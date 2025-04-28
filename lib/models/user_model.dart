class UserModel {
  final int id;
  final String nombre;
  final String token;

  UserModel({required this.id, required this.nombre, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'token': token,
    };
  }
}
