import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'badger';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection('people').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Expanded(child: ListView(
              children: (snapshot.data!).docs.map((document) {
                return Container(
                  child: Center(child: Text(document['name'])),
                );
              }).toList(),
            ));
          },
        ),
        Center(
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('people')
                  .add({'name': 'data added through app'});
            },
          ),
        ),
      ],
    );
  }
}

class ReadData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("geeksforgeeks"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('people').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: (snapshot.data!).docs.map((document) {
              return Container(
                child: Center(child: Text(document['name'])),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class AddData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("geeksforgeeks"),
      ),
      body:Center(
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('people')
                .add({'name': 'data added through app'});
          },
        ),
      ),
    );
  }
}