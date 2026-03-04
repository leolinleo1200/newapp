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
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        } else {
          message = e.message ?? message;
        }
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

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
    final name = widget.userData['name']?.toString() ?? '使用者';
    final role = widget.userData['role']?.toString() ?? 'swimmer';

    final pages = [
      DashboardTab(name: name, role: role),
      const ResultsTab(),
      const PbTab(),
      TeamTab(role: role),
    ];

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
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '首頁'),
          NavigationDestination(icon: Icon(Icons.timer), label: '成績'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'PB'),
          NavigationDestination(icon: Icon(Icons.groups), label: '團隊'),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key, required this.name, required this.role});

  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Center(
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
            const Text('你可以在下方查看成績、PB 與團隊管理。'),
          ],
        ),
      ),
    );
  }
}

class ResultsTab extends ConsumerStatefulWidget {
  const ResultsTab({super.key});

  @override
  ConsumerState<ResultsTab> createState() => _ResultsTabState();
}

class _ResultsTabState extends ConsumerState<ResultsTab> {
  List<dynamic> results = [];
  bool loading = false;

  final strokeCtrl = TextEditingController(text: 'Freestyle');
  final distanceCtrl = TextEditingController(text: '50');
  final timeMsCtrl = TextEditingController(text: '35000');
  String pool = '25m';

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    setState(() => loading = true);
    try {
      final dio = ref.read(apiClientProvider);
      final res = await dio.get('/results');
      setState(() => results = (res.data as List?) ?? []);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('載入成績失敗')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> addResult() async {
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post('/results', data: {
        'stroke': strokeCtrl.text.trim(),
        'distance': int.tryParse(distanceCtrl.text.trim()) ?? 0,
        'poolLength': pool,
        'timeMs': int.tryParse(timeMsCtrl.text.trim()) ?? 0,
      });
      await fetchResults();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('新增成功')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('新增失敗')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchResults,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('新增成績', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: strokeCtrl, decoration: const InputDecoration(labelText: '泳姿')),
          TextField(controller: distanceCtrl, decoration: const InputDecoration(labelText: '距離(公尺)'), keyboardType: TextInputType.number),
          TextField(controller: timeMsCtrl, decoration: const InputDecoration(labelText: '時間(ms)'), keyboardType: TextInputType.number),
          DropdownButtonFormField<String>(
            value: pool,
            items: const [
              DropdownMenuItem(value: '25m', child: Text('25m')),
              DropdownMenuItem(value: '50m', child: Text('50m')),
            ],
            onChanged: (v) => setState(() => pool = v ?? '25m'),
            decoration: const InputDecoration(labelText: '池長'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: addResult, child: const Text('送出成績')),
          const Divider(height: 24),
          const Text('我的成績', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (loading)
            const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
          else if (results.isEmpty)
            const Text('目前沒有成績')
          else
            ...results.map((r) => Card(
                  child: ListTile(
                    title: Text('${r['stroke']} ${r['distance']}m (${r['poolLength']})'),
                    subtitle: Text('timeMs: ${r['timeMs']}'),
                  ),
                )),
        ],
      ),
    );
  }
}

class PbTab extends ConsumerStatefulWidget {
  const PbTab({super.key});

  @override
  ConsumerState<PbTab> createState() => _PbTabState();
}

class _PbTabState extends ConsumerState<PbTab> {
  List<dynamic> pb = [];
  List<dynamic> bench = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final dio = ref.read(apiClientProvider);
      final p1 = await dio.get('/pb');
      final p2 = await dio.get('/benchmarks');
      setState(() {
        pb = (p1.data as List?) ?? [];
        bench = (p2.data as List?) ?? [];
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('載入 PB/標竿失敗')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('個人最佳 PB', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (loading)
            const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
          else if (pb.isEmpty)
            const Text('尚無 PB 資料')
          else
            ...pb.map((e) => ListTile(
                  title: Text('${e['stroke']} ${e['distance']}m (${e['poolLength']})'),
                  trailing: Text('${e['bestTimeMs']} ms'),
                )),
          const Divider(height: 24),
          const Text('官方標竿', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (bench.isEmpty)
            const Text('尚無標竿資料（可由後端 seed）')
          else
            ...bench.take(20).map((e) => ListTile(
                  title: Text('${e['type']} ${e['stroke']} ${e['distance']}m'),
                  trailing: Text('${e['timeMs']} ms'),
                )),
        ],
      ),
    );
  }
}

class TeamTab extends ConsumerStatefulWidget {
  const TeamTab({super.key, required this.role});

  final String role;

  @override
  ConsumerState<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends ConsumerState<TeamTab> {
  final teamIdCtrl = TextEditingController();
  final teamNameCtrl = TextEditingController();
  final teamDescCtrl = TextEditingController();
  final memberUserIdCtrl = TextEditingController();
  dynamic teamInfo;
  List<dynamic> members = [];
  List<dynamic> pendingMembers = [];
  dynamic selectedUserResults;

  Future<void> createTeam() async {
    try {
      final dio = ref.read(apiClientProvider);
      final res = await dio.post('/teams', data: {
        'name': teamNameCtrl.text.trim(),
        'description': teamDescCtrl.text.trim(),
      });
      teamIdCtrl.text = res.data['teamId'].toString();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('建立隊伍成功')));
      }
      await loadTeam();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('建立隊伍失敗（需教練角色）')));
      }
    }
  }

  Future<void> joinTeam() async {
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post('/teams/${teamIdCtrl.text.trim()}/join');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已送出加入申請')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('加入隊伍失敗')));
      }
    }
  }

  Future<void> loadTeam() async {
    if (teamIdCtrl.text.trim().isEmpty) return;
    try {
      final dio = ref.read(apiClientProvider);
      final res = await dio.get('/teams/${teamIdCtrl.text.trim()}');
      setState(() => teamInfo = res.data);

      if (widget.role == 'coach' || widget.role == 'admin') {
        final m = await dio.get('/teams/${teamIdCtrl.text.trim()}/members');
        final p = await dio.get('/teams/${teamIdCtrl.text.trim()}/pending');
        setState(() {
          members = (m.data as List?) ?? [];
          pendingMembers = (p.data as List?) ?? [];
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('查詢隊伍失敗')));
      }
    }
  }

  Future<void> approveMember(String userId) async {
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post('/teams/${teamIdCtrl.text.trim()}/approve/$userId');
      await loadTeam();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('核准失敗')));
      }
    }
  }

  Future<void> rejectMember(String userId) async {
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post('/teams/${teamIdCtrl.text.trim()}/reject/$userId');
      await loadTeam();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('拒絕失敗')));
      }
    }
  }

  Future<void> loadUserResults() async {
    final uid = memberUserIdCtrl.text.trim();
    if (uid.isEmpty) return;
    try {
      final dio = ref.read(apiClientProvider);
      final res = await dio.get('/users/$uid/results');
      setState(() => selectedUserResults = res.data);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('查詢學員成績失敗')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('團隊', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (widget.role == 'coach' || widget.role == 'admin') ...[
          TextField(controller: teamNameCtrl, decoration: const InputDecoration(labelText: '隊伍名稱')),
          TextField(controller: teamDescCtrl, decoration: const InputDecoration(labelText: '隊伍描述')),
          ElevatedButton(onPressed: createTeam, child: const Text('建立隊伍')),
          const Divider(height: 24),
        ],
        TextField(controller: teamIdCtrl, decoration: const InputDecoration(labelText: '隊伍 ID')),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: ElevatedButton(onPressed: loadTeam, child: const Text('查詢隊伍'))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton(onPressed: joinTeam, child: const Text('申請加入'))),
          ],
        ),
        const SizedBox(height: 12),
        if (teamInfo != null)
          Card(
            child: ListTile(
              title: Text(teamInfo['name']?.toString() ?? '-'),
              subtitle: Text(teamInfo['description']?.toString() ?? ''),
            ),
          ),
        if (pendingMembers.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('待審核申請', style: TextStyle(fontWeight: FontWeight.bold)),
          ...pendingMembers.map((m) => Card(
                child: ListTile(
                  title: Text(m['user']?['name']?.toString() ?? '-'),
                  subtitle: Text(m['user']?['email']?.toString() ?? ''),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        onPressed: () => approveMember(m['userId'].toString()),
                        icon: const Icon(Icons.check, color: Colors.green),
                        tooltip: '核准',
                      ),
                      IconButton(
                        onPressed: () => rejectMember(m['userId'].toString()),
                        icon: const Icon(Icons.close, color: Colors.red),
                        tooltip: '拒絕',
                      ),
                    ],
                  ),
                ),
              )),
        ],
        if (members.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('隊員列表', style: TextStyle(fontWeight: FontWeight.bold)),
          ...members.map((m) => ListTile(
                title: Text(m['user']?['name']?.toString() ?? '-'),
                subtitle: Text(m['user']?['email']?.toString() ?? ''),
              )),
        ],
        if (widget.role == 'coach' || widget.role == 'admin') ...[
          const Divider(height: 24),
          const Text('查詢學員歷史成績', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: memberUserIdCtrl, decoration: const InputDecoration(labelText: '學員 User ID')),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: loadUserResults, child: const Text('查詢學員成績')),
          if (selectedUserResults != null) ...[
            const SizedBox(height: 8),
            Text('學員：${selectedUserResults['user']?['name'] ?? '-'}'),
            ...((selectedUserResults['results'] as List?) ?? []).map((r) => ListTile(
                  dense: true,
                  title: Text('${r['stroke']} ${r['distance']}m (${r['poolLength']})'),
                  trailing: Text('${r['timeMs']} ms'),
                )),
          ],
        ],
      ],
    );
  }
}
