package hibernatesql;

import models.DailyList;
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
	
	public Boolean insertListTitleByUserId(int userId, String title) {
		try {
			List list = new List(userId, title);
			Logger.debug("" + list.userId + userId);
			Logger.debug("" + list.title + title);
			Logger.debug("session.save");
			session.save(list);
			Logger.debug("transaction.commit");
			transaction.commit();
			return true;
		} catch(Exception e) {
			Logger.error(e.getMessage());
			StackTraceElement[] trace = e.getStackTrace();
			   for(int i=0; i < trace.length-1; i++) {
				   Logger.debug(trace[i].getMethodName() +" Called by method ");
				   Logger.debug(trace[trace.length-1].getMethodName() +" in the class " + trace[trace.length-1].getClassName());
			   }
			return false;
		} finally {
			closeSession();
		}
	}
	
	public Boolean insertListTitleByUserId2(int userId, String title) {
		try {
			DailyList list = new DailyList();
			list.userId = userId;
			list.title = title;
			
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
