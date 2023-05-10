import 'dart:async';

import 'package:admin_pelayanan_katolik/Agen/Message.dart';

import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPage extends Agent {
  AgentPage() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }
  static List<dynamic> dataView = [];
  @override
  int canPerformTask(Message message) {
    //Karena data error tetap diterima oleh agen Page maka
    //fungsi canPerformTask di override oleh agen Page
    if (message.task.action == "error") {
      return 1;
    } else {
      for (var p in plan) {
        if (p.goals == message.task.action && p.protocol == message.protocol) {
          return 1;
        }
      }
    }
    return -1;
  }

  @override
  Future performTask() async {
    //Karena agen page tidak mengecek goals maka
    //fungsi performTask override fungsi supercla
    Message msg = Messages.last;
    String sender = Senders.last;
    dynamic task = msg.task;
    for (var p in plan) {
      action(p.goals, task.data, sender);
      print("View can use data store in " + agentName);
    }
  }

  static _messageSetData(task) {
    //Menyimpan data pada list
    dataView.add(task);
  }

  static Future getData() async {
    //Fungsi untuk view mengambil data yang tersedia
    //pada agen Page
    return dataView.last;
  }

  void _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Page";
    //nama agen
    plan = [
      Plan("status modifikasi data", "INFORM"), //come from agen Pendaftaran
      Plan("hasil pencarian", "INFORM"), //come from agen Pencarian
      Plan("status aplikasi", "INFORM"), //come from agen Setting
      Plan("status modifikasi/ pencarian data akun",
          "INFORM"), //come from agen Akun
      Plan("error", "INFORM")
    ];
    //Perencanaan agen
    goals = [
      Goals("status modifikasi data", String, 5),
      Goals("hasil pencarian", String, 5),
      Goals("status aplikasi", String, 5),
      Goals("status modifikasi/ pencarian data akun", String, 5),
      Goals("error", String, 1),
    ];
  }

  @override
  action(String goals, data, String sender) {
    _messageSetData(data);
  }

  @override
  Message overTime(task, sender) {
    // TODO: implement overTime
    throw UnimplementedError();
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik

    // TODO: implement addEstimatedTime
    throw UnimplementedError();
  }
}
