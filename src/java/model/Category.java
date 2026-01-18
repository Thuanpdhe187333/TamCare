package model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Category {
    private Long categoryId;
    private String name;
    private Long parentId;
}
