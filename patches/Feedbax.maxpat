{
	"patcher" : {
		"fileversion" : 1,
		"appversion" : {
			"major" : 9,
			"minor" : 0,
			"revision" : 7,
			"architecture" : "x64",
			"modernui" : 1
		},
		"classnamespace" : "box",
		"rect" : [ 198.0, 503.0, 1127.0, 903.0 ],
		"gridsize" : [ 15.0, 15.0 ],
		"boxes" : [
			{
				"box" : {
					"id" : "obj-feedbax-pathsetup",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 0,
					"patcher" : {
						"fileversion" : 1,
						"appversion" : {
							"major" : 9,
							"minor" : 0,
							"revision" : 7,
							"architecture" : "x64",
							"modernui" : 1
						},
						"classnamespace" : "box",
						"rect" : [ 100, 100, 700, 500 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [
							{
								"box" : {
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 50.0, 30.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-2",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 50.0, 70.0, 35.0, 22.0 ],
									"text" : "path"
								}
							},
							{
								"box" : {
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 50.0, 110.0, 72.0, 22.0 ],
									"text" : "thispatcher"
								}
							},
							{
								"box" : {
									"comment" : "thispatcher outputs 'path <dir>' — route strips the selector",
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 50.0, 150.0, 63.0, 22.0 ],
									"text" : "route path"
								}
							},
							{
								"box" : {
									"comment" : "Strip trailing directory (patches/ or patches/variants/) to get project root",
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 5,
									"outlettype" : [ "", "", "", "", "" ],
									"patching_rect" : [ 50.0, 190.0, 280.0, 22.0 ],
									"text" : "regexp (.+[\\\\/]).+[\\\\/]$ @substitute %1"
								}
							},
							{
								"box" : {
									"id" : "obj-6",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 50.0, 230.0, 120.0, 22.0 ],
									"text" : "value feedbax_root"
								}
							},
							{
								"box" : {
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 50.0, 270.0, 280.0, 22.0 ],
									"text" : "sprintf symout folder %sinput/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 50.0, 310.0, 145.0, 22.0 ],
									"text" : "send feedbax_sticker_folder"
								}
							},
							{
								"box" : {
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 380.0, 270.0, 290.0, 22.0 ],
									"text" : "sprintf symout folder AS %sinput/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 380.0, 310.0, 165.0, 22.0 ],
									"text" : "send feedbax_as_sticker_folder"
								}
							},
							{
								"box" : {
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 50.0, 370.0, 230.0, 22.0 ],
									"text" : "sprintf symout prefix %sinput/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-12",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 50.0, 410.0, 150.0, 22.0 ],
									"text" : "send feedbax_sticker_prefix"
								}
							},
							{
								"box" : {
									"id" : "obj-13",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 350.0, 30.0, 300.0, 20.0 ],
									"text" : "Resolve project root for portable file paths"
								}
							}
						],
						"lines" : [
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-1", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-2", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-3", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-5", 0 ],
									"source" : [ "obj-4", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-5", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-5", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-7", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-5", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-9", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-5", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-11", 0 ]
								}
							}
						]
					},
					"patching_rect" : [ 10.0, 10.0, 85.0, 22.0 ],
					"saved_object_attributes" : {
						"description" : "",
						"digest" : "",
						"globalpatchername" : "",
						"tags" : ""
					},
					"text" : "p pathsetup"
				}
			},
			{
				"box" : {
					"id" : "obj-166",
					"maxclass" : "gswitch2",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 858.0, 297.0, 39.0, 32.0 ]
				}
			},
			{
				"box" : {
					"id" : "obj-165",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1087.0, 380.0, 50.0, 22.0 ]
				}
			},
			{
				"box" : {
					"id" : "obj-161",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 909.0, 257.0, 22.0, 22.0 ],
					"text" : "t b"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-123",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 882.0, -7.0, 88.0, 22.0 ],
					"presentation" : 1,
					"presentation_linecount" : 2,
					"presentation_rect" : [ 1067.0, 335.0, 83.0, 35.0 ],
					"text" : "dim 5120 1440"
				}
			},
			{
				"box" : {
					"id" : "obj-152",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 825.0, 160.0, 22.0, 22.0 ],
					"text" : "t b"
				}
			},
			{
				"box" : {
					"id" : "obj-149",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 979.0, 57.0, 22.0, 22.0 ],
					"text" : "t b"
				}
			},
			{
				"box" : {
					"id" : "obj-145",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 973.0, 94.0, 29.5, 22.0 ],
					"text" : "1"
				}
			},
			{
				"box" : {
					"id" : "obj-144",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 834.0, 105.0, 22.0, 22.0 ],
					"text" : "t b"
				}
			},
			{
				"box" : {
					"id" : "obj-133",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 863.0, 128.0, 29.5, 22.0 ],
					"text" : "0"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-174",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 825.0, 213.0, 72.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 841.0, 203.0, 83.0, 22.0 ],
					"text" : "pos -5120 0"
				}
			},
			{
				"box" : {
					"id" : "obj-170",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 899.0, 148.0, 24.0, 24.0 ]
				}
			},
			{
				"box" : {
					"id" : "obj-167",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 896.0, 184.0, 60.0, 22.0 ],
					"text" : "border $1"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-163",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1608.0, 142.0, 88.0, 22.0 ],
					"presentation" : 1,
					"presentation_linecount" : 2,
					"presentation_rect" : [ 1611.0, 142.0, 83.0, 35.0 ],
					"text" : "dim 5120 1440"
				}
			},
			{
				"box" : {
					"id" : "obj-160",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 844.0, 28.5, 22.0, 22.0 ],
					"text" : "t b"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-137",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 859.0, 67.0, 90.0, 22.0 ],
					"presentation" : 1,
					"presentation_linecount" : 2,
					"presentation_rect" : [ 837.0, 161.0, 83.0, 35.0 ],
					"text" : "size 5120 1440"
				}
			},
			{
				"box" : {
					"id" : "obj-135",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1295.0, 320.0, 88.0, 22.0 ],
					"text" : "dim 5120 1440"
				}
			},
			{
				"box" : {
					"id" : "obj-85",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1457.0, 63.0, 150.0, 20.0 ],
					"text" : "1080P + oversample"
				}
			},
			{
				"box" : {
					"id" : "obj-130",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1430.0, 98.0, 88.0, 22.0 ],
					"text" : "dim 2880 1620"
				}
			},
			{
				"box" : {
					"id" : "obj-122",
					"maxclass" : "button",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 1612.0, 263.0, 24.0, 24.0 ]
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-86",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1651.0, 408.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[128]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[11]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[2]"
				}
			},
			{
				"box" : {
					"id" : "obj-63",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 1532.0, 368.0, 22.0, 22.0 ],
					"text" : "t b"
				}
			},
			{
				"box" : {
					"id" : "obj-60",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 1578.0, 386.0, 29.5, 22.0 ],
					"text" : "/ 1."
				}
			},
			{
				"box" : {
					"id" : "obj-42",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 1628.0, 320.0, 50.0, 22.0 ]
				}
			},
			{
				"box" : {
					"id" : "obj-31",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 1559.0, 320.0, 50.0, 22.0 ]
				}
			},
			{
				"box" : {
					"id" : "obj-151",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 391.5, 204.0, 140.0, 22.0 ],
					"text" : "loadmess doublebuffer 1"
				}
			},
			{
				"box" : {
					"id" : "obj-146",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1638.0, 470.0, 76.0, 22.0 ],
					"text" : "r worldBump"
				}
			},
			{
				"box" : {
					"id" : "obj-98",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "float" ],
					"patching_rect" : [ 1619.0, 507.0, 29.5, 22.0 ],
					"text" : "t b f"
				}
			},
			{
				"box" : {
					"id" : "obj-93",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 1619.0, 544.0, 29.5, 22.0 ],
					"text" : "+ 0."
				}
			},
			{
				"box" : {
					"id" : "obj-82",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1751.0, 525.0, 29.5, 22.0 ],
					"text" : "0"
				}
			},
			{
				"box" : {
					"id" : "obj-59",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 167.0, 302.0, 29.5, 22.0 ],
					"text" : "100"
				}
			},
			{
				"box" : {
					"id" : "obj-58",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 398.0582469701767, 68.5, 51.0, 22.0 ],
					"text" : "r uiGain"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-101",
					"maxclass" : "flonum",
					"maximum" : 1.0,
					"minimum" : 0.0,
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1303.0, 684.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_longname" : "number[160]",
							"parameter_mmax" : 1.0,
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[15]",
							"parameter_type" : 0
						}
					},
					"varname" : "number[1]"
				}
			},
			{
				"box" : {
					"id" : "obj-105",
					"maxclass" : "newobj",
					"numinlets" : 5,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1178.0, 728.0, 147.0, 22.0 ],
					"text" : "pak erase_color 0. 0. 0. 1."
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-99",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1324.875, 383.0, 88.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1460.3499758807907, 283.4999849796295, 88.0, 22.0 ],
					"text" : "dim 7680 4320"
				}
			},
			{
				"box" : {
					"id" : "obj-96",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1234.0, 253.0, 67.0, 20.0 ],
					"text" : "ultrawide"
				}
			},
			{
				"box" : {
					"id" : "obj-95",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1246.0, 220.0, 55.0, 20.0 ],
					"text" : "ACD"
				}
			},
			{
				"box" : {
					"id" : "obj-54",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 449.0, 264.0, 65.0, 22.0 ],
					"text" : "r fswindow"
				}
			},
			{
				"box" : {
					"id" : "obj-53",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 260.0, 126.0, 67.0, 22.0 ],
					"text" : "s fswindow"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-29",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 187.0, 450.0, 48.0, 19.0 ],
					"text" : "s ctrlbang"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-23",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 317.0, 450.0, 50.0, 19.0 ],
					"text" : "s imgbang"
				}
			},
			{
				"box" : {
					"attr" : "doublebuffer",
					"id" : "obj-11",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 580.0, 264.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"id" : "obj-194",
					"int" : 1,
					"maxclass" : "gswitch2",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 389.0, 379.0, 39.0, 32.0 ]
				}
			},
			{
				"box" : {
					"fontname" : "Menlo Bold",
					"fontsize" : 18.0,
					"id" : "obj-24",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 0,
					"patcher" : {
						"fileversion" : 1,
						"appversion" : {
							"major" : 9,
							"minor" : 0,
							"revision" : 7,
							"architecture" : "x64",
							"modernui" : 1
						},
						"classnamespace" : "box",
						"rect" : [ 84.0, 131.0, 772.0, 549.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [
							{
								"box" : {
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 94.40000021457672, 7.0, 58.0, 22.0 ],
									"text" : "r savePic"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-7",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 180.05000066757202, 252.79999923706055, 353.6000024676323, 22.0 ],
									"text" : "output/1-7-2024-6-29-13.jpg"
								}
							},
							{
								"box" : {
									"id" : "obj-3",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 75.59999734163284, 390.6000007390976, 441.20000582933426, 22.0 ],
									"text" : "screencapture -t png -D 2 output/feedbaxStill6-20-2025-16-51-42.jpg"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-17",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 132.8499999642372, 324.80000030994415, 353.6000024676323, 22.0 ],
									"text" : "output/feedbaxStill6-20-2025-16-51-42.jpg"
								}
							},
							{
								"box" : {
									"id" : "obj-16",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 109.90000021457672, 53.99999934434891, 27.0, 27.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 93.09999996423721, 284.8000003695488, 341.0, 22.0 ],
									"text" : "combine output/ feedbaxStill date .jpg @triggers 2"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 109.90000021457672, 148.9999993443489, 32.5, 22.0 ],
									"text" : "join"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-12",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 109.90000021457672, 180.9999993443489, 132.0, 22.0 ],
									"text" : "tosymbol @separator -"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "list", "list", "int" ],
									"patching_rect" : [ 109.90000021457672, 118.99999934434891, 46.0, 22.0 ],
									"text" : "date"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 154.40000021457672, 469.0000008940697, 44.0, 22.0 ],
									"text" : "print 1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 109.90000021457672, 469.0000008940697, 34.0, 22.0 ],
									"text" : "print"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-8",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 93.09999996423721, 352.200000166893, 161.0, 22.0 ],
									"text" : "screencapture -t png -D 2 $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 109.90000021457672, 429.0000008940697, 33.0, 22.0 ],
									"text" : "shell"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-6",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 109.90000021457672, 87.99999934434891, 63.0, 22.0 ],
									"text" : "time, date"
								}
							}
						],
						"lines" : [
							{
								"patchline" : {
									"destination" : [ "obj-16", 0 ],
									"source" : [ "obj-1", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 2 ],
									"source" : [ "obj-12", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-13", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-17", 1 ],
									"order" : 0,
									"source" : [ "obj-14", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 0 ],
									"order" : 1,
									"source" : [ "obj-14", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-16", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-4", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-4", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 1 ],
									"source" : [ "obj-5", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-5", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-5", 0 ],
									"source" : [ "obj-6", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 1 ],
									"source" : [ "obj-7", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 1 ],
									"order" : 0,
									"source" : [ "obj-8", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-4", 0 ],
									"order" : 1,
									"source" : [ "obj-8", 0 ]
								}
							}
						]
					},
					"patching_rect" : [ 24.0, 156.0, 128.0, 29.0 ],
					"text" : "p StillSave",
					"textcolor" : [ 0.0, 1.0, 0.0, 1.0 ]
				}
			},
			{
				"box" : {
					"fontname" : "Menlo Bold",
					"fontsize" : 18.0,
					"id" : "obj-64",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 0,
					"patcher" : {
						"fileversion" : 1,
						"appversion" : {
							"major" : 9,
							"minor" : 0,
							"revision" : 7,
							"architecture" : "x64",
							"modernui" : 1
						},
						"classnamespace" : "box",
						"rect" : [ 101.0, 87.0, 1142.0, 779.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [
							{
								"box" : {
									"id" : "obj-55",
									"int" : 1,
									"maxclass" : "gswitch2",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 277.83333333333337, 630.0, 39.0, 32.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-22",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 164.0, 24.0, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-25",
									"linecount" : 18,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 29.0, 185.20001200000002, 50.0, 250.0 ],
									"text" : "4 -251.518661 68.19693 -138.861374 -0.233919 0.295343 -0.306857 0.87401 0. 0. 0. 1 102.977837"
								}
							},
							{
								"box" : {
									"id" : "obj-19",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 439.9569528592226, 460.50758730580515, 31.0, 22.0 ],
									"text" : "float"
								}
							},
							{
								"box" : {
									"id" : "obj-21",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 390.0, 422.19999699999994, 59.0, 22.0 ],
									"text" : "r ctrlbang"
								}
							},
							{
								"box" : {
									"id" : "obj-53",
									"linecount" : 3,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 353.25, 270.200012, 62.0, 47.0 ],
									"text" : "-.1 grab disable hack"
								}
							},
							{
								"box" : {
									"id" : "obj-43",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 846.0, 165.04854142665863, 150.0, 34.0 ],
									"text" : "removed toggles\n"
								}
							},
							{
								"box" : {
									"id" : "obj-31",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 484.0, 678.0, 60.0, 22.0 ],
									"text" : "zl.change"
								}
							},
							{
								"box" : {
									"id" : "obj-20",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 41.0, 717.3494004638901, 450.0, 22.0 ],
									"text" : "0. 0. 0. 0. 0. 0. 0. 0. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 347.25, 324.200012, 84.0, 22.0 ],
									"text" : "loadmess -0.1"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-60",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 383.0, 366.0, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-52",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1053.0, 372.0, 29.5, 22.0 ],
									"text" : "0"
								}
							},
							{
								"box" : {
									"id" : "obj-42",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 602.912613093853, 225.24271535873413, 115.0, 22.0 ],
									"text" : "s leap2HandsActive"
								}
							},
							{
								"box" : {
									"id" : "obj-18",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 602.912613093853, 193.2038808465004, 29.5, 22.0 ],
									"text" : "||"
								}
							},
							{
								"box" : {
									"id" : "obj-10",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 712.0, 154.0, 150.0, 20.0 ],
									"text" : "hands present"
								}
							},
							{
								"box" : {
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 184.0, 585.0, 100.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-9",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 478.5253359290182, 245.5, 22.0, 22.0 ],
									"text" : "t b"
								}
							},
							{
								"box" : {
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 434.0, 315.200012, 29.5, 22.0 ],
									"text" : "||"
								}
							},
							{
								"box" : {
									"id" : "obj-51",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 247.0, 21.0, 24.0, 24.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-49",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 339.0, 36.0, 57.0, 22.0 ],
									"text" : "active $1"
								}
							},
							{
								"box" : {
									"id" : "obj-46",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 620.7332353333336, 299.200012, 24.0, 24.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-47",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 620.7332353333336, 263.200012, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-45",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 775.1359212915474, 422.19999699999994, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-44",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 484.33333333333337, 368.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-41",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 85.0, 269.0, 24.0, 24.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-39",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 85.0, 233.0, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-38",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 110.0, 378.19999699999994, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-35",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 274.09092464284674, 297.200012, 62.0, 20.0 ],
									"text" : "Grab"
								}
							},
							{
								"box" : {
									"id" : "obj-36",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 284.04708971531454, 378.19999699999994, 36.0, 22.0 ],
									"text" : "> 0.8"
								}
							},
							{
								"box" : {
									"id" : "obj-37",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 278.04708971531454, 326.0, 47.0, 22.0 ],
									"text" : "zl nth 8"
								}
							},
							{
								"box" : {
									"id" : "obj-33",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 390.0, 565.0, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-27",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 880.0909246428467, 324.200012, 62.0, 20.0 ],
									"text" : "Grab"
								}
							},
							{
								"box" : {
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 824.4503248598235, 378.19999699999994, 36.0, 22.0 ],
									"text" : "> 0.8"
								}
							},
							{
								"box" : {
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 871.5, 323.200012, 47.0, 22.0 ],
									"text" : "zl nth 5"
								}
							},
							{
								"box" : {
									"id" : "obj-124",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 846.0, 448.0, 98.0, 22.0 ],
									"text" : "scale -1. 1. 1. -1."
								}
							},
							{
								"box" : {
									"id" : "obj-123",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "float", "float", "float" ],
									"patching_rect" : [ 720.1359212915474, 318.44659757614136, 87.0, 22.0 ],
									"text" : "unpack 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-121",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 720.1359212915474, 282.52426797151566, 55.0, 22.0 ],
									"text" : "zl slice 3"
								}
							},
							{
								"box" : {
									"id" : "obj-119",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 530.0, 336.0, 55.0, 22.0 ],
									"text" : "zl slice 3"
								}
							},
							{
								"box" : {
									"id" : "obj-120",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 501.0, 299.200012, 55.0, 22.0 ],
									"text" : "zl slice 1"
								}
							},
							{
								"box" : {
									"id" : "obj-114",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 164.33333333333337, 332.0, 55.0, 22.0 ],
									"text" : "zl slice 3"
								}
							},
							{
								"box" : {
									"id" : "obj-113",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 135.33333333333337, 295.200012, 55.0, 22.0 ],
									"text" : "zl slice 1"
								}
							},
							{
								"box" : {
									"id" : "obj-6",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 422.33333333333337, 603.0, 24.0, 24.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 484.33333333333337, 630.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-23",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 880.0909246428467, 583.4852004678955, 44.0, 20.0 ],
									"text" : "theta",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-61",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 820.9503248598234, 583.4852004678955, 43.0, 20.0 ],
									"text" : "scale",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-24",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 759.7274959340715, 583.4852004678955, 45.0, 20.0 ],
									"text" : "yshift",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-12",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 702.669125293777, 583.4852004678955, 41.0, 20.0 ],
									"text" : "xshift",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-14",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 599.8017135134512, 583.4852004678955, 85.0, 20.0 ],
									"text" : "scalebright",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-15",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 545.8666865872497, 583.4852004678955, 38.0, 20.0 ],
									"text" : "bias",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-16",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 495.05500337514115, 583.4852004678955, 35.0, 20.0 ],
									"text" : "hue",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-26",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 940.2726389972341, 583.4852004678955, 33.0, 20.0 ],
									"text" : "NC",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-17",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 989.002093066614, 583.4852004678955, 36.0, 20.0 ],
									"text" : "sat",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-75",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "float", "float", "float" ],
									"patching_rect" : [ 842.4506293137869, 489.9802419982376, 87.0, 22.0 ],
									"text" : "unpack 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-76",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 482.8888933261236, 489.9802419982376, 111.0, 22.0 ],
									"text" : "scale -20. 35. 1. -1."
								}
							},
							{
								"box" : {
									"id" : "obj-79",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 511.5, 717.3494004638901, 92.0, 22.0 ],
									"text" : "s shadeCtlLeap"
								}
							},
							{
								"box" : {
									"id" : "obj-94",
									"maxclass" : "newobj",
									"numinlets" : 9,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 507.05500337514115, 556.4852004678955, 517.9470896914728, 22.0 ],
									"text" : "pack 0. 0. 0. 0. 0. 0. 0. 0. 1."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-83",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 599.7332353333335, 489.9802419982376, 107.0, 22.0 ],
									"text" : "scale 20. 50. 1. -1."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-84",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 277.83333333333337, 496.666656, 108.0, 22.0 ],
									"text" : "scale -15 15. -1. 1."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-85",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 142.83333333333337, 422.19999699999994, 88.0, 22.0 ],
									"text" : "vexpr $f1 * 0.1"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-86",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 40.58348633333338, 496.666656, 101.0, 22.0 ],
									"text" : "scale -20 0. -1. 1."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-87",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 160.83348633333338, 496.666656, 104.0, 22.0 ],
									"text" : "scale 14 50. -1. 1."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-88",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "float", "float", "float" ],
									"patching_rect" : [ 140.1334741263022, 450.1999816894531, 89.0, 22.0 ],
									"text" : "unpack 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 717.5680412553075, 489.9802419982376, 108.0, 22.0 ],
									"text" : "scale -20 20. -1. 1."
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-92",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "float", "float", "float" ],
									"patching_rect" : [ 594.8333333333334, 450.0, 89.0, 22.0 ],
									"text" : "unpack 0. 0. 0."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-93",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 594.8333333333334, 419.0, 88.0, 22.0 ],
									"text" : "vexpr $f1 * 0.1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 627.5833333333334, 107.0, 80.0, 22.0 ],
									"text" : "s frame_info"
								}
							},
							{
								"box" : {
									"id" : "obj-34",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "int", "int", "int", "float" ],
									"patching_rect" : [ 454.0, 157.0, 198.0, 22.0 ],
									"text" : "unpack i i i f"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-30",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 255.83333333333337, 107.0, 84.0, 22.0 ],
									"text" : "s right_fingers"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-32",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 131.91666666666669, 107.0, 77.0, 22.0 ],
									"text" : "s left_fingers"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-28",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 503.6666666666667, 107.0, 80.0, 22.0 ],
									"text" : "s right_hand"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-29",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 379.75, 107.0, 75.0, 22.0 ],
									"text" : "s left_hand"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-117",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 0,
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 225.0, 233.0, 634.0, 174.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-28",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 233.5, 51.0, 80.0, 22.0 ],
													"text" : "r right_hand"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-29",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 219.5, 25.0, 75.0, 22.0 ],
													"text" : "r left_hand"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-30",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 93.5, 42.0, 84.0, 22.0 ],
													"text" : "r right_fingers"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-3",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 9.5, 42.0, 77.0, 22.0 ],
													"text" : "r left_fingers"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 9.5, 91.0, 79.0, 22.0 ],
													"saved_object_attributes" : {
														"embed" : 0,
														"precision" : 6
													},
													"text" : "coll fingers_L"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 93.5, 91.0, 81.0, 22.0 ],
													"saved_object_attributes" : {
														"embed" : 0,
														"precision" : 6
													},
													"text" : "coll fingers_R"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-100",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 392.0, 42.0, 76.0, 22.0 ],
													"text" : "r leap_frame"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-114",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 513.5, 14.0, 84.0, 22.0 ],
													"text" : "r start_frame"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-13",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 513.5, 45.0, 37.0, 22.0 ],
													"text" : "clear"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-11",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 219.5, 91.0, 65.0, 22.0 ],
													"saved_object_attributes" : {
														"embed" : 0,
														"precision" : 6
													},
													"text" : "coll hands"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-14",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 392.0, 91.0, 63.0, 22.0 ],
													"saved_object_attributes" : {
														"embed" : 0,
														"precision" : 6
													},
													"text" : "coll frame"
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-14", 0 ],
													"source" : [ "obj-100", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-13", 0 ],
													"source" : [ "obj-114", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"midpoints" : [ 523.0, 78.5, 103.0, 78.5 ],
													"order" : 2,
													"source" : [ "obj-13", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-11", 0 ],
													"midpoints" : [ 523.0, 78.5, 229.0, 78.5 ],
													"order" : 1,
													"source" : [ "obj-13", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-14", 0 ],
													"midpoints" : [ 523.0, 78.5, 401.5, 78.5 ],
													"order" : 0,
													"source" : [ "obj-13", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-2", 0 ],
													"midpoints" : [ 523.0, 78.5, 19.0, 78.5 ],
													"order" : 3,
													"source" : [ "obj-13", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-11", 0 ],
													"source" : [ "obj-28", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-11", 0 ],
													"source" : [ "obj-29", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-3", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-30", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 131.91666666666669, 137.5, 77.0, 22.0 ],
									"text" : "p fill_coll"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-111",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 8.0, 107.0, 78.0, 22.0 ],
									"text" : "s end_frame"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-110",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 751.5, 107.0, 80.0, 22.0 ],
									"text" : "s start_frame"
								}
							},
							{
								"box" : {
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 10,
									"outlettype" : [ "anything", "anything", "anything", "anything", "anything", "anything", "anything", "anything", "anything", "anything" ],
									"patching_rect" : [ 8.0, 75.0, 762.5, 22.0 ],
									"text" : "ultraleap"
								}
							}
						],
						"lines" : [
							{
								"patchline" : {
									"destination" : [ "obj-110", 0 ],
									"source" : [ "obj-1", 6 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-111", 0 ],
									"source" : [ "obj-1", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"order" : 1,
									"source" : [ "obj-1", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-120", 0 ],
									"order" : 1,
									"source" : [ "obj-1", 4 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-28", 0 ],
									"order" : 0,
									"source" : [ "obj-1", 4 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-29", 0 ],
									"order" : 0,
									"source" : [ "obj-1", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"order" : 0,
									"source" : [ "obj-1", 5 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-1", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-32", 0 ],
									"source" : [ "obj-1", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-34", 0 ],
									"midpoints" : [ 430.55555555555554, 148.0, 463.5, 148.0 ],
									"order" : 1,
									"source" : [ "obj-1", 5 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-31", 0 ],
									"source" : [ "obj-11", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-114", 0 ],
									"source" : [ "obj-113", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-37", 0 ],
									"source" : [ "obj-114", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-38", 1 ],
									"source" : [ "obj-114", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-121", 0 ],
									"source" : [ "obj-119", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-44", 1 ],
									"source" : [ "obj-119", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-119", 0 ],
									"source" : [ "obj-120", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-123", 0 ],
									"source" : [ "obj-121", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-121", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-45", 1 ],
									"source" : [ "obj-123", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-75", 0 ],
									"source" : [ "obj-124", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-44", 0 ],
									"order" : 1,
									"source" : [ "obj-13", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-45", 0 ],
									"order" : 0,
									"source" : [ "obj-13", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-42", 0 ],
									"source" : [ "obj-18", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 0 ],
									"source" : [ "obj-19", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-21", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-51", 0 ],
									"source" : [ "obj-22", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-55", 1 ],
									"order" : 1,
									"source" : [ "obj-31", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-79", 0 ],
									"order" : 0,
									"source" : [ "obj-31", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-33", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 1 ],
									"order" : 0,
									"source" : [ "obj-34", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 0 ],
									"order" : 0,
									"source" : [ "obj-34", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-7", 1 ],
									"order" : 1,
									"source" : [ "obj-34", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-7", 0 ],
									"order" : 2,
									"source" : [ "obj-34", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-9", 0 ],
									"order" : 1,
									"source" : [ "obj-34", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-38", 0 ],
									"source" : [ "obj-36", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-36", 0 ],
									"source" : [ "obj-37", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-85", 0 ],
									"source" : [ "obj-38", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-41", 0 ],
									"source" : [ "obj-39", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 5 ],
									"source" : [ "obj-4", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-38", 0 ],
									"source" : [ "obj-41", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-93", 0 ],
									"source" : [ "obj-44", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-124", 0 ],
									"source" : [ "obj-45", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-44", 0 ],
									"order" : 1,
									"source" : [ "obj-46", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-45", 0 ],
									"order" : 0,
									"source" : [ "obj-46", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-46", 0 ],
									"source" : [ "obj-47", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-49", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-60", 0 ],
									"source" : [ "obj-5", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-49", 0 ],
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 1 ],
									"source" : [ "obj-52", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-20", 1 ],
									"source" : [ "obj-55", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-6", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 1 ],
									"order" : 0,
									"source" : [ "obj-60", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-36", 1 ],
									"order" : 1,
									"source" : [ "obj-60", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-7", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 7 ],
									"source" : [ "obj-75", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 6 ],
									"source" : [ "obj-75", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 3 ],
									"source" : [ "obj-76", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-8", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 4 ],
									"source" : [ "obj-83", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 2 ],
									"source" : [ "obj-84", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-88", 0 ],
									"source" : [ "obj-85", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-19", 1 ],
									"source" : [ "obj-86", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 1 ],
									"source" : [ "obj-87", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-84", 0 ],
									"source" : [ "obj-88", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-86", 0 ],
									"source" : [ "obj-88", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-87", 0 ],
									"source" : [ "obj-88", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-9", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-92", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-76", 0 ],
									"source" : [ "obj-92", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-83", 0 ],
									"source" : [ "obj-92", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-92", 0 ],
									"source" : [ "obj-93", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 1 ],
									"source" : [ "obj-94", 0 ]
								}
							}
						],
						"boxgroups" : [
							{
								"boxes" : [
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
					},
					"patching_rect" : [ 23.5, 114.5, 139.0, 29.0 ],
					"text" : "p LeapGemini",
					"textcolor" : [ 0.0, 1.0, 0.0, 1.0 ]
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-27",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1318.0, 253.0, 88.0, 22.0 ],
					"presentation" : 1,
					"presentation_linecount" : 2,
					"presentation_rect" : [ 1550.25, 150.06430828746034, 83.0, 35.0 ],
					"text" : "dim 3440 1440"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-21",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1318.0, 190.0, 88.0, 22.0 ],
					"presentation" : 1,
					"presentation_linecount" : 2,
					"presentation_rect" : [ 1548.0, 196.06430828746034, 83.0, 35.0 ],
					"text" : "dim 2560 1080"
				}
			},
			{
				"box" : {
					"id" : "obj-5",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1079.0, 506.0, 70.0, 22.0 ],
					"text" : "loadmess 1"
				}
			},
			{
				"box" : {
					"id" : "obj-220",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1261.0, 125.0, 55.0, 20.0 ],
					"text" : "iPad"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-216",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1318.0, 125.0, 88.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1279.0, 619.3000035881996, 88.0, 22.0 ],
					"text" : "dim 1366 1024"
				}
			},
			{
				"box" : {
					"id" : "obj-213",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1306.0, 468.0, 51.0, 22.0 ],
					"text" : "r xyratio"
				}
			},
			{
				"box" : {
					"id" : "obj-212",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1481.0, 249.0, 53.0, 22.0 ],
					"text" : "s xyratio"
				}
			},
			{
				"box" : {
					"id" : "obj-211",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 298.0, 316.0, 71.0, 22.0 ],
					"text" : "r FPSconfig"
				}
			},
			{
				"box" : {
					"id" : "obj-210",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 77.0, 420.0, 73.0, 22.0 ],
					"text" : "s FPSconfig"
				}
			},
			{
				"box" : {
					"id" : "obj-209",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 94.0, 354.0, 41.0, 20.0 ],
					"text" : "FPS"
				}
			},
			{
				"box" : {
					"id" : "obj-207",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1098.0, 233.0, 65.49999994039536, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1037.25, 472.9000023007393, 30.0, 20.0 ],
					"text" : "MS"
				}
			},
			{
				"box" : {
					"id" : "obj-205",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 461.0, 54.0, 77.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 908.5, 112.40000230073929, 93.0, 20.0 ],
					"text" : "Audio Gain"
				}
			},
			{
				"box" : {
					"id" : "obj-203",
					"maxclass" : "meter~",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 517.0, 85.0, 14.0, 104.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 964.4999999403954, 136.9000023007393, 14.0, 104.0 ]
				}
			},
			{
				"box" : {
					"focusbordercolor" : [ 0.757527, 0.757527, 0.757527, 1.0 ],
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-332",
					"maxclass" : "live.slider",
					"modulationcolor" : [ 0.431373, 0.752941, 0.890196, 1.0 ],
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "float" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 462.0, 85.0, 57.0, 104.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 908.5, 136.9000023007393, 57.0, 104.0 ],
					"saved_attribute_attributes" : {
						"focusbordercolor" : {
							"expression" : ""
						},
						"modulationcolor" : {
							"expression" : ""
						},
						"slidercolor" : {
							"expression" : ""
						},
						"textcolor" : {
							"expression" : ""
						},
						"tribordercolor" : {
							"expression" : ""
						},
						"tricolor" : {
							"expression" : ""
						},
						"valueof" : {
							"parameter_initial" : [ 1.0 ],
							"parameter_initial_enable" : 1,
							"parameter_longname" : "Audio Gain",
							"parameter_mmax" : 2.0,
							"parameter_modmode" : 0,
							"parameter_shortname" : "Audio Gain",
							"parameter_type" : 0,
							"parameter_unitstyle" : 1
						}
					},
					"showname" : 0,
					"slidercolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"textcolor" : [ 0.25, 0.25, 0.25, 1.0 ],
					"tribordercolor" : [ 0.75, 0.75, 0.75, 1.0 ],
					"tricolor" : [ 0.25, 0.25, 0.25, 1.0 ],
					"varname" : "live.slider[1]"
				}
			},
			{
				"box" : {
					"id" : "obj-199",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1242.0, 26.0, 150.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1099.0, 105.0, 67.0, 20.0 ],
					"text" : "Resolution"
				}
			},
			{
				"box" : {
					"id" : "obj-197",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1303.0, 355.0, 83.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1110.0, 386.0, 83.0, 20.0 ],
					"text" : "EXTREME"
				}
			},
			{
				"box" : {
					"id" : "obj-195",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1290.0, 439.0, 150.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1175.0, 460.5, 150.0, 20.0 ],
					"text" : "Scale main video plane"
				}
			},
			{
				"box" : {
					"id" : "obj-193",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "float" ],
					"patching_rect" : [ 1321.0, 496.0, 29.5, 22.0 ],
					"text" : "t b f"
				}
			},
			{
				"box" : {
					"id" : "obj-192",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1392.0, 294.0, 87.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1175.0, 432.9000023007393, 87.0, 20.0 ],
					"text" : "W:H Ratio"
				}
			},
			{
				"box" : {
					"id" : "obj-191",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1183.0, 58.0, 50.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1115.5, 136.9000023007393, 50.0, 20.0 ],
					"text" : "4:3"
				}
			},
			{
				"box" : {
					"id" : "obj-190",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1333.0, 63.0, 50.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1118.0, 256.4000023007393, 50.0, 20.0 ],
					"text" : "16x10"
				}
			},
			{
				"box" : {
					"id" : "obj-189",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1183.0, 105.0, 50.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1115.5, 184.0, 50.0, 20.0 ],
					"text" : "16x9"
				}
			},
			{
				"box" : {
					"id" : "obj-187",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1452.0, 134.0, 68.0, 22.0 ],
					"text" : "r resolution"
				}
			},
			{
				"box" : {
					"id" : "obj-186",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1202.0, 772.0, 68.0, 22.0 ],
					"text" : "r resolution"
				}
			},
			{
				"box" : {
					"id" : "obj-185",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1219.875, 401.0, 70.0, 22.0 ],
					"text" : "s resolution"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-181",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1481.0, 294.0, 50.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1123.0, 432.9000023007393, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[117]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[117]",
							"parameter_type" : 3
						}
					},
					"varname" : "number"
				}
			},
			{
				"box" : {
					"id" : "obj-180",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 1493.0, 199.0, 29.5, 22.0 ],
					"text" : "/ 1."
				}
			},
			{
				"box" : {
					"id" : "obj-15",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "int", "int" ],
					"patching_rect" : [ 1457.0, 166.0, 90.0, 22.0 ],
					"text" : "unpack dim 0 0"
				}
			},
			{
				"box" : {
					"id" : "obj-4",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 1139.0, 536.0, 58.0, 22.0 ],
					"text" : "loadbang"
				}
			},
			{
				"box" : {
					"id" : "obj-182",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 48.0, 890.0, 82.0, 22.0 ],
					"text" : "@mode static"
				}
			},
			{
				"box" : {
					"id" : "obj-159",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 0,
					"patcher" : {
						"fileversion" : 1,
						"appversion" : {
							"major" : 9,
							"minor" : 0,
							"revision" : 7,
							"architecture" : "x64",
							"modernui" : 1
						},
						"classnamespace" : "box",
						"rect" : [ 766.0, 106.0, 640.0, 480.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [
							{
								"box" : {
									"id" : "obj-2",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 229.0, 41.0, 29.5, 22.0 ],
									"text" : "12"
								}
							},
							{
								"box" : {
									"id" : "obj-105",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 185.0, 24.5, 29.5, 22.0 ],
									"text" : "8"
								}
							},
							{
								"box" : {
									"id" : "obj-102",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 149.0, 24.5, 29.5, 22.0 ],
									"text" : "6"
								}
							},
							{
								"box" : {
									"id" : "obj-101",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 112.0, 24.5, 29.5, 22.0 ],
									"text" : "4"
								}
							},
							{
								"box" : {
									"id" : "obj-54",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 28.5, 26.9000244140625, 70.0, 22.0 ],
									"text" : "loadmess 4"
								}
							},
							{
								"box" : {
									"id" : "obj-63",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 64.5, 61.5, 107.0, 22.0 ],
									"text" : "s lineSmoothGrain"
								}
							},
							{
								"box" : {
									"id" : "obj-100",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "bang", "bang", "" ],
									"patching_rect" : [ 633.0, 148.0, 44.0, 22.0 ],
									"text" : "sel 0 1"
								}
							},
							{
								"box" : {
									"id" : "obj-99",
									"linecount" : 2,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 685.0, 146.0, 96.0, 35.0 ],
									"text" : ";\rmax showcursor"
								}
							},
							{
								"box" : {
									"id" : "obj-98",
									"linecount" : 2,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 685.0, 206.0, 91.0, 35.0 ],
									"text" : ";\rmax hidecursor"
								}
							}
						],
						"lines" : [
							{
								"patchline" : {
									"destination" : [ "obj-98", 0 ],
									"source" : [ "obj-100", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-99", 0 ],
									"source" : [ "obj-100", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-63", 0 ],
									"source" : [ "obj-101", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-63", 0 ],
									"source" : [ "obj-102", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-63", 0 ],
									"source" : [ "obj-105", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-63", 0 ],
									"source" : [ "obj-2", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-63", 0 ],
									"source" : [ "obj-54", 0 ]
								}
							}
						]
					},
					"patching_rect" : [ 30.09708696603775, 225.24271535873413, 43.0, 22.0 ],
					"text" : "p misc"
				}
			},
			{
				"box" : {
					"id" : "obj-155",
					"linecount" : 3,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 1012.0, 16.0, 69.0, 47.0 ],
					"presentation" : 1,
					"presentation_linecount" : 3,
					"presentation_rect" : [ 1020.25, 101.5, 69.0, 47.0 ],
					"text" : "Control Smoothing MS"
				}
			},
			{
				"box" : {
					"id" : "obj-94",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 195.5, 60.234463423490524, 31.0, 20.0 ],
					"text" : "FS"
				}
			},
			{
				"box" : {
					"id" : "obj-126",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1055.0, 208.0, 35.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1037.25, 424.9000023007393, 35.0, 22.0 ],
					"text" : "8000"
				}
			},
			{
				"box" : {
					"id" : "obj-141",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1012.0, 146.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.25, 230.9000023007393, 29.5, 22.0 ],
					"text" : "25"
				}
			},
			{
				"box" : {
					"id" : "obj-140",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1012.0, 118.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.25, 202.4000023007393, 29.5, 22.0 ],
					"text" : "20"
				}
			},
			{
				"box" : {
					"id" : "obj-125",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 139.0, 323.0, 29.5, 22.0 ],
					"text" : "120"
				}
			},
			{
				"box" : {
					"id" : "obj-124",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 139.0, 278.0, 29.5, 22.0 ],
					"text" : "90"
				}
			},
			{
				"box" : {
					"id" : "obj-66",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 139.0, 216.5048514008522, 29.5, 22.0 ],
					"text" : "30"
				}
			},
			{
				"box" : {
					"id" : "obj-65",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 139.0, 248.0, 29.5, 22.0 ],
					"text" : "60"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-121",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1801.0, 571.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[63]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[32]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[27]"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-120",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1745.0, 571.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[62]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[32]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[26]"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-117",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1690.0, 571.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[32]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[32]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[25]"
				}
			},
			{
				"box" : {
					"id" : "obj-116",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1055.0, 184.0, 35.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1037.25, 400.9000023007393, 35.0, 22.0 ],
					"text" : "2000"
				}
			},
			{
				"box" : {
					"fontname" : "Menlo Bold",
					"fontsize" : 24.0,
					"id" : "obj-83",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 0,
					"patcher" : {
						"fileversion" : 1,
						"appversion" : {
							"major" : 9,
							"minor" : 0,
							"revision" : 7,
							"architecture" : "x64",
							"modernui" : 1
						},
						"classnamespace" : "box",
						"rect" : [ 34.0, 88.0, 1057.0, 825.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [
							{
								"box" : {
									"id" : "obj-152",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 215.0, 20.0, 150.0, 20.0 ],
									"text" : "Navi"
								}
							},
							{
								"box" : {
									"id" : "obj-316",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 296.0, 559.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[18]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[18]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[18]"
								}
							},
							{
								"box" : {
									"id" : "obj-307",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 325.0, 586.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-279",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 329.0, 533.0, 62.0, 22.0 ],
									"text" : "r imgbang"
								}
							},
							{
								"box" : {
									"attr" : "capture",
									"id" : "obj-262",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 256.0, 656.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-183",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 564.0, 531.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[17]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[17]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[17]"
								}
							},
							{
								"box" : {
									"id" : "obj-170",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 554.0, 568.0, 91.0, 22.0 ],
									"text" : "outputmatrix $1"
								}
							},
							{
								"box" : {
									"id" : "obj-77",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 337.0, 191.0, 388.0, 22.0 ],
									"text" : "folder input/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-44",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 189.0, 120.0, 422.0, 22.0 ],
									"text" : "folder input/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-19",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 200.0, 144.0, 428.0, 22.0 ],
									"text" : "folder input/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-10",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 175.0, 92.0, 526.0, 22.0 ],
									"text" : "folder input/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-7",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 265.0, 9.0, 560.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 4,
									"presentation_rect" : [ 293.0, 83.0, 220.0, 62.0 ],
									"text" : "folder input/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-336",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1047.0, 45.0, 80.0, 22.0 ],
									"text" : "loadmess 1.5"
								}
							},
							{
								"box" : {
									"id" : "obj-335",
									"linecount" : 2,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1008.0, 534.0, 24.0, 35.0 ],
									"text" : "1.1"
								}
							},
							{
								"box" : {
									"id" : "obj-333",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 954.0, 45.0, 87.0, 22.0 ],
									"text" : "loadmess 1.55"
								}
							},
							{
								"box" : {
									"id" : "obj-331",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 861.0, 45.0, 87.0, 22.0 ],
									"text" : "loadmess 1.55"
								}
							},
							{
								"box" : {
									"id" : "obj-330",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1226.0, 288.0, 29.0, 20.0 ],
									"text" : "Sat",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontsize" : 12.0,
									"id" : "obj-329",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1183.0, 288.0, 37.0, 20.0 ],
									"text" : "Cont",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-328",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1147.0, 288.0, 29.0, 20.0 ],
									"text" : "Brt",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-326",
									"maxclass" : "slider",
									"min" : -2.0,
									"mult" : 2.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1223.0, 312.0, 34.0, 72.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[25]",
											"parameter_mmax" : 0.0,
											"parameter_mmin" : -2.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "slider[3]",
											"parameter_type" : 0
										}
									},
									"size" : 2.0,
									"varname" : "slider[8]"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-325",
									"maxclass" : "slider",
									"min" : -2.0,
									"mult" : 2.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1184.0, 312.0, 34.0, 72.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[24]",
											"parameter_mmax" : 0.0,
											"parameter_mmin" : -2.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "slider[3]",
											"parameter_type" : 0
										}
									},
									"size" : 2.0,
									"varname" : "slider[7]"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-322",
									"maxclass" : "slider",
									"min" : -2.0,
									"mult" : 2.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1144.0, 312.0, 34.0, 72.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[23]",
											"parameter_mmax" : 0.0,
											"parameter_mmin" : -2.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "slider[3]",
											"parameter_type" : 0
										}
									},
									"size" : 2.0,
									"varname" : "slider[6]"
								}
							},
							{
								"box" : {
									"id" : "obj-321",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1035.0, 322.0, 96.0, 20.0 ],
									"text" : "BRCOSA adjust"
								}
							},
							{
								"box" : {
									"id" : "obj-319",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1007.0, 320.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[60]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[60]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[16]"
								}
							},
							{
								"box" : {
									"id" : "obj-317",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "jit_gl_texture" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 59.0, 106.0, 758.0, 760.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"comment" : "Saturation",
													"id" : "obj-8",
													"index" : 4,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 650.0, 416.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"comment" : "Contrast",
													"id" : "obj-7",
													"index" : 3,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 573.0, 416.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"comment" : "Brightness",
													"id" : "obj-3",
													"index" : 2,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 499.0, 416.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 643.5, 543.0, 57.0, 22.0 ],
													"text" : "clip -2. 2."
												}
											},
											{
												"box" : {
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 577.0, 543.0, 57.0, 22.0 ],
													"text" : "clip -2. 2."
												}
											},
											{
												"box" : {
													"id" : "obj-64",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 504.0, 543.0, 57.0, 22.0 ],
													"text" : "clip -2. 2."
												}
											},
											{
												"box" : {
													"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"hint" : "Move this control to set the saturation of the output.",
													"id" : "obj-140",
													"maxclass" : "live.dial",
													"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "float" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 650.0, 459.0, 44.0, 48.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 140.4748077392578, 40.792236328125, 60.0, 48.0 ],
													"saved_attribute_attributes" : {
														"activedialcolor" : {
															"expression" : ""
														},
														"activeneedlecolor" : {
															"expression" : ""
														},
														"dialcolor" : {
															"expression" : ""
														},
														"needlecolor" : {
															"expression" : ""
														},
														"valueof" : {
															"parameter_initial" : [ 4.0 ],
															"parameter_initial_enable" : 1,
															"parameter_longname" : "Saturation[1]",
															"parameter_mmax" : 8.0,
															"parameter_mmin" : -8.0,
															"parameter_modmode" : 0,
															"parameter_shortname" : "Saturation",
															"parameter_type" : 0,
															"parameter_unitstyle" : 1
														}
													},
													"varname" : "Freq[2]"
												}
											},
											{
												"box" : {
													"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"hint" : "Move this control to set the contrast of the output.",
													"id" : "obj-127",
													"maxclass" : "live.dial",
													"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "float" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 573.0, 459.0, 44.0, 48.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 71.97479248046875, 40.792236328125, 60.0, 48.0 ],
													"saved_attribute_attributes" : {
														"activedialcolor" : {
															"expression" : ""
														},
														"activeneedlecolor" : {
															"expression" : ""
														},
														"dialcolor" : {
															"expression" : ""
														},
														"needlecolor" : {
															"expression" : ""
														},
														"valueof" : {
															"parameter_initial" : [ 6.0 ],
															"parameter_initial_enable" : 1,
															"parameter_longname" : "Contrast[1]",
															"parameter_mmax" : 8.0,
															"parameter_mmin" : -8.0,
															"parameter_modmode" : 0,
															"parameter_shortname" : "Contrast",
															"parameter_type" : 0,
															"parameter_unitstyle" : 1
														}
													},
													"varname" : "Freq[1]"
												}
											},
											{
												"box" : {
													"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"hint" : "Move this control to set the brightness of the output.",
													"id" : "obj-119",
													"maxclass" : "live.dial",
													"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "float" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 504.0, 463.0, 44.0, 48.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 3.474807977676392, 40.792236328125, 60.0, 48.0 ],
													"saved_attribute_attributes" : {
														"activedialcolor" : {
															"expression" : ""
														},
														"activeneedlecolor" : {
															"expression" : ""
														},
														"dialcolor" : {
															"expression" : ""
														},
														"needlecolor" : {
															"expression" : ""
														},
														"valueof" : {
															"parameter_initial" : [ 1.0 ],
															"parameter_initial_enable" : 1,
															"parameter_longname" : "Brightness[1]",
															"parameter_mmax" : 8.0,
															"parameter_mmin" : -8.0,
															"parameter_modmode" : 0,
															"parameter_shortname" : "Brightness",
															"parameter_type" : 0,
															"parameter_unitstyle" : 1
														}
													},
													"varname" : "Freq"
												}
											},
											{
												"box" : {
													"id" : "obj-10",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 282.0, 563.0, 70.0, 22.0 ],
													"text" : "loadmess 1"
												}
											},
											{
												"box" : {
													"id" : "obj-15",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 249.0, 663.3333315849304, 20.0, 22.0 ],
													"text" : "t l"
												}
											},
											{
												"box" : {
													"color" : [ 0.941176, 0.690196, 0.196078, 1.0 ],
													"id" : "obj-4",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "jit_gl_texture", "" ],
													"patching_rect" : [ 210.0, 760.0, 125.0, 22.0 ],
													"text" : "jit.gl.pix @gen brcosa"
												}
											},
											{
												"box" : {
													"color" : [ 0.941176, 0.690196, 0.196078, 1.0 ],
													"id" : "obj-13",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 249.0, 716.0, 67.0, 22.0 ],
													"text" : "vzgl-object"
												}
											},
											{
												"box" : {
													"align" : 2,
													"bgcolor" : [ 0.3, 0.3, 0.3, 1.0 ],
													"bgoncolor" : [ 0.165741, 0.364658, 0.14032, 1.0 ],
													"fontname" : "Ableton Sans Bold Regular",
													"hint" : "The BRCOSR module (based on the jit.brcosa object) is the official Vizzie \"do not adjust your set\" color module for image fun. You can modify your image's brightness, image contrast, and color saturation individually or together. The module also allows you to not only work with nice big ranges of values, but also to invert some of them for very different results.",
													"id" : "obj-6",
													"legacytextcolor" : 1,
													"maxclass" : "textbutton",
													"mode" : 1,
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "", "", "int" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 282.0, 603.0, 40.0, 20.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 0.474808007478714, 15.0, 208.0, 19.0 ],
													"saved_attribute_attributes" : {
														"valueof" : {
															"parameter_enum" : [ "off", "on" ],
															"parameter_initial" : [ 1 ],
															"parameter_initial_enable" : 1,
															"parameter_invisible" : 1,
															"parameter_longname" : "range[9]",
															"parameter_mmax" : 1.0,
															"parameter_modmode" : 0,
															"parameter_shortname" : "range",
															"parameter_type" : 3
														}
													},
													"text" : "OFF  ",
													"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"textjustification" : 2,
													"texton" : "ON  ",
													"textoncolor" : [ 0.905882, 0.909804, 0.917647, 1.0 ],
													"usebgoncolor" : 1,
													"varname" : "FreqMode[3]"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-143",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 650.0, 584.0, 80.0, 23.0 ],
													"text" : "saturation $1"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-130",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 573.0, 584.0, 72.0, 23.0 ],
													"text" : "contrast $1"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-45",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 485.0, 584.0, 83.0, 23.0 ],
													"text" : "brightness $1"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-56",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "off" ],
													"patching_rect" : [ 188.0, 603.0, 85.0, 23.0 ],
													"text" : "video-handler"
												}
											},
											{
												"box" : {
													"comment" : "Video output",
													"id" : "obj-14",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 188.0, 799.0, 25.0, 25.0 ]
												}
											},
											{
												"box" : {
													"comment" : "Video input",
													"id" : "obj-5",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 188.0, 554.0, 25.0, 25.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-130", 0 ],
													"source" : [ "obj-1", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-6", 0 ],
													"source" : [ "obj-10", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-64", 0 ],
													"source" : [ "obj-119", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-127", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-4", 0 ],
													"midpoints" : [ 258.5, 748.5, 219.5, 748.5 ],
													"source" : [ "obj-13", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-15", 0 ],
													"midpoints" : [ 582.5, 642.0, 258.5, 642.0 ],
													"source" : [ "obj-130", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-140", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-15", 0 ],
													"midpoints" : [ 659.5, 642.0, 258.5, 642.0 ],
													"source" : [ "obj-143", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-4", 0 ],
													"midpoints" : [ 258.5, 707.6666651964188, 219.5, 707.6666651964188 ],
													"source" : [ "obj-15", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-143", 0 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-64", 0 ],
													"source" : [ "obj-3", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-14", 0 ],
													"source" : [ "obj-4", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-15", 0 ],
													"midpoints" : [ 494.5, 642.0, 258.5, 642.0 ],
													"source" : [ "obj-45", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-56", 0 ],
													"source" : [ "obj-5", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-13", 0 ],
													"order" : 0,
													"source" : [ "obj-56", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-14", 0 ],
													"source" : [ "obj-56", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-4", 0 ],
													"order" : 1,
													"source" : [ "obj-56", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-6", 0 ],
													"source" : [ "obj-56", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-56", 1 ],
													"source" : [ "obj-6", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-45", 0 ],
													"source" : [ "obj-64", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-7", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-8", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 936.0, 676.0, 156.0, 22.0 ],
									"text" : "p brcosaslab",
									"varname" : "brcosaslab"
								}
							},
							{
								"box" : {
									"id" : "obj-313",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1032.0, 294.0, 64.0, 20.0 ],
									"text" : "LumaLow"
								}
							},
							{
								"box" : {
									"id" : "obj-311",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1032.0, 267.0, 67.0, 20.0 ],
									"text" : "LumaHigh"
								}
							},
							{
								"box" : {
									"id" : "obj-308",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1007.0, 265.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[59]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[59]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[15]"
								}
							},
							{
								"box" : {
									"id" : "obj-305",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1007.0, 292.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[58]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[11]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[8]"
								}
							},
							{
								"box" : {
									"id" : "obj-301",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1483.0, 343.0, 41.0, 20.0 ],
									"text" : "Light",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-299",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1445.0, 343.0, 34.0, 20.0 ],
									"text" : "Sat",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-294",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1402.0, 343.0, 34.0, 20.0 ],
									"text" : "Hue",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-268",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1486.0, 365.0, 34.0, 72.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[22]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "slider[3]",
											"parameter_type" : 0
										}
									},
									"size" : 1.0,
									"varname" : "slider[5]"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-267",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1445.0, 365.0, 34.0, 72.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[21]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "slider[3]",
											"parameter_type" : 0
										}
									},
									"size" : 1.0,
									"varname" : "slider[3]"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-260",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1402.0, 365.0, 34.0, 72.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[20]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 3,
											"parameter_shortname" : "slider[3]",
											"parameter_type" : 0
										}
									},
									"size" : 1.0,
									"varname" : "slider[4]"
								}
							},
							{
								"box" : {
									"id" : "obj-258",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1422.0, 453.0, 87.0, 22.0 ],
									"text" : "pak hsl 0. 1. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-125",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 823.0, 440.0, 82.0, 20.0 ],
									"text" : "Full Alpha"
								}
							},
							{
								"box" : {
									"id" : "obj-94",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 823.0, 408.0, 90.0, 20.0 ],
									"text" : "Circle Alpha"
								}
							},
							{
								"box" : {
									"id" : "obj-67",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 794.0, 438.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[16]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[16]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[7]"
								}
							},
							{
								"box" : {
									"id" : "obj-11",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 794.0, 406.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[15]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[15]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[6]"
								}
							},
							{
								"box" : {
									"id" : "obj-9",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 302.0, 942.0, 273.0, 22.0 ],
									"text" : "importmovie NormalFullAlpha1080p1.png 1, bang"
								}
							},
							{
								"box" : {
									"id" : "obj-72",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 278.0, 33.0, 447.0, 22.0 ],
									"text" : "folder AS input/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-68",
									"linecount" : 3,
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 227.0, 451.0, 412.0, 49.0 ],
									"text" : "input/transparent-background/"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-56",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 235.0, 299.0, 120.0, 21.0 ],
									"text" : "drop a folder here!"
								}
							},
							{
								"box" : {
									"id" : "obj-63",
									"maxclass" : "dropfile",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 227.0, 287.0, 134.75, 44.5 ]
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "int" ],
									"patching_rect" : [ 219.0, 352.0, 130.0, 23.0 ],
									"text" : "folder input/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-298",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 302.0, 971.0, 150.0, 20.0 ],
									"text" : "Requires path set!"
								}
							},
							{
								"box" : {
									"id" : "obj-293",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 372.0, 881.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-287",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 302.0, 911.0, 258.0, 22.0 ],
									"text" : "importmovie circleGradiant1080p6.png 1, bang"
								}
							},
							{
								"box" : {
									"id" : "obj-280",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 366.0, 835.0, 248.0, 22.0 ],
									"text" : "importmovie NormalFullAlpha1080p1.png 0"
								}
							},
							{
								"box" : {
									"id" : "obj-276",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 284.0, 859.0, 73.0, 22.0 ],
									"text" : "loadmess 1."
								}
							},
							{
								"box" : {
									"id" : "obj-269",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 47.0, 820.0, 72.0, 22.0 ],
									"text" : "r keyCh2init"
								}
							},
							{
								"box" : {
									"id" : "obj-257",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 13.0, 862.0, 63.0, 22.0 ],
									"text" : "r camRaw"
								}
							},
							{
								"box" : {
									"annotation" : "## Combine video using alpha channel masking ##",
									"bgmode" : 1,
									"border" : 0,
									"clickthrough" : 0,
									"enablehscroll" : 0,
									"enablevscroll" : 0,
									"id" : "obj-252",
									"lockeddragscroll" : 0,
									"lockedsize" : 0,
									"maxclass" : "bpatcher",
									"name" : "vz.alphablendr.maxpat",
									"numinlets" : 5,
									"numoutlets" : 1,
									"offset" : [ 0.0, 0.0 ],
									"outlettype" : [ "jit_gl_texture" ],
									"patching_rect" : [ 18.0, 918.0, 268.0, 146.0 ],
									"prototypename" : "pixl",
									"varname" : "alphablendr",
									"viewvisibility" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-245",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1275.0, 459.0, 104.0, 20.0 ],
									"text" : "Low Bandwidth"
								}
							},
							{
								"box" : {
									"id" : "obj-203",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1249.0, 456.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[57]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[57]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle"
								}
							},
							{
								"box" : {
									"id" : "obj-196",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 720.0, 513.0, 135.0, 22.0 ],
									"text" : "prepend low_bandwidth"
								}
							},
							{
								"box" : {
									"id" : "obj-156",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 371.0, 401.0, 92.0, 22.0 ],
									"text" : "prepend enable"
								}
							},
							{
								"box" : {
									"id" : "obj-139",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "int" ],
									"patching_rect" : [ 371.0, 317.0, 29.5, 22.0 ],
									"text" : "t b i"
								}
							},
							{
								"box" : {
									"id" : "obj-138",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 371.0, 367.0, 29.5, 22.0 ],
									"text" : "||"
								}
							},
							{
								"box" : {
									"id" : "obj-137",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1005.0, 221.0, 123.99999922513962, 20.0 ],
									"text" : "Transparency Type"
								}
							},
							{
								"box" : {
									"id" : "obj-128",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1006.0, 150.0, 150.0, 20.0 ],
									"text" : "Camera Type"
								}
							},
							{
								"box" : {
									"id" : "obj-98",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 995.0, 440.0, 144.5, 33.0 ],
									"text" : "NDI camera source selection"
								}
							},
							{
								"box" : {
									"id" : "obj-96",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1202.0, 459.0, 51.95210248231888, 20.0 ],
									"text" : "Rescan"
								}
							},
							{
								"box" : {
									"id" : "obj-75",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1178.0, 456.0, 23.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[14]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[14]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[5]"
								}
							},
							{
								"box" : {
									"id" : "obj-51",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "" ],
									"patching_rect" : [ 750.0, 135.0, 34.0, 22.0 ],
									"text" : "sel 0"
								}
							},
							{
								"box" : {
									"id" : "obj-315",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1286.0, 415.0, 37.0, 22.0 ],
									"text" : "close"
								}
							},
							{
								"box" : {
									"id" : "obj-314",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1247.0, 415.0, 35.0, 22.0 ],
									"text" : "open"
								}
							},
							{
								"box" : {
									"id" : "obj-312",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1201.0, 417.0, 51.95210248231888, 20.0 ],
									"text" : "Rescan"
								}
							},
							{
								"box" : {
									"id" : "obj-310",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1176.0, 413.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[13]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[13]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[4]"
								}
							},
							{
								"box" : {
									"id" : "obj-306",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1308.0, 77.0, 210.56910556554794, 22.0 ],
									"text" : "0.328129 0.144197 0. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-303",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1448.0, 45.0, 80.0, 22.0 ],
									"text" : "loadmess 0.2"
								}
							},
							{
								"box" : {
									"id" : "obj-304",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1448.0, 22.0, 80.0, 22.0 ],
									"text" : "loadmess 0.2"
								}
							},
							{
								"box" : {
									"id" : "obj-302",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1165.0, 251.0, 74.40650403499603, 20.0 ],
									"text" : "Reset Keys"
								}
							},
							{
								"box" : {
									"id" : "obj-300",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1140.0, 247.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[12]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[12]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[3]"
								}
							},
							{
								"box" : {
									"id" : "obj-297",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 12,
									"outlettype" : [ "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float" ],
									"patching_rect" : [ 636.0, 995.0, 207.0, 22.0 ],
									"text" : "unpack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-296",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 636.0, 968.0, 59.0, 22.0 ],
									"text" : "r keyCtrls"
								}
							},
							{
								"box" : {
									"id" : "obj-295",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 4,
									"outlettype" : [ "float", "float", "float", "float" ],
									"patching_rect" : [ 1805.0, 353.0, 101.0, 22.0 ],
									"text" : "unpack 0. 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-290",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1554.0, 420.0, 358.5365851521492, 20.0 ],
									"text" : "highLuma tol fade lowLuma tol fade ChromaTol fade r g b a"
								}
							},
							{
								"box" : {
									"id" : "obj-291",
									"maxclass" : "newobj",
									"numinlets" : 12,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1570.0, 442.0, 338.21138191223145, 22.0 ],
									"text" : "pak 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-292",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1570.0, 468.0, 61.0, 22.0 ],
									"text" : "s keyCtrls"
								}
							},
							{
								"box" : {
									"id" : "obj-289",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1422.0, 289.0, 109.75609749555588, 20.0 ],
									"text" : "Fade"
								}
							},
							{
								"box" : {
									"id" : "obj-288",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1304.0, 289.0, 109.75609749555588, 20.0 ],
									"text" : "Chroma Tolerance"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-286",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1422.0, 305.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[131]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[15]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-285",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1304.0, 305.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[130]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[14]"
								}
							},
							{
								"box" : {
									"id" : "obj-284",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1304.0, 119.0, 150.0, 20.0 ],
									"text" : "Chromakey Color"
								}
							},
							{
								"box" : {
									"id" : "obj-283",
									"maxclass" : "swatch",
									"numinlets" : 3,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1304.0, 141.0, 217.07317060232162, 143.9024389386177 ],
									"saturation" : 1.0,
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "swatch[8]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "swatch[2]",
											"parameter_type" : 3
										}
									},
									"varname" : "swatch[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-282",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1129.0, 224.0, 156.23304599523544, 20.0 ],
									"text" : "Luminance Tolerance Fade"
								}
							},
							{
								"box" : {
									"id" : "obj-281",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1129.0, 164.0, 156.23304599523544, 20.0 ],
									"text" : "Luminance Tolerance Fade"
								}
							},
							{
								"box" : {
									"id" : "obj-278",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1140.0, 179.0, 150.0, 20.0 ],
									"text" : "Lumakey low"
								}
							},
							{
								"box" : {
									"id" : "obj-277",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1140.0, 120.0, 150.0, 20.0 ],
									"text" : "Lumakey high"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-273",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1247.0, 202.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[72]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[11]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-274",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1194.0, 202.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[73]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[12]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-275",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1140.0, 202.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[129]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[13]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-272",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1247.0, 142.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[71]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[10]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-271",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1194.0, 142.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[70]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[9]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-270",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1140.0, 142.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[8]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[8]"
								}
							},
							{
								"box" : {
									"id" : "obj-265",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 774.0, 301.0, 29.5, 22.0 ],
									"text" : "!= 1"
								}
							},
							{
								"box" : {
									"id" : "obj-264",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 328.0, 1506.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-263",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 254.0, 1119.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-261",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 71.0, 1398.0, 150.0, 20.0 ],
									"text" : "init channel 2 key"
								}
							},
							{
								"box" : {
									"id" : "obj-254",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 273.0, 1431.0, 29.5, 22.0 ],
									"text" : "255"
								}
							},
							{
								"box" : {
									"id" : "obj-255",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 206.0, 1431.0, 29.5, 22.0 ],
									"text" : "255"
								}
							},
							{
								"box" : {
									"id" : "obj-256",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 142.0, 1431.0, 29.5, 22.0 ],
									"text" : "255"
								}
							},
							{
								"box" : {
									"id" : "obj-253",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 39.0, 1431.0, 29.5, 22.0 ],
									"text" : "0"
								}
							},
							{
								"box" : {
									"id" : "obj-251",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 420.0, 1185.0, 72.0, 22.0 ],
									"text" : "r keyCh2init"
								}
							},
							{
								"box" : {
									"id" : "obj-250",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 410.0, 1012.0, 72.0, 22.0 ],
									"text" : "r keyCh2init"
								}
							},
							{
								"box" : {
									"id" : "obj-249",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 429.0, 1361.0, 72.0, 22.0 ],
									"text" : "r keyCh2init"
								}
							},
							{
								"box" : {
									"id" : "obj-248",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 39.0, 1671.0, 74.0, 22.0 ],
									"text" : "s keyCh2init"
								}
							},
							{
								"box" : {
									"id" : "obj-247",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 291.0, 1627.0, 105.0, 22.0 ],
									"text" : "s cameragrabpost"
								}
							},
							{
								"box" : {
									"id" : "obj-246",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 170.0, 812.0, 150.0, 20.0 ],
									"text" : "Gradiant loader"
								}
							},
							{
								"box" : {
									"id" : "obj-244",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 815.0, 137.0, 70.0, 22.0 ],
									"text" : "loadmess 0"
								}
							},
							{
								"box" : {
									"id" : "obj-243",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 332.0, 1405.0, 71.0, 22.0 ],
									"text" : "r chromaEn"
								}
							},
							{
								"box" : {
									"id" : "obj-240",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 302.0, 994.0, 57.0, 22.0 ],
									"text" : "r lumaEn"
								}
							},
							{
								"box" : {
									"id" : "obj-234",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 837.0, 333.0, 73.0, 22.0 ],
									"text" : "s chromaEn"
								}
							},
							{
								"box" : {
									"id" : "obj-223",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 776.0, 333.0, 59.0, 22.0 ],
									"text" : "s lumaEn"
								}
							},
							{
								"box" : {
									"id" : "obj-211",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1361.0, 45.0, 80.0, 22.0 ],
									"text" : "loadmess 0.1"
								}
							},
							{
								"box" : {
									"id" : "obj-212",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1270.0, 45.0, 87.0, 22.0 ],
									"text" : "loadmess 0.15"
								}
							},
							{
								"box" : {
									"id" : "obj-221",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1195.0, 45.0, 73.0, 22.0 ],
									"text" : "loadmess 0."
								}
							},
							{
								"box" : {
									"id" : "obj-210",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1361.0, 22.0, 80.0, 22.0 ],
									"text" : "loadmess 0.1"
								}
							},
							{
								"box" : {
									"id" : "obj-200",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1269.0, 22.0, 80.0, 22.0 ],
									"text" : "loadmess 0.2"
								}
							},
							{
								"box" : {
									"id" : "obj-181",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1195.0, 22.0, 73.0, 22.0 ],
									"text" : "loadmess 1."
								}
							},
							{
								"box" : {
									"id" : "obj-149",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 441.0, 635.0, 47.0, 22.0 ],
									"text" : "r toNDI"
								}
							},
							{
								"box" : {
									"id" : "obj-129",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1078.0, 1437.0, 49.0, 22.0 ],
									"text" : "s toNDI"
								}
							},
							{
								"box" : {
									"id" : "obj-204",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 137.0, 810.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[9]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[9]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[2]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-191",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 152.0, 842.0, 117.0, 23.0 ],
									"text" : "importmovie, bang"
								}
							},
							{
								"box" : {
									"id" : "obj-155",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 115.0, 875.0, 150.0, 22.0 ],
									"text" : "jit.matrix 4 char 1920 1080"
								}
							},
							{
								"box" : {
									"annotation" : "## Combine two videos using lumakeying ##",
									"bgmode" : 1,
									"border" : 0,
									"clickthrough" : 0,
									"enablehscroll" : 0,
									"enablevscroll" : 0,
									"id" : "obj-153",
									"lockeddragscroll" : 0,
									"lockedsize" : 0,
									"maxclass" : "bpatcher",
									"name" : "vz.lumakeyr.maxpat",
									"numinlets" : 5,
									"numoutlets" : 1,
									"offset" : [ 0.0, 0.0 ],
									"outlettype" : [ "jit_gl_texture" ],
									"patching_rect" : [ 351.0, 1244.0, 450.0, 146.0 ],
									"prototypename" : "pixl",
									"varname" : "lumakeyr[1]",
									"viewvisibility" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-150",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1006.0, 235.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[51]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[51]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[14]"
								}
							},
							{
								"box" : {
									"id" : "obj-141",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1031.0, 239.0, 97.99999922513962, 20.0 ],
									"text" : "Luma/Chroma"
								}
							},
							{
								"box" : {
									"id" : "obj-148",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1952.0, 465.0, 55.0, 22.0 ],
									"text" : "pipe 100"
								}
							},
							{
								"box" : {
									"id" : "obj-146",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "" ],
									"patching_rect" : [ 1944.0, 430.0, 34.0, 22.0 ],
									"text" : "sel 1"
								}
							},
							{
								"box" : {
									"id" : "obj-145",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1951.0, 389.0, 58.0, 22.0 ],
									"text" : "r usbcam"
								}
							},
							{
								"box" : {
									"id" : "obj-144",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1287.0, 837.0, 150.0, 22.0 ],
									"text" : "loadmess output_texture 1"
								}
							},
							{
								"box" : {
									"id" : "obj-121",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 302.0, 1026.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[47]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[11]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[13]"
								}
							},
							{
								"box" : {
									"id" : "obj-114",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 722.0, 750.0, 29.5, 22.0 ],
									"text" : "0"
								}
							},
							{
								"box" : {
									"id" : "obj-80",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 770.0, 711.0, 55.0, 22.0 ],
									"text" : "pipe 100"
								}
							},
							{
								"box" : {
									"id" : "obj-120",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 861.0, 97.0, 49.0, 22.0 ],
									"text" : "r livevid"
								}
							},
							{
								"box" : {
									"id" : "obj-93",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "" ],
									"patching_rect" : [ 506.0, 359.0, 34.0, 22.0 ],
									"text" : "sel 0"
								}
							},
							{
								"box" : {
									"id" : "obj-64",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 9.0, 1367.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"annotation" : "## Combine two videos using lumakeying ##",
									"bgmode" : 1,
									"border" : 0,
									"clickthrough" : 0,
									"enablehscroll" : 0,
									"enablevscroll" : 0,
									"id" : "obj-48",
									"lockeddragscroll" : 0,
									"lockedsize" : 0,
									"maxclass" : "bpatcher",
									"name" : "vz.lumakeyr.maxpat",
									"numinlets" : 5,
									"numoutlets" : 1,
									"offset" : [ 0.0, 0.0 ],
									"outlettype" : [ "jit_gl_texture" ],
									"patching_rect" : [ 356.0, 1053.0, 450.0, 146.0 ],
									"prototypename" : "pixl",
									"varname" : "lumakeyr",
									"viewvisibility" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-82",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 857.0, 1521.0, 187.29629385471344, 22.0 ],
									"text" : "0.898039 0.898039 0.898039 1."
								}
							},
							{
								"box" : {
									"id" : "obj-76",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 857.0, 1491.0, 80.0, 22.0 ],
									"text" : "prepend rgba"
								}
							},
							{
								"box" : {
									"id" : "obj-62",
									"maxclass" : "suckah",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 940.0, 1424.0, 108.8325987458229, 83.41850313544273 ]
								}
							},
							{
								"box" : {
									"id" : "obj-60",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "float", "float", "float" ],
									"patching_rect" : [ 772.0, 1402.0, 87.0, 22.0 ],
									"text" : "unpack 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-55",
									"maxclass" : "swatch",
									"numinlets" : 3,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 838.0, 1551.0, 157.0, 135.0 ],
									"saturation" : 1.0,
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "swatch[2]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "swatch[2]",
											"parameter_type" : 3
										}
									},
									"varname" : "swatch"
								}
							},
							{
								"box" : {
									"id" : "obj-25",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 405.0, 627.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 9.0,
									"id" : "obj-22",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 433.0, 593.0, 49.0, 19.0 ],
									"text" : "r imgbang"
								}
							},
							{
								"box" : {
									"id" : "obj-241",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 502.0, 1373.0, 150.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 314.3333756327629, 403.5, 150.0, 20.0 ],
									"text" : "Chromakey params"
								}
							},
							{
								"box" : {
									"id" : "obj-239",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 679.0, 1396.0, 41.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 491.3333756327629, 427.0, 41.0, 20.0 ],
									"text" : "Fade"
								}
							},
							{
								"box" : {
									"id" : "obj-238",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 626.0, 1398.0, 41.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 438.3333756327629, 429.0, 41.0, 20.0 ],
									"text" : "Tol"
								}
							},
							{
								"box" : {
									"id" : "obj-237",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 565.0, 1398.0, 41.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 377.8333756327629, 429.0, 41.0, 20.0 ],
									"text" : "B"
								}
							},
							{
								"box" : {
									"id" : "obj-236",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 502.0, 1398.0, 41.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 314.3333756327629, 429.0, 41.0, 20.0 ],
									"text" : "G"
								}
							},
							{
								"box" : {
									"id" : "obj-235",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 435.0, 1398.0, 41.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 248.3333756327629, 429.0, 41.0, 20.0 ],
									"text" : "R"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-233",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 679.0, 1422.0, 50.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 491.3333756327629, 453.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[52]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[2]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[6]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-232",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 626.0, 1422.0, 50.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 438.3333756327629, 453.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[51]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[2]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[5]"
								}
							},
							{
								"box" : {
									"id" : "obj-231",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1267.0, 1427.0, 69.3333740234375, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 810.0, 468.5, 73.0, 20.0 ],
									"text" : "PTZ Zoom"
								}
							},
							{
								"box" : {
									"id" : "obj-230",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1157.0, 1437.0, 97.0, 22.0 ],
									"text" : "pak ptz_zoom 0."
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-229",
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1256.0, 1277.0, 51.1666259765625, 147.5 ],
									"presentation" : 1,
									"presentation_rect" : [ 813.8333740234375, 317.8110892928926, 51.1666259765625, 147.5 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[16]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider[12]",
											"parameter_type" : 0
										}
									},
									"size" : 2.0,
									"varname" : "slider[2]"
								}
							},
							{
								"box" : {
									"id" : "obj-228",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1005.0, 1317.0, 150.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 547.0, 344.3110892928926, 150.0, 20.0 ],
									"text" : "PTZ Pan Tilt"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-227",
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1191.0, 1277.0, 51.1666259765625, 147.5 ],
									"presentation" : 1,
									"presentation_rect" : [ 732.8333740234375, 317.8110892928926, 51.1666259765625, 147.5 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[13]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider[12]",
											"parameter_type" : 0
										}
									},
									"size" : 2.0,
									"varname" : "slider[1]"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-226",
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1018.0, 1339.0, 169.1666259765625, 51.5 ],
									"presentation" : 1,
									"presentation_rect" : [ 560.166748046875, 365.8110892928926, 169.1666259765625, 51.5 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[12]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider[12]",
											"parameter_type" : 0
										}
									},
									"size" : 2.0,
									"varname" : "slider"
								}
							},
							{
								"box" : {
									"id" : "obj-225",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1053.0, 1396.0, 113.0, 22.0 ],
									"text" : "pak ptz_pantilt 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-224",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 972.0, 1205.0, 150.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 619.0, 270.3694527071075, 150.0, 20.0 ],
									"text" : "PTZ Preset "
								}
							},
							{
								"box" : {
									"fontsize" : 24.0,
									"id" : "obj-220",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1369.0, 1231.0, 29.5, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 649.0, 292.3694527071075, 29.5, 35.0 ],
									"text" : "8"
								}
							},
							{
								"box" : {
									"fontsize" : 24.0,
									"id" : "obj-219",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1321.0, 1231.0, 29.5, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 600.8333740234375, 292.3694527071075, 29.5, 35.0 ],
									"text" : "7"
								}
							},
							{
								"box" : {
									"fontsize" : 24.0,
									"id" : "obj-218",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1267.0, 1231.0, 29.5, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 546.8333740234375, 292.3694527071075, 29.5, 35.0 ],
									"text" : "6"
								}
							},
							{
								"box" : {
									"fontsize" : 24.0,
									"id" : "obj-217",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1212.0, 1231.0, 29.5, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 491.8333740234375, 292.3694527071075, 29.5, 35.0 ],
									"text" : "5"
								}
							},
							{
								"box" : {
									"fontsize" : 24.0,
									"id" : "obj-216",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1157.0, 1231.0, 29.5, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 436.8333740234375, 292.3694527071075, 29.5, 35.0 ],
									"text" : "4"
								}
							},
							{
								"box" : {
									"fontsize" : 24.0,
									"id" : "obj-215",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1102.0, 1231.0, 29.5, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 382.8333740234375, 292.3694527071075, 29.5, 35.0 ],
									"text" : "3"
								}
							},
							{
								"box" : {
									"fontsize" : 24.0,
									"id" : "obj-214",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1044.0, 1231.0, 29.5, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 323.0, 292.3694527071075, 29.5, 35.0 ],
									"text" : "2"
								}
							},
							{
								"box" : {
									"fontsize" : 24.0,
									"id" : "obj-213",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 975.0, 1231.0, 46.0, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 256.0, 292.3694527071075, 46.0, 35.0 ],
									"text" : "1"
								}
							},
							{
								"box" : {
									"id" : "obj-208",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 126.0, 368.0, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-207",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 142.0, 400.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[12]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[12]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[12]"
								}
							},
							{
								"box" : {
									"id" : "obj-201",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 48.0, 431.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-195",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 241.0, 1431.0, 29.5, 22.0 ],
									"text" : "0"
								}
							},
							{
								"box" : {
									"id" : "obj-198",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 225.0, 1461.0, 61.0, 22.0 ],
									"text" : "jit.fill alp 3"
								}
							},
							{
								"box" : {
									"id" : "obj-190",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 174.0, 1431.0, 29.5, 22.0 ],
									"text" : "0"
								}
							},
							{
								"box" : {
									"id" : "obj-192",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 161.0, 1461.0, 61.0, 22.0 ],
									"text" : "jit.fill alp 2"
								}
							},
							{
								"box" : {
									"id" : "obj-186",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 110.0, 1431.0, 29.5, 22.0 ],
									"text" : "0"
								}
							},
							{
								"box" : {
									"id" : "obj-189",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 95.0, 1461.0, 61.0, 22.0 ],
									"text" : "jit.fill alp 1"
								}
							},
							{
								"box" : {
									"id" : "obj-182",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 9.0, 1413.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[7]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[7]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[1]"
								}
							},
							{
								"box" : {
									"annotation" : "## Convert Jitter matrix input to texture output ##",
									"bgmode" : 1,
									"border" : 0,
									"clickthrough" : 0,
									"enablehscroll" : 0,
									"enablevscroll" : 0,
									"id" : "obj-179",
									"lockeddragscroll" : 0,
									"lockedsize" : 0,
									"maxclass" : "bpatcher",
									"name" : "vz.matrix2texture.maxpat",
									"numinlets" : 1,
									"numoutlets" : 1,
									"offset" : [ 0.0, 0.0 ],
									"outlettype" : [ "" ],
									"patching_rect" : [ 27.0, 1534.0, 182.0, 120.0 ],
									"prototypename" : "pixl",
									"varname" : "matrix2texture[1]",
									"viewvisibility" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-165",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 71.0, 1431.0, 29.5, 22.0 ],
									"text" : "255"
								}
							},
							{
								"box" : {
									"id" : "obj-161",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 27.0, 1461.0, 61.0, 22.0 ],
									"text" : "jit.fill alp 0"
								}
							},
							{
								"box" : {
									"id" : "obj-159",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 27.0, 1496.0, 169.0, 22.0 ],
									"text" : "jit.matrix alp 4 char 1920 1080"
								}
							},
							{
								"box" : {
									"id" : "obj-147",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 0,
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 59.0, 106.0, 898.0, 730.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"hint" : "Click in this window to choose the keying color. Portions of video in 1 that include this color will appear transparent, and video in 2 will be visible in its place.",
													"id" : "obj-57",
													"maxclass" : "suckah",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"outputalpha" : 0,
													"patching_rect" : [ 332.0, 275.0, 80.0, 60.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 4.0, 39.16353225708008, 112.0, 84.0 ]
												}
											},
											{
												"box" : {
													"color" : [ 0.941176, 0.690196, 0.196078, 1.0 ],
													"id" : "obj-40",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 493.16662599999995, 662.0, 73.0, 22.0 ],
													"text" : "vzgl-routegl"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-20",
													"maxclass" : "newobj",
													"numinlets" : 5,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 343.666687, 527.0, 197.333328, 23.0 ],
													"text" : "pack color 0. 0. 0. 1."
												}
											},
											{
												"box" : {
													"id" : "obj-46",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 774.666687, 573.0, 92.0, 22.0 ],
													"text" : "prepend param"
												}
											},
											{
												"box" : {
													"id" : "obj-42",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 774.666687, 541.0, 34.0, 22.0 ],
													"text" : "t l"
												}
											},
											{
												"box" : {
													"color" : [ 0.941176, 0.690196, 0.196078, 1.0 ],
													"filename" : "co.chromakey.hsv.jxs",
													"id" : "obj-35",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "jit_gl_texture", "" ],
													"patching_rect" : [ 493.16662599999995, 699.0, 204.0, 22.0 ],
													"text" : "jit.gl.slab @file co.chromakey.hsv.jxs",
													"textfile" : {
														"filename" : "co.chromakey.hsv.jxs",
														"flags" : 0,
														"embed" : 0,
														"autowatch" : 1
													}
												}
											},
											{
												"box" : {
													"color" : [ 0.941176, 0.690196, 0.196078, 1.0 ],
													"id" : "obj-38",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 570.0, 662.0, 67.0, 22.0 ],
													"text" : "vzgl-object"
												}
											},
											{
												"box" : {
													"bgmode" : 0,
													"border" : 0,
													"clickthrough" : 0,
													"enablehscroll" : 0,
													"enablevscroll" : 0,
													"id" : "obj-7",
													"lockeddragscroll" : 0,
													"lockedsize" : 0,
													"maxclass" : "bpatcher",
													"name" : "vzgl-pwindow.maxpat",
													"numinlets" : 3,
													"numoutlets" : 1,
													"offset" : [ 0.0, 0.0 ],
													"outlettype" : [ "" ],
													"patching_rect" : [ 241.0, 191.0, 78.0, 68.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 4.0, 39.16353225708008, 112.0, 84.0 ],
													"viewvisibility" : 1
												}
											},
											{
												"box" : {
													"bgmode" : 0,
													"border" : 0,
													"clickthrough" : 0,
													"enablehscroll" : 0,
													"enablevscroll" : 0,
													"hint" : "input image 2",
													"id" : "obj-17",
													"lockeddragscroll" : 0,
													"lockedsize" : 0,
													"maxclass" : "bpatcher",
													"name" : "vzgl-pwindow.maxpat",
													"numinlets" : 3,
													"numoutlets" : 1,
													"offset" : [ 0.0, 0.0 ],
													"outlettype" : [ "" ],
													"patching_rect" : [ 332.0, 191.0, 86.0, 68.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 120.0, 39.16353225708008, 112.0, 84.0 ],
													"viewvisibility" : 1
												}
											},
											{
												"box" : {
													"bgmode" : 0,
													"border" : 0,
													"clickthrough" : 0,
													"enablehscroll" : 0,
													"enablevscroll" : 0,
													"hint" : "output image",
													"id" : "obj-4",
													"lockeddragscroll" : 0,
													"lockedsize" : 0,
													"maxclass" : "bpatcher",
													"name" : "vzgl-pwindow.maxpat",
													"numinlets" : 3,
													"numoutlets" : 1,
													"offset" : [ 0.0, 0.0 ],
													"outlettype" : [ "" ],
													"patching_rect" : [ 269.0, 832.0, 116.0, 92.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 291.0, 39.16353225708008, 112.0, 84.0 ],
													"viewvisibility" : 1
												}
											},
											{
												"box" : {
													"hint" : "This palette displays the keying color you clicked on in the window above. You can also click and drag to set a keying color",
													"id" : "obj-45",
													"maxclass" : "swatch",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "float" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 241.0, 386.0, 80.0, 60.0 ],
													"saturation" : 1.0,
													"saved_attribute_attributes" : {
														"valueof" : {
															"parameter_initial" : [ 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0 ],
															"parameter_initial_enable" : 1,
															"parameter_invisible" : 1,
															"parameter_longname" : "swatch[1]",
															"parameter_modmode" : 0,
															"parameter_shortname" : "swatch",
															"parameter_type" : 3
														}
													},
													"varname" : "swatch"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-78",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 269.0, 353.0, 80.0, 23.0 ],
													"text" : "saturation $1"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "", "", "" ],
													"patching_rect" : [ 115.0, 353.0, 85.0, 23.0 ],
													"restore" : [ 1.0, 0.71764705882353, 0.71764705882353, 1.0, 0.0, 1.0, 0.858823529411765 ],
													"saved_object_attributes" : {
														"parameter_enable" : 0,
														"parameter_mappable" : 0
													},
													"text" : "pattr keycolor",
													"varname" : "keycolor"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-93",
													"maxclass" : "newobj",
													"numinlets" : 4,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 544.0, 275.0, 83.0, 23.0 ],
													"text" : "pak 0. 0. 0. 1."
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 11.595187,
													"id" : "obj-94",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 544.0, 304.0, 60.0, 22.0 ],
													"text" : "zl change"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 269.0, 742.0, 68.0, 23.0 ],
													"text" : "r ---bypass"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-61",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 269.0, 802.0, 54.0, 23.0 ],
													"text" : "gate 1 1"
												}
											},
											{
												"box" : {
													"bgcolor" : [ 0.913, 0.913, 0.913, 0.75 ],
													"blinkcolor" : [ 1.0, 0.89, 0.09, 1.0 ],
													"id" : "obj-44",
													"maxclass" : "button",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"outlinecolor" : [ 0.439216, 0.447059, 0.47451, 1.0 ],
													"parameter_enable" : 0,
													"patching_rect" : [ 343.666687, 498.0, 20.0, 20.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "float", "float", "float", "float" ],
													"patching_rect" : [ 344.0, 457.0, 153.0, 23.0 ],
													"text" : "unpack 0. 0. 0. 0."
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-20", 3 ],
													"source" : [ "obj-1", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-20", 2 ],
													"source" : [ "obj-1", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-20", 1 ],
													"order" : 0,
													"source" : [ "obj-1", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-44", 0 ],
													"midpoints" : [ 353.5, 483.0, 353.166687, 483.0 ],
													"order" : 1,
													"source" : [ "obj-1", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-45", 0 ],
													"source" : [ "obj-2", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-46", 0 ],
													"midpoints" : [ 353.166687, 561.0, 784.166687, 561.0 ],
													"source" : [ "obj-20", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-61", 1 ],
													"midpoints" : [ 502.66662599999995, 768.0, 313.5, 768.0 ],
													"source" : [ "obj-35", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-35", 0 ],
													"source" : [ "obj-38", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-35", 0 ],
													"source" : [ "obj-40", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-46", 0 ],
													"source" : [ "obj-42", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-20", 0 ],
													"source" : [ "obj-44", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"midpoints" : [ 250.5, 452.0, 353.5, 452.0 ],
													"source" : [ "obj-45", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-40", 0 ],
													"source" : [ "obj-46", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-61", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"order" : 0,
													"source" : [ "obj-57", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-45", 0 ],
													"midpoints" : [ 341.5, 345.0, 250.5, 345.0 ],
													"order" : 1,
													"source" : [ "obj-57", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-4", 0 ],
													"source" : [ "obj-61", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-45", 0 ],
													"source" : [ "obj-78", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-94", 0 ],
													"source" : [ "obj-93", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-45", 0 ],
													"midpoints" : [ 553.5, 345.5, 250.5, 345.5 ],
													"source" : [ "obj-94", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1551.0, 1227.0, 42.0, 22.0 ],
									"text" : "p chro",
									"varname" : "chro"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-142",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 502.0, 1422.0, 50.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 314.3333756327629, 453.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[95]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[2]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[4]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-135",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 429.0, 1422.0, 50.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 242.00004229942954, 453.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[99]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[2]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[3]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-134",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 565.0, 1422.0, 50.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 377.8333756327629, 453.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[2]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[2]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[2]"
								}
							},
							{
								"box" : {
									"annotation" : "## Convert Jitter matrix input to texture output ##",
									"bgmode" : 1,
									"border" : 0,
									"clickthrough" : 0,
									"enablehscroll" : 0,
									"enablevscroll" : 0,
									"id" : "obj-133",
									"lockeddragscroll" : 0,
									"lockedsize" : 0,
									"maxclass" : "bpatcher",
									"name" : "vz.matrix2texture.maxpat",
									"numinlets" : 1,
									"numoutlets" : 1,
									"offset" : [ 0.0, 0.0 ],
									"outlettype" : [ "" ],
									"patching_rect" : [ 693.0, 803.0, 182.0, 120.0 ],
									"prototypename" : "pixl",
									"varname" : "matrix2texture",
									"viewvisibility" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-130",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 683.0, 1566.0, 47.0, 21.0 ],
									"text" : "Blue",
									"textcolor" : [ 0.50196099281311, 0.50196099281311, 0.50196099281311, 1.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-131",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 553.0, 1566.0, 45.0, 21.0 ],
									"text" : "Green",
									"textcolor" : [ 0.50196099281311, 0.50196099281311, 0.50196099281311, 1.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-132",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 423.0, 1566.0, 34.0, 21.0 ],
									"text" : "Red",
									"textcolor" : [ 0.50196099281311, 0.50196099281311, 0.50196099281311, 1.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-97",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 372.0, 1437.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[11]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[11]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[11]"
								}
							},
							{
								"box" : {
									"annotation" : "## Combine two videos using chromakeying ##",
									"bgmode" : 1,
									"border" : 0,
									"clickthrough" : 0,
									"enablehscroll" : 0,
									"enablevscroll" : 0,
									"id" : "obj-26",
									"lockeddragscroll" : 0,
									"lockedsize" : 0,
									"maxclass" : "bpatcher",
									"name" : "vz.chromakeyr.maxpat",
									"numinlets" : 7,
									"numoutlets" : 4,
									"offset" : [ 0.0, 0.0 ],
									"outlettype" : [ "jit_gl_texture", "", "", "" ],
									"patching_rect" : [ 414.0, 1453.0, 408.0, 146.0 ],
									"prototypename" : "pixl",
									"varname" : "chromakeyr",
									"viewvisibility" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-46",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 290.0, 57.0, 545.0, 22.0 ],
									"presentation" : 1,
									"presentation_linecount" : 4,
									"presentation_rect" : [ 518.5, 19.0, 220.0, 62.0 ],
									"text" : "folder AS input/transparent-background/"
								}
							},
							{
								"box" : {
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "int" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 358.0, 97.0, 698.0, 755.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-72",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 71.0, 208.17346199999997, 56.0, 22.0 ],
													"text" : "r movSel"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-7",
													"index" : 2,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 415.0, 529.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"id" : "obj-3",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 478.0, 526.0, 50.0, 22.0 ]
												}
											},
											{
												"box" : {
													"activebgcolor" : [ 0.1, 0.1, 0.1, 1.0 ],
													"activebgoncolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"bgcolor" : [ 0.1, 0.1, 0.1, 1.0 ],
													"bgoncolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"bordercolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"focusbordercolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"hint" : "Choose a movie or send the \"folder\" message to populate the menu",
													"id" : "obj-41",
													"ignoreclick" : 1,
													"maxclass" : "live.toggle",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"parameter_enable" : 1,
													"parameter_mappable" : 0,
													"patching_rect" : [ 724.0, 159.006989, 15.0, 15.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 3.0, 4.0, 9.742591857910156, 9.742591857910156 ],
													"rounded" : 15.0,
													"saved_attribute_attributes" : {
														"activebgcolor" : {
															"expression" : ""
														},
														"activebgoncolor" : {
															"expression" : ""
														},
														"bgcolor" : {
															"expression" : ""
														},
														"bgoncolor" : {
															"expression" : ""
														},
														"bordercolor" : {
															"expression" : ""
														},
														"focusbordercolor" : {
															"expression" : ""
														},
														"valueof" : {
															"parameter_enum" : [ "off", "on" ],
															"parameter_initial" : [ 1 ],
															"parameter_initial_enable" : 1,
															"parameter_invisible" : 2,
															"parameter_longname" : "pictctrl[1]",
															"parameter_mmax" : 1,
															"parameter_modmode" : 0,
															"parameter_shortname" : "pictctrl[1]",
															"parameter_type" : 2
														}
													},
													"varname" : "pictctrl[3]"
												}
											},
											{
												"box" : {
													"activebgcolor" : [ 0.1, 0.1, 0.1, 1.0 ],
													"activebgoncolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"bgcolor" : [ 0.1, 0.1, 0.1, 1.0 ],
													"bgoncolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"bordercolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"focusbordercolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"hint" : "Connect this outlet to the rightmost inlet of the PLAYR module to support menu-based file loading",
													"id" : "obj-30",
													"ignoreclick" : 1,
													"maxclass" : "live.toggle",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"parameter_enable" : 1,
													"parameter_mappable" : 0,
													"patching_rect" : [ 230.0, 487.0, 15.0, 15.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 3.0, 82.0, 9.742591857910156, 9.742591857910156 ],
													"rounded" : 15.0,
													"saved_attribute_attributes" : {
														"activebgcolor" : {
															"expression" : ""
														},
														"activebgoncolor" : {
															"expression" : ""
														},
														"bgcolor" : {
															"expression" : ""
														},
														"bgoncolor" : {
															"expression" : ""
														},
														"bordercolor" : {
															"expression" : ""
														},
														"focusbordercolor" : {
															"expression" : ""
														},
														"valueof" : {
															"parameter_enum" : [ "off", "on" ],
															"parameter_initial" : [ 1 ],
															"parameter_initial_enable" : 1,
															"parameter_invisible" : 2,
															"parameter_longname" : "pictctrl[2]",
															"parameter_mmax" : 1,
															"parameter_modmode" : 0,
															"parameter_shortname" : "pictctrl[1]",
															"parameter_type" : 2
														}
													},
													"varname" : "pictctrl[2]"
												}
											},
											{
												"box" : {
													"autopopulate" : 1,
													"bgcolor" : [ 0.8, 0.5, 0.5, 1.0 ],
													"bgfillcolor_angle" : 270.0,
													"bgfillcolor_autogradient" : 0,
													"bgfillcolor_color" : [ 0.8, 0.5, 0.5, 1.0 ],
													"bgfillcolor_color1" : [ 0.454902, 0.462745, 0.482353, 1.0 ],
													"bgfillcolor_color2" : [ 0.290196, 0.309804, 0.301961, 1.0 ],
													"bgfillcolor_proportion" : 0.39,
													"bgfillcolor_type" : "color",
													"hint" : "Select an input source",
													"id" : "obj-5",
													"items" : [
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
													"maxclass" : "umenu",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "int", "", "" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 163.0, 283.0, 218.0, 22.0 ],
													"prefix" : "",
													"presentation" : 1,
													"presentation_rect" : [ 11.525192260742188, 45.31418228149414, 214.0, 22.0 ],
													"saved_attribute_attributes" : {
														"valueof" : {
															"parameter_invisible" : 1,
															"parameter_longname" : "Menu[1]",
															"parameter_mmax" : 52.0,
															"parameter_modmode" : 0,
															"parameter_shortname" : "Menu",
															"parameter_type" : 3
														}
													},
													"textcolor" : [ 0.25, 0.0, 0.0, 1.0 ],
													"types" : [ "MooV", "MPEG", "mpg4", "VfW", "WMV", "PICT", "PNG", "GIFf", "TIFF", "BMP" ],
													"varname" : "umenu"
												}
											},
											{
												"box" : {
													"id" : "obj-8",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 216.5, 314.223145, 65.0, 22.0 ],
													"text" : "route drag"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-6",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 262.5, 342.223145, 62.0, 23.0 ],
													"text" : "zl change"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-4",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "", "", "" ],
													"patching_rect" : [ 585.0, 76.0, 89.0, 23.0 ],
													"text" : "route int folder"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 163.0, 204.0, 87.0, 23.0 ],
													"text" : "prepend prefix"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 11.595187,
													"id" : "obj-31",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 370.0, 243.0, 383.0, 22.0 ],
													"text" : "types MooV MPEG mpg4 \"VfW \" \"WMV \" PICT \"PNG \" GIFf TIFF \"BMP \""
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-46",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "int", "bang" ],
													"patching_rect" : [ 362.0, 342.223145, 43.5, 23.0 ],
													"text" : "t i b"
												}
											},
											{
												"box" : {
													"bgcolor" : [ 0.913, 0.913, 0.913, 0.75 ],
													"blinkcolor" : [ 1.0, 0.89, 0.09, 1.0 ],
													"id" : "obj-43",
													"maxclass" : "button",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"outlinecolor" : [ 0.439216, 0.447059, 0.47451, 1.0 ],
													"parameter_enable" : 0,
													"patching_rect" : [ 908.0, 20.0, 20.0, 20.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-75",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "", "", "" ],
													"patching_rect" : [ 655.0, 113.006989, 88.0, 23.0 ],
													"text" : "data-handler"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-39",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 386.5, 385.771027, 248.0, 23.0 ],
													"text" : "bgcolor 0.8 0.5 0.5 1., textcolor 0.25 0. 0. 1."
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-37",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 348.0, 204.0, 600.0, 23.0 ],
													"text" : "clear, bgcolor 0.25 0. 0. 1., framecolor 1. 1. 1. 1., textcolor 1. 1. 1. 1., append drag a folder here to load movies"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-108",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 650.0, 416.371918, 95.0, 23.0 ],
													"text" : "scale 0. 1. 0 1 1"
												}
											},
											{
												"box" : {
													"comment" : "Choose a movie or send the \"folder\" message to populate the menu",
													"id" : "obj-76",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 585.0, 36.0, 25.0, 25.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 3,
													"outlettype" : [ "int", "int", "bang" ],
													"patching_rect" : [ 936.0, 49.0, 46.0, 23.0 ],
													"text" : "t 0 1 b"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-71",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 228.0, 508.0, 54.0, 23.0 ],
													"text" : "gate 1 1"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-33",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 937.0, 21.0, 60.0, 23.0 ],
													"text" : "loadbang"
												}
											},
											{
												"box" : {
													"comment" : "Connect this outlet to the rightmost inlet of the PLAYR module to support menu-based file loading",
													"id" : "obj-17",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 229.0, 532.0, 25.0, 25.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-22",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "", "" ],
													"patching_rect" : [ 362.0, 314.223145, 98.0, 23.0 ],
													"text" : "route populate"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-13",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 263.0, 385.771027, 82.0, 23.0 ],
													"text" : "prepend read"
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-1", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"midpoints" : [ 659.5, 444.0, 151.0, 444.0, 151.0, 268.0, 172.5, 268.0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-71", 1 ],
													"source" : [ "obj-13", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-46", 0 ],
													"source" : [ "obj-22", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-71", 0 ],
													"source" : [ "obj-30", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"midpoints" : [ 379.5, 268.0, 172.5, 268.0 ],
													"source" : [ "obj-31", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-33", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"midpoints" : [ 357.5, 268.0, 172.5, 268.0 ],
													"source" : [ "obj-37", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"midpoints" : [ 396.0, 444.0, 151.5, 444.0, 151.5, 268.0, 172.5, 268.0 ],
													"source" : [ "obj-39", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"midpoints" : [ 629.5, 167.0, 172.5, 167.0 ],
													"source" : [ "obj-4", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-75", 0 ],
													"source" : [ "obj-4", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-33", 0 ],
													"source" : [ "obj-43", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-108", 4 ],
													"midpoints" : [ 371.5, 374.797546, 720.3, 374.797546 ],
													"order" : 0,
													"source" : [ "obj-46", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-39", 0 ],
													"source" : [ "obj-46", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-7", 0 ],
													"order" : 1,
													"source" : [ "obj-46", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-22", 0 ],
													"source" : [ "obj-5", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-8", 0 ],
													"source" : [ "obj-5", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-30", 0 ],
													"midpoints" : [ 959.0, 474.5, 239.0, 474.5 ],
													"source" : [ "obj-50", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-31", 0 ],
													"midpoints" : [ 972.5, 233.5, 379.5, 233.5 ],
													"order" : 0,
													"source" : [ "obj-50", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-37", 0 ],
													"midpoints" : [ 972.5, 191.0, 357.5, 191.0 ],
													"order" : 1,
													"source" : [ "obj-50", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-13", 0 ],
													"source" : [ "obj-6", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-17", 0 ],
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-72", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-108", 0 ],
													"source" : [ "obj-75", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-41", 0 ],
													"midpoints" : [ 699.0, 147.006989, 733.0, 147.006989 ],
													"source" : [ "obj-75", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-4", 0 ],
													"source" : [ "obj-76", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-6", 0 ],
													"source" : [ "obj-8", 1 ]
												}
											}
										]
									},
									"patching_rect" : [ 175.0, 181.0, 34.0, 22.0 ],
									"text" : "p pic"
								}
							},
							{
								"box" : {
									"id" : "obj-206",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 10.0, 68.0, 150.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 355.3000002503395, 6.0, 118.0, 20.0 ],
									"text" : "Video/Pic control"
								}
							},
							{
								"box" : {
									"id" : "obj-205",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 13.0, 33.0, 150.0, 33.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 35.08337336778641, -0.5, 150.0, 33.0 ],
									"text" : "feedbax v90+\nSean Stevens 2025"
								}
							},
							{
								"box" : {
									"id" : "obj-197",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 941.0, 635.0, 80.0, 22.0 ],
									"text" : "r cameragrab"
								}
							},
							{
								"box" : {
									"id" : "obj-193",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 927.0, 708.0, 65.0, 22.0 ],
									"text" : "s camRaw"
								}
							},
							{
								"box" : {
									"id" : "obj-188",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1063.0, 999.0, 82.0, 22.0 ],
									"text" : "s cameragrab"
								}
							},
							{
								"box" : {
									"id" : "obj-187",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 53.0, 172.0, 82.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 49.0, 46.5, 150.0, 20.0 ],
									"text" : "movieBang"
								}
							},
							{
								"box" : {
									"id" : "obj-184",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1032.0, 168.0, 38.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 314.3333756327629, 264.0, 38.0, 20.0 ],
									"text" : "NDI"
								}
							},
							{
								"box" : {
									"id" : "obj-180",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1006.0, 165.0, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 288.3333756327629, 260.56945799999994, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[7]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[7]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[7]"
								}
							},
							{
								"box" : {
									"id" : "obj-177",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1766.0, 808.0, 60.0, 20.0 ],
									"text" : "Binary"
								}
							},
							{
								"box" : {
									"id" : "obj-163",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1708.0, 887.0, 103.0, 20.0 ],
									"text" : "Only output Key"
								}
							},
							{
								"box" : {
									"id" : "obj-162",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1032.0, 193.0, 85.69999974966049, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 314.9666333794594, 208.93054200000006, 85.69999974966049, 20.0 ],
									"text" : "USB"
								}
							},
							{
								"box" : {
									"id" : "obj-160",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1006.0, 191.0, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 288.6666331291199, 206.93054200000006, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[38]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[38]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-185",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 992.0, 399.0, 186.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 288.0666486620903, 97.30000430345535, 203.0, 20.0 ],
									"text" : "USB Camera Input Selection"
								}
							},
							{
								"box" : {
									"id" : "obj-178",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1572.0, 1051.0, 128.0, 33.0 ],
									"text" : "Check for changes to folder"
								}
							},
							{
								"box" : {
									"id" : "obj-158",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1543.0, 1060.0, 20.0, 20.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[10]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[10]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[10]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-166",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 1543.0, 1089.0, 58.0, 22.0 ],
									"text" : "metro 30"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-168",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1604.0, 1257.0, 34.0, 22.0 ],
									"text" : "print"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-172",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 1611.0, 1190.0, 32.5, 22.0 ],
									"text" : "t l l"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-173",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 1599.0, 1223.0, 45.0, 22.0 ],
									"text" : "zl.filter"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-174",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 1611.0, 1160.0, 53.0, 22.0 ],
									"text" : "zl.group"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-175",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 1543.0, 1152.0, 57.0, 22.0 ],
									"text" : "zl.slice 1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-176",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "int" ],
									"patching_rect" : [ 1543.0, 1118.0, 188.0, 23.0 ],
									"text" : "folder \"./Cycling '74/max-help\""
								}
							},
							{
								"box" : {
									"fontname" : "Futura Medium",
									"fontsize" : 12.0,
									"id" : "obj-23",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2078.0, 712.0, 59.0, 24.0 ],
									"text" : "r 2dfft4x"
								}
							},
							{
								"box" : {
									"fontname" : "Futura Medium",
									"fontsize" : 12.0,
									"id" : "obj-50",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2148.0, 712.0, 77.0, 24.0 ],
									"text" : "r scope2011"
								}
							},
							{
								"box" : {
									"fontname" : "Futura Medium",
									"fontsize" : 12.0,
									"id" : "obj-157",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2233.0, 712.0, 67.0, 24.0 ],
									"text" : "r waterfall"
								}
							},
							{
								"box" : {
									"id" : "obj-43",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 805.0, 257.0, 60.0, 22.0 ],
									"text" : "s usbcam"
								}
							},
							{
								"box" : {
									"id" : "obj-42",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1032.0, 124.0, 102.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 313.5, 45.5, 109.0, 20.0 ],
									"text" : "Enable camera"
								}
							},
							{
								"box" : {
									"id" : "obj-151",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1734.0, 845.0, 103.0, 20.0 ],
									"text" : "Invert"
								}
							},
							{
								"box" : {
									"id" : "obj-74",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1079.0, 822.0, 58.0, 22.0 ],
									"text" : "r usbcam"
								}
							},
							{
								"box" : {
									"id" : "obj-15",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1069.0, 907.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[36]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[36]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[9]"
								}
							},
							{
								"box" : {
									"id" : "obj-17",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1088.0, 951.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-127",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1682.0, 885.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[34]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[34]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[6]"
								}
							},
							{
								"box" : {
									"id" : "obj-126",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1708.0, 843.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[33]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[33]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[5]"
								}
							},
							{
								"box" : {
									"id" : "obj-124",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1823.0, 886.0, 123.0, 22.0 ],
									"text" : "prepend param mode"
								}
							},
							{
								"box" : {
									"id" : "obj-123",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1839.0, 853.0, 123.0, 22.0 ],
									"text" : "prepend param invert"
								}
							},
							{
								"box" : {
									"id" : "obj-122",
									"linecount" : 23,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1826.0, 1092.0, 530.0, 315.0 ],
									"text" : "\tLuminance based keying\n\t</description>\n\t<param name=\"luma\" type=\"float\" default=\"0.0\">\n\t\t<description>Target luminance</description>\n\t</param>\n\t<param name=\"tol\" type=\"float\" default=\"0.3\">\n\t\t<description>Tolerance</description>\n\t</param>\n\t<param name=\"fade\" type=\"float\" default=\"0.\">\n\t\t<description>Fade amount</description>\n\t</param>\t\n\t<param name=\"lumcoeff\" type=\"vec4\" default=\"0.299 .587 0.114 0.\">\n\t\t<description>Luminance coefficients (RGBA)</description>\n\t</param>\n\t<param name=\"invert\" type=\"float\" default=\"0.0\">\n\t\t<description>Invert mask</description>\n\t</param>\n\t<param name=\"mode\" type=\"float\" default=\"0.0\">\n\t\t<description>Mask mode (if 1, result mask only)</description>\n\t</param>\n\t<param name=\"binary\" type=\"float\" default=\"0.0\">\n\t\t<description>Mix with second source (if 0, just gen alpha channel)</description>\n\t</param>"
								}
							},
							{
								"box" : {
									"id" : "obj-119",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1737.0, 805.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[32]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[32]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[4]"
								}
							},
							{
								"box" : {
									"id" : "obj-95",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1851.0, 825.0, 126.0, 22.0 ],
									"text" : "prepend param binary"
								}
							},
							{
								"box" : {
									"id" : "obj-87",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1007.0, 120.0, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 287.5, 43.5, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[31]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[31]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[3]"
								}
							},
							{
								"box" : {
									"id" : "obj-92",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 391.0, 579.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-85",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 382.0, 545.0, 103.0, 22.0 ],
									"text" : "r cameragrabpost"
								}
							},
							{
								"box" : {
									"id" : "obj-83",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 298.0, 1372.0, 105.0, 22.0 ],
									"text" : "s cameragrabpost"
								}
							},
							{
								"box" : {
									"id" : "obj-79",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 589.0, 222.0, 22.0, 22.0 ],
									"text" : "t 0"
								}
							},
							{
								"box" : {
									"id" : "obj-78",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 81.0, 92.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-24",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1091.0, 856.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[16]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[16]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[2]"
								}
							},
							{
								"box" : {
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1119.0, 888.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"appearance" : 3,
									"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"fontface" : 1,
									"fontsize" : 12.0,
									"hint" : "Set the luminance of the keying function.",
									"id" : "obj-81",
									"maxclass" : "live.dial",
									"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1975.0, 808.0, 64.0, 75.0 ],
									"saved_attribute_attributes" : {
										"activedialcolor" : {
											"expression" : ""
										},
										"activeneedlecolor" : {
											"expression" : ""
										},
										"dialcolor" : {
											"expression" : ""
										},
										"needlecolor" : {
											"expression" : ""
										},
										"valueof" : {
											"parameter_initial" : [ 0.5 ],
											"parameter_initial_enable" : 1,
											"parameter_longname" : "Luminance",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "Luminance",
											"parameter_type" : 0,
											"parameter_unitstyle" : 1
										}
									},
									"triangle" : 1,
									"varname" : "control[2]"
								}
							},
							{
								"box" : {
									"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"appearance" : 3,
									"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"fontface" : 1,
									"fontsize" : 12.0,
									"hint" : "Crossfade between the keyed and unkeyed video.",
									"id" : "obj-84",
									"maxclass" : "live.dial",
									"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2198.0, 799.0, 64.0, 75.0 ],
									"saved_attribute_attributes" : {
										"activedialcolor" : {
											"expression" : ""
										},
										"activeneedlecolor" : {
											"expression" : ""
										},
										"dialcolor" : {
											"expression" : ""
										},
										"needlecolor" : {
											"expression" : ""
										},
										"valueof" : {
											"parameter_initial" : [ 0.5 ],
											"parameter_initial_enable" : 1,
											"parameter_longname" : "Fade",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "Fade",
											"parameter_type" : 0,
											"parameter_unitstyle" : 1
										}
									},
									"triangle" : 1,
									"varname" : "control"
								}
							},
							{
								"box" : {
									"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"appearance" : 3,
									"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"fontface" : 1,
									"fontsize" : 12.0,
									"hint" : "Set the tolerance of the keying function.",
									"id" : "obj-86",
									"maxclass" : "live.dial",
									"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2076.0, 797.0, 64.0, 75.0 ],
									"saved_attribute_attributes" : {
										"activedialcolor" : {
											"expression" : ""
										},
										"activeneedlecolor" : {
											"expression" : ""
										},
										"dialcolor" : {
											"expression" : ""
										},
										"needlecolor" : {
											"expression" : ""
										},
										"valueof" : {
											"parameter_initial" : [ 0.5 ],
											"parameter_initial_enable" : 1,
											"parameter_longname" : "Tolerance",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "Tolerance",
											"parameter_type" : 0,
											"parameter_unitstyle" : 1
										}
									},
									"triangle" : 1,
									"varname" : "control[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-88",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1946.0, 925.0, 90.0, 22.0 ],
									"text" : "prepend param"
								}
							},
							{
								"box" : {
									"id" : "obj-89",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2088.0, 920.0, 90.0, 22.0 ],
									"text" : "prepend param"
								}
							},
							{
								"box" : {
									"id" : "obj-90",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2192.0, 920.0, 90.0, 22.0 ],
									"text" : "prepend param"
								}
							},
							{
								"box" : {
									"fontname" : "Ableton Sans Medium",
									"fontsize" : 12.0,
									"id" : "obj-91",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1954.0, 893.0, 51.0, 23.0 ],
									"text" : "luma $1"
								}
							},
							{
								"box" : {
									"color" : [ 0.941176, 0.690196, 0.196078, 1.0 ],
									"filename" : "co.lumakey.jxs",
									"id" : "obj-116",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "jit_gl_texture", "" ],
									"patching_rect" : [ 2081.0, 952.0, 458.0, 22.0 ],
									"text" : "jit.gl.slab @file co.lumakey.jxs @param binary 0 @param fade 0.05 @param tol 0.05",
									"textfile" : {
										"filename" : "co.lumakey.jxs",
										"flags" : 0,
										"embed" : 0,
										"autowatch" : 1
									}
								}
							},
							{
								"box" : {
									"fontname" : "Ableton Sans Medium",
									"fontsize" : 12.0,
									"id" : "obj-117",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2204.0, 886.0, 51.0, 23.0 ],
									"text" : "fade $1"
								}
							},
							{
								"box" : {
									"fontname" : "Ableton Sans Medium",
									"fontsize" : 12.0,
									"id" : "obj-118",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2076.0, 892.0, 62.0, 23.0 ],
									"text" : "tol $1"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-73",
									"maxclass" : "jit.fpsgui",
									"mode" : 3,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 124.0, 292.0, 80.0, 35.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 16.5, 86.09999519586563, 80.0, 35.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-71",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 255.0, 222.0, 81.0, 22.0 ],
									"text" : "s movsFound"
								}
							},
							{
								"box" : {
									"id" : "obj-70",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 610.0, 246.0, 79.0, 22.0 ],
									"text" : "r movsFound"
								}
							},
							{
								"box" : {
									"id" : "obj-69",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 553.0, 323.0, 58.0, 22.0 ],
									"text" : "s movSel"
								}
							},
							{
								"box" : {
									"id" : "obj-66",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 631.0, 312.0, 79.0, 22.0 ],
									"text" : "prepend max"
								}
							},
							{
								"box" : {
									"id" : "obj-65",
									"maxclass" : "incdec",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 492.0, 260.0, 55.0, 53.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 16.5, 233.0, 55.0, 53.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-61",
									"maxclass" : "number",
									"maximum" : 53,
									"minimum" : 0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 553.0, 260.0, 50.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 77.5, 233.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[1]",
											"parameter_mmax" : 53.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[1]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-57",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 553.0, 289.0, 50.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 77.5, 262.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[39]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[39]",
											"parameter_type" : 3
										}
									},
									"varname" : "number"
								}
							},
							{
								"box" : {
									"id" : "obj-54",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "" ],
									"patching_rect" : [ 40.0, 216.0, 31.0, 22.0 ],
									"text" : "t b s"
								}
							},
							{
								"box" : {
									"id" : "obj-53",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 21.0, 170.0, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 16.5, 44.5, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[6]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[6]",
											"parameter_type" : 2
										}
									},
									"varname" : "button"
								}
							},
							{
								"box" : {
									"id" : "obj-49",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_gl_texture", "" ],
									"patching_rect" : [ 93.0, 252.0, 155.0, 22.0 ],
									"text" : "jit.movie @output_texture 1"
								}
							},
							{
								"box" : {
									"id" : "obj-115",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1136.0, 856.0, 62.0, 22.0 ],
									"text" : "r imgbang"
								}
							},
							{
								"box" : {
									"id" : "obj-99",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1531.0, 898.0, 61.0, 22.0 ],
									"text" : "format -1"
								}
							},
							{
								"box" : {
									"id" : "obj-100",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1810.0, 580.0, 85.0, 22.0 ],
									"text" : "loadmess set"
								}
							},
							{
								"box" : {
									"id" : "obj-101",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1926.0, 580.0, 209.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-102",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 1764.0, 584.0, 24.0, 22.0 ],
									"text" : "t b"
								}
							},
							{
								"box" : {
									"id" : "obj-103",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 1286.0, 866.0, 62.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-104",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 4,
									"outlettype" : [ "", "", "", "" ],
									"patching_rect" : [ 1764.0, 547.0, 371.0, 22.0 ],
									"text" : "route device_added device_removed device_format"
								}
							},
							{
								"box" : {
									"attr" : "output_texture",
									"id" : "obj-105",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1362.0, 866.0, 139.0, 22.0 ],
									"text_width" : 112.0
								}
							},
							{
								"box" : {
									"attr" : "format",
									"id" : "obj-40",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1285.0, 550.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-41",
									"items" : "<empty>",
									"maxclass" : "umenu",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "int", "", "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1285.0, 523.0, 180.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 474.3000002503395, 149.5, 180.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [
												"YUY2 - 422YpCbCr8_yuvs - 144 x 144",
												"YUY2 - 422YpCbCr8_yuvs - 256 x 256",
												"YUY2 - 422YpCbCr8_yuvs - 512 x 256",
												"YUY2 - 422YpCbCr8_yuvs - 512 x 512",
												"YUY2 - 422YpCbCr8_yuvs - 1024 x 1024"
											],
											"parameter_longname" : "umenu[2]",
											"parameter_mmax" : 4,
											"parameter_modmode" : 0,
											"parameter_shortname" : "umenu[2]",
											"parameter_type" : 2
										}
									},
									"varname" : "umenu[2]"
								}
							},
							{
								"box" : {
									"attr" : "colormode",
									"id" : "obj-106",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1362.0, 898.0, 139.0, 22.0 ],
									"text_width" : 87.0
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-107",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "clear", "clear" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 34.0, 79.0, 580.0, 303.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-4",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 386.0, 131.5, 91.0, 22.0 ],
													"text" : "loadmess clear"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 13.0,
													"id" : "obj-21",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 132.5, 27.0, 23.0 ],
													"text" : "iter"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 13.0,
													"id" : "obj-23",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "clear" ],
													"patching_rect" : [ 151.0, 132.5, 46.0, 23.0 ],
													"text" : "t clear"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 13.0,
													"id" : "obj-24",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "clear" ],
													"patching_rect" : [ 302.0, 131.5, 46.0, 23.0 ],
													"text" : "t clear"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 13.0,
													"id" : "obj-27",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 201.0, 155.5, 107.0, 23.0 ],
													"text" : "prepend append"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 13.0,
													"id" : "obj-28",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 201.0, 132.5, 27.0, 23.0 ],
													"text" : "iter"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 13.0,
													"id" : "obj-32",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 155.5, 107.0, 23.0 ],
													"text" : "prepend append"
												}
											},
											{
												"box" : {
													"fontface" : 0,
													"fontname" : "Arial",
													"fontsize" : 13.0,
													"id" : "obj-33",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "", "", "" ],
													"patching_rect" : [ 50.0, 79.0, 143.0, 23.0 ],
													"text" : "route vdevlist formatlist"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 40.0, 25.0, 25.0 ]
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-5",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 95.5, 236.5, 25.0, 25.0 ]
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-13",
													"index" : 2,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 246.5, 236.5, 25.0, 25.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-33", 0 ],
													"source" : [ "obj-1", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-32", 0 ],
													"source" : [ "obj-21", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-23", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-13", 0 ],
													"source" : [ "obj-24", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-13", 0 ],
													"source" : [ "obj-27", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-27", 0 ],
													"source" : [ "obj-28", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-32", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-21", 0 ],
													"order" : 1,
													"source" : [ "obj-33", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-23", 0 ],
													"midpoints" : [ 59.5, 128.5, 160.5, 128.5 ],
													"order" : 0,
													"source" : [ "obj-33", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-24", 0 ],
													"midpoints" : [ 121.5, 124.5, 311.5, 124.5 ],
													"order" : 0,
													"source" : [ "obj-33", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-28", 0 ],
													"midpoints" : [ 121.5, 124.5, 210.5, 124.5 ],
													"order" : 1,
													"source" : [ "obj-33", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-13", 0 ],
													"order" : 0,
													"source" : [ "obj-4", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"order" : 1,
													"source" : [ "obj-4", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1477.0, 523.0, 205.0, 23.0 ],
									"text" : "p vdev/format"
								}
							},
							{
								"box" : {
									"attr" : "vdevice",
									"id" : "obj-30",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1090.0, 507.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-108",
									"items" : "seancomm-x2 Camera",
									"maxclass" : "umenu",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "int", "", "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 993.0, 415.0, 180.0, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 288.3000002503395, 149.5, 180.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "Ultraleap", "SIPPro9.7" ],
											"parameter_longname" : "umenu[1]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "umenu[1]",
											"parameter_type" : 2
										}
									},
									"varname" : "umenu[1]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-109",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1510.0, 866.0, 81.0, 23.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 470.9666337966919, 121.09999519586563, 81.0, 23.0 ],
									"text" : "getformatlist"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-110",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1286.0, 898.0, 72.0, 23.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 288.0666486620903, 121.09999519586563, 72.0, 23.0 ],
									"text" : "getvdevlist"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-111",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1226.0, 876.0, 42.0, 23.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 333.4666337966919, 176.09999519586563, 42.0, 23.0 ],
									"text" : "close"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-112",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1226.0, 844.0, 40.0, 23.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 288.6666331291199, 176.09999519586563, 40.0, 23.0 ],
									"text" : "open"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-113",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_gl_texture", "" ],
									"patching_rect" : [ 1148.0, 951.0, 50.0, 23.0 ],
									"text" : "jit.grab"
								}
							},
							{
								"box" : {
									"id" : "obj-12",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1444.0, 1374.0, 150.0, 20.0 ],
									"text" : "enable x y 0 zx zy 0 0 0 r"
								}
							},
							{
								"box" : {
									"id" : "obj-39",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 31.0, 381.0, 78.0, 22.0 ],
									"text" : "r imageMove"
								}
							},
							{
								"box" : {
									"id" : "obj-38",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 176.0, 533.0, 55.0, 22.0 ],
									"text" : "zl slice 3"
								}
							},
							{
								"box" : {
									"id" : "obj-37",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 136.0, 504.0, 55.0, 22.0 ],
									"text" : "zl slice 3"
								}
							},
							{
								"box" : {
									"id" : "obj-36",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 66.0, 504.0, 55.0, 22.0 ],
									"text" : "zl slice 3"
								}
							},
							{
								"box" : {
									"id" : "obj-35",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 31.0, 470.0, 55.0, 22.0 ],
									"text" : "zl slice 1"
								}
							},
							{
								"box" : {
									"id" : "obj-33",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 27.0, 568.0, 92.0, 22.0 ],
									"text" : "prepend enable"
								}
							},
							{
								"box" : {
									"id" : "obj-32",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 66.0, 535.0, 97.0, 22.0 ],
									"text" : "prepend position"
								}
							},
							{
								"box" : {
									"id" : "obj-31",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 192.0, 597.0, 84.0, 22.0 ],
									"text" : "prepend scale"
								}
							},
							{
								"box" : {
									"id" : "obj-29",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 176.0, 560.0, 105.0, 22.0 ],
									"text" : "prepend rotatexyz"
								}
							},
							{
								"box" : {
									"id" : "obj-28",
									"maxclass" : "newobj",
									"numinlets" : 10,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1439.0, 1396.0, 161.0, 22.0 ],
									"text" : "pak 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-27",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1444.0, 1429.0, 80.0, 22.0 ],
									"text" : "s imageMove"
								}
							},
							{
								"box" : {
									"attr" : "blend",
									"id" : "obj-6",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 27.0, 715.0, 210.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "blend_mode",
									"id" : "obj-4",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 27.0, 689.0, 210.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "layer",
									"id" : "obj-3",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 27.0, 662.0, 133.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 3.0, 772.0, 476.0, 22.0 ],
									"text" : "jit.gl.layer foo @layer 2 @enable 0 @shadow_caster 0 @two_sided 0 @auto_material 0"
								}
							},
							{
								"box" : {
									"id" : "obj-21",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1148.0, 922.0, 82.0, 22.0 ],
									"text" : "exportattrs $1"
								}
							},
							{
								"box" : {
									"attr" : "interp",
									"id" : "obj-169",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 27.0, 635.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-34",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 606.0, 934.0, 82.0, 22.0 ],
									"text" : "s cameragrab"
								}
							},
							{
								"box" : {
									"id" : "obj-143",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 603.0, 901.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-52",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 489.0, 789.0, 54.0, 22.0 ],
									"text" : "dict.print"
								}
							},
							{
								"box" : {
									"hidden" : 1,
									"id" : "obj-20",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 652.0, 681.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-18",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 651.0, 711.0, 106.0, 22.0 ],
									"text" : "getsourcelistmenu"
								}
							},
							{
								"box" : {
									"id" : "obj-16",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 548.0, 711.0, 76.0, 22.0 ],
									"text" : "getsourcelist"
								}
							},
							{
								"box" : {
									"id" : "obj-58",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "", "", "" ],
									"patching_rect" : [ 489.0, 759.0, 174.0, 22.0 ],
									"text" : "route sourcelist sourcelistmenu"
								}
							},
							{
								"box" : {
									"allowdrag" : 0,
									"id" : "obj-59",
									"items" : "<empty>",
									"maxclass" : "umenu",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "int", "", "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 995.0, 456.0, 179.5, 22.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 359.000116109848, 264.0, 200.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "LOCALHOST (Telestripe-1014)", "IPAD 1687 (NDI HX Camera)" ],
											"parameter_longname" : "umenu",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "umenu",
											"parameter_type" : 2
										}
									},
									"varname" : "umenu"
								}
							},
							{
								"box" : {
									"id" : "obj-1",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "multichannelsignal", "jit_matrix", "" ],
									"patching_rect" : [ 433.0, 700.0, 96.0, 22.0 ],
									"text" : "jit.ndi.receive~ 2"
								}
							},
							{
								"box" : {
									"attr" : "colormode",
									"id" : "obj-45",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 506.0, 635.0, 233.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-47",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 548.0, 678.0, 75.0, 22.0 ],
									"text" : "summary $1"
								}
							},
							{
								"box" : {
									"id" : "obj-140",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 988.0, 1295.0, 117.0, 22.0 ],
									"text" : "ptz_recall_preset $1"
								}
							},
							{
								"box" : {
									"background" : 1,
									"color" : [ 0.0, 0.0, 0.0, 0.301960784313725 ],
									"id" : "obj-202",
									"ignoreclick" : 1,
									"maxclass" : "mira.frame",
									"numinlets" : 0,
									"numoutlets" : 0,
									"patching_rect" : [ 987.0, 97.0, 548.5714423656464, 390.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 212.0, -6.0, 714.268142383963, 507.79999470710754 ],
									"tabname" : "VidIn",
									"taborder" : 3
								}
							},
							{
								"box" : {
									"attr" : "output_texture",
									"id" : "obj-8",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 93.0, 222.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "automatic",
									"id" : "obj-199",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 256.0, 690.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-209",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 156.0, 743.0, 51.0, 22.0 ],
									"text" : "draw $1"
								}
							},
							{
								"box" : {
									"id" : "obj-222",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 210.0, 743.0, 107.0, 22.0 ],
									"text" : "drawimmediate $1"
								}
							},
							{
								"box" : {
									"id" : "obj-242",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 320.0, 743.0, 71.0, 22.0 ],
									"text" : "drawraw $1"
								}
							},
							{
								"box" : {
									"attr" : "blend_enable",
									"id" : "obj-318",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 18.0, 604.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-recv-sticker-folder",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 50.0, 10.0, 170.0, 22.0 ],
									"text" : "receive feedbax_sticker_folder"
								}
							},
							{
								"box" : {
									"id" : "obj-recv-as-folder",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 50.0, 10.0, 190.0, 22.0 ],
									"text" : "receive feedbax_as_sticker_folder"
								}
							}
						],
						"lines" : [
							{
								"patchline" : {
									"destination" : [ "obj-133", 0 ],
									"source" : [ "obj-1", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-58", 0 ],
									"midpoints" : [ 519.5, 735.3694527071075, 498.5, 735.3694527071075 ],
									"source" : [ "obj-1", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-10", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-101", 0 ],
									"source" : [ "obj-100", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-110", 0 ],
									"source" : [ "obj-102", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-110", 0 ],
									"source" : [ "obj-103", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-101", 1 ],
									"source" : [ "obj-104", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-102", 0 ],
									"source" : [ "obj-104", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-102", 0 ],
									"source" : [ "obj-104", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-107", 0 ],
									"midpoints" : [ 2125.5, 635.5, 1486.5, 635.5 ],
									"source" : [ "obj-104", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"midpoints" : [ 1371.5, 942.75, 1157.5, 942.75 ],
									"source" : [ "obj-105", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"midpoints" : [ 1371.5, 943.25, 1157.5, 943.25 ],
									"source" : [ "obj-106", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-108", 0 ],
									"source" : [ "obj-107", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-41", 0 ],
									"source" : [ "obj-107", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-108", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"midpoints" : [ 1519.5, 942.25, 1157.5, 942.25 ],
									"source" : [ "obj-109", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-287", 0 ],
									"source" : [ "obj-11", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"midpoints" : [ 1295.5, 941.75, 1157.5, 941.75 ],
									"source" : [ "obj-110", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"source" : [ "obj-111", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"source" : [ "obj-112", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-104", 0 ],
									"midpoints" : [ 1188.5, 579.5000009536743, 1758.5000627040863, 579.5000009536743, 1758.5000627040863, 537.5000009536743, 1773.5, 537.5000009536743 ],
									"source" : [ "obj-113", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-17", 1 ],
									"source" : [ "obj-113", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-59", 0 ],
									"source" : [ "obj-114", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 1 ],
									"source" : [ "obj-115", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-90", 0 ],
									"source" : [ "obj-117", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-89", 0 ],
									"source" : [ "obj-118", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-95", 0 ],
									"source" : [ "obj-119", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-160", 0 ],
									"order" : 1,
									"source" : [ "obj-120", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-51", 0 ],
									"order" : 2,
									"source" : [ "obj-120", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-87", 0 ],
									"order" : 0,
									"source" : [ "obj-120", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-153", 0 ],
									"order" : 2,
									"source" : [ "obj-121", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-263", 0 ],
									"order" : 0,
									"source" : [ "obj-121", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-48", 0 ],
									"order" : 1,
									"source" : [ "obj-121", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-116", 0 ],
									"source" : [ "obj-123", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-116", 0 ],
									"source" : [ "obj-124", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-123", 0 ],
									"source" : [ "obj-126", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-124", 0 ],
									"source" : [ "obj-127", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"source" : [ "obj-13", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-143", 1 ],
									"source" : [ "obj-133", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 4 ],
									"source" : [ "obj-134", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 2 ],
									"source" : [ "obj-135", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-156", 0 ],
									"source" : [ "obj-138", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-138", 1 ],
									"source" : [ "obj-139", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-138", 0 ],
									"source" : [ "obj-139", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-54", 0 ],
									"source" : [ "obj-14", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-71", 0 ],
									"source" : [ "obj-14", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-129", 0 ],
									"source" : [ "obj-140", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 3 ],
									"source" : [ "obj-142", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-34", 0 ],
									"source" : [ "obj-143", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"source" : [ "obj-144", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-146", 0 ],
									"source" : [ "obj-145", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-109", 0 ],
									"order" : 1,
									"source" : [ "obj-146", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-110", 0 ],
									"order" : 2,
									"source" : [ "obj-146", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-148", 0 ],
									"order" : 0,
									"source" : [ "obj-146", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-112", 0 ],
									"source" : [ "obj-148", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-149", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-17", 0 ],
									"source" : [ "obj-15", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-234", 0 ],
									"order" : 0,
									"source" : [ "obj-150", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-265", 0 ],
									"order" : 1,
									"source" : [ "obj-150", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-83", 0 ],
									"source" : [ "obj-153", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-252", 2 ],
									"source" : [ "obj-155", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-280", 1 ],
									"source" : [ "obj-155", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-156", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-166", 0 ],
									"source" : [ "obj-158", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-179", 0 ],
									"source" : [ "obj-159", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"midpoints" : [ 557.5, 763.3694527071075, 442.5, 763.3694527071075 ],
									"source" : [ "obj-16", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-160", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-159", 0 ],
									"source" : [ "obj-161", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-161", 0 ],
									"source" : [ "obj-165", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-176", 0 ],
									"source" : [ "obj-166", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-169", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-188", 0 ],
									"source" : [ "obj-17", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-170", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-173", 0 ],
									"source" : [ "obj-172", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-173", 1 ],
									"source" : [ "obj-172", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-168", 0 ],
									"source" : [ "obj-173", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-172", 0 ],
									"source" : [ "obj-174", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-174", 0 ],
									"source" : [ "obj-175", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-174", 1 ],
									"source" : [ "obj-176", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-175", 0 ],
									"source" : [ "obj-176", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-248", 0 ],
									"source" : [ "obj-179", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"midpoints" : [ 660.5, 763.3694527071075, 442.5, 763.3694527071075 ],
									"source" : [ "obj-18", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-143", 0 ],
									"order" : 0,
									"source" : [ "obj-180", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"order" : 2,
									"source" : [ "obj-180", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-93", 0 ],
									"order" : 1,
									"source" : [ "obj-180", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-270", 0 ],
									"source" : [ "obj-181", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-159", 0 ],
									"source" : [ "obj-182", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-170", 0 ],
									"source" : [ "obj-183", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-189", 0 ],
									"source" : [ "obj-186", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-159", 0 ],
									"source" : [ "obj-189", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-19", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-192", 0 ],
									"source" : [ "obj-190", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-155", 0 ],
									"source" : [ "obj-191", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-159", 0 ],
									"source" : [ "obj-192", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-198", 0 ],
									"source" : [ "obj-195", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-196", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-317", 0 ],
									"source" : [ "obj-197", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-159", 0 ],
									"source" : [ "obj-198", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-199", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 0 ],
									"hidden" : 1,
									"source" : [ "obj-20", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-271", 0 ],
									"source" : [ "obj-200", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-35", 0 ],
									"source" : [ "obj-201", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-196", 0 ],
									"source" : [ "obj-203", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-155", 0 ],
									"source" : [ "obj-204", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-201", 0 ],
									"source" : [ "obj-207", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-207", 0 ],
									"source" : [ "obj-208", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-209", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"source" : [ "obj-21", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-272", 0 ],
									"source" : [ "obj-210", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-273", 0 ],
									"source" : [ "obj-211", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-274", 0 ],
									"source" : [ "obj-212", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-213", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-214", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-215", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-216", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-217", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-218", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-219", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 1 ],
									"source" : [ "obj-22", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-220", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-275", 0 ],
									"source" : [ "obj-221", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-222", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-129", 0 ],
									"source" : [ "obj-225", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-225", 1 ],
									"source" : [ "obj-226", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-225", 2 ],
									"source" : [ "obj-227", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-230", 1 ],
									"source" : [ "obj-229", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-129", 0 ],
									"source" : [ "obj-230", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 5 ],
									"source" : [ "obj-232", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 6 ],
									"source" : [ "obj-233", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-24", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-121", 0 ],
									"source" : [ "obj-240", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-242", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-97", 0 ],
									"source" : [ "obj-243", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-150", 0 ],
									"source" : [ "obj-244", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 1 ],
									"source" : [ "obj-249", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-25", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-48", 1 ],
									"source" : [ "obj-250", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-153", 1 ],
									"source" : [ "obj-251", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-263", 1 ],
									"order" : 1,
									"source" : [ "obj-252", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-264", 1 ],
									"order" : 0,
									"source" : [ "obj-252", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-161", 0 ],
									"source" : [ "obj-253", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-198", 0 ],
									"source" : [ "obj-254", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-192", 0 ],
									"source" : [ "obj-255", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-189", 0 ],
									"source" : [ "obj-256", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-252", 0 ],
									"source" : [ "obj-257", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-283", 0 ],
									"source" : [ "obj-258", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-247", 0 ],
									"source" : [ "obj-26", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-258", 1 ],
									"source" : [ "obj-260", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-262", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-48", 0 ],
									"source" : [ "obj-263", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 0 ],
									"source" : [ "obj-264", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-223", 0 ],
									"source" : [ "obj-265", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-258", 2 ],
									"source" : [ "obj-267", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-258", 3 ],
									"source" : [ "obj-268", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-252", 1 ],
									"source" : [ "obj-269", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 0 ],
									"source" : [ "obj-270", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 1 ],
									"source" : [ "obj-271", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 2 ],
									"source" : [ "obj-272", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 5 ],
									"source" : [ "obj-273", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 4 ],
									"source" : [ "obj-274", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 3 ],
									"source" : [ "obj-275", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-252", 3 ],
									"source" : [ "obj-276", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-307", 1 ],
									"source" : [ "obj-279", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-27", 0 ],
									"source" : [ "obj-28", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-295", 0 ],
									"source" : [ "obj-283", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 6 ],
									"source" : [ "obj-285", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 7 ],
									"source" : [ "obj-286", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-155", 0 ],
									"source" : [ "obj-287", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-29", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-292", 0 ],
									"source" : [ "obj-291", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-293", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 11 ],
									"source" : [ "obj-295", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 10 ],
									"source" : [ "obj-295", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 9 ],
									"source" : [ "obj-295", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 8 ],
									"source" : [ "obj-295", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-297", 0 ],
									"source" : [ "obj-296", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-153", 4 ],
									"source" : [ "obj-297", 5 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-153", 3 ],
									"source" : [ "obj-297", 4 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-153", 2 ],
									"source" : [ "obj-297", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 4 ],
									"source" : [ "obj-297", 10 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 3 ],
									"source" : [ "obj-297", 9 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 2 ],
									"source" : [ "obj-297", 8 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 6 ],
									"source" : [ "obj-297", 7 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 5 ],
									"source" : [ "obj-297", 6 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-48", 4 ],
									"source" : [ "obj-297", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-48", 3 ],
									"source" : [ "obj-297", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-48", 2 ],
									"source" : [ "obj-297", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-3", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"midpoints" : [ 1099.5, 633.0, 1232.0, 633.0, 1232.0, 503.0, 1157.5, 503.0 ],
									"source" : [ "obj-30", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-181", 0 ],
									"order" : 8,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-200", 0 ],
									"order" : 6,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-210", 0 ],
									"order" : 3,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-211", 0 ],
									"order" : 2,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-212", 0 ],
									"order" : 5,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-221", 0 ],
									"order" : 7,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-303", 0 ],
									"order" : 0,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-304", 0 ],
									"order" : 1,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-306", 0 ],
									"order" : 4,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-331", 0 ],
									"order" : 11,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-333", 0 ],
									"order" : 10,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-336", 0 ],
									"order" : 9,
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-286", 0 ],
									"source" : [ "obj-303", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-285", 0 ],
									"source" : [ "obj-304", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-153", 0 ],
									"source" : [ "obj-305", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-283", 0 ],
									"source" : [ "obj-306", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-307", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-48", 0 ],
									"source" : [ "obj-308", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-31", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-109", 0 ],
									"order" : 0,
									"source" : [ "obj-310", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-110", 0 ],
									"order" : 1,
									"source" : [ "obj-310", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"source" : [ "obj-314", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"source" : [ "obj-315", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-307", 0 ],
									"source" : [ "obj-316", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-193", 0 ],
									"source" : [ "obj-317", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-318", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-317", 0 ],
									"source" : [ "obj-319", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-32", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-317", 1 ],
									"order" : 1,
									"source" : [ "obj-322", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-335", 1 ],
									"order" : 0,
									"source" : [ "obj-322", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-317", 2 ],
									"source" : [ "obj-325", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-317", 3 ],
									"source" : [ "obj-326", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-322", 0 ],
									"source" : [ "obj-331", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-325", 0 ],
									"source" : [ "obj-333", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-326", 0 ],
									"source" : [ "obj-336", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-138", 0 ],
									"order" : 0,
									"source" : [ "obj-35", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-33", 0 ],
									"order" : 1,
									"source" : [ "obj-35", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-36", 0 ],
									"source" : [ "obj-35", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-32", 0 ],
									"source" : [ "obj-36", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-37", 0 ],
									"source" : [ "obj-36", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-31", 0 ],
									"source" : [ "obj-37", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-38", 0 ],
									"source" : [ "obj-37", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-29", 0 ],
									"source" : [ "obj-38", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-201", 1 ],
									"source" : [ "obj-39", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-4", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"midpoints" : [ 1294.5, 544.0, 1233.5, 544.0, 1233.5, 530.5, 1157.5, 530.5 ],
									"source" : [ "obj-40", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-40", 0 ],
									"source" : [ "obj-41", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-44", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-45", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-46", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-47", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-153", 0 ],
									"source" : [ "obj-48", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"order" : 1,
									"source" : [ "obj-49", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-73", 0 ],
									"order" : 0,
									"source" : [ "obj-49", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-53", 0 ],
									"order" : 1,
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-79", 0 ],
									"order" : 0,
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-49", 0 ],
									"source" : [ "obj-53", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-49", 0 ],
									"source" : [ "obj-54", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-49", 0 ],
									"source" : [ "obj-54", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-60", 0 ],
									"source" : [ "obj-55", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-66", 0 ],
									"source" : [ "obj-57", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-52", 0 ],
									"source" : [ "obj-58", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-59", 0 ],
									"source" : [ "obj-58", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"midpoints" : [ 1084.75, 765.3694527071075, 689.0, 765.3694527071075, 689.0, 740.3694527071075, 442.5, 740.3694527071075 ],
									"source" : [ "obj-59", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-6", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-134", 0 ],
									"source" : [ "obj-60", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-135", 0 ],
									"source" : [ "obj-60", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-142", 0 ],
									"source" : [ "obj-60", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-65", 0 ],
									"order" : 1,
									"source" : [ "obj-61", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-69", 0 ],
									"order" : 0,
									"source" : [ "obj-61", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-76", 0 ],
									"order" : 1,
									"source" : [ "obj-62", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-82", 1 ],
									"order" : 0,
									"source" : [ "obj-62", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-5", 0 ],
									"order" : 1,
									"source" : [ "obj-63", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-68", 1 ],
									"order" : 0,
									"source" : [ "obj-63", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-182", 0 ],
									"source" : [ "obj-64", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-61", 0 ],
									"source" : [ "obj-65", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-61", 0 ],
									"source" : [ "obj-66", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-9", 0 ],
									"source" : [ "obj-67", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-7", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-57", 0 ],
									"order" : 1,
									"source" : [ "obj-70", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-79", 0 ],
									"order" : 0,
									"source" : [ "obj-70", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-72", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-15", 0 ],
									"order" : 1,
									"source" : [ "obj-74", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-24", 0 ],
									"order" : 0,
									"source" : [ "obj-74", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-75", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-55", 0 ],
									"source" : [ "obj-76", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-77", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-10", 0 ],
									"source" : [ "obj-78", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-61", 0 ],
									"source" : [ "obj-79", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-49", 0 ],
									"source" : [ "obj-8", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-114", 0 ],
									"source" : [ "obj-80", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-91", 0 ],
									"source" : [ "obj-81", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-117", 0 ],
									"source" : [ "obj-84", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-92", 1 ],
									"source" : [ "obj-85", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-118", 0 ],
									"source" : [ "obj-86", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-139", 0 ],
									"order" : 1,
									"source" : [ "obj-87", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-92", 0 ],
									"order" : 0,
									"source" : [ "obj-87", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-116", 0 ],
									"midpoints" : [ 1955.5, 957.6110979914665, 2090.5, 957.6110979914665 ],
									"source" : [ "obj-88", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-116", 0 ],
									"midpoints" : [ 2097.5, 957.6110979914665, 2090.5, 957.6110979914665 ],
									"source" : [ "obj-89", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-155", 0 ],
									"source" : [ "obj-9", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-116", 0 ],
									"midpoints" : [ 2201.5, 957.6110979914665, 2090.5, 957.6110979914665 ],
									"source" : [ "obj-90", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-88", 0 ],
									"source" : [ "obj-91", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-92", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 0 ],
									"order" : 1,
									"source" : [ "obj-93", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-53", 0 ],
									"source" : [ "obj-93", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-80", 0 ],
									"order" : 0,
									"source" : [ "obj-93", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-116", 0 ],
									"source" : [ "obj-95", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 0 ],
									"order" : 1,
									"source" : [ "obj-97", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-264", 0 ],
									"order" : 0,
									"source" : [ "obj-97", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"midpoints" : [ 1540.5, 942.75, 1157.5, 942.75 ],
									"source" : [ "obj-99", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-recv-sticker-folder", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-recv-as-folder", 0 ]
								}
							}
						],
						"boxgroups" : [
							{
								"boxes" : [
									"obj-65",
									"obj-57",
									"obj-61"
								]
							},
							{
								"boxes" : [
									"obj-87",
									"obj-42"
								]
							},
							{
								"boxes" : [
									"obj-184",
									"obj-180"
								]
							},
							{
								"boxes" : [
									"obj-126",
									"obj-151"
								]
							},
							{
								"boxes" : [
									"obj-127",
									"obj-163"
								]
							},
							{
								"boxes" : [
									"obj-119",
									"obj-177"
								]
							},
							{
								"boxes" : [
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
								"boxes" : [
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
								"boxes" : [
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
								"boxes" : [
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
								"boxes" : [
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
								"boxes" : [
									"obj-162",
									"obj-160"
								]
							},
							{
								"boxes" : [
									"obj-185",
									"obj-108",
									"obj-310",
									"obj-312",
									"obj-314",
									"obj-315"
								]
							},
							{
								"boxes" : [
									"obj-98",
									"obj-59",
									"obj-75",
									"obj-96",
									"obj-203",
									"obj-245"
								]
							},
							{
								"boxes" : [
									"obj-125",
									"obj-94",
									"obj-11",
									"obj-67"
								]
							},
							{
								"boxes" : [
									"obj-328",
									"obj-329",
									"obj-330",
									"obj-326",
									"obj-325",
									"obj-322"
								]
							}
						]
					},
					"patching_rect" : [ 23.5, 71.0, 139.0, 36.0 ],
					"text" : "p picsVid",
					"textcolor" : [ 0.0, 1.0, 0.0, 1.0 ],
					"varname" : "vid"
				}
			},
			{
				"box" : {
					"id" : "obj-119",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 178.0, 643.0, 115.0, 22.0 ],
					"text" : "r erasetransparency"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-107",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1318.0, 87.0, 81.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1102.5, 278.0, 81.0, 22.0 ],
					"text" : "dim 1280 720"
				}
			},
			{
				"box" : {
					"id" : "obj-115",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1052.0, 160.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.5, 376.9000023007393, 29.5, 22.0 ],
					"text" : "800"
				}
			},
			{
				"box" : {
					"id" : "obj-114",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1052.0, 136.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.5, 352.9000023007393, 29.5, 22.0 ],
					"text" : "400"
				}
			},
			{
				"box" : {
					"id" : "obj-113",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1052.0, 115.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.5, 331.5, 29.5, 22.0 ],
					"text" : "200"
				}
			},
			{
				"box" : {
					"id" : "obj-112",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1052.0, 89.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.5, 305.8000046014786, 29.5, 22.0 ],
					"text" : "100"
				}
			},
			{
				"box" : {
					"id" : "obj-111",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1012.0, 67.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.25, 151.5, 29.5, 22.0 ],
					"text" : "0"
				}
			},
			{
				"box" : {
					"id" : "obj-110",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1012.0, 94.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.25, 178.4000023007393, 29.5, 22.0 ],
					"text" : "10"
				}
			},
			{
				"box" : {
					"id" : "obj-109",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1012.0, 172.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.5, 256.4000023007393, 29.5, 22.0 ],
					"text" : "50"
				}
			},
			{
				"box" : {
					"id" : "obj-108",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1052.0, 67.0, 29.5, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1034.5, 283.4000023007393, 29.5, 22.0 ],
					"text" : "75"
				}
			},
			{
				"box" : {
					"id" : "obj-97",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 46.0, 323.0, 77.0, 22.0 ],
					"text" : "loadmess 60"
				}
			},
			{
				"box" : {
					"id" : "obj-3",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 65.0, 627.0, 70.0, 22.0 ],
					"text" : "loadmess 1"
				}
			},
			{
				"box" : {
					"fontface" : 0,
					"fontname" : "Arial",
					"fontsize" : 18.0,
					"id" : "obj-106",
					"maxclass" : "jit.fpsgui",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 24.0, 268.0, 71.0, 42.0 ]
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-92",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1034.0, 562.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[108]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[29]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[24]"
				}
			},
			{
				"box" : {
					"id" : "obj-91",
					"maxclass" : "newobj",
					"numinlets" : 5,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 973.0, 593.0, 111.0, 22.0 ],
					"text" : "pak color 1. 1. 1. 1."
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-88",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1264.0, 537.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[106]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[11]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[22]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-89",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1207.0, 536.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[107]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[10]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[23]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-90",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1131.0, 563.0, 117.0, 22.0 ],
					"text" : "pak blend_mode 6 8"
				}
			},
			{
				"box" : {
					"id" : "obj-87",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 239.61165076494217, 19.203884959220886, 25.0, 22.0 ],
					"text" : "r fs"
				}
			},
			{
				"box" : {
					"id" : "obj-84",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 178.0, 673.0, 107.0, 22.0 ],
					"text" : "scale 0 1. 0.8 1. 3."
				}
			},
			{
				"box" : {
					"id" : "obj-81",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1529.0, 435.0, 97.0, 22.0 ],
					"text" : "loadmess -0.414"
				}
			},
			{
				"box" : {
					"id" : "obj-80",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1371.0, 471.0, 73.0, 22.0 ],
					"text" : "loadmess 1."
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-79",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1371.0, 500.0, 50.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1124.0, 459.5, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[29]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[29]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[21]"
				}
			},
			{
				"box" : {
					"id" : "obj-78",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 1342.0, 544.0, 40.0, 22.0 ],
					"text" : "* 1.78"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-73",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1437.0, 571.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[28]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[28]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[20]"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-74",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1322.0, 571.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[27]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[27]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[19]"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-76",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1377.0, 571.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[26]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[26]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[18]"
				}
			},
			{
				"box" : {
					"id" : "obj-77",
					"maxclass" : "newobj",
					"numinlets" : 4,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1321.0, 602.0, 113.0, 22.0 ],
					"text" : "pak scale 1.78 1. 1."
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-67",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1568.0, 470.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[25]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[25]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[17]"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-69",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1513.0, 571.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[24]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[24]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[16]"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-71",
					"maxclass" : "flonum",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1568.0, 571.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[23]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[23]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[15]"
				}
			},
			{
				"box" : {
					"id" : "obj-72",
					"maxclass" : "newobj",
					"numinlets" : 4,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1512.0, 603.0, 113.0, 22.0 ],
					"text" : "pak position 0. 0. 0."
				}
			},
			{
				"box" : {
					"id" : "obj-12",
					"maxclass" : "newobj",
					"numinlets" : 4,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1680.0, 604.0, 120.0, 22.0 ],
					"text" : "pak rotatexyz 0. 0. 0."
				}
			},
			{
				"box" : {
					"id" : "obj-26",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 960.0, 204.0, 83.0, 22.0 ],
					"text" : "loadmess 100"
				}
			},
			{
				"box" : {
					"id" : "obj-104",
					"maxclass" : "number",
					"maximum" : 5000,
					"minimum" : 0,
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1046.0, 232.0, 50.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1028.4999999403954, 448.9000023007393, 67.75000005960464, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_longname" : "number[19]",
							"parameter_mmax" : 5000.0,
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[19]",
							"parameter_type" : 0
						}
					},
					"varname" : "number[11]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-103",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 979.0, 264.0, 111.0, 22.0 ],
					"text" : "s controlSmoothMs"
				}
			},
			{
				"box" : {
					"id" : "obj-13",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 54.0, 854.0, 180.0, 22.0 ],
					"text" : "blend_mode 6 8 0.92 interesting"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-7",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1167.0, 159.0, 88.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1099.0, 230.9000023007393, 88.0, 22.0 ],
					"text" : "dim 2560 1600"
				}
			},
			{
				"box" : {
					"fontface" : 1,
					"fontname" : "Menlo Bold",
					"fontsize" : 24.0,
					"id" : "obj-6",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 0,
					"patcher" : {
						"fileversion" : 1,
						"appversion" : {
							"major" : 9,
							"minor" : 0,
							"revision" : 7,
							"architecture" : "x64",
							"modernui" : 1
						},
						"classnamespace" : "box",
						"rect" : [ 273.0, 453.0, 799.0, 797.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Menlo Bold",
									"fontsize" : 10.0,
									"id" : "obj-139",
									"linecount" : 8,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1326.0, 473.0, 17.0625, 100.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 940.75, 421.0, 33.0, 30.0 ],
									"text" : "CONTRAST",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-140",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1321.0, 446.0, 25.875, 151.876089528203 ],
									"presentation" : 1,
									"presentation_rect" : [ 933.75, 407.0, 21.0, 102.16666576266289 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "slider[26]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 3
										}
									},
									"size" : 2.0,
									"varname" : "slider[3]"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-138",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 573.75, 420.0, 36.0, 27.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 568.25, 427.5, 94.0, 17.0 ],
									"text" : "pic  -size",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-132",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 592.6666843295097, 396.66667848825455, 66.0, 17.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 578.0000172257423, 392.66667836904526, 94.0, 17.0 ],
									"text" : "pic rotate",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 6.0,
									"id" : "obj-136",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 718.6666880846024, 460.6666803956032, 34.125000953674316, 13.0 ],
									"text" : "Circle",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 6.0,
									"id" : "obj-134",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 692.0000206232071, 460.6666803956032, 36.0, 20.0 ],
									"text" : "Bass\n",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-131",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 480.00001430511475, 63.0, 46.999985694885254, 20.0 ],
									"text" : "1"
								}
							},
							{
								"box" : {
									"id" : "obj-119",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1060.0, 596.0, 29.5, 22.0 ],
									"text" : "1."
								}
							},
							{
								"box" : {
									"id" : "obj-117",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1060.0, 562.0, 12.291664689779282, 12.291664689779282 ],
									"presentation" : 1,
									"presentation_rect" : [ 1051.25, 782.75, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[18]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[2]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[8]"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-116",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 888.0, 561.0, 61.0, 17.0 ],
									"text" : "Reset ->"
								}
							},
							{
								"box" : {
									"id" : "obj-63",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1031.0, 563.0, 12.291664689779282, 12.291664689779282 ],
									"presentation" : 1,
									"presentation_rect" : [ 1036.25, 767.75, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[17]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[2]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[6]"
								}
							},
							{
								"box" : {
									"id" : "obj-36",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1032.0, 596.0, 29.5, 22.0 ],
									"text" : "1."
								}
							},
							{
								"box" : {
									"id" : "obj-43",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 474.0, 304.0, 87.0, 22.0 ],
									"text" : "loadmess 1.25"
								}
							},
							{
								"box" : {
									"id" : "obj-42",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 447.0, 269.33334136009216, 73.0, 22.0 ],
									"text" : "loadmess 1."
								}
							},
							{
								"box" : {
									"id" : "obj-15",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 748.0, 990.0, 60.0, 22.0 ],
									"text" : "zl.change"
								}
							},
							{
								"box" : {
									"id" : "obj-13",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 762.0, 900.0, 31.0, 22.0 ],
									"text" : "float"
								}
							},
							{
								"box" : {
									"id" : "obj-133",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 724.0000215768814, 468.0000139474869, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[54]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[54]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[13]"
								}
							},
							{
								"box" : {
									"id" : "obj-71",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 566.0, 685.0, 128.0, 22.0 ],
									"text" : "s soundwave_enable1"
								}
							},
							{
								"box" : {
									"blinkcolor" : [ 0.909803921568627, 0.909803921568627, 0.807843137254902, 1.0 ],
									"id" : "obj-163",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"outlinecolor" : [ 0.925490196078431, 0.125490196078431, 0.529411764705882, 1.0 ],
									"parameter_enable" : 1,
									"patching_rect" : [ 825.0, 531.75, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[11]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[9]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[7]"
								}
							},
							{
								"box" : {
									"id" : "obj-235",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 665.0, 598.0, 60.0, 22.0 ],
									"text" : "s savePic"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-222",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 848.0, 536.25, 51.25, 17.0 ],
									"text" : "capture"
								}
							},
							{
								"box" : {
									"id" : "obj-129",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 513.0, 592.0, 51.0, 22.0 ],
									"text" : "s livevid"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-127",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 581.25, 533.25, 45.0, 17.0 ],
									"text" : "Video?"
								}
							},
							{
								"box" : {
									"id" : "obj-107",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 562.5, 532.25, 18.0, 18.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[45]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[45]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[12]"
								}
							},
							{
								"box" : {
									"id" : "obj-123",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 795.0, 627.0, 61.0, 22.0 ],
									"text" : "pipe 1500"
								}
							},
							{
								"box" : {
									"id" : "obj-112",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 795.0, 592.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-108",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 863.0, 811.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[120]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[5]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[8]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-105",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 915.0, 811.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[119]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[5]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[5]"
								}
							},
							{
								"box" : {
									"id" : "obj-174",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 59.0, 106.0, 640.0, 659.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-232",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 461.7166722416878, 432.615024, 151.0, 22.0 ],
													"text" : "scale -360. 360. 360. -360."
												}
											},
											{
												"box" : {
													"id" : "obj-231",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 377.25, 340.4984563589096, 29.5, 22.0 ],
													"text" : "0"
												}
											},
											{
												"box" : {
													"id" : "obj-229",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 396.25, 384.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-227",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 358.70353920509194, 423.0, 57.0, 22.0 ],
													"text" : "accum 0."
												}
											},
											{
												"box" : {
													"id" : "obj-224",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 56.25, 241.0, 29.5, 22.0 ],
													"text" : "&&"
												}
											},
											{
												"box" : {
													"id" : "obj-221",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 50.0, 423.0, 42.0, 22.0 ],
													"text" : "< 1.01"
												}
											},
											{
												"box" : {
													"id" : "obj-219",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 78.85867158571875, 391.615024, 130.0, 22.0 ],
													"text" : "scale 0. 100. 0. 1. 1.02"
												}
											},
											{
												"box" : {
													"id" : "obj-194",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 108.41666666666652, 216.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-193",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 162.24997663497925, 238.0, 33.0, 22.0 ],
													"text" : "* 0.1"
												}
											},
											{
												"box" : {
													"id" : "obj-190",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 64.25, 120.0, 29.5, 22.0 ],
													"text" : "!= 1"
												}
											},
											{
												"box" : {
													"id" : "obj-189",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 82.82353920902631, 189.71666844189167, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-179",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 130.08328660329198, 126.0, 29.5, 22.0 ],
													"text" : "< 1."
												}
											},
											{
												"box" : {
													"id" : "obj-174",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 134.8235392090263, 176.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-159",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 89.85867158571875, 254.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-161",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 82.82353920902631, 292.0, 71.0, 22.0 ],
													"text" : "accum 0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-149",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 454.7166722416878, 306.33331859111786, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-143",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 426.7166722416878, 230.33331859111786, 22.0, 22.0 ],
													"text" : "t b"
												}
											},
											{
												"box" : {
													"id" : "obj-140",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 426.7166722416878, 263.33331859111786, 29.5, 22.0 ],
													"text" : "&&"
												}
											},
											{
												"box" : {
													"id" : "obj-139",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 465.7166722416878, 216.0, 33.0, 22.0 ],
													"text" : "== 1"
												}
											},
											{
												"box" : {
													"id" : "obj-138",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 383.7166722416878, 216.0, 33.0, 22.0 ],
													"text" : "== 1"
												}
											},
											{
												"box" : {
													"id" : "obj-136",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 191.0833097100258, 250.0, 36.0, 22.0 ],
													"text" : "<= 1."
												}
											},
											{
												"box" : {
													"id" : "obj-134",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 239.26489300000003, 286.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-133",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 285.76489300000003, 286.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-132",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 201.5833097100258, 326.33331859111786, 58.0, 22.0 ],
													"text" : "loadbang"
												}
											},
											{
												"box" : {
													"id" : "obj-131",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 209.25, 406.0, 57.0, 22.0 ],
													"text" : "clip -1. 1."
												}
											},
											{
												"box" : {
													"id" : "obj-129",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 252.24997637669242, 136.9000249999999, 57.0, 22.0 ],
													"text" : "clip -3. 3."
												}
											},
											{
												"box" : {
													"id" : "obj-127",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 195.0833097100258, 357.0, 32.0, 22.0 ],
													"text" : "0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-125",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 279.7499763766924, 326.33331859111786, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-123",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 272.71484399999997, 364.33331859111786, 71.0, 22.0 ],
													"text" : "accum 0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-119",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 292.21484399999997, 250.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-117",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 241.41663942734397, 246.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-113",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 201.5833097100258, 209.0, 29.5, 22.0 ],
													"text" : "> 0."
												}
											},
											{
												"box" : {
													"id" : "obj-112",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 312.71484399999997, 209.0, 29.5, 22.0 ],
													"text" : "< 0."
												}
											},
											{
												"box" : {
													"id" : "obj-108",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 239.26489300000003, 176.0, 125.0, 22.0 ],
													"text" : "scale -10. 10. -0.2 0.2"
												}
											},
											{
												"box" : {
													"id" : "obj-107",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 426.4666722416878, 161.0, 29.5, 22.0 ],
													"text" : "0"
												}
											},
											{
												"box" : {
													"id" : "obj-105",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 394.25, 161.0, 29.5, 22.0 ],
													"text" : "1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-91",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "bang", "bang", "" ],
													"patching_rect" : [ 504.7166722416878, 401.2333435911179, 46.0, 22.0 ],
													"text" : "sel 0 1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-95",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 465.7166722416878, 364.33331859111786, 85.0, 22.0 ],
													"text" : "mira.mt.rotate"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-63",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "bang", "bang", "" ],
													"patching_rect" : [ 330.9999763766924, 132.0, 46.0, 22.0 ],
													"text" : "sel 0 1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-71",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 223.26489300000003, 100.0, 83.0, 22.0 ],
													"text" : "mira.mt.pinch"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-150",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 338.490784, 40.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"comment" : "X axis",
													"id" : "obj-163",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 78.85867300000001, 514.6150210000001, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"comment" : "Y axis",
													"id" : "obj-167",
													"index" : 2,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 461.716675, 514.6150210000001, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-138", 0 ],
													"order" : 1,
													"source" : [ "obj-105", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-139", 0 ],
													"order" : 0,
													"source" : [ "obj-105", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-138", 0 ],
													"order" : 1,
													"source" : [ "obj-107", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-139", 0 ],
													"order" : 0,
													"source" : [ "obj-107", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-112", 0 ],
													"order" : 0,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-113", 0 ],
													"order" : 3,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-117", 1 ],
													"order" : 2,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-119", 1 ],
													"order" : 1,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-119", 0 ],
													"source" : [ "obj-112", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-117", 0 ],
													"source" : [ "obj-113", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-134", 1 ],
													"source" : [ "obj-117", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-133", 1 ],
													"source" : [ "obj-119", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-131", 0 ],
													"order" : 0,
													"source" : [ "obj-123", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-136", 0 ],
													"order" : 1,
													"source" : [ "obj-123", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 1 ],
													"source" : [ "obj-125", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 0 ],
													"source" : [ "obj-127", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-108", 0 ],
													"source" : [ "obj-129", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-127", 0 ],
													"source" : [ "obj-132", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-125", 0 ],
													"source" : [ "obj-133", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-125", 0 ],
													"source" : [ "obj-134", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-134", 0 ],
													"source" : [ "obj-136", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 0 ],
													"source" : [ "obj-138", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 1 ],
													"order" : 0,
													"source" : [ "obj-139", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-143", 0 ],
													"order" : 1,
													"source" : [ "obj-139", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-149", 0 ],
													"source" : [ "obj-140", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 0 ],
													"source" : [ "obj-143", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-71", 0 ],
													"order" : 1,
													"source" : [ "obj-150", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-95", 0 ],
													"order" : 0,
													"source" : [ "obj-150", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 1 ],
													"source" : [ "obj-159", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 0 ],
													"source" : [ "obj-159", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-219", 0 ],
													"source" : [ "obj-161", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-194", 0 ],
													"source" : [ "obj-174", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-174", 0 ],
													"order" : 0,
													"source" : [ "obj-179", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-190", 0 ],
													"order" : 1,
													"source" : [ "obj-179", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-159", 0 ],
													"source" : [ "obj-189", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-224", 0 ],
													"source" : [ "obj-190", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 2 ],
													"source" : [ "obj-194", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 0 ],
													"source" : [ "obj-194", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-163", 0 ],
													"order" : 0,
													"source" : [ "obj-219", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-221", 0 ],
													"order" : 1,
													"source" : [ "obj-219", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-224", 1 ],
													"source" : [ "obj-221", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-189", 0 ],
													"source" : [ "obj-224", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-232", 0 ],
													"source" : [ "obj-227", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 1 ],
													"source" : [ "obj-229", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 0 ],
													"source" : [ "obj-229", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 0 ],
													"source" : [ "obj-231", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-167", 0 ],
													"source" : [ "obj-232", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-105", 0 ],
													"order" : 0,
													"source" : [ "obj-63", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-107", 0 ],
													"source" : [ "obj-63", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 0 ],
													"order" : 1,
													"source" : [ "obj-63", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-129", 0 ],
													"source" : [ "obj-71", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-174", 1 ],
													"order" : 0,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-179", 0 ],
													"order" : 1,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-189", 1 ],
													"order" : 2,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-63", 0 ],
													"source" : [ "obj-71", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-229", 0 ],
													"source" : [ "obj-95", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-91", 0 ],
													"source" : [ "obj-95", 2 ]
												}
											}
										]
									},
									"patching_rect" : [ 72.0, 173.0, 59.0, 22.0 ],
									"text" : "p xypinch"
								}
							},
							{
								"box" : {
									"id" : "obj-220",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 302.0, 374.0, 41.0, 22.0 ],
									"text" : "abs 0."
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-192",
									"maxclass" : "flonum",
									"minimum" : 1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 419.0, 374.0, 54.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[114]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[114]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[3]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-195",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 418.0, 352.0, 72.0, 21.0 ],
									"text" : "slide down",
									"textcolor" : [ 0.501961, 0.501961, 0.501961, 1.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-196",
									"maxclass" : "flonum",
									"minimum" : 1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 352.0, 374.0, 54.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[115]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[115]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[4]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-197",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 352.0, 352.0, 55.0, 21.0 ],
									"text" : "slide up",
									"textcolor" : [ 0.501961, 0.501961, 0.501961, 1.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-191",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 299.0, 412.0, 70.0, 22.0 ],
									"text" : "slide 22. 14"
								}
							},
							{
								"box" : {
									"id" : "obj-169",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 302.0, 326.0, 99.0, 22.0 ],
									"text" : "r kittybumpsignal"
								}
							},
							{
								"box" : {
									"id" : "obj-171",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 577.0, 598.0, 69.0, 22.0 ],
									"text" : "s kittybump"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-164",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 575.0, 551.25, 79.0, 17.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 569.7509961724281, 739.0, 78.0, 17.0 ],
									"text" : " kittieBump™"
								}
							},
							{
								"box" : {
									"id" : "obj-162",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 562.25, 550.25, 18.0, 18.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 652.7333354949953, 737.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[37]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[37]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[5]"
								}
							},
							{
								"box" : {
									"id" : "obj-147",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "float" ],
									"patching_rect" : [ 238.0, 412.0, 29.5, 22.0 ],
									"text" : "t b f"
								}
							},
							{
								"box" : {
									"id" : "obj-145",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 208.0, 451.0, 29.5, 22.0 ],
									"text" : "+ 0."
								}
							},
							{
								"box" : {
									"id" : "obj-233",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 299.0, 459.0, 118.0, 22.0 ],
									"text" : "scale -1. 1. 210 -210"
								}
							},
							{
								"box" : {
									"id" : "obj-226",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 145.0, 389.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-225",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 145.0, 420.0, 29.5, 22.0 ],
									"text" : "f"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-137",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1512.0, 846.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number",
											"parameter_type" : 3
										}
									},
									"varname" : "number"
								}
							},
							{
								"box" : {
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "float" ],
									"patching_rect" : [ 1368.0, 1028.0, 74.0, 22.0 ],
									"text" : "unpack 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-96",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1440.0, 912.0, 94.0, 22.0 ],
									"text" : "scale 0. 1. 1. -1."
								}
							},
							{
								"box" : {
									"id" : "obj-99",
									"linecount" : 2,
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1363.0, 912.0, 71.5, 35.0 ],
									"text" : "scale 0. 1. -1. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-100",
									"maxclass" : "newobj",
									"numinlets" : 5,
									"numoutlets" : 5,
									"outlettype" : [ "", "", "", "", "" ],
									"patching_rect" : [ 1368.0, 998.0, 76.0, 22.0 ],
									"text" : "route 1 2 3 4"
								}
							},
							{
								"box" : {
									"id" : "obj-101",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1368.0, 965.0, 71.0, 22.0 ],
									"text" : "pack 1 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-102",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 6,
									"outlettype" : [ "float", "float", "int", "int", "int", "" ],
									"patching_rect" : [ 1374.0, 880.0, 212.0, 22.0 ],
									"text" : "unpack 0. 0. 0 0 0 stuff"
								}
							},
							{
								"box" : {
									"id" : "obj-124",
									"linecount" : 2,
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 1378.0, 827.0, 68.0, 35.0 ],
									"text" : "route touch"
								}
							},
							{
								"box" : {
									"id" : "obj-98",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 1031.0, 639.0, 31.0, 22.0 ],
									"text" : "* -1."
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-97",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 724.712409004569, 529.5, 57.0, 17.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 730.8140693902969, 731.4594224095345, 57.0, 17.0 ],
									"text" : "Fill/Line"
								}
							},
							{
								"box" : {
									"id" : "obj-93",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 698.0, 526.0, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 704.8140693902969, 731.4594224095345, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[28]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[28]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[4]"
								}
							},
							{
								"box" : {
									"id" : "obj-4",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 766.0, 672.0, 87.0, 22.0 ],
									"text" : "s waveLineFilll"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-218",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 514.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[68]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[6]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[2]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-217",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 451.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[113]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[6]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[1]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-199",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 411.0, 680.0, 44.0, 20.0 ],
									"text" : "theta",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-200",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 348.0, 680.0, 43.0, 20.0 ],
									"text" : "scale",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-201",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 282.0, 680.0, 45.0, 20.0 ],
									"text" : "yshift",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-202",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 221.0, 680.0, 41.0, 20.0 ],
									"text" : "xshift",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-203",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 111.0, 680.0, 85.0, 20.0 ],
									"text" : "scalebright",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-204",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 53.0, 680.0, 38.0, 20.0 ],
									"text" : "bias",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-205",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ -2.0, 680.0, 35.0, 20.0 ],
									"text" : "hue",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-206",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 475.0, 680.0, 33.0, 20.0 ],
									"text" : "NC",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-207",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 528.0, 680.0, 36.0, 20.0 ],
									"text" : "sat",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-208",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 13.0, 775.0, 65.0, 22.0 ],
									"text" : "s shadeCtl"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-209",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 388.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[93]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[6]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[10]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-210",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 325.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[98]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[5]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[11]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-211",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 261.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[110]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[4]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[12]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-212",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 198.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[66]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[3]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[13]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-213",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 135.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[94]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[2]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[14]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-214",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 72.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[67]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[1]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[15]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-215",
									"maxclass" : "flonum",
									"maximum" : 1.0,
									"minimum" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 9.0, 709.0, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[84]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number",
											"parameter_type" : 0
										}
									},
									"varname" : "number[16]"
								}
							},
							{
								"box" : {
									"id" : "obj-216",
									"maxclass" : "newobj",
									"numinlets" : 9,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 13.0, 744.0, 512.0, 22.0 ],
									"text" : "pack 0. 0. 0. 0. 0. 0. 0. 0. 0."
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-180",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1131.0, 963.0, 44.0, 20.0 ],
									"text" : "theta",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-181",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1072.0, 963.0, 43.0, 20.0 ],
									"text" : "scale",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-182",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1011.0, 963.0, 45.0, 20.0 ],
									"text" : "yshift",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-183",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 954.0, 963.0, 41.0, 20.0 ],
									"text" : "xshift",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-184",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 851.0, 963.0, 85.0, 20.0 ],
									"text" : "scalebright",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-185",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 797.0, 963.0, 38.0, 20.0 ],
									"text" : "bias",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-186",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 746.0, 963.0, 35.0, 20.0 ],
									"text" : "hue",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-187",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1192.0, 963.0, 33.0, 20.0 ],
									"text" : "NC",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-188",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1240.0, 963.0, 36.0, 20.0 ],
									"text" : "sat",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-160",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 773.0, 13.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-158",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 773.0, 47.0, 159.0, 22.0 ],
									"text" : "0.910104 0.85734 0. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-144",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 457.0, 474.0, 70.0, 22.0 ],
									"text" : "loadmess 0"
								}
							},
							{
								"box" : {
									"id" : "obj-92",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 461.0, 435.0, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-122",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 712.0, 861.0, 59.0, 22.0 ],
									"text" : "r ctrlbang"
								}
							},
							{
								"box" : {
									"id" : "obj-121",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 204.0, 542.0, 63.0, 22.0 ],
									"text" : "r shadeCtl"
								}
							},
							{
								"box" : {
									"id" : "obj-114",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 23.0, 966.0, 65.0, 22.0 ],
									"text" : "s shadeCtl"
								}
							},
							{
								"box" : {
									"attr" : "tap_enabled",
									"id" : "obj-109",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 592.0, 99.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "pinch_enabled",
									"id" : "obj-58",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 833.0, 124.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "rotate_enabled",
									"id" : "obj-73",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 833.0, 148.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-178",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1000.0, 563.0, 12.291664689779282, 12.291664689779282 ],
									"presentation" : 1,
									"presentation_rect" : [ 928.24085521698, 742.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[5]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[2]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[5]"
								}
							},
							{
								"box" : {
									"id" : "obj-177",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 971.0, 562.0, 12.583329021930695, 12.583329021930695 ],
									"presentation" : 1,
									"presentation_rect" : [ 899.24085521698, 742.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[4]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[2]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[4]"
								}
							},
							{
								"box" : {
									"id" : "obj-176",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1522.0, 557.0, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 870.24085521698, 742.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[3]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[2]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[3]"
								}
							},
							{
								"box" : {
									"id" : "obj-175",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 944.0, 562.0, 12.583329021930695, 12.583329021930695 ],
									"presentation" : 1,
									"presentation_rect" : [ 838.5843371748924, 742.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[2]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[2]",
											"parameter_type" : 2
										}
									},
									"varname" : "button[2]"
								}
							},
							{
								"box" : {
									"id" : "obj-173",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 968.0, 596.0, 29.5, 22.0 ],
									"text" : "1.1"
								}
							},
							{
								"box" : {
									"id" : "obj-172",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1457.0, 490.0, 29.5, 22.0 ],
									"text" : "1."
								}
							},
							{
								"box" : {
									"id" : "obj-170",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 935.0, 596.0, 29.5, 22.0 ],
									"text" : "1."
								}
							},
							{
								"box" : {
									"id" : "obj-168",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1000.0, 596.0, 29.5, 22.0 ],
									"text" : "0.5"
								}
							},
							{
								"box" : {
									"id" : "obj-166",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 912.0, 708.0, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 990.8916737437248, 741.8000099658966, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[26]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[14]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[9]"
								}
							},
							{
								"box" : {
									"id" : "obj-165",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 915.0, 744.0, 95.0, 22.0 ],
									"text" : "s scaleInvtoggle"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-157",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 720.0000214576721, 553.3333498239517, 102.0, 17.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 1020.2250064015388, 695.4166669100523, 57.0, 27.0 ],
									"text" : " Motion control"
								}
							},
							{
								"box" : {
									"id" : "obj-148",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1099.0, 387.0, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-146",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 700.6666875481606, 552.6666831374168, 20.233330935239792, 20.233330935239792 ],
									"presentation" : 1,
									"presentation_rect" : [ 1024.9170283675194, 657.4666675329208, 33.80797904729843, 33.80797904729843 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[25]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[25]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[8]"
								}
							},
							{
								"box" : {
									"id" : "obj-141",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1176.0, 650.0, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 12.0,
									"id" : "obj-135",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 661.5, 480.39583829045296, 37.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 659.5636110305788, 684.9594224095345, 37.0, 20.0 ],
									"text" : "of",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 18.0,
									"id" : "obj-130",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 612.520828038454, 477.0, 28.999999582767487, 27.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 630.5, 696.4587197303772, 33.0, 27.0 ],
									"text" : "-",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 18.0,
									"id" : "obj-126",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 613.770828038454, 425.0, 27.000019073486328, 27.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 628.5, 660.9594224095345, 33.0, 27.0 ],
									"text" : "+",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-111",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 610.020828038454, 474.5, 31.791676580905914, 31.791676580905914 ],
									"presentation" : 1,
									"presentation_rect" : [ 619.4999995827675, 694.6181422472, 32.00000041723251, 32.00000041723251 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[1]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button",
											"parameter_type" : 2
										}
									},
									"varname" : "button[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-110",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 610.520828038454, 421.75, 31.33333432674408, 31.33333432674408 ],
									"presentation" : 1,
									"presentation_rect" : [ 618.7333350777628, 656.4594222009182, 32.00000041723251, 32.00000041723251 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button",
											"parameter_type" : 2
										}
									},
									"varname" : "button"
								}
							},
							{
								"box" : {
									"id" : "obj-106",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 444.0, 557.0, 29.5, 22.0 ],
									"text" : "dec"
								}
							},
							{
								"box" : {
									"id" : "obj-103",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 444.0, 530.0, 29.5, 22.0 ],
									"text" : "inc"
								}
							},
							{
								"box" : {
									"id" : "obj-70",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 363.0, 512.0, 79.0, 22.0 ],
									"text" : "r movsFound"
								}
							},
							{
								"box" : {
									"id" : "obj-69",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 363.0, 538.0, 58.0, 22.0 ],
									"text" : "s movSel"
								}
							},
							{
								"box" : {
									"id" : "obj-12",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 358.0, 570.0, 79.0, 22.0 ],
									"text" : "prepend max"
								}
							},
							{
								"box" : {
									"id" : "obj-22",
									"maxclass" : "incdec",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 474.0, 526.0, 55.0, 53.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-25",
									"maxclass" : "number",
									"maximum" : 53,
									"minimum" : 0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 610.270828038454, 454.25, 31.583352744579315, 19.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 652.7333354949953, 665.9594224095345, 41.0, 19.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[65]",
											"parameter_mmax" : 53.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[65]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[7]"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-57",
									"maxclass" : "number",
									"minimum" : 0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 651.0, 500.0, 38.0, 19.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 652.7333354949953, 703.9594224095345, 42.0, 19.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[9]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[9]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[9]"
								}
							},
							{
								"box" : {
									"id" : "obj-156",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 565.0, 629.0, 121.0, 22.0 ],
									"text" : "s soundwave_enable"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"id" : "obj-155",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 920.0, 385.0, 63.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 904.24085521698, 600.4666675329208, 63.0, 20.0 ],
									"text" : "rotate",
									"textcolor" : [ 0.517647058823529, 0.517647058823529, 0.517647058823529, 1.0 ],
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 10.0,
									"id" : "obj-154",
									"linecount" : 4,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1063.0, 457.0, 15.0, 53.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 990.8916737437248, 624.8333345353603, 38.0, 18.0 ],
									"text" : "ZOOM",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-152",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 750.0000223517418, 471.3333473801613, 70.0, 17.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 730.8140693902969, 667.9594224095345, 76.0, 17.0 ],
									"text" : "Wave Enable"
								}
							},
							{
								"box" : {
									"id" : "obj-153",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 698.000020802021, 468.0000139474869, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 704.8140693902969, 665.9594224095345, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[13]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[21]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[6]"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-151",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 577.0, 517.0, 67.0, 17.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 612.0843288302422, 632.6516514122486, 95.0, 17.0 ],
									"text" : "pic enable",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-128",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 7,
									"outlettype" : [ "", "", "", "", "", "", "" ],
									"patching_rect" : [ 202.0, 173.0, 211.0, 22.0 ],
									"text" : "mira.mt.centroid"
								}
							},
							{
								"box" : {
									"id" : "obj-89",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 23.0, 928.0, 660.0, 22.0 ],
									"text" : "0.011905 0.392857 0.755952 -0.354023 -0.5 -0.634044 0.281234 0. 0.71131"
								}
							},
							{
								"box" : {
									"id" : "obj-88",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 12.0, 882.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 10.0,
									"id" : "obj-19",
									"linecount" : 10,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 999.3333631157875, 422.00001257658005, 15.0, 123.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 924.24085521698, 618.5333420038223, 33.0, 41.0 ],
									"text" : "SATURATION",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-50",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 992.0, 408.0, 27.875, 151.876089528203 ],
									"presentation" : 1,
									"presentation_rect" : [ 928.24085521698, 633.0333379805088, 21.0, 102.16666576266289 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "fbhue[1]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "fbhue",
											"parameter_type" : 3
										}
									},
									"size" : 1.0,
									"varname" : "slider[9]"
								}
							},
							{
								"box" : {
									"id" : "obj-47",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 46.0, 451.0, 150.0, 20.0 ],
									"text" : "enable x y 0 zx zy 0 0 0 r"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 9.0,
									"id" : "obj-65",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 724.0, 501.0, 87.0, 17.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 730.8140693902969, 706.3968514204025, 86.0, 17.0 ],
									"text" : "Wave Lighting"
								}
							},
							{
								"box" : {
									"id" : "obj-54",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 565.0, 658.0, 166.0, 22.0 ],
									"text" : "s soundwave_lighting_enable"
								}
							},
							{
								"box" : {
									"id" : "obj-55",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 698.0, 499.0, 24.0, 24.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 704.8140693902969, 704.3968514204025, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[22]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[21]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[10]"
								}
							},
							{
								"box" : {
									"id" : "obj-53",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 141.0, 346.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-87",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 32.0, 389.0, 59.0, 22.0 ],
									"text" : "r ctrlbang"
								}
							},
							{
								"box" : {
									"id" : "obj-84",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 285.0, 290.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-82",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 461.0, 234.66667366027832, 70.0, 22.0 ],
									"text" : "loadmess 0"
								}
							},
							{
								"box" : {
									"id" : "obj-80",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 188.0, 256.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-79",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 297.0, 253.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-76",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 282.0, 486.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-75",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 563.0, 421.75, 34.25, 84.54167658090591 ],
									"presentation" : 1,
									"presentation_rect" : [ 569.7509961724281, 624.8333345353603, 40.333332657814026, 84.99999898672104 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_initial" : [ 0.746666663244036 ],
											"parameter_initial_enable" : 1,
											"parameter_invisible" : 1,
											"parameter_longname" : "slider[15]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 3
										}
									},
									"size" : 2.0,
									"varname" : "slider[12]"
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-74",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 562.833332657814, 391.50000989437103, 126.16666734218597, 24.50000250339508 ],
									"presentation" : 1,
									"presentation_rect" : [ 573.028773691919, 595.8529032915831, 108.33333468437195, 24.333330512046814 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_initial" : [ -360 ],
											"parameter_initial_enable" : 1,
											"parameter_invisible" : 1,
											"parameter_longname" : "slider[14]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 3
										}
									},
									"size" : 2.0,
									"varname" : "slider[11]"
								}
							},
							{
								"box" : {
									"id" : "obj-64",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 309.0, 214.0, 91.0, 22.0 ],
									"text" : "scale 0. 1. 1 -1."
								}
							},
							{
								"box" : {
									"id" : "obj-67",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 180.0, 214.0, 121.0, 22.0 ],
									"text" : "scale 0.1 0.9 -1.7 1.7"
								}
							},
							{
								"box" : {
									"color" : [ 0.75, 0.75, 0.75, 0.2 ],
									"id" : "obj-62",
									"maxclass" : "mira.multitouch",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 563.0, 203.0, 252.0, 176.5 ],
									"pinch_enabled" : 0,
									"presentation" : 1,
									"presentation_rect" : [ 577.7509961724281, 420.7633735537529, 231.34066772460938, 168.03662449121475 ],
									"rotate_enabled" : 0,
									"swipe_enabled" : 0,
									"swipe_touch_count" : 0,
									"tap_enabled" : 0,
									"tap_tap_count" : 0,
									"tap_touch_count" : 0
								}
							},
							{
								"box" : {
									"id" : "obj-1",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 562.5, 514.75, 18.0, 18.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 675.084328830242, 632.6516514122486, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[20]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[20]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[2]"
								}
							},
							{
								"box" : {
									"id" : "obj-8",
									"maxclass" : "newobj",
									"numinlets" : 10,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 46.0, 486.0, 167.0, 22.0 ],
									"text" : "pack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-44",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 46.0, 521.0, 80.0, 22.0 ],
									"text" : "s imageMove"
								}
							},
							{
								"box" : {
									"id" : "obj-59",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 141.0, 313.0, 111.0, 22.0 ],
									"text" : "scale 0. 1024 -1. 1."
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-27",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1054.0, 408.0, 30.375, 152.376089528203 ],
									"presentation" : 1,
									"presentation_rect" : [ 995.5836957097054, 642.6999984681606, 27.333332657814026, 89.74058082699776 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_initial" : [ 0.75 ],
											"parameter_initial_enable" : 1,
											"parameter_invisible" : 1,
											"parameter_longname" : "slider[11]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 3
										}
									},
									"size" : 2.0,
									"varname" : "slider[8]"
								}
							},
							{
								"box" : {
									"id" : "obj-23",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 171.0, 542.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[19]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[19]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-7",
									"maxclass" : "gswitch2",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 184.0, 586.0, 39.0, 32.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-6",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ -2.0, 639.0, 543.8329677728366, 22.0 ],
									"text" : "-0.489224 0.483331 0.393104 -0.249777 -0.865481 0.047872 0.510855 0. 0.67"
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-56",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 818.0, 383.0, 266.4978713095188, 22.5 ],
									"presentation" : 1,
									"presentation_rect" : [ 950.3916727304459, 600.4666675329208, 108.33333468437195, 24.333330512046814 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_initial" : [ 0.739079350328317 ],
											"parameter_initial_enable" : 1,
											"parameter_invisible" : 1,
											"parameter_longname" : "slider[10]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 3
										}
									},
									"size" : 2.0,
									"varname" : "slider[7]"
								}
							},
							{
								"box" : {
									"id" : "obj-52",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1127.0, 840.0, 98.0, 22.0 ],
									"text" : "scale -1. 1. 1. -1."
								}
							},
							{
								"box" : {
									"id" : "obj-49",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 5,
									"outlettype" : [ "float", "float", "float", "float", "" ],
									"patching_rect" : [ 1189.0, 783.0, 126.0, 22.0 ],
									"text" : "unpack 0. 0. 0. 0. stuff"
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 10.0,
									"id" : "obj-41",
									"linecount" : 12,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1031.0, 411.0, 15.0, 146.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 956.8408552408218, 615.7333419322968, 33.0, 41.0 ],
									"text" : "TRANSPARANCY",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-120",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 912.0, 663.0, 117.0, 22.0 ],
									"text" : "s erasetransparency"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-83",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1023.0, 409.0, 28.875, 151.376089528203 ],
									"presentation" : 1,
									"presentation_rect" : [ 963.24085521698, 633.0333379805088, 24.200000047683716, 102.16666576266289 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_initial" : [ 1.0 ],
											"parameter_initial_enable" : 1,
											"parameter_longname" : "slider",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 0
										}
									},
									"size" : 1.0,
									"varname" : "slider"
								}
							},
							{
								"box" : {
									"id" : "obj-118",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 716.0, 629.0, 45.0, 22.0 ],
									"text" : "s hue1"
								}
							},
							{
								"box" : {
									"id" : "obj-198",
									"maxclass" : "swatch",
									"numinlets" : 3,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 691.0, 383.0, 124.42481800913811, 78.60362235456705 ],
									"presentation" : 1,
									"presentation_rect" : [ 702.1333429217339, 596.4666675329208, 120.16666972637177, 63.36995458602905 ],
									"saturation" : 1.0,
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "swatch[3]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "swatch",
											"parameter_type" : 3
										}
									},
									"varname" : "swatch"
								}
							},
							{
								"box" : {
									"id" : "obj-40",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1514.0, 434.0, 37.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 862.24085521698, 618.5333420038223, 37.0, 20.0 ],
									"text" : "cont"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Menlo Bold",
									"fontsize" : 10.0,
									"id" : "obj-39",
									"linecount" : 10,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 941.3333613872528, 421.33334589004517, 15.0, 123.0 ],
									"presentation" : 1,
									"presentation_linecount" : 3,
									"presentation_rect" : [ 840.0843371748924, 618.5333420038223, 33.0, 41.0 ],
									"text" : "BRIGNTNESS",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Menlo Bold",
									"fontsize" : 10.0,
									"id" : "obj-38",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 970.1875, 421.33334589004517, 75.0, 30.0 ],
									"presentation" : 1,
									"presentation_linecount" : 2,
									"presentation_rect" : [ 895.24085521698, 618.5333420038223, 87.0, 30.0 ],
									"text" : "HUE          -S H I FT",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-18",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1522.0, 448.0, 21.0, 102.16666576266289 ],
									"presentation" : 1,
									"presentation_rect" : [ 870.24085521698, 633.0333379805088, 21.0, 102.16666576266289 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "slider[7]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 3
										}
									},
									"size" : 2.0,
									"varname" : "slider[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-16",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 848.0, 857.0, 91.0, 22.0 ],
									"text" : "scale 0 -2. -1. 0"
								}
							},
							{
								"box" : {
									"id" : "obj-35",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 5,
									"outlettype" : [ "float", "float", "float", "float", "" ],
									"patching_rect" : [ 982.0, 790.0, 126.0, 22.0 ],
									"text" : "unpack 0. 0. 0. 0. stuff"
								}
							},
							{
								"box" : {
									"id" : "obj-34",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "float", "float" ],
									"patching_rect" : [ 1093.0, 640.0, 74.0, 22.0 ],
									"text" : "unpack 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 742.0, 1028.0, 65.0, 22.0 ],
									"text" : "s shadeCtl"
								}
							},
							{
								"box" : {
									"id" : "obj-94",
									"maxclass" : "newobj",
									"numinlets" : 9,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 757.0, 936.0, 512.0, 22.0 ],
									"text" : "pack 0. 0. 0. 0. 0. 0. 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-33",
									"linecount" : 2,
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1197.5, 544.3333498239517, 71.5, 35.0 ],
									"text" : "scale 0. 1. -1. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-32",
									"linecount" : 2,
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1120.0, 541.0, 71.5, 35.0 ],
									"text" : "scale 0. 1. -1. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-31",
									"maxclass" : "newobj",
									"numinlets" : 5,
									"numoutlets" : 5,
									"outlettype" : [ "", "", "", "", "" ],
									"patching_rect" : [ 1093.0, 610.0, 76.0, 22.0 ],
									"text" : "route 1 2 3 4"
								}
							},
							{
								"box" : {
									"id" : "obj-29",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1093.0, 584.0, 71.0, 22.0 ],
									"text" : "pack 1 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-28",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 6,
									"outlettype" : [ "float", "float", "int", "int", "int", "" ],
									"patching_rect" : [ 1104.0, 488.0, 165.0, 22.0 ],
									"text" : "unpack 0. 0. 0 0 0 clientname"
								}
							},
							{
								"box" : {
									"id" : "obj-24",
									"linecount" : 2,
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patching_rect" : [ 1104.0, 445.0, 68.0, 35.0 ],
									"text" : "route touch"
								}
							},
							{
								"box" : {
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 6,
									"outlettype" : [ "", "", "", "", "", "" ],
									"patching_rect" : [ 1146.0, 692.0, 314.0349667072296, 22.0 ],
									"text" : "route rawaccel orientation accel gravity rotationrate"
								}
							},
							{
								"box" : {
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 447.0, 193.0, 67.0, 22.0 ],
									"text" : "s gainmain"
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-30",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 934.5833290219307, 408.4380447641015, 25.875, 151.876089528203 ],
									"presentation" : 1,
									"presentation_rect" : [ 840.0843371748924, 633.0333379805088, 21.0, 102.16666576266289 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "slider[6]",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 3
										}
									},
									"size" : 2.0,
									"varname" : "slider[2]"
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-17",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 965.0, 408.0, 25.375, 151.876089528203 ],
									"presentation" : 1,
									"presentation_rect" : [ 899.24085521698, 633.0333379805088, 21.0, 102.16666576266289 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "fbhue",
											"parameter_mmax" : 1.0,
											"parameter_mmin" : -1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "fbhue",
											"parameter_type" : 3
										}
									},
									"size" : 2.0,
									"varname" : "slider[5]"
								}
							},
							{
								"box" : {
									"drawoffcolor" : 1,
									"elementcolor" : [ 0.164706, 0.776471, 0.878431, 1.0 ],
									"floatoutput" : 1,
									"id" : "obj-26",
									"knobcolor" : [ 0.898039, 0.780392, 0.368627, 1.0 ],
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 447.0, 63.0, 20.0, 119.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "slider[4]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider",
											"parameter_type" : 3
										}
									},
									"size" : 1.0,
									"varname" : "slider[4]"
								}
							},
							{
								"box" : {
									"color" : [ 0.75, 0.75, 0.75, 0.2 ],
									"id" : "obj-11",
									"maxclass" : "mira.multitouch",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 819.0, 203.0, 265.65507489442825, 176.0091561228037 ],
									"pinch_enabled" : 0,
									"presentation" : 1,
									"presentation_rect" : [ 818.25, 420.7633735537529, 231.34066772460938, 168.03662449121475 ],
									"rotate_enabled" : 0,
									"swipe_enabled" : 0,
									"swipe_touch_count" : 0,
									"tap_enabled" : 0,
									"tap_tap_count" : 0,
									"tap_touch_count" : 0
								}
							},
							{
								"box" : {
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1218.0, 586.0, 71.0, 22.0 ],
									"text" : "mira.motion"
								}
							},
							{
								"box" : {
									"attr" : "pinch_enabled",
									"id" : "obj-20",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 592.0, 123.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "rotate_enabled",
									"id" : "obj-21",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 592.0, 147.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "swipe_enabled",
									"id" : "obj-86",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 833.0, 172.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "swipe_enabled",
									"id" : "obj-90",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 592.0, 171.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "tap_enabled",
									"id" : "obj-104",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 833.0, 100.0, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"background" : 1,
									"color" : [ 0.0, 0.0, 0.0, 0.301960784313725 ],
									"id" : "obj-9",
									"ignoreclick" : 1,
									"maxclass" : "mira.frame",
									"numinlets" : 0,
									"numoutlets" : 0,
									"patching_rect" : [ 560.0, 178.0, 562.6373767852783, 400.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 212.5, 24.0, 371.340675333044, 264.0000047311185 ],
									"tabname" : "feedbax-by-i@seanstevens.com",
									"taborder" : 1
								}
							}
						],
						"lines" : [
							{
								"patchline" : {
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-1", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-141", 1 ],
									"source" : [ "obj-10", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-5", 0 ],
									"source" : [ "obj-100", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-100", 0 ],
									"source" : [ "obj-101", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-101", 0 ],
									"source" : [ "obj-102", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-96", 0 ],
									"source" : [ "obj-102", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-99", 0 ],
									"source" : [ "obj-102", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-22", 0 ],
									"source" : [ "obj-103", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-104", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-16", 4 ],
									"source" : [ "obj-105", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-22", 0 ],
									"source" : [ "obj-106", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-129", 0 ],
									"source" : [ "obj-107", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-16", 3 ],
									"source" : [ "obj-108", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-62", 0 ],
									"source" : [ "obj-109", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-11", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-103", 0 ],
									"source" : [ "obj-110", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-106", 0 ],
									"source" : [ "obj-111", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-123", 0 ],
									"source" : [ "obj-112", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-119", 0 ],
									"source" : [ "obj-117", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-27", 0 ],
									"source" : [ "obj-119", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-12", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-7", 1 ],
									"source" : [ "obj-121", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-122", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-175", 0 ],
									"order" : 2,
									"source" : [ "obj-123", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-177", 0 ],
									"order" : 1,
									"source" : [ "obj-123", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-178", 0 ],
									"order" : 0,
									"source" : [ "obj-123", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-102", 0 ],
									"source" : [ "obj-124", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-64", 0 ],
									"source" : [ "obj-128", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-67", 0 ],
									"source" : [ "obj-128", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 0 ],
									"source" : [ "obj-13", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-71", 0 ],
									"source" : [ "obj-133", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 7 ],
									"source" : [ "obj-140", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-141", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-55", 0 ],
									"source" : [ "obj-144", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 5 ],
									"order" : 0,
									"source" : [ "obj-145", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 4 ],
									"order" : 1,
									"source" : [ "obj-145", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-141", 0 ],
									"source" : [ "obj-146", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-145", 1 ],
									"source" : [ "obj-147", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-145", 0 ],
									"source" : [ "obj-147", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-146", 0 ],
									"source" : [ "obj-148", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-15", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-156", 0 ],
									"source" : [ "obj-153", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-198", 0 ],
									"source" : [ "obj-158", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 5 ],
									"source" : [ "obj-16", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-158", 0 ],
									"source" : [ "obj-160", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-171", 0 ],
									"source" : [ "obj-162", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-235", 0 ],
									"source" : [ "obj-163", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-165", 0 ],
									"source" : [ "obj-166", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-50", 0 ],
									"source" : [ "obj-168", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-220", 0 ],
									"source" : [ "obj-169", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 1 ],
									"source" : [ "obj-17", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-170", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-172", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-17", 0 ],
									"source" : [ "obj-173", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-226", 0 ],
									"source" : [ "obj-174", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-76", 0 ],
									"source" : [ "obj-174", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-170", 0 ],
									"source" : [ "obj-175", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-172", 0 ],
									"source" : [ "obj-176", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-173", 0 ],
									"source" : [ "obj-177", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-168", 0 ],
									"source" : [ "obj-178", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 2 ],
									"source" : [ "obj-18", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-147", 0 ],
									"source" : [ "obj-191", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-191", 2 ],
									"source" : [ "obj-192", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-191", 1 ],
									"source" : [ "obj-196", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-118", 0 ],
									"source" : [ "obj-198", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-62", 0 ],
									"source" : [ "obj-20", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 6 ],
									"source" : [ "obj-209", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-62", 0 ],
									"source" : [ "obj-21", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 5 ],
									"source" : [ "obj-210", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 4 ],
									"source" : [ "obj-211", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 3 ],
									"source" : [ "obj-212", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 2 ],
									"source" : [ "obj-213", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 1 ],
									"source" : [ "obj-214", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 0 ],
									"source" : [ "obj-215", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-208", 0 ],
									"source" : [ "obj-216", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 7 ],
									"source" : [ "obj-217", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 8 ],
									"source" : [ "obj-218", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-22", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-191", 0 ],
									"source" : [ "obj-220", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 5 ],
									"order" : 0,
									"source" : [ "obj-225", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 4 ],
									"order" : 1,
									"source" : [ "obj-225", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-225", 0 ],
									"source" : [ "obj-226", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-23", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-76", 0 ],
									"source" : [ "obj-233", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-28", 0 ],
									"source" : [ "obj-24", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-22", 0 ],
									"order" : 0,
									"source" : [ "obj-25", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-69", 0 ],
									"order" : 1,
									"source" : [ "obj-25", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-26", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 5 ],
									"source" : [ "obj-27", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-29", 0 ],
									"source" : [ "obj-28", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-32", 0 ],
									"source" : [ "obj-28", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-33", 0 ],
									"source" : [ "obj-28", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-31", 0 ],
									"source" : [ "obj-29", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-35", 0 ],
									"source" : [ "obj-3", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-49", 0 ],
									"source" : [ "obj-3", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 1 ],
									"source" : [ "obj-30", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-34", 0 ],
									"source" : [ "obj-31", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-29", 1 ],
									"source" : [ "obj-32", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-29", 2 ],
									"source" : [ "obj-33", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 4 ],
									"source" : [ "obj-34", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 3 ],
									"source" : [ "obj-34", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-16", 0 ],
									"source" : [ "obj-35", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-83", 0 ],
									"source" : [ "obj-36", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-74", 0 ],
									"source" : [ "obj-42", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-75", 0 ],
									"source" : [ "obj-43", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-52", 0 ],
									"source" : [ "obj-49", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 8 ],
									"source" : [ "obj-50", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 6 ],
									"source" : [ "obj-52", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 2 ],
									"source" : [ "obj-53", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-54", 0 ],
									"source" : [ "obj-55", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-98", 0 ],
									"source" : [ "obj-56", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-57", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-58", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-53", 0 ],
									"source" : [ "obj-59", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-128", 0 ],
									"order" : 0,
									"source" : [ "obj-62", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-174", 0 ],
									"order" : 1,
									"source" : [ "obj-62", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-36", 0 ],
									"source" : [ "obj-63", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-79", 0 ],
									"source" : [ "obj-64", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-80", 0 ],
									"source" : [ "obj-67", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 1 ],
									"source" : [ "obj-7", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-57", 0 ],
									"source" : [ "obj-70", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-73", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-233", 0 ],
									"source" : [ "obj-74", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-84", 0 ],
									"source" : [ "obj-75", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 9 ],
									"source" : [ "obj-76", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 2 ],
									"source" : [ "obj-79", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-44", 0 ],
									"source" : [ "obj-8", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 1 ],
									"source" : [ "obj-80", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-82", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-120", 0 ],
									"source" : [ "obj-83", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-145", 0 ],
									"source" : [ "obj-84", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-86", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-87", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-89", 0 ],
									"source" : [ "obj-88", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-114", 0 ],
									"source" : [ "obj-89", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-62", 0 ],
									"source" : [ "obj-90", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-153", 0 ],
									"source" : [ "obj-92", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-93", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-15", 0 ],
									"source" : [ "obj-94", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-101", 2 ],
									"source" : [ "obj-96", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-94", 6 ],
									"source" : [ "obj-98", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-101", 1 ],
									"source" : [ "obj-99", 0 ]
								}
							}
						],
						"boxgroups" : [
							{
								"boxes" : [
									"obj-55",
									"obj-65"
								]
							},
							{
								"boxes" : [
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
								"boxes" : [
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
								"boxes" : [
									"obj-162",
									"obj-164"
								]
							},
							{
								"boxes" : [
									"obj-127",
									"obj-107"
								]
							},
							{
								"boxes" : [
									"obj-157",
									"obj-146"
								]
							},
							{
								"boxes" : [
									"obj-27",
									"obj-154"
								]
							},
							{
								"boxes" : [
									"obj-41",
									"obj-83"
								]
							},
							{
								"boxes" : [
									"obj-19",
									"obj-50"
								]
							},
							{
								"boxes" : [
									"obj-38",
									"obj-17"
								]
							},
							{
								"boxes" : [
									"obj-39",
									"obj-30"
								]
							},
							{
								"boxes" : [
									"obj-155",
									"obj-56"
								]
							},
							{
								"boxes" : [
									"obj-136",
									"obj-134",
									"obj-153",
									"obj-133",
									"obj-152"
								]
							},
							{
								"boxes" : [
									"obj-25",
									"obj-110",
									"obj-111",
									"obj-126",
									"obj-130"
								]
							},
							{
								"boxes" : [
									"obj-151",
									"obj-1"
								]
							},
							{
								"boxes" : [
									"obj-222",
									"obj-163"
								]
							},
							{
								"boxes" : [
									"obj-139",
									"obj-140"
								]
							}
						]
					},
					"patching_rect" : [ 23.5, 25.0, 110.0, 36.0 ],
					"text" : "p webUI",
					"textcolor" : [ 0.0, 1.0, 0.0, 1.0 ]
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-2",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1295.0, 287.0, 88.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1102.5, 359.5, 88.0, 22.0 ],
					"text" : "dim 3840 2160"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 11.934731,
					"id" : "obj-61",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 764.0, 46.0, 64.0, 22.0 ],
					"text" : "floating $1"
				}
			},
			{
				"box" : {
					"id" : "obj-62",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 764.0, 22.0, 20.0, 20.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_enum" : [ "off", "on" ],
							"parameter_longname" : "toggle[8]",
							"parameter_mmax" : 1,
							"parameter_modmode" : 0,
							"parameter_shortname" : "toggle[8]",
							"parameter_type" : 2
						}
					},
					"varname" : "toggle[8]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-10",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1167.0, 80.0, 83.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1099.0, 158.9000023007393, 83.0, 22.0 ],
					"text" : "dim 1024 768"
				}
			},
			{
				"box" : {
					"format" : 6,
					"id" : "obj-57",
					"maxclass" : "flonum",
					"maximum" : 1.0,
					"minimum" : 0.0,
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 133.0, 737.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_longname" : "number[15]",
							"parameter_mmax" : 1.0,
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[15]",
							"parameter_type" : 0
						}
					},
					"varname" : "number[7]"
				}
			},
			{
				"box" : {
					"id" : "obj-56",
					"maxclass" : "newobj",
					"numinlets" : 5,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 8.0, 781.0, 147.0, 22.0 ],
					"text" : "pak erase_color 0. 0. 0. 1."
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-14",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1318.0, 159.0, 90.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1102.5, 305.4000023007393, 90.0, 22.0 ],
					"text" : "dim 1920 1080"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-157",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1167.0, 128.0, 83.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1099.0, 207.26430469926072, 83.0, 22.0 ],
					"text" : "dim 1280 800"
				}
			},
			{
				"box" : {
					"fontface" : 1,
					"fontname" : "Menlo Bold",
					"fontsize" : 24.0,
					"id" : "obj-150",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "signal", "signal" ],
					"patcher" : {
						"fileversion" : 1,
						"appversion" : {
							"major" : 9,
							"minor" : 0,
							"revision" : 7,
							"architecture" : "x64",
							"modernui" : 1
						},
						"classnamespace" : "box",
						"rect" : [ 112.0, 190.0, 968.0, 797.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [
							{
								"box" : {
									"id" : "obj-94",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1032.0, 1271.0, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-345",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 198.9361687898636, 59.57446765899658, 150.0, 20.0 ],
									"text" : "Wordlbump"
								}
							},
							{
								"box" : {
									"id" : "obj-342",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1706.6711573873977, 1942.4255180358887, 72.34042608737946, 20.0 ],
									"text" : "worldbump"
								}
							},
							{
								"box" : {
									"id" : "obj-339",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1679.7820938691088, 1940.4255180358887, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[15]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[15]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[15]"
								}
							},
							{
								"box" : {
									"id" : "obj-331",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1550.0857460970701, 2100.1063680648804, 90.0, 22.0 ],
									"text" : "s wordBumpEn"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-319",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 258.6404406580391, 703.8000231385231, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[170]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[170]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[13]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-320",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 199.6404406580391, 703.8000231385231, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[21]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[21]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[21]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-321",
									"maxclass" : "flonum",
									"maximum" : 0.2,
									"minimum" : 0.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 243.8904406580391, 651.9000023007393, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "number[53]",
											"parameter_mmax" : 0.2,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[53]",
											"parameter_type" : 0
										}
									},
									"varname" : "number[23]"
								}
							},
							{
								"box" : {
									"id" : "obj-322",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 148.89044059843445, 677.6000232100487, 100.0, 22.0 ],
									"text" : "scale 0 0.3 0. 0.1"
								}
							},
							{
								"box" : {
									"id" : "obj-325",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 186.6404406580391, 735.0, 63.0, 22.0 ],
									"text" : "slide 8. 12"
								}
							},
							{
								"box" : {
									"id" : "obj-330",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 148.89044059843445, 638.0, 76.0, 22.0 ],
									"text" : "r worldBump"
								}
							},
							{
								"box" : {
									"id" : "obj-318",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 230.56170815229416, 593.759450891655, 78.0, 22.0 ],
									"text" : "s worldBump"
								}
							},
							{
								"box" : {
									"id" : "obj-287",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 138.36170184612274, 96.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[14]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[14]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[14]"
								}
							},
							{
								"box" : {
									"id" : "obj-229",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1590.0857460970701, 1854.5532014429778, 80.0, 22.0 ],
									"text" : "loadmess 0.8"
								}
							},
							{
								"box" : {
									"id" : "obj-228",
									"linecount" : 3,
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2398.3617018461227, 1748.0, 41.0, 49.0 ],
									"text" : "loadmess 0.8"
								}
							},
							{
								"box" : {
									"id" : "obj-190",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1906.8063588730104, 1865.1733979173018, 42.0, 20.0 ],
									"text" : "alpha"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-215",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1916.1791037176147, 1795.4749246348592, 23.25451031079092, 66.00000000000045 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[19]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider[17]",
											"parameter_type" : 0
										}
									},
									"size" : 1.0,
									"varname" : "slider[4]"
								}
							},
							{
								"box" : {
									"id" : "obj-64",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1524.9124486854107, 1892.5200749784708, 85.0, 22.0 ],
									"text" : "prepend alpha"
								}
							},
							{
								"box" : {
									"id" : "obj-374",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2144.703199118376, 1962.4750248607788, 150.0, 20.0 ],
									"text" : "wave ab"
								}
							},
							{
								"box" : {
									"id" : "obj-372",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2118.703199118376, 1960.4750248607788, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[56]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[56]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[13]"
								}
							},
							{
								"box" : {
									"id" : "obj-370",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2137.3617018461227, 2082.0, 76.0, 22.0 ],
									"text" : "s wavebump"
								}
							},
							{
								"box" : {
									"id" : "obj-369",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "float" ],
									"patching_rect" : [ 2297.9051259035887, 2029.1558756050263, 29.5, 22.0 ],
									"text" : "t b f"
								}
							},
							{
								"box" : {
									"id" : "obj-368",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 2297.9051259035887, 2071.7914781090412, 39.07446801662445, 22.0 ],
									"text" : "+ 0."
								}
							},
							{
								"box" : {
									"id" : "obj-367",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 358.36170184612274, 585.0, 29.5, 22.0 ],
									"text" : "+ 0."
								}
							},
							{
								"box" : {
									"id" : "obj-366",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2312.37234044075, 1992.416429929151, 89.0, 22.0 ],
									"text" : "r wavebumpsig"
								}
							},
							{
								"box" : {
									"id" : "obj-357",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 345.36170184612274, 403.1898846503432, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[55]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[50]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[12]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-359",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 458.9595729112625, 468.75944713656236, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[169]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[69]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[22]"
								}
							},
							{
								"box" : {
									"id" : "obj-360",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 407.56170815229416, 517.7898886080916, 40.0, 22.0 ],
									"text" : "*~ 2.2"
								}
							},
							{
								"box" : {
									"id" : "obj-361",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 358.36170184612274, 637.7474299760265, 91.0, 22.0 ],
									"text" : "s wavebumpsig"
								}
							},
							{
								"box" : {
									"id" : "obj-362",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 345.36170184612274, 507.45181149380824, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-363",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 358.7617091536522, 441.4920808213358, 74.0, 22.0 ],
									"text" : "r wavebump"
								}
							},
							{
								"box" : {
									"id" : "obj-364",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 364.56170904636383, 474.70438998164104, 72.0, 22.0 ],
									"text" : "r audiobang"
								}
							},
							{
								"box" : {
									"id" : "obj-365",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 361.2617091536522, 544.3592796034486, 35.0, 22.0 ],
									"text" : "avg~"
								}
							},
							{
								"box" : {
									"id" : "obj-344",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 549.3617018461227, 486.0, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[50]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[50]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[9]"
								}
							},
							{
								"box" : {
									"id" : "obj-340",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2206.8617018461227, 1861.9828541356185, 42.0, 20.0 ],
									"text" : "alpha"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-338",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2216.234446690727, 1792.284380853176, 23.25451031079092, 66.00000000000045 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[18]",
											"parameter_mmax" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider[17]",
											"parameter_type" : 0
										}
									},
									"size" : 1.0,
									"varname" : "slider[3]"
								}
							},
							{
								"box" : {
									"id" : "obj-337",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2297.9051259035887, 2099.507788806747, 85.0, 22.0 ],
									"text" : "prepend alpha"
								}
							},
							{
								"box" : {
									"attr" : "gl_color",
									"id" : "obj-333",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1567.261587785763, 1003.4042629999999, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-332",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2059.905830261092, 1962.4750248607788, 48.0, 20.0 ],
									"text" : "Radius"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-329",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2071.586834973553, 1886.6750346836243, 24.63799057507822, 71.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[2]",
											"parameter_mmax" : 4.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider[2]",
											"parameter_type" : 0
										}
									},
									"size" : 4.0,
									"varname" : "slider[2]"
								}
							},
							{
								"box" : {
									"id" : "obj-328",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1478.2095908522606, 1155.4000095129013, 83.0, 22.0 ],
									"text" : "r wave2cmdG"
								}
							},
							{
								"box" : {
									"id" : "obj-327",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2247.1529277563095, 2173.0, 85.0, 22.0 ],
									"text" : "s wave2cmdG"
								}
							},
							{
								"box" : {
									"id" : "obj-326",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2113.3031991422176, 1929.9228226465125, 40.39999836683273, 20.0 ],
									"text" : "Thic"
								}
							},
							{
								"box" : {
									"id" : "obj-324",
									"maxclass" : "number",
									"maximum" : 24,
									"minimum" : 1,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2144.703199118376, 1929.9228226465125, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[167]",
											"parameter_mmax" : 24.0,
											"parameter_mmin" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[167]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[47]"
								}
							},
							{
								"box" : {
									"id" : "obj-323",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2247.1529277563095, 2146.3668335676193, 109.0, 22.0 ],
									"text" : "prepend line_width"
								}
							},
							{
								"box" : {
									"id" : "obj-317",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1712.9595901370049, 619.0, 73.0, 22.0 ],
									"text" : "r wave2cmd"
								}
							},
							{
								"box" : {
									"id" : "obj-316",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2268.6595903635025, 1954.3333507180214, 75.0, 22.0 ],
									"text" : "s wave2cmd"
								}
							},
							{
								"box" : {
									"id" : "obj-315",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2116.703199118376, 1917.6750346836243, 150.0, 20.0 ],
									"text" : "Downsample"
								}
							},
							{
								"box" : {
									"id" : "obj-313",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2116.703199118376, 1886.6750346836243, 89.01278203725815, 29.0 ],
									"relative" : 1,
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[1]",
											"parameter_mmax" : 1023.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider[1]",
											"parameter_type" : 0
										}
									},
									"size" : 1024.0,
									"varname" : "slider[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-312",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1685.3617018461227, 1427.0, 53.0, 22.0 ],
									"text" : "s uiGain"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-311",
									"maxclass" : "slider",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1963.2344466907273, 1788.5, 23.25451031079092, 110.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_longname" : "slider[17]",
											"parameter_mmax" : 2.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "slider[17]",
											"parameter_type" : 0
										}
									},
									"size" : 2.0,
									"varname" : "slider"
								}
							},
							{
								"box" : {
									"id" : "obj-309",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1936.3617018461227, 1757.0, 77.0, 20.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 923.5, 127.40000230073929, 93.0, 20.0 ],
									"text" : "Audio Gain"
								}
							},
							{
								"box" : {
									"id" : "obj-310",
									"maxclass" : "meter~",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 1992.8617017269135, 1788.5, 14.0, 104.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 979.4999999403954, 151.9000023007393, 14.0, 104.0 ]
								}
							},
							{
								"box" : {
									"attr" : "tap_enabled",
									"id" : "obj-292",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1766.905126076017, 1357.8269380625, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "pinch_enabled",
									"id" : "obj-304",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1766.905126076017, 1381.8269380625, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "rotate_enabled",
									"id" : "obj-306",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1766.905126076017, 1405.8269380625, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "swipe_enabled",
									"id" : "obj-308",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1766.9051259035887, 1429.8269380625, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-233",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 59.0, 106.0, 640.0, 659.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-232",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 461.7166722416878, 432.615024, 151.0, 22.0 ],
													"text" : "scale -360. 360. 360. -360."
												}
											},
											{
												"box" : {
													"id" : "obj-231",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 377.25, 340.4984563589096, 29.5, 22.0 ],
													"text" : "0"
												}
											},
											{
												"box" : {
													"id" : "obj-229",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 396.25, 384.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-227",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 358.70353920509194, 423.0, 57.0, 22.0 ],
													"text" : "accum 0."
												}
											},
											{
												"box" : {
													"id" : "obj-224",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 56.25, 241.0, 29.5, 22.0 ],
													"text" : "&&"
												}
											},
											{
												"box" : {
													"id" : "obj-221",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 50.0, 423.0, 42.0, 22.0 ],
													"text" : "< 1.01"
												}
											},
											{
												"box" : {
													"id" : "obj-219",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 78.85867158571875, 391.615024, 130.0, 22.0 ],
													"text" : "scale 0. 100. 0. 1. 1.02"
												}
											},
											{
												"box" : {
													"id" : "obj-194",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 108.41666666666652, 216.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-193",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 162.24997663497925, 238.0, 33.0, 22.0 ],
													"text" : "* 0.1"
												}
											},
											{
												"box" : {
													"id" : "obj-190",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 64.25, 120.0, 29.5, 22.0 ],
													"text" : "!= 1"
												}
											},
											{
												"box" : {
													"id" : "obj-189",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 82.82353920902631, 189.71666844189167, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-179",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 130.08328660329198, 126.0, 29.5, 22.0 ],
													"text" : "< 1."
												}
											},
											{
												"box" : {
													"id" : "obj-174",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 134.8235392090263, 176.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-159",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 89.85867158571875, 254.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-161",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 82.82353920902631, 292.0, 71.0, 22.0 ],
													"text" : "accum 0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-149",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 454.7166722416878, 306.33331859111786, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-143",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 426.7166722416878, 230.33331859111786, 22.0, 22.0 ],
													"text" : "t b"
												}
											},
											{
												"box" : {
													"id" : "obj-140",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 426.7166722416878, 263.33331859111786, 29.5, 22.0 ],
													"text" : "&&"
												}
											},
											{
												"box" : {
													"id" : "obj-139",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 465.7166722416878, 216.0, 33.0, 22.0 ],
													"text" : "== 1"
												}
											},
											{
												"box" : {
													"id" : "obj-138",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 383.7166722416878, 216.0, 33.0, 22.0 ],
													"text" : "== 1"
												}
											},
											{
												"box" : {
													"id" : "obj-136",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 191.0833097100258, 250.0, 36.0, 22.0 ],
													"text" : "<= 1."
												}
											},
											{
												"box" : {
													"id" : "obj-134",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 239.26489300000003, 286.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-133",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 285.76489300000003, 286.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-132",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 201.5833097100258, 326.33331859111786, 58.0, 22.0 ],
													"text" : "loadbang"
												}
											},
											{
												"box" : {
													"id" : "obj-131",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 209.25, 406.0, 57.0, 22.0 ],
													"text" : "clip -1. 1."
												}
											},
											{
												"box" : {
													"id" : "obj-129",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 252.24997637669242, 136.9000249999999, 57.0, 22.0 ],
													"text" : "clip -3. 3."
												}
											},
											{
												"box" : {
													"id" : "obj-127",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 195.0833097100258, 357.0, 32.0, 22.0 ],
													"text" : "0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-125",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 279.7499763766924, 326.33331859111786, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-123",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 272.71484399999997, 364.33331859111786, 71.0, 22.0 ],
													"text" : "accum 0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-119",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 292.21484399999997, 250.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-117",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 241.41663942734397, 246.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-113",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 201.5833097100258, 209.0, 29.5, 22.0 ],
													"text" : "> 0."
												}
											},
											{
												"box" : {
													"id" : "obj-112",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 312.71484399999997, 209.0, 29.5, 22.0 ],
													"text" : "< 0."
												}
											},
											{
												"box" : {
													"id" : "obj-108",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 239.26489300000003, 176.0, 125.0, 22.0 ],
													"text" : "scale -10. 10. -0.2 0.2"
												}
											},
											{
												"box" : {
													"id" : "obj-107",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 426.4666722416878, 161.0, 29.5, 22.0 ],
													"text" : "0"
												}
											},
											{
												"box" : {
													"id" : "obj-105",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 394.25, 161.0, 29.5, 22.0 ],
													"text" : "1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-91",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "bang", "bang", "" ],
													"patching_rect" : [ 504.7166722416878, 401.2333435911179, 46.0, 22.0 ],
													"text" : "sel 0 1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-95",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 465.7166722416878, 364.33331859111786, 85.0, 22.0 ],
													"text" : "mira.mt.rotate"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-63",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "bang", "bang", "" ],
													"patching_rect" : [ 330.9999763766924, 132.0, 46.0, 22.0 ],
													"text" : "sel 0 1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-71",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 223.26489300000003, 100.0, 83.0, 22.0 ],
													"text" : "mira.mt.pinch"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-150",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 338.490784, 40.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"comment" : "X axis",
													"id" : "obj-163",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 78.85867300000001, 514.6150210000001, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"comment" : "Y axis",
													"id" : "obj-167",
													"index" : 2,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 461.716675, 514.6150210000001, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-138", 0 ],
													"order" : 1,
													"source" : [ "obj-105", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-139", 0 ],
													"order" : 0,
													"source" : [ "obj-105", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-138", 0 ],
													"order" : 1,
													"source" : [ "obj-107", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-139", 0 ],
													"order" : 0,
													"source" : [ "obj-107", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-112", 0 ],
													"order" : 0,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-113", 0 ],
													"order" : 3,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-117", 1 ],
													"order" : 2,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-119", 1 ],
													"order" : 1,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-119", 0 ],
													"source" : [ "obj-112", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-117", 0 ],
													"source" : [ "obj-113", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-134", 1 ],
													"source" : [ "obj-117", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-133", 1 ],
													"source" : [ "obj-119", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-131", 0 ],
													"order" : 0,
													"source" : [ "obj-123", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-136", 0 ],
													"order" : 1,
													"source" : [ "obj-123", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 1 ],
													"source" : [ "obj-125", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 0 ],
													"source" : [ "obj-127", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-108", 0 ],
													"source" : [ "obj-129", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-127", 0 ],
													"source" : [ "obj-132", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-125", 0 ],
													"source" : [ "obj-133", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-125", 0 ],
													"source" : [ "obj-134", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-134", 0 ],
													"source" : [ "obj-136", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 0 ],
													"source" : [ "obj-138", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 1 ],
													"order" : 0,
													"source" : [ "obj-139", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-143", 0 ],
													"order" : 1,
													"source" : [ "obj-139", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-149", 0 ],
													"source" : [ "obj-140", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 0 ],
													"source" : [ "obj-143", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-71", 0 ],
													"order" : 1,
													"source" : [ "obj-150", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-95", 0 ],
													"order" : 0,
													"source" : [ "obj-150", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 1 ],
													"source" : [ "obj-159", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 0 ],
													"source" : [ "obj-159", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-219", 0 ],
													"source" : [ "obj-161", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-194", 0 ],
													"source" : [ "obj-174", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-174", 0 ],
													"order" : 0,
													"source" : [ "obj-179", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-190", 0 ],
													"order" : 1,
													"source" : [ "obj-179", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-159", 0 ],
													"source" : [ "obj-189", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-224", 0 ],
													"source" : [ "obj-190", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 2 ],
													"source" : [ "obj-194", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 0 ],
													"source" : [ "obj-194", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-163", 0 ],
													"order" : 0,
													"source" : [ "obj-219", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-221", 0 ],
													"order" : 1,
													"source" : [ "obj-219", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-224", 1 ],
													"source" : [ "obj-221", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-189", 0 ],
													"source" : [ "obj-224", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-232", 0 ],
													"source" : [ "obj-227", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 1 ],
													"source" : [ "obj-229", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 0 ],
													"source" : [ "obj-229", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 0 ],
													"source" : [ "obj-231", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-167", 0 ],
													"source" : [ "obj-232", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-105", 0 ],
													"order" : 0,
													"source" : [ "obj-63", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-107", 0 ],
													"source" : [ "obj-63", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 0 ],
													"order" : 1,
													"source" : [ "obj-63", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-129", 0 ],
													"source" : [ "obj-71", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-174", 1 ],
													"order" : 0,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-179", 0 ],
													"order" : 1,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-189", 1 ],
													"order" : 2,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-63", 0 ],
													"source" : [ "obj-71", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-229", 0 ],
													"source" : [ "obj-95", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-91", 0 ],
													"source" : [ "obj-95", 2 ]
												}
											}
										]
									},
									"patching_rect" : [ 1311.5291380097897, 1733.2119140625, 59.0, 22.0 ],
									"text" : "p xypinch"
								}
							},
							{
								"box" : {
									"id" : "obj-240",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1167.029114386482, 1733.3285849243402, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-242",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 1167.029114386482, 1764.0452485978603, 29.5, 22.0 ],
									"text" : "f"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-251",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 7,
									"outlettype" : [ "", "", "", "", "", "", "" ],
									"patching_rect" : [ 1423.9826800163, 1733.8269380625, 211.0, 22.0 ],
									"text" : "mira.mt.centroid"
								}
							},
							{
								"box" : {
									"id" : "obj-261",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1409.442160289529, 1817.5452503561974, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-266",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1518.9124486854107, 1814.2843808531761, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-267",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1278.534550130374, 1795.4749246348592, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-268",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1530.9826772148817, 1774.8269380624997, 104.0, 22.0 ],
									"text" : "scale 0. 1. -90. 90"
								}
							},
							{
								"box" : {
									"id" : "obj-269",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1401.9939820097898, 1774.8269380624997, 104.0, 22.0 ],
									"text" : "scale 0. 1. -90 90."
								}
							},
							{
								"box" : {
									"color" : [ 0.75, 0.75, 0.75, 0.2 ],
									"id" : "obj-270",
									"maxclass" : "mira.multitouch",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1706.6711573873977, 1520.8269381821156, 298.3406677246094, 218.03662449121475 ],
									"pinch_enabled" : 1,
									"presentation" : 1,
									"presentation_rect" : [ 1509.053685831529, 1378.8269381821156, 231.34066772460938, 168.03662449121475 ],
									"rotate_enabled" : 1,
									"swipe_enabled" : 0,
									"swipe_touch_count" : 0,
									"tap_enabled" : 0,
									"tap_tap_count" : 0,
									"tap_touch_count" : 0
								}
							},
							{
								"box" : {
									"id" : "obj-231",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1727.2914929986, 1883.541845548111, 45.0, 22.0 ],
									"text" : "s hue1"
								}
							},
							{
								"box" : {
									"id" : "obj-232",
									"maxclass" : "swatch",
									"numinlets" : 3,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1727.2914929986, 1762.0, 182.16666996479034, 118.55320144297775 ],
									"presentation" : 1,
									"presentation_rect" : [ 1735.9297911524773, 1285.0, 120.16666972637177, 63.36995458602905 ],
									"saturation" : 1.0,
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "swatch[7]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "swatch",
											"parameter_type" : 3
										}
									},
									"varname" : "swatch[3]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-216",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1665.7545371527494, 2131.933350622654, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[13]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[8]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[20]"
								}
							},
							{
								"box" : {
									"id" : "obj-181",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 2023.2914929986, 1879.541845548111, 45.0, 22.0 ],
									"text" : "s hue2"
								}
							},
							{
								"box" : {
									"id" : "obj-189",
									"maxclass" : "swatch",
									"numinlets" : 3,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2023.2914929986, 1758.0, 182.16666996479034, 118.55320144297775 ],
									"presentation" : 1,
									"presentation_rect" : [ 2073.059538602829, 1537.1787326335907, 120.16666972637177, 63.36995458602905 ],
									"saturation" : 1.0,
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "swatch[6]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "swatch",
											"parameter_type" : 3
										}
									},
									"varname" : "swatch[2]"
								}
							},
							{
								"box" : {
									"id" : "obj-68",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 59.0, 106.0, 640.0, 659.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-232",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 461.7166722416878, 432.615024, 151.0, 22.0 ],
													"text" : "scale -360. 360. 360. -360."
												}
											},
											{
												"box" : {
													"id" : "obj-231",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 377.25, 340.4984563589096, 29.5, 22.0 ],
													"text" : "0"
												}
											},
											{
												"box" : {
													"id" : "obj-229",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 396.25, 384.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-227",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 358.70353920509194, 423.0, 57.0, 22.0 ],
													"text" : "accum 0."
												}
											},
											{
												"box" : {
													"id" : "obj-224",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 56.25, 241.0, 29.5, 22.0 ],
													"text" : "&&"
												}
											},
											{
												"box" : {
													"id" : "obj-221",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 50.0, 423.0, 42.0, 22.0 ],
													"text" : "< 1.01"
												}
											},
											{
												"box" : {
													"id" : "obj-219",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 78.85867158571875, 391.615024, 130.0, 22.0 ],
													"text" : "scale 0. 100. 0. 1. 1.02"
												}
											},
											{
												"box" : {
													"id" : "obj-194",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 108.41666666666652, 216.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-193",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 162.24997663497925, 238.0, 33.0, 22.0 ],
													"text" : "* 0.1"
												}
											},
											{
												"box" : {
													"id" : "obj-190",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 64.25, 120.0, 29.5, 22.0 ],
													"text" : "!= 1"
												}
											},
											{
												"box" : {
													"id" : "obj-189",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 82.82353920902631, 189.71666844189167, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-179",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 130.08328660329198, 126.0, 29.5, 22.0 ],
													"text" : "< 1."
												}
											},
											{
												"box" : {
													"id" : "obj-174",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 134.8235392090263, 176.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-159",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 89.85867158571875, 254.0, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-161",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 82.82353920902631, 292.0, 71.0, 22.0 ],
													"text" : "accum 0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-149",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 454.7166722416878, 306.33331859111786, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-143",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 426.7166722416878, 230.33331859111786, 22.0, 22.0 ],
													"text" : "t b"
												}
											},
											{
												"box" : {
													"id" : "obj-140",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 426.7166722416878, 263.33331859111786, 29.5, 22.0 ],
													"text" : "&&"
												}
											},
											{
												"box" : {
													"id" : "obj-139",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 465.7166722416878, 216.0, 33.0, 22.0 ],
													"text" : "== 1"
												}
											},
											{
												"box" : {
													"id" : "obj-138",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 383.7166722416878, 216.0, 33.0, 22.0 ],
													"text" : "== 1"
												}
											},
											{
												"box" : {
													"id" : "obj-136",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 191.0833097100258, 250.0, 36.0, 22.0 ],
													"text" : "<= 1."
												}
											},
											{
												"box" : {
													"id" : "obj-134",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 239.26489300000003, 286.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-133",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 285.76489300000003, 286.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-132",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "bang" ],
													"patching_rect" : [ 201.5833097100258, 326.33331859111786, 58.0, 22.0 ],
													"text" : "loadbang"
												}
											},
											{
												"box" : {
													"id" : "obj-131",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 209.25, 406.0, 57.0, 22.0 ],
													"text" : "clip -1. 1."
												}
											},
											{
												"box" : {
													"id" : "obj-129",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 252.24997637669242, 136.9000249999999, 57.0, 22.0 ],
													"text" : "clip -3. 3."
												}
											},
											{
												"box" : {
													"id" : "obj-127",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 195.0833097100258, 357.0, 32.0, 22.0 ],
													"text" : "0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-125",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "bang", "float" ],
													"patching_rect" : [ 279.7499763766924, 326.33331859111786, 29.5, 22.0 ],
													"text" : "t b f"
												}
											},
											{
												"box" : {
													"id" : "obj-123",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "float" ],
													"patching_rect" : [ 272.71484399999997, 364.33331859111786, 71.0, 22.0 ],
													"text" : "accum 0.33"
												}
											},
											{
												"box" : {
													"id" : "obj-119",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 292.21484399999997, 250.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-117",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 241.41663942734397, 246.0, 32.0, 22.0 ],
													"text" : "gate"
												}
											},
											{
												"box" : {
													"id" : "obj-113",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 201.5833097100258, 209.0, 29.5, 22.0 ],
													"text" : "> 0."
												}
											},
											{
												"box" : {
													"id" : "obj-112",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "int" ],
													"patching_rect" : [ 312.71484399999997, 209.0, 29.5, 22.0 ],
													"text" : "< 0."
												}
											},
											{
												"box" : {
													"id" : "obj-108",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 239.26489300000003, 176.0, 125.0, 22.0 ],
													"text" : "scale -10. 10. -0.2 0.2"
												}
											},
											{
												"box" : {
													"id" : "obj-107",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 426.4666722416878, 161.0, 29.5, 22.0 ],
													"text" : "0"
												}
											},
											{
												"box" : {
													"id" : "obj-105",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 394.25, 161.0, 29.5, 22.0 ],
													"text" : "1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-91",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "bang", "bang", "" ],
													"patching_rect" : [ 504.7166722416878, 401.2333435911179, 46.0, 22.0 ],
													"text" : "sel 0 1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-95",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 465.7166722416878, 364.33331859111786, 85.0, 22.0 ],
													"text" : "mira.mt.rotate"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-63",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 3,
													"outlettype" : [ "bang", "bang", "" ],
													"patching_rect" : [ 330.9999763766924, 132.0, 46.0, 22.0 ],
													"text" : "sel 0 1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-71",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 4,
													"outlettype" : [ "", "", "", "" ],
													"patching_rect" : [ 223.26489300000003, 100.0, 83.0, 22.0 ],
													"text" : "mira.mt.pinch"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-150",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 338.490784, 40.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"comment" : "X axis",
													"id" : "obj-163",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 78.85867300000001, 514.6150210000001, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"comment" : "Y axis",
													"id" : "obj-167",
													"index" : 2,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 461.716675, 514.6150210000001, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-138", 0 ],
													"order" : 1,
													"source" : [ "obj-105", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-139", 0 ],
													"order" : 0,
													"source" : [ "obj-105", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-138", 0 ],
													"order" : 1,
													"source" : [ "obj-107", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-139", 0 ],
													"order" : 0,
													"source" : [ "obj-107", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-112", 0 ],
													"order" : 0,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-113", 0 ],
													"order" : 3,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-117", 1 ],
													"order" : 2,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-119", 1 ],
													"order" : 1,
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-119", 0 ],
													"source" : [ "obj-112", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-117", 0 ],
													"source" : [ "obj-113", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-134", 1 ],
													"source" : [ "obj-117", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-133", 1 ],
													"source" : [ "obj-119", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-131", 0 ],
													"order" : 0,
													"source" : [ "obj-123", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-136", 0 ],
													"order" : 1,
													"source" : [ "obj-123", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 1 ],
													"source" : [ "obj-125", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 0 ],
													"source" : [ "obj-127", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-108", 0 ],
													"source" : [ "obj-129", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-127", 0 ],
													"source" : [ "obj-132", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-125", 0 ],
													"source" : [ "obj-133", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-125", 0 ],
													"source" : [ "obj-134", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-134", 0 ],
													"source" : [ "obj-136", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 0 ],
													"source" : [ "obj-138", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 1 ],
													"order" : 0,
													"source" : [ "obj-139", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-143", 0 ],
													"order" : 1,
													"source" : [ "obj-139", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-149", 0 ],
													"source" : [ "obj-140", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-140", 0 ],
													"source" : [ "obj-143", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-71", 0 ],
													"order" : 1,
													"source" : [ "obj-150", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-95", 0 ],
													"order" : 0,
													"source" : [ "obj-150", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 1 ],
													"source" : [ "obj-159", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 0 ],
													"source" : [ "obj-159", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-219", 0 ],
													"source" : [ "obj-161", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-194", 0 ],
													"source" : [ "obj-174", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-174", 0 ],
													"order" : 0,
													"source" : [ "obj-179", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-190", 0 ],
													"order" : 1,
													"source" : [ "obj-179", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-159", 0 ],
													"source" : [ "obj-189", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-224", 0 ],
													"source" : [ "obj-190", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 2 ],
													"source" : [ "obj-194", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-161", 0 ],
													"source" : [ "obj-194", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-163", 0 ],
													"order" : 0,
													"source" : [ "obj-219", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-221", 0 ],
													"order" : 1,
													"source" : [ "obj-219", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-224", 1 ],
													"source" : [ "obj-221", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-189", 0 ],
													"source" : [ "obj-224", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-232", 0 ],
													"source" : [ "obj-227", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 1 ],
													"source" : [ "obj-229", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 0 ],
													"source" : [ "obj-229", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-227", 0 ],
													"source" : [ "obj-231", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-167", 0 ],
													"source" : [ "obj-232", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-105", 0 ],
													"order" : 0,
													"source" : [ "obj-63", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-107", 0 ],
													"source" : [ "obj-63", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-123", 0 ],
													"order" : 1,
													"source" : [ "obj-63", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-129", 0 ],
													"source" : [ "obj-71", 1 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-174", 1 ],
													"order" : 0,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-179", 0 ],
													"order" : 1,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-189", 1 ],
													"order" : 2,
													"source" : [ "obj-71", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-63", 0 ],
													"source" : [ "obj-71", 2 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-229", 0 ],
													"source" : [ "obj-95", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-91", 0 ],
													"source" : [ "obj-95", 2 ]
												}
											}
										]
									},
									"patching_rect" : [ 1791.84151487301, 2013.2119140625, 59.0, 22.0 ],
									"text" : "p xypinch"
								}
							},
							{
								"box" : {
									"id" : "obj-69",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1647.3414912497024, 2013.3285849243402, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-87",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 1647.3414912497024, 2044.0452485978603, 29.5, 22.0 ],
									"text" : "f"
								}
							},
							{
								"box" : {
									"attr" : "tap_enabled",
									"id" : "obj-89",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 2230.905126076017, 1340.8269380625, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-90",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 7,
									"outlettype" : [ "", "", "", "", "", "", "" ],
									"patching_rect" : [ 1904.2950568795204, 2013.8269380625, 211.0, 22.0 ],
									"text" : "mira.mt.centroid"
								}
							},
							{
								"box" : {
									"id" : "obj-91",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1889.7545371527494, 2097.5452503561974, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-132",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1999.224825548631, 2094.284380853176, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-149",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1758.8469269935945, 2075.4749246348592, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-150",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2011.295054078102, 2054.8269380624997, 107.0, 22.0 ],
									"text" : "scale 0. 1. 2.5 -2.5"
								}
							},
							{
								"box" : {
									"id" : "obj-151",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1882.3063588730101, 2054.8269380624997, 94.0, 22.0 ],
									"text" : "scale 0. 1. -4. 4."
								}
							},
							{
								"box" : {
									"color" : [ 0.75, 0.75, 0.75, 0.2 ],
									"id" : "obj-152",
									"maxclass" : "mira.multitouch",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2016.4153876776518, 1520.8269381821156, 298.3406677246094, 218.03662449121475 ],
									"pinch_enabled" : 1,
									"presentation" : 1,
									"presentation_rect" : [ 577.7509961724281, 420.7633735537529, 231.34066772460938, 168.03662449121475 ],
									"rotate_enabled" : 1,
									"swipe_enabled" : 0,
									"swipe_touch_count" : 0,
									"tap_enabled" : 0,
									"tap_tap_count" : 0,
									"tap_touch_count" : 0
								}
							},
							{
								"box" : {
									"attr" : "pinch_enabled",
									"id" : "obj-153",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 2230.905126076017, 1364.8269380625, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "rotate_enabled",
									"id" : "obj-158",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 2230.905126076017, 1388.8269380625, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "swipe_enabled",
									"id" : "obj-163",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 2230.9051259035887, 1412.8269380625, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-72",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1103.3617335557938, 1342.0000399947166, 149.33333629369736, 22.0 ],
									"text" : "0. 0.786722 0.821229 1."
								}
							},
							{
								"box" : {
									"id" : "obj-66",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1690.361684024334, 964.0000084638596, 124.0, 22.0 ],
									"text" : "loadmess circpoints 1"
								}
							},
							{
								"box" : {
									"id" : "obj-188",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1055.710682347721, 758.2021991869874, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-185",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 106.6638315320015, 901.4898900266821, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-184",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 958.3617018461227, 1403.0, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-183",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 835.6744679808617, 1462.2731068088806, 173.84898050159836, 22.0 ],
									"text" : "0.392375 0.23808 0. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-182",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1027.3691829817028, 1462.2731068088806, 139.0, 22.0 ],
									"text" : "0. 0.786722 0.821229 1."
								}
							},
							{
								"box" : {
									"id" : "obj-170",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1245.710682347721, 878.2000098228455, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-169",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1225.1617198586464, 1023.2000098228455, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"id" : "obj-166",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 2125.161718785763, 1118.522813014402, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-165",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2119.361732840538, 1155.4000095129013, 87.0, 22.0 ],
									"text" : "poly_mode 0 0"
								}
							},
							{
								"box" : {
									"id" : "obj-162",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2119.361732840538, 895.0, 70.0, 22.0 ],
									"text" : "loadmess 0"
								}
							},
							{
								"box" : {
									"id" : "obj-133",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1702.659589290619, 476.60219558686686, 70.0, 22.0 ],
									"text" : "loadmess 2"
								}
							},
							{
								"box" : {
									"fontsize" : 18.0,
									"id" : "obj-134",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1706.4595901370049, 513.8793983200121, 59.0, 29.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[159]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[122]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[46]"
								}
							},
							{
								"box" : {
									"id" : "obj-142",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1706.4595901370049, 551.1377142590418, 86.0, 22.0 ],
									"text" : "prepend mode"
								}
							},
							{
								"box" : {
									"id" : "obj-131",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 1752.0857215399565, 2121.6666588187218, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-130",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1407.999692421201, 2140.770921289921, 77.0, 22.0 ],
									"text" : "loadmess 30"
								}
							},
							{
								"box" : {
									"id" : "obj-129",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1299.6857409353079, 2146.770921289921, 77.0, 22.0 ],
									"text" : "loadmess 20"
								}
							},
							{
								"box" : {
									"id" : "obj-127",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1137.3524061317266, 1999.2105353551965, 80.0, 22.0 ],
									"text" : "loadmess 0.7"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-307",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1185.3524061317266, 2131.933350622654, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[45]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[45]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[45]"
								}
							},
							{
								"box" : {
									"id" : "obj-305",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1175.0, 2187.0, 107.0, 22.0 ],
									"text" : "pak radialradius 1."
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-300",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1880.9985051626982, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[156]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[42]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-301",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1824.9985043282331, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[157]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[43]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-302",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1769.0857488984884, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[158]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[44]"
								}
							},
							{
								"box" : {
									"id" : "obj-303",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1747.4857485766233, 2219.266683459282, 99.0, 22.0 ],
									"text" : "pak scale 1. 1. 1."
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-296",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1701.9985023612799, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[127]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[39]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-297",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1645.9985015268148, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[96]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[40]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-298",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1590.0857460970701, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[100]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[41]"
								}
							},
							{
								"box" : {
									"id" : "obj-299",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1568.485745775205, 2219.266683459282, 117.0, 22.0 ],
									"text" : "pak position 0. 0. -2."
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-295",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1518.9124486854107, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[116]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[31]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-294",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1462.9124478509457, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[126]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[19]"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-293",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1406.999692421201, 2178.4666828513145, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[125]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[125]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-291",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1385.3996920993359, 2219.266683459282, 120.0, 22.0 ],
									"text" : "pak rotatexyz 0. 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-289",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 748.1617124080658, 352.8000048995018, 32.700000047683716, 20.0 ],
									"text" : "out"
								}
							},
							{
								"box" : {
									"id" : "obj-288",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 219.49044080109024, 75.89839397632431, 18.79999804496765, 20.0 ],
									"text" : "in"
								}
							},
							{
								"box" : {
									"id" : "obj-286",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 209.8904406580391, 100.89839397632431, 29.5, 22.0 ],
									"text" : "+~"
								}
							},
							{
								"box" : {
									"id" : "obj-285",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 209.8904406580391, 143.008515894413, 29.5, 22.0 ],
									"text" : "+~"
								}
							},
							{
								"box" : {
									"id" : "obj-284",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 179.16170233488083, 262.40000289678574, 105.99999934434891, 20.0 ],
									"text" : "average samples"
								}
							},
							{
								"box" : {
									"id" : "obj-244",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 146.5617015361786, 335.68988077604126, 90.0, 22.0 ],
									"text" : "loadmess 2500"
								}
							},
							{
								"box" : {
									"id" : "obj-245",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 87.7617017030716, 307.4000043272972, 90.0, 22.0 ],
									"text" : "loadmess 2500"
								}
							},
							{
								"box" : {
									"id" : "obj-103",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 205.16170167922974, 361.8898837443526, 87.0, 22.0 ],
									"text" : "loadmess 0.05"
								}
							},
							{
								"box" : {
									"id" : "obj-102",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 120.06170153617859, 542.5594440490418, 29.5, 22.0 ],
									"text" : "0,"
								}
							},
							{
								"box" : {
									"id" : "obj-246",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "bang", "" ],
									"patching_rect" : [ 55.16169863939285, 223.62680963978528, 34.0, 22.0 ],
									"text" : "sel 0"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-247",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 205.16170167922974, 390.40000224113464, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[35]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[35]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[35]"
								}
							},
							{
								"box" : {
									"id" : "obj-248",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 158.0617015361786, 542.5594440490418, 33.0, 22.0 ],
									"text" : "* 0.8"
								}
							},
							{
								"box" : {
									"id" : "obj-249",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 130.46170124411583, 260.40000289678574, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[153]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[153]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[36]"
								}
							},
							{
								"box" : {
									"id" : "obj-250",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 23.061701893806458, 290.6000040769577, 58.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-252",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 27.46170151233673, 364.2000043988228, 31.0, 23.0 ],
									"text" : "rms"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-253",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 23.061701893806458, 259.40000289678574, 49.0, 23.0 ],
									"text" : "bipolar"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-254",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 23.061701893806458, 319.2000043988228, 59.0, 23.0 ],
									"text" : "absolute"
								}
							},
							{
								"box" : {
									"id" : "obj-255",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 111.06170153617859, 509.97576969008423, 64.0, 22.0 ],
									"text" : "snapshot~"
								}
							},
							{
								"box" : {
									"id" : "obj-256",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 87.46170145273209, 468.75944713656236, 59.0, 22.0 ],
									"text" : "average~"
								}
							},
							{
								"box" : {
									"id" : "obj-257",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 146.5617015361786, 390.40000224113464, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[154]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[154]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[37]"
								}
							},
							{
								"box" : {
									"id" : "obj-258",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 91.56170153617859, 390.40000224113464, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[155]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[155]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[38]"
								}
							},
							{
								"box" : {
									"id" : "obj-259",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 292.76170229911804, 373.4000062942505, 35.0, 22.0 ],
									"text" : "abs~"
								}
							},
							{
								"box" : {
									"id" : "obj-260",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 120.06170153617859, 436.80000162124634, 78.0, 22.0 ],
									"text" : "slide~"
								}
							},
							{
								"box" : {
									"id" : "obj-262",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 87.46170145273209, 593.759450891655, 107.0, 22.0 ],
									"text" : "s kittybumpsignal1"
								}
							},
							{
								"box" : {
									"id" : "obj-263",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 100.56170153617859, 223.62680963978528, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-264",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 50.56170153617859, 180.60000032186508, 88.0, 22.0 ],
									"text" : "r wordBumpEn"
								}
							},
							{
								"box" : {
									"id" : "obj-265",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 158.0617015361786, 180.60000032186508, 59.0, 22.0 ],
									"text" : "r ctrlbang"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-272",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 350.4595729112625, 122.5810381647284, 73.0, 22.0 ],
									"text" : "gainmode 1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-273",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 625.4595729112625, 129.68988101445984, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-274",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 545.4595729112625, 129.68988101445984, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-275",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 450.4595729112625, 129.68988101445984, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-276",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 625.4595729112625, 165.18988101445984, 55.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[150]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[38]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[32]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-277",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 545.4595729112625, 165.18988101445984, 55.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[151]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[37]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[33]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-278",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 455.4595729112625, 165.18988101445984, 57.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[152]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[36]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[34]"
								}
							},
							{
								"box" : {
									"autoout" : 1,
									"bgcolor" : [ 0.913725, 0.913725, 1.0, 1.0 ],
									"curvecolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"domain" : [ 0.0, 22050.0 ],
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"hcurvecolor" : [ 1.0, 0.086275, 0.086275, 1.0 ],
									"id" : "obj-279",
									"linmarkers" : [ 0.0, 11025.0, 16537.5 ],
									"logmarkers" : [ 0.0, 100.0, 1000.0, 10000.0 ],
									"markercolor" : [ 0.509804, 0.509804, 0.509804, 1.0 ],
									"maxclass" : "filtergraph~",
									"nfilters" : 1,
									"numinlets" : 8,
									"numoutlets" : 7,
									"outlettype" : [ "list", "float", "float", "float", "float", "list", "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 332.37446665763855, 222.68988101445984, 246.5, 94.0 ],
									"setfilter" : [ 0, 1, 1, 0, 0, 144.31146240234375, 1.766406178474426, 0.70710676908493, 9.9999997474e-05, 22050.0, 9.9999997474e-05, 16.0, 0.5, 25.0 ],
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-280",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 298.5617029070854, 335.68988077604126, 92.0, 23.0 ],
									"text" : "biquad~"
								}
							},
							{
								"box" : {
									"attr" : "edit_mode",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-281",
									"lock" : 1,
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"orientation" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 350.4595729112625, 154.68988101445984, 83.0, 46.0 ],
									"text_width" : 83.0
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial Bold",
									"fontsize" : 10.0,
									"id" : "obj-282",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 288.840439334816, 209.73427660501648, 31.0, 20.0 ],
									"text" : "*~ 1."
								}
							},
							{
								"box" : {
									"id" : "obj-243",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1270.5085536989632, 922.8000137209892, 86.79999905824661, 20.0 ],
									"text" : "audio loop viz"
								}
							},
							{
								"box" : {
									"id" : "obj-241",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1248.1617198586464, 920.8000137209892, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[53]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[53]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[8]"
								}
							},
							{
								"box" : {
									"id" : "obj-239",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1295.3617205619812, 980.8000146150589, 85.0, 22.0 ],
									"text" : "prepend radial"
								}
							},
							{
								"box" : {
									"id" : "obj-237",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 1071.4212404489517, 1191.541845548111, 45.0, 22.0 ],
									"text" : "s hue2"
								}
							},
							{
								"box" : {
									"id" : "obj-238",
									"maxclass" : "swatch",
									"numinlets" : 3,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1071.4212404489517, 1104.1787326335907, 136.16666996479034, 84.37446880938717 ],
									"presentation" : 1,
									"presentation_rect" : [ 954.0297765731812, 531.3787240982056, 120.16666972637177, 63.36995458602905 ],
									"saturation" : 1.0,
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "swatch[5]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "swatch",
											"parameter_type" : 3
										}
									},
									"varname" : "swatch[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-235",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 913.0212380886078, 1194.1163153588564, 45.0, 22.0 ],
									"text" : "s hue1"
								}
							},
							{
								"box" : {
									"id" : "obj-236",
									"maxclass" : "swatch",
									"numinlets" : 3,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 904.5914770960808, 1104.1787326335907, 136.16666996479034, 84.37446880938717 ],
									"presentation" : 1,
									"presentation_rect" : [ 732.1333429217339, 626.4666675329208, 120.16666972637177, 63.36995458602905 ],
									"saturation" : 1.0,
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "swatch[4]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "swatch",
											"parameter_type" : 3
										}
									},
									"varname" : "swatch"
								}
							},
							{
								"box" : {
									"id" : "obj-234",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2119.361732840538, 1191.6468080459165, 87.0, 22.0 ],
									"text" : "poly_mode 2 2"
								}
							},
							{
								"box" : {
									"id" : "obj-97",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2297.9051259035887, 1854.5532014429778, 83.0, 22.0 ],
									"text" : "loadmess 512"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-98",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1346.8404565605583, 738.8000063896179, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[123]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[69]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[3]"
								}
							},
							{
								"box" : {
									"fontsize" : 18.0,
									"id" : "obj-99",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2209.459590137005, 1886.6750346836243, 59.0, 29.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[124]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[122]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[7]"
								}
							},
							{
								"box" : {
									"id" : "obj-101",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2253.459590137005, 1923.933350622654, 123.0, 22.0 ],
									"text" : "prepend downsample"
								}
							},
							{
								"box" : {
									"id" : "obj-104",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1370.1617187857628, 654.2000098228455, 70.0, 22.0 ],
									"text" : "loadmess 0"
								}
							},
							{
								"box" : {
									"id" : "obj-105",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1464.374483883381, 755.2000098228455, 40.0, 22.0 ],
									"text" : "*~ 0.2"
								}
							},
							{
								"box" : {
									"id" : "obj-106",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1529.9595901370049, 747.3594528228455, 29.5, 22.0 ],
									"text" : "+~"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-107",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1559.374483883381, 653.2000098228455, 45.0, 23.0 ],
									"text" : "$1 20"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-108",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "signal", "bang" ],
									"patching_rect" : [ 1570.2095901370049, 683.2000098228455, 40.0, 23.0 ],
									"text" : "line~"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-109",
									"maxclass" : "flonum",
									"maximum" : 10000.0,
									"minimum" : 10.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1559.374483883381, 625.2000098228455, 54.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_initial" : [ 440 ],
											"parameter_initial_enable" : 1,
											"parameter_invisible" : 1,
											"parameter_longname" : "flonum[2]",
											"parameter_mmax" : 10000.0,
											"parameter_mmin" : 10.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "flonum",
											"parameter_type" : 3
										}
									},
									"triscale" : 0.9,
									"varname" : "flonum[2]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-113",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1560.4595901370049, 715.1270267717709, 90.0, 23.0 ],
									"text" : "cycle~ 440."
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-115",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1458.374483883381, 653.2000098228455, 45.0, 23.0 ],
									"text" : "$1 20"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-118",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "signal", "bang" ],
									"patching_rect" : [ 1469.2095901370049, 683.2000098228455, 40.0, 23.0 ],
									"text" : "line~"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-125",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1459.4595901370049, 715.1270267717709, 90.0, 23.0 ],
									"text" : "cycle~ 440."
								}
							},
							{
								"box" : {
									"id" : "obj-126",
									"maxclass" : "gswitch",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1404.6617187857628, 758.2000098228455, 41.0, 32.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-128",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1346.8404565605583, 825.1145097062788, 44.0, 22.0 ],
									"text" : "*~ -0.5"
								}
							},
							{
								"box" : {
									"id" : "obj-135",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1478.2095908522606, 1118.522813014402, 72.0, 22.0 ],
									"text" : "r audiobang"
								}
							},
							{
								"box" : {
									"id" : "obj-136",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2167.161718785763, 947.689891385668, 91.0, 22.0 ],
									"text" : "r waveLineFilll1"
								}
							},
							{
								"box" : {
									"id" : "obj-137",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2125.161718785763, 941.2000098228455, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[46]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[44]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[5]"
								}
							},
							{
								"box" : {
									"id" : "obj-138",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "bang", "bang", "" ],
									"patching_rect" : [ 2167.161718785763, 980.2000098228455, 44.0, 22.0 ],
									"text" : "sel 0 1"
								}
							},
							{
								"box" : {
									"id" : "obj-139",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2099.7914929986, 1023.2000098228455, 72.0, 22.0 ],
									"text" : "line_width 4"
								}
							},
							{
								"box" : {
									"id" : "obj-140",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2186.161718785763, 1057.6042628228456, 69.0, 22.0 ],
									"text" : "circpoints 5"
								}
							},
							{
								"box" : {
									"id" : "obj-141",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 2186.161718785763, 1023.2000098228455, 69.0, 22.0 ],
									"text" : "circpoints 1"
								}
							},
							{
								"box" : {
									"attr" : "blend",
									"id" : "obj-143",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 1145.1559794467826, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "line_width",
									"id" : "obj-144",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 1045.522813014402, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "poly_mode",
									"id" : "obj-145",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 1118.522813014402, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "two_sided",
									"id" : "obj-146",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 1070.2000098228455, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "circpoints",
									"id" : "obj-147",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 1095.4270660203836, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-148",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1253.210682347721, 1094.2000098228455, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[48]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[43]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[6]"
								}
							},
							{
								"box" : {
									"id" : "obj-159",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1254.210682347721, 1159.6468080459165, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[49]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[42]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[7]"
								}
							},
							{
								"box" : {
									"id" : "obj-160",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1347.1752216371956, 1164.8879535794258, 126.0, 22.0 ],
									"text" : "r soundwave_enable1"
								}
							},
							{
								"box" : {
									"id" : "obj-161",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1347.1752216371956, 1203.292198139243, 61.0, 22.0 ],
									"text" : "enable $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-164",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1793.2776626944542, 619.2468146085739, 72.0, 22.0 ],
									"text" : "r audiobang"
								}
							},
							{
								"box" : {
									"id" : "obj-167",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1302.1752216371956, 1087.4000095129015, 171.0, 22.0 ],
									"text" : "r soundwave_lighting_enable1"
								}
							},
							{
								"box" : {
									"id" : "obj-168",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1324.6752216371956, 1132.7914972275394, 106.0, 22.0 ],
									"text" : "lighting_enable $1"
								}
							},
							{
								"box" : {
									"attr" : "downsample",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-171",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1834.7787374854088, 480.02681390747784, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"attr" : "framesize",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-172",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1834.7787374854088, 507.31450474717235, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"attr" : "mode",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-173",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1834.7787374854088, 531.6021955868669, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-174",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1349.6752216371956, 1259.492642045021, 43.0, 22.0 ],
									"text" : "r hue2"
								}
							},
							{
								"box" : {
									"id" : "obj-175",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 1979.1617187857628, 307.95945086233496, 257.0, 22.0 ],
									"text" : "jit.slide @adapt 1 @slide_up 8 @slide_down 3"
								}
							},
							{
								"box" : {
									"attr" : "trigthresh",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-176",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1834.7787374854088, 555.8898864265616, 228.0, 23.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-178",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1345.6752216371956, 1293.8926664590836, 84.0, 22.0 ],
									"text" : "prepend color"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-180",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 1968.1821825976194, 2146.5682101768393, 60.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"id" : "obj-193",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2092.1821825976194, 2234.266683459282, 20.0, 20.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[52]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[9]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[11]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-194",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1968.1821825976194, 2234.266683459282, 115.0, 22.0 ],
									"text" : "pak blend_enable 1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-195",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2087.1821825976194, 2146.5682101768393, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[144]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[47]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[26]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-196",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 2033.1821825976194, 2146.5682101768393, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[145]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[46]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[27]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-197",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1989.1821825976194, 2185.5682101768393, 117.0, 22.0 ],
									"text" : "pak blend_mode 6 8"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-198",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1476.4595901370049, 788.5810485359366, 73.0, 22.0 ],
									"text" : "gainmode 1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-199",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1751.4595901370049, 795.689891385668, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-200",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1671.4595901370049, 795.689891385668, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-201",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1576.4595901370049, 795.689891385668, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-202",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1751.4595901370049, 831.189891385668, 55.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[146]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[38]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[28]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-203",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1671.4595901370049, 831.189891385668, 55.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[147]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[37]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[29]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-204",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1581.4595901370049, 831.189891385668, 57.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[148]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[36]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[30]"
								}
							},
							{
								"box" : {
									"autoout" : 1,
									"bgcolor" : [ 0.913725, 0.913725, 1.0, 1.0 ],
									"curvecolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"domain" : [ 0.0, 22050.0 ],
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"hcurvecolor" : [ 1.0, 0.086275, 0.086275, 1.0 ],
									"id" : "obj-205",
									"linmarkers" : [ 0.0, 11025.0, 16537.5 ],
									"logmarkers" : [ 0.0, 100.0, 1000.0, 10000.0 ],
									"markercolor" : [ 0.509804, 0.509804, 0.509804, 1.0 ],
									"maxclass" : "filtergraph~",
									"nfilters" : 1,
									"numinlets" : 8,
									"numoutlets" : 7,
									"outlettype" : [ "list", "float", "float", "float", "float", "list", "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1428.1617187857628, 902.2000098228455, 246.5, 94.0 ],
									"setfilter" : [ 0, 1, 1, 0, 0, 60.00290298461914, 2.04883861541748, 0.897967100143433, 9.9999997474e-05, 22050.0, 9.9999997474e-05, 16.0, 0.5, 25.0 ],
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-206",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1417.2095901370049, 1017.689891385668, 92.0, 23.0 ],
									"text" : "biquad~"
								}
							},
							{
								"box" : {
									"attr" : "edit_mode",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-207",
									"lock" : 1,
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"orientation" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1428.1617187857628, 849.4898918148215, 131.29787135124207, 46.0 ],
									"text_width" : 83.0
								}
							},
							{
								"box" : {
									"attr" : "smooth_shading",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-209",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 972.2351221747072, 195.0, 23.0 ],
									"text_width" : 122.410034
								}
							},
							{
								"box" : {
									"attr" : "lighting_enable",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-211",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 947.9474313350124, 195.0, 23.0 ],
									"text_width" : 122.410034
								}
							},
							{
								"box" : {
									"attr" : "circpoints",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-212",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 996.5228130144019, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"fontsize" : 10.0,
									"id" : "obj-213",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 1441.905126076017, 1261.0, 944.0, 20.0 ],
									"text" : "jit.gl.graph foo @antialias 1 @auto_material 0 @color 1 1 1 1 @lighting_enable 0 @shininess 0. @smooth_shading 0 @circpoints 5 @automatic 0 @shadow_caster 0 @line_width 2 @blend_enable 0"
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"fontsize" : 10.0,
									"id" : "obj-214",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 1815.1914927363396, 710.153792142868, 346.0, 20.0 ],
									"text" : "jit.catch~ @mode 3 @framesize 1024 @trigthresh 0.02 @downsample 0"
								}
							},
							{
								"box" : {
									"attr" : "radial",
									"id" : "obj-217",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1567.261587785763, 1079.6042628228456, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "shadow_caster",
									"id" : "obj-218",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1567.261587785763, 1101.6042628228456, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "shininess",
									"id" : "obj-219",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1567.261587785763, 1123.6042628228456, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "smooth_shading",
									"id" : "obj-220",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1567.261587785763, 1145.6042628228456, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "two_sided",
									"id" : "obj-221",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1567.261587785763, 1167.6042628228456, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "outputmode",
									"id" : "obj-222",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 2175.743621647358, 274.95945076052476, 216.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "trigdir",
									"id" : "obj-223",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1884.2946843504906, 666.5474314890595, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "slide_down",
									"id" : "obj-224",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1845.4117187857628, 274.95945076052476, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "slide_up",
									"id" : "obj-225",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 2008.1617184345205, 274.95945076052476, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "blend_enable",
									"id" : "obj-226",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 1172.6042591273576, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "blend_mode",
									"id" : "obj-227",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1848.2095901370049, 1196.6042591273576, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-92",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 561.9194716215134, 710.5214452315831, 70.0, 22.0 ],
									"text" : "loadmess 2"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-96",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 666.6719599366188, 590.2619268434651, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[69]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[69]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[2]"
								}
							},
							{
								"box" : {
									"fontsize" : 18.0,
									"id" : "obj-100",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 556.1719599366188, 745.1214519311452, 59.0, 29.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[122]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[122]",
											"parameter_type" : 3
										}
									},
									"varname" : "number"
								}
							},
							{
								"box" : {
									"id" : "obj-95",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 556.1719599366188, 782.4898900266821, 123.0, 22.0 ],
									"text" : "prepend downsample"
								}
							},
							{
								"box" : {
									"id" : "obj-93",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 796.791486799717, 394.6000027656555, 74.0, 20.0 ],
									"text" : "KittieBump"
								}
							},
							{
								"box" : {
									"id" : "obj-55",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 611.5617081522942, 600.6000039577484, 34.0, 22.0 ],
									"text" : "*~ 1."
								}
							},
							{
								"box" : {
									"id" : "obj-54",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 957.1744759678841, 224.32701930926942, 70.0, 22.0 ],
									"text" : "loadmess 0"
								}
							},
							{
								"box" : {
									"id" : "obj-88",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1041.2595833539963, 239.40000236034393, 40.0, 22.0 ],
									"text" : "*~ 0.2"
								}
							},
							{
								"box" : {
									"id" : "obj-86",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1106.8446896076202, 231.55944536034394, 29.5, 22.0 ],
									"text" : "+~"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-78",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1136.2595833539963, 137.40000236034393, 45.0, 23.0 ],
									"text" : "$1 20"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-79",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "signal", "bang" ],
									"patching_rect" : [ 1147.0946896076202, 167.40000236034393, 40.0, 23.0 ],
									"text" : "line~"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-80",
									"maxclass" : "flonum",
									"maximum" : 10000.0,
									"minimum" : 10.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1136.2595833539963, 109.40000236034393, 54.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_initial" : [ 440 ],
											"parameter_initial_enable" : 1,
											"parameter_invisible" : 1,
											"parameter_longname" : "flonum[1]",
											"parameter_mmax" : 10000.0,
											"parameter_mmin" : 10.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "flonum",
											"parameter_type" : 3
										}
									},
									"triscale" : 0.9,
									"varname" : "flonum[1]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-85",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1137.3446896076202, 199.32701930926942, 90.0, 23.0 ],
									"text" : "cycle~ 440."
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-73",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1035.2595833539963, 137.40000236034393, 45.0, 23.0 ],
									"text" : "$1 20"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-75",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "signal", "bang" ],
									"patching_rect" : [ 1046.0946896076202, 167.40000236034393, 40.0, 23.0 ],
									"text" : "line~"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-76",
									"maxclass" : "flonum",
									"maximum" : 10000.0,
									"minimum" : 10.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1035.2595833539963, 101.40000236034393, 54.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_initial" : [ 440 ],
											"parameter_initial_enable" : 1,
											"parameter_invisible" : 1,
											"parameter_longname" : "flonum",
											"parameter_mmax" : 10000.0,
											"parameter_mmin" : 10.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "flonum",
											"parameter_type" : 3
										}
									},
									"triscale" : 0.9,
									"varname" : "flonum"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-77",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 1036.3446896076202, 199.32701930926942, 90.0, 23.0 ],
									"text" : "cycle~ 440."
								}
							},
							{
								"box" : {
									"id" : "obj-56",
									"maxclass" : "gswitch",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 814.8946686387062, 212.08988224231553, 41.0, 32.0 ]
								}
							},
							{
								"box" : {
									"comment" : "",
									"id" : "obj-53",
									"index" : 2,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 710.6638283133507, 421.8340450525284, 30.0, 30.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-51",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 679.2574594768944, 336.51450264908885, 34.0, 22.0 ],
									"text" : "*~ 1."
								}
							},
							{
								"box" : {
									"id" : "obj-49",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 890.7829924225807, 172.92701891587876, 70.0, 22.0 ],
									"text" : "loadmess 1"
								}
							},
							{
								"box" : {
									"comment" : "",
									"id" : "obj-50",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 698.9617007374763, 254.08988224231553, 30.0, 30.0 ]
								}
							},
							{
								"box" : {
									"comment" : "",
									"id" : "obj-19",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 652.2574594768944, 403.1898846503432, 30.0, 30.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-47",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 565.3106728348198, 654.0351176566751, 101.0, 22.0 ],
									"text" : "s kittybumpsignal"
								}
							},
							{
								"box" : {
									"id" : "obj-41",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 549.3617018461227, 590.2619268434651, 32.0, 22.0 ],
									"text" : "gate"
								}
							},
							{
								"box" : {
									"id" : "obj-26",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 562.7617091536522, 524.3021961709926, 67.0, 22.0 ],
									"text" : "r kittybump"
								}
							},
							{
								"box" : {
									"id" : "obj-21",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 568.5617090463638, 557.5145053312979, 59.0, 22.0 ],
									"text" : "r ctrlbang"
								}
							},
							{
								"box" : {
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 565.2617091536522, 627.1693949531054, 35.0, 22.0 ],
									"text" : "avg~"
								}
							},
							{
								"box" : {
									"id" : "obj-48",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 364.56157225370407, 997.9787312746048, 72.0, 22.0 ],
									"text" : "r audiobang"
								}
							},
							{
								"box" : {
									"id" : "obj-46",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1084.9617028832436, 841.4898900266821, 85.0, 22.0 ],
									"text" : "r waveLineFilll"
								}
							},
							{
								"box" : {
									"id" : "obj-43",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1042.9617028832436, 835.0000084638596, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[44]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[44]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[4]"
								}
							},
							{
								"box" : {
									"id" : "obj-30",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "bang", "bang", "" ],
									"patching_rect" : [ 1084.9617028832436, 874.0000084638596, 44.0, 22.0 ],
									"text" : "sel 0 1"
								}
							},
							{
								"box" : {
									"id" : "obj-27",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1017.5914770960808, 917.0000084638596, 79.0, 22.0 ],
									"text" : "line_width 12"
								}
							},
							{
								"box" : {
									"id" : "obj-24",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1103.9617028832436, 951.4042614638596, 69.0, 22.0 ],
									"text" : "circpoints 5"
								}
							},
							{
								"box" : {
									"id" : "obj-23",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1103.9617028832436, 917.0000084638596, 69.0, 22.0 ],
									"text" : "circpoints 1"
								}
							},
							{
								"box" : {
									"attr" : "blend",
									"id" : "obj-52",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 766.0095742344856, 1038.9559780877967, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "line_width",
									"id" : "obj-65",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 766.0095742344856, 939.322811655416, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "poly_mode",
									"id" : "obj-62",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 766.0095742344856, 1012.322811655416, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "two_sided",
									"id" : "obj-61",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 766.0095742344856, 964.0000084638596, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "circpoints",
									"id" : "obj-58",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 766.0095742344856, 989.2270646613977, 195.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-45",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 141.96170288324356, 946.4000078439713, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[43]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[43]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[3]"
								}
							},
							{
								"box" : {
									"id" : "obj-42",
									"maxclass" : "button",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 730.6638315320015, 1235.382984638214, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "button[8]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "button[8]",
											"parameter_type" : 2
										}
									},
									"varname" : "button"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-31",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 518.9591948390007, 1226.0731054498947, 60.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-36",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 633.6719599366188, 1173.0731054498947, 42.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[83]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[53]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[9]"
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-37",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 670.6719599366188, 1173.0731054498947, 42.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[91]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[52]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[10]"
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-38",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 596.6719599366188, 1173.0731054498947, 42.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[92]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[51]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[11]"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 9.0,
									"id" : "obj-39",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 543.9591948390007, 1263.7788851734335, 82.0, 19.0 ],
									"text" : "pak scale 1.5 1. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-20",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 172.01066644520188, 1053.4468066869306, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[42]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[42]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[2]"
								}
							},
							{
								"box" : {
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 206.00957423448563, 1039.4042614638597, 119.0, 22.0 ],
									"text" : "r soundwave_enable"
								}
							},
							{
								"box" : {
									"id" : "obj-18",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 222.30853779644394, 1076.4255294976758, 61.0, 22.0 ],
									"text" : "enable $1"
								}
							},
							{
								"box" : {
									"id" : "obj-13",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 901.4404501470985, 210.94334148132157, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[41]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[41]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[1]"
								}
							},
							{
								"box" : {
									"id" : "obj-117",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 301.0095742344856, 1164.361703157425, 24.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[24]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[24]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle[10]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-44",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 739.8946686387062, 573.2340475320816, 72.0, 22.0 ],
									"text" : "r audiobang"
								}
							},
							{
								"box" : {
									"id" : "obj-28",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 199.6404406580391, 959.5744867147876, 164.0, 22.0 ],
									"text" : "r soundwave_lighting_enable"
								}
							},
							{
								"box" : {
									"id" : "obj-25",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 199.6404406580391, 997.9787312746048, 106.0, 22.0 ],
									"text" : "lighting_enable $1"
								}
							},
							{
								"box" : {
									"attr" : "slide_down",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-124",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 760.5787217020988, 839.077818951534, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"attr" : "slide_up",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-123",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 760.5787217020988, 807.4898900266821, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"attr" : "downsample",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-122",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 805.0095745325089, 700.5594516014326, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"attr" : "framesize",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-121",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 760.5787217020988, 733.9145083472929, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"attr" : "mode",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-120",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 760.5787217020988, 758.2021991869874, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-119",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 167.51066644520188, 1111.2926406860352, 43.0, 22.0 ],
									"text" : "r hue1"
								}
							},
							{
								"box" : {
									"id" : "obj-208",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 743.0095745325089, 676.5594516014326, 257.0, 22.0 ],
									"text" : "jit.slide @adapt 1 @slide_up 8 @slide_down 3"
								}
							},
							{
								"box" : {
									"attr" : "trigthresh",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-187",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 760.5787217020988, 782.4898900266821, 228.0, 23.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-186",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "signal", "signal" ],
									"patching_rect" : [ 901.4404501470985, 246.3810406800444, 35.0, 22.0 ],
									"text" : "adc~"
								}
							},
							{
								"box" : {
									"id" : "obj-210",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 163.51066644520188, 1145.6926651000977, 84.0, 22.0 ],
									"text" : "prepend color"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-29",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 883.5914770960808, 1229.9787316322327, 60.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-179",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 297.96170288324356, 1236.0731054498947, 60.0, 22.0 ],
									"text" : "loadbang"
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-154",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 798.6744679808617, 1189.4042611122131, 42.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[82]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[82]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[50]"
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-155",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 835.6744679808617, 1189.4042611122131, 42.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[81]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[81]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[49]"
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-156",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 761.6744679808617, 1189.4042611122131, 42.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[80]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[80]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[48]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 9.0,
									"id" : "obj-157",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 733.9617028832436, 1278.4042611122131, 94.0, 19.0 ],
									"text" : "pak rotatexyz 0. 0. 0."
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-81",
									"maxclass" : "flonum",
									"maximum" : 2.0,
									"minimum" : -2.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 413.17446798086166, 1181.0731054498947, 67.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[50]",
											"parameter_mmax" : 2.0,
											"parameter_mmin" : -2.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[50]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[18]"
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-82",
									"maxclass" : "flonum",
									"maximum" : 2.0,
									"minimum" : -2.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 489.17446798086166, 1181.0731054498947, 42.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[49]",
											"parameter_mmax" : 2.0,
											"parameter_mmin" : -2.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[49]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[17]"
								}
							},
							{
								"box" : {
									"bgcolor" : [ 0.866667, 0.866667, 0.866667, 1.0 ],
									"fontname" : "Arial Bold",
									"fontsize" : 14.0,
									"format" : 6,
									"htricolor" : [ 0.87, 0.82, 0.24, 1.0 ],
									"id" : "obj-83",
									"maxclass" : "flonum",
									"maximum" : 2.0,
									"minimum" : -2.0,
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 364.56157225370407, 1181.0731054498947, 42.0, 24.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[48]",
											"parameter_mmax" : 2.0,
											"parameter_mmin" : -2.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[48]",
											"parameter_type" : 3
										}
									},
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"tricolor" : [ 0.75, 0.75, 0.75, 1.0 ],
									"triscale" : 0.9,
									"varname" : "number[16]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 9.0,
									"id" : "obj-84",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 281.6638315320015, 1270.0731054498947, 100.0, 19.0 ],
									"text" : "pak position 0. -0.85 0."
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-63",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 210.00957423448563, 1198.0212849378586, 95.0, 22.0 ],
									"text" : "pak automatic 0"
								}
							},
							{
								"box" : {
									"id" : "obj-116",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1017.5914770960808, 1304.6772049146753, 20.0, 20.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_enum" : [ "off", "on" ],
											"parameter_longname" : "toggle[9]",
											"parameter_mmax" : 1,
											"parameter_modmode" : 0,
											"parameter_shortname" : "toggle[9]",
											"parameter_type" : 2
										}
									},
									"varname" : "toggle"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-114",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 893.5914770960808, 1304.6772049146753, 115.0, 22.0 ],
									"text" : "pak blend_enable 1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-110",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1002.5914770960808, 1229.9787316322327, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[47]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[47]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[15]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-111",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 948.5914770960808, 1229.9787316322327, 50.0, 22.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[46]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[46]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[14]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-112",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 904.5914770960808, 1268.9787316322327, 117.0, 22.0 ],
									"text" : "pak blend_mode 6 7"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-60",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 808.8765930533409, 299.98104147874665, 73.0, 22.0 ],
									"text" : "gainmode 1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-2",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1083.876593053341, 307.0898843284781, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-1",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1003.8765930533409, 307.0898843284781, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-4",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 890.7829924225807, 286.2000033855438, 48.0, 23.0 ],
									"text" : "set $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-6",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1083.876593053341, 342.5898843284781, 55.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[38]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[38]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[6]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-74",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1003.8765930533409, 342.5898843284781, 55.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[37]",
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[37]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[5]"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"format" : 6,
									"id" : "obj-7",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 913.8765930533409, 342.5898843284781, 57.0, 23.0 ],
									"saved_attribute_attributes" : {
										"valueof" : {
											"parameter_invisible" : 1,
											"parameter_longname" : "number[36]",
											"parameter_modmax" : 19.0,
											"parameter_modmin" : 1.0,
											"parameter_modmode" : 0,
											"parameter_shortname" : "number[36]",
											"parameter_type" : 3
										}
									},
									"varname" : "number[4]"
								}
							},
							{
								"box" : {
									"autoout" : 1,
									"bgcolor" : [ 0.913725, 0.913725, 1.0, 1.0 ],
									"curvecolor" : [ 0.0, 0.0, 0.0, 1.0 ],
									"domain" : [ 0.0, 22050.0 ],
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"hcurvecolor" : [ 1.0, 0.086275, 0.086275, 1.0 ],
									"id" : "obj-8",
									"linmarkers" : [ 0.0, 11025.0, 16537.5 ],
									"logmarkers" : [ 0.0, 100.0, 1000.0, 10000.0 ],
									"markercolor" : [ 0.509804, 0.509804, 0.509804, 1.0 ],
									"maxclass" : "filtergraph~",
									"nfilters" : 1,
									"numinlets" : 8,
									"numoutlets" : 7,
									"outlettype" : [ "list", "float", "float", "float", "float", "list", "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 760.5787217020988, 413.6000027656555, 246.5, 94.0 ],
									"setfilter" : [ 0, 1, 1, 0, 0, 46.66890335083008, 0.916996538639069, 1.015430927276611, 9.9999997474e-05, 22050.0, 9.9999997474e-05, 16.0, 0.5, 25.0 ],
									"textcolor" : [ 0.0, 0.0, 0.0, 1.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-17",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "signal" ],
									"patching_rect" : [ 707.3117122650146, 528.2898843165572, 92.0, 23.0 ],
									"text" : "biquad~"
								}
							},
							{
								"box" : {
									"attr" : "edit_mode",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-10",
									"lock" : 1,
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"orientation" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 808.8765930533409, 332.0898843284781, 83.0, 46.0 ],
									"text_width" : 83.0
								}
							},
							{
								"box" : {
									"attr" : "smooth_shading",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-32",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 766.0095742344856, 866.0351208157213, 195.0, 23.0 ],
									"text_width" : 122.410034
								}
							},
							{
								"box" : {
									"attr" : "lighting_enable",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-33",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 766.0095742344856, 841.7474299760265, 195.0, 23.0 ],
									"text_width" : 122.410034
								}
							},
							{
								"box" : {
									"attr" : "circpoints",
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-34",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 766.0095742344856, 890.322811655416, 195.0, 23.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"fontsize" : 10.0,
									"id" : "obj-12",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 400.5615727901459, 1079.6042605638504, 793.0, 20.0 ],
									"text" : "jit.gl.graph foo @antialias 0 @auto_material 0 @color 1 1 1 1 @lighting_enable 0 @shininess 50 @smooth_shading 0 @circpoints 5 @automatic 0 @shadow_caster 0"
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"fontsize" : 10.0,
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_matrix", "" ],
									"patching_rect" : [ 750.5914770960808, 612.7474299760265, 346.0, 20.0 ],
									"text" : "jit.catch~ @mode 3 @framesize 1024 @trigthresh 0.02 @downsample 0"
								}
							},
							{
								"box" : {
									"attr" : "antialias",
									"id" : "obj-9",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 465.06157158522035, 895.4042606293946, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "radial",
									"id" : "obj-22",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 465.06157158522035, 917.4042606293946, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "shadow_caster",
									"id" : "obj-35",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 465.06157158522035, 939.4042606293946, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "shininess",
									"id" : "obj-40",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 465.06157158522035, 961.4042606293946, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "smooth_shading",
									"id" : "obj-67",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 465.06157158522035, 983.4042606293947, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "outputmode",
									"id" : "obj-70",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 919.5914770960808, 641.1594514638596, 216.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "trigdir",
									"id" : "obj-71",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 814.8946686387062, 582.7474304638596, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "slide_down",
									"id" : "obj-5",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 998.5574441552162, 270.46157334152986, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "slide_up",
									"id" : "obj-15",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 752.0095738832435, 641.1594514638596, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "blend_enable",
									"id" : "obj-57",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 413.17446798086166, 1314.4042614638597, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "blend_mode",
									"id" : "obj-59",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 413.17446798086166, 1338.4042614638597, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"attr" : "antialias",
									"id" : "obj-16",
									"maxclass" : "attrui",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1567.261587785763, 1053.404263, 150.0, 22.0 ]
								}
							},
							{
								"box" : {
									"background" : 1,
									"color" : [ 0.0, 0.0, 0.0, 0.301960784313725 ],
									"id" : "obj-177",
									"ignoreclick" : 1,
									"maxclass" : "mira.frame",
									"numinlets" : 0,
									"numoutlets" : 0,
									"patching_rect" : [ 1651.3617018461227, 1503.0, 680.7912259101868, 484.0 ],
									"tabname" : "SoundWaves",
									"taborder" : 4
								}
							}
						],
						"lines" : [
							{
								"patchline" : {
									"destination" : [ "obj-74", 0 ],
									"source" : [ "obj-1", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-10", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-95", 0 ],
									"source" : [ "obj-100", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-316", 0 ],
									"source" : [ "obj-101", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-262", 0 ],
									"source" : [ "obj-102", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-247", 0 ],
									"source" : [ "obj-103", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-126", 0 ],
									"source" : [ "obj-104", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-126", 2 ],
									"source" : [ "obj-105", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-105", 0 ],
									"source" : [ "obj-106", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-108", 0 ],
									"source" : [ "obj-107", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-113", 0 ],
									"source" : [ "obj-108", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-107", 0 ],
									"source" : [ "obj-109", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-47", 0 ],
									"source" : [ "obj-11", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-112", 2 ],
									"source" : [ "obj-110", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-112", 1 ],
									"source" : [ "obj-111", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-112", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-106", 1 ],
									"source" : [ "obj-113", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-114", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-118", 0 ],
									"source" : [ "obj-115", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-114", 1 ],
									"source" : [ "obj-116", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-63", 1 ],
									"source" : [ "obj-117", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-125", 0 ],
									"source" : [ "obj-118", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-210", 0 ],
									"source" : [ "obj-119", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-120", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-121", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-122", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-208", 0 ],
									"source" : [ "obj-123", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-208", 0 ],
									"source" : [ "obj-124", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-106", 0 ],
									"source" : [ "obj-125", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-128", 1 ],
									"source" : [ "obj-126", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-329", 0 ],
									"source" : [ "obj-127", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-206", 0 ],
									"source" : [ "obj-128", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-293", 0 ],
									"source" : [ "obj-129", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-186", 0 ],
									"source" : [ "obj-13", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-294", 0 ],
									"source" : [ "obj-130", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-303", 0 ],
									"source" : [ "obj-131", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-299", 2 ],
									"source" : [ "obj-132", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-134", 0 ],
									"source" : [ "obj-133", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-142", 0 ],
									"source" : [ "obj-134", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-135", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-138", 0 ],
									"source" : [ "obj-136", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-138", 0 ],
									"source" : [ "obj-137", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-139", 0 ],
									"order" : 1,
									"source" : [ "obj-138", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-140", 0 ],
									"source" : [ "obj-138", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-141", 0 ],
									"order" : 0,
									"source" : [ "obj-138", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-139", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-14", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-140", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-141", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-142", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-143", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-144", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-145", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-146", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-147", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-208", 0 ],
									"source" : [ "obj-15", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-132", 0 ],
									"source" : [ "obj-150", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-91", 0 ],
									"source" : [ "obj-151", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-68", 0 ],
									"order" : 1,
									"source" : [ "obj-152", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-90", 0 ],
									"order" : 0,
									"source" : [ "obj-152", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-152", 0 ],
									"source" : [ "obj-153", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-157", 2 ],
									"source" : [ "obj-154", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-157", 3 ],
									"source" : [ "obj-155", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-157", 1 ],
									"source" : [ "obj-156", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-157", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-152", 0 ],
									"source" : [ "obj-158", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-161", 0 ],
									"source" : [ "obj-159", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-16", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-161", 0 ],
									"source" : [ "obj-160", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-161", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-137", 0 ],
									"source" : [ "obj-162", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-152", 0 ],
									"source" : [ "obj-163", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-164", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-165", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-165", 0 ],
									"source" : [ "obj-166", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-168", 0 ],
									"source" : [ "obj-167", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-168", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-148", 0 ],
									"order" : 1,
									"source" : [ "obj-169", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-159", 0 ],
									"order" : 0,
									"source" : [ "obj-169", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"order" : 0,
									"source" : [ "obj-17", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-360", 0 ],
									"order" : 2,
									"source" : [ "obj-17", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-55", 0 ],
									"order" : 1,
									"source" : [ "obj-17", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-241", 0 ],
									"source" : [ "obj-170", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-171", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-172", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-173", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-178", 0 ],
									"source" : [ "obj-174", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-176", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-178", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-84", 0 ],
									"source" : [ "obj-179", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-18", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-194", 0 ],
									"order" : 1,
									"source" : [ "obj-180", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-197", 0 ],
									"order" : 0,
									"source" : [ "obj-180", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-238", 0 ],
									"source" : [ "obj-182", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-236", 0 ],
									"source" : [ "obj-183", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-182", 0 ],
									"order" : 0,
									"source" : [ "obj-184", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-183", 0 ],
									"order" : 1,
									"source" : [ "obj-184", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-20", 0 ],
									"order" : 0,
									"source" : [ "obj-185", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-45", 0 ],
									"order" : 1,
									"source" : [ "obj-185", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-56", 1 ],
									"source" : [ "obj-186", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-187", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-43", 0 ],
									"source" : [ "obj-188", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-181", 0 ],
									"source" : [ "obj-189", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-194", 1 ],
									"source" : [ "obj-193", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-194", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-197", 2 ],
									"source" : [ "obj-195", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-197", 1 ],
									"source" : [ "obj-196", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-197", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-205", 0 ],
									"source" : [ "obj-198", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-202", 0 ],
									"source" : [ "obj-199", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-2", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 0 ],
									"source" : [ "obj-20", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-203", 0 ],
									"source" : [ "obj-200", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-204", 0 ],
									"source" : [ "obj-201", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-205", 7 ],
									"source" : [ "obj-202", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-205", 6 ],
									"source" : [ "obj-203", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-205", 5 ],
									"source" : [ "obj-204", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-199", 0 ],
									"source" : [ "obj-205", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-200", 0 ],
									"source" : [ "obj-205", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-201", 0 ],
									"source" : [ "obj-205", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-206", 0 ],
									"source" : [ "obj-205", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-206", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-205", 0 ],
									"source" : [ "obj-207", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-208", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-209", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-41", 1 ],
									"source" : [ "obj-21", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-210", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-211", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-212", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-214", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-64", 0 ],
									"source" : [ "obj-215", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-217", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-218", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-219", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-22", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-220", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-221", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-175", 0 ],
									"source" : [ "obj-222", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-223", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-175", 0 ],
									"source" : [ "obj-224", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-175", 0 ],
									"source" : [ "obj-225", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-226", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-227", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-338", 0 ],
									"source" : [ "obj-228", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-215", 0 ],
									"source" : [ "obj-229", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-23", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-231", 0 ],
									"source" : [ "obj-232", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-240", 0 ],
									"source" : [ "obj-233", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-267", 0 ],
									"source" : [ "obj-233", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-234", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-235", 0 ],
									"source" : [ "obj-236", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-237", 0 ],
									"source" : [ "obj-238", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-239", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-24", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-242", 0 ],
									"source" : [ "obj-240", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-239", 0 ],
									"source" : [ "obj-241", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-257", 0 ],
									"source" : [ "obj-244", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-258", 0 ],
									"source" : [ "obj-245", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-102", 0 ],
									"source" : [ "obj-246", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-248", 1 ],
									"source" : [ "obj-247", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-262", 0 ],
									"order" : 1,
									"source" : [ "obj-248", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-318", 0 ],
									"order" : 0,
									"source" : [ "obj-248", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-256", 0 ],
									"source" : [ "obj-249", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-25", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-254", 0 ],
									"source" : [ "obj-250", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-268", 0 ],
									"source" : [ "obj-251", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-269", 0 ],
									"source" : [ "obj-251", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-256", 0 ],
									"source" : [ "obj-252", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-256", 0 ],
									"source" : [ "obj-253", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-256", 0 ],
									"source" : [ "obj-254", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-248", 0 ],
									"source" : [ "obj-255", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-255", 0 ],
									"source" : [ "obj-256", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-260", 2 ],
									"source" : [ "obj-257", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-260", 1 ],
									"source" : [ "obj-258", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-260", 0 ],
									"source" : [ "obj-259", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-41", 0 ],
									"source" : [ "obj-26", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-256", 0 ],
									"source" : [ "obj-260", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 2 ],
									"source" : [ "obj-261", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-255", 0 ],
									"source" : [ "obj-263", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-246", 0 ],
									"order" : 1,
									"source" : [ "obj-264", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-263", 0 ],
									"order" : 0,
									"source" : [ "obj-264", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-263", 1 ],
									"source" : [ "obj-265", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 1 ],
									"source" : [ "obj-266", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-266", 0 ],
									"source" : [ "obj-268", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-261", 0 ],
									"source" : [ "obj-269", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-27", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-233", 0 ],
									"order" : 1,
									"source" : [ "obj-270", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-251", 0 ],
									"order" : 0,
									"source" : [ "obj-270", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-279", 0 ],
									"source" : [ "obj-272", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-276", 0 ],
									"source" : [ "obj-273", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-277", 0 ],
									"source" : [ "obj-274", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-278", 0 ],
									"source" : [ "obj-275", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-279", 7 ],
									"source" : [ "obj-276", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-279", 6 ],
									"source" : [ "obj-277", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-279", 5 ],
									"source" : [ "obj-278", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-273", 0 ],
									"source" : [ "obj-279", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-274", 0 ],
									"source" : [ "obj-279", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-275", 0 ],
									"source" : [ "obj-279", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-280", 0 ],
									"source" : [ "obj-279", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-28", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-259", 0 ],
									"source" : [ "obj-280", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-279", 0 ],
									"source" : [ "obj-281", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-280", 0 ],
									"order" : 0,
									"source" : [ "obj-282", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-285", 0 ],
									"order" : 1,
									"source" : [ "obj-282", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-282", 0 ],
									"source" : [ "obj-286", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-246", 0 ],
									"order" : 1,
									"source" : [ "obj-287", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-263", 0 ],
									"order" : 0,
									"source" : [ "obj-287", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-112", 0 ],
									"source" : [ "obj-29", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-291", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-270", 0 ],
									"source" : [ "obj-292", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 1 ],
									"source" : [ "obj-293", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 2 ],
									"source" : [ "obj-294", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-291", 3 ],
									"source" : [ "obj-295", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-299", 3 ],
									"source" : [ "obj-296", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-299", 2 ],
									"source" : [ "obj-297", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-299", 1 ],
									"source" : [ "obj-298", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-299", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-208", 0 ],
									"source" : [ "obj-3", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-23", 0 ],
									"order" : 0,
									"source" : [ "obj-30", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-24", 0 ],
									"source" : [ "obj-30", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-27", 0 ],
									"order" : 1,
									"source" : [ "obj-30", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-303", 3 ],
									"source" : [ "obj-300", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-303", 2 ],
									"source" : [ "obj-301", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-303", 1 ],
									"source" : [ "obj-302", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-303", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-270", 0 ],
									"source" : [ "obj-304", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-305", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-270", 0 ],
									"source" : [ "obj-306", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-305", 1 ],
									"source" : [ "obj-307", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-270", 0 ],
									"source" : [ "obj-308", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-39", 0 ],
									"source" : [ "obj-31", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-312", 0 ],
									"source" : [ "obj-311", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-99", 0 ],
									"source" : [ "obj-313", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-214", 0 ],
									"source" : [ "obj-317", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-325", 2 ],
									"source" : [ "obj-319", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-32", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-325", 1 ],
									"source" : [ "obj-320", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-322", 4 ],
									"source" : [ "obj-321", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-325", 0 ],
									"source" : [ "obj-322", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-327", 0 ],
									"source" : [ "obj-323", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-323", 0 ],
									"source" : [ "obj-324", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-328", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-305", 1 ],
									"source" : [ "obj-329", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-33", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-333", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-189", 0 ],
									"source" : [ "obj-337", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-368", 0 ],
									"source" : [ "obj-338", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-331", 0 ],
									"source" : [ "obj-339", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-34", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-41", 0 ],
									"source" : [ "obj-344", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-35", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-362", 0 ],
									"source" : [ "obj-357", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-360", 1 ],
									"source" : [ "obj-359", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-39", 2 ],
									"source" : [ "obj-36", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-365", 0 ],
									"source" : [ "obj-360", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-365", 0 ],
									"source" : [ "obj-362", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-362", 0 ],
									"source" : [ "obj-363", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-362", 1 ],
									"source" : [ "obj-364", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-367", 0 ],
									"source" : [ "obj-365", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-369", 0 ],
									"source" : [ "obj-366", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-361", 0 ],
									"source" : [ "obj-367", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-337", 0 ],
									"source" : [ "obj-368", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-368", 1 ],
									"source" : [ "obj-369", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-368", 0 ],
									"source" : [ "obj-369", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-39", 3 ],
									"source" : [ "obj-37", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-370", 0 ],
									"source" : [ "obj-372", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-39", 1 ],
									"source" : [ "obj-38", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-39", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-7", 0 ],
									"source" : [ "obj-4", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-40", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-41", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-157", 0 ],
									"source" : [ "obj-42", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-43", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-44", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-45", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-46", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-48", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-13", 0 ],
									"source" : [ "obj-49", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-208", 0 ],
									"source" : [ "obj-5", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-51", 1 ],
									"source" : [ "obj-50", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-128", 0 ],
									"order" : 1,
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-17", 0 ],
									"order" : 3,
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-19", 0 ],
									"order" : 4,
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-286", 0 ],
									"order" : 5,
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-310", 0 ],
									"order" : 0,
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-53", 0 ],
									"order" : 2,
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-52", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-56", 0 ],
									"source" : [ "obj-54", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-55", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-51", 0 ],
									"source" : [ "obj-56", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-57", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-58", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-59", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 7 ],
									"source" : [ "obj-6", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-60", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-61", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-62", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-63", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-232", 0 ],
									"source" : [ "obj-64", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-65", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-213", 0 ],
									"source" : [ "obj-66", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-67", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-149", 0 ],
									"source" : [ "obj-68", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-69", 0 ],
									"source" : [ "obj-68", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-87", 0 ],
									"source" : [ "obj-69", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 5 ],
									"source" : [ "obj-7", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-208", 0 ],
									"source" : [ "obj-70", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-71", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-75", 0 ],
									"source" : [ "obj-73", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 6 ],
									"source" : [ "obj-74", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-77", 0 ],
									"source" : [ "obj-75", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-73", 0 ],
									"source" : [ "obj-76", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-86", 0 ],
									"source" : [ "obj-77", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-79", 0 ],
									"source" : [ "obj-78", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-85", 0 ],
									"source" : [ "obj-79", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-1", 0 ],
									"source" : [ "obj-8", 2 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-17", 0 ],
									"source" : [ "obj-8", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-2", 0 ],
									"source" : [ "obj-8", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-8", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-78", 0 ],
									"source" : [ "obj-80", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-84", 2 ],
									"source" : [ "obj-81", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-84", 3 ],
									"source" : [ "obj-82", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-84", 1 ],
									"source" : [ "obj-83", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-84", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-86", 1 ],
									"source" : [ "obj-85", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-88", 0 ],
									"source" : [ "obj-86", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-216", 0 ],
									"order" : 0,
									"source" : [ "obj-87", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-305", 1 ],
									"order" : 1,
									"source" : [ "obj-87", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-56", 2 ],
									"source" : [ "obj-88", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-152", 0 ],
									"source" : [ "obj-89", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-9", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-150", 0 ],
									"source" : [ "obj-90", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-151", 0 ],
									"source" : [ "obj-90", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-299", 1 ],
									"source" : [ "obj-91", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-100", 0 ],
									"source" : [ "obj-92", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-116", 0 ],
									"source" : [ "obj-94", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-95", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-55", 1 ],
									"source" : [ "obj-96", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-99", 0 ],
									"source" : [ "obj-97", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-128", 1 ],
									"source" : [ "obj-98", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-101", 0 ],
									"source" : [ "obj-99", 0 ]
								}
							}
						],
						"boxgroups" : [
							{
								"boxes" : [
									"obj-241",
									"obj-243"
								]
							},
							{
								"boxes" : [
									"obj-189",
									"obj-181"
								]
							},
							{
								"boxes" : [
									"obj-232",
									"obj-231"
								]
							},
							{
								"boxes" : [
									"obj-329",
									"obj-332"
								]
							},
							{
								"boxes" : [
									"obj-340",
									"obj-338"
								]
							},
							{
								"boxes" : [
									"obj-190",
									"obj-215"
								]
							}
						]
					},
					"patching_rect" : [ 373.0, 10.0, 134.0, 36.0 ],
					"text" : "p sound2",
					"textcolor" : [ 0.0, 1.0, 0.0, 1.0 ]
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-147",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1324.875, 415.0, 90.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1103.0, 405.9000023007393, 90.0, 22.0 ],
					"text" : "dim 8192 8192"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-138",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 133.0, 548.0, 34.0, 19.0 ],
					"text" : "reset"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-139",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 133.0, 566.0, 80.0, 19.0 ],
					"text" : "jit.gl.handle foo"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-1",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1318.0, 220.0, 90.0, 22.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 1102.5, 332.4000023007393, 90.0, 22.0 ],
					"text" : "dim 2560 1440"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-52",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 133.0, 354.0, 50.0, 22.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_invisible" : 1,
							"parameter_longname" : "number[12]",
							"parameter_modmode" : 0,
							"parameter_shortname" : "number[12]",
							"parameter_type" : 3
						}
					},
					"varname" : "number[4]"
				}
			},
			{
				"box" : {
					"fontface" : 0,
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-16",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 77.0, 388.0, 111.0, 22.0 ],
					"text" : "pak interval 120 hz"
				}
			},
			{
				"box" : {
					"id" : "obj-20",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 95.0, 657.0, 20.0, 20.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_enum" : [ "off", "on" ],
							"parameter_longname" : "toggle[6]",
							"parameter_mmax" : 1,
							"parameter_modmode" : 0,
							"parameter_shortname" : "toggle[6]",
							"parameter_type" : 2
						}
					},
					"varname" : "toggle[6]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-25",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 20.0, 711.0, 115.0, 22.0 ],
					"text" : "pak blend_enable 0"
				}
			},
			{
				"box" : {
					"bgcolor" : [ 0.050980392156863, 0.094117647058824, 0.062745098039216, 1.0 ],
					"fontface" : 1,
					"fontname" : "Menlo Bold",
					"fontsize" : 24.0,
					"id" : "obj-148",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "jit_gl_texture" ],
					"patcher" : {
						"fileversion" : 1,
						"appversion" : {
							"major" : 9,
							"minor" : 0,
							"revision" : 7,
							"architecture" : "x64",
							"modernui" : 1
						},
						"classnamespace" : "box",
						"rect" : [ 156.0, 134.0, 1046.0, 903.0 ],
						"gridsize" : [ 15.0, 15.0 ],
						"boxes" : [
							{
								"box" : {
									"id" : "obj-84",
									"linecount" : 2,
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 291.0, 99.0, 266.22443437036463, 33.0 ],
									"text" : "Leap is primarty control, reverts to iPad after 2 seconds of no hands"
								}
							},
							{
								"box" : {
									"id" : "obj-82",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 369.0, 67.0, 24.0, 24.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-80",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 3,
									"outlettype" : [ "", "int", "int" ],
									"patching_rect" : [ 403.1500020325184, 62.0, 48.0, 22.0 ],
									"text" : "change"
								}
							},
							{
								"box" : {
									"id" : "obj-78",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"patching_rect" : [ 477.93996339438706, 62.0, 46.0, 22.0 ],
									"text" : "< 2000"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 9.0,
									"id" : "obj-77",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 530.0418981554685, -6.0, 46.0, 19.0 ],
									"text" : "r ctrlbang"
								}
							},
							{
								"box" : {
									"id" : "obj-68",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 403.1500020325184, 27.0, 22.0, 22.0 ],
									"text" : "t b"
								}
							},
							{
								"box" : {
									"id" : "obj-59",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "float", "" ],
									"patching_rect" : [ 464.0, 31.0, 35.0, 22.0 ],
									"text" : "timer"
								}
							},
							{
								"box" : {
									"id" : "obj-57",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 398.0418981554685, -7.0, 113.0, 22.0 ],
									"text" : "r leap2HandsActive"
								}
							},
							{
								"box" : {
									"id" : "obj-46",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 160.0, 838.0, 643.0, 22.0 ],
									"text" : "0. 0. 0. 0. 0. 0. 0. 0. 1."
								}
							},
							{
								"box" : {
									"id" : "obj-58",
									"maxclass" : "toggle",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "int" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 741.4399633943872, 37.599974155426025, 24.0, 24.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-55",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 341.9999999999999, 229.0, 22.0, 22.0 ],
									"text" : "t b"
								}
							},
							{
								"box" : {
									"id" : "obj-53",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 992.0, 188.0, 150.0, 20.0 ],
									"text" : "Color Invert (unused atm)"
								}
							},
							{
								"box" : {
									"id" : "obj-45",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1023.0, 215.0, 73.0, 22.0 ],
									"text" : "loadmess 1."
								}
							},
							{
								"box" : {
									"id" : "obj-49",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1083.0, 356.0, 29.5, 22.0 ],
									"text" : "-1"
								}
							},
							{
								"box" : {
									"id" : "obj-5",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 926.0, 451.0, 73.0, 22.0 ],
									"text" : "loadmess 1."
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-18",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1136.0, 457.0, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-14",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1011.0, 424.0, 111.0, 22.0 ],
									"text" : "scale -1. 1. -1.5 1.5"
								}
							},
							{
								"box" : {
									"floatoutput" : 1,
									"id" : "obj-12",
									"maxclass" : "slider",
									"min" : -1.0,
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 1011.0, 262.0, 20.0, 140.0 ],
									"size" : 2.0
								}
							},
							{
								"box" : {
									"id" : "obj-3",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1011.0, 466.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-87",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 1147.0, 538.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-89",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1139.0, 504.0, 97.0, 22.0 ],
									"text" : "scale 0. 1. 0. 1.5"
								}
							},
							{
								"box" : {
									"color" : [ 0.941176, 0.690196, 0.196078, 1.0 ],
									"id" : "obj-47",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_gl_texture", "" ],
									"patching_rect" : [ 946.0, 629.0, 125.0, 22.0 ],
									"text" : "jit.gl.pix @gen brcosa"
								}
							},
							{
								"box" : {
									"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"hint" : "Move this control to set the saturation of the output.",
									"id" : "obj-142",
									"maxclass" : "live.dial",
									"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1088.0, 498.0, 44.0, 48.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 155.4748077392578, 55.792236328125, 60.0, 48.0 ],
									"saved_attribute_attributes" : {
										"activedialcolor" : {
											"expression" : ""
										},
										"activeneedlecolor" : {
											"expression" : ""
										},
										"dialcolor" : {
											"expression" : ""
										},
										"needlecolor" : {
											"expression" : ""
										},
										"valueof" : {
											"parameter_initial" : [ 1.0 ],
											"parameter_initial_enable" : 1,
											"parameter_longname" : "saturation[4]",
											"parameter_mmax" : 1.5,
											"parameter_modmode" : 0,
											"parameter_shortname" : "Saturation",
											"parameter_type" : 0,
											"parameter_unitstyle" : 1
										}
									},
									"varname" : "Offset[3]"
								}
							},
							{
								"box" : {
									"fontname" : "Ableton Sans Medium",
									"fontsize" : 12.0,
									"id" : "obj-143",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1083.0, 581.0, 80.0, 23.0 ],
									"text" : "saturation $1"
								}
							},
							{
								"box" : {
									"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"hint" : "Move this control to set the contrast of the output.",
									"id" : "obj-129",
									"maxclass" : "live.dial",
									"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 1020.0, 512.0, 44.0, 48.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 86.97479248046875, 55.792236328125, 60.0, 48.0 ],
									"saved_attribute_attributes" : {
										"activedialcolor" : {
											"expression" : ""
										},
										"activeneedlecolor" : {
											"expression" : ""
										},
										"dialcolor" : {
											"expression" : ""
										},
										"needlecolor" : {
											"expression" : ""
										},
										"valueof" : {
											"parameter_initial" : [ 1.0 ],
											"parameter_initial_enable" : 1,
											"parameter_longname" : "contrast[3]",
											"parameter_mmax" : 1.5,
											"parameter_mmin" : -1.5,
											"parameter_modmode" : 0,
											"parameter_shortname" : "Contrast",
											"parameter_type" : 0,
											"parameter_unitstyle" : 1
										}
									},
									"varname" : "Offset[1]"
								}
							},
							{
								"box" : {
									"fontname" : "Ableton Sans Medium",
									"fontsize" : 12.0,
									"id" : "obj-130",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 1003.0, 573.0, 72.0, 23.0 ],
									"text" : "contrast $1"
								}
							},
							{
								"box" : {
									"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"hint" : "Move this control to set the brightness of the output.",
									"id" : "obj-121",
									"maxclass" : "live.dial",
									"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "float" ],
									"parameter_enable" : 1,
									"patching_rect" : [ 926.0, 512.0, 44.0, 48.0 ],
									"presentation" : 1,
									"presentation_rect" : [ 18.47480797767639, 55.792236328125, 60.0, 48.0 ],
									"saved_attribute_attributes" : {
										"activedialcolor" : {
											"expression" : ""
										},
										"activeneedlecolor" : {
											"expression" : ""
										},
										"dialcolor" : {
											"expression" : ""
										},
										"needlecolor" : {
											"expression" : ""
										},
										"valueof" : {
											"parameter_initial" : [ 1.0 ],
											"parameter_initial_enable" : 1,
											"parameter_linknames" : 1,
											"parameter_longname" : "Offset[1]",
											"parameter_mmax" : 1.25,
											"parameter_modmode" : 0,
											"parameter_shortname" : "Brightness",
											"parameter_type" : 0,
											"parameter_unitstyle" : 1
										}
									},
									"varname" : "Offset[2]"
								}
							},
							{
								"box" : {
									"fontname" : "Ableton Sans Medium",
									"fontsize" : 12.0,
									"id" : "obj-48",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 910.0, 573.0, 83.0, 23.0 ],
									"text" : "brightness $1"
								}
							},
							{
								"box" : {
									"id" : "obj-38",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 637.2399636447267, 112.0, 36.39999830722809, 20.0 ],
									"text" : "NYI"
								}
							},
							{
								"box" : {
									"id" : "obj-37",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 660.4399639904336, 134.0, 36.39999830722809, 20.0 ],
									"text" : "ancy"
								}
							},
							{
								"box" : {
									"id" : "obj-24",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 620.4399633943872, 134.0, 36.39999830722809, 20.0 ],
									"text" : "ancx"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-17",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 741.4399633943872, 457.0, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-13",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 683.5, 457.0, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-10",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 653.1066300610538, 504.0, 132.0, 22.0 ],
									"text" : "pak param anchor 0. 0."
								}
							},
							{
								"box" : {
									"id" : "obj-2",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 0,
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 59.0, 106.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-13",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 225.5, 114.0, 37.0, 20.0 ],
													"text" : "bias"
												}
											},
											{
												"box" : {
													"id" : "obj-12",
													"maxclass" : "comment",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 80.0, 100.0, 37.0, 20.0 ],
													"text" : "sb"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 11.934731,
													"id" : "obj-75",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 160.0, 283.49996107816696, 84.0, 22.0 ],
													"text" : "param bias $1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 11.934731,
													"id" : "obj-77",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 62.0, 283.49996107816696, 90.0, 22.0 ],
													"text" : "param scale $1"
												}
											},
											{
												"box" : {
													"filename" : "cc.scalebias.jxs",
													"fontface" : 0,
													"fontname" : "Arial",
													"fontsize" : 11.934731,
													"id" : "obj-10",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 2,
													"outlettype" : [ "jit_gl_texture", "" ],
													"patching_rect" : [ 74.5, 320.6999732851982, 194.0, 22.0 ],
													"text" : "jit.gl.slab foo @file cc.scalebias.jxs",
													"textfile" : {
														"filename" : "cc.scalebias.jxs",
														"flags" : 0,
														"embed" : 0,
														"autowatch" : 1
													}
												}
											},
											{
												"box" : {
													"format" : 6,
													"id" : "obj-57",
													"maxclass" : "flonum",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"parameter_enable" : 0,
													"patching_rect" : [ 153.30010986328125, 242.0999976992607, 50.0, 22.0 ]
												}
											},
											{
												"box" : {
													"format" : 6,
													"id" : "obj-55",
													"maxclass" : "flonum",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"parameter_enable" : 0,
													"patching_rect" : [ 68.30010986328125, 242.0999976992607, 50.0, 22.0 ]
												}
											},
											{
												"box" : {
													"id" : "obj-87",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patcher" : {
														"fileversion" : 1,
														"appversion" : {
															"major" : 9,
															"minor" : 0,
															"revision" : 7,
															"architecture" : "x64",
															"modernui" : 1
														},
														"classnamespace" : "box",
														"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
														"gridsize" : [ 15.0, 15.0 ],
														"boxes" : [
															{
																"box" : {
																	"id" : "obj-2",
																	"maxclass" : "newobj",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
																	"text" : "r lineSmoothGrain"
																}
															},
															{
																"box" : {
																	"comment" : "",
																	"id" : "obj-1",
																	"index" : 1,
																	"maxclass" : "outlet",
																	"numinlets" : 1,
																	"numoutlets" : 0,
																	"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-49",
																	"maxclass" : "newobj",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
																	"text" : "r controlSmoothMs"
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-50",
																	"maxclass" : "newobj",
																	"numinlets" : 2,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
																	"text" : "pack 0. 200"
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-9",
																	"maxclass" : "newobj",
																	"numinlets" : 3,
																	"numoutlets" : 2,
																	"outlettype" : [ "", "bang" ],
																	"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
																	"text" : "line 0."
																}
															},
															{
																"box" : {
																	"comment" : "",
																	"id" : "obj-108",
																	"index" : 1,
																	"maxclass" : "inlet",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
																}
															}
														],
														"lines" : [
															{
																"patchline" : {
																	"destination" : [ "obj-50", 0 ],
																	"source" : [ "obj-108", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-9", 2 ],
																	"source" : [ "obj-2", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-50", 1 ],
																	"source" : [ "obj-49", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-9", 0 ],
																	"source" : [ "obj-50", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-1", 0 ],
																	"source" : [ "obj-9", 0 ]
																}
															}
														]
													},
													"patching_rect" : [ 289.0, 413.4000244140625, 97.0, 22.0 ],
													"text" : "p mIniCtlSmooth"
												}
											},
											{
												"box" : {
													"fontface" : 0,
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-89",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 282.0, 379.9000244140625, 97.0, 22.0 ],
													"text" : "scale 0. 1. 0. 1.5"
												}
											},
											{
												"box" : {
													"color" : [ 0.941176, 0.690196, 0.196078, 1.0 ],
													"id" : "obj-47",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "jit_gl_texture", "" ],
													"patching_rect" : [ 88.5, 504.87536641406246, 125.0, 22.0 ],
													"text" : "jit.gl.pix @gen brcosa"
												}
											},
											{
												"box" : {
													"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"hint" : "Move this control to set the saturation of the output.",
													"id" : "obj-142",
													"maxclass" : "live.dial",
													"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "float" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 230.27556562963537, 374.0, 44.0, 48.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 155.4748077392578, 55.792236328125, 60.0, 48.0 ],
													"saved_attribute_attributes" : {
														"activedialcolor" : {
															"expression" : ""
														},
														"activeneedlecolor" : {
															"expression" : ""
														},
														"dialcolor" : {
															"expression" : ""
														},
														"needlecolor" : {
															"expression" : ""
														},
														"valueof" : {
															"parameter_initial" : [ 1.0 ],
															"parameter_initial_enable" : 1,
															"parameter_longname" : "saturation[3]",
															"parameter_mmax" : 1.5,
															"parameter_modmode" : 0,
															"parameter_shortname" : "Saturation",
															"parameter_type" : 0,
															"parameter_unitstyle" : 1
														}
													},
													"varname" : "Offset[3]"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-143",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 225.27556562963525, 456.0, 80.0, 23.0 ],
													"text" : "saturation $1"
												}
											},
											{
												"box" : {
													"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"hint" : "Move this control to set the contrast of the output.",
													"id" : "obj-129",
													"maxclass" : "live.dial",
													"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "float" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 162.0, 387.4000244140625, 44.0, 48.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 86.97479248046875, 55.792236328125, 60.0, 48.0 ],
													"saved_attribute_attributes" : {
														"activedialcolor" : {
															"expression" : ""
														},
														"activeneedlecolor" : {
															"expression" : ""
														},
														"dialcolor" : {
															"expression" : ""
														},
														"needlecolor" : {
															"expression" : ""
														},
														"valueof" : {
															"parameter_initial" : [ 1.0 ],
															"parameter_initial_enable" : 1,
															"parameter_longname" : "contrast[2]",
															"parameter_mmax" : 1.5,
															"parameter_mmin" : -1.5,
															"parameter_modmode" : 0,
															"parameter_shortname" : "Contrast",
															"parameter_type" : 0,
															"parameter_unitstyle" : 1
														}
													},
													"varname" : "Offset[1]"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-130",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 146.0, 449.0, 72.0, 23.0 ],
													"text" : "contrast $1"
												}
											},
											{
												"box" : {
													"activedialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"activeneedlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"dialcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"hint" : "Move this control to set the brightness of the output.",
													"id" : "obj-121",
													"maxclass" : "live.dial",
													"needlecolor" : [ 1.0, 1.0, 1.0, 1.0 ],
													"numinlets" : 1,
													"numoutlets" : 2,
													"outlettype" : [ "", "float" ],
													"parameter_enable" : 1,
													"patching_rect" : [ 68.0, 387.4000244140625, 44.0, 48.0 ],
													"presentation" : 1,
													"presentation_rect" : [ 18.47480797767639, 55.792236328125, 60.0, 48.0 ],
													"saved_attribute_attributes" : {
														"activedialcolor" : {
															"expression" : ""
														},
														"activeneedlecolor" : {
															"expression" : ""
														},
														"dialcolor" : {
															"expression" : ""
														},
														"needlecolor" : {
															"expression" : ""
														},
														"valueof" : {
															"parameter_initial" : [ 1.0 ],
															"parameter_initial_enable" : 1,
															"parameter_linknames" : 1,
															"parameter_longname" : "Offset[4]",
															"parameter_mmax" : 1.25,
															"parameter_modmode" : 0,
															"parameter_shortname" : "Brightness",
															"parameter_type" : 0,
															"parameter_unitstyle" : 1
														}
													},
													"varname" : "Offset[4]"
												}
											},
											{
												"box" : {
													"fontname" : "Ableton Sans Medium",
													"fontsize" : 12.0,
													"id" : "obj-48",
													"maxclass" : "message",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 52.0, 449.0, 83.0, 23.0 ],
													"text" : "brightness $1"
												}
											},
											{
												"box" : {
													"id" : "obj-18",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patcher" : {
														"fileversion" : 1,
														"appversion" : {
															"major" : 9,
															"minor" : 0,
															"revision" : 7,
															"architecture" : "x64",
															"modernui" : 1
														},
														"classnamespace" : "box",
														"rect" : [ 360.0, 424.0, 640.0, 480.0 ],
														"gridsize" : [ 15.0, 15.0 ],
														"boxes" : [
															{
																"box" : {
																	"id" : "obj-2",
																	"maxclass" : "newobj",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
																	"text" : "r lineSmoothGrain"
																}
															},
															{
																"box" : {
																	"comment" : "",
																	"id" : "obj-1",
																	"index" : 1,
																	"maxclass" : "outlet",
																	"numinlets" : 1,
																	"numoutlets" : 0,
																	"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-49",
																	"maxclass" : "newobj",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
																	"text" : "r controlSmoothMs"
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-50",
																	"maxclass" : "newobj",
																	"numinlets" : 2,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
																	"text" : "pack 0. 200"
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-9",
																	"maxclass" : "newobj",
																	"numinlets" : 3,
																	"numoutlets" : 2,
																	"outlettype" : [ "", "bang" ],
																	"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
																	"text" : "line 0."
																}
															},
															{
																"box" : {
																	"comment" : "",
																	"id" : "obj-108",
																	"index" : 1,
																	"maxclass" : "inlet",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
																}
															}
														],
														"lines" : [
															{
																"patchline" : {
																	"destination" : [ "obj-50", 0 ],
																	"source" : [ "obj-108", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-9", 2 ],
																	"source" : [ "obj-2", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-50", 1 ],
																	"source" : [ "obj-49", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-9", 0 ],
																	"source" : [ "obj-50", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-1", 0 ],
																	"source" : [ "obj-9", 0 ]
																}
															}
														]
													},
													"patching_rect" : [ 50.0, 183.4000244140625, 97.0, 22.0 ],
													"text" : "p mIniCtlSmooth"
												}
											},
											{
												"box" : {
													"id" : "obj-17",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patcher" : {
														"fileversion" : 1,
														"appversion" : {
															"major" : 9,
															"minor" : 0,
															"revision" : 7,
															"architecture" : "x64",
															"modernui" : 1
														},
														"classnamespace" : "box",
														"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
														"gridsize" : [ 15.0, 15.0 ],
														"boxes" : [
															{
																"box" : {
																	"id" : "obj-2",
																	"maxclass" : "newobj",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
																	"text" : "r lineSmoothGrain"
																}
															},
															{
																"box" : {
																	"comment" : "",
																	"id" : "obj-1",
																	"index" : 1,
																	"maxclass" : "outlet",
																	"numinlets" : 1,
																	"numoutlets" : 0,
																	"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-49",
																	"maxclass" : "newobj",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
																	"text" : "r controlSmoothMs"
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-50",
																	"maxclass" : "newobj",
																	"numinlets" : 2,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
																	"text" : "pack 0. 200"
																}
															},
															{
																"box" : {
																	"fontname" : "Arial",
																	"fontsize" : 12.0,
																	"id" : "obj-9",
																	"maxclass" : "newobj",
																	"numinlets" : 3,
																	"numoutlets" : 2,
																	"outlettype" : [ "", "bang" ],
																	"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
																	"text" : "line 0."
																}
															},
															{
																"box" : {
																	"comment" : "",
																	"id" : "obj-108",
																	"index" : 1,
																	"maxclass" : "inlet",
																	"numinlets" : 0,
																	"numoutlets" : 1,
																	"outlettype" : [ "" ],
																	"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
																}
															}
														],
														"lines" : [
															{
																"patchline" : {
																	"destination" : [ "obj-50", 0 ],
																	"source" : [ "obj-108", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-9", 2 ],
																	"source" : [ "obj-2", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-50", 1 ],
																	"source" : [ "obj-49", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-9", 0 ],
																	"source" : [ "obj-50", 0 ]
																}
															},
															{
																"patchline" : {
																	"destination" : [ "obj-1", 0 ],
																	"source" : [ "obj-9", 0 ]
																}
															}
														]
													},
													"patching_rect" : [ 165.5, 179.4000244140625, 97.0, 22.0 ],
													"text" : "p mIniCtlSmooth"
												}
											},
											{
												"box" : {
													"fontface" : 0,
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-68",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 165.5, 151.4000244140625, 111.0, 22.0 ],
													"text" : "scale -1. 1. -0.5 0.1"
												}
											},
											{
												"box" : {
													"fontface" : 0,
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-67",
													"maxclass" : "newobj",
													"numinlets" : 6,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 55.0, 146.4000244140625, 107.0, 22.0 ],
													"text" : "scale -1. 1. 0.5 1.5"
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-48", 0 ],
													"source" : [ "obj-121", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-130", 0 ],
													"source" : [ "obj-129", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-47", 0 ],
													"source" : [ "obj-130", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-143", 0 ],
													"source" : [ "obj-142", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-47", 0 ],
													"source" : [ "obj-143", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-75", 0 ],
													"source" : [ "obj-17", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-77", 0 ],
													"source" : [ "obj-18", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-47", 0 ],
													"source" : [ "obj-48", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-77", 0 ],
													"source" : [ "obj-55", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-75", 0 ],
													"source" : [ "obj-57", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-18", 0 ],
													"source" : [ "obj-67", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-17", 0 ],
													"source" : [ "obj-68", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-10", 0 ],
													"source" : [ "obj-75", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-10", 0 ],
													"source" : [ "obj-77", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-143", 0 ],
													"source" : [ "obj-87", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-87", 0 ],
													"source" : [ "obj-89", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 9.0, 7.0, 75.0, 22.0 ],
									"text" : "p oldconrtrol"
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-1",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 735.5, 625.2000343203545, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-76",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 559.7175066437566, 620.2000343203545, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-73",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 335.9799305663212, 625.2000343203545, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-64",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 495.9504056588588, 584.2000343203545, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-65",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 477.93996339438706, 620.2000343203545, 31.0, 22.0 ],
									"text" : "* -1."
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-61",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 683.5, 597.0, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-62",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 679.4399633943872, 635.0, 31.0, 22.0 ],
									"text" : "* -1."
								}
							},
							{
								"box" : {
									"format" : 6,
									"id" : "obj-54",
									"maxclass" : "flonum",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 291.0, 582.2000343203545, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-52",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 280.0, 625.2000343203545, 31.0, 22.0 ],
									"text" : "* -1."
								}
							},
							{
								"box" : {
									"id" : "obj-50",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 627.4399633943872, 699.4000244140625, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-51",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 620.4399633943872, 665.9000244140625, 141.0, 22.0 ],
									"text" : "scale 0. 1. -0.05 0.05 0.1"
								}
							},
							{
								"box" : {
									"id" : "obj-27",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 250.0, 218.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 427.71750664375656, 708.4000244140625, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-36",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 427.71750664375656, 656.2000343203545, 151.0, 22.0 ],
									"text" : "scale -1. 1. -0.04 0.02 0.05"
								}
							},
							{
								"box" : {
									"id" : "obj-8",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 456.5, 757.8753664140625, 73.0, 22.0 ],
									"text" : "lightness $1"
								}
							},
							{
								"box" : {
									"id" : "obj-4",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 360.5, 757.8753664140625, 78.0, 22.0 ],
									"text" : "saturation $1"
								}
							},
							{
								"box" : {
									"id" : "obj-30",
									"maxclass" : "gswitch",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 164.0, 92.0, 41.0, 32.0 ]
								}
							},
							{
								"box" : {
									"id" : "obj-16",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 258.0418981554685, 1.0, 90.0, 22.0 ],
									"text" : "r shadeCtlLeap"
								}
							},
							{
								"box" : {
									"id" : "obj-44",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 326.0, 193.0, 54.0, 22.0 ],
									"text" : "r SInvert"
								}
							},
							{
								"box" : {
									"id" : "obj-39",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "bang" ],
									"patching_rect" : [ 869.0, 133.0, 22.0, 22.0 ],
									"text" : "t b"
								}
							},
							{
								"box" : {
									"id" : "obj-40",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 852.1399645149545, 83.59997415542603, 29.5, 22.0 ],
									"text" : "-1."
								}
							},
							{
								"box" : {
									"id" : "obj-41",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 807.6399645149545, 83.59997415542603, 29.5, 22.0 ],
									"text" : "1."
								}
							},
							{
								"box" : {
									"id" : "obj-42",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 3,
									"outlettype" : [ "bang", "bang", "" ],
									"patching_rect" : [ 852.1399645149545, 38.599974155426025, 44.0, 22.0 ],
									"text" : "sel 0 1"
								}
							},
							{
								"box" : {
									"id" : "obj-43",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 812.1399645149545, 2.999998569488525, 93.0, 22.0 ],
									"text" : "r scaleInvtoggle"
								}
							},
							{
								"box" : {
									"id" : "obj-35",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 487.26710098489775, 384.0, 54.0, 22.0 ],
									"text" : "r SInvert"
								}
							},
							{
								"box" : {
									"id" : "obj-34",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 800.6399645149545, 170.19998168945312, 56.0, 22.0 ],
									"text" : "s SInvert"
								}
							},
							{
								"box" : {
									"id" : "obj-33",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 395.6500020325184, 248.0, 29.5, 22.0 ],
									"text" : "* 1."
								}
							},
							{
								"box" : {
									"id" : "obj-32",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 277.25, 248.0, 29.5, 22.0 ],
									"text" : "* 1."
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-199",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 487.26710098489775, 134.0, 44.0, 20.0 ],
									"text" : "theta",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-200",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 438.8447339899317, 134.0, 43.0, 20.0 ],
									"text" : "scale",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-201",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 388.71750664375645, 134.0, 45.0, 20.0 ],
									"text" : "yshift",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-202",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 341.9999999999999, 134.0, 41.0, 20.0 ],
									"text" : "xshift",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-203",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 257.77556562963537, 134.0, 85.0, 20.0 ],
									"text" : "scalebright",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-204",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 213.61534951269311, 134.0, 38.0, 20.0 ],
									"text" : "bias",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-205",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 172.01242392256472, 134.0, 35.0, 20.0 ],
									"text" : "hue",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-206",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 536.5418981554685, 134.0, 33.0, 20.0 ],
									"text" : "NC",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"fontname" : "Arial Bold",
									"id" : "obj-207",
									"maxclass" : "comment",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 576.4399633943872, 134.0, 36.0, 20.0 ],
									"text" : "sat",
									"textjustification" : 1
								}
							},
							{
								"box" : {
									"id" : "obj-28",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "float" ],
									"patching_rect" : [ 448.71750664375645, 414.0999976992607, 31.0, 22.0 ],
									"text" : "* -1."
								}
							},
							{
								"box" : {
									"id" : "obj-164",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 433.26710098489775, 321.0, 104.0, 22.0 ],
									"text" : "scale -1. 1 0.4 1.2"
								}
							},
							{
								"box" : {
									"id" : "obj-31",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 219.5, 667.4000686407089, 145.0, 22.0 ],
									"text" : "scale -1. 1. -0.05 0.05 0.1"
								}
							},
							{
								"box" : {
									"id" : "obj-29",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 267.0, 757.8753664140625, 74.0, 22.0 ],
									"text" : "hue_shift $1"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 13.0,
									"id" : "obj-25",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "jit_gl_texture", "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "jit.gen",
										"rect" : [ 34.0, 87.0, 600.0, 450.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"title" : "untitled",
										"boxes" : [
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-10",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 482.0, 100.0, 113.0, 22.0 ],
													"text" : "param lightness 0.5"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 362.0, 100.0, 119.0, 22.0 ],
													"text" : "param saturation 0.5"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-7",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 278.0, 157.0, 67.0, 22.0 ],
													"text" : "vec 0. 0. 0."
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-6",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 232.0, 100.0, 121.0, 22.0 ],
													"text" : "param hue_shift 0.02"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-5",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 176.0, 247.0, 50.0, 22.0 ],
													"text" : "hsl2rgb"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 176.0, 195.0, 32.5, 22.0 ],
													"text" : "+"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-1",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 14.0, 30.0, 22.0 ],
													"text" : "in 1"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-3",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 176.0, 149.0, 50.0, 22.0 ],
													"text" : "rgb2hsl"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-4",
													"maxclass" : "newobj",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 176.0, 418.0, 37.0, 22.0 ],
													"text" : "out 1"
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-3", 0 ],
													"source" : [ "obj-1", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-7", 2 ],
													"source" : [ "obj-10", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-5", 0 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-2", 0 ],
													"source" : [ "obj-3", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-4", 0 ],
													"source" : [ "obj-5", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-7", 0 ],
													"source" : [ "obj-6", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-2", 1 ],
													"source" : [ "obj-7", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-7", 1 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										],
										"bgcolor" : [ 0.9, 0.9, 0.9, 1.0 ],
										"editing_bgcolor" : [ 0.9, 0.9, 0.9, 1.0 ]
									},
									"patching_rect" : [ 288.0, 802.9126103520393, 54.0, 23.0 ],
									"text" : "jit.gl.pix"
								}
							},
							{
								"box" : {
									"id" : "obj-22",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 360.0, 424.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 620.4399633943872, 384.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-21",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 360.0, 424.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 436.26710098489775, 353.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-20",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 360.0, 424.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 326.26710098489775, 322.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-19",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 360.0, 424.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 225.26710098489775, 322.0, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-15",
									"maxclass" : "newobj",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 157.04189815546852, 1.0, 63.0, 22.0 ],
									"text" : "r shadeCtl"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-93",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 627.4399633943872, 355.0, 151.0, 22.0 ],
									"text" : "scale -1. 1. 3.1415 -3.1415"
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-92",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 525.2671009848978, 414.0999976992607, 111.0, 22.0 ],
									"text" : "pak param theta 0."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-91",
									"maxclass" : "newobj",
									"numinlets" : 3,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 354.71750664375645, 449.0, 113.0, 22.0 ],
									"text" : "pak param zoom 0."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-88",
									"maxclass" : "newobj",
									"numinlets" : 4,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 211.26710098489775, 364.0, 124.0, 22.0 ],
									"text" : "pak param offset 0. 0."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-72",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 379.26710098489775, 278.0, 138.0, 22.0 ],
									"text" : "scale -1. 1. -2000. 2000."
								}
							},
							{
								"box" : {
									"fontface" : 0,
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-69",
									"maxclass" : "newobj",
									"numinlets" : 6,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 225.26710098489775, 284.0, 138.0, 22.0 ],
									"text" : "scale -1. 1. -2000. 2000."
								}
							},
							{
								"box" : {
									"id" : "obj-26",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patcher" : {
										"fileversion" : 1,
										"appversion" : {
											"major" : 9,
											"minor" : 0,
											"revision" : 7,
											"architecture" : "x64",
											"modernui" : 1
										},
										"classnamespace" : "box",
										"rect" : [ 360.0, 424.0, 640.0, 480.0 ],
										"gridsize" : [ 15.0, 15.0 ],
										"boxes" : [
											{
												"box" : {
													"id" : "obj-2",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 295.0, 244.0, 105.0, 22.0 ],
													"text" : "r lineSmoothGrain"
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-1",
													"index" : 1,
													"maxclass" : "outlet",
													"numinlets" : 1,
													"numoutlets" : 0,
													"patching_rect" : [ 50.0, 219.0, 30.0, 30.0 ]
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-49",
													"maxclass" : "newobj",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 127.0, 100.0, 109.0, 22.0 ],
													"text" : "r controlSmoothMs"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-50",
													"maxclass" : "newobj",
													"numinlets" : 2,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 50.0, 131.0, 73.0, 22.0 ],
													"text" : "pack 0. 200"
												}
											},
											{
												"box" : {
													"fontname" : "Arial",
													"fontsize" : 12.0,
													"id" : "obj-9",
													"maxclass" : "newobj",
													"numinlets" : 3,
													"numoutlets" : 2,
													"outlettype" : [ "", "bang" ],
													"patching_rect" : [ 50.0, 173.0, 46.0, 22.0 ],
													"text" : "line 0."
												}
											},
											{
												"box" : {
													"comment" : "",
													"id" : "obj-108",
													"index" : 1,
													"maxclass" : "inlet",
													"numinlets" : 0,
													"numoutlets" : 1,
													"outlettype" : [ "" ],
													"patching_rect" : [ 41.0, 47.0, 30.0, 30.0 ]
												}
											}
										],
										"lines" : [
											{
												"patchline" : {
													"destination" : [ "obj-50", 0 ],
													"source" : [ "obj-108", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 2 ],
													"source" : [ "obj-2", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-50", 1 ],
													"source" : [ "obj-49", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-9", 0 ],
													"source" : [ "obj-50", 0 ]
												}
											},
											{
												"patchline" : {
													"destination" : [ "obj-1", 0 ],
													"source" : [ "obj-9", 0 ]
												}
											}
										]
									},
									"patching_rect" : [ 219.5, 704.100058734417, 97.0, 22.0 ],
									"text" : "p mIniCtlSmooth"
								}
							},
							{
								"box" : {
									"id" : "obj-11",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 11,
									"outlettype" : [ "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float" ],
									"patching_rect" : [ 177.0, 156.0, 466.8000040650368, 22.0 ],
									"text" : "unpack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-7",
									"maxclass" : "newobj",
									"numinlets" : 1,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 525.2671009848978, 446.0, 72.0, 22.0 ],
									"text" : "loadmess 4"
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 12.0,
									"id" : "obj-70",
									"maxclass" : "number",
									"numinlets" : 1,
									"numoutlets" : 2,
									"outlettype" : [ "", "bang" ],
									"parameter_enable" : 0,
									"patching_rect" : [ 525.2671009848978, 473.0, 50.0, 22.0 ]
								}
							},
							{
								"box" : {
									"fontname" : "Arial",
									"fontsize" : 9.0,
									"id" : "obj-56",
									"maxclass" : "message",
									"numinlets" : 2,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 525.2671009848978, 499.0, 99.0, 19.0 ],
									"text" : "param boundmode $1"
								}
							},
							{
								"box" : {
									"color" : [ 1.0, 0.890196, 0.090196, 1.0 ],
									"filename" : "td.rota.jxs",
									"fontname" : "Arial",
									"fontsize" : 9.0,
									"id" : "obj-6",
									"maxclass" : "newobj",
									"numinlets" : 2,
									"numoutlets" : 2,
									"outlettype" : [ "jit_gl_texture", "" ],
									"patching_rect" : [ 477.93996339438706, 541.0, 125.0, 19.0 ],
									"text" : "jit.gl.slab foo @file td.rota.jxs",
									"textfile" : {
										"filename" : "td.rota.jxs",
										"flags" : 0,
										"embed" : 0,
										"autowatch" : 1
									}
								}
							},
							{
								"box" : {
									"comment" : "Texture in",
									"id" : "obj-144",
									"index" : 1,
									"maxclass" : "inlet",
									"numinlets" : 0,
									"numoutlets" : 1,
									"outlettype" : [ "" ],
									"patching_rect" : [ 80.5, 141.80001831054688, 50.39996337890625, 50.39996337890625 ]
								}
							},
							{
								"box" : {
									"comment" : "",
									"id" : "obj-147",
									"index" : 1,
									"maxclass" : "outlet",
									"numinlets" : 1,
									"numoutlets" : 0,
									"patching_rect" : [ 389.72993056632106, 870.0, 25.0, 25.0 ]
								}
							}
						],
						"lines" : [
							{
								"patchline" : {
									"destination" : [ "obj-51", 5 ],
									"source" : [ "obj-1", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-10", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-164", 0 ],
									"source" : [ "obj-11", 5 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-31", 0 ],
									"source" : [ "obj-11", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-32", 0 ],
									"source" : [ "obj-11", 3 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-33", 0 ],
									"source" : [ "obj-11", 4 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-36", 0 ],
									"source" : [ "obj-11", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-51", 0 ],
									"source" : [ "obj-11", 8 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-93", 0 ],
									"source" : [ "obj-11", 6 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-14", 0 ],
									"source" : [ "obj-12", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-48", 0 ],
									"source" : [ "obj-121", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-130", 0 ],
									"source" : [ "obj-129", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-10", 2 ],
									"source" : [ "obj-13", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-47", 0 ],
									"source" : [ "obj-130", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-18", 0 ],
									"order" : 0,
									"source" : [ "obj-14", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"order" : 1,
									"source" : [ "obj-14", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-143", 0 ],
									"source" : [ "obj-142", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-47", 0 ],
									"source" : [ "obj-143", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-144", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-30", 1 ],
									"source" : [ "obj-15", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-30", 2 ],
									"order" : 1,
									"source" : [ "obj-16", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-46", 1 ],
									"order" : 0,
									"source" : [ "obj-16", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-21", 0 ],
									"source" : [ "obj-164", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-10", 3 ],
									"source" : [ "obj-17", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-88", 2 ],
									"source" : [ "obj-19", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-88", 3 ],
									"source" : [ "obj-20", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-28", 0 ],
									"source" : [ "obj-21", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-92", 2 ],
									"source" : [ "obj-22", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-147", 0 ],
									"source" : [ "obj-25", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-29", 0 ],
									"source" : [ "obj-26", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-8", 0 ],
									"source" : [ "obj-27", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-91", 2 ],
									"source" : [ "obj-28", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-29", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-130", 0 ],
									"source" : [ "obj-3", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-11", 0 ],
									"source" : [ "obj-30", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-26", 0 ],
									"source" : [ "obj-31", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-69", 0 ],
									"source" : [ "obj-32", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-72", 0 ],
									"source" : [ "obj-33", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-28", 1 ],
									"source" : [ "obj-35", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-27", 0 ],
									"source" : [ "obj-36", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-34", 0 ],
									"source" : [ "obj-39", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-4", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-34", 0 ],
									"order" : 1,
									"source" : [ "obj-40", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-39", 0 ],
									"order" : 0,
									"source" : [ "obj-40", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-34", 0 ],
									"order" : 1,
									"source" : [ "obj-41", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-39", 0 ],
									"order" : 0,
									"source" : [ "obj-41", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-40", 0 ],
									"source" : [ "obj-42", 1 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-41", 0 ],
									"source" : [ "obj-42", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-42", 0 ],
									"source" : [ "obj-43", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-32", 1 ],
									"order" : 2,
									"source" : [ "obj-44", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-33", 1 ],
									"order" : 0,
									"source" : [ "obj-44", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-55", 0 ],
									"order" : 1,
									"source" : [ "obj-44", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-12", 0 ],
									"source" : [ "obj-45", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-47", 0 ],
									"source" : [ "obj-48", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-49", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-3", 0 ],
									"source" : [ "obj-5", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-4", 0 ],
									"source" : [ "obj-50", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-50", 0 ],
									"source" : [ "obj-51", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-31", 3 ],
									"source" : [ "obj-52", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-31", 4 ],
									"order" : 0,
									"source" : [ "obj-54", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-52", 0 ],
									"order" : 1,
									"source" : [ "obj-54", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-32", 0 ],
									"order" : 1,
									"source" : [ "obj-55", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-33", 0 ],
									"order" : 0,
									"source" : [ "obj-55", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-56", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-68", 0 ],
									"source" : [ "obj-57", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-42", 0 ],
									"source" : [ "obj-58", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-78", 0 ],
									"source" : [ "obj-59", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-6", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-51", 4 ],
									"order" : 0,
									"source" : [ "obj-61", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-62", 0 ],
									"order" : 1,
									"source" : [ "obj-61", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-51", 3 ],
									"source" : [ "obj-62", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-36", 4 ],
									"order" : 0,
									"source" : [ "obj-64", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-65", 0 ],
									"order" : 1,
									"source" : [ "obj-64", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-36", 3 ],
									"source" : [ "obj-65", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-59", 0 ],
									"source" : [ "obj-68", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-19", 0 ],
									"source" : [ "obj-69", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-70", 0 ],
									"source" : [ "obj-7", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-56", 0 ],
									"source" : [ "obj-70", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-20", 0 ],
									"source" : [ "obj-72", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-31", 5 ],
									"source" : [ "obj-73", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-36", 5 ],
									"source" : [ "obj-76", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-59", 1 ],
									"source" : [ "obj-77", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-80", 0 ],
									"source" : [ "obj-78", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-25", 0 ],
									"source" : [ "obj-8", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-82", 0 ],
									"source" : [ "obj-80", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-30", 0 ],
									"source" : [ "obj-82", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-143", 0 ],
									"source" : [ "obj-87", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-88", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-87", 0 ],
									"source" : [ "obj-89", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-91", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-6", 0 ],
									"source" : [ "obj-92", 0 ]
								}
							},
							{
								"patchline" : {
									"destination" : [ "obj-22", 0 ],
									"source" : [ "obj-93", 0 ]
								}
							}
						],
						"boxgroups" : [
							{
								"boxes" : [
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
					},
					"patching_rect" : [ 688.0, 536.0, 168.0, 36.0 ],
					"text" : "p shaderfx",
					"textcolor" : [ 0.0, 1.0, 0.0, 1.0 ],
					"varname" : "shaderfx"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-75",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 244.0, 290.0, 72.0, 22.0 ],
					"text" : "loadmess 1"
				}
			},
			{
				"box" : {
					"attr" : "erase_color",
					"fontface" : 0,
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-55",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 324.0, 705.0, 211.0, 22.0 ]
				}
			},
			{
				"box" : {
					"id" : "obj-8",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 1091.0, 593.0, 20.0, 20.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_enum" : [ "off", "on" ],
							"parameter_longname" : "toggle[5]",
							"parameter_mmax" : 1,
							"parameter_modmode" : 0,
							"parameter_shortname" : "toggle[5]",
							"parameter_type" : 2
						}
					},
					"varname" : "toggle[5]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 12.0,
					"id" : "obj-9",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 1148.0, 593.0, 115.0, 22.0 ],
					"text" : "pak blend_enable 0"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 11.934731,
					"id" : "obj-142",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 698.0, 42.0, 50.0, 22.0 ],
					"text" : "fsaa $1"
				}
			},
			{
				"box" : {
					"id" : "obj-143",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 698.0, 18.0, 20.0, 20.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_enum" : [ "off", "on" ],
							"parameter_longname" : "toggle[4]",
							"parameter_mmax" : 1,
							"parameter_modmode" : 0,
							"parameter_shortname" : "toggle[4]",
							"parameter_type" : 2
						}
					},
					"varname" : "toggle[4]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 11.934731,
					"id" : "obj-131",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 566.0, 42.0, 50.0, 22.0 ],
					"text" : "sync $1"
				}
			},
			{
				"box" : {
					"id" : "obj-132",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 566.0, 18.0, 20.0, 20.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_enum" : [ "off", "on" ],
							"parameter_longname" : "toggle[3]",
							"parameter_mmax" : 1,
							"parameter_modmode" : 0,
							"parameter_shortname" : "toggle[3]",
							"parameter_type" : 2
						}
					},
					"varname" : "toggle[3]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-128",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 626.0, 44.0, 66.0, 19.0 ],
					"text" : "fsmenubar $1"
				}
			},
			{
				"box" : {
					"id" : "obj-129",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 626.0, 15.0, 20.5, 20.5 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_enum" : [ "off", "on" ],
							"parameter_longname" : "toggle[2]",
							"parameter_mmax" : 1,
							"parameter_modmode" : 0,
							"parameter_shortname" : "toggle[2]",
							"parameter_type" : 2
						}
					},
					"varname" : "toggle[2]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-19",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 249.0, 450.0, 61.0, 19.0 ],
					"text" : "s audiobang"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-22",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 416.0, 451.0, 91.0, 17.0 ],
					"text" : "window texture"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-32",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 4,
					"outlettype" : [ "int", "int", "int", "int" ],
					"patching_rect" : [ 281.3592230081558, 49.30097192525864, 40.0, 19.0 ],
					"text" : "key"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-33",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 260.0, 99.78640812635422, 70.0, 19.0 ],
					"text" : "fullscreen $1"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-34",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 3,
					"outlettype" : [ "bang", "bang", "" ],
					"patching_rect" : [ 462.0, 380.0, 164.0, 19.0 ],
					"text" : "sel 0 1"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-35",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 539.0, 400.0, 75.0, 19.0 ],
					"text" : "usetexture fst"
				}
			},
			{
				"box" : {
					"fontface" : 0,
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-36",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_gl_texture", "" ],
					"patching_rect" : [ 1178.0, 819.0, 499.0, 19.0 ],
					"text" : "jit.gl.texture foo @type long @name fst @dim 1920 1080 @filter none @erase_color 0. 0. 0. 1. @anisotropy 2 @filter linear"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-37",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 411.0, 473.0, 49.0, 19.0 ],
					"text" : "switch 2"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-38",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 388.0, 450.0, 27.0, 19.0 ],
					"text" : "+ 1"
				}
			},
			{
				"box" : {
					"id" : "obj-39",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 228.93203926086426, 53.184467017650604, 34.09999281167984, 34.09999281167984 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_enum" : [ "off", "on" ],
							"parameter_longname" : "toggle[1]",
							"parameter_mmax" : 1,
							"parameter_modmode" : 0,
							"parameter_shortname" : "toggle[1]",
							"parameter_type" : 2
						}
					},
					"varname" : "toggle[1]"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-40",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "" ],
					"patching_rect" : [ 281.3592230081558, 69.68932116031647, 38.0, 19.0 ],
					"text" : "sel 27"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-41",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 909.0, 544.0, 34.0, 19.0 ],
					"text" : "reset"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-43",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 909.0, 562.0, 80.0, 19.0 ],
					"text" : "jit.gl.handle foo"
				}
			},
			{
				"box" : {
					"fontface" : 0,
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-44",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_matrix", "" ],
					"patching_rect" : [ 859.0, 644.0, 1021.75, 19.0 ],
					"text" : "jit.gl.videoplane foo @automatic 0 @scale -1.78 1. 1. @color 1. 1. 1. 1. @blend_enable 1 @blend_mode 6 7 @position 0. 0. -0.4 @shadow_caster 0 @two_sided 0 @interp 0 @auto_material 0"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-45",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 462.0, 400.0, 76.0, 19.0 ],
					"text" : "usetexture dst"
				}
			},
			{
				"box" : {
					"fontface" : 0,
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-46",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "jit_gl_texture", "" ],
					"patching_rect" : [ 539.0, 459.0, 179.0, 19.0 ],
					"text" : "jit.gl.texture foo @name dst @dim 320 180"
				}
			},
			{
				"box" : {
					"id" : "obj-47",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 1,
					"patching_rect" : [ 244.0, 327.0, 15.0, 15.0 ],
					"saved_attribute_attributes" : {
						"valueof" : {
							"parameter_enum" : [ "off", "on" ],
							"parameter_longname" : "toggle",
							"parameter_mmax" : 1,
							"parameter_modmode" : 0,
							"parameter_shortname" : "toggle",
							"parameter_type" : 2
						}
					},
					"varname" : "toggle"
				}
			},
			{
				"box" : {
					"fontface" : 0,
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-48",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "" ],
					"patching_rect" : [ 533.0, 355.5, 494.0, 19.0 ],
					"text" : "jit.window foo @size 320 180 @fsaa 0 @sync 0 @doublebuffer 1 @fsmenubar 0 @floating 1 @doublebuffer 0 @shared 0"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-49",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "" ],
					"patching_rect" : [ 178.0, 805.0, 653.0, 19.0 ],
					"text" : "jit.gl.render foo @erase_color 0 0 0 1. @blend_enable 1 @blend_mode 6 7 @automatic 0 @depth_enable 0 @shadow_caster 0 @auto_material 0 @two_sided 0"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-50",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 8,
					"outlettype" : [ "to_texture", "bang", "bang", "bang", "bang", "bang", "bang", "erase" ],
					"patching_rect" : [ 244.0, 373.0, 124.0, 19.0 ],
					"text" : "t to_texture b b b b b b erase"
				}
			},
			{
				"box" : {
					"fontname" : "Arial",
					"fontsize" : 9.0,
					"id" : "obj-51",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 244.0, 348.0, 99.0, 19.0 ],
					"text" : "metro @interval 60 hz"
				}
			},
			{
				"box" : {
					"attr" : "blend",
					"id" : "obj-127",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 324.0, 676.0, 246.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "pos",
					"id" : "obj-17",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 567.0, 78.0, 227.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "shared",
					"id" : "obj-18",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 564.0, 105.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "clamp",
					"id" : "obj-28",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 564.0, 137.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "colormode",
					"id" : "obj-68",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 564.0, 167.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "colormode",
					"id" : "obj-70",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 564.0, 196.0, 150.0, 22.0 ],
					"text_width" : 121.0
				}
			},
			{
				"box" : {
					"attr" : "anisotropy",
					"id" : "obj-100",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 800.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "dim",
					"id" : "obj-102",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 692.0, 262.00000166893005, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "correction",
					"id" : "obj-134",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 746.0, 217.00000059604645, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "filter",
					"id" : "obj-136",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 772.0, 217.00000059604645, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "texture_mode",
					"id" : "obj-153",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 722.0, 217.00000059604645, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "thru",
					"id" : "obj-154",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 827.0, 217.00000059604645, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "type",
					"id" : "obj-158",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 857.0, 217.00000059604645, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "automatic",
					"id" : "obj-156",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 324.0, 737.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "depth_write",
					"id" : "obj-168",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 324.0, 763.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "depth_enable",
					"id" : "obj-171",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 577.0, 676.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "lighting_enable",
					"id" : "obj-172",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 577.0, 707.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "lens_angle",
					"id" : "obj-173",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 577.0, 740.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "size",
					"id" : "obj-175",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 564.0, 229.0, 230.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "camera",
					"id" : "obj-178",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 577.0, 767.0, 246.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "antialias",
					"id" : "obj-30",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 500.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "interp",
					"id" : "obj-118",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 898.0, 468.0, 150.0, 22.0 ]
				}
			},
			{
				"box" : {
					"attr" : "border",
					"id" : "obj-164",
					"maxclass" : "attrui",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 733.0, 263.0, 150.0, 22.0 ]
				}
			}
		],
		"lines" : [
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-1", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-10", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-100", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-105", 4 ],
					"source" : [ "obj-101", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-102", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-103", 0 ],
					"source" : [ "obj-104", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-105", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-107", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-108", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-109", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-11", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-110", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-111", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-112", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-113", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-114", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-115", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-116", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-12", 1 ],
					"source" : [ "obj-117", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-118", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-84", 0 ],
					"source" : [ "obj-119", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-12", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-12", 2 ],
					"source" : [ "obj-120", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-12", 3 ],
					"source" : [ "obj-121", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-60", 0 ],
					"order" : 0,
					"source" : [ "obj-122", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-78", 0 ],
					"order" : 1,
					"source" : [ "obj-122", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-160", 0 ],
					"order" : 0,
					"source" : [ "obj-123", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-46", 0 ],
					"order" : 1,
					"source" : [ "obj-123", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-52", 0 ],
					"source" : [ "obj-124", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-52", 0 ],
					"source" : [ "obj-125", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-126", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-127", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-128", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-128", 0 ],
					"source" : [ "obj-129", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-130", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-131", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-131", 0 ],
					"source" : [ "obj-132", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-170", 0 ],
					"source" : [ "obj-133", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-134", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-135", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-136", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-144", 0 ],
					"order" : 0,
					"source" : [ "obj-137", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"order" : 1,
					"source" : [ "obj-137", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-139", 0 ],
					"source" : [ "obj-138", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-139", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-14", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-140", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-141", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-142", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-142", 0 ],
					"source" : [ "obj-143", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-133", 0 ],
					"source" : [ "obj-144", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-170", 0 ],
					"source" : [ "obj-145", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-98", 0 ],
					"source" : [ "obj-146", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-147", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-148", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-145", 0 ],
					"source" : [ "obj-149", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-180", 1 ],
					"source" : [ "obj-15", 2 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-180", 0 ],
					"source" : [ "obj-15", 1 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-203", 0 ],
					"source" : [ "obj-150", 1 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-332", 0 ],
					"source" : [ "obj-150", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-151", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-174", 0 ],
					"source" : [ "obj-152", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-153", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-154", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-156", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-157", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-158", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-210", 0 ],
					"source" : [ "obj-16", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-137", 0 ],
					"source" : [ "obj-160", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-163", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-164", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-166", 1 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-152", 0 ],
					"order" : 1,
					"source" : [ "obj-167", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-166", 1 ],
					"order" : 0,
					"source" : [ "obj-167", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-168", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-17", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-167", 0 ],
					"source" : [ "obj-170", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-171", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-172", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-173", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-161", 0 ],
					"order" : 0,
					"source" : [ "obj-174", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-166", 1 ],
					"order" : 1,
					"source" : [ "obj-174", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-175", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-178", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-18", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-181", 0 ],
					"order" : 0,
					"source" : [ "obj-180", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-212", 0 ],
					"order" : 1,
					"source" : [ "obj-180", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"source" : [ "obj-186", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-15", 0 ],
					"source" : [ "obj-187", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-78", 1 ],
					"source" : [ "obj-193", 1 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-78", 0 ],
					"source" : [ "obj-193", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-36", 0 ],
					"midpoints" : [ 418.5, 606.6999918818474, 1187.5, 606.6999918818474 ],
					"source" : [ "obj-194", 1 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-46", 0 ],
					"source" : [ "obj-194", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-2", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-25", 1 ],
					"source" : [ "obj-20", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-21", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-51", 1 ],
					"source" : [ "obj-211", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-193", 0 ],
					"source" : [ "obj-213", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-216", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-25", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-104", 0 ],
					"source" : [ "obj-26", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-27", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-28", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-20", 0 ],
					"source" : [ "obj-3", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-30", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-60", 0 ],
					"source" : [ "obj-31", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-40", 0 ],
					"source" : [ "obj-32", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-53", 0 ],
					"source" : [ "obj-33", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-150", 0 ],
					"source" : [ "obj-332", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-35", 0 ],
					"source" : [ "obj-34", 1 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-45", 0 ],
					"source" : [ "obj-34", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-149", 0 ],
					"order" : 0,
					"source" : [ "obj-35", 0 ]
				}
			},
			{
				"patchline" : {
					"color" : [ 0.156863, 0.8, 0.54902, 1.0 ],
					"destination" : [ "obj-49", 0 ],
					"midpoints" : [ 548.5, 426.6999918818474, 187.5, 426.6999918818474 ],
					"order" : 1,
					"source" : [ "obj-35", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-37", 2 ],
					"midpoints" : [ 1187.5, 435.6999918818474, 450.5, 435.6999918818474 ],
					"source" : [ "obj-36", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-148", 0 ],
					"source" : [ "obj-37", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-37", 0 ],
					"source" : [ "obj-38", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-194", 0 ],
					"order" : 1,
					"source" : [ "obj-39", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-33", 0 ],
					"order" : 3,
					"source" : [ "obj-39", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-34", 0 ],
					"midpoints" : [ 238.43203926086426, 191.69999188184738, 471.5, 191.69999188184738 ],
					"order" : 0,
					"source" : [ "obj-39", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-38", 0 ],
					"midpoints" : [ 238.43203926086426, 170.69999188184738, 397.5, 170.69999188184738 ],
					"order" : 2,
					"source" : [ "obj-39", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-90", 0 ],
					"source" : [ "obj-4", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-39", 0 ],
					"source" : [ "obj-40", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-43", 0 ],
					"source" : [ "obj-41", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-60", 1 ],
					"order" : 0,
					"source" : [ "obj-42", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-63", 0 ],
					"order" : 1,
					"source" : [ "obj-42", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"midpoints" : [ 918.5, 596.6999918818474, 868.5, 596.6999918818474 ],
					"source" : [ "obj-43", 0 ]
				}
			},
			{
				"patchline" : {
					"color" : [ 0.156863, 0.8, 0.54902, 1.0 ],
					"destination" : [ "obj-49", 0 ],
					"midpoints" : [ 471.5, 426.6999918818474, 187.5, 426.6999918818474 ],
					"source" : [ "obj-45", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-37", 1 ],
					"source" : [ "obj-46", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-51", 0 ],
					"source" : [ "obj-47", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-106", 0 ],
					"source" : [ "obj-49", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-8", 0 ],
					"source" : [ "obj-5", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-19", 0 ],
					"source" : [ "obj-50", 4 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-194", 1 ],
					"source" : [ "obj-50", 6 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-23", 0 ],
					"source" : [ "obj-50", 5 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-29", 0 ],
					"source" : [ "obj-50", 3 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"midpoints" : [ 283.5, 411.6999918818474, 801.750000834465, 411.6999918818474, 801.750000834465, 501.6999918818474, 868.5, 501.6999918818474 ],
					"source" : [ "obj-50", 2 ]
				}
			},
			{
				"patchline" : {
					"color" : [ 0.156863, 0.8, 0.54902, 1.0 ],
					"destination" : [ "obj-49", 0 ],
					"midpoints" : [ 358.5, 426.6999918818474, 187.5, 426.6999918818474 ],
					"source" : [ "obj-50", 7 ]
				}
			},
			{
				"patchline" : {
					"color" : [ 0.156863, 0.8, 0.54902, 1.0 ],
					"destination" : [ "obj-49", 0 ],
					"midpoints" : [ 268.5, 426.6999918818474, 187.5, 426.6999918818474 ],
					"source" : [ "obj-50", 1 ]
				}
			},
			{
				"patchline" : {
					"color" : [ 0.156863, 0.8, 0.54902, 1.0 ],
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-50", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-50", 0 ],
					"source" : [ "obj-51", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-16", 1 ],
					"source" : [ "obj-52", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-54", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-55", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-49", 0 ],
					"source" : [ "obj-56", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-56", 4 ],
					"source" : [ "obj-57", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-332", 0 ],
					"source" : [ "obj-58", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-52", 0 ],
					"source" : [ "obj-59", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-86", 0 ],
					"source" : [ "obj-60", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-61", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-61", 0 ],
					"source" : [ "obj-62", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-60", 0 ],
					"source" : [ "obj-63", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-52", 0 ],
					"source" : [ "obj-65", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-52", 0 ],
					"source" : [ "obj-66", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-93", 0 ],
					"source" : [ "obj-67", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-68", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-72", 1 ],
					"source" : [ "obj-69", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-7", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-48", 0 ],
					"source" : [ "obj-70", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-72", 2 ],
					"source" : [ "obj-71", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-72", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-77", 3 ],
					"source" : [ "obj-73", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-77", 1 ],
					"source" : [ "obj-74", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-47", 0 ],
					"source" : [ "obj-75", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-77", 2 ],
					"source" : [ "obj-76", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-77", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-74", 0 ],
					"source" : [ "obj-78", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-76", 0 ],
					"order" : 0,
					"source" : [ "obj-79", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-78", 0 ],
					"order" : 1,
					"source" : [ "obj-79", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-9", 1 ],
					"source" : [ "obj-8", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-79", 0 ],
					"source" : [ "obj-80", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-67", 0 ],
					"source" : [ "obj-81", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-117", 0 ],
					"order" : 2,
					"source" : [ "obj-82", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-120", 0 ],
					"order" : 1,
					"source" : [ "obj-82", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-121", 0 ],
					"order" : 0,
					"source" : [ "obj-82", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-56", 4 ],
					"source" : [ "obj-84", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-78", 1 ],
					"source" : [ "obj-86", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-39", 0 ],
					"source" : [ "obj-87", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-90", 2 ],
					"source" : [ "obj-88", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-90", 1 ],
					"source" : [ "obj-89", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-9", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-90", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-44", 0 ],
					"source" : [ "obj-91", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-91", 4 ],
					"source" : [ "obj-92", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-72", 3 ],
					"source" : [ "obj-93", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-52", 0 ],
					"source" : [ "obj-97", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-93", 1 ],
					"source" : [ "obj-98", 1 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-93", 0 ],
					"source" : [ "obj-98", 0 ]
				}
			},
			{
				"patchline" : {
					"destination" : [ "obj-185", 0 ],
					"source" : [ "obj-99", 0 ]
				}
			}
		],
		"parameters" : {
			"obj-101" : [ "number[160]", "number[15]", 0 ],
			"obj-104" : [ "number[19]", "number[19]", 0 ],
			"obj-117" : [ "number[32]", "number[32]", 0 ],
			"obj-120" : [ "number[62]", "number[32]", 0 ],
			"obj-121" : [ "number[63]", "number[32]", 0 ],
			"obj-129" : [ "toggle[2]", "toggle[2]", 0 ],
			"obj-132" : [ "toggle[3]", "toggle[3]", 0 ],
			"obj-143" : [ "toggle[4]", "toggle[4]", 0 ],
			"obj-148::obj-121" : [ "Offset[1]", "Brightness", 0 ],
			"obj-148::obj-129" : [ "contrast[3]", "Contrast", 0 ],
			"obj-148::obj-142" : [ "saturation[4]", "Saturation", 0 ],
			"obj-148::obj-2::obj-121" : [ "Offset[4]", "Brightness", 0 ],
			"obj-148::obj-2::obj-129" : [ "contrast[2]", "Contrast", 0 ],
			"obj-148::obj-2::obj-142" : [ "saturation[3]", "Saturation", 0 ],
			"obj-150::obj-100" : [ "number[122]", "number[122]", 0 ],
			"obj-150::obj-109" : [ "flonum[2]", "flonum", 0 ],
			"obj-150::obj-110" : [ "number[47]", "number[47]", 0 ],
			"obj-150::obj-111" : [ "number[46]", "number[46]", 0 ],
			"obj-150::obj-116" : [ "toggle[9]", "toggle[9]", 0 ],
			"obj-150::obj-117" : [ "toggle[24]", "toggle[24]", 0 ],
			"obj-150::obj-13" : [ "toggle[41]", "toggle[41]", 0 ],
			"obj-150::obj-134" : [ "number[159]", "number[122]", 0 ],
			"obj-150::obj-137" : [ "toggle[46]", "toggle[44]", 0 ],
			"obj-150::obj-148" : [ "toggle[48]", "toggle[43]", 0 ],
			"obj-150::obj-154" : [ "number[82]", "number[82]", 0 ],
			"obj-150::obj-155" : [ "number[81]", "number[81]", 0 ],
			"obj-150::obj-156" : [ "number[80]", "number[80]", 0 ],
			"obj-150::obj-159" : [ "toggle[49]", "toggle[42]", 0 ],
			"obj-150::obj-189" : [ "swatch[6]", "swatch", 0 ],
			"obj-150::obj-193" : [ "toggle[52]", "toggle[9]", 0 ],
			"obj-150::obj-195" : [ "number[144]", "number[47]", 0 ],
			"obj-150::obj-196" : [ "number[145]", "number[46]", 0 ],
			"obj-150::obj-20" : [ "toggle[42]", "toggle[42]", 0 ],
			"obj-150::obj-202" : [ "number[146]", "number[38]", 0 ],
			"obj-150::obj-203" : [ "number[147]", "number[37]", 0 ],
			"obj-150::obj-204" : [ "number[148]", "number[36]", 0 ],
			"obj-150::obj-215" : [ "slider[19]", "slider[17]", 0 ],
			"obj-150::obj-216" : [ "number[13]", "number[8]", 0 ],
			"obj-150::obj-232" : [ "swatch[7]", "swatch", 0 ],
			"obj-150::obj-236" : [ "swatch[4]", "swatch", 0 ],
			"obj-150::obj-238" : [ "swatch[5]", "swatch", 0 ],
			"obj-150::obj-241" : [ "toggle[53]", "toggle[53]", 0 ],
			"obj-150::obj-247" : [ "number[35]", "number[35]", 0 ],
			"obj-150::obj-249" : [ "number[153]", "number[153]", 0 ],
			"obj-150::obj-257" : [ "number[154]", "number[154]", 0 ],
			"obj-150::obj-258" : [ "number[155]", "number[155]", 0 ],
			"obj-150::obj-276" : [ "number[150]", "number[38]", 0 ],
			"obj-150::obj-277" : [ "number[151]", "number[37]", 0 ],
			"obj-150::obj-278" : [ "number[152]", "number[36]", 0 ],
			"obj-150::obj-287" : [ "toggle[14]", "toggle[14]", 0 ],
			"obj-150::obj-293" : [ "number[125]", "number[125]", 0 ],
			"obj-150::obj-294" : [ "number[126]", "number[125]", 0 ],
			"obj-150::obj-295" : [ "number[116]", "number[125]", 0 ],
			"obj-150::obj-296" : [ "number[127]", "number[125]", 0 ],
			"obj-150::obj-297" : [ "number[96]", "number[125]", 0 ],
			"obj-150::obj-298" : [ "number[100]", "number[125]", 0 ],
			"obj-150::obj-300" : [ "number[156]", "number[125]", 0 ],
			"obj-150::obj-301" : [ "number[157]", "number[125]", 0 ],
			"obj-150::obj-302" : [ "number[158]", "number[125]", 0 ],
			"obj-150::obj-307" : [ "number[45]", "number[45]", 0 ],
			"obj-150::obj-311" : [ "slider[17]", "slider[17]", 0 ],
			"obj-150::obj-313" : [ "slider[1]", "slider[1]", 0 ],
			"obj-150::obj-319" : [ "number[170]", "number[170]", 0 ],
			"obj-150::obj-320" : [ "number[21]", "number[21]", 0 ],
			"obj-150::obj-321" : [ "number[53]", "number[53]", 0 ],
			"obj-150::obj-324" : [ "number[167]", "number[167]", 0 ],
			"obj-150::obj-329" : [ "slider[2]", "slider[2]", 0 ],
			"obj-150::obj-338" : [ "slider[18]", "slider[17]", 0 ],
			"obj-150::obj-339" : [ "toggle[15]", "toggle[15]", 0 ],
			"obj-150::obj-344" : [ "toggle[50]", "toggle[50]", 0 ],
			"obj-150::obj-357" : [ "toggle[55]", "toggle[50]", 0 ],
			"obj-150::obj-359" : [ "number[169]", "number[69]", 0 ],
			"obj-150::obj-36" : [ "number[83]", "number[53]", 0 ],
			"obj-150::obj-37" : [ "number[91]", "number[52]", 0 ],
			"obj-150::obj-372" : [ "toggle[56]", "toggle[56]", 0 ],
			"obj-150::obj-38" : [ "number[92]", "number[51]", 0 ],
			"obj-150::obj-42" : [ "button[8]", "button[8]", 0 ],
			"obj-150::obj-43" : [ "toggle[44]", "toggle[44]", 0 ],
			"obj-150::obj-45" : [ "toggle[43]", "toggle[43]", 0 ],
			"obj-150::obj-6" : [ "number[38]", "number[38]", 0 ],
			"obj-150::obj-7" : [ "number[36]", "number[36]", 0 ],
			"obj-150::obj-74" : [ "number[37]", "number[37]", 0 ],
			"obj-150::obj-76" : [ "flonum", "flonum", 0 ],
			"obj-150::obj-80" : [ "flonum[1]", "flonum", 0 ],
			"obj-150::obj-81" : [ "number[50]", "number[50]", 0 ],
			"obj-150::obj-82" : [ "number[49]", "number[49]", 0 ],
			"obj-150::obj-83" : [ "number[48]", "number[48]", 0 ],
			"obj-150::obj-96" : [ "number[69]", "number[69]", 0 ],
			"obj-150::obj-98" : [ "number[123]", "number[69]", 0 ],
			"obj-150::obj-99" : [ "number[124]", "number[122]", 0 ],
			"obj-181" : [ "number[117]", "number[117]", 0 ],
			"obj-20" : [ "toggle[6]", "toggle[6]", 0 ],
			"obj-332" : [ "Audio Gain", "Audio Gain", 0 ],
			"obj-39" : [ "toggle[1]", "toggle[1]", 0 ],
			"obj-47" : [ "toggle", "toggle", 0 ],
			"obj-52" : [ "number[12]", "number[12]", 0 ],
			"obj-57" : [ "number[15]", "number[15]", 0 ],
			"obj-62" : [ "toggle[8]", "toggle[8]", 0 ],
			"obj-67" : [ "number[25]", "number[25]", 0 ],
			"obj-69" : [ "number[24]", "number[24]", 0 ],
			"obj-6::obj-1" : [ "toggle[20]", "toggle[20]", 0 ],
			"obj-6::obj-105" : [ "number[119]", "number[5]", 0 ],
			"obj-6::obj-107" : [ "toggle[45]", "toggle[45]", 0 ],
			"obj-6::obj-108" : [ "number[120]", "number[5]", 0 ],
			"obj-6::obj-110" : [ "button", "button", 0 ],
			"obj-6::obj-111" : [ "button[1]", "button", 0 ],
			"obj-6::obj-117" : [ "button[18]", "button[2]", 0 ],
			"obj-6::obj-133" : [ "toggle[54]", "toggle[54]", 0 ],
			"obj-6::obj-137" : [ "number", "number", 0 ],
			"obj-6::obj-140" : [ "slider[26]", "slider", 0 ],
			"obj-6::obj-146" : [ "toggle[25]", "toggle[25]", 0 ],
			"obj-6::obj-153" : [ "toggle[13]", "toggle[21]", 0 ],
			"obj-6::obj-162" : [ "toggle[37]", "toggle[37]", 0 ],
			"obj-6::obj-163" : [ "button[11]", "button[9]", 0 ],
			"obj-6::obj-166" : [ "toggle[26]", "toggle[14]", 0 ],
			"obj-6::obj-17" : [ "fbhue", "fbhue", 0 ],
			"obj-6::obj-175" : [ "button[2]", "button[2]", 0 ],
			"obj-6::obj-176" : [ "button[3]", "button[2]", 0 ],
			"obj-6::obj-177" : [ "button[4]", "button[2]", 0 ],
			"obj-6::obj-178" : [ "button[5]", "button[2]", 0 ],
			"obj-6::obj-18" : [ "slider[7]", "slider", 0 ],
			"obj-6::obj-192" : [ "number[114]", "number[114]", 0 ],
			"obj-6::obj-196" : [ "number[115]", "number[115]", 0 ],
			"obj-6::obj-198" : [ "swatch[3]", "swatch", 0 ],
			"obj-6::obj-209" : [ "number[93]", "number[6]", 0 ],
			"obj-6::obj-210" : [ "number[98]", "number[5]", 0 ],
			"obj-6::obj-211" : [ "number[110]", "number[4]", 0 ],
			"obj-6::obj-212" : [ "number[66]", "number[3]", 0 ],
			"obj-6::obj-213" : [ "number[94]", "number[2]", 0 ],
			"obj-6::obj-214" : [ "number[67]", "number[1]", 0 ],
			"obj-6::obj-215" : [ "number[84]", "number", 0 ],
			"obj-6::obj-217" : [ "number[113]", "number[6]", 0 ],
			"obj-6::obj-218" : [ "number[68]", "number[6]", 0 ],
			"obj-6::obj-23" : [ "toggle[19]", "toggle[19]", 0 ],
			"obj-6::obj-25" : [ "number[65]", "number[65]", 0 ],
			"obj-6::obj-26" : [ "slider[4]", "slider", 0 ],
			"obj-6::obj-27" : [ "slider[11]", "slider", 0 ],
			"obj-6::obj-30" : [ "slider[6]", "slider", 0 ],
			"obj-6::obj-50" : [ "fbhue[1]", "fbhue", 0 ],
			"obj-6::obj-55" : [ "toggle[22]", "toggle[21]", 0 ],
			"obj-6::obj-56" : [ "slider[10]", "slider", 0 ],
			"obj-6::obj-57" : [ "number[9]", "number[9]", 0 ],
			"obj-6::obj-63" : [ "button[17]", "button[2]", 0 ],
			"obj-6::obj-74" : [ "slider[14]", "slider", 0 ],
			"obj-6::obj-75" : [ "slider[15]", "slider", 0 ],
			"obj-6::obj-83" : [ "slider", "slider", 0 ],
			"obj-6::obj-93" : [ "toggle[28]", "toggle[28]", 0 ],
			"obj-71" : [ "number[23]", "number[23]", 0 ],
			"obj-73" : [ "number[28]", "number[28]", 0 ],
			"obj-74" : [ "number[27]", "number[27]", 0 ],
			"obj-76" : [ "number[26]", "number[26]", 0 ],
			"obj-79" : [ "number[29]", "number[29]", 0 ],
			"obj-8" : [ "toggle[5]", "toggle[5]", 0 ],
			"obj-83::obj-108" : [ "umenu[1]", "umenu[1]", 0 ],
			"obj-83::obj-11" : [ "button[15]", "button[15]", 0 ],
			"obj-83::obj-119" : [ "toggle[32]", "toggle[32]", 0 ],
			"obj-83::obj-121" : [ "toggle[47]", "toggle[11]", 0 ],
			"obj-83::obj-126" : [ "toggle[33]", "toggle[33]", 0 ],
			"obj-83::obj-127" : [ "toggle[34]", "toggle[34]", 0 ],
			"obj-83::obj-133::obj-14" : [ "live.toggle[3]", "live.toggle[2]", 0 ],
			"obj-83::obj-133::obj-19" : [ "umenu[11]", "umenu", 0 ],
			"obj-83::obj-133::obj-22" : [ "range[12]", "range", 0 ],
			"obj-83::obj-133::obj-5::obj-23" : [ "gswitch2[5]", "gswitch2", 0 ],
			"obj-83::obj-134" : [ "number[2]", "number[2]", 0 ],
			"obj-83::obj-135" : [ "number[99]", "number[2]", 0 ],
			"obj-83::obj-142" : [ "number[95]", "number[2]", 0 ],
			"obj-83::obj-147::obj-45" : [ "swatch[1]", "swatch", 0 ],
			"obj-83::obj-14::obj-30" : [ "pictctrl[2]", "pictctrl[1]", 0 ],
			"obj-83::obj-14::obj-41" : [ "pictctrl[1]", "pictctrl[1]", 0 ],
			"obj-83::obj-14::obj-5" : [ "Menu[1]", "Menu", 0 ],
			"obj-83::obj-15" : [ "toggle[36]", "toggle[36]", 0 ],
			"obj-83::obj-150" : [ "toggle[51]", "toggle[51]", 0 ],
			"obj-83::obj-153::obj-11" : [ "range[15]", "range", 0 ],
			"obj-83::obj-153::obj-32" : [ "pictctrl[18]", "pictctrl[1]", 0 ],
			"obj-83::obj-153::obj-39::obj-23" : [ "gswitch2[12]", "gswitch2", 0 ],
			"obj-83::obj-153::obj-48" : [ "Fade[2]", "Fade", 0 ],
			"obj-83::obj-153::obj-53" : [ "pictctrl[17]", "pictctrl[1]", 0 ],
			"obj-83::obj-153::obj-56::obj-23" : [ "gswitch2[11]", "gswitch2", 0 ],
			"obj-83::obj-153::obj-78" : [ "Luminance[2]", "Luminance", 0 ],
			"obj-83::obj-153::obj-85" : [ "pictctrl[16]", "pictctrl[1]", 0 ],
			"obj-83::obj-153::obj-9" : [ "Tolerance[3]", "Tolerance", 0 ],
			"obj-83::obj-158" : [ "toggle[10]", "toggle[10]", 0 ],
			"obj-83::obj-160" : [ "toggle[38]", "toggle[38]", 0 ],
			"obj-83::obj-179::obj-14" : [ "live.toggle[4]", "live.toggle[2]", 0 ],
			"obj-83::obj-179::obj-19" : [ "umenu[3]", "umenu", 0 ],
			"obj-83::obj-179::obj-22" : [ "range[7]", "range", 0 ],
			"obj-83::obj-179::obj-5::obj-23" : [ "gswitch2[6]", "gswitch2", 0 ],
			"obj-83::obj-180" : [ "toggle[7]", "toggle[7]", 0 ],
			"obj-83::obj-182" : [ "button[7]", "button[7]", 0 ],
			"obj-83::obj-183" : [ "toggle[17]", "toggle[17]", 0 ],
			"obj-83::obj-203" : [ "toggle[57]", "toggle[57]", 0 ],
			"obj-83::obj-204" : [ "button[9]", "button[9]", 0 ],
			"obj-83::obj-207" : [ "toggle[12]", "toggle[12]", 0 ],
			"obj-83::obj-226" : [ "slider[12]", "slider[12]", 0 ],
			"obj-83::obj-227" : [ "slider[13]", "slider[12]", 0 ],
			"obj-83::obj-229" : [ "slider[16]", "slider[12]", 0 ],
			"obj-83::obj-232" : [ "number[51]", "number[2]", 0 ],
			"obj-83::obj-233" : [ "number[52]", "number[2]", 0 ],
			"obj-83::obj-24" : [ "toggle[16]", "toggle[16]", 0 ],
			"obj-83::obj-252::obj-1" : [ "Blendmode ", "Blendmode ", 0 ],
			"obj-83::obj-252::obj-17::obj-23" : [ "gswitch2[15]", "gswitch2", 0 ],
			"obj-83::obj-252::obj-2" : [ "range[1]", "range", 0 ],
			"obj-83::obj-252::obj-22" : [ "pictctrl[15]", "pictctrl[1]", 0 ],
			"obj-83::obj-252::obj-30::obj-23" : [ "gswitch2[16]", "gswitch2", 0 ],
			"obj-83::obj-252::obj-42" : [ "pictctrl[19]", "pictctrl[1]", 0 ],
			"obj-83::obj-252::obj-56::obj-23" : [ "gswitch2[8]", "gswitch2", 0 ],
			"obj-83::obj-252::obj-65" : [ "Alphacontrast ", "Alphacontrast ", 0 ],
			"obj-83::obj-260" : [ "slider[20]", "slider[3]", 0 ],
			"obj-83::obj-267" : [ "slider[21]", "slider[3]", 0 ],
			"obj-83::obj-268" : [ "slider[22]", "slider[3]", 0 ],
			"obj-83::obj-26::obj-11" : [ "range[4]", "range", 0 ],
			"obj-83::obj-26::obj-15" : [ "pictctrl[3]", "pictctrl[1]", 0 ],
			"obj-83::obj-26::obj-22" : [ "pictctrl[6]", "pictctrl[1]", 0 ],
			"obj-83::obj-26::obj-28" : [ "pictctrl[7]", "pictctrl[1]", 0 ],
			"obj-83::obj-26::obj-29" : [ "pictctrl[11]", "pictctrl[1]", 0 ],
			"obj-83::obj-26::obj-32" : [ "pictctrl[4]", "pictctrl[1]", 0 ],
			"obj-83::obj-26::obj-33" : [ "live.toggle[2]", "live.toggle", 0 ],
			"obj-83::obj-26::obj-37" : [ "pictctrl[9]", "pictctrl[1]", 0 ],
			"obj-83::obj-26::obj-39::obj-23" : [ "gswitch2[3]", "gswitch2", 0 ],
			"obj-83::obj-26::obj-45" : [ "swatch", "swatch", 0 ],
			"obj-83::obj-26::obj-48" : [ "control", "Fade", 0 ],
			"obj-83::obj-26::obj-53" : [ "pictctrl[5]", "pictctrl[1]", 0 ],
			"obj-83::obj-26::obj-56::obj-23" : [ "gswitch2[2]", "gswitch2", 0 ],
			"obj-83::obj-26::obj-59" : [ "pictctrl[10]", "pictctrl[1]", 0 ],
			"obj-83::obj-26::obj-9" : [ "Tolerance[1]", "Tolerance", 0 ],
			"obj-83::obj-270" : [ "number[8]", "number[8]", 0 ],
			"obj-83::obj-271" : [ "number[70]", "number[8]", 0 ],
			"obj-83::obj-272" : [ "number[71]", "number[8]", 0 ],
			"obj-83::obj-273" : [ "number[72]", "number[8]", 0 ],
			"obj-83::obj-274" : [ "number[73]", "number[8]", 0 ],
			"obj-83::obj-275" : [ "number[129]", "number[8]", 0 ],
			"obj-83::obj-283" : [ "swatch[8]", "swatch[2]", 0 ],
			"obj-83::obj-285" : [ "number[130]", "number[8]", 0 ],
			"obj-83::obj-286" : [ "number[131]", "number[8]", 0 ],
			"obj-83::obj-300" : [ "button[12]", "button[12]", 0 ],
			"obj-83::obj-305" : [ "toggle[58]", "toggle[11]", 0 ],
			"obj-83::obj-308" : [ "toggle[59]", "toggle[59]", 0 ],
			"obj-83::obj-310" : [ "button[13]", "button[13]", 0 ],
			"obj-83::obj-316" : [ "toggle[18]", "toggle[18]", 0 ],
			"obj-83::obj-317::obj-119" : [ "Brightness[1]", "Brightness", 0 ],
			"obj-83::obj-317::obj-127" : [ "Contrast[1]", "Contrast", 0 ],
			"obj-83::obj-317::obj-140" : [ "Saturation[1]", "Saturation", 0 ],
			"obj-83::obj-317::obj-56::obj-23" : [ "gswitch2[10]", "gswitch2", 0 ],
			"obj-83::obj-317::obj-6" : [ "range[9]", "range", 0 ],
			"obj-83::obj-319" : [ "toggle[60]", "toggle[60]", 0 ],
			"obj-83::obj-322" : [ "slider[23]", "slider[3]", 0 ],
			"obj-83::obj-325" : [ "slider[24]", "slider[3]", 0 ],
			"obj-83::obj-326" : [ "slider[25]", "slider[3]", 0 ],
			"obj-83::obj-41" : [ "umenu[2]", "umenu[2]", 0 ],
			"obj-83::obj-48::obj-11" : [ "range[8]", "range", 0 ],
			"obj-83::obj-48::obj-32" : [ "pictctrl[12]", "pictctrl[1]", 0 ],
			"obj-83::obj-48::obj-39::obj-23" : [ "gswitch2[7]", "gswitch2", 0 ],
			"obj-83::obj-48::obj-48" : [ "Fade[1]", "Fade", 0 ],
			"obj-83::obj-48::obj-53" : [ "pictctrl[13]", "pictctrl[1]", 0 ],
			"obj-83::obj-48::obj-56::obj-23" : [ "gswitch2[4]", "gswitch2", 0 ],
			"obj-83::obj-48::obj-78" : [ "Luminance[1]", "Luminance", 0 ],
			"obj-83::obj-48::obj-85" : [ "pictctrl[8]", "pictctrl[1]", 0 ],
			"obj-83::obj-48::obj-9" : [ "Tolerance[2]", "Tolerance", 0 ],
			"obj-83::obj-53" : [ "button[6]", "button[6]", 0 ],
			"obj-83::obj-55" : [ "swatch[2]", "swatch[2]", 0 ],
			"obj-83::obj-57" : [ "number[39]", "number[39]", 0 ],
			"obj-83::obj-59" : [ "umenu", "umenu", 0 ],
			"obj-83::obj-61" : [ "number[1]", "number[1]", 0 ],
			"obj-83::obj-67" : [ "button[16]", "button[16]", 0 ],
			"obj-83::obj-75" : [ "button[14]", "button[14]", 0 ],
			"obj-83::obj-81" : [ "Luminance", "Luminance", 0 ],
			"obj-83::obj-84" : [ "Fade", "Fade", 0 ],
			"obj-83::obj-86" : [ "Tolerance", "Tolerance", 0 ],
			"obj-83::obj-87" : [ "toggle[31]", "toggle[31]", 0 ],
			"obj-83::obj-97" : [ "toggle[11]", "toggle[11]", 0 ],
			"obj-86" : [ "number[128]", "number[11]", 0 ],
			"obj-88" : [ "number[106]", "number[11]", 0 ],
			"obj-89" : [ "number[107]", "number[10]", 0 ],
			"obj-92" : [ "number[108]", "number[29]", 0 ],
			"parameterbanks" : {},
			"parameter_overrides" : {
				"obj-83::obj-153::obj-32" : {
					"parameter_longname" : "pictctrl[18]"
				},
				"obj-83::obj-153::obj-48" : {
					"parameter_longname" : "Fade[2]"
				},
				"obj-83::obj-153::obj-53" : {
					"parameter_longname" : "pictctrl[17]"
				},
				"obj-83::obj-153::obj-78" : {
					"parameter_longname" : "Luminance[2]"
				},
				"obj-83::obj-153::obj-85" : {
					"parameter_longname" : "pictctrl[16]"
				},
				"obj-83::obj-153::obj-9" : {
					"parameter_longname" : "Tolerance[3]"
				},
				"obj-83::obj-179::obj-14" : {
					"parameter_longname" : "live.toggle[4]"
				},
				"obj-83::obj-179::obj-19" : {
					"parameter_longname" : "umenu[3]"
				},
				"obj-83::obj-252::obj-42" : {
					"parameter_longname" : "pictctrl[19]"
				},
				"obj-83::obj-26::obj-9" : {
					"parameter_longname" : "Tolerance[1]"
				},
				"obj-83::obj-48::obj-32" : {
					"parameter_longname" : "pictctrl[12]"
				},
				"obj-83::obj-48::obj-48" : {
					"parameter_longname" : "Fade[1]"
				},
				"obj-83::obj-48::obj-53" : {
					"parameter_longname" : "pictctrl[13]"
				},
				"obj-83::obj-48::obj-78" : {
					"parameter_longname" : "Luminance[1]"
				},
				"obj-83::obj-48::obj-9" : {
					"parameter_longname" : "Tolerance[2]"
				}
			},
			"inherited_shortname" : 1
		},
		"dependency_cache" : [
			{
				"name" : "2input-router.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "brcosa.genjit",
				"bootpath" : "~/Library/Application Support/Cycling '74/Max 9/Examples/jitter-examples/gen",
				"patcherrelativepath" : "../../../Library/Application Support/Cycling '74/Max 9/Examples/jitter-examples/gen",
				"type" : "gJIT",
				"implicit" : 1
			},
			{
				"name" : "data-handler.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "exact_menu.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "jit.ndi.receive~.mxo",
				"type" : "iLaX"
			},
			{
				"name" : "mira.mt.centroid.js",
				"bootpath" : "C74:/packages/mira/patchers",
				"type" : "TEXT",
				"implicit" : 1
			},
			{
				"name" : "mira.mt.centroid.maxpat",
				"bootpath" : "C74:/packages/mira/patchers",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "mira.mt.pinch.maxpat",
				"bootpath" : "C74:/packages/mira/patchers",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "mira.mt.rotate.maxpat",
				"bootpath" : "C74:/packages/mira/patchers",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "mira.mt.touch.maxpat",
				"bootpath" : "C74:/packages/mira/patchers",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "ultraleap.mxo",
				"type" : "iLaX"
			},
			{
				"name" : "video-handler.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vizzie-datatexconvert.js",
				"bootpath" : "C74:/packages/Vizzie/code",
				"type" : "TEXT",
				"implicit" : 1
			},
			{
				"name" : "vizzie-global.js",
				"bootpath" : "C74:/packages/Vizzie/code",
				"type" : "TEXT",
				"implicit" : 1
			},
			{
				"name" : "vz.alphablendr.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vz.chromakeyr.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vz.lumakeyr.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vz.matrix2texture.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vzgl-disable.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vzgl-object.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vzgl-outputdim.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vzgl-pwindow.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			},
			{
				"name" : "vzgl-routegl.maxpat",
				"bootpath" : "C74:/packages/Vizzie/patchers/utils",
				"type" : "JSON",
				"implicit" : 1
			}
		],
		"autosave" : 0,
		"boxgroups" : [
			{
				"boxes" : [
					"obj-203",
					"obj-332",
					"obj-205"
				]
			}
		],
		"oscreceiveudpport" : 0
	}
}
