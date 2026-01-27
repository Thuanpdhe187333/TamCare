package service;

import dao.RoleDAO;
import dto.PageResponseDTO;
import dto.RoleDTO;
import dto.RoleRequest;
import java.sql.SQLException;
import java.util.List;
import model.Permission;
import model.Role;

public class RoleService {
    private final RoleDAO roleDao = new RoleDAO();

    public PageResponseDTO<RoleDTO> getPagedList(String search, String sort, long page, long size) throws SQLException {
        long total = roleDao.getPageCount(search);
        List<Role> roles = roleDao.getList(search, sort, page, size);
        
        List<RoleDTO> dtos = roles.stream()
            .map(this::mapToDTO)
            .toList();

        return PageResponseDTO.<RoleDTO>builder()
            .items(dtos)
            .totalItems(total)
            .totalPages((total + size - 1) / size)
            .currentPage(page)
            .pageSize(size)
            .build();
    }

    public List<RoleDTO> getAll() throws SQLException {
        return roleDao.getAll().stream()
                .map(this::mapToDTO)
                .toList();
    }

    public RoleDTO getById(Long id) throws SQLException {
        Role r = roleDao.getById(id);
        return r != null ? mapToDTO(r) : null;
    }

    public List<Permission> getPermissionsDetailByRoleId(Long id) throws SQLException {
        return roleDao.getPermissionsDetailByRoleId(id);
    }

    public List<Long> getPermissionsByRoleId(Long id) throws SQLException {
        return roleDao.getPermissionsByRoleId(id);
    }

    public void create(RoleRequest request) throws SQLException {
        Role r = new Role();
        r.setName(request.getName());
        r.setDescription(request.getDescription());
        
        validateRole(r);
        
        if (roleDao.create(r)) {
            if (request.getPermissionIds() != null) {
                roleDao.setRolePermissions(r.getRoleId(), request.getPermissionIds());
            }
        }
    }

    public void update(Long id, RoleRequest request) throws SQLException {
        Role r = roleDao.getById(id);
        if (r == null) throw new util.ValidationException("Vai trò không tồn tại");
        
        r.setName(request.getName());
        r.setDescription(request.getDescription());
        
        validateRole(r);
        
        if (roleDao.update(r)) {
            roleDao.setRolePermissions(id, request.getPermissionIds());
        }
    }

    private void validateRole(Role r) throws SQLException {
        if (r.getName() == null || r.getName().isBlank()) {
            throw new util.ValidationException("Tên vai trò không được để trống");
        }
        if (roleDao.nameExists(r.getName(), r.getRoleId())) {
            throw new util.ValidationException("Tên vai trò đã tồn tại");
        }
    }

    public boolean delete(Long id) throws SQLException {
        return roleDao.delete(id);
    }

    private RoleDTO mapToDTO(Role r) {
        return RoleDTO.builder()
            .roleId(r.getRoleId())
            .name(r.getName())
            .description(r.getDescription())
            .build();
    }
}
