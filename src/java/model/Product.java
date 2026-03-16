package model;

public class Product {
    private int id;
    private String productName;
    private String imageUrl;
    private String productCategory;
    private String productDescription;
    private double price;

    public Product() {}

    public Product(int id, String productName, String imageUrl, String productCategory, String productDescription, double price) {
        this.id = id;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.productCategory = productCategory;
        this.productDescription = productDescription;
        this.price = price;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getProductCategory() { return productCategory; }
    public void setProductCategory(String productCategory) { this.productCategory = productCategory; }
    public String getProductDescription() { return productDescription; }
    public void setProductDescription(String productDescription) { this.productDescription = productDescription; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}