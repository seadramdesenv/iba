import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Card 1: Aniversariantes da Semana
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text(
                  'Aniversariantes da Semana',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('5 aniversariantes nesta semana'),
                leading: Icon(Icons.cake, color: Colors.blue),
              ),
            ),

            // Card 2: Aniversariantes do Mês
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text(
                  'Aniversariantes do Mês',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('12 aniversariantes neste mês'),
                leading: Icon(Icons.cake, color: Colors.green),
              ),
            ),

            // Card 3: Quantidade de Membros Cadastrados
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text(
                  'Membros Cadastrados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('350 membros cadastrados'),
                leading: Icon(Icons.group, color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}