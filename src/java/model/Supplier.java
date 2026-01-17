package model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Supplier {

    private Long supplierId;
    private String code;
    private String name;
    private String email;
    private String phone;
    private String address;
    private String status;
}
