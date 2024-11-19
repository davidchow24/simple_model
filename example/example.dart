import 'package:simple_model/simple_model.dart';

void main() {
  final model = ExampleModel.fromJson({
    "name": "John Doe",
    "age": 30,
    "height": 1.8,
    "scores": [100, 90, 80],
    "isEmployed": true,
    "status": 1,
    "company": {"name": "Company Name", "location": "Mountain View"},
    "friends": [
      {"name": "Jane Doe", "age": 28},
      {"name": "Jack Doe", "age": 32}
    ]
  });

  print(model.name); // John Doe

  print(model.age); // 30

  print(model.height); // 1.8

  print(model.scores); // [100, 90, 80]

  print(model.isEmployed); // true

  print(model.status); // Status.running

  print(model.company?.name); // Company Name

  print(model.company?.location); // Mountain View

  print(model.friends?[0]?.name); // Jane Doe

  print(model.friends?[0]?.age); // 28

  print(model.friends?[1]?.name); // Jack Doe

  print(model.friends?[1]?.age); // 32

  print(model.toJson());

  final model2 = model.copyWith(
    status: Status.stopped,
  );

  print(model2.status); // Status.stopped
}

final class ExampleModel extends SimpleModel {
  ExampleModel.fromJson(super.data);

  String? get name => $get('name');

  int? get age => $get('age');

  double? get height => $get('height');

  List<int?>? get scores => $get('scores');

  bool? get isEmployed => $get('isEmployed');

  Status? get status => $get(
        'status',
        fromValue: $fromValueWithEnumMap(Status.enumMap),
      );

  ExampleCompanyModel? get company => $get(
        'company',
        fromJson: ExampleCompanyModel.fromJson,
      );

  List<ExampleFriendModel?>? get friends => $get(
        'friends',
        fromList: $fromList(ExampleFriendModel.fromJson),
      );

  ExampleModel copyWith({
    String? name,
    int? age,
    double? height,
    List<int?>? scores,
    bool? isEmployed,
    Status? status,
    ExampleCompanyModel? company,
    List<ExampleFriendModel?>? friends,
  }) =>
      $copyWith(
        toJson(),
        fromJson: ExampleModel.fromJson,
        value: {
          'name': name,
          'age': age,
          'height': height,
          'scores': scores,
          'isEmployed': isEmployed,
          'status': Status.enumMap[status],
          'company': company?.toJson(),
          'friends': friends?.toJson(),
        },
      );
}

final class ExampleCompanyModel extends SimpleModel {
  ExampleCompanyModel.fromJson(super.data);

  String? get name => $get('name');

  String? get location => $get('location');
}

final class ExampleFriendModel extends SimpleModel {
  ExampleFriendModel.fromJson(super.data);

  String? get name => $get('name');

  int? get age => $get('age');
}

enum Status {
  running,
  stopped,
  paused,
  ;

  static final enumMap = SimpleModel.getEnumMap(values)(
    (value) => switch (value) {
      Status.running => 1,
      Status.stopped => 2,
      Status.paused => 3,
    },
  );
}
