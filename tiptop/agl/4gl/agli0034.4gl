# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: agli0034.4gl
# Descriptions...: MISC來源科目設定
# Date & Author..: 10/12/24 By lutingting copy from agli0031,无族群以及公司
#
# Note...........: 本程式目前只提供外部呼叫,沒有查詢的功能
# Modify.........: NO.FUN-B40104 11/05/05 By jll
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    m_axss             RECORD LIKE axss_file.*,
    g_axss             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        axss03         LIKE axss_file.axss03,
        aag02         LIKE aag_file.aag02
                      END RECORD,
    g_axss_t           RECORD                 #程式變數 (舊值)
        axss03         LIKE axss_file.axss03,
        aag02         LIKE aag_file.aag02
                      END RECORD,
    a                 LIKE type_file.chr1,
    g_wc,g_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,   
    g_ss              LIKE type_file.chr1,   
    l_ac              LIKE type_file.num5,   #目前處理的ARRAY CNT
    g_argv1           LIKE axss_file.axss00,
    g_argv2           LIKE axss_file.axss01
DEFINE p_row,p_col    LIKE type_file.num5    
DEFINE g_aaw01       LIKE aaw_file.aaw01 
DEFINE g_axz03        LIKE axz_file.axz03 
DEFINE g_dbs_axz03    LIKE type_file.chr21 

#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_sql_tmp    STRING
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03
DEFINE   g_row_count   LIKE type_file.num10
DEFINE   g_curs_index  LIKE type_file.num10

MAIN

   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)

   SELECT aaw01 INTO g_aaw01 FROM aaw_file WHERE aaw00 = '0'
   LET p_row = 3 LET p_col = 16

   OPEN WINDOW i0034_w AT p_row,p_col
     WITH FORM "agl/42f/agli0034"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL i0034_q()
   CALL i0034_menu()

   CLOSE WINDOW i0034_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i0034_cs()
DEFINE l_sql STRING
    LET l_sql="SELECT UNIQUE axss00,axss01",  
              "  FROM axss_file ",
              " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY axss00,axss01" 
    PREPARE i0034_prepare FROM g_sql                             #預備一下
    DECLARE i0034_bcs SCROLL CURSOR WITH HOLD FOR i0034_prepare  #宣告成可捲動的

    DROP TABLE i0034_cnttmp
    LET g_sql_tmp=l_sql," INTO TEMP i0034_cnttmp"
    
    PREPARE i0034_cnttmp_pre FROM g_sql_tmp
    EXECUTE i0034_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i0034_cnttmp"      
    
    PREPARE i0034_precount FROM g_sql
    DECLARE i0034_count CURSOR FOR i0034_precount
  
END FUNCTION

FUNCTION i0034_menu()

   WHILE TRUE
      CALL i0034_bp("G")
      CASE g_action_choice
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i0034_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i0034_b()
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

FUNCTION i0034_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE m_axss.* TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axss.clear()
   DISPLAY '' TO FORMONLY.cnt

   LET g_wc = " axss00 = '",g_argv1,"'",
              " AND axss01 = '",g_argv2,"'"
   CALL i0034_cs()                      #取得查詢條件

   OPEN i0034_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
     #INITIALIZE m_axss.* TO NULL 
     #外部呼叫,新增時
     LET m_axss.axss00 = g_argv1
     LET m_axss.axss01 = g_argv2
     DISPLAY m_axss.axss01 TO axf01
   ELSE
      OPEN i0034_count
      FETCH i0034_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i0034_fetch('F')            #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

#處理資料的讀取
FUNCTION i0034_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   
   l_abso          LIKE type_file.num10   #絕對的筆數

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i0034_bcs INTO m_axss.axss00,m_axss.axss01 
       WHEN 'P' FETCH PREVIOUS i0034_bcs INTO m_axss.axss00,m_axss.axss01 
       WHEN 'F' FETCH FIRST    i0034_bcs INTO m_axss.axss00,m_axss.axss01
       WHEN 'L' FETCH LAST     i0034_bcs INTO m_axss.axss00,m_axss.axss01
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
            FETCH ABSOLUTE l_abso i0034_bcs INTO m_axss.axss00,m_axss.axss01 
   END CASE

   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(m_axss.axss01,SQLCA.sqlcode,0)
      #外部呼叫,新增時
      LET m_axss.axss00 = g_argv1
      LET m_axss.axss01 = g_argv2
      DISPLAY m_axss.axss01 TO axf01
   ELSE
      CALL i0034_show()
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
FUNCTION i0034_show()
 
   DISPLAY m_axss.axss01 TO axf01
   CALL i0034_b_fill(g_wc)                      #單身
   CALL cl_show_fld_cont()      
END FUNCTION

#單身
FUNCTION i0034_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,          #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否      
   p_cmd           LIKE type_file.chr1,          #處理狀態       
   l_allow_insert  LIKE type_file.num5,          #可新增否      
   l_allow_delete  LIKE type_file.num5,          #可刪除否     
   l_cnt           LIKE type_file.num10,      
   l_axz           RECORD LIKE axz_file.*

   LET g_action_choice = ""
   LET g_dbs = g_dbs,"."
   IF cl_null(m_axss.axss01) OR cl_null(m_axss.axss00) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT axss03,'' FROM axss_file",
                      " WHERE axss00 = ? AND axss01 = ? AND axss03 = ?",
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)  
                      
   DECLARE i0034_bcl CURSOR FROM g_forupd_sql 

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   IF g_rec_b=0 THEN CALL g_axss.clear() END IF

   INPUT ARRAY g_axss WITHOUT DEFAULTS FROM s_axss.*

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
            LET g_axss_t.* = g_axss[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i0034_bcl USING m_axss.axss00,m_axss.axss01,g_axss_t.axss03
            IF STATUS THEN
               CALL cl_err("OPEN i0034_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i0034_bcl INTO g_axss[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i0034_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i0034_set_axss03(g_axss[l_ac].axss03) RETURNING g_axss[l_ac].aag02
                  LET g_axss_t.*=g_axss[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axss[l_ac].* TO NULL           
         LET g_axss_t.* = g_axss[l_ac].*               #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD axss03

      AFTER FIELD axss03                         # check data 是否重複
         IF NOT cl_null(g_axss[l_ac].axss03) THEN
            IF g_axss[l_ac].axss03 != g_axss_t.axss03 OR g_axss_t.axss03 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM axss_file
                     WHERE axss00=m_axss.axss00
                       AND axss01=m_axss.axss01
                       AND axss03=g_axss[l_ac].axss03
               IF (SQLCA.sqlcode) OR (l_cnt>0) THEN
                  CALL cl_err3("sel","axss_file",g_axss[l_ac].axss03,"","-239","","",1)
                  LET g_axss[l_ac].axss03=g_axss_t.axss03
                  LET g_axss[l_ac].aag02=g_axss_t.aag02
                  DISPLAY BY NAME g_axss[l_ac].axss03,g_axss[l_ac].aag02
                  NEXT FIELD CURRENT
               END IF
               LET l_cnt=0
               CALL i0034_set_axss03(g_axss[l_ac].axss03)
                          RETURNING g_axss[l_ac].aag02
               DISPLAY BY NAME g_axss[l_ac].aag02
               IF cl_null(g_axss[l_ac].aag02) THEN
                   CALL cl_err('','abg-010',0)
                   NEXT FIELD axss03
               END IF
            END IF
         ELSE
            LET g_axss[l_ac].aag02 = null
            DISPLAY BY NAME g_axss[l_ac].aag02
         END IF

      AFTER INSERT
         IF INT_FLAG OR cl_null(g_axss[l_ac].axss03) THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_axss[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_axss[l_ac].* TO s_axss.*
            ROLLBACK WORK
            CANCEL INSERT
         END IF
         INSERT INTO axss_file(axss00,axss01,axss03)
         VALUES(m_axss.axss00,m_axss.axss01,g_axss[l_ac].axss03)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axss_file",g_axss[l_ac].axss03,'',SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_axss_t.axss03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM axss_file 
                  WHERE axss00=m_axss.axss00
                    AND axss01=m_axss.axss01
                    AND axss03=g_axss_t.axss03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axss_file",g_axss[l_ac].axss03,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_axss[l_ac].* = g_axss_t.*
            CLOSE i0034_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axss[l_ac].axss03,-263,1)
            LET g_axss[l_ac].* = g_axss_t.*
         ELSE
            UPDATE axss_file SET axss03 = g_axss[l_ac].axss03
                          WHERE axss00=m_axss.axss00
                            AND axss01=m_axss.axss01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","axss_file",g_axss[l_ac].axss03,"",SQLCA.sqlcode,"","",1)
               LET g_axss[l_ac].* = g_axss_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_axss[l_ac].* = g_axss_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_axss.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i0034_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 add
         CLOSE i0034_bcl
         COMMIT WORK

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axss03)
                CALL q_m_aag2(FALSE,TRUE,g_dbs,g_axss[l_ac].axss03,'23',g_aaw01)
                     RETURNING g_axss[l_ac].axss03
                DISPLAY g_axss[l_ac].axss03
                NEXT FIELD axss03
         END CASE

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(axss02) AND l_ac > 1 THEN
            LET g_axss[l_ac].* = g_axss[l_ac-1].*
            LET g_axss[l_ac].axss03=null
            NEXT FIELD axss03
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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

   CLOSE i0034_bcl
   COMMIT WORK
 
END FUNCTION

FUNCTION i0034_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING

   LET g_sql = "SELECT axss03,''",
               " FROM axss_file ",
               " WHERE axss00 = '",m_axss.axss00,"'",
               "   AND axss01 = '",m_axss.axss01,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY axss03"
   PREPARE i0034_prepare2 FROM g_sql       #預備一下
   DECLARE axss_cs CURSOR FOR i0034_prepare2

   CALL g_axss.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH axss_cs INTO g_axss[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i0034_set_axss03(g_axss[g_cnt].axss03) RETURNING g_axss[g_cnt].aag02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_axss.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i0034_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axss TO s_axss.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
      
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY

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

FUNCTION i0034_set_axss03(p_axss03)
DEFINE p_axss03 LIKE axss_file.axss03,
       l_aag02  LIKE aag_file.aag02

   SELECT aag02 INTO l_aag02
     FROM aag_file
    WHERE aag00 = g_aaw01
      AND aag01 = p_axss03

   IF SQLCA.sqlcode THEN
      LET l_aag02=NULL
   END IF
   RETURN l_aag02
END FUNCTION

FUNCTION i0034_r()
   IF cl_null(m_axss.axss01) OR cl_null(m_axss.axss00)  THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   DELETE FROM axss_file
               WHERE axss00=m_axss.axss00
                 AND axss01=m_axss.axss01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","axss_file",m_axss.axss01,m_axss.axss03,SQLCA.sqlcode,"","del axss",1)
      RETURN      
   END IF   

   INITIALIZE m_axss.* TO NULL
   MESSAGE ""
   DROP TABLE i0034_cnttmp
   PREPARE i0034_precount_x2 FROM g_sql_tmp
   EXECUTE i0034_precount_x2
   OPEN i0034_count
   FETCH i0034_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i0034_bcs
      CALL i0034_fetch('F') 
   ELSE
      DISPLAY m_axss.axss01 TO axf01
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_axss.clear()
      CALL i0034_menu()
   END IF                      
END FUNCTION

FUNCTION i0034_set_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)

   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("b",TRUE)
   END IF

END FUNCTION

FUNCTION i0034_set_no_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1     #No.FUN-680098  VARCHAR(01)

   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      IF a != '1' THEN
         CALL cl_set_comp_entry("b",FALSE)
      END IF
   END IF
END FUNCTION
#No.FUN-B40104 
