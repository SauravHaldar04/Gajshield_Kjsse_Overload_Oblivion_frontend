import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../file_analysis/file_analysis_screen.dart';
import 'package:admin/responsive.dart';
import 'dart:math' as math;

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Section
            buildHeroSection(context),

            // Features Section
            buildFeaturesSection(),

            // How It Works Section
            buildHowItWorksSection(),

            // Stats Section
            buildStatsSection(),

            // Footer
            buildFooterSection(),
          ],
        ),
      ),
    );
  }

  Widget buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  bgColor,
                  secondaryColor,
                ],
              ),
            ),
          ),

          // Animated particles
          ...List.generate(20, (index) {
            return Positioned(
              left: (MediaQuery.of(context).size.width / 20) * index,
              top: (MediaQuery.of(context).size.height / 20) * (index % 10),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final value = _animationController.value;
                  final offset = math.sin(value * math.pi * 2 + index);
                  return Transform.translate(
                    offset: Offset(offset * 30, offset * 20),
                    child: Container(
                      width: (index % 5) * 2.0 + 5,
                      height: (index % 5) * 2.0 + 5,
                      decoration: BoxDecoration(
                        color:
                            primaryColor.withOpacity(0.2 + (index % 10) * 0.03),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SecureGuard",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: -0.2, end: 0),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            _scrollController.animateTo(
                              MediaQuery.of(context).size.height,
                              duration: Duration(milliseconds: 800),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text("Features",
                              style: TextStyle(color: Colors.white70)),
                        ),
                        SizedBox(width: defaultPadding),
                        TextButton(
                          onPressed: () {
                            _scrollController.animateTo(
                              MediaQuery.of(context).size.height * 2,
                              duration: Duration(milliseconds: 800),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text("How it works",
                              style: TextStyle(color: Colors.white70)),
                        ),
                        SizedBox(width: defaultPadding),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FileAnalysisScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding / 2,
                            ),
                          ),
                          child: Text("Get Started"),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideY(begin: -0.2, end: 0),
                  ],
                ),
                SizedBox(height: defaultPadding * 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Advanced File",
                            style: GoogleFonts.poppins(
                              fontSize: Responsive.isMobile(context) ? 38 : 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms)
                              .slideX(begin: -0.2),
                          Text(
                            "Security Analysis",
                            style: GoogleFonts.poppins(
                              fontSize: Responsive.isMobile(context) ? 38 : 48,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 200.ms)
                              .slideX(begin: -0.2),
                          SizedBox(height: defaultPadding),
                          Text(
                            "Protect your system with AI-powered malware detection",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 400.ms)
                              .slideX(begin: -0.2),
                          SizedBox(height: defaultPadding * 2),
                          Container(
                            width: 500,
                            child: Text(
                              "Our cutting-edge AI algorithms analyze files for potential threats, providing instant security insights and protection against the latest malware, ransomware, and other cyber threats.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white60,
                                height: 1.5,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 800.ms)
                              .slideX(begin: -0.2),
                          SizedBox(height: defaultPadding * 2),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FileAnalysisScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding * 2,
                                    vertical: defaultPadding,
                                  ),
                                ),
                                child: Text(
                                  "Analyze Now",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 1200.ms)
                                  .slideX(begin: -0.2),
                              SizedBox(width: defaultPadding),
                              TextButton.icon(
                                onPressed: () {
                                  _scrollController.animateTo(
                                    MediaQuery.of(context).size.height * 2,
                                    duration: Duration(milliseconds: 800),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: Icon(Icons.play_circle_outline,
                                    color: Colors.white),
                                label: Text("How it works",
                                    style: TextStyle(color: Colors.white)),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 1400.ms)
                                  .slideX(begin: -0.2),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      _animationController.value * 2 * math.pi,
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: SweepGradient(
                                        colors: [
                                          primaryColor.withOpacity(0.1),
                                          primaryColor.withOpacity(0.3),
                                          primaryColor.withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Icon(
                              Icons.security,
                              size: 120,
                              color: primaryColor,
                            ).animate().fadeIn(duration: 1200.ms).scale(
                                begin: Offset(0.5, 0.5), end: Offset(1, 1)),
                          ],
                        ),
                      ),
                  ],
                ),

                // Arrow down animation
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: defaultPadding * 5),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                      size: 30,
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .fadeIn(duration: 500.ms)
                        .then()
                        .moveY(begin: 0, end: 10, duration: 800.ms)
                        .then()
                        .moveY(begin: 10, end: 0, duration: 800.ms),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeaturesSection() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: defaultPadding * 5, horizontal: defaultPadding * 2),
      width: double.infinity,
      color: secondaryColor,
      child: Column(
        children: [
          Text(
            "Powerful Security Features",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
              .animate(
                key: ValueKey('features-title'),
                delay: 200.ms,
              )
              .fadeIn()
              .slideY(begin: 0.2, end: 0),
          SizedBox(height: defaultPadding),
          Text(
            "Protect your system with our comprehensive security solution",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          )
              .animate(
                key: ValueKey('features-subtitle'),
                delay: 400.ms,
              )
              .fadeIn()
              .slideY(begin: 0.2, end: 0),
          SizedBox(height: defaultPadding * 4),
          Wrap(
            spacing: defaultPadding * 2,
            runSpacing: defaultPadding * 2,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureCard(
                icon: Icons.verified_user,
                title: "Real-time Detection",
                description:
                    "Instantly analyze files for malicious content with advanced AI algorithms",
                delay: 0,
              ),
              _buildFeatureCard(
                icon: Icons.biotech,
                title: "Deep Analysis",
                description:
                    "Multi-layered inspection identifies even the most sophisticated threats",
                delay: 200,
              ),
              _buildFeatureCard(
                icon: Icons.speed,
                title: "Fast Scanning",
                description:
                    "Rapid file analysis with minimal system impact and maximum performance",
                delay: 400,
              ),
              _buildFeatureCard(
                icon: Icons.history,
                title: "Threat History",
                description:
                    "Comprehensive logs of all scanned files and detected threats",
                delay: 600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(defaultPadding * 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 30,
            ),
          ),
          SizedBox(height: defaultPadding),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: defaultPadding / 2),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    )
        .animate(
          key: ValueKey('feature-$title'),
          delay: Duration(milliseconds: 600 + delay),
        )
        .fadeIn()
        .scale(begin: Offset(0.9, 0.9), end: Offset(1, 1));
  }

  Widget buildHowItWorksSection() {
    final steps = [
      {
        'number': '01',
        'title': 'Upload Your File',
        'description': 'Drag and drop any file or select it from your device.'
      },
      {
        'number': '02',
        'title': 'AI Analysis',
        'description':
            'Our AI engine scans the file using multiple detection methods.'
      },
      {
        'number': '03',
        'title': 'Get Results',
        'description':
            'Receive detailed analysis with threat assessment and recommendations.'
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: defaultPadding * 5, horizontal: defaultPadding * 2),
      width: double.infinity,
      color: bgColor,
      child: Column(
        children: [
          Text(
            "How It Works",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
              .animate(
                key: ValueKey('how-title'),
                delay: 200.ms,
              )
              .fadeIn()
              .slideY(begin: 0.2, end: 0),
          SizedBox(height: defaultPadding),
          Text(
            "Simple three-step process to keep your files safe",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          )
              .animate(
                key: ValueKey('how-subtitle'),
                delay: 400.ms,
              )
              .fadeIn()
              .slideY(begin: 0.2, end: 0),
          SizedBox(height: defaultPadding * 4),
          Responsive(
            mobile: Column(
              children: steps
                  .map((step) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: defaultPadding * 2),
                        child: _buildStepCard(
                          number: step['number']!,
                          title: step['title']!,
                          description: step['description']!,
                          delay: steps.indexOf(step) * 200,
                        ),
                      ))
                  .toList(),
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: steps
                  .map((step) => _buildStepCard(
                        number: step['number']!,
                        title: step['title']!,
                        description: step['description']!,
                        delay: steps.indexOf(step) * 200,
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: defaultPadding * 4),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FileAnalysisScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 2,
                vertical: defaultPadding,
              ),
            ),
            child: Text(
              "Start Analyzing",
              style: TextStyle(fontSize: 18),
            ),
          )
              .animate(
                key: ValueKey('start-button'),
                delay: 1000.ms,
              )
              .fadeIn()
              .scale(),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String number,
    required String title,
    required String description,
    required int delay,
  }) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(defaultPadding * 2),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: defaultPadding),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: defaultPadding / 2),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    )
        .animate(
          key: ValueKey('step-$number'),
          delay: Duration(milliseconds: 600 + delay),
        )
        .fadeIn()
        .slideY(begin: 0.2, end: 0);
  }

  Widget buildStatsSection() {
    final stats = [
      {'value': '99.8%', 'label': 'Detection Rate'},
      {'value': '1M+', 'label': 'Files Analyzed'},
      {'value': '5000+', 'label': 'Threats Blocked'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultPadding * 3),
      color: primaryColor.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) {
          final index = stats.indexOf(stat);
          return Column(
            children: [
              AnimatedCounter(
                value: stat['value']!,
                delay: index * 200,
              ),
              SizedBox(height: defaultPadding / 2),
              Text(
                stat['label']!,
                style: TextStyle(color: Colors.white70),
              )
                  .animate(
                    key: ValueKey('stat-label-${stat['label']}'),
                    delay: Duration(milliseconds: 500 + index * 200),
                  )
                  .fadeIn()
                  .slideY(begin: 0.5, end: 0),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildFooterSection() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: defaultPadding * 3, horizontal: defaultPadding * 2),
      color: bgColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SecureGuard",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook_outlined, color: Colors.white70),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.alternate_email, color: Colors.white70),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.work_outline, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: defaultPadding * 2),
          Divider(color: Colors.white24),
          SizedBox(height: defaultPadding),
          Text(
            "© 2024 SecureGuard. All rights reserved. Advanced malware detection system.",
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class AnimatedCounter extends StatelessWidget {
  final String value;
  final int delay;

  const AnimatedCounter({
    Key? key,
    required this.value,
    required this.delay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: GoogleFonts.poppins(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    )
        .animate(
          key: ValueKey('counter-$value'),
          delay: Duration(milliseconds: 300 + delay),
        )
        .fadeIn()
        .slideY(begin: 0.5, end: 0);
  }
}
