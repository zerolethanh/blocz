class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

class ExampleApi {
  Future<User> getUserById(int id) async {
    // Simulated API call
    return User(id: id, name: 'John Doe', email: 'john@example.com');
  }

  Future<List<User>> getUsers() async {
    // Simulated API call
    return [
      User(id: 1, name: 'John Doe', email: 'john@example.com'),
      User(id: 2, name: 'Jane Doe', email: 'jane@example.com'),
    ];
  }

  Future<void> createUser(User user) async {
    // Simulated API call
  }

  Future<void> deleteUser(int id) async {
    // Simulated API call
  }
}
