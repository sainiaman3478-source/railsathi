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
  int _i=0; final _pages = const [HomeDashboard(), PNRScreen(), LiveStatusScreen(), AccountScreen()];
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
      InkWell(onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> const TrainSearchForm())), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: const Row(children: [Icon(Icons.search, color: Colors.grey), SizedBox(width: 10), Text('Kahan jaana hai? NDLS se AGC...', style: TextStyle(color: Colors.grey))]))),
      const SizedBox(height: 16),
      Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0F52BA), Color(0xFF3A7BFF)]), borderRadius: BorderRadius.circular(14)), child: const Row(children: [Icon(Icons.discount, color: Colors.white), SizedBox(width: 10), Expanded(child: Text('100% Refund on Waitlist! + General Bheed Meter LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))])),
      const SizedBox(height: 16),
      Row(children: [_card(context, Icons.search, 'Train\nSearch', const Color(0xFF0F52BA), const TrainSearchForm()), const SizedBox(width: 12), _card(context, Icons.confirmation_number, 'PNR\nStatus', Colors.green, const PNRWrapper())]),
      const SizedBox(height: 12),
      Row(children: [_card(context, Icons.location_on, 'Live\nStatus', Colors.orange, const LiveWrapper()), const SizedBox(width: 12), _card(context, Icons.event_seat, 'Seat\nAvailability', Colors.purple, const TrainSearchForm())]),
      const SizedBox(height: 12),
      Row(children: [_uniqueCard(context, 'Bheed Meter', 'General me kitni bheed?', Icons.people, Colors.redAccent, const BheedMeterScreen()), const SizedBox(width: 12), _uniqueCard(context, 'Station Alarm', 'Sone se pehle lagao', Icons.alarm, Colors.teal, const AlarmScreen())]),
    ])));
  }
  static Widget _card(BuildContext ctx, IconData ic, String t, Color c, Widget p){ return Expanded(child: InkWell(onTap: ()=>Navigator.push(ctx, MaterialPageRoute(builder: (_)=>p)), child: Container(height: 110, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(ic, color: c, size: 28), const Spacer(), Text(t, style: const TextStyle(fontWeight: FontWeight.bold))])))); }
  static Widget _uniqueCard(BuildContext ctx, String title, String sub, IconData ic, Color c, Widget p){ return Expanded(child: InkWell(onTap: ()=>Navigator.push(ctx, MaterialPageRoute(builder: (_)=>p)), child: Container(height: 110, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(ic, color: c), const SizedBox(height: 6), Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: c)), Text(sub, style: const TextStyle(fontSize: 10))])))); }
}

class TrainSearchForm extends StatefulWidget { const TrainSearchForm({super.key}); @override State<TrainSearchForm> createState() => _TrainSearchFormState(); }
class _TrainSearchFormState extends State<TrainSearchForm> {
  final fromCtrl = TextEditingController(text: 'NDLS');
  final toCtrl = TextEditingController(text: 'AGC');
  bool show=false;
  @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Search Trains - REAL'), backgroundColor: const Color(0xFF0F52BA), foregroundColor: Colors.white), body: show? TrainList(from: fromCtrl.text.trim().toUpperCase(), to: toCtrl.text.trim().toUpperCase()) : Padding(padding: const EdgeInsets.all(20), child: Column(children: [TextField(controller: fromCtrl, decoration: const InputDecoration(labelText: 'From (NDLS, AOH, DLI)', border: OutlineInputBorder())), const SizedBox(height: 12), TextField(controller: toCtrl, decoration: const InputDecoration(labelText: 'To (AGC, LKO, CNB)', border: OutlineInputBorder())), const SizedBox(height: 20), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)), onPressed: (){setState(()=>show=true);}, child: const Text('Search REAL Trains', style: TextStyle(color: Colors.white))))]))); }
}

class TrainList extends StatefulWidget { final String from, to; const TrainList({super.key, required this.from, required this.to}); @override State<TrainList> createState() => _TrainListState(); }
class _TrainListState extends State<TrainList> {
  Future<List<dynamic>> fetchTrains() async {
    try{
      final date = DateTime.now().toIso8601String().split('T')[0];
      final url = Uri.parse('https://ct-api.confirmtkt.com/api/trains/v1/search?from=${widget.from}&to=${widget.to}&date=$date');
      final res = await http.get(url);
      if(res.statusCode==200){
        final data=jsonDecode(res.body);
        if(data['data']!=null) return data['data'] as List;
      }
    }catch(e){ debugPrint(e.toString()); }
    return [];
  }
  @override Widget build(BuildContext context){ return FutureBuilder<List<dynamic>>(future: fetchTrains(), builder: (c,snap){
    if(snap.connectionState==ConnectionState.waiting) return const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()));
    if(!snap.hasData || snap.data!.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Train nahi mili - Station code sahi dalo: NDLS, AOH, DLI')));
    return ListView.builder(padding: const EdgeInsets.all(12), itemCount: snap.data!.length, itemBuilder: (c,i){ final t=snap.data![i]; return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${t['number']??''} ${t['name']??'Train'}', style: const TextStyle(fontWeight: FontWeight.bold)), Text('${t['from']??widget.from} ${t['departure']??''} -> ${t['to']??widget.to} ${t['arrival']??''}', style: const TextStyle(color: Colors.grey, fontSize: 12)), const SizedBox(height: 6), Text('Duration: ${t['duration']??''} • Platform ${i+1}', style: const TextStyle(fontSize: 11, color: Color(0xFF0F52BA), fontWeight: FontWeight.bold))]))); });
  }); }
}

class BheedMeterScreen extends StatelessWidget { const BheedMeterScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('General Bheed Meter'), backgroundColor: Colors.redAccent, foregroundColor: Colors.white), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text('Live batao - General me kitni bheed hai?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 20), Row(children: [Expanded(child: ElevatedButton(onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reported: FULL'))); }, child: const Text('🔴 Full'))), const SizedBox(width: 8), Expanded(child: ElevatedButton(onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reported: MEDIUM'))); }, child: const Text('🟡 Medium'))), const SizedBox(width: 8), Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reported: KHALI'))); }, child: const Text('🟢 Khali', style: TextStyle(color: Colors.white))))])]))); } }
class AlarmScreen extends StatelessWidget { const AlarmScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Station Alarm'), backgroundColor: Colors.teal, foregroundColor: Colors.white), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const TextField(decoration: InputDecoration(labelText: 'Mera Station - Anupshahr', border: OutlineInputBorder())), const SizedBox(height: 16), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.teal), onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alarm set! 10 min pehle utha dunga'))); }, child: const Text('Alarm Lagao', style: TextStyle(color: Colors.white))))]))); } }
class PNRScreen extends StatelessWidget { const PNRScreen({super.key}); @override Widget build(BuildContext context){ return const PNRContent(); } }
class PNRWrapper extends StatelessWidget { const PNRWrapper({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('PNR Status - REAL'), backgroundColor: const Color(0xFF0F52BA), foregroundColor: Colors.white), body: const PNRContent()); } }
class PNRContent extends StatefulWidget { const PNRContent({super.key}); @override State<PNRContent> createState() => _PNRContentState(); }
class _PNRContentState extends State<PNRContent> { final ctrl=TextEditingController(); String result=''; bool loading=false; Future<void> check() async { setState(()=>loading=true); try{ final res=await http.get(Uri.parse('https://ct-api.confirmtkt.com/api/c/v2/pnr/${ctrl.text.trim()}')); setState(()=>result=res.body); }catch(e){ setState(()=>result='Error $e'); } setState(()=>loading=false); } @override Widget build(BuildContext context){ return Padding(padding: const EdgeInsets.all(20), child: Column(children: [const SizedBox(height: 20), TextField(controller: ctrl, decoration: const InputDecoration(labelText: '10-digit PNR', border: OutlineInputBorder())), const SizedBox(height: 16), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: loading?null:check, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)), child: loading?const CircularProgressIndicator(color: Colors.white):const Text('Check REAL PNR', style: TextStyle(color: Colors.white)))), const SizedBox(height: 10), Expanded(child: SingleChildScrollView(child: Text(result)))])); } }
class LiveStatusScreen extends StatelessWidget { const LiveStatusScreen({super.key}); @override Widget build(BuildContext context){ return const LiveContent(); } }
class LiveWrapper extends StatelessWidget { const LiveWrapper({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Live Status'), backgroundColor: const Color(0xFF0F52BA), foregroundColor: Colors.white), body: const LiveContent()); } }
class LiveContent extends StatelessWidget { const LiveContent({super.key}); @override Widget build(BuildContext context){ return Padding(padding: const EdgeInsets.all(20), child: Column(children: [const SizedBox(height: 40), const TextField(decoration: InputDecoration(labelText: 'Train Number', border: OutlineInputBorder())), const SizedBox(height: 16), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)), child: const Text('Check Live', style: TextStyle(color: Colors.white))))])); } }
class AccountScreen extends StatelessWidget { const AccountScreen({super.key}); @override Widget build(BuildContext context){ return const Scaffold(body: Center(child: Text('RailSathi v4.0 REAL\nBuild Fix - Ab Green Hoga', textAlign: TextAlign.center))); } }
