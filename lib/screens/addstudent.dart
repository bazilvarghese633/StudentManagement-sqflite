// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:student_try3/screens/studentList.dart';

import '../functions/functions.dart';
import 'model.dart';

class AddStudent extends StatefulWidget {
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final rollnoController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final phonenoController = TextEditingController();
  final agecontroller = TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Information",
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentInfo()),
              );
            },
            icon: Icon(
              Icons.person_search,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/studentadd.png'),
                maxRadius: 60,
                child: GestureDetector(
                    onTap: () async {
                      File? pickimage = await _pickImageFromCamera();
                      setState(() {
                        _selectedImage = pickimage;
                      });
                    },
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                          )
                        : null),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Student Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: rollnoController,
                decoration: const InputDecoration(
                  labelText: "Roll number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Roll no is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: agecontroller,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.verified),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Age is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: departmentController,
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Department is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phonenoController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number is required';
                  }
                  final phoneRegExp = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegExp.hasMatch(value)) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "You must select an image",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                          return;
                        }
                        final student = StudentModel(
                          rollno: rollnoController.text,
                          name: nameController.text,
                          department: departmentController.text,
                          phoneno: phonenoController.text,
                          age: agecontroller.text,
                          imageurl: _selectedImage != null
                              ? _selectedImage!.path
                              : null,
                        );
                        await addStudent(student);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Data Added Successfully",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );

                        rollnoController.clear();
                        nameController.clear();
                        departmentController.clear();
                        phonenoController.clear();
                        agecontroller.clear();
                        setState(() {
                          _selectedImage = null;
                        });

                        // Navigate to StudentList and ensure data is refreshed
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentInfo(), // Replace with your StudentList page
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Text("Save"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        rollnoController.clear();
                        nameController.clear();
                        departmentController.clear();
                        phonenoController.clear();
                        agecontroller.clear();
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      child: Text('clear'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImageFromCamera() async {
    if (Platform.isIOS) {
      // iOS
      return await ImagePicker().pickImage(source: ImageSource.gallery).then(
          (pickedImage) => pickedImage != null ? File(pickedImage.path) : null);
    } else if (Platform.isAndroid) {
      // Android
      return await ImagePicker().pickImage(source: ImageSource.gallery).then(
          (pickedImage) => pickedImage != null ? File(pickedImage.path) : null);
    }
    return null;
  }
}
