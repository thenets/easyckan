#!/bin/bash

nohup /etc/easyckan/helpers/harvest.sh gather_consumer &
nohup /etc/easyckan/helpers/harvest.sh fetch_consumer &