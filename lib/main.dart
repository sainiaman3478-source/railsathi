import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const RailSathiApp());

class RailSathiApp extends StatelessWidget {
  const RailSathiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: const Color(0xFF0F52BA)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fromCtrl = TextEditingController(text: 'NDLS');
  final toCtrl = TextEditingController(text: 'AGC');
  List trains = [];
  bool loading = false;
  String msg = 'REAL API - NDLS to AGC search karo';

  Future<void> doSearch() async {
    setState(() { loading = true; trains = []; msg = 'Fetching REAL trains...'; });
    try {
      final f = fromCtrl.text.trim().toUpperCase();
      final t = toCtrl.text.trim().toUpperCase();
      final url = Uri.parse('https://erail.in/rail/getTrains.aspx?Station_From=$f&Station_To=$t&DataSource=0&Language=0&Cache=true');
      final res = await http.get(url, headers: {'User-Agent': 'Mozilla/5.0'}).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200 && res.body.length > 20) {
        final parts = res.body.split('~^');
        List list = [];
        for (var p in parts) {
          if (p.contains('^')) {
            final c = p.split('^');
            if (c.length > 12 && c[0].length < 6) {
              list.add({'num': c[0], 'name': c[1], 'dep': c[11], 'arr': c[12], 'dur': c.length > 13? c[13] : ''});
            }
          }
        }
        if (list.isNotEmpty) {
          setState(() { trains = list; msg = '${list.length} REAL trains found'; loading = false; });
          return;
        }
      }
      setState(() { msg = 'No trains found. Code sahi daalo - NDLS, AGC, LKO'; });
    } catch (e) {
      setState(() { msg = 'Error: $e'; });
    }
    setState(() { loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RailSathi REAL'), backgroundColor: const Color(0xFF0F52BA), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: fromCtrl, decoration: const InputDecoration(labelText: 'FROM - NDLS', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: toCtrl, decoration: const InputDecoration(labelText: 'TO - AGC', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)), onPressed: loading? null : doSearch, child: loading? const CircularProgressIndicator(color: Colors.white) : const Text('Search REAL Trains', style: TextStyle(color: Colors.white)))),
          const SizedBox(height: 10),
          Text(msg, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 10),
          Expanded(child: ListView.builder(itemCount: trains.length, itemBuilder: (c,i){
            final tr = trains[i];
            return Card(child: ListTile(title: Text('${tr['num']} ${tr['name']}', style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('Dep: ${tr['dep']} Arr: ${tr['arr']} Dur: ${tr['dur']}')));
          }))
        ]),
      ),
    );
  }
}
