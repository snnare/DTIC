#!/bin/bash

# Credenciales para acceder
DB_USER="root"
DB_PASSWORD="R3p0s!T0r!0"

# Directorio donde se guardarán los backups.
BACKUP_DIR="/home/mysql/respaldos"

# IP del servidor para el nombre del archivo (los últimos dos bytes).
# Por ejemplo si el servidor es: 148.215.1.98 -> 1_98
SERVER_IP_SUFFIX="1_33"
DATE_FORMAT=$(date +%Y%m%d_%H%M%S)

# Define the paths to your MySQL client binaries.
# Ensure these paths are correct for your system.
export MYSQLC="/usr/local/mysql/bin/mysql"
export MYSQLDUMPC="/usr/local/mysql/bin/mysqldump"


# --- Crear el directorio de backup si no existe ---
mkdir -p "${BACKUP_DIR}"

# --- Obtener la lista de todas las bases de datos ---
# Se excluyen bases de datos del sistema que no suelen necesitar backup.
DATABASES=$("${MYSQLC}" -u"${DB_USER}" -p"${DB_PASSWORD}" -e "SHOW DATABASES;" | \
    grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")


for DB_NAME in ${DATABASES}; do
    echo "Realizando backup de la base de datos: ${DB_NAME}"

# Definir el nombre del archivo de backup con la nomenclatura especificada:
    # Rsp_dbname_YYYYMMDD_HHMMSS_1_98.sql
    BACKUP_FILE="${BACKUP_DIR}/Rsp_${DB_NAME}_${DATE_FORMAT}_${SERVER_IP_SUFFIX}.sql"

    # Comando mysqldump para exportar la base de datos.
    # --single-transaction: Es bueno para bases de datos transaccionales (InnoDB)
    #                      para asegurar la consistencia sin bloquear tablas.
    # --skip-extended-insert: Opcional, puede hacer el backup más legible pero más grande.
    #                       Quitar si el tamaño es una preocupación.
    # --set-gtid-purged=OFF: This option is for MySQL 5.6+ and will cause an error
    #                       on older versions (like MySQL 5.5 or earlier). Removed for compatibility.
    "${MYSQLDUMPC}" -u"${DB_USER}" -p"${DB_PASSWORD}" --single-transaction "${DB_NAME}" > "${BACKUP_FILE}"

    # Verificar si el backup fue exitoso
    if [ $? -eq 0 ]; then
        echo "Backup de ${DB_NAME} completado exitosamente: ${BACKUP_FILE}"
    else
        echo "Error al realizar el backup de ${DB_NAME}"
    fi
done

echo "Proceso de backup de MySQL 5.x completado."