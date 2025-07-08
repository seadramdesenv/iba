import 'package:flutter/material.dart';
import 'package:iba_member_app/core/data/auth_service.dart';
import 'package:iba_member_app/features/donate/screens/donate_search_screen.dart';
import 'package:iba_member_app/features/heritage/screens/heritage_search_screen.dart';
import 'package:iba_member_app/pages/profile/widgets/edit_profile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthService api = AuthService();

  Future<Map<String, String?>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email'),
      'userName': prefs.getString('userName'),
    };
  }

  void Logoff(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sair"),
          content: const Text("Tem certeza que deseja sair?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () async {
                Navigator.of(context).pop();
                await api.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, String?>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Erro ao carregar os dados!',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _getUserData(),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            final userInfo = snapshot.data ?? {};

            return Column(
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('lib/assets/logo.jpg'),
                ),
                const SizedBox(height: 16),
                Text(
                  userInfo['userName'] ?? 'Nome não disponível',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  userInfo['email'] ?? 'Email não disponível',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // ListTile(
                    //   leading: const Icon(Icons.edit),
                    //   title: const Text('Editar Perfil'),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const EditProfilePage()),
                    //     );
                    //   },
                    // ),
                    ListTile(
                      leading: const Icon(Icons.monetization_on),
                      title: const Text('Doações'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DonateSearchScreen()),
                        );
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.add_business),
                      title: const Text('Patrimônio'),
                      children: [
                        ListTile(
                          title: const Text('Lista'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HeritageSearchScreen()),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Movimentação'),
                          onTap: () {

                          },
                        ),
                      ],
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                        Logoff(context);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
