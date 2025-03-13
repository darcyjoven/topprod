# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abxt001.4gl
# Descriptions...: 保稅庫存折合數量維護作業
# Date & Author..: 98/07/20 BY Chiayi
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550017 05/05/11 By day  根據模塊對FUN-530065分單 
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能#
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0046 06/10/19 By jamie 1.FUNCTION t001()_q 一開始應清空g_bwe.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/11/06 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-9C0055 11/05/04 By Suncx 帶出顯示bwe031(單位用量)
# Modify.........: No:CHI-BB0016 11/12/08 By ck2yuan 畫面新增兩個欄位值生效日期(bwg02)與組成用量(bwg041) 一併帶出
# Modify.........: No:MOD-BC0166 12/03/02 By ck2yuan 控卡bew04只能輸入3位小數
# Modify.........: No:MOD-C50034 12/05/08 By ck2yuan 指定到某一筆時應指定到所有的key值欄位,故加上bwe03欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bwe   RECORD LIKE bwe_file.*,
    g_bwe_t RECORD LIKE bwe_file.*,
    g_bwe01_t LIKE bwe_file.bwe01,
    g_bwe011_t LIKE bwe_file.bwe011,   #FUN-6A0007
    g_bwg      RECORD LIKE bwg_file.*,  #CHI-BB0016 add
    g_bwg_t    RECORD LIKE bwg_file.*,  #CHI-BB0016 add
    g_wc,g_sql          STRING   #No.FUN-580092 HCN   
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680062 integer
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680062 smallint
 
MAIN
    DEFINE
        p_row,p_col   LIKE type_file.num5           #No.FUN-680062 smallint
#       l_time        LIKE type_file.chr8           #No.FUN-6A0062
 
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
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
    INITIALIZE g_bwe.* TO NULL
    INITIALIZE g_bwe_t.* TO NULL

    INITIALIZE g_bwg.*   TO NULL     #CHI-BB0016 add
    INITIALIZE g_bwg_t.* TO NULL     #CHI-BB0016 add
    
   #LET g_forupd_sql = "SELECT * FROM bwe_file WHERE bwe00 = ? AND bwe01 = ? AND bwe02 = ? AND bwe011 = ? FOR UPDATE"               #MOD-C50034 mark 
    LET g_forupd_sql = "SELECT * FROM bwe_file WHERE bwe00 = ? AND bwe01 = ? AND bwe02 = ? AND bwe011 = ? AND bwe03 = ? FOR UPDATE" #MOD-C50034 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_bwe_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 5
    OPEN WINDOW p_bwe_w AT p_row,p_col WITH FORM "abx/42f/abxt001" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL p_bwe_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW p_bwe_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION p_bwe_curs()
    CLEAR FORM
    INITIALIZE g_bwe.* TO NULL      #No.FUN-750051
    INITIALIZE g_bwg.*  TO NULL      #CHI-BB0016 add
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
            #bwe00,bwe01,bwe03,ima02,bwe04,ima15
             bwe011,bwe00,bwe01,bwe03,ima02,ima021,ima1916,bwe031,bwe04,ima15  #FUN-6A0007   #FUN-9C0055 add bwe031
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
          WHEN INFIELD(bwe03)                                                   
#FUN-AA0059 --Begin--
          #  CALL cl_init_qry_var()                                              
          #  LET g_qryparam.form = "q_ima"                                       
          #  LET g_qryparam.state = "c"                                          
          #  LET g_qryparam.default1 = g_bwe.bwe03                               
          #  CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            CALL q_sel_ima( TRUE, "q_ima","",g_bwe.bwe03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
            DISPLAY g_qryparam.multiret TO bwe03                                
            NEXT FIELD bwe03                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
     #--
 
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
   #LET g_sql="SELECT bwe_file.bwe00,bwe01,bwe02,bwe011 FROM bwe_file,ima_file ",                #MOD-C50034 mark
    LET g_sql="SELECT bwe_file.bwe00,bwe01,bwe02,bwe011,'','',bwe03 FROM bwe_file,ima_file ",    #MOD-C50034 add
        " WHERE ",g_wc CLIPPED,
        " AND  bwe03 = ima01 "
 
    PREPARE p_bwe_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE p_bwe_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR p_bwe_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM bwe_file,ima_file WHERE ",g_wc CLIPPED,
        " AND  bwe03 = ima01 "
 
    PREPARE p_bwe_precount FROM g_sql
    DECLARE p_bwe_count CURSOR FOR p_bwe_precount
END FUNCTION
 
FUNCTION p_bwe_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL p_bwe_q()
            END IF
            NEXT OPTION "next" 
        ON ACTION next 
            CALL p_bwe_fetch('N') 
        ON ACTION previous 
            CALL p_bwe_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL p_bwe_u()
            END IF
            NEXT OPTION "next"
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
            CALL p_bwe_fetch('/')
        ON ACTION first
            CALL p_bwe_fetch('F')
        ON ACTION last
            CALL p_bwe_fetch('L')
 
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
               IF g_bwe.bwe00 IS NOT NULL THEN            
                  LET g_doc.column1 = "bwe00"               
                  LET g_doc.column2 = "bwe01" 
                  LET g_doc.column3 = "bwe02"
                  LET g_doc.column4 = "bwe011"              
                  LET g_doc.value1 = g_bwe.bwe00            
                  LET g_doc.value2 = g_bwe.bwe01
                  LET g_doc.value3 = g_bwe.bwe02
                  LET g_doc.value4 = g_bwe.bwe011           
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
    CLOSE p_bwe_curs
END FUNCTION
 
 
FUNCTION p_bwe_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680062 smallint
        l_bwe04         DEC(15,3)                     #MOD-BC0166 add 
   #MOD-BC0166 str-----
   #INPUT BY NAME
   #       # g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe03,g_bwe.bwe04
   #        g_bwe.bwe011,g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe03,g_bwe.bwe04  #FUN-6A0007
   #    WITHOUT DEFAULTS 
    INPUT g_bwe.bwe011,g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe03,l_bwe04  WITHOUT DEFAULTS
     FROM bwe011,bwe00,bwe01,bwe03,bwe04


    AFTER INPUT
         LET g_bwe.bwe04 = l_bwe04
   #MOD-BC0166 end-----
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(bwe01) THEN
        #        LET g_bwe.* = g_bwe_t.*
        #        DISPLAY BY NAME g_bwe.* 
        #        NEXT FIELD bwe01
        #    END IF
        #MOD-650015 --end
 
        #FUN-530065                                                                                                                 
        ON ACTION CONTROLP                                                                                                          
           CASE                                                                                                                     
              WHEN INFIELD(bwe03)                                                                                                   
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()                                                                                              
             #   LET g_qryparam.form = "q_ima"                                                                                       
             #   LET g_qryparam.default1 = g_bwe.bwe03                                                                               
             #   CALL cl_create_qry() RETURNING g_bwe.bwe03                                                                          
                CALL q_sel_ima(FALSE, "q_ima", "", g_bwe.bwe03, "", "", "", "" ,"",'' )  RETURNING g_bwe.bwe03 
#FUN-AA0059 --End--
                DISPLAY BY NAME g_bwe.bwe03                                                                                        
                NEXT FIELD bwe03                                                                                                    
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
 
FUNCTION p_bwe_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bwe.* TO NULL                 #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL p_bwe_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN p_bwe_count
    FETCH p_bwe_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN p_bwe_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwe.bwe01,SQLCA.sqlcode,0)
        INITIALIZE g_bwe.* TO NULL
    ELSE
        CALL p_bwe_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_bwe_fetch(p_flbwe)
    DEFINE
        p_flbwe         LIKE type_file.chr1,         #No.FUN-680062   VARCHAR(1)   
        l_abso          LIKE type_file.num10         #No.FUN-680062   integer
 
    CASE p_flbwe
        WHEN 'N' FETCH NEXT     p_bwe_curs INTO g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011,g_bwg.bwg02,g_bwg.bwg041,g_bwe.bwe03   #CHI-BB0016 add g_bwg.bwg02,g_bwg.bwg041  #MOD-C50034 add ,g_bwe.bwe03 
        WHEN 'P' FETCH PREVIOUS p_bwe_curs INTO g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011,g_bwg.bwg02,g_bwg.bwg041,g_bwe.bwe03   #CHI-BB0016 add g_bwg.bwg02,g_bwg.bwg041  #MOD-C50034 add ,g_bwe.bwe03 
        WHEN 'F' FETCH FIRST    p_bwe_curs INTO g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011,g_bwg.bwg02,g_bwg.bwg041,g_bwe.bwe03   #CHI-BB0016 add g_bwg.bwg02,g_bwg.bwg041  #MOD-C50034 add ,g_bwe.bwe03 
        WHEN 'L' FETCH LAST     p_bwe_curs INTO g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011,g_bwg.bwg02,g_bwg.bwg041,g_bwe.bwe03   #CHI-BB0016 add g_bwg.bwg02,g_bwg.bwg041  #MOD-C50034 add ,g_bwe.bwe03 
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR l_abso
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            END IF
           #FETCH ABSOLUTE l_abso p_bwe_curs INTO g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011,g_bwe.bwe01
           #FETCH ABSOLUTE l_abso p_bwe_curs INTO g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011  #FUN-6A0007                          #MOD-C50034 mark
            FETCH ABSOLUTE l_abso p_bwe_curs INTO g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011,g_bwg.bwg02,g_bwg.bwg041,g_bwe.bwe03  #MOD-C50034 add
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwe.bwe01,SQLCA.sqlcode,0)
        INITIALIZE g_bwe.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbwe
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bwe.* FROM bwe_file            # 重讀DB,因TEMP有不被更新特性
       WHERE bwe00 = g_bwe.bwe00 AND bwe01 = g_bwe.bwe01 AND bwe02 = g_bwe.bwe02 AND bwe011 = g_bwe.bwe011
         AND bwe03 = g_bwe.bwe03        #MOD-C50034 add
  #       AND bwe01=g_bwe.bwe01          #FUN-6A0007
   #      AND bwe011=g_bwe.bwe011  #FUN-6A0007
     CALL p_bwg_find()              #CHI-BB0016 add for重讀DB
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bwe.bwe01,SQLCA.sqlcode,0)    #No.FUN-660052
       CALL cl_err3("sel","bwe_file",g_bwe.bwe01,"",SQLCA.sqlcode,"","",1)
    ELSE
        CALL p_bwe_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION p_bwe_show()
    DEFINE l_ima02 LIKE ima_file.ima02 
    DEFINE l_ima15 LIKE ima_file.ima14 
    DEFINE x_bwa02 LIKE bwa_file.bwa02
    #FUN-6A0007-- start
    DEFINE l_ima021    LIKE ima_file.ima021,
           l_ima1916 LIKE ima_file.ima1916,
           l_bxe02 LIKE bxe_file.bxe02,
           l_bxe03 LIKE bxe_file.bxe03
    #FUN-6A0007-- end
  
    LET g_bwe_t.* = g_bwe.*
    LET g_bwg_t.* = g_bwg.*         #CHI-BB0016 add
    
    DISPLAY BY NAME
           #g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe03,g_bwe.bwe04
           #g_bwe.bwe011,g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe03,g_bwe.bwe04  #FUN-6A0007
            g_bwe.bwe011,g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe03,g_bwe.bwe031,g_bwe.bwe04,  #FUN-6A0007   #FUN-9C0055 add g_bwe.bwe031
            g_bwg.bwg02,g_bwg.bwg041                  #CHI-BB0016 add
   #SELECT ima02,ima15 INTO l_ima02,l_ima15 
   #FROM ima_file WHERE ima01 = g_bwe.bwe03   #FUN-6A0007 mark
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         DISPLAY "                           " AT 7,21
    ELSE DISPLAY "                           " AT 7,40
    END IF
    SELECT bwa02 into x_bwa02 from bwa_file where bwa01 = g_bwe.bwe01
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         DISPLAY "上階料號:",x_bwa02 AT 7,21  #NO:7527 REVERSE拿掉 
    ELSE DISPLAY "上階料號:",x_bwa02 AT 7,40  #NO:7527 REVERSE拿掉
    END IF
   #SELECT ima02,ima15 INTO l_ima02,l_ima15 
    SELECT ima02,ima021,ima1916,ima15 INTO l_ima02,l_ima021,l_ima1916,l_ima15 #FUN-6A0007
    FROM ima_file WHERE ima01 = g_bwe.bwe03
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
 
FUNCTION p_bwe_u()
    IF g_bwe.bwe01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bwe01_t = g_bwe.bwe01
    LET g_bwe011_t = g_bwe.bwe011  #FUN-6A0007
    BEGIN WORK
 
   #OPEN p_bwe_curl USING g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011              #MOD-C50034 mark
    OPEN p_bwe_curl USING g_bwe.bwe00,g_bwe.bwe01,g_bwe.bwe02,g_bwe.bwe011,g_bwe.bwe03  #MOD-C50034 add
    IF STATUS THEN
       CALL cl_err("OPEN p_bwe_curl:", STATUS, 1)
       CLOSE p_bwe_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_bwe_curl INTO g_bwe.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bwe.bwe01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL p_bwe_show()                          # 顯示最新資料
    WHILE TRUE
        CALL p_bwe_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bwe_file SET bwe_file.* = g_bwe.*    # 更新DB
            WHERE bwe00 = g_bwe_t.bwe00 AND bwe01 = g_bwe_t.bwe01 AND bwe02 = g_bwe_t.bwe02 AND bwe011 = g_bwe_t.bwe011             # COLAUTH?
              AND bwe03 = g_bwe.bwe03        #MOD-C50034 add
        IF SQLCA.sqlcode 
        THEN
#           CALL cl_err(g_bwe.bwe01,SQLCA.sqlcode,0)   #NO.FUN-660052
            CALL cl_err3("upd","bwe_file",g_bwe01_t,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE p_bwe_curl
    COMMIT WORK
END FUNCTION
FUNCTION p_bwg_find()        #CHI-BB0016  若有多筆生效日期，抓取最新的生效日期        
    DEFINE l_count           LIKE type_file.num10
    DEFINE l_bwg02           LIKE bwg_file.bwg02
    DEFINE l_bwg041          LIKE bwg_file.bwg041
    
    SELECT COUNT(*) INTO l_count FROM bwg_file WHERE bwg04 = g_bwe.bwe03  

    CASE
     WHEN l_count =1 
          SELECT bwg02,bwg041 INTO g_bwg.bwg02,g_bwg.bwg041 FROM bwg_file WHERE bwg04 = g_bwe.bwe03
     WHEN l_count >1 
         INITIALIZE g_bwg.* TO NULL
         LET g_sql="SELECT bwg02,bwg041 FROM bwg_file WHERE bwg04 = '",g_bwe.bwe03 CLIPPED,"'"
         PREPARE p_bwg_prepare FROM g_sql           
         DECLARE p_bwg_curs CURSOR FOR p_bwg_prepare
         FOREACH p_bwg_curs INTO l_bwg02,l_bwg041
            IF cl_null(g_bwg.bwg02) THEN
               LET  g_bwg.bwg02  = l_bwg02
               LET  g_bwg.bwg041 = l_bwg041
            ELSE 
               IF l_bwg02 >g_bwg.bwg02 THEN 
                 LET  g_bwg.bwg02  = l_bwg02
                 LET  g_bwg.bwg041 = l_bwg041
               END IF
            END IF
         END FOREACH
    END CASE

    
END FUNCTION
