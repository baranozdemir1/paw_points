import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paw_points/helpers/paw_points_helper.dart';
import 'package:paw_points/riverpod/services/user_state.dart';
import 'package:paw_points/screens/root_screen.dart';

import '../../../constants.dart';
import '../../../helpers/keyboard.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends ConsumerStatefulWidget {
  const CompleteProfileForm({super.key});

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

  late String displayName;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStateProvider);

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
                          if (e.code == 'invalid_image') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Invalid image. Please change your image.'),
                              ),
                            );
                          }
                        } catch (e) {
                          throw e.toString();
                        }
                      },
                      alignment: Alignment.center,
                      color: Colors.white,
                      icon: Icon(
                        CupertinoIcons.camera,
                        size: getProportionateScreenWidth(20),
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
              heroTag: 'completeProfileButton',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    displayName =
                        '${firstNameController.text} ${lastNameController.text}';
                    _loading = true;
                  });
                  KeyboardUtil.hideKeyboard(context);
                  await PawPointsHelper.getPawCirclePathFile()
                      .then((localImage) async {
                    await ref
                        .read(userStateProvider.notifier)
                        .completeProfile(
                          user!.uid!,
                          displayName,
                          phoneNumberController.text,
                          _image ?? localImage,
                          context,
                        )
                        .whenComplete(
                      () {
                        setState(() {
                          _loading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RootScreen(),
                          ),
                        );
                      },
                    );
                  });

                  // ref
                  //     .read(authControllerProvider.notifier)
                  //     .updateUserProfile(
                  //       context,
                  //       user.uid!,
                  //       displayName,
                  //       phoneNumberController.text,
                  //       _image!,
                  //     );
                  // setState(() => _loading = false);
                  // Navigator.of(context).pushNamed('/');
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
            CupertinoIcons.person,
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
            CupertinoIcons.person,
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
            CupertinoIcons.phone,
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
            CupertinoIcons.location,
            color: kTextColor,
            size: getProportionateScreenWidth(20),
          ),
        ),
      ),
    );
  }
}
