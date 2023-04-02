import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPendaftaran.dart';

import 'Agent.dart';
import 'AgenPencarian.dart';

import 'Messages.dart';

class MessagePassing {
  Map<String, Agent> agents = {
    'Agent Pencarian': AgentPencarian(),
    'Agent Pendaftaran': AgentPendaftaran(),
  };

  static List data = [];

  Future<dynamic> sendMessage(Message message) async {
    if (agents.containsKey(message.receiver)) {
      Agent? agent = agents[message.receiver];
      if (agent!.canPerformTask(message)) {
        return await agent.performTask(message, message.sender);
      } else {
        agent.rejectTask(message.task, message.sender);
      }
    } else if (message.receiver == "View") {
      messageSetToView(message.task);
    }
    return null;
  }

  messageSetToView(message) {
    return data.add(message.data);
  }

  Future messageGetToView() async {
    return await data.last;
  }
}
