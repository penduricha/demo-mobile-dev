import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;

  ChatMessage({required this.id, required this.text, required this.isMe});
}

class ChatDetailScreen extends StatefulWidget {
  final String senderName;
  const ChatDetailScreen({super.key, required this.senderName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Danh sách lưu trữ tin nhắn hiện tại
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: 'Your verification code is: 849201. Do not share this code with anyone for security reasons.',
      isMe: false,
    ),
  ];

  // Ngưỡng chiều cao tối đa của một bong bóng chat trước khi tự động chia làm 2 box
  static const double _maxBubbleHeightThreshold = 180.0;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Cắt khoảng trắng ở 2 đầu (giữ nguyên xuống dòng nội dung)
  String _trimLeadingTrailing(String text) {
    return text.trim();
  }

  // Kiểm tra chiều cao văn bản thực tế để quyết định cắt chuỗi
  List<String> _splitMessageIfNeeded(String originalText, double maxWidth) {
    final textStyle = const TextStyle(fontSize: 15);
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: null,
    );

    // Tính toán chiều cao toàn bộ text
    textPainter.text = TextSpan(text: originalText, style: textStyle);
    textPainter.layout(maxWidth: maxWidth);

    // Nếu chiều cao nhỏ hơn ngưỡng, giữ nguyên 1 box
    if (textPainter.size.height <= _maxBubbleHeightThreshold) {
      return [originalText];
    }

    // Nếu vượt ngưỡng chiều cao, tiến hành tách thành 2 box
    List<String> words = originalText.split(' ');
    int midPoint = (words.length / 2).ceil();

    String firstPart = words.sublist(0, midPoint).join(' ');
    String secondPart = words.sublist(midPoint).join(' ');

    return [firstPart, secondPart];
  }

  void _handleSendMessage() {
    String rawText = _messageController.text;

    // Validate: chỉ chấp nhận tin nhắn có ký tự thực tế (không phải khoảng trắng)
    if (rawText.trim().isEmpty) return;

    // 1. Cắt khoảng trắng 2 đầu
    String trimmedText = _trimLeadingTrailing(rawText);

    // Tính toán chiều rộng tối đa của box chat (75% screen width - padding)
    double maxChatWidth = (MediaQuery.of(context).size.width * 0.75) - 28;

    // 2. Chia chuỗi nếu vượt quá chiều cao cho phép
    List<String> parts = _splitMessageIfNeeded(trimmedText, maxChatWidth);

    // 3. Làm mới ô nhập văn bản ngay lập tức
    _messageController.clear();
    setState(() {});

    // 4. Thêm tin nhắn vào danh sách và kích hoạt hiệu ứng Float Up
    for (int i = 0; i < parts.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        final newMessage = ChatMessage(
          id: '${DateTime.now().millisecondsSinceEpoch}_$i',
          text: parts[i],
          isMe: true,
        );

        _messages.add(newMessage);
        _listKey.currentState?.insertItem(
          _messages.length - 1,
          duration: const Duration(milliseconds: 350),
        );

        // Tự động cuộn xuống tin nhắn mới nhất
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF007AFF)),
        title: Column(
          children: [
            const SizedBox(height: 2),
            Text(
              widget.senderName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                final message = _messages[index];

                // Hiệu ứng Float Up (Trượt từ dưới lên + Mờ dần sang rõ)
                final slideAnimation =
                    Tween<Offset>(
                      begin: const Offset(0, 0.4),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve:
                            Curves.easeOutBack, // Sửa từ outBack thành backOut
                      ),
                    );

                return SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: animation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildChatBubble(message),
                    ),
                  ),
                );
              },
            ),
          ),
          // Thanh nhập tin nhắn dưới cùng
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe
              ? const Color(0xFF007AFF)
              : const Color(0xFFE5E5EA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 15,
            color: message.isMe ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEFEFF0),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF007AFF)),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF0),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFD1D1D6)),
                ),
                child: TextField(
                  controller: _messageController,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _handleSendMessage(),
                  decoration: const InputDecoration(
                    hintText: 'iMessage',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Nút gửi tin nhắn (Chỉ bật màu khi có dữ liệu thực tế)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _messageController,
              builder: (context, value, child) {
                final hasText = value.text.trim().isNotEmpty;
                return Container(
                  decoration: BoxDecoration(
                    color: hasText ? const Color(0xFF007AFF) : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: hasText ? _handleSendMessage : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
