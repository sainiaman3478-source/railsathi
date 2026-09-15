import 'package:flutter/material.dart';

void main() {
  runApp(const RailSathiApp());
}

class RailSathiApp extends StatelessWidget {
  const RailSathiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0F52BA),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.train_rounded, size: 90, color: Color(0xFF0F52BA)),
            SizedBox(height: 16),
            Text('RailSathi', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF0A2A6B))),
            Text('Bharat Ki Apni Train App', style: TextStyle(color: Colors.grey, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final List<Widget> screens = const [
    HomeDashboard(),
    PNRScreen(),
    LiveStatusScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), label: 'PNR'),
          NavigationDestination(icon: Icon(Icons.train), label: 'Live'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account'),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('RailSathi', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA))),
            const Text('Welcome! Kya check karna hai?', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              children: [
                _homeCard(context, Icons.search, 'Train\nSearch', const Color(0xFF0F52BA), const TrainSearchForm()),
                const SizedBox(width: 12),
                _homeCard(context, Icons.confirmation_number, 'PNR\nStatus', Colors.green, const PNRScreenWrapper()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _homeCard(context, Icons.location_on, 'Live\nStatus', Colors.orange, const LiveStatusWrapper()),
                const SizedBox(width: 12),
                _homeCard(context, Icons.event_seat, 'Seat\nAvailability', Colors.purple, const TrainSearchForm()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeCard(BuildContext ctx, IconData icon, String title, Color color, Widget page) {
    return Expanded(
      child: InkWell(
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => page)),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const Spacer(),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainSearchForm extends StatefulWidget {
  const TrainSearchForm({super.key});
  @override
  State<TrainSearchForm> createState() => _TrainSearchFormState();
}

class _TrainSearchFormState extends State<TrainSearchForm> {
  bool showList = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Trains'), backgroundColor: const Color(0xFF0F52BA), foregroundColor: Colors.white),
      body: showList
          ? const TrainListView()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const TextField(decoration: InputDecoration(labelText: 'From - Delhi', prefixIcon: Icon(Icons.train), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
                  const SizedBox(height: 12),
                  const TextField(decoration: InputDecoration(labelText: 'To - Mumbai', prefixIcon: Icon(Icons.location_on), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
                  const SizedBox(height: 12),
                  const TextField(decoration: InputDecoration(labelText: 'Date - 16 Oct', prefixIcon: Icon(Icons.calendar_month), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))))),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)),
                      onPressed: () => setState(() => showList = true),
                      child: const Text('Search Trains', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class TrainListView extends StatelessWidget {
  const TrainListView({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _trainCard('12951', 'Rajdhani Express', '16:05', '18h 20m', '10:25', 'Fastest • Rajdhani', '42'),
        _trainCard('12213', 'Duronto Express', '21:30', '17h 55m', '15:25', 'Superfast', '18'),
      ],
    );
  }

  Widget _trainCard(String no, String name, String time, String dur, String arr, String tag, String avail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(20)), child: Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA)))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(20)), child: Text('Available $avail', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          Text('$no • $name', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('$time\nDelhi NDLS', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(dur, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text('$arr +1d\nMumbai CSMT', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ]),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)), child: const Text('View Seats >', style: TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }
}

class PNRScreen extends StatelessWidget {
  const PNRScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const PNRContent();
  }
}

class PNRScreenWrapper extends StatelessWidget {
  const PNRScreenWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PNR Status'), backgroundColor: const Color(0xFF0F52BA), foregroundColor: Colors.white),
      body: const PNRContent(),
    );
  }
}

class PNRContent extends StatelessWidget {
  const PNRContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 60),
          const TextField(decoration: InputDecoration(labelText: 'Enter 10-digit PNR', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))), prefixIcon: Icon(Icons.confirmation_number))),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)), child: const Text('Check PNR Status', style: TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }
}

class LiveStatusScreen extends StatelessWidget {
  const LiveStatusScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const LiveContent();
  }
}

class LiveStatusWrapper extends StatelessWidget {
  const LiveStatusWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Train Status'), backgroundColor: const Color(0xFF0F52BA), foregroundColor: Colors.white),
      body: const LiveContent(),
    );
  }
}

class LiveContent extends StatelessWidget {
  const LiveContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 60),
          const TextField(decoration: InputDecoration(labelText: 'Enter Train Number', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))), prefixIcon: Icon(Icons.train))),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F52BA)), child: const Text('Check Live Status', style: TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('RailSathi v2.1\nBharat Ki Apni Train App', textAlign: TextAlign.center)));
  }
}
