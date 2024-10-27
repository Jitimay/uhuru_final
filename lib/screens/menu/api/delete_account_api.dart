import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uhuru/screens/menu/utils/logout.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/variables.dart';

class DeleteAccount extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<dynamic> deleteAccountApi(phone, context) async {

    try {
      final response = await dioConfig.dio.delete(
          '${Environment.host}/users/$phone/',
          options: Options(
              headers: Variables.headers
          )
      );
      if(response.statusCode == 200 || response.statusCode == 204){
        debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
        debugPrint('REQUEST SUCCESSFUL----------->${response.data}');
        showSnackBar(content: "Account Deleted", context: context);

          Variables.fullName.clear();
          Variables.bio.clear();

          Variables.avatar=null;
          Variables.videoId=null;
          Variables.storyList=[];

          ///String
          Variables.token = "";
          Variables.countryName = "";
          Variables.countryIso = "";
          Variables.countryCode = "";
          Variables.phoneNumber = "";
          Variables.fullNameString = "";
          Variables.bioString = "";

          ///int
          Variables.id = 0;
          Variables.commentIndex = 0;

          ///List
          Variables.contacts = [];
          Variables.videoList = [];
          Variables.filteredVideos = [];
          Variables.postedVideos = [];
          Variables.ownStoryList = [];
          Variables.friendsStoryList;
          Variables.storyGroupedByPhone = [];
          Variables.friendsGroupedByPhone = [];
          Variables.videoCommentList = [];
          Variables.groupedCommentList = [];
          Variables.childCommentList = [];
          Variables.storyViewList = [];

        await logout(context);
        if (response.data is List<dynamic>) {
          return response.data;
        } else {
          return [{'response':'${response.data}'}];// Handle other data types (e.g., log an error or throw an exception)
        }
      } else {
        debugPrint('REQUEST FAILED----------->${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        print('DATA===========>${response.data}');
        if(response.data != null){
          Variables.dioResponseExceptionData = response.data;
          print('RESPONSEDETAILS===========>${Variables.dioResponseExceptionData['detail']}');
          print('TOKEN===========>${Variables.token}');
          print('STATUSCODE===========>${response.statusCode}');
        }
        print('HEADERS===========>${response.headers}');
        print('REQUESTOPTIONS===========>${response.requestOptions}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('REQUESTOPTIONS===========>${e.requestOptions}');
        print('MESSAGE===========>${e.message}');
      }
      rethrow;
    }
  }
}