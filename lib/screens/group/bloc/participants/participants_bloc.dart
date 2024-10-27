import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uhuru/screens/group/bloc/group_bloc.dart';
import 'package:uhuru/screens/group/data/model/participant_model.dart';

import '../../data/isar/participant_collection.dart';

part 'participants_event.dart';
part 'participants_state.dart';

class ParticipantsBloc extends Bloc<ParticipantsEvent, ParticipantsState> {
  ParticipantsBloc() : super(ParticipantsState(participants: [])) {
    on<FetchGroupParticipantEvent>(_onFetchGroupParticipants);
  }

  void _onFetchGroupParticipants(FetchGroupParticipantEvent e, Emitter emit) async {
    final rsp = await GroupParicipantCollection().getParticipants(groupId: e.groupId);
    final participants = rsp.data;
    emit(ParticipantsState(participants: participants));
  }
}
