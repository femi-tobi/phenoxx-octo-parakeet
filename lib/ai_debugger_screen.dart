import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phenoxx/models/advanced_features_model.dart';
import 'package:phenoxx/services/advanced_features_service.dart';

class AIDebuggerScreen extends StatefulWidget {
  const AIDebuggerScreen({super.key});

  @override
  State<AIDebuggerScreen> createState() => _AIDebuggerScreenState();
}

class _AIDebuggerScreenState extends State<AIDebuggerScreen> {
  final _codeController = TextEditingController();
  final _errorController = TextEditingController();
  final _debugService = AIDebuggerService();
  
  DebugSession? _session;
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI Code Debugger',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Code input
            TextField(
              controller: _codeController,
              maxLines: 10,
              style: GoogleFonts.sourceCodePro(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Paste your code here',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? const Color(0xFF1A2332) : Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Error message input
            TextField(
              controller: _errorController,
              maxLines: 3,
              style: GoogleFonts.poppins(color: textColor),
              decoration: InputDecoration(
                labelText: 'Error message (optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? const Color(0xFF1A2332) : Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            // Analyze button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: _isAnalyzing 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.psychology, color: Colors.white),
                label: Text(
                  _isAnalyzing ? 'Analyzing...' : 'Analyze with AI',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Suggestions
            if (_session != null) ...[
              const SizedBox(height: 32),
              Text(
                'AI Suggestions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              ..._session!.suggestions.map((sug) => _SuggestionCard(
                    suggestion: sug,
                    isDark: isDark,
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _analyzeCode() async {
    setState(() => _isAnalyzing = true);
    
    final session = await _debugService.analyzeCode(
      userId: 'current_user',
      code: _codeController.text,
      language: 'dart',
      errorMessage: _errorController.text,
    );
    
    setState(() {
      _session = session;
      _isAnalyzing = false;
    });
  }
}

class _SuggestionCard extends StatelessWidget {
  final AISuggestion suggestion;
  final bool isDark;

  const _SuggestionCard({
    required this.suggestion,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor = suggestion.severity == SeverityLevel.error
        ? Colors.red
        : suggestion.severity == SeverityLevel.warning
            ? Colors.orange
            : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2332) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: severityColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  suggestion.issue,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${suggestion.confidence.toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: severityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            suggestion.explanation,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    suggestion.suggestedFix,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 13,
                      color: Colors.green[700],
                    ),
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
