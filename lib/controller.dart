import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Controller extends GetxController {
  var isHided = true.obs;

  void changeToFalse() {
    isHided.value =  false;
  }

  void changeToTrue() {
    isHided.value =  true;
  }


}
