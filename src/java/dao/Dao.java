package dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public interface Dao<T> {

    default List<T> getList(Object[] parameters) throws SQLException {
        return null;
    }

    default Long getPageCount(Object... parameters) throws SQLException {
        return null;
    }

    default T getDetail(Long id) throws SQLException {
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

    default void prepare(PreparedStatement statement, Object... parameters) throws SQLException {
        if (parameters != null) {
            for (int i = 0; i < parameters.length; i++) {
                statement.setObject(i + 1, parameters[i]);
            }
        }
    }
}
