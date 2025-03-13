# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp450.4gl
# Descriptions...: 訂單備置/還原
# Date & Author..: 97/08/04 By Lynn
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-570098 05/07/13 By Nicola 按action[備置]後執行axmp450如果訂單有留置時,應改用pub window 顯示 axm-296 的error messqge
# Modify.........: No.MOD-570253 05/09/07 By Rosayu oeb08-->no use
# Modify.........: No.MOD-5A0228 05/10/20 By Nicola 可備置量應減掉已備置量
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710046 07/01/18 By Carrier 錯誤訊息匯整
# Modify.........: No.MOD-720069 07/02/08 By claire 備置欄位應考慮有無庫存量及img資料才能勾選
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-830014 08/03/12 By lumx axmp450只在單身下條件，資料不會被過濾
# Modify.........: No.TQC-830017 08/03/17 By wujie 備置欄位不勾選應將備置量清0 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:MOD-B50227 11/06/10 By Summer 訂單上備置量控卡需增加允許超交率
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    tm  RECORD
        	wc  	 LIKE type_file.chr1000,		# Head Where condition  #No.FUN-680137 VARCHAR(300)
        	wc2  	 LIKE type_file.chr1000		# Body Where condition  #No.FUN-680137 VARCHAR(300)
        END RECORD,
    g_oea   RECORD
            oea01   LIKE oea_file.oea01,  
            oea02   LIKE oea_file.oea02,  
            oea03   LIKE oea_file.oea03,  
            oea04   LIKE oea_file.oea04,  
            oea032  LIKE oea_file.oea032,  
            occ02   LIKE occ_file.occ02,  
            oea14   LIKE oea_file.oea14,  
            oea15   LIKE oea_file.oea15,  
            oeaconf LIKE oea_file.oeaconf,  
            oeahold LIKE oea_file.oeahold
        END RECORD,
    g_oeb DYNAMIC ARRAY OF RECORD
            oeb03   LIKE oeb_file.oeb03,
            oeb04   LIKE oeb_file.oeb04,
            oeb06   LIKE oeb_file.oeb06,
            oeb05   LIKE oeb_file.oeb05,
            oeb12   LIKE oeb_file.oeb12,
            oeb24   LIKE oeb_file.oeb24,
            oeb25   LIKE oeb_file.oeb25,
            unqty   LIKE oeb_file.oeb12,#No:5271
            oeb15   LIKE oeb_file.oeb15,
            oeb16   LIKE oeb_file.oeb16,
            oeb19   LIKE oeb_file.oeb19,
            oeb905  LIKE oeb_file.oeb905,
            #oeb08   LIKE oeb_file.oeb08, #MOD-570253
            oeb09   LIKE oeb_file.oeb09,
            oeb091  LIKE oeb_file.oeb091,
            oeb092  LIKE oeb_file.oeb092
        END RECORD,
    g_oeb_o RECORD
            oeb03   LIKE oeb_file.oeb03,
            oeb04   LIKE oeb_file.oeb04,
            oeb06   LIKE oeb_file.oeb06,
            oeb05   LIKE oeb_file.oeb05,
            oeb12   LIKE oeb_file.oeb12,
            oeb24   LIKE oeb_file.oeb24,
            oeb25   LIKE oeb_file.oeb25,
            unqty   LIKE oeb_file.oeb12,#No:5271
            oeb15   LIKE oeb_file.oeb15,
            oeb16   LIKE oeb_file.oeb16,
            oeb19   LIKE oeb_file.oeb19,
            oeb905  LIKE oeb_file.oeb905,
            #oeb08   LIKE oeb_file.oeb08, #MOD-570253
            oeb09   LIKE oeb_file.oeb09,
            oeb091  LIKE oeb_file.oeb091,
            oeb092  LIKE oeb_file.oeb092
        END RECORD,
    g_argv1         LIKE oea_file.oea01,
    g_query_flag    LIKE type_file.num5,      #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
    g_wc,g_wc2,g_sql  STRING,  #WHERE CONDITION  #No.FUN-580092 HCN 
    g_rec_b LIKE type_file.num10,  	#單身筆數  #No.FUN-680137 INTEGER
    g_seq LIKE type_file.num5     #放oeb03   #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL   
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   l_ac            LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_oea09         LIKE oea_file.oea09         #MOD-B50227 add  
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
 
   LET g_argv1 = ARG_VAL(1)          #參數值(1) Part#
   LET g_query_flag=1
 
   LET g_forupd_sql = "SELECT oea01,oea02,oea03,oea04,oea032,'',",
                      "       oea14,oea15,oeaconf,oeahold",
                      "  FROM oea_file",
                      "   WHERE oea01=? ",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p450_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
 
   OPEN WINDOW p450_w WITH FORM "axm/42f/axmp450" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL p450_q() 
   END IF
 
   WHILE TRUE
      LET g_action_choice = ''
      CALL p450_menu()
      IF g_action_choice = 'exit' THEN
         EXIT WHILE 
      END IF
   END WHILE
 
   CLOSE WINDOW p450_w
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
 
END MAIN
 
FUNCTION p450_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "oea01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM #清除畫面
      CALL g_oeb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_oea.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04, 
                                 oea14,oea15,oeaconf,oeahold
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
        
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
        
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
 
      CALL p450_b_askkey()
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT ' 
 
   IF tm.wc2 = " 1=1"  THEN    #TQC-830014
       LET g_sql=" SELECT oea01 FROM oea_file ",
                 "  WHERE oea00 <> '0' AND ",tm.wc CLIPPED,
                 "    AND oeaconf != 'X' ",  #01/08/16 mandy
                 "  ORDER BY oea01"
#TQC-830014--start---
   ELSE
      LET g_sql=" SELECT UNIQUE oea01 FROM oea_file,oeb_file ",
                "  WHERE oea00 <> '0' AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "    AND oea01 = oeb01",
                "    AND oeb70 ='N' ",                   #no.7182(只處理未結案)
                "    AND oeb12-oeb24+oeb25-oeb26 > 0 ",  #no.7182
                "    AND oeaconf != 'X' ",  #01/08/16 mandy
                "  ORDER BY oea01"
   END IF
#TQC-830014--end---
   PREPARE p450_prepare FROM g_sql
   DECLARE p450_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR p450_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF tm.wc2 = " 1=1"  THEN    #TQC-830014
      LET g_sql=" SELECT COUNT(*) FROM oea_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND oea00 <> '0' ",
                "   AND oeaconf != 'X' "  #01/08/16 mandy
#TQC-830014--start---
   ELSE
      LET g_sql=" SELECT COUNT(DISTINCT oea01) FROM oea_file,oeb_file ",
                "  WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "    AND oea00 <> '0' ",
                "    AND oea01 = oeb01",
                "    AND oeb70 ='N' ",                   #no.7182(只處理未結案)
                "    AND oeb12-oeb24+oeb25-oeb26 > 0 ",  #no.7182
                "    AND oeaconf != 'X' "
   END IF
#TQC-830014--end---
   PREPARE p450_pp  FROM g_sql
   DECLARE p450_cnt   CURSOR FOR p450_pp
 
END FUNCTION
 
FUNCTION p450_b_askkey()
 
   CONSTRUCT tm.wc2 ON oeb03,oeb04,oeb06,oeb05,oeb12,oeb24,oeb25,unqty,
                       #oeb15,oeb16,oeb19,oeb905,oeb08,oeb09,oeb091,oeb092 #MOD-570253
                       oeb15,oeb16,oeb19,oeb905,oeb09,oeb091,oeb092 #MOD-570253
                  FROM s_oeb[1].oeb03,s_oeb[1].oeb04,s_oeb[1].oeb06,
                       s_oeb[1].oeb05,s_oeb[1].oeb12,s_oeb[1].oeb24,
                       s_oeb[1].oeb25,s_oeb[1].unqty,
                       s_oeb[1].oeb15,s_oeb[1].oeb16,
                       s_oeb[1].oeb19,s_oeb[1].oeb905,
                       #s_oeb[1].oeb08,s_oeb[1].oeb09, #MOD-570253
                       s_oeb[1].oeb09, #MOD-570253
                       s_oeb[1].oeb091,s_oeb[1].oeb092
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
 
END FUNCTION
 
FUNCTION p450_menu()
   WHILE TRUE
      CALL p450_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p450_q()
            END IF
#        WHEN "B.備置處理"     
         WHEN "allocate"
            IF cl_chk_act_auth() THEN
               CALL p450_b()
            END IF
#        WHEN "Z.整批備置還原"
         WHEN "batch_undo_allocate"
            IF cl_chk_act_auth() THEN
               CALL p450_z()
            END IF
         WHEN "next" 
            CALL p450_fetch('N')
         WHEN "previous" 
            CALL p450_fetch('P')
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "jump"
            CALL p450_fetch('/')
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p450_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt  
 
   CALL p450_cs()
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   OPEN p450_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN p450_cnt
      FETCH p450_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL p450_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ''
 
END FUNCTION
 
FUNCTION p450_fetch(p_flag)
   DEFINE   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
            l_oeauser       LIKE oea_file.oeauser, #FUN-4C0057 add
            l_oeagrup       LIKE oea_file.oeagrup  #FUN-4C0057 add
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     p450_cs INTO g_oea.oea01
       WHEN 'P' FETCH PREVIOUS p450_cs INTO g_oea.oea01
       WHEN 'F' FETCH FIRST    p450_cs INTO g_oea.oea01
       WHEN 'L' FETCH LAST     p450_cs INTO g_oea.oea01
       WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump p450_cs INTO g_oea.oea01
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)
       INITIALIZE g_oea.* TO NULL  #TQC-6B0105
       LET g_oea.oea01 = NULL      #TQC-6B0105
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
    SELECT oea01,oea02,oea03,oea04,oea032,'',oea14,oea15,oeaconf,oeahold,
           oeauser,oeagrup,oea09                     #FUN-4C0057 modify #MOD-B50227 add oea09
      INTO g_oea.*,l_oeauser,l_oeagrup,g_oea09       #FUN-4C0057 modify #MOD-B50227 add g_oea09
      FROM oea_file
     WHERE oea01 = g_oea.oea01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
       INITIALIZE g_oea.* TO NULL     #FUN-4C0057 add
       RETURN
    END IF
    LET g_data_owner = l_oeauser      #FUN-4C0057 add
    LET g_data_group = l_oeagrup      #FUN-4C0057 add
    CALL p450_show()
END FUNCTION
 
FUNCTION p450_show()
 
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
 
   IF SQLCA.SQLCODE THEN
      LET g_oea.occ02=' '
   END IF
 
   DISPLAY BY NAME g_oea.*   # 顯示單頭值
 
   CALL p450_b_fill() #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION p450_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(400)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
 
   LET l_sql =
        "SELECT oeb03,oeb04,oeb06,oeb05,oeb12,oeb24,oeb25,",
        "      (oeb12-oeb24+oeb25-oeb26),oeb15,oeb16,oeb19,oeb905,",
        #"       oeb08,oeb09,oeb091,oeb092", #MOD-570253
        "       oeb09,oeb091,oeb092",  #MOD-570253
        "  FROM oeb_file ",
        " WHERE oeb01 = '",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND oeb70 ='N' ",                   #no.7182(只處理未結案)
        "   AND oeb12-oeb24+oeb25-oeb26 > 0 ",  #no.7182
        " ORDER BY 1"
    PREPARE p450_pb FROM l_sql
    DECLARE p450_bcs CURSOR WITH HOLD FOR p450_pb
 
    CALL g_oeb.clear()
    LET g_cnt = 1
 
    FOREACH p450_bcs INTO g_oeb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       IF g_oeb[g_cnt].oeb12 IS NULL THEN
          LET g_oeb[g_cnt].oeb12 = 0 
       END IF
 
       IF g_oeb[g_cnt].oeb24 IS NULL THEN
          LET g_oeb[g_cnt].oeb24 = 0 
       END IF
 
       IF g_oeb[g_cnt].oeb25 IS NULL THEN
          LET g_oeb[g_cnt].oeb25 = 0 
       END IF
 
       IF g_oeb[g_cnt].unqty IS NULL THEN
          LET g_oeb[g_cnt].unqty = 0 
       END IF
 
       LET g_cnt = g_cnt + 1
 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_oeb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION p450_bp(p_ud)
   DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
           LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
       ON ACTION query      
          LET g_action_choice="query"     
          EXIT DISPLAY 
 
       ON ACTION next       
         CALL p450_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
       ON ACTION previous   
         CALL p450_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
       ON ACTION first      
         CALL p450_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
       ON ACTION last       
         CALL p450_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
       ON ACTION jump       
         CALL p450_fetch('/')
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
          EXIT DISPLAY
 
       ON ACTION exit       
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION accept
          LET g_action_choice="allocate"
          LET l_ac = ARR_CURR()
          EXIT DISPLAY
   
       ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION allocate   
          LET g_action_choice="allocate"
          EXIT DISPLAY
 
       ON ACTION batch_undo_allocate
          LET g_action_choice="batch_undo_allocate"
          EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p450_b()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_ac LIKE type_file.num5          #No.FUN-680137 SMALLINT
#   DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_avl_stk LIKE type_file.num15_3  #FUN-A20044
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
   #FUN-A20044-----BEGIN
   DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3
   DEFINE l_unavl_stk LIKE type_file.num15_3
   #FUN-A20044-----END
   DEFINE l_oeb05_fac   LIKE oeb_file.oeb05_fac #MOD-B50227 add

   IF NOT cl_null(g_oea.oeahold) THEN
      CALL cl_err('','axm-296',1)   #No.FUN-570098
      RETURN
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb70 = 'N' 
      AND oeb12-oeb24+oeb25-oeb26 > 0
   IF g_cnt = 0 THEN 
      CALL cl_err('','axm-808',1) 
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT ARRAY g_oeb WITHOUT DEFAULTS FROM s_oeb.* 
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         BEGIN WORK
 
         OPEN p450_cl USING g_oea.oea01
         IF STATUS THEN
            CALL cl_err("OPEN p450_cl:", STATUS, 1) 
            CLOSE p450_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH p450_cl INTO g_oea.*  # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
            CLOSE p450_cl
            ROLLBACK WORK 
            RETURN
         END IF
 
         LET g_oeb_o.* = g_oeb[l_ac].*  
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD oeb19
         IF NOT cl_null(g_oeb[l_ac].oeb19) THEN
            IF g_oeb[l_ac].oeb19 NOT MATCHES '[YN]' THEN 
               NEXT FIELD oeb19 
            END IF
             #MOD-720069-begin-add
              IF g_oeb[l_ac].oeb19='Y' THEN
               #  SELECT ima262 INTO l_ima262 FROM ima_file
                #  WHERE ima01 = g_oeb[l_ac].oeb04   #FUN-A20044
               CALL s_getstock(g_oeb[l_ac].oeb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk  #FUN-A20044
                 IF l_avl_stk = 0 THEN 
                    LET g_oeb[l_ac].oeb19='N'
                    LET g_oeb[l_ac].oeb905 = 0 
                    CALL cl_err('','axm-283',0)
                    NEXT FIELD oeb19 
                 END IF 
              END IF 
             #MOD-720069-end-add
#No.TQC-830017 --begin  
              IF g_oeb[l_ac].oeb19='N' THEN       
                 LET g_oeb[l_ac].oeb905 =0       
              END IF                            
#No.TQC-830017 --end 
         END IF
 
      BEFORE FIELD oeb905
         IF g_oeb[l_ac].oeb19 = 'N' OR cl_null(g_oeb[l_ac].oeb19) THEN 
            LET g_oeb[l_ac].oeb905 = 0 
         END IF
 
      AFTER FIELD oeb905
         IF cl_null(g_oeb[l_ac].oeb905) THEN
            NEXT FIELD oeb905
         END IF
         IF g_oeb[l_ac].oeb19 = 'Y' THEN
            #備置量不可大於未交量
           #IF g_oeb[l_ac].oeb905 > g_oeb[l_ac].unqty THEN #MOD-B50227 mark
            IF g_oeb[l_ac].oeb905 > g_oeb[l_ac].unqty*((100+g_oea09)/100) THEN #MOD-B50227
               CALL cl_err('','axm-807',0)
               NEXT FIELD oeb905
            END IF
 
            #備置量不可大於可用庫存量
          #  SELECT ima262 INTO l_ima262 FROM ima_file
           #  WHERE ima01 = g_oeb[l_ac].oeb04              #FUN-A20044
                CALL s_getstock(g_oeb[l_ac].oeb04,g_plant) RETURNING  l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk 
          #  IF cl_null(l_ima262) THEN LET l_ima262 = 0 END IF  #FUN-A20044
 
            SELECT SUM(oeb905*oeb05_fac) INTO l_oeb12 FROM oeb_file
             WHERE oeb04 = g_oeb[l_ac].oeb04 
               AND (oeb01 != g_oea.oea01 OR oeb03 != g_oeb[l_ac].oeb03)   #No.MOD-5A0228
               AND oeb70  = 'N'
 
            IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
 
          #  LET l_qoh = l_ima262 - l_oeb12 #FUN-A20044
             LET l_qoh = l_avl_stk - l_oeb12 #FUN-A20044
              #MOD-720069-begin-add
              IF l_qoh = 0 THEN 
                 LET g_oeb[l_ac].oeb19='N'
                 LET g_oeb[l_ac].oeb905 = 0 
                 CALL cl_err('','axm-283',0)
                 NEXT FIELD oeb19 
              END IF 
              #MOD-720069-end-add
              #MOD-B50227 add --start--
              SELECT oeb05_fac INTO l_oeb05_fac FROM oeb_file
               WHERE oeb01 = g_oea.oea01 
                 AND oeb03 = g_oeb[l_ac].oeb03
              IF cl_null(l_oeb05_fac) THEN LET l_oeb05_fac = 1 END IF 
              #MOD-B50227 add --end--

           #IF l_qoh < g_oeb[l_ac].oeb905 THEN  #庫存不足                   #MOD-B50227 mark
            IF l_qoh < g_oeb[l_ac].oeb905*l_oeb05_fac THEN  #庫存不足 #MOD-B50227
               CALL cl_err('QOH<0','axm-283',0)
               NEXT FIELD oeb905
            END IF
         ELSE
            LET g_oeb[l_ac].oeb905 = 0 
         END IF
 
      AFTER ROW
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET g_oeb[l_ac].* = g_oeb_o.*
            EXIT INPUT
         END IF
 
         IF cl_null(g_oeb[l_ac].oeb03) THEN
           INITIALIZE g_oeb[l_ac].* TO NULL
         ELSE
            IF cl_null(g_oeb[l_ac].oeb19) THEN
               MESSAGE "oeb19 no change"
               CALL ui.Interface.refresh()
               ROLLBACK WORK CLOSE p450_cl
            ELSE 
               UPDATE oeb_file SET oeb19 = g_oeb[l_ac].oeb19,
                                   oeb905= g_oeb[l_ac].oeb905
                WHERE oeb01 = g_oea.oea01
                  AND oeb03 = g_oeb[l_ac].oeb03
              

                IF SQLCA.SQLCODE THEN 
#                 CALL cl_err('upd rvb',SQLCA.SQLCODE,1)   #No.FUN-660167
                  CALL cl_err3("upd","oeb_file","","",SQLCA.SQLCODE,"","upd rvb",1)   #No.FUN-660167
                  ROLLBACK WORK
                  CLOSE p450_cl
               ELSE
                  COMMIT WORK
                  CLOSE p450_cl
               END IF 
            END IF
         END IF
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
   END INPUT
 
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF #使用者中斷
 
END FUNCTION
{
FUNCTION p450_y()
   DEFINE l_oeb RECORD LIKE oeb_file.*
 # DEFINE g_seq SMALLINT
 #  DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_avl_stk  LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
   DEFINE l_unqty   LIKE oeb_file.oeb12
 
   IF NOT cl_null(g_oea.oeahold) THEN
      CALL cl_err('','axm-296',0)
      RETURN
   END IF
   CALL cl_getmsg('axm-281',g_lang) RETURNING g_msg
   OPEN WINDOW p450_y_w AT 9,20 WITH 1 ROWS, 40 COLUMNS 
            LET INT_FLAG = 0  ######add for prompt bug
   PROMPT g_msg CLIPPED FOR g_seq
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
#         CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END PROMPT
   CLOSE WINDOW p450_y_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF g_seq IS NULL THEN RETURN END IF
 
   #No:5271 未交量為零,此料件已全部出貨,不需再備置!
   SELECT (oeb12-oeb24+oeb25-oeb26) INTO l_unqty
     FROM oeb_file 
    WHERE oeb01 = g_oea.oea01
      AND oeb03 = g_seq
   IF l_unqty = 0 THEN 
       CALL cl_err(g_oea.oea01,'axm-540',0)
       RETURN 
   END IF
   
   SELECT * INTO l_oeb.* FROM oeb_file WHERE oeb01=g_oea.oea01 AND oeb03=g_seq
   IF STATUS THEN 
#     CALL cl_err('sel oeb:',STATUS,0) 
      CALL cl_err3("sel","oeb_file",g_oea.oea01,g_seq,STATUS,"","sel oeb:",0)  RETURN END IF   #FUN-660167
      RETURN END IF
   IF l_oeb.oeb19='Y' THEN CALL cl_err('sel oeb:','axm-282',0) RETURN END IF
   IF l_oeb.oeb70='Y' THEN CALL cl_err('','aap-730',0) RETURN END IF
 
   #須check(庫存量ima262-sum(備置量oeb12-oeb24))>=訂單數量oeb12
      #  SELECT ima262 INTO l_ima262 FROM ima_file WHERE ima01=l_oeb.oeb04
      #  IF l_ima262 IS NULL THEN LET l_ima262 = 0 END IF                      #FUN-A20044
         CALL s_getstock(l_oeb.oeb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk                      #FUN-A20044
            SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO l_oeb12 FROM oeb_file 
                WHERE oeb04=l_oeb.oeb04 AND oeb19 = 'Y'
        IF l_oeb12 IS NULL THEN LET l_oeb12 = 0 END IF
       # LET l_qoh = l_ima262 - l_oeb12                                 #FUN-A20044
         LET l_qoh = l_avl_stk - l_oeb12                             #FUN-A20044
            IF l_qoh < l_oeb.oeb12 THEN      ###量不足時 , Fail
          CALL cl_err('QOH<0','axm-283',1) RETURN 
        END IF
   #-----------
   LET l_oeb.oeb19='Y' 
 
   BEGIN WORK
   OPEN p450_bcl
   FETCH p450_bcl INTO g_oea.*  # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE p450_bcl ROLLBACK WORK RETURN
   END IF
 
   UPDATE oeb_file SET * = l_oeb.* WHERE oeb01=g_oea.oea01 AND oeb03=g_seq
  #No.+042 010330 by plum
  #IF STATUS THEN CALL cl_err('upd oeb19:',STATUS,0) RETURN END IF
   IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err('upd oeb19:',SQLCA.SQLCODE,0)
       ROLLBACK WORK
       RETURN
   ELSE
       COMMIT WORK
   END IF
  #No.+042 ..end
   FOR i = 1 TO g_oeb.getLength()
      IF g_oeb[i].oeb03=g_seq THEN
# genero  script marked          LET g_oeb[i].oeb19='Y' LET j=i/g_oeb_sarrno+1
# genero  script marked          IF j=g_oeb_pageno THEN
# genero  script marked             LET j=i-(j-1)*g_oeb_sarrno
            DISPLAY g_oeb[i].oeb19 TO s_oeb[j].oeb19 
         END IF
      END IF
   END FOR
END FUNCTION
}
 
FUNCTION p450_z()
   DEFINE l_oeb03 LIKE oeb_file.oeb03
 
   SELECT COUNT(*) INTO g_cnt FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb70 = 'N' 
      AND oeb12-oeb24+oeb25-oeb26 > 0
 
   IF g_cnt = 0 THEN
      CALL cl_err('','axm-808',1)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM oeb_file
    WHERE oeb01 = g_oea.oea01
      AND oeb19 = 'Y'
 
   IF g_cnt = 0 THEN
      CALL cl_err('sel oeb:','axm-285',0)
      RETURN
   END IF
 
   IF NOT cl_sure(0,0) THEN
      RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN p450_cl USING g_oea.oea01
   IF STATUS THEN
      CALL cl_err("OPEN p450_cl:", STATUS, 1)
      CLOSE p450_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p450_cl INTO g_oea.*  # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE p450_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE oeb_cs CURSOR FOR SELECT oeb03 FROM oeb_file 
                              WHERE oeb01 = g_oea.oea01
                                AND oeb19 = 'Y'
 
   CALL s_showmsg_init()   #No.FUN-710046
   FOREACH oeb_cs INTO l_oeb03
      UPDATE oeb_file SET oeb19  = 'N',
                          oeb905 = 0
       WHERE oeb01 = g_oea.oea01 
         AND oeb03 = l_oeb03
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('upd oeb19:',SQLCA.SQLCODE,1)   #No.FUN-660167
         #No.FUN-710046  --Begin
         #CALL cl_err3("upd","oeb_file",g_oea.oea01,l_oeb03,SQLCA.SQLCODE,"","upd oeb19",1)   #No.FUN-660167
         LET g_showmsg=g_oea.oea01,"/",l_oeb03
         CALL s_errmsg("oeb01,oeb03",g_showmsg,"upd oeb19:",SQLCA.sqlcode,1)
         LET g_success = 'N'
         #EXIT FOREACH
         CONTINUE FOREACH
         #No.FUN-710046  --End  
      END IF
   END FOREACH
 
   #No.FUN-710046  --Begin
   CALL s_showmsg()
   #No.FUN-710046  --End  
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(0)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(0)
   END IF
 
   CALL p450_b_fill()
 
END FUNCTION
#NO.FUN-B80089
