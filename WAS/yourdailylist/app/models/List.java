package models;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class List {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	public Integer listId;
	public Integer userId;
	public String title;
	public String content;
	
}
