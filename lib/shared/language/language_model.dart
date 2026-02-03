import 'package:flutter/material.dart';
import 'package:nexpaylab/app/data/service/local_storage_service.dart';

class LanguageModel extends ChangeNotifier {
  LanguageModel(this._localStorageService) {
    _loadLanguage();
  }

  static const _languageKey = 'app_language';
  final LocalStorageService _localStorageService;
  
  Locale? _currentLocale;
  Locale? get currentLocale => _currentLocale;
  
  void _loadLanguage() {
    final savedLang = _localStorageService.getString(_languageKey);
    if (savedLang != null) {
      _currentLocale = Locale(savedLang);
    }
    notifyListeners();
  }
  
  Future<void> setLocale(String languageCode) async {
    if (_currentLocale?.languageCode == languageCode) return;
    
    _currentLocale = Locale(languageCode);
    notifyListeners();
    await _localStorageService.saveString(_languageKey, languageCode);
  }
}
