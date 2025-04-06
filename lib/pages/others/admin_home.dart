import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:resq/services/controllers/adminauth_controller.dart';
import 'package:resq/services/controllers/adminhome_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminHomePage extends StatefulWidget {

  AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller. fetchAllUsers();
  }
  final AdminHomeController controller = Get.put(AdminHomeController());

  final AdminAuthController authcontroller = Get.put(AdminAuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C3B2E),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          authcontroller.signOut();
        },
        child: Icon(Icons.logout_outlined),
      ),
      appBar: AppBar(title: Text("Admin Dashboard"),
      actions: [
        Obx(() {
           return  IconButton(onPressed: () {
          controller.fetchAllUsers();
        }, icon:
         LottieBuilder.asset('assets/Animation - 1743885710865.json',repeat: controller.isLoading.value,)
        );
        },)
     
      ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.allUsers.isEmpty) {
          return Center(child: Text("No user data found."));
        }

        return ListView.builder(
          itemCount: controller.allUsers.length,
          itemBuilder: (context, index) {
            final user = controller.allUsers[index];
            return Card(
              child: ListTile(
                
                title: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(user['name'] ?? "No Name"),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        log('latlong is ${user['latlong']}');
                        openGoogleMaps(user['latlong']);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.location_on,),
                          Text("Location: ${user['location'] ?? 'Unknown'}"),
                        ],
                      ),
                    ),
                    Padding(
                         padding: const EdgeInsets.only(left: 5.0),
                      child: Text("Note: ${user['note'] ?? 'No Note'}"),
                    ),
                  ],
                ),
                trailing: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(user['status']),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user['status'] ?? 'Unknown',
                    style: TextStyle(color: Colors.white),
                    
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Safe':
        return Colors.green;
      case 'Mild':
        return Colors.orange;
      case 'Severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

Future<void> openGoogleMaps(String latLong) async {
    final parts = latLong.split(',');

    if (parts.length == 2) {
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());
  final Uri googleMapUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
  
  if (await canLaunchUrl(googleMapUrl)) {
    await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open the map.';
  }
}

}
}