import 'package:finbedu/services/constants.dart';

import '../../routes/app_routes.dart' as route;
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Menampilkan informasi pengguna di terminal
    if (user != null) {
      print('User Name: ${user.name}');
      print('User Email: ${user.email}');
    } else {
      print('No user data available');
    }

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ClipOval(
                      child:
                          (user.photo ?? '').isNotEmpty
                              ? Image.network(
                                '${Constants.imgUrl}/${user.photo}',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.white,
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                              : Container(
                                width: 90,
                                height: 90,
                                color: Colors.white,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: const Text("Edit Profile"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        await Navigator.pushNamed(context, route.edit_profile);
                        setState(() {}); // trigger reload saat kembali
                      },
                    ),
                    // ListTile(
                    //   title: const Text("Security"),
                    //   trailing: const Icon(Icons.arrow_forward_ios),
                    //   onTap: () {
                    //     // Navigator.pushNamed(context, route.security);
                    //   },
                    // ),
                    // ListTile(
                    //   title: const Text("Terms & Conditions"),
                    //   trailing: const Icon(Icons.arrow_forward_ios),
                    //   onTap: () {
                    //     // Navigator.pushNamed(context, route.terms);
                    //   },
                    // ),
                    ListTile(
                      title: const Text("Logout"),
                      trailing: const Icon(Icons.logout),
                      onTap: () async {
                        // await authService.logout(); // optional: clear token/session in service
                        userProvider.clearUser(); // clear user in provider
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          route.login,
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: 'Full Name')),
            TextField(decoration: InputDecoration(labelText: 'Date of Birth')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(decoration: InputDecoration(labelText: 'Phone Number')),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Gender'),
              items: [
                DropdownMenuItem(child: Text("Male"), value: "Male"),
                DropdownMenuItem(child: Text("Female"), value: "Female"),
                DropdownMenuItem(child: Text("Other"), value: "Other"),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement update functionality here
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Security')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.lock, size: 100.0),
            SizedBox(height: 20),
            Text("Choose Options", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement change PIN functionality here
              },
              child: Text('Change PIN'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement change password functionality here
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Condition & Attending",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "At our online learning platform, we are excited to have you join us! It is important to follow the rules to ensure everyone has a fun and safe experience. Please remember to be respectful, treat others kindly, and participate actively in all activities. If you have any questions or need help, feel free to ask your teacher or an adult.",
              ), // Shortened for brevity
              SizedBox(height: 20),
              Text(
                "Terms & Use",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "By using our application, you agree to follow our guidelines to help make learning enjoyable for everyone. You should not share your password with anyone and must not use the platform for anything harmful or unfair. We work hard to keep the tools and resources safe and fun, so please take care when using them and always be friendly with your classmates!",
              ), // Shortened for brevity
            ],
          ),
        ),
      ),
    );
  }
}
