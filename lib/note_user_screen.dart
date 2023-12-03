import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _noteController = TextEditingController();

  void _addNote() {
    FirebaseFirestore.instance.collection('notes').add({
      'content': _noteController.text,
      'userId': _auth.currentUser!.uid,
    });
  }

  void _updateNote(String noteId, String newContent) {
  FirebaseFirestore.instance.collection('notes').doc(noteId).update({
    'content': newContent,
  });
  }

  void _deleteNote(DocumentSnapshot note) {
    FirebaseFirestore.instance.collection('notes').doc(note.id).delete();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Page'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(labelText: 'Note'),
          ),
          ElevatedButton(
            onPressed: _addNote,
            child: const Text('Add Note'),
          ),
          ElevatedButton(
          onPressed: () {
            _updateNote('noteId', 'new content');
          },
          child: const Text('Update Note'),
          ),
          // ajouter un bouton pour se signout
          ElevatedButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamed(context, '/welcome');
            },
            child: const Text('Sign Out'),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('notes').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['content']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteNote(document);
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}