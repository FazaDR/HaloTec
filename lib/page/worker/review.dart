import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:halotec/db/db_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<Review>> reviewsFuture = Future.error('Worker ID not initialized');

  @override
  void initState() {
    super.initState();
    _initializeReviews();
  }

  Future<void> _initializeReviews() async {
    final workerId = await _getWorkerId();
    if (workerId != null) {
      setState(() {
        reviewsFuture = fetchReviews(int.parse(workerId));
      });
    } else {
      setState(() {
        reviewsFuture = Future.error('Worker ID not found');
      });
    }
  }

  static Future<String?> _getWorkerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_worker');
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
                    _onRefresh(); // Call the refresh method (you may define it later)
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Optionally, add a search bar or other widgets here if needed
          ],
        ),
      ),
    );
  }

  void _onRefresh() {
    setState(() {
      reviewsFuture = Future.error('Worker ID not initialized'); // Reset the reviews data or perform a refresh logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 225), // Background color set here
      body: Column(
        children: [
          _buildSearchHeader(), // Custom header added here
          Expanded(
            child: FutureBuilder<List<Review>>(
              future: reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reviews available.'));
                }

                final reviews = snapshot.data!;

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(review.userName[0].toUpperCase()),
                          ),
                          title: Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.comment ?? 'No comment provided'),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: review.rating.toDouble(),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${review.rating} / 5'),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(review.createdAt.split(' ')[0]),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
