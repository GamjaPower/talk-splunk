# Kafka Connect + Splunk Sink 설정 가이드

이 문서는 Kafka Connect를 사용해 이벤트를 Splunk로 전송하는 절차를 정리한 것입니다.

## 개요

Kafka 클러스터와 Kafka Connect를 구성한 뒤 Splunk Sink Connector를 등록해 Kafka 토픽의 데이터를 Splunk HEC(HTTP Event Collector)로 전달합니다.

## 사전 준비

- Kafka 클러스터와 Kafka Connect가 정상 동작 중이어야 합니다.
  (docker-compose.yml 파일을 사용해서 테스트 환경 구축)
- Splunk HEC가 활성화되어 있어야 합니다.
- Splunk HEC 토큰과 수집 대상 인덱스가 준비되어 있어야 합니다.

## 절차

### 1) Kafka 토픽 생성

```bash
docker exec -it kafka1 kafka-topics \
  --create \
  --topic test-topic \
  --bootstrap-server kafka1:9092 \
  --replication-factor 3 \
  --partitions 3
```

### 2) Splunk Sink Connector 등록

기존 커넥터가 있으면 먼저 삭제합니다.

```bash
curl -X DELETE localhost:8083/connectors/kafka-connect-splunk
```

아래 예시에서 `splunk.hec.uri`와 `splunk.hec.token`은 환경에 맞게 변경하세요.

```bash
curl localhost:8083/connectors \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name": "kafka-connect-splunk",
    "config": {
      "connector.class": "com.splunk.kafka.connect.SplunkSinkConnector",
      "tasks.max": "3",
      "splunk.indexes": "main",
      "splunk.hec.ssl.validate.certs": "false",
      "topics": "test-topic",
      "splunk.hec.uri": "https://<splunk-hec-host>:8088",
      "splunk.hec.token": "<hec-token>"
    }
  }'
```

### 3) 이벤트 생성(프로듀싱)

```bash
docker exec -it kafka1 kafka-console-producer \
  --topic test-topic \
  --bootstrap-server kafka1:9092
```

### 4) Splunk 수집 확인

Splunk에서 다음 검색을 실행해 이벤트가 들어오는지 확인합니다.

```
index=main
```

## 구성 참고

### 여러 토픽 선택

`topics`에 콤마로 구분된 리스트를 지정하거나, 정규식 구독이 필요하면 `topics.regex`를 사용합니다.

```json
"topics": "topic-a,topic-b,topic-c"
```

```json
"topics.regex": "topic-.*"
```

## 운영 권장 사항

- HEC 토큰은 문서에 직접 노출하지 말고 환경 변수나 시크릿 관리 도구로 관리하세요.
- `splunk.hec.ssl.validate.certs`는 테스트 환경에서만 `false`를 사용하고, 운영 환경에서는 `true`를 권장합니다.
- `tasks.max`는 커넥터가 실행될 수 있는 최대 태스크 수입니다. 클러스터 리소스와 토픽 파티션 수에 맞춰 조정하세요.

## 참고 링크

- Kafka 클러스터 Docker Compose 예시: https://medium.com/@darshak.kachchhi/setting-up-a-kafka-cluster-using-docker-compose-a-step-by-step-guide-a1ee5972b122
- Splunk Kafka Connect 릴리즈: https://github.com/splunk/kafka-connect-splunk/releases
- Splunk Kafka Connect 리포지토리: https://github.com/splunk/kafka-connect-splunk
