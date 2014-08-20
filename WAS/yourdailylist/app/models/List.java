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
	public String content;
	public Integer userId;
	
	public List(int userId, String title) {
		this.userId = userId;
		this.title = title;
	}
	
}