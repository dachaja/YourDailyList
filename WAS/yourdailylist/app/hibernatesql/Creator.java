package hibernatesql;

import models.List;
import models.User;

import org.hibernate.*;
import org.hibernate.cfg.Configuration;

import play.Logger;

public class Creator {

	private SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
	private Session session = sessionFactory.openSession();
	private Transaction transaction = session.beginTransaction();

	public Boolean insertUser(String email, String facebookAuth) {

		try {
			User user = new User(email, facebookAuth);
			session.save(user);
			transaction.commit();
			
			return true;
		} catch (Exception e) {
			Logger.error(e.getMessage());
			return false;
		} finally {
			closeSession();
		}
	}
	
	public Boolean insertListTitleByUserId(int userId, String title, String mark) {
		try {
			List list = new List(userId, title, mark);
			session.save(list);
			transaction.commit();
			return true;
		} catch(Exception e) {
			Logger.error(e.getMessage());
			return false;
		} finally {
			closeSession();
		}
	}
	
	private void closeSession() {
		session.clear();
	}
}
