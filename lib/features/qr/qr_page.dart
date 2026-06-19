import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  static const double _scanSize = 250;
  static const double _cornerSize = 40;
  static const double _cornerInset = 6;

  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: [BarcodeFormat.qrCode],
  );
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final code = capture.barcodes.first.rawValue;
              if (!_scanned && code != null) {
                setState(() => _scanned = true);
                _controller.stop();
                Navigator.pop(context, code);
              }
            },
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _QrOverlayPainter(
                borderRadius: 20,
                cutOutSize: _scanSize,
                overlayColor: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: _scanSize,
              height: _scanSize,
              child: Stack(
                children: const [
                  Positioned(
                    top: _cornerInset,
                    left: _cornerInset,
                    child: _CornerAsset('assets/images/topLeft.png'),
                  ),
                  Positioned(
                    top: _cornerInset,
                    right: _cornerInset,
                    child: _CornerAsset('assets/images/topRight.png'),
                  ),
                  Positioned(
                    bottom: _cornerInset,
                    left: _cornerInset,
                    child: _CornerAsset('assets/images/bottomLeft.png'),
                  ),
                  Positioned(
                    bottom: _cornerInset,
                    right: _cornerInset,
                    child: _CornerAsset('assets/images/bottomRight.png'),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Text(
              'Поместите QR-код в рамку',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xff777777), size: 25),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerAsset extends StatelessWidget {
  final String asset;
  const _CornerAsset(this.asset);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: _QrScannerPageState._cornerSize,
      height: _QrScannerPageState._cornerSize,
      fit: BoxFit.contain,
    );
  }
}

class _QrOverlayPainter extends CustomPainter {
  final double borderRadius;
  final double cutOutSize;
  final Color overlayColor;

  _QrOverlayPainter({
    required this.borderRadius,
    required this.cutOutSize,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = overlayColor;

    final fullRect = Offset.zero & size;
    final cutOutRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: cutOutSize,
      height: cutOutSize,
    );

    final cutOutRRect = RRect.fromRectAndRadius(
      cutOutRect,
      Radius.circular(borderRadius),
    );

    final overlayPath = Path()
      ..addRect(fullRect)
      ..addRRect(cutOutRRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(overlayPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant _QrOverlayPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.cutOutSize != cutOutSize ||
        oldDelegate.overlayColor != overlayColor;
  }
}
