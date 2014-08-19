package controllers;

import play.api.mvc.Result;
import play.mvc.Controller;

public class ListController extends Controller{
	
	public static Result getAllList() {
		return ok();
	}
}
