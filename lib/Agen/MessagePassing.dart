import 'package:admin_pelayanan_katolik/Agen/AgenPencarian.dart';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';

import 'package:admin_pelayanan_katolik/Agen/agenAkun.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPendaftaran.dart';
import 'package:admin_pelayanan_katolik/Agen/agenSetting.dart';

import 'Agent.dart';

class MessagePassing {
  //Kelas distributor pengiriman pesan antara agen
  //
  //Kumpulan agen yang dibuat pada sistem
  Map<String, Agent> agents = {'Agent Pencarian': agenPencarian(), 'Agent Pendaftaran': agenPendaftaran(), 'Agent Setting': agenSetting(), 'Agent Akun': agenAkun(), 'Agent Page': agenPage()};

  Future<dynamic> sendMessage(Messages message) async {
    //Fungsi pengiriman pesan dari agen pengirim kepada agen penerima
    if (agents.containsKey(message.receiver)) {
      //Jika agen penerima terdaftar pada map agents
      Agent? agent = agents[message.receiver];
      if (agent!.canPerformTask(message) == 1) {
        //jika agen bisa melakukan tugas yang berada dalam pesan yang dikirim
        //oleh agen pengirim, maka agen akan menerima pesan
        return await agent.receiveMessage(message, message.sender);
      } else if (agent.canPerformTask(message) == -1) {
        //jika agen tidak bisa melakukan tugas yang berada dalam pesan yang dikirim
        //oleh agen pengirim, maka agen akan menerima pesan
        Messages msg = agent.rejectTask(message, message.sender);
        return await sendMessage(msg);
      }
    } else {
      //Jika nama agen penerima tidak terdaftar dalam sistem
      print("Agen Not Found!");
      return null;
    }
  }
}
