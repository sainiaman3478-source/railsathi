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
  @override
  void initState() { super.initState(); Future.delayed(const Duration(seconds: 2), (){ if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const MainScreen())); }); }
  @override Widget build(BuildContext context) { return const Scaffold(backgroundColor: Colors.white, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.train_rounded, size: 90, color: Color(0xFF0F52BA)), SizedBox(height: 12), Text('RailSathi', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF0A2A6B))), Text('Bharat Ki Apni Train App', style: TextStyle(color: Colors.grey))]))); }
}

class MainScreen extends StatefulWidget { const MainScreen({super.key}); @override State<MainScreen> createState() => _MainScreenState(); }
class _MainScreenState extends State<MainScreen> {
  int _i=0;
  final _pages = const [HomeDashboard(), PNRScreen(), LiveStatusScreen(), AccountScreen()];
  @override Widget build(BuildContext context) { return Scaffold(body: _pages[_i], bottomNavigationBar: NavigationBar(selectedIndex: _i, onDestinationSelected: (v)=>setState(()=>_i=v), destinations: const [NavigationDestination(icon: Icon(Icons.home), label: 'Home'), NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), label: 'PNR'), NavigationDestination(icon: Icon(Icons.train), label: 'Live'), NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account')])); }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('RailSathi', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA))),
      const Text('Welcome! Kya check karna hai?', style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 16),
      InkWell(onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> const TrainSearchReal())), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: const Row(children: [Icon(Icons.search, color: Colors.grey), SizedBox(width: 10), Text('Kahan jaana hai? NDLS se AGC...', style: TextStyle(color: Colors.grey))]))),
      const SizedBox(height: 16),
      Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0F52BA), Color(0xFF3A7BFF)]), borderRadius: BorderRadius.circular(14)), child: const Row(children: [Icon(Icons.discount, color: Colors.white), SizedBox(width: 10), Expanded(child: Text('100% Refund on Waitlist! + General Bheed Meter LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))])),
      const SizedBox(height: 16),
      Row(children: [_card(context, Icons.search, 'Train\nSearch', const Color(0xFF0F52BA), const TrainSearchReal()), const SizedBox(width: 12), _card(context, Icons.confirmation_number, 'PNR\nStatus', Colors.green, const PNRScreen())]),
      const SizedBox(height: 12),
      Row(children: [_card(context, Icons.location_on, 'Live\nStatus', Colors.orange, const LiveStatusScreen()), const SizedBox(width: 12), _card(context, Icons.event_seat, 'Seat\nAvailability', Colors.purple, const TrainSearchReal())]),
      const SizedBox(height: 12),
      Row(children: [_uniqueCard(context, 'Bheed Meter', 'General me kitni bheed?', Icons.people, Colors.redAccent, const BheedMeterScreen()), const SizedBox(width: 12), _uniqueCard(context, 'Station Alarm', 'Sone se pehle lagao', Icons.alarm, Colors.teal, const AlarmScreen())]),
    ])));
  }
  static Widget _card(BuildContext ctx, IconData ic, String t, Color c, Widget p){ return Expanded(child: InkWell(onTap: ()=>Navigator.push(ctx, MaterialPageRoute(builder: (_)=>p)), child: Container(height: 110, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(ic, color: c, size: 28), const Spacer(), Text(t, style: const TextStyle(fontWeight: FontWeight.bold))])))); }
  static Widget _uniqueCard(BuildContext ctx, String title, String sub, IconData ic, Color c, Widget p){ return Expanded(child: InkWell(onTap: ()=>Navigator.push(ctx, MaterialPageRoute(builder: (_)=>p)), child: Container(height: 110, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(ic, color: c), const SizedBox(height: 6), Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: c)), Text(sub, style: const TextStyle(fontSize: 10))])))); }
}

// --- REAL TRAIN SEARCH ---
class TrainSearchReal extends StatefulWidget { const TrainSearchReal({super.key}); @override State<TrainSearchReal> createState() => _TrainSearchRealState(); }
class _TrainSearchRealState extends State<TrainSearchReal> {
  final from = TextEditingController(text: 'NDLS');
  final to = TextEditingController(text: 'AGC');
  List trains = []; bool loading = false; String msg='NDLS se AGC search karke dekho';
  Future<void> search() async {
    setState(()=>{loading=true, msg='Search ho raha hai...'});
    try{
      final date = DateTime.now().toIso8601String().split('T')[0];
      final url = Uri.parse('https://ct-api.confirmtkt.com/api/trains/v1/search?from=${from.text.trim().toUpperCase()}&to=${to.text.trim().toUpperCase()}&date=$date');
      final res = await http.get(url);
      if(res.statusCode==200){
        final d=jsonDecode(res.body);
        setState(()=>trains=d['data']??[]);
        setState(()=>msg=trains.isEmpty?'Koi train nahi mili - code check karo':'${trains.length} trains mili');
      } else { setState(()=>msg='Error: ${res.statusCode}'); }
    }catch(e){ setState(()=>msg='Error: $e'); }
    setState(()=>loading=false);
  }
  @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('REAL Train Search'), backgroundColor: const Color(0xFF0F52BA), foregroundColor: Colors.white), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [TextField(controller: from, decoration: const InputDecoration(labelText: 'From - NDLS/AOH/DLI', border: OutlineInputBorder())), const SizedBox(height:10), TextField(controller: to, decoration: const InputDecoration(labelText: 'To - AGC/LKO/CNB', border: OutlineInputBorder())), const SizedBox(height:10), SizedBox(width: double.infinity, height: 45, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)), onPressed: loading?null:search, child: loading?const SizedBox(height: 20, width:20, child:CircularProgressIndicator(color: Colors.white, strokeWidth: 2)):const Text('Search REAL Trains', style: TextStyle(color: Colors.white)))), const SizedBox(height:10), Text(msg, style: const TextStyle(color: Colors.grey)), const SizedBox(height:10), Expanded(child: ListView.builder(itemCount: trains.length, itemBuilder: (c,i){ final t=trains[i]; return Container(margin: const EdgeInsets.only(bottom:8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${t['number']??''} ${t['name']??''}', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height:4), Text('${t['from']??''} ${t['departure']??''} -> ${t['to']??''} ${t['arrival']??''} ${t['duration']??''}', style: const TextStyle(fontSize: 12, color: Colors.grey))])) ; }))]))); }
}

class PNRScreen extends StatelessWidget { const PNRScreen({super.key}); @override Widget build(BuildContext context){ return const Scaffold(body: Center(child: Text('PNR Screen - next step'))); } }
class LiveStatusScreen extends StatelessWidget { const LiveStatusScreen({super.key}); @override Widget build(BuildContext context){ return const Scaffold(body: Center(child: Text('Live Screen - next step'))); } }
class BheedMeterScreen extends StatelessWidget { const BheedMeterScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Bheed Meter')), body: const Center(child: Text('Next step me REAL banayenge'))); } }
class AlarmScreen extends StatelessWidget { const AlarmScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Station Alarm')), body: const Center(child: Text('Next step'))); } }
class AccountScreen extends StatelessWidget { const AccountScreen({super.key}); @override Widget build(BuildContext context){ return const Scaffold(body: Center(child: Text('RailSathi v4.1\nTrain Search REAL\nBuild Fix'))); } }
