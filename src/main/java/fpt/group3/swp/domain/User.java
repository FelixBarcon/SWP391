package fpt.group3.swp.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    @Email(message = "Email không hợp lệ", regexp = "^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$")
    private String email;

    @NotNull
    @Size(min = 2, message = "Password phải có tối thiểu 2 ký tự")
    private String password;

    private String firstName;
    private String lastName;

    @NotNull
    @Size(min = 3, message = "Fullname phải có tối thiểu 3 ký tự")
    private String fullName;

    private String address;
    private String phone;

    private String avatar;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    private String resetToken;
    private LocalDateTime resetTokenExpiry;
}
