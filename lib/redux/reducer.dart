import 'actions.dart';
import 'states/navigation_state.dart';

NavigationState navigationReducer(NavigationState state, dynamic action) {
  if (action is UpdateNavigationIndexAction) {
    action.navigationIndex = action.navigationIndex;
    return NavigationState(tabIndex: action.navigationIndex);
  }
  return state;
}
