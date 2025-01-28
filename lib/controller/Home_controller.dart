import 'package:get/get.dart';

class HomeController extends GetxController {
  bool isSearch = false;

  setSearchOptions() {
    isSearch = !isSearch;
    update();
  }
}
