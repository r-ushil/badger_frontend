import 'package:badger_frontend/drill_list/view-model/drill_view_model.dart';
import 'package:badger_frontend/drill_list/model/drill_model.dart';
import 'package:badger_frontend/drill_list/view/widgets/drill_card.dart';
import 'package:flutter/material.dart';

class DrillList extends StatelessWidget {
  const DrillList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Drill List Widget",
      home: StatefulDrillList(),
    );
  }
}

class StatefulDrillList extends StatefulWidget {
  const StatefulDrillList({super.key});

  @override
  State<StatefulDrillList> createState() => _StatefulDrillList();
}

class _StatefulDrillList extends State<StatefulDrillList> {
  final Future<List<DisplayableDrill>> _drillData =
      DrillViewModel.getDisplayableDrills();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<List<DisplayableDrill>>(
        future: _drillData,
        builder: (BuildContext context,
            AsyncSnapshot<List<DisplayableDrill>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return DrillCard(drill: snapshot.data![index]);
                      })),
              Material(
                  color: Colors.black,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ))
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
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
