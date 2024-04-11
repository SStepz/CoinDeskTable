import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// import 'package:coin_desk/data/local_data.dart';

class CoinTable extends StatefulWidget {
  const CoinTable({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CoinTableState();
  }
}

class _CoinTableState extends State<CoinTable> {
  Map<String, dynamic>? _coinData;
  List<String>? _keyData;

  @override
  void initState() {
    _fetchCoinData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Desk Table'),
      ),
      body: _coinData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 147, 223, 247),
                      ),
                      children: _keyData!.map((key) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: allTextStyle(
                            text: key.toUpperCase(),
                            weight: FontWeight.bold,
                            align: key == 'code' || key == 'symbol'
                                ? TextAlign.start
                                : TextAlign.center,
                          ),
                        );
                      }).toList(),
                    ),
                    ..._coinData!.entries.map(
                      (entry) {
                        final data = entry.value;
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: allTextStyle(
                                text: data['code'],
                                align: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: allTextStyle(
                                text: NumberFormat.compactSimpleCurrency(
                                        name: data['code'])
                                    .currencySymbol,
                                align: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: allTextStyle(
                                text: data['rate'],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: allTextStyle(
                                text: data['description'],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: allTextStyle(
                                text: data['rate_float'].toString(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _fetchCoinData() async {
    final response = await http
        .get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));
    if (response.statusCode == 200) {
      setState(() {
        _coinData = json.decode(response.body)['bpi'];
        _keyData = _coinData!.entries.first.value.keys.toList();
      });
    } else {
      throw Exception('Failed to fetch coin data');
    }
  }

  Widget allTextStyle({
    required String text,
    FontWeight? weight,
    TextAlign? align,
  }) {
    return Text(
      text,
      style: TextStyle(fontWeight: weight ?? FontWeight.normal),
      textAlign: align ?? TextAlign.center,
    );
  }
}
