class AppUser {
  final String id; // unique identifier provided at signup/signin
  final String name;
  final String phone;

  const AppUser({required this.id, required this.name, required this.phone});

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
      };

  factory AppUser.fromMap(Map<String, Object?> map) => AppUser(
        id: map['id'] as String,
        name: map['name'] as String,
        phone: map['phone'] as String,
      );
}



