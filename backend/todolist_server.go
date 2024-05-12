package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/go-chi/chi/v5"
	_ "github.com/go-sql-driver/mysql"
)

type returnId struct{
	Id int;
	
}



	type Putdataedited struct{
		returnId
		EditedMsg string `json:"data"`
		Time string `json:"Timing"`
	}
	


type Postsubdirectory struct{
	
	Subdirectory string 	`json:"Subdirectory"`
}
type Getlistofmsg struct{
	Timing []byte;
	Message string 
	Id int   `json:"Id"`
}

type Postdata struct{
Postsubdirectory ;
Data string;
Timing string;
}




func unique_id(db *sql.DB)  (c int) {
	var count sql.NullInt64;
	row:=db.QueryRow("select max(Id) from todolist;");
	
	row.Scan(&count);
if !count.Valid{
	c=1;
	return ;
}
	c=int(count.Int64)+1;
	return ;
}
//!CORSmiddleware() middleware function
func CORSmiddleware(next http.Handler) http.Handler{

return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	next.ServeHTTP( w,r);
})

};

//! ==========JSON TO STRUCT =======================

func JSONtoStruct(structtype interface{},r *http.Request)  {
	fmt.Print("tapai jsontostruct bhitra hunuhuncha");
	subdir_read:=io.NopCloser(r.Body);
	subdirectoryJSON,err:=io.ReadAll(subdir_read);

	defer subdir_read.Close() 

	
	json.Unmarshal(subdirectoryJSON,structtype); 
	fmt.Print(structtype);
	
	if err!=nil{
        fmt.Print("subdir_read bata data fetch bhaena in postdirectory");
	
    }
	
	
}

//? this function receive data : {"subdirectory":textfield.text } 
//? should this be used to return subdir for listing the subdir??? 

//! ==========START /POSTSUBDIRECTORY =======================
func postsubdirectory(db *sql.DB, w http.ResponseWriter, r *http.Request){

//?thi function is required if user just creates empty directory and while searching atleast I want empty subdir to be displayed tetti ko lagi ni i want null thing to be displayed.

//! also i will have to check this field along with fields data,......are null or not to prevent same 2 diff subdir with same name  . not valid bhanera dekhaucha. 
 var sub_directory Postsubdirectory; 

   id:=unique_id(db);
  JSONtoStruct(&sub_directory,r);
 
 

	


data,err:=db.Prepare("insert into todolist(Id,Subdirectory) values(?,?);")

if err!=nil{
	fmt.Print("insert garda probelm inn todolist from postsubdirectory");
    return;
}
;


_,er:=data.Exec(id,sub_directory.Subdirectory);
if er!=nil{
	fmt.Print("execute garda problem inn todolist from postsubdirectory");
    return;
}
 //return_Id :=returnId{Id:id};

fmt.Print("this is the struct")
// fmt.Print("\n\n\n")
// JSON,_:= json.Marshal(return_Id);
// w.Write(JSON);


	
}
//! ==========END /POSTSUBDIRECTORY =======================

//! ==========start /postdata=======================
func postdata(db *sql.DB,w http.ResponseWriter, r *http.Request){
	//? gets the data from client:    {
		//?	                             "Subdirectory":"subdir",
		//?                           "Data": " ................",
		//?                           "Timing": " ................",
		//?                               };
		id:=unique_id(db);
		var return_Id returnId;
		var postdata Postdata;
		JSONtoStruct(&postdata,r);
		
		
		
		
		data,_:=db.Prepare("insert into todolist(Id,Subdirectory,Data,Timing) values(?,?,?,?);");
		data.Exec(id,postdata.Subdirectory,postdata.Data,postdata.Timing);
		return_Id=returnId{Id: id};
		jsonid,_:=json.Marshal(return_Id);
		//fmt.Print(return_Id);
		w.Write(jsonid);
	}
	//! ==========end /postdata=======================
	
	
	//! ==========/putdataedited           =======================
	
	
	func putdataedited(db *sql.DB,_ http.ResponseWriter,r *http.Request){
		fmt.Print("chalyo chalyo wow");
		fmt.Print("\n");
		//? gets the data from client: 
		//?                        {
			//?                                 "Id":12,
			//?                           "editedMsg": " ................"
			//?                               };
			var comparedata Putdataedited;
			var timebyte []byte;
			JSONtoStruct(&comparedata,r);
			timebyte=[]byte(comparedata.Time);
			result,_:=db.Prepare("update todolist set Data=?,Timing=? where Id=?;");
			result.Exec(comparedata.EditedMsg,timebyte,comparedata.Id);
			
			
			
		}
		//! ==========/putdataedited           =======================
		
		
	
	
	
	
	
	
	
	
	
	
	//! ========== /getlistofsubdirectory  =======================
	func getlistofsubdirectory(db *sql.DB,w http.ResponseWriter,_ *http.Request){
		
            //?    RETURNS : [{"Subdirectory":"jello"},{"Subdirectory":""}]
            var comparedata Postsubdirectory;
			var sliceofsubdirectory []string;
          rows,_:= db.Query("select Subdirectory from todolist;")
		defer rows.Close();
			
			 for rows.Next(){

				rows.Scan(&comparedata.Subdirectory);
			
				sliceofsubdirectory=append(sliceofsubdirectory,comparedata.Subdirectory);
			}

			JSONslice,_:=json.Marshal(sliceofsubdirectory);
			w.Write(JSONslice);
		  

           // defer db.Close();
            
            
        }
        //! ==========end  /getlistofsubdirectory =======================






        //! ==========start  /getlistofmessage            =======================
        
		func  getlistofmsg(db *sql.DB,w http.ResponseWriter,r *http.Request){
			//? subdirectory name sent here.{subdirectory: "hello "}
			var msginsubdirectory Postsubdirectory; 
			var strtime string;
			var strid string;
listofmsg :=[]map[string]string{} ;
JSONtoStruct(&msginsubdirectory,r)

rows,_:=db.Query("SELECT Id,Data,Timing from todolist where Subdirectory=?;",msginsubdirectory.Subdirectory)
for rows.Next(){
				var eachmsg Getlistofmsg;
				rows.Scan(&eachmsg.Id,&eachmsg.Message,&eachmsg.Timing);
			strtime=string(eachmsg.Timing);
			strid=fmt.Sprintf("%d",eachmsg.Id);
				if (string(strtime)!=""){

					msgmap:=map[string]string{"Message":eachmsg.Message,
					"Id":strid,
					"Timing":strtime}
					listofmsg=append(listofmsg,msgmap);
				}
				
			}
			
			JSONlist,_:=json.Marshal(listofmsg);
			
			w.Write(JSONlist);
		}
		
		
		
		
		//! ==========end of  /getlistofmsg            =======================




//! ==========start of  /putcomplete =======================
func putcompleteontick(db *sql.DB,w http.ResponseWriter,r *http.Request){
  //?get the id from client , 
  
  var toggle returnId;
JSONtoStruct(&toggle,r);

db.Query("update todolist set Completed_or_not=true where Id=? ;", toggle.Id);
}

//! ==========end of  /putcomplete =======================


//! ==========start of  /deletemsg =======================

func deletemsg(db *sql.DB,_ http.ResponseWriter,r *http.Request){
	//?get id from client
	var deleteid returnId;
    JSONtoStruct(&deleteid,r);
    db.Query("delete from todolist where Id=?;",deleteid.Id);
   
  //  defer db.Close();
}
//! ==========end of  /deletemsg =======================
//! ==========start of  /deletemsg =======================

func deletesubdirectory(db *sql.DB,w http.ResponseWriter,r *http.Request){
	//?get id from client
	var deleteid Postsubdirectory;
    JSONtoStruct(&deleteid,r);
    db.Query("delete from todolist where Subdirectory=?;",deleteid.Subdirectory);
   
   // defer db.Close();
}
//! ==========end of  /deletemsg =======================



func main(){
		todolist_router:=chi.NewRouter();
		

db_username:=os.Getenv("DB_USERNAME");

db_password:=os.Getenv("DB_PASSWORD");

db_port:=os.Getenv("DB_PORT");


db_datasource:=fmt.Sprintf("%s:%s@tcp(localhost:%s)/todo_listdb",db_username,db_password,db_port);
db,err:=sql.Open("mysql",db_datasource);
if err!=nil{
fmt.Print("mysql ma error aayo.  ");
}
defer db.Close(); 

//?==================================================================

todolist_router.Post("/postsubdir",func(w http.ResponseWriter, r *http.Request) {

	
	postsubdirectory(db,w,r);
})
todolist_router.Post("/postdata",func(w http.ResponseWriter, r *http.Request) {
	postdata(db,w,r);
});
todolist_router.Post("/putdataedited",func(w http.ResponseWriter, r *http.Request) {
	putdataedited(db,w,r);
});
todolist_router.Get("/getlistofsubdirectory",func(w http.ResponseWriter, r *http.Request) {
	getlistofsubdirectory(db,w,r);
});
todolist_router.Post("/getlistofmessage",func(w http.ResponseWriter, r *http.Request) {
	getlistofmsg(db,w,r);
});

todolist_router.Put("/putcompleteontick",func(w http.ResponseWriter, r *http.Request) {

	putcompleteontick(db,w,r);

})
todolist_router.Post("/deletemessage",func(w http.ResponseWriter, r *http.Request) {
	fmt.Print("hello delete");

	deletemsg(db,w,r);

})
todolist_router.Post("/deletesubdirectory",func(w http.ResponseWriter, r *http.Request) {

	deletesubdirectory(db,w,r);

})




//?=======================================dont touch below this line
http.ListenAndServe(":8000",CORSmiddleware(todolist_router));



}