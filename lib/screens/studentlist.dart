// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_try3/screens/addstudent.dart';
import 'package:student_try3/screens/details.dart';
import '../functions/functions.dart';
import 'model.dart';

class StudentInfo extends StatefulWidget {
  const StudentInfo({super.key});

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  late List<Map<String, dynamic>> _studentsData = [];
  TextEditingController searchController = TextEditingController();
  bool _isGridView = false;

  @override
  void initState() {
    _fetchStudentsData();
    super.initState();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await getAllStudents();
    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student['name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _studentsData = students;
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // Set the background color to white

        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "STUDENT LIST",
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      _fetchStudentsData();
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    labelText: "Search",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: _isGridView ? _buildGridView() : _buildListView(),

        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddStudent(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10), // Add spacing between buttons
            FloatingActionButton(
              onPressed: _toggleView,
              child: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return _studentsData.isEmpty
        ? const Center(child: Text("No students available."))
        : ListView.separated(
            itemBuilder: (context, index) {
              final student = _studentsData[index];
              final id = student['id'];
              final imageUrl = student['imageurl'];
              return ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return Details(student: student);
                  }));
                },
                leading: GestureDetector(
                  onTap: () {
                    if (imageUrl != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.file(File(imageUrl)),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        imageUrl != null ? FileImage(File(imageUrl)) : null,
                    child: imageUrl == null ? const Icon(Icons.person) : null,
                  ),
                ),
                title: Text(student['name']),
                subtitle: Text(student['department']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _showEditDialog(index);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext) => AlertDialog(
                            title: const Text("Delete Student"),
                            content:
                                const Text("Are you sure you want to delete?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await deleteStudent(id);
                                  _fetchStudentsData();
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Deleted Successfully")));
                                },
                                child: const Text("Ok"),
                              )
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: _studentsData.length,
          );
  }

  Widget _buildGridView() {
    return _studentsData.isEmpty
        ? const Center(child: Text("No students available."))
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio:
                  0.75, // Adjust the aspect ratio to control card height
            ),
            itemCount: _studentsData.length,
            itemBuilder: (context, index) {
              final student = _studentsData[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(student: student),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9, // Maintain a fixed aspect ratio
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8.0)),
                          child: Image.file(
                            File(student['imageurl']),
                            fit: BoxFit
                                .cover, // Ensure the image covers the entire area
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ); // Handle cases where the image fails to load
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Prevent overflow by ellipsis
                              maxLines: 1,
                            ),
                            Text(
                              student['department'],
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _showEditDialog(index);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext) => AlertDialog(
                                        title: const Text("Delete Student"),
                                        content: const Text(
                                            "Are you sure you want to delete?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await deleteStudent(
                                                  student['id']);
                                              _fetchStudentsData();
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Deleted Successfully"),
                                                ),
                                              );
                                            },
                                            child: const Text("Ok"),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Future<void> _showEditDialog(int index) async {
    final student = _studentsData[index];
    final TextEditingController nameController =
        TextEditingController(text: student['name']);
    final TextEditingController rollnoController =
        TextEditingController(text: student['rollno'].toString());
    final TextEditingController departmentController =
        TextEditingController(text: student['department']);
    final TextEditingController phonenoController =
        TextEditingController(text: student['phoneno'].toString());
    final TextEditingController ageController =
        TextEditingController(text: student['age'].toString());

    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: const Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: rollnoController,
                decoration: const InputDecoration(labelText: "Roll No"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: const InputDecoration(labelText: "Phone No"),
              ),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(labelText: " Age"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                StudentModel(
                  id: student['id'],
                  rollno: rollnoController.text,
                  name: nameController.text,
                  department: departmentController.text,
                  phoneno: phonenoController.text,
                  age: ageController.text,
                  imageurl: student['imageurl'],
                ),
              );
              Navigator.of(context).pop();
              _fetchStudentsData();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Changes Updated")));
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
