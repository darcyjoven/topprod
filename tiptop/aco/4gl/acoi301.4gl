# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acoi301.4gl
# Descriptions...: 加工合同進口材料資料維護作業
# Date & Author..: 00/05/02 By Kammy
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/11 By Danny add coc10
# Modify.........: No.MOD-490398 05/03/03 By Carrier add coe107,coe108,coe109
# Modify.........: NO.FUN-570129 05/08/05 BY yiting 單身只有行序時只能放棄才能離
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790066 07/09/11 By Judy 匯出Excel多一空白行 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-840202 08/05/08 By TSD.Wind 自定功能欄位修改
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.MOD-970071 09/07/09 By mike sql語句存在語法錯誤     
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 12/01/13 By chenjing 增加數量欄位小數取位
# Modify.........: NO.TQC-C20183 12/02/15 By fengrui 數量欄位小數取位處理
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_coc           RECORD LIKE coc_file.*,       #單頭   #TQC-840066
    g_coc_t         RECORD LIKE coc_file.*,       #單頭(舊值)
    g_coc_o         RECORD LIKE coc_file.*,       #單頭(舊值)
    g_coc01_t       LIKE coc_file.coc01,   #單頭 (舊值)
    g_coe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        coe02       LIKE coe_file.coe02,   #項次
        coe03       LIKE coe_file.coe03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        coe05       LIKE coe_file.coe05,   #
        coe10       LIKE coe_file.coe10,   #
        coe06       LIKE coe_file.coe06,   #
        coe07       LIKE coe_file.coe07,   #
        coe08       LIKE coe_file.coe08,   #
        coe11       LIKE coe_file.coe11,   #
        coe12       LIKE coe_file.coe12,   #
        #FUN-840202 --start---
        coeud01     LIKE coe_file.coeud01,
        coeud02     LIKE coe_file.coeud02,
        coeud03     LIKE coe_file.coeud03,
        coeud04     LIKE coe_file.coeud04,
        coeud05     LIKE coe_file.coeud05,
        coeud06     LIKE coe_file.coeud06,
        coeud07     LIKE coe_file.coeud07,
        coeud08     LIKE coe_file.coeud08,
        coeud09     LIKE coe_file.coeud09,
        coeud10     LIKE coe_file.coeud10,
        coeud11     LIKE coe_file.coeud11,
        coeud12     LIKE coe_file.coeud12,
        coeud13     LIKE coe_file.coeud13,
        coeud14     LIKE coe_file.coeud14,
        coeud15     LIKE coe_file.coeud15
        #FUN-840202 --end--
                    END RECORD,
    g_coe_t         RECORD                 #程式變數 (舊值)
        coe02       LIKE coe_file.coe02,   #項次
        coe03       LIKE coe_file.coe03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        coe05       LIKE coe_file.coe05,   #
        coe10       LIKE coe_file.coe10,   #
        coe06       LIKE coe_file.coe06,   #
        coe07       LIKE coe_file.coe07,   #
        coe08       LIKE coe_file.coe08,   #
        coe11       LIKE coe_file.coe11,   #
        coe12       LIKE coe_file.coe12,   #
        #FUN-840202 --start---
        coeud01     LIKE coe_file.coeud01,
        coeud02     LIKE coe_file.coeud02,
        coeud03     LIKE coe_file.coeud03,
        coeud04     LIKE coe_file.coeud04,
        coeud05     LIKE coe_file.coeud05,
        coeud06     LIKE coe_file.coeud06,
        coeud07     LIKE coe_file.coeud07,
        coeud08     LIKE coe_file.coeud08,
        coeud09     LIKE coe_file.coeud09,
        coeud10     LIKE coe_file.coeud10,
        coeud11     LIKE coe_file.coeud11,
        coeud12     LIKE coe_file.coeud12,
        coeud13     LIKE coe_file.coeud13,
        coeud14     LIKE coe_file.coeud14,
        coeud15     LIKE coe_file.coeud15
        #FUN-840202 --end--
                    END RECORD,
    g_coe_o         RECORD                 #程式變數 (舊值)
        coe02       LIKE coe_file.coe02,   #項次
        coe03       LIKE coe_file.coe03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        coe05       LIKE coe_file.coe05,   #
        coe10       LIKE coe_file.coe10,   #
        coe06       LIKE coe_file.coe06,   #
        coe07       LIKE coe_file.coe07,   #
        coe08       LIKE coe_file.coe08,   #
        coe11       LIKE coe_file.coe11,   #
        coe12       LIKE coe_file.coe12,   #
        #FUN-840202 --start---
        coeud01     LIKE coe_file.coeud01,
        coeud02     LIKE coe_file.coeud02,
        coeud03     LIKE coe_file.coeud03,
        coeud04     LIKE coe_file.coeud04,
        coeud05     LIKE coe_file.coeud05,
        coeud06     LIKE coe_file.coeud06,
        coeud07     LIKE coe_file.coeud07,
        coeud08     LIKE coe_file.coeud08,
        coeud09     LIKE coe_file.coeud09,
        coeud10     LIKE coe_file.coeud10,
        coeud11     LIKE coe_file.coeud11,
        coeud12     LIKE coe_file.coeud12,
        coeud13     LIKE coe_file.coeud13,
        coeud14     LIKE coe_file.coeud14,
        coeud15     LIKE coe_file.coeud15
        #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE coe_file.coe01,        # 詢價單號
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_sl            LIKE type_file.num5         #No.FUN-680069 SMALLINT  #目前處理的SCREEN LINE
 
#主程式開始
DEFINE g_forupd_sql STRING #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE g_chr               LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_msg               LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
#CKP3
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_coe06_t      LIKE coe_file.coe06          #No.FUN-910088--add--
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
#       l_time    LIKE type_file.chr8              #No.FUN-6A0063
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ACO")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    LET g_argv1 = ARG_VAL(1)               #參數-1(詢價單號)
 
    LET g_forupd_sql = " SELECT * FROM coc_file WHERE coc01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i301_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i301_w AT p_row,p_col
        WITH FORM "aco/42f/acoi301"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL i301_q()
    END IF
    CALL i301_menu()
    CLOSE WINDOW i301_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION i301_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_coe.clear()
 
  IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
     LET g_wc = " coc01 = '",g_argv1,"'"
     LET g_wc2=" 1=1"
  ELSE
     CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
 
   INITIALIZE g_coc.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
         coc01,coc02,coc10,coc03,coc04,          #No.MOD-490398
         coc06,coc05,coc07,
         coc08, coc09,
         cocuser,cocgrup,cocmodu,cocdate,cocacti,
         #FUN-840202   ---start---
         cocud01,cocud02,cocud03,cocud04,cocud05,
         cocud06,cocud07,cocud08,cocud09,cocud10,
         cocud11,cocud12,cocud13,cocud14,cocud15
         #FUN-840202    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
     ON ACTION controlp
           CASE
              WHEN INFIELD(coc02) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_azi"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO coc02
                   NEXT FIELD coc02
               #No.MOD-490398
              WHEN INFIELD(coc10)    #海關代號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_cna"
                   LET g_qryparam.default1 = g_coc.coc10
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO coc10
                   NEXT FIELD coc10
               #No.MOD-490398 end
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
     CONSTRUCT g_wc2 ON coe02,coe03,coe05,coe10,coe06,coe07,coe08, #螢幕上取單身條件
                        coe11,coe12
                        #No.FUN-840202 --start--
                        ,coeud01,coeud02,coeud03,coeud04,coeud05
                        ,coeud06,coeud07,coeud08,coeud09,coeud10
                        ,coeud11,coeud12,coeud13,coeud14,coeud15
                        #No.FUN-840202 ---end---
             FROM s_coe[1].coe02,s_coe[1].coe03,s_coe[1].coe05,
                  s_coe[1].coe10,s_coe[1].coe06,s_coe[1].coe07,
                  s_coe[1].coe08,s_coe[1].coe11,s_coe[1].coe12
                  #No.FUN-840202 --start--
                  ,s_coe[1].coeud01,s_coe[1].coeud02,s_coe[1].coeud03
                  ,s_coe[1].coeud04,s_coe[1].coeud05,s_coe[1].coeud06
                  ,s_coe[1].coeud07,s_coe[1].coeud08,s_coe[1].coeud09
                  ,s_coe[1].coeud10,s_coe[1].coeud11,s_coe[1].coeud12
                  ,s_coe[1].coeud13,s_coe[1].coeud14,s_coe[1].coeud15
                  #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON ACTION controlp
           CASE
              WHEN INFIELD(coe03) #料件編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_cob"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coe03
                    NEXT FIELD coe03
               WHEN INFIELD(coe06) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coe06
                    NEXT FIELD coe06
               WHEN INFIELD(coe11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_geb"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coe11
                    NEXT FIELD coe11
               WHEN INFIELD(coe12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_cnc"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coe12
                    NEXT FIELD coe12
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
 
 
		#No.FUN-580031 --start--     HCN
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
  END IF
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND cocuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND cocgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND cocgrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT coc01 FROM coc_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY coc01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE coc01 ",
                   "  FROM coc_file, coe_file ",
                   " WHERE coc01 = coe01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY coc01"
    END IF
 
    PREPARE i301_prepare FROM g_sql
    DECLARE i301_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i301_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM coc_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM coc_file,coe_file WHERE ",
                  "coe01=coc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i301_precount FROM g_sql
    DECLARE i301_count CURSOR FOR i301_precount
END FUNCTION
 
FUNCTION i301_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL i301_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i301_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i301_r()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i301_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i301_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_coe),'','')
             END IF
         #--
 
          {#No.MOD-490398
         WHEN "gen_imports"
            IF cl_chk_act_auth() AND g_coc.coc01 IS NOT NULL
               AND g_coc.cocacti = 'Y'
            THEN
               SELECT COUNT(*) INTO g_cnt FROM coe_file
               WHERE coe01 = g_coc.coc01
               AND coe09 !=0
               IF g_cnt > 0 THEN
                  CALL cl_err('','aco-014',0)
               ELSE
                 CALL s_ins_coe(g_coc.coc01,1)
                 CALL i301_show()
               END IF
            END IF
           }      #No.MOD-490398 END
 
         WHEN "query_exports"
            IF cl_chk_act_auth() THEN
               LET l_cmd="acoi300 '",g_coc.coc01,"'"
               CALL cl_cmdrun(l_cmd)
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_coc.coc01 IS NOT NULL THEN
                 LET g_doc.column1 = "coc01"
                 LET g_doc.value1 = g_coc.coc01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 {#No.MOD-490398 此段沒用到,故整段mark掉
#處理INPUT
FUNCTION i301_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n,l_i   LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    p_cmd     LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    DISPLAY BY NAME
        g_coc.coc01,g_coc.coc02,g_coc.coc03,g_coc.coc04,g_coc.coc05,
        g_coc.coc06,g_coc.coc07,g_coc.coc08,g_coc.coc09,g_coc.cocuser,
        g_coc.cocgrup,g_coc.cocmodu,g_coc.cocdate,g_coc.cocacti
 
    INPUT BY NAME
        g_coc.coc01,g_coc.coc02,g_coc.coc03,g_coc.coc04,
        g_coc.coc06,g_coc.coc05,g_coc.coc07,
        g_coc.coc08,g_coc.coc09,
        g_coc.cocuser,g_coc.cocgrup,g_coc.cocmodu,g_coc.cocdate,g_coc.cocacti,
        #FUN-840202     ---start---
        g_coc.cocud01,g_coc.cocud02,g_coc.cocud03,g_coc.cocud04,
        g_coc.cocud05,g_coc.cocud06,g_coc.cocud07,g_coc.cocud08,
        g_coc.cocud09,g_coc.cocud10,g_coc.cocud11,g_coc.cocud12,
        g_coc.cocud13,g_coc.cocud14,g_coc.cocud15 
        #FUN-840202     ----end----
                      WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i301_set_entry(p_cmd)
            CALL i301_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD coc01
            IF NOT cl_null(g_coc.coc01) THEN
               IF g_coc.coc01 != g_coc01_t OR g_coc01_t IS NULL THEN
                   SELECT count(*) INTO l_n FROM coc_file
                       WHERE coc01 = g_coc.coc01
                   IF l_n > 0 THEN   #單據編號重複
                       CALL cl_err(g_coc.coc01,-239,0)
                       LET g_coc.coc01 = g_coc01_t
                       DISPLAY BY NAME g_coc.coc01
                       NEXT FIELD coc01
                   END IF
               END IF
            END IF
 
        AFTER FIELD coc02                  #幣別
            IF NOT cl_null(g_coc.coc02) THEN
               IF g_coc_o.coc02 IS NULL OR
                  (g_coc_o.coc02 != g_coc.coc02) THEN
                  CALL i301_coc02(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_coc.coc02,g_errno,0)
                     LET g_coc.coc02 = g_coc_o.coc02
                     DISPLAY BY NAME g_coc.coc02
                     NEXT FIELD coc02
                  END IF
               END IF
            END IF
            LET g_coc_o.coc02 = g_coc.coc02
 
        #FUN-840202     ---start---
        AFTER FIELD cocud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cocud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(coc02) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_coc.coc02
                 CALL cl_create_qry() RETURNING g_coc.coc02
#                 CALL FGL_DIALOG_SETBUFFER( g_coc.coc02 )
                  DISPLAY BY NAME g_coc.coc02
                  CALL i301_coc02('d')
                  NEXT FIELD coc02
              OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION i301_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("coc01,coc02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i301_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("coc01,coc02",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i301_coc02(p_cmd)  #幣別
    DEFINE l_azi02   LIKE azi_file.azi02,
           l_aziacti LIKE azi_file.aziacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT azi02,aziacti INTO l_azi02,l_aziacti
      FROM azi_file WHERE azi01 = g_coc.coc02
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                   LET l_azi02 = NULL
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 }  #No.MOD-490398 END
 
#Query 查詢
FUNCTION i301_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_coc.* TO NULL          #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_coe.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i301_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_coc.* TO NULL
        RETURN
    END IF
    OPEN i301_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_coc.* TO NULL
    ELSE
        OPEN i301_count
        FETCH i301_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i301_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i301_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i301_cs INTO g_coc.coc01
        WHEN 'P' FETCH PREVIOUS i301_cs INTO g_coc.coc01
        WHEN 'F' FETCH FIRST    i301_cs INTO g_coc.coc01
        WHEN 'L' FETCH LAST     i301_cs INTO g_coc.coc01
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i301_cs INTO g_coc.coc01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
        INITIALIZE g_coc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_coc.* FROM coc_file WHERE coc01 = g_coc.coc01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0) #No.TQC-660045
         CALL cl_err3("sel","coc_file",g_coc.coc01,"",SQLCA.sqlcode,"","",1)       #NO.TQC-660045
        INITIALIZE g_coc.* TO NULL
        RETURN
    END IF
    CALL i301_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i301_show()
    LET g_coc_t.* = g_coc.*                #保存單頭舊值
    LET g_coc_o.* = g_coc.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_coc.coc01,g_coc.coc02,g_coc.coc03,g_coc.coc04,g_coc.coc05,
        g_coc.coc06,g_coc.coc07,g_coc.coc08,g_coc.coc09,
        g_coc.coc10,g_coc.cocuser,                        #No.MOD-490398
        g_coc.cocgrup,g_coc.cocmodu,g_coc.cocdate,g_coc.cocacti,
        #FUN-840202     ---start---
        g_coc.cocud01,g_coc.cocud02,g_coc.cocud03,g_coc.cocud04,
        g_coc.cocud05,g_coc.cocud06,g_coc.cocud07,g_coc.cocud08,
        g_coc.cocud09,g_coc.cocud10,g_coc.cocud11,g_coc.cocud12,
        g_coc.cocud13,g_coc.cocud14,g_coc.cocud15 
        #FUN-840202     ----end----
 
    CALL i301_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION i301_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_coc.coc01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_coc.cocacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_coc.coc01,'mfg1000',0)
        RETURN
    END IF
 
    IF (NOT cl_null(g_coc.coc07) AND g_coc.coc07 < g_today) OR
       g_coc.coc05 < g_today THEN
       CALL cl_err(g_coc.coc04,'aco-060',0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i301_cl USING g_coc.coc01
    IF STATUS THEN
       CALL cl_err("OPEN i301_cl:", STATUS, 1)
       CLOSE i301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i301_cl INTO g_coc.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i301_cl
        RETURN
    END IF
    CALL i301_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "coc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_coc.coc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM coe_file WHERE coe01 = g_coc.coc01
          #No.MOD-490398
         LET g_msg=TIME
         INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)       #FUN-980002 add azoplant,azolegal
              VALUES ('acoi301',g_user,g_today,g_msg,g_coc.coc01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
         CALL i301_update()
          #No.MOD-490398 end
         CLEAR FORM
         CALL g_coe.clear()
         #CKP3
         OPEN i301_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i301_cs
            CLOSE i301_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i301_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i301_cs
            CLOSE i301_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i301_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i301_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i301_fetch('/')
         END IF
    END IF
    CLOSE i301_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i301_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_coc.coc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_coc.* FROM coc_file WHERE coc01=g_coc.coc01
    IF g_coc.cocacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_coc.coc01,'mfg1000',0)
        RETURN
    END IF
 
     IF NOT cl_null(g_coc.coc07) OR g_coc.coc05 < g_today THEN   #No.MOD-490398
       CALL cl_err(g_coc.coc01,'aco-060',0) RETURN
    END IF
    #判斷是否有報關記錄
    SELECT COUNT(*) INTO l_cnt FROM cno_file
     #WHERE cno10 = g_coc.coc04 AND cno11 = g_coc.coc03 AND cnoconf='Y'
     WHERE cno10 = g_coc.coc03 AND cnoconf='Y'
    IF l_cnt > 0 THEN
       CALL cl_err(g_coc.coc01,'aco-076',0) RETURN
    END IF
 
    LET g_success='Y'
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT coe02,coe03,'',coe05,coe10, ",
                       "       coe06,coe07,coe08,coe11,coe12, ",
                       #No.FUN-840202 --start--
                       "       coeud01,coeud02,coeud03,coeud04,coeud05,",
                       "       coeud06,coeud07,coeud08,coeud09,coeud10,",
                       "       coeud11,coeud12,coeud13,coeud14,coeud15 ", 
                       #No.FUN-840202 ---end---
                       " FROM coe_file ",
                       " WHERE coe01=? AND coe02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i301_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
 #No.MOD-490398
     # LET l_allow_insert = cl_detail_input_auth("insert")       
     # LET l_allow_delete = cl_detail_input_auth("delete")       
 
        INPUT ARRAY g_coe WITHOUT DEFAULTS FROM s_coe.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET g_coe_t.* = g_coe[l_ac].*  #BACKUP
            LET g_coe_o.* = g_coe[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i301_cl USING g_coc.coc01
            IF STATUS THEN
               CALL cl_err("OPEN i301_cl:", STATUS, 1)
               CLOSE i301_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i301_cl INTO g_coc.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i301_cl
               RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_coe06_t = g_coe[l_ac].coe06    #FUN-910088--add--
 
                OPEN i301_bcl USING g_coc.coc01,g_coe_t.coe02
                IF STATUS THEN
                   CALL cl_err("OPEN i301_bcl:", STATUS, 1)
                   CLOSE i301_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i301_bcl INTO g_coe[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_coe_t.coe02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL i301_coe03('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD coe02
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CALL g_coe.deleteElement(l_ac)   #取消 Array Element
               IF g_rec_b != 0 THEN             #單身有資料時取消新增而不離開輸入
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
               EXIT INPUT
            END IF
             INSERT INTO coe_file(coe01,coe02,coe03,coe04,     #No.MOD-490398
                                 coe05,coe06,
                                 coe07,coe08,coe09,
                                 coe091,coe10,coe101,
                                 coe102,coe103,coe104,
                                 coe105,coe106,coe107,coe108,coe109, #No.MOD-490398
                                 coe11,coe12,
                                 #FUN-840202 --start--
                                 coeud01,coeud02,coeud03,coeud04,coeud05,
                                 coeud06,coeud07,coeud08,coeud09,coeud10,
                                 #coeud11,coeud12,coeud13,coeud14,coeud15) #FUN-980002
                                 #FUN-840202 --end--
                                 coeud11,coeud12,coeud13,coeud14,coeud15,  #FUN-980002
                                 coeplant,coelegal)  #FUN-980002
            VALUES(g_coc.coc01,g_coe[l_ac].coe02,
                    g_coe[l_ac].coe03,g_coc.coc10,           #No.MOD-490398
                   g_coe[l_ac].coe05,g_coe[l_ac].coe06,
                   g_coe[l_ac].coe07,g_coe[l_ac].coe08,
                    0,0,g_coe[l_ac].coe10,0,0,0,0,0,0,0,0,0, #No.MOD-490398
                   g_coe[l_ac].coe11,g_coe[l_ac].coe12,
                   #FUN-840202 --start--
                   g_coe[l_ac].coeud01,g_coe[l_ac].coeud02,g_coe[l_ac].coeud03,
                   g_coe[l_ac].coeud04,g_coe[l_ac].coeud05,g_coe[l_ac].coeud06,
                   g_coe[l_ac].coeud07,g_coe[l_ac].coeud08,g_coe[l_ac].coeud09,
                   g_coe[l_ac].coeud10,g_coe[l_ac].coeud11,g_coe[l_ac].coeud12,
                   #g_coe[l_ac].coeud13,g_coe[l_ac].coeud14,g_coe[l_ac].coeud15) #FUN-980002
                   #FUN-840202 --end--
                   g_coe[l_ac].coeud13,g_coe[l_ac].coeud14,g_coe[l_ac].coeud15,  #FUN-980002
                   g_plant,g_legal)  #FUN-980002
            IF SQLCA.sqlcode THEN
#                CALL cl_err(g_coe[l_ac].coe02,SQLCA.sqlcode,0) #No.TQC-660045
                 CALL cl_err3("ins","coe_file",g_coc.coc01,g_coe[l_ac].coe02,SQLCA.sqlcode,"","",1)       #NO.TQC-660045
                LET g_coe[l_ac].* = g_coe_t.*
            ELSE
                CALL i301_update()
                IF g_success='Y' THEN
                   COMMIT WORK
                   MESSAGE 'INSERT O.K'
                ELSE
                   CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_coe[l_ac].* TO NULL      #900423
            LET g_coe[l_ac].coe07 = 0        #Body default
            LET g_coe[l_ac].coe08 = 0        #Body default
            LET g_coe[l_ac].coe10 = 0        #Body default
            LET g_coe_t.* = g_coe[l_ac].*         #新輸入資料
            LET g_coe_o.* = g_coe[l_ac].*         #新輸入資料
            LET g_coe06_t = NULL              #FUN-910088--add--
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
            NEXT FIELD coe02
 
        BEFORE FIELD coe02                        #default 序號
            IF g_coe[l_ac].coe02 IS NULL OR g_coe[l_ac].coe02 = 0 THEN
                SELECT max(coe02)+1
                   INTO g_coe[l_ac].coe02
                   FROM coe_file
                   WHERE coe01 = g_coc.coc01
                IF g_coe[l_ac].coe02 IS NULL THEN
                    LET g_coe[l_ac].coe02 = 1
                END IF
                 #NO.MOD-570129 MARK
                 #DISPLAY g_coe[l_ac].coe02 TO coe02              #No.MOD-490371
            END IF
 
        AFTER FIELD coe02                        #check 序號是否重複
            IF NOT cl_null(g_coe[l_ac].coe02) THEN
               IF g_coe[l_ac].coe02 != g_coe_t.coe02 OR
                  g_coe_t.coe02 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM coe_file
                       WHERE coe01 = g_coc.coc01 AND
                             coe02 = g_coe[l_ac].coe02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_coe[l_ac].coe02 = g_coe_t.coe02
                       NEXT FIELD coe02
                   END IF
               END IF
            END IF
 
        AFTER FIELD coe03
            IF NOT cl_null(g_coe[l_ac].coe03) THEN
              #-->check 是否存在海關商品檔
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_coe[l_ac].coe03 != g_coe_o.coe03) THEN
                  #No.MOD-490398
                 SELECT COUNT(*) INTO l_n FROM coa_file
                  WHERE coa03 = g_coe[l_ac].coe03
                    AND coa05 = g_coc.coc10
                 IF cl_null(l_n) THEN LET l_n =0 END IF
                 IF l_n <= 0
                   THEN CALL cl_err(g_coe[l_ac].coe03,'aco-001',0)
                        LET g_coe[l_ac].coe03 = g_coe_t.coe03
                         DISPLAY g_coe[l_ac].coe03 TO coe03         #No.MOD-490371
                        NEXT FIELD coe03
                 END IF
              END IF
            END IF
            LET g_coe_o.coe03 = g_coe[l_ac].coe03
 
        BEFORE FIELD coe05
            IF NOT cl_null(g_coe[l_ac].coe03) THEN
               IF p_cmd = 'a' OR (p_cmd = 'u' AND
                 g_coe[l_ac].coe03 != g_coe_o.coe03 )
               THEN
                  CALL i301_coe03(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     LET g_msg = g_coe[l_ac].coe03 clipped
                      CALL cl_err(g_msg,g_errno,0)
                     LET g_coe[l_ac].coe03 = g_coe_o.coe03
                      DISPLAY g_coe[l_ac].coe03 TO coe03      #No.MOD-490371
                     NEXT FIELD coe03
                  END IF
                  #-->單身的不可有相同的商品編號
                  SELECT COUNT(*) INTO l_n FROM coe_file
                   WHERE coe01 = g_coc.coc01
                     AND coe03 = g_coe[l_ac].coe03
                  IF l_n > 0 THEN
                     LET g_msg = g_coe[l_ac].coe03 clipped
                     CALL cl_err(g_msg,'aco-009',0)
                     LET g_coe[l_ac].coe03 = g_coe_t.coe03
                      DISPLAY g_coe[l_ac].coe03 TO coe03            #No.MOD-490371
                     NEXT FIELD coe03
                  END IF
               END IF
            END IF
            LET g_coe_o.coe03 = g_coe[l_ac].coe03
 
        AFTER FIELD coe05
           IF NOT i301_coe05_check() THEN NEXT FIELD coe05 END IF  #FUN-910088--add--
       #FUN-910088--mark--start--
       #    IF NOT cl_null(g_coe[l_ac].coe05) THEN
       #       IF g_coe[l_ac].coe05 <=0 THEN
       #          LET g_coe[l_ac].coe05 = g_coe_t.coe05
       #           DISPLAY g_coe[l_ac].coe05 TO coe05              #No.MOD-490371
       #          NEXT FIELD coe05
       #       END IF
       #        #No.MOD-490398
       #       LET g_coe[l_ac].coe08 = g_coe[l_ac].coe07 *
       #                             ( g_coe[l_ac].coe05 + g_coe[l_ac].coe10 )
       #       DISPLAY g_coe[l_ac].coe08 TO coe08
       #        #No.MOD-490398 END
       #    END IF
       #FUN-910088--mark--end--

       #FUN-910088--add--start--
        AFTER FIELD coe10
           CALL i301_coe10_check()    
       #FUN-910088--add--end--
 
        AFTER FIELD coe06
            IF NOT cl_null(g_coe[l_ac].coe06) THEN
               CALL i301_coe06('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_coe[l_ac].coe05 = g_coe_t.coe05
                   DISPLAY g_coe[l_ac].coe05 TO coe05             #No.MOD-490371
                   CALL cl_err(g_coe[l_ac].coe06,g_errno,0) 
                  NEXT FIELD coe06
               END IF
            #FUN-910088--add--start--
               CALL i301_coe10_check()
               #TQC-C20183--add--str--
               IF NOT cl_null(g_coe[l_ac].coe05) AND NOT cl_null(g_coe[l_ac].coe06) THEN
                  IF cl_null(g_coe06_t) OR cl_null(g_coe_t.coe05) OR g_coe06_t != g_coe[l_ac].coe06 OR g_coe_t.coe05 != g_coe[l_ac].coe05 THEN
                     LET g_coe[l_ac].coe05 = s_digqty(g_coe[l_ac].coe05,g_coe[l_ac].coe06)  
                     DISPLAY BY NAME g_coe[l_ac].coe05                                       
                  END IF
               END IF
               #TQC-C20183--add--end--
               #TQC-C20183--mark--str--
               #   IF NOT i301_coe05_check() THEN 
               #      LET g_coe06_t = g_coe[l_ac].coe06
               #      NEXT FIELD coe05
               #   END IF
               #TQC-C20183--mark--end--
               LET g_coe06_t = g_coe[l_ac].coe06
            #FUN-910088--add--end--
            END IF
 
        AFTER FIELD coe07
           IF NOT cl_null(g_coe[l_ac].coe07) THEN
              IF g_coe[l_ac].coe07 <= 0  THEN
                 LET g_coe[l_ac].coe07 = g_coe_t.coe07
                  DISPLAY g_coe[l_ac].coe07 TO coe07           #No.MOD-490371
                 NEXT FIELD coe07
              END IF
           END IF
           LET g_coe[l_ac].coe08 = g_coe[l_ac].coe07 *
                                 ( g_coe[l_ac].coe05 + g_coe[l_ac].coe10 )
            DISPLAY g_coe[l_ac].coe08 TO coe08             #No.MOD-490371
 
        AFTER FIELD coe11
            IF NOT cl_null(g_coe[l_ac].coe11) THEN
               IF g_coe_o.coe11 IS NULL OR
                 (g_coe[l_ac].coe11 != g_coe_o.coe11 ) THEN
                 CALL i301_coe11('a')
                 IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_coe[l_ac].coe11,g_errno,0) 
                    NEXT FIELD coe11
                 END IF
               END IF
            END IF
 
        AFTER FIELD coe12
            IF NOT cl_null(g_coe[l_ac].coe12) THEN
               IF g_coe_o.coe12 IS NULL OR
                 (g_coe[l_ac].coe12 != g_coe_o.coe12 ) THEN
                 CALL i301_coe12('a')
                 IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_coe[l_ac].coe12,g_errno,0)
                    NEXT FIELD coe12
                 END IF
               END IF
            END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD coeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_coe_t.coe02 > 0 AND
               g_coe_t.coe02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM coe_file
                    WHERE coe01 = g_coc.coc01 AND
                          coe02 = g_coe_t.coe02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_coe_t.coe02,SQLCA.sqlcode,0) #No.TQC-660045
                     CALL cl_err3("del","coe_file",g_coc.coc01,g_coe_t.coe02,SQLCA.sqlcode,"","",1)       #NO.TQC-660045
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
            CALL i301_update()
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_coe[l_ac].* = g_coe_t.*
               CLOSE i301_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_coe[l_ac].coe02,-263,1)
               LET g_coe[l_ac].* = g_coe_t.*
            ELSE
               UPDATE coe_file SET coe02=g_coe[l_ac].coe02,
                                   coe03=g_coe[l_ac].coe03,
                                    coe04=g_coc.coc10,        #No.MOD-490398
                                   coe05=g_coe[l_ac].coe05,
                                   coe06=g_coe[l_ac].coe06,
                                   coe07=g_coe[l_ac].coe07,
                                   coe08=g_coe[l_ac].coe08,
                                   coe10=g_coe[l_ac].coe10,
                                   coe11=g_coe[l_ac].coe11,
                                   coe12=g_coe[l_ac].coe12,
                                   #FUN-840202 --start--
                                   coeud01 = g_coe[l_ac].coeud01,
                                   coeud02 = g_coe[l_ac].coeud02,
                                   coeud03 = g_coe[l_ac].coeud03,
                                   coeud04 = g_coe[l_ac].coeud04,
                                   coeud05 = g_coe[l_ac].coeud05,
                                   coeud06 = g_coe[l_ac].coeud06,
                                   coeud07 = g_coe[l_ac].coeud07,
                                   coeud08 = g_coe[l_ac].coeud08,
                                   coeud09 = g_coe[l_ac].coeud09,
                                   coeud10 = g_coe[l_ac].coeud10,
                                   coeud11 = g_coe[l_ac].coeud11,
                                   coeud12 = g_coe[l_ac].coeud12,
                                   coeud13 = g_coe[l_ac].coeud13,
                                   coeud14 = g_coe[l_ac].coeud14,
                                   coeud15 = g_coe[l_ac].coeud15
                                   #FUN-840202 --end-- 
               WHERE coe01=g_coc.coc01 AND coe02=g_coe_t.coe02
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_coe[l_ac].coe02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("upd","coe_file",g_coc.coc01,g_coe_t.coe02,SQLCA.sqlcode,"","",1)       #NO.TQC-660045
                   LET g_coe[l_ac].* = g_coe_t.*
               ELSE
                   CALL i301_update()
                   IF g_success='Y' THEN
                      COMMIT WORK
                      MESSAGE 'UPDATE O.K'
                   ELSE
                      CALL cl_rbmsg(1) ROLLBACK WORK
                   END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_coe[l_ac].* = g_coe_t.*
               CLOSE i301_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET g_coe_t.* = g_coe[l_ac].*
            CLOSE i301_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(coe02) AND l_ac > 1 THEN
                LET g_coe[l_ac].* = g_coe[l_ac-1].*
                NEXT FIELD coe02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
               WHEN INFIELD(coe03) #料件編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cob"
                    LET g_qryparam.default1 = g_coe[l_ac].coe03
                     LET g_qryparam.where = " cob03 = '2' "    #No.MOD-490398
                    CALL cl_create_qry()
                         RETURNING g_coe[l_ac].coe03
#                    CALL FGL_DIALOG_SETBUFFER( g_coe[l_ac].coe03 )
                     DISPLAY g_coe[l_ac].coe03 TO coe03          #No.MOD-490371
                    NEXT FIELD coe03
               WHEN INFIELD(coe06) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_coe[l_ac].coe06
                    CALL cl_create_qry() RETURNING g_coe[l_ac].coe06
#                    CALL FGL_DIALOG_SETBUFFER( g_coe[l_ac].coe06 )
                    DISPLAY BY NAME g_coe[l_ac].coe06
                    NEXT FIELD coe06
               WHEN INFIELD(coe11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_geb"
                    LET g_qryparam.default1 = g_coe[l_ac].coe11
                    CALL cl_create_qry() RETURNING g_coe[l_ac].coe11
#                    CALL FGL_DIALOG_SETBUFFER( g_coe[l_ac].coe11 )
                    DISPLAY BY NAME g_coe[l_ac].coe11
                    NEXT FIELD coe11
               WHEN INFIELD(coe12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cnc"
                    LET g_qryparam.default1 = g_coe[l_ac].coe12
                    CALL cl_create_qry() RETURNING g_coe[l_ac].coe12
#                    CALL FGL_DIALOG_SETBUFFER( g_coe[l_ac].coe12 )
                    DISPLAY BY NAME g_coe[l_ac].coe12
                    NEXT FIELD coe12
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT 
 
    CLOSE i301_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i301_coe03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_price   LIKE cof_file.cof03,
           l_unit    LIKE cob_file.cob04,
           l_cob10   LIKE cob_file.cob10,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
    SELECT cob02,cob04,cob10,cobacti
           INTO g_coe[l_ac].cob02,l_unit,l_cob10,l_cobacti
           FROM cob_file
           WHERE cob01 = g_coe[l_ac].coe03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET l_cobacti = NULL
                                   LET g_coe[l_ac].cob02 = ' '
         WHEN l_cobacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' THEN
       SELECT cof03 INTO l_price FROM cof_file
        WHERE cof01 = g_coe[l_ac].coe03
          AND cof02 = g_coc.coc02
       IF SQLCA.sqlcode THEN LET l_price = 0  END IF
       LET g_coe[l_ac].coe06 = l_unit
       LET g_coe[l_ac].coe10 = s_digqty(g_coe[l_ac].coe10,g_coe[l_ac].coe06)    #FUN-910088--add--
       LET g_coe[l_ac].coe07 = l_price
       LET g_coe[l_ac].coe11 = l_cob10
       DISPLAY g_coe[l_ac].coe06 TO s_coe[l_sl].coe06
       DISPLAY g_coe[l_ac].coe07 TO s_coe[l_sl].coe07
       DISPLAY g_coe[l_ac].coe11 TO s_coe[l_sl].coe11
       DISPLAY g_coe[l_ac].coe10 TO s_coe[l_sl].coe10    #FUN-910088--add--
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_coe[l_ac].cob02 TO s_coe[l_sl].cob02
    END IF
END FUNCTION
 
FUNCTION i301_coe06(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_coe[l_ac].coe06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i301_coe11(p_cmd)  #產絡地
   DEFINE l_gebacti  LIKE geb_file.gebacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gebacti INTO l_gebacti FROM geb_file
                WHERE geb01 = g_coe[l_ac].coe11
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-152'
                            LET l_gebacti = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i301_coe12(p_cmd)  #征免性質
   DEFINE l_cncacti  LIKE cnc_file.cncacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT cncacti INTO l_cncacti FROM cnc_file
                WHERE cnc01 = g_coe[l_ac].coe12
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-015'
                            LET l_cncacti = NULL
         WHEN l_cncacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i301_b_askkey()
DEFINE
    l_wc2    LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON coe02,coe03,coe05,coe10,coe06,coe07,coe08,coe11,
                       coe12                    # 螢幕上取單身條件
                       #No.FUN-840202 --start--
                       ,coeud01,coeud02,coeud03,coeud04,coeud05
                       ,coeud06,coeud07,coeud08,coeud09,coeud10
                       ,coeud11,coeud12,coeud13,coeud14,coeud15
                       #No.FUN-840202 ---end---
            FROM s_coe[1].coe02,
                 s_coe[1].coe03,
                 s_coe[1].coe05,
                 s_coe[1].coe10,
                 s_coe[1].coe06,
                 s_coe[1].coe07,
                 s_coe[1].coe08,
                 s_coe[1].coe11,s_coe[1].coe12
                 #No.FUN-840202 --start--
                 ,s_coe[1].coeud01,s_coe[1].coeud02,s_coe[1].coeud03
                 ,s_coe[1].coeud04,s_coe[1].coeud05,s_coe[1].coeud06
                 ,s_coe[1].coeud07,s_coe[1].coeud08,s_coe[1].coeud09
                 ,s_coe[1].coeud10,s_coe[1].coeud11,s_coe[1].coeud12
                 ,s_coe[1].coeud13,s_coe[1].coeud14,s_coe[1].coeud15
                 #No.FUN-840202 ---end---
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i301_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i301_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
        "SELECT coe02,coe03,cob02,coe05,coe10,coe06,coe07,coe08,coe11,coe12,",
        #No.FUN-840202 --start--
        "       coeud01,coeud02,coeud03,coeud04,coeud05,",
        "       coeud06,coeud07,coeud08,coeud09,coeud10,",
        "       coeud11,coeud12,coeud13,coeud14,coeud15 ", 
        #No.FUN-840202 ---end---
        "  FROM coe_file LEFT OUTER JOIN cob_file ON coe_file.coe03 = cob_file.cob01",
        " WHERE coe01 ='",g_coc.coc01,"' AND ",  #單頭
    #No.FUN-8B0123---Begin
        " coe03=cob_file.cob01 "   #AND ", #MOD-970071 去掉多余的AND 
    #   p_wc2 CLIPPED,    #單身
    #   " ORDER BY 1,2"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i301_pb FROM g_sql
    DECLARE coe_cs                       #SCROLL CURSOR
        CURSOR FOR i301_pb
 
    CALL g_coe.clear()
    LET g_cnt = 1
    FOREACH coe_cs INTO g_coe[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_coe.deleteElement(g_cnt)  #TQC-790066
    LET g_rec_b = g_cnt - 1
        DISPLAY g_rec_b TO FORMONLY.cn2
        LET g_cnt = 0
END FUNCTION
 
FUNCTION i301_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_coe TO s_coe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i301_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i301_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i301_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i301_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i301_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
         LET l_ac = 1
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 產生進口材料
 #No.MOD-490398
#     ON ACTION gen_imports
#        LET g_action_choice="gen_imports"
#        EXIT DISPLAY
      #@ON ACTION 出口成品資料查詢
      ON ACTION query_exports
         LET g_action_choice="query_exports"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0168  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i301_update()
 DEFINE l_coc08 LIKE coc_file.coc08
 
   SELECT SUM(coe08) INTO l_coc08 FROM coe_file
    WHERE coe01=g_coc.coc01
   IF cl_null(l_coc08) THEN LET l_coc08 = 0 END IF
   UPDATE coc_file SET coc08=l_coc08
    WHERE coc01=g_coc.coc01
   IF STATUS THEN
#      CALL cl_err('upd coc08:',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","coc_file",g_coc.coc01,"",STATUS,"","upd coc08:",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
   DISPLAY l_coc08 TO coc08
END FUNCTION
 
FUNCTION i301_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_coc.coc01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i301_cl USING g_coc.coc01
    IF STATUS THEN
       CALL cl_err("OPEN i301_cl:", STATUS, 1)
       CLOSE i301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i301_cl INTO g_coc.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i301_show()
    IF cl_exp(0,0,g_coc.cocacti) THEN                   #審核一下
        LET g_chr=g_coc.cocacti
        IF g_coc.cocacti='Y' THEN
            LET g_coc.cocacti='N'
        ELSE
            LET g_coc.cocacti='Y'
        END IF
        UPDATE coc_file                    #更改有效碼
            SET cocacti=g_coc.cocacti
            WHERE coc01=g_coc.coc01
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","coc_file",g_coc.coc01,"",SQLCA.sqlcode,"","",1)       #NO.TQC-660045
            LET g_coc.cocacti=g_chr
        END IF
        DISPLAY BY NAME g_coc.cocacti
    END IF
    CLOSE i301_cl
    COMMIT WORK
END FUNCTION
#Patch....NO.TQC-610035 <001> #

#FUN-910088--add--start--
FUNCTION i301_coe05_check()
   IF NOT cl_null(g_coe[l_ac].coe05) AND NOT cl_null(g_coe[l_ac].coe06) THEN
      IF cl_null(g_coe06_t) OR cl_null(g_coe_t.coe05) OR g_coe06_t != g_coe[l_ac].coe06 OR g_coe_t.coe05 != g_coe[l_ac].coe05 THEN
         LET g_coe[l_ac].coe05 = s_digqty(g_coe[l_ac].coe05,g_coe[l_ac].coe06)   
         DISPLAY BY NAME g_coe[l_ac].coe05
      END IF
   END IF   
   IF NOT cl_null(g_coe[l_ac].coe05) THEN
      IF g_coe[l_ac].coe05 <=0 THEN
         LET g_coe[l_ac].coe05 = g_coe_t.coe05
         DISPLAY g_coe[l_ac].coe05 TO coe05                                 
         RETURN FALSE    
      END IF
      LET g_coe[l_ac].coe08 = g_coe[l_ac].coe07 *
                            ( g_coe[l_ac].coe05 + g_coe[l_ac].coe10 )
      DISPLAY g_coe[l_ac].coe08 TO coe08
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i301_coe10_check()
   IF NOT cl_null(g_coe[l_ac].coe10) AND NOT cl_null(g_coe[l_ac].coe06) THEN
      IF cl_null(g_coe06_t) OR cl_null(g_coe_t.coe10) OR g_coe06_t != g_coe[l_ac].coe06 OR g_coe_t.coe10 != g_coe[l_ac].coe10 THEN
         LET g_coe[l_ac].coe10 = s_digqty(g_coe[l_ac].coe10,g_coe[l_ac].coe06)          
         DISPLAY BY NAME g_coe[l_ac].coe10
      END IF
   END IF
END FUNCTION
#FUN-910088--add--end--
