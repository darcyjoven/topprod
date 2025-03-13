# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_klock.4gl
# Descriptions...: 檔案維護作業
# Date & Author..: 05/08/15 By qazzaq
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制         
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray g_time轉g_time
# Modify.........: No.MOD-710134 07/01/24 By Alexstar p_zta的解除Table Lock(action),按下去無作用
# Modify.........: No.FUN-770001 07/07/11 By alexstar 改成非動態產生畫面，才能動態轉換語言別
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.MOD-A60063 10/06/09 By Carrier database系统用户后面不加call cl_ins_del_sid因为这些用户中没有sid_file
# Modify.........: No.FUN-A60022 09/06/04 By Echo GP5.2 SQL Server 移植-p_zta 工具調整(含集團架構)
# Modify.........: No.FUN-B40034 11/04/14 By jenjwu 修改database system 資料庫切換後沒有切換回來之錯誤
# Modify.........: No.FUN-C50098 12/05/28 By laura 讀取user改由gbq03顯示使用者ID及行程號碼由VARCHAR(5)改用VARCHAR(24)
# Modify.........: No.CHI-C80034 13/01/04 By amdo 讀取user加入wzq_file 的wzq03顯示 B2B

IMPORT os
DATABASE ds  
GLOBALS "../../config/top.global"
 
DEFINE g_rec_b    LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE g_db_type  LIKE type_file.chr3     #FUN-680135 VARCHAR(3)
DEFINE g_dba_priv LIKE type_file.chr1     #FUN-680135 VARCHAR(1)
DEFINE g_lock DYNAMIC ARRAY OF RECORD
                  select    LIKE type_file.chr1,    #FUN-680135 VARCHAR(1)
                  object    LIKE type_file.chr20,   #FUN-680135 VARCHAR(16)
                  user      LIKE type_file.chr20,   #FUN-680135 VARCHAR(11)
                  #proc      LIKE type_file.chr5,    #FUN-680135 VARCHAR(5)
                  proc      LIKE type_file.chr30,   #FUN-C50098 VARCHAR(24) 
                  terminal  LIKE type_file.chr8,    #FUN-680135 VARCHAR(8)
                  sid       LIKE type_file.num10,   #FUN-680135 INTEGER
                  serial    LIKE type_file.num10,   #FUN-680135 INTEGER
                  machine   LIKE type_file.chr20    #FUN-680135 VARCHAR(10)
                  END RECORD
DEFINE gi_count   LIKE type_file.num10              #No.FUN-C50098    
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_db_type=cl_db_get_database_type()
                 
   CASE 
      WHEN g_db_type="MSV" 
       #FUN-A60022 -- start --
       SELECT COUNT(*) INTO g_dba_priv FROM sysusers
        WHERE usertype='D' and (username=g_user or username='public')
       IF g_dba_priv != '0' THEN
          LET g_dba_priv='1'
       END IF
       #FUN-A60022 -- end --

      WHEN g_db_type="IFX" 
         SELECT COUNT(*) INTO g_dba_priv FROM sysusers
          WHERE usertype='D' and (username=g_user or username='public')
         IF g_dba_priv != '0' THEN
            LET g_dba_priv='1'
         END IF

      WHEN g_db_type="ORA" 
         RUN "groups|grep dba" RETURNING g_dba_priv
         IF g_dba_priv = '0' THEN
            LET g_dba_priv='1'
         END IF
   END CASE
 
   OPEN WINDOW p_klock_w WITH FORM "azz/42f/p_klock"     #FUN-770001
 
   CALL cl_ui_init()

   IF g_db_type="IFX" THEN   #FUN-770001
      CALL cl_set_comp_visible("SERIAL",FALSE)
   END IF

   CALL p_klock_select_data()
   CALL p_klock_menu()
 
   CLOSE WINDOW p_klock_w
   

   DATABASE g_dbs                              #FUN-B40034
   
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
    
   
END MAIN

 
FUNCTION p_klock_select_data()
   DEFINE l_sql      STRING,
          l_i        LIKE type_file.num5,    
          l_dbname   LIKE type_file.chr20, 
          l_tabname  LIKE type_file.chr20,   #No.FUN-680135 VARCHAR(10)
          l_object   LIKE type_file.chr20    #TQC-940036---add  #David Lee
   DEFINE lr_gbq     DYNAMIC ARRAY OF RECORD LIKE gbq_file.*  #No.FUN-C50098
   DEFINE ls_sql     STRING                                   #No.FUN-C50098
   DEFINE li_j       LIKE type_file.num10                     #No.FUN-C50098
   DEFINE li_i       LIKE type_file.num10,                    #No.FUN-C50098
          li_minute  LIKE type_file.num10                     #No.FUN-C50098 

 
   IF g_dba_priv!='1' THEN
      CALL cl_err('','azz-108',1)
      CLOSE WINDOW p_klock_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   #No.FUN-C50098 --start-- 
   CONNECT TO g_dbs     AS "erpdb"
   SET CONNECTION "erpdb" 
   CALL cl_process_check()  #先將gbq_file內的資料refresh
   LET ls_sql = "SELECT * FROM gbq_file ORDER BY gbq03,gbq02,gbq01"
   PREPARE gbq_pre FROM ls_sql
   DECLARE gbq_curs CURSOR FOR gbq_pre
 
   LET gi_count = 1
   FOREACH gbq_curs INTO lr_gbq[gi_count].*
      IF SQLCA.sqlcode THEN
          EXIT FOREACH
      END IF
      LET gi_count = gi_count + 1
   END FOREACH
   CALL lr_gbq.deleteElement(gi_count)
   #No.CHI-C80034 --start--
   LET ls_sql = "SELECT wzq01,wzq03,wzq11 FROM wds.wzq_file"
   PREPARE wzq_pre FROM ls_sql
   DECLARE wzq_curs CURSOR FOR wzq_pre
   LET gi_count = gi_count + 1
   FOREACH wzq_curs INTO lr_gbq[gi_count].gbq01,lr_gbq[gi_count].gbq03,lr_gbq[gi_count].gbq11
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET gi_count = gi_count + 1
   END FOREACH
   CALL lr_gbq.deleteElement(gi_count)	
   #No.CHI-C80034 --end--
   DISCONNECT "erpdb"
   #No.FUN-C50098 ---end---   


   CASE 
      WHEN g_db_type="MSV" 
       #FUN-A60022 -- start --
       LET l_sql="select 'N' as sflag"
                ,",db_name(t1.rsc_dbid) as dbname"
                ,",t1.rsc_objid as objid"
                ,",t3.client_net_address"
                ,",t2.host_process_id"
                ,",t3.net_transport"
                ,",t1.req_spid"
                ,",t1.req_ecid"
                ,",t2.host_name" 
                ," from sys.syslockinfo t1"
                ," inner join sys.dm_exec_sessions t2"
                ," on t1.req_spid =t2.session_id"  
                ," inner join sys.dm_exec_connections t3"
                ," on t1.req_spid =t3.session_id"  
                ," where t1.rsc_type='5'" 
                ," order by t1.req_spid"
       #FUN-A60022 -- end --
      WHEN g_db_type="IFX"         
         #No.FUN-C50098 --start-- 
         #DATABASE sysmaster           
         CONNECT TO "sysmaster" AS "sysdb"        
         SET CONNECTION "sysdb" 
         #No.FUN-C50098 ---end---   
         #CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
         #CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069  #No.MOD-A60063
         LET l_sql = "SELECT 'N',o.dbsname[1,10],o.tabname[1,10], a.username[1,8],a.pid,a.tty[6,12],a.sid,'',a.hostname",
                     "  FROM syslocks o,syssessions a",
                     " WHERE o.dbsname <> 'sysmaster'",
                     "   AND o.owner=a.sid",
                     "   AND o.rowidlk!=0",
                     " ORDER BY 1 DESC,2"

      WHEN g_db_type="ORA" 
         DATABASE SYSTEM              
         IF sqlca.sqlcode THEN
            LET l_i=sqlca.sqlcode
            DATABASE ds
            CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
            CALL cl_err("can't connect to system schema:",l_i,"1")

            CLOSE WINDOW p_klock_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
         LET l_sql="SELECT 'N',lower(SUBSTR(all_objects.owner||'.'||object_name,1,16)) ",
                         ",SUBSTR(os_user_name,1,10) ",
                         ",v$locked_object.process ",
                         ",SUBSTR(terminal,1,7) ",
                         ",v$session.sid,v$session.serial# ",
                         ",v$session.machine ",
                   " FROM v$locked_object,all_objects,v$session",
                  " WHERE v$locked_object.object_id=all_objects.object_id",
                   "  AND v$locked_object.SESSION_ID=v$session.SID"
   END CASE

   DECLARE p_klock_c CURSOR FROM l_sql
   LET l_i=1
   CASE 
      WHEN g_db_type="MSV" 
         #FUN-A60022 -- start --
         FOREACH p_klock_c INTO g_lock[l_i].select,l_dbname,l_object,
                               g_lock[l_i].user,g_lock[l_i].proc, g_lock[l_i].terminal,
                               g_lock[l_i].sid,g_lock[l_i].serial,g_lock[l_i].machine 
            LET l_sql=" select t1.name from "
                     ,l_dbname CLIPPED,".sys.tables t1"
                     ," where t1.object_id =",l_object CLIPPED
            INITIALIZE l_tabname TO NULL
            DECLARE p_klock_d CURSOR FROM l_sql
            FOREACH p_klock_d INTO l_tabname
            END FOREACH
            IF l_tabname IS NOT NULL THEN  
               LET g_lock[l_i].object=l_dbname CLIPPED,".dbo.",l_tabname CLIPPED
            END IF 
            #No.FUN-C50098 ---start---
            LET g_lock[l_i].machine = cl_used_ap_hostname()   #本機查出的PID均應填入本機AP名稱
            FOR li_j = 1 TO lr_gbq.getLength()
               IF g_lock[l_i].proc = lr_gbq[li_j].gbq01 AND
                  g_lock[l_i].machine = lr_gbq[li_j].gbq11 THEN            
                  LET g_lock[l_i].user = lr_gbq[li_j].gbq03 #User
               END IF
            END FOR
            #No.FUN-C50098 ---end---
            LET l_i=l_i+1
         END FOREACH
         #FUN-A60022 -- end --
      WHEN g_db_type="IFX" 
         FOREACH p_klock_c INTO g_lock[l_i].select,l_dbname,l_tabname,
                                g_lock[l_i].user,g_lock[l_i].proc,
                                g_lock[l_i].terminal,g_lock[l_i].sid,
                                g_lock[l_i].serial,g_lock[l_i].machine
            LET g_lock[l_i].object=l_dbname CLIPPED,":",l_tabname CLIPPED
            #No.FUN-C50098 ---start---
            LET g_lock[l_i].machine = cl_used_ap_hostname()   #本機查出的PID均應填入本機AP名稱
            FOR li_j = 1 TO lr_gbq.getLength()
               IF g_lock[l_i].proc = lr_gbq[li_j].gbq01 AND
                  g_lock[l_i].machine = lr_gbq[li_j].gbq11 THEN            
                  LET g_lock[l_i].user = lr_gbq[li_j].gbq03 #User
               END IF
            END FOR
            #No.FUN-C50098 ---end---
            LET l_i=l_i+1
            DISCONNECT "sysdb"     #No.FUN-C50098
         END FOREACH

      WHEN g_db_type="ORA" 
         FOREACH p_klock_c INTO g_lock[l_i].*
            #No.FUN-C50098 ---start---
            LET g_lock[l_i].machine = cl_used_ap_hostname()   #本機查出的PID均應填入本機AP名稱
            FOR li_j = 1 TO lr_gbq.getLength()
               IF g_lock[l_i].proc = lr_gbq[li_j].gbq01 AND
                  g_lock[l_i].machine = lr_gbq[li_j].gbq11 THEN            
                  LET g_lock[l_i].user = lr_gbq[li_j].gbq03 #User
               END IF
            END FOR
            #No.FUN-C50098 ---end---
            LET l_i=l_i+1
         END FOREACH
   END CASE

   CALL g_lock.deleteElement(l_i)
   LET g_rec_b=l_i-1
 
   DISPLAY ARRAY g_lock TO s_table_data.*
      BEFORE DISPLAY 
         EXIT DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
 
END FUNCTION
 
 
FUNCTION p_klock_menu()
 
   WHILE TRUE
      CALL p_klock_bp()
      CASE g_action_choice
         WHEN "select_kill_lock"
              CALL p_klock_b()
              CALL p_klock_select_data()
         WHEN "exit"
              EXIT WHILE
         WHEN "refresh data"
              CALL p_klock_select_data()
      END CASE
   END WHILE
 
END FUNCTION
 
 
FUNCTION p_klock_b()
DEFINE l_i    LIKE type_file.num5     
DEFINE l_sql  STRING,
       l_str  STRING,
       l_status LIKE type_file.chr1, 
       l_sid    STRING,  #MOD-710134
       l_serial STRING   #MOD-710134
 
    IF g_rec_b=0 THEN
       RETURN
    END IF

    INPUT ARRAY g_lock WITHOUT DEFAULTS FROM s_table_data.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED)
          AFTER INPUT
               FOR l_i=1 TO g_lock.getLength()
                   IF g_lock[l_i].select='Y' THEN
                      # TQC-940036---start
                      #IF g_db_type="IFX" THEN
                      CASE g_db_type
                        WHEN "IFX" 
                          LET l_status='0'
                          LET l_sql="onmode -z ",g_lock[l_i].sid CLIPPED
                          RUN l_sql RETURNING l_status
                          IF l_status THEN
                             LET l_str="Kill Lock ",g_lock[l_i].object CLIPPED,
                                       " Fail"
                             CALL fgl_winmessage("Stop",l_str,"stop")
                          ELSE
                             LET l_str="Kill Lock ",g_lock[l_i].object CLIPPED,
                                       " Success"
                             CALL fgl_winmessage("Info",l_str,"info")
                          END IF
                        WHEN "ORA"
                          LET l_sid=g_lock[l_i].sid  #MOD-710134
                          LET l_serial=g_lock[l_i].serial  #MOD-710134
                          LET l_sql="alter system kill session '",l_sid CLIPPED,",",l_serial CLIPPED,"'"  #MOD-710134
                         #LET l_sql="alter system kill session '",g_lock[l_i].sid CLIPPED,",",g_lock[l_i].serial,"'"
                          EXECUTE IMMEDIATE l_sql 
                          IF sqlca.sqlcode THEN
                             LET l_str="Kill Lock ",g_lock[l_i].object CLIPPED,
                                       " Fail"
                             CALL fgl_winmessage("Stop",l_str,"stop")
                          ELSE
                             LET l_str="Kill Lock ",g_lock[l_i].object CLIPPED,
                                       " Success"
                             CALL fgl_winmessage("Info","Kill Lock Success","info")
                          END IF
                        WHEN "MSV"
                          LET l_status='0'
                          LET l_sql="kill ",g_lock[l_i].sid CLIPPED
                          EXECUTE IMMEDIATE l_sql
                          IF sqlca.sqlcode THEN
                             LET l_str="Kill Lock ",g_lock[l_i].object CLIPPED,
                                       " Fail"
                             CALL fgl_winmessage("Stop",l_str,"stop")
                          ELSE
                             LET l_str="Kill Lock ",g_lock[l_i].object CLIPPED,
                                       " Success"
                             CALL fgl_winmessage("Info",l_str,"info")
                          END IF                       
                      END CASE 
                      # TQC-940036---end
                   END IF
               END FOR

          ON ACTION cancel    #FUN-770001
               EXIT INPUT
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
    END INPUT
    
END FUNCTION
 
 
 
FUNCTION p_klock_buildTable(pn_vbox)
    DEFINE pn_vbox om.DomNode
    DEFINE ln_table, ln_table_column, ln_edit om.DomNode
    DEFINE ln_grid, ln_FormField, ln_TextEdit,ln_RadioGroup,ln_Item om.DomNode
    DEFINE l_i LIKE type_file.num10       #FUN-680135 INTEGER
    DEFINE l_colname STRING
    DEFINE l_width LIKE type_file.num5    #FUN-680135 SMALLINT
    
    LET ln_table = pn_vbox.createChild("Table")
    CALL ln_table.setAttribute("tabName", "s_table_data")
    CALL ln_table.setAttribute("pageSize", 10)
    CALL ln_table.setAttribute("size", 10)
    CALL ln_table.setAttribute("unhidableColumns", 1)
    FOR l_i = 1 TO 8
        LET ln_table_column = ln_table.createChild("TableColumn")
        LET l_colname = "field", l_i USING "&&&"
        CALL ln_table_column.setAttribute("colName", l_colname)
        CALL ln_table_column.setAttribute("name", "formonly." || l_colname)
        CASE WHEN l_i=1
                  LET l_colname="Select"
             WHEN l_i=2
                  LET l_colname="Locked Object"
             WHEN l_i=3
                  LET l_colname="TipTop User"
             WHEN l_i=4
                  LET l_colname="Process"
             WHEN l_i=5
                  LET l_colname="Terminal"
             WHEN l_i=6
                  LET l_colname="SID"
             WHEN l_i=7
                  LET l_colname="SERIAL#"
             WHEN l_i=8
                  LET l_colname="MACHINE"
        END CASE
        CALL ln_table_column.setAttribute("text",l_colname)
        IF l_i=1 THEN
           LET ln_edit = ln_table_column.createChild("CheckBox")
        ELSE
           LET ln_edit = ln_table_column.createChild("Edit")
           CALL ln_table_column.setAttribute("noEntry", 1)
        END IF
        CASE WHEN l_i=1
                  LET l_width=3
                  CALL ln_edit.setAttribute("valueChecked","Y")
                  CALL ln_edit.setAttribute("valueUnchecked","N")
             WHEN l_i=2
                  LET l_width=16
             WHEN l_i=3
                  LET l_width=11
             WHEN l_i=4
                  LET l_width=5
             WHEN l_i=5
                  LET l_width=8
             WHEN l_i=6
                  LET l_width=5
             WHEN l_i=7
                  LET l_width=7
                  IF g_db_type="IFX" THEN
                     CALL ln_table_column.setAttribute("hidden", 1)
                  END IF
             WHEN l_i=8
                  LET l_width=10
        END CASE
        CALL ln_edit.setAttribute("width", l_width)
    END FOR
END FUNCTION
 
 
FUNCTION p_klock_bp()
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_lock TO s_table_data.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        ON ACTION select_kill_lock
           LET g_action_choice="select_kill_lock"
           EXIT DISPLAY
   
        ON ACTION exit
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION refresh_data
           LET g_action_choice="refresh data"
           EXIT DISPLAY
 
        ON ACTION cancel
           LET INT_FLAG=FALSE       
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION


#FUN-A60022 
