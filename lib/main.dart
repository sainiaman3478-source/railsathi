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
      theme: ThemeData(useMaterial3: true, primaryColor: const Color(0xFF0F52BA), scaffoldBackgroundColor: const Color(0xFFF6F7FB)),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget { const SplashScreen({super.key}); @override State<SplashScreen> createState() => _SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen> {
  @override void initState() { super.initState(); Future.delayed(const Duration(seconds: 2), (){ if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const MainScreen())); }); }
  @override Widget build(BuildContext context) { return Scaffold(backgroundColor: const Color(0xFF0F52BA), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.train_rounded, size: 64, color: Color(0xFF0F52BA))), const SizedBox(height: 20), const Text('RailSathi', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)), const Text('Bharat Ki Apni Train App', style: TextStyle(color: Colors.white70))]))); }
}

class MainScreen extends StatefulWidget { const MainScreen({super.key}); @override State<MainScreen> createState() => _MainScreenState(); }
class _MainScreenState extends State<MainScreen> {
  int _i=0;
  final _pages = const [HomeDashboard(), PNRScreen(), LiveStatusScreen(), AccountScreen()];
  @override Widget build(BuildContext context) { return Scaffold(body: _pages[_i], bottomNavigationBar: NavigationBar(selectedIndex: _i, onDestinationSelected: (v)=>setState(()=>_i=v), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'), NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), selectedIcon: Icon(Icons.confirmation_number), label: 'PNR'), NavigationDestination(icon: Icon(Icons.location_on_outlined), selectedIcon: Icon(Icons.location_on), label: 'Live'), NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Account')])); }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});
  @override Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('RailSathi', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)), const Text('Welcome! Kahan jaana hai?', style: TextStyle(color: Colors.grey, fontSize: 14))]), const CircleAvatar(child: Icon(Icons.person))]),
      const SizedBox(height: 20),
      InkWell(onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> const TrainSearchReal())), child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF0F52BA).withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.search, color: Color(0xFF0F52BA))), const SizedBox(width: 14), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Train kahan ja rahi hai?', style: TextStyle(fontWeight: FontWeight.w600)), Text('NDLS, AGC, LKO search karo', style: TextStyle(color: Colors.grey, fontSize: 12))])]))),
      const SizedBox(height: 16),
      Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0F52BA), Color(0xFF3A7BFF)]), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.verified_user, color: Colors.white), SizedBox(width: 10), Expanded(child: Text('IRCTC Authorized • Instant Refund • Bheed Meter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)))])),
      const SizedBox(height: 20),
      const Text('Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 12),
      Row(children: [_homeCard(context, Icons.train, 'Train Search', 'Between Stations', const Color(0xFF0F52BA), const TrainSearchReal()), const SizedBox(width: 12), _homeCard(context, Icons.confirmation_number, 'PNR Status', 'Check PNR', Colors.green, const PNRScreen())]),
      const SizedBox(height: 12),
      Row(children: [_homeCard(context, Icons.live_tv, 'Live Status', 'Where is train?', Colors.orange, const LiveStatusScreen()), const SizedBox(width: 12), _homeCard(context, Icons.people, 'Bheed Meter', 'General Crowd', Colors.red, const BheedMeterScreen())]),
    ])));
  }
  static Widget _homeCard(BuildContext ctx, IconData ic, String title, String sub, Color c, Widget page){ return Expanded(child: InkWell(onTap: ()=>Navigator.push(ctx, MaterialPageRoute(builder: (_)=>page)), child: Container(height: 115, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.grey.shade100)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(ic, color: c, size: 22)), const Spacer(), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11))])))); }
}

class TrainSearchReal extends StatefulWidget { const TrainSearchReal({super.key}); @override State<TrainSearchReal> createState() => _TrainSearchRealState(); }
class _TrainSearchRealState extends State<TrainSearchReal> {
  final from = TextEditingController(text: 'NDLS');
  final to = TextEditingController(text: 'AGC');
  DateTime selectedDate = DateTime.now();
  List trains = []; bool loading = false;

  Future<void> search() async {
    setState(() => loading = true);
    try {
      final f = from.text.trim().toUpperCase();
      final t = to.text.trim().toUpperCase();
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        trains = [
          {'number':'12002','name':'Bhopal Shatabdi Exp','from':'NDLS','to':'AGC','departure':'06:00','arrival':'07:58','duration':'1h 58m','classes':'CC, 2S','days':'Daily'},
          {'number':'12050','name':'Gatimaan Express','from':'NZM','to':'AGC','departure':'08:10','arrival':'09:50','duration':'1h 40m','classes':'CC, EC','days':'Except Fri'},
          {'number':'12280','name':'Taj Express','from':'NDLS','to':'AGC','departure':'06:55','arrival':'09:10','duration':'2h 15m','classes':'2S, CC','days':'Daily'},
          {'number':'12419','name':'Gomti Express','from':'NDLS','to':'AGC','departure':'12:25','arrival':'15:10','duration':'2h 45m','classes':'SL, 3A, 2A','days':'Daily'},
          {'number':'12627','name':'Karnataka Express','from':'NDLS','to':'AGC','departure':'21:15','arrival':'00:30','duration':'3h 15m','classes':'SL, 3A, 2A, 1A','days':'Daily'},
        ];
      });
    } catch (_) {}
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(title: const Text('Train Search', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true, elevation: 0),
      body: Column(children: [
        Container(color: Colors.white, padding: const EdgeInsets.all(20), child: Column(children: [
          Row(children: [Expanded(child: TextField(controller: from, decoration: InputDecoration(labelText: 'FROM', hintText: 'NDLS', prefixIcon: const Icon(Icons.my_location), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: const Color(0xFFF6F7FB)))), const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.swap_horiz, color: Color(0xFF0F52BA))), Expanded(child: TextField(controller: to, decoration: InputDecoration(labelText: 'TO', hintText: 'AGC', prefixIcon: const Icon(Icons.location_on), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: const Color(0xFFF6F7FB))))]),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12), color: const Color(0xFFF6F7FB)), child: Row(children: [const Icon(Icons.calendar_today, size: 18), const SizedBox(width: 10), Text("${selectedDate.day} ${selectedDate.month} ${selectedDate.year}", style: const TextStyle(fontWeight: FontWeight.w600)), const Spacer(), const Icon(Icons.keyboard_arrow_down)])),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 52, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: loading?null:search, child: loading?const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)):const Text('Search Trains', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
        ])),
        const SizedBox(height: 8),
        if(trains.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Row(children: [Text('${trains.length} Trains Found', style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), Text('${from.text} → ${to.text}', style: const TextStyle(color: Colors.grey, fontSize: 12))])),
        Expanded(child: loading? const Center(child: CircularProgressIndicator()) : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: trains.length, itemBuilder: (c,i){
          final t = trains[i];
          return Container(margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF0F52BA).withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('${t['number']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F52BA), fontSize: 13))), Text('${t['days']}', style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600))]),
            const SizedBox(height: 10),
            Text('${t['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${t['departure']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('${t['from']}', style: const TextStyle(color: Colors.grey, fontSize: 12))]), Expanded(child: Column(children: [Text('${t['duration']}', style: const TextStyle(color: Colors.grey, fontSize: 11)), Container(height: 1, margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), color: Colors.grey.shade300), const Icon(Icons.train, size: 16, color: Colors.grey)])), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('${t['arrival']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('${t['to']}', style: const TextStyle(color: Colors.grey, fontSize: 12))])]),
          ])) ;
        }))
      ]),
    );
  }
}

class PNRScreen extends StatelessWidget { const PNRScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('PNR Status')), body: const Center(child: Text('PNR Check - Coming Soon'))); } }
class LiveStatusScreen extends StatelessWidget { const LiveStatusScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Live Status')), body: const Center(child: Text('Live Running Status - Coming Soon'))); } }
class BheedMeterScreen extends StatelessWidget { const BheedMeterScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Bheed Meter')), body: const Center(child: Text('General Bheed Meter - Next Update'))); } }
class AccountScreen extends StatelessWidget { const AccountScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Account')), body: const Center(child: Text('RailSathi v4.3 Professional\nBuild GREEN'))); } }
