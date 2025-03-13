# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: acop760.4gl
# Descriptions...: 基本資料導入電子合同系統作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0139 09/11/25 By jan 1.料件基本資料導入時，應過濾保稅料件才可導入
# .............................................. 2.BOM資料導入時，撈主件資料時，應過濾主件必需是保稅料件，且元件在INSERT cek_file 前，應判斷保稅料件才可insert 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_ima RECORD
                 ima01      LIKE ima_file.ima01,
                 ima901     LIKE ima_file.ima901
                END RECORD
   DEFINE g_bma RECORD
                 bma01      LIKE bma_file.bma01,
                 bma06      LIKE bma_file.bma06
                END RECORD
   DEFINE tm    RECORD                         # Print condition RECORD
                 a       LIKE type_file.chr1,           
                 b       LIKE type_file.chr1,          
                 azi01      LIKE azi_file.azi01,  #歸併前幣別
                 bma01   LIKE bma_file.bma01,         
                 bma06   LIKE bma_file.bma06,         
                 ver     LIKE bma_file.bma06   #版本，當無使用特性BOM時，則要輸入BOM預設備本        
                END RECORD
                
   DEFINE g_cei      RECORD  LIKE cei_file.*
   DEFINE g_wc          STRING
   DEFINE g_sql         STRING  
   DEFINE g_showmsg     STRING               
   DEFINE g_bma01       LIKE bma_file.bma01
   DEFINE g_bma06       LIKE bma_file.bma06      
   DEFINE g_cej02       LIKE cej_file.cej02      
   DEFINE g_ima08       LIKE ima_file.ima08
   DEFINE g_ima25       LIKE ima_file.ima25
   DEFINE g_ima01       LIKE ima_file.ima01
   DEFINE g_cnt         LIKE type_file.num5  
   DEFINE g_bmb01_cnt   LIKE type_file.num5   
   DEFINE g_bmb03_cnt   LIKE type_file.num5 
   DEFINE g_cei_cnt     LIKE type_file.num5
   DEFINE g_cei03_cnt   LIKE type_file.num5
   DEFINE g_cei02_max   LIKE type_file.num5
   DEFINE p_row,p_col   LIKE type_file.num5,
          g_change_lang LIKE type_file.chr1,     
          l_flag        LIKE type_file.chr1   
   DEFINE g_ins_num     LIKE type_file.num5      
 
MAIN
   OPTIONS 
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET tm.b           = ARG_VAL(1)        
   LET tm.a           = ARG_VAL(2)        
   LET g_wc           = ARG_VAL(3)
   LET tm.azi01       = ARG_VAL(4)
   LET tm.bma01       = ARG_VAL(5)
   LET tm.bma06       = ARG_VAL(6)
   LET tm.ver         = ARG_VAL(7)
   LET g_bgjob        = ARG_VAL(8)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
   WHILE TRUE
     IF g_bgjob = 'N' THEN
        LET g_ins_num = 0                 
        CALL p760()
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           BEGIN WORK
           LET g_success = 'Y'
           IF tm.b = '1' THEN
              CALL p760_1()     #料件基本資料導入
           ELSE    
              CALL p760_2()     #BOM導入
           END IF
 
           CALL s_showmsg()         
           IF g_success = 'Y' THEN
              COMMIT WORK
              IF g_ins_num = 0 THEN
                 CALL cl_err('','axc-034',1)
                 LET l_flag = 'Y'
              ELSE
                 CALL cl_end2(1) RETURNING l_flag       
              END IF
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag          
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p760_w
     ELSE
        BEGIN WORK
        LET g_success = 'Y'
        IF tm.b = '1' THEn
           CALL p760_1()
        ELSE  
           CALL p760_2()
        END IF
        CALL s_showmsg()          
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
 
FUNCTION p760()   #輸入條件
DEFINE lc_cmd    LIKE type_file.chr1000  
DEFINE l_n       LIKE type_file.num5
 
   OPEN WINDOW p760_w AT p_row,p_col WITH FORM "aco/42f/acop760" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("bma06",g_sma.sma118='Y') 
   CALL cl_set_comp_required("ver",TRUE) 
 
   CALL cl_opmsg('f')
 
   WHILE TRUE
     CLEAR FORM
     LET g_change_lang = FALSE
     LET g_bgjob = 'N'
     LET tm.b = '1'      
     LET tm.a = '1'     
      
     INPUT BY NAME tm.b WITHOUT DEFAULTS    #1:料件基本資料導入  2:產品結構BOM導入
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION about      
            CALL cl_about()    
         ON ACTION help         
            CALL cl_show_help() 
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
     
         ON ACTION locale
             CALL cl_dynamic_locale()               
             LET g_change_lang = TRUE
             EXIT INPUT
             
         ON ACTION exit                           
             LET INT_FLAG = 1
             EXIT INPUT
             
         AFTER INPUT
             IF INT_FLAG THEN
                LET INT_FLAG = 0                    
                CLOSE WINDOW p760_w                 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                EXIT PROGRAM
             END IF                           
     END INPUT
 
     IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW p760_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
     END IF 
     IF g_change_lang = TRUE THEN 
       LET g_change_lang = FALSE      
         CALL cl_dynamic_locale()        
         CALL cl_show_fld_cont()       
         CONTINUE WHILE 
     END IF
 
    
     IF tm.b = '1' THEN    #料件基本資料導入              
        INPUT BY NAME tm.a WITHOUT DEFAULTS    #1:成品  2:料件  3:委外半成品
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG
              CALL cl_cmdask()    # Command execution
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
           ON ACTION about      
              CALL cl_about()    
           ON ACTION help         
              CALL cl_show_help() 
 
           ON ACTION qbe_save
              CALL cl_qbe_save()
 
           ON ACTION locale
               CALL cl_dynamic_locale()               
               LET g_change_lang = TRUE
               EXIT INPUT
 
           ON ACTION exit                           
               LET INT_FLAG = 1
               EXIT INPUT
 
           AFTER INPUT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0                    
                  CLOSE WINDOW p760_w                 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                  EXIT PROGRAM
               END IF                           
         END INPUT
 
         IF INT_FLAG THEN
           LET INT_FLAG = 0
           CLOSE WINDOW p760_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
         END IF 
         IF g_change_lang = TRUE THEN 
           LET g_change_lang = FALSE      
             CALL cl_dynamic_locale()        
             CALL cl_show_fld_cont()       
             CONTINUE WHILE 
         END IF
 
 
         CONSTRUCT BY NAME g_wc ON ima01,ima901  #料件編號 / 建檔日期 
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
 
            ON ACTION locale
               LET g_change_lang = TRUE
               EXIT CONSTRUCT
 
            ON ACTION exit                     
               CLOSE WINDOW p760_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
 
            ON ACTION qbe_select
               CALL cl_qbe_select()
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
         
         IF INT_FLAG THEN
           LET INT_FLAG=0 
           CLOSE WINDOW p760_w 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM 
         END IF
         IF g_change_lang = TRUE THEN 
             LET g_change_lang = FALSE      
             CALL cl_dynamic_locale()        
             CALL cl_show_fld_cont()       
             CONTINUE WHILE 
         END IF 
  
      #輸入預設歸併前幣別
        INPUT BY NAME tm.azi01 WITHOUT DEFAULTS    
           AFTER FIELD azi01
             LET l_n = 0
             SELECT COUNT(*) INTO l_n FROM azi_file
              WHERE azi01 = tm.azi01
                AND aziacti = 'Y'        
             IF l_n = 0 THEN 
                CALL cl_err(tm.azi01,'mfg3008',1)
                NEXT FIELD azi01
             END IF
           ON ACTION controlp
              CASE WHEN INFIELD(azi01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azi"
                  CALL cl_create_qry() RETURNING tm.azi01
                  DISPLAY BY NAME tm.azi01
                  NEXT FIELD azi01
              OTHERWISE
              END CASE
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG
              CALL cl_cmdask()    # Command execution
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
           ON ACTION about      
              CALL cl_about()    
           ON ACTION help         
              CALL cl_show_help() 
 
           ON ACTION qbe_save
              CALL cl_qbe_save()
 
           ON ACTION locale
               CALL cl_dynamic_locale()               
               LET g_change_lang = TRUE
               EXIT INPUT
 
           ON ACTION exit                           
               LET INT_FLAG = 1
               EXIT INPUT
 
           AFTER INPUT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0                    
                  CLOSE WINDOW p760_w                 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                  EXIT PROGRAM
               END IF                           
         END INPUT
 
         IF INT_FLAG THEN
           LET INT_FLAG = 0
           CLOSE WINDOW p760_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
         END IF 
         IF g_change_lang = TRUE THEN 
           LET g_change_lang = FALSE      
             CALL cl_dynamic_locale()        
             CALL cl_show_fld_cont()       
             CONTINUE WHILE 
         END IF
 
     END IF  
     
     IF tm.b = '2' THEN     #BOM導入         
        LET tm.bma01 = ''
        LET tm.bma06 = ' '
        LET tm.ver = ''
        INPUT BY NAME tm.bma01,tm.bma06,tm.ver WITHOUT DEFAULTS   #主件料件編號/特性代碼
          AFTER FIELD bma01
             IF cl_null(tm.bma01) THEN NEXT FIELD bma01 END IF
 
          AFTER FIELD bma06
             IF cl_null(tm.bma06) THEN 
                LET tm.bma06 = ' '
             END IF
             LET tm.ver = tm.bma06
             DISPLAY BY NAME tm.ver
 
          AFTER FIELD ver
             IF cl_null(tm.ver) THEN
                IF cl_null(g_sma.sma118) OR g_sma.sma118 = 'N' THEN   #不使用特性BOM則一定要輸入版本別
                   NEXT FIELD ver
                END IF
             END IF
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG 
             CALL cl_cmdask()    # Command execution
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
          ON ACTION about         
             CALL cl_about()      
          ON ACTION help          
             CALL cl_show_help()  
 
          ON ACTION exit
             LET INT_FLAG = 1
             EXIT INPUT
 
          ON ACTION qbe_save
            CALL cl_qbe_save()
 
          ON ACTION locale
              CALL cl_dynamic_locale()               
              LET g_change_lang = TRUE
              EXIT INPUT
              
          ON ACTION controlp
             CASE
                WHEN INFIELD(bma01)     
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_bma101"
                  CALL cl_create_qry() RETURNING tm.bma01
                  DISPLAY BY NAME tm.bma01
                  NEXT FIELD bma01
                WHEN INFIELD(bma06)      
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_bma11"
                  LET g_qryparam.arg1 = tm.bma01                  
                  CALL cl_create_qry() RETURNING tm.bma06
                  DISPLAY BY NAME tm.bma06
                  NEXT FIELD bma06
                OTHERWISE EXIT CASE
              END CASE
        END INPUT
         IF INT_FLAG THEN
           LET INT_FLAG = 0
           CLOSE WINDOW p760_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
         END IF 
         IF g_change_lang = TRUE THEN 
           LET g_change_lang = FALSE      
             CALL cl_dynamic_locale()        
             CALL cl_show_fld_cont()       
             CONTINUE WHILE 
         END IF
     END IF          
 
   IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = g_prog
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err(g_prog,'9031',1)   
        ELSE          
           LET g_wc  = cl_replace_str(g_wc,"'","\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.b,"'",
                        " '",tm.a,"'",
                        " '",g_wc CLIPPED,"'",
                        " '",tm.bma01,"'",
                        " '",tm.bma06,"'",
                        " '",tm.ver,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat(g_prog,g_time,lc_cmd CLIPPED)
        END IF
   END IF
   EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION p760_1()  #料件基本資料導入
   DEFINE l_bmb02_t	LIKE bmb_file.bmb02,
          l_i           LIKE type_file.num5,         
          l_cei      RECORD LIKE cei_file.*
 
   LET g_cei02_max = 0
 
   IF g_bgjob = "N" THEN    
      CALL cl_wait()
   END IF
   IF cl_null(g_wc) THEN  RETURN  END IF
 
   LET g_sql = "SELECT ima01,ima08,ima25 ",
               "  FROM ima_file  ",
               " WHERE 1=1 ",  
               "   AND imaacti='Y' ",
               "   AND ima1010='1' ",   #已確認的料號
               "   AND ima15= 'Y' ",    #FUN-9B0139 報稅料件
               "   AND ", g_wc CLIPPED
 
   CASE tm.a 
      WHEN '1' LET g_sql = g_sql," AND ima08 = 'M'"   #來源碼 M:自製料件
      WHEN '2' LET g_sql = g_sql," AND ima08 = 'P'"   #       P:採購料件
     #WHEN '3' LET g_sql = g_sql," AND ima08 = 'S'"   #       S:廠外加工料件
   END CASE
 
   LET g_sql = g_sql CLIPPED," ORDER BY ima01"
   PREPARE p760_01_prepare FROM g_sql
   DECLARE p760_01_cs CURSOR WITH HOLD FOR p760_01_prepare
   OPEN p760_01_cs 
   IF STATUS THEN
     LET g_success = 'N'
     CALL s_errmsg("OPEN p760_01_cs:",'','',STATUS,1)
     RETURN
   END IF
 
 
   IF tm.a ='2' THEN  #料件
      LET g_sql = "SELECT MAX(cei02) FROM cei_file ",
                  " WHERE cei01 ='2' "
   ELSE
      LET g_sql = "SELECT MAX(cei02) FROM cei_file ",
                  " WHERE cei01 !='2' "
   END IF               
   PREPARE f03_pr FROM g_sql
   DECLARE f03_cs CURSOR WITH HOLD FOR f03_pr
   FOREACH p760_01_cs INTO g_ima01,g_ima08,g_ima25
       IF SQLCA.SQLCODE THEN
           CALL s_errmsg("ima01",g_ima.ima01,"sel ima",STATUS,1)
           LET g_success = 'N'
           RETURN
       END IF
 
       SELECT COUNT(cei03) INTO g_cei03_cnt   #廠內料號
         FROM cei_file 
        WHERE cei03 = g_ima01 
       IF g_cei03_cnt > 0 THEN CONTINUE FOREACH END IF  
 
       INITIALIZE l_cei.* TO NULL
 
       OPEN f03_cs  
       FETCH f03_cs INTO g_cei02_max
       CLOSE f03_cs
       IF cl_null(g_cei02_max) THEN
           LET g_cei02_max = 0
       END IF
       LET g_cei02_max=g_cei02_max+1
 
 
       LET l_cei.cei01=tm.a           #料件類別 1.成品 2.料件 3.委外半成品
       LET l_cei.cei02 = g_cei02_max  #序號 
       LET l_cei.cei03 = g_ima01      #廠內料號(不可維護)      
       LET l_cei.cei04 = ' '          #海關商品編號
       LET l_cei.cei05 = tm.azi01     #歸併前幣別          
       LET l_cei.cei06 = 0            #歸併前單價              
       LET l_cei.cei07 = g_ima25      #企業使用單位(default庫存單位)
 
       IF cl_null(l_cei.cei06) THEN LET l_cei.cei06 = 0 END IF
       IF cl_null(l_cei.cei07) THEN LET l_cei.cei07 = ' ' END IF
 
       LET l_cei.cei08 = ' '          #申報計量單位(不可維護),於歸併關係表中，做歸併時會自動帶出
       LET l_cei.cei09 = ' '          #法定計量單位 
       LET l_cei.cei10 = 1            #法定計量單位轉換比率   
       LET l_cei.cei11 = ' '          #歸併後序號 
       LET l_cei.cei12 = ' '          #歸併後品名 
       LET l_cei.cei13 = ' '          #歸併後規格
       LET l_cei.cei14 = 0            #歸併後單價
       LET l_cei.cei15 = 'N'          #審核狀態
       LET l_cei.cei16 = ' '          #合同申請單號 
       LET l_cei.cei17 = ' '          #第二法定單位
       LET l_cei.cei18 = 1            #第二法定單位轉換率
       LET l_cei.cei19 = 1            #申報單位轉換率(不可維護)
       LET l_cei.cei20 = NULL         #歸併後貨號
       LET l_cei.cei21 = ' '          #備註說明 
       LET l_cei.cei22 = ''           #歸併後幣別
       LET l_cei.ceiacti = 'Y'        #
       LET l_cei.ceiuser = g_user     #
       LET l_cei.ceigrup = g_grup     #
       LET l_cei.ceimodu = ' '        #
       LET l_cei.ceidate = NULL       # 
 
       LET l_cei.ceioriu = g_user      #No.FUN-980030 10/01/04
       LET l_cei.ceiorig = g_grup      #No.FUN-980030 10/01/04
       INSERT INTO cei_file VALUES(l_cei.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             LET g_showmsg= "1","/",g_ima01,"/",g_cei02_max
             CALL s_errmsg('cei01,cei02,cei03',g_showmsg,
                            'ins cei',SQLCA.SQLCODE,1)
             LET g_success = 'N'
         END IF
       LET g_ins_num = g_ins_num + 1  
   END FOREACH    
END FUNCTION
 
 
 
FUNCTION p760_2()
   DEFINE l_cei03_cnt  LIKE type_file.num5
   LET g_ima01 = ""
   LET g_ima08 = ""
   LET l_cei03_cnt = 0
   
   SELECT ima01,ima08,bma01,bma06            #料號/來源碼/主件料號/特性碼
     INTO g_ima01,g_ima08,g_bma01,g_bma06
     FROM bma_file, ima_file 
      WHERE ima01 = bma01 
        AND ima15 = 'Y'        #FUN-9B0139 報稅料件
        AND bma01 = tm.bma01   #主件料號
        AND bma06 = tm.bma06   #特性代碼
        AND bma05 IS NOT NULL  #發放日期
   IF STATUS THEN
      CALL cl_err(tm.bma01,'aco-711',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT COUNT(cei03) INTO l_cei03_cnt FROM cei_file
    WHERE cei03 = g_ima01 
      AND cei15 = 'Y'
   IF l_cei03_cnt = 0 THEN
      CALL cl_err(tm.bma01,'aco-712',1)
      LET g_success='N'
      RETURN 
   END IF
 
   IF g_ima08 = 'M' THEN   #自製料件
      CALL p760_21()
   ELSE
      CALL p760_23()   
   END IF
END FUNCTION
 
 
 
FUNCTION p760_21()   #轉自製料件 
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_cej RECORD LIKE cej_file.*
   
   LET g_cej02 = tm.ver CLIPPED
 
   SELECT * INTO g_cei.* FROM cei_file WHERE cei03=g_ima01 
 
   SELECT COUNT(cej04) INTO l_cnt FROM cej_file
    WHERE cej01 = g_cei.cei02 
      AND cej02 = g_cej02
      AND cej03 = g_bma06
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN RETURN END IF
 
   IF cl_null(g_cei.cei04) THEN LET g_cei.cei04=' ' END IF 
 
   LET l_cej.cej01 = g_cei.cei02   #成品序號
   LET l_cej.cej02 = g_cej02       #BOM版本           
   LET l_cej.cej03 = g_bma06       #特性碼
   LET l_cej.cej04 = g_ima01       #廠內料號
   LET l_cej.cej05 = g_cei.cei11   #歸併後序號 
   LET l_cej.cej06 = g_cei.cei04   #海關商品編號
   LET l_cej.cej07 = 'N'           #審核狀態
   LET l_cej.cejacti = 'Y'
   LET l_cej.cejuser = g_user
   LET l_cej.cejgrup = g_grup
   INSERT INTO cej_file(cej01,cej02,cej03,cej04,cej05,
                        cej06,cej07,cejacti,cejuser,cejgrup,cejoriu,cejorig)
        VALUES(l_cej.cej01,l_cej.cej02,l_cej.cej03,l_cej.cej04,l_cej.cej05,
               l_cej.cej06,l_cej.cej07,
               l_cej.cejacti,l_cej.cejuser,l_cej.cejgrup, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       LET g_success = 'N'
       CALL s_errmsg("ins cej",'','',"insert cej_file",1)
       RETURN
   END IF
   LET g_ins_num = g_ins_num + 1 
   CALL p760_22(0,g_bma01,g_bma06,1)
END FUNCTION 
 
 
#                階     主件   特性碼
FUNCTION p760_22(p_level,p_key,p_key2,p_total)    #自製料件單身
 
   DEFINE p_level	LIKE type_file.num5,    
          p_key		LIKE bma_file.bma01,    #主件料號   = bma01
          p_key2        LIKE ima_file.ima910,   #主特性代碼 = bma06
          p_total       LIKE oqa_file.oqa10,    #數量
          p_date        DATE,
          l_fac         LIKE bmb_file.bmb10_fac, #「發料」對「料件庫存單位」換算率
          l_fac1        LIKE bmb_file.bmb10_fac, #「申報單位」對「料件庫存單位」換算率
          l_gfe03       LIKE gfe_file.gfe03,     #小數位數
          l_ac,l_m	LIKE type_file.num5,    
          l_arrno	LIKE type_file.num5,    
          l_chr		LIKE type_file.chr1,    
 
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料 
              level	LIKE type_file.num5,    
              bmb03     LIKE bmb_file.bmb03,     #元件料號
              bmb10     LIKE bmb_file.bmb10,     #發料單位
              ima25     LIKE ima_file.ima25,     #庫存單位
              ima55     LIKE ima_file.ima55,     #生產單位
              ima910    LIKE ima_file.ima910,    #料件主特性代碼
              bmb08     LIKE bmb_file.bmb08,     #損耗率
              bmb02     LIKE bmb_file.bmb02,     #組合項次
              bmb06     LIKE bmb_file.bmb06      #組成用量
          END RECORD,
 
          l_cmd	    LIKE type_file.chr1000,
          l_cnt,g_i SMALLINT
 
    DEFINE l_ima08     LIKE ima_file.ima08,   #來源碼 M自製 P採購 S委外
           l_cek13     LIKE cek_file.cek13    #類型 1:半成品  2:材料  
    DEFINE l_max  LIKE type_file.num5
 
    DEFINE l_cei RECORD  
          cei02 LIKE cei_file.cei02,    #序號
          cei04 LIKE cei_file.cei04,    #海關商品編號 
          cei08 LIKE cei_file.cei08,    #申報計量單位
          cei11 LIKE cei_file.cei11,    #歸併後序號
          cei19 LIKE cei_file.cei19     #申報單位轉換率 
          END RECORD
 
    DEFINE l_cek RECORD LIKE cek_file.*
    DEFINE l_old_bmb06 LIKE cek_file.cek10
    DEFINE l_new_bmb06 LIKE cek_file.cek10        
    DEFINE l_ima15     LIKE ima_file.ima15   #FUN-9B0139 
          
    SELECT count(*) INTO l_cnt FROM bma_file 
     WHERE bma01=p_key 
       AND bma06=p_key2 
       AND bma05 IS NOT NULL     #發放日期
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    IF l_cnt =0 THEN
        CALL cl_err('','aco-713',1) 
        LET g_success='N'
        RETURN 
    END IF   
              
 
    IF p_level > 20 THEN 
       CALL cl_err('','mfg2733',1) 
       LET g_success='N' 
       RETURN 
    END IF
 
    LET p_level = p_level + 1
    LET l_arrno = 600	
 
    LET l_cmd= "SELECT 0,bmb03,bmb10,",                #元件料號，發料計量單位
               "       ima25,ima55,ima910,bmb08,",     #庫存單位，生產單位，料件主特性代號，損耗率
               "       bmb02,bmb06/bmb07 bmb06",       #項次,組成用量/底數=組成用量 
               "  FROM bmb_file, ima_file ",
               " WHERE bmb01 ='", p_key,"'",
               "   AND bmb03 = ima_file.ima01 ",
               "   AND bmb29 ='",p_key2,"' ",
               " AND (bmb04 <='", g_today,"'"," OR bmb04 IS NULL )",
               " AND (bmb05 >'",g_today,"'"," OR bmb05 IS NULL )" 
    LET l_cmd = l_cmd CLIPPED," ORDER BY bmb02"
    PREPARE p760_precur FROM l_cmd
    IF SQLCA.sqlcode THEN 
       CALL cl_err('P1:',STATUS,1) 
       LET g_success='N'
       RETURN 
    END IF
    DECLARE p760_cur CURSOR WITH HOLD FOR p760_precur
 
    LET l_ac = 1
    FOREACH p760_cur INTO sr[l_ac]. *     	
        IF cl_null(sr[l_ac].ima910) THEN LET sr[l_ac].ima910 = ' ' END IF
        LET l_ac = l_ac + 1
        IF l_ac > l_arrno THEN   #l_arrno:600
           EXIT FOREACH 
        END IF
    END FOREACH
    CALL sr.deleteElement(l_ac)
    LET l_ac = l_ac - 1
    
    FOR l_m = 1 TO l_ac    	        	
        LET sr[l_m].level = p_level
        LET l_cnt = 0
 
        SELECT COUNT(*) INTO l_cnt  
          FROM bmb_file 
         WHERE bmb01 = sr[l_m].bmb03 
           AND bmb29 = sr[l_m].ima910    #主件特性=該筆元件的件料特性(ima910) 
 
        IF l_cnt > 0 THEN      # 若為主件 
           LET sr[l_m].bmb06= p_total * sr[l_m].bmb06      #如果是半成品，則乘以總耗 
 
                                         #發料單位 -> 生產單位
           CALL s_umfchk(sr[l_m].bmb03,sr[l_m].bmb10,sr[l_m].ima55)
           RETURNING g_i,l_fac
           IF g_i THEN LET l_fac=1 END IF
 
           LET sr[l_m].bmb06=sr[l_m].bmb06*l_fac
 
           CALL p760_22(p_level,sr[l_m].bmb03,sr[l_m].ima910,sr[l_m].bmb06)  
 
        ELSE #非主件
 
            LET sr[l_m].bmb06=p_total*sr[l_m].bmb06  #如果是最低階材料，則乘以單耗 
                                        #發料單位 -> 庫存單位 
            CALL s_umfchk(sr[l_m].bmb03,sr[l_m].bmb10,sr[l_m].ima25)
            RETURNING g_i,l_fac
            IF g_i THEN LET l_fac=1 END IF
            LET sr[l_m].bmb06=sr[l_m].bmb06*l_fac
 
            #FUN-9B0139 --begin--add---------
            LET l_ima15= ''
            SELECT ima15 INTO l_ima15 FROM ima_file
            WHERE ima01 = sr[l_m].bmb03
            IF l_ima15 != 'Y' THEN CONTINUE FOR END IF
            #FUN-9B0139 --end--add--------------
            SELECT cei02,cei04,cei08,cei11,cei19 
              INTO l_cei.* 
              FROM cei_file
             WHERE cei03=sr[l_m].bmb03 
               AND cei15='Y'
            IF SQLCA.SQLCODE = 0 THEN
              #申報單位/庫存單位轉換率
                CALL s_umfchk(sr[l_m].bmb03,sr[l_m].ima25,l_cei.cei08)
                RETURNING g_i,l_fac1
                IF g_i THEN LET l_fac1=1 END IF
                LET sr[l_m].bmb06=sr[l_m].bmb06*l_fac1
 
                SELECT MAX(cek04) INTO l_max FROM cek_file
                 WHERE cek01= g_cei.cei02 
                   AND cek02 = g_cej02 
                   AND cek03 = g_bma06            #特性碼
                IF l_max = 0 OR cl_null(l_max) THEN
                   LET l_max = 10
                ELSE 
                   LET l_max = l_max + 10
                END IF   
                IF cl_null(sr[l_m].bmb08) THEN LET sr[l_m].bmb08=0 END IF 
                IF cl_null(sr[l_m].bmb06) THEN LET sr[l_m].bmb06=0 END IF 
 
                IF NOT cl_null(l_cei.cei08) THEN  #申報計量單位 
                   IF sr[l_m].bmb10 <> l_cei.cei08 THEN  #bmb10(發料單位),cei08(申報單位)
                      IF NOT cl_null(l_cei.cei19) THEN       #申報單位轉換率
                         LET sr[l_m].bmb06=sr[l_m].bmb06*l_cei.cei19
                      END IF  
                   END IF
                END IF
            #---------要先判斷是否已經有了，若有了則update,否則insert--------
                SELECT count(*) INTO g_cnt FROM cek_file 
                 WHERE cek01 = g_cei.cei02 
                   AND cek02 = g_cej02 
                   AND cek06 = sr[l_m].bmb03
                   AND cek03 = g_bma06            #特性碼
                IF cl_null(g_cnt) THEN LET g_cnt=0 END IF         
                IF g_cnt>0 THEN  #已有存在了，則需要update原資料即可
                   #1>找到原資料
                   INITIALIZE l_cek.* TO NULL
                   SELECT * INTO l_cek.* FROM cek_file
                    WHERE cek01=g_cei.cei02 
                      AND cek02=g_cej02
                      AND cek06=sr[l_m].bmb03
                      AND cek03=g_bma06            #特性碼
 
                   #2>計算總損耗率   
                   #2-1>----原總耗
                    LET l_old_bmb06=l_cek.cek10/(1-l_cek.cek11/100)
                   #2-2>----新總耗
                    LET l_new_bmb06=sr[l_m].bmb06/(1-sr[l_m].bmb08/100)
 
                   #3>算累計單耗  
                   LET l_cek.cek10=l_cek.cek10+sr[l_m].bmb06       #單耗直接相加
 
                   #3-2>----最後損耗率
                   LET l_cek.cek11=100-l_cek.cek10/(l_old_bmb06+l_new_bmb06)*100
 
                   UPDATE cek_file SET cek10=l_cek.cek10,
                                       cek11=l_cek.cek11
                      WHERE cek01=l_cek.cek01 
                        AND cek02=l_cek.cek02 
                        AND cek04=l_cek.cek04
                        AND cek03=g_bma06            #特性碼
                   IF SQLCA.sqlcode THEN 
                      CALL cl_err('update cek_file',STATUS,1) 
                      LET g_success='N'
                      RETURN 
                   END IF
                   LET l_max=l_max - 10
                   IF l_max = 0 OR cl_null(l_max) THEN LET l_max = 10 END IF
                ELSE   #---------要先判斷是否已經有了，若有了則update,否則insert----
 
                  SELECT ima08 INTO l_ima08 FROM ima_file 
                   WHERE ima01=sr[l_m].bmb03
                  IF l_ima08='P' THEN 
                     LET l_cek13='2' 
                  ELSE 
                     LET l_cek13='1'
                  END IF
                  INITIALIZE l_cek.* TO NULL
                  LET l_cek.cek01 = g_cei.cei02
                  LET l_cek.cek02 = g_cej02
                  LET l_cek.cek03 = g_bma06
                  LET l_cek.cek04 = l_max
                  LET l_cek.cek05 = l_cei.cei02
                  LET l_cek.cek06 = sr[l_m].bmb03
                  LET l_cek.cek07 = l_cei.cei11
                  LET l_cek.cek08 = l_cei.cei04
                  LET l_cek.cek09 = l_cei.cei08
                  LET l_cek.cek10 = sr[l_m].bmb06
                  LET l_cek.cek11 = sr[l_m].bmb08
                  LET l_cek.cek12 = g_cei.cei11
                  LET l_cek.cek13 = l_cek13
                  INSERT INTO cek_file(cek01,cek02,cek03,cek04,
                                       cek05,cek06,cek07,cek08,
                                       cek09,cek10,cek11,cek12, 
                                       cek13) 
                       VALUES(l_cek.cek01,l_cek.cek02,l_cek.cek03,l_cek.cek04,
                              l_cek.cek05,l_cek.cek06,l_cek.cek07,l_cek.cek08,
                              l_cek.cek09,l_cek.cek10,l_cek.cek11,l_cek.cek12, 
                              l_cek.cek13)  
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
                     CALL cl_err('ins cek_file',STATUS,1) 
                     LET g_success='N'
                     RETURN 
                  END IF
                END IF        
                LET g_ins_num = g_ins_num + 1 
            ELSE      #如果未審核或者出錯，則停止一切後續動作   
               CALL cl_err(sr[l_m].bmb03,'aco-712',1) 
               LET g_success='N'
               RETURN 
            END IF
        END IF
    END FOR
END FUNCTION
 
 
FUNCTION p760_23()   #ima08 <> 'M' 非自製料件      
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_cmd	       LIKE type_file.chr1000
   DEFINE g_i          SMALLINT
   DEFINE l_cek13      LIKE cek_file.cek13,   #BOM版本
          l_ima08      LIKE ima_file.ima08
   DEFINE l_max        LIKE type_file.num5,
          l_fac        LIKE bmb_file.bmb10_fac,
          l_fac1       LIKE bmb_file.bmb10_fac
 
   DEFINE l_cei RECORD  
          cei02 LIKE cei_file.cei02,    #序號
          cei04 LIKE cei_file.cei04,    #海關商編
          cei08 LIKE cei_file.cei08,    #申報計量單位
          cei11 LIKE cei_file.cei11,    #歸併後序號
          cei19 LIKE cei_file.cei19     #申報單位轉換率
          END RECORD
 
   DEFINE sr  RECORD           
            bmb03    LIKE bmb_file.bmb03,       #元件料號
            bmb10    LIKE bmb_file.bmb10,       #發料單位 
            ima25    LIKE ima_file.ima25,       #庫存單位
            ima55    LIKE ima_file.ima55,       #生產單位
            bmb08    LIKE bmb_file.bmb08,       #損耗率
            bmb02    LIKE bmb_file.bmb02,       #組合項次
            bmb06    LIKE bmb_file.bmb06        #組成用量
          END RECORD
 
   DEFINE l_cej RECORD LIKE cej_file.*,
          l_cek RECORD LIKE cek_file.*
   DEFINE l_ima15   LIKE ima_file.ima15   #FUN-9B0139 
   
   SELECT * INTO g_cei.* FROM cei_file 
    WHERE cei03=g_ima01
 
   SELECT COUNT(*) INTO l_cnt FROM cej_file
      WHERE cej01 = g_cei.cei02 
        AND cej02 = g_cej02          
        AND cej03 = g_bma06          
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN RETURN END IF
   
   SELECT count(*) INTO l_cnt 
     FROM bma_file 
    WHERE bma01=g_bma01 
      AND bma06=g_bma06 
      AND bma05 IS NOT NULL    
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    IF l_cnt =0 THEN
        CALL cl_err('','aco-713',1) 
        LET g_success='N'
        RETURN 
    END IF   
   
   IF cl_null(g_cei.cei04) THEN LET g_cei.cei04=' ' END IF 
 
   LET l_cej.cej01 = g_cei.cei02      #成品序號
   LET l_cej.cej02 = tm.ver           #BOM版本
   LET l_cej.cej03 = g_bma06          #特性碼
   LET l_cej.cej04 = g_ima01          #廠內料號
   LET l_cej.cej05 = g_cei.cei11      #歸併後序號 
   LET l_cej.cej06 = g_cei.cei04      #海關商品編號
   LET l_cej.cej07 = 'N'              #審核狀態
   LET l_cej.cejacti = 'Y'           
   LET l_cej.cejuser = g_user
   LET l_cej.cejgrup = g_grup
   LET l_cej.cej03 = g_bma06
   INSERT INTO cej_file(cej01,cej02,cej03,cej04,cej05, 
                        cej06,cej07,cejacti,cejuser,cejgrup,cejoriu,cejorig)
        VALUES(l_cej.cej01,l_cej.cej02,l_cej.cej03,l_cej.cej04,l_cej.cej05, 
               l_cej.cej06,l_cej.cej07,
               l_cej.cejacti,l_cej.cejuser,l_cej.cejgrup, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       LET g_success = 'N'
       CALL s_errmsg("ins cej",'','',"insert cej_file",1)
       RETURN
   END IF
   LET g_ins_num = g_ins_num + 1 
 
   LET l_cmd= "SELECT bmb03,bmb10,",                            #元件料號，發料計量單位,
              "       ima25,ima55,bmb08,",                      #庫存單位，生產單位，損耗率
              "       bmb02,bmb06/bmb07 bmb06",                 #項次,組成用量 
              "  FROM bmb_file, ima_file ",
              " WHERE bmb01='", g_bma01,"'",
              "   AND bmb03= ima_file.ima01 ",
              "   AND bmb29 ='",g_bma06,"' ",
              " ORDER BY bmb02"
   PREPARE p2_precur FROM l_cmd
   IF SQLCA.sqlcode THEN 
      CALL cl_err('p2:',STATUS,1) 
      LET g_success='N'
      RETURN 
   END IF
   DECLARE p2_cur CURSOR WITH HOLD FOR p2_precur
   FOREACH p2_cur INTO sr.*     	
       #FUN-9B0139 --begin--add---------
       LET l_ima15= ''
       SELECT ima15 INTO l_ima15 FROM ima_file
        WHERE ima01 = sr.bmb03
       IF l_ima15 != 'Y' THEN CONTINUE FOREACH END IF
       #FUN-9B0139 --end--add--------------
                               #發料單位 -> 庫存單位
        CALL s_umfchk(sr.bmb03,sr.bmb10,sr.ima25)
        RETURNING g_i,l_fac
        IF g_i THEN LET l_fac=1 END IF
 
        LET sr.bmb06=sr.bmb06*l_fac
 
        SELECT cei02,cei04,cei08,cei11,cei19 
          INTO l_cei.* 
          FROM cei_file
         WHERE cei03 = sr.bmb03 AND cei15='Y'
 
        IF SQLCA.SQLCODE = 0 THEN
                               #庫存單位->申報單位
           CALL s_umfchk(sr.bmb03,sr.ima25,l_cei.cei08)
           RETURNING g_i,l_fac1
           IF g_i THEN LET l_fac1=1 END IF
           LET sr.bmb06=sr.bmb06*l_fac1
 
           SELECT MAX(cek04) INTO l_max FROM cek_file
              WHERE cek01 = g_cei.cei02 
                AND cek02 = l_cej.cej02        #cek02(BOM版本) 
                AND cek03 = g_bma06            #特性碼
           IF l_max = 0 OR cl_null(l_max) THEN
              LET l_max = 10
           ELSE 
              LET l_max = l_max + 10
           END IF   
           IF cl_null(sr.bmb08) THEN LET sr.bmb08 = 0 END IF 
           IF cl_null(sr.bmb06) THEN LET sr.bmb06 = 0 END IF
 
           SELECT ima08 INTO l_ima08 
             FROM ima_file 
            WHERE ima01 = sr.bmb03
           IF l_ima08= 'P' THEN 
             LET l_cek13='2'      #材料
           ELSE 
             LET l_cek13='1'      #半成品
           END IF
 
           LET l_cek.cek01 = l_cej.cej01    #成品序號 
           LET l_cek.cek02 = l_cej.cej02    #BOM版本 
           LET l_cek.cek03 = l_cej.cej03    #特性碼
           LET l_cek.cek04 = l_max          #單身項次 
           LET l_cek.cek05 = l_cei.cei02    #元件歸併前序號
           LET l_cek.cek06 = sr.bmb03       #廠內元件料號  = ima01 = bmb03
           LET l_cek.cek07 = l_cei.cei11    #歸併後序號
           LET l_cek.cek08 = l_cei.cei04    #海關商品編號 
           LET l_cek.cek09 = l_cei.cei08    #申報計量單位 
           LET l_cek.cek10 = sr.bmb06       #單耗
           LET l_cek.cek11 = sr.bmb08       #耗損率
           LET l_cek.cek12 = g_cei.cei11    #成品歸併後序號 
           LET l_cek.cek13 = l_cek13        #類型 1:半成品  2材料
 
           INSERT INTO cek_file(cek01,cek02,cek03,cek04,cek05,
                                cek06,cek07,cek08,cek09,cek10,
                                cek11,cek12,cek13) 
               VALUES(l_cek.cek01,l_cek.cek02,l_cek.cek03,l_cek.cek04,l_cek.cek05,
                      l_cek.cek06,l_cek.cek07,l_cek.cek08,l_cek.cek09,l_cek.cek10, 
                      l_cek.cek11,l_cek.cek12,l_cek.cek13 )  
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
              CALL cl_err('ins cek_file',STATUS,1) 
              LET g_success='N'
              RETURN 
           END IF
           LET g_ins_num = g_ins_num + 1 
        ELSE   #如果未審核或者出錯，則停止一切後續動作 
           CALL cl_err(sr.bmb03,'aco-712',1) 
           LET g_success='N'
           RETURN 
        END IF
   END FOREACH
 
   IF g_success!='N' THEN
      SELECT count(*) INTO l_cnt 
        FROM cek_file 
       WHERE cek01 = g_cei.cei02 
         AND cek02 = tm.ver             #BOM版本
         AND cek03 = g_bma06            #特性碼
      IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
      IF l_cnt = 0 THEN
          CALL cl_err('','aco-714',1) 
          LET g_success='N'
          RETURN 
      END IF
   END IF
END FUNCTION 
 
 
#FUN-930151
