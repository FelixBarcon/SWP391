package fpt.group3.swp.common;

public enum OrderStatus {
    PENDING_CONFIRM,   // COD: chờ shop xác nhận
    PENDING_PAYMENT,   // VNPAY: chờ thanh toán
    PAID,              // đã thanh toán
    CANCELED
}
