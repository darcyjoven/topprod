# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: artq512.4gl
# Descriptions...: 採購單處理狀況查詢
# Date & Author..: No.FUN-870007 09/02/17 By Zhangyajun 
# Memo...........: 由apmq520客制而來
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10061 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.TQC-AB0025 10/12/20 By chenying Sybase調整
# Modify.........: No.TQC-B10052 11/01/10 By zhangll 修正点击"入库请款资料"按钮,作业异常当出问题
# Modify.........: No.TQC-B30181 11/03/28 By lilingyu 增加顯示當前筆數欄位
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
       	wc  	LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(500)
       	wc2  	LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(500)
        END RECORD,
    g_pmn   RECORD
            pmm01 LIKE pmm_file.pmm01,
            pmn02 LIKE pmn_file.pmn02,
            pmm04 LIKE pmm_file.pmm04,
            pmm02 LIKE pmm_file.pmm02,
            pmm25 LIKE pmm_file.pmm25,
            pmmplant LIKE pmm_file.pmmplant,
            pmm09 LIKE pmm_file.pmm09,
            pmn04 LIKE pmn_file.pmn04,
            pmn16 LIKE pmn_file.pmn16,
            pmn42 LIKE pmn_file.pmn42,
            pmn041 LIKE pmn_file.pmn041,
            ima021 LIKE ima_file.ima021,
            pmn20 LIKE pmn_file.pmn20,
            pmn07 LIKE pmn_file.pmn07,
            #FUN-570175  --begin
            pmn83   LIKE pmn_file.pmn83,
            pmn85   LIKE pmn_file.pmn85,
            pmn80   LIKE pmn_file.pmn80,
            pmn82   LIKE pmn_file.pmn82,
            #FUN-570175  --end
            pmn41 LIKE pmn_file.pmn41,
            pmn61 LIKE pmn_file.pmn61,
            pmn62 LIKE pmn_file.pmn62,
            pmn33 LIKE pmn_file.pmn33,
            pmn34 LIKE pmn_file.pmn34,
            pmn35 LIKE pmn_file.pmn35,
            rest  LIKE pmn_file.pmn20,
            pmn50_55 LIKE pmn_file.pmn50,
            pmn51 LIKE pmn_file.pmn51,
            pmn53 LIKE pmn_file.pmn53,
            pmn55 LIKE pmn_file.pmn55,
            pmn58 LIKE pmn_file.pmn58
            END RECORD,
    g_pmm01 LIKE pmm_file.pmm01,
    g_pmm18 LIKE pmm_file.pmm18,
    g_pmmmksg LIKE pmm_file.pmmmksg,
    g_pmn02 LIKE pmn_file.pmn02,
    g_pmc03 LIKE pmc_file.pmc03,
    g_rest  LIKE pmn_file.pmn20,
    g_cond  LIKE ze_file.ze03,              #No.FUN-680136 VARCHAR(12)
    g_rvb DYNAMIC ARRAY OF RECORD
            rva06   LIKE rva_file.rva06,
            rvb01   LIKE rvb_file.rvb01,
            rvb02   LIKE rvb_file.rvb02,
            rvb07   LIKE rvb_file.rvb07,
            #FUN-570175  --begin
            rvb83   LIKE rvb_file.rvb83,
            rvb85   LIKE rvb_file.rvb85,
            rvb80   LIKE rvb_file.rvb80,
            rvb82   LIKE rvb_file.rvb82,
            #FUN-570175  --end
            rvb08   LIKE rvb_file.rvb08,
            rvb29   LIKE rvb_file.rvb29,
            rvb30   LIKE rvb_file.rvb30,
            rvb31   LIKE rvb_file.rvb31,
            rvb35   LIKE rvb_file.rvb35
        END RECORD,
    g_argv1         LIKE pmn_file.pmn01,      # INPUT ARGUMENT - 1
    g_argv2         LIKE pmn_file.pmn02,      # INPUT ARGUMENT - 2
    g_argv3         LIKE pmn_file.pmnplant,     # INPUT ARGUMENT - 3 
    g_query_flag    LIKE type_file.num5,      #No.FUN-680136 SMALLINT # 第一次進入程式時即進入Query之後進入next
    g_sql           string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_chr           LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
    g_rec_b         LIKE type_file.num5       # 單身筆數  #No.FUN-680136 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5       #No.FUN-680136 SMALLINT
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(72)
       l_ac         LIKE type_file.num5       #目前處理的ARRAY CNT   #No.FUN-680136 SMALLINT
DEFINE g_row_count  LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_cmd        LIKE type_file.chr1000    #FUN-610098 add        #No.FUN-680136 VARCHAR(100)
DEFINE g_pmmplant     LIKE pmm_file.pmmplant
 
MAIN
DEFINE  l_sl	    LIKE type_file.num5       #No.FUN-680136 SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1)       # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
         RETURNING g_time
    LET g_query_flag=1
 
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_argv2      = ARG_VAL(2)          # 參數值(2)
    LET g_argv3      = ARG_VAL(3)          # 值(3) 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q512_w AT p_row,p_col WITH FORM "art/42f/artq512"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL q512_def_form()
    IF NOT cl_null(g_argv1) THEN CALL q512_q() END IF
    CALL q512_menu()
    CLOSE WINDOW q512_w
      CALL cl_used(g_prog,g_time,2)       # 計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
        RETURNING g_time
END MAIN
 
FUNCTION q512_cs()                         # QBE 查詢資料
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE l_dbs LIKE azp_file.azp03
   DEFINE g_sql2 STRING 
   DEFINE g_chk_pmmplant LIKE type_file.chr1
   DEFINE g_chk_auth STRING 
   DEFINE l_zxy03 LIKE zxy_file.zxy03
   DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
   LET g_chk_pmmplant = TRUE 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmn01 = '",g_argv1,"'"
           IF g_argv2 IS NOT NULL AND g_argv2 != ' ' THEN
              LET tm.wc = tm.wc CLIPPED," AND pmn02 = ",g_argv2 CLIPPED
           END IF
           IF g_argv3 IS NOT NULL AND g_argv3 != ' ' THEN
              LET tm.wc = tm.wc CLIPPED," AND pmnplant = '",g_argv3 CLIPPED,"'"
              LET g_chk_pmmplant = FALSE
           END IF
		   LET tm.wc2=" 1=1 "
   ELSE CLEAR FORM                       # 清除畫面
   CALL g_rvb.clear()
       CALL cl_opmsg('q')
       INITIALIZE tm.* TO NULL			# Default condition
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmm01 TO NULL    #No.FUN-750051
   INITIALIZE g_pmn02 TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME tm.wc ON       # 螢幕上取單頭條件
       pmm01, pmn02, pmm04, pmm09,
       pmm02, pmn41, pmm25, pmmplant,     
       pmn04, pmn041,pmn16, pmn20, pmn07,
       pmn83, pmn85, pmn80, pmn82,   #FUN-570175
       pmn42, pmn61, pmn62,
       pmn34, pmn33, pmn35,
       pmn51, pmn53, pmn55, pmn58
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
     AFTER FIELD pmmplant
       IF get_fldbuf(pmmplant) IS NOT NULL THEN
          LET g_chk_pmmplant = FALSE
       END IF
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(pmn04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_pmn.pmn04
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pmn04
            NEXT FIELD pmn04
          WHEN INFIELD(pmmplant)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_pmn.pmmplant
            LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pmmplant
            NEXT FIELD pmmplant
         OTHERWISE
            EXIT CASE
       END CASE
 
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
 
           CALL q512_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
           IF INT_FLAG THEN RETURN END IF
   END IF
   MESSAGE ' SEARGHING '
   LET g_chk_auth = ''
   LET g_sql2 = ''
   IF g_chk_pmmplant THEN
      DECLARE q512_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q512_zxy_cs INTO l_zxy03
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
        IF g_chk_auth IS NULL THEN
           LET g_chk_auth = "'",l_zxy03,"'"
        ELSE
           LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
        END IF
      END FOREACH
      IF g_chk_auth IS NOT NULL THEN
         LET g_chk_auth = "(",g_chk_auth,")"
      END IF
   END IF
#TQC-A10061 MARK AND ADD START--------------------------------
  #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
  #             " WHERE zxy01 = '",g_user,"' ",
  #             "   AND zxy03 = azp01  "
  #IF g_argv3 IS NOT NULL THEN
  #   LET g_sql = g_sql," AND azp01 = '",g_argv3,"'"
  #END IF
   LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file ",
                " WHERE zxy01 = '",g_user,"' "
   IF g_argv3 IS NOT NULL THEN
      LET g_sql = g_sql," AND zxy03 = '",g_argv3,"'"
   END IF
#TQC-A10061 MARK AND ADD END --------------------------------
   PREPARE q512_pre FROM g_sql
   DECLARE q512_DB_cs CURSOR FOR q512_pre
  #FOREACH q512_DB_cs INTO l_dbs   #TQC-A10061 MARK
   FOREACH q512_DB_cs INTO l_zxy03 #TQC-A10061 ADD
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:q540_DB_cs',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
    #FUN-A50102 ---mark---str---
    #TQC-A10061 ADD----------------- 
     #LET g_plant_new = l_zxy03
     #CALL s_gettrandbs()
     #LET l_dbs = g_dbs_tra
    #TQC-A10061 END-----------------
    #FUN-A50102 ---mark---end---
     IF tm.wc2 = " 1=1" THEN
#       LET g_sql = "SELECT UNIQUE pmm01, pmn02,pmmplant ",  #TQC-AB0025 mark
        LET g_sql = "SELECT UNIQUE pmm01, pmn02,pmmplant ",  #TQC-AB0025 add
                   #" FROM ",s_dbstring(l_dbs),"pmm_file,",s_dbstring(l_dbs),"pmn_file", #FUN-A50102
                    " FROM ",cl_get_target_table(l_zxy03, 'pmm_file'),",",cl_get_target_table(l_zxy03, 'pmn_file'), #FUN-A50102
                    " WHERE pmn01 = pmm01 ",
                    "   AND pmnplant = pmmplant ",
                    "   AND pmm18 !='X' AND ",tm.wc CLIPPED
     ELSE
#       LET g_sql = "SELECT UNIQUE pmm01, pmn02 ,pmmplant ",   #TQC-AB0025 mark
        LET g_sql = "SELECT UNIQUE pmm01, pmn02 ,pmmplant ",   #TQC-AB0025 add
                    #" FROM ",s_dbstring(l_dbs),"pmm_file,",s_dbstring(l_dbs),"pmn_file,",  #FUN-A50102
                    #         s_dbstring(l_dbs),"rva_file,",s_dbstring(l_dbs),"rvb_file",   #FUN-A50102
                    " FROM ",cl_get_target_table(l_zxy03, 'pmm_file'),",",cl_get_target_table(l_zxy03, 'pmn_file'),",",    #FUN-A50102
                             cl_get_target_table(l_zxy03, 'rva_file'),",",cl_get_target_table(l_zxy03, 'rvb_file'),    #FUN-A50102
                    " WHERE pmn01 = pmm01 ",
                    "   AND pmnplant = pmmplant ",
                    "   AND pmm18 !='X' AND ",tm.wc CLIPPED,
                    "   AND rvb03 = pmn02 AND rvb04 = pmn01",
                    "   AND rvb930 = pmn930 AND rva01 = rvb01 ",
                    "   AND rva930 = rvb930 ",
                    "   AND rvaconf='Y' AND ", tm.wc2 CLIPPED
     END IF
     IF g_chk_pmmplant THEN
        LET g_sql = "(",g_sql," AND pmmplant IN ",g_chk_auth,")"
     ELSE
        LET g_sql = "(",g_sql,")"
     END IF
     IF g_sql2 IS NULL THEN
        LET g_sql2 = g_sql
     ELSE
        LET g_sql = g_sql2," UNION ALL ",g_sql
        LET g_sql2 = g_sql
     END IF
  END FOREACH 
    #CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    #CALL cl_parse_qry_sql(g_sql, l_zxy03) RETURNING g_sql    #FUN-A50102	
    PREPARE q512_prepare FROM g_sql
    DECLARE q512_cs                          # SCROLL CURSOR
            SCROLL CURSOR FOR q512_prepare
   LET g_sql = "SELECT COUNT(*) FROM (",g_sql,")" 
   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
   #CALL cl_parse_qry_sql(g_sql, l_zxy03) RETURNING g_sql    #FUN-A50102	
   PREPARE q512_pp FROM g_sql
   DECLARE q512_cnt CURSOR FOR q512_pp
 
END FUNCTION
 
FUNCTION q512_b_askkey()
   #FUN-570175  --begin
   CONSTRUCT tm.wc2 ON rva06,rvb01,rvb02,rvb07,rvb83,rvb85,rvb80,rvb82,
                       rvb08,rvb29,rvb30,rvb31,rvb35
        FROM s_rvb[1].rva06,s_rvb[1].rvb01,s_rvb[1].rvb02,
             s_rvb[1].rvb07,s_rvb[1].rvb83,s_rvb[1].rvb85,
             s_rvb[1].rvb80,s_rvb[1].rvb82,
             s_rvb[1].rvb08,s_rvb[1].rvb29,s_rvb[1].rvb30,
             s_rvb[1].rvb31,s_rvb[1].rvb35
   #FUN-570175  --end
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
 
FUNCTION q512_menu()
 
   WHILE TRUE
      CALL q512_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q512_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "料件靜態資料"
         WHEN "query_by_item_no"
            CALL q512_1()
         #@WHEN "入庫請款資料"
         WHEN "store_in_billing"
             CALL q512_2()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q512_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
#   DISPLAY '   ' TO FORMONLY.cnt
    CALL q512_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q512_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q512_cnt
        FETCH q512_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q512_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
	
MESSAGE ''
END FUNCTION
 
FUNCTION q512_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
    
    CASE p_flag
        WHEN 'N' FETCH NEXT     q512_cs INTO g_pmm01, g_pmn02 ,g_pmmplant
        WHEN 'P' FETCH PREVIOUS q512_cs INTO g_pmm01, g_pmn02 ,g_pmmplant
        WHEN 'F' FETCH FIRST    q512_cs INTO g_pmm01, g_pmn02 ,g_pmmplant
        WHEN 'L' FETCH LAST     q512_cs INTO g_pmm01, g_pmn02 ,g_pmmplant
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
            FETCH ABSOLUTE l_abso q512_cs INTO g_pmm01, g_pmn02,g_pmmplant
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pmm01,SQLCA.sqlcode,0)
        INITIALIZE g_pmn.* TO NULL  #TQC-6B0105
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
       DISPLAY g_curs_index TO FORMONLY.cnt1                       #TQC-B30181
    END IF
  #FUN-A50102 ---mark---str---
  #TQC-A10061 ADD-------------
  # SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01 = g_pmmplant
    #LET g_plant_new = g_pmmplant
    #CALL s_gettrandbs()
    #LET g_dbs = g_dbs_tra
  #TQC-A10061 END------------- 
  #FUN-A50102 ---mark---end---
    LET g_sql = "SELECT pmm01, pmn02, pmm04, pmm02, pmm25,pmmplant,pmm09,",
           "pmn04, pmn16, pmn42, pmn041, ima021, pmn20, pmn07,",
           "pmn83, pmn85, pmn80, pmn82, pmn41, pmn61,", #FUN-570175
           "pmn62, pmn33, pmn34, pmn35,",
           "(pmn20-pmn50+pmn55), pmn50, pmn51, pmn53, pmn55,  pmn58,pmc03,",
           "pmm18,pmmmksg",
	  #" FROM ",s_dbstring(g_dbs),"pmm_file,",s_dbstring(g_dbs),"pmn_file,", #FUN-A50102
    #      " OUTER ",s_dbstring(g_dbs),"pmc_file,OUTER ",s_dbstring(g_dbs),"ima_file", #FUN-A50102
    " FROM ",cl_get_target_table(g_pmmplant, 'pmm_file'),",",cl_get_target_table(g_pmmplant, 'pmn_file'),",", #FUN-A50102
           " OUTER ",cl_get_target_table(g_pmmplant, 'pmc_file'),", OUTER ",cl_get_target_table(g_pmmplant, 'ima_file'), #FUN-A50102      
	  " WHERE pmm01 = pmn01 AND pmc_file.pmc01 = pmm09 AND pmn04=ima_file.ima01",
          "  AND pmm01 = ? AND pmn02 = ? AND pmmplant = ?" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_pmmplant) RETURNING g_sql  #FUN-A50102      
    PREPARE q512_pmm_cs FROM g_sql
    EXECUTE q512_pmm_cs USING g_pmm01,g_pmn02,g_pmmplant
                        INTO g_pmn.*, g_pmc03,g_pmm18,g_pmmmksg
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pmm_file,pmn_file",g_pmm01,g_pmn02,SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF
    IF g_pmn.pmn61 = g_pmn.pmn04 THEN
       LET g_pmn.pmn61 = NULL
       LET g_pmn.pmn62 = NULL
    END IF
 
    IF g_pmn.pmm25 = '6' THEN
       Let g_pmn.rest = 0
    END IF
 
    CALL q512_show()
END FUNCTION
 
FUNCTION q512_show()
   CALL s_pmmsta('pmm',g_pmn.pmm25,g_pmm18,g_pmmmksg) RETURNING g_cond
   DISPLAY BY NAME g_pmn.*
   DISPLAY g_pmc03, g_cond TO pmc03, explan
   CALL q512_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q512_1()
   DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(80)
   IF g_pmm01 IS NULL THEN RETURN END IF
   LET l_cmd = "aimq102  '1' ",g_pmn.pmn04  # 料件編號
   CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION q512_2()
   DEFINE i		LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE l_rvu00       LIKE rvu_file.rvu00
   DEFINE l_rvv DYNAMIC ARRAY OF RECORD
                rvv09 LIKE rvv_file.rvv09,
                rvv01 LIKE rvv_file.rvv01,
                rvv04 LIKE rvv_file.rvv04,
                rvb22 LIKE rvb_file.rvb22,
                rvv17 LIKE rvv_file.rvv17,
                apb01 LIKE apb_file.apb01,
                apb02 LIKE apb_file.apb02,  #Add No.TQC-B10052
                apb09 LIKE apb_file.apb09
                END RECORD
   DEFINE l_t      LIKE type_file.num10   #No.FUN-680136 INTEGER
 
   IF g_pmm01 IS NULL THEN RETURN END IF
   DISPLAY g_pmm01
   DISPLAY g_pmn02
 
   LET g_sql = "SELECT rvv09, rvv01, rvv04, rvb22, rvv17, apb01, apb02,apb09, rvu00",  #Mod No.TQC-B10052 add apb02
               #"  FROM ",s_dbstring(g_dbs),"rvb_file,",s_dbstring(g_dbs),"rvu_file,",   #FUN-A50102
               #   s_dbstring(g_dbs),"rvv_file LEFT JOIN ",s_dbstring(g_dbs),"apb_file ", #FUN-A50102
               "  FROM ",cl_get_target_table(g_pmmplant, 'rvb_file'),",",cl_get_target_table(g_pmmplant, 'rvu_file'),",",    #FUN-A50102
                  cl_get_target_table(g_pmmplant, 'rvv_file')," LEFT JOIN ",cl_get_target_table(g_pmmplant, 'apb_file'), #FUN-A50102   
               "   ON rvv01=apb21 AND rvv02=apb22",
               " WHERE rvb04 = '",g_pmm01,"' AND rvb03 = '",g_pmn02,"'",
               "   AND rvv04 = rvb01 AND rvv05 = rvb02",
               "   AND rvv01 = rvu01 AND rvuconf='Y' AND rvu00!='2'"
   DECLARE q320_2_c CURSOR FROM g_sql
   LET i = 1
   LET p_row = 14 LET p_col = 2
   OPEN WINDOW q512_bw AT p_row,p_col
        WITH FORM "apm/42f/apmq520b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("apmq520b")
   CALL cl_load_act_list(NULL)   #FUN-610098 add
 
   FOREACH q320_2_c INTO l_rvv[i].*,l_rvu00
      IF STATUS THEN EXIT FOREACH END IF
      IF l_rvu00='3' THEN
         LET l_rvv[i].rvv17=l_rvv[i].rvv17*(-1)
         LET l_rvv[i].apb09=l_rvv[i].apb09*(-1)
      END IF
      LET i = i + 1
     #IF i > 5 THEN EXIT FOREACH END IF  
        IF i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
   END FOREACH
 
   DISPLAY ARRAY l_rvv TO s_rvv.*
     #FUN-610098 add
     BEFORE DISPLAY
 
     ON ACTION payment_qry
        LET l_t = ARR_CURR()
        CALL q512c(l_rvv[l_t].apb01,l_rvv[l_t].apb09)
        CONTINUE DISPLAY
     #FUN-610098 end
 
   ON ACTION exit
      LET g_action_choice="exit"
      EXIT DISPLAY
   END DISPLAY
 
  LET INT_FLAG = 0
  CLOSE WINDOW q512_bw
END FUNCTION
 
FUNCTION q512c(p_apb01,p_apb09)
   DEFINE  p_apb01  LIKE apb_file.apb01
   DEFINE  p_apb09  LIKE apb_file.apb09
   DEFINE  i        LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE  l_apb    DYNAMIC ARRAY OF RECORD
                    apb01   LIKE apb_file.apb01,
                    apb09   LIKE apb_file.apb09,
                    apg01   LIKE apg_file.apg01,
                    aph03   LIKE aph_file.aph03,
                    aph07   LIKE aph_file.aph07
                    END RECORD
 
  LET p_row = 14 LET p_col = 2
  OPEN WINDOW q512_c_w AT p_row,p_col WITH FORM "apm/42f/apmq520c"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("apmq520c")
   LET g_sql="SELECT apb01,apb09,apg01,aph03,aph07",
             #"  FROM ",s_dbstring(g_dbs),"apb_file LEFT JOIN ", #FUN-A50102
             #   s_dbstring(g_dbs),"apg_file ON apb01=apg04 LEFT JOIN ", #FUN-A50102
             #   s_dbstring(g_dbs),"aph_file ON apg01=aph01",     #FUN-A50102
             "  FROM ",cl_get_target_table(g_pmmplant, 'apb_file')," LEFT JOIN ", #FUN-A50102
                cl_get_target_table(g_pmmplant, 'apg_file')," ON apb01=apg04 LEFT JOIN ", #FUN-A50102
                cl_get_target_table(g_pmmplant, 'aph_file')," ON apg01=aph01",     #FUN-A50102   
             " WHERE apb01 = '",p_apb01,"' AND apb09 = '",p_apb09,"'"
   DECLARE q512c_t_c CURSOR FROM g_sql
   LET i = 1
 
   FOREACH q512c_t_c INTO l_apb[i].*
      IF STATUS THEN EXIT FOREACH END IF
      LET i = i + 1
   END FOREACH
 
   DISPLAY ARRAY l_apb TO s_apb.*
 
   ON ACTION exit
      LET g_action_choice = "exit"
      EXIT DISPLAY
   END DISPLAY
   LET INT_FLAG = 0
   CLOSE WINDOW q512_c_w
END FUNCTION
 
FUNCTION q512_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET l_sql =
        "SELECT rva06, rvb01, rvb02, rvb07, rvb83,rvb85,rvb80,rvb82,rvb08,", #FUN-570175
        " rvb29, rvb30, rvb31, rvb35",
        #" FROM  ",s_dbstring(g_dbs),"rva_file, ",s_dbstring(g_dbs),"rvb_file", #FUN-A50102
        " FROM  ",cl_get_target_table(g_pmmplant, 'rva_file'),",",cl_get_target_table(g_pmmplant, 'rvb_file'), #FUN-A50102
        " WHERE rvb04 = '",g_pmm01,
        "' AND rvb03 = ",g_pmn02," AND ",
        "    rvb01 = rva01 AND rvaconf='Y' AND ",tm.wc2 CLIPPED,
        " ORDER BY rva06 " 
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, g_pmmplant) RETURNING l_sql  #FUN-A50102    
    PREPARE q512_pb FROM l_sql
    DECLARE q512_bcs                       #BODY CURSOR
        CURSOR FOR q512_pb
    FOR g_cnt = 1 TO g_rvb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_rvb[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q512_bcs INTO g_rvb[g_cnt].*
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
    CALL g_rvb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q512_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q512_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q512_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q512_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q512_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q512_fetch('L')
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
         CALL q512_def_form()   #FUN-610006
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 料件查詢
      ON ACTION query_by_item_no
         LET g_action_choice="query_by_item_no"
         EXIT DISPLAY
      #@ON ACTION 入庫請款資料
      ON ACTION store_in_billing
         LET g_action_choice="store_in_billing"
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
 
#-----FUN-610006---------
FUNCTION q512_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
       CALL cl_set_comp_visible("rvb80,rvb82,rvb83,rvb85",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
       CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
       CALL cl_getmsg('asm-362',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
       CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
       CALL cl_getmsg('asm-363',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
       CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
    END IF
END FUNCTION
#No.FUN-870007
