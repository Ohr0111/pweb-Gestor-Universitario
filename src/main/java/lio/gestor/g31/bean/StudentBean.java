package lio.gestor.g31.bean;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import lio.gestor.g31.utils.JsfUtils;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;
import javax.faces.view.ViewScoped;

import org.primefaces.PrimeFaces;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import lio.gestor.g31.dto.StudentDTO;
import lio.gestor.g31.service.StudentService;

@Component
@ManagedBean
@ViewScoped
public class StudentBean {
	
	private StudentDTO selected_student;
	
	private List<StudentDTO> student_list;
	private List<StudentDTO> selected_students;
	
	@Autowired
	private StudentService service;

	public StudentBean() {
		
		student_list = new ArrayList<StudentDTO>();
		selected_students = new ArrayList<StudentDTO>();
		
	}
	
	@PostConstruct
    public void init() {
		student_list = service.getStudents();
		System.out.println(student_list);
    }
	
	public void newStudent() {
		selected_student = new StudentDTO();
	}
	
	public void save() {
		
		if(this.selected_student.getDni() == null || this.selected_student.getFull_name() == null) {
			
			FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Error", "Debe rellenar todos los datos"));
			PrimeFaces.current().ajax().update("form:messages");
			
		}
		
		else {
			
			if(this.selected_student.getId() == null) {
				
				selected_student.setId(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9));
				
				this.student_list.add(selected_student);
				
				FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "�xito", "Estudiante insertado"));
				
			}
			else {
				
				FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "�xito", "Estudiante modificado"));
				
			}
			
			PrimeFaces.current().ajax().update("form:messages", "form:student-table");
			
			PrimeFaces.current().executeScript("PF('student-form').hide()");
			
		}
			
	}
	
	public void deleteStudents() {
		
		try {
			
			System.out.println("SSSSSS");
			
			if(!this.selected_students.isEmpty()) {
				
				int cant = this.selected_students.size();
				
				for(StudentDTO student : this.selected_students) {
					
					this.student_list.remove(student);
					
				}
				
	            this.selected_students = null;
	            
	            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "�xito", cant > 1 ? "Estudiantes elimidados" : "Estudiante elimidado"));
	            
	            PrimeFaces.current().ajax().update("form:messages", "form:student-table");
				
			}
			
    		
		} catch (Exception e) {
			System.out.println("Excepcion");
			JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_ERROR, "message_error");
		}
		
	}
	
	public boolean checkSelected() {
		
		return this.selected_students.isEmpty();
		
	}

	public StudentDTO getSelected_student() {
		return selected_student;
	}

	public void setSelected_student(StudentDTO selected_student) {
		this.selected_student = selected_student;
	}

	public List<StudentDTO> getStudent_list() {
		return student_list;
	}

	public void setStudent_list(List<StudentDTO> student_list) {
		this.student_list = student_list;
	}

	public List<StudentDTO> getSelected_students() {
		return selected_students;
	}

	public void setSelected_students(List<StudentDTO> selected_students) {
		this.selected_students = selected_students;
	}
	 
}
