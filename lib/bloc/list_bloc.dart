import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_dev_stack/firebase.dart';
import 'package:test_task_dev_stack/listOfItems.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState>{
  final ListOfItems items;
  final FireBase fb;
  ListBloc(this.items, this.fb) : super(ListInitial()){

    
    on<RefreshEvent>(_refresh);
    on<FirebaseEvent>(_firebase);
    on<LocalEvent>(_local);

    add(LocalEvent(items, fb));
    add(FirebaseEvent(items, fb));
  }

  Future<void> _refresh(RefreshEvent event, Emitter emit) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ListOfItems.read(event.items, prefs, event.fb);
    await Future.delayed(const Duration(seconds: 2));
    emit(OnRefreshState());
  }

  Future<void> _firebase(FirebaseEvent event, Emitter emit) async{
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection) {
      FireBase.sync(event.items, event.fb);
    }
    await Future.delayed(const Duration(seconds: 10));
    add(FirebaseEvent(event.items, event.fb));
    emit(FirebaseSync());
  }

  Future<void> _local(LocalEvent event, Emitter emit) async{
    ListOfItems.sync(event.items, event.fb);
    await Future.delayed(const Duration(seconds: 2));
    add(LocalEvent(event.items, event.fb));
    emit(LocalSync());
  }
}