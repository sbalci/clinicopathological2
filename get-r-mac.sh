#!/usr/bin/env bash
set -e

# Download and extract the main Mac Resources directory
# Requires xar and cpio, both installed in the Dockerfile
mkdir -p r-mac
curl -o r-mac/latest_r.pkg \
     https://cloud.r-project.org/bin/macosx/R-4.0.0.pkg

cd r-mac
xar -xf latest_r.pkg
rm -r r-fw.pkg Resources tcltk.pkg texinfo.pkg Distribution latest_r.pkg
cat r-app.pkg/Payload | gunzip -dc | cpio -i
cp -R /Library/Frameworks/R.framework/Versions/Current/Resources/* .
rm -r r-app.pkg

# Patch the main R script
sed -i.bak '/^R_HOME_DIR=/d' bin/R
sed -i.bak 's;/Library/Frameworks/R.framework/Resources;${R_HOME};g' \
    bin/R
chmod +x bin/R
rm -f bin/R.bak

# Remove unneccessary files TODO: What else
rm -r doc tests
rm -r lib/*.dSYM
