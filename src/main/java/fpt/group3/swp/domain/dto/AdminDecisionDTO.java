package fpt.group3.swp.domain.dto;

import lombok.Data;

@Data
public class AdminDecisionDTO {
    /** APPROVE | REJECT */
    private String action;
    private String note; // nếu muốn lưu lý do (hiện chưa dùng)
}