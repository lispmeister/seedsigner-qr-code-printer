# Print Example QR-code

This project is a simple prototype that intends to show how to print
a[SeedSigner seed](https://github.com/SeedSigner/seedsigner) and its
QR-code on a Brother QL-700 label printer using only Python and the
[brother_ql](https://github.com/pklaus/brother_ql) library.

The project is really just a proof of concept and would need integration with
the main SeedSigner code to become useful.

## Example Seed

The image of the seed we will to print:
![Example seed image](example-seedsigner-qr-code.png?raw=true "Example seed image")


The actual printout:
![Example seed printout](example-seedsigner-qr-code-printout.jpeg?raw=true "Example seed printout")


## Requirements

This project assumes that the QL-700 (or compatible) printer is attached to a
Raspberry Pi running Raspbian.

## Update and Upgrade

```sh
sudo apt-get update && sudo apt-get upgrade
```

## Install pipenv

```sh
sudo apt-get install pipenv
```

## Create `pipenv` Environment

All our dependencies are defined in the `Pipfile` but we need to create
an environment first.
```sh
pipenv --python 3.7
```

Install libraries into environment.
```sh
pipenv install
```

Start a shell in the environment
```sh
pipenv shell
```

## Install Libraries

```sh
sudo apt-get install -y libusb-1.0-0 libopenjp2-7 libtiff5
```

## Change permissions

Once we switch on the printer it will automatically show up as `/dev/usb/lp0` in
our device tree. Default permissions don't allow the `pi` user access. Let's 
change that.
```sh
sudo chmod o+rw /dev/usb/lp0
```

## Print


Print our example seed horizontally:
```sh
#!/bin/sh
export BROTHER_QL_PRINTER=file:///dev/usb/lp0
export BROTHER_QL_MODEL=QL-700
brother_ql print -l 62 example-seedsigner-qr-code.png
```

Print our example seed vertically:
```sh
#!/bin/sh
export BROTHER_QL_PRINTER=file:///dev/usb/lp0
export BROTHER_QL_MODEL=QL-700
brother_ql print -r 90 -l 62 example-seedsigner-qr-code.png
```


## Fix USB Permissions Permanently

The `chmod` command above is only a temporary fix for the access permissions to the `lp0` device.
Every time the printer goes offline (manually or due to power safe mode) the permissions revert
to the default.

Check permissions after power was off:
```sh
ls -la /dev/usb/lp0
```
Result:
```
crw-rw---- 1 root lp 180, 0 Nov 26 08:10 /dev/usb/lp0
```

List our device tree:
```sh
lsusb -vvv
```
Result (excerpt):
```
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x04f9 Brother Industries, Ltd
  idProduct          0x2042
```

We create a new file `50-usb-printer-rules`:
```sh
sudo vi /etc/udev/rules.d/50-usb-printer.rules
```

The file has only one line and references our vendor and product ids but without the
leading `0x` to mark them as hexadecimal values:
```
SUBSYSTEMS=="usb", ATTRS{idVendor}=="04f9", ATTRS{idProduct}=="2042", GROUP="users", MODE="0666"
```

You will need to reboot for these changes to take effect.
```sh
sudo reboot
```

Once we're logged in again we check our permissions again to make sure they have changed to what we defined:
```sh
ls -la /dev/usb/lp0
```
Result:
```
crw-rw-rw- 1 root users 180, 0 Nov 26 08:46 /dev/usb/lp0
```










