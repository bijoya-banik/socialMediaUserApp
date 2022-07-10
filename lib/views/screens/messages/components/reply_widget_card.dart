import 'package:buddyscripts/views/styles/b_style.dart';
import 'package:flutter/material.dart';

class ReplyMessageWidget extends StatelessWidget {
  final Message message;
  final VoidCallback? onCancelReply;
  final dynamic fromRoute;

  const ReplyMessageWidget({
    required this.message,
    required this.onCancelReply,
    this.fromRoute,
     Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: fromRoute == null
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(message.message == "" ? "Attachment" : message.message??"",
                    maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: KColor.black54)))
            : Container(
                padding: const EdgeInsets.only(top: 6, bottom: 3),
                child: Row(
                  children: [
                    message.username == null ? Container() : Container(color: KColor.primary, width: 4),
                    const SizedBox(width: 8),
                    buildReplyMessage(),
                  ],
                ),
              ),
      );

  Widget buildReplyMessage() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.username == null
                ? Container()
                : Text(
                    message.username??"",
                    style: TextStyle(fontWeight: FontWeight.bold, color: KColor.primary),
                  ),
            const SizedBox(height: 2),
            Text(message.message == "" ? "Attachment" : message.message??"",
                maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: KColor.black54)),
          ],
        ),
      );
}

class MessageField {
  static const String message = 'message';
}

class Message {
  final int? id;
  final String? username;
  final String? message;
  final Message? replyMessage;

  const Message({
     this.id,
     this.username,
     this.message,
     this.replyMessage,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        username: json['username'],
        message: json['message'],
        replyMessage: json['replyMessage'] == null ? null : Message.fromJson(json['replyMessage']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'message': message,
        'replyMessage':  replyMessage?.toJson(),
      };
}
