import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flashx/flashx.dart';

void main() {
  // Optional: configure global defaults before running the app.
  FlashX.configure(
    const FlashXConfig(
      position: FlashPosition.top,
      animation: FlashAnimation.slide,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      duration: Duration(seconds: 4),
      showProgress: true,
    ),
  );

  runApp(const FlashXExampleApp());
}

class FlashXExampleApp extends StatelessWidget {
  const FlashXExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashX Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      // 🔑 Key step: wrap with FlashXWidget.init() builder
      builder: FlashXWidget.init(),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  FlashPosition _position = FlashPosition.top;
  FlashAnimation _animation = FlashAnimation.slide;
  bool _showTitle = true;
  bool _showAction = false;
  bool _blur = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 FlashX Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Settings ──────────────────────────────────────────────────
            const _SectionHeader('Settings'),
            const SizedBox(height: 12),
            _SettingRow(
              label: 'Position',
              child: SegmentedButton<FlashPosition>(
                segments: const [
                  ButtonSegment(value: FlashPosition.top, label: Text('Top')),
                  ButtonSegment(
                      value: FlashPosition.bottom, label: Text('Bottom')),
                  ButtonSegment(
                      value: FlashPosition.center, label: Text('Center')),
                ],
                selected: {_position},
                onSelectionChanged: (s) => setState(() => _position = s.first),
              ),
            ),
            const SizedBox(height: 10),
            _SettingRow(
              label: 'Animation',
              child: DropdownButton<FlashAnimation>(
                value: _animation,
                isExpanded: true,
                items: FlashAnimation.values
                    .map((a) => DropdownMenuItem(
                          value: a,
                          child: Text(a.name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _animation = v!),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Show Title'),
                    value: _showTitle,
                    onChanged: (v) => setState(() => _showTitle = v!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Action Button'),
                    value: _showAction,
                    onChanged: (v) => setState(() => _showAction = v!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Blur'),
                    value: _blur,
                    onChanged: (v) => setState(() => _blur = v!),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // ─── Basic Types ───────────────────────────────────────────────
            const _SectionHeader('Basic Types'),
            const SizedBox(height: 12),
            Row(
              children: [
                _TypeButton(
                  label: 'Success',
                  color: const Color(0xFF22C55E),
                  onTap: () => FlashX.success(
                    'Your changes have been saved.',
                    title: _showTitle ? 'Saved!' : null,
                    options: _buildOptions(FlashType.success),
                  ),
                ),
                const SizedBox(width: 8),
                _TypeButton(
                  label: 'Error',
                  color: const Color(0xFFEF4444),
                  onTap: () => FlashX.error(
                    'Unable to process your request.',
                    title: _showTitle ? 'Payment Failed' : null,
                    options: _buildOptions(FlashType.error),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _TypeButton(
                  label: 'Warning',
                  color: const Color(0xFFF59E0B),
                  onTap: () => FlashX.warning(
                    'Your session expires in 5 minutes.',
                    title: _showTitle ? 'Session Expiring' : null,
                    options: _buildOptions(FlashType.warning),
                  ),
                ),
                const SizedBox(width: 8),
                _TypeButton(
                  label: 'Info',
                  color: const Color(0xFF3B82F6),
                  onTap: () => FlashX.info(
                    'Version 2.0 is available for download.',
                    title: _showTitle ? 'Update Available' : null,
                    options: _buildOptions(FlashType.info),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // ─── Advanced ──────────────────────────────────────────────────
            const _SectionHeader('Advanced Features'),
            const SizedBox(height: 12),

            _DemoButton(
              icon: Icons.hourglass_top_rounded,
              label: 'Loading → Success',
              subtitle: 'Tracks an async operation',
              onTap: () async {
                await FlashX.future(
                  future: Future.delayed(const Duration(seconds: 2)),
                  loading: 'Processing your order...',
                  success: 'Order placed successfully! 🎉',
                  error: 'Order failed. Please try again.',
                );
              },
            ),
            const SizedBox(height: 8),

            _DemoButton(
              icon: Icons.layers_rounded,
              label: 'Queue Multiple',
              subtitle: 'Shows 4 notifications in sequence',
              onTap: () {
                FlashX.info('First notification in queue');
                FlashX.success('Second — success!');
                FlashX.warning('Third — heads up');
                FlashX.error('Fourth — uh oh');
              },
            ),
            const SizedBox(height: 8),

            _DemoButton(
              icon: Icons.priority_high_rounded,
              label: 'Priority Queue',
              subtitle: 'Critical items jump the queue',
              onTap: () {
                FlashX.show(const FlashOptions(
                  type: FlashType.info,
                  message: 'Normal priority #1',
                  priority: FlashPriority.normal,
                ));
                FlashX.show(const FlashOptions(
                  type: FlashType.info,
                  message: 'Normal priority #2',
                  priority: FlashPriority.normal,
                ));
                FlashX.show(const FlashOptions(
                  type: FlashType.error,
                  title: 'Critical Alert',
                  message: 'This jumps to the front!',
                  priority: FlashPriority.critical,
                ));
              },
            ),
            const SizedBox(height: 8),

            _DemoButton(
              icon: Icons.widgets_rounded,
              label: 'Custom Widget',
              subtitle: 'Fully custom notification content',
              onTap: () {
                FlashX.show(FlashOptions(
                  type: FlashType.custom,
                  position: _position,
                  animation: _animation,
                  themeData: const FlashThemeData(
                    backgroundColor: Color(0xFF1E1B4B),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    actionColor: Colors.amberAccent,
                    progressColor: Colors.amber,
                    borderColor: Color(0xFF312E81),
                    borderWidth: 1,
                  ),
                  customWidget: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star_rounded,
                              color: Colors.amber),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Custom Widget!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text('You can render anything here.',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              },
            ),
            const SizedBox(height: 8),

            _DemoButton(
              icon: Icons.gradient_rounded,
              label: 'Gradient Background',
              subtitle: 'Custom gradient theme',
              onTap: () {
                FlashX.show(FlashOptions(
                  type: FlashType.custom,
                  title: 'Premium Feature',
                  message: 'Unlock the full experience.',
                  position: _position,
                  animation: _animation,
                  actionText: 'Upgrade',
                  onAction: () {},
                  themeData: const FlashThemeData(
                    backgroundColor: Colors.transparent,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    actionColor: Colors.amber,
                    progressColor: Colors.amber,
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                    ),
                    elevation: 12,
                    shadowColor: Color(0x807C3AED),
                  ),
                ));
              },
            ),
            const SizedBox(height: 8),

            _DemoButton(
              icon: Icons.deselect_rounded,
              label: 'Persistent + Dismiss All',
              subtitle: 'Manual dismissal',
              onTap: () {
                FlashX.show(const FlashOptions(
                  type: FlashType.info,
                  title: 'Persistent',
                  message: 'This stays until dismissed.',
                  duration: null,
                  showProgress: false,
                  actionText: 'Got it',
                  onAction: null,
                ));
                Future.delayed(const Duration(seconds: 3), FlashX.dismissAll);
              },
            ),
            const SizedBox(height: 8),

            _DemoButton(
              icon: Icons.deselect_outlined,
              label: 'Duplicate Prevention',
              subtitle: 'Same key = shown only once',
              onTap: () {
                for (int i = 0; i < 5; i++) {
                  FlashX.show(const FlashOptions(
                    type: FlashType.warning,
                    message: 'Only one of these shows!',
                    key: 'dedupe_demo',
                  ));
                }
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  FlashOptions _buildOptions(FlashType type) {
    return FlashOptions(
      type: type,
      position: _position,
      animation: _animation,
      actionText: _showAction ? 'Undo' : null,
      onAction: _showAction ? () => FlashX.info('Action tapped!') : null,
      themeData: _blur
          ? FlashThemeData.glassSuccess(
              dark: Theme.of(context).brightness == Brightness.dark)
          : null,
    );
  }
}

// ─── Helper Widgets ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _SettingRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _DemoButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
