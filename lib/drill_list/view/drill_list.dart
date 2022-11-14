import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<List<DisplayableDrill>>(
          future: _drillData,
          builder: (BuildContext context,
              AsyncSnapshot<List<DisplayableDrill>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                Column(
                  children: [
                    const Text("Choose your drill!"),
                    Expanded(
                        child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(height: 10),
                            padding: const EdgeInsets.all(7),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return DrillCard(drill: snapshot.data![index]);
                            }))
                  ],
                ),
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
      ),
    );
  }
}
