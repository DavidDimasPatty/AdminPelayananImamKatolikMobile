import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Goals.dart';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/Plan.dart';
import 'package:admin_pelayanan_katolik/Agen/Task.dart';

abstract class Agent {
  List<Plan> //nama agen
      plan = [];
  List<Goals> //Perencanaan agen
      goals = [];
  List MessageList = [];
  List Senders = [];
  String agentName = "";
  bool stop = false;

  int canPerformTask(Messages message) {
    //Fungsi untuk melakukan pengecekan pada plan agen terhadap
    //tugas yang berada dalam pesan
    if (message.task.action == "error") {
      print(this.agentName + " get error messages");
      //Jika terdapat pesan error dari agen lain
      return -2;
    } else {
      for (var p in plan) {
        if (p.goals == message.task.action && p.protocol == message.protocol) {
          //Jika bisa mengerjakan tugas
          return 1;
        }
      }
    }
    return -1;
  }

  Future<dynamic> receiveMessage(Messages msg, String sender) {
    //Fungsi agen menerima pesan yang dikirim oleh agen pengirim
    print(agentName + ' received message from $sender');
    //Menambahkan pesan dan nama pengirim ke variabel
    MessageList.add(msg);
    Senders.add(sender);
    //Mengembalikan fungsi performTask
    return performTask();
  }

  Future<dynamic> performTask() async {
    //Fungsi agen mengerjakan tugas yang berada dalam pesan
    Messages msgCome = MessageList.last;
    String sender = Senders.last;
    dynamic task = msgCome.task;
    //Mengektifitaskan pemanggilan variabel
    var goalsQuest = goals.where((element) => element.request == task.action).toList();
    int clock = goalsQuest[0].time as int;
    //Mendapatkan batas waktu pengerjaan dalam goals terhadap tugas

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      timer.cancel(); //memberhentikan timer
      addEstimatedTime(task.action); //menambahkan waktu pengerjaan terhadap tugas tersebut
      MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
      Messages msg = overTime(msgCome, sender); //Mengirim pesan overtime
      messagePassing.sendMessage(msg);
    });
    //Timer pengerjaan tugas agen
    Messages message;
    try {
      message = await action(task.action, msgCome, sender);
      //Memanggil fungsi action untuk memilih tindakan yang dikerjakan
    } catch (e) {
      message = Messages(agentName, sender, "INFORM", Tasks('lack of parameters', "failed"));
      //Jika terdapat error dalam pengerjaan maka pesan gagal
    }

    if (stop == false) {
      if (timer.isActive) {
        timer.cancel();
        bool checkGoals = false;
        if (message.task.data.runtimeType == String && message.task.data == "failed") {
          MessagePassing messagePassing = MessagePassing();
          Messages msg = rejectTask(msgCome, sender);
          return messagePassing.sendMessage(msg);
        } else {
          for (var g in goals) {
            if (g.request == task.action && g.goals == message.task.data.runtimeType) {
              checkGoals = true;
              break;
            }
          }

          if (message.task.action == "done") {
            print(agentName + " Success doing coordination with another agent for task ${task.action}");
            return null;
          } else if (checkGoals == true) {
            print(agentName + ' returning data to ${message.receiver}');
            MessagePassing messagePassing = MessagePassing();
            return messagePassing.sendMessage(message);
          } else if (checkGoals == false) {
            MessagePassing messagePassing = MessagePassing();
            Messages msg = failedGoal(msgCome, sender);
            return messagePassing.sendMessage(msg);
          }
        }
      }
    }
  }

  Messages rejectTask(dynamic task, sender) {
    print(task.task.action);
    Messages message = Messages(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(agentName + ' rejected task from $sender because not capable of doing: ${task.task.action} with protocol ${task.protocol}');
    return message;
  }

  Messages overTime(dynamic task, sender) {
    Messages message = Messages(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(agentName + ' rejected task from $sender because takes time too long: ${task.task.action}');
    return message;
  }

  Messages failedGoal(dynamic task, sender) {
    Messages message = Messages(agentName, sender, "INFORM", Tasks('error', 'failed'));

    print(agentName + " rejecting task from $sender because the result of ${task.task.action} dataType does'nt suit the goal from ${agentName}");
    return message;
  }

  action(String goals, dynamic data, String sender);
  addEstimatedTime(String goals);
}
