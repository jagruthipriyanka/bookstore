import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Store()));

class Book {
  final String title, author, category; final double price; final int stock;
  const Book(this.title, this.author, this.category, this.price, this.stock);
}

const books = [
  Book('The Alchemist', 'Paulo Coelho', 'Fiction', 299, 10), Book('Godan', 'Premchand', 'Fiction', 199, 5),
  Book('The Guide', 'R.K. Narayan', 'Fiction', 249, 0), Book('Malgudi Days', 'R.K. Narayan', 'Fiction', 219, 7),
  Book('Wings of Fire', 'A.P.J. Abdul Kalam', 'Science', 350, 8), Book('A Brief History of Time', 'Stephen Hawking', 'Science', 450, 4),
  Book('Cosmos', 'Carl Sagan', 'Science', 499, 6), Book('The Selfish Gene', 'Richard Dawkins', 'Science', 399, 3),
  Book('Clean Code', 'Robert C. Martin', 'Tech', 650, 9), Book('Flutter in Action', 'Eric Windmill', 'Tech', 550, 5),
  Book('Python Crash Course', 'Eric Matthes', 'Tech', 599, 12), Book('Head First Java', 'Kathy Sierra', 'Tech', 620, 2),
];

class Store extends StatefulWidget { const Store({super.key}); @override State<Store> createState() => _StoreState(); }

class _StoreState extends State<Store> {
  final wish = <Book>[]; String q = '', cat = 'All'; bool showWish = false;

  void add(Book b) {
    if (wish.length >= 10) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wishlist is full (max 10 books)'))); return; }
    setState(() => wish.add(b));
  }

  void details(Book b) => showDialog(context: context, builder: (_) => AlertDialog(title: Text(b.title),
      content: Text('Author: ${b.author}\nCategory: ${b.category}\nPrice: ₹${b.price}\nStock: ${b.stock == 0 ? 'Out of stock' : b.stock}')));

  @override
  Widget build(BuildContext context) {
    final shown = (showWish ? wish : books).where((b) => (cat == 'All' || b.category == cat) && '${b.title} ${b.author}'.toLowerCase().contains(q)).toList();
    return Scaffold(
        appBar: AppBar(title: Text(showWish ? 'Wishlist (${wish.length}/10)' : 'Bookstore'), actions: [
          IconButton(icon: Icon(showWish ? Icons.menu_book : Icons.favorite), tooltip: 'Switch view', onPressed: () => setState(() => showWish = !showWish)),
          IconButton(icon: const Icon(Icons.history), tooltip: 'Load old wishlist (12 books)', onPressed: () => setState(() { wish.clear(); wish.addAll(books); }))]),
        body: Column(children: [
          if (wish.length > 10) Container(width: double.infinity, color: Colors.red.shade100, padding: const EdgeInsets.all(8),
              child: Text('⚠ Wishlist has ${wish.length} books (limit is 10). Please remove some. Nothing was deleted.')),
          Padding(padding: const EdgeInsets.all(8), child: Row(children: [
            Expanded(child: TextField(decoration: const InputDecoration(hintText: 'Search title or author', prefixIcon: Icon(Icons.search)), onChanged: (v) => setState(() => q = v.toLowerCase()))),
            const SizedBox(width: 8),
            DropdownButton<String>(value: cat, items: ['All', 'Fiction', 'Science', 'Tech'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => cat = v!))])),
          Expanded(child: ListView(children: shown.map((b) => ListTile(
              onTap: () => details(b), isThreeLine: true, title: Text(b.title),
              subtitle: Text('${b.author} • ${b.category}\n₹${b.price} • ${b.stock == 0 ? 'Out of stock' : 'Stock: ${b.stock}'}'),
              trailing: wish.contains(b)
                  ? IconButton(icon: const Icon(Icons.favorite, color: Colors.red), onPressed: () => setState(() => wish.remove(b)))
                  : IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => add(b)))).toList()))]));
  }
}