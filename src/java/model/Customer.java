package model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Customer {
    private Long customerId;
    private String code;
    private String name;
    private String email;
    private String phone;
    private String address;
    private String status;
}
