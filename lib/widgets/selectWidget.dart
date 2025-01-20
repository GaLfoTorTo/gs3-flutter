import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SelectWidget extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selected;
  final Function onChanged;
  
  const SelectWidget({
    super.key, 
    required this.label,
    this.selected, 
    required this.options, 
    required this.onChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownSearch<String>(
        items: (filter, infiniteScrollProps) => options,
        selectedItem: selected ?? "Selecione",
        onChanged: (value) => onChanged(value),
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              errorMaxLines: 3,
              hintText: label,
              errorStyle: const TextStyle(
                fontStyle: FontStyle.normal
              ),
              floatingLabelStyle: const TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold
              ),
              labelStyle: const TextStyle(
                color: Colors.grey,
              ),
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
          /* dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: Theme.of(context).brightness == Brightness.light
              ? AppStyle.lightDropdownMenuTheme.copyWith(
                labelText: label,
              )
              : AppStyle.darkDropdownMenuTheme.copyWith(
                labelText: label,
              )
          ), */
        ),
      ),
    );
  }
}