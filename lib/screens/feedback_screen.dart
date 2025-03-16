import 'package:flutter/material.dart';
import '../services/database_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  String _name = '';
  String _email = '';
  String _message = '';
  String _contactRequest = '';
  bool _isSubmittingFeedback = false;
  bool _isSubmittingRequest = false;
  bool _showRequestForm = false;

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmittingFeedback = true;
      });

      try {
        await _databaseService.submitFeedback(_name, _email, _message);

        setState(() {
          _isSubmittingFeedback = false;
          _name = '';
          _email = '';
          _message = '';
        });

        _formKey.currentState!.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feedback submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        setState(() {
          _isSubmittingFeedback = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting feedback: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitContactRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmittingRequest = true;
      });

      try {
        await _databaseService.requestNewContact(_name, _email, _contactRequest);

        setState(() {
          _isSubmittingRequest = false;
          _name = '';
          _email = '';
          _contactRequest = '';
          _showRequestForm = false;
        });

        _formKey.currentState!.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact request submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        setState(() {
          _isSubmittingRequest = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting request: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Feedback & Requests'),
          backgroundColor: Colors.green[700],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Toggle between feedback and request forms
              Row(
              children: [
              Expanded(
              child: ElevatedButton(
                  onPressed: () {
            setState(() {
            _showRequestForm = false;
            });
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: !_showRequestForm
                    ? Colors.green[700]
                    : Colors.grey[300],
                foregroundColor: !_showRequestForm
                    ? Colors.white
                    : Colors.black87,
              ),
              child: const Text('Send Feedback'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showRequestForm = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _showRequestForm
                    ? Colors.green[700]
                    : Colors.grey[300],
                foregroundColor: _showRequestForm
                    ? Colors.white
                    : Colors.black87,
              ),
              child: const Text('Request Contact'),
            ),
          ),
          ],
        ),
        const SizedBox(height: 24),

        // Common fields
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Your Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
          onSaved: (value) {
            _name = value!;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Your Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onSaved: (value) {
            _email = value!;
          },
        ),
        const SizedBox(height: 16),

        // Conditional form content
        if (!_showRequestForm) ...[
    TextFormField(
    decoration: const InputDecoration(
    labelText: 'Your Feedback',
    border: OutlineInputBorder(),
    hintText: 'Tell us what you think about the app...',
    ),
    maxLines: 5,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your feedback';
    }
    return null;
    },
    onSaved: (value) {
    _message = value!;
    },
    ),
    const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmittingFeedback ? null : _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmittingFeedback
                  ? const CircularProgressIndicator(color: Colors.white) // Fixed this line
                  : const Text('Submit Feedback'),
            ),
          ),
    ] else ...[
    TextFormField(
    decoration: const InputDecoration(
    labelText: 'Contact Information Request',
    border: OutlineInputBorder(),
    hintText: 'Describe the contact information you would like to be added...',
    ),
    maxLines: 5,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please describe the contact you want to add';
    }
    return null;
    },
    onSaved: (value) {
    _contactRequest = value!;
    },
    ),
    const SizedBox(height: 24),
    SizedBox(
    width: double.infinity,
    child: ElevatedButton(
    onPressed: _isSubmittingRequest ? null : _submitContactRequest,
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green[700],
    padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    child: _isSubmittingRequest
    ? const CircularProgressIndicator(color: Colors.white)
        : const Text('Submit Request'),
    ),
    ),
    ],
    const SizedBox(height: 32),
    const Card(
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Contact Developer',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 8),
    Text(
    'If you have any issues or suggestions, please feel free to contact the developer:',
    ),
    SizedBox(height: 8),
    Row(
    children: [
    Icon(Icons.email, size: 18),
    SizedBox(width: 8),
    Text('developer@villagephonebook.com'),
    ],
    ),
    SizedBox(height: 4),
    Row(
    children: [
    Icon(Icons.phone, size: 18),
    SizedBox(width: 8),
    Text('+1234567890'),
    ],
    ),
    ],
    ),
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