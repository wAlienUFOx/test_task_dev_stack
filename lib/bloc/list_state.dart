part of 'list_bloc.dart';

abstract class ListState{
  const ListState();
}

class ListInitial extends ListState {}

class OnRefreshState extends ListState{}

class FirebaseSync extends ListState{}

class LocalSync extends ListState{}