#!/usr/bin/env python
import argparse
import plistlib
import re


def read_sectors(sectors_description):
    """docstring for read_sectors"""
    sector_description = re.compile(
            r'^\d{1,2}\.\s(?P<sector_id>[A-Z]{3})\s\((?P<sector_name>.+)\)$'
            )
    coordinate_line = re.compile(
            r'^\s{3}(?P<lng>\d{1,2}\.\d{4})\s{2}(?P<lat>\d{1,3}\.\d{4})$'
            )
    sectors = {}
    current_sector = ''
    for line in sectors_description:
        sector_match = sector_description.match(line)
        if sector_match:
            # begins a new sector
            sector_elements = sector_match.groupdict()
            current_sector = sector_elements['sector_id']
            sectors[current_sector] = []
            continue

        coordinate_match = coordinate_line.match(line)
        if coordinate_match:
            coordinate_elements = coordinate_match.groupdict()
            sectors[current_sector].append(
                    (
                        round(float(coordinate_elements['lng']), 4),
                        round(float(coordinate_elements['lat']) - 360.0, 4),
                        )
                    )
    return sectors


def main():
    """docstring for main"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
            'sectors_in',
            type=argparse.FileType('rb'),
            help='File containing the columns',
            default=None,
        )

    name_space = parser.parse_args()

    if name_space.sectors_in:
        sectors = read_sectors(name_space.sectors_in)
        plistlib.writePlist(sectors, 'Centers.plist')



if __name__ == '__main__':
    main()

