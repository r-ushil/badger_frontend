import 'package:badger_frontend/api_models/api_client_channel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grpc/grpc.dart';

import 'badger-api/drill_submission/v1/drill_submission_api.pbgrpc.dart';

class DrillSubmissionData {
  final String userId;
  final String drillId;
  final String bucketUrl;
  final Timestamp timestamp;
  final String processingStatus; //TODO: necessary?
  final int drillScore;

  DrillSubmissionData(this.userId, this.drillId, this.bucketUrl, this.timestamp,
      this.processingStatus, this.drillScore);
}

class DrillSubmissionModel {
  static final drillSubmissionServiceClient = DrillSubmissionServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

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
              drillSubmission.timestamp,
              drillSubmission.processingStatus,
              drillSubmission.drillScore))
          .toList();
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return drills;
  }

  static Future<List<DrillSubmissionData>> getUserDrillSubmissionsData(String userId) async {
    List<DrillSubmissionData> drills = List.empty(growable: false);
    final req = GetUserDrillSubmissionsRequest(userId: userId);
    try {
      final res = await drillSubmissionServiceClient.getUserDrillSubmissions(req);
      drills = res.drillSubmissions
          .map((drillSubmission) => DrillSubmissionData(
              drillSubmission.userId,
              drillSubmission.drillId,
              drillSubmission.bucketUrl,
              drillSubmission.timestamp,
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
        DrillSubmissionData("0", "dummy", "dummy", Timestamp(0, 0), "dummy", 0);
    final req = GetDrillSubmissionRequest(drillSubmissionId: submissionId);
    try {
      final res = await drillSubmissionServiceClient.getDrillSubmission(req);
      drillSubmission = DrillSubmissionData(
          res.drillSubmission.userId,
          res.drillSubmission.drillId,
          res.drillSubmission.bucketUrl,
          res.drillSubmission.timestamp,
          res.drillSubmission.processingStatus,
          res.drillSubmission.drillScore);
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return drillSubmission;
  }
}
