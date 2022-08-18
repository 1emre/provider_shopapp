import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopapp/providers/auth.dart';

import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 80.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  //late Animation<Size> _heightAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ));
    // _heightAnimation = Tween<Size>(
    //         begin: const Size(double.infinity, 260),
    //         end: const Size(double.infinity, 320))
    //     .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, -1.5), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    //_heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An Error Occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await context
            .read<Auth>()
            .signIn(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        await context
            .read<Auth>()
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.message.contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.message.contains('WEEK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
      var errorMessage = 'Could not authenticate you.Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward(); //forward means start the animation
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          // AnimatedBuilder(
          //   animation: _heightAnimation,
          //   builder: (ctx, ch) =>

          //height: _heightAnimation.value.height,
          height: _authMode == AuthMode.Signup ? 320 : 260,
          constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.Signup ? 320 : 260,
          ),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),

          //child: ch,
          // ),
          // child:
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  //if (_authMode == AuthMode.Signup)
                  AnimatedContainer(
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                        maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  // TextFormField(
                  //   enabled: _authMode == AuthMode.Signup,
                  //   decoration:
                  //       const InputDecoration(labelText: 'Confirm Password'),
                  //   obscureText: true,
                  //   validator: _authMode == AuthMode.Signup
                  //       ? (value) {
                  //           if (value != _passwordController.text) {
                  //             return 'Passwords do not match!';
                  //           }
                  //           return null;
                  //         }
                  //       : null,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    RaisedButton(
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button!.color,
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    ),
                  FlatButton(
                    onPressed: _switchAuthMode,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  ),
                ],
              ),
            ),
          ),
        )
        // ),
        // child: Container(
        //   //height: _authMode == AuthMode.Signup ? 320 : 260,
        //   height: _heightAnimation.value.height,
        //   // constraints:
        //   //     BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        //   constraints: BoxConstraints(minHeight: _heightAnimation.value.height),
        //   width: deviceSize.width * 0.75,
        //   padding: const EdgeInsets.all(16.0),
        //   child: Form(
        //     key: _formKey,
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children: <Widget>[
        //           TextFormField(
        //             decoration: const InputDecoration(labelText: 'E-Mail'),
        //             keyboardType: TextInputType.emailAddress,
        //             validator: (value) {
        //               if (value!.isEmpty || !value.contains('@')) {
        //                 return 'Invalid email!';
        //               }
        //               return null;
        //               return null;
        //             },
        //             onSaved: (value) {
        //               _authData['email'] = value!;
        //             },
        //           ),
        //           TextFormField(
        //             decoration: const InputDecoration(labelText: 'Password'),
        //             obscureText: true,
        //             controller: _passwordController,
        //             validator: (value) {
        //               if (value!.isEmpty || value.length < 5) {
        //                 return 'Password is too short!';
        //               }
        //               return null;
        //             },
        //             onSaved: (value) {
        //               _authData['password'] = value!;
        //             },
        //           ),
        //           if (_authMode == AuthMode.Signup)
        //             TextFormField(
        //               enabled: _authMode == AuthMode.Signup,
        //               decoration:
        //                   const InputDecoration(labelText: 'Confirm Password'),
        //               obscureText: true,
        //               validator: _authMode == AuthMode.Signup
        //                   ? (value) {
        //                       if (value != _passwordController.text) {
        //                         return 'Passwords do not match!';
        //                       }
        //                       return null;
        //                     }
        //                   : null,
        //             ),
        //           const SizedBox(
        //             height: 20,
        //           ),
        //           if (_isLoading)
        //             const CircularProgressIndicator()
        //           else
        //             RaisedButton(
        //               onPressed: _submit,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(30),
        //               ),
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 30.0, vertical: 8.0),
        //               color: Theme.of(context).primaryColor,
        //               textColor: Theme.of(context).primaryTextTheme.button!.color,
        //               child:
        //                   Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
        //             ),
        //           FlatButton(
        //             onPressed: _switchAuthMode,
        //             padding:
        //                 const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
        //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //             textColor: Theme.of(context).primaryColor,
        //             child: Text(
        //                 '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
