import 'package:flutter/material.dart';
import 'package:x/main.dart';

class NewMessage extends StatefulWidget {
  Function setStateForDrawer;
  NewMessage(this.setStateForDrawer);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

int hrs = TimeOfDay.now().hour;
int? min = TimeOfDay.now().minute;

class _NewMessageState extends State<NewMessage> {
  void _showAlertDialog(BuildContext context) async {
    TextEditingController messageController = TextEditingController();
    TimeOfDay? selectedTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: messageController,
                decoration: InputDecoration(labelText: 'Enter Message'),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Text('Select Time: '),
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        if (pickedTime != null) {
                          selectedTime = pickedTime;
                          print(selectedTime);
                        } else {
                          print(selectedTime);
                        }
                      });
                    },
                    child: Text(
                      "Set time",
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
                print('Message: $message, Time: $time');

                Map addToMap = {"Id": 1000, "Message": message, "Timing": time};
                if (mapOfMessage!.containsKey(currentSubdirectory)) {
                  mapOfMessage![currentSubdirectory]!.add(addToMap);
                } else {
                  mapOfMessage![currentSubdirectory] = [addToMap];
                }
                await widget.setStateForDrawer(universalCount);
                print("map hai kya");
                print(mapOfMessage);
                setState(() {
                  selectedTime;
                });
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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Color(0xC6433AD6),
        size: 24,
      ),
      onPressed: () {
        _showAlertDialog(context);
      },
    );
  }
}

class NewSubdirectory extends StatelessWidget {
  Function setStateForSubdirectory;

  NewSubdirectory(this.setStateForSubdirectory);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _ShowAlertDialog(context);
      },
      icon: Icon(Icons.add, size: 40, color: Colors.white24),
    );
  }

  void _ShowAlertDialog(BuildContext context) async {
    TextEditingController messageController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Subdirectory'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: messageController,
                decoration: InputDecoration(labelText: 'Enter Message'),
              ),
              SizedBox(height: 20),
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
                setStateForSubdirectory(message);
                Navigator.pop(context);
                //  }
                // Close the dialog
                //Navigator.of(context).pop();
              },
              child: Text('Set Subdirectory'),
            ),
          ],
        );
      },
    );
  }
}
