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
  List _dataProcess = [];
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
    print('Agent Pendaftaran received message from $sender');

    for (var p in _plan) {
      if (p.goals == task.action) {
        Timer timer = Timer.periodic(Duration(seconds: p.time), (timer) {
          stop = true;
          timer.cancel();

          MessagePassing messagePassing = MessagePassing();
          Message msg = rejectTask(task, sender);
          messagePassing.sendMessage(msg);
        });
        _dataProcess.add(task.data);

        Message message = await action(p.goals, task);

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

  Future<Message> action(String goals, dynamic data) async {
    switch (goals) {
      case "update user":
        return updateUser(data);

      default:
        return rejectTask(data.task, data.sender);
    }
  }

  Future<Message> updateUser(dynamic data) async {
    if (_dataProcess.isNotEmpty) {
      var userCollection = MongoDatabase.db.collection(USER_COLLECTION);

      var update = await userCollection.updateOne(
          where.eq('_id', _dataProcess.last),
          modify.set(
              'banned', _dataProcess.elementAt(_dataProcess.length - 1)));

      if (update.isSuccess) {
        Message message =
            Message('Agent Pendaftaran', 'View', "INFORM", Task('cari', "oke"));
        return message;
      } else {
        Message message = Message(
            'Agent Pendaftaran', 'View', "INFORM", Task('cari', "failed"));
        return message;
      }
    }
    return rejectTask("update user", "View");
  }

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        "Agent Pendaftaran",
        sender,
        "INFORM",
        Task('error', [
          ['failed']
        ]));

    print('Task rejected Pendaftaran: $task');
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
    ];
    _goals = [
      Goals("update user", String, 2),
    ];
  }
}


//  if (data[0][0] == "update user") {
//           var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//           try {
//             var update = await userCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('banned', data[2][0]))
//                 .then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('fail');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "update gereja") {
//           var userCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
//           try {
//             var update = await userCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('banned', data[2][0]))
//                 .then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('fail');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "update imam") {
//           var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//           var GerejarCollection =
//               MongoDatabase.db.collection(GEREJA_COLLECTION);
//           try {
//             var update = await userCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('banned', data[2][0]))
//                 .then((result) async {
//               if (result.isSuccess) {
//                 await msg.addReceiver("agenPage");
//                 await msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 await msg.addReceiver("agenPage");
//                 await msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('fail');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "add gereja") {
//           var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
//           var aturanCollection =
//               MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
//           try {
//             var hasil = await gerejaCollection.insertOne({
//               "nama": data[1][0],
//               "address": data[2][0],
//               "paroki": data[3][0],
//               "lingkungan": data[4][0],
//               "deskripsi": data[5][0],
//               "lat": data[6][0],
//               "lng": data[7][0],
//               "gambar": "",
//               "banned": 0,
//               "createdAt": DateTime.now(),
//             }).then((result) async {
//               try {
//                 var find = await gerejaCollection
//                     .find(where.sortBy("createdAt", descending: true).limit(1))
//                     .toList()
//                     .then((result2) async {
//                   print("objectaWWDDDDDDDDDDD");
//                   print(result2);
//                   var addAturan = await aturanCollection.insertOne({
//                     "idGereja": result2[0]['_id'],
//                     "baptis": "",
//                     "komuni": "",
//                     "krisma": "",
//                     "perkawinan": "",
//                     "perminyakan": "",
//                     "tobat": "",
//                     "pemberkatan": "",
//                     "updatedAt": DateTime.now(),
//                     "updatedBy": ObjectId(),
//                   }).then((result3) async {
//                     if (result3.isSuccess) {
//                       msg.addReceiver("agenPage");
//                       msg.setContent('oke');
//                       await msg.send();
//                     } else {
//                       msg.addReceiver("agenPage");
//                       msg.setContent('failed');
//                       await msg.send();
//                     }
//                   });
//                 });
//               } catch (e) {
//                 print(e);
//                 msg.addReceiver("agenPage");
//                 msg.setContent('fail');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('fail');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "add imam") {
//           var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//           try {
//             var hasil = await userCollection.insertOne({
//               "email": data[1][0],
//               "password": data[2][0],
//               "idGereja": data[3][0],
//               "name": data[4][0],
//               "picture": "",
//               "notelp": "",
//               "statusPemberkatan": 0,
//               "statusPerminyakan": 0,
//               "statusTobat": 0,
//               "statusPerkawinan": 0,
//               "banned": 0,
//               "notif": true
//             }).then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('fail');
//             await msg.send();
//           }
//         }