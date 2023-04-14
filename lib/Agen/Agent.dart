import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Goals.dart';
import 'package:admin_pelayanan_katolik/Agen/Plan.dart';

import 'Message.dart';

abstract class Agent {
  List<Plan> plan = [];
  List<Goals> goals = [];
  List Messages = [];
  List Senders = [];
  String agentName = "";
  bool stop = false;

  bool canPerformTask(dynamic task);

  Future<dynamic> receiveMessage(Message msg, String sender);

  Future<dynamic> performTask();

  Message rejectTask(dynamic task, String sender);
  Message overTime(dynamic task, sender);
  action(String goals, dynamic data, String sender);
}
