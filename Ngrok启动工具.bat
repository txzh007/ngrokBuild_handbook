@echo OFF
color 0a
Title Ngrok�������� by:Tan.
Mode con cols=109 lines=30
:START
ECHO.
Echo                  ==========================================================================
ECHO.
Echo                                          Ngrok�ͻ�����������
ECHO.
ECHO.
ECHO.
Echo                                              ����:Tan.
ECHO.
ECHO.                                        
ECHO.
Echo                  ==========================================================================
Echo.
echo.
echo.
:TUNNEL
Echo               ������Ҫ����������ǰ׺���硰aa�� ������͸����Ϊ����aa.ngrok.tanxin.link��
Echo               �˿�Nginx�Ѵ���8888 ,��Ĭ��Ϊ80  ��������ַΪ http://aa.ngrok.tanxin.link
ECHO.
ECHO.
set /p clientid=   ��������ӳ��ǰ׺��
ECHO.
ECHO.
set /p port=   ��������ӳ��˿ڣ�
echo.
ngrok -config=ngrok.cfg -subdomain %clientid% %port%
PAUSE
goto TUNNEL

