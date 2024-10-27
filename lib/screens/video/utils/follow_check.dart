
import '../../../common/utils/variables.dart';

class FollowCheck{

  bool hasCurrentUserFollowed(item, contact) {
    String currentUserPhoneNumber = Variables.phoneNumber.toString();

    return item.any((like) =>
    like[contact].toString() == currentUserPhoneNumber);
  }

}