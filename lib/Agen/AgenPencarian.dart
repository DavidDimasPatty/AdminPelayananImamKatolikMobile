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
  static Map<String, int> _timeAction = {
    "cari gereja": _estimatedTime,
    "cari gereja terakhir": _estimatedTime,
    "cari imam": _estimatedTime,
    "cari user": _estimatedTime,
    "cari jumlah": _estimatedTime
  };

  @override
  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "cari gereja":
        return _cariGereja(sender);

      case "cari imam":
        return _cariImam(sender);

      case "cari user":
        return _cariUser(sender);

      case "cari jumlah":
        return _cariJumlah(sender);

      case "cari gereja terakhir":
        return _cariGerejaTerakhir(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> _cariGereja(String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find().toList();
    Message message =
        Message(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Message> _cariGerejaTerakhir(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection
        .find(where.sortBy("createdAt", descending: true).limit(1))
        .toList();
    Completer<void> completer = Completer<void>();
    Message message2 = Message(agentName, sender, "INFORM",
        Tasks('add aturan pelayanan', [data, conn]));
    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message2);
    Message message = Message(
        agentName, sender, "INFORM", Tasks('wait Agent Pendaftaran', null));
    completer.complete();

    await completer.future;
    return message;
  }

  Future<Message> _cariImam(String sender) async {
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

  Future<Message> _cariUser(String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find().toList();
    Message message =
        Message(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Message> _cariJumlah(String sender) async {
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

  @override
  addEstimatedTime(String goals) {
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    agentName = "Agent Pencarian";
    plan = [
      Plan("cari gereja", "REQUEST"),
      Plan("cari gereja terakhir", "REQUEST"),
      Plan("cari imam", "REQUEST"),
      Plan("cari user", "REQUEST"),
      Plan("cari jumlah", "REQUEST")
    ];
    goals = [
      Goals("cari gereja", List<Map<String, Object?>>,
          _timeAction["cari gereja"]),
      Goals("cari gereja terakhir", List<dynamic>,
          _timeAction["cari gereja terakhir"]),
      Goals("cari imam", List<Map<String, Object?>>, _timeAction["cari imam"]),
      Goals("cari user", List<Map<String, Object?>>, _timeAction["cari user"]),
      Goals("cari jumlah", List<dynamic>, _timeAction["cari jumlah"])
    ];
  }
}
