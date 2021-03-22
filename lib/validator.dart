class Validator{

  static final Validator _singleton = Validator._internal();

  factory Validator() {
    return _singleton;
  }

  Validator._internal();

  bool isCorrectUrl(String url){
    if(url!=null && url.isNotEmpty){
      if(url.startsWith("http://")||url.startsWith("https://"))
        return true;
    }
    return false;
  }
}