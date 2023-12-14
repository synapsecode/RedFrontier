import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:redfrontier/services/fcm.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'h1',
        onPressed: () {
          InAppMessagingService.broadcastMessage(
              title: 'HELLLPPP', message: 'SOSOSSS');
        },
        child: const Icon(Icons.sos),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              items: [
                Image.network(
                    'https://media.slidesgo.com/storage/18949018/conversions/0-planet-mars-thumb.jpg',
                    fit: BoxFit.cover),
                Image.network(
                    'https://cdn.mos.cms.futurecdn.net/BoTkdfxo9ehAPQG3qMdRxZ.jpg',
                    fit: BoxFit.cover),
                Image.network(
                    'https://imgix.bustle.com/uploads/image/2020/4/20/4f0e4ffe-434d-421c-8221-f00ac8213df2-ee1a587a-34a4-4d4d-b4d4-61a7d4faadab-shutterstock-1470652997.jpg?w=1200&h=630&fit=crop&crop=faces&fm=jpg',
                    fit: BoxFit.cover),
              ],
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 2.0,
                enableInfiniteScroll: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Mars',
                    style: TextStyle(color: Color(0xFFB24D4D)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Helping you in the red world',
                    style: TextStyle(fontSize: 16, color: Color(0xFFB24D4D)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
