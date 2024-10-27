import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uhuru/screens/group/data/isar/group_collection.dart';
import 'package:uhuru/screens/group/data/model/group_model.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupState()) {
    on<FetchGroupEvent>(_onFetchGroup);
    on<SaveGroupEvent>(_onSaveGroup);
    on<EditGroupEvent>(_onEditGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<SaveGroupLastMessageEvent>(_onSaveGroupLastMessage);
  }

  void _onFetchGroup(FetchGroupEvent e, Emitter emit) async {
    final rsp = await GroupCollection().getGroups();
    debugPrint("Rungika: ${rsp.data['group_with_new_messages']}");
    emit(
      GroupFetchingState(
        groups: rsp.data['groups'],
        groupWithNewMessage: rsp.data['group_with_new_messages'],
      ),
    );
  }

  void _onSaveGroup(SaveGroupEvent e, Emitter emit) async {
    final rsp = await GroupCollection().saveGroupList(e.groups);
    if (rsp.status == 1) {
      final rsp = await GroupCollection().getGroups();
      emit(GroupFetchingState(
        groups: rsp.data['groups'],
        groupWithNewMessage: rsp.data['group_with_new_messages'],
      ));

      debugPrint('Emitting  group changes');
    }
  }

  void _onSaveGroupLastMessage(SaveGroupLastMessageEvent e, Emitter emit) async {
    final rps = await GroupCollection().saveGroupLastMessage(
      id: e.groupId,
      groupLastActivity: e.groupLastActivity,
      groupLastMessage: e.groupLastMessage,
      senderName: e.senderName,
    );
    if (rps) {
      final rsp = await GroupCollection().getGroups();
      emit(GroupFetchingState(groups: rsp.data['groups']));
    }
  }

  void _onEditGroup(EditGroupEvent e, Emitter emit) async {}
  void _onDeleteGroup(DeleteGroupEvent e, Emitter emit) async {}
}
