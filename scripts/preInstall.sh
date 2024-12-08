#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./esdata1
chown -R 1000:1000 ./esdata1