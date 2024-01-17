#!/bin/bash

# Define the destination directory in your MkDocs project
DEST_DIR="docs"

# URLs of the raw documentation files
KINEMATIC_MODEL_URL="https://raw.githubusercontent.com/team-drift/kinematic-model/main/docs/kinematic_model.md"

# Use curl to fetch each file
curl -o "${DEST_DIR}/kinematic_model.md" $KINEMATIC_MODEL_URL


echo "Documentation updated."
