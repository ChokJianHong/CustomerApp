import 'package:customer_app/API/review.dart';
import 'package:flutter/material.dart';

class ReviewDialog extends StatefulWidget {
  final String orderId;
  final String token;

  const ReviewDialog({
    super.key,
    required this.orderId,
    required this.token,
  });

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  double? _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  void _submitReview() async {
  if (_rating == null || _rating == 0) {
    // Ensure a rating is provided
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please provide a rating')),
    );
    return;
  }

  try {
    // Call your API to submit the review
    final response = await ReviewApi().createReview(
      token: widget.token,
      orderId: widget.orderId,
      rating: _rating!.toInt(),
      reviewText: _reviewController.text,
    );

    print('Response: $response'); // Print the raw response

    if (response['success']) {
      Navigator.pop(context); // Close the dialog on success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
    } else {
      // Handle failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['message']}')),
      );
      print('Review submission failed: ${response['message']}');
    }
  } catch (error) {
    // Print out the error in terminal for debugging
    print('Error occurred while submitting review: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Submit Your Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < (_rating ?? 0) ? Icons.star : Icons.star_border,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
              );
            }),
          ),
          TextField(
            controller: _reviewController,
            decoration: const InputDecoration(
              labelText: 'Write your review (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitReview,
          child: const Text('Submit Review'),
        ),
      ],
    );
  }
}
