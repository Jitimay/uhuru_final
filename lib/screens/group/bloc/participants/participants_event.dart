part of 'participants_bloc.dart';

sealed class ParticipantsEvent extends Equatable {
  const ParticipantsEvent();

  @override
  List<Object> get props => [];
}

class FetchGroupParticipantEvent extends ParticipantsEvent {
  final int groupId;
  const FetchGroupParticipantEvent({required this.groupId});
}
