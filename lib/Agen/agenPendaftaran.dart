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

class AgentPendaftaran extends Agent {
  AgentPendaftaran() {
    _initAgent();
  }
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  bool stop = false;
  int _estimatedTime = 5;
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
      case "update user":
        return updateUser(data, sender);
      case "update imam":
        return updateImam(data, sender);
      case "update gereja":
        return updateGereja(data, sender);
      case "add imam":
        return addImam(data, sender);
      case "add gereja":
        return addGereja(data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> updateUser(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);

    var update = await userCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));

    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> updateImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var update = await imamCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));
    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> updateGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var update = await gerejaCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));

    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> addImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var addImam = await imamCollection.insertOne({
      "email": data[0],
      "password": data[1],
      "idGereja": data[2],
      "name": data[3],
      "picture": "",
      "notelp": "",
      "statusPemberkatan": 0,
      "statusPerminyakan": 0,
      "statusTobat": 0,
      "statusPerkawinan": 0,
      "banned": 0,
      "notif": true,
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
      "updatedBy": data[5],
      "createdBy": data[5],
      "role": data[4]
    });
    if (addImam.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

/////////////////BELOM KELARRRRE
  Future<Message> addGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var addGereja = await gerejaCollection.insertOne({
      "nama": data[0],
      "address": data[1],
      "paroki": data[2],
      "lingkungan": data[3],
      "deskripsi": data[4],
      "lat": data[5],
      "lng": data[6],
      "gambar": "",
      "banned": 0,
      "createdAt": DateTime.now(),
      "createdBy": data[7],
      "updatedAt": DateTime.now(),
      "updatedBy": data[7]
    });

    if (addGereja.isSuccess) {
      Message message = Message(agentName, 'Agent Pencarian', "REQUEST",
          Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName + ' rejected task form $sender: ${task.action}');
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
    this.agentName = "Agent Pendaftaran";
    _plan = [
      Plan("update user", "REQUEST"),
      Plan("update imam", "REQUEST"),
      Plan("update gereja", "REQUEST"),
      Plan("add imam", "REQUEST"),
      Plan("add gereja", "REQUEST"),
      Plan("add aturan pelayanan", "INFORM"),
    ];
    _goals = [
      Goals("update user", String, 2),
      Goals("update imam", String, 2),
      Goals("update gereja", String, 2),
      Goals("add imam", String, 2),
      Goals("add gereja", String, 2),
      Goals("add aturan pelayanan", String, 2),
    ];
  }
}
