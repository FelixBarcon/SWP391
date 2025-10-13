package fpt.group3.swp.controller.client;

import fpt.group3.swp.service.OrderService;
import fpt.group3.swp.service.VnPayService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class VnpayController {
    private final VnPayService vnPayService;
    private final OrderService orderService;

    // User quay về
    @GetMapping("/payment/vnp-return")
    public String vnpReturn(@RequestParam Map<String,String> params, Model model) {
        boolean ok = vnPayService.validateReturn(params.entrySet().stream()
                           .collect(Collectors.toMap(Map.Entry::getKey, e -> new String[]{e.getValue()})));

        String responseCode = params.get("vnp_ResponseCode");
        String txnRef = params.get("vnp_TxnRef");
        String orderInfo = params.get("vnp_OrderInfo");

        if (ok && "00".equals(responseCode)) {
            Long orderId = extractOrderId(orderInfo);
            orderService.markPaid(orderId);
            model.addAttribute("orderId", orderId);
            return "client/order/success";
        } else {
            model.addAttribute("message", "Thanh toán thất bại hoặc sai chữ ký!");
            return "client/order/failed";
        }
    }

    @GetMapping("/payment/vnp-ipn")
    @ResponseBody
    public String vnpIpn(@RequestParam Map<String,String> params) {
        boolean ok = vnPayService.validateReturn(params.entrySet().stream()
                           .collect(Collectors.toMap(Map.Entry::getKey, e -> new String[]{e.getValue()})));

        String rsp = params.get("vnp_ResponseCode");
        String orderInfo = params.get("vnp_OrderInfo");
        Long orderId = extractOrderId(orderInfo);

        if (ok && "00".equals(rsp)) {
            orderService.markPaid(orderId);
            return "OK";
        } else {
            orderService.markFailed(orderId);
            return "INVALID";
        }
    }

    private Long extractOrderId(String orderInfo) {
        if (orderInfo == null) return null;
        int idx = orderInfo.lastIndexOf('#');
        return (idx >= 0) ? Long.parseLong(orderInfo.substring(idx+1).trim()) : null;
    }
}
