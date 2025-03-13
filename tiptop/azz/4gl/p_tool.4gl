# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: p_tool.4gl
# Descriptions...: TIPTOP 系統管理工具
# Date & Author..: 04/03/12 by Brendan
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.FUN-640234 06/06/15 By alexstar p_tool 按下「列出索引表格」之後，進入後再退出，回到 p_tool
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: NO.FUN-770001 07/07/09 By alexstar 修正相關顯示資料,修正index查詢功能段
# Modify.........: NO.FUN-820044 08/03/10 By alex 新增MSV 需求函式
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: NO.CHI-8B0058 08/11/28 By alexstar For AP/DB separate environment
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.MOD-A60063 10/06/09 By Carrier DATABASE系统用户后面不加call cl_ins_del_sid因为这些用户中没有sid_file
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_zta01    LIKE zta_file.zta01    #No.FUN-680135 VARCHAR(10)
DEFINE g_cmd      STRING
DEFINE g_action   LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE g_dba_priv LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE g_dir      RECORD
                  top      STRING,
                  tempdir  STRING
                  END RECORD
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used("p_prog", g_time, 1) RETURNING g_time   #No.FUN-6A0096
 
   CASE cl_db_get_database_type()   #FUN-820044
      WHEN "IFX" 
         SELECT COUNT(*) INTO g_dba_priv FROM sysusers
          WHERE usertype='D' and (username=g_user or username='public')
         IF g_dba_priv != '0' THEN
            LET g_dba_priv='1'
         END IF
      WHEN "ORA"
         RUN "groups|grep dba" RETURNING g_dba_priv
         IF g_dba_priv = '0' THEN
            LET g_dba_priv='1'
         END IF
      WHEN "MSV"   #FUN-820044
         SELECT COUNT(*) INTO g_dba_priv FROM sysusers
          WHERE usertype='D' and (username=g_user or username='public')
         IF g_dba_priv != '0' THEN
            LET g_dba_priv='1'
         END IF
   END CASE
 
   OPEN WINDOW p_tool_w WITH FORM "azz/42f/p_tool"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_action = 1
   WHILE TRUE
       LET g_action_choice = ""
 
       CALL p_tool_i()
 
       IF g_action_choice = "exit" THEN
          EXIT WHILE
       END IF
   END WHILE
 
   CLOSE WINDOW p_tool_w

   CALL cl_used("p_tool", g_time, 2) RETURNING g_time  #No.FUN-6A0096
END MAIN
 
FUNCTION p_tool_i()
    DEFINE li_cnt     LIKE type_file.num10   #No.FUN-680135 INTEGER
    DEFINE lc_plant   LIKE azp_file.azp01,   #No.FUN-680135 VARCHAR(10)
           lc_dbs     LIKE type_file.chr20   #No.FUN-680135 VARCHAR(20)
 
    INPUT g_plant, g_action WITHOUT DEFAULTS FROM FORMONLY.plant, FORMONLY.action
          ATTRIBUTE(UNBUFFERED)
 
        BEFORE FIELD plant
            LET lc_plant = g_plant
            LET lc_dbs = g_dbs
 
        AFTER FIELD plant
            IF NOT cl_null(g_plant) THEN
               SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01 = g_plant
               IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
                  #CALL cl_err("select azp: ", SQLCA.SQLCODE, 1)  #No.FUN-660081
                  CALL cl_err3("sel","azp_file",g_plant,"",SQLCA.sqlcode,"","select azp", 1)  #No.FUN-660081)   #No.FUN-660081
                  NEXT FIELD CURRENT
               END IF
 
           #   CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
               CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
               CLOSE DATABASE
               DATABASE g_dbs
        #      CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
               CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
               IF SQLCA.SQLCODE THEN
                  CALL cl_err("switch database: ", SQLCA.SQLCODE, 1)
                  LET g_plant = lc_plant
                  LET g_dbs = lc_dbs
                  DATABASE g_dbs
           #      CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
                  CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
                  NEXT FIELD CURRENT
               END IF
            END IF
 
        AFTER INPUT
           IF NOT INT_FLAG THEN
              CALL p_tool_action()
           END IF
 
        ON ACTION CONTROLP
            CASE 
                WHEN INFIELD(plant)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azp"
                     LET g_qryparam.construct = 'N'
                     LET g_qryparam.default1 = g_plant
                     CALL cl_create_qry() RETURNING g_plant
                     NEXT FIELD plant
            END CASE
 
        ON ACTION locale
            CALL cl_dynamic_locale()
            EXIT INPUT
 
        ON ACTION exit                           #"Esc.結束"
            LET g_action_choice = "exit"
            EXIT INPUT
 
        ON ACTION controlg                       #KEY(CONTROL-G)
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = FALSE
       LET g_action_choice = "exit"
    END IF
    
END FUNCTION
 
FUNCTION tool_menu()
 
    MENU ""
        ON ACTION query
           CALL tool_q()
 
        ON ACTION exit
          LET INT_FLAG = TRUE
          RETURN    
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG = TRUE
          RETURN
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
    END MENU
END FUNCTION
 
FUNCTION tool_q()
    DEFINE lr_index DYNAMIC ARRAY OF RECORD
               idx      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               uni      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               ord      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               col      LIKE type_file.chr50    #No.FUN-680135 VARCHAR(30)
           END RECORD
    DEFINE ls_sql   STRING
    DEFINE li_cnt   LIKE type_file.num10        #No.FUN-680135 INTEGER
    
    OPEN WINDOW p_tool_idx_w WITH FORM "azz/42f/p_tool_idx"
 
    INPUT by name g_zta01 
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
 
    CASE cl_db_get_database_type()
         WHEN "IFX"
              LET ls_sql = "SELECT a.tabname, b.dbname || ':' || b.tabname",
                           " FROM systables a, syssyntable b WHERE a.tabid",
                           " = b.tabid"
         WHEN "ORA"
              LET ls_sql ="SELECT SUBSTR(USER_INDEXES.INDEX_NAME,1,10)",
                          ",SUBSTR(UNIQUENESS,1,10)",
                          ",COLUMN_POSITION,SUBSTR(COLUMN_NAME,1,20)",
                          " FROM USER_INDEXES,USER_IND_COLUMNS",
                          " WHERE USER_INDEXES.INDEX_NAME",
                          "=USER_IND_COLUMNS.INDEX_NAME AND",
                          " USER_INDEXES.TABLE_NAME=UPPER('",g_zta01 CLIPPED,"')",
                          " ORDER BY 1,COLUMN_POSITION" 
         WHEN "MSV"   #FUN-820044
              LET ls_sql = "SELECT a.tabname, b.dbname || ':' || b.tabname",
                           " FROM systables a, syssyntable b WHERE a.tabid",
                           " = b.tabid"
    END CASE
    DECLARE idx_q_cs CURSOR FROM ls_sql
    IF SQLCA.SQLCODE THEN
       CALL cl_err("declare error: ", SQLCA.SQLCODE, 1)
    END IF
 
    LET li_cnt = 1
    FOREACH idx_q_cs INTO lr_index[li_cnt].*
        IF SQLCA.SQLCODE THEN
           CALL cl_err("foreach error: ", SQLCA.SQLCODE, 0)
           EXIT FOREACH
        END IF
        LET li_cnt = li_cnt + 1
    END FOREACH
 
    DISPLAY ARRAY lr_index TO s_index.*
       ATTRIBUTE (COUNT = li_cnt - 1, UNBUFFERED)
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
 
    LET INT_FLAG = FALSE
 
    CLOSE WINDOW p_tool_idx_w
 
END FUNCTION


 
FUNCTION p_tool_action()   #FUN-770001
    CASE g_action
       WHEN 1
            CALL p_tool_synonymTable()
       WHEN 2
            IF g_dba_priv='1' THEN
              CALL p_tool_klock()
            ELSE
              CALL cl_err('','azz-108',1)
            END IF
       WHEN 3
            CALL p_tool_session() 
       WHEN 4
          CASE cl_db_get_database_type()   #FUN-820044
             WHEN "IFX"
                LET g_cmd = "echo update statistics|dbaccess ",g_dbs
                RUN g_cmd
             WHEN "ORA"
                LET g_cmd = "analyze2 ",g_dbs
                RUN g_cmd
             WHEN "MSV"   #FUN-820044
                LET g_cmd = "echo update statistics|dbaccess ",g_dbs
                RUN g_cmd
          END CASE
    END CASE
END FUNCTION
 
FUNCTION p_tool_synonymTable()
    DEFINE lr_synonym DYNAMIC ARRAY OF RECORD
               tab      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               ex_tab   LIKE type_file.chr50    #No.FUN-680135 VARCHAR(50)
           END RECORD
    DEFINE ls_sql       STRING
    DEFINE li_cnt       LIKE type_file.num10    #No.FUN-680135 INTEGER
 
    OPEN WINDOW p_tool_syn_w WITH FORM "azz/42f/p_tool_syn"
 
    CALL cl_ui_locale("p_tool_syn")    #FUN-770001
    
    CASE cl_db_get_database_type()
       WHEN "IFX"
          LET ls_sql = "SELECT a.tabname, b.dbname || ':' || b.tabname FROM systables a, syssyntable b WHERE a.tabid = b.tabid"
       WHEN "ORA"
          LET ls_sql = "select substr(synonym_name,1,10),substr(table_owner||'.'||table_name,1,20) from user_synonyms "
       WHEN "MSV"   #FUN-820044
          LET ls_sql = "SELECT a.tabname, b.dbname || ':' || b.tabname FROM systables a, syssyntable b WHERE a.tabid = b.tabid"
    END CASE
 
    DECLARE syn_cs CURSOR FROM ls_sql
    IF SQLCA.SQLCODE THEN 
       CALL cl_err("declare error: ", SQLCA.SQLCODE, 1)
    END IF
 
    LET li_cnt = 1
    FOREACH syn_cs INTO lr_synonym[li_cnt].*
        IF SQLCA.SQLCODE THEN
           CALL cl_err("foreach error: ", SQLCA.SQLCODE, 0)
           EXIT FOREACH
        END IF
        LET li_cnt = li_cnt + 1
    END FOREACH
 
    DISPLAY ARRAY lr_synonym TO s_synonym.* 
        ATTRIBUTE (COUNT = li_cnt - 1, UNBUFFERED)
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
 
    LET INT_FLAG = FALSE
 
 
    CLOSE WINDOW p_tool_syn_w
END FUNCTION
 
FUNCTION p_tool_indexTable()
    DEFINE lr_index DYNAMIC ARRAY OF RECORD
               idx      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               uni      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               ord      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               col      LIKE type_file.chr50    #No.FUN-680135 VARCHAR(30)
           END RECORD
    DEFINE ls_sql       STRING
    DEFINE li_cnt       LIKE type_file.num10    #No.FUN-680135 INTEGER
    
    OPEN WINDOW p_tool_idx_w WITH FORM "azz/42f/p_tool_idx"
    CALL tool_menu()
    #FUN-640234---start---
    IF INT_FLAG THEN
        LET INT_FLAG = FALSE
        CLOSE WINDOW p_tool_idx_w
        RETURN
    END IF
    #FUN-640234---end---
 
    INPUT by name g_zta01 
#TQC-860017 start
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
#TQC-860017 end    
 
    CASE cl_db_get_database_type()
       WHEN "IFX"
          LET ls_sql = " SELECT a.tabname, b.dbname || ':' || b.tabname ",
                         " FROM systables a, syssyntable b ",
                        " WHERE a.tabid = b.tabid "
       WHEN "ORA"
          LET ls_sql =" SELECT SUBSTR(USER_INDEXES.INDEX_NAME,1,10)",
                            " ,SUBSTR(UNIQUENESS,1,10)",
                            " ,COLUMN_POSITION,SUBSTR(COLUMN_NAME,1,20)",
                        " FROM USER_INDEXES,USER_IND_COLUMNS ",
                       " WHERE USER_INDEXES.INDEX_NAME=USER_IND_COLUMNS.INDEX_NAME ",
                         " AND USER_INDEXES.TABLE_NAME=UPPER('",g_zta01 CLIPPED,"') ",
                       " ORDER BY 1,COLUMN_POSITION " 
       WHEN "MSV"   #FUN-820044
          LET ls_sql = " SELECT a.tabname, b.dbname || ':' || b.tabname ",
                         " FROM systables a, syssyntable b ",
                        " WHERE a.tabid = b.tabid "
    END CASE
    DECLARE idx_cs CURSOR FROM ls_sql
    IF SQLCA.SQLCODE THEN
       CALL cl_err("declare error: ", SQLCA.SQLCODE, 1)
    END IF
 
    LET li_cnt = 1
    FOREACH idx_cs INTO lr_index[li_cnt].*
        IF SQLCA.SQLCODE THEN
           CALL cl_err("foreach error: ", SQLCA.SQLCODE, 0)
           EXIT FOREACH
        END IF
        LET li_cnt = li_cnt + 1
        #TQC-630107---add---
        IF li_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
        #TQC-630107---end---
    END FOREACH
 
    DISPLAY ARRAY lr_index TO s_index.*
        ATTRIBUTE (COUNT = li_cnt - 1, UNBUFFERED)
#TQC-860017 start
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
#TQC-860017 end    
 
    LET INT_FLAG = FALSE
    CLOSE WINDOW p_tool_idx_w
 
END FUNCTION
 
FUNCTION p_tool_session()
 
    CASE cl_db_get_database_type()
       WHEN "IFX"
          CALL p_tool_session_ifx()
       WHEN "ORA"
          CALL p_tool_session_ora()
       WHEN "MSV"   #FUN-820044
          CALL p_tool_session_ora()
    END CASE 
END FUNCTION
 
FUNCTION p_tool_session_ifx()
 
    DEFINE lr_session DYNAMIC ARRAY OF RECORD
               sid      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               tpuser   LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               pid      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
               tty      LIKE type_file.chr50    #No.FUN-680135 VARCHAR(30)
           END RECORD
    DEFINE ls_sql       STRING
    DEFINE li_cnt       LIKE type_file.num10    #No.FUN-680135 INTEGER
 
    LET ls_sql = "SELECT sid, username, pid, tty FROM syssessions"
 
    OPEN WINDOW p_tool_ses_ifx_w WITH FORM "azz/42f/p_tool_ses_ifx"
 
    CALL cl_ui_locale("p_tool_ses_ifx")    #FUN-770001
 
    DATABASE sysmaster
#   CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
#   CALL cl_ins_del_sid(1,'') #FUN-980030   #FUN-990069  #No.MOD-A60063
 
    DECLARE ses_ifx_cs CURSOR FROM ls_sql
    IF SQLCA.SQLCODE THEN
       CALL cl_err("declare error: ", SQLCA.SQLCODE, 1)
    END IF
 
    LET li_cnt = 1
    FOREACH ses_ifx_cs INTO lr_session[li_cnt].sid,
                            lr_session[li_cnt].tpuser,
                            lr_session[li_cnt].pid,
                            lr_session[li_cnt].tty
        IF SQLCA.SQLCODE THEN
           CALL cl_err("foreach error: ", SQLCA.SQLCODE, 0)
           EXIT FOREACH
 
        END IF
        LET li_cnt = li_cnt + 1
    END FOREACH
 
    DISPLAY ARRAY lr_session TO s_session.*
        ATTRIBUTE (COUNT = li_cnt - 1, UNBUFFERED)
#TQC-860017 start
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
#TQC-860017 end    
 
    LET INT_FLAG = FALSE
 
    CLOSE WINDOW p_tool_ses_ifx_w
    DISCONNECT ALL
DATABASE ds
#CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
 
 
END FUNCTION
 
FUNCTION p_tool_session_ora()
 
    DEFINE lr_session DYNAMIC ARRAY OF RECORD
     sid      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
     dbuser   LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
     tpuser   LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
     pid      LIKE type_file.chr50,   #No.FUN-680135 VARCHAR(30)
     tty      LIKE type_file.chr50    #No.FUN-680135 VARCHAR(30)
     END RECORD
    DEFINE    ls_sql   STRING
    DEFINE    li_cnt   LIKE type_file.num10   #No.FUN-680135 INTEGER
 
    LET ls_sql ="SELECT TO_CHAR(sid,'999999')",
                ",SUBSTR(username,1,10)",
                ",SUBSTR(osuser,1,10)",
                ",PROCESS",
                ",SUBSTR(terminal,1,7)",
                " FROM v$session",
                " WHERE username IS NOT NULL",
                " ORDER BY 1"
 
    OPEN WINDOW p_tool_ses_w WITH FORM "azz/42f/p_tool_ses"
 
    CALL cl_ui_locale("p_tool_ses")    #FUN-770001
 
    DECLARE ses_cs CURSOR FROM ls_sql
    IF SQLCA.SQLCODE THEN
       CALL cl_err("declare error: ", SQLCA.SQLCODE, 1)
    END IF
 
    LET li_cnt = 1
    FOREACH ses_cs INTO lr_session[li_cnt].*
        IF SQLCA.SQLCODE THEN
           CALL cl_err("foreach error: ", SQLCA.SQLCODE, 0)
           EXIT FOREACH
        END IF
        LET li_cnt = li_cnt + 1
        #TQC-630107---add---
        IF li_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
        #TQC-630107---end---
    END FOREACH
 
    DISPLAY ARRAY lr_session TO s_session.*
        ATTRIBUTE (COUNT = li_cnt - 1, UNBUFFERED)
#TQC-860017 start
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
#TQC-860017 end    
 
    LET INT_FLAG = FALSE
    CLOSE WINDOW p_tool_ses_w
 
 
END FUNCTION
 
 
 
FUNCTION p_tool_lockTable()
 
   IF g_dba_priv='1' THEN
      LET g_cmd = "p_klock"
      CALL cl_cmdrun(g_cmd)
   ELSE
      CALL cl_err('','azz-108',1)
   END IF
 
END FUNCTION
 
 
 
FUNCTION p_tool_klock()
    DEFINE readfile_channel   base.channel
    DEFINE l_str              STRING
    DEFINE l_ze               LIKE ze_file.ze03  #No.FUN-680135 VARCHAR(30)
    DEFINE l_pwd              STRING
 
    CASE cl_db_get_database_type()   #FUN-820044
       WHEN "IFX" 
          LET g_cmd = "p_klock"
          CALL cl_cmdrun(g_cmd)
       WHEN "ORA" 
          SELECT ze03 INTO l_ze FROM ze_file WHERE ze01='zta-030' AND ze02=g_lang
          PROMPT l_ze CLIPPED FOR l_pwd ATTRIBUTE(INVISIBLE)
             ON ACTION about
                CALL cl_about()
 
             ON ACTION controlg
                CALL cl_cmdask()
 
             ON ACTION help
                CALL cl_show_help()
 
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
          END PROMPT
          CALL ui.interface.refresh()
      
          RUN "echo 'exit'|sqlplus system/" || l_pwd || "@$ORACLE_SID|grep -i error >/dev/null 2>&1"  RETURNING g_dba_priv   #FUN-770001 #CHI-8B0058
          IF g_dba_priv = '0'  THEN  #FUN-770001
              CALL cl_err("Wrong Passwd !!","aoo-003","1")           
              LET g_dba_priv = '1'
          ELSE
              RUN "cp $FGLPROFILE $TEMPDIR/fglprofile.sys"
              RUN "chmod 777 $TEMPDIR/fglprofile.sys>/dev/null 2>&1"
      
              LET l_str= fgl_getenv("TEMPDIR") CLIPPED,"/fglprofile.script"   #FUN-770001
              LET readfile_channel=base.channel.create()
              CALL readfile_channel.setdelimiter("")
              CALL readfile_channel.openfile(l_str CLIPPED, "w" )
              CALL readfile_channel.write("ex $TEMPDIR/fglprofile.sys <<%%")
              CALL readfile_channel.write("g/ds\.source")
              CALL readfile_channel.write("-1")
              CALL readfile_channel.write("a")
 
              CALL readfile_channel.write('dbi.database.system.source= "`echo ${ORACLE_SID}`" ')
              CALL readfile_channel.write('dbi.database.system.username= "system" ')
              CALL readfile_channel.write('dbi.database.system.password= "'||l_pwd||'"')
              CALL readfile_channel.write('dbi.database.system.schema= "system" ')
              CALL readfile_channel.write('dbi.database.system.ora.prefetch.rows = 1 ')
              CALL readfile_channel.write("")
              CALL readfile_channel.write(".")
              CALL readfile_channel.write("w")
              CALL readfile_channel.write("q")
              CALL readfile_channel.write("%%")
              CALL readfile_channel.close()
              RUN "chmod 777 $TEMPDIR/fglprofile.script>/dev/null 2>&1"
              RUN "$TEMPDIR/fglprofile.script"
              RUN "export FGLPROFILE=$TEMPDIR/fglprofile.sys;$FGLRUN $AZZ/42r/p_klock.42r"
              RUN "rm $TEMPDIR/fglprofile.sys>/dev/null 2>&1"
              LET g_dba_priv='1'   #FUN-770001
          END IF
       WHEN "MSV"   #FUN-820044
    END CASE
END FUNCTION
 
