import 'package:admin_pelayanan_katolik/Agen/Message.dart';

import 'Messages.dart';

class Plan {
  String goals;
  String protocol;
  final Future<Message> actions;
  dynamic constraints;

  Plan(this.goals, this.protocol, this.actions, this.constraints);
}
