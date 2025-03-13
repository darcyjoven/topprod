# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acoi300.4gl
# Descriptions...: 加工合同出口成品資料維護作業
# Date & Author..: 00/04/29 By Kammy
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/10 By Danny add coc10
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改
# Modify.........: NO.FUN-570129 05/08/05 BY yiting 單身只有行序時只能放棄才能離
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-660072 06/06/15 By Dido 補充TQC-630070
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-740287 07/04/30 By Carol 單身單身資料時先按新增後再按放棄原畫面的單身資料不被清空
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/08 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ACO
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 12/01/13 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_coc           RECORD LIKE coc_file.*,       #單頭
    g_coc_t         RECORD LIKE coc_file.*,       #單頭(舊值)
    g_coc_o         RECORD LIKE coc_file.*,       #單頭(舊值)
    g_coc01_t       LIKE coc_file.coc01,   #單頭 (舊值)
    g_coc04_t       LIKE coc_file.coc01,   #合同編號
    g_t1            LIKE oay_file.oayslip,          #No.FUn-560002        #No.FUN-680069 VARCHAR(05)
    g_cod           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        cod02       LIKE cod_file.cod02,   #項次
        cod03       LIKE cod_file.cod03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        cod041      LIKE cod_file.cod041,  #BOM版本編號
        cod05       LIKE cod_file.cod05,   #
        cod10       LIKE cod_file.cod10,   #
        cod06       LIKE cod_file.cod06,   #
        cod07       LIKE cod_file.cod07,   #
        cod08       LIKE cod_file.cod08,   #
        cod11       LIKE cod_file.cod11,   #
        cod12       LIKE cod_file.cod12,   #
        #FUN-840202 --start---
        codud01     LIKE cod_file.codud01,
        codud02     LIKE cod_file.codud02,
        codud03     LIKE cod_file.codud03,
        codud04     LIKE cod_file.codud04,
        codud05     LIKE cod_file.codud05,
        codud06     LIKE cod_file.codud06,
        codud07     LIKE cod_file.codud07,
        codud08     LIKE cod_file.codud08,
        codud09     LIKE cod_file.codud09,
        codud10     LIKE cod_file.codud10,
        codud11     LIKE cod_file.codud11,
        codud12     LIKE cod_file.codud12,
        codud13     LIKE cod_file.codud13,
        codud14     LIKE cod_file.codud14,
        codud15     LIKE cod_file.codud15
        #FUN-840202 --end--
                    END RECORD,
    g_cod_t         RECORD                 #程式變數 (舊值)
        cod02       LIKE cod_file.cod02,   #項次
        cod03       LIKE cod_file.cod03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        cod041      LIKE cod_file.cod041,  #BOM版本編號
        cod05       LIKE cod_file.cod05,   #
        cod10       LIKE cod_file.cod10,   #
        cod06       LIKE cod_file.cod06,   #
        cod07       LIKE cod_file.cod07,   #
        cod08       LIKE cod_file.cod08,   #
        cod11       LIKE cod_file.cod11,   #
        cod12       LIKE cod_file.cod12,   #
        #FUN-840202 --start---
        codud01     LIKE cod_file.codud01,
        codud02     LIKE cod_file.codud02,
        codud03     LIKE cod_file.codud03,
        codud04     LIKE cod_file.codud04,
        codud05     LIKE cod_file.codud05,
        codud06     LIKE cod_file.codud06,
        codud07     LIKE cod_file.codud07,
        codud08     LIKE cod_file.codud08,
        codud09     LIKE cod_file.codud09,
        codud10     LIKE cod_file.codud10,
        codud11     LIKE cod_file.codud11,
        codud12     LIKE cod_file.codud12,
        codud13     LIKE cod_file.codud13,
        codud14     LIKE cod_file.codud14,
        codud15     LIKE cod_file.codud15
        #FUN-840202 --end--
                    END RECORD,
    g_cod_o         RECORD                 #程式變數 (舊值)
        cod02       LIKE cod_file.cod02,   #項次
        cod03       LIKE cod_file.cod03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        cod041      LIKE cod_file.cod041,  #BOM版本編號
        cod05       LIKE cod_file.cod05,   #
        cod10       LIKE cod_file.cod10,   #
        cod06       LIKE cod_file.cod06,   #
        cod07       LIKE cod_file.cod07,   #
        cod08       LIKE cod_file.cod08,   #
        cod11       LIKE cod_file.cod11,   #
        cod12       LIKE cod_file.cod12,   #
        #FUN-840202 --start---
        codud01     LIKE cod_file.codud01,
        codud02     LIKE cod_file.codud02,
        codud03     LIKE cod_file.codud03,
        codud04     LIKE cod_file.codud04,
        codud05     LIKE cod_file.codud05,
        codud06     LIKE cod_file.codud06,
        codud07     LIKE cod_file.codud07,
        codud08     LIKE cod_file.codud08,
        codud09     LIKE cod_file.codud09,
        codud10     LIKE cod_file.codud10,
        codud11     LIKE cod_file.codud11,
        codud12     LIKE cod_file.codud12,
        codud13     LIKE cod_file.codud13,
        codud14     LIKE cod_file.codud14,
        codud15     LIKE cod_file.codud15
        #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE coc_file.coc01,        # 詢價單號
    g_argv2         STRING ,     #No.FUN-680069    #TQC-630070      #執行功能
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql        STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_cod06_t      LIKE cod_file.cod06          #FUN-910088--add--
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5         #No.FUN-680069 SMALLINT
#       l_time    LIKE type_file.chr8            #No.FUN-6A0063
 
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
    LET g_argv2 = ARG_VAL(2)   #執行功能   #TQC-630070
 
    LET g_forupd_sql = " SELECT * FROM coc_file WHERE coc01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW i300_w AT p_row,p_col
        WITH FORM "aco/42f/acoi300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #start TQC-630070
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i300_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i300_a()
             END IF
          OTHERWISE          #TQC-660072
             CALL i300_q()   #TQC-660072
       END CASE
    END IF
    #end TQC-630070
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
    THEN CALL i300_q()
    END IF
    CALL i300_menu()
    CLOSE WINDOW i300_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION i300_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_cod.clear()
 
  IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
     LET g_wc = " coc01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
     CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INITIALIZE g_coc.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
         coc01,coc02,coc10,                #No.MOD-490398
         coc03,coc04,
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
     ON ACTION controlp  #ok
           CASE
              WHEN INFIELD(coc01) #單別
                 #CALL q_coy(FALSE,TRUE,g_coc.coc01,'10',g_sys)  #TQC-670008
                 CALL q_coy(FALSE,TRUE,g_coc.coc01,'10','ACO')   #TQC-670008
                         RETURNING g_coc.coc01
                  DISPLAY BY NAME g_coc.coc01
                 NEXT FIELD coc01
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
 
     CONSTRUCT g_wc2 ON cod02,cod03,cod041,cod05,   #螢幕上取單身條件
                        cod10,cod06,cod07,cod08,cod11,cod12
                        #No.FUN-840202 --start--
                        ,codud01,codud02,codud03,codud04,codud05
                        ,codud06,codud07,codud08,codud09,codud10
                        ,codud11,codud12,codud13,codud14,codud15
                        #No.FUN-840202 ---end---
            FROM s_cod[1].cod02,s_cod[1].cod03,s_cod[1].cod041,
                 s_cod[1].cod05,s_cod[1].cod10,s_cod[1].cod06,
                 s_cod[1].cod07,s_cod[1].cod08,s_cod[1].cod11,s_cod[1].cod12
                 #No.FUN-840202 --start--
                 ,s_cod[1].codud01,s_cod[1].codud02,s_cod[1].codud03
                 ,s_cod[1].codud04,s_cod[1].codud05,s_cod[1].codud06
                 ,s_cod[1].codud07,s_cod[1].codud08,s_cod[1].codud09
                 ,s_cod[1].codud10,s_cod[1].codud11,s_cod[1].codud12
                 ,s_cod[1].codud13,s_cod[1].codud14,s_cod[1].codud15
                 #No.FUN-840202 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp  #ok
            CASE
               WHEN INFIELD(cod03) #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_cob"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cod03
                 NEXT FIELD cod03
               WHEN INFIELD(cod06) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cod06
                 NEXT FIELD cod06
               WHEN INFIELD(cod11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_geb"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cod11
                 NEXT FIELD cod11
               WHEN INFIELD(cod12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_cnc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cod12
                 NEXT FIELD cod12
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
                   "  FROM coc_file, cod_file ",
                   " WHERE coc01 = cod01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY coc01"
    END IF
 
    PREPARE i300_prepare FROM g_sql
    DECLARE i300_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i300_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM coc_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT coc01) FROM coc_file,cod_file WHERE ",
                  "cod01=coc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i300_precount FROM g_sql
    DECLARE i300_count CURSOR FOR i300_precount
END FUNCTION
 
FUNCTION i300_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i300_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i300_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i300_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i300_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i300_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i300_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cod),'','')
             END IF
         #--
 
         WHEN "mntn_imports"
            IF cl_chk_act_auth() THEN
                #No.MOD-490398
               IF cl_null(g_coc.coc07) THEN
                  CALL s_ins_coe(g_coc.coc01,0)
               END IF
                #No.MOD-490398  end
               LET l_cmd="acoi301 '",g_coc.coc01,"'"
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "query_quality"
            LET l_cmd="acoq500 '",g_coc.coc01,"'"
            CALL cl_cmdrun(l_cmd)
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
 
#Add  輸入
FUNCTION i300_a()
#No.FUN-560002--begin
  DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
    MESSAGE ""
    CLEAR FORM
    CALL g_cod.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_coc.* LIKE coc_file.*             #DEFAULT 設置
    LET g_coc01_t = NULL
    LET g_coc04_t = NULL
    LET g_coc_t.* = g_coc.*
    LET g_coc_o.* = g_coc.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_coc.coc08 = 0
        LET g_coc.coc09 = 0
         LET g_coc.coc10 = g_coz.coz02            #No.MOD-490398
        LET g_coc.cocuser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_coc.cocgrup=g_grup
        LET g_coc.cocdate=g_today
        LET g_coc.cocacti='Y'              #資料有效
        LET g_coc.cocplant = g_plant  #FUN-980002
        LET g_coc.coclegal = g_legal  #FUN-980002
 
        #TQC-630070 --start--
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_coc.coc01 = g_argv1
        END IF
        #TQC-630070 ---end---
 
        BEGIN WORK
        CALL i300_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_coc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_coc.coc01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
#No.FUN-560002--begin
        BEGIN WORK
#       CALL s_auto_assign_no(g_sys,g_coc.coc01,g_today,"10","coc_file","coc01","","","")
        CALL s_auto_assign_no("aco",g_coc.coc01,g_today,"10","coc_file","coc01","","","")   #No.FUN-A40041
        RETURNING li_result,g_coc.coc01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
#       IF cl_null(g_coc.coc01[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_coc.coc01,g_today,'10')
#            RETURNING g_i,g_coc.coc01
#          IF g_i THEN CONTINUE WHILE END IF
           DISPLAY BY NAME g_coc.coc01
#       END IF
#No.FUN-560002--end
         IF g_coc.coc10 IS NULL THEN LET g_coc.coc10 = ' 'END IF   #No.MOD-490398
        LET g_coc.cocoriu = g_user      #No.FUN-980030 10/01/04
        LET g_coc.cocorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO coc_file VALUES (g_coc.*)
#       LET g_t1 = g_coc.coc01[1,3]           #備份上一筆單別
        LET g_t1=s_get_doc_no(g_coc.coc01)
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
#            CALL cl_err(g_coc.coc01,SQLCA.sqlcode,1)
             CALL cl_err3("ins","coc_file",g_coc.coc01,"",SQLCA.sqlcode,"","",1)           #NO.TQC-660045
            CONTINUE WHILE
        END IF
 
        SELECT COUNT(*) INTO g_cnt FROM cng_file
         WHERE cng03 = g_coc.coc03
           AND cng04 = g_coc.coc04
           AND cngconf <> 'X'  #CHI-C80041
        IF g_cnt > 0 THEN
           UPDATE cng_file SET cng05 = g_coc.coc05,
                               cng06 = g_coc.coc06
              WHERE cng03 = g_coc.coc03
                AND cng04 = g_coc.coc04
                AND cngconf <> 'X'  #CHI-C80041
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
               CALL cl_err3("upd","cng_file",g_coc.coc01,"",SQLCA.sqlcode,"","",1)           #NO.TQC-660045
              CONTINUE WHILE
           END IF
        END IF
 
        COMMIT WORK
        CALL cl_flow_notify(g_coc.coc01,'I')
        SELECT coc01 INTO g_coc.coc01 FROM coc_file
            WHERE coc01 = g_coc.coc01
        LET g_coc01_t = g_coc.coc01        #保留舊值
        LET g_coc04_t = g_coc.coc04        #保留舊值
        LET g_coc_t.* = g_coc.*
        LET g_coc_o.* = g_coc.*
        LET g_rec_b=0
        CALL i300_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i300_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_coc.coc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_coc.* FROM coc_file WHERE coc01=g_coc.coc01
    IF g_coc.cocacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_coc.coc01,'mfg1000',0)
        RETURN
    END IF
     IF NOT cl_null(g_coc.coc07) OR g_coc.coc05 < g_today THEN    #No.MOD-490398
       CALL cl_err(g_coc.coc04,'aco-060',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_coc01_t = g_coc.coc01
    LET g_coc04_t = g_coc.coc04
    BEGIN WORK
 
    OPEN i300_cl USING g_coc.coc01
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:", STATUS, 1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_coc.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i300_cl
        RETURN
    END IF
    CALL i300_show()
    WHILE TRUE
        LET g_coc01_t = g_coc.coc01
        LET g_coc04_t = g_coc.coc04
        LET g_coc_o.* = g_coc.*
        LET g_coc.cocmodu=g_user
        LET g_coc.cocdate=g_today
        CALL i300_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_coc.*=g_coc_t.*
            CALL i300_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_coc.coc01 != g_coc01_t THEN            # 更改單號
            UPDATE cod_file SET cod01 = g_coc.coc01
                WHERE cod01 = g_coc01_t
            IF SQLCA.sqlcode THEN
 #               CALL cl_err('cod',SQLCA.sqlcode,0) #TQC-660045
                 CALL cl_err3("upd","cod_file",g_coc01_t,"",SQLCA.sqlcode,"","upd",1)           #NO.TQC-660045
                 CONTINUE WHILE
            END IF
        END IF
        UPDATE coc_file SET coc_file.* = g_coc.*
            WHERE coc01 = g_coc.coc01
        IF SQLCA.sqlcode THEN
 #           CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0) #TQC-660045
             CALL cl_err3("upd","coc_file",g_coc01_t,"",SQLCA.sqlcode,"","",1)           #NO.TQC-660045
            CONTINUE WHILE
        END IF
 
        SELECT COUNT(*) INTO g_cnt FROM cng_file
         WHERE cng03 = g_coc.coc03
           AND cng04 = g_coc.coc04
           AND cngconf <> 'X'  #CHI-C80041
        IF g_cnt > 0 THEN
           UPDATE cng_file SET cng05 = g_coc.coc05,
                               cng06 = g_coc.coc06
              WHERE cng03 = g_coc.coc03
                AND cng04 = g_coc.coc04
                AND cngconf <> 'X'  #CHI-C80041
           IF SQLCA.sqlcode THEN
 #             CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
               CALL cl_err3("upd","cng_file",g_coc01_t,"",SQLCA.sqlcode,"","",1)           #NO.TQC-660045
              CONTINUE WHILE
           END IF
        END IF
 
        EXIT WHILE
    END WHILE
    CLOSE i300_cl
    COMMIT WORK
    CALL cl_flow_notify(g_coc.coc01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION i300_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n,l_i   LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    p_cmd     LIKE type_file.chr1     #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
#No.FUN-560002--begin
    DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    DISPLAY BY NAME
        g_coc.coc01,g_coc.coc02,g_coc.coc03,g_coc.coc04,
        g_coc.coc06,g_coc.coc05,g_coc.coc07,
        g_coc.coc08,g_coc.coc09,
        g_coc.cocuser,g_coc.cocgrup,g_coc.cocmodu,g_coc.cocdate,g_coc.cocacti
 
    INPUT BY NAME
        g_coc.coc01,g_coc.coc02,g_coc.coc10,g_coc.coc03,g_coc.coc04,  #No.MOD-490398
        g_coc.coc06,g_coc.coc05,g_coc.coc07,
        g_coc.coc08,g_coc.coc09,g_coc.cocuser,
        g_coc.cocgrup,g_coc.cocmodu,g_coc.cocdate,g_coc.cocacti,
        #FUN-840202     ---start---
        g_coc.cocud01,g_coc.cocud02,g_coc.cocud03,g_coc.cocud04,
        g_coc.cocud05,g_coc.cocud06,g_coc.cocud07,g_coc.cocud08,
        g_coc.cocud09,g_coc.cocud10,g_coc.cocud11,g_coc.cocud12,
        g_coc.cocud13,g_coc.cocud14,g_coc.cocud15 
        #FUN-840202     ----end----
                      WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i300_set_entry(p_cmd)
            CALL i300_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-560002--begin
            CALL cl_set_docno_format("coc01")
        AFTER FIELD coc01
#No.FUN-560002--end
            IF NOT cl_null(g_coc.coc01) THEN
#              CALL s_check_no(g_sys,g_coc.coc01,g_coc_t.coc01,"10","coc_file","coc01","")
               CALL s_check_no("aco",g_coc.coc01,g_coc_t.coc01,"10","coc_file","coc01","")   #No.FUN-A40041
               RETURNING li_result,g_coc.coc01
               IF (NOT li_result) THEN
                   LET g_coc.coc01 = g_coc_o.coc01
                   NEXT FIELD coc01
               END IF
#              LET g_t1=g_coc.coc01[1,3]
#              CALL s_acoslip(g_t1,'10',g_sys)             #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_coc.coc01=g_coc_o.coc01
#                 NEXT FIELD coc01
#              END IF
               IF p_cmd = 'a'  THEN
#	          IF g_coc.coc01[1,3] IS NOT NULL AND       #並且單號空白時,
#	          	  cl_null(g_coc.coc01[5,10]) THEN           #請用戶自行輸入
	          IF g_coc.coc01[1,g_doc_len] IS NOT NULL AND       #並且單號空白時,
	          	  cl_null(g_coc.coc01[g_no_sp,g_no_ep]) THEN           #請用戶自行輸入
	             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
	                NEXT FIELD coc01
	             ELSE					 #要不, 則單號不用
	                NEXT FIELD coc02			 #輸入
  	             END IF
	           END IF
#                 IF g_coc.coc01[1,3] IS NOT NULL AND	 #並且單號空白時,
#               	   NOT cl_null(g_coc.coc01[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_coc.coc01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD coc01
#                     END IF
#                  END IF
               END IF
#              IF g_coc.coc01 != g_coc01_t OR g_coc01_t IS NULL THEN
#                  SELECT count(*) INTO l_n FROM coc_file
#                      WHERE coc01 = g_coc.coc01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_coc.coc01,-239,0)
#                      LET g_coc.coc01 = g_coc01_t
#                      DISPLAY BY NAME g_coc.coc01
#                      NEXT FIELD coc01
#                  END IF
#              END IF
#No.FUN-560002--end
            END IF
 
        AFTER FIELD coc02                  #幣別
            IF NOT cl_null(g_coc.coc02) THEN
               IF g_coc_o.coc02 IS NULL OR
                  (g_coc_o.coc02 != g_coc.coc02) THEN
                  CALL i300_coc02(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_coc.coc02,g_errno,0)
                     LET g_coc.coc02 = g_coc_o.coc02
                     DISPLAY BY NAME g_coc.coc02
                     NEXT FIELD coc02
                  END IF
               END IF
            END IF
            LET g_coc_o.coc02 = g_coc.coc02
 
        AFTER FIELD coc03
            IF g_coc.coc03 != g_coc_t.coc03 OR g_coc_t.coc03 IS NULL THEN
                SELECT count(*) INTO l_n FROM coc_file
                    WHERE coc03 = g_coc.coc03
                IF l_n > 0 THEN   #單據編號重複
                    CALL cl_err(g_coc.coc01,'aco-008',0)
                    LET g_coc.coc03 = g_coc_t.coc03
                    DISPLAY BY NAME g_coc.coc03
                    NEXT FIELD coc03
                END IF
            END IF
 
        AFTER FIELD coc04
            IF g_coc.coc04 != g_coc04_t OR g_coc04_t IS NULL THEN
                SELECT count(*) INTO l_n FROM coc_file
                    WHERE coc04 = g_coc.coc04
                IF l_n > 0 THEN   #單據編號重複
                    CALL cl_err(g_coc.coc01,'aco-008',0)
                    LET g_coc.coc04 = g_coc04_t
                    DISPLAY BY NAME g_coc.coc04
                    NEXT FIELD coc04
                END IF
            END IF
 
       AFTER FIELD coc05
           IF NOT cl_null(g_coc.coc05) THEN
               IF g_coc.coc05 < g_today THEN NEXT FIELD coc05 END IF
           END IF
 
        #No.MOD-490398
        AFTER FIELD coc10                         #海關代號
            IF g_coc.coc10 IS NULL THEN LET g_coc.coc10 = ' ' END IF
            IF NOT cl_null(g_coc.coc10) THEN
               CALL i300_coc10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_coc.coc10,g_errno,0)
                  NEXT FIELD coc10
               END IF
            END IF
        #No.MOD-490398 end
 
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
              WHEN INFIELD(coc01) #單別
                 #CALL q_coy(FALSE,TRUE,g_coc.coc01,'10',g_sys)  #TQC-670008
                 CALL q_coy(FALSE,TRUE,g_coc.coc01,'10','ACO')   #TQC-670008
                         RETURNING g_coc.coc01
#                 CALL FGL_DIALOG_SETBUFFER( g_coc.coc01 )
                  DISPLAY BY NAME g_coc.coc01
                 NEXT FIELD coc01
               WHEN INFIELD(coc02) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_coc.coc02
                 CALL cl_create_qry() RETURNING g_coc.coc02
#                 CALL FGL_DIALOG_SETBUFFER( g_coc.coc02 )
                 DISPLAY BY NAME g_coc.coc02
                 CALL i300_coc02('d')
                 NEXT FIELD coc02
               #No.MOD-490398
               WHEN INFIELD(coc10)      #海關代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cna"
                 LET g_qryparam.default1 = g_coc.coc10
                 CALL cl_create_qry() RETURNING g_coc.coc10
#                CALL FGL_DIALOG_SETBUFFER( g_coc.coc10 )
                 DISPLAY BY NAME g_coc.coc10
                 NEXT FIELD coc10
                #No.MOD-490398 end
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
 
 #No.MOD-490398
FUNCTION i300_coc10(p_cmd)  #
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file WHERE cna01 = g_coc.coc10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
         WHEN l_cnaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 #No.MOD-490398 end
 
FUNCTION i300_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("coc01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i300_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("coc01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i300_coc02(p_cmd)  #幣別
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
 
#Query 查詢
FUNCTION i300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cod.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i300_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_coc.* TO NULL
        RETURN
    END IF
    OPEN i300_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_coc.* TO NULL
    ELSE
        OPEN i300_count
        FETCH i300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i300_cs INTO g_coc.coc01
        WHEN 'P' FETCH PREVIOUS i300_cs INTO g_coc.coc01
        WHEN 'F' FETCH FIRST    i300_cs INTO g_coc.coc01
        WHEN 'L' FETCH LAST     i300_cs INTO g_coc.coc01
        WHEN '/'
 
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
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
 
         END IF
         FETCH ABSOLUTE g_jump i300_cs INTO g_coc.coc01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
        INITIALIZE g_coc.* TO NULL               #No.FUN-6A0168
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
    SELECT * INTO g_coc.* FROM coc_file WHERE coc01 = g_coc.coc01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
         CALL cl_err3("sel","coc_file",g_coc.coc01,"",SQLCA.sqlcode,"","",1)           #NO.TQC-660045
         INITIALIZE g_coc.* TO NULL
        RETURN
    END IF
 
    CALL i300_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i300_show()
    LET g_coc_t.* = g_coc.*                #保存單頭舊值
    LET g_coc_o.* = g_coc.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_coc.coc01,g_coc.coc02,g_coc.coc03,g_coc.coc04,g_coc.coc05,
        g_coc.coc06,g_coc.coc07,g_coc.coc08,g_coc.coc09,g_coc.coc10,  #No.MOD-490398
        g_coc.cocuser,
        g_coc.cocgrup,g_coc.cocmodu,g_coc.cocdate,g_coc.cocacti,
        #FUN-840202     ---start---
        g_coc.cocud01,g_coc.cocud02,g_coc.cocud03,g_coc.cocud04,
        g_coc.cocud05,g_coc.cocud06,g_coc.cocud07,g_coc.cocud08,
        g_coc.cocud09,g_coc.cocud10,g_coc.cocud11,g_coc.cocud12,
        g_coc.cocud13,g_coc.cocud14,g_coc.cocud15 
        #FUN-840202     ----end----
 
    CALL i300_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i300_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_coc.coc01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i300_cl USING g_coc.coc01
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:", STATUS, 1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_coc.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i300_show()
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
#            CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
             CALL cl_err3("upd","coc_file",g_coc.coc01,"",SQLCA.sqlcode,"","",1)           #NO.TQC-660045
            LET g_coc.cocacti=g_chr
        END IF
        DISPLAY BY NAME g_coc.cocacti
    END IF
    CLOSE i300_cl
    COMMIT WORK
    CALL cl_flow_notify(g_coc.coc01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION i300_r()
 DEFINE l_i LIKE type_file.num5          #No.FUN-680069 SMALLINT
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
 
    OPEN i300_cl USING g_coc.coc01
    IF STATUS THEN
       CALL cl_err("OPEN i300_cl:", STATUS, 1)
       CLOSE i300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i300_cl INTO g_coc.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i300_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "coc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_coc.coc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM coc_file WHERE coc01 = g_coc.coc01
            DELETE FROM cod_file WHERE cod01 = g_coc.coc01
            DELETE FROM coe_file WHERE coe01 = g_coc.coc01
 
            SELECT COUNT(*) INTO l_i FROM cng_file
             WHERE cng03 = g_coc.coc03
               AND cng04 = g_coc.coc04
               AND cngconf <> 'X'  #CHI-C80041
            IF l_i > 0 THEN
                UPDATE cng_file SET cng03='',cng04='',cng05='',cng12='', #No.MOD-490398  By carrier
                                   cng06='',cng07='',cng10=''
                WHERE cng03 = g_coc.coc03 AND cng04 = g_coc.coc04
                  AND cngconf <> 'X'  #CHI-C80041
            END IF
             #No.MOD-490398
            LET g_msg=TIME
            INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980002 add azoplant,azolegal
               VALUES ('acoi300',g_user,g_today,g_msg,g_coc.coc01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
             #No.MOD-490398 end
            CLEAR FORM
            CALL g_cod.clear()
 
         OPEN i300_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i300_cs
            CLOSE i300_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i300_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i300_cs
            CLOSE i300_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i300_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i300_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i300_fetch('/')
         END IF
    END IF
    CLOSE i300_cl
    COMMIT WORK
    CALL cl_flow_notify(g_coc.coc01,'D')
END FUNCTION
 
#單身
FUNCTION i300_b()
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
     IF NOT cl_null(g_coc.coc07) OR g_coc.coc05 < g_today THEN    #No.MOD-490398
       CALL cl_err(g_coc.coc04,'aco-060',0)
       RETURN
    END IF
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT cod02,cod03,'',cod041, ",
                       " cod05,cod10,cod06,cod07,cod08,cod11,cod12, ",
                       #No.FUN-840202 --start--
                       "       codud01,codud02,codud03,codud04,codud05,",
                       "       codud06,codud07,codud08,codud09,codud10,",
                       "       codud11,codud12,codud13,codud14,codud15 ", 
                       #No.FUN-840202 ---end---
                       "   FROM cod_file ",
                       "  WHERE cod01=? AND cod02=? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_cod.clear() END IF
 
        INPUT ARRAY g_cod WITHOUT DEFAULTS FROM s_cod.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i300_cl USING g_coc.coc01
            IF STATUS THEN
               CALL cl_err("OPEN i300_cl:", STATUS, 1)
               CLOSE i300_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i300_cl INTO g_coc.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i300_cl
              RETURN
            END IF
 
            # 修改狀態時才作備份舊值的動作
            IF g_rec_b >= l_ac THEN
                LET p_cmd="u"
                LET g_cod_t.* = g_cod[l_ac].*  #BACKUP
                LET g_cod_o.* = g_cod[l_ac].*  #BACKUP
                LET g_cod06_t = g_cod[l_ac].cod06   #FUN-910088--add--
 
                OPEN i300_bcl USING g_coc.coc01,g_cod_t.cod02
                IF STATUS THEN
                   CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                   CLOSE i300_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i300_bcl INTO g_cod[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cod_t.cod02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL i300_cod03('D')
            END IF
#           NEXT FIELD cod02
 
        BEFORE INSERT
            LET p_cmd="a"
            LET l_n = ARR_COUNT()
            INITIALIZE g_cod[l_ac].* TO NULL       #900423
            LET g_cod[l_ac].cod05 = 0              #Body default
            LET g_cod[l_ac].cod08 = 0              #Body default
            LET g_cod[l_ac].cod10 = 0              #Body default
            LET g_cod_t.* = g_cod[l_ac].*          #新輸入資料
            LET g_cod_o.* = g_cod[l_ac].*          #新輸入資料
            LET g_cod06_t = NULL                   #FUN-910088--add--
            NEXT FIELD cod02
 
        BEFORE FIELD cod02                        #default 序號
            IF g_cod[l_ac].cod02 IS NULL OR g_cod[l_ac].cod02 = 0 THEN
                SELECT max(cod02)+1
                   INTO g_cod[l_ac].cod02
                   FROM cod_file
                   WHERE cod01 = g_coc.coc01
                IF g_cod[l_ac].cod02 IS NULL THEN
                    LET g_cod[l_ac].cod02 = 1
                END IF
                 #NO.MOD-570129 MARK
                #DISPLAY g_cod[l_ac].cod02 TO cod02
            END IF
 
        AFTER FIELD cod02                        #check 序號是否重複
            IF NOT g_cod[l_ac].cod02 IS NULL THEN
               IF g_cod[l_ac].cod02 != g_cod_t.cod02 OR
                  g_cod_t.cod02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM cod_file
                       WHERE cod01 = g_coc.coc01 AND
                             cod02 = g_cod[l_ac].cod02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cod[l_ac].cod02 = g_cod_t.cod02
                       NEXT FIELD cod02
                   END IF
               END IF
            END IF
 
 {#No.MOD-490398
        AFTER FIELD cod03
            IF NOT cl_null(g_cod[l_ac].cod03) THEN
              #-->check 是否存在海關商品檔
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_cod[l_ac].cod03 != g_cod_o.cod03) THEN
                  SELECT COUNT(*) INTO l_n FROM coa_file      #No.MOD-490398
                  WHERE coa03 = g_cod[l_ac].cod03
                    AND coa05 = g_coc.coc10
                   IF cl_null(l_n) THEN LET l_n =0 END IF
                   IF l_n <= 0
                   THEN CALL cl_err(g_cod[l_ac].cod03,'aco-001',0)
                        LET g_cod[l_ac].cod03 = g_cod_t.cod03
                        DISPLAY g_cod[l_ac].cod03 TO cod03
                        NEXT FIELD cod03
                   END IF
              END IF
            END IF
 }#No.MOD-490398  end
 
        BEFORE FIELD cod041
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_cod[l_ac].cod03 != g_cod_o.cod03 ) THEN
               CALL i300_cod03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  LET g_msg = g_cod[l_ac].cod03 clipped
                   CALL cl_err(g_msg,g_errno,0)
                  LET g_cod[l_ac].cod03 = g_cod_o.cod03
                  DISPLAY g_cod[l_ac].cod03 TO cod03
                  NEXT FIELD cod03
               END IF
               #-->單身的不可有相同的商品編號+版本
               SELECT COUNT(*) INTO l_n FROM cod_file
                WHERE cod01 = g_coc.coc01
                  AND cod03 = g_cod[l_ac].cod03
                  AND cod041= g_cod[l_ac].cod041
                   AND cod04 = g_coc.coc10               #No.MOD-490398
               IF l_n > 0 THEN
                  LET g_msg = g_cod[l_ac].cod03 clipped
                  CALL cl_err(g_msg,'aco-009',0)
                  LET g_cod[l_ac].cod03 = g_cod_t.cod03
                  DISPLAY g_cod[l_ac].cod03 TO cod03
                  NEXT FIELD cod03
               END IF
            END IF
            LET g_cod_o.cod03 = g_cod[l_ac].cod03
 
        AFTER FIELD cod041
            IF g_cod[l_ac].cod041 IS NULL THEN LET g_cod[l_ac].cod041=' ' END IF
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
              (g_cod[l_ac].cod03 != g_cod_o.cod03 OR
               g_cod[l_ac].cod041!= g_cod_o.cod041)) THEN
               #-->check 是否存在BOM 單頭
               SELECT COUNT(*) INTO l_n FROM com_file
                 WHERE com01=g_cod[l_ac].cod03
                   AND com02=g_cod[l_ac].cod041
                    AND com03=g_coc.coc10                  #No.MOD-490398
                   AND comacti !='N'  #010806增
               IF l_n = 0 THEN
                  LET g_msg = g_cod[l_ac].cod03 clipped
                   CALL cl_err(g_msg,'aco-180',0)           #No.MOD-490398
                  LET g_cod[l_ac].cod03 = g_cod_t.cod03
                  LET g_cod[l_ac].cod041= g_cod_t.cod041
                  DISPLAY g_cod[l_ac].cod03 TO cod03
                  DISPLAY g_cod[l_ac].cod041 TO cod041
                  NEXT FIELD cod041
               END IF
            END IF
            LET g_cod_o.cod03 = g_cod[l_ac].cod03
            LET g_cod_o.cod041= g_cod[l_ac].cod041
 
 
        AFTER FIELD cod05
           IF NOT i300_cod05_check() THEN NEXT FIELD cod05 END IF   #FUN-910088--add--
        #FUN-910088--mark--start--
        #   IF NOT cl_null(g_cod[l_ac].cod05) THEN
        #      IF g_cod[l_ac].cod05 <=0 THEN
        #         LET g_cod[l_ac].cod05 = g_cod_t.cod05
        #         DISPLAY g_cod[l_ac].cod05 TO cod05
        #         NEXT FIELD cod05
        #      END IF
        #       #No.MOD-490398
        #      LET g_cod[l_ac].cod08 = g_cod[l_ac].cod07 *
        #                              ( g_cod[l_ac].cod05 + g_cod[l_ac].cod10)
        #      DISPLAY g_cod[l_ac].cod08 TO cod08
        #       #No.MOD-490398 end
        #   END IF
        #FUN-910088--mark--end--
    
      
        AFTER FIELD cod06  #單位
            IF NOT cl_null(g_cod[l_ac].cod06) THEN
               IF g_cod_o.cod06 IS NULL OR
                 (g_cod[l_ac].cod06 != g_cod_o.cod06 ) THEN
                 CALL i300_cod06('a')
                 IF NOT cl_null(g_errno) THEN
                    LET g_cod[l_ac].cod06 = g_cod_t.cod06
                    DISPLAY g_cod[l_ac].cod06 TO cod06
                    CALL cl_err(g_cod[l_ac].cod06,g_errno,0)
                    NEXT FIELD cod06
                 END IF
               END IF
           #FUN-910088--add--start--
               LET g_cod[l_ac].cod10 = s_digqty(g_cod[l_ac].cod10,g_cod[l_ac].cod06)
               DISPLAY g_cod[l_ac].cod10 TO cod10    
               IF NOT i300_cod05_check() THEN
                  LET g_cod06_t = g_cod[l_ac].cod06
                  NEXT FIELD cod05
               END IF
               LET g_cod06_t = g_cod[l_ac].cod06
           #FUN-910088--add--end--
            END IF
 
        AFTER FIELD cod07
           IF NOT cl_null(g_cod[l_ac].cod07) THEN
              IF g_cod[l_ac].cod07 < 0 THEN
                 NEXT FIELD cod07
              END IF
           END IF
           LET g_cod[l_ac].cod08 = g_cod[l_ac].cod07 *
                                   ( g_cod[l_ac].cod05 + g_cod[l_ac].cod10)
           DISPLAY g_cod[l_ac].cod08 TO cod08
 
        AFTER FIELD cod11
            IF not cl_null(g_cod[l_ac].cod11) THEN
               IF g_cod_o.cod11 IS NULL OR
                 (g_cod[l_ac].cod11 != g_cod_o.cod11 ) THEN
                 CALL i300_cod11('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_cod[l_ac].cod11,g_errno,0)
                    NEXT FIELD cod11
                 END IF
               END IF
            END IF
 
        AFTER FIELD cod12
            IF not cl_null(g_cod[l_ac].cod12) THEN
               IF g_cod_o.cod12 IS NULL OR
                 (g_cod[l_ac].cod12 != g_cod_o.cod12 ) THEN
                 CALL i300_cod12('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_cod[l_ac].cod12,g_errno,0)
                    NEXT FIELD cod12
                 END IF
               END IF
            END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD codud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD codud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_cod[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cod[l_ac].* TO s_cod.*
              CALL g_cod.deleteElement(l_ac)    #TQC-740287 moidfy g_rec_b+1 -> l_ac
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
             INSERT INTO cod_file(cod01,cod02,cod03,cod041,cod04,    #No.MOD-490398
                                 cod05,cod06,cod07,cod08,cod09,
                                 cod091,cod10,cod101,cod102,cod103,
                                 cod104,cod105,cod106,cod11,cod12,
                                 #FUN-840202 --start--
                                 codud01,codud02,codud03,codud04,codud05,
                                 codud06,codud07,codud08,codud09,codud10,
                                 #codud11,codud12,codud13,codud14,codud15) #FUN-980002
                                 #FUN-840202 --end--
                                 codud11,codud12,codud13,codud14,codud15,  #FUN-980002
                                 codplant,codlegal) #FUN-980002
            VALUES(g_coc.coc01,g_cod[l_ac].cod02,
                    g_cod[l_ac].cod03,g_cod[l_ac].cod041,g_coc.coc10,   #No.MOD-490398
                   g_cod[l_ac].cod05,g_cod[l_ac].cod06,
                   g_cod[l_ac].cod07,g_cod[l_ac].cod08,
                   0,0,g_cod[l_ac].cod10,0,0,0,0,0,0,
                   g_cod[l_ac].cod11,g_cod[l_ac].cod12,
                   #FUN-840202 --start--
                   g_cod[l_ac].codud01,g_cod[l_ac].codud02,
                   g_cod[l_ac].codud03,g_cod[l_ac].codud04,
                   g_cod[l_ac].codud05,g_cod[l_ac].codud06,
                   g_cod[l_ac].codud07,g_cod[l_ac].codud08,
                   g_cod[l_ac].codud09,g_cod[l_ac].codud10,
                   g_cod[l_ac].codud11,g_cod[l_ac].codud12,
                   g_cod[l_ac].codud13,g_cod[l_ac].codud14,
                   #g_cod[l_ac].codud15) #FUN-840202 --end-- #FUN-980002
                   g_cod[l_ac].codud15, #FUN-840202 --end--  #FUN-980002
                   g_plant,g_legal) #FUN-980002
            IF SQLCA.sqlcode THEN
#                CALL cl_err(g_cod[l_ac].cod02,SQLCA.sqlcode,0)
                 CALL cl_err3("ins","cod_file",g_coc.coc01,g_cod[l_ac].cod02,SQLCA.sqlcode,"","",1)           #NO.TQC-660045
                # 新增至資料庫發生錯誤時, CANCEL INSERT,
                # 不需要讓舊值回復到原變數
                CANCEL INSERT
#               LET g_cod[l_ac].* = g_cod_t.*
            ELSE
                CALL i300_update()
                IF g_success='Y' THEN
                   COMMIT WORK
                   MESSAGE 'INSERT O.K'
                ELSE
                   CALL cl_rbmsg(1)
                   ROLLBACK WORK
                   MESSAGE 'INSERT FAIL'
                END IF
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cod_t.cod02 > 0 AND
               g_cod_t.cod02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                 #No.MOD-490398
                CALL i300_chk_bom()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_cod_t.cod03,g_errno,1)
                   CANCEL DELETE
                END IF
                 #No.MOD-490398   end
                DELETE FROM cod_file
                    WHERE cod01 = g_coc.coc01 AND
                          cod02 = g_cod_t.cod02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_cod_t.cod02,SQLCA.sqlcode,0)
                     CALL cl_err3("del","cod_file",g_coc.coc01,g_cod_t.cod02,SQLCA.sqlcode,"","",1)           #NO.TQC-660045
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        AFTER DELETE
          CALL i300_update()
          IF g_success='Y' THEN
             COMMIT WORK
          ELSE
             CALL cl_rbmsg(1) ROLLBACK WORK
          END IF
          LET l_n = ARR_COUNT()
          INITIALIZE g_cod[l_n+1].* TO NULL
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cod[l_ac].* = g_cod_t.*
               CLOSE i300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cod[l_ac].cod02,-263,1)
               LET g_cod[l_ac].* = g_cod_t.*
            ELSE
               UPDATE cod_file SET cod02= g_cod[l_ac].cod02,
                                   cod03= g_cod[l_ac].cod03,
                                   cod041= g_cod[l_ac].cod041,
                                   cod04= g_coc.coc10,          #No.MOD-490398
                                   cod05= g_cod[l_ac].cod05,
                                   cod06= g_cod[l_ac].cod06,
                                   cod07= g_cod[l_ac].cod07,
                                   cod08= g_cod[l_ac].cod08,
                                   cod10= g_cod[l_ac].cod10,
                                   cod11= g_cod[l_ac].cod11,
                                   cod12= g_cod[l_ac].cod12,
                                   #FUN-840202 --start--
                                   codud01 = g_cod[l_ac].codud01,
                                   codud02 = g_cod[l_ac].codud02,
                                   codud03 = g_cod[l_ac].codud03,
                                   codud04 = g_cod[l_ac].codud04,
                                   codud05 = g_cod[l_ac].codud05,
                                   codud06 = g_cod[l_ac].codud06,
                                   codud07 = g_cod[l_ac].codud07,
                                   codud08 = g_cod[l_ac].codud08,
                                   codud09 = g_cod[l_ac].codud09,
                                   codud10 = g_cod[l_ac].codud10,
                                   codud11 = g_cod[l_ac].codud11,
                                   codud12 = g_cod[l_ac].codud12,
                                   codud13 = g_cod[l_ac].codud13,
                                   codud14 = g_cod[l_ac].codud14,
                                   codud15 = g_cod[l_ac].codud15
                                   #FUN-840202 --end-- 
               WHERE cod01=g_coc.coc01 AND cod02=g_cod_t.cod02
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cod[l_ac].cod02,SQLCA.sqlcode,0)
                    CALL cl_err3("upd","cod_file",g_coc.coc01,g_cod[l_ac].cod02,SQLCA.sqlcode,"","",1)           #NO.TQC-660045
                   LET g_cod[l_ac].* = g_cod_t.*
               ELSE
                   CALL i300_update()
                   IF g_success='Y' THEN
                      COMMIT WORK
                      MESSAGE 'UPDATE O.K'
                   ELSE
                      CALL cl_rbmsg(1)
                      ROLLBACK WORK
                      MESSAGE 'UPDATE FAIL'
                   END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac    #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               # 當為修改狀態且取消輸入時, 才作回復舊值的動作
               IF p_cmd = 'u' THEN
                  LET g_cod[l_ac].* = g_cod_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cod.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
 
               CLOSE i300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            # 除了修改狀態取消時, 其餘不需要回復舊值或備份舊值
#           LET g_cod_t.* = g_cod[l_ac].*
            LET l_ac_t = l_ac    #FUN-D30034 Add
            CLOSE i300_bcl
            COMMIT WORK
 
           #CALL g_cod.deleteElement(g_rec_b+1)   #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cod02) AND l_ac > 1 THEN
                LET g_cod[l_ac].* = g_cod[l_ac-1].*
                NEXT FIELD cod02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(cod03) #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_cob"
                 LET g_qryparam.default1 = g_cod[l_ac].cod03
                 LET g_qryparam.where = " cob03 = '1' "
                 CALL cl_create_qry() RETURNING g_cod[l_ac].cod03
#                 CALL FGL_DIALOG_SETBUFFER( g_cod[l_ac].cod03 )
                 DISPLAY g_cod[l_ac].cod03  TO cod03
                 NEXT FIELD cod03
                #No.MOD-490398
               WHEN INFIELD(cod041)   #版本
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_com'
                 LET g_qryparam.arg1 = g_coc.coc10
                 LET g_qryparam.where = " com01 = '",g_cod[l_ac].cod03,"'"
                 LET g_qryparam.construct = 'N'
                 CALL cl_create_qry() RETURNING g_cod[l_ac].cod03,g_cod[l_ac].cod041
                 NEXT FIELD cod041
                  #No.MOD-490398   end
               WHEN INFIELD(cod06) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_cod[l_ac].cod06
                 CALL cl_create_qry() RETURNING g_cod[l_ac].cod06
#                 CALL FGL_DIALOG_SETBUFFER( g_cod[l_ac].cod06 )
                 DISPLAY BY NAME g_cod[l_ac].cod06
                 NEXT FIELD cod06
               WHEN INFIELD(cod11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geb"
                 LET g_qryparam.default1 =g_cod[l_ac].cod11
                 CALL cl_create_qry() RETURNING g_cod[l_ac].cod11
#                 CALL FGL_DIALOG_SETBUFFER( g_cod[l_ac].cod11 )
                 DISPLAY BY NAME g_cod[l_ac].cod11
                 NEXT FIELD cod11
               WHEN INFIELD(cod12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_cnc"
                 LET g_qryparam.default1 = g_cod[l_ac].cod12
                 CALL cl_create_qry() RETURNING g_cod[l_ac].cod12
#                 CALL FGL_DIALOG_SETBUFFER( g_cod[l_ac].cod12 )
                 DISPLAY BY NAME g_cod[l_ac].cod12
                 NEXT FIELD cod12
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
 
        #FUN-5B0043-begin
         LET g_coc.cocmodu = g_user
         LET g_coc.cocdate = g_today
         UPDATE coc_file SET cocmodu = g_coc.cocmodu,cocdate = g_coc.cocdate
          WHERE coc01 = g_coc.coc01
         DISPLAY BY NAME g_coc.cocmodu,g_coc.cocdate
        #FUN-5B0043-end
 
        CLOSE i300_bcl
        COMMIT WORK
        CALL i300_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i300_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM coe_file WHERE coe01 = g_coc.coc01  #CHI-C80041
         DELETE FROM coc_file WHERE coc01 = g_coc.coc01
         INITIALIZE g_coc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i300_cod03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_price   LIKE cof_file.cof03,
           l_unit    LIKE cob_file.cob04,
           l_cob10   LIKE cob_file.cob10,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
    SELECT cob02,cob04,cob10,cobacti
      INTO g_cod[l_ac].cob02,l_unit,l_cob10,l_cobacti
      FROM cob_file WHERE cob01 = g_cod[l_ac].cod03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET g_cod[l_ac].cob02 = ' '
                                   LET l_cobacti = NULL
                                   LET l_unit    = NULL
                                   LET l_price   = NULL
         WHEN l_cobacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' THEN
       SELECT cof03 INTO l_price FROM cof_file
        WHERE cof01 = g_cod[l_ac].cod03
          AND cof02 = g_coc.coc02
       IF SQLCA.sqlcode THEN LET l_price = 0  END IF
       LET g_cod[l_ac].cod06 = l_unit
       LET g_cod[l_ac].cod05 = s_digqty(g_cod[l_ac].cod05,g_cod[l_ac].cod06)   #FUN-910088--add--
       LET g_cod[l_ac].cod10 = s_digqty(g_cod[l_ac].cod10,g_cod[l_ac].cod06)   #FUN-910088--add--
       LET g_cod[l_ac].cod07 = l_price
       LET g_cod[l_ac].cod11 = l_cob10
       DISPLAY g_cod[l_ac].cod06 TO cod06
       DISPLAY g_cod[l_ac].cod07 TO cod07
       DISPLAY g_cod[l_ac].cod11 TO cod11
       DISPLAY g_cod[l_ac].cod05 TO cod05    #FUN-910088--add--
       DISPLAY g_cod[l_ac].cod10 TO cod10    #FUN-910088--add--
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_cod[l_ac].cob02 TO cob02
    END IF
END FUNCTION
 
FUNCTION i300_cod06(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          l_price    LIKE cod_file.cod07,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_cod[l_ac].cod06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i300_cod11(p_cmd)  #產絡地
   DEFINE l_gebacti  LIKE geb_file.gebacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gebacti INTO l_gebacti FROM geb_file
                WHERE geb01 = g_cod[l_ac].cod11
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-152'
                            LET l_gebacti = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i300_cod12(p_cmd)  #征免性質
   DEFINE l_cncacti  LIKE cnc_file.cncacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT cncacti INTO l_cncacti FROM cnc_file
                WHERE cnc01 = g_cod[l_ac].cod12
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-015'
                            LET l_cncacti = NULL
         WHEN l_cncacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i300_b_askkey()
DEFINE
    l_wc2     LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(200)
 
 
    CONSTRUCT l_wc2 ON cod02,cod03,cod041,cod05,cod10,cod06,
                       cod07,cod08,cod11,cod12
                       #No.FUN-840202 --start--
                       ,codud01,codud02,codud03,codud04,codud05
                       ,codud06,codud07,codud08,codud09,codud10
                       ,codud11,codud12,codud13,codud14,codud15
                       #No.FUN-840202 ---end---
            FROM s_cod[1].cod02,s_cod[1].cod03,s_cod[1].cod041,
                 s_cod[1].cod05,s_cod[1].cod10,s_cod[1].cod06,
                 s_cod[1].cod07,s_cod[1].cod08,
                 s_cod[1].cod11,s_cod[1].cod12
                 #No.FUN-840202 --start--
                 ,s_cod[1].codud01,s_cod[1].codud02,s_cod[1].codud03
                 ,s_cod[1].codud04,s_cod[1].codud05,s_cod[1].codud06
                 ,s_cod[1].codud07,s_cod[1].codud08,s_cod[1].codud09
                 ,s_cod[1].codud10,s_cod[1].codud11,s_cod[1].codud12
                 ,s_cod[1].codud13,s_cod[1].codud14,s_cod[1].codud15
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i300_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000   #No.FUN-680069 VARCHAR(200)
 
 
    LET g_sql =
        "SELECT cod02,cod03,cob02,cod041,cod05,cod10,cod06,cod07,cod08,",
        "       cod11,cod12, ",
        #No.FUN-840202 --start--
        "       codud01,codud02,codud03,codud04,codud05,",
        "       codud06,codud07,codud08,codud09,codud10,",
        "       codud11,codud12,codud13,codud14,codud15 ", 
        #No.FUN-840202 ---end---
        "  FROM cod_file LEFT OUTER JOIN cob_file ON cod_file.cod03 = cob_file.cob01 ",
        " WHERE cod01 ='",g_coc.coc01,"' AND ",  #單頭
        "       cod03 = cob01 "
    #No.FUN-8B0123---Begin
    #   "  ", p_wc2 CLIPPED, #單身
    #   " ORDER BY 1,2"
        IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
 
    PREPARE i300_pb FROM g_sql
    DECLARE cod_cs                       #SCROLL CURSOR
        CURSOR FOR i300_pb
    CALL g_cod.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cod_cs INTO g_cod[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_cod.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cod TO s_cod.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 進口材料資料維護
      ON ACTION mntn_imports
         LET g_action_choice="mntn_imports"
         EXIT DISPLAY
    #@ON ACTION 數量查詢
      ON ACTION query_quality
         LET g_action_choice="query_quality"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
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
 
 
FUNCTION i300_copy()
DEFINE
    l_n             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    l_newno         LIKE coc_file.coc01,
    l_newno2        LIKE coc_file.coc04,
    l_oldno         LIKE coc_file.coc01
#No.FUN-560002--begin
    DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
 
    IF s_shut(0) THEN RETURN END IF
    IF g_coc.coc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
 
     #No.MOD-490398  --begin
    LET g_before_input_done = FALSE
    CALL i300_set_entry('a')
    LET g_before_input_done = TRUE
     #No.MOD-490398  --end
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    INPUT l_newno,l_newno2 FROM coc01,coc04
 
        AFTER FIELD coc01
            IF NOT cl_null(l_newno) THEN
#No.FUN-560002--begin
#              LET g_t1=l_newno[1,3]
#              CALL s_check_no(g_sys,l_newno,"","10","coc_file","coc01","")
               CALL s_check_no("aco",l_newno,"","10","coc_file","coc01","")   #No.FUN-A40041
               RETURNING li_result,l_newno
               DISPLAY l_newno TO coc01
               IF (NOT li_result) THEN
                  NEXT FIELD coc01
               END IF
#              CALL s_auto_assign_no(g_sys,l_newno,"","10","coc_file","coc01","","","")
               CALL s_auto_assign_no("aco",l_newno,"","10","coc_file","coc01","","","")   #No.FUN-A40041
               RETURNING li_result,l_newno
               DISPLAY l_newno TO coc01
               IF (NOT li_result) THEN
                  NEXT FIELD coc01
               END IF
 
#              CALL s_acoslip(g_t1,'10',g_sys)             #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 NEXT FIELD coc01
#              END IF
#       IF l_newno[1,3] IS NOT NULL AND           #並且單號空白時,
#                 cl_null(l_newno[5,10]) THEN               #請用戶自行輸入
#          IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#             NEXT FIELD coc01
#                 END IF
#              END IF
#              IF l_newno[1,3] IS NOT NULL AND           #並且單號空白時,
#                 NOT cl_null(l_newno[5,10]) THEN	      #請用戶自行輸入
#                 IF NOT cl_chk_data_continue(l_newno[5,10]) THEN
#                    CALL cl_err('','9056',0)
#                    NEXT FIELD coc01
#                 END IF
#              END IF
#              IF g_coy.coyauno = 'Y' THEN              #自動編號
#                 CALL s_acoauno(l_newno,g_today,'10')
#                   RETURNING g_i,l_newno
#                 IF g_i THEN NEXT FIELD coc01 END IF
#                 DISPLAY l_newno TO coc01
#              END IF
#              SELECT count(*) INTO g_cnt FROM coc_file WHERE coc01 = l_newno
#              IF g_cnt > 0 THEN
#                  CALL cl_err(l_newno,-239,0)
#                  NEXT FIELD coc01
#              END IF
#No.FUN-560002--end
            END IF
        AFTER FIELD coc04
            IF NOT cl_null(l_newno2) THEN
               SELECT count(*) INTO l_n FROM coc_file
                WHERE coc04 = l_newno2
               IF l_n > 0 THEN   #單據編號重複
                  CALL cl_err(l_newno2,-239,0)
                  LET l_newno2 = ' '
                  DISPLAY l_newno2 TO coc04
                  NEXT FIELD coc04
               END IF
            END IF
       ON ACTION controlp
            CASE
               WHEN INFIELD(coc01) #單別
                    #CALL q_coy(FALSE,TRUE,l_newno,'10',g_sys)  #TQC-670008
                    CALL q_coy(FALSE,TRUE,l_newno,'10','ACO')   #TQC-670008
                         RETURNING l_newno
#                    CALL FGL_DIALOG_SETBUFFER( l_newno )
                  DISPLAY BY NAME l_newno
                  NEXT FIELD coc01
              OTHERWISE EXIT CASE
            END CASE
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_coc.coc01
        DISPLAY BY NAME g_coc.coc04
#No.FUN-560002--begin
        ROLLBACK WORK
#No.FUN-560002--end
 
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM coc_file         #單頭複製
        WHERE coc01=g_coc.coc01
        INTO TEMP y
    UPDATE y
        SET coc01=l_newno,    #新的鍵值
            coc04=l_newno2,
            cocuser=g_user,   #資料所有者
            cocgrup=g_grup,   #資料所有者所屬群
            cocmodu=NULL,     #資料更改日期
            cocdate=g_today,  #資料建立日期
            cocacti='Y'       #有效資料
    INSERT INTO coc_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM cod_file         #單身複製
        WHERE cod01=g_coc.coc01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
         CALL cl_err3("sel","cod_file",g_coc.coc01,"",SQLCA.sqlcode,"","",1)           #NO.TQC-660045
        RETURN
    END IF
    UPDATE x
        SET cod01=l_newno,
            cod09= 0,
            cod10= 0
    INSERT INTO cod_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_coc.coc01,SQLCA.sqlcode,0)
         CALL cl_err3("ins","cod_file",g_coc.coc01,"",SQLCA.sqlcode,"","",1)           #NO.TQC-660045
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_coc.coc01
     SELECT coc_file.* INTO g_coc.* FROM coc_file WHERE coc01 = l_newno
     CALL i300_u()
     CALL i300_b()
     #SELECT coc_file.* INTO g_coc.* FROM coc_file WHERE coc01 = l_oldno #FUN-C30027
     #CALL i300_show()  #FUN-C30027
END FUNCTION
 
FUNCTION i300_update()
 DEFINE l_coc09 LIKE coc_file.coc09
 
   SELECT SUM(cod08) INTO l_coc09 FROM cod_file
    WHERE cod01=g_coc.coc01
   IF cl_null(l_coc09) THEN LET l_coc09 = 0 END IF
   UPDATE coc_file SET coc09=l_coc09
    WHERE coc01=g_coc.coc01
   IF STATUS THEN
      CALL cl_err('upd coc09:',STATUS,0)
      LET g_success='N'
   END IF
   DISPLAY l_coc09 TO coc09
END FUNCTION
 
 #No.MOD-490398
FUNCTION i300_chk_bom()
    DEFINE l_con03         LIKE con_file.con03
    DEFINE l_coe03         LIKE coe_file.coe03
 
    DECLARE chk_bom_curs CURSOR FOR
       SELECT UNIQUE con03,coe03 from cod_file,con_file LEFT OUTER JOIN coe_file ON con_file.con03=coe_file.coe03 AND con_file.con08=coe_file.coe04
        WHERE cod01 = g_coc.coc01
          AND con01 = cod03  AND con013 = cod041 AND con08 = cod04
          AND cod03 = g_cod_t.cod03
          AND cod041= g_cod_t.cod041
          AND cod04 = g_coc.coc10
          AND coe_file.coe01 = g_coc.coc01
    LET g_errno = ''
    FOREACH chk_bom_curs INTO l_con03,l_coe03
       IF STATUS THEN
          CALL cl_err('chk_bom_curs',STATUS,0) LET g_errno = STATUS EXIT FOREACH
       END IF
       IF NOT cl_null(l_coe03) THEN LET g_errno = 'aco-038' EXIT FOREACH END IF
    END FOREACH
END FUNCTION
 #No.MOD-490398  END
#Patch....NO.TQC-610035 <001> #

#FUN-910088--add--start--
FUNCTION i300_cod05_check()
   IF NOT cl_null(g_cod[l_ac].cod05) AND NOT cl_null(g_cod[l_ac].cod06) THEN
      IF cl_null(g_cod06_t) OR cl_null(g_cod_t.cod05) OR g_cod06_t != g_cod[l_ac].cod06 OR g_cod_t.cod05 != g_cod[l_ac].cod05 THEN
         LET g_cod[l_ac].cod05 = s_digqty(g_cod[l_ac].cod05,g_cod[l_ac].cod06)
         DISPLAY BY NAME g_cod[l_ac].cod05
      END IF
   END IF   
   IF NOT cl_null(g_cod[l_ac].cod05) THEN
      IF g_cod[l_ac].cod05 <=0 THEN
         LET g_cod[l_ac].cod05 = g_cod_t.cod05
         DISPLAY g_cod[l_ac].cod05 TO cod05
         RETURN FALSE    
      END IF
      LET g_cod[l_ac].cod08 = g_cod[l_ac].cod07 *
                              ( g_cod[l_ac].cod05 + g_cod[l_ac].cod10)
      DISPLAY g_cod[l_ac].cod08 TO cod08
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--
