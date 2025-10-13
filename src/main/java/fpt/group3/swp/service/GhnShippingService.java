// fpt/group3/swp/service/GhnShippingService.java
package fpt.group3.swp.service;

import fpt.group3.swp.config.GhnProperties;
import fpt.group3.swp.domain.CartDetail;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.dto.FeeCalcRequestGHN;
import fpt.group3.swp.domain.dto.FeeCalcResponse;
import fpt.group3.swp.reposirory.CartDetailRepo;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ShopRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class GhnShippingService {
    private final GhnProperties props;
    private final RestTemplate restTemplate;

    private final CartDetailRepo cartDetailRepo;
    private final ProductRepository productRepo;
    private final ShopRepository shopRepo;

    @Value("${shipping.fixed.weightGram:500}")   private int fixedWeight;   // gram
    @Value("${shipping.fixed.lengthCm:20}")      private int fixedLength;   // cm
    @Value("${shipping.fixed.widthCm:10}")       private int fixedWidth;    // cm
    @Value("${shipping.fixed.heightCm:10}")      private int fixedHeight;   // cm
    @Value("${shipping.use-insurance:false}")    private boolean useInsurance;
    @Value("${shipping.insurance.value:0}")      private int insuranceValueDefault;

    public FeeCalcResponse calcFeeFromFixedOrigin(FeeCalcRequestGHN req) {
        if (req.getToDistrictId() == null || req.getToWardCode() == null) {
            throw new IllegalArgumentException("Thiếu toDistrictId/toWardCode.");
        }

        Set<Long> shopIds = new LinkedHashSet<>();

        if (req.getShopIds() != null && !req.getShopIds().isEmpty()) {
            shopIds.addAll(req.getShopIds());
        } else if (req.getCartDetailIds() != null && !req.getCartDetailIds().isEmpty()) {
            List<CartDetail> lines = cartDetailRepo.findAllById(req.getCartDetailIds());
            if (lines.isEmpty()) throw new IllegalArgumentException("Không có sản phẩm hợp lệ.");
            for (CartDetail cd : lines) {
                if (cd.getProduct() != null && cd.getProduct().getShop() != null) {
                    shopIds.add(cd.getProduct().getShop().getId());
                }
            }
        } else if (req.getProductId() != null) {
            Product p = productRepo.findById(req.getProductId()).orElseThrow();
            shopIds.add(p.getShop().getId());
        } else {
            throw new IllegalArgumentException("Thiếu shopIds/cartDetailIds/productId.");
        }

        if (shopIds.isEmpty()) {
            FeeCalcResponse r = new FeeCalcResponse();
            r.setTotalFee(0);
            r.setShops(List.of());
            return r;
        }

        int totalFee = 0;
        List<FeeCalcResponse.ShopFee> shopFees = new ArrayList<>();
        Map<Long, Shop> shops = shopRepo.findAllById(shopIds).stream()
                .collect(Collectors.toMap(Shop::getId, s -> s));

        Integer serviceId = pickFirstAvailableService(props.getFixedFromDistrictId(), req.getToDistrictId());
        if (serviceId == null) {
            log.warn("[GHN] Không có service từ {} -> {}", props.getFixedFromDistrictId(), req.getToDistrictId());
            FeeCalcResponse r = new FeeCalcResponse();
            r.setTotalFee(0);
            r.setShops(List.of());
            return r;
        }

        for (Long shopId : shopIds) {
            int insuranceValue = useInsurance ? insuranceValueDefault : 0;

            int fee = requestGhnFee(
                    serviceId,
                    props.getFixedFromDistrictId(),
                    req.getToDistrictId(),
                    req.getToWardCode(),
                    fixedWeight, fixedLength, fixedWidth, fixedHeight,
                    insuranceValue
            );

            totalFee += fee;

            Shop s = shops.get(shopId);
            FeeCalcResponse.ShopFee sf = new FeeCalcResponse.ShopFee();
            sf.setShopId(shopId);
            sf.setShopName(s != null ? s.getDisplayName() : ("Shop " + shopId));
            sf.setServiceTypeId(serviceId);
            sf.setFee(fee);
            shopFees.add(sf);
        }

        FeeCalcResponse resp = new FeeCalcResponse();
        resp.setTotalFee(totalFee);
        resp.setShops(shopFees);
        return resp;
    }

    private Integer pickFirstAvailableService(Integer fromDistrict, Integer toDistrict) {
        String url = props.getBaseUrl() + "/v2/shipping-order/available-services";
        Map<String, Object> body = Map.of(
                "shop_id", props.getShopId(),
                "from_district", fromDistrict,
                "to_district", toDistrict
        );

        HttpHeaders h = new HttpHeaders();
        h.setContentType(MediaType.APPLICATION_JSON);
        h.set("Token", props.getToken());
        h.set("ShopId", String.valueOf(props.getShopId()));

        try {
            ResponseEntity<Map> res = restTemplate.exchange(url, HttpMethod.POST, new HttpEntity<>(body, h), Map.class);
            Object data = res.getBody() != null ? res.getBody().get("data") : null;
            if (data instanceof List<?> list && !list.isEmpty()) {
                for (Object o : list) {
                    if (o instanceof Map<?,?> m && m.get("service_id") instanceof Number n) {
                        return n.intValue();
                    }
                }
            }
        } catch (HttpStatusCodeException ex) {
            log.error("[GHN] available-services 4xx: {} - {}", ex.getStatusCode(), ex.getResponseBodyAsString());
        } catch (Exception ex) {
            log.error("[GHN] available-services error", ex);
        }
        return null;
    }

    private int requestGhnFee(Integer serviceId, Integer fromDistrictId, Integer toDistrictId,
                              String toWardCode, int weight, int length, int width, int height,
                              int insuranceValue) {

        String url = props.getBaseUrl() + "/v2/shipping-order/fee";

        Map<String, Object> body = new HashMap<>();
        body.put("shop_id", props.getShopId());
        body.put("service_id", serviceId);
        body.put("from_district_id", fromDistrictId);
        body.put("to_district_id", toDistrictId);
        body.put("to_ward_code", toWardCode);
        body.put("weight", weight);
        body.put("length", length);
        body.put("width",  width);
        body.put("height", height);
        if (insuranceValue > 0) body.put("insurance_value", insuranceValue);

        HttpHeaders h = new HttpHeaders();
        h.setContentType(MediaType.APPLICATION_JSON);
        h.set("Token", props.getToken());
        h.set("ShopId", String.valueOf(props.getShopId()));

        try {
            ResponseEntity<Map> res = restTemplate.exchange(url, HttpMethod.POST, new HttpEntity<>(body, h), Map.class);
            if (res.getStatusCode().is2xxSuccessful() && res.getBody() != null) {
                Object code = res.getBody().get("code");
                if (code instanceof Number n && n.intValue() == 200) {
                    Map<String, Object> data = (Map<String, Object>) res.getBody().get("data");
                    Object total = data != null ? data.get("total") : null;
                    return (total instanceof Number) ? ((Number) total).intValue() : 0;
                }
            }
            log.error("[GHN] fee payload unexpected: {}", res.getBody());
        } catch (HttpStatusCodeException ex) {
            log.error("[GHN] fee lỗi: {} - {}", ex.getStatusCode(), ex.getResponseBodyAsString());
        } catch (Exception ex) {
            log.error("[GHN] fee error", ex);
        }
        return 0;
    }
}
