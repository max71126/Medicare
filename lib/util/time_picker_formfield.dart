import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/services.dart' show TextInputFormatter;

DateFormat toDateFormat(TimeOfDayFormat format) {
  switch (format) {
    case TimeOfDayFormat.a_space_h_colon_mm:
      return DateFormat('a h:mm');
    case TimeOfDayFormat.frenchCanadian:
      return DateFormat("HH 'h' mm");
    case TimeOfDayFormat.H_colon_mm:
      return DateFormat('H:mm');
    case TimeOfDayFormat.h_colon_mm_space_a:
      return DateFormat('h:mm a');
    case TimeOfDayFormat.HH_colon_mm:
      return DateFormat('HH:mm');
    case TimeOfDayFormat.HH_dot_mm:
      return DateFormat('HH.mm');
  }
  return null;
}

/// Deprecated. Use [DateTimePickerFormField] with `type = PickerType.time`
/// instead.
/// A [FormField<TimeOfDay>] that uses a [TextField] to manage input.
/// If it gains focus while empty, the time picker will be shown to the user.
@deprecated
class TimePickerFormField extends FormField<TimeOfDay> {
  /// For representing the time as a string e.g.
  /// `DateFormat("h:mma")` (9:24pm). You can also use the helper function
  /// [toDateFormat(TimeOfDayFormat)].
  final DateFormat format;

  /// If defined the TextField [decoration]'s [suffixIcon] will be
  /// overridden to reset the input using the icon defined here.
  /// Set this to `null` to stop that behavior. Defaults to [Icons.close].
  final IconData resetIcon;

  /// Allow manual editing of the date/time. Defaults to true. If false, the
  /// picker(s) will be shown every time the field gains focus.
  final bool editable;

  /// For validating the [TimeOfDay]. The value passed will be `null` if
  /// [format] fails to parse the text.
  final FormFieldValidator<TimeOfDay> validator;

  /// Called when an enclosing form is saved. The value passed will be `null`
  /// if [format] fails to parse the text.
  final FormFieldSetter<TimeOfDay> onSaved;

  /// Called when an enclosing form is submitted. The value passed will be
  /// `null` if [format] fails to parse the text.
  final ValueChanged<TimeOfDay> onFieldSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;

  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;

  /// The initial value of the text field before user interaction.
  final TimeOfDay initialValue;

  /// The initial time prefilled in the picker dialog when it is shown.
  /// Defaults to noon. Explicitly set this to `null` to use the current time.
  final TimeOfDay initialTime;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;

  /// Called whenever the state's value changes, e.g. after the picker value
  /// has been selected or when the field loses focus. To listen for all text
  /// changes, use the [controller] and [focusNode].
  final ValueChanged<TimeOfDay> onChanged;

  TimePickerFormField({
    Key key,
    @required this.format,
    this.editable: true,
    this.onChanged,
    this.resetIcon: Icons.close,
    this.initialTime: const TimeOfDay(hour: 12, minute: 0),
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
    bool autovalidate: false,

    // TextField properties
    TextEditingController controller,
    FocusNode focusNode,
    this.initialValue,
    this.decoration: const InputDecoration(),
    this.keyboardType: TextInputType.text,
    this.style,
    this.textAlign: TextAlign.start,
    this.autofocus: false,
    this.obscureText: false,
    this.autocorrect: true,
    this.maxLengthEnforced: true,
    this.enabled,
    this.maxLines: 1,
    this.maxLength,
    this.inputFormatters,
  })  : controller = controller ??
            TextEditingController(text: _toString(initialValue, format)),
        focusNode = focusNode ?? FocusNode(),
        super(
            key: key,
            autovalidate: autovalidate,
            validator: validator,
            onSaved: onSaved,
            builder: (FormFieldState<TimeOfDay> field) {
              // final _TimePickerTextFormFieldState state = field;
            });

  @override
  _TimePickerTextFormFieldState createState() =>
      _TimePickerTextFormFieldState(this);
}

class _TimePickerTextFormFieldState extends FormFieldState<TimeOfDay> {
  final TimePickerFormField parent;
  bool showResetIcon = false;
  String _previousValue = '';

  _TimePickerTextFormFieldState(this.parent);

  @override
  void setValue(TimeOfDay value) {
    super.setValue(value);
    if (parent.onChanged != null) parent.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    parent.focusNode.addListener(inputChanged);
    parent.controller.addListener(inputChanged);
  }

  @override
  void dispose() {
    parent.controller.removeListener(inputChanged);
    parent.focusNode.removeListener(inputChanged);
    super.dispose();
  }

  void inputChanged() {
    final bool requiresInput = parent.controller.text.isEmpty &&
        _previousValue.isEmpty &&
        parent.focusNode.hasFocus;

    if (requiresInput) {
      getTimeInput(context, parent.initialTime).then(_setValue);
    } else if (parent.resetIcon != null &&
        parent.controller.text.isEmpty == showResetIcon) {
      setState(() => showResetIcon = !showResetIcon);
      // parent.focusNode.unfocus();
    }
    _previousValue = parent.controller.text;
    if (!parent.focusNode.hasFocus) {
      setValue(_toTime(_previousValue, parent.format));
    } else if (!requiresInput && !parent.editable) {
      getTimeInput(context,
              _toTime(_previousValue, parent.format) ?? parent.initialTime)
          .then(_setValue);
    }
  }

  void _setValue(TimeOfDay time) {
    parent.focusNode.unfocus();
    // When Cancel is tapped, retain the previous value if present.
    if (time == null && _previousValue.isNotEmpty) {
      time = _toTime(_previousValue, parent.format);
    }
    setState(() {
      parent.controller.text = _toString(time, parent.format);
      setValue(time);
    });
  }

  Future<TimeOfDay> getTimeInput(
      BuildContext context, TimeOfDay initialTime) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: parent.controller,
      focusNode: parent.focusNode,
      decoration: parent.resetIcon == null
          ? parent.decoration
          : parent.decoration.copyWith(
              suffixIcon: showResetIcon
                  ? IconButton(
                      icon: Icon(parent.resetIcon),
                      onPressed: () {
                        parent.focusNode.unfocus();
                        _previousValue = '';
                        parent.controller.clear();
                      },
                    )
                  : Container(width: 0.0, height: 0.0),
            ),
      keyboardType: parent.keyboardType,
      style: parent.style,
      textAlign: parent.textAlign,
      autofocus: parent.autofocus,
      obscureText: parent.obscureText,
      autocorrect: parent.autocorrect,
      maxLengthEnforced: parent.maxLengthEnforced,
      maxLines: parent.maxLines,
      maxLength: parent.maxLength,
      inputFormatters: parent.inputFormatters,
      enabled: parent.enabled,
      onFieldSubmitted: (value) {
        if (parent.onFieldSubmitted != null) {
          return parent.onFieldSubmitted(_toTime(value, parent.format));
        }
      },
      validator: (value) {
        if (parent.validator != null) {
          return parent.validator(_toTime(value, parent.format));
        }
      },
      onSaved: (value) {
        if (parent.onSaved != null) {
          return parent.onSaved(_toTime(value, parent.format));
        }
      },
    );
  }
}

String _toString(TimeOfDay time, DateFormat formatter) {
  if (time != null) {
    try {
      return formatter.format(
          DateTime(0).add(Duration(hours: time.hour, minutes: time.minute)));
    } catch (e) {
      debugPrint('Error formatting time: $e');
    }
  }
  return '';
}

TimeOfDay _toTime(String string, DateFormat formatter) {
  if (string != null && string.isNotEmpty) {
    try {
      var date = formatter.parse(string);
      return TimeOfDay(hour: date.hour, minute: date.minute);
    } catch (e) {
      debugPrint('Error parsing time: $e');
    }
  }
  return null;
}
