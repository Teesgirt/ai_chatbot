import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';

import '../../core/ads/banner_ad_widget.dart';

class ChatScreen extends StatefulWidget {
const ChatScreen({super.key});

@override
State<ChatScreen> createState() =>
_ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
final TextEditingController controller =
TextEditingController();

final ScrollController scrollController =
ScrollController();

@override
void initState() {
super.initState();

Future.microtask(() {
context.read<ChatProvider>().loadMessages();
});
}

void scrollBottom() {
WidgetsBinding.instance.addPostFrameCallback((_) {
if (scrollController.hasClients) {
scrollController.animateTo(
scrollController.position.maxScrollExtent,
duration: const Duration(
milliseconds: 300,
),
curve: Curves.easeOut,
);
}
});
}

@override
void dispose() {
controller.dispose();
scrollController.dispose();
super.dispose();
}

void _sendMessage(ChatProvider provider) {
final text = controller.text.trim();

if (text.isEmpty) return;

provider.sendMessage(text);

controller.clear();
}

@override
Widget build(BuildContext context) {
final provider = context.watch<ChatProvider>();

scrollBottom();

return Scaffold(
backgroundColor: const Color(0xFFF8F9FB),

appBar: AppBar(
elevation: 0,
scrolledUnderElevation: 0,
backgroundColor: Colors.white,
centerTitle: true,
title: Column(
mainAxisSize: MainAxisSize.min,
children: const [
Text(
"AI Chat",
style: TextStyle(
fontWeight: FontWeight.w600,
fontSize: 18,
color: Colors.black,
),
),
SizedBox(height: 2),
Text(
"Online",
style: TextStyle(
fontSize: 12,
color: Colors.green,
),
),
],
),
),

body: Column(
children: [
Expanded(
child: ListView.builder(
controller: scrollController,
padding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 12,
),
itemCount: provider.messages.length,
itemBuilder: (_, index) {
final msg =
provider.messages[index];

return ChatBubble(
text: msg.text,
isUser: msg.isUser,
);
},
),
),

if (provider.isTyping)
const TypingIndicator(),

const BannerAdWidget(),

SafeArea(
child: Container(
margin: const EdgeInsets.all(12),
padding: const EdgeInsets.symmetric(
horizontal: 12,
),
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(30),
),
child: Row(
children: [
Expanded(
child: TextField(
controller: controller,
decoration:
const InputDecoration(
hintText:
"Send a message",
border:
InputBorder.none,
),
textInputAction:
TextInputAction.send,
onSubmitted: (_) =>
_sendMessage(
provider,
),
),
),

IconButton(
onPressed: () =>
_sendMessage(
provider,
),
icon: const Icon(
Icons.send_rounded,
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
