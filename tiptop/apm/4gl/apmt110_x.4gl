# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmt110_x.4gl
# Descriptions...: 收貨驗收狀況
# Date & Author..: 03/04/22 By Mandy
# Modify.........: No.MOD-480453 Kammy 單身不可新增 or 刪除
# Modify.........: No.MOD-480163 Wiky 修改上下筆功能,查詢CURSOR ADD WITH HOLD
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-560132 收貨單號:1451-050600006已QC完成但無法產生入庫單 ,原因:rvb40輸入後沒有存到data
# Modify.........: No.FUN-570175 05/07/18 By Elva  新增雙單位內容
# Modify.........: No.FUN-580115 05/08/23 By Carrier 新增允收多單位rvb331/rvb332
# Modify.........: No.FUN-5A0179 05/11/02 By Sarah 修改允收數量,且大於原允收數量時,重計rvb29,rvb30,rvb09,rvb31
# Modify.........: No.FUN-5C0078 05/12/20 By day 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.MOD-610026 06/01/09 By Nicola 從其他程式進入時的權限控管
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-660129 06/06/19 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.CHI-6A0040 07/01/03 By jamie 原程式apmt110_x改為apmt110_x
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740124 07/04/18 By chenl  新增ora文件
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780158 07/08/28 By claire  調整sam886參數對此程式的使用
#                                                    sam886[6]='Y' AND sam886[8]='Y'=>只可開窗查,不可進入單身修改
#                                                    sam886[6]='Y' AND sam886[8]='N'=>可開窗查,不可進入單身修改
#                                                    sam886[6]='N' AND sam886[8]='Y'=>不可開窗查
#                                                    sam886[6]='N' AND sam886[8]='N'=>參數檔掉(asms250)
# Modify.........: No.TQC-7C0086 07/12/07 By Rayven 檢驗日期不可小于收貨日期
#                                                   點擊單身功能鈕不能進入單身時，右下角沒有提示信息
# Modify.........: No.MOD-7C0227 07/12/28 By claire 要考慮單頭沒有輸入採購單號應取單身採購單號
# Modify.........: No.MOD-8A0115 08/10/14 By Smapmin 控制允收數量(rvb33)不可低於{實收數(rvb07) - 入庫數(rvb30) - 驗退數(rvb29)}
# Modify.........: No.MOD-8B0054 08/11/06 By Smapmin 修正MOD-8A0115
# Modify.........: No.MOD-8C0080 08/12/09 By chenyu 所有數量都(包括未審核)已經入庫或驗退時，不可在修改允收數量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-970323 09/12/29 By baofei 欄位cn3不存在
# Modify.........: No:MOD-B40262 11/05/09 By Smapmin 若料件不需檢驗,則檢驗相關欄位不允許修改
# Modify.........: No:FUN-B30097 11/05/19 By wuxj  檢驗日期預設上一筆的日期
# Modify.........: No.FUN-BB0085 11/12/12 By xianghui 增加數量欄位小數取位
# Modify.........: No:MOD-BC0222 11/12/22 By suncx 檔單身第一筆為不需要檢驗，第二筆是需檢驗的時候點擊進入單身會直接跳出程序，報-8092的錯誤
# Modify.........: No:MOD-BC0236 11/12/22 By suncx MOD-BC0222漏改
# Modify.........: No:MOD-C50227 12/06/15 By Vampire 將FUNCTION t110_x_b()中MOD-B40262修改段移到BEFORE INPUT中

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
            wc      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500) # Head Where condition
       	    wc2     LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(500) # Body Where condition
        END RECORD,
    g_rva RECORD LIKE rva_file.*,
    g_rvb DYNAMIC ARRAY OF RECORD
            rvb02   LIKE rvb_file.rvb02,
            rvb05   LIKE rvb_file.rvb05,
            pmn041  LIKE pmn_file.pmn041,
            ima021  LIKE ima_file.ima021,
            pmn07   LIKE pmn_file.pmn07,
            rvb39   LIKE rvb_file.rvb39,
            rvb40   LIKE rvb_file.rvb40,
            rvb41   LIKE rvb_file.rvb41,
            rvb07   LIKE rvb_file.rvb07,
            #FUN-570175  --begin
            rvb83   LIKE rvb_file.rvb83,
            rvb85   LIKE rvb_file.rvb85,
            rvb80   LIKE rvb_file.rvb80,
            rvb82   LIKE rvb_file.rvb82,
            #FUN-570175  --end
            rvb33   LIKE rvb_file.rvb33,
            #No.FUN-580115  --begin
            rvb332  LIKE rvb_file.rvb332,
            rvb331  LIKE rvb_file.rvb331,
            #No.FUN-580115  --begin
            rvb30   LIKE rvb_file.rvb30,
            rvb29   LIKE rvb_file.rvb29
    END RECORD,
    g_rvb_t RECORD
            rvb02   LIKE rvb_file.rvb02,
            rvb05   LIKE rvb_file.rvb05,
            pmn041  LIKE pmn_file.pmn041,
            ima021  LIKE ima_file.ima021,
            pmn07   LIKE pmn_file.pmn07,
            rvb39   LIKE rvb_file.rvb39,
            rvb40   LIKE rvb_file.rvb40,
            rvb41   LIKE rvb_file.rvb41,
            rvb07   LIKE rvb_file.rvb07,
            #FUN-570175  --begin
            rvb83   LIKE rvb_file.rvb83,
            rvb85   LIKE rvb_file.rvb85,
            rvb80   LIKE rvb_file.rvb80,
            rvb82   LIKE rvb_file.rvb82,
            #FUN-570175  --end
            rvb33   LIKE rvb_file.rvb33,
            #No.FUN-580115  --begin
            rvb332  LIKE rvb_file.rvb332,
            rvb331  LIKE rvb_file.rvb331,
            #No.FUN-580115  --begin
            rvb30   LIKE rvb_file.rvb30,
            rvb29   LIKE rvb_file.rvb29
    END RECORD,
    g_rvb_o RECORD
            rvb02   LIKE rvb_file.rvb02,
            rvb05   LIKE rvb_file.rvb05,
            pmn041  LIKE pmn_file.pmn041,
            ima021  LIKE ima_file.ima021,
            pmn07   LIKE pmn_file.pmn07,
            rvb39   LIKE rvb_file.rvb39,
            rvb40   LIKE rvb_file.rvb40,
            rvb41   LIKE rvb_file.rvb41,
            rvb07   LIKE rvb_file.rvb07,
            #FUN-570175  --begin
            rvb83   LIKE rvb_file.rvb83,
            rvb85   LIKE rvb_file.rvb85,
            rvb80   LIKE rvb_file.rvb80,
            rvb82   LIKE rvb_file.rvb82,
            #FUN-570175  --end
            rvb33   LIKE rvb_file.rvb33,
            #No.FUN-580115  --begin
            rvb332  LIKE rvb_file.rvb332,
            rvb331  LIKE rvb_file.rvb331,
            #No.FUN-580115  --begin
            rvb30   LIKE rvb_file.rvb30,
            rvb29   LIKE rvb_file.rvb29
    END RECORD,
    g_argv1         LIKE rva_file.rva01,
    g_query_flag    LIKE type_file.num5,    #No.FUN-680136 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_sql           string,                 #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num10,   #No.FUN-680136 INTEGER  #單身筆數
    l_ac            LIKE type_file.num5    #No.FUN-680136 SMALLINT #目前處理的ARRAY CNT
DEFINE g_ima906     LIKE ima_file.ima906    #No.FUN-580115
DEFINE p_row,p_col  LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE g_msg        LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10    #No.FUN-680136 INTEGER 
DEFINE g_curs_index LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE g_jump       LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01     #No.FUN-580031 HCN
#CHI-6A0040
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
  #MOD-780158-begin-add
   IF g_sma.sma886[6]='N' THEN
      #參數設定,所以無法執行此支程式!
      CALL cl_err('','apm-066',1)
      EXIT PROGRAM
   END IF 
  #MOD-780158-end-add
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_rva.rva01  = g_argv1
    LET g_query_flag =1
 
    OPEN WINDOW t110_x_w WITH FORM "apm/42f/apmt110_x"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    #No.FUN-580115  --begin
    CALL cl_set_comp_visible("rvb331,rvb332",g_sma.sma115='Y')
    CALL cl_set_comp_visible("rvb33",g_sma.sma115='N')
    #No.FUN-580115  --end
 
    #-----FUN-610006---------
    CALL t110_x_def_form()
#   #FUN-570175  --begin
#   IF g_sma.sma115 ='N' THEN
#      CALL cl_set_comp_visible("rvb83,rvb85,rvb80,rvb82",FALSE)
#   END IF
#   IF g_sma.sma122 ='1' THEN
#      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
#      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
#      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
#      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
#      #No.FUN-580115  --begin
#      CALL cl_getmsg('asm-406',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb332",g_msg CLIPPED)
#      CALL cl_getmsg('asm-407',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb331",g_msg CLIPPED)
#      #No.FUN-580115  --end
#   END IF
#   IF g_sma.sma122 ='2' THEN
#      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
#      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
#      CALL cl_getmsg('asm-362',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
#      CALL cl_getmsg('asm-363',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
#      #No.FUN-580115  --begin
#      CALL cl_getmsg('asm-408',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb332",g_msg CLIPPED)
#      CALL cl_getmsg('asm-409',g_lang) RETURNING g_msg
#      CALL cl_set_comp_att_text("rvb331",g_msg CLIPPED)
#      #No.FUN-580115  --end
#   END IF
#   #FUN-570175  --end
    #-----END FUN-610006-----
 
    IF NOT cl_null(g_argv1) THEN
       CALL t110_x_q()
       #-----No.MOD-610026-----
       LET g_action_choice="detail"
       LET l_ac = 1
       IF cl_chk_act_auth() THEN
          CALL t110_x_b()
       ELSE
          LET g_action_choice = NULL
       END IF
       #-----No.MOD-610026-----
    END IF
 
    CALL t110_x_menu()
    CLOSE WINDOW t110_x_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION t110_x_cs()
   DEFINE   l_cnt LIKE type_file.num5     #No.FUN-680136 SMALLINT 
 
   IF NOT cl_null(g_argv1) THEN
       LET tm.wc = " rva01 = '",g_argv1,"'"
       LET tm.wc2= " 1=1 "
   ELSE
       CLEAR FORM #清除畫面
   CALL g_rvb.clear()
       CALL cl_opmsg('q')
       INITIALIZE tm.* TO NULL			# Default condition
       CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_rva.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME tm.wc ON rva01
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
       END CONSTRUCT
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
       #End:FUN-980030
 
       IF INT_FLAG THEN RETURN END IF
           CALL t110_x_b_askkey()
       IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
   IF tm.wc2 = " 1=1" THEN
       LET g_sql=" SELECT rva01 FROM rva_file ",
                 "  WHERE ",tm.wc CLIPPED,
                 "  ORDER BY rva01"
   ELSE
       LET g_sql=" SELECT rva_file.rva01 FROM rva_file,rvb_file ",
                 "  WHERE ",tm.wc CLIPPED,
                 "    AND ",tm.wc2 CLIPPED,
                 "    AND rva01 = rvb01 ",
                 "  ORDER BY rva01"
   END IF
   PREPARE t110_x_prepare FROM g_sql
   DECLARE t110_x_cs                         #SCROLL CURSOR
            SCROLL CURSOR WITH HOLD FOR t110_x_prepare #MOD-480163
 
   IF tm.wc2 = " 1=1" THEN
       LET g_sql=" SELECT COUNT(*) FROM rva_file ",
                 "  WHERE ",tm.wc CLIPPED
   ELSE
       LET g_sql=" SELECT COUNT(*) FROM rva_file,rvb_file ",
                 "  WHERE ",tm.wc CLIPPED,
                 "    AND ",tm.wc2 CLIPPED,
                 "    AND rva01 = rvb01 "
   END IF
   PREPARE t110_x_pp  FROM g_sql
   DECLARE t110_x_cnt   CURSOR FOR t110_x_pp
END FUNCTION
 
FUNCTION t110_x_b_askkey()
   #FUN-570175  --begin
   #No.FUN-580115  --begin
   CONSTRUCT tm.wc2 ON rvb02,rvb05,rvb39,rvb40,rvb41,rvb07,
                       rvb83,rvb85,rvb80,rvb82,rvb33,rvb332,
                       rvb331,rvb30,rvb29
                  FROM s_rvb[1].rvb02, s_rvb[1].rvb05,s_rvb[1].rvb39,
                       s_rvb[1].rvb40, s_rvb[1].rvb41,s_rvb[1].rvb07,
                       s_rvb[1].rvb83, s_rvb[1].rvb85,s_rvb[1].rvb80,
                       s_rvb[1].rvb82, s_rvb[1].rvb33,s_rvb[1].rvb332,
                       s_rvb[1].rvb331,s_rvb[1].rvb30,s_rvb[1].rvb29
   #No.FUN-580115  --end
   #FUN-570175  --end
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
END FUNCTION
 
FUNCTION t110_x_menu()
 
   WHILE TRUE
      CALL t110_x_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t110_x_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t110_x_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t110_x_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t110_x_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN t110_x_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN t110_x_cnt
         FETCH t110_x_cnt INTO g_row_count  #No.MOD-480163
         DISPLAY g_row_count TO cnt       #No.MOD-480163
        CALL t110_x_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION t110_x_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1) #處理方式
    l_abso          LIKE type_file.num10    #No.FUN-680136 INTEGER  #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t110_x_cs INTO g_rva.rva01
        WHEN 'P' FETCH PREVIOUS t110_x_cs INTO g_rva.rva01
        WHEN 'F' FETCH FIRST    t110_x_cs INTO g_rva.rva01
        WHEN 'L' FETCH LAST     t110_x_cs INTO g_rva.rva01
        WHEN '/'
            #No.MOD-480163
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
           FETCH ABSOLUTE g_jump t110_x_cs INTO g_rva.rva01
           LET mi_no_ask = FALSE
            #No.MOD-480163(end)
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)
        INITIALIZE g_rva.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump  #No.MOD-480163
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT rva01,rva02
      INTO g_rva.rva01,g_rva.rva02
      FROM rva_file
     WHERE rva01=g_rva.rva01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_rva.rva01,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("sel","rva_file","","",SQLCA.sqlcode,"","",0)  #No.FUN-660129
        RETURN
    END IF
 
    CALL t110_x_show()
END FUNCTION
 
FUNCTION t110_x_show()
   DISPLAY BY NAME g_rva.rva01   # 顯示單頭值
   CALL t110_x_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t110_x_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(1000)
          l_rvb04   LIKE rvb_file.rvb04,  #MOD-7C0227
          l_rvb03   LIKE rvb_file.rvb03
 
   IF cl_null(tm.wc2) THEN
       LET tm.wc2=" 1=1"
   END IF
 
   #FUN-570175  --begin
   LET l_sql =
        "SELECT rvb02,rvb05,'','','',rvb39,rvb40,rvb41,rvb07,",
        #No.FUN-580115  --begin
        "       rvb83,rvb85,rvb80,rvb82,rvb33,rvb332,rvb331,",
        "       rvb30,rvb29,rvb03,rvb04 ",  #MOD-7C0227 modify rvb04
        #No.FUN-580115  --end
   #FUN-570175  --end
        "  FROM rva_file,rvb_file ",
        " WHERE rva01=rvb01 ",
        "   AND rva01= '",g_rva.rva01,"'",
       #"   AND ",tm.wc2 CLIPPED,
        " ORDER BY rvb02,rvb05 "
    PREPARE t110_x_pb FROM l_sql
    DECLARE t110_x_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR t110_x_pb
 
    CALL g_rvb.clear()
    LET g_cnt = 1
    FOREACH t110_x_bcs INTO g_rvb[g_cnt].*,l_rvb03,l_rvb04 #MOD-7C0227 modify 
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT pmn041,pmn07
         INTO g_rvb[g_cnt].pmn041,g_rvb[g_cnt].pmn07
         FROM pmn_file
        WHERE pmn01 = l_rvb04    #MOD-7C0227 modify g_rva.rva02
          AND pmn02 = l_rvb03
       SELECT ima021 INTO g_rvb[g_cnt].ima021
         FROM ima_file
        WHERE ima01 = g_rvb[g_cnt].rvb05
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvb.deleteElement(g_cnt)  #MOD-480163
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
#    DISPLAY g_cnt   TO FORMONLY.cn3   #TQC-970323
END FUNCTION
 
FUNCTION t110_x_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) 
 
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN  #No.MOD-480163
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t110_x_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t110_x_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t110_x_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t110_x_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t110_x_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t110_x_def_form()   #FUN-610006
 
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
      LET g_action_choice="detail"   #MOD-BC0222 add
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
 
 
FUNCTION t110_x_b()
DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680136 SMALLINT #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,     #No.FUN-680136 SMALLINT #檢查重複用
       l_cnt           LIKE type_file.num5,     #No.FUN-680136 SMALLINT #檢查重複用
       l_lock_sw       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)  #單身鎖住否
       p_cmd           LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)  #處理狀態
       l_misc          LIKE type_file.chr4,     #No.FUN-680136 VARCHAR(04)
       l_qcs091        LIKE qcs_file.qcs091,
       l_rvv17_sum     LIKE rvv_file.rvv17,
       l_rvb04         LIKE rvb_file.rvb04,     #MOD-7C0227
       l_rvb03         LIKE rvb_file.rvb03,
       l_allow_insert  LIKE type_file.num5,     #No.FUN-680136 SMALLINT #可新增否
       l_allow_delete  LIKE type_file.num5      #No.FUN-680136 SMALLINT #可刪除否
DEFINE l_rvb29         LIKE rvb_file.rvb29,     #FUN-5A0179
       l_rvb291        LIKE rvb_file.rvb29,     #FUN-5A0179
       l_rvb30         LIKE rvb_file.rvb30      #FUN-5A0179
#No.MOD-8C0080 add --begin
DEFINE l_in            LIKE rvb_file.rvb07      #所有入庫數量，包括未審核
DEFINE l_out           LIKE rvb_file.rvb07      #所有驗退數量，包括未審核
#No.MOD-8C0080 add --end
 
    LET g_action_choice = ""
    SELECT * INTO g_rva.* FROM rva_file
     WHERE rva01=g_rva.rva01
    IF cl_null(g_rva.rva01) THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
   #MOD-780158-begin-modify
    #IF g_sma.sma886[8]='N' AND g_sma.sma886[6] = 'N' THEN  #採購收貨允收數量是否與IQC量勾稽
    #    RETURN
    #END IF
    IF g_sma.sma886[8]='Y' THEN
        CALL cl_err('','apm-977',0)  #No.TQC-7C0086
        RETURN
    END IF
   #MOD-780158-end-modify
    IF g_rva.rvaconf = 'N' THEN CALL cl_err('','aap-717',0) RETURN END IF

    #MOD-C50227 mark start -----
    ##-----MOD-B40262---------
    #LET l_cnt = 0 
    #SELECT COUNT(*) INTO l_cnt FROM rvb_file
    #  WHERE rvb01 = g_rva.rva01
    #    AND rvb39 = 'Y'
    #IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    #IF l_cnt = 0 THEN
    #   CALL cl_err('','apm1059',0)
    #   RETURN
    #END IF
    ##-----END MOD-B40262-----
    #MOD-C50227 mark end   -----
 
    CALL cl_opmsg('b')
 
    #FUN-570175  --begin
    #No.FUN-580115  --begin
    LET g_forupd_sql = "SELECT rvb02,rvb05,'','','',rvb39,rvb40,rvb41,rvb07,",
                       "       rvb83,rvb85,rvb80,rvb82,rvb33,rvb332,rvb331,",
                       "       rvb30,rvb29,rvb03,rvb04",  #MOD-7C0227 modify
                       "  FROM rvb_file  WHERE rvb01= ? AND  rvb02= ?  FOR UPDATE"
    #No.FUN-580115  --end
    #FUN-570175  --end
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_x_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_rvb WITHOUT DEFAULTS FROM s_rvb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=FALSE,DELETE ROW=FALSE, #No.MOD-480453
                         APPEND ROW=FALSE)                  #No.MOD-480453
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
               #MOD-C50227 add start -----
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM rvb_file
                 WHERE rvb01 = g_rva.rva01 AND rvb05 = g_rvb[l_ac].rvb05
                   AND rvb39 = 'Y'
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt = 0 THEN
                  CALL cl_err('','apm1059',0)
                  EXIT INPUT
               END IF
               #MOD-C50227 add end   -----
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
         #   DISPLAY l_ac TO FORMONLY.cn3  #TQC-970323
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_rvb_t.* = g_rvb[l_ac].*  #BACKUP
               LET g_rvb_o.* = g_rvb[l_ac].*  #BACKUP
               OPEN t110_x_b_cl USING g_rva.rva01,g_rvb_t.rvb02
               IF STATUS THEN
                  CALL cl_err("OPEN t110_x_b_cl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t110_x_b_cl INTO g_rvb[l_ac].*,l_rvb03,l_rvb04  #MOD-7C0227 modify
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_rvb_t.rvb02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                 END IF
                 SELECT pmn041,pmn07
                   INTO g_rvb[l_ac].pmn041,g_rvb[l_ac].pmn07
                   FROM pmn_file
                  WHERE pmn01 = l_rvb04  #MOD-7C0227 modify  g_rva.rva02
                    AND pmn02 = l_rvb03
                 SELECT ima021 INTO g_rvb[l_ac].ima021
                   FROM ima_file
                  WHERE ima01 = g_rvb[l_ac].rvb05
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
               #No.FUN-580115  --begin
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01=g_rvb[l_ac].rvb05
               CALL t110_x_set_entry_b(p_cmd)
               CALL t110_x_set_no_entry_b(p_cmd)
               CALL t110_x_set_no_required()
               CALL t110_x_set_required()
               #No.FUN-580115  --end
               #No.MOD-8C0080 add --begin
               SELECT SUM(rvv17) INTO l_in FROM rvv_file,rvu_file
                WHERE rvv04=g_rva.rva01        #收貨單號
                  AND rvv05=g_rvb[l_ac].rvb02  #收貨項次
                  AND rvu01=rvv01
                  AND rvu00='1'
                  AND rvuconf != 'X'
               SELECT SUM(rvv17) INTO l_out FROM rvv_file,rvu_file
                WHERE rvv04=g_rva.rva01        #收貨單號
                  AND rvv05=g_rvb[l_ac].rvb02  #收貨項次
                  AND rvu01=rvv01
                  AND rvu00='2'
                  AND rvuconf != 'X'
               IF cl_null(l_in) THEN LET l_in = 0 END IF
               IF cl_null(l_out) THEN LET l_out = 0 END IF
               IF l_in + l_out = g_rvb[l_ac].rvb07 THEN    #已經全部入庫或驗退
                  CALL cl_set_comp_entry("rvb33,rvb331,rvb332",FALSE)
                  #LET l_ac = l_ac+1                        #MOD-BC0222 add #MOD-BC0236 mark
                  #CALL fgl_set_arr_curr(l_ac)              #MOD-BC0222 add #MOD-BC0236 mark
                  #MOD-BC0236 add begin-------------------------
                  IF g_rvb[l_ac].rvb39 = 'N' OR g_rvb[l_ac].rvb39 IS NULL THEN
                     IF l_ac = g_rec_b THEN
                        LET l_ac = l_ac - 1
                     ELSE
                        LET l_ac = l_ac + 1
                     END IF
                     CALL fgl_set_arr_curr(l_ac)
                  END IF
                  #MOD-BC0236 add end---------------------------
               ELSE
                  IF g_rvb[l_ac].rvb39 = 'Y' THEN   #MOD-B40262
                     CALL cl_set_comp_entry("rvb33,rvb331,rvb332",TRUE)
                  END IF   #MOD-B40262
               END IF
               #No.MOD-8C0080 add --end
            END IF
 
        BEFORE FIELD rvb40
            IF g_rvb[l_ac].rvb39 = 'N' THEN
                #只可修改檢驗否='Y'的資料
                CALL cl_err('','apm-123',0)
            END IF
            IF cl_null(g_rvb[l_ac].rvb40) THEN
#No.FUN-B30097  ---begin---
              #LET g_rvb[l_ac].rvb40 = g_today
               IF l_ac = 1 THEN 
                  LET g_rvb[l_ac].rvb40 = g_today
               ELSE 
                  LET g_rvb[l_ac].rvb40 = g_rvb[l_ac-1].rvb40 
               END IF 
#No.FUN-B30097  ---end---
            END IF
             DISPLAY g_rvb[l_ac].rvb40 TO rvb40 #MOD-560132 有重新DISPLAY 才會影響到後續有跑ON ROW CHANGE
 
        #No.TQC-7C0086 --start--
        AFTER FIELD rvb40
            IF NOT cl_null(g_rvb[l_ac].rvb40) THEN
               IF g_rvb[l_ac].rvb40 < g_rva.rva06 THEN
                  CALL cl_err('','apm-976',1)
                  NEXT FIELD rvb40
               END IF
            END IF
        #No.TQC-7C0086 --end--
 
        BEFORE FIELD rvb33
            IF cl_null(g_rvb[l_ac].rvb33) THEN
                LET g_rvb[l_ac].rvb33 = 0
            END IF
        AFTER FIELD rvb33
            IF g_rvb[l_ac].rvb33 >g_rvb[l_ac].rvb07 THEN
                CALL cl_err('','mfg9031',0)
                LET g_rvb[l_ac].rvb33 = g_rvb_t.rvb33
                NEXT FIELD rvb33
            END IF
            #-----MOD-8A0115---------
            #IF g_rvb[l_ac].rvb33 < g_rvb[l_ac].rvb07 - g_rvb[l_ac].rvb30 -   #MOD-8B0054
            #                       g_rvb[l_ac].rvb29 THEN   #MOD-8B0054
            #No.MOD-8C0080 modify --begin
            #IF ((g_rvb[l_ac].rvb07 - g_rvb[l_ac].rvb29) < g_rvb[l_ac].rvb33) OR   #MOD-8B0054
            #   (g_rvb[l_ac].rvb30 > g_rvb[l_ac].rvb33) THEN     #MOD-8B0054
             IF ((g_rvb[l_ac].rvb07 - l_out) < g_rvb[l_ac].rvb33) OR (l_in > g_rvb[l_ac].rvb33) THEN
            #No.MOD-8C0080 modify --end
                CALL cl_err('','apm1019',0)
                LET g_rvb[l_ac].rvb33 = g_rvb_t.rvb33
                NEXT FIELD rvb33
            END IF
            #-----END MOD-8A0115-----
            IF g_sma.sma886[8]='Y' AND g_rvb[l_ac].rvb39 = 'Y' THEN  #採購收貨允收數量是否與IQC量勾稽
                SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
                 WHERE qcs01=g_rva.rva01
                   AND qcs02=g_rvb[l_ac].rvb02
                   AND qcs14='Y'
                   AND qcs09 IN ('1','3') #判定結果1.合格    2.退貨   3.特採
                   AND qcs00<'5'   #No.FUN-5C0078
                IF cl_null(l_qcs091) THEN
                    LET l_qcs091 = 0
                END IF
                IF g_rvb[l_ac].rvb33 >l_qcs091 THEN
                    #此數為IQC合格量,採購收貨允收數量不可大於IQC合格量!
                    CALL cl_err(l_qcs091,'apm-402',0)  #採購收貨允收數量不可大於IQC合格量!
                    NEXT FIELD rvb33
                END IF
            END IF
            IF cl_null(g_rvb[l_ac].rvb33) THEN
                LET g_rvb[l_ac].rvb33 = 0
            END IF
            IF g_rvb[l_ac].rvb33 < 0 THEN
                #錄入值不可小於零!
                CALL cl_err('','aim-391',0)
                LET g_rvb[l_ac].rvb33 = g_rvb_t.rvb33
                NEXT FIELD rvb33
            END IF
 
        #No.FUN-580115  --begin
        BEFORE FIELD rvb332
            IF cl_null(g_rvb[l_ac].rvb332) THEN
                LET g_rvb[l_ac].rvb332 = 0
            END IF
 
        AFTER FIELD rvb332
            #FUN-BB0085-add-str---
            IF NOT cl_null(g_rvb[l_ac].rvb332) AND NOT cl_null(g_rvb[l_ac].rvb83) THEN
               IF g_rvb_t.rvb332 != g_rvb[l_ac].rvb332 OR cl_null(g_rvb_t.rvb332) THEN
                  LET g_rvb[l_ac].rvb332 = s_digqty(g_rvb[l_ac].rvb332,g_rvb[l_ac].rvb83)
                  DISPLAY BY NAME g_rvb[l_ac].rvb332
               END IF
            END IF
            #FUN-BB0085-add-end---
            IF g_rvb[l_ac].rvb332 >g_rvb[l_ac].rvb85 THEN
                CALL cl_err('','mfg9031',0)
                LET g_rvb[l_ac].rvb332 = g_rvb_t.rvb332
                NEXT FIELD rvb332
            END IF
            IF cl_null(g_rvb[l_ac].rvb332) THEN
                LET g_rvb[l_ac].rvb332 = 0
            END IF
            IF g_rvb[l_ac].rvb332 < 0 THEN
                #錄入值不可小於零!
                CALL cl_err('','aim-391',0)
                LET g_rvb[l_ac].rvb332 = g_rvb_t.rvb332
                NEXT FIELD rvb332
            END IF
 
        BEFORE FIELD rvb331
            IF cl_null(g_rvb[l_ac].rvb331) THEN
                LET g_rvb[l_ac].rvb331 = 0
            END IF
 
        AFTER FIELD rvb331
            #FUN-BB0085-add-str---
            IF NOT cl_null(g_rvb[l_ac].rvb331) AND NOT cl_null(g_rvb[l_ac].rvb80) THEN 
               IF g_rvb_t.rvb331 != g_rvb[l_ac].rvb331 OR cl_null(g_rvb_t.rvb331) THEN 
                  LET g_rvb[l_ac].rvb331 = s_digqty(g_rvb[l_ac].rvb331,g_rvb[l_ac].rvb80) 
                  DISPLAY BY NAME g_rvb[l_ac].rvb331
               END IF
            END IF
            #FUN-BB0085-add-end---
            IF g_rvb[l_ac].rvb331 >g_rvb[l_ac].rvb82 THEN
                CALL cl_err('','mfg9031',0)
                LET g_rvb[l_ac].rvb331 = g_rvb_t.rvb331
                NEXT FIELD rvb331
            END IF
            IF cl_null(g_rvb[l_ac].rvb331) THEN
                LET g_rvb[l_ac].rvb331 = 0
            END IF
            IF g_rvb[l_ac].rvb331 < 0 THEN
                #錄入值不可小於零!
                CALL cl_err('','aim-391',0)
                LET g_rvb[l_ac].rvb331 = g_rvb_t.rvb331
                NEXT FIELD rvb331
            END IF
            CALL t110_x_set_rvb33()
            IF g_rvb[l_ac].rvb33 >g_rvb[l_ac].rvb07 THEN
                CALL cl_err('','mfg9031',0)
                LET g_rvb[l_ac].rvb33 = g_rvb_t.rvb33
                IF g_ima906 MATCHES '[23]' THEN
                   NEXT FIELD rvb332
                ELSE
                   NEXT FIELD rvb331
                END IF
            END IF
            IF g_sma.sma886[8]='Y' AND g_rvb[l_ac].rvb39 = 'Y' THEN  #採購收貨允收數量是否與IQC量勾稽
                SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
                 WHERE qcs01=g_rva.rva01
                   AND qcs02=g_rvb[l_ac].rvb02
                   AND qcs14='Y'
                   AND qcs09 IN ('1','3') #判定結果1.合格    2.退貨   3.特採
                   AND qcs00<'5'   #No.FUN-5C0078
                IF cl_null(l_qcs091) THEN
                    LET l_qcs091 = 0
                END IF
                IF g_rvb[l_ac].rvb33 >l_qcs091 THEN
                    #此數為IQC合格量,採購收貨允收數量不可大於IQC合格量!
                    CALL cl_err(l_qcs091,'apm-402',0)  #採購收貨允收數量不可大於IQC合格量!
                    IF g_ima906 MATCHES '[23]' THEN
                       NEXT FIELD rvb332
                    ELSE
                       NEXT FIELD rvb331
                    END IF
                END IF
            END IF
            IF cl_null(g_rvb[l_ac].rvb33) THEN
                LET g_rvb[l_ac].rvb33 = 0
            END IF
            IF g_rvb[l_ac].rvb33 < 0 THEN
                #錄入值不可小於零!
                CALL cl_err('','aim-391',0)
                LET g_rvb[l_ac].rvb33 = g_rvb_t.rvb33
                IF g_ima906 MATCHES '[23]' THEN
                   NEXT FIELD rvb332
                ELSE
                   NEXT FIELD rvb331
                END IF
            END IF
        #No.FUN-580115  --end
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rvb[l_ac].* = g_rvb_t.*
               CLOSE t110_x_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rvb[l_ac].rvb02,-263,1)
               LET g_rvb[l_ac].* = g_rvb_t.*
            ELSE
               UPDATE rvb_file SET
                  rvb33=g_rvb[l_ac].rvb33,
                  rvb332=g_rvb[l_ac].rvb332,  #No.FUN-580115
                  rvb331=g_rvb[l_ac].rvb331,  #No.FUN-580115
                  rvb40=g_rvb[l_ac].rvb40,
                  rvb41=g_rvb[l_ac].rvb41
                WHERE CURRENT OF t110_x_b_cl
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                  CALL cl_err(g_rvb[l_ac].rvb33,SQLCA.sqlcode,0)   #No.FUN-660129
                   CALL cl_err3("upd","rvb_file","","",SQLCA.sqlcode,"","",0)  #No.FUN-660129
                   LET g_rvb[l_ac].* = g_rvb_t.*
               ELSE
                  #start FUN-5A0179
                   #當修改允收量大於原允收量時,重計rvb29,rvb30,rvb09,rvb31
                   IF g_rvb[l_ac].rvb33 > g_rvb_t.rvb33 THEN
                      #計算已入庫量
                      SELECT SUM(rvv17) INTO l_rvb30 FROM rvv_file,rvu_file
                       WHERE rvv04=g_rva.rva01 AND rvv05=g_rvb[l_ac].rvb02
                         AND rvuconf ='Y' AND rvu00='1' AND rvv01=rvu01
                      #計算驗退
                      SELECT SUM(rvv17) INTO l_rvb29 FROM rvv_file,rvu_file
                       WHERE rvv04=g_rva.rva01 AND rvv05=g_rvb[l_ac].rvb02
                         AND rvuconf ='Y' AND rvu00='2' AND rvv01=rvu01
                      #計算倉退
                      SELECT SUM(rvv17) INTO l_rvb291 FROM rvv_file,rvu_file
                       WHERE rvv04=g_rva.rva01 AND rvv05=g_rvb[l_ac].rvb02
                         AND rvuconf ='Y' AND rvu00='3' AND rvv01=rvu01
                      IF cl_null(l_rvb30)  THEN LET l_rvb30=0 END IF
                      IF cl_null(l_rvb29)  THEN LET l_rvb29=0 END IF
                      IF cl_null(l_rvb291) THEN LET l_rvb291=0 END IF
                      IF g_rvb[l_ac].rvb39 = 'Y' THEN    #rvb39:檢驗否
                         UPDATE rvb_file SET rvb29 = l_rvb29,           #驗退量
                                             rvb30 = l_rvb30,           #入庫量
                                             rvb09 = l_rvb30-l_rvb291,  #允請量
                                             rvb31 = rvb33-l_rvb30      #可入庫量
                          WHERE rvb01 = g_rva.rva01
                            AND rvb02 = g_rvb[l_ac].rvb02
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                           CALL cl_err('退 upd rvb29,rvb30,rvb09,rvb31:',SQLCA.sqlcode,1)   #No.FUN-660129
                            CALL cl_err3("upd","rvb_file",g_rva.rva01,g_rvb[l_ac].rvb02,SQLCA.sqlcode,"","退 upd rvb29,rvb30,rvb09,rvb31:",1)  #No.FUN-660129
                            CLOSE t110_x_b_cl
                            ROLLBACK WORK
                            EXIT INPUT
                         END IF
                      ELSE
                         UPDATE rvb_file SET rvb29 = l_rvb29,               #驗退量
                                             rvb30 = l_rvb30,               #入庫量
                                             rvb09 = l_rvb30-l_rvb291,      #允請量
                                             rvb31 = rvb07-l_rvb29-l_rvb30  #可入庫量
                          WHERE rvb01 = g_rva.rva01
                            AND rvb02 = g_rvb[l_ac].rvb02
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                           CALL cl_err('退 upd rvb29,rvb30,rvb09,rvb31:',SQLCA.sqlcode,1)   #No.FUN-660129
                            CALL cl_err3("upd","rvb_file",g_rvb[l_ac].rvb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                            CLOSE t110_x_b_cl
                            ROLLBACK WORK
                            EXIT INPUT
                         END IF
                      END IF
                   END IF
                  #end FUN-5A0179
                   MESSAGE 'UPDATE O.K'
                   CLOSE t110_x_b_cl
                   COMMIT WORK
               END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_rvb[l_ac].* = g_rvb_t.*
               END IF
               CLOSE t110_x_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t110_x_b_cl
            COMMIT WORK
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
 
    CLOSE t110_x_b_cl
    COMMIT WORK
 
END FUNCTION
#No.FUN-580115  --begin
FUNCTION t110_x_set_rvb33()
 DEFINE    l_ima906 LIKE ima_file.ima906,
           l_ima907 LIKE ima_file.ima907,
           l_img09  LIKE img_file.img09,     #img單位
           l_tot    LIKE img_file.img10,
           l_fac2   LIKE rvb_file.rvb84,
           l_qty2   LIKE rvb_file.rvb85,
           l_fac1   LIKE rvb_file.rvb81,
           l_qty1   LIKE rvb_file.rvb82,
           l_factor LIKE pml_file.pml09,   #No.FUN-680136 DECIMAL(16,8)
           l_ima25  LIKE ima_file.ima25,
           l_rvb    RECORD LIKE rvb_file.*
 
   SELECT ima906 INTO l_ima906
     FROM ima_file WHERE ima01=g_rvb[l_ac].rvb05
   IF SQLCA.sqlcode = 100 THEN
      IF g_rvb[l_ac].rvb05 MATCHES 'MISC*' THEN
         SELECT ima906 INTO l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
 
   SELECT * INTO l_rvb.* FROM rvb_file
    WHERE rvb01=g_rva.rva01 AND rvb02=g_rvb[l_ac].rvb02
   IF cl_null(l_rvb.rvb80) THEN LET g_rvb[l_ac].rvb331=NULL END IF
   IF cl_null(l_rvb.rvb83) THEN LET g_rvb[l_ac].rvb332=NULL END IF
   LET l_fac2=l_rvb.rvb84
   LET l_qty2=g_rvb[l_ac].rvb332
   LET l_fac1=l_rvb.rvb81
   LET l_qty1=g_rvb[l_ac].rvb331
 
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1
         WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
         WHEN '3' LET l_tot=l_qty1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=l_qty1
   END IF
 
   LET g_rvb[l_ac].rvb33=l_tot
   LET g_rvb[l_ac].rvb33=s_digqty(g_rvb[l_ac].rvb33,l_rvb.rvb90)     #FUN-BB0085
 
END FUNCTION
 
FUNCTION t110_x_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
  CALL cl_set_comp_entry("rvb332",TRUE)
  CALL cl_set_comp_entry("rvb40,rvb41,rvb33,rvb331,rvb332",TRUE)   #MOD-B40262
 
END FUNCTION
 
FUNCTION t110_x_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
  IF g_ima906 = '1' THEN
     CALL cl_set_comp_entry("rvb332",FALSE)
  END IF

  #-----MOD-B40262---------
  IF g_rvb[l_ac].rvb39 = 'N' OR g_rvb[l_ac].rvb39 IS NULL THEN
     CALL cl_set_comp_entry("rvb40,rvb41,rvb33,rvb331,rvb332",FALSE)   
  END IF 
  #-----END MOD-B40262----- 
 
END FUNCTION
 
FUNCTION t110_x_set_required()
 
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("rvb331,rvb332",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t110_x_set_no_required()
 
  CALL cl_set_comp_required("rvb331,rvb332",FALSE)
END FUNCTION
#No.FUN-580115  --end
 
#-----FUN-610006---------
FUNCTION t110_x_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("rvb83,rvb85,rvb80,rvb82",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
       CALL cl_getmsg('asm-406',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb332",g_msg CLIPPED)
       CALL cl_getmsg('asm-407',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb331",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb83",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb85",g_msg CLIPPED)
       CALL cl_getmsg('asm-362',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb80",g_msg CLIPPED)
       CALL cl_getmsg('asm-363',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb82",g_msg CLIPPED)
       CALL cl_getmsg('asm-408',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb332",g_msg CLIPPED)
       CALL cl_getmsg('asm-409',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("rvb331",g_msg CLIPPED)
    END IF
END FUNCTION
#-----END FUN-610006-----
 
#No.TQC-740124   新增ora文件
