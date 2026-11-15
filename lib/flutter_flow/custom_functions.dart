String? getOtherUsers(
  List<String> fullNames,
  List<String> userIds,
  String authUser,
) {
  List<String> otherUsers = [];

  // Har user ID ko check karein
  for (int i = 0; i < userIds.length; i++) {
    // Agar user ID current user ki ID se match nahi karti
    if (userIds[i] != authUser) {
      // Toh uska fullName list mein add kar dein
      if (i < fullNames.length) {
        otherUsers.add(fullNames[i]);
      }
    }
  }

  // Sab fullNames ko comma (,) ke sath jor kar return karein
  return otherUsers.join(', ');
}
