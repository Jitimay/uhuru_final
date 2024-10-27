part of 'group_bloc.dart';

sealed class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class FetchGroupEvent extends GroupEvent {}

class SaveGroupEvent extends GroupEvent {
  final List<GroupModel> groups;
  const SaveGroupEvent({required this.groups});
}

class EditGroupEvent extends GroupEvent {
  final GroupModel group;
  const EditGroupEvent({required this.group});
}

class DeleteGroupEvent extends GroupEvent {
  final GroupModel group;
  const DeleteGroupEvent({required this.group});
}

class SaveGroupLastMessageEvent extends GroupEvent {
  final int groupId;
  final String groupLastMessage;
  final String groupLastActivity;
  final String senderName;
  const SaveGroupLastMessageEvent({
    required this.groupId,
    required this.groupLastMessage,
    required this.groupLastActivity,
    required this.senderName,
  });
}
