package lio.gestor.g31.service;

import java.util.List;

import lio.gestor.g31.dto.SubjectDto;

public interface SubjectService {
	List<SubjectDto> getSubjects();
	SubjectDto getSubjectById(String id);
	void createSubject(SubjectDto subject);
	void updateSubject(SubjectDto subject);
	void deleteSubject(String id);
}
