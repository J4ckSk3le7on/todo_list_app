import 'package:flutter/material.dart';

class CustomCheck extends StatefulWidget {
  final bool value;
  final void Function(bool value) onChanged;
  
  const CustomCheck({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomCheck> createState() => _CustomCheckState();
}

class _CustomCheckState extends State<CustomCheck> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text("Completed:",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Checkbox.adaptive(
          value: widget.value,
          onChanged: (value) => widget.onChanged(value!),
        )
      ],
    );
  }

}
