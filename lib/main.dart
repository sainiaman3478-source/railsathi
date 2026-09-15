import 'package:flutter/material.dart';

void main() => runApp(RailSathiApp());

class RailSathiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Color(0xFF0F52BA),
        scaffoldBackgroundColor: Color(0xFFF6F7FB),
        fontFamily: 'Roboto',
      ),
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
  final screens = [TrainListScreen(), PNRScreen(), LiveStatusScreen(), AccountScreen()];

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

// HOME - TRAIN LIST
class TrainListScreen extends StatelessWidget {
  final trains = [
    {'no':'12951','name':'Rajdhani Express','time':'16:05','dur':'18h 20m','arr':'10:25','tag':'Fastest • Rajdhani','avail':'42','price':'1,980'},
    {'no':'12213','name':'Duronto Express','time':'21:30','dur':'17h 55m','arr':'15:25','tag':'Superfast','avail':'18','price':'1,920'},
    {'no':'12952','name':'Mumbai Rajdhani','time':'22:40','dur':'18h 45m','arr':'17:25','tag':'Express','avail':'WL 12','price':'2,010'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RailSathi', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F52BA))),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade300)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Delhi → Mumbai', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Wed, 16 Oct • 1 Passenger • AC 3 Tier', style: TextStyle(color: Colors.grey)),
                      ]),
                      Icon(Icons.calendar_month, color: Color(0xFF0F52BA))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: Color(0xFF0F52BA), borderRadius: BorderRadius.circular(24)),
                  child: Row(children: [
                    Text('Showing 12 trains • Today, 16 Oct', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: trains.length,
              itemBuilder: (c,i){
                final t = trains[i];
                bool isAvailable =!t['avail']!.contains('WL');
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(20)), child: Text(t['tag']!, style: TextStyle(fontSize: 12, color: Color(0xFF0F52BA), fontWeight: FontWeight.bold))),
                          Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: isAvailable? Colors.green.shade100 : Colors.orange.shade100, borderRadius: BorderRadius.circular(20)), child: Text(isAvailable? 'Available ${t['avail']}' : 'Waitlist ${t['avail']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('${t['no']} • ${t['name']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${t['time']}\nDelhi NDLS', style: TextStyle(fontWeight: FontWeight.bold)),
                          Column(children: [Text(t['dur']!, style: TextStyle(color: Colors.grey)), Icon(Icons.train, size: 16)]),
                          Text('${t['arr']} +1d\nMumbai CSMT', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(children: [
                        Chip(label: Text('AC 3 Tier • ₹${t['price']}')),
                        SizedBox(width: 6),
                        Chip(label: Text('AC 2 Tier • ₹2,850')),
                      ]),
                      SizedBox(height: 10),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0F52BA)), child: Text('View Seats >', style: TextStyle(color: Colors.white)))),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// PNR SCREEN
class PNRScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PNR Status'), backgroundColor: Color(0xFF0F52BA), foregroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Enter 10-digit PNR', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: Icon(Icons.confirmation_number))),
            SizedBox(height: 16),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0F52BA)), child: Text('Check PNR Status', style: TextStyle(color: Colors.white, fontSize: 16)))),
            SizedBox(height: 30),
            Icon(Icons.train_outlined, size: 80, color: Colors.grey.shade300),
            Text('Enter PNR to get live booking status', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// LIVE STATUS SCREEN
class LiveStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Train Status'), backgroundColor: Color(0xFF0F52BA), foregroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Enter Train Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: Icon(Icons.train))),
            SizedBox(height: 16),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0F52BA)), child: Text('Check Live Status', style: TextStyle(color: Colors.white, fontSize: 16)))),
            SizedBox(height: 30),
            Icon(Icons.location_on_outlined, size: 80, color: Colors.grey.shade300),
            Text('Track your train in real-time', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Account')), body: Center(child: Text('RailSathi - Bharat ki Train\nVersion 2.0 Professional', textAlign: TextAlign.center)));
  }
}
