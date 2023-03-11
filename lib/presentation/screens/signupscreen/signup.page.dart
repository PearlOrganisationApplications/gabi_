import 'package:flutter/material.dart';
import 'package:gabi/presentation/app/constant/appcolors.dart';
import 'package:gabi/presentation/screens/loginscreen/login.page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 35.0,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 15.0,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        //controller: userEmailController,
                        //autofocus: true,
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
                          label: const Text('Name'),
                          labelStyle: const TextStyle(color: Colors.amber),
                          hintText: 'Enter User Name',
                          hintStyle: const TextStyle(color: Colors.amber),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Plase Enter User name' : null,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        //controller: userEmailController,
                        //autofocus: true,
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
                          label: const Text('Phone number'),
                          labelStyle: const TextStyle(color: Colors.amber),
                          hintText: 'Enter Phone number',
                          hintStyle: const TextStyle(color: Colors.amber),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Plase Enter Phone number' : null,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        //controller: userEmailController,
                        //autofocus: true,
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
                          label: const Text('Email'),
                          labelStyle: const TextStyle(color: Colors.amber),
                          hintText: 'Email Address',
                          hintStyle: const TextStyle(color: Colors.amber),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Plase Enter Email Address' : null,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        //controller: userEmailController,
                        //autofocus: true,
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
                          label: const Text('Password'),
                          labelStyle: const TextStyle(color: Colors.amber),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.amber),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Plase Enter password' : null,
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
                                builder: (context) => LoginPage(),
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
                            "Sign up with email",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
