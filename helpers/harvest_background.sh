#!/bin/bash

nohup ./harvest.sh gather_consumer &
nohup ./harvest.sh fetch_consumer &