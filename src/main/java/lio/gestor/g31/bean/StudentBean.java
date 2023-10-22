package lio.gestor.g31.bean;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import lio.gestor.g31.utils.JsfUtils;

import javax.annotation.PostConstruct;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
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
		
		if(this.selected_student.getId() == null) {
			
			selected_student.setId(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9));
			
			this.student_list.add(selected_student);
			
			JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_INFO, "message_student_insert");
			
		}
		else {
			
			JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_INFO, "message_student_update");
			
		}
		
		PrimeFaces.current().executeScript("PF('student-form').hide()");
		PrimeFaces.current().ajax().update("form:student-table");
		
	}
	
	public void deleteStudents() {
		
		try {
    		this.student_list.remove(this.selected_student);
            this.selected_student = null;
            JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_INFO, "message_student_removed");
            PrimeFaces.current().ajax().update("form:student-table");
		} catch (Exception e) {
			JsfUtils.addMessageFromBundle(null, FacesMessage.SEVERITY_ERROR, "message_error");
		}
		
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
