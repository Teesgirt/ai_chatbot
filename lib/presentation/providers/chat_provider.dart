
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/services/gemini_service.dart';
import '../../data/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
final List<MessageModel> messages = [];

bool isTyping = false;

static const String boxName = "chat_box";
static const String messagesKey = "messages";

String getErrorMessage(dynamic error) {
final message = error.toString().toLowerCase();

if (message.contains('503') ||
message.contains('unavailable') ||
message.contains('high demand')) {
return "The AI service is currently busy. Please try again shortly.";
}

if (message.contains('network') ||
message.contains('socketexception')) {
return "No internet connection. Please check your internet.";
}

if (message.contains('timeout')) {
return "The request timed out. Please try again.";
}

return "Something went wrong. Please try again later.";
}

Future<void> loadMessages() async {
final box = await Hive.openBox(boxName);

final data = box.get(
messagesKey,
defaultValue: [],
);

messages.clear();

for (final item in data) {
messages.add(
MessageModel.fromJson(
Map<String, dynamic>.from(item),
),
);
}

notifyListeners();
}

Future<void> sendMessage(String text) async {
if (text.trim().isEmpty) return;

// User message
messages.add(
MessageModel(
text: text.trim(),
isUser: true,
timestamp: DateTime.now(),
),
);

notifyListeners();
await saveMessages();

// Show typing indicator
isTyping = true;
notifyListeners();

try {
final futureResponse =
GeminiService.generateResponse(
text.trim(),
);

// Keep typing animation visible
await Future.delayed(
const Duration(milliseconds: 1500),
);

final aiReply = await futureResponse;

messages.add(
MessageModel(
text: aiReply,
isUser: false,
timestamp: DateTime.now(),
),
);
} catch (e) {
messages.add(
MessageModel(
text: getErrorMessage(e),
isUser: false,
timestamp: DateTime.now(),
),
);

debugPrint('Gemini Error: $e');
} finally {
isTyping = false;
notifyListeners();

await saveMessages();
}
}

Future<void> saveMessages() async {
final box = await Hive.openBox(boxName);

await box.put(
messagesKey,
messages
    .map((message) => message.toJson())
    .toList(),
);
}

Future<void> clearChat() async {
messages.clear();

notifyListeners();

final box = await Hive.openBox(boxName);

await box.put(messagesKey, []);
}
}
