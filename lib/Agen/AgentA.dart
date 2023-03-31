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
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
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
              print('Agent A returning data to ${message.receiver}');
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

  Future<Message> cariImam() async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'imamGereja'))
        .build();
    var conn = await userCollection.aggregateToStream(pipeline4).toList();
    Message message = Message('Agent A', 'View', "INFORM", Task('cari', conn));
    return message;
  }

  Future<Message> cariUser() async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find().toList();
    Message message = Message('Agent A', 'View', "INFORM", Task('cari', conn));
    return message;
  }

  Future<Message> cariJumlah() async {
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
    // conn,
    // result,
    // connBan,
    // connG,
    // connUnG,
    // connBanG,
    // connI,
    // connUnI,
    // connBanI

    Message message = Message(
        'Agent A',
        'View',
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
    plan = [
      Plan("cari gereja", "REQUEST", cariGereja(), null),
      Plan("cari imam", "REQUEST", cariImam(), null),
      Plan("cari user", "REQUEST", cariUser(), null),
      Plan("cari jumlah", "REQUEST", cariJumlah(), null)
    ];
    goals = [
      Goals("cari gereja", List<Map<String, Object?>>, 2),
      Goals("cari imam", List<Map<String, Object?>>, 2),
      Goals("cari user", List<Map<String, Object?>>, 2),
      Goals("cari jumlah", List<dynamic>, 2)
    ];
  }
}
