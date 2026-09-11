import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
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

  // Helper lấy thời gian Hà Nội (UTC+7)
  static DateTime _getHanoiNow() {
    return DateTime.now().toUtc().add(const Duration(hours: 7));
  }

  late final List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    final hanoiNow = _getHanoiNow();
    _messages = [
      ChatMessage(
        id: '1',
        text:
        'Your verification code is: 849201. Do not share this code with anyone for security reasons.',
        isMe: false,
        timestamp: hanoiNow.subtract(const Duration(days: 2)),
      ),
      ChatMessage(
        id: '2',
        text: 'Hello, this is yesterday message.',
        isMe: false,
        timestamp: hanoiNow.subtract(const Duration(hours: 26)),
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _trimLeadingTrailing(String text) {
    return text.trim();
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDateHeader(DateTime timestamp) {
    final now = _getHanoiNow();
    final String timeStr = _formatTime(timestamp);

    final DateTime todayDate = DateTime(now.year, now.month, now.day);
    final DateTime messageDate =
    DateTime(timestamp.year, timestamp.month, timestamp.day);
    final int differenceInDays = todayDate.difference(messageDate).inDays;

    if (differenceInDays == 0) {
      return '$timeStr, Today';
    } else if (differenceInDays == 1) {
      return '$timeStr, Yesterday';
    } else {
      return '$timeStr, ${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  bool _shouldShowDateHeader(int index) {
    if (index == 0) return true;

    final currentTimestamp = _messages[index].timestamp;
    final previousTimestamp = _messages[index - 1].timestamp;

    final difference = currentTimestamp.difference(previousTimestamp).abs();
    return difference.inHours >= 20;
  }

  /// Tính toán chiều cao tổng thể của 1 Box Chat Bubble dựa trên text và maxWidth
  double _calculateBubbleHeight(String text, double maxContentWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 15),
      ),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxContentWidth);

    double contentHeight = textPainter.size.height;

    // UI Spacing & Padding
    const double verticalPadding = 16.0; // Top 8 + Bottom 8
    const double spacing = 2.0;
    const double timestampHeight = 12.0; // FontSize 10

    return contentHeight + verticalPadding + spacing + timestampHeight;
  }

  /// Cắt động đoạn văn bản sao cho phần đầu tiên không vượt quá maxHeightThreshold.
  /// Trả về [FirstPart, RemainingPart]
  List<String> _takeFitChunk(String remainingText, double maxContentWidth, double maxHeightThreshold) {
    List<String> words = remainingText.split(' ');

    // Nếu toàn bộ văn bản còn lại đã nhỏ hơn ngưỡng -> không cần cắt thêm
    if (_calculateBubbleHeight(remainingText, maxContentWidth) <= maxHeightThreshold) {
      return [remainingText, ""];
    }

    int low = 1;
    int high = words.length;
    int bestFitIndex = 1;

    // Tìm kiếm nhị phân (Binary Search) vị trí từ tối đa mà chiều cao bubble vẫn <= maxHeightThreshold
    while (low <= high) {
      int mid = (low + high) ~/ 2;
      String testChunk = words.sublist(0, mid).join(' ');

      if (_calculateBubbleHeight(testChunk, maxContentWidth) <= maxHeightThreshold) {
        bestFitIndex = mid;
        low = mid + 1; // Thử lấy thêm từ
      } else {
        high = mid - 1; // Quá cao, bớt từ đi
      }
    }

    String fitPart = words.sublist(0, bestFitIndex).join(' ');
    String restPart = words.sublist(bestFitIndex).join(' ');

    return [fitPart, restPart];
  }

  /// Tách văn bản thành N phần box chat (1, 2, 3,... box) dựa trên ngưỡng chiều cao
  List<String> _splitMessageIfNeeded(String originalText, double maxContentWidth, double maxHeightThreshold) {
    // Nếu chiều cao tổng ban đầu <= Threshold -> giữ nguyên 1 box chat
    if (_calculateBubbleHeight(originalText, maxContentWidth) <= maxHeightThreshold) {
      return [originalText];
    }

    List<String> resultChunks = [];
    String currentText = originalText;

    // Lặp để cắt các phần vừa vặn cho đến khi hết chuỗi
    while (currentText.isNotEmpty) {
      List<String> splitResult = _takeFitChunk(currentText, maxContentWidth, maxHeightThreshold);
      resultChunks.add(splitResult[0]);
      currentText = splitResult[1].trim();
    }

    return resultChunks;
  }

  void _handleSendMessage() {
    String rawText = _messageController.text;
    if (rawText.trim().isEmpty) return;

    String trimmedText = _trimLeadingTrailing(rawText);

    double screenHeight = MediaQuery.of(context).size.height;

    // 1. CHỌN NGƯỠNG CHIỀU CAO (Height Threshold)
    // Chọn khoảng 2/3 chiều cao màn hình (66%)
    // Bạn cũng có thể test thử bằng cách đổi sang số cố định như 100.0 hoặc 200.0
    double maxHeightThreshold = screenHeight * 0.66;

    // Chiều rộng tối đa phần nội dung text trong Bubble
    double maxBubbleWidth = MediaQuery.of(context).size.width * 0.75;
    double maxContentWidth = maxBubbleWidth - 24.0; // Trừ Padding 12px mỗi bên

    // 2. TÁCH THÀNH N BOX CHAT
    List<String> parts = _splitMessageIfNeeded(trimmedText, maxContentWidth, maxHeightThreshold);

    _messageController.clear();
    setState(() {});

    final now = _getHanoiNow();

    // 3. THÊM LẦN LƯỢT CÁC BOX CHAT VÀO DANH SÁCH
    for (int i = 0; i < parts.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        final newMessage = ChatMessage(
          id: '${now.millisecondsSinceEpoch}_$i',
          text: parts[i],
          isMe: true,
          timestamp: now,
        );

        _messages.add(newMessage);
        _listKey.currentState?.insertItem(
          _messages.length - 1,
          duration: const Duration(milliseconds: 350),
        );

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                final message = _messages[index];
                final showHeader = _shouldShowDateHeader(index);

                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                );

                return SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: animation,
                    child: Column(
                      children: [
                        if (showHeader) _buildDateHeader(message.timestamp),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildChatBubble(message),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime timestamp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: Text(
        _formatDateHeader(timestamp),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: message.isMe
              ? const Color(0xFF007AFF)
              : const Color(0xFFE5E5EA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 15,
                  color: message.isMe ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isMe ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
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
                  borderRadius: BorderRadius.circular(8),
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