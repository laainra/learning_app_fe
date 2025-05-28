import 'package:finbedu/widgets/custom_button.dart'; // Pastikan ActionButton adalah nama yang benar
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:finbedu/providers/review_provider.dart'; // Import ReviewProvider
// import '../../routes/app_routes.dart' as route; // Anda mungkin tidak memerlukannya jika navigasi dilakukan setelah sukses

class WriteReviewPage extends StatefulWidget {
  final int courseId; // Terima courseId

  const WriteReviewPage({
    super.key,
    required this.courseId, // Jadikan required
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Untuk validasi dasar
  bool _isSubmitting = false;

  // Listener untuk character counter
  @override
  void initState() {
    super.initState();
    _reviewController.addListener(() {
      setState(() {}); // Update UI untuk character counter
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a rating.')));
      return;
    }
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your review.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Provider.of<ReviewProvider>(context, listen: false).addReview(
        reviews: _reviewController.text.trim(),
        rating: _rating.toInt(),
        courseId: widget.courseId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
      // Kembali ke halaman sebelumnya setelah sukses
      if (mounted) {
        Navigator.pop(
          context,
          true,
        ); // Kirim 'true' untuk menandakan sukses jika perlu
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        // Pastikan widget masih ada di tree
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f5ff),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            // Bungkus dengan Form jika ingin validasi lebih lanjut
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back & Title
                Row(
                  children: [
                    IconButton(
                      // Jadikan Icon bisa diklik untuk kembali
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(
                      width: 0,
                    ), // Kurangi atau hilangkan jika IconButton sudah memberi padding
                    const Text(
                      "Write a Review", // Konsistenkan "Review" atau "Reviews"
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Ratings Title
                const Text(
                  "Ratings",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),

                // Stars
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                _rating = index + 1.0;
                              });
                            },
                            icon: Icon(
                              index < _rating
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              color: Colors.orange,
                              size: 32,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _rating > 0
                            ? "You rated: $_rating stars"
                            : "Click to Rate Course",
                        style: TextStyle(
                          color: _rating > 0 ? Colors.orange : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Write Review Section
                const Text(
                  "Write your Review", // Konsistenkan
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: _reviewController,
                        maxLines: 5,
                        maxLength: 250,
                        decoration: const InputDecoration(
                          hintText:
                              "Would you like to write anything about this course?", // Sesuaikan "Product" menjadi "course"
                          border: InputBorder.none,
                          counterText:
                              '', // maxLength sudah menampilkan counter bawaan
                        ),
                      ),
                      // Text( // Counter bawaan dari maxLength sudah cukup
                      //   "${250 - _reviewController.text.length} Characters Remaining",
                      //   style: const TextStyle(color: Colors.grey),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
                Center(
                  child:
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : ActionButton(
                            // Pastikan ActionButton adalah nama widget yang benar
                            label: "Submit Review",
                            color: const Color(0xFF202244),
                            width: double.infinity,
                            height: 50,
                            onTap:
                                _submitReview, // Panggil fungsi _submitReview
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF202244),
                            ), // Warna icon agar terlihat
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
