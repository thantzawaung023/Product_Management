extension FormattedMessage on Exception {
  String get getMessage {
    final message = toString();
    
    if (message.contains(']')) {
      return message.split(']').last.trim();
    } 
    
    if (message.startsWith("Exception: ")) {
      return message.substring(11);
    }
    
    return message;
  }
}
