# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: cl_used
# Descriptions...: 記錄各程式實際被執行的狀況
# Date & Author..: 90/06/25 By LYS
# Modify.........: No.FUN-4C0024 04/12/07 By Smapmin 將起始執行時間(time1)存入zu_file
# Modify.........: No.MOD-580088 05/08/15 By alex 將 p_code 改為使用 g_prog
# Modify.........: No.FUN-580093 05/09/09 By saki 增加紀錄、刪除process資訊的function
# Modify.........: No.FUN-640184 06/04/20 by Echo 自動執行確認功能
# Modify.........: No.FUN-660135 06/07/12 by saki process增加紀錄database
# Modify.........: No.FUN-690105 06/09/05 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690056 06/09/13 by Brendan 調整紀錄 WEB 執行時的 IP 為實際 Client IP, 而非紀錄 127.0.0.1
# Modify.........: No.FUN-740179 07/06/11 by saki 同一台電腦不同telnet連線,分別記錄資料庫來使用
# Modify.........: No.TQC-780066 07/08/21 by saki 刪除process資料時，IP不需調整FUN-740179的功能
# Modify.........: No.MOD-7C0055 07/12/07 by joyce 避免IP漏掉port，所以加入檢查
# Modify.........: No.MOD-7C0146 07/12/20 by alexstar 日期+斜線共8碼
# Modify.........: No.FUN-960177 09/06/26 by kevin 調整cl_process_check() 符合MSV架構
# Modify.........: No.FUN-980030 09/08/06 by Hiko 刪除sid_file的資訊
# Modify.........: No.FUN-920138 09/08/14 by tsai_yen 部門與部門群組上線人數控管
# Modify.........: No.FUN-980097 09/09/10 by alex 調整wos進入 4gl
# Modify.........: No.MOD-990152 09/12/18 by alex 新增鎖定刪除ps目標
# Modify.........: No.FUN-950082 10/05/03 by alex 加入hostname以判別執行AP Server(抓取hostname)
# Modify.........: No.FUN-A80037 10/08/05 By alex 跨AP顯示完整的gbq_file內容，並予以適當標示非本機process
# Modify.........: No:FUN-AB0111 10/12/07 By Jay 修正在weblogin登入時,營運中心不正常問題
# Modify.........: No:TQC-B10169 11/01/19 By saki 修正process check的效能問題
# Modify.........: No:FUN-BB0068 11/11/15 By jrg542 
#                   1.原有aoos010設定執行程式紀錄移入 aoos900 (全系統共用，與aoos010每營運中心設定的方式不同)
#                   2.原有cl_used調整依循 aoos900 設定 (1:每次都記錄 2:只有個資紀錄 3:不紀錄 ) 來進行系統執行的 log 紀錄 (default 為記錄)
# Modify.........: NO:MOD-BC0109 12/03/16 By madey handle程式執行時間計錄之使用分鐘欄位為null的情況 
# Modify.........: NO:FUN-C30021 12/03/16 by madey 修正跨日使用分鐘數=負數問題
# Modify.........: No:DEV-C50001 12/06/01 By joyce 程式執行紀錄也應寫入p_syslog中
# Modify.........: NO:CHI-C80032 12/08/13 by zack   insert zu_file時,zu02執行日期改抓程式開始執行時的日期
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
   DEFINE  gs_hostname  STRING
END GLOBALS

#DEFINE g_db_type  LIKE type_file.chr3 #FUN-960177  MOD-990152
 
##################################################
# Descriptions...: 記錄各程式實際被執行的狀況
# Input parameter: p_code - 程式代號
#                  time1  - 起始執行時間
#                  sw     - 1:執行開始, RETURN TIME
#                           2:執行結束, INSERT (執行的狀況) TO zu_file
# RETURN code....: time
# Usage .........: call cl_used(p_code,time1,sw)
# Example .......: call cl_used('aom2020','09:30','1')
#                  call cl_used('aom2020','09:40','2')
# Memo...........: 93/05/26 Lee 加上系統參數aza18的判斷, 決定是否記錄使用時間
##################################################
FUNCTION cl_used(p_code,time1,sw)
    DEFINE p_code	LIKE zz_file.zz01,    # VARCHAR(10), MOD-580088
          time1		LIKE type_file.chr8,          #No.FUN-690005 VARCHAR(8),
          sw		LIKE type_file.num5,          #No.FUN-690005 SMALLINT,
          l_date	LIKE type_file.chr8,        #No.FUN-690005 VARCHAR(8),  #MOD-7C0146 VARCHAR(8)
          l_time	LIKE type_file.chr8,          #No.FUN-690005 VARCHAR(8)
          l_time_used	LIKE bnc_file.bnc06        #No.FUN-690005 DECIMAL(8,2)

   DEFINE l_date1 LIKE type_file.dat 
   DEFINE l_date_now   DATE,                 #No:FUN-C30021
          l_date_range LIKE type_file.num5   #No:FUN-C30021
   DEFINE ls_msg_syslog STRING               #No:DEV-C50001
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF sw = 2 THEN
      CALL cl_process_logout()
   END IF
 
   #No:FUN-BB0068 start
   IF cl_null(g_azz.azz11) THEN 
      SELECT * INTO g_azz.* FROM azz_file WHERE azz01='0'
   END IF 
   IF g_azz.azz11 IS NULL THEN      
      LET g_azz.azz11 = '1'    #1:紀錄 2:個資作業紀錄 3:不紀錄
   END IF 
   #No:FUN-BB0068 end
 
   LET p_code = p_code CLIPPED
   IF p_code != g_prog THEN
      LET p_code = g_prog
   END IF
 
   LET l_time = TIME
   
   IF sw = 1 THEN
      LET gs_hostname = ""                      #FUN-950082
      LET gs_hostname = cl_used_ap_hostname()
      LET time1 = l_time

      # No:DEV-C50001 ---start---
      # 因為會有部分必要欄位為null值導致無法寫入的問題，因此先不寫入syslog中   2012/06/27 by joyce
   #  IF g_azz.azz11 = "1" OR g_azz.azz11 = "2" THEN
   #     LET ls_msg_syslog = p_code CLIPPED," is excuted by ",g_user CLIPPED," at ",TODAY," ",time1 CLIPPED
   #     IF cl_syslog("A","G",ls_msg_syslog) THEN END IF
   #  END IF
      # No:DEV-C50001 --- end ---

      RETURN time1
   END IF
 
   IF sw = 2 THEN
      #No:FUN-C30021 mark --start
      #LET l_time_used = l_time[1,2]*60 + l_time[4,5]*1 + l_time[7,8]/60 -
      #                  (time1[1,2]*60 +  time1[4,5]*1 +  time1[7,8]/60)
      #No:FUN-C30021 mark --end

      #No:FUN-C30021 --start 調整公式:增加累計跨天日數
      LET l_date_now = TODAY
      LET l_date_range = l_date_now - g_today
      LET l_time_used = l_date_range*24*60 + l_time[1,2]*60 + l_time[4,5]*1 + l_time[7,8]/60 -
                         (time1[1,2]*60 +  time1[4,5]*1 +  time1[7,8]/60)
      #No:FUN-C30021 --end      
       
          #CASE WHEN g_aza.aza18='2' #No:FUN-BB0068 start
      IF cl_null(l_time_used) THEN LET l_time_used = 0 END IF  #NO.NO:MOD-BC0109
      CASE
         WHEN g_azz.azz11='1'      #No:FUN-BB0068 改用 azz_file azz11 Program Running Log
             # LET l_date1 = TODAY                                    #CHI-C80032 marked 
               LET l_date = g_today USING 'yy/mm/dd'                  #CHI-C80032 程式開始執行時日期
              INSERT INTO zu_file(zu01,zu02,zu03,zu04,zu05)
                         #  VALUES (p_code,TODAY,time1,g_user,l_time_used) #CHI-C80032 marked
                            VALUES (p_code,l_date,time1,g_user,l_time_used) #CHI-C80032
              # No:DEV-C50001 ---start---
              # 因為會有部分必要欄位為null值導致無法寫入的問題，因此先不寫入syslog中   2012/06/27 by joyce
           #  LET ls_msg_syslog = p_code CLIPPED," is closed by ",g_user CLIPPED," at ",TODAY," ",time1 CLIPPED
           #  IF cl_syslog("A","G",ls_msg_syslog) THEN END IF
              # No:DEV-C50001 --- end ---
         WHEN g_azz.azz11='2'      #No:FUN-BB0068 個資作業
              #LET l_date1 = TODAY                                   #CHI-C80032 marked
              LET l_date = g_today USING 'yy/mm/dd'                  #CHI-C80032 程式開始執行時日期
              INSERT INTO zu_file(zu01,zu02,zu03,zu04,zu05)
                        #  VALUES (p_code,TODAY,time1,g_user,l_time_used) #CHI-C80032 marked
                           VALUES (p_code,l_date,time1,g_user,l_time_used) #CHI-C80032
              # No:DEV-C50001 ---start---
              # 因為會有部分必要欄位為null值導致無法寫入的問題，因此先不寫入syslog中   2012/06/27 by joyce
           #  LET ls_msg_syslog = p_code CLIPPED," is closed by ",g_user CLIPPED," at ",TODAY," ",time1 CLIPPED
           #  IF cl_syslog("A","G",ls_msg_syslog) THEN END IF
              # No:DEV-C50001 --- end ---
         OTHERWISE  #不記錄
      END CASE
          # WHEN g_aza.aza18='3'
          #      LET l_date = TODAY USING 'yy/mm/dd'
          #      UPDATE zu_file SET zu04=g_user,zu05=zu05+l_time_used,zu03=time1 #FUN-4C0024
          #        WHERE zu01 = p_code AND zu02 = l_date
          #      IF SQLCA.SQLERRD[3]=0 THEN
          #         INSERT INTO zu_file(zu01,zu02,zu03,zu04,zu05)
          #             VALUES (p_code,l_date,time1,g_user,l_time_used) #FUN-4C0024
          #      END IF
          # WHEN g_aza.aza18='4'
          #      LET l_date = TODAY USING 'yy/mm/dd'
          #      LET l_date[7,8]='01'
          #      UPDATE zu_file SET zu04=g_user,zu05=zu05+l_time_used,zu03=time1 #FUN-4C0024
          #        WHERE zu01 = p_code AND zu02 = l_date
          #      IF SQLCA.SQLERRD[3]=0 THEN
          #         INSERT INTO zu_file(zu01,zu02,zu03,zu04,zu05)
          #             VALUES (p_code,l_date,time1,g_user,l_time_used) #FUN-4C0024
          #      END IF
          #No:FUN-BB0068 end
      #END CASE
   END IF
 
   RETURN l_time
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 紀錄使用者登入後每個process的資訊
# Date & Author..: 2005/09/08 by saki
# Input Parameter: 
# Return code....: void
##################################################
 
FUNCTION cl_process_login()
   DEFINE   lr_gbq       RECORD LIKE gbq_file.*
   DEFINE   ls_cmd       STRING
   DEFINE   lr_process   DYNAMIC ARRAY OF RECORD
               ip        STRING,       #IP
               pid       STRING        #PID
                         END RECORD
   DEFINE   lc_channel   base.Channel
   DEFINE   li_cnt       LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   li_i         LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   ls_result    STRING
   DEFINE   ls_fglserver STRING
 
   LET lr_gbq.gbq01 = FGL_GETPID()
 
   # 透過fglWrt找正確的FGLSERVER
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN        #FUN-640184
      OPEN WINDOW dummy_w  WITH 1 ROWS, 1 COLUMNS
      CLOSE WINDOW dummy_w
   END IF
   LET ls_cmd = "fglWrt -a info users 2>&1"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   CALL lc_channel.setDelimiter("")
   LET li_i = 1
   CALL lr_process.clear()
   WHILE lc_channel.read(ls_result)
      LET li_cnt= ls_result.getIndexOf("GUI Server",1)
      IF li_cnt > 0 THEN
         LET ls_fglserver = ls_result.subString(li_cnt + 11,ls_result.getLength())
      #-- FUN-690056 begin
      #   判斷抓到的 FGLSERVER IP 是否為 127.0.0.1, 若是, 代表為 WEB 模式執行,
      #   則 IP 部分以 FGL_WEBSERVER_REMOTE_ADDR 變數取代(但必須透過如 Apache 的 Web Server 才會自動設定此環境變數值)
      #--
#No.FUN-740179 --mark-- 換位置
#        IF ls_fglserver.getIndexOf("127.0.0.1", 1) > 0 AND FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR") IS NOT NULL THEN
#           LET li_cnt = ls_fglserver.getIndexOf(":", 1)
#           LET ls_fglserver = FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR"), ls_fglserver.subString(li_cnt, ls_fglserver.getLength())
#        END IF
#No.FUN-740179 --mark--
      #-- FUN-690056 end
         #No.FUN-920138 saki  --start--
         LET li_cnt = ls_result.getIndexOf("Process Id",1)
         IF li_cnt > 0 THEN
            LET ls_fglserver = ls_result.subString(ls_result.getIndexOf("GUI Server",1) + 11,li_cnt-4)
            LET lr_process[li_i].ip = ls_fglserver
            LET lr_process[li_i].pid = ls_result.subString(li_cnt + 11,ls_result.getLength())
            LET li_i = li_i + 1
         END IF
         #No.FUN-920138 saki  ---end---
         CONTINUE WHILE
      END IF
 
      LET li_cnt = ls_result.getIndexOf("Process Id",1)
      IF li_cnt > 0 THEN
         LET lr_process[li_i].ip = ls_fglserver
         LET lr_process[li_i].pid = ls_result.subString(li_cnt + 11,ls_result.getLength())
         LET li_i = li_i + 1
      END IF
   END WHILE
   CALL lr_process.deleteElement(li_i)
   CALL lc_channel.close()
 
   FOR li_i = 1 TO lr_process.getLength()
       IF (lr_process[li_i].pid.equals(lr_gbq.gbq01)) THEN
          LET lr_gbq.gbq02 = lr_process[li_i].ip
          EXIT FOR
       END IF
   END FOR
 
   LET lr_gbq.gbq03 = g_user
   LET lr_gbq.gbq04 = g_prog
   SELECT zx03 INTO lr_gbq.gbq05 FROM zx_file WHERE zx01 = g_user
   LET lr_gbq.gbq06 = g_gui_type
   #No.FUN-740179 --start--
   LET ls_fglserver = cl_process_chg_iprec(lr_gbq.gbq02 CLIPPED)
   LET lr_gbq.gbq02 = ls_fglserver
   #No.FUN-740179 ---end---
   LET lr_gbq.gbq07 = TODAY," ",TIME
   LET lr_gbq.gbq08 = ""
   LET lr_gbq.gbq10 = g_plant CLIPPED,"/",g_plant CLIPPED       #No.FUN-660135
   LET lr_gbq.gbq11 = cl_used_ap_hostname()                     #FUN-950082
 
   IF cl_null(lr_gbq.gbq01) OR cl_null(lr_gbq.gbq02) OR cl_null(lr_gbq.gbq03) THEN
      RETURN
   END IF
 
   SELECT COUNT(*) INTO li_cnt FROM gbq_file WHERE gbq01 = lr_gbq.gbq01 AND gbq11 = lr_gbq.gbq11   #FUN-950082
   IF li_cnt > 0 THEN    #已經存在相同的PID (在同一AP Server上), 可能因為先前未刪除, 若找到就清空
      DELETE FROM gbq_file WHERE gbq01 = lr_gbq.gbq01 AND gbq11 = lr_gbq.gbq11   #FUN-950082
   END IF
 
   INSERT INTO gbq_file VALUES(lr_gbq.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err(lr_gbq.gbq01,"lib-300",0)
   END IF
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 使用者登出後, 將process資訊由table中刪除
# Date & Author..: 2005/09/08 by saki
# Input Parameter: 
# Return code....: void
##################################################
 
FUNCTION cl_process_logout()
   DEFINE   lr_gbq       RECORD LIKE gbq_file.*
   DEFINE   ls_cmd       STRING
   DEFINE   lr_process   DYNAMIC ARRAY OF RECORD
               ip        STRING,       #IP
               pid       STRING        #PID
                         END RECORD
   DEFINE   lc_channel   base.Channel
   DEFINE   li_i         LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   li_cnt       LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   ls_result    STRING
   DEFINE   ls_fglserver STRING
 
   LET lr_gbq.gbq01 = FGL_GETPID()
 
   # 透過fglWrt找正確的FGLSERVER
   LET ls_cmd = "fglWrt -a info users 2>&1"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   CALL lc_channel.setDelimiter("")
   LET li_i = 1
   WHILE lc_channel.read(ls_result)
      LET li_cnt= ls_result.getIndexOf("GUI Server",1)
      IF li_cnt > 0 THEN
         LET ls_fglserver = ls_result.subString(li_cnt + 11,ls_result.getLength())
      #-- FUN-690056 begin
      #   判斷抓到的 FGLSERVER IP 是否為 127.0.0.1, 若是, 代表為 WEB 模式執行,
      #   則 IP 部分以 FGL_WEBSERVER_REMOTE_ADDR 變數取代(但必須透過如 Apache 的 Web Server 才會自動設定此環境變數值)
      #--
#No.FUN-740179 --mark-- 換位置
#        IF ls_fglserver.getIndexOf("127.0.0.1", 1) > 0 AND FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR") IS NOT NULL THEN
#           LET li_cnt = ls_fglserver.getIndexOf(":", 1)
#           LET ls_fglserver = FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR"), ls_fglserver.subString(li_cnt, ls_fglserver.getLength())
#        END IF
#No.FUN-740179 --mark--
      #-- FUN-690056 end
         #No.FUN-920138 saki  --start--
         LET li_cnt = ls_result.getIndexOf("Process Id",1)
         IF li_cnt > 0 THEN
            LET ls_fglserver = ls_result.subString(ls_result.getIndexOf("GUI Server",1) + 11,li_cnt-4)
            LET lr_process[li_i].ip = ls_fglserver
            LET lr_process[li_i].pid = ls_result.subString(li_cnt + 11,ls_result.getLength())
            LET li_i = li_i + 1
         END IF
         #No.FUN-920138 saki  ---end---
         CONTINUE WHILE
      END IF
 
      LET li_cnt = ls_result.getIndexOf("Process Id",1)
      IF li_cnt > 0 THEN
         LET lr_process[li_i].ip = ls_fglserver
         LET lr_process[li_i].pid = ls_result.subString(li_cnt + 11,ls_result.getLength())
         LET li_i = li_i + 1
      END IF
   END WHILE
   CALL lr_process.deleteElement(li_i)
   CALL lc_channel.close()
 
   FOR li_i = 1 TO lr_process.getLength()
       IF (lr_process[li_i].pid.equals(lr_gbq.gbq01)) THEN
          LET lr_gbq.gbq02 = lr_process[li_i].ip
          EXIT FOR
       END IF
   END FOR
   #No.FUN-740179 --start--
   LET ls_fglserver = cl_process_chg_iprec(lr_gbq.gbq02 CLIPPED)
   #No.FUN-740179 ---end---
 
   LET lr_gbq.gbq02 = ls_fglserver
   LET lr_gbq.gbq03 = g_user
   LET lr_gbq.gbq08 = TODAY," ",TIME
   LET lr_gbq.gbq11 = cl_used_ap_hostname()      #FUN-950082

   #先紀錄按下離開的時間，如果沒有刪除成功還可保留紀錄
   UPDATE gbq_file SET gbq08 = lr_gbq.gbq08 WHERE gbq01 = lr_gbq.gbq01
                                              AND gbq02 = lr_gbq.gbq02
                                              AND gbq03 = lr_gbq.gbq03
                                              AND gbq11 = lr_gbq.gbq11    #FUN-950082
 
   DELETE FROM gbq_file WHERE gbq01 = lr_gbq.gbq01 AND gbq02 = lr_gbq.gbq02
                          AND gbq03 = lr_gbq.gbq03 AND gbq11 = lr_gbq.gbq11    #FUN-950082
 
   CALL cl_ins_del_sid(2, g_plant) #FUN-980030
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 檢查table內所記錄的process是否實際存在
# Date & Author..: 2005/09/09 by saki
# Input Parameter: none
# Return code....: void
##################################################
 
FUNCTION cl_process_check()
   DEFINE   lr_gbq       RECORD LIKE gbq_file.*
   DEFINE   ls_sql       STRING
   DEFINE   ls_cmd       STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
 
   DEFINE   lr_pid       DYNAMIC ARRAY OF STRING
   DEFINE   li_cnt       LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   li_no_del    LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   li_pid       LIKE type_file.num10         #No.FUN-690005 INTEGER
   DEFINE   ls_fglserver STRING                       #No.FUN-740179
   DEFINE   ls_tmp       STRING                       #MOD-990152

   #FUN-960177 start
   #LET lc_channel = base.Channel.create()
   #LET ls_cmd = "ps -ef | grep 'fglrun' | awk ' { print $2 } '"
   #CALL lc_channel.openPipe(ls_cmd,"r")
   #CALL lc_channel.setDelimiter("")
   #LET ls_result = ""
   #LET li_cnt = 1
   #WHILE (lc_channel.read(ls_result))
   #   IF NOT cl_null(ls_result) THEN
   #      LET lr_pid[li_cnt] = ls_result
   #      LET li_cnt = li_cnt + 1
   #   END IF
   #END WHILE
   #CALL lr_pid.deleteElement(li_cnt)
   #CALL lc_channel.close()
   #FUN-960177 end
 
#  LET ls_sql = "SELECT * FROM gbq_file ORDER BY gbq02,gbq03,gbq01"
   LET ls_sql = "SELECT * FROM gbq_file WHERE gbq11 = '",cl_used_ap_hostname() CLIPPED,"' ",
                " ORDER BY gbq02,gbq03,gbq01"   #FUN-A80037
   PREPARE gbq_pre FROM ls_sql
   DECLARE gbq_curs CURSOR FOR gbq_pre
 
   LET lc_channel = base.Channel.create()
   #No:TQC-B10169 --start--
   CALL lc_channel.openPipe("fglWrt -a ps","r")
   CALL lc_channel.setDelimiter("")
   LET ls_result = ""        
   WHILE lc_channel.read(ls_result)
      LET lr_pid[lr_pid.getLength()+1] = ls_result
   END WHILE
   CALL lc_channel.close()
   #No:TQC-B10169 ---end---

#  LET g_db_type = cl_db_get_database_type()  #FUN-960177   MOD-990152
   FOREACH gbq_curs INTO lr_gbq.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      #FUN-960177 start      
      IF NOT cl_null(lr_gbq.gbq01) THEN
 
#No:TQC-B10169 --start mark--
#         LET ls_tmp = lr_gbq.gbq01 CLIPPED
#         IF os.Path.separator() = "/" THEN      #FUN-980097
##           LET ls_cmd = "fglWrt -a ps |grep ", lr_gbq.gbq01
#            LET ls_cmd = "fglWrt -a ps |grep '^", ls_tmp.trim(), "$' "
#         ELSE
##           LET ls_cmd = "fglWrt -a ps |findstr ", lr_gbq.gbq01
#            LET ls_cmd = 'fglWrt -a ps |findstr "^', ls_tmp.trim(), '$" '
#         END IF
#         LET lc_channel = base.Channel.create()
#         CALL lc_channel.openPipe(ls_cmd,"r")
#         CALL lc_channel.setDelimiter("")
#         LET ls_result = ""        
#No:TQC-B10169 ---end mark---

      #LET li_no_del = FALSE
      #FOR li_cnt = 1 TO lr_pid.getLength()
      #    IF lr_gbq.gbq01 = lr_pid[li_cnt] THEN
      #       LET li_no_del = TRUE
      #       EXIT FOR
      #    END IF
      #END FOR
      #IF NOT li_no_del THEN
         #No.FUN-740179 --start--   #No.TQC-780066 --mark--
#        LET ls_fglserver = cl_process_chg_iprec(lr_gbq.gbq02 CLIPPED)
#        LET lr_gbq.gbq02 = ls_fglserver
         #No.FUN-740179 ---end---         

#No:TQC-B10169 --start--
#        IF NOT lc_channel.read(ls_result) THEN
         LET li_no_del = FALSE
         FOR li_cnt = 1 TO lr_pid.getLength()
             IF lr_gbq.gbq01 = lr_pid[li_cnt] THEN
                LET li_no_del = TRUE
                CALL lr_pid.deleteElement(li_cnt)
                EXIT FOR
             END IF
         END FOR
         IF NOT li_no_del THEN
#No:TQC-B10169 ---end---
            DELETE FROM gbq_file WHERE gbq01 = lr_gbq.gbq01 AND gbq02 = lr_gbq.gbq02
                                   AND gbq03 = lr_gbq.gbq03 AND gbq11 = lr_gbq.gbq11   #FUN-950082
         END IF  
      #FUN-960177 end                                 
      END IF
   END FOREACH

   CLOSE gbq_curs   #TQC-B60011
   FREE gbq_curs    #TQC-B60011

##################################
# 第二種check方式，因為目前資料量，array的方式比較快一點，
# 但TEMPTABLE可能等資料量大時，看會不會快點
##################################
#  CREATE TEMP TABLE ps_list(pid INTEGER)
#  LET lc_channel = base.Channel.create()
#  LET ls_cmd = "ps -ef | grep 'fglrun' | awk ' { print $2 } '"
#  CALL lc_channel.openPipe(ls_cmd,"r")
#  CALL lc_channel.setDelimiter("")
#  LET ls_result = ""
#  let li_cnt = 1
#  WHILE (lc_channel.read(ls_result))
#     IF NOT cl_null(ls_result) THEN
#        LET li_pid = ls_result
#        INSERT INTO ps_list VALUES(li_pid)
#     END IF
#  END WHILE
#  CALL lc_channel.close()
 
#  DELETE FROM gbq_file WHERE gbq01 NOT IN (SELECT pid FROM ps_list)
#  IF SQLCA.sqlcode AND SQLCA.sqlerrd[3] = 0 THEN
#     DISPLAY 'DELETE ERROR'
#  END IF
#  DROP TABLE ps_list
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 轉換從WEB登入的User IP
# Date & Author..: 2007/06/13 by saki
# Input Parameter: ps_fglserver   STRING   原本的IP
# Return code....: ps_fglserver   STRING   WEB登入的IP
# Memo...........: No.FUN-740179
##################################################
 
FUNCTION cl_process_chg_iprec(ps_fglserver)
   DEFINE   ps_fglserver   STRING
   DEFINE   ls_logtty      STRING
   DEFINE   lc_channel     base.Channel
   DEFINE   ls_cmd         STRING
   DEFINE   ls_serverip    STRING
   DEFINE   li_cnt         LIKE type_file.num5
 
   # No.MOD-7C0055 --start--
   IF ps_fglserver.getIndexOf(":",1) <= 0 THEN                                                                                      
      LET ps_fglserver = ps_fglserver,":0"                                                                                          
   END IF
   # No.MOD-7C0055 ---end---
   CASE
      WHEN g_gui_type = "1"
         LET ls_logtty = FGL_GETENV("LOGTTY")
         IF ls_logtty.getIndexOf("/dev/",1) THEN
            LET ls_logtty = ls_logtty.subString(6,ls_logtty.getLength())
         END IF
         LET ps_fglserver = ps_fglserver," [",ls_logtty,"]"
 
      WHEN g_gui_type = "2" OR g_gui_type = "3"
         #LET ls_cmd = "grep -i `hostname` /etc/hosts | head -1 | cut -f1"          #FUN-AB0111 mark
         LET ls_cmd = "grep -i `hostname` /etc/hosts |head -1 |awk '{ print $1}'"   #FUN-AB0111
         LET lc_channel = base.Channel.create()
         CALL lc_channel.openPipe(ls_cmd,"r")
         WHILE (lc_channel.read(ls_serverip))
         END WHILE
         CALL lc_channel.close()
         IF (ps_fglserver.getIndexOf("127.0.0.1", 1) > 0 OR
             ps_fglserver.getIndexOf(ls_serverip,1)) AND
            FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR") IS NOT NULL THEN
            LET li_cnt = ps_fglserver.getIndexOf(":", 1)
            LET ps_fglserver = FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR"), ps_fglserver.subString(li_cnt, ps_fglserver.getLength())
         END IF
   END CASE
   RETURN ps_fglserver
END FUNCTION

##################################################
# Descriptions...: 抓取AP Server的hostname (若不同ap server未依慣例而設定相同hostname時,將會造成系統誤判誤砍)
# Date & Author..: 2010/05/03 by alex
# Input Parameter: none
# Return code....: AP_Server_Hostname  String
##################################################
 
FUNCTION cl_used_ap_hostname()    #FUN-950082

   DEFINE ls_host   STRING
   DEFINE ch base.Channel

   IF cl_null(gs_hostname) THEN
      LET ch = base.Channel.create()
      CALL ch.setDelimiter(".")
      CALL ch.openPipe("hostname","r")

      LET ls_host = ""
      WHILE ch.read(ls_host)
      END WHILE
   ELSE
      LET ls_host = gs_hostname
   END IF

   CALL ch.close()
   RETURN ls_host.trim()
   
END FUNCTION

