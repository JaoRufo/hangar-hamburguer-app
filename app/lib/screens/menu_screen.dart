import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Todos';
  final List<String> _categories = ['Todos', 'Hamburgers', 'Bebidas'];

  final List<Product> _products = [
    // Hamburgers
    Product(
      id: '1',
      name: 'Jumbo 747',
      description:
          'Pão com gergilin, 2x Hambúrguer, Cheddar, Bacon e Molho especial',
      price: 28.00,
      image: 'assets/images/jumbo_747.jpeg', // Espaço para imagem futura
      category: 'Hamburgers',
      ingredients: [
        'Pão com gergilin',
        '2x Hambúrguer',
        'Cheddar',
        'Bacon',
        'Molho especial',
      ],
    ),
    Product(
      id: '2',
      name: 'Super Tucano',
      description:
          'Pão com gergilin, Hambúrguer, Cheddar, Bacon, Alface, Tomate, Cebola e Molho especial',
      price: 26.00,
      image: 'assets/images/super_tucano.jpeg', // Espaço para imagem futura
      category: 'Hamburgers',
      ingredients: [
        'Pão com gergilin',
        'Hambúrguer',
        'Cheddar',
        'Bacon',
        'Alface',
        'Tomate',
        'Cebola',
        'Molho especial',
      ],
    ),
    Product(
      id: '3',
      name: 'Planador',
      description:
          'Pão com gergilin, Hambúrguer de frango, Bacon, Mussarela, Alface, Tomate e Molho especial',
      price: 22.00,
      image: 'assets/images/planador.jpeg', // Espaço para imagem futura
      category: 'Hamburgers',
      ingredients: [
        'Pão com gergilin',
        'Hambúrguer de frango',
        'Bacon',
        'Mussarela',
        'Alface',
        'Tomate',
        'Molho especial',
      ],
    ),
    Product(
      id: '4',
      name: 'Sukhoi SU-59',
      description: 'Pão com gergilin, Hambúrguer, Cheddar e Molho especial',
      price: 18.00,
      image: 'assets/images/sukhoi_su59.jpeg', // Espaço para imagem futura
      category: 'Hamburgers',
      ingredients: [
        'Pão com gergilin',
        'Hambúrguer',
        'Cheddar',
        'Molho especial',
      ],
    ),
    Product(
      id: '5',
      name: 'Antnov 225',
      description:
          'Pão com gergilin, 2x Hambúrguer de frango, Bacon, Catupiry e Molho especial',
      price: 28.00,
      image: 'assets/images/antnov_225.jpeg', // Espaço para imagem futura
      category: 'Hamburgers',
      ingredients: [
        'Pão com gergilin',
        '2x Hambúrguer de frango',
        'Bacon',
        'Catupiry',
        'Molho especial',
      ],
    ),
    Product(
      id: '6',
      name: 'Ultra leve',
      description:
          'Pão com gergilin, Hambúrguer de frango, Cream Cheese e Molho especial',
      price: 18.00,
      image: 'assets/images/ultra_leve.jpeg', // Espaço para imagem futura
      category: 'Hamburgers',
      ingredients: [
        'Pão com gergilin',
        'Hambúrguer de frango',
        'Cream Cheese',
        'Molho especial',
      ],
    ),
    // Bebidas
    Product(
      id: '7',
      name: 'Refrigerantes 2 litros',
      description: 'Coca-cola, Pepsi e Guaraná',
      price: 12.00,
      image: 'assets/images/refrigerantes_2l.png', // Espaço para imagem futura
      category: 'Bebidas',
      ingredients: ['Coca-cola, Pepsi ou Guaraná 2L'],
    ),
    Product(
      id: '8',
      name: 'Água sem gás',
      description: 'Água sem gás 500ml',
      price: 3.00,
      image: 'assets/images/agua_sem_gas.png', // Espaço para imagem futura
      category: 'Bebidas',
      ingredients: ['Água mineral 500ml'],
    ),
    Product(
      id: '9',
      name: 'Água com gás',
      description: 'Água com gás 500ml',
      price: 3.50,
      image: 'assets/images/agua_com_gas.png', // Espaço para imagem futura
      category: 'Bebidas',
      ingredients: ['Água com gás 500ml'],
    ),
  ];

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Todos') {
      return _products;
    }
    return _products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/Logo_hangar_hamburguer.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.local_dining,
                      size: 24,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Cardápio'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFF87CEEB),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  onAddToCart: () {
                    Provider.of<CartService>(
                      context,
                      listen: false,
                    ).addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} adicionado ao carrinho'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: const Color(0xFF87CEEB),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
