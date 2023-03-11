import 'package:flutter/material.dart';
import 'package:gabi/presentation/app/constant/appcolors.dart';
import 'package:gabi/presentation/screens/loginscreen/login.page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: TextFormField(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    //autofocus: true,
                    //controller: userPassController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.amber),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.amber),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      label: const Text('Enter your email'),
                      hintText: 'e.g saun@gmail.com',
                      labelStyle: const TextStyle(color: Colors.amber),
                      hintStyle: const TextStyle(
                        color: Colors.amber,
                      ),
                    ),
                    validator: (val) =>
                        val!.isEmpty ? 'Please Enter email address' : null,
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        // side: MaterialStateBorderSide.resolveWith((states) => BorderRadius.all(context),
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.amber,
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
