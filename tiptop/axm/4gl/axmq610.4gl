# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmq610.4gl
# Descriptions...: 出貨單金額查詢
# Date & Author..: 95/01/12 By Nick
# Modify....2.0版: 95/11/06 By Danny (加接收出貨單號之參數)
# Modify.........: 96/02/09 By Danny  (q610_u()修改UPDATE oga_file )
# Modify.........: No.FUN-4A0022 93/10/04 By Yuna 出貨單號,通知單號,訂單單號,帳款客戶,業務人員要開窗
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-560175 05/06/29 By kim l_occ02 VARCHAR(10) -> 改用Like
# Modify.........: No.FUN-570175 05/07/21 By Elva  新增雙單位內容
# Modify.........: No.FUN-560175 05/09/07 By kim 由外部(axmt610)串的程式,傳入的參數是通知單號,這邊接收的卻是出貨單號,應該改為通知單號(oga011)
# Modify.........: No.MOD-590003 05/09/06 By jackie 修正幣別開窗錯誤
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-640007 06/04/06 By pengu 若單身輸入查詢條件時,則總筆數不正確
# Modify.........: No.TQC-640023 06/04/06 By pengu 單身無法下條件查詢
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-6C0108 06/12/22 By claire 出貨單(oga01)的qry應調整
# Modify.........: NO.CHI-710059 07/02/02 By jamie ogb14應為ogb917*ogb13
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860133 08/06/12 By Smapmin 由axmt610串入的單號可能為出通單或出貨單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 
# Modify.........: No:CHI-A70015 10/07/06 By Nicola 需考慮無訂單出貨
# Modify.........: No:TQC-BC0113 11/12/19 By SunLM  type_file.chr1000--->STRING
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
#                wc      LIKE type_file.chr1000,# Head Where condition  #No.FUN-680137 VARCHAR(500) TQC-BC0113 MARK
#                wc2     LIKE type_file.chr1000 # Body Where condition  #No.FUN-680137 VARCHAR(500) TQC-BC0113 MARK
            wc      STRING,
            wc2     STRING     
        END RECORD,        
    g_oga   RECORD  LIKE oga_file.*,
    g_ogb DYNAMIC ARRAY OF RECORD
            ogb03   LIKE ogb_file.ogb03,
            ogb31   LIKE ogb_file.ogb31,
            ogb32   LIKE ogb_file.ogb32,
            ogb08   LIKE ogb_file.ogb08,
            ogb09   LIKE ogb_file.ogb09,
            ogb091  LIKE ogb_file.ogb091,
            ogb092  LIKE ogb_file.ogb092,
            ogb04   LIKE ogb_file.ogb04,
            ogb05   LIKE ogb_file.ogb05,
            oeb13   LIKE oeb_file.oeb13,
            ogb13   LIKE ogb_file.ogb13,
            ogb12   LIKE ogb_file.ogb12,
            #FUN-570175  --begin
          #------------No.TQC-640023 modify
           #oeb916  LIKE oeb_file.oeb916,
           #oeb917  LIKE oeb_file.oeb917,
            ogb916  LIKE ogb_file.ogb916,
            ogb917  LIKE ogb_file.ogb917,
          #------------No.TQC-640023 end
            #FUN-570175  --end
            ogb60   LIKE ogb_file.ogb60,
            ogb63   LIKE ogb_file.ogb63,
            ogb64   LIKE ogb_file.ogb64,
            ogb14   LIKE ogb_file.ogb14,
            ogb14t  LIKE ogb_file.ogb14t
        END RECORD,
    g_ogb_t RECORD
            ogb03   LIKE ogb_file.ogb03,
            ogb31   LIKE ogb_file.ogb31,
            ogb32   LIKE ogb_file.ogb32,
            ogb08   LIKE ogb_file.ogb08,
            ogb09   LIKE ogb_file.ogb09,
            ogb091  LIKE ogb_file.ogb091,
            ogb092  LIKE ogb_file.ogb092,
            ogb04   LIKE ogb_file.ogb04,
            ogb05   LIKE ogb_file.ogb05,
            oeb13   LIKE oeb_file.oeb13,
            ogb13   LIKE ogb_file.ogb13,
            ogb12   LIKE ogb_file.ogb12,
            #FUN-570175  --begin
          #------------No.TQC-640023 modify
           #oeb916  LIKE oeb_file.oeb916,
           #oeb917  LIKE oeb_file.oeb917,
            ogb916  LIKE ogb_file.ogb916,
            ogb917  LIKE ogb_file.ogb917,
          #------------No.TQC-640023 end
            #FUN-570175  --end
            ogb60   LIKE ogb_file.ogb60,
            ogb63   LIKE ogb_file.ogb63,
            ogb64   LIKE ogb_file.ogb64,
            ogb14   LIKE ogb_file.ogb14,
            ogb14t  LIKE ogb_file.ogb14t
        END RECORD,
	g_argv1	    LIKE oga_file.oga01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
     g_sql          STRING, #WHERE CONDITION   #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10   #單身筆數         #No.FUN-680137 INTEGER
DEFINE p_row,p_col     LIKE type_file.num5           #No.FUN-680137 SMALLINT
DEFINE l_ac     	LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680137 INTEGER
#DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(72) #TQC-BC0113 MARK
DEFINE   g_msg          STRING  ##TQC-BC0113 ADD
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0094
 
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
    LET g_query_flag=1
    #95/11/06 by danny (接收出貨單號)
    LET g_argv1= ARG_VAL(1)
 
    LET g_forupd_sql = "SELECT * FROM oga_file WHERE oga01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q610_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q610_w AT p_row,p_col
         WITH FORM "axm/42f/axmq610"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-570175  --begin
    IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
       CALL cl_set_comp_visible("ogb916,ogb917",FALSE)
    END IF
    #FUN-570175  --end
#    IF cl_chk_act_auth() THEN
#       CALL q610_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q610_q() END IF
    CALL q610_menu()
    CLOSE WINDOW q610_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q610_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
	   IF NOT cl_null(g_argv1) THEN
     	           #LET tm.wc="oga01='",g_argv1,"'"  #FUN-560175   #MOD-860133 mark
                   LET tm.wc="(oga01='",g_argv1,"'"," OR ","oga011='",g_argv1,"')"    #MOD-860133
		   LET tm.wc2=" 1=1"
	   ELSE
           CLEAR FORM #清除畫面
   CALL g_ogb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_oga.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga021,oga011,oga16,oga03,
				  oga04,oga14,oga15,oga23,oga50,oga52,oga53,
  				  oga54,oga19,oga10
              #--No.FUN-4A0022--------
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
              ON ACTION CONTROLP
                 CASE WHEN INFIELD(oga01) #出貨單號
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
              	          #LET g_qryparam.form = "q_oga6"   #MOD-6C0108 mark
              	           LET g_qryparam.form = "q_oga8"   #MOD-6C0108 add
               	           CALL cl_create_qry() RETURNING g_qryparam.multiret
               	           DISPLAY g_qryparam.multiret TO oga01
               	           NEXT FIELD oga01
                      WHEN INFIELD(oga011) #通知單號
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_oga5"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oga011
                           NEXT FIELD oga011
                      WHEN INFIELD(oga03) #帳款客戶
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_occ"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oga03
                           NEXT FIELD oga03
                      WHEN INFIELD(oga14) #業務人員
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_gen"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oga14
                           NEXT FIELD oga14
                      WHEN INFIELD(oga16) #訂單單號
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_oea9"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oga16
                           NEXT FIELD oga16
                      #FUN-4B0050
#No.MOD-590003 --start--
                      WHEN INFIELD(oga23)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state="c"
                           LET g_qryparam.form ="q_azi"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oga23
                           NEXT FIELD oga23
#                      WHEN INFIELD(oga24)
#                           CALL s_rate(g_oga.oga23,g_oga.oga24) RETURNING g_oga.oga09
#                           DISPLAY BY NAME g_oga.oga24
#                           NEXT FIELD oga24
#No.MOD-590003 --end--
                      #FUN-4B0050(end)
 
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
           CALL q610_b_askkey()
           IF INT_FLAG THEN RETURN END IF
	   END IF
 
   MESSAGE ' WAIT '
   IF tm.wc2=' 1=1' OR cl_null(tm.wc2) THEN #FUN-560175
      LET g_sql=" SELECT oga01 FROM oga_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND oga09<>'1'",
                "   AND oga09<>'5' ",    #出貨通知單 #No.8347
                "   AND oga09<>'7' ",    #No.FUN-610020
                "   AND oga09<>'9' ",    #No.FUN-610020
                 "  AND oga65='N' ",  #No.FUN-610020
                "   AND ogaconf != 'X' " #01/08/20 mandy
   ELSE
      LET g_sql=" SELECT UNIQUE oga01 FROM oga_file,ogb_file ",
                " WHERE oga01=ogb01 ",
                "   AND ",tm.wc CLIPPED,
                "   AND ",tm.wc2 CLIPPED,
                "   AND oga09<>'1'",
                "   AND oga09<>'5' ",    #出貨通知單 #No.8347
                "   AND oga09<>'7' ",    #No.FUN-610020
                "   AND oga09<>'9' ",    #No.FUN-610020
                 "  AND oga65='N' ",  #No.FUN-610020
                "   AND ogaconf != 'X' " #01/08/20 mandy
   END IF
 
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
 
   PREPARE q610_prepare FROM g_sql
        IF SQLCA.sqlcode THEN
            CALL cl_err('q610_prepare:',SQLCA.sqlcode,1)
        END IF
   DECLARE q610_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q610_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
#--------------------------No.MOD-640007 modify
#  LET g_sql=" SELECT COUNT(*) FROM oga_file ",
#             " WHERE ",tm.wc CLIPPED,
#             "   AND oga09<>'1'",
#             "   AND oga09<>'5' ",    #出貨通知單 #No.8347
#             "   AND oga09<>'7' ",    #No.FUN-610020
#             "   AND oga09<>'9' ",    #No.FUN-610020
#                "  AND oga65='N' ",  #No.FUN-610020
#             "   AND ogaconf != 'X' " #01/08/20 mandy
   IF tm.wc2=' 1=1' OR cl_null(tm.wc2) THEN
      LET g_sql=" SELECT COUNT(*) FROM oga_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND oga09<>'1'",
                "   AND oga09<>'5' ",    #出貨通知單 #No.8347
                "   AND oga09<>'7' ",    
                "   AND oga09<>'9' ",    
                 "  AND oga65='N' ",     
                "   AND ogaconf != 'X' " #01/08/20 mandy
   ELSE
      LET g_sql=" SELECT COUNT(DISTINCT oga01) FROM oga_file,ogb_file ",
                " WHERE oga01=ogb01 ",
                "   AND ",tm.wc CLIPPED,
                "   AND ",tm.wc2 CLIPPED,
                "   AND oga09<>'1'",
                "   AND oga09<>'5' ",    #出貨通知單 #No.8347
                "   AND oga09<>'7' ",    
                "   AND oga09<>'9' ",    
                 "  AND oga65='N' ",     
                "   AND ogaconf != 'X' " #01/08/20 mandy
   END IF
#--------------------------No.MOD-640007 end
 
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
 
   PREPARE q610_pp  FROM g_sql
        IF SQLCA.sqlcode THEN
            CALL cl_err('prepare:q610_pp',SQLCA.sqlcode,1)
        END IF
   DECLARE q610_cnt   CURSOR FOR q610_pp
END FUNCTION
 
FUNCTION q610_b_askkey()
   #FUN-570175  --begin
      CONSTRUCT tm.wc2 ON ogb03,ogb31,ogb32,ogb08,ogb04,ogb05,
                          oeb13,ogb13,ogb12,ogb916,ogb917,ogb60,
                          ogb63,ogb64,ogb14,ogb14t
                     FROM s_ogb[1].ogb03,s_ogb[1].ogb31,s_ogb[1].ogb32,
                          s_ogb[1].ogb08,s_ogb[1].ogb04,s_ogb[1].ogb05,
                          s_ogb[1].oeb13,s_ogb[1].ogb13,s_ogb[1].ogb12,
                         #s_oga[1].ogb916,s_oga[1].ogb917,      #No.TQC-640023 mark
                          s_ogb[1].ogb916,s_ogb[1].ogb917,      #No.TQC-640023 add  
                          s_ogb[1].ogb60,s_ogb[1].ogb63,s_ogb[1].ogb64,
                          s_ogb[1].ogb14,s_ogb[1].ogb14t
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
 
FUNCTION q610_menu()
 
   WHILE TRUE
      CALL q610_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q610_q()
            END IF
         WHEN "detail"
            CALL q610_b()
            LET g_action_choice = ""
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "單頭修改"
         WHEN "modify_header"
            CALL q610_u()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q610_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q610_cnt
        FETCH q610_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q610_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q610_cs INTO g_oga.oga01
        WHEN 'P' FETCH PREVIOUS q610_cs INTO g_oga.oga01
        WHEN 'F' FETCH FIRST    q610_cs INTO g_oga.oga01
        WHEN 'L' FETCH LAST     q610_cs INTO g_oga.oga01
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
            FETCH ABSOLUTE g_jump q610_cs INTO g_oga.oga01
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
	SELECT  * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)  #No.FUN-660167
        CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
 
    CALL q610_show()
END FUNCTION
 
FUNCTION q610_show()
  #DEFINE l_occ02,l_gen02,l_gem02 VARCHAR(10)
   DEFINE l_occ02,l_gen02,l_gem02 LIKE occ_file.occ02 #FUN-560175
 
   DISPLAY BY NAME g_oga.oga01 ,
            g_oga.oga02 , g_oga.oga021, g_oga.oga011, g_oga.oga16 ,
            g_oga.oga03 , g_oga.oga032, g_oga.oga04 , g_oga.oga14 ,
            g_oga.oga15 , g_oga.oga23 , g_oga.oga24 , g_oga.oga21 ,
            g_oga.oga211, g_oga.oga212, g_oga.oga213, g_oga.oga50 ,
            g_oga.oga52 , g_oga.oga53 , g_oga.oga54 , g_oga.oga19,
            g_oga.oga10
   SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=g_oga.oga04
   IF SQLCA.SQLCODE THEN LET l_occ02=' ' END IF
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_oga.oga14
   IF SQLCA.SQLCODE THEN LET l_gen02=' ' END IF
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_oga.oga15
   IF SQLCA.SQLCODE THEN LET l_gem02=' ' END IF
   DISPLAY l_occ02 TO occ02 DISPLAY l_gem02 TO gem02 DISPLAY l_gen02 TO gen02
   CALL q610_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q610_b_fill()              #BODY FILL UP
#   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(1000) MARK TQC-BC0113
   DEFINE l_sql   STRING    #TQC-BC0113 ADD
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
   #FUN-570175  --begin
        "SELECT ogb03,ogb31,ogb32,ogb08,ogb09,ogb091,ogb092,ogb04,",
        "       ogb05,oeb13,ogb13,ogb12,ogb916,ogb917,ogb60,ogb63,",
        "       ogb64,ogb14,ogb14t",
   #FUN-570175  --end
        "  FROM ogb_file , OUTER oeb_file",
        " WHERE ogb01 = '",g_oga.oga01,"'"," AND ", tm.wc2 CLIPPED,
        "   AND ogb_file.ogb31=oeb_file.oeb01 AND ogb_file.ogb32=oeb_file.oeb03",
        " ORDER BY ogb03"
 
    PREPARE q610_pb FROM l_sql
        IF SQLCA.sqlcode THEN
            CALL cl_err('prepare:q610_pb',SQLCA.sqlcode,1)
        END IF
	
    DECLARE q610_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q610_pb
 
    CALL g_ogb.clear()
    LET g_cnt = 1
    FOREACH q610_bcs INTO g_ogb[g_cnt].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(g_ogb[g_cnt].ogb13) THEN LET g_ogb[g_cnt].ogb13 = 0 END IF
       IF cl_null(g_ogb[g_cnt].ogb14) THEN LET g_ogb[g_cnt].ogb14 = 0 END IF
       IF cl_null(g_ogb[g_cnt].ogb14t) THEN LET g_ogb[g_cnt].ogb14t= 0 END IF
       IF cl_null(g_ogb[g_cnt].ogb12) THEN LET g_ogb[g_cnt].ogb12 = 0 END IF
       IF cl_null(g_ogb[g_cnt].ogb60) THEN LET g_ogb[g_cnt].ogb60 = 0 END IF
       IF cl_null(g_ogb[g_cnt].ogb63) THEN LET g_ogb[g_cnt].ogb63 = 0 END IF
       IF cl_null(g_ogb[g_cnt].ogb64) THEN LET g_ogb[g_cnt].ogb64 = 0 END IF
       LET g_cnt = g_cnt + 1
 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
 
    END FOREACH
    CALL g_ogb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q610_fetch('L')
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
 
FUNCTION q610_u()
 
   BEGIN WORK
 
   OPEN q610_cl USING g_oga.oga01
 
   IF STATUS THEN
      CALL cl_err("OPEN q610_cl:", STATUS, 1)
      CLOSE q610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH q610_cl INTO g_oga.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE q610_cl ROLLBACK WORK RETURN
   END IF
 
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_oga.oga01
   IF cl_null(g_oga.oga01) THEN RETURN END IF
   #BugNo:5545
   IF NOT cl_null(g_oga.oga10) THEN
       CALL cl_err(g_oga.oga10,'axm-610',0)
       RETURN
   END IF
   INPUT BY NAME g_oga.oga24, g_oga.oga21
                 WITHOUT DEFAULTS
      AFTER FIELD oga21
          SELECT gec04,gec05,gec07
                   INTO g_oga.oga211,g_oga.oga212,g_oga.oga213
                   FROM gec_file WHERE gec01=g_oga.oga21
                                   AND gec011='2'  #銷項
          DISPLAY BY NAME g_oga.oga211,g_oga.oga212,g_oga.oga213
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   #Modify by danny 96/01/09
   UPDATE oga_file SET oga24=g_oga.oga24,
                       oga21=g_oga.oga21,
                       oga211=g_oga.oga211,
                       oga212=g_oga.oga212,
                       oga213=g_oga.oga213
    WHERE oga01=g_oga.oga01
   # Modify by WUPN 95/12/29 ---------------------
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
#       THEN CALL cl_err('update',SQLCA.SQLCODE,0)   #No.FUN-660167
         THEN CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","update",0)   #No.FUN-660167
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   #--------------------------------------------
END FUNCTION
 
FUNCTION q610_b()
DEFINE l_n,l_cnt       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否     #No.FUN-680137 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
 
    IF NOT cl_null(g_oga.oga10) THEN
       CALL cl_err(g_oga.oga10,'axm-610',0)
       RETURN
    END IF
 
    #FUN-570175  --begin
    LET g_forupd_sql = "SELECT ogb03,ogb31,ogb32,ogb08,ogb04,ogb05,'',ogb13,",
                       "       ogb12,ogb916,ogb917,ogb60,ogb63,ogb64,ogb14,''",
                       "  FROM ogb_file WHERE ogb01 = ?  AND ogb03 = ? FOR UPDATE"
    #FUN-570175  --end
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q610_bcl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ogb WITHOUT DEFAULTS FROM s_ogb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_ogb_t.* = g_ogb[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN q610_cl USING g_oga.oga01
            IF STATUS THEN
               CALL cl_err("OPEN q610_cl:", STATUS, 1) 
               CLOSE q610_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH q610_cl INTO g_oga.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE q610_cl
                ROLLBACK WORK
                RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               OPEN q610_bcl USING g_oga.oga01,g_ogb_t.ogb03
               IF STATUS THEN
                  CALL cl_err("OPEN q610_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH q610_bcl INTO g_ogb[l_ac].*  # 鎖住將被更改或取消的資料
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ogb[l_ac].ogb03,SQLCA.sqlcode,0) # 資料被他人LOCK
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT oeb13 INTO g_ogb[l_ac].oeb13 FROM oeb_file
                      WHERE oeb01 = g_ogb[l_ac].ogb31
                        AND oeb03 = g_ogb[l_ac].ogb32
                  END IF
	       END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
            NEXT FIELD ogb13
 
        AFTER FIELD ogb13
            IF g_oga.oga213 = 'N' THEN
              #LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb12 *g_ogb[l_ac].ogb13   #CHI-710059 mod
               LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb917*g_ogb[l_ac].ogb13   #CHI-710059 mod
               LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb14 *(1+g_oga.oga211/100)
            ELSE
              #LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb12 *g_ogb[l_ac].ogb13   #CHI-710059 mod 
               LET g_ogb[l_ac].ogb14t=g_ogb[l_ac].ogb917*g_ogb[l_ac].ogb13   #CHI-710059 mod
               LET g_ogb[l_ac].ogb14 =g_ogb[l_ac].ogb14t/(1+g_oga.oga211/100)
            END IF
 
            CALL cl_digcut(g_ogb[l_ac].ogb14,g_azi04) RETURNING g_ogb[l_ac].ogb14
            CALL cl_digcut(g_ogb[l_ac].ogb14t,g_azi04)RETURNING g_ogb[l_ac].ogb14t
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ogb[l_ac].* = g_ogb_t.*
              CLOSE q610_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ogb[l_ac].ogb03,-263,1)
              LET g_ogb[l_ac].* = g_ogb_t.*
           ELSE
              UPDATE ogb_file SET ogb13=g_ogb[l_ac].ogb13,
                                  ogb14=g_ogb[l_ac].ogb14,
                                  ogb14t=g_ogb[l_ac].ogb14t
               WHERE ogb01=g_oga.oga01
                 AND ogb03=g_ogb[l_ac].ogb03
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ogb[l_ac].ogb03,SQLCA.sqlcode,0)   #No.FUN-660167
                 CALL cl_err3("upd","ogb_file",g_oga.oga01,g_ogb[l_ac].ogb03,SQLCA.sqlcode,"","",0)   #No.FUN-660167
                 LET g_ogb[l_ac].* = g_ogb_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE q610_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ogb[l_ac].* = g_ogb_t.*
               CLOSE q610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET g_ogb_t.* = g_ogb[l_ac].*          # 900423
            CLOSE q610_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask() NEXT FIELD ogb13
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
 
    CALL q610_bu()
 
END FUNCTION
 
FUNCTION q610_bu()
   DEFINE l_oea61   LIKE oea_file.oea61    #No:FUN-A50103
   DEFINE l_oea1008 LIKE oea_file.oea1008  #No:FUN-A50103
   DEFINE l_oea261  LIKE oea_file.oea261   #No:FUN-A50103
   DEFINE l_oea262  LIKE oea_file.oea262   #No:FUN-A50103
   DEFINE l_oea263  LIKE oea_file.oea263   #No:FUN-A50103

   LET g_oga.oga50 = NULL
   SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file WHERE ogb01 = g_oga.oga01
   IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF

   #-----No:FUN-A50103-----
   SELECT oea61,oea1008,oea261,oea262,oea263
     INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
     FROM oea_file
    WHERE oea01 = g_oga.oga16

   #-----No:CHI-A70015-----
   IF STATUS THEN     #找不到訂單，表無訂單出貨
      LET l_oea61 = 100
      LET l_oea1008 = 100
      LET l_oea261 = 0
      LET l_oea262 = 100
      LET l_oea263 = 0
   END IF
   #-----No:CHI-A70015 END-----

   IF g_oga.oga213 = 'Y' THEN
      LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea1008
      LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea1008
   ELSE
      LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea61
      LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea61
   END IF
  #LET g_oga.oga52 = g_oga.oga50 * g_oga.oga161/100
  #LET g_oga.oga53 = g_oga.oga50 * (g_oga.oga162+g_oga.oga163)/100
   #-----No:FUN-A50103 END-----

   UPDATE oga_file SET oga50=g_oga.oga50,
                       oga52=g_oga.oga52,
                       oga53=g_oga.oga53
    WHERE oga01 = g_oga.oga01
# Modify by WUPN 95/12/29 ---------------------
   IF sqlca.sqlcode or sqlca.sqlerrd[3] = 0  THEN
      CALL cl_err('_bu():upd oga',SQLCA.SQLCODE,0)
      ROLLBACK WORK
   END IF
# --------------------------------------------
   DISPLAY BY NAME g_oga.oga50,g_oga.oga52,g_oga.oga53

END FUNCTION
