import 'package:advaithaunnathi/shopping/assets/shopping_cat_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ShoppingCatW extends StatelessWidget {
  const ShoppingCatW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.shade100,
      child: Wrap(
        children: [
          cat(spgCatImgs.mobiles),
          cat(spgCatImgs.electronics),
          cat(spgCatImgs.appliances),
          cat(spgCatImgs.beauty),
          cat(spgCatImgs.home),
          cat(spgCatImgs.fashion),
          cat(spgCatImgs.grocery),
          cat(spgCatImgs.travel),
        ],
      ),
    );
  }

  Widget cat(ShoopingCatModel scm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GFAvatar(
              backgroundColor: Colors.transparent,
              size: GFSize.LARGE,
              child: CachedNetworkImage(
                imageUrl: scm.image,
                errorWidget: (context, url, error) {
                  return const GFLoader();
                },
              )),
          Text(scm.name, textScaleFactor: 0.9),
        ],
      ),
    );
  }
}
