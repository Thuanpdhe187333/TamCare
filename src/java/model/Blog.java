package model;

import java.sql.Timestamp;

public class Blog {
    private int blogID;
    private String title;
    private String summary;
    private String content;
    private String image;
    private String category;
    private int authorID;
    private Timestamp createdAt;
    private boolean status;

    public Blog() {
    }

    // Các Getter và Setter bác tự gen thêm bằng IDE nhé
    public int getBlogID() { return blogID; }
    public void setBlogID(int blogID) { this.blogID = blogID; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}