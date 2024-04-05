import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ing_mobile/configs/constants.dart';
import 'package:ing_mobile/features/authentication/firebase_methods.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();

  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeNume = FocusNode();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNumeController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
    focusNodeEmail.dispose();
    focusNodeNume.dispose();
    super.dispose();
  }
  
  double containerHeight = 275; // 380
  double buttonMargin = 255; // 360

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: SizedBox(
                    width: 300.0,
                    height: containerHeight,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeNume,
                            controller: signupNumeController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(height: 0.05),
                              border: InputBorder.none,
                              icon: Icon(
                                // FontAwesomeIcons.user,
                                Icons.person_outline_outlined,
                                color: Colors.black,
                              ),
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 135, 135, 135),
                                ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Câmp obligatoriu.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              focusNodeEmail.requestFocus();
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeEmail,
                            controller: signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(height: 0.05),
                              border: InputBorder.none,
                              icon: Icon(
                                // FontAwesomeIcons.envelope,
                                Icons.mail_outline_outlined,
                                color: Colors.black,
                              ),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 135, 135, 135),
                                ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Câmp obligatoriu.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              focusNodePassword.requestFocus();
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodePassword,
                            controller: signupPasswordController,
                            obscureText: _obscureTextPassword,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(height: 0.05),
                              border: InputBorder.none,
                              icon: const Icon(
                                // FontAwesomeIcons.lock,
                                Icons.lock_outlined,
                                color: Colors.black,
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 135, 135, 135),
                                ),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Câmp obligatoriu.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              focusNodeConfirmPassword.requestFocus();
                            },
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: focusNodeConfirmPassword,
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextConfirmPassword,
                            autocorrect: false,
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(height: 0.05),
                              border: InputBorder.none,
                              icon: const Icon(
                                // FontAwesomeIcons.lock,
                                Icons.lock_outlined,
                                color: Colors.black,
                              ),
                              hintText: 'Confirm password',
                              hintStyle: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 135, 135, 135),
                                ),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  _obscureTextConfirmPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Câmp obligatoriu.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              if (_formKey.currentState!.validate()) {
                                if (emailVerificationEnabled) {
                                  signUserUp(context, signupEmailController.text, signupNumeController.text, signupPasswordController.text, signupConfirmPasswordController.text);
                                } else if (pinEnabled) {
                                  signUserUpWithoutEmailVerification(context, signupEmailController.text, signupNumeController.text, signupPasswordController.text, signupConfirmPasswordController.text);
                                } else {
                                  signUserUpWithoutEmailVerificationAndPin(context, signupEmailController.text, signupNumeController.text, signupPasswordController.text, signupConfirmPasswordController.text);
                                }
                                
                              } else {
                                setState(() {
                                  containerHeight = 380;
                                  buttonMargin = 360;
                                });
                              }
                            },
                            textInputAction: TextInputAction.go,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 230.0,
                  margin: EdgeInsets.only(top: buttonMargin),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Color.fromARGB(255, 0, 10, 76),
                  ),
                  child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: const Color.fromARGB(255, 38, 40, 110),
                    child: const Text(
                      'Create account',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (emailVerificationEnabled) {
                          signUserUp(context, signupEmailController.text, signupNumeController.text, signupPasswordController.text, signupConfirmPasswordController.text);
                        } else if (pinEnabled) {
                          signUserUpWithoutEmailVerification(context, signupEmailController.text, signupNumeController.text, signupPasswordController.text, signupConfirmPasswordController.text);
                        } else {
                          signUserUpWithoutEmailVerificationAndPin(context, signupEmailController.text, signupNumeController.text, signupPasswordController.text, signupConfirmPasswordController.text);
                        }
                      } else {
                        setState(() {
                          containerHeight = 325; // 380
                          buttonMargin = 305;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }
}
