import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportal/providers/auth_provider.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/widgets/kdropdown_button_form_field.dart';
import 'package:sportal/widgets/rectangle_button.dart';

class FiltersWidget extends StatefulWidget {
  const FiltersWidget({super.key, required this.onFilter});
  final Function(Map<String, dynamic> filtrs) onFilter;

  @override
  State<FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  List<String> selectedDepartments = [
    'All',
  ];
  List<String> selectedGenders = [];
  List<String> gender = ['male', 'female'];
  List<String> sortBy = [
    'Relevance',
    'CNIC',
    'Phone number',
    'Name',
    'Department',
    'Checkin',
  ];
  String sortCriteria = 'Relevance';
  List<String> departments() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    return [
      'All',
      ...user!.departments!.map((e) => e['name']).toList(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kToolbarHeight - 10,
            ),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Departments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ...List.generate(
              departments().length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedDepartments.contains(departments()[index])) {
                      selectedDepartments.remove(departments()[index]);
                    } else {
                      selectedDepartments.add(departments()[index]);
                    }
                  });
                },
                child: tile(departments()[index],
                    selectedDepartments.contains(departments()[index])),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Gender',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ...List.generate(
              gender.length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedGenders.contains(gender[index])) {
                      selectedGenders.remove(gender[index]);
                    } else {
                      selectedGenders.add(gender[index]);
                    }
                  });
                },
                child: tile(gender[index] == 'male' ? 'Male' : 'Female',
                    selectedGenders.contains(gender[index])),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Sort by',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            KDropdownButtonFormField(
              items: sortBy
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  sortCriteria = val.toString();
                });
              },
              value: sortCriteria,
            ),
            const SizedBox(
              height: 15,
            ),
            RectangleButton(
              text: 'APPLY',
              onPressed: () {
                final filter = {
                  'departments': selectedDepartments,
                  'gender': selectedGenders,
                  'sort': sortCriteria
                };
                widget.onFilter(filter);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget tile(String title, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(selected ? Icons.check_box : Icons.check_box_outline_blank,
              color: selected ? primaryColor : Colors.grey),
          const SizedBox(
            width: 15,
          ),
          Text(title)
        ],
      ),
    );
  }
}
