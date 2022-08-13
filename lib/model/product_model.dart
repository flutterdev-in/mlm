import 'package:advaithaunnathi/shopping/assets/shopping_cat_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String name;
  List? images;
  DateTime uploadTime;
  List categories;
  num mrp;
  num? price;
  List? descriptions;
  int stockAvailable;
  int maxPerOrder;
  DocumentReference<Map<String, dynamic>>? docRef;

  ProductModel({
    required this.name,
    required this.images,
    required this.uploadTime,
    required this.categories,
    required this.mrp,
    required this.price,
    required this.descriptions,
    required this.maxPerOrder,
    required this.stockAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      productMOS.name: name,
      productMOS.images: images,
      productMOS.uploadTime: Timestamp.fromDate(uploadTime),
      productMOS.categories: categories,
      productMOS.mrp: mrp,
      productMOS.price: price,
      productMOS.descriptions: descriptions,
      productMOS.maxPerOrder: maxPerOrder,
      productMOS.stockAvailable: stockAvailable,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> productMap) {
    return ProductModel(
      name: productMap[productMOS.name] ?? "",
      images: productMap[productMOS.images],
      uploadTime: productMap[productMOS.uploadTime]?.toDate(),
      categories: productMap[productMOS.categories],
      mrp: productMap[productMOS.mrp],
      price: productMap[productMOS.price],
      descriptions: productMap[productMOS.descriptions],
      maxPerOrder: productMap[productMOS.maxPerOrder],
      stockAvailable: productMap[productMOS.stockAvailable],
    );
  }
}

ProductModelObjects productMOS = ProductModelObjects();

class ProductModelObjects {
  final name = "name";
  final price = "price";
  final mrp = "mrp";
  final categories = "categories";
  final images = "images";
  final descriptions = "descriptions";
  final uploadTime = "uploadTime";
  final maxPerOrder = "maxPerOrder";
  final stockAvailable = "stockAvailable";
  final productsCR = FirebaseFirestore.instance.collection("products");
}

List<ProductModel> dummyProducts() {
  return [
    ProductModel(
      name: "SAMSUNG Galaxy F23 5G (Aqua Blue, 128 GB)  (6 GB RAM)",
      images: [
        "https://rukminim1.flixcart.com/image/832/832/l0sgyvk0/mobile/k/x/c/-original-imagcg22czc3ggvw.jpeg?q=70",
        "https://rukminim1.flixcart.com/image/128/128/l0fm07k0/mobile/u/j/h/-original-imagc829hsbv9bg7.jpeg?q=70",
        "https://rukminim1.flixcart.com/image/128/128/l0fm07k0/mobile/z/k/e/-original-imagc829xnfx6mgf.jpeg?q=70",
        "https://rukminim1.flixcart.com/image/128/128/l15bxjk0/mobile/l/q/k/-original-imagcs2aaj2r3apf.jpeg?q=70",
        "https://rukminim1.flixcart.com/image/128/128/l0fm07k0/mobile/y/4/1/-original-imagc829k2wscjyy.jpeg?q=70"
      ],
      uploadTime: DateTime.now(),
      categories: [spgCatImgs.mobiles.name],
      mrp: 23999,
      price: 15999,
      maxPerOrder: 2,
      stockAvailable: 10,
      descriptions: [
        "6 GB RAM | 128 GB ROM | Expandable Upto 1 TB",
        "16.76 cm (6.6 inch) Full HD+ Display",
        "50MP + 8MP + 2MP | 8MP Front Camera",
        "5000 mAh Lithium Ion Battery",
        "Qualcomm Snapdragon 750G Processor",
        "Bring home the efficient Samsung Galaxy F23 5G mobile phone that comes with a myriad of impeccable features, including fast operation, versatility, and flawless gaming experience. This phone comes with a 16.25 (6.4) Full HD+ Infinity-U Display with a refresh rate of up to 120 Hz so that you can enjoy smooth multitasking and vibrant visuals. Driven by a Snapdragon 750G processor, this mobile phone turns your gaming session intense and productive. Thanks to the Auto Data Switching feature of this phone, you can switch to a secondary SIM network when the primary SIM loses its network. Moreover, the integrated Power Cool technology of this phone allows your phone to stay cool well even when used for long hours"
      ],
    ),
    ProductModel(
        name: "Solid Men Round Neck Light Blue T-Shirt",
        images: [
          "https://rukminim1.flixcart.com/image/618/742/kyt0ya80/t-shirt/a/k/7/-original-imagayn5pfggcrjr.jpeg?q=50",
          "https://rukminim1.flixcart.com/image/618/742/kyt0ya80/t-shirt/u/a/b/-original-imagayn5qhhufxmf.jpeg?q=50",
          "https://rukminim1.flixcart.com/image/618/742/kyt0ya80/t-shirt/e/b/u/-original-imagayn5h6whfzjt.jpeg?q=50",
          "https://rukminim1.flixcart.com/image/618/742/kyt0ya80/t-shirt/g/x/l/-original-imagayn54cx8es7t.jpeg?q=50",
        ],
        uploadTime: DateTime.now(),
        categories: [spgCatImgs.fashion.name],
        mrp: 999,
        price: 549,
        maxPerOrder: 10,
        stockAvailable: 30,
        descriptions: ["Available sizes : S,M,L"]),
    ProductModel(
        name:
            "Pigeon Gas Stove Combo - Brunet 3 Burner Gas Cooktop + Flat tawa 250 + Fry Pan 240 Stainless Steel Manual Gas Stove  (3 Burners)",
        images: [
          "https://rukminim1.flixcart.com/image/832/832/xif0q/gas-stove/d/4/y/-original-imaggh8gqz2j6ts4.jpeg?q=70",
          "https://rukminim1.flixcart.com/image/832/832/xif0q/gas-stove/p/p/j/-original-imaggh8gc9c3sjfk.jpeg?q=70",
          "https://rukminim1.flixcart.com/image/832/832/xif0q/gas-stove/x/8/q/-original-imaggh8ghpjy8rw3.jpeg?q=70",
          "https://rukminim1.flixcart.com/image/832/832/xif0q/gas-stove/n/c/c/-original-imaggh8gwsusvtrv.jpeg?q=70",
        ],
        uploadTime: DateTime.now(),
        categories: [spgCatImgs.appliances.name],
        mrp: 5494,
        price: 2759,
        maxPerOrder: 3,
        stockAvailable: 8,
        descriptions: [
          "Type: Manual Gas Stove",
          "Burner Type: Brass Burner",
          "Dimension: 29 cm x 60 cm",
          "Pigeon Gas Stove Combo comes with Brunet 3 Burner and Nonstick Flat Tawa and Fry Pan. Cooking becomes easy when you have the right accessories and utensils with you. The Pigeon Brunet 3 Burner Glass Top Gas Stove features a set of two burners for cooking more than one dish at the same time. Its stands provide better balance and a unique pan support to cook chapatis, rotis, dosas, pancakes and more with ease. Its 360 degree revolving nozzle and easy-to-use design makes it ideal for all types of households."
        ]),
    ProductModel(
      name: "Fortune Everyday Basmati Rice (Long Grain)  (1 kg)",
      images: [
        "https://rukminim1.flixcart.com/image/832/832/kqidx8w0/rice/r/p/x/white-everyday-na-basmati-rice-pouch-fortune-original-imag4gb4ynggnzgt.jpeg?q=70",
        "https://rukminim1.flixcart.com/image/832/832/kqidx8w0/rice/m/y/k/white-everyday-na-basmati-rice-pouch-fortune-original-imag4gb4fbuchssa.jpeg?q=70",
        "https://rukminim1.flixcart.com/image/832/832/kqidx8w0/rice/z/a/r/white-everyday-na-basmati-rice-pouch-fortune-original-imag4gb4yckxyp6b.jpeg?q=70",
        "https://rukminim1.flixcart.com/image/832/832/kqidx8w0/rice/t/b/m/white-everyday-na-basmati-rice-pouch-fortune-original-imag4gb4zuyghhpk.jpeg?q=70",
        "https://rukminim1.flixcart.com/image/832/832/kqidx8w0/rice/5/0/q/white-everyday-na-basmati-rice-vacuum-pack-fortune-original-imag4gb3h7ghjqgz.jpeg?q=70"
      ],
      uploadTime: DateTime.now(),
      categories: [spgCatImgs.grocery.name],
      mrp: 149,
      price: 109,
      maxPerOrder: 10,
      stockAvailable: 40,
      descriptions: [
        "Fortune Everyday basmati rice is a fine variety of basmati that you can relish every day. Specially aged to help every grain of basmati become long and fluffy. On cooking, the grains do not stick together and become flavorsome. The result is an irresistible serving of basmati that delights everyones heart through its appearance and taste."
      ],
    ),
  ];
}

Future<void> addDummyProductsToFire() async {
  for (var i in dummyProducts()) {
    await productMOS.productsCR.add(i.toMap());
  }
}
