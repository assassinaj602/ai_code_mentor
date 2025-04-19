import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 32),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  height: 20,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 32),
                ...List.generate(3, (i) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                )),
              ],
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text('John Doe', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 32),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Profile'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text('My Orders'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                SwitchListTile(
                  value: _darkMode,
                  onChanged: (val) {
                    setState(() => _darkMode = val);
                    // TODO: Actually toggle app dark mode
                  },
                  secondary: Icon(Icons.dark_mode),
                  title: Text('Dark Mode'),
                ),
              ],
            ),
    );
  }
}
