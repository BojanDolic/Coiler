import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:floor/floor.dart';

class CapacitorBankConverter extends TypeConverter<CapacitorBank, String> {
  @override
  CapacitorBank decode(String databaseValue) {
    return CapacitorBank.fromDatabase(databaseValue);
    /*return CapacitorBank(
      capacitance: 25.4, //double.parse(valuesList[0]),
      seriesCapacitorCount: 4, //int.parse(valuesList[1]),
      parallelCapacitorCount: 5,
    );*/ //int.parse(valuesList[2]));

    //return CapacitorBank.fromDatabase(databaseValue);
  }

  @override
  String encode(CapacitorBank value) {
    print("TYPE CONVERTER POZVAN || UPISIVANJE VRIJEDNOSTI");
    return value.toDatabaseString();
  }
}
