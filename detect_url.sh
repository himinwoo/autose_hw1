#!/bin/bash

# URL이 인자로 제공되지 않으면 에러 메시지 출력
if [ -z "$1" ]; then
    echo "Usage: docker run <image> <image_url>"
    exit 1
fi

IMAGE_URL="$1"

# 작업 디렉토리로 이동
cd /app/darknet

# URL에서 이미지 다운로드
echo "Downloading image from $IMAGE_URL..."
wget -q -O input.jpg "$IMAGE_URL"

if [ ! -f input.jpg ]; then
    echo "Failed to download image from $IMAGE_URL"
    exit 1
fi

# YOLOv3 객체 검출 실행
./darknet detect cfg/yolov3.cfg yolov3.weights input.jpg -dont_show

# 정리
rm -f input.jpg predictions.jpg
