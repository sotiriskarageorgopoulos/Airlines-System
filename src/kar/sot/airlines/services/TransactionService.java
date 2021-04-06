package kar.sot.airlines.services;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import kar.sot.airlines.db.SQLConnection;
import kar.sot.airlines.model.CreditCardDetails;
import kar.sot.airlines.model.Ticket;
import kar.sot.airlines.security.Cryptography;
import kar.sot.airlines.security.DigitalSignature;

@Path("TransactionService")
public class TransactionService {
	private SQLConnection sqlCon = new SQLConnection();
	
	@POST 
	@Path("/buy_ticket/{flightNumber}/{ticketId}/{userId}/{depId}/{desId}/{seatNumber}/{price}/{cardType}/{cardNumber}/{cardHolderName}/{cvc}")
	@Produces(MediaType.TEXT_PLAIN)
	public String reserveTicket(@PathParam("flightNumber") String flightNumber, @PathParam("ticketId") String ticketId ,@PathParam("userId") String userId, @PathParam("depId") String depId, 
			@PathParam("desId") String desId, @PathParam("seatNumber") int seatNumber, @PathParam("price") double price, @PathParam("cardType") String cardType,
		   @PathParam("cardNumber") String cardNumber, @PathParam("cardHolderName") String cardHolderName, @PathParam("cvc") String cvc) throws SQLException, ClassNotFoundException, 
	InvalidKeyException, NoSuchAlgorithmException, SignatureException, UnsupportedEncodingException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException {
		String digitalSignature = DigitalSignature.createDigitalSignature(userId);
		Ticket t = new Ticket(ticketId,userId,flightNumber,depId,desId,seatNumber,price,digitalSignature);
		
		Connection con = sqlCon.connectToDB();
		PreparedStatement psTicket = con.prepareStatement("INSERT INTO Ticket VALUES(?,?,?,?,?,?,?,?);");
		psTicket.setString(1,t.getTicketId());
		psTicket.setString(2,t.getUserId());
		psTicket.setString(3,t.getFlightNumber());
		psTicket.setString(4,t.getDepartureId());
		psTicket.setString(5,t.getDestinationId());
		psTicket.setInt(6,t.getSeatNumber());
		psTicket.setDouble(7,t.getPrice());
		psTicket.setString(8,t.getDigitalSignature());
		psTicket.executeUpdate(); 
		psTicket.close();
		
		CreditCardDetails c = new CreditCardDetails(t.getTicketId(),UUID.randomUUID().toString(),userId,cardType,cardNumber,cardHolderName,cvc);
		PreparedStatement psCreditCard = con.prepareStatement("INSERT INTO CreditCardDetails VALUES(?,?,?,?,?,?,?)");
		psCreditCard.setString(1, c.getCCDID());
		psCreditCard.setString(2, c.getUserId());
		psCreditCard.setString(3, c.getCardType());
		psCreditCard.setString(4, Cryptography.encrypt(c.getCardNumber()));
		psCreditCard.setString(5, Cryptography.encrypt(c.getCardHolderName()));
		psCreditCard.setString(6, Cryptography.encrypt(c.getCVC()));
		psCreditCard.setString(7, c.getTicketId());
		psCreditCard.executeUpdate();
		psCreditCard.close();
		return "OK";
	}

}
