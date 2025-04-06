import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDetailsController extends GetxController {
  final supabase = Supabase.instance.client;

  var name = ''.obs;
  var location = ''.obs;
  var note = ''.obs;
  var status = 'Safe'.obs; // Default status is "Safe"

  // Function to change status when button is clicked
  void changeStatus() {
    if (status.value == 'Safe') {
      status.value = 'Mild';
    } else if (status.value == 'Mild') {
      status.value = 'Severe';
    } else {
      status.value = 'Safe';
    }
    print('Status changed to: ${status.value}');
  }

  // Function to save user details in Supabase
  Future<void> saveUserDetails({String? latlong}) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    try {
      final response = await supabase.from('user_data_table').upsert([
        {
          'user_id': user.id,
          'name': name.value,
          'location': location.value,
          'note': note.value,
          'status': status.value,
          'created_at': DateTime.now().toIso8601String(),
          'latlong':latlong??'',
        }
      ]);

      print('User details datas is : $response'); // ✅ Print response to check its format

      // ✅ Just assume success if no exception is thrown
      Get.snackbar('Success', 'Details saved successfully');
      Get.offAllNamed('/bottomnav'); // Navigate to home after saving
    } catch (e) {
      print('Exception occurred: $e'); // ✅ Print actual error message
      Get.snackbar('Error', 'Failed to save data: $e');
    }
  }
  // Function to fetch user details from Supabase
Future<void> fetchUserDetails() async {
  final user = supabase.auth.currentUser;
  if (user == null) {
    Get.snackbar('Error', 'User not logged in');
    return;
  }

  try {
    final response = await supabase
        .from('user_data_table')
        .select()
        .eq('user_id', user.id)
        .single(); // Assuming one record per user

    // Update the controller variables with the fetched data
    name.value = response['name'] ?? '';
    location.value = response['location'] ?? '';
    note.value = response['note'] ?? '';
    status.value = response['status'] ?? 'Safe';

    print('Fetched user details: $response');
  } catch (e) {
    print('Exception occurred while fetching: $e');
    Get.snackbar('Error', 'Failed to fetch user details');
  }
}

}
