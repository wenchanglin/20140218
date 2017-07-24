# 20140218
我的代码库

切换分支：git checkout name
撤销修改：git checkout -- file
删除文件：git rm file
查看状态：git status
添加记录：git add file 或 git add .
添加描述：git commit -m "miao shu nei rong"
同步数据：git pull
提交数据：git push origin name
分支操作
查看分支：git branch
创建分支：git branch name
切换分支：git checkout name
创建+切换分支：git checkout -b name
合并某分支到当前分支：git merge name
删除分支：git branch -d name
删除远程分支：git push origin :name
建立本地Git仓库
cd到你的本地项目根目录下，执行git命令
git init
将本地项目工作区的所有文件添加到暂存区
git add .
如果想添加项目中的指定文件，那就把.改为指定文件名即可  
将暂存区的文件提交到本地仓库
git commit -m ""  冒号里面写注释语句
在Github上创建自己的repository
将本地仓库关联到Github上
git remote add origin GitHub网址
如果出现错误：fatal:remote origin already exists
那就先输入 git remote rm origin
再输入 git remote add origin GitHub网址
git push -u origin master 无错误就成功了
