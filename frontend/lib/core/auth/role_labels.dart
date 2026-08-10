class RoleLabels {
  RoleLabels._();

  static String label(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
        return 'Propriétaire';

      case 'MANAGER':
        return 'Gestionnaire';

      case 'PILOT':
        return 'Pilote';

      default:
        return role;
    }
  }
}
