// ignore_for_file: non_constant_identifier_names

import '../../models/menu.dart';

class UpdateNavigationIndexAction {
  int navigationIndex;
  UpdateNavigationIndexAction(this.navigationIndex);
}

class UpdateSelectedTabAction {
  Menu selectedTab;
  bool isClosed;
  UpdateSelectedTabAction(this.selectedTab, this.isClosed);
}

class UpdateUserDetailsAction {
  String? auth_uid;
  String? displayName;
  String? email;
  String? phoneNumber;

  UpdateUserDetailsAction(
    this.auth_uid,
    this.displayName,
    this.email,
    this.phoneNumber,
  );
}
