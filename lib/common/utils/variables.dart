import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';

class Variables {
  ///TextEditingController
  static bool isText = true;
  static TextEditingController fullName = TextEditingController();
  static TextEditingController bio = TextEditingController();

  ///var
  static var timeStamp;
  static var qrCode;
  static var dioResponseExceptionData;
  static var headers = {
    "Accept": "application/json ; charset=utf-8",
    "Content-Type": "application/json",
    "Authorization": "Bearer ${Variables.token}",
  };
  static var avatar;
  static var videoId;
  static var commentId;
  static var base64Video;
  static var storyList;
  static var videoPageNumber = 1;
  static var videoPages = 0;

  ///Boolean
  static bool devicesBool = true;
  static bool signIn = false;
  static bool signUp = false;
  static bool isActive = false;
  static bool updateProfile = false;
  static bool isSendingFile = false;
  static bool ownStoryViewing = false;
  static bool isVideo = false;
  static bool isImage = false;
  static bool isDarkMode = true;

  static bool isFollowed = false;
  static bool viewingFriendsStory = false;
  static bool textMessage = false;
  static bool isPickingVideo = false;
  static bool isPickingImage = false;
  static bool isOnline = false;
  static bool isUploading = false;
  static bool isSuccess = false;

  ///String
  static String token = "";
  static String countryName = "";
  static String countryIso = "";
  static String countryCode = "";
  static String phoneNumber = "";
  static String fullNameString = "";
  static String bioString = "";
  static String dateJoined = "";
  static String parentCommentAvatar = "";
  static String parentCommentName = "";
  static String parentCommentContent = "";
  static String parentCommentDate = "";
  static String parentCommentNotifKey = "";
  static String replyChat = "";
  static String videoProfileName = "";
  static String videoProfileLikes = "";
  static String videoProfileAvatar = "";
  static String videoProfileViewers = "";
  static String videoProfileFollowers = "0";
  static String videoProfileNotifKey = "";
  static String? mediaUrl;
  static const String appId = "139c014b-5498-4e8b-9ca2-8261caa19591";
  static String? likeStatus;
  static String? flyingCaption;
  static String recieverName = '';

  static final dateMessageFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  ///Globalkey
  static final GlobalKey<ScaffoldState> keyLoader = GlobalKey<ScaffoldState>();

  ///int
  static int id = 0;
  static int commentIndex = 0;

  ///double
  static double uploadProgress = 0.0;

  ///List
  static List<Map<String, dynamic>> contacts = [];
  static List videoList = [];
  static List filteredVideos = [];
  static List postedVideos = [];
  static List ownStoryList = [];
  static var friendsStoryList;
  static List storyGroupedByPhone = [];
  static List friendsGroupedByPhone = [];
  static List videoCommentList = [];
  static List groupedCommentList = [];
  static List childCommentList = [];
  static List storyViewList = [];
  static List<String> extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.tif', '.webp', '.svg', '.mp3', '.wav', '.aac', '.ogg', '.flac', '.m4a', '.mp4', '.avi', '.mkv', '.wmv', '.mov', '.flv', '.webm'];
  static List<String> imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.tif', '.webp', '.svg'];

  static List<String> audioExtensions = ['.mp3', '.wav', '.aac', '.ogg', '.flac', '.m4a'];

  static List<String> videoExtensions = ['.mp4', '.avi', '.mkv', '.wmv', '.mov', '.flv', '.webm'];
  // Create a list to track the loading state for each item
  static List<bool> itemLoadingStates = List.filled(Variables.filteredVideos.length, false);
  static List<ChatModel> remoteContacts = [];
  // static List<ChatModel> uhuruContacts = [];

  ///CONNECTIVITY GLOBAL VARIABLE
  static var connectionStatus;
  static var connectivitySubscription;
}
