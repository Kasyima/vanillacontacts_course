import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//! Managing state with a singleton ValueNotifier

class Contact {
  final String id;
  final String name;

  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

//! Convert ContactBook to ValueNotifier<LIst<Contact>>
//! This allows us to track changes

//! Identify contacts
//! We will allow the user to remove contacts so we need id for each contact`

//! Add uuid package

//! length of ContactBook
//! Update length getter to use value.length
class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();

  factory ContactBook() => _shared;

  int get length => value.length;
//! Update "add()" function to use "value" instead
//? Don't forget notifyListeners()
  void add({required Contact contact}) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
    // value.add(contact);
    // notifyListeners();
  }

  void remove({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      value = contacts;
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

//! Value Notifier
//? This is how we will notify HomePage about changes to ContactBook

//! Rebuilding Our HomePage
//? We need to listen to changes to ValueNotifier and rebuild our widget.

//! ValueListenableBuilder
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      //! ListView for Contact instances
      //? Return ListView inside ValueListenableBuilder

      //! Dismissible cells
      //? Make your cells dismissible using Dismissible and ValueKey(contact.id)

      //! Removing contacts
      //? implement "onDismissed" on your Dismissible and remove the contact
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value as List<Contact>;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Dismissible(
                onDismissed: (direction) {
                  contacts.remove(contact);
                  //? ContactBook().remove(contact:contact);
                },
                key: ValueKey(contact.id),
                child: Material(
                  color: Colors.white,
                  elevation: 6.0,
                  child: ListTile(
                    title: Text(contact!.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/new-contact');
          // Navigator.of(context).pushNamed(routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

//! Add TextEditingController to view
//! We want the user to be able to write the name of the new contact.
class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Contact'),
      ),
      body: Column(
        children: [
          //! Add TextField and assign our controller to it
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter a new contact name here',
            ),
          ),
          TextButton(
              onPressed: () {
                final contact = Contact(name: _controller.text);
                ContactBook().add(contact: contact);
                Navigator.of(context).pop();
              },
              child: Text('Add Contact'))
          //! Add TextButton and add Contact upon pressing it and pop back too
          //! This will add a new contact to our ContactBook()
        ],
      ),
    );
  }
}
