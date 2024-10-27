part of 'language_selecter_bloc.dart';

class LanguageSelecterState extends Equatable {
  final Locale locale;
  const LanguageSelecterState({required this.locale});

  LanguageSelecterState copyWith({Locale? locale}) {
    return LanguageSelecterState(locale: locale ?? this.locale);
  }

  @override
  List<Object> get props => [locale, DateTime.now()];
}
