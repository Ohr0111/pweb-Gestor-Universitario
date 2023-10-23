package lio.gestor.g31.service;

import java.util.List;
import lio.gestor.g31.dto.CourseDto;

public interface CourseService {
	List<CourseDto> getCourses();
	CourseDto getCourseById(String id);
	void createCourse(CourseDto subject);
	void updateCourse(CourseDto subject);
	void deleteCourse(String id);
}