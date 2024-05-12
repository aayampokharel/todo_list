import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:x/EmptyDisplay.dart';
import 'package:x/MessageBox.dart';
import 'package:http/http.dart' as http;
import 'package:x/newMessage.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List? listOfSubdirectory = [];
Map? mapOfMessage =
    {}; //! [{Id: 6, Message: additional example, Timing: 12:00:00}]
var ListOfMessageOfSelectedDirectory;
String? currentSubdirectory = null;
int universalCount = 0;

class _MyHomePageState extends State<MyHomePage> {
  var x;
  var y;
  String displayText = "";

  //!=========================
  Future? getListOfSubdirectory() async {
    var response = await http
        .get(Uri.parse("http://localhost:8000/getlistofsubdirectory"));

    return jsonDecode(response.body).toSet().toList();
  }

  Future? getSingleListOfMessage({String? subdirectory}) async {
    if (subdirectory == null) {
      //!  this is wrong as check if there is duplication or not in th e
      listOfSubdirectory = await getListOfSubdirectory();
      subdirectory = listOfSubdirectory![0];
    }
    // print("list of subdir from getsingle list of message");
    // print(listOfSubdirectory);

    Map jsons = {"Subdirectory": subdirectory};
    // print("jsons:");
    // print(jsons);

    if (listOfSubdirectory != null) {
      var value = await http.post(
          Uri.parse("http://localhost:8000/getlistofmessage"),
          body: jsonEncode(jsons));

      mapOfMessage![subdirectory] = jsonDecode(value.body).toSet().toList();
      // print("map");
      // print(mapOfMessage);
    }

    ///!

    displayText = mapOfMessage![subdirectory].toString();
    print("brother==================");
    print(mapOfMessage![subdirectory].toString());

    return mapOfMessage![subdirectory];
  }

  Future? getOtherListOfMessage() async {
    // print("below is list of subdir");
    // print(listOfSubdirectory);
    // await Future.delayed(Duration(seconds: 10), () => 2);
    if (listOfSubdirectory != null && listOfSubdirectory!.length > 0) {
      for (int i = 1; i < listOfSubdirectory!.length; i++) {
        Map jsons = {"Subdirectory": listOfSubdirectory![i].toString()};
        // print("jsons domain tenkai");
        // print(jsons);
        // print("printing jsons");
        // print(jsons);

        // !this  function receives in thiis format:
        // !{"Message":eachmsg.Message,
        // !			"Id":strid,
        // !			"Timing":strtime}

        var value = await http.post(
            Uri.parse("http://localhost:8000/getlistofmessage"),
            body: jsonEncode(jsons));
        // print(await jsonDecode(value.body));
        mapOfMessage![listOfSubdirectory![i]] = jsonDecode(value.body);
      }

      //print(mapOfMessage);
      return mapOfMessage!;
    }
  }

  @override
  void initState() {
    x = getSingleListOfMessage()!.then((value) {
      getOtherListOfMessage()!.then((values) => y = values);
      currentSubdirectory = listOfSubdirectory![0];
      return value;
    });
    //  getListOfMessage();
  }

  setStateForText(String value) {
    setState(() {
      // print("===value---");
      // print(value);
      // print("===value---");
      displayText = value;
    });
  }

  setStateForDrawer(int count) async {
    universalCount = count;
    if (mapOfMessage != null &&
        mapOfMessage!.containsKey(listOfSubdirectory![count])) {
      print("map map");
      var xx = mapOfMessage![listOfSubdirectory![count]];

      //  selectedSubdirectory =
      ListOfMessageOfSelectedDirectory = xx;
      print("============");
      setStateForText(xx.toString());
    } else {
      print("not map");
      var xx = await getSingleListOfMessage(
          subdirectory: listOfSubdirectory![count]);
      ListOfMessageOfSelectedDirectory = xx;
      print("============");
      setStateForText(xx.toString());
    }
    currentSubdirectory = listOfSubdirectory![count];
    setState(() {
      ListOfMessageOfSelectedDirectory;
      currentSubdirectory;
    });
    print("are bhai bhai abhai");
    print(currentSubdirectory);
    Navigator.pop(context);
  }

  setStateForSubdirectory(String subdirectory) {
    setState(() {
      listOfSubdirectory!.add(subdirectory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Color(0xC6433AD6),
            title: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(26),
                child: Text(
                  'TO DO APP',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            centerTitle: false,
            elevation: 2,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xC6433AD6).withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 4, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: Offset(0, 3), //
                    )
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Your\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Sub directories',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: NewSubdirectory(setStateForSubdirectory),
                      )
                    ],
                  ),
                ),
              ),

              FutureBuilder(
                  future: x,
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.done) {
                      return Container(
                          color: Colors.white10,
                          height: 300,
                          child: ListView.builder(
                              itemCount: listOfSubdirectory?.length ?? 0,
                              itemBuilder: (context, count) {
                                return Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    setState(() {
                                      listOfSubdirectory!.removeAt(count);
                                      mapOfMessage!
                                          .remove(listOfSubdirectory![count]);
                                    });
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      setStateForDrawer(count);
                                    },
                                    child: ListTile(
                                        title: Text(listOfSubdirectory![count]
                                            .toString())),
                                  ),
                                );
                              }));
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
              // Add more ListTile widgets for additional items
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xC6433AD6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xC6433AD6), // Border color
                              width: 1, // Border width
                            ),
                            borderRadius:
                                BorderRadius.circular(12), // Border radius
                            color: Color.fromARGB(255, 211, 204, 243),
                            // Fill color
                          ),
                          width: 40, // Button size
                          height: 40, // Button size
                          child: NewMessage(setStateForDrawer),
                        )),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x2B000000),
                              offset: Offset(
                                0,
                                2,
                              ),
                            )
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: SelectionArea(
                            child: Text(
                              DateFormat('d MMMM').format(DateTime.now()),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                      child: Icon(
                        Icons.settings_outlined,
                        color: Color(0xFFECECEC),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                // color: Colors.transparent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 71,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(
                          0,
                          2,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                    shape: BoxShape.rectangle,
                  ),
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: FutureBuilder(
                        future: x,
                        builder: (context, snapshot) {
                          return Text(
                            currentSubdirectory.toString(),
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 34,
                              letterSpacing: 0,
                            ),
                          );
                        }),
                  ),
                ),
              ),
              FutureBuilder(
                future: x,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return Column(
                    children: [
                      // container(setStateForText, getSingleListOfMessage),
                      insideColumn(snapshot)
                    ],
                  );
                },
              ),
            ],
          ),
        ));
  }

  callSetState(snapshot) {
    setState(() {
      mapOfMessage;
      insideColumn(snapshot);
    });
  }

  Widget insideColumn(snapshot) {
    if (mapOfMessage![currentSubdirectory].length == 0) {
      print("brother is good ");
      return empty_display();
    } else {
      return Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: MessageBox(
              snapshot.data, setStateForDrawer, callSetState, snapshot));
    }
  }
}
