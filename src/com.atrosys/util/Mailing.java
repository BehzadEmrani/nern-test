package com.atrosys.util;

import com.atrosys.model.UniSubStatus;

import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.Properties;

/**
 * Created by met on 11/28/17.
 */
public class Mailing {
    static String bccList = "hasan@seemsys.com,behnam@nern.ir,valizadeh@ito.gov.ir";
    static String from = "crm@nern.ir";

    private static boolean sendMail(String to, String bodyText, String subject) {
        try {
            String host = "localhost";
            Properties properties = System.getProperties();
            properties.setProperty("mail.host", host);
            Session mailingSession = Session.getDefaultInstance(properties);
            MimeMessage message = new MimeMessage(mailingSession);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setRecipients(Message.RecipientType.BCC, bccList);
            message.setSubject(subject, "UTF-8");
            MimeMultipart multipart = new MimeMultipart("related");
            BodyPart messageBodyPart = new MimeBodyPart();
            String htmlText = "<p style='direction: rtl;white-space: pre-line;'>" + bodyText + "</p>";
            messageBodyPart.setContent(htmlText, "text/html;charset=utf-8");
            multipart.addBodyPart(messageBodyPart);
            message.setContent(multipart);
            Transport.send(message);
        } catch (Exception e) {
            return false;
        }
        return true;
    }

    private static boolean sendTestMail(String to, String bodyText, String subject) {
        try {
            String host = "localhost";
            Properties properties = System.getProperties();
            properties.setProperty("mail.host", host);
            Session mailingSession = Session.getDefaultInstance(properties);
            MimeMessage message = new MimeMessage(mailingSession);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
//            message.setRecipients(Message.RecipientType.BCC, bccList);
            message.setSubject(subject, "UTF-8");
            MimeMultipart multipart = new MimeMultipart("related");
            BodyPart messageBodyPart = new MimeBodyPart();
            String htmlText = "<p style='direction: rtl;white-space: pre-line;'>" + bodyText + "</p>";
            messageBodyPart.setContent(htmlText, "text/html;charset=utf-8");
            multipart.addBodyPart(messageBodyPart);
            message.setContent(multipart);
            Transport.send(message);
        } catch (Exception e) {
            return false;
        }
        return true;
    }

    public static boolean sendToNextPhaseChangeMail(String to, String topManagerName, HttpServletRequest request) throws IOException {
        String filePath = request.getServletContext().getRealPath("/documents/mail/sendToNextPhaseChangeMailBody.txt");
        String rawBody = readFile(filePath);
        String body = String.format(rawBody, topManagerName);
        String subject = "تغییر وضعیت در CRM شبکه علمی ایران";
        return sendMail(to, body, subject);
    }

    public static boolean sendSubsToAgentChangeMail(String to, String uniName, String topManagerName
            , String subscriptionFormNo, Date subscriptionFormDate, HttpServletRequest request) throws IOException {
        String filePath = request.getServletContext().getRealPath("/documents/mail/sendSubsToAgentChangeMailBody.txt");
        String rawBody = readFile(filePath);
        String body = String.format(rawBody, uniName, topManagerName,
                subscriptionFormNo, Util.convertGregorianToJalali(subscriptionFormDate));

        String subject = "ارسال قرارداد نهایی اشتراک شبکه علمی ایران";
        return sendMail(to, body, subject);
    }

    public static boolean sendGeneralUniStatusChangeMail(String to, String uniName, String topManagerName, String newStatus, HttpServletRequest request) throws IOException {
        String filePath = request.getServletContext().getRealPath("/documents/mail/sendGeneralStatusChangeMailBody.txt");
        String rawBody = readFile(filePath);
        String body = String.format(rawBody, uniName, topManagerName, newStatus);

        String subject = "تغییر وضعیت در CRM شبکه علمی ایران";
        return sendTestMail(to, body, subject);
    }

    public static boolean sendReqToOrganChangeMail(String to, String uniName, String topManagerName,String organName,String approverName, HttpServletRequest request) throws IOException {
        String filePath = request.getServletContext().getRealPath("/documents/mail/sendReqToOrganChangeMailBody.txt");
        String rawBody = readFile(filePath);
        String body = String.format(rawBody, uniName, topManagerName,approverName,organName);

        String subject = "بررسی درخواست عضویت شبکه علمی ایران توسط ارگان مربوط";
        return sendMail(to, body, subject);
    }

    public static boolean sendReqToSubsChangeMail(String to, String uniName, String topManagerName, HttpServletRequest request) throws IOException {
        String filePath = request.getServletContext().getRealPath("/documents/mail/sendReqToSubsChangeMailBody.txt");
        String rawBody = readFile(filePath);
        String body = String.format(rawBody, uniName, topManagerName);

        String subject = "ارسال قرارداد اشتراک شبکه علمی ایران";
        return sendMail(to, body, subject);
    }

    public static boolean sendServiceFormToCompeletedChangeMail(String to, String uniName, String topManagerName, HttpServletRequest request) throws IOException {
        String filePath = request.getServletContext().getRealPath("/documents/mail/sendServiceFormToCompletedChangeMailBody.txt");
        String rawBody = readFile(filePath);
        String body = String.format(rawBody, uniName, topManagerName);
        String subject = "تغییر وضعیت در سرویس فرم - شبکه علمی ایران";
        return sendMail(to, body, subject);
    }

    public static boolean sendReqErrorMail(String to, String uniName, String topManagerName, UniSubStatus subStatus,
                                           String message, HttpServletRequest request) throws IOException {
        String filePath = request.getServletContext().getRealPath("/documents/mail/sendReqErrorMailBody.txt");
        String rawBody = readFile(filePath);
        String body = String.format(rawBody, uniName, topManagerName, subStatus.getFaStr(), message);
        String subject = "خطا در ثبت نام در شبکه علمی ایران";
        return sendMail(to, body, subject);
    }

    static String readFile(String path) throws IOException {
        byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, StandardCharsets.UTF_8);
    }
}
