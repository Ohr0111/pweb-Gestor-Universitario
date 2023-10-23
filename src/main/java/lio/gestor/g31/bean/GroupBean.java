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

import lio.gestor.g31.dto.GroupDto;
import lio.gestor.g31.service.GroupService;


@Component
@ManagedBean
@ViewScoped
public class GroupBean {
	
	private GroupDto selectedGroup;
	
	private ArrayList<Integer> yearList;
	private ArrayList<String> courseList;

	private ArrayList<GroupDto> groups;	
	private List<GroupDto> selectedGroups;
	
	@Autowired
	private GroupService service;
	
	
	
	public GroupBean() {
		// TODO Auto-generated constructor stub
		selectedGroups = new ArrayList<GroupDto>();
	}
	
	@PostConstruct
    public void init() {
		groups = (ArrayList<GroupDto>) service.getGroups();
		
		yearList = new ArrayList<>();
		yearList.add(1);
		yearList.add(2);
		yearList.add(3);
		yearList.add(4);
		
		courseList = new ArrayList<>();
		courseList.add("2019-2020");
		courseList.add("2020-2021");
		
    }
	
	public void openNew() {
        this.selectedGroup = new GroupDto();
    }
	
	public void saveGroup() {
		if (this.selectedGroup.getId() == null){
	        this.selectedGroup.setId(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9));
			groups.add(this.selectedGroup);
			FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", "Grupo añadido"));
		}else {
			FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", "Grupo modificado"));
		}
		
		PrimeFaces.current().executeScript("PF('group-form').hide()");
		PrimeFaces.current().ajax().update("form:messages", "form:group-table");
    }

    public void deleteGroups() {
		
		try {
			
			System.out.print("entro");
			
			if(!this.selectedGroups.isEmpty()) {
				
				int cant = this.selectedGroups.size();
				
				for(GroupDto group : this.selectedGroups) {
					
					this.groups.remove(group);
					
				}
				
	            this.selectedGroups = null;
	            
	            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", cant > 1 ? "Grupos eliminados" : "Grupo elimidado"));
	            PrimeFaces.current().ajax().update("form:messages", "form:group-table");
				
			}
			
    		
		} catch (Exception e) {
			System.out.println(e);
//			JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_ERROR, "message_error");
		}
		
	}

	public GroupDto getSelectedGroup() {
		return selectedGroup;
	}

	public void setSelectedGroup(GroupDto selectedGroup) {
		this.selectedGroup = selectedGroup;
	}

	public ArrayList<Integer> getYearList() {
		return yearList;
	}

	public void setYearList(ArrayList<Integer> yearList) {
		this.yearList = yearList;
	}

	public ArrayList<String> getCourseList() {
		return courseList;
	}

	public void setCourseList(ArrayList<String> courseList) {
		this.courseList = courseList;
	}

	public ArrayList<GroupDto> getGroups() {
		return groups;
	}

	public void setGroups(ArrayList<GroupDto> groups) {
		this.groups = groups;
	}

	public List<GroupDto> getSelectedGroups() {
		return selectedGroups;
	}

	public void setSelectedGroups(List<GroupDto> selectedGroups) {
		this.selectedGroups = selectedGroups;
	}

	public GroupService getService() {
		return service;
	}

	public void setService(GroupService service) {
		this.service = service;
	}
	
    

}
