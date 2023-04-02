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

  Future<dynamic> performTask(Message msg, String sender) async {
    print('Agent Pendaftaran received message from $sender');
    dynamic task = msg.task;
    for (var p in _plan) {
      if (p.goals == task.action) {
        Timer timer = Timer.periodic(Duration(seconds: p.time), (timer) {
          stop = true;
          timer.cancel();

          MessagePassing messagePassing = MessagePassing();
          Message msg = rejectTask(task, sender);
          messagePassing.sendMessage(msg);
        });

        Message message = await action(p.goals, task, sender);

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
                if (g.request == p.goals &&
                    g.goals == message.task.data.runtimeType) {
                  checkGoals = true;
                }
              }
              if (checkGoals == true) {
                print(
                    'Agent Pendaftaran returning data to ${message.receiver}');
                MessagePassing messagePassing = MessagePassing();
                messagePassing.sendMessage(message);
                break;
              } else {
                rejectTask(task, sender);
              }
              break;
            }
          }
        }
      }
    }
  }

  messageSetData(task) {
    pencarianData.add(task);
  }

  Future<List> getDataPencarian() async {
    return pencarianData;
  }

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "update user":
        return updateUser(data.data, sender);
      case "update imam":
        return updateImam(data.data, sender);
      case "update gereja":
        return updateGereja(data.data, sender);
      case "add imam":
        return addImam(data.data, sender);
      case "add gereja":
        return addGereja(data.data, sender);

      case "add aturan pelayanan":
        return addAturanPelayanan(data.data, sender);

      default:
        return rejectTask(data, data.sender);
    }
  }

  Future<Message> updateUser(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);

    var update = await userCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));

    if (update.isSuccess) {
      Message message =
          Message('Agent Pendaftaran', sender, "INFORM", Task('cari', "oke"));
      return message;
    } else {
      Message message = Message(
          'Agent Pendaftaran', sender, "INFORM", Task('cari', "failed"));
      return message;
    }
  }

  Future<Message> updateImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var update = await imamCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));
    if (update.isSuccess) {
      Message message =
          Message('Agent Pendaftaran', sender, "INFORM", Task('cari', "oke"));
      return message;
    } else {
      Message message = Message(
          'Agent Pendaftaran', sender, "INFORM", Task('cari', "failed"));
      return message;
    }
  }

  Future<Message> updateGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var update = await gerejaCollection.updateOne(where.eq('_id', data[0]),
        modify.set('banned', data[1]).set("updatedAt", DateTime.now()));

    if (update.isSuccess) {
      Message message =
          Message('Agent Pendaftaran', sender, "INFORM", Task('cari', "oke"));
      return message;
    } else {
      Message message = Message(
          'Agent Pendaftaran', sender, "INFORM", Task('cari', "failed"));
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
      "updatedBy": data[4]
    });
    if (addImam.isSuccess) {
      Message message =
          Message('Agent Pendaftaran', sender, "INFORM", Task('cari', "oke"));
      return message;
    } else {
      Message message = Message(
          'Agent Pendaftaran', sender, "INFORM", Task('cari', "failed"));
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
      Message message = Message('Agent Pendaftaran', 'Agent Pencarian',
          "REQUEST", Task('cari gereja terakhir', "oke"));
      return message;
    } else {
      Message message = Message(
          'Agent Pendaftaran', sender, "INFORM", Task('cari', "failed"));
      return message;
    }
  }

  Future<Message> addAturanPelayanan(dynamic data, String sender) async {
    var aturanCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);

    var addAturan = await aturanCollection.insertOne({
      "idGereja": data[0]['_id'],
      "baptis": "",
      "komuni": "",
      "krisma": "",
      "perkawinan": "",
      "perminyakan": "",
      "tobat": "",
      "pemberkatan": "",
      "updatedAt": DateTime.now(),
      "updatedBy": ObjectId(),
    });

    if (addAturan.isSuccess) {
      Message message =
          Message('Agent Pendaftaran', 'View', "INFORM", Task('cari', "oke"));
      return message;
    } else {
      Message message = Message(
          'Agent Pendaftaran', 'View', "INFORM", Task('cari', "failed"));
      return message;
    }
  }

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        "Agent Pendaftaran",
        sender,
        "INFORM",
        Task('error', [
          ['failed']
        ]));

    print('Task rejected $sender: $task');
    return message;
  }

  Message overTime(sender) {
    Message message = Message(
        sender,
        "Agent Pendaftaran",
        "INFORM",
        Task('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    _plan = [
      Plan("update user", "REQUEST", _estimatedTime),
      Plan("update imam", "REQUEST", _estimatedTime),
      Plan("update gereja", "REQUEST", _estimatedTime),
      Plan("add imam", "REQUEST", _estimatedTime),
      Plan("add gereja", "REQUEST", _estimatedTime),
      Plan("add aturan pelayanan", "INFORM", _estimatedTime),
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
