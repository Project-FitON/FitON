import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
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
      "image": "assets/girl.jpeg",
    },
    {
      "isUser": false,
      "text":
          "You can see I colored your hair in black. Don’t you think black-colored hair gives you more look with this dress? 🤞",
    },
  ];

  TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({"isUser": true, "text": _controller.text});
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius:5,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {},
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () {},
            ),
          ),
          SizedBox(width: 20),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
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
              child:
                  messages.isNotEmpty
                      ? ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment:
                                  message["isUser"]
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                if (!message["isUser"])
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/mm.png",
                                    ),
                                  ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          message["isUser"]
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
                                            color:
                                                message["isUser"]
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
                                SizedBox(width: 8),
                                if (message["isUser"])
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/girl.jpeg",
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      )
                      : Center(
                        child: Text("No messages yet! Start chatting..."),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        decoration: InputDecoration(
                          hintText: 'Ask Me Anything...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
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