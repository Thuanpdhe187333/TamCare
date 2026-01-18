package dao;

import java.sql.SQLException;
import java.util.List;

public interface Dao<T> {

    default List<T> getAll() throws SQLException {
        return null;
    }

    default T getById(Long id) throws SQLException {
        return null;
    }

    default boolean create(T data) throws SQLException {
        return false;
    }

    default boolean update(T data) throws SQLException {
        return false;
    }

    default boolean delete(Long id) throws SQLException {
        return false;
    }
}
