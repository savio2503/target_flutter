import 'package:mobx/mobx.dart';
import 'package:target_flutter/model/target.dart';

part 'edit_store.g.dart';

class EditStore = _EditStore with _$EditStore;

abstract class _EditStore with Store {
  @observable
  String? descricao;

  @observable
  num? valorFinal;

  String idTarget = "";

  @observable
  bool loading = false;

  @action
  setTarget(Target target) {
    descricao = target.descricao!;
    print('setTarget: ${target.valorFinal}');
    valorFinal = target.valorFinal;
    idTarget = target.id!;
  }

  @action
  void setDescricao(String? value) => descricao = value;

  @computed
  bool get descricaoValid => descricao != null && descricao!.isNotEmpty;
  String? get descricaoError {
    if (descricaoValid) {
      return null;
    } else {
      return 'A descrição não pode ficar vazia!';
    }
  }

  @action
  void setFinal(num? value) => valorFinal = value;

  @computed
  bool get finalValid => valorFinal != null && valorFinal! > 0;
  String? get finalError {
    if (finalValid) {
      return null;
    } else {
      return 'O valor final tem que ser maior que zero';
    }
  }
}
