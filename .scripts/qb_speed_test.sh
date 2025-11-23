#!/usr/bin/env bash

kc="${1:-mallard}"

case "${kc}" in
    mallard|serpentine)
        export KUBE_CONTEXT="${1}"
        ;;
    *)
        echo "Error: no context ${kc} found" >&2
        exit 1
        ;;
esac

pod_name="$(kubectl -n media get po -l app.kubernetes.io/name=qbittorrent -o name)"

kubectl -n media exec -it "${pod_name}" -c app -- ./speedtest -B
