package com.atrosys.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "world_nern")
public class WorldNren {
    private String countryId;
    private String nernName;
    private String imageURL;
    private String siteURL;
    private String description;

    @Id
    @Column(name = "country_id")
    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    @Column(name = "nern_name")
    public String getNernName() {
        return nernName;
    }

    public void setNernName(String nernName) {
        this.nernName = nernName;
    }

    @Column(name = "image_url")
    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    @Column(name = "site_url")
    public String getSiteURL() {
        return siteURL;
    }

    public void setSiteURL(String siteURL) {
        this.siteURL = siteURL;
    }

    @Column(name = "description", length = 2000)
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
