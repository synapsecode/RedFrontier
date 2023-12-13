import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:redfrontier/common/widgets.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/screens/chat/individual_chat/individual_chat.dart';
import 'package:redfrontier/services/firestore.dart';
import 'package:redfrontier/services/messaging/helpers.dart';
import 'package:redfrontier/services/messaging/models/chat_engine.dart';
import 'package:redfrontier/services/messaging/models/chat_entity.dart';

class GenericMultiUserSelectorWidget extends StatefulWidget {
  final String searchField;
  final String Function(List<RedFrontierUser>) createActionLabel;
  final Function(List<RedFrontierUser>) onAction;
  final List ignoredFieldList;
  const GenericMultiUserSelectorWidget({
    Key? key,
    required this.searchField,
    required this.createActionLabel,
    required this.onAction,
    required this.ignoredFieldList,
  }) : super(key: key);

  @override
  State<GenericMultiUserSelectorWidget> createState() =>
      _GenericMultiUserSelectorWidgetState();
}

class _GenericMultiUserSelectorWidgetState
    extends State<GenericMultiUserSelectorWidget> {
  List<RedFrontierUser> selectedUsers = [];
  List<RedFrontierUser> allUsers = [];
  String query = '';

  fetchUsers() async {}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 20,
          right: 20,
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Positioned(
          // ignore: sort_child_properties_last
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  width: 300,
                  child: Material(
                    type: MaterialType.transparency,
                    child: RedFrontierTextField(
                      hintText: '  Search User',
                      centeredText: false,
                      onChanged: (x) {
                        setState(() => query = x);
                      },
                    ),
                  ),
                ),
                if (query != '') ...[
                  Container(
                    width: 300,
                    color: Colors.grey[300],
                    child: FutureBuilder(
                      future: FirestoreService.searchUserByEmail(query),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final x = snapshot.data!
                              .where((e) =>
                                  !widget.ignoredFieldList.contains(e.name))
                              .toList();
                          if (x.isNotEmpty) {
                            return Material(
                              color: Colors.grey[300],
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                shrinkWrap: true,
                                children: x
                                    .map(
                                      (u) => ListTile(
                                        onTap: () {
                                          log('TAP');
                                          if (selectedUsers
                                              .map((x) => x.id)
                                              .contains(u.id)) {
                                            selectedUsers.removeWhere(
                                                (e) => e.id == u.id);
                                          } else {
                                            selectedUsers.add(u);
                                          }

                                          setState(() {});
                                        },
                                        tileColor: selectedUsers
                                                .where((e) => e.id == u.id)
                                                .toList()
                                                .isNotEmpty
                                            ? Colors.green.withAlpha(40)
                                            : null,
                                        leading: CircleAvatar(
                                          backgroundImage: u.dp != null
                                              ? NetworkImage(u.dp!)
                                              : null,
                                        ),
                                        title: Text(u.name),
                                        subtitle: Text('redfrontier user'),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                  ).clip(10).addTopMargin(10).maxConstrain(null, 300),
                ],
                if (selectedUsers.isNotEmpty) ...[
                  Material(
                    color: Colors.grey[300],
                    child: Container(
                      width: 300,
                      height: 190,
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Selected Users")
                                .size(18)
                                .color(Colors.black87),
                            const SizedBox(height: 20),
                            ...selectedUsers
                                .map((u) => ListTile(
                                      leading: CircleAvatar(
                                          // backgroundImage:
                                          //     NetworkImage(u.profilePhoto),
                                          ),
                                      title: Text(u.name),
                                      subtitle: Text('redfrontier user'),
                                      trailing:
                                          Icons.cancel.toIcon().onClick(() {
                                        selectedUsers
                                            .removeWhere((e) => e.id == u.id);
                                        setState(() {});
                                      }),
                                    ))
                                .toList()
                          ],
                        ),
                      ),
                      // child: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     const Text("Selected Users")
                      //         .size(18)
                      //         .color(Colors.black87),
                      //     const SizedBox(height: 20),
                      //     ...selectedUsers
                      //         .map((u) => ListTile(
                      //               leading: CircleAvatar(
                      //                   backgroundImage:
                      //                       NetworkImage(u.profilePhoto)),
                      //               title: Text(u.name),
                      //               subtitle: Text(u.username),
                      //               trailing: Icons.cancel.toIcon().onClick(() {
                      //                 selectedUsers
                      //                     .removeWhere((e) => e.id == u.id);
                      //                 setState(() {});
                      //               }),
                      //             ))
                      //         .toList()
                      //   ],
                      // ),
                    ),
                  ).clip(10).addTopMargin(10),
                  Material(
                    color: Colors.blue[900],
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(20),
                      child: Text(widget.createActionLabel(selectedUsers))
                          .size(16)
                          .color(Colors.white70)
                          .center(),
                    ),
                  )
                      .onClick(() => widget.onAction(selectedUsers))
                      .clip(8)
                      .addTopMargin(10)
                ],
              ],
            ),
          ),
          top: 100,
          left: (MediaQuery.of(context).size.width - 300) / 2,
        )
      ],
    );
  }
}

class UserSearchWidget extends StatelessWidget {
  const UserSearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericMultiUserSelectorWidget(
      searchField: 'name',
      ignoredFieldList: [gpc.read(currentRFUserProvider)!.name],
      onAction: (selectedUsers) async {
        ChatEntity? chatEntity;
        if (selectedUsers.length > 1) {
          // Create Group Chat
          chatEntity = await ChatEngine.createGroupChat(
            selectedUsers,
          );
        } else {
          chatEntity =
              await ChatEngine.createIndividualChat(user: selectedUsers.first);
        }

        if (chatEntity == null) {
          log('ChatEntity was null. Aborting');
          return;
        }
        //Navigate to the Chat
        gpc.read(currentlyActiveChat.notifier).state = chatEntity;
        await ChatHelpers.setCurrentlyActiveChatMembers(
          chatEntity.memberIds,
        );
        Navigator.pop(context);
        Navigator.of(context).pushNewPage(const IndividualChat());
      },
      createActionLabel: (selectedUsers) =>
          "Create ${selectedUsers.length > 1 ? 'Group' : 'Chat'}",
    );
  }
}
