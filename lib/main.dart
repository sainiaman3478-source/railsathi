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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true, scaffoldBackgroundColor: Color(0xFFF6F8FF)),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget { @override _SplashScreenState createState() => _SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen> {
  @override void initState(){ super.initState(); Future.delayed(Duration(seconds: 2), ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MainProScreen()))); }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Color(0xFF0D47A1), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.train_rounded, size: 90, color: Colors.white), SizedBox(height: 16), Text('RailSathi', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)), Text('Pro', style: TextStyle(fontSize: 26, color: Colors.orange[300], fontWeight: FontWeight.bold, letterSpacing: 2)), SizedBox(height: 30), CircularProgressIndicator(color: Colors.white)])));
  }
}

class MainProScreen extends StatefulWidget { @override _MainProScreenState createState() => _MainProScreenState(); }
class _MainProScreenState extends State<MainProScreen> {
  int idx=0;
  final pages=[HomePro(), PNRProPage(), AlarmProPage(), AccountProPage()];
  @override Widget build(BuildContext context){
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (i)=>setState(()=>idx=i), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.blue[800], unselectedItemColor: Colors.grey, items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_num_rounded), label: 'PNR'),
        BottomNavigationBarItem(icon: Icon(Icons.alarm_rounded), label: 'Alarm'),
        BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Pro'),
      ]),
    );
  }
}

class HomePro extends StatefulWidget { @override _HomeProState createState() => _HomeProState(); }
class _HomeProState extends State<HomePro> {
  final fromC=TextEditingController(text:'NDLS'); final toC=TextEditingController(text:'AGC');
  List filtered=[]; bool isPro=false;
  final trains=[
    {'num':'12002','name':'Bhopal Shatabdi','from':'NDLS','to':'AGC','dep':'06:00','arr':'07:55','fare':'₹750','type':'Superfast'},
    {'num':'12050','name':'Gatimaan Express','from':'NDLS','to':'AGC','dep':'08:10','arr':'09:50','fare':'₹755','type':'Fastest India'},
    {'num':'12280','name':'Taj Express','from':'NDLS','to':'AGC','dep':'06:55','arr':'09:15','fare':'₹105','type':'Daily'},
    {'num':'12448','name':'UP Sampark Kranti','from':'NDLS','to':'AGC','dep':'16:00','arr':'18:00','fare':'₹260','type':'Express'},
    {'num':'12004','name':'Lucknow Swarn Shatabdi','from':'NDLS','to':'LKO','dep':'06:10','arr':'12:40','fare':'₹1300','type':'Shatabdi'},
    {'num':'12230','name':'Lucknow Mail','from':'NDLS','to':'LKO','dep':'22:15','arr':'06:15','fare':'₹385','type':'Superfast'},
    {'num':'12556','name':'Gorakhdham Express','from':'NDLS','to':'LKO','dep':'20:00','arr':'04:00','fare':'₹350','type':'Express'},
  ];

  @override void initState(){ super.initState(); filtered=trains; loadPro(); }
  loadPro() async { var p=await SharedPreferences.getInstance(); setState(()=> isPro=p.getBool('isPro')??false); }
  void search(){ String f=fromC.text.toUpperCase(); String t=toC.text.toUpperCase(); setState(()=> filtered=trains.where((e)=> e['from'].toString().contains(f) || e['to'].toString().contains(t) || f=='NDLS').toList()); }
  void bookTicket(String num) async {
    final url=Uri.parse('https://www.confirmtkt.com/train-booking?utm_source=railsathipro_$num');
    if(await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Redirecting... Booking hogi toh ₹15 commission ayega')));
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('RailSathi Pro', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.blue[800], foregroundColor: Colors.white, elevation: 0),
      body: Column(children: [
        if(!isPro) Container(width: double.infinity, color: Colors.amber[100], padding: EdgeInsets.symmetric(vertical: 6), child: Text('🔥 AD SPACE - Yaha AdMob ad = ₹300/day', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
        Container(color: Colors.blue[800], padding: EdgeInsets.fromLTRB(16,0,16,16), child: Row(children: [
          Expanded(child: TextField(controller: fromC, style: TextStyle(color: Colors.black), decoration: InputDecoration(filled: true, fillColor: Colors.white, labelText: 'FROM', hintText: 'NDLS/delhi', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), isDense: true, prefixIcon: Icon(Icons.my_location)))),
          SizedBox(width: 8), Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Icon(Icons.swap_horiz, color: Colors.blue[800])), SizedBox(width: 8),
          Expanded(child: TextField(controller: toC, style: TextStyle(color: Colors.black), decoration: InputDecoration(filled: true, fillColor: Colors.white, labelText: 'TO', hintText: 'AGC/agra', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), isDense: true, prefixIcon: Icon(Icons.location_on)))),
        ])),
        Padding(padding: EdgeInsets.all(12), child: SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: search, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Search REAL Trains', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))))),
        Expanded(child: ListView.builder(itemCount: filtered.length, itemBuilder: (c,i){ var t=filtered[i]; return Card(margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6), elevation: 2, child: ListTile(leading: CircleAvatar(backgroundColor: Colors.blue[800], child: Text(t['num'].toString().substring(0,2), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))), title: Text('${t['num']} - ${t['name']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(height: 4), Text('${t['from']} ${t['dep']} → ${t['to']} ${t['arr']} | ${t['type']
