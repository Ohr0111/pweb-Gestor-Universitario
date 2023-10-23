package lio.gestor.g31.dto;


public class GroupDto {
	private String id;
	private String name;
	private int year;
	private String course;
	
	public GroupDto() {
		super();
		// TODO Auto-generated constructor stub
	}

	public GroupDto(String id, String name, int year, String course) {
		super();
		this.id = id;
		this.name = name;
		this.year = year;
		this.course = course;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public String getCourse() {
		return course;
	}

	public void setCourse(String course) {
		this.course = course;
	}
	
	
	
	
}