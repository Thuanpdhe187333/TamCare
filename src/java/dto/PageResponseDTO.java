package dto;

import java.util.List;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PageResponseDTO<T> {
    private List<T> items;
    private long totalItems;
    private long totalPages;
    private long currentPage;
    private long pageSize;
}
