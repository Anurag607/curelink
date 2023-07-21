class Product {
  final String image, title, description, type;
  final int price, id;
  int quantity;
  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.type,
    required this.quantity,
  });
}

List<Product> products = [
  // Ointments...
  Product(
    id: 1,
    title: "Fusiderm",
    price: 234,
    type: "ointments",
    description: dummyText,
    image: "assets/medicines/Fusiderm.png",
    quantity: 10,
  ),
  Product(
    id: 2,
    title: "Terrasil",
    price: 234,
    type: "ointments",
    description: dummyText,
    image: "assets/medicines/Terrasil.png",
    quantity: 10,
  ),
  Product(
    id: 3,
    title: "CeraVe",
    price: 234,
    type: "ointments",
    description: dummyText,
    image: "assets/medicines/CeraVe.png",
    quantity: 10,
  ),
  Product(
    id: 4,
    title: "Aquaphor",
    price: 234,
    type: "ointments",
    description: dummyText,
    image: "assets/medicines/Aquaphor.png",
    quantity: 10,
  ),

  // Tablets...
  Product(
    id: 5,
    title: "Gofen 400",
    price: 234,
    type: "tablets",
    description: dummyText,
    image: "assets/medicines/Gofen 400.png",
    quantity: 10,
  ),
  Product(
    id: 6,
    title: "Aspirin C",
    price: 234,
    type: "tablets",
    description: dummyText,
    image: "assets/medicines/Aspirin-C.png",
    quantity: 10,
  ),
  Product(
    id: 7,
    title: "Doliprane",
    price: 234,
    type: "tablets",
    description: dummyText,
    image: "assets/medicines/Doliprane.png",
    quantity: 10,
  ),
  Product(
    id: 8,
    title: "Paracetamol",
    price: 234,
    type: "tablets",
    description: dummyText,
    image: "assets/medicines/Paracetamol.png",
    quantity: 10,
  ),

  // Syrups...
  Product(
    id: 9,
    title: "Allergex 100",
    price: 234,
    type: "syrups",
    description: dummyText,
    image: "assets/medicines/Allergex 100.png",
    quantity: 10,
  ),
  Product(
    id: 10,
    title: "Bisolvon",
    price: 234,
    type: "syrups",
    description: dummyText,
    image: "assets/medicines/Bisolvon.png",
    quantity: 10,
  ),
  Product(
    id: 11,
    title: "Meritus Cough Syrup",
    price: 234,
    type: "syrups",
    description: dummyText,
    image: "assets/medicines/Meritus Cough Syrup.png",
    quantity: 10,
  ),
  Product(
    id: 12,
    title: "Chest-Eeze",
    price: 234,
    type: "syrups",
    description: dummyText,
    image: "assets/medicines/Chest-Eeze.png",
    quantity: 10,
  ),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
