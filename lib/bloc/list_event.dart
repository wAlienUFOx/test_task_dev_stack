part of 'list_bloc.dart';

abstract class ListEvent{
  const ListEvent();
}

class RefreshEvent extends ListEvent {
  final ListOfItems items;
  final FireBase fb;
  const RefreshEvent(this.items, this.fb);
}

class FirebaseEvent extends ListEvent {
  final ListOfItems items;
  final FireBase fb;
  const FirebaseEvent(this.items, this.fb);
}

class LocalEvent extends ListEvent {
  final ListOfItems items;
  final FireBase fb;
  const LocalEvent(this.items, this.fb);
}