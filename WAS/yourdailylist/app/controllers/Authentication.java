package controllers;

import hibernatesql.Creator;
import hibernatesql.Searcher;

import java.util.HashMap;
import java.util.Map;

import models.User;
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
	 *	@param - String email, String facebookAuth
	 *	@throws - n/a
	 *	@return json format 
	 */
	
	@play.db.jpa.Transactional
	public static Result auth() {
		Logger.info("auth");
		
		try{
			final Map<String, String[]> values = request().body().asFormUrlEncoded();
			String email = values.get("email")[0];
			String facebookAuth = values.get("facebookAuth")[0];
			
			Searcher searcher = new Searcher();
			User user = searcher.getUser(email);
			
			if(user==null) {
				Creator creator = new Creator();
				creator.insertUser(email, facebookAuth);
				
				user = searcher.getUser(email);
			}
			
			Map<String, String> jsonUser = new HashMap<String, String>();
			jsonUser.put("email", user.email);
			jsonUser.put("facebookAuth", user.facebookAuth);
			jsonUser.put("userId", user.userId + "");
			
			Logger.info(user.email + " " + user.facebookAuth + " " + user.userId);
			
			return ok(play.libs.Json.toJson(jsonUser));
			
//			return ok();
		} catch(Exception e) {
			return ok(e.getMessage());
		}		
	}
	
//	public static Result index() {
//		return ok();
//	}
}
