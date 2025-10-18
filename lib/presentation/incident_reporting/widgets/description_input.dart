import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/app_export.dart';

class DescriptionInput extends StatefulWidget {
  final String? initialText;
  final Function(String) onTextChanged;
  final int maxLength;

  const DescriptionInput({
    super.key,
    this.initialText,
    required this.onTextChanged,
    this.maxLength = 500,
  });

  @override
  State<DescriptionInput> createState() => _DescriptionInputState();
}

class _DescriptionInputState extends State<DescriptionInput> {
  late TextEditingController _controller;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _speechAvailable = false;
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
    _controller.addListener(_onTextChanged);
    _initSpeech();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.onTextChanged(_controller.text);
  }

  Future<void> _initSpeech() async {
    try {
      final hasPermission = await Permission.microphone.request();
      if (hasPermission.isGranted) {
        _speechEnabled = await _speechToText.initialize();
        setState(() {
          _speechAvailable = _speechEnabled;
        });
      }
    } catch (e) {
      setState(() {
        _speechAvailable = false;
      });
    }
  }

  Future<void> _startListening() async {
    if (!_speechAvailable) return;

    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'es_ES',
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );

      setState(() {
        _isListening = true;
      });
    } catch (e) {
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (result.finalResult) {
        final currentText = _controller.text;
        final newText =
            currentText.isEmpty ? _lastWords : '$currentText $_lastWords';

        if (newText.length <= widget.maxLength) {
          _controller.text = newText;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
        _isListening = false;
      }
    });
  }

  Color get _characterCountColor {
    final length = _controller.text.length;
    final percentage = length / widget.maxLength;

    if (percentage >= 1.0) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (percentage >= 0.8) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Descripción del Incidente',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_speechAvailable)
                Container(
                  decoration: BoxDecoration(
                    color: _isListening
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isListening
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _isListening ? _stopListening : _startListening,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isListening
                          ? CustomIconWidget(
                              key: const ValueKey('stop'),
                              iconName: 'stop',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 24,
                            )
                          : CustomIconWidget(
                              key: const ValueKey('mic'),
                              iconName: 'mic',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 24,
                            ),
                    ),
                    tooltip: _isListening
                        ? 'Detener grabación'
                        : 'Grabar descripción',
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _controller.text.length >= widget.maxLength
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 6,
              maxLength: widget.maxLength,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText:
                    'Describe lo que está sucediendo, incluye detalles importantes como la magnitud, personas afectadas, daños visibles...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
                counterText: '',
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_isListening && _lastWords.isNotEmpty)
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Escuchando: "$_lastWords"',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Spacer(),
              Text(
                '${_controller.text.length}/${widget.maxLength}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _characterCountColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (_controller.text.length >= widget.maxLength)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Has alcanzado el límite máximo de caracteres',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
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
