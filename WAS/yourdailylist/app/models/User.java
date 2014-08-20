package models;

import javax.persistence.*;
import play.db.jpa.JPA;

@Entity
public class User{
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	public int userId;
	public String email;
	@GeneratedValue(generator="")
	public String password;
	public String facebookAuth;
	
	public User() {
		
	}
	
	public User(int userId) {
		this.userId = userId;
	}
	
	public User(String email, String facebookAuth) {
		this.email = email;
		this.facebookAuth = facebookAuth;
	}
	
	public static User findByEmail(String email) {
		return JPA.em().find(User.class, email);
	}
}
