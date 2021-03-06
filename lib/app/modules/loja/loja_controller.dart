import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'loja_controller.g.dart';

@Injectable()
class LojaController = _LojaControllerBase with _$LojaController;

abstract class _LojaControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
