import 'package:coiler_app/entities/Sparkgap.dart';
import 'package:floor/floor.dart';

class SparkgapConverter extends TypeConverter<Sparkgap, String> {
  @override
  Sparkgap decode(String databaseValue) {
    return Sparkgap.fromDatabase(databaseValue);
  }

  @override
  String encode(Sparkgap value) {
    return value.toDatabaseString();
  }
}
