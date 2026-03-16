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
			766.0,
			106.0,
			640.0,
			480.0
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "obj-2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						229.0,
						41.0,
						29.5,
						22.0
					],
					"text": "12"
				}
			},
			{
				"box": {
					"id": "obj-105",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						185.0,
						24.5,
						29.5,
						22.0
					],
					"text": "8"
				}
			},
			{
				"box": {
					"id": "obj-102",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						149.0,
						24.5,
						29.5,
						22.0
					],
					"text": "6"
				}
			},
			{
				"box": {
					"id": "obj-101",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						112.0,
						24.5,
						29.5,
						22.0
					],
					"text": "4"
				}
			},
			{
				"box": {
					"id": "obj-54",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						28.5,
						26.9000244140625,
						70.0,
						22.0
					],
					"text": "loadmess 4"
				}
			},
			{
				"box": {
					"id": "obj-63",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						64.5,
						61.5,
						107.0,
						22.0
					],
					"text": "s lineSmoothGrain"
				}
			},
			{
				"box": {
					"id": "obj-100",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 3,
					"outlettype": [
						"bang",
						"bang",
						""
					],
					"patching_rect": [
						633.0,
						148.0,
						44.0,
						22.0
					],
					"text": "sel 0 1"
				}
			},
			{
				"box": {
					"id": "obj-99",
					"linecount": 2,
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						685.0,
						146.0,
						96.0,
						35.0
					],
					"text": ";\rmax showcursor"
				}
			},
			{
				"box": {
					"id": "obj-98",
					"linecount": 2,
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						685.0,
						206.0,
						91.0,
						35.0
					],
					"text": ";\rmax hidecursor"
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"destination": [
						"obj-98",
						0
					],
					"source": [
						"obj-100",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-99",
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
						"obj-63",
						0
					],
					"source": [
						"obj-101",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-63",
						0
					],
					"source": [
						"obj-102",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-63",
						0
					],
					"source": [
						"obj-105",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-63",
						0
					],
					"source": [
						"obj-2",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-63",
						0
					],
					"source": [
						"obj-54",
						0
					]
				}
			}
		]
	}
}
