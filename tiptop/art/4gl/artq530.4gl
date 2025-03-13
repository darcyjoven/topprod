# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: artq530.4gl
# Descriptions...: 供應商採購未交明細查詢作業
# Date & Author..: No.FUN-870006 09/02/24 By Sunyanchun
# Memo...........: 由apmq530客制而來
# Modify.........: No.FUN-870007 09/02/24 By Zhangyajun 程序移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10070 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(500)
        END RECORD,
    g_pmm  RECORD
            pmm09    LIKE pmm_file.pmm09, #供應商
            pmc03    LIKE pmc_file.pmc03  #供應商簡稱
        END RECORD,
    choice           LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
    g_order          LIKE type_file.num5,     #No.FUN-680136 SMALLINT
    g_pmn DYNAMIC ARRAY OF RECORD
            pmn01   LIKE pmn_file.pmn01, #採購單號
            pmn04   LIKE pmn_file.pmn04, #料號
            pmn33   LIKE pmn_file.pmn36, #交貨日
            pmn20   LIKE pmn_file.pmn20, #訂購量
            pmn83   LIKE pmn_file.pmn83,
            pmn85   LIKE pmn_file.pmn85,
            pmn80   LIKE pmn_file.pmn80,
            pmn82   LIKE pmn_file.pmn82,
            rest    LIKE pmn_file.pmn20, #在外量
            pmn07   LIKE pmn_file.pmn07  #單位
        END RECORD,
    g_pmn02 DYNAMIC ARRAY OF LIKE type_file.num5,     #No.FUN-680136 SMALLINT	 #採購單項次
    g_argv1         LIKE pmm_file.pmm09,
    g_query_flag    LIKE type_file.num5,     #No.FUN-680136 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_sql           string,                  #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5      #單身筆數  #No.FUN-680136 SMALLINT
 
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680136 SMALLINT
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03,       #No.FUN-680136 VARCHAR(72)
       l_ac         LIKE type_file.num5      #目前處理的ARRAY CNT        #No.FUN-680136 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   g_dbs          LIKE azp_file.azp03     
DEFINE   g_azp01        LIKE azp_file.azp01   
DEFINE   g_sql1         STRING             
DEFINE   g_sql2         STRING            
 
MAIN
DEFINE l_sl  LIKE type_file.num5     #No.FUN-680136 SMALLINT
 
   OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN EXIT PROGRAM END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q530_w AT p_row,p_col
        WITH FORM "art/42f/artq530"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   SELECT pmm09,pmmplant FROM pmm_file WHERE 1=0 INTO TEMP temp_pmm09  
   CALL q530_def_form()
 
   IF NOT cl_null(g_argv1) THEN CALL q530_q() END IF
   CALL q530_menu()
   DROP TABLE temp_pmm09 
   CLOSE WINDOW q530_w
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
    RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q530_cs()
   DEFINE   l_cnt    LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE   l_rows   LIKE type_file.num5
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmm09 = '",g_argv1,"'"
   ELSE CLEAR FORM #清除畫面
   CALL g_pmn.clear()
       CALL cl_opmsg('q')
       INITIALIZE tm.* TO NULL
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
       INITIALIZE g_pmm.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME tm.wc ON pmm09,pmmplant      
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          ON ACTION CONTROLP
            CASE WHEN INFIELD(pmm09)      #廠商編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_pmc"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO pmm09
                      NEXT FIELD pmm09
                 WHEN INFIELD(pmmplant)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_azp"
                      LET g_qryparam.state = 'c'
                      LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO pmmplant
                      NEXT FIELD pmmplant
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
 
 
      ON ACTION qbe_select
     	   CALL cl_qbe_select()
      ON ACTION qbe_save
           CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
       #End:FUN-980030
 
   END IF
   LET choice = '3'
   INPUT BY NAME choice WITHOUT DEFAULTS
       AFTER FIELD choice
          IF choice NOT MATCHES "[123]" THEN
             NEXT FIELD choice
          END IF
          IF INT_FLAG THEN
             EXIT INPUT
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
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
#TQC-A10070 MARK AND ADD-----------------------------------------
  #LET g_sql = "SELECT DISTINCT azp01,azp03 FROM azp_file,zxy_file ",
  #             " WHERE zxy01 = '",g_user,"' ",
  #             "   AND zxy03 = azp01  "
   LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file ",
                " WHERE zxy01 = '",g_user,"' "
#TQC-A10070 MARK AND ADD----------------------------------------
   PREPARE q530_pre FROM g_sql
   DECLARE q530_DB_cs CURSOR FOR q530_pre
   DELETE FROM temp_pmm09
  #FOREACH q530_DB_cs INTO g_azp01,g_dbs   #TQC-A10070 MARK
   FOREACH q530_DB_cs INTO g_azp01         #TQC-A10070 ADD
      #FUN-A50102 ---mark---str---  
      #LET g_plant_new = g_azp01            #TQC-A10070 ADD
      #CALL s_gettrandbs()                  #TQC-A10070 ADD
      #LET g_dbs = g_dbs_tra                #TQC-A10070 ADD
      #FUN-A50102 ---mark---end---

      LET g_sql=" INSERT INTO temp_pmm09 SELECT UNIQUE pmm09,pmmplant ",
                #" FROM ",s_dbstring(g_dbs),"pmm_file ", #FUN-A50102
                 " FROM ",cl_get_target_table(g_azp01, 'pmm_file'), #FUN-A50102
                " WHERE pmm18 !='X' AND ",tm.wc CLIPPED,
                " AND pmm09 != ' ' AND pmm09 IS NOT NULL ",
                " AND pmmplant='",g_azp01,"'",
                " AND ",tm.wc 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_azp01) RETURNING g_sql  #FUN-A50102          
      PREPARE pre_ins_temp FROM g_sql
      EXECUTE pre_ins_temp
   END FOREACH
  
   #去掉重复行
   LET g_sql = "DELETE FROM temp_pmm09 ",
               "  WHERE pmm09 NOT IN (SELECT pmm09 FROM temp_pmm09 ",
               "  WHERE pmm09 in (SELECT MIN(pmm09) ",
               "   FROM temp_pmm09 group by pmm09,pmmplant))"
   PREPARE pre_del_pmm FROM g_sql
   EXECUTE pre_del_pmm
   LET l_rows = SQLCA.sqlerrd[3]
 
   LET g_sql1=" SELECT UNIQUE pmm09,pmmplant",
              " FROM temp_pmm09 "
   PREPARE q530_prepare FROM g_sql1
   DECLARE q530_cs SCROLL CURSOR FOR q530_prepare
 
   LET g_sql2=" SELECT COUNT(UNIQUE pmm09||pmmplant) FROM temp_pmm09 "
   PREPARE q530_pp  FROM g_sql2
   DECLARE q530_cnt   CURSOR FOR q530_pp
END FUNCTION
 
FUNCTION q530_menu()
 
   WHILE TRUE
      CALL q530_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q530_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "收貨明細查詢"
         WHEN "qry_receipts_details"
            CALL q530_detail()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q530_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q530_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0 RETURN
    END IF
    OPEN q530_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q530_cnt
       FETCH q530_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q530_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q530_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q530_cs INTO g_pmm.pmm09,g_azp01
        WHEN 'P' FETCH PREVIOUS q530_cs INTO g_pmm.pmm09,g_azp01
        WHEN 'F' FETCH FIRST    q530_cs INTO g_pmm.pmm09,g_azp01
        WHEN 'L' FETCH LAST     q530_cs INTO g_pmm.pmm09,g_azp01
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            FETCH ABSOLUTE l_abso q530_cs INTO g_pmm.pmm09,g_azp01
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('Fetch error !',SQLCA.sqlcode,0)
       INITIALIZE g_pmm.* TO NULL  #TQC-6B0105
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
#TQC-A10070  MARK AND ADD--------------------------------
  # SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=g_azp01
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_azp01
    #CALL s_gettrandbs()
    #LET g_dbs = g_dbs_tra
    #FUN-A50102 ---mark---end---
#TQC-A10070  MARK AND ADD--------------------------------
    #LET g_sql="SELECT pmc03 FROM ",s_dbstring(g_dbs),"pmc_file WHERE pmc01 = '",g_pmm.pmm09,"'" #FUN-A50102
    LET g_sql="SELECT pmc03 FROM ",cl_get_target_table(g_azp01, 'pmc_file')," WHERE pmc01 = '",g_pmm.pmm09,"'" #FUN-A50102 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_azp01) RETURNING g_sql    #FUN-A50102
    PREPARE pmc03_cs FROM g_sql
    EXECUTE pmc03_cs INTO g_pmm.pmc03
    IF SQLCA.sqlcode THEN
       LET g_pmm.pmc03 = ' '
    END IF
 
    CALL q530_show()
END FUNCTION
 
FUNCTION q530_show()
   DISPLAY g_pmm.pmm09, g_pmm.pmc03 ,g_azp01 TO pmm09, pmc03,pmmplant
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO FORMONLY.choice
   END IF
 
   CALL q530_b_fill()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q530_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
    LET l_sql =
         "SELECT pmn01,pmn04,pmn33,pmn20,pmn83,pmn85,pmn80,pmn82,",
         "       pmn20-pmn50+pmn55,pmn07,pmn02",
        #" FROM  ",s_dbstring(g_dbs),"pmm_file,",s_dbstring(g_dbs),"pmn_file ", #FUN-A50102
         " FROM  ",cl_get_target_table(g_azp01, 'pmm_file'),",",cl_get_target_table(g_azp01, 'pmn_file'), #FUN-A50102
         " WHERE pmm01 = pmn01 AND (pmn20 - pmn50 +pmn55)>0 ",
         "   AND pmm09 = '",g_pmm.pmm09,"'",
         "   AND pmn16 <'6'"
    IF choice = '1' THEN
        LET l_sql = l_sql CLIPPED, "ORDER BY pmn01,pmn02 " CLIPPED #MOD-530016
    END IF
    IF choice = '2' THEN
        LET l_sql = l_sql CLIPPED, "ORDER BY pmn04,pmn33 " CLIPPED #MOD-530016
    END IF
    IF choice = '3' THEN
        LET l_sql = l_sql CLIPPED, "ORDER BY pmn33 " CLIPPED #MOD-530016
    END IF
    PREPARE q530_pb FROM l_sql
    DECLARE q530_bcs CURSOR FOR q530_pb
 
    CALL g_pmn.clear()
    CALL g_pmn02.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q530_bcs INTO g_pmn[g_cnt].*, g_pmn02[g_cnt]
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF g_pmn[g_cnt].rest < 0 THEN
           LET g_pmn[g_cnt].rest = 0
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q530_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q530_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q530_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q530_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q530_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q530_fetch('L')
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
         CALL q530_def_form()   #FUN-610006
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 收貨明細查詢
      ON ACTION qry_receipts_details
         LET g_action_choice="qry_receipts_details"
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
 
 
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION q530_detail()
DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
    IF cl_null (g_pmn[1].pmn01)  THEN
       CALL cl_err ('','apm-207',0)
       RETURN
    END IF
 
    LET l_ac  = ARR_CURR()
    LET l_sql = "artq512 '",g_pmn[l_ac].pmn01,"' ",g_pmn02[l_ac]
 
display 'fgl run:',l_sql
    CALL cl_cmdrun(l_sql)
END FUNCTION
 
#-----FUN-610006---------
FUNCTION q530_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
END FUNCTION
#No.FUN-870007
