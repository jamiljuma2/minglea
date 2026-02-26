import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AdvancedChatScreen extends StatefulWidget {
  final String peerId;
  final String peerName;
  const AdvancedChatScreen(
      {super.key, required this.peerId, required this.peerName});

  @override
  State<AdvancedChatScreen> createState() => _AdvancedChatScreenState();
}

class _AdvancedChatScreenState extends State<AdvancedChatScreen> {
  final TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  Timer? typingTimer;

  void sendTypingStatus(bool typing) {
    FirebaseFirestore.instance
        .collection('chats_typing')
        .doc(widget.peerId)
        .set({
      'isTyping': typing,
      'from': 'CURRENT_USER_ID', // TODO: Replace with actual user ID
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendMessage() async {
    final msg = messageController.text.trim();
    if (msg.isEmpty) return;
    await FirebaseFirestore.instance.collection('chats').add({
      'to': widget.peerId,
      'from': 'CURRENT_USER_ID', // TODO: Replace with actual user ID
      'message': msg,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
    messageController.clear();
    sendTypingStatus(false);
  }

  void onTyping(String value) {
    if (!isTyping) {
      setState(() {
        isTyping = true;
      });
      sendTypingStatus(true);
    }
    typingTimer?.cancel();
    typingTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        isTyping = false;
      });
      sendTypingStatus(false);
    });
  }

  void markAsRead(String messageId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(messageId)
        .update({'read': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.peerName}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('to', isEqualTo: widget.peerId)
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, idx) {
                    final data = docs[idx].data() as Map<String, dynamic>;
                    final messageId = docs[idx].id;
                    if (!data['read'] && data['to'] == 'CURRENT_USER_ID') {
                      markAsRead(messageId);
                    }
                    return ListTile(
                      title: Text(data['message'] ?? ''),
                      subtitle: Text(data['from'] ?? ''),
                      trailing: data['read'] == true
                          ? const Icon(Icons.done_all, color: Colors.blue)
                          : const Icon(Icons.done, color: Colors.grey),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats_typing')
                .doc(widget.peerId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                final typingData =
                    snapshot.data!.data() as Map<String, dynamic>;
                if (typingData['isTyping'] == true) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text('Typing...', style: TextStyle(color: Colors.pink)),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message'),
                    onChanged: onTyping,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
