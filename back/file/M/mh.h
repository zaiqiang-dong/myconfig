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

/*Multi-Include-Prevent Section*/
#ifndef __FN_FILENAME_H
#define __FN_FILENAME_H

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
}CM_RadiationDose_st, *CM_RadiationDose_pst;

/*Prototype Declare Section*/
unsigned int MD_guiGetScanTimes(void);

#endif
