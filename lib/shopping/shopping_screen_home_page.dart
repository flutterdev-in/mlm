import 'package:advaithaunnathi/shopping/Home%20screen%20w/a_offers_corosal.dart';
import 'package:advaithaunnathi/shopping/Home%20screen%20w/b_shopping_cat_w.dart';
import 'package:advaithaunnathi/shopping/Home%20screen%20w/c_products_grid_list.dart';
import 'package:flutter/material.dart';

class ShoppingScreenHomePage extends StatefulWidget {
  const ShoppingScreenHomePage({Key? key}) : super(key: key);

  @override
  State<ShoppingScreenHomePage> createState() => _ShoppingScreenHomePageState();
}

class _ShoppingScreenHomePageState extends State<ShoppingScreenHomePage> {
  @override
  void initState() {
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    
    

    return Scaffold(
      appBar: AppBar(title: const Text("Shopping screen")),
      body: ListView(
        children: const [
          OffersCarousel(),
          ShoppingCatW(),
          SizedBox(height: 10),
          ProductsGridList(),
          SizedBox(height: 60),
        ],
      ),
    );
  }



// dvdbnfbb

}




