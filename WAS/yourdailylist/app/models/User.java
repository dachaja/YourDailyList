package models;

import javax.persistence.*;
import play.db.jpa.*;

@Entity
public class User{
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	public int userId;
	public String email;
	@GeneratedValue(generator="")
	public String password;
	public String facebookAuth;
	
	public User(String email, String facebookAuth) {
		this.email = email;
		this.facebookAuth = facebookAuth;
	}

}
