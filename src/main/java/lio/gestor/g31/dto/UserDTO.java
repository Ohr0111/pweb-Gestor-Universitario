package lio.gestor.g31.dto;

public class UserDTO {
	
	private String id;
	private String name;
	private String user_name;
	private String password;
	private String role;
	
	public UserDTO() {super();}
	
	public UserDTO(String id, String name, String user_name, String password, String role) {
		super();
		this.id = id;
		this.name = name;
		this.user_name = user_name;
		this.password = password;
		this.role = role;
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
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}

	
	
}
