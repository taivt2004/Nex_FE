import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/core/data/model/user.dart' as model;
import 'package:nexpaylab/app/database/database.dart';

abstract class UserLocalStore {
  Future<int> saveOrUpdateUser(model.User user);
  SingleOrNullSelectable<model.User> getUserById(int userId);
  Future<void> deleteUser(int userId);
}

@Injectable(as: UserLocalStore)
class UserLocalStoreImp extends UserLocalStore {
  UserLocalStoreImp({required this.database});

  final Database database;

  @override
  Future<void> deleteUser(int userId) {
    final query = database.delete(database.users)
      ..where((t) => t.id.equals(userId));
    return query.go();
  }
  
  @override
  Future<int> saveOrUpdateUser(model.User user) {
    final query = database.into(database.users);
    return query.insertOnConflictUpdate(user.toData());
  }

  @override
  SingleOrNullSelectable<model.User> getUserById(int userId) {
    final query = database.select(database.users)
      ..where((t) => t.id.equals(userId));
    return query.map((it) {
      return model.User.fromData(it);
    });
  }
}
