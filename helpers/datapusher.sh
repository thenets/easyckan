#!/bin/bash

# Get all CKAN datasets
DATASETS="/tmp/ckan_datasets"
rm -f $DATASETS
touch $DATASETS
timeout 30s su -c "/etc/easyckan/bin/easyckan paster dataset list > $DATASET"

# Remove useless information lines
tail -n +3 "$DATASETS" > "$DATASETS.tmp"

cut "$DATASETS.tmp" -c38- | cat > $DATASETS

# Update all Datasets on DataStore
echo "Starting DataStore Update..."
cat /tmp/ckan_datasets | while read line ; do
  echo ""
  echo "# Update Dataset: $line"
  echo "| ================================================"
  timeout 3m su -c "echo -ne 'y\n' | /etc/easyckan/bin/easyckan paster datapusher submit $line"
  sleep 2
done