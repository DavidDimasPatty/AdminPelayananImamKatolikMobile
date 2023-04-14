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
      Message msg = overTime(msgCome, sender);
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
        return rejectTask(data, sender);
    }
  }

  Future<Message> cariGereja(String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find().toList();
    Message message =
        Message(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Message> cariGerejaTerakhir(String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection
        .find(where.sortBy("createdAt", descending: true).limit(1))
        .toList();

    Message message =
        Message(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
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
        Message(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Message> cariUser(String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find().toList();
    Message message =
        Message(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
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
        agentName,
        sender,
        "INFORM",
        Tasks('hasil pencarian', [
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
        agentName,
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
    this.agentName = "Agent Pencarian";
    plan = [
      Plan("cari gereja", "REQUEST"),
      Plan("cari gereja terakhir", "REQUEST"),
      Plan("cari imam", "REQUEST"),
      Plan("cari user", "REQUEST"),
      Plan("cari jumlah", "REQUEST")
    ];
    goals = [
      Goals("cari gereja", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari gereja terakhir", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari imam", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari user", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari jumlah", List<dynamic>, _estimatedTime)
    ];
  }
}
