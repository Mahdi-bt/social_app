abstract class HomeLayoutStates {}

class HomeInitialState extends HomeLayoutStates {}

// states to BottomNavigation Bar
class HomeChangeBottomNavState extends HomeLayoutStates {}

// states to log out
class HomeLogOutSuccesStates extends HomeLayoutStates {}

class HomeLogOutFailedSates extends HomeLayoutStates {}

// fetch currentuser data
class HomeGetUserDataSuccesState extends HomeLayoutStates {}

class HomeGetUserDataLoadingState extends HomeLayoutStates {}

class HomeGetUserDataFailedState extends HomeLayoutStates {}

// states for picke an image

class HomePickImageSuccesState extends HomeLayoutStates {}

class HomePickImageFailedState extends HomeLayoutStates {}

class HomePostImageDeleteSuccfuly extends HomeLayoutStates {}

//states to upload a posts

class HomeUploadPostLoadingStates extends HomeLayoutStates {}

class HomeUploadPostSuccesStates extends HomeLayoutStates {}

class HomeUploadPostFailedStates extends HomeLayoutStates {}

//states to fetch posts

class HomeGetPostLoadingState extends HomeLayoutStates {}

class HomeGetPostSuccesState extends HomeLayoutStates {}

class HomeGetPostFailedSate extends HomeLayoutStates {}

//states to fetch Users
class HomeGetAllUsersLoadingState extends HomeLayoutStates {}

class HomeGetAllUsersSuccesState extends HomeLayoutStates {}

class HomeGetAllUsersFailedState extends HomeLayoutStates {}

// states to like post
class HomeLikePostSuccesState extends HomeLayoutStates {}

class HomeLikePostFailedState extends HomeLayoutStates {}

class HomeLikePostLoadingState extends HomeLayoutStates {}

//states to get post likes
class HomeGetPostLikeLoadingState extends HomeLayoutStates {}

class HomeGetPostLikeSuccesState extends HomeLayoutStates {}

// states to delete like from a post
class HomeDeleteLikePostLoadingState extends HomeLayoutStates {}

class HomeDeleteLikePostSuccesState extends HomeLayoutStates {}

class HomeDeleteLikePostFailedState extends HomeLayoutStates {}
