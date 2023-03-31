import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';

import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentB extends Agent {
  AgentB() : super('Agent B') {
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
    print('Agent B received message from $sender');

    Timer timer = Timer.periodic(Duration(seconds: _estimatedTime), (timer) {
      stop = true;
      timer.cancel();
      return overTime(sender);
    });
    // await Future.delayed(Duration(seconds: 3));

    for (var p in plan) {
      if (p.goals == task.action) {
        Message message = await p.actions;
        if (stop == false) {
          if (timer.isActive) {
            timer.cancel();

            bool checkGoals = false;
            for (var g in goals) {
              if (g.request == p.goals) {
                if (g.goals == message.task.data.runtimeType) {
                  checkGoals = true;
                  if (checkGoals == true) {
                    print(
                        'Agent B waited seconds and is returning data to ${message.receiver}');
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
      }
    }
  }

  Future<Message> SearchDb() async {
    await Future.delayed(Duration(seconds: 3));
    Message message = Message(
        'Agent B',
        'View',
        "INFORM",
        Task('search', [
          [1],
          [2]
        ]));
    return message;
  }

  void rejectTask(dynamic task) {
    print('Task rejected B: $task');
  }

  void overTime(sender) {
    Message message = Message(
        "Agent B",
        sender,
        "INFORM",
        Task('error', [
          ['reject over time']
        ]));
    MessagePassing messagePassing = MessagePassing();
    messagePassing.sendMessage(message);
  }

  void _initAgent() {
    plan = [Plan("searchDb", "REQUEST", SearchDb(), null)];
    goals = [Goals("searchDb", List<List<int>>, 2)];
  }
}
