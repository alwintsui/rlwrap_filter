rlwrap filters for gnuplot and grace
=====================

项目简介
-----------
本项目为GNUPlot和Grace设计rlwrap filter脚本，实现GNUPlot和Grace的命令行单词智能补齐功能。

GNUPlot和Grace是Unix-like操作系统下两个流行数据绘图工具，并且都支持命令行交互式操作，但命令行的单词自动补齐和命令历史检索功能缺失或不足，
导致用户的命令行交互受到诸多不便，有幸可通过rlwrap工具可以增强命令行交互功能。rlwrap工具一个特别的软件工具，它可以包装运行任意一个命令程序，
特别是具有交互式的命令行工具。使得原程序能提供命令关键字或文件名的自动补齐功能，还提供历史命令行的检索功能等等。

例如，简单包装grace命令的调用方式为rlwrap -a -A -c grace，就可以在命令行上补齐引号后的文件，并且能使用上下键检索历史命令。
还可以添加-f参数来指定一个字典，它用来为命令行上单词自动补齐，很大地提高了命令行操作的有效性；但仅仅通过-f提供一个全局的单词库，实现自动补齐还不够。

有时我们需要识别当前命令的前缀，实现提示下级补齐单词范围更准确，我们希望rlwrap的这种工作方式更智能。
为了优化rlwrap操控GNUPlot和Grace的特性。这就是需要通过rlwrap的filter功能来实现，使用rlwrap -z listing命令查看当前已经安装的filter。
filter是一个perl格式的可执行文件，它可以调用rlwrap提供的一个预制的类库，来操作rlwrap工作流程。
基于这个原理框架我们可以实现自定义的filter，从而达到实现多级命令自动智能补齐的目的。

当前GNUPlot和Grace相关智能补齐功能的rlwrap filters尚未发现，本项目实现了grace和gunplot两个脚本文件，实现智能补齐这个功能。

安装方法
-----------
首先rlwrap必须已经安装，例Ubuntu为例，使用命令行：
```Bash
sudo apt-get install rlwrap
```
就可以了。将新设计grace和gunplo脚本拷贝到路径/usr/share/rlwrap/filters/，这个路径是rlwrap的filters路径，不同系统上可能不同，需要预先确认。
使用命令行
```Bash
sudo cp grace /usr/share/rlwrap/filters/grace
sudo cp gnuplot /usr/share/rlwrap/filters/gnuplot
sudo chmod +x /usr/share/rlwrap/filters/grace
sudo chmod +x /usr/share/rlwrap/filters/gnuplot
```
grace和gnuplot是Perl脚本，需要修改为可执行属性，否则无法识别。
再使用rlwrap命令查看是否安装成功。
```Bash
rlwrap -z listing
```
![rlwrap_filter] (res/rlwrap_filter.png "rlwrap_filter")

列出当前filter，其中应该显示grace

使用操作
-----------
调用方式：
**grace**命令：
```Bash
rlwrap -a -A -z grace -c -pGreen  grace
```
**gnuplot**命令：
```Bash
rlwrap -a -A -z gnuplot -c -pGreen  gnuplot
```

其中-c表示加入当前目录下的文件名自动补齐字典，-pGreen对命令的提示符号promote设置一个颜色，我们用来区别原生的grace
-z grace调用名为grace的filter，最后的grace为原生grace程序名。GNUPlot也是一样的调用。
我们还可以在bashrc中加入
```Bash
alias grace='rlwrap -a -A -z grace -c -pBlue grace'
alias gnuplot='rlwrap -a -A -z gnuplot -c -pBlue gnuplot'
```
直接重命名grace

通过以上操作设置之后，我们就可以在命令行调用gunplot和grace命令，进入交互界面。提示符被设置了所选择的颜色，
另外输入命令的前几个字母，按tab键就可以进行自动补齐。

![rlwrap_grace] (res/rlwrap_grace.png "rlwrap_grace")
![rlwrap_gnuplot] (res/rlwrap_gnuplot.png "rlwrap_gnuplot")

Contact
=====
Author: Shun Xu <AlwinTsui@gmail.com>
Date: December 12, 2014
