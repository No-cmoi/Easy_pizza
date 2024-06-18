class User {

 String email;
 String password;
 String firstName;
 String lastName;
 String role;

 User({
  required this.email,
  required this.password,
  required this.firstName,
  required this.lastName,
  required this.role
});

factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email :json["email"],
      password: json["password"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
    );
  }

}