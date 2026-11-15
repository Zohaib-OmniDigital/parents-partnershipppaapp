import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<String> _q1location = [];
  List<String> get q1location => _q1location;
  set q1location(List<String> value) {
    _q1location = value;
  }

  void addToQ1location(String value) {
    q1location.add(value);
  }

  void removeFromQ1location(String value) {
    q1location.remove(value);
  }

  void removeAtIndexFromQ1location(int index) {
    q1location.removeAt(index);
  }

  void updateQ1locationAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    q1location[index] = updateFn(_q1location[index]);
  }

  void insertAtIndexInQ1location(int index, String value) {
    q1location.insert(index, value);
  }

  List<String> _q2childrenage = [];
  List<String> get q2childrenage => _q2childrenage;
  set q2childrenage(List<String> value) {
    _q2childrenage = value;
  }

  void addToQ2childrenage(String value) {
    q2childrenage.add(value);
  }

  void removeFromQ2childrenage(String value) {
    q2childrenage.remove(value);
  }

  void removeAtIndexFromQ2childrenage(int index) {
    q2childrenage.removeAt(index);
  }

  void updateQ2childrenageAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    q2childrenage[index] = updateFn(_q2childrenage[index]);
  }

  void insertAtIndexInQ2childrenage(int index, String value) {
    q2childrenage.insert(index, value);
  }

  List<String> _q3maritalstatus = [];
  List<String> get q3maritalstatus => _q3maritalstatus;
  set q3maritalstatus(List<String> value) {
    _q3maritalstatus = value;
  }

  void addToQ3maritalstatus(String value) {
    q3maritalstatus.add(value);
  }

  void removeFromQ3maritalstatus(String value) {
    q3maritalstatus.remove(value);
  }

  void removeAtIndexFromQ3maritalstatus(int index) {
    q3maritalstatus.removeAt(index);
  }

  void updateQ3maritalstatusAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    q3maritalstatus[index] = updateFn(_q3maritalstatus[index]);
  }

  void insertAtIndexInQ3maritalstatus(int index, String value) {
    q3maritalstatus.insert(index, value);
  }

  List<String> _q4religion = [];
  List<String> get q4religion => _q4religion;
  set q4religion(List<String> value) {
    _q4religion = value;
  }

  void addToQ4religion(String value) {
    q4religion.add(value);
  }

  void removeFromQ4religion(String value) {
    q4religion.remove(value);
  }

  void removeAtIndexFromQ4religion(int index) {
    q4religion.removeAt(index);
  }

  void updateQ4religionAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    q4religion[index] = updateFn(_q4religion[index]);
  }

  void insertAtIndexInQ4religion(int index, String value) {
    q4religion.insert(index, value);
  }

  List<String> _q5journeys = [];
  List<String> get q5journeys => _q5journeys;
  set q5journeys(List<String> value) {
    _q5journeys = value;
  }

  void addToQ5journeys(String value) {
    q5journeys.add(value);
  }

  void removeFromQ5journeys(String value) {
    q5journeys.remove(value);
  }

  void removeAtIndexFromQ5journeys(int index) {
    q5journeys.removeAt(index);
  }

  void updateQ5journeysAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    q5journeys[index] = updateFn(_q5journeys[index]);
  }

  void insertAtIndexInQ5journeys(int index, String value) {
    q5journeys.insert(index, value);
  }

  List<String> _q6familystructure = [];
  List<String> get q6familystructure => _q6familystructure;
  set q6familystructure(List<String> value) {
    _q6familystructure = value;
  }

  void addToQ6familystructure(String value) {
    q6familystructure.add(value);
  }

  void removeFromQ6familystructure(String value) {
    q6familystructure.remove(value);
  }

  void removeAtIndexFromQ6familystructure(int index) {
    q6familystructure.removeAt(index);
  }

  void updateQ6familystructureAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    q6familystructure[index] = updateFn(_q6familystructure[index]);
  }

  void insertAtIndexInQ6familystructure(int index, String value) {
    q6familystructure.insert(index, value);
  }

  List<String> _q7parentingstyle = [];
  List<String> get q7parentingstyle => _q7parentingstyle;
  set q7parentingstyle(List<String> value) {
    _q7parentingstyle = value;
  }

  void addToQ7parentingstyle(String value) {
    q7parentingstyle.add(value);
  }

  void removeFromQ7parentingstyle(String value) {
    q7parentingstyle.remove(value);
  }

  void removeAtIndexFromQ7parentingstyle(int index) {
    q7parentingstyle.removeAt(index);
  }

  void updateQ7parentingstyleAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    q7parentingstyle[index] = updateFn(_q7parentingstyle[index]);
  }

  void insertAtIndexInQ7parentingstyle(int index, String value) {
    q7parentingstyle.insert(index, value);
  }

  List<String> _q8primarygoal = [];
  List<String> get q8primarygoal => _q8primarygoal;
  set q8primarygoal(List<String> value) {
    _q8primarygoal = value;
  }

  void addToQ8primarygoal(String value) {
    q8primarygoal.add(value);
  }

  void removeFromQ8primarygoal(String value) {
    q8primarygoal.remove(value);
  }

  void removeAtIndexFromQ8primarygoal(int index) {
    q8primarygoal.removeAt(index);
  }

  void updateQ8primarygoalAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    q8primarygoal[index] = updateFn(_q8primarygoal[index]);
  }

  void insertAtIndexInQ8primarygoal(int index, String value) {
    q8primarygoal.insert(index, value);
  }

  int _myUserId = 0;
  int get myUserId => _myUserId;
  set myUserId(int value) {
    _myUserId = value;
  }

  String _stateLegalName = '';
  String get stateLegalName => _stateLegalName;
  set stateLegalName(String value) {
    _stateLegalName = value;
  }

  String _stateDOB = '';
  String get stateDOB => _stateDOB;
  set stateDOB(String value) {
    _stateDOB = value;
  }

  String _stateAddress = '';
  String get stateAddress => _stateAddress;
  set stateAddress(String value) {
    _stateAddress = value;
  }

  String _stateCountry = '';
  String get stateCountry => _stateCountry;
  set stateCountry(String value) {
    _stateCountry = value;
  }

  String _stateState = '';
  String get stateState => _stateState;
  set stateState(String value) {
    _stateState = value;
  }

  String _stateZip = '';
  String get stateZip => _stateZip;
  set stateZip(String value) {
    _stateZip = value;
  }

  String _stateIdUrl = '';
  String get stateIdUrl => _stateIdUrl;
  set stateIdUrl(String value) {
    _stateIdUrl = value;
  }

  String _stateSelfieUrl = '';
  String get stateSelfieUrl => _stateSelfieUrl;
  set stateSelfieUrl(String value) {
    _stateSelfieUrl = value;
  }

  String _userStatus = '';
  String get userStatus => _userStatus;
  set userStatus(String value) {
    _userStatus = value;
  }
}
