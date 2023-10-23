package lio.gestor.g31.service;

import java.util.List;

import lio.gestor.g31.dto.UserDTO;

public interface UserService {
	
	public List<UserDTO> get_users();
	
	public List<UserDTO> insert();
	
	public List<UserDTO> update();
	
	public List<UserDTO> delete();

}
