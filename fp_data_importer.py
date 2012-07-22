#!/usr/bin/env python

import datetime
import plistlib
import sqlite3


def main():
    conn = sqlite3.connect('/Users/Ludo/utils/tmp/flightviewer.sqlite')

    flight_plants = {}

    fids = []

    for row in conn.execute(
            ' '.join([
                'SELECT DISTINCT atl_fp.ACID FROM atl_fp',
                'JOIN atl_arr_tfms_radar',
                'ON atl_arr_tfms_radar.FID = atl_fp.FID'
                ])
            ):
        fp_infos = conn.execute(
                ' '.join([
                    'SELECT FID, ACID, AC_TYPE, ORIGIN, DEP_DATE, DEP_TIME,'
                    'DESTINATION, ARR_DATE, ARR_TIME, FLIGHT_PLAN FROM atl_fp',
                    'WHERE ACID = ?'
                    ]),
                row
                ).fetchone()
        fids.append(fp_infos[0])

        dep_time = datetime.datetime.strptime(
                ' '.join([
                    fp_infos[4],
                    fp_infos[5],
                    ]),
                '%Y%m%d %H:%M:%S'
                )

        arr_time = datetime.datetime.strptime(
                ' '.join([
                    fp_infos[7],
                    fp_infos[8],
                    ]),
                '%Y%m%d %H:%M:%S'
                )

        fp_infos_prepared = {
                'acId': fp_infos[1],
                'acType': fp_infos[2],
                'airportDeparture': fp_infos[3],
                'departureTime': dep_time,
                'airportArrival': fp_infos[6],
                'arrivalTime': arr_time,
                'flightPlan': fp_infos[9],
                }
        flight_plants[str(fp_infos[0])] = fp_infos_prepared

    plistlib.writePlist(flight_plants, 'arrival_ATL_flight_info.plist')

    routes = {}
    for fid in fids:
        route_items_prepared = []

        for point in conn.execute(
                ' '.join([
                    'SELECT LAT, LON, ALT, GND_SPEED, RADAR_HIT_DATE,',
                    'RADAR_HIT_TIME',
                    'FROM atl_arr_tfms_radar WHERE FID = ?'
                    ]),
                (fid,)
                ):
            hit_time = datetime.datetime.strptime(
                ' '.join([
                    point[4],
                    point[5],
                    ]),
                '%Y%m%d %H:%M:%S'
                )

            point_prepared = {
                    'latitude': point[0],
                    'longitude': point[1],
                    'altitude': point[2],
                    'speed': point[3],
                    'time': hit_time,
                    }
            route_items_prepared.append(point_prepared)

        routes[str(fid)] = route_items_prepared

    plistlib.writePlist(routes, 'arrival_ATL_route_points.plist')
    conn.close()

if __name__ == '__main__':
    main()

