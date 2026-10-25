import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../config/constants.dart';
import 'role_selection_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = roleCitizen;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final List<Map<String, dynamic>> _roles = [
    {'id': roleCitizen, 'name': 'Citizen', 'icon': Icons.person_rounded, 'color': AppTheme.primary},
    {'id': roleEngineer, 'name': 'Field Engineer', 'icon': Icons.engineering_rounded, 'color': AppTheme.success},
    {'id': roleAdmin, 'name': 'Government Admin', 'icon': Icons.admin_panel_settings_rounded, 'color': AppTheme.danger},
  ];

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    
    // For demo purposes, any login works.
    // Real implementation would validate credentials here.
    final state = context.read<AppState>();
    await state.setRole(_selectedRole);
    
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  void _handleSkip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppTheme.primary.withValues(alpha: 0.15), Colors.transparent],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(color: Theme.of(context).dividerColor),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                          child: Icon(Icons.psychology_rounded, size: 64, color: Colors.white),
                        ),
                      ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                    ),
                    SizedBox(height: 24),
                    
                    // Welcome Text
                    Text(
                      'Welcome to RoadSense',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      'Sign in to access your portal',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 14),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                    
                    SizedBox(height: 32),

                    // Role Selector
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Column(
                        children: _roles.map((role) {
                          final isSelected = _selectedRole == role['id'];
                          return GestureDetector(
                            onTap: () => setState(() => _selectedRole = role['id']),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? role['color'].withValues(alpha: 0.15) : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? role['color'].withValues(alpha: 0.5) : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(role['icon'], color: isSelected ? role['color'] : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), size: 20),
                                  SizedBox(width: 12),
                                  Text(
                                    role['name'],
                                    style: TextStyle(
                                      color: isSelected ? role['color'] : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey),
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isSelected)
                                    Icon(Icons.check_circle_rounded, color: role['color'], size: 18),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

                    SizedBox(height: 24),

                    // Email Field
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email or Phone Number',
                        hintStyle: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey)),
                        prefixIcon: Icon(Icons.email_outlined, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey)),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                    
                    SizedBox(height: 16),
                    
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey)),
                        prefixIcon: Icon(Icons.lock_outline_rounded, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey),
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                    
                    SizedBox(height: 12),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms),
                    
                    SizedBox(height: 24),
                    
                    // Login Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
                    
                    SizedBox(height: 16),
                    
                    // Skip Button
                    OutlinedButton(
                      onPressed: _handleSkip,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Theme.of(context).dividerColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Skip for now', style: TextStyle(color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey), size: 18),
                        ],
                      ),
                    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
