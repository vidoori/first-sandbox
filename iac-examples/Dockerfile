# INTENTIONALLY INSECURE - for scanner comparison only. Never built.

# Flaw: unpinned "latest" tag
FROM python:latest

# Flaw: apt-get without --no-install-recommends or cache cleanup
RUN apt-get update && apt-get install -y curl

# Flaw: ADD from a remote URL instead of a verified download
ADD https://example.com/tool.tar.gz /opt/

COPY . /app
WORKDIR /app

# Flaw: no USER instruction, so the container runs as root
# Flaw: no HEALTHCHECK
CMD ["python", "app.py"]
