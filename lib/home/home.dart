import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Navigator.pop(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white70,
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                  child: Center(
                child: Icon(
                  Icons.image_search,
                  size: 100,
                  color: Colors.indigo,
                ),
              )),
              const ListTile(
                title: Text(
                  "I M A G E - T O - T E X T - A P P",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: const ListTile(
                  leading: Icon(Icons.camera_alt_outlined, color: Colors.indigo),
                  title: Text(
                    "Capture Image",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: const ListTile(
                  leading: Icon(Icons.image, color: Colors.indigo),
                  title: Text(
                    "Add Image From Gallery",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _signOut();
                },
                child: const ListTile(
                  leading: Icon(Icons.logout, color: Colors.indigo),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Text("Home"),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
