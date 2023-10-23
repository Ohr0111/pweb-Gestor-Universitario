package lio.gestor.g31.service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;

import lio.gestor.g31.dto.UserDTO;
import lio.gestor.g31.service.UserService;

@Service
public class UserServiceImplemenation implements UserService{

	@Override
	public List<UserDTO> get_users() {
		
		List<UserDTO> list = new ArrayList<UserDTO>();
		
		list.add(new UserDTO(UUID.randomUUID().toString().replaceAll("-", "").substring(0,9), "Omar Hernandez Rodriguez", "OmarHR0111", "1234", "Director" ) );
		
		return list;
	}

	@Override
	public List<UserDTO> insert() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<UserDTO> update() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<UserDTO> delete() {
		// TODO Auto-generated method stub
		return null;
	}

}
