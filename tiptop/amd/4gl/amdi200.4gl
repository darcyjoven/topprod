# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: amdi200.4gl
# Descriptions...: 賣方廠編維護作業
# Date & Author..: 10/11/18 By sabrina
# Modify.........: No:FUN-AB0080 10/11/18 By sabrina create program
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_argv1         LIKE amg_file.amg01,
    g_amg01         LIKE amg_file.amg01,
    g_amg01_t       LIKE amg_file.amg01,
    g_amg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        amg02       LIKE amg_file.amg02,   #產品編號類別代碼
        azf03       LIKE azf_file.azf03,   #品號類別名稱
        amg03       LIKE amg_file.amg03,   #賣方廠編
        amgacti     LIKE amg_file.amgacti  #有效否 
                    END RECORD,
    g_amg_t         RECORD                 #程式變數 (舊值)
        amg02       LIKE amg_file.amg02,   #產品編號類別代碼
        azf03       LIKE azf_file.azf03,   #品號類別名稱
        amg03       LIKE amg_file.amg03,   #賣方廠編
        amgacti     LIKE amg_file.amgacti  #有效否 
                    END RECORD,
     g_wc,g_sql     string,  
     g_wc2          string,  
    g_rec_b         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10    
DEFINE   g_curs_index          LIKE type_file.num10    
DEFINE   g_row_count           LIKE type_file.num10    
DEFINE   g_jump                LIKE type_file.num10    
DEFINE   g_msg                 LIKE type_file.chr1000  
DEFINE   g_no_ask              LIKE type_file.num5     


MAIN
  DEFINE   p_row,p_col    LIKE type_file.num5

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1   = ARG_VAL(1) 
   LET g_amg01   = g_argv1
   LET g_amg01_t = g_amg01
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET p_row = 5 LET p_col = 10

   OPEN WINDOW i200_w AT p_row,p_col WITH FORM "amd/42f/amdi200"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   DISPLAY g_amg01 TO amg01
   LET g_wc = " amg01 ='",g_amg01 CLIPPED,"' " 
 
   CALL i200_menu()
 
   CLOSE WINDOW i200_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i200_curs()
    DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
 
    CLEAR FORM
    CALL g_amg.clear()
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "amg01 = '",g_argv1,"'"
    ELSE
       CALL cl_set_head_visible("","YES")
       INITIALIZE g_amg01 TO NULL
       CONSTRUCT g_wc ON amg01 FROM amg01 
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION help          
             CALL cl_show_help()  
          
          ON ACTION controlg      
             CALL cl_cmdask()     
       
          ON ACTION qbe_select
             CALL cl_qbe_select() 

          ON ACTION qbe_save
             CALL cl_qbe_save()

       END CONSTRUCT

       LET g_wc = g_wc CLIPPED

       IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    END IF

    LET g_sql = "SELECT UNIQUE amg01 ",
                "  FROM amg_file ",
                " WHERE ", g_wc CLIPPED,                     #單身
                " ORDER BY amg01"
    PREPARE i200_pre FROM g_sql          # 預備一下
    DECLARE i200_curs 
      SCROLL CURSOR WITH HOLD FOR i200_pre

END FUNCTION

FUNCTION i200_count()

   DEFINE li_cnt   LIKE type_file.num10   
   DEFINE li_rec_b LIKE type_file.num10  
 
   LET g_sql= "SELECT UNIQUE amg01 FROM amg_file ", 
              " WHERE ", g_wc CLIPPED,
              " GROUP BY amg01 ORDER BY amg01"      
 
   PREPARE i200_precount FROM g_sql
   DECLARE i200_count CURSOR FOR i200_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i200_count INTO g_amg[li_cnt].*  
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b
 
END FUNCTION

FUNCTION i200_menu()
 
   WHILE TRUE
      CALL i200_bp()
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i200_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_amg),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i200_a()

  MESSAGE ""
  CLEAR FORM
  CALL g_amg.clear()
  LET g_wc = NULL
  INITIALIZE g_amg01 LIKE amg_file.amg01

  WHILE TRUE
     CALL i200_i("a")                       # 輸入單頭
 
     IF INT_FLAG THEN                            # 使用者不玩了
        LET g_amg01=NULL
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
     LET g_rec_b = 0
 
     CALL i200_b()                          # 輸入單身
     LET g_amg01_t=g_amg01
     EXIT WHILE
  END WHILE

END FUNCTION

FUNCTION i200_i(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_count    LIKE type_file.num5    
   DEFINE l_cnt      LIKE type_file.num5 
 
   DISPLAY g_amg01 TO amg01
   CALL cl_set_head_visible("","YES")   
   INPUT g_amg01 WITHOUT DEFAULTS FROM amg01 
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF NOT cl_null(g_amg01) THEN
            IF (g_amg01 != g_amg01_t) OR cl_null(g_amg01_t) THEN
               LET l_cnt = 0
               SELECT COUNT(amg01) INTO l_cnt FROM amg_file
                WHERE amg01 = g_amg01
               IF l_cnt > 0 THEN
                  CALL cl_err(g_amg01,'-239',1)
                  NEXT FIELD amg01
               END IF
            END IF
         END IF
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT

END FUNCTION

FUNCTION i200_q()

   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  
   CALL g_amg.clear()
   DISPLAY '' TO FORMONLY.cn2
   CALL i200_curs()                         #取得查詢條件

   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF

   OPEN i200_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_amg01 TO NULL
   ELSE
      CALL i200_count()
      DISPLAY g_row_count TO FORMONLY.cn2
      CALL i200_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i200_show()

  DISPLAY g_amg01 TO amg01
  CALL i200_b_fill(g_wc)                    
  CALL cl_show_fld_cont()                  

END FUNCTION

FUNCTION i200_b()
   DEFINE l_ac_t          LIKE type_file.num5,    
          l_n             LIKE type_file.num5,    
          l_lock_sw       LIKE type_file.chr1,    
          p_cmd           LIKE type_file.chr1,    
          l_allow_insert  LIKE type_file.num5,    
          l_allow_delete  LIKE type_file.num5,    
          l_azf03         LIKE azf_file.azf03,
          l_imz02         LIKE imz_file.imz02,
          l_oba02         LIKE oba_file.oba02 


   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   LET g_forupd_sql = " SELECT amg02,' ',amg03,amgacti FROM amg_file ",   
                      "  WHERE amg01= ? AND amg02= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_amg WITHOUT DEFAULTS FROM s_amg.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_amg_t.* = g_amg[l_ac].*  #BACKUP
            OPEN i200_bcl USING g_amg01,g_amg_t.amg02
            IF STATUS THEN
               CALL cl_err("OPEN i200_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i200_bcl INTO g_amg[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_amg01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  IF g_amg01 MATCHES "[DEF]" THEN
                     SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_amg[l_ac].amg02 and azf02=g_amg01
                     LET g_amg[l_ac].azf03 = l_azf03
                  ELSE
                     IF g_amg01 = 'M' THEN
                        SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = g_amg[l_ac].amg02
                        LET g_amg[l_ac].azf03 = l_imz02
                     ELSE
                        SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_amg[l_ac].amg02
                        LET g_amg[l_ac].azf03 = l_oba02
                     END IF
                  END IF
                  DISPLAY BY NAME g_amg[l_ac].azf03
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_amg[l_ac].* TO NULL      
         LET g_amg[l_ac].amgacti = 'Y'       
         LET g_amg_t.* = g_amg[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     
         NEXT FIELD amg02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO amg_file(amg01,amg02,amg03,amgacti)
                       VALUES(g_amg01,g_amg[l_ac].amg02,g_amg[l_ac].amg03,
                              g_amg[l_ac].amgacti)      
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","amg_file",g_amg01,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn1  
         END IF
 
      AFTER FIELD amg02                        
         IF NOT cl_null(g_amg[l_ac].amg02) THEN
            IF (g_amg[l_ac].amg02 != g_amg_t.amg02) OR (g_amg_t.amg02 IS NULL) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM amg_file
                WHERE amg02 = g_amg[l_ac].amg02 AND amg01 = g_amg01
               IF cl_null(l_n) THEN LET l_n = 0 END IF
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_amg[l_ac].amg02 = g_amg_t.amg02
                  NEXT FIELD amg02
               END IF
            END IF
            LET l_n = 0
            IF g_amg01 MATCHES "[DEF]" THEN
               SELECT COUNT(*) INTO l_n FROM azf_file
                WHERE azf01 = g_amg[l_ac].amg02 AND azf02 = g_amg01
                  AND azfacti = 'Y'
            ELSE
               IF g_amg01 = 'M' THEN
                  SELECT COUNT(*) INTO l_n FROM imz_file
                    WHERE imz01 = g_amg[l_ac].amg02
                      AND imzacti = 'Y'
               ELSE
                  IF g_amg01 = 'P' THEN 
                     SELECT COUNT(*) INTO l_n FROM oba_file
                      WHERE oba14= '0' AND obaacti = 'Y'
                        AND oba01 = g_amg[l_ac].amg02
                  END IF
               END IF
            END IF
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err('','apm-800',0)
              #LET g_amg[l_ac].amg02 = g_amg_t.amg02
               NEXT FIELD amg02
            ELSE
               IF g_amg01 MATCHES "[DEF]" THEN
                  SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_amg[l_ac].amg02 and azf02=g_amg01
                  LET g_amg[l_ac].azf03 = l_azf03
               ELSE
                  IF g_amg01 = 'M' THEN
                     SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = g_amg[l_ac].amg02
                     LET g_amg[l_ac].azf03 = l_imz02
                  ELSE
                     SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_amg[l_ac].amg02
                     LET g_amg[l_ac].azf03 = l_oba02
                  END IF
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_amg_t.amg02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM amg_file WHERE amg01 = g_amg01 AND amg02 = g_amg_t.amg02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","amg_file",g_amg01,"",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn1  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_amg[l_ac].* = g_amg_t.*
            CLOSE i200_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_amg01,-263,1)
            LET g_amg[l_ac].* = g_amg_t.*
         ELSE
            UPDATE amg_file SET amg02=g_amg[l_ac].amg02,
                                amg03=g_amg[l_ac].amg03,
                                amgacti=g_amg[l_ac].amgacti 
             WHERE amg01 = g_amg01
               AND amg02 = g_amg_t.amg02 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","amg_file",g_amg01,g_amg_t.amg02,SQLCA.sqlcode,"","",1)  
               LET g_amg[l_ac].* = g_amg_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac     #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_amg[l_ac].* = g_amg_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_amg.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i200_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032  add   
         CLOSE i200_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(amg02)     
                CALL cl_init_qry_var()
                IF g_amg01 MATCHES "[DEF]" THEN
                   LET g_qryparam.form ="q_azf" 
                   LET g_qryparam.arg1 = g_amg01 
                ELSE
                   IF g_amg01 = 'M' THEN
                      LET g_qryparam.form ="q_imz"
                   ELSE
                      LET g_qryparam.form ="q_oba_01"
                   END IF
                END IF    
                LET g_qryparam.default1 = g_amg[l_ac].amg02
                CALL cl_create_qry() RETURNING g_amg[l_ac].amg02 
                IF g_amg01 MATCHES "[DEF]" THEN
                   SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_amg[l_ac].amg02 and azf02=g_amg01
                   LET g_amg[l_ac].azf03 = l_azf03
                ELSE
                   IF g_amg01 = 'M' THEN
                      SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = g_amg[l_ac].amg02
                      LET g_amg[l_ac].azf03 = l_imz02
                   ELSE
                      SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_amg[l_ac].amg02
                      LET g_amg[l_ac].azf03 = l_oba02
                   END IF
                END IF
                DISPLAY BY NAME g_amg[l_ac].amg02
                DISPLAY BY NAME g_amg[l_ac].azf03
                NEXT FIELD amg02
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(amg01) AND l_ac > 1 THEN
            LET g_amg[l_ac].* = g_amg[l_ac-1].*
            NEXT FIELD amg01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
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
 
   CLOSE i200_bcl
 
   COMMIT WORK
 
END FUNCTION

FUNCTION i200_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式     
            l_abso   LIKE type_file.num10         #絕對的筆數   
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i200_curs INTO g_amg01
      WHEN 'P' FETCH PREVIOUS i200_curs INTO g_amg01
      WHEN 'F' FETCH FIRST    i200_curs INTO g_amg01
      WHEN 'L' FETCH LAST     i200_curs INTO g_amg01
      WHEN '/' 
         IF (NOT g_no_ask) THEN          
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i200_curs INTO g_amg01
         LET g_no_ask = FALSE  
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_amg01,SQLCA.sqlcode,0)
      INITIALIZE g_amg01 TO NULL  
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL i200_show()
   END IF

END FUNCTION

 
FUNCTION i200_b_fill(p_wc)              
   DEFINE p_wc        LIKE type_file.chr1000  
   DEFINE l_azf03     LIKE azf_file.azf03      
   DEFINE l_imz02     LIKE imz_file.imz02
   DEFINE l_oba02     LIKE oba_file.oba02 
 
   LET g_sql = "SELECT amg02,' ',amg03,amgacti ",
               "  FROM amg_file ",
               " WHERE ", p_wc CLIPPED,                     #單身
               "   AND amg01 = '",g_amg01,"'",
               " ORDER BY amg02"

   PREPARE i200_pb FROM g_sql
   DECLARE amg_curs CURSOR FOR i200_pb

   CALL g_amg.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH amg_curs INTO g_amg[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF g_amg01 MATCHES "[DEF]" THEN
         SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_amg[g_cnt].amg02 and azf02=g_amg01
         LET g_amg[g_cnt].azf03 = l_azf03
      ELSE
         IF g_amg01 = 'M' THEN
            SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = g_amg[g_cnt].amg02
            LET g_amg[g_cnt].azf03 = l_imz02
         ELSE
            SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_amg[g_cnt].amg02
            LET g_amg[g_cnt].azf03 = l_oba02
         END IF
      END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      
   END FOREACH
 
   CALL g_amg.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn1  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i200_bp()
 
   IF g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_amg TO s_amg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      ON ACTION insert 
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
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
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL i200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous                         # P.上筆
         CALL i200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION jump                             # 指定筆
         CALL i200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION next                             # N.下筆
         CALL i200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION last                             # 最終筆
         CALL i200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                   

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
   
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-AB0080
