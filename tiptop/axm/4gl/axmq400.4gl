# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmq400.4gl
# Descriptions...: 訂單查詢
# Date & Author..: 95/01/11 By Danny
# Modify.........: No.FUN-4A0015 04/10/05 By Yuna 帳款客戶.送貨客戶.訂單單號開窗
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-570175 05/07/20 By Elva  新增雙單位內容
# Modify.........: No.MOD-570253 05/08/11 By Rosayu oeb08=>no use
# Modify.........: No.FUN-560236 05/08/11 By Sarah 單頭帶出客戶單號
# Modify.........: No.FUN-610020 06/01/06 By Carrier 出貨驗收功能 -- 單身新增驗收欄位acc_q2/acc_q1/acc_q
# Modify.........: NO.TQC-610129 06/01/24 By Rosayu 串接axmq410 and axmq420
# Modify.........: No.FUN-610067 06/02/08 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-650087 06/07/07 By kim 新增列印功能
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE  
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760107 07/06/23 By claire 修改變數定義方式
# Modify.........: No.TQC-790065 07/09/11 By lumxa 匯出Excel多出一空白行
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D60024 13/06/24 By yangtt 1.留置原因(oeahold)新增開窗功能;
#                                                   2.單身添加品名(oeb06)、規格(ima021)、庫別名稱(imd02)、儲位名稱(ime03)欄位顯示
 
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
            oea04   LIKE oea_file.oea04,
            oea032  LIKE oea_file.oea032,
            occ02   LIKE occ_file.occ02,
            oea10   LIKE oea_file.oea10,   #FUN-560236
            oea14   LIKE oea_file.oea14,
            oea15   LIKE oea_file.oea15,
            oeaconf LIKE oea_file.oeaconf,
            oeahold LIKE oea_file.oeahold
        END RECORD,
    g_oeb DYNAMIC ARRAY OF RECORD
 
            oeb03   LIKE oeb_file.oeb03,
            oeb04   LIKE oeb_file.oeb04,
            oeb06   LIKE oeb_file.oeb06,   #TQC-D60024
            ima021  LIKE ima_file.ima021,  #TQC-D60024
            oeb12   LIKE oeb_file.oeb12,   #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb05   LIKE oeb_file.oeb05,
            #FUN-570175  --begin
            oeb913  LIKE oeb_file.oeb913,
            oeb915  LIKE oeb_file.oeb915,
            oeb910  LIKE oeb_file.oeb910,
            oeb912  LIKE oeb_file.oeb912,
            #FUN-570175  --end
            oeb23   LIKE oeb_file.oeb23,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            #No.FUN-610020  --Begin
            acc_q2  LIKE oeb_file.oeb912,
            acc_q1  LIKE oeb_file.oeb912,
            acc_q   LIKE oeb_file.oeb912,
            #No.FUN-610020  --End
            oeb24   LIKE oeb_file.oeb24,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb25   LIKE oeb_file.oeb25,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            unqty   LIKE oeb_file.oeb24,  #MOD-760107 modify type_file.num10,         #No.FUN-680137 INTEGER
            oeb15   LIKE oeb_file.oeb15,
            oeb16   LIKE oeb_file.oeb16,
             #oeb08   LIKE oeb_file.oeb08, #MOD-570253mark
            oeb09   LIKE oeb_file.oeb09,
            imd02   LIKE imd_file.imd02,   #TQC-D60024
            oeb091  LIKE oeb_file.oeb091,
            ime03   LIKE ime_file.ime03,   #TQC-D60024
            oeb092  LIKE oeb_file.oeb092,
            oeb70   LIKE oeb_file.oeb70
        END RECORD,
    g_argv1         LIKE oea_file.oea01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next #No.FUN-680137 SMALLINT
     g_sql LIKE type_file.chr1000,#WHERE CONDITION  #No.FUN-580092 HCN  #No.FUN-680137
    g_rec_b LIKE type_file.num10   #單身筆數        #No.FUN-680137 INTEGER
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5        #No.FUN-680137 SMALLINT
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0094
    DEFINE     l_sl	LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
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
 
    OPEN WINDOW q400_w AT p_row,p_col
        WITH FORM "axm/42f/axmq400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #-----FUN-610067---------
    CALL q400_def_form()
    #FUN-570175 --begin
#   IF g_sma.sma115 ='N' THEN
#      CALL cl_set_comp_visible("oeb910,oeb912,oeb913,oeb915",FALSE)
#      CALL cl_set_comp_visible("acc_q2,acc_q1",FALSE) #No.FUN-610020
#   END IF
#   IF g_sma.sma122 ='1' THEN
#      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
#      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
#      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
#      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
#      #No.FUN-610020  --Begin
#      CALL cl_getmsg('asm-411',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("acc_q2",g_msg CLIPPED)
#      CALL cl_getmsg('asm-412',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("acc_q1",g_msg CLIPPED)
#      #No.FUN-610020  --End
#   END IF
#   IF g_sma.sma122 ='2' THEN
#      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
#      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
#      CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
#      CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
#      #No.FUN-610020  --Begin
#      CALL cl_getmsg('asm-413',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("acc_q2",g_msg CLIPPED)
#      CALL cl_getmsg('asm-414',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("acc_q1",g_msg CLIPPED)
#      #No.FUN-610020  --End
#   END IF
    #FUN-570175 --end
    #-----END FUN-610067---------
#    IF cl_chk_act_auth() THEN
#       CALL q400_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q400_q() END IF
    CALL q400_menu()
 
    CLOSE WINDOW q400_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q400_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "oea01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_oeb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
#           CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,      #FUN-560236
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031   
   INITIALIZE g_oea.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,oea10, #FUN-560236
                                      oea14,oea15,oeahold,oeaconf
              #--No.FUN-4A0015--------
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
              ON ACTION CONTROLP
                 CASE WHEN INFIELD(oea03) #帳款客戶
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
              	           LET g_qryparam.form = "q_occ"
              	           CALL cl_create_qry() RETURNING g_qryparam.multiret
              	           DISPLAY g_qryparam.multiret TO oea03
              	           NEXT FIELD oea03
                      WHEN INFIELD(oea04) #送貨客戶
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_occ"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oea04
                           NEXT FIELD oea04
                      WHEN INFIELD(oea01) #訂單單號
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_oea6"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oea01
                           NEXT FIELD oea01
                      WHEN INFIELD(oea10) #客戶單號   #FUN-560236
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_oea10"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oea10
                           NEXT FIELD oea10
                      WHEN INFIELD(oea14)          #No.FUN-4B0043
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_gen"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oea14
                           NEXT FIELD oea14
                      WHEN INFIELD(oea15)           #No.FUN-4B0043
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_gem"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oea15
                           NEXT FIELD oea15
                    #TQC-D60024---add---str--
                     WHEN INFIELD(oeahold)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state= "c"
                           LET g_qryparam.form = "q_oak"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oeahold
                           NEXT FIELD oeahold
                     #TQC-D60024---add---end--
                       OTHERWISE
                           EXIT CASE
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
           CALL q400_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
  IF tm.wc2 = " 1=1" THEN
   LET g_sql=" SELECT oea01 FROM oea_file ",
             " WHERE oea00<>'0' AND ",tm.wc CLIPPED,
             "   AND oeaconf = 'Y' " #01/08/15 mandy
  ELSE
   LET g_sql=" SELECT UNIQUE oea01 FROM oea_file,oeb_file ",
             " WHERE oea01=oeb01 AND oea00<>'0' AND ",tm.wc CLIPPED,
             " AND ",tm.wc2 CLIPPED,
             "   AND oeaconf = 'Y' " #01/08/15 mandy
  END IF
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
 
   PREPARE q400_prepare FROM g_sql
   DECLARE q400_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q400_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
  IF tm.wc2 = " 1=1 " THEN
   LET g_sql=" SELECT COUNT(*) FROM oea_file ",
              " WHERE oea00<>'0' AND ",tm.wc CLIPPED,
              "   AND oeaconf = 'Y' " #01/08/15 mandy
  ELSE
   LET g_sql=" SELECT COUNT(DISTINCT oea01) FROM oea_file,oeb_file ",
              " WHERE oea01 = oeb01 AND oea00<>'0' AND ",tm.wc CLIPPED,
              " AND ",tm.wc2 CLIPPED,
              "   AND oeaconf = 'Y' " #01/08/15 mandy
  END IF
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
 
   PREPARE q400_pp  FROM g_sql
   DECLARE q400_cnt   CURSOR FOR q400_pp
END FUNCTION
 
FUNCTION q400_b_askkey()
   #FUN-570175  --begin
   CONSTRUCT tm.wc2 ON oeb03,oeb04,oeb12,oeb05,oeb913,oeb915,
                       oeb910,oeb912,oeb23,oeb24,oeb25,
                        #oeb15,oeb16,oeb08,oeb09,oeb091,oeb092,oeb70 #MOD-570253
                       oeb15,oeb16,      oeb09,oeb091,oeb092,oeb70 #BUg-570253
                  FROM s_oeb[1].oeb03,s_oeb[1].oeb04,s_oeb[1].oeb12,
                       s_oeb[1].oeb05,s_oeb[1].oeb913,s_oeb[1].oeb915,
                       s_oeb[1].oeb910,s_oeb[1].oeb912,
                       s_oeb[1].oeb23,s_oeb[1].oeb24,s_oeb[1].oeb25,
                       s_oeb[1].oeb15,s_oeb[1].oeb16,
                        #s_oeb[1].oeb08,s_oeb[1].oeb09,s_oeb[1].oeb091, #MOD-570253
                                        s_oeb[1].oeb09,s_oeb[1].oeb091, #MOD-570253
                       s_oeb[1].oeb092,s_oeb[1].oeb70
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
 
FUNCTION q400_menu()
 
   WHILE TRUE
      CALL q400_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q400_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #TQC-610129 add
         #WHEN 訂單出貨明細
         WHEN "ship_detail"
            CALL q400_1()
         #WHEN 訂單出貨發票
         WHEN "ship_invoice"
            CALL q400_2()
         #TQC-610129 end
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb),'','')
            END IF
         #FUN-650087...............begin
         WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL q400_out()
           END IF
         #FUN-650087...............end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q400_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q400_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q400_cnt
        FETCH q400_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q400_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q400_cs INTO g_oea.oea01
        WHEN 'P' FETCH PREVIOUS q400_cs INTO g_oea.oea01
        WHEN 'F' FETCH FIRST    q400_cs INTO g_oea.oea01
        WHEN 'L' FETCH LAST     q400_cs INTO g_oea.oea01
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
            FETCH ABSOLUTE g_jump q400_cs INTO g_oea.oea01
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
#start FUN-560236
#        SELECT oea01,oea02,oea03,oea04,oea032,'',oea14,oea15,oeaconf,oeahold
        SELECT oea01,oea02,oea03,oea04,oea032,'',oea10,oea14,oea15,oeaconf,oeahold
#end FUN-560236
	  INTO g_oea.*
	  FROM oea_file
	 WHERE oea01 = g_oea.oea01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
 
    CALL q400_show()
END FUNCTION
 
FUNCTION q400_show()
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
   IF SQLCA.SQLCODE THEN LET g_oea.occ02=' ' END IF
   DISPLAY BY NAME g_oea.*   # 顯示單頭值
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6'
      THEN
      DISPLAY '!' TO oeaconf
   END IF
   CALL q400_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#TQC-610129 add
 
FUNCTION q400_1()
    DEFINE l_cmd       LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(80)
    IF g_oea.oea01 IS NULL THEN RETURN END IF
    LET l_cmd = "axmq410 ",g_oea.oea01  # 訂單單號
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION q400_2()
    DEFINE l_cmd       LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(80)
    IF g_oea.oea01 IS NULL THEN RETURN END IF
    LET l_cmd = "axmq420 ",g_oea.oea01  # 訂單單號
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
#TQC-610129 end
 
FUNCTION q400_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT oeb03,oeb04,oeb06,'',oeb12,oeb05,oeb913,oeb915,oeb910,oeb912,oeb23,", #FUN-570175 #TQC-D60024 addoeb06,'',
        "       0,0,0,oeb24,oeb25*-1,(oeb12-oeb24+oeb25-oeb26),oeb15,oeb16,",#No.FUN-610020
        #"       oeb08,oeb09,oeb091,oeb092,oeb70", #MOD-570253
        #"             oeb09,oeb091,oeb092,oeb70", #MOD-570253   #TQC-D60024
         "             oeb09,'',oeb091,'',oeb092,oeb70", #MOD-570253   #TQC-D60024
        "  FROM oeb_file ",
        " WHERE oeb01 = '",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE q400_pb FROM l_sql
    DECLARE q400_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q400_pb
#TQC-790065---start---
#   FOR g_cnt = 1 TO g_oeb.getLength()           #單身 ARRAY 乾洗
#      INITIALIZE g_oeb[g_cnt].* TO NULL
#   END FOR
   CALL g_oeb.clear()
#TQC-790065--end--
    LET g_cnt = 1
    FOREACH q400_bcs INTO g_oeb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_oeb[g_cnt].oeb12 IS NULL THEN LET g_oeb[g_cnt].oeb12 = 0 END IF
        #FUN-570175  --begin
        IF NOT cl_null(g_oeb[g_cnt].oeb913) AND cl_null(g_oeb[g_cnt].oeb915) THEN
  	       LET g_oeb[g_cnt].oeb915 = 0
        END IF
        IF NOT cl_null(g_oeb[g_cnt].oeb910) AND cl_null(g_oeb[g_cnt].oeb912) THEN
  	       LET g_oeb[g_cnt].oeb912 = 0
        END IF
        #FUN-570175  --end
        IF g_oeb[g_cnt].oeb23 IS NULL THEN LET g_oeb[g_cnt].oeb23 = 0 END IF
        IF g_oeb[g_cnt].oeb24 IS NULL THEN LET g_oeb[g_cnt].oeb24 = 0 END IF
        IF g_oeb[g_cnt].oeb25 IS NULL THEN LET g_oeb[g_cnt].oeb25 = 0 END IF
        IF g_oeb[g_cnt].unqty IS NULL THEN LET g_oeb[g_cnt].unqty = 0 END IF
        #No.FUN-610020  --Begin
        SELECT SUM(ogb912),SUM(ogb915),SUM(ogb12)
          INTO g_oeb[g_cnt].acc_q1,g_oeb[g_cnt].acc_q2,g_oeb[g_cnt].acc_q
          FROM ogb_file,oga_file,oea_file,oeb_file
         WHERE ogb31 = g_oea.oea01 AND ogb32 = g_oeb[g_cnt].oeb03
           AND ogb01 = oga01
           AND oeb01 = oea01
           AND oeb01 = ogb31 AND oeb03 = ogb32
           AND oea65 = 'Y'
           AND ogaconf = 'Y' AND ogapost = 'Y'
           AND oga09 = '8'  
        IF cl_null(g_oeb[g_cnt].acc_q1) THEN LET g_oeb[g_cnt].acc_q1 = 0 END IF
        IF cl_null(g_oeb[g_cnt].acc_q2) THEN LET g_oeb[g_cnt].acc_q2 = 0 END IF
        IF cl_null(g_oeb[g_cnt].acc_q ) THEN LET g_oeb[g_cnt].acc_q  = 0 END IF
        #No.FUN-610020  --End
        #TQC-D60024---add---str--
        SELECT ima021 INTO g_oeb[g_cnt].ima021 FROM ima_file WHERE ima01 = g_oeb[g_cnt].oeb04
        SELECT imd02 INTO g_oeb[g_cnt].imd02 FROM imd_file WHERE imd01 = g_oeb[g_cnt].oeb09
        SELECT ime03 INTO g_oeb[g_cnt].ime03 FROM ime_file WHERE ime01 = g_oeb[g_cnt].oeb09
           AND ime02 = g_oeb[g_cnt].oeb091
        #TQC-D60024---add---end--
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_oeb.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL q400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q400_fetch('L')
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
         CALL q400_def_form()     #FUN-610067
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #TQC-610129 add
      #訂單出貨明細axmq410
      ON ACTION ship_detail
         LET g_action_choice ="ship_detail"
         EXIT DISPLAY
      #訂單出貨發票axmq420
      ON ACTION ship_invoice
         LET g_action_choice ="ship_invoice"
         EXIT DISPLAY
      #TQC-610129 end
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
 
      #FUN-650087...............begin
      ON ACTION output
         LET g_action_choice ="output"
         EXIT DISPLAY
      #FUN-650087...............end
 
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
 
#-----FUN-610067---------
FUNCTION q400_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("oeb910,oeb912,oeb913,oeb915",FALSE)
       CALL cl_set_comp_visible("acc_q2,acc_q1",FALSE) #No.FUN-610020
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       CALL cl_getmsg('asm-411',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acc_q2",g_msg CLIPPED)
       CALL cl_getmsg('asm-412',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acc_q1",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       CALL cl_getmsg('asm-413',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acc_q2",g_msg CLIPPED)
       CALL cl_getmsg('asm-414',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("acc_q1",g_msg CLIPPED)
    END IF
END FUNCTION
#-----END FUN-610067-----
 
#FUN-650087...............begin
FUNCTION q400_out()
DEFINE l_cmd,l_program,l_wc  STRING 
 
    LET l_program='axmr412'
    LET l_wc='oea01="',g_oea.oea01,'"'
   #LET l_wc="oea01='",g_oea.oea01,"'"
    LET l_cmd = l_program,
                " 'axmq400'",
                " '1'",
                " '",g_today,"'",
                " '",g_user,"'",
                " '",g_lang,"'",
                " 'Y'",
                " ' '",
                " '1'",
                " '",l_wc CLIPPED,"'"
    CALL cl_cmdrun_wait(l_cmd CLIPPED)
 
END FUNCTION
#FUN-650087...............end
