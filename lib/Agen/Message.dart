import 'Task.dart';

class Message {
  String sender;
  String receiver;
  Task task;
  dynamic protocol;

  Message(this.sender, this.receiver, this.protocol, this.task);
}
