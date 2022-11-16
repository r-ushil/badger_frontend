import 'package:badger_frontend/api_models/api_client_channel.dart';
import 'package:badger_frontend/api_models/badger-api/drill_submission/v1/drill_submission_api.pbgrpc.dart';
import "package:badger_frontend/api_models/badger-api/drill_submission/v1/drill_submission.pb.dart";
import 'package:badger_frontend/api_models/badger-api/google/type/datetime.pb.dart'
    as google_date_time;
import 'package:grpc/grpc.dart';

class DrillSubmissionData {
  final String userId;
  final String drillId;
  final String bucketUrl;
  final DateTime timestamp;
  final String processingStatus; //TODO: necessary?
  final int drillScore;

  DrillSubmissionData(this.userId, this.drillId, this.bucketUrl, this.timestamp,
      this.processingStatus, this.drillScore);
}

class DrillSubmissionModel {
  static DateTime convertFromGoogleDateTime(
      google_date_time.DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hours,
      dateTime.minutes,
      dateTime.seconds,
    );
  }

  static google_date_time.DateTime convertToGoogleDateTime(DateTime dateTime) {
    return google_date_time.DateTime(
        year: dateTime.year,
        month: dateTime.month,
        day: dateTime.day,
        hours: dateTime.hour,
        minutes: dateTime.minute,
        seconds: dateTime.second);
  }

  static final drillSubmissionServiceClient = DrillSubmissionServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

  static void submitDrill(DrillSubmissionData data) async {
    final req = InsertDrillSubmissionRequest(
        drillSubmission: DrillSubmission(
            userId: data.userId,
            drillId: data.drillId,
            bucketUrl: data.bucketUrl,
            timestamp: convertToGoogleDateTime(data.timestamp),
            processingStatus: data.processingStatus,
            drillScore: data.drillScore));
    try {
      await drillSubmissionServiceClient.insertDrillSubmission(req);
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    
  }

  static Future<List<DrillSubmissionData>> getDrillSubmissionsData() async {
    List<DrillSubmissionData> drills = List.empty(growable: false);
    final req = GetDrillSubmissionsRequest();
    try {
      final res = await drillSubmissionServiceClient.getDrillSubmissions(req);
      drills = res.drillSubmissions
          .map((drillSubmission) => DrillSubmissionData(
              drillSubmission.userId,
              drillSubmission.drillId,
              drillSubmission.bucketUrl,
              convertFromGoogleDateTime(drillSubmission.timestamp),
              drillSubmission.processingStatus,
              drillSubmission.drillScore))
          .toList();
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return drills;
  }

  static Future<List<DrillSubmissionData>> getUserDrillSubmissionsData(
      String userId) async {
    List<DrillSubmissionData> drills = List.empty(growable: false);
    final req = GetUserDrillSubmissionsRequest(userId: userId);
    try {
      final res =
          await drillSubmissionServiceClient.getUserDrillSubmissions(req);
      drills = res.drillSubmissions
          .map((drillSubmission) => DrillSubmissionData(
              drillSubmission.userId,
              drillSubmission.drillId,
              drillSubmission.bucketUrl,
              convertFromGoogleDateTime(drillSubmission.timestamp),
              drillSubmission.processingStatus,
              drillSubmission.drillScore))
          .toList();
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return drills;
  }

  static Future<DrillSubmissionData> getDrillSubmissionData(
      String submissionId) async {
    DrillSubmissionData drillSubmission =
        DrillSubmissionData("0", "dummy", "dummy", DateTime(0), "dummy", 0);
    final req = GetDrillSubmissionRequest(drillSubmissionId: submissionId);
    try {
      final res = await drillSubmissionServiceClient.getDrillSubmission(req);
      drillSubmission = DrillSubmissionData(
          res.drillSubmission.userId,
          res.drillSubmission.drillId,
          res.drillSubmission.bucketUrl,
          convertFromGoogleDateTime(res.drillSubmission.timestamp),
          res.drillSubmission.processingStatus,
          res.drillSubmission.drillScore);
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return drillSubmission;
  }
}
