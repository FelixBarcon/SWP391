// fpt/group3/swp/controller/client/ShippingController.java
package fpt.group3.swp.controller.client;

import fpt.group3.swp.domain.dto.FeeCalcRequestGHN;
import fpt.group3.swp.domain.dto.FeeCalcResponse;
import fpt.group3.swp.service.GhnMasterDataClient;
import fpt.group3.swp.service.GhnShippingService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/shipping/ghn")
@RequiredArgsConstructor
public class ShippingController {
    private final GhnMasterDataClient ghnClient;
    private final GhnShippingService ghnShippingService;

    @GetMapping("/provinces")
    public List<Map<String, Object>> provinces() { return ghnClient.getProvinces(); }

    @GetMapping("/districts")
    public List<Map<String, Object>> districts(@RequestParam Integer provinceId) {
        return ghnClient.getDistricts(provinceId);
    }

    @GetMapping("/wards")
    public List<Map<String, Object>> wards(@RequestParam Integer districtId) {
        return ghnClient.getWards(districtId);
    }

    @PostMapping("/fee")
    public FeeCalcResponse calcFee(@RequestBody FeeCalcRequestGHN req) {
        return ghnShippingService.calcFeeFromFixedOrigin(req);
    }
}
