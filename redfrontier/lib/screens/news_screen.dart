import 'package:flutter/material.dart';

import '../models/reports.dart';
import '../widgets/repnews_details.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  void _openNews() {
    showDialog(context: context, builder: (context) => const RepNewsDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: dummyReports.length,
          itemBuilder: (context, index) {
            final _news = dummyReports[index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: _openNews,
                child: Card(
                  color: const Color(0xFFD2B48C),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          _news['image'] as String,
                          height: 50,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: Column(
                          children: [
                            Text(
                              _news['title'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFB24D4D)),
                            ),
                            Text(
                              _news['description'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
