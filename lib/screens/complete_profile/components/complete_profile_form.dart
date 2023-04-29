import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import '../../../helpers/keyboard.dart';
import '../../../size_config.dart';
import '../../../vm/register/register_controller.dart';
import '../../root_screen.dart';

class CompleteProfileForm extends StatefulHookConsumerWidget {
  const CompleteProfileForm({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  ConsumerState<CompleteProfileForm> createState() =>
      _CompleteProfileFormState();
}

class _CompleteProfileFormState extends ConsumerState<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool _loading = false;
  File? _image;

  late String email;
  late String password;
  late String displayName;

  @override
  void initState() {
    super.initState();
    email = widget.email;
    password = widget.password;
    displayName = '${firstNameController.text} ${lastNameController.text}';
  }

  @override
  Widget build(BuildContext context) {
    print(email);
    print(password);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                    shape: BoxShape.circle,
                    image: _image != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_image!),
                          )
                        : const DecorationImage(
                            image: AssetImage('assets/images/paw_circle.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      border: Border.all(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        try {
                          _loading = true;
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              _image = File(pickedFile.path);
                            });
                          }
                          _loading = false;
                        } on PlatformException catch (e) {
                          print(e.message);
                        } catch (e) {
                          print(e);
                        }
                      },
                      alignment: Alignment.center,
                      color: Colors.white,
                      icon: const Icon(
                        FeatherIcons.camera,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          buildFirstNameFormField(),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          buildLastNameFormField(),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          buildPhoneNumberFormField(),
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          SizedBox(
            width: double.infinity,
            height: getProportionateScreenHeight(56),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() => _loading = true);
                  KeyboardUtil.hideKeyboard(context);
                  await ref.read(registerControllerProvider.notifier).register(
                        email,
                        password,
                        displayName,
                        phoneNumberController.text,
                        _image!,
                      );
                  setState(() => _loading = false);

                  if (!context.mounted) return;
                  Navigator.pushNamed(context, RootScreen.routeName);
                }
              },
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Complete',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: firstNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            getProportionateScreenWidth(10),
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(10),
          ),
          child: Icon(
            FeatherIcons.user,
            color: kTextColor,
            size: getProportionateScreenWidth(20),
          ),
        ),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: lastNameController,
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            getProportionateScreenWidth(10),
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(10),
          ),
          child: Icon(
            FeatherIcons.user,
            color: kTextColor,
            size: getProportionateScreenWidth(20),
          ),
        ),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneNumberController,
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            getProportionateScreenWidth(10),
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(10),
          ),
          child: Icon(
            FeatherIcons.phone,
            color: kTextColor,
            size: getProportionateScreenWidth(20),
          ),
        ),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      controller: addressController,
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            getProportionateScreenWidth(10),
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(10),
          ),
          child: Icon(
            FeatherIcons.mapPin,
            color: kTextColor,
            size: getProportionateScreenWidth(20),
          ),
        ),
      ),
    );
  }
}
