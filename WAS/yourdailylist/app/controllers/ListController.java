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
			
			if(result != null) {
				Map<String, String> lists = new HashMap<String, String>();
				for (models.List list : result) {
					lists.put("listId",list.listId + "");
					lists.put("title", list.title);
					lists.put("content", list.content);
				}
				return ok(play.libs.Json.toJson(lists));
			} else {
				return ok();
			}
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
			
			Creator creator = new Creator();
			Boolean result = creator.insertListTitleByUserId(userId, title);
			
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
