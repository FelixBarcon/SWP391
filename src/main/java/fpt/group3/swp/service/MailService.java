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

    @Async("mailExecutor")
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

    @Async("mailExecutor")
    public void sendAccountDeactivationEmail(String to, String reason) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Thông báo khóa tài khoản");
        String body = "Kính gửi người dùng,\n\n" +
                "Tài khoản của bạn đã bị tạm khóa bởi quản trị viên hệ thống.\n" +
                (reason != null && !reason.isBlank() ? ("Lý do: " + reason + "\n\n") : "") +
                "Nếu bạn cho rằng đây là sự nhầm lẫn, vui lòng phản hồi email này để được hỗ trợ.\n\n" +
                "Trân trọng.";
        message.setText(body);
        mailSender.send(message);
        System.out.println("📧 Đã gửi email khóa tài khoản tới: " + to);
    }
}
