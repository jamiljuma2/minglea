import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MatchScreen extends StatefulWidget {
  final String matchedUserId;
  final String matchedUserName;
  const MatchScreen(
      {super.key, required this.matchedUserId, required this.matchedUserName});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('It’s a Match!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You matched with ${widget.matchedUserName}!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      peerId: widget.matchedUserId,
                      peerName: widget.matchedUserName,
                    ),
                  ),
                );
              },
              child: const Text('Start Chat'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerName;
  const ChatScreen({super.key, required this.peerId, required this.peerName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatBackground = 'default';
  bool isTyping = false;
  File? imageFile;
  bool isUploading = false;
  List<Map<String, dynamic>> messageObjects = [];
  final List<String> reactions = ['👍', '❤️', '😂', '🔥', '👏', '😮'];
  String? selectedReaction;
  final TextEditingController messageController = TextEditingController();
  List<String> messages = [];
  bool isLoading = false;

  void onTyping(String value) {
    setState(() {
      isTyping = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isTyping = false;
      });
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
    // Simulate upload
    await Future.delayed(const Duration(seconds: 1));
    final url =
        'https://fakeurl.com/${DateTime.now().millisecondsSinceEpoch}.jpg';
    setState(() {
      isUploading = false;
    });
    sendMessage(imageUrl: url);
  }

  void sendMessage({String? imageUrl}) async {
    final msg = messageController.text.trim();
    if (msg.isEmpty && imageUrl == null) return;
    setState(() {
      isLoading = true;
    });
    // Simulate backend
    await Future.delayed(const Duration(milliseconds: 300));
    messageObjects.add({
      'message': msg,
      'isMe': messageObjects.length % 2 == 0,
      'read': true,
      'reaction': selectedReaction,
      'imageUrl': imageUrl,
    });
    setState(() {
      messages.add(msg);
      messageController.clear();
      imageFile = null;
      isLoading = false;
      selectedReaction = null;
    });
  }

  void showReactionPicker(int idx) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: reactions
            .map((r) => GestureDetector(
                  onTap: () {
                    setState(() {
                      messageObjects[idx]['reaction'] = r;
                    });
                    Navigator.pop(ctx);
                  },
                  child: Text(r, style: const TextStyle(fontSize: 32)),
                ))
            .toList(),
      ),
    );
  }

  void showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => GridView.count(
        crossAxisCount: 6,
        children: [
          '😀',
          '😂',
          '😍',
          '🥰',
          '😎',
          '😭',
          '😡',
          '👍',
          '❤️',
          '🔥',
          '👏',
          '😮',
          '🎉',
          '😇',
          '🤔',
          '😜',
          '😏',
          '😱',
          '😴',
          '🤩',
          '😅',
          '😆',
          '😋',
          '😌',
          '😢',
          '😤',
          '😬',
          '😳',
          '😵',
          '😡',
          '😃',
          '😄',
          '😁',
          '😆',
          '😅',
          '🤣',
          '😊',
          '😇',
          '🙂',
          '🙃',
          '😉',
          '😌',
          '😍',
          '🥰',
          '😘',
          '😗',
          '😙',
          '😚',
          '😋',
          '😜',
          '😝',
          '😛',
          '🤑',
          '🤗',
          '🤩',
          '🤔',
          '🤨',
          '😐',
          '😑',
          '😶',
          '🙄',
          '😏',
          '😣',
          '😥',
          '😮',
          '🤐',
          '😯',
          '😪',
          '😫',
          '😴',
          '😌',
          '😛',
          '😜',
          '😝',
          '😒',
          '😓',
          '😔',
          '😕',
          '🙁',
          '☹️',
          '😖',
          '😞',
          '😟',
          '😤',
          '😢',
          '😭',
          '😦',
          '😧',
          '😨',
          '😩',
          '😰',
          '😱',
          '😳',
          '😵',
          '😡',
          '😠',
          '😷',
          '🤒',
          '🤕',
          '🤢',
          '🤮',
          '🤧',
          '😇',
          '🥳',
          '🥺',
          '🤠',
          '🤡',
          '🤥',
          '🤫',
          '🤭',
          '🧐',
          '🤓',
          '😈',
          '👿',
          '👹',
          '👺',
          '💀',
          '👻',
          '👽',
          '🤖',
          '💩',
          '😺',
          '😸',
          '😹',
          '😻',
          '😼',
          '😽',
          '🙀',
          '😿',
          '😾'
        ]
            .map((e) => GestureDetector(
                  onTap: () {
                    messageController.text += e;
                    Navigator.pop(ctx);
                  },
                  child: Center(
                      child: Text(e, style: const TextStyle(fontSize: 28))),
                ))
            .toList(),
      ),
    );
  }

  void showBackgroundPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Default'),
            onTap: () {
              setState(() {
                chatBackground = 'default';
              });
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            title: const Text('Pink Gradient'),
            onTap: () {
              setState(() {
                chatBackground = 'pink';
              });
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            title: const Text('Image'),
            onTap: () {
              setState(() {
                chatBackground = 'image';
              });
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration bg;
    if (chatBackground == 'pink') {
      bg = const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
    } else if (chatBackground == 'image') {
      bg = BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/chat_banner.png'),
          fit: BoxFit.cover,
        ),
      );
    } else {
      bg = const BoxDecoration(color: Colors.white);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.peerName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: showBackgroundPicker,
          ),
        ],
      ),
      body: Container(
        decoration: bg,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messageObjects.length,
                itemBuilder: (context, idx) {
                  final msg = messageObjects[idx];
                  return GestureDetector(
                    onLongPress: () => showReactionPicker(idx),
                    child: Align(
                      alignment: msg['isMe']
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: msg['isMe']
                              ? const LinearGradient(
                                  colors: [Colors.pink, Colors.purple],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [Colors.grey, Colors.white],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: msg['isMe']
                                  ? Colors.pink.shade100
                                  : Colors.grey.shade200,
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (msg['imageUrl'] != null)
                              Image.network(msg['imageUrl'], height: 120),
                            Text(
                              msg['message'] ?? '',
                              style: TextStyle(
                                color:
                                    msg['isMe'] ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (msg['reaction'] != null)
                                  Text(msg['reaction'],
                                      style: const TextStyle(fontSize: 20)),
                                msg['read'] == true
                                    ? const Icon(Icons.done_all,
                                        color: Colors.blue, size: 18)
                                    : const Icon(Icons.done,
                                        color: Colors.grey, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isTyping)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Typing...', style: TextStyle(color: Colors.pink)),
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
                    icon: const Icon(Icons.emoji_emotions),
                    onPressed: showEmojiPicker,
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: pickImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration:
                          const InputDecoration(hintText: 'Type a message'),
                      onChanged: onTyping,
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
      ),
    );
  }
  // All code outside the class has been removed. All methods are now inside _ChatScreenState.
}
