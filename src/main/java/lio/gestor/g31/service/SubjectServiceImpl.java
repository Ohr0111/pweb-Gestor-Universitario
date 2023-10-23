package lio.gestor.g31.service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import lio.gestor.g31.dto.SubjectDto;

import org.springframework.stereotype.Service;


@Service
public class SubjectServiceImpl implements SubjectService{
	
	private List<SubjectDto> subjects;

	@Override
	public List<SubjectDto> getSubjects() {
		// TODO Auto-generated method stub
		subjects = new ArrayList<>();
		subjects.add(new SubjectDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9), "Educación Física 1", 30, 1, "2019-2020"));
		subjects.add(new SubjectDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9), "DPOO", 60, 1, "2019-2020"));
		subjects.add(new SubjectDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9), "IP", 45, 1, "2019-2020"));
		subjects.add(new SubjectDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9), "Cálculo 1", 70, 1, "2019-2020"));
		subjects.add(new SubjectDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9), "MC", 55, 1, "2019-2020"));
		
		return subjects;
	}

	@Override
	public SubjectDto getSubjectById(String id) {
		// TODO Auto-generated method stub
		return getSubjects().stream().filter(r -> r.getId().equals(id)).findFirst().get();
	}

	@Override
	public void createSubject(SubjectDto subject) {
		// TODO Auto-generated method stub
		subjects.add(subject);
	}

	@Override
	public void updateSubject(SubjectDto subject) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteSubject(String id) {
		// TODO Auto-generated method stub
		
	}
	
}
