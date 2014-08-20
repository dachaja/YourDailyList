package models;

import javax.persistence.*;
import play.db.jpa.JPA;

@Entity
public class DailyList {
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	public Integer listId;
	public String title;
	public String content;
	public Integer userId;
	
	public DailyList() {
		
	}
}
