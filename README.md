# SambaDemo

//导入kxSMB文件夹
//导入libz、libiconv、libresolve库
//httpServe文件夹的目的是手机建立httpServer，这样Samba协议投播视频时相当于请求本地服务器
//在appDelegate内输入samba账户名和密码
//参考https://github.com/inoccu/SambaClient_iOS
//参考 https://github.com/FlameGrace/EasySamba

samba库使用最新xcode打包生成，其过程比较繁琐。最新xcode已经去掉了很多c语言下的执行文件比如extern.h，所以编译该库的时候我使用的是xcode8.2，且该库需要将bitcode设置为NO。<br>
亲测在Xcode9.2下可正常使用<br>
`一定要保证你的应用已经允许使用的网络权限`
