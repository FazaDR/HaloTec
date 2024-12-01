import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:halotec/util/config.dart';

class Review {
  final int idReview;
  final int idUser;
  final int idWorker;
  final int rating;
  final String? comment; // Make comment nullable
  final String createdAt;
  final String userName;

  Review({
    required this.idReview,
    required this.idUser,
    required this.idWorker,
    required this.rating,
    this.comment, // Allow comment to be nullable
    required this.createdAt,
    required this.userName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      idReview: json['id_review'],
      idUser: json['id_user'],
      idWorker: json['id_worker'],
      rating: json['rating'],
      comment: json['comment'], // Directly assign as it can be null
      createdAt: json['created_at'],
      userName: json['user_name'],
    );
  }
}

Future<List<Review>> fetchReviews(int idWorker) async {
  final String url = '$apiBaseUrl/halotec/review_worker/modul.php';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id_worker': idWorker}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'success') {
        final List<dynamic> reviewsJson = data['reviews'];
        return reviewsJson.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch reviews: ${data['message']}');
      }
    } else {
      throw Exception('Failed to connect to server. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('An error occurred: $e');
  }
}
