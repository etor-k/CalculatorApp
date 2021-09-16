import 'dart:math';
import 'package:petitparser/petitparser.dart';

Parser buildParser() {
  final builder = ExpressionBuilder();
  builder.group()
    ..primitive((pattern("+-").optional() &
        digit().plus() &
        (char(".") & digit().plus()).optional() &
        (pattern("eE") & pattern("+/-").optional() & digit().plus())
            .optional()
            .flatten("number exceeds")
            .trim()
            .map(num.tryParse)))
    ..wrapper(
        char("(").trim(), char(")").trim(), (left, value, right) => value);

  builder.group().prefix(char("-").trim(), (op, num a) => -a);
  builder.group().right(char("^").trim(), (num a, op, num b) => pow(a, b));
  builder.group()
    ..left(char("*").trim(), (num a, op, num b) => a * b)
    ..left(char("/").trim(), (num a, op, num b) => a / b);
  builder.group()
    ..left(char("+").trim(), (num a, op, num b) => a + b)
    ..left(char("-").trim(), (num a, op, num b) => a - b);

  return builder.build().end();
}
