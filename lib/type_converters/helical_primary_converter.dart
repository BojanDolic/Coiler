/*class HelicalPrimaryConverter extends TypeConverter<HelicalCoil?, String?> {
  @override
  HelicalCoil? decode(String? databaseValue) {
    if (databaseValue == null) {
      return null;
    }
    return HelicalCoil.fromJson(jsonDecode(databaseValue));
  }

  @override
  String? encode(HelicalCoil? value) {
    if (value == null) {
      return null;
    }
    return jsonEncode(value,
        toEncodable: (Object? value) => value is HelicalCoil
            ? HelicalCoil.toJson(value)
            : throw UnsupportedError("Cannot convert to value JSON: $value"));
  }
}*/
