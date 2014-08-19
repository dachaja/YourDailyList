package hibernatesql;

import java.util.List;

import javax.persistence.Query;

import models.User;
import play.Logger;
import play.db.jpa.JPA;

public class Searcher {
	
	public User getUser(String email) {
		String getUser = "FROM User u WHERE u.email = :email";
		try{	
			Query query = JPA.em().createQuery(getUser);
			query.setParameter("email", email);
			
			List<User> result = query.getResultList();
			Logger.debug("user size" + result.size() + result.toString());
			
			for(User user : result) {
				Logger.debug("user size" + user.email + user.userId + email);
				return user;
			}
			
			return null;
		} catch(Exception e) {
			return null;
		}
	}
}
