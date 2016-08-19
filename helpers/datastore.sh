# Get all CKAN datasets
DATASETS="/tmp/ckan_datasets"
/etc/easyckan/bin/easyckan paster dataset list > $DATASETS

# Remove useless information lines
tail -n +2 "$DATASETS" > "$DATASETS.tmp"

cut "$DATASETS.tmp" -c36N- | cat > $DATASETS

# Update all Datasets on DataStore
cat /tmp/ckan_datasets | while read line ; do echo -ne 'y\n' | /etc/easyckan/bin/easyckan paster datapusher submit $line ; done