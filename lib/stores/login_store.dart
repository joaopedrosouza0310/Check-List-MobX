import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  String email = "";

  @observable
  bool isVisiblePassword = false;

  @observable
  bool loading = false;

  @observable
  bool isLoggedIn = false;

  @action
  Future<void> login() async {
    loading = true;

    await Future.delayed(Duration(seconds: 2));

    loading = false;
    isLoggedIn = true;

    email = "";
    password = "";
  }

  @action
  void toggleVisiblePassword() => isVisiblePassword = !isVisiblePassword;

  @action
  void setEmail(value) => email = value;

  @observable
  String password = "";

  @action
  setPassword(value) => password = value;

  @action
  void logOut() {
    isLoggedIn = false;
  }

  @computed
  bool get isEmailValid => email.contains("@");

  @computed
  bool get isPasswordValid => password.length >= 6;

  @computed
  bool get isFormValid => isEmailValid && isPasswordValid;

  @computed
  Function get loginPressed =>
      (isEmailValid && isPasswordValid && !loading) ? login : null;
}
