# ============================================
# Stage 1: 빌드 스테이지 (원본 소스 + 빌드 도구)
# ============================================
FROM python:3.10-slim AS builder

WORKDIR /app

# 빌드 도구 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

# Python 패키지 설치
RUN pip install --no-cache-dir cython pyarmor

# 소스 코드 복사
COPY src/ ./src/
COPY interface.py setup_cython.py ./

# Cython 빌드
RUN python setup_cython.py build_ext --inplace

# PyArmor 난독화
RUN pyarmor gen -O protected interface.py src/utils.py

# protected 폴더에 필요한 파일 복사
RUN mkdir -p protected/src/core && \
    cp src/core/*.so protected/src/core/ && \
    cp src/core/__init__.py protected/src/core/ && \
    cp src/__init__.py protected/src/ && \
    mv protected/utils.py protected/src/

# ============================================
# Stage 2: 실행 스테이지 (보호된 코드만 포함)
# ============================================
FROM python:3.10-slim

WORKDIR /app

# 빌드 스테이지에서 보호된 코드만 복사
COPY --from=builder /app/protected/ ./

CMD ["python", "interface.py"]
