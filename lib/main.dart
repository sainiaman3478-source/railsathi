import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(RailSathiApp());

class RailSathiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RailSathi',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final pages = [HomeRealPage(), PNRPage(), LivePage(), AccountPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'PNR'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

// ============ HOME - REAL SEARCH ============
class HomeRealPage extends StatefulWidget {
  @override
  _HomeRealPageState createState() => _HomeRealPageState();
}

class _HomeRealPageState extends State<HomeRealPage> {
  final fromCtrl = TextEditingController(text: 'NDLS');
  final toCtrl = TextEditingController(text: 'AGC');
  List trains = [];
  bool loading = false;
  String status = 'Bharat ki apni train app';

  Future<void> searchReal() async {
    setState(() { loading = true; status = 'LIVE IRCTC se search ho raha hai...'; trains = []; });
    try {
      String from = fromCtrl.text.trim().toUpperCase();
      String to = toCtrl.text.trim().toUpperCase();
      String date = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2,'0')}-${DateTime.now().day.toString().padLeft(2,'0')}";
      final url = Uri.parse('https://cttrainsapi.confirmtkt.com/api/ct/v2/trainsbetweenstations?fromStnCode=$from&toStnCode=$to&journeyDate=$date');

      final res = await http.get(url, headers: {'User-Agent': 'Mozilla/5.0'});
      final body = jsonDecode(res.body);

      if (body['data']!= null && body['data'].length > 0) {
        setState(() {
          trains = body['data'];
          status = 'LIVE - ${trains.length} REAL trains mili NDLS -> $to (IRCTC)';
        });
      } else {
        setState(() => status = 'No trains found. Try NDLS->LKO / AGC / CNB');
      }
    } catch (e) {
      setState(() => status = 'Error: $e - Internet check karo');
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RailSathi - LIVE'), backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(Icons.train, color: Colors.blue[800]), SizedBox(width: 8), Text('Bharat ki apni train app', style: TextStyle(fontWeight: FontWeight.bold))])),
            SizedBox(height: 16),
            Row(children: [
              Expanded(child: TextField(controller: fromCtrl, decoration: InputDecoration(labelText: 'FROM', hintText: 'NDLS', border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on)))),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward),
              SizedBox(width: 10),
              Expanded(child: TextField(controller: toCtrl, decoration: InputDecoration(labelText: 'TO', hintText: 'AGC', border: OutlineInputBorder(), prefixIcon: Icon(Icons.flag)))),
            ]),
            SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: loading? null : searchReal, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]), child: Text(loading? 'Searching LIVE...' : 'Search REAL Trains - IRCTC LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            SizedBox(height: 8),
            Text(status, style: TextStyle(color: status.contains('LIVE')? Colors.green[700] : Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 8),
            Expanded(
              child: trains.isEmpty? Center(child: Text('FROM-TO daal ke Search karo\nDemo nahi, REAL data ayega', textAlign: TextAlign.center)) : ListView.builder(itemCount: trains.length, itemBuilder: (c, i) {
                var t = trains[i];
                return Card(child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.blue[800], child: Text('${t['trainNumber']}'.toString().substring(0,2), style: TextStyle(color: Colors.white, fontSize: 12))),
                  title: Text('${t['trainNumber']} - ${t['trainName']?? ''}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Departure: ${t['fromStationTime']} | Arrival: ${t['toStationTime']} | Duration: ${t['duration']?? ''}'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 14),
                ));
              }),
            )
          ],
        ),
      ),
    );
  }
}

// ============ PNR PAGE ============
class PNRPage extends StatelessWidget {
  final ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('PNR Status')), body: Padding(padding: EdgeInsets.all(16), child: Column(children: [TextField(controller: ctrl, decoration: InputDecoration(labelText: 'PNR Number', border: OutlineInputBorder())), SizedBox(height: 10), ElevatedButton(onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PNR API next step me add karenge'))); }, child: Text('Check PNR'))])));
  }
}

class LivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Live Status')), body: Center(child: Text('Live Train Status - Next update me')));
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Account')), body: Center(child: Text('RailSathi - Bhagwanpur\nVersion: REAL LIVE 1.0')));
  }
}
