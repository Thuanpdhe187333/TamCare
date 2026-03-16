package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.CareTask;
import model.CareTaskInstance;

public class CareTaskDAO extends DBContext {

    private CareTask mapTask(ResultSet rs) throws SQLException {
        CareTask t = new CareTask();
        t.setTaskID(rs.getInt("TaskID"));
        t.setElderlyUserID(rs.getInt("ElderlyUserID"));
        t.setTitle(rs.getString("Title"));
        t.setShortDescription(rs.getString("ShortDescription"));
        t.setTaskType(rs.getString("TaskType"));
        t.setStartDate(rs.getDate("StartDate").toLocalDate());
        java.sql.Date end = rs.getDate("EndDate");
        t.setEndDate(end != null ? end.toLocalDate() : null);
        LocalTime time = rs.getTime("TimeOfDay") != null ? rs.getTime("TimeOfDay").toLocalTime() : null;
        t.setTimeOfDay(time);
        t.setTaskCategory(rs.getString("TaskCategory"));
        t.setDaysOfWeek(rs.getString("DaysOfWeek"));
        return t;
    }

    private List<CareTask> getActiveTasksForRange(int elderlyUserId, LocalDate from, LocalDate to) {
        List<CareTask> list = new ArrayList<>();
        String sql = "SELECT * FROM CareTasks "
                + "WHERE ElderlyUserID = ? "
                + "AND StartDate <= ? "
                + "AND (EndDate IS NULL OR EndDate >= ?)";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, elderlyUserId);
            ps.setDate(2, java.sql.Date.valueOf(to));
            ps.setDate(3, java.sql.Date.valueOf(from));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Map<String, Boolean> getCompletionMap(int elderlyUserId, LocalDate from, LocalDate to) {
        Map<String, Boolean> map = new HashMap<>();

        String sql = "SELECT c.TaskID, c.TaskDate, c.IsCompleted "
                + "FROM CareTaskCompletions c "
                + "JOIN CareTasks t ON c.TaskID = t.TaskID "
                + "WHERE t.ElderlyUserID = ? "
                + "AND c.TaskDate BETWEEN ? AND ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, elderlyUserId);
            ps.setDate(2, java.sql.Date.valueOf(from));
            ps.setDate(3, java.sql.Date.valueOf(to));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int taskId = rs.getInt("TaskID");
                    LocalDate taskDate = rs.getDate("TaskDate").toLocalDate();
                    boolean completed = rs.getBoolean("IsCompleted");
                    String key = taskId + "|" + taskDate.toString();
                    map.put(key, completed);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    private List<CareTaskInstance> expandTask(CareTask task, LocalDate from, LocalDate to,
            Map<String, Boolean> completionMap) {
        List<CareTaskInstance> result = new ArrayList<>();

        LocalDate start = task.getStartDate().isAfter(from) ? task.getStartDate() : from;
        LocalDate end = (task.getEndDate() != null && task.getEndDate().isBefore(to))
                ? task.getEndDate() : to;

        if (end.isBefore(start)) {
            return result;
        }

        String type = task.getTaskType() != null ? task.getTaskType().toUpperCase() : "ONCE";
        Set<Integer> weeklyDays = new HashSet<>();
        if ("WEEKLY".equals(type) && task.getDaysOfWeek() != null) {
            String[] parts = task.getDaysOfWeek().split(",");
            for (String p : parts) {
                try {
                    weeklyDays.add(Integer.parseInt(p.trim()));
                } catch (NumberFormatException ignored) {
                }
            }
        }

        if ("ONCE".equals(type)) {
            LocalDate d = task.getStartDate();
            if (!d.isBefore(from) && !d.isAfter(to)) {
                result.add(buildInstance(task, d, completionMap));
            }
            return result;
        }

        LocalDate d = start;
        while (!d.isAfter(end)) {
            boolean add = false;
            if ("DAILY".equals(type)) {
                add = true;
            } else if ("WEEKLY".equals(type)) {
                int dow = d.getDayOfWeek().getValue(); // 1=Mon..7=Sun
                if (weeklyDays.contains(dow)) {
                    add = true;
                }
            }
            if (add) {
                CareTaskInstance inst = buildInstance(task, d, completionMap);
                result.add(inst);
            }
            d = d.plusDays(1);
        }

        return result;
    }

    private CareTaskInstance buildInstance(CareTask task, LocalDate d,
            Map<String, Boolean> completionMap) {
        CareTaskInstance inst = new CareTaskInstance();
        inst.setTaskID(task.getTaskID());
        inst.setElderlyUserID(task.getElderlyUserID());
        inst.setTaskDate(d);
        inst.setTimeOfDay(task.getTimeOfDay());
        inst.setTitle(task.getTitle());
        inst.setShortDescription(task.getShortDescription());
        inst.setTaskCategory(task.getTaskCategory());
        inst.setTaskType(task.getTaskType());
        String key = task.getTaskID() + "|" + d.toString();
        inst.setCompleted(Boolean.TRUE.equals(completionMap.get(key)));
        return inst;
    }

    public List<CareTaskInstance> getTaskInstancesForMonth(int elderlyUserId, int year, int month) {
        LocalDate firstDay = LocalDate.of(year, month, 1);
        LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth());

        List<CareTask> baseTasks = getActiveTasksForRange(elderlyUserId, firstDay, lastDay);
        Map<String, Boolean> completionMap = getCompletionMap(elderlyUserId, firstDay, lastDay);

        List<CareTaskInstance> all = new ArrayList<>();
        for (CareTask t : baseTasks) {
            all.addAll(expandTask(t, firstDay, lastDay, completionMap));
        }
        return all;
    }

    public List<CareTaskInstance> getTaskInstancesForDate(int elderlyUserId, LocalDate date) {
        List<CareTask> baseTasks = getActiveTasksForRange(elderlyUserId, date, date);
        Map<String, Boolean> completionMap = getCompletionMap(elderlyUserId, date, date);

        List<CareTaskInstance> all = new ArrayList<>();
        for (CareTask t : baseTasks) {
            all.addAll(expandTask(t, date, date, completionMap));
        }
        return all;
    }

    public void toggleCompletion(int elderlyUserId, int taskId, LocalDate taskDate) {
        String checkSql = "SELECT COUNT(*) FROM CareTasks WHERE TaskID = ? AND ElderlyUserID = ?";
        String selectSql = "SELECT IsCompleted FROM CareTaskCompletions WHERE TaskID = ? AND TaskDate = ?";
        String insertSql = "INSERT INTO CareTaskCompletions(TaskID, TaskDate, IsCompleted, CompletedAt) "
                + "VALUES(?, ?, 1, SYSDATETIME())";
        String updateSql = "UPDATE CareTaskCompletions SET IsCompleted = ?, CompletedAt = ? "
                + "WHERE TaskID = ? AND TaskDate = ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, taskId);
                psCheck.setInt(2, elderlyUserId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        conn.rollback();
                        return;
                    }
                }
            }

            Boolean currentCompleted = null;
            try (PreparedStatement psSel = conn.prepareStatement(selectSql)) {
                psSel.setInt(1, taskId);
                psSel.setDate(2, java.sql.Date.valueOf(taskDate));
                try (ResultSet rs = psSel.executeQuery()) {
                    if (rs.next()) {
                        currentCompleted = rs.getBoolean("IsCompleted");
                    }
                }
            }

            if (currentCompleted == null) {
                try (PreparedStatement psIns = conn.prepareStatement(insertSql)) {
                    psIns.setInt(1, taskId);
                    psIns.setDate(2, java.sql.Date.valueOf(taskDate));
                    psIns.executeUpdate();
                }
            } else {
                boolean newState = !currentCompleted;
                try (PreparedStatement psUpd = conn.prepareStatement(updateSql)) {
                    psUpd.setBoolean(1, newState);
                    if (newState) {
                        psUpd.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));
                    } else {
                        psUpd.setTimestamp(2, null);
                    }
                    psUpd.setInt(3, taskId);
                    psUpd.setDate(4, java.sql.Date.valueOf(taskDate));
                    psUpd.executeUpdate();
                }
            }

            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

