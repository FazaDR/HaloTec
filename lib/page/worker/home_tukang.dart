import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:halotec/db/db_update_pemesanan.dart';
import 'package:halotec/util/SharedPreferences.dart';
import 'package:halotec/db/db_pemesanan.dart';  
import 'package:halotec/db/db_insert_review.dart';
import 'package:halotec/db/db_delete_pemesanan.dart';

// Halaman utama untuk tukang
void main() {
  runApp(HomeTukangPage());
}

class HomeTukangPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeTukangPageState(),
    );
  }
}

class HomeTukangPageState extends StatefulWidget {
  @override
  _HomeTukangPageState createState() => _HomeTukangPageState();
}

class ReviewDialog extends StatefulWidget {
  final Pemesanan service;
  final VoidCallback onStatusUpdated; // Callback to update UI when status changes

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
      title: Text('Give a Review for ${widget.service.userNama}'),
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
            String? workerId = await SharedPreferencesHelper.getWorkerId();
            if (workerId != null) {
              // Submit the review
              await submitReview(
                workerId, // User ID
                widget.service.idWorker, // Worker ID
                selectedRating, // Rating
                commentController.text.trim(), // Comment
              );

              // Archive the service (change status)
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

class _HomeTukangPageState extends State<HomeTukangPageState> {
    List<Pemesanan> services = [];

  @override
  void initState() {
    super.initState();
    _loadUserAndServices(); // Adjusted to reflect the new name
  }

  Future<void> _loadUserAndServices() async {
    String? workerId = await SharedPreferencesHelper.getWorkerId();
    if (workerId != null) {
      await _fetchPemesananData(workerId);
    }
  }

  Future<void> _onRefresh() async {
    String? workerId = await SharedPreferencesHelper.getWorkerId();
    if (workerId != null) {
      await _fetchPemesananData(workerId); // Refresh the services by fetching new data
    }
  }


  // void _logout(BuildContext context) async {
  //   await SharedPreferencesHelper.clearPreferences();

  //   // Replace the current route with the AuthPage and remove all previous routes
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => AuthPage()),
  //     (route) => false, // This ensures all previous routes are removed
  //   );
  // }
  
Future<void> _fetchPemesananData(String workerId) async {
  print("Starting to fetch pemesanan data for workerId: $workerId");

  try {
    print("Calling fetchPemesananData with workerId: $workerId and filter: false");

    List<Pemesanan> fetchedServices =
        await Pemesanan.fetchPemesananData(workerId, false);

    print("Fetched ${fetchedServices.length} items. Details:");

    for (var pemesanan in fetchedServices) {
      print("""
      -----
      idPemesanan: ${pemesanan.idPemesanan}
      Description: ${pemesanan.description}
      Scheduled Date: ${pemesanan.scheduledDate}
      Status: ${pemesanan.status}
      Cancel Reason: ${pemesanan.cancelReason ?? 'None'}
      Created At: ${pemesanan.createdAt}
      User Info:
        - Name: ${pemesanan.userNama}
        - Phone: ${pemesanan.userTelpon}
        - Address: ${pemesanan.userAlamat}
        - Profile Pic: ${pemesanan.userProfilePic ?? 'None'}
        - Gender: ${pemesanan.userGender}
      Worker Info:
        - Name: ${pemesanan.workerNama}
        - Phone: ${pemesanan.workerTelpon}
        - Profile Pic: ${pemesanan.workerProfilePic ?? 'None'}
        - Category: ${pemesanan.workerKategori}
      Worker ID: ${pemesanan.idWorker}
      -----
      """);
    }

    setState(() {
      services = fetchedServices;
      print("State updated with fetched services.");
    });
  } catch (e, stackTrace) {
    print("Error fetching pemesanan data: $e");
    print("StackTrace: $stackTrace");
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
  String? workerId = await SharedPreferencesHelper.getWorkerId();

  if (workerId != null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReviewDialog(
          service: service,
          onStatusUpdated: () {
            setState(() {
              _fetchPemesananData(workerId); // Use the fetched user ID to update the UI
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
    body: Column(
      children: [
        // Header Section
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
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  onPressed: () {
                    _onRefresh();
                  },
                ),
              ],
            ),
          ),
        ),
        // Body Section
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 'In Progress' Section
                  sectionTitle('Service berlangsung', Icons.chat_bubble_outline),
                  if (services.any((service) => service.status == 'in_progress'))
                    ...services
                        .where((service) => service.status == 'in_progress')
                        .map((service) => serviceCard(context, service, Icons.chat_bubble_outline))
                  else
                    noServiceMessage('No ongoing services.'),

                  const Divider(),

                  // 'Pending' Section
                  sectionTitle('Service belum disetujui', Icons.chat_bubble_outline),
                  if (services.any((service) => service.status == 'pending'))
                    ...services
                        .where((service) => service.status == 'pending')
                        .map((service) => serviceCard(
                              context,
                              service,
                              Icons.cancel,
                              isPending: true,
                            ))
                  else
                    noServiceMessage('No pending services.'),

                  const Divider(),

                  // 'Completed' Section
                  sectionTitle('Service selesai', Icons.star_border),
                  if (services.any((service) => service.status == 'completed'))
                    ...services
                        .where((service) => service.status == 'completed')
                        .map((service) => serviceCard(context, service, Icons.star_border))
                  else
                    noServiceMessage('No completed services.'),

                  const Divider(),

                  // 'Canceled' Section
                  sectionTitle('Service inaktif', Icons.delete),
                  if (services.any((service) => service.status == 'canceled'))
                    ...services
                        .where((service) => service.status == 'canceled')
                        .map((service) => serviceCard(context, service, Icons.delete))
                  else
                    noServiceMessage('No inactive services.'),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Helper method for an empty section message
Widget noServiceMessage(String message) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      message,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
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
          backgroundImage: NetworkImage(service.userProfilePic),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.userNama,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (service.userAlamat.isNotEmpty)
                Text(
                  service.userAlamat,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              if (isPending)
                Text(
                  'Menunggung hingga: ${service.scheduledDate}',
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
