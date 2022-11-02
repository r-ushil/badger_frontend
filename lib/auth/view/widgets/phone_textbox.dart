import 'package:flutter/material.dart';

class PhoneTextbox extends StatelessWidget {
  const PhoneTextbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: const <Widget>[
          Padding(padding: EdgeInsets.only(right: 150.0),
              child: Text("Phone Number",
                           style: TextStyle(fontSize: 20,
                                            color: Colors.grey
                           )
              )
          ),
          SizedBox(height: 10), // margin before textbox
          SizedBox(width: 300,
              child: TextField(
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(prefixIcon: Icon(Icons.phone,
                                                          color: Colors.grey),
                                              filled: true,
                                              fillColor: Colors.white12
                  )
              )
          ),
    ]);
  }
}
