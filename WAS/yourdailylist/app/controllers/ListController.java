package controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import hibernatesql.Creator;
import hibernatesql.Searcher;
import play.Logger;
import play.mvc.*;
import play.db.jpa.JPA;

public class ListController extends Controller{
	
	@play.db.jpa.Transactional
	public static Result readAllList(int userId) {
		try {
			Logger.debug(userId + "");
			Searcher searcher = new Searcher();
			List<models.List> result = (List<models.List>) searcher.readAllList(userId);
			
			return ok(play.libs.Json.toJson(result));
			
		} catch(Exception e) {
			
		}
		return ok();
	}
	
	@play.db.jpa.Transactional
	public static Result createList() {
		try {
			Logger.debug("createList");
			
			final Map<String, String[]> values = request().body().asFormUrlEncoded();
			int userId = Integer.parseInt(values.get("userId")[0]);
			String title = values.get("title")[0];
			String mark = values.get("mark")[0];
			
			Creator creator = new Creator();
			Boolean result = creator.insertListTitleByUserId(userId, title, mark);
			
			Map<String, String> list = new HashMap<String, String>();
			
			if(result) {
				list.put("createList", "sucess");
				return ok(play.libs.Json.toJson(list));
			} else {
				list.put("createlist", "fail");
				return ok(play.libs.Json.toJson(list));
			}
			
		} catch(Exception e) {
			
		}
		
		return ok();
	}
}
