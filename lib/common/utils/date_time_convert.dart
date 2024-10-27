import 'package:intl/intl.dart';

class DateTimeConvert {

  String convert(dateTimeData){
    DateTime dateTime = DateTime.parse('$dateTimeData');
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    String userFriendlyFormat = '$formattedDate at $formattedTime';
    return userFriendlyFormat;
  }

}