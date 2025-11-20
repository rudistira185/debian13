#!/system/bin/sh

# --- KONFIGURASI UMUM ---
PORT=9100
METRICS_FILE="/data/local/tmp/android_metrics.prom"
# Path yang sudah dikoreksi untuk sensor CPU MediaTek G85
CPU_TEMP_PATH="/sys/class/thermal/thermal_zone3/temp" 

echo "Memulai Prometheus Bash Exporter (Mode Jiffies) di port $PORT..."
echo "Metrik Jiffies digunakan untuk CPU. Gunakan PromQL: rate(android_cpu_jiffies_total{mode!=\"idle\"}[5m])"
echo "Tekan Ctrl+C untuk menghentikan server."

# --- FUNGSI HELPER ---

# Mengambil data dari dumpsys battery
get_battery_metric() {
    local field="$1"
    dumpsys battery | grep "$field" | awk '{print $2}'
}

# Mengambil Suhu dari path sensor dan mengkonversinya ke Celsius
get_cpu_temp() {
    if [ -f "$CPU_TEMP_PATH" ]; then
        TEMP_RAW=$(cat "$CPU_TEMP_PATH")
        # Asumsi: Umumnya dalam milli-Celsius (dibagi 1000)
        if [ "$TEMP_RAW" -gt 1000 ]; then
            echo "scale=1; $TEMP_RAW / 1000" | bc
        # Asumsi: Jika centi-Celsius (dibagi 10)
        else
            echo "scale=1; $TEMP_RAW / 10" | bc
        fi
    else
        echo "0"
    fi
}

# --- LOOP UTAMA: KOLEKSI DAN LAYANI ---
while true; do
    
    # 1. KOLEKSI METRIK (menulis ke $METRICS_FILE)
    
    # Hapus file metrik lama untuk koleksi baru
    echo "" > $METRICS_FILE
    
    # --- UPTIME ---
    UPTIME_SECONDS=$(cat /proc/uptime | awk '{print $1}' | cut -d'.' -f1)
    echo "# HELP android_device_uptime_seconds Waktu sejak boot terakhir dalam detik." >> $METRICS_FILE
    echo "# TYPE android_device_uptime_seconds gauge" >> $METRICS_FILE
    echo "android_device_uptime_seconds $UPTIME_SECONDS" >> $METRICS_FILE

    # --- CPU USAGE (Menggunakan Jiffies Counter) ---
    # Metrik ini akan digunakan Prometheus untuk menghitung penggunaan CPU (rate).
    
    # Abaikan baris pertama ('cpu') yang merupakan total semua core
    cat /proc/stat | grep '^cpu[0-9]' | while read line ; do
        
        # Pisahkan nama core (misalnya cpu0) dan nilai jiffies
        CORE_NAME=$(echo $line | awk '{print $1}')
        USER=$(echo $line | awk '{print $2}')
        NICE=$(echo $line | awk '{print $3}')
        SYSTEM=$(echo $line | awk '{print $4}')
        IDLE=$(echo $line | awk '{print $5}')
        IOWAIT=$(echo $line | awk '{print $6}')
        IRQ=$(echo $line | awk '{print $7}')
        SOFTIRQ=$(echo $line | awk '{print $8}')

        echo "" >> $METRICS_FILE
        echo "# HELP android_cpu_jiffies_total Total Jiffies per core, dipisahkan berdasarkan status." >> $METRICS_FILE
        echo "# TYPE android_cpu_jiffies_total counter" >> $METRICS_FILE
        
        # Menyajikan data untuk setiap status dalam format Prometheus
        echo "android_cpu_jiffies_total{core=\"$CORE_NAME\", mode=\"user\"} $USER" >> $METRICS_FILE
        echo "android_cpu_jiffies_total{core=\"$CORE_NAME\", mode=\"nice\"} $NICE" >> $METRICS_FILE
        echo "android_cpu_jiffies_total{core=\"$CORE_NAME\", mode=\"system\"} $SYSTEM" >> $METRICS_FILE
        echo "android_cpu_jiffies_total{core=\"$CORE_NAME\", mode=\"idle\"} $IDLE" >> $METRICS_FILE
        echo "android_cpu_jiffies_total{core=\"$CORE_NAME\", mode=\"iowait\"} $IOWAIT" >> $METRICS_FILE
        echo "android_cpu_jiffies_total{core=\"$CORE_NAME\", mode=\"irq\"} $IRQ" >> $METRICS_FILE
        echo "android_cpu_jiffies_total{core=\"$CORE_NAME\", mode=\"softirq\"} $SOFTIRQ" >> $METRICS_FILE
    done

    # --- CPU TEMP (MENGGUNAKAN thermal_zone3) ---
    CPU_TEMP=$(get_cpu_temp)
    echo "" >> $METRICS_FILE
    echo "# HELP android_cpu_temperature_celsius Suhu CPU dalam Celsius." >> $METRICS_FILE
    echo "# TYPE android_cpu_temperature_celsius gauge" >> $METRICS_FILE
    echo "android_cpu_temperature_celsius $CPU_TEMP" >> $METRICS_FILE

    # --- BATTERY STATUS CHARGING ---
    STATUS_STR=$(get_battery_metric status)
    if [ "$STATUS_STR" = "2" ] || [ "$STATUS_STR" = "5" ]; then
        IS_CHARGING=1
    else
        IS_CHARGING=0
    fi
    echo "" >> $METRICS_FILE
    echo "# HELP android_battery_is_charging Status pengisian baterai (1=ya, 0=tidak)." >> $METRICS_FILE
    echo "# TYPE android_battery_is_charging gauge" >> $METRICS_FILE
    echo "android_battery_is_charging $IS_CHARGING" >> $METRICS_FILE

    # --- BATTERY CAPACITY ---
    BATTERY_CAPACITY=$(get_battery_metric level)
    echo "" >> $METRICS_FILE
    echo "# HELP android_battery_capacity_percent Kapasitas baterai saat ini dalam persen." >> $METRICS_FILE
    echo "# TYPE android_battery_capacity_percent gauge" >> $METRICS_FILE
    echo "android_battery_capacity_percent $BATTERY_CAPACITY" >> $METRICS_FILE

    # --- BATTERY TEMPERATURE ---
    BATTERY_TEMP_RAW=$(get_battery_metric temperature)
    BATTERY_TEMP_C=$(echo "scale=1; $BATTERY_TEMP_RAW / 10" | bc)
    echo "" >> $METRICS_FILE
    echo "# HELP android_battery_temperature_celsius Suhu baterai dalam Celsius." >> $METRICS_FILE
    echo "# TYPE android_battery_temperature_celsius gauge" >> $METRICS_FILE
    echo "android_battery_temperature_celsius $BATTERY_TEMP_C" >> $METRICS_FILE

    # --- NETWORK USAGE TOTAL ---
    NETWORK_STATS=$(cat /proc/net/dev | grep -E '^[[:space:]]+[a-zA-Z0-9]+:' | grep -v 'lo:' | awk '{rx+=$2; tx+=$10} END {print rx, tx}')

    RX_BYTES=$(echo $NETWORK_STATS | awk '{print $1}')
    TX_BYTES=$(echo $NETWORK_STATS | awk '{print $2}')
    
    if [ -z "$RX_BYTES" ]; then RX_BYTES=0; fi
    if [ -z "$TX_BYTES" ]; then TX_BYTES=0; fi

    echo "" >> $METRICS_FILE
    echo "# HELP android_network_total_bytes Total bytes yang diterima/ditransmisikan (akumulatif sejak boot)." >> $METRICS_FILE
    echo "# TYPE android_network_total_bytes counter" >> $METRICS_FILE
    echo "android_network_total_bytes{direction=\"received\"} $RX_BYTES" >> $METRICS_FILE
    echo "android_network_total_bytes{direction=\"transmitted\"} $TX_BYTES" >> $METRICS_FILE

    # Berikan izin baca pada file
    chmod 644 $METRICS_FILE

    # 2. LAYANAN METRIK DENGAN NETCAT

    # Header HTTP untuk respons Prometheus
    HTTP_HEADER="HTTP/1.1 200 OK\r\nContent-Type: text/plain; version=0.0.4\r\n\r\n"
    
    # Gabungkan Header + Isi Metrik, lalu layani dengan netcat
    (echo -e "$HTTP_HEADER"; cat $METRICS_FILE) | nc -l -p $PORT -w 1
    
    # Jeda singkat sebelum mendengarkan koneksi berikutnya
    sleep 1

done
