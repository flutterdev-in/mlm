import 'package:advaithaunnathi/model/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductViewScreen extends StatelessWidget {
  final ProductModel pm;
  const ProductViewScreen(this.pm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageIndex = 0.obs;
    return Scaffold(
      appBar: AppBar(title: const Text("Produt view")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 5),
                CarouselSlider.builder(
                  options: CarouselOptions(
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      // aspectRatio: 16 / 21,
                      height: 300.0,
                      viewportFraction: 0.7,
                      enableInfiniteScroll: false,
                      // autoPlay: true,
                      // enlargeCenterPage: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 600),
                      // padEnds: false,
                      // clipBehavior: Clip.antiAlias,
                      onPageChanged: (index, reason) {
                        imageIndex.value = index;
                      }),
                  itemCount: pm.images?.length,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    // color: Colors.orange.shade100,
                    child: CachedNetworkImage(imageUrl: pm.images?[itemIndex]),
                  ),
                ),
                const SizedBox(height: 5),
                Obx(() => DotsIndicator(
                      dotsCount: pm.images?.length ?? 0,
                      position: imageIndex.value.toDouble(),
                      decorator: DotsDecorator(
                        size: const Size.square(9.0),
                        activeSize: const Size(15.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(pm.name, softWrap: true),
                ),
                Container(
                  color: Colors.green.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          "Price  ",
                          textScaleFactor: 1.5,
                        ),
                        Text(
                          "${pm.mrp}  ",
                          textScaleFactor: 1.5,
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          "\u{20B9}${pm.price}",
                          textScaleFactor: 1.5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                if (pm.descriptions != null)
                  Column(
                    children: pm.descriptions!
                        .map((e) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(MdiIcons.circleSmall),
                                Expanded(
                                    child: Text(e.toString(), softWrap: true)),
                                const SizedBox(height: 5),
                              ],
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          SizedBox(
            height: 70,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Card(
                    color: Colors.red,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Buy now",
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.white)),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiImageViewerScreen extends StatefulWidget {
  final PageController pageController;
  final ProductModel pm;

  MultiImageViewerScreen({
    Key? key,
    required this.pm,
  }) : pageController = PageController();

  @override
  State<MultiImageViewerScreen> createState() => _MultiImageViewerScreenState();
}

class _MultiImageViewerScreenState extends State<MultiImageViewerScreen> {
  @override
  void didChangeDependencies() {
    context.dependOnInheritedWidgetOfExactType(); // OK
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.pageController.dispose();
    // context.dependOnInheritedWidgetOfExactType();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var rxIndex = 0.obs;
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() {
          var afm = widget.pm.images?[rxIndex.value];

          return Text(afm, textScaleFactor: 0.8);
        }),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            pageController: widget.pageController,
            itemCount: widget.pm.images?.length,
            builder: (context, index) {
              var afm = widget.pm.images?[index];
              return PhotoViewGalleryPageOptions(
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained * 0.2,
                  maxScale: PhotoViewComputedScale.contained * 2,
                  imageProvider: CachedNetworkImageProvider(afm.rumm!.img!));
            },
            onPageChanged: (index) {
              rxIndex.value = index;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: Obx(() {
              var afm = widget.pm.images?[rxIndex.value];
              var time = DateFormat("hh:mm a")
                  .format(afm.foodTakenTime ?? DateTime.now());
              return Text(
                "Image ${rxIndex.value + 1}/${widget.pm.images?.length} ($time)",
                style: const TextStyle(color: Colors.white),
              );
            }),
          )
        ],
      ),
    );
  }
}
