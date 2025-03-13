# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: ggli2035.4gl
# Descriptions...: MISC對沖科目設定
# Date & Author..: 10/12/24 By lutingting
# Note...........: 本程式目前只提供外部呼叫,沒有查詢的功能
# Modify.........: NO.FUN-B40104 By jll
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50202 13/05/23 By fengmy q_m_aag2營運中心參數錯誤

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-750058
#模組變數(Module Variables)    #FUN-BB0036
DEFINE
    m_asuu             RECORD LIKE asuu_file.*,
    g_asuu             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        asuu03         LIKE asuu_file.asuu03,
        aag02         LIKE aag_file.aag02,
        asuu04         LIKE asuu_file.asuu04,
        asuu05         LIKE asuu_file.asuu05,
        asuu06         LIKE asuu_file.asuu06
                      END RECORD,
    g_asuu_t           RECORD                 #程式變數 (舊值)
        asuu03         LIKE asuu_file.asuu03,
        aag02         LIKE aag_file.aag02,
        asuu04         LIKE asuu_file.asuu04,
        asuu05         LIKE asuu_file.asuu05,
        asuu06         LIKE asuu_file.asuu06
                      END RECORD,
    a                 LIKE type_file.chr1,
    g_wc,g_sql,l_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,   
    g_ss              LIKE type_file.chr1,   
    l_ac              LIKE type_file.num5,   #目前處理的ARRAY CNT
    g_argv1           LIKE asuu_file.asuu00,   #來源帳別(asq00)
    g_argv2           LIKE asuu_file.asuu01   #來源會計科目編號(asq02)
DEFINE p_row,p_col    LIKE type_file.num5    
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_sql_tmp    STRING
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03
DEFINE   g_row_count   LIKE type_file.num10
DEFINE   g_curs_index  LIKE type_file.num10
DEFINE   g_asz01       LIKE asz_file.asz01 
DEFINE   g_azp01       LIKE type_file.chr21   #MOD-D50202

MAIN

   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)

   LET p_row = 3 LET p_col = 16

   OPEN WINDOW i0035_w AT p_row,p_col
     WITH FORM "ggl/42f/ggli2035"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   
   CALL cl_set_comp_visible("asuu06",FALSE)    #FUN-950052 

   CALL i0035_q()
   CALL i0035_menu()

   CLOSE WINDOW i0035_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i0035_cs()
    LET l_sql="SELECT UNIQUE asuu00,asuu01",
              "  FROM asuu_file ",
              " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY asuu00,asuu01"
    PREPARE i0035_prepare FROM g_sql      #預備一下
    DECLARE i0035_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i0035_prepare

    DROP TABLE i0035_cnttmp
    LET g_sql_tmp=l_sql," INTO TEMP i0035_cnttmp"
    
    PREPARE i0035_cnttmp_pre FROM g_sql_tmp  
    EXECUTE i0035_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i0035_cnttmp"      
    
    PREPARE i0035_precount FROM g_sql
    DECLARE i0035_count CURSOR FOR i0035_precount
END FUNCTION

FUNCTION i0035_menu()

   WHILE TRUE
      CALL i0035_bp("G")
      CASE g_action_choice
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i0035_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i0035_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i0035_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE m_asuu.* TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_asuu.clear()
   DISPLAY '' TO FORMONLY.cnt

   LET g_wc = " asuu00 = '",g_argv1,"'",
              " AND asuu01 = '",g_argv2,"' "
   CALL i0035_cs()                      #取得查詢條件

   OPEN i0035_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
     #外部呼叫,新增時
     LET m_asuu.asuu00 = g_argv1
     LET m_asuu.asuu01 = g_argv2
     DISPLAY m_asuu.asuu01 TO asq02
   ELSE
      OPEN i0035_count
      FETCH i0035_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i0035_fetch('F')            #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

#處理資料的讀取
FUNCTION i0035_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式  
   l_abso          LIKE type_file.num10   #絕對的筆數

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i0035_bcs INTO m_asuu.asuu00,m_asuu.asuu01
       WHEN 'P' FETCH PREVIOUS i0035_bcs INTO m_asuu.asuu00,m_asuu.asuu01 
       WHEN 'F' FETCH FIRST    i0035_bcs INTO m_asuu.asuu00,m_asuu.asuu01
       WHEN 'L' FETCH LAST     i0035_bcs INTO m_asuu.asuu00,m_asuu.asuu01
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
              
               ON ACTION about        
                  CALL cl_about()    
              
               ON ACTION help         
                  CALL cl_show_help()
              
               ON ACTION controlg   
                  CALL cl_cmdask() 
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso i0035_bcs INTO m_asuu.asuu00,m_asuu.asuu01 
   END CASE

   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(m_asuu.asuu01,SQLCA.sqlcode,0)
      #外部呼叫,新增時
      LET m_asuu.asuu00 = g_argv1
      LET m_asuu.asuu01 = g_argv2
      DISPLAY m_asuu.asuu01 TO asq02
   ELSE
      CALL i0035_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF

END FUNCTION

#將資料顯示在畫面上
FUNCTION i0035_show()
 
   DISPLAY m_asuu.asuu01 TO asq02
   CALL i0035_b_fill(g_wc)                      #單身
   CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

#單身
FUNCTION i0035_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,          #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否      
   p_cmd           LIKE type_file.chr1,          #處理狀態       
   l_allow_insert  LIKE type_file.num5,          #可新增否      
   l_allow_delete  LIKE type_file.num5,          #可刪除否     
   l_cnt           LIKE type_file.num10,     
   l_asg           RECORD LIKE asg_file.*,
   l_asa09         LIKE asa_file.asa09      

   LET g_action_choice = ""
   SELECT azp01 INTO g_azp01 FROM azp_file WHERE azp03=g_dbs #MOD-D50202
   LET g_dbs = g_dbs,"."
   IF cl_null(m_asuu.asuu00) OR cl_null(m_asuu.asuu01)  THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   IF s_shut(0) THEN
      RETURN
   END IF

   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'
   
   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT asuu03,'',asuu04,asuu05,asuu06 FROM asuu_file",
                      " WHERE asuu00 = ? AND asuu01= ? AND asuu03 = ?",
                      "   FOR UPDATE  "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                   
   DECLARE i0035_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

#   IF g_rec_b=0 THEN CALL g_asuu.clear() END IF

   INPUT ARRAY g_asuu WITHOUT DEFAULTS FROM s_asuu.*

      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_asuu_t.* = g_asuu[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i0035_bcl USING m_asuu.asuu00,m_asuu.asuu01,g_asuu_t.asuu03
            IF STATUS THEN
               CALL cl_err("OPEN i0035_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i0035_bcl INTO g_asuu[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i0035_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i0035_set_asuu03(g_asuu[l_ac].asuu03) RETURNING g_asuu[l_ac].aag02
                  LET g_asuu_t.*=g_asuu[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_asuu[l_ac].* TO NULL 
         LET g_asuu[l_ac].asuu04='N'
         LET g_asuu[l_ac].asuu05='N'
         LET g_asuu[l_ac].asuu06='N'
         LET g_asuu_t.* = g_asuu[l_ac].*               #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD asuu03

      AFTER FIELD asuu03                         # check data 是否重複
         IF NOT cl_null(g_asuu[l_ac].asuu03) THEN
            IF g_asuu[l_ac].asuu03 != g_asuu_t.asuu03 OR g_asuu_t.asuu03 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM asuu_file
                     WHERE asuu00=m_asuu.asuu00
                       AND asuu01=m_asuu.asuu01
                       AND asuu03=g_asuu[l_ac].asuu03
               IF (SQLCA.sqlcode) OR (l_cnt>0) THEN
                  CALL cl_err3("sel","asuu_file",g_asuu[l_ac].asuu03,"","-239","","",1)
                  LET g_asuu[l_ac].asuu03=g_asuu_t.asuu03
                  LET g_asuu[l_ac].aag02=g_asuu_t.aag02
                  DISPLAY BY NAME g_asuu[l_ac].asuu03,g_asuu[l_ac].aag02
                  NEXT FIELD CURRENT
               END IF
               CALL i0035_set_asuu03(g_asuu[l_ac].asuu03)
                          RETURNING g_asuu[l_ac].aag02
               DISPLAY BY NAME g_asuu[l_ac].aag02
               IF cl_null(g_asuu[l_ac].aag02) THEN
                   CALL cl_err('','abg-010',0)
                   NEXT FIELD asuu03
               END IF
            END IF
         ELSE
            LET g_asuu[l_ac].aag02 = null
            DISPLAY BY NAME g_asuu[l_ac].aag02
         END IF

      AFTER FIELD asuu04
         IF g_asuu[l_ac].asuu04 = 'Y' THEN
         END IF
      AFTER INSERT
         IF INT_FLAG OR cl_null(g_asuu[l_ac].asuu03) THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_asuu[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_asuu[l_ac].* TO s_asuu.*
            ROLLBACK WORK
            CANCEL INSERT
         END IF
         INSERT INTO asuu_file(asuu00,asuu01,asuu03,asuu04,asuu05,asuu06)
         VALUES(m_asuu.asuu00,m_asuu.asuu01,g_asuu[l_ac].asuu03,
                g_asuu[l_ac].asuu04,g_asuu[l_ac].asuu05,g_asuu[l_ac].asuu06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","asuu_file",g_asuu[l_ac].asuu03,'',SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE DELETE                            #是否取消單身
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF

            DELETE FROM asuu_file 
                  WHERE asuu00=m_asuu.asuu00
                    AND asuu01=m_asuu.asuu01
                    AND asuu03=g_asuu_t.asuu03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","asuu_file",g_asuu[l_ac].asuu03,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_asuu[l_ac].* = g_asuu_t.*
            CLOSE i0035_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_asuu[l_ac].asuu03,-263,1)
            LET g_asuu[l_ac].* = g_asuu_t.*
         ELSE
            UPDATE asuu_file SET asuu03 = g_asuu[l_ac].asuu03,
                                asuu04 = g_asuu[l_ac].asuu04,
                                asuu05 = g_asuu[l_ac].asuu05,
                                asuu06 = g_asuu[l_ac].asuu06
                          WHERE asuu00=m_asuu.asuu00
                            AND asuu01=m_asuu.asuu01
                            AND asuu03=g_asuu_t.asuu03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","asuu_file",g_asuu[l_ac].asuu03,"",SQLCA.sqlcode,"","",1)
               LET g_asuu[l_ac].* = g_asuu_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_asuu[l_ac].* = g_asuu_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_asuu.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i0035_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032 Add
         CLOSE i0035_bcl
         COMMIT WORK

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asuu03)
              #CALL q_m_aag2(FALSE,TRUE,g_dbs,g_asuu[l_ac].asuu03,'23',g_asz01)  #MOD-D50202 mark
               CALL q_m_aag2(FALSE,TRUE,g_azp01,g_asuu[l_ac].asuu03,'23',g_asz01)  #MOD-D50202 
                    RETURNING g_asuu[l_ac].asuu03
               DISPLAY g_asuu[l_ac].asuu03
               NEXT FIELD asuu03
         END CASE

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(asuu03) AND l_ac > 1 THEN   
            LET g_asuu[l_ac].* = g_asuu[l_ac-1].*
            NEXT FIELD asuu03
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help         
         CALL cl_show_help()
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT

   CLOSE i0035_bcl
   COMMIT WORK
 
END FUNCTION

FUNCTION i0035_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING

   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'    #MOD-D50202

   LET g_sql = "SELECT asuu03,'',asuu04,asuu05,asuu06",
               "  FROM asuu_file ",
               " WHERE asuu00 = '",m_asuu.asuu00,"'",
               "   AND asuu01 = '",m_asuu.asuu01,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY asuu03"
   PREPARE i0035_prepare2 FROM g_sql       #預備一下
   DECLARE asuu_cs CURSOR FOR i0035_prepare2

   CALL g_asuu.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH asuu_cs INTO g_asuu[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i0035_set_asuu03(g_asuu[g_cnt].asuu03) RETURNING g_asuu[g_cnt].aag02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_asuu.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i0035_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asuu TO s_asuu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i0035_set_asuu03(p_asuu03)
DEFINE p_asuu03 LIKE asuu_file.asuu03,
       l_aag02 LIKE aag_file.aag02

   SELECT aag02 INTO l_aag02 FROM aag_file
    WHERE aag00=g_asz01
      AND aag01=p_asuu03
   IF SQLCA.sqlcode THEN
      LET l_aag02=NULL
   END IF
   RETURN l_aag02
END FUNCTION

FUNCTION i0035_r()
   IF cl_null(m_asuu.asuu01) OR cl_null(m_asuu.asuu00) THEN 
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   DELETE FROM asuu_file
               WHERE asuu00=m_asuu.asuu00
                 AND asuu01=m_asuu.asuu01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","asuu_file",m_asuu.asuu01,m_asuu.asuu03,SQLCA.sqlcode,"","del asuu",1)
      RETURN      
   END IF   

   INITIALIZE m_asuu.* TO NULL
   MESSAGE ""
   DROP TABLE i0035_cnttmp
   PREPARE i0035_precount_x2 FROM g_sql_tmp
   EXECUTE i0035_precount_x2
   OPEN i0035_count
   FETCH i0035_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i0035_bcs
      CALL i0035_fetch('F') 
   ELSE
      DISPLAY m_asuu.asuu01 TO asq02
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_asuu.clear()
      CALL i0035_menu()
   END IF                      
END FUNCTION


FUNCTION i0035_set_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1  

   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("b",TRUE)
   END IF

END FUNCTION

FUNCTION i0035_set_no_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1 

   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      IF a != '1' THEN
         CALL cl_set_comp_entry("b",FALSE)
      END IF
   END IF
END FUNCTION
#NO.FUN-B40104
