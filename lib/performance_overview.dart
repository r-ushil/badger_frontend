import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PerformanceOverview extends StatelessWidget {
  const PerformanceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    Widget title = const Padding(
      padding: EdgeInsets.all(32),
      child: Text('History',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badger'),
        backgroundColor: Colors.red[200],
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: Column(
        children: [
          Center(child: title),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('drills').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: (snapshot.data!).docs.map((document) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(document['name']),
                        Text(DateFormat('dd/MM/yyyy, HH:mm')
                            .format(document['timestamp'].toDate())),
                        Text(document['score'].toString())
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
