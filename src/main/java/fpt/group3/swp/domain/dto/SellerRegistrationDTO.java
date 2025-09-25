package fpt.group3.swp.domain.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class SellerRegistrationDTO {
    @NotBlank(message = "Vui lòng nhập tên hiển thị của cửa hàng")
    @Size(min = 3, message = "Tên hiển thị phải có ít nhất 3 ký tự")
    private String displayName;

    @Size(min = 10, message = "Mô tả phải có ít nhất 10 ký tự")
    private String description;

    @NotBlank(message = "Vui lòng nhập địa chỉ lấy hàng")
    @Size(min = 10, message = "Vui lòng nhập địa chỉ đầy đủ và chi tiết hơn")
    private String pickupAddress;

    @NotBlank(message = "Vui lòng nhập địa chỉ trả hàng")
    @Size(min = 10, message = "Vui lòng nhập địa chỉ đầy đủ và chi tiết hơn")
    private String returnAddress;

    @NotBlank(message = "Vui lòng nhập số điện thoại liên hệ")
    @Pattern(regexp = "^(0[3|5|7|8|9])+([0-9]{8})$", 
             message = "Số điện thoại không hợp lệ (phải có 10 số và bắt đầu bằng 03, 05, 07, 08, 09)")
    private String contactPhone;

    @NotBlank(message = "Vui lòng nhập mã ngân hàng")
    @Pattern(regexp = "^[A-Z]{3,6}$", 
             message = "Mã ngân hàng không hợp lệ (VD: BIDV, VCB, TCB)")
    private String bankCode;

    @NotBlank(message = "Vui lòng nhập số tài khoản")
    @Pattern(regexp = "^\\d{8,16}$", 
             message = "Số tài khoản không hợp lệ (phải có 8-16 chữ số)")
    private String bankAccountNo;

    @NotBlank(message = "Vui lòng nhập tên chủ tài khoản")
    @Size(min = 5, message = "Vui lòng nhập đầy đủ họ tên chủ tài khoản")
    private String bankAccountName;
}