// fpt/group3/swp/service/GhnShippingService.java
package fpt.group3.swp.service;

import fpt.group3.swp.config.GhnProperties;
import fpt.group3.swp.domain.CartDetail;
import fpt.group3.swp.domain.dto.FeeCalcRequestGHN;
import fpt.group3.swp.domain.dto.FeeCalcResponse;
import fpt.group3.swp.reposirory.CartDetailRepo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class GhnShippingService {
    private final GhnProperties props;
    private final CartDetailRepo cartDetailRepo;
    private final RestTemplate restTemplate;

    @Value("${shipping.default-weight-gram:200}") private int defaultWeight;
    @Value("${shipping.use-insurance:false}")     private boolean useInsurance;

    public FeeCalcResponse calcFeeFromFixedOrigin(FeeCalcRequestGHN req) {
        List<CartDetail> lines = cartDetailRepo.findAllById(req.getCartDetailIds());
        if (lines.isEmpty()) throw new IllegalArgumentException("Không có sản phẩm hợp lệ");

        int weight = lines.stream().mapToInt(cd -> cd.getQuantity() * defaultWeight).sum();
        int insuranceValue = 0;
        if (useInsurance) {
            insuranceValue = (int) Math.round(lines.stream()
                    .mapToDouble(cd -> cd.getPrice() * cd.getQuantity()).sum());
        }

        Integer serviceId = pickFirstAvailableService(props.getFixedFromDistrictId(), req.getToDistrictId());
        if (serviceId == null) {
            log.warn("[GHN] No available service from {} -> {}", props.getFixedFromDistrictId(), req.getToDistrictId());
            FeeCalcResponse r = new FeeCalcResponse();
            r.setTotalFee(0);
            r.setShops(List.of());
            return r;
        }

        int fee = requestGhnFee(serviceId, props.getFixedFromDistrictId(), req.getToDistrictId(),
                req.getToWardCode(), weight, insuranceValue);

        FeeCalcResponse resp = new FeeCalcResponse();
        resp.setTotalFee(fee);

        FeeCalcResponse.ShopFee sf = new FeeCalcResponse.ShopFee();
        sf.setShopId(0L);
        sf.setShopName("Kho cố định");
        sf.setServiceTypeId(serviceId);
        sf.setFee(fee);
        resp.setShops(List.of(sf));
        return resp;
    }

    private Integer pickFirstAvailableService(Integer fromDistrict, Integer toDistrict) {
        String url = props.getBaseUrl() + "/v2/shipping-order/available-services";
        Map<String, Object> body = new HashMap<>();
        body.put("shop_id", props.getShopId());
        body.put("from_district", fromDistrict);
        body.put("to_district", toDistrict);

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
                              String toWardCode, int weight, int insuranceValue) {

        String url = props.getBaseUrl() + "/v2/shipping-order/fee";

        Map<String, Object> body = new HashMap<>();
        body.put("shop_id", props.getShopId());
        body.put("service_id", serviceId);
        body.put("from_district_id", fromDistrictId);
        body.put("to_district_id", toDistrictId);
        body.put("to_ward_code", toWardCode);
        body.put("weight", weight);
        body.put("length", 20);
        body.put("width", 10);
        body.put("height", 10);
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