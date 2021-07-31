defmodule Marvin.RiverGaugeMonitorTest do
  use ExUnit.Case
  doctest Marvin.RiverGaugeMonitor

  @typedoc """

  The following JSON example is from a time when some of the stations were down and returning empty values lists.

  {
    "name": "ns1:timeSeriesResponseType",
    "declaredType": "org.cuahsi.waterml.TimeSeriesResponseType",
    "scope": "javax.xml.bind.JAXBElement$GlobalScope",
    "value": {
      "queryInfo": {
        "queryURL": "http://waterservices.usgs.gov/nwis/iv/sites=12144500,12142000,12141300,12143400&format=json&period=PT2H",
        "criteria": {
          "locationParam": "[ALL:12144500, ALL:12142000, ALL:12141300, ALL:12143400]",
          "variableParam": "ALL",
          "parameter": []
        },
        "note": [
          {
            "value": "[ALL:12144500, ALL:12142000, ALL:12141300, ALL:12143400]",
            "title": "filter:sites"
          },
          {
            "value": "[mode=PERIOD, period=PT2H, modifiedSince=null]",
            "title": "filter:timeRange"
          },
          {
            "value": "methodIds=[ALL]",
            "title": "filter:methodId"
          },
          {
            "value": "2021-07-22T17:27:53.993Z",
            "title": "requestDT"
          },
          {
            "value": "25bb6970-eb12-11eb-a9ba-005056beda50",
            "title": "requestId"
          },
          {
            "value": "Provisional data are subject to revision. Go to http://waterdata.usgs.gov/nwis/help/?provisional for more information.",
            "title": "disclaimer"
          },
          {
            "value": "caas01",
            "title": "server"
          }
        ]
      },
      "timeSeries": [
        {
          "sourceInfo": {
            "siteName": "MIDDLE FORK SNOQUALMIE RIVER NEAR TANNER, WA",
            "siteCode": [
              {
                "value": "12141300",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.48593975,
                "longitude": -121.6478809
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00060",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807197,
                "default": true
              }
            ],
            "variableName": "Streamflow, ft&#179;/s",
            "variableDescription": "Discharge, cubic feet per second",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "ft3/s"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807197"
          },
          "values": [
            {
              "value": [],
              "qualifier": [],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151153
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12141300:00060:00000"
        },
        {
          "sourceInfo": {
            "siteName": "MIDDLE FORK SNOQUALMIE RIVER NEAR TANNER, WA",
            "siteCode": [
              {
                "value": "12141300",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.48593975,
                "longitude": -121.6478809
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00065",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807202,
                "default": true
              }
            ],
            "variableName": "Gage height, ft",
            "variableDescription": "Gage height, feet",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "ft"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807202"
          },
          "values": [
            {
              "value": [],
              "qualifier": [],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151154
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12141300:00065:00000"
        },
        {
          "sourceInfo": {
            "siteName": "NF SNOQUALMIE RIVER NEAR SNOQUALMIE FALLS, WA",
            "siteCode": [
              {
                "value": "12142000",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.61482536,
                "longitude": -121.7134437
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00060",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807197,
                "default": true
              }
            ],
            "variableName": "Streamflow, ft&#179;/s",
            "variableDescription": "Discharge, cubic feet per second",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "ft3/s"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807197"
          },
          "values": [
            {
              "value": [
                {
                  "value": "98.5",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:30:00.000-07:00"
                },
                {
                  "value": "98.5",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:45:00.000-07:00"
                },
                {
                  "value": "98.5",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:00:00.000-07:00"
                },
                {
                  "value": "98.5",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:15:00.000-07:00"
                },
                {
                  "value": "98.5",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:30:00.000-07:00"
                },
                {
                  "value": "98.5",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:45:00.000-07:00"
                },
                {
                  "value": "98.5",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:00:00.000-07:00"
                },
                {
                  "value": "98.5",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:15:00.000-07:00"
                }
              ],
              "qualifier": [
                {
                  "qualifierCode": "P",
                  "qualifierDescription": "Provisional data subject to revision.",
                  "qualifierID": 0,
                  "network": "NWIS",
                  "vocabulary": "uv_rmk_cd"
                }
              ],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151160
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12142000:00060:00000"
        },
        {
          "sourceInfo": {
            "siteName": "NF SNOQUALMIE RIVER NEAR SNOQUALMIE FALLS, WA",
            "siteCode": [
              {
                "value": "12142000",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.61482536,
                "longitude": -121.7134437
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00065",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807202,
                "default": true
              }
            ],
            "variableName": "Gage height, ft",
            "variableDescription": "Gage height, feet",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "ft"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807202"
          },
          "values": [
            {
              "value": [
                {
                  "value": "2.11",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:30:00.000-07:00"
                },
                {
                  "value": "2.11",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:45:00.000-07:00"
                },
                {
                  "value": "2.11",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:00:00.000-07:00"
                },
                {
                  "value": "2.11",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:15:00.000-07:00"
                },
                {
                  "value": "2.11",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:30:00.000-07:00"
                },
                {
                  "value": "2.11",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:45:00.000-07:00"
                },
                {
                  "value": "2.11",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:00:00.000-07:00"
                },
                {
                  "value": "2.11",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:15:00.000-07:00"
                }
              ],
              "qualifier": [
                {
                  "qualifierCode": "P",
                  "qualifierDescription": "Provisional data subject to revision.",
                  "qualifierID": 0,
                  "network": "NWIS",
                  "vocabulary": "uv_rmk_cd"
                }
              ],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151161
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12142000:00065:00000"
        },
        {
          "sourceInfo": {
            "siteName": "SF SNOQUALMIE RIVER AB ALICE CREEK NEAR GARCIA, WA",
            "siteCode": [
              {
                "value": "12143400",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.4151086,
                "longitude": -121.5873213
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00021",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807074,
                "default": true
              }
            ],
            "variableName": "Temperature, air, &#176;F",
            "variableDescription": "Temperature, air, degrees Fahrenheit",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "deg F"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807074"
          },
          "values": [
            {
              "value": [
                {
                  "value": "55.8",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:30:00.000-07:00"
                },
                {
                  "value": "56.6",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:45:00.000-07:00"
                },
                {
                  "value": "58.9",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:00:00.000-07:00"
                },
                {
                  "value": "59.1",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:15:00.000-07:00"
                },
                {
                  "value": "60.6",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:30:00.000-07:00"
                },
                {
                  "value": "60.7",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:45:00.000-07:00"
                },
                {
                  "value": "59.6",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:00:00.000-07:00"
                },
                {
                  "value": "61.0",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:15:00.000-07:00"
                }
              ],
              "qualifier": [
                {
                  "qualifierCode": "P",
                  "qualifierDescription": "Provisional data subject to revision.",
                  "qualifierID": 0,
                  "network": "NWIS",
                  "vocabulary": "uv_rmk_cd"
                }
              ],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151172
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12143400:00021:00000"
        },
        {
          "sourceInfo": {
            "siteName": "SF SNOQUALMIE RIVER AB ALICE CREEK NEAR GARCIA, WA",
            "siteCode": [
              {
                "value": "12143400",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.4151086,
                "longitude": -121.5873213
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00045",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807140,
                "default": true
              }
            ],
            "variableName": "Precipitation, total, in",
            "variableDescription": "Precipitation, total, inches",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "in"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807140"
          },
          "values": [
            {
              "value": [
                {
                  "value": "0.00",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:30:00.000-07:00"
                },
                {
                  "value": "0.00",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:45:00.000-07:00"
                },
                {
                  "value": "0.00",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:00:00.000-07:00"
                },
                {
                  "value": "0.00",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:15:00.000-07:00"
                },
                {
                  "value": "0.00",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:30:00.000-07:00"
                },
                {
                  "value": "0.00",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:45:00.000-07:00"
                },
                {
                  "value": "0.00",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:00:00.000-07:00"
                },
                {
                  "value": "0.00",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:15:00.000-07:00"
                }
              ],
              "qualifier": [
                {
                  "qualifierCode": "P",
                  "qualifierDescription": "Provisional data subject to revision.",
                  "qualifierID": 0,
                  "network": "NWIS",
                  "vocabulary": "uv_rmk_cd"
                }
              ],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151169
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12143400:00045:00000"
        },
        {
          "sourceInfo": {
            "siteName": "SF SNOQUALMIE RIVER AB ALICE CREEK NEAR GARCIA, WA",
            "siteCode": [
              {
                "value": "12143400",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.4151086,
                "longitude": -121.5873213
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00060",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807197,
                "default": true
              }
            ],
            "variableName": "Streamflow, ft&#179;/s",
            "variableDescription": "Discharge, cubic feet per second",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "ft3/s"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807197"
          },
          "values": [
            {
              "value": [
                {
                  "value": "72.3",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:30:00.000-07:00"
                },
                {
                  "value": "72.3",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:45:00.000-07:00"
                },
                {
                  "value": "72.3",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:00:00.000-07:00"
                },
                {
                  "value": "72.3",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:15:00.000-07:00"
                },
                {
                  "value": "72.3",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:30:00.000-07:00"
                },
                {
                  "value": "72.3",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:45:00.000-07:00"
                },
                {
                  "value": "72.3",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:00:00.000-07:00"
                },
                {
                  "value": "72.3",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:15:00.000-07:00"
                }
              ],
              "qualifier": [
                {
                  "qualifierCode": "P",
                  "qualifierDescription": "Provisional data subject to revision.",
                  "qualifierID": 0,
                  "network": "NWIS",
                  "vocabulary": "uv_rmk_cd"
                }
              ],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151167
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12143400:00060:00000"
        },
        {
          "sourceInfo": {
            "siteName": "SF SNOQUALMIE RIVER AB ALICE CREEK NEAR GARCIA, WA",
            "siteCode": [
              {
                "value": "12143400",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.4151086,
                "longitude": -121.5873213
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00065",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807202,
                "default": true
              }
            ],
            "variableName": "Gage height, ft",
            "variableDescription": "Gage height, feet",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "ft"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807202"
          },
          "values": [
            {
              "value": [
                {
                  "value": "10.63",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:30:00.000-07:00"
                },
                {
                  "value": "10.63",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T08:45:00.000-07:00"
                },
                {
                  "value": "10.63",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:00:00.000-07:00"
                },
                {
                  "value": "10.63",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:15:00.000-07:00"
                },
                {
                  "value": "10.63",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:30:00.000-07:00"
                },
                {
                  "value": "10.63",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T09:45:00.000-07:00"
                },
                {
                  "value": "10.63",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:00:00.000-07:00"
                },
                {
                  "value": "10.63",
                  "qualifiers": [
                    "P"
                  ],
                  "dateTime": "2021-07-22T10:15:00.000-07:00"
                }
              ],
              "qualifier": [
                {
                  "qualifierCode": "P",
                  "qualifierDescription": "Provisional data subject to revision.",
                  "qualifierID": 0,
                  "network": "NWIS",
                  "vocabulary": "uv_rmk_cd"
                }
              ],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151168
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12143400:00065:00000"
        },
        {
          "sourceInfo": {
            "siteName": "SNOQUALMIE RIVER NEAR SNOQUALMIE, WA",
            "siteCode": [
              {
                "value": "12144500",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.5451019,
                "longitude": -121.842336
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00060",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807197,
                "default": true
              }
            ],
            "variableName": "Streamflow, ft&#179;/s",
            "variableDescription": "Discharge, cubic feet per second",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "ft3/s"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807197"
          },
          "values": [
            {
              "value": [],
              "qualifier": [],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151191
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12144500:00060:00000"
        },
        {
          "sourceInfo": {
            "siteName": "SNOQUALMIE RIVER NEAR SNOQUALMIE, WA",
            "siteCode": [
              {
                "value": "12144500",
                "network": "NWIS",
                "agencyCode": "USGS"
              }
            ],
            "timeZoneInfo": {
              "defaultTimeZone": {
                "zoneOffset": "-08:00",
                "zoneAbbreviation": "PST"
              },
              "daylightSavingsTimeZone": {
                "zoneOffset": "-07:00",
                "zoneAbbreviation": "PDT"
              },
              "siteUsesDaylightSavingsTime": true
            },
            "geoLocation": {
              "geogLocation": {
                "srs": "EPSG:4326",
                "latitude": 47.5451019,
                "longitude": -121.842336
              },
              "localSiteXY": []
            },
            "note": [],
            "siteType": [],
            "siteProperty": [
              {
                "value": "ST",
                "name": "siteTypeCd"
              },
              {
                "value": "17110010",
                "name": "hucCd"
              },
              {
                "value": "53",
                "name": "stateCd"
              },
              {
                "value": "53033",
                "name": "countyCd"
              }
            ]
          },
          "variable": {
            "variableCode": [
              {
                "value": "00065",
                "network": "NWIS",
                "vocabulary": "NWIS:UnitValues",
                "variableID": 45807202,
                "default": true
              }
            ],
            "variableName": "Gage height, ft",
            "variableDescription": "Gage height, feet",
            "valueType": "Derived Value",
            "unit": {
              "unitCode": "ft"
            },
            "options": {
              "option": [
                {
                  "name": "Statistic",
                  "optionCode": "00000"
                }
              ]
            },
            "note": [],
            "noDataValue": -999999,
            "variableProperty": [],
            "oid": "45807202"
          },
          "values": [
            {
              "value": [],
              "qualifier": [],
              "qualityControlLevel": [],
              "method": [
                {
                  "methodDescription": "",
                  "methodID": 151192
                }
              ],
              "source": [],
              "offset": [],
              "sample": [],
              "censorCode": []
            }
          ],
          "name": "USGS:12144500:00065:00000"
        }
      ]
    },
    "nil": false,
    "globalScope": true,
    "typeSubstituted": false
  }
  """

end
