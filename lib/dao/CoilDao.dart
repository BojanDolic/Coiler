import 'package:coiler_app/entities/Coil.dart';
import 'package:floor/floor.dart';

@dao
abstract class CoilDao {
  @insert
  Future<void> insertCoil(Coil coil);

  @delete
  Future<void> deleteCoil(Coil coil);

  @update
  Future<void> updateCoil(Coil coil);

  @Query("SELECT * FROM Coil")
  Stream<List<Coil>> getCoils();
}
