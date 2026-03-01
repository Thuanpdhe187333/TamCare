package service;

import dao.CustomerDAO;

public class CustomerService {

    private final CustomerDAO customerDao = new CustomerDAO();

    /** Returns customer_id for the given code, or null if not found. */
    public Long findIdByCode(String code) throws Exception {
        return customerDao.findIdByCode(code);
    }
}

