import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageController extends GetxController {
  var selectedImage = Rx<File?>(null);
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();


  // Method to clear the selected image.
  void clearImage() {
    selectedImage.value = null;
  }

  // Method to request permission and pick an image from the gallery.
  Future<void> pickImageFromGallery() async {
    // Request the permission before accessing the gallery.
    var galleryStatus = await Permission.photos.request();

    if (galleryStatus.isGranted) {
      try {
        isLoading.value = true;
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          selectedImage.value = File(image.path);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to pick image: $e');
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please grant gallery permission to select an image.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Method to request permission and pick an image from the camera.
  Future<void> pickImageFromCamera() async {
    // Request the permission before accessing the camera.
    var cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      try {
        isLoading.value = true;
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          selectedImage.value = File(image.path);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to pick image: $e');
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please grant camera permission to take a picture.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
