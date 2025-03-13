# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aemq102.4gl
# Descriptions...: 設備備件ＢＩＮ卡查詢(依單據日期)
# Date & Author..: 2004/7/20 by day
# Modify.........: No.FUN-680072 06/08/24 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770003 07/07/01 By hongmei help按鈕不可用
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.CHI-840065 08/06/04 By sherry 切換上下筆時，單身顯示有問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_fia            RECORD
                     fia01	LIKE fia_file.fia01,
                     fia02	LIKE fia_file.fia02,
                     fjb03      LIKE fjb_file.fjb03,
                     ima02	LIKE ima_file.ima02, 
                     fiw04      LIKE fiw_file.fiw04,
                     fiw05      LIKE fiw_file.fiw05,
                     fiw06      LIKE fiw_file.fiw06,
                     img09      LIKE img_file.img09,
                     imk09      LIKE imk_file.imk09,
                     img10      LIKE img_file.img10
                     END RECORD,
    g_bdate          LIKE type_file.dat,             #No.FUN-680072DATE
    g_yy,g_mm        LIKE type_file.num10,           #No.FUN-680072INTEGER
    g_fiw            DYNAMIC ARRAY OF RECORD
                     fiv05      LIKE fiv_file.fiv05,
                     fiv00      LIKE fiv_file.fiv00,
                     b          LIKE fiv_file.fiv02,
                     c          LIKE fiv_file.fiv02,
                     fiw07      LIKE fiw_file.fiw07,
                     fiw07_fac  LIKE fiw_file.fiw07_fac,
                     fiw08      LIKE fiw_file.fiw08,  #異動數量
                     d          LIKE imk_file.imk09 #No.FUN-680072DECIMAL(15,3) #TQC-840066
                     END RECORD,
     g_wc             STRING,	     # Body Where condition  #No.FUN-580092 HCN
     g_sql,g_sql1     STRING,         #No.FUN-580092 HCN
     i                LIKE type_file.num10,          #No.FUN-680072INTEGER
     g_rec_b          LIKE type_file.num5   		  #單身筆數        #No.FUN-680072 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680072 VARCHAR(72)
DEFINE   l_ac            LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0068
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
 
   LET g_bdate=g_today
 
   LET p_row = 3 LET p_col = 6
 
   OPEN WINDOW q102_w AT p_row,p_col
        WITH FORM "aem/42f/aemq102" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   CALL q102_menu()  
 
   CLOSE WINDOW q102_w
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION q102_curs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680072 SMALLINT
 
   CLEAR FORM
   CALL g_fiw.clear() 
 
   CALL cl_opmsg('q')
 
   DISPLAY g_bdate TO bdate
   CALL cl_set_head_visible("","YES")          #No.FUN-6B0029
 
   INITIALIZE g_fia.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON fia01,fia02,fjb03,fiw04,fiw05,fiw06
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fia01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fia"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fia01
                NEXT FIELD fia01
             WHEN INFIELD(fjb03)   #need modify
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()   
             #   LET g_qryparam.state = "c"
             #   LET g_qryparam.form ="q_ima"
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO fjb03
                NEXT FIELD fjb03
             WHEN INFIELD(fiw04) 
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_imd"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fiw04
                NEXT FIELD fiw04
             WHEN INFIELD(fiw05) 
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_ime1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fiw05
                NEXT FIELD fiw05
             WHEN INFIELD(fiw06) 
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_ime1"
                LET g_qryparam.multiret_index =2
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fiw06
                NEXT FIELD fiw06
             OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fiauser', 'fiagrup') #FUN-980030
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   INPUT g_bdate WITHOUT DEFAULTS FROM bdate
      AFTER FIELD bdate
        IF cl_null(g_bdate) THEN                                                
           CALL cl_err('','aim-372',0)                                          
           NEXT FIELD bdate                                                     
        ELSE
           IF MONTH(g_bdate)=1 THEN
              LET g_yy=YEAR(g_bdate)-1
              LET g_mm=12
           ELSE
              LET g_yy = YEAR(g_bdate)
              LET g_mm = MONTH(g_bdate)-1
           END IF
        END IF                                                                  
                                                                                
      AFTER INPUT                                                               
        IF INT_FLAG THEN                                                        
           LET INT_FLAG = 0                                                     
           RETURN                                                               
        END IF                                                                  
 
      ON IDLE g_idle_seconds                                               
         CALL cl_on_idle()                                                 
         CONTINUE INPUT      
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
 
    LET g_sql= " SELECT UNIQUE fia01,fia02,fjb03,ima02,fiw04,fiw05, ",
               "        fiw06,img09,'','',img10 ",
               "   FROM fia_file, fjb_file, fiw_file, img_file,",
               "        fil_file, fiv_file, ima_file",
               "  WHERE fia01 = fjb01 AND fia01 = fil03 ",
               "    AND fiv01 = fiw01 AND fiv02 = fil01 ",
               "    AND fiw03 = fjb03 AND fjb03 = ima01 ",
               "    AND fjb03 = img01 AND fiw04 = img02 ",
               "    AND fiw05 = img03 AND fiw06 = img04 ",
               "    AND fiaacti='Y'   AND fivpost='Y' ",
               "    AND filacti='Y'   AND filconf='Y' ",
               "    AND ",g_wc CLIPPED
 
    LET g_sql=g_sql CLIPPED, "  ORDER BY fia01,fjb03,fiw04,fiw05,fiw06 "
    PREPARE q102_prepare FROM g_sql
    DECLARE q102_cs SCROLL CURSOR FOR q102_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql= " SELECT UNIQUE fia01,fjb03,fiw04,fiw05,fiw06 ",
               "   FROM fia_file, fjb_file, fiw_file, img_file,",
               "        fil_file, fiv_file, ima_file",
               "  WHERE fia01 = fjb01 AND fia01 = fil03 ",
               "    AND fiv01 = fiw01 AND fiv02 = fil01 ",
               "    AND fiw03 = fjb03 AND fjb03 = ima01 ",
               "    AND fjb03 = img01 AND fiw04 = img02 ",
               "    AND fiw05 = img03 AND fiw06 = img04 ",
               "    AND fiaacti='Y'   AND fivpost='Y' ",
               "    AND filacti='Y'   AND filconf='Y' ",
               "    AND ",g_wc CLIPPED,
               "   INTO TEMP x"
 
    DROP TABLE x                                                            
    PREPARE q102_precount_x FROM g_sql                                      
    EXECUTE q102_precount_x                                                 
    LET g_sql = " SELECT COUNT(*) FROM x " 
    PREPARE q102_pp  FROM g_sql
    DECLARE q102_cnt   CURSOR FOR q102_pp
END FUNCTION
 
FUNCTION q102_menu()
    WHILE TRUE
      CALL q102_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q102_q()
            END IF
         WHEN "help" 
#           CALL SHOWHELP(1)           #No.TQC-770003
            CALL cl_show_help()        #No.TQC-770003
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q102_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""      
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q102_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q102_cnt
       FETCH q102_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
       CALL q102_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q102_cs INTO g_fia.fia01,g_fia.fia02,
                                             g_fia.fjb03,g_fia.ima02,
                                             g_fia.fiw04,g_fia.fiw05,
                                             g_fia.fiw06,g_fia.img09,
                                             g_fia.imk09,g_fia.img10
        WHEN 'P' FETCH PREVIOUS q102_cs INTO g_fia.fia01,g_fia.fia02,
                                             g_fia.fjb03,g_fia.ima02,
                                             g_fia.fiw04,g_fia.fiw05,
                                             g_fia.fiw06,g_fia.img09,
                                             g_fia.imk09,g_fia.img10
        WHEN 'F' FETCH FIRST    q102_cs INTO g_fia.fia01,g_fia.fia02,
                                             g_fia.fjb03,g_fia.ima02,
                                             g_fia.fiw04,g_fia.fiw05,
                                             g_fia.fiw06,g_fia.img09,
                                             g_fia.imk09,g_fia.img10
        WHEN 'L' FETCH LAST     q102_cs INTO g_fia.fia01,g_fia.fia02,
                                             g_fia.fjb03,g_fia.ima02,
                                             g_fia.fiw04,g_fia.fiw05,
                                             g_fia.fiw06,g_fia.img09,
                                             g_fia.imk09,g_fia.img10
        WHEN '/'
          IF (NOT mi_no_ask) THEN      
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG=0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds                                           
                  CALL cl_on_idle()                                             
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
          FETCH ABSOLUTE g_jump q102_cs INTO g_fia.fia01,g_fia.fia02,
                                             g_fia.fjb03,g_fia.ima02,
                                             g_fia.fiw04,g_fia.fiw05,
                                             g_fia.fiw06,g_fia.img09,
                                             g_fia.imk09,g_fia.img10
          LET mi_no_ask = FALSE     
    END CASE
    IF SQLCA.sqlcode THEN                                                       
        CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)                                
        INITIALIZE g_fia.* TO NULL  #TQC-6B0105
        CLEAR FORM
        CALL g_fiw.clear()
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
    CALL q102_show()
END FUNCTION
 
FUNCTION q102_show()
  DEFINE l_fiw08_1     LIKE fiw_file.fiw08
  DEFINE l_fiw08_2     LIKE fiw_file.fiw08
 
   DISPLAY g_fia.fia01,g_fia.fia02,g_fia.fjb03,g_fia.ima02,
           g_fia.fiw04,g_fia.fiw05,g_fia.fiw06,g_fia.img09,
           g_fia.imk09,g_fia.img10
        TO fia01,fia02,fjb03,ima02,fiw04,fiw05,fiw06,img09,imk09,img10
 
   SELECT img10 INTO g_fia.img10 FROM img_file   #當前庫存
    WHERE img01=g_fia.fjb03 AND img02=g_fia.fiw04
      AND img03=g_fia.fiw05 AND img04=g_fia.fiw06
   IF cl_null(g_fia.img10) THEN LET g_fia.img10=0 END IF
   DISPLAY g_fia.img10 TO img10
 
   SELECT imk09 INTO g_fia.imk09 FROM imk_file   #起始日期上月結余
    WHERE imk01=g_fia.fjb03 AND imk02=g_fia.fiw04
      AND imk03=g_fia.fiw05 AND imk04=g_fia.fiw06
      AND imk05=g_yy        AND imk06=g_mm          
   IF cl_null(g_fia.imk09) THEN LET g_fia.imk09=0 END IF
 
   CALL q102_fiw08('1') RETURNING l_fiw08_1  #1~DAY(g_bdate)的fiw08發料數量
   IF cl_null(l_fiw08_1) THEN LET l_fiw08_1 = 0 END IF
 
   CALL q102_fiw08('2') RETURNING l_fiw08_2  #1~DAY(g_bdate)的fiw08退料數量
   IF cl_null(l_fiw08_2) THEN LET l_fiw08_2 = 0 END IF
 
   LET g_fia.imk09=g_fia.imk09 + l_fiw08_1 - l_fiw08_2
   DISPLAY g_fia.imk09 TO imk09
 
   CALL q102_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q102_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680072CHAR(500)
          l_c       LIKE cre_file.cre08,          #No.FUN-680072CHAR(10)
          l_imk09   LIKE imk_file.imk09
 
 
   LET l_sql =
        "SELECT fiv05,fiv00,fiv01,fiv02,fiw07,fiw07_fac,fiw08,0 ",
        "  FROM fiv_file,fiw_file,fil_file",
        " WHERE fil03 = '",g_fia.fia01,"'",
        "   AND fiv01 = fiw01 ",
        "   AND fiw03 = '",g_fia.fjb03,"'",
        "   AND fiw04 = '",g_fia.fiw04,"'",
        "   AND fiw05 = '",g_fia.fiw05,"'",
        "   AND fiw06 = '",g_fia.fiw06,"'",
        "   AND fiv02 = fil01 ",
        "   AND fiv05 >='",g_bdate,"'",
        " ORDER BY fiv05,fiv00,fiv01,fiv02 "
    PREPARE q102_pb FROM l_sql
    DECLARE q102_bcs CURSOR FOR q102_pb
 
    LET g_rec_b=0
    CALL g_fiw.clear()
    LET g_cnt = 1
    LET l_imk09 = g_fia.imk09
    FOREACH q102_bcs INTO g_fiw[g_cnt].* 
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        IF g_fiw[g_cnt].fiv00 = '2' THEN
           LET l_c = g_fiw[g_cnt].c
           LET g_fiw[g_cnt].c=g_fiw[g_cnt].b
           LET g_fiw[g_cnt].b=l_c
           LET g_fiw[g_cnt].d = l_imk09 + g_fiw[g_cnt].fiw08 * g_fiw[g_cnt].fiw07_fac
        ELSE
           LET g_fiw[g_cnt].d = l_imk09 - g_fiw[g_cnt].fiw08 * g_fiw[g_cnt].fiw07_fac
        END IF
 
        LET l_imk09 = g_fiw[g_cnt].d
 
        IF cl_null(g_fiw[g_cnt].d) THEN LET g_fiw[g_cnt].d=0 END IF
        IF cl_null(l_imk09) THEN LET l_imk09=0 END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_fiw TO s_fiw.* ATTRIBUTE(COUNT=g_rec_b)            #No.CHI-840065
   DISPLAY ARRAY g_fiw TO s_fiw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #No.CHI-840065 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                                                                                
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)
         END IF                            
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION previous
         CALL q102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
         END IF                            
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION jump 
         CALL q102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF                            
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION next
         CALL q102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF                            
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION last
         CALL q102_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF                            
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close                                                           
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
      ON IDLE g_idle_seconds                                                 
         CALL cl_on_idle()                                                   
         CONTINUE DISPLAY               
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q102_fiw08(p_chr) 
  DEFINE p_chr         LIKE type_file.chr1          #No.FUN-680072CHAR(1)
  DEFINE l_fiw08       LIKE fiw_file.fiw08
  DEFINE l_date        LIKE type_file.dat           #No.FUN-680072DATE
 
    LET l_date=MDY(MONTH(g_bdate),1,YEAR(g_bdate))
    SELECT SUM(fiw07_fac*fiw08) INTO l_fiw08
      FROM fiv_file,fiw_file,fil_file
     WHERE fil03 = g_fia.fia01
       AND fiv01 = fiw01
       AND fiw03 = g_fia.fjb03
       AND fiw04 = g_fia.fiw04
       AND fiw05 = g_fia.fiw05
       AND fiw06 = g_fia.fiw06
       AND fiv02 = fil01
       AND fiv05 >=l_date AND fiv05 < g_bdate
       AND fiv00 = p_chr
    IF cl_null(l_fiw08) THEN LET l_fiw08 =0 END IF
    RETURN l_fiw08
 
END FUNCTION
