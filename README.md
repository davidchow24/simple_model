# Simple Model

Simple way for converting to and from JSON without code generator.

## Features

- `fromJson`
- `toJson`
- `copyWith`

## Getting started

- `SimpleModel` for converting to and from JSON
- `$get` method for getting data by key
- `$fromList` method for handling list of objects
- `SimpleModel.fromJsonList` method for converting JSON list of objects

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
        'company': company?.toJson(),
        'friends': friends?.toJson(),
      },
    );
```
