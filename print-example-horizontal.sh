#!/bin/sh
export BROTHER_QL_PRINTER=file:///dev/usb/lp0
export BROTHER_QL_MODEL=QL-700
brother_ql print -l 62 --600dpi example-seedsigner-qr-code.png
