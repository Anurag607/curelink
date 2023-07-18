import 'package:curelink/redux/states/sidebar_state.dart';

import 'actions.dart';
import 'states/navigation_state.dart';

NavigationState navigationReducer(NavigationState state, dynamic action) {
  if (action is UpdateNavigationIndexAction) {
    action.navigationIndex = action.navigationIndex;
    return NavigationState(tabIndex: action.navigationIndex);
  }
  return state;
}

SidebarMenuState sidebarMenuReducer(SidebarMenuState state, dynamic action) {
  if (action is UpdateSelectedTabAction) {
    action.selectedTab = action.selectedTab;
    return SidebarMenuState(
        selectedTab: action.selectedTab, isClosed: action.isClosed);
  }
  return state;
}
