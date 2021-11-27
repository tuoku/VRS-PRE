import 'dart:collection';

import 'package:crypto/models/gecko_response.dart';
import 'package:crypto/models/price.dart';
import 'package:crypto/repositories/gecko_repo.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? longestBear;
  DateTime? highestVolume;
  DateTime? _startDate;
  DateTime? _endDate;

  static Route<DateTimeRange?> _dateRangePickerRoute(
    BuildContext context,
  ) {
    return DialogRoute<DateTimeRange?>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          firstDate: DateTime(2015, 1, 1),
          currentDate: DateTime.now(),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  int findLongestBear(List<Price> data) {
    int current = 1;
    int max = 1;
    // final d = data.values.toList();
    for (int i = 1; i < data.length; i++) {
      current = (data[i].price < data[i - 1].price) ? current + 1 : 1;
      if (current > max) {
        max = current;
      }
    }
    return max;
  }

/*
  List<Price> toOnePerDay(List<Price> prices) {
    var ls = [];
    prices.forEach((element) {
      if (ls.where((e) => element.time.day == e.time.day).isEmpty) {
        ls.
      }
    })
  }
*/
  void _selectDateRange(DateTimeRange? newSelectedDate) async {
    if (newSelectedDate != null) {
      GeckoResponse stats = await GeckoRepo()
          .getStats(newSelectedDate.start, newSelectedDate.end);

      setState(() {
        longestBear = findLongestBear(stats.prices);
        _startDate = newSelectedDate.start;
        _endDate = newSelectedDate.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(_dateRangePickerRoute(context))
                  .then((value) => _selectDateRange(value));
            },
            child: const Text('Open Date Range Picker'),
          ),
          Expanded(
              flex: 10,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  SizedBox(
                      width: 200,
                      child: Card(
                        borderOnForeground: true,
                        child: ListTile(
                          autofocus: false,
                          title: Text("Longest bearish trend"),
                          subtitle: Text(
                              longestBear != null ? "$longestBear Days" : "--"),
                        ),
                      )),
                  SizedBox(
                      width: 200,
                      child: Card(
                        borderOnForeground: true,
                        child: ListTile(
                          autofocus: false,
                          title: Text("Highest trading volume"),
                          subtitle: Text(highestVolume != null
                              ? highestVolume.toString()
                              : "--"),
                        ),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
