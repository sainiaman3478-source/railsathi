import 'package:flutter/material.dart';
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
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: const Row(children: [Icon(Icons.search, color: Colors.grey), SizedBox(width: 10), Text('Kahan jaana hai? Delhi se...', style: TextStyle(color: Colors.grey))])),
      const SizedBox(height: 16),
      Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF0F52BA), Color(0xFF3A7BFF)]), borderRadius: BorderRadius.circular(14)), child: const Row(children: [Icon(Icons.discount, color: Colors.white), SizedBox(width: 10), Expanded(child: Text('100% Refund on Waitlist! + General Bheed Meter LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))])),
      const SizedBox(height: 16),
      Row(children: [_card(context, Icons.search, 'Train\nSearch', const Color(0xFF0F52BA)), const SizedBox(width: 12), _card(context, Icons.confirmation_number, 'PNR\nStatus', Colors.green)]),
      const SizedBox(height: 12),
      Row(children: [_card(context, Icons.location_on, 'Live\nStatus', Colors.orange), const SizedBox(width: 12), _card(context, Icons.event_seat, 'Seat\nAvailability', Colors.purple)]),
      const SizedBox(height: 12),
      Row(children: [_uniqueCard(context, 'Bheed Meter', 'General me kitni bheed?', Icons.people, Colors.redAccent), const SizedBox(width: 12), _uniqueCard(context, 'Station Alarm', 'Sone se pehle lagao', Icons.alarm, Colors.teal)]),
    ])));
  }
  static Widget _card(BuildContext ctx, IconData ic, String t, Color c){ return Expanded(child: Container(height: 110, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(ic, color: c, size: 28), const Spacer(), Text(t, style: const TextStyle(fontWeight: FontWeight.bold))]))); }
  static Widget _uniqueCard(BuildContext ctx, String title, String sub, IconData ic, Color c){ return Expanded(child: Container(height: 110, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withOpacity(0.3))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(ic, color: c), const SizedBox(height: 6), Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: c)), Text(sub, style: const TextStyle(fontSize: 10))]))); }
}
class PNRScreen extends StatelessWidget { const PNRScreen({super.key}); @override Widget build(BuildContext context){ return const Scaffold(body: Center(child: Text('PNR Screen'))); } }
class LiveStatusScreen extends StatelessWidget { const LiveStatusScreen({super.key}); @override Widget build(BuildContext context){ return const Scaffold(body: Center(child: Text('Live Screen'))); } }
class AccountScreen extends StatelessWidget { const AccountScreen({super.key}); @override Widget build(BuildContext context){ return const Scaffold(body: Center(child: Text('RailSathi v4.0\nAb Green Hoga', textAlign: TextAlign.center))); } }
