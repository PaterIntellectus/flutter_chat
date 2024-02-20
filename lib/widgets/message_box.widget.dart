import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_messenger/flutter_chat_icons_icons.dart';
import 'package:flutter_messenger/main.dart';
import 'package:flutter_messenger/models/message.class.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class MessageBox extends StatelessWidget {
  final Message message;
  final MessageBoxType messageBoxType;

  const MessageBox({
    super.key,
    required this.message,
    this.messageBoxType = MessageBoxType.solo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appState = context.watch<MessengerAppState>();
    final currentUser = appState.currentUser;

    final isCurrentUserMessage = message.userId == currentUser.id;

    final borderRadius = _createBorderRadius(isCurrentUserMessage);

    final isMessageLong = message.length > 31;
    final doesMessageHaveAttachments = message.attachment != null;

    return Row(
      textDirection:
          isCurrentUserMessage ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // only the messages that is standing Solo or
        // at the Bottom of the group has Tails
        (messageBoxType == MessageBoxType.solo ||
                messageBoxType == MessageBoxType.bottom)
            ? MessageBoxTail(
                isCurrentUserMessage: isCurrentUserMessage,
                size: const Size(12, 21),
              )
            : const SizedBox(
                width: 12,
                height: 21,
              ),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            minWidth: 10,
          ),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isCurrentUserMessage
                ? const Color(0xFF3CED78)
                : const Color(0xFFEDF2F6),
          ),
          child: Column(
            children: [
              if (doesMessageHaveAttachments)
                ClipRRect(
                  borderRadius: _createBorderRadius(
                    isCurrentUserMessage,
                    defaultRadiusNum: 19,
                    changedRadiusNum: 2,
                  ),
                  // const BorderRadius.only(
                  //   topLeft: Radius.circular(19),
                  //   topRight: Radius.circular(19),
                  //   bottomRight: Radius.circular(8),
                  //   bottomLeft: Radius.circular(8),
                  // ),
                  child: MessageBoxImage(message: message),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 8,
                  right: 4,
                  bottom: 6,
                ),
                child: Flex(
                  direction: isMessageLong ? Axis.vertical : Axis.horizontal,
                  mainAxisSize: doesMessageHaveAttachments
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (message.hasText)
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                          minWidth: 10,
                        ),
                        child: Text(
                          message.text!,
                          style: TextStyle(
                            color: isCurrentUserMessage
                                ? const Color(0xFF00521C)
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          intl.DateFormat("HH:mm").format(message.date),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        if (isCurrentUserMessage)
                          Icon(
                            message.status == MessageStatus.read
                                ? FlutterChatIcons.read
                                : FlutterChatIcons.unread,
                            size: 12,
                            color: const Color(0xFF00521C),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BorderRadius _createBorderRadius(
    final bool isCurrentUserMessage, {
    final double defaultRadiusNum = 23,
    final double changedRadiusNum = 6,
  }) {
    final defaultRadius = Radius.circular(defaultRadiusNum);
    final changedRadius = Radius.circular(changedRadiusNum);

    final topLeft = isCurrentUserMessage
        ? defaultRadius
        : switch (messageBoxType) {
            MessageBoxType.solo || MessageBoxType.up => defaultRadius,
            MessageBoxType.middle || MessageBoxType.bottom => changedRadius,
          };

    final topRight = isCurrentUserMessage
        ? switch (messageBoxType) {
            MessageBoxType.solo || MessageBoxType.up => defaultRadius,
            MessageBoxType.middle || MessageBoxType.bottom => changedRadius,
          }
        : defaultRadius;

    final bottomRight = isCurrentUserMessage
        ? switch (messageBoxType) {
            MessageBoxType.solo => Radius.zero,
            MessageBoxType.up => changedRadius,
            MessageBoxType.middle => changedRadius,
            MessageBoxType.bottom => Radius.zero,
          }
        : defaultRadius;

    final bottomLeft = isCurrentUserMessage
        ? defaultRadius
        : switch (messageBoxType) {
            MessageBoxType.solo => Radius.zero,
            MessageBoxType.up => changedRadius,
            MessageBoxType.middle => changedRadius,
            MessageBoxType.bottom => Radius.zero,
          };

    final borderRadius = BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomRight: bottomRight,
      bottomLeft: bottomLeft,
    );

    return borderRadius;
  }
}

class MessageBoxImage extends StatelessWidget {
  final Message message;

  const MessageBoxImage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.file(
        File(message.attachment ?? ''),
        fit: BoxFit.fill,
        cacheWidth: 1124,
      ),
    );
  }
}

class MessageBoxTail extends StatelessWidget {
  final Size size;

  final bool isCurrentUserMessage;

  const MessageBoxTail({
    super.key,
    required this.isCurrentUserMessage,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: MessageBoxTailPainter(
        isCurrentUserMessage: isCurrentUserMessage,
      ),
    );
  }
}

class MessageBoxTailPainter extends CustomPainter {
  final bool isCurrentUserMessage;

  MessageBoxTailPainter({this.isCurrentUserMessage = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCurrentUserMessage
          ? const Color(0xFF3CED78)
          : const Color(0xFFEDF2F6)
      ..strokeWidth = 2;

    Path path = Path();
    if (isCurrentUserMessage) {
      path.moveTo(0, 0);
      path.conicTo(
        size.width * 0.1,
        size.height * 0.8,
        size.width,
        size.height,
        1,
      );
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.conicTo(
        size.width * 0.9,
        size.height * 0.8,
        0,
        size.height,
        1,
      );
      path.lineTo(size.width, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum MessageBoxType {
  solo,
  up,
  middle,
  bottom,
}
