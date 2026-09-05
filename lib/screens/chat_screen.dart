import 'package:flutter/material.dart';

// Model đại diện cho một tin nhắn
class ChatMessage {
  final String text;
  final bool
  isMe; // true nếu là tin nhắn của mình gửi, false nếu của người khác
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Controller để lấy nội dung từ ô nhập text
  final TextEditingController _controller = TextEditingController();

  // Danh sách tin nhắn mẫu
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Chào bạn, dự án Flutter thế nào rồi?',
      isMe: false,
      time: '10:00 AM',
    ),
    ChatMessage(
      text: 'Chào cậu, mọi thứ đang diễn ra rất suôn sẻ!',
      isMe: true,
      time: '10:02 AM',
    ),
    ChatMessage(
      text: 'Tuyệt vời. Cố gắng hoàn thành sớm nhé.',
      isMe: false,
      time: '10:05 AM',
    ),
  ];

  // Hàm xử lý khi gửi tin nhắn
  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _controller.text.trim(),
          isMe: true,
          time: TimeOfDay.now().format(context),
        ),
      );
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D61E7),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Nguyễn Văn A',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Đang online',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Container(
        color: const Color(0xFFECE5DD), // Màu nền chat quen thuộc của WhatsApp
        child: Column(
          children: [
            // Danh sách tin nhắn
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: message.isMe
                            ? const Color(0xFFDCF8C6)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            message.text,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message.time,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Thanh nhập tin nhắn (Đã lược bỏ nút tác vụ nâng cao như đính kèm file/ảnh)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF075E54),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
