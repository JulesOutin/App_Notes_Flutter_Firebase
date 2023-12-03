import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('notes').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot note = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(note['content']),
                    trailing: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _updateNote(note.id, 'new content');
                          },
                          child: const Text('Update Note'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _deleteNote(note);
                          },
                          child: const Text('Delete Note'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
          // Vous pouvez ajouter ici un ListView.builder pour afficher les notes
        ],
      ),
    );
  }
}