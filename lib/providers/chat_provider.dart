import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/chat_message.dart';
import '../services/chat_repository.dart';
import '../services/gemini_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  GeminiService? _geminiService;
  ChatRepository? _chatRepository;

  bool _isLoading = false;
  String? _error;

  UnmodifiableListView<ChatMessage> get messages =>
      UnmodifiableListView(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void configure(GeminiService geminiService, ChatRepository chatRepository) {
    _geminiService = geminiService;
    _chatRepository = chatRepository;
  }

  Future<void> sendMessage({required String text, required String userId}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isLoading) return;

    _setError(null);

    final userMessage = ChatMessage(
      id: _createId(),
      text: trimmed,
      isUser: true,
      createdAt: DateTime.now(),
      status: MessageStatus.sent,
    );

    _messages.add(userMessage);
    _setLoading(true);

    try {
      final response = await _geminiService!.sendMessage(
        prompt: trimmed,
        context: _buildContext(),
      );

      final botMessage = ChatMessage(
        id: _createId(),
        text: response,
        isUser: false,
        createdAt: DateTime.now(),
      );

      _messages.add(botMessage);
      notifyListeners();

      await _chatRepository!.saveConversation(
        userId: userId,
        userMessage: userMessage,
        botMessage: botMessage,
      );
    } catch (e) {
      _setError('Failed to send message. ${e.toString()}');
      _messages.add(
        ChatMessage(
          id: _createId(),
          text: 'I ran into an issue. Please try again.',
          isUser: false,
          createdAt: DateTime.now(),
          status: MessageStatus.failed,
        ),
      );
    } finally {
      _setLoading(false);
    }
  }

  List<Content> _buildContext() {
    final latest = _messages.reversed.take(6).toList().reversed;
    return latest
        .map(
          (msg) => Content.text(
            '${msg.isUser ? 'User' : 'Assistant'}: ${msg.text}',
          ),
        )
        .toList();
  }

  String _createId() => DateTime.now().microsecondsSinceEpoch.toString();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
}
