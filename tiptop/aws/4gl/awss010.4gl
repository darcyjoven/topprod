# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: awss010
# Descriptions...: 整合參數維護設定作業
# Date & Author..: No.FUN-BC0116 11/12/27 Abby  
# Modify.........: No.FUN-C10064 12/01/31 Abby CROSS自動化功能補強:自動勾選整合參數功能補強(EF)
# Modify.........: No.FUN-C20087 12/03/03 Abby CROSS追版以上單號

DATABASE ds
 
#FUN-BC0116
#FUN-C20087
 
GLOBALS "../../config/top.global"

DEFINE g_prod_name         LIKE type_file.chr30
DEFINE g_aza72             LIKE aza_file.aza72      #FUN-C10064
DEFINE g_aza72_t           LIKE aza_file.aza72      #FUN-C10064
DEFINE g_azp               DYNAMIC ARRAY of RECORD  # 單身
          chkaza              LIKE type_file.chr1,      
          azp01               LIKE azp_file.azp01,
          azp02               LIKE azp_file.azp02,
          azw02               LIKE azw_file.azw02,
          azw05               LIKE azw_file.azw05 
                           END RECORD
DEFINE g_azp_t             DYNAMIC ARRAY of RECORD  # 變數舊值
          chkaza              LIKE type_file.chr1,      
          azp01               LIKE azp_file.azp01,
          azp02               LIKE azp_file.azp02, 
          azw02               LIKE azw_file.azw02,
          azw05               LIKE azw_file.azw05 
                           END RECORD          
DEFINE   g_cnt             LIKE type_file.num10,  
         g_sql             STRING,
         g_rec_b           LIKE type_file.num5,     # 單身筆數
         l_ac              LIKE type_file.num5,     # 目前處理的ARRAY CNT
         g_chkaza          STRING,                  # 整合產品參數欄位        
         g_azp01           LIKE azp_file.azp01      
DEFINE   g_dbs_sep         LIKE type_file.chr50
DEFINE   g_wc              STRING
                               
MAIN
   DEFINE   p_row,p_col      LIKE type_file.num5
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW awss010_w AT p_row,p_col WITH FORM "aws/42f/awss010"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()

   LET g_prod_name = "1"
   DISPLAY g_prod_name TO g_prod_name

  #FUN-C10064 add str---
   CALL cl_set_comp_visible("aza72", FALSE)  
   CALL cl_set_act_visible("modifyef", FALSE)
  #FUN-C10064 add end---

   CALL s010_b_fill()
   CALL s010_menu()
 
   CLOSE WINDOW awss010_w                    # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION s010_menu()
   WHILE TRUE    
      CALL s010_bp("G")    
      
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL s010_q()
              #FUN-C10064 add str---
               IF g_prod_name = "3" THEN
                  CALL cl_set_act_visible("modifyef", TRUE) 
               ELSE
                  CALL cl_set_act_visible("modifyef", FALSE)
               END IF
              #FUN-C10064 add end---
            END IF

        #FUN-C10064 mod str---
         WHEN "modifyef"
            IF cl_chk_act_auth() THEN
               CALL s010_ef_u() 
               CALL s010_b_u()  
            END IF

         WHEN "dbchoice"
            IF cl_chk_act_auth() THEN
               CALL s010_b()
            END IF
            
        #WHEN "detail"
        #   IF cl_chk_act_auth() THEN
        #      CALL s010_b()
        #   END IF
        #FUN-C10064 mod end---
                       
         WHEN "help"                             # H.求助
            CALL cl_show_help()
            
         WHEN "exit"                             # Esc.結束
            EXIT WHILE
            
         WHEN "controlg"                         # KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION s010_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_azp TO s_azp.* ATTRIBUTE(COUNT=g_rec_b, UNBUFFERED)
         
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
        #FUN-C10064 add str---
         IF g_prod_name = "3" THEN
            CALL cl_set_act_visible("modifyef", TRUE)  
         ELSE
            CALL cl_set_act_visible("modifyef", FALSE)  
         END IF
        #FUN-C10064 add end---
         EXIT DISPLAY  

      ON ACTION query                           # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY

     #FUN-C10064 mod str---
      ON ACTION modifyef                        # 挑選EasyFlow產品類型
         LET g_action_choice="modifyef"
         EXIT DISPLAY

      ON ACTION dbchoice                      
         LET g_action_choice="dbchoice"         # 選擇營運中心
         LET l_ac = 1
         EXIT DISPLAY
        
     #ON ACTION detail                           # B.單身
     #   LET g_action_choice="detail"
     #   LET l_ac = 1
     #   EXIT DISPLAY
     #FUN-C10064 mod end---

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY 
            
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY 
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY 
            
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 

      ON ACTION about      
         CALL cl_about() 
         CONTINUE DISPLAY 
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY  
 
   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION s010_b_fill()   #BODY FILL UP
   DEFINE   l_azw05          LIKE azw_file.azw05      # 實體DB
   
   #取得單身ARRAY資料(取得所有營運中心)
   LET g_sql = "SELECT 'N' AS chkaza,azp01,azp02,azw02,azw05",
               "  FROM azp_file m INNER JOIN azw_file a",
               "    ON m.azp01 = a.azw01",
               " WHERE azwacti = 'Y'",
               " ORDER by azp01"
               
   PREPARE azp_prepare FROM g_sql 
   DECLARE azp_curs CURSOR FOR azp_prepare
   
   CALL g_azp.clear()  #清空單身資料
   LET g_cnt = 1

   FOREACH azp_curs INTO g_azp[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      CASE g_prod_name
         WHEN "1"
            LET g_chkaza = "aza57"
         WHEN "2"
            LET g_chkaza = "aza123"
         WHEN "3"
            LET g_chkaza = "aza23"
         WHEN "4"
            LET g_chkaza = "aza107"
         WHEN "5"
            LET g_chkaza = "aza67"
      END CASE

      #傳入營運中心,取得實體DB
      LET g_azp01 = g_azp[g_cnt].azp01
      CALL s010_get_dbs_sep(g_azp01) RETURNING g_dbs_sep

      #取得各營運中心的aoos010中的ERPII產品整合設定資訊      
      LET g_sql = "SELECT ",g_chkaza,
                  "  FROM ",g_dbs_sep CLIPPED,"aza_file"   

      PREPARE aza_prepare FROM g_sql
      DECLARE aza_curs CURSOR FOR aza_prepare
      
      FOREACH aza_curs INTO g_azp[g_cnt].chkaza  #chkaza單身 ARRAY 填充
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN               #最大單身筆數限制
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_azp.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn1
   LET g_cnt = 1
   DISPLAY g_cnt TO FORMONLY.cnt
   LET g_cnt = 0
END FUNCTION

FUNCTION s010_b()
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_i             LIKE type_file.num10
   DEFINE   l_cnt           LIKE type_file.num5

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = "FALSE"
   LET l_allow_delete = "FALSE"
 
   LET l_ac_t = 0

   INPUT ARRAY g_azp WITHOUT DEFAULTS FROM s_azp.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            LET g_azp_t.* = g_azp.*       #BACKUP
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION controlf  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON ACTION about      
         CALL cl_about() 
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT

      ON ACTION select_all
         FOR l_i = 1 TO g_rec_b
             LET g_azp[l_i].chkaza = "Y"
         END FOR
            
      ON ACTION cancel_all
         FOR l_i = 1 TO g_rec_b
             LET g_azp[l_i].chkaza = "N"
         END FOR

      ON ACTION ACCEPT
         LET g_action_choice = "accept"  
         CALL s010_b_u()
         EXIT INPUT

      ON ACTION cancel
         LET g_action_choice = "cancel"
         LET g_azp.* = g_azp_t.*
         CALL s010_b_fill()
         EXIT INPUT 
         
   END INPUT
 
   IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
   END IF

END FUNCTION

#依單頭產品配合單身營運中心寫入DB
FUNCTION s010_b_u()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_azw05 LIKE azw_file.azw05      # 實體DB
   
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      LET g_azp.* = g_azp_t.*
      RETURN
   END IF

   #確認將整合產品設定參數勾選
   LET l_cnt = g_azp.getLength()
   FOR l_i = 1 TO l_cnt
       BEGIN WORK 
       #傳入營運中心,取得實體DB
       LET g_azp01 = g_azp[l_i].azp01
       CALL s010_get_dbs_sep(g_azp01) RETURNING g_dbs_sep
       IF (NOT cl_null(g_dbs_sep)) AND g_dbs_sep <> " " THEN
          IF g_azp[l_i].chkaza = "Y" THEN
             #變更aza值
             LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"aza_file SET ",g_chkaza," = 'Y', azamodu = '",g_user,"', azadate = '",g_today,"'"," ,aza72 = '",g_aza72,"'"  #FUN-C10064 add aza72
             PREPARE updaza_prepare FROM g_sql
             EXECUTE updaza_prepare
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                LET g_showmsg = g_azp01,' update chkaza,azamodu,azadate:'
                CALL s_errmsg('azp01',g_azp01,g_showmsg,SQLCA.SQLCODE,1)
                LET g_azp.* = g_azp_t.*
                EXIT FOR
             ELSE
                COMMIT WORK
             END IF
          ELSE
             #變更aza值
             LET g_sql = "UPDATE ",g_dbs_sep CLIPPED,"aza_file SET ",g_chkaza," = 'N', azamodu = '",g_user,"', azadate = '",g_today,"'"," ,aza72 = '",g_aza72,"'"  #FUN-C10064 add aza72
             PREPARE updaza_prepare1 FROM g_sql
             EXECUTE updaza_prepare1
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                LET g_showmsg = g_azp01,' update chkaza,azamodu,azadate:'
                CALL s_errmsg('azp01',g_azp01,g_showmsg,SQLCA.SQLCODE,1)
                LET g_azp.* = g_azp_t.*
                EXIT FOR
             ELSE
                COMMIT WORK
             END IF
          END IF
       END IF
   END FOR

END FUNCTION

FUNCTION s010_q()

   MESSAGE ""
   CALL g_azp.clear()
   DISPLAY '' TO FORMONLY.cnt

   CONSTRUCT g_prod_name ON g_prod_name FROM g_prod_name
     #FUN-C10064 add str---
      BEFORE CONSTRUCT
         DISPLAY g_prod_name TO g_prod_name
     #FUN-C10064 add end---
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
   END CONSTRUCT

   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF

   LET g_prod_name = g_prod_name[14,14]
  #FUN-C10064 add str---
   IF g_prod_name = '3' THEN
      CALL cl_set_comp_visible("aza72", TRUE) 
      SELECT aza72 INTO g_aza72 FROM aza_file
      DISPLAY g_aza72 TO aza72
   ELSE
      CALL cl_set_comp_visible("aza72", FALSE)
   END IF
  #FUN-C10064 add end---

   CALL s010_b_fill()
END FUNCTION

#取得實體DB
FUNCTION s010_get_dbs_sep(p_azp01)
   DEFINE p_azp01               LIKE azq_file.azq01
   DEFINE l_dbs                 LIKE type_file.chr20
   DEFINE l_dbs_sep             LIKE type_file.chr50
 
   SELECT azw05 INTO l_dbs FROM azw_file
    WHERE azw01 = p_azp01
      AND azwacti = 'Y'
   CALL s_dbstring(l_dbs) RETURNING l_dbs_sep
   RETURN l_dbs_sep
END FUNCTION

#FUN-C10064 add str---
#變更EasyFloww產品類型，但尚未寫入DB
FUNCTION s010_ef_u()
   MESSAGE ""
   CALL cl_opmsg('u')

   WHILE TRUE
      LET g_aza72_t = g_aza72
      INPUT g_aza72 WITHOUT DEFAULTS FROM aza72

         AFTER INPUT
            IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
            END IF
       
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
       
         ON ACTION about
            CALL cl_about()
       
         ON ACTION controlg
            CALL cl_cmdask()
       
         ON ACTION help
            CALL cl_show_help()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_aza72 = g_aza72_t
         DISPLAY g_aza72 TO aza72
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
#FUN-C10064 add end---
