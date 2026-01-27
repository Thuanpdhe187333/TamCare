package service;

import dao.PermissionDAO;
import dto.PageResponseDTO;
import dto.PermissionDTO;
import dto.PermissionRequest;
import java.sql.SQLException;
import java.util.List;
import model.Permission;
import model.Role;

public class PermissionService {
    private final PermissionDAO permissionDao = new PermissionDAO();

    public PageResponseDTO<PermissionDTO> getPagedList(String search, String sort, long page, long size) throws SQLException {
        long total = permissionDao.getPageCount(search);
        List<Permission> permissions = permissionDao.getList(search, sort, page, size);
        
        List<PermissionDTO> dtos = permissions.stream()
            .map(this::mapToDTO)
            .toList();

        return PageResponseDTO.<PermissionDTO>builder()
            .items(dtos)
            .totalItems(total)
            .totalPages((total + size - 1) / size)
            .currentPage(page)
            .pageSize(size)
            .build();
    }

    public List<PermissionDTO> getAll(String search, String sort) throws SQLException {
        return permissionDao.getList(search, sort, 1L, 1000L).stream()
                .map(this::mapToDTO)
                .toList();
    }

    public PermissionDTO getDetail(Long id) throws SQLException {
        Permission p = permissionDao.getDetail(id);
        return p != null ? mapToDTO(p) : null;
    }

    public List<Role> getRolesByPermissionId(Long id) throws SQLException {
        return permissionDao.getRolesByPermissionId(id);
    }

    public void create(PermissionRequest request) throws SQLException {
        Permission p = new Permission();
        p.setCode(request.getCode());
        p.setName(request.getName());
        
        validatePermission(p);
        
        if (permissionDao.create(p)) {
            if (request.getRoleIds() != null) {
                permissionDao.setPermissionRoles(p.getPermissionId(), request.getRoleIds());
            }
        }
    }

    public void update(Long id, PermissionRequest request) throws SQLException {
        Permission p = permissionDao.getDetail(id);
        if (p == null) throw new util.ValidationException("Quyền không tồn tại");
        
        p.setCode(request.getCode());
        p.setName(request.getName());
        
        validatePermission(p);
        
        if (permissionDao.update(p)) {
            permissionDao.setPermissionRoles(id, request.getRoleIds());
        }
    }

    private void validatePermission(Permission p) throws SQLException {
        if (p.getCode() == null || p.getCode().isBlank()) {
            throw new util.ValidationException("Mã quyền không được để trống");
        }
        if (p.getName() == null || p.getName().isBlank()) {
            throw new util.ValidationException("Tên quyền không được để trống");
        }
        if (permissionDao.codeExists(p.getCode(), p.getPermissionId())) {
            throw new util.ValidationException("Mã quyền đã tồn tại");
        }
    }

    public boolean delete(Long id) throws SQLException {
        return permissionDao.delete(id);
    }

    private PermissionDTO mapToDTO(Permission p) {
        return PermissionDTO.builder()
            .permissionId(p.getPermissionId())
            .code(p.getCode())
            .name(p.getName())
            .build();
    }
}
