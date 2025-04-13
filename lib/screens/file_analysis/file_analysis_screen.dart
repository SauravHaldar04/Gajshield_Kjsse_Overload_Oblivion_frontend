import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'package:admin/responsive.dart';

class FileAnalysisScreen extends StatefulWidget {
  const FileAnalysisScreen({Key? key}) : super(key: key);

  @override
  _FileAnalysisScreenState createState() => _FileAnalysisScreenState();
}

class _FileAnalysisScreenState extends State<FileAnalysisScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnalyzing = false;
  bool _hasResult = false;
  String? _fileName;
  Map<String, dynamic>? _analysisResult;
  bool _isDragEnter = false;
  late AnimationController _animationController;
  final _animatedListKey = GlobalKey<AnimatedListState>();
  final List<Map<String, dynamic>> _details = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.first.name;
        _isAnalyzing = true;
        _hasResult = false;
        _details.clear();
      });

      // TODO: Implement file upload and analysis API call
      // Simulating API call with delayed response
      await Future.delayed(Duration(seconds: 1));

      // Add items to the list with delays for animation
      final analysisDetails = [
        {'type': 'Signature Analysis', 'status': 'Clean'},
        {'type': 'Behavior Analysis', 'status': 'No suspicious activity'},
        {'type': 'Machine Learning Score', 'status': '0.08 (Safe)'},
      ];

      setState(() {
        _isAnalyzing = false;
        _hasResult = true;
        _analysisResult = {
          'threat_level': 'Low',
          'confidence': 0.92,
          'details': analysisDetails,
        };
      });

      // Add items with delay for animation
      for (int i = 0; i < analysisDetails.length; i++) {
        await Future.delayed(Duration(milliseconds: 400));
        setState(() {
          _details.add(analysisDetails[i]);
          if (_animatedListKey.currentState != null) {
            _animatedListKey.currentState!.insertItem(_details.length - 1,
                duration: Duration(milliseconds: 500));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              bgColor,
              secondaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!Responsive.isMobile(context))
                        Expanded(
                          flex: 2,
                          child: _buildLeftPanel(),
                        ),
                      if (!Responsive.isMobile(context))
                        SizedBox(width: defaultPadding),
                      Expanded(
                        flex: Responsive.isMobile(context) ? 4 : 6,
                        child: _buildMainContent(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding * 2,
        vertical: defaultPadding,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "SecureGuard",
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (!Responsive.isMobile(context))
            Text(
              "File Analysis Dashboard",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.home_outlined, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
            tooltip: "Return to Home",
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildLeftPanel() {
    final protectionStats = [
      {
        'title': 'Files Scanned',
        'value': '243',
        'icon': Icons.insert_drive_file_outlined
      },
      {
        'title': 'Threats Detected',
        'value': '12',
        'icon': Icons.warning_amber_outlined
      },
      {
        'title': 'Protection Status',
        'value': 'Active',
        'icon': Icons.shield_outlined
      },
    ];

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Protection Statistics",
            style: Theme.of(context).textTheme.titleLarge,
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0),
          SizedBox(height: defaultPadding),
          Divider(color: Colors.white24),
          SizedBox(height: defaultPadding),
          ...List.generate(
            protectionStats.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: defaultPadding),
              child: _buildStatItem(
                protectionStats[index]['title'] as String,
                protectionStats[index]['value'] as String,
                protectionStats[index]['icon'] as IconData,
                index * 200,
              ),
            ),
          ),
          Expanded(child: Container()),
          if (_hasResult)
            Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: _analysisResult!['threat_level'] == 'Low'
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    _analysisResult!['threat_level'] == 'Low'
                        ? Icons.verified_outlined
                        : Icons.error_outline,
                    color: _analysisResult!['threat_level'] == 'Low'
                        ? Colors.green
                        : Colors.red,
                  ),
                  SizedBox(width: defaultPadding / 2),
                  Expanded(
                    child: Text(
                      _analysisResult!['threat_level'] == 'Low'
                          ? "File is safe to use"
                          : "Threats detected!",
                      style: TextStyle(
                        color: _analysisResult!['threat_level'] == 'Low'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 1000.ms).shake(),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: Offset(0.9, 0.9));
  }

  Widget _buildStatItem(String title, String value, IconData icon, int delay) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(defaultPadding / 2),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        SizedBox(width: defaultPadding / 2),
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    )
        .animate(delay: Duration(milliseconds: 400 + delay))
        .fadeIn()
        .slideX(begin: -0.2, end: 0);
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildUploadSection(),
        SizedBox(height: defaultPadding),
        if (_hasResult && _analysisResult != null)
          Expanded(child: _buildResultsSection()),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Background particles
            if (!_isAnalyzing)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ParticlesPainter(
                        _animationController.value,
                        primaryColor.withOpacity(0.1),
                      ),
                    );
                  },
                ),
              ),

            // Content
            Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      // Would be implemented with proper drag and drop support
                    },
                    onWillAccept: (data) {
                      setState(() => _isDragEnter = true);
                      return true;
                    },
                    onLeave: (data) {
                      setState(() => _isDragEnter = false);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        color: _isDragEnter
                            ? primaryColor
                            : primaryColor.withOpacity(0.5),
                        strokeWidth: 2,
                        dashPattern: [10, 5],
                        child: Container(
                          padding: EdgeInsets.all(defaultPadding * 2),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _isDragEnter
                                ? primaryColor.withOpacity(0.05)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              if (_isAnalyzing)
                                _buildAnalyzingAnimation()
                              else
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 60,
                                  color: primaryColor,
                                )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .scale(delay: 200.ms),
                              SizedBox(height: defaultPadding),
                              Text(
                                _fileName ??
                                    'Drag and drop or click to upload file',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: 400.ms)
                                  .slideY(begin: 0.2, end: 0),
                              SizedBox(height: defaultPadding),
                              if (!_isAnalyzing)
                                ElevatedButton.icon(
                                  icon: Icon(Icons.upload_file),
                                  label: Text('Select File'),
                                  onPressed: _pickFile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 2,
                                      vertical: defaultPadding,
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 600.ms)
                                    .slideY(begin: 0.2, end: 0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (_fileName != null && !_isAnalyzing)
                    Padding(
                      padding: const EdgeInsets.only(top: defaultPadding),
                      child: Row(
                        children: [
                          Icon(Icons.insert_drive_file,
                              color: primaryColor, size: 20),
                          SizedBox(width: defaultPadding / 2),
                          Expanded(
                            child: Text(
                              _fileName!,
                              style: TextStyle(color: Colors.white70),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_hasResult)
                            Chip(
                              label: Text('Analyzed',
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: Offset(0.95, 0.95));
  }

  Widget _buildAnalyzingAnimation() {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Spinning circle
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationController.value * 2 * math.pi,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withOpacity(0.5),
                      width: 3,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
              );
            },
          ),

          // Pulsing circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(seconds: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: 1 - value,
                child: Transform.scale(
                  scale: 0.5 + (value * 0.5),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.3),
                    ),
                  ),
                ),
              );
            },
            onEnd: () {
              if (_isAnalyzing) {
                setState(() {}); // Force rebuild to restart animation
              }
            },
          ),

          Icon(
            Icons.security,
            color: primaryColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _analysisResult!['threat_level'] == 'Low'
                    ? Icons.verified
                    : Icons.warning_amber,
                color: _analysisResult!['threat_level'] == 'Low'
                    ? Colors.green
                    : Colors.orange,
                size: 24,
              ),
              SizedBox(width: defaultPadding / 2),
              Text(
                'Analysis Results',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Spacer(),
              OutlinedButton.icon(
                icon: Icon(Icons.refresh),
                label: Text('Scan Again'),
                onPressed: _pickFile,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: BorderSide(color: Colors.white24),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0),
          SizedBox(height: defaultPadding),

          // Threat gauge
          Container(
            margin: EdgeInsets.symmetric(vertical: defaultPadding),
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white10,
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 800),
                        height: 10,
                        width: MediaQuery.of(context).size.width *
                            (_analysisResult!['confidence'] * 0.8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green,
                              Colors.yellow,
                              Colors.orange,
                              Colors.red,
                            ],
                            stops: [0.0, 0.5, 0.75, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: (MediaQuery.of(context).size.width *
                                (_analysisResult!['confidence'] * 0.8)) -
                            10,
                        top: -15,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _analysisResult!['threat_level'] == 'Low'
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _analysisResult!['threat_level'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: _analysisResult!['threat_level'] == 'Low'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 500.ms)
                          .slideY(begin: -0.5, end: 0),
                    ],
                  ),
                ),
                SizedBox(width: defaultPadding),
                Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Confidence',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '${(_analysisResult!['confidence'] * 100).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.2, end: 0),
              ],
            ),
          ),

          SizedBox(height: defaultPadding),
          Text(
            'Detailed Analysis',
            style: Theme.of(context).textTheme.titleMedium,
          ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.2, end: 0),
          SizedBox(height: defaultPadding / 2),

          // Detailed results
          Expanded(
            child: AnimatedList(
              key: _animatedListKey,
              initialItemCount: _details.length,
              itemBuilder: (context, index, animation) {
                final detail = _details[index];
                return SlideTransition(
                  position: animation.drive(Tween(
                    begin: Offset(1, 0),
                    end: Offset.zero,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: Container(
                      margin: EdgeInsets.only(bottom: defaultPadding / 2),
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                          SizedBox(width: defaultPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detail['type'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  detail['status'],
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale(begin: Offset(0.95, 0.95));
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final random = math.Random(42); // Fixed seed for consistent pattern

  ParticlesPainter(this.animationValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final particleCount = 20;

    for (int i = 0; i < particleCount; i++) {
      final offsetX = size.width * (0.1 + random.nextDouble() * 0.8);
      final offsetY = size.height * (0.1 + random.nextDouble() * 0.8);

      final sinValue = math.sin(animationValue * math.pi * 2 + i);
      final x = offsetX + sinValue * 10;
      final y = offsetY + math.cos(animationValue * math.pi * 2 + i) * 10;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 3 + random.nextDouble() * 3, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}
