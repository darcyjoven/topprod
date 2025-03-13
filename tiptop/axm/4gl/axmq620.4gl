# Prog. Version..: '5.30.06-13.03.19(00007)'     #
#
# Pattern name...: axmq620.4gl
# Descriptions...: 出貨前庫存明細查詢
# Date & Author..: 95/02/15 By Danny
# Modify.........: #No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-570175 05/07/21 By Elva  新增雙單位內容
# Modify.........: No.FUN-560175 05/09/07 By kim 由外部(axmt610)串的程式,傳入的參數是通知單號,這邊接收的卻是出貨單號,應該改為通知單號(oga011)
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-660167 06/06/23 By cl  cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790071 07/09/11 By lumxa 匯出Excel多一空白行
# Modify.........: No.MOD-860193 08/06/17 By Smapmin 查詢僅下單身條件時會有錯
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-D30173 13/03/19 By Vampire 清空 error 舊值，避免殘留上一筆資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
                wc      LIKE type_file.chr1000,# Head Where condition  #No.FUN-680137 VARCHAR(1000)                                              
                wc2     LIKE type_file.chr1000 # Body Where condition  #No.FUN-680137 VARCHAR(1000)
        END RECORD,
    g_buf   LIKE type_file.chr20,        #No.FUN-680137 VARCHAR(20) 
    g_oga   RECORD LIKE oga_file.*,
    g_ogb17 LIKE type_file.chr1,         #No.FUN-680137 VARCHAR(1)
    g_ogb DYNAMIC ARRAY OF RECORD
            ogb03   LIKE ogb_file.ogb03,
            ogb04   LIKE ogb_file.ogb04,
            ogb092  LIKE ogb_file.ogb092,
            ogb09   LIKE ogb_file.ogb09,
            ogb091  LIKE ogb_file.ogb091,
            ogb15   LIKE ogb_file.ogb15,
            ogb16   LIKE ogb_file.ogb16,
            img10   LIKE img_file.img10,
            #FUN-570175  --begin
            ogb913  LIKE ogb_file.ogb913,
            ogb915  LIKE ogb_file.ogb915,
            ogb910  LIKE ogb_file.ogb910,
            ogb912  LIKE ogb_file.ogb912,
            #FUN-570175  --end
            error   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(01)
        END RECORD,
    g_argv1         LIKE oga_file.oga01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
     g_sql          STRING,  #No.FUN-580092 HCN  
    g_rec_b  LIKE type_file.num10    #單身筆數    #No.FUN-680137 INTEGER
DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,  #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5      #No.FUN-680137 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5      #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0094
      DEFINE   l_sl   LIKE type_file.num5       #No.FUN-680137 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
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
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q620_w AT p_row,p_col
        WITH FORM "axm/42f/axmq620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #-----FUN-610006---------
    CALL q620_def_form()
#   #FUN-570175 --begin
#   IF g_sma.sma115 ='N' THEN
#      CALL cl_set_comp_visible("ogb910,ogb912,ogb913,ogb915",FALSE)
#   END IF
#   IF g_sma.sma122 ='1' THEN
#      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
#      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
#      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
#      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
#   END IF
#   IF g_sma.sma122 ='2' THEN
#      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
#      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
#      CALL cl_getmsg('asm-326',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
#      CALL cl_getmsg('asm-327',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
#   END IF
#   #FUN-570175 --end
    #-----END FUN-610006-----
#    IF cl_chk_act_auth() THEN
#       CALL q620_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q620_q() END IF
    CALL q620_menu()
    CLOSE WINDOW q620_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q620_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
     #THEN LET tm.wc = "oga01 = '",g_argv1,"'"  #FUN-560175
      THEN LET tm.wc="(oga01='",g_argv1,"'"," OR ","oga011='",g_argv1,"')" #FUN-560175
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_ogb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031	
   INITIALIZE g_oga.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON oga09,oga01,oga02,oga03,oga04,oga032,
                                      oga14,oga15,ogaconf,ogapost
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(oga03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga03
              NEXT FIELD oga03
           END IF
           IF INFIELD(oga04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga04
              NEXT FIELD oga04
           END IF
           IF INFIELD(oga14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga14
              NEXT FIELD oga14
           END IF
           IF INFIELD(oga15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oga15
              NEXT FIELD oga15
           END IF
 
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
           CALL q620_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   IF tm.wc2 = " 1=1" THEN   #MOD-860193
      LET g_sql=" SELECT oga01 FROM oga_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND ogaconf != 'X' " #01/08/20 mandy
   #-----MOD-860193---------
   ELSE
      LET g_sql=" SELECT UNIQUE oga01 FROM oga_file,ogb_file,OUTER img_file ",
                " WHERE oga01=ogb01",
                "   AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND ogaconf != 'X' ", 
                "   AND img_file.img01=ogb_file.ogb04 ",
                "   AND img_file.img02=ogb_file.ogb09 ",
                "   AND img_file.img03=ogb_file.ogb091 ",
                "   AND img_file.img04=ogb_file.ogb092 "
   END IF
   #-----END MOD-860193-----
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND ogauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY oga01"
 
   PREPARE q620_prepare FROM g_sql
   DECLARE q620_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q620_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF tm.wc2 = " 1=1" THEN   #MOD-860193
      LET g_sql=" SELECT COUNT(*) FROM oga_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND ogaconf != 'X' " #01/08/20 mandy
   #-----MOD-860193---------
   ELSE
      LET g_sql=" SELECT COUNT(DISTINCT oga01) FROM oga_file,ogb_file,OUTER img_file ",
                " WHERE oga01=ogb01",
                "   AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND ogaconf != 'X' ", 
                "   AND img_file.img01=ogb_file.ogb04 ",
                "   AND img_file.img02=ogb_file.ogb09 ",
                "   AND img_file.img03=ogb_file.ogb091 ",
                "   AND img_file.img04=ogb_file.ogb092 "
   END IF
   #-----END MOD-860193----- 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND ogauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q620_pp  FROM g_sql
   DECLARE q620_cnt   CURSOR FOR q620_pp
END FUNCTION
 
FUNCTION q620_b_askkey()
   #FUN-570175  --begin
   CONSTRUCT tm.wc2 ON ogb03,ogb04,ogb092,ogb09,ogb091,ogb15,ogb16,
                       img10,ogb913,ogb910
                  FROM s_ogb[1].ogb03,s_ogb[1].ogb04,s_ogb[1].ogb092,
                       s_ogb[1].ogb09,s_ogb[1].ogb091,s_ogb[1].ogb15,
                       s_ogb[1].ogb16,s_ogb[1].img10,s_ogb[1].ogb913,
                       s_ogb[1].ogb910
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
 
FUNCTION q620_menu()
 
   WHILE TRUE
      CALL q620_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q620_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q620_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q620_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q620_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q620_cnt
        FETCH q620_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q620_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q620_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q620_cs INTO g_oga.oga01
        WHEN 'P' FETCH PREVIOUS q620_cs INTO g_oga.oga01
        WHEN 'F' FETCH FIRST    q620_cs INTO g_oga.oga01
        WHEN 'L' FETCH LAST     q620_cs INTO g_oga.oga01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q620_cs INTO g_oga.oga01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
        INITIALIZE g_oga.* TO NULL  #TQC-6B0105
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
	SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)    #No.FUN-660167
        CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
 
    CALL q620_show()
END FUNCTION
 
FUNCTION q620_show()
   SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_oga.oga04
   IF SQLCA.SQLCODE THEN LET g_buf=' ' END IF
   DISPLAY g_buf TO occ02
   DISPLAY BY NAME g_oga.oga09,g_oga.oga01,g_oga.oga02,g_oga.oga03,g_oga.oga032,
                   g_oga.oga04,g_oga.oga14,g_oga.oga15,g_oga.ogaconf,
                   g_oga.ogapost
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      DISPLAY '!' TO ogaconf
      DISPLAY '!' TO ogapost
   END IF
   CALL q620_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q620_b_fill()                      #BODY FILL UP
   DEFINE t1  LIKE type_file.num5           #No.FUN-680137 SMALLINT 
   DEFINE t2 LIKE ima_file.ima01           #No.MOD-490217
   DEFINE t3  LIKE type_file.chr20          #No.FUN-680137 VARCHAR(20)
   DEFINE l_sql     LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(1000)
   DEFINE l_factor  LIKE ogb_file.ogb911
   DEFINE l_cnt     LIKE type_file.num5     #No.FUN-680137 SMALLINT
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
   #FUN-570175  --begin
        "SELECT ogb03,ogb04,ogb092,ogb09,ogb091,ogb15,ogb16,img10,",
        "       ogb913,ogb915,ogb910,ogb912,'',ogb17",
   #FUN-570175  --end
        "  FROM ogb_file,OUTER img_file ",
        " WHERE ogb01 = '",g_oga.oga01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND img_file.img01=ogb_file.ogb04 ",
        "   AND img_file.img02=ogb_file.ogb09 ",
        "   AND img_file.img03=ogb_file.ogb091 ",
        "   AND img_file.img04=ogb_file.ogb092 ",
        "   AND ",tm.wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE q620_pb FROM l_sql
    DECLARE q620_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q620_pb
 
    FOR g_cnt = 1 TO g_ogb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ogb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH q620_bcs INTO g_ogb[g_cnt].*, g_ogb17
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_ogb[g_cnt].error='' #MOD-D30173 add
#       IF cl_null(g_ogb[g_cnt].ogb16) THEN LET g_ogb[g_cnt].ogb16=0 END IF
#       IF cl_null(g_ogb[g_cnt].img10) THEN LET g_ogb[g_cnt].img10=0 END IF
        IF g_ogb[g_cnt].ogb16 > g_ogb[g_cnt].img10 OR
           g_ogb[g_cnt].ogb16 IS NULL OR
           g_ogb[g_cnt].img10 IS NULL THEN
           LET g_ogb[g_cnt].error='*'
        END IF
        IF g_ogb17='Y' THEN
           LET t1=g_ogb[g_cnt].ogb03
           LET t2=g_ogb[g_cnt].ogb04
           LET t3=g_ogb[g_cnt].ogb092
           DECLARE q620_bcs2 CURSOR FOR
              SELECT '','',ogc092,ogc09,ogc091,ogc15,ogc16,img10,''
                  FROM ogc_file,OUTER img_file
                 WHERE ogc01 = g_oga.oga01 AND ogc03 = t1
                   AND t2    = img01 AND ogc_file.ogc09 = img_file.img02
                   AND ogc_file.ogc091= img_file.img03 AND ogc_file.ogc092= img_file.img04
           FOREACH q620_bcs2 INTO g_ogb[g_cnt].*
              IF STATUS THEN EXIT FOREACH END IF
              LET g_ogb[g_cnt].error='' #MOD-D30173 add
              LET g_ogb[g_cnt].ogb03 = t1
              LET g_ogb[g_cnt].ogb04 = t2
              IF g_ogb[g_cnt].ogb16 > g_ogb[g_cnt].img10 OR
                 g_ogb[g_cnt].ogb16 IS NULL OR
                 g_ogb[g_cnt].img10 IS NULL THEN
                 LET g_ogb[g_cnt].error='*'
              END IF
              LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
           END FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_ogb.deleteElement(g_cnt)   #TQC-790071
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
        DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q620_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q620_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q620_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q620_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q620_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q620_fetch('L')
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
         CALL q620_def_form()   #FUN-610006
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
   ON ACTION exporttoexcel       #FUN-4B0038
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
 
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
 
#-----FUN-610006---------
FUNCTION q620_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("ogb910,ogb912,ogb913,ogb915",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-326',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-327',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
    END IF
END FUNCTION
#-----END FUN-610006-----
