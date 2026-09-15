import 'package:flutter/material.dart';

void main() => runApp(RailSathiApp());

class RailSathiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: Color(0xFF0F52BA), scaffoldBackgroundColor: Color(0xFFF6F7FB)),
      home: SplashScreen(),
    );
  }
}

// 1. SPLASH - Ek dum professional start
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.train_rounded, size: 100, color: Color(0xFF0F52BA)),
          SizedBox(height: 16),
          Text('RailSathi', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF0A2A6B))),
          Text('Bharat Ki Apni Train App', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ]),
      ),
    );
  }
}

// 2. MAIN NAVIGATION
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final screens = [HomeDashboard(), PNRScreen(), LiveStatusScreen(), AccountScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), label: 'PNR'),
          NavigationDestination(icon: Icon(Icons.train), label: 'Live'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account'),
        ],
      ),
    );
  }
}

// 3. HOME DASHBOARD - YAHI CHAHIYE THA TUJHE
class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 10),
          Text('RailSathi', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA))),
          Text('Welcome! Kya check karna hai?', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          // Bade bade options
          Row(children: [
            _homeCard(context, Icons.search, 'Train\nSearch', Color(0xFF0F52BA), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TrainSearchForm()));
            }),
            SizedBox(width: 12),
            _homeCard(context, Icons.confirmation_number, 'PNR\nStatus', Colors.green, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PNRScreen(showAppBar: true)));
            }),
          ]),
          SizedBox(height: 12),
          Row(children: [
            _homeCard(context, Icons.location_on, 'Live\nStatus', Colors.orange, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStatusScreen(showAppBar: true)));
            }),
            SizedBox(width: 12),
            _homeCard(context, Icons.event_seat, 'Seat\nAvailability', Colors.purple, () {}),
          ]),
          SizedBox(height: 20),
          Container(
            width: double.infinity, padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Icon(Icons.discount, color: Color(0xFF0F52BA)),
              SizedBox(width: 10),
              Text('Get 100% Refund on Waitlist Tickets!', style: TextStyle(fontWeight: FontWeight.bold))
            ]),
          )
        ]),
      ),
    );
  }

  Widget _homeCard(BuildContext ctx, IconData icon, String title, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 120,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 32),
            Spacer(),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ),
      ),
    );
  }
}

// 4. TRAIN SEARCH FORM - PEHLE FORM, FIR LIST
class TrainSearchForm extends StatefulWidget {
  @override
  _TrainSearchFormState createState() => _TrainSearchFormState();
}
class _TrainSearchFormState extends State<TrainSearchForm> {
  bool showList = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Trains'), backgroundColor: Color(0xFF0F52BA), foregroundColor: Colors.white),
      body: showList ? TrainListScreen() : Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          TextField(decoration: InputDecoration(labelText: 'From - Delhi', prefixIcon: Icon(Icons.train), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'To - Mumbai', prefixIcon: Icon(Icons.location_on), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'Date - 16 Oct', prefixIcon: Icon(Icons.calendar_month), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
          SizedBox(height: 20),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0F52BA)),
            onPressed: () => setState(() => showList = true),
            child: Text('Search Trains', style: TextStyle(color: Colors.white, fontSize: 18))
          ))
        ]),
      ),
    );
  }
}

// 5. TRAIN LIST - TABHI DIKHEGI JAB SEARCH KAREGA
class TrainListScreen extends StatelessWidget {
  final trains = [
    {'no':'12951','name':'Rajdhani Express','time':'16:05','dur':'18h 20m','arr':'10:25','tag':'Fastest • Rajdhani','avail':'42','price':'1
