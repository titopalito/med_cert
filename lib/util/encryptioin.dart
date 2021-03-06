import 'package:encrypt/encrypt.dart';

class EncryptionUtil {
  Key key;
  IV iv;
  Encrypter? encrypter;

  static EncryptionUtil shared = EncryptionUtil(
      Key.fromUtf8('nm3nHVDkIYzUdRAy3fskMibgsL0tvAfr'), IV.fromLength(16));

  EncryptionUtil(this.key, this.iv) {
    encrypter = Encrypter(AES(key));
  }

  String getDecryptedStringFrom({required String text}) {
    try {
      if (encrypter != null) {
        final encrypter = Encrypter(AES(key, padding: null));
        final decrypted = encrypter.decrypt(Encrypted.fromBase64(text), iv: iv);
        decrypted.trim();
        decrypted.replaceAll('', '');
        decrypted.replaceAll(' ', '');
        return decrypted;
      }
    } catch (e) {
      return "DECRYPTION FAILS";
    }
    return "DECRYPTION UNKNOWN ERROR";
  }

  String getEncryptedStringFrom({required String text}) {
    if (encrypter != null) {
      final encrypted = encrypter!.encrypt(text, iv: iv);
      return encrypted.base64;
    }
    return "";
  }
}
