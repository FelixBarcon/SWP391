package fpt.group3.swp.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.util.*;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.ServletContext;

@Service
public class UploadService {
    private final ServletContext servletContext;

    public UploadService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    // Giữ nguyên để tương thích (single)
    public String handleSaveUploadFile(MultipartFile file, String targetFolder) {
        List<String> rs = handleSaveUploadFiles(new MultipartFile[]{file}, targetFolder);
        return rs.isEmpty() ? "" : rs.get(0);
    }

    // MỚI: lưu nhiều file
    public List<String> handleSaveUploadFiles(MultipartFile[] files, String targetFolder) {
        List<String> saved = new ArrayList<>();
        if (files == null || files.length == 0) return saved;

        String rootPath = this.servletContext.getRealPath("/resources/images");
        Path dir = Paths.get(rootPath, targetFolder);
        try {
            Files.createDirectories(dir);
        } catch (IOException e) {
            throw new RuntimeException("Cannot create upload dir: " + dir, e);
        }

        for (MultipartFile file : files) {
            if (file == null || file.isEmpty()) continue;

            // Lấy đuôi file an toàn
            String original = Optional.ofNullable(file.getOriginalFilename()).orElse("file");
            String ext = "";
            int dot = original.lastIndexOf('.');
            if (dot >= 0) ext = original.substring(dot);

            // Tên file duy nhất
            String finalName = UUID.randomUUID().toString() + ext;

            Path dest = dir.resolve(finalName);
            try (InputStream in = file.getInputStream()) {
                Files.copy(in, dest, StandardCopyOption.REPLACE_EXISTING);
                saved.add(finalName);
            } catch (IOException e) {
                // Tùy bạn: log hoặc ném exception
                e.printStackTrace();
            }
        }
        return saved;
    }
}
