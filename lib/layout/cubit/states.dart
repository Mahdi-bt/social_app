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

// states to Comment post
class HomeCommentPostSuccesState extends HomeLayoutStates {}

class HomeCommentPostFailedState extends HomeLayoutStates {}

class HomeCommentPostLoadingState extends HomeLayoutStates {}

//states to get Comment
class HomeGetPostCommentLoadingState extends HomeLayoutStates {}

class HomeGetPostCommentSuccesState extends HomeLayoutStates {}

class HomeGetPostCommentFailedState extends HomeLayoutStates {}

//states to send message

class HomeSendMessageLoadingState extends HomeLayoutStates {}

class HomeSendMessageFailedState extends HomeLayoutStates {}

class HomeSendMessageSuccesState extends HomeLayoutStates {}

//state to get messages
class HomeGetMessageSuccesState extends HomeLayoutStates {}

// states to pick messageImage
class HomePickMessageImageSuccesState extends HomeLayoutStates {}

class HomePickMessageImageFailedState extends HomeLayoutStates {}

class HomePickMessageImageDeleteState extends HomeLayoutStates {}

//states to get current user posts

class HomeGetMyPostSuccesState extends HomeLayoutStates {}

class HomeGetMyPostFailedState extends HomeLayoutStates {}

class HomeGetMyPostLoadingState extends HomeLayoutStates {}

//states to delete posts
class HomeDeletePostLoadingState extends HomeLayoutStates {}

class HomeDeletePostFailedState extends HomeLayoutStates {}

class HomeDeletePostSuccesState extends HomeLayoutStates {}

//states to update Post
class HomeUpdatePostSuccesState extends HomeLayoutStates {}

class HomeUpdatePostFailedState extends HomeLayoutStates {}

class HomeUpdatePostLoadingState extends HomeLayoutStates {}
