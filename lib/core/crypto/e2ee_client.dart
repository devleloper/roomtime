import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class E2EeClient {
  static final _x25519 = X25519();
  static final _aesGcm = AesGcm.with256bits();

  /// Holds the static public key of the server
  static SimplePublicKey? _serverPublicKey;

  /// Ephemeral keypair for session lifecycle
  static SimpleKeyPair? _clientKeyPair;
  static SimplePublicKey? _clientPublicKey;

  /// Cached shared secret derived from Server Public Key + Client Private Key
  static SecretKey? _sharedSecret;

  /// Cached AES-256-GCM key derived via HKDF-SHA256 from the shared secret
  static SecretKey? _aesKey;

  /// Initialize ephemeral keypair
  static Future<void> init() async {
    _clientKeyPair = await _x25519.newKeyPair();
    _clientPublicKey = await _clientKeyPair!.extractPublicKey();
  }

  /// Client public key (Base64)
  static Future<String> getClientPublicKeyBase64() async {
    if (_clientPublicKey == null) await init();
    return base64Encode(_clientPublicKey!.bytes);
  }

  /// Set server public key and derive AES key
  static Future<void> setServerPublicKey(String base64Key) async {
    if (_clientKeyPair == null) await init();

    final serverBytes = base64Decode(base64Key);
    _serverPublicKey = SimplePublicKey(serverBytes, type: KeyPairType.x25519);

    // 1. ECDH: Derive shared secret
    _sharedSecret = await _x25519.sharedSecretKey(
      keyPair: _clientKeyPair!,
      remotePublicKey: _serverPublicKey!,
    );

    // 2. HKDF-SHA256: Derive AES key (32 bytes)
    // Domain separation info MUST match Go server's DeriveAESKey info param
    final hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
    _aesKey = await hkdf.deriveKey(
      secretKey: _sharedSecret!,
      nonce: [], // Nil salt on Go side (acceptable per RFC 5869)
      info: utf8.encode('familycalls-e2ee-v1'), // domain separation
    );
  }

  /// Encrypt JSON payload (returns Base64 ciphertext & nonce)
  static Future<Map<String, String>> encryptPayload(String jsonString) async {
    if (_aesKey == null) {
      throw Exception('E2EE not initialized with server key');
    }

    final plaintext = utf8.encode(jsonString);

    // AES-GCM uses a 12-byte nonce
    final secretBox = await _aesGcm.encrypt(plaintext, secretKey: _aesKey!);

    // Ciphertext includes MAC tag at the end (compatible with Go's cipher.NewGCM().Seal())
    return {
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText + secretBox.mac.bytes),
    };
  }

  /// Decrypt Base64 payload back to JSON string
  static Future<String> decryptPayload(
    String nonceBase64,
    String ciphertextBase64,
  ) async {
    if (_aesKey == null) {
      throw Exception('E2EE not initialized with server key');
    }

    final nonce = base64Decode(nonceBase64);
    final ciphertextWithTag = base64Decode(ciphertextBase64);

    // Extract the 16-byte MAC tag from the end
    if (ciphertextWithTag.length < 16) {
      throw Exception('Ciphertext too short (missing MAC tag)');
    }

    final cipherText = ciphertextWithTag.sublist(
      0,
      ciphertextWithTag.length - 16,
    );
    final mac = Mac(ciphertextWithTag.sublist(ciphertextWithTag.length - 16));

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);

    final plaintext = await _aesGcm.decrypt(secretBox, secretKey: _aesKey!);

    return utf8.decode(plaintext);
  }

  static bool get isInitialized => _aesKey != null;
}
