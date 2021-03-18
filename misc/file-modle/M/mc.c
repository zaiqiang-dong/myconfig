/********************************************************************************

File Name			:FN_FileName.c
Copyright			:2003-2008 XXXX Corporation, All Rights Reserved.
Module Name			:Draw Engine/Display
Platform			:MSM8996
Create Date			:2003/10/01
Author/Corporation	:WhoAmI/your company name
Abstract Description:Place some description here.

-----------------------Revision History---------------------------------
No		Version		Date		Revised By	Item			Description
1 		V0.95  		00.05.18	WhoAmI		abcdefghijklm	WhatUDo

**********************************************************************************/

/*Debug switch Section*/
#define D_DISP_BASE

/*Include File Section*/
#include "IncFile.h"

/*Macro Define Section*/
#define MAX_TIMER_OUT (4)

/*Struct Define Section*/
typedef struct CM_RadiationDose
{
unsigned char ucCtgID;
char cPatId_a[MAX_PATI_LEN];
}CM_RadiationDose_st, *pCM_RadiationDose_st;

/*Prototype Declare Section*/
unsigned int MD_guiGetScanTimes(void);

/*Global Variable Declare Section*/
extern unsigned int MD_guiHoldBreathStatus;

/*File Static Variable Define Section*/
static unsigned int nuiNaviSysStatus;

/*Function Define Section*/

/*
Function	:
Description	:
Input		:
Output		:
Return		:
*/

