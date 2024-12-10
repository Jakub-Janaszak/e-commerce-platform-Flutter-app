import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final Key key; // Klucz szyfrujący
  final IV iv;   // Wektor inicjujący (IV)

  // Konstruktor, który przyjmuje ciągi znaków do utworzenia klucza i wektora IV
  EncryptionService(String keyString, String ivString)
      : key = Key.fromUtf8(keyString.padRight(32).substring(0, 32)), // Klucz AES (32 bajty)
        iv = IV.fromUtf8(ivString.padRight(16).substring(0, 16));    // Wektor IV (16 bajtów)

  // Funkcja szyfrująca tekst jawny
  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc)); // AES w trybie CBC
    final encrypted = encrypter.encrypt(plainText, iv: iv);   // Szyfrowanie tekstu
    return encrypted.base64; // Zwracamy tekst Base64
  }

  // Funkcja deszyfrująca tekst zaszyfrowany w formacie Base64
  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc)); // AES w trybie CBC
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv); // Deszyfrowanie tekstu Base64
    return decrypted; // Zwracamy odszyfrowany tekst
  }
}
