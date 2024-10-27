part of 'participants_bloc.dart';

class ParticipantsState extends Equatable {
  final List<ParticipantModel> participants;
  const ParticipantsState({required this.participants});

  @override
  List<Object> get props => [participants];
}
