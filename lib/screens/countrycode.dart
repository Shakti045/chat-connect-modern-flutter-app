import 'package:flutter/material.dart';

import 'package:chatconnect/data/countrycode.dart';

class CountryCode extends StatefulWidget {
  const CountryCode({super.key});

  @override
  State<CountryCode> createState() {
    return _CountryCodeState();
  }
}

class _CountryCodeState extends State<CountryCode> {
  List precountrycodes = countrycodes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Choose your product',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 32, 36, 36),
            ),
            child: Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (String text) {
                      if (text.isEmpty) {
                        return;
                      }
                      final List updatedcountrycodes = countrycodes
                          .where((countrycode) => countrycode['country']
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()))
                          .toList();
                      setState(() {
                        precountrycodes = updatedcountrycodes;
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: "Search",
                       enabledBorder: InputBorder.none,
                       focusedBorder: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (var countrycode in precountrycodes)
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop(countrycode);
                    },
                    title: Text(countrycode['country']!),
                    trailing: Text(countrycode['code']!),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
