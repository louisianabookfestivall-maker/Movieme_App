<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(const MovieMeApp());

class MovieMeApp extends StatelessWidget {
  const MovieMeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOVIE ME BY TEMIDAYO',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const AuthScreen(),
        '/otp': (context) => const OTPScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/wallet': (context) => const WalletScreen(),
        '/invite': (context) => const InviteScreen(), // NEW REFERRAL PAGE
        '/admin': (context) => const AdminScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// PREMIUM UI: AUTH SCREEN
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final referralCode = TextEditingController(); // NEW: REFERRAL INPUT
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black, Colors.purple], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('MOVIE ME', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.amber)),
              const Text('BY TEMIDAYO', style: TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 30),
              if(!isLogin) ...[
                TextField(controller: firstName, decoration: _input('First Name')),
                TextField(controller: lastName, decoration: _input('Last Name')),
                TextField(controller: referralCode, decoration: _input('Referral Code - Get 200 Naira Bonus')), // NEW
              ],
              TextField(controller: email, decoration: _input('Email')),
              TextField(controller: password, decoration: _input('Password'), obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  otp = (100000 + Random().nextInt(900000)).toString();
                  // NEW: IF REFERRAL CODE ENTERED, GIVE 200 NAIRA
                  if(referralCode.text.isNotEmpty){
                    WalletScreen.addToWallet(200); // Add bonus to referrer
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Referral Bonus: 200 Naira Added!')));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP Sent: $otp')));
                  Navigator.pushNamed(context, '/otp', arguments: otp);
                },
                child: Text(isLogin ? 'LOGIN' : 'SIGN UP & GET OTP'),
              ),
              TextButton(onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin ? 'No account? Sign Up' : 'Have account? Login', style: const TextStyle(color: Colors.amber)))
            ]),
          ),
        ),
      ),
    );
  }
  InputDecoration _input(String label) => InputDecoration(labelText: label, filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)));
}

// OTP + WELCOME
class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final correctOTP = ModalRoute.of(context)!.settings.arguments as String;
    final otpController = TextEditingController();
    return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Enter OTP'),
      SizedBox(width: 200, child: TextField(controller: otpController)),
      ElevatedButton(onPressed: () {
        if(otpController.text == correctOTP) Navigator.pushReplacementNamed(context, '/welcome');
      }, child: const Text('VERIFY'))
    ])));
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(context, '/home'));
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Welcome to MOVIE ME BY TEMIDAYO', style: TextStyle(fontSize: 28, color: Colors.amber))));
  }
}

// HOME WITH BIG PLUS + BOTTOM NAV + PREMIUM UI
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int wallet = 0;

  void showGenerators() {
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF1A1A1A), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.person), title: const Text('Human Generator'), subtitle: const Text('500 Naira per scene'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorPage(type: 'Human', price: 500)))),
        ListTile(leading: const Icon(Icons.auto_awesome), title: const Text('AI Generator'), subtitle: const Text('200 Naira per scene'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorPage(type: 'AI', price: 200)))),
        ListTile(leading: const Icon(Icons.movie), title: const Text('Production'), subtitle: const Text('100,000 Naira'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorPage(type: 'Production', price: 100000)))),
        ListTile(leading: const Icon(Icons.campaign), title: const Text('Ads'), subtitle: const Text('50,000 - 100,000 Naira'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorPage(type: 'Ads', price: 50000)))),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), actions: [IconButton(icon: const Icon(Icons.settings), onPressed: _adminCheck)]),
      body: ListView(padding: const EdgeInsets.all(16), children: const [Text('Your Generated Videos Will Show Here Like TikTok Feed')]),
      floatingActionButton: FloatingActionButton(onPressed: showGenerators, backgroundColor: Colors.amber, child: const Icon(Icons.add, color: Colors.black, size: 30)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1A1A1A),
        shape: const CircularNotchedRectangle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(icon: const Icon(Icons.account_balance_wallet), onPressed: () => Navigator.pushNamed(context, '/wallet')),
          IconButton(icon: const Icon(Icons.card_giftcard), onPressed: () => Navigator.pushNamed(context, '/invite')), // NEW: INVITE BUTTON
          const SizedBox(width: 40),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          IconButton(icon: const Icon(Icons.support_agent), onPressed: () {}),
        ]),
      ),
    );
  }

  void _adminCheck() {
    showDialog(context: context, builder: (_) {
      final code = TextEditingController();
      return AlertDialog(title: const Text('Admin Code'), content: TextField(controller: code),
          actions: [TextButton(onPressed: () {if(code.text == 'TEMIDAYO2026') Navigator.pushNamed(context, '/admin');}, child: const Text('Enter'))]);
    });
  }
}

// NEW: INVITE & EARN SCREEN
class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invite & Earn 200 Naira')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        const Icon(Icons.card_giftcard, size: 100, color: Colors.amber),
        const SizedBox(height: 20),
        const Text('Earn 200 Naira For Every Friend!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('Share your referral code. When they sign up, 200 Naira go enter your wallet instantly'),
        const SizedBox(height: 30),
        Card(color: Colors.purple, child: ListTile(
          title: const Text('Your Referral Code'),
          trailing: const Text('TEMI2026', style: TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold)),
        )),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Referral Link Copied!')));
        }, child: const Text('COPY REFERRAL LINK')),
      ])),
    );
  }
}

// WALLET + PAYMENT
class WalletScreen extends StatefulWidget { // CHANGED TO STATEFUL
  const WalletScreen({super.key});
  static int balance = 0; // NEW: STATIC BALANCE FOR REFERRAL
  static void addToWallet(int amount){ // NEW: FUNCTION TO ADD MONEY
    balance += amount;
  }
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        Card(color: Colors.purple, child: ListTile(title: const Text('Balance'), trailing: Text('${WalletScreen.balance} Naira', style: const TextStyle(fontSize: 24, color: Colors.amber)))), // UPDATED
        ElevatedButton(onPressed: () {
          showDialog(context: context, builder: (_) => AlertDialog(
            title: const Text('Fund Wallet'),
            content: const Text('Send money to:\n8144485466\nMoniepoint\nTemidayo Joshua Ojo\nThen upload screenshot'),
            actions: [TextButton(onPressed: () {}, child: const Text('Upload Screenshot'))],
          ));
        }, child: const Text('FUND WALLET')),
        const Text('Transaction History'),
      ])),
    );
  }
}

// GENERATOR + FAKE AI GENERATING
class GeneratorPage extends StatefulWidget {
  final String type; final int price;
  const GeneratorPage({super.key, required this.type, required this.price});
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  bool generating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type)),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        Text('Price: ${widget.price} Naira per scene'),
        const TextField(decoration: InputDecoration(labelText: 'Upload Script/Photo/Voice')),
        ElevatedButton(onPressed: () {
          setState(() => generating = true);
          Future.delayed(const Duration(seconds: 10), () {
            setState(() => generating = false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video Generated! Check Profile')));
          });
        }, child: generating ? const CircularProgressIndicator() : const Text('GENERATE')),
      ])),
    );
  }
}

// ADMIN DASHBOARD
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard - TEMIDAYO ONLY')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Downloads: 1,234'),
        Text('Active Users: 56'),
        Text('Total Wallet Money: ${WalletScreen.balance} Naira'), // UPDATED
        const Text('Pending Payments: 3'),
        const Text('Broadcast to Users Button'),
      ])),
    );
  }
=======
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(const MovieMeApp());

class MovieMeApp extends StatelessWidget {
  const MovieMeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOVIE ME BY TEMIDAYO',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const AuthScreen(),
        '/otp': (context) => const OTPScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/wallet': (context) => const WalletScreen(),
        '/invite': (context) => const InviteScreen(), // NEW REFERRAL PAGE
        '/admin': (context) => const AdminScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// PREMIUM UI: AUTH SCREEN
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final referralCode = TextEditingController(); // NEW: REFERRAL INPUT
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black, Colors.purple], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('MOVIE ME', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.amber)),
              const Text('BY TEMIDAYO', style: TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 30),
              if(!isLogin) ...[
                TextField(controller: firstName, decoration: _input('First Name')),
                TextField(controller: lastName, decoration: _input('Last Name')),
                TextField(controller: referralCode, decoration: _input('Referral Code - Get 200 Naira Bonus')), // NEW
              ],
              TextField(controller: email, decoration: _input('Email')),
              TextField(controller: password, decoration: _input('Password'), obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  otp = (100000 + Random().nextInt(900000)).toString();
                  // NEW: IF REFERRAL CODE ENTERED, GIVE 200 NAIRA
                  if(referralCode.text.isNotEmpty){
                    WalletScreen.addToWallet(200); // Add bonus to referrer
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Referral Bonus: 200 Naira Added!')));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP Sent: $otp')));
                  Navigator.pushNamed(context, '/otp', arguments: otp);
                },
                child: Text(isLogin ? 'LOGIN' : 'SIGN UP & GET OTP'),
              ),
              TextButton(onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin ? 'No account? Sign Up' : 'Have account? Login', style: const TextStyle(color: Colors.amber)))
            ]),
          ),
        ),
      ),
    );
  }
  InputDecoration _input(String label) => InputDecoration(labelText: label, filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)));
}

// OTP + WELCOME
class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final correctOTP = ModalRoute.of(context)!.settings.arguments as String;
    final otpController = TextEditingController();
    return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Enter OTP'),
      SizedBox(width: 200, child: TextField(controller: otpController)),
      ElevatedButton(onPressed: () {
        if(otpController.text == correctOTP) Navigator.pushReplacementNamed(context, '/welcome');
      }, child: const Text('VERIFY'))
    ])));
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(context, '/home'));
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Welcome to MOVIE ME BY TEMIDAYO', style: TextStyle(fontSize: 28, color: Colors.amber))));
  }
}

// HOME WITH BIG PLUS + BOTTOM NAV + PREMIUM UI
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int wallet = 0;

  void showGenerators() {
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF1A1A1A), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.person), title: const Text('Human Generator'), subtitle: const Text('500 Naira per scene'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorPage(type: 'Human', price: 500)))),
        ListTile(leading: const Icon(Icons.auto_awesome), title: const Text('AI Generator'), subtitle: const Text('200 Naira per scene'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorPage(type: 'AI', price: 200)))),
        ListTile(leading: const Icon(Icons.movie), title: const Text('Production'), subtitle: const Text('100,000 Naira'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorPage(type: 'Production', price: 100000)))),
        ListTile(leading: const Icon(Icons.campaign), title: const Text('Ads'), subtitle: const Text('50,000 - 100,000 Naira'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorPage(type: 'Ads', price: 50000)))),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), actions: [IconButton(icon: const Icon(Icons.settings), onPressed: _adminCheck)]),
      body: ListView(padding: const EdgeInsets.all(16), children: const [Text('Your Generated Videos Will Show Here Like TikTok Feed')]),
      floatingActionButton: FloatingActionButton(onPressed: showGenerators, backgroundColor: Colors.amber, child: const Icon(Icons.add, color: Colors.black, size: 30)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1A1A1A),
        shape: const CircularNotchedRectangle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(icon: const Icon(Icons.account_balance_wallet), onPressed: () => Navigator.pushNamed(context, '/wallet')),
          IconButton(icon: const Icon(Icons.card_giftcard), onPressed: () => Navigator.pushNamed(context, '/invite')), // NEW: INVITE BUTTON
          const SizedBox(width: 40),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          IconButton(icon: const Icon(Icons.support_agent), onPressed: () {}),
        ]),
      ),
    );
  }

  void _adminCheck() {
    showDialog(context: context, builder: (_) {
      final code = TextEditingController();
      return AlertDialog(title: const Text('Admin Code'), content: TextField(controller: code),
          actions: [TextButton(onPressed: () {if(code.text == 'TEMIDAYO2026') Navigator.pushNamed(context, '/admin');}, child: const Text('Enter'))]);
    });
  }
}

// NEW: INVITE & EARN SCREEN
class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invite & Earn 200 Naira')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        const Icon(Icons.card_giftcard, size: 100, color: Colors.amber),
        const SizedBox(height: 20),
        const Text('Earn 200 Naira For Every Friend!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('Share your referral code. When they sign up, 200 Naira go enter your wallet instantly'),
        const SizedBox(height: 30),
        Card(color: Colors.purple, child: ListTile(
          title: const Text('Your Referral Code'),
          trailing: const Text('TEMI2026', style: TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold)),
        )),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Referral Link Copied!')));
        }, child: const Text('COPY REFERRAL LINK')),
      ])),
    );
  }
}

// WALLET + PAYMENT
class WalletScreen extends StatefulWidget { // CHANGED TO STATEFUL
  const WalletScreen({super.key});
  static int balance = 0; // NEW: STATIC BALANCE FOR REFERRAL
  static void addToWallet(int amount){ // NEW: FUNCTION TO ADD MONEY
    balance += amount;
  }
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        Card(color: Colors.purple, child: ListTile(title: const Text('Balance'), trailing: Text('${WalletScreen.balance} Naira', style: const TextStyle(fontSize: 24, color: Colors.amber)))), // UPDATED
        ElevatedButton(onPressed: () {
          showDialog(context: context, builder: (_) => AlertDialog(
            title: const Text('Fund Wallet'),
            content: const Text('Send money to:\n8144485466\nMoniepoint\nTemidayo Joshua Ojo\nThen upload screenshot'),
            actions: [TextButton(onPressed: () {}, child: const Text('Upload Screenshot'))],
          ));
        }, child: const Text('FUND WALLET')),
        const Text('Transaction History'),
      ])),
    );
  }
}

// GENERATOR + FAKE AI GENERATING
class GeneratorPage extends StatefulWidget {
  final String type; final int price;
  const GeneratorPage({super.key, required this.type, required this.price});
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  bool generating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type)),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        Text('Price: ${widget.price} Naira per scene'),
        const TextField(decoration: InputDecoration(labelText: 'Upload Script/Photo/Voice')),
        ElevatedButton(onPressed: () {
          setState(() => generating = true);
          Future.delayed(const Duration(seconds: 10), () {
            setState(() => generating = false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video Generated! Check Profile')));
          });
        }, child: generating ? const CircularProgressIndicator() : const Text('GENERATE')),
      ])),
    );
  }
}

// ADMIN DASHBOARD
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard - TEMIDAYO ONLY')),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Downloads: 1,234'),
        Text('Active Users: 56'),
        Text('Total Wallet Money: ${WalletScreen.balance} Naira'), // UPDATED
        const Text('Pending Payments: 3'),
        const Text('Broadcast to Users Button'),
      ])),
    );
  }
>>>>>>> 09b6ec13fda0a88fd45f3fc59537389f04bf22b2
}