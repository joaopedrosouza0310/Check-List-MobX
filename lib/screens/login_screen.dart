import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:todomobx/stores/login_store.dart';
import 'package:todomobx/widgets/custom_icon_button.dart';
import 'package:todomobx/widgets/custom_text_field.dart';

import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginStore loginStore;
  ReactionDisposer reactionDispoder;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Recuperando o login através do provider
    loginStore = Provider.of<LoginStore>(context);

    // Outra alternativa - 1º Parâmetro define qual observable observar e o segundo recebe a mudança pra fazer alguma coisa
    reactionDispoder = reaction((_) => loginStore.isLoggedIn, (loggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => ListScreen()));
    });

    // autorun((_) {
    //   if (loginStore.isLoggedIn) {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (c) => ListScreen()));
    //   }
    // });
  }

  @override
  void dispose() {
    reactionDispoder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Observer(
                      builder: (_) {
                        return CustomTextField(
                          hint: 'E-mail',
                          prefix: Icon(Icons.account_circle),
                          textInputType: TextInputType.emailAddress,
                          onChanged: loginStore.setEmail,
                          enabled: !loginStore.loading,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Observer(
                      builder: (_) {
                        return CustomTextField(
                          hint: 'Senha',
                          prefix: Icon(Icons.lock),
                          obscure: !loginStore.isVisiblePassword,
                          onChanged: loginStore.setPassword,
                          enabled: !loginStore.loading,
                          suffix: CustomIconButton(
                            radius: 32,
                            iconData: loginStore.isVisiblePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onTap: loginStore.toggleVisiblePassword,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 44,
                      child: Observer(
                        builder: (_) {
                          return RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: loginStore.loading
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : Text('Login'),
                            color: Theme.of(context).primaryColor,
                            disabledColor:
                                Theme.of(context).primaryColor.withAlpha(100),
                            textColor: Colors.white,
                            onPressed: loginStore.loginPressed,
                          );
                        },
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
