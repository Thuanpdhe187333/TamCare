package util;

import java.io.UnsupportedEncodingException;
import java.sql.Date;

public final class RequestUtil {

    private RequestUtil() {
    }

    public static int parseInt(String raw, int def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Integer.parseInt(raw);
        } catch (Exception e) {
            return def;
        }
    }

    public static long parseLong(String raw, long def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Long.parseLong(raw);
        } catch (Exception e) {
            return def;
        }
    }

    public static Date parseSqlDate(String s) {
        try {
            if (s == null || s.isBlank()) {
                return null;
            }
            return Date.valueOf(s);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Build encoded query string for pagination while keeping filters.
     *
     * @param keyword search keyword (nullable)
     * @param status  status filter (nullable)
     * @param from    from date string (nullable)
     * @param to      to date string (nullable)
     * @param fromParamName parameter name for from date in query
     * @param toParamName   parameter name for to date in query
     */
    public static String buildQueryString(
            String keyword,
            String status,
            String from,
            String to,
            String fromParamName,
            String toParamName) throws UnsupportedEncodingException {

        StringBuilder sb = new StringBuilder();

        if (keyword != null && !keyword.isBlank()) {
            sb.append("&keyword=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
        }
        if (status != null && !status.isBlank()) {
            sb.append("&status=").append(java.net.URLEncoder.encode(status, "UTF-8"));
        }
        if (from != null && !from.isBlank()) {
            sb.append("&").append(fromParamName).append("=")
                    .append(java.net.URLEncoder.encode(from, "UTF-8"));
        }
        if (to != null && !to.isBlank()) {
            sb.append("&").append(toParamName).append("=")
                    .append(java.net.URLEncoder.encode(to, "UTF-8"));
        }
        return sb.toString();
    }
}

