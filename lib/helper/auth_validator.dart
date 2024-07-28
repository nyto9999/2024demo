class Validator {
  static String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return '請輸入確認密碼';
    }

    if (password == null || password.isEmpty) {
      return '請輸入密碼';
    }

    if (password != confirmPassword) {
      return '密碼不匹配';
    }
    return null;
  }

  static String? password(String? password) {
    if (password == null || password.isEmpty) {
      return '請輸入密碼';
    }
    if (password.length < 6) {
      return '密碼至少需要6個字符';
    }
    return null;
  }

  static String? email(String? email) {
    if (email == null || email.isEmpty) {
      return '請輸入電子郵件';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return '請輸入有效的電子郵件';
    }
    return null;
  }

  //台灣手機號碼 0968992985

  static String? phoneNo(String? phoneNo) {
    if (phoneNo == null || phoneNo.isEmpty) {
      return '請輸入手機號碼';
    }
    final phoneNoRegex = RegExp(r'^09\d{8}$');
    if (!phoneNoRegex.hasMatch(phoneNo)) {
      return '請輸入台灣區手機號碼 09xxxxxxxx';
    }
    return null;
  }

    static String? quoteAmount(String? quoteAmount, int? preQuote) {
    if (quoteAmount == null || quoteAmount.isEmpty) {
      return '請輸入金額';
    }
    final newQuote = int.tryParse(quoteAmount);
    if (newQuote == null) {
      return '請輸入有效的數字';
    }
    if (newQuote == preQuote) {
      return '新報價不能與之前的報價相同';
    }
    return null;
  }
}
