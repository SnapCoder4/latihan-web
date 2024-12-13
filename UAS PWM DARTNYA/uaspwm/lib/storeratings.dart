import 'package:flutter/material.dart';

class StoreRatingsPage extends StatefulWidget {
  @override
  _StoreRatingsPageState createState() => _StoreRatingsPageState();
}

class _StoreRatingsPageState extends State<StoreRatingsPage> {
  double _rating = 0.0;
  final TextEditingController _feedbackController = TextEditingController();
  String _thankYouMessage = '';

  // Function to handle the submit action
  void _submitRating() {
    if (_rating > 0 && _feedbackController.text.isNotEmpty) {
      setState(() {
        _thankYouMessage = 'Terimakasih telah menilai toko kami!';
      });
    } else {
      setState(() {
        _thankYouMessage = 'Mohon berikan rating dan feedback.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nilai Toko Kami'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title text
                    Text(
                      'Berikan Rating untuk TechZone',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Rating stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.yellow,
                            size: 40,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 16),

                    // Feedback Text Field
                    TextField(
                      controller: _feedbackController,
                      decoration: InputDecoration(
                        labelText: 'Tinggalkan Feedback',
                        prefixIcon: Icon(Icons.feedback),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitRating,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text('Kirim Rating'),
                    ),
                    SizedBox(height: 16),

                    // Thank you message
                    if (_thankYouMessage.isNotEmpty)
                      Text(
                        _thankYouMessage,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
