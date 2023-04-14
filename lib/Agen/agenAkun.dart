import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentAkun extends Agent {
  AgentAkun() {
    _initAgent();
  }

  static int _estimatedTime = 5;

  bool canPerformTask(dynamic message) {
    for (var p in plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> receiveMessage(Message msg, String sender) {
    print(agentName + ' received message from $sender');
    Messages.add(msg);
    Senders.add(sender);
    return performTask();
  }

  Future<dynamic> performTask() async {
    Message msgCome = Messages.last;

    String sender = Senders.last;
    dynamic task = msgCome.task;

    var goalsQuest =
        goals.where((element) => element.request == task.action).toList();
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
          for (var g in goals) {
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
      case "login":
        return login(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> login(dynamic data, String sender) async {
    var adminCollection = await MongoDatabase.db.collection(ADMIN_COLLECTION);

    var conn = await adminCollection
        .find({'user': data[0], 'password': data[1]}).toList();

    Message message = Message(agentName, sender, "INFORM",
        Tasks('status modifikasi/ pencarian data akun', conn));
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
    this.agentName = "Agent Akun";
    this.plan = [
      Plan("login", "REQUEST"),
    ];
    this.goals = [
      Goals("login", List<Map<String, Object?>>, _estimatedTime),
    ];
  }
}
