
import '../../../common/utils/variables.dart';

class LikeCheck{

  // Function to check if the current user has liked the video
  bool hasCurrentUserLikedVideo(Map<String, dynamic> video) {
    // Assuming Variables.phoneNumber is a string
    String currentUserPhoneNumber = Variables.phoneNumber.toString();

    // Iterate through the likes list and check if the current user has liked the video
    return video['likes'].any((like) =>
    like['user']['phone_number'].toString() == currentUserPhoneNumber);
  }

  bool hasCurrentUserLikedItem(Map<String, dynamic> item, itemList, contact) {
    String currentUserPhoneNumber = Variables.phoneNumber.toString();

    return item[itemList].any((like) =>
    like[contact].toString() == currentUserPhoneNumber);
  }

}