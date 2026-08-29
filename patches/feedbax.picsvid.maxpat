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
			34.0,
			88.0,
			1057.0,
			825.0
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "obj-152",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						215.0,
						20.0,
						150.0,
						20.0
					],
					"text": "Navi"
				}
			},
			{
				"box": {
					"id": "obj-316",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						296.0,
						559.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[18]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[18]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[18]"
				}
			},
			{
				"box": {
					"id": "obj-307",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						325.0,
						586.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-279",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						329.0,
						533.0,
						62.0,
						22.0
					],
					"text": "r imgbang"
				}
			},
			{
				"box": {
					"attr": "capture",
					"id": "obj-262",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						256.0,
						656.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-183",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						564.0,
						531.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[17]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[17]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[17]"
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
						554.0,
						568.0,
						91.0,
						22.0
					],
					"text": "outputmatrix $1"
				}
			},
			{
				"box": {
					"id": "obj-77",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						337.0,
						191.0,
						388.0,
						22.0
					],
					"text": "; feedbax_rescan bang"
				}
			},
			{
				"box": {
					"id": "obj-44",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						189.0,
						120.0,
						422.0,
						22.0
					],
					"text": "; feedbax_rescan bang"
				}
			},
			{
				"box": {
					"id": "obj-19",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						200.0,
						144.0,
						428.0,
						22.0
					],
					"text": "; feedbax_rescan bang"
				}
			},
			{
				"box": {
					"id": "obj-10",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						175.0,
						92.0,
						526.0,
						22.0
					],
					"text": "; feedbax_rescan bang"
				}
			},
			{
				"box": {
					"id": "obj-7",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						265.0,
						9.0,
						560.0,
						22.0
					],
					"presentation": 1,
					"presentation_linecount": 4,
					"presentation_rect": [
						293.0,
						83.0,
						220.0,
						62.0
					],
					"text": "; feedbax_rescan bang"
				}
			},
			{
				"box": {
					"id": "obj-336",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1047.0,
						45.0,
						80.0,
						22.0
					],
					"text": "loadmess 1.5"
				}
			},
			{
				"box": {
					"id": "obj-335",
					"linecount": 2,
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1008.0,
						534.0,
						24.0,
						35.0
					],
					"text": "1.1"
				}
			},
			{
				"box": {
					"id": "obj-333",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						954.0,
						45.0,
						87.0,
						22.0
					],
					"text": "loadmess 1.55"
				}
			},
			{
				"box": {
					"id": "obj-331",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						861.0,
						45.0,
						87.0,
						22.0
					],
					"text": "loadmess 1.55"
				}
			},
			{
				"box": {
					"id": "obj-330",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1226.0,
						288.0,
						29.0,
						20.0
					],
					"text": "Sat",
					"textjustification": 1
				}
			},
			{
				"box": {
					"fontsize": 12.0,
					"id": "obj-329",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1183.0,
						288.0,
						37.0,
						20.0
					],
					"text": "Cont",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-328",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1147.0,
						288.0,
						29.0,
						20.0
					],
					"text": "Brt",
					"textjustification": 1
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-326",
					"maxclass": "slider",
					"min": -2.0,
					"mult": 2.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1223.0,
						312.0,
						34.0,
						72.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[25]",
							"parameter_mmax": 0.0,
							"parameter_mmin": -2.0,
							"parameter_modmode": 3,
							"parameter_shortname": "slider[3]",
							"parameter_type": 0
						}
					},
					"size": 2.0,
					"varname": "slider[8]"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-325",
					"maxclass": "slider",
					"min": -2.0,
					"mult": 2.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1184.0,
						312.0,
						34.0,
						72.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[24]",
							"parameter_mmax": 0.0,
							"parameter_mmin": -2.0,
							"parameter_modmode": 3,
							"parameter_shortname": "slider[3]",
							"parameter_type": 0
						}
					},
					"size": 2.0,
					"varname": "slider[7]"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-322",
					"maxclass": "slider",
					"min": -2.0,
					"mult": 2.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1144.0,
						312.0,
						34.0,
						72.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[23]",
							"parameter_mmax": 0.0,
							"parameter_mmin": -2.0,
							"parameter_modmode": 3,
							"parameter_shortname": "slider[3]",
							"parameter_type": 0
						}
					},
					"size": 2.0,
					"varname": "slider[6]"
				}
			},
			{
				"box": {
					"id": "obj-321",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1035.0,
						322.0,
						96.0,
						20.0
					],
					"text": "BRCOSA adjust"
				}
			},
			{
				"box": {
					"id": "obj-319",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1007.0,
						320.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[60]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[60]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[16]"
				}
			},
			{
				"box": {
					"id": "obj-317",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						"jit_gl_texture"
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
							758.0,
							760.0
						],
						"gridsize": [
							15.0,
							15.0
						],
						"boxes": [
							{
								"box": {
									"comment": "Saturation",
									"id": "obj-8",
									"index": 4,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										650.0,
										416.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"comment": "Contrast",
									"id": "obj-7",
									"index": 3,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										573.0,
										416.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"comment": "Brightness",
									"id": "obj-3",
									"index": 2,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										499.0,
										416.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"id": "obj-2",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										643.5,
										543.0,
										57.0,
										22.0
									],
									"text": "clip -2. 2."
								}
							},
							{
								"box": {
									"id": "obj-1",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										577.0,
										543.0,
										57.0,
										22.0
									],
									"text": "clip -2. 2."
								}
							},
							{
								"box": {
									"id": "obj-64",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										504.0,
										543.0,
										57.0,
										22.0
									],
									"text": "clip -2. 2."
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
									"id": "obj-140",
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
										650.0,
										459.0,
										44.0,
										48.0
									],
									"presentation": 1,
									"presentation_rect": [
										140.4748077392578,
										40.792236328125,
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
												4.0
											],
											"parameter_initial_enable": 1,
											"parameter_longname": "Saturation[1]",
											"parameter_mmax": 8.0,
											"parameter_mmin": -8.0,
											"parameter_modmode": 0,
											"parameter_shortname": "Saturation",
											"parameter_type": 0,
											"parameter_unitstyle": 1
										}
									},
									"varname": "Freq[2]"
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
									"id": "obj-127",
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
										573.0,
										459.0,
										44.0,
										48.0
									],
									"presentation": 1,
									"presentation_rect": [
										71.97479248046875,
										40.792236328125,
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
												6.0
											],
											"parameter_initial_enable": 1,
											"parameter_longname": "Contrast[1]",
											"parameter_mmax": 8.0,
											"parameter_mmin": -8.0,
											"parameter_modmode": 0,
											"parameter_shortname": "Contrast",
											"parameter_type": 0,
											"parameter_unitstyle": 1
										}
									},
									"varname": "Freq[1]"
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
									"id": "obj-119",
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
										504.0,
										463.0,
										44.0,
										48.0
									],
									"presentation": 1,
									"presentation_rect": [
										3.474807977676392,
										40.792236328125,
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
											"parameter_longname": "Brightness[1]",
											"parameter_mmax": 8.0,
											"parameter_mmin": -8.0,
											"parameter_modmode": 0,
											"parameter_shortname": "Brightness",
											"parameter_type": 0,
											"parameter_unitstyle": 1
										}
									},
									"varname": "Freq"
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
										282.0,
										563.0,
										70.0,
										22.0
									],
									"text": "loadmess 1"
								}
							},
							{
								"box": {
									"id": "obj-15",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										249.0,
										663.3333315849304,
										20.0,
										22.0
									],
									"text": "t l"
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
									"id": "obj-4",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"jit_gl_texture",
										""
									],
									"patching_rect": [
										210.0,
										760.0,
										125.0,
										22.0
									],
									"text": "jit.gl.pix @gen brcosa"
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
									"id": "obj-13",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"",
										""
									],
									"patching_rect": [
										249.0,
										716.0,
										67.0,
										22.0
									],
									"text": "vzgl-object"
								}
							},
							{
								"box": {
									"align": 2,
									"bgcolor": [
										0.3,
										0.3,
										0.3,
										1.0
									],
									"bgoncolor": [
										0.165741,
										0.364658,
										0.14032,
										1.0
									],
									"fontname": "Ableton Sans Bold Regular",
									"hint": "The BRCOSR module (based on the jit.brcosa object) is the official Vizzie \"do not adjust your set\" color module for image fun. You can modify your image's brightness, image contrast, and color saturation individually or together. The module also allows you to not only work with nice big ranges of values, but also to invert some of them for very different results.",
									"id": "obj-6",
									"legacytextcolor": 1,
									"maxclass": "textbutton",
									"mode": 1,
									"numinlets": 1,
									"numoutlets": 3,
									"outlettype": [
										"",
										"",
										"int"
									],
									"parameter_enable": 1,
									"patching_rect": [
										282.0,
										603.0,
										40.0,
										20.0
									],
									"presentation": 1,
									"presentation_rect": [
										0.474808007478714,
										15.0,
										208.0,
										19.0
									],
									"saved_attribute_attributes": {
										"valueof": {
											"parameter_enum": [
												"off",
												"on"
											],
											"parameter_initial": [
												1
											],
											"parameter_initial_enable": 1,
											"parameter_invisible": 1,
											"parameter_longname": "range[9]",
											"parameter_mmax": 1.0,
											"parameter_modmode": 0,
											"parameter_shortname": "range",
											"parameter_type": 3
										}
									},
									"text": "OFF  ",
									"textcolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"textjustification": 2,
									"texton": "ON  ",
									"textoncolor": [
										0.905882,
										0.909804,
										0.917647,
										1.0
									],
									"usebgoncolor": 1,
									"varname": "FreqMode[3]"
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
										650.0,
										584.0,
										80.0,
										23.0
									],
									"text": "saturation $1"
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
										573.0,
										584.0,
										72.0,
										23.0
									],
									"text": "contrast $1"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-45",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										485.0,
										584.0,
										83.0,
										23.0
									],
									"text": "brightness $1"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-56",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 4,
									"outlettype": [
										"",
										"",
										"",
										"off"
									],
									"patching_rect": [
										188.0,
										603.0,
										85.0,
										23.0
									],
									"text": "video-handler"
								}
							},
							{
								"box": {
									"comment": "Video output",
									"id": "obj-14",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										188.0,
										799.0,
										25.0,
										25.0
									]
								}
							},
							{
								"box": {
									"comment": "Video input",
									"id": "obj-5",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										"int"
									],
									"patching_rect": [
										188.0,
										554.0,
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
										"obj-130",
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
										"obj-64",
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
										"obj-1",
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
										"obj-4",
										0
									],
									"midpoints": [
										258.5,
										748.5,
										219.5,
										748.5
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
										"obj-15",
										0
									],
									"midpoints": [
										582.5,
										642.0,
										258.5,
										642.0
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
										"obj-2",
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
										"obj-15",
										0
									],
									"midpoints": [
										659.5,
										642.0,
										258.5,
										642.0
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
										"obj-4",
										0
									],
									"midpoints": [
										258.5,
										707.6666651964188,
										219.5,
										707.6666651964188
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
										"obj-143",
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
										"obj-64",
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
										"obj-14",
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
										"obj-15",
										0
									],
									"midpoints": [
										494.5,
										642.0,
										258.5,
										642.0
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
										"obj-56",
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
										"obj-13",
										0
									],
									"order": 0,
									"source": [
										"obj-56",
										1
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
										"obj-56",
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
									"order": 1,
									"source": [
										"obj-56",
										1
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
										2
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-56",
										1
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
										"obj-45",
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
										"obj-1",
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
										"obj-2",
										0
									],
									"source": [
										"obj-8",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						936.0,
						676.0,
						156.0,
						22.0
					],
					"text": "p brcosaslab",
					"varname": "brcosaslab"
				}
			},
			{
				"box": {
					"id": "obj-313",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1032.0,
						294.0,
						64.0,
						20.0
					],
					"text": "LumaLow"
				}
			},
			{
				"box": {
					"id": "obj-311",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1032.0,
						267.0,
						67.0,
						20.0
					],
					"text": "LumaHigh"
				}
			},
			{
				"box": {
					"id": "obj-308",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1007.0,
						265.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[59]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[59]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[15]"
				}
			},
			{
				"box": {
					"id": "obj-305",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1007.0,
						292.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[58]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[11]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[8]"
				}
			},
			{
				"box": {
					"id": "obj-301",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1483.0,
						343.0,
						41.0,
						20.0
					],
					"text": "Light",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-299",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1445.0,
						343.0,
						34.0,
						20.0
					],
					"text": "Sat",
					"textjustification": 1
				}
			},
			{
				"box": {
					"id": "obj-294",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1402.0,
						343.0,
						34.0,
						20.0
					],
					"text": "Hue",
					"textjustification": 1
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-268",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1486.0,
						365.0,
						34.0,
						72.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[22]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 3,
							"parameter_shortname": "slider[3]",
							"parameter_type": 0
						}
					},
					"size": 1.0,
					"varname": "slider[5]"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-267",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1445.0,
						365.0,
						34.0,
						72.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[21]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 3,
							"parameter_shortname": "slider[3]",
							"parameter_type": 0
						}
					},
					"size": 1.0,
					"varname": "slider[3]"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-260",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1402.0,
						365.0,
						34.0,
						72.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[20]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 3,
							"parameter_shortname": "slider[3]",
							"parameter_type": 0
						}
					},
					"size": 1.0,
					"varname": "slider[4]"
				}
			},
			{
				"box": {
					"id": "obj-258",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1422.0,
						453.0,
						87.0,
						22.0
					],
					"text": "pak hsl 0. 1. 1."
				}
			},
			{
				"box": {
					"id": "obj-125",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						823.0,
						440.0,
						82.0,
						20.0
					],
					"text": "Full Alpha"
				}
			},
			{
				"box": {
					"id": "obj-94",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						823.0,
						408.0,
						90.0,
						20.0
					],
					"text": "Circle Alpha"
				}
			},
			{
				"box": {
					"id": "obj-67",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						794.0,
						438.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[16]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[16]",
							"parameter_type": 2
						}
					},
					"varname": "button[7]"
				}
			},
			{
				"box": {
					"id": "obj-11",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						794.0,
						406.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[15]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[15]",
							"parameter_type": 2
						}
					},
					"varname": "button[6]"
				}
			},
			{
				"box": {
					"id": "obj-9",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						302.0,
						942.0,
						273.0,
						22.0
					],
					"text": "importmovie NormalFullAlpha1080p1.png 1, bang"
				}
			},
			{
				"box": {
					"id": "obj-72",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						278.0,
						33.0,
						447.0,
						22.0
					],
					"text": "; feedbax_rescan bang"
				}
			},
			{
				"box": {
					"id": "obj-298",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						302.0,
						971.0,
						150.0,
						20.0
					],
					"text": "Requires path set!"
				}
			},
			{
				"box": {
					"id": "obj-293",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						372.0,
						881.0,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "obj-287",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						302.0,
						911.0,
						258.0,
						22.0
					],
					"text": "importmovie circleGradiant1080p6.png 1, bang"
				}
			},
			{
				"box": {
					"id": "obj-280",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						366.0,
						835.0,
						248.0,
						22.0
					],
					"text": "importmovie NormalFullAlpha1080p1.png 0"
				}
			},
			{
				"box": {
					"id": "obj-276",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						284.0,
						859.0,
						73.0,
						22.0
					],
					"text": "loadmess 1."
				}
			},
			{
				"box": {
					"id": "obj-269",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						47.0,
						820.0,
						72.0,
						22.0
					],
					"text": "r keyCh2init"
				}
			},
			{
				"box": {
					"id": "obj-257",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						13.0,
						862.0,
						63.0,
						22.0
					],
					"text": "r camRaw"
				}
			},
			{
				"box": {
					"annotation": "## Combine video using alpha channel masking ##",
					"bgmode": 1,
					"border": 0,
					"clickthrough": 0,
					"enablehscroll": 0,
					"enablevscroll": 0,
					"id": "obj-252",
					"lockeddragscroll": 0,
					"lockedsize": 0,
					"maxclass": "bpatcher",
					"name": "vz.alphablendr.maxpat",
					"numinlets": 5,
					"numoutlets": 1,
					"offset": [
						0.0,
						0.0
					],
					"outlettype": [
						"jit_gl_texture"
					],
					"patching_rect": [
						18.0,
						918.0,
						268.0,
						146.0
					],
					"prototypename": "pixl",
					"varname": "alphablendr",
					"viewvisibility": 1
				}
			},
			{
				"box": {
					"id": "obj-245",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1275.0,
						459.0,
						104.0,
						20.0
					],
					"text": "Low Bandwidth"
				}
			},
			{
				"box": {
					"id": "obj-203",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1249.0,
						456.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[57]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[57]",
							"parameter_type": 2
						}
					},
					"varname": "toggle"
				}
			},
			{
				"box": {
					"id": "obj-196",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						720.0,
						513.0,
						135.0,
						22.0
					],
					"text": "prepend low_bandwidth"
				}
			},
			{
				"box": {
					"id": "obj-156",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						371.0,
						401.0,
						92.0,
						22.0
					],
					"text": "prepend enable"
				}
			},
			{
				"box": {
					"id": "obj-139",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						"int"
					],
					"patching_rect": [
						371.0,
						317.0,
						29.5,
						22.0
					],
					"text": "t b i"
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
						371.0,
						367.0,
						29.5,
						22.0
					],
					"text": "||"
				}
			},
			{
				"box": {
					"id": "obj-137",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1005.0,
						221.0,
						123.99999922513962,
						20.0
					],
					"text": "Transparency Type"
				}
			},
			{
				"box": {
					"id": "obj-128",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1006.0,
						150.0,
						150.0,
						20.0
					],
					"text": "Camera Type"
				}
			},
			{
				"box": {
					"id": "obj-98",
					"linecount": 2,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						995.0,
						440.0,
						144.5,
						33.0
					],
					"text": "NDI camera source selection"
				}
			},
			{
				"box": {
					"id": "obj-96",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1202.0,
						459.0,
						51.95210248231888,
						20.0
					],
					"text": "Rescan"
				}
			},
			{
				"box": {
					"id": "obj-75",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1178.0,
						456.0,
						23.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[14]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[14]",
							"parameter_type": 2
						}
					},
					"varname": "button[5]"
				}
			},
			{
				"box": {
					"id": "obj-51",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						""
					],
					"patching_rect": [
						750.0,
						135.0,
						34.0,
						22.0
					],
					"text": "sel 0"
				}
			},
			{
				"box": {
					"id": "obj-315",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1286.0,
						415.0,
						37.0,
						22.0
					],
					"text": "close"
				}
			},
			{
				"box": {
					"id": "obj-314",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1247.0,
						415.0,
						35.0,
						22.0
					],
					"text": "open"
				}
			},
			{
				"box": {
					"id": "obj-312",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1201.0,
						417.0,
						51.95210248231888,
						20.0
					],
					"text": "Rescan"
				}
			},
			{
				"box": {
					"id": "obj-310",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1176.0,
						413.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[13]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[13]",
							"parameter_type": 2
						}
					},
					"varname": "button[4]"
				}
			},
			{
				"box": {
					"id": "obj-306",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1308.0,
						77.0,
						210.56910556554794,
						22.0
					],
					"text": "0.328129 0.144197 0. 1."
				}
			},
			{
				"box": {
					"id": "obj-303",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1448.0,
						45.0,
						80.0,
						22.0
					],
					"text": "loadmess 0.2"
				}
			},
			{
				"box": {
					"id": "obj-304",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1448.0,
						22.0,
						80.0,
						22.0
					],
					"text": "loadmess 0.2"
				}
			},
			{
				"box": {
					"id": "obj-302",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1165.0,
						251.0,
						74.40650403499603,
						20.0
					],
					"text": "Reset Keys"
				}
			},
			{
				"box": {
					"id": "obj-300",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1140.0,
						247.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[12]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[12]",
							"parameter_type": 2
						}
					},
					"varname": "button[3]"
				}
			},
			{
				"box": {
					"id": "obj-297",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 12,
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
						"float",
						"float"
					],
					"patching_rect": [
						636.0,
						995.0,
						207.0,
						22.0
					],
					"text": "unpack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-296",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						636.0,
						968.0,
						59.0,
						22.0
					],
					"text": "r keyCtrls"
				}
			},
			{
				"box": {
					"id": "obj-295",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"outlettype": [
						"float",
						"float",
						"float",
						"float"
					],
					"patching_rect": [
						1805.0,
						353.0,
						101.0,
						22.0
					],
					"text": "unpack 0. 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-290",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1554.0,
						420.0,
						358.5365851521492,
						20.0
					],
					"text": "highLuma tol fade lowLuma tol fade ChromaTol fade r g b a"
				}
			},
			{
				"box": {
					"id": "obj-291",
					"maxclass": "newobj",
					"numinlets": 12,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1570.0,
						442.0,
						338.21138191223145,
						22.0
					],
					"text": "pak 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-292",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1570.0,
						468.0,
						61.0,
						22.0
					],
					"text": "s keyCtrls"
				}
			},
			{
				"box": {
					"id": "obj-289",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1422.0,
						289.0,
						109.75609749555588,
						20.0
					],
					"text": "Fade"
				}
			},
			{
				"box": {
					"id": "obj-288",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1304.0,
						289.0,
						109.75609749555588,
						20.0
					],
					"text": "Chroma Tolerance"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-286",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1422.0,
						305.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[131]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[15]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-285",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1304.0,
						305.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[130]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[14]"
				}
			},
			{
				"box": {
					"id": "obj-284",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1304.0,
						119.0,
						150.0,
						20.0
					],
					"text": "Chromakey Color"
				}
			},
			{
				"box": {
					"id": "obj-283",
					"maxclass": "swatch",
					"numinlets": 3,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1304.0,
						141.0,
						217.07317060232162,
						143.9024389386177
					],
					"saturation": 1.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "swatch[8]",
							"parameter_modmode": 0,
							"parameter_shortname": "swatch[2]",
							"parameter_type": 3
						}
					},
					"varname": "swatch[1]"
				}
			},
			{
				"box": {
					"id": "obj-282",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1129.0,
						224.0,
						156.23304599523544,
						20.0
					],
					"text": "Luminance Tolerance Fade"
				}
			},
			{
				"box": {
					"id": "obj-281",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1129.0,
						164.0,
						156.23304599523544,
						20.0
					],
					"text": "Luminance Tolerance Fade"
				}
			},
			{
				"box": {
					"id": "obj-278",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1140.0,
						179.0,
						150.0,
						20.0
					],
					"text": "Lumakey low"
				}
			},
			{
				"box": {
					"id": "obj-277",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1140.0,
						120.0,
						150.0,
						20.0
					],
					"text": "Lumakey high"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-273",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1247.0,
						202.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[72]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[11]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-274",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1194.0,
						202.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[73]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[12]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-275",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1140.0,
						202.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[129]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[13]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-272",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1247.0,
						142.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[71]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[10]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-271",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1194.0,
						142.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[70]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[9]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-270",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1140.0,
						142.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[8]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[8]"
				}
			},
			{
				"box": {
					"id": "obj-265",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						774.0,
						301.0,
						29.5,
						22.0
					],
					"text": "!= 1"
				}
			},
			{
				"box": {
					"id": "obj-264",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						328.0,
						1506.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-263",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						254.0,
						1119.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-261",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						71.0,
						1398.0,
						150.0,
						20.0
					],
					"text": "init channel 2 key"
				}
			},
			{
				"box": {
					"id": "obj-254",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						273.0,
						1431.0,
						29.5,
						22.0
					],
					"text": "255"
				}
			},
			{
				"box": {
					"id": "obj-255",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						206.0,
						1431.0,
						29.5,
						22.0
					],
					"text": "255"
				}
			},
			{
				"box": {
					"id": "obj-256",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						142.0,
						1431.0,
						29.5,
						22.0
					],
					"text": "255"
				}
			},
			{
				"box": {
					"id": "obj-253",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						39.0,
						1431.0,
						29.5,
						22.0
					],
					"text": "0"
				}
			},
			{
				"box": {
					"id": "obj-251",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						420.0,
						1185.0,
						72.0,
						22.0
					],
					"text": "r keyCh2init"
				}
			},
			{
				"box": {
					"id": "obj-250",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						410.0,
						1012.0,
						72.0,
						22.0
					],
					"text": "r keyCh2init"
				}
			},
			{
				"box": {
					"id": "obj-249",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						429.0,
						1361.0,
						72.0,
						22.0
					],
					"text": "r keyCh2init"
				}
			},
			{
				"box": {
					"id": "obj-248",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						39.0,
						1671.0,
						74.0,
						22.0
					],
					"text": "s keyCh2init"
				}
			},
			{
				"box": {
					"id": "obj-247",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						291.0,
						1627.0,
						105.0,
						22.0
					],
					"text": "s cameragrabpost"
				}
			},
			{
				"box": {
					"id": "obj-246",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						170.0,
						812.0,
						150.0,
						20.0
					],
					"text": "Gradiant loader"
				}
			},
			{
				"box": {
					"id": "obj-244",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						815.0,
						137.0,
						70.0,
						22.0
					],
					"text": "loadmess 0"
				}
			},
			{
				"box": {
					"id": "obj-243",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						332.0,
						1405.0,
						71.0,
						22.0
					],
					"text": "r chromaEn"
				}
			},
			{
				"box": {
					"id": "obj-240",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						302.0,
						994.0,
						57.0,
						22.0
					],
					"text": "r lumaEn"
				}
			},
			{
				"box": {
					"id": "obj-234",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						837.0,
						333.0,
						73.0,
						22.0
					],
					"text": "s chromaEn"
				}
			},
			{
				"box": {
					"id": "obj-223",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						776.0,
						333.0,
						59.0,
						22.0
					],
					"text": "s lumaEn"
				}
			},
			{
				"box": {
					"id": "obj-211",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1361.0,
						45.0,
						80.0,
						22.0
					],
					"text": "loadmess 0.1"
				}
			},
			{
				"box": {
					"id": "obj-212",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1270.0,
						45.0,
						87.0,
						22.0
					],
					"text": "loadmess 0.15"
				}
			},
			{
				"box": {
					"id": "obj-221",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1195.0,
						45.0,
						73.0,
						22.0
					],
					"text": "loadmess 0."
				}
			},
			{
				"box": {
					"id": "obj-210",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1361.0,
						22.0,
						80.0,
						22.0
					],
					"text": "loadmess 0.1"
				}
			},
			{
				"box": {
					"id": "obj-200",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1269.0,
						22.0,
						80.0,
						22.0
					],
					"text": "loadmess 0.2"
				}
			},
			{
				"box": {
					"id": "obj-181",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1195.0,
						22.0,
						73.0,
						22.0
					],
					"text": "loadmess 1."
				}
			},
			{
				"box": {
					"id": "obj-149",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						441.0,
						635.0,
						47.0,
						22.0
					],
					"text": "r toNDI"
				}
			},
			{
				"box": {
					"id": "obj-129",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1078.0,
						1437.0,
						49.0,
						22.0
					],
					"text": "s toNDI"
				}
			},
			{
				"box": {
					"id": "obj-204",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						137.0,
						810.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[9]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[9]",
							"parameter_type": 2
						}
					},
					"varname": "button[2]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-191",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						152.0,
						842.0,
						117.0,
						23.0
					],
					"text": "importmovie, bang"
				}
			},
			{
				"box": {
					"id": "obj-155",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						115.0,
						875.0,
						150.0,
						22.0
					],
					"text": "jit.matrix 4 char 1920 1080"
				}
			},
			{
				"box": {
					"annotation": "## Combine two videos using lumakeying ##",
					"bgmode": 1,
					"border": 0,
					"clickthrough": 0,
					"enablehscroll": 0,
					"enablevscroll": 0,
					"id": "obj-153",
					"lockeddragscroll": 0,
					"lockedsize": 0,
					"maxclass": "bpatcher",
					"name": "vz.lumakeyr.maxpat",
					"numinlets": 5,
					"numoutlets": 1,
					"offset": [
						0.0,
						0.0
					],
					"outlettype": [
						"jit_gl_texture"
					],
					"patching_rect": [
						351.0,
						1244.0,
						450.0,
						146.0
					],
					"prototypename": "pixl",
					"varname": "lumakeyr[1]",
					"viewvisibility": 1
				}
			},
			{
				"box": {
					"id": "obj-150",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1006.0,
						235.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[51]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[51]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[14]"
				}
			},
			{
				"box": {
					"id": "obj-141",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1031.0,
						239.0,
						97.99999922513962,
						20.0
					],
					"text": "Luma/Chroma"
				}
			},
			{
				"box": {
					"id": "obj-148",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1952.0,
						465.0,
						55.0,
						22.0
					],
					"text": "pipe 100"
				}
			},
			{
				"box": {
					"id": "obj-146",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						""
					],
					"patching_rect": [
						1944.0,
						430.0,
						34.0,
						22.0
					],
					"text": "sel 1"
				}
			},
			{
				"box": {
					"id": "obj-145",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1951.0,
						389.0,
						58.0,
						22.0
					],
					"text": "r usbcam"
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
						1287.0,
						837.0,
						150.0,
						22.0
					],
					"text": "loadmess output_texture 1"
				}
			},
			{
				"box": {
					"id": "obj-121",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						302.0,
						1026.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[47]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[11]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[13]"
				}
			},
			{
				"box": {
					"id": "obj-114",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						722.0,
						750.0,
						29.5,
						22.0
					],
					"text": "0"
				}
			},
			{
				"box": {
					"id": "obj-80",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						770.0,
						711.0,
						55.0,
						22.0
					],
					"text": "pipe 100"
				}
			},
			{
				"box": {
					"id": "obj-120",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						861.0,
						97.0,
						49.0,
						22.0
					],
					"text": "r livevid"
				}
			},
			{
				"box": {
					"id": "obj-93",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						""
					],
					"patching_rect": [
						506.0,
						359.0,
						34.0,
						22.0
					],
					"text": "sel 0"
				}
			},
			{
				"box": {
					"id": "obj-64",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						9.0,
						1367.0,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"annotation": "## Combine two videos using lumakeying ##",
					"bgmode": 1,
					"border": 0,
					"clickthrough": 0,
					"enablehscroll": 0,
					"enablevscroll": 0,
					"id": "obj-48",
					"lockeddragscroll": 0,
					"lockedsize": 0,
					"maxclass": "bpatcher",
					"name": "vz.lumakeyr.maxpat",
					"numinlets": 5,
					"numoutlets": 1,
					"offset": [
						0.0,
						0.0
					],
					"outlettype": [
						"jit_gl_texture"
					],
					"patching_rect": [
						356.0,
						1053.0,
						450.0,
						146.0
					],
					"prototypename": "pixl",
					"varname": "lumakeyr",
					"viewvisibility": 1
				}
			},
			{
				"box": {
					"id": "obj-82",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						857.0,
						1521.0,
						187.29629385471344,
						22.0
					],
					"text": "0.898039 0.898039 0.898039 1."
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
					"patching_rect": [
						857.0,
						1491.0,
						80.0,
						22.0
					],
					"text": "prepend rgba"
				}
			},
			{
				"box": {
					"id": "obj-62",
					"maxclass": "suckah",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						940.0,
						1424.0,
						108.8325987458229,
						83.41850313544273
					]
				}
			},
			{
				"box": {
					"id": "obj-60",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"float",
						"float",
						"float"
					],
					"patching_rect": [
						772.0,
						1402.0,
						87.0,
						22.0
					],
					"text": "unpack 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-55",
					"maxclass": "swatch",
					"numinlets": 3,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						838.0,
						1551.0,
						157.0,
						135.0
					],
					"saturation": 1.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "swatch[2]",
							"parameter_modmode": 0,
							"parameter_shortname": "swatch[2]",
							"parameter_type": 3
						}
					},
					"varname": "swatch"
				}
			},
			{
				"box": {
					"id": "obj-25",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						405.0,
						627.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 9.0,
					"id": "obj-22",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						433.0,
						593.0,
						49.0,
						19.0
					],
					"text": "r imgbang"
				}
			},
			{
				"box": {
					"id": "obj-241",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						502.0,
						1373.0,
						150.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						314.3333756327629,
						403.5,
						150.0,
						20.0
					],
					"text": "Chromakey params"
				}
			},
			{
				"box": {
					"id": "obj-239",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						679.0,
						1396.0,
						41.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						491.3333756327629,
						427.0,
						41.0,
						20.0
					],
					"text": "Fade"
				}
			},
			{
				"box": {
					"id": "obj-238",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						626.0,
						1398.0,
						41.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						438.3333756327629,
						429.0,
						41.0,
						20.0
					],
					"text": "Tol"
				}
			},
			{
				"box": {
					"id": "obj-237",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						565.0,
						1398.0,
						41.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						377.8333756327629,
						429.0,
						41.0,
						20.0
					],
					"text": "B"
				}
			},
			{
				"box": {
					"id": "obj-236",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						502.0,
						1398.0,
						41.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						314.3333756327629,
						429.0,
						41.0,
						20.0
					],
					"text": "G"
				}
			},
			{
				"box": {
					"id": "obj-235",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						435.0,
						1398.0,
						41.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						248.3333756327629,
						429.0,
						41.0,
						20.0
					],
					"text": "R"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-233",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						679.0,
						1422.0,
						50.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						491.3333756327629,
						453.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[52]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[2]",
							"parameter_type": 3
						}
					},
					"varname": "number[6]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-232",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						626.0,
						1422.0,
						50.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						438.3333756327629,
						453.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[51]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[2]",
							"parameter_type": 3
						}
					},
					"varname": "number[5]"
				}
			},
			{
				"box": {
					"id": "obj-231",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1267.0,
						1427.0,
						69.3333740234375,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						810.0,
						468.5,
						73.0,
						20.0
					],
					"text": "PTZ Zoom"
				}
			},
			{
				"box": {
					"id": "obj-230",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1157.0,
						1437.0,
						97.0,
						22.0
					],
					"text": "pak ptz_zoom 0."
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-229",
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1256.0,
						1277.0,
						51.1666259765625,
						147.5
					],
					"presentation": 1,
					"presentation_rect": [
						813.8333740234375,
						317.8110892928926,
						51.1666259765625,
						147.5
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[16]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider[12]",
							"parameter_type": 0
						}
					},
					"size": 2.0,
					"varname": "slider[2]"
				}
			},
			{
				"box": {
					"id": "obj-228",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1005.0,
						1317.0,
						150.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						547.0,
						344.3110892928926,
						150.0,
						20.0
					],
					"text": "PTZ Pan Tilt"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-227",
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1191.0,
						1277.0,
						51.1666259765625,
						147.5
					],
					"presentation": 1,
					"presentation_rect": [
						732.8333740234375,
						317.8110892928926,
						51.1666259765625,
						147.5
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[13]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider[12]",
							"parameter_type": 0
						}
					},
					"size": 2.0,
					"varname": "slider[1]"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-226",
					"maxclass": "slider",
					"min": -1.0,
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1018.0,
						1339.0,
						169.1666259765625,
						51.5
					],
					"presentation": 1,
					"presentation_rect": [
						560.166748046875,
						365.8110892928926,
						169.1666259765625,
						51.5
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[12]",
							"parameter_mmax": 1.0,
							"parameter_mmin": -1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider[12]",
							"parameter_type": 0
						}
					},
					"size": 2.0,
					"varname": "slider"
				}
			},
			{
				"box": {
					"id": "obj-225",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1053.0,
						1396.0,
						113.0,
						22.0
					],
					"text": "pak ptz_pantilt 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-224",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						972.0,
						1205.0,
						150.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						619.0,
						270.3694527071075,
						150.0,
						20.0
					],
					"text": "PTZ Preset "
				}
			},
			{
				"box": {
					"fontsize": 24.0,
					"id": "obj-220",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1369.0,
						1231.0,
						29.5,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						649.0,
						292.3694527071075,
						29.5,
						35.0
					],
					"text": "8"
				}
			},
			{
				"box": {
					"fontsize": 24.0,
					"id": "obj-219",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1321.0,
						1231.0,
						29.5,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						600.8333740234375,
						292.3694527071075,
						29.5,
						35.0
					],
					"text": "7"
				}
			},
			{
				"box": {
					"fontsize": 24.0,
					"id": "obj-218",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1267.0,
						1231.0,
						29.5,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						546.8333740234375,
						292.3694527071075,
						29.5,
						35.0
					],
					"text": "6"
				}
			},
			{
				"box": {
					"fontsize": 24.0,
					"id": "obj-217",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1212.0,
						1231.0,
						29.5,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						491.8333740234375,
						292.3694527071075,
						29.5,
						35.0
					],
					"text": "5"
				}
			},
			{
				"box": {
					"fontsize": 24.0,
					"id": "obj-216",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1157.0,
						1231.0,
						29.5,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						436.8333740234375,
						292.3694527071075,
						29.5,
						35.0
					],
					"text": "4"
				}
			},
			{
				"box": {
					"fontsize": 24.0,
					"id": "obj-215",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1102.0,
						1231.0,
						29.5,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						382.8333740234375,
						292.3694527071075,
						29.5,
						35.0
					],
					"text": "3"
				}
			},
			{
				"box": {
					"fontsize": 24.0,
					"id": "obj-214",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1044.0,
						1231.0,
						29.5,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						323.0,
						292.3694527071075,
						29.5,
						35.0
					],
					"text": "2"
				}
			},
			{
				"box": {
					"fontsize": 24.0,
					"id": "obj-213",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						975.0,
						1231.0,
						46.0,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						256.0,
						292.3694527071075,
						46.0,
						35.0
					],
					"text": "1"
				}
			},
			{
				"box": {
					"id": "obj-208",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						126.0,
						368.0,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-207",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						142.0,
						400.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[12]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[12]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[12]"
				}
			},
			{
				"box": {
					"id": "obj-201",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						48.0,
						431.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-195",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						241.0,
						1431.0,
						29.5,
						22.0
					],
					"text": "0"
				}
			},
			{
				"box": {
					"id": "obj-198",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						225.0,
						1461.0,
						61.0,
						22.0
					],
					"text": "jit.fill alp 3"
				}
			},
			{
				"box": {
					"id": "obj-190",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						174.0,
						1431.0,
						29.5,
						22.0
					],
					"text": "0"
				}
			},
			{
				"box": {
					"id": "obj-192",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						161.0,
						1461.0,
						61.0,
						22.0
					],
					"text": "jit.fill alp 2"
				}
			},
			{
				"box": {
					"id": "obj-186",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						110.0,
						1431.0,
						29.5,
						22.0
					],
					"text": "0"
				}
			},
			{
				"box": {
					"id": "obj-189",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						95.0,
						1461.0,
						61.0,
						22.0
					],
					"text": "jit.fill alp 1"
				}
			},
			{
				"box": {
					"id": "obj-182",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						9.0,
						1413.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[7]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[7]",
							"parameter_type": 2
						}
					},
					"varname": "button[1]"
				}
			},
			{
				"box": {
					"annotation": "## Convert Jitter matrix input to texture output ##",
					"bgmode": 1,
					"border": 0,
					"clickthrough": 0,
					"enablehscroll": 0,
					"enablevscroll": 0,
					"id": "obj-179",
					"lockeddragscroll": 0,
					"lockedsize": 0,
					"maxclass": "bpatcher",
					"name": "vz.matrix2texture.maxpat",
					"numinlets": 1,
					"numoutlets": 1,
					"offset": [
						0.0,
						0.0
					],
					"outlettype": [
						""
					],
					"patching_rect": [
						27.0,
						1534.0,
						182.0,
						120.0
					],
					"prototypename": "pixl",
					"varname": "matrix2texture[1]",
					"viewvisibility": 1
				}
			},
			{
				"box": {
					"id": "obj-165",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						71.0,
						1431.0,
						29.5,
						22.0
					],
					"text": "255"
				}
			},
			{
				"box": {
					"id": "obj-161",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						27.0,
						1461.0,
						61.0,
						22.0
					],
					"text": "jit.fill alp 0"
				}
			},
			{
				"box": {
					"id": "obj-159",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						27.0,
						1496.0,
						169.0,
						22.0
					],
					"text": "jit.matrix alp 4 char 1920 1080"
				}
			},
			{
				"box": {
					"id": "obj-147",
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
							898.0,
							730.0
						],
						"gridsize": [
							15.0,
							15.0
						],
						"boxes": [
							{
								"box": {
									"hint": "Click in this window to choose the keying color. Portions of video in 1 that include this color will appear transparent, and video in 2 will be visible in its place.",
									"id": "obj-57",
									"maxclass": "suckah",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"outputalpha": 0,
									"patching_rect": [
										332.0,
										275.0,
										80.0,
										60.0
									],
									"presentation": 1,
									"presentation_rect": [
										4.0,
										39.16353225708008,
										112.0,
										84.0
									]
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
									"id": "obj-40",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										493.16662599999995,
										662.0,
										73.0,
										22.0
									],
									"text": "vzgl-routegl"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-20",
									"maxclass": "newobj",
									"numinlets": 5,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										343.666687,
										527.0,
										197.333328,
										23.0
									],
									"text": "pack color 0. 0. 0. 1."
								}
							},
							{
								"box": {
									"id": "obj-46",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										774.666687,
										573.0,
										92.0,
										22.0
									],
									"text": "prepend param"
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
										774.666687,
										541.0,
										34.0,
										22.0
									],
									"text": "t l"
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
									"filename": "co.chromakey.hsv.jxs",
									"id": "obj-35",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 2,
									"outlettype": [
										"jit_gl_texture",
										""
									],
									"patching_rect": [
										493.16662599999995,
										699.0,
										204.0,
										22.0
									],
									"text": "jit.gl.slab @file co.chromakey.hsv.jxs",
									"textfile": {
										"filename": "co.chromakey.hsv.jxs",
										"flags": 0,
										"embed": 0,
										"autowatch": 1
									}
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
									"id": "obj-38",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"",
										""
									],
									"patching_rect": [
										570.0,
										662.0,
										67.0,
										22.0
									],
									"text": "vzgl-object"
								}
							},
							{
								"box": {
									"bgmode": 0,
									"border": 0,
									"clickthrough": 0,
									"enablehscroll": 0,
									"enablevscroll": 0,
									"id": "obj-7",
									"lockeddragscroll": 0,
									"lockedsize": 0,
									"maxclass": "bpatcher",
									"name": "vzgl-pwindow.maxpat",
									"numinlets": 3,
									"numoutlets": 1,
									"offset": [
										0.0,
										0.0
									],
									"outlettype": [
										""
									],
									"patching_rect": [
										241.0,
										191.0,
										78.0,
										68.0
									],
									"presentation": 1,
									"presentation_rect": [
										4.0,
										39.16353225708008,
										112.0,
										84.0
									],
									"viewvisibility": 1
								}
							},
							{
								"box": {
									"bgmode": 0,
									"border": 0,
									"clickthrough": 0,
									"enablehscroll": 0,
									"enablevscroll": 0,
									"hint": "input image 2",
									"id": "obj-17",
									"lockeddragscroll": 0,
									"lockedsize": 0,
									"maxclass": "bpatcher",
									"name": "vzgl-pwindow.maxpat",
									"numinlets": 3,
									"numoutlets": 1,
									"offset": [
										0.0,
										0.0
									],
									"outlettype": [
										""
									],
									"patching_rect": [
										332.0,
										191.0,
										86.0,
										68.0
									],
									"presentation": 1,
									"presentation_rect": [
										120.0,
										39.16353225708008,
										112.0,
										84.0
									],
									"viewvisibility": 1
								}
							},
							{
								"box": {
									"bgmode": 0,
									"border": 0,
									"clickthrough": 0,
									"enablehscroll": 0,
									"enablevscroll": 0,
									"hint": "output image",
									"id": "obj-4",
									"lockeddragscroll": 0,
									"lockedsize": 0,
									"maxclass": "bpatcher",
									"name": "vzgl-pwindow.maxpat",
									"numinlets": 3,
									"numoutlets": 1,
									"offset": [
										0.0,
										0.0
									],
									"outlettype": [
										""
									],
									"patching_rect": [
										269.0,
										832.0,
										116.0,
										92.0
									],
									"presentation": 1,
									"presentation_rect": [
										291.0,
										39.16353225708008,
										112.0,
										84.0
									],
									"viewvisibility": 1
								}
							},
							{
								"box": {
									"hint": "This palette displays the keying color you clicked on in the window above. You can also click and drag to set a keying color",
									"id": "obj-45",
									"maxclass": "swatch",
									"numinlets": 3,
									"numoutlets": 2,
									"outlettype": [
										"",
										"float"
									],
									"parameter_enable": 1,
									"patching_rect": [
										241.0,
										386.0,
										80.0,
										60.0
									],
									"saturation": 1.0,
									"saved_attribute_attributes": {
										"valueof": {
											"parameter_initial": [
												0.0,
												0.0,
												0.0,
												1.0,
												0.0,
												1.0,
												0.0
											],
											"parameter_initial_enable": 1,
											"parameter_invisible": 1,
											"parameter_longname": "swatch[1]",
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
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-78",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										269.0,
										353.0,
										80.0,
										23.0
									],
									"text": "saturation $1"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-2",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 3,
									"outlettype": [
										"",
										"",
										""
									],
									"patching_rect": [
										115.0,
										353.0,
										85.0,
										23.0
									],
									"restore": [
										1.0,
										0.71764705882353,
										0.71764705882353,
										1.0,
										0.0,
										1.0,
										0.858823529411765
									],
									"saved_object_attributes": {
										"parameter_enable": 0,
										"parameter_mappable": 0
									},
									"text": "pattr keycolor",
									"varname": "keycolor"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-93",
									"maxclass": "newobj",
									"numinlets": 4,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										544.0,
										275.0,
										83.0,
										23.0
									],
									"text": "pak 0. 0. 0. 1."
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 11.595187,
									"id": "obj-94",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 2,
									"outlettype": [
										"",
										""
									],
									"patching_rect": [
										544.0,
										304.0,
										60.0,
										22.0
									],
									"text": "zl change"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										269.0,
										742.0,
										68.0,
										23.0
									],
									"text": "r ---bypass"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-61",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										269.0,
										802.0,
										54.0,
										23.0
									],
									"text": "gate 1 1"
								}
							},
							{
								"box": {
									"bgcolor": [
										0.913,
										0.913,
										0.913,
										0.75
									],
									"blinkcolor": [
										1.0,
										0.89,
										0.09,
										1.0
									],
									"id": "obj-44",
									"maxclass": "button",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										"bang"
									],
									"outlinecolor": [
										0.439216,
										0.447059,
										0.47451,
										1.0
									],
									"parameter_enable": 0,
									"patching_rect": [
										343.666687,
										498.0,
										20.0,
										20.0
									]
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-1",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 4,
									"outlettype": [
										"float",
										"float",
										"float",
										"float"
									],
									"patching_rect": [
										344.0,
										457.0,
										153.0,
										23.0
									],
									"text": "unpack 0. 0. 0. 0."
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-20",
										3
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
										"obj-20",
										2
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
										"obj-20",
										1
									],
									"order": 0,
									"source": [
										"obj-1",
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
									"midpoints": [
										353.5,
										483.0,
										353.166687,
										483.0
									],
									"order": 1,
									"source": [
										"obj-1",
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
									"source": [
										"obj-2",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-46",
										0
									],
									"midpoints": [
										353.166687,
										561.0,
										784.166687,
										561.0
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
										"obj-61",
										1
									],
									"midpoints": [
										502.66662599999995,
										768.0,
										313.5,
										768.0
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
										"obj-35",
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
										"obj-35",
										0
									],
									"source": [
										"obj-40",
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
										"obj-42",
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
										"obj-44",
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
										250.5,
										452.0,
										353.5,
										452.0
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
										"obj-40",
										0
									],
									"source": [
										"obj-46",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-61",
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
									"order": 0,
									"source": [
										"obj-57",
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
									"midpoints": [
										341.5,
										345.0,
										250.5,
										345.0
									],
									"order": 1,
									"source": [
										"obj-57",
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
										"obj-61",
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
									"source": [
										"obj-78",
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
										"obj-93",
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
									"midpoints": [
										553.5,
										345.5,
										250.5,
										345.5
									],
									"source": [
										"obj-94",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						1551.0,
						1227.0,
						42.0,
						22.0
					],
					"text": "p chro",
					"varname": "chro"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-142",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						502.0,
						1422.0,
						50.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						314.3333756327629,
						453.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[95]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[2]",
							"parameter_type": 3
						}
					},
					"varname": "number[4]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-135",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						429.0,
						1422.0,
						50.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						242.00004229942954,
						453.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[99]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[2]",
							"parameter_type": 3
						}
					},
					"varname": "number[3]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-134",
					"maxclass": "flonum",
					"maximum": 1.0,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						565.0,
						1422.0,
						50.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						377.8333756327629,
						453.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[2]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[2]",
							"parameter_type": 3
						}
					},
					"varname": "number[2]"
				}
			},
			{
				"box": {
					"annotation": "## Convert Jitter matrix input to texture output ##",
					"bgmode": 1,
					"border": 0,
					"clickthrough": 0,
					"enablehscroll": 0,
					"enablevscroll": 0,
					"id": "obj-133",
					"lockeddragscroll": 0,
					"lockedsize": 0,
					"maxclass": "bpatcher",
					"name": "vz.matrix2texture.maxpat",
					"numinlets": 1,
					"numoutlets": 1,
					"offset": [
						0.0,
						0.0
					],
					"outlettype": [
						""
					],
					"patching_rect": [
						693.0,
						803.0,
						182.0,
						120.0
					],
					"prototypename": "pixl",
					"varname": "matrix2texture",
					"viewvisibility": 1
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-130",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						683.0,
						1566.0,
						47.0,
						21.0
					],
					"text": "Blue",
					"textcolor": [
						0.50196099281311,
						0.50196099281311,
						0.50196099281311,
						1.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-131",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						553.0,
						1566.0,
						45.0,
						21.0
					],
					"text": "Green",
					"textcolor": [
						0.50196099281311,
						0.50196099281311,
						0.50196099281311,
						1.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-132",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						423.0,
						1566.0,
						34.0,
						21.0
					],
					"text": "Red",
					"textcolor": [
						0.50196099281311,
						0.50196099281311,
						0.50196099281311,
						1.0
					]
				}
			},
			{
				"box": {
					"id": "obj-97",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						372.0,
						1437.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[11]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[11]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[11]"
				}
			},
			{
				"box": {
					"annotation": "## Combine two videos using chromakeying ##",
					"bgmode": 1,
					"border": 0,
					"clickthrough": 0,
					"enablehscroll": 0,
					"enablevscroll": 0,
					"id": "obj-26",
					"lockeddragscroll": 0,
					"lockedsize": 0,
					"maxclass": "bpatcher",
					"name": "vz.chromakeyr.maxpat",
					"numinlets": 7,
					"numoutlets": 4,
					"offset": [
						0.0,
						0.0
					],
					"outlettype": [
						"jit_gl_texture",
						"",
						"",
						""
					],
					"patching_rect": [
						414.0,
						1453.0,
						408.0,
						146.0
					],
					"prototypename": "pixl",
					"varname": "chromakeyr",
					"viewvisibility": 1
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
						290.0,
						57.0,
						545.0,
						22.0
					],
					"presentation": 1,
					"presentation_linecount": 4,
					"presentation_rect": [
						518.5,
						19.0,
						220.0,
						62.0
					],
					"text": "; feedbax_rescan bang"
				}
			},
			{
				"box": {
					"id": "obj-14",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"int"
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
							358.0,
							97.0,
							698.0,
							755.0
						],
						"gridsize": [
							15.0,
							15.0
						],
						"boxes": [
							{
								"box": {
									"id": "obj-72",
									"maxclass": "newobj",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										71.0,
										208.17346199999997,
										56.0,
										22.0
									],
									"text": "r movSel"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-7",
									"index": 2,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										415.0,
										529.0,
										30.0,
										30.0
									]
								}
							},
							{
								"box": {
									"id": "obj-3",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										478.0,
										526.0,
										50.0,
										22.0
									]
								}
							},
							{
								"box": {
									"activebgcolor": [
										0.1,
										0.1,
										0.1,
										1.0
									],
									"activebgoncolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"bgcolor": [
										0.1,
										0.1,
										0.1,
										1.0
									],
									"bgoncolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"bordercolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"focusbordercolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"hint": "Choose a movie or send the \"folder\" message to populate the menu",
									"id": "obj-41",
									"ignoreclick": 1,
									"maxclass": "live.toggle",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"parameter_enable": 1,
									"parameter_mappable": 0,
									"patching_rect": [
										724.0,
										159.006989,
										15.0,
										15.0
									],
									"presentation": 1,
									"presentation_rect": [
										3.0,
										4.0,
										9.742591857910156,
										9.742591857910156
									],
									"rounded": 15.0,
									"saved_attribute_attributes": {
										"activebgcolor": {
											"expression": ""
										},
										"activebgoncolor": {
											"expression": ""
										},
										"bgcolor": {
											"expression": ""
										},
										"bgoncolor": {
											"expression": ""
										},
										"bordercolor": {
											"expression": ""
										},
										"focusbordercolor": {
											"expression": ""
										},
										"valueof": {
											"parameter_enum": [
												"off",
												"on"
											],
											"parameter_initial": [
												1
											],
											"parameter_initial_enable": 1,
											"parameter_invisible": 2,
											"parameter_longname": "pictctrl[1]",
											"parameter_mmax": 1,
											"parameter_modmode": 0,
											"parameter_shortname": "pictctrl[1]",
											"parameter_type": 2
										}
									},
									"varname": "pictctrl[3]"
								}
							},
							{
								"box": {
									"activebgcolor": [
										0.1,
										0.1,
										0.1,
										1.0
									],
									"activebgoncolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"bgcolor": [
										0.1,
										0.1,
										0.1,
										1.0
									],
									"bgoncolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"bordercolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"focusbordercolor": [
										1.0,
										1.0,
										1.0,
										1.0
									],
									"hint": "Connect this outlet to the rightmost inlet of the PLAYR module to support menu-based file loading",
									"id": "obj-30",
									"ignoreclick": 1,
									"maxclass": "live.toggle",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"parameter_enable": 1,
									"parameter_mappable": 0,
									"patching_rect": [
										230.0,
										487.0,
										15.0,
										15.0
									],
									"presentation": 1,
									"presentation_rect": [
										3.0,
										82.0,
										9.742591857910156,
										9.742591857910156
									],
									"rounded": 15.0,
									"saved_attribute_attributes": {
										"activebgcolor": {
											"expression": ""
										},
										"activebgoncolor": {
											"expression": ""
										},
										"bgcolor": {
											"expression": ""
										},
										"bgoncolor": {
											"expression": ""
										},
										"bordercolor": {
											"expression": ""
										},
										"focusbordercolor": {
											"expression": ""
										},
										"valueof": {
											"parameter_enum": [
												"off",
												"on"
											],
											"parameter_initial": [
												1
											],
											"parameter_initial_enable": 1,
											"parameter_invisible": 2,
											"parameter_longname": "pictctrl[2]",
											"parameter_mmax": 1,
											"parameter_modmode": 0,
											"parameter_shortname": "pictctrl[1]",
											"parameter_type": 2
										}
									},
									"varname": "pictctrl[2]"
								}
							},
							{
								"box": {
									"autopopulate": 1,
									"bgcolor": [
										0.8,
										0.5,
										0.5,
										1.0
									],
									"bgfillcolor_angle": 270.0,
									"bgfillcolor_autogradient": 0,
									"bgfillcolor_color": [
										0.8,
										0.5,
										0.5,
										1.0
									],
									"bgfillcolor_color1": [
										0.454902,
										0.462745,
										0.482353,
										1.0
									],
									"bgfillcolor_color2": [
										0.290196,
										0.309804,
										0.301961,
										1.0
									],
									"bgfillcolor_proportion": 0.39,
									"bgfillcolor_type": "color",
									"hint": "Select an input source",
									"id": "obj-5",
									"items": [
										"cleo2.png",
										",",
										"cleoBaby.png",
										",",
										"cleoLooks.png",
										",",
										"cleoMeh.png",
										",",
										"cleoStand.png",
										",",
										"dblcat.png",
										",",
										"dblcat2.png",
										",",
										"dblcat3.png",
										",",
										"dblcat4.png",
										",",
										"Image 2.png",
										",",
										"Image 3.png",
										",",
										"Image 4.png",
										",",
										"Image 5.png",
										",",
										"Image copy.png",
										",",
										"Image.png",
										",",
										"IMG_3658.PNG",
										",",
										"IMG_3659.PNG",
										",",
										"IMG_3660.PNG",
										",",
										"IMG_3661.PNG",
										",",
										"IMG_3662.PNG",
										",",
										"IMG_3663.PNG",
										",",
										"IMG_3664.PNG",
										",",
										"IMG_3665.PNG",
										",",
										"IMG_3666.PNG",
										",",
										"IMG_3667.PNG",
										",",
										"IMG_3668.PNG",
										",",
										"IMG_3669.PNG",
										",",
										"IMG_3670.PNG",
										",",
										"IMG_3671.PNG",
										",",
										"IMG_3672.PNG",
										",",
										"IMG_3673.PNG",
										",",
										"IMG_3674.PNG",
										",",
										"IMG_3675.PNG",
										",",
										"IMG_3676.PNG",
										",",
										"IMG_3677.PNG",
										",",
										"IMG_3678.PNG",
										",",
										"IMG_3679.PNG",
										",",
										"IMG_3680.PNG",
										",",
										"IMG_3681.PNG",
										",",
										"IMG_3682.PNG",
										",",
										"IMG_3683.PNG",
										",",
										"IMG_3683u.png",
										",",
										"IMG_3684.PNG",
										",",
										"Pasted Graphic 14.png",
										",",
										"Pasted Graphic 4.png",
										",",
										"pasted-image-281.png",
										",",
										"pasted-image-285.png",
										",",
										"pasted-image-294.png",
										",",
										"pasted-image-299.png",
										",",
										"pasted-image-304.png",
										",",
										"pasted-image-310.png",
										",",
										"Subject.png",
										",",
										"Untitled.png"
									],
									"maxclass": "umenu",
									"numinlets": 1,
									"numoutlets": 3,
									"outlettype": [
										"int",
										"",
										""
									],
									"parameter_enable": 1,
									"patching_rect": [
										163.0,
										283.0,
										218.0,
										22.0
									],
									"prefix": "",
									"presentation": 1,
									"presentation_rect": [
										11.525192260742188,
										45.31418228149414,
										214.0,
										22.0
									],
									"saved_attribute_attributes": {
										"valueof": {
											"parameter_invisible": 1,
											"parameter_longname": "Menu[1]",
											"parameter_mmax": 52.0,
											"parameter_modmode": 0,
											"parameter_shortname": "Menu",
											"parameter_type": 3
										}
									},
									"textcolor": [
										0.25,
										0.0,
										0.0,
										1.0
									],
									"types": [
										"MooV",
										"MPEG",
										"mpg4",
										"VfW",
										"WMV",
										"PICT",
										"PNG",
										"GIFf",
										"TIFF",
										"BMP"
									],
									"varname": "umenu"
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
										216.5,
										314.223145,
										65.0,
										22.0
									],
									"text": "route drag"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-6",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 2,
									"outlettype": [
										"",
										""
									],
									"patching_rect": [
										262.5,
										342.223145,
										62.0,
										23.0
									],
									"text": "zl change"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-4",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 3,
									"outlettype": [
										"",
										"",
										""
									],
									"patching_rect": [
										585.0,
										76.0,
										89.0,
										23.0
									],
									"text": "route int folder"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-1",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										163.0,
										204.0,
										87.0,
										23.0
									],
									"text": "prepend prefix"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 11.595187,
									"id": "obj-31",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										370.0,
										243.0,
										383.0,
										22.0
									],
									"text": "types MooV MPEG mpg4 \"VfW \" \"WMV \" PICT \"PNG \" GIFf TIFF \"BMP \""
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-46",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"int",
										"bang"
									],
									"patching_rect": [
										362.0,
										342.223145,
										43.5,
										23.0
									],
									"text": "t i b"
								}
							},
							{
								"box": {
									"bgcolor": [
										0.913,
										0.913,
										0.913,
										0.75
									],
									"blinkcolor": [
										1.0,
										0.89,
										0.09,
										1.0
									],
									"id": "obj-43",
									"maxclass": "button",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										"bang"
									],
									"outlinecolor": [
										0.439216,
										0.447059,
										0.47451,
										1.0
									],
									"parameter_enable": 0,
									"patching_rect": [
										908.0,
										20.0,
										20.0,
										20.0
									]
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-75",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 3,
									"outlettype": [
										"",
										"",
										""
									],
									"patching_rect": [
										655.0,
										113.006989,
										88.0,
										23.0
									],
									"text": "data-handler"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-39",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										386.5,
										385.771027,
										248.0,
										23.0
									],
									"text": "bgcolor 0.8 0.5 0.5 1., textcolor 0.25 0. 0. 1."
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-37",
									"maxclass": "message",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										348.0,
										204.0,
										600.0,
										23.0
									],
									"text": "clear, bgcolor 0.25 0. 0. 1., framecolor 1. 1. 1. 1., textcolor 1. 1. 1. 1., append drag a folder here to load movies"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-108",
									"maxclass": "newobj",
									"numinlets": 6,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										650.0,
										416.371918,
										95.0,
										23.0
									],
									"text": "scale 0. 1. 0 1 1"
								}
							},
							{
								"box": {
									"comment": "Choose a movie or send the \"folder\" message to populate the menu",
									"id": "obj-76",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										585.0,
										36.0,
										25.0,
										25.0
									]
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-50",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 3,
									"outlettype": [
										"int",
										"int",
										"bang"
									],
									"patching_rect": [
										936.0,
										49.0,
										46.0,
										23.0
									],
									"text": "t 0 1 b"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-71",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										228.0,
										508.0,
										54.0,
										23.0
									],
									"text": "gate 1 1"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-33",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										"bang"
									],
									"patching_rect": [
										937.0,
										21.0,
										60.0,
										23.0
									],
									"text": "loadbang"
								}
							},
							{
								"box": {
									"comment": "Connect this outlet to the rightmost inlet of the PLAYR module to support menu-based file loading",
									"id": "obj-17",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										229.0,
										532.0,
										25.0,
										25.0
									]
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-22",
									"maxclass": "newobj",
									"numinlets": 2,
									"numoutlets": 2,
									"outlettype": [
										"",
										""
									],
									"patching_rect": [
										362.0,
										314.223145,
										98.0,
										23.0
									],
									"text": "route populate"
								}
							},
							{
								"box": {
									"fontname": "Ableton Sans Medium",
									"fontsize": 12.0,
									"id": "obj-13",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										263.0,
										385.771027,
										82.0,
										23.0
									],
									"text": "prepend read"
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"destination": [
										"obj-5",
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
										"obj-5",
										0
									],
									"midpoints": [
										659.5,
										444.0,
										151.0,
										444.0,
										151.0,
										268.0,
										172.5,
										268.0
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
										"obj-71",
										1
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
										"obj-46",
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
										"obj-71",
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
										"obj-5",
										0
									],
									"midpoints": [
										379.5,
										268.0,
										172.5,
										268.0
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
										"obj-50",
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
										"obj-5",
										0
									],
									"midpoints": [
										357.5,
										268.0,
										172.5,
										268.0
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
										"obj-5",
										0
									],
									"midpoints": [
										396.0,
										444.0,
										151.5,
										444.0,
										151.5,
										268.0,
										172.5,
										268.0
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
										"obj-1",
										0
									],
									"midpoints": [
										629.5,
										167.0,
										172.5,
										167.0
									],
									"source": [
										"obj-4",
										1
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
										"obj-4",
										2
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
										"obj-43",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-108",
										4
									],
									"midpoints": [
										371.5,
										374.797546,
										720.3,
										374.797546
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
										"obj-39",
										0
									],
									"source": [
										"obj-46",
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
										"obj-22",
										0
									],
									"source": [
										"obj-5",
										2
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
										"obj-5",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-30",
										0
									],
									"midpoints": [
										959.0,
										474.5,
										239.0,
										474.5
									],
									"source": [
										"obj-50",
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
									"midpoints": [
										972.5,
										233.5,
										379.5,
										233.5
									],
									"order": 0,
									"source": [
										"obj-50",
										2
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-37",
										0
									],
									"midpoints": [
										972.5,
										191.0,
										357.5,
										191.0
									],
									"order": 1,
									"source": [
										"obj-50",
										2
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
										"obj-6",
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
										"obj-71",
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
										"obj-72",
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
										"obj-75",
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
									"midpoints": [
										699.0,
										147.006989,
										733.0,
										147.006989
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
										"obj-4",
										0
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
										"obj-6",
										0
									],
									"source": [
										"obj-8",
										1
									]
								}
							}
						]
					},
					"patching_rect": [
						175.0,
						181.0,
						34.0,
						22.0
					],
					"text": "p pic"
				}
			},
			{
				"box": {
					"id": "obj-206",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						10.0,
						68.0,
						150.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						355.3000002503395,
						6.0,
						118.0,
						20.0
					],
					"text": "Video/Pic control"
				}
			},
			{
				"box": {
					"id": "obj-205",
					"linecount": 2,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						13.0,
						33.0,
						150.0,
						33.0
					],
					"presentation": 1,
					"presentation_linecount": 2,
					"presentation_rect": [
						35.08337336778641,
						-0.5,
						150.0,
						33.0
					],
					"text": "feedbax v90+\nSean Stevens 2025"
				}
			},
			{
				"box": {
					"id": "obj-197",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						941.0,
						635.0,
						80.0,
						22.0
					],
					"text": "r cameragrab"
				}
			},
			{
				"box": {
					"id": "obj-193",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						927.0,
						708.0,
						65.0,
						22.0
					],
					"text": "s camRaw"
				}
			},
			{
				"box": {
					"id": "obj-188",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1063.0,
						999.0,
						82.0,
						22.0
					],
					"text": "s cameragrab"
				}
			},
			{
				"box": {
					"id": "obj-187",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						53.0,
						172.0,
						82.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						49.0,
						46.5,
						150.0,
						20.0
					],
					"text": "movieBang"
				}
			},
			{
				"box": {
					"id": "obj-184",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1032.0,
						168.0,
						38.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						314.3333756327629,
						264.0,
						38.0,
						20.0
					],
					"text": "NDI"
				}
			},
			{
				"box": {
					"id": "obj-180",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1006.0,
						165.0,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						288.3333756327629,
						260.56945799999994,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[7]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[7]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[7]"
				}
			},
			{
				"box": {
					"id": "obj-177",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1766.0,
						808.0,
						60.0,
						20.0
					],
					"text": "Binary"
				}
			},
			{
				"box": {
					"id": "obj-163",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1708.0,
						887.0,
						103.0,
						20.0
					],
					"text": "Only output Key"
				}
			},
			{
				"box": {
					"id": "obj-162",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1032.0,
						193.0,
						85.69999974966049,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						314.9666333794594,
						208.93054200000006,
						85.69999974966049,
						20.0
					],
					"text": "USB"
				}
			},
			{
				"box": {
					"id": "obj-160",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1006.0,
						191.0,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						288.6666331291199,
						206.93054200000006,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[38]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[38]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[1]"
				}
			},
			{
				"box": {
					"id": "obj-185",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						992.0,
						399.0,
						186.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						288.0666486620903,
						97.30000430345535,
						203.0,
						20.0
					],
					"text": "USB Camera Input Selection"
				}
			},
			{
				"box": {
					"id": "obj-178",
					"linecount": 2,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1572.0,
						1051.0,
						128.0,
						33.0
					],
					"text": "Check for changes to folder"
				}
			},
			{
				"box": {
					"id": "obj-158",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1543.0,
						1060.0,
						20.0,
						20.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[10]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[10]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[10]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-166",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						1543.0,
						1089.0,
						58.0,
						22.0
					],
					"text": "metro 30"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-168",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1604.0,
						1257.0,
						34.0,
						22.0
					],
					"text": "print"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-172",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1611.0,
						1190.0,
						32.5,
						22.0
					],
					"text": "t l l"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-173",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1599.0,
						1223.0,
						45.0,
						22.0
					],
					"text": "zl.filter"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-174",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1611.0,
						1160.0,
						53.0,
						22.0
					],
					"text": "zl.group"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-175",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1543.0,
						1152.0,
						57.0,
						22.0
					],
					"text": "zl.slice 1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-176",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"int"
					],
					"patching_rect": [
						1543.0,
						1118.0,
						188.0,
						23.0
					],
					"text": "folder \"./Cycling '74/max-help\""
				}
			},
			{
				"box": {
					"fontname": "Futura Medium",
					"fontsize": 12.0,
					"id": "obj-23",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2078.0,
						712.0,
						59.0,
						24.0
					],
					"text": "r 2dfft4x"
				}
			},
			{
				"box": {
					"fontname": "Futura Medium",
					"fontsize": 12.0,
					"id": "obj-50",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2148.0,
						712.0,
						77.0,
						24.0
					],
					"text": "r scope2011"
				}
			},
			{
				"box": {
					"fontname": "Futura Medium",
					"fontsize": 12.0,
					"id": "obj-157",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2233.0,
						712.0,
						67.0,
						24.0
					],
					"text": "r waterfall"
				}
			},
			{
				"box": {
					"id": "obj-43",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						805.0,
						257.0,
						60.0,
						22.0
					],
					"text": "s usbcam"
				}
			},
			{
				"box": {
					"id": "obj-42",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1032.0,
						124.0,
						102.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						313.5,
						45.5,
						109.0,
						20.0
					],
					"text": "Enable camera"
				}
			},
			{
				"box": {
					"id": "obj-151",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1734.0,
						845.0,
						103.0,
						20.0
					],
					"text": "Invert"
				}
			},
			{
				"box": {
					"id": "obj-74",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1079.0,
						822.0,
						58.0,
						22.0
					],
					"text": "r usbcam"
				}
			},
			{
				"box": {
					"id": "obj-15",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1069.0,
						907.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[36]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[36]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[9]"
				}
			},
			{
				"box": {
					"id": "obj-17",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1088.0,
						951.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-127",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1682.0,
						885.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[34]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[34]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[6]"
				}
			},
			{
				"box": {
					"id": "obj-126",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1708.0,
						843.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[33]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[33]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[5]"
				}
			},
			{
				"box": {
					"id": "obj-124",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1823.0,
						886.0,
						123.0,
						22.0
					],
					"text": "prepend param mode"
				}
			},
			{
				"box": {
					"id": "obj-123",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1839.0,
						853.0,
						123.0,
						22.0
					],
					"text": "prepend param invert"
				}
			},
			{
				"box": {
					"id": "obj-122",
					"linecount": 23,
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1826.0,
						1092.0,
						530.0,
						315.0
					],
					"text": "\tLuminance based keying\n\t</description>\n\t<param name=\"luma\" type=\"float\" default=\"0.0\">\n\t\t<description>Target luminance</description>\n\t</param>\n\t<param name=\"tol\" type=\"float\" default=\"0.3\">\n\t\t<description>Tolerance</description>\n\t</param>\n\t<param name=\"fade\" type=\"float\" default=\"0.\">\n\t\t<description>Fade amount</description>\n\t</param>\t\n\t<param name=\"lumcoeff\" type=\"vec4\" default=\"0.299 .587 0.114 0.\">\n\t\t<description>Luminance coefficients (RGBA)</description>\n\t</param>\n\t<param name=\"invert\" type=\"float\" default=\"0.0\">\n\t\t<description>Invert mask</description>\n\t</param>\n\t<param name=\"mode\" type=\"float\" default=\"0.0\">\n\t\t<description>Mask mode (if 1, result mask only)</description>\n\t</param>\n\t<param name=\"binary\" type=\"float\" default=\"0.0\">\n\t\t<description>Mix with second source (if 0, just gen alpha channel)</description>\n\t</param>"
				}
			},
			{
				"box": {
					"id": "obj-119",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1737.0,
						805.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[32]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[32]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[4]"
				}
			},
			{
				"box": {
					"id": "obj-95",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1851.0,
						825.0,
						126.0,
						22.0
					],
					"text": "prepend param binary"
				}
			},
			{
				"box": {
					"id": "obj-87",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1007.0,
						120.0,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						287.5,
						43.5,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[31]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[31]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[3]"
				}
			},
			{
				"box": {
					"id": "obj-92",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						391.0,
						579.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-85",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						382.0,
						545.0,
						103.0,
						22.0
					],
					"text": "r cameragrabpost"
				}
			},
			{
				"box": {
					"id": "obj-83",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						298.0,
						1372.0,
						105.0,
						22.0
					],
					"text": "s cameragrabpost"
				}
			},
			{
				"box": {
					"id": "obj-79",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"patching_rect": [
						589.0,
						222.0,
						22.0,
						22.0
					],
					"text": "t 0"
				}
			},
			{
				"box": {
					"id": "obj-78",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						81.0,
						92.0,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "obj-24",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1091.0,
						856.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[16]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[16]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[2]"
				}
			},
			{
				"box": {
					"id": "obj-13",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1119.0,
						888.0,
						32.0,
						22.0
					],
					"text": "gate"
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
					"appearance": 3,
					"dialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"fontface": 1,
					"fontsize": 12.0,
					"hint": "Set the luminance of the keying function.",
					"id": "obj-81",
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
						1975.0,
						808.0,
						64.0,
						75.0
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
								0.5
							],
							"parameter_initial_enable": 1,
							"parameter_longname": "Luminance",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "Luminance",
							"parameter_type": 0,
							"parameter_unitstyle": 1
						}
					},
					"triangle": 1,
					"varname": "control[2]"
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
					"appearance": 3,
					"dialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"fontface": 1,
					"fontsize": 12.0,
					"hint": "Crossfade between the keyed and unkeyed video.",
					"id": "obj-84",
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
						2198.0,
						799.0,
						64.0,
						75.0
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
								0.5
							],
							"parameter_initial_enable": 1,
							"parameter_longname": "Fade",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "Fade",
							"parameter_type": 0,
							"parameter_unitstyle": 1
						}
					},
					"triangle": 1,
					"varname": "control"
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
					"appearance": 3,
					"dialcolor": [
						1.0,
						1.0,
						1.0,
						1.0
					],
					"fontface": 1,
					"fontsize": 12.0,
					"hint": "Set the tolerance of the keying function.",
					"id": "obj-86",
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
						2076.0,
						797.0,
						64.0,
						75.0
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
								0.5
							],
							"parameter_initial_enable": 1,
							"parameter_longname": "Tolerance",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "Tolerance",
							"parameter_type": 0,
							"parameter_unitstyle": 1
						}
					},
					"triangle": 1,
					"varname": "control[1]"
				}
			},
			{
				"box": {
					"id": "obj-88",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1946.0,
						925.0,
						90.0,
						22.0
					],
					"text": "prepend param"
				}
			},
			{
				"box": {
					"id": "obj-89",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2088.0,
						920.0,
						90.0,
						22.0
					],
					"text": "prepend param"
				}
			},
			{
				"box": {
					"id": "obj-90",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2192.0,
						920.0,
						90.0,
						22.0
					],
					"text": "prepend param"
				}
			},
			{
				"box": {
					"fontname": "Ableton Sans Medium",
					"fontsize": 12.0,
					"id": "obj-91",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1954.0,
						893.0,
						51.0,
						23.0
					],
					"text": "luma $1"
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
					"filename": "co.lumakey.jxs",
					"id": "obj-116",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"jit_gl_texture",
						""
					],
					"patching_rect": [
						2081.0,
						952.0,
						458.0,
						22.0
					],
					"text": "jit.gl.slab @file co.lumakey.jxs @param binary 0 @param fade 0.05 @param tol 0.05",
					"textfile": {
						"filename": "co.lumakey.jxs",
						"flags": 0,
						"embed": 0,
						"autowatch": 1
					}
				}
			},
			{
				"box": {
					"fontname": "Ableton Sans Medium",
					"fontsize": 12.0,
					"id": "obj-117",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2204.0,
						886.0,
						51.0,
						23.0
					],
					"text": "fade $1"
				}
			},
			{
				"box": {
					"fontname": "Ableton Sans Medium",
					"fontsize": 12.0,
					"id": "obj-118",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2076.0,
						892.0,
						62.0,
						23.0
					],
					"text": "tol $1"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-73",
					"maxclass": "jit.fpsgui",
					"mode": 3,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						124.0,
						292.0,
						80.0,
						35.0
					],
					"presentation": 1,
					"presentation_rect": [
						16.5,
						86.09999519586563,
						80.0,
						35.0
					]
				}
			},
			{
				"box": {
					"id": "obj-71",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						255.0,
						222.0,
						81.0,
						22.0
					],
					"text": "s movsFound"
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
						610.0,
						246.0,
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
						553.0,
						323.0,
						58.0,
						22.0
					],
					"text": "s movSel"
				}
			},
			{
				"box": {
					"id": "obj-66",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						631.0,
						312.0,
						79.0,
						22.0
					],
					"text": "prepend max"
				}
			},
			{
				"box": {
					"id": "obj-65",
					"maxclass": "incdec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"parameter_enable": 0,
					"patching_rect": [
						492.0,
						260.0,
						55.0,
						53.0
					],
					"presentation": 1,
					"presentation_rect": [
						16.5,
						233.0,
						55.0,
						53.0
					]
				}
			},
			{
				"box": {
					"id": "obj-61",
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
						553.0,
						260.0,
						50.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						77.5,
						233.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[1]",
							"parameter_mmax": 53.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[1]",
							"parameter_type": 0
						}
					},
					"varname": "number[1]"
				}
			},
			{
				"box": {
					"id": "obj-57",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						553.0,
						289.0,
						50.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						77.5,
						262.0,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[39]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[39]",
							"parameter_type": 3
						}
					},
					"varname": "number"
				}
			},
			{
				"box": {
					"id": "obj-54",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						""
					],
					"patching_rect": [
						40.0,
						216.0,
						31.0,
						22.0
					],
					"text": "t b s"
				}
			},
			{
				"box": {
					"id": "obj-53",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						21.0,
						170.0,
						24.0,
						24.0
					],
					"presentation": 1,
					"presentation_rect": [
						16.5,
						44.5,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[6]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[6]",
							"parameter_type": 2
						}
					},
					"varname": "button"
				}
			},
			{
				"box": {
					"id": "obj-49",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_gl_texture",
						""
					],
					"patching_rect": [
						93.0,
						252.0,
						224.0,
						22.0
					],
					"text": "jit.movie @output_texture 0"
				}
			},
			{
				"box": {
					"id": "obj-115",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1136.0,
						856.0,
						62.0,
						22.0
					],
					"text": "r imgbang"
				}
			},
			{
				"box": {
					"id": "obj-99",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1531.0,
						898.0,
						61.0,
						22.0
					],
					"text": "format -1"
				}
			},
			{
				"box": {
					"id": "obj-100",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1810.0,
						580.0,
						85.0,
						22.0
					],
					"text": "loadmess set"
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
						1926.0,
						580.0,
						209.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-102",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						1764.0,
						584.0,
						24.0,
						22.0
					],
					"text": "t b"
				}
			},
			{
				"box": {
					"id": "obj-103",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						1286.0,
						866.0,
						62.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "obj-104",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 4,
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"patching_rect": [
						1764.0,
						547.0,
						371.0,
						22.0
					],
					"text": "route device_added device_removed device_format"
				}
			},
			{
				"box": {
					"attr": "output_texture",
					"id": "obj-105",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1362.0,
						866.0,
						139.0,
						22.0
					],
					"text_width": 112.0
				}
			},
			{
				"box": {
					"attr": "format",
					"id": "obj-40",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1285.0,
						550.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-41",
					"items": "<empty>",
					"maxclass": "umenu",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"int",
						"",
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1285.0,
						523.0,
						180.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						474.3000002503395,
						149.5,
						180.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"YUY2 - 422YpCbCr8_yuvs - 144 x 144",
								"YUY2 - 422YpCbCr8_yuvs - 256 x 256",
								"YUY2 - 422YpCbCr8_yuvs - 512 x 256",
								"YUY2 - 422YpCbCr8_yuvs - 512 x 512",
								"YUY2 - 422YpCbCr8_yuvs - 1024 x 1024"
							],
							"parameter_longname": "umenu[2]",
							"parameter_mmax": 4,
							"parameter_modmode": 0,
							"parameter_shortname": "umenu[2]",
							"parameter_type": 2
						}
					},
					"varname": "umenu[2]"
				}
			},
			{
				"box": {
					"attr": "colormode",
					"id": "obj-106",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1362.0,
						898.0,
						139.0,
						22.0
					],
					"text_width": 87.0
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-107",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"clear",
						"clear"
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
							34.0,
							79.0,
							580.0,
							303.0
						],
						"gridsize": [
							15.0,
							15.0
						],
						"boxes": [
							{
								"box": {
									"id": "obj-4",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										386.0,
										131.5,
										91.0,
										22.0
									],
									"text": "loadmess clear"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 13.0,
									"id": "obj-21",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										132.5,
										27.0,
										23.0
									],
									"text": "iter"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 13.0,
									"id": "obj-23",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										"clear"
									],
									"patching_rect": [
										151.0,
										132.5,
										46.0,
										23.0
									],
									"text": "t clear"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 13.0,
									"id": "obj-24",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										"clear"
									],
									"patching_rect": [
										302.0,
										131.5,
										46.0,
										23.0
									],
									"text": "t clear"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 13.0,
									"id": "obj-27",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										201.0,
										155.5,
										107.0,
										23.0
									],
									"text": "prepend append"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 13.0,
									"id": "obj-28",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										201.0,
										132.5,
										27.0,
										23.0
									],
									"text": "iter"
								}
							},
							{
								"box": {
									"fontname": "Arial",
									"fontsize": 13.0,
									"id": "obj-32",
									"maxclass": "newobj",
									"numinlets": 1,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										155.5,
										107.0,
										23.0
									],
									"text": "prepend append"
								}
							},
							{
								"box": {
									"fontface": 0,
									"fontname": "Arial",
									"fontsize": 13.0,
									"id": "obj-33",
									"maxclass": "newobj",
									"numinlets": 3,
									"numoutlets": 3,
									"outlettype": [
										"",
										"",
										""
									],
									"patching_rect": [
										50.0,
										79.0,
										143.0,
										23.0
									],
									"text": "route vdevlist formatlist"
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-1",
									"index": 1,
									"maxclass": "inlet",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										50.0,
										40.0,
										25.0,
										25.0
									]
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-5",
									"index": 1,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										95.5,
										236.5,
										25.0,
										25.0
									]
								}
							},
							{
								"box": {
									"comment": "",
									"id": "obj-13",
									"index": 2,
									"maxclass": "outlet",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										246.5,
										236.5,
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
										"obj-33",
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
										"obj-32",
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
										"obj-5",
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
										"obj-13",
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
										"obj-13",
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
										"obj-27",
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
										"obj-5",
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
										"obj-21",
										0
									],
									"order": 1,
									"source": [
										"obj-33",
										0
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-23",
										0
									],
									"midpoints": [
										59.5,
										128.5,
										160.5,
										128.5
									],
									"order": 0,
									"source": [
										"obj-33",
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
									"midpoints": [
										121.5,
										124.5,
										311.5,
										124.5
									],
									"order": 0,
									"source": [
										"obj-33",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-28",
										0
									],
									"midpoints": [
										121.5,
										124.5,
										210.5,
										124.5
									],
									"order": 1,
									"source": [
										"obj-33",
										1
									]
								}
							},
							{
								"patchline": {
									"destination": [
										"obj-13",
										0
									],
									"order": 0,
									"source": [
										"obj-4",
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
									"order": 1,
									"source": [
										"obj-4",
										0
									]
								}
							}
						]
					},
					"patching_rect": [
						1477.0,
						523.0,
						205.0,
						23.0
					],
					"text": "p vdev/format"
				}
			},
			{
				"box": {
					"attr": "vdevice",
					"id": "obj-30",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1090.0,
						507.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-108",
					"items": "seancomm-x2 Camera",
					"maxclass": "umenu",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"int",
						"",
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						993.0,
						415.0,
						180.0,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						288.3000002503395,
						149.5,
						180.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"Ultraleap",
								"SIPPro9.7"
							],
							"parameter_longname": "umenu[1]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "umenu[1]",
							"parameter_type": 2
						}
					},
					"varname": "umenu[1]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-109",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1510.0,
						866.0,
						81.0,
						23.0
					],
					"presentation": 1,
					"presentation_rect": [
						470.9666337966919,
						121.09999519586563,
						81.0,
						23.0
					],
					"text": "getformatlist"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-110",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1286.0,
						898.0,
						72.0,
						23.0
					],
					"presentation": 1,
					"presentation_rect": [
						288.0666486620903,
						121.09999519586563,
						72.0,
						23.0
					],
					"text": "getvdevlist"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-111",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1226.0,
						876.0,
						42.0,
						23.0
					],
					"presentation": 1,
					"presentation_rect": [
						333.4666337966919,
						176.09999519586563,
						42.0,
						23.0
					],
					"text": "close"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-112",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1226.0,
						844.0,
						40.0,
						23.0
					],
					"presentation": 1,
					"presentation_rect": [
						288.6666331291199,
						176.09999519586563,
						40.0,
						23.0
					],
					"text": "open"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-113",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_gl_texture",
						""
					],
					"patching_rect": [
						1148.0,
						951.0,
						116.0,
						23.0
					],
					"text": "jit.grab @drawto foo"
				}
			},
			{
				"box": {
					"id": "obj-12",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1444.0,
						1374.0,
						150.0,
						20.0
					],
					"text": "enable x y 0 zx zy 0 0 0 r"
				}
			},
			{
				"box": {
					"id": "obj-39",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						31.0,
						381.0,
						78.0,
						22.0
					],
					"text": "r imageMove"
				}
			},
			{
				"box": {
					"id": "obj-38",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						176.0,
						533.0,
						55.0,
						22.0
					],
					"text": "zl slice 3"
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
						136.0,
						504.0,
						55.0,
						22.0
					],
					"text": "zl slice 3"
				}
			},
			{
				"box": {
					"id": "obj-36",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						66.0,
						504.0,
						55.0,
						22.0
					],
					"text": "zl slice 3"
				}
			},
			{
				"box": {
					"id": "obj-35",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						31.0,
						470.0,
						55.0,
						22.0
					],
					"text": "zl slice 1"
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
						27.0,
						568.0,
						92.0,
						22.0
					],
					"text": "prepend enable"
				}
			},
			{
				"box": {
					"id": "obj-32",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						66.0,
						535.0,
						97.0,
						22.0
					],
					"text": "prepend position"
				}
			},
			{
				"box": {
					"id": "obj-31",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						192.0,
						597.0,
						84.0,
						22.0
					],
					"text": "prepend scale"
				}
			},
			{
				"box": {
					"id": "obj-29",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						176.0,
						560.0,
						105.0,
						22.0
					],
					"text": "prepend rotatexyz"
				}
			},
			{
				"box": {
					"id": "obj-28",
					"maxclass": "newobj",
					"numinlets": 10,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1439.0,
						1396.0,
						161.0,
						22.0
					],
					"text": "pak 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-27",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1444.0,
						1429.0,
						80.0,
						22.0
					],
					"text": "s imageMove"
				}
			},
			{
				"box": {
					"attr": "blend",
					"id": "obj-6",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						27.0,
						715.0,
						210.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "blend_mode",
					"id": "obj-4",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						27.0,
						689.0,
						210.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "layer",
					"id": "obj-3",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						27.0,
						662.0,
						133.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						3.0,
						772.0,
						476.0,
						22.0
					],
					"text": "jit.gl.layer fb @layer 2 @enable 0 @shadow_caster 0 @two_sided 0 @auto_material 0 @automatic 1"
				}
			},
			{
				"box": {
					"id": "obj-21",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1148.0,
						922.0,
						82.0,
						22.0
					],
					"text": "exportattrs $1"
				}
			},
			{
				"box": {
					"attr": "interp",
					"id": "obj-169",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						27.0,
						635.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-34",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						606.0,
						934.0,
						82.0,
						22.0
					],
					"text": "s cameragrab"
				}
			},
			{
				"box": {
					"id": "obj-143",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						603.0,
						901.0,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-52",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						489.0,
						789.0,
						54.0,
						22.0
					],
					"text": "dict.print"
				}
			},
			{
				"box": {
					"hidden": 1,
					"id": "obj-20",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						652.0,
						681.0,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "obj-18",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						651.0,
						711.0,
						106.0,
						22.0
					],
					"text": "getsourcelistmenu"
				}
			},
			{
				"box": {
					"id": "obj-16",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						548.0,
						711.0,
						76.0,
						22.0
					],
					"text": "getsourcelist"
				}
			},
			{
				"box": {
					"id": "obj-58",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						""
					],
					"patching_rect": [
						489.0,
						759.0,
						174.0,
						22.0
					],
					"text": "route sourcelist sourcelistmenu"
				}
			},
			{
				"box": {
					"allowdrag": 0,
					"id": "obj-59",
					"items": "<empty>",
					"maxclass": "umenu",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"int",
						"",
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						995.0,
						456.0,
						179.5,
						22.0
					],
					"presentation": 1,
					"presentation_rect": [
						359.000116109848,
						264.0,
						200.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"LOCALHOST (Telestripe-1014)",
								"IPAD 1687 (NDI HX Camera)"
							],
							"parameter_longname": "umenu",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "umenu",
							"parameter_type": 2
						}
					},
					"varname": "umenu"
				}
			},
			{
				"box": {
					"id": "obj-1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"multichannelsignal",
						"jit_matrix",
						""
					],
					"patching_rect": [
						433.0,
						700.0,
						96.0,
						22.0
					],
					"text": "jit.ndi.receive~ 2"
				}
			},
			{
				"box": {
					"attr": "colormode",
					"id": "obj-45",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						506.0,
						635.0,
						233.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-47",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						548.0,
						678.0,
						75.0,
						22.0
					],
					"text": "summary $1"
				}
			},
			{
				"box": {
					"id": "obj-140",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						988.0,
						1295.0,
						117.0,
						22.0
					],
					"text": "ptz_recall_preset $1"
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
					"id": "obj-202",
					"ignoreclick": 1,
					"maxclass": "mira.frame",
					"numinlets": 0,
					"numoutlets": 0,
					"patching_rect": [
						987.0,
						97.0,
						548.5714423656464,
						390.0
					],
					"presentation": 1,
					"presentation_rect": [
						212.0,
						-6.0,
						714.268142383963,
						507.79999470710754
					],
					"tabname": "VidIn",
					"taborder": 3
				}
			},
			{
				"box": {
					"attr": "output_texture",
					"id": "obj-8",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						93.0,
						222.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "automatic",
					"id": "obj-199",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						256.0,
						690.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-209",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						156.0,
						743.0,
						51.0,
						22.0
					],
					"text": "draw $1"
				}
			},
			{
				"box": {
					"id": "obj-222",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						210.0,
						743.0,
						107.0,
						22.0
					],
					"text": "drawimmediate $1"
				}
			},
			{
				"box": {
					"id": "obj-242",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						320.0,
						743.0,
						71.0,
						22.0
					],
					"text": "drawraw $1"
				}
			},
			{
				"box": {
					"attr": "blend_enable",
					"id": "obj-318",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						18.0,
						604.0,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-recv-sticker-folder",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						50.0,
						10.0,
						170.0,
						22.0
					],
					"text": "receive feedbax_sticker_folder"
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"destination": [
						"obj-133",
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
						"obj-58",
						0
					],
					"midpoints": [
						519.5,
						735.3694527071075,
						498.5,
						735.3694527071075
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
						"obj-101",
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
						"obj-110",
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
						"obj-110",
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
						"obj-101",
						1
					],
					"source": [
						"obj-104",
						2
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
						"obj-104",
						1
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
						"obj-104",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-107",
						0
					],
					"midpoints": [
						2125.5,
						635.5,
						1486.5,
						635.5
					],
					"source": [
						"obj-104",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-113",
						0
					],
					"midpoints": [
						1371.5,
						942.75,
						1157.5,
						942.75
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
						"obj-113",
						0
					],
					"midpoints": [
						1371.5,
						943.25,
						1157.5,
						943.25
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
						"obj-108",
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
						"obj-41",
						0
					],
					"source": [
						"obj-107",
						1
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
					"midpoints": [
						1519.5,
						942.25,
						1157.5,
						942.25
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
						"obj-287",
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
						"obj-113",
						0
					],
					"midpoints": [
						1295.5,
						941.75,
						1157.5,
						941.75
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
						"obj-113",
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
						"obj-113",
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
						"obj-104",
						0
					],
					"midpoints": [
						1188.5,
						579.5000009536743,
						1758.5000627040863,
						579.5000009536743,
						1758.5000627040863,
						537.5000009536743,
						1773.5,
						537.5000009536743
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
						"obj-17",
						1
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
						"obj-59",
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
						"obj-13",
						1
					],
					"source": [
						"obj-115",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-90",
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
						"obj-89",
						0
					],
					"source": [
						"obj-118",
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
					"source": [
						"obj-119",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-160",
						0
					],
					"order": 1,
					"source": [
						"obj-120",
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
					"order": 2,
					"source": [
						"obj-120",
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
					"order": 0,
					"source": [
						"obj-120",
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
					"order": 2,
					"source": [
						"obj-121",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-263",
						0
					],
					"order": 0,
					"source": [
						"obj-121",
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
					"order": 1,
					"source": [
						"obj-121",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-116",
						0
					],
					"source": [
						"obj-123",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-116",
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
						"obj-123",
						0
					],
					"source": [
						"obj-126",
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
						"obj-127",
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
					"source": [
						"obj-13",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-143",
						1
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
						"obj-26",
						4
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
						"obj-26",
						2
					],
					"source": [
						"obj-135",
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
						"obj-138",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-138",
						1
					],
					"source": [
						"obj-139",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-138",
						0
					],
					"source": [
						"obj-139",
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
						"obj-14",
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
						"obj-14",
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
						"obj-140",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						3
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
						"obj-34",
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
						"obj-113",
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
						"obj-146",
						0
					],
					"source": [
						"obj-145",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-109",
						0
					],
					"order": 1,
					"source": [
						"obj-146",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-110",
						0
					],
					"order": 2,
					"source": [
						"obj-146",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-148",
						0
					],
					"order": 0,
					"source": [
						"obj-146",
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
					"source": [
						"obj-148",
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
						"obj-149",
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
						"obj-15",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-234",
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
						"obj-265",
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
						"obj-83",
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
						"obj-252",
						2
					],
					"source": [
						"obj-155",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-280",
						1
					],
					"source": [
						"obj-155",
						1
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
						"obj-156",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-166",
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
						"obj-179",
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
						"obj-1",
						0
					],
					"midpoints": [
						557.5,
						763.3694527071075,
						442.5,
						763.3694527071075
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
						"obj-43",
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
						"obj-159",
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
						"obj-161",
						0
					],
					"source": [
						"obj-165",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-176",
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
						"obj-2",
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
						"obj-188",
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
						"obj-1",
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
						"obj-173",
						0
					],
					"source": [
						"obj-172",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-173",
						1
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
						"obj-168",
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
						"obj-172",
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
					"source": [
						"obj-175",
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
					"source": [
						"obj-176",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-175",
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
						"obj-248",
						0
					],
					"source": [
						"obj-179",
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
						660.5,
						763.3694527071075,
						442.5,
						763.3694527071075
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
						"obj-143",
						0
					],
					"order": 0,
					"source": [
						"obj-180",
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
					"order": 2,
					"source": [
						"obj-180",
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
					"order": 1,
					"source": [
						"obj-180",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-270",
						0
					],
					"source": [
						"obj-181",
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
						"obj-182",
						0
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
						"obj-183",
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
						"obj-186",
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
						"obj-192",
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
						"obj-155",
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
						"obj-159",
						0
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
						"obj-198",
						0
					],
					"source": [
						"obj-195",
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
						"obj-196",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-317",
						0
					],
					"source": [
						"obj-197",
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
						"obj-198",
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
						"obj-199",
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
					"hidden": 1,
					"source": [
						"obj-20",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-271",
						0
					],
					"source": [
						"obj-200",
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
						"obj-201",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-196",
						0
					],
					"source": [
						"obj-203",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-155",
						0
					],
					"source": [
						"obj-204",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-201",
						0
					],
					"source": [
						"obj-207",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-207",
						0
					],
					"source": [
						"obj-208",
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
						"obj-209",
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
					"source": [
						"obj-21",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-272",
						0
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
						"obj-273",
						0
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
						"obj-274",
						0
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
						"obj-140",
						0
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
						"obj-140",
						0
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
						"obj-140",
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
						"obj-140",
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
						"obj-140",
						0
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
						"obj-140",
						0
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
						"obj-140",
						0
					],
					"source": [
						"obj-219",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-25",
						1
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
						"obj-140",
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
						"obj-275",
						0
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
						"obj-2",
						0
					],
					"source": [
						"obj-222",
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
						"obj-225",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-225",
						1
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
						"obj-225",
						2
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
						"obj-230",
						1
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
						"obj-129",
						0
					],
					"source": [
						"obj-230",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						5
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
						"obj-26",
						6
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
						"obj-13",
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
						"obj-121",
						0
					],
					"source": [
						"obj-240",
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
						"obj-242",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-97",
						0
					],
					"source": [
						"obj-243",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-150",
						0
					],
					"source": [
						"obj-244",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						1
					],
					"source": [
						"obj-249",
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
						"obj-25",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-48",
						1
					],
					"source": [
						"obj-250",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-153",
						1
					],
					"source": [
						"obj-251",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-263",
						1
					],
					"order": 1,
					"source": [
						"obj-252",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-264",
						1
					],
					"order": 0,
					"source": [
						"obj-252",
						0
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
						"obj-253",
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
						"obj-254",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-192",
						0
					],
					"source": [
						"obj-255",
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
						"obj-256",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-252",
						0
					],
					"source": [
						"obj-257",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-283",
						0
					],
					"source": [
						"obj-258",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-247",
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
						"obj-258",
						1
					],
					"source": [
						"obj-260",
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
						"obj-262",
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
						"obj-263",
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
						"obj-264",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-223",
						0
					],
					"source": [
						"obj-265",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-258",
						2
					],
					"source": [
						"obj-267",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-258",
						3
					],
					"source": [
						"obj-268",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-252",
						1
					],
					"source": [
						"obj-269",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						0
					],
					"source": [
						"obj-270",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						1
					],
					"source": [
						"obj-271",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						2
					],
					"source": [
						"obj-272",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						5
					],
					"source": [
						"obj-273",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						4
					],
					"source": [
						"obj-274",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						3
					],
					"source": [
						"obj-275",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-252",
						3
					],
					"source": [
						"obj-276",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-307",
						1
					],
					"source": [
						"obj-279",
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
						"obj-28",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-295",
						0
					],
					"source": [
						"obj-283",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						6
					],
					"source": [
						"obj-285",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						7
					],
					"source": [
						"obj-286",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-155",
						0
					],
					"source": [
						"obj-287",
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
						"obj-29",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-292",
						0
					],
					"source": [
						"obj-291",
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
						"obj-293",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						11
					],
					"source": [
						"obj-295",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						10
					],
					"source": [
						"obj-295",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						9
					],
					"source": [
						"obj-295",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-291",
						8
					],
					"source": [
						"obj-295",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-297",
						0
					],
					"source": [
						"obj-296",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-153",
						4
					],
					"source": [
						"obj-297",
						5
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-153",
						3
					],
					"source": [
						"obj-297",
						4
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-153",
						2
					],
					"source": [
						"obj-297",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						4
					],
					"source": [
						"obj-297",
						10
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						3
					],
					"source": [
						"obj-297",
						9
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						2
					],
					"source": [
						"obj-297",
						8
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						6
					],
					"source": [
						"obj-297",
						7
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-26",
						5
					],
					"source": [
						"obj-297",
						6
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-48",
						4
					],
					"source": [
						"obj-297",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-48",
						3
					],
					"source": [
						"obj-297",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-48",
						2
					],
					"source": [
						"obj-297",
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
						"obj-113",
						0
					],
					"midpoints": [
						1099.5,
						633.0,
						1232.0,
						633.0,
						1232.0,
						503.0,
						1157.5,
						503.0
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
						"obj-181",
						0
					],
					"order": 8,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-200",
						0
					],
					"order": 6,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-210",
						0
					],
					"order": 3,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-211",
						0
					],
					"order": 2,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-212",
						0
					],
					"order": 5,
					"source": [
						"obj-300",
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
					"order": 7,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-303",
						0
					],
					"order": 0,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-304",
						0
					],
					"order": 1,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-306",
						0
					],
					"order": 4,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-331",
						0
					],
					"order": 11,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-333",
						0
					],
					"order": 10,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-336",
						0
					],
					"order": 9,
					"source": [
						"obj-300",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-286",
						0
					],
					"source": [
						"obj-303",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-285",
						0
					],
					"source": [
						"obj-304",
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
						"obj-305",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-283",
						0
					],
					"source": [
						"obj-306",
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
						"obj-307",
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
						"obj-308",
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
						"obj-31",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-109",
						0
					],
					"order": 0,
					"source": [
						"obj-310",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-110",
						0
					],
					"order": 1,
					"source": [
						"obj-310",
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
					"source": [
						"obj-314",
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
					"source": [
						"obj-315",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-307",
						0
					],
					"source": [
						"obj-316",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-193",
						0
					],
					"source": [
						"obj-317",
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
						"obj-318",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-317",
						0
					],
					"source": [
						"obj-319",
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
						"obj-32",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-317",
						1
					],
					"order": 1,
					"source": [
						"obj-322",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-335",
						1
					],
					"order": 0,
					"source": [
						"obj-322",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-317",
						2
					],
					"source": [
						"obj-325",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-317",
						3
					],
					"source": [
						"obj-326",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-322",
						0
					],
					"source": [
						"obj-331",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-325",
						0
					],
					"source": [
						"obj-333",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-326",
						0
					],
					"source": [
						"obj-336",
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
					"order": 0,
					"source": [
						"obj-35",
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
					"order": 1,
					"source": [
						"obj-35",
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
						"obj-35",
						1
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
						"obj-36",
						0
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
						"obj-36",
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
						"obj-37",
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
						"obj-37",
						1
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
						"obj-38",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-201",
						1
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
						"obj-2",
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
						"obj-113",
						0
					],
					"midpoints": [
						1294.5,
						544.0,
						1233.5,
						544.0,
						1233.5,
						530.5,
						1157.5,
						530.5
					],
					"source": [
						"obj-40",
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
						"obj-41",
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
						"obj-45",
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
						"obj-47",
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
						"obj-48",
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
					"order": 1,
					"source": [
						"obj-49",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-73",
						0
					],
					"order": 0,
					"source": [
						"obj-49",
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
					"order": 1,
					"source": [
						"obj-51",
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
						"obj-51",
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
						"obj-53",
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
						"obj-54",
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
						"obj-54",
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
						"obj-55",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-66",
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
						"obj-52",
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
						"obj-59",
						0
					],
					"source": [
						"obj-58",
						1
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
						1084.75,
						765.3694527071075,
						689.0,
						765.3694527071075,
						689.0,
						740.3694527071075,
						442.5,
						740.3694527071075
					],
					"source": [
						"obj-59",
						1
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
						"obj-6",
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
						"obj-60",
						2
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-135",
						0
					],
					"source": [
						"obj-60",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-142",
						0
					],
					"source": [
						"obj-60",
						1
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
						"obj-61",
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
						"obj-76",
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
						"obj-82",
						1
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
						"obj-182",
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
						"obj-61",
						0
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
						"obj-61",
						0
					],
					"source": [
						"obj-66",
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
						"obj-67",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-57",
						0
					],
					"order": 1,
					"source": [
						"obj-70",
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
						"obj-70",
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
					"order": 1,
					"source": [
						"obj-74",
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
					"order": 0,
					"source": [
						"obj-74",
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
						"obj-75",
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
						"obj-76",
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
						"obj-78",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-61",
						0
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
						"obj-49",
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
						"obj-114",
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
						"obj-91",
						0
					],
					"source": [
						"obj-81",
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
						"obj-84",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-92",
						1
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
						"obj-118",
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
						"obj-139",
						0
					],
					"order": 1,
					"source": [
						"obj-87",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-92",
						0
					],
					"order": 0,
					"source": [
						"obj-87",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-116",
						0
					],
					"midpoints": [
						1955.5,
						957.6110979914665,
						2090.5,
						957.6110979914665
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
						"obj-116",
						0
					],
					"midpoints": [
						2097.5,
						957.6110979914665,
						2090.5,
						957.6110979914665
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
						"obj-155",
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
						"obj-116",
						0
					],
					"midpoints": [
						2201.5,
						957.6110979914665,
						2090.5,
						957.6110979914665
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
						"obj-88",
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
						"obj-2",
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
						"obj-18",
						0
					],
					"order": 1,
					"source": [
						"obj-93",
						1
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
						"obj-93",
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
					"order": 0,
					"source": [
						"obj-93",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-116",
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
						"obj-26",
						0
					],
					"order": 1,
					"source": [
						"obj-97",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-264",
						0
					],
					"order": 0,
					"source": [
						"obj-97",
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
					"midpoints": [
						1540.5,
						942.75,
						1157.5,
						942.75
					],
					"source": [
						"obj-99",
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
						"obj-recv-sticker-folder",
						0
					]
				}
			}
		],
		"boxgroups": [
			{
				"boxes": [
					"obj-65",
					"obj-57",
					"obj-61"
				]
			},
			{
				"boxes": [
					"obj-87",
					"obj-42"
				]
			},
			{
				"boxes": [
					"obj-184",
					"obj-180"
				]
			},
			{
				"boxes": [
					"obj-126",
					"obj-151"
				]
			},
			{
				"boxes": [
					"obj-127",
					"obj-163"
				]
			},
			{
				"boxes": [
					"obj-119",
					"obj-177"
				]
			},
			{
				"boxes": [
					"obj-235",
					"obj-236",
					"obj-241",
					"obj-134",
					"obj-135",
					"obj-142",
					"obj-237",
					"obj-232",
					"obj-238",
					"obj-233",
					"obj-239",
					"obj-26",
					"obj-60",
					"obj-76",
					"obj-82",
					"obj-55",
					"obj-132",
					"obj-131",
					"obj-130",
					"obj-62"
				]
			},
			{
				"boxes": [
					"obj-74",
					"obj-24",
					"obj-15",
					"obj-13",
					"obj-115",
					"obj-21",
					"obj-113",
					"obj-17",
					"obj-144",
					"obj-112",
					"obj-111",
					"obj-103",
					"obj-110",
					"obj-105",
					"obj-106",
					"obj-109",
					"obj-99"
				]
			},
			{
				"boxes": [
					"obj-213",
					"obj-224",
					"obj-214",
					"obj-140",
					"obj-215",
					"obj-226",
					"obj-228",
					"obj-216",
					"obj-227",
					"obj-217",
					"obj-229",
					"obj-218",
					"obj-225",
					"obj-219",
					"obj-231",
					"obj-230",
					"obj-129",
					"obj-220"
				]
			},
			{
				"boxes": [
					"obj-158",
					"obj-178",
					"obj-166",
					"obj-176",
					"obj-175",
					"obj-174",
					"obj-172",
					"obj-173",
					"obj-168"
				]
			},
			{
				"boxes": [
					"obj-277",
					"obj-181",
					"obj-221",
					"obj-270",
					"obj-271",
					"obj-281",
					"obj-278",
					"obj-272",
					"obj-273",
					"obj-274",
					"obj-275",
					"obj-200",
					"obj-212",
					"obj-282",
					"obj-283",
					"obj-284",
					"obj-306",
					"obj-300",
					"obj-302",
					"obj-210",
					"obj-211",
					"obj-288",
					"obj-289",
					"obj-304",
					"obj-303",
					"obj-285",
					"obj-286",
					"obj-295",
					"obj-290",
					"obj-291",
					"obj-292"
				]
			},
			{
				"boxes": [
					"obj-162",
					"obj-160"
				]
			},
			{
				"boxes": [
					"obj-185",
					"obj-108",
					"obj-310",
					"obj-312",
					"obj-314",
					"obj-315"
				]
			},
			{
				"boxes": [
					"obj-98",
					"obj-59",
					"obj-75",
					"obj-96",
					"obj-203",
					"obj-245"
				]
			},
			{
				"boxes": [
					"obj-125",
					"obj-94",
					"obj-11",
					"obj-67"
				]
			},
			{
				"boxes": [
					"obj-328",
					"obj-329",
					"obj-330",
					"obj-326",
					"obj-325",
					"obj-322"
				]
			}
		]
	}
}