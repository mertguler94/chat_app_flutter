import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final chatDocs = snapshot.data?.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: ((context, index) => MessageBubble(
                chatDocs?[index]['text'],
                chatDocs?[index]['username'],
                chatDocs?[index]['userId'] ==
                    FirebaseAuth.instance.currentUser?.uid,
                messageKey: ValueKey(chatDocs?[index].id),
              )),
          itemCount: chatDocs?.length,
        );
      }),
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('sentAt', descending: true)
          .snapshots(),
    );
  }
}
