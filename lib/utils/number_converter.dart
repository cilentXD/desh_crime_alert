class BanglaNumberConverter {
  static const List<String> _banglaNumbers = [
    '০',
    '১',
    '২',
    '৩',
    '৪',
    '৫',
    '৬',
    '৭',
    '৮',
    '৯'
  ];

  static String convertToBangla(String number) {
    String result = '';
    for (int i = 0; i < number.length; i++) {
      if (number[i].contains(RegExp(r'[0-9]'))) {
        result += _banglaNumbers[int.parse(number[i])];
      } else {
        result += number[i];
      }
    }
    return result;
  }

  static String formatDateTime(DateTime dateTime) {
    final day = convertToBangla(dateTime.day.toString().padLeft(2, '0'));
    final month = _getBanglaMonth(dateTime.month);
    final year = convertToBangla(dateTime.year.toString());
    final hour = convertToBangla(dateTime.hour.toString().padLeft(2, '0'));
    final minute = convertToBangla(dateTime.minute.toString().padLeft(2, '0'));

    return '$day $month, $year - $hour:$minute';
  }

  static String _getBanglaMonth(int month) {
    const months = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];
    return months[month - 1];
  }
}
