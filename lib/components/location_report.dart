import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paw_points/models/location_model.dart';
import 'package:paw_points/riverpod/repository/report_repository.dart';

import '../constants.dart';
import '../helpers/keyboard.dart';
import '../riverpod/services/user_state.dart';
import '../size_config.dart';

class LocationReport extends ConsumerStatefulWidget {
  const LocationReport({super.key});

  @override
  ConsumerState<LocationReport> createState() => _LocationReportState();
}

List<String> reportSubjectOptions = [
  'Animal Abuse',
  'Animal Cruelty',
  'Animal Neglect',
  'Animal Hoarding',
  'Animal Fighting',
  'Animal Abandonment',
  'Other',
];

class _LocationReportState extends ConsumerState<LocationReport> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController reportContentController = TextEditingController();
  TextEditingController reportOtherSubjectController = TextEditingController();
  bool _loading = false;

  // default value of dropdown menu
  String reportSubject = reportSubjectOptions.first;

  ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<String>? selectedImagesList = [];

  Future<void> pickImageFromGallery() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        imageFileList = selectedImages;
      });
      for (XFile image in selectedImages) {
        setState(() {
          selectedImagesList!.add(image.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    ReportArguments args =
        ModalRoute.of(context)!.settings.arguments as ReportArguments;

    final user = ref.watch(userStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text('Report Location', style: headingStyle),
                  const Text(
                    'Send us a report about the location.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            iconSize: 40,
                            onPressed: () {
                              pickImageFromGallery();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.touch_app,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                      const Expanded(
                        child: Text(
                          'You can support your report with photo(s) to better describe.',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  imageFileList.isNotEmpty
                      ? SizedBox(
                          height: getProportionateScreenHeight(100),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageFileList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: getProportionateScreenWidth(10),
                                ),
                                child: Stack(
                                  children: [
                                    Image.file(
                                      File(imageFileList[index].path),
                                      width: getProportionateScreenWidth(100),
                                      height: getProportionateScreenHeight(100),
                                    ),
                                    // center the delete icon on the image
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            imageFileList.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          color: Colors.black.withOpacity(0.3),
                                          child: const Icon(
                                            CupertinoIcons.delete,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox(height: 0),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          icon: const SizedBox.shrink(),
                          decoration: const InputDecoration(
                            labelText: "Subject",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(CupertinoIcons.chevron_down),
                          ),
                          value: reportSubject,
                          items: reportSubjectOptions.map(
                            (String subjectOption) {
                              return DropdownMenuItem(
                                value: subjectOption,
                                child: Text(subjectOption),
                              );
                            },
                          ).toList(),
                          onChanged: (item) {
                            setState(() {
                              reportSubject = item.toString();
                            });
                          },
                        ),
                        reportSubject == 'Other'
                            ? SizedBox(height: getProportionateScreenHeight(15))
                            : const SizedBox(height: 0),
                        reportSubject == 'Other'
                            ? TextFormField(
                                validator: (value) {
                                  if (reportSubject == 'Other' &&
                                      value!.isEmpty) {
                                    return 'Please describe the subject';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                controller: reportOtherSubjectController,
                                decoration: const InputDecoration(
                                  labelText: "Please describe the subject",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: Icon(CupertinoIcons.text_bubble),
                                ),
                              )
                            : const SizedBox(height: 0),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        TextFormField(
                          initialValue:
                              '${args.locationId} (${args.latitude.toString()}, ${args.longitude.toString()})',
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Location",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(CupertinoIcons.location),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        TextFormField(
                          controller: reportContentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: "Content",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(30)),
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
                              if (_loading) return;
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                KeyboardUtil.hideKeyboard(context);
                                setState(() {
                                  _loading = true;
                                });

                                LocationModel location = LocationModel(
                                  id: 'id-1',
                                  latitude: args.latitude,
                                  longitude: args.longitude,
                                  name: args.locationId,
                                );

                                await ref
                                    .read(reportRepositoryProvider)
                                    .addReport(
                                      user!.uid!,
                                      selectedImagesList ?? [],
                                      reportSubject == 'Other'
                                          ? reportOtherSubjectController.text
                                          : reportSubject,
                                      reportContentController.text,
                                      location,
                                      context,
                                    )
                                    .whenComplete(
                                  () {
                                    setState(() {
                                      _loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Report sent successfully! Thank you for your support.',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
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
                                    'Send Report',
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(18),
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportArguments {
  final double latitude;
  final double longitude;
  final String locationId;

  ReportArguments(
    this.locationId, {
    required this.latitude,
    required this.longitude,
  });
}
