# YOLOv3 Object Detection with Darknet
FROM ubuntu:latest

# 환경 변수 설정 (대화형 프롬프트 방지)
ENV DEBIAN_FRONTEND=noninteractive

# 필요한 패키지 설치 (OpenCV 제외, 기본 패키지만)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    wget \
    ca-certificates \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /app

# Darknet 클론 및 빌드
RUN git clone https://github.com/pjreddie/darknet.git && \
    cd darknet && \
    make

# YOLOv3 가중치 다운로드
RUN cd darknet && \
    wget https://pjreddie.com/media/files/yolov3.weights

# ENTRYPOINT 설정 (스크립트 파일 없이 직접 실행)
WORKDIR /app/darknet
ENTRYPOINT ["/bin/bash", "-c", "\
    wget -q -O input.jpg \"$0\"; \
    ./darknet detect cfg/yolov3.cfg yolov3.weights input.jpg -dont_show; \
    rm -f input.jpg predictions.jpg"]
