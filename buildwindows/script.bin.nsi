!include "MUI2.nsh"
icon "safejumper.ico"
Name Safejumper
OutFile Safejumper_install.exe ; NsiDecompiler: generated value!
InstallColors 00FF00 000000
InstallDir 'C:\Program Files\Safejumper'
Page directory "" "" ""
Page instfiles "" "" ""
Page custom ""  ""

Section main

SectionIn RO
       CreateDirectory $INSTDIR
       SetOutPath $INSTDIR
       File  Qt5Core.dll
       File  Qt5Gui.dll
       File  Qt5Network.dll
       File  Qt5Svg.dll
       File  Qt5Widgets.dll
       File  Qt5Xml.dll
       File  libeay32.dll
       File  vcredist_x86.exe
       File  proxysh.crt
       File  ssleay32.dll
	   SetOutPath $INSTDIR\platforms
       File  platforms\qwindows.dll
	   SetOutPath $INSTDIR
       File  safejumper.exe
       SetOutPath $TEMP
       File  openvpn-proxysh.exe
       Push $0
       ExecWait '$OUTDIR\openvpn-proxysh.exe /S /D=C:\Program Files\OpenVPN' $0
       IfErrors Label_0x19 Label_0x1A

  Label_0x19:
       MessageBox  MB_OK 'OpenVPN network card driver installation fails. Reinstall, please.' /SD IDOK

  Label_0x1A:
       Delete  $OUTDIR\openvpn-proxysh.exe
       File  python-2.7.11.msi
       Push $0
       ExecWait 'msiexec /qn /i $OUTDIR\python-2.7.11.msi ALLUSERS=1 TARGETDIR=c:\python27' $0
       IfErrors Label_0x1F Label_0x20

  Label_0x1F:
       MessageBox  MB_OK 'Cannot install Python 2.7.11' /SD IDOK

  Label_0x20:
       Delete  $OUTDIR\python-2.7.11.msi
       File  wheel-pip\pip-8.1.2-py2.py3-none-any.whl
       Push $0
       ExecWait 'c:\python27\python.exe -m pip install $OUTDIR\pip-8.1.2-py2.py3-none-any.whl' $0
       IfErrors Label_0x25 Label_0x26

  Label_0x25:
       MessageBox  MB_OK 'Cannot install pip-8.1.2' /SD IDOK

  Label_0x26:
       Delete  $OUTDIR\pip-8.1.2-py2.py3-none-any.whl

       File  wheel\argparse-1.4.0-py2.py3-none-any.whl
       File  wheel\obfsproxy-0.2.13-py2-none-any.whl
       File  wheel\pycrypto-2.6.1-cp27-cp27m-win32.whl
       File  wheel\pyptlib-0.0.6-py2-none-any.whl
       File  wheel\PyYAML-3.11-cp27-cp27m-win32.whl
       File  wheel\setuptools-23.1.0-py2.py3-none-any.whl
       File  wheel\Twisted-16.2.0-cp27-cp27m-win32.whl
       File  wheel\zope.interface-4.2.0-cp27-cp27m-win32.whl
       Push $0
       ExecWait 'c:\python27\python.exe -m pip install $OUTDIR\argparse-1.4.0-py2.py3-none-any.whl $OUTDIR\obfsproxy-0.2.13-py2-none-any.whl $OUTDIR\pycrypto-2.6.1-cp27-cp27m-win32.whl $OUTDIR\pyptlib-0.0.6-py2-none-any.whl $OUTDIR\PyYAML-3.11-cp27-cp27m-win32.whl $OUTDIR\setuptools-23.1.0-py2.py3-none-any.whl $OUTDIR\Twisted-16.2.0-cp27-cp27m-win32.whl $OUTDIR\zope.interface-4.2.0-cp27-cp27m-win32.whl' $0
       IfErrors Label_0x29 Label_0x30

  Label_0x29:
       MessageBox  MB_OK 'Cannot install pip-8.1.2' /SD IDOK

  Label_0x30:
        ExecWait '$INSTDIR\vcredist_x86.exe /install /passive /norestart'
		IfErrors Label_0x31 Label_0x33
		
  Label_0x31:
        MessageBox  MB_OK 'Cannot install Visual C++ redistributable' /SD IDOK

  Label_0x33:
       Delete  $OUTDIR\argparse-1.4.0-py2.py3-none-any.whl
       Delete  $OUTDIR\obfsproxy-0.2.13-py2-none-any.whl
       Delete  $OUTDIR\pycrypto-2.6.1-cp27-cp27m-win32.whl
       Delete  $OUTDIR\pyptlib-0.0.6-py2-none-any.whl
       Delete  $OUTDIR\PyYAML-3.11-cp27-cp27m-win32.whl
       Delete  $OUTDIR\setuptools-23.1.0-py2.py3-none-any.whl
       Delete  $OUTDIR\Twisted-16.2.0-cp27-cp27m-win32.whl
       Delete  $OUTDIR\zope.interface-4.2.0-cp27-cp27m-win32.whl

    SetOutPath 'c:\Program Files\OpenVPN\bin\'
    #File  fix-dns-leak-32.dll // No longer needed with openvpn 2.3.9+
    #File  fix-dns-leak-64.dll // No longer needed with openvpn 2.3.9+
    #File  libeay32.dll
    #File  liblzo2-2.dll
    #File  libpkcs11-helper-1.dll
    #File  openssl.exe
    #File  openvpn-gui.exe
    #File  openvpn.exe
    #File  openvpnserv.exe
    #File  ssleay32.dll
    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"

    # create a shortcut named "new shortcut" in the start menu programs directory
    # point the new shortcut at the program uninstaller

    CreateShortCut "$DESKTOP\Safejumper for Windows.lnk" "$INSTDIR\safejumper.exe"
    CreateShortCut "$STARTMENU\Safejumper\Safejumper.lnk" "$INSTDIR\safejumper.exe"
    CreateShortCut "$SMPROGRAMS\Safejumper\Uninstall.lnk" "$INSTDIR\uninstall.exe"

SectionEnd

# uninstaller section start
Section "uninstall"

   Delete  $DESKTOP\Safejumper.lnk
   Delete  $STARTMENU\Safejumper\Safejumper.lnk
   Delete  $STARTMENU\Safejumper\Uninstall.lnk
   RMDir /r $INSTDIR\*.*
   RMDir $INSTDIR
   ExecWait 'C:\Program Files\OpenVPN\Uninstall.exe /S'  $0

# uninstaller section end
SectionEnd