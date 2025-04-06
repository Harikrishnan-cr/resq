
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthChecker extends StatelessWidget {
  final supabase = Supabase.instance.client;

  AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    // log("🔍 AuthChecker: Building Widget...");

    return FutureBuilder(
      future: checkUsers(),
      builder: (context, snapshot) {
        print("📡 FutureBuilder State: ${snapshot.connectionState}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("⏳ Checking Auth Status...");
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          print("✅ Auth Status Received: ${snapshot.data}");

          // Navigate based on auth status
          Future.microtask(
            () {
              switch (snapshot.data) {
                case 1:
                  Get.offAllNamed('/adminHome');
                  return;
                  case 2:
                  Get.offAllNamed('/bottomnav');
                  return;
                  case 3:
                   Get.offAllNamed('/signin');

                default:
                  Get.offAllNamed('/signin');
              }
             
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<bool> _checkAuthStatus() async {
    final session = supabase.auth.currentSession;
    print('_checkAuthStatus $session');
    return session != null; // Return true if logged in
  }
  Future<bool>_adminCheck()async{
     final session = supabase.auth.currentSession;
     final adminCheck = await supabase
          .from('admins')
          .select('id, email')
          .eq('email', session?.user.userMetadata?['email'])
          .maybeSingle();
    print('_adminCheck $adminCheck');
          
          return adminCheck !=null;
  }

  Future<int>checkUsers()async{
    if (await _adminCheck()) {
      return 1;
    }
    if (await _checkAuthStatus()) {
      return 2;
    }
    return 3;
  }
}
