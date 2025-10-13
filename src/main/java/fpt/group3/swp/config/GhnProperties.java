// fpt/group3/swp/config/GhnProperties.java
package fpt.group3.swp.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter @Setter
@Component
@ConfigurationProperties(prefix = "ghn")
public class GhnProperties {
    private String baseUrl;

    private String token;

    private Integer shopId;

    private Integer fixedFromDistrictId;
    private String  fixedFromWardCode;
}
