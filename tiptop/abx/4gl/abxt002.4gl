# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abxt002.4gl
# Descriptions...: 保稅庫存折合數量維護作業
# Date & Author..: 98/07/20 BY Chiayi
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550017 05/05/11 By day  根據模塊對FUN-530065分單 
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能#
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0046 06/10/19 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/11/07 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-910012 08/01/16 By ve007   舊值保存的BUG
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bwg   RECORD LIKE bwg_file.*,
    g_bwg_t RECORD LIKE bwg_file.*,
    g_bwg01_t LIKE bwg_file.bwg01,
    g_bwg011_t LIKE bwg_file.bwg011,   #FUN-6A0007
    g_wc,g_sql          STRING   #No.FUN-580092 HCN   
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_before_input_done   LIKE type_file.num5      #No.FUN-680062 smallint
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ABX")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
    INITIALIZE g_bwg.* TO NULL 
    INITIALIZE g_bwg_t.* TO NULL       
 
    LET g_forupd_sql = "SELECT * FROM bwg_file WHERE bwg00=? AND bwg01=? AND bwg02=? AND bwg03=? AND bwg011=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t002_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW t002_w WITH FORM "abx/42f/abxt002" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL t002_menu()
 
    CLOSE WINDOW t002_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t002_curs()
    CLEAR FORM
    INITIALIZE g_bwg.* TO NULL      #No.FUN-750051  
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       bwg011,bwg00,bwg04,ima02,ima021,ima1916,bwg05,ima15  #06/08/02 BY TDS.jin
 
              #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     #FUN-530065                                                                 
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(bwg04)                                                   
#FUN-AA0059 --Begin--
          #  CALL cl_init_qry_var()                                              
          #  LET g_qryparam.form = "q_ima"                                       
          #  LET g_qryparam.state = "c"                                          
          #  LET g_qryparam.default1 = g_bwg.bwg04                               
          #  CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            CALL q_sel_ima( TRUE, "q_ima","",g_bwg.bwg04,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
            DISPLAY g_qryparam.multiret TO bwg04                                
            NEXT FIELD bwg04                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
    # 組合出 SQL 指令
    LET g_sql="SELECT bwg_file.bwg00,bwg01,bwg02,bwg03,bwg011 FROM bwg_file,ima_file ", 
        " WHERE ",g_wc CLIPPED,
        " AND   bwg04 = ima01 "
      
    PREPARE t002_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t002_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t002_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM bwg_file,ima_file WHERE ",g_wc CLIPPED,
        " AND   bwg04 = ima01 "
 
    PREPARE t002_precount FROM g_sql
    DECLARE t002_count CURSOR FOR t002_precount
END FUNCTION
 
FUNCTION t002_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t002_q()
            END IF
        ON ACTION next 
            CALL t002_fetch('N') 
        ON ACTION previous 
            CALL t002_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t002_u()
            END IF
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
            CALL t002_fetch('/')
        ON ACTION first
            CALL t002_fetch('F')
        ON ACTION last
            CALL t002_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0046-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_bwg.bwg00 IS NOT NULL THEN            
                  LET g_doc.column1 = "bwg00"               
                  LET g_doc.column2 = "bwg01" 
                  LET g_doc.column3 = "bwg02"
                  LET g_doc.column4 = "bwg03"  
                  LET g_doc.column5 = "bwg011"             
                  LET g_doc.value1 = g_bwg.bwg00            
                  LET g_doc.value2 = g_bwg.bwg01
                  LET g_doc.value3 = g_bwg.bwg02
                  LET g_doc.value4 = g_bwg.bwg03
                  LET g_doc.value5 = g_bwg.bwg011            
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0046-------add--------end---- 
           LET g_action_choice = "exit"
           CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t002_curs
END FUNCTION
 
 
FUNCTION t002_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680062 smallint
 
    INPUT BY NAME
           #g_bwg.bwg00,g_bwg.bwg04,g_bwg.bwg05
            g_bwg.bwg011,g_bwg.bwg00,g_bwg.bwg04,g_bwg.bwg05 #FUN-6A0007
        WITHOUT DEFAULTS 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t002_set_entry(p_cmd)
          CALL t002_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(bwg01) THEN
        #        LET g_bwg.* = g_bwg_t.*
        #        DISPLAY BY NAME g_bwg.* 
        #        NEXT FIELD bwg01
        #    END IF
        #MOD-650015 --end
 
 
        #FUN-530065                                                                                                                 
        ON ACTION CONTROLP                                                                                                          
           CASE                                                                                                                     
              WHEN INFIELD(bwg04)                                                                                                   
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()                                                                                              
              #  LET g_qryparam.form = "q_ima"                                                                                       
              #  LET g_qryparam.default1 = g_bwg.bwg04                                                                               
              #  CALL cl_create_qry() RETURNING g_bwg.bwg04                                                                          
                CALL q_sel_ima(FALSE, "q_ima", "", g_bwg.bwg04, "", "", "", "" ,"",'' )  RETURNING g_bwg.bwg04
#FUN-AA0059 --End--
                DISPLAY BY NAME g_bwg.bwg04                                                                                        
                NEXT FIELD bwg04                                                                                                    
             OTHERWISE                                                                                                              
                EXIT CASE                                                                                                           
          END CASE                                                                                                                  
        #--             
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
FUNCTION t002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t002_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t002_count
    FETCH t002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t002_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bwg.bwg01,SQLCA.sqlcode,0)
       INITIALIZE g_bwg.* TO NULL  
    ELSE
        CALL t002_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t002_fetch(p_flbwg)
    DEFINE
        p_flbwg         LIKE type_file.chr1,         #No.FUN-680062    VARCHAR(1)   
        l_abso          LIKE type_file.num10         #No.FUN-680062    integer
 
    CASE p_flbwg
        WHEN 'N' FETCH NEXT     t002_curs INTO g_bwg.bwg00,g_bwg.bwg01,g_bwg.bwg02,g_bwg.bwg03,g_bwg.bwg011
        WHEN 'P' FETCH PREVIOUS t002_curs INTO g_bwg.bwg00,g_bwg.bwg01,g_bwg.bwg02,g_bwg.bwg03,g_bwg.bwg011
        WHEN 'F' FETCH FIRST    t002_curs INTO g_bwg.bwg00,g_bwg.bwg01,g_bwg.bwg02,g_bwg.bwg03,g_bwg.bwg011
        WHEN 'L' FETCH LAST     t002_curs INTO g_bwg.bwg00,g_bwg.bwg01,g_bwg.bwg02,g_bwg.bwg03,g_bwg.bwg011
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
           #FETCH ABSOLUTE l_abso t002_curs INTO g_bwg.bwg00,g_bwg.bwg01,g_bwg.bwg02,g_bwg.bwg03,g_bwg.bwg011,g_bwg.bwg01
            FETCH ABSOLUTE l_abso t002_curs INTO g_bwg.bwg00,g_bwg.bwg01,g_bwg.bwg02,g_bwg.bwg03,g_bwg.bwg011   #FUN-6A0007
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwg.bwg01,SQLCA.sqlcode,0)
        INITIALIZE g_bwg.* TO NULL  #TQC-6B0105 
        RETURN
    ELSE
       CASE p_flbwg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bwg.* FROM bwg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE bwg00=g_bwg.bwg00 AND bwg01=g_bwg.bwg01 AND bwg02=g_bwg.bwg02 AND bwg03=g_bwg.bwg03 AND bwg011=g_bwg.bwg011
     #    AND bwg01=g_bwg.bwg01          #FUN-6A0007
     #    AND bwg011=g_bwg.bwg011  #FUN-6A0007
 
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bwg.bwg01,SQLCA.sqlcode,0)    #No.FUN-660052
       CALL cl_err3("sel","bwg_file",g_bwg.bwg01,"",SQLCA.sqlcode,"","",1)
    ELSE
        CALL t002_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t002_show()
    DEFINE l_ima02 LIKE ima_file.ima02 
    DEFINE l_ima15 LIKE ima_file.ima14 
    #FUN-6A0007-- start
    DEFINE l_ima021    LIKE ima_file.ima021,
           l_ima1916 LIKE ima_file.ima1916,
           l_bxe02 LIKE bxe_file.bxe02,
           l_bxe03 LIKE bxe_file.bxe03
    #FUN-6A0007-- end
  
    LET g_bwg_t.* = g_bwg.*
    DISPLAY BY NAME
           #g_bwg.bwg00,g_bwg.bwg04,g_bwg.bwg05
            g_bwg.bwg011,g_bwg.bwg00,g_bwg.bwg04,g_bwg.bwg05 #FUN-6A0007
          
   #SELECT ima02,ima15 INTO l_ima02,l_ima15 
    SELECT ima02,ima021,ima1916,ima15 INTO l_ima02,l_ima021,l_ima1916,l_ima15
    FROM ima_file WHERE ima01 = g_bwg.bwg04  #FUN-6A0007
   #FUN-6A0007 --start
    SELECT bxe02,bxe03 INTO l_bxe02,l_bxe03
      FROM bxe_file WHERE bxe01 = l_ima1916
   #FUN-6A0007 --end
 
    DISPLAY l_ima02 TO ima02 
    DISPLAY l_ima15 TO ima15 
    #FUN-6A0007--start
    DISPLAY l_ima021 TO ima021
    DISPLAY l_ima1916 TO ima1916
    DISPLAY l_bxe02 TO bxe02
    DISPLAY l_bxe03 TO bxe03
    #FUN-6A0007--end
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t002_u()
    IF g_bwg.bwg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bwg01_t = g_bwg.bwg01
    LET g_bwg011_t = g_bwg.bwg011  #FUN-6A0007
    BEGIN WORK
 
    OPEN t002_curl USING g_bwg.bwg00,g_bwg.bwg01,g_bwg.bwg02,g_bwg.bwg03,g_bwg.bwg011
    IF STATUS THEN
       CALL cl_err("OPEN t002_curl:", STATUS, 1)
       CLOSE t002_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t002_curl INTO g_bwg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwg.bwg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t002_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t002_i("u")                      # 欄位更改
        IF INT_FLAG THEN                         # 若按了DEL鍵
           #INITIALIZE g_bwg.* TO NULL          #NO.TQC-910012 --MARK--
            LET g_bwg.* = g_bwg_t.*      #No.TQC-910012 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
     UPDATE bwg_file SET bwg_file.* = g_bwg.*    # 更新DB
      WHERE bwg00=g_bwg_t.bwg00 AND bwg01=g_bwg_t.bwg01 AND bwg02=g_bwg_t.bwg02 AND bwg03=g_bwg_t.bwg03 AND bwg011=g_bwg_t.bwg011
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bwg.bwg01,SQLCA.sqlcode,0)  #No.FUN-660052
            CALL cl_err3("upd","bwg_file",g_bwg01_t,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t002_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION t002_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1           #No.FUN-680062 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
        #CALL cl_set_comp_entry("bwg00",TRUE) #FUN-6A0007 mark
         CALL cl_set_comp_entry("bwg00,bwg011",TRUE) #FUN-6A0007
     END IF
 
END FUNCTION
 
FUNCTION t002_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1           #No.FUN-680062 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
      #CALL cl_set_comp_entry("bwg00",FALSE) #FUN-6A0007 mark
       CALL cl_set_comp_entry("bwg00,bwg011",FALSE) #FUN-6A0007
    END IF
END FUNCTION
