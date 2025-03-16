import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String contactsCollection = 'contacts';
  final String feedbackCollection = 'feedback';
  final String requestsCollection = 'requests';

  // Get all contacts
  Stream<List<Contact>> getContacts() {
    return _firestore
        .collection(contactsCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Contact.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Add a new contact
  Future<void> addContact(Contact contact) async {
    await _firestore.collection(contactsCollection).add(contact.toMap());
  }

  // Update an existing contact
  Future<void> updateContact(Contact contact) async {
    await _firestore
        .collection(contactsCollection)
        .doc(contact.id)
        .update(contact.toMap());
  }

  // Delete a contact
  Future<void> deleteContact(String contactId) async {
    await _firestore.collection(contactsCollection).doc(contactId).delete();
  }

  // Search contacts by name or profession
  Stream<List<Contact>> searchContacts(String query) {
    return _firestore
        .collection(contactsCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Contact.fromMap(doc.data(), doc.id))
        .toList()
        .where((contact) =>
    contact.name.toLowerCase().contains(query.toLowerCase()) ||
        contact.profession.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  // Submit feedback
  Future<void> submitFeedback(String name, String email, String message) async {
    await _firestore.collection(feedbackCollection).add({
      'name': name,
      'email': email,
      'message': message,
      'timestamp': Timestamp.now(),
    });
  }

  // Request a new contact
  Future<void> requestNewContact(
      String requesterName, String requesterEmail, String contactInfo) async {
    await _firestore.collection(requestsCollection).add({
      'requesterName': requesterName,
      'requesterEmail': requesterEmail,
      'contactInfo': contactInfo,
      'status': 'pending',
      'timestamp': Timestamp.now(),
    });
  }
}