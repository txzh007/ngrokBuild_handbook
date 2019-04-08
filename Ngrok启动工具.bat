@echo OFF
color 0a
Title Ngrok启动工具 by:Tan.
Mode con cols=109 lines=30
:START
ECHO.
Echo                  ==========================================================================
ECHO.
Echo                                          Ngrok客户端启动工具
ECHO.
ECHO.
ECHO.
Echo                                              作者:Tan.
ECHO.
ECHO.                                        
ECHO.
Echo                  ==========================================================================
Echo.
echo.
echo.
:TUNNEL
Echo               输入需要启动的域名前缀，如“aa” ，即穿透域名为：“aa.ngrok.tanxin.link”
Echo               端口Nginx已代理8888 ,现默认为80  即访问网址为 http://aa.ngrok.tanxin.link
ECHO.
ECHO.
set /p clientid=   请输入需映射前缀：
ECHO.
ECHO.
set /p port=   请输入需映射端口：
echo.
ngrok -config=ngrok.cfg -subdomain %clientid% %port%
PAUSE
goto TUNNEL

