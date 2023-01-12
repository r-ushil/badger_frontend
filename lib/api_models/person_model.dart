// import 'badger-api/leaderboard/v1/leaderboard_api.pbgrpc.dart';
// import 'package:badger_frontend/api_models/api_client_channel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:grpc/grpc.dart';

// class Person {
//   String id;
//   String name;
//   int score;

//   Person({required this.id, required this.name, required this.score});
// }

// class PersonModel {
//   static final personServiceClient = LeaderboardServiceClient(
//       ApiClientChannel.getClientChannel(),
//       options: CallOptions(timeout: const Duration(minutes: 1)));

//   static Future<Person> getPerson() async {
//     String uid = FirebaseAuth.instance.currentUser!.uid;

//     final req = GetPersonRequest();
//     try {
//       final res = await personServiceClient.getPerson(req,
//           options: CallOptions(metadata: {"authorization": uid}));
//       final person = Person(
//         id: res.person.id,
//         name: res.person.name,
//         score: res.person.score,
//       );
//       return person;
//     } catch (e) {
//       rethrow;
//       //TODO: error handling
//     }
//   }

//   static Future<List<Person>> getPeopleData() async {
//     List<Person> people = List.empty(growable: false);
//     final req = GetPeopleRequest();
//     try {
//       final res = await personServiceClient.getPeople(req);
//       people = res.people
//           .map((person) => Person(
//             id: res.person.id,
//             name: res.person.name,
//             score: res.person.score))
//           .toList();
//     } catch (e) {
//       rethrow;
//       //TODO: error handling
//     }
//     return people;
//   }
// }
