import 'package:flutter/material.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  // Placeholder for profile picture
  ImageProvider<Object>? _profileImage;

  // List of available skills (this can be dynamic as mentioned earlier)
  List<String> availableSkills = [
    "Teknisi Mekanik",
    "Teknisi Elektronik",
    "Tukang Kayu",
    "Tukang Atap",
    "Teknisi Komputer",
    "Teknisi Las",
    "Tukang Bangunan",
    "Teknisi Perpipaan",
  ];

  // List of selected skills
  List<String> selectedSkills = [];

  // Controller for custom skill input
  TextEditingController customSkillController = TextEditingController();

  // Controller for the description input
  TextEditingController descriptionController = TextEditingController();

  // Controller for portfolio images
  List<Image> portfolioImages = [];

  // Function to handle image selection (to be implemented later)
  void selectPortfolioImage() {
    // In the future, integrate image picker functionality here
    setState(() {
      portfolioImages.add(Image.asset('assets/placeholder_image.png')); // Add placeholder for now
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB74D), // Yellow-ish theme
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Add a square above the semicircle image
            Container(
              width: double.infinity,
              height: 40, // Height of the square
              color: const Color(0xFFf5DBA6), // Square color
            ),

            // Decorative semicircle image
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Semicircle image (use BoxFit.fill for stretching)
                Image.asset(
                  'assets/semicircle.png',
                  width: double.infinity,
                  height: 175, // Increase the height to ensure stretching
                  fit: BoxFit.fill, // Make the image stretch to fit the space
                ),
                // Profile image positioned over the semicircle with border
                Positioned(
                  top: 100, // Adjust to position the profile image to clip with semicircle
                  child: Container(
                    width: 120, // Width of the CircleAvatar
                    height: 120, // Height of the CircleAvatar
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 4, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60, // Adjusted size for a larger profile picture
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage,
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 60, color: Colors.grey[700])
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60), // Adjust for spacing with the larger profile picture

            // Centered name display
            const Text(
              'Worker Name',
              style: TextStyle(
                fontSize: 14, // Changed font size to 14
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Skills Input Form Section - Aligned to the left
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keahlian (Skills):',
                    style: TextStyle(
                      fontSize: 14, // Changed font size to 14
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Displaying selectable chips for predefined skills
                  Wrap(
                    spacing: 8.0,
                    children: availableSkills.map((skill) {
                      return ChoiceChip(
                        label: Text(skill),
                        selected: selectedSkills.contains(skill),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedSkills.add(skill);
                            } else {
                              selectedSkills.remove(skill);
                            }
                          });
                        },
                        selectedColor: const Color(0xFFFFB74D), // Highlight color when selected
                        backgroundColor: Colors.grey[300], // Default color for unselected chip
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Description Input Form Section
                  const Text(
                    'Deskripsi (Description):',
                    style: TextStyle(
                      fontSize: 14, // Changed font size to 14
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4, // Allow multi-line input
                    decoration: InputDecoration(
                      hintText: 'Enter a brief description of yourself...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintStyle: const TextStyle(fontSize: 12), // Set hint text size to 12
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Portfolio Input Form Section
                  const Text(
                    'Portofolio (Portfolio):',
                    style: TextStyle(
                      fontSize: 14, // Changed font size to 14
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: selectPortfolioImage,
                    child: const Text('Add Portfolio Image'),
                  ),

                  const SizedBox(height: 10),

                  // Displaying selected portfolio images (placeholders for now)
                  portfolioImages.isNotEmpty
                      ? Wrap(
                          spacing: 8.0,
                          children: portfolioImages.map((image) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image(image: image.image, width: 80, height: 80, fit: BoxFit.cover),
                            );
                          }).toList(),
                        )
                      : const Text('No portfolio images added yet.')
                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0), // Adjusts spacing for the button
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14), // Adjust vertical padding for button height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Capsule shape
                    ),
                    backgroundColor: const Color(0xFFf5DBA6), // Adjust button color as needed
                  ),
                  child: const Center(
                    child: Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
