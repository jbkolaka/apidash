import '../form/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/index.dart';
import '../../theme/theme.dart';
import '../text/index.dart';
import '../enable/index.dart';
import '../inherited_styles/index.dart';

import 'text_field.models.dart';
import 'text_field.styles.dart';
import 'text_field.extensions.dart';

typedef _Styles = CTextfieldStyles;

enum CValidationKind { success, warning, error }

enum CTextfieldKind { success, warning, error, primary }

class CTextField extends StatefulWidget {
  const CTextField({
    Key? key,
    this.enable = true,
    this.validator,
    this.label,
    this.semanticLabel,
    this.hint,
    this.description,
    this.controller,
    this.keyboardType,
    this.focusNode,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.onEditingComplete,
    this.onChanged,
    this.onSubmitted,
    this.obscuringCharacter = '•',
    this.readOnly = false,
    this.showCursor,
    this.hideBorder = false,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.toolbarOptions,
    this.keyboardAppearance,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.inputFormatters,
    this.isRequired = false,
  }) : super(key: key);

  final bool enable;

  final String? label;

  /// Programmatic label for inputs without a visible [label].
  /// Hint text is not a substitute for a label.
  final String? semanticLabel;

  final String? hint;
  final String? description;
  final String obscuringCharacter;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool isRequired;
  final bool obscureText;
  final bool readOnly;
  final bool? showCursor;
  final bool hideBorder;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final TextDirection? textDirection;
  final ToolbarOptions? toolbarOptions;
  final Brightness? keyboardAppearance;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;

  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final CValidationResult? Function(String? value)? validator;

  @override
  CTextFieldState createState() => CTextFieldState();
}

class CTextFieldState extends State<CTextField> {
  late FocusNode _focusNode;

  CWidgetState _state = CWidgetState.enabled;

  bool _isFocused = false;
  late bool _obscureText;

  CFormState? _cform;
  CValidationResult? _validationResult;

  CTextfieldKind _kind = CTextfieldKind.primary;
  String? _value;

  void _focusNodeListener() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  void initState() {
    _obscureText = widget.obscureText;
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
    }

    _focusNode.addListener(_focusNodeListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cform = context.cform;
    _cform?.formFields.add(this);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(CTextField oldWidget) {
    if (widget.obscureText != oldWidget.obscureText) {
      _obscureText = widget.obscureText;
    }
    if (oldWidget.validator != null && widget.validator == null) {
      _validationResult = null;
      _kind = CTextfieldKind.primary;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _cform?.formFields.remove(this);
    _focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  bool get _isEnabled {
    return context.inheritedEnable ? widget.enable : false;
  }

  Color? get inheritedBackgroundColor {
    return context.styles['textfield-background-color']?[_state];
  }

  void _validate(String? text) {
    _validationResult = widget.validator!(text);
    _kind = _validationResult?.kind.toTextFieldKind ?? CTextfieldKind.primary;
  }

  bool validate() {
    if (_value == null) {
      return widget.isRequired ? false : true;
    }

    if (_validationResult == null ||
        _validationResult?.kind == CValidationKind.success) {
      return true;
    } else {
      return false;
    }
  }

  void _setStateVariables() {
    if (!_isEnabled) {
      _focusNode.unfocus();
      _state = CWidgetState.disabled;
    } else if (_isEnabled && (_isFocused || _validationResult != null)) {
      _state = CWidgetState.focused;
    } else {
      _state = CWidgetState.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = _isEnabled;
    final tokens = context.tokens;

    _setStateVariables();

    final inputBorder = widget.hideBorder
        ? InputBorder.none
        : _Styles.border(tokens, _kind, _state);
    final message = _validationResult?.message ?? widget.description;
    final semanticLabel = [
      widget.semanticLabel ?? widget.label,
      if (widget.isRequired) 'required',
    ].where((part) => part != null && part.isNotEmpty).join(', ');
    final isError = _validationResult?.kind == CValidationKind.error;

    return IgnorePointer(
      ignoring: !isEnabled,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.label != null) ...[
            ExcludeSemantics(
              child: CText(
                data: widget.label!,
                isRequired: widget.isRequired,
                style: TextStyle(
                  fontSize: _Styles.labelFontSize,
                  fontFamily: _Styles.labelFontFamily,
                  color: _Styles.labelColor(tokens, _state),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            height: 40,
            child: Semantics(
              label: semanticLabel.isEmpty ? null : semanticLabel,
              hint: message,
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                textCapitalization: widget.textCapitalization,
                textAlignVertical: TextAlignVertical.center,
                textDirection: widget.textDirection,
                readOnly: widget.readOnly,
                toolbarOptions: widget.toolbarOptions,
                showCursor: widget.showCursor,
                autofocus: widget.autofocus,
                obscuringCharacter: widget.obscuringCharacter,
                obscureText: _obscureText,
                autocorrect: widget.autocorrect,
                enableSuggestions: widget.enableSuggestions,
                onChanged: (value) {
                  setState(() {
                    _value = value;

                    if (widget.validator != null) _validate(value);
                  });

                  widget.onChanged?.call(value);
                },
                onEditingComplete: widget.onEditingComplete,
                onSubmitted: widget.onSubmitted,
                inputFormatters: widget.inputFormatters,
                cursorColor: _Styles.cursorColor(tokens),
                keyboardAppearance: widget.keyboardAppearance,
                onTap: widget.onTap,
                scrollController: widget.scrollController,
                scrollPhysics: widget.scrollPhysics,
                autofillHints: widget.autofillHints,
                style: TextStyle(
                  fontSize: _Styles.textFontSize,
                  fontFamily: _Styles.textFontFamily,
                  color: _Styles.textColor(tokens, _state),
                ),
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: widget.hideBorder
                      ? const EdgeInsets.only(left: 14, right: 14, bottom: 12)
                      : EdgeInsets.only(
                          left: 14,
                          top: 8,
                          bottom: isEnabled && _isFocused ? 12.5 : 15,
                        ),
                  fillColor:
                      inheritedBackgroundColor ??
                      _Styles.backgroundColor(tokens, _state),
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontSize: _Styles.hintFontSize,
                    fontFamily: _Styles.hintFontFamily,
                    color: _Styles.hintColor(tokens, _state),
                  ),
                  errorText: isError ? _validationResult!.message : null,
                  errorStyle: const TextStyle(
                    height: 0,
                    fontSize: 0,
                    color: Colors.transparent,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 46,
                    maxWidth: 46,
                  ), // 44 + 2 (width of border)
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 46,
                    maxWidth: 46,
                  ), // 44 + 2 (width of border)
                  prefixIcon: (() {
                    if (widget.prefixIcon == null) return null;

                    return IconTheme(
                      data: IconThemeData(
                        color: _Styles.iconColor(tokens, _state),
                      ),
                      child: widget.prefixIcon!,
                    );
                  })(),
                  suffixIcon: (() {
                    final iconColor = _Styles.iconColor(tokens, _state);
                    final validationIcon = _validationResult?.icon;
                    if (validationIcon != null) {
                      return IconTheme(
                        data: IconThemeData(color: iconColor),
                        child: validationIcon,
                      );
                    }
                    if (widget.suffixIcon != null) {
                      return IconTheme(
                        data: IconThemeData(color: iconColor),
                        child: widget.suffixIcon!,
                      );
                    }
                    if (_obscureText || widget.obscureText) {
                      return IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        ),
                        color: iconColor,
                        tooltip: _obscureText
                            ? 'Show password'
                            : 'Hide password',
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      );
                    }
                    return null;
                  })(),
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  disabledBorder: inputBorder,
                ),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            ExcludeSemantics(
              child: CText(
                data: message,
                style: TextStyle(
                  fontSize: _Styles.descriptionFontSize,
                  fontFamily: _Styles.descriptionFontFamily,
                  color: _Styles.descriptionColor(tokens, _kind, _state),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
