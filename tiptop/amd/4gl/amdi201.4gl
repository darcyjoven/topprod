# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: amdi201.4gl
# Descriptions...: 店別代碼維護作業 
# Date & Author..: 10/11/19 By sabrina
# Modify.........: No:FUN-AB0080 10/11/19 By sabrina create program
# Modify.........: No:FUN-AC0008 10/12/03 By sabrina 不應串amh_file。會抓不到資料 
# Modify.........: No:TQC-AC0086 10/12/08 By sabrina 單身更改有錯 
# Modify.........: No:FUN-AC0034 10/12/14 By sabrina 單頭備註無法更改 
# Modify.........: No:MOD-AC0422 10/12/31 By Dido 更新成功應增加 COMMIT WORK 
# Modify.........: No:MOD-AC0426 11/01/03 By sabrina 查詢時單身未過濾總店號，會取出同類型的資料 
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_argv1         LIKE amh_file.amh01,
    g_argv2         LIKE amh_file.amh02,
    g_amh01         LIKE amh_file.amh01,
    g_amh01_t       LIKE amh_file.amh01,
    g_amh02         LIKE amh_file.amh02,
    g_amh02_t       LIKE amh_file.amh02,
    g_amh03         LIKE amh_file.amh03,
    g_amh03_t       LIKE amh_file.amh03,
    g_amh_lock      RECORD LIKE amh_file.*,
    g_amh           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        amh04       LIKE amh_file.amh04,   
        occ02       LIKE occ_file.occ02,
        amh05       LIKE amh_file.amh05,  
        azf03       LIKE azf_file.azf03,   
        amh06       LIKE amh_file.amh06,   
        amh07       LIKE amh_file.amh07,   
        amhacti     LIKE amh_file.amhacti  
                    END RECORD,
    g_amh_t         RECORD                 #程式變數 (舊值)
        amh04       LIKE amh_file.amh04,   
        occ02       LIKE occ_file.occ02,
        amh05       LIKE amh_file.amh05,   
        azf03       LIKE azf_file.azf03,   
        amh06       LIKE amh_file.amh06,   
        amh07       LIKE amh_file.amh07,   
        amhacti     LIKE amh_file.amhacti  
                    END RECORD,
     g_wc,g_sql     string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_no_ask              LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1   = ARG_VAL(1) 
   LET g_amh01   = g_argv1
   LET g_amh01_t = g_amh01
   LET g_amh02   = g_argv2
   LET g_amh02_t = g_amh02
   LET g_amh03_t = g_amh03
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW i201_w WITH FORM "amd/42f/amdi201"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   DISPLAY g_amh01 TO amh01
   DISPLAY g_amh02 TO amh02
   DISPLAY g_amh03 TO amh03

   LET g_sql = "SELECT * FROM amh_file ",
               " WHERE amh01 = ? AND amh02 = ? ",
               "FOR UPDATE "
   LET g_sql = cl_forupd_sql(g_sql)
   DECLARE i201_lock_u CURSOR FROM g_sql
 
   CALL i201_menu()
 
   CLOSE WINDOW i201_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i201_curs()
 
    CLEAR FORM
    CALL g_amh.clear()
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "amh01 = '",g_argv1 CLIPPED,"'"
       IF NOT cl_null(g_argv2) THEN
          LET g_wc = g_wc, "AND amh02 = '",g_argv2 CLIPPED,"'"
       END IF
    ELSE
       CALL cl_set_head_visible("","YES")
       INITIALIZE g_amh01 TO NULL
       CONSTRUCT g_wc ON amh01,amh02,amh04,amh05,amh06,amh07,amhacti
            FROM amh01,amh02,s_amh[1].amh04,s_amh[1].amh05,s_amh[1].amh06,s_amh[1].amh07,s_amh[1].amhacti 
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
    
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
    
          ON ACTION CONTROLP
             CASE
                WHEN INFIELD(amh01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO amh01
                   NEXT FIELD amh01
                WHEN INFIELD(amh04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ01_2"
                   LET g_qryparam.state = "c"
                   CALL GET_FLDBUF(amh01) RETURNING g_amh01
                   LET g_qryparam.arg1 = g_amh01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO amh04
                   NEXT FIELD amh04
                WHEN INFIELD(amh05)      
                   CALL cl_init_qry_var()
                   CALL GET_FLDBUF(amh02) RETURNING g_amh02
                   IF g_amh02 MATCHES "[DEF]" THEN
                      LET g_qryparam.form ="q_azf" 
                      LET g_qryparam.arg1 = g_amh02 
                   ELSE
                      IF g_amh02 = 'M' THEN
                         LET g_qryparam.form ="q_imz"
                      ELSE
                         LET g_qryparam.form ="q_oba_01"
                      END IF
                   END IF    
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO amh05
                   NEXT FIELD amh05
                OTHERWISE
             END CASE
 
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
 
       IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
       LET g_wc =g_wc CLIPPED
    END IF 
    LET g_sql = "SELECT UNIQUE amh01,amh02,amh03 FROM amh_file ",
                " WHERE ",g_wc CLIPPED,
                "ORDER BY amh01,amh02,amh03 "
    PREPARE i201_pre FROM g_sql
    DECLARE i201_curs SCROLL CURSOR WITH HOLD FOR i201_pre

END FUNCTION

FUNCTION i201_count()

   DEFINE li_cnt   LIKE type_file.num10   
   DEFINE li_rec_b LIKE type_file.num10  
 
   LET g_sql= "SELECT UNIQUE amh01,amh02,amh03 FROM amh_file ", 
              " WHERE ", g_wc CLIPPED,
              " GROUP BY amh01,amh02,amh03 ORDER BY amh01,amh02 "      
 
   PREPARE i201_precount FROM g_sql
   DECLARE i201_count CURSOR FOR i201_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i201_count INTO g_amh[li_cnt].*  
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

FUNCTION i201_menu()
 
   WHILE TRUE
      CALL i201_bp()
      CASE g_action_choice
         WHEN "insert"                       
            IF cl_chk_act_auth() THEN
               CALL i201_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i201_q()
            END IF
         WHEN "modify"                          
            IF cl_chk_act_auth() THEN
               CALL i201_u()
            END IF
         WHEN "delete"                         
            IF cl_chk_act_auth() THEN
               CALL i201_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i201_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_amh),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i201_q()
 
 
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  
   CALL g_amh.clear()
   DISPLAY '' TO FORMONLY.cn2
   CALL i201_curs()                         #取得查詢條件

   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF

   OPEN i201_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_amh01 TO NULL
      INITIALIZE g_amh02 TO NULL
      INITIALIZE g_amh03 TO NULL
   ELSE
      CALL i201_count()
      DISPLAY g_row_count TO FORMONLY.cn2
      CALL i201_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF

END FUNCTION
 
FUNCTION i201_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式     #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10         #絕對的筆數   #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i201_curs INTO g_amh01,g_amh02,g_amh03 
      WHEN 'P' FETCH PREVIOUS i201_curs INTO g_amh01,g_amh02,g_amh03 
      WHEN 'F' FETCH FIRST    i201_curs INTO g_amh01,g_amh02,g_amh03 
      WHEN 'L' FETCH LAST     i201_curs INTO g_amh01,g_amh02,g_amh03 
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
         FETCH ABSOLUTE g_jump i201_curs INTO g_amh01
         LET g_no_ask = FALSE  
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_amh01,SQLCA.sqlcode,0)
      INITIALIZE g_amh01 TO NULL  
      INITIALIZE g_amh02 TO NULL  
      INITIALIZE g_amh03 TO NULL  
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL i201_show()
   END IF

END FUNCTION

FUNCTION i201_show()

  DISPLAY g_amh01 TO amh01
  DISPLAY g_amh02 TO amh02
  DISPLAY g_amh03 TO amh03
  CALL i201_b_fill(g_wc)                    
  CALL cl_show_fld_cont()                  

END FUNCTION

FUNCTION i201_b()
   DEFINE l_ac_t          LIKE type_file.num5,    
          l_n             LIKE type_file.num5,    
          l_lock_sw       LIKE type_file.chr1,    
          p_cmd           LIKE type_file.chr1,    
          l_allow_insert  LIKE type_file.num5,    
          l_allow_delete  LIKE type_file.num5,    
          l_azf03         LIKE azf_file.azf03,
          l_occ02         LIKE occ_file.occ02,
          l_imz02         LIKE imz_file.imz02,
          l_oba02         LIKE oba_file.oba02 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_amh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   LET g_forupd_sql = " SELECT amh04,' ',amh05,' ',amh06,amh07,amhacti ",
                      " FROM amh_file ",   
                      "  WHERE amh01 = ? AND amh02=? ",
                      "    AND amh04 = ? AND amh05 = ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_amh WITHOUT DEFAULTS FROM s_amh.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE

 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_amh_t.* = g_amh[l_ac].*  #BACKUP
            OPEN i201_bcl USING g_amh01,g_amh02,g_amh_t.amh04,g_amh_t.amh05
            IF STATUS THEN
               CALL cl_err("OPEN i201_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i201_bcl INTO g_amh[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i201_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  IF g_amh02 MATCHES "[DEF]" THEN
                     SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_amh[l_ac].amh05 and azf02=g_amh02
                     LET g_amh[l_ac].azf03 = l_azf03
                  ELSE
                     IF g_amh02 = 'M' THEN
                        SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = g_amh[l_ac].amh05
                        LET g_amh[l_ac].azf03 = l_imz02
                     ELSE
                        SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_amh[l_ac].amh05
                        LET g_amh[l_ac].azf03 = l_oba02
                     END IF
                  END IF
                  SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=g_amh[l_ac].amh04
                  LET g_amh[l_ac].occ02 = l_occ02
                  DISPLAY BY NAME g_amh[l_ac].azf03
                  DISPLAY BY NAME g_amh[l_ac].occ02
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_amh[l_ac].* TO NULL      
         LET g_amh[l_ac].amhacti = 'Y'       
         LET g_amh_t.* = g_amh[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     
         NEXT FIELD amh04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO amh_file(amh01,amh02,amh03,amh04,amh05,amh06,amh07,amhacti)
                       VALUES(g_amh01,g_amh02,g_amh03,g_amh[l_ac].amh04,g_amh[l_ac].amh05,
                              g_amh[l_ac].amh06,g_amh[l_ac].amh07,g_amh[l_ac].amhacti)      
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","amh_file",g_amh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn1  
         END IF
 
      AFTER FIELD amh04                        
         IF NOT cl_null(g_amh[l_ac].amh04) THEN
            LET l_n = 0
           #SELECT COUNT(*) INTO l_n FROM occ_file,amh_file  #FUN-AC0008 modify mark
            SELECT COUNT(*) INTO l_n FROM occ_file           #FUN-AC0008 modify add
             WHERE occ74 = g_amh01
               AND occ01 = g_amh[l_ac].amh04   
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err('','mfg9329',0)
               LET g_amh[l_ac].amh04 = g_amh_t.amh04
               NEXT FIELD amh04
            END IF

            SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=g_amh[l_ac].amh04
            LET g_amh[l_ac].occ02 = l_occ02
            DISPLAY BY NAME g_amh[l_ac].occ02
         END IF

      AFTER FIELD amh05                        
         IF NOT cl_null(g_amh[l_ac].amh05) THEN
            IF NOT cl_null(g_amh[l_ac].amh04) AND
               (g_amh[l_ac].amh04 != g_amh_t.amh04) OR 
                g_amh_t.amh04 IS NULL THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM amh_file
                WHERE amh01=g_amh01 AND amh02=g_amh02
                  AND amh04=g_amh[l_ac].amh04
                  AND amh05=g_amh[l_ac].amh05
               IF l_n > 0 THEN
                  CALL cl_err(g_amh[l_ac].amh04,'-239',0)
                  NEXT FIELD amh04
               END IF
            END IF
            IF g_amh02 MATCHES "[DEF]" THEN
               SELECT COUNT(*) INTO l_n FROM azf_file
                WHERE azf01 = g_amh[l_ac].amh05 AND azf02 = g_amh02
                  AND azfacti = 'Y'
            ELSE
               IF g_amh02 = 'M' THEN
                  SELECT COUNT(*) INTO l_n FROM imz_file
                    WHERE imz01 = g_amh[l_ac].amh05
                      AND imzacti = 'Y'
               ELSE
                  IF g_amh02 = 'P' THEN 
                     SELECT COUNT(*) INTO l_n FROM oba_file
                      WHERE oba14= '0' AND obaacti = 'Y'
                        AND oba01 = g_amh[l_ac].amh05
                  END IF
               END IF
            END IF
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err('','mfg9329',0)
               LET g_amh[l_ac].amh05 = g_amh_t.amh05
               NEXT FIELD amh05
            END IF
            IF g_amh02 MATCHES "[DEF]" THEN
               SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_amh[l_ac].amh05 and azf02=g_amh02
               LET g_amh[l_ac].azf03 = l_azf03
            ELSE
               IF g_amh02 = 'M' THEN
                  SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = g_amh[l_ac].amh05
                  LET g_amh[l_ac].azf03 = l_imz02
               ELSE
                  SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_amh[l_ac].amh05
                  LET g_amh[l_ac].azf03 = l_oba02
               END IF
            END IF
            DISPLAY BY NAME g_amh[l_ac].azf03
         END IF

 
      BEFORE DELETE                            #是否取消單身
         IF g_amh_t.amh04 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM amh_file WHERE amh01 = g_amh01 AND amh02 = g_amh02 AND amh04 = g_amh_t.amh04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","amh_file",g_amh_t.amh04,"",SQLCA.sqlcode,"","",1)  
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
            LET g_amh[l_ac].* = g_amh_t.*
            CLOSE i201_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_amh01,-263,1)
            LET g_amh[l_ac].* = g_amh_t.*
         ELSE
            UPDATE amh_file SET amh04=g_amh[l_ac].amh04,
                                amh05=g_amh[l_ac].amh05,
                                amh06=g_amh[l_ac].amh06,
                                amh07=g_amh[l_ac].amh07,
                                amhacti=g_amh[l_ac].amhacti
             WHERE amh01 = g_amh01
               AND amh02 = g_amh02 
               AND amh04 = g_amh_t.amh04         #TQC-AC0086 add
               AND amh05 = g_amh_t.amh05         #TQC-AC0086 add  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","amh_file",g_amh01,g_amh_t.amh04,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_amh[l_ac].* = g_amh_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac    #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_amh[l_ac].* = g_amh_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_amh.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i201_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac    #FUN-D30032 add
         CLOSE i201_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(amh04)      
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_occ01_2" 
                LET g_qryparam.arg1 = g_amh01
                LET g_qryparam.default1 = g_amh[l_ac].amh04
                CALL cl_create_qry() RETURNING g_amh[l_ac].amh04 
                DISPLAY BY NAME g_amh[l_ac].amh04
                NEXT FIELD amh04
             WHEN INFIELD(amh05)      
                CALL cl_init_qry_var()
                IF g_amh02 MATCHES "[DEF]" THEN
                   LET g_qryparam.form ="q_azf" 
                   LET g_qryparam.arg1 = g_amh02 
                ELSE
                   IF g_amh02 = 'M' THEN
                      LET g_qryparam.form ="q_imz"
                   ELSE
                      LET g_qryparam.form ="q_oba_01"
                   END IF
                END IF    
                LET g_qryparam.default1 = g_amh[l_ac].amh05
                CALL cl_create_qry() RETURNING g_amh[l_ac].amh05 
                DISPLAY BY NAME g_amh[l_ac].amh05
                NEXT FIELD amh05
             OTHERWISE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(amh01) AND l_ac > 1 THEN
            LET g_amh[l_ac].* = g_amh[l_ac-1].*
            NEXT FIELD amh01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
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
 
   CLOSE i201_bcl
 
   COMMIT WORK
 
END FUNCTION

 
FUNCTION i201_b_fill(p_wc)              
   DEFINE p_wc         LIKE type_file.chr1000  
   DEFINE l_azf03      LIKE azf_file.azf03      
   DEFINE l_occ02      LIKE occ_file.occ02      
   DEFINE l_imz02      LIKE imz_file.imz02 
   DEFINE l_oba02      LIKE oba_file.oba02 
 
   LET g_sql = "SELECT amh04,' ',amh05,' ',amh06,amh07,amhacti ",
               "  FROM amh_file ",
               " WHERE ", p_wc CLIPPED,                     #單身
               "   AND amh01 = '",g_amh01,"'",         #MOD-AC0426 add
               "   AND amh02 = '",g_amh02,"'",
               " ORDER BY amh02"
   PREPARE i201_pb FROM g_sql
   DECLARE amh_curs CURSOR FOR i201_pb
 
   CALL g_amh.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH amh_curs INTO g_amh[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=g_amh[g_cnt].amh04
      IF g_amh02 MATCHES "[DEF]" THEN
         SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=g_amh[g_cnt].amh05 and azf02=g_amh02
         LET g_amh[g_cnt].azf03 = l_azf03
      ELSE
         IF g_amh02 = 'M' THEN
            SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = g_amh[g_cnt].amh05
            LET g_amh[g_cnt].azf03 = l_imz02
         ELSE
            SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_amh[g_cnt].amh05
            LET g_amh[g_cnt].azf03 = l_oba02
         END IF
      END IF
      LET g_amh[g_cnt].occ02 = l_occ02
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      
   END FOREACH
 
   CALL g_amh.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn1  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i201_bp()
 
   IF g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_amh TO s_amh.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      ON ACTION insert 
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION delete 
         LET g_action_choice="delete"
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
         CALL i201_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous                         # P.上筆
         CALL i201_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION jump                             # 指定筆
         CALL i201_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                  
 
      ON ACTION next                             # N.下筆
         CALL i201_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 	 ACCEPT DISPLAY                   
 
      ON ACTION last                             # 最終筆
         CALL i201_fetch('L')
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

FUNCTION i201_a()

   MESSAGE " "
   CLEAR FORM
   CALL g_amh.clear()
   CALL cl_opmsg('a')
   INITIALIZE g_amh01 LIKE amh_file.amh01 
   INITIALIZE g_amh02 LIKE amh_file.amh02 
   INITIALIZE g_amh03 LIKE amh_file.amh03 
 
   WHILE TRUE
      CALL i201_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_amh01 = NULL
         LET g_amh02 = NULL
         LET g_amh03 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      CALL i201_b()             # 單身
      LET g_amh01_t=g_amh01
      LET g_amh02_t=g_amh02
      LET g_amh03_t=g_amh03
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i201_u()

   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_amh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_amh01_t = g_amh01
   LET g_amh02_t = g_amh02
   LET g_amh03_t = g_amh03
 
   BEGIN WORK
   OPEN i201_lock_u USING g_amh01,g_amh02
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i201_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i201_lock_u INTO g_amh_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("amh01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i201_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL i201_i("u")
      IF INT_FLAG THEN
         LET g_amh01 = g_amh01_t
         LET g_amh02 = g_amh02_t
         LET g_amh03 = g_amh03_t
         DISPLAY g_amh01,g_amh02,g_amh03 TO amh01,amh02,amh03
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE amh_file SET amh01 = g_amh01, amh02 = g_amh02, amh03 = g_amh03
       WHERE amh01 = g_amh01_t
        #AND amh02 = g-amh02_t    #FUN-AC0034 mark
         AND amh02 = g_amh02_t    #FUN-AC0034 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","amh_file",g_amh01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      COMMIT WORK                 #MOD-AC0422
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i201_i(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1           # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
   DEFINE   l_cnt        LIKE type_file.num5
 
   DISPLAY g_amh01,g_amh02,g_amh03 TO amh01,amh02,amh03
   CALL cl_set_head_visible("","YES") 
   INPUT g_amh01,g_amh02,g_amh03 WITHOUT DEFAULTS FROM amh01,amh02,amh03
 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i201_set_entry(p_cmd)
         CALL i201_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD amh01                         
         IF NOT cl_null(g_amh01) THEN
            IF g_amh01 != g_amh01_t OR cl_null(g_amh01_t) THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM occ_file
                WHERE occ01 = g_amh01 
               IF l_cnt = 0 THEN
                  CALL cl_err(g_amh01,'anm-045',1)
                  NEXT FIELD amh01
               END IF
            END IF
         END IF
 
       AFTER FIELD amh02
         IF NOT cl_null(g_amh01) AND NOT cl_null(g_amh02) THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM amh_file
             WHERE amh01 = g_amh01 AND amh02 = g_amh02
            IF l_cnt > 0 THEN
               CALL cl_err(g_amh02,'-239',1)
               NEXT FIELD amh02
            END IF
         END IF

       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(amh01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ02"
                LET g_qryparam.default1= g_amh01 
                CALL cl_create_qry() RETURNING g_amh01 
                NEXT FIELD amh01
          END CASE

       ON ACTION controlf     #欄位說明 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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

FUNCTION i201_set_entry(p_cmd)
    DEFINE  p_cmd     LIKE type_file.chr1

    IF p_cmd='a' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("amh01,amh02",TRUE)
    END IF
END FUNCTION

FUNCTION i201_set_no_entry(p_cmd)
    DEFINE  p_cmd     LIKE type_file.chr1

    IF p_cmd='u' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("amh01,amh02",FALSE)
    END IF
END FUNCTION

FUNCTION i201_r()
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_amh    RECORD LIKE amh_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_amh01) AND cl_null(g_amh02)THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   
   IF cl_delh(0,0) THEN
      DELETE FROM amh_file
       WHERE amh01 = g_amh01 AND amh02 = g_amh02 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","amh_file",g_amh01,g_amh02,SQLCA.sqlcode,"","BODY DELETE",0)
         ROLLBACK WORK
         RETURN
      ELSE
         CALL i201_count()
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i201_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cn2
         OPEN i201_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i201_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL i201_fetch('/')
         END IF
      END IF
    END IF
    COMMIT WORK   
END FUNCTION
#FUN-AB0080
