import os

# Secret key for Flask
SECRET_KEY = os.environ.get('SUPERSET_SECRET_KEY', 'secret')

# SQLAlchemy database URI
# SQLALCHEMY_DATABASE_URI = os.environ.get('SQLALCHEMY_DATABASE_URI', 'postgresql+psycopg2://superset:superset@haproxy:5000/superset')

# The app will be able to connect to the Patroni PostgreSQL clusters
SQLALCHEMY_TRACK_MODIFICATIONS = False

# Enable or disable SSL
ENABLE_SSL = False

# The superuser credentials
ADMIN_USERNAME = os.environ.get('SUPERSET_ADMIN_USERNAME', 'admin')
ADMIN_PASSWORD = os.environ.get('SUPERSET_ADMIN_PASSWORD', 'admin')
ADMIN_FIRST_NAME = os.environ.get('SUPERSET_ADMIN_FIRST_NAME', 'Admin')
ADMIN_LAST_NAME = os.environ.get('SUPERSET_ADMIN_LAST_NAME', 'User')
ADMIN_EMAIL = os.environ.get('SUPERSET_ADMIN_EMAIL', 'admin@superset.com')
AUTH_TYPE = 1
WTF_CSRF_ENABLED = False
ENABLE_PROXY_FIX = True
SECURITY_MANAGER = "superset.security.Manager"

# Enable or disable asynchronous queries
ENABLE_ASYNC = True

# Redis configuration (for async tasks)
# REDIS_URL = os.environ.get('REDIS_URL', 'redis://localhost:6379/0')

# Additional optional settings for features like caching, logs, etc.
