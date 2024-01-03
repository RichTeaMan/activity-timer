
BUILD_DIR="build"
OUT_ZIP=activity-timer-lambda.zip
OUT_ZIP_PATH="$(pwd)/build/$OUT_ZIP"

mkdir -p "$BUILD_DIR"

echo $OUT_ZIP_PATH

rm $OUT_ZIP_PATH -f
zip -r $OUT_ZIP_PATH . -x ".aws-sam*"
