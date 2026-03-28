import 'package:blocz_example/api/example_api.dart';

abstract class UserRepository {
  Future<User> getUserById(int id);
  Future<List<User>> getUsers();
  Future<User> createUser(User user);
  Future<int> deleteUser(int id);
  Future<User> getUserByIdWithApiKey(int id, String apiKey);
  Future<bool> updateUser(User user);
}
