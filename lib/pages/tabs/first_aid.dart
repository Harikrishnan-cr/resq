import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resq/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirstAidController extends GetxController {
  final supabase = Supabase.instance.client;
  var items = <Map<String, dynamic>>[].obs;
  var selectedItems = <String>{}.obs;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<void> fetchItems() async {
    try {
      final response = await supabase.from('first_aid_items').select();
      print("📢 Raw Response from Supabase: $response");

      if (response != null && response.isNotEmpty) {
        items.assignAll(List<Map<String, dynamic>>.from(response));
        print("✅ Items fetched: ${items.length} items loaded.");
      } else {
        print("⚠️ No items found in the database.");
      }
    } catch (e) {
      print("❌ Error fetching items: $e");
    }
  }

  void toggleSelection(String itemId) {
    if (selectedItems.contains(itemId)) {
      selectedItems.remove(itemId);
      print("Item deselected: $itemId");
    } else {
      selectedItems.add(itemId);
      print("Item selected: $itemId");
    }
  }

  Future<void> saveSelection() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print("Error: No logged-in user.");
      return;
    }

    print("Saving selected items for user: ${user.id}");
    print("Selected items: ${selectedItems.toList()}");

    try {
      await supabase.from('user_selected_items').upsert(
            selectedItems
                .map((id) => {'user_id': user.id, 'item_id': id})
                .toList(),
          );

      print("✅ Selection saved successfully.");
      Get.snackbar('Success', 'Your selections have been saved!');
    } catch (e) {
      print("❌ Error saving selections: $e");
      Get.snackbar('Error', 'Failed to save selections.');
    }
  }
}



class FirstAidListClass {
  
  final int id;
  final String img;
  final String name;

FirstAidListClass({required this.id,required this.img,required this.name});


}

List<FirstAidListClass> firstAidList = [

  FirstAidListClass(id: 1, img: 'assets/water.jpg', name: 'Water'),
  FirstAidListClass(id: 2, img: 'assets/rope.jpg', name: 'Rope'),
  FirstAidListClass(id: 3, img: 'assets/food.jpg', name: 'Food'),
  FirstAidListClass(id: 4, img: 'assets/ambulace.jpg', name: 'Ambulance'),
  FirstAidListClass(id: 5, img: 'assets/firstaid.jpg', name: 'first aid box'),
  FirstAidListClass(id: 6, img: 'assets/knife.jpg', name: 'Knife'),
];

class FirstAidPage extends StatefulWidget {
  const FirstAidPage({super.key});

  @override
  State<FirstAidPage> createState() => _FirstAidPageState();
}

class _FirstAidPageState extends State<FirstAidPage> {



  int isSlectedId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Select First Aid Items",
            style: AppTextStyles.headlineLargeBlack,
          ),
        ),
      ),
      body:  GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
          ),
          itemCount:firstAidList.length,
          itemBuilder: (context, index) {
            final item = firstAidList[index];
           

            return GestureDetector(
              onTap: () {
               setState(() {

                if(isSlectedId == item.id){
                  isSlectedId = 0;
                  return;
                }
                 isSlectedId = item.id;


               });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: item.id == isSlectedId ? Colors.green : Colors.grey),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        item.img,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                         
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        item.name,
                        style: AppTextStyles.bodyLargeBlack,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
      
        
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
