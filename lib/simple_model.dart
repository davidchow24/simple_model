import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// A base class for the SimpleModel.
///
/// This class serves as a foundation for creating simple models.
/// Extend this class to implement specific model functionalities.
base class SimpleModel {
  @protected
  SimpleModel(Map<String, Object?>? data)
      : _data = data != null ? Map.unmodifiable(data) : null;

  /// Generates a map from enum values to mapped values using the provided mapper function.
  ///
  /// This function takes a list of enum values and a mapper function, and returns a map
  /// where each enum value is a key and the corresponding mapped value is the value.
  ///
  /// - Parameters:
  ///   - mapper: A function that takes an enum value and returns a mapped value.
  ///   - values: A list of enum values to be used as keys in the map.
  ///
  /// - Returns: A map where each key is an enum value and each value is the result of
  ///   applying the mapper function to the corresponding enum value.
  static Map<E, T> Function(T Function(E) mapper) getEnumMap<T, E extends Enum>(
    List<E> values,
  ) {
    return (T Function(E) mapper) => Map.unmodifiable({
          for (final value in values) value: mapper(value),
        });
  }

  /// A protected method that creates a copy of an object with updated values.
  ///
  /// This method takes a map of data and a map of values, and returns a new object
  /// created by merging the data and values maps. The `fromJson` function is used
  /// to create the new object from the merged map.
  ///
  /// - Parameters:
  ///   - data: A map of data to be copied. Can be null.
  ///   - fromJson: A function that creates an object of type `T` from a map.
  ///   - value: A map of values to update in the copied data. Only non-null values
  ///     will be included in the merged map.
  ///
  /// - Returns: A new object of type `T` created from the merged map.
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

  /// Converts a list of objects to a list of a specific type [T].
  ///
  /// The [fromJsonT] parameter is a function that converts a map to an instance of [T].
  /// If [data] is already a list of [T], it is returned as is.
  /// If [fromJsonT] is provided, it is used to convert each map in [data] to an instance of [T].
  ///
  /// Returns a list of [T] or null if [data] is null or cannot be converted.
  ///
  /// - [data]: The list of objects to be converted.
  /// - [fromJsonT]: A function that converts a map to an instance of [T].
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

  /// A protected function that returns a function to map a value to an enum key.
  ///
  /// This function takes a map of enum values to their corresponding data values
  /// and returns a function that can be used to find the enum key for a given data value.
  ///
  /// The returned function takes an [Object?] data value and returns the corresponding
  /// enum key of type [T], or `null` if no matching entry is found.
  ///
  /// - Parameter enumMap: A map of enum values to their corresponding data values.
  /// - Returns: A function that takes an [Object?] data value and returns the corresponding
  ///   enum key of type [T], or `null` if no matching entry is found.
  @protected
  T? Function(Object? data) $fromValueWithEnumMap<T>(
    Map<T, Object?> enumMap,
  ) {
    return (Object? data) {
      return enumMap.entries
          .firstWhereOrNull((entry) => entry.value == data)
          ?.key;
    };
  }

  final Map<String, Object?>? _data;

  /// Retrieves a value of type `T` from the internal data map using the provided key.
  ///
  /// The method attempts to cast the value directly to `T`. If that fails, it tries to
  /// convert the value using the provided conversion functions (`fromJson`, `fromList`, `fromValue`).
  ///
  /// If no conversion functions are provided, it attempts to parse the value to common types
  /// such as `int`, `double`, `num`, `bool`, and `String`.
  ///
  /// - Parameters:
  ///   - key: The key to look up in the internal data map.
  ///   - fromJson: A function that converts a `Map<String, Object?>` to `T`.
  ///   - fromList: A function that converts a `List<Map<String, Object?>?>` to `T`.
  ///   - fromValue: A function that converts an `Object?` to `T`.
  ///
  /// - Returns: The value associated with the key, converted to type `T`, or `null` if the conversion fails.
  @protected
  T? $get<T>(
    String key, {
    T? Function(Map<String, Object?>)? fromJson,
    T? Function(List<Map<String, Object?>?>?)? fromList,
    T? Function(Object? value)? fromValue,
  }) {
    final value = _data?[key];

    if (value is T?) {
      return value;
    }

    if (fromValue != null) {
      return fromValue(value);
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

  /// Returns a string representation of the object.
  ///
  /// This method overrides the default `toString` method to provide a custom
  /// string representation of the object based on its `_data` property.
  ///
  /// Returns:
  ///   A string representation of the `_data` property.
  @override
  String toString() => _data.toString();
}

/// An extension on `List<SimpleModel?>` that provides a method to convert
/// the list of `SimpleModel` objects to a list of JSON maps.
///
/// The `toJson` method maps each `SimpleModel` object in the list to its
/// JSON representation using the `toJson` method of `SimpleModel`. If an
/// element in the list is `null`, it will be mapped to `null` in the resulting
/// list of JSON maps.
///
/// Returns a list of JSON maps representing the `SimpleModel` objects.
extension ListSimpleModelExtension on List<SimpleModel?> {
  /// Converts the list of objects to a list of JSON-serializable maps.
  ///
  /// Each object in the list is converted to a JSON map using its `toJson` method.
  /// If an object is `null`, it will be represented as `null` in the resulting list.
  ///
  /// Returns a list of maps where each map represents the JSON-serializable
  /// version of the corresponding object in the original list.
  List<Map<String, Object?>?> toJson() => map((e) => e?.toJson()).toList();
}
