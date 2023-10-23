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

import lio.gestor.g31.dto.CourseDto;
import lio.gestor.g31.dto.GroupDto;
import lio.gestor.g31.service.CourseService;
import lio.gestor.g31.service.GroupService;


@Component
@ManagedBean
@ViewScoped
public class CourseBean {
	
	private CourseDto selectedCourse;

	private ArrayList<CourseDto> courses;	
	private List<CourseDto> selectedCourses;
	
	@Autowired
	private CourseService service;
	
	
	
	public CourseBean() {
		// TODO Auto-generated constructor stub
		selectedCourses = new ArrayList<CourseDto>();
	}
	
	@PostConstruct
    public void init() {
		courses = (ArrayList<CourseDto>) service.getCourses();
		
    }
	
	public void openNew() {
        this.selectedCourse = new CourseDto();
    }
	
	public void saveCourse() {
		if (this.selectedCourse.getId() == null){
	        this.selectedCourse.setId(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9));
			courses.add(this.selectedCourse);
			System.out.println(service.getCourses());
			FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", "Curso añadido"));
		}else {
			FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", "Curso modificado"));
		}
		
		PrimeFaces.current().executeScript("PF('course-form').hide()");
		PrimeFaces.current().ajax().update("form:messages", "form:course-table");
    }

    public void deleteCourses() {
		
		try {
			
			System.out.print("entro");
			
			if(!this.selectedCourses.isEmpty()) {
				
				int cant = this.selectedCourses.size();
				
				for(CourseDto course : this.selectedCourses) {
					
					this.courses.remove(course);
					
				}
				
	            this.selectedCourses = null;
	            
	            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", cant > 1 ? "Cursos eliminados" : "Curso elimidado"));
	            PrimeFaces.current().ajax().update("form:messages", "form:course-table");
				
			}
			
    		
		} catch (Exception e) {
			System.out.println(e);
//			JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_ERROR, "message_error");
		}
		
	}

	public CourseDto getSelectedCourse() {
		return selectedCourse;
	}

	public void setSelectedCourse(CourseDto selectedCourse) {
		this.selectedCourse = selectedCourse;
	}

	public ArrayList<CourseDto> getCourses() {
		return courses;
	}

	public void setCourses(ArrayList<CourseDto> courses) {
		this.courses = courses;
	}

	public List<CourseDto> getSelectedCourses() {
		return selectedCourses;
	}

	public void setSelectedCourses(List<CourseDto> selectedCourses) {
		this.selectedCourses = selectedCourses;
	}

	public CourseService getService() {
		return service;
	}

	public void setService(CourseService service) {
		this.service = service;
	}	
    

}
