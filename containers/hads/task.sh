#!/bin/bash
echo "[task.sh] [1/4] Starting Execution."
export TZ="HST"
echo "It is currently $(date)."
if [ $CUSTOM_DATE ]; then
    echo "An Acquisition date was provided by the environment."
else
    export CUSTOM_DATE=$(date -d "1 day ago" --iso-8601)
    echo "No Acquisition date was provided by the environment. Defaulting to yesterday."
fi
echo "Acquisition date is: " $CUSTOM_DATE

echo "[task.sh] [2/4] Collecting Climate data from HADS on the daily timeframe."
cd /home/hawaii_climate_products_container/preliminary/data_aqs/code/hads
Rscript hads_24hr_webscape.R $CUSTOM_DATE

echo "[task.sh] [3/4] Injecting authentication variables for uploader."
cd /sync
cp upload_config.json config.json
python3 add_auth_info_to_config.py config.json

echo "[task.sh] [4/4] Attempting to upload the gathered data."
python3 upload.py

echo "[task.sh] All done!"