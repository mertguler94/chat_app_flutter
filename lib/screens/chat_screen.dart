import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs;
          return ListView.builder(
            itemBuilder: ((context, index) => Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(docs?[index]['text']),
                )),
            itemCount: snapshot.data?.docs.length,
          );
        }),
        stream: FirebaseFirestore.instance
            .collection('chats/KeH4DZlWa8lrctVyawO7/messages')
            .snapshots(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          FirebaseFirestore.instance
              .collection('chats/KeH4DZlWa8lrctVyawO7/messages')
              .add({'text': 'This was added by clicking a button.'});
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
