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
			112.0,
			190.0,
			968.0,
			797.0
		],
		"gridsize": [
			15.0,
			15.0
		],
		"boxes": [
			{
				"box": {
					"id": "obj-94",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1032.0,
						1271.0,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-345",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						198.9361687898636,
						59.57446765899658,
						150.0,
						20.0
					],
					"text": "Wordlbump"
				}
			},
			{
				"box": {
					"id": "obj-342",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1706.6711573873977,
						1942.4255180358887,
						72.34042608737946,
						20.0
					],
					"text": "worldbump"
				}
			},
			{
				"box": {
					"id": "obj-339",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1679.7820938691088,
						1940.4255180358887,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[15]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[15]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[15]"
				}
			},
			{
				"box": {
					"id": "obj-331",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1550.0857460970701,
						2100.1063680648804,
						90.0,
						22.0
					],
					"text": "s wordBumpEn"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-319",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						258.6404406580391,
						703.8000231385231,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[170]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[170]",
							"parameter_type": 3
						}
					},
					"varname": "number[13]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-320",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						199.6404406580391,
						703.8000231385231,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[21]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[21]",
							"parameter_type": 3
						}
					},
					"varname": "number[21]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-321",
					"maxclass": "flonum",
					"maximum": 0.2,
					"minimum": 0.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						243.8904406580391,
						651.9000023007393,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "number[53]",
							"parameter_mmax": 0.2,
							"parameter_modmode": 0,
							"parameter_shortname": "number[53]",
							"parameter_type": 0
						}
					},
					"varname": "number[23]"
				}
			},
			{
				"box": {
					"id": "obj-322",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						148.89044059843445,
						677.6000232100487,
						100.0,
						22.0
					],
					"text": "scale 0 0.3 0. 0.1"
				}
			},
			{
				"box": {
					"id": "obj-325",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						186.6404406580391,
						735.0,
						63.0,
						22.0
					],
					"text": "slide 8. 12"
				}
			},
			{
				"box": {
					"id": "obj-330",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						148.89044059843445,
						638.0,
						76.0,
						22.0
					],
					"text": "r worldBump"
				}
			},
			{
				"box": {
					"id": "obj-318",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						230.56170815229416,
						593.759450891655,
						78.0,
						22.0
					],
					"text": "s worldBump"
				}
			},
			{
				"box": {
					"id": "obj-287",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						138.36170184612274,
						96.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[14]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[14]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[14]"
				}
			},
			{
				"box": {
					"id": "obj-229",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1590.0857460970701,
						1854.5532014429778,
						80.0,
						22.0
					],
					"text": "loadmess 0.8"
				}
			},
			{
				"box": {
					"id": "obj-228",
					"linecount": 3,
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2398.3617018461227,
						1748.0,
						41.0,
						49.0
					],
					"text": "loadmess 0.8"
				}
			},
			{
				"box": {
					"id": "obj-190",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1906.8063588730104,
						1865.1733979173018,
						42.0,
						20.0
					],
					"text": "alpha"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-215",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1916.1791037176147,
						1795.4749246348592,
						23.25451031079092,
						66.00000000000045
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[19]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider[17]",
							"parameter_type": 0
						}
					},
					"size": 1.0,
					"varname": "slider[4]"
				}
			},
			{
				"box": {
					"id": "obj-64",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1524.9124486854107,
						1892.5200749784708,
						85.0,
						22.0
					],
					"text": "prepend alpha"
				}
			},
			{
				"box": {
					"id": "obj-374",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2144.703199118376,
						1962.4750248607788,
						150.0,
						20.0
					],
					"text": "wave ab"
				}
			},
			{
				"box": {
					"id": "obj-372",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						2118.703199118376,
						1960.4750248607788,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[56]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[56]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[13]"
				}
			},
			{
				"box": {
					"id": "obj-370",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2137.3617018461227,
						2082.0,
						76.0,
						22.0
					],
					"text": "s wavebump"
				}
			},
			{
				"box": {
					"id": "obj-369",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						"float"
					],
					"patching_rect": [
						2297.9051259035887,
						2029.1558756050263,
						29.5,
						22.0
					],
					"text": "t b f"
				}
			},
			{
				"box": {
					"id": "obj-368",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						2297.9051259035887,
						2071.7914781090412,
						39.07446801662445,
						22.0
					],
					"text": "+ 0."
				}
			},
			{
				"box": {
					"id": "obj-367",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						358.36170184612274,
						585.0,
						29.5,
						22.0
					],
					"text": "+ 0."
				}
			},
			{
				"box": {
					"id": "obj-366",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2312.37234044075,
						1992.416429929151,
						89.0,
						22.0
					],
					"text": "r wavebumpsig"
				}
			},
			{
				"box": {
					"id": "obj-357",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						345.36170184612274,
						403.1898846503432,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[55]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[50]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[12]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-359",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						458.9595729112625,
						468.75944713656236,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[169]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[69]",
							"parameter_type": 3
						}
					},
					"varname": "number[22]"
				}
			},
			{
				"box": {
					"id": "obj-360",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						407.56170815229416,
						517.7898886080916,
						40.0,
						22.0
					],
					"text": "*~ 2.2"
				}
			},
			{
				"box": {
					"id": "obj-361",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						358.36170184612274,
						637.7474299760265,
						91.0,
						22.0
					],
					"text": "s wavebumpsig"
				}
			},
			{
				"box": {
					"id": "obj-362",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						345.36170184612274,
						507.45181149380824,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-363",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						358.7617091536522,
						441.4920808213358,
						74.0,
						22.0
					],
					"text": "r wavebump"
				}
			},
			{
				"box": {
					"id": "obj-364",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						364.56170904636383,
						474.70438998164104,
						72.0,
						22.0
					],
					"text": "r audiobang"
				}
			},
			{
				"box": {
					"id": "obj-365",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						361.2617091536522,
						544.3592796034486,
						35.0,
						22.0
					],
					"text": "avg~"
				}
			},
			{
				"box": {
					"id": "obj-344",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						549.3617018461227,
						486.0,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[50]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[50]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[9]"
				}
			},
			{
				"box": {
					"id": "obj-340",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2206.8617018461227,
						1861.9828541356185,
						42.0,
						20.0
					],
					"text": "alpha"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-338",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						2216.234446690727,
						1792.284380853176,
						23.25451031079092,
						66.00000000000045
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[18]",
							"parameter_mmax": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider[17]",
							"parameter_type": 0
						}
					},
					"size": 1.0,
					"varname": "slider[3]"
				}
			},
			{
				"box": {
					"id": "obj-337",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2297.9051259035887,
						2099.507788806747,
						85.0,
						22.0
					],
					"text": "prepend alpha"
				}
			},
			{
				"box": {
					"attr": "gl_color",
					"id": "obj-333",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1567.261587785763,
						1003.4042629999999,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-332",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2059.905830261092,
						1962.4750248607788,
						48.0,
						20.0
					],
					"text": "Radius"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-329",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						2071.586834973553,
						1886.6750346836243,
						24.63799057507822,
						71.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[2]",
							"parameter_mmax": 4.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider[2]",
							"parameter_type": 0
						}
					},
					"size": 4.0,
					"varname": "slider[2]"
				}
			},
			{
				"box": {
					"id": "obj-328",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1478.2095908522606,
						1155.4000095129013,
						83.0,
						22.0
					],
					"text": "r wave2cmdG"
				}
			},
			{
				"box": {
					"id": "obj-327",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2247.1529277563095,
						2173.0,
						85.0,
						22.0
					],
					"text": "s wave2cmdG"
				}
			},
			{
				"box": {
					"id": "obj-326",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2113.3031991422176,
						1929.9228226465125,
						40.39999836683273,
						20.0
					],
					"text": "Thic"
				}
			},
			{
				"box": {
					"id": "obj-324",
					"maxclass": "number",
					"maximum": 24,
					"minimum": 1,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						2144.703199118376,
						1929.9228226465125,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[167]",
							"parameter_mmax": 24.0,
							"parameter_mmin": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[167]",
							"parameter_type": 3
						}
					},
					"varname": "number[47]"
				}
			},
			{
				"box": {
					"id": "obj-323",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2247.1529277563095,
						2146.3668335676193,
						109.0,
						22.0
					],
					"text": "prepend line_width"
				}
			},
			{
				"box": {
					"id": "obj-317",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1712.9595901370049,
						619.0,
						73.0,
						22.0
					],
					"text": "r wave2cmd"
				}
			},
			{
				"box": {
					"id": "obj-316",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2268.6595903635025,
						1954.3333507180214,
						75.0,
						22.0
					],
					"text": "s wave2cmd"
				}
			},
			{
				"box": {
					"id": "obj-315",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2116.703199118376,
						1917.6750346836243,
						150.0,
						20.0
					],
					"text": "Downsample"
				}
			},
			{
				"box": {
					"id": "obj-313",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						2116.703199118376,
						1886.6750346836243,
						89.01278203725815,
						29.0
					],
					"relative": 1,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[1]",
							"parameter_mmax": 1023.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider[1]",
							"parameter_type": 0
						}
					},
					"size": 1024.0,
					"varname": "slider[1]"
				}
			},
			{
				"box": {
					"id": "obj-312",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1685.3617018461227,
						1427.0,
						53.0,
						22.0
					],
					"text": "s uiGain"
				}
			},
			{
				"box": {
					"floatoutput": 1,
					"id": "obj-311",
					"maxclass": "slider",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 1,
					"patching_rect": [
						1963.2344466907273,
						1788.5,
						23.25451031079092,
						110.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "slider[17]",
							"parameter_mmax": 2.0,
							"parameter_modmode": 0,
							"parameter_shortname": "slider[17]",
							"parameter_type": 0
						}
					},
					"size": 2.0,
					"varname": "slider"
				}
			},
			{
				"box": {
					"id": "obj-309",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1936.3617018461227,
						1757.0,
						77.0,
						20.0
					],
					"presentation": 1,
					"presentation_rect": [
						923.5,
						127.40000230073929,
						93.0,
						20.0
					],
					"text": "Audio Gain"
				}
			},
			{
				"box": {
					"id": "obj-310",
					"maxclass": "meter~",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1992.8617017269135,
						1788.5,
						14.0,
						104.0
					],
					"presentation": 1,
					"presentation_rect": [
						979.4999999403954,
						151.9000023007393,
						14.0,
						104.0
					]
				}
			},
			{
				"box": {
					"attr": "tap_enabled",
					"id": "obj-292",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1766.905126076017,
						1357.8269380625,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "pinch_enabled",
					"id": "obj-304",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1766.905126076017,
						1381.8269380625,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "rotate_enabled",
					"id": "obj-306",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1766.905126076017,
						1405.8269380625,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "swipe_enabled",
					"id": "obj-308",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1766.9051259035887,
						1429.8269380625,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-233",
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
						1311.5291380097897,
						1733.2119140625,
						59.0,
						22.0
					],
					"text": "p xypinch"
				}
			},
			{
				"box": {
					"id": "obj-240",
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
						1167.029114386482,
						1733.3285849243402,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-242",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1167.029114386482,
						1764.0452485978603,
						29.5,
						22.0
					],
					"text": "f"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-251",
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
						1423.9826800163,
						1733.8269380625,
						211.0,
						22.0
					],
					"text": "mira.mt.centroid"
				}
			},
			{
				"box": {
					"id": "obj-261",
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
						1409.442160289529,
						1817.5452503561974,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-266",
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
						1518.9124486854107,
						1814.2843808531761,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-267",
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
						1278.534550130374,
						1795.4749246348592,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-268",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1530.9826772148817,
						1774.8269380624997,
						104.0,
						22.0
					],
					"text": "scale 0. 1. -90. 90"
				}
			},
			{
				"box": {
					"id": "obj-269",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1401.9939820097898,
						1774.8269380624997,
						104.0,
						22.0
					],
					"text": "scale 0. 1. -90 90."
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
					"id": "obj-270",
					"maxclass": "mira.multitouch",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1706.6711573873977,
						1520.8269381821156,
						298.3406677246094,
						218.03662449121475
					],
					"pinch_enabled": 1,
					"presentation": 1,
					"presentation_rect": [
						1509.053685831529,
						1378.8269381821156,
						231.34066772460938,
						168.03662449121475
					],
					"rotate_enabled": 1,
					"swipe_enabled": 0,
					"swipe_touch_count": 0,
					"tap_enabled": 0,
					"tap_tap_count": 0,
					"tap_touch_count": 0
				}
			},
			{
				"box": {
					"id": "obj-231",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1727.2914929986,
						1883.541845548111,
						45.0,
						22.0
					],
					"text": "s hue1"
				}
			},
			{
				"box": {
					"id": "obj-232",
					"maxclass": "swatch",
					"numinlets": 3,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1727.2914929986,
						1762.0,
						182.16666996479034,
						118.55320144297775
					],
					"presentation": 1,
					"presentation_rect": [
						1735.9297911524773,
						1285.0,
						120.16666972637177,
						63.36995458602905
					],
					"saturation": 1.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "swatch[7]",
							"parameter_modmode": 0,
							"parameter_shortname": "swatch",
							"parameter_type": 3
						}
					},
					"varname": "swatch[3]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-216",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1665.7545371527494,
						2131.933350622654,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[13]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[8]",
							"parameter_type": 3
						}
					},
					"varname": "number[20]"
				}
			},
			{
				"box": {
					"id": "obj-181",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						2023.2914929986,
						1879.541845548111,
						45.0,
						22.0
					],
					"text": "s hue2"
				}
			},
			{
				"box": {
					"id": "obj-189",
					"maxclass": "swatch",
					"numinlets": 3,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						2023.2914929986,
						1758.0,
						182.16666996479034,
						118.55320144297775
					],
					"presentation": 1,
					"presentation_rect": [
						2073.059538602829,
						1537.1787326335907,
						120.16666972637177,
						63.36995458602905
					],
					"saturation": 1.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "swatch[6]",
							"parameter_modmode": 0,
							"parameter_shortname": "swatch",
							"parameter_type": 3
						}
					},
					"varname": "swatch[2]"
				}
			},
			{
				"box": {
					"id": "obj-68",
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
						1791.84151487301,
						2013.2119140625,
						59.0,
						22.0
					],
					"text": "p xypinch"
				}
			},
			{
				"box": {
					"id": "obj-69",
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
						1647.3414912497024,
						2013.3285849243402,
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
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						1647.3414912497024,
						2044.0452485978603,
						29.5,
						22.0
					],
					"text": "f"
				}
			},
			{
				"box": {
					"attr": "tap_enabled",
					"id": "obj-89",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						2230.905126076017,
						1340.8269380625,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-90",
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
						1904.2950568795204,
						2013.8269380625,
						211.0,
						22.0
					],
					"text": "mira.mt.centroid"
				}
			},
			{
				"box": {
					"id": "obj-91",
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
						1889.7545371527494,
						2097.5452503561974,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-132",
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
						1999.224825548631,
						2094.284380853176,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-149",
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
						1758.8469269935945,
						2075.4749246348592,
						97.0,
						22.0
					],
					"text": "p mIniCtlSmooth"
				}
			},
			{
				"box": {
					"id": "obj-150",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2011.295054078102,
						2054.8269380624997,
						107.0,
						22.0
					],
					"text": "scale 0. 1. 2.5 -2.5"
				}
			},
			{
				"box": {
					"id": "obj-151",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1882.3063588730101,
						2054.8269380624997,
						94.0,
						22.0
					],
					"text": "scale 0. 1. -4. 4."
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
					"id": "obj-152",
					"maxclass": "mira.multitouch",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2016.4153876776518,
						1520.8269381821156,
						298.3406677246094,
						218.03662449121475
					],
					"pinch_enabled": 1,
					"presentation": 1,
					"presentation_rect": [
						577.7509961724281,
						420.7633735537529,
						231.34066772460938,
						168.03662449121475
					],
					"rotate_enabled": 1,
					"swipe_enabled": 0,
					"swipe_touch_count": 0,
					"tap_enabled": 0,
					"tap_tap_count": 0,
					"tap_touch_count": 0
				}
			},
			{
				"box": {
					"attr": "pinch_enabled",
					"id": "obj-153",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						2230.905126076017,
						1364.8269380625,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "rotate_enabled",
					"id": "obj-158",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						2230.905126076017,
						1388.8269380625,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "swipe_enabled",
					"id": "obj-163",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						2230.9051259035887,
						1412.8269380625,
						150.0,
						22.0
					]
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
						1103.3617335557938,
						1342.0000399947166,
						149.33333629369736,
						22.0
					],
					"text": "0. 0.786722 0.821229 1."
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
						1690.361684024334,
						964.0000084638596,
						124.0,
						22.0
					],
					"text": "loadmess circpoints 1"
				}
			},
			{
				"box": {
					"id": "obj-188",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1055.710682347721,
						758.2021991869874,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-185",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						106.6638315320015,
						901.4898900266821,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-184",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						958.3617018461227,
						1403.0,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "obj-183",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						835.6744679808617,
						1462.2731068088806,
						173.84898050159836,
						22.0
					],
					"text": "0.392375 0.23808 0. 1."
				}
			},
			{
				"box": {
					"id": "obj-182",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1027.3691829817028,
						1462.2731068088806,
						139.0,
						22.0
					],
					"text": "0. 0.786722 0.821229 1."
				}
			},
			{
				"box": {
					"id": "obj-170",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1245.710682347721,
						878.2000098228455,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-169",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1225.1617198586464,
						1023.2000098228455,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"id": "obj-166",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						2125.161718785763,
						1118.522813014402,
						58.0,
						22.0
					],
					"text": "loadbang"
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
						2119.361732840538,
						1155.4000095129013,
						87.0,
						22.0
					],
					"text": "poly_mode 0 0"
				}
			},
			{
				"box": {
					"id": "obj-162",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2119.361732840538,
						895.0,
						70.0,
						22.0
					],
					"text": "loadmess 0"
				}
			},
			{
				"box": {
					"id": "obj-133",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1702.659589290619,
						476.60219558686686,
						70.0,
						22.0
					],
					"text": "loadmess 2"
				}
			},
			{
				"box": {
					"fontsize": 18.0,
					"id": "obj-134",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1706.4595901370049,
						513.8793983200121,
						59.0,
						29.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[159]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[122]",
							"parameter_type": 3
						}
					},
					"varname": "number[46]"
				}
			},
			{
				"box": {
					"id": "obj-142",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1706.4595901370049,
						551.1377142590418,
						86.0,
						22.0
					],
					"text": "prepend mode"
				}
			},
			{
				"box": {
					"id": "obj-131",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						1752.0857215399565,
						2121.6666588187218,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "obj-130",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1407.999692421201,
						2140.770921289921,
						77.0,
						22.0
					],
					"text": "loadmess 30"
				}
			},
			{
				"box": {
					"id": "obj-129",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1299.6857409353079,
						2146.770921289921,
						77.0,
						22.0
					],
					"text": "loadmess 20"
				}
			},
			{
				"box": {
					"id": "obj-127",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1137.3524061317266,
						1999.2105353551965,
						80.0,
						22.0
					],
					"text": "loadmess 0.7"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-307",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1185.3524061317266,
						2131.933350622654,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[45]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[45]",
							"parameter_type": 3
						}
					},
					"varname": "number[45]"
				}
			},
			{
				"box": {
					"id": "obj-305",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1175.0,
						2187.0,
						107.0,
						22.0
					],
					"text": "pak radialradius 1."
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-300",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1880.9985051626982,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[156]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[42]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-301",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1824.9985043282331,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[157]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[43]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-302",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1769.0857488984884,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[158]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[44]"
				}
			},
			{
				"box": {
					"id": "obj-303",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1747.4857485766233,
						2219.266683459282,
						99.0,
						22.0
					],
					"text": "pak scale 1. 1. 1."
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-296",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1701.9985023612799,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[127]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[39]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-297",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1645.9985015268148,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[96]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[40]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-298",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1590.0857460970701,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[100]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[41]"
				}
			},
			{
				"box": {
					"id": "obj-299",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1568.485745775205,
						2219.266683459282,
						117.0,
						22.0
					],
					"text": "pak position 0. 0. -2."
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-295",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1518.9124486854107,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[116]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[31]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-294",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1462.9124478509457,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[126]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[19]"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-293",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1406.999692421201,
						2178.4666828513145,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[125]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[125]",
							"parameter_type": 3
						}
					},
					"varname": "number[1]"
				}
			},
			{
				"box": {
					"id": "obj-291",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1385.3996920993359,
						2219.266683459282,
						120.0,
						22.0
					],
					"text": "pak rotatexyz 0. 0. 0."
				}
			},
			{
				"box": {
					"id": "obj-289",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						748.1617124080658,
						352.8000048995018,
						32.700000047683716,
						20.0
					],
					"text": "out"
				}
			},
			{
				"box": {
					"id": "obj-288",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						219.49044080109024,
						75.89839397632431,
						18.79999804496765,
						20.0
					],
					"text": "in"
				}
			},
			{
				"box": {
					"id": "obj-286",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						209.8904406580391,
						100.89839397632431,
						29.5,
						22.0
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "obj-285",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						209.8904406580391,
						143.008515894413,
						29.5,
						22.0
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"id": "obj-284",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						179.16170233488083,
						262.40000289678574,
						105.99999934434891,
						20.0
					],
					"text": "average samples"
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
						146.5617015361786,
						335.68988077604126,
						90.0,
						22.0
					],
					"text": "loadmess 2500"
				}
			},
			{
				"box": {
					"id": "obj-245",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						87.7617017030716,
						307.4000043272972,
						90.0,
						22.0
					],
					"text": "loadmess 2500"
				}
			},
			{
				"box": {
					"id": "obj-103",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						205.16170167922974,
						361.8898837443526,
						87.0,
						22.0
					],
					"text": "loadmess 0.05"
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
						120.06170153617859,
						542.5594440490418,
						29.5,
						22.0
					],
					"text": "0,"
				}
			},
			{
				"box": {
					"id": "obj-246",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"bang",
						""
					],
					"patching_rect": [
						55.16169863939285,
						223.62680963978528,
						34.0,
						22.0
					],
					"text": "sel 0"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-247",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						205.16170167922974,
						390.40000224113464,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[35]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[35]",
							"parameter_type": 3
						}
					},
					"varname": "number[35]"
				}
			},
			{
				"box": {
					"id": "obj-248",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						158.0617015361786,
						542.5594440490418,
						33.0,
						22.0
					],
					"text": "* 0.8"
				}
			},
			{
				"box": {
					"id": "obj-249",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						130.46170124411583,
						260.40000289678574,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[153]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[153]",
							"parameter_type": 3
						}
					},
					"varname": "number[36]"
				}
			},
			{
				"box": {
					"id": "obj-250",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						23.061701893806458,
						290.6000040769577,
						58.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-252",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						27.46170151233673,
						364.2000043988228,
						31.0,
						23.0
					],
					"text": "rms"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-253",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						23.061701893806458,
						259.40000289678574,
						49.0,
						23.0
					],
					"text": "bipolar"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-254",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						23.061701893806458,
						319.2000043988228,
						59.0,
						23.0
					],
					"text": "absolute"
				}
			},
			{
				"box": {
					"id": "obj-255",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						111.06170153617859,
						509.97576969008423,
						64.0,
						22.0
					],
					"text": "snapshot~"
				}
			},
			{
				"box": {
					"id": "obj-256",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						87.46170145273209,
						468.75944713656236,
						59.0,
						22.0
					],
					"text": "average~"
				}
			},
			{
				"box": {
					"id": "obj-257",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						146.5617015361786,
						390.40000224113464,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[154]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[154]",
							"parameter_type": 3
						}
					},
					"varname": "number[37]"
				}
			},
			{
				"box": {
					"id": "obj-258",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						91.56170153617859,
						390.40000224113464,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[155]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[155]",
							"parameter_type": 3
						}
					},
					"varname": "number[38]"
				}
			},
			{
				"box": {
					"id": "obj-259",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						292.76170229911804,
						373.4000062942505,
						35.0,
						22.0
					],
					"text": "abs~"
				}
			},
			{
				"box": {
					"id": "obj-260",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						120.06170153617859,
						436.80000162124634,
						78.0,
						22.0
					],
					"text": "slide~"
				}
			},
			{
				"box": {
					"id": "obj-262",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						87.46170145273209,
						593.759450891655,
						107.0,
						22.0
					],
					"text": "s kittybumpsignal1"
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
						100.56170153617859,
						223.62680963978528,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-264",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						50.56170153617859,
						180.60000032186508,
						88.0,
						22.0
					],
					"text": "r wordBumpEn"
				}
			},
			{
				"box": {
					"id": "obj-265",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						158.0617015361786,
						180.60000032186508,
						59.0,
						22.0
					],
					"text": "r ctrlbang"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-272",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						350.4595729112625,
						122.5810381647284,
						73.0,
						22.0
					],
					"text": "gainmode 1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-273",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						625.4595729112625,
						129.68988101445984,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-274",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						545.4595729112625,
						129.68988101445984,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-275",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						450.4595729112625,
						129.68988101445984,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-276",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						625.4595729112625,
						165.18988101445984,
						55.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[150]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[38]",
							"parameter_type": 3
						}
					},
					"varname": "number[32]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-277",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						545.4595729112625,
						165.18988101445984,
						55.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[151]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[37]",
							"parameter_type": 3
						}
					},
					"varname": "number[33]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-278",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						455.4595729112625,
						165.18988101445984,
						57.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[152]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[36]",
							"parameter_type": 3
						}
					},
					"varname": "number[34]"
				}
			},
			{
				"box": {
					"autoout": 1,
					"bgcolor": [
						0.913725,
						0.913725,
						1.0,
						1.0
					],
					"curvecolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"domain": [
						0.0,
						22050.0
					],
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"hcurvecolor": [
						1.0,
						0.086275,
						0.086275,
						1.0
					],
					"id": "obj-279",
					"linmarkers": [
						0.0,
						11025.0,
						16537.5
					],
					"logmarkers": [
						0.0,
						100.0,
						1000.0,
						10000.0
					],
					"markercolor": [
						0.509804,
						0.509804,
						0.509804,
						1.0
					],
					"maxclass": "filtergraph~",
					"nfilters": 1,
					"numinlets": 8,
					"numoutlets": 7,
					"outlettype": [
						"list",
						"float",
						"float",
						"float",
						"float",
						"list",
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						332.37446665763855,
						222.68988101445984,
						246.5,
						94.0
					],
					"setfilter": [
						0,
						1,
						1,
						0,
						0,
						144.31146240234375,
						1.766406178474426,
						0.70710676908493,
						9.9999997474e-05,
						22050.0,
						9.9999997474e-05,
						16.0,
						0.5,
						25.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-280",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						298.5617029070854,
						335.68988077604126,
						92.0,
						23.0
					],
					"text": "biquad~"
				}
			},
			{
				"box": {
					"attr": "edit_mode",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-281",
					"lock": 1,
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"orientation": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						350.4595729112625,
						154.68988101445984,
						83.0,
						46.0
					],
					"text_width": 83.0
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "obj-282",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						288.840439334816,
						209.73427660501648,
						31.0,
						20.0
					],
					"text": "*~ 1."
				}
			},
			{
				"box": {
					"id": "obj-243",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1270.5085536989632,
						922.8000137209892,
						86.79999905824661,
						20.0
					],
					"text": "audio loop viz"
				}
			},
			{
				"box": {
					"id": "obj-241",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1248.1617198586464,
						920.8000137209892,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[53]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[53]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[8]"
				}
			},
			{
				"box": {
					"id": "obj-239",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1295.3617205619812,
						980.8000146150589,
						85.0,
						22.0
					],
					"text": "prepend radial"
				}
			},
			{
				"box": {
					"id": "obj-237",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						1071.4212404489517,
						1191.541845548111,
						45.0,
						22.0
					],
					"text": "s hue2"
				}
			},
			{
				"box": {
					"id": "obj-238",
					"maxclass": "swatch",
					"numinlets": 3,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1071.4212404489517,
						1104.1787326335907,
						136.16666996479034,
						84.37446880938717
					],
					"presentation": 1,
					"presentation_rect": [
						954.0297765731812,
						531.3787240982056,
						120.16666972637177,
						63.36995458602905
					],
					"saturation": 1.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "swatch[5]",
							"parameter_modmode": 0,
							"parameter_shortname": "swatch",
							"parameter_type": 3
						}
					},
					"varname": "swatch[1]"
				}
			},
			{
				"box": {
					"id": "obj-235",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						913.0212380886078,
						1194.1163153588564,
						45.0,
						22.0
					],
					"text": "s hue1"
				}
			},
			{
				"box": {
					"id": "obj-236",
					"maxclass": "swatch",
					"numinlets": 3,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"patching_rect": [
						904.5914770960808,
						1104.1787326335907,
						136.16666996479034,
						84.37446880938717
					],
					"presentation": 1,
					"presentation_rect": [
						732.1333429217339,
						626.4666675329208,
						120.16666972637177,
						63.36995458602905
					],
					"saturation": 1.0,
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "swatch[4]",
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
					"id": "obj-234",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2119.361732840538,
						1191.6468080459165,
						87.0,
						22.0
					],
					"text": "poly_mode 2 2"
				}
			},
			{
				"box": {
					"id": "obj-97",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2297.9051259035887,
						1854.5532014429778,
						83.0,
						22.0
					],
					"text": "loadmess 512"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-98",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1346.8404565605583,
						738.8000063896179,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[123]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[69]",
							"parameter_type": 3
						}
					},
					"varname": "number[3]"
				}
			},
			{
				"box": {
					"fontsize": 18.0,
					"id": "obj-99",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						2209.459590137005,
						1886.6750346836243,
						59.0,
						29.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[124]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[122]",
							"parameter_type": 3
						}
					},
					"varname": "number[7]"
				}
			},
			{
				"box": {
					"id": "obj-101",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2253.459590137005,
						1923.933350622654,
						123.0,
						22.0
					],
					"text": "prepend downsample"
				}
			},
			{
				"box": {
					"id": "obj-104",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1370.1617187857628,
						654.2000098228455,
						70.0,
						22.0
					],
					"text": "loadmess 0"
				}
			},
			{
				"box": {
					"id": "obj-105",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1464.374483883381,
						755.2000098228455,
						40.0,
						22.0
					],
					"text": "*~ 0.2"
				}
			},
			{
				"box": {
					"id": "obj-106",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1529.9595901370049,
						747.3594528228455,
						29.5,
						22.0
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-107",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1559.374483883381,
						653.2000098228455,
						45.0,
						23.0
					],
					"text": "$1 20"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-108",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"bang"
					],
					"patching_rect": [
						1570.2095901370049,
						683.2000098228455,
						40.0,
						23.0
					],
					"text": "line~"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-109",
					"maxclass": "flonum",
					"maximum": 10000.0,
					"minimum": 10.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1559.374483883381,
						625.2000098228455,
						54.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [
								440
							],
							"parameter_initial_enable": 1,
							"parameter_invisible": 1,
							"parameter_longname": "flonum[2]",
							"parameter_mmax": 10000.0,
							"parameter_mmin": 10.0,
							"parameter_modmode": 0,
							"parameter_shortname": "flonum",
							"parameter_type": 3
						}
					},
					"triscale": 0.9,
					"varname": "flonum[2]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-113",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1560.4595901370049,
						715.1270267717709,
						90.0,
						23.0
					],
					"text": "cycle~ 440."
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-115",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1458.374483883381,
						653.2000098228455,
						45.0,
						23.0
					],
					"text": "$1 20"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-118",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"bang"
					],
					"patching_rect": [
						1469.2095901370049,
						683.2000098228455,
						40.0,
						23.0
					],
					"text": "line~"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-125",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1459.4595901370049,
						715.1270267717709,
						90.0,
						23.0
					],
					"text": "cycle~ 440."
				}
			},
			{
				"box": {
					"id": "obj-126",
					"maxclass": "gswitch",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1404.6617187857628,
						758.2000098228455,
						41.0,
						32.0
					]
				}
			},
			{
				"box": {
					"id": "obj-128",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1346.8404565605583,
						825.1145097062788,
						44.0,
						22.0
					],
					"text": "*~ -0.5"
				}
			},
			{
				"box": {
					"id": "obj-135",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1478.2095908522606,
						1118.522813014402,
						72.0,
						22.0
					],
					"text": "r audiobang"
				}
			},
			{
				"box": {
					"id": "obj-136",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2167.161718785763,
						947.689891385668,
						91.0,
						22.0
					],
					"text": "r waveLineFilll1"
				}
			},
			{
				"box": {
					"id": "obj-137",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						2125.161718785763,
						941.2000098228455,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[46]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[44]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[5]"
				}
			},
			{
				"box": {
					"id": "obj-138",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 3,
					"outlettype": [
						"bang",
						"bang",
						""
					],
					"patching_rect": [
						2167.161718785763,
						980.2000098228455,
						44.0,
						22.0
					],
					"text": "sel 0 1"
				}
			},
			{
				"box": {
					"id": "obj-139",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2099.7914929986,
						1023.2000098228455,
						72.0,
						22.0
					],
					"text": "line_width 4"
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
						2186.161718785763,
						1057.6042628228456,
						69.0,
						22.0
					],
					"text": "circpoints 5"
				}
			},
			{
				"box": {
					"id": "obj-141",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						2186.161718785763,
						1023.2000098228455,
						69.0,
						22.0
					],
					"text": "circpoints 1"
				}
			},
			{
				"box": {
					"attr": "blend",
					"id": "obj-143",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						1145.1559794467826,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "line_width",
					"id": "obj-144",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						1045.522813014402,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "poly_mode",
					"id": "obj-145",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						1118.522813014402,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "two_sided",
					"id": "obj-146",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						1070.2000098228455,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "circpoints",
					"id": "obj-147",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						1095.4270660203836,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-148",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1253.210682347721,
						1094.2000098228455,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[48]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[43]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[6]"
				}
			},
			{
				"box": {
					"id": "obj-159",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1254.210682347721,
						1159.6468080459165,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[49]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[42]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[7]"
				}
			},
			{
				"box": {
					"id": "obj-160",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1347.1752216371956,
						1164.8879535794258,
						126.0,
						22.0
					],
					"text": "r soundwave_enable1"
				}
			},
			{
				"box": {
					"id": "obj-161",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1347.1752216371956,
						1203.292198139243,
						61.0,
						22.0
					],
					"text": "enable $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-164",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1793.2776626944542,
						619.2468146085739,
						72.0,
						22.0
					],
					"text": "r audiobang"
				}
			},
			{
				"box": {
					"id": "obj-167",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1302.1752216371956,
						1087.4000095129015,
						171.0,
						22.0
					],
					"text": "r soundwave_lighting_enable1"
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
						1324.6752216371956,
						1132.7914972275394,
						106.0,
						22.0
					],
					"text": "lighting_enable $1"
				}
			},
			{
				"box": {
					"attr": "downsample",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-171",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1834.7787374854088,
						480.02681390747784,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"attr": "framesize",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-172",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1834.7787374854088,
						507.31450474717235,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"attr": "mode",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-173",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1834.7787374854088,
						531.6021955868669,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"id": "obj-174",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1349.6752216371956,
						1259.492642045021,
						43.0,
						22.0
					],
					"text": "r hue2"
				}
			},
			{
				"box": {
					"id": "obj-175",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						1979.1617187857628,
						307.95945086233496,
						257.0,
						22.0
					],
					"text": "jit.slide @adapt 1 @slide_up 8 @slide_down 3"
				}
			},
			{
				"box": {
					"attr": "trigthresh",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-176",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1834.7787374854088,
						555.8898864265616,
						228.0,
						23.0
					]
				}
			},
			{
				"box": {
					"id": "obj-178",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1345.6752216371956,
						1293.8926664590836,
						84.0,
						22.0
					],
					"text": "prepend color"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-180",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						1968.1821825976194,
						2146.5682101768393,
						60.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"id": "obj-193",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						2092.1821825976194,
						2234.266683459282,
						20.0,
						20.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[52]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[9]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[11]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-194",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1968.1821825976194,
						2234.266683459282,
						115.0,
						22.0
					],
					"text": "pak blend_enable 1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-195",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						2087.1821825976194,
						2146.5682101768393,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[144]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[47]",
							"parameter_type": 3
						}
					},
					"varname": "number[26]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-196",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						2033.1821825976194,
						2146.5682101768393,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[145]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[46]",
							"parameter_type": 3
						}
					},
					"varname": "number[27]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-197",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1989.1821825976194,
						2185.5682101768393,
						117.0,
						22.0
					],
					"text": "pak blend_mode 6 8"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-198",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1476.4595901370049,
						788.5810485359366,
						73.0,
						22.0
					],
					"text": "gainmode 1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-199",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1751.4595901370049,
						795.689891385668,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-200",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1671.4595901370049,
						795.689891385668,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-201",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1576.4595901370049,
						795.689891385668,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-202",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1751.4595901370049,
						831.189891385668,
						55.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[146]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[38]",
							"parameter_type": 3
						}
					},
					"varname": "number[28]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-203",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1671.4595901370049,
						831.189891385668,
						55.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[147]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[37]",
							"parameter_type": 3
						}
					},
					"varname": "number[29]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-204",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1581.4595901370049,
						831.189891385668,
						57.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[148]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[36]",
							"parameter_type": 3
						}
					},
					"varname": "number[30]"
				}
			},
			{
				"box": {
					"autoout": 1,
					"bgcolor": [
						0.913725,
						0.913725,
						1.0,
						1.0
					],
					"curvecolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"domain": [
						0.0,
						22050.0
					],
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"hcurvecolor": [
						1.0,
						0.086275,
						0.086275,
						1.0
					],
					"id": "obj-205",
					"linmarkers": [
						0.0,
						11025.0,
						16537.5
					],
					"logmarkers": [
						0.0,
						100.0,
						1000.0,
						10000.0
					],
					"markercolor": [
						0.509804,
						0.509804,
						0.509804,
						1.0
					],
					"maxclass": "filtergraph~",
					"nfilters": 1,
					"numinlets": 8,
					"numoutlets": 7,
					"outlettype": [
						"list",
						"float",
						"float",
						"float",
						"float",
						"list",
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						1428.1617187857628,
						902.2000098228455,
						246.5,
						94.0
					],
					"setfilter": [
						0,
						1,
						1,
						0,
						0,
						60.00290298461914,
						2.04883861541748,
						0.897967100143433,
						9.9999997474e-05,
						22050.0,
						9.9999997474e-05,
						16.0,
						0.5,
						25.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-206",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1417.2095901370049,
						1017.689891385668,
						92.0,
						23.0
					],
					"text": "biquad~"
				}
			},
			{
				"box": {
					"attr": "edit_mode",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-207",
					"lock": 1,
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"orientation": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1428.1617187857628,
						849.4898918148215,
						131.29787135124207,
						46.0
					],
					"text_width": 83.0
				}
			},
			{
				"box": {
					"attr": "smooth_shading",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-209",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						972.2351221747072,
						195.0,
						23.0
					],
					"text_width": 122.410034
				}
			},
			{
				"box": {
					"attr": "lighting_enable",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-211",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						947.9474313350124,
						195.0,
						23.0
					],
					"text_width": 122.410034
				}
			},
			{
				"box": {
					"attr": "circpoints",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-212",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						996.5228130144019,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "obj-213",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						1441.905126076017,
						1261.0,
						944.0,
						20.0
					],
					"text": "jit.gl.graph fb @antialias 1 @auto_material 0 @color 1 1 1 1 @lighting_enable 0 @shininess 0. @smooth_shading 0 @circpoints 5 @automatic 1 @shadow_caster 0 @line_width 2 @blend_enable 0 @layer 3"
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "obj-214",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						1815.1914927363396,
						710.153792142868,
						346.0,
						20.0
					],
					"text": "jit.catch~ @mode 3 @framesize 1024 @trigthresh 0.02 @downsample 0"
				}
			},
			{
				"box": {
					"attr": "radial",
					"id": "obj-217",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1567.261587785763,
						1079.6042628228456,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "shadow_caster",
					"id": "obj-218",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1567.261587785763,
						1101.6042628228456,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "shininess",
					"id": "obj-219",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1567.261587785763,
						1123.6042628228456,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "smooth_shading",
					"id": "obj-220",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1567.261587785763,
						1145.6042628228456,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "two_sided",
					"id": "obj-221",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1567.261587785763,
						1167.6042628228456,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "outputmode",
					"id": "obj-222",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						2175.743621647358,
						274.95945076052476,
						216.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "trigdir",
					"id": "obj-223",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1884.2946843504906,
						666.5474314890595,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "slide_down",
					"id": "obj-224",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1845.4117187857628,
						274.95945076052476,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "slide_up",
					"id": "obj-225",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						2008.1617184345205,
						274.95945076052476,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "blend_enable",
					"id": "obj-226",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						1172.6042591273576,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "blend_mode",
					"id": "obj-227",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1848.2095901370049,
						1196.6042591273576,
						150.0,
						22.0
					]
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
						561.9194716215134,
						710.5214452315831,
						70.0,
						22.0
					],
					"text": "loadmess 2"
				}
			},
			{
				"box": {
					"format": 6,
					"id": "obj-96",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						666.6719599366188,
						590.2619268434651,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[69]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[69]",
							"parameter_type": 3
						}
					},
					"varname": "number[2]"
				}
			},
			{
				"box": {
					"fontsize": 18.0,
					"id": "obj-100",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						556.1719599366188,
						745.1214519311452,
						59.0,
						29.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[122]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[122]",
							"parameter_type": 3
						}
					},
					"varname": "number"
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
						556.1719599366188,
						782.4898900266821,
						123.0,
						22.0
					],
					"text": "prepend downsample"
				}
			},
			{
				"box": {
					"id": "obj-93",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						796.791486799717,
						394.6000027656555,
						74.0,
						20.0
					],
					"text": "KittieBump"
				}
			},
			{
				"box": {
					"id": "obj-55",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						611.5617081522942,
						600.6000039577484,
						34.0,
						22.0
					],
					"text": "*~ 1."
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
						957.1744759678841,
						224.32701930926942,
						70.0,
						22.0
					],
					"text": "loadmess 0"
				}
			},
			{
				"box": {
					"id": "obj-88",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1041.2595833539963,
						239.40000236034393,
						40.0,
						22.0
					],
					"text": "*~ 0.2"
				}
			},
			{
				"box": {
					"id": "obj-86",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1106.8446896076202,
						231.55944536034394,
						29.5,
						22.0
					],
					"text": "+~"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-78",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1136.2595833539963,
						137.40000236034393,
						45.0,
						23.0
					],
					"text": "$1 20"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-79",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"bang"
					],
					"patching_rect": [
						1147.0946896076202,
						167.40000236034393,
						40.0,
						23.0
					],
					"text": "line~"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-80",
					"maxclass": "flonum",
					"maximum": 10000.0,
					"minimum": 10.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1136.2595833539963,
						109.40000236034393,
						54.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [
								440
							],
							"parameter_initial_enable": 1,
							"parameter_invisible": 1,
							"parameter_longname": "flonum[1]",
							"parameter_mmax": 10000.0,
							"parameter_mmin": 10.0,
							"parameter_modmode": 0,
							"parameter_shortname": "flonum",
							"parameter_type": 3
						}
					},
					"triscale": 0.9,
					"varname": "flonum[1]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-85",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1137.3446896076202,
						199.32701930926942,
						90.0,
						23.0
					],
					"text": "cycle~ 440."
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-73",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1035.2595833539963,
						137.40000236034393,
						45.0,
						23.0
					],
					"text": "$1 20"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-75",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"bang"
					],
					"patching_rect": [
						1046.0946896076202,
						167.40000236034393,
						40.0,
						23.0
					],
					"text": "line~"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-76",
					"maxclass": "flonum",
					"maximum": 10000.0,
					"minimum": 10.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1035.2595833539963,
						101.40000236034393,
						54.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [
								440
							],
							"parameter_initial_enable": 1,
							"parameter_invisible": 1,
							"parameter_longname": "flonum",
							"parameter_mmax": 10000.0,
							"parameter_mmin": 10.0,
							"parameter_modmode": 0,
							"parameter_shortname": "flonum",
							"parameter_type": 3
						}
					},
					"triscale": 0.9,
					"varname": "flonum"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-77",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						1036.3446896076202,
						199.32701930926942,
						90.0,
						23.0
					],
					"text": "cycle~ 440."
				}
			},
			{
				"box": {
					"id": "obj-56",
					"maxclass": "gswitch",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						814.8946686387062,
						212.08988224231553,
						41.0,
						32.0
					]
				}
			},
			{
				"box": {
					"comment": "",
					"id": "obj-53",
					"index": 2,
					"maxclass": "outlet",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						710.6638283133507,
						421.8340450525284,
						30.0,
						30.0
					]
				}
			},
			{
				"box": {
					"id": "obj-51",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						679.2574594768944,
						336.51450264908885,
						34.0,
						22.0
					],
					"text": "*~ 1."
				}
			},
			{
				"box": {
					"id": "obj-49",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						890.7829924225807,
						172.92701891587876,
						70.0,
						22.0
					],
					"text": "loadmess 1"
				}
			},
			{
				"box": {
					"comment": "",
					"id": "obj-50",
					"index": 1,
					"maxclass": "inlet",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						698.9617007374763,
						254.08988224231553,
						30.0,
						30.0
					]
				}
			},
			{
				"box": {
					"comment": "",
					"id": "obj-19",
					"index": 1,
					"maxclass": "outlet",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						652.2574594768944,
						403.1898846503432,
						30.0,
						30.0
					]
				}
			},
			{
				"box": {
					"id": "obj-47",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						565.3106728348198,
						654.0351176566751,
						101.0,
						22.0
					],
					"text": "s kittybumpsignal"
				}
			},
			{
				"box": {
					"id": "obj-41",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						549.3617018461227,
						590.2619268434651,
						32.0,
						22.0
					],
					"text": "gate"
				}
			},
			{
				"box": {
					"id": "obj-26",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						562.7617091536522,
						524.3021961709926,
						67.0,
						22.0
					],
					"text": "r kittybump"
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
						568.5617090463638,
						557.5145053312979,
						59.0,
						22.0
					],
					"text": "r ctrlbang"
				}
			},
			{
				"box": {
					"id": "obj-11",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"patching_rect": [
						565.2617091536522,
						627.1693949531054,
						35.0,
						22.0
					],
					"text": "avg~"
				}
			},
			{
				"box": {
					"id": "obj-48",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						364.56157225370407,
						997.9787312746048,
						72.0,
						22.0
					],
					"text": "r audiobang"
				}
			},
			{
				"box": {
					"id": "obj-46",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1084.9617028832436,
						841.4898900266821,
						85.0,
						22.0
					],
					"text": "r waveLineFilll"
				}
			},
			{
				"box": {
					"id": "obj-43",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1042.9617028832436,
						835.0000084638596,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[44]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[44]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[4]"
				}
			},
			{
				"box": {
					"id": "obj-30",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 3,
					"outlettype": [
						"bang",
						"bang",
						""
					],
					"patching_rect": [
						1084.9617028832436,
						874.0000084638596,
						44.0,
						22.0
					],
					"text": "sel 0 1"
				}
			},
			{
				"box": {
					"id": "obj-27",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1017.5914770960808,
						917.0000084638596,
						79.0,
						22.0
					],
					"text": "line_width 12"
				}
			},
			{
				"box": {
					"id": "obj-24",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1103.9617028832436,
						951.4042614638596,
						69.0,
						22.0
					],
					"text": "circpoints 5"
				}
			},
			{
				"box": {
					"id": "obj-23",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1103.9617028832436,
						917.0000084638596,
						69.0,
						22.0
					],
					"text": "circpoints 1"
				}
			},
			{
				"box": {
					"attr": "blend",
					"id": "obj-52",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						766.0095742344856,
						1038.9559780877967,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "line_width",
					"id": "obj-65",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						766.0095742344856,
						939.322811655416,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "poly_mode",
					"id": "obj-62",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						766.0095742344856,
						1012.322811655416,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "two_sided",
					"id": "obj-61",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						766.0095742344856,
						964.0000084638596,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "circpoints",
					"id": "obj-58",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						766.0095742344856,
						989.2270646613977,
						195.0,
						22.0
					]
				}
			},
			{
				"box": {
					"id": "obj-45",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						141.96170288324356,
						946.4000078439713,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[43]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[43]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[3]"
				}
			},
			{
				"box": {
					"id": "obj-42",
					"maxclass": "button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						730.6638315320015,
						1235.382984638214,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "button[8]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "button[8]",
							"parameter_type": 2
						}
					},
					"varname": "button"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-31",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						518.9591948390007,
						1226.0731054498947,
						60.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-36",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						633.6719599366188,
						1173.0731054498947,
						42.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[83]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[53]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[9]"
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-37",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						670.6719599366188,
						1173.0731054498947,
						42.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[91]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[52]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[10]"
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-38",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						596.6719599366188,
						1173.0731054498947,
						42.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[92]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[51]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[11]"
				}
			},
			{
				"box": {
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 9.0,
					"id": "obj-39",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						543.9591948390007,
						1263.7788851734335,
						82.0,
						19.0
					],
					"text": "pak scale 1.5 1. 0."
				}
			},
			{
				"box": {
					"id": "obj-20",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						172.01066644520188,
						1053.4468066869306,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[42]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[42]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[2]"
				}
			},
			{
				"box": {
					"id": "obj-14",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						206.00957423448563,
						1039.4042614638597,
						119.0,
						22.0
					],
					"text": "r soundwave_enable"
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
						222.30853779644394,
						1076.4255294976758,
						61.0,
						22.0
					],
					"text": "enable $1"
				}
			},
			{
				"box": {
					"id": "obj-13",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						901.4404501470985,
						210.94334148132157,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[41]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[41]",
							"parameter_type": 2
						}
					},
					"varname": "toggle[1]"
				}
			},
			{
				"box": {
					"id": "obj-117",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						301.0095742344856,
						1164.361703157425,
						24.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[24]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[24]",
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
					"id": "obj-44",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						739.8946686387062,
						573.2340475320816,
						72.0,
						22.0
					],
					"text": "r audiobang"
				}
			},
			{
				"box": {
					"id": "obj-28",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						199.6404406580391,
						959.5744867147876,
						164.0,
						22.0
					],
					"text": "r soundwave_lighting_enable"
				}
			},
			{
				"box": {
					"id": "obj-25",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						199.6404406580391,
						997.9787312746048,
						106.0,
						22.0
					],
					"text": "lighting_enable $1"
				}
			},
			{
				"box": {
					"attr": "slide_down",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-124",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						760.5787217020988,
						839.077818951534,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"attr": "slide_up",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-123",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						760.5787217020988,
						807.4898900266821,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"attr": "downsample",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-122",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						805.0095745325089,
						700.5594516014326,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"attr": "framesize",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-121",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						760.5787217020988,
						733.9145083472929,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"attr": "mode",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-120",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						760.5787217020988,
						758.2021991869874,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"id": "obj-119",
					"maxclass": "newobj",
					"numinlets": 0,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						167.51066644520188,
						1111.2926406860352,
						43.0,
						22.0
					],
					"text": "r hue1"
				}
			},
			{
				"box": {
					"id": "obj-208",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						743.0095745325089,
						676.5594516014326,
						257.0,
						22.0
					],
					"text": "jit.slide @adapt 1 @slide_up 8 @slide_down 3"
				}
			},
			{
				"box": {
					"attr": "trigthresh",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-187",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						760.5787217020988,
						782.4898900266821,
						228.0,
						23.0
					]
				}
			},
			{
				"box": {
					"id": "obj-186",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"signal"
					],
					"patching_rect": [
						901.4404501470985,
						246.3810406800444,
						35.0,
						22.0
					],
					"text": "adc~"
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
						163.51066644520188,
						1145.6926651000977,
						84.0,
						22.0
					],
					"text": "prepend color"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-29",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						883.5914770960808,
						1229.9787316322327,
						60.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-179",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"bang"
					],
					"patching_rect": [
						297.96170288324356,
						1236.0731054498947,
						60.0,
						22.0
					],
					"text": "loadbang"
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-154",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						798.6744679808617,
						1189.4042611122131,
						42.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[82]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[82]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[50]"
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-155",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						835.6744679808617,
						1189.4042611122131,
						42.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[81]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[81]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[49]"
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-156",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						761.6744679808617,
						1189.4042611122131,
						42.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[80]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[80]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[48]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 9.0,
					"id": "obj-157",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						733.9617028832436,
						1278.4042611122131,
						94.0,
						19.0
					],
					"text": "pak rotatexyz 0. 0. 0."
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-81",
					"maxclass": "flonum",
					"maximum": 2.0,
					"minimum": -2.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						413.17446798086166,
						1181.0731054498947,
						67.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[50]",
							"parameter_mmax": 2.0,
							"parameter_mmin": -2.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[50]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[18]"
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-82",
					"maxclass": "flonum",
					"maximum": 2.0,
					"minimum": -2.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						489.17446798086166,
						1181.0731054498947,
						42.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[49]",
							"parameter_mmax": 2.0,
							"parameter_mmin": -2.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[49]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[17]"
				}
			},
			{
				"box": {
					"bgcolor": [
						0.866667,
						0.866667,
						0.866667,
						1.0
					],
					"fontname": "Arial Bold",
					"fontsize": 14.0,
					"format": 6,
					"htricolor": [
						0.87,
						0.82,
						0.24,
						1.0
					],
					"id": "obj-83",
					"maxclass": "flonum",
					"maximum": 2.0,
					"minimum": -2.0,
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						364.56157225370407,
						1181.0731054498947,
						42.0,
						24.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[48]",
							"parameter_mmax": 2.0,
							"parameter_mmin": -2.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[48]",
							"parameter_type": 3
						}
					},
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"tricolor": [
						0.75,
						0.75,
						0.75,
						1.0
					],
					"triscale": 0.9,
					"varname": "number[16]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 9.0,
					"id": "obj-84",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						281.6638315320015,
						1270.0731054498947,
						100.0,
						19.0
					],
					"text": "pak position 0. -0.85 0."
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-63",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						210.00957423448563,
						1198.0212849378586,
						95.0,
						22.0
					],
					"text": "pak automatic 0"
				}
			},
			{
				"box": {
					"id": "obj-116",
					"maxclass": "toggle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"int"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1017.5914770960808,
						1304.6772049146753,
						20.0,
						20.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_enum": [
								"off",
								"on"
							],
							"parameter_longname": "toggle[9]",
							"parameter_mmax": 1,
							"parameter_modmode": 0,
							"parameter_shortname": "toggle[9]",
							"parameter_type": 2
						}
					},
					"varname": "toggle"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-114",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						893.5914770960808,
						1304.6772049146753,
						115.0,
						22.0
					],
					"text": "pak blend_enable 1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-110",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1002.5914770960808,
						1229.9787316322327,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[47]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[47]",
							"parameter_type": 3
						}
					},
					"varname": "number[15]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-111",
					"maxclass": "number",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						948.5914770960808,
						1229.9787316322327,
						50.0,
						22.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[46]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[46]",
							"parameter_type": 3
						}
					},
					"varname": "number[14]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-112",
					"maxclass": "newobj",
					"numinlets": 3,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						904.5914770960808,
						1268.9787316322327,
						117.0,
						22.0
					],
					"text": "pak blend_mode 6 7"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 12.0,
					"id": "obj-60",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						808.8765930533409,
						299.98104147874665,
						73.0,
						22.0
					],
					"text": "gainmode 1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-2",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1083.876593053341,
						307.0898843284781,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1003.8765930533409,
						307.0898843284781,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-4",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						890.7829924225807,
						286.2000033855438,
						48.0,
						23.0
					],
					"text": "set $1"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-6",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1083.876593053341,
						342.5898843284781,
						55.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[38]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[38]",
							"parameter_type": 3
						}
					},
					"varname": "number[6]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-74",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						1003.8765930533409,
						342.5898843284781,
						55.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[37]",
							"parameter_modmode": 0,
							"parameter_shortname": "number[37]",
							"parameter_type": 3
						}
					},
					"varname": "number[5]"
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"format": 6,
					"id": "obj-7",
					"maxclass": "flonum",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"bang"
					],
					"parameter_enable": 1,
					"patching_rect": [
						913.8765930533409,
						342.5898843284781,
						57.0,
						23.0
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_invisible": 1,
							"parameter_longname": "number[36]",
							"parameter_modmax": 19.0,
							"parameter_modmin": 1.0,
							"parameter_modmode": 0,
							"parameter_shortname": "number[36]",
							"parameter_type": 3
						}
					},
					"varname": "number[4]"
				}
			},
			{
				"box": {
					"autoout": 1,
					"bgcolor": [
						0.913725,
						0.913725,
						1.0,
						1.0
					],
					"curvecolor": [
						0.0,
						0.0,
						0.0,
						1.0
					],
					"domain": [
						0.0,
						22050.0
					],
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 12.0,
					"hcurvecolor": [
						1.0,
						0.086275,
						0.086275,
						1.0
					],
					"id": "obj-8",
					"linmarkers": [
						0.0,
						11025.0,
						16537.5
					],
					"logmarkers": [
						0.0,
						100.0,
						1000.0,
						10000.0
					],
					"markercolor": [
						0.509804,
						0.509804,
						0.509804,
						1.0
					],
					"maxclass": "filtergraph~",
					"nfilters": 1,
					"numinlets": 8,
					"numoutlets": 7,
					"outlettype": [
						"list",
						"float",
						"float",
						"float",
						"float",
						"list",
						"int"
					],
					"parameter_enable": 0,
					"patching_rect": [
						760.5787217020988,
						413.6000027656555,
						246.5,
						94.0
					],
					"setfilter": [
						0,
						1,
						1,
						0,
						0,
						46.66890335083008,
						0.916996538639069,
						1.015430927276611,
						9.9999997474e-05,
						22050.0,
						9.9999997474e-05,
						16.0,
						0.5,
						25.0
					],
					"textcolor": [
						0.0,
						0.0,
						0.0,
						1.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-17",
					"maxclass": "newobj",
					"numinlets": 6,
					"numoutlets": 1,
					"outlettype": [
						"signal"
					],
					"patching_rect": [
						707.3117122650146,
						528.2898843165572,
						92.0,
						23.0
					],
					"text": "biquad~"
				}
			},
			{
				"box": {
					"attr": "edit_mode",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-10",
					"lock": 1,
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"orientation": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						808.8765930533409,
						332.0898843284781,
						83.0,
						46.0
					],
					"text_width": 83.0
				}
			},
			{
				"box": {
					"attr": "smooth_shading",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-32",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						766.0095742344856,
						866.0351208157213,
						195.0,
						23.0
					],
					"text_width": 122.410034
				}
			},
			{
				"box": {
					"attr": "lighting_enable",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-33",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						766.0095742344856,
						841.7474299760265,
						195.0,
						23.0
					],
					"text_width": 122.410034
				}
			},
			{
				"box": {
					"attr": "circpoints",
					"fontface": 0,
					"fontname": "Arial",
					"fontsize": 13.0,
					"id": "obj-34",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						766.0095742344856,
						890.322811655416,
						195.0,
						23.0
					]
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "obj-12",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						400.5615727901459,
						1079.6042605638504,
						793.0,
						20.0
					],
					"text": "jit.gl.graph fb @antialias 0 @auto_material 0 @color 1 1 1 1 @lighting_enable 0 @shininess 50 @smooth_shading 0 @circpoints 5 @automatic 1 @shadow_caster 0 @layer 3"
				}
			},
			{
				"box": {
					"fontname": "Arial Bold",
					"fontsize": 10.0,
					"id": "obj-3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"jit_matrix",
						""
					],
					"patching_rect": [
						750.5914770960808,
						612.7474299760265,
						346.0,
						20.0
					],
					"text": "jit.catch~ @mode 3 @framesize 1024 @trigthresh 0.02 @downsample 0"
				}
			},
			{
				"box": {
					"attr": "antialias",
					"id": "obj-9",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						465.06157158522035,
						895.4042606293946,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "radial",
					"id": "obj-22",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						465.06157158522035,
						917.4042606293946,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "shadow_caster",
					"id": "obj-35",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						465.06157158522035,
						939.4042606293946,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "shininess",
					"id": "obj-40",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						465.06157158522035,
						961.4042606293946,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "smooth_shading",
					"id": "obj-67",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						465.06157158522035,
						983.4042606293947,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "outputmode",
					"id": "obj-70",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						919.5914770960808,
						641.1594514638596,
						216.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "trigdir",
					"id": "obj-71",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						814.8946686387062,
						582.7474304638596,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "slide_down",
					"id": "obj-5",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						998.5574441552162,
						270.46157334152986,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "slide_up",
					"id": "obj-15",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						752.0095738832435,
						641.1594514638596,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "blend_enable",
					"id": "obj-57",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						413.17446798086166,
						1314.4042614638597,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "blend_mode",
					"id": "obj-59",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						413.17446798086166,
						1338.4042614638597,
						150.0,
						22.0
					]
				}
			},
			{
				"box": {
					"attr": "antialias",
					"id": "obj-16",
					"maxclass": "attrui",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"parameter_enable": 0,
					"patching_rect": [
						1567.261587785763,
						1053.404263,
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
					"id": "obj-177",
					"ignoreclick": 1,
					"maxclass": "mira.frame",
					"numinlets": 0,
					"numoutlets": 0,
					"patching_rect": [
						1651.3617018461227,
						1503.0,
						680.7912259101868,
						484.0
					],
					"tabname": "SoundWaves",
					"taborder": 4
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"destination": [
						"obj-74",
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
						"obj-8",
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
						"obj-95",
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
						"obj-316",
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
						"obj-262",
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
						"obj-247",
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
						"obj-126",
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
						"obj-126",
						2
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
						"obj-105",
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
						"obj-113",
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
						"obj-107",
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
						"obj-47",
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
						"obj-112",
						2
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
						"obj-112",
						1
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
						"obj-12",
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
						"obj-106",
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
						"obj-12",
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
						"obj-118",
						0
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
						"obj-114",
						1
					],
					"source": [
						"obj-116",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-63",
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
						"obj-125",
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
						"obj-210",
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
						"obj-3",
						0
					],
					"source": [
						"obj-120",
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
						"obj-121",
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
						"obj-122",
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
						"obj-123",
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
						"obj-124",
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
						"obj-125",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-128",
						1
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
						"obj-329",
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
						"obj-206",
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
						"obj-293",
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
						"obj-186",
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
						"obj-294",
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
						"obj-303",
						0
					],
					"source": [
						"obj-131",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-299",
						2
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
						"obj-134",
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
						"obj-142",
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
						"obj-213",
						0
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
						"obj-138",
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
						"obj-138",
						0
					],
					"source": [
						"obj-137",
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
						"obj-138",
						1
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
						"obj-141",
						0
					],
					"order": 0,
					"source": [
						"obj-138",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
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
						"obj-18",
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
						"obj-213",
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
						"obj-213",
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
						"obj-214",
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
						"obj-213",
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
						"obj-213",
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
						"obj-213",
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
						"obj-213",
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
						"obj-213",
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
						"obj-208",
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
						"obj-132",
						0
					],
					"source": [
						"obj-150",
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
						"obj-151",
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
					"order": 1,
					"source": [
						"obj-152",
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
					"order": 0,
					"source": [
						"obj-152",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-152",
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
						"obj-157",
						2
					],
					"source": [
						"obj-154",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-157",
						3
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
						"obj-157",
						1
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
						"obj-12",
						0
					],
					"source": [
						"obj-157",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-152",
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
						"obj-213",
						0
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
						"obj-161",
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
						"obj-213",
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
						"obj-137",
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
						"obj-152",
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
						"obj-214",
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
						"obj-213",
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
						"obj-168",
						0
					],
					"source": [
						"obj-167",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
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
						"obj-148",
						0
					],
					"order": 1,
					"source": [
						"obj-169",
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
					"order": 0,
					"source": [
						"obj-169",
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
					"order": 0,
					"source": [
						"obj-17",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-360",
						0
					],
					"order": 2,
					"source": [
						"obj-17",
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
						"obj-17",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-241",
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
						"obj-214",
						0
					],
					"source": [
						"obj-171",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-214",
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
						"obj-214",
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
						"obj-178",
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
						"obj-214",
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
						"obj-213",
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
						"obj-84",
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
						"obj-12",
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
						"obj-194",
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
						"obj-197",
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
						"obj-238",
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
						"obj-236",
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
						"obj-182",
						0
					],
					"order": 0,
					"source": [
						"obj-184",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-183",
						0
					],
					"order": 1,
					"source": [
						"obj-184",
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
					"order": 0,
					"source": [
						"obj-185",
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
					"order": 1,
					"source": [
						"obj-185",
						0
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
						"obj-186",
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
						"obj-187",
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
						"obj-188",
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
					"source": [
						"obj-189",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-194",
						1
					],
					"source": [
						"obj-193",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
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
						"obj-197",
						2
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
						"obj-197",
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
						"obj-213",
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
						"obj-205",
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
						"obj-202",
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
						"obj-6",
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
						"obj-18",
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
						"obj-203",
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
						"obj-204",
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
						"obj-205",
						7
					],
					"source": [
						"obj-202",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-205",
						6
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
						"obj-205",
						5
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
						"obj-199",
						0
					],
					"source": [
						"obj-205",
						3
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-200",
						0
					],
					"source": [
						"obj-205",
						2
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
						"obj-205",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-206",
						0
					],
					"source": [
						"obj-205",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-214",
						0
					],
					"source": [
						"obj-206",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-205",
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
						"obj-12",
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
						"obj-213",
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
						"obj-41",
						1
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
						"obj-12",
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
						"obj-213",
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
						"obj-213",
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
						"obj-213",
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
						"obj-64",
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
						"obj-213",
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
						"obj-213",
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
						"obj-213",
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
						"obj-12",
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
						"obj-213",
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
						"obj-213",
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
						"obj-175",
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
						"obj-214",
						0
					],
					"source": [
						"obj-223",
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
					"source": [
						"obj-224",
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
					"source": [
						"obj-225",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
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
						"obj-213",
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
						"obj-338",
						0
					],
					"source": [
						"obj-228",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-215",
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
						"obj-12",
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
						"obj-231",
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
						"obj-240",
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
						"obj-267",
						0
					],
					"source": [
						"obj-233",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
						0
					],
					"source": [
						"obj-234",
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
						"obj-236",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-237",
						0
					],
					"source": [
						"obj-238",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
						0
					],
					"source": [
						"obj-239",
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
						"obj-24",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-242",
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
						"obj-239",
						0
					],
					"source": [
						"obj-241",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-257",
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
						"obj-258",
						0
					],
					"source": [
						"obj-245",
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
						"obj-246",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-248",
						1
					],
					"source": [
						"obj-247",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-262",
						0
					],
					"order": 1,
					"source": [
						"obj-248",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-318",
						0
					],
					"order": 0,
					"source": [
						"obj-248",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-256",
						0
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
						"obj-12",
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
						"obj-254",
						0
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
						"obj-268",
						0
					],
					"source": [
						"obj-251",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-269",
						0
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
						"obj-256",
						0
					],
					"source": [
						"obj-252",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-256",
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
						"obj-256",
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
						"obj-248",
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
						"obj-255",
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
						"obj-260",
						2
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
						"obj-260",
						1
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
						"obj-260",
						0
					],
					"source": [
						"obj-259",
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
						"obj-26",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-256",
						0
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
						"obj-291",
						2
					],
					"source": [
						"obj-261",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-255",
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
						"obj-246",
						0
					],
					"order": 1,
					"source": [
						"obj-264",
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
						"obj-264",
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
					"source": [
						"obj-265",
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
						"obj-266",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-266",
						0
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
						"obj-261",
						0
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
						"obj-12",
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
						"obj-233",
						0
					],
					"order": 1,
					"source": [
						"obj-270",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-251",
						0
					],
					"order": 0,
					"source": [
						"obj-270",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-279",
						0
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
						"obj-276",
						0
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
						"obj-277",
						0
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
						"obj-278",
						0
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
						"obj-279",
						7
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
						"obj-279",
						6
					],
					"source": [
						"obj-277",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-279",
						5
					],
					"source": [
						"obj-278",
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
						"obj-279",
						3
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
						"obj-279",
						2
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
						"obj-279",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-280",
						0
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
						"obj-25",
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
						"obj-259",
						0
					],
					"source": [
						"obj-280",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-279",
						0
					],
					"source": [
						"obj-281",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-280",
						0
					],
					"order": 0,
					"source": [
						"obj-282",
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
					"order": 1,
					"source": [
						"obj-282",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-282",
						0
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
						"obj-246",
						0
					],
					"order": 1,
					"source": [
						"obj-287",
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
						"obj-287",
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
						"obj-29",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
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
						"obj-270",
						0
					],
					"source": [
						"obj-292",
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
						"obj-293",
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
						"obj-294",
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
						"obj-295",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-299",
						3
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
						"obj-299",
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
						"obj-299",
						1
					],
					"source": [
						"obj-298",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
						0
					],
					"source": [
						"obj-299",
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
						"obj-3",
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
					"order": 0,
					"source": [
						"obj-30",
						1
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
						"obj-30",
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
					"order": 1,
					"source": [
						"obj-30",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-303",
						3
					],
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
						2
					],
					"source": [
						"obj-301",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-303",
						1
					],
					"source": [
						"obj-302",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
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
						"obj-270",
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
						"obj-213",
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
						"obj-270",
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
						"obj-305",
						1
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
						"obj-270",
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
						"obj-39",
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
						"obj-312",
						0
					],
					"source": [
						"obj-311",
						0
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
						"obj-313",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-214",
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
						"obj-325",
						2
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
						"obj-12",
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
						"obj-325",
						1
					],
					"source": [
						"obj-320",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-322",
						4
					],
					"source": [
						"obj-321",
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
						"obj-322",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-327",
						0
					],
					"source": [
						"obj-323",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-323",
						0
					],
					"source": [
						"obj-324",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
						0
					],
					"source": [
						"obj-328",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-305",
						1
					],
					"source": [
						"obj-329",
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
						"obj-33",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-213",
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
						"obj-189",
						0
					],
					"source": [
						"obj-337",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-368",
						0
					],
					"source": [
						"obj-338",
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
					"source": [
						"obj-339",
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
						"obj-34",
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
						"obj-344",
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
						"obj-35",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-362",
						0
					],
					"source": [
						"obj-357",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-360",
						1
					],
					"source": [
						"obj-359",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-39",
						2
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
						"obj-365",
						0
					],
					"source": [
						"obj-360",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-365",
						0
					],
					"source": [
						"obj-362",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-362",
						0
					],
					"source": [
						"obj-363",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-362",
						1
					],
					"source": [
						"obj-364",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-367",
						0
					],
					"source": [
						"obj-365",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-369",
						0
					],
					"source": [
						"obj-366",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-361",
						0
					],
					"source": [
						"obj-367",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-337",
						0
					],
					"source": [
						"obj-368",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-368",
						1
					],
					"source": [
						"obj-369",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-368",
						0
					],
					"source": [
						"obj-369",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-39",
						3
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
						"obj-370",
						0
					],
					"source": [
						"obj-372",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-39",
						1
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
						"obj-12",
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
						"obj-7",
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
						"obj-12",
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
						"obj-11",
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
						"obj-157",
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
						"obj-30",
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
						"obj-3",
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
						"obj-25",
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
						"obj-30",
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
						"obj-12",
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
						"obj-13",
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
						"obj-208",
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
						"obj-51",
						1
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
						"obj-128",
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
						"obj-17",
						0
					],
					"order": 3,
					"source": [
						"obj-51",
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
					"order": 4,
					"source": [
						"obj-51",
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
					"order": 5,
					"source": [
						"obj-51",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-310",
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
						"obj-53",
						0
					],
					"order": 2,
					"source": [
						"obj-51",
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
						"obj-52",
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
						"obj-54",
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
						"obj-55",
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
						"obj-12",
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
						"obj-12",
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
						"obj-8",
						7
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
						"obj-8",
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
						"obj-12",
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
						"obj-12",
						0
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
						"obj-12",
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
						"obj-232",
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
						"obj-12",
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
						"obj-213",
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
						"obj-12",
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
						"obj-149",
						0
					],
					"source": [
						"obj-68",
						1
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
						"obj-68",
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
						"obj-69",
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
					"source": [
						"obj-7",
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
						"obj-70",
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
						"obj-71",
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
						"obj-73",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-8",
						6
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
						"obj-77",
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
						"obj-73",
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
						"obj-86",
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
						"obj-79",
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
						"obj-85",
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
						"obj-1",
						0
					],
					"source": [
						"obj-8",
						2
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
						"obj-8",
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
						3
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
						"obj-8",
						1
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
						"obj-80",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-84",
						2
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
						"obj-84",
						3
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
						"obj-84",
						1
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
						"obj-12",
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
						"obj-86",
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
						"obj-88",
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
						"obj-216",
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
						"obj-305",
						1
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
						"obj-56",
						2
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
						"obj-152",
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
						"obj-12",
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
						"obj-150",
						0
					],
					"source": [
						"obj-90",
						1
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-151",
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
						"obj-299",
						1
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
						"obj-100",
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
						"obj-116",
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
						"obj-3",
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
						"obj-55",
						1
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
						"obj-99",
						0
					],
					"source": [
						"obj-97",
						0
					]
				}
			},
			{
				"patchline": {
					"destination": [
						"obj-128",
						1
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
						0
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
					"obj-241",
					"obj-243"
				]
			},
			{
				"boxes": [
					"obj-189",
					"obj-181"
				]
			},
			{
				"boxes": [
					"obj-232",
					"obj-231"
				]
			},
			{
				"boxes": [
					"obj-329",
					"obj-332"
				]
			},
			{
				"boxes": [
					"obj-340",
					"obj-338"
				]
			},
			{
				"boxes": [
					"obj-190",
					"obj-215"
				]
			}
		]
	}
}
