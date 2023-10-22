package lio.gestor.g31.service;

import java.util.ArrayList;
import java.util.List;

import lio.gestor.g31.dto.StudentDTO;

public interface StudentService {
	
	public List<StudentDTO> getStudents();
	public void insert(StudentDTO student);
	public void update(String old_student, StudentDTO student);
	public void delete(String dni);

}
