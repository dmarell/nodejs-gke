dbHost=$1
dbName=$2
dbUser=$3
dbPass=$4

cat << EOF
apiVersion: v1
kind: Secret
metadata:
  name: appname-secrets
type: Opaque
data:
  dbHost: ${dbHost}
  dbName: ${dbName}
  dbUser: ${dbUser}
  dbPass: ${dbPass}
EOF
