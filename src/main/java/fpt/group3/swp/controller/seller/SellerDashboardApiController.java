package fpt.group3.swp.controller.seller;

import fpt.group3.swp.common.OrderStatus;
import fpt.group3.swp.domain.Order;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.Shop;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.reposirory.OrderRepo;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.ShopRepository;
import fpt.group3.swp.service.UserService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/seller/dashboard")
@RequiredArgsConstructor
public class SellerDashboardApiController {
    
    private final ShopRepository shopRepository;
    private final OrderRepo orderRepo;
    private final ProductRepository productRepository;
    private final UserService userService;
    
    /**
     * API lấy dữ liệu biểu đồ doanh thu và đơn hàng theo thời gian
     */
    @GetMapping("/sales-chart")
    public ResponseEntity<Map<String, Object>> getSalesChart(
            @RequestParam(required = false, defaultValue = "month") String period,
            Principal principal) {
        
        if (principal == null) {
            return ResponseEntity.status(401).build();
        }
        
        // Lấy shop của seller
        User user = userService.getUserByEmail(principal.getName());
        Shop shop = shopRepository.findByUser_Id(user.getId()).orElse(null);
        
        if (shop == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy shop"));
        }
        
        Map<String, Object> response = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Double> revenueData = new ArrayList<>();
        List<Integer> orderData = new ArrayList<>();
        
        // Lấy tất cả đơn hàng của shop
        List<Order> allOrders = orderRepo.findAllByShopId(shop.getId());
        
        switch (period) {
            case "today":
                // Hôm nay
                LocalDate today = LocalDate.now();
                labels.add("Hôm nay");
                
                List<Order> todayOrders = allOrders.stream()
                        .filter(o -> o.getCreatedAt() != null && o.getCreatedAt().equals(today))
                        .collect(Collectors.toList());
                
                double todayRevenue = todayOrders.stream()
                        .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                        .mapToDouble(Order::getTotalAmount)
                        .sum();
                
                revenueData.add(todayRevenue);
                orderData.add(todayOrders.size());
                break;
                
            case "week":
                // 7 ngày gần nhất
                for (int i = 6; i >= 0; i--) {
                    LocalDate date = LocalDate.now().minusDays(i);
                    labels.add(date.format(DateTimeFormatter.ofPattern("dd/MM")));
                    
                    List<Order> dayOrders = allOrders.stream()
                            .filter(o -> o.getCreatedAt() != null && o.getCreatedAt().equals(date))
                            .collect(Collectors.toList());
                    
                    double dayRevenue = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .mapToDouble(Order::getTotalAmount)
                            .sum();
                    
                    revenueData.add(dayRevenue);
                    orderData.add(dayOrders.size());
                }
                break;
                
            case "year":
                // 12 tháng gần nhất
                for (int i = 11; i >= 0; i--) {
                    LocalDate monthStart = LocalDate.now().minusMonths(i).withDayOfMonth(1);
                    LocalDate monthEnd = monthStart.plusMonths(1);
                    labels.add(monthStart.format(DateTimeFormatter.ofPattern("MM/yyyy")));
                    
                    List<Order> monthOrders = allOrders.stream()
                            .filter(o -> o.getCreatedAt() != null 
                                    && !o.getCreatedAt().isBefore(monthStart) 
                                    && o.getCreatedAt().isBefore(monthEnd))
                            .collect(Collectors.toList());
                    
                    double monthRevenue = monthOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .mapToDouble(Order::getTotalAmount)
                            .sum();
                    
                    revenueData.add(monthRevenue);
                    orderData.add(monthOrders.size());
                }
                break;
                
            case "month":
            default:
                // 30 ngày gần nhất
                for (int i = 29; i >= 0; i--) {
                    LocalDate date = LocalDate.now().minusDays(i);
                    labels.add(date.format(DateTimeFormatter.ofPattern("dd/MM")));
                    
                    List<Order> dayOrders = allOrders.stream()
                            .filter(o -> o.getCreatedAt() != null && o.getCreatedAt().equals(date))
                            .collect(Collectors.toList());
                    
                    double dayRevenue = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .mapToDouble(Order::getTotalAmount)
                            .sum();
                    
                    revenueData.add(dayRevenue);
                    orderData.add(dayOrders.size());
                }
                break;
        }
        
        // Tính tổng hợp
        double totalRevenue = revenueData.stream().mapToDouble(Double::doubleValue).sum();
        int totalOrders = orderData.stream().mapToInt(Integer::intValue).sum();
        
        response.put("labels", labels);
        response.put("revenueData", revenueData);
        response.put("orderData", orderData);
        
        // Thêm thống kê tổng hợp
        Map<String, Object> summary = new HashMap<>();
        summary.put("totalRevenue", totalRevenue);
        summary.put("totalOrders", totalOrders);
        summary.put("averageOrderValue", totalOrders > 0 ? totalRevenue / totalOrders : 0);
        
        response.put("summary", summary);
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * API xuất báo cáo Excel
     */
    @GetMapping("/export-report")
    public void exportReport(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false, defaultValue = "all") String reportType,
            Principal principal,
            HttpServletResponse response) throws IOException {
        
        if (principal == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        // Lấy shop của seller
        User user = userService.getUserByEmail(principal.getName());
        Shop shop = shopRepository.findByUser_Id(user.getId()).orElse(null);
        
        if (shop == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không tìm thấy shop");
            return;
        }
        
        // Set thời gian mặc định nếu không có
        if (startDate == null) {
            startDate = LocalDate.now().minusMonths(1);
        }
        if (endDate == null) {
            endDate = LocalDate.now();
        }
        
        // Tạo workbook
        Workbook workbook = new XSSFWorkbook();
        
        // Tạo styles
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 12);
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);
        
        // Tạo các sheet theo reportType
        if (reportType.equals("all") || reportType.equals("orders")) {
            createOrdersSheet(workbook, headerStyle, dataStyle, shop.getId(), startDate, endDate);
        }
        
        if (reportType.equals("all") || reportType.equals("products")) {
            createProductsSheet(workbook, headerStyle, dataStyle, shop.getId(), startDate, endDate);
        }
        
        if (reportType.equals("all") || reportType.equals("summary")) {
            createSummarySheet(workbook, headerStyle, dataStyle, shop.getId(), startDate, endDate);
        }
        
        // Set response headers
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String filename = "BaoCao_Shop_" + shop.getDisplayName() + "_" + startDate + "_" + endDate + ".xlsx";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        
        // Write to response
        workbook.write(response.getOutputStream());
        workbook.close();
    }
    
    private void createOrdersSheet(Workbook workbook, CellStyle headerStyle, CellStyle dataStyle,
                                   Long shopId, LocalDate startDate, LocalDate endDate) {
        Sheet sheet = workbook.createSheet("Đơn hàng");
        
        // Title
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("DANH SÁCH ĐƠN HÀNG");
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleCell.setCellStyle(titleStyle);
        
        Row periodRow = sheet.createRow(1);
        periodRow.createCell(0).setCellValue("Từ ngày " + startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + 
                " đến " + endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        
        sheet.createRow(2); // Empty row
        
        // Header
        Row headerRow = sheet.createRow(3);
        String[] headers = {"STT", "ID", "Khách hàng", "Email", "Tổng tiền", "Trạng thái", "Ngày tạo"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Set column widths
        sheet.setColumnWidth(0, 2000);
        sheet.setColumnWidth(1, 2500);
        sheet.setColumnWidth(2, 6000);
        sheet.setColumnWidth(3, 7000);
        sheet.setColumnWidth(4, 4000);
        sheet.setColumnWidth(5, 4000);
        sheet.setColumnWidth(6, 4000);
        
        // Data
        List<Order> orders = orderRepo.findAllByShopId(shopId).stream()
                .filter(o -> o.getCreatedAt() != null && 
                        !o.getCreatedAt().isBefore(startDate) &&
                        o.getCreatedAt().isBefore(endDate.plusDays(1)))
                .collect(Collectors.toList());
        
        int rowNum = 4;
        int stt = 1;
        double totalAmount = 0;
        
        for (Order order : orders) {
            Row row = sheet.createRow(rowNum++);
            
            row.createCell(0).setCellValue(stt++);
            row.createCell(1).setCellValue(order.getId());
            row.createCell(2).setCellValue(order.getUser() != null && order.getUser().getFullName() != null ? 
                    order.getUser().getFullName() : "");
            row.createCell(3).setCellValue(order.getUser() != null && order.getUser().getEmail() != null ? 
                    order.getUser().getEmail() : "");
            row.createCell(4).setCellValue(String.format("%,d", order.getTotalAmount()) + "₫");
            
            String status = "";
            if (order.getOrderStatus() == OrderStatus.PENDING_CONFIRM) status = "Chờ xác nhận";
            else if (order.getOrderStatus() == OrderStatus.PENDING_PAYMENT) status = "Chờ thanh toán";
            else if (order.getOrderStatus() == OrderStatus.PAID) {
                status = "Đã thanh toán";
                totalAmount += order.getTotalAmount();
            }
            else if (order.getOrderStatus() == OrderStatus.CANCELED) status = "Đã hủy";
            row.createCell(5).setCellValue(status);
            
            row.createCell(6).setCellValue(order.getCreatedAt() != null ? 
                    order.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "");
            
            for (int i = 0; i < 7; i++) {
                row.getCell(i).setCellStyle(dataStyle);
            }
        }
        
        // Summary
        Row summaryRow1 = sheet.createRow(rowNum + 1);
        Cell summaryCell1 = summaryRow1.createCell(0);
        summaryCell1.setCellValue("Tổng số đơn hàng: " + orders.size());
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        CellStyle boldStyle = workbook.createCellStyle();
        boldStyle.setFont(boldFont);
        summaryCell1.setCellStyle(boldStyle);
        
        Row summaryRow2 = sheet.createRow(rowNum + 2);
        Cell summaryCell2 = summaryRow2.createCell(0);
        summaryCell2.setCellValue("Tổng doanh thu: " + String.format("%,d", (int) totalAmount) + "₫");
        summaryCell2.setCellStyle(boldStyle);
    }
    
    private void createProductsSheet(Workbook workbook, CellStyle headerStyle, CellStyle dataStyle,
                                     Long shopId, LocalDate startDate, LocalDate endDate) {
        Sheet sheet = workbook.createSheet("Sản phẩm");
        
        // Title
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("DANH SÁCH SẢN PHẨM");
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleCell.setCellStyle(titleStyle);
        
        Row periodRow = sheet.createRow(1);
        periodRow.createCell(0).setCellValue("Sản phẩm của shop");
        
        sheet.createRow(2); // Empty row
        
        // Header
        Row headerRow = sheet.createRow(3);
        String[] headers = {"STT", "ID", "Tên sản phẩm", "Giá", "Trạng thái"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Set column widths
        sheet.setColumnWidth(0, 2000);
        sheet.setColumnWidth(1, 2500);
        sheet.setColumnWidth(2, 10000);
        sheet.setColumnWidth(3, 4000);
        sheet.setColumnWidth(4, 4000);
        
        // Data
        List<Product> products = productRepository.findAllByShop_IdOrderByUpdatedAtDesc(shopId);
        
        int rowNum = 4;
        int stt = 1;
        int activeCount = 0;
        
        for (Product product : products) {
            if (product.isDeleted()) continue;
            
            Row row = sheet.createRow(rowNum++);
            
            row.createCell(0).setCellValue(stt++);
            row.createCell(1).setCellValue(product.getId());
            row.createCell(2).setCellValue(product.getName() != null ? product.getName() : "");
            
            if (product.getPrice() != null) {
                row.createCell(3).setCellValue(String.format("%,.0f", product.getPrice()) + "₫");
            } else {
                row.createCell(3).setCellValue("0₫");
            }
            
            String statusText = "";
            if (product.getStatus() != null) {
                statusText = product.getStatus().toString().equals("ACTIVE") ? "Hoạt động" : "Không hoạt động";
                if (product.getStatus().toString().equals("ACTIVE")) {
                    activeCount++;
                }
            }
            row.createCell(4).setCellValue(statusText);
            
            for (int i = 0; i < 5; i++) {
                row.getCell(i).setCellStyle(dataStyle);
            }
        }
        
        // Summary
        Row summaryRow1 = sheet.createRow(rowNum + 1);
        Cell summaryCell1 = summaryRow1.createCell(0);
        summaryCell1.setCellValue("Tổng số sản phẩm: " + (stt - 1));
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        CellStyle boldStyle = workbook.createCellStyle();
        boldStyle.setFont(boldFont);
        summaryCell1.setCellStyle(boldStyle);
        
        Row summaryRow2 = sheet.createRow(rowNum + 2);
        Cell summaryCell2 = summaryRow2.createCell(0);
        summaryCell2.setCellValue("Sản phẩm đang hoạt động: " + activeCount);
        summaryCell2.setCellStyle(boldStyle);
    }
    
    private void createSummarySheet(Workbook workbook, CellStyle headerStyle, CellStyle dataStyle,
                                    Long shopId, LocalDate startDate, LocalDate endDate) {
        Sheet sheet = workbook.createSheet("Tổng quan");
        
        // Title
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO TỔNG QUAN SHOP");
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 16);
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleCell.setCellStyle(titleStyle);
        
        Row periodRow = sheet.createRow(1);
        periodRow.createCell(0).setCellValue("Từ ngày " + startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + 
                " đến " + endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        
        sheet.createRow(2); // Empty row
        
        // Statistics
        List<Order> allOrders = orderRepo.findAllByShopId(shopId);
        List<Order> periodOrders = allOrders.stream()
                .filter(o -> o.getCreatedAt() != null && 
                        !o.getCreatedAt().isBefore(startDate) &&
                        o.getCreatedAt().isBefore(endDate.plusDays(1)))
                .collect(Collectors.toList());
        
        double totalRevenue = periodOrders.stream()
                .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                .mapToDouble(Order::getTotalAmount)
                .sum();
        
        List<Product> allProducts = productRepository.findAllByShop_IdOrderByUpdatedAtDesc(shopId);
        long activeProducts = allProducts.stream().filter(p -> !p.isDeleted()).count();
        
        int rowNum = 3;
        
        // Header
        Row headerRow = sheet.createRow(rowNum++);
        Cell headerCell0 = headerRow.createCell(0);
        headerCell0.setCellValue("Chỉ số");
        headerCell0.setCellStyle(headerStyle);
        Cell headerCell1 = headerRow.createCell(1);
        headerCell1.setCellValue("Giá trị");
        headerCell1.setCellStyle(headerStyle);
        
        // Data rows
        addSummaryRow(sheet, rowNum++, "Tổng số đơn hàng", String.valueOf(allOrders.size()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Đơn hàng trong kỳ", String.valueOf(periodOrders.size()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Đơn hàng đã thanh toán", 
                String.valueOf(periodOrders.stream().filter(o -> o.getOrderStatus() == OrderStatus.PAID).count()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Doanh thu trong kỳ", String.format("%,.0f", totalRevenue) + "₫", dataStyle);
        
        sheet.createRow(rowNum++); // Empty row
        
        addSummaryRow(sheet, rowNum++, "Tổng số sản phẩm", String.valueOf(activeProducts), dataStyle);
        
        // Set column width
        sheet.setColumnWidth(0, 8000);
        sheet.setColumnWidth(1, 6000);
    }
    
    private void addSummaryRow(Sheet sheet, int rowNum, String label, String value, CellStyle dataStyle) {
        Row row = sheet.createRow(rowNum);
        Cell cell0 = row.createCell(0);
        cell0.setCellValue(label);
        cell0.setCellStyle(dataStyle);
        
        Cell cell1 = row.createCell(1);
        cell1.setCellValue(value);
        cell1.setCellStyle(dataStyle);
    }
}
