import 'package:zego_zim/zego_zim.dart';

class Services {
  void sendCallInvitation() {
    List<String> invitees = []; // The list of the callee.
    invitees.add('1234'); // ID of the callee.
    ZIMCallInviteConfig callInviteConfig = ZIMCallInviteConfig();
    callInviteConfig.timeout = 200;
  }
}
