# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aemq100.4gl
# Descriptions...: 設備歷史記錄查詢作業 
# Date & Author..: 2004/07/27 by day
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-680072 06/08/24 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    tm  RECORD
                wc      LIKE type_file.chr1000, #No.FUN-680072CHAR(500)
                wc1     LIKE type_file.chr1000  #No.FUN-680072CHAR(500)
        END RECORD,
    g_fia  RECORD
            fia01	LIKE fia_file.fia01, # 料件編號
            fia02	LIKE fia_file.fia02  # 倉庫編號
        END RECORD,
    g_bdate     LIKE type_file.dat,           #No.FUN-680072DATE
    g_flag      LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    g_fil   DYNAMIC ARRAY OF RECORD
            fil01   LIKE fil_file.fil01,
            fil02   LIKE fil_file.fil02,
            fil00   LIKE fil_file.fil00,
            desc    LIKE type_file.chr8,      #No.FUN-680072CHAR(10)
            fil04   LIKE fil_file.fil04,  
            fje02   LIKE fje_file.fje02,
            fil05   LIKE fil_file.fil05,
            d5      LIKE cre_file.cre08,      #No.FUN-680072CHAR(10)
            fil06   LIKE fil_file.fil06,
            fil10   LIKE fil_file.fil10,
            fil11   LIKE fil_file.fil11,
            fil12   LIKE fil_file.fil12,
            fil13   LIKE fil_file.fil13,
            fil14   LIKE fil_file.fil14,
            fil141  LIKE fil_file.fil141,
            fil15   LIKE fil_file.fil15, 
            fil151  LIKE fil_file.fil151,
            c       LIKE fim_file.fim09,      #No.FUN-680072DEC(8,3)
            fil16   LIKE fil_file.fil16,
            fia12   LIKE fia_file.fia12,
            fil17   LIKE fil_file.fil17,
            fil18   LIKE fil_file.fil18,
            fil19   LIKE fil_file.fil19,
            fil20   LIKE fil_file.fil20
        END RECORD,
    g_argv1         LIKE fia_file.fia01,    
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入N.下筆   #No.FUN-680072SMALLINT
    g_sql           STRING,    #No.FUN-580092 HCN 
    i               LIKE type_file.num10,     #No.FUN-680072INTEGER
    g_rec_b         LIKE type_file.num5       #單身筆數        #No.FUN-680072 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_cnt         LIKE type_file.num10                                                         #No.FUN-680072 INTEGER
DEFINE   g_msg         LIKE type_file.chr1000,                                                     #No.FUN-680072CHAR(72)
         l_ac          LIKE type_file.num5                 #No.FUN-680072 SMALLINT
DEFINE   g_jump        LIKE type_file.num10                                                         #No.FUN-680072 INTEGER
                                                                                
DEFINE   mi_no_ask     LIKE type_file.num5                  #No.FUN-680072 SMALLINT
DEFINE   g_row_count   LIKE type_file.num10                                                         #No.FUN-680072 INTEGER
                                                                                
DEFINE   g_curs_index  LIKE type_file.num10         #No.FUN-680072 INTEGER
 
 
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
    LET g_argv1      = ARG_VAL(1)   
    #FUN-570250 mark
    #LET g_msg=g_today USING 'yy/mm/dd'
    #LET g_bdate=DATE(g_msg)
    #FUN-570250 add 
    LET g_bdate=g_today
    #FUN-570250 end 
    LET g_query_flag=1
       LET p_row = 3 LET p_col = 6
 
 OPEN WINDOW q100_w AT p_row,p_col
        WITH FORM "aem/42f/aemq100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL q100_menu()    #中文
    CLOSE WINDOW q100_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION q100_curs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680072 SMALLINT
 
  IF g_argv1 != ' '                                                            
      THEN LET tm.wc = "fia01 = '",g_argv1,"'"                                  
      ELSE 
           CLEAR FORM 
           CALL g_fil.clear() 
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL	
           CALL cl_set_head_visible("","YES")    #No.FUN-6B0029	
   INITIALIZE g_fia.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON fia01,fil01
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
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
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fiauser', 'fiagrup') #FUN-980030
 
           IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
  END IF  
 
    LET g_sql= " SELECT UNIQUE fia01,fia02 ",
               "   FROM fia_file, fil_file ",
               "  WHERE fia01 = fil03 ",
               "    AND ",tm.wc  CLIPPED,
               "  ORDER BY fia01,fia02"
    PREPARE q100_prepare FROM g_sql
    DECLARE q100_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q100_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(UNIQUE fia01) FROM fia_file,fil_file ",
               " WHERE fia01 = fil03 ",
               "   AND ",tm.wc  CLIPPED 
    PREPARE q100_pp  FROM g_sql
    DECLARE q100_cnt   CURSOR FOR q100_pp
END FUNCTION
 
 
FUNCTION q100_menu()
    WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q100_q()
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
 
FUNCTION q100_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""      
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q100_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
          OPEN q100_cnt
          FETCH q100_cnt INTO g_row_count
          DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
          CALL q100_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q100_cs INTO g_fia.fia01,
                                             g_fia.fia02
        WHEN 'P' FETCH PREVIOUS q100_cs INTO g_fia.fia01,
                                             g_fia.fia02
        WHEN 'F' FETCH FIRST    q100_cs INTO g_fia.fia01,
                                             g_fia.fia02
        WHEN 'L' FETCH LAST     q100_cs INTO g_fia.fia01,
                                             g_fia.fia02
        WHEN '/'
        IF NOT(mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds                                           
                  CALL cl_on_idle()                                             
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
            FETCH ABSOLUTE g_jump q100_cs INTO g_fia.fia01,
                                               g_fia.fia02
            LET mi_no_ask = FALSE    
    END CASE
 
 
    IF SQLCA.sqlcode THEN                                                       
        CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)                                
        INITIALIZE g_fia.* TO NULL  #TQC-6B0105
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
    CALL q100_show()
END FUNCTION
 
FUNCTION q100_show()
 
   DISPLAY g_fia.fia01,g_fia.fia02
        TO fia01,fia02
   CALL q100_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q100_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,        #No.FUN-680072CHAR(2000)
          l_c       LIKE fim_file.fim09            #No.FUN-680072DECIMAL(8,3) #TQC-840066
 
 
   LET l_sql =
        "SELECT fil01,fil02,fil00,'',fil04,fje02,fil05,'',fil06,fil10, ",
        "       fil11,fil12,fil13,fil14,fil141,fil15,fil151,'',fil16,fia12, ",
        "       fil17,fil18,fil19,fil20 ",
        "  FROM fil_file LEFT OUTER JOIN fia_file ON fil_file.fil03=fia_file.fia01  LEFT OUTER JOIN fje_file ON fil_file.fil04=fje_file.fje01 ",
        " WHERE fil03 = '",g_fia.fia01,"'",
#        "   AND fil16 = fia
        " ORDER BY fil01 "
    PREPARE q100_pb FROM l_sql
    DECLARE q100_bcs                       #BODY CURSOR
        CURSOR FOR q100_pb
 
    LET g_rec_b=0
    CALL g_fil.clear()
 
    LET g_cnt = 1
    FOREACH q100_bcs INTO g_fil[g_cnt].* 
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    CASE g_fil[g_cnt].fil00                                                     
       WHEN  '1' CALL cl_getmsg('aem-023',g_lang) RETURNING g_fil[g_cnt].desc   
       WHEN  '2' CALL cl_getmsg('axd-051',g_lang) RETURNING g_fil[g_cnt].desc   
    END CASE                   
    CASE g_fil[g_cnt].fil05                                                     
       WHEN  '1' CALL cl_getmsg('aem-010',g_lang) RETURNING g_fil[g_cnt].d5   
       WHEN  '2' CALL cl_getmsg('aem-011',g_lang) RETURNING g_fil[g_cnt].d5   
       WHEN  '3' CALL cl_getmsg('aem-012',g_lang) RETURNING g_fil[g_cnt].d5   
       WHEN  '4' CALL cl_getmsg('aem-013',g_lang) RETURNING g_fil[g_cnt].d5   
       WHEN  '5' CALL cl_getmsg('aem-016',g_lang) RETURNING g_fil[g_cnt].d5   
    END CASE      
       SELECT SUM(fim09) INTO l_c                                               
       FROM fim_file,fil_file                                                   
        WHERE fil03 = g_fia.fia01                                               
          AND fil01 = fim01                                                     
          AND fim08 = 'Y'     
       LET g_fil[g_cnt].c = l_c                                                 
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_fil.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt=0
END FUNCTION
 
FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fil TO s_fil.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY                                                            
                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL q100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
