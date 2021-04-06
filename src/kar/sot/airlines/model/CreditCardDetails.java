package kar.sot.airlines.model;

public class CreditCardDetails {
	
	private String ticketId;
	private String ccdId;
	private String userId;
	private String cardType;
	private String cardNumber;
	private String cardHolderName;
	private String cvc;
	
	public CreditCardDetails(String ticketId,String ccdId,String userId,String cardType, String cardNumber, String cardHolderName, String cvc) {
		this.ticketId = ticketId;
		this.ccdId = ccdId;
		this.userId = userId;
		this.cardType = cardType;
		this.cardNumber = cardNumber;
		this.cardHolderName = cardHolderName;
		this.cvc = cvc;
	}
	
	public String getCCDID() {
		return this.ccdId;
	}
	
	public String getTicketId() {
		return this.ticketId;
	}
	
	public String getUserId() {
		return this.userId;
	}
	
	public String getCardType() {
		return this.cardType;
	}
	
	public String getCardNumber() {
		return this.cardNumber;
	}
	
	public String getCardHolderName() {
		return this.cardHolderName;
	}
	
	public String getCVC() {
		return this.cvc;
	}
	
	public void setCCDID(String ccdId) {
		this.ccdId = ccdId;
	}
	
	public void setTicketId(String ticketId) {
		this.ticketId = ticketId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public void setCardType(String cardType) {
		this.cardType = cardType;
	}
	
	public void setCardNumber(String cardNumber) {
		this.cardNumber = cardNumber;
	}
	
	public void setCardHolderName(String cardHolderName) {
		this.cardHolderName = cardHolderName;
	}
	
	public void setCVC(String cvc) {
		this.cvc = cvc;
	}
}
