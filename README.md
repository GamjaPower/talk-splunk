# Talk Splunk Scripts

Talk Splunk 영상 채널에서 사용하는 실습·데모용 스크립트와 설정을 모아둔 저장소입니다. 동일한 실습 환경을 빠르게 재현하는 것이 목표이므로 실행 전에 내용을 확인하고 환경에 맞게 수정하는 것을 권장합니다.

## 디렉터리 구성
- `inst/inst_splunk_linux.sh`: Splunk Enterprise 9.4.7을 Linux에 설치하고 부팅 시 자동 시작하도록 설정.
- `inst/user-seed.conf`: 설치 시 적용되는 기본 관리자 계정(`admin`/`changeme`) 정의.
- `inst/inst_splunk_uf_linux.sh`: Splunk Universal Forwarder 9.4.7 설치 및 자동 시작 설정.
- `inst/hf_inputs.conf`, `inst/hf_outputs.conf`: Universal Forwarder용 입력(UDP 1514)·출력(포워딩 대상 `192.168.0.203:9997`) 설정 샘플.
- `inst/cluster-base/docker-compose.yml`: 1 x Cluster Manager, 3 x Indexer, 1 x Search Head, 1 x Heavy Forwarder로 구성된 기본 클러스터 예제.
- `inst/cluster-idx3-sh3-cm1-hf1-dpl1/docker-compose.yml`: Search Head Cluster(3노드) + Deployer를 포함한 확장 클러스터 예제.
- `LICENSE`: MIT 라이선스.

## 빠른 시작
### 1) 단일 호스트에 Splunk Enterprise 설치
필수: 루트 권한, `wget`, `tar`, `/opt`에 쓰기 권한.
```bash
cd inst
sudo bash inst_splunk_linux.sh
```
- 설치 경로: `/opt/splunk`
- 기본 관리자 정보는 `inst/user-seed.conf`에서 변경 가능.
- 설치 후 자동으로 라이선스 동의 및 부팅 시 자동 시작이 설정됩니다.

### 2) Universal Forwarder 설치
필수: 루트 권한, `wget`, `tar`.
```bash
cd inst
sudo bash inst_splunk_uf_linux.sh
```
- 설치 경로: `/opt/splunkforwarder`
- 수집 대상 포트와 포워딩 목적지(IP:포트)는 `inst/hf_inputs.conf`, `inst/hf_outputs.conf`를 실행 전 수정하세요.

### 3) Docker Compose로 실습 클러스터 실행
필수: Docker, docker compose plugin.
```bash
export SPLUNK_PASSWORD='<강력한 비밀번호>'
docker compose -f inst/cluster-base/docker-compose.yml up -d
# 또는
docker compose -f inst/cluster-idx3-sh3-cm1-hf1-dpl1/docker-compose.yml up -d
```
- 각 compose 파일은 `.env` 없이 `SPLUNK_PASSWORD` 환경변수를 요구합니다.
- 주요 노출 포트: 8000(웹), 8089(관리), 1514/udp, 9997/tcp. 필요에 따라 변경하거나 방화벽을 구성하세요.
- 데이터·설정은 각 서비스별 로컬 디렉터리(`*-data`, `*-etc`)에 볼륨 마운트됩니다.

## 주의 사항
- 스크립트와 포트, 포워딩 대상은 영상 촬영 시점을 기준으로 작성되었습니다. 운영 환경에 적용하기 전에 버전, 네트워크 경로, 계정/패스워드를 반드시 검증하세요.
- 기본 사용자 정보(`admin`/`changeme`)와 대칭 키(`SPLUNK_IDXC_SECRET`, `SPLUNK_SHC_PASS4SYMMKEY`)는 테스트용입니다. 실제 환경에서는 즉시 변경하세요.
- Compose 예제는 단일 호스트 실습용으로 리소스·보안 최적화가 되어 있지 않습니다.

## 라이선스
- MIT License. 자세한 내용은 `LICENSE`를 참고하세요.
