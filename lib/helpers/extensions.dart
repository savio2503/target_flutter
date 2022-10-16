import 'package:intl/intl.dart';
import 'package:target_flutter/model/debit.dart';

extension StringExtension on String {
  bool isEmailValid() {
    final RegExp regex = RegExp(
        r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
    return regex.hasMatch(this);
  }
}

extension NumberExtension on num {
  String formattedMoneyWithType(TypeDebit tipo) {
    String prefix = tipo == TypeDebit.REAL ? 'R\$' : 'U\$';
    return NumberFormat('$prefix ###,##0.00', 'pt-BR').format(this);
  }

  String formattedMoney() {
    return NumberFormat('R\$ ###,##0.00', 'pt-BR').format(this);
  }

  String formatted() {
    return NumberFormat('###,##0.00', 'pt-BR').format(this);
  }

  String formattedPercentage() {
    return NumberFormat('0.00', 'pt-BR').format(this) + ' %';
  }
}

extension DateTimeExtension on DateTime {
  String formattedDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
