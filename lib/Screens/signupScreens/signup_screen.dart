import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern_assignment/Screens/login_screen.dart';
import 'package:intern_assignment/resources/auth_methods.dart';
import 'package:intern_assignment/utils/colors.dart';
import 'package:intern_assignment/utils/utils.dart';
import 'package:intern_assignment/widgets/text_field_input.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';

const List<String> list = <String>['Faculty', 'Student', 'Alumini'];

enum UserType { Student, Alumini, Faculty }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  Uint8List? _image;

  bool _isLoading = false;

  String dropdownValue = list.first;

  UserType _userType = UserType.Student;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _yearController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    var res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      userType: dropdownValue,
      number: _mobileController.text,
      year: _yearController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      await showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToToLoginIn() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    String userType = "deafult";
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            height: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 0,
                ),
                const Text(
                  'Registration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/34AD2.jpg'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    textEditingController: _nameController,
                    hintText: 'Name',
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: inputBorder,
                    filled: true,
                    hintText: "User Type",
                  ),
                  hint: const Text('User Type'),
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                      userType = value;
                      if (userType == 'Student') {
                        _userType = UserType.Student;
                      } else if (userType == 'Alumini') {
                        _userType = UserType.Alumini;
                      } else {
                        _userType = UserType.Faculty;
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                if (_userType == UserType.Student)
                  TextFieldInput(
                      hintText: 'Admission Year',
                      textInputType: TextInputType.text,
                      textEditingController: _yearController),
                if (_userType == UserType.Alumini)
                  TextFieldInput(
                      hintText: 'Passout Year',
                      textInputType: TextInputType.text,
                      textEditingController: _yearController),
                if (_userType == UserType.Faculty)
                  TextFieldInput(
                      hintText: 'joining Year',
                      textInputType: TextInputType.text,
                      textEditingController: _yearController),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    textEditingController: _mobileController,
                    hintText: 'Mobile Number',
                    textInputType: TextInputType.number),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Enter your password',
                    isPass: true,
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('Next'),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Already have an account? "),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: navigateToToLoginIn,
                      child: Container(
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: blueColor),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
