// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profileapp/main.dart';
import 'package:profileapp/screens/login_screen.dart';
import 'package:profileapp/utils/preference.dart';
import 'package:http/http.dart' as http;

import '../common/form_button.dart';
import '../common/input_field.dart';
import '../utils/constants.dart';

const placeholderImage =
    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool enableUpdate = false;
  Uint8List? _image = prefs.image != '' ? getImage() : null;
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      Uint8List imageBytes = imageTemporary.readAsBytesSync();
      setState(() {
        _image = imageBytes;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = prefs.name;
    emailController.text = prefs.email;
    phonenoController.text = prefs.phoneno;
    pincodeController.text = prefs.pincode;
    districtController.text = prefs.district;
    stateController.text = stateController.text;
    countryController.text = countryController.text;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          centerTitle: true,
          title: const Text(
            'Your Profile',
            style: TextStyle(color: appcolor, fontSize: 25),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout,
                    size: 25,
                    color: appcolor,
                  )),
            )
          ],
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20)),
            height: MediaQuery.sizeOf(context).height - 100,
            width: size.width * 0.9,
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundImage:
                            _image != null ? MemoryImage(_image!) : null,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: _pickProfileImage,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade400,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFormField(
                        controller: nameController,
                        labelText: 'Name',
                        hintText: 'Your name',
                        isDense: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Name field is required!';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFormField(
                        controller: emailController,
                        labelText: 'Email',
                        hintText: 'Your email id',
                        isDense: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Email is required!';
                          }
                          if (!EmailValidator.validate(textValue)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFormField(
                        controller: phonenoController,
                        labelText: 'Contact no.',
                        hintText: 'Your contact number',
                        isDense: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Contact number is required!';
                          }
                          if (textValue.length != 10) {
                            return 'Contant number should be 10 digits';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFormField(
                        controller: pincodeController,
                        labelText: 'Pincode',
                        hintText: 'Your pincode',
                        isDense: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Pincode is required!';
                          }
                          if (textValue.length != 6) {
                            return 'Pincode should have 6 digits';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormButton(
                      innerText: 'Fetch Address',
                      onPressed: _fetchAddress,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFormField(
                        controller: districtController,
                        labelText: 'District',
                        hintText: 'Your district',
                        isDense: false,
                        readonly: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'District is required!';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFormField(
                        controller: stateController,
                        labelText: 'State',
                        hintText: 'Your state',
                        isDense: false,
                        readonly: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'State is required!';
                          }

                          return null;
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomInputFormField(
                        controller: countryController,
                        labelText: 'Country',
                        hintText: 'Your country',
                        isDense: true,
                        readonly: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Country is required!';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormButton(
                      innerText: 'Update',
                      onPressed: _handleupdate,
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleupdate() async {
    if (_formkey.currentState!.validate()) {
      final prefs = UserPreferences();

      prefs.name = nameController.text;
      prefs.email = emailController.text.trim();

      prefs.phoneno = phonenoController.text;
      if (_image != null) {
        await saveImage(_image!);
      }
      prefs.pincode = pincodeController.text;
      prefs.state = stateController.text;
      prefs.district = districtController.text;
      prefs.country = countryController.text;
      print('''
Updated User Info: 
Name: ${prefs.name},
Email: ${prefs.email},
Username: ${prefs.username},
Phoneno: ${prefs.phoneno},
Address: ${prefs.district} ${prefs.state} ${prefs.country} ${prefs.pincode}
Image: ${prefs.image},
''');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 94, 175, 241),
          content: Text('Updating data..'),
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 76, 162, 99),
          content: Text('Data Updated..'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _logout() async {
    setState(() {
      clearprefs();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color.fromARGB(255, 94, 175, 241),
        content: Text('Clearing all data and Logging out..'),
        duration: Duration(seconds: 1),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false);
  }

  Future<void> _fetchAddress() async {
    final response = await http.get(Uri.parse(
        'https://api.postalpincode.in/pincode/${pincodeController.text.trim()}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data[0]['Status'] == 'Success') {
        final address = data[0]['PostOffice'][0];
        setState(() {
          stateController.text = address['State'];
          districtController.text = address['District'];
          countryController.text = address['Country'];

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 76, 162, 99),
              content: Text('Address Fetched..'),
              duration: Duration(seconds: 1),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 242, 111, 101),
            content: Text('No data found for this pincode'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 242, 111, 101),
          content: Text('Error in fetching address'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
