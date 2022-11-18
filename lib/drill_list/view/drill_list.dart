import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
import 'package:badger_frontend/drill_list/view/widgets/drill_card.dart';
import 'package:flutter/material.dart';

class DrillList extends StatefulWidget {
  const DrillList({super.key});

  @override
  State<DrillList> createState() => _DrillList();
}

class _DrillList extends State<DrillList> {
  final Future<List<DisplayableDrill>> _drillData =
      DrillListViewModel.getDisplayableDrills();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<DisplayableDrill>>(
        future: _drillData,
        builder: (context, snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/drill_list_banner3.webp"),
                        fit: BoxFit.cover)),
                child: Container(
                    height: 50,
                    width: 300,
                    padding: const EdgeInsets.only(left: 8),
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(50)),
                        color: Colors.green),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Choose your drill!".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ))),
              ),
              Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      padding: const EdgeInsets.all(7),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return DrillCard(drill: snapshot.data![index]);
                      }))
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(color: Colors.white)),
            ];
          }
          return Center(
            child: Column(
              children: children,
            ),
          );
        },
      ),
    );
  }
}
