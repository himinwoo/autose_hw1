# autose_hw1 - YOLOv3 Object Detection

YOLOv3 딥러닝 네트워크를 사용한 객체 검출 시스템을 Docker로 패키징한 프로젝트입니다.

## 프로젝트 소개

이 프로젝트는 [Darknet](https://github.com/pjreddie/darknet) 프레임워크와 [YOLOv3](https://arxiv.org/abs/1804.02767) 모델을 사용하여 이미지 URL을 입력받아 객체를 검출하는 Docker 이미지입니다.

## Docker 이미지 사용 방법

### 기본 실행

```bash
docker run himinwoo/yolo <이미지_URL>
```

### 실행 예시

```bash
# 기차 이미지 검출
docker run himinwoo/yolo https://upload.wikimedia.org/wikipedia/commons/3/3b/SBB_Re_450_097_ZKB_Nachtnetz.jpg

# 고양이 이미지 검출
docker run himinwoo/yolo https://upload.wikimedia.org/wikipedia/commons/e/e5/Blue-eyed_domestic_cat_%28Felis_silvestris_catus%29.jpg

# 커피 이미지 검출
docker run himinwoo/yolo https://upload.wikimedia.org/wikipedia/commons/4/45/A_small_cup_of_coffee.JPG
```

## Dockerfile 설명

### 1. 베이스 이미지

```dockerfile
FROM ubuntu:latest
```

- Ubuntu 24.04를 기본 운영체제로 사용합니다.

### 2. 필요한 패키지 설치

```dockerfile
RUN apt-get update && apt-get install -y \
    git wget ca-certificates build-essential
```

- `git`: Darknet 소스코드를 다운로드하기 위해 필요
- `wget`: 이미지 URL 다운로드 및 가중치 파일 다운로드
- `build-essential`: C 컴파일러 등 빌드 도구
- `ca-certificates`: HTTPS 연결을 위한 인증서

### 3. Darknet 빌드

```dockerfile
RUN git clone https://github.com/pjreddie/darknet.git && \
    cd darknet && \
    make
```

- Darknet 프레임워크를 GitHub에서 다운로드
- `make` 명령어로 소스코드를 컴파일

### 4. YOLOv3 가중치 다운로드

```dockerfile
RUN cd darknet && \
    wget https://pjreddie.com/media/files/yolov3.weights
```

- 사전 학습된 YOLOv3 가중치 파일(~240MB)을 다운로드

### 5. 실행 스크립트 (ENTRYPOINT)

```dockerfile
ENTRYPOINT ["/bin/bash", "-c", "\
    wget -q -O input.jpg \"$0\"; \
    ./darknet detect cfg/yolov3.cfg yolov3.weights input.jpg -dont_show; \
    rm -f input.jpg predictions.jpg"]
```

- `$0`: 사용자가 입력한 이미지 URL
- `wget -q -O input.jpg "$0"`: URL에서 이미지를 다운로드하여 input.jpg로 저장
- `./darknet detect ...`: YOLOv3로 객체 검출 실행
- `rm -f ...`: 임시 파일 정리

## 링크

- **GitHub 저장소**: https://github.com/himinwoo/autose_hw1
- **Docker Hub 이미지**: https://hub.docker.com/r/himinwoo/yolo
- **Darknet 공식 페이지**: https://pjreddie.com/darknet/
- **YOLOv3 논문**: https://arxiv.org/abs/1804.02767

## 로컬에서 빌드

```bash
# 저장소 클론
git clone https://github.com/himinwoo/autose_hw1.git
cd autose_hw1

# Docker 이미지 빌드
docker build -t yolo .

# 실행
docker run yolo <이미지_URL>
```
