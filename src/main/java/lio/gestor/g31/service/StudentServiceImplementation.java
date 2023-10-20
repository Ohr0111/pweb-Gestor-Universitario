package lio.gestor.g31.service;

import java.util.ArrayList;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import lio.gestor.g31.dto.StudentDTO;

@Service
public class StudentServiceImplementation implements StudentService{

	@Override
	public ArrayList<StudentDTO> getStudents() {
		
		ArrayList<StudentDTO> list = new ArrayList<StudentDTO>();
		
		list.add(new StudentDTO("01112066240", "Omar Hernandez", "M", 19, "Promovido", "Arroyo", "31", "3", "2021-2025"));
		list.add(new StudentDTO("02093068456", "Dayana Vasquez", "F", 19, "Promovido", "Alta Habana", "32", "3", "2021-2025"));
		
		return list;
	}
	
}