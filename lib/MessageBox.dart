import 'package:flutter/material.dart';
import 'package:x/EmptyDisplay.dart';

//import 'package:http/http.dart' as http;
import 'package:x/main.dart';

class MessageBox extends StatefulWidget {
  List? singleMessageList;
  Function setStateForDrawer;
  Function callSetState;
  dynamic snapshot;
  MessageBox(this.singleMessageList, this.setStateForDrawer, this.callSetState,
      this.snapshot);

  @override
  State<MessageBox> createState() => _messageBoxState();
}

class _messageBoxState extends State<MessageBox> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();

    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    if (ListOfMessageOfSelectedDirectory == null) {
      return containerListForInitialAndOther(widget.singleMessageList);
    }
    print("heroic");
    return containerListForInitialAndOther(ListOfMessageOfSelectedDirectory);
    // return (ListOfMessageOfSelectedDirectory);
  }

  Widget containerListForInitialAndOther(List? singleMsgList) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: singleMsgList!.length,

        //!HANDLE FOR NULL TYO CHAI JUST HAVE A DIFFERENT PAGE STRAIGHT MAI .

        itemBuilder: (context, index) {
          return Align(
            alignment: AlignmentDirectional(-1, -1),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {
                    _showAlertDialog(context, singleMsgList, index);
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        mapOfMessage![currentSubdirectory].removeAt(index);
                        print("whatttttt!!!!!!!!!!!!!!!!!!!!!!!!!!");

                        listOfSubdirectory;
                      });
                      widget.callSetState(widget.snapshot);
                    },
                    background: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.red,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete, color: Colors.white)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
                            child: Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(2),
                                      topRight: Radius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                              child: Checkbox(
                                value: false,
                                onChanged: null,
                                side: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 132, 36, 241),
                                ),
                                activeColor: Colors.red,
                                checkColor: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 10, 0, 10),
                                    child: Text(
                                      singleMsgList[index]["Message"],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 25,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 0, 0, 10),
                                  child: Text(
                                    singleMsgList[index]["Timing"],
                                    style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 18,
                                        letterSpacing: 0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(1, 0),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Icon(
                                Icons.delete_sweep,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAlertDialog(
      BuildContext context, List? singleMsgList, int index) async {
    TextEditingController messageController =
        TextEditingController(text: singleMsgList![index]["Message"]);
    int hrs = TimeOfDay.now().hour;
    int? min = TimeOfDay.now().minute;
    List listOfTime = singleMsgList![index]["Timing"].toString().split(":");
    selectedTime = TimeOfDay(
        hour: int.parse(listOfTime[0]), minute: int.parse(listOfTime[1]));

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: messageController,
                decoration: InputDecoration(),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Text('Select Time: '),
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );

                      if (pickedTime != null) {
                        setState(() {
                          setState(() {
                            selectedTime = pickedTime;
                            hrs = selectedTime.hour;
                            min = selectedTime.minute;
                          });
                        });
                      }
                    },
                    child: Text(
                      "$hrs:$min",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Process the entered message and selected time here
                String message = messageController.text;
                String time = "${selectedTime!.hour}:${selectedTime!.minute}";

                Map replaceInMap = {
                  "Id": 1000,
                  "Message": message,
                  "Timing": time
                };

                mapOfMessage![currentSubdirectory][index] = replaceInMap;

                await widget.setStateForDrawer(universalCount);
                print("map hai kya");
                print(mapOfMessage);
                //  }
                // Close the dialog
                //Navigator.of(context).pop();
              },
              child: Text('Set Reminder'),
            ),
          ],
        );
      },
    );
  }
}
