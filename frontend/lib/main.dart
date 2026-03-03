import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'services/api_client.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaTrack 游跡',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String _role = 'swimmer';

  @override
  void initState() {
    super.initState();
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    if (token == null || token.isEmpty) return;

    final dio = ref.read(apiClientProvider);
    try {
      final response = await dio.get('/auth/me');
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(userData: response.data as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      await storage.delete(key: 'access_token');
    }
  }

  Future<void> _submit() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final dio = ref.read(apiClientProvider);

    try {
      if (_isLogin) {
        final response = await dio.post('/auth/login', data: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        });

        final token = response.data['access_token'] as String?;
        if (token == null || token.isEmpty) {
          throw Exception('無效的登入回應');
        }

        await const FlutterSecureStorage().write(key: 'access_token', value: token);

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(userData: response.data['user'] as Map<String, dynamic>? ?? {}),
          ),
        );
      } else {
        await dio.post('/auth/register', data: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'fullName': _fullNameController.text.trim(),
          'role': _role,
        });

        if (!mounted) return;
        setState(() => _isLogin = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('註冊成功，請登入')),
        );
      }
    } catch (e) {
      String message = '發生錯誤，請稍後再試';
      if (e is DioException) {
        message = e.response?.data?['message']?.toString() ?? e.message ?? message;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AquaTrack',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '教練與學員追蹤平台',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                if (!_isLogin)
                  TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: '姓名'),
                  ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: '密碼'),
                  obscureText: true,
                ),
                if (!_isLogin) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _role,
                    items: const [
                      DropdownMenuItem(value: 'swimmer', child: Text('學員')),
                      DropdownMenuItem(value: 'coach', child: Text('教練')),
                    ],
                    onChanged: (val) => setState(() => _role = val ?? 'swimmer'),
                    decoration: const InputDecoration(labelText: '身分'),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isLogin ? '登入' : '註冊'),
                ),
                TextButton(
                  onPressed: _isLoading ? null : () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? '沒有帳號？註冊' : '已有帳號？登入'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  Future<void> _logout(BuildContext context) async {
    await const FlutterSecureStorage().delete(key: 'access_token');
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = userData['name']?.toString() ?? '使用者';
    final role = userData['role']?.toString() ?? 'swimmer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('AquaTrack 游跡'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: '登出',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pool, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              Text('歡迎回來，$name', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('角色：$role', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              const Text('登入成功！接下來可串接 Dashboard / 訓練紀錄 / 團隊功能。'),
            ],
          ),
        ),
      ),
    );
  }
}
