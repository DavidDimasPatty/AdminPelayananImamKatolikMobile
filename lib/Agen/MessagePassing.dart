import 'package:admin_pelayanan_katolik/Agen/AgenPencarian.dart';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';

import 'package:admin_pelayanan_katolik/Agen/agenAkun.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPendaftaran.dart';
import 'package:admin_pelayanan_katolik/Agen/agenSetting.dart';

import 'Agent.dart';

class MessagePassing {
  Map<String, Agent> agents = {
    'Agent Pencarian': AgentPencarian(),
    'Agent Pendaftaran': AgentPendaftaran(),
    'Agent Setting': AgentSetting(),
    'Agent Akun': AgentAkun(),
    'Agent Page': AgentPage()
  };

  Future<dynamic> sendMessage(Message message) async {
    if (agents.containsKey(message.receiver)) {
      Agent? agent = agents[message.receiver];
      if (agent!.canPerformTask(message)) {
        return await agent.receiveMessage(message, message.sender);
      } else {
        agent.rejectTask(message.task, message.sender);
      }
      return null;
    }
  }
}
