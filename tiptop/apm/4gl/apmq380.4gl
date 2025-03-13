# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: apmq380.4gl
# Descriptions...: 供應商採購未交明細查詢作業
# Date & Author..: 93/06/10 By  Felicity  Tseng
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增廠商編號開窗
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-530016 05/03/24 By Mandy 排序項若選擇依 1.單號 時,單身之資料無法顯示.因為組l_sql時,LET l_sql = l_sql CLIPPED, "ORDER BY 1,8 " ---->有誤!無第8個欄位!
# Modify.........: No.FUN-570175 05/07/18 By Elva  新增雙單位內容
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0159 06/11/29 By Ray “匯出EXCEL”輸出的值多出一空白行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-910013 09/01/05 By sherry 只有在采購單發出后，未交明細中才可以查詢到該采購單 
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990062 09/09/22 By mike 請於料號(pmn04)之后增加品名(pmn041)    
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:CHI-A70024 10/07/13 By Summer 增加規格的顯示,位置放在品名之後
# Modify.........: No:MOD-CA0084 13/03/07 By jt_chen MISC*的料不存在ima_file時會印不出來,調整OUTER ima_file寫法,改為LEFT OUTER JOIN ima_file
# Modify.........: No:MOD-CC0046 13/03/07 By Vampire b_fill段的SQL outer join ima 應該是pmn04=ima01

DATABASE ds
 
GLOBALS "../../config/top.global"
 
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
    gtype            LIKE type_file.chr1, 
    gm               LIKE type_file.chr1,  
    g_pmn DYNAMIC ARRAY OF RECORD
            pmn01   LIKE pmn_file.pmn01, #採購單號
            pmn41   LIKE pmn_file.pmn41, #工单单号
            pmn04   LIKE pmn_file.pmn04, #料號
            pmn041  LIKE pmn_file.pmn041,#品名   #FUN-990062       
            ima021  LIKE ima_file.ima021,#規格   #CHI-A70024 add
            pmn18   LIKE pmn_file.pmn18, #run-card单号
            pmn78   LIKE pmn_file.pmn78, #作业编号
            ecd02   LIKE ecd_file.ecd02, #作业名称
            pmn33   LIKE pmn_file.pmn36, #交貨日
            pmm04   LIKE pmm_file.pmm04, #采购日期 #add by wangxt170411
            pmm09   LIKE pmm_file.pmm09, #供应商 #add by wangxt170411
            pmc031  LIKE pmc_file.pmc03, #供应商简称 #add by wangxt170411
            pmn20   LIKE pmn_file.pmn20, #訂購量
            sfbud10 LIKE sfb_file.sfbud10, #排版量 #add by wangxt170411
            pmn50   LIKE pmn_file.pmn50, #收货量
            pmn55   LIKE pmn_file.pmn55, #验退量
            pmn53   LIKE pmn_file.pmn53, #入库量
            #FUN-570175  --begin
            pmn83   LIKE pmn_file.pmn83,
            pmn85   LIKE pmn_file.pmn85,
            pmn80   LIKE pmn_file.pmn80,
            pmn82   LIKE pmn_file.pmn82,
            pmn201  LIKE type_file.num15_3,  #PNL 订购量/排版量 #add by wangxt170411
            #FUN-570175  --end
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


MAIN
   OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q380_w AT p_row,p_col
        WITH FORM "apm/42f/apmq380"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #-----FUN-610006---------
   CALL q380_def_form()
#  #FUN-570175  --begin
#  IF g_sma.sma115 ='N' THEN
#     CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
#  END IF
#  IF g_sma.sma122 ='1' THEN
#     CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#     CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#     CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#     CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#  END IF
#  IF g_sma.sma122 ='2' THEN
#     CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#     CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#     CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#     CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#  END IF
#  #FUN-570175  --end
   #-----END FUN-610006-----
 
#   OPEN FORM q380_srn FROM 'apm/42f/apmq380'
#   DISPLAY FORM q380_srn
#   FOR l_sl = 10 TO 21 STEP 1 DISPLAY "" AT l_sl,1 END FOR
    #IF cl_chk_act_auth() THEN
    #   CALL q380_q()
    #END IF
IF NOT cl_null(g_argv1) THEN CALL q380_q() END IF
    CALL q380_menu()
    CLOSE WINDOW q380_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q380_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "pmm09 = '",g_argv1,"'"
   ELSE CLEAR FORM #清除畫面
   CALL g_pmn.clear()
       CALL cl_opmsg('q')
       INITIALIZE tm.* TO NULL
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmm.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME tm.wc ON pmm09
          #--No.FUN-4B0022-------
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON ACTION CONTROLP
            CASE WHEN INFIELD(pmm09)      #廠商編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_pmc"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO pmm09
                      NEXT FIELD pmm09
            OTHERWISE EXIT CASE
            END CASE
          #--END---------------
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
   LET gtype = '1'
   LET gm = '1'
   INPUT BY NAME choice,gtype,gm WITHOUT DEFAULTS
       AFTER FIELD choice
          IF choice NOT MATCHES "[123]" THEN
             NEXT FIELD choice
          END IF
          IF INT_FLAG THEN
             EXIT INPUT
             RETURN
          END IF
       AFTER FIELD gtype
          IF gtype NOT MATCHES "[123]" THEN
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
   LET g_sql=" SELECT UNIQUE pmm09 ",
             " FROM pmm_file ",
             " WHERE pmm18 !='X' AND ",tm.wc CLIPPED,
             " AND pmm09 != ' ' AND pmm09 IS NOT NULL ",
             " ORDER BY pmm09"
   PREPARE q380_prepare FROM g_sql
   DECLARE q380_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q380_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(UNIQUE pmm09) FROM pmm_file ",
             " WHERE pmm18 !='X' AND ",tm.wc CLIPPED,
             " AND pmm09 != ' ' AND pmm09 IS NOT NULL "
   PREPARE q380_pp  FROM g_sql
   DECLARE q380_cnt   CURSOR FOR q380_pp
END FUNCTION
 
FUNCTION q380_menu()
 
   WHILE TRUE
      CALL q380_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q380_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "收貨明細查詢"
         WHEN "qry_receipts_details"
            CALL q380_detail()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q380_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q380_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0 RETURN
    END IF
    OPEN q380_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q380_cnt
       FETCH q380_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q380_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q380_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q380_cs INTO g_pmm.pmm09
        WHEN 'P' FETCH PREVIOUS q380_cs INTO g_pmm.pmm09
        WHEN 'F' FETCH FIRST    q380_cs INTO g_pmm.pmm09
        WHEN 'L' FETCH LAST     q380_cs INTO g_pmm.pmm09
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
            FETCH ABSOLUTE l_abso q380_cs INTO g_pmm.pmm09
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
    SELECT pmc03 INTO g_pmm.pmc03 FROM pmc_file WHERE pmc01 = g_pmm.pmm09
        IF SQLCA.sqlcode THEN
       LET g_pmm.pmc03 = ' '
    END IF
 
    CALL q380_show()
END FUNCTION
 
FUNCTION q380_show()
   DISPLAY g_pmm.pmm09, g_pmm.pmc03 TO pmm09, pmc03
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO FORMONLY.choice
   END IF
 
   CALL q380_b_fill()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q380_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
    LET l_sql =
        #FUN-570175  --begin
         "SELECT pmn01,pmn41,pmn04,pmn041,ima021,pmn18,pmn78,'',pmn33,pmm04,pmm09,'',pmn20,sfbud10,pmn50,pmn55,pmn53,pmn83,pmn85,pmn80,pmn82,", #FUN-990062 add pmn041 #CHI-A70024 add ima021 #add pmm04,pmm09,'',sfbud10 by wangxt170411
#        "       pmn20-pmn50+pmn55,pmn07,pmn02",          #No.FUN-940083
         "       pmn20/sfbud10,pmn20-pmn50+pmn55+pmn58,pmn07,pmn02",    #No.FUN-940083 #add pmn20/sfbud10 by wangxt170411
        #FUN-570175  --end
        #" FROM  pmm_file,pmn_file", #CHI-A70024 mark
        #" FROM  pmm_file,pmn_file,OUTER ima_file ", #CHI-A70024     #MOD-CA0084 mark
         " FROM  pmm_file,pmn_file LEFT OUTER JOIN ima_file ",      #MOD-CA0084 add
         #"   ON pmm04 = ima01 ",    #MOD-CA0084 add   #MOD-CC0046 mark
         "   ON pmn04 = ima01 ",     #MOD-CC0046 add
         "    LEFT JOIN sfb_file ON pmn41 = sfb01 ",#add by wangxt170411
#        " WHERE pmm01 = pmn01 AND (pmn20 - pmn50 +pmn55)>0 ",       #No.FUN-9A0068 mark
         #" WHERE pmm01 = pmn01 AND (pmn20 - pmn50 +pmn55+pmn58)>0 ", #No.FUN-9A0068
         " WHERE pmm01 = pmn01 ", #No.FUN-9A0068
         "   AND pmm09 = '",g_pmm.pmm09,"'",
         "   and ((sfb04 <> '8' and sfb01 is not null) or (sfb01 is null)) ", #darcy:2023/12/14
         "   AND pmm18 = 'Y'  "   #MOD-910013 add     
         #"   AND pmm18 = 'Y' AND pmm25 = '2' "   #MOD-910013 add      
        #"   AND pmn04=ima01 "  #CHI-A70024 add   #MOD-CA0084 mark
         #"   AND pmn16 <'6'"
   
    IF gtype ='2' THEN
       LET l_sql = l_sql CLIPPED," AND pmm02='REG'"
    END IF
    IF gtype ='3' THEN 
       LET l_sql = l_sql CLIPPED," AND pmm02='SUB'"
    END IF
    IF gm ='2' THEN 
       LET l_sql = l_sql CLIPPED," AND (pmn20 - pmn50 +pmn55+pmn58)>0 "
    END IF
    
    IF choice = '1' THEN
        LET l_sql = l_sql CLIPPED, "ORDER BY pmn01,pmn02 " CLIPPED #MOD-530016
    END IF
    IF choice = '2' THEN
        LET l_sql = l_sql CLIPPED, "ORDER BY pmn04,pmn33 " CLIPPED #MOD-530016
    END IF
    IF choice = '3' THEN
        LET l_sql = l_sql CLIPPED, "ORDER BY pmn33 " CLIPPED #MOD-530016
    END IF
    PREPARE q380_pb FROM l_sql
    DECLARE q380_bcs CURSOR FOR q380_pb
 
    CALL g_pmn.clear()
    CALL g_pmn02.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q380_bcs INTO g_pmn[g_cnt].*, g_pmn02[g_cnt]
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF g_pmn[g_cnt].rest < 0 THEN
           LET g_pmn[g_cnt].rest = 0
        END IF
        SELECT ecd02 INTO g_pmn[g_cnt].ecd02 FROM ecd_file WHERE ecd01=g_pmn[g_cnt].pmn78
        SELECT pmc03 INTO g_pmn[g_cnt].pmc031 FROM pmc_file WHERE pmc01 = g_pmn[g_cnt].pmm09 #add by wangxt170411
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #No.TQC-6B0159 --begin
    CALL g_pmn.deleteElement(g_cnt)
    MESSAGE ""
    #No.TQC-6B0159 --end
 
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q380_bp(p_ud)
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
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q380_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q380_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q380_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q380_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q380_fetch('L')
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
         CALL q380_def_form()   #FUN-610006
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
 
 
 
FUNCTION q380_detail()
DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
    IF cl_null (g_pmn[1].pmn01)  THEN
       CALL cl_err ('','apm-207',0)
       RETURN
    END IF
{
    IF INT_FLAG THEN RETURN END IF
    WHILE TRUE
#      OPEN WINDOW q380_ww AT 8,40
#           WITH 2 ROWS, 30 COLUMNS
       CALL cl_getmsg('apm-208',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT g_msg CLIPPED,':' FOR g_order
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
#             CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END PROMPT
       IF INT_FLAG THEN
          LET INT_FLAG = 0
#         CLOSE WINDOW q380_ww
          RETURN
       END IF
       IF g_order >= 1 AND g_order <= 100  THEN
          IF NOT cl_null(g_pmn[g_order].pmn01)  THEN
             EXIT WHILE
          END IF
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
#         CLOSE WINDOW q380_ww
          RETURN
       END IF
    END WHILE
}
 
#   LET l_sql = "apmq520 '",g_pmn[g_order].pmn01,"' '",g_pmn02[g_order],"'"
    LET l_ac  = ARR_CURR()
#   LET l_sql = "apmq520 '",g_pmn[l_ac].pmn01,"' ",1
    LET l_sql = "apmq520 '",g_pmn[l_ac].pmn01,"' ",g_pmn02[l_ac]
 
display 'fgl run:',l_sql
    CALL cl_cmdrun(l_sql)
#   CLOSE WINDOW q380_ww
END FUNCTION
 
#-----FUN-610006---------
FUNCTION q380_def_form()
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
#-----END FUN-610006-----
