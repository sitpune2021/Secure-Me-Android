import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;

  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.padding,
    this.borderRadius = 16.0,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GlowContainer extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double blurRadius;
  final double spreadRadius;

  const GlowContainer({
    super.key,
    required this.child,
    required this.glowColor,
    this.blurRadius = 20.0,
    this.spreadRadius = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.3),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}

class FuturisticButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;

  const FuturisticButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: GlowContainer(
        glowColor: color,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBackIcon extends StatelessWidget {
  final Color? color;
  final double? size;

  const AppBackIcon({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.adaptive.arrow_back,
      color: color,
      size: size,
    );
  }
}

class SosSlider extends StatefulWidget {
  final VoidCallback onTrigger;
  final String text;
  final Color color;

  const SosSlider({
    super.key,
    required this.onTrigger,
    this.text = "SLIDE TO ACTIVATE SOS",
    this.color = const Color(0xFFFF5252),
  });

  @override
  State<SosSlider> createState() => _SosSliderState();
}

class _SosSliderState extends State<SosSlider> {
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: widget.color.withValues(alpha:0.3), width: 1.5),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.color.withValues(alpha:0.8),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 14,
              ),
            ),
          ),
          Positioned.fill(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 65,
                thumbShape: const SosThumbShape(),
                overlayColor: Colors.transparent,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
              ),
              child: Slider(
                value: _value,
                onChanged: (val) {
                  setState(() => _value = val);
                },
                onChangeEnd: (val) {
                  if (val > 0.9) {
                    widget.onTrigger();
                  }
                  setState(() => _value = 0.0);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SosThumbShape extends SliderComponentShape {
  const SosThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(60, 60);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = const Color(0xFFFF5252)
      ..style = PaintingStyle.fill;

    // Outer glow
    canvas.drawCircle(
      center,
      30,
      Paint()
        ..color = const Color(0xFFFF5252).withValues(alpha:0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Main Circle
    canvas.drawCircle(center, 28, paint);

    // SOS Text on thumb
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'SOS',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }
}

