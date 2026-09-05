import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String senderName;
  const ChatDetailScreen({super.key, required this.senderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF007AFF)),
        title: Column(
          children: [
            // CircleAvatar(
            //   radius: 12,
            //   backgroundColor: Colors.blue.withValues(alpha: 0.2),
            //   child: Text(
            //     senderName[0],
            //     style: const TextStyle(
            //       fontSize: 10,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.blue,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 2),
            Text(
              senderName,
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: Text(
                    'Today 10:42 AM',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 16),
                // Bong bóng chat OTP
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your verification code is: 849201. Do not share this code with anyone for security reasons.',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        // Nút giả lập sao chép OTP nhanh
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 10,
                        //     vertical: 6,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(
                        //       color: Colors.blue.withValues(alpha: 0.3),
                        //     ),
                        //   ),
                        //   child: const Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Icon(Icons.copy, size: 14, color: Colors.blue),
                        //       SizedBox(width: 6),
                        //       Text(
                        //         'Tap to Copy Code: 849201',
                        //         style: TextStyle(
                        //           color: Colors.blue,
                        //           fontSize: 13,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Phản hồi gửi mã
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '849201',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Thanh nhập tin nhắn dưới cùng
          Container(
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
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFD1D1D6)),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'iMessage',
                          //hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          //contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AFF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
