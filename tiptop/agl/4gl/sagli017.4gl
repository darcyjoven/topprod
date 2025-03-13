# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: sagli017.4gl 
# Descriptions...: 股東權益科目分類/群組歸屬作業
# Date & Author..: 11/06/28 By lixiang(FUN-B60144)
# Modify         : No.MOD-B90168 11/09/21 By Carrier input科目开窗使用q_aag02 
# Modify.........: No.FUN-BB0065 12/03/05 by belle   agli0171 單獨拆畫面與agli017分開
# Modify.........: No.FUN-C20023 12/03/05 by belle   增加加減項
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE 
    g_aai00         LIKE aai_file.aai00,
    g_aai00_t       LIKE aai_file.aai00,
    g_aai           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aai01       LIKE aai_file.aai01,
        aag02       LIKE aag_file.aag02,
        aai05       LIKE aai_file.aai05,     #FUN-C20023
        aai02       LIKE aai_file.aai02,
        aya02       LIKE aya_file.aya02,
        aai03       LIKE aai_file.aai03,
        axl02       LIKE axl_file.axl02,
        aai04       LIKE aai_file.aai04
                    END RECORD,
    g_aai_t         RECORD                 #程式變數 (舊值)
        aai01       LIKE aai_file.aai01,
        aag02       LIKE aag_file.aag02,
        aai05       LIKE aai_file.aai05,     #FUN-C20023
        aai02       LIKE aai_file.aai02,
        aya02       LIKE aya_file.aya02,
        aai03       LIKE aai_file.aai03,
        axl02       LIKE axl_file.axl02,
        aai04       LIKE aai_file.aai04
                    END RECORD,
    g_wc,g_wc2,g_sql    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_cnt2               LIKE type_file.num10         
DEFINE g_msg                LIKE type_file.chr1000      
DEFINE g_row_count          LIKE type_file.num10         
DEFINE g_curs_index         LIKE type_file.num10         
DEFINE g_jump               LIKE type_file.num10         
DEFINE mi_no_ask            LIKE type_file.num5         
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE g_argv1         LIKE type_file.chr1

#FUNCTION i017(p_argv1)
FUNCTION i0171(p_argv1)     #FUN-BB0065 mod
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
   DEFINE p_argv1       LIKE type_file.chr1

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_argv1 = p_argv1
#--FUN-BB0065 mark start---
#   CASE
#      WHEN g_argv1 = '1'
#         LET g_prog = 'agli017'
#      WHEN g_argv1 = '2'
#---FUN-BB0065 nark end----
         LET g_prog = 'agli0171'
#   END CASE                     #FUN-BB0065 mark

   LET p_row = 4 LET p_col = 20
   #OPEN WINDOW i017_w AT p_row,p_col WITH FORM "agl/42f/agli017"    #FUN-BB0065 mark
   OPEN WINDOW i017_w AT p_row,p_col WITH FORM "agl/42f/agli0171"    #FUN-BB0065 mod
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   CALL cl_set_comp_visible("aai04",FALSE)
   CALL cl_set_comp_entry("aag02,aya02,axl02",FALSE)
   
   #CALL i017_menu()
   CALL i0171_menu()    #FUN-BB0065 mod
   CLOSE WINDOW i017_w                 #結束畫面
END FUNCTION
 
#FUNCTION i017_menu()
FUNCTION i0171_menu()      #FUN-BB0065 mod
   DEFINE l_cmd STRING
   WHILE TRUE
      #CALL i017_bp("G")
      CALL i0171_bp("G")   #FUN-BB0065 mod
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               #CALL i017_a()
               CALL i0171_a()    #FUN-BB0065 mod
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               #CALL i017_q()
               CALL i0171_q()    #FUN-BB0065 mod
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               #CALL i017_r()
               CALL i0171_r()    #FUN-BB0065 mod
            END IF   
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               #CALL i017_b()
               CALL i0171_b()    #FUN-BB0065 mod
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_aai[l_ac].aai01 IS NOT NULL THEN
                  LET g_doc.column1 = "aai00"
                  LET g_doc.value1 = g_aai00
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                       base.TypeInfo.create(g_aai),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

#FUNCTION i017_cs()
FUNCTION i0171_cs() #FUN-BB0065 mod
DEFINE  lc_qbe_sn   LIKE   gbm_file.gbm01    
DEFINE  l_aai04     LIKE   aai_file.aai04
    CLEAR FORM                       
    CALL g_aai.clear()          

    IF g_argv1 = '1' THEN
       LET l_aai04 = 'Y'
    ELSE
       LET l_aai04 = 'N'
    END IF

    CLEAR FORM                                    #清除畫面
    CALL g_aai.clear()          

    LET g_aai00=NULL
    CONSTRUCT g_wc ON aai00,aai01,aai02,aai03
         FROM aai00,s_aai[1].aai01,s_aai[1].aai02,s_aai[1].aai03                   #螢幕上取單頭條件
        
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
               
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(aai00)              
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aai"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aai00
             NEXT FIELD aai00
          WHEN INFIELD(aai01)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form  = "q_aag11"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aai[1].aai01
             NEXT FIELD aai01
          WHEN INFIELD(aai02)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             IF g_argv1 = '1' THEN
                LET g_qryparam.form = "q_aya01"
             ELSE
                LET g_qryparam.form = "q_aya02"
             END IF
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aai[1].aai02
             NEXT FIELD aai02
          WHEN INFIELD(aai03)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form  = "q_axl"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aai[1].aai03
             NEXT FIELD aai03   
        OTHERWISE EXIT CASE
       END CASE
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
       CALL cl_qbe_list() RETURNING lc_qbe_sn
       CALL cl_qbe_display_condition(lc_qbe_sn)

    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc = NULL
       RETURN
    END IF
                     
    LET g_sql = " SELECT  DISTINCT aai00",
                " FROM aai_file",
                " WHERE ", g_wc CLIPPED,
                "   AND aai04='",l_aai04,"' ",
                " ORDER BY 1"
  
    PREPARE i017_prepare FROM g_sql
    DECLARE i017_cs                             #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i017_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT aai00) FROM aai_file WHERE ",g_wc CLIPPED
    
    PREPARE i017_precount FROM g_sql
    DECLARE i017_count CURSOR FOR i017_precount
    
END FUNCTION

#FUNCTION i017_q()
FUNCTION i0171_q()     #FUN-BB0065 mod
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    LET g_aai00=NULL                      
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    #CALL i017_cs()
    CALL i0171_cs()   ##FUN-BB0065 mod
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_aai00=NULL 
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i017_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        LET g_aai00=NULL 
    ELSE
        OPEN i017_count
        FETCH i017_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        #CALL i017_fetch('F')                
        CALL i0171_fetch('F')              #FUN-BB0065 mod   
    END IF
    MESSAGE ""

END FUNCTION

#FUNCTION i017_fetch(p_flag)
FUNCTION i0171_fetch(p_flag)    #FUN-BB0065 mod
DEFINE
    p_flag     LIKE type_file.chr1,            #處理方式        
    l_abso     LIKE type_file.num10            #絕對的筆數      
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     i017_cs INTO g_aai00
       WHEN 'P' FETCH PREVIOUS i017_cs INTO g_aai00
       WHEN 'F' FETCH FIRST    i017_cs INTO g_aai00
       WHEN 'L' FETCH LAST     i017_cs INTO g_aai00
       WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN         
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         
                  CALL cl_about()      
 
               ON ACTION help          
                  CALL cl_show_help()  
 
               ON ACTION controlg      
                  CALL cl_cmdask()     
 
           END PROMPT
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              EXIT CASE
           END IF
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i017_cs INTO g_aai00
         LET mi_no_ask = FALSE          
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aai00,SQLCA.sqlcode,0)
        LET g_aai00=NULL 
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    DISPLAY g_aai00 TO aai00
    #CALL i017_b_fill(g_wc)               #單身 
    CALL i0171_b_fill(g_wc)               #單身   #FUN-BB0065 mod
    CALL cl_show_fld_cont()

END FUNCTION

#FUNCTION i017_a()
FUNCTION i0171_a()    #FUN-BB0065 mod
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    CALL g_aai.clear()
    LET g_aai00_t = g_aai00
    LET g_aai00=NULL

    CALL cl_opmsg('a')
    WHILE TRUE
        #CALL i017_i("a")                #輸入單頭  
        CALL i0171_i("a")                #輸入單頭  #FUN-BB0065 mod
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF

        IF cl_null(g_aai00) THEN
            CONTINUE WHILE
        END IF
        
        LET g_aai00_t = g_aai00
        
        LET g_rec_b=0
        #CALL i017_b()                           #輸入單身 
        CALL i0171_b()                           #輸入單身   #FUN-BB0065 mod
        EXIT WHILE
    END WHILE
END FUNCTION

#FUNCTION i017_i(p_cmd)
FUNCTION i0171_i(p_cmd)  #FUN-BB0065 mod
DEFINE
    l_flag          LIKE type_file.chr1,   
    l_n1            LIKE type_file.num5,   
    p_cmd           LIKE type_file.chr1,   
    l_n             LIKE type_file.num5,    
    l_cnt           LIKE type_file.num5 

    DISPLAY BY NAME g_aai00
    INPUT g_aai00 WITHOUT DEFAULTS FROM aai00
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
          #CALL i017_set_entry(p_cmd)		#FUN-BB0065
          #CALL i017_set_no_entry(p_cmd)	#FUN-BB0065
           CALL i0171_set_entry(p_cmd)      #FUN-BB0065 mod
           CALL i0171_set_no_entry(p_cmd)   #FUN-BB0065 mod
           LET g_before_input_done = TRUE
 
        AFTER FIELD aai00    
            IF NOT cl_null(g_aai00) THEN
               SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01=g_aai00
               IF l_cnt=0 THEN
                  CALL cl_err('',100,0)
                  NEXT FIELD aai00
               END IF
            ELSE 
               CALL cl_err(g_aai00,'-1124',0)
               NEXT FIELD aai00
            END IF
         
        ON ACTION controlp
           CASE
             WHEN INFIELD(aai00) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 =g_aai00
                  CALL cl_create_qry() RETURNING g_aai00
                  DISPLAY BY NAME g_aai00
                  NEXT FIELD aai00 
             OTHERWISE EXIT CASE
           END CASE
  
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about        
           CALL cl_about()     
 
        ON ACTION help         
           CALL cl_show_help() 

    END INPUT
END FUNCTION
 
#FUNCTION i017_b()
FUNCTION i0171_b()  #FUN-BB0065 mod
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_allow_insert  LIKE type_file.chr1,                #可新增否
    l_allow_delete  LIKE type_file.chr1,                #可刪除否
    l_cnt           LIKE type_file.num10,
    l_aai04         LIKE aai_file.aai04

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
   #LET g_forupd_sql = "SELECT aai01,'',aai02,'',aai03,'',aai04",       #FUN-C20023 mark
    LET g_forupd_sql = "SELECT aai01,'',aai05,aai02,'',aai03,'',aai04", #FUN-C20023
                       "  FROM aai_file WHERE aai00=? AND aai01=? AND aai02=? AND aai03=? AND aai04=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i017_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_aai WITHOUT DEFAULTS FROM s_aai.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,
                     DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
       LET p_cmd=''
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'            #DEFAULT
       LET l_n  = ARR_COUNT()
       IF g_rec_b>=l_ac THEN
          BEGIN WORK
          LET p_cmd='u'
          LET g_aai_t.* = g_aai[l_ac].*  #BACKUP
 
          LET g_before_input_done = FALSE                                      
         #CALL i017_set_entry(p_cmd)             #FUN-BB0065 mod               
         #CALL i017_set_no_entry(p_cmd)    		 #FUN-BB0065 mod
          CALL i0171_set_entry(p_cmd)            #FUN-BB0065 mod
          CALL i0171_set_no_entry(p_cmd)         #FUN-BB0065 mod
          LET g_before_input_done = TRUE                                       
 
          OPEN i017_bcl USING g_aai00,g_aai_t.aai01,g_aai_t.aai02,g_aai_t.aai03,g_aai_t.aai04
          IF STATUS THEN
             CALL cl_err("OPEN i017_bcl:", STATUS, 1)
             LET l_lock_sw = "Y"
          ELSE 
             FETCH i017_bcl INTO g_aai[l_ac].* 
             IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aai_t.aai01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_aai[l_ac].aag02 FROM aag_file WHERE aag01=g_aai[l_ac].aai01 
             SELECT aya02 INTO g_aai[l_ac].aya02 FROM aya_file WHERE aya01=g_aai[l_ac].aai02
             SELECT axl02 INTO g_aai[l_ac].axl02 FROM axl_file WHERE axl01=g_aai[l_ac].aai03
          END IF
          CALL cl_show_fld_cont()     
       END IF
 
    BEFORE INSERT
       LET l_n = ARR_COUNT()
       LET p_cmd='a'
       LET g_before_input_done = FALSE                                        
         #CALL i017_set_entry(p_cmd)             #FUN-BB0065 mod               
         #CALL i017_set_no_entry(p_cmd)    		 #FUN-BB0065 mod
          CALL i0171_set_entry(p_cmd)            #FUN-BB0065 mod
          CALL i0171_set_no_entry(p_cmd)         #FUN-BB0065 mod                                      
       LET g_before_input_done = TRUE                                         
       INITIALIZE g_aai[l_ac].* TO NULL
       IF g_argv1 = '1' THEN
          LET g_aai[l_ac].aai04 = 'Y'
       ELSE
          LET g_aai[l_ac].aai04 = 'N'
       END IF
       LET g_aai_t.* = g_aai[l_ac].*         #新輸入資料
       CALL cl_show_fld_cont()     
       NEXT FIELD aai01
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i017_bcl
           CANCEL INSERT
        END IF
  
        BEGIN WORK                   

        IF (NOT cl_null(g_aai[l_ac].aai01)) AND (NOT cl_null(g_aai[l_ac].aai02))
           AND (NOT cl_null(g_aai[l_ac].aai03)) AND (NOT cl_null(g_aai[l_ac].aai04))THEN
           IF (g_aai[l_ac].aai01 != g_aai_t.aai01 OR g_aai_t.aai01 IS NULL) OR
              (g_aai[l_ac].aai02 != g_aai_t.aai02 OR g_aai_t.aai02 IS NULL) OR
              (g_aai[l_ac].aai03 != g_aai_t.aai03 OR g_aai_t.aai03 IS NULL) OR
              (g_aai[l_ac].aai04 != g_aai_t.aai04 OR g_aai_t.aai04 IS NULL) THEN
              SELECT count(*) INTO g_cnt FROM aai_file
               WHERE aai01 = g_aai[l_ac].aai01
                 AND aai02 = g_aai[l_ac].aai02
                 AND aai03 = g_aai[l_ac].aai03
                 AND aai04 = g_aai[l_ac].aai04
                 AND aai00 = g_aai00
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aai[l_ac].aai01 = g_aai_t.aai01
                 NEXT FIELD aai01
              END IF
           END IF
        END IF 
       #INSERT INTO aai_file(aai00,aai01,aai02,aai03,aai04)                                        #FUN-C20023
       #VALUES(g_aai00,g_aai[l_ac].aai01,g_aai[l_ac].aai02,g_aai[l_ac].aai03,g_aai[l_ac].aai04)    #FUN-C20023
        INSERT INTO aai_file(aai00,aai01,aai02,aai03,aai04,aai05)                                  #FUN-C20023
        VALUES(g_aai00,g_aai[l_ac].aai01,g_aai[l_ac].aai02,g_aai[l_ac].aai03,g_aai[l_ac].aai04,g_aai[l_ac].aai05)   #FUN-C20023
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","aai_file",g_aai[l_ac].aai01,"",
                         SQLCA.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b = g_rec_b + 1
           DISPLAY g_rec_b TO FORMONLY.cn2 
           COMMIT WORK
        END IF
 
    AFTER FIELD aai01  
        IF NOT cl_null(g_aai[l_ac].aai01) THEN
           SELECT COUNT(*) INTO l_cnt FROM aag_file WHERE aag01=g_aai[l_ac].aai01
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_aai[l_ac].aai01=NULL
              NEXT FIELD aai01
           END IF
           SELECT aag02 INTO g_aai[l_ac].aag02 FROM aag_file WHERE aag01=g_aai[l_ac].aai01 
        END IF
        IF (NOT cl_null(g_aai[l_ac].aai01)) AND (NOT cl_null(g_aai[l_ac].aai02)) AND (NOT cl_null(g_aai[l_ac].aai03)) THEN
           IF (g_aai[l_ac].aai01 != g_aai_t.aai01 OR g_aai_t.aai01 IS NULL) OR
              (g_aai[l_ac].aai02 != g_aai_t.aai02 OR g_aai_t.aai02 IS NULL) OR
              (g_aai[l_ac].aai03 != g_aai_t.aai03 OR g_aai_t.aai03 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM aai_file
               WHERE aai01 = g_aai[l_ac].aai01 AND aai02=g_aai[l_ac].aai02 
                 AND aai03=g_aai[l_ac].aai03 AND aai04 = g_aai[l_ac].aai04 AND aai00=g_aai00
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aai[l_ac].aai01 = g_aai_t.aai01
                 NEXT FIELD aai01
              END IF
           END IF
        END IF

    AFTER FIELD aai02  
        IF NOT cl_null(g_aai[l_ac].aai02) THEN
           IF g_argv1= '1' THEN
              LET l_aai04='Y'
           ELSE
              LET l_aai04='N'
           END IF
           SELECT COUNT(*) INTO l_cnt FROM aya_file WHERE aya01=g_aai[l_ac].aai02
                                                      AND aya07=l_aai04   
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_aai[l_ac].aai02=NULL
              NEXT FIELD aai02
           END IF
           SELECT aya02 INTO g_aai[l_ac].aya02 FROM aya_file WHERE aya01=g_aai[l_ac].aai02
        END IF
        IF (NOT cl_null(g_aai[l_ac].aai01)) AND (NOT cl_null(g_aai[l_ac].aai02)) AND (NOT cl_null(g_aai[l_ac].aai03)) THEN
           IF (g_aai[l_ac].aai01 != g_aai_t.aai01 OR g_aai_t.aai01 IS NULL) OR
              (g_aai[l_ac].aai02 != g_aai_t.aai02 OR g_aai_t.aai02 IS NULL) OR
              (g_aai[l_ac].aai03 != g_aai_t.aai03 OR g_aai_t.aai03 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM aai_file
               WHERE aai01 = g_aai[l_ac].aai01 AND aai02=g_aai[l_ac].aai02 
                 AND aai03=g_aai[l_ac].aai03 AND aai04 = g_aai[l_ac].aai04 AND aai00=g_aai00
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aai[l_ac].aai02 = g_aai_t.aai02
                 NEXT FIELD aai01
              END IF
           END IF
        END IF

    AFTER FIELD aai03  
        IF NOT cl_null(g_aai[l_ac].aai03) THEN
           SELECT COUNT(*) INTO l_cnt FROM axl_file WHERE axl01=g_aai[l_ac].aai03
           IF l_cnt=0 THEN
              CALL cl_err('',100,0)
              LET g_aai[l_ac].aai03=NULL
              NEXT FIELD aai03
           END IF 
           SELECT axl02 INTO g_aai[l_ac].axl02 FROM axl_file WHERE axl01=g_aai[l_ac].aai03
        END IF
        IF (NOT cl_null(g_aai[l_ac].aai01)) AND (NOT cl_null(g_aai[l_ac].aai02)) AND (NOT cl_null(g_aai[l_ac].aai03)) THEN
           IF (g_aai[l_ac].aai01 != g_aai_t.aai01 OR g_aai_t.aai01 IS NULL) OR
              (g_aai[l_ac].aai02 != g_aai_t.aai02 OR g_aai_t.aai02 IS NULL) OR
              (g_aai[l_ac].aai03 != g_aai_t.aai03 OR g_aai_t.aai03 IS NULL) THEN
              SELECT count(*) INTO l_cnt FROM aai_file
               WHERE aai01 = g_aai[l_ac].aai01 AND aai02=g_aai[l_ac].aai02 
                 AND aai03=g_aai[l_ac].aai03 AND aai04 = g_aai[l_ac].aai04 AND aai00=g_aai00
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_aai[l_ac].aai03 = g_aai_t.aai03
                 NEXT FIELD aai01
              END IF
           END IF
        END IF
 
    BEFORE DELETE                            #是否取消單身
        IF g_rec_b>=l_ac THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL         
            LET g_doc.column1 = "aai01"           
            LET g_doc.value1 = g_aai[l_ac].aai01 
            CALL cl_del_doc()                   
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM aai_file WHERE aai00=g_aai00 AND aai01 = g_aai_t.aai01
                                   AND aai02=g_aai_t.aai02 AND aai03=g_aai_t.aai03
                                   AND aai04=g_aai_t.aai04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aai_file",g_aai_t.aai01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_aai[l_ac].* = g_aai_t.*
           CLOSE i017_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_aai[l_ac].aai01,-263,0)
           LET g_aai[l_ac].* = g_aai_t.*
        ELSE
           UPDATE aai_file 
               SET aai01=g_aai[l_ac].aai01,aai02=g_aai[l_ac].aai02,
                   aai03=g_aai[l_ac].aai03,aai04=g_aai[l_ac].aai04
                  ,aai05=g_aai[l_ac].aai05                          #FUN-C20023
            WHERE aai01 = g_aai_t.aai01
              AND aai00 = g_aai00         #FUN-BB0065 add
              AND aai02 = g_aai_t.aai02   #FUN-BB0065 add
              AND aai03 = g_aai_t.aai03   #FUN-BB0065 add
              AND aai04 = 'N'             #FUN-BB0065 add
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","aai_file",g_aai[l_ac].aai01,"",
                           SQLCA.sqlcode,"","",1)
              LET g_aai[l_ac].* = g_aai_t.*
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()      
        #LET l_ac_t = l_ac  #FUN-D30032 

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_aai[l_ac].* = g_aai_t.*
           #FUN-D30032--add--str--
           ELSE
              CALL g_aai.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30032--add--end--
           END IF
           CLOSE i017_bcl        
           ROLLBACK WORK        
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac  #FUN-D30032 
        CLOSE i017_bcl         
        COMMIT WORK

     ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aai01)
                CALL cl_init_qry_var()
                #No.MOD-B90168  --Begin                                         
                #LET g_qryparam.form = "q_aag11"                                
                LET g_qryparam.form = "q_aag02"                                 
                LET g_qryparam.arg1 = g_aai00                                   
                #No.MOD-B90168  --End  
                LET g_qryparam.default1 = g_aai[l_ac].aai01
                CALL cl_create_qry() RETURNING g_aai[l_ac].aai01
                DISPLAY g_aai[l_ac].aai01 TO aai01
             WHEN INFIELD(aai02)
                CALL cl_init_qry_var()
                IF g_argv1 = '1' THEN
                   LET g_qryparam.form = "q_aya01"
                ELSE 
                   LET g_qryparam.form = "q_aya02"
                END IF
                LET g_qryparam.default1 = g_aai[l_ac].aai02
                CALL cl_create_qry() RETURNING g_aai[l_ac].aai02
                DISPLAY g_aai[l_ac].aai02 TO aai02
             WHEN INFIELD(aai03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_axl"
                LET g_qryparam.default1 = g_aai[l_ac].aai03
                CALL cl_create_qry() RETURNING g_aai[l_ac].aai03,g_aai[l_ac].axl02
                DISPLAY g_aai[l_ac].aai03 TO aai03
             OTHERWISE
                EXIT CASE
          END CASE
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(aai01) AND l_ac > 1 THEN
             LET g_aai[l_ac].* = g_aai[l_ac-1].*
             NEXT FIELD aai01
         END IF
 
     ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
         CALL cl_cmdask()
 
     ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
          RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
     
     END INPUT
 
 
    CLOSE i017_bcl
    COMMIT WORK
END FUNCTION
 
#FUNCTION i017_b_fill(p_wc)              #BODY FILL UP
FUNCTION i0171_b_fill(p_wc)              #BODY FILL UP   #FUN-BB0065 mod
DEFINE
    p_wc             STRING       
DEFINE
    l_aai04     LIKE aai_file.aai04

    IF g_argv1 = '1' THEN
       LET l_aai04 = 'Y'
    ELSE
       LET l_aai04 = 'N'
    END IF 

    LET g_sql =
    #"SELECT aai01,'',aai02,'',aai03,'',aai04",        #FUN-C20023 mark
     "SELECT aai01,'',aai05,aai02,'',aai03,'',aai04",  #FUN-C20023
     " FROM aai_file",
     " WHERE ", p_wc CLIPPED, 
     " AND aai00 = '",g_aai00,"'",
     " AND aai04 = '",l_aai04,"'",
     " ORDER BY aai01"
   
    PREPARE i017_pb FROM g_sql
    DECLARE aai_curs CURSOR FOR i017_pb
 
    CALL g_aai.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    MESSAGE "Searching!" 
    FOREACH aai_curs INTO g_aai[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        SELECT aag02 INTO g_aai[g_cnt].aag02 FROM aag_file WHERE aag01=g_aai[g_cnt].aai01 
        SELECT aya02 INTO g_aai[g_cnt].aya02 FROM aya_file WHERE aya01=g_aai[g_cnt].aai02
        SELECT axl02 INTO g_aai[g_cnt].axl02 FROM axl_file WHERE axl01=g_aai[g_cnt].aai03
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aai.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
#FUNCTION i017_bp(p_ud)
FUNCTION i0171_bp(p_ud)    #FUN-BB0065
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aai TO s_aai.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()           

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION delete
          LET g_action_choice="delete"
          EXIT DISPLAY
      ON ACTION first
         #CALL i017_fetch('F')
         CALL i0171_fetch('F')    #FUN-BB0065 mod
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY        

      ON ACTION previous
         #CALL i017_fetch('P')
         CALL i0171_fetch('P')    #FUN-BB0065 mod
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY          

      ON ACTION jump
         #CALL i017_fetch('/')
         CALL i0171_fetch('/')    #FUN-BB0065 mod
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY          

      ON ACTION next
         #CALL i017_fetch('N')
         CALL i0171_fetch('N')      #FUN-BB0065 mod
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
        ACCEPT DISPLAY           

       ON ACTION last
         #CALL i017_fetch('L')
         CALL i0171_fetch('L')       #FUN-BB0065 mod
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY 

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

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
             LET INT_FLAG=FALSE                 #MOD-570244     mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

#@    ON ACTION 相關文件
       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUNCTION i017_r()
FUNCTION i0171_r()      #FUN-BB0065 mod
DEFINE l_aai04    LIKE aai_file.aai04
    
    IF s_shut(0) THEN RETURN END IF

    IF g_argv1='1' THEN
       LET l_aai04 = 'Y'
    ELSE
       LET l_aai04 = 'N'
    END IF
    IF cl_null(g_aai00) THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i017_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CLOSE i017_cs ROLLBACK WORK RETURN 
    END IF
    
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL           
        LET g_doc.column1 = "aai00"          
        LET g_doc.value1 = g_aai00       
        CALL cl_del_doc()                                            
       MESSAGE "Delete aai!"
       DELETE FROM aai_file
        WHERE aai00 = g_aai00  AND aai04 = l_aai04
          
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","aai_file",g_aai00,l_aai04,STATUS,"","No aai deleted",1)  
          CLOSE i017_cs ROLLBACK WORK RETURN
       END IF
       
       CLEAR FORM
       CALL g_aai.clear()
       INITIALIZE g_aai00 TO NULL
       MESSAGE ""
         #CKP3
         OPEN i017_count
         FETCH i017_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i017_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            #CALL i017_fetch('L')
            CALL i0171_fetch('L')    #FUN-BB0065 mod
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE         #No.FUN-6A0067
            #CALL i017_fetch('/')
            CALL i0171_fetch('/')        #FUN-BB0065 mod
         END IF
    END IF
    CLOSE i017_cs
    COMMIT WORK
END FUNCTION


#FUNCTION i017_out()
FUNCTION i0171_out()    #FUN-BB0065 mod
DEFINE l_cmd  LIKE type_file.chr1000

   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF

   IF g_argv1 = '1' THEN
      LET g_wc = g_wc," AND aai04 = 'Y'"
   ELSE
      LET g_wc = g_wc," AND aai04 = 'N'"
   END IF

#--FUN-BB0065 mark start--
#   IF g_argv1 = '1' THEN
#      LET l_cmd = 'p_query "agli017" "',g_wc CLIPPED,'"'
#   ELSE
#---FUN-BB0065 mark end---
      LET l_cmd = 'p_query "agli0171" "',g_wc CLIPPED,'"'
#   END IF                          #FUN-BB0065 mark 
   CALL cl_cmdrun(l_cmd)
   RETURN

END FUNCTION

#FUNCTION i017_set_entry(p_cmd)
FUNCTION i0171_set_entry(p_cmd)    #FUN-BB0065 mod
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("aai00",TRUE)
   END IF

END FUNCTION

#FUNCTION i017_set_no_entry(p_cmd)
FUNCTION i0171_set_no_entry(p_cmd)    #FUN-BB0065 mod
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("aai00",FALSE)
   END IF

END FUNCTION
