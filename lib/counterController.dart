import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:get/get.dart';

class CounterController extends GetxController {
  var counter = 0.obs;

  void increment() {
    counter++;
  }

  void reset() {
    print('######################### reset'+counter.value.toString());
    counter.value = 0;
  }
}
