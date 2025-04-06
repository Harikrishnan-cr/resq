import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;
  var isLoading = false.obs;

  // Sign In Function
  Future<void> signIn(String email, String password) async {
       
    
    try {
      isLoading.value = true;

      log('vopid eon preoject $email and $password');
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      isLoading.value = false;

      if (response.user != null) {
        Get.offAllNamed('/bottomnav');
      } else {
        Get.snackbar('Sign In Failed', 'Invalid email or password');
      }
    } catch (e) {
      isLoading.value = false;

      print('evgjjgj $e');
      
      // Get.snackbar('Something went wrong', 'Please login again');
      Get.dialog(
         AlertDialog(
    title: const Text("Alert",style: TextStyle(
      fontWeight: FontWeight.bold
    ),),
    content:  const Text("Kindly check your inbox and verify your email address to proceed",style: TextStyle(
      fontWeight: FontWeight.w600
    ),),
    actions: [
      TextButton(
        onPressed: () => Get.back(), // closes the dialog
        child: const Text("OK"),
      ),
    ],
  ),
      );
      // Get.snackbar('Error', e.toString());
    }
  }

  // Sign Up Function
  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      isLoading.value = false;

      if (response.user != null) {
        Get.offAllNamed('/signin');
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar('Error', e.toString());
      Get.snackbar('Something went wrong', 'Please register again');
    }
  }

  // Sign Out Function
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
