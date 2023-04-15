import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/DatabaseFolder/modelDB.dart';
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
  static int _estimatedTime = 5;

  @override
  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "update user":
        return updateUser(data.task.data, sender);
      case "update imam":
        return updateImam(data.task.data, sender);
      case "update gereja":
        return updateGereja(data.task.data, sender);
      case "add imam":
        return addImam(data.task.data, sender);
      case "add gereja":
        return addGereja(data.task.data, sender);

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
    var configJson = modelDB.imam(data[0], data[1], data[2], data[3], "", "", 0,
        data[4], 1, 1, 1, 1, DateTime.now(), DateTime.now(), data[5], data[5]);

    var addImam = await imamCollection.insertOne(configJson);

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

  Future<Message> addGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var configJson = modelDB.Gereja(
        data[0],
        data[1],
        data[2],
        data[3],
        data[4],
        data[5],
        data[6],
        0,
        "",
        DateTime.now(),
        data[7],
        DateTime.now(),
        data[7]);

    var addGereja = await gerejaCollection.insertOne(configJson);

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

  @override
  addEstimatedTime() {
    _estimatedTime++;
  }

  void _initAgent() {
    agentName = "Agent Pendaftaran";
    plan = [
      Plan("update user", "REQUEST"),
      Plan("update imam", "REQUEST"),
      Plan("update gereja", "REQUEST"),
      Plan("add imam", "REQUEST"),
      Plan("add gereja", "REQUEST"),
      Plan("add aturan pelayanan", "INFORM"),
    ];
    goals = [
      Goals("update user", String, _estimatedTime),
      Goals("update imam", String, _estimatedTime),
      Goals("update gereja", String, _estimatedTime),
      Goals("add imam", String, _estimatedTime),
      Goals("add gereja", String, _estimatedTime),
      Goals("add aturan pelayanan", String, _estimatedTime),
    ];
  }
}
