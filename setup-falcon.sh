DEVICE_NAME="falcon"
UBUNTU_FS_ROOT=/root

echo "mounting userdata partition to /data..."
adb shell mount /dev/block/platform/msm_sdcc.1/by-name/userdata /data

echo "mounting Ubuntu system image to ${UBUNTU_FS_ROOT}..."
adb shell mount /data/system.img ${UBUNTU_FS_ROOT}

adb_push_ubuntu()
{
	FILE_PATH=$1
	adb push "${FILE_PATH}" "${UBUNTU_FS_ROOT}/${FILE_PATH}"
}

# adbd must be executable!
echo "copying modified adbd..."
adb_push_ubuntu "usr/bin/adbd"
adb_push_ubuntu "etc/init/android-tools-adbd.override"

echo "copying udev rules..."
adb_push_ubuntu "usr/lib/lxc-android-config/70-${DEVICE_NAME}.rules"

echo "copying display configuration..."
adb_push_ubuntu "etc/ubuntu-touch-session.d/${DEVICE_NAME}.conf"
