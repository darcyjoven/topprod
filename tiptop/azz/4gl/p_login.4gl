# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_login.4gl 
# Descriptions...: 登录情况

import os


DATABASE ds
 
GLOBALS "../../config/top.global"


# 资料定义 s---
type group1 record
   gem01    like gem_file.gem01,
   gem02    like gem_file.gem02,
   zyw01    like zyw_file.zyw01,
   zyw02    like zyw_file.zyw02,
   gbo02    like gbo_file.gbo02,
   gbo03    integer,
   right    integer
end record
type gen record
   gen01     varchar(10),
   gen02     varchar(100),
   ip        varchar(20),
   dat       date,
   tim       varchar(10)
end record
type process record
   chk         boolean,
   pid         varchar(20),
   shell       varchar(1000),
   dat_1       date,
   tim_1       varchar(10)
end record
type license  record
      uuid      varchar(40),
      dat       date,
      ip        varchar(20),
      pid       varchar(10),
      startdat  date,
      starttim  varchar(10),
      cmd       varchar(1000)
end record
# 资料定义 e---

# s ---
define g_path     varchar(1000)
define g_file     varchar(100)
define g_cnt,l_ac       integer
define g_group     dynamic array of group1
define g_gen       dynamic array of gen
define g_process   dynamic array of process
define g_uuid      varchar(40)
define g_flag      varchar(10)
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
 
   open window p_login_w with form "azz/42f/p_login" 
        attribute(style=g_win_style clipped)
   call cl_ui_init()
   
   call p_login_license()
   -- call p_login_history_parse()

   close window p_login_w
   call cl_used(g_prog, g_time, 2) returning g_time 
END MAIN

function p_login()

end function

# license 占用进程
function p_login_license()

   while true
      call p_login_license_parse()
      call p_login_license_bp()
       
      if g_action_choice = 'exit' then
         exit while
      end if
   end while

end function

function p_login_license_bp()
   dialog attributes(unbuffered)
      display array g_group to s_group.*
         before row
            let l_ac = arr_curr()
         after row
            call p_login_license_fill_gen(g_uuid,g_group[l_ac].gem01)
      end display

      display array g_gen to s_gen.*
         before row
            let l_ac = arr_curr()
         after row
            call p_login_license_fill_process(g_uuid,g_gen[l_ac].gen01)
      end display

      input array g_process from s_process.* attribute(count=1,maxcount=g_max_rec,
                                                       insert row=false,delete row=false,append row=false)

      end input

      on action kill
         call p_login_license_kill()
         continue dialog
      on action page2
         let g_flag = 'page2'
         exit dialog
      on action page3
         let g_flag = 'page3'
         exit dialog

      on action help
         call cl_show_help()
         continue dialog
      on action exit
         let g_action_choice="exit"
         exit dialog
      on action controlg
         call cl_cmdask()
         continue dialog
      on idle g_idle_seconds
         call cl_on_idle()
         continue dialog
      on action close
         let g_action_choice = 'close'
         exit dialog


   end dialog
end function

function p_login_license_kill()
   define i integer
   define l_cmd  string

   for i = 1 to g_process.getLength()
      let l_cmd = 'kill -9 ', g_process[i].pid
      run l_cmd
   end for
   call p_login_license_fill_group(g_uuid)
   message "已结束"
end function

function p_login_license_parse()
   define   l_sql,l_cmd,l_str,l_temp    string
   define   l_channel     base.Channel
   define   l_tok,l_tok1         base.StringTokenizer
   define   l_license     license
   define   l_hostname    varchar(1000)
   define   l_usr         varchar(100)
   define   l_day,l_month,l_year,i  integer

   let l_cmd = "/u1/usr/tiptop/license/parse.sh > /u1/usr/tiptop/output.txt"
   run l_cmd

   let l_channel = base.channel.create()
   call l_channel.openfile("/u1/usr/tiptop/output.txt","r")

   initialize l_license.* to null
      -- uuid      varchar(40),
      -- dat       date,
      -- ip        varchar(20),
      -- pid       varchar(10),
      -- startdat  date,
      -- starttim  varchar(10),
      -- cmd       varchar(1000)
   let l_license.uuid = cs_uuid()
   let g_uuid = l_license.uuid
   let l_license.dat = g_today

   begin work
   let g_success = 'Y'
   while true
      let l_str = l_channel.readline()
      if l_channel.iseof() then
         exit while
      end if
      -- 192.168.2.224;FLY-PC-0002-PC;yuanliaocang;25657
      message l_str

      let l_tok = base.StringTokenizer.create(l_str, ';')
      let l_license.ip = l_tok.nextToken()
      let l_hostname = l_tok.nextToken()
      let l_usr = l_tok.nextToken()
      let l_license.pid = l_tok.nextToken()
      
      let l_temp = p_login_cmd(sfmt("ps -p %1 -o lstart --no-headers",l_license.pid))
      -- Mon Dec  1 15:01:38 2025
      let l_tok1 = base.StringTokenizer.create(l_temp, ' ')
      let l_license.starttim = l_tok1.nextToken()
      let l_month = p_login_getmonth(l_tok1.nextToken())
      let l_day = l_tok1.nextToken()
      let l_license.starttim = l_tok1.nextToken()
      let l_year = l_tok1.nextToken()
      let l_license.startdat = mdy(l_month, l_day, l_year)      
      
      let l_license.cmd = p_login_cmd(sfmt("ps -p %1 -o cmd --no-headers",l_license.pid))
      insert into login_license (uuid,dat,ip,pid,startdat,starttim,cmd)
      values (l_license.uuid,l_license.dat,l_license.ip,l_license.pid,l_license.startdat,l_license.starttim,l_license.cmd)
      if sqlca.sqlcode then
         let g_success = 'N'
         call cl_err('ins license',sqlca.sqlcode,1)
         goto _error
      end if

      select count(*) into i from login_ip where ip = l_license.ip
      if i > 0 then
         update login_ip set usr = l_usr,hostname = l_hostname where ip = l_license.ip
      else
         insert into login_ip (ip,usr,hostname) values(l_license.ip,l_usr,l_hostname)
      end if
      if sqlca.sqlcode then
         let g_success = 'N'
         call cl_err('ins ip',sqlca.sqlcode,1)
         goto _error
      end if
   end while

   delete from login_gbq
   insert into login_gbq select * from gbq_file

   label _error:
   if g_success = 'N' then
      rollback work
   else
      commit work
   end if

   call p_login_license_fill_group(l_license.uuid)

end function
function p_login_license_fill_group(p_uuid)
   define   p_uuid      varchar(40) 
   define   l_sql       string

   let l_sql = " select gem01,gem02,zyw01,zyw02,gbo02,gbo03,count(unique ip) cnt",
               "   from login_license",
               "   left join login_gbq on pid = gbq01",
               "   left join zyw_file on zyw03 = gbq05",
               "   left join gem_file on gbq05 = gem01",
               "   left join gbo_file on gbo01 =  zyw01 ",
               "  where uuid = ? ",
               "  group by gem01,gem02,zyw01,zyw02,gbo02,gbo03",
               " order by gem01"
   prepare p_login_fill from l_sql
   declare p_login_fill_cur cursor for p_login_fill

   let g_cnt = 1
   call g_group.clear()
   foreach p_login_fill_cur using p_uuid into g_group[g_cnt].*
      if sqlca.sqlcode then
         call cl_err('p_login_fill',sqlca.sqlcode,1)
         exit foreach
      end if
      let g_cnt = g_cnt + 1
   end foreach
   call g_group.deleteElement(g_cnt)
   let g_cnt = g_cnt - 1

   if g_cnt > 0 then
      call p_login_license_fill_gen(p_uuid,g_group[1].gem01)
   end if

end function
function p_login_license_fill_gen(p_uuid,p_gem01)
   define l_sql   string
   define p_uuid,p_gem01   varchar(40)

   let l_sql = "select gbq03,zx02,ip,min(startdat) mindat,",
               "        MIN(starttim) KEEP (DENSE_RANK FIRST ORDER BY startdat, starttim) AS mintim",
               "  from login_license",
               "  left join gbq_file on pid = gbq01",
               "  left join zx_file on zx01 = gbq03",
               "  left join zyw_file on zyw03 = gbq05",
               "  left join gem_file on gbq05 =gem01",
               "  left join gbo_file on gbo01 =  zyw01 ",
               " where uuid = '",p_uuid,"' and gem01 = '",p_gem01,"'",
               " group by gbq03,zx02,ip",
               " order by gbq03"
   prepare p_login_fill2 from l_sql
   declare p_login_fill2_cur cursor for p_login_fill2
   
   let g_cnt = 1
   call g_gen.clear()
   foreach p_login_fill2_cur into g_gen[g_cnt].*
      if sqlca.sqlcode then
         call cl_err('p_login_fill2',sqlca.sqlcode,1)
         exit foreach
      end if
      let g_cnt = g_cnt + 1
   end foreach
   call g_gen.deleteElement(g_cnt)
   let g_cnt = g_cnt - 1
   if g_cnt > 0 then
      call p_login_license_fill_process(p_uuid,g_gen[1].gen01)
   end if
end function

function p_login_license_fill_process(p_uuid,p_gen01)
   define    l_sql    string
   define    p_uuid,p_gen01    varchar(40)

   let l_sql = " select 'Y',pid,cmd, startdat,starttim ",
               "  from login_license",
               "  left join gbq_file on pid = gbq01",
               "  left join zx_file on zx01 = gbq03",
               "  left join zyw_file on zyw03 = gbq05",
               "  left join gem_file on gbq05 =gem01",
               "  left join gbo_file on gbo01 =  zyw01 ",
               " where uuid = '",p_uuid,"' and gbq03 = '",p_gen01,"' ",
               "  order by startdat,starttim"
   prepare p_login_fill3 from l_sql
   declare p_login_fill3_cur cursor for p_login_fill3
   
   let g_cnt = 1
   call g_process.clear()
   foreach p_login_fill3_cur into g_process[g_cnt].*
      if sqlca.sqlcode then
         call cl_err('p_login_fill3',sqlca.sqlcode,1)
         exit foreach
      end if
      let g_cnt = g_cnt + 1
   end foreach
   call g_process.deleteElement(g_cnt)
   let g_cnt = g_cnt - 1
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

   call p_login_history_archive()
   call p_login_history_read(g_file)

   delete from login_history where dat < g_today - 30

end function

# 归档文件解析
function p_login_history_archive()
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
   define l_line,i,l_lastLine  integer
   
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
   define l_dat date 

   if p_file == g_file then
      let l_size = p_login_cmd('stat -c %s '||sfmt('%1/%2',g_path,p_file))
      initialize l_offset.* to null
      select hdat,siz,line into l_offset.dat,l_offset.siz,l_offset.line
        from login_offset where filename = g_file
      if sqlca.sqlcode or cl_null(l_offset.line) then
         let l_line = 0
      else
         # 实时日志，如果 1.第一行日期变了 2.size变小 行数重置为0
         # 日期判断
         let l_str = p_login_cmd('head -n 1 '||sfmt('%1/%2',g_path,p_file))
         
         initialize l_history.* to null
         call p_login_history_getdate(l_str) returning l_history.ip,l_history.dat,l_history.tim
         if cl_null(l_offset.dat) or l_history.dat != l_offset.dat then
            let l_line = 0
         else
            # size 判断
            if l_size < l_offset.siz or cl_null(l_offset.siz) then
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
      call p_login_history_getdate(l_str) returning l_history.ip,l_history.dat,l_history.tim
      
      if l_history.dat < l_offset.dat then
         return
      end if
      # 判断首行是否晚于解析日期，是的话，全部处理
      initialize l_history.* to null
      let l_str = p_login_cmd('head -n 1 '||sfmt('%1/%2',g_path,p_file))
      call p_login_history_getdate(l_str) returning l_history.ip,l_history.dat,l_history.tim
      
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
   let l_lastLine = p_login_cmd('wc -l < '||sfmt("%1/%2",g_path,p_file))
   let l_str =  "/u1/usr/tiptop/http/parse.sh ",l_line," ",sfmt("%1/%2",g_path,p_file)," ","/u1/usr/tiptop/output.txt"
   run l_str 

   call p_login_history_ins()
   let l_dat = l_history.dat
   -- 最后一行
   initialize l_history.* to null
   let l_str = p_login_cmd('tail -n 1 '||sfmt('%1/%2',g_path,p_file))
   call p_login_history_getdate(l_str) returning l_history.ip,l_history.dat,l_history.tim

   if p_file = g_file then
      # 这是实时日志
      # 第一行的日期
      # 最后一行的行数

      select count(*) into i from login_offset
       where filename = p_file
      if i > 0 then
         update login_offset
            set line = l_lastLine,
                siz = l_size,
                dat =  l_history.dat,
                tim = l_history.tim,
                hdat = l_dat
         where filename = p_file
      else
         insert into login_offset(filename,line,siz,dat,tim,hdat)
         values(p_file,l_lastLine,l_size,l_history.dat,l_history.tim,l_dat)
      end if
   else
      # 归档日志
      insert into login_offset(filename,line,siz,dat,tim)
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
function p_login_history_getdate(p_str)
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

# 将文件内容解析并插入到数据库
function p_login_history_ins()
   define l_history record
      ip    varchar(20),
      dat   date,
      seq   decimal(5),
      cnt   decimal(10)
   end record
   define l_old record
      ip    varchar(20),
      dat   date,
      seq   decimal(5),
      cnt   decimal(10)
   end record
   define l_channel     base.Channel
   define l_str         string
   define l_tok         base.StringTokenizer
   define i             integer

   declare history_cur cursor with hold for insert into login_history values (l_history.*)
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

      initialize l_old.* to null
      select * into l_old.* from login_history
       where ip = l_history.ip
         and dat = l_history.dat
         and seq = l_history.seq
      if not cl_null(l_old.ip) then
         if l_history.cnt > l_old.cnt then
            update login_history
               set cnt = l_history.cnt
             where ip = l_history.ip
               and dat = l_history.dat
               and seq = l_history.seq 
         end if
      else
         put history_cur
      end if
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


-- fglWrt -a info users | awk '
-- function flush() {
--     if (proc_id != "" && user != "" && host_addr != "" && host_name != "") {
--         print host_addr ";" host_name ";" user ";" proc_id
--     }
--     user = ""; host_addr = ""; host_name = ""; proc_id = ""
-- }

-- /^[[:space:]]*GUI Server [0-9.:]+ - Process Id [0-9]+/ {
--     flush()
--     # 提取 Process Id：最后一个字段就是 PID
--     proc_id = $NF
--     next
-- }

-- proc_id != "" && /^[[:space:]]+user-name:[[:space:]]+/ {
--     sub(/^[[:space:]]+user-name:[[:space:]]+/, "")
--     user = $0
-- }
-- proc_id != "" && /^[[:space:]]+host-addr:[[:space:]]+/ {
--     sub(/^[[:space:]]+host-addr:[[:space:]]+/, "")
--     host_addr = $0
-- }
-- proc_id != "" && /^[[:space:]]+host-name:[[:space:]]+/ {
--     sub(/^[[:space:]]+host-name:[[:space:]]+/, "")
--     host_name = $0
-- }

-- END {
--     flush()
-- }'
