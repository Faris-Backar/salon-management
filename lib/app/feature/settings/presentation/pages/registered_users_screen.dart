import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/resources/firebase_resources.dart';
import 'package:salon_management/app/core/utils/responsive.dart';
import 'package:salon_management/app/feature/auth/domain/entities/user_entity.dart';
import 'package:salon_management/app/feature/auth/data/models/user_model.dart';

// Provider for search query
final userSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for active/inactive filter
final userFilterProvider = StateProvider<String>((ref) => 'all');

// Provider for users list
final usersProvider = StreamProvider<List<UserEntity>>((ref) {
  return FirebaseFirestore.instance
      .collection(FirebaseResources.registeredUsers)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
});

@RoutePage()
class RegisteredUsersScreen extends ConsumerWidget {
  const RegisteredUsersScreen({super.key});

  Widget _buildCompactStat(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _toggleUserStatus(
      BuildContext context, String userId, bool currentStatus) async {
    // Show confirmation dialog
    final shouldToggle = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(currentStatus ? 'Deactivate User' : 'Activate User'),
          content: Text(
            currentStatus
                ? 'Are you sure you want to deactivate this user? They will not be able to access the system.'
                : 'Are you sure you want to activate this user? They will be able to access the system.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (shouldToggle == true) {
      try {
        await FirebaseFirestore.instance
            .collection(FirebaseResources.registeredUsers)
            .doc(userId)
            .update({'isActive': !currentStatus});

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User status updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating user status: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _toggleAdminStatus(
      BuildContext context, String userId, bool currentStatus) async {
    // Show confirmation dialog
    final shouldToggle = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              currentStatus ? 'Remove Admin Access' : 'Grant Admin Access'),
          content: Text(
            currentStatus
                ? 'Are you sure you want to remove admin privileges from this user? They will lose access to administrative features.'
                : 'Are you sure you want to grant admin privileges to this user? They will have access to all administrative features.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (shouldToggle == true) {
      try {
        await FirebaseFirestore.instance
            .collection(FirebaseResources.registeredUsers)
            .doc(userId)
            .update({'isAdmin': !currentStatus});

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Admin status updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating admin status: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final searchQuery = ref.watch(userSearchQueryProvider);
    final filterType = ref.watch(userFilterProvider);
    final isMobile = Responsive.isMobile();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
        automaticallyImplyLeading: isMobile,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Compact header with filters and summary
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter row
                    Row(
                      children: [
                        Wrap(
                          spacing: 8.0,
                          children: [
                            FilterChip(
                              selected: filterType == 'all',
                              label: const Text('All'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.primaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref.read(userFilterProvider.notifier).state =
                                      'all';
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected: filterType == 'active',
                              label: const Text('Active'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor:
                                  context.colorScheme.secondaryContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref.read(userFilterProvider.notifier).state =
                                      'active';
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            FilterChip(
                              selected: filterType == 'inactive',
                              label: const Text('Inactive'),
                              backgroundColor:
                                  context.colorScheme.surfaceVariant,
                              selectedColor: context.colorScheme.errorContainer,
                              onSelected: (selected) {
                                if (selected) {
                                  ref.read(userFilterProvider.notifier).state =
                                      'inactive';
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Search and summary row
                    Row(
                      children: [
                        // Search field
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search users...',
                                prefixIcon: const Icon(Icons.search, size: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: context.colorScheme.surfaceVariant
                                    .withOpacity(0.5),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                ref
                                    .read(userSearchQueryProvider.notifier)
                                    .state = value;
                              },
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Summary stats
                        Expanded(
                          flex: 3,
                          child: usersAsync.when(
                            data: (users) {
                              final activeUsers =
                                  users.where((user) => user.isActive).length;
                              final adminUsers =
                                  users.where((user) => user.isAdmin).length;
                              final inactiveUsers =
                                  users.where((user) => !user.isActive).length;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCompactStat(
                                    context,
                                    "Total Users",
                                    users.length.toString(),
                                    Icons.people_outline,
                                    context.colorScheme.primary,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Active Users",
                                    activeUsers.toString(),
                                    Icons.check_circle_outline,
                                    Colors.green,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Admin Users",
                                    adminUsers.toString(),
                                    Icons.admin_panel_settings_outlined,
                                    Colors.orange,
                                  ),
                                  _buildCompactStat(
                                    context,
                                    "Inactive",
                                    inactiveUsers.toString(),
                                    Icons.block_outlined,
                                    Colors.red,
                                  ),
                                ],
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (_, __) =>
                                const Text("Error loading statistics"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Users Table
            Expanded(
              child: usersAsync.when(
                data: (users) {
                  if (users.isEmpty) {
                    return const Center(child: Text("No users found."));
                  }

                  // Filter users based on search and filter type
                  var filteredUsers = users.where((user) {
                    final matchesSearch = searchQuery.isEmpty ||
                        user.email
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase());
                    final matchesFilter = filterType == 'all' ||
                        (filterType == 'active' && user.isActive) ||
                        (filterType == 'inactive' && !user.isActive);
                    return matchesSearch && matchesFilter;
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return const Center(
                        child: Text("No matching users found."));
                  }

                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: PaginatedDataTable(
                          header: const Text('User Records'),
                          rowsPerPage: 10,
                          columnSpacing: 12,
                          horizontalMargin: 16,
                          availableRowsPerPage: const [10, 25, 50],
                          showFirstLastButtons: true,
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Created At')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Role')),
                            DataColumn(label: Text('Actions')),
                          ],
                          source: _UserDataSource(
                            filteredUsers,
                            context,
                            onToggleStatus: (user) => _toggleUserStatus(
                                context, user.id, user.isActive),
                            onToggleAdmin: (user) => _toggleAdminStatus(
                                context, user.id, user.isAdmin),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: ${error.toString()}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDataSource extends DataTableSource {
  final List<UserEntity> _users;
  final BuildContext _context;
  final Function(UserEntity) onToggleStatus;
  final Function(UserEntity) onToggleAdmin;

  _UserDataSource(
    this._users,
    this._context, {
    required this.onToggleStatus,
    required this.onToggleAdmin,
  });

  @override
  DataRow getRow(int index) {
    final user = _users[index];
    return DataRow(
      cells: [
        DataCell(Text(user.email)),
        DataCell(Text(user.createdAt.toString().split('.')[0])),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: user.isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 12,
                color: _context.colorScheme.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: user.isAdmin ? Colors.orange : Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.isAdmin ? 'Admin' : 'User',
              style: TextStyle(
                fontSize: 12,
                color: _context.colorScheme.surface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  user.isActive ? Icons.check_circle : Icons.block,
                  size: 20,
                  color: user.isActive ? Colors.green : Colors.red,
                ),
                onPressed: () => onToggleStatus(user),
                tooltip: user.isActive ? 'Deactivate' : 'Activate',
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(
                  user.isAdmin ? Icons.person_off : Icons.admin_panel_settings,
                  size: 20,
                  color: user.isAdmin ? Colors.red : Colors.orange,
                ),
                onPressed: () => onToggleAdmin(user),
                tooltip: user.isAdmin ? 'Remove Admin' : 'Make Admin',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _users.length;

  @override
  int get selectedRowCount => 0;
}
