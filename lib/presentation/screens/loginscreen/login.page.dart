import 'package:flutter/material.dart';
import 'package:gabi/presentation/app/constant/appcolors.dart';
import 'package:gabi/presentation/screens/forgotepassword/forgotpass.dart';
import 'package:gabi/presentation/screens/homescreen/home.page.dart';
import 'package:gabi/presentation/screens/signupscreen/signup.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0000),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 28.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: double.infinity,
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 28.0),
                    child: Image(
                      image: AssetImage(
                        'assets/images/login/login.jpg',
                      ),
                      height: 50,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 90.0,
                      left: 10.0,
                      right: 10.0,
                      bottom: 20.0,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          //autofocus: true,
                          //controller: userPassController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.amber),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.amber),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            label: const Text('Enter your email'),
                            hintText: 'e.g saun@gmail.com',
                            labelStyle: const TextStyle(color: Colors.amber),
                            hintStyle: const TextStyle(
                              color: Colors.amber,
                            ),
                          ),
                          validator: (val) => val!.isEmpty
                              ? 'Please Enter email address'
                              : null,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          //autofocus: true,
                          //controller: userPassController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.amber),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            label: const Text(
                              'Password',
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.amber,
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: Colors.amber,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.amber),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Please Enter Password' : null,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              // side: MaterialStateBorderSide.resolveWith((states) => BorderRadius.all(context),
                              backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.amber,
                              ),
                            ),
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Your password?",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/social/facebook.png',
                              height: 50,
                            ),
                            const SizedBox(
                              width: 60.0,
                            ),
                            Image.asset(
                              'assets/images/social/google.png',
                              height: 50,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          child: const Text(
                            "New User? Sign up!",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
