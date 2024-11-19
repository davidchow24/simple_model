# Simple Model

A straightforward method for converting between JSON and its reverse format without the need for a code generator.

## Simple Model Converter

Utilize this converter to convert JSON data into Simple Model classes.

[Try Converter](https://simple-model-converter.web.app/)

## Features

- `fromJson`
- `toJson`
- `copyWith`

## Getting started

- `SimpleModel` for converting to and from JSON
- `SimpleModel.fromJsonList` method for converting JSON list of objects
- `SimpleModel.getEnumMap` method for getting enum map
- `$get` method for getting data by key
- `$fromList` method for handling list of objects
- `$fromValueWithEnumMap` method for handling enum

## Usage

If you want to convert the following JSON

```json
{
    "name": "John Doe",
    "age": 30,
    "height": 1.8,
    "scores": [100, 90, 80],
    "isEmployed": true
}
```

The following example shows how to convert

```dart
import 'package:simple_model/simple_model.dart';

final class ExampleModel extends SimpleModel {
  ExampleModel.fromJson(super.data);

  String? get name => $get('name');

  int? get age => $get('age');

  double? get height => $get('height');

  List<int?>? get scores => $get('scores');

  bool? get isEmployed => $get('isEmployed');
}
```

Example for `fromJson` and `toJson` methods

```dart
final model = ExampleModel.fromJson({
  "name": "John Doe",
  "age": 30,
  "height": 1.8,
  "scores": [100, 90, 80],
  "isEmployed": true
});

model.name; // John Doe

model.age; // 30

model.height; // 1.8

model.scores; // [100, 90, 80]

model.isEmployed; // true

model.toJson();
```

## Advanced JSON format

If you want to convert JSON data like this

```json
{
  ...
  "status": 0,
  "company": {
    "name": "Company Name",
    "location": "Mountain View"
  },
  "friends": [
    {"name": "Jane Doe", "age": 28},
    {"name": "Jack Doe", "age": 32}
  ]
}
```

The following example shows how to convert

```dart
final class ExampleModel extends SimpleModel {
  ...

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
```

If you want to convert the JSON like this

```json
[
  {
    "name": "John Doe",
    "age": 30,
    "height": 1.8,
    "scores": [100, 90, 80],
    "isEmployed": true
  },
  {
    "name": "Kevin Doe",
    "age": 35,
    "height": 2.8,
    "scores": [100, 90, 80, 70],
    "isEmployed": false
  }
]
```

The following example shows how to convert

```dart
final model = SimpleModel.fromJsonList(ExampleModel.fromJson)([
  {
    "name": "John Doe",
    "age": 30,
    "height": 1.8,
    "scores": [100, 90, 80],
    "isEmployed": true
  },
  {
    "name": "Kevin Doe",
    "age": 35,
    "height": 2.8,
    "scores": [100, 90, 80, 70],
    "isEmployed": false
  }
]);

model.length; // 2
```

## Copy with

You can add `copyWith` like this

```dart
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
```
