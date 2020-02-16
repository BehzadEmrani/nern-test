package com.atrosys.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;

/**
 * Created by mehdisabermahani on 6/14/17.
 * each person info in the system.
 */

@Entity
@Table(name = "personal_info")
public class PersonalInfo {
    private Long nationalId;
    private String shenasNo;
    private String nationalCardNo;
    private String shenasSerial;
    private String fname;
    private String lname;
    private String fatherName;
    private String username;
    private String password;
    private Date birthDate;
    private Boolean needChangePass;
    private Boolean legalPersonality;
    private Boolean active;


    public String combineName() {
        if (fname != null && lname != null)
            return fname + " " + lname;
        else
            return "نامشخص";
    }

    @Id
    @Column(name = "national_id")
    public Long getNationalId() {
        return nationalId;
    }

    public void setNationalId(Long nationalId) {
        this.nationalId = nationalId;
    }


    @Column(name = "national_card_no")
    public String getNationalCardNo() {
        return nationalCardNo;
    }

    public void setNationalCardNo(String nationalCardNo) {
        this.nationalCardNo = nationalCardNo;
    }

    @Column(name = "shenas_no")
    public String getShenasNo() {
        return shenasNo;
    }

    public void setShenasNo(String shenasNo) {
        this.shenasNo = shenasNo;
    }

    @Column(name = "shenas_serial")
    public String getShenasSerial() {
        return shenasSerial;
    }

    public void setShenasSerial(String shenasSerial) {
        this.shenasSerial = shenasSerial;
    }


    @Column(name = "fname")
    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }


    @Column(name = "lname")
    public String getLname() {
        return lname;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    @Column(name = "father_name")
    public String getFatherName() {
        return fatherName;
    }

    public void setFatherName(String fatherName) {
        this.fatherName = fatherName;
    }

    @Column(name = "birth_date")
    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    @Column(name = "username", unique = true)
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Column(name = "password")
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void hashAndSetPassword(String password) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        this.password = customHash(password);
    }

    @Column(name = "need_change_pass")
    public Boolean getNeedChangePass() {
        return needChangePass;
    }

    public void setNeedChangePass(Boolean needChangePass) {
        this.needChangePass = needChangePass;
    }

    @Column(name = "legal_personality")
    public Boolean getLegalPersonality() {
        return legalPersonality;
    }

    public void setLegalPersonality(Boolean legalPersonality) {
        this.legalPersonality = legalPersonality;
    }

    @Column(name = "active")
    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    private static String sha1Hash(String str) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        MessageDigest crypt = MessageDigest.getInstance("SHA-1");
        crypt.reset();
        crypt.update(str.getBytes("UTF-8"));
        return new BigInteger(1, crypt.digest()).toString(16);
    }

    private static String md5Hash(String str) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        MessageDigest crypt = MessageDigest.getInstance("MD5");
        crypt.reset();
        crypt.update(str.getBytes("UTF-8"));
        return new BigInteger(1, crypt.digest()).toString(16);
    }

    public static String customHash(String str) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        return md5Hash("$NeRn!1396$NeRn!1396" + sha1Hash(str));
    }

}