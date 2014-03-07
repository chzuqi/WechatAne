@echo off
rem 转到当前盘符
%~d0
rem 打开当前目录
cd %~dp0
set SOURCEJAR=com.weixin.ane.jar
set MainJar=weixinsdk.jar
set ExternalJar=libammsdk.jar
set packageName=com
set SWC=MMANE-WeixinSdk.swc
echo =========== start make jar ==============
rem 创建临时目录
md temp
rem 拷贝临时文件
rem copy %SOURCEJAR% %MainJar%
copy .\android\bin\%SOURCEJAR% .\temp\%MainJar% >nul
copy .\android\lib\%ExternalJar% .\temp\ >nul
cd temp
rem 解压第三方包
jar -xf %ExternalJar%
rem 合并主JAR包
jar -uf %MainJar% %packageName% 
rem 拷贝过去ane构建目录
copy %MainJar% ..\ane-build-path\android-ARM >nul
cd ..
rd /s/q temp
echo =========== jar make over,start build ane ==============
copy .\actionscript\bin\%SWC% .\ane-build-path >nul
cd ane-build-path
jar -xf %SWC%
move catalog.xml .\android-ARM\ >nul
move library.swf .\android-ARM\ >nul
echo ===========building ane now ===========================
rem build ane
set FLEX_SDK=D:\AIR_3.9
set FLEX_SDK_BIN= %FLEX_SDK%\bin
set FLEX_LIBS=%FLEX_SDK%\frameworks\libs
java -jar "%FLEX_SDK%\lib\adt.jar" -package -storetype PKCS12 -keystore czq.p12 -storepass 123456 -target ane com.mmsns.ane extension.xml -swc *.swc -platform Android-ARM -C Android-ARM mmiap . 
move com.mmsns.ane ..\ >nul
cd ..
echo =========build complete==========
echo =========打包apk的时候记得把mmiap目录也打包进去，点任意键结束===
pause>nul