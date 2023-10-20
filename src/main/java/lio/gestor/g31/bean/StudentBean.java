package lio.gestor.g31.bean;

import java.util.ArrayList;

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

	private StudentDTO new_student;
	
	private StudentDTO selected_student;
	
	private ArrayList<StudentDTO> student_list;
	
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
	
	public void a() {
		System.out.println(student_list);
	}

	public StudentDTO getNew_student() {
		return new_student;
	}

	public void setNew_student(StudentDTO new_student) {
		this.new_student = new_student;
	}

	public StudentDTO getSelected_student() {
		return selected_student;
	}

	public void setSelected_student(StudentDTO selected_student) {
		this.selected_student = selected_student;
	}

	public ArrayList<StudentDTO> getStudent_list() {
		return student_list;
	}

	public void setStudent_list(ArrayList<StudentDTO> student_list) {
		this.student_list = student_list;
	}
	

}
