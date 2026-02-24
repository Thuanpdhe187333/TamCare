package service;

import dao.ProductVariantDAO;
import dto.ProductVariantDTO;
import java.util.List;

public class ProductVariantService {
    private final ProductVariantDAO variantDao;

    public ProductVariantService() {
        this.variantDao = new ProductVariantDAO();
    }

    public List<ProductVariantDTO> listByProductId(long productId) throws Exception {
        return variantDao.listByProductId(productId);
    }
}
