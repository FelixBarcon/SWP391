package fpt.group3.swp.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class MailService {

    private final JavaMailSender mailSender;

    public MailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @Async
    public void sendResetPasswordEmail(String to, String resetLink) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Reset mật khẩu");
        message.setText("Bạn vừa yêu cầu reset mật khẩu.\n" +
                "Click vào link sau để đặt lại mật khẩu:\n" + resetLink +
                "\n\nLink sẽ hết hạn sau 30 phút.");

        mailSender.send(message);
        System.out.println("📧 Email đã được gửi tới: " + to);
    }
}
