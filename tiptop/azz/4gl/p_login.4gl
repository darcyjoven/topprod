# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_login.4gl 
# Descriptions...: 登录情况

import os


DATABASE ds
 
GLOBALS "../../config/top.global"


# 资料定义 s---
type tree record
   parent      varchar(20),   -- 父亲节点
   item        varchar(20),   -- 节点（部门、账号、作业编号）
   descripe    string,        -- 节点名称 
   children    boolean,       -- 是否含子节点
   expand      boolean,       -- 展开否
   level       integer,       -- 层级
   path        string,        -- 路径
   --- 
   cnt         integer,       -- 计数
   pid         varchar(10),   -- 进程pid
   btime       varchar(20),   -- 开始时间
   duration    varchar(20)    -- 耗时
end record
-- 登录时长统计
type used record
   gen01       varchar(10),
   gen02       varchar(20),
   gem01       varchar(10),
   gem02       varchar(40),
   stime       decimal(15,3), -- 登录时长
   sday        integer        -- 登录天数
end record
type login record
   ip       varchar(20),
   dat      date,
   seq      decimal(5),
   cnt      decimal(10)
end record
# 资料定义 e---

# s ---
define g_path     varchar(1000)
define g_file     varchar(100)
# e ---

MAIN
   options 
       input no wrap
   defer interrupt
 
   if (not cl_user()) then
      exit program
   end if
  
   whenever error call cl_err_msg_log
  
   if (not cl_setup("AZZ")) then
      exit program
   end if
 
   call cl_used(g_prog, g_time, 1) returning g_time 
 
   -- open window p_login_w with form "azz/42f/p_login" 
   --      attribute(style=g_win_style clipped)
   -- call cl_ui_init()
   
   -- close window p_login_w
   call p_login_history_parse()

   call cl_used(g_prog, g_time, 2) returning g_time 
END MAIN

function p_login()

end function

# license 占用进程
function p_login_license()
   # 授权占用 登录时长

   # 明细
   # 部门合计

   # 授权人数 vs 登录人数 
end function

# runtime 运行时长统计 p_used
function p_login_runtime()
   # 平均白、夜 登录时长 
   #     平均时间/登录天数 = 平均每日登录时长

   # 最近一周、一月、一年

   # 群组理论授权人数
end function

# 登录统计 历史登录次数
function p_login_history()
   # 最近一周、月 ip 登录次数
   # 今天登录次数
   # 热点图
end function

# 解析http访问日志
function p_login_history_parse()
   define last_line,last_size,l_size,l_line        decimal(10)
   define last_date,l_date                         date
   define l_file                                   string

   let g_path = '/etc/httpd/logs'
   let g_file = 'ssl_access_log'
   # 取所有归档文件名，未解析去解析
   # 解析 /etc/httpd/logs/ssl_access_log 未解析部分
   # 删除30天之前的记录

   call p_login_archive()
   call p_login_history_read(g_file)

   delete from login_history where dat < g_today - 30

end function

# 归档文件解析
function p_login_archive()
   define h,i,j       integer
   define child   varchar(1000)
   
   
   if not os.path.exists(g_path) then
      return
   end if

   if not os.path.isDirectory(g_path) then
      message os.path.basename(g_path)
      return
   end if

   call os.path.dirsort("name", 1)
   let h = os.path.diropen(g_path)
   while h > 0
      let child = os.path.dirNext(h)
      if child is null then 
         exit while
      end if
      if child == "." or child == ".." then
         continue while
      end if
      if child not matches g_file||'*' or child == g_file then
         continue while
      end if
      # 判断是否解析过
      select count(*) into i from login_offset where filename = child
      if i > 0 then
         continue while
      end if
      # 开始处理
      call p_login_history_read(child)
   end while

   call os.path.dirclose(h)

end function

# 处理单个文件
function p_login_history_read(p_file)
   define p_file  varchar(200)
   define p_date  date
   define l_line  integer
   
   define l_str   string
   define l_temp  varchar(100)
   define l_size  decimal(10)
   define l_offset record
      line decimal(10),
      dat   date,
      siz   decimal(10),
      tim   varchar(10)
   end record
   define l_history record
      ip     varchar(20),
      dat    date,
      tim    varchar(10),
      seq    decimal(5),
      cnt    decimal(10)
   end record

   if p_file == g_file then
      initialize l_offset.* to null
      select dat,siz,line into l_offset.dat,l_offset.siz,l_offset.line
        from login_offset where filename = g_file
      if sqlca.sqlcode or cl_null(l_offset.line) then
         let l_line = 0
      else
         # 实时日志，如果 1.第一行日期变了 2.size变小 行数重置为0
         # 日期判断
         let l_str = p_login_cmd('head -n 1 '||sfmt('%1/%2',g_path,p_file))
         
         initialize l_history.* to null
         call p_login_getdate(l_str) returning l_history.ip,l_history.dat,l_history.tim
         if cl_null(l_offset.dat) or l_history.dat != l_offset.dat then
            let l_line = 0
         else
            # size 判断
            let l_size = p_login_cmd('stat -c %s '||sfmt('%1/%2',g_path,p_file))
            if l_size <> l_offset.siz or cl_null(l_offset.siz) then
               let l_line = 0
            else
               # 否则从上次行数开始
               let l_line = l_offset.line
            end if
         end if
      end if
   else
      initialize l_offset.* to null
      select max(dat) into l_offset.dat from login_offset
      if not cl_null(l_offset.dat) then
         select max(tim) into l_offset.tim from login_offset
         where dat = l_offset.dat
      end if
      # 判断末行日期是否早于解析日期，是的话不处理
      initialize l_history.* to null
      let l_str = p_login_cmd('tail -n 1 '||sfmt('%1/%2',g_path,p_file))
      call p_login_getdate(l_str) returning l_history.ip,l_history.dat,l_history.tim
      
      if l_history.dat < l_offset.dat then
         return
      end if
      # 判断首行是否晚于解析日期，是的话，全部处理
      initialize l_history.* to null
      let l_str = p_login_cmd('head -n 1 '||sfmt('%1/%2',g_path,p_file))
      call p_login_getdate(l_str) returning l_history.ip,l_history.dat,l_history.tim
      
      if l_history.dat > l_offset.dat then
         let l_line = 0
      else
         if cl_null(l_offset.dat) then
            let l_line = 0
         else
            # 否则 ，找到日期+小时+分钟出现的行数开始处理
            -- awk '$0 ~ /\[28\/Nov\/2025:10/ { print NR; exit }' ssl_access_log
            let l_str = sfmt("awk '$0 ~ /\[%1\/%2\/%3:%4/ { print NR; exit }' %5",
                           day(l_offset.dat) using '&&',
                           l_offset.dat using 'Mon',
                           year(l_offset.dat) using '&&&&',
                           l_offset.tim[1,2],
                           sfmt("%1/%2",g_path,p_file) )
            let l_line = p_login_cmd(l_str)
            if cl_null(l_line) then
               let l_line = 0
            end if
         end if
      end if
   end if

   # 将文件符合的行抓取到文件~/output.txt 中
   -- grep 'GET /gas/ja/r/gdc-tiptop-udm-intranet' /etc/httpd/logs/ssl_access_log-20251102 >> output.log
   -- tail -n +100001 /etc/httpd/logs/ssl_access_log-20251102 | grep 'GET /gas/ja/r/gdc-tiptop-udm-intranet' >> /u1/usr/tiptop/output.txt
   let l_line = p_login_cmd('wc -l < '||sfmt("%1/%2",g_path,p_file))
   let l_str =  "/u1/usr/tiptop/parse.sh ",l_line," ",sfmt("%1/%2",g_path,p_file)," ","/u1/usr/tiptop/output.txt"
   run l_str 

   call p_login_ins()

   if p_file = g_file then
      # 这是实时日志
      # 第一行的日期
      # 最后一行的行数
      insert into login_offset (filename,line,siz,dat,tim)
       values(p_file,l_line,l_size,l_history.dat,'')
   else
      # 归档日志
      initialize l_history.* to null
      let l_str = p_login_cmd('tail -n 1 '||sfmt('%1/%2',g_path,p_file))
      call p_login_getdate(l_str) returning l_history.ip,l_history.dat,l_history.tim

      insert into login_offset (filename,line,siz,dat,tim)
       values(p_file,0,0,l_history.dat,l_history.tim)
   end if


end function

# 命令单行结果
function p_login_cmd(p_cmd)
   define p_cmd,ls_result           string
   define l_channel                 base.Channel

   let l_channel = base.channel.create()
   call l_channel.openpipe(p_cmd, "r")

   if l_channel.read(ls_result) then
      return ls_result
   end if
   return ""
end function

# 从字符串获取ip、日期、时间
function p_login_getdate(p_str)
   define p_str string
   define l_ip     varchar(20)
   define l_dat    date
   define l_tim    varchar(10)
   define l_tok    base.StringTokenizer
   define l_temp   varchar(200) 

   -- 192.168.41.74 - - [23/Nov/2025:03:18:04 +0800] "POST /gas/ja/sua/2b0fdd4b6a67cf52dd71af016aecf9bd?appId=3&pageId=11 HTTP/1.1" 200 59

   # ip
   let l_tok = base.StringTokenizer.create(p_str, ' ')
   if l_tok.hasMoreTokens() then
      let l_ip = l_tok.nextToken()
   end if 

   # 日期&时间
   let l_tok = base.StringTokenizer.create(p_str, '[')
      -- 23/Nov/2025:03:18:04 +0800] "POST /gas/ja/sua/2b0fdd4b6a67cf52dd71af016aecf9bd?appId=3&pageId=11 HTTP/1.1" 200 59
   let l_temp = l_tok.nextToken()
   let l_temp = l_tok.nextToken()
   let l_tim = l_temp[13,20]
   let l_temp = l_temp[1,11]

   let l_dat = mdy(p_login_getmonth(l_temp[4,7]),l_temp[1,2],l_temp[8,11])

   return l_ip,l_dat,l_tim
end function

function p_login_getmonth(p_str)
   define p_str varchar(3)

   case p_str
   when 'Jan'
      return 1
   when 'Feb'
      return 2
   when 'Mar'
      return 3
   when 'Apr'
      return 4
   when 'May'
      return 5
   when 'Jun'
      return 6
   when 'Jul'
      return 7
   when 'Aug'
      return 8
   when 'Sep'
      return 9
   when 'Oct'
      return 10
   when 'Nov'
      return 11
   when 'Dec'
      return 12
   otherwise
      return 0
   end case
end function

# 时间转为第几个5分钟
function p_login_minute_seq(p_str)
   define p_str    varchar(10)
   define l_seq    decimal(5)
   define l_cnt    decimal(5)

   -- 03:18:04
   
   let l_cnt = p_str[1,2] * 60 + p_str[4,5]
   let l_seq = l_cnt / 5 + 1

   return l_seq
end function

# 将文件内容解析并插入到数据库
function p_login_ins()
   define l_history record
      ip    varchar(20),
      dat   date,
      seq   decimal(5),
      cnt   decimal(10)
   end record
   define l_channel     base.Channel
   define l_str         string
   define l_tok         base.StringTokenizer

   declare history_cur cursor for insert into login_history values (l_history.*)
   begin work
   open history_cur

   let l_channel = base.channel.create()
   call l_channel.openfile("/u1/usr/tiptop/output.txt","r")
   while true
      let l_str = l_channel.readline()
      if l_channel.iseof() then
         exit while
      end if
      message l_str
      let l_tok = base.StringTokenizer.create(l_str, ';')
      let l_history.ip = l_tok.nextToken()
      let l_history.dat = l_tok.nextToken()
      let l_history.seq = l_tok.nextToken()
      let l_history.cnt = l_tok.nextToken()
      put history_cur
      if sqlca.sqlcode then
         exit while
      end if
   end while
   call l_channel.close()

   flush history_cur
   close history_cur
   commit work
   free history_cur
end function

-- #!/bin/bash

-- # 检查参数数量
-- if [ "$#" -ne 3 ]; then
--     echo "用法: $0 <起始行数> <输入日志文件> <输出结果文件>"
--     exit 1
-- fi

-- START_LINE="$1"
-- INPUT_LOG="$2"
-- OUTPUT_FILE="$3"

-- # 检查输入文件是否存在
-- if [ ! -f "$INPUT_LOG" ]; then
--     echo "错误: 输入文件 '$INPUT_LOG' 不存在。"
--     exit 1
-- fi

-- # 执行处理命令
-- tail -n +"$START_LINE" "$INPUT_LOG" | \
-- grep 'GET /gas/ja/r/gdc-tiptop-udm-intranet' | \
-- awk '
-- function m2n(m) {
--     split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", mm, " ")
--     for (i=1; i<=12; i++) months[mm[i]] = sprintf("%02d", i)
--     return months[m]
-- }
-- {
--     ip = $1
--     # 提取并清理时间字段
--     tstr = $4
--     gsub(/^\[|\].*/, "", tstr)  # 得到 "27/Nov/2025:14:09:31"

--     # 分割：只按 / 或 : 切（tstr 中只有这两种符号）
--     n = split(tstr, a, /[:\/]/)

--     if (n < 6) next
--     day   = a[1]
--     mon   = a[2]
--     year  = a[3]
--     hour  = a[4]
--     min   = a[5]

--     month_num = m2n(mon)
--     if (month_num == "") next

--     date_str = year "/" month_num "/" day
--     interval = int((hour * 60 + min) / 5) + 1

--     key = ip ";" date_str ";" interval
--     count[key]++
-- }
-- END {
--     for (k in count) print k ";" count[k]
-- }' | sort > "$OUTPUT_FILE"

-- echo "处理完成，结果已写入: $OUTPUT_FILE"
