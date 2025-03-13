# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aooq040.4gl
# Descriptions...: 單據異動記錄查詢
# Date & Author..: 96/03/20 By Roger
# Modify.........: No.MOD-490445 04/09/24 By Yuna 修改可以按右上角(X)關閉程式
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能	
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-850032 08/05/07 By mike gaq_file代替原來的zq_file,gaq03代替zq04,
#                                                 show()CALL b_fill()
# Modify.........: No.FUN-850016 08/05/08 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.TQC-850036 08/07/07 By sherry 查詢出有資料來,但是總筆數顯示為0
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-960351 09/07/02 By Dido 語法調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A80139 10/08/19 By Dido b_fill 段取消呼叫 q040_bp 
# Modify.........: No.MOD-B40109 11/04/18 By sabrina 變更上下筆數時單頭資料會變，但單身不會變
# Modify.........: No.MOD-B40230 11/04/25 By sabrina 查詢後，若無此筆資料，單身沒有清空
# Modify.........: No.TQC-C10115 12/01/31 31區rebuild的結果錯誤排除,ltype > acttype
# Modify.........: No.TQC-C20135 12/02/13 將acttype改為ltype
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     tm  RECORD
        	wc  	LIKE type_file.chr1000,        #No.FUN-680102CHAR(1000),		# Head Where condition
        	wc2  	LIKE type_file.chr1000         #No.FUN-680102 VARCHAR(1000)		# Body Where condition
        END RECORD,
    g_hed   RECORD
		tab 	LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
		key1	LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
		key2	LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
		key3	LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
		key4	LIKE type_file.chr50           #No.FUN-680102CHAR(40)
        END RECORD,
    #No.FUN-850032  --BEGIN
    {b_log DYNAMIC ARRAY OF RECORD
            col		LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
            colname	LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
            date	DATETIME MONTH TO MINUTE,
            user	LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
            type	LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
            old_val	LIKE type_file.chr50,          #No.FUN-680102CHAR(40),
            new_val	LIKE type_file.chr50           #No.FUN-680102CHAR(40)
        END RECORD,}
    b_log DYNAMIC ARRAY OF RECORD   
           col          LIKE log_file.col,
           colname      LIKE gaq_file.gaq03,
           date         LIKE log_file.ldate,
           user         LIKE log_file.luser,
           type         LIKE log_file.ltype,   #TQC-C10115 mark  #TQC-C20135
           #type         LIKE log_file.acttype,  #TQC-C10115 #TQC-C20135 mark
           old_val      LIKE log_file.old_val,
           new_val      LIKE log_file.new_val
        END RECORD,
    #No.FUN-850032  --END
    g_argv1         LIKE log_file.key1,
    g_argv2         LIKE log_file.key2,
    g_argv3         LIKE log_file.key3,
    g_argv4         LIKE log_file.key4,
    g_query_flag    LIKE type_file.num5,           #No.FUN-680102SMALINT #第一次進入程式時即進入Query之後進入next
    #No.FUN-850032  --begin
    #No.FUN-850032  --end
     g_wc,g_wc2,g_sql STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10          #No.FUN-680102	INTEGER  #單身筆數
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680102CHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   g_str          STRING                       #No.FUN-850016   
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0081
   DEFINE l_sl		LIKE type_file.num5           #No.FUN-680102SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag = 1
    LET p_row        = 3
    LET p_col        = 2
 
    OPEN WINDOW q040_w AT p_row,p_col
        WITH FORM "aoo/42f/aooq040"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_argv1<>' ' THEN CALL q040_q() END IF
    CALL q040_menu()
    CLOSE WINDOW q040_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION q040_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "key1 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN LET tm.wc=" AND key2 = '",g_argv2,"'" END IF
      IF NOT cl_null(g_argv3) THEN LET tm.wc=" AND key3 = '",g_argv3,"'" END IF
      IF NOT cl_null(g_argv4) THEN LET tm.wc=" AND key4 = '",g_argv4,"'" END IF
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL      # Default condition
   INITIALIZE g_hed.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON tab,key1,key2,key3,key4
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      CALL q040_b_askkey()
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
  #LET g_sql=" SELECT UNIQUE tab,key1,key2,key3,key4 FROM log_file ",	#MOD-960351 mark
   LET g_sql=" SELECT UNIQUE tab,key1,key2,key3,key4 FROM log_file ",		#MOD-960351
             " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
             " ORDER BY tab,key1,key2,key3,key4"
   PREPARE q040_prepare FROM g_sql
  #DECLARE q040_cs SCROLL CURSOR FOR q040_prepare		#MOD-960351 mark
   DECLARE q040_cs SCROLL CURSOR WITH HOLD FOR q040_prepare	#MOD-960351
 
  #LET g_sql=" SELECT COUNT(UNIQUE key1) FROM log_file ",		#MOD-960351 mark
   LET g_sql=" SELECT UNIQUE tab,key1,key2,key3,key4 FROM log_file ",	#MOD-960351
              " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED
   PREPARE q040_pp  FROM g_sql
  #DECLARE q040_count   CURSOR FOR q040_pp		#MOD-960351 mark
   DECLARE q040_count   CURSOR WITH HOLD FOR q040_pp	#MOD-960351
END FUNCTION
 
FUNCTION q040_b_askkey()
   CONSTRUCT tm.wc2 ON col,date,user,type
                  FROM s_log[1].col,s_log[1].date,
                       s_log[1].user,s_log[1].type
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
END FUNCTION
 
#中文的MENU
 
FUNCTION q040_menu()
 
   WHILE TRUE
      CALL q040_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q040_q()
            END IF
         WHEN "output"
            CALL q040_out()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "cancel"   #No.MOD-490445
            EXIT WHILE
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hed),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q040_q()
DEFINE l_tmp VARCHAR(01)	#MOD-960351
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CLEAR FORM              #MOD-B40230 add 
    CALL b_log.clear()      #MOD-B40230 add
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q040_cs()
   #-MOD-960351-add-
    OPEN q040_count
    LET g_row_count = 0 
    FOREACH q040_count INTO l_tmp,l_tmp,l_tmp,l_tmp,l_tmp
       LET g_row_count = g_row_count + 1
    END FOREACH 
    DISPLAY g_row_count TO FORMONLY.cnt
   #-MOD-960351-end-
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q040_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
      #-MOD-960351-add-
      #OPEN q040_count
       #FETCH q040_cs INTO g_row_count     #TQC-850036     
      #FETCH q040_count INTO g_row_count   #TQC-850036 
      #DISPLAY g_row_count TO FORMONLY.cnt
      #-MOD-960351-end-
       CALL q040_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q040_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680102 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q040_cs INTO g_hed.tab,g_hed.key1,g_hed.key2,g_hed.key3,g_hed.key4 #	#MOD-960351 mark
        WHEN 'P' FETCH PREVIOUS q040_cs INTO g_hed.tab,g_hed.key1,g_hed.key2,g_hed.key3,g_hed.key4 #	#MOD-960351 mark
        WHEN 'F' FETCH FIRST    q040_cs INTO g_hed.tab,g_hed.key1,g_hed.key2,g_hed.key3,g_hed.key4 #	#MOD-960351 mark
        WHEN 'L' FETCH LAST     q040_cs INTO g_hed.tab,g_hed.key1,g_hed.key2,g_hed.key3,g_hed.key4 #	#MOD-960351 mark
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q040_cs INTO g_hed.tab,g_hed.key1,g_hed.key2,g_hed.key3,g_hed.key4 #	#MOD-960351 mark
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hed.key1,SQLCA.sqlcode,0)
        INITIALIZE g_hed.* TO NULL  #TQC-6B0105
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
 
    CALL q040_show()
END FUNCTION
 
FUNCTION q040_show()
   DISPLAY BY NAME g_hed.*
   CALL q040_b_fill()                        #No.FUN-850032
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q040_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680102CHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        #No.FUN-850032  --BEGIN
        #"SELECT col,zq04,date,log_file.user,type,old_val,new_val",
        #"  FROM log_file,OUTER zq_file",
        "SELECT col,gaq03,ldate,luser,ltype,old_val,new_val",   #TQC-C10115 ltype > acctype  #TQC-C20135  acctype > ltype
        " FROM log_file LEFT OUTER JOIN gaq_file ON col=gaq01 AND gaq02='",g_lang,"' ",
        #No.FUN-850032  --end
        " WHERE tab ='",g_hed.tab,"'",
        "   AND key1='",g_hed.key1,"' AND ",tm.wc2 CLIPPED
        #"   AND col=zq_file.zq01 AND zq02='",g_lang,"' AND zq03=0"  #No.FUN-850032
   IF g_hed.key2 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED, " AND key2='",g_hed.key2,"'"
   END IF
   IF g_hed.key3 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED, " AND key3='",g_hed.key3,"'"
   END IF
   IF g_hed.key4 IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED, " AND key4='",g_hed.key4,"'"
   END IF
   #LET l_sql = l_sql CLIPPED, " ORDER BY col,date" #No.FUN-850032
   LET l_sql = l_sql CLIPPED, " ORDER BY col,ldate"  #No.FUN-850032  
    PREPARE q040_pb FROM l_sql
    #DECLARE q040_bcs CURSOR WITH HOLD FOR q040_pb  #No.FUN-850032
    DECLARE q040_bcs CURSOR FOR q040_pb  #No.FUN-850032      
 
    FOR g_cnt = 1 TO b_log.getLength()           #單身 ARRAY 乾洗
       INITIALIZE b_log[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q040_bcs INTO b_log[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
   #CALL  q040_bp('G')	#MOD-960351     #MOD-A80139
END FUNCTION
 
FUNCTION q040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  #DISPLAY ARRAY b_log TO s_log.*               #MOD-B40109 mark
   DISPLAY ARRAY b_log TO s_log.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)     #MOD-B40109 add
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q040_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q040_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q040_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q040_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q040_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
       #No.MOD-490445
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="cancel"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q040_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(40)
        sr	RECORD
            	tab	LIKE type_file.chr3,           #No.FUN-680102CHAR(3),
            	key1	LIKE log_file.key1,            #No.FUN-680102CHAR(20),  
            	key2	LIKE log_file.key2,            #No.FUN-680102CHAR(20),  
            	key3	LIKE log_file.key3,            #No.FUN-680102CHAR(20),  
            	key4	LIKE log_file.key4,            #No.FUN-680102CHAR(20),  
            	col	LIKE log_file.col,             #No.FUN-680102CHAR(08),
 
            	colname	LIKE type_file.chr50,         #No.FUN-680102CHAR(40),
            	date	DATETIME MONTH TO MINUTE,
            	user	LIKE type_file.chr8,           #No.FUN-680102CHAR(08),
            	type	LIKE log_file.ltype,           # Prog. Version..: '5.30.06-13.03.12(03), #TQC-C10115 mark #TQC-C20135
                #type    LIKE log_file.acttype,         #TQC-C10115   #TQC-C20135  mark
            	old_val	LIKE log_file.old_val,         #No.FUN-680102CHAR(15),
            	new_val	LIKE log_file.new_val          #No.FUN-680102CHAR(15),
            	END RECORD
 
    IF tm.wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
#   LET l_name = 'aooq040.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aooq040'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT tab,key1,key2,key3,key4,",
              #No.FUN-850032  --BEGIN
              #"       col,zq04,date,log_file.user,type,old_val,new_val",
              #"  FROM log_file,OUTER zq_file ",          # 組合出 SQL 指令
              #" WHERE col=zq_file.zq01 AND zq02='0' AND zq03=0 AND ",tm.wc CLIPPED
              "       col,gaq03,ldate,luser,ltype,old_val,new_val",   #TQC-C10115 ltype > acctype  #TQC-C20135  acctype > ltype
              " FROM log_file LEFT OUTER JOIN gaq_file ON col=gaq01 AND gaq02='",g_lang,"' ",          # 組合出 SQL 指令 
              " WHERE col=gaq_file.gaq01 AND gaq02='0' AND ",tm.wc CLIPPED 
              #No.FUN-850032  --end
    #No.FUN-850016  --BEGIN  
    #PREPARE q040_p1 FROM g_sql                # RUNTIME 編譯
    #DECLARE q040_co                         # SCROLL CURSOR
    #    CURSOR FOR q040_p1
 
    #CALL cl_outnam('aooq040') RETURNING l_name
    #START REPORT q040_rep TO l_name
 
    #FOREACH q040_co INTO sr.*
    #    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    #    LET sr.colname=sr.colname[7,40]
    #    OUTPUT TO REPORT q040_rep(sr.*)
    #END FOREACH
 
    #FINISH REPORT q040_rep
 
    #CLOSE q040_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(tm.wc,'tab,key1,key2,key3,key4')                                                                               
       RETURNING tm.wc                                                                                                              
       LET g_str = tm.wc                                                                                                            
    END IF                                                                                                                          
    CALL cl_prt_cs1('aooq040','aooq040',g_sql,g_str)                                                                                
    #No.FUN-850016   --end        
END FUNCTION
 
#No.FUN-850016   --begin                                                                                                            
{       
REPORT q040_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1), 
        sr	RECORD
            	tab	LIKE type_file.chr3,          #No.FUN-680102CHAR(3),
            	key1	LIKE log_file.key1,           #No.FUN-680102CHAR(20),
            	key2	LIKE log_file.key2,           #No.FUN-680102CHAR(20),
            	key3	LIKE log_file.key3,           #No.FUN-680102CHAR(20),
            	key4	LIKE log_file.key4,           #No.FUN-680102CHAR(20),
            	col	LIKE log_file.col,            #No.FUN-680102CHAR(08),
            	colname	LIKE log_file.col,            #No.FUN-680102CHAR(08),
            	date	DATETIME MONTH TO MINUTE,
            	user	LIKE type_file.chr8,      #No.FUN-680102CHAR(08),
            	type	LIKE log_file.ltype,      #No.FUN-680102CHAR(03),
            	old_val	LIKE log_file.old_val,    #No.FUN-680102CHAR(15),
            	new_val	LIKE log_file.new_val     #No.FUN-680102CHAR(15)
            	END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.tab, sr.key1, sr.key2, sr.key3, sr.key4
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.key4
            PRINT g_x[13] CLIPPED,sr.tab,' ',
                  g_x[14] CLIPPED,sr.key1 CLIPPED,'/',sr.key2 CLIPPED,'/',
                                  sr.key3 CLIPPED,'/',sr.key4 CLIPPED
            PRINT
            PRINT g_x[11],g_x[12]
            PRINT '-------- -------- ----------- --------',
                  ' --- --------------- ---------------'
        ON EVERY ROW
            PRINT COLUMN 1,sr.col,
                  COLUMN 10,sr.colname,
                  COLUMN 11,sr.date,
                  COLUMN 31,sr.user,
                  COLUMN 40,sr.type,
                  COLUMN 44,sr.old_val,
                  COLUMN 60,sr.new_val
        AFTER GROUP OF sr.key4
            PRINT g_dash[1,g_len]
 
        ON LAST ROW
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}                                                                                                                                   
#No.FUN-850016   --end   
#Patch....NO.TQC-610036 <001> #
