import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OffersCarousel extends StatelessWidget {
  const OffersCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          height: 110.0,
          viewportFraction: 0.7,

          autoPlay: true,
          // enlargeCenterPage: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 600),
          // padEnds: false,
          // clipBehavior: Clip.antiAlias,
        ),
        itemCount: 8,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          color: Colors.orange.shade100,
          child: Center(child: Text(itemIndex.toString())),
        ),
      ),
    );
  }
}
