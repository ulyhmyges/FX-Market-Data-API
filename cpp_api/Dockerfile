# ---------- build stage ----------
FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y \
    g++ cmake make git libboost-all-dev libssl-dev pkg-config libpq-dev libpqxx-dev

WORKDIR /app

COPY . .

RUN rm -rf build
RUN cmake -S . -B build && cmake --build build -j$(nproc)

# ---------- runtime stage ----------
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    libboost-all-dev libssl3 libpq5 libpqxx-7.8 pkg-config && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/libraries/local/lib/libQuantLib.so* /usr/local/lib/
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

COPY --from=builder /app/build/RESTApi /app/server

EXPOSE 8081

CMD ["./server"]