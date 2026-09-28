# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri033_1.4gl
# Descriptions...: 班段加班信息维护作业
# Date & Author..: 13/05/20 by lijun

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_hrbob09           LIKE hrbob_file.hrbob09,  
  g_hrbob09_t         LIKE hrbob_file.hrbob09,  
  g_hrbob10           LIKE hrbob_file.hrbob10, 
  g_hrbob10_t         LIKE hrbob_file.hrbob10,
  g_hrbo03            LIKE hrbo_file.hrbo03,
  l_cnt             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
  g_hrbob             DYNAMIC ARRAY OF RECORD   #單身數組
           hrbob01    LIKE hrbob_file.hrbob01,
           hrbob02    LIKE hrbob_file.hrbob02,
           hrbob03    LIKE hrbob_file.hrbob03,
           hrbob04    LIKE hrbob_file.hrbob04,
           hrbob05    LIKE hrbob_file.hrbob05,
           hrbob06    LIKE hrbob_file.hrbob06,
           hrbob07    LIKE hrbob_file.hrbob07,
           hrbob08    LIKE hrbob_file.hrbob08
                    END RECORD,
  g_hrbob_t           RECORD   #單身數組舊值
           hrbob01    LIKE hrbob_file.hrbob01,
           hrbob02    LIKE hrbob_file.hrbob02,
           hrbob03    LIKE hrbob_file.hrbob03,
           hrbob04    LIKE hrbob_file.hrbob04,
           hrbob05    LIKE hrbob_file.hrbob05,
           hrbob06    LIKE hrbob_file.hrbob06,
           hrbob07    LIKE hrbob_file.hrbob07,
           hrbob08    LIKE hrbob_file.hrbob08
                    END RECORD,
  g_wc,g_wc2,g_sql  STRING,
  g_delete          LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
  g_rec_b           LIKE type_file.num5,          #No.FUN-680136 SMALLINT 
  l_ac              LIKE type_file.num5           #No.FUN-680136 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680136 SMALLINT 
DEFINE g_forupd_sql        STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10         #No.FUN-680136  INTEGER
DEFINE g_i                 LIKE type_file.num5          #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE g_msg               LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index        LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_jump              LIKE type_file.num10         #No.FUN-680136 INTEGER                                                  #No.FUN-680136
DEFINE g_no_ask           LIKE type_file.num5          #No.FUN-680136 INTEGER   #No.FUN-6A0067
 
MAIN
    OPTIONS                                #改變一些系統預設值 
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理  
 
    IF (NOT cl_user()) THEN 
       EXIT PROGRAM 
    END IF 
 
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("GHR")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    INITIALIZE g_hrbob TO NULL                                                
    INITIALIZE g_hrbob_t.* TO NULL
    LET g_hrbob09 = NULL
    LET g_hrbob10 = NULL
    
    LET g_hrbob09 = ARG_VAL(1)
    LET g_hrbob10 = ARG_VAL(2)                                                          
 
    OPEN WINDOW i033_1_w WITH FORM "ghr/42f/ghri033_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()

    LET g_delete='N'
    IF NOT cl_null(g_hrbob09) AND NOT cl_null(g_hrbob10) THEN
       CALL i033_1_b_fill('1=1')
       CALL i033_1_show()
    END IF
    CALL i033_1_menu()   
    CLOSE WINDOW i033_1_w     
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION i033_1_cs()
    CLEAR FORM
    CALL g_hrbob.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INITIALIZE g_hrbob09 TO NULL    #No.FUN-750051
    INITIALIZE g_hrbob10 TO NULL
    CONSTRUCT g_wc ON hrbob09,hrbob10,hrbob01,hrbob02,hrbob03,hrbob04,hrbob05,hrbob06,hrbob07,hrbob08
                 FROM hrbob09,hrbob10,s_hrbob[1].hrbob01,s_hrbob[1].hrbob02,s_hrbob[1].hrbob03,
                      s_hrbob[1].hrbob04,s_hrbob[1].hrbob05,s_hrbob[1].hrbob06,s_hrbob[1].hrbob07,s_hrbob[1].hrbob08
              
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(hrbob09)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.form ="q_hrbo02"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbob09
              NEXT FIELD hrbob09        
           WHEN INFIELD(hrbob10)
              CALL cl_init_qry_var()       
              LET g_qryparam.state ="c"
              LET g_qryparam.arg1 = g_hrbob09
              LET g_qryparam.form ="q_hrboa01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrbob10
              NEXT FIELD hrbob10         
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
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED
  
    IF INT_FLAG THEN RETURN END IF
  
    LET g_sql=" SELECT DISTINCT hrbob09,hrbob10 FROM hrbob_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY hrbob09,hrbob10 "
    PREPARE i033_1_prepare FROM g_sql
    DECLARE i033_1_bcs SCROLL CURSOR WITH HOLD FOR i033_1_prepare
    LET g_sql=" SELECT COUNT(UNIQUE hrbob01) ",
              "   FROM hrbob_file WHERE ",g_wc CLIPPED
    PREPARE i033_1_precount FROM g_sql
    DECLARE i033_1_count CURSOR FOR i033_1_precount
  
END FUNCTION
 
FUNCTION i033_1_menu()
    WHILE TRUE
      CALL i033_1_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i033_1_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i033_1_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i033_1_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i033_1_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i033_1_b()
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
               call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_hrbob),'','')
            END IF 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_hrbob09 IS NOT NULL THEN
                 LET g_doc.column1 = "hrbob09"
                 LET g_doc.value1 = g_hrbob09
                 CALL cl_doc()
               END IF
         END IF
      END CASE
    END WHILE
END FUNCTION 
 
FUNCTION i033_1_a() 
    IF s_shut(0) THEN RETURN END IF 
    MESSAGE ""
    CLEAR FORM
    CALL g_hrbob.clear()
    INITIALIZE g_hrbob09 LIKE hrbob_file.hrbob09
    INITIALIZE g_hrbob10 LIKE hrbob_file.hrbob10
    LET g_hrbob09_t = NULL
    LET g_hrbob10_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i033_1_i("a")     #輸入單頭
        IF INT_FLAG THEN     #使用者不玩了 
           LET g_hrbob09 = NULL
           LET g_hrbob10 = NULL
           CLEAR FORM
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i033_1_b()                    
        LET g_hrbob09_t = g_hrbob09
        LET g_hrbob10_t = g_hrbob10         
        EXIT WHILE
    END WHILE        
END FUNCTION
 
FUNCTION i033_1_u()
    IF g_hrbob09 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_hrbob10 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_opmsg('u')
    LET g_hrbob09_t = g_hrbob09
    LET g_hrbob10_t = g_hrbob10
    WHILE TRUE
        CALL i033_1_i("u")                      
        IF INT_FLAG THEN
            LET g_hrbob09=g_hrbob09_t
            DISPLAY g_hrbob09 TO hrbob09
            LET g_hrbob10=g_hrbob10_t
            DISPLAY g_hrbob10 TO hrbob10        
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_hrbob09 != g_hrbob09_t OR g_hrbob10 != g_hrbob10_t THEN #欄位更改         
            UPDATE hrbob_file SET hrbob09  = g_hrbob09,
                                  hrbob10  = g_hrbob10  
                WHERE hrbob09 = g_hrbob09_t AND hrbob10 = g_hrbob10_t    
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hrbob_file",g_hrbob09,"",
                              SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    CALL i033_1_b()
    CALL i033_1_show()
END FUNCTION 
 
FUNCTION i033_1_i(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1,            #No.FUN-680136 VARCHAR(1)
         l_n             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
         l_pma02         LIKE pma_file.pma02
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
 
    INPUT g_hrbob09,g_hrbob10 WITHOUT DEFAULTS FROM hrbob09,hrbob10
 
        BEFORE INPUT
            LET g_before_input_done = FALSE 
            CALL i033_1_set_entry(p_cmd) 
            CALL i033_1_set_no_entry(p_cmd) 
            LET g_before_input_done = TRUE
 
        AFTER FIELD hrbob09
            IF g_hrbob09 IS NULL OR g_hrbob09=' ' THEN
               CALL cl_err("","ghr-317",0)
#              NEXT FIELD hrbob01
            END IF
            IF g_hrbob09 IS NOT NULL AND (p_cmd='a' OR (g_hrbob09!=g_hrbob09_t)) THEN
               #判斷資料重復否
               SELECT COUNT(hrbob09) INTO l_n FROM hrbob_file
                  WHERE hrbob09=g_hrbob09
                  IF l_n >=1 THEN
                     CALL cl_err(g_hrbob09,"atm-310",0)
                     NEXT FIELD hrbob09
                  END IF
               SELECT hrbo03 INTO g_hrbo03 FROM hrbo_file WHERE hrbo02=g_hrbob09
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","hrbo_file",g_hrbob09,"",SQLCA.sqlcode,"","",1)
                  NEXT FIELD hrbob09
               ELSE          
                  DISPLAY g_hrbo03 TO hrbo03
               END IF        
             END IF
        AFTER FIELD hrbob10
            IF g_hrbob10 IS NULL OR g_hrbob10=' ' THEN
               CALL cl_err("","ghr-317",0)
#              NEXT FIELD hrbob01
            END IF
            IF g_hrbob10 IS NOT NULL AND (p_cmd='a' OR (g_hrbob10!=g_hrbob10_t)) THEN
               #判斷資料重復否
               SELECT COUNT(*) INTO l_n FROM hrbob_file
                  WHERE hrbob09=g_hrbob09 AND hrbob10=g_hrbob10
                  IF l_n >=1 THEN
                     CALL cl_err(g_hrbob10,"atm-310",0)
                     NEXT FIELD hrbob10
                  END IF        
             END IF            
 
        ON ACTION CONTROLP                 
            CASE
                WHEN INFIELD(hrbob09)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrbo02"
                   LET g_qryparam.default1 = g_hrbob09
                   CALL cl_create_qry() RETURNING g_hrbob09 
                   DISPLAY g_hrbob09 TO hrbob09
                   NEXT FIELD hrbob09
                WHEN INFIELD(hrbob10)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrboa01"
                   LET g_qryparam.arg1 = g_hrbob09
                   LET g_qryparam.default1 = g_hrbob10
                   CALL cl_create_qry() RETURNING g_hrbob10 
                   DISPLAY g_hrbob10 TO hrbob10
                   NEXT FIELD hrbob10        
            END CASE
   
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
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i033_1_q()
  DEFINE l_hrbob09  LIKE hrbob_file.hrbob09,
         l_cnt    LIKE type_file.num10               #No.FUN-680136 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_hrbob09 TO NULL     #No.FUN-6A0162
    INITIALIZE g_hrbob10 TO NULL
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_hrbob.clear()
 
    CALL i033_1_cs()                 #去得查詢條件 
    IF INT_FLAG THEN               #使用者不玩了  
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i033_1_bcs                  #從DB產生合乎條件的TEMP(0-30秒)  
    IF SQLCA.sqlcode THEN           
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_hrbob09 TO NULL
        INITIALIZE g_hrbob10 TO NULL
    ELSE
        OPEN i033_1_count                                                     
        FETCH i033_1_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i033_1_fetch('F')        #讀取TEMP的第一筆并顯示  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i033_1_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1         #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i033_1_bcs INTO g_hrbob09,g_hrbob10
        WHEN 'P' FETCH PREVIOUS i033_1_bcs INTO g_hrbob09,g_hrbob10
        WHEN 'F' FETCH FIRST    i033_1_bcs INTO g_hrbob09,g_hrbob10
        WHEN 'L' FETCH LAST     i033_1_bcs INTO g_hrbob09,g_hrbob10
        WHEN '/' 
         IF (NOT g_no_ask) THEN   #No.FUN-6A0067
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
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
         END IF
         FETCH ABSOLUTE g_jump i033_1_bcs INTO g_hrbob09,g_hrbob10
         LET g_no_ask = FALSE             #No.FUN-6A0067
    END CASE
 
    IF SQLCA.sqlcode THEN                        
        CALL cl_err(g_hrbob09,SQLCA.sqlcode,0)
        INITIALIZE g_hrbob09 TO NULL  #TQC-6B0105
        INITIALIZE g_hrbob10 TO NULL
        RETURN
    ELSE
        CASE p_flag                                                             
                                                                                
          WHEN 'F' LET g_curs_index = 1                                        
          WHEN 'P' LET g_curs_index = g_curs_index - 1                        
          WHEN 'N' LET g_curs_index = g_curs_index + 1                        
          WHEN 'L' LET g_curs_index = g_row_count                             
          WHEN '/' LET g_curs_index = g_jump                                   
        END CASE                                                                
        CALL cl_navigator_setting( g_curs_index, g_row_count )        
    END IF
    OPEN i033_1_count
    FETCH i033_1_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL i033_1_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i033_1_show()  
 
    DISPLAY g_hrbob09 TO hrbob09  #ATTRIBUTE(YELLOW)    #單頭
    SELECT hrbo03 INTO g_hrbo03 FROM hrbo_file WHERE hrbo02=g_hrbob09
    DISPLAY g_hrbo03 TO hrbo03
    DISPLAY g_hrbob10 TO hrbob10 

    CALL i033_1_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#刪除整筆資料(所有合乎單頭的資料)
FUNCTION i033_1_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_hrbob09 IS NULL OR g_hrbob10 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0162
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下 
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "hrbob09"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_hrbob09       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM hrbob_file WHERE hrbob09 = g_hrbob09 AND hrbob10=g_hrbob10
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","hrbob_file",g_hrbob09,"",SQLCA.sqlcode,"",
                         "BODY DELETE",1)  #No.FUN-660104
        ELSE
            CLEAR FORM
            CALL g_hrbob.clear()
            LET g_delete='Y'
            LET g_hrbob09 = NULL
            LET g_hrbob10 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i033_1_count                                                     
            FETCH i033_1_count INTO g_row_count                 
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN i033_1_bcs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL i033_1_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET g_no_ask = TRUE         #No.FUN-6A0067                   
               CALL i033_1_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION i033_1_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用         #No.FUN-680136 SMALLINT
    l_ac_o          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_rows          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_success       LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680136 VARCHAR(1)
    l_hrbob04         LIKE hrbob_file.hrbob04,   
    l_hrbob03         LIKE hrbob_file.hrbob03,   #序號
    l_hrbob03_t       LIKE hrbob_file.hrbob03,   #序號舊值
    l_hrbob05         LIKE hrbob_file.hrbob05,   #比率
    l_hrbob05_t       LIKE hrbob_file.hrbob05,   #比率舊值
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680136 SMALLINT
    l_count         LIKE type_file.num5
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_hrbob09) OR cl_null(g_hrbob10)THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT hrbob01,hrbob02,hrbob03,hrbob04,hrbob05, ",
                       " hrbob06,hrbob07,hrbob08 ",
                       "   FROM hrbob_file  ",
                       "   WHERE hrbob09=?   ",
                       "    AND hrbob10=? AND hrbob01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i033_1_bcl CURSOR FROM g_forupd_sql 
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_hrbob WITHOUT DEFAULTS FROM s_hrbob.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL i033_1_set_entry_b()
            CALL i033_1_set_no_entry_b()
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_hrbob_t.* = g_hrbob[l_ac].*      #BACKUP
                OPEN i033_1_bcl USING g_hrbob09,g_hrbob10,g_hrbob_t.hrbob01
                IF STATUS THEN
                   CALL cl_err("OPEN i033_1_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i033_1_bcl INTO g_hrbob[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_hrbob_t.hrbob01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      LET g_hrbob_t.*=g_hrbob[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            IF l_n = 1 THEN 
              LET p_cmd='a'
              INITIALIZE g_hrbob[l_ac].* TO NULL      #900423
              LET g_hrbob_t.* = g_hrbob[l_ac].*         #輸入新資料
              LET g_hrbob[l_n].hrbob02='N'
              LET g_hrbob[l_n].hrbob03='N'
              LET g_hrbob[l_n].hrbob04='N'
              LET g_hrbob[l_n].hrbob05='60'
              LET g_hrbob[l_n].hrbob06='30'
              LET g_hrbob[l_n].hrbob07='180'
              CALL cl_show_fld_cont()     #FUN-550037(smin)
              NEXT FIELD hrbob01
            ELSE
              CALL cl_err('每个班段只允许存在一笔加班信息','!',0)
              CANCEL INSERT
            END IF
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT COUNT(*) INTO l_count FROM hrbob_file
            WHERE hrbob=g_hrbob09 AND hrbob10=g_hrbob10
            IF l_count = 0 THEN 
              INSERT INTO hrbob_file(hrbob01,hrbob02,hrbob03,hrbob04,hrbob05,
                                 hrbob06,hrbob07,hrbob08,hrbob09,hrbob10)
                          VALUES(g_hrbob[l_ac].hrbob01,g_hrbob[l_ac].hrbob02,g_hrbob[l_ac].hrbob03,
                                 g_hrbob[l_ac].hrbob04,g_hrbob[l_ac].hrbob05,g_hrbob[l_ac].hrbob06,
                                 g_hrbob[l_ac].hrbob07,g_hrbob[l_ac].hrbob08,g_hrbob09,g_hrbob10)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","hrbob_file",g_hrbob09,g_hrbob[l_ac].hrbob03,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT
              ELSE
               UPDATE hrbob_file SET hrbobmodu = g_hrbobmodu
                WHERE hrbob01=g_hrbob01
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
               LET g_rec_b=g_rec_b+1
              END IF
            ELSE
              CALL cl_err('该班段加班信息已存在','!',0)
              CANCEL INSERT
            END IF
              
 
        BEFORE FIELD hrbob01
            IF g_hrbob[l_ac].hrbob01 IS NULL THEN
               SELECT MAX(hrbob01)+1 INTO g_hrbob[l_ac].hrbob01 
                 FROM hrbob_file WHERE hrbob09=g_hrbob09 AND hrbob10=g_hrbob10
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","hrbob_file",g_hrbob09,"",SQLCA.sqlcode,"","",1)
                  NEXT FIELD hrbob01
               END IF 
               IF g_hrbob[l_ac].hrbob01 IS NULL THEN
                  LET g_hrbob[l_ac].hrbob01=1
               END IF
            END IF 
 
        AFTER FIELD hrbob01
            IF g_hrbob[l_ac].hrbob01 != g_hrbob_t.hrbob01 OR g_hrbob_t.hrbob01 IS NULL THEN
               SELECT COUNT(hrbob01) INTO l_n FROM hrbob_file 
                WHERE hrbob09=g_hrbob09 AND hrbob10=g_hrbob10 AND hrbob01=g_hrbob[l_ac].hrbob01
               IF l_n>=1 THEN
                  CALL cl_err(g_hrbob[l_ac].hrbob01,"asf-406",1)
                  LET g_hrbob[l_ac].hrbob01=g_hrbob_t.hrbob01
                  NEXT FIELD hrbob01
               END IF
            END IF
 
        BEFORE DELETE                            #刪除單身
            IF g_hrbob_t.hrbob01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM hrbob_file
                 WHERE hrbob09 = g_hrbob09
                   AND hrbob10 = g_hrbob10 
                   AND hrbob01 = g_hrbob_t.hrbob01 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","hrbob_file",g_hrbob_t.hrbob01,"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            LET g_rec_b=g_rec_b-1
            END IF
            COMMIT WORK
 
      ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrbob[l_ac].* = g_hrbob_t.*
               CLOSE i033_1_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrbob[l_ac].hrbob01,-263,1)
               LET g_hrbob[l_ac].* = g_hrbob_t.*
            ELSE
               UPDATE hrbob_file SET hrbob09  =g_hrbob09,
                                     hrbob10  =g_hrbob10,
                                     hrbob01=g_hrbob[l_ac].hrbob01,
                                     hrbob02=g_hrbob[l_ac].hrbob02,
                                     hrbob03=g_hrbob[l_ac].hrbob03,
                                     hrbob04=g_hrbob[l_ac].hrbob04,
                                     hrbob05=g_hrbob[l_ac].hrbob05,
                                     hrbob06=g_hrbob[l_ac].hrbob06,
                                     hrbob07=g_hrbob[l_ac].hrbob07,
                                     hrbob08=g_hrbob[l_ac].hrbob08
                WHERE hrbob09 = g_hrbob09
                  AND hrbob10 = g_hrbob10 
                  AND hrbob01 = g_hrbob_t.hrbob01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","hrbob_file",g_hrbob[l_ac].hrbob01,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_hrbob[l_ac].* = g_hrbob_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
      AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_hrbob[l_ac].* = g_hrbob_t.*
               END IF
               CLOSE i033_1_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i033_1_bcl
            COMMIT WORK
#No.TQC-6C0019  --begin
    AFTER INPUT 
#        SELECT SUM(hrbob05) INTO l_hrbob05 FROM hrbob_file WHERE hrbob01=g_hrbob01
#        IF l_hrbob05 <>100 THEN
#           CALL cl_err(' ','agl-107',0)
#           NEXT FIELD hrbob05
#        END IF
#No.TQC-6C0019  --end  
          
 
        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(hrbob04)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_pma"
#                   LET g_qryparam.default1 = g_hrbob[l_ac].hrbob04
#                   CALL cl_create_qry() RETURNING g_hrbob[l_ac].hrbob04
#                   NEXT FIELD hrbob04
#           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
#        ON ACTION CONTROLO                        #沿用所有欄位                                                                     
#           IF INFIELD(hrbob03) AND l_ac > 1 THEN                                                                                      
#               LET g_hrbob[l_ac].* = g_hrbob[l_ac-1].* 
#               LET g_hrbob[l_ac].hrbob03 = g_rec_b+1
#               NEXT FIELD hrbob03                                                                                                     
#           END IF      
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
    CLOSE i033_1_bcl
    COMMIT WORK
    SELECT COUNT(hrbob01) INTO l_n FROM hrbob_file WHERE hrbob01=g_hrbob01
    IF l_n = 0 THEN
       CALL i033_1_delall() 
    END IF
 
END FUNCTION
 
FUNCTION i033_1_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql = "SELECT hrbob01,hrbob02,hrbob03,hrbob04,hrbob05, ",
                " hrbob06,hrbob07,hrbob08 ",
                "  FROM hrbob_file ",
                " WHERE hrbob09 = '",g_hrbob09,"'",
                "   AND hrbob10 = '",g_hrbob10,"'",
    #           "   AND ",p_wc CLIPPED ,    #No.TQC-6C0019
                " ORDER BY hrbob01"
    PREPARE i033_1_prepare2 FROM g_sql      
    DECLARE hrbob_cs CURSOR FOR i033_1_prepare2
    CALL g_hrbob.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH hrbob_cs INTO g_hrbob[g_cnt].*   #單身ARRAY填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
        CALL g_hrbob.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1     
       #LET g_cnt = 0
END FUNCTION
 
FUNCTION i033_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbob TO s_hrbob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i033_1_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL i033_1_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
 
      ON ACTION jump 
         CALL i033_1_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
      ON ACTION next
         CALL i033_1_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              
 
      ON ACTION last 
         CALL i033_1_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY               
 
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
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
      
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i033_1_set_entry(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("hrbob09,hrbob10",TRUE)                               
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i033_1_set_no_entry(p_cmd)                                               
DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                    
           CALL cl_set_comp_entry("hrbob09,hrbob10",FALSE)                          
       END IF                                                                   
   END IF                                                                       
END FUNCTION
 
FUNCTION i033_1_set_entry_b()
#    IF g_hrbob02='1' THEN
#       CALL cl_set_comp_entry("hrbob05",TRUE)
#    END IF
END FUNCTION
 
FUNCTION i033_1_set_no_entry_b()
#    IF g_hrbob02='2' THEN
#       CALL cl_set_comp_entry("hrbob05",FALSE)
#    END IF
END FUNCTION
 
FUNCTION i033_1_delall()                                                                                                              
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料                                                            
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED                       
      #IF cl_delb(0,0) THEN                       
          DELETE FROM hrbob_file WHERE hrbob09 = g_hrbob09 AND hrbob10=g_hrbob10
          CLEAR FORM 
          CALL g_hrbob.clear() 
      #END IF                                                                                                                       
    END IF                                                                                                                          
END FUNCTION       

