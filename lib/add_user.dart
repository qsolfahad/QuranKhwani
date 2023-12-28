import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddUser extends StatefulWidget {
  var id;
  AddUser(this.id);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  emailSender(url) async {
    //  if (await canLaunch(url)) {
    await launch(url);
    //  } else {
    //    throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[400]!, Colors.green[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: const Text(
                "Add Members",
                style: TextStyle(fontSize: 25, fontFamily: 'Schyler'),
              )),
          body: FutureBuilder(
              future: FirebaseFirestore.instance.collection('Users').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      var userID = ds['userID'];
                      var userName = ds['userName'];
                      var email = ds['email'];
                      return Card(
                        child: ListTile(
                          title: Text(userName),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              final Uri params = Uri(
                                scheme: 'mailto',
                                path: email,
                                query:
                                    'subject=You are added to my Group.', //add subject and body here
                              );

                              var url = params.toString();
                              await FirebaseFirestore.instance
                                  .collection('Request')
                                  .where('userID', isEqualTo: userID)
                                  .where('groupID', isEqualTo: widget.id)
                                  .get()
                                  .then((value) {
                                if (value.docs.isNotEmpty) {
                                  const snackBar = SnackBar(
                                    content: Text('This user is already Added'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  emailSender(url);
                                  FirebaseFirestore.instance
                                      .collection('Request')
                                      .add({
                                    'userID': userID,
                                    'groupID': widget.id,
                                    'userName': userName
                                  });
                                  const snackBar = SnackBar(
                                    content: Text('Added to this Group'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                            },
                          ),
                        ),
                      );
                    });
              })),
    );
  }
}
