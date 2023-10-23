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
import lio.gestor.g31.dto.SubjectDto;
import lio.gestor.g31.service.CourseService;
import lio.gestor.g31.service.SubjectService;


@Component
@ManagedBean
@ViewScoped
public class SubjectBean {
	
	private SubjectDto selectedSubject;
	
	private ArrayList<Integer> yearList;
	private ArrayList<CourseDto> courseList;

	private ArrayList<SubjectDto> subjects;	
	private List<SubjectDto> selectedSubjects;
	
	@Autowired
	private SubjectService service;
	
	
	@Autowired
	private CourseService courseService;
	
	
	public SubjectBean() {
		// TODO Auto-generated constructor stub
		selectedSubjects = new ArrayList<SubjectDto>();
	}
	
	@PostConstruct
    public void init() {
		subjects = (ArrayList<SubjectDto>) service.getSubjects();
		
		yearList = new ArrayList<>();
		yearList.add(1);
		yearList.add(2);
		yearList.add(3);
		yearList.add(4);
		
		courseList = new ArrayList<>();
		courseList = (ArrayList<CourseDto>)courseService.getCourses();
		
    }
	
	public void openNew() {
        this.selectedSubject = new SubjectDto();
    }
	
	public void saveSubject() {
		if (this.selectedSubject.getId() == null){
	        this.selectedSubject.setId(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9));
			
			subjects.add(this.selectedSubject);
			FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", "Asignatura añadida"));
		}else {
			FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", "Asignatura modificada"));
		}
		
		PrimeFaces.current().executeScript("PF('subject-form').hide()");
		PrimeFaces.current().ajax().update("form:messages", "form:subject-table");
    }

    public void deleteSubjects() {
		
		try {
			
			System.out.print("entro");
			
			if(!this.selectedSubjects.isEmpty()) {
				
				int cant = this.selectedSubjects.size();
				
				for(SubjectDto subject : this.selectedSubjects) {
					
					this.subjects.remove(subject);
					
				}
				
	            this.selectedSubjects = null;
	            
	            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Éxito", cant > 1 ? "Asignaturas eliminadas" : "Asignatura elimidada"));
	            PrimeFaces.current().ajax().update("form:messages", "form:subject-table");
				
			}
			
    		
		} catch (Exception e) {
			System.out.println(e);
//			JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_ERROR, "message_error");
		}
		
	}
	
	public boolean checkSelected() {
		
		return this.selectedSubjects.isEmpty();
		
	}
    
    
	public SubjectDto getSelectedSubject() {
		return selectedSubject;
	}

	public void setSelectedSubject(SubjectDto selectedSubject) {
		this.selectedSubject = selectedSubject;
	}

	public ArrayList<Integer> getYearList() {
		return yearList;
	}

	public void setYearList(ArrayList<Integer> yearList) {
		this.yearList = yearList;
	}

	public ArrayList<CourseDto> getCourseList() {
		return courseList;
	}

	public void setCourseList(ArrayList<CourseDto> courseList) {
		this.courseList = courseList;
	}

	public ArrayList<SubjectDto> getSubjects() {
		return subjects;
	}

	public void setSubjects(ArrayList<SubjectDto> subjects) {
		this.subjects = subjects;
	}

	public List<SubjectDto> getSelectedSubjects() {
		return selectedSubjects;
	}

	public void setSelectedSubjects(List<SubjectDto> selectedSubjects) {
		this.selectedSubjects = selectedSubjects;
	}

	public SubjectService getService() {
		return service;
	}

	public void setService(SubjectService service) {
		this.service = service;
	}
	
    

}
