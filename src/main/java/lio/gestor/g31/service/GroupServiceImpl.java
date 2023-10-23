package lio.gestor.g31.service;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import lio.gestor.g31.dto.GroupDto;
import lio.gestor.g31.dto.SubjectDto;

import org.springframework.stereotype.Service;


@Service
public class GroupServiceImpl implements GroupService{

	@Override
	public List<GroupDto> getGroups() {
		// TODO Auto-generated method stub
		List<GroupDto> groups = new ArrayList<GroupDto>();
		groups.add(new GroupDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9),"INF-1",3,"2020-2021"));
		groups.add(new GroupDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9),"INF-2",3,"2020-2021"));
		groups.add(new GroupDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9),"INF-3",3,"2020-2021"));
		groups.add(new GroupDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9),"INF-1",2,"2020-2021"));
		groups.add(new GroupDto(UUID.randomUUID().toString().replaceAll("-", "").substring(0, 9),"INF-2",2,"2020-2021"));
		return null;
	}

	@Override
	public GroupDto getGroupById(String id) {
		// TODO Auto-generated method stub
		return getGroups().stream().filter(r -> r.getId().equals(id)).findFirst().get();
	}

	@Override
	public void createGroup(GroupDto subject) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateGroup(GroupDto subject) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteGroup(String id) {
		// TODO Auto-generated method stub
		
	}
	
}
