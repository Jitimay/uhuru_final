part of 'language_selecter_bloc.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class LanguageSelectedEvent extends LocaleEvent {
  final Locale locale;
  const LanguageSelectedEvent({required this.locale});

  @override
  List<Object> get props => [locale];
}

class StoredLocaleEvent extends LocaleEvent {}
