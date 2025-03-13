# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axmq420.4gl
# Descriptions...: 訂單出貨發票查詢
# Date & Author..: 95/01/12 By Danny
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0045 04/11/16 By Smapmin 帳款客戶,送貨客戶,人員,部門開窗
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610129 06/01/24 By Rosayu 單身加帳單編號欄位
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-750149 07/06/13 By claire 單頭的訂單號碼空白時且單身仍只有一筆訂單出貨資料仍要帶出 
# Modify.........: No.MOD-760151 07/08/08 By claire (1)有 key出通單，出通單的單頭有key訂單單號
#                                                   (2)一張訂單分二次出貨，其中一張出貨單的單頭有key訂單單號
# Modify.........: No.TQC-790065 07/09/11 By lumxa 匯出Excel多出一空白行
# Modify.........: No.MOD-850190 08/05/20 By Smapmin 取消單身查詢功能
# Modify.........: No.TQC-860033 08/06/19 By claire 調整語法
# Modify.........: No.MOD-960096 09/07/07 By Smapmin 出貨單單頭沒打訂單,當出貨單單身有多筆時,會出現重複的資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-CC0096 12/12/19 By qirl 增加欄位顯示，增加開窗 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
                wc      LIKE type_file.chr1000,# Head Where condition  #No.FUN-680137 VARCHAR(500)                                              
                wc2     LIKE type_file.chr1000 # Body Where condition  #No.FUN-680137 VARCHAR(500)
        END RECORD,
    g_oea   RECORD
            oea01   LIKE oea_file.oea01,
            oea02   LIKE oea_file.oea02,
            oea03   LIKE oea_file.oea03,
            oea032  LIKE oea_file.oea032,
            oea04   LIKE oea_file.oea04,
            occ02   LIKE occ_file.occ02,
            oea14   LIKE oea_file.oea14,
            gen02   LIKE gen_file.gen02,   #--TQC-CC0096-add--
            oea15   LIKE oea_file.oea15,
            gem02   LIKE gem_file.gem02,    #--TQC-CC0096-add--
            oea23   LIKE oea_file.oea23,
            oea21   LIKE oea_file.oea21,
            gec02   LIKE gec_file.gec02,   #--TQC-CC0096-add--
            oea31   LIKE oea_file.oea31,
            oah02   LIKE oah_file.oah02,  #--TQC-CC0096-add--
            oea32   LIKE oea_file.oea32,
            oag02   LIKE oag_file.oag02,  #--TQC-CC0096-add-
            oea61   LIKE oea_file.oea61,
            oea62   LIKE oea_file.oea62,
            oeaconf LIKE oea_file.oeaconf,
            oeahold LIKE oea_file.oeahold,
            oak02   LIKE oak_file.oak02    #--TQC-CC0096-add-
        END RECORD,
    g_oga DYNAMIC ARRAY OF RECORD
            oga02   LIKE oga_file.oga02,
            oga01   LIKE oga_file.oga01,
            oga50   LIKE oga_file.oga50,
            oma10   LIKE oma_file.oma10,
            oma54   LIKE oma_file.oma54,
            oma11   LIKE oma_file.oma11,
            oma55   LIKE oma_file.oma55, #TQC-610129
            oga10   LIKE oga_file.oga10  #TQC-610129
        END RECORD,
    g_argv1         LIKE oea_file.oea01,
    g_oga50_t       LIKE oga_file.oga50,
    g_oma54_t       LIKE oma_file.oma54,
    g_oma55_t       LIKE oma_file.oma55,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next #No.FUN-680137 SMALLINT 
     g_sql          STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10    #單身筆數       #No.FUN-680137 INTEGER
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5        #No.FUN-680137 SMALLINT
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0094
DEFINE          l_sl		LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
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
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q420_w AT p_row,p_col
        WITH FORM "axm/42f/axmq420"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q420_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q420_q() END IF
    CALL q420_menu()
    CLOSE WINDOW q420_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q420_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "oea01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_oga.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031    
   INITIALIZE g_oea.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea032,oea04,
                                      oea14,oea15,oea23,oea21,oea31,oea32,
                                      oea61,oea62,oeaconf,oeahold
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
              ON ACTION CONTROLP
           CASE
             WHEN INFIELD(oea03) #帳款客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03
             WHEN INFIELD(oea04) #送貨客戶   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea04
                  NEXT FIELD oea04
             WHEN INFIELD(oea14) #人員   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea14
                  NEXT FIELD oea14
             WHEN INFIELD(oea15) #部門   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gem"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea15
                  NEXT FIELD oea15
#---TQC-CC0096--add---
                   WHEN INFIELD(oea21)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_gec02"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea21
                        NEXT FIELD oea21
                   WHEN INFIELD(oeahold)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oeahold"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oeahold
                        NEXT FIELD oeahold
                   WHEN INFIELD(oea31)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oah"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea31
                        NEXT FIELD oea31
                   WHEN INFIELD(oea32)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oag"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea32
                        NEXT FIELD oea32
#--TQC-CC0096--add--end---
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
           #CALL q420_b_askkey()   #MOD-850190
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT oea01 FROM oea_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND oeaconf != 'X' " #01/08/15 mandy
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND oeauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY oea01"
 
   PREPARE q420_prepare FROM g_sql
   DECLARE q420_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q420_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(*) FROM oea_file ",
             " WHERE ",tm.wc CLIPPED,
             "   AND oeaconf != 'X' " #01/08/15 mandy
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND oeauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q420_pp  FROM g_sql
   DECLARE q420_cnt   CURSOR FOR q420_pp
END FUNCTION
 
FUNCTION q420_b_askkey()
   CONSTRUCT tm.wc2 ON oga02,oga01,oga50,oma10,oma54,oma11,oma55,oga10
                  FROM s_oga[1].oga02,s_oga[1].oga01,s_oga[1].oga50,
                       s_oga[1].oma10,s_oga[1].oma54,s_oga[1].oma11,
                       s_oga[1].oma55,s_oga[1].oga10                #TQC-610129
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
 
FUNCTION q420_menu()
 
   WHILE TRUE
      CALL q420_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q420_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oga),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q420_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q420_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q420_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q420_cnt
        FETCH q420_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q420_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q420_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q420_cs INTO g_oea.oea01
        WHEN 'P' FETCH PREVIOUS q420_cs INTO g_oea.oea01
        WHEN 'F' FETCH FIRST    q420_cs INTO g_oea.oea01
        WHEN 'L' FETCH LAST     q420_cs INTO g_oea.oea01
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
            FETCH ABSOLUTE g_jump q420_cs INTO g_oea.oea01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)
        INITIALIZE g_oea.* TO NULL  #TQC-6B0105
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
	SELECT oea01,oea02,oea03,oea032,oea04,'',oea14,'',oea15,'',oea23,oea21,'',
           oea31,'',oea32,'',oea61,oea62,oeaconf,oeahold,''    #---TQC-CC0096---add''
	  INTO g_oea.*
	  FROM oea_file
	 WHERE oea01 = g_oea.oea01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)  #No.FUN-660167
        CALL cl_err3("sel","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
 
    CALL q420_show()
END FUNCTION
 
FUNCTION q420_show()
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
   IF SQLCA.SQLCODE THEN LET g_oea.occ02=' ' END IF
   DISPLAY BY NAME g_oea.*   # 顯示單頭值
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO oeaconf
   END IF
#---TQC-CC0096---add--star---
   SELECT gen02 INTO g_oea.gen02 FROM gen_file WHERE gen01 = g_oea.oea14
   SELECT gem02 INTO g_oea.gem02 FROM gem_file WHERE gem01 = g_oea.oea15
   SELECT gec02 INTO g_oea.gec02 FROM gec_file WHERE gec01 = g_oea.oea21
   SELECT oah02 INTO g_oea.oah02 FROM oah_file WHERE oah01 = g_oea.oea31
   SELECT oag02 INTO g_oea.oag02 FROM oag_file WHERE oag01 = g_oea.oea32
   SELECT oak02 INTO g_oea.oak02 FROM oak_file WHERE oak01 = g_oea.oeahold
   DISPLAY g_oea.gen02 TO gen02
   DISPLAY g_oea.gem02 TO gem02
   DISPLAY g_oea.gec02 TO gec02
   DISPLAY g_oea.oah02 TO oah02
   DISPLAY g_oea.oag02 TO oag02
   DISPLAY g_oea.oak02 TO oak02
#---TQC-CC0096---add--end---
 
   CALL q420_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q420_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_sql2    LIKE type_file.chr1000       #MOD-760151 add
   DEFINE l_cnt     LIKE type_file.num10         #MOD-760151 add
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT oga02,oga01,oga50,oma10,oma54,oma11,oma55,oga10 ", #TQC-610129
        "  FROM oga_file,OUTER oma_file ",
        " WHERE oga16 = '",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND (oga09='2' OR oga09='3' OR oga09='4' OR oga09='6' OR oga09='8') ", #No.8347  #No.FUN-610020
        "  AND oga65='N' ",  #No.FUN-610020
        "   AND oga_file.oga01=oma_file.oma16 ",  #出貨單號
        "   AND ogaconf != 'X' ", #01/08/15 mandy
        " ORDER BY 1"
 
   #MOD-750149-begin-add
   #若客戶出貨單單頭未輸入訂單, 但出貨單身也僅有一筆 ( 一對一 )
    LET l_cnt = 0
   #MOD-760151 mark
   #SELECT COUNT(*) INTO l_cnt FROM oga_file WHERE oga16 = g_oea.oea01
   #IF g_cnt = 0  THEN 
   #MOD-760151 mark
       SELECT  COUNT(*) INTO l_cnt FROM oga_file,ogb_file
        WHERE  oga01 = ogb01
          AND  ogb31 = g_oea.oea01 
          AND  (oga09='2' OR oga09='3' OR oga09='4' OR oga09='6' OR oga09='8') 
          AND  oga16 is null   #MOD-760151 add
       IF l_cnt > 0 THEN 
          LET l_sql2 =    #TQC-860033 modify
               "SELECT DISTINCT oga02,oga01,oga50,oma10,oma54,oma11,oma55,oga10 ",    #MOD-960096   加上DISTINCT
               "  FROM oga_file,ogb_file,OUTER oma_file ",
               " WHERE ogb31 = '",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
               "   AND (oga09='2' OR oga09='3' OR oga09='4' OR oga09='6' OR oga09='8') ", 
               "  AND oga65='N' ",  
               "   AND oga_file.oga01=oma_file.oma16 ",  #出貨單號
               "   AND ogaconf != 'X' ", 
               "   AND oga01 = ogb01 ",
               "   AND oga16 IS NULL ",  #MOD-760151 add
               " ORDER BY 1"
              END IF 
   #END IF  #MOD-760151 mark 
   #MOD-750149-end-add
 
    PREPARE q420_pb FROM l_sql
    IF SQLCA.SQLCODE THEN CALL cl_err('q420_pb',STATUS,0) END IF
    DECLARE q420_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q420_pb
#TQC-790065--start--
#   FOR g_cnt = 1 TO g_oga.getLength()           #單身 ARRAY 乾洗
#      INITIALIZE g_oga[g_cnt].* TO NULL
#   END FOR
    CALL g_oga.clear()
#TQC-790065--end--
    LET g_cnt = 1
    LET g_oga50_t=0
    LET g_oma54_t=0
    LET g_oma55_t=0
    FOREACH q420_bcs INTO g_oga[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_oga[g_cnt].oga50 IS NULL THEN
  	       LET g_oga[g_cnt].oga50 = 0
        END IF
        IF g_oga[g_cnt].oma54 IS NULL THEN
  	       LET g_oga[g_cnt].oma54 = 0
        END IF
        IF g_oga[g_cnt].oma55 IS NULL THEN
  	       LET g_oga[g_cnt].oma55 = 0
        END IF
        LET g_oga50_t=g_oga50_t+g_oga[g_cnt].oga50
        LET g_oma54_t=g_oma54_t+g_oga[g_cnt].oma54
        LET g_oma55_t=g_oma55_t+g_oga[g_cnt].oma55
        IF cl_null(g_oga50_t) THEN LET g_oga50_t=0 END IF
        IF cl_null(g_oma54_t) THEN LET g_oma54_t=0 END IF
        IF cl_null(g_oma55_t) THEN LET g_oma55_t=0 END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
   #MOD-760151-begin-add
    IF l_cnt > 0 THEN 
    PREPARE q420_pb2 FROM l_sql2
    IF SQLCA.SQLCODE THEN CALL cl_err('q420_pb2',STATUS,0) END IF
    DECLARE q420_bcs2                       #BODY CURSOR
        CURSOR WITH HOLD FOR q420_pb2
    FOREACH q420_bcs2 INTO g_oga[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_oga[g_cnt].oga50 IS NULL THEN
  	       LET g_oga[g_cnt].oga50 = 0
        END IF
        IF g_oga[g_cnt].oma54 IS NULL THEN
  	       LET g_oga[g_cnt].oma54 = 0
        END IF
        IF g_oga[g_cnt].oma55 IS NULL THEN
  	       LET g_oga[g_cnt].oma55 = 0
        END IF
        LET g_oga50_t=g_oga50_t+g_oga[g_cnt].oga50
        LET g_oma54_t=g_oma54_t+g_oga[g_cnt].oma54
        LET g_oma55_t=g_oma55_t+g_oga[g_cnt].oma55
        IF cl_null(g_oga50_t) THEN LET g_oga50_t=0 END IF
        IF cl_null(g_oma54_t) THEN LET g_oma54_t=0 END IF
        IF cl_null(g_oma55_t) THEN LET g_oma55_t=0 END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    END IF
   #MOD-760151-end-add
    CALL g_oga.deleteElement(g_cnt)   #TQC-790065
    DISPLAY g_oga50_t,g_oma54_t,g_oma55_t TO oga50_t,oma54_t,oma55_t
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q420_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q420_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q420_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q420_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q420_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q420_fetch('L')
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
 
