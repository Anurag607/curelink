import 'package:curelink/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CureLinkDatabase db = CureLinkDatabase();
  late String uid = "";
  late List<types.Message> messages = [];

  @override
  void initState() {
    uid = db.getUserDetails()["auth_uid"];
    super.initState();
  }

  void _handleSendPressed(types.PartialText messageTxt) {
    if (messageTxt.text.trim().isEmpty) {
      return;
    }

    final message = types.TextMessage(
      author: types.User(
        id: uid,
      ),
      id: uid,
      text: messageTxt.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: HexColor("#f6f8fe").withOpacity(1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.72,
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Chat(
            messages: messages,
            onSendPressed: _handleSendPressed,
            user: types.User(
              id: uid,
            ),
          ),
        ),
      ),
    );
  }
}
