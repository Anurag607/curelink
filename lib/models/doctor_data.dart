import 'package:curelink/models/doctor.dart';

List<Doctor> doctors = [
  Doctor(
    id: 1,
    image: "assets/avaters/doctor_1.jpg",
    name: "Dr. Brijesh Patel",
    rating: 4.5,
    desc: "Cardiologist",
    reviews: List.generate(451, (index) => ""),
  ),
  Doctor(
    id: 2,
    image: "assets/avaters/doctor_2.jpg",
    name: "Dr. Anthony Leeway",
    rating: 4.0,
    desc: "Dental Specialist",
    reviews: List.generate(122, (index) => ""),
  ),
  Doctor(
    id: 3,
    image: "assets/avaters/doctor_3.jpg",
    name: "Dr. Adison Ashley",
    rating: 4.2,
    desc: "Dental Specialist",
    reviews: List.generate(258, (index) => ""),
  ),
];
