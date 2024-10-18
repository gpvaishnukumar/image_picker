import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/image_controller.dart';

class ImagePickerScreen extends StatelessWidget {
  // Initialize the controller.
  final ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker with GetX'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (imageController.selectedImage.value != null) {
                Get.defaultDialog(
                  title: "Confirmation",
                  middleText: "Are you sure to delete?",
                  textCancel: "No",
                  textConfirm: "Yes",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    imageController.clearImage();
                    Get.back();
                  },
                  onCancel: () {
                    Get.back();
                  },
                );
              } else {
                Get.snackbar(
                  "No Image",
                  "Please select an image to delete.",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display a loading animation or the selected image.
            Obx(() {
              if (imageController.isLoading.value) {
                return Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading image...'),
                  ],
                );
              } else if (imageController.selectedImage.value != null) {
                return Image.file(
                  imageController.selectedImage.value!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                );
              } else {
                return Text('No image selected');
              }
            }),
            SizedBox(height: 20),
            // Container with a "+" icon that opens a bottom sheet.
            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text('Camera'),
                          onTap: () {
                            imageController.pickImageFromCamera();
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Gallery'),
                          onTap: () {
                            imageController.pickImageFromGallery();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
