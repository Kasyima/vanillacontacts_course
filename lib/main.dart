import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      //! Define "/new-contact" as a new route
      //! Upon floating action button press, send user to NewContactView
      routes: {
        '/new-contact': (context) => _NewContactView(),
      },
    );
  }
}

class Contact {
  final String name;

  const Contact({
    required this.name,
  });
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();

  factory ContactBook() => _shared;

  final List<Contact> _contacts = [];

  int get length => _contacts.length;

  void add({required Contact contact}) {
    _contacts.add(contact);
  }

  void remove({required Contact contact}) {
    _contacts.remove(contact);
  }

  Contact? contact({required int atIndex}) =>
      _contacts.length > atIndex ? _contacts[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (context, index) {
          final contact = contactBook.contact(atIndex: index);
          return ListTile(
            title: Text(contact!.name),
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

class _NewContactView extends StatefulWidget {
  const _NewContactView({super.key});

  @override
  State<_NewContactView> createState() => __NewContactViewState();
}

//! Add TextEditingController to view
//! We want the user to be able to write the name of the new contact.
class __NewContactViewState extends State<_NewContactView> {
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
