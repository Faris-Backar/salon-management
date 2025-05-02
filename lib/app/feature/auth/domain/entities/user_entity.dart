class UserEntity {
  final String id;
  final String email;
  final bool isActive;
  final bool isAdmin;
  final DateTime createdAt;
  UserEntity({
    required this.id,
    required this.email,
    required this.isActive,
    required this.isAdmin,
    required this.createdAt,
  });
}
