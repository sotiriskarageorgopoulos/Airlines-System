package kar.sot.airlines.security;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;


public class Cryptography {
	
	public  static String encrypt(String text) throws NoSuchAlgorithmException,
	NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException
	{ 
		String key = "BLSLXMMMMlai2%&*";
		Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, aesKey);
		byte[] encrypted = cipher.doFinal(text.getBytes());
		Base64.Encoder encoder = Base64.getEncoder();
		String encryptedString = encoder.encodeToString(encrypted);
		return encryptedString;
	}
	
	public static String decrypt(String encryptedString) throws NoSuchAlgorithmException,
	NoSuchPaddingException,InvalidKeyException, IllegalBlockSizeException, BadPaddingException {   
		String key = "BLSLXMMMMlai2%&*";
		Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, aesKey);
		Base64.Decoder decoder = Base64.getDecoder();
		cipher.init(Cipher.DECRYPT_MODE, aesKey);
		String decrypted = new String(cipher.doFinal(decoder.decode(encryptedString)));
		return decrypted;
	}
}
