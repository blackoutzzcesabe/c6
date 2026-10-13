import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const C6YellowApp());
}

// Controller global para gerenciar saldo e persistência com SharedPreferences
class AppDataModel extends ChangeNotifier {
  bool _isBalanceVisible = false;
  double _accountBalance = 8.27;

  bool get isBalanceVisible => _isBalanceVisible;
  double get accountBalance => _accountBalance;

  AppDataModel() {
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    _accountBalance = prefs.getDouble('saved_balance') ?? 8.27;
    notifyListeners();
  }

  Future<void> updateBalance(double newBalance) async {
    _accountBalance = newBalance;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saved_balance', newBalance);
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }
}

final appData = AppDataModel();

class C6YellowApp extends StatelessWidget {
  const C6YellowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C6 Yellow Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFFEE140),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF1E1E1E),
          primary: Color(0xFFFEE140),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CardsScreen(),
    const InvestScreen(),
    const StatementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFFFEE140),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            activeIcon: Icon(Icons.credit_card),
            label: 'Cartões',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            activeIcon: Icon(Icons.show_chart),
            label: 'Investir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Extrato',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TELA 1: INÍCIO (Com Dicas C6Yellow Fiéis)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Olá,', style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Pedro', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(appData.isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () {
                  appData.toggleBalanceVisibility();
                },
              ),
              IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Conta Corrente Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Logo personalizada da bandeira do Brasil sem emoji
                        Container(
                          width: 20,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Conta corrente', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Saldo em reais', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appData.isBalanceVisible 
                            ? 'R\$ ${appData.accountBalance.toStringAsFixed(2).replaceAll('.', ',')}' 
                            : 'R\$ •••••',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Ações Rápidas Topo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _QuickActionButton(icon: Icons.swap_horiz, label: 'Transferir'),
                  _QuickActionButton(icon: Icons.description_outlined, label: 'Extrato'),
                  _QuickActionButton(icon: Icons.credit_card, label: 'Cartão'),
                  _QuickActionButton(icon: Icons.trending_up, label: 'Investir'),
                ],
              ),
              const SizedBox(height: 16),
              // Bloco Pix
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pix', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C2C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Digite ou cole uma chave Pix', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE140),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward, color: Colors.black),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _PixSubAction(icon: Icons.swap_horiz, label: 'Transferir Pix'),
                        _PixSubAction(icon: Icons.qr_code, label: 'Pagar QR Code'),
                        _PixSubAction(icon: Icons.monetization_on_outlined, label: 'Gerar QR Code'),
                      ],
                    ),
                    const Divider(height: 32, color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                                SizedBox(width: 6),
                                Text('Email', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('rodrigotlinhares77@gmail.com', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        TextButton(onPressed: () {}, child: const Text('Cadastrar', style: TextStyle(color: Color(0xFF3EA6FF))))
                      ],
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text('Minhas chaves', style: TextStyle(color: Color(0xFF3EA6FF), fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Seção Dicas @C6Yellow
              const Text('Dicas @C6Yellow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 340,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _TipCard(
                      bannerColor: Colors.cyan,
                      title: 'Cartões @C6Yellow',
                      description: 'O cartão do C6 Yellow é um cartão de débito e pode ser usado em compras à vista em lojas físicas e on-line.',
                    ),
                    SizedBox(width: 16),
                    _TipCard(
                      bannerColor: Colors.amber,
                      title: 'Cartões @C6Yellow',
                      description: 'É uma forma de pagamento segura e prática. Você não precisa andar com dinheiro para fazer suas compras.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// TELA 2: CARTÕES
// ==========================================
class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cartões', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              width: 220,
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFF00ACC1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: const [
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Icon(Icons.contactless, color: Colors.white, size: 20),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Row(
                      children: [
                        Text('💳', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 4),
                        Text('C6yellow', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(child: Text('Pedro Anastacio', style: TextStyle(fontWeight: FontWeight.bold))),
          const Center(child: Text('Cartão de débito final 4190', style: TextStyle(color: Colors.grey, fontSize: 12))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.lock_open, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Cartão desbloqueado', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('Bloquear', style: TextStyle(color: Color(0xFF3EA6FF), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Meu cartão', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: const [
                ListTile(leading: Icon(Icons.lock_outline), title: Text('Ver senha'), trailing: Icon(Icons.chevron_right)),
                Divider(height: 1, color: Colors.black),
                ListTile(leading: Icon(Icons.shopping_bag_outlined), title: Text('Compras no cartão'), trailing: Icon(Icons.chevron_right)),
                Divider(height: 1, color: Colors.black),
                ListTile(leading: Icon(Icons.credit_card), title: Text('Cartão virtual'), trailing: Icon(Icons.chevron_right)),
                Divider(height: 1, color: Colors.black),
                ListTile(leading: Icon(Icons.add_card), title: Text('Pedir novo cartão'), trailing: Icon(Icons.chevron_right)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TELA 3: INVESTIR (Com Menu Secreto Corrigido)
// ==========================================
class InvestScreen extends StatelessWidget {
  const InvestScreen({super.key});

  void _showSecretBalanceEditor(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: appData.accountBalance.toStringAsFixed(2),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menu Secreto: Editar Saldo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFEE140)),
              ),
              const SizedBox(height: 12),
              const Text('Insira o novo valor para o saldo da conta corrente:', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixText: 'R\$ ',
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFEE140)),
                  onPressed: () {
                    final cleanText = controller.text.replaceAll(',', '.');
                    final newBalance = double.tryParse(cleanText) ?? appData.accountBalance;
                    appData.updateBalance(newBalance);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saldo atualizado e salvo com sucesso!')),
                    );
                  },
                  child: const Text('Salvar Novo Saldo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Investimentos por objetivos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.help_outline), onPressed: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.cake, size: 50, color: Colors.pinkAccent),
                const SizedBox(height: 12),
                const Text('0% completo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Total R\$ 0,00', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
                        onPressed: () => _showSecretBalanceEditor(context),
                        child: const Text('Detalhes', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFEE140)),
                        onPressed: () {},
                        child: const Text('Investir mais', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Últimas atualizações', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Qui., 11 de setembro', style: TextStyle(color: Colors.grey, fontSize: 12)),
                SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: Color(0xFF2C2C2C), child: Icon(Icons.arrow_upward, color: Colors.white)),
                  title: Text('Saiu'),
                  subtitle: Text('Resgate realizado'),
                  trailing: Text('R\$ 53,02', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TELA 4: EXTRATO
// ==========================================
class StatementScreen extends StatelessWidget {
  const StatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Extrato', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Conta corrente', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Saldo em reais', style: TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      appData.isBalanceVisible 
                        ? 'R\$ ${appData.accountBalance.toStringAsFixed(2).replaceAll('.', ',')}' 
                        : 'R\$ •••••',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ActionChip(label: const Text('Filtros'), avatar: const Icon(Icons.filter_list, size: 16), onPressed: () {}),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Entradas'), selected: true, onSelected: (_) {}),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Saídas'), selected: false, onSelected: (_) {}),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Devolução'), selected: false, onSelected: (_) {}),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Ontem', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const ListTile(
                  leading: CircleAvatar(backgroundColor: Color(0xFF2C2C2C), child: Icon(Icons.arrow_upward, color: Colors.white, size: 18)),
                  title: Text('Saiu'),
                  subtitle: Text('Pix enviado para Pagar Me Pagamentos'),
                  trailing: Text('R\$ 5,50', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widgets Auxiliares
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _PixSubAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PixSubAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final Color bannerColor;
  final String title;
  final String description;

  const _TipCard({
    required this.bannerColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: bannerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEE140),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'C6',
                          style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.upload, size: 16, color: Color(0xFF3EA6FF)),
                    SizedBox(width: 4),
                    Text('Compartilhar', style: TextStyle(color: Color(0xFF3EA6FF), fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}