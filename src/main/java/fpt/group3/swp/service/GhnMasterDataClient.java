// fpt/group3/swp/service/GhnMasterDataClient.java
package fpt.group3.swp.service;

import fpt.group3.swp.config.GhnProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class GhnMasterDataClient {

    private final GhnProperties props;
    private final RestTemplate restTemplate;

    private HttpEntity<Void> headers() {
        HttpHeaders h = new HttpHeaders();
        h.set("Token", props.getToken());
        return new HttpEntity<>(h);
    }

    public List<Map<String, Object>> getProvinces() {
        ResponseEntity<Map> res = restTemplate.exchange(
                props.getBaseUrl() + "/master-data/province",
                HttpMethod.GET, headers(), Map.class
        );
        return (List<Map<String, Object>>) res.getBody().get("data");
    }

    public List<Map<String, Object>> getDistricts(Integer provinceId) {
        ResponseEntity<Map> res = restTemplate.exchange(
                props.getBaseUrl() + "/master-data/district?province_id=" + provinceId,
                HttpMethod.GET, headers(), Map.class
        );
        return (List<Map<String, Object>>) res.getBody().get("data");
    }

    public List<Map<String, Object>> getWards(Integer districtId) {
        ResponseEntity<Map> res = restTemplate.exchange(
                props.getBaseUrl() + "/master-data/ward?district_id=" + districtId,
                HttpMethod.GET, headers(), Map.class
        );
        return (List<Map<String, Object>>) res.getBody().get("data");
    }
}
