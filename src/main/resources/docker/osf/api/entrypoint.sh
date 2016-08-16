#!/bin/ash

echo "Entrypoint begin."
echo `/bin/pwd`
cat ${CODE}/tasks/__init__.py

# npm configuration
# - sets a global cache directory to a Docker volume from the 'vols/js' image
echo "NPM config"
npm config set cache ${NPM_CACHE} -g

# bower configuration
# - sets a packages directory to a Docker volume from the 'vols/js' image
echo "Bower" 
cat ${TMP}/bowerrc.tmpl | envsubst > ~/.bowerrc && cat ~/.bowerrc && \

# Install python dependencies, npm, and bower packages
#echo "Wheelhouse"
#invoke -f ${TMP}/invoke.yaml wheelhouse --dev \

#echo "Requirements"
#invoke -f ${TMP}/invoke.yaml requirements --base --dev 

#echo "Assets"
#gosu nobody invoke -f ${TMP}/invoke.yaml assets --dev

echo "build_js_config_files"
gosu nobody invoke -f ${TMP}/invoke.yaml build_js_config_files

echo "webpack"
gosu nobody invoke -f ${TMP}/invoke.yaml webpack --dev

echo "Entrypoint complete."
