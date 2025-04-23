#!/bin/bash

helm list --all-namespaces --output json | jq -r '
  .[] | 
  [.namespace, .name, .status, .revision, .app_version, .chart] | 
  @tsv' | while IFS=$'\t' read -r namespace release status revision app_version chart; do

    chart_version="${chart##*-}"
    metric_name="helm_release_status_code"
    labels="namespace=\"$namespace\",release=\"$release\",status=\"$status\",revision=\"$revision\",app_version=\"$app_version\",chart_version=\"$chart_version\""

    # Normalize status to lowercase and replace spaces with dashes
    status_key=$(echo "$status" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

    # Assign a numeric value based on status
    case "$status_key" in
        deployed) value=0 ;;
        deleted) value=1 ;;
        superseded) value=2 ;;
        failed) value=3 ;;
        deleting) value=4 ;;
        pending-install) value=5 ;;
        pending-upgrade) value=6 ;;
        pending-rollback) value=7 ;;
        *) value=-1 ;;  # Unknown status
    esac

    echo "$metric_name{$labels} $value"
done