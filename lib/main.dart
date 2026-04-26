import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Microsoft data',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}

// --- HALAMAN 1: LOGIN SCREEN ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await Future.delayed(const Duration(seconds: 2));

      // Mock Hardcoded Credential
      if (_emailController.text == "angelina@gmail.com" && _passwordController.text == "Admin123") {
        setState(() => _isLoading = false);
        if (!mounted) return;
        
        // MENGIRIM EMAIL SEBAGAI ARGUMEN
        Navigator.pushReplacementNamed(context, '/dashboard', arguments: _emailController.text);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Email atau Password salah!";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400), 
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 21, height: 21, color: const Color(0xfff25022)),
                            const SizedBox(width: 3),
                            Container(width: 21, height: 21, color: const Color(0xff7fbb00)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 21, height: 21, color: const Color(0xff00a4ef)),
                            const SizedBox(width: 3),
                            Container(width: 21, height: 21, color: const Color(0xffffb900)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text("Sign in", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text("to continue to Microsoft data", style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 30),
                    
                    // VALIDASI EMAIL DENGAN REGEX
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email, phone, or Skype', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                        return null;
                      },
                    ),
                    
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                        child: const Text("Forgot password?", style: TextStyle(color: Color(0xff00a4ef))),
                      ),
                    ),
                    
                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00a4ef),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                          : const Text("Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- HALAMAN 2: LUPA PASSWORD ---
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Masukkan email Anda untuk menerima link reset."),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email wajib diisi';
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link reset dikirim")));
                      }
                    },
                    child: const Text("Kirim Link Reset"),
                  ),
                ),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kembali ke Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- HALAMAN 3: DASHBOARD ---
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // MENANGKAP EMAIL DARI ARGUMEN
    final userEmail = ModalRoute.of(context)!.settings.arguments as String? ?? "User";

    final List<Map<String, String>> items = [
      {"judul": "Data Penjualan", "sub": "Laporan transaksi Januari - Maret 2026."},
      {"judul": "Manajemen Inventaris", "sub": "Stok perangkat keras di gudang pusat."},
      {"judul": "Log Keamanan", "sub": "Catatan akses percobaan login tidak sah."},
      {"judul": "Basis Data Karyawan", "sub": "Update kontrak dan informasi personal."},
      {"judul": "Statistik Server", "sub": "Monitor penggunaan CPU dan RAM berkala."},
      {"judul": "Dokumentasi API", "sub": "Panduan integrasi sistem Microsoft Data."},
      {"judul": "Arsip Laporan Pajak", "sub": "Berkas keuangan untuk audit tahunan."},
      {"judul": "Konfigurasi Jaringan", "sub": "Status koneksi LAN dan WAN kantor pusat."},
      {"judul": "Backup Cloud Otomatis", "sub": "Sinkronisasi data terakhir berhasil."},
      {"judul": "Analitik Pengguna", "sub": "Tren aktivitas user pada dashboard web."},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xff00a4ef),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, 
      ),
      body: Row(
        children: [
          Container(
            width: 200, 
            color: const Color.fromARGB(255, 3, 85, 168), 
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                const SizedBox(height: 10),
                const Text("Angelina", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const Divider(color: Colors.white24, height: 40),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text("Home", style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text("Logout", style: TextStyle(color: Colors.white)),
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginPage()), 
                    (route) => false
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, 
                  color: Colors.blue.shade50, 
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    // DI SINI KATA 'CONST' DIHAPUS KARENA ADA VARIABEL $userEmail
                    child: Text(
                      "Selamat datang, $userEmail", 
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 2, 158, 243),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text("${index + 1}"),
                          ),
                          title: Text(items[index]["judul"]!),
                          subtitle: Text(items[index]["sub"]!),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}//// update commit 3
//update commit 4