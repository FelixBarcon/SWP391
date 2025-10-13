package fpt.group3.swp.service;

import fpt.group3.swp.domain.Order;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VnPayService {
    @Value("${vnpay.tmnCode}")      private String tmnCode;
    @Value("${vnpay.hashSecret}")   private String secret;
    @Value("${vnpay.payUrl}")       private String payUrl;      // https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
    @Value("${vnpay.returnUrl}")    private String returnUrl;   // https://yourdomain.com/payment/vnp-return
    @Value("${vnpay.ipnUrl}")       private String ipnUrl;      // https://yourdomain.com/payment/vnp-ipn

    public String createPaymentUrl(Order order) {
        // amount: VND * 100 (int)
        long amount = (order.getTotalAmount()) * 100L;

        // TxnRef: duy nhất, 8-32 ký tự
        String txnRef = "ORD" + order.getId() + "-" + System.currentTimeMillis();

        Map<String, String> vnp = new TreeMap<>();
        vnp.put("vnp_Version", "2.1.0");
        vnp.put("vnp_Command", "pay");
        vnp.put("vnp_TmnCode", tmnCode);
        vnp.put("vnp_Amount", String.valueOf(amount));
        vnp.put("vnp_CurrCode", "VND");
        vnp.put("vnp_TxnRef", txnRef);
        vnp.put("vnp_OrderInfo", "Thanh toan don #" + order.getId());
        vnp.put("vnp_OrderType", "other");
        vnp.put("vnp_Locale", "vn");
        vnp.put("vnp_ReturnUrl", returnUrl);
        vnp.put("vnp_IpAddr", "0.0.0.0"); // optional – có thể lấy từ request
        vnp.put("vnp_CreateDate", nowVnpTime());
        vnp.put("vnp_ExpireDate", plusMinutesVnpTime(15));

        // Build query + secure hash
        String query = buildQuery(vnp);
        String secureHash = hmacSHA512(secret, buildHashData(vnp)); // hashData = key=value&... (đã encode value)
        return payUrl + "?" + query + "&vnp_SecureHash=" + secureHash;
    }

    public boolean validateReturn(Map<String, String[]> queryMap) {
        // chuyển thành map<k,v> 1-1
        Map<String, String> fields = new HashMap<>();
        queryMap.forEach((k, arr) -> fields.put(k, arr[0]));

        String secureHash = fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        // sort + encode value trước khi hash lại
        Map<String, String> sorted = new TreeMap<>(fields);
        String hashData = buildHashData(sorted);
        String calc = hmacSHA512(secret, hashData);
        return calc.equalsIgnoreCase(secureHash);
    }

    // Helpers
    private static String buildQuery(Map<String, String> params) {
        return params.entrySet().stream()
                .map(e -> e.getKey() + "=" + urlEncode(e.getValue()))
                .collect(Collectors.joining("&"));
    }
    private static String buildHashData(Map<String, String> params) {
        return params.entrySet().stream()
                .map(e -> e.getKey() + "=" + urlEncode(e.getValue()))
                .collect(Collectors.joining("&"));
    }
    private static String urlEncode(String s) {
        try { return URLEncoder.encode(s, StandardCharsets.UTF_8.toString()); }
        catch (Exception e) { throw new RuntimeException(e); }
    }
    private static String nowVnpTime() {
        DateTimeFormatter f = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        return LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).format(f);
    }
    private static String plusMinutesVnpTime(int minutes) {
        DateTimeFormatter f = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        return LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).plusMinutes(minutes).format(f);
    }
    private static String hmacSHA512(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac.init(secretKey);
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}
