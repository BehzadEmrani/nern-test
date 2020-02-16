package com.atrosys.entity;

import javax.persistence.*;
import java.sql.Date;

/**
 * news sections data.
 * deprecated.
 */

@Entity
@Table(name = "news")
public class News {
    private Long id;
    private String title;
    private String emphasize;
    private String text;
    private String imageURL;
    private String source;
    private Date date;
    private int newsDest;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Column(name = "title")
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    @Column(name = "emphasize",length = 2000)
    public String getEmphasize() {
        return emphasize;
    }

    public void setEmphasize(String emphasize) {
        this.emphasize = emphasize;
    }

    @Column(name = "text",length = 4000)
    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    @Column(name = "date")
    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    @Column(name = "image_url")
    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    @Column(name = "news_dest")
    public int getNewsDest() {
        return newsDest;
    }

    public void setNewsDest(int newsDest) {
        this.newsDest = newsDest;
    }

    @Column(name = "source")
    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }
}
