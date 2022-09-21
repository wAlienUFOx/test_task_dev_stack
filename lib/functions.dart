import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_dev_stack/bloc/list_bloc.dart';
import 'package:test_task_dev_stack/firebase.dart';
import 'package:test_task_dev_stack/listOfItems.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_task_dev_stack/functions.dart';


class Functions{
  static Future<void> onRefresh(ListOfItems items, FireBase fb) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ListOfItems.read(items, prefs, fb);
  }

  static void backSyncFirebase (ListOfItems items, FireBase fb) async{
    while(true){
      bool hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection) {
        FireBase.sync(items, fb);
      }
    }
  }

  static void backSyncLocal (ListOfItems items, FireBase fb) async{
    ListOfItems.sync(items, fb);
  }
}

