
// Assuming your friends_status data is in a List<Map<String, dynamic>> variable
List<Map<String, dynamic>> groupStatusesByPhoneNumbers(List<dynamic> statuses) {
  final groupedStatuses = <String, List<Map<String, dynamic>>>{};

  for (final status in statuses) {
    final phoneNumber = status['user']['full_name'];
    // final phoneNumber = status['user']['phone_number'];
    /// **Commented out suffix creation**
    /// String uniqueKey = fullName;
    /// if (groupedStatuses.containsKey(fullName)) {
    ///   uniqueKey = '$fullName ($phoneNumber.substring(phoneNumber.length - 3))'; // Append last 3 digits
    /// }
    groupedStatuses[phoneNumber] ??= []; // Initialize empty list if not present
    groupedStatuses[phoneNumber]!.add(status);

    // final fullName = status['user']['full_name']; // Assuming full_name exists within the 'user' key
    //
    // // Combine phone number and full name into a single key
    // final key = {'phone_number': phoneNumber, 'full_name': fullName};
    //
    // groupedStatuses[key.toString()] ??= []; // Initialize empty list if not present
    // groupedStatuses[key.toString()]!.add(status);
  }

  return groupedStatuses.entries.map((entry) => {'key': entry.key, 'value': entry.value}).toList();
}