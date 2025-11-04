package fpt.group3.swp.controller.admin;

import fpt.group3.swp.common.OrderStatus;
import fpt.group3.swp.domain.Order;
import fpt.group3.swp.domain.Product;
import fpt.group3.swp.domain.User;
import fpt.group3.swp.reposirory.OrderRepo;
import fpt.group3.swp.reposirory.ProductRepository;
import fpt.group3.swp.reposirory.UserRepository;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/dashboard")
public class AdminDashboardApiController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private OrderRepo orderRepo;
    
    @Autowired
    private ProductRepository productRepository;
    
    // API lấy dữ liệu biểu đồ đơn hàng theo khoảng thời gian
    @GetMapping("/user-activity-chart")
    public ResponseEntity<Map<String, Object>> getUserActivityChart(
            @RequestParam(required = false, defaultValue = "month") String period) {
        
        Map<String, Object> response = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Integer> pendingOrdersData = new ArrayList<>();
        List<Integer> paidOrdersData = new ArrayList<>();
        List<Integer> canceledOrdersData = new ArrayList<>();
        List<Integer> totalOrdersData = new ArrayList<>();
        List<Double> revenueData = new ArrayList<>();
        
        // Lấy tất cả đơn hàng một lần
        List<Order> allOrders = orderRepo.findAll();
        
        switch (period) {
            case "today":
                // 24 giờ gần nhất - nhóm theo ngày vì createdAt là LocalDate
                LocalDate today = LocalDate.now();
                labels.add("Hôm nay");
                
                List<Order> todayOrders = allOrders.stream()
                        .filter(o -> o.getCreatedAt() != null && o.getCreatedAt().equals(today))
                        .collect(Collectors.toList());
                
                long todayPaidOrders = todayOrders.stream()
                        .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                        .count();
                
                long todayCanceledOrders = todayOrders.stream()
                        .filter(o -> o.getOrderStatus() == OrderStatus.CANCELED)
                        .count();
                
                long todayPendingOrders = todayOrders.stream()
                        .filter(o -> o.getOrderStatus() == OrderStatus.PENDING_CONFIRM 
                                    || o.getOrderStatus() == OrderStatus.PENDING_PAYMENT)
                        .count();
                
                double todayRevenue = todayOrders.stream()
                        .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                        .mapToDouble(Order::getTotalAmount)
                        .sum();
                
                pendingOrdersData.add((int) todayPendingOrders);
                paidOrdersData.add((int) todayPaidOrders);
                canceledOrdersData.add((int) todayCanceledOrders);
                totalOrdersData.add(todayOrders.size());
                revenueData.add(todayRevenue);
                break;
                
            case "week":
                // 7 ngày gần nhất
                for (int i = 6; i >= 0; i--) {
                    LocalDate date = LocalDate.now().minusDays(i);
                    labels.add(date.format(DateTimeFormatter.ofPattern("dd/MM")));
                    
                    List<Order> dayOrders = allOrders.stream()
                            .filter(o -> o.getCreatedAt() != null && o.getCreatedAt().equals(date))
                            .collect(Collectors.toList());
                    
                    long dayPaidOrders = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .count();
                    
                    long dayCanceledOrders = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.CANCELED)
                            .count();
                    
                    long dayPendingOrders = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PENDING_CONFIRM 
                                        || o.getOrderStatus() == OrderStatus.PENDING_PAYMENT)
                            .count();
                    
                    double dayRevenue = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .mapToDouble(Order::getTotalAmount)
                            .sum();
                    
                    pendingOrdersData.add((int) dayPendingOrders);
                    paidOrdersData.add((int) dayPaidOrders);
                    canceledOrdersData.add((int) dayCanceledOrders);
                    totalOrdersData.add(dayOrders.size());
                    revenueData.add(dayRevenue);
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
                    
                    long monthPaidOrders = monthOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .count();
                    
                    long monthCanceledOrders = monthOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.CANCELED)
                            .count();
                    
                    long monthPendingOrders = monthOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PENDING_CONFIRM 
                                        || o.getOrderStatus() == OrderStatus.PENDING_PAYMENT)
                            .count();
                    
                    double monthRevenue = monthOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .mapToDouble(Order::getTotalAmount)
                            .sum();
                    
                    pendingOrdersData.add((int) monthPendingOrders);
                    paidOrdersData.add((int) monthPaidOrders);
                    canceledOrdersData.add((int) monthCanceledOrders);
                    totalOrdersData.add(monthOrders.size());
                    revenueData.add(monthRevenue);
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
                    
                    long dayPaidOrders = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .count();
                    
                    long dayCanceledOrders = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.CANCELED)
                            .count();
                    
                    long dayPendingOrders = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PENDING_CONFIRM 
                                        || o.getOrderStatus() == OrderStatus.PENDING_PAYMENT)
                            .count();
                    
                    double dayRevenue = dayOrders.stream()
                            .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                            .mapToDouble(Order::getTotalAmount)
                            .sum();
                    
                    pendingOrdersData.add((int) dayPendingOrders);
                    paidOrdersData.add((int) dayPaidOrders);
                    canceledOrdersData.add((int) dayCanceledOrders);
                    totalOrdersData.add(dayOrders.size());
                    revenueData.add(dayRevenue);
                }
                break;
        }
        
        // Tính tổng hợp
        int totalOrders = totalOrdersData.stream().mapToInt(Integer::intValue).sum();
        int totalPending = pendingOrdersData.stream().mapToInt(Integer::intValue).sum();
        int totalPaid = paidOrdersData.stream().mapToInt(Integer::intValue).sum();
        int totalCanceled = canceledOrdersData.stream().mapToInt(Integer::intValue).sum();
        double totalRevenue = revenueData.stream().mapToDouble(Double::doubleValue).sum();
        
        response.put("labels", labels);
        response.put("pendingOrders", pendingOrdersData);
        response.put("paidOrders", paidOrdersData);
        response.put("canceledOrders", canceledOrdersData);
        response.put("totalOrdersData", totalOrdersData);
        response.put("revenueData", revenueData);
        
        // Thêm thống kê tổng hợp
        Map<String, Object> summary = new HashMap<>();
        summary.put("totalOrders", totalOrders);
        summary.put("totalPending", totalPending);
        summary.put("totalPaid", totalPaid);
        summary.put("totalCanceled", totalCanceled);
        summary.put("totalRevenue", totalRevenue);
        summary.put("successRate", totalOrders > 0 ? (totalPaid * 100.0 / totalOrders) : 0);
        summary.put("cancelRate", totalOrders > 0 ? (totalCanceled * 100.0 / totalOrders) : 0);
        
        response.put("summary", summary);
        
        return ResponseEntity.ok(response);
    }
    
    // API xuất báo cáo Excel
    @GetMapping("/export-report")
    public void exportReport(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false, defaultValue = "all") String reportType,
            HttpServletResponse response) throws IOException {
        
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
        
        LocalDateTime startDateTime = startDate.atStartOfDay();
        LocalDateTime endDateTime = endDate.plusDays(1).atStartOfDay();
        
        // Tạo các sheet theo reportType
        // Lưu ý: "all" chỉ xuất summary + orders + products (không xuất users vì không filter được theo thời gian)
        if (reportType.equals("users")) {
            createUsersSheet(workbook, headerStyle, dataStyle, startDateTime, endDateTime);
        }
        
        if (reportType.equals("all") || reportType.equals("orders")) {
            createOrdersSheet(workbook, headerStyle, dataStyle, startDateTime, endDateTime);
        }
        
        if (reportType.equals("all") || reportType.equals("products")) {
            createProductsSheet(workbook, headerStyle, dataStyle, startDateTime, endDateTime);
        }
        
        if (reportType.equals("all") || reportType.equals("summary")) {
            createSummarySheet(workbook, headerStyle, dataStyle, startDateTime, endDateTime);
        }
        
        // Set response headers
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String filename = "BaoCao_" + startDate + "_" + endDate + ".xlsx";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
        
        // Write to response
        workbook.write(response.getOutputStream());
        workbook.close();
    }
    
    private void createUsersSheet(Workbook workbook, CellStyle headerStyle, CellStyle dataStyle,
                                  LocalDateTime startDate, LocalDateTime endDate) {
        Sheet sheet = workbook.createSheet("Người dùng");
        
        // Title with period
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("DANH SÁCH NGƯỜI DÙNG");
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleCell.setCellStyle(titleStyle);
        
        Row periodRow = sheet.createRow(1);
        Cell periodCell = periodRow.createCell(0);
        periodCell.setCellValue("Tổng số người dùng trong hệ thống (User không có thông tin ngày tạo)");
        
        // Empty row
        sheet.createRow(2);
        
        // Header
        Row headerRow = sheet.createRow(3);
        String[] headers = {"STT", "ID", "Email", "Họ tên", "Số điện thoại", "Vai trò", "Trạng thái"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Set column widths
        sheet.setColumnWidth(0, 2000);  // STT
        sheet.setColumnWidth(1, 2500);  // ID
        sheet.setColumnWidth(2, 7000);  // Email
        sheet.setColumnWidth(3, 6000);  // Họ tên
        sheet.setColumnWidth(4, 4000);  // SĐT
        sheet.setColumnWidth(5, 4000);  // Vai trò
        sheet.setColumnWidth(6, 4000);  // Trạng thái
        
        // Data - lấy tất cả users (User không có createdAt để filter theo thời gian)
        List<User> users = userRepository.findAll();
        
        int rowNum = 4;
        int stt = 1;
        for (User user : users) {
            Row row = sheet.createRow(rowNum++);
            
            Cell cell0 = row.createCell(0);
            cell0.setCellValue(stt++);
            cell0.setCellStyle(dataStyle);
            
            Cell cell1 = row.createCell(1);
            cell1.setCellValue(user.getId());
            cell1.setCellStyle(dataStyle);
            
            Cell cell2 = row.createCell(2);
            cell2.setCellValue(user.getEmail() != null ? user.getEmail() : "");
            cell2.setCellStyle(dataStyle);
            
            Cell cell3 = row.createCell(3);
            cell3.setCellValue(user.getFullName() != null ? user.getFullName() : "");
            cell3.setCellStyle(dataStyle);
            
            Cell cell4 = row.createCell(4);
            cell4.setCellValue(user.getPhone() != null ? user.getPhone() : "");
            cell4.setCellStyle(dataStyle);
            
            Cell cell5 = row.createCell(5);
            cell5.setCellValue(user.getRole() != null ? user.getRole().getName() : "");
            cell5.setCellStyle(dataStyle);
            
            Cell cell6 = row.createCell(6);
            cell6.setCellValue(user.isActive() ? "Hoạt động" : "Không hoạt động");
            cell6.setCellStyle(dataStyle);
        }
        
        // Summary row
        Row summaryRow = sheet.createRow(rowNum + 1);
        Cell summaryCell = summaryRow.createCell(0);
        summaryCell.setCellValue("Tổng số người dùng: " + users.size());
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        CellStyle boldStyle = workbook.createCellStyle();
        boldStyle.setFont(boldFont);
        summaryCell.setCellStyle(boldStyle);
    }
    
    private void createOrdersSheet(Workbook workbook, CellStyle headerStyle, CellStyle dataStyle,
                                   LocalDateTime startDate, LocalDateTime endDate) {
        Sheet sheet = workbook.createSheet("Đơn hàng");
        
        // Title with period
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("DANH SÁCH ĐỖN HÀNG");
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleCell.setCellStyle(titleStyle);
        
        Row periodRow = sheet.createRow(1);
        Cell periodCell = periodRow.createCell(0);
        periodCell.setCellValue("Từ ngày " + startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + 
                " đến " + endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        
        // Empty row
        sheet.createRow(2);
        
        // Header
        Row headerRow = sheet.createRow(3);
        String[] headers = {"STT", "ID", "Khách hàng", "Email", "Tổng tiền", "Trạng thái", "Ngày tạo"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Set column widths
        sheet.setColumnWidth(0, 2000);  // STT
        sheet.setColumnWidth(1, 2500);  // ID
        sheet.setColumnWidth(2, 6000);  // Khách hàng
        sheet.setColumnWidth(3, 7000);  // Email
        sheet.setColumnWidth(4, 4000);  // Tổng tiền
        sheet.setColumnWidth(5, 4000);  // Trạng thái
        sheet.setColumnWidth(6, 4000);  // Ngày tạo
        
        // Data - filter by LocalDate range
        LocalDate startLocalDate = startDate.toLocalDate();
        LocalDate endLocalDate = endDate.toLocalDate();
        
        List<Order> orders = orderRepo.findAll().stream()
                .filter(o -> o.getCreatedAt() != null && 
                        !o.getCreatedAt().isBefore(startLocalDate) &&
                        o.getCreatedAt().isBefore(endLocalDate))
                .collect(Collectors.toList());
        
        int rowNum = 4;
        int stt = 1;
        double totalAmount = 0;
        
        for (Order order : orders) {
            Row row = sheet.createRow(rowNum++);
            
            Cell cell0 = row.createCell(0);
            cell0.setCellValue(stt++);
            cell0.setCellStyle(dataStyle);
            
            Cell cell1 = row.createCell(1);
            cell1.setCellValue(order.getId());
            cell1.setCellStyle(dataStyle);
            
            Cell cell2 = row.createCell(2);
            cell2.setCellValue(order.getUser() != null && order.getUser().getFullName() != null ? 
                    order.getUser().getFullName() : "");
            cell2.setCellStyle(dataStyle);
            
            Cell cell3 = row.createCell(3);
            cell3.setCellValue(order.getUser() != null && order.getUser().getEmail() != null ? 
                    order.getUser().getEmail() : "");
            cell3.setCellStyle(dataStyle);
            
            Cell cell4 = row.createCell(4);
            cell4.setCellValue(String.format("%,d", Integer.valueOf(order.getTotalAmount())) + "₫");
            cell4.setCellStyle(dataStyle);
            
            Cell cell5 = row.createCell(5);
            String status = "";
            if (order.getOrderStatus() == OrderStatus.PENDING_CONFIRM) status = "Chờ xác nhận";
            else if (order.getOrderStatus() == OrderStatus.PENDING_PAYMENT) status = "Chờ thanh toán";
            else if (order.getOrderStatus() == OrderStatus.PAID) {
                status = "Đã thanh toán";
                totalAmount += order.getTotalAmount();
            }
            else if (order.getOrderStatus() == OrderStatus.CANCELED) status = "Đã hủy";
            cell5.setCellValue(status);
            cell5.setCellStyle(dataStyle);
            
            Cell cell6 = row.createCell(6);
            cell6.setCellValue(order.getCreatedAt() != null ? 
                    order.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "");
            cell6.setCellStyle(dataStyle);
        }
        
        // Summary rows
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
        summaryCell2.setCellValue("Tổng doanh thu (đơn đã thanh toán): " + String.format("%,d", (int) totalAmount) + "₫");
        summaryCell2.setCellStyle(boldStyle);
    }
    
    private void createProductsSheet(Workbook workbook, CellStyle headerStyle, CellStyle dataStyle,
                                     LocalDateTime startDate, LocalDateTime endDate) {
        Sheet sheet = workbook.createSheet("Sản phẩm");
        
        // Title with period
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
        Cell periodCell = periodRow.createCell(0);
        periodCell.setCellValue("Từ ngày " + startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + 
                " đến " + endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        
        // Empty row
        sheet.createRow(2);
        
        // Header
        Row headerRow = sheet.createRow(3);
        String[] headers = {"STT", "ID", "Tên sản phẩm", "Giá", "Trạng thái", "Shop", "Trạng thái xóa", "Ngày tạo"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // Set column widths
        sheet.setColumnWidth(0, 2000);  // STT
        sheet.setColumnWidth(1, 2500);  // ID
        sheet.setColumnWidth(2, 8000);  // Tên sản phẩm
        sheet.setColumnWidth(3, 4000);  // Giá
        sheet.setColumnWidth(4, 4000);  // Trạng thái
        sheet.setColumnWidth(5, 5000);  // Shop
        sheet.setColumnWidth(6, 4000);  // Trạng thái xóa
        sheet.setColumnWidth(7, 5000);  // Ngày tạo
        
        // Data - filter by LocalDateTime range (bao gồm cả sản phẩm đã xóa)
        List<Product> products = productRepository.findAll().stream()
                .filter(p -> p.getCreatedAt() != null && 
                        !p.getCreatedAt().isBefore(startDate) &&
                        p.getCreatedAt().isBefore(endDate))
                .collect(Collectors.toList());
        
        int rowNum = 4;
        int stt = 1;
        int activeCount = 0;
        int deletedCount = 0;
        
        for (Product product : products) {
            Row row = sheet.createRow(rowNum++);
            
            Cell cell0 = row.createCell(0);
            cell0.setCellValue(stt++);
            cell0.setCellStyle(dataStyle);
            
            Cell cell1 = row.createCell(1);
            cell1.setCellValue(product.getId());
            cell1.setCellStyle(dataStyle);
            
            Cell cell2 = row.createCell(2);
            cell2.setCellValue(product.getName() != null ? product.getName() : "");
            cell2.setCellStyle(dataStyle);
            
            Cell cell3 = row.createCell(3);
            if (product.getPrice() != null) {
                cell3.setCellValue(String.format("%,.0f", product.getPrice()) + "₫");
            } else {
                cell3.setCellValue("0₫");
            }
            cell3.setCellStyle(dataStyle);
            
            Cell cell4 = row.createCell(4);
            String statusText = "";
            if (product.getStatus() != null) {
                statusText = product.getStatus().toString().equals("ACTIVE") ? "Hoạt động" : "Không hoạt động";
                if (product.getStatus().toString().equals("ACTIVE") && !product.isDeleted()) {
                    activeCount++;
                }
            }
            cell4.setCellValue(statusText);
            cell4.setCellStyle(dataStyle);
            
            Cell cell5 = row.createCell(5);
            cell5.setCellValue(product.getShop() != null && product.getShop().getDisplayName() != null ? 
                    product.getShop().getDisplayName() : "");
            cell5.setCellStyle(dataStyle);
            
            // Thêm cột trạng thái xóa
            Cell cell6 = row.createCell(6);
            String deleteStatus = product.isDeleted() ? "Đã xóa" : "Còn hoạt động";
            cell6.setCellValue(deleteStatus);
            cell6.setCellStyle(dataStyle);
            if (product.isDeleted()) {
                deletedCount++;
            }
            
            Cell cell7 = row.createCell(7);
            cell7.setCellValue(product.getCreatedAt() != null ? 
                    product.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "");
            cell7.setCellStyle(dataStyle);
        }
        
        // Summary rows
        Row summaryRow1 = sheet.createRow(rowNum + 1);
        Cell summaryCell1 = summaryRow1.createCell(0);
        summaryCell1.setCellValue("Tổng số sản phẩm: " + products.size());
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        CellStyle boldStyle = workbook.createCellStyle();
        boldStyle.setFont(boldFont);
        summaryCell1.setCellStyle(boldStyle);
        
        Row summaryRow2 = sheet.createRow(rowNum + 2);
        Cell summaryCell2 = summaryRow2.createCell(0);
        summaryCell2.setCellValue("Sản phẩm đang hoạt động: " + activeCount);
        summaryCell2.setCellStyle(boldStyle);
        
        Row summaryRow3 = sheet.createRow(rowNum + 3);
        Cell summaryCell3 = summaryRow3.createCell(0);
        summaryCell3.setCellValue("Sản phẩm đã xóa: " + deletedCount);
        summaryCell3.setCellStyle(boldStyle);
    }
    
    private void createSummarySheet(Workbook workbook, CellStyle headerStyle, CellStyle dataStyle,
                                    LocalDateTime startDate, LocalDateTime endDate) {
        Sheet sheet = workbook.createSheet("Tổng quan");
        
        // Title
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO TỔNG QUAN HỆ THỐNG");
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 16);
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleCell.setCellStyle(titleStyle);
        
        // Period
        Row periodRow = sheet.createRow(1);
        Cell periodCell = periodRow.createCell(0);
        periodCell.setCellValue("Từ ngày " + startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + 
                " đến " + endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        
        // Empty row
        sheet.createRow(2);
        
        // Statistics
        List<User> allUsers = userRepository.findAll();
        
        List<Order> allOrders = orderRepo.findAll();
        LocalDate startLocalDate = startDate.toLocalDate();
        LocalDate endLocalDate = endDate.toLocalDate();
        
        List<Order> periodOrders = allOrders.stream()
                .filter(o -> o.getCreatedAt() != null && 
                        !o.getCreatedAt().isBefore(startLocalDate) &&
                        o.getCreatedAt().isBefore(endLocalDate))
                .collect(Collectors.toList());
        
        double totalRevenue = periodOrders.stream()
                .filter(o -> o.getOrderStatus() == OrderStatus.PAID)
                .mapToDouble(Order::getTotalAmount)
                .sum();
        
        // Lấy tất cả sản phẩm trong kỳ (bao gồm cả đã xóa)
        List<Product> periodProducts = productRepository.findAll().stream()
                .filter(p -> p.getCreatedAt() != null && 
                        !p.getCreatedAt().isBefore(startDate) &&
                        p.getCreatedAt().isBefore(endDate))
                .collect(Collectors.toList());
        
        // Thống kê chi tiết
        long periodProductsActive = periodProducts.stream()
                .filter(p -> !p.isDeleted() && p.getStatus() != null 
                        && p.getStatus().toString().equals("ACTIVE"))
                .count();
        long periodProductsDeleted = periodProducts.stream()
                .filter(Product::isDeleted)
                .count();
        
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
        addSummaryRow(sheet, rowNum++, "Tổng số người dùng", String.valueOf(allUsers.size()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Người dùng hoạt động", 
                String.valueOf(allUsers.stream().filter(User::isActive).count()), dataStyle);
        
        sheet.createRow(rowNum++); // Empty row
        
        addSummaryRow(sheet, rowNum++, "Tổng số đơn hàng (toàn hệ thống)", String.valueOf(allOrders.size()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Đơn hàng trong kỳ", String.valueOf(periodOrders.size()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Đơn hàng đã thanh toán (trong kỳ)", 
                String.valueOf(periodOrders.stream().filter(o -> o.getOrderStatus() == OrderStatus.PAID).count()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Đơn hàng chờ xử lý (trong kỳ)", 
                String.valueOf(periodOrders.stream().filter(o -> o.getOrderStatus() == OrderStatus.PENDING_CONFIRM 
                        || o.getOrderStatus() == OrderStatus.PENDING_PAYMENT).count()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Đơn hàng đã hủy (trong kỳ)", 
                String.valueOf(periodOrders.stream().filter(o -> o.getOrderStatus() == OrderStatus.CANCELED).count()), dataStyle);
        addSummaryRow(sheet, rowNum++, "Doanh thu trong kỳ", String.format("%,.0f", totalRevenue) + "₫", dataStyle);
        
        sheet.createRow(rowNum++); // Empty row
        
        // Thống kê sản phẩm chi tiết
        List<Product> allProducts = productRepository.findAll();
        long totalProducts = allProducts.size();
        long totalActiveProducts = allProducts.stream().filter(p -> !p.isDeleted()).count();
        long totalDeletedProducts = allProducts.stream().filter(Product::isDeleted).count();
        
        addSummaryRow(sheet, rowNum++, "Tổng số sản phẩm (toàn hệ thống)", String.valueOf(totalProducts), dataStyle);
        addSummaryRow(sheet, rowNum++, "  - Sản phẩm còn hoạt động", String.valueOf(totalActiveProducts), dataStyle);
        addSummaryRow(sheet, rowNum++, "  - Sản phẩm đã xóa", String.valueOf(totalDeletedProducts), dataStyle);
        addSummaryRow(sheet, rowNum++, "Sản phẩm mới trong kỳ", String.valueOf(periodProducts.size()), dataStyle);
        addSummaryRow(sheet, rowNum++, "  - Hoạt động trong kỳ", String.valueOf(periodProductsActive), dataStyle);
        addSummaryRow(sheet, rowNum++, "  - Đã xóa trong kỳ", String.valueOf(periodProductsDeleted), dataStyle);
        
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
