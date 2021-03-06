EESchema Schematic File Version 2  date 6/5/2013 1:51:18 PM
LIBS:DigiRED_v1.0-cache
LIBS:DigiRED_v1.0-cache
EELAYER 27 0
EELAYER END
$Descr User 8263 11692
encoding utf-8
Sheet 3 6
Title "DigiRED v1.0"
Date "5 jun 2013"
Rev "1"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text GLabel 5575 7025 2    45   Input ~ 0
RXD11
Text GLabel 5625 6625 2    45   Input ~ 0
RXD7
Text GLabel 5625 6425 2    45   Input ~ 0
RXD5
Text GLabel 5625 6225 2    45   Input ~ 0
RXD3
Text GLabel 5625 6025 2    45   Input ~ 0
RXD1
Text GLabel 5575 6925 2    45   Input ~ 0
RXD10
Text GLabel 5625 6725 2    45   Input ~ 0
RXD8
Text GLabel 5625 6525 2    45   Input ~ 0
RXD6
Text GLabel 5525 7125 2    45   Input ~ 0
RXIQSEL
Text GLabel 5625 6325 2    45   Input ~ 0
RXD4
Text GLabel 5625 2400 2    45   Output ~ 0
TXD8
Text GLabel 5625 2200 2    45   Output ~ 0
TXD6
Text GLabel 5625 1800 2    45   Output ~ 0
TXD2
Text GLabel 5625 2800 2    45   Output ~ 0
TXIQSEL
Text GLabel 5625 6825 2    45   Input ~ 0
RXD9
Text GLabel 5625 2600 2    45   Output ~ 0
TXD10
Text GLabel 5625 2700 2    45   Output ~ 0
TXD11
Text GLabel 5625 1700 2    45   Output ~ 0
TXD1
Text GLabel 5625 1900 2    45   Output ~ 0
TXD3
Text GLabel 5625 2100 2    45   Output ~ 0
TXD5
Text GLabel 5625 2500 2    45   Output ~ 0
TXD9
Text GLabel 5625 2300 2    45   Output ~ 0
TXD7
Text GLabel 5625 6125 2    45   Input ~ 0
RXD2
Text GLabel 5625 5925 2    45   Input ~ 0
RXD0
Text GLabel 5625 2000 2    45   Output ~ 0
TXD4
Text GLabel 5625 1600 2    45   Output ~ 0
TXD0
$Comp
L CYUSB3011 U1
U 3 1 51717308
P 3975 3050
F 0 "U1" H 3300 4675 50  0000 L BNN
F 1 "CYUSB3011" H 4275 4700 50  0000 L BNN
F 2 "CYUSB3011-121-ballBGA" H 4775 4800 50  0001 C CNN
F 3 "" H 3975 3050 60  0001 C CNN
	3    3975 3050
	1    0    0    -1  
$EndComp
$Comp
L CYUSB3011 U2
U 3 1 51714D16
P 3975 7375
F 0 "U2" H 3275 9025 50  0000 L BNN
F 1 "CYUSB3011" H 4275 9025 50  0000 L BNN
F 2 "CYUSB3011-121-ballBGA" H 4775 9125 50  0001 C CNN
F 3 "" H 3975 7375 60  0001 C CNN
	3    3975 7375
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R11
U 1 1 517575CD
P 2775 1600
F 0 "R11" H 2575 1650 50  0000 L BNN
F 1 "10K" H 2800 1650 50  0000 L BNN
F 2 "R_SM0402" H 2775 1750 50  0001 C CNN
F 3 "" H 2775 1600 60  0001 C CNN
F 4 "RES, 10K OHM, 1/16W, 5%, 0402, SMD," H 2775 1600 60  0001 C CNN "Description"
F 5 "RC0402JR-0710KL" H 2775 1600 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 1600 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 1600 60  0001 C CNN "Vendor"
F 8 "311-10KJRCT-ND" H 2775 1600 60  0001 C CNN "Vendor Part Number"
	1    2775 1600
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR017
U 1 1 5175780E
P 2425 1200
F 0 "#PWR017" H 2425 1100 40  0001 C CNN
F 1 "+3V3" H 2405 1270 40  0000 C CNN
F 2 "~" H 2425 1200 60  0000 C CNN
F 3 "~" H 2425 1200 60  0000 C CNN
	1    2425 1200
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR018
U 1 1 517578A5
P 2425 5750
F 0 "#PWR018" H 2425 5650 40  0001 C CNN
F 1 "+3V3" H 2415 5820 40  0000 C CNN
F 2 "~" H 2425 5750 60  0000 C CNN
F 3 "~" H 2425 5750 60  0000 C CNN
	1    2425 5750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR019
U 1 1 517578F4
P 2025 1775
F 0 "#PWR019" H 2025 1875 40  0001 C CNN
F 1 "GND" H 2025 1705 40  0000 C CNN
F 2 "~" H 2025 1775 60  0000 C CNN
F 3 "~" H 2025 1775 60  0000 C CNN
	1    2025 1775
	1    0    0    -1  
$EndComp
Text Notes 2700 2800 0    39   ~ 0
+3.3V_TX_ID 
Text Notes 2675 7125 0    39   ~ 0
GND_RX_ID
$Comp
L RESISTOR_0603 R17
U 1 1 517A15E3
P 5200 1600
F 0 "R17" H 4950 1600 50  0000 L BNN
F 1 "22" H 5310 1600 50  0000 L BNN
F 2 "R_SM0402" H 5200 1750 50  0001 C CNN
F 3 "" H 5200 1600 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 1600 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 1600 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 1600 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 1600 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 1600 60  0001 C CNN "Vendor Part Number"
	1    5200 1600
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR020
U 1 1 517A2D5F
P 1900 2800
F 0 "#PWR020" H 1900 2700 40  0001 C CNN
F 1 "+3V3" V 1950 2825 40  0000 C CNN
F 2 "~" H 1900 2800 60  0000 C CNN
F 3 "~" H 1900 2800 60  0000 C CNN
	1    1900 2800
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR021
U 1 1 517A3A3E
P 2125 7225
F 0 "#PWR021" H 2125 7325 40  0001 C CNN
F 1 "GND" H 2125 7155 40  0000 C CNN
F 2 "~" H 2125 7225 60  0000 C CNN
F 3 "~" H 2125 7225 60  0000 C CNN
	1    2125 7225
	1    0    0    -1  
$EndComp
$Comp
L T_SWITCH SW1
U 1 1 517A60AF
P 2150 1675
F 0 "SW1" H 2150 1775 60  0000 C CNN
F 1 "T_SWITCH" H 2190 1595 60  0001 C CNN
F 2 "SW_B3U-1000P" H 2150 1675 60  0001 C CNN
F 3 "" H 2150 1675 60  0000 C CNN
F 4 "SWITCH, TACTILE, SPST-NO, 0.05A, 12V," H 2150 1675 60  0001 C CNN "Description"
F 5 "B3U-1000P" H 2150 1675 60  0001 C CNN "Manufacturer Part Number"
F 6 "Omron Electronics Inc-EMC Div" H 2150 1675 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2150 1675 60  0001 C CNN "Vendor"
F 8 "SW1020CT-ND" H 2150 1675 60  0001 C CNN "Vendor Part Number"
	1    2150 1675
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR022
U 1 1 517A64D0
P 2050 6100
F 0 "#PWR022" H 2050 6200 40  0001 C CNN
F 1 "GND" H 2050 6030 40  0000 C CNN
F 2 "~" H 2050 6100 60  0000 C CNN
F 3 "~" H 2050 6100 60  0000 C CNN
	1    2050 6100
	1    0    0    -1  
$EndComp
$Comp
L T_SWITCH SW2
U 1 1 517A64D6
P 2175 6000
F 0 "SW2" H 2175 6075 60  0000 C CNN
F 1 "T_SWITCH" H 2215 5920 60  0001 C CNN
F 2 "SW_B3U-1000P" H 2175 6000 60  0001 C CNN
F 3 "" H 2175 6000 60  0000 C CNN
F 4 "SWITCH, TACTILE, SPST-NO, 0.05A, 12V," H 2175 6000 60  0001 C CNN "Description"
F 5 "B3U-1000P" H 2175 6000 60  0001 C CNN "Manufacturer Part Number"
F 6 "Omron Electronics Inc-EMC Div" H 2175 6000 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2175 6000 60  0001 C CNN "Vendor"
F 8 "SW1020CT-ND" H 2175 6000 60  0001 C CNN "Vendor Part Number"
	1    2175 6000
	1    0    0    -1  
$EndComp
Text Notes 3250 1200 0    59   ~ 0
Transmitter data lines
Text Notes 3250 5500 0    59   ~ 0
Receiver data lines
Text GLabel 3025 1750 0    45   Input ~ 0
TXCLK
Text GLabel 3025 6075 0    45   Input ~ 0
RXCLK
$Comp
L GND #PWR023
U 1 1 517C45B1
P 2425 4150
F 0 "#PWR023" H 2425 4250 40  0001 C CNN
F 1 "GND" H 2425 4080 40  0000 C CNN
F 2 "~" H 2425 4150 60  0000 C CNN
F 3 "~" H 2425 4150 60  0000 C CNN
	1    2425 4150
	0    1    1    0   
$EndComp
$Comp
L GND #PWR024
U 1 1 517C45B8
P 2425 8475
F 0 "#PWR024" H 2425 8575 40  0001 C CNN
F 1 "GND" H 2425 8405 40  0000 C CNN
F 2 "~" H 2425 8475 60  0000 C CNN
F 3 "~" H 2425 8475 60  0000 C CNN
	1    2425 8475
	0    1    1    0   
$EndComp
Text GLabel 5075 8525 2    45   BiDi ~ 0
GPIO2_Rx
Text GLabel 5075 8425 2    45   BiDi ~ 0
GPIO1_Rx
Text GLabel 5075 8325 2    45   Input ~ 0
GPIO0_Rx
Text Label 5300 3600 2    59   ~ 0
SLRD_Tx
Text Label 2625 2350 0    59   ~ 0
SLRD_Tx
Text Label 2625 1900 0    59   ~ 0
SLCS_Tx
Text Label 2625 2050 0    59   ~ 0
SLWR_Tx
Text Label 2625 2200 0    59   ~ 0
SLOE_Tx
Text Label 5300 3300 2    59   ~ 0
SLCS_Tx
Text Label 5300 3400 2    59   ~ 0
SLWR_Tx
Text Label 5300 3500 2    59   ~ 0
SLOE_Tx
Text Label 2625 3700 0    59   ~ 0
A0_Tx
Text Label 2625 3550 0    59   ~ 0
A1_Tx
Text Label 2550 2950 0    59   ~ 0
PKTEND_Tx
Text Label 5400 3700 2    59   ~ 0
PKTEND_Tx
Text Label 5300 3800 2    59   ~ 0
A0_Tx
Text Label 5300 3900 2    59   ~ 0
A1_Tx
NoConn ~ 3075 2500
NoConn ~ 3075 2650
Text GLabel 5075 4200 2    45   BiDi ~ 0
GPIO2_Tx
Text GLabel 5075 4100 2    45   BiDi ~ 0
GPIO1_Tx
Text GLabel 5075 4000 2    45   Input ~ 0
GPIO0_Tx
Text Label 2625 6675 0    59   ~ 0
SLRD_Rx
Text Label 2625 6225 0    59   ~ 0
SLCS_Rx
Text Label 2625 6375 0    59   ~ 0
SLWR_Rx
Text Label 2625 6525 0    59   ~ 0
SLOE_Rx
Text Label 2550 7275 0    59   ~ 0
PKTEND_Rx
Text Label 2625 8025 0    59   ~ 0
A0_Rx
Text Label 2625 7875 0    59   ~ 0
A1_Rx
Text Label 5300 7925 2    59   ~ 0
SLRD_Rx
Text Label 5300 7625 2    59   ~ 0
SLCS_Rx
Text Label 5300 7725 2    59   ~ 0
SLWR_Rx
Text Label 5300 7825 2    59   ~ 0
SLOE_Rx
Text Label 5400 8025 2    59   ~ 0
PKTEND_Rx
Text Label 5300 8125 2    59   ~ 0
A0_Rx
Text Label 5300 8225 2    59   ~ 0
A1_Rx
Text Label 2625 6975 0    59   ~ 0
FLAGB
Text Label 2625 6825 0    59   ~ 0
FLAGA
Text Label 6125 7325 2    59   ~ 0
FLAGB
Text Label 6125 7225 2    59   ~ 0
FLAGA
NoConn ~ 4875 2900
NoConn ~ 4875 3000
NoConn ~ 4875 3100
Text GLabel 5100 4300 2    45   Output ~ 0
RESET_Tx
Text GLabel 5100 8625 2    45   Output ~ 0
RESET_Rx
$Comp
L +3V3 #PWR025
U 1 1 517F1E8C
P 2300 3625
F 0 "#PWR025" H 2300 3525 40  0001 C CNN
F 1 "+3V3" H 2280 3695 40  0000 C CNN
F 2 "~" H 2300 3625 60  0000 C CNN
F 3 "~" H 2300 3625 60  0000 C CNN
	1    2300 3625
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR026
U 1 1 517F24A4
P 2300 7950
F 0 "#PWR026" H 2300 7850 40  0001 C CNN
F 1 "+3V3" H 2280 8020 40  0000 C CNN
F 2 "~" H 2300 7950 60  0000 C CNN
F 3 "~" H 2300 7950 60  0000 C CNN
	1    2300 7950
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R30
U 1 1 5193B178
P 2775 3850
F 0 "R30" H 2525 3875 50  0000 L BNN
F 1 "0" H 2900 3875 50  0000 L BNN
F 2 "R_SM0402" H 2775 4000 50  0001 C CNN
F 3 "" H 2775 3850 60  0001 C CNN
F 4 "RES, 0.0 OHM,1/16W, JUMP, 0402 SMD," H 2775 3850 60  0001 C CNN "Description"
F 5 "RC0402JR-070RL" H 2775 3850 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 3850 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 3850 60  0001 C CNN "Vendor"
F 8 "311-0.0JRCT-ND" H 2775 3850 60  0001 C CNN "Vendor Part Number"
	1    2775 3850
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R31
U 1 1 5193B1F9
P 2775 4000
F 0 "R31" H 2525 4025 50  0000 L BNN
F 1 "0" H 2900 4025 50  0000 L BNN
F 2 "R_SM0402" H 2775 4150 50  0001 C CNN
F 3 "" H 2775 4000 60  0001 C CNN
F 4 "RES, 0.0 OHM,1/16W, JUMP, 0402 SMD," H 2775 4000 60  0001 C CNN "Description"
F 5 "RC0402JR-070RL" H 2775 4000 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 4000 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 4000 60  0001 C CNN "Vendor"
F 8 "311-0.0JRCT-ND" H 2775 4000 60  0001 C CNN "Vendor Part Number"
F 9 "NF" H 2775 3990 50  0000 C CNN "Installation"
F 10 "NOFIT" H 2775 4000 60  0001 C CNN "Assemble"
	1    2775 4000
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R12
U 1 1 5193B373
P 2450 2800
F 0 "R12" H 2250 2850 50  0000 L BNN
F 1 "10K" H 2475 2850 50  0000 L BNN
F 2 "R_SM0402" H 2450 2950 50  0001 C CNN
F 3 "" H 2450 2800 60  0001 C CNN
F 4 "RES, 10K OHM, 1/16W, 5%, 0402, SMD," H 2450 2800 60  0001 C CNN "Description"
F 5 "RC0402JR-0710KL" H 2450 2800 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2450 2800 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2450 2800 60  0001 C CNN "Vendor"
F 8 "311-10KJRCT-ND" H 2450 2800 60  0001 C CNN "Vendor Part Number"
	1    2450 2800
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R14
U 1 1 5193B37E
P 2775 5925
F 0 "R14" H 2575 5975 50  0000 L BNN
F 1 "10K" H 2800 5975 50  0000 L BNN
F 2 "R_SM0402" H 2775 6075 50  0001 C CNN
F 3 "" H 2775 5925 60  0001 C CNN
F 4 "RES, 10K OHM, 1/16W, 5%, 0402, SMD," H 2775 5925 60  0001 C CNN "Description"
F 5 "RC0402JR-0710KL" H 2775 5925 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 5925 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 5925 60  0001 C CNN "Vendor"
F 8 "311-10KJRCT-ND" H 2775 5925 60  0001 C CNN "Vendor Part Number"
	1    2775 5925
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R15
U 1 1 5193B389
P 2400 7125
F 0 "R15" H 2200 7175 50  0000 L BNN
F 1 "10K" H 2425 7175 50  0000 L BNN
F 2 "R_SM0402" H 2400 7275 50  0001 C CNN
F 3 "" H 2400 7125 60  0001 C CNN
F 4 "RES, 10K OHM, 1/16W, 5%, 0402, SMD," H 2400 7125 60  0001 C CNN "Description"
F 5 "RC0402JR-0710KL" H 2400 7125 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2400 7125 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2400 7125 60  0001 C CNN "Vendor"
F 8 "311-10KJRCT-ND" H 2400 7125 60  0001 C CNN "Vendor Part Number"
	1    2400 7125
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R18
U 1 1 5193B3B6
P 5200 1700
F 0 "R18" H 4950 1700 50  0000 L BNN
F 1 "22" H 5310 1700 50  0000 L BNN
F 2 "R_SM0402" H 5200 1850 50  0001 C CNN
F 3 "" H 5200 1700 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 1700 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 1700 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 1700 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 1700 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 1700 60  0001 C CNN "Vendor Part Number"
	1    5200 1700
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R19
U 1 1 5193B3C1
P 5200 1800
F 0 "R19" H 4950 1800 50  0000 L BNN
F 1 "22" H 5310 1800 50  0000 L BNN
F 2 "R_SM0402" H 5200 1950 50  0001 C CNN
F 3 "" H 5200 1800 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 1800 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 1800 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 1800 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 1800 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 1800 60  0001 C CNN "Vendor Part Number"
	1    5200 1800
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R20
U 1 1 5193B3F4
P 5200 1900
F 0 "R20" H 4950 1900 50  0000 L BNN
F 1 "22" H 5310 1900 50  0000 L BNN
F 2 "R_SM0402" H 5200 2050 50  0001 C CNN
F 3 "" H 5200 1900 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 1900 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 1900 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 1900 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 1900 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 1900 60  0001 C CNN "Vendor Part Number"
	1    5200 1900
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R21
U 1 1 5193B3FF
P 5200 2000
F 0 "R21" H 4950 2000 50  0000 L BNN
F 1 "22" H 5310 2000 50  0000 L BNN
F 2 "R_SM0402" H 5200 2150 50  0001 C CNN
F 3 "" H 5200 2000 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2000 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2000 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2000 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2000 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2000 60  0001 C CNN "Vendor Part Number"
	1    5200 2000
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R22
U 1 1 5193B40A
P 5200 2100
F 0 "R22" H 4950 2100 50  0000 L BNN
F 1 "22" H 5310 2100 50  0000 L BNN
F 2 "R_SM0402" H 5200 2250 50  0001 C CNN
F 3 "" H 5200 2100 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2100 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2100 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2100 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2100 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2100 60  0001 C CNN "Vendor Part Number"
	1    5200 2100
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R23
U 1 1 5193B415
P 5200 2200
F 0 "R23" H 4950 2200 50  0000 L BNN
F 1 "22" H 5310 2200 50  0000 L BNN
F 2 "R_SM0402" H 5200 2350 50  0001 C CNN
F 3 "" H 5200 2200 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2200 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2200 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2200 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2200 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2200 60  0001 C CNN "Vendor Part Number"
	1    5200 2200
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R24
U 1 1 5193B420
P 5200 2300
F 0 "R24" H 4950 2300 50  0000 L BNN
F 1 "22" H 5310 2300 50  0000 L BNN
F 2 "R_SM0402" H 5200 2450 50  0001 C CNN
F 3 "" H 5200 2300 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2300 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2300 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2300 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2300 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2300 60  0001 C CNN "Vendor Part Number"
	1    5200 2300
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R25
U 1 1 5193B42B
P 5200 2400
F 0 "R25" H 4950 2400 50  0000 L BNN
F 1 "22" H 5310 2400 50  0000 L BNN
F 2 "R_SM0402" H 5200 2550 50  0001 C CNN
F 3 "" H 5200 2400 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2400 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2400 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2400 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2400 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2400 60  0001 C CNN "Vendor Part Number"
	1    5200 2400
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R26
U 1 1 5193B436
P 5200 2500
F 0 "R26" H 4950 2500 50  0000 L BNN
F 1 "22" H 5310 2500 50  0000 L BNN
F 2 "R_SM0402" H 5200 2650 50  0001 C CNN
F 3 "" H 5200 2500 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2500 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2500 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2500 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2500 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2500 60  0001 C CNN "Vendor Part Number"
	1    5200 2500
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R27
U 1 1 5193B441
P 5200 2600
F 0 "R27" H 4950 2600 50  0000 L BNN
F 1 "22" H 5310 2600 50  0000 L BNN
F 2 "R_SM0402" H 5200 2750 50  0001 C CNN
F 3 "" H 5200 2600 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2600 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2600 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2600 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2600 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2600 60  0001 C CNN "Vendor Part Number"
	1    5200 2600
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R28
U 1 1 5193B44C
P 5200 2700
F 0 "R28" H 4950 2700 50  0000 L BNN
F 1 "22" H 5310 2700 50  0000 L BNN
F 2 "R_SM0402" H 5200 2850 50  0001 C CNN
F 3 "" H 5200 2700 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2700 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2700 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2700 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2700 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2700 60  0001 C CNN "Vendor Part Number"
	1    5200 2700
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R29
U 1 1 5193B457
P 5200 2800
F 0 "R29" H 4950 2800 50  0000 L BNN
F 1 "22" H 5310 2800 50  0000 L BNN
F 2 "R_SM0402" H 5200 2950 50  0001 C CNN
F 3 "" H 5200 2800 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 2800 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 2800 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 2800 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 2800 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 2800 60  0001 C CNN "Vendor Part Number"
	1    5200 2800
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R33
U 1 1 5193B462
P 5200 5925
F 0 "R33" H 4950 5925 50  0000 L BNN
F 1 "22" H 5310 5925 50  0000 L BNN
F 2 "R_SM0402" H 5200 6075 50  0001 C CNN
F 3 "" H 5200 5925 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 5925 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 5925 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 5925 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 5925 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 5925 60  0001 C CNN "Vendor Part Number"
	1    5200 5925
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R34
U 1 1 5193B46D
P 5200 6025
F 0 "R34" H 4950 6025 50  0000 L BNN
F 1 "22" H 5310 6025 50  0000 L BNN
F 2 "R_SM0402" H 5200 6175 50  0001 C CNN
F 3 "" H 5200 6025 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6025 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6025 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6025 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6025 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6025 60  0001 C CNN "Vendor Part Number"
	1    5200 6025
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R35
U 1 1 5193B478
P 5200 6125
F 0 "R35" H 4950 6125 50  0000 L BNN
F 1 "22" H 5310 6125 50  0000 L BNN
F 2 "R_SM0402" H 5200 6275 50  0001 C CNN
F 3 "" H 5200 6125 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6125 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6125 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6125 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6125 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6125 60  0001 C CNN "Vendor Part Number"
	1    5200 6125
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R36
U 1 1 5193B483
P 5200 6225
F 0 "R36" H 4950 6225 50  0000 L BNN
F 1 "22" H 5310 6225 50  0000 L BNN
F 2 "R_SM0402" H 5200 6375 50  0001 C CNN
F 3 "" H 5200 6225 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6225 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6225 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6225 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6225 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6225 60  0001 C CNN "Vendor Part Number"
	1    5200 6225
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R37
U 1 1 5193B48E
P 5200 6325
F 0 "R37" H 4950 6325 50  0000 L BNN
F 1 "22" H 5310 6325 50  0000 L BNN
F 2 "R_SM0402" H 5200 6475 50  0001 C CNN
F 3 "" H 5200 6325 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6325 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6325 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6325 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6325 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6325 60  0001 C CNN "Vendor Part Number"
	1    5200 6325
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R38
U 1 1 5193B499
P 5200 6425
F 0 "R38" H 4950 6425 50  0000 L BNN
F 1 "22" H 5310 6425 50  0000 L BNN
F 2 "R_SM0402" H 5200 6575 50  0001 C CNN
F 3 "" H 5200 6425 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6425 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6425 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6425 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6425 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6425 60  0001 C CNN "Vendor Part Number"
	1    5200 6425
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R39
U 1 1 5193B4A4
P 5200 6525
F 0 "R39" H 4950 6525 50  0000 L BNN
F 1 "22" H 5310 6525 50  0000 L BNN
F 2 "R_SM0402" H 5200 6675 50  0001 C CNN
F 3 "" H 5200 6525 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6525 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6525 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6525 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6525 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6525 60  0001 C CNN "Vendor Part Number"
	1    5200 6525
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R40
U 1 1 5193B4AF
P 5200 6625
F 0 "R40" H 4950 6625 50  0000 L BNN
F 1 "22" H 5310 6625 50  0000 L BNN
F 2 "R_SM0402" H 5200 6775 50  0001 C CNN
F 3 "" H 5200 6625 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6625 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6625 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6625 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6625 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6625 60  0001 C CNN "Vendor Part Number"
	1    5200 6625
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R41
U 1 1 5193B4BA
P 5200 6725
F 0 "R41" H 4950 6725 50  0000 L BNN
F 1 "22" H 5310 6725 50  0000 L BNN
F 2 "R_SM0402" H 5200 6875 50  0001 C CNN
F 3 "" H 5200 6725 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6725 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6725 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6725 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6725 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6725 60  0001 C CNN "Vendor Part Number"
	1    5200 6725
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R42
U 1 1 5193B4C5
P 5200 6825
F 0 "R42" H 4950 6825 50  0000 L BNN
F 1 "22" H 5310 6825 50  0000 L BNN
F 2 "R_SM0402" H 5200 6975 50  0001 C CNN
F 3 "" H 5200 6825 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6825 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6825 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6825 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6825 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6825 60  0001 C CNN "Vendor Part Number"
	1    5200 6825
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R43
U 1 1 5193B4D0
P 5200 6925
F 0 "R43" H 4950 6925 50  0000 L BNN
F 1 "22" H 5310 6925 50  0000 L BNN
F 2 "R_SM0402" H 5200 7075 50  0001 C CNN
F 3 "" H 5200 6925 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 6925 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 6925 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 6925 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 6925 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 6925 60  0001 C CNN "Vendor Part Number"
	1    5200 6925
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R44
U 1 1 5193B4DB
P 5200 7025
F 0 "R44" H 4950 7025 50  0000 L BNN
F 1 "22" H 5310 7025 50  0000 L BNN
F 2 "R_SM0402" H 5200 7175 50  0001 C CNN
F 3 "" H 5200 7025 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 7025 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 7025 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 7025 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 7025 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 7025 60  0001 C CNN "Vendor Part Number"
	1    5200 7025
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R45
U 1 1 5193B4E6
P 5200 7125
F 0 "R45" H 4950 7125 50  0000 L BNN
F 1 "22" H 5310 7125 50  0000 L BNN
F 2 "R_SM0402" H 5200 7275 50  0001 C CNN
F 3 "" H 5200 7125 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 7125 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 7125 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 7125 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 7125 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 7125 60  0001 C CNN "Vendor Part Number"
	1    5200 7125
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R46
U 1 1 5193B4F1
P 5200 7225
F 0 "R46" H 4950 7225 50  0000 L BNN
F 1 "22" H 5310 7225 50  0000 L BNN
F 2 "R_SM0402" H 5200 7375 50  0001 C CNN
F 3 "" H 5200 7225 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 7225 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 7225 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 7225 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 7225 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 7225 60  0001 C CNN "Vendor Part Number"
	1    5200 7225
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R47
U 1 1 5193C3D8
P 5200 7325
F 0 "R47" H 4950 7325 50  0000 L BNN
F 1 "22" H 5310 7325 50  0000 L BNN
F 2 "R_SM0402" H 5200 7475 50  0001 C CNN
F 3 "" H 5200 7325 60  0001 C CNN
F 4 "RES, 22.0 OHM, 1/16W, 1%, 0402, SMD," H 5200 7325 60  0001 C CNN "Description"
F 5 "RC0402FR-0722RL" H 5200 7325 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 5200 7325 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 5200 7325 60  0001 C CNN "Vendor"
F 8 "311-22.0LRTR-ND" H 5200 7325 60  0001 C CNN "Vendor Part Number"
	1    5200 7325
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG027
U 1 1 51946AEF
P 2150 1250
F 0 "#FLG027" H 2150 1175 30  0001 C CNN
F 1 "PWR_FLAG" H 2150 1300 30  0000 C CNN
F 2 "~" H 2150 1250 60  0000 C CNN
F 3 "~" H 2150 1250 60  0000 C CNN
	1    2150 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	4875 8825 5075 8825
Wire Wire Line
	2425 1225 2425 1600
Wire Wire Line
	2425 1600 2575 1600
Wire Wire Line
	2975 1600 3075 1600
Wire Wire Line
	2425 5775 2425 5925
Wire Wire Line
	2425 5925 2575 5925
Connection ~ 3025 1600
Connection ~ 3025 5925
Wire Wire Line
	2975 5925 3075 5925
Wire Wire Line
	4875 1600 5000 1600
Wire Wire Line
	5400 1600 5625 1600
Wire Wire Line
	4875 1700 5000 1700
Wire Wire Line
	5400 1700 5625 1700
Wire Wire Line
	4875 1800 5000 1800
Wire Wire Line
	5400 1800 5625 1800
Wire Wire Line
	4875 1900 5000 1900
Wire Wire Line
	5400 1900 5625 1900
Wire Wire Line
	4875 2000 5000 2000
Wire Wire Line
	5400 2000 5625 2000
Wire Wire Line
	4875 2100 5000 2100
Wire Wire Line
	5400 2100 5625 2100
Wire Wire Line
	4875 2200 5000 2200
Wire Wire Line
	5400 2200 5625 2200
Wire Wire Line
	4875 2300 5000 2300
Wire Wire Line
	5400 2300 5625 2300
Wire Wire Line
	4875 2400 5000 2400
Wire Wire Line
	4875 2500 5000 2500
Wire Wire Line
	4875 2600 5000 2600
Wire Wire Line
	4875 2700 5000 2700
Wire Wire Line
	4875 2800 5000 2800
Wire Wire Line
	5400 2400 5625 2400
Wire Wire Line
	5400 2500 5625 2500
Wire Wire Line
	5400 2600 5625 2600
Wire Wire Line
	5400 2700 5625 2700
Wire Wire Line
	5400 2800 5625 2800
Wire Wire Line
	4875 5925 5000 5925
Wire Wire Line
	5400 5925 5625 5925
Wire Wire Line
	4875 6025 5000 6025
Wire Wire Line
	5400 6025 5625 6025
Wire Wire Line
	4875 6125 5000 6125
Wire Wire Line
	5400 6125 5625 6125
Wire Wire Line
	4875 6225 5000 6225
Wire Wire Line
	5400 6225 5625 6225
Wire Wire Line
	4875 6325 5000 6325
Wire Wire Line
	5400 6325 5625 6325
Wire Wire Line
	4875 6425 5000 6425
Wire Wire Line
	5400 6425 5625 6425
Wire Wire Line
	4875 6525 5000 6525
Wire Wire Line
	5400 6525 5625 6525
Wire Wire Line
	4875 6625 5000 6625
Wire Wire Line
	5400 6625 5625 6625
Wire Wire Line
	4875 6725 5000 6725
Wire Wire Line
	4875 6825 5000 6825
Wire Wire Line
	4875 6925 5000 6925
Wire Wire Line
	4875 7025 5000 7025
Wire Wire Line
	4875 7125 5000 7125
Wire Wire Line
	4875 7225 5000 7225
Wire Wire Line
	4875 7325 5000 7325
Wire Wire Line
	5400 6725 5625 6725
Wire Wire Line
	5400 6825 5625 6825
Wire Wire Line
	5400 6925 5575 6925
Wire Wire Line
	5400 7025 5575 7025
Wire Wire Line
	5400 7125 5525 7125
Wire Wire Line
	2600 7125 3075 7125
Wire Wire Line
	2200 7125 2125 7125
Wire Wire Line
	2125 7125 2125 7175
Wire Wire Line
	3025 1675 3025 1600
Wire Wire Line
	2225 1675 3025 1675
Wire Wire Line
	2075 1675 2025 1675
Wire Wire Line
	2025 1675 2025 1725
Wire Wire Line
	2250 6000 3025 6000
Wire Wire Line
	2100 6000 2050 6000
Wire Wire Line
	2050 6000 2050 6050
Wire Wire Line
	3025 6000 3025 5925
Wire Wire Line
	3075 2800 2650 2800
Wire Wire Line
	3025 6075 3075 6075
Wire Wire Line
	4875 4000 5075 4000
Wire Wire Line
	4875 4100 5075 4100
Wire Wire Line
	4875 4200 5075 4200
Wire Wire Line
	2975 4300 3075 4300
Wire Wire Line
	2975 8625 3075 8625
Wire Wire Line
	2625 2350 3075 2350
Wire Wire Line
	3025 1750 3075 1750
Wire Wire Line
	4875 8325 5075 8325
Wire Wire Line
	4875 8425 5075 8425
Wire Wire Line
	4875 8525 5075 8525
Wire Wire Line
	4875 3300 5300 3300
Wire Wire Line
	4875 3400 5300 3400
Wire Wire Line
	4875 3500 5300 3500
Wire Wire Line
	4875 3600 5300 3600
Wire Wire Line
	2625 1900 3075 1900
Wire Wire Line
	2625 2050 3075 2050
Wire Wire Line
	2625 2200 3075 2200
Wire Wire Line
	2625 3700 3075 3700
Wire Wire Line
	2625 3550 3075 3550
Wire Wire Line
	2550 2950 3075 2950
Wire Wire Line
	4875 3700 5400 3700
Wire Wire Line
	4875 3800 5300 3800
Wire Wire Line
	4875 3900 5300 3900
Wire Wire Line
	2625 6675 3075 6675
Wire Wire Line
	2625 6225 3075 6225
Wire Wire Line
	2625 6375 3075 6375
Wire Wire Line
	2625 6525 3075 6525
Wire Wire Line
	2550 7275 3075 7275
Wire Wire Line
	2625 8025 3075 8025
Wire Wire Line
	2625 7875 3075 7875
Wire Wire Line
	4875 7625 5300 7625
Wire Wire Line
	4875 7725 5300 7725
Wire Wire Line
	4875 7825 5300 7825
Wire Wire Line
	4875 7925 5300 7925
Wire Wire Line
	4875 8025 5400 8025
Wire Wire Line
	4875 8125 5300 8125
Wire Wire Line
	4875 8225 5300 8225
Wire Wire Line
	2625 6975 3075 6975
Wire Wire Line
	2625 6825 3075 6825
Wire Wire Line
	5400 7325 6125 7325
Wire Wire Line
	5400 7225 6125 7225
Wire Wire Line
	5100 4300 4875 4300
Wire Wire Line
	5100 8625 4875 8625
Wire Wire Line
	2975 3850 3075 3850
Wire Wire Line
	2975 4000 3075 4000
Wire Wire Line
	2975 4150 3075 4150
Wire Wire Line
	2300 4300 2575 4300
Wire Wire Line
	2300 3850 2575 3850
Wire Wire Line
	2300 4000 2575 4000
Connection ~ 2300 3850
Connection ~ 2300 8175
Wire Wire Line
	2975 8175 3075 8175
Wire Wire Line
	2975 8325 3075 8325
Wire Wire Line
	2975 8475 3075 8475
Wire Wire Line
	1925 2800 2250 2800
Wire Wire Line
	2150 1275 2150 1375
Connection ~ 2425 1375
Wire Wire Line
	2150 1375 2425 1375
Wire Wire Line
	1950 8175 1950 8075
Wire Wire Line
	1950 8175 2575 8175
$Comp
L PWR_FLAG #FLG028
U 1 1 51946A50
P 1950 8050
F 0 "#FLG028" H 1950 7975 30  0001 C CNN
F 1 "PWR_FLAG" H 1950 8100 30  0000 C CNN
F 2 "~" H 1950 8050 60  0000 C CNN
F 3 "~" H 1950 8050 60  0000 C CNN
	1    1950 8050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2675 7725 3075 7725
Wire Wire Line
	3075 3400 2825 3400
Text GLabel 5100 4500 2    45   BiDi ~ 0
GPIO_Tx4
Wire Wire Line
	4875 4500 5100 4500
Text GLabel 5100 4400 2    45   BiDi ~ 0
GPIO_Tx3
Wire Wire Line
	4875 4400 5100 4400
Text GLabel 2825 3250 0    45   BiDi ~ 0
GPIO_Tx2
Text GLabel 2825 3100 0    45   BiDi ~ 0
GPIO_Tx1
Wire Wire Line
	3075 3100 2825 3100
Wire Wire Line
	2825 3250 3075 3250
Text GLabel 2675 7575 0    45   BiDi ~ 0
GPIO_Rx2
Text GLabel 2675 7425 0    45   BiDi ~ 0
GPIO_Rx1
Wire Wire Line
	2675 7425 3075 7425
Wire Wire Line
	2675 7575 3075 7575
Text GLabel 5075 8825 2    45   BiDi ~ 0
GPIO_Rx4
Text GLabel 5075 8725 2    45   BiDi ~ 0
GPIO_Rx3
Wire Wire Line
	4875 8725 5075 8725
Text GLabel 2675 7725 0    45   Output ~ 0
SBEN_Rx
Text GLabel 2825 3400 0    45   Output ~ 0
SBEN_Tx
Text GLabel 5675 7425 2    45   Input ~ 0
PPS
Wire Wire Line
	4875 7425 5675 7425
$Comp
L RESISTOR_0603 R32
U 1 1 51A618CD
P 2775 4150
F 0 "R32" H 2525 4175 50  0000 L BNN
F 1 "0" H 2900 4175 50  0000 L BNN
F 2 "R_SM0402" H 2775 4300 50  0001 C CNN
F 3 "" H 2775 4150 60  0001 C CNN
F 4 "RES, 0.0 OHM,1/16W, JUMP, 0402 SMD," H 2775 4150 60  0001 C CNN "Description"
F 5 "RC0402JR-070RL" H 2775 4150 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 4150 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 4150 60  0001 C CNN "Vendor"
F 8 "311-0.0JRCT-ND" H 2775 4150 60  0001 C CNN "Vendor Part Number"
	1    2775 4150
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R48
U 1 1 51A618FA
P 2775 8175
F 0 "R48" H 2525 8175 50  0000 L BNN
F 1 "0" H 2895 8195 50  0000 L BNN
F 2 "R_SM0402" H 2775 8325 50  0001 C CNN
F 3 "" H 2775 8175 60  0001 C CNN
F 4 "RES, 0.0 OHM,1/16W, JUMP, 0402 SMD," H 2775 8175 60  0001 C CNN "Description"
F 5 "RC0402JR-070RL" H 2775 8175 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 8175 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 8175 60  0001 C CNN "Vendor"
F 8 "311-0.0JRCT-ND" H 2775 8175 60  0001 C CNN "Vendor Part Number"
	1    2775 8175
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R126
U 1 1 51A61907
P 2775 8325
F 0 "R126" H 2475 8325 50  0000 L BNN
F 1 "0" H 2895 8345 50  0000 L BNN
F 2 "R_SM0402" H 2775 8475 50  0001 C CNN
F 3 "" H 2775 8325 60  0001 C CNN
F 4 "RES, 0.0 OHM,1/16W, JUMP, 0402 SMD," H 2775 8325 60  0001 C CNN "Description"
F 5 "RC0402JR-070RL" H 2775 8325 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 8325 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 8325 60  0001 C CNN "Vendor"
F 8 "311-0.0JRCT-ND" H 2775 8325 60  0001 C CNN "Vendor Part Number"
F 9 "NF" H 2775 8315 50  0000 C CNN "Installation"
F 10 "NOFIT" H 2775 8325 60  0001 C CNN "Assemble"
	1    2775 8325
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR_0603 R127
U 1 1 51A61912
P 2775 8475
F 0 "R127" H 2475 8475 50  0000 L BNN
F 1 "0" H 2895 8495 50  0000 L BNN
F 2 "R_SM0402" H 2775 8625 50  0001 C CNN
F 3 "" H 2775 8475 60  0001 C CNN
F 4 "RES, 0.0 OHM,1/16W, JUMP, 0402 SMD," H 2775 8475 60  0001 C CNN "Description"
F 5 "RC0402JR-070RL" H 2775 8475 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 8475 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 8475 60  0001 C CNN "Vendor"
F 8 "311-0.0JRCT-ND" H 2775 8475 60  0001 C CNN "Vendor Part Number"
	1    2775 8475
	1    0    0    -1  
$EndComp
Wire Wire Line
	2575 4150 2475 4150
Wire Wire Line
	2300 3650 2300 4300
Wire Wire Line
	2575 8475 2475 8475
Wire Wire Line
	2300 8625 2575 8625
Wire Wire Line
	2300 7975 2300 8625
$Comp
L RESISTOR_0603 R13
U 1 1 51A642C6
P 2775 4300
F 0 "R13" H 2525 4325 50  0000 L BNN
F 1 "0" H 2900 4325 50  0000 L BNN
F 2 "R_SM0402" H 2775 4450 50  0001 C CNN
F 3 "" H 2775 4300 60  0001 C CNN
F 4 "RES, 0.0 OHM,1/16W, JUMP, 0402 SMD," H 2775 4300 60  0001 C CNN "Description"
F 5 "RC0402JR-070RL" H 2775 4300 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 4300 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 4300 60  0001 C CNN "Vendor"
F 8 "311-0.0JRCT-ND" H 2775 4300 60  0001 C CNN "Vendor Part Number"
F 9 "NF" H 2775 4290 50  0000 C CNN "Installation"
F 10 "NOFIT" H 2775 4300 60  0001 C CNN "Assemble"
	1    2775 4300
	1    0    0    -1  
$EndComp
Connection ~ 2300 4000
$Comp
L RESISTOR_0603 R16
U 1 1 51A64447
P 2775 8625
F 0 "R16" H 2475 8625 50  0000 L BNN
F 1 "0" H 2895 8645 50  0000 L BNN
F 2 "R_SM0402" H 2775 8775 50  0001 C CNN
F 3 "" H 2775 8625 60  0001 C CNN
F 4 "RES, 0.0 OHM,1/16W, JUMP, 0402 SMD," H 2775 8625 60  0001 C CNN "Description"
F 5 "RC0402JR-070RL" H 2775 8625 60  0001 C CNN "Manufacturer Part Number"
F 6 "Yageo" H 2775 8625 60  0001 C CNN "Manufacturer"
F 7 "Digi-Key" H 2775 8625 60  0001 C CNN "Vendor"
F 8 "311-0.0JRCT-ND" H 2775 8625 60  0001 C CNN "Vendor Part Number"
F 9 "NF" H 2775 8615 50  0000 C CNN "Installation"
F 10 "NOFIT" H 2775 8625 60  0001 C CNN "Assemble"
	1    2775 8625
	1    0    0    -1  
$EndComp
Connection ~ 2300 8325
Wire Wire Line
	2300 8325 2575 8325
$EndSCHEMATC
