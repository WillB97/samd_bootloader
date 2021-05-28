#! /usr/bin/env python3
import struct
import argparse
import binascii
from typing import IO, AnyStr


def pad_serial(serial_num: str, pad_length: int = 15) -> str:
    if len(serial_num) > pad_length:
        # truncate over-length serials
        return serial_num[:pad_length - 1]
    else:
        return serial_num + '\0' * (pad_length - len(serial_num.encode('utf-8')))


def insert_bin_serial(
    serial_num_padded: str,
    in_file: IO[AnyStr],
    out_file: IO[AnyStr],
) -> None:
    data = in_file.read()

    data = data.replace(b"XXXXXXXXXXXXXXX", serial_num_padded.encode('utf-8'), 1)

    out_file.write(data)


def generate_ihex_line(old_line: bytes, serial_num: str) -> bytes:
    serial_num_bytes = serial_num.encode('utf-8')
    serial_num_len = len(serial_num_bytes) + 1
    format = f'>BHB{serial_num_len}s'

    (length, addr, pkt_type, _) = struct.unpack_from(
        format,
        binascii.unhexlify(old_line[1:].strip()),
    )

    data_raw = struct.pack(format, length, addr, pkt_type, serial_num_bytes+ b'\0')
    checksum = struct.pack('B', 256 - (sum(data_raw) & 0xff))
    data_pkt = binascii.hexlify(data_raw + checksum).upper()
    return b':' + data_pkt + b'\r\n'


def insert_hex_serial(
    serial_num_padded: str,
    in_file: IO[AnyStr],
    out_file: IO[AnyStr],
) -> None:
    line = in_file.readline()

    while(line):  # for each line
        if line.find(binascii.hexlify(b"XXXXXXXXXXXXXXX")) == -1:
            out_file.write(line)
        else:  # placeholder found
            new_line = generate_ihex_line(line, serial_num_padded)
            print(new_line)
            out_file.write(new_line)

        line = in_file.readline()


def create_parser() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Insert a serial number into a pre-compiled binary where "
            "the placeholder value 'XXXXXXXXXXXXXXX' has been used"
        ),
    )
    parser.add_argument('serial_num', help="The value to set the serial number to.")
    parser.add_argument(
        'infile',
        type=argparse.FileType('rb'),
        help="The template file to insert the serial number into.",
    )
    parser.add_argument(
        'outfile',
        type=argparse.FileType('wb'),
        help="The file to write the output to.",
    )
    parser.add_argument(
        "--type",
        choices=('hex', 'binary'),
        help="The type of program code being edited. (Defaults to binary)",
        default='binary',
    )
    return parser


if __name__ == '__main__':
    parser = create_parser()
    args = parser.parse_args()

    serial_num_padded = pad_serial(args.serial_num)

    if args.type == 'binary':
        insert_bin_serial(serial_num_padded, args.infile, args.outfile)
    else:
        insert_hex_serial(serial_num_padded, args.infile, args.outfile)
