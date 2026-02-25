package service;

import dao.ProductVariantDAO;
import dto.ProductVariantDTO;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class ProductVariantService {
    private final ProductVariantDAO variantDao;

    public ProductVariantService() {
        this.variantDao = new ProductVariantDAO();
    }

    public List<ProductVariantDTO> listByProductId(long productId) throws Exception {
        return variantDao.listByProductId(productId);
    }

    /** Returns map variant_sku -> variant_id for the given SKUs. */
    public Map<String, Long> findIdsBySkus(Set<String> skus) throws Exception {
        return variantDao.findIdsBySkus(skus);
    }
}
