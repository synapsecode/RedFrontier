import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/services/messaging/helpers.dart';
import 'package:redfrontier/services/messaging/messaging.dart';

class MessageRenderer {
  static Widget renderMessage(MessageModel model) {
    Widget child = const SizedBox();

    final sender = gpc.read(currentlyActiveChatMembers)![model.authorUserID];
    // if (sender == null) return Icons.error.toIcon();

    if (model.type == 'text') {
      child = Text(model.text).color(Colors.white);
    }
    return Row(
      children: [
        if (sender?.id == gpc.read(currentRFUserProvider)!.id)
          Expanded(child: Container()),
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.grey[900],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sender?.name ?? '[deleted]')
                  .weight(FontWeight.bold)
                  .color(Colors.yellow),
              child.addTopMargin(10),
            ],
          ),
        ).clip(12),
        if (sender?.id != gpc.read(currentRFUserProvider)!.id)
          Expanded(child: Container()),
      ],
    ).addBottomMargin(10);
  }
}
