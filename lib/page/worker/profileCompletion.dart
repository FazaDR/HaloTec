import 'package:flutter/material.dart';
import 'package:halotec/page/worker/navbar_worker.dart';
import 'package:halotec/util/config.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:halotec/db/db_define_keahlian.dart';
import 'package:halotec/page/Auth.dart';
import 'package:halotec/util/SharedPreferences.dart';


class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  ImageProvider<Object>? _profileImage;
  List<Map<String, dynamic>> availableSkills = []; // Full skill details
  List<int> selectedSkills = [];
  TextEditingController descriptionController = TextEditingController();
  List<Image> portfolioImages = [];
  String? selectedPaymentPlan;
  String? workerName; // Added variable for worker's name

void showImageDialog(int index) {
  final image = portfolioImages[index];
  final captionController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Edit Portfolio Image"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: Image(
                  image: image.image,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  labelText: "Add Caption",
                  border: OutlineInputBorder(),
                ),
                maxLength: 255, // Limiting the caption to 255 characters
                maxLines: null, // Allow the text field to be multi-line
              ),
            ],
          ),
        ),
        actions: [
          // Buttons in a Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
            children: [
              // Delete Button
              TextButton(
                onPressed: () async {
                  await deletePortfolioImage(index);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Delete"),
              ),
              // Cancel Button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              // Save Caption Button
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String? idWorker = prefs.getString('id_worker');
                  if (idWorker == null) {
                    print("Worker ID not found in SharedPreferences");
                    return;
                  }

                  // Original imageUrl string
                  String imageUrl = portfolioImages[index].image.toString();

                  // Extract the file name (e.g., "1000020034.jpg") using RegExp
                  final RegExp fileNameRegExp = RegExp(r'[^/]+\.(jpg|jpeg|png|webp|bmp|gif|tiff)', caseSensitive: false);
                  final Match? match = fileNameRegExp.firstMatch(imageUrl);
                  final String fileName = match?.group(0) ?? '';

                  if (fileName.isEmpty) {
                    print("File name could not be extracted from imageUrl");
                    return;
                  }

                  // Construct the relativeImageUrl using the extracted file name
                  String relativeImageUrl = '/halotec/uploads/portofolio_pics/$fileName';

                  print("Sending request to update caption with URL: $relativeImageUrl");

                  final response = await http.post(
                    Uri.parse('$apiBaseUrl/halotec/portofolio/update_caption.php'),
                    body: json.encode({
                      'id_worker': idWorker,
                      'image_url': relativeImageUrl,
                      'caption': captionController.text,
                    }),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 200) {
                    final respStr = json.decode(response.body);
                    if (respStr['status'] == 'success') {
                      print('Caption updated successfully');
                    } else {
                      print("Failed to update caption: ${respStr['message']}");
                    }
                  } else {
                    print("Server error: ${response.statusCode}");
                  }

                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      );
    },
  );
}


  // Fetch the skills and worker name directly in initState
  @override
  void initState() {
    super.initState();
    _loadData(); // Load skills and worker name
  }

Widget buildPortfolioGrid() {
  return portfolioImages.isEmpty
      ? const SizedBox()
      : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: portfolioImages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => showImageDialog(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the frame
                  border: Border.all(color: Colors.grey, width: 1), // Border around the frame
                  borderRadius: BorderRadius.circular(8), // Rounded corners for the frame
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4), // Padding inside the frame
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image(
                    image: portfolioImages[index].image,
                    fit: BoxFit.cover, // Ensures the image is cropped to fit
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            );
          },
        );
}



Future<void> _loadData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? kategoriId = prefs.getString('kategori'); // Retrieve kategori
    workerName = prefs.getString('nama'); // Retrieve worker name
    String? idWorker = prefs.getString('id_worker'); // Retrieve id_worker
    String? profilePicPath = prefs.getString('profile_pic'); // Retrieve profile picture path

    print("Kategori ID: $kategoriId"); // Debugging
    print("Worker Name: $workerName"); // Debugging
    print("Profile Pic Path: $profilePicPath"); // Debugging

    if (idWorker != null) {
      int? workerId = int.tryParse(idWorker);
      if (workerId != null) {
        print("Worker ID: $workerId");
      } else {
        print("Invalid Worker ID: $idWorker");
        return;
      }
    } else {
      print("Worker ID not found in SharedPreferences");
    }

    if (kategoriId != null) {
      List<Map<String, dynamic>> skillsData = await fetchKeahlian(kategoriId);

      setState(() {
        availableSkills = skillsData;  // No need to map to strings
      });
    } else {
      print('Kategori not found in SharedPreferences');
    }

    if (profilePicPath != null) {
      // Construct the full URL using the base URL
      String imageUrl = '$apiBaseUrl$profilePicPath';

      print("Image URL: $imageUrl"); // Debugging to verify the URL

      setState(() {
        _profileImage = NetworkImage(imageUrl); // Use the constructed URL
      });
    } else {
      print("Profile picture path not found in SharedPreferences");
    }
  } catch (e) {
    print('Error fetching data: $e');
  }

}


Future<void> deletePortfolioImage(int index) async {
  final prefs = await SharedPreferences.getInstance();
  String? idWorker = prefs.getString('id_worker');

  if (idWorker == null) {
    print("Worker ID not found in SharedPreferences");
    return;
  }

  // Original imageUrl string
  String imageUrl = portfolioImages[index].image.toString();

  // Extract the file name (e.g., "1000020034.jpg") using RegExp
  final RegExp fileNameRegExp = RegExp(r'[^/]+\.(jpg|jpeg|png|webp|bmp|gif|tiff)', caseSensitive: false);
  final Match? match = fileNameRegExp.firstMatch(imageUrl);
  final String fileName = match?.group(0) ?? '';

  if (fileName.isEmpty) {
    print("File name could not be extracted from imageUrl");
    return;
  }

  // Construct the relativeImageUrl using the extracted file name
  String relativeImageUrl = '/halotec/uploads/portofolio_pics/$fileName';

  print("Sending request to delete image with URL: $relativeImageUrl");

  // Now send the correct relative URL to the PHP script
  final uri = Uri.parse('$apiBaseUrl/halotec/portofolio/delete.php');
  final response = await http.post(
    uri,
    body: json.encode({'id_worker': idWorker, 'image_url': relativeImageUrl}),
    headers: {'Content-Type': 'application/json'},
  );

  // Debugging the response body
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    try {
      final respStr = json.decode(response.body);
      if (respStr['status'] == 'success') {
        setState(() {
          portfolioImages.removeAt(index);
        });
        print("Image deleted successfully.");
      } else {
        print("Failed to delete image: ${respStr['message']}");
      }
    } catch (e) {
      print("Error decoding JSON: $e");
      print("Response body: ${response.body}");
    }
  } else {
    print("Server error: ${response.statusCode} - ${response.body}");
  }
}





Future<void> uploadPortfolioImage(File image) async {
  final prefs = await SharedPreferences.getInstance();
  String? idWorker = prefs.getString('id_worker'); // Fetch `id_worker` directly as string.

  if (idWorker == null) {
    print("Worker ID not found in SharedPreferences");
    return;
  }

  final uri = Uri.parse('$apiBaseUrl/halotec/portofolio/create.php');
  final request = http.MultipartRequest('POST', uri);

  // Add the image file
  request.files.add(await http.MultipartFile.fromPath('portfolio_image', image.path));

  // Include `id_worker` in the request body
  request.fields['id_worker'] = idWorker;

  final response = await request.send();

  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    print('Response: $respStr');

    try {
      final jsonResp = json.decode(respStr);
      if (jsonResp['status'] == 'success') {
        print('Image uploaded successfully!');
      } else {
        print('Failed to upload image: ${jsonResp['message']}');
      }
    } catch (e) {
      print('Error parsing response: $e');
    }
  } else {
    print('Server error: ${response.statusCode}');
  }
}


  Future<void> selectPortfolioImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        portfolioImages.add(Image.file(File(image.path)));
      });

      // Optional: Upload image to server immediately
      await uploadPortfolioImage(File(image.path));
    }
  }

Future<void> submitData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? idWorkerString = prefs.getString('id_worker');

    // Ensure idWorker is parsed as an integer
    int? idWorker = int.tryParse(idWorkerString ?? '');
    if (idWorker == null) {
      print('Invalid Worker ID');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Worker ID')),
      );
      return;
    }

    // Prepare the data to send
    final Map<String, dynamic> data = {
      'id_worker': idWorker, // Send worker ID as an integer
      'payment_plan': selectedPaymentPlan, // Ensure selectedPaymentPlan is a valid value
      'deskripsi': descriptionController.text, // Send the description from the controller
      'keahlian': selectedSkills, // Send selectedSkills as a list of skill IDs
    };

    // Define the API endpoint
    final String apiUrl = '$apiBaseUrl/halotec/worker_data/update.php';

    // Send the data to the backend
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(data), // Convert the data to JSON format
    );

    // Handle the response from the backend
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        // Successfully updated worker data
        print('Worker data updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully!')),
        );
      } else {
        // Error in updating worker data
        print('Error: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } else {
      // Server error
      print('Server error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error: ${response.statusCode}')),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}



void showPaymentPlanDialog() {
  // Use a temporary variable to manage the selected value
  String? tempSelectedPlan = selectedPaymentPlan;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select Payment Plan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text("Weekly"),
              subtitle: const Text("Rp 50,000"),
              value: "weekly",
              groupValue: tempSelectedPlan, // Bind to the temporary variable
              onChanged: (String? value) {
                setState(() {
                  tempSelectedPlan = value; // Update the temporary selection
                });
              },
            ),
            RadioListTile<String>(
              title: const Text("Monthly"),
              subtitle: const Text("Rp 200,000"),
              value: "monthly",
              groupValue: tempSelectedPlan,
              onChanged: (String? value) {
                setState(() {
                  tempSelectedPlan = value; // Update the temporary selection
                });
              },
            ),
            RadioListTile<String>(
              title: const Text("Yearly"),
              subtitle: const Text("Rp 2,000,000"),
              value: "yearly",
              groupValue: tempSelectedPlan,
              onChanged: (String? value) {
                setState(() {
                  tempSelectedPlan = value; // Update the temporary selection
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without confirming
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // After confirmation, update the selectedPaymentPlan
              setState(() {
                selectedPaymentPlan = tempSelectedPlan; // Update the main state
              });

              // Trigger data submission
              submitData();

              // Navigate to WorkerHomePage after submission
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => WorkerNavbar()),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      );
    },
  );
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFFB74D),
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            elevation: 10, // Adding elevation for the elevated effect
            borderRadius: BorderRadius.circular(20), // Rounded corners for the container
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(), // Empty space to balance the row
                      IconButton(
                        icon: const Icon(Icons.exit_to_app, color: Colors.black),
                        onPressed: () {
                          // Add your logout logic here
                          _logout(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // "Lengkapi Profil (Opsional)" Text
                  const Center(
                    child: Text(
                      'Lengkapi Profil (Opsional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile Picture inside the container
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage, // Display the image
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 60, color: Colors.grey[700])
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Worker Name - Centered, showing name from SharedPreferences
                  Center(
                    child: Text(
                      workerName ?? 'Worker Name', // Display worker name from SharedPreferences
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Skills (Keahlian) - Left-Aligned
                  const Text(
                    'Keahlian :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  availableSkills.isEmpty
                      ? const CircularProgressIndicator()
                      : Wrap(
                          spacing: 8.0,
                          children: availableSkills.map((skill) {
                            return ChoiceChip(
                              label: Text(skill['nama_keahlian']),
                              selected: selectedSkills.contains(skill['id_keahlian']),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    selectedSkills.add(skill['id_keahlian']);
                                  } else {
                                    selectedSkills.remove(skill['id_keahlian']);
                                  }
                                });
                              },
                              selectedColor: const Color(0xFFFFB74D),
                              backgroundColor: Colors.grey[300],
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 20),

                  // Description (Deskripsi) - Left-Aligned
                  const Text(
                    'Deskripsi :',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter a brief description of yourself...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Portfolio (Portofolio) - Left-Aligned
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Portofolio:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: selectPortfolioImage,
                        child: const Text(
                          "Select Portfolio Image",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 0),
                      buildPortfolioGrid(), // Portfolio images grid
                      const SizedBox(height: 20),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: showPaymentPlanDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB74D), // Set the button color to yellow
                        padding: const EdgeInsets.symmetric(vertical: 10), // Increase padding for better height
                        minimumSize: const Size(double.infinity, 48), // Make the button wider
                      ),
                      child: const Text(
                        "Select Payment Plan",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }

  void _logout(BuildContext context) async {
    // Clear the SharedPreferences data
    await SharedPreferencesHelper.clearPreferences();

    // Navigate to the AuthPage, where login and register pages are managed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthPage(), // Navigate to AuthPage after logout
      ),
    );
  }


}

