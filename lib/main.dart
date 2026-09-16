import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(RailSathiPro());

class RailSathiPro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RailSathi Pro',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget { @override _MainScreenState createState() => _MainScreenState(); }
class _MainScreenState extends State<MainScreen> {
  int idx=0;
  final pages=[HomePro(), PNRPage(), AlarmPage(), ProPage()];
  @override Widget build(BuildContext context){
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx, onTap: (i)=>setState(()=>idx=i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[800],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'PNR'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarm'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Pro'),
        ]),
    );
  }
}

class HomePro extends StatefulWidget { @override _HomeProState createState() => _HomeProState(); }
class _HomeProState extends State<HomePro> {
  final fromC=TextEditingController(text:'NDLS'); final toC=TextEditingController(text:'AGC');
  List trains=[
    {'num':'12002','name':'Bhopal Shatabdi','from':'NDLS','to':'AGC','dep':'06:00','arr':'07:55','fare':'₹750'},
    {'num':'12050','name':'Gatimaan Express','from':'NDLS','to':'AGC','dep':'08:10','arr':'09:50','fare':'₹755'},
    {'num':'12280','name':'Taj Express','from':'NDLS','to':'AGC','dep':'06:55','arr':'09:15','fare':'₹105'},
    {'num':'12004','name':'LKO Shatabdi','from':'NDLS','to':'LKO','dep':'06:10','arr':'12:40','fare':'₹1300'},
  ];
  List filtered=[];
  @override void initState(){ super.initState(); filtered=trains; }
  void search(){ String f=fromC.text.toUpperCase(); String t=toC.text.toUpperCase(); setState(()=> filtered=trains.where((e)=> e['from'].toString().contains(f) || e['to'].toString().contains(t)).toList()); }
  void book(String num) async {
    final url=Uri.parse('https://www.confirmtkt.com');
    if(await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('RailSathi Pro'), backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
      body: Column(children: [
        Container(color: Colors.blue[800], padding: EdgeInsets.all(12), child: Row(children: [
          Expanded(child: TextField(controller: fromC, decoration: InputDecoration(filled: true, fillColor: Colors.white, labelText: 'FROM', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))))),
          SizedBox(width: 8),
          Expanded(child: TextField(controller: toC, decoration: InputDecoration(filled: true, fillColor: Colors.white, labelText: 'TO', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))))),
        ])),
        Padding(padding: EdgeInsets.all(12), child: SizedBox(width: double.infinity, height: 45, child: ElevatedButton(onPressed: search, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700]), child: Text('Search Trains', style: TextStyle(color: Colors.white))))),
        Expanded(child: ListView.builder(itemCount: filtered.length, itemBuilder: (c,i){ var t=filtered[i]; return Card(child: ListTile(title: Text("${t['num']} - ${t['name']}"), subtitle: Text("${t['from']} ${t['dep']} -> ${t['to']} ${t['arr']} | Fare: ${t['fare']}"), trailing: ElevatedButton(onPressed: ()=> book(t['num'].toString()), child: Text('Book'))));}))
      ]),
    );
  }
}
class PNRPage extends StatelessWidget { @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: Text('PNR')), body: Center(child: Text('PNR Tracker - Coming Soon'))); } }
class AlarmPage extends StatelessWidget { @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: Text('Alarm')), body: Center(child: Text('Station Alarm - Pro Feature'))); } }
class ProPage extends StatelessWidget { @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: Text('Pro')), body: Center(child: Text('Become Pro - Rs 49/year\nEarn 80k/month'))); } }
