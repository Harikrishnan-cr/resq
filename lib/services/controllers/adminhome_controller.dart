import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHomeController extends GetxController {
    final supabase = Supabase.instance.client;

  var allUsers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers(); // Auto-fetch on controller init
  }

  // Fetch all user details from Supabase
  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('user_data_table')
          .select()
          .order('created_at', ascending: false);

      allUsers.value = List<Map<String, dynamic>>.from(response);
     isLoading.value = false;
      print('Fetched all users: $allUsers');
    } catch (e) {
      isLoading.value = false;
      print('Error fetching users: $e');
      Get.snackbar('Error', 'Failed to fetch user data');
    } finally {
      isLoading.value = false;
    }
  }
}
