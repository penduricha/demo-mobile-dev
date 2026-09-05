import 'package:flutter/material.dart';

import 'chat_detail_screen.dart';

// import '../screens/login_screen.dart';

String truncateMessage(String text, int limit) {
  if (text.length <= limit) {
    return text;
  }
  return '${text.substring(0, limit)}...';
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chatList = [
      {
        'name': 'Apple Verification',
        'message': 'Your verification code is: 849201. Do not share this code with anyone for security reasons.',
        'time': '10:42 AM',
        'unread': 'true',
      },
      {
        'name': 'Momo OTP',
        'message': 'Ma xac thuc Momo cua ban la 592104. Hieu luc trong 5 phut.',
        'time': 'Hôm qua',
        'unread': 'false',
      },
      {
        'name': 'Nguyen Van A',
        'message': 'Ê tối nay đi cà phê không ông ơi?',
        'time': 'Hôm qua',
        'unread': 'false',
      },
      {
        'name': 'Viettel Telecom',
        'message': 'Quy khach da thanh toán thanh cong hoa den cuoc thang.',
        'time': '28/08',
        'unread': 'false',
      },
    ];

    // Sử dụng PopScope để chặn nút back của Android
    return PopScope(
      canPop:
          false, // Chặn không cho tự động back về màn hình trước (login_screen)
      // onPopInvokedWithResult: (didPop, result) async {
      //   if (didPop) {
      //     return;
      //   }

      //   // Tùy chọn 1: Hiển thị hộp thoại xác nhận đăng xuất / thoát ứng dụng
      //   final bool? shouldLogout = await showDialog<bool>(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: const Text('Đăng xuất'),
      //       content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
      //       actions: [
      //         TextButton(
      //           onPressed: () => Navigator.of(context).pop(false),
      //           child: const Text('Hủy'),
      //         ),
      //         TextButton(
      //           onPressed: () => Navigator.of(context).pop(true),
      //           child: const Text(
      //             'Đăng xuất',
      //             style: TextStyle(color: Colors.red),
      //           ),
      //         ),
      //       ],
      //     ),
      //   );

      //   // Nếu người dùng đồng ý đăng xuất, điều hướng sạch về LoginScreen và xóa hết lịch sử route cũ
      //   if (shouldLogout == true && context.mounted) {
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => const LoginScreen()),
      //       (route) => false, // Xóa sạch toàn bộ stack màn hình phía sau
      //     );
      //   }
      // },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Xử lý menu mở rộng nếu cần
            },
          ),
          title: const Text(
            'Messages',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_square, color: Color(0xFF007AFF)),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
          ),
        ),

        body: ListView.separated(
          itemCount: chatList.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, indent: 76, color: Color(0xFFE5E5EA)),
          itemBuilder: (context, index) {
            final chat = chatList[index];
            final bool isUnread = chat['unread'] == 'true';

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatDetailScreen(senderName: chat['name']!),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                      child: Center(
                        child: isUnread
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF007AFF),
                                  shape: BoxShape.circle,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors
                          .primaries[index % Colors.primaries.length]
                          .withValues(alpha: 0.2),
                      child: Text(
                        chat['name']![0],
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.primaries[index % Colors.primaries.length],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                chat['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isUnread
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                chat['time']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isUnread
                                      ? const Color(0xFF007AFF)
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            truncateMessage(chat['message']!, 80),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: isUnread
                                  ? Colors.black87
                                  : Colors.grey[600],
                              fontWeight: isUnread
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
