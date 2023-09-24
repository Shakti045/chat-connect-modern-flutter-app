import 'package:chatconnect/screens/auth.dart';
import 'package:chatconnect/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class Otp extends StatelessWidget {
  const Otp({super.key, required this.verificationid, required this.number});
  final String verificationid;
  final String number;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your otp'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinputExample(verificationid: verificationid),
            const SizedBox(
              height: 30,
            ),
            Text(
              'We have sent an verification code on $number',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit number')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send_to_mobile),
                label: const Text('Resend otp'))
          ],
        ),
      ),
    );
  }
}

class PinputExample extends StatefulWidget {
  const PinputExample({super.key, required this.verificationid});

  final String verificationid;

  @override
  State<PinputExample> createState() => _PinputExampleState();
}

class _PinputExampleState extends State<PinputExample> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    void verifyotp(String otp) async {
      setState(() {
        loading = true;
      });
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationid,
        smsCode: otp,
      );

      try {
        final credentials =
            await FirebaseAuth.instance.signInWithCredential(credential);
        if (!context.mounted) {
          return;
        }
        final firestore = FirebaseFirestore.instance;
        final firestoreref =
            firestore.collection('users').doc(credentials.user!.uid);
        final user = await firestoreref.get();
        if (!user.exists) {
          await firestoreref.set({
            "userid": credentials.user!.uid,
            "profilephoto": "https://i.stack.imgur.com/34AD2.jpg",
            "number":credentials.user!.phoneNumber,
            "name":credentials.user!.phoneNumber,
            "about":"Can't talk whatsapp only",
            "conversations": [],
          });
        }
        if (!context.mounted) {
          return;
        }
        Navigator.of(context).pop();
        Navigator.of(context).replace(
            oldRoute: MaterialPageRoute(
                builder: (BuildContext context) => const AuthScreen()),
            newRoute: MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()));
      } on FirebaseAuthException catch (err) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(err.message ?? "Something went wrong")));
        }
      }
      setState(() {
        loading = false;
      });
    }

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Form(
      key: formKey,
      child: Center(
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                controller: pinController,
                length: 6,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 8),
                onCompleted: (pin) {
                  verifyotp(pin);
                },
                // onChanged: (value) {
                //   debugPrint('onChanged: $value');
                // },
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 1,
                      color: focusedBorderColor,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
