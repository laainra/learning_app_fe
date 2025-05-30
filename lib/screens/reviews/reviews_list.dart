import 'package:finbedu/screens/reviews/write_reviews.dart'; // Ganti dengan path yang benar ke WriteReviewPage Anda
// import 'package:finbedu/services/access_service.dart'; // Tidak terlihat digunakan, bisa dihapus jika tidak perlu
import 'package:finbedu/widgets/custom_button.dart'; // Pastikan ActionButton adalah nama widget yang benar
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/review_provider.dart';
import 'package:finbedu/models/review_model.dart';
// import 'package:finbedu/models/user_model.dart'; // Tidak perlu import UserModel secara eksplisit di sini jika sudah ada di ReviewModel
import 'package:intl/intl.dart';

class ReviewsPage extends StatefulWidget {
  final int courseId;

  const ReviewsPage({super.key, required this.courseId});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final storage =
      const FlutterSecureStorage(); // Inisialisasi FlutterSecureStorage
  int? _loggedInUserId;
  bool _isUserDataLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return; // Pastikan widget masih ada di tree
    setState(() {
      _isUserDataLoading = true;
    });

    String? userIdString = await storage.read(
      key: 'user_id',
    ); // Ganti 'user_id' jika key Anda berbeda
    if (userIdString != null) {
      _loggedInUserId = int.tryParse(userIdString);
    }

    if (mounted) {
      // Cek lagi sebelum setState
      setState(() {
        _isUserDataLoading = false;
      });
    }
    // Panggil fetchReviews setelah data user dimuat (atau bisa paralel jika tidak ada dependensi kuat)
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    if (mounted) {
      // Pastikan context masih valid (mounted)
      await Provider.of<ReviewProvider>(
        context,
        listen: false,
      ).loadReviews(courseId: widget.courseId);
    }
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Unknown date';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime.toLocal());
    } catch (e) {
      return dateTimeString;
    }
  }

  Future<void> _handleDeleteReview(int reviewId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this review?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await Provider.of<ReviewProvider>(
          context,
          listen: false,
        ).removeReview(reviewId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review deleted successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete review: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        double averageRating = 0;
        int totalReviews = 0;

        if (reviewProvider.reviews.isNotEmpty) {
          averageRating =
              reviewProvider.averageRating; // Gunakan getter dari provider
          totalReviews =
              reviewProvider.totalReviews; // Gunakan getter dari provider
        }

        // Tidak ada filter lagi, tampilkan semua review
        List<Review> displayedReviews = reviewProvider.reviews;

        return Scaffold(
          backgroundColor: const Color(
            0xFF202244,
          ), // Warna latar belakang utama halaman
          body: SafeArea(
            child: Column(
              children: [
                // Header Kustom
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Course Reviews',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ), // Sesuaikan agar judul tetap di tengah
                    ],
                  ),
                ),

                // Bagian Putih Utama
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Icon(
                              averageRating >= index + 1
                                  ? Icons.star
                                  : averageRating >= index + 0.5
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          'Based on $totalReviews Reviews',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 24,
                        ), // Jarak setelah statistik rating
                        // Daftar Review
                        Expanded(
                          child:
                              _isUserDataLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : reviewProvider.isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : reviewProvider.errorMessage != null
                                  ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Error: ${reviewProvider.errorMessage}',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                  : displayedReviews.isEmpty
                                  ? const Center(
                                    child: Text(
                                      'No reviews yet for this course.',
                                    ),
                                  )
                                  : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    itemCount: displayedReviews.length,
                                    itemBuilder: (context, index) {
                                      final review = displayedReviews[index];
                                      return ReviewItem(
                                        key: ValueKey(review.id),
                                        review: review,
                                        loggedInUserId: _loggedInUserId,
                                        onDelete:
                                            (reviewId) =>
                                                _handleDeleteReview(reviewId),
                                      );
                                    },
                                  ),
                        ),
                        const SizedBox(
                          height: 10,
                        ), // Sedikit ruang di bawah list
                      ],
                    ),
                  ),
                ),

                // Tombol "Write a Review"
                if (!_isUserDataLoading) // Tampilkan tombol jika data user sudah dicek
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      20,
                    ), // Padding lebih konsisten
                    child: ActionButton(
                      label: "Write a Review",
                      color: Colors.white, // Warna tombol utama
                      textColor: Color(0xFF202244), // Warna teks pada tombol
                      width: double.infinity,
                      height: 50,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Pastikan WriteReviewPage sudah benar path importnya
                            builder:
                                (_) =>
                                    WriteReviewPage(courseId: widget.courseId),
                          ),
                        );
                        if (result == true && mounted) {
                          _fetchReviews();
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF202244),
                      ), // Ikon pada tombol
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReviewItem extends StatelessWidget {
  final Review review;
  final int? loggedInUserId;
  final Function(int reviewId) onDelete;

  const ReviewItem({
    super.key,
    required this.review,
    this.loggedInUserId,
    required this.onDelete,
  });

  String _formatDisplayDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime.toLocal());
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    // Asumsi 'photo' adalah field URL avatar di review.user
    final String? avatarPath = review.user?.photo;

    if (avatarPath != null && avatarPath.isNotEmpty) {
      // Jika avatarPath adalah URL lengkap, gunakan NetworkImage.
      // Jika hanya nama file, Anda perlu menggabungkannya dengan base URL gambar Anda.
      // Contoh: backgroundImage = NetworkImage('${Constants.imgUrl}/$avatarPath');
      // Untuk saat ini, kita anggap avatarPath adalah URL lengkap jika ada.
      backgroundImage = NetworkImage(avatarPath);
    } else {
      backgroundImage = const AssetImage(
        'assets/placeholder_avatar.png',
      ); // Pastikan placeholder ada
    }

    final bool isOwnReview =
        loggedInUserId != null && review.userId == loggedInUserId;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar item review
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                Colors.grey.shade300, // Warna fallback jika gambar error
            backgroundImage: backgroundImage,
            onBackgroundImageError: (exception, stackTrace) {
              // Anda bisa log error atau menampilkan UI lain jika gambar gagal dimuat
              print('Error loading avatar: $avatarPath, Error: $exception');
            },
            child:
                (avatarPath == null || avatarPath.isEmpty)
                    ? Text(
                      review.user?.name?.isNotEmpty == true
                          ? review.user!.name![0].toUpperCase()
                          : 'A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        review.user?.name ?? 'Anonymous User',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // Rating atau Tombol Hapus
                    isOwnReview
                        ? IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[600],
                          ),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          tooltip: 'Delete Review',
                          onPressed: () => onDelete(review.id),
                        )
                        : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber.shade800,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                review.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
                if (isOwnReview) // Jika review sendiri, tampilkan rating di bawah nama
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          review.rating >= i + 1
                              ? Icons.star
                              : review.rating >= i + 0.5
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  review.review,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDisplayDate(review.createdAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
