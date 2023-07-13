import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_input/extension.dart';

class CustomPhoneFormField extends StatefulWidget {
  const CustomPhoneFormField({
    super.key,
    required this.name,
    this.initialValue,
    required this.labelText,
    this.required = false,
    this.enabled = true,
    this.focusNode,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.onSaved,
    this.onReset,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });
  final String name;
  final String? initialValue;
  final String labelText;
  final bool required;
  final bool enabled;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<PhoneNumber?>? onChanged;
  final ValueChanged<PhoneNumber?>? onSaved;
  final VoidCallback? onReset;
  final AutovalidateMode autovalidateMode;
  @override
  State<CustomPhoneFormField> createState() => _CustomPhoneFormFieldState();
}

class _CustomPhoneFormFieldState extends State<CustomPhoneFormField> {
  FormFieldState<PhoneNumber>? state;
  late final PhoneNumber _initialValue;
  late final PhoneController _controller;

  @override
  void initState() {
    widget.focusNode?.addListener(focusListener);
    if (widget.initialValue != null) {
      _initialValue = PhoneNumber.parse(widget.initialValue!);
    } else {
      _initialValue = const PhoneNumber(isoCode: IsoCode.US, nsn: '');
    }
    _controller = PhoneController(_initialValue);
    super.initState();
  }

  void focusListener() => setState(() {});

  @override
  void dispose() {
    widget.focusNode?.removeListener(focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<PhoneNumber>(
      name: widget.name,
      initialValue: _initialValue,
      validator: buildValidator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      onReset: widget.onReset,
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      builder: (FormFieldState<PhoneNumber> state) {
        this.state = state;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: widget.labelText,
                children: [
                  if (widget.required)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: eColor),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicWidth(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fColor,
                      constraints: const BoxConstraints.tightForFinite(
                          height: kMinInteractiveDimension),
                    ),
                    child: DropdownButton<Country>(
                      value: Country(
                          state.value!.isoCode, state.value!.isoCode.name),
                      onChanged: (Country? newValue) {
                        state.didChange(
                          PhoneNumber(
                            isoCode: newValue!.isoCode,
                            nsn: state.value!.nsn,
                          ),
                        );
                        state.save();
                      },
                      items: [IsoCode.US, IsoCode.CA, IsoCode.MX]
                          .map((IsoCode isoCode) {
                        return DropdownMenuItem<Country>(
                          value: Country(isoCode, isoCode.name),
                          child: Text(isoCode.name),
                        );
                      }).toList(),
                      underline: const SizedBox.shrink(),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: PhoneFormField(
                    controller: _controller,
                    shouldFormat: true,
                    focusNode: widget.focusNode,
                    defaultCountry: IsoCode.US,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fColor,
                      helperText: state.value?.helperText,
                      helperStyle: TextStyle(color: helperColor),
                      errorStyle: TextStyle(color: errorColor),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: pColor)),
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: errorBorderColor)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      suffixIcon: _controller.value!.nsn.isNotEmpty
                          ? IconButton(
                              onPressed: _controller.reset,
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                      suffixIconColor: Colors.black,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    isCountryChipPersistent: false,
                    isCountrySelectionEnabled: false,
                    showFlagInInput: false,
                    flagSize: 0,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    countryCodeStyle: const TextStyle(fontSize: 0),
                    enabled: true,
                    autofocus: false,
                    onChanged: (value) => state.didChange(
                      PhoneNumber(
                        isoCode: state.value?.isoCode ??
                            value?.isoCode ??
                            IsoCode.US,
                        nsn: value?.nsn ?? '',
                      ),
                    ),
                    validator: (phoneNumber) =>
                        state.widget.validator!(state.value),
                    onSubmitted: widget.onSubmitted,
                    onEditingComplete: widget.onEditingComplete,
                    onSaved: state.widget.onSaved,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Color get hColor => Colors.blueGrey.shade500;
  Color? get fColor => Colors.grey[200];
  Color get eColor => Colors.red;
  Color get pColor => Colors.blue;

  Color get helperColor {
    Color base = hColor;

    if (widget.focusNode?.hasFocus == true) {
      base = pColor;
    }

    return base;
  }

  Color get errorColor {
    Color base = eColor;

    if (widget.focusNode?.hasFocus == true) {
      base = pColor;
    }

    if (widget.focusNode?.hasFocus == false &&
        state?.isValid == false &&
        state?.value!.nsn.isEmpty == true) {
      base = hColor;
    }

    return base;
  }

  Color get errorBorderColor {
    Color base = eColor;

    if (widget.focusNode?.hasFocus == false &&
        state?.isValid == false &&
        state?.value!.nsn.isEmpty == true) {
      base = hColor;
    }

    return base;
  }

  PhoneNumberInputValidator get buildValidator {
    return PhoneValidator.validMobile(
      errorText: state?.value?.isValidLength() == false
          ? state?.value?.helperText
          : 'Invalid phone number',
      allowEmpty: !widget.required,
    );
  }
}
