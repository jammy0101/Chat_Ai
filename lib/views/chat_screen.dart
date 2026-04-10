import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /// Replace with real user id from FirebaseAuth once auth flow is added.
  final String _demoUserId = 'demo-user';

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
      ),
      body: Column(
        children: [
          if (chatProvider.error != null)
            MaterialBanner(
              content: Text(chatProvider.error!),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: chatProvider.messages[index]);
              },
            ),
          ),
          if (chatProvider.isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(),
            ),
          MessageInput(
            controller: _controller,
            enabled: !chatProvider.isLoading,
            onSend: () async {
              final text = _controller.text;
              _controller.clear();
              await context
                  .read<ChatProvider>()
                  .sendMessage(text: text, userId: _demoUserId);
            },
          ),
        ],
      ),
    );
  }
}
