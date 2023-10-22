package lio.gestor.g31.bean;

import java.io.IOException;

import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.annotation.SessionScope;

@ManagedBean
@SessionScope
public class UserBean {
	
	private String username;
	private String password;
	
	public UserBean() {
		// TODO Auto-generated constructor stub
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String login() {
		
		System.out.println(username);
		System.out.println(password);
		
		if(username.equals("OmarHR0111") && password.equals("1234")) {
			try {
				
				System.out.println(getRequest().getContextPath() + "/pages/student/students.jsf" );
				
				getFacesContext().getExternalContext().redirect( getRequest().getContextPath() + "/pages/student/students_list.jsf" );
				
			} catch (IOException e) {
				System.out.println(e);
				e.printStackTrace();
			}
			
		}
		return null;
	}
	
	protected HttpServletRequest getRequest() {
	    return (HttpServletRequest) getFacesContext().getExternalContext().getRequest();
	}
	
	protected FacesContext getFacesContext() {
	    return FacesContext.getCurrentInstance();
	}
}
