import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task_dev_stack/firebase.dart';

class ListOfItems{
  int counter = 0; List list = []; List id = []; List sort = []; List switchName = [];
  List radio = []; List checkbox = []; List switchChange = [];  List radioChange = []; List checkChange = [];

  static void sync (ListOfItems items, FireBase fb) async {
    final prefs = await SharedPreferences.getInstance();
    write(items, prefs, fb);
    read(items, prefs, fb);
  }

  static void write(ListOfItems items, SharedPreferences prefs, FireBase fb) {
    int counter = prefs.getInt('counter') ?? 0;
    while(items.switchChange.isNotEmpty){
      int index = items.switchChange.last;
      for(int i = 0; i < counter; i++){
        if(items.id[index] == prefs.getInt('id$i')){
          prefs.setBool('switchName$i', items.switchName[index]);
          fb.switchToFb.add(i);
          fb.switchFromFb.add(i);
        }
      }
      items.switchChange.removeLast();
    }
    while(items.radioChange.isNotEmpty){
      int index = items.radioChange.last;
      for(int i = 0; i < counter; i++){
        if(items.id[index] == prefs.getInt('id$i')){
          prefs.setBool('radio$i', items.radio[index]);
          fb.radioToFb.add(i);
          fb.radioFromFb.add(i);
        }
      }
      items.radioChange.removeLast();
    }
    while(items.checkChange.isNotEmpty){
      int index = items.checkChange.last;
      for(int i = 0; i < counter; i++){
        if(items.id[index] == prefs.getInt('id$i')){
          prefs.setBool('checkbox$i', items.checkbox[index]);
          fb.checkToFb.add(i);
          fb.checkFromFb.add(i);
        }
      }
      items.checkChange.removeLast();
    }
    writeChange(fb, prefs);
  }

  static void read(ListOfItems items, SharedPreferences prefs, FireBase fb) {
    ListOfItems.clear(items);
    readChange(fb, prefs);
    items.counter = prefs.getInt('counter') ?? 0;
    int i = 0;
    while(i < items.counter){
      insert(i, items, prefs);
      i++;
    }
  }

  static void insert(int i, ListOfItems items, SharedPreferences prefs) {
    if(i == 0){
      add(i, items, prefs);
      return;
    }
    int n = 0;
    int s = (prefs.getInt('sort$i') ?? 0);
    int tmp = i-1;
    while(n < i){
      if(s < items.sort[n]){
        addI(tmp, items);
        for (tmp; tmp > n; tmp--){
          stepRight(tmp, items);
        }
        setFromPrefs(n, i, items, prefs);
        return;
      }
      n++;
    }
    add(i, items, prefs);
  }

  static void writeChange (FireBase fb, SharedPreferences prefs){
    prefs.setInt('lengthSwitchTo', fb.switchToFb.length);
    prefs.setInt('lengthSwitchFrom', fb.switchToFb.length);
    int counter = fb.switchToFb.length;
    for(int i = 0; i < counter; i++){prefs.setInt('switchTo$i', fb.switchToFb[i]);}
    counter = fb.switchFromFb.length;
    for(int i = 0; i < counter; i++){prefs.setInt('switchFrom$i', fb.switchFromFb[i]);}
    prefs.setInt('lengthRadioTo', fb.radioToFb.length);
    prefs.setInt('lengthRadioFrom', fb.radioToFb.length);
    counter = fb.radioToFb.length;
    for(int i = 0; i < counter; i++){prefs.setInt('radioTo$i', fb.radioToFb[i]);}
    counter = fb.radioFromFb.length;
    for(int i = 0; i < counter; i++){prefs.setInt('radioFrom$i', fb.radioFromFb[i]);}
    prefs.setInt('lengthCheckTo', fb.checkToFb.length);
    prefs.setInt('lengthCheckFrom', fb.checkToFb.length);
    counter = fb.checkToFb.length;
    for(int i = 0; i < counter; i++){prefs.setInt('checkTo$i', fb.checkToFb[i]);}
    counter = fb.checkFromFb.length;
    for(int i = 0; i < counter; i++){prefs.setInt('checkFrom$i', fb.checkFromFb[i]);}
  }

  static void readChange (FireBase fb, SharedPreferences prefs) {
    fb.switchToFb.clear();
    fb.switchFromFb.clear();
    int counter = prefs.getInt('lengthSwitchTo') ?? 0;
    for(int i = 0; i < counter; i++){fb.switchToFb.add(prefs.getInt('switchTo$i'));}
    counter = prefs.getInt('lengthSwitchFrom') ?? 0;
    for(int i = 0; i < counter; i++){fb.switchFromFb.add(prefs.getInt('switchFrom$i'));}
    fb.radioToFb.clear();
    fb.radioFromFb.clear();
    counter = prefs.getInt('lengthRadioTo') ?? 0;
    for(int i = 0; i < counter; i++){fb.radioToFb.add(prefs.getInt('radioTo$i'));}
    counter = prefs.getInt('lengthRadioFrom') ?? 0;
    for(int i = 0; i < counter; i++){fb.radioFromFb.add(prefs.getInt('radioFrom$i'));}
    fb.checkToFb.clear();
    fb.checkFromFb.clear();
    counter = prefs.getInt('lengthCheckTo') ?? 0;
    for(int i = 0; i < counter; i++){fb.checkToFb.add(prefs.getInt('checkTo$i'));}
    counter = prefs.getInt('lengthCheckFrom') ?? 0;
    for(int i = 0; i < counter; i++){fb.checkFromFb.add(prefs.getInt('checkFrom$i'));}
  }

  static void switchNameF(int index, ListOfItems items) {
    items.switchName[index] = !items.switchName[index];
    items.switchChange.add(index);
  }

  static void radioF(int index, ListOfItems items) async{
    items.radio[index] = !items.radio[index];
    items.radioChange.add(index);
  }

  static void checkBoxF(int index, ListOfItems items) async{
    items.checkbox[index] = !items.checkbox[index];
    items.checkChange.add(index);
  }

  static void add(int i, ListOfItems items, SharedPreferences prefs){
    items.list.add(prefs.getString("list$i"));
    items.id.add(prefs.getInt('id$i'));
    items.sort.add(prefs.getInt('sort$i'));
    items.switchName.add(prefs.getBool('switchName$i'));
    items.radio.add(prefs.getBool('radio$i'));
    items.checkbox.add(prefs.getBool('checkbox$i'));
  }

  static void addI(int i, ListOfItems items){
    items.list.add(items.list[i]);
    items.id.add(items.id[i]);
    items.sort.add(items.sort[i]);
    items.switchName.add(items.switchName[i]);
    items.radio.add(items.radio[i]);
    items.checkbox.add(items.checkbox[i]);
  }

  static void stepRight(int i, ListOfItems items){
    items.list[i] = items.list[i-1];
    items.id[i] = items.id[i-1];
    items.sort[i] = items.sort[i-1];
    items.switchName[i] = items.switchName[i-1];
    items.radio[i] = items.radio[i-1];
    items.checkbox[i] = items.checkbox[i-1];
  }

  static void setFromPrefs(int positionItems, int positionPrefs, ListOfItems items, SharedPreferences prefs){
    items.list[positionItems] = prefs.getString('list$positionPrefs');
    items.id[positionItems] = prefs.getInt('id$positionPrefs');
    items.sort[positionItems] = prefs.getInt('sort$positionPrefs');
    items.switchName[positionItems] = prefs.getBool('switchName$positionPrefs');
    items.radio[positionItems] = prefs.getBool('radio$positionPrefs');
    items.checkbox[positionItems] = prefs.getBool('checkbox$positionPrefs');
  }

  static void clear(ListOfItems items) async{
    items.list.clear();
    items.id.clear();
    items.sort.clear();
    items.switchName.clear();
    items.radio.clear();
    items.checkbox.clear();
  }
}