// src/main/java/fpt/group3/swp/controller/client/BuyNowController.java
package fpt.group3.swp.controller.client;

import fpt.group3.swp.common.PaymentMethod;
import fpt.group3.swp.domain.Order;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.service.BuyNowService;
import fpt.group3.swp.service.OrderService;
import fpt.group3.swp.service.VnPayService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class BuyNowController {

    private final BuyNowService buyNowService;
    private final OrderService orderService;
    private final VnPayService vnPayService;

    @PostMapping("/buy-now")
    public String startBuyNow(@RequestParam Long productId,
                              @RequestParam(required = false) Long variantId,
                              @RequestParam(defaultValue = "1") int qty,
                              HttpSession session) {
        session.setAttribute("buynow.req",
                new BuyNowService.BuyNowRequest(productId, variantId, Math.max(1, qty)));
        return "redirect:/checkout/buynow";
    }

    @GetMapping("/checkout/buynow")
    public String showBuyNowCheckout(Model model, HttpSession session) {
        BuyNowService.BuyNowRequest req =
                (BuyNowService.BuyNowRequest) session.getAttribute("buynow.req");
        if (req == null) return "redirect:/";

        model.addAttribute("groups",
                buyNowService.groupDirectItemByShop(req.getProductId(), req.getVariantId(), req.getQuantity()));
        model.addAttribute("paymentMethods", PaymentMethod.values());

        model.addAttribute("formAction", "/order/place-direct");
        model.addAttribute("checkoutMode", "DIRECT");
        return "client/order/checkout";
    }

    @PostMapping("/order/place-direct")
    public String placeDirectOrder(HttpSession session,
                                   @RequestParam PaymentMethod paymentMethod,
                                   @RequestParam String receiverName,
                                   @RequestParam String receiverPhone,
                                   @RequestParam String receiverAddress,
                                   @RequestParam String receiverProvince,
                                   @RequestParam String receiverDistrict,
                                   @RequestParam String receiverWard) {
        Long userId = (Long) session.getAttribute("id");
        if (userId == null) return "redirect:/login";

        User user = new User(); user.setId(userId);

        BuyNowService.BuyNowRequest req =
                (BuyNowService.BuyNowRequest) session.getAttribute("buynow.req");
        if (req == null) return "redirect:/";

        Order order = orderService.createFromDirectItem(
                user,
                req.getProductId(),
                req.getVariantId(),
                req.getQuantity(),
                paymentMethod,
                receiverName, receiverPhone,
                receiverAddress, receiverProvince, receiverDistrict, receiverWard
        );

        // clear session của flow buy-now
        session.removeAttribute("buynow.req");

        if (paymentMethod == PaymentMethod.COD) {
            return "redirect:/order/confirmation/" + order.getId();
        } else {
            String payUrl = vnPayService.createPaymentUrl(order);
            return "redirect:" + payUrl;
        }
    }
}
