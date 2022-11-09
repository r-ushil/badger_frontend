class LoginViewModel {
  LoginViewModel();

  String getUnderlined(String text) {
    List<String> words = text.trim().split(" ");
    String lastWord = words[words.length - 1];

    if (lastWord.endsWith("?")) {
      return "";
    }

    return lastWord;
  }

  String getMainText(String text) {
    String trim = text.trim();
    List<String> words = trim.split(" ");

    String lastWord = words[words.length - 1];
    if (lastWord.endsWith("?")) {
      return text;
    }

    return trim.replaceAll(lastWord, "");
  }
}
