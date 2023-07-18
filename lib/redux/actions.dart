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
