import 'package:simple_model/simple_model.dart';

final class ExampleModel extends SimpleModel {
  ExampleModel.fromJson(super.data);

  String? get name => $get('name');

  int? get age => $get('age');

  double? get height => $get('height');

  List<int?>? get scores => $get('scores');

  bool? get isEmployed => $get('isEmployed');
}

void main() {
  final model = ExampleModel.fromJson({
    "name": "John Doe",
    "age": 30,
    "height": 1.8,
    "scores": [100, 90, 80],
    "isEmployed": true
  });

  print(model.name); // John Doe

  print(model.age); // 30

  print(model.height); // 1.8

  print(model.scores); // [100, 90, 80]

  print(model.isEmployed); // true

  print(model.toJson());
}
