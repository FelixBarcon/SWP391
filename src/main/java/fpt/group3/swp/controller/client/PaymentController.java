package fpt.group3.swp.controller.client;

import fpt.group3.swp.common.OrderStatus;
import fpt.group3.swp.domain.Order;
import fpt.group3.swp.reposirory.OrderRepo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequiredArgsConstructor
public class PaymentController {
    private final OrderRepo orderRepo;

    // Return URL từ VNPay (demo)
    @GetMapping("/payment/vnpay-return")
    public String vnpayReturn(@RequestParam Map<String,String> params, Model model) {
        String txnRef = params.get("vnp_TxnRef");     // order id
        String rspCode = params.get("vnp_ResponseCode");

        Order order = orderRepo.findById(Long.valueOf(txnRef)).orElseThrow();

        if ("00".equals(rspCode)) {
            order.setOrderStatus(OrderStatus.PAID);
            orderRepo.save(order);
        } else {
            model.addAttribute("error", "Thanh toán thất bại: " + rspCode);
        }

        model.addAttribute("order", order);
        return "client/order/confirmation";
    }

    @GetMapping("/order/confirmation/{id}")
    public String confirmation(@PathVariable Long id, Model model) {
        Order order = orderRepo.findById(id).orElseThrow();
        model.addAttribute("order", order);
        return "client/order/confirmation";
    }
}
