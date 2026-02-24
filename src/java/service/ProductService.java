package service;

import dao.ProductDAO;
import dto.ProductListDTO;
import java.util.List;

public class ProductService {
    private final ProductDAO productDao;

    public ProductService() {
        this.productDao = new ProductDAO();
    }

    public List<ProductListDTO> getProducts() throws Exception {
        return productDao.getProducts();
    }
}
