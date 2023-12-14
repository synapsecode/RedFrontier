// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redfrontier/common/widgets.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/services/firestore/chats.dart';
import 'package:redfrontier/services/messaging/helpers.dart';
import 'package:redfrontier/services/messaging/models/chat_engine.dart';
import 'package:redfrontier/services/messaging/models/chat_entity.dart';
import '../all_chats/components.dart';

class ChatDetails extends ConsumerStatefulWidget {
  const ChatDetails({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends ConsumerState<ChatDetails> {
  TextEditingController nameController = TextEditingController();

  ChatEntity? get currentChat => ref.read(currentlyActiveChat);

  @override
  void initState() {
    super.initState();
    nameController.text = currentChat!.chatName;
  }

  editPfp() {
    //You cannot change the dp of an individual chat
    if (currentChat!.type == 'individual') return;
    // ToastContext().init(context);
    // MediaEngine.openMediaPicker(
    //   context: context,
    //   callback: (imgs) async {
    //     Toast.show('Uploading PFP!');
    //     if (imgs.isEmpty) return;
    //     //----------(Cropping)----------------
    //     final imgFile = imgs.first.file!;
    //     final croppedImg = await MediaEngine.cropImage(
    //       imgFile,
    //       CrezamAspectRatio.freestyle,
    //     );
    //     if (croppedImg == null) {
    //       return;
    //     }
    //     //-------------------------------------
    //     final src = await MediaEngine.uploadFile(croppedImg);
    //     print('Uploaded PFP & source is => $src');
    //     if (src == null) return;
    //     //Guards
    //     if (currentChat!.dpMap.isEmpty) return;
    //     currentChat!.dpMap['dp'] = src;
    //     await ChatEngine.updateChat(currentChat!);
    //     Toast.show('Changed DP!');
    //     setState(() {});
    //   },
    //   mediaType: CustomMediaType.image,
    // );
  }

  editName() async {
    if (currentChat!.type == 'individual') return;
    showDialog(
      context: context,
      builder: (context) {
        nameController.text = currentChat!.chatName;
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text("Edit Chat Name"),
          content: SizedBox(
            width: 300,
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RedFrontierTextField(
                    controller: nameController,
                    hintText: '  Edit Chat Name',
                    centeredText: false,
                    onChanged: (x) {},
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      currentChat!.name = nameController.value.text;
                      await ChatEngine.updateChat(currentChat!);
                      setState(() {});

                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text("Update"),
                  )
                      .primaryColor(Colors.black)
                      .limitSize(double.infinity, 60)
                      .addTopMargin(10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  deleteChat() async {
    int count = 0;
    await ChatEngine.deleteChat(currentChat!);
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  addMember() async {
    final members = gpc.read(currentlyActiveChatMembers);
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      builder: (context) {
        return GenericMultiUserSelectorWidget(
          searchField: 'name',
          ignoredFieldList: members!.values.map((x) => x.name).toList(),
          onAction: (selectedUsers) async {
            final sids = selectedUsers.map((x) => x.id).toList();
            currentChat!.memberIds = [...currentChat!.memberIds, ...sids];
            await ChatEngine.updateChat(currentChat!);
            await ChatHelpers.setCurrentlyActiveChatMembers(
                currentChat!.memberIds);
            Navigator.pop(context);
            setState(() {});
          },
          createActionLabel: (s) => 'Add Member${s.length > 1 ? "s" : ""}',
        );
      },
    );
  }

  removeMember(String memberID) async {
    log('Removing Member');

    currentChat!.memberIds =
        currentChat!.memberIds.where((e) => e != memberID).toList();

    await ChatEngine.updateChat(currentChat!);
    await ChatHelpers.setCurrentlyActiveChatMembers(currentChat!.memberIds);

    if (memberID == ref.read(currentRFUserProvider)!.id) {
      //User is leaving group
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
    } else {
      //Admin is removing other user
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, currentChat);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Chat Details'),
          backgroundColor: Colors.grey[900],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(currentChat!.chatDP),
              ).onClick(editPfp),
              const SizedBox(height: 20),
              Text(currentChat!.chatName)
                  .size(40)
                  .color(Colors.white)
                  .weight(FontWeight.bold)
                  .align(TextAlign.center)
                  .onClick(
                    editName,
                  ),
              const SizedBox(height: 10),
              Text("${currentChat!.type} Chat ${currentChat!.type == 'group' ? '  |  ${currentChat!.memberIds.length} participant${currentChat!.memberIds.length > 1 ? 's' : ''}' : ''}"
                      .capitalize())
                  .size(20)
                  .color(Colors.white54),
              const SizedBox(height: 20),
              //MemberViewerSection
              if (currentChat!.type == 'group')
                FutureBuilder(
                  future: FirestoreChatService.fetchUsersByIDList(
                    currentChat!.memberIds.map((x) => x.toString()).toList(),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      );
                    }

                    return Column(
                      children: [
                        ...snapshot.data!
                            .map((e) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: e.dp == null
                                        ? null
                                        : NetworkImage(e.dp!),
                                  ),
                                  title: Text(e.name).color(Colors.white),
                                  trailing: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //User Specific Actions
                                      if (e.id ==
                                          gpc
                                              .read(currentRFUserProvider)!
                                              .id) ...[
                                        Icons.logout
                                            .toIcon(color: Colors.white)
                                            .onClick(() => removeMember(e.id)),
                                      ] else ...[
                                        Icons.delete
                                            .toIcon(color: Colors.white)
                                            .onClick(() => removeMember(e.id)),
                                      ],
                                    ],
                                  ),
                                ))
                            .toList()
                      ],
                    );
                  },
                ).addBottomMargin(20),

              Wrap(
                spacing: 10,
                runSpacing: 5,
                alignment: WrapAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentChat!.type == 'group')
                    ElevatedButton(
                      onPressed: addMember,
                      child: const Text('Add Member'),
                    ).addRightMargin(10),
                  ElevatedButton(
                    onPressed: deleteChat,
                    child: Text(
                        'Delete ${currentChat!.type == 'group' ? 'Group' : 'Chat'}'),
                  ),
                ],
              ),
            ],
          ).center(),
        ),
      ),
    );
  }
}
