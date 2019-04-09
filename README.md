# Wake On Lan
iOS和macOS使用幻数据包(Magic Packet)进行网络唤醒(WOL) 。

1、远程开机Wake onLAN(WOL)简介：

俗称远程唤醒，是现在很多网卡都支持的功能。而远程唤醒的实现，主要是向目标主机发送特殊格式的数据包，是AMD公司制作的MagicPacket这套软件以生成网络唤醒所需要的特殊数据包，俗称魔术包（Magic Packet）。MagicPacket格式虽然只是AMD公司开发推广的技术，并非世界公认的标准，但是仍然受到很多网卡制造商的支持，因此许多具有网络唤醒功能的网卡都能与之兼容。原理上我们不用深入,实现上是发一个BroadCast包,包的内容包括以下数据就可以了。FF FF FF FF FF FF，6个FF是数据的开始,紧跟着16次MAC地址就可以了。


2、设置BIOS

首先需要进行BIOS和网卡设置，启动计算机，进入BIOS参数设置。选择电源管理设置“Power Management Setup”选项，将“Wake up on LAN”项和“Wake on PCI Card”项均设置为“Enable”，启用该计算机的远程唤醒功能。 (各个主板不一样，可以在百度上搜索怎么开启你家电脑的主板的远程唤醒功能)


3、获取Mac

通过命令行输入ipconfig/all可以得到Mac地址 00:0B:2F:70:40:9E


4、调用CocoaAsyncSocket的UPD协议将幻数据包发送到要唤醒计算机。
