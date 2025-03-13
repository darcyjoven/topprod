# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmq520.4gl
# Descriptions...: 採購單處理狀況查詢
# Date & Author..: 93/02/06  By  Felicity  Tseng
# Modify.........: 93/11/03  By Apple (不包含委外)
# Modify.........: 95/09/23  By Danny (Debug)
# Modify.........: 99/04/16  By Carol:modify s_pmmsta()
# Modify.........: No.MOD-480532 04/10/26 By Smapmin 拿掉PROMPT視窗
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.MOD-540052 05/04/27 By kim 查詢全部後無法按上下筆!ora可以,ifx不行
# Modify.........: No.FUN-570175 05/07/19 By Elva  新增雙單位內容
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-610098 06/10/24 By Rosayu q520_bw 再新增一視窗查詢 請款單號,請款數量,付款單號,付款類別,到期日
# Modify.........: No.FUN-630094 06/03/31 By Claire 入庫請款資料調整可顯示50筆
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-650167 06/07/24 By rainy 已結案之採購單在外量顯示為0
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0159 06/11/29 By Ray “匯出EXCEL”輸出的值多出一空白行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-860191 08/06/17 By Smapmin 在外量小於0時則以0顯示
# Modify.........: No.FUN-880095 08/08/27 By xiaofeizhu 加 action 預付請款資料 (call aapt150) 
# Modify.........: No.MOD-890169 08/09/18 By Smapmin 筆數計算有誤
# Modify.........: No.MOD-890191 08/09/19 By Smapmin 延續MOD-890169
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-940037 09/10/09 By chenmoyan 改'整張狀態'欄位為COMBOBOX
# Modify.........: No.MOD-9A0098 09/10/15 By Smapmin 為避免造成混淆,將rvb08加以隱藏
# Modify.........: No.FUN-A80150 10/09/14 By sabrina GP5.2號機管理
# Modify.........: No:MOD-AB0016 10/11/04 By Smapmin 入庫請款資料頁面多增加請款項次欄位
# Modify.........: No:MOD-AC0301 11/01/05 By Smapmin 結案否改由單身狀態碼來判斷
# Modify.........: No.TQC-B40071 11/04/13 By lilingyu "料號"欄位開窗第一頁資料全選,確定後報錯-404 
# Modify.........: No.MOD-C30371 12/03/12 By linlin  修改無法帶出單頭料號相關資訊
# Modify.........: No.MOD-C30472 12/03/14 By zhuhao pmn50_55 -> pmn50
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
       	wc  	STRING,  #No.FUN-680136 VARCHAR(500)     #TQC-B40071 chr1000->STRING
       	wc2  	STRING   #No.FUN-680136 VARCHAR(500)     #TQC-B40071 chr1000->STRING
        END RECORD,
    g_pmn   RECORD
            pmm01 LIKE pmm_file.pmm01,
            pmn02 LIKE pmn_file.pmn02,
            pmm04 LIKE pmm_file.pmm04,
            pmm02 LIKE pmm_file.pmm02,
            pmm25 LIKE pmm_file.pmm25,
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
            pmn919 LIKE pmn_file.pmn919,   #FUN-A80150 add
            pmn33 LIKE pmn_file.pmn33,
            pmn34 LIKE pmn_file.pmn34,
            pmn35 LIKE pmn_file.pmn35,
            rest  LIKE pmn_file.pmn20,
            pmn50 LIKE pmn_file.pmn50,     #MOD-C30472 pmn50_55 -> pmn50
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
DEFINE g_apb01      LIKE apb_file.apb01       #FUN-880095
DEFINE l_cmd        LIKE type_file.chr1000    #FUN-880095
 
MAIN
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_query_flag=1
 
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_argv2      = ARG_VAL(2)          # 參數值(2)
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q520_w AT p_row,p_col WITH FORM "apm/42f/apmq520"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("rvb08",FALSE)   #MOD-9A0098
 
    #-----FUN-610006---------
    CALL q520_def_form()
#   #FUN-570175  --begin
#   IF g_sma.sma115 ='N' THEN
#      CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
#      CALL cl_set_comp_visible("rvb80,rvb82,rvb83,rvb85",FALSE)
#   END IF
#   IF g_sma.sma122 ='1' THEN
#      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#   END IF
#   IF g_sma.sma122 ='2' THEN
#      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
#      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#      CALL cl_getmsg('asm-362',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
#      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#      CALL cl_getmsg('asm-363',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
#      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#   END IF
#   #FUN-570175  --end
    #-----END FUN-610006-----
    IF NOT cl_null(g_argv1) THEN CALL q520_q() END IF
    CALL q520_menu()
    CLOSE WINDOW q520_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q520_cs()                         # QBE 查詢資料
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmn01 = '",g_argv1,"'"
           IF g_argv2 IS NOT NULL AND g_argv2 != ' ' THEN
              LET tm.wc = tm.wc CLIPPED," AND pmn02 = ",g_argv2 CLIPPED
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
       pmm02, pmn41, pmm25,
       pmn04, pmn041,pmn16, pmn20, pmn07,
       pmn83, pmn85, pmn80, pmn82,   #FUN-570175
       pmn42, pmn61, pmn62, pmn919,   #FUN-A80150 add pmn919
       pmn34, pmn33, pmn35,
       pmn51, pmn53, pmn55, pmn58
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
     #FUN-530065
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
         OTHERWISE
            EXIT CASE
       END CASE
     #--
 
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
 
           CALL q520_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
           IF INT_FLAG THEN RETURN END IF
   END IF
   MESSAGE ' SEARGHING '
 
   IF tm.wc2 = " 1=1" THEN
      LET g_sql = " SELECT UNIQUE pmm01, pmn02 ",
                  " FROM pmm_file, pmn_file",
                  " WHERE pmn01 = pmm01 AND pmm18 !='X' AND ",tm.wc CLIPPED,
                  " ORDER BY pmm01"
   ELSE
      LET g_sql = " SELECT UNIQUE pmm01, pmn02 ",
                  " FROM pmm_file, pmn_file, rva_file, rvb_file ",
                  " WHERE pmn01 = pmm01 AND pmm18 !='X' AND ",tm.wc CLIPPED,
                  "   AND rvb03 = pmn02 AND rvb04 = pmn01 AND rva01 = rvb01 ",
                  "   AND rvaconf='Y' AND ", tm.wc2 CLIPPED,
                  " ORDER BY pmm01"
   END IF
   PREPARE q520_prepare FROM g_sql
   DECLARE q520_cs                          # SCROLL CURSOR
           SCROLL CURSOR FOR q520_prepare
 
   IF tm.wc2 = " 1=1" THEN
      LET g_sql = " SELECT COUNT(*) ",
                  " FROM pmm_file, pmn_file",
                  " WHERE pmn01 = pmm01 AND pmm18 !='X' AND ",tm.wc CLIPPED
 #                 " ORDER BY pmm01"  #MOD-540052
   ELSE
      #LET g_sql= " SELECT COUNT(DISTINCT pmm01,pmn02) ",# 取合乎條件筆數   #MOD-890169
      LET g_sql= " SELECT COUNT(DISTINCT pmm01||pmn02) ",# 取合乎條件筆數   #MOD-890169   #MOD-890191
                 "  FROM pmm_file, pmn_file, rva_file, rvb_file ",
                 " WHERE pmn01 = pmm01 AND pmm18 !='X' AND ",tm.wc CLIPPED,
                 "   AND rvb03 = pmn02 AND rvb04 = pmn01 AND rva01 = rvb01 ",
                 "   AND rvaconf='Y' AND ", tm.wc2 CLIPPED
   END IF
   PREPARE q520_pp FROM g_sql
   DECLARE q520_cnt CURSOR FOR q520_pp
 
END FUNCTION
 
FUNCTION q520_b_askkey()
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
 
FUNCTION q520_menu()
 
   WHILE TRUE
      CALL q520_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q520_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "料件靜態資料"
         WHEN "query_by_item_no"
            CALL q520_1()
         #@WHEN "入庫請款資料"
         WHEN "store_in_billing"
             CALL q520_2()
         #No.FUN-880095--Add--Begin--#    
         WHEN "prepay capital information"              
             LET l_cmd = "aapt150 '' '' '' '",g_pmm01,"'"   
             CALL cl_cmdrun(l_cmd)
         #No.FUN-880095--Add--End--#
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q520_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
#   DISPLAY '   ' TO FORMONLY.cnt
    CALL q520_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q520_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q520_cnt
        FETCH q520_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q520_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
	
MESSAGE ''
END FUNCTION
 
FUNCTION q520_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q520_cs INTO g_pmm01, g_pmn02
        WHEN 'P' FETCH PREVIOUS q520_cs INTO g_pmm01, g_pmn02
        WHEN 'F' FETCH FIRST    q520_cs INTO g_pmm01, g_pmn02
        WHEN 'L' FETCH LAST     q520_cs INTO g_pmm01, g_pmn02
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
            FETCH ABSOLUTE l_abso q520_cs INTO g_pmm01, g_pmn02
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
    END IF
 
    SELECT pmm01, pmn02, pmm04, pmm02, pmm25, pmm09,
           pmn04, pmn16, pmn42, pmn041, ima021, pmn20, pmn07,
           pmn83, pmn85, pmn80, pmn82, pmn41, pmn61, #FUN-570175
           pmn62, pmn919,pmn33, pmn34, pmn35,     #FUN-A80150 add pmn919
#          (pmn20-pmn50+pmn55), (pmn50-pmn55), pmn51, pmn53, pmn55,  pmc03,
        #  (pmn20-pmn50+pmn55+pmn58), pmn50, pmn51, pmn53, pmn55,  pmn58,pmc03,
        #No.+032 在外量不含倉退010424 by linda
#          (pmn20-pmn50+pmn55), pmn50, pmn51, pmn53, pmn55,  pmn58,pmc03,       #No.FUN-940083
           (pmn20-pmn50+pmn55+pmn58), pmn50, pmn51, pmn53, pmn55,  pmn58,pmc03, #No.FUN-940083
        #No.+032 end---
           pmm18,pmmmksg
	  INTO g_pmn.*, g_pmc03,g_pmm18,g_pmmmksg
	  FROM pmm_file, pmn_file, OUTER pmc_file,OUTER ima_file
	 WHERE pmm01 = pmn01 AND pmc_file.pmc01 = pmm_file.pmm09 AND pmn_file.pmn04=ima_file.ima01
       AND pmm01 = g_pmm01 AND pmn02 = g_pmn02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_pmm01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","pmm_file,pmn_file",g_pmm01,g_pmn02,SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF
    IF g_pmn.rest < 0 THEN LET g_pmn.rest = 0 END IF     #MOD-860191
    IF g_pmn.pmn61 = g_pmn.pmn04 THEN
       LET g_pmn.pmn61 = NULL
       LET g_pmn.pmn62 = NULL
    END IF
 
   #FUN-650167 --start
    #IF g_pmn.pmm25 = '6' THEN   #MOD-AC0301
    IF g_pmn.pmn16 MATCHES "[6789]" THEN   #MOD-AC0301
       Let g_pmn.rest = 0
    END IF
   #FUN-670167 --end
 
    CALL q520_show()
END FUNCTION
 
FUNCTION q520_show()
#  CALL s_pmmsta('pmm',g_pmn.pmm25,g_pmm18,g_pmmmksg) RETURNING g_cond #No.FUN-940037
   DISPLAY BY NAME g_pmn.*
#  DISPLAY g_pmc03, g_cond TO pmc03, explan   #No.FUN-940037
   DISPLAY g_pmc03 TO pmc03                   #No.FUN-940037
   CALL q520_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q520_1()
   DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(80)
   IF g_pmm01 IS NULL THEN RETURN END IF
#   LET l_cmd = "aimq102  '1' ",g_pmn.pmn04  # 料件編號   #No.MOD-C30371 MARK
   LET l_cmd = "aimq102  '1' ","'",g_pmn.pmn04,"'"       #No.MOD-C30371 add
   CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION q520_2()
   DEFINE i		LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE l_rvu00       LIKE rvu_file.rvu00
   DEFINE l_rvv DYNAMIC ARRAY OF RECORD
                rvv09 LIKE rvv_file.rvv09,
                rvv01 LIKE rvv_file.rvv01,
                rvv04 LIKE rvv_file.rvv04,
                rvb22 LIKE rvb_file.rvb22,
                rvv17 LIKE rvv_file.rvv17,
                apb01 LIKE apb_file.apb01,
                apb02 LIKE apb_file.apb02,   #MOD-AB0016
                apb09 LIKE apb_file.apb09
                END RECORD
   DEFINE l_t      LIKE type_file.num10   #No.FUN-680136 INTEGER
 
   IF g_pmm01 IS NULL THEN RETURN END IF
   DISPLAY g_pmm01
   DISPLAY g_pmn02
 
   DECLARE q320_2_c CURSOR FOR
                SELECT rvv09, rvv01, rvv04, rvb22, rvv17, apb01, apb02, apb09, rvu00   #MOD-AB0016 add apb02
                  FROM rvb_file, rvv_file,rvu_file, OUTER apb_file
                  WHERE rvb04 = g_pmm01 AND rvb03 = g_pmn02
                   AND rvv04 = rvb01 AND rvv05 = rvb02
                   AND rvv_file.rvv01 = apb_file.apb21 AND rvv_file.rvv02 = apb_file.apb22
                   AND rvv01 = rvu01 AND rvuconf='Y' AND rvu00!='2'
   LET i = 1
   LET p_row = 14 LET p_col = 2
   OPEN WINDOW q520_bw AT p_row,p_col
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
#     DISPLAY l_rvv[i].* TO s_rvv[i].*
      LET i = i + 1
     #FUN-630094-begin
     #IF i > 5 THEN EXIT FOREACH END IF  
        IF i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     #FUN-630094-end
   END FOREACH
 
 #MOD-480532
   DISPLAY ARRAY l_rvv TO s_rvv.*
     #FUN-610098 add
     BEFORE DISPLAY
 
     ON ACTION payment_qry
        LET l_t = ARR_CURR()
        CALL q520c(l_rvv[l_t].apb01,l_rvv[l_t].apb02,l_rvv[l_t].apb09)   #MOD-AB0016 add apb02
        CONTINUE DISPLAY
     #FUN-610098 end
 
   ON ACTION exit
      LET g_action_choice="exit"
      EXIT DISPLAY
 
   #TQC-860019-begin-add
    ON IDLE g_idle_seconds
       CALL cl_on_idle  ()
       CONTINUE DISPLAY
   #TQC-860019-end-add
 
   END DISPLAY
 
#       LET INT_FLAG = 0  ######add for prompt bug
 
#PROMPT "Press any key to continue:" FOR CHAR g_chr
#       ON IDLE g_idle_seconds
#       CALL cl_on_idle()
#       CONTINUE PROMPT
 
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
#
 #     ON ACTION help          #MOD-4C0121
 #        CALL cl_show_help()  #MOD-4C0121
#
 #     ON ACTION controlg      #MOD-4C0121
 #        CALL cl_cmdask()     #MOD-4C0121
#
#END PROMPT
 #END MOD-480532
 
  LET INT_FLAG = 0
  CLOSE WINDOW q520_bw
END FUNCTION
 
#FUN-610098 add
FUNCTION q520c(p_apb01,p_apb02,p_apb09)   #MOD-AB0016 add apb02
   DEFINE  p_apb01  LIKE apb_file.apb01
   DEFINE  p_apb02  LIKE apb_file.apb02   #MOD-AB0016
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
  OPEN WINDOW q520_c_w AT p_row,p_col WITH FORM "apm/42f/apmq520c"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("apmq520c")
 
   DECLARE q520c_t_c CURSOR FOR
          SELECT apb01,apb09,apg01,aph03,aph07
            FROM apb_file LEFT OUTER JOIN apg_file LEFT OUTER JOIN aph_file ON apg01 = aph01 ON apb01 = apg04
            WHERE apb01 = p_apb01 AND apb09 = p_apb09 AND apb02 = p_apb02    #MOD-AB0016 add apb02
 
   LET i = 1
 
   FOREACH q520c_t_c INTO l_apb[i].*
      IF STATUS THEN EXIT FOREACH END IF
      LET i = i + 1
   END FOREACH
 
   DISPLAY ARRAY l_apb TO s_apb.*
 
   ON ACTION exit
      LET g_action_choice = "exit"
      EXIT DISPLAY
   #TQC-860019-begin-add
    ON IDLE g_idle_seconds
       CALL cl_on_idle  ()
       CONTINUE DISPLAY
   #TQC-860019-end-add
   END DISPLAY
   LET INT_FLAG = 0
   CLOSE WINDOW q520_c_w
END FUNCTION
#FUN-610098 end
FUNCTION q520_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET l_sql =
        "SELECT rva06, rvb01, rvb02, rvb07, rvb83,rvb85,rvb80,rvb82,rvb08,", #FUN-570175
        " rvb29, rvb30, rvb31, rvb35",
        " FROM  rva_file, rvb_file",
        " WHERE rvb04 = '",g_pmm01,
        "' AND rvb03 = ",g_pmn02," AND ",
        "    rvb01 = rva01 AND rvaconf='Y' AND ",tm.wc2 CLIPPED,
        " ORDER BY rva06 "
    PREPARE q520_pb FROM l_sql
    DECLARE q520_bcs                       #BODY CURSOR
        CURSOR FOR q520_pb
    FOR g_cnt = 1 TO g_rvb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_rvb[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q520_bcs INTO g_rvb[g_cnt].*
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
    #No.TQC-6B0159 --begin
    CALL g_rvb.deleteElement(g_cnt)
    MESSAGE ""
    #No.TQC-6B0159 --end
    LET g_rec_b=g_cnt-1
         DISPLAY g_rec_b TO FORMONLY.cn2
#        LET g_cnt = 0
#        DISPLAY g_cnt   TO FORMONLY.cn3
END FUNCTION
 
FUNCTION q520_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q520_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q520_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q520_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q520_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q520_fetch('L')
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
         CALL q520_def_form()   #FUN-610006
 
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
         
   ON ACTION prepay_capital_information                         #FUN-880095
         LET g_action_choice = 'prepay capital information'     #FUN-880095
         EXIT DISPLAY                                           #FUN-880095
 
 
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
FUNCTION q520_def_form()
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
    CALL cl_set_comp_visible("pmn919",g_sma.sma1421='Y')   #FUN-A80150 add
END FUNCTION
#-----END FUN-610006-----
