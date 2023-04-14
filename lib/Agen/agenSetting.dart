import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import '../view/login.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentSetting extends Agent {
  AgentSetting() {
    _initAgent();
  }
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  bool stop = false;
  int _estimatedTime = 10;
  List _Message = [];
  List _Sender = [];

  bool canPerformTask(dynamic message) {
    for (var p in _plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> receiveMessage(Message msg, String sender) {
    print(agentName + ' received message from $sender');
    _Message.add(msg);
    _Sender.add(sender);
    return performTask();
  }

  Future<dynamic> performTask() async {
    Message msgCome = _Message.last;

    String sender = _Sender.last;
    dynamic task = msgCome.task;

    var goalsQuest =
        _goals.where((element) => element.request == task.action).toList();
    int clock = goalsQuest[0].time;

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      timer.cancel();
      _estimatedTime++;
      MessagePassing messagePassing = MessagePassing();
      Message msg = overTime(task, sender);
      messagePassing.sendMessage(msg);
    });

    Message message;
    try {
      message = await action(task.action, msgCome, sender);
    } catch (e) {
      message = Message(
          agentName, sender, "INFORM", Tasks('lack of parameters', "failed"));
    }

    if (stop == false) {
      if (timer.isActive) {
        timer.cancel();
        bool checkGoals = false;
        if (message.task.data.runtimeType == String &&
            message.task.data == "failed") {
          MessagePassing messagePassing = MessagePassing();
          Message msg = rejectTask(msgCome, sender);
          return messagePassing.sendMessage(msg);
        } else {
          for (var g in _goals) {
            if (g.request == task.action &&
                g.goals == message.task.data.runtimeType) {
              checkGoals = true;
              break;
            }
          }

          if (checkGoals == true) {
            print(agentName + ' returning data to ${message.receiver}');
            MessagePassing messagePassing = MessagePassing();
            messagePassing.sendMessage(message);
          } else {
            rejectTask(message, sender);
          }
        }
      }
    }
  }

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "setting user":
        return settinganUser(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> settinganUser(dynamic data, String sender) async {
    await dotenv.load(fileName: ".env");
    var statusF = await Firebase.initializeApp();
    var statusM = await MongoDatabase.connect();
    WidgetsFlutterBinding.ensureInitialized();

    Message message =
        Message(agentName, sender, "INFORM", Tasks('status aplikasi', "oke"));
    return message;
  }

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        "Agent Akun",
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName +
        ' rejected task from $sender because not capable of doing: ${task.task.action} with protocol ${task.protocol}');
    return message;
  }

  Message overTime(dynamic task, sender) {
    Message message = Message(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName +
        ' rejected task from $sender because takes time too long: ${task.task.action}');
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Setting";
    _plan = [
      Plan("setting user", "REQUEST"),
    ];
    _goals = [
      Goals("setting user", String, _estimatedTime),
    ];
  }
}
