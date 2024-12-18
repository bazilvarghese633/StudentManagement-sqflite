class StudentModel {
  int? id;
  final dynamic rollno;
  final String name;
  final String department;
  final dynamic phoneno;
  final dynamic age;
  final String? imageurl;

  StudentModel(
      {this.id,
      required this.rollno,
      required this.name,
      required this.department,
      required this.phoneno,
      this.imageurl,
      required this.age});
}
