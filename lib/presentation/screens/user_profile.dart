import 'package:flutter/material.dart';
import 'package:pagebeya/data/models/user.dart';
import 'package:pagebeya/data/services/auth_services.dart';
import 'package:pagebeya/data/services/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pagebeya/data/services/auth_provider.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserData();
  }

  // Future<void> _loadUserData() async {
  //   final authProvider = context.read<AuthProvider>();
  //   await authProvider.fetchUserData();
  //   final user = authProvider.user;
  //   if (user != null && mounted) {
  //     _nameController.text = user.name;
  //     _emailController.text = user.email;
  //     _phoneController.text = user.phone;
  //   }
  // }
  Future<void> _loadUserData() async {
    final user = Provider.of<UserProvider>(context).user;
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
    _phoneController.text = user?.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authProvider.user;
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _getProfileImage(user),
                ),
                const SizedBox(height: 20),
                Text(user.name,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 30),
                _buildProfileInfoSection(user),
                const SizedBox(height: 30),
                _buildLogoutButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  ImageProvider _getProfileImage(User user) {
    if (user.image?.isNotEmpty ?? false) {
      return NetworkImage(user.image!);
    }
    return const AssetImage('assets/placeholder.png');
  }

  Widget _buildProfileInfoSection(User user) {
    return Column(
      children: [
        _buildReadOnlyField('Name', Icons.person, _nameController),
        const SizedBox(height: 16),
        _buildReadOnlyField('Email', Icons.email, _emailController),
        const SizedBox(height: 16),
        _buildReadOnlyField('Phone', Icons.phone, _phoneController),
      ],
    );
  }

  Widget _buildReadOnlyField(
      String label, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      readOnly: true,
      style: const TextStyle(color: Colors.black87),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text('Log Out', style: TextStyle(color: Colors.white)),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => _handleLogout(context),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final AuthServices authServices = AuthServices();
    authServices.logout(context);
  }
}
