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

  @override
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

  @override
  addEstimatedTime() {
    _estimatedTime++;
  }

  void _initAgent() {
    agentName = "Agent Akun";
    plan = [
      Plan("login", "REQUEST"),
    ];
    goals = [
      Goals("login", List<Map<String, Object?>>, _estimatedTime),
    ];
  }
}
