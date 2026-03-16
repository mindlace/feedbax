{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 9,
			"minor": 0,
			"revision": 7,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "box",
		"rect": [
			101.0,
			87.0,
			1142.0,
			779.0
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "obj-55",
					"int": 1,
					"maxclass": "gswitch2",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						277.83333333333337,
						630.0,
						39.0,
						32.0
					]
				}
			},
			{
				"box": {
					"id": "obj-22",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						164.0,
						24.0,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-25",
					"linecount": 18,
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						29.0,
						185.20001200000002,
						50.0,
						250.0
					],
					"text": "4 -251.518661 68.19693 -138.861374 -0.233919 0.295343 -0.306857 0.87401 0. 0. 0. 1 102.977837"
				}
			},
			{
				"box": {
					"id": "obj-19",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						439.9569528592226,
						460.50758730580515,
						31.0,
						22.0
					],
					"text": "float"
				}
			},
			{
				"box": {
					"id": "obj-21",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						390.0,
						422.19999699999994,
						59.0,
						22.0
					],
					"text": "r ctrlbang"
				}
			},
			{
				"box": {
					"id": "obj-53",
					"linecount": 3,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						353.25,
						270.200012,
						62.0,
						47.0
					],
					"text": "-.1 grab disable hack"
				}
			},
			{
				"box": {
					"id": "obj-43",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						846.0,
						165.04854142665863,
						150.0,
						34.0
					],
					"text": "removed toggles\n"
				}
			},
			{
				"box": {
					"id": "obj-31",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						484.0,
						678.0,
						60.0,
						22.0
					],
					"text": "zl.change"
				}
			},
			{
				"box": {
					"id": "obj-20",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						41.0,
						717.3494004638901,
						450.0,
						22.0
					],
					"text": "0. 0. 0. 0. 0. 0. 0. 0. 1."
				}
			},
			{
				"box": {
					"id": "obj-5",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						347.25,
						324.200012,
						84.0,
						22.0
					],
					"text": "loadmess -0.1"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-60",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						383.0,
						366.0,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-52",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1053.0,
						372.0,
						29.5,
						22.0
					],
					"text": "0"
				}
			},
			{
				"box": {
					"id": "obj-42",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						602.912613093853,
						225.24271535873413,
						115.0,
						22.0
					],
					"text": "s leap2HandsActive"
				}
			},
			{
				"box": {
					"id": "obj-18",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						602.912613093853,
						193.2038808465004,
						29.5,
						22.0
					],
					"text": "||"
				}
			},
			{
				"box": {
					"id": "obj-10",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						712.0,
						154.0,
						150.0,
						20.0
					],
					"text": "hands present"
				}
			},
			{
				"box": {
					"id": "obj-2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						184.0,
						585.0,
						100.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-9",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						478.5253359290182,
						245.5,
						22.0,
						22.0
					],
					"text": "t b"
				}
			},
			{
				"box": {
					"id": "obj-7",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						434.0,
						315.200012,
						29.5,
						22.0
					],
					"text": "||"
				}
			},
			{
				"box": {
					"id": "obj-51",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						247.0,
						21.0,
						24.0,
						24.0
					]
				}
			},
			{
				"box": {
					"id": "obj-49",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						339.0,
						36.0,
						57.0,
						22.0
					],
					"text": "active $1"
				}
			},
			{
				"box": {
					"id": "obj-46",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						620.7332353333336,
						299.200012,
						24.0,
						24.0
					]
				}
			},
			{
				"box": {
					"id": "obj-47",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						620.7332353333336,
						263.200012,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-45",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						775.1359212915474,
						422.19999699999994,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-44",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						484.33333333333337,
						368.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-41",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						85.0,
						269.0,
						24.0,
						24.0
					]
				}
			},
			{
				"box": {
					"id": "obj-39",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						85.0,
						233.0,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-38",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						110.0,
						378.19999699999994,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-35",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						274.09092464284674,
						297.200012,
						62.0,
						20.0
					],
					"text": "Grab"
				}
			},
			{
				"box": {
					"id": "obj-36",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						284.04708971531454,
						378.19999699999994,
						36.0,
						22.0
					],
					"text": "> 0.8"
				}
			},
			{
				"box": {
					"id": "obj-37",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						278.04708971531454,
						326.0,
						47.0,
						22.0
					],
					"text": "zl nth 8"
				}
			},
			{
				"box": {
					"id": "obj-33",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						390.0,
						565.0,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-27",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						880.0909246428467,
						324.200012,
						62.0,
						20.0
					],
					"text": "Grab"
				}
			},
			{
				"box": {
					"id": "obj-13",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						824.4503248598235,
						378.19999699999994,
						36.0,
						22.0
					],
					"text": "> 0.8"
				}
			},
			{
				"box": {
					"id": "obj-8",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						871.5,
						323.200012,
						47.0,
						22.0
					],
					"text": "zl nth 5"
				}
			},
			{
				"box": {
					"id": "obj-124",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						846.0,
						448.0,
						98.0,
						22.0
					],
					"text": "scale -1. 1. 1. -1."
				}
			},
			{
				"box": {
					"id": "obj-123",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"float",
						"float",
						"float"
					],
					"patching_rect": [
						720.1359212915474,
						318.44659757614136,
						87.0,
						22.0
					],
					"text": "unpack 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-121",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						720.1359212915474,
						282.52426797151566,
						55.0,
						22.0
					],
					"text": "zl slice 3"
				}
			},
			{
				"box": {
					"id": "obj-119",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						530.0,
						336.0,
						55.0,
						22.0
					],
					"text": "zl slice 3"
				}
			},
			{
				"box": {
					"id": "obj-120",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						501.0,
						299.200012,
						55.0,
						22.0
					],
					"text": "zl slice 1"
				}
			},
			{
				"box": {
					"id": "obj-114",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						164.33333333333337,
						332.0,
						55.0,
						22.0
					],
					"text": "zl slice 3"
				}
			},
			{
				"box": {
					"id": "obj-113",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						135.33333333333337,
						295.200012,
						55.0,
						22.0
					],
					"text": "zl slice 1"
				}
			},
			{
				"box": {
					"id": "obj-6",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						422.33333333333337,
						603.0,
						24.0,
						24.0
					]
				}
			},
			{
				"box": {
					"id": "obj-11",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						484.33333333333337,
						630.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-23",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						880.0909246428467,
						583.4852004678955,
						44.0,
						20.0
					],
					"text": "theta",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-61",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						820.9503248598234,
						583.4852004678955,
						43.0,
						20.0
					],
					"text": "scale",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-24",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						759.7274959340715,
						583.4852004678955,
						45.0,
						20.0
					],
					"text": "yshift",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-12",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						702.669125293777,
						583.4852004678955,
						41.0,
						20.0
					],
					"text": "xshift",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-14",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						599.8017135134512,
						583.4852004678955,
						85.0,
						20.0
					],
					"text": "scalebright",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-15",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						545.8666865872497,
						583.4852004678955,
						38.0,
						20.0
					],
					"text": "bias",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-16",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						495.05500337514115,
						583.4852004678955,
						35.0,
						20.0
					],
					"text": "hue",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-26",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						940.2726389972341,
						583.4852004678955,
						33.0,
						20.0
					],
					"text": "NC",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-17",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						989.002093066614,
						583.4852004678955,
						36.0,
						20.0
					],
					"text": "sat",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-75",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"float",
						"float",
						"float"
					],
					"patching_rect": [
						842.4506293137869,
						489.9802419982376,
						87.0,
						22.0
					],
					"text": "unpack 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-76",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						482.8888933261236,
						489.9802419982376,
						111.0,
						22.0
					],
					"text": "scale -20. 35. 1. -1."
				}
			},
			{
				"box": {
					"id": "obj-79",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						511.5,
						717.3494004638901,
						92.0,
						22.0
					],
					"text": "s shadeCtlLeap"
				}
			},
			{
				"box": {
					"id": "obj-94",
					"maxclass": "newobj",
					"numinlets": 9,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						507.05500337514115,
						556.4852004678955,
						517.9470896914728,
						22.0
					],
					"text": "pack 0. 0. 0. 0. 0. 0. 0. 0. 1."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-83",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						599.7332353333335,
						489.9802419982376,
						107.0,
						22.0
					],
					"text": "scale 20. 50. 1. -1."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-84",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						277.83333333333337,
						496.666656,
						108.0,
						22.0
					],
					"text": "scale -15 15. -1. 1."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-85",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						142.83333333333337,
						422.19999699999994,
						88.0,
						22.0
					],
					"text": "vexpr $f1 * 0.1"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-86",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						40.58348633333338,
						496.666656,
						101.0,
						22.0
					],
					"text": "scale -20 0. -1. 1."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-87",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						160.83348633333338,
						496.666656,
						104.0,
						22.0
					],
					"text": "scale 14 50. -1. 1."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-88",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"float",
						"float",
						"float"
					],
					"patching_rect": [
						140.1334741263022,
						450.1999816894531,
						89.0,
						22.0
					],
					"text": "unpack 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-4",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						717.5680412553075,
						489.9802419982376,
						108.0,
						22.0
					],
					"text": "scale -20 20. -1. 1."
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-92",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"float",
						"float",
						"float"
					],
					"patching_rect": [
						594.8333333333334,
						450.0,
						89.0,
						22.0
					],
					"text": "unpack 0. 0. 0."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-93",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						594.8333333333334,
						419.0,
						88.0,
						22.0
					],
					"text": "vexpr $f1 * 0.1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						627.5833333333334,
						107.0,
						80.0,
						22.0
					],
					"text": "s frame_info"
				}
			},
			{
				"box": {
					"id": "obj-34",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"outlettype": [
						"int",
						"int",
						"int",
						"float"
					],
					"patching_rect": [
						454.0,
						157.0,
						198.0,
						22.0
					],
					"text": "unpack i i i f"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-30",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						255.83333333333337,
						107.0,
						84.0,
						22.0
					],
					"text": "s right_fingers"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-32",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						131.91666666666669,
						107.0,
						77.0,
						22.0
					],
					"text": "s left_fingers"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-28",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						503.6666666666667,
						107.0,
						80.0,
						22.0
					],
					"text": "s right_hand"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-29",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						379.75,
						107.0,
						75.0,
						22.0
					],
					"text": "s left_hand"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-117",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 0,
					"patcher": {
						"fileversion": 1,
						"appversion": {
							"major": 9,
							"minor": 0,
							"revision": 7,
							"architecture": "x64",
							"modernui": 1
						},
						"classnamespace": "box",
						"rect": [
							225.0,
							233.0,
							634.0,
							174.0
						],
						"gridsize": [
							15.0,
							15.0
						],
						"boxes": [
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-28",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										233.5,
										51.0,
										80.0,
										22.0
									],
									"text": "r right_hand"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-29",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										219.5,
										25.0,
										75.0,
										22.0
									],
									"text": "r left_hand"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-30",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										93.5,
										42.0,
										84.0,
										22.0
									],
									"text": "r right_fingers"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-3",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										9.5,
										42.0,
										77.0,
										22.0
									],
									"text": "r left_fingers"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-2",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 4,
									"outlettype": [
										"",
										"",
										"",
										""
									],
									"patching_rect": [
										9.5,
										91.0,
										79.0,
										22.0
									],
									"saved_object_attributes": {
										"embed": 0,
										"precision": 6
									},
									"text": "coll fingers_L"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-1",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 4,
									"outlettype": [
										"",
										"",
										"",
										""
									],
									"patching_rect": [
										93.5,
										91.0,
										81.0,
										22.0
									],
									"saved_object_attributes": {
										"embed": 0,
										"precision": 6
									},
									"text": "coll fingers_R"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-100",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										392.0,
										42.0,
										76.0,
										22.0
									],
									"text": "r leap_frame"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-114",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										513.5,
										14.0,
										84.0,
										22.0
									],
									"text": "r start_frame"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-13",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										513.5,
										45.0,
										37.0,
										22.0
									],
									"text": "clear"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-11",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 4,
									"outlettype": [
										"",
										"",
										"",
										""
									],
									"patching_rect": [
										219.5,
										91.0,
										65.0,
										22.0
									],
									"saved_object_attributes": {
										"embed": 0,
										"precision": 6
									},
									"text": "coll hands"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-14",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 4,
									"outlettype": [
										"",
										"",
										"",
										""
									],
									"patching_rect": [
										392.0,
										91.0,
										63.0,
										22.0
									],
									"saved_object_attributes": {
										"embed": 0,
										"precision": 6
									},
									"text": "coll frame"
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-14",
										0
									],
									"source": [
										"obj-100",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-13",
										0
									],
									"source": [
										"obj-114",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-1",
										0
									],
									"midpoints": [
										523.0,
										78.5,
										103.0,
										78.5
									],
									"order": 2,
									"source": [
										"obj-13",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-11",
										0
									],
									"midpoints": [
										523.0,
										78.5,
										229.0,
										78.5
									],
									"order": 1,
									"source": [
										"obj-13",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-14",
										0
									],
									"midpoints": [
										523.0,
										78.5,
										401.5,
										78.5
									],
									"order": 0,
									"source": [
										"obj-13",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-2",
										0
									],
									"midpoints": [
										523.0,
										78.5,
										19.0,
										78.5
									],
									"order": 3,
									"source": [
										"obj-13",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-11",
										0
									],
									"source": [
										"obj-28",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-11",
										0
									],
									"source": [
										"obj-29",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-2",
										0
									],
									"source": [
										"obj-3",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-1",
										0
									],
									"source": [
										"obj-30",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						131.91666666666669,
						137.5,
						77.0,
						22.0
					],
					"text": "p fill_coll"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-111",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						8.0,
						107.0,
						78.0,
						22.0
					],
					"text": "s end_frame"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-110",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						751.5,
						107.0,
						80.0,
						22.0
					],
					"text": "s start_frame"
				}
			},
			{
				"box": {
					"id": "obj-1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 10,
					"outlettype": [
						"anything",
						"anything",
						"anything",
						"anything",
						"anything",
						"anything",
						"anything",
						"anything",
						"anything",
						"anything"
					],
					"patching_rect": [
						8.0,
						75.0,
						762.5,
						22.0
					],
					"text": "ultraleap"
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"destination": [
						"obj-110",
						0
					],
					"source": [
						"obj-1",
						6
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-111",
						0
					],
					"source": [
						"obj-1",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-113",
						0
					],
					"order": 1,
					"source": [
						"obj-1",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-120",
						0
					],
					"order": 1,
					"source": [
						"obj-1",
						4
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-28",
						0
					],
					"order": 0,
					"source": [
						"obj-1",
						4
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-29",
						0
					],
					"order": 0,
					"source": [
						"obj-1",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-3",
						0
					],
					"order": 0,
					"source": [
						"obj-1",
						5
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-30",
						0
					],
					"source": [
						"obj-1",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-32",
						0
					],
					"source": [
						"obj-1",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-34",
						0
					],
					"midpoints": [
						430.55555555555554,
						148.0,
						463.5,
						148.0
					],
					"order": 1,
					"source": [
						"obj-1",
						5
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-31",
						0
					],
					"source": [
						"obj-11",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-114",
						0
					],
					"source": [
						"obj-113",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-37",
						0
					],
					"source": [
						"obj-114",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-38",
						1
					],
					"source": [
						"obj-114",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-121",
						0
					],
					"source": [
						"obj-119",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-44",
						1
					],
					"source": [
						"obj-119",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-119",
						0
					],
					"source": [
						"obj-120",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-123",
						0
					],
					"source": [
						"obj-121",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-8",
						0
					],
					"source": [
						"obj-121",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-45",
						1
					],
					"source": [
						"obj-123",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-75",
						0
					],
					"source": [
						"obj-124",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-44",
						0
					],
					"order": 1,
					"source": [
						"obj-13",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-45",
						0
					],
					"order": 0,
					"source": [
						"obj-13",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-42",
						0
					],
					"source": [
						"obj-18",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						0
					],
					"source": [
						"obj-19",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-19",
						0
					],
					"source": [
						"obj-21",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-51",
						0
					],
					"source": [
						"obj-22",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-55",
						1
					],
					"order": 1,
					"source": [
						"obj-31",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-79",
						0
					],
					"order": 0,
					"source": [
						"obj-31",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-6",
						0
					],
					"source": [
						"obj-33",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-18",
						1
					],
					"order": 0,
					"source": [
						"obj-34",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-18",
						0
					],
					"order": 0,
					"source": [
						"obj-34",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-7",
						1
					],
					"order": 1,
					"source": [
						"obj-34",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-7",
						0
					],
					"order": 2,
					"source": [
						"obj-34",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-9",
						0
					],
					"order": 1,
					"source": [
						"obj-34",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-38",
						0
					],
					"source": [
						"obj-36",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-36",
						0
					],
					"source": [
						"obj-37",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-85",
						0
					],
					"source": [
						"obj-38",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-41",
						0
					],
					"source": [
						"obj-39",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						5
					],
					"source": [
						"obj-4",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-38",
						0
					],
					"source": [
						"obj-41",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-93",
						0
					],
					"source": [
						"obj-44",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-124",
						0
					],
					"source": [
						"obj-45",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-44",
						0
					],
					"order": 1,
					"source": [
						"obj-46",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-45",
						0
					],
					"order": 0,
					"source": [
						"obj-46",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-46",
						0
					],
					"source": [
						"obj-47",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-1",
						0
					],
					"source": [
						"obj-49",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-60",
						0
					],
					"source": [
						"obj-5",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-49",
						0
					],
					"source": [
						"obj-51",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-13",
						1
					],
					"source": [
						"obj-52",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-20",
						1
					],
					"source": [
						"obj-55",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-11",
						0
					],
					"source": [
						"obj-6",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-13",
						1
					],
					"order": 0,
					"source": [
						"obj-60",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-36",
						1
					],
					"order": 1,
					"source": [
						"obj-60",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-11",
						0
					],
					"source": [
						"obj-7",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						7
					],
					"source": [
						"obj-75",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						6
					],
					"source": [
						"obj-75",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						3
					],
					"source": [
						"obj-76",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-13",
						0
					],
					"source": [
						"obj-8",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						4
					],
					"source": [
						"obj-83",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						2
					],
					"source": [
						"obj-84",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-88",
						0
					],
					"source": [
						"obj-85",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-19",
						1
					],
					"source": [
						"obj-86",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						1
					],
					"source": [
						"obj-87",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-84",
						0
					],
					"source": [
						"obj-88",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-86",
						0
					],
					"source": [
						"obj-88",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-87",
						0
					],
					"source": [
						"obj-88",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-7",
						0
					],
					"source": [
						"obj-9",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-4",
						0
					],
					"source": [
						"obj-92",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-76",
						0
					],
					"source": [
						"obj-92",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-83",
						0
					],
					"source": [
						"obj-92",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-92",
						0
					],
					"source": [
						"obj-93",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-11",
						1
					],
					"source": [
						"obj-94",
						0
					]
				}
			}
		],
		"boxgroups": [
			{
				"boxes": [
					"obj-17",
					"obj-26",
					"obj-23",
					"obj-61",
					"obj-24",
					"obj-12",
					"obj-14",
					"obj-15",
					"obj-16"
				]
			}
		]
	}
}
