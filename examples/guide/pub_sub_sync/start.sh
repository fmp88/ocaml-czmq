echo "Starting subscribers..."
for ((a=0; a<10; a++)); do
    sub/bin-sub &
done
echo "Starting publisher..."
pub/bin-pub
