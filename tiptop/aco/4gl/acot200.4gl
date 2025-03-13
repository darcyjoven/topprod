# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot200.4gl
# Descriptions...: 模擬合同出口成品資料維護作業
# Date & Author..: 03/04/14 By Carrier
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/19 By Danny add cng12
# Modify.........: No.FUN-550100 05/05/25 By ching 特性BOM功能修改
# Modify.........: No.FUN-560002 05/06/03 By ice 單據編號修改
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# Modify.........: No.TQC-660072 06/06/15 By Dido 補充TQC-630070
# Modify.........: No.TQC-660113 06/06/26 By Rayven s_ins_cnj()抓取cob資料時，分開查找，避免多選數據
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790066 07/09/12 By judy 點擊"復制"，報單據性質不符 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/07 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910  
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ACO
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: NO.TQC-B60093 11/06/17 By Polly 延續FUN-A40041處理，調整g_sys為實際系統代號
# Modify.........: NO.FUN-BB0084 11/12/27 By lixh1 增加數量欄位小數取位
# Modify.........: NO.TQC-C20183 12/02/15 By fengrui 數量欄位小數取位處理
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/11/29 By bart 1.增加作廢功能 2.刪除單頭時，一併刪除相關table
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cng           RECORD LIKE cng_file.*,       #單頭
    g_cng_t         RECORD LIKE cng_file.*,       #單頭(舊值)
    g_cng_o         RECORD LIKE cng_file.*,       #單頭(舊值)
    g_cng01_t       LIKE cng_file.cng01,          #單頭 (舊值)
    g_cng04_t       LIKE cng_file.cng01,          #合同編號
    g_vdate         LIKE type_file.dat,           #No.FUN-680069  DATE
    g_t1            LIKE oay_file.oayslip,        #No.FUN-560002        #No.FUN-680069  VARCHAR(05)
    g_cnh           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        cnh02       LIKE cnh_file.cnh02,   #項次
        cnh03       LIKE cnh_file.cnh03,   #商品編號
        ima02       LIKE ima_file.ima02,   #
        cnh05       LIKE cnh_file.cnh05,   #
        cnh06       LIKE cnh_file.cnh06,   #
        #FUN-840202 --start---
        cnhud01     LIKE cnh_file.cnhud01,
        cnhud02     LIKE cnh_file.cnhud02,
        cnhud03     LIKE cnh_file.cnhud03,
        cnhud04     LIKE cnh_file.cnhud04,
        cnhud05     LIKE cnh_file.cnhud05,
        cnhud06     LIKE cnh_file.cnhud06,
        cnhud07     LIKE cnh_file.cnhud07,
        cnhud08     LIKE cnh_file.cnhud08,
        cnhud09     LIKE cnh_file.cnhud09,
        cnhud10     LIKE cnh_file.cnhud10,
        cnhud11     LIKE cnh_file.cnhud11,
        cnhud12     LIKE cnh_file.cnhud12,
        cnhud13     LIKE cnh_file.cnhud13,
        cnhud14     LIKE cnh_file.cnhud14,
        cnhud15     LIKE cnh_file.cnhud15
        #FUN-840202 --end--
                    END RECORD,
    g_cnh_t         RECORD                 #程式變數 (舊值)
        cnh02       LIKE cnh_file.cnh02,   #項次
        cnh03       LIKE cnh_file.cnh03,   #商品編號
        ima02       LIKE ima_file.ima02,   #
        cnh05       LIKE cnh_file.cnh05,   #
        cnh06       LIKE cnh_file.cnh06,   #
        #FUN-840202 --start---
        cnhud01     LIKE cnh_file.cnhud01,
        cnhud02     LIKE cnh_file.cnhud02,
        cnhud03     LIKE cnh_file.cnhud03,
        cnhud04     LIKE cnh_file.cnhud04,
        cnhud05     LIKE cnh_file.cnhud05,
        cnhud06     LIKE cnh_file.cnhud06,
        cnhud07     LIKE cnh_file.cnhud07,
        cnhud08     LIKE cnh_file.cnhud08,
        cnhud09     LIKE cnh_file.cnhud09,
        cnhud10     LIKE cnh_file.cnhud10,
        cnhud11     LIKE cnh_file.cnhud11,
        cnhud12     LIKE cnh_file.cnhud12,
        cnhud13     LIKE cnh_file.cnhud13,
        cnhud14     LIKE cnh_file.cnhud14,
        cnhud15     LIKE cnh_file.cnhud15
        #FUN-840202 --end--
                    END RECORD,
    g_cnh_o         RECORD                 #程式變數 (舊值)
        cnh02       LIKE cnh_file.cnh02,   #項次
        cnh03       LIKE cnh_file.cnh03,   #商品編號
        ima02       LIKE ima_file.ima02,   #
        cnh05       LIKE cnh_file.cnh05,   #
        cnh06       LIKE cnh_file.cnh06,   #
        #FUN-840202 --start---
        cnhud01     LIKE cnh_file.cnhud01,
        cnhud02     LIKE cnh_file.cnhud02,
        cnhud03     LIKE cnh_file.cnhud03,
        cnhud04     LIKE cnh_file.cnhud04,
        cnhud05     LIKE cnh_file.cnhud05,
        cnhud06     LIKE cnh_file.cnhud06,
        cnhud07     LIKE cnh_file.cnhud07,
        cnhud08     LIKE cnh_file.cnhud08,
        cnhud09     LIKE cnh_file.cnhud09,
        cnhud10     LIKE cnh_file.cnhud10,
        cnhud11     LIKE cnh_file.cnhud11,
        cnhud12     LIKE cnh_file.cnhud12,
        cnhud13     LIKE cnh_file.cnhud13,
        cnhud14     LIKE cnh_file.cnhud14,
        cnhud15     LIKE cnh_file.cnhud15
        #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE cng_file.cng01,        # 詢價單號
    g_argv2         STRING,      #No.FUN-680069             #TQC-630070      #執行功能
    g_wc,g_wc2,g_sql    STRING,                 #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,        #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
 
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069   VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10          #No.FUN-680069 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680069 INTEGER
 
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_cnh06_t       LIKE cnh_file.cnh06          #FUN-BB0084
DEFINE g_void       LIKE type_file.chr1      #CHI-C80041

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
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
 
    LET g_forupd_sql = "SELECT * FROM cng_file WHERE cng01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t200_w AT p_row,p_col
        WITH FORM "aco/42f/acot200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #start TQC-630070
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t200_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t200_a()
             END IF
          OTHERWISE          #TQC-660072
             CALL t200_q()   #TQC-660072
       END CASE
    END IF
    #end TQC-630070
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL t200_q()
    END IF
    CALL t200_menu()
    CLOSE WINDOW t200_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_cnh.clear()
 
  IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
     LET g_wc = " cng01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
     CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INITIALIZE g_cng.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          cng01,cng12,cng03,cng04,cng10,cng05,cng06,cng07, #No.MOD-490398
          cngconf,cnguser,cnggrup,cngmodu,cngdate,cngacti,
          #FUN-840202   ---start---
          cngud01,cngud02,cngud03,cngud04,cngud05,
          cngud06,cngud07,cngud08,cngud09,cngud10,
          cngud11,cngud12,cngud13,cngud14,cngud15
          #FUN-840202    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
     ON ACTION controlp
            CASE
               WHEN INFIELD(cng01) #單別
                    #CALL q_coy(FALSE,TRUE,g_cng.cng01,'00',g_sys)  #TQC-670008
                    CALL q_coy(FALSE,TRUE,g_cng.cng01,'00','ACO')   #TQC-670008
                         RETURNING g_cng.cng01
                    DISPLAY BY NAME g_cng.cng01
                    NEXT FIELD cng01
                #No.MOD-490398
               #WHEN INFIELD(cng02) #幣別
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.state ="c"
               #     LET g_qryparam.form ="q_azi"
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
               #     DISPLAY g_qryparam.multiret TO cng02
               #     NEXT FIELD cng02
               WHEN INFIELD(cng12)  #customer
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_cna"
                 LET g_qryparam.default1 = g_cng.cng12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cng12
                 NEXT FIELD cng12
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
     CONSTRUCT g_wc2 ON cnh02,cnh03,cnh05,cnh06
                        #No.FUN-840202 --start--
                        ,cnhud01,cnhud02,cnhud03,cnhud04,cnhud05
                        ,cnhud06,cnhud07,cnhud08,cnhud09,cnhud10
                        ,cnhud11,cnhud12,cnhud13,cnhud14,cnhud15
                        #No.FUN-840202 ---end---
            FROM s_cnh[1].cnh02,s_cnh[1].cnh03,s_cnh[1].cnh05,
                 s_cnh[1].cnh06
                 #No.FUN-840202 --start--
                 ,s_cnh[1].cnhud01,s_cnh[1].cnhud02,s_cnh[1].cnhud03
                 ,s_cnh[1].cnhud04,s_cnh[1].cnhud05,s_cnh[1].cnhud06
                 ,s_cnh[1].cnhud07,s_cnh[1].cnhud08,s_cnh[1].cnhud09
                 ,s_cnh[1].cnhud10,s_cnh[1].cnhud11,s_cnh[1].cnhud12
                 ,s_cnh[1].cnhud13,s_cnh[1].cnhud14,s_cnh[1].cnhud15
                 #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(cnh03) #料件編號
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.state ="c"
               #  LET g_qryparam.form ="q_ima"
               #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO cnh03
                 NEXT FIELD cnh03
               WHEN INFIELD(cnh06) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cnh06
                 NEXT FIELD cnh06
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
  #     LET g_wc = g_wc clipped," AND cnguser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND cnggrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND cnggrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnguser', 'cnggrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT cng01 FROM cng_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY cng01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cng01 ",
                   "  FROM cng_file, cnh_file ",
                   " WHERE cng01 = cnh01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY cng01"
    END IF
 
    PREPARE t200_prepare FROM g_sql
    DECLARE t200_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t200_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cng_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT cng01) FROM cng_file,cnh_file WHERE ",
                  "cnh01=cng01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t200_precount FROM g_sql
    DECLARE t200_count CURSOR FOR t200_precount
END FUNCTION
 
FUNCTION t200_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069    VARCHAR(100) 
 
 
 
   WHILE TRUE
      CALL t200_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t200_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t200_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t200_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t200_u()
            END IF
          WHEN "invalid"    #No.MOD-490398
            IF cl_chk_act_auth() THEN
               CALL t200_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t200_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN"controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnh),'','')
             END IF
         #--
 
         WHEN "mntn_imports"
            IF cl_chk_act_auth() THEN
               CALL s_ins_cnj()
               LET l_cmd="acot201 '",g_cng.cng01,"'"
               #CALL cl_cmdrun(l_cmd)      #FUN-660216 remark
               CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_z()
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cng.cng01 IS NOT NULL THEN
                 LET g_doc.column1 = "cng01"
                 LET g_doc.value1 = g_cng.cng01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t200_v()
               IF g_cng.cngconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cng.cngconf,"","","",g_void,g_cng.cngacti) 
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t200_a()
#No.FUN-560002--begin
  DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
    MESSAGE ""
    CLEAR FORM
    CALL g_cnh.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cng.* LIKE cng_file.*             #DEFAULT 設置
    LET g_cng01_t = NULL
    LET g_cng_t.* = g_cng.*
    LET g_cng_o.* = g_cng.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cng.cnguser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_cng.cnggrup=g_grup
        LET g_cng.cngdate=g_today
        LET g_cng.cngacti='Y'              #資料有效
        LET g_cng.cngconf='N'              #資料有效
        LET g_cng.cngplant = g_plant  #FUN-980002
        LET g_cng.cnglegal = g_legal  #FUN-980002
 
        #TQC-630070 --start--
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_cng.cng01 = g_argv1
        END IF
        #TQC-630070 ---end---
 
        BEGIN WORK
        CALL t200_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_cng.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cng.cng01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
#No.FUN-560002--begin
        BEGIN WORK
#       CALL s_auto_assign_no(g_sys,g_cng.cng01,g_today,"00","cng_file","cng01","","","")
        CALL s_auto_assign_no("aco",g_cng.cng01,g_today,"00","cng_file","cng01","","","")   #No.FUN-A40041
        RETURNING li_result,g_cng.cng01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_cng.cng01
#       IF cl_null(g_cng.cng01[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_cng.cng01,g_today,'00')
#            RETURNING g_i,g_cng.cng01
#          IF g_i THEN CONTINUE WHILE END IF
#          DISPLAY BY NAME g_cng.cng01
#       END IF
#No.FUN-560002--end
        LET g_cng.cngoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cng.cngorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cng_file VALUES (g_cng.*)
        LET g_t1 = g_cng.cng01[1,3]           #備份上一筆單別
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
#           CALL cl_err(g_cng.cng01,SQLCA.sqlcode,1)
            CALL cl_err3("ins","cng_file",g_cng.cng01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_cng.cng01,'I')
        SELECT cng01 INTO g_cng.cng01 FROM cng_file
            WHERE cng01 = g_cng.cng01
        LET g_cng01_t = g_cng.cng01        #保留舊值
        LET g_cng_t.* = g_cng.*
        LET g_cng_o.* = g_cng.*
         #No.MOD-490398  --begin
        CALL g_cnh.clear()
        #FOR g_cnt = 1 TO g_cnh.getLength()
        #    INITIALIZE g_cnh[g_cnt].* TO NULL
        #END FOR
         #No.MOD-490398  --end
        LET g_rec_b=0
        CALL t200_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t200_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cng.cng01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cng.* FROM cng_file WHERE cng01=g_cng.cng01
    IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'mfg1000',0)
        RETURN
    END IF
    IF g_cng.cngconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cng.cngconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'9022',0)
        RETURN
    END IF
    IF (NOT cl_null(g_cng.cng07) AND g_cng.cng07 < g_today) OR
       g_cng.cng05 < g_today THEN
       CALL cl_err(g_cng.cng01,'aco-060',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cng01_t = g_cng.cng01
    BEGIN WORK
 
    OPEN t200_cl USING g_cng.cng01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_cng.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t200_cl
        RETURN
    END IF
    CALL t200_show()
    WHILE TRUE
        LET g_cng01_t = g_cng.cng01
        LET g_cng_o.* = g_cng.*
        LET g_cng.cngmodu=g_user
        LET g_cng.cngdate=g_today
        CALL t200_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cng.*=g_cng_t.*
            CALL t200_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cng.cng01 != g_cng01_t THEN            # 更改單號
            UPDATE cnh_file SET cnh01 = g_cng.cng01
                WHERE cnh01 = g_cng01_t
            IF SQLCA.sqlcode THEN
#              CALL cl_err('cnh',SQLCA.sqlcode,0) 
               CALL cl_err3("upd","cnh_file",g_cng01_t,"",SQLCA.sqlcode,"","cnh",1)  #TQC-660045
               CONTINUE WHILE
            END IF
        END IF
        UPDATE cng_file SET cng_file.* = g_cng.*
            WHERE cng01 = g_cng01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
            CALL cl_err3("upd","cng_file",g_cng01_t,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t200_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cng.cng01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t200_i(p_cmd)
DEFINE
    l_n		LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
#No.FUN-560002--begin
    DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    INPUT BY NAME
        g_cng.cng01,g_cng.cng10,g_cng.cng12,g_cng.cng03,     #No.MOD-490398
        g_cng.cng04,g_cng.cng05,g_cng.cng06,g_cng.cng07,
        g_cng.cnguser,g_cng.cngconf,g_cng.cnggrup,g_cng.cngmodu,
        g_cng.cngdate,g_cng.cngacti,
        #FUN-840202     ---start---
        g_cng.cngud01,g_cng.cngud02,g_cng.cngud03,g_cng.cngud04,
        g_cng.cngud05,g_cng.cngud06,g_cng.cngud07,g_cng.cngud08,
        g_cng.cngud09,g_cng.cngud10,g_cng.cngud11,g_cng.cngud12,
        g_cng.cngud13,g_cng.cngud14,g_cng.cngud15 
        #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t200_set_entry(p_cmd)
            CALL t200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-560002--begin
            CALL cl_set_docno_format("cng01")
#No.FUN-560002--end
 
        AFTER FIELD cng01
            IF NOT cl_null(g_cng.cng01) THEN
#              CALL s_check_no(g_sys,g_cng.cng01,g_cng_t.cng01,"00","cng_file","cng01","")
               CALL s_check_no("aco",g_cng.cng01,g_cng_t.cng01,"00","cng_file","cng01","")   #No.FUN-A40041
               RETURNING li_result,g_cng.cng01
               IF (NOT li_result) THEN
                   LET g_cng.cng01 = g_cng_o.cng01
                   NEXT FIELD cng01
               END IF
#              LET g_t1=g_cng.cng01[1,3]
#              CALL s_acoslip(g_t1,'00',g_sys)           #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cng.cng01=g_cng_o.cng01
#                 NEXT FIELD cng01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cng.cng01[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_cng.cng01[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD cng01
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD NEXT 			 #輸入
# 	             END IF
#           END IF
#           IF g_cng.cng01[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_cng.cng01[5,10]) THEN	 #請用戶自行輸入
          IF g_cng.cng01[1,g_doc_len] IS NOT NULL AND       #並且單號空白時,
          	  cl_null(g_cng.cng01[g_no_sp,g_no_ep]) THEN           #請用戶自行輸入
             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
                NEXT FIELD cng01
             ELSE					 #要不, 則單號不用
                NEXT FIELD cng02			 #輸入
             END IF
           END IF
 
#                     IF NOT cl_chk_data_continue(g_cng.cng01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD cng01
#                     END IF
#                  END IF
#              END IF
#              IF g_cng.cng01 != g_cng01_t OR g_cng01_t IS NULL THEN
#                  SELECT count(*) INTO l_n FROM cng_file
#                      WHERE cng01 = g_cng.cng01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_cng.cng01,-239,0)
#                      LET g_cng.cng01 = g_cng01_t
#                      DISPLAY BY NAME g_cng.cng01
#                      NEXT FIELD cng01
#                  END IF
#              END IF
#No.FUN-560002--end
            END IF
 
        #FUN-840202     ---start---
        AFTER FIELD cngud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud15
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
               WHEN INFIELD(cng01) #單別
                    #CALL q_coy( FALSE, TRUE, g_cng.cng01,'00',g_sys) #TQC-670008
                    CALL q_coy( FALSE, TRUE, g_cng.cng01,'00','ACO')  #TQC-670008
                         RETURNING g_cng.cng01
#                    CALL FGL_DIALOG_SETBUFFER( g_cng.cng01 )
                    DISPLAY BY NAME g_cng.cng01
                    NEXT FIELD cng01
               WHEN INFIELD(cng02) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azi"
                    LET g_qryparam.default1 = g_cng.cng02
                    CALL cl_create_qry() RETURNING g_cng.cng02
#                    CALL FGL_DIALOG_SETBUFFER( g_cng.cng02 )
                    DISPLAY BY NAME g_cng.cng02
                    NEXT FIELD cng02
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
 
FUNCTION t200_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("cng01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cng01",FALSE)
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cng.* TO NULL             #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cnh.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t200_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cng.* TO NULL
        RETURN
    END IF
    OPEN t200_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cng.* TO NULL
    ELSE
        OPEN t200_count
        FETCH t200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t200_cs INTO g_cng.cng01
        WHEN 'P' FETCH PREVIOUS t200_cs INTO g_cng.cng01
        WHEN 'F' FETCH FIRST    t200_cs INTO g_cng.cng01
        WHEN 'L' FETCH LAST     t200_cs INTO g_cng.cng01
        WHEN '/'
 
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
         FETCH ABSOLUTE g_jump t200_cs INTO g_cng.cng01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
        INITIALIZE g_cng.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_cng.* FROM cng_file WHERE cng01 = g_cng.cng01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
        CALL cl_err3("sel","cng_file",g_cng.cng01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
        INITIALIZE g_cng.* TO NULL
        RETURN
    END IF
    CALL t200_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t200_show()
    LET g_cng_t.* = g_cng.*                #保存單頭舊值
    LET g_cng_o.* = g_cng.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
 
        g_cng.cng01,g_cng.cng03,g_cng.cng04,g_cng.cng05,
        g_cng.cng06,g_cng.cng07,g_cng.cng10,g_cng.cng12,       #No.MOD-490398
        g_cng.cnguser,g_cng.cngconf,g_cng.cnggrup,g_cng.cngmodu,
        g_cng.cngdate,g_cng.cngacti,
        #FUN-840202     ---start---
        g_cng.cngud01,g_cng.cngud02,g_cng.cngud03,g_cng.cngud04,
        g_cng.cngud05,g_cng.cngud06,g_cng.cngud07,g_cng.cngud08,
        g_cng.cngud09,g_cng.cngud10,g_cng.cngud11,g_cng.cngud12,
        g_cng.cngud13,g_cng.cngud14,g_cng.cngud15 
        #FUN-840202     ----end----
    #CKP
    #CALL cl_set_field_pic(g_cng.cngconf,"","","","",g_cng.cngacti)  #CHI-C80041
    IF g_cng.cngconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cng.cngconf,"","","",g_void,g_cng.cngacti)   #CHI-C80041
    CALL t200_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t200_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cng.cng01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_cng.cngconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'9021',0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t200_cl USING g_cng.cng01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_cng.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t200_show()
    IF cl_exp(0,0,g_cng.cngacti) THEN                   #審核一下
        LET g_chr=g_cng.cngacti
        IF g_cng.cngacti='Y' THEN
            LET g_cng.cngacti='N'
        ELSE
            LET g_cng.cngacti='Y'
        END IF
        UPDATE cng_file                    #更改有效碼
            SET cngacti=g_cng.cngacti
            WHERE cng01=g_cng.cng01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
            CALL cl_err3("upd","cng_file",g_cng.cng01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            LET g_cng.cngacti=g_chr
        END IF
        DISPLAY BY NAME g_cng.cngacti
    END IF
    CLOSE t200_cl
    COMMIT WORK
 
    #CKP
    #CALL cl_set_field_pic(g_cng.cngconf,"","","","",g_cng.cngacti)   #CHI-C80041
    IF g_cng.cngconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cng.cngconf,"","","",g_void,g_cng.cngacti)   #CHI-C80041
    CALL cl_flow_notify(g_cng.cng01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t200_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cng.cng01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'mfg1000',0) RETURN
    END IF
    IF g_cng.cngconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cng.cngconf ='Y' THEN    #檢查資料是否已審核
        CALL cl_err(g_cng.cng01,'9021',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN t200_cl USING g_cng.cng01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_cng.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t200_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cng01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cng.cng01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM cng_file WHERE cng01 = g_cng.cng01
            DELETE FROM cnh_file WHERE cnh01 = g_cng.cng01
            DELETE FROM cnj_file WHERE cnj01 = g_cng.cng01
            CLEAR FORM
            CALL g_cnh.clear()
 
         OPEN t200_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t200_cs
            CLOSE t200_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t200_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t200_cs
            CLOSE t200_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t200_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t200_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t200_fetch('/')
         END IF
    END IF
    CLOSE t200_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cng.cng01,'D')
END FUNCTION
 
#單身
FUNCTION t200_b()
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
    IF g_cng.cng01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cng.* FROM cng_file WHERE cng01=g_cng.cng01
    IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cng.cng01,'mfg1000',0) RETURN
    END IF
    IF g_cng.cngconf ='X' THEN    #CHI-C80041
       CALL cl_err(g_cng.cng01,'art-102',0) RETURN  #CHI-C80041
    END IF  #CHI-C80041
    IF g_cng.cngconf ='Y' THEN    #檢查資料是否已審核
       CALL cl_err(g_cng.cng01,'9022',0) RETURN
    END IF
    IF (NOT cl_null(g_cng.cng07) AND g_cng.cng07 < g_today) OR
       g_cng.cng05 < g_today THEN
       CALL cl_err(g_cng.cng01,'aco-060',0)
       RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT cnh02,cnh03,'',cnh05,cnh06, ",
                       #No.FUN-840202 --start--
                       "        cnhud01,cnhud02,cnhud03,cnhud04,cnhud05,",
                       "        cnhud06,cnhud07,cnhud08,cnhud09,cnhud10,",
                       "        cnhud11,cnhud12,cnhud13,cnhud14,cnhud15 ", 
                       #No.FUN-840202 ---end---
                       "   FROM cnh_file ",
                       "  WHERE cnh01=? ",
                       "    AND cnh02=? ",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_cnh.clear() END IF
 
        INPUT ARRAY g_cnh WITHOUT DEFAULTS FROM s_cnh.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success='Y'
            BEGIN WORK
 
            OPEN t200_cl USING g_cng.cng01
            IF STATUS THEN
               CALL cl_err("OPEN t200_cl:", STATUS, 1)
               CLOSE t200_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t200_cl INTO g_cng.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t200_cl
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cnh_t.* = g_cnh[l_ac].*  #BACKUP
                LET g_cnh_o.* = g_cnh[l_ac].*  #BACKUP
                LET g_cnh06_t = g_cnh[l_ac].cnh06     #FUN-BB0084 
                OPEN t200_bcl USING g_cng.cng01,g_cnh_t.cnh02
                IF STATUS THEN
                   CALL cl_err("OPEN t200_bcl:", STATUS, 1)
                   CLOSE t200_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t200_bcl INTO g_cnh[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cnh_t.cnh02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL t200_cnh03('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD cnh02
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
 
              INITIALIZE g_cnh[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cnh[l_ac].* TO s_cnh.*
              CALL g_cnh.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO cnh_file(cnh01,cnh02,cnh03,cnh05,cnh06,
                                 #FUN-840202 --start--
                                 cnhud01,cnhud02,cnhud03,cnhud04,cnhud05,
                                 cnhud06,cnhud07,cnhud08,cnhud09,cnhud10,
                                 #cnhud11,cnhud12,cnhud13,cnhud14,cnhud15) #FUN-980002
                                 #FUN-840202 --end--
                                 cnhud11,cnhud12,cnhud13,cnhud14,cnhud15,  #FUN-980002
                                 cnhplant,cnhlegal) #FUN-980002
            VALUES(g_cng.cng01,g_cnh[l_ac].cnh02,g_cnh[l_ac].cnh03,
                   g_cnh[l_ac].cnh05,g_cnh[l_ac].cnh06,
                   #FUN-840202 --start--
                   g_cnh[l_ac].cnhud01,g_cnh[l_ac].cnhud02,
                   g_cnh[l_ac].cnhud03,g_cnh[l_ac].cnhud04,
                   g_cnh[l_ac].cnhud05,g_cnh[l_ac].cnhud06,
                   g_cnh[l_ac].cnhud07,g_cnh[l_ac].cnhud08,
                   g_cnh[l_ac].cnhud09,g_cnh[l_ac].cnhud10,
                   g_cnh[l_ac].cnhud11,g_cnh[l_ac].cnhud12,
                   g_cnh[l_ac].cnhud13,g_cnh[l_ac].cnhud14,
                   g_cnh[l_ac].cnhud15,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
                   #FUN-840202 --end--
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cnh[l_ac].cnh02,SQLCA.sqlcode,0)
               CALL cl_err3("ins","cnh_file",g_cng.cng01,g_cnh[l_ac].cnh02,SQLCA.sqlcode,"","",1)  #TQC-660045
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_cnh[l_ac].* TO NULL
            LET g_cnh[l_ac].cnh05 = 0              #Body default
            LET g_cnh_t.* = g_cnh[l_ac].*          #新輸入資料
            LET g_cnh_o.* = g_cnh[l_ac].*          #新輸入資料
            LET g_cnh06_t = NULL                   #FUN-BB0084   
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnh02
 
        BEFORE FIELD cnh02                        #default 序號
            IF g_cnh[l_ac].cnh02 IS NULL OR g_cnh[l_ac].cnh02 = 0 THEN
                SELECT max(cnh02)+1
                   INTO g_cnh[l_ac].cnh02
                   FROM cnh_file
                   WHERE cnh01 = g_cng.cng01
                IF g_cnh[l_ac].cnh02 IS NULL THEN
                    LET g_cnh[l_ac].cnh02 = 1
                END IF
#               DISPLAY g_cnh[l_ac].cnh02 TO cnh02   #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD cnh02                        #check 序號是否重複
            IF NOT cl_null(g_cnh[l_ac].cnh02) THEN
               IF g_cnh[l_ac].cnh02 != g_cnh_t.cnh02 OR
                  g_cnh_t.cnh02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM cnh_file
                       WHERE cnh01 = g_cng.cng01 AND
                             cnh02 = g_cnh[l_ac].cnh02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cnh[l_ac].cnh02 = g_cnh_t.cnh02
                       NEXT FIELD cnh02
                   END IF
               END IF
            END IF
 
        AFTER FIELD cnh03
            LET l_n = 0
            IF NOT cl_null(g_cnh[l_ac].cnh03) THEN
               #FUN-AA0059 ---------------------------add sart----------------------
               IF NOT s_chk_item_no(g_cnh[l_ac].cnh03,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD cnh03
               END IF 
               #FUN-AA0059 --------------------------add end------------------------    
               IF g_cnh_t.cnh03 IS NULL OR g_cnh_t.cnh03 <> g_cnh[l_ac].cnh03
               THEN
                  SELECT COUNT(*) INTO l_n FROM cnh_file #不能重復
                   WHERE cnh01 = g_cng.cng01
                     AND cnh03 = g_cnh[l_ac].cnh03
                  IF l_n > 0 THEN
                     CALL cl_err(g_cnh[l_ac].cnh03,-239,0)
                     NEXT FIELD cnh03
                  END IF
               END IF
            END IF
            IF not cl_null(g_cnh[l_ac].cnh03) THEN
              #-->check 是否存在海關商品檔
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_cnh[l_ac].cnh03 != g_cnh_o.cnh03) THEN
                    #No.MOD-490398
                   SELECT COUNT(*) INTO l_n FROM coa_file
                     WHERE coa01 = g_cnh[l_ac].cnh03          #No.MOD-490398 END
                   IF cl_null(l_n) THEN LET l_n =0 END IF
                   IF l_n <= 0 THEN
                        CALL cl_err(g_cnh[l_ac].cnh03,'aco-078',0)
                        LET g_cnh[l_ac].cnh03 = g_cnh_t.cnh03
                        DISPLAY g_cnh[l_ac].cnh03 TO cnh03
                        NEXT FIELD cnh03
                   ELSE
                      LET l_n = 0
                      SELECT COUNT(*) INTO l_n FROM bma_file  #成品
                       WHERE bma01 = g_cnh[l_ac].cnh03
                      IF l_n = 0 THEN
                         CALL cl_err(g_cnh[l_ac].cnh03,'mfg2602',2)
                         LET g_cnh[l_ac].cnh03 = g_cnh_t.cnh03
                         DISPLAY g_cnh[l_ac].cnh03 TO cnh03
                         NEXT FIELD cnh03
                      END IF
                   END IF
                    CALL t200_cnh03('a')  #No.MOD-390398
              END IF
            END IF
            LET g_cnh_o.cnh03 = g_cnh[l_ac].cnh03
             #CALL t200_cnh03('a')  #No.MOD-390398
 
        AFTER FIELD cnh05
        #FUN-BB0084 ------Begin---------
            IF NOT t200_cnh05_chk() THEN
               NEXT FIELD cnh05
            END IF  
        #FUN-BB0084 ------End-----------
#FUN-BB0084 ----------------Begin-----------------
#           IF NOT cl_null(g_cnh[l_ac].cnh05) THEN
#              IF g_cnh[l_ac].cnh05 <=0 THEN
#                 LET g_cnh[l_ac].cnh05 = g_cnh_t.cnh05
#                 DISPLAY g_cnh[l_ac].cnh05 TO cnh05
#                 NEXT FIELD cnh05
#              END IF
#           END IF
#FUN-BB0084 ----------------End-------------------
 
        AFTER FIELD cnh06  #單位
            IF NOT cl_null(g_cnh[l_ac].cnh06) THEN
               IF g_cnh_o.cnh06 IS NULL OR
                 (g_cnh[l_ac].cnh06 != g_cnh_o.cnh06 ) THEN
                 CALL t200_cnh06('a')
                 IF NOT cl_null(g_errno) THEN
                    LET g_cnh[l_ac].cnh06 = g_cnh_t.cnh06
                    DISPLAY g_cnh[l_ac].cnh06 TO cnh06
                    CALL cl_err(g_cnh[l_ac].cnh06,g_errno,0)
                    NEXT FIELD cnh06
                 END IF
               END IF
           #FUN-BB0084 -------------Begin--------------
               IF NOT cl_null(g_cnh[l_ac].cnh05) AND g_cnh[l_ac].cnh05<>0 THEN #TQC-C20183 add
                  IF NOT t200_cnh05_chk() THEN
                     LET g_cnh06_t = g_cnh[l_ac].cnh06
                     NEXT FIELD cnh05
                  END IF  
               END IF                                                          #TQC-C20183 add
               LET g_cnh06_t = g_cnh[l_ac].cnh06 
           #FUN-BB0084 -------------End----------------
           END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD cnhud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnhud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cnh_t.cnh02 > 0 AND
               g_cnh_t.cnh02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cnh_file
                    WHERE cnh01 = g_cng.cng01 AND
                          cnh02 = g_cnh_t.cnh02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cnh_t.cnh02,SQLCA.sqlcode,0)
                    CALL cl_err3("del","cnh_file",g_cng.cng01,g_cnh_t.cnh02,SQLCA.sqlcode,"","",1)  #TQC-660045
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cnh[l_ac].* = g_cnh_t.*
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cnh[l_ac].cnh02,-263,1)
               LET g_cnh[l_ac].* = g_cnh_t.*
            ELSE
               UPDATE cnh_file SET cnh02= g_cnh[l_ac].cnh02,
                                   cnh03= g_cnh[l_ac].cnh03,
                                   cnh05= g_cnh[l_ac].cnh05,
                                   cnh06= g_cnh[l_ac].cnh06,
                                   #FUN-840202 --start--
                                   cnhud01 = g_cnh[l_ac].cnhud01,
                                   cnhud02 = g_cnh[l_ac].cnhud02,
                                   cnhud03 = g_cnh[l_ac].cnhud03,
                                   cnhud04 = g_cnh[l_ac].cnhud04,
                                   cnhud05 = g_cnh[l_ac].cnhud05,
                                   cnhud06 = g_cnh[l_ac].cnhud06,
                                   cnhud07 = g_cnh[l_ac].cnhud07,
                                   cnhud08 = g_cnh[l_ac].cnhud08,
                                   cnhud09 = g_cnh[l_ac].cnhud09,
                                   cnhud10 = g_cnh[l_ac].cnhud10,
                                   cnhud11 = g_cnh[l_ac].cnhud11,
                                   cnhud12 = g_cnh[l_ac].cnhud12,
                                   cnhud13 = g_cnh[l_ac].cnhud13,
                                   cnhud14 = g_cnh[l_ac].cnhud14,
                                   cnhud15 = g_cnh[l_ac].cnhud15
                                   #FUN-840202 --end-- 
                WHERE cnh01=g_cng.cng01 AND cnh02=g_cnh_t.cnh02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cnh[l_ac].cnh02,SQLCA.sqlcode,0)
                   CALL cl_err3("upd","cnh_file",g_cng.cng01,g_cnh[l_ac].cnh02,SQLCA.sqlcode,"","",1)  #TQC-660045
                   LET g_cnh[l_ac].* = g_cnh_t.*
               ELSE
                   IF g_success='Y' THEN
                      COMMIT WORK
                   ELSE
                      CALL cl_rbmsg(1) ROLLBACK WORK
                   END IF
                   MESSAGE 'UPDATE O.K'
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_cnh[l_ac].* = g_cnh_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cnh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--       
               END IF
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_cnh_t.* = g_cnh[l_ac].*          # 900423
            LET l_ac_t = l_ac      #FUN-D30034 Add
            CLOSE t200_bcl
            COMMIT WORK
           #CALL g_cnh.deleteElement(g_rec_b+1)   #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cnh02) AND l_ac > 1 THEN
                LET g_cnh[l_ac].* = g_cnh[l_ac-1].*
                NEXT FIELD cnh02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON ACTION controlp
           CASE
              WHEN INFIELD(cnh03) #料件編號
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form ="q_ima"
                #   LET g_qryparam.default1 = g_cnh[l_ac].cnh03
                #    LET g_qryparam.where = " ima08 IN ('M','U','S')"   #No.MOD-490398
                #   CALL cl_create_qry() RETURNING g_cnh[l_ac].cnh03
                    CALL q_sel_ima(FALSE, "q_ima", "ima08 IN ('M','U','S')", g_cnh[l_ac].cnh03, "", "", "", "" ,"",'' )  RETURNING g_cnh[l_ac].cnh03 
#FUN-AA0059 --End--
#                   CALL FGL_DIALOG_SETBUFFER( g_cnh[l_ac].cnh03 )
                   DISPLAY g_cnh[l_ac].cnh03  TO cnh03
                   NEXT FIELD cnh03
              WHEN INFIELD(cnh06) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_cnh[l_ac].cnh06
                   CALL cl_create_qry() RETURNING g_cnh[l_ac].cnh06
#                   CALL FGL_DIALOG_SETBUFFER( g_cnh[l_ac].cnh06 )
                   DISPLAY g_cnh[l_ac].cnh06 TO cnh06
                   NEXT FIELD cnh06
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
    LET g_cng.cngmodu = g_user
    LET g_cng.cngdate = g_today
    UPDATE cng_file SET cngmodu = g_cng.cngmodu,cngdate = g_cng.cngdate
     WHERE cng01 = g_cng.cng01
    DISPLAY BY NAME g_cng.cngmodu,g_cng.cngdate
    #FUN-5B0043-end
 
    CLOSE t200_bcl
    COMMIT WORK
    #NO:8575
#   CALL t200_delall()  #CHI-C30002 mark
    CALL t200_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t200_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_cng.cng01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM cng_file ",
                  "  WHERE cng01 LIKE '",l_slip,"%' ",
                  "    AND cng01 > '",g_cng.cng01,"'"
      PREPARE t200_pb1 FROM l_sql 
      EXECUTE t200_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t200_v()
         IF g_cng.cngconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_cng.cngconf,"","","",g_void,g_cng.cngacti)
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM cnj_file WHERE cnj01 = g_cng.cng01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM cng_file WHERE cng01 = g_cng.cng01
         INITIALIZE g_cng.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#FUN-BB0084 -----------------Begin----------------------
FUNCTION t200_cnh05_chk()
   IF NOT cl_null(g_cnh[l_ac].cnh05) THEN
      IF g_cnh[l_ac].cnh05 <=0 THEN
         LET g_cnh[l_ac].cnh05 = g_cnh_t.cnh05
         DISPLAY g_cnh[l_ac].cnh05 TO cnh05
         RETURN FALSE
      END IF
      IF NOT cl_null(g_cnh[l_ac].cnh06) THEN
         IF cl_null(g_cnh06_t) OR cl_null(g_cnh_t.cnh05) OR g_cnh06_t ! = g_cnh[l_ac].cnh06
            OR g_cnh_t.cnh05 ! = g_cnh[l_ac].cnh05 THEN
            LET g_cnh[l_ac].cnh05 = s_digqty(g_cnh[l_ac].cnh05,g_cnh[l_ac].cnh06)
            DISPLAY g_cnh[l_ac].cnh05 TO cnh05
         END IF
      END IF    
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BB0084 -----------------End-----------------------

#CHI-C30002 -------- mark -------- begin
#FUNCTION t200_delall()
#   SELECT COUNT(*) INTO g_cnt FROM cnh_file
#       WHERE cnh01 = g_cng.cng01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM cng_file WHERE cng01 = g_cng.cng01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end 

FUNCTION t200_cnh03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_cnh06   LIKE cnh_file.cnh06,          #No.MOD-490398
           l_ima25   LIKE ima_file.ima25,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
     #No.MOD-490398  --begin
    SELECT ima02,ima25,imaacti
      INTO g_cnh[l_ac].ima02,l_cnh06,l_imaacti
      FROM ima_file WHERE ima01 = g_cnh[l_ac].cnh03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET g_cnh[l_ac].ima02 = ' '
                                   LET l_cnh06 = ' '
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
  #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_cnh[l_ac].cnh06) THEN LET g_cnh[l_ac].cnh06=l_cnh06 END IF
    #IF cl_null(g_errno) OR p_cmd = 'd' THEN
    #   DISPLAY g_cnh[l_ac].ima02 TO ima02
    #   DISPLAY g_cnh[l_ac].cnh06 TO cnh06
    #END IF
    #------MOD-5A0095 START----------
    DISPLAY BY NAME g_cnh[l_ac].ima02
    DISPLAY BY NAME g_cnh[l_ac].cnh06
    #------MOD-5A0095 END------------
     #No.MOD-490398  --end
#FUN-BB0084 --------------Begin-------------
    IF NOT cl_null(g_cnh[l_ac].cnh05) THEN
       LET g_cnh[l_ac].cnh05 = s_digqty(g_cnh[l_ac].cnh05,g_cnh[l_ac].cnh06)
       DISPLAY BY NAME g_cnh[l_ac].cnh05
    END IF
#FUN-BB0084 --------------End---------------
END FUNCTION
 
FUNCTION t200_cnh06(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_cnh[l_ac].cnh06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t200_b_askkey()
DEFINE l_wc2           STRING        #No.FUN-680069
 
    CONSTRUCT l_wc2 ON cnh02,cnh03,cnh05,cnh06
                       #No.FUN-840202 --start--
                       ,cnhud01,cnhud02,cnhud03,cnhud04,cnhud05
                       ,cnhud06,cnhud07,cnhud08,cnhud09,cnhud10
                       ,cnhud11,cnhud12,cnhud13,cnhud14,cnhud15
                       #No.FUN-840202 ---end---
            FROM s_cnh[1].cnh02,s_cnh[1].cnh03,s_cnh[1].cnh05,s_cnh[1].cnh06
                 #No.FUN-840202 --start--
                 ,s_cnh[1].cnhud01,s_cnh[1].cnhud02,s_cnh[1].cnhud03
                 ,s_cnh[1].cnhud04,s_cnh[1].cnhud05,s_cnh[1].cnhud06
                 ,s_cnh[1].cnhud07,s_cnh[1].cnhud08,s_cnh[1].cnhud09
                 ,s_cnh[1].cnhud10,s_cnh[1].cnhud11,s_cnh[1].cnhud12
                 ,s_cnh[1].cnhud13,s_cnh[1].cnhud14,s_cnh[1].cnhud15
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
    CALL t200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING        #No.FUN-680069
 
    LET g_sql =
        "SELECT cnh02,cnh03,ima02,cnh05,cnh06, ",
        #No.FUN-840202 --start--
        "       cnhud01,cnhud02,cnhud03,cnhud04,cnhud05,",
        "       cnhud06,cnhud07,cnhud08,cnhud09,cnhud10,",
        "       cnhud11,cnhud12,cnhud13,cnhud14,cnhud15 ", 
        #No.FUN-840202 ---end---
        "  FROM cnh_file LEFT OUTER JOIN ima_file ON cnh_file.cnh03 = ima_file.ima01",
        " WHERE cnh01 ='",g_cng.cng01,"'  "  #單頭
    #No.FUN-8B0123---begin
    #   "  AND ", p_wc2 CLIPPED, #單身
    #   " ORDER BY 1,2"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t200_pb FROM g_sql
    DECLARE cnh_cs                       #SCROLL CURSOR
        CURSOR FOR t200_pb
    CALL g_cnh.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cnh_cs INTO g_cnh[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #CKP
    CALL g_cnh.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnh TO s_cnh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
       ON ACTION invalid               #No.MOD-490398
          LET g_action_choice="invalid"   #No.MOD-490398
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
         #CKP
         #CALL cl_set_field_pic(g_cng.cngconf,"","","","",g_cng.cngacti)  #CHI-C80041
         IF g_cng.cngconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_cng.cngconf,"","","",g_void,g_cng.cngacti)   #CHI-C80041
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
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
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
 
FUNCTION t200_copy()
DEFINE
    l_n             LIKE type_file.num5,            #No.FUN-680069 SMALLINT
    l_newno         LIKE cng_file.cng01,
    l_oldno         LIKE cng_file.cng01
#No.FUN-560002--begin
    DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cng.cng01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL t200_set_entry('a')
    LET g_before_input_done = TRUE
 
   #DISPLAY "" AT 1,1
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    INPUT l_newno FROM cng01
 
        AFTER FIELD cng01
            IF NOT cl_null(l_newno) THEN
#No.FUN-560002--begin
             # CALL s_check_no(g_sys,l_newno,"","10","cng_file","cng01","")  #TQC-790066
             # CALL s_check_no(g_sys,l_newno,"","00","cng_file","cng01","")  #TQC-790066 #TQC-B60093 mark
               CALL s_check_no("aco",l_newno,"","00","cng_file","cng01","")  #TQC-B60093 add
               RETURNING li_result,l_newno
               DISPLAY l_newno TO cng01
               IF (NOT li_result) THEN
                  NEXT FIELD cng01
               END IF
               CALL s_auto_assign_no(g_sys,l_newno,"","00","cng_file","cng01","","","")
               RETURNING li_result,l_newno
               DISPLAY l_newno TO cng01
               IF (NOT li_result) THEN
                  NEXT FIELD cng01
               END IF
 
#              LET g_t1=l_newno[1,3]
#              CALL s_acoslip(g_t1,'00',g_sys)             #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 NEXT FIELD cng01
#              END IF
#       IF l_newno[1,3] IS NOT NULL AND           #並且單號空白時,
#                 cl_null(l_newno[5,10]) THEN     #請用戶自行輸入
#          IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#             NEXT FIELD cng01
#                 END IF
#              END IF
#              IF l_newno[1,3] IS NOT NULL AND                #並且單號空白時,
#                 NOT cl_null(l_newno[5,10]) THEN	      #請用戶自行輸入
#                 IF NOT cl_chk_data_continue(l_newno[5,10]) THEN
#                    CALL cl_err('','9056',0)
#                    NEXT FIELD cng01
#                 END IF
#              END IF
#              IF g_coy.coyauno = 'Y' THEN              #自動編號
#                 BEGIN WORK
#                 CALL s_acoauno(l_newno,g_today,'00')
#                   RETURNING g_i,l_newno
#                 IF g_i THEN NEXT FIELD cng01 END IF
#                 DISPLAY l_newno TO cng01
#              END IF
#              SELECT count(*) INTO g_cnt FROM cng_file WHERE cng01 = l_newno
#              IF g_cnt > 0 THEN
#                  CALL cl_err(l_newno,-239,0)
#                  NEXT FIELD cng01
#              END IF
#No.FUN-560002--end
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cng01) #單別
                    #CALL q_coy( FALSE, TRUE,l_newno,'00',g_sys) #TQC-670008
                    CALL q_coy( FALSE, TRUE,l_newno,'00','ACO')  #TQC-670008
                         RETURNING l_newno
#                    CALL FGL_DIALOG_SETBUFFER( l_newno )
                    DISPLAY BY NAME l_newno
                    NEXT FIELD cng01
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
        DISPLAY BY NAME g_cng.cng01
#No.FUN-560002--begin
        ROLLBACK WORK
#No.FUN-560002--end
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM cng_file         #單頭複製
        WHERE cng01=g_cng.cng01
        INTO TEMP y
     #No.MOD-490398  --begin
    UPDATE y
        SET cng01=l_newno,    #新的鍵值
            cng02=NULL,
            cng03=NULL,
            cng04=NULL,
            cng05=NULL,
            cng06=NULL,
            cng07=NULL,
            cng08=0,
            cng09=0,
            cng10=NULL,
            cng12=NULL,
            cngconf='N',
            cnguser=g_user,   #資料所有者
            cnggrup=g_grup,   #資料所有者所屬群
            cngmodu=NULL,     #資料更改日期
            cngdate=g_today,  #資料建立日期
            cngacti='Y'       #有效資料
     #No.MOD-490398  --end
    INSERT INTO cng_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM cnh_file         #單身複製
        WHERE cnh01=g_cng.cng01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
        CALL cl_err3("sel","cnh_file",g_cng.cng01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
        ROLLBACK WORK
        RETURN
    END IF
    UPDATE x
        SET cnh01=l_newno
    INSERT INTO cnh_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
        CALL cl_err3("ins","cnh_file",g_cng.cng01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_cng.cng01
     SELECT cng_file.* INTO g_cng.* FROM cng_file WHERE cng01 = l_newno
     CALL t200_u()
     CALL t200_b()
     #SELECT cng_file.* INTO g_cng.* FROM cng_file WHERE cng01 = l_oldno  #FUN-C30027
     #CALL t200_show()  #FUN-C30027
END FUNCTION
 
FUNCTION t200_y() #審核
    IF g_cng.cng01 IS NULL THEN RETURN END IF
      #CHI-C30107 ------- add ------- begin
    IF g_cng.cngconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cng.cngconf='Y' THEN RETURN END IF
    IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'mfg1000',0)
        RETURN
    END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107
    #CHI-C30107 ------- add ------- end
    SELECT * INTO g_cng.* FROM cng_file WHERE cng01=g_cng.cng01
    IF g_cng.cngconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cng.cngconf='Y' THEN RETURN END IF
    IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'mfg1000',0)
        RETURN
    END IF
   #no.7377
   SELECT COUNT(*) INTO g_cnt FROM cnh_file
    WHERE cnh01 = g_cng.cng01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #no.7377(end)
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
 
    LET g_success='Y'
    BEGIN WORK
 
        OPEN t200_cl USING g_cng.cng01
        IF STATUS THEN
           CALL cl_err("OPEN t200_cl:", STATUS, 1)
           CLOSE t200_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t200_cl INTO g_cng.*  # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
            CLOSE t200_cl
            ROLLBACK WORK
            RETURN
        END IF
 
    UPDATE cng_file SET cngconf='Y'
        WHERE cng01 = g_cng.cng01
    IF STATUS THEN
#       CALL cl_err('upd cngconf',STATUS,0)
        CALL cl_err3("upd","cng_file",g_cng.cng01,"",STATUS,"","upd cngconf",1)  #TQC-660045
        LET g_success='N'
    END IF
    IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_flow_notify(g_cng.cng01,'Y')
        CALL cl_cmmsg(1)
    ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(1)
    END IF
    SELECT cngconf INTO g_cng.cngconf FROM cng_file
        WHERE cng01 = g_cng.cng01
    DISPLAY BY NAME g_cng.cngconf
    #CKP
    #CALL cl_set_field_pic(g_cng.cngconf,"","","","",g_cng.cngacti)  #CHI-C80041
    IF g_cng.cngconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cng.cngconf,"","","",g_void,g_cng.cngacti)   #CHI-C80041
END FUNCTION
 
FUNCTION t200_z() #撤銷審核
    IF g_cng.cng01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cng.* FROM cng_file WHERE cng01=g_cng.cng01
    IF g_cng.cngconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cng.cngconf='N' THEN RETURN END IF
    IF NOT cl_null(g_cng.cng10) THEN CALL cl_err('','aco-177',0) RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
        OPEN t200_cl USING g_cng.cng01
        IF STATUS THEN
           CALL cl_err("OPEN t200_cl:", STATUS, 1)
           CLOSE t200_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t200_cl INTO g_cng.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
            CLOSE t200_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE cng_file SET cngconf='N'
            WHERE cng01 = g_cng.cng01
        IF STATUS THEN
#           CALL cl_err('upd cngconf',STATUS,0)
            CALL cl_err3("upd","cng_file",g_cng.cng01,"",STATUS,"","upd cngconf",1)  #TQC-660045
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT cngconf INTO g_cng.cngconf FROM cng_file
            WHERE cng01 = g_cng.cng01
        DISPLAY BY NAME g_cng.cngconf
    #CKP
    #CALL cl_set_field_pic(g_cng.cngconf,"","","","",g_cng.cngacti) #CHI-C80041
    IF g_cng.cngconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cng.cngconf,"","","",g_void,g_cng.cngacti)   #CHI-C80041
END FUNCTION
 
FUNCTION s_ins_cnj()
  DEFINE l_cnh03 LIKE cnh_file.cnh03
  DEFINE l_cnh05 LIKE cnh_file.cnh05
   DEFINE l_cnh06 LIKE cnh_file.cnh06     #No.MOD-493098
   DEFINE l_ima55 LIKE ima_file.ima55     #No.MOD-493098
  DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550100
   DEFINE l_fac   LIKE bmb_file.bmb10_fac #No.MOD-490398
   DEFINE l_sw   LIKE type_file.chr1         #No.FUN-680069   VARCHAR(1)              #No.MOD-490398
  DEFINE l_bmb06 LIKE bmb_file.bmb06
  DEFINE l_bmb03 LIKE bmb_file.bmb03
  DEFINE l_i     LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_ima25 LIKE ima_file.ima25
  DEFINE l_n     LIKE type_file.num5                   #No.TQC-660113        #No.FUN-680069 SMALLINT
 
  IF s_shut(0) THEN RETURN END IF
  IF g_cng.cng01 IS NULL THEN
      CALL cl_err("",-400,0) RETURN
  END IF
  IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_cng.cng01,'mfg1000',0)
      RETURN
  END IF
  IF (NOT cl_null(g_cng.cng07) AND g_cng.cng07 < g_today) OR
     g_cng.cng05 < g_today THEN
     CALL cl_err(g_cng.cng04,'aco-060',0)
     RETURN
  END IF
  SELECT COUNT(*) INTO l_i FROM cnj_file
   WHERE cnj01 = g_cng.cng01
  IF l_i > 0 THEN
      RETURN
  END IF
 
  LET g_vdate      = g_today
  DROP TABLE t200_temp
#No.FUN-680069-begin
  CREATE TEMP TABLE t200_temp (
         level1 LIKE bmb_file.bmb02,
         bmb02  LIKE bmb_file.bmb02,
         bmb03  LIKE bmb_file.bmb03,
         bmb06  LIKE bmb_file.bmb06,
         bmb08  LIKE bmb_file.bmb08,
         bmb10  LIKE bmb_file.bmb10,
         bma01  LIKE bma_file.bma01)
#No.FUN-680069-end
  IF STATUS THEN CALL cl_err('cre temp',STATUS,0) RETURN END IF
 
   #No.MOD-490398
  DECLARE t200_cnh_cur CURSOR FOR
          SELECT cnh03,cnh05,cnh06 FROM cnh_file  #,coa_file,cob_file #No.TQC-660113 MARK
           WHERE cnh01 = g_cng.cng01
#            AND cnh03 = coa01  #No.TQC-660113 MARK
#            AND cob01 = coa03  #No.TQC-660113 MARK
   #No.MOD-490398 END
   #No.MOD-490398  --begin
  FOREACH t200_cnh_cur INTO l_cnh03,l_cnh05,l_cnh06
      IF SQLCA.sqlcode THEN
         CALL cl_err(l_cnh03,SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      #No.TQC-660113 --start--                                                                                                      
      SELECT COUNT(*) INTO l_n                                                                                                      
        FROM coa_file,cob_file                                                                                                      
       WHERE coa01 = l_cnh03                                                                                                        
         AND cob01 = coa03                                                                                                          
      IF l_n = 0 THEN                                                                                                               
         CONTINUE FOREACH                                                                                                           
      END IF                                                                                                                        
      #No.TQC-660113 --end-- 
      SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=l_cnh03
      IF cl_null(l_ima55) THEN
         CALL cl_err('ima55',SQLCA.sqlcode,0)
         LET l_ima55=l_cnh06
      END IF
      LET l_fac = 1
      IF l_ima55 !=l_cnh06 THEN
         CALL s_umfchk(l_cnh03,l_cnh06,l_ima55)
              RETURNING l_sw, l_fac    #單位換算
         IF l_sw  = '1'  THEN #有問題
            CALL cl_err(l_cnh03,'abm-731',1)
            LET l_fac = 1
         END IF
      END IF
      LET l_cnh05=l_cnh05*l_fac
       #No.MOD-490398  --end
      #FUN-550100
      LET l_ima910=''
      SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=l_cnh03
      IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
      #--
      CALL t200_bom(0,l_cnh03,l_ima910,l_cnh05)   #FUN-550100
  END FOREACH
 
  DECLARE t200_temp_cur CURSOR FOR
          SELECT bmb03,SUM(bmb06) FROM t200_temp
           GROUP BY bmb03
           ORDER BY bmb03
  DELETE FROM cnj_file WHERE cnj01 = g_cng.cng01
  LET l_i = 1
  FOREACH t200_temp_cur INTO l_bmb03,l_bmb06
      IF SQLCA.sqlcode THEN
         CALL cl_err(l_cnh03,SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
   #No.MOD-490398  --begin
      SELECT ima25,ima55 INTO l_ima25,l_ima55 FROM ima_file
       WHERE ima01 = l_bmb03
      LET l_fac = 1
      IF l_ima55 !=l_ima25 THEN
         CALL s_umfchk(l_bmb03,l_ima55,l_ima25)
              RETURNING l_sw, l_fac    #單位換算
         IF l_sw  = '1'  THEN #有問題
            CALL cl_err(l_bmb03,'abm-731',1)
            LET l_fac = 1
         END IF
      END IF
      LET l_bmb06=l_bmb06*l_fac
      LET l_bmb06=s_digqty(l_bmb06,l_ima25)   #FUN-BB0084
   #No.MOD-490398  --end
      INSERT INTO cnj_file(cnj01,cnj02,cnj03,cnj05,cnj06,cnj07,cnj08,cnjplant,cnjlegal) #FUN-980002 add cnjplant,cnjlegal
           VALUES (g_cng.cng01,l_i,l_bmb03,l_bmb06,l_ima25,0,0,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
      LET l_i = l_i + 1
  END FOREACH
END FUNCTION
 
FUNCTION t200_bom(p_level,p_key,p_key2,p_total)      #FUN-550100
   DEFINE p_level       LIKE type_file.num5,         #No.FUN-680069 SMALLINT,
          p_key         LIKE bma_file.bma01,         #主件料件編號
          p_key2	LIKE ima_file.ima910,        #FUN-550100
         #p_total       DECIMAL(13,5),
          p_total       LIKE oeb_file.oeb12,         #No.FUN-680069  DECIMAL(16,8)  #FUN-560227
          l_ac,i,l_n    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          arrno         LIKE type_file.num5,         #No.FUN-680069 SMALLINT      #BUFFER SIZE (可存筆數)
          l_chr         LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
   #No.MOD-490398  --begin
          sr DYNAMIC ARRAY OF RECORD                 #每階存放資料
              level1 LIKE type_file.num5,            #No.FUN-680069   SMALLINT
              bmb02  LIKE bmb_file.bmb02,    #項次
              bmb03  LIKE bmb_file.bmb03,    #元件料號
              bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08  LIKE bmb_file.bmb08,    #損耗率
              bmb10  LIKE bmb_file.bmb10,    #發料單位
              bma01  LIKE bma_file.bma01
          END RECORD,
          l_cmd         LIKE type_file.chr1000       #No.FUN-680069  VARCHAR(1000)
   DEFINE l_ima55 LIKE ima_file.ima55
   DEFINE l_fac   LIKE bmb_file.bmb10_fac
   DEFINE l_sw    LIKE type_file.chr1                #No.FUN-680069  VARCHAR(1) 
   #No.MOD-490398  --end
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
        IF p_level > 20 THEN
                CALL cl_err('','mfg2733',1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
                EXIT PROGRAM
                   
        END IF
    LET p_level = p_level + 1
    LET arrno = 600                     #95/12/21 Modify By Lynn
     #No.MOD-490398  --begin
    LET l_cmd= "SELECT 0, bmb02, bmb03, (bmb06/bmb07),bmb08,bmb10, bma01",
               "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03 = bma_file.bma01",
               " WHERE bmb01='", p_key,"' " ,
               "   AND bmb29 ='",p_key2,"' "  #FUN-550100
    #---->生效日及失效日的判斷
     LET l_cmd=l_cmd CLIPPED,
               " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
    LET l_cmd = l_cmd CLIPPED, ' ORDER BY bmb02'
     #No.MOD-490398  --end
    PREPARE t200_precur FROM l_cmd
    IF SQLCA.sqlcode THEN CALL cl_err('P1:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM 
    END IF
    DECLARE t200_cur CURSOR FOR t200_precur
    LET l_ac = 1
    FOREACH t200_cur INTO sr[l_ac].*    # 先將BOM單身存入BUFFER
        #FUN-8B0035--BEGIN--
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        #FUN-8B0035--END--
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1                         # 讀BUFFER傳給REPORT
        LET sr[i].level1= p_level
         #No.MOD-490398  by carrier
        LET l_fac = 1
        SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=sr[i].bmb03
        IF l_ima55 !=sr[i].bmb10 THEN
           CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima55)
                 RETURNING l_sw, l_fac    #單位換算
           IF l_sw  = '1'  THEN #有問題
              CALL cl_err(sr[i].bmb03,'abm-731',1)
              LET l_fac = 1
           END IF
        END IF
        LET sr[i].bmb06=p_total*sr[i].bmb06*l_fac
         #No.MOD-490398  end
        IF sr[i].bma01 IS NOT NULL                      #若為主件
          #THEN CALL t200_bom(p_level,sr[i].bmb03,' ',sr[i].bmb06) #FUN-550100#FUN-8B0035
           THEN CALL t200_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06) #FUN-8B0035
           ELSE
                #No.MOD-490398  begin
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM coa_file,cob_file
                WHERE coa01 = sr[i].bmb03 AND cob01=coa03
                #No.MOD-490398  end
               IF l_n > 0 THEN
                  INSERT INTO t200_temp VALUES (sr[i].*)
               END IF
        END IF
    END FOR
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
#Patch....NO.TQC-610035 <001> #
#CHI-C80041---begin
FUNCTION t200_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cng.cng01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t200_cl USING g_cng.cng01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_cng.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_cng.cngconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_cng.cngconf)   THEN 
        LET l_chr=g_cng.cngconf
        IF g_cng.cngconf='N' THEN 
            LET g_cng.cngconf='X' 
        ELSE
            LET g_cng.cngconf='N'
        END IF
        UPDATE cng_file
            SET cngconf=g_cng.cngconf,  
                cngmodu=g_user,
                cngdate=g_today
            WHERE cng01=g_cng.cng01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","cng_file",g_cng.cng01,"",SQLCA.sqlcode,"","",1)  
            LET g_cng.cngconf=l_chr 
        END IF
        DISPLAY BY NAME g_cng.cngconf 
   END IF
 
   CLOSE t200_cl
   COMMIT WORK
   CALL cl_flow_notify(g_cng.cng01,'V')
 
END FUNCTION
#CHI-C80041---end
