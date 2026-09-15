import 'package:flutter/material.dart';

void main() => runApp(RailSathiApp());

class Train {
  final String number, name, from, to, time, duration, type;
  Train(this.number, this.name, this.from, this.to, this.time, this.duration, this.type);
}

class RailSathiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RailSathi',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5B21B6))),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String from = 'DELHI';
  String to = 'MUMBAI';
  List<Train> allTrains = [
    Train('12952','Mumbai Rajdhani','DELHI','MUMBAI','16:35','15h 35m','Rajdhani'),
    Train('12953','August Kranti Rajdhani','DELHI','MUMBAI','17:05','17h 10m','Rajdhani'),
    Train('12259','Duronto Express','DELHI','MUMBAI','23:00','16h 10m','Duronto'),
    Train('12903','Golden Temple Mail','DELHI','MUMBAI','07:20','16h 45m','Mail'),
    Train('12926','Paschim Express','DELHI','MUMBAI','11:30','24h 05m','Express'),
    Train('12216','Garib Rath','DELHI','MUMBAI','15:25','16h 55m','Garib Rath'),
    Train('12908','Maharashtra Sampark Kranti','DELHI','MUMBAI','08:05','19h 10m','Kranti'),
    Train('12622','Tamil Nadu Express','DELHI','CHENNAI','22:30','32h 30m','Superfast'),
    Train('12615','Grand Trunk Express','DELHI','CHENNAI','18:35','33h 15m','Express'),
    Train('12270','Duronto','DELHI','CHENNAI','06:40','28h 50m','Duronto'),
    Train('12434','Rajdhani','DELHI','CHENNAI','16:00','28h 10m','Rajdhani'),
    Train('12423','Rajdhani','DELHI','GUWAHATI','11:15','27h 15m','Rajdhani'),
    Train('15657','Brahmaputra Mail','DELHI','GUWAHATI','23:40','37h 25m','Mail'),
    Train('12506','North East Express','DELHI','GUWAHATI','06:40','28h 00m','Express'),
    Train('12502','Poorvottar Sampark Kranti','DELHI','GUWAHATI','11:50','27h 30m','Kranti'),
  ];

  List<Train> filtered = [];

  void search() {
    setState(() {
      filtered = allTrains.where((t) => t.from == from && t.to == to).toList();
    });
  }

  @override
  void initState() { super.initState(); search(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3FF),
      appBar: AppBar(backgroundColor: Color(0xFF5B21B6), title: Text('RailSathi - Bharat ki Train', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
          child: Column(children: [
            Row(children: [
              Expanded(child: DropdownButtonFormField<String>(value: from, items: ['DELHI','MUMBAI','CHENNAI','GUWAHATI','ALIGARH'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => from = v!), decoration: InputDecoration(labelText: 'Kahan se', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
              SizedBox(width: 10),
              Expanded(child: DropdownButtonFormField<String>(value: to, items: ['MUMBAI','DELHI','CHENNAI','GUWAHATI','ALIGARH'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => to = v!), decoration: InputDecoration(labelText: 'Kahan tak', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
            ]),
            SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5B21B6), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: search, child: Text('Train Dhoondo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
          ]),
        ),
        Padding(padding: EdgeInsets.all(12), child: Text('${filtered.length} Trains • $from → $to', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: ListView.builder(itemCount: filtered.length, itemBuilder: (c,i){
          final t = filtered[i];
          return Card(margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: ListTile(leading: Icon(Icons.train, color: Color(0xFF5B21B6)), title: Text('${t.number} - ${t.name}', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${t.from} → ${t.to} • ${t.time} • ${t.duration}'), trailing: Chip(label: Text(t.type, style: TextStyle(fontSize: 10)))));
        }))
      ]),
    );
  }
}
