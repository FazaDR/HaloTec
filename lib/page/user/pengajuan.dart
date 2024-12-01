import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:halotec/page/Auth.dart';
import 'package:halotec/db/db_update_pemesanan.dart';
import 'package:halotec/util/SharedPreferences.dart';
import 'package:halotec/db/db_pemesanan.dart';  
import 'package:halotec/db/db_insert_review.dart';
import 'package:halotec/db/db_delete_pemesanan.dart';

void main() {
  runApp(PengajuanPage());
}

class PengajuanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HalotecHomePage(),
    );
  }
}

class HalotecHomePage extends StatefulWidget {
  @override
  _HalotecHomePageState createState() => _HalotecHomePageState();
}

class ReviewDialog extends StatefulWidget {
  final Pemesanan service;
  final VoidCallback onStatusUpdated; // Add this parameter

  ReviewDialog({required this.service, required this.onStatusUpdated});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int selectedRating = 0; // Default rating
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Give a Review for ${widget.service.workerNama}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color: selectedRating >= index + 1
                      ? const Color.fromARGB(255, 255, 200, 0)
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    selectedRating = index + 1; // Update selected rating
                  });
                },
              );
            }),
          ),

          // Comment field
          TextField(
            controller: commentController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Your Comment',
              hintText: 'Optional',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
TextButton(
  onPressed: () async {
    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a rating'),
      ));
      return;
    }

    // Fetch the user ID asynchronously
    String? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      // Submit the review
      await submitReview(
        userId, // User ID
        widget.service.idWorker, // Worker ID
        selectedRating, // Rating
        commentController.text.trim(), // Comment
      );

      // Archive the service
      await updateServiceStatus(widget.service.idPemesanan, 'canceled');

      // Notify parent widget to update the UI
      widget.onStatusUpdated();

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User ID is not available. Please log in again.'),
      ));
    }
  },
  child: Text('Submit'),
),


      ],
    );
  }
}


class _HalotecHomePageState extends State<HalotecHomePage> {
  List<Pemesanan> services = [];


  @override
  void initState() {
    super.initState();
    _loadUserAndServices();
  }

  void _loadUserAndServices() async {
    String? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      _fetchPemesananData(userId);
    }
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesHelper.clearPreferences();

    // Replace the current route with the AuthPage and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
      (route) => false, // This ensures all previous routes are removed
    );
  }

  void _fetchPemesananData(String userId) async {
    try {
      List<Pemesanan> fetchedServices = await Pemesanan.fetchPemesananData(userId, true);
      setState(() {
        services = fetchedServices;
      });
    } catch (e) {
      print("Error fetching pemesanan data: $e");
    }
  }

void _archiveService(int idPemesanan, {bool isReviewCompleted = false}) async {
  try {
    String newStatus = isReviewCompleted ? 'canceled' : 'canceled';
    await updateServiceStatus(idPemesanan, newStatus);
    setState(() {
      services.firstWhere((s) => s.idPemesanan == idPemesanan).status = newStatus;
    });
    String message = isReviewCompleted
        ? 'Service status updated to canceled after review.'
        : 'Service has been canceled.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update service status: $e')),
    );
  }
}

void _showReviewDialog(BuildContext context, Pemesanan service) async {
  // Fetch the user ID from SharedPreferences
  String? userId = await SharedPreferencesHelper.getUserId();

  if (userId != null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReviewDialog(
          service: service,
          onStatusUpdated: () {
            setState(() {
              _fetchPemesananData(userId); // Use the fetched user ID to update the UI
            });
          },
        );
      },
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('User ID is not available. Please log in again.'),
    ));
  }
}

  void _launchWhatsApp(String phoneNumber) async {
    final url = phoneNumber;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E1),
      body: services.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Material(
                  elevation: 5.0,
                  shadowColor: Colors.black.withOpacity(0.5),
                  child: Container(
                    color: const Color(0xFFFFB74D),
                    padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'HaloTec',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.exit_to_app, color: Colors.black),
                          onPressed: () {
                            _logout(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Move 'in_progress' above 'pending'
                          sectionTitle('Service berlangsung', Icons.chat_bubble_outline),
                          ...services
                              .where((service) => service.status == 'in_progress')
                              .map((service) => serviceCard(context, service, Icons.chat_bubble_outline)),

                          const SizedBox(height: 16),

                          sectionTitle('Service belum disetujui', Icons.chat_bubble_outline),
                          ...services
                              .where((service) => service.status == 'pending')
                              .map((service) => serviceCard(
                                    context,
                                    service,
                                    Icons.cancel,
                                    isPending: true,
                                  )),

                          const SizedBox(height: 16),

                          sectionTitle('Service selesai', Icons.star_border),
                          ...services
                              .where((service) => service.status == 'completed')
                              .map((service) => serviceCard(context, service, Icons.star_border)),

                          const SizedBox(height: 16),

                          sectionTitle('Service inaktif', Icons.delete),
                          ...services
                              .where((service) => service.status == 'canceled')
                              .map((service) => serviceCard(context, service, Icons.delete)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

Widget serviceCard(BuildContext context, Pemesanan service, IconData trailingIcon, {bool isPending = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black, width: 1),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(service.workerProfilePic),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.workerNama,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (service.workerKategori.isNotEmpty)
                Text(
                  service.workerKategori,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              if (isPending)
                Text(
                  'Auto Cancel Setelah: ${service.scheduledDate}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                if (trailingIcon == Icons.chat_bubble_outline) {
                  _launchWhatsApp(service.workerTelpon);
                } else if (trailingIcon == Icons.cancel) {
                  _archiveService(service.idPemesanan);
                } else if (trailingIcon == Icons.star_border) {
                  _showReviewDialog(context, service);
                } else if (trailingIcon == Icons.delete) {
                  // Handle delete with callback to update the UI
                  deleteService(service.idPemesanan, () {
                    setState(() {
                      services.removeWhere((s) => s.idPemesanan == service.idPemesanan);
                    });
                  });
                }
              },
              child: Icon(trailingIcon, color: Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
