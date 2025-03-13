# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmq320.4gl
# Descriptions...: 驗收單處理狀況查詢
# Date & Author..: 93/02/05  By  Felicity  Tseng
# Modify.........: 加上單身部份(rvv_file)
# Modify.........: rvb06 已請款數量修改成(sum(rvv23))
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 單身筆數不對
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0159 06/11/29 By Ray “匯出EXCEL”輸出的值多出一空白行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0018 09/11/04 By wujie 5.2转SQL标准语法
# Modify.........: No.TQC-960320 10/03/04 By veaxlu 筆數選取時單身下條件和單身沒有下條件應不一樣
# Modify.........: No.MOD-C30485 12/03/13 By linlin 查詢不能查詢料件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1  LIKE   rva_file.rva01,       # No.FUN-680136 VARCHAR(16)
    g_rva    RECORD LIKE rva_file.*,
    g_rvb    RECORD LIKE rvb_file.*,
    g_rest   LIKE   rvb_file.rvb07,
    g_rva01  LIKE   rva_file.rva01,
    g_rvb02  LIKE   rvb_file.rvb02,
    g_ima02  LIKE   ima_file.ima02,
    g_pmc03  LIKE   pmc_file.pmc03,
    g_pmn041 LIKE   pmn_file.pmn041,
    g_ima021 LIKE   ima_file.ima021,
    g_pmn07  LIKE   pmn_file.pmn07,
    g_rvv17_s LIKE  rvv_file.rvv17,
    g_cond    LIKE  ze_file.ze03,          # No.FUN-680136 VARCHAR(10) 
    g_wc,g_wc2      string,                #No.FUN-580092 HCN
    g_sql    string,                       #No.FUN-580092 HCN
    g_rvv DYNAMIC ARRAY OF RECORD
            rvu03   LIKE rvu_file.rvu03,
            rvu01   LIKE rvu_file.rvu01,
            rvv02   LIKE rvv_file.rvv02,
            str     LIKE ze_file.ze03,     # No.FUN-680136 VARCHAR(4) 
            rvv17   LIKE rvv_file.rvv17,
            rvv32   LIKE rvv_file.rvv32,
            rvv33   LIKE rvv_file.rvv33,
            rvv34   LIKE rvv_file.rvv34,
            rvv25   LIKE rvv_file.rvv25
        END RECORD,
    g_rec_b         LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03,     #No.FUN-680136 VARCHAR(72)
       l_ac         LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680136 SMALLINT
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-680136 INTEGER

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1= ARG_VAL(1)

    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_rva.* TO NULL
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q320_w AT p_row,p_col
         WITH FORM "apm/42f/apmq320"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_argv1 <> ' ' THEN CALL q320_q() END IF
    CALL q320_menu()
    CLOSE WINDOW q320_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q320_cs()
    CLEAR FORM
   CALL g_rvv.clear()
    IF g_argv1 <> ' ' THEN
       LET g_wc =" rva01='",g_argv1,"'"
       LET g_wc2=" 1=1"
     ELSE
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INITIALIZE g_rva01 TO NULL    #No.FUN-750051
   INITIALIZE g_rvb02 TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           rva01, rvb02, rvb04, rvb03, rvb05,
           rva05, rva06, rvb19, rvb18,
           rvb08, rvb07, rvb30,
           rvb29, rvb06
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
          WHEN INFIELD(rvb05)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_rvb.rvb05
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvb05
            NEXT FIELD rvb05
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
       #          LET g_wc = g_wc clipped," AND rvauser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
       #End:FUN-980030
 
       CALL q320_b_askkey()
    END IF
    IF g_wc2 = ' 1=1' THEN
	    LET g_sql="SELECT rva01,rvb02 ",
                      "  FROM rva_file,rvb_file ",        #組合出 SQL 指令
                      " WHERE rva01 = rvb01 AND rvaconf !='X' AND ",
                      g_wc CLIPPED,
                      " ORDER BY rva01"
	ELSE
	    LET g_sql="SELECT rva01,rvb02 ",
                      "  FROM rva_file,rvb_file,rvu_file,rvv_file ",  #組合出 SQL 指令
                      " WHERE rva01 = rvb01 AND ",g_wc CLIPPED,
                            " AND rvv04 = rvb01 ",
                            " AND rvv05 = rvb02 ",
                            " AND rvv01 = rvu01 ",
                            " AND rvaconf !='X' AND ",g_wc2 CLIPPED,
                      " ORDER BY rva01"
    END IF
    PREPARE q320_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q320_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q320_prepare
    IF g_wc2 = ' 1=1' THEN                    #No.TQC-960320
	LET g_sql=
	        "SELECT COUNT(*) ",
	        "   FROM rva_file,rvb_file ",
	        "  WHERE rvb01=rva01 AND rvaconf !='X' AND ",g_wc CLIPPED

#No.TQC-960320 --start---
    ELSE
       LET g_sql=
               "SELECT COUNT(*) ",
               "  FROM rva_file,rvb_file,rvu_file,rvv_file ",
               " WHERE rva01 = rvb01 AND ", g_wc CLIPPED,
               "   AND rvv04 = rvb01 ",
               "   AND rvv05 = rvb02 ",
               "   AND rvv01 = rvu01 ",
               "   AND rvaconf != 'X' AND ",g_wc2 CLIPPED,
               " ORDER BY rva01"
    END IF   
#No.TQC-960320 ---end--- 

    PREPARE q320_precount FROM g_sql
    DECLARE q320_count CURSOR FOR q320_precount
END FUNCTION
 
FUNCTION q320_menu()
 
   WHILE TRUE
      CALL q320_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q320_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "料件庫存資料"
         WHEN "item_inventory"
            CALL q320_1()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvv),'','')
            END IF
 
      END CASE
   END WHILE
      CLOSE q320_cs
END FUNCTION
 
FUNCTION q320_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q320_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_rvv.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
        OPEN q320_count
        FETCH q320_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q320_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)
        INITIALIZE g_rva.* TO NULL
    ELSE
        CALL q320_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q320_fetch(p_flrva)
    DEFINE
        p_flrva         LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1) 
        l_abso          LIKE type_file.num10         #No.FUN-680136 INTEGER
 
    CASE p_flrva
        WHEN 'N' FETCH NEXT     q320_cs INTO g_rva01,g_rvb02
        WHEN 'P' FETCH PREVIOUS q320_cs INTO g_rva01,g_rvb02
        WHEN 'F' FETCH FIRST    q320_cs INTO g_rva01,g_rvb02
        WHEN 'L' FETCH LAST     q320_cs INTO g_rva01,g_rvb02
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso q320_cs INTO g_rva01,g_rvb02
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)
       INITIALIZE g_rvb.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flrva
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    LET g_rest = 0
    SELECT * INTO g_rva.* FROM rva_file        # 先讀 rva_file
       WHERE rva01 = g_rva01
    IF SQLCA.sqlcode THEN INITIALIZE g_rva.* TO NULL END IF
 
    SELECT rvb_file.*,ima02 INTO g_rvb.*,g_ima02
#No.FUN-9B0018 --begin
      FROM rvb_file LEFT OUTER JOIN ima_file ON rvb05 = ima01
       WHERE rvb01 = g_rva01 AND rvb02 = g_rvb02
#     FROM rvb_file ,OUTER ima_file
#      WHERE rvb01 = g_rva01 AND rvb02 = g_rvb02
#        AND rvb_file.rvb05 = ima_file.ima01
#No.FUN-9B0018 --end 
    IF SQLCA.sqlcode THEN INITIALIZE g_rvb.* TO NULL END IF
 
    SELECT pmc03 INTO g_pmc03 FROM pmc_file WHERE pmc01 = g_rva.rva05
    IF SQLCA.sqlcode THEN LET g_pmc03 = NULL END IF
 
    SELECT pmn041,pmn07 INTO g_pmn041,g_pmn07 FROM pmn_file
           WHERE pmn01 = g_rvb.rvb04 AND pmn02 = g_rvb.rvb03
    SELECT ima021 INTO g_ima021 FROM ima_file
           WHERE ima01 = g_rvb.rvb05
    IF SQLCA.sqlcode THEN LET g_pmn041 = NULL LET g_pmn07 = NULL END IF
 
    CALL q320_show()                           # 顯示資料
END FUNCTION
 
FUNCTION q320_b_askkey()
   CONSTRUCT g_wc2 ON rvu03,rvu01,rvv02,str,rvv17,rvv32,rvv33,rvv34,rvv25
        FROM s_rvv[1].rvu03,s_rvv[1].rvu01,s_rvv[1].rvv02,s_rvv[1].str,
             s_rvv[1].rvv17,s_rvv[1].rvv32,s_rvv[1].rvv33,s_rvv[1].rvv34,
             s_rvv[1].rvv25
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
 
FUNCTION q320_show()
 DEFINE l_str            LIKE ze_file.ze03                 # No.FUN-680136 VARCHAR(4) 
 
     DISPLAY BY NAME g_rva.rva01, g_rvb.rvb02, g_rva.rva05, g_rvb.rvb04,
       g_rvb.rvb03, g_rva.rva06, g_rvb.rvb05, g_rvb.rvb19, g_rvb.rvb08,
       g_rvb.rvb18, g_rvb.rvb07, g_rvb.rvb29, g_rvb.rvb30
 
     SELECT sum(rvv23) INTO g_rvb.rvb06 FROM rvv_file
                       WHERE rvv04 = g_rva.rva01
                         AND rvv05 = g_rvb.rvb02
                         AND rvv03 = '1'
    IF SQLCA.sqlcode THEN LET g_rvb.rvb06 = 0  END IF
     DISPLAY BY NAME g_rvb.rvb06
    IF g_rvb.rvb19 ='2' THEN LET g_pmn041 = g_ima02 END IF
    CALL s_iqctype (g_rvb.rvb18) RETURNING g_cond
    CALL s_subdes  (g_rvb.rvb19) RETURNING l_str
    SELECT sum(rvv17) INTO g_rvv17_s FROM rvv_file,rvu_file
                      WHERE rvu01=rvv01 AND rvu00='3' AND rvuconf='Y'
                        AND rvv04 = g_rva.rva01
                        AND rvv05 = g_rvb.rvb02
    LET g_rest=g_rvb.rvb07-g_rvb.rvb30-g_rvb.rvb29
    DISPLAY g_rest, g_pmc03, g_pmn041, g_pmn07, g_cond,l_str, g_ima021,g_rvv17_s
            TO rest, pmc03, pmn041, pmn07, explan,desc,ima021 ,rvv17_s
	CALL q320_b_fill()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q320_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(1000) #TQC-840066
          l_rvu00   LIKE rvu_file.rvu00
 
   LET l_sql = "SELECT rvu03,rvu01,rvv02,' ',rvv17,rvv32,rvv33,rvv34,rvv25,",
               "       rvu00 ",
                " FROM rvu_file,rvv_file",
               " WHERE rvv04 = '",g_rva01,"'",
	         " AND rvv05 = '",g_rvb02,"'",
                 " AND rvu01=rvv01 AND rvuconf='Y' ",
		 " AND ",g_wc2 CLIPPED,
               " ORDER BY 1,2,3 "
    PREPARE q320_pb FROM l_sql
    DECLARE q320_bcs                       #BODY CURSOR
        CURSOR FOR q320_pb
 
    FOR g_cnt = 1 TO g_rvv.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_rvv[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q320_bcs INTO g_rvv[g_cnt].*,l_rvu00
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF l_rvu00!='1' THEN
           LET g_rvv[g_cnt].rvv17=g_rvv[g_cnt].rvv17*(-1)
        END IF
        CASE
          WHEN l_rvu00='1'
               CALL cl_getmsg('apm-243',g_lang) RETURNING g_rvv[g_cnt].str
          WHEN l_rvu00='2'
               CALL cl_getmsg('apm-244',g_lang) RETURNING g_rvv[g_cnt].str
          WHEN l_rvu00='3'
               CALL cl_getmsg('apm-245',g_lang) RETURNING g_rvv[g_cnt].str
        END CASE
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #No.TQC-6B0159 --begin
    CALL g_rvv.deleteElement(g_cnt)
    MESSAGE ""
    #No.TQC-6B0159 --end
    LET g_rec_b=g_cnt-1
#No.TQC-5B0212 begin
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
#No.TQC-5B0212 end
#    DISPLAY g_cnt   TO FORMONLY.cn3
END FUNCTION
 
FUNCTION q320_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q320_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q320_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q320_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q320_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q320_fetch('L')
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
      #@ON ACTION 料件庫存資料
      ON ACTION item_inventory
         LET g_action_choice="item_inventory"
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
 
 
FUNCTION q320_1()
   DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(80)
 
   IF g_rva01 IS NULL THEN RETURN END IF
 #  LET l_cmd = "aimq102 '1' ",g_rvb.rvb05            # 料件編號  #No.MOD-C30485 MARK
      LET l_cmd = "aimq102 '1' ","'",g_rvb.rvb05,"'"  # 料件編號 #No.MOD-C30485 ADD
   CALL cl_cmdrun(l_cmd)
END FUNCTION
 
