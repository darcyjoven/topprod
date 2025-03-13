# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot300.4gl
# Descriptions...: 出口成品加簽與減量異動作業
# Date & Author..: 00/06/05 By Kammy
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/16 By Carrier add cog05
# Modify.........: No.FUN-550036 05/05/24 By Trisy 單據編號加大
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630014 06/03/07 By Carol 流程訊息通知功能
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740287 07/04/30 By Carol 單身單身資料時先按新增後再按放棄原畫面的單身資料不被清空
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7C0140 07/12/20 By Carol 單身修改時應重新顯示品名
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/08 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
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
    g_cog           RECORD LIKE cog_file.*,       #單頭
    g_cog_t         RECORD LIKE cog_file.*,       #單頭(舊值)
    g_cog_o         RECORD LIKE cog_file.*,       #單頭(舊值)
    g_cog01_t       LIKE cog_file.cog01,          #單頭 (舊值)
    g_cog03_t       LIKE cog_file.cog01,          #手冊編號
    g_cog05_t       LIKE cog_file.cog01,          #customer   #No.MOD-490398
    g_t1            LIKE oay_file.oayslip,        #No.FUN-550036        #No.FUN-680069  VARCHAR(05)
    g_coh           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        coh02       LIKE coh_file.coh02,          #項次
        coh03       LIKE coh_file.coh03,   #商品編號
        cob02       LIKE cob_file.cob02,   #
        coh041      LIKE coh_file.coh041,  #BOM版本編號
        coh05       LIKE coh_file.coh05,   #
        coh06       LIKE coh_file.coh06,   #
        coh07       LIKE coh_file.coh07,   #
        coh08       LIKE coh_file.coh08,   #
        #FUN-840202 --start---
        cohud01     LIKE coh_file.cohud01,
        cohud02     LIKE coh_file.cohud02,
        cohud03     LIKE coh_file.cohud03,
        cohud04     LIKE coh_file.cohud04,
        cohud05     LIKE coh_file.cohud05,
        cohud06     LIKE coh_file.cohud06,
        cohud07     LIKE coh_file.cohud07,
        cohud08     LIKE coh_file.cohud08,
        cohud09     LIKE coh_file.cohud09,
        cohud10     LIKE coh_file.cohud10,
        cohud11     LIKE coh_file.cohud11,
        cohud12     LIKE coh_file.cohud12,
        cohud13     LIKE coh_file.cohud13,
        cohud14     LIKE coh_file.cohud14,
        cohud15     LIKE coh_file.cohud15
        #FUN-840202 --end--
                    END RECORD,
    g_coh_t         RECORD                 #程式變數 (舊值)
        coh02       LIKE coh_file.coh02,   #項次
        coh03       LIKE coh_file.coh03,   #商品編號
        cob02       LIKE cob_file.cob02,    #
        coh041      LIKE coh_file.coh041,  #BOM版本編號
        coh05       LIKE coh_file.coh05,   #
        coh06       LIKE coh_file.coh06,   #
        coh07       LIKE coh_file.coh07,   #
        coh08       LIKE coh_file.coh08,   #
        #FUN-840202 --start---
        cohud01     LIKE coh_file.cohud01,
        cohud02     LIKE coh_file.cohud02,
        cohud03     LIKE coh_file.cohud03,
        cohud04     LIKE coh_file.cohud04,
        cohud05     LIKE coh_file.cohud05,
        cohud06     LIKE coh_file.cohud06,
        cohud07     LIKE coh_file.cohud07,
        cohud08     LIKE coh_file.cohud08,
        cohud09     LIKE coh_file.cohud09,
        cohud10     LIKE coh_file.cohud10,
        cohud11     LIKE coh_file.cohud11,
        cohud12     LIKE coh_file.cohud12,
        cohud13     LIKE coh_file.cohud13,
        cohud14     LIKE coh_file.cohud14,
        cohud15     LIKE coh_file.cohud15
        #FUN-840202 --end--
                    END RECORD,
    g_coh_o         RECORD                 #程式變數 (舊值)
        coh02       LIKE coh_file.coh02,   #項次
        coh03       LIKE coh_file.coh03,   #商品編號
        cob02       LIKE cob_file.cob02,    #
        coh041      LIKE coh_file.coh041,  #BOM版本編號
        coh05       LIKE coh_file.coh05,   #
        coh06       LIKE coh_file.coh06,   #
        coh07       LIKE coh_file.coh07,   #
        coh08       LIKE coh_file.coh08,   #
        #FUN-840202 --start---
        cohud01     LIKE coh_file.cohud01,
        cohud02     LIKE coh_file.cohud02,
        cohud03     LIKE coh_file.cohud03,
        cohud04     LIKE coh_file.cohud04,
        cohud05     LIKE coh_file.cohud05,
        cohud06     LIKE coh_file.cohud06,
        cohud07     LIKE coh_file.cohud07,
        cohud08     LIKE coh_file.cohud08,
        cohud09     LIKE coh_file.cohud09,
        cohud10     LIKE coh_file.cohud10,
        cohud11     LIKE coh_file.cohud11,
        cohud12     LIKE coh_file.cohud12,
        cohud13     LIKE coh_file.cohud13,
        cohud14     LIKE coh_file.cohud14,
        cohud15     LIKE coh_file.cohud15
        #FUN-840202 --end--
                    END RECORD,
    g_coc01         LIKE coc_file.coc01,   #合同申請單號
    g_argv1         LIKE cnp_file.cnp01,   #詢價單號
    g_argv2         STRING,                #No.FUN-680069   #FUN-630014 指定執行的功能
    g_wc,g_wc2,g_sql    STRING,            #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   #No.FUN-680069
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1              #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10             #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5              #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000           #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10              #No.FUN-680069 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10              #No.FUN-680069 INTEGER
 
DEFINE   g_jump          LIKE type_file.num10              #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5              #No.FUN-680069 SMALLINT
DEFINE   g_void          LIKE type_file.chr1              #CHI-C80041

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5                  #No.FUN-680069 SMALLINT
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
 
    LET g_forupd_sql = " SELECT * FROM cog_file WHERE cog01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t300_w AT p_row,p_col
        WITH FORM "aco/42f/acot300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-630014 mark 
   #IF g_argv1 IS NOT NULL AND g_argv1 != ' '
   #   THEN CALL t300_q()
   #END IF
   #FUN-630014 mark --end 
 
   #FUN-630014 --start--
   # 先以g_argv2判斷直接執行哪種功能
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t300_a()
            END IF
         OTHERWISE
            CALL t300_q()
      END CASE
   END IF
   #FUN-630014 ---end---
 
   CALL t300_menu()
   CLOSE WINDOW t300_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t300_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_coh.clear()
 
  IF NOT cl_null(g_argv1) THEN             #FUN-630014 modify
     LET g_wc = " cog01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
     CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_cog.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
         cog01,cog02,cog05,cog03,          #No.MOD-490398
         cogconf,cog04,coguser,coggrup,cogmodu,cogdate,cogacti,
         #FUN-840202   ---start---
         cogud01,cogud02,cogud03,cogud04,cogud05,
         cogud06,cogud07,cogud08,cogud09,cogud10,
         cogud11,cogud12,cogud13,cogud14,cogud15
         #FUN-840202    ----end----
 
        #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(cog01) #單別
                    #CALL q_coy( FALSE, TRUE,g_cog.cog01,'12',g_sys)  #TQC-670008
                    CALL q_coy( FALSE, TRUE,g_cog.cog01,'12','ACO')   #TQC-670008
                         RETURNING g_cog.cog01
                    DISPLAY BY NAME g_cog.cog01
                    NEXT FIELD cog01
                #No.MOD-490398
               WHEN INFIELD(cog05)  #customer
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_cna"
                 LET g_qryparam.default1 = g_cog.cog05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cog05
                 NEXT FIELD cog05
               WHEN INFIELD(cog03) #手冊編號
                 CALL q_coc2(TRUE,TRUE,g_cog.cog03,'',
                             g_cog.cog02,'0',g_cog.cog05,'')
                      RETURNING g_cog.cog03
                 DISPLAY BY NAME g_cog.cog03
                 NEXT FIELD cog03
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
 
    CONSTRUCT g_wc2 ON coh02,coh03,coh041,coh05,   #螢幕上取單身條件
                       coh06,coh07,coh08
                       #No.FUN-840202 --start--
                       ,cohud01,cohud02,cohud03,cohud04,cohud05
                       ,cohud06,cohud07,cohud08,cohud09,cohud10
                       ,cohud11,cohud12,cohud13,cohud14,cohud15
                       #No.FUN-840202 ---end---
            FROM s_coh[1].coh02,s_coh[1].coh03,s_coh[1].coh041,
                 s_coh[1].coh05,s_coh[1].coh06,s_coh[1].coh07,s_coh[1].coh08
                 #No.FUN-840202 --start--
                 ,s_coh[1].cohud01,s_coh[1].cohud02,s_coh[1].cohud03
                 ,s_coh[1].cohud04,s_coh[1].cohud05,s_coh[1].cohud06
                 ,s_coh[1].cohud07,s_coh[1].cohud08,s_coh[1].cohud09
                 ,s_coh[1].cohud10,s_coh[1].cohud11,s_coh[1].cohud12
                 ,s_coh[1].cohud13,s_coh[1].cohud14,s_coh[1].cohud15
                 #No.FUN-840202 ---end---
 
      #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
	   CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
            CASE
               WHEN INFIELD(coh02)  #序號
                    CALL q_cod(TRUE,TRUE,g_coc01,g_coh[1].coh02)
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coh02
                    NEXT FIELD coh02
               WHEN INFIELD(coh03) #料件編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_cob"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coh03
                    NEXT FIELD coh03
               WHEN INFIELD(coh06) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coh06
                    NEXT FIELD coh06
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
 
  LET g_wc = g_wc clipped," AND coguser = '",g_user,"'"
  
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND coguser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND coggrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND coggrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('coguser', 'coggrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT cog01 FROM cog_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY cog01 "
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cog01 ",
                   "  FROM cog_file, coh_file ",
                   " WHERE cog01 = coh01 ",
                   "   AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
                   " ORDER BY cog01 "
    END IF
 
    PREPARE t300_prepare FROM g_sql
    DECLARE t300_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t300_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cog_file WHERE ", g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cog_file,coh_file WHERE ",
                  "coh01=cog01 AND ", g_wc CLIPPED ," AND ", g_wc2 CLIPPED
    END IF
    PREPARE t300_precount FROM g_sql
    DECLARE t300_count CURSOR FOR t300_precount
END FUNCTION
 
FUNCTION t300_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069  VARCHAR(100)
 
   WHILE TRUE
      CALL t300_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t300_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t300_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t300_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t300_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t300_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_coh),'','')
             END IF
         #--
 
         WHEN "mntn_imports"
            IF cl_chk_act_auth() THEN
               CALL s_ins_coj(g_cog.cog01,0)
               LET l_cmd="acot301 '",g_cog.cog01,"' 'query'"
               #CALL cl_cmdrun(l_cmd)      #FUN-660216 remark
               CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t300_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t300_z()
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cog.cog01 IS NOT NULL THEN
                 LET g_doc.column1 = "cog01"
                 LET g_doc.value1 = g_cog.cog01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t300_v()
               IF g_cog.cogconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cog.cogconf,"","","",g_void,g_cog.cogacti)
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t300_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
    MESSAGE ""
    CLEAR FORM
    CALL g_coh.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cog.* LIKE cog_file.*             #DEFAULT 設置
    LET g_cog01_t = NULL
    LET g_cog05_t = NULL    #No.MOD-490398
    LET g_cog03_t = NULL
    LET g_cog_t.* = g_cog.*
    LET g_cog_o.* = g_cog.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cog.cog04 = 0
        LET g_cog.cog02 = g_today
        LET g_cog.cog05 = g_coz.coz02            #No.MOD-490398
        LET g_cog.cogconf='N'
        LET g_cog.coguser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_cog.coggrup=g_grup
        LET g_cog.cogdate=g_today
        LET g_cog.cogacti='Y'              #資料有效
        LET g_cog.cogplant = g_plant  #FUN-980002
        LET g_cog.coglegal = g_legal  #FUN-980002
 
        BEGIN WORK
        CALL t300_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_cog.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cog.cog01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
      #No.FUN-550036 --start--
#       IF cl_null(g_cog.cog01[5,10]) THEN              #自動編號
#       IF cl_null(g_cog.cog01[g_no_sp,g_no_ep]) THEN              #自動編號
#          CALL s_acoauno(g_cog.cog01,g_cog.cog02,'12')
#            RETURNING g_i,g_cog.cog01
#          IF g_i THEN CONTINUE WHILE END IF
      CALL s_auto_assign_no("aco",g_cog.cog01,g_cog.cog02,"12","cog_file","cog01","","","")
        RETURNING li_result,g_cog.cog01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      #No.FUN-550036 ---end---
           DISPLAY BY NAME g_cog.cog01
#       END IF
        LET g_cog.cogoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cog.cogorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cog_file VALUES (g_cog.*)
#       LET g_t1 = g_cog.cog01[1,3]           #備份上一筆單別
        LET g_t1 = s_get_doc_no(g_cog.cog01)  #No.FUN-550036
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
#           CALL cl_err(g_cog.cog01,SQLCA.sqlcode,1) #No.TQC-660045
            CALL cl_err3("ins","cog_file",g_cog.cog01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_cog.cog01,'I')
        SELECT cog01 INTO g_cog.cog01 FROM cog_file
            WHERE cog01 = g_cog.cog01
        LET g_cog01_t = g_cog.cog01        #保留舊值
        LET g_cog03_t = g_cog.cog03        #保留舊值
         LET g_cog05_t = g_cog.cog05        #保留舊值  #No.MOD-490398
        LET g_cog_t.* = g_cog.*
        LET g_cog_o.* = g_cog.*
        FOR g_cnt = 1 TO g_coh.getLength()
            INITIALIZE g_coh[g_cnt].* TO NULL
        END FOR
        LET g_rec_b=0
        CALL t300_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t300_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cog.cog01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cog.* FROM cog_file WHERE cog01=g_cog.cog01
    IF g_cog.cogacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cog.cog01,'mfg1000',0)
        RETURN
    END IF
    IF g_cog.cogconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cog.cogconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_cog.cog01,'axm-101',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cog01_t = g_cog.cog01
     LET g_cog05_t = g_cog.cog05        #No.MOD-490398
    LET g_cog03_t = g_cog.cog03
    BEGIN WORK
 
    OPEN t300_cl USING g_cog.cog01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_cog.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t300_cl
        RETURN
    END IF
    CALL t300_show()
    WHILE TRUE
        LET g_cog01_t = g_cog.cog01
         LET g_cog05_t = g_cog.cog05       #No.MOD-490398
        LET g_cog03_t = g_cog.cog03
        LET g_cog_o.* = g_cog.*
        LET g_cog.cogmodu=g_user
        LET g_cog.cogdate=g_today
        CALL t300_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cog.*=g_cog_t.*
            CALL t300_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cog.cog01 != g_cog01_t THEN            # 更改單號
            UPDATE coh_file SET coh01 = g_cog.cog01
                WHERE coh01 = g_cog01_t
            IF SQLCA.sqlcode THEN
#              CALL cl_err('coh',SQLCA.sqlcode,0)  #No.TQC-660045
               CALL cl_err3("upd","coh_file",g_cog01_t,"",SQLCA.sqlcode,"","coh",1)  #TQC-660045
               CONTINUE WHILE
            END IF
        END IF
        UPDATE cog_file SET cog_file.* = g_cog.*
            WHERE cog01 = g_cog01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cog_file",g_cog01_t,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t300_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cog.cog01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t300_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_coc04   LIKE coc_file.coc04,            #No.MOD-490398
    l_n		LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    p_cmd           LIKE type_file.chr1       #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
DEFINE   li_result  LIKE type_file.num5       #No.FUN-550036        #No.FUN-680069 SMALLINT
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
        g_cog.cog01,g_cog.cog02,g_cog.cog03,g_cog.cog05,    #No.MOD-490398
        g_cog.cogconf,g_cog.cog04,g_cog.coguser,
        g_cog.coggrup,g_cog.cogmodu,g_cog.cogdate,g_cog.cogacti
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
    INPUT BY NAME
        g_cog.cog01,g_cog.cog02,g_cog.cog05,g_cog.cog03,   #No.MOD-490398
        g_cog.cogconf,g_cog.cog04,g_cog.coguser,
        g_cog.coggrup,g_cog.cogmodu,g_cog.cogdate,g_cog.cogacti,
        #FUN-840202     ---start---
        g_cog.cogud01,g_cog.cogud02,g_cog.cogud03,g_cog.cogud04,
        g_cog.cogud05,g_cog.cogud06,g_cog.cogud07,g_cog.cogud08,
        g_cog.cogud09,g_cog.cogud10,g_cog.cogud11,g_cog.cogud12,
        g_cog.cogud13,g_cog.cogud14,g_cog.cogud15 
        #FUN-840202     ----end----
                      WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t300_set_entry(p_cmd)
            CALL t300_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("cog01")
         #No.FUN-550036 ---end---
 
        AFTER FIELD cog01
         #No.FUN-550036 --start--
         IF NOT cl_null(g_cog.cog01) THEN
            CALL s_check_no("aco",g_cog.cog01,g_cog01_t,"12","cog_file","cog01","")
            RETURNING li_result,g_cog.cog01
            DISPLAY BY NAME g_cog.cog01
            IF (NOT li_result) THEN
               LET g_cog.cog01=g_cog_o.cog01
               NEXT FIELD cog01
            END IF
 
#           IF NOT cl_null(g_cog.cog01) THEN
#              LET g_t1=g_cog.cog01[1,3]
#              CALL s_acoslip(g_t1,'12',g_sys)           #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cog.cog01=g_cog_o.cog01
#                 NEXT FIELD cog01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cog.cog01[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_cog.cog01[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD cog01
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD cog02			 #輸入
# 	             END IF
#           END IF
#           IF g_cog.cog01[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_cog.cog01[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_cog.cog01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD cog01
#                     END IF
#                  END IF
#              END IF
 
#              IF g_cog.cog01 != g_cog01_t OR g_cog01_t IS NULL THEN
#                  SELECT count(*) INTO l_n FROM cog_file
#                      WHERE cog01 = g_cog.cog01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_cog.cog01,-239,0)
#                      LET g_cog.cog01 = g_cog01_t
#                      DISPLAY BY NAME g_cog.cog01
#                      NEXT FIELD cog01
#                  END IF
#              END IF
            END IF
         #No.FUN-550036 ---end---
 
        #No.MOD-490398
        AFTER FIELD cog05                         #customer
            IF g_cog.cog05 IS NULL THEN LET g_cog.cog05 = ' ' END IF
            IF NOT cl_null(g_cog.cog05) THEN
               CALL t300_cog05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cog.cog05,g_errno,0)
                  NEXT FIELD cog05
               END IF
            END IF
        #No.MOD-490398 end
 
        AFTER FIELD cog03
            IF NOT cl_null(g_cog.cog03) THEN
               CALL t300_cog03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD cog03
               END IF
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(cog01) #單別
                    #CALL q_coy( FALSE, TRUE,g_cog.cog01,'12',g_sys) #TQC-670008
                    CALL q_coy( FALSE, TRUE,g_cog.cog01,'12','ACO')  #TQC-670008
                               RETURNING g_cog.cog01
#                    CALL FGL_DIALOG_SETBUFFER( g_cog.cog01 )
                    DISPLAY BY NAME g_cog.cog01
                    NEXT FIELD cog01
               #No.MOD-490398 --begin
               WHEN INFIELD(cog05)      #custom
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_cna"
                    LET g_qryparam.default1 = g_cog.cog05
                    CALL cl_create_qry() RETURNING g_cog.cog05
                    DISPLAY BY NAME g_cog.cog05
                    NEXT FIELD cog05
               WHEN INFIELD(cog03) #手冊編號
                 CALL q_coc2(FALSE,FALSE,g_cog.cog03,'',
                             g_cog.cog02,'0',g_cog.cog05,'')
                      RETURNING g_cog.cog03,l_coc04
                 DISPLAY BY NAME g_cog.cog03
                 NEXT FIELD cog03
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
FUNCTION t300_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("cog01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t300_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cog01",FALSE)
    END IF
END FUNCTION
 
 #No.MOD-490398
FUNCTION t300_cog05(p_cmd)  #
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file WHERE cna01 = g_cog.cog05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
         WHEN l_cnaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 #No.MOD-490398 end
 
 #No.MOD-490398
FUNCTION t300_cog03(p_cmd)  #手冊編號
    DEFINE l_coc02   LIKE coc_file.coc02,
           l_coc04   LIKE coc_file.coc04,
           l_coc05   LIKE coc_file.coc05,
           l_coc07   LIKE coc_file.coc07,
           l_cocacti LIKE coc_file.cocacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT coc01,coc02,coc04,coc05,coc07,cocacti
      INTO g_coc01,l_coc02,l_coc04,l_coc05,l_coc07,l_cocacti
      FROM coc_file WHERE coc03 = g_cog.cog03 AND coc10 = g_cog.cog05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-005'
                                   LET l_coc02 = NULL
                                   LET l_coc04 = NULL
                                   LET l_coc07 = NULL
         WHEN l_cocacti='N' LET g_errno = '9028'
         WHEN l_coc05 < g_today    LET g_errno = 'aco-056'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(l_coc07) THEN LET g_errno='aco-057' END IF
    DISPLAY l_coc02 TO FORMONLY.coc02
    DISPLAY l_coc04 TO FORMONLY.coc04
END FUNCTION
 #No.MOD-490398 end
 
#Query 查詢
FUNCTION t300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cog.* TO NULL             #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_coh.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t300_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cog.* TO NULL
        RETURN
    END IF
    OPEN t300_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cog.* TO NULL
    ELSE
        OPEN t300_count
        FETCH t300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式          #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t300_cs INTO g_cog.cog01
        WHEN 'P' FETCH PREVIOUS t300_cs INTO g_cog.cog01
        WHEN 'F' FETCH FIRST    t300_cs INTO g_cog.cog01
        WHEN 'L' FETCH LAST     t300_cs INTO g_cog.cog01
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
         FETCH ABSOLUTE g_jump t300_cs INTO g_cog.cog01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0)
        INITIALIZE g_cog.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_cog.* FROM cog_file WHERE cog01 = g_cog.cog01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cog_file",g_cog.cog01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
        INITIALIZE g_cog.* TO NULL
        RETURN
    END IF
 
    CALL t300_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t300_show()
    LET g_cog_t.* = g_cog.*                #保存單頭舊值
    LET g_cog_o.* = g_cog.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
 
        g_cog.cog01,g_cog.cog02,g_cog.cog03,g_cog.cog04,g_cog.cog05,   #No.MOD-490398
        g_cog.cogconf,g_cog.coguser,
        g_cog.coggrup,g_cog.cogmodu,g_cog.cogdate,g_cog.cogacti,
        #FUN-840202     ---start---
        g_cog.cogud01,g_cog.cogud02,g_cog.cogud03,g_cog.cogud04,
        g_cog.cogud05,g_cog.cogud06,g_cog.cogud07,g_cog.cogud08,
        g_cog.cogud09,g_cog.cogud10,g_cog.cogud11,g_cog.cogud12,
        g_cog.cogud13,g_cog.cogud14,g_cog.cogud15 
        #FUN-840202     ----end----
 
    #CALL cl_set_field_pic(g_cog.cogconf,"","","","",g_cog.cogacti)  #CHI-C80041
    IF g_cog.cogconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cog.cogconf,"","","",g_void,g_cog.cogacti)   #CHI-C80041
    CALL t300_cog03('d')
    CALL t300_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t300_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cog.cog01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t300_cl USING g_cog.cog01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_cog.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    IF g_cog.cogconf='Y' THEN RETURN END IF
    CALL t300_show()
    IF cl_exp(0,0,g_cog.cogacti) THEN                   #審核一下
        LET g_chr=g_cog.cogacti
        IF g_cog.cogacti='Y' THEN
            LET g_cog.cogacti='N'
        ELSE
            LET g_cog.cogacti='Y'
        END IF
        UPDATE cog_file                    #更改有效碼
            SET cogacti=g_cog.cogacti
            WHERE cog01=g_cog.cog01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cog_file",g_cog.cog01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            LET g_cog.cogacti=g_chr
        END IF
        DISPLAY BY NAME g_cog.cogacti
    END IF
    CLOSE t300_cl
    COMMIT WORK
 
    #CALL cl_set_field_pic(g_cog.cogconf,"","","","",g_cog.cogacti)  #CHI-C80041
    IF g_cog.cogconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cog.cogconf,"","","",g_void,g_cog.cogacti)   #CHI-C80041
    CALL cl_flow_notify(g_cog.cog01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t300_r()
 DEFINE l_i LIKE type_file.num5          #No.FUN-680069 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    IF g_cog.cog01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    SELECT * INTO g_cog.* FROM cog_file WHERE cog01=g_cog.cog01
    IF g_cog.cogacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cog.cog01,'mfg1000',0)
        RETURN
    END IF
    IF g_cog.cogconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cog.cogconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_cog.cog01,'axm-101',0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t300_cl USING g_cog.cog01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_cog.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t300_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cog01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cog.cog01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM cog_file WHERE cog01 = g_cog.cog01
            DELETE FROM coh_file WHERE coh01 = g_cog.cog01
 
            SELECT COUNT(*) INTO l_i FROM cng_file
             WHERE cng10 = g_cog.cog01
            IF l_i > 0 THEN
               UPDATE cng_file SET cng03='',
                                   cng04='',
                                   cng05='',
                                   cng06='',
                                   cng07='',
                                    cng12='',  #No.MOD-490398 By carrier
                                   cng10=''
                WHERE cng10 = g_cog.cog01
            END IF
            #####
        #No.MOD-490398
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980002 add azoplant,azolegal
          VALUES ('acot300',g_user,g_today,g_msg,g_cog.cog01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
        #No.MOD-490398 end
            CLEAR FORM
            CALL g_coh.clear()
 
         OPEN t300_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t300_cs
            CLOSE t300_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t300_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t300_cs
            CLOSE t300_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t300_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t300_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t300_fetch('/')
         END IF
    END IF
    CLOSE t300_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cog.cog01,'D')
END FUNCTION
 
#單身
FUNCTION t300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT     #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cog.cog01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cog.* FROM cog_file WHERE cog01=g_cog.cog01
    IF g_cog.cogacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cog.cog01,'mfg1000',0)
        RETURN
    END IF
    IF g_cog.cogconf='Y' THEN RETURN END IF
    IF g_cog.cogconf='X' THEN RETURN END IF  #CHI-C80041
    LET g_success='Y'
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT coh02,coh03,'',coh041,coh05,coh06,coh07,coh08, ",
                       #No.FUN-840202 --start--
                       "        cohud01,cohud02,cohud03,cohud04,cohud05,",
                       "        cohud06,cohud07,cohud08,cohud09,cohud10,",
                       "        cohud11,cohud12,cohud13,cohud14,cohud15 ", 
                       #No.FUN-840202 ---end---
                       "   FROM coh_file ",
                       "  WHERE coh01=? AND coh02=? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_coh.clear() END IF
 
        INPUT ARRAY g_coh WITHOUT DEFAULTS FROM s_coh.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
 
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t300_cl USING g_cog.cog01
            IF STATUS THEN
               CALL cl_err("OPEN t300_cl:", STATUS, 1)
               CLOSE t300_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t300_cl INTO g_cog.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t300_cl
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_coh_t.* = g_coh[l_ac].*  #BACKUP
                LET g_coh_o.* = g_coh[l_ac].*  #BACKUP
                OPEN t300_bcl USING g_cog.cog01,g_coh_t.coh02
                IF STATUS THEN
                   CALL cl_err("OPEN t300_bcl:", STATUS, 1)
                   CLOSE t300_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t300_bcl INTO g_coh[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_coh_t.coh02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL t300_coh02('d')     #MOD-7C0140-add
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
           #NEXT FIELD coh02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_coh[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_coh[l_ac].* TO s_coh.*
              CALL g_coh.deleteElement(l_ac)    #TQC-740287 moidfy g_rec_b+1 -> l_ac
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO coh_file(coh01,coh02,coh03,coh041,
                                 coh04,coh05,coh06,coh07,coh08,    #No.MOD-490398
                                 #FUN-840202 --start--
                                 cohud01,cohud02,cohud03,cohud04,cohud05,
                                 cohud06,cohud07,cohud08,cohud09,cohud10,
                                 #cohud11,cohud12,cohud13,cohud14,cohud15) #FUN-980002
                                 #FUN-840202 --end--
                                 cohud11,cohud12,cohud13,cohud14,cohud15,  #FUN-980002
                                 cohplant,cohlegal) #FUN-980002
            VALUES(g_cog.cog01,g_coh[l_ac].coh02,
                   g_coh[l_ac].coh03,
                   g_coh[l_ac].coh041,g_cog.cog05,g_coh[l_ac].coh05,  #No.MOD-490398
                   g_coh[l_ac].coh06,g_coh[l_ac].coh07,
                   g_coh[l_ac].coh08,
                   #FUN-840202 --start--
                   g_coh[l_ac].cohud01,g_coh[l_ac].cohud02,g_coh[l_ac].cohud03,
                   g_coh[l_ac].cohud04,g_coh[l_ac].cohud05,g_coh[l_ac].cohud06,
                   g_coh[l_ac].cohud07,g_coh[l_ac].cohud08,g_coh[l_ac].cohud09,
                   g_coh[l_ac].cohud10,g_coh[l_ac].cohud11,g_coh[l_ac].cohud12,
                   #g_coh[l_ac].cohud13,g_coh[l_ac].cohud14,g_coh[l_ac].cohud15) #FUN-980002
                   #FUN-840202 --end--
                   g_coh[l_ac].cohud13,g_coh[l_ac].cohud14,g_coh[l_ac].cohud15,  #FUN-980002
                   g_plant,g_legal) #FUN-980002
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_coh[l_ac].coh02,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","coh_file",g_cog.cog01,g_coh[l_ac].coh02,SQLCA.sqlcode,"","",1)  #TQC-660045
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                CALL t300_update()
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
 
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_coh[l_ac].* TO NULL       #900423
            LET g_coh[l_ac].coh05 = 0              #Body default
            LET g_coh[l_ac].coh07 = 0              #Body default
            LET g_coh[l_ac].coh08 = 0              #Body default
            LET g_coh_t.* = g_coh[l_ac].*          #新輸入資料
            LET g_coh_o.* = g_coh[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD coh02
 
        BEFORE FIELD coh05                        #check 序號是否重複
            IF NOT cl_null(g_coh[l_ac].coh02) THEN
               IF g_coh[l_ac].coh02 != g_coh_t.coh02 OR
                  g_coh_t.coh02 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM coh_file
                       WHERE coh01 = g_cog.cog01 AND
                             coh02 = g_coh[l_ac].coh02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_coh[l_ac].coh02 = g_coh_t.coh02
                       NEXT FIELD coh02
                   END IF
                   CALL t300_coh02('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_coh[l_ac].coh02,g_errno,0)
                      LET g_coh[l_ac].coh02 = g_coh_o.coh02
                      DISPLAY g_coh[l_ac].coh02 TO coh02
                      NEXT FIELD coh02
                   END IF
               END IF
            END IF
 
        AFTER FIELD coh05
           IF NOT cl_null(g_coh[l_ac].coh05) THEN
              IF g_coh[l_ac].coh05 = 0 THEN
                  NEXT FIELD coh05
              END IF
              LET g_coh[l_ac].coh05 = s_digqty(g_coh[l_ac].coh05,g_coh[l_ac].coh06)   #FUN-910088--add--
              DISPLAY BY NAME g_coh[l_ac].coh05                                       #FUN-910088--add--
           END IF
           LET g_coh[l_ac].coh08 = g_coh[l_ac].coh07 * g_coh[l_ac].coh05
           DISPLAY g_coh[l_ac].coh08 TO coh08
 
        #No.FUN-840202 --start--
        AFTER FIELD cohud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cohud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_coh_t.coh02 > 0 AND
               g_coh_t.coh02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM coh_file
                      WHERE coh01 = g_cog.cog01 AND
                            coh02 = g_coh_t.coh02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_coh_t.coh02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","coh_file",g_cog.cog01,g_coh_t.coh02,SQLCA.sqlcode,"","",1)  #TQC-660045
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
            CALL t300_update()
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_coh[l_ac].* = g_coh_t.*
               CLOSE t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_coh[l_ac].coh02,-263,1)
               LET g_coh[l_ac].* = g_coh_t.*
            ELSE
               UPDATE coh_file SET coh02=g_coh[l_ac].coh02,
                                   coh03=g_coh[l_ac].coh03,
                                   coh041=g_coh[l_ac].coh041,
                                    coh04=g_cog.cog05,          #No.MOD-490398
                                   coh05=g_coh[l_ac].coh05,
                                   coh06=g_coh[l_ac].coh06,
                                   coh07=g_coh[l_ac].coh07,
                                   coh08=g_coh[l_ac].coh08,
                                   #FUN-840202 --start--
                                   cohud01 = g_coh[l_ac].cohud01,
                                   cohud02 = g_coh[l_ac].cohud02,
                                   cohud03 = g_coh[l_ac].cohud03,
                                   cohud04 = g_coh[l_ac].cohud04,
                                   cohud05 = g_coh[l_ac].cohud05,
                                   cohud06 = g_coh[l_ac].cohud06,
                                   cohud07 = g_coh[l_ac].cohud07,
                                   cohud08 = g_coh[l_ac].cohud08,
                                   cohud09 = g_coh[l_ac].cohud09,
                                   cohud10 = g_coh[l_ac].cohud10,
                                   cohud11 = g_coh[l_ac].cohud11,
                                   cohud12 = g_coh[l_ac].cohud12,
                                   cohud13 = g_coh[l_ac].cohud13,
                                   cohud14 = g_coh[l_ac].cohud14,
                                   cohud15 = g_coh[l_ac].cohud15
                                   #FUN-840202 --end-- 
               WHERE coh01=g_cog.cog01 AND coh02=g_coh_t.coh02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_coh[l_ac].coh02,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","coh_file",g_cog.cog01,g_coh[l_ac].coh02,SQLCA.sqlcode,"","",1)  #TQC-660045
                   LET g_coh[l_ac].* = g_coh_t.*
               ELSE
                   CALL t300_update()
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
           #LET l_ac_t = l_ac     #FUN-D40064 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               IF p_cmd='u' THEN
                  LET g_coh[l_ac].* = g_coh_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_coh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40064 Add
          #LET g_coh_t.* = g_coh[l_ac].*          # 900423
           CLOSE t300_bcl
           COMMIT WORK
 
          #CALL g_coh.deleteElement(g_rec_b+1)   #FUN-D40064 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(coh02) AND l_ac > 1 THEN
                LET g_coh[l_ac].* = g_coh[l_ac-1].*
                NEXT FIELD coh02
            END IF
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(coh02)  #序號
                    CALL q_cod(FALSE,TRUE,g_coc01,g_coh[l_ac].coh02)
                         RETURNING g_coc01,g_coh[l_ac].coh02
#                    CALL FGL_DIALOG_SETBUFFER( g_coc01 )
#                    CALL FGL_DIALOG_SETBUFFER( g_coh[l_ac].coh02 )
                    DISPLAY g_coh[l_ac].coh02 TO coh02
                    NEXT FIELD coh02
               WHEN INFIELD(coh03) #料件編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cob"
                    LET g_qryparam.default1 = g_coh[l_ac].coh03
                    CALL cl_create_qry() RETURNING g_coh[l_ac].coh03
#                    CALL FGL_DIALOG_SETBUFFER( g_coh[l_ac].coh03 )
                    DISPLAY g_coh[l_ac].coh03 TO coh03
                    NEXT FIELD coh03
               WHEN INFIELD(coh06) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_coh[l_ac].coh06
                    CALL cl_create_qry() RETURNING g_coh[l_ac].coh06
#                    CALL FGL_DIALOG_SETBUFFER( g_coh[l_ac].coh06 )
                    DISPLAY BY NAME g_coh[l_ac].coh06
                    NEXT FIELD coh06
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
 
 
        END INPUT
 
        #FUN-5B0043-begin
         LET g_cog.cogmodu = g_user
         LET g_cog.cogdate = g_today
         UPDATE cog_file SET cogmodu = g_cog.cogmodu,cogdate = g_cog.cogdate
          WHERE cog01 = g_cog.cog01
         DISPLAY BY NAME g_cog.cogmodu,g_cog.cogdate
        #FUN-5B0043-end
 
        CLOSE t300_bcl
        COMMIT WORK
        CALL t300_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t300_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_cog.cog01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM cog_file ",
                  "  WHERE cog01 LIKE '",l_slip,"%' ",
                  "    AND cog01 > '",g_cog.cog01,"'"
      PREPARE t300_pb1 FROM l_sql 
      EXECUTE t300_pb1 INTO l_cnt       
      
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
         CALL t300_v()
         IF g_cog.cogconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_cog.cogconf,"","","",g_void,g_cog.cogacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM cog_file WHERE cog01 = g_cog.cog01
         INITIALIZE g_cog.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t300_delall()
#   SELECT COUNT(*) INTO g_cnt FROM coh_file
#       WHERE coh01 = g_cog.cog01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM cog_file WHERE cog01 = g_cog.cog01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t300_coh02(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_item    LIKE coh_file.coh03,
           l_unit    LIKE coh_file.coh06,
           l_bomno   LIKE cod_file.cod041,
           l_price   LIKE coh_file.coh07,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
 
    #檢查合同+商品編號是否經申請
 
     #No.MOD-490398
    SELECT cod03,cod041,cod06,cod07
      INTO l_item,l_bomno,l_unit,l_price FROM cod_file,coc_file
     WHERE coc01 = cod01
       AND cod02 = g_coh[l_ac].coh02 AND coc03 = g_cog.cog03
       AND coc10 = g_cog.cog05
       AND cocacti !='N' #010807增
     #No.MOD-490398  end
 
    CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'aco-010'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' THEN
       LET g_coh[l_ac].coh03 = l_item
       LET g_coh[l_ac].coh041= l_bomno
       LET g_coh[l_ac].coh06 = l_unit
       LET g_coh[l_ac].coh05 = s_digqty(g_coh[l_ac].coh05,g_coh[l_ac].coh06)    #FUN-910088--add--
       LET g_coh[l_ac].coh07 = l_price
       DISPLAY g_coh[l_ac].coh03 TO coh03
       DISPLAY g_coh[l_ac].coh041 TO coh041
       DISPLAY g_coh[l_ac].coh06 TO coh06
       DISPLAY g_coh[l_ac].coh07 TO coh07
       DISPLAY g_coh[l_ac].coh05 TO coh05     #FUN-910088--add--
    END IF
    #檢查商品編號檔
    SELECT cob02 INTO g_coh[l_ac].cob02
      FROM cob_file WHERE cob01 = g_coh[l_ac].coh03
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_coh[l_ac].cob02 TO cob02
    END IF
END FUNCTION
{
FUNCTION t300_coh03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_unit    LIKE coh_file.coh06,
           l_price   LIKE coh_file.coh07,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
    #檢查商品編號檔
    SELECT cob02,cobacti INTO g_coh[l_ac].cob02,l_cobacti
      FROM cob_file WHERE cob01 = g_coh[l_ac].coh03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET g_coh[l_ac].cob02 = ' '
                                   LET l_cobacti = NULL
         WHEN l_cobacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    #檢查合同+商品編號是否經申請
    SELECT cod06,cod07
      INTO l_unit,l_price FROM cod_file,coc_file
     WHERE coc01 = cod01
       AND cod03 = g_coh[l_ac].coh03 AND coc03 = g_cog.cog03
       AND cocacti !='N' #010807增
    CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'aco-010'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' THEN
       LET g_coh[l_ac].coh06 = l_unit
       LET g_coh[l_ac].coh07 = l_price
       DISPLAY g_coh[l_ac].coh06 TO coh06
       DISPLAY g_coh[l_ac].coh07 TO coh07
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_coh[l_ac].cob02 TO cob02
    END IF
END FUNCTION
}
FUNCTION t300_coh06(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_coh[l_ac].coh06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t300_b_askkey()
DEFINE
    l_wc2    LIKE type_file.chr1000       #No.FUN-680069  VARCHAR(200) 
 
 
    CONSTRUCT l_wc2 ON coh02,coh03,coh041,coh05,coh06,
                       coh07,coh08               # 螢幕上取單身條件
                       #No.FUN-840202 --start--
                       ,cohud01,cohud02,cohud03,cohud04,cohud05
                       ,cohud06,cohud07,cohud08,cohud09,cohud10
                       ,cohud11,cohud12,cohud13,cohud14,cohud15
                       #No.FUN-840202 ---end---
            FROM s_coh[1].coh02,s_coh[1].coh03,
                 s_coh[1].coh041,s_coh[1].coh05,s_coh[1].coh06,
                 s_coh[1].coh07,s_coh[1].coh08
                 #No.FUN-840202 --start--
                 ,s_coh[1].cohud01,s_coh[1].cohud02,s_coh[1].cohud03
                 ,s_coh[1].cohud04,s_coh[1].cohud05,s_coh[1].cohud06
                 ,s_coh[1].cohud07,s_coh[1].cohud08,s_coh[1].cohud09
                 ,s_coh[1].cohud10,s_coh[1].cohud11,s_coh[1].cohud12
                 ,s_coh[1].cohud13,s_coh[1].cohud14,s_coh[1].cohud15
                 #No.FUN-840202 ---end---
        #No.MOD-490398  --begin
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION controlp
            CASE
               WHEN INFIELD(coh03) #料件編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_cob"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coh03
                    NEXT FIELD coh03
               WHEN INFIELD(coh06) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coh06
                    NEXT FIELD coh06
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
    CALL t300_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2        LIKE type_file.chr1000       #No.FUN-680069  VARCHAR(200) 
 
 
    LET g_sql =
        "SELECT coh02,coh03,cob02,coh041,coh05,coh06,coh07,coh08, ",
        #No.FUN-840202 --start--
        "       cohud01,cohud02,cohud03,cohud04,cohud05,",
        "       cohud06,cohud07,cohud08,cohud09,cohud10,",
        "       cohud11,cohud12,cohud13,cohud14,cohud15 ", 
        #No.FUN-840202 ---end---
        "  FROM coh_file  LEFT OUTER JOIN cob_file ON coh_file.coh03 = cob_file.cob01",
        " WHERE coh01 ='",g_cog.cog01,"' AND ",  #單頭
    #No.FUN-8B0123---Begin
        "       coh03 = cob01 "                  #AND ", p_wc2 CLIPPED, #單身
    #   " ORDER BY 1,2"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t300_pb FROM g_sql
    DECLARE coh_cs                       #SCROLL CURSOR
        CURSOR FOR t300_pb
 
    CALL g_coh.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH coh_cs INTO g_coh[g_cnt].*   #單身 ARRAY 填充
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
 
    CALL g_coh.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_coh TO s_coh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t300_fetch('L')
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
 
         CALL cl_set_field_pic(g_cog.cogconf,"","","","",g_cog.cogacti)  #CHI-C80041
         IF g_cog.cogconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_cog.cogconf,"","","",g_void,g_cog.cogacti)   #CHI-C80041
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
 
 
FUNCTION t300_update()
 DEFINE l_cog04 LIKE cog_file.cog04
 
   SELECT SUM(coh08) INTO l_cog04 FROM coh_file
    WHERE coh01=g_cog.cog01
   IF cl_null(l_cog04) THEN LET l_cog04 = 0 END IF
   UPDATE cog_file SET cog04=l_cog04
    WHERE cog01=g_cog.cog01
   IF STATUS THEN
#     CALL cl_err('upd cog04:',STATUS,0) #No.TQC-660045
      CALL cl_err3("upd","cog_file",g_cog.cog01,"",STATUS,"","upd cog04:",1)  #TQC-660045
      LET g_success='N'
   END IF
   DISPLAY l_cog04 TO cog04
END FUNCTION
 
FUNCTION t300_y()
 DEFINE s_coc01    LIKE coc_file.coc01
 DEFINE l_coh02    LIKE coh_file.coh02
 DEFINE l_coh05    LIKE coh_file.coh05
 DEFINE l_coh08    LIKE coh_file.coh08
   IF g_cog.cog01 IS NULL THEN RETURN END IF
#CHI-C30107 -------- add --------- begin
   IF g_cog.cogacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cog.cog01,'mfg1000',0)
       RETURN
   END IF
   IF g_cog.cogconf='Y' THEN RETURN END IF
   IF g_cog.cogconf='X' THEN RETURN END IF  #CHI-C80041
  IF NOT cl_confirm('axm-108') THEN RETURN END IF  
#CHI-C30107 -------- add --------- end
   IF g_cog.cogacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cog.cog01,'mfg1000',0)
       RETURN
   END IF
   SELECT * INTO g_cog.* FROM cog_file WHERE cog01=g_cog.cog01
   IF g_cog.cogconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_cog.cogconf='Y' THEN RETURN END IF
   #no.7377
   SELECT COUNT(*) INTO g_cnt FROM coh_file
    WHERE coh01 = g_cog.cog01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #no.7377(end)
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
 
   #找出原始的申請編號
    #No.MOD-490398
   SELECT coc01 INTO s_coc01 FROM coc_file
    WHERE coc03 = g_cog.cog03
      AND coc10 = g_cog.cog05
      AND cocacti !='N' #010807增
    #No.MOD-490398  end
   IF cl_null(s_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1) 
      RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t300_cl USING g_cog.cog01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_cog.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   #回寫加簽數量,金額
   DECLARE firm_cs CURSOR FOR
    SELECT coh02,coh05,coh08 FROM coh_file WHERE coh01 = g_cog.cog01
   FOREACH firm_cs INTO l_coh02,l_coh05,l_coh08
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
 
      UPDATE cod_file SET cod10 = (cod10+l_coh05),
                          cod08 = (cod08+l_coh08)
       WHERE cod01 = s_coc01 AND cod02=l_coh02
      IF STATUS THEN
#        CALL cl_err('upd cod10:',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","cod_file",s_coc01,l_coh02,STATUS,"","upd cod10:",1)  #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
 
      UPDATE coc_file SET coc09 = (coc09 + l_coh08)
       WHERE coc01 = s_coc01
      IF STATUS THEN
#        CALL cl_err('upd coc09:',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","coc_file",s_coc01,"",STATUS,"","upd coc09:",1)  #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
 
   END FOREACH
   UPDATE cog_file SET cogconf='Y'
    WHERE cog01 = g_cog.cog01
   IF STATUS THEN
#     CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
      CALL cl_err3("upd","cog_file",g_cog.cog01,"",STATUS,"","upd cofconf",1)  #TQC-660045
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cog.cog01,'Y')
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT cogconf INTO g_cog.cogconf FROM cog_file
    WHERE cog01 = g_cog.cog01
   DISPLAY BY NAME g_cog.cogconf
   #CALL cl_set_field_pic(g_cog.cogconf,"","","","",g_cog.cogacti)  #CHI-C80041
   IF g_cog.cogconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_cog.cogconf,"","","",g_void,g_cog.cogacti)   #CHI-C80041
END FUNCTION
 
FUNCTION t300_z()
 DEFINE s_coc01    LIKE coc_file.coc01
 DEFINE l_coh02    LIKE coh_file.coh02
 DEFINE l_coh05    LIKE coh_file.coh05
 DEFINE l_coh08    LIKE coh_file.coh08
   IF g_cog.cog01 IS NULL THEN RETURN END IF
   SELECT * INTO g_cog.* FROM cog_file WHERE cog01=g_cog.cog01
   IF g_cog.cogconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_cog.cogconf='N' THEN RETURN END IF
   IF g_cog.cogacti='N' THEN RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   #找出原始的申請編號
    #No.MOD-490398
   SELECT coc01 INTO s_coc01 FROM coc_file
    WHERE coc03 = g_cog.cog03
      AND coc10 = g_cog.cog05
      AND cocacti !='N' #010807增
    #No.MOD-490398 end
   IF cl_null(s_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1)
      RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t300_cl USING g_cog.cog01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_cog.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   #回寫加簽數量
   DECLARE unfirm_cs CURSOR FOR
    SELECT coh02,coh05,coh08 FROM coh_file WHERE coh01 = g_cog.cog01
   FOREACH unfirm_cs INTO l_coh02,l_coh05,l_coh08
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
 
      UPDATE cod_file SET cod10 = (cod10-l_coh05),
                          cod08 = (cod08-l_coh08)
       WHERE cod01 = s_coc01 AND cod02=l_coh02
      IF STATUS THEN
#        CALL cl_err('upd cod10:',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","cod_file",s_coc01,l_coh02,STATUS,"","upd cod10:",1)  #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
      UPDATE coc_file SET coc09 = (coc09 - l_coh08)
       WHERE coc01 = s_coc01
      IF STATUS THEN
#        CALL cl_err('upd cod09:',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","coc_file",s_coc01,"",STATUS,"","upd cod09:",1)  #TQC-660045
         LET g_success='N' EXIT FOREACH
      END IF
 
   END FOREACH
   UPDATE cog_file SET cogconf='N'
    WHERE cog01 = g_cog.cog01
   IF STATUS THEN
#     CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
      CALL cl_err3("upd","cog_file",g_cog.cog01,"",STATUS,"","upd cofconf",1)  #TQC-660045
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT cogconf INTO g_cog.cogconf FROM cog_file
    WHERE cog01 = g_cog.cog01
   DISPLAY BY NAME g_cog.cogconf
   #CALL cl_set_field_pic(g_cog.cogconf,"","","","",g_cog.cogacti)  #CHI-C80041
   IF g_cog.cogconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_cog.cogconf,"","","",g_void,g_cog.cogacti)   #CHI-C80041
END FUNCTION
#Patch....NO.TQC-610035 <001> #
#CHI-C80041---begin
FUNCTION t300_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cog.cog01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t300_cl USING g_cog.cog01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_cog.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cog.cog01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t300_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_cog.cogconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_cog.cogconf)   THEN 
        LET l_chr=g_cog.cogconf
        IF g_cog.cogconf='N' THEN 
            LET g_cog.cogconf='X' 
        ELSE
            LET g_cog.cogconf='N'
        END IF
        UPDATE cog_file
            SET cogconf=g_cog.cogconf,  
                cogmodu=g_user,
                cogdate=g_today
            WHERE cog01=g_cog.cog01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","cog_file",g_cog.cog01,"",SQLCA.sqlcode,"","",1)  
            LET g_cog.cogconf=l_chr 
        END IF
        DISPLAY BY NAME g_cog.cogconf 
   END IF
 
   CLOSE t300_cl
   COMMIT WORK
   CALL cl_flow_notify(g_cog.cog01,'V')
 
END FUNCTION
#CHI-C80041---end
