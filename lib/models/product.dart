import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/firebase.dart';
import 'category_model.dart';

//
class Product {
  String? id;
  String name;
  List<ImageModel>? list_images;
  DateTime upload_time;
  List<DocumentReference<Map<String, dynamic>>> list_categories;
  List<PriceModel>? list_prices;
  num high_price;
  num low_price;
  List<String>? descriptions;
  String? price_type;
  bool? is_live;
  bool? is_prime;
  Reference? product_sr;

  DocumentReference<Map<String, dynamic>>? docRef;

  Product({
    required this.name,
    required this.list_images,
    required this.upload_time,
    required this.list_categories,
    required this.high_price,
    required this.low_price,
    required this.list_prices,
    required this.descriptions,
    required this.is_live,
    required this.id,
    required this.is_prime,
    required this.product_sr,
    required this.price_type,
  });

  //
  static const name_key = "name";
  static const list_images_key = "list_images";
  static const upload_time_key = "upload_time";
  static const list_categories_key = "list_categories";
  static const high_price_key = "high_price";
  static const low_price_key = "low_price";
  static const list_prices_key = "list_prices";
  static const descriptions_key = "descriptions";
  static const is_live_key = "is_live";
  static const id_key = "id";
  static const is_prime_key = "is_prime";
  static const product_sr_key = "product_sr";
  static const price_type_key = "price_type";
  //
  static final col_ref = FirebaseFirestore.instance.collection("products");

//
  Map<String, dynamic> toMap() {
    return {
      name_key: name,
      list_images_key: list_images?.map((e) => e.toMap()).toList(),
      upload_time_key: Timestamp.fromDate(upload_time),
      list_categories_key: list_categories.map((e) => e.id).toList(),
      high_price_key: list_prices != null
          ? (list_prices_desc(list_prices!).last.price ??
              list_prices_desc(list_prices!).last.mrp)
          : high_price,
      low_price_key: list_prices != null
          ? (list_prices_desc(list_prices!).first.price ??
              list_prices_desc(list_prices!).first.mrp)
          : low_price,
      list_prices_key: list_prices?.map((e) => e.toMap()).toList(),
      descriptions_key: descriptions,
      is_live_key: is_live,
      id_key: id,
      is_prime_key: is_prime,
      product_sr_key: product_sr?.fullPath,
      price_type_key: price_type,
    };
  }

  static Product fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};
    var listImages = json[list_images_key] as List?;
    var listPrcs = (json[list_prices_key] as List?)
        ?.map((e) => PriceModel.fromMap(e as Map))
        .toList();
    listPrcs?.sort((a, b) => (a.price ?? a.mrp).compareTo(b.price ?? b.mrp));

    var listCat = (json[list_categories_key] as List?)
        ?.map(((e) => e.toString()))
        .toList();
    return Product(
      name: json[name_key] ?? "",
      list_images: listImages?.map((e) => ImageModel.fromMap(e)).toList(),
      list_prices: listPrcs,
      upload_time: json[upload_time_key]?.toDate(),
      low_price: (listPrcs?.first.price ?? listPrcs?.first.mrp) ?? 0,
      high_price: (listPrcs?.last.price ?? listPrcs?.last.mrp) ?? 0,
      list_categories:
          listCat?.map((e) => CategoryModel.col_ref.doc(e)).toList() ?? [],
      descriptions:
          (json[descriptions_key] as List?)?.map((e) => e.toString()).toList(),
      is_live: json[is_live_key],
      price_type: json[price_type_key],
      id: json[id_key],
      is_prime: json[is_prime_key],
      product_sr: json[product_sr_key] != null
          ? storageRef.child(json[product_sr_key])
          : null,
    );
  }

  //
  static List<PriceModel> list_prices_desc(List<PriceModel> listPrices) {
    listPrices.sort((a, b) => (a.price ?? a.mrp).compareTo((a.price ?? a.mrp)));
    return listPrices;
  }

  
  // static Future<void> old_to_new() async {
  //   var list_old_prod =
  //       await productMOS.productsCR.orderBy(productMOS.uploadTime).get();

  //   for (var qds in list_old_prod.docs) {
  //     var prod = ProductModel.fromMap(qds.data());
  //     List<DocumentReference<Map<String, dynamic>>> list_cat = [];

  //     for (var cat in prod.categories) {
  //       var qds = await CategoryModel.col_ref
  //           .where(CategoryModel.name_key, isEqualTo: cat)
  //           .limit(1)
  //           .get();
  //       list_cat.add(qds.docs.first.reference);
  //     }

  //     await col_ref.add(Product(
  //             name: prod.name,
  //             list_images: prod.images
  //                 ?.map((e) => ImageModel(url: e.url, sr: e.sr, name: null))
  //                 .toList(),
  //             upload_time: prod.uploadTime,
  //             list_categories: list_cat,
  //             high_price: prod.highPrice,
  //             low_price: prod.lowPrice,
  //             list_prices: prod.listPrices
  //                 ?.map((e) => PriceModel(
  //                     price_name: e.priceName,
  //                     mrp: e.mrp,
  //                     price: e.price,
  //                     max_per_order: e.maxPerOrder,
  //                     stock_available: e.stockAvailable))
  //                 .toList(),
  //             descriptions:
  //                 prod.descriptions?.map((e) => e.toString()).toList(),
  //             is_live: prod.isPublic,
  //             id: prod.productID,
  //             is_prime: null,
  //             product_sr: prod.productSR,
  //             price_type: prod.priceType)
  //         .toMap());
  //   }
  // }
}

//
class PriceModel {
  String price_name;
  num mrp;
  num? price;
  int stock_available;
  int max_per_order;

  PriceModel({
    required this.price_name,
    required this.mrp,
    required this.price,
    required this.max_per_order,
    required this.stock_available,
  });

  //
  static const price_name_key = "price_name";
  static const mrp_key = "mrp";
  static const price_key = "price";
  static const max_per_order_key = "max_per_order";
  static const stock_available_key = "stock_available";

  Map<String, dynamic> toMap() {
    return {
      price_name_key: price_name,
      mrp_key: mrp,
      price_key: price,
      max_per_order_key: max_per_order,
      stock_available_key: stock_available,
    };
  }

  static PriceModel fromMap(Map json) {
    return PriceModel(
      price_name: json[price_name_key] ?? "",
      mrp: json[mrp_key] ?? 0,
      price: json[price_key],
      max_per_order: json[max_per_order_key] ?? 1,
      stock_available: json[stock_available_key] ?? 1,
    );
  }
}

//

class ImageModel {
  String url;
  Reference? sr;
  String? name;

  ImageModel({
    required this.url,
    required this.sr,
    required this.name,
  });

  //
  static const url_key = "url";
  static const sr_key = "sr";
  static const name_key = "name";

  Map<String, dynamic> toMap() {
    return {
      url_key: url,
      sr_key: sr?.fullPath,
      name_key: name,
    };
  }

  static ImageModel fromMap(Map imageMap) {
    return ImageModel(
        url: imageMap[url_key], sr: imageMap[sr_key], name: imageMap[name_key]);
  }
}
