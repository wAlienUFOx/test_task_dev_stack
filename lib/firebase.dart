import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:test_task_dev_stack/listOfItems.dart';

class FireBase{

  List switchToFb = []; List radioToFb = []; List checkToFb = []; List switchFromFb = []; List radioFromFb = []; List checkFromFb = [];

  static void sync (ListOfItems items, FireBase fb) async {
    final prefs = await SharedPreferences.getInstance();
    upload(prefs, fb);
    download(prefs, fb);
  }

  static void upload (SharedPreferences prefs, FireBase fb) async{
    while(fb.switchToFb.isNotEmpty){
      int index = fb.switchToFb.last;
      final doc = FirebaseFirestore.instance.collection("collection").doc("doc$index");
      await Future.delayed(Duration(seconds: Random().nextInt(5)));//imitation of delay
      doc.update({"switchName" : prefs.getBool("switchName$index")});
      fb.switchToFb.removeLast();
    }
    while(fb.radioToFb.isNotEmpty){
      int index = fb.radioToFb.last;
      final doc = FirebaseFirestore.instance.collection("collection").doc("doc$index");
      await Future.delayed(Duration(seconds: Random().nextInt(5)));//imitation of delay
      doc.update({"radio" : prefs.getBool("radio$index")});
      fb.radioToFb.removeLast();
    }
    while(fb.checkToFb.isNotEmpty){
      int index = fb.checkToFb.last;
      final doc = FirebaseFirestore.instance.collection("collection").doc("doc$index");
      await Future.delayed(Duration(seconds: Random().nextInt(5)));//imitation of delay
      doc.update({"checkbox" : prefs.getBool("checkbox$index")});
      fb.checkToFb.removeLast();
    }
  }

  static void download (SharedPreferences prefs, FireBase fb) async {
    await Future.delayed(Duration(seconds: Random().nextInt(5)));//imitation of delay
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("counter").doc("counter").get();
    prefs.setInt("counter", doc.get("counter"));
    await Future.delayed(Duration(seconds: Random().nextInt(5)));//imitation of delay
    QuerySnapshot collection = await FirebaseFirestore.instance.collection("collection").get();
    List<DocumentSnapshot> docs = collection.docs;
    for (DocumentSnapshot doc in docs){
      int i = int.parse(doc.id.substring(3));
      prefs.setString('list$i', doc.get('list'));//
      prefs.setInt('id$i', doc.get('id'));
      prefs.setInt('sort$i', doc.get('sort'));//
      if(fb.switchFromFb.contains(i)){
        fb.switchFromFb.remove(i);
      }else{
        prefs.setBool('switchName$i', doc.get('switchName'));
      }
      if(fb.radioFromFb.contains(i)){
        fb.radioFromFb.remove(i);
      }else{
        prefs.setBool('radio$i', doc.get('radio'));
      }
      if(fb.checkFromFb.contains(i)){
        fb.checkFromFb.remove(i);
      }else{
        prefs.setBool('checkbox$i', doc.get('checkbox'));
      }
    }
  }
}
