#!/bin/bash
echo "deleting  ${RESOURCE_IDS}"
az resource delete --ids ${RESOURCE_IDS} || true