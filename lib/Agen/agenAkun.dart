// import 'dart:developer';

// import 'package:admin_pelayanan_katolik/DatabaseFolder/data.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import '../DatabaseFolder/mongodb.dart';
// import 'messages.dart';

// class AgenAkun {
//   AgenAkun() {
//     ResponsBehaviour();
//   }

//   ResponsBehaviour() async {
//     Messages msg = Messages();

//     var data = await msg.receive();
//     action() async {
//       try {
//         if (data.runtimeType == List<List<dynamic>>) {
//           if (await data[0][0] == "cari admin") {
//             // var userCollection =
//             //     await MongoDatabase.db.collection(ADMIN_COLLECTION);

//             await MongoDatabase.db
//                 .collection(ADMIN_COLLECTION)
//                 .find({'user': data[1][0], 'password': data[2][0]})
//                 .toList()
//                 .then((result) async {
//                   if (await result != 0) {
//                     msg.addReceiver("agenPage");
//                     msg.setContent(result);
//                     msg.send();
//                   } else {
//                     msg.addReceiver("agenPage");
//                     msg.setContent(result);
//                     msg.send();
//                   }
//                 });
//           }
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }

//   ReadyBehaviour() {
//     Messages msg = Messages();
//     var data = msg.receive();
//     action() {
//       try {
//         if (data == "ready") {
//           print("Agen Pencarian Ready");
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }
// }
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
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  List _Message = [];
  List _Sender = [];
  bool stop = false;
  int _estimatedTime = 5;

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
    Message msg = _Message.last;
    String sender = _Sender.last;
    dynamic task = msg.task;

    var goalsQuest =
        _goals.where((element) => element.request == task.action).toList();
    int clock = goalsQuest[0].time;

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      timer.cancel();

      MessagePassing messagePassing = MessagePassing();
      Message msg = rejectTask(task, sender);
      messagePassing.sendMessage(msg);
      return;
    });

    Message message = await action(task.action, task.data, sender);

    if (stop == false) {
      if (timer.isActive) {
        timer.cancel();
        bool checkGoals = false;
        if (message.task.data.runtimeType == String &&
            message.task.data == "failed") {
          MessagePassing messagePassing = MessagePassing();
          Message msg = rejectTask(task, sender);
          messagePassing.sendMessage(msg);
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
            rejectTask(task, sender);
          }
        }
      }
    }
  }

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "login":
        return login(data, sender);

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
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(agentName + ' rejected task form $sender: ${task.action}');
    return message;
  }

  Message overTime(sender) {
    Message message = Message(
        sender,
        agentName,
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Akun";
    _plan = [
      Plan("login", "REQUEST"),
    ];
    _goals = [
      Goals("login", List<Map<String, Object?>>, 2),
    ];
  }
}
