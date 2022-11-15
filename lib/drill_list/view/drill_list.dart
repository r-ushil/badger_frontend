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
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(50)),
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
                        itemBuilder: (BuildContext context, int index) {
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
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }
}
