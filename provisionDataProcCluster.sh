gcloud dataproc clusters create $1 \
 --project specter1 \
 --initialization-action-timeout 60m \
 --initialization-actions gs://specter-dia/specterInit.sh \
 --image-version 1.3 \
 --metadata 'MINICONDA_VARIANT=2' \
 --metadata 'MINOCONDA_VERSION=latest' \
 --bucket specter-dia \
 --master-boot-disk-size 1TB \
 --master-machine-type n1-highmem-8 \
 --master-boot-disk-type pd-ssd \
 --num-masters 1 \
 --worker-machine-type n1-highmem-8 \
 --worker-boot-disk-size 100GB \
 --worker-boot-disk-type pd-ssd \
 --num-workers 4 \
 --num-preemptible-workers 4


