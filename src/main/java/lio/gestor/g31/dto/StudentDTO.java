package lio.gestor.g31.dto;

public class StudentDTO {
	
	private String dni;
	private String full_name;
	private String sex;
	private int list_number;
	private String type;
	private String municipality;
	private String group;
	private String year;
	private String course;
	
	public StudentDTO(String dni, String full_name, String sex, int list_number, String type, String municipality,
			String group, String year, String course) {
		super();
		this.dni = dni;
		this.full_name = full_name;
		this.sex = sex;
		this.list_number = list_number;
		this.type = type;
		this.municipality = municipality;
		this.group = group;
		this.year = year;
		this.course = course;
	}

	public String getDni() {
		return dni;
	}

	public void setDni(String dni) {
		this.dni = dni;
	}

	public String getFull_name() {
		return full_name;
	}

	public void setFull_name(String full_name) {
		this.full_name = full_name;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public int getList_number() {
		return list_number;
	}

	public void setList_number(int list_number) {
		this.list_number = list_number;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getMunicipality() {
		return municipality;
	}

	public void setMunicipality(String municipality) {
		this.municipality = municipality;
	}

	public String getGroup() {
		return group;
	}

	public void setGroup(String group) {
		this.group = group;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getCourse() {
		return course;
	}

	public void setCourse(String course) {
		this.course = course;
	}


}
