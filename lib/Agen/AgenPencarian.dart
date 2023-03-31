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

class AgentPencarian extends Agent {
  AgentPencarian() {
    _initAgent();
  }

  List<Plan> _plan = [];
  List<Goals> _goals = [];
  int _estimatedTime = 5;
  bool stop = false;

  bool canPerformTask(dynamic message) {
    for (var p in _plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> performTask(dynamic task, String sender) async {
    print('Agent Pencarian received message from $sender');

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
                print('Agent Pencarian returning data to ${message.receiver}');
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

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "cari gereja":
        return cariGereja(sender);

      case "cari imam":
        return cariImam(sender);

      case "cari user":
        return cariUser(sender);

      case "cari jumlah":
        return cariJumlah(sender);

      case "cari gereja terakhir":
        return cariGerejaTerakhir(sender);

      default:
        return rejectTask(data.task, data.sender);
    }
  }

  Future<Message> cariGereja(String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find().toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Task('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariGerejaTerakhir(String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection
        .find(where.sortBy("createdAt", descending: true).limit(1))
        .toList();

    Message message =
        Message('Agent Pencarian', sender, "INFORM", Task('cari', conn));
    return message;
  }

  Future<Message> cariImam(String sender) async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'imamGereja'))
        .build();
    var conn = await userCollection.aggregateToStream(pipeline4).toList();
    Message message =
        Message('Agent Pencarian', sender, "INFORM", Task('cari', conn));
    return message;
  }

  Future<Message> cariUser(String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find().toList();
    Message message =
        Message('Agent Pencarian', sender, "INFORM", Task('cari', conn));
    return message;
  }

  Future<Message> cariJumlah(String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.find().length;

    var connBan = await userCollection.find({'banned': 1}).length;

    var connG = await gerejaCollection.find().length;

    var connBanG = await gerejaCollection.find({'banned': 1}).length;

    var connUnG = await gerejaCollection.find({'banned': 0}).length;

    var connI = await imamCollection.find().length;

    var connBanI = await imamCollection.find({'banned': 1}).length;

    var connUnI = await imamCollection.find({'banned': 0}).length;

    var connUn = await userCollection.find({'banned': 0}).length;

    Message message = Message(
        'Agent Pencarian',
        sender,
        "INFORM",
        Task('cari', [
          conn,
          connUn,
          connBan,
          connG,
          connUnG,
          connBanG,
          connI,
          connUnI,
          connBanI
        ]));
    return message;
  }

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        "Agent Pencarian",
        sender,
        "INFORM",
        Task('error', [
          ['failed']
        ]));

    print('Task rejected A: $task');
    return message;
  }

  Message overTime(sender) {
    Message message = Message(
        sender,
        "Agent Pencarian",
        "INFORM",
        Task('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    _plan = [
      Plan("cari gereja", "REQUEST", _estimatedTime),
      Plan("cari imam", "REQUEST", _estimatedTime),
      Plan("cari user", "REQUEST", _estimatedTime),
      Plan("cari jumlah", "REQUEST", _estimatedTime)
    ];
    _goals = [
      Goals("cari gereja", List<Map<String, Object?>>, 2),
      Goals("cari imam", List<Map<String, Object?>>, 2),
      Goals("cari user", List<Map<String, Object?>>, 2),
      Goals("cari jumlah", List<dynamic>, 2)
    ];
  }
}
