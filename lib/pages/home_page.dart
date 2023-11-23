import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_learning/read%20data/get_user_name.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  //list of document id's
  List<String> docIDs = [];

  //method to get document id's

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('age',descending: true)
        // .where('age',isGreaterThan: 30)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  // @override
  // void initState() {
  //   getDocId();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text(
          user.email!,
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Icon(Icons.logout)),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
              future: getDocId(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, Index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: GetUserName(documentId: docIDs[Index]),
                          tileColor: Colors.grey[200],
                        ),
                      );
                    });
              },
            ),
          )
        ],
      )),
    );
  }
}
