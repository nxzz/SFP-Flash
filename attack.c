#include <errno.h>
#include <fcntl.h>
#include <linux/i2c-dev.h>
#include <stdio.h>
#include <stdlib.h>

/* LM75温度センサがつながっているI2Cバスの指定 */
#define I2CDEVICE "/dev/i2c-10"

/* LM75温度センサのI2Cアドレス指定(7bitアドレス値) */
#define SFP_50_ADDR 0x50
#define SFP_51_ADDR 0x51

#define SN_REG 0x44
#define PASSWORD_REG 0x7B

#define COM_STR 0x46

int writePassword(int fd, u_int32_t pwd) {
  int ret;
  unsigned char data[5];

  // 0x51にかく
  ret = ioctl(fd, I2C_SLAVE, SFP_51_ADDR);
  if (ret < 0) {
    perror(I2CDEVICE);
    return -EIO;
  }

  // パスワードを送る
  data[0] = PASSWORD_REG;
  data[1] = (pwd > 24) & 0xFF;
  data[2] = (pwd > 16) & 0xFF;
  data[3] = (pwd > 8) & 0xFF;
  data[4] = pwd & 0xFF;
  ret = write(fd, data, 5);
  usleep(5);
  if (ret < 0) {
    perror(I2CDEVICE);
    return -EIO;
  }
  return 1;
}

int writeAndCompSN(int fd) {
  int ret;
  unsigned char data[5];

  // 0x50にかく
  ret = ioctl(fd, I2C_SLAVE, SFP_50_ADDR);
  if (ret < 0) {
    perror(I2CDEVICE);
    return -EIO;
  }

  // SN一文字書き換え
  data[0] = SN_REG;
  data[1] = COM_STR;
  ret = write(fd, data, 2);
  if (ret < 0) {
    perror(I2CDEVICE);
    return -EIO;
  }

  // SN一文字読み出し
  data[0] = SN_REG;
  ret = write(fd, data, 1);
  if (ret < 0) {
    perror(I2CDEVICE);
    return -EIO;
  }
  ret = read(fd, data, 1);
  if (ret < 0) {
    perror(I2CDEVICE);
    return -EIO;
  }
  return data[0] == COM_STR ? 10 : 0;
}

int main() {
  int fd; /* ファイルディスクリプタ */
  /* I2C 通信デバイスのオープン */
  fd = open(I2CDEVICE, O_RDWR);
  if (fd < 0) {
    perror(I2CDEVICE);
    exit(1);
  }
  for (u_int32_t i = 0; i <= 0xFFFFFFFF; i++) {
    if (writePassword(fd, i) > 0) {
      if (writeAndCompSN(fd) == 10) {
        printf("%#x\n", i);
        printf("end\n");
        break;
      }
    } else {
      perror(I2CDEVICE);
      exit(1);
    }
    if (i % 0xFF == 0) {
      printf("now: %#x\n", i);
    }
  }
  close(fd);
}
