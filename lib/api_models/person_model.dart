import 'package:badger_frontend/api_models/badger-api/person/v1/person_api.pbgrpc.dart';
import 'package:badger_frontend/api_models/api_client_channel.dart';
import 'package:grpc/grpc.dart';

class PersonData {
  String userId;
  int userScore;
  String firebaseId;

  PersonData(this.userId, this.userScore, this.firebaseId);
}

class PersonModel {
  static final personServiceClient = PersonServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

  Future<PersonData> getPersonData(String userId) async {
    final req = GetPersonRequest(personId: userId);
    PersonData person = PersonData("dummy", 0, "dummy");
    try {
      final res = await personServiceClient.getPerson(req);
      person = PersonData(
          res.person.userId, res.person.userScore, res.person.firebaseId);
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return person;
  }

  static Future<List<PersonData>> getPeopleData() async {
    List<PersonData> people = List.empty(growable: false);
    final req = GetPeopleRequest();
    try {
      final res = await personServiceClient.getPeople(req);
      people = res.people
          .map((person) =>
              PersonData(person.userId, person.userScore, person.firebaseId))
          .toList();
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return people;
  }
}
