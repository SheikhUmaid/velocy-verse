import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocyverse/components/base/component.custom_app_bar.dart';
import 'package:velocyverse/providers/user/provider.ride.dart';
import 'package:velocyverse/utils/util.ride_persistor.dart';

class WaitingDriverScreen extends StatefulWidget {
  const WaitingDriverScreen({super.key});

  @override
  State<WaitingDriverScreen> createState() => _WaitingDriverScreenState();
}

class _WaitingDriverScreenState extends State<WaitingDriverScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     duration: const Duration(seconds: 2),
  //     vsync: this,
  //   )..repeat();
  // }

  @override
  void initState() {
    super.initState();

    // Simulate rideId=123, replace with actual
    Future.microtask(() {
      final rideProvider = Provider.of<RideProvider>(context, listen: false);

      // What to do when OTP comes
      rideProvider.onOtpReceived = (otp) {
        rideProvider.otp = otp;
        RidePersistor.save(rideProvider);
        _showOtpDialog(context, otp);
      };
      rideProvider.connectToOtpWs(123);
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen for OTP updates
    final rideProvider = Provider.of<RideProvider>(context);
    if (rideProvider.otp != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOtpDialog(context, rideProvider.otp!);
      });
    }
  }

  void _showOtpDialog(BuildContext context, String otp) async {
    context.goNamed("/riderLiveTracking", extra: otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Waiting for driver'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Map area
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          color: Color(0xFFF0F4F8),
                        ),
                        child: Stack(
                          children: [
                            // Map background
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFE6F3FF),
                                    Color(0xFFF8FAFC),
                                  ],
                                ),
                              ),
                            ),
                            // Map roads
                            CustomPaint(
                              size: Size.infinite,
                              painter: MapPainter(),
                            ),
                            // Route line
                            Positioned.fill(
                              child: CustomPaint(painter: RoutePainter()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom section
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Loading indicator
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _controller.value * 2 * 3.14159,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 3,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.phone,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Waiting for driver...',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'wait for few seconds waiting for driver',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Cancel button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF3F4F6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Cancel Ride',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Custom painter for map background
class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    // Draw road network
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      paint,
    );

    // Green area (park)
    final greenPaint = Paint()..color = const Color(0xFF86EFAC);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.1, size.height * 0.4)
        ..lineTo(size.width * 0.4, size.height * 0.35)
        ..lineTo(size.width * 0.35, size.height * 0.65)
        ..lineTo(size.width * 0.05, size.height * 0.8)
        ..close(),
      greenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for route
class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..lineTo(size.width * 0.5, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height * 0.4);

    canvas.drawPath(path, paint);

    // Start point
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      6,
      Paint()..color = Colors.black,
    );

    // End point
    final endPaint = Paint()..color = Colors.black;
    final endPath = Path()
      ..moveTo(size.width * 0.8 - 6, size.height * 0.4)
      ..lineTo(size.width * 0.8, size.height * 0.4 - 10)
      ..lineTo(size.width * 0.8 + 6, size.height * 0.4)
      ..close();
    canvas.drawPath(endPath, endPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
