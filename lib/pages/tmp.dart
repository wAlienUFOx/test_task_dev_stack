import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_task_dev_stack/firebase.dart';
import 'package:test_task_dev_stack/listOfItems.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var items = ListOfItems();
  var fb = FireBase();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    _backSyncLocal(items, fb);
    _backSyncFirebase(items, fb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List', style: TextStyle(color: Colors.black, fontSize: 32),),
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white),
      ),
      body:
      CustomRefreshIndicator(
        builder: (
            BuildContext context,
            Widget child,
            IndicatorController controller,
            ){
          return AnimatedBuilder(
            animation: controller, builder: (BuildContext context, _){
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if(!controller.isIdle)
                  Positioned(
                    top: 35 * controller.value,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: const Color.fromRGBO(111, 143, 255, 1),
                        value: !controller.isLoading
                            ? controller.value.clamp(0.0, 1.0)
                            : null,
                      ),
                    ),
                  ),
                Transform.translate(
                  offset: Offset(0, 100.0 * controller.value),
                  child: child,
                ),
              ],
            );
          },
          );
        },
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: items.counter,
          itemBuilder: _renderItem,
        ),
      ),
    );
  }

  Widget _renderItem(BuildContext context, int index){
    return Card(
      shadowColor: Colors.white,
      child: Column(
        children: [
          Container(
            color: const Color.fromRGBO(235, 242, 252, 1),
            height: 54.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(items.list[index], style: const TextStyle(fontSize: 16),),
                  Text('${items.sort[index]}'),
                  Text('ID:${items.id[index]}', style: const TextStyle(fontSize: 16),),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('switchName', style: TextStyle(fontSize: 14),),
                Switch(
                    activeColor: const Color.fromRGBO(49, 172, 106, 1),
                    value: items.switchName[index],
                    onChanged: (value){
                      setState((){
                        ListOfItems.switchNameF(index, items);
                      });
                    }
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Radio(
                  activeColor: const Color.fromRGBO(49, 172, 106, 1),
                  value: true,
                  groupValue: items.radio[index],
                  onChanged: (value){
                    setState((){
                      ListOfItems.radioF(index, items);
                    });
                  }
              ),
              const Text('Radio 1', style: TextStyle(fontSize: 14),),
              Radio(
                  activeColor: const Color.fromRGBO(49, 172, 106, 1),
                  value: false,
                  groupValue: items.radio[index],
                  onChanged: (value){
                    setState((){
                      ListOfItems.radioF(index, items);
                    });
                  }
              ),
              const Text('Radio 2', style: TextStyle(fontSize: 14),),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: items.checkbox[index],
                activeColor: Colors.green,
                onChanged: (value){
                  setState((){
                    ListOfItems.checkBoxF(index, items);
                  });
                },
              ),
              const Text('Checkbox'),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      ListOfItems.read(items, prefs, fb);
    });
    await Future.delayed(const Duration(seconds: 2));
  }

  void _backSyncFirebase (ListOfItems items, FireBase fb) async{
    while(true){
      bool hasConnection = await InternetConnectionChecker().hasConnection;
      await Future.delayed(const Duration(seconds: 10));
      if (hasConnection) {
        setState(() {
          FireBase.sync(items, fb);
        });
      }
    }
  }

  void _backSyncLocal (ListOfItems items, FireBase fb) async{
    while(true){
      setState((){
        ListOfItems.sync(items, fb);
      });
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}