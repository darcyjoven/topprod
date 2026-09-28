# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmq103.4gl
# Descriptions...: 支票付款查詢
# Date & Author..: 97/01/27 BY Star
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550057 05/06/01 By wujie 單據編號加大
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-660118 06/06/28 By Smapmin 單身資料顯示有誤
# Modify.........: No.MOD-680057 06/08/23 By Smapmin 拿掉mark
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740058 07/04/13 By Judy 匯出EXCEL多一行空白列
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
       g_nmd RECORD LIKE nmd_file.*,   #TQC-840066
       g_apa DYNAMIC ARRAY OF RECORD
            apa08   LIKE apa_file.apa08,   #發票號碼
            apa09   LIKE apa_file.apa09,   #發票日期
            apa31   LIKE apa_file.apa31,   #未稅金額
            apa32   LIKE apa_file.apa32,   #稅額
            apa01   LIKE apa_file.apa01,   #請款單號
            apa20   LIKE apa_file.apa20
       END RECORD,
       g_nma02      LIKE nma_file.nma02,
       g_wc         string,                 #No.FUN-580092 HCN
       g_wc2        string,                 #No.FUN-580092 HCN
       g_sql        string,                 #No.FUN-580092 HCN
       l_ac         LIKE type_file.num5,    #No.FUN-680107 SMALLINT
#      g_argv1      VARCHAR(10),
       g_argv1      LIKE apa_file.apa01,    #No.FUN-550057
       g_rec_b      LIKE type_file.num5     #單身筆數  #No.FUN-680107 SMALLINT
 
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5    #No.FUN-680107 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q103_w AT p_row,p_col
         WITH FORM "anm/42f/anmq103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    LET g_argv1 = ARG_VAL(1)
#    IF cl_chk_act_auth() THEN
#       CALL q103_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q103_q() END IF
    CALL q103_menu()
    CLOSE WINDOW q103_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION q103_cs()
    CLEAR FORM
   CALL g_apa.clear()
 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT nmd01 FROM nmd_file ", # 組合出 SQL 指令
          " WHERE nmd30 <> 'X' AND nmd02 ='",g_argv1, "' ORDER BY nmd01"
    ELSE
   INITIALIZE g_nmd.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON nmd02,nmd04,nmd08,nmd24,nmd10,nmd101,
                                 nmd03,nmd05,nmd07,nmd15,nmd21
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
       IF INT_FLAG THEN RETURN END IF
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND nmduser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
       #End:FUN-980030
 
       LET g_sql="SELECT nmd01 FROM nmd_file ", # 組合出 SQL 指令
          " WHERE ",g_wc CLIPPED, " ORDER BY nmd01"
    END IF
 
    PREPARE q103_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q103_cs                         # SCROLL CURSOR
        SCROLL CURSOR FOR q103_prepare
    IF NOT cl_null(g_argv1) THEN
        LET g_sql = "SELECT COUNT(*) FROM nmd_file WHERE nmd30 <> 'X' AND ",
                     " nmd02 ='",g_argv1,"'"
    ELSE
        LET g_sql= "SELECT COUNT(*) FROM nmd_file WHERE nmd30 <> 'X' ",
                   " AND ",g_wc CLIPPED
    END IF
    PREPARE q103_pre_count FROM g_sql
    DECLARE q103_count CURSOR FOR q103_pre_count
END FUNCTION
 
FUNCTION q103_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL q103_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q103_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apa),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q103_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q103_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_apa.clear()
        RETURN
    END IF
    OPEN q103_count
    FETCH q103_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q103_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
        INITIALIZE g_nmd.* TO NULL
    ELSE
        CALL q103_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q103_fetch(p_flnmd)
    DEFINE
        p_flnmd         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
    CASE p_flnmd
        WHEN 'N' FETCH NEXT     q103_cs INTO g_nmd.nmd01
        WHEN 'P' FETCH PREVIOUS q103_cs INTO g_nmd.nmd01
        WHEN 'F' FETCH FIRST    q103_cs INTO g_nmd.nmd01
        WHEN 'L' FETCH LAST     q103_cs INTO g_nmd.nmd01
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
            FETCH ABSOLUTE g_jump q103_cs INTO g_nmd.nmd01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
        INITIALIZE g_nmd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnmd
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_nmd.* FROM nmd_file    # 重讀DB,因TEMP有不被更新特性
       WHERE nmd01 = g_nmd.nmd01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("sel","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
    ELSE
 
        CALL q103_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q103_show()
 
    DISPLAY BY NAME g_nmd.nmd02,g_nmd.nmd04,g_nmd.nmd08,g_nmd.nmd24,
                    g_nmd.nmd10,g_nmd.nmd101,g_nmd.nmd03,
                    g_nmd.nmd05,g_nmd.nmd07,g_nmd.nmd15,g_nmd.nmd21
 
   CALL q103_nmd03('d')
   CALL q103_b_fill()                        #單身
    CALL cl_show_fld_cont()                  #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q103_nmd03(p_cmd)  #銀行代號
    DEFINE p_cmd   LIKE   type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_nma02 LIKE   nma_file.nma02,
           l_nmaacti LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma02,nmaacti
           INTO l_nma02,l_nmaacti
           FROM nma_file WHERE nma01 = g_nmd.nmd03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-007'
                            LET l_nma02 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_nma02 TO FORMONLY.nma02
    END IF
END FUNCTION
 
FUNCTION q103_b_fill()  #BODY FILL UP
 DEFINE  l_azp03  LIKE azp_file.azp03
 
 FOR g_cnt = 1 TO g_apa.getLength()           #單身 ARRAY 乾洗
    INITIALIZE g_apa[g_cnt].* TO NULL
 END FOR
 LET g_cnt = 1
 IF cl_null(g_nmd.nmd34) THEN
    LET g_nmd.nmd34 = g_plant
 END IF
 SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_nmd.nmd34
    LET g_sql =
        "SELECT distinct apa08, apa09, apa31, apa32, apa01, apa20 ",
#TQC-940177   ---start   
       #" FROM ",s_dbstring(l_azp03 CLIPPED)," apg_file, ",
       #         s_dbstring(l_azp03 CLIPPED)," apa_file ",
       # " FROM ",s_dbstring(l_azp03 CLIPPED)," apg_file, ",   
       #          s_dbstring(l_azp03 CLIPPED)," apa_file ",
       " FROM ",cl_get_target_table(g_nmd.nmd34,'apg_file'),",", #FUN-A50102  
                cl_get_target_table(g_nmd.nmd34,'apa_file'),     #FUN-A50102  
#TQC-940177   ---end         
        " WHERE apg01 = '",g_nmd.nmd10,"' ",
        "   AND apg04 = apa01 ",
        " ORDER BY 1,2 "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	CALL cl_parse_qry_sql(g_sql,g_nmd.nmd34) RETURNING g_sql #FUN-A50102
    PREPARE q103_pb FROM g_sql
    DECLARE apa_curs                      #SCROLL CURSOR
        CURSOR FOR q103_pb
 
    FOREACH apa_curs INTO g_apa[g_cnt].*           #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        IF g_apa[g_cnt].apa08 = 'MISC' THEN   #多發票
 
           LET g_sql =
               "SELECT distinct apk03, apk05, apk08, apk07, apa01, apa20 ",
#TQC-940177   ---start  
              #" FROM ",s_dbstring(l_azp03 CLIPPED)," apg_file, ",
              #  s_dbstring(l_azp03 CLIPPED)," apa_file,",
              #  s_dbstring(l_azp03 CLIPPED)," apk_file ",
              # " FROM ",s_dbstring(l_azp03 CLIPPED)," apg_file, ",  
              #   s_dbstring(l_azp03 CLIPPED)," apa_file,",   
              #  s_dbstring(l_azp03 CLIPPED)," apk_file ", 
              " FROM ",cl_get_target_table(g_nmd.nmd34,'apg_file'),",", #FUN-A50102
                       cl_get_target_table(g_nmd.nmd34,'apa_file'),",", #FUN-A50102 
                       cl_get_target_table(g_nmd.nmd34,'apk_file'),     #FUN-A50102
#TQC-940177   ---end       
               " WHERE apg01 = '",g_nmd.nmd10,"' ",
            #  "   AND apg02 = '",g_nmd.nmd101,"' ",
               "   AND apg04 = apa01 ",
               "   AND apa01 = apk01 ",
               "   AND apa42 = 'N' ",
               #---NO:3038  modify in 99/03/17---------------#
               "   AND apg04 = '", g_apa[g_cnt].apa01 ,"'",   #MOD-680057 remark
               #-------
               " ORDER BY 1,2 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
           CALL cl_parse_qry_sql(g_sql,g_nmd.nmd34) RETURNING g_sql #FUN-A50102
           PREPARE q103_apk FROM g_sql
           DECLARE apk_curs                      #SCROLL CURSOR
                 CURSOR FOR q103_apk
           FOREACH apk_curs INTO g_apa[g_cnt].*           #單身 ARRAY 填充
               IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach:',SQLCA.sqlcode,1)
                   EXIT FOREACH
               END IF
               LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
           END FOREACH
        ELSE
           LET g_cnt = g_cnt + 1
        END IF
    END FOREACH
    CALL g_apa.deleteElement(g_cnt)  #TQC-740058
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_apa TO s_apa.*   #MOD-660118
   DISPLAY ARRAY g_apa TO s_apa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-660118
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
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
         CALL q103_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q103_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q103_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q103_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q103_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
