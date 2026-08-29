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
			273.0,
			453.0,
			799.0,
			797.0
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"fontface": 0,
					"fontname": "Menlo Bold",
					"fontsize": 10.0,
					"id": "obj-139",
					"linecount": 8,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1326.0,
						473.0,
						17.0625,
						100.0
					],
					"presentation": 1,
					"presentation_linecount": 2,
					"presentation_rect": [
						940.75,
						421.0,
						33.0,
						30.0
					],
					"text": "CONTRAST",
					"textjustification": 1
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-140",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1321.0,
						446.0,
						25.875,
						151.876089528203
					],
					"presentation": 1,
					"presentation_rect": [
						933.75,
						407.0,
						21.0,
						102.16666576266289
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "slider[26]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 3
						}
					},
					"size": 2.0,
					"varname": "slider[3]"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-138",
					"linecount": 2,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						573.75,
						420.0,
						36.0,
						27.0
					],
					"presentation": 1,
					"presentation_rect": [
						568.25,
						427.5,
						94.0,
						17.0
					],
					"text": "pic  -size",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-132",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						592.6666843295097,
						396.66667848825455,
						66.0,
						17.0
					],
					"presentation": 1,
					"presentation_rect": [
						578.0000172257423,
						392.66667836904526,
						94.0,
						17.0
					],
					"text": "pic rotate",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 6.0,
					"id": "obj-136",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						718.6666880846024,
						460.6666803956032,
						34.125000953674316,
						13.0
					],
					"text": "Circle",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 6.0,
					"id": "obj-134",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						692.0000206232071,
						460.6666803956032,
						36.0,
						20.0
					],
					"text": "Bass\n",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-131",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						480.00001430511475,
						63.0,
						46.999985694885254,
						20.0
					],
					"text": "1"
				}
			},
			{
				"box": {
					"id": "obj-119",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060.0,
						596.0,
						29.5,
						22.0
					],
					"text": "1."
				}
			},
			{
				"box": {
					"id": "obj-117",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1060.0,
						562.0,
						12.291664689779282,
						12.291664689779282
					],
					"presentation": 1,
					"presentation_rect": [
						1051.25,
						782.75,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[18]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[2]",
							"parameter_type": 2
						}
					},
					"varname": "button[8]"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-116",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						888.0,
						561.0,
						61.0,
						17.0
					],
					"text": "Reset ->"
				}
			},
			{
				"box": {
					"id": "obj-63",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1031.0,
						563.0,
						12.291664689779282,
						12.291664689779282
					],
					"presentation": 1,
					"presentation_rect": [
						1036.25,
						767.75,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[17]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[2]",
							"parameter_type": 2
						}
					},
					"varname": "button[6]"
				}
			},
			{
				"box": {
					"id": "obj-36",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1032.0,
						596.0,
						29.5,
						22.0
					],
					"text": "1."
				}
			},
			{
				"box": {
					"id": "obj-43",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						474.0,
						304.0,
						87.0,
						22.0
					],
					"text": "loadmess 1.25"
				}
			},
			{
				"box": {
					"id": "obj-42",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						447.0,
						269.33334136009216,
						73.0,
						22.0
					],
					"text": "loadmess 1."
				}
			},
			{
				"box": {
					"id": "obj-15",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						748.0,
						990.0,
						60.0,
						22.0
					],
					"text": "zl.change"
				}
			},
			{
				"box": {
					"id": "obj-13",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						762.0,
						900.0,
						31.0,
						22.0
					],
					"text": "float"
				}
			},
			{
				"box": {
					"id": "obj-133",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						724.0000215768814,
						468.0000139474869,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[54]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[54]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[13]"
				}
			},
			{
				"box": {
					"id": "obj-71",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						566.0,
						685.0,
						128.0,
						22.0
					],
					"text": "s soundwave_enable1"
				}
			},
			{
				"box": {
					"blinkcolor": [
						0.909803921568627,
						0.909803921568627,
						0.807843137254902,
						1.0
					],
					"id": "obj-163",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"outlinecolor": [
						0.925490196078431,
						0.125490196078431,
						0.529411764705882,
						1.0
					],
					"parameter_enable": 1,
					"patching_rect": [
						825.0,
						531.75,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[11]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[9]",
							"parameter_type": 2
						}
					},
					"varname": "button[7]"
				}
			},
			{
				"box": {
					"id": "obj-235",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						665.0,
						598.0,
						60.0,
						22.0
					],
					"text": "s savePic"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-222",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						848.0,
						536.25,
						51.25,
						17.0
					],
					"text": "capture"
				}
			},
			{
				"box": {
					"id": "obj-129",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						513.0,
						592.0,
						51.0,
						22.0
					],
					"text": "s livevid"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-127",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						581.25,
						533.25,
						45.0,
						17.0
					],
					"text": "Video?"
				}
			},
			{
				"box": {
					"id": "obj-107",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						562.5,
						532.25,
						18.0,
						18.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[45]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[45]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[12]"
				}
			},
			{
				"box": {
					"id": "obj-123",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						795.0,
						627.0,
						61.0,
						22.0
					],
					"text": "pipe 1500"
				}
			},
			{
				"box": {
					"id": "obj-112",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						795.0,
						592.0,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-108",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						863.0,
						811.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[120]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[5]",
							"parameter_type": 3
						}
					},
					"varname": "number[8]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-105",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						915.0,
						811.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[119]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[5]",
							"parameter_type": 3
						}
					},
					"varname": "number[5]"
				}
			},
			{
				"box": {
					"id": "obj-174",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
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
							59.0,
							106.0,
							640.0,
							659.0
						],
						"gridsize": [
							15.0,
							15.0
						],
						"boxes": [
							{
								"box": {
									"id": "obj-232",
									"maxclass": "newobj",
									"numinlets": 6,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										461.7166722416878,
										432.615024,
										151.0,
										22.0
									],
									"text": "scale -360. 360. 360. -360."
								}
							},
							{
								"box": {
									"id": "obj-231",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										377.25,
										340.4984563589096,
										29.5,
										22.0
									],
									"text": "0"
								}
							},
							{
								"box": {
									"id": "obj-229",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"bang",
										"float"
									],
									"patching_rect": [
										396.25,
										384.0,
										29.5,
										22.0
									],
									"text": "t b f"
								}
							},
							{
								"box": {
									"id": "obj-227",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										"float"
									],
									"patching_rect": [
										358.70353920509194,
										423.0,
										57.0,
										22.0
									],
									"text": "accum 0."
								}
							},
							{
								"box": {
									"id": "obj-224",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										56.25,
										241.0,
										29.5,
										22.0
									],
									"text": "&&"
								}
							},
							{
								"box": {
									"id": "obj-221",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										50.0,
										423.0,
										42.0,
										22.0
									],
									"text": "< 1.01"
								}
							},
							{
								"box": {
									"id": "obj-219",
									"maxclass": "newobj",
									"numinlets": 6,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										78.85867158571875,
										391.615024,
										130.0,
										22.0
									],
									"text": "scale 0. 100. 0. 1. 1.02"
								}
							},
							{
								"box": {
									"id": "obj-194",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"bang",
										"float"
									],
									"patching_rect": [
										108.41666666666652,
										216.0,
										29.5,
										22.0
									],
									"text": "t b f"
								}
							},
							{
								"box": {
									"id": "obj-193",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"float"
									],
									"patching_rect": [
										162.24997663497925,
										238.0,
										33.0,
										22.0
									],
									"text": "* 0.1"
								}
							},
							{
								"box": {
									"id": "obj-190",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										64.25,
										120.0,
										29.5,
										22.0
									],
									"text": "!= 1"
								}
							},
							{
								"box": {
									"id": "obj-189",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										82.82353920902631,
										189.71666844189167,
										32.0,
										22.0
									],
									"text": "gate"
								}
							},
							{
								"box": {
									"id": "obj-179",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										130.08328660329198,
										126.0,
										29.5,
										22.0
									],
									"text": "< 1."
								}
							},
							{
								"box": {
									"id": "obj-174",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										134.8235392090263,
										176.0,
										32.0,
										22.0
									],
									"text": "gate"
								}
							},
							{
								"box": {
									"id": "obj-159",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"bang",
										"float"
									],
									"patching_rect": [
										89.85867158571875,
										254.0,
										29.5,
										22.0
									],
									"text": "t b f"
								}
							},
							{
								"box": {
									"id": "obj-161",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										"float"
									],
									"patching_rect": [
										82.82353920902631,
										292.0,
										71.0,
										22.0
									],
									"text": "accum 0.33"
								}
							},
							{
								"box": {
									"id": "obj-149",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										454.7166722416878,
										306.33331859111786,
										32.0,
										22.0
									],
									"text": "gate"
								}
							},
							{
								"box": {
									"id": "obj-143",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										"bang"
									],
									"patching_rect": [
										426.7166722416878,
										230.33331859111786,
										22.0,
										22.0
									],
									"text": "t b"
								}
							},
							{
								"box": {
									"id": "obj-140",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										426.7166722416878,
										263.33331859111786,
										29.5,
										22.0
									],
									"text": "&&"
								}
							},
							{
								"box": {
									"id": "obj-139",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										465.7166722416878,
										216.0,
										33.0,
										22.0
									],
									"text": "== 1"
								}
							},
							{
								"box": {
									"id": "obj-138",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										383.7166722416878,
										216.0,
										33.0,
										22.0
									],
									"text": "== 1"
								}
							},
							{
								"box": {
									"id": "obj-136",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										191.0833097100258,
										250.0,
										36.0,
										22.0
									],
									"text": "<= 1."
								}
							},
							{
								"box": {
									"id": "obj-134",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										239.26489300000003,
										286.0,
										32.0,
										22.0
									],
									"text": "gate"
								}
							},
							{
								"box": {
									"id": "obj-133",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										285.76489300000003,
										286.0,
										32.0,
										22.0
									],
									"text": "gate"
								}
							},
							{
								"box": {
									"id": "obj-132",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										"bang"
									],
									"patching_rect": [
										201.5833097100258,
										326.33331859111786,
										58.0,
										22.0
									],
									"text": "loadbang"
								}
							},
							{
								"box": {
									"id": "obj-131",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										209.25,
										406.0,
										57.0,
										22.0
									],
									"text": "clip -1. 1."
								}
							},
							{
								"box": {
									"id": "obj-129",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										252.24997637669242,
										136.9000249999999,
										57.0,
										22.0
									],
									"text": "clip -3. 3."
								}
							},
							{
								"box": {
									"id": "obj-127",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										195.0833097100258,
										357.0,
										32.0,
										22.0
									],
									"text": "0.33"
								}
							},
							{
								"box": {
									"id": "obj-125",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"bang",
										"float"
									],
									"patching_rect": [
										279.7499763766924,
										326.33331859111786,
										29.5,
										22.0
									],
									"text": "t b f"
								}
							},
							{
								"box": {
									"id": "obj-123",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										"float"
									],
									"patching_rect": [
										272.71484399999997,
										364.33331859111786,
										71.0,
										22.0
									],
									"text": "accum 0.33"
								}
							},
							{
								"box": {
									"id": "obj-119",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										292.21484399999997,
										250.0,
										32.0,
										22.0
									],
									"text": "gate"
								}
							},
							{
								"box": {
									"id": "obj-117",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										241.41663942734397,
										246.0,
										32.0,
										22.0
									],
									"text": "gate"
								}
							},
							{
								"box": {
									"id": "obj-113",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										201.5833097100258,
										209.0,
										29.5,
										22.0
									],
									"text": "> 0."
								}
							},
							{
								"box": {
									"id": "obj-112",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										312.71484399999997,
										209.0,
										29.5,
										22.0
									],
									"text": "< 0."
								}
							},
							{
								"box": {
									"id": "obj-108",
									"maxclass": "newobj",
									"numinlets": 6,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										239.26489300000003,
										176.0,
										125.0,
										22.0
									],
									"text": "scale -10. 10. -0.2 0.2"
								}
							},
							{
								"box": {
									"id": "obj-107",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										426.4666722416878,
										161.0,
										29.5,
										22.0
									],
									"text": "0"
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
										394.25,
										161.0,
										29.5,
										22.0
									],
									"text": "1"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-91",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 3,
									"outlettype": [
										"bang",
										"bang",
										""
									],
									"patching_rect": [
										504.7166722416878,
										401.2333435911179,
										46.0,
										22.0
									],
									"text": "sel 0 1"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-95",
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
										465.7166722416878,
										364.33331859111786,
										85.0,
										22.0
									],
									"text": "mira.mt.rotate"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-63",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 3,
									"outlettype": [
										"bang",
										"bang",
										""
									],
									"patching_rect": [
										330.9999763766924,
										132.0,
										46.0,
										22.0
									],
									"text": "sel 0 1"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 12.0,
									"id": "obj-71",
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
										223.26489300000003,
										100.0,
										83.0,
										22.0
									],
									"text": "mira.mt.pinch"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-150",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										338.490784,
										40.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"comment": "X axis",
									"id": "obj-163",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										78.85867300000001,
										514.6150210000001,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"comment": "Y axis",
									"id": "obj-167",
									"index": 2,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										461.716675,
										514.6150210000001,
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
										"obj-138",
										0
									],
									"order": 1,
									"source": [
										"obj-105",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-139",
										0
									],
									"order": 0,
									"source": [
										"obj-105",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-138",
										0
									],
									"order": 1,
									"source": [
										"obj-107",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-139",
										0
									],
									"order": 0,
									"source": [
										"obj-107",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-112",
										0
									],
									"order": 0,
									"source": [
										"obj-108",
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
									"order": 3,
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-117",
										1
									],
									"order": 2,
									"source": [
										"obj-108",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-119",
										1
									],
									"order": 1,
									"source": [
										"obj-108",
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
										"obj-112",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-117",
										0
									],
									"source": [
										"obj-113",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-134",
										1
									],
									"source": [
										"obj-117",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-133",
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
										"obj-131",
										0
									],
									"order": 0,
									"source": [
										"obj-123",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-136",
										0
									],
									"order": 1,
									"source": [
										"obj-123",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-123",
										1
									],
									"source": [
										"obj-125",
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
										"obj-127",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-108",
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
										"obj-127",
										0
									],
									"source": [
										"obj-132",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-125",
										0
									],
									"source": [
										"obj-133",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-125",
										0
									],
									"source": [
										"obj-134",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-134",
										0
									],
									"source": [
										"obj-136",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-140",
										0
									],
									"source": [
										"obj-138",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-140",
										1
									],
									"order": 0,
									"source": [
										"obj-139",
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
									"order": 1,
									"source": [
										"obj-139",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-149",
										0
									],
									"source": [
										"obj-140",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-140",
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
										"obj-71",
										0
									],
									"order": 1,
									"source": [
										"obj-150",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-95",
										0
									],
									"order": 0,
									"source": [
										"obj-150",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-161",
										1
									],
									"source": [
										"obj-159",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-161",
										0
									],
									"source": [
										"obj-159",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-219",
										0
									],
									"source": [
										"obj-161",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-194",
										0
									],
									"source": [
										"obj-174",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-174",
										0
									],
									"order": 0,
									"source": [
										"obj-179",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-190",
										0
									],
									"order": 1,
									"source": [
										"obj-179",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-159",
										0
									],
									"source": [
										"obj-189",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-224",
										0
									],
									"source": [
										"obj-190",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-161",
										2
									],
									"source": [
										"obj-194",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-161",
										0
									],
									"source": [
										"obj-194",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-163",
										0
									],
									"order": 0,
									"source": [
										"obj-219",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-221",
										0
									],
									"order": 1,
									"source": [
										"obj-219",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-224",
										1
									],
									"source": [
										"obj-221",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-189",
										0
									],
									"source": [
										"obj-224",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-232",
										0
									],
									"source": [
										"obj-227",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-227",
										1
									],
									"source": [
										"obj-229",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-227",
										0
									],
									"source": [
										"obj-229",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-227",
										0
									],
									"source": [
										"obj-231",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-167",
										0
									],
									"source": [
										"obj-232",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-105",
										0
									],
									"order": 0,
									"source": [
										"obj-63",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-107",
										0
									],
									"source": [
										"obj-63",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-123",
										0
									],
									"order": 1,
									"source": [
										"obj-63",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-129",
										0
									],
									"source": [
										"obj-71",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-174",
										1
									],
									"order": 0,
									"source": [
										"obj-71",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-179",
										0
									],
									"order": 1,
									"source": [
										"obj-71",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-189",
										1
									],
									"order": 2,
									"source": [
										"obj-71",
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
										"obj-71",
										2
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-229",
										0
									],
									"source": [
										"obj-95",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-91",
										0
									],
									"source": [
										"obj-95",
										2
									]
								}
							}
						]
					},
					"patching_rect": [
						72.0,
						173.0,
						59.0,
						22.0
					],
					"text": "p xypinch"
				}
			},
			{
				"box": {
					"id": "obj-220",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						302.0,
						374.0,
						41.0,
						22.0
					],
					"text": "abs 0."
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-192",
					"maxclass": "flonum",
					"minimum": 1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						419.0,
						374.0,
						54.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[114]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[114]",
							"parameter_type": 3
						}
					},
					"varname": "number[3]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-195",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						418.0,
						352.0,
						72.0,
						21.0
					],
					"text": "slide down",
					"textcolor": [
						0.501961,
						0.501961,
						0.501961,
						1.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-196",
					"maxclass": "flonum",
					"minimum": 1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						352.0,
						374.0,
						54.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[115]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[115]",
							"parameter_type": 3
						}
					},
					"varname": "number[4]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-197",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						352.0,
						352.0,
						55.0,
						21.0
					],
					"text": "slide up",
					"textcolor": [
						0.501961,
						0.501961,
						0.501961,
						1.0
					]
				}
			},
			{
				"box": {
					"id": "obj-191",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						299.0,
						412.0,
						70.0,
						22.0
					],
					"text": "slide 22. 14"
				}
			},
			{
				"box": {
					"id": "obj-169",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						302.0,
						326.0,
						99.0,
						22.0
					],
					"text": "r kittybumpsignal"
				}
			},
			{
				"box": {
					"id": "obj-171",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						577.0,
						598.0,
						69.0,
						22.0
					],
					"text": "s kittybump"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-164",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						575.0,
						551.25,
						79.0,
						17.0
					],
					"presentation": 1,
					"presentation_rect": [
						569.7509961724281,
						739.0,
						78.0,
						17.0
					],
					"text": " kittieBump™"
				}
			},
			{
				"box": {
					"id": "obj-162",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						562.25,
						550.25,
						18.0,
						18.0
					],
					"presentation": 1,
					"presentation_rect": [
						652.7333354949953,
						737.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[37]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[37]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[5]"
				}
			},
			{
				"box": {
					"id": "obj-147",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						"float"
					],
					"patching_rect": [
						238.0,
						412.0,
						29.5,
						22.0
					],
					"text": "t b f"
				}
			},
			{
				"box": {
					"id": "obj-145",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						208.0,
						451.0,
						29.5,
						22.0
					],
					"text": "+ 0."
				}
			},
			{
				"box": {
					"id": "obj-233",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						299.0,
						459.0,
						118.0,
						22.0
					],
					"text": "scale -1. 1. 210 -210"
				}
			},
			{
				"box": {
					"id": "obj-226",
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
						145.0,
						389.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-225",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						145.0,
						420.0,
						29.5,
						22.0
					],
					"text": "f"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-137",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1512.0,
						846.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number",
							"parameter_modmode": 0,
							"parameter_shortname": "number",
							"parameter_type": 3
						}
					},
					"varname": "number"
				}
			},
			{
				"box": {
					"id": "obj-5",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"float",
						"float"
					],
					"patching_rect": [
						1368.0,
						1028.0,
						74.0,
						22.0
					],
					"text": "unpack 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-96",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1440.0,
						912.0,
						94.0,
						22.0
					],
					"text": "scale 0. 1. 1. -1."
				}
			},
			{
				"box": {
					"id": "obj-99",
					"linecount": 2,
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1363.0,
						912.0,
						71.5,
						35.0
					],
					"text": "scale 0. 1. -1. 1."
				}
			},
			{
				"box": {
					"id": "obj-100",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 5,
					"outlettype": [
						"",
						"",
						"",
						"",
						""
					],
					"patching_rect": [
						1368.0,
						998.0,
						76.0,
						22.0
					],
					"text": "route 1 2 3 4"
				}
			},
			{
				"box": {
					"id": "obj-101",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1368.0,
						965.0,
						71.0,
						22.0
					],
					"text": "pack 1 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-102",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 6,
					"outlettype": [
						"float",
						"float",
						"int",
						"int",
						"int",
						""
					],
					"patching_rect": [
						1374.0,
						880.0,
						212.0,
						22.0
					],
					"text": "unpack 0. 0. 0 0 0 stuff"
				}
			},
			{
				"box": {
					"id": "obj-124",
					"linecount": 2,
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1378.0,
						827.0,
						68.0,
						35.0
					],
					"text": "route touch"
				}
			},
			{
				"box": {
					"id": "obj-98",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1031.0,
						639.0,
						31.0,
						22.0
					],
					"text": "* -1."
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-97",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						724.712409004569,
						529.5,
						57.0,
						17.0
					],
					"presentation": 1,
					"presentation_rect": [
						730.8140693902969,
						731.4594224095345,
						57.0,
						17.0
					],
					"text": "Fill/Line"
				}
			},
			{
				"box": {
					"id": "obj-93",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						698.0,
						526.0,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						704.8140693902969,
						731.4594224095345,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[28]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[28]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[4]"
				}
			},
			{
				"box": {
					"id": "obj-4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						766.0,
						672.0,
						87.0,
						22.0
					],
					"text": "s waveLineFilll"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-218",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						514.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[68]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[6]",
							"parameter_type": 0
						}
					},
					"varname": "number[2]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-217",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						451.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[113]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[6]",
							"parameter_type": 0
						}
					},
					"varname": "number[1]"
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
						411.0,
						680.0,
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
						348.0,
						680.0,
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
						282.0,
						680.0,
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
						221.0,
						680.0,
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
						111.0,
						680.0,
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
						53.0,
						680.0,
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
						-2.0,
						680.0,
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
						475.0,
						680.0,
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
						528.0,
						680.0,
						36.0,
						20.0
					],
					"text": "sat",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-208",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						13.0,
						775.0,
						65.0,
						22.0
					],
					"text": "s shadeCtl"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-209",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						388.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[93]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[6]",
							"parameter_type": 0
						}
					},
					"varname": "number[10]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-210",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						325.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[98]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[5]",
							"parameter_type": 0
						}
					},
					"varname": "number[11]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-211",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						261.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[110]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[4]",
							"parameter_type": 0
						}
					},
					"varname": "number[12]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-212",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						198.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[66]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[3]",
							"parameter_type": 0
						}
					},
					"varname": "number[13]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-213",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						135.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[94]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[2]",
							"parameter_type": 0
						}
					},
					"varname": "number[14]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-214",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						72.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[67]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[1]",
							"parameter_type": 0
						}
					},
					"varname": "number[15]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-215",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": -1.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						9.0,
						709.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[84]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number",
							"parameter_type": 0
						}
					},
					"varname": "number[16]"
				}
			},
			{
				"box": {
					"id": "obj-216",
					"maxclass": "newobj",
					"numinlets": 9,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						13.0,
						744.0,
						512.0,
						22.0
					],
					"text": "pack 0. 0. 0. 0. 0. 0. 0. 0. 0."
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"id": "obj-180",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1131.0,
						963.0,
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
					"id": "obj-181",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1072.0,
						963.0,
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
					"id": "obj-182",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1011.0,
						963.0,
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
					"id": "obj-183",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						954.0,
						963.0,
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
					"id": "obj-184",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						851.0,
						963.0,
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
					"id": "obj-185",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						797.0,
						963.0,
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
					"id": "obj-186",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						746.0,
						963.0,
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
					"id": "obj-187",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1192.0,
						963.0,
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
					"id": "obj-188",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1240.0,
						963.0,
						36.0,
						20.0
					],
					"text": "sat",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-160",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						773.0,
						13.0,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "obj-158",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						773.0,
						47.0,
						159.0,
						22.0
					],
					"text": "0.910104 0.85734 0. 1."
				}
			},
			{
				"box": {
					"id": "obj-144",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						457.0,
						474.0,
						70.0,
						22.0
					],
					"text": "loadmess 0"
				}
			},
			{
				"box": {
					"id": "obj-92",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						461.0,
						435.0,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-122",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						712.0,
						861.0,
						59.0,
						22.0
					],
					"text": "r ctrlbang"
				}
			},
			{
				"box": {
					"id": "obj-121",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						204.0,
						542.0,
						63.0,
						22.0
					],
					"text": "r shadeCtl"
				}
			},
			{
				"box": {
					"id": "obj-114",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						23.0,
						966.0,
						65.0,
						22.0
					],
					"text": "s shadeCtl"
				}
			},
			{
				"box": {
					"attr": "tap_enabled",
					"id": "obj-109",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						592.0,
						99.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "pinch_enabled",
					"id": "obj-58",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						833.0,
						124.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "rotate_enabled",
					"id": "obj-73",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						833.0,
						148.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-178",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1000.0,
						563.0,
						12.291664689779282,
						12.291664689779282
					],
					"presentation": 1,
					"presentation_rect": [
						928.24085521698,
						742.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[5]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[2]",
							"parameter_type": 2
						}
					},
					"varname": "button[5]"
				}
			},
			{
				"box": {
					"id": "obj-177",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						971.0,
						562.0,
						12.583329021930695,
						12.583329021930695
					],
					"presentation": 1,
					"presentation_rect": [
						899.24085521698,
						742.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[4]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[2]",
							"parameter_type": 2
						}
					},
					"varname": "button[4]"
				}
			},
			{
				"box": {
					"id": "obj-176",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1522.0,
						557.0,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						870.24085521698,
						742.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[3]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[2]",
							"parameter_type": 2
						}
					},
					"varname": "button[3]"
				}
			},
			{
				"box": {
					"id": "obj-175",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						944.0,
						562.0,
						12.583329021930695,
						12.583329021930695
					],
					"presentation": 1,
					"presentation_rect": [
						838.5843371748924,
						742.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[2]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[2]",
							"parameter_type": 2
						}
					},
					"varname": "button[2]"
				}
			},
			{
				"box": {
					"id": "obj-173",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						968.0,
						596.0,
						29.5,
						22.0
					],
					"text": "1.1"
				}
			},
			{
				"box": {
					"id": "obj-172",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1457.0,
						490.0,
						29.5,
						22.0
					],
					"text": "1."
				}
			},
			{
				"box": {
					"id": "obj-170",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						935.0,
						596.0,
						29.5,
						22.0
					],
					"text": "1."
				}
			},
			{
				"box": {
					"id": "obj-168",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1000.0,
						596.0,
						29.5,
						22.0
					],
					"text": "0.5"
				}
			},
			{
				"box": {
					"id": "obj-166",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						912.0,
						708.0,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						990.8916737437248,
						741.8000099658966,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[26]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[14]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[9]"
				}
			},
			{
				"box": {
					"id": "obj-165",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						915.0,
						744.0,
						95.0,
						22.0
					],
					"text": "s scaleInvtoggle"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-157",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						720.0000214576721,
						553.3333498239517,
						102.0,
						17.0
					],
					"presentation": 1,
					"presentation_linecount": 2,
					"presentation_rect": [
						1020.2250064015388,
						695.4166669100523,
						57.0,
						27.0
					],
					"text": " Motion control"
				}
			},
			{
				"box": {
					"id": "obj-148",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1099.0,
						387.0,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-146",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						700.6666875481606,
						552.6666831374168,
						20.233330935239792,
						20.233330935239792
					],
					"presentation": 1,
					"presentation_rect": [
						1024.9170283675194,
						657.4666675329208,
						33.80797904729843,
						33.80797904729843
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[25]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[25]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[8]"
				}
			},
			{
				"box": {
					"id": "obj-141",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1176.0,
						650.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 12.0,
					"id": "obj-135",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						661.5,
						480.39583829045296,
						37.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						659.5636110305788,
						684.9594224095345,
						37.0,
						20.0
					],
					"text": "of",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 18.0,
					"id": "obj-130",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						612.520828038454,
						477.0,
						28.999999582767487,
						27.0
					],
					"presentation": 1,
					"presentation_rect": [
						630.5,
						696.4587197303772,
						33.0,
						27.0
					],
					"text": "-",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 18.0,
					"id": "obj-126",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						613.770828038454,
						425.0,
						27.000019073486328,
						27.0
					],
					"presentation": 1,
					"presentation_rect": [
						628.5,
						660.9594224095345,
						33.0,
						27.0
					],
					"text": "+",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-111",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						610.020828038454,
						474.5,
						31.791676580905914,
						31.791676580905914
					],
					"presentation": 1,
					"presentation_rect": [
						619.4999995827675,
						694.6181422472,
						32.00000041723251,
						32.00000041723251
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[1]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button",
							"parameter_type": 2
						}
					},
					"varname": "button[1]"
				}
			},
			{
				"box": {
					"id": "obj-110",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						610.520828038454,
						421.75,
						31.33333432674408,
						31.33333432674408
					],
					"presentation": 1,
					"presentation_rect": [
						618.7333350777628,
						656.4594222009182,
						32.00000041723251,
						32.00000041723251
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button",
							"parameter_type": 2
						}
					},
					"varname": "button"
				}
			},
			{
				"box": {
					"id": "obj-106",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						444.0,
						557.0,
						29.5,
						22.0
					],
					"text": "dec"
				}
			},
			{
				"box": {
					"id": "obj-103",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						444.0,
						530.0,
						29.5,
						22.0
					],
					"text": "inc"
				}
			},
			{
				"box": {
					"id": "obj-70",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						363.0,
						512.0,
						79.0,
						22.0
					],
					"text": "r movsFound"
				}
			},
			{
				"box": {
					"id": "obj-69",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						363.0,
						538.0,
						58.0,
						22.0
					],
					"text": "s movSel"
				}
			},
			{
				"box": {
					"id": "obj-12",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						358.0,
						570.0,
						79.0,
						22.0
					],
					"text": "prepend max"
				}
			},
			{
				"box": {
					"id": "obj-22",
					"maxclass": "incdec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"parameter_enable": 0,
					"patching_rect": [
						474.0,
						526.0,
						55.0,
						53.0
					]
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-25",
					"maxclass": "number",
					"maximum": 53,
					"minimum": 0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						610.270828038454,
						454.25,
						31.583352744579315,
						19.0
					],
					"presentation": 1,
					"presentation_rect": [
						652.7333354949953,
						665.9594224095345,
						41.0,
						19.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[65]",
							"parameter_mmax": 53.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[65]",
							"parameter_type": 0
						}
					},
					"varname": "number[7]"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-57",
					"maxclass": "number",
					"minimum": 0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						651.0,
						500.0,
						38.0,
						19.0
					],
					"presentation": 1,
					"presentation_rect": [
						652.7333354949953,
						703.9594224095345,
						42.0,
						19.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[9]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[9]",
							"parameter_type": 3
						}
					},
					"varname": "number[9]"
				}
			},
			{
				"box": {
					"id": "obj-156",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						565.0,
						629.0,
						121.0,
						22.0
					],
					"text": "s soundwave_enable"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"id": "obj-155",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						920.0,
						385.0,
						63.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						904.24085521698,
						600.4666675329208,
						63.0,
						20.0
					],
					"text": "rotate",
					"textcolor": [
						0.517647058823529,
						0.517647058823529,
						0.517647058823529,
						1.0
					],
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 10.0,
					"id": "obj-154",
					"linecount": 4,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1063.0,
						457.0,
						15.0,
						53.0
					],
					"presentation": 1,
					"presentation_rect": [
						990.8916737437248,
						624.8333345353603,
						38.0,
						18.0
					],
					"text": "ZOOM",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-152",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						750.0000223517418,
						471.3333473801613,
						70.0,
						17.0
					],
					"presentation": 1,
					"presentation_rect": [
						730.8140693902969,
						667.9594224095345,
						76.0,
						17.0
					],
					"text": "Wave Enable"
				}
			},
			{
				"box": {
					"id": "obj-153",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						698.000020802021,
						468.0000139474869,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						704.8140693902969,
						665.9594224095345,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[13]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[21]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[6]"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-151",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						577.0,
						517.0,
						67.0,
						17.0
					],
					"presentation": 1,
					"presentation_rect": [
						612.0843288302422,
						632.6516514122486,
						95.0,
						17.0
					],
					"text": "pic enable",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-128",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 7,
					"outlettype": [
						"",
						"",
						"",
						"",
						"",
						"",
						""
					],
					"patching_rect": [
						202.0,
						173.0,
						211.0,
						22.0
					],
					"text": "mira.mt.centroid"
				}
			},
			{
				"box": {
					"id": "obj-89",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						23.0,
						928.0,
						660.0,
						22.0
					],
					"text": "0.011905 0.392857 0.755952 -0.354023 -0.5 -0.634044 0.281234 0. 0.71131"
				}
			},
			{
				"box": {
					"id": "obj-88",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						12.0,
						882.0,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 10.0,
					"id": "obj-19",
					"linecount": 10,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						999.3333631157875,
						422.00001257658005,
						15.0,
						123.0
					],
					"presentation": 1,
					"presentation_linecount": 3,
					"presentation_rect": [
						924.24085521698,
						618.5333420038223,
						33.0,
						41.0
					],
					"text": "SATURATION",
					"textjustification": 1
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-50",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						992.0,
						408.0,
						27.875,
						151.876089528203
					],
					"presentation": 1,
					"presentation_rect": [
						928.24085521698,
						633.0333379805088,
						21.0,
						102.16666576266289
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "fbhue[1]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "fbhue",
							"parameter_type": 3
						}
					},
					"size": 1.0,
					"varname": "slider[9]"
				}
			},
			{
				"box": {
					"id": "obj-47",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						46.0,
						451.0,
						150.0,
						20.0
					],
					"text": "enable x y 0 zx zy 0 0 0 r"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 9.0,
					"id": "obj-65",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						724.0,
						501.0,
						87.0,
						17.0
					],
					"presentation": 1,
					"presentation_rect": [
						730.8140693902969,
						706.3968514204025,
						86.0,
						17.0
					],
					"text": "Wave Lighting"
				}
			},
			{
				"box": {
					"id": "obj-54",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						565.0,
						658.0,
						166.0,
						22.0
					],
					"text": "s soundwave_lighting_enable"
				}
			},
			{
				"box": {
					"id": "obj-55",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						698.0,
						499.0,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						704.8140693902969,
						704.3968514204025,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[22]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[21]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[10]"
				}
			},
			{
				"box": {
					"id": "obj-53",
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
						141.0,
						346.0,
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
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						32.0,
						389.0,
						59.0,
						22.0
					],
					"text": "r ctrlbang"
				}
			},
			{
				"box": {
					"id": "obj-84",
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
						285.0,
						290.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-82",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						461.0,
						234.66667366027832,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-80",
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
						188.0,
						256.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-79",
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
						297.0,
						253.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-76",
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
						282.0,
						486.0,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-75",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						563.0,
						421.75,
						34.25,
						84.54167658090591
					],
					"presentation": 1,
					"presentation_rect": [
						569.7509961724281,
						624.8333345353603,
						40.333332657814026,
						84.99999898672104
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [
								0.746666663244036
							],
							"parameter_initial_enable": 1,
							"parameter_invisible": 1,
							"parameter_longname": "slider[15]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 3
						}
					},
					"size": 2.0,
					"varname": "slider[12]"
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-74",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						562.833332657814,
						391.50000989437103,
						126.16666734218597,
						24.50000250339508
					],
					"presentation": 1,
					"presentation_rect": [
						573.028773691919,
						595.8529032915831,
						108.33333468437195,
						24.333330512046814
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [
								-360
							],
							"parameter_initial_enable": 1,
							"parameter_invisible": 1,
							"parameter_longname": "slider[14]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 3
						}
					},
					"size": 2.0,
					"varname": "slider[11]"
				}
			},
			{
				"box": {
					"id": "obj-64",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						309.0,
						214.0,
						91.0,
						22.0
					],
					"text": "scale 0. 1. 1 -1."
				}
			},
			{
				"box": {
					"id": "obj-67",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						180.0,
						214.0,
						121.0,
						22.0
					],
					"text": "scale 0.1 0.9 -1.7 1.7"
				}
			},
			{
				"box": {
					"color": [
						0.75,
						0.75,
						0.75,
						0.2
					],
					"id": "obj-62",
					"maxclass": "mira.multitouch",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						563.0,
						203.0,
						252.0,
						176.5
					],
					"pinch_enabled": 0,
					"presentation": 1,
					"presentation_rect": [
						577.7509961724281,
						420.7633735537529,
						231.34066772460938,
						168.03662449121475
					],
					"rotate_enabled": 0,
					"swipe_enabled": 0,
					"swipe_touch_count": 0,
					"tap_enabled": 0,
					"tap_tap_count": 0,
					"tap_touch_count": 0
				}
			},
			{
				"box": {
					"id": "obj-1",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						562.5,
						514.75,
						18.0,
						18.0
					],
					"presentation": 1,
					"presentation_rect": [
						675.084328830242,
						632.6516514122486,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[20]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[20]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[2]"
				}
			},
			{
				"box": {
					"id": "obj-8",
					"maxclass": "newobj",
					"numinlets": 10,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						46.0,
						486.0,
						167.0,
						22.0
					],
					"text": "pack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-44",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						46.0,
						521.0,
						80.0,
						22.0
					],
					"text": "s imageMove"
				}
			},
			{
				"box": {
					"id": "obj-59",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						141.0,
						313.0,
						111.0,
						22.0
					],
					"text": "scale 0. 1024 -1. 1."
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-27",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1054.0,
						408.0,
						30.375,
						152.376089528203
					],
					"presentation": 1,
					"presentation_rect": [
						995.5836957097054,
						642.6999984681606,
						27.333332657814026,
						89.74058082699776
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [
								0.75
							],
							"parameter_initial_enable": 1,
							"parameter_invisible": 1,
							"parameter_longname": "slider[11]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 3
						}
					},
					"size": 2.0,
					"varname": "slider[8]"
				}
			},
			{
				"box": {
					"id": "obj-23",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						171.0,
						542.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[19]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[19]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[1]"
				}
			},
			{
				"box": {
					"id": "obj-7",
					"maxclass": "gswitch2",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						184.0,
						586.0,
						39.0,
						32.0
					]
				}
			},
			{
				"box": {
					"id": "obj-6",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						-2.0,
						639.0,
						543.8329677728366,
						22.0
					],
					"text": "-0.489224 0.483331 0.393104 -0.249777 -0.865481 0.047872 0.510855 0. 0.67"
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-56",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						818.0,
						383.0,
						266.4978713095188,
						22.5
					],
					"presentation": 1,
					"presentation_rect": [
						950.3916727304459,
						600.4666675329208,
						108.33333468437195,
						24.333330512046814
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [
								0.739079350328317
							],
							"parameter_initial_enable": 1,
							"parameter_invisible": 1,
							"parameter_longname": "slider[10]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 3
						}
					},
					"size": 2.0,
					"varname": "slider[7]"
				}
			},
			{
				"box": {
					"id": "obj-52",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1127.0,
						840.0,
						98.0,
						22.0
					],
					"text": "scale -1. 1. 1. -1."
				}
			},
			{
				"box": {
					"id": "obj-49",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 5,
					"outlettype": [
						"float",
						"float",
						"float",
						"float",
						""
					],
					"patching_rect": [
						1189.0,
						783.0,
						126.0,
						22.0
					],
					"text": "unpack 0. 0. 0. 0. stuff"
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 10.0,
					"id": "obj-41",
					"linecount": 12,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1031.0,
						411.0,
						15.0,
						146.0
					],
					"presentation": 1,
					"presentation_linecount": 3,
					"presentation_rect": [
						956.8408552408218,
						615.7333419322968,
						33.0,
						41.0
					],
					"text": "TRANSPARANCY",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-120",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						912.0,
						663.0,
						117.0,
						22.0
					],
					"text": "s erasetransparency"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-83",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1023.0,
						409.0,
						28.875,
						151.376089528203
					],
					"presentation": 1,
					"presentation_rect": [
						963.24085521698,
						633.0333379805088,
						24.200000047683716,
						102.16666576266289
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [
								1.0
							],
							"parameter_initial_enable": 1,
							"parameter_longname": "slider",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 0
						}
					},
					"size": 1.0,
					"varname": "slider"
				}
			},
			{
				"box": {
					"id": "obj-118",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						716.0,
						629.0,
						45.0,
						22.0
					],
					"text": "s hue1"
				}
			},
			{
				"box": {
					"id": "obj-198",
					"maxclass": "swatch",
					"numinlets": 3,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						691.0,
						383.0,
						124.42481800913811,
						78.60362235456705
					],
					"presentation": 1,
					"presentation_rect": [
						702.1333429217339,
						596.4666675329208,
						120.16666972637177,
						63.36995458602905
					],
					"saturation": 1.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "swatch[3]",
							"parameter_modmode": 0,
							"parameter_shortname": "swatch",
							"parameter_type": 3
						}
					},
					"varname": "swatch"
				}
			},
			{
				"box": {
					"id": "obj-40",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1514.0,
						434.0,
						37.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						862.24085521698,
						618.5333420038223,
						37.0,
						20.0
					],
					"text": "cont"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Menlo Bold",
					"fontsize": 10.0,
					"id": "obj-39",
					"linecount": 10,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						941.3333613872528,
						421.33334589004517,
						15.0,
						123.0
					],
					"presentation": 1,
					"presentation_linecount": 3,
					"presentation_rect": [
						840.0843371748924,
						618.5333420038223,
						33.0,
						41.0
					],
					"text": "BRIGNTNESS",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontname": "Menlo Bold",
					"fontsize": 10.0,
					"id": "obj-38",
					"linecount": 2,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						970.1875,
						421.33334589004517,
						75.0,
						30.0
					],
					"presentation": 1,
					"presentation_linecount": 2,
					"presentation_rect": [
						895.24085521698,
						618.5333420038223,
						87.0,
						30.0
					],
					"text": "HUE          -S H I FT",
					"textjustification": 1
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-18",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1522.0,
						448.0,
						21.0,
						102.16666576266289
					],
					"presentation": 1,
					"presentation_rect": [
						870.24085521698,
						633.0333379805088,
						21.0,
						102.16666576266289
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "slider[7]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 3
						}
					},
					"size": 2.0,
					"varname": "slider[1]"
				}
			},
			{
				"box": {
					"id": "obj-16",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						848.0,
						857.0,
						91.0,
						22.0
					],
					"text": "scale 0 -2. -1. 0"
				}
			},
			{
				"box": {
					"id": "obj-35",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 5,
					"outlettype": [
						"float",
						"float",
						"float",
						"float",
						""
					],
					"patching_rect": [
						982.0,
						790.0,
						126.0,
						22.0
					],
					"text": "unpack 0. 0. 0. 0. stuff"
				}
			},
			{
				"box": {
					"id": "obj-34",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"float",
						"float"
					],
					"patching_rect": [
						1093.0,
						640.0,
						74.0,
						22.0
					],
					"text": "unpack 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-14",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						742.0,
						1028.0,
						65.0,
						22.0
					],
					"text": "s shadeCtl"
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
						757.0,
						936.0,
						512.0,
						22.0
					],
					"text": "pack 0. 0. 0. 0. 0. 0. 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-33",
					"linecount": 2,
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1197.5,
						544.3333498239517,
						71.5,
						35.0
					],
					"text": "scale 0. 1. -1. 1."
				}
			},
			{
				"box": {
					"id": "obj-32",
					"linecount": 2,
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1120.0,
						541.0,
						71.5,
						35.0
					],
					"text": "scale 0. 1. -1. 1."
				}
			},
			{
				"box": {
					"id": "obj-31",
					"maxclass": "newobj",
					"numinlets": 5,
					"numoutlets": 5,
					"outlettype": [
						"",
						"",
						"",
						"",
						""
					],
					"patching_rect": [
						1093.0,
						610.0,
						76.0,
						22.0
					],
					"text": "route 1 2 3 4"
				}
			},
			{
				"box": {
					"id": "obj-29",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1093.0,
						584.0,
						71.0,
						22.0
					],
					"text": "pack 1 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-28",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 6,
					"outlettype": [
						"float",
						"float",
						"int",
						"int",
						"int",
						""
					],
					"patching_rect": [
						1104.0,
						488.0,
						165.0,
						22.0
					],
					"text": "unpack 0. 0. 0 0 0 clientname"
				}
			},
			{
				"box": {
					"id": "obj-24",
					"linecount": 2,
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1104.0,
						445.0,
						68.0,
						35.0
					],
					"text": "route touch"
				}
			},
			{
				"box": {
					"id": "obj-3",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 6,
					"outlettype": [
						"",
						"",
						"",
						"",
						"",
						""
					],
					"patching_rect": [
						1146.0,
						692.0,
						314.0349667072296,
						22.0
					],
					"text": "route rawaccel orientation accel gravity rotationrate"
				}
			},
			{
				"box": {
					"id": "obj-2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						447.0,
						193.0,
						67.0,
						22.0
					],
					"text": "s gainmain"
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-30",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						934.5833290219307,
						408.4380447641015,
						25.875,
						151.876089528203
					],
					"presentation": 1,
					"presentation_rect": [
						840.0843371748924,
						633.0333379805088,
						21.0,
						102.16666576266289
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "slider[6]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 3
						}
					},
					"size": 2.0,
					"varname": "slider[2]"
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-17",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						965.0,
						408.0,
						25.375,
						151.876089528203
					],
					"presentation": 1,
					"presentation_rect": [
						899.24085521698,
						633.0333379805088,
						21.0,
						102.16666576266289
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "fbhue",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "fbhue",
							"parameter_type": 3
						}
					},
					"size": 2.0,
					"varname": "slider[5]"
				}
			},
			{
				"box": {
					"drawoffcolor": 1,
					"elementcolor": [
						0.164706,
						0.776471,
						0.878431,
						1.0
					],
					"floatoutput": 1,
					"id": "obj-26",
					"knobcolor": [
						0.898039,
						0.780392,
						0.368627,
						1.0
					],
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						447.0,
						63.0,
						20.0,
						119.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "slider[4]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider",
							"parameter_type": 3
						}
					},
					"size": 1.0,
					"varname": "slider[4]"
				}
			},
			{
				"box": {
					"color": [
						0.75,
						0.75,
						0.75,
						0.2
					],
					"id": "obj-11",
					"maxclass": "mira.multitouch",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						819.0,
						203.0,
						265.65507489442825,
						176.0091561228037
					],
					"pinch_enabled": 0,
					"presentation": 1,
					"presentation_rect": [
						818.25,
						420.7633735537529,
						231.34066772460938,
						168.03662449121475
					],
					"rotate_enabled": 0,
					"swipe_enabled": 0,
					"swipe_touch_count": 0,
					"tap_enabled": 0,
					"tap_tap_count": 0,
					"tap_touch_count": 0
				}
			},
			{
				"box": {
					"id": "obj-10",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1218.0,
						586.0,
						71.0,
						22.0
					],
					"text": "mira.motion"
				}
			},
			{
				"box": {
					"attr": "pinch_enabled",
					"id": "obj-20",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						592.0,
						123.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "rotate_enabled",
					"id": "obj-21",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						592.0,
						147.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "swipe_enabled",
					"id": "obj-86",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						833.0,
						172.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "swipe_enabled",
					"id": "obj-90",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						592.0,
						171.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "tap_enabled",
					"id": "obj-104",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						833.0,
						100.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"background": 1,
					"color": [
						0.0,
						0.0,
						0.0,
						0.301960784313725
					],
					"id": "obj-9",
					"ignoreclick": 1,
					"maxclass": "mira.frame",
					"numinlets": 0,
					"numoutlets": 0,
					"patching_rect": [
						560.0,
						178.0,
						562.6373767852783,
						400.0
					],
					"presentation": 1,
					"presentation_rect": [
						212.5,
						24.0,
						371.340675333044,
						264.0000047311185
					],
					"tabname": "feedbax-by-i@seanstevens.com",
					"taborder": 1
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"destination": [
						"obj-8",
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
						"obj-141",
						1
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
						"obj-100",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-100",
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
						"obj-101",
						0
					],
					"source": [
						"obj-102",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-96",
						0
					],
					"source": [
						"obj-102",
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
						"obj-102",
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
						"obj-103",
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
						"obj-104",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-16",
						4
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
						"obj-22",
						0
					],
					"source": [
						"obj-106",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-129",
						0
					],
					"source": [
						"obj-107",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-16",
						3
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
						"obj-62",
						0
					],
					"source": [
						"obj-109",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-24",
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
						"obj-103",
						0
					],
					"source": [
						"obj-110",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-106",
						0
					],
					"source": [
						"obj-111",
						0
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
						"obj-112",
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
						"obj-117",
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
						"obj-119",
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
						"obj-12",
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
						"obj-121",
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
						"obj-122",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-175",
						0
					],
					"order": 2,
					"source": [
						"obj-123",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-177",
						0
					],
					"order": 1,
					"source": [
						"obj-123",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-178",
						0
					],
					"order": 0,
					"source": [
						"obj-123",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-102",
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
						"obj-64",
						0
					],
					"source": [
						"obj-128",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-67",
						0
					],
					"source": [
						"obj-128",
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
						"obj-13",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-71",
						0
					],
					"source": [
						"obj-133",
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
						"obj-140",
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
						"obj-141",
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
					"source": [
						"obj-144",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-8",
						5
					],
					"order": 0,
					"source": [
						"obj-145",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-8",
						4
					],
					"order": 1,
					"source": [
						"obj-145",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-141",
						0
					],
					"source": [
						"obj-146",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-145",
						1
					],
					"source": [
						"obj-147",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-145",
						0
					],
					"source": [
						"obj-147",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-146",
						0
					],
					"source": [
						"obj-148",
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
					"source": [
						"obj-15",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-156",
						0
					],
					"source": [
						"obj-153",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-198",
						0
					],
					"source": [
						"obj-158",
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
						"obj-16",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-158",
						0
					],
					"source": [
						"obj-160",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-171",
						0
					],
					"source": [
						"obj-162",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-235",
						0
					],
					"source": [
						"obj-163",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-165",
						0
					],
					"source": [
						"obj-166",
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
						"obj-168",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-220",
						0
					],
					"source": [
						"obj-169",
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
						"obj-17",
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
						"obj-170",
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
						"obj-172",
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
						"obj-173",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-226",
						0
					],
					"source": [
						"obj-174",
						0
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
						"obj-174",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-170",
						0
					],
					"source": [
						"obj-175",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-172",
						0
					],
					"source": [
						"obj-176",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-173",
						0
					],
					"source": [
						"obj-177",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-168",
						0
					],
					"source": [
						"obj-178",
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
						"obj-18",
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
						"obj-191",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-191",
						2
					],
					"source": [
						"obj-192",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-191",
						1
					],
					"source": [
						"obj-196",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-118",
						0
					],
					"source": [
						"obj-198",
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
					"source": [
						"obj-20",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						6
					],
					"source": [
						"obj-209",
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
					"source": [
						"obj-21",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						5
					],
					"source": [
						"obj-210",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						4
					],
					"source": [
						"obj-211",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						3
					],
					"source": [
						"obj-212",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						2
					],
					"source": [
						"obj-213",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						1
					],
					"source": [
						"obj-214",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						0
					],
					"source": [
						"obj-215",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-208",
						0
					],
					"source": [
						"obj-216",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						7
					],
					"source": [
						"obj-217",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-216",
						8
					],
					"source": [
						"obj-218",
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
						"obj-22",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-191",
						0
					],
					"source": [
						"obj-220",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-8",
						5
					],
					"order": 0,
					"source": [
						"obj-225",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-8",
						4
					],
					"order": 1,
					"source": [
						"obj-225",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-225",
						0
					],
					"source": [
						"obj-226",
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
						"obj-23",
						0
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
						"obj-233",
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
						"obj-24",
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
					"order": 0,
					"source": [
						"obj-25",
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
					"order": 1,
					"source": [
						"obj-25",
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
						"obj-26",
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
						"obj-27",
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
						"obj-28",
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
						"obj-28",
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
					"source": [
						"obj-28",
						1
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
						"obj-29",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-35",
						0
					],
					"source": [
						"obj-3",
						1
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
						"obj-3",
						3
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
						"obj-30",
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
						"obj-31",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-29",
						1
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
						"obj-29",
						2
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
						"obj-94",
						4
					],
					"source": [
						"obj-34",
						1
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
						"obj-34",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-16",
						0
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
						"obj-83",
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
						"obj-74",
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
						"obj-75",
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
						"obj-52",
						0
					],
					"source": [
						"obj-49",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-94",
						8
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
						"obj-94",
						6
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
						"obj-8",
						2
					],
					"source": [
						"obj-53",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-54",
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
						"obj-98",
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
						"obj-12",
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
						"obj-11",
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
						"obj-53",
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
						"obj-128",
						0
					],
					"order": 0,
					"source": [
						"obj-62",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-174",
						0
					],
					"order": 1,
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
						0
					],
					"source": [
						"obj-63",
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
					"source": [
						"obj-64",
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
						"obj-67",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-6",
						1
					],
					"source": [
						"obj-7",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-57",
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
						"obj-11",
						0
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
						"obj-233",
						0
					],
					"source": [
						"obj-74",
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
						"obj-75",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-8",
						9
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
						"obj-8",
						2
					],
					"source": [
						"obj-79",
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
					"source": [
						"obj-8",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-8",
						1
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
						"obj-1",
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
						"obj-120",
						0
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
						"obj-145",
						0
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
						"obj-11",
						0
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
						"obj-8",
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
						"obj-89",
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
						"obj-114",
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
						"obj-62",
						0
					],
					"source": [
						"obj-90",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-153",
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
						"obj-4",
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
						"obj-15",
						0
					],
					"source": [
						"obj-94",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-101",
						2
					],
					"source": [
						"obj-96",
						0
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
						"obj-98",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-101",
						1
					],
					"source": [
						"obj-99",
						0
					]
				}
			}
		],
		"boxgroups": [
			{
				"boxes": [
					"obj-55",
					"obj-65"
				]
			},
			{
				"boxes": [
					"obj-188",
					"obj-187",
					"obj-180",
					"obj-181",
					"obj-182",
					"obj-183",
					"obj-184",
					"obj-185",
					"obj-186"
				]
			},
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
			},
			{
				"boxes": [
					"obj-162",
					"obj-164"
				]
			},
			{
				"boxes": [
					"obj-127",
					"obj-107"
				]
			},
			{
				"boxes": [
					"obj-157",
					"obj-146"
				]
			},
			{
				"boxes": [
					"obj-27",
					"obj-154"
				]
			},
			{
				"boxes": [
					"obj-41",
					"obj-83"
				]
			},
			{
				"boxes": [
					"obj-19",
					"obj-50"
				]
			},
			{
				"boxes": [
					"obj-38",
					"obj-17"
				]
			},
			{
				"boxes": [
					"obj-39",
					"obj-30"
				]
			},
			{
				"boxes": [
					"obj-155",
					"obj-56"
				]
			},
			{
				"boxes": [
					"obj-136",
					"obj-134",
					"obj-153",
					"obj-133",
					"obj-152"
				]
			},
			{
				"boxes": [
					"obj-25",
					"obj-110",
					"obj-111",
					"obj-126",
					"obj-130"
				]
			},
			{
				"boxes": [
					"obj-151",
					"obj-1"
				]
			},
			{
				"boxes": [
					"obj-222",
					"obj-163"
				]
			},
			{
				"boxes": [
					"obj-139",
					"obj-140"
				]
			}
		]
	}
}
