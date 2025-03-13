# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: afap900.4gl
# Descriptions...: 抵押資產銀行標籤維護作業
# Date & Author..: 96/06/12 By Star  
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     tm  RECORD
         	wc  	LIKE type_file.chr1000,		# Head Where condition       #No.FUN-680070 VARCHAR(1000)
        	wc2  	LIKE type_file.chr1000		# Body Where condition       #No.FUN-680070 VARCHAR(1000)
        END RECORD,
    g_fcd  RECORD
            fcd01               LIKE fcd_file.fcd01,
            fcd06               LIKE fcd_file.fcd06
        END RECORD,
    g_fce DYNAMIC ARRAY OF RECORD
            fce02		LIKE fce_file.fce02, 
            fce03		LIKE fce_file.fce03, 
            fce031		LIKE fce_file.fce031, 
            faj04		LIKE faj_file.faj04, 
            faj49		LIKE faj_file.faj49, 
            faj20		LIKE faj_file.faj20, 
            fce05		LIKE fce_file.fce05, 
            fce08		LIKE fce_file.fce08
        END RECORD,
 
    g_argv1         LIKE fcd_file.fcd01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next       #No.FUN-680070 SMALLINT
     g_wc,g_wc2,g_sql string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10,   #單身筆數       #No.FUN-680070 INTEGER
    l_ac,l_sl       LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0069
 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag=1
 
    OPEN WINDOW p900_w WITH FORM "afa/42f/afap900" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
IF NOT cl_null(g_argv1) THEN CALL p900_q() END IF
    CALL p900_menu()
    CLOSE WINDOW p900_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
END MAIN
 
FUNCTION p900_cs()
   DEFINE   l_cnt   LIKE type_file.num5          #No.FUN-680070 SMALLINT
 
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "fcd01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
   CALL g_fce.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL	            # Default condition
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
      INPUT BY NAME g_fcd.fcd01,g_fcd.fcd06 WITHOUT DEFAULTS 
       ON ACTION locale
#            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()   #FUN-550037(smin)
             LET g_action_choice = "locale"
             EXIT INPUT     
 
         AFTER FIELD fcd01 
            IF cl_null(g_fcd.fcd01) THEN 
               NEXT FIELD fcd01
            END IF 
            SELECT fcd06 INTO g_fcd.fcd06 FROM fcd_file 
             WHERE fcd01 = g_fcd.fcd01
               AND fcdconf = 'Y'
            IF SQLCA.sqlcode  THEN 
#              CALL cl_err('not found . ',STATUS,0)   #No.FUN-660136
               CALL cl_err3("sel","fcd_file",g_fcd.fcd01,"",STATUS,"","not found . ",0)   #No.FUN-660136
               NEXT FIELD fcd01 
            END IF 
            DISPLAY BY NAME g_fcd.fcd06  
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(fcd01) #申請單號
#                 CALL q_fcd(4,3,g_fcd.fcd01,g_fcd.fcd06) 
#                 RETURNING g_fcd.fcd01,g_fcd.fcd06
#                 CALL FGL_DIALOG_SETBUFFER( g_fcd.fcd01 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fcd.fcd06 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fcd"
                  LET g_qryparam.default1 = g_fcd.fcd01
                  LET g_qryparam.default2 = g_fcd.fcd06
                  CALL cl_create_qry() RETURNING g_fcd.fcd01,g_fcd.fcd06
#                  CALL FGL_DIALOG_SETBUFFER( g_fcd.fcd01 )
#                  CALL FGL_DIALOG_SETBUFFER( g_fcd.fcd06 )
                  DISPLAY g_fcd.fcd01,g_fcd.fcd06 TO fcd01,fcd06 
                  NEXT FIELD fcd01
               OTHERWISE
                  EXIT CASE
            END CASE
      
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
 
      
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
 
      END INPUT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         RETURN        
      END IF
 
      LET tm.wc = " fcd01 = '",g_fcd.fcd01,"'"
      #CALL p900_b_askkey()
      IF INT_FLAG THEN
         RETURN 
      END IF
   END IF
 
   MESSAGE ' WAIT ' 
   LET g_sql=" SELECT fcd01 FROM fcd_file ",
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY fcd01"
   PREPARE p900_prepare FROM g_sql
   DECLARE p900_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR p900_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(*) FROM fcd_file ",
             " WHERE ",tm.wc CLIPPED
   PREPARE p900_pp  FROM g_sql
   DECLARE p900_cnt   CURSOR FOR p900_pp
END FUNCTION
 
{
FUNCTION p900_b_askkey()
   CONSTRUCT tm.wc2 ON fce02,fce03,fce031,faj04,faj49,faj20,fce05,fce08
                  FROM s_fce[1].fce02,s_fce[1].fce03,s_fce[1].fce031,
                       s_fce[1].faj04,s_fce[1].faj49,s_fce[1].faj20,
                       s_fce[1].fce05,s_fce[1].fce08
       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
  
  END CONSTRUCT
  LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
END FUNCTION
}
 
#中文的MENU
FUNCTION p900_menu()
   WHILE TRUE
      CALL p900_bp("G")
      CASE g_action_choice
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p900_q()
            END IF
           WHEN "bank_label"
              IF cl_chk_act_auth() THEN
                 CALL p900_b()
              END IF
           WHEN "batch_generate"
              IF cl_chk_act_auth() THEN
                 CALL p900_g()
              END IF
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "controlg"   #KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p900_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL p900_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN p900_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN p900_cnt
       FETCH p900_cnt INTO g_cnt
       DISPLAY g_cnt TO cnt  
       CALL p900_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION p900_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p900_cs INTO g_fcd.fcd01
        WHEN 'P' FETCH PREVIOUS p900_cs INTO g_fcd.fcd01
        WHEN 'F' FETCH FIRST    p900_cs INTO g_fcd.fcd01
        WHEN 'L' FETCH LAST     p900_cs INTO g_fcd.fcd01
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso p900_cs INTO g_fcd.fcd01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)
        INITIALIZE g_fcd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
	SELECT fcd01,fcd06
	  INTO g_fcd.*
	  FROM fcd_file
	 WHERE fcd01 = g_fcd.fcd01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)  #No.FUN-660136
        CALL cl_err3("sel","fcd_file",g_fcd.fcd01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660136
        RETURN
    END IF
 
    CALL p900_show()
END FUNCTION
 
FUNCTION p900_show()
   #No.FUN-9A0024--begin  
   #DISPLAY BY NAME g_fcd.*   # 顯示單頭值
   DISPLAY BY NAME g_fcd.fcd01,g_fcd.fcd06
    #No.FUN-9A0024--end 
   CALL p900_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p900_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680070 VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT fce02,fce03,fce031,faj04,faj49,faj20,fce05,fce08 ",
        "  FROM fce_file,faj_file ",
        " WHERE fce01 = '",g_fcd.fcd01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND fce03 = faj02 ",
        "   AND fce031= faj022 ",
        " ORDER BY fce02"
    PREPARE p900_pb FROM l_sql
    DECLARE p900_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR p900_pb
 
    CALL g_fce.clear()
    LET g_cnt = 1
    FOREACH p900_bcs INTO g_fce[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_fce[g_cnt].fce05 IS NULL THEN LET g_fce[g_cnt].fce05 = 0 END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fce.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2  
END FUNCTION
 
FUNCTION p900_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "bank_label" THEN
       RETURN
    END IF
 
    LET g_action_choice = " "
    
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_fce TO s_fce.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION query       LET g_action_choice="query"      EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
        ON ACTION exit        LET g_action_choice="exit"       EXIT DISPLAY
 
      ON ACTION bank_label
         LET g_action_choice = "bank_label"
         EXIT DISPLAY
 
      ON ACTION batch_generate
         LET g_action_choice="batch_generate"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="bank_label"
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
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
 
FUNCTION p900_b()
    CALL cl_opmsg('b')
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    LET g_action_choice = ""
 
    INPUT ARRAY g_fce WITHOUT DEFAULTS FROM s_fce.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED)   #TQC-630104
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
        BEFORE ROW
            LET l_ac = ARR_CURR() 
            CALL p900_faj()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fce08
        AFTER ROW
            IF NOT cl_null(g_fce[l_ac].fce03) THEN
               UPDATE fce_file SET fce08 = g_fce[l_ac].fce08
                  WHERE fce01=g_fcd.fcd01 AND fce03=g_fce[l_ac].fce03
                    AND fce031=g_fce[l_ac].fce031
               IF STATUS THEN 
#                 CALL cl_err('upd fce',STATUS,0)    #No.FUN-660136
                  CALL cl_err3("upd","fce_file",g_fcd.fcd01,g_fce[l_ac].fce03,STATUS,"","upd fce",0)   #No.FUN-660136
               END IF
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
    END INPUT
END FUNCTION
 
FUNCTION p900_faj()
    SELECT faj04,faj49,faj20
      INTO g_fce[l_ac].faj04, g_fce[l_ac].faj49, g_fce[l_ac].faj20
      FROM faj_file
     WHERE faj02 = g_fce[l_ac].fce03
       AND faj022= g_fce[l_ac].fce031
   DISPLAY g_fce[l_ac].* TO s_fce[l_sl].*     
END FUNCTION
 
FUNCTION p900_g()             # G. 自動產生..單身資料
   DEFINE   l_ax,l_az   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_sql                   LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(500)
            l_wc                    RECORD
            begin                   LIKE type_file.num10,             #No.FUN-680070 DEC(10,0)
            endno                   LIKE type_file.num10,        #No.FUN-680070 DEC(10,0)
            s                       LIKE type_file.chr1          #No.FUN-680070 VARCHAR(1)
                                    END RECORD,
            l_fce                   RECORD
            fce03                   LIKE fce_file.fce03, 
            fce031                  LIKE fce_file.fce031, 
            faj20                   LIKE faj_file.faj20, 
            fce05                   LIKE fce_file.fce05, 
            fce08                   LIKE fce_file.fce08
                                    END RECORD
 
   OPEN WINDOW p900_g WITH FORM "afa/42f/afap900s" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("afap900s")
   #資料權限的檢查
   INPUT BY NAME l_wc.begin,l_wc.endno,l_wc.s WITHOUT DEFAULTS 
 
      AFTER FIELD begin 
         IF cl_null(l_wc.begin) THEN
            NEXT FIELD begin
         END IF 
    
      AFTER FIELD endno 
         IF cl_null(l_wc.endno) THEN
            NEXT FIELD endno
         END IF 
    
      AFTER FIELD s
         IF cl_null(l_wc.s) OR l_wc.s NOT MATCHES '[1-2]' THEN 
            NEXT FIELD s
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
 
   IF INT_FLAG THEN
      LET INT_FLAG=0 
      CLOSE WINDOW p900_g RETURN
   END IF
   IF l_wc.s = '1' THEN 
      LET l_sql = "SELECT fce03,fce031,faj20,fce05,fce08 ",
                  "  FROM fce_file,faj_file ",
                  " WHERE fce01 = '", g_fcd.fcd01,"'",
                  "   AND fce03 = faj02 ",
                  "   AND fce031= faj022 ",
                  " ORDER BY fce05 DESC "
   ELSE
      LET l_sql = "SELECT fce03,fce031,faj20,fce05,fce08 ",
                  "  FROM fce_file,faj_file ",
                  " WHERE fce01 = '", g_fcd.fcd01,"'",
                  "   AND fce03 = faj02 ",
                  "   AND fce031= faj022 ",
                  " ORDER BY fce03,fce031 "
   END IF 
   PREPARE p900_pg FROM l_sql 
   DECLARE p900_g_c CURSOR FOR p900_pg
   CALL p900_create_temp1()
   LET l_ax = (l_wc.endno - l_wc.begin) + 1
   LET l_az = 1     
   FOREACH p900_g_c INTO l_fce.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH 
      END IF
      INSERT INTO b1_temp VALUES(l_fce.*)
      IF l_az = l_ax THEN
         EXIT FOREACH
      END IF 
      LET l_az = l_az + 1
   END FOREACH
   DECLARE p900_g_curx CURSOR FOR 
    SELECT * FROM b1_temp 
     ORDER BY faj20                   
   FOREACH p900_g_curx INTO l_fce.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)    
         EXIT FOREACH 
      END IF
      UPDATE fce_file SET fce08 = l_wc.begin 
       WHERE fce03 = l_fce.fce03 AND fce031 = l_fce.fce031
         AND fce01 = g_fcd.fcd01
      IF l_wc.begin = l_wc.endno  THEN
         EXIT FOREACH
      END IF 
      LET l_wc.begin = l_wc.begin + 1
   END FOREACH
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
   END IF
   CLOSE WINDOW p900_g  
   CALL p900_b_fill()       # 單身
 
END FUNCTION
 
FUNCTION p900_create_temp1()
   DROP TABLE b1_temp
#No.FUN-680070  -- begin --
#   CREATE TEMP TABLE b1_temp(
#     fce03  VARCHAR(10),
#     fce031 VARCHAR(4),
#     faj20  VARCHAR(8),
#     fce05  dec(20,6),
#     fce08  VARCHAR(10));
   CREATE TEMP TABLE b1_temp(
     fce03  LIKE fce_file.fce03,
     fce031 LIKE fce_file.fce031,
     faj20  LIKE faj_file.faj20,
     fce05  LIKE fce_file.fce05,
     fce08  LIKE fce_file.fce08);
#No.FUN-680070  -- end --
END FUNCTION
 
