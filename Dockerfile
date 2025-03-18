# Sử dụng image Python 3.11 làm base image thay vì 3.12 để tránh các vấn đề tương thích với PyTorch
FROM python:3.11

# Cài đặt các gói phụ thuộc hệ thống:
# - ffmpeg: để xử lý video và audio
# - libsm6 và libxext6: thư viện cần thiết cho OpenCV
# - imagemagick: để xử lý hình ảnh
# - fonts-dejavu: font chữ cho việc render text
# Sau khi cài đặt, xóa cache apt để giảm kích thước image
RUN apt-get update && apt-get install -y \
    ffmpeg libsm6 libxext6 imagemagick fonts-dejavu \
    && rm -rf /var/lib/apt/lists/*

# Cấu hình ImageMagick để cho phép đọc và ghi file
# Mặc định, ImageMagick có các hạn chế bảo mật cần được điều chỉnh
RUN sed -i 's/none/read,write/g' /etc/ImageMagick-6/policy.xml

# Cập nhật pip lên phiên bản mới nhất
RUN pip install --upgrade pip
# Cài đặt virtualenv để tạo môi trường Python độc lập
RUN pip install virtualenv

# Tạo môi trường ảo Python trong thư mục /venv
RUN python -m venv /venv

# Thêm đường dẫn của môi trường ảo vào PATH
# Điều này đảm bảo các lệnh Python sẽ sử dụng môi trường ảo
ENV PATH="/venv/bin:$PATH"

# Thiết lập thư mục làm việc trong container là /app
WORKDIR /app

# Copy tất cả files từ thư mục hiện tại (context) vào /app trong container
COPY . .

# Cài đặt các thư viện Python được liệt kê trong requirements.txt
# --no-cache-dir giúp giảm kích thước của image
RUN pip install --no-cache-dir -r requirements.txt

# Cấp quyền đọc-ghi-thực thi cho tất cả files trong /app
# 777 cho phép tất cả users có thể đọc, ghi và thực thi
RUN chmod -R 777 /app

# Tạo file shell script để chạy cả FastAPI và Streamlit
# & ở cuối lệnh đầu tiên cho phép chạy nền
# wait ở cuối đảm bảo container không kết thúc khi process đầu chạy nền
RUN echo '#!/bin/bash\nuvicorn api:app --host 0.0.0.0 --port 8000 & \nstreamlit run app.py --server.port 8501 --server.address 0.0.0.0\nwait' > /app/start.sh
# Cấp quyền thực thi cho file shell script
RUN chmod +x /app/start.sh

# Lệnh mặc định khi container khởi động
# Chạy file shell script đã tạo ở trên
CMD ["/app/start.sh"]
