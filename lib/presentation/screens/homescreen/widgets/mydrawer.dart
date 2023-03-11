import 'package:flutter/material.dart';
import 'package:gabi/presentation/screens/homescreen/widgets/socialicons.dart';

class MyDradwer extends StatefulWidget {
  const MyDradwer({super.key});

  @override
  State<MyDradwer> createState() => _MyDradwerState();
}

class _MyDradwerState extends State<MyDradwer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 60.0,
                      backgroundImage:
                          AssetImage('assets/images/onboarding/7111.jpg'),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      "Rose",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.download_done),
                  title: const Text("Downloads"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.live_tv),
                  title: const Text("Live"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Profile"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Log out"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: socialIocns(
                      images: 'assets/images/social/facebook.png',
                      ontap: () {}),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: socialIocns(
                      images: 'assets/images/social/instagram.png',
                      ontap: () {}),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: socialIocns(
                      images: 'assets/images/social/twitter.png', ontap: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
