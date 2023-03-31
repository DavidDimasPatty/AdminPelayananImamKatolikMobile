import 'dart:async';

import 'Messages.dart';

abstract class Agent {
  String name;

  Agent(this.name) {}

  bool canPerformTask(dynamic task);

  Future<dynamic> performTask(dynamic task, String sender);

  void rejectTask(dynamic task);
}
