import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:halotec/page/Auth.dart';
import 'package:halotec/util/SharedPreferences.dart';
import 'package:halotec/db/db_worker_all.dart'; // Import Worker model
import 'package:halotec/db/db_define_kategori.dart';
import 'package:halotec/db/db_portofolio.dart';
import 'package:halotec/util/config.dart';
import 'package:halotec/db/db_review.dart';
import 'package:halotec/db/db_create_pemesanan.dart';
import 'package:intl/intl.dart';

class PencarianPage extends StatefulWidget {
  final String selectedCategoryId;

  // Constructor to accept category ID
  PencarianPage({Key? key, this.selectedCategoryId = ''}) : super(key: key);

  @override
  _PencarianPageState createState() => _PencarianPageState();
}

class _PencarianPageState extends State<PencarianPage> {
  String selectedCategoryId = ''; // Default to "Tampilkan Semua"
  String selectedFilter = ''; 
  TextEditingController searchController = TextEditingController();
  

  List<Map<String, dynamic>> categories = [];
  List<Worker> workers = [];
  bool isLoading = true;
  bool isCategoryLoading = true;
  bool isAscending = true; // Default to ascending
  


  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.selectedCategoryId; // Set category ID from the constructor
    _fetchCategories();
    _fetchData(); // Fetch workers on init
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await fetchKategori();
      setState(() {
        categories = [
          {'id_kategori': '', 'nama_kategori': 'Tampilkan Semua', 'icon_name': ''},
          ...fetchedCategories,
        ];
        isCategoryLoading = false;
      });
    } catch (e) {
      setState(() {
        isCategoryLoading = false;
      });
      print('Error fetching categories: $e');
    }
  }


void _sortWorkers() {
  print('Sorting workers by ${isAscending ? 'ascending' : 'descending'} order.');

  setState(() {
    workers.sort((a, b) {
      if (selectedFilter == '1') {
        return isAscending ? a.rating.compareTo(b.rating) : b.rating.compareTo(a.rating);
      } else if (selectedFilter == '3') {
        return isAscending ? a.pengalamanKerja.compareTo(b.pengalamanKerja) : b.pengalamanKerja.compareTo(a.pengalamanKerja);
      } else if (selectedFilter == '5') {
        return isAscending ? a.rangeHarga.compareTo(b.rangeHarga) : b.rangeHarga.compareTo(a.rangeHarga);
      } else {
        return 0; // No sorting if no filter is selected
      }
    });
  });

  // Debug: Log the sorted list
  print('Sorted workers:');
  for (var worker in workers) {
    print('${worker.nama} - Rating: ${worker.rating} - Experience: ${worker.pengalamanKerja} - Price: ${worker.rangeHarga}');
  }
}



Future<void> _fetchData() async {
  setState(() {
    isLoading = true;
    workers.clear(); // Clear previous data to avoid showing old cards
  });

  try {
    // Determine filters based on the selected dropdown and sort options
    String? pengalamanKerjaFilter;
    double? ratingFilter;
    double? hargaFilter;

    if (selectedFilter == '1') {
      ratingFilter = isAscending ? 1.0 : -1.0; // Use positive for ascending, negative for descending
    } else if (selectedFilter == '3') {
      pengalamanKerjaFilter = isAscending ? 'asc' : 'desc';
    } else if (selectedFilter == '5') {
      hargaFilter = isAscending ? 1.0 : -1.0;
    }

    // Debug: Log the applied filters
    print('Fetching workers with filters:');
    print('Category: $selectedCategoryId');
    print('Rating Filter: $ratingFilter');
    print('Experience Filter: $pengalamanKerjaFilter');
    print('Price Filter: $hargaFilter');

    // Fetch workers based on the selected filters
    final fetchedWorkers = await fetchWorkers(
      kategori: selectedCategoryId.isNotEmpty ? selectedCategoryId : null,
      pengalamanKerja: pengalamanKerjaFilter,
      ratingFilter: ratingFilter,
      hargaFilter: hargaFilter,
    );

    setState(() {
      workers = fetchedWorkers;
      isLoading = false;
    });

    // Debug: Log the fetched workers
    print('Fetched workers:');
    for (var worker in workers) {
      print('${worker.nama} - Rating: ${worker.rating} - Experience: ${worker.pengalamanKerja} - Price: ${worker.rangeHarga}');
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    print('Error fetching workers: $e');
  }
}

  Future<void> _onRefresh() async {
      await _fetchData(); // Refresh the services by fetching new data
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFFF6E1),
    body: Column(
      children: [
        _buildSearchHeader(),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh, // This is the refresh function
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Dropdown
                          Expanded(
                            flex: 1, // Same flex value as the other dropdown
                            child: isCategoryLoading
                                ? Center(child: CircularProgressIndicator())
                                : _buildCategoryDropdown(),
                          ),
                          SizedBox(width: 10.0), // Space between dropdowns
                          
                          // Additional Filter Dropdown
                          Expanded(
                            flex: 1, // Same flex value as the category dropdown
                            child: _buildAdditionalFilterDropdown(),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0), // Add some spacing after dropdown row
                      if (workers.isEmpty)
                        Center(child: Text('No workers found.'))
                      else
                        ...workers.map((worker) => _buildWorkerCard(worker)).toList(),
                    ],
                  ),
                ),
              ),
      ],
    ),
  );
}


  Widget _buildSearchHeader() {
    return Material(
      elevation: 5.0,
      shadowColor: Colors.black.withOpacity(0.5),
      child: Container(
        color: const Color(0xFFFFB74D),
        padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 0),
            Row(
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
                    _onRefresh(); // Call the logout method
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Search bar
          ],
        ),
      ),
    );
  }

void showPortfolioDialog(BuildContext context, String workerName, List<Portfolio> portfolios, String keahlian) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator handle for sliding (centered)
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.only(bottom: 16.0),
                ),
              ),
              SizedBox(height: 8.0),
              Text("Keahlian :"),
              SizedBox(height: 8.0),
              // Displaying Keahlian as non-clickable chips
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: keahlian.split(',').map((skill) {
                  return Chip(
                    label: Text(skill.trim()),
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text("Portfolio :"),
              SizedBox(height: 16.0),
              // Check if portfolios are empty and show default message
              portfolios.isEmpty
                  ? Center(
                      child: Text(
                        "Belum ada portofolio",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: portfolios.length,
                      itemBuilder: (context, index) {
                        final portfolio = portfolios[index];
                        final fullImageUrl = '$apiBaseUrl${portfolio.imageUrl}';

                        return GestureDetector(
                          onTap: () {
                            // Show bottom sheet with clicked image details
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Indicator handle for sliding (centered)
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 40.0,
                                            height: 5.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            margin: EdgeInsets.only(bottom: 16.0),
                                          ),
                                        ),
                                        Image.network(
                                          fullImageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          portfolio.caption ?? "No caption available.",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              fullImageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      );
    },
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
  );
}



void showReviewDialog(BuildContext context, String workerName, List<Review> reviews) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reviews for $workerName',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: reviews.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      review.userName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${review.rating} ★",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  review.comment ?? '', // Default value when comment is null
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  review.createdAt,
                                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                ),
                                Divider(color: Colors.grey),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No reviews available.',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


Future<void> _onReviewButtonPressed(BuildContext context, Worker worker) async {
  try {
    // Fetch reviews for the worker
    List<Review> reviews = await fetchReviews(worker.idWorker);
    print('Response data: ${reviews}');

    // Show the reviews in a dialog
    showReviewDialog(context, worker.nama, reviews);
  } catch (e) {
    print('Error fetching reviews: $e');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Unable to fetch reviews. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

Future<void> showAjukanDialog(
  BuildContext context,
  int idWorker,
) async {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  String? idUser = await SharedPreferencesHelper.getUserId();

  if (idUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User ID not found. Please log in again.')),
    );
    return;
  }

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ajukan Pemesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Problem Description Input
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi Masalah',
                hintText: 'Masukkan deskripsi masalah Anda...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),
            // Date Picker Input
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Tanggal dan Waktu',
                hintText: 'Pilih tanggal dan waktu...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    DateTime fullDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    dateController.text = dateFormatter.format(fullDateTime);
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          // Submit Button
          ElevatedButton(
            onPressed: () async {
              String description = descriptionController.text.trim();
              String scheduledDate = dateController.text.trim();

              if (description.isEmpty || scheduledDate.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Harap isi semua bidang.')),
                );
                return;
              }

              Navigator.of(context).pop(); // Close the dialog

              // Call the `ajukan` function
              final response = await ajukan(idUser, idWorker, description, scheduledDate);

              if (response != null && response.statusCode == 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pemesanan berhasil diajukan!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal mengajukan pemesanan.')),
                );
              }
            },
            child: Text('Kirim'),
          ),
        ],
      );
    },
  );
}



Widget _buildAdditionalFilterDropdown() {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.only(top: 10.0), // Adjust the top margin to move it down
          child: DropdownButtonFormField<String>(
            value: null, // Default filter value
            items: [
              DropdownMenuItem(value: '', child: Text('All', style: TextStyle(fontSize: 10))),
              DropdownMenuItem(value: '1', child: Text('Rating', style: TextStyle(fontSize: 10))),
              DropdownMenuItem(value: '3', child: Text('Pengalaman', style: TextStyle(fontSize: 10))),
              DropdownMenuItem(value: '5', child: Text('Harga', style: TextStyle(fontSize: 10))),
            ],
            onChanged: (value) {
              // Update the state when a filter is selected and re-sort workers
              setState(() {
                selectedFilter = value ?? ''; // Set the selected filter
                _sortWorkers(); // Sort workers based on the selected filter
              });
            },
            decoration: InputDecoration(
              labelText: 'Filter',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
      SizedBox(width: 0.0),
      Padding(
        padding: EdgeInsets.all(0.0), // Add padding around the icon
        child: IconButton(
          onPressed: () {
            setState(() {
              // Toggle sort order
              isAscending = !isAscending;
              _sortWorkers();
            });
          },
          icon: Icon(
            isAscending ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.brown,
          ),
          iconSize: 20.0, // Adjust the icon size here
          tooltip: isAscending ? 'Sort Descending' : 'Sort Ascending',
        ),
      ),
    ],
  );
}




  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: selectedCategoryId,
        items: categories
            .map((category) => DropdownMenuItem<String>(
                  value: category['id_kategori'].toString(),
                  child: Text(category['nama_kategori'], style: TextStyle(fontSize: 10)), // Reduced font size
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategoryId = value ?? ''; // Default to "Tampilkan Semua"
            _fetchData(); // Refetch workers when category changes
          });
        },
        decoration: InputDecoration(
          labelText: 'Kategori',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

Widget _buildWorkerCard(Worker worker) {
  return GestureDetector(
    onTap: () async {
      try {
        // Fetch portfolio data for the selected worker
        List<Portfolio>? portfolios = await fetchPortfolio(worker.idWorker);

        // Show the portfolio dialog, even if there are no portfolios
        showPortfolioDialog(context, worker.nama, portfolios ?? [], worker.keahlian);
      } catch (e) {
        // Log the error to the console (optional)
        print('Error: $e');

        // Show the portfolio dialog with empty portfolios (no error dialog)
        showPortfolioDialog(context, worker.nama, [], worker.keahlian);
      }
    },

    child: Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.brown, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: worker.profilePic.isNotEmpty
                      ? NetworkImage(worker.profilePic)
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: worker.profilePic.isEmpty
                      ? Icon(Icons.person, size: 30.0, color: Colors.brown)
                      : null,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.nama,
                        style: TextStyle(
                          fontSize: 16.0, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(Icons.handyman, size: 16.0), // Reduced icon size
                          SizedBox(width: 4.0),
                          Text(worker.kategoriName, style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16.0), // Reduced icon size
                          SizedBox(width: 4.0),
                          Text('${worker.pengalamanKerja} Tahun', style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(Icons.attach_money, size: 16.0), // Reduced icon size
                          SizedBox(width: 4.0),
                          Text('Rp${worker.rangeHarga} /Jam', style: TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            // Row for rating and buttons side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between rating and buttons
              children: [
                // Rating Bar and Text on the left
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rating: ${worker.rating.toStringAsFixed(1)} ★",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: worker.rating,
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Icon(Icons.star, color: Colors.orange);
                      },
                    ),
                  ],
                ),
                // Buttons on the right side
                Row(
                  children: [
                    // Review Button
                    ElevatedButton(
                      onPressed: () async {
                        await _onReviewButtonPressed(context, worker);
                      },
                      child: Text('Review', style: TextStyle(color: Colors.black)), // Text color changed to black
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber, // Amber color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Less roundness
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // Adjust button padding
                      ),
                    ),

                    SizedBox(width: 8.0), // Space between buttons
                    // Ajukan Button
                    ElevatedButton(
                      onPressed: () async {
                        String? idUser = await SharedPreferencesHelper.getUserId();
                        print('Ajukan button pressed for user id: $idUser (type: ${idUser.runtimeType}) and worker id: ${worker.idWorker} (type: ${worker.idWorker.runtimeType})');

                        // Ensure `idUser` is valid
                        if (idUser != null) {
                          await showAjukanDialog(context, worker.idWorker); // Call the dialog
                        } else {
                          // Handle missing user ID (e.g., show an error message)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User ID not found. Please log in again.')),
                          );
                        }
                      },
                      child: Text('Ajukan', style: TextStyle(color: Colors.black)), // Text color changed to black
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber, // Amber color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Less roundness
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // Adjust button padding
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}





  void _logout(BuildContext context) async {
    await SharedPreferencesHelper.clearPreferences();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }
}
