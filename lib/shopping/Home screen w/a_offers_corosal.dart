import 'package:advaithaunnathi/shopping/assets/carousal_images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OffersCarousel extends StatelessWidget {
  const OffersCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CarouselSlider.builder(
          options: CarouselOptions(
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            height: 110.0,
            viewportFraction: 0.7,

            autoPlay: true,
            enlargeCenterPage: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            // padEnds: false,
            // clipBehavior: Clip.antiAlias,
          ),
          itemCount: corouselAssets.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
                  Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.orange.shade100,
            child: Image.asset(corouselAssets[itemIndex]),
          ),
        ),
      ),
    );
  }
}
