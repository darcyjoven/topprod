# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmp460.4gl
# Descriptions...: 訂單倉儲備置/還原
# Date & Author..: 97/09/15 By Lynn
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-570253 05/08/08 By Rosayu oeb08=>no use
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-690055 06/11/15 By pengu 畫面單身的表頭欄位與內容資料不對齊
# Modify.........: No.FUN-6A0092 06/11/27 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-710072 07/01/22 By pengu  兩個action"備置","還原備置"無法使用
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    tm  RECORD
        	wc  	LIKE type_file.chr1000,        # Head Where condition  #No.FUN-680137 VARCHAR(300)
        	wc2  	LIKE type_file.chr1000         # Body Where condition  #No.FUN-680137 VARCHAR(300)
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
            oeb06   LIKE oeb_file.oeb06,     #No.TQC-690055 add
            oeb092  LIKE oeb_file.oeb092,
            oeb05   LIKE oeb_file.oeb05,
            oeb12   LIKE type_file.num10,     #No.FUN-680137 INTEGER
            oeb24   LIKE type_file.num10,     #No.FUN-680137 INTEGER
            oeb25   LIKE type_file.num10,     #No.FUN-680137 INTEGER
            unqty   LIKE type_file.num10,     #No.FUN-680137 INTEGER
            oeb15   LIKE oeb_file.oeb15,
            oeb16   LIKE oeb_file.oeb16,     #No.TQC-690055 add
            oeb19   LIKE oeb_file.oeb19,
            #oeb08   LIKE oeb_file.oeb08, #MOD-570253
            oeb09   LIKE oeb_file.oeb09,
            oeb091  LIKE oeb_file.oeb091 
        END RECORD,
    g_argv1         LIKE oea_file.oea01,
    g_query_flag    LIKE type_file.num5,     #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
     g_wc,g_wc2,g_sql STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10            #No.FUN-680137 INTEGER      #單身筆數
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   j               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   l_ac            LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
 
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
   LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
   LET g_query_flag=1
 
   OPEN WINDOW p460_w WITH FORM "axm/42f/axmp460" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
#   IF cl_chk_act_auth() THEN
#      CALL p460_q()
#   END IF
IF NOT cl_null(g_argv1) THEN CALL p460_q() END IF
   WHILE TRUE
     LET g_action_choice = ''
     CALL p460_menu()
     IF g_action_choice = 'exit' THEN EXIT WHILE END IF
   END WHILE
   CLOSE WINDOW p460_w
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION p460_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "oea01 = '",g_argv1,"'"
           LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
           CALL g_oeb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
           END CONSTRUCT
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
           IF INT_FLAG THEN RETURN END IF
           CALL p460_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT ' 
   LET g_sql=" SELECT oea01 FROM oea_file ",
             " WHERE oea00 <> '0' AND ",tm.wc CLIPPED,
             "   AND oeaconf != 'X' ", #01/08/16 mandy
             " ORDER BY oea01"
   PREPARE p460_prepare FROM g_sql
   DECLARE p460_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR p460_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(*) FROM oea_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND oea00 <> '0' ",
             "   AND oeaconf != 'X' "  #01/08/16 mandy
   PREPARE p460_pp  FROM g_sql
   DECLARE p460_count   CURSOR FOR p460_pp
END FUNCTION
 
FUNCTION p460_b_askkey()
  #-----------No.TQC-690055 modify
  #CONSTRUCT tm.wc2 ON oeb03,oeb04,oeb092,oeb05,oeb12,oeb24,oeb25,unqty,
  #                    #oeb15,oeb19,oeb06,oeb08,oeb09,oeb091,oeb16 #MOD-570253
  #                     oeb15,oeb19,oeb06,      oeb09,oeb091,oeb16 #MOD-570253
   CONSTRUCT tm.wc2 ON oeb03,oeb04,oeb06,oeb092,oeb05,oeb12,oeb24,oeb25,unqty,
                        oeb15,oeb16,oeb19,oeb09,oeb091 #MOD-570253
  #-----------No.TQC-690055 end
                  FROM s_oeb[1].oeb03,s_oeb[1].oeb04,s_oeb[1].oeb06,s_oeb[1].oeb05,    #No.TQC-690055 add
                       s_oeb[1].oeb092,
                       s_oeb[1].oeb12,s_oeb[1].oeb24,s_oeb[1].oeb25,
                       s_oeb[1].unqty,s_oeb[1].oeb15,s_oeb[1].oeb16,s_oeb[1].oeb19,    #No.TQC-690055 add
                       s_oeb[1].oeb09, #MOD-570253   #No.TQC-690055 modify
                       s_oeb[1].oeb091               #No.TQC-690055 modify
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
 
#中文的MENU
FUNCTION p460_menu()
   WHILE TRUE
      CALL p460_bp("G")
      CASE g_action_choice
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p460_q()
            END IF
          #-----------No.TQC-710072 modify
          #WHEN "Y.備置"
           WHEN "allocate"   #Y.備置
          #-----------No.TQC-710072 end
              IF cl_chk_act_auth() THEN
                 CALL p460_y()
              END IF
          #-----------No.TQC-710072 modify
          #WHEN "Z.備置還原"
           WHEN "undo_allocate"  #"Z.備置還原"
          #-----------No.TQC-710072 end
              IF cl_chk_act_auth() THEN
                 CALL p460_z()
              END IF
           WHEN "next" 
            CALL p460_fetch('N')
           WHEN "previous" 
            CALL p460_fetch('P')
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL p460_fetch('/')
           WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p460_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL p460_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN p460_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN p460_count
       FETCH p460_count INTO g_row_count
       DISPLAY g_row_count TO cnt  
       CALL p460_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION p460_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
    l_oeauser       LIKE oea_file.oeauser, #FUN-4C0057 add
    l_oeagrup       LIKE oea_file.oeagrup  #FUN-4C0057 add
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p460_cs INTO g_oea.oea01
        WHEN 'P' FETCH PREVIOUS p460_cs INTO g_oea.oea01
        WHEN 'F' FETCH FIRST    p460_cs INTO g_oea.oea01
        WHEN 'L' FETCH LAST     p460_cs INTO g_oea.oea01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump p460_cs INTO g_oea.oea01
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
    SELECT oea01,oea02,oea03,oea04,oea032,'',oea14,oea15,oeaconf,oeahold
           oeauser,oeagrup                           #FUN-4C0057 modify
      INTO g_oea.*,l_oeauser,l_oeagrup               #FUN-4C0057 modify
      FROM oea_file
     WHERE oea01 = g_oea.oea01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
       INITIALIZE g_oea.* TO NULL        #FUN-4C0057 add
       RETURN
    END IF
    LET g_data_owner = l_oeauser      #FUN-4C0057 add
    LET g_data_group = l_oeagrup      #FUN-4C0057 add
    CALL p460_show()
END FUNCTION
 
FUNCTION p460_show()
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
   IF SQLCA.SQLCODE THEN LET g_oea.occ02=' ' END IF
   DISPLAY BY NAME g_oea.*   # 顯示單頭值
   CALL p460_b_fill() #單身
# genero  script marked    LET g_oeb_pageno = 0
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p460_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000        #No.FUN-680137  VARCHAR(400)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
      #---------------No.TQC-690055 modify
       #"SELECT oeb03,oeb04,oeb092,oeb05,oeb12,oeb24,oeb25,",
       #"      (oeb12-oeb24+oeb25-oeb26),oeb15,oeb19,",
       ##"       oeb06,oeb08,oeb09,oeb091,oeb16,' ' ", #MOD-570253
       # "       oeb06,      oeb09,oeb091,oeb16,' ' ", #MOD-570253
        "SELECT oeb03,oeb04,oeb06,oeb092,oeb05,oeb12,oeb24,oeb25,",
        "      (oeb12-oeb24+oeb25-oeb26),oeb15,oeb16,oeb19,",
         "     oeb09,oeb091 ", #MOD-570253
      #---------------No.TQC-690055 end
        "  FROM oeb_file ",
        " WHERE oeb01 = '",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE p460_pb FROM l_sql
    DECLARE p460_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR p460_pb
 
    FOR g_cnt = 1 TO g_oeb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_oeb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH p460_bcs INTO g_oeb[g_cnt].*
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
# genero script mark# genero  script marked         IF g_cnt > g_oeb_arrno THEN
# genero script mark            CALL cl_err('',9035,0)
# genero script mark            EXIT FOREACH
# genero script mark        END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
END FUNCTION
 
FUNCTION p460_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
#      BEFORE ROW
#           LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION query
           LET g_action_choice = "query"
           EXIT DISPLAY
 
        ON ACTION allocate   #Y.備置
           LET g_action_choice = "allocate"
           EXIT DISPLAY
 
        ON ACTION undo_allocate  #"Z.備置還原"
           LET g_action_choice = "undo_allocate"
           EXIT DISPLAY
 
        ON ACTION next
         CALL p460_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
        ON ACTION previous
         CALL p460_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
        ON ACTION help
           LET g_action_choice = "help"
           EXIT DISPLAY
 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT DISPLAY
 
        ON ACTION jump
         CALL p460_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
 
        ON ACTION first
         CALL p460_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
 
        ON ACTION last
         CALL p460_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION controlg
           LET g_action_choice = "controlg"
           EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
       #No.MOD-530688  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530688  --end          
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p460_y()
   DEFINE l_oeb RECORD LIKE oeb_file.*
   DEFINE l_seq LIKE type_file.num5      #No.FUN-680137 SMALLINT
   DEFINE l_img10  LIKE img_file.img10
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
 
   CALL cl_getmsg('axm-281',g_lang) RETURNING g_msg
   OPEN WINDOW p460_y_w AT 9,20 WITH 1 ROWS, 40 COLUMNS 
            LET INT_FLAG = 0  ######add for prompt bug
   PROMPT g_msg CLIPPED FOR l_seq
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
   CLOSE WINDOW p460_y_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF l_seq IS NULL THEN RETURN END IF
   SELECT * INTO l_oeb.* FROM oeb_file WHERE oeb01=g_oea.oea01 AND oeb03=l_seq
   IF STATUS THEN 
#     CALL cl_err('sel oeb:',STATUS,0) 
      CALL cl_err3("sel","oeb_file",g_oea.oea01,l_seq,STATUS,"","sel oeb:",0)     #FUN-660167
      RETURN END IF
   IF l_oeb.oeb19='Y' THEN CALL cl_err('sel oeb:','axm-282',0) RETURN END IF
   #須check(庫存量img10-sum(備置量oeb12-oeb24))>=訂單數量oeb12
        SELECT img10 INTO l_img10 FROM img_file 
             WHERE img01=l_oeb.oeb04 AND img02=l_oeb.oeb09
               AND img03=l_oeb.oeb091 AND img04=l_oeb.oeb092
        IF l_img10 IS NULL THEN LET l_img10 = 0 END IF
        SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO l_oeb12 FROM oeb_file 
                WHERE oeb04=l_oeb.oeb04 AND oeb19 = 'Y'
                  AND oeb09=l_oeb.oeb09 AND oeb091=l_oeb.oeb091 
                  AND oeb092=l_oeb.oeb092
        IF l_oeb12 IS NULL THEN LET l_oeb12 = 0 END IF
        LET l_qoh = l_img10 - l_oeb12
        IF l_qoh < l_oeb.oeb12 THEN      ###量不足時 , Fail
          CALL cl_err('QOH<0','axm-283',1) RETURN 
        END IF
   #-----------
   LET l_oeb.oeb19='Y' 
   UPDATE oeb_file SET * = l_oeb.* WHERE oeb01=g_oea.oea01 AND oeb03=l_seq
  #No.+042 010330 by plum
  #IF STATUS THEN CALL cl_err('upd oeb19:',STATUS,0) RETURN END IF
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('upd oeb19:',SQLCA.SQLCODE,0)
      RETURN
   END IF
  #No.+042 ..end
{   FOR i = 1 TO g_oeb.getLength()
      IF g_oeb[i].oeb03=l_seq THEN
# genero  script marked          LET g_oeb[i].oeb19='Y' LET j=i/g_oeb_sarrno+1
# genero  script marked          IF j=g_oeb_pageno THEN
# genero  script marked             LET j=i-(j-1)*g_oeb_sarrno
            DISPLAY g_oeb[i].oeb19 TO s_oeb[j].oeb19 
         END IF
      END IF
   END FOR
}
END FUNCTION
 
FUNCTION p460_z()
   DEFINE l_oeb RECORD LIKE oeb_file.*
   DEFINE l_seq LIKE type_file.num5      #No.FUN-680137 SMALLINT
 
   CALL cl_getmsg('axm-284',g_lang) RETURNING g_msg
   OPEN WINDOW p460_z_w AT 10,20 WITH 1 ROWS, 40 COLUMNS 
            LET INT_FLAG = 0  ######add for prompt bug
   PROMPT g_msg CLIPPED FOR l_seq
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
   CLOSE WINDOW p460_z_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   SELECT * INTO l_oeb.* FROM oeb_file WHERE oeb01=g_oea.oea01 AND oeb03=l_seq
   IF STATUS THEN 
#     CALL cl_err('sel oeb:',STATUS,0) 
      CALL cl_err3("sel","oeb_file",g_oea.oea01,l_seq,STATUS,"","sel oeb:",0)     #FUN-660167
      RETURN 
   END IF
   IF l_oeb.oeb19='N' THEN CALL cl_err('sel oeb:','axm-285',0) RETURN END IF
   LET l_oeb.oeb19='N'
   UPDATE oeb_file SET * = l_oeb.* WHERE oeb01=g_oea.oea01 AND oeb03=l_seq
  #No.+042 010330 by plum
  #IF STATUS THEN CALL cl_err('upd oeb19:',STATUS,0) RETURN END IF
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('upd oeb19:',SQLCA.SQLCODE,0)
      RETURN
   END IF
  #No.+042 ..end
   FOR i = 1 TO g_oeb.getLength()
      IF g_oeb[i].oeb03=l_seq THEN
# genero  script marked          LET g_oeb[i].oeb19='N' LET j=i/g_oeb_sarrno+1
# genero  script marked          IF j=g_oeb_pageno THEN
# genero  script marked             LET j=i-(j-1)*g_oeb_sarrno
            DISPLAY g_oeb[i].oeb19 TO s_oeb[j].oeb19 
# genero  script marked          END IF
      END IF
   END FOR
END FUNCTION
