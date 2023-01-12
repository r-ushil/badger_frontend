import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api_models/badger-api/leaderboard/v1/leaderboard.pb.dart';
import '../api_models/leaderboard_model.dart';
import '../common/auth/auth_model.dart';
import '../drill_list/view/drill_list.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<BadgerAuth>(context);

    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 10, top: 50),
                    width: (MediaQuery.of(context).size.width - 20) / 2,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Overview"))),
                Container(
                    margin: const EdgeInsets.only(right: 10, top: 50),
                    width: (MediaQuery.of(context).size.width - 20) / 2,
                    child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 3),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            backgroundColor: Colors.green.withOpacity(0.5),
                            foregroundColor: Colors.white),
                        child: const Text("Leaderboard"))),
              ],
            ),
            leaderboardList(context),
          ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_circle, size: 60),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const DrillList())); //TODO: change implementation
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: const Color.fromRGBO(64, 235, 133, 50),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.home, color: Colors.white)),
                IconButton(
                    onPressed: () async {
                      await auth.logout();
                    },
                    icon: const Icon(Icons.logout, color: Colors.white)),
              ])),
    );
  }
}

leaderboardList(BuildContext context) {
  final topPlayers = TopPlayersModel.getTopPlayers(5);

  return FutureBuilder<List<Player>>(
      future: topPlayers,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {

          // Sort the players by score in reverse order
          snapshot.data!.sort((a, b) => b.score.compareTo(a.score));

          return Center(
              child: Column(
            children: [
              const SizedBox(
                  width: 60,
                  height: 60,
              ),
              const Text("Leaderboard", style: TextStyle(color: Colors.white, fontSize: 25)),
              const SizedBox(
                  width: 60,
                  height: 60,
              ),
              for (var player in snapshot.data!)
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('${player.name}: ${player.score}', style: const TextStyle(color: Colors.white, fontSize: 20)))
            ],
          ));
        }
        return Center(
          child: Column(
            children: const <Widget>[
              SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(color: Colors.white)),
            ],
          ),
        );
      }));
}
