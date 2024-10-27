import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_selecter_event.dart';
part 'language_selecter_state.dart';

class LanguageSelecterBloc extends Bloc<LocaleEvent, LanguageSelecterState> {
  LanguageSelecterBloc() : super(LanguageSelecterState(locale: Locale('en'))) {
    on<LanguageSelectedEvent>(_onLanguageSelected);
    on<StoredLocaleEvent>(_onStoredLocale);
  }
  void _onLanguageSelected(LanguageSelectedEvent e, Emitter emit) {
    emit(state.copyWith(locale: e.locale));
  }

  void _onStoredLocale(StoredLocaleEvent event, Emitter<LanguageSelecterState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final storedLocale = prefs.getString("selectedLocale") ?? 'en';
    Locale? _locale = Locale(storedLocale);
    debugPrint(_locale.languageCode);
    emit(state.copyWith(locale: _locale));
  }
}
