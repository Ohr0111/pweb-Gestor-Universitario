package lio.gestor.g31.service;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import lio.gestor.g31.dto.CourseDto;

import org.springframework.stereotype.Service;


@Service
public class CourseServiceImpl implements CourseService{

	@Override
	public List<CourseDto> getCourses() {
		// TODO Auto-generated method stub
		List<CourseDto> courses = new ArrayList<CourseDto>();
		courses.add(new CourseDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9),"2020-2021"));
		courses.add(new CourseDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9),"2019-2020"));
		
		return courses;
	}

	@Override
	public CourseDto getCourseById(String id) {
		// TODO Auto-generated method stub
		return getCourses().stream().filter(r -> r.getId().equals(id)).findFirst().get();
	}

	@Override
	public void createCourse(CourseDto subject) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateCourse(CourseDto subject) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteCourse(String id) {
		// TODO Auto-generated method stub
		
	}

	
}
