#!/bin/bash

# Credenciales para acceder
DB_USER="root"
DB_PASSWORD="r8oTMy5q%"

# Directorio donde se guardarán los backups.
BACKUP_DIR="/var/lib/mysql/rsp-total"

# IP del servidor para el nombre del archivo (los últimos dos bytes).
# Por ejemplo si el servidor es: 148.215.1.98 -> 1_98
SERVER_IP_SUFFIX="154_19"

# Nuevo formato de fecha: MM_DD_YYYY_HH_MM (ejemplo: 06_07_2025_19_49)
DATE_FORMAT=$(date +%m_%d_%Y_%H_%M)

# --- Crear el directorio de backup si no existe ---
mkdir -p "${BACKUP_DIR}"

# --- Obtener la lista de todas las bases de datos ---
# Se excluyen bases de datos del sistema que no suelen necesitar backup.
DATABASES=$(mysql -u"${DB_USER}" -p"${DB_PASSWORD}" -e "SHOW DATABASES;" | \
    grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

for DB_NAME in ${DATABASES}; do
    echo "Realizando backup de la base de datos: ${DB_NAME}"

# Definir el nombre del archivo de backup con la nomenclatura especificada:
    # Rsp_dbname_MM_DD_YYYY_HH_MM_154_16.sql
    BACKUP_FILE="${BACKUP_DIR}/Rsp_${DB_NAME}_${DATE_FORMAT}_${SERVER_IP_SUFFIX}.sql"

    # Comando mysqldump para exportar la base de datos.
    # --single-transaction: Es bueno para bases de datos transaccionales (InnoDB)
    #                      para asegurar la consistencia sin bloquear tablas.
    # --skip-extended-insert: Opcional, puede hacer el backup más legible pero más grande.
    #                       Quitar si el tamaño es una preocupación.
    # Eliminada la opción --set-gtid-purged=OFF ya que no es compatible con versiones antiguas de MySQL.
    mysqldump -u"${DB_USER}" -p"${DB_PASSWORD}" --single-transaction "${DB_NAME}" > "${BACKUP_FILE}"

    # Verificar si el backup fue exitoso
    if [ $? -eq 0 ]; then
        echo "Backup de ${DB_NAME} completado exitosamente: ${BACKUP_FILE}"
    else
        echo "Error al realizar el backup de ${DB_NAME}"
    fi
done

echo "Proceso de backup de MySQL 5.x completado."