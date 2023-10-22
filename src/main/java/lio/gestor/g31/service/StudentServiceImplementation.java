package lio.gestor.g31.service;

import java.util.ArrayList;
import java.util.List;

import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import lio.gestor.g31.dto.StudentDTO;

@Service
public class StudentServiceImplementation implements StudentService{
	
	private List<StudentDTO> list;

	@Override
	public List<StudentDTO> getStudents() {
		
		list = new ArrayList<StudentDTO>();
		
		list.add(new StudentDTO(UUID.randomUUID().toString().replaceAll("-", "").substring( 0, 9),"01112066240", "Omar Hernandez", "M", 19, "Promovido", "Arroyo", "31", "3", "2021-2025"));
		list.add(new StudentDTO(UUID.randomUUID().toString().replaceAll("-", "").substring( 0, 9),"02093068456", "Dayana Vasquez", "F", 19, "Promovido", "Alta Habana", "32", "3", "2021-2025"));
		list.add(new StudentDTO(UUID.randomUUID().toString().replaceAll("-", "").substring( 0, 9),"02033868426", "Josuan Reinoso Rodriguez", "M", 20, "Promovido", "La lisa", "31", "3", "2021-2025"));
		
		return list;
	}

	@Override
	public void insert(StudentDTO student) {
		
		list.add(student);
		
	}

	@Override
	public void update(String old_student, StudentDTO student) {
		
		boolean found = false;
		int pointer = 0;
		
		do {
			
			StudentDTO s = list.get(pointer++);
			
			if(s.getDni().equals(old_student)) {
				found = true;
				list.remove(pointer--);
				list.add(student);
			}
			
		}while(!found);
		
	}

	@Override
	public void delete(String dni) {
		
		
		
	}
	
}