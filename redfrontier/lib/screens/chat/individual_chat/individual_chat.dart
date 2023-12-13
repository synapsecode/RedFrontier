import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/screens/chat/individual_chat/renderer.dart';
import 'package:redfrontier/services/messaging/messaging.dart';
import 'package:redfrontier/services/messaging/models/chat_engine.dart';
import 'package:redfrontier/services/messaging/models/chat_entity.dart';
import '../chat_details/chat_details.dart';
import 'components.dart';

int numOfMessages = 0;

final latestMessageProvider = StateProvider<MessageModel?>((ref) => null);

//TODO: When the user leaves the chat, it must update the chat preview

class IndividualChat extends ConsumerStatefulWidget {
  const IndividualChat({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<IndividualChat> createState() => _IndividualChatState();
}

class _IndividualChatState extends ConsumerState<IndividualChat> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  ChatEntity? get currentChat => ref.read(currentlyActiveChat);

  registerPreview() async {
    final lm = gpc.read(latestMessageProvider);
    if (lm == null) return;
    final cc = gpc.read(currentlyActiveChat);
    await ChatEngine.setChatPreview(cc!.id, lm);
    gpc.read(latestMessageProvider.notifier).state = null;
    gpc.read(currentlyActiveChat.notifier).state = null;
  }

  @override
  void dispose() {
    Future.delayed(const Duration(milliseconds: 50), () {
      registerPreview();
    });
    super.dispose();
  }

  _scrollToBottomOfChat() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Chat Opened");

    Future.delayed(const Duration(milliseconds: 250), () {
      // debugPrint("Scrolling to Bottom");
      if (scrollController.hasClients) {
        _scrollToBottomOfChat();
      } else {
        debugPrint("ScrollController has not attached yet");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentChat == null) return Icons.error.toIcon();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black,
        actions: [
          Icons.info.toIcon().onClick(() async {
            // Chat? z = await Navigator.of(context).push(
            //   AdaptivePageRoute(
            //     builder: (context) => ChatDetails(chatModel: widget.chatModel),
            //   ),
            // );
            // setState(() {});
            final x =
                await Navigator.of(context).pushNewPage(const ChatDetails());
            setState(() {});
          }).addRightMargin(15),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(currentChat!.chatDP),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 200,
              // color: Colors.green,
              child: Text(
                currentChat!.chatName,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: const Color.fromRGBO(16, 16, 16, 1),
              child: StreamBuilder(
                stream: MessageEngine.getMessageStream(chatId: currentChat!.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ).limitSize(50, 50).center();
                  }
                  // log(snapshot.data!.docs.toString());
                  final List<MessageModel> messages =
                      snapshot.data!.docs.map((x) {
                    final m = MessageModel.fromMap(x.data());
                    return m;
                  }).toList();

                  if (messages.length > numOfMessages) {
                    //Autoscroll
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _scrollToBottomOfChat());
                  }
                  numOfMessages = messages.length;

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: numOfMessages,
                    itemBuilder: (context, index) {
                      final m = messages[index];
                      return MessageRenderer.renderMessage(m);
                    },
                  );
                },
              ),
            ),
          ),
          // StagedStateNotifierSection(updateState: () => setState(() {})),
          Container(
            color: const Color.fromARGB(255, 32, 32, 32),
            height: 70,
            child: Row(
              children: [
                MessageTextBox(controller: controller),
                const SizedBox(width: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MediaPickerCircularButton(
                    //   updateState: () => setState(() {}),
                    // ),
                    SendMessageCircularButton(
                      chatModel: currentChat!,
                      scrollController: scrollController,
                      controller: controller,
                      setState: setState,
                      originalContext: context,
                    ).addLeftMargin(3),
                  ].addHorizontalSpacing(5),
                )
              ],
            ).addHorizontalMargin(10),
          )
        ],
      ),
    );
  }
}
