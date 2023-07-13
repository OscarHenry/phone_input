import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:phone_input/custom_phone_form_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  FormBuilderState? get formState => _formKey.currentState;

  FocusNode phoneFocus = FocusNode(debugLabel: 'phone');
  FocusNode mobilePhoneFocus = FocusNode(debugLabel: 'mobile_phone');

  bool get formIsValid =>
      formState?.fields.values.every((element) => element.isValid) ?? false;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return GestureDetector(
      onTap: node.unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PhoneInput'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FormBuilder(
            key: _formKey,
            onChanged: onFormChanged,
            child: Column(
              children: [
                Text('${formState?.instantValue}'),
                const SizedBox(height: 24),
                CustomPhoneFormField(
                  name: 'phone',
                  initialValue: '+15547910092',
                  labelText: 'Phone',
                  required: true,
                  focusNode: phoneFocus,
                  // onSubmitted: (_) => node.nextFocus(),
                ),
                const SizedBox(height: 24),
                CustomPhoneFormField(
                  name: 'mobile_phone',
                  // initialValue: '+520000000000',
                  labelText: 'Mobile Phone',
                  focusNode: mobilePhoneFocus,
                  // onSubmitted: (_) => node.nextFocus(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          margin: const EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
              ElevatedButton(
                onPressed: formIsValid ? submit : null,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onFormChanged() {
    if (mounted) {
      setState(() {
        formState?.save();
      });
    }
  }

  Future<void> submit() async {}
}
