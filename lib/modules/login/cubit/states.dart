abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginFailedState extends LoginStates {}

class LoginSuccesState extends LoginStates {}

class LoginChangePassVisibility extends LoginStates {}

class LoginWithGoogleLoadingState extends LoginStates {}

class LoginWithGoogleFailedState extends LoginStates {}

class LoginWithGoogleSuccesSates extends LoginStates {}
