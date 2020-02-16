package com.atrosys.entity;

import javax.persistence.*;
import java.sql.Date;

/**
 * document files in index page info sections(darbare shoa,shabake elmi chist)
 */

@Entity
@Table(name = "info_doc")
public class InfoDoc {
    private Long docId;
    private Date pubDate;
    private String title;
    private String owner;
    private String writer;
    private String fileURL;
    private String description;
    private int docDest;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "doc_id")
    public Long getDocId() {
        return docId;
    }

    public void setDocId(Long docId) {
        this.docId = docId;
    }

    @Column(name = "pub_date")
    public Date getPubDate() {
        return pubDate;
    }

    public void setPubDate(Date pubDate) {
        this.pubDate = pubDate;
    }

    @Column(name = "title")
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    @Column(name = "owner")
    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    @Column(name = "writer")
    public String getWriter() {
        return writer;
    }

    public void setWriter(String writer) {
        this.writer = writer;
    }

    @Column(name = "url")
    public String getFileURL() {
        return fileURL;
    }

    public void setFileURL(String fileURL) {
        this.fileURL = fileURL;
    }

    @Column(name = "doc_dest")
    public int getDocDest() {
        return docDest;
    }

    public void setDocDest(int docDest) {
        this.docDest = docDest;
    }

    @Column(name = "description", length = 2000)
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
