#!/usr/bin/env python
import argparse


def read_columns(csv):
    """docstring for read_columns"""
    date = []
    longitude = []
    latitude = []
    altitude = []
    speed = []

    for line in csv:
        hit_date, hit_time, lat, lng, alt, gnd_speed = line.split(',')
        longitude.append(lng)
        latitude.append(lat)
        altitude.append(alt)
        speed.append(gnd_speed.replace('\n', ''))
        date.append(' '.join([hit_date, hit_time]))

    return {
            'date': date,
            'longitude': longitude,
            'latitude': latitude,
            'speed': speed,
            'altitude': altitude,
            }


def print_on_lines(fp_elements):
    """docstring for print_on_lines"""
    print('date')
    print(', '.join(fp_elements['date']))

    print('longitude')
    print(', '.join(fp_elements['longitude']))

    print('latitude')
    print(', '.join(fp_elements['latitude']))

    print('altitude')
    print(', '.join(fp_elements['altitude']))

    print('speed')
    print(', '.join(fp_elements['speed']))


def main():
    """docstring for main"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
            'csv_in',
            type=argparse.FileType('rb'),
            help='File containing the columns',
            default=None,
        )

    name_space = parser.parse_args()

    if name_space.csv_in:
        # reads the lines
        # strip the first one
        name_space.csv_in.readline()
        print_on_lines(read_columns(name_space.csv_in))
        name_space.csv_in.close()


if __name__ == '__main__':
    main()

