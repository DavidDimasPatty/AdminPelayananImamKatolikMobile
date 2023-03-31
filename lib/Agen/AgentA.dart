import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';

import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentA extends Agent {
  AgentA() : super('Agent A') {
    _initAgent();
  }
  List<Plan> plan = [];
  List<Goals> goals = [];
  int _estimatedTime = 5;
  bool stop = false;

  bool canPerformTask(dynamic message) {
    for (var p in plan) {
      if (p.goals == message.task.action) {
        if (p.protocol == message.protocol) {
          return true;
        }
        return false;
      }
      return false;
    }
    return false;
  }

  Future<dynamic> performTask(dynamic task, String sender) async {
    print('Agent A received message from $sender');

    for (var p in plan) {
      if (p.goals == task.action) {
        Timer timer =
            Timer.periodic(Duration(seconds: _estimatedTime), (timer) {
          stop = true;
          timer.cancel();
          return overTime(sender);
        });

        Message message = await p.actions;

        if (stop == false) {
          if (timer.isActive) {
            timer.cancel();
            bool checkGoals = false;

            for (var g in goals) {
              if (g.request == p.goals &&
                  g.goals == message.task.data.runtimeType) {
                checkGoals = true;
              }
            }
            if (checkGoals == true) {
              print(
                  'Agent A waited seconds and is returning data to ${message.receiver}');
              MessagePassing messagePassing = MessagePassing();
              messagePassing.sendMessage(message);
              break;
            } else {
              rejectTask(task);
            }
            break;
          }
        }
      }
    }
  }

  Future<Message> cariGereja() async {
    var userCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await userCollection.find().toList();
    Message message = Message('Agent A', 'View', "INFORM", Task('cari', conn));
    return message;
  }

  void rejectTask(dynamic task) {
    print('Task rejected A: $task');
  }

  void overTime(sender) {
    Message message = Message(
        sender,
        "Agent A",
        "INFORM",
        Task('error', [
          ['reject over time']
        ]));
    MessagePassing messagePassing = MessagePassing();
    messagePassing.sendMessage(message);
  }

  void _initAgent() {
    plan = [Plan("cari gereja", "REQUEST", cariGereja(), null)];
    goals = [Goals("cari gereja", List<Map<String, Object?>>, 2)];
  }
}
