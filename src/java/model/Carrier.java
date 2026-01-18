package model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Carrier {
    private Long carrierId;
    private String name;
    private String carrierType;
    private String phone;
    private String note;
}
