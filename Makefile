!IF "$(CPU)" == ""
CPU=$(_BUILDARCH)
!ENDIF

!IF "$(CPU)" == ""
CPU=i386
!ENDIF

WARNING_LEVEL=/nologo /WX /W4 /wd4214 /wd4201 /wd4206
!IF "$(CPU)" == "i386"
OPTIMIZATION=/O2 /G7 /GR- /MD
!ELSEIF "$(CPU)" == "ARM"
OPTIMIZATION=/O2 /GR- /wd4996 /wd4005 /D_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE /MD
!ELSE
OPTIMIZATION=/O2 /GS- /GR- /MD
!ENDIF
LINK_SWITCHES=/nologo /release /opt:ref,icf=10 /largeaddressaware

$(CPU)\swapadd.exe: $(CPU)\swapadd.obj ..\lib\minwcrt.lib Makefile
	link $(LINK_SWITCHES) /out:$(CPU)\swapadd.exe $(CPU)\swapadd.obj

$(CPU)\swapadd.obj: swapadd.cpp ..\include\winstrct.hpp ..\include\winstrct.h Makefile
	cl /c $(WARNING_LEVEL) $(OPTIMIZATION) $(CPP_DEFINE) /Fp$(CPU)\swapadd /Fo$(CPU)\swapadd swapadd.cpp

clean:
	del /s *.obj *~ *.pch
