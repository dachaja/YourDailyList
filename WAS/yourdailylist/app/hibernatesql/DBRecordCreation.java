package hibernatesql;

import models.User;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import play.Logger;

public class DBRecordCreation {

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

	private void closeSession() {
		session.clear();
	}
}
