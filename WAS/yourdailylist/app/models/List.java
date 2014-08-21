package models;

import javax.persistence.*;

import play.db.jpa.JPA;

@Entity
@Table(name="List")
public class List {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	public Integer listId;
	public String title;
	@GeneratedValue(generator="")
	public String mark;
	public Integer userId;
	
	public List() {
		
	}
	
	public List(int userId, String title, String mark) {
		this.userId = userId;
		this.title = title;
		this.mark = mark;
	}
	
}
