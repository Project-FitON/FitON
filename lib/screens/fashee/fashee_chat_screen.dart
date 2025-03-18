import 'package:flutter/material.dart';
import 'package:fiton/screens/fashee/fashee_screen.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [
    {
      "isUser": true,
      "text": "I have a wedding party tomorrow. What do I wear?",
    },
    {
      "isUser": false,
      "text":
          "I think the gold color frock you have is the best suit for a wedding, Nimasha. Let me show you.",
      "image": "assets/images/feed/girl.jpeg",
    },
    {
      "isUser": false,
      "text":
          "You can see I colored your hair in black. Don’t you think black-colored hair gives you more look with this dress? 🤞",
    },
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({"isUser": true, "text": _controller.text});
      });

      String userMessage = _controller.text.toLowerCase();
      _controller.clear();

      // Simulate bot response after a short delay
      Future.delayed(Duration(milliseconds: 500), () {
        _botReply(userMessage);
      });
    }
  }

  void _botReply(String userMessage) {
    String botResponse;

    // Simple bot response logic
    if (userMessage.contains("hello") || userMessage.contains("hi")) {
      botResponse = "Hello! How can I help you today? 😊";
    } else if (userMessage.contains("wedding")) {
      botResponse = "Looking for wedding outfits? I can suggest some great options! 👗";
    } else if (userMessage.contains("thank you")) {
      botResponse = "You're welcome! Let me know if you need more help. 😊";
    } else {
      botResponse = "I'm here to assist you! Ask me anything. ";
    }

    setState(() {
      messages.add({"isUser": false, "text": botResponse});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FasheeHomePage(),
                ),
              );
            },
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: messages.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: message["isUser"]
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!message["isUser"])
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "assets/images/feed/mm.png", // Bot Image
                                  ),
                                ),
                              if (!message["isUser"]) const SizedBox(width: 8),
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: message["isUser"]
                                        ? Colors.purple.shade800
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message["text"],
                                        style: TextStyle(
                                          color: message["isUser"]
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      if (message["image"] != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                          ),
                                          child: Image.asset(
                                            message["image"],
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              if (message["isUser"]) const SizedBox(width: 8),
                              if (message["isUser"])
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    "assets/images/feed/girl.jpeg", // User Image
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No messages yet! Start chatting..."),
                    ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Ask Me Anything...',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 26, 5, 63),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}