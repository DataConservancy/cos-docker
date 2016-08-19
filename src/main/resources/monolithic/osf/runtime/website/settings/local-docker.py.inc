# The contents of this file are interpolated (environment variables are
# substituted) and then appended to 'website/settings/local.py' when the
# Docker image is executed.
#
# 'website/settings/local.py' is created by the image by copying
# 'website/settings/local-dist.py' to 'website/settings/local.py'.

CAS_SERVER_URL = '${CAS_SERVER_URL}'
DOMAIN = '${DOMAIN}'
API_DOMAIN = '${API_DOMAIN}'
# WATERBUTLER_URL = '${WATERBUTLER_URL}'
# WATERBUTLER_ADDRS = ${WATERBUTLER_ADDRS}
