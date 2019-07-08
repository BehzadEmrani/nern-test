package com.atrosys.entity;

import javax.persistence.*;

/**
 * Created by mehdisabermahani on 6/14/17.
 */
@Entity
@Table(name = "personal_doc")
public class PersonalDoc {
    private Long nationalId;
    private byte[] shenasFpage;
    private byte[] nationalCard;

    @Id
    @Column(name = "national_id")
    public Long getNationalId() {
        return nationalId;
    }

    public void setNationalId(Long nationalId) {
        this.nationalId = nationalId;
    }





    @Lob
    @Column(name = "shenas_fpage", columnDefinition = "mediumblob")
    public byte[] getShenasFpage() {
        return shenasFpage;
    }

    public void setShenasFpage(byte[] shenasFpage) {
        this.shenasFpage = shenasFpage;
    }

    @Lob
    @Column(name = "national_card", columnDefinition = "mediumblob")
    public byte[] getNationalCard() {
        return nationalCard;
    }

    public void setNationalCard(byte[] nationalCard) {
        this.nationalCard = nationalCard;
    }
}
