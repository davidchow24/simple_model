import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

extension ListSimpleModelExtension on List<SimpleModel?> {
  /// Converts the list of [SimpleModel] objects to a list of maps.
  /// Each map represents the JSON representation of a [SimpleModel] object.
  /// If a [SimpleModel] object is null, it will be represented as null in the resulting list.
  List<Map<String, Object?>?> toJson() => map((e) => e?.toJson()).toList();
}

base class SimpleModel {
  @protected
  SimpleModel(Map<String, Object?>? data)
      : _data = data != null ? Map.unmodifiable(data) : null;

  /// Converts a list of JSON objects to a list of objects.
  static List<T?>? Function(List<Object?>? json) fromJsonList<T>(
    T? Function(Map<String, Object?>?)? fromJsonT,
  ) {
    return (List<Object?>? data) {
      if (data is List<T?>?) {
        return data;
      }
      if (fromJsonT != null) {
        return data.whereType<Map<String, Object?>?>().map(fromJsonT).toList();
      }
      return null;
    };
  }

  /// A protected method that creates a new instance of [T] by merging the provided [data] with the current instance's data.
  ///
  /// This method is used to create a new instance of [T] with updated values. It takes 3 parameters:
  /// - [data] : A required map of data that will be merged with the current instance's data.
  /// - [fromJson] : A required function that converts a map of data to an instance of [T].
  /// - [value] : A required map of data that will be merged with the current instance's data.
  ///
  /// The method returns a new instance of [T] with the updated values.
  @protected
  T $copyWith<T>(
    Map<String, Object?>? data, {
    required T Function(Map<String, Object?>) fromJson,
    required Map<String, Object?> value,
  }) {
    return fromJson({
      ...?data,
      for (final entry in value.entries)
        if (entry.value != null) entry.key: entry.value,
    });
  }

  /// A protected method that returns a function that can convert a list of JSON objects to a list of objects.
  ///
  /// This method is used to handle the conversion of a list of JSON objects to a list of [T] objects.
  /// It takes a single optional parameter [fromJsonT], which is a function that converts a single JSON object to a [T] object.
  ///
  /// This method is intended to be used as a helper method within the [SimpleModel] class and its subclasses.
  @protected
  List<T?>? Function(List<Object?>? data) $fromList<T>(
    T? Function(Map<String, Object?>?)? fromJsonT,
  ) {
    return (List<Object?>? data) {
      if (data is List<T?>?) {
        return data;
      }
      if (fromJsonT != null) {
        return data.whereType<Map<String, Object?>?>().map(fromJsonT).toList();
      }
      return null;
    };
  }

  final Map<String, Object?>? _data;

  /// A protected method that retrieves a value from the model's data based on the provided field.
  /// It supports various data types and provides custom conversion functions for lists and maps.
  ///
  /// Parameters:
  /// - key: A required string representing the field name to retrieve from the model's data.
  /// - fromJson: An optional function that converts a single JSON object to a custom data type.
  /// - fromList: An optional function that converts a list of JSON objects to a list of custom data types.
  ///
  /// Return:
  /// - Returns the value of the specified field, converted using the provided `fromJson` or `fromList` function,
  ///   or attempts to convert the value to the specified type if no conversion function is provided.
  ///   If the value is not found or cannot be converted, returns `null`.
  @protected
  T? $get<T>(
    String key, {
    T? Function(Map<String, Object?>)? fromJson,
    T? Function(List<Map<String, Object?>?>?)? fromList,
  }) {
    final value = _data?[key];

    if (value is T?) {
      return value;
    }

    if (fromList != null) {
      if (value is List<Map<String, Object?>?>) {
        return fromList(value);
      }
    }

    if (fromJson != null) {
      if (value is Map<String, Object?>) {
        return fromJson(value);
      }
    }

    if (T == int) {
      return int.tryParse(value.toString()) as T?;
    }

    if (T == double) {
      return double.tryParse(value.toString()) as T?;
    }

    if (T == num) {
      return num.tryParse(value.toString()) as T?;
    }

    if (T == bool) {
      return bool.tryParse(value.toString()) as T?;
    }

    if (T == String) {
      return value.toString() as T?;
    }

    return null;
  }

  /// Converts the model's data to a JSON-compatible map.
  ///
  /// This method returns a new map containing the model's data. If the model's data is null,
  /// it returns null. The returned map is a deep copy of the original data, ensuring that
  /// modifications to the returned map do not affect the original data.
  ///
  /// The map's keys are strings, and the values can be of any type that is JSON-compatible.
  ///
  /// Return:
  /// - A map representing the model's data in JSON format, or null if the model's data is null.
  Map<String, Object?>? toJson() => _data != null ? Map.from(_data) : null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SimpleModel &&
        const DeepCollectionEquality().equals(other._data, _data);
  }

  @override
  int get hashCode => _data.hashCode;

  @override
  String toString() => _data.toString();
}
