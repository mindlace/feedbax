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
			156.0,
			134.0,
			1046.0,
			903.0
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "obj-84",
					"linecount": 2,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						291.0,
						99.0,
						266.22443437036463,
						33.0
					],
					"text": "Leap is primarty control, reverts to iPad after 2 seconds of no hands"
				}
			},
			{
				"box": {
					"id": "obj-82",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						369.0,
						67.0,
						24.0,
						24.0
					]
				}
			},
			{
				"box": {
					"id": "obj-80",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"int",
						"int"
					],
					"patching_rect": [
						403.1500020325184,
						62.0,
						48.0,
						22.0
					],
					"text": "change"
				}
			},
			{
				"box": {
					"id": "obj-78",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						477.93996339438706,
						62.0,
						46.0,
						22.0
					],
					"text": "< 2000"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 9.0,
					"id": "obj-77",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						530.0418981554685,
						-6.0,
						46.0,
						19.0
					],
					"text": "r ctrlbang"
				}
			},
			{
				"box": {
					"id": "obj-68",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						403.1500020325184,
						27.0,
						22.0,
						22.0
					],
					"text": "t b"
				}
			},
			{
				"box": {
					"id": "obj-59",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"float",
						""
					],
					"patching_rect": [
						464.0,
						31.0,
						35.0,
						22.0
					],
					"text": "timer"
				}
			},
			{
				"box": {
					"id": "obj-57",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						398.0418981554685,
						-7.0,
						113.0,
						22.0
					],
					"text": "r leap2HandsActive"
				}
			},
			{
				"box": {
					"id": "obj-46",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						160.0,
						838.0,
						643.0,
						22.0
					],
					"text": "0. 0. 0. 0. 0. 0. 0. 0. 1."
				}
			},
			{
				"box": {
					"id": "obj-58",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						741.4399633943872,
						37.599974155426025,
						24.0,
						24.0
					]
				}
			},
			{
				"box": {
					"id": "obj-55",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						341.9999999999999,
						229.0,
						22.0,
						22.0
					],
					"text": "t b"
				}
			},
			{
				"box": {
					"id": "obj-53",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						992.0,
						188.0,
						150.0,
						20.0
					],
					"text": "Color Invert (unused atm)"
				}
			},
			{
				"box": {
					"id": "obj-45",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1023.0,
						215.0,
						73.0,
						22.0
					],
					"text": "loadmess 1."
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
						1083.0,
						356.0,
						29.5,
						22.0
					],
					"text": "-1"
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
						926.0,
						451.0,
						73.0,
						22.0
					],
					"text": "loadmess 1."
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-18",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						1136.0,
						457.0,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-14",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1011.0,
						424.0,
						111.0,
						22.0
					],
					"text": "scale -1. 1. -1.5 1.5"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-12",
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1011.0,
						262.0,
						20.0,
						140.0
					],
					"size": 2.0
				}
			},
			{
				"box": {
					"id": "obj-3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
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
							250.0,
							218.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						1011.0,
						466.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-87",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
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
							250.0,
							218.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						1147.0,
						538.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-89",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1139.0,
						504.0,
						97.0,
						22.0
					],
					"text": "scale 0. 1. 0. 1.5"
				}
			},
			{
				"box": {
					"color": [
						0.941176,
						0.690196,
						0.196078,
						1.0
					],
					"id": "obj-47",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_gl_texture",
						""
					],
					"patching_rect": [
						946.0,
						629.0,
						125.0,
						22.0
					],
					"text": "jit.gl.pix @gen brcosa"
				}
			},
			{
				"box": {
					"activedialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"activeneedlecolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"dialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"hint": "Move this control to set the saturation of the output.",
					"id": "obj-142",
					"maxclass": "live.dial",
					"needlecolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1088.0,
						498.0,
						44.0,
						48.0
					],
					"presentation": 1,
					"presentation_rect": [
						155.4748077392578,
						55.792236328125,
						60.0,
						48.0
					],
					"saved_attribute_attributes": {
						"activedialcolor": {
							"expression": ""
						},
						"activeneedlecolor": {
							"expression": ""
						},
						"dialcolor": {
							"expression": ""
						},
						"needlecolor": {
							"expression": ""
						},
						"valueof": {
							"parameter_initial": [
								1.0
							],
							"parameter_initial_enable": 1,
							"parameter_longname": "saturation[4]",
							"parameter_mmax": 1.5,
							"parameter_modmode": 0,
							"parameter_shortname": "Saturation",
							"parameter_type": 0,
							"parameter_unitstyle": 1
						}
					},
					"varname": "Offset[3]"
				}
			},
			{
				"box": {
					"fontname": "Ableton Sans Medium",
					"fontsize": 12.0,
					"id": "obj-143",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1083.0,
						581.0,
						80.0,
						23.0
					],
					"text": "saturation $1"
				}
			},
			{
				"box": {
					"activedialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"activeneedlecolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"dialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"hint": "Move this control to set the contrast of the output.",
					"id": "obj-129",
					"maxclass": "live.dial",
					"needlecolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1020.0,
						512.0,
						44.0,
						48.0
					],
					"presentation": 1,
					"presentation_rect": [
						86.97479248046875,
						55.792236328125,
						60.0,
						48.0
					],
					"saved_attribute_attributes": {
						"activedialcolor": {
							"expression": ""
						},
						"activeneedlecolor": {
							"expression": ""
						},
						"dialcolor": {
							"expression": ""
						},
						"needlecolor": {
							"expression": ""
						},
						"valueof": {
							"parameter_initial": [
								1.0
							],
							"parameter_initial_enable": 1,
							"parameter_longname": "contrast[3]",
							"parameter_mmax": 1.5,
							"parameter_mmin": -1.5,
							"parameter_modmode": 0,
							"parameter_shortname": "Contrast",
							"parameter_type": 0,
							"parameter_unitstyle": 1
						}
					},
					"varname": "Offset[1]"
				}
			},
			{
				"box": {
					"fontname": "Ableton Sans Medium",
					"fontsize": 12.0,
					"id": "obj-130",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1003.0,
						573.0,
						72.0,
						23.0
					],
					"text": "contrast $1"
				}
			},
			{
				"box": {
					"activedialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"activeneedlecolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"dialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"hint": "Move this control to set the brightness of the output.",
					"id": "obj-121",
					"maxclass": "live.dial",
					"needlecolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						926.0,
						512.0,
						44.0,
						48.0
					],
					"presentation": 1,
					"presentation_rect": [
						18.47480797767639,
						55.792236328125,
						60.0,
						48.0
					],
					"saved_attribute_attributes": {
						"activedialcolor": {
							"expression": ""
						},
						"activeneedlecolor": {
							"expression": ""
						},
						"dialcolor": {
							"expression": ""
						},
						"needlecolor": {
							"expression": ""
						},
						"valueof": {
							"parameter_initial": [
								1.0
							],
							"parameter_initial_enable": 1,
							"parameter_linknames": 1,
							"parameter_longname": "Offset[1]",
							"parameter_mmax": 1.25,
							"parameter_modmode": 0,
							"parameter_shortname": "Brightness",
							"parameter_type": 0,
							"parameter_unitstyle": 1
						}
					},
					"varname": "Offset[2]"
				}
			},
			{
				"box": {
					"fontname": "Ableton Sans Medium",
					"fontsize": 12.0,
					"id": "obj-48",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						910.0,
						573.0,
						83.0,
						23.0
					],
					"text": "brightness $1"
				}
			},
			{
				"box": {
					"id": "obj-38",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						637.2399636447267,
						112.0,
						36.39999830722809,
						20.0
					],
					"text": "NYI"
				}
			},
			{
				"box": {
					"id": "obj-37",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						660.4399639904336,
						134.0,
						36.39999830722809,
						20.0
					],
					"text": "ancy"
				}
			},
			{
				"box": {
					"id": "obj-24",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						620.4399633943872,
						134.0,
						36.39999830722809,
						20.0
					],
					"text": "ancx"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-17",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						741.4399633943872,
						457.0,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-13",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						683.5,
						457.0,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-10",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						653.1066300610538,
						504.0,
						132.0,
						22.0
					],
					"text": "pak param anchor 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-2",
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
							59.0,
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
									"id": "obj-13",
									"maxclass": "comment",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										225.5,
										114.0,
										37.0,
										20.0
									],
									"text": "bias"
								}
							},
							{
								"box": {
									"id": "obj-12",
									"maxclass": "comment",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										80.0,
										100.0,
										37.0,
										20.0
									],
									"text": "sb"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 11.934731,
									"id": "obj-75",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										160.0,
										283.49996107816696,
										84.0,
										22.0
									],
									"text": "param bias $1"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 11.934731,
									"id": "obj-77",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										62.0,
										283.49996107816696,
										90.0,
										22.0
									],
									"text": "param scale $1"
								}
							},
							{
								"box": {
									"filename": "cc.scalebias.jxs",
									"fontface": 0,
									"fontname": "Arial",
									"fontsize": 11.934731,
									"id": "obj-10",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 2,
									"outlettype": [
										"jit_gl_texture",
										""
									],
									"patching_rect": [
										74.5,
										320.6999732851982,
										194.0,
										22.0
									],
									"text": "jit.gl.slab foo @file cc.scalebias.jxs",
									"textfile": {
										"filename": "cc.scalebias.jxs",
										"flags": 0,
										"embed": 0,
										"autowatch": 1
									}
								}
							},
							{
								"box": {
									"format": 6,
									"id": "obj-57",
									"maxclass": "flonum",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"parameter_enable": 0,
									"patching_rect": [
										153.30010986328125,
										242.0999976992607,
										50.0,
										22.0
									]
								}
							},
							{
								"box": {
									"format": 6,
									"id": "obj-55",
									"maxclass": "flonum",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"parameter_enable": 0,
									"patching_rect": [
										68.30010986328125,
										242.0999976992607,
										50.0,
										22.0
									]
								}
							},
							{
								"box": {
									"id": "obj-87",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
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
											250.0,
											218.0,
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
													"maxclass": "newobj",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														295.0,
														244.0,
														105.0,
														22.0
													],
													"text": "r lineSmoothGrain"
												}
											},
											{
												"box": {
													"comment": "",
													"id": "obj-1",
													"index": 1,
													"maxclass": "outlet",
													"numinlets": 1,
													"numoutlets": 0,
													"patching_rect": [
														50.0,
														219.0,
														30.0,
														30.0
													]
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-49",
													"maxclass": "newobj",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														127.0,
														100.0,
														109.0,
														22.0
													],
													"text": "r controlSmoothMs"
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-50",
													"maxclass": "newobj",
													"numinlets": 2,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														50.0,
														131.0,
														73.0,
														22.0
													],
													"text": "pack 0. 200"
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-9",
													"maxclass": "newobj",
													"numinlets": 3,
													"numoutlets": 2,
													"outlettype": [
														"",
														"bang"
													],
													"patching_rect": [
														50.0,
														173.0,
														46.0,
														22.0
													],
													"text": "line 0."
												}
											},
											{
												"box": {
													"comment": "",
													"id": "obj-108",
													"index": 1,
													"maxclass": "inlet",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														41.0,
														47.0,
														30.0,
														30.0
													]
												}
											}
										],
										"lines": [
											{
												"patchline": {
													"destination": [
														"obj-50",
														0
													],
													"source": [
														"obj-108",
														0
													]
												}
											},
											{
												"patchline": {
													"destination": [
														"obj-9",
														2
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
														"obj-50",
														1
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
														"obj-9",
														0
													],
													"source": [
														"obj-50",
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
														"obj-9",
														0
													]
												}
											}
										]
									},
									"patching_rect": [
										289.0,
										413.4000244140625,
										97.0,
										22.0
									],
									"text": "p mIniCtlSmooth"
								}
							},
							{
								"box": {
									"fontface": 0,
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-89",
									"maxclass": "newobj",
									"numinlets": 6,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										282.0,
										379.9000244140625,
										97.0,
										22.0
									],
									"text": "scale 0. 1. 0. 1.5"
								}
							},
							{
								"box": {
									"color": [
										0.941176,
										0.690196,
										0.196078,
										1.0
									],
									"id": "obj-47",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"jit_gl_texture",
										""
									],
									"patching_rect": [
										88.5,
										504.87536641406246,
										125.0,
										22.0
									],
									"text": "jit.gl.pix @gen brcosa"
								}
							},
							{
								"box": {
									"activedialcolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"activeneedlecolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"dialcolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"hint": "Move this control to set the saturation of the output.",
									"id": "obj-142",
									"maxclass": "live.dial",
									"needlecolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"",
										"float"
									],
									"parameter_enable": 1,
									"patching_rect": [
										230.27556562963537,
										374.0,
										44.0,
										48.0
									],
									"presentation": 1,
									"presentation_rect": [
										155.4748077392578,
										55.792236328125,
										60.0,
										48.0
									],
									"saved_attribute_attributes": {
										"activedialcolor": {
											"expression": ""
										},
										"activeneedlecolor": {
											"expression": ""
										},
										"dialcolor": {
											"expression": ""
										},
										"needlecolor": {
											"expression": ""
										},
										"valueof": {
											"parameter_initial": [
												1.0
											],
											"parameter_initial_enable": 1,
											"parameter_longname": "saturation[3]",
											"parameter_mmax": 1.5,
											"parameter_modmode": 0,
											"parameter_shortname": "Saturation",
											"parameter_type": 0,
											"parameter_unitstyle": 1
										}
									},
									"varname": "Offset[3]"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-143",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										225.27556562963525,
										456.0,
										80.0,
										23.0
									],
									"text": "saturation $1"
								}
							},
							{
								"box": {
									"activedialcolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"activeneedlecolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"dialcolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"hint": "Move this control to set the contrast of the output.",
									"id": "obj-129",
									"maxclass": "live.dial",
									"needlecolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"",
										"float"
									],
									"parameter_enable": 1,
									"patching_rect": [
										162.0,
										387.4000244140625,
										44.0,
										48.0
									],
									"presentation": 1,
									"presentation_rect": [
										86.97479248046875,
										55.792236328125,
										60.0,
										48.0
									],
									"saved_attribute_attributes": {
										"activedialcolor": {
											"expression": ""
										},
										"activeneedlecolor": {
											"expression": ""
										},
										"dialcolor": {
											"expression": ""
										},
										"needlecolor": {
											"expression": ""
										},
										"valueof": {
											"parameter_initial": [
												1.0
											],
											"parameter_initial_enable": 1,
											"parameter_longname": "contrast[2]",
											"parameter_mmax": 1.5,
											"parameter_mmin": -1.5,
											"parameter_modmode": 0,
											"parameter_shortname": "Contrast",
											"parameter_type": 0,
											"parameter_unitstyle": 1
										}
									},
									"varname": "Offset[1]"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-130",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										146.0,
										449.0,
										72.0,
										23.0
									],
									"text": "contrast $1"
								}
							},
							{
								"box": {
									"activedialcolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"activeneedlecolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"dialcolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"hint": "Move this control to set the brightness of the output.",
									"id": "obj-121",
									"maxclass": "live.dial",
									"needlecolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"",
										"float"
									],
									"parameter_enable": 1,
									"patching_rect": [
										68.0,
										387.4000244140625,
										44.0,
										48.0
									],
									"presentation": 1,
									"presentation_rect": [
										18.47480797767639,
										55.792236328125,
										60.0,
										48.0
									],
									"saved_attribute_attributes": {
										"activedialcolor": {
											"expression": ""
										},
										"activeneedlecolor": {
											"expression": ""
										},
										"dialcolor": {
											"expression": ""
										},
										"needlecolor": {
											"expression": ""
										},
										"valueof": {
											"parameter_initial": [
												1.0
											],
											"parameter_initial_enable": 1,
											"parameter_linknames": 1,
											"parameter_longname": "Offset[4]",
											"parameter_mmax": 1.25,
											"parameter_modmode": 0,
											"parameter_shortname": "Brightness",
											"parameter_type": 0,
											"parameter_unitstyle": 1
										}
									},
									"varname": "Offset[4]"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-48",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										52.0,
										449.0,
										83.0,
										23.0
									],
									"text": "brightness $1"
								}
							},
							{
								"box": {
									"id": "obj-18",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
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
											360.0,
											424.0,
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
													"maxclass": "newobj",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														295.0,
														244.0,
														105.0,
														22.0
													],
													"text": "r lineSmoothGrain"
												}
											},
											{
												"box": {
													"comment": "",
													"id": "obj-1",
													"index": 1,
													"maxclass": "outlet",
													"numinlets": 1,
													"numoutlets": 0,
													"patching_rect": [
														50.0,
														219.0,
														30.0,
														30.0
													]
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-49",
													"maxclass": "newobj",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														127.0,
														100.0,
														109.0,
														22.0
													],
													"text": "r controlSmoothMs"
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-50",
													"maxclass": "newobj",
													"numinlets": 2,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														50.0,
														131.0,
														73.0,
														22.0
													],
													"text": "pack 0. 200"
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-9",
													"maxclass": "newobj",
													"numinlets": 3,
													"numoutlets": 2,
													"outlettype": [
														"",
														"bang"
													],
													"patching_rect": [
														50.0,
														173.0,
														46.0,
														22.0
													],
													"text": "line 0."
												}
											},
											{
												"box": {
													"comment": "",
													"id": "obj-108",
													"index": 1,
													"maxclass": "inlet",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														41.0,
														47.0,
														30.0,
														30.0
													]
												}
											}
										],
										"lines": [
											{
												"patchline": {
													"destination": [
														"obj-50",
														0
													],
													"source": [
														"obj-108",
														0
													]
												}
											},
											{
												"patchline": {
													"destination": [
														"obj-9",
														2
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
														"obj-50",
														1
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
														"obj-9",
														0
													],
													"source": [
														"obj-50",
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
														"obj-9",
														0
													]
												}
											}
										]
									},
									"patching_rect": [
										50.0,
										183.4000244140625,
										97.0,
										22.0
									],
									"text": "p mIniCtlSmooth"
								}
							},
							{
								"box": {
									"id": "obj-17",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
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
											250.0,
											218.0,
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
													"maxclass": "newobj",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														295.0,
														244.0,
														105.0,
														22.0
													],
													"text": "r lineSmoothGrain"
												}
											},
											{
												"box": {
													"comment": "",
													"id": "obj-1",
													"index": 1,
													"maxclass": "outlet",
													"numinlets": 1,
													"numoutlets": 0,
													"patching_rect": [
														50.0,
														219.0,
														30.0,
														30.0
													]
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-49",
													"maxclass": "newobj",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														127.0,
														100.0,
														109.0,
														22.0
													],
													"text": "r controlSmoothMs"
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-50",
													"maxclass": "newobj",
													"numinlets": 2,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														50.0,
														131.0,
														73.0,
														22.0
													],
													"text": "pack 0. 200"
												}
											},
											{
												"box": {
													"fontname": "Arial",
													"fontsize": 12.0,
													"id": "obj-9",
													"maxclass": "newobj",
													"numinlets": 3,
													"numoutlets": 2,
													"outlettype": [
														"",
														"bang"
													],
													"patching_rect": [
														50.0,
														173.0,
														46.0,
														22.0
													],
													"text": "line 0."
												}
											},
											{
												"box": {
													"comment": "",
													"id": "obj-108",
													"index": 1,
													"maxclass": "inlet",
													"numinlets": 0,
													"numoutlets": 1,
													"outlettype": [
														""
													],
													"patching_rect": [
														41.0,
														47.0,
														30.0,
														30.0
													]
												}
											}
										],
										"lines": [
											{
												"patchline": {
													"destination": [
														"obj-50",
														0
													],
													"source": [
														"obj-108",
														0
													]
												}
											},
											{
												"patchline": {
													"destination": [
														"obj-9",
														2
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
														"obj-50",
														1
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
														"obj-9",
														0
													],
													"source": [
														"obj-50",
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
														"obj-9",
														0
													]
												}
											}
										]
									},
									"patching_rect": [
										165.5,
										179.4000244140625,
										97.0,
										22.0
									],
									"text": "p mIniCtlSmooth"
								}
							},
							{
								"box": {
									"fontface": 0,
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-68",
									"maxclass": "newobj",
									"numinlets": 6,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										165.5,
										151.4000244140625,
										111.0,
										22.0
									],
									"text": "scale -1. 1. -0.5 0.1"
								}
							},
							{
								"box": {
									"fontface": 0,
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-67",
									"maxclass": "newobj",
									"numinlets": 6,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										55.0,
										146.4000244140625,
										107.0,
										22.0
									],
									"text": "scale -1. 1. 0.5 1.5"
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-48",
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
										"obj-130",
										0
									],
									"source": [
										"obj-129",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-47",
										0
									],
									"source": [
										"obj-130",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-143",
										0
									],
									"source": [
										"obj-142",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-47",
										0
									],
									"source": [
										"obj-143",
										0
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
										"obj-17",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-77",
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
										"obj-47",
										0
									],
									"source": [
										"obj-48",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-77",
										0
									],
									"source": [
										"obj-55",
										0
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
										"obj-57",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-18",
										0
									],
									"source": [
										"obj-67",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-17",
										0
									],
									"source": [
										"obj-68",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-10",
										0
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
										"obj-10",
										0
									],
									"source": [
										"obj-77",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-143",
										0
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
										"obj-87",
										0
									],
									"source": [
										"obj-89",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						9.0,
						7.0,
						75.0,
						22.0
					],
					"text": "p oldconrtrol"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-1",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						735.5,
						625.2000343203545,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-76",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						559.7175066437566,
						620.2000343203545,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-73",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						335.9799305663212,
						625.2000343203545,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-64",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						495.9504056588588,
						584.2000343203545,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-65",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						477.93996339438706,
						620.2000343203545,
						31.0,
						22.0
					],
					"text": "* -1."
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-61",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						683.5,
						597.0,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-62",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						679.4399633943872,
						635.0,
						31.0,
						22.0
					],
					"text": "* -1."
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-54",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						291.0,
						582.2000343203545,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-52",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						280.0,
						625.2000343203545,
						31.0,
						22.0
					],
					"text": "* -1."
				}
			},
			{
				"box": {
					"id": "obj-50",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
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
							250.0,
							218.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						627.4399633943872,
						699.4000244140625,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-51",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						620.4399633943872,
						665.9000244140625,
						141.0,
						22.0
					],
					"text": "scale 0. 1. -0.05 0.05 0.1"
				}
			},
			{
				"box": {
					"id": "obj-27",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
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
							250.0,
							218.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						427.71750664375656,
						708.4000244140625,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-36",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						427.71750664375656,
						656.2000343203545,
						151.0,
						22.0
					],
					"text": "scale -1. 1. -0.04 0.02 0.05"
				}
			},
			{
				"box": {
					"id": "obj-8",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						456.5,
						757.8753664140625,
						73.0,
						22.0
					],
					"text": "lightness $1"
				}
			},
			{
				"box": {
					"id": "obj-4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						360.5,
						757.8753664140625,
						78.0,
						22.0
					],
					"text": "saturation $1"
				}
			},
			{
				"box": {
					"id": "obj-30",
					"maxclass": "gswitch",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						164.0,
						92.0,
						41.0,
						32.0
					]
				}
			},
			{
				"box": {
					"id": "obj-16",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						258.0418981554685,
						1.0,
						90.0,
						22.0
					],
					"text": "r shadeCtlLeap"
				}
			},
			{
				"box": {
					"id": "obj-44",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						326.0,
						193.0,
						54.0,
						22.0
					],
					"text": "r SInvert"
				}
			},
			{
				"box": {
					"id": "obj-39",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						869.0,
						133.0,
						22.0,
						22.0
					],
					"text": "t b"
				}
			},
			{
				"box": {
					"id": "obj-40",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						852.1399645149545,
						83.59997415542603,
						29.5,
						22.0
					],
					"text": "-1."
				}
			},
			{
				"box": {
					"id": "obj-41",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						807.6399645149545,
						83.59997415542603,
						29.5,
						22.0
					],
					"text": "1."
				}
			},
			{
				"box": {
					"id": "obj-42",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 3,
					"outlettype": [
						"bang",
						"bang",
						""
					],
					"patching_rect": [
						852.1399645149545,
						38.599974155426025,
						44.0,
						22.0
					],
					"text": "sel 0 1"
				}
			},
			{
				"box": {
					"id": "obj-43",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						812.1399645149545,
						2.999998569488525,
						93.0,
						22.0
					],
					"text": "r scaleInvtoggle"
				}
			},
			{
				"box": {
					"id": "obj-35",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						487.26710098489775,
						384.0,
						54.0,
						22.0
					],
					"text": "r SInvert"
				}
			},
			{
				"box": {
					"id": "obj-34",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						800.6399645149545,
						170.19998168945312,
						56.0,
						22.0
					],
					"text": "s SInvert"
				}
			},
			{
				"box": {
					"id": "obj-33",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						395.6500020325184,
						248.0,
						29.5,
						22.0
					],
					"text": "* 1."
				}
			},
			{
				"box": {
					"id": "obj-32",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						277.25,
						248.0,
						29.5,
						22.0
					],
					"text": "* 1."
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-199",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						487.26710098489775,
						134.0,
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
					"id": "obj-200",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						438.8447339899317,
						134.0,
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
					"id": "obj-201",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						388.71750664375645,
						134.0,
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
					"id": "obj-202",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						341.9999999999999,
						134.0,
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
					"id": "obj-203",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						257.77556562963537,
						134.0,
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
					"id": "obj-204",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						213.61534951269311,
						134.0,
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
					"id": "obj-205",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						172.01242392256472,
						134.0,
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
					"id": "obj-206",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						536.5418981554685,
						134.0,
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
					"id": "obj-207",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						576.4399633943872,
						134.0,
						36.0,
						20.0
					],
					"text": "sat",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-28",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						448.71750664375645,
						414.0999976992607,
						31.0,
						22.0
					],
					"text": "* -1."
				}
			},
			{
				"box": {
					"id": "obj-164",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						433.26710098489775,
						321.0,
						104.0,
						22.0
					],
					"text": "scale -1. 1 0.4 1.2"
				}
			},
			{
				"box": {
					"id": "obj-31",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						219.5,
						667.4000686407089,
						145.0,
						22.0
					],
					"text": "scale -1. 1. -0.05 0.05 0.1"
				}
			},
			{
				"box": {
					"id": "obj-29",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						267.0,
						757.8753664140625,
						74.0,
						22.0
					],
					"text": "hue_shift $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-25",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_gl_texture",
						""
					],
					"patcher": {
						"fileversion": 1,
						"appversion": {
							"major": 9,
							"minor": 0,
							"revision": 7,
							"architecture": "x64",
							"modernui": 1
						},
						"classnamespace": "jit.gen",
						"rect": [
							34.0,
							87.0,
							600.0,
							450.0
						],
						"gridsize": [
							15.0,
							15.0
						],
						"title": "untitled",
						"boxes": [
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-10",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										482.0,
										100.0,
										113.0,
										22.0
									],
									"text": "param lightness 0.5"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										362.0,
										100.0,
										119.0,
										22.0
									],
									"text": "param saturation 0.5"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-7",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										278.0,
										157.0,
										67.0,
										22.0
									],
									"text": "vec 0. 0. 0."
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-6",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										232.0,
										100.0,
										121.0,
										22.0
									],
									"text": "param hue_shift 0.02"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-5",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										176.0,
										247.0,
										50.0,
										22.0
									],
									"text": "hsl2rgb"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-2",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										176.0,
										195.0,
										32.5,
										22.0
									],
									"text": "+"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-1",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										14.0,
										30.0,
										22.0
									],
									"text": "in 1"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-3",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										176.0,
										149.0,
										50.0,
										22.0
									],
									"text": "rgb2hsl"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-4",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										176.0,
										418.0,
										37.0,
										22.0
									],
									"text": "out 1"
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-3",
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
										"obj-7",
										2
									],
									"source": [
										"obj-10",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-5",
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
										"obj-4",
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
										"obj-7",
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
										"obj-2",
										1
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
										"obj-7",
										1
									],
									"source": [
										"obj-9",
										0
									]
								}
							}
						],
						"bgcolor": [
							0.9,
							0.9,
							0.9,
							1.0
						],
						"editing_bgcolor": [
							0.9,
							0.9,
							0.9,
							1.0
						]
					},
					"patching_rect": [
						288.0,
						802.9126103520393,
						54.0,
						23.0
					],
					"text": "jit.gl.pix"
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
							360.0,
							424.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						620.4399633943872,
						384.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-21",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
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
							360.0,
							424.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						436.26710098489775,
						353.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-20",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
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
							360.0,
							424.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						326.26710098489775,
						322.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-19",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
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
							360.0,
							424.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						225.26710098489775,
						322.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-15",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						157.04189815546852,
						1.0,
						63.0,
						22.0
					],
					"text": "r shadeCtl"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-93",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						627.4399633943872,
						355.0,
						151.0,
						22.0
					],
					"text": "scale -1. 1. 3.1415 -3.1415"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-92",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						525.2671009848978,
						414.0999976992607,
						111.0,
						22.0
					],
					"text": "pak param theta 0."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-91",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						354.71750664375645,
						449.0,
						113.0,
						22.0
					],
					"text": "pak param zoom 0."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-88",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						211.26710098489775,
						364.0,
						124.0,
						22.0
					],
					"text": "pak param offset 0. 0."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-72",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						379.26710098489775,
						278.0,
						138.0,
						22.0
					],
					"text": "scale -1. 1. -2000. 2000."
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-69",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						225.26710098489775,
						284.0,
						138.0,
						22.0
					],
					"text": "scale -1. 1. -2000. 2000."
				}
			},
			{
				"box": {
					"id": "obj-26",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
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
							360.0,
							424.0,
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
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										295.0,
										244.0,
										105.0,
										22.0
									],
									"text": "r lineSmoothGrain"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										50.0,
										219.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-49",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										127.0,
										100.0,
										109.0,
										22.0
									],
									"text": "r controlSmoothMs"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										131.0,
										73.0,
										22.0
									],
									"text": "pack 0. 200"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-9",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"bang"
									],
									"patching_rect": [
										50.0,
										173.0,
										46.0,
										22.0
									],
									"text": "line 0."
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-108",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										41.0,
										47.0,
										30.0,
										30.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-50",
										0
									],
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-9",
										2
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
										"obj-50",
										1
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
										"obj-9",
										0
									],
									"source": [
										"obj-50",
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
										"obj-9",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						219.5,
						704.100058734417,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-11",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 11,
					"outlettype": [
						"float",
						"float",
						"float",
						"float",
						"float",
						"float",
						"float",
						"float",
						"float",
						"float",
						"float"
					],
					"patching_rect": [
						177.0,
						156.0,
						466.8000040650368,
						22.0
					],
					"text": "unpack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-7",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						525.2671009848978,
						446.0,
						72.0,
						22.0
					],
					"text": "loadmess 4"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-70",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 0,
					"patching_rect": [
						525.2671009848978,
						473.0,
						50.0,
						22.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 9.0,
					"id": "obj-56",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						525.2671009848978,
						499.0,
						99.0,
						19.0
					],
					"text": "param boundmode $1"
				}
			},
			{
				"box": {
					"color": [
						1.0,
						0.890196,
						0.090196,
						1.0
					],
					"filename": "td.rota.jxs",
					"fontname": "Arial",
					"fontsize": 9.0,
					"id": "obj-6",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"jit_gl_texture",
						""
					],
					"patching_rect": [
						477.93996339438706,
						541.0,
						125.0,
						19.0
					],
					"text": "jit.gl.slab foo @file td.rota.jxs",
					"textfile": {
						"filename": "td.rota.jxs",
						"flags": 0,
						"embed": 0,
						"autowatch": 1
					}
				}
			},
			{
				"box": {
					"comment": "Texture in",
					"id": "obj-144",
					"index": 1,
					"maxclass": "inlet",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						80.5,
						141.80001831054688,
						50.39996337890625,
						50.39996337890625
					]
				}
			},
			{
				"box": {
					"comment": "",
					"id": "obj-147",
					"index": 1,
					"maxclass": "outlet",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						389.72993056632106,
						870.0,
						25.0,
						25.0
					]
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"destination": [
						"obj-51",
						5
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
						"obj-6",
						0
					],
					"source": [
						"obj-10",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-164",
						0
					],
					"source": [
						"obj-11",
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
						"obj-32",
						0
					],
					"source": [
						"obj-11",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-33",
						0
					],
					"source": [
						"obj-11",
						4
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
						"obj-11",
						1
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
						"obj-11",
						8
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
						"obj-11",
						6
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-14",
						0
					],
					"source": [
						"obj-12",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-48",
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
						"obj-130",
						0
					],
					"source": [
						"obj-129",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-10",
						2
					],
					"source": [
						"obj-13",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-47",
						0
					],
					"source": [
						"obj-130",
						0
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
						"obj-14",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-3",
						0
					],
					"order": 1,
					"source": [
						"obj-14",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-143",
						0
					],
					"source": [
						"obj-142",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-47",
						0
					],
					"source": [
						"obj-143",
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
						"obj-144",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-30",
						1
					],
					"source": [
						"obj-15",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-30",
						2
					],
					"order": 1,
					"source": [
						"obj-16",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-46",
						1
					],
					"order": 0,
					"source": [
						"obj-16",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-21",
						0
					],
					"source": [
						"obj-164",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-10",
						3
					],
					"source": [
						"obj-17",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-88",
						2
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
						"obj-88",
						3
					],
					"source": [
						"obj-20",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-28",
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
						"obj-92",
						2
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
						"obj-147",
						0
					],
					"source": [
						"obj-25",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-29",
						0
					],
					"source": [
						"obj-26",
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
						"obj-27",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-91",
						2
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
						"obj-25",
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
						"obj-130",
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
						"obj-11",
						0
					],
					"source": [
						"obj-30",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						0
					],
					"source": [
						"obj-31",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-69",
						0
					],
					"source": [
						"obj-32",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-72",
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
						"obj-28",
						1
					],
					"source": [
						"obj-35",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-27",
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
						"obj-34",
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
						"obj-25",
						0
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
						"obj-34",
						0
					],
					"order": 1,
					"source": [
						"obj-40",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-39",
						0
					],
					"order": 0,
					"source": [
						"obj-40",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-34",
						0
					],
					"order": 1,
					"source": [
						"obj-41",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-39",
						0
					],
					"order": 0,
					"source": [
						"obj-41",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-40",
						0
					],
					"source": [
						"obj-42",
						1
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
						"obj-42",
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
						"obj-43",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-32",
						1
					],
					"order": 2,
					"source": [
						"obj-44",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-33",
						1
					],
					"order": 0,
					"source": [
						"obj-44",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-55",
						0
					],
					"order": 1,
					"source": [
						"obj-44",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-12",
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
						"obj-47",
						0
					],
					"source": [
						"obj-48",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-3",
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
						"obj-3",
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
						"obj-4",
						0
					],
					"source": [
						"obj-50",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-50",
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
						"obj-31",
						3
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
						"obj-31",
						4
					],
					"order": 0,
					"source": [
						"obj-54",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-52",
						0
					],
					"order": 1,
					"source": [
						"obj-54",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-32",
						0
					],
					"order": 1,
					"source": [
						"obj-55",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-33",
						0
					],
					"order": 0,
					"source": [
						"obj-55",
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
						"obj-56",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-68",
						0
					],
					"source": [
						"obj-57",
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
						"obj-58",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-78",
						0
					],
					"source": [
						"obj-59",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-25",
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
						"obj-51",
						4
					],
					"order": 0,
					"source": [
						"obj-61",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-62",
						0
					],
					"order": 1,
					"source": [
						"obj-61",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-51",
						3
					],
					"source": [
						"obj-62",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-36",
						4
					],
					"order": 0,
					"source": [
						"obj-64",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-65",
						0
					],
					"order": 1,
					"source": [
						"obj-64",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-36",
						3
					],
					"source": [
						"obj-65",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-59",
						0
					],
					"source": [
						"obj-68",
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
						"obj-69",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-70",
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
						"obj-56",
						0
					],
					"source": [
						"obj-70",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-20",
						0
					],
					"source": [
						"obj-72",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-31",
						5
					],
					"source": [
						"obj-73",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-36",
						5
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
						"obj-59",
						1
					],
					"source": [
						"obj-77",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-80",
						0
					],
					"source": [
						"obj-78",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-25",
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
						"obj-82",
						0
					],
					"source": [
						"obj-80",
						0
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
						"obj-82",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-143",
						0
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
						"obj-6",
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
						"obj-89",
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
						"obj-91",
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
						"obj-92",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-22",
						0
					],
					"source": [
						"obj-93",
						0
					]
				}
			}
		],
		"boxgroups": [
			{
				"boxes": [
					"obj-207",
					"obj-206",
					"obj-199",
					"obj-200",
					"obj-201",
					"obj-202",
					"obj-203",
					"obj-204",
					"obj-205"
				]
			}
		]
	}
}
