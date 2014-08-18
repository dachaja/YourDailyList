package controllers;

import hibernatesql.DBRecordCreation;

import java.util.HashMap;
import java.util.Map;

import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;
import play.db.jpa.JPA;

/**
 * Authentication API
 * Purpose: Process Http requests for login/logout.
 * 
 * @author Anna Pettit
 * @version 0.1 08/17/2014
 * 
 */

public class Authentication extends Controller {
	/**
	 *	Create a user to DB.
	 *	@param - n/a
	 *	@throws - n/a
	 *	@return json format 
	 */
	@play.db.jpa.Transactional
	public static Result authTest(String email, String facebookAuth) {

		try{			
			DBRecordCreation dbRecordCreation = new DBRecordCreation();
			dbRecordCreation.insertUser(email, facebookAuth);
			
			Map<String, String> jsonUser = new HashMap<String, String>();
			jsonUser.put("email", email);
			jsonUser.put("facebookAuth", facebookAuth);
			
			Logger.info(email + " " + facebookAuth);
			
			return ok(play.libs.Json.toJson(jsonUser));
		} catch(Exception e) {
			return ok(e.getMessage());
		}		
	}
	
	@play.db.jpa.Transactional
	public static Result auth() {
		Logger.info("auth");
		
		try{
			final Map<String, String[]> values = request().body().asFormUrlEncoded();
			String email = values.get("email")[0];
			String facebookAuth = values.get("facebookAuth")[0];
			
			DBRecordCreation dbRecordCreation = new DBRecordCreation();
			dbRecordCreation.insertUser(email, facebookAuth);
			
			Map<String, String> jsonUser = new HashMap<String, String>();
			jsonUser.put("email", email);
			jsonUser.put("facebookAuth", facebookAuth);
			
			Logger.info(email + " " + facebookAuth);
			
			return ok(play.libs.Json.toJson(jsonUser));
		} catch(Exception e) {
			return ok(e.getMessage());
		}		
	}
	
//	public static Result index() {
//		return ok();
//	}
}
