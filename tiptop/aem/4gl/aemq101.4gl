# Prog. Version..: '5.30.06-13.03.28(00006)'     #
#
# Pattern name...: aemq101.4gl
# Descriptions...: 設備維修項目查詢作業    
# Date & Author..: 2004/07/27 by day
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-680072 06/08/24 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760207 07/06/28 By jamie 一執行會出現-404的錯誤
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-CB0202 12/11/23 By Elise 避免有更新不即時的情況
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    tm  RECORD
                wc      LIKE type_file.chr1000, #No.FUN-680072CHAR(500)
                wc1     LIKE type_file.chr1000  #No.FUN-680072CHAR(500)
        END RECORD,
    g_fia  RECORD
            fia01		LIKE fia_file.fia01,
            fia02		LIKE fia_file.fia02 
        END RECORD,
    g_bdate     LIKE type_file.dat,           #No.FUN-680072DATE
    g_flag      LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    g_fim   DYNAMIC ARRAY OF RECORD
            fim03   LIKE fim_file.fim03,
            fio02   LIKE fio_file.fio02,
            fim04   LIKE fim_file.fim04,
            fim05   LIKE fim_file.fim05,
            fim01   LIKE fim_file.fim01,
            fio05   LIKE fio_file.fio05,
            a1      LIKE type_file.chr20,       #No.FUN-680072CHAR(20)
            fio06   LIKE fio_file.fio06,
            fiu02   LIKE fiu_file.fiu02,
            fio07   LIKE fio_file.fio07,
            fja02   LIKE fja_file.fja02,
            fim06   LIKE fim_file.fim06,
            fim07   LIKE fim_file.fim07,
            fim08   LIKE fim_file.fim08,
            fim09   LIKE fim_file.fim09,
            fim10   LIKE fim_file.fim10,
            fim11   LIKE fim_file.fim11  
        END RECORD,
    g_argv1         LIKE fia_file.fia01,    
    g_query_flag    LIKE type_file.num5,       #第一次進入程式時即進入Query之後進入N.下筆 #No.FUN-680072SMALLINT
    g_sql           STRING,      #No.FUN-580092 HCN
    i               LIKE type_file.num10,       #No.FUN-680072INTEGER
    g_rec_b         LIKE type_file.num5         #單身筆數        #No.FUN-680072 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680072 SMALLINT
DEFINE g_cnt        LIKE type_file.num10        #No.FUN-680072 INTEGER
DEFINE g_msg        LIKE type_file.chr1000,     #No.FUN-680072CHAR(72)
       l_ac         LIKE type_file.num5         #No.FUN-680072 SMALLINT
DEFINE g_jump       LIKE type_file.num10        #No.FUN-680072 INTEGER
                                                                                
DEFINE mi_no_ask    LIKE type_file.num5         #No.FUN-680072 SMALLINT
DEFINE g_row_count  LIKE type_file.num10        #No.FUN-680072 INTEGER
                                                                                
DEFINE g_curs_index LIKE type_file.num10        #No.FUN-680072 INTEGER
 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0068
 
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
 
 OPEN WINDOW q101_w AT p_row,p_col
        WITH FORM "aem/42f/aemq101"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL q101_menu()    #中文
    CLOSE WINDOW q101_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION q101_curs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680072 SMALLINT
 
  IF g_argv1 != ' '                                                            
      THEN LET tm.wc = "fia01 = '",g_argv1,"'"                                  
      ELSE CLEAR FORM 
           CALL g_fim.clear() 
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL		
           CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fia.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON fia01,fim03,fim04,fim05,fim01
 
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
              #"   FROM fia_file, OUTER fim_file, OUTER fil_file",   #TQC-760207 mark
"   FROM fia_file, fim_file LEFT OUTER JOIN fil_file ON fil_file.fil01=fim_file.fim01 ",
"   WHERE fia_file.fia01 = fil_file.fil03 ",
               "    AND ",tm.wc  CLIPPED,
               "  ORDER BY fia01,fia02"
    PREPARE q101_prepare FROM g_sql
    DECLARE q101_cs                         #SCROLL CURSOR
            SCROLL CURSOR FOR q101_prepare
 
    # 取合乎條件筆數
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
      LET g_sql=" SELECT COUNT(UNIQUE fia01) ",
                " FROM fia_file,fim_file LEFT OUTER JOIN fil_file ON fil_file.fil01 = fim_file.fim01 ",
                " WHERE fia01 =fil03 ",
               "   AND ",tm.wc  CLIPPED 
    PREPARE q101_pp  FROM g_sql
    DECLARE q101_cnt   CURSOR FOR q101_pp
END FUNCTION
 
FUNCTION q101_menu()
    WHILE TRUE
      CALL q101_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q101_q()
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
 
FUNCTION q101_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )                    
    MESSAGE ""      
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL q101_curs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    OPEN q101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
          OPEN q101_cnt
          FETCH q101_cnt INTO g_row_count
          DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
          CALL q101_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q101_cs INTO g_fia.fia01,
                                             g_fia.fia02
        WHEN 'P' FETCH PREVIOUS q101_cs INTO g_fia.fia01,
                                             g_fia.fia02
        WHEN 'F' FETCH FIRST    q101_cs INTO g_fia.fia01,
                                             g_fia.fia02
        WHEN 'L' FETCH LAST     q101_cs INTO g_fia.fia01,
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
            FETCH ABSOLUTE g_jump q101_cs INTO g_fia.fia01,
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
    CALL q101_show()
END FUNCTION
 
FUNCTION q101_show()
 
   DISPLAY g_fia.fia01,g_fia.fia02
        TO fia01,fia02
   CALL q101_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q101_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000         #No.FUN-680072CHAR(2000) #TQC-840066
 
 
   LET l_sql =
        "SELECT fim03,fio02,fim04,fim05,fim01,fio05,'',fio06,fiu02, ",
        "       fio07,fja02,fim06,fim07,fim08,fim09,fim10,fim11 ",
        "  FROM fim_file LEFT OUTER JOIN fil_file ON fim_file.fim01=fil_file.fil01 ",
        "  LEFT OUTER JOIN fio_file ON fim_file.fim03 = fio_file.fio01 ",
        "  LEFT OUTER JOIN fiu_file ON fiu_file.fiu01 = fio_file.fio06 ",
        "  LEFT OUTER JOIN fja_file ON fja_file.fja01 = fio_file.fio07 ",
        " WHERE fil03 = '",g_fia.fia01,"'",
#        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY fim03,fim01 "
    PREPARE q101_pb FROM l_sql
    DECLARE q101_bcs                       #BODY CURSOR
        CURSOR FOR q101_pb
 
    LET g_rec_b=0
    CALL g_fim.clear()
 
    LET g_cnt = 1
    FOREACH q101_bcs INTO g_fim[g_cnt].* 
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    CASE g_fim[g_cnt].fio05                                                     
       WHEN  '1' CALL cl_getmsg('aem-023',g_lang) RETURNING g_fim[g_cnt].a1   
       WHEN  '2' CALL cl_getmsg('axd-051',g_lang) RETURNING g_fim[g_cnt].a1   
    END CASE        
 
        LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_fim.deleteElement(g_cnt)      
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2     
END FUNCTION
 
FUNCTION q101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  #DISPLAY ARRAY g_fim TO s_fim.* ATTRIBUTE(COUNT=g_rec_b)             #MOD-CB0202 mark
   DISPLAY ARRAY g_fim TO s_fim.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-CB0202
      BEFORE DISPLAY                                                            
                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL q101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF              
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q101_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
