#!/bin/bash

helm list --all-namespaces --output json | jq -r '.[] | [.namespace, .name, .status, .revision, .app_version, (.chart | split("-") | .[-1])] | @tsv' | while IFS=$'\t' read -r namespace release status; do
    metric_name="helm_release_status"
    labels="namespace=\"$namespace\",release=\"$release\",status=\"$status\""
    if [[ "$status" == "failed" ]]; then
        value=1
    else
        value=0
    fi
    echo "$metric_name{$labels} $value"
done
