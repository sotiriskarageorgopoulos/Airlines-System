package kar.sot.airlines.security;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.SignatureException;
import java.security.PublicKey;

public class DigitalSignature {

	DigitalSignature() {}
	
	//create digital signature with userId
	public static String createDigitalSignature(String userId) throws NoSuchAlgorithmException, 
	InvalidKeyException, SignatureException, UnsupportedEncodingException {
		KeyPairGenerator kpg = KeyPairGenerator.getInstance("DSA");
		kpg.initialize(2048);
		KeyPair kp = kpg.generateKeyPair();
		PrivateKey privateKey = kp.getPrivate();
		Signature sign = Signature.getInstance("SHA256withDSA");
		sign.initSign(privateKey);
		byte[] b = userId.getBytes();
		sign.update(b);
		byte[] signOfBytes = sign.sign();
		return new String(signOfBytes,"UTF-8");
	}
	
	//verify digital signature with userId
	public static boolean verifyDigitalSignature(String userId) throws NoSuchAlgorithmException, 
	InvalidKeyException, SignatureException {
		KeyPairGenerator kpg = KeyPairGenerator.getInstance("DSA");
		kpg.initialize(2048);
		KeyPair kp = kpg.generateKeyPair();
		PrivateKey privateKey = kp.getPrivate();
		PublicKey publicKey = kp.getPublic();
		Signature sign = Signature.getInstance("SHA256withDSA");
		sign.initSign(privateKey);
		byte[] b = userId.getBytes();
		sign.update(b);
		byte[] signOfBytes = sign.sign();
		sign.initVerify(publicKey);
		sign.update(b);
		return sign.verify(signOfBytes);
	}

}
