import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class GenericSelectionBottomSheet<T> extends StatelessWidget {
  const GenericSelectionBottomSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.labelBuilder,
    this.iconBuilder,
    super.key,
  });

  final String title;
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  
  /// Hàm lấy text hiển thị từ item option
  final String Function(T) labelBuilder;
  
  /// Hàm lấy icon hiển thị từ item option (optional)
  final IconData? Function(T)? iconBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            title,
            style: PoppinsTextStyles.display16Medium,
          ),
          SizedBox(height: 16.h),
          
          // List Options
          ...options.map((option) {
            final isSelected = option == selectedValue;
            final iconData = iconBuilder?.call(option);

            return ListTile(
              onTap: () {
                onChanged(option);
                Navigator.pop(context);
              },
              leading: iconData != null 
                  ? Icon(
                      iconData,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    )
                  : null,
              title: Text(
                labelBuilder(option),
                style: PoppinsTextStyles.display16Medium.copyWith(
                  color: isSelected ? Theme.of(context).primaryColor : null,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
            );
          }),
          
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
