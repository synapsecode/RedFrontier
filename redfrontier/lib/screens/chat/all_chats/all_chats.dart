import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/screens/chat/all_chats/components.dart';
import 'package:redfrontier/screens/chat/individual_chat/individual_chat.dart';
import 'package:redfrontier/services/messaging/helpers.dart';
import 'package:redfrontier/services/messaging/models/chat_engine.dart';
import 'package:redfrontier/services/messaging/models/chat_entity.dart';

class AllChatsScreen extends StatelessWidget {
  final bool partOfFragment;
  const AllChatsScreen({super.key, this.partOfFragment = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AllChatsFragment(
        partOfFragment: partOfFragment,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            barrierColor: Colors.black45,
            context: context,
            builder: (context) {
              return const UserSearchWidget();
            },
          );
        },
        child: Icons.add.toIcon(color: Colors.white),
      ),
    );
  }
}

class AllChatsFragment extends StatelessWidget {
  final bool partOfFragment;
  const AllChatsFragment({super.key, this.partOfFragment = false});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // height: heigth * 0.95,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.fromLTRB(
              width / 20,
              heigth / 25,
              width / 20,
              0,
            ), //!Ideal width: 10
            decoration: const BoxDecoration(
              color: Color.fromRGBO(5, 16, 32, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white70,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              children: [
                if (partOfFragment) SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!partOfFragment)
                      Icons.arrow_back_ios
                          .toIcon(color: Colors.white)
                          .addHorizontalMargin(20)
                          .onClick(() {
                        Navigator.pop(context);
                      }),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          'CHATS',
                          style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ).addRightMargin(partOfFragment ? 0 : 55),
                      ),
                    ),
                  ],
                ).addBottomMargin(partOfFragment ? 20 : 10),
                Expanded(
                  child: StreamBuilder(
                    stream: ChatEngine.getChatStream(
                        gpc.read(currentRFUserProvider)!.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('No Chats found')
                            .color(Colors.white60)
                            .center();
                      }
                      final chats = snapshot.data!.docs
                          .map((x) =>
                              ChatEntity.fromMap({'id': x.id, ...x.data()}))
                          .toList();
                      return ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10),
                        children: chats.map((chat) {
                          return ChatTile(entity: chat);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const Color COLOR = Color.fromRGBO(8, 49, 106, 1);
const Color COLOR2 = Color.fromRGBO(97, 93, 125, 1);

class ChatTile extends StatelessWidget {
  final ChatEntity entity;
  const ChatTile({
    super.key,
    required this.entity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height / 10,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: COLOR2,
          ),
        ),
      ),
      child: ListTile(
        onTap: () async {
          gpc.read(currentlyActiveChat.notifier).state = entity;
          await ChatHelpers.setCurrentlyActiveChatMembers(
            entity.memberIds,
          );
          Navigator.of(context).pushNewPage(const IndividualChat());
        },
        tileColor: Colors.transparent,
        leading: CircleAvatar(
          backgroundColor: COLOR,
          // child: Icon(Icons.person),
          radius: 24,
          backgroundImage: NetworkImage(entity.chatDP),
        ),
        title:
            Text(entity.chatName).weight(FontWeight.bold).color(Colors.white),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (entity.preview.senderName != null &&
                entity.preview.senderName != '')
              Text("${entity.preview.senderName!}: ").color(Colors.yellow[50]!),
            Text(entity.preview.preview)
                .color(Colors.white60)
                .wrap(TextOverflow.ellipsis)
                .expanded(),
          ],
        ).addVerticalMargin(5),
        trailing: Text(entity.preview.timestamp).size(10).color(Colors.white60),
      ),
    );
  }
}

const Color RCOLOR = Color.fromRGBO(96, 92, 128, 1);

class Round extends StatelessWidget {
  final Color color;
  final double padding;
  final Widget child;
  const Round(
      {super.key,
      this.color = RCOLOR,
      required this.padding,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: child);
  }
}
