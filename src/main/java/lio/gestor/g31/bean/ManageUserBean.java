package lio.gestor.g31.bean;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;
import javax.faces.view.ViewScoped;

import org.primefaces.PrimeFaces;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import lio.gestor.g31.dto.StudentDTO;
import lio.gestor.g31.dto.UserDTO;
import lio.gestor.g31.service.UserService;
import lio.gestor.g31.utils.JsfUtils;

@Component
@ManagedBean
@ViewScoped
public class ManageUserBean {
	
	private UserDTO selected_user;
	private List<UserDTO> user_list;
	private List<UserDTO> selected_users;
	
	@Autowired
	private UserService service;
	
	public ManageUserBean() {
		super();
		user_list = new ArrayList<>();
	}
	
	@PostConstruct
	public void init() {
		user_list = service.get_users();
	}
	
	public void newUser() {
		
		selected_user = new UserDTO();
		
	}
	
	public void save() {
		
		if(this.selected_user.getName() == null || this.selected_user.getPassword() == null || this.selected_user.getUser_name() == null) {
			
			FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Error", "Debe rellenar todos los datos"));
			PrimeFaces.current().ajax().update("form:messages");
			
		}
		
		else {
			
			if(this.selected_user.getId() == null) {
				
				selected_user.setId(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9));
				
				this.user_list.add(selected_user);
				
				FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", "Usuario insertado"));
				
			}
			else {
				
				FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", "Usuario modificado"));
				
			}
			
			PrimeFaces.current().ajax().update("form:messages", "form:user-table");
			
			PrimeFaces.current().executeScript("PF('user-form').hide()");
			
		}
		
	}
	
	public void deleteUsers() {
		
		try {
			
			if(!this.selected_users.isEmpty()) {
				
				int cant = this.selected_users.size();
				
				for(UserDTO user : this.selected_users) {
					
					this.user_list.remove(user);
					
				}
				
	            this.selected_users = null;
	            
	            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", cant > 1 ? "Usuarios eliminados" : "Usuario elimidado"));
	            
	            PrimeFaces.current().ajax().update("form:messages", "form:user-table");
				
			}
			
    		
		} catch (Exception e) {
			System.out.println("Excepcion");
			JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_ERROR, "message_error");
		}
		
	}

	public UserDTO getSelected_user() {
		return selected_user;
	}

	public void setSelected_user(UserDTO selected_user) {
		this.selected_user = selected_user;
	}

	public List<UserDTO> getUser_list() {
		return user_list;
	}

	public void setUser_list(List<UserDTO> user_list) {
		this.user_list = user_list;
	}

	public List<UserDTO> getSelected_users() {
		return selected_users;
	}

	public void setSelected_users(List<UserDTO> selected_users) {
		this.selected_users = selected_users;
	}
	
	

}
