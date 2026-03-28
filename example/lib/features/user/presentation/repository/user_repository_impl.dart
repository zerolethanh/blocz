import 'package:blocz_example/api/example_api.dart';
import 'package:injectable/injectable.dart';
import 'user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> getUserById(int id) async {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getUsers() async {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<User> createUser(User user) async {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<int> deleteUser(int id) async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<User> getUserByIdWithApiKey(int id, String apiKey) async {
    // TODO: implement getUserByIdWithApiKey
    throw UnimplementedError();
  }

  @override
  Future<bool> updateUser(User user) async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
