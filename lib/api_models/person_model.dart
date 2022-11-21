import 'package:badger_frontend/api_models/badger-api/person/v1/person_api.pbgrpc.dart';
import 'package:badger_frontend/api_models/api_client_channel.dart';
import 'package:grpc/grpc.dart';

class PersonData {
  String userId;
  int userScore;
  String firebaseId;
  int userPowerScore;
  int userTimingScore;
  int userAgilityScore;

  PersonData(this.userId, this.userScore, this.firebaseId, this.userPowerScore, this.userTimingScore, this.userAgilityScore);
}

class PersonModel {
  static final personServiceClient = PersonServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

  static Future<PersonData> getPersonData(String userId) async {
    final req = GetPersonRequest(personId: userId);
    try {
      final res = await personServiceClient.getPerson(req);
      final person = PersonData(
          res.person.userId, res.person.userScore, res.person.firebaseId, res.person.userPowerScore, res.person.userTimingScore, res.person.userAgilityScore);
      return person;
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
  }

  static Future<List<PersonData>> getPeopleData() async {
    List<PersonData> people = List.empty(growable: false);
    final req = GetPeopleRequest();
    try {
      final res = await personServiceClient.getPeople(req);
      people = res.people
          .map((person) =>
              PersonData(person.userId, person.userScore, person.firebaseId, person.userPowerScore, person.userTimingScore, person.userAgilityScore))
          .toList();
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return people;
  }
}
