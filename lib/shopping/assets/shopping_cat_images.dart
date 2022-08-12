ShoppingCatImages spgCatImgs = ShoppingCatImages();

class ShoppingCatImages {
  final mobiles = ShoopingCatModel(
      name: "Mobiles",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Fmobiles.webp?alt=media&token=2f09e952-ba4a-48ab-9de0-db50d48a7de5");
  final appliances = ShoopingCatModel(
      name: "Appliances",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Fappliances.webp?alt=media&token=187106e9-0c18-4a9c-8732-76804b69a798");

  final beauty = ShoopingCatModel(
      name: "Beauty",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Fbeauty.webp?alt=media&token=bab64d59-fdb8-431f-91ed-f5d2e1be3896");

  final electronics = ShoopingCatModel(
      name: "Electronics",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Felectronics.webp?alt=media&token=283e683c-3843-4127-8665-f3414a854d22");
  final fashion = ShoopingCatModel(
      name: "Fashion",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Ffashion.webp?alt=media&token=d1021f72-4dec-4906-8cf9-6f21e0687cf4");
  final furnitures = ShoopingCatModel(
      name: "Furniture",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Ffurnitures.webp?alt=media&token=34dd36e6-f0ae-41ec-a947-b88418e6a33b");
  final grocery = ShoopingCatModel(
      name: "Grocery",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Fgrocery.webp?alt=media&token=6b10eca6-f9a6-4640-b58b-5faf81b71cff");
  final home = ShoopingCatModel(
      name: "Home",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Fhome.webp?alt=media&token=3f25e17e-7e5f-43cd-9fee-8e01afd04ab0");
  final travel = ShoopingCatModel(
      name: "Travel",
      image:
          "https://firebasestorage.googleapis.com/v0/b/mlm-app-vijayawada.appspot.com/o/shopping_category%2Ftravel.webp?alt=media&token=26faccee-fbc3-40c2-9b3b-8b03f107513d");
}

class ShoopingCatModel {
  String name;
  String image;
  ShoopingCatModel({
    required this.name,
    required this.image,
  });
}
