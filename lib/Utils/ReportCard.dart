import 'package:flutter/material.dart';

class ReportCard extends StatefulWidget {
  const ReportCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  static const Color emeraldDark = Color(0xFF046A38);
  static const Color emeraldLight = Color(0xFF2EBB57);

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1 : .55,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: widget.enabled ? widget.onTap : null,
          borderRadius: BorderRadius.circular(18),
          splashColor: ReportCard.emeraldLight.withOpacity(.25),
          highlightColor: ReportCard.emeraldLight.withOpacity(.12),
          onHighlightChanged: (value) {
            setState(() {
              isPressed = value;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: ReportCard.emeraldLight.withOpacity(.15),
                  child: Icon(widget.icon, color: ReportCard.emeraldDark),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.subtitle,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),

                widget.enabled
                    ? AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isPressed
                              ? ReportCard.emeraldDark
                              : ReportCard.emeraldLight.withOpacity(.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: isPressed
                              ? Colors.white
                              : ReportCard.emeraldDark,
                        ),
                      )
                    : Chip(
                        label: const Text("Soon"),
                        backgroundColor: Colors.grey.shade200,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
