package lio.gestor.g31.dto;


public class CourseDto {
	private String id;
	private String course;
	
	public CourseDto() {
		super();
		// TODO Auto-generated constructor stub
	}

	public CourseDto(String id, String course) {
		super();
		this.id = id;
		this.course = course;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCourse() {
		return course;
	}

	public void setCourse(String course) {
		this.course = course;
	}
	
	
	
}