# ---------- build stage ----------
FROM --platform=amd64 ubuntu:24.04 AS builder

# RUN apt-get update && apt-get install -y \
#     g++ cmake make git libboost-all-dev libssl-dev pkg-config libpq-dev libpqxx-dev

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libboost-all-dev \
    libssl-dev \
    libpq-dev \
    libpqxx-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN rm -rf build && \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build -j2

RUN strip build/RESTApi
RUN strip /app/ext/quantlib/lib/ubuntu/amd64/libQuantLib.so.1.42.0

# ---------- runtime stage ----------
FROM --platform=amd64 ubuntu:24.04


# RUN apt-get update && apt-get install -y \
#     libssl3 libpq5 libpqxx-7.8 pkg-config && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    libpqxx-7.8 \
    libpq5 \
    libssl3 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/ext/quantlib/lib/ubuntu/amd64/libQuantLib.so* /usr/local/lib/
COPY --from=builder /app/build/RESTApi /app/server

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

EXPOSE 8081

CMD ["./server"]