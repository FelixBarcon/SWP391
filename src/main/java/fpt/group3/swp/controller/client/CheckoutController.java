package fpt.group3.swp.controller.client;

import fpt.group3.swp.common.PaymentMethod;
import fpt.group3.swp.domain.Order;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.domain.dto.ShopCartDto;
import fpt.group3.swp.service.CartService;
import fpt.group3.swp.service.OrderService;
import fpt.group3.swp.service.VnPayService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class CheckoutController {
    private final CartService cartService;
    private final OrderService orderService;
    private final VnPayService vnPayService;

    // 1) Người dùng chọn dòng trong giỏ → vào checkout
    @PostMapping("/cart/checkout")
    public String startCheckout(@RequestParam("ids") List<Long> cartDetailIds,
                                HttpSession session) {
        if (cartDetailIds == null || cartDetailIds.isEmpty()) return "redirect:/cart";
        session.setAttribute("checkout.ids", cartDetailIds);
        return "redirect:/checkout";
    }

    // 2) Hiển thị checkout gom theo shop
    @GetMapping("/checkout")
    public String showCheckout(Model model, HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Long> ids = (List<Long>) session.getAttribute("checkout.ids");
        if (ids == null || ids.isEmpty()) return "redirect:/cart";

        List<ShopCartDto> groups = cartService.groupSelectionByShop(ids);
        model.addAttribute("groups", groups);
        model.addAttribute("paymentMethods", PaymentMethod.values());
        model.addAttribute("formAction", "/order/place");
        model.addAttribute("checkoutMode", "CART");
        return "client/order/checkout";
    }

    // 3) Đặt hàng
    @PostMapping("/order/place")
    public String placeOrder(HttpSession session,
                             @RequestParam PaymentMethod paymentMethod,
                             @RequestParam String receiverName,
                             @RequestParam String receiverPhone,
                             @RequestParam String receiverAddress,
                             @RequestParam String receiverProvince,
                             @RequestParam String receiverDistrict,
                             @RequestParam String receiverWard) {
        Long userId = (Long) session.getAttribute("id");
        if (userId == null) {
            return "redirect:/login"; // chưa login
        }

        User user = new User();
        user.setId(userId);

        @SuppressWarnings("unchecked")
        List<Long> ids = (List<Long>) session.getAttribute("checkout.ids");
        if (ids == null || ids.isEmpty()) return "redirect:/cart";

        Order order = orderService.createFromCartSelection(
                user, ids, paymentMethod,
                receiverName, receiverPhone, receiverAddress,
                receiverProvince, receiverDistrict, receiverWard
        );
        session.removeAttribute("checkout.ids");

        if (paymentMethod == PaymentMethod.COD) {
            return "redirect:/order/confirmation/" + order.getId();
        } else {
            String payUrl = vnPayService.createPaymentUrl(order);
            return "redirect:" + payUrl;
        }
    }

}
