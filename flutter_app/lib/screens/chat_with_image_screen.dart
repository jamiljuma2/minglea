import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatWithImageScreen extends StatefulWidget {
  final String peerId;
  final String peerName;
  const ChatWithImageScreen(
      {super.key, required this.peerId, required this.peerName});

  @override
  State<ChatWithImageScreen> createState() => _ChatWithImageScreenState();
}

class _ChatWithImageScreenState extends State<ChatWithImageScreen> {
  final TextEditingController messageController = TextEditingController();
  File? imageFile;
  bool isUploading = false;

  Future<void> sendMessage({String? imageUrl}) async {
    final msg = messageController.text.trim();
    if (msg.isEmpty && imageUrl == null) return;
    await FirebaseFirestore.instance.collection('chats').add({
      'to': widget.peerId,
      'from': 'CURRENT_USER_ID', // TODO: Replace with actual user ID
      'message': msg,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
    messageController.clear();
    setState(() {
      imageFile = null;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> uploadAndSendImage() async {
    if (imageFile == null) return;
    setState(() {
      isUploading = true;
    });
    final ref = FirebaseStorage.instance
        .ref('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(imageFile!);
    final url = await ref.getDownloadURL();
    await sendMessage(imageUrl: url);
    setState(() {
      isUploading = false;
    });
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
                    return ListTile(
                      title: data['imageUrl'] != null
                          ? Image.network(data['imageUrl'])
                          : Text(data['message'] ?? ''),
                      subtitle: Text(data['from'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          if (imageFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(imageFile!, height: 100),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                isUploading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: imageFile != null
                            ? uploadAndSendImage
                            : () => sendMessage(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
