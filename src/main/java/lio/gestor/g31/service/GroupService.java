package lio.gestor.g31.service;

import java.util.List;
import lio.gestor.g31.dto.GroupDto;

public interface GroupService {
	List<GroupDto> getGroups();
	GroupDto getGroupById(String id);
	void createGroup(GroupDto subject);
	void updateGroup(GroupDto subject);
	void deleteGroup(String id);
}