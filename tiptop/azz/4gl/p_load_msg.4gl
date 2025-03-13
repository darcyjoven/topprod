# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: p_load_msg.4gl
# Descriptions...: 自動載入訊息.
# Date & Author..: 04/02/10 by saki
# Sample.........: CALL p_load_msg()
# Memo...........: 此程式為背景執行.
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.TQC-590023 05/09/22 By saki 將接收人員開窗改為全部顯示，不翻頁
# Modify.........: NO.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-610008 06/10/24 By yoyo 人員增加按部門選擇，全選和顯示在線人員功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.MOD-870131 08/07/14 By Sarah ON IDLE 5 段沒做閒置控制
# Modify.........: No.MOD-8A0226 08/10/29 By Sarah 接收人員開窗改為q_zx1,程式卻沒過單,重新過單
# Modify.........: No.MOD-8B0158 08/11/15 By Sarah 選完接收人員後按"enter"或"tab"程式會突然終止
# Modify.........: No.FUN-8B0062 08/11/21 By Sarah 傳送時改傳送使用者的中文名zx02
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-970122 09/11/10 By tsai_yen 歷史訊息可查看自己傳送給其他人的記錄
 
DATABASE ds
 
GLOBALS "../../config/top.global"
                  
DEFINE   g_gar            RECORD
            gar01          LIKE gar_file.gar01,   #訊息編號
            gar02          LIKE gar_file.gar02,   #訊息接收者
            gar03          LIKE gar_file.gar03,   #訊息
            gar04          LIKE gar_file.gar04,   #訊息發送者
            #gar05          LIKE gar_file.gar05,                 #FUN-970122 mark
            gar05          LIKE type_file.chr20,  #訊息產生日期時間  #FUN-970122
            gar06          LIKE gar_file.gar06
                           END RECORD
DEFINE   g_gar_a          RECORD
            gar01          LIKE gar_file.gar01,
            gar02          LIKE gar_file.gar02,
            gar03          LIKE gar_file.gar03,
            gar04          LIKE gar_file.gar04,
            #gar05          LIKE gar_file.gar05,                 #FUN-970122 mark
            gar05          LIKE type_file.chr20,  #訊息產生日期時間  #FUN-970122
            gar06          LIKE gar_file.gar06
                           END RECORD
DEFINE   g_gar_i           RECORD
            gar01          LIKE gar_file.gar01,
            gar02          LIKE gar_file.gar02,
            gar03          LIKE gar_file.gar03,
            gar04          LIKE gar_file.gar04,
            #gar05          LIKE gar_file.gar05,                 #FUN-970122 mark
            gar05          LIKE type_file.chr20,  #訊息產生日期時間  #FUN-970122
            gar06          LIKE gar_file.gar06
                           END RECORD
DEFINE   ma_gar            DYNAMIC ARRAY OF RECORD
          check            LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
          gar01            LIKE gar_file.gar01,
          gar04            LIKE gar_file.gar04,
          #gar05          LIKE gar_file.gar05,                   #FUN-970122 mark
          gar05            LIKE type_file.chr20,  #訊息產生日期時間  #FUN-970122
          gar03            LIKE gar_file.gar03
                           END RECORD,
         ms_gar01          LIKE gar_file.gar01
DEFINE   ma_gar_u          DYNAMIC ARRAY OF RECORD
          gar01            LIKE gar_file.gar01
                           END RECORD,
         ms_upd_count      LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_zx02            LIKE zx_file.zx02
DEFINE   mi_curs_index     LIKE type_file.num10,  #No.FUN-680135 INTEGER
          g_row_count      LIKE type_file.num10   #No.FUN-580092 HCN   #No.FUN-680135 INTEGER
DEFINE   mi_curs_index2    LIKE type_file.num10,  #No.FUN-680135 INTEGER
          g_row_count2     LIKE type_file.num10   #No.FUN-580092 HCN   #No.FUN-680135 INTEGER
DEFINE   g_jump           LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   mwin_curr         ui.Window,
         mfrm_curr         ui.Form
DEFINE   mi_del            LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   mst_peo_name      base.StringTokenizer.create
DEFINE   mi_peo_num        LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_rec_b           LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_cnt             LIKE type_file.num10  #NO.TQC-630107---add---   #No.FUN-680135 INTEGER
 
MAIN
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理   #MOD-8B0158 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.TQC-860017 by saki
 
   OPEN WINDOW w_msg WITH FORM "azz/42f/p_load_msg"
      ATTRIBUTE(STYLE="err01")
   CALL cl_ui_init()
 
   LET mwin_curr = ui.Window.getCurrent()
   LET mfrm_curr = mwin_curr.getForm()
 
   CALL p_load_msg_i()
 
   CLOSE WINDOW w_msg  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.TQC-860017 by saki
END MAIN
 
##################################################
# Description  	: 載入訊息.
# Date & Author : 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION p_load_msg_load()
   DEFINE   li_i             LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_sql           STRING,
            ls_time_format   STRING
 
 
   LET ls_sql = "SELECT COUNT(*) FROM gar_file",
                " WHERE gar02 = '",g_user,"' AND gar06 = 'N'"
   PREPARE lcurs_precount FROM ls_sql
   DECLARE lcurs_count CURSOR FOR lcurs_precount
   OPEN lcurs_count
    FETCH lcurs_count INTO g_row_count #No.FUN-580092 HCN
   CLOSE lcurs_count
 
   LET ls_time_format = "YYYY/MM/DD HH24:MI:SS"
   LET ls_sql = "SELECT gar01,gar02,gar03,gar04,TO_CHAR(gar05,'",ls_time_format,"'),gar06 FROM gar_file",
                " WHERE gar02 = '",g_user,"' AND gar06 = 'N'",
                " ORDER BY gar05,gar01"
   PREPARE lcurs_prepare FROM ls_sql
   DECLARE lcurs_gar SCROLL CURSOR WITH HOLD FOR lcurs_prepare
END FUNCTION
 
FUNCTION p_load_msg_opencur()
   OPEN lcurs_gar
   IF SQLCA.sqlcode THEN
      RETURN
   ELSE
      CALL p_load_msg_fetch('F')
      CALL p_load_msg_upd_array(g_gar.gar01)
   END IF
END FUNCTION
 
FUNCTION p_load_msg_fetch(pc_flag)
   DEFINE   pc_flag   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
   
 
   CASE pc_flag
      WHEN 'F' FETCH FIRST            lcurs_gar INTO g_gar.*
      WHEN 'N' FETCH NEXT             lcurs_gar INTO g_gar.*
      WHEN 'P' FETCH PREVIOUS         lcurs_gar INTO g_gar.*
      WHEN '/' FETCH ABSOLUTE g_jump lcurs_gar INTO g_gar.*
   END CASE
 
   IF SQLCA.sqlcode THEN
      INITIALIZE g_gar.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE pc_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN '/' LET mi_curs_index = g_jump
      END CASE
       CALL mlib_navigator_setting(mi_curs_index,g_row_count) #No.FUN-580092 HCN
      CALL p_show_msg()
   END IF
END FUNCTION
 
##################################################
# Description  	: 顯示訊息及輸入訊息畫面.
# Date & Author : 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION p_load_msg_i()
   DEFINE   li_row_count   LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE   lc_gar02_cnt   LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE   l_delay        LIKE type_file.num5    #MOD-870131 add
 
   WHILE TRUE   #MOD-8B0158 add
      MESSAGE ""
      INPUT g_gar_i.gar03,g_gar_i.gar02
         WITHOUT DEFAULTS FROM FORMONLY.input_msg,gar02
         BEFORE INPUT
            LET l_delay=0   #MOD-870131 add
            LET ms_upd_count = 1
            LET ma_gar_u[ms_upd_count].gar01 = ""
            LET g_row_count = 0 #No.FUN-580092 HCN
            CALL p_load_msg_load()
            CALL p_load_msg_opencur()
            CALL mlib_navigator_setting(mi_curs_index,g_row_count) #No.FUN-580092 HCN
    
         AFTER FIELD gar02
            IF NOT cl_null(g_gar_i.gar02) THEN
               SELECT zx02 INTO g_zx02 FROM zx_file
                WHERE zx01 = g_gar_i.gar02
               DISPLAY g_gar_i.gar02,g_zx02 TO gar02,FORMONLY.zx02
            END IF
    
         ON IDLE 5
           #str MOD-870131 add
            LET l_delay=l_delay+5
            IF l_delay >= g_idle_seconds THEN
               LET l_delay=0
               CALL cl_on_idle()
               CONTINUE INPUT
            END IF
           #end MOD-870131 add
            LET li_row_count = g_row_count #No.FUN-580092 HCN
            CALL p_load_msg_load()
            OPEN lcurs_gar
            IF li_row_count = g_row_count THEN #No.FUN-580092 HCN
               LET g_jump = mi_curs_index
            ELSE
               LET g_jump = li_row_count + 1
               MESSAGE 'You have new messages!'
            END IF
            CALL p_load_msg_fetch('/')
            CALL p_load_msg_upd_array(g_gar.gar01)
    
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gar02)
                  CALL GET_FLDBUF(gar02) RETURNING g_gar_i.gar02
                  LET mi_peo_num = 0
                  CALL cl_init_qry_var()
                 #FUN-610008--start
                 #LET g_qryparam.form = "q_zx"
                 #LET g_qryparam.state = "c"
                 #LET g_qryparam.construct = "N"             #No.TQC-590023
                 #LET g_qryparam.pagecount = 3000            #No.TQC-590023
                 #LET g_qryparam.default1 = g_gar_i.gar02
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_zx1(TRUE,TRUE,' ',' ') RETURNING g_qryparam.multiret   #MOD-8A0226
                 #FUN-610008--end                
 
                  LET mst_peo_name = base.StringTokenizer.create(g_qryparam.multiret,"|")
                  LET mi_peo_num = mst_peo_name.countTokens()
                  IF mi_peo_num > 1 THEN
                      CALL FGL_DIALOG_SETBUFFER('Multiple')
                  ELSE
                     LET g_gar_i.gar02 = g_qryparam.multiret
                     SELECT zx02 INTO g_zx02 FROM zx_file
                      WHERE zx01 = g_gar_i.gar02
                     DISPLAY g_gar_i.gar02,g_zx02 TO gar02,FORMONLY.zx02
                  END IF
            END CASE
    
         ON ACTION history
            CALL p_load_all_msg()
             CALL mlib_navigator_setting(mi_curs_index,g_row_count) #No.FUN-580092 HCN
         ON ACTION nextdata
            CALL p_load_msg_fetch('N')
            CALL p_load_msg_upd_array(g_gar.gar01)
         ON ACTION prevdata
            CALL p_load_msg_fetch('P')
            CALL p_load_msg_upd_array(g_gar.gar01)
         ON ACTION send
            CALL GET_FLDBUF(FORMONLY.input_msg) RETURNING g_gar_i.gar03
            CALL GET_FLDBUF(gar02) RETURNING g_gar_i.gar02
            IF cl_null(g_gar_i.gar03) OR cl_null(g_gar_i.gar02) THEN
               CONTINUE INPUT
            END IF
            IF mi_peo_num > 1 THEN
               CALL p_load_msg_multiple()
            ELSE
               SELECT COUNT(*) INTO lc_gar02_cnt FROM zx_file 
                WHERE zx01 = g_gar_i.gar02
               IF lc_gar02_cnt = 0 THEN
                  CALL cl_err('error','aoo-001',1)
                  CONTINUE INPUT
               END IF
               CALL p_load_msg_insert()
            END IF
            INITIALIZE g_gar_i.* TO NULL
            INITIALIZE g_zx02 TO NULL
            DISPLAY g_gar_i.gar02,g_gar_i.gar03,g_zx02 TO gar02,FORMONLY.input_msg,zx02
         ON ACTION exit
            CALL p_load_msg_update()
            LET INT_FLAG=1   #MOD-8B0158 add
            EXIT INPUT
         ON ACTION close
            CALL p_load_msg_update()
            LET INT_FLAG=1   #MOD-8B0158 add
            EXIT INPUT
        #TQC-860017 start
         ON ACTION about
            CALL cl_about()
         ON ACTION controlg
            CALL cl_cmdask()
         ON ACTION help
            CALL cl_show_help()
        #TQC-860017 end  
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF   #MOD-8B0158 add
   END WHILE   #MOD-8B0158 add
END FUNCTION
 
##################################################
# Description  	: 顯示訊息.
# Date & Author : 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION p_show_msg()
   DEFINE ls_msg   STRING
   DEFINE l_zx02   LIKE zx_file.zx02   #FUN-8B0062 add
 
   INITIALIZE ls_msg TO NULL
   DISPLAY ls_msg TO FORMONLY.display_msg
 
  #str FUN-8B0062 mod
  #LET ls_msg = g_gar.gar04 || " (" || g_gar.gar05 || ") : \n" || g_gar.gar03
   LET l_zx02=''
   SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=g_gar.gar04
   LET ls_msg = g_gar.gar04 || " " || l_zx02 || " (" || g_gar.gar05 || ") : \n" || g_gar.gar03
  #end FUN-8B0062 mod
 
   DISPLAY ls_msg TO FORMONLY.display_msg
   IF g_gar.gar01 MATCHES '*9999999999' THEN
      IF NOT mi_del THEN
         CALL cl_confirm("azz-019") RETURNING mi_del
         IF mi_del THEN
            DELETE FROM gar_file WHERE gar02 = g_user
            CALL p_load_msg_load()
            OPEN lcurs_gar
            IF NOT SQLCA.sqlcode THEN
               CALL p_load_msg_fetch('F')
               CALL p_load_msg_upd_array(g_gar.gar01)
            END IF
         END IF
      END IF
   END IF
END FUNCTION
 
##################################################
# Description  	: 顯示所有訊息.
# Date & Author : 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION p_load_all_msg()
   DEFINE   lr_gar           RECORD
               gar01         LIKE gar_file.gar01,
               gar02         LIKE gar_file.gar02,
               gar03         LIKE gar_file.gar03,
               gar04         LIKE gar_file.gar04,
               #gar05         LIKE gar_file.gar05,  #FUN-970122 mark
               gar05         LIKE type_file.chr20,  #訊息產生日期時間  #FUN-970122
               gar06         LIKE gar_file.gar06
                             END RECORD
   DEFINE   li_i             LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            ls_time_format   STRING,
            ls_sql           STRING
 
 
   OPEN WINDOW w_msg_history WITH FORM "azz/42f/p_load_msg_history"
      ATTRIBUTE(STYLE="err01")
   CALL cl_ui_locale("p_load_msg_history")
 
   CALL ma_gar.clear()
 
   LET ls_time_format = "YYYY/MM/DD HH24:MI:SS"
   LET ls_sql = "SELECT gar01,gar02,gar03,gar04,TO_CHAR(gar05,'",ls_time_format,"'),gar06 FROM gar_file",
                #" WHERE gar02 = '",g_user,"'",                          #FUN-970122 mark
                " WHERE gar02 = '",g_user,"' OR gar04 = '",g_user,"'",   #FUN-970122
                " ORDER BY gar05 DESC"
   DECLARE lcurs_all_gar CURSOR FROM ls_sql
 
   LET g_rec_b = 0
   FOREACH lcurs_all_gar INTO lr_gar.*
      IF (SQLCA.SQLCODE) THEN
         EXIT FOREACH
      END IF
 
      LET g_rec_b = g_rec_b + 1
      LET ma_gar[li_i+1].check = 'N'
      LET ma_gar[li_i+1].gar01 = lr_gar.gar01
      LET ma_gar[li_i+1].gar03 = lr_gar.gar03      
      LET ma_gar[li_i+1].gar04 = lr_gar.gar04      
      LET ma_gar[li_i+1].gar05 = lr_gar.gar05 
     
      LET li_i = li_i + 1
       
      #NO.TQC-630107---add---
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #NO.TQC-630107---end---
   END FOREACH
   CALL p_show_all_msg()
END FUNCTION
 
FUNCTION p_show_all_msg()
   DEFINE li_i            LIKE type_file.num5,   #No.FUN-680135 SMALLINT
          l_ac            LIKE type_file.num5,   #No.FUN-680135 SMALLINT
          li_count        LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE ls_sql          STRING,
          l_flag          LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE ls_time_format  STRING                 #FUN-970122
 
   
   LET l_flag = FALSE 
   INPUT ARRAY ma_gar WITHOUT DEFAULTS FROM s_gar.*
               #NO.TQC-630107---add--- 
               ATTRIBUTES(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                          INSERT ROW=FALSE, DELETE ROW=FALSE, 
                          APPEND ROW=FALSE,UNBUFFERED)
               #NO.TQC-630107---end---
      BEFORE ROW
         LET g_row_count2 = 0 #No.FUN-580092 HCN
         LET l_ac = ARR_CURR()
 
         #SELECT COUNT(*) INTO li_count FROM gar_file WHERE gar02 = g_user   #FUN-970122 mark
         SELECT COUNT(*) INTO li_count FROM gar_file WHERE gar02 = g_user OR gar04 = g_user   #FUN-970122
 
         LET ls_time_format = "YYYY/MM/DD HH24:MI:SS"
         #LET ls_sql = "SELECT gar01,gar02,gar03,gar04,gar05,gar06 FROM gar_file", #FUN-970122 mark
         #" WHERE gar02 = '",g_user,"'",                                           #FUN-970122 mark
         LET ls_sql = "SELECT gar01,gar02,gar03,gar04,TO_CHAR(gar05,'",ls_time_format,"'),gar06 FROM gar_file",  #FUN-970122                     
                      " WHERE gar02 = '",g_user,"' OR gar04 = '",g_user,"'",       #FUN-970122
                      " ORDER BY gar05 DESC"
         PREPARE lcurs_prepare_all FROM ls_sql
         DECLARE lcurs_gar_all SCROLL CURSOR WITH HOLD FOR lcurs_prepare_all
         OPEN lcurs_gar_all
         IF SQLCA.sqlcode THEN
            RETURN
         ELSE
            LET g_jump = l_ac
             LET g_row_count2 = li_count #No.FUN-580092 HCN
            CALL p_load_msg_allfetch('/')
         END IF
      
      ###FUN-970122 START ###
      ON CHANGE check
         #不可刪除別人發送的訊息
         IF ma_gar[l_ac].gar04 <> g_user THEN
            LET ma_gar[l_ac].check = "N"               
            CALL cl_err("","azz-033",1)
         END IF
      ###FUN-970122 END ###
     
      ON ACTION sel_all
         FOR li_i = 1 TO ma_gar.getLength()
             IF ma_gar[li_i].gar04 = g_user THEN   #FUN-970122
                LET ma_gar[li_i].check = 'Y'
             END IF                                #FUN-970122
         END FOR
   
      ON ACTION clear
         FOR li_i = 1 TO ma_gar.getLength()
             LET ma_gar[li_i].check = 'N'
         END FOR
   
      ON ACTION delete
         CALL GET_FLDBUF(s_gar.check) RETURNING ma_gar[ARR_CURR()].check
 
         FOR li_i = ma_gar.getLength() TO 1 STEP -1
             IF (ma_gar[li_i].check = "Y") THEN
                LET ms_gar01 = ma_gar[li_i].gar01
                CALL p_load_msg_r()
                CALL ma_gar.deleteElement(li_i)
             END IF
         END FOR
         LET l_flag = TRUE
         EXIT INPUT
#        CALL p_load_msg_opencur()
      ON ACTION prevdata
         CALL p_load_msg_allfetch('P')
      ON ACTION nextdata
         CALL p_load_msg_allfetch('N')
      ON ACTION exit
         EXIT INPUT
         
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   IF l_flag THEN
      CALL p_show_all_msg()
   END IF
   CLOSE WINDOW w_msg_history
END FUNCTION
 
FUNCTION p_load_msg_allfetch(pc_flag)
   DEFINE   pc_flag   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
   
 
   CASE pc_flag
      WHEN 'F' FETCH FIRST            lcurs_gar_all INTO g_gar.*
      WHEN 'N' FETCH NEXT             lcurs_gar_all INTO g_gar.*
      WHEN 'P' FETCH PREVIOUS         lcurs_gar_all INTO g_gar.*
      WHEN '/' FETCH ABSOLUTE g_jump lcurs_gar_all INTO g_gar.*
   END CASE
   IF SQLCA.sqlcode THEN
      INITIALIZE g_gar.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE pc_flag
         WHEN 'F' LET mi_curs_index2 = 1
         WHEN 'N' LET mi_curs_index2 = mi_curs_index2 + 1
         WHEN 'P' LET mi_curs_index2 = mi_curs_index2 - 1
         WHEN '/' LET mi_curs_index2 = g_jump
      END CASE
       CALL mlib_navigator_setting(mi_curs_index2,g_row_count2) #No.FUN-580092 HCN
      CALL p_show_msg()
   END IF
END FUNCTION
 
##################################################
# Description  	: 更新資料庫訊息狀態.
# Date & Author : 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
# 2004/04/12 by saki : 將訊息是否讀取的更新放在移到新訊息之後,紀錄到暫存array
FUNCTION p_load_msg_upd_array(ls_gar01)
   DEFINE   ls_gar01      LIKE gar_file.gar01,
            li_i          LIKE type_file.num10,   #No.FUN-680135 INTEGER
            ls_cnt        LIKE type_file.num10,   #No.FUN-680135 INTEGER
            no_upd_flag   LIKE type_file.num5     #No.FUN-680135 SMALLINT
  
   FOR li_i = 1 TO ma_gar_u.getLength()
       IF ls_gar01 = ma_gar_u[li_i].gar01 THEN
          LET no_upd_flag = TRUE
       END IF
   END FOR
   IF (NOT no_upd_flag) THEN
      LET ma_gar_u[ms_upd_count].gar01 = ls_gar01
      LET ms_upd_count = ma_gar_u.getLength() + 1
   END IF
END FUNCTION
 
FUNCTION p_load_msg_update()
   DEFINE   lr_gar   RECORD LIKE gar_file.*
   DEFINE   li_i     LIKE type_file.num10   #No.FUN-680135 INTEGER
 
   
   # 2004/04/12 by saki : 離開時將有看過的訊息狀態碼更改為已看過
   FOR li_i = 1 TO ma_gar_u.getLength()
       IF cl_null(ma_gar_u[li_i].gar01) THEN
          CONTINUE FOR
       END IF
       UPDATE gar_file SET gar06 = 'Y'
        WHERE gar01 = ma_gar_u[li_i].gar01 AND gar01 NOT MATCHES '*9999999999'
       IF SQLCA.sqlcode THEN
          DISPLAY 'Update status of messages error!'
       END IF
   END FOR
END FUNCTION
 
##################################################
# Description  	: 儲存送出的訊息.
# Date & Author : 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION p_load_msg_insert()
 
 
   CALL p_load_msg_making_gar01()
 
   IF cl_null(g_gar_i.gar01) OR g_gar_i.gar01 MATCHES '*10000000000' THEN
      CALL cl_err('error:','azz-018',1)
      RETURN
   END IF
   IF g_gar_i.gar01 MATCHES '*999999999' THEN
      CALL cl_err('error:','azz-018',1)
   END IF
 
   LET g_gar_i.gar04 = g_user
   LET g_gar_i.gar05 = CURRENT YEAR TO SECOND
   LET g_gar_i.gar06 = 'N'
 
     
      INSERT INTO gar_file(gar01,gar02,gar03,gar04,gar05,gar06)
                 VALUES(g_gar_i.gar01,g_gar_i.gar02,g_gar_i.gar03,
                        g_gar_i.gar04,TO_DATE(g_gar_i.gar05,'YYYY/MM/DD HH24:MI:SS'),g_gar_i.gar06)
   IF SQLCA.sqlcode THEN
#     CALL cl_err('insert:',SQLCA.sqlcode,1)  #No.FUN-660081
      CALL cl_err3("ins","gar_file",g_gar_i.gar01,"",SQLCA.sqlcode,"","insert",1)   #No.FUN-660081
      RETURN
   END IF
END FUNCTION
 
FUNCTION p_load_msg_making_gar01()
   DEFINE   ls_max_gar01   LIKE gar_file.gar01,
            ls_gar01       STRING,
            ls_gar02       STRING,
            li_num_s       LIKE type_file.num10,   #No.FUN-680135 INTEGER
            li_num_e       LIKE type_file.num10,   #No.FUN-680135 INTEGER
            ls_num_str     STRING,
            ld_num         LIKE fab_file.fab09     #No.FUN-680135 DEC(11,0) 
 
   LET ls_max_gar01 = ""
   SELECT MAX(gar01) INTO ls_max_gar01 FROM gar_file
    WHERE gar02 = g_gar_i.gar02
 
   IF cl_null(ls_max_gar01) THEN
      CALL s_string_auno(g_gar_i.gar02,1) RETURNING g_gar_i.gar01
      RETURN
   END IF
 
   LET ls_gar01 = ls_max_gar01
   LET ls_gar01 = ls_gar01.trim()
 
   LET ls_gar02 = g_gar_i.gar02
   LET ls_gar02 = ls_gar02.trim()
 
   LET li_num_e = ls_gar01.getLength()
   LET li_num_s = ls_gar02.getLength() + 1
 
   LET ls_num_str = ls_gar01.subString(li_num_s,li_num_e)
   LET ld_num = ls_num_str + 1
   IF cl_null(ld_num) THEN
      CALL cl_err('key value is error','9052',1)
      LET g_gar_i.gar01 = ""
      RETURN
   END IF
   IF ld_num = 10**10 - 1 THEN
      LET g_gar_i.gar03 = "Your messages box is too large, please delete all of them"
   END IF
   CALL s_string_auno(g_gar_i.gar02,ld_num) RETURNING g_gar_i.gar01
END FUNCTION
 
##################################################
# Description  	: 刪除訊息.
# Date & Author : 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION p_load_msg_r()
   IF g_gar.gar01 IS NULL THEN
      MESSAGE "Key value is null"
      RETURN
   END IF
 
   DELETE FROM gar_file WHERE gar01 = ms_gar01
      AND gar04 = g_user   #FUN-970122
   IF SQLCA.sqlcode THEN
      #CALL cl_err('delete:','9051',1)  #No.FUN-660081
      CALL cl_err3("del","gar_file",ms_gar01,"","9051","","delete",1)   #No.FUN-660081
   END IF
END FUNCTION
 
##################################################
# Description  	: 整體傳送訊息.
# Date & Author : 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION p_load_msg_multiple()
 
 
   LET mst_peo_name = base.StringTokenizer.create(g_qryparam.multiret,"|")
 
   WHILE mst_peo_name.hasMoreTokens()
      LET g_gar_i.gar02 = mst_peo_name.nextToken()
      CALL p_load_msg_insert()
   END WHILE
   MESSAGE "Send OK!"
END FUNCTION
 
#[
# Description  	: 結束程式
# Date & Author	: 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	: 在結束udm_tree前,要先結束此程式.
# Modify   	:
#]
FUNCTION exit_load_msg()
   EXIT PROGRAM
END FUNCTION
 
#[
# Description  	: 設定ToolBar上瀏覽上下筆資料的按鈕狀態
# Date & Author	: 2004/02/10 by saki
# Parameter   	: none
# Return   	: void
# Memo        	: call cl_navigator_setting來改~~因為next previous用的名稱不一樣
# Modify   	:
#]
FUNCTION mlib_navigator_setting(pi_curr_index, pi_row_count)
   DEFINE   pi_curr_index   LIKE type_file.num10,  #No.FUN-680135 INTEGER
            pi_row_count    LIKE type_file.num10   #No.FUN-680135 INTEGER
 
 
   CALL mlib_reset_local_action("nextdata,prevdata", TRUE)
 
   CASE pi_curr_index
      WHEN 0
         CALL mlib_reset_local_action("nextdata,prevdata", FALSE)
      WHEN 1
         CALL mlib_reset_local_action("prevdata", FALSE)
         IF pi_row_count = 1 THEN
            CALL mlib_reset_local_action("nextdata",FALSE)
         END IF
      WHEN pi_row_count
         CALL mlib_reset_local_action("nextdata", FALSE)
   END CASE
END FUNCTION
 
FUNCTION mlib_reset_local_action(ps_act_names, pi_visible)
   DEFINE   ps_act_names    STRING,
            pi_visible      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            li_j            LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            lnode_item      om.DomNode,
            ls_item_name    STRING 
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING
 
 
   LET la_act_type[1] = "Action"
   LET la_act_type[2] = "MenuAction"
   LET lnode_root = ui.Interface.getRootNode()
 
   FOR li_i = 1 TO la_act_type.getLength()
      LET lst_act_names = base.StringTokenizer.create(ps_act_names, ",")
      WHILE lst_act_names.hasMoreTokens() 
         LET ls_act_name = lst_act_names.nextToken()
         LET ls_act_name = ls_act_name.trim()
         LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])
         FOR li_j = 1 TO llst_items.getLength()
            LET lnode_item = llst_items.item(li_j)
            LET ls_item_name = lnode_item.getAttribute("name")
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
 
            IF (ls_item_name.equals(ls_act_name)) THEN
               IF (pi_visible) THEN
                  # 2004/02/18 by Hiko : 若是設定"hidden",則畫面會閃爍一次.
#                 CALL lnode_item.setAttribute("hidden", "0")
                  CALL lnode_item.setAttribute("active", "1")
               ELSE
#                 CALL lnode_item.setAttribute("hidden", "1")
                  CALL lnode_item.setAttribute("active", "0")
               END IF
 
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
