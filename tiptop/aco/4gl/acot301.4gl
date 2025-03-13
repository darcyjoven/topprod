# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot301.4gl
# Descriptions...: 進口材料加簽異動作業
# Date & Author..: 00/06/05 By Kammy
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/17 By Carrier add coi05
# Modify.........: No.FUN-550036 05/05/24 By Trisy 單據編號加大
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630014 06/03/07 By Carol 流程訊息通知功能
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/07 By TSD.liquor 自定欄位功能修改
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-960255 09/06/22 By baofei ON ROW CHANGE段不需要LET g_rec_b=g_rec_b+1
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0055 09/12/08 By Carrier g_rec_b错误
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 12/01/11 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/20 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_coi           RECORD LIKE coi_file.*,       #單頭
    g_coi_t         RECORD LIKE coi_file.*,       #單頭(舊值)
    g_coi_o         RECORD LIKE coi_file.*,       #單頭(舊值)
    g_coi01_t       LIKE coi_file.coi01,          #單頭 (舊值)
    g_coi03_t       LIKE coi_file.coi01,          #手冊編號
     g_coi05_t      LIKE coi_file.coi01,          #custom  #No.MOD-490398
    g_t1            LIKE oay_file.oayslip,        #No.FUN-550036        #No.FUN-680069  VARCHAR(05)
    g_coj           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        coj02       LIKE coj_file.coj02,      #項次
        coj03       LIKE coj_file.coj03,      #商品編號
        cob02       LIKE cob_file.cob02,      #
        coj05       LIKE coj_file.coj05,      #
        coj06       LIKE coj_file.coj06,      #
        coj07       LIKE coj_file.coj07,      #
        coj08       LIKE coj_file.coj08,      #
        #FUN-840202 --start---
        cojud01 LIKE coj_file.cojud01,
        cojud02 LIKE coj_file.cojud02,
        cojud03 LIKE coj_file.cojud03,
        cojud04 LIKE coj_file.cojud04,
        cojud05 LIKE coj_file.cojud05,
        cojud06 LIKE coj_file.cojud06,
        cojud07 LIKE coj_file.cojud07,
        cojud08 LIKE coj_file.cojud08,
        cojud09 LIKE coj_file.cojud09,
        cojud10 LIKE coj_file.cojud10,
        cojud11 LIKE coj_file.cojud11,
        cojud12 LIKE coj_file.cojud12,
        cojud13 LIKE coj_file.cojud13,
        cojud14 LIKE coj_file.cojud14,
        cojud15 LIKE coj_file.cojud15
        #FUN-840202 --end--
                    END RECORD,
    g_coj_t         RECORD                 #程式變數 (舊值)
        coj02       LIKE coj_file.coj02,   #項次
        coj03       LIKE coj_file.coj03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        coj05       LIKE coj_file.coj05,   #
        coj06       LIKE coj_file.coj06,   #
        coj07       LIKE coj_file.coj07,   #
        coj08       LIKE coj_file.coj08,   #
        #FUN-840202 --start---
        cojud01 LIKE coj_file.cojud01,
        cojud02 LIKE coj_file.cojud02,
        cojud03 LIKE coj_file.cojud03,
        cojud04 LIKE coj_file.cojud04,
        cojud05 LIKE coj_file.cojud05,
        cojud06 LIKE coj_file.cojud06,
        cojud07 LIKE coj_file.cojud07,
        cojud08 LIKE coj_file.cojud08,
        cojud09 LIKE coj_file.cojud09,
        cojud10 LIKE coj_file.cojud10,
        cojud11 LIKE coj_file.cojud11,
        cojud12 LIKE coj_file.cojud12,
        cojud13 LIKE coj_file.cojud13,
        cojud14 LIKE coj_file.cojud14,
        cojud15 LIKE coj_file.cojud15
        #FUN-840202 --end--
                    END RECORD,
    g_coj_o         RECORD                 #程式變數 (舊值)
        coj02       LIKE coj_file.coj02,   #項次
        coj03       LIKE coj_file.coj03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        coj05       LIKE coj_file.coj05,   #
        coj06       LIKE coj_file.coj06,   #
        coj07       LIKE coj_file.coj07,   #
        coj08       LIKE coj_file.coj08,   #
        #FUN-840202 --start---
        cojud01 LIKE coj_file.cojud01,
        cojud02 LIKE coj_file.cojud02,
        cojud03 LIKE coj_file.cojud03,
        cojud04 LIKE coj_file.cojud04,
        cojud05 LIKE coj_file.cojud05,
        cojud06 LIKE coj_file.cojud06,
        cojud07 LIKE coj_file.cojud07,
        cojud08 LIKE coj_file.cojud08,
        cojud09 LIKE coj_file.cojud09,
        cojud10 LIKE coj_file.cojud10,
        cojud11 LIKE coj_file.cojud11,
        cojud12 LIKE coj_file.cojud12,
        cojud13 LIKE coj_file.cojud13,
        cojud14 LIKE coj_file.cojud14,
        cojud15 LIKE coj_file.cojud15
        #FUN-840202 --end--
                    END RECORD,
    g_coc01         LIKE coc_file.coc01,   #合同申請單號
    g_argv1         LIKE cnp_file.cnp01,   #詢價單號
    g_argv2         STRING,                #No.FUN-680069 STRING   #FUN-630014 指定執行的功能
    g_wc,g_wc2,g_sql    STRING,            #No.FUN-580092 HCN      #No.FUN-680069
    g_rec_b         LIKE type_file.num5,   #單身筆數               #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680069 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-680069 SMALLINT #目前處理的SCREEN LINE
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     #No.FUN-680069
DEFINE g_before_input_done LIKE type_file.num5              #No.FUN-680069 SMALLINT
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680069 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE   g_void          LIKE type_file.chr1              #CHI-C80041

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5            #No.FUN-680069 SMALLINT
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
    LET g_argv2 = ARG_VAL(2)               #參數-2(指定執行的功能) FUN-630014 add
 
    LET g_forupd_sql = " SELECT * FROM coi_file WHERE coi01 =? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t301_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t301_w AT p_row,p_col
        WITH FORM "aco/42f/acot301"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-630014 mark 
   #IF g_argv1 IS NOT NULL AND g_argv1 != ' '
   #THEN CALL t301_q()
   #END IF
   #FUN-630014 mark --end 
 
   #FUN-630014 --start--
   # 先以g_argv2判斷直接執行哪種功能
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t301_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t301_a()
            END IF
         OTHERWISE
            CALL t301_q()
      END CASE
   END IF
   #FUN-630014 ---end---
 
    CALL t301_menu()
    CLOSE WINDOW t301_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t301_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_coj.clear()
 
  IF NOT cl_null(g_argv1) THEN                    #FUN-630014 modify
     LET g_wc = " coi01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
     CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_coi.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          coi01,coi02,coi05,coi03,  #No.MOD-490398
         coiconf,coi04,coiuser,coigrup,coimodu,coidate,coiacti,
         #FUN-840202   ---start---
         coiud01,coiud02,coiud03,coiud04,coiud05,
         coiud06,coiud07,coiud08,coiud09,coiud10,
         coiud11,coiud12,coiud13,coiud14,coiud15
         #FUN-840202    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
               WHEN INFIELD(coi01) #單別
                    #CALL q_coy( FALSE,TRUE,g_coi.coi01,'13',g_sys)  #TQC-670008
                    CALL q_coy( FALSE,TRUE,g_coi.coi01,'13','ACO')   #TQC-670008
                         RETURNING g_coi.coi01
                    DISPLAY BY NAME g_coi.coi01
                    NEXT FIELD coi01
                #No.MOD-490398
               WHEN INFIELD(coi05)  #customer
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_cna"
                    LET g_qryparam.default1 = g_coi.coi05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coi05
                    NEXT FIELD coi05
               WHEN INFIELD(coi03) #手冊編號
                 CALL q_coc2(TRUE,TRUE,g_coi.coi03,'',
                             g_coi.coi02,'1',g_coi.coi05,'')
                      RETURNING g_coi.coi03
                 DISPLAY BY NAME g_coi.coi03
                 NEXT FIELD coi03
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
    CONSTRUCT g_wc2 ON coj02,coj03,coj05,   #螢幕上取單身條件
                       coj06,coj07,coj08
                       #No.FUN-840202 --start--
                       ,cojud01,cojud02,cojud03,cojud04,cojud05
                       ,cojud06,cojud07,cojud08,cojud09,cojud10
                       ,cojud11,cojud12,cojud13,cojud14,cojud15
                       #No.FUN-840202 ---end---
            FROM s_coj[1].coj02,s_coj[1].coj03,
                 s_coj[1].coj05,s_coj[1].coj06,s_coj[1].coj07,
                 s_coj[1].coj08
                 #No.FUN-840202 --start--
                 ,s_coj[1].cojud01,s_coj[1].cojud02,s_coj[1].cojud03,s_coj[1].cojud04,s_coj[1].cojud05
                 ,s_coj[1].cojud06,s_coj[1].cojud07,s_coj[1].cojud08,s_coj[1].cojud09,s_coj[1].cojud10
                 ,s_coj[1].cojud11,s_coj[1].cojud12,s_coj[1].cojud13,s_coj[1].cojud14,s_coj[1].cojud15
                 #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(coj02)  #序號
                    CALL q_coe(TRUE,TRUE,g_coc01,g_coj[1].coj02)
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coj02
                    NEXT FIELD coj02
               WHEN INFIELD(coj03) #料件編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cob"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coj03
                    NEXT FIELD coj03
               WHEN INFIELD(coj06) #詢價單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coj03
                    NEXT FIELD coj06
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
  #     LET g_wc = g_wc clipped," AND coiuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND coigrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND coigrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('coiuser', 'coigrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT coi01 FROM coi_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY coi01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE coi01 ",
                   "  FROM coi_file, coj_file ",
                   " WHERE coi01 = coj01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY coi01"
    END IF
 
    PREPARE t301_prepare FROM g_sql
    DECLARE t301_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t301_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM coi_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM coi_file,coj_file WHERE ",
                  "coj01=coi01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t301_precount FROM g_sql
    DECLARE t301_count CURSOR FOR t301_precount
END FUNCTION
 
FUNCTION t301_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069  VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL t301_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t301_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t301_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t301_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t301_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t301_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t301_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_coj),'','')
             END IF
         #--
 
         WHEN "query_exports"
            IF cl_chk_act_auth() THEN
               LET l_cmd="acot300 '",g_coi.coi01,"'"
               #CALL cl_cmdrun(l_cmd)     #FUN-660216 remark
               CALL cl_cmdrun_wait(l_cmd) #FUN-660216 add
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t301_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t301_z()
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_coi.coi01 IS NOT NULL THEN
                 LET g_doc.column1 = "coi01"
                 LET g_doc.value1 = g_coi.coi01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t301_v()
               IF g_coi.coiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_coi.coiconf,"","","",g_void,g_coi.coiacti)
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t301_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
    MESSAGE ""
    CLEAR FORM
    CALL g_coj.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_coi.* LIKE coi_file.*             #DEFAULT 設置
    LET g_coi01_t = NULL
    LET g_coi03_t = NULL
    LET g_coi05_t = NULL  #No.MOD-490398
    LET g_coi_t.* = g_coi.*
    LET g_coi_o.* = g_coi.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_coi.coi04 = 0
        LET g_coi.coi02 = g_today
        LET g_coi.coi05 = g_coz.coz02            #No.MOD-490398
        LET g_coi.coiconf='N'
        LET g_coi.coiuser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_coi.coigrup=g_grup
        LET g_coi.coidate=g_today
        LET g_coi.coiplant = g_plant #FUN-980002
        LET g_coi.coilegal = g_legal #FUN-980002
 
        LET g_coi.coiacti='Y'              #資料有效
        BEGIN WORK
        CALL t301_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_coi.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_coi.coi01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
      #No.FUN-550036 --start--
#       IF cl_null(g_coi.coi01[5,10]) THEN              #自動編號
        IF cl_null(g_coi.coi01[g_no_sp,g_no_ep]) THEN   #自動編號
#           CALL s_acoauno(g_coi.coi01,g_coi.coi02,'13')
#             RETURNING g_i,g_coi.coi01
#           #####
#           IF g_i THEN CONTINUE WHILE END IF
      CALL s_auto_assign_no("aco",g_coi.coi01,g_coi.coi02,"13","coi_file","coi01","","","")
        RETURNING li_result,g_coi.coi01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      #No.FUN-550036 ---end---
           DISPLAY BY NAME g_coi.coi01
        END IF
        LET g_coi.coioriu = g_user      #No.FUN-980030 10/01/04
        LET g_coi.coiorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO coi_file VALUES (g_coi.*)
#       LET g_t1 = g_coi.coi01[1,3]           #備份上一筆單別
        LET g_t1 = s_get_doc_no(g_coi.coi01)  #No.FUN-550036
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
#           CALL cl_err(g_coi.coi01,SQLCA.sqlcode,1) #No.TQC-660045
            CALL cl_err3("ins","coi_file",g_coi.coi01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_coi.coi01,'I')
        SELECT coi01 INTO g_coi.coi01 FROM coi_file
            WHERE coi01 = g_coi.coi01
        LET g_coi01_t = g_coi.coi01        #保留舊值
         LET g_coi05_t = g_coi.coi05        #保留舊值  #No.MOD-490398
        LET g_coi03_t = g_coi.coi03        #保留舊值
        LET g_coi_t.* = g_coi.*
        LET g_coi_o.* = g_coi.*
        LET g_rec_b=0
        CALL t301_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t301_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_coi.coi01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_coi.* FROM coi_file WHERE coi01=g_coi.coi01
    IF g_coi.coiacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_coi.coi01,'mfg1000',0)
        RETURN
    END IF
    IF g_coi.coiconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_coi.coiconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_coi.coi01,'axm-101',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_coi01_t = g_coi.coi01
     LET g_coi05_t = g_coi.coi05    #No.MOD-490398
    LET g_coi03_t = g_coi.coi03
    BEGIN WORK
 
    OPEN t301_cl USING g_coi.coi01
    IF STATUS THEN
       CALL cl_err("OPEN t301_cl:", STATUS, 1)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t301_cl INTO g_coi.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t301_cl
        RETURN
    END IF
    CALL t301_show()
    WHILE TRUE
        LET g_coi01_t = g_coi.coi01
         LET g_coi05_t = g_coi.coi05  #No.MOD-490398
        LET g_coi03_t = g_coi.coi03
        LET g_coi_o.* = g_coi.*
        LET g_coi.coimodu=g_user
        LET g_coi.coidate=g_today
        CALL t301_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_coi.*=g_coi_t.*
            CALL t301_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_coi.coi01 != g_coi01_t THEN            # 更改單號
            UPDATE coj_file SET coj01 = g_coi.coi01
                WHERE coj01 = g_coi01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('coj',SQLCA.sqlcode,0)  #No.TQC-660045
                CALL cl_err3("upd","coj_file",g_coi01_t,"",SQLCA.sqlcode,"","coj",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
        UPDATE coi_file SET coi_file.* = g_coi.*
            WHERE coi01 = g_coi01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","coi_file",g_coi01_t,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t301_cl
    COMMIT WORK
    CALL cl_flow_notify(g_coi.coi01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t301_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_coc04   LIKE coc_file.coc04,            #No.MOD-490398
    l_pmc30   LIKE pmc_file.pmc30,
    l_n		LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    p_cmd           LIKE type_file.chr1       #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
DEFINE   li_result  LIKE type_file.num5       #No.FUN-550036        #No.FUN-680069 SMALLINT
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
         g_coi.coi01,g_coi.coi02,g_coi.coi05,g_coi.coi03,  #No.MOD-490398
        g_coi.coiconf,g_coi.coi04,g_coi.coiuser,
        g_coi.coigrup,g_coi.coimodu,g_coi.coidate,g_coi.coiacti,
        #FUN-840202     ---start---
        g_coi.coiud01,g_coi.coiud02,g_coi.coiud03,g_coi.coiud04,
        g_coi.coiud05,g_coi.coiud06,g_coi.coiud07,g_coi.coiud08,
        g_coi.coiud09,g_coi.coiud10,g_coi.coiud11,g_coi.coiud12,
        g_coi.coiud13,g_coi.coiud14,g_coi.coiud15 
        #FUN-840202     ----end----
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
    INPUT BY NAME
         g_coi.coi01,g_coi.coi02,g_coi.coi05,g_coi.coi03,g_coi.coi04,  #No.MOD-490398
        g_coi.coiconf,g_coi.coiuser,
        g_coi.coigrup,g_coi.coimodu,g_coi.coidate,g_coi.coiacti,
        #FUN-840202     ---start---
        g_coi.coiud01,g_coi.coiud02,g_coi.coiud03,g_coi.coiud04,
        g_coi.coiud05,g_coi.coiud06,g_coi.coiud07,g_coi.coiud08,
        g_coi.coiud09,g_coi.coiud10,g_coi.coiud11,g_coi.coiud12,
        g_coi.coiud13,g_coi.coiud14,g_coi.coiud15 
        #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t301_set_entry(p_cmd)
            CALL t301_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("coi01")
         #No.FUN-550036 ---end---
 
       {
        BEFORE FIELD coi01    #本系統不允許更改key
            IF p_cmd = 'u'  AND g_chkey = 'N' THEN
               NEXT FIELD coi02
            END IF
       }
        AFTER FIELD coi01
         #No.FUN-550036 --start--
         IF NOT cl_null(g_coi.coi01) THEN
            LET g_t1=s_get_doc_no(g_coi.coi01)
            IF p_cmd = 'a' THEN
               CALL s_check_no("aco",g_coi.coi01,g_coi01_t,"13","coi_file","coi01","")
                  RETURNING li_result,g_coi.coi01
            ELSE
               IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
                  CALL s_check_no("aco",g_coi.coi01,g_coi01_t,"12","coi_file","coi01","")
                     RETURNING li_result,g_coi.coi01
               ELSE
                  SELECT * FROM cog_file WHERE cog01 = g_coi.coi01
                  IF STATUS THEN
                     CALL s_check_no("aco",g_coi.coi01,g_coi01_t,"13","coi_file","coi01","")
                        RETURNING li_result,g_coi.coi01
                  ELSE
                     CALL s_check_no("aco",g_coi.coi01,g_coi01_t,"12","coi_file","coi01","")
                        RETURNING li_result,g_coi.coi01
                  END IF
               END IF
            END IF
            DISPLAY BY NAME g_coi.coi01
            IF (NOT li_result) THEN
               LET g_coi.coi01=g_coi_o.coi01
               NEXT FIELD coi01
            END IF
#           IF NOT cl_null(g_coi.coi01) THEN
#              LET g_t1=g_coi.coi01[1,3]
#
#              IF p_cmd = 'a' THEN
#                 CALL s_acoslip(g_t1,'13',g_sys)           #檢查單別
#              ELSE
#                 IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
#                    CALL s_acoslip(g_t1,'12',g_sys)
#                 ELSE
#                    SELECT * FROM cog_file WHERE cog01 = g_coi.coi01
#                    IF STATUS THEN
#                       CALL s_acoslip(g_t1,'13',g_sys)     #檢查單別
#                    ELSE
#                       CALL s_acoslip(g_t1,'12',g_sys)     #檢查單別
#                    END IF
#                 END IF
#              END IF
#              #####
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_coi.coi01=g_coi_o.coi01
#                 NEXT FIELD coi01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_coi.coi01[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_coi.coi01[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD coi01
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD coi02			 #輸入
# 	             END IF
#           END IF
#           IF g_coi.coi01[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_coi.coi01[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_coi.coi01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD coi01
#                     END IF
#                  END IF
#              END IF
#              IF g_coi.coi01 != g_coi01_t OR g_coi01_t IS NULL THEN
#
#                  SELECT count(*) INTO l_n FROM coi_file
#                      WHERE coi01 = g_coi.coi01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_coi.coi01,-239,0)
#                      LET g_coi.coi01 = g_coi01_t
#                      DISPLAY BY NAME g_coi.coi01
#                      NEXT FIELD coi01
#                  END IF
#              END IF
            END IF
         #No.FUN-550036 ---end---
 
        #No.MOD-490398
        AFTER FIELD coi05                         #customer
            IF g_coi.coi05 IS NULL THEN LET g_coi.coi05 = ' ' END IF
            IF NOT cl_null(g_coi.coi05) THEN
               CALL t301_coi05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_coi.coi05,g_errno,0) 
                  NEXT FIELD coi05
               END IF
            END IF
        #No.MOD-490398 end
 
        AFTER FIELD coi03
            IF NOT cl_null(g_coi.coi03) THEN
               CALL t301_coi03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD coi03
               END IF
            END IF
 
        #FUN-840202     ---start---
        AFTER FIELD coiud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coiud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(coi01) #單別
                    #CALL q_coy( FALSE, TRUE,g_coi.coi01,'13',g_sys)  #TQC-670008
                    CALL q_coy( FALSE, TRUE,g_coi.coi01,'13','ACO')   #TQC-670008
                         RETURNING g_coi.coi01
#                    CALL FGL_DIALOG_SETBUFFER( g_coi.coi01 )
                    DISPLAY BY NAME g_coi.coi01
                    NEXT FIELD coi01
               #No.MOD-490398 --begin
               WHEN INFIELD(coi05)      #custom
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_cna"
                    LET g_qryparam.default1 = g_coi.coi05
                    CALL cl_create_qry() RETURNING g_coi.coi05
                    DISPLAY BY NAME g_coi.coi05
                    NEXT FIELD coi05
               WHEN INFIELD(coi03) #手冊編號
                    CALL q_coc2(FALSE,FALSE,g_coi.coi03,'',
                                g_coi.coi02,'0',g_coi.coi05,'')
                         RETURNING g_coi.coi03,l_coc04
                    DISPLAY BY NAME g_coi.coi03
                    NEXT FIELD coi03
                #No.MOD-490398 --end
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t301_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
 
 IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
 CALL cl_set_comp_entry("coi01",TRUE)
 END IF
 
END FUNCTION
FUNCTION t301_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("coi01",FALSE)
    END IF
END FUNCTION
 
 #No.MOD-490398
FUNCTION t301_coi05(p_cmd)  #
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file WHERE cna01 = g_coi.coi05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
         WHEN l_cnaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 #No.MOD-490398 end
 
 #No.MOD-490398
FUNCTION t301_coi03(p_cmd)  #手冊編號
    DEFINE l_coc02   LIKE coc_file.coc02,
           l_coc04   LIKE coc_file.coc04,
           l_coc05   LIKE coc_file.coc05,
           l_coc07   LIKE coc_file.coc07,
           l_cocacti LIKE coc_file.cocacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT coc01,coc02,coc04,coc05,coc07,cocacti
      INTO g_coc01,l_coc02,l_coc04,l_coc05,l_coc07,l_cocacti
      FROM coc_file WHERE coc03 = g_coi.coi03 AND coc10 = g_coi.coi05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-005'
                                   LET l_coc02 = NULL
                                   LET l_coc04 = NULL
                                   LET l_coc07 = NULL
         WHEN l_cocacti='N'        LET g_errno = '9028'
         WHEN l_coc05 < g_today    LET g_errno = 'aco-056'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(l_coc07) THEN LET g_errno='aco-057' END IF
    DISPLAY l_coc02 TO FORMONLY.coc02
    DISPLAY l_coc04 TO FORMONLY.coc04
END FUNCTION
 #No.MOD-490398  end
 
#Query 查詢
FUNCTION t301_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_coi.* TO NULL               #No.FUN-6A0168 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_coj.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t301_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_coi.* TO NULL
        RETURN
    END IF
    OPEN t301_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_coi.* TO NULL
    ELSE
        OPEN t301_count
        FETCH t301_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t301_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
#處理資料的讀取
FUNCTION t301_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式          #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t301_cs INTO g_coi.coi01
        WHEN 'P' FETCH PREVIOUS t301_cs INTO g_coi.coi01
        WHEN 'F' FETCH FIRST    t301_cs INTO g_coi.coi01
        WHEN 'L' FETCH LAST     t301_cs INTO g_coi.coi01
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
         FETCH ABSOLUTE g_jump t301_cs INTO g_coi.coi01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0)
        INITIALIZE g_coi.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_coi.* FROM coi_file WHERE coi01 = g_coi.coi01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","coi_file",g_coi.coi01,"",SQLCA.sqlcode,"","",1) #TQC-660045
        INITIALIZE g_coi.* TO NULL
        RETURN
    END IF
 
    CALL t301_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t301_show()
    LET g_coi_t.* = g_coi.*                #保存單頭舊值
    LET g_coi_o.* = g_coi.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
 
         g_coi.coi01,g_coi.coi02,g_coi.coi03,g_coi.coi04,g_coi.coi05,  #No.MOD-490398
        g_coi.coiconf,g_coi.coiuser,
        g_coi.coigrup,g_coi.coimodu,g_coi.coidate,g_coi.coiacti,
        #FUN-840202     ---start---
        g_coi.coiud01,g_coi.coiud02,g_coi.coiud03,g_coi.coiud04,
        g_coi.coiud05,g_coi.coiud06,g_coi.coiud07,g_coi.coiud08,
        g_coi.coiud09,g_coi.coiud10,g_coi.coiud11,g_coi.coiud12,
        g_coi.coiud13,g_coi.coiud14,g_coi.coiud15 
        #FUN-840202     ----end----
    #CALL cl_set_field_pic(g_coi.coiconf,"","","","",g_coi.coiacti)  #CHI-C80041
    IF g_coi.coiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_coi.coiconf,"","","",g_void,g_coi.coiacti)  #CHI-C80041
 
    CALL t301_coi03('d')
    CALL t301_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t301_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_coi.coi01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t301_cl USING g_coi.coi01
    IF STATUS THEN
       CALL cl_err("OPEN t301_cl:", STATUS, 1)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t301_cl INTO g_coi.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    IF g_coi.coiconf='Y' THEN RETURN END IF
    CALL t301_show()
    IF cl_exp(0,0,g_coi.coiacti) THEN                   #審核一下
        LET g_chr=g_coi.coiacti
        IF g_coi.coiacti='Y' THEN
            LET g_coi.coiacti='N'
        ELSE
            LET g_coi.coiacti='Y'
        END IF
        UPDATE coi_file                    #更改有效碼
            SET coiacti=g_coi.coiacti
            WHERE coi01=g_coi.coi01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","coi_file",g_coi.coi01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            LET g_coi.coiacti=g_chr
        END IF
        DISPLAY BY NAME g_coi.coiacti
    END IF
    CLOSE t301_cl
    COMMIT WORK
    #CALL cl_set_field_pic(g_coi.coiconf,"","","","",g_coi.coiacti) #CHI-C80041
    IF g_coi.coiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_coi.coiconf,"","","",g_void,g_coi.coiacti)  #CHI-C80041
    CALL cl_flow_notify(g_coi.coi01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t301_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_coi.coi01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    SELECT * INTO g_coi.* FROM coi_file WHERE coi01=g_coi.coi01
    IF g_coi.coiacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_coi.coi01,'mfg1000',0)
        RETURN
    END IF
    IF g_coi.coiconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_coi.coiconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_coi.coi01,'axm-101',0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t301_cl USING g_coi.coi01
    IF STATUS THEN
       CALL cl_err("OPEN t301_cl:", STATUS, 1)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t301_cl INTO g_coi.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t301_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "coi01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_coi.coi01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM coi_file WHERE coi01 = g_coi.coi01
            DELETE FROM coj_file WHERE coj01 = g_coi.coi01
        #No.MOD-490398
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980002 add azoplant,azolegal
          VALUES ('acot301',g_user,g_today,g_msg,g_coi.coi01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
        #No.MOD-490398 end
            CLEAR FORM
           CALL g_coj.clear()
 
         OPEN t301_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t301_cs
            CLOSE t301_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t301_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t301_cs
            CLOSE t301_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t301_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t301_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t301_fetch('/')
         END IF
    END IF
    CLOSE t301_cl
    COMMIT WORK
    CALL cl_flow_notify(g_coi.coi01,'D')
END FUNCTION
 
#單身
FUNCTION t301_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT     #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_coi.coi01 IS NULL THEN RETURN END IF
    SELECT * INTO g_coi.* FROM coi_file WHERE coi01=g_coi.coi01
    IF g_coi.coiacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_coi.coi01,'mfg1000',0)
        RETURN
    END IF
    IF g_coi.coiconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_coi.coiconf='Y' THEN RETURN END IF
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT coj02,coj03,'',coj05,coj06,coj07,coj08 ",
                       "  FROM coj_file ",
                       " WHERE coj01=? AND coj02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t301_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        IF g_rec_b=0 THEN CALL g_coj.clear() END IF
 
        INPUT ARRAY g_coj WITHOUT DEFAULTS FROM s_coj.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
 
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t301_cl USING g_coi.coi01
            IF STATUS THEN
               CALL cl_err("OPEN t301_cl:", STATUS, 1)
               CLOSE t301_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t301_cl INTO g_coi.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t301_cl
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_coj_t.* = g_coj[l_ac].*  #BACKUP
                LET g_coj_o.* = g_coj[l_ac].*  #BACKUP
 
                OPEN t301_bcl USING g_coi.coi01,g_coj_t.coj02
                IF STATUS THEN
                   CALL cl_err("OPEN t301_bcl:", STATUS, 1)
                   CLOSE t301_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t301_bcl INTO g_coj[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_coj_t.coj02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL t301_coj02('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #No.TQC-9C0055  --Begin
              #INITIALIZE g_coj[l_ac].* TO NULL  #重要欄位空白,無效
              #DISPLAY g_coj[l_ac].* TO s_coj.*
              #CALL g_coj.deleteElement(g_rec_b+1)
              #ROLLBACK WORK
              #EXIT INPUT
              CANCEL INSERT
              #No.TQC-9C0055  --End  
            END IF
            INSERT INTO coj_file(coj01,coj02,coj03,
                                 coj05,coj06,
                                 coj07,coj08,
                                 #FUN-840202 --start--
                                 cojud01,cojud02,cojud03,
                                 cojud04,cojud05,cojud06,
                                 cojud07,cojud08,cojud09,
                                 cojud10,cojud11,cojud12,
                                 cojud13,cojud14,cojud15
                                 #FUN-840202 --end--
                                ,cojplant,cojlegal  ##FUN-980002
                                )
            VALUES(g_coi.coi01,g_coj[l_ac].coj02,
                   g_coj[l_ac].coj03,
                   g_coj[l_ac].coj05,g_coj[l_ac].coj06,
                   g_coj[l_ac].coj07,g_coj[l_ac].coj08,
                   #FUN-840202 --start--
                   g_coj[l_ac].cojud01,
                   g_coj[l_ac].cojud02,
                   g_coj[l_ac].cojud03,
                   g_coj[l_ac].cojud04,
                   g_coj[l_ac].cojud05,
                   g_coj[l_ac].cojud06,
                   g_coj[l_ac].cojud07,
                   g_coj[l_ac].cojud08,
                   g_coj[l_ac].cojud09,
                   g_coj[l_ac].cojud10,
                   g_coj[l_ac].cojud11,
                   g_coj[l_ac].cojud12,
                   g_coj[l_ac].cojud13,
                   g_coj[l_ac].cojud14,
                   g_coj[l_ac].cojud15
                   #FUN-840202 --end--
                  ,g_plant,g_legal     #FUN-980002
                  )
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_coj[l_ac].coj02,SQLCA.sqlcode,0) #No.TQC-660045
                CALL cl_err3("ins","coj_file",g_coi.coi01,g_coj[l_ac].coj02,SQLCA.sqlcode,"","",1) #TQC-660045
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                CALL t301_update()
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                MESSAGE 'INSERT O.K'
                #No.TQC-9C0055  --Begin
              #  LET g_rec_b=g_rec_b+1      #TQC-960255
                 LET g_rec_b=g_rec_b+1 
                #No.TQC-9C0055  --End  
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
 
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_coj[l_ac].* TO NULL       #900423
            LET g_coj[l_ac].coj05 = 0              #Body default
            LET g_coj[l_ac].coj07 = 0              #Body default
            LET g_coj[l_ac].coj08 = 0              #Body default
            LET g_coj_t.* = g_coj[l_ac].*          #新輸入資料
            LET g_coj_o.* = g_coj[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
            NEXT FIELD coj02
 
        BEFORE FIELD coj05                        #check 序號是否重複
            IF NOT cl_null(g_coj[l_ac].coj02) THEN
               IF g_coj[l_ac].coj02 != g_coj_t.coj02 OR
                  g_coj_t.coj02 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM coj_file
                       WHERE coj01 = g_coi.coi01 AND
                             coj02 = g_coj[l_ac].coj02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_coj[l_ac].coj02 = g_coj_t.coj02
                       NEXT FIELD coj02
                   END IF
                   CALL t301_coj02('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_coj[l_ac].coj02,g_errno,0)
                      LET g_coj[l_ac].coj02 = g_coj_o.coj02
                      DISPLAY g_coj[l_ac].coj02 TO s_coj[l_sl].coj02
                      NEXT FIELD coj02
                   END IF
               END IF
            END IF
 
        AFTER FIELD coj05
           IF NOT cl_null(g_coj[l_ac].coj05) THEN
              IF g_coj[l_ac].coj05 = 0 THEN
                 NEXT FIELD coj05
              END IF
              LET g_coj[l_ac].coj05 = s_digqty(g_coj[l_ac].coj05,g_coj[l_ac].coj06)   #FUN-910088--add--
              DISPLAY BY NAME g_coj[l_ac].coj05                                       #FUN-910088--add--
           END IF
           LET g_coj[l_ac].coj08 = g_coj[l_ac].coj07 * g_coj[l_ac].coj05
           DISPLAY g_coj[l_ac].coj08 TO s_coj[l_sl].coj08
 
        #No.FUN-840202 --start--
        AFTER FIELD cojud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cojud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_coj_t.coj02 > 0 AND
               g_coj_t.coj02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM coj_file
                    WHERE coj01 = g_coi.coi01 AND
                          coj02 = g_coj_t.coj02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_coj_t.coj02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","coj_file",g_coi.coi01,g_coj_t.coj02,SQLCA.sqlcode,"","",1) #TQC-660045    
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            CALL t301_update()
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_coj[l_ac].* = g_coj_t.*
               CLOSE t301_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_coj[l_ac].coj02,-263,1)
               LET g_coj[l_ac].* = g_coj_t.*
            ELSE
               UPDATE coj_file SET coj02=g_coj[l_ac].coj02,
                                   coj03=g_coj[l_ac].coj03,
                                   coj05=g_coj[l_ac].coj05,
                                   coj06=g_coj[l_ac].coj06,
                                   coj07=g_coj[l_ac].coj07,
                                   coj08=g_coj[l_ac].coj08,
                                   #FUN-840202 --start--
                                   cojud01 = g_coj[l_ac].cojud01,
                                   cojud02 = g_coj[l_ac].cojud02,
                                   cojud03 = g_coj[l_ac].cojud03,
                                   cojud04 = g_coj[l_ac].cojud04,
                                   cojud05 = g_coj[l_ac].cojud05,
                                   cojud06 = g_coj[l_ac].cojud06,
                                   cojud07 = g_coj[l_ac].cojud07,
                                   cojud08 = g_coj[l_ac].cojud08,
                                   cojud09 = g_coj[l_ac].cojud09,
                                   cojud10 = g_coj[l_ac].cojud10,
                                   cojud11 = g_coj[l_ac].cojud11,
                                   cojud12 = g_coj[l_ac].cojud12,
                                   cojud13 = g_coj[l_ac].cojud13,
                                   cojud14 = g_coj[l_ac].cojud14,
                                   cojud15 = g_coj[l_ac].cojud15
                                   #FUN-840202 --end-- 
               WHERE coj01=g_coi.coi01 AND coj02=g_coj_t.coj02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_coj[l_ac].coj02,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","coj_file",g_coi.coi01,g_coj_t.coj02,SQLCA.sqlcode,"","",1) #TQC-660045
                   LET g_coj[l_ac].* = g_coj_t.*
                   DISPLAY g_coj[l_ac].* TO s_coj[l_sl].*
               ELSE
                   CALL t301_update()
                   IF g_success='Y' THEN
                      COMMIT WORK
                   ELSE
                      CALL cl_rbmsg(1) ROLLBACK WORK
                   END IF
                   MESSAGE 'UPDATE O.K'
                   #No.TQC-9C0055  --Begin
                   #LET g_rec_b=g_rec_b+1
                   #No.TQC-9C0055  --End  
                   DISPLAY g_rec_b TO FORMONLY.cn2
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               IF p_cmd='u' THEN
                  LET g_coj[l_ac].* = g_coj_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_coj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t301_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
          #LET g_coj_t.* = g_coj[l_ac].*          # 900423
            CLOSE t301_bcl
            COMMIT WORK
 
#           CALL g_coj.deleteElement(g_rec_b+1)    #No.TQC-9C0055
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(coj02) AND l_ac > 1 THEN
                LET g_coj[l_ac].* = g_coj[l_ac-1].*
                NEXT FIELD coj02
            END IF
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(coj02)  #序號
                    CALL q_coe(FALSE,TRUE,g_coc01,g_coj[l_ac].coj02)
                         RETURNING g_coc01,g_coj[l_ac].coj02
#                    CALL FGL_DIALOG_SETBUFFER( g_coc01 )
#                    CALL FGL_DIALOG_SETBUFFER( g_coj[l_ac].coj02 )
                     DISPLAY BY NAME g_coj[l_ac].coj02       #No.MOD-490371
                    NEXT FIELD coj02
 #No.MOD-490398   --begin
#              WHEN INFIELD(coj03) #料件編號
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_cob"
#                   LET g_qryparam.default1 = g_coj[l_ac].coj03
#                   CALL cl_create_qry() RETURNING g_coj[l_ac].coj03
#                    CALL FGL_DIALOG_SETBUFFER( g_coj[l_ac].coj03 )
 #                   DISPLAY g_coj[l_ac].coj03 TO coj03          #No.MOD-490371
#                   NEXT FIELD coj03
#
#              WHEN INFIELD(coj06) #詢價單位
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_gfe"
#                   LET g_qryparam.default1 = g_coj[l_ac].coj06
#                   CALL cl_create_qry() RETURNING g_coj[l_ac].coj06
#                    CALL FGL_DIALOG_SETBUFFER( g_coj[l_ac].coj06 )
#                   DISPLAY BY NAME g_coj[l_ac].coj06
#                   NEXT FIELD coj06
               OTHERWISE EXIT CASE
            END CASE
 #No.MOD-490398  --end
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
 
 
        END INPUT
 
        #FUN-5B0043-begin
         LET g_coi.coimodu = g_user
         LET g_coi.coidate = g_today
         UPDATE coi_file SET coimodu = g_coi.coimodu,coidate = g_coi.coidate
          WHERE coi01 = g_coi.coi01
         DISPLAY BY NAME g_coi.coimodu,g_coi.coidate
        #FUN-5B0043-end
 
        CLOSE t301_bcl
        COMMIT WORK
        CALL t301_delHeader()     #CHI-C30002 add
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION t301_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_coi.coi01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM coi_file ",
                  "  WHERE coi01 LIKE '",l_slip,"%' ",
                  "    AND coi01 > '",g_coi.coi01,"'"
      PREPARE t301_pb1 FROM l_sql 
      EXECUTE t301_pb1 INTO l_cnt       
      
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
         CALL t301_v()
         IF g_coi.coiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_coi.coiconf,"","","",g_void,g_coi.coiacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM coi_file WHERE coi01 = g_coi.coi01
         INITIALIZE g_coi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t301_delall()
#   SELECT COUNT(*) INTO g_cnt FROM coj_file
#       WHERE coj01 = g_coi.coi01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM coi_file WHERE coi01 = g_coi.coi01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
 #No.MOD-490398
FUNCTION t301_coj02(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_item    LIKE coj_file.coj03,
           l_unit    LIKE coj_file.coj06,
           l_price   LIKE coj_file.coj07,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
 
    #檢查合同+商品編號是否經申請
    SELECT coe03,coe06,coe07
      INTO l_item,l_unit,l_price FROM coe_file,coc_file
     WHERE coc01 = coe01
       AND coe02 = g_coj[l_ac].coj02 AND coc03 = g_coi.coi03
        AND coc10 = g_coi.coi05  #No.MOD-490398
       AND cocacti !='N' #010807增
    CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'aco-010'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' THEN
       LET g_coj[l_ac].coj03 = l_item
       LET g_coj[l_ac].coj06 = l_unit
       LET g_coj[l_ac].coj05 = s_digqty(g_coj[l_ac].coj05,g_coj[l_ac].coj06)    #FUN-910088--add--
       LET g_coj[l_ac].coj07 = l_price
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_coj[l_ac].coj03
       DISPLAY BY NAME g_coj[l_ac].coj06
       DISPLAY BY NAME g_coj[l_ac].coj07
       DISPLAY BY NAME g_coj[l_ac].coj05           #FUN-910088--add--
       #------MOD-5A0095 END------------
    END IF
    #檢查商品編號檔
    SELECT cob02 INTO g_coj[l_ac].cob02
      FROM cob_file WHERE cob01 = g_coj[l_ac].coj03
      #------MOD-5A0095 START----------
      DISPLAY BY NAME g_coj[l_ac].cob02
      #------MOD-5A0095 END------------
END FUNCTION
 #No.MOD-490398  --end
 
FUNCTION t301_coj03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_unit    LIKE coj_file.coj06,
           l_price   LIKE coj_file.coj07,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
    #檢查商品編號檔
    SELECT cob02,cobacti INTO g_coj[l_ac].cob02,l_cobacti
      FROM cob_file WHERE cob01 = g_coj[l_ac].coj03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET g_coj[l_ac].cob02 = ' '
                                   LET l_cobacti = NULL
         WHEN l_cobacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    #檢查合同+商品編號是否經申請
    SELECT coe06,coe07
      INTO l_unit,l_price FROM coe_file,coc_file
     WHERE coc01 = coe01
        AND coe03 = g_coj[l_ac].coj03 AND coc03 = g_coi.coi03   #No.MOD-490398
       AND cocacti !='N' #010807增
    CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'aco-010'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' THEN
       LET g_coj[l_ac].coj06 = l_unit
       LET g_coj[l_ac].coj07 = l_price
       DISPLAY g_coj[l_ac].coj06 TO coj06
       DISPLAY g_coj[l_ac].coj07 TO coj07
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_coj[l_ac].cob02 TO cob02
    END IF
END FUNCTION
 
FUNCTION t301_coj06(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_coj[l_ac].coj06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t301_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680069  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON coj02,coj03,coj05,coj06,
                       coj07,coj08               # 螢幕上取單身條件
            FROM s_coj[1].coj02,s_coj[1].coj03,
                 s_coj[1].coj05,s_coj[1].coj06,s_coj[1].coj07,
                 s_coj[1].coj08
 #No.MOD-490398  --begin
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(coj02)  #序號
                    CALL q_coe(TRUE,TRUE,g_coc01,g_coj[1].coj02)
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coj02
                    NEXT FIELD coj02
               WHEN INFIELD(coj03) #料件編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cob"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coj03
                    NEXT FIELD coj03
               WHEN INFIELD(coj06) #詢價單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coj03
                    NEXT FIELD coj06
               OTHERWISE EXIT CASE
            END CASE
 #No.MOD-490398  --end
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
    CALL t301_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t301_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2        LIKE type_file.chr1000       #No.FUN-680069  VARCHAR(200) 
 
    LET g_sql =
        "SELECT coj02,coj03,cob02,coj05,coj06,coj07,coj08, ",
        #No.FUN-840202 --start--
        "       cojud01,cojud02,cojud03,cojud04,cojud05,",
        "       cojud06,cojud07,cojud08,cojud09,cojud10,",
        "       cojud11,cojud12,cojud13,cojud14,cojud15", 
        #No.FUN-840202 ---end---
        "  FROM coj_file LEFT OUTER JOIN cob_file ON coj_file.coj03 = cob_file.cob01",
        " WHERE coj01 ='",g_coi.coi01,"' AND ",  #單頭
    #No.FUN-8B0123---Begin 
        "       coj03 = cob01 "                  #AND ", p_wc2 CLIPPED, #單身
    #   " ORDER BY 1,2"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t301_pb FROM g_sql
    DECLARE coj_cs                       #SCROLL CURSOR
        CURSOR FOR t301_pb
 
    CALL g_coj.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH coj_cs INTO g_coj[g_cnt].*   #單身 ARRAY 填充
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
 
    CALL g_coj.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t301_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_coj TO s_coj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t301_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t301_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t301_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t301_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t301_fetch('L')
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
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #CALL cl_set_field_pic(g_coi.coiconf,"","","","",g_coi.coiacti)  #CHI-C80041
         IF g_coi.coiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_coi.coiconf,"","","",g_void,g_coi.coiacti)  #CHI-C80041
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 出口成品資料查詢
      ON ACTION query_exports
         LET g_action_choice="query_exports"
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
      ON ACTION controls                       # No.FUN-6B0033
       CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t301_update()
 DEFINE l_coi04 LIKE coi_file.coi04
 
   SELECT SUM(coj08) INTO l_coi04 FROM coj_file
    WHERE coj01=g_coi.coi01
   IF cl_null(l_coi04) THEN LET l_coi04 = 0 END IF
   UPDATE coi_file SET coi04=l_coi04
    WHERE coi01=g_coi.coi01
   IF STATUS THEN
#     CALL cl_err('upd coi04:',STATUS,0) #No.TQC-660045
      CALL cl_err3("upd","coi_file",g_coi.coi01,"",STATUS,"","upd coi04:",1) #TQC-660045
      LET g_success='N'
   END IF
   DISPLAY l_coi04 TO coi04
END FUNCTION
 
FUNCTION t301_y()
 DEFINE s_coc01    LIKE coc_file.coc01
 DEFINE l_coj02    LIKE coj_file.coj02
 DEFINE l_coj05    LIKE coj_file.coj05
 DEFINE l_coj08    LIKE coj_file.coj08
   IF g_coi.coi01 IS NULL THEN RETURN END IF
#CHI-C30107 -------- add --------- begin
   IF g_coi.coiconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_coi.coiconf='Y' THEN RETURN END IF
   IF g_coi.coiacti='N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM coj_file
    WHERE coj01 = g_coi.coi01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------- add --------- end
   SELECT * INTO g_coi.* FROM coi_file WHERE coi01=g_coi.coi01
   IF g_coi.coiconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_coi.coiconf='Y' THEN RETURN END IF
   IF g_coi.coiacti='N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
   #no.7377
   SELECT COUNT(*) INTO g_cnt FROM coj_file
    WHERE coj01 = g_coi.coi01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #no.7377(end)
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   #找出原始的申請編號
    #No.MOD-490398
   SELECT coc01 INTO s_coc01
     FROM coc_file
    WHERE coc03 = g_coi.coi03
      AND coc10 = g_coi.coi05
      AND cocacti !='N' #010807增
    #No.MOD-490398 end
   IF cl_null(s_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1) RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t301_cl USING g_coi.coi01
   IF STATUS THEN
      CALL cl_err("OPEN t301_cl:", STATUS, 1)
      CLOSE t301_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t301_cl INTO g_coi.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   #回寫加簽數量,金額
   DECLARE firm_cs CURSOR FOR
    SELECT coj02,coj05,coj08 FROM coj_file WHERE coj01 = g_coi.coi01
   FOREACH firm_cs INTO l_coj02,l_coj05,l_coj08
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
 
      UPDATE coe_file SET coe10 = (coe10+l_coj05),
                          coe08 = (coe08+l_coj08)
       WHERE coe01 = s_coc01 AND coe02=l_coj02
      IF STATUS THEN
#        CALL cl_err('upd coe10:',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","coe_file",s_coc01,l_coj02,STATUS,"","upd coe10:",1) #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
      UPDATE coc_file SET coc08 = (coc08 + l_coj08)
       WHERE coc01 = s_coc01
      IF STATUS THEN
#        CALL cl_err('upd coc08:',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","coc_file",s_coc01,"",STATUS,"","upd coc08:",1) #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
 
   END FOREACH
   UPDATE coi_file SET coiconf='Y'
    WHERE coi01 = g_coi.coi01
   IF STATUS THEN
#     CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
      CALL cl_err3("upd","coi_file",g_coi.coi01,"",STATUS,"","cofconf",1) #TQC-660045
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_coi.coi01,'Y')
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT coiconf INTO g_coi.coiconf FROM coi_file
    WHERE coi01 = g_coi.coi01
   DISPLAY BY NAME g_coi.coiconf
   #CALL cl_set_field_pic(g_coi.coiconf,"","","","",g_coi.coiacti)  #CHI-C80041
   IF g_coi.coiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_coi.coiconf,"","","",g_void,g_coi.coiacti)  #CHI-C80041
END FUNCTION
 
FUNCTION t301_z()
 DEFINE s_coc01    LIKE coc_file.coc01
 DEFINE l_coj02    LIKE coj_file.coj02
 DEFINE l_coj05    LIKE coj_file.coj05
 DEFINE l_coj08    LIKE coj_file.coj08
   IF g_coi.coi01 IS NULL THEN RETURN END IF
   SELECT * INTO g_coi.* FROM coi_file WHERE coi01=g_coi.coi01
   IF g_coi.coiconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_coi.coiconf='N' THEN RETURN END IF
   IF g_coi.coiacti='N' THEN RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   #找出原始的申請編號
    #No.MOD-490398
   SELECT coc01 INTO s_coc01 FROM coc_file
    WHERE coc03 = g_coi.coi03
      AND coc10 = g_coi.coi05
      AND cocacti !='N' #010807增
    #No.MOD-490398  end
   IF cl_null(s_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1) RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t301_cl USING g_coi.coi01
   IF STATUS THEN
      CALL cl_err("OPEN t301_cl:", STATUS, 1)
      CLOSE t301_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t301_cl INTO g_coi.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   #回寫加簽數量
   DECLARE unfirm_cs CURSOR FOR
    SELECT coj02,coj05,coj08 FROM coj_file WHERE coj01 = g_coi.coi01
   FOREACH unfirm_cs INTO l_coj02,l_coj05,l_coj08
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
 
      UPDATE coe_file SET coe10 = (coe10-l_coj05),
                          coe08 = (coe08-l_coj08)
       WHERE coe01 = s_coc01 AND coe02=l_coj02
      IF STATUS THEN
#        CALL cl_err('upd coe10:',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","coe_file",s_coc01,l_coj02,STATUS,"","upd coe10:",1) #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
      UPDATE coc_file SET coc08 = (coc08 - l_coj08)
       WHERE coc01 = s_coc01
      IF STATUS THEN
#        CALL cl_err('upd coc08:',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","coc_file",s_coc01,"",STATUS,"","upd coc08:",1) #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
 
   END FOREACH
   UPDATE coi_file SET coiconf='N'
    WHERE coi01 = g_coi.coi01
   IF STATUS THEN
#     CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
      CALL cl_err3("upd","coi_file",g_coi.coi01,"",STATUS,"","upd cofconf",1) #TQC-660045
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT coiconf INTO g_coi.coiconf FROM coi_file
    WHERE coi01 = g_coi.coi01
   DISPLAY BY NAME g_coi.coiconf
   #CALL cl_set_field_pic(g_coi.coiconf,"","","","",g_coi.coiacti)  #CHI-C80041
   IF g_coi.coiconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_coi.coiconf,"","","",g_void,g_coi.coiacti)  #CHI-C80041
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002> #
#Patch....NO.TQC-610035 <001> #
#CHI-C80041---begin
FUNCTION t301_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_coi.coi01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t301_cl USING g_coi.coi01
   IF STATUS THEN
      CALL cl_err("OPEN t301_cl:", STATUS, 1)
      CLOSE t301_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t301_cl INTO g_coi.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_coi.coi01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t301_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_coi.coiconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_coi.coiconf)   THEN 
        LET l_chr=g_coi.coiconf
        IF g_coi.coiconf='N' THEN 
            LET g_coi.coiconf='X' 
        ELSE
            LET g_coi.coiconf='N'
        END IF
        UPDATE coi_file
            SET coiconf=g_coi.coiconf,  
                coimodu=g_user,
                coidate=g_today
            WHERE coi01=g_coi.coi01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","coi_file",g_coi.coi01,"",SQLCA.sqlcode,"","",1)  
            LET g_coi.coiconf=l_chr 
        END IF
        DISPLAY BY NAME g_coi.coiconf 
   END IF
 
   CLOSE t301_cl
   COMMIT WORK
   CALL cl_flow_notify(g_coi.coi01,'V')
 
END FUNCTION
#CHI-C80041---end
