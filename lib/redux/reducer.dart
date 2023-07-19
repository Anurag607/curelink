import 'package:curelink/redux/states/sidebar_state.dart';
import 'package:curelink/redux/states/user_details_state.dart';

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

UserDetailsState userDetailsReducer(UserDetailsState state, dynamic action) {
  if (action is UpdateUserDetailsAction) {
    action.auth_uid = action.auth_uid;
    action.displayName = action.displayName;
    action.email = action.email;
    action.phoneNumber = action.phoneNumber;
    return UserDetailsState(
      auth_uid: action.auth_uid,
      displayName: action.displayName,
      email: action.email,
      phoneNumber: action.phoneNumber,
    );
  }
  return state;
}
