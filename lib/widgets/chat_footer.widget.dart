import 'package:flutter/material.dart';
import 'package:flutter_messenger/flutter_chat_icons_icons.dart';
import 'package:flutter_messenger/main.dart';
import 'package:flutter_messenger/models/message.class.dart';
import 'package:flutter_messenger/models/user.class.dart';
import 'package:flutter_messenger/widgets/action_icon_button.widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatFooter extends StatelessWidget {
  final imagePicker = ImagePicker();
  final textEditingController = TextEditingController();

  final User user;

  ChatFooter({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<MessengerAppState>();
    final currentUser = appState.currentUser;

    void handleSendMessage({String? attachment}) {
      appState.sendMessage(
        Message.newMessage(
          currentUser.id,
          text: textEditingController.text.isEmpty
              ? null
              : textEditingController.text,
          attachment: attachment,
        ),
        user.id,
      );
      textEditingController.clear();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: theme.colorScheme.secondary),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          ActionIconButtonWidget(
            icon: const Icon(FlutterChatIcons.attach),
            onPressed: () => _showAttachmentPicker(
              context: context,
              userId: user.id,
              onPicked: handleSendMessage,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MessageInput(
              userId: user.id,
              controller: textEditingController,
              onSubmit: handleSendMessage,
            ),
          ),
          const SizedBox(width: 8),
          ActionIconButtonWidget(
            icon: const Icon(FlutterChatIcons.audio),
            onPressed: () => debugPrint("Record audio clicked"),
          ),
        ],
      ),
    );
  }

  Future<String?> getAttachment(
    ImageSource img,
  ) async {
    final pickedFile = await imagePicker.pickImage(source: img);
    return pickedFile?.path;
  }

  void _showAttachmentPicker({
    required BuildContext context,
    required String userId,
    required Function({String? attachment}) onPicked,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        void onTap(ImageSource img) async {
          final attachment = await getAttachment(img);
          onPicked(attachment: attachment);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }

        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(FlutterChatIcons.img),
                title: const Text('Галерея'),
                onTap: () => onTap(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(FlutterChatIcons.camera),
                title: const Text('Камера'),
                onTap: () => onTap(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MessageInput extends StatelessWidget {
  final String userId;
  final TextEditingController controller;
  final Function({String? attachment}) onSubmit;

  const MessageInput({
    super.key,
    required this.userId,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    handleSubmit(String text) {
      if (text.isEmpty) {
        return;
      }
      onSubmit();
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: handleSubmit,
        onChanged: (inputText) {
          inputText;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          hintText: "Сообщение",
          hintStyle: TextStyle(
            color: theme.colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
