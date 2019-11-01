/*---------------------------------------------------------------------------------

	Copyright (C) 2018

	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any
	damages arising from the use of this software.

	Permission is granted to anyone to use this software for any
	purpose, including commercial applications, and to alter it and
	redistribute it freely, subject to the following restrictions:


	1.	The origin of this software must not be misrepresented; you
		must not claim that you wrote the original software. If you use
		this software in a product, an acknowledgment in the product
		documentation would be appreciated but is not required.

	2.	Altered source versions must be plainly marked as such, and
		must not be misrepresented as being the original software.

	3.	This notice may not be removed or altered from any source
		distribution.

---------------------------------------------------------------------------------*/
/*! \file coleco.h
\brief the master include file for colecovision applications.
*/

/*!
 \mainpage PVcollib Documentation


 \section intro Introduction
 Welcome to the PVcollib reference documentation.

 \section console_mngt Generic console feature
 - \ref console.h "Console management"

 \section sound_sn76489 sound engine API
 - \ref sound.h "General sound"

 \section video_tms9918 2D engine API
 - \ref video.h "General video"
 
 \section external_links Useful links
 - <a href="http://atariage.com/forums/forum/55-colecovision-programming/">AtariAge ColecoVision development forum.</a>
 
 \section special_thanks Special Thanks
 - <a href="http://ccjvq.com/newcoleco/indexfr.html">Daniel Bienvenu for cvlib source code, which are parts of PVcollib.</a>
 - <a href="https://sourceforge.net/projects/sdcc/files/">Philipp Klaus Krause - SDCC Release Manager. </a>
*/


//adding the example page.
/*!
 <!-- EXAMPLES -->
    <!-- hello world -->
		\example helloworld/helloworld.c

*/

#ifndef COL_INCLUDE
#define COL_INCLUDE

#include "coleco/console.h"
#include "coleco/sound.h"
#include "coleco/video.h"

#endif // COL_INCLUDE