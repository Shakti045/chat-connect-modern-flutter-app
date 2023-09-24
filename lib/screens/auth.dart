import 'package:chatconnect/screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatconnect/screens/countrycode.dart';


final firebaseinstance = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  String _countryname = 'India';
  final _phonenumber = TextEditingController();
  String _countrycode = '+91';
  bool _loading = false;

  void _verificationCompleted(PhoneAuthCredential credential) {
   
  }

  void _verificationFailed(FirebaseAuthException exception) {
    setState(() {
      _loading = false;
    });
     
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Something went wrong')));
  }

  void _codeSent(String verificationid, int? resenttoken) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => Otp(number:_countrycode+_phonenumber.text,verificationid:verificationid)));
    setState(() {
      _loading = false;
    });
     

  }

  void codeAutoRetrievalTimeout(String verificationid) {}

  void _authoriseuser() async {
    
    setState(() {
      _loading = true;
    });
    firebaseinstance.verifyPhoneNumber(
        phoneNumber: _countrycode + _phonenumber.text,
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  void dispose() {
    _phonenumber.dispose();
    super.dispose();
  }

  void _navigationhelper() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const CountryCode()));

    if (result == null) {
      return;
    }
    setState(() {
      _countryname = result['country'];
      _countrycode = result['code'];
    });
  }

  @override
  Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//   SystemUiOverlayStyle(
//     statusBarColor: const Color.fromARGB(255, 20, 12, 12), // Set your desired color here
//   ),
// );

    return Scaffold(
    
      // appBar: AppBar(),
      body: SafeArea(
        
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter phone number',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 32, 36, 36),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _navigationhelper,
                      child: Container(
                        decoration: const BoxDecoration(
                            border: BorderDirectional(
                                bottom:
                                    BorderSide(width: 0.2, color: Colors.white))),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_countryname),
                              const Icon(Icons.navigate_next)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 32, 36, 36),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                border: BorderDirectional(
                                    end: BorderSide(
                                        width: 0.2, color: Colors.white))),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Text(_countrycode),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "Phone number",
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                              controller: _phonenumber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const Text(
                  'We will send you a code by SMS to confirm your phone number.'),
              const SizedBox(
                height: 25,
              ),
              const Text('We may occasionally send you service-based messages'),
              const SizedBox(
                height: 65,
              ),
              Center(
                child: _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _authoriseuser, child: const Text('Next')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
