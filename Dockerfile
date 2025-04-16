FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    curl bash jq \
    && curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
    && pip install flask

WORKDIR /app
COPY helm_status_exporter.py .
COPY helm_status.sh /scripts/helm_status.sh
RUN chmod 777 /scripts/helm_status.sh
EXPOSE 9110

CMD ["python", "helm_status_exporter.py"]
