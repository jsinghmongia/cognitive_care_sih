import 'package:firebase_core/firebase_core.dart';
import 'backend_service.dart';
import 'firebase_options.dart';
import 'patient_service.dart';
import 'assessment_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  runApp(const CognitiveCareApp());
}

class CognitiveCareApp extends StatelessWidget {
  const CognitiveCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cognitive Care',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const RoleSelectionPage(),
    );
  }
}

// ============================================================
// MODELS
// ============================================================

enum UserRole {
  patient,
  caregiver,
}

class Companion {
  final String name;
  final String emoji;
  final String subtitle;
  final Color color;

  const Companion({
    required this.name,
    required this.emoji,
    required this.subtitle,
    required this.color,
  });
}

// ============================================================
// 1. ROLE SELECTION PAGE
// ============================================================

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0E8FF),
              Color(0xFFF8F7FF),
              Color(0xFFE7FAF3),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 950),
              child: Column(
                children: [
                  Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6C4CE8),
                          Color(0xFF00B894),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.12),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 58,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Cognitive Care',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF172345),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'A friendly companion for a healthier mind',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF687083),
                    ),
                  ),

                  const SizedBox(height: 55),

                  const Text(
                    'How would you like to continue?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF172345),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Choose the account that best describes you',
                    style: TextStyle(
                      color: Color(0xFF687083),
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 35),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 700) {
                        return Column(
                          children: [
                            RoleCard(
                              emoji: '👴🏻',
                              title: 'Patient',
                              description:
                                  'Play brain games, receive reminders and get help from your AI companion.',
                              color: const Color(0xFF6845E8),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const CompanionSelectionPage(
                                      role: UserRole.patient,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            RoleCard(
                              emoji: '👩🏻‍⚕️',
                              title: 'Caregiver',
                              description:
                                  'Monitor patient progress, activities, medication and important alerts.',
                              color: const Color(0xFF00A978),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const CompanionSelectionPage(
                                      role: UserRole.caregiver,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: RoleCard(
                              emoji: '👴🏻',
                              title: 'Patient',
                              description:
                                  'Play brain games, receive reminders and get help from your AI companion.',
                              color: const Color(0xFF6845E8),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const CompanionSelectionPage(
                                      role: UserRole.patient,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            child: RoleCard(
                              emoji: '👩🏻‍⚕️',
                              title: 'Caregiver',
                              description:
                                  'Monitor patient progress, activities, medication and important alerts.',
                              color: const Color(0xFF00A978),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const CompanionSelectionPage(
                                      role: UserRole.caregiver,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.15),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 115,
              width: 115,
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 70),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              title,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF687083),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Continue →',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 2. COMPANION SELECTION
// ============================================================

class CompanionSelectionPage extends StatelessWidget {
  final UserRole role;

  const CompanionSelectionPage({
    super.key,
    required this.role,
  });

  List<Companion> get companions {
    if (role == UserRole.patient) {
      return const [
        Companion(
          name: 'Maya',
          emoji: '🤖',
          subtitle: 'Your friendly AI companion',
          color: Color(0xFF6845E8),
        ),
        Companion(
          name: 'Aarav',
          emoji: '🧑🏻‍⚕️',
          subtitle: 'Your helpful care assistant',
          color: Color(0xFF2385E8),
        ),
        Companion(
          name: 'Luna',
          emoji: '🌿',
          subtitle: 'Your calm wellness guide',
          color: Color(0xFF00A978),
        ),
      ];
    }

    return const [
      Companion(
        name: 'Aarav AI',
        emoji: '🤖',
        subtitle: 'Patient monitoring assistant',
        color: Color(0xFF00A978),
      ),
      Companion(
        name: 'Insight',
        emoji: '📊',
        subtitle: 'Progress and analytics assistant',
        color: Color(0xFF6845E8),
      ),
      Companion(
        name: 'CareBot',
        emoji: '🩺',
        subtitle: 'Healthcare support assistant',
        color: Color(0xFFFF8A00),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                Text(
                  role == UserRole.patient
                      ? 'Choose Your AI Companion'
                      : 'Choose Your AI Assistant',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF172345),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Choose someone who will guide you through Cognitive Care',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF687083),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 45),

                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 22,
                      runSpacing: 22,
                      alignment: WrapAlignment.center,
                      children: companions.map((companion) {
                        return CompanionCard(
                          companion: companion,
                          onTap: () async {
  await BackendService.saveUser(
  role: role == UserRole.patient ? 'patient' : 'caregiver',
  companion: companion.name,
);
                            if (role == UserRole.patient) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PatientDashboard(
                                    companion: companion,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CaregiverDashboard(
                                    companion: companion,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompanionCard extends StatelessWidget {
  final Companion companion;
  final VoidCallback onTap;

  const CompanionCard({
    super.key,
    required this.companion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Ink(
        width: 270,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: companion.color.withOpacity(.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: companion.color.withOpacity(.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 125,
              width: 125,
              decoration: BoxDecoration(
                color: companion.color.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                companion.emoji,
                style: const TextStyle(fontSize: 75),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              companion.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: companion.color,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              companion.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF687083),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Choose ${companion.name}',
              style: TextStyle(
                color: companion.color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PATIENT DASHBOARD
// ============================================================

class PatientDashboard extends StatefulWidget {
  final Companion companion;

  const PatientDashboard({
    super.key,
    required this.companion,
  });

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: widget.companion.color,
        foregroundColor: Colors.white,
        onPressed: () {
          showAssistant(
            context,
            widget.companion,
            UserRole.patient,
          );
        },
        icon: Text(
          widget.companion.emoji,
          style: const TextStyle(fontSize: 25),
        ),
        label: Text('Ask ${widget.companion.name}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildTopBar(
              context,
              companion: widget.companion,
              role: UserRole.patient,
            ),
            Expanded(
              child: selectedIndex == 0
                  ? patientHome()
                  : selectedIndex == 1
                      ? gamesPage()
                      : selectedIndex == 2
                          ? progressPage()
                          : profilePage(context),
            ),
            NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.psychology_outlined),
                  selectedIcon: Icon(Icons.psychology),
                  label: 'Games',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: 'Progress',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget patientHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanionWelcomeCard(
            companion: widget.companion,
            title: 'Good Morning, Arun! 👋',
            message:
                'I am here to help you have a healthy and happy day. What would you like to do?',
            onTalk: () {
              showAssistant(
                context,
                widget.companion,
                UserRole.patient,
              );
            },
          ),

          const SizedBox(height: 25),

          const Text(
            'What would you like to do?',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              ActionCard(
                emoji: '🧠',
                title: 'Brain Games',
                subtitle: 'Train your mind',
                color: const Color(0xFF6845E8),
                onTap: () {
                  setState(() => selectedIndex = 1);
                },
              ),
              ActionCard(
                emoji: '💊',
                title: 'Medicines',
                subtitle: 'Check reminders',
                color: const Color(0xFF2385E8),
                onTap: () {
                  showPatientDialog(
                    context,
                    'Medicine Reminder',
                    'Your next medicine is scheduled for 9:00 AM.',
                  );
                },
              ),
              ActionCard(
                emoji: '💧',
                title: 'Hydration',
                subtitle: 'Track your water',
                color: const Color(0xFF00A978),
                onTap: () {
                  showPatientDialog(
                    context,
                    'Hydration',
                    'You have completed 4 out of 8 glasses today.',
                  );
                },
              ),
              ActionCard(
                emoji: '📅',
                title: 'My Schedule',
                subtitle: 'View today',
                color: const Color(0xFFFF8A00),
                onTap: () {
                  showPatientDialog(
                    context,
                    'Today\'s Schedule',
                    '10:00 AM – Memory Game\n5:00 PM – Evening Walk',
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Today\'s Progress',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFECE6FF),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Row(
              children: [
                Text(
                  '🔥',
                  style: TextStyle(fontSize: 45),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You are doing great!',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF5133C7),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'You have completed 4 of your 6 activities today.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget gamesPage() {
    final games = [
      ['🧠', 'Memory Match', 'Improve your memory'],
      ['🎯', 'Focus Challenge', 'Improve concentration'],
      ['🔷', 'Pattern Match', 'Recognise patterns'],
      ['🍎', 'Object Recall', 'Remember familiar objects'],
    ];

    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        const Text(
          'Brain Games 🧠',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Choose a fun activity with the help of your companion.',
          style: TextStyle(color: Color(0xFF687083)),
        ),
        const SizedBox(height: 20),
        ...games.map(
          (game) => Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Text(
                  game[0],
                  style: const TextStyle(fontSize: 42),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game[1],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        game[2],
                        style: const TextStyle(
                          color: Color(0xFF687083),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showPatientDialog(
                      context,
                      game[1],
                      '${widget.companion.name} will help you start this game.',
                    );
                  },
                  child: const Text('Play'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget progressPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Progress 📈',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: ProgressCard(
                  value: '85%',
                  label: 'Cognitive Score',
                  icon: Icons.psychology,
                  color: const Color(0xFF6845E8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProgressCard(
                  value: '92%',
                  label: 'Accuracy',
                  icon: Icons.check_circle,
                  color: const Color(0xFF00A978),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: ProgressCard(
                  value: '12',
                  label: 'Games Played',
                  icon: Icons.sports_esports,
                  color: const Color(0xFFFF8A00),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProgressCard(
                  value: '7',
                  label: 'Day Streak',
                  icon: Icons.local_fire_department,
                  color: const Color(0xFFE9435A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          CompanionWelcomeCard(
            companion: widget.companion,
            title: 'A message from ${widget.companion.name}',
            message:
                'Your progress is improving. Keep playing small activities every day!',
            onTalk: () {
              showAssistant(
                context,
                widget.companion,
                UserRole.patient,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget profilePage(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const RoleSelectionPage(),
            ),
            (route) => false,
          );
        },
        icon: const Icon(Icons.swap_horiz),
        label: const Text('Switch Account'),
      ),
    );
  }
}

// ============================================================
// CAREGIVER DASHBOARD
// ============================================================

class CaregiverDashboard extends StatefulWidget {
  final Companion companion;

  const CaregiverDashboard({
    super.key,
    required this.companion,
  });

  @override
  State<CaregiverDashboard> createState() =>
      _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: widget.companion.color,
        foregroundColor: Colors.white,
        onPressed: () {
          showAssistant(
            context,
            widget.companion,
            UserRole.caregiver,
          );
        },
        icon: Text(
          widget.companion.emoji,
          style: const TextStyle(fontSize: 25),
        ),
        label: Text('Ask ${widget.companion.name}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildTopBar(
              context,
              companion: widget.companion,
              role: UserRole.caregiver,
            ),
            Expanded(
              child: selectedIndex == 0
                  ? caregiverHome()
                  : selectedIndex == 1
                      ? monitoringPage()
                      : selectedIndex == 2
                          ? alertsPage()
                          : caregiverProfile(context),
            ),
            NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Overview',
                ),
                NavigationDestination(
                  icon: Icon(Icons.monitor_heart_outlined),
                  selectedIcon: Icon(Icons.monitor_heart),
                  label: 'Monitoring',
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications_none),
                  selectedIcon: Icon(Icons.notifications),
                  label: 'Alerts',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget caregiverHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanionWelcomeCard(
            companion: widget.companion,
            title: 'Good Morning! 👋',
            message:
                'Arun has completed 4 of 6 activities today. Here is the latest summary.',
            onTalk: () {
              showAssistant(
                context,
                widget.companion,
                UserRole.caregiver,
              );
            },
          ),

          const SizedBox(height: 25),

          const Text(
            'Patient Overview',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: const [
              DashboardStat(
                emoji: '🧠',
                value: '85%',
                label: 'Cognitive Score',
                color: Color(0xFF6845E8),
              ),
              DashboardStat(
                emoji: '💊',
                value: '100%',
                label: 'Medicine Taken',
                color: Color(0xFF2385E8),
              ),
              DashboardStat(
                emoji: '💧',
                value: '50%',
                label: 'Hydration',
                color: Color(0xFF00A978),
              ),
              DashboardStat(
                emoji: '😊',
                value: 'Happy',
                label: 'Current Mood',
                color: Color(0xFFFF8A00),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'Attention Required',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 15),

          AlertCard(
            emoji: '💧',
            title: 'Hydration needs attention',
            message: 'Only 4 glasses of water recorded today.',
            color: const Color(0xFFE5F3FF),
          ),

          const SizedBox(height: 12),

          AlertCard(
            emoji: '🧠',
            title: 'Activities remaining',
            message: '2 recommended cognitive activities are incomplete.',
            color: const Color(0xFFEDE6FF),
          ),
        ],
      ),
    );
  }

  Widget monitoringPage() {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        const Text(
          'Patient Monitoring',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 25),

        AlertCard(
          emoji: '🧠',
          title: 'Cognitive Performance',
          message: 'Score: 85% • Improved by 12% this week',
          color: const Color(0xFFEDE6FF),
        ),

        const SizedBox(height: 15),

        AlertCard(
          emoji: '🎮',
          title: 'Daily Activities',
          message: '4 out of 6 activities completed today',
          color: const Color(0xFFE5F3FF),
        ),

        const SizedBox(height: 15),

        AlertCard(
          emoji: '💊',
          title: 'Medication Adherence',
          message: 'All scheduled medicines completed',
          color: const Color(0xFFE5FAF1),
        ),

        const SizedBox(height: 15),

        AlertCard(
          emoji: '😊',
          title: 'Mood Trend',
          message: 'Patient reported a positive mood today',
          color: const Color(0xFFFFF2DE),
        ),
      ],
    );
  }

  Widget alertsPage() {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        const Text(
          'Alerts & Reminders 🚨',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 25),

        AlertCard(
          emoji: '💧',
          title: 'Hydration Alert',
          message: 'Hydration level is below the daily target.',
          color: const Color(0xFFE5F3FF),
        ),

        const SizedBox(height: 15),

        AlertCard(
          emoji: '🧠',
          title: 'Activity Reminder',
          message: 'Two cognitive activities remain for today.',
          color: const Color(0xFFEDE6FF),
        ),

        const SizedBox(height: 15),

        AlertCard(
          emoji: '👨🏻‍⚕️',
          title: 'Doctor Appointment',
          message: 'Neurology appointment tomorrow at 10:30 AM.',
          color: const Color(0xFFE5FAF1),
        ),
      ],
    );
  }

  Widget caregiverProfile(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const RoleSelectionPage(),
            ),
            (route) => false,
          );
        },
        icon: const Icon(Icons.swap_horiz),
        label: const Text('Switch Account'),
      ),
    );
  }
}

// ============================================================
// AI ASSISTANT
// ============================================================

void showAssistant(
  BuildContext context,
  Companion companion,
  UserRole role,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return AssistantSheet(
        companion: companion,
        role: role,
      );
    },
  );
}

class AssistantSheet extends StatefulWidget {
  final Companion companion;
  final UserRole role;

  const AssistantSheet({
    super.key,
    required this.companion,
    required this.role,
  });

  @override
  State<AssistantSheet> createState() => _AssistantSheetState();
}

class _AssistantSheetState extends State<AssistantSheet> {
  String message = '';

  String get defaultMessage {
    if (widget.role == UserRole.patient) {
      return 'Hello! 😊 I am ${widget.companion.name}. How can I help you today?';
    }

    return 'Hello! I am ${widget.companion.name}. I can help you understand your patient\'s progress.';
  }

  void changeMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: widget.companion.color.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.companion.emoji,
                  style: const TextStyle(fontSize: 35),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.companion.name,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'AI Companion • Online',
                      style: TextStyle(
                        color: Color(0xFF00A978),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.companion.color.withOpacity(.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.isEmpty ? defaultMessage : message,
              style: const TextStyle(
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 22),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.role == UserRole.patient
                  ? 'Quick actions'
                  : 'Ask about the patient',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView(
              children: widget.role == UserRole.patient
                  ? [
                      AssistantOption(
                        emoji: '🧠',
                        text: 'Start a brain game',
                        onTap: () {
                          changeMessage(
                            'Great choice! 🧠 Let us play a short memory game together.',
                          );
                        },
                      ),
                      AssistantOption(
                        emoji: '💊',
                        text: 'Check my medicines',
                        onTap: () {
                          changeMessage(
                            '💊 Your next medicine is scheduled for 9:00 AM.',
                          );
                        },
                      ),
                      AssistantOption(
                        emoji: '💧',
                        text: 'Check hydration',
                        onTap: () {
                          changeMessage(
                            '💧 You have completed 4 out of 8 glasses today. Let us drink some water!',
                          );
                        },
                      ),
                      AssistantOption(
                        emoji: '📅',
                        text: 'What is my schedule?',
                        onTap: () {
                          changeMessage(
                            '📅 Today you have a memory activity at 10:00 AM and an evening walk at 5:00 PM.',
                          );
                        },
                      ),
                      AssistantOption(
                        emoji: '😊',
                        text: 'I want to talk',
                        onTap: () {
                          changeMessage(
                            'Of course. 😊 I am here with you. How are you feeling today?',
                          );
                        },
                      ),
                    ]
                  : [
                      AssistantOption(
                        emoji: '🧠',
                        text: 'Cognitive progress',
                        onTap: () {
                          changeMessage(
                            'Arun has a cognitive score of 85%, which is 12% higher than last week.',
                          );
                        },
                      ),
                      AssistantOption(
                        emoji: '💊',
                        text: 'Medication status',
                        onTap: () {
                          changeMessage(
                            'All scheduled medicines have been marked as completed today.',
                          );
                        },
                      ),
                      AssistantOption(
                        emoji: '💧',
                        text: 'Hydration status',
                        onTap: () {
                          changeMessage(
                            'Hydration requires attention. Only 4 out of 8 glasses have been recorded.',
                          );
                        },
                      ),
                      AssistantOption(
                        emoji: '😊',
                        text: 'Mood summary',
                        onTap: () {
                          changeMessage(
                            'The patient reported a happy mood today with positive activity engagement.',
                          );
                        },
                      ),
                      AssistantOption(
                        emoji: '🚨',
                        text: 'Show important alerts',
                        onTap: () {
                          changeMessage(
                            'Important alerts: hydration is below target and two cognitive activities remain.',
                          );
                        },
                      ),
                    ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.role == UserRole.patient
                        ? 'Tap an option or speak to me...'
                        : 'Ask ${widget.companion.name}...',
                    style: const TextStyle(
                      color: Color(0xFF7A8190),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: widget.companion.color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AssistantOption extends StatelessWidget {
  final String emoji;
  final String text;
  final VoidCallback onTap;

  const AssistantOption({
    super.key,
    required this.emoji,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FB),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE WIDGETS
// ============================================================

Widget buildTopBar(
  BuildContext context, {
  required Companion companion,
  required UserRole role,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 25,
      vertical: 14,
    ),
    color: Colors.white,
    child: Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: companion.color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.psychology,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cognitive Care',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Color(0xFF172345),
              ),
            ),
            Text(
              'Your AI-powered care companion',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF687083),
              ),
            ),
          ],
        ),
        const Spacer(),
        CircleAvatar(
          backgroundColor: companion.color.withOpacity(.12),
          child: Text(companion.emoji),
        ),
      ],
    ),
  );
}

class CompanionWelcomeCard extends StatelessWidget {
  final Companion companion;
  final String title;
  final String message;
  final VoidCallback onTalk;

  const CompanionWelcomeCard({
    super.key,
    required this.companion,
    required this.title,
    required this.message,
    required this.onTalk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            companion.color.withOpacity(.15),
            companion.color.withOpacity(.05),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            height: 105,
            width: 105,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: companion.color.withOpacity(.15),
                  blurRadius: 15,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              companion.emoji,
              style: const TextStyle(fontSize: 65),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF596174),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: onTalk,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: companion.color,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.mic),
                  label: Text('Talk to ${companion.name}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        width: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 38),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const ProgressCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF687083),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const DashboardStat({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.08),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 35),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF687083),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String message;
  final Color color;

  const AlertCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF596174),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showPatientDialog(
  BuildContext context,
  String title,
  String message,
) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Okay'),
          ),
        ],
      );
    },
  );
}