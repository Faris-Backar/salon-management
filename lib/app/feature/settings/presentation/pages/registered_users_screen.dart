import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';

@RoutePage()
class RegisteredUsersScreen extends StatefulWidget {
  const RegisteredUsersScreen({super.key});

  @override
  State<RegisteredUsersScreen> createState() => _RegisteredUsersScreenState();
}

class _RegisteredUsersScreenState extends State<RegisteredUsersScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      // final users = await FirebaseFirestore.instance
      //     .collection('registered-users')
      //     .get();
      // _users = users.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading users: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleUserStatus(String userId, bool isActive) async {
    try {
      // TODO: Implement Firebase user status update
      // await FirebaseFirestore.instance
      //     .collection('registered-users')
      //     .doc(userId)
      //     .update({'isActive': isActive});
      await _loadUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _toggleAdminStatus(String userId, bool isAdmin) async {
    try {
      // TODO: Implement Firebase admin status update
      // await FirebaseFirestore.instance
      //     .collection('registered-users')
      //     .doc(userId)
      //     .update({'isAdmin': isAdmin});
      await _loadUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // context.router.pushNamed(AppRouter.register);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListTile(
                      title: Text(user['email'] ?? ''),
                      subtitle: Text(
                        'Status: ${user['isActive'] == true ? 'Active' : 'Inactive'} | '
                        'Role: ${user['isAdmin'] == true ? 'Admin' : 'User'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: user['isActive'] == true,
                            onChanged: (value) =>
                                _toggleUserStatus(user['id'], value),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: user['isAdmin'] == true,
                            onChanged: (value) =>
                                _toggleAdminStatus(user['id'], value),
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
