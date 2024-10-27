part of 'group_bloc.dart';

class GroupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupFetchingState extends GroupState {
  final List<GroupModel> groups;
  final int groupWithNewMessage;

  GroupFetchingState({required this.groups, this.groupWithNewMessage = 0});

  GroupFetchingState copyWith({
    List<GroupModel>? groups,
    int? groupWithNewMessage,
  }) {
    return GroupFetchingState(
      groups: groups ?? this.groups,
      groupWithNewMessage: groupWithNewMessage ?? this.groupWithNewMessage,
    );
  }

  @override
  List<Object?> get props => [
        this.groupWithNewMessage,
        this.groups,
      ];
}
