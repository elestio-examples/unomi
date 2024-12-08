#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./esdata1
chown -R 1000:1000 ./esdata1

cat << EOT > ./unomi.custom.system.properties
org.apache.unomi.security.root.password=${ADMIN_PASSWORD}
EOT