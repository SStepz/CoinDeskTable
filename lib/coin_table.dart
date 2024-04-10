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

  @override
  void initState() {
    super.initState();
    _fetchCoinData();
  }

  void _fetchCoinData() async {
    final response = await http
        .get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));
    if (response.statusCode == 200) {
      setState(() {
        _coinData = json.decode(response.body)['bpi'];
      });
    } else {
      throw Exception('Failed to fetch coin data');
    }
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
                    const TableRow(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 147, 223, 247),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Code',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Symbol',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Rate',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Rate Float',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ..._coinData!.entries.map(
                      (entry) {
                        final data = entry.value;
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(data['code']),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(NumberFormat.compactSimpleCurrency(
                                      name: data['code'])
                                  .currencySymbol),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['rate'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['description'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['rate_float'].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    // ...coinData2.entries.map(
                    //   (entry) {
                    //     final data = entry.value;
                    //     return TableRow(
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(data['code']),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(NumberFormat.compactSimpleCurrency(
                    //                   name: data['code'])
                    //               .currencySymbol),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(
                    //             data['rate'],
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(
                    //             data['description'],
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Text(
                    //             data['rate_float'].toString(),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
