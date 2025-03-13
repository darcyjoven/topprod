# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 保險單資料維護作業
# Pattern Name...: afat500.4gl
# Date & Author..: 97/08/27 By Sophia
# Modify.........: No.MOD-490179 93/09/22 By Yuna
#                     1.單據若已確認,不得單身明細再作保額重計
#                     2.取消確認時,若保單有保費分攤記錄或已產生分錄底稿,要show訊息詢問是否確定取消確認
#                       若保單已產生傳票,則不可再作取消確認動作
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/02 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
#
# Modify.........: NO.FUN-550034 05/05/20 By jackie 單據編號加大
# Modify.........: No.MOD-480333 05/08/02 By Smapmin  開放fdb08可修改, 並依幣別(本幣)取位
#                                                     確認時要提示明細與單身不合,且要卡確認動作
# Modify.........: No.FUN-5B0049 05/11/30 By Sarah 1.明細單身輸入資產編號後,不會帶出中文名稱、折舊部門、未折餘額
#                                                  2.明細單身保險金額修改，保險費不會重新計算
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t500_q() 一開始應清空g_fda.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710028 07/01/26 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-750073 07/05/16 By Smapmin 若財產附號為NULL,就設為' '
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7C0198 07/12/26 By Smapmin 單身明細部門欄位依分攤方式抓取
# Modify.........: No.MOD-7C0205 07/12/27 By Smapmin 單身明細輸入時,附號改變無法正確default後面欄位
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/14 By TSD.hoho 自定欄位功能修改
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.TQC-970414 09/07/31 By Carrier 非負控管
# Modify.........: No.TQC-970424 09/08/03 By xiaofeizhu 非負控管
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AB0088 11/04/01 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No.FUN-C10039 12/02/02 By Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20272 12/02/22 By wangrr 修改明細單身(afat5001)單機單身無法進行單身操作，財產編號fdc03修改插敘條件
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fda   RECORD LIKE fda_file.*,
    g_fda_t RECORD LIKE fda_file.*,
    g_fda_o RECORD LIKE fda_file.*,
    g_fdb            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                     fdb02     LIKE fdb_file.fdb02,
                     fdb03     LIKE fdb_file.fdb03,
                     fdb04     LIKE fdb_file.fdb04,
                     fdb05     LIKE fdb_file.fdb05,
                     fdb06     LIKE fdb_file.fdb06,
                     fdb07     LIKE fdb_file.fdb07,
                     fdb08     LIKE fdb_file.fdb08,
                     fdb09     LIKE fdb_file.fdb09,
                     #FUN-850068 --start---
                     fdbud01   LIKE fdb_file.fdbud01,
                     fdbud02   LIKE fdb_file.fdbud02,
                     fdbud03   LIKE fdb_file.fdbud03,
                     fdbud04   LIKE fdb_file.fdbud04,
                     fdbud05   LIKE fdb_file.fdbud05,
                     fdbud06   LIKE fdb_file.fdbud06,
                     fdbud07   LIKE fdb_file.fdbud07,
                     fdbud08   LIKE fdb_file.fdbud08,
                     fdbud09   LIKE fdb_file.fdbud09,
                     fdbud10   LIKE fdb_file.fdbud10,
                     fdbud11   LIKE fdb_file.fdbud11,
                     fdbud12   LIKE fdb_file.fdbud12,
                     fdbud13   LIKE fdb_file.fdbud13,
                     fdbud14   LIKE fdb_file.fdbud14,
                     fdbud15   LIKE fdb_file.fdbud15
                     #FUN-850068 --end--
                     END RECORD,
    g_fdc            DYNAMIC ARRAY OF RECORD
                     fdc02     LIKE fdc_file.fdc02,
                     fdc04     LIKE fdc_file.fdc04,
                     fdc03     LIKE fdc_file.fdc03,
                     fdc032    LIKE fdc_file.fdc032,
                     fdc12     LIKE fdc_file.fdc12,
                     fdc05     LIKE fdc_file.fdc05,
                     fdc06     LIKE fdc_file.fdc06,
                     fdc07     LIKE fdc_file.fdc07,
                     fdc08     LIKE fdc_file.fdc08,
                     fdc09     LIKE fdc_file.fdc09,
                     fdc10     LIKE fdc_file.fdc10,
                     fdc11     LIKE fdc_file.fdc11
                     END RECORD,
    g_fdb_t          RECORD
                     fdb02     LIKE fdb_file.fdb02,
                     fdb03     LIKE fdb_file.fdb03,
                     fdb04     LIKE fdb_file.fdb04,
                     fdb05     LIKE fdb_file.fdb05,
                     fdb06     LIKE fdb_file.fdb06,
                     fdb07     LIKE fdb_file.fdb07,
                     fdb08     LIKE fdb_file.fdb08,
                     fdb09     LIKE fdb_file.fdb09,
                     #FUN-850068 --start---
                     fdbud01   LIKE fdb_file.fdbud01,
                     fdbud02   LIKE fdb_file.fdbud02,
                     fdbud03   LIKE fdb_file.fdbud03,
                     fdbud04   LIKE fdb_file.fdbud04,
                     fdbud05   LIKE fdb_file.fdbud05,
                     fdbud06   LIKE fdb_file.fdbud06,
                     fdbud07   LIKE fdb_file.fdbud07,
                     fdbud08   LIKE fdb_file.fdbud08,
                     fdbud09   LIKE fdb_file.fdbud09,
                     fdbud10   LIKE fdb_file.fdbud10,
                     fdbud11   LIKE fdb_file.fdbud11,
                     fdbud12   LIKE fdb_file.fdbud12,
                     fdbud13   LIKE fdb_file.fdbud13,
                     fdbud14   LIKE fdb_file.fdbud14,
                     fdbud15   LIKE fdb_file.fdbud15
                     #FUN-850068 --end--
                     END RECORD,
    g_fdc_t          RECORD
                     fdc02     LIKE fdc_file.fdc02,
                     fdc04     LIKE fdc_file.fdc04,
                     fdc03     LIKE fdc_file.fdc03,
                     fdc032    LIKE fdc_file.fdc032,
                     fdc12     LIKE fdc_file.fdc12,
                     fdc05     LIKE fdc_file.fdc05,
                     fdc06     LIKE fdc_file.fdc06,
                     fdc07     LIKE fdc_file.fdc07,
                     fdc08     LIKE fdc_file.fdc08,
                     fdc09     LIKE fdc_file.fdc09,
                     fdc10     LIKE fdc_file.fdc10,
                     fdc11     LIKE fdc_file.fdc11
                     END RECORD,
    g_fda01_t        LIKE fda_file.fda01,
    g_wc,g_wc2,g_sql STRING,                      #No.FUN-580092 HCN
#   g_t1             LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
    g_t1             LIKE type_file.chr5,         #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
    l_modify_flag    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_flag           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_rec_b          LIKE type_file.num5,         #單身筆數               #No.FUN-680070 SMALLINT
    g_rec_b2         LIKE type_file.num5,         #單身筆數               #No.FUN-680070 SMALLINT
    l_ac             LIKE type_file.num5,         #目前處理的ARRAY CNT    #No.FUN-680070 SMALLINT
    l_ac2            LIKE type_file.num5          #目前處理的ARRAY CNT    #No.FUN-680070 SMALLINT
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql  STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done    LIKE type_file.num5                         #No.FUN-680070 SMALLINT
DEFINE g_chr         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_msg         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index  LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump        LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_argv1     LIKE fda_file.fda01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
DEFINE
#    l_time        LIKE type_file.chr8,     #計算被使用時間       #No.FUN-680070 VARCHAR(8)  #NO.FUN-6A0069
    l_sql         LIKE type_file.chr1000   #No.FUN-680070 VARCHAR(200)
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
    IF INT_FLAG THEN EXIT PROGRAM END IF
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
        RETURNING g_time                                           #NO.FUN-6A0069     
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    LET g_forupd_sql = " SELECT * FROM fda_file WHERE fda01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t500_w AT p_row,p_col             #顯示畫面
         WITH FORM "afa/42f/afat500"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t500_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t500_a()
            END IF
         OTHERWISE        
            CALL t500_q() 
      END CASE
   END IF
   #--
 
    CALL t500_menu()
    CLOSE WINDOW t500_w                    #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                           #NO.FUN-6A0069        
END MAIN
 
FUNCTION t500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_fdb.clear()
    CALL g_fdc.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fda.* TO NULL    #No.FUN-750051
 
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" fda01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
   ELSE
 
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
      fda01,fda02,fda03,fda04,fda09,fda091,fda10,
      fdavoid,fdaconf,fdauser,fdagrup,fdamodu,fdadate,fda07,fda08,
      #FUN-850068   ---start---
      fdaud01,fdaud02,fdaud03,fdaud04,fdaud05,
      fdaud06,fdaud07,fdaud08,fdaud09,fdaud10,
      fdaud11,fdaud12,fdaud13,fdaud14,fdaud15
      #FUN-850068    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
 
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
    CONSTRUCT g_wc2 ON fdb02,fdb03,fdb04,fdb05,fdb06,fdb07,fdb08,fdb09,
                       #No.FUN-850068 --start--
                       fdbud01,fdbud02,fdbud03,fdbud04,fdbud05,
                       fdbud06,fdbud07,fdbud08,fdbud09,fdbud10,
                       fdbud11,fdbud12,fdbud13,fdbud14,fdbud15
                       #No.FUN-850068 ---end---
            FROM s_fdb[1].fdb02, s_fdb[1].fdb03,s_fdb[1].fdb04,
                 s_fdb[1].fdb05, s_fdb[1].fdb06,s_fdb[1].fdb07,
                 s_fdb[1].fdb08, s_fdb[1].fdb09,
                 #No.FUN-850068 --start--
                 s_fdb[1].fdbud01,s_fdb[1].fdbud02,s_fdb[1].fdbud03,
                 s_fdb[1].fdbud04,s_fdb[1].fdbud05,s_fdb[1].fdbud06,
                 s_fdb[1].fdbud07,s_fdb[1].fdbud08,s_fdb[1].fdbud09,
                 s_fdb[1].fdbud10,s_fdb[1].fdbud11,s_fdb[1].fdbud12,
                 s_fdb[1].fdbud13,s_fdb[1].fdbud14,s_fdb[1].fdbud15
                 #No.FUN-850068 ---end---
 
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(fdb05)  #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fdb05
                 NEXT FIELD fdb05
              OTHERWISE
                 EXIT CASE
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF  #FUN-7C0050
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND fdauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND fdagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND fdagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fdauser', 'fdagrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fda01 FROM fda_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT fda01 ",
                   "  FROM fda_file, fdb_file",
                   " WHERE fda01 = fdb01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
    PREPARE t500_prepare FROM g_sql
    DECLARE t500_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t500_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fda_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fda01) FROM fda_file,fdb_file",
                  " WHERE fdb01 = fda01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE t500_precount FROM g_sql
    DECLARE t500_count CURSOR WITH HOLD FOR t500_precount
END FUNCTION
 
FUNCTION t500_menu()
 
   WHILE TRUE
      CALL t500_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t500_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t500_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t500_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t500_u()
            END IF
         WHEN "detail"
            CALL t500_b()
           #LET g_action_choice = ""  #FUN-D30032 mark
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t500_x()              #FUN-D20035
               CALL t500_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t500_x(2)
            END IF
         #FUN-D20035---add---end
         WHEN "contents"
            CALL t500_d()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t500_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t500_z()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fda.fda01 IS NOT NULL THEN
                  LET g_doc.column1 = "fda01"
                  LET g_doc.value1 = g_fda.fda01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fdb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t500_a()
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fdb.clear()
    CALL g_fdc.clear()
    INITIALIZE g_fda.* TO NULL
    LET g_fda01_t = NULL
    LET g_fda_o.* = g_fda.*
    LET g_fda_t.* = g_fda.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fda.fda03  =g_today
        LET g_fda.fda04  =g_today
        LET g_fda.fdaconf='N'
        LET g_fda.fdavoid='N'
        LET g_fda.fdauser=g_user
        LET g_fda.fdaoriu = g_user #FUN-980030
        LET g_fda.fdaorig = g_grup #FUN-980030
        LET g_fda.fdagrup=g_grup
        LET g_fda.fdadate=g_today
        LET g_fda.fdalegal= g_legal    #FUN-980003 add
        BEGIN WORK
        CALL t500_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fda.fda01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO fda_file VALUES (g_fda.*)
        IF SQLCA.SQLCODE THEN
#          CALL cl_err('Ins:',SQLCA.SQLCODE,1)   #No.FUN-660136
           CALL cl_err3("ins","fda_file",g_fda.fda01,"",SQLCA.sqlcode,"","Ins:",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
        COMMIT WORK
        LET g_rec_b=0
        LET g_fda_t.* = g_fda.*
        LET g_fda01_t = g_fda.fda01
        SELECT fda01 INTO g_fda.fda01
          FROM fda_file
         WHERE fda01 = g_fda.fda01
        CALL t500_b()
        CALL t500_d()
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t500_u()
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fda.fda01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_fda.fdaconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_fda.fdavoid = 'Y' THEN
       CALL cl_err(' ','afa-348',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fda01_t = g_fda.fda01
    LET g_fda_o.* = g_fda.*
    BEGIN WORK
 
    OPEN t500_cl USING g_fda.fda01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t500_cl INTO g_fda.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
    CALL t500_show()
    WHILE TRUE
        LET g_fda01_t = g_fda.fda01
        LET g_fda.fdamodu=g_user
        LET g_fda.fdadate=g_today
        CALL t500_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fda.*=g_fda_t.*
            CALL t500_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fda.fda01 != g_fda_t.fda01 THEN
           UPDATE fdb_file SET fdb01=g_fda.fda01 WHERE fdb01=g_fda_t.fda01
           UPDATE fdc_file SET fdc01=g_fda.fda01 WHERE fdc01=g_fda_t.fda01
           IF SQLCA.SQLCODE THEN
#             CALL cl_err('upd fdb01',SQLCA.SQLCODE,1)   #No.FUN-660136
              CALL cl_err3("upd","fdc_file",g_fda_t.fda01,"",SQLCA.sqlcode,"","upd fdb01",1)  #No.FUN-660136
              LET g_fda.*=g_fda_t.*
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fda_file SET * = g_fda.*
         WHERE fda01 = g_fda.fda01
        IF SQLCA.SQLCODE THEN
#          CALL cl_err(g_fda.fda01,SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("upd","fda_file",g_fda.fda01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t500_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t500_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,    #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5,   #No.FUN-680070 SMALLINT
         l_mm            LIKE type_file.num5    #No.FUN-680070 SMALLINT
 
  DEFINE li_result   LIKE type_file.num5        #No.FUN-550034       #No.FUN-680070 SMALLINT
     CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
     
     DISPLAY BY NAME
        g_fda.fda01,g_fda.fda02,g_fda.fda03,g_fda.fda04,g_fda.fda09,
        g_fda.fda091,g_fda.fda07,g_fda.fda08,g_fda.fda10,
        g_fda.fdavoid,g_fda.fdaconf,g_fda.fdauser,
        g_fda.fdagrup,g_fda.fdamodu,g_fda.fdadate,
        #FUN-850068     ---start---
        g_fda.fdaud01,g_fda.fdaud02,g_fda.fdaud03,g_fda.fdaud04,
        g_fda.fdaud05,g_fda.fdaud06,g_fda.fdaud07,g_fda.fdaud08,
        g_fda.fdaud09,g_fda.fdaud10,g_fda.fdaud11,g_fda.fdaud12,
        g_fda.fdaud13,g_fda.fdaud14,g_fda.fdaud15
        #FUN-850068     ----end----
 
 
     INPUT BY NAME g_fda.fda01,g_fda.fda02,g_fda.fda03,g_fda.fda04, g_fda.fdaoriu,g_fda.fdaorig,
                   g_fda.fda09,g_fda.fda091,g_fda.fda07,g_fda.fda08,g_fda.fda10,
                   g_fda.fdavoid,g_fda.fdaconf,g_fda.fdauser,g_fda.fdagrup,
                   g_fda.fdamodu,g_fda.fdadate,
                   #FUN-850068     ---start---
                   g_fda.fdaud01,g_fda.fdaud02,g_fda.fdaud03,g_fda.fdaud04,
                   g_fda.fdaud05,g_fda.fdaud06,g_fda.fdaud07,g_fda.fdaud08,
                   g_fda.fdaud09,g_fda.fdaud10,g_fda.fdaud11,g_fda.fdaud12,
                   g_fda.fdaud13,g_fda.fdaud14,g_fda.fdaud15
                   #FUN-850068     ----end----
                    WITHOUT DEFAULTS
       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t500_set_entry(p_cmd)
            CALL t500_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550034 --start--
         CALL cl_set_docno_format("fda01")
#No.FUN-550034 ---end---
 
        AFTER FIELD fda01
            IF NOT cl_null(g_fda.fda01) THEN
            IF g_fda.fda01 != g_fda_t.fda01 OR g_fda_t.fda01 IS NULL THEN
                   SELECT count(*) INTO g_cnt FROM fda_file
                    WHERE fda01 = g_fda.fda01
                   IF g_cnt > 0 THEN   #資料重複
                       CALL cl_err(g_fda.fda01,-239,0)
                       LET g_fda.fda01 = g_fda_t.fda01
                       DISPLAY BY NAME g_fda.fda01
                       NEXT FIELD fda01
                   END IF
               END IF
            END IF
 
 
        AFTER FIELD fda04
            IF NOT cl_null(g_fda.fda04) THEN
               IF g_fda.fda04 < g_fda.fda03 THEN NEXT FIELD fda04 END IF
            END IF
 
 
        AFTER FIELD fda091
            IF NOT cl_null(g_fda.fda091) THEN
               IF g_fda.fda091 > 12 OR g_fda.fda091 < 1 THEN
                  NEXT FIELD fda091
               END IF
            END IF
       #FUN-850068     ---start---
       AFTER FIELD fdaud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdaud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #FUN-850068     ----end----
 
 
        AFTER INPUT
           LET g_fda.fdauser = s_get_data_owner("fda_file") #FUN-C10039
           LET g_fda.fdagrup = s_get_data_group("fda_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(fda01) THEN
       #         LET g_fda.* = g_fda_t.*
       #         LET g_fda.fda01 = ' '
       #         LET g_fda.fdaconf = 'N'
       #         LET g_fda.fdavoid = 'N'
       #         CALL t500_show()
       #         NEXT FIELD fda01
       #     END IF
        #MOD-650015 --start 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION t500_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fda01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t500_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fda01",FALSE)
    END IF
 
END FUNCTION
 
 
FUNCTION t500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fda.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t500_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fda.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fda.* TO NULL
    ELSE
        OPEN t500_count
        FETCH t500_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t500_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t500_cs INTO g_fda.fda01
        WHEN 'P' FETCH PREVIOUS t500_cs INTO g_fda.fda01
        WHEN 'F' FETCH FIRST    t500_cs INTO g_fda.fda01
        WHEN 'L' FETCH LAST     t500_cs INTO g_fda.fda01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t500_cs INTO g_fda.fda01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)
        INITIALIZE g_fda.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fda.* FROM fda_file WHERE fda01 = g_fda.fda01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fda_file",g_fda.fda01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fda.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fda.fdauser   #FUN-4C0059
    LET g_data_group = g_fda.fdagrup   #FUN-4C0059
    CALL t500_show()
END FUNCTION
 
FUNCTION t500_show()
    LET g_fda_t.* = g_fda.*                #保存單頭舊值
    DISPLAY BY NAME g_fda.fdaoriu,g_fda.fdaorig,
 
        g_fda.fda01,g_fda.fda02,g_fda.fda03,g_fda.fda04,
        g_fda.fda09,g_fda.fda091,g_fda.fda07,g_fda.fda08,g_fda.fda10,
        g_fda.fdaconf,g_fda.fdavoid,
        g_fda.fdauser,g_fda.fdagrup,g_fda.fdamodu,g_fda.fdadate,
        #FUN-850068     ---start---
        g_fda.fdaud01,g_fda.fdaud02,g_fda.fdaud03,g_fda.fdaud04,
        g_fda.fdaud05,g_fda.fdaud06,g_fda.fdaud07,g_fda.fdaud08,
        g_fda.fdaud09,g_fda.fdaud10,g_fda.fdaud11,g_fda.fdaud12,
        g_fda.fdaud13,g_fda.fdaud14,g_fda.fdaud15
        #FUN-850068     ----end----
 
    #CKP
    CALL cl_set_field_pic(g_fda.fdaconf,"","","",g_fda.fdavoid,"")
    CALL t500_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t500_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fda.fda01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    IF g_fda.fdaconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fda.fdavoid = 'Y' THEN
       CALL cl_err(' ','afa-348',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN t500_cl USING g_fda.fda01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t500_cl INTO g_fda.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)
       CLOSE t500_cl ROLLBACK WORK  RETURN
    END IF
    CALL t500_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fda01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fda.fda01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fda,fdb,fdc!"
        DELETE FROM fda_file WHERE fda01 = g_fda.fda01
        IF SQLCA.SQLCODE THEN
#          CALL cl_err('No fda deleted',SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("del","fda_file",g_fda.fda01,"",SQLCA.sqlcode,"","No fda deleted",1)  #No.FUN-660136
        ELSE
           CLEAR FORM
           CALL g_fdb.clear()
           CALL g_fdc.clear()
        END IF
        DELETE FROM fdb_file WHERE fdb01 = g_fda.fda01
        DELETE FROM fdc_file WHERE fdc01 = g_fda.fda01
        LET g_msg = TIME
        INITIALIZE g_fda.* TO NULL
        MESSAGE ""
        OPEN t500_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t500_cs
           CLOSE t500_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH t500_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t500_cs
           CLOSE t500_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t500_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t500_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t500_fetch('/')
        END IF
 
    END IF
    CLOSE t500_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t500_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,  		   #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_b2      	    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    l_faj06         LIKE faj_file.faj06,
    l_qty	    LIKE bwh_file.bwh03,         #No.FUN-680070 DECIMAL(15,3),
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fda.fda01 IS NULL THEN RETURN END IF
    IF g_fda.fdaconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fda.fdavoid = 'Y' THEN CALL cl_err('','afa-348',0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fdb02,fdb03,fdb04,fdb05,fdb06,fdb07,fdb08,fdb09, ",
                       #No.FUN-850068 --start--
                       "       fdbud01,fdbud02,fdbud03,fdbud04,fdbud05,",
                       "       fdbud06,fdbud07,fdbud08,fdbud09,fdbud10,",
                       "       fdbud11,fdbud12,fdbud13,fdbud14,fdbud15 ",
                       #No.FUN-850068 ---end---
                       "   FROM fdb_file ",
                       "  WHERE fdb01 =? ",
                       "    AND fdb02 =? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fdb.clear() END IF
 
 
      INPUT ARRAY g_fdb WITHOUT DEFAULTS FROM s_fdb.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_fdb_t.* = g_fdb[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
 
            OPEN t500_cl USING g_fda.fda01
            IF STATUS THEN
               CALL cl_err("OPEN t500_cl:", STATUS, 1)
               CLOSE t500_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t500_cl INTO g_fda.*    # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t500_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
           #IF g_fdb[l_ac].fdb02 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_fdb_t.* = g_fdb[l_ac].*  #BACKUP
                LET l_flag = 'Y'
 
                OPEN t500_bcl USING g_fda.fda01,g_fdb_t.fdb02
                IF STATUS THEN
                   CALL cl_err("OPEN t500_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                   CLOSE t500_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t500_bcl INTO g_fdb[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fdb',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #LET g_fdb_t.* = g_fdb[l_ac].*  #BACKUP
           #NEXT FIELD fdb02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fdb[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fdb[l_ac].* TO s_fdb.*
              CALL g_fdb.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            IF g_fdb[l_ac].fdb06 != 0 THEN
               IF g_fda.fda10 != 0 THEN
                  LET g_fdb[l_ac].fdb08 = g_fdb[l_ac].fdb06 *
                                          (g_fdb[l_ac].fdb07/1000) *
                                          (g_fdb[l_ac].fdb09/100) *
                                          (g_fda.fda10 /100) *
                                          ((g_fda.fda04 - g_fda.fda03) / 365)
               ELSE
                  LET g_fdb[l_ac].fdb08 = g_fdb[l_ac].fdb06 *
                                          (g_fdb[l_ac].fdb07 / 1000) *
                                          (g_fdb[l_ac].fdb09/100) *
                                          ((g_fda.fda04 - g_fda.fda03) / 365)
               END IF
               #no.A010依幣別取位
               LET g_fdb[l_ac].fdb08 = cl_digcut(g_fdb[l_ac].fdb08,g_azi04)
               #(end)
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_fdb[l_ac].fdb08
               #------MOD-5A0095 END------------
            END IF
            INSERT INTO fdb_file (fdb01,fdb02,fdb03,fdb04,fdb05,fdb06,
                                  fdb07,fdb08,fdb09,
                                 #FUN-850068 --start--
                                 fdbud01,fdbud02,fdbud03,
                                 fdbud04,fdbud05,fdbud06,
                                 fdbud07,fdbud08,fdbud09,
                                 fdbud10,fdbud11,fdbud12,
                                 fdbud13,fdbud14,fdbud15,
                                 #FUN-850068 --end--
                                 fdblegal) #FUN-980003 add
                   VALUES(g_fda.fda01,g_fdb[l_ac].fdb02,
                  g_fdb[l_ac].fdb03,g_fdb[l_ac].fdb04,g_fdb[l_ac].fdb05,
                  g_fdb[l_ac].fdb06,g_fdb[l_ac].fdb07,
                  g_fdb[l_ac].fdb08,g_fdb[l_ac].fdb09,
                  #FUN-850068 --start--
                  g_fdb[l_ac].fdbud01,
                  g_fdb[l_ac].fdbud02,
                  g_fdb[l_ac].fdbud03,
                  g_fdb[l_ac].fdbud04,
                  g_fdb[l_ac].fdbud05,
                  g_fdb[l_ac].fdbud06,
                  g_fdb[l_ac].fdbud07,
                  g_fdb[l_ac].fdbud08,
                  g_fdb[l_ac].fdbud09,
                  g_fdb[l_ac].fdbud10,
                  g_fdb[l_ac].fdbud11,
                  g_fdb[l_ac].fdbud12,
                  g_fdb[l_ac].fdbud13,
                  g_fdb[l_ac].fdbud14,
                  g_fdb[l_ac].fdbud15,
                  #FUN-850068 --end--
                  g_legal) #FUN-980003 add
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins fdb',SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fdb_file",g_fda.fda01,g_fdb[l_ac].fdb02,SQLCA.sqlcode,"","ins fdb",1)  #No.FUN-660136
               #LET g_fdb[l_ac].* = g_fdb_t.*
               CANCEL INSERT
            ELSE MESSAGE 'INSERT O.K'
                 LET g_rec_b=g_rec_b+1
                 CALL t500_sum()
                 DISPLAY g_rec_b TO FORMONLY.cn2
                 COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fdb[l_ac].* TO NULL      #900423
            LET g_fdb_t.* = g_fdb[l_ac].*             #新輸入資料
            LET g_fdb[l_ac].fdb06 = 0
            LET g_fdb[l_ac].fdb07 = 0
            LET g_fdb[l_ac].fdb08 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fdb02
 
        BEFORE FIELD fdb02                            #defdalt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fdb[l_ac].fdb02 IS NULL OR g_fdb[l_ac].fdb02 = 0 THEN
                   SELECT max(fdb02)+1 INTO g_fdb[l_ac].fdb02
                     FROM fdb_file WHERE fdb01 = g_fda.fda01
                   IF g_fdb[l_ac].fdb02 IS NULL THEN
                       LET g_fdb[l_ac].fdb02 = 1
                   END IF
               END IF
            END IF
 
        AFTER FIELD fdb02                        #check 序號是否重複
            IF NOT cl_null(g_fdb[l_ac].fdb02) THEN
               IF g_fdb[l_ac].fdb02 != g_fdb_t.fdb02 OR
                  g_fdb_t.fdb02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fdb_file
                    WHERE fdb01 = g_fda.fda01
                      AND fdb02 = g_fdb[l_ac].fdb02
                   IF l_n > 0 THEN
                       LET g_fdb[l_ac].fdb02 = g_fdb_t.fdb02
                       CALL cl_err('',-239,0)
                       NEXT FIELD fdb02
                   END IF
               END IF
            END IF
 
        AFTER FIELD fdb05
           IF NOT cl_null(g_fdb[l_ac].fdb05) THEN
              SELECT COUNT(*) INTO g_cnt FROM gem_file
               WHERE gem01 = g_fdb[l_ac].fdb05
                 AND gemacti='Y'   #NO:6950
              IF g_cnt = 0 THEN
                 CALL cl_err(g_fdb[l_ac].fdb05,'afa-038',0)
                 NEXT FIELD fdb05
              END IF
           END IF
 
        AFTER FIELD fdb06
           IF NOT cl_null(g_fdb[l_ac].fdb06) THEN
              IF g_fdb[l_ac].fdb06 < 0 THEN
                 CALL cl_err(g_fdb[l_ac].fdb06,'axm-179',0)  #No.TQC-970414
                 NEXT FIELD fdb06
              END IF
           END IF
 
        AFTER FIELD fdb07
           IF NOT cl_null(g_fdb[l_ac].fdb07) THEN
              IF g_fdb[l_ac].fdb07 < 0 THEN
                 CALL cl_err(g_fdb[l_ac].fdb07,'axm-179',0)  #No.TQC-970414
                 NEXT FIELD fdb07
              END IF
           END IF
 #MOD-480333
        BEFORE FIELD fdb08
           IF g_rec_b>=l_ac THEN
              CALL cl_set_comp_entry("fdb08",TRUE)
           ELSE
              CALL cl_set_comp_entry("fdb08",FALSE)
           END IF
 
        AFTER FIELD fdb08
              CALL cl_set_comp_entry("fdb08",TRUE)
              LET g_fdb[l_ac].fdb08 = cl_digcut(g_fdb[l_ac].fdb08,g_azi04)
              DISPLAY BY NAME g_fdb[l_ac].fdb08
           #No.TQC-970414  --Begin
           IF NOT cl_null(g_fdb[l_ac].fdb08) THEN
              IF g_fdb[l_ac].fdb08 < 0 THEN
                 CALL cl_err(g_fdb[l_ac].fdb08,'axm-179',0)  #No.TQC-970414
                 NEXT FIELD fdb08
              END IF
           END IF
           #No.TQC-970414  --End  
 #END MOD-480333
 
       #No.TQC-970414  --Begin
       AFTER FIELD fdb09
           IF NOT cl_null(g_fdb[l_ac].fdb09) THEN
              IF g_fdb[l_ac].fdb09 < 0 THEN
                 CALL cl_err(g_fdb[l_ac].fdb09,'axm-179',0)  #No.TQC-970414
                 NEXT FIELD fdb09
              END IF
           END IF
       #No.TQC-970414  --End  
 
       #No.FUN-850068 --start--
       AFTER FIELD fdbud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fdbud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-850068 ---end---
 
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_fdb_t.fdb02 > 0 AND g_fdb_t.fdb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fdb_file WHERE fdb01 = g_fda.fda01
                                       AND fdb02 = g_fdb_t.fdb02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fdb_t.fdb02,SQLCA.sqlcode,0)   #No.FUN-660136
                    CALL cl_err3("del","fdb_file",g_fda.fda01,g_fdb_t.fdb02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fdb[l_ac].* = g_fdb_t.*
               CLOSE t500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fdb[l_ac].fdb02,-263,1)
               LET g_fdb[l_ac].* = g_fdb_t.*
            ELSE
 #MOD-480333
#             IF g_fdb[l_ac].fdb06 != 0 THEN
#                IF g_fda.fda10 != 0 THEN
#                   LET g_fdb[l_ac].fdb08 = g_fdb[l_ac].fdb06 *
#                                           (g_fdb[l_ac].fdb07/1000) *
#                                           (g_fdb[l_ac].fdb09/100) *
#                                           (g_fda.fda10 /100) *
#                                           ((g_fda.fda04 - g_fda.fda03) / 365)
#                ELSE
#                   LET g_fdb[l_ac].fdb08 = g_fdb[l_ac].fdb06 *
#                                           (g_fdb[l_ac].fdb07 / 1000) *
#                                           (g_fdb[l_ac].fdb09/100) *
#                                           ((g_fda.fda04 - g_fda.fda03) / 365)
#                END IF
#                #no.A010依幣別取位
#                LET g_fdb[l_ac].fdb08 = cl_digcut(g_fdb[l_ac].fdb08,g_azi04)
#                #(end)
#             END IF
 #END MOD-480333
                UPDATE fdb_file SET
                 fdb01=g_fda.fda01,fdb02=g_fdb[l_ac].fdb02,
                 fdb03=g_fdb[l_ac].fdb03,fdb04=g_fdb[l_ac].fdb04,
                 fdb05=g_fdb[l_ac].fdb05,fdb06=g_fdb[l_ac].fdb06,
                 fdb07=g_fdb[l_ac].fdb07,fdb08=g_fdb[l_ac].fdb08,
                 fdb09=g_fdb[l_ac].fdb09,
                 #FUN-850068 --start--
                 fdbud01 = g_fdb[l_ac].fdbud01,
                 fdbud02 = g_fdb[l_ac].fdbud02,
                 fdbud03 = g_fdb[l_ac].fdbud03,
                 fdbud04 = g_fdb[l_ac].fdbud04,
                 fdbud05 = g_fdb[l_ac].fdbud05,
                 fdbud06 = g_fdb[l_ac].fdbud06,
                 fdbud07 = g_fdb[l_ac].fdbud07,
                 fdbud08 = g_fdb[l_ac].fdbud08,
                 fdbud09 = g_fdb[l_ac].fdbud09,
                 fdbud10 = g_fdb[l_ac].fdbud10,
                 fdbud11 = g_fdb[l_ac].fdbud11,
                 fdbud12 = g_fdb[l_ac].fdbud12,
                 fdbud13 = g_fdb[l_ac].fdbud13,
                 fdbud14 = g_fdb[l_ac].fdbud14,
                 fdbud15 = g_fdb[l_ac].fdbud15
                 #FUN-850068 --end--
                 WHERE fdb01=g_fda.fda01 AND fdb02=g_fdb_t.fdb02
             IF SQLCA.sqlcode THEN
#               CALL cl_err('upd fdb',SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("upd","fdb_file",g_fda.fda01,g_fdb_t.fdb02,SQLCA.sqlcode,"","upd fdb",1)  #No.FUN-660136
                LET g_fdb[l_ac].* = g_fdb_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CALL t500_sum()
                COMMIT WORK
             END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fdb[l_ac].* = g_fdb_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fdb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032 add
            #LET g_fdb_t.* = g_fdb[l_ac].*  #FUN-D30032 mark
            CLOSE t500_bcl
            COMMIT WORK
            #CKP2
           #CALL g_fdb.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fdb02) AND l_ac > 1 THEN
                LET g_fdb[l_ac].* = g_fdb[l_ac-1].*
                LET g_fdb[l_ac].fdb02 = NULL
                NEXT FIELD fdb02
            END IF
 
         ON ACTION controlp
           CASE
              WHEN INFIELD(fdb05)  #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fdb[l_ac].fdb05
                 CALL cl_create_qry() RETURNING g_fdb[l_ac].fdb05
#                 CALL FGL_DIALOG_SETBUFFER( g_fdb[l_ac].fdb05 )
                 DISPLAY g_fdb[l_ac].fdb05 TO fdb05
                 NEXT FIELD fdb05
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
      END INPUT
      UPDATE fda_file SET fdauser = g_user,
                          fdadate = g_today
       WHERE fda01 = g_fda.fda01
    CLOSE t500_cl
    CLOSE t500_bcl
    COMMIT WORK
    CALL t500_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t500_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fda.fda01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fda_file ",
                  "  WHERE fda01 LIKE '",l_slip,"%' ",
                  "    AND fda01 > '",g_fda.fda01,"'"
      PREPARE t500_pb1 FROM l_sql 
      EXECUTE t500_pb1 INTO l_cnt 
      
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
        #CALL t500_x()                #FUN-D20035
         CALL t500_x(1)               #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM fdc_file WHERE fdc01 = g_fda.fda01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fda_file WHERE fda01 = g_fda.fda01
         INITIALIZE g_fda.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t500_sum()
 
   SELECT SUM(fdb06),SUM(fdb08)
     INTO g_fda.fda07,g_fda.fda08
     FROM fdb_file
    WHERE fdb01 = g_fda.fda01
   IF cl_null(g_fda.fda07) THEN LET g_fda.fda07=0 END IF
   IF cl_null(g_fda.fda08) THEN LET g_fda.fda08=0 END IF
   #no.A010依幣別取位
   LET g_fda.fda07 = cl_digcut(g_fda.fda07,g_azi04)
   LET g_fda.fda08 = cl_digcut(g_fda.fda08,g_azi04)
   #(end)
   UPDATE fda_file SET fda07=g_fda.fda07,fda08 =g_fda.fda08
    WHERE fda01 = g_fda.fda01
   IF STATUS THEN
#     CALL cl_err('upd fda',STATUS,0)   #No.FUN-660136
      CALL cl_err3("upd","fda_file",g_fda.fda01,"",SQLCA.sqlcode,"","upd fda",1)  #No.FUN-660136
   END IF
   DISPLAY BY NAME g_fda.fda07,g_fda.fda08
 
END FUNCTION
 
FUNCTION t500_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fdb02,fdb03,fdb04,fdb05,fdb06,fdb07,fdb08,fdb09
         FROM s_fdb[1].fdb02,s_fdb[1].fdb03,s_fdb[1].fdb04,s_fdb[1].fdb05,
              s_fdb[1].fdb06,s_fdb[1].fdb07,s_fdb[1].fdb08,s_fdb[1].fdb09
 
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
    CALL t500_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t500_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fdb02,fdb03,fdb04,fdb05,fdb06,fdb07,fdb08,fdb09,",
        #No.FUN-850068 --start--
        "       fdbud01,fdbud02,fdbud03,fdbud04,fdbud05,",
        "       fdbud06,fdbud07,fdbud08,fdbud09,fdbud10,",
        "       fdbud11,fdbud12,fdbud13,fdbud14,fdbud15 ",
        #No.FUN-850068 ---end---
 
        "  FROM fdb_file",
        " WHERE fdb01  ='",g_fda.fda01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t500_pb FROM g_sql
    DECLARE fdb_curs                       #SCROLL CURSOR
        CURSOR FOR t500_pb
 
    CALL g_fdb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fdb_curs INTO g_fdb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_fdb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fdb TO s_fdb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION previous
         CALL t500_fetch('P')
         LET g_action_choice="previous"
         EXIT DISPLAY
      ON ACTION jump
         CALL t500_fetch('/')
      ON ACTION next
         CALL t500_fetch('N')
         LET g_action_choice="next"
         EXIT DISPLAY
      ON ACTION last
         CALL t500_fetch('L')
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end
  
      #@ON ACTION 明細單身
      ON ACTION contents
         LET g_action_choice="contents"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
      #FUN-810046
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t500_y() 	# 確認 when g_fda.fdaconf='N' (Turn to 'Y')
DEFINE l_fdc03   LIKE fdc_file.fdc03
DEFINE l_fdc032  LIKE fdc_file.fdc032
DEFINE l_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 #MOD-480333
DEFINE s_fdc07   LIKE fdc_file.fdc07
DEFINE s_fdc09   LIKE fdc_file.fdc09
DEFINE s_fdb06   LIKE fdb_file.fdb06
DEFINE s_fdb08   LIKE fdb_file.fdb08
 #END MOD-480333
   IF s_shut(0) THEN RETURN END IF
#CHI-C30107 ------------ add --------------- begin
   IF g_fda.fdaconf='Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------------ add --------------- end
   IF g_fda.fda01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fda.fdaconf='Y' THEN RETURN END IF
   #bugno:7341 add......................................................
   SELECT COUNT(*) INTO l_cnt FROM fdb_file
    WHERE fdb01= g_fda.fda01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #bugno:7341 end......................................................
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   BEGIN WORK
 
    OPEN t500_cl USING g_fda.fda01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t500_cl INTO g_fda.*    # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE fda_file SET fdaconf = 'Y' WHERE fda01 = g_fda.fda01
   IF STATUS THEN
#     CALL cl_err('upd fdaconf',STATUS,1)   #No.FUN-660136
      CALL cl_err3("upd","fda_file",g_fda.fda01,"",SQLCA.sqlcode,"","upd fdaconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   DECLARE t500_y1 CURSOR FOR             #NO:4985
       SELECT fdc03,fdc032 FROM fdc_file
        WHERE fdc01=g_fda.fda01
   CALL s_showmsg_init()  #No.FUN-710028
   FOREACH t500_y1 INTO l_fdc03,l_fdc032
#No.FUN-710028 --begin                                                                                                              
           IF g_success='N' THEN                                                                                                         
              LET g_totsuccess='N'                                                                                                       
              LET g_success="Y"                                                                                                          
           END IF                                                                                                                        
#No.FUN-710028 --end
 
           UPDATE faj_file SET faj39 = '2' WHERE faj02 =l_fdc03
                                             AND faj022=l_fdc032
           IF STATUS THEN
#             CALL cl_err('upd faj39',STATUS,1)                              #No.FUN-660136
#             CALL cl_err3("upd","faj_file",l_fdc03,l_fdc032,SQLCA.sqlcode,"","upd faj39",1) #No.FUN-660136 #No.FUN-710028
              LET g_showmsg = l_fdc03,"/",l_fdc032                           #No.FUN-710028
              CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj39',STATUS,1)   #No.FUN-710028
              LET g_success = 'N'
           END IF
  END FOREACH
#No.FUN-710028 --begin                                                                                                              
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
#No.FUN-710028 --end
 
   CLOSE t500_cl
 #MOD-480333
  SELECT SUM(fdc07),SUM(fdc09) INTO s_fdc07,s_fdc09 FROM fdc_file
     WHERE fdc01 = g_fda.fda01
  SELECT SUM(fdb06),SUM(fdb08) INTO s_fdb06,s_fdb08 FROM fdb_file
     WHERE fdb01 = g_fda.fda01
  IF s_fdc07 <> s_fdb06 THEN
#    CALL cl_err('','afa-976',0)         #No.FUN-710028
     CALL s_errmsg('','','','afa-976',1) #No.FUN-710028
     LET g_success = 'N'
  END IF
  IF s_fdc09 <> s_fdb08 THEN
#    CALL cl_err('','afa-977',0)         #No.FUN-710028
     CALL s_errmsg('','','','afa-976',1) #No.FUN-710028
     LET g_success = 'N'
  END IF
 #END MOD-480333
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_fda.fdaconf='Y'
      COMMIT WORK
      DISPLAY BY NAME g_fda.fdaconf
  ELSE
      LET g_fda.fdaconf='N'
      ROLLBACK WORK
   END IF
   #CKP
    CALL cl_set_field_pic(g_fda.fdaconf,"","","",g_fda.fdavoid,"")
END FUNCTION
 
FUNCTION t500_z() 	# 確認取消 when g_fda.fdaconf='Y' (Turn to 'N')
DEFINE l_fdc03   LIKE fdc_file.fdc03
DEFINE l_fdc032  LIKE fdc_file.fdc032
DEFINE l_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE l_fdd01   LIKE fdd_file.fdd01
DEFINE l_fdd06   LIKE fdd_file.fdd06
DEFINE l_npq23   LIKE npq_file.npq23
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fda.fda01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fda.fdaconf='N' THEN RETURN END IF
 
    #--No.MOD-490179
   SELECT fdd01,fdd06 INTO l_fdd01,l_fdd06 FROM fdd_file
     WHERE fdd01 = g_fda.fda01
   SELECT DISTINCT npq23 INTO l_npq23 FROM npq_file
     WHERE npq23 = g_fda.fda01
   CASE WHEN NOT cl_null(l_fdd06)   #已產生傳票,不可取消確認
             CALL cl_err(g_fda.fda01,'axr-370',0)
             RETURN
        WHEN NOT cl_null(l_npq23)   #已產生保費分攤底稿
             IF NOT cl_confirm('afa-356') THEN RETURN END IF
        WHEN NOT cl_null(l_fdd01)   ##已有保費分攤紀錄
             IF NOT cl_confirm('afa-355') THEN RETURN END IF
        OTHERWISE
             IF NOT cl_confirm('axm-109') THEN RETURN END IF
   END CASE
   #--END
 
    BEGIN WORK
    OPEN t500_cl USING g_fda.fda01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t500_cl INTO g_fda.*    # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE fda_file SET fdaconf = 'N' WHERE fda01 = g_fda.fda01
   IF SQLCA.sqlcode THEN LET g_success = 'N' END IF
   DECLARE t500_z1 CURSOR FOR             #NO:4985
       SELECT fdc03,fdc032 FROM fdc_file
        WHERE fdc01=g_fda.fda01
   CALL s_showmsg_init()  #No.FUN-710028
   FOREACH t500_z1 INTO l_fdc03,l_fdc032
#No.FUN-710028 --begin                                                                                                              
           IF g_success='N' THEN                                                                                                         
              LET g_totsuccess='N'                                                                                                       
              LET g_success="Y"                                                                                                          
           END IF                                                                                                                        
#No.FUN-710028 --end
 
           SELECT COUNT(*) INTO l_cnt FROM fda_file,fdc_file
            WHERE fdc03=l_fdc03
              AND fdc032=l_fdc032
              AND fdc01 =fda01
              AND fda01 <> g_fda.fda01
              AND fdaconf = 'Y'
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)   #No.FUN-660136
#              CALL cl_err3("sel","fda_file,fdc_file",l_fdc03,l_fdc032,SQLCA.sqlcode,"","",1)  #No.FUN-660136
               LET g_showmsg = l_fdc03,"/",l_fdc032,"/",'Y'                                    #No.FUN-710028
               CALL s_errmsg('fdc03,fdc032,fdaconf',g_showmsg,g_fda.fda01,SQLCA.sqlcode,0)     #No.FUN-710028
           END IF
           IF l_cnt >0 THEN
              CONTINUE FOREACH
           END IF
           UPDATE faj_file SET faj39 = '1' WHERE faj02 =l_fdc03
                                             AND faj022=l_fdc032
           IF STATUS THEN
#              CALL cl_err('upd faj39',STATUS,1)     #No.FUN-660136
#              CALL cl_err3("upd","faj_file",l_fdc03,l_fdc032,SQLCA.sqlcode,"","upd faj39",1)  #No.FUN-660136 #No.FUN-710028
               LET g_showmsg = l_fdc03,"/",l_fdc032  #No.FUN-710028
               CALL s_errmsg('faj02,faj032',g_showmsg,'upd faj39',STATUS,1)  #No.FUN-710028
               LET g_success = 'N'
           END IF
  END FOREACH
#No.FUN-710028 --begin                                                                                                              
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
#No.FUN-710028 --end
 
   CLOSE t500_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_fda.fdaconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_fda.fdaconf
   ELSE
      LET g_fda.fdaconf='Y'
      ROLLBACK WORK
   END IF
    #CKP
    CALL cl_set_field_pic(g_fda.fdaconf,"","","",g_fda.fdavoid,"")
END FUNCTION
 
#FUNCTION t500_x()                                # 無效   #FUN-D20035
FUNCTION t500_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

    IF g_fda.fdaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF s_shut(0) THEN RETURN END IF
    IF g_fda.fda01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

   #FUN-D20035---begin
   #作废操作
   IF p_type = 1 THEN
      IF g_fda.fdavoid ='Y' THEN RETURN END IF
   ELSE
   #取消作废
      IF g_fda.fdavoid <>'Y' THEN RETURN END IF
   END IF
   #FUN-D20035---end

    BEGIN WORK
 
    OPEN t500_cl USING g_fda.fda01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t500_cl INTO g_fda.*
    IF SQLCA.SQLCODE THEN
       CALL cl_err(g_fda.fda01,SQLCA.SQLCODE,0)
       CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
    CALL t500_show()
   #IF cl_void(0,0,g_fda.fdavoid)   THEN          #FUN-D20035
    IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'Y' END IF     #FUN-D20035
    IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
        LET g_chr=g_fda.fdavoid
       #IF g_fda.fdavoid='Y' THEN                                        #FUN-D20035
        IF p_type = 1 THEN                                              #FUN-D20035
            LET g_fda.fdavoid='Y'
        ELSE
            LET g_fda.fdavoid='N'
        END IF
        UPDATE fda_file
            SET fdavoid=g_fda.fdavoid
            WHERE fda01=g_fda.fda01
        IF SQLCA.SQLCODE THEN
#           CALL cl_err(g_fda.fda01,SQLCA.SQLCODE,0)   #No.FUN-660136
            CALL cl_err3("upd","fda_file",g_fda.fda01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            LET g_fda.fdavoid=g_chr
            CLOSE t500_cl ROLLBACK WORK RETURN
        END IF
        DISPLAY BY NAME g_fda.fdavoid
    END IF
    CLOSE t500_cl
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic(g_fda.fdaconf,"","","",g_fda.fdavoid,"")
 
END FUNCTION
 
FUNCTION t500_d()
  DEFINE ans     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_wc    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_sql   LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_i     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_fdc   RECORD LIKE fdc_file.*,
         l_faj   RECORD
                 faj02    LIKE faj_file.faj02,
                 faj022   LIKE faj_file.faj022,
                 faj06    LIKE faj_file.faj06,
                 faj23    LIKE faj_file.faj23,
                 faj24    LIKE faj_file.faj24,
                 faj20    LIKE faj_file.faj20,   #MOD-7C0198
                 faj33    LIKE faj_file.faj33,
                 faj53    LIKE faj_file.faj53
                 END RECORD
    DEFINE ls_tmp  STRING
    DEFINE ls_tmp1 STRING
 
    IF g_fda.fda01 IS NULL THEN RETURN END IF
    INITIALIZE l_fdc.* TO NULL
    LET p_row = 10 LET p_col = 6
    OPEN WINDOW t5002_w AT p_row,p_col WITH FORM "afa/42f/afat5001"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat5001")
 
    SELECT COUNT(*) INTO g_cnt FROM fdc_file WHERE fdc01 = g_fda.fda01
    IF g_cnt = 0 THEN
       CALL cl_getmsg('afa-103',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT g_msg CLIPPED,':' FOR ans
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
#             CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END PROMPT
      #---------詢問是否自動新增單身--------------
      IF ans MATCHES  '[yY]' THEN
         LET p_row = 8 LET p_col = 22
         OPEN WINDOW t500_w2 AT 12,24 WITH FORM "afa/42f/afat5002"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
         CALL cl_ui_locale("afat5002")
 
         CONSTRUCT BY NAME l_wc ON faj02
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
         IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t500_w2 RETURN END IF
 
         #LET l_sql ="SELECT faj02,faj022,faj06,faj23,faj24,faj33,faj53",   #MOD-7C0198
         LET l_sql ="SELECT faj02,faj022,faj06,faj23,faj24,faj20,faj33,faj53",   #MOD-7C0198
                    " FROM faj_file",
                    " WHERE fajconf = 'Y' AND faj43 NOT IN ('X','5','6') ",
                    "   AND faj432 NOT IN ('X','5','6') ",     #FUN-AB0088  
                    " AND faj39 !='0' ",       #NO:4985
                    " AND ",l_wc CLIPPED,
                    " ORDER BY 1"
        PREPARE t500_prepare_g FROM l_sql
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare:',SQLCA.sqlcode,0)
           RETURN
        END IF
        DECLARE t500_curs2 CURSOR FOR t500_prepare_g
 
        SELECT MAX(fdc02)+1 INTO l_i FROM fdc_file
         WHERE fdc01 = g_fda.fda01
        IF SQLCA.sqlcode THEN LET l_i = 1 END IF
        IF cl_null(l_i) THEN LET l_i = 1 END IF
        FOREACH t500_curs2 INTO l_faj.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('t500_curs2 foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET l_fdc.fdc01 = g_fda.fda01
          LET l_fdc.fdc02 = l_i
          LET l_fdc.fdc03 = l_faj.faj02
          LET l_fdc.fdc032 = l_faj.faj022
          LET l_fdc.fdc12 = l_faj.faj06
          LET l_fdc.fdc04 = ' '
          #-----MOD-7C0198--------- 
          #LET l_fdc.fdc05 = l_faj.faj24
          IF l_faj.faj23 = '1' THEN 
             LET l_fdc.fdc05 = l_faj.faj24
          ELSE
             LET l_fdc.fdc05 = l_faj.faj20
          END IF
          #-----END MOD-7C0198-----
          CALL t500_fdc06(l_fdc.fdc03,l_fdc.fdc032,l_faj.faj33)
               RETURNING l_fdc.fdc06
          IF cl_null(l_fdc.fdc06) THEN
             LET l_fdc.fdc06=0
          END IF
          LET l_fdc.fdc07 = 0
          LET l_fdc.fdc08 = 0
          LET l_fdc.fdc10 = 0
          LET l_fdc.fdc11 = 0
          LET l_fdc.fdclegal = g_legal  #FUN-980003 add
 
          INSERT INTO fdc_file VALUES (l_fdc.*)
          IF STATUS THEN
#            CALL cl_err('ins fdc',STATUS,0)   #No.FUN-660136
             CALL cl_err3("ins","fdc_file",l_fdc.fdc01,l_fdc.fdc02,SQLCA.sqlcode,"","ins fdc",1)  #No.FUN-660136
             EXIT FOREACH
          END IF
          LET l_i = l_i + 1
        END FOREACH
        CLOSE WINDOW t500_w2
       END IF
    END IF
 
    IF cl_null(g_wc2) THEN LET g_wc2 = ' 1=1 ' END IF
    CALL t500_b2_fill(g_wc2)
    CALL t500_bp2("D")
    CALL t500_b2()
    CALL t500_menu1()
    CLOSE WINDOW t5002_w
END FUNCTION
 
FUNCTION t500_menu1()
   LET g_action_choice=" "
   WHILE TRUE
       CALL t500_bp2("G")
       CASE g_action_choice
          WHEN "premium_calculation"
             IF cl_chk_act_auth() THEN
                CALL t500_g()
             END IF
          WHEN "detail"
             IF cl_chk_act_auth() THEN
                CALL t500_b2()
              ELSE
                 LET g_action_choice = NULL
              END IF
          WHEN "exit"
            EXIT WHILE
       END CASE
   END WHILE
END FUNCTION
 
# ----  1998/05/22  BY CLIN ----------
FUNCTION t500_g()
    DEFINE anser   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    DEFINE l_fdb02 LIKE fdb_file.fdb02         #No.FUN-680070 SMALLINT
    DEFINE p_fda01              LIKE fda_file.fda01
    DEFINE l_tot                LIKE type_file.num20_6  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    DEFINE l_fdb                RECORD LIKE fdb_file.*
    DEFINE l_fdc                RECORD LIKE fdc_file.*
    DEFINE l_acu_amt1           LIKE type_file.num20_6  #No.FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
    DEFINE l_acu_amt2           LIKE type_file.num20_6  #No.FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
    CALL cl_getmsg('afa-372',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
     #No.MOD-490179
    IF g_fda.fdaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    PROMPT g_msg CLIPPED,':' FOR anser  # 輸入保單序號
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
#          CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END PROMPT
 
    LET g_success = 'Y'
 
    BEGIN WORK
    LET l_acu_amt1 = 0
    LET l_acu_amt2 = 0
 
    DECLARE t500_cs2 CURSOR WITH HOLD FOR
         SELECT *
           FROM fdc_file
          WHERE fdc01 = g_fda.fda01 AND fdc04 = anser
    CALL s_showmsg_init()   #No.FUN-710028
    FOREACH t500_cs2 INTO l_fdc.*
       IF STATUS THEN
#         CALL cl_err('foreach:',STATUS,1)      #No.FUN-710028
          LET g_showmsg = g_fda.fda01,"/",anser #No.FUN-710028
          CALL s_errmsg('fdc01,fdc04',g_showmsg,'foreach:',STATUS,0) #No.FUN-710028
          LET g_success = 'N'                   #No.FUN-8A0086
          EXIT FOREACH 
       END IF 
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 --end
 
       MESSAGE l_fdb.fdb01
 
       # 未折餘額合計
       SELECT SUM(fdc06) INTO l_tot
             FROM fdc_file
       WHERE  fdc01 = l_fdc.fdc01
         AND  fdc04 = anser
 
       # 單身保險金額 ,保險費
       SELECT fdb06,fdb08 INTO l_fdb.fdb06,l_fdb.fdb08
             FROM fdb_file
       WHERE  fdb01 = l_fdc.fdc01
         AND  fdb02 = anser
 
       LET l_fdc.fdc07 = (l_fdc.fdc06 / l_tot ) *  l_fdb.fdb06
       LET l_fdc.fdc09 = (l_fdc.fdc06 / l_tot ) *  l_fdb.fdb08
       #no.A010依幣別取位
       LET l_fdc.fdc07 = cl_digcut(l_fdc.fdc07,g_azi04)
       LET l_fdc.fdc09 = cl_digcut(l_fdc.fdc09,g_azi04)
       #(end)
 
       LET l_acu_amt1 = l_acu_amt1 + l_fdc.fdc07    # Accumulated shared amt
       LET l_acu_amt2 = l_acu_amt2 + l_fdc.fdc09    # Accumulated shared amt
 
       UPDATE fdc_file SET fdc07=l_fdc.fdc07,fdc09=l_fdc.fdc09
              WHERE fdc01 = l_fdc.fdc01 AND fdc02 = l_fdc.fdc02
 
         IF STATUS THEN 
#           CALL cl_err('upd cle.1',SQLCA.sqlcode,1)     #No.FUN-660136
#           CALL cl_err3("upd","fdc_file",l_fdc.fdc01,l_fdc.fdc02,SQLCA.sqlcode,"","upd cle.1",1)  #No.FUN-660136 #No.FUN-710028
            LET g_showmsg = l_fdc.fdc01,"/",l_fdc.fdc02  #No.FUN-710028  
            CALL s_errmsg('fdc01,fdc02',g_showmsg,'upd cle.1',SQLCA.sqlcode,1)  #No.FUN-710028
            LET g_success = 'N' 
#           EXIT FOREACH      #No.FUN-710028
            CONTINUE FOREACH  #No.FUN-710028
         END IF
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
 
    LET l_fdc.fdc07 = l_fdc.fdc07 + (l_fdb.fdb06 - l_acu_amt1) #總差異分攤至最後
    LET l_fdc.fdc09 = l_fdc.fdc09 + (l_fdb.fdb08 - l_acu_amt2) #總差異分攤至最後
    #no.A010依幣別取位
    LET l_fdc.fdc07 = cl_digcut(l_fdc.fdc07,g_azi04)
    LET l_fdc.fdc09 = cl_digcut(l_fdc.fdc09,g_azi04)
    #(end)
 
    UPDATE fdc_file SET fdc07=l_fdc.fdc07,fdc09 =l_fdc.fdc09
              WHERE fdc01 = l_fdc.fdc01 AND fdc02 = l_fdc.fdc02
 
      IF STATUS THEN 
#        CALL cl_err('upd cfd.2',SQLCA.sqlcode,1)    #No.FUN-660136
#        CALL cl_err3("upd","fdc_file",l_fdc.fdc01,l_fdc.fdc02,SQLCA.sqlcode,"","upd cfd.2",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = l_fdc.fdc01,"/",l_fdc.fdc02 #No.FUN-710028
         CALL s_errmsg('fdc01,fdc02',g_showmsg,'upd cfd.2',SQLCA.sqlcode,1)  #No.FUN-710028
         LET g_success = 'N'
    END IF
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = 'Y'
          THEN COMMIT WORK
          ELSE ROLLBACK WORK
    END IF
    CALL t500_b2_fill(' 1=1')
    CALL t500_bp2("D")
 
END FUNCTION
# ----  1998/05/22  BY CLIN ----------
 
FUNCTION t500_b2()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,  		   #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_b2      	    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    l_faj33         LIKE faj_file.faj33,
    l_faj23         LIKE faj_file.faj23,
    l_faj53         LIKE faj_file.faj53,
    l_fdb09         LIKE fdb_file.fdb09,
    l_fdb07         LIKE fdb_file.fdb07,
    l_qty	    LIKE bwh_file.bwh03,         #No.FUN-680070 DECIMAL(15,3),
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fda.fda01 IS NULL THEN RETURN END IF
    IF g_fda.fdaconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fda.fdavoid = 'Y' THEN CALL cl_err('','afa-348',0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fdc02,fdc04,fdc03,fdc032,fdc12,fdc05,fdc06,fdc07,fdc08, ",
                       " fdc09,fdc10,fdc11 ",
                       " FROM fdc_file ",
                       " WHERE fdc01 = ? ",
                       " AND fdc02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b2=0 THEN CALL g_fdc.clear() END IF
 
      INPUT ARRAY g_fdc WITHOUT DEFAULTS FROM s_fdc.*
            ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
          IF g_rec_b2!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_fdc_t.* = g_fdc[l_ac].*         #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
 
            OPEN t500_cl USING g_fda.fda01
            IF STATUS THEN
               CALL cl_err("OPEN t500_cl:", STATUS, 1)
               CLOSE t500_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t500_cl INTO g_fda.*    # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fda.fda01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t500_cl ROLLBACK WORK RETURN
            END IF
            #IF g_fdc[l_ac].fdc02 IS NOT NULL THEN
             IF g_rec_b2>=l_ac THEN
                LET p_cmd='u'
                LET g_fdc_t.* = g_fdc[l_ac].*         #BACKUP
                LET l_flag = 'Y'
 
                OPEN t500_bcl2 USING g_fda.fda01,g_fdc_t.fdc02
                IF STATUS THEN
                   CALL cl_err("OPEN t500_bcl:", STATUS, 1)
                   CLOSE t500_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t500_bcl2 INTO g_fdc[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fdc',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #LET g_fdc_t.* = g_fdc[l_ac].*  #BACKUP
           #NEXT FIELD fdc02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fdc[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fdc[l_ac].* TO s_fdc.*
              CALL g_fdc.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            IF g_fdc[l_ac].fdc032 IS NULL THEN LET g_fdc[l_ac].fdc032 = ' ' END IF   #MOD-750073
            INSERT INTO fdc_file (fdc01,fdc02,fdc03,fdc032,fdc04,fdc05,
                                   fdc06,fdc07,fdc08,fdc09,fdc10,
                                   fdc11,fdc12,fdclegal) #FUN-980003 add
                    VALUES(g_fda.fda01,g_fdc[l_ac].fdc02,
                  g_fdc[l_ac].fdc03,g_fdc[l_ac].fdc032,g_fdc[l_ac].fdc04,
                  g_fdc[l_ac].fdc05,g_fdc[l_ac].fdc06,g_fdc[l_ac].fdc07,
                  g_fdc[l_ac].fdc08,g_fdc[l_ac].fdc09,g_fdc[l_ac].fdc10,
                  g_fdc[l_ac].fdc11,g_fdc[l_ac].fdc12,g_legal) #FUN-980003 add
            IF SQLCA.sqlcode THEN
#               CALL cl_err('ins fdc',SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("ins","fdc_file",g_fda.fda01,g_fdc[l_ac].fdc02,SQLCA.sqlcode,"","ins fdc",1)  #No.FUN-660136
                #LET g_fdc[l_ac].* = g_fdc_t.*
                CANCEL INSERT
            ELSE MESSAGE 'INSERT O.K'
                  LET g_rec_b2=g_rec_b2+1
                  DISPLAY g_rec_b2 TO FORMONLY.cn2
                  COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fdc[l_ac].* TO NULL      #900423
            LET g_fdc_t.* = g_fdc[l_ac].*             #新輸入資料
            LET g_fdc[l_ac].fdc06 = 0
            LET g_fdc[l_ac].fdc07 = 0
            LET g_fdc[l_ac].fdc08 = 0
            LET g_fdc[l_ac].fdc09 = 0
            LET g_fdc[l_ac].fdc10 = 0
            LET g_fdc[l_ac].fdc11 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fdc02
 
        BEFORE FIELD fdc02                            #defdalt 序號
            IF g_fdc[l_ac].fdc02 IS NULL OR g_fdc[l_ac].fdc02 = 0 THEN
                SELECT max(fdc02)+1 INTO g_fdc[l_ac].fdc02
                  FROM fdc_file WHERE fdc01 = g_fda.fda01
                IF g_fdc[l_ac].fdc02 IS NULL THEN
                    LET g_fdc[l_ac].fdc02 = 1
                END IF
            END IF
 
        AFTER FIELD fdc02                        #check 序號是否重複
            IF NOT cl_null(g_fdc[l_ac].fdc02) THEN
               IF g_fdc[l_ac].fdc02 != g_fdc_t.fdc02 OR
                  g_fdc_t.fdc02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fdc_file
                    WHERE fdc01 = g_fda.fda01
                      AND fdc02 = g_fdc[l_ac].fdc02
                   IF l_n > 0 THEN
                       LET g_fdc[l_ac].fdc02 = g_fdc_t.fdc02
                       CALL cl_err('',-239,0)
                       NEXT FIELD fdc02
                   END IF
               END IF
            END IF
 
        AFTER FIELD fdc04   #標的序號
           IF NOT cl_null(g_fdc[l_ac].fdc04) THEN
              SELECT COUNT(*) INTO g_cnt FROM fdb_file
               WHERE fdb01 = g_fda.fda01
                 AND fdb02 = g_fdc[l_ac].fdc04
              IF g_cnt = 0 THEN
                 CALL cl_err(g_fdc[l_ac].fdc04,'afa-349',0)
                 NEXT FIELD fdc04
              END IF
              IF p_cmd = 'u' AND (g_fdc[l_ac].fdc04 != g_fdc_t.fdc04 OR
                                  g_fdc_t.fdc04 IS NULL) THEN
                 SELECT COUNT(*) INTO g_cnt FROM faj_file
                  WHERE faj02 = g_fdc[l_ac].fdc03
                    AND faj022 = g_fdc[l_ac].fdc032
                 IF g_cnt > 0 THEN
                    #-----MOD-7C0198---------
                    #SELECT faj06,faj24,faj33
                    #  INTO g_fdc[l_ac].fdc12,g_fdc[l_ac].fdc05,l_faj33
                    #  FROM faj_file
                    # WHERE faj02 = g_fdc[l_ac].fdc03
                    #   AND faj022= g_fdc[l_ac].fdc032
                    SELECT faj06,faj33
                      INTO g_fdc[l_ac].fdc12,l_faj33
                      FROM faj_file
                     WHERE faj02 = g_fdc[l_ac].fdc03
                       AND faj022= g_fdc[l_ac].fdc032
                    SELECT faj23 INTO l_faj23 FROM faj_file
                     WHERE faj02 = g_fdc[l_ac].fdc03
                       AND faj022= g_fdc[l_ac].fdc032
                    IF l_faj23 = '1' THEN 
                       SELECT faj24
                         INTO g_fdc[l_ac].fdc05
                         FROM faj_file
                        WHERE faj02 = g_fdc[l_ac].fdc03
                          AND faj022= g_fdc[l_ac].fdc032
                    ELSE
                       SELECT faj20
                         INTO g_fdc[l_ac].fdc05
                         FROM faj_file
                        WHERE faj02 = g_fdc[l_ac].fdc03
                          AND faj022= g_fdc[l_ac].fdc032
                    END IF
                    #-----END MOD-7C0198-----
                    CALL t500_fdc06(g_fdc[l_ac].fdc03,g_fdc[l_ac].fdc032,l_faj33)
                          RETURNING g_fdc[l_ac].fdc06
                    IF cl_null(g_fdc[l_ac].fdc06) THEN
                       LET g_fdc[l_ac].fdc06=0
                    END IF
                    SELECT fdb09,fdb07 INTO l_fdb09,l_fdb07 FROM fdb_file
                     WHERE fdb01 = g_fda.fda01
                       AND fdb02 = g_fdc[l_ac].fdc04
                    IF cl_null(l_fdb07) THEN LET l_fdb07=0 END IF
                    LET g_fdc[l_ac].fdc08 = l_fdb07
                   #IF NOT cl_null(l_fdb09) THEN                    #FUN-5B0049 mark
                    IF NOT cl_null(l_fdb09) AND l_fdb09 != 0 THEN   #FUN-5B0049
                    #保險金額=未折減額*(折扣率/100)*(全額保險率/100)
                       LET g_fdc[l_ac].fdc07 = g_fdc[l_ac].fdc06*
                                              (g_fda.fda10/100) *
                                              (l_fdb09/100)
                    #保險費=保險金額*(保險費率/1000)*保險期間/365
                       LET g_fdc[l_ac].fdc09 = g_fdc[l_ac].fdc07 *
                                              (l_fdb07 / 1000) *
                                              ((g_fda.fda04 - g_fda.fda03) / 365)
                    ELSE
                       LET g_fdc[l_ac].fdc07 = g_fdc[l_ac].fdc06 *
                                               (g_fda.fda10/100)
                       LET g_fdc[l_ac].fdc09 = g_fdc[l_ac].fdc07 *
                                              (l_fdb07 / 1000) *
                                              ((g_fda.fda04 - g_fda.fda03) / 365)
                    END IF
                    #no.A010依幣別取位
                    LET g_fdc[l_ac].fdc07 = cl_digcut(g_fdc[l_ac].fdc07,g_azi04)
                    LET g_fdc[l_ac].fdc09 = cl_digcut(g_fdc[l_ac].fdc09,g_azi04)
                    #(end)
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_fdc[l_ac].fdc07
                    DISPLAY BY NAME g_fdc[l_ac].fdc09
                    DISPLAY BY NAME g_fdc[l_ac].fdc08
                    DISPLAY BY NAME g_fdc[l_ac].fdc06
                    DISPLAY BY NAME g_fdc[l_ac].fdc12
                    DISPLAY BY NAME g_fdc[l_ac].fdc05
                    #------MOD-5A0095 END------------
                 END IF
              END IF
            END IF
 
        BEFORE FIELD fdc03    #財產編號
            CALL t5001_set_entry_b()
 
        AFTER FIELD fdc03    #財產編號
            IF NOT cl_null(g_fdc[l_ac].fdc03) THEN
               IF g_fdc[l_ac].fdc03 != 'MISC' THEN
                  SELECT COUNT(*) INTO g_cnt FROM faj_file
                   WHERE faj02 = g_fdc[l_ac].fdc03 AND faj43 NOT IN ('X','5','6')
                     AND faj432 NOT IN ('X','5','6')    #FUN-AB0088 
                     AND faj39 !='0'    #TQC-C20272     
                  IF g_cnt = 0 THEN
                     CALL cl_err(g_fdc[l_ac].fdc03,'afa-041',0)
                     NEXT FIELD fdc03
                  END IF
               END IF
              #start FUN-5B0049
               IF p_cmd = 'a' OR g_fdc[l_ac].fdc03 != g_fdc_t.fdc03 THEN
                  IF NOT cl_null(g_fdc[l_ac].fdc032) THEN
                     SELECT COUNT(*) INTO g_cnt FROM faj_file
                      WHERE faj02  = g_fdc[l_ac].fdc03
                        AND faj022 = g_fdc[l_ac].fdc032
                  ELSE
                     SELECT COUNT(*) INTO g_cnt FROM faj_file
                      WHERE faj02  = g_fdc[l_ac].fdc03
                  END IF
                  IF g_cnt > 0 THEN
                     #-----MOD-7C0198---------
                     #IF NOT cl_null(g_fdc[l_ac].fdc032) THEN
                     #   SELECT faj06,faj24,faj33
                     #     INTO g_fdc[l_ac].fdc12,g_fdc[l_ac].fdc05,l_faj33
                     #     FROM faj_file
                     #    WHERE faj02  = g_fdc[l_ac].fdc03
                     #      AND faj022 = g_fdc[l_ac].fdc032
                     #ELSE
                     #   SELECT faj06,faj24,faj33
                     #     INTO g_fdc[l_ac].fdc12,g_fdc[l_ac].fdc05,l_faj33
                     #     FROM faj_file
                     #    WHERE faj02  = g_fdc[l_ac].fdc03
                     #END IF
                     IF NOT cl_null(g_fdc[l_ac].fdc032) THEN
                        SELECT faj06,faj33
                          INTO g_fdc[l_ac].fdc12,l_faj33
                          FROM faj_file
                         WHERE faj02  = g_fdc[l_ac].fdc03
                           AND faj022 = g_fdc[l_ac].fdc032
                        SELECT faj23 INTO l_faj23 FROM  faj_file
                         WHERE faj02  = g_fdc[l_ac].fdc03
                           AND faj022 = g_fdc[l_ac].fdc032
                        IF l_faj23 = '1' THEN
                           SELECT faj24 INTO g_fdc[l_ac].fdc05 FROM faj_file  
                            WHERE faj02  = g_fdc[l_ac].fdc03
                              AND faj022 = g_fdc[l_ac].fdc032
                        ELSE
                           SELECT faj20 INTO g_fdc[l_ac].fdc05 FROM faj_file  
                            WHERE faj02  = g_fdc[l_ac].fdc03
                              AND faj022 = g_fdc[l_ac].fdc032
                        END IF
                     ELSE
                        SELECT faj06,faj33
                          INTO g_fdc[l_ac].fdc12,l_faj33
                          FROM faj_file
                         WHERE faj02  = g_fdc[l_ac].fdc03
                        SELECT faj23 INTO l_faj23 FROM  faj_file
                         WHERE faj02  = g_fdc[l_ac].fdc03
                        IF l_faj23 = '1' THEN
                           SELECT faj24 INTO g_fdc[l_ac].fdc05 FROM faj_file  
                            WHERE faj02  = g_fdc[l_ac].fdc03
                        ELSE
                           SELECT faj20 INTO g_fdc[l_ac].fdc05 FROM faj_file  
                            WHERE faj02  = g_fdc[l_ac].fdc03
                        END IF
                     END IF
                     #-----END MOD-7C0198-----
                     CALL t500_fdc06(g_fdc[l_ac].fdc03,g_fdc[l_ac].fdc032,
                                     l_faj33) RETURNING g_fdc[l_ac].fdc06
                     IF cl_null(g_fdc[l_ac].fdc06) THEN
                        LET g_fdc[l_ac].fdc06=0
                     END IF
                  END IF
               END IF
              #end FUN-5B0049
            END IF
            CALL t5001_set_no_entry_b()
 
        AFTER FIELD fdc032  #附號
            #-----MOD-7C0205---------
            #IF NOT cl_null(g_fdc[l_ac].fdc032) THEN  
             IF g_fdc[l_ac].fdc032 IS NULL THEN
                LET g_fdc[l_ac].fdc032 = ' ' 
             END IF 
            #-----END MOD-7C0205-----
               IF g_fdc[l_ac].fdc03 != 'MISC' THEN
                  SELECT COUNT(*) INTO g_cnt FROM faj_file
                    WHERE faj02 = g_fdc[l_ac].fdc03
                      AND faj022= g_fdc[l_ac].fdc032
                      AND faj43 NOT IN ('X','5','6')
                      AND faj432 NOT IN ('X','5','6')   #FUN-AB0088 
                      AND faj39 !='0'        #NO:4985
                   IF g_cnt = 0 THEN
                      CALL cl_err(g_fdc[l_ac].fdc032,'afa-041',0)
                      NEXT FIELD fdc032
                   END IF
                  IF p_cmd = 'a' OR g_fdc[l_ac].fdc03 != g_fdc_t.fdc03 OR
                     g_fdc[l_ac].fdc032 != g_fdc_t.fdc032 THEN
                     SELECT COUNT(*) INTO g_cnt FROM faj_file
                      WHERE faj02 = g_fdc[l_ac].fdc03
                        AND faj022 = g_fdc[l_ac].fdc032
                     IF g_cnt > 0 THEN
                        #-----MOD-7C0198---------
                        #SELECT faj06,faj24,faj33
                        #  INTO g_fdc[l_ac].fdc12,g_fdc[l_ac].fdc05,l_faj33
                        #  FROM faj_file
                        # WHERE faj02 = g_fdc[l_ac].fdc03
                        #   AND faj022= g_fdc[l_ac].fdc032
                        SELECT faj06,faj33
                          INTO g_fdc[l_ac].fdc12,l_faj33
                          FROM faj_file
                         WHERE faj02 = g_fdc[l_ac].fdc03
                           AND faj022= g_fdc[l_ac].fdc032
                        SELECT faj23 INTO l_faj23 FROM faj_file
                         WHERE faj02 = g_fdc[l_ac].fdc03
                           AND faj022= g_fdc[l_ac].fdc032
                        IF l_faj23 = '1' THEN 
                           SELECT faj24 INTO g_fdc[l_ac].fdc05 FROM faj_file
                            WHERE faj02 = g_fdc[l_ac].fdc03
                              AND faj022= g_fdc[l_ac].fdc032
                        ELSE
                           SELECT faj20 INTO g_fdc[l_ac].fdc05 FROM faj_file
                            WHERE faj02 = g_fdc[l_ac].fdc03
                              AND faj022= g_fdc[l_ac].fdc032
                        END IF
                        #-----END MOD-7C0198-----
                         CALL t500_fdc06(g_fdc[l_ac].fdc03,g_fdc[l_ac].fdc032,
                                         l_faj33) RETURNING g_fdc[l_ac].fdc06
                     IF cl_null(g_fdc[l_ac].fdc06) THEN
                        LET g_fdc[l_ac].fdc06=0
                     END IF
                     SELECT fdb07,fdb09 INTO l_fdb07,l_fdb09 FROM fdb_file
                      WHERE fdb01 = g_fda.fda01
                        AND fdb02 = g_fdc[l_ac].fdc04
                     IF cl_null(l_fdb07) THEN LET l_fdb07=0 END IF
                     LET g_fdc[l_ac].fdc08 = l_fdb07
                    #IF NOT cl_null(l_fdb09) THEN                    #FUN-5B0049 mark
                     IF NOT cl_null(l_fdb09) AND l_fdb09 != 0 THEN   #FUN-5B0049
                        LET g_fdc[l_ac].fdc07 = g_fdc[l_ac].fdc06*
                                               (g_fda.fda10/100) *
                                               (l_fdb09/100)
                        LET g_fdc[l_ac].fdc09 = g_fdc[l_ac].fdc07 *
                                               (l_fdb07 / 1000) *
                                               ((g_fda.fda04 - g_fda.fda03) / 365)
                     ELSE
                        LET g_fdc[l_ac].fdc07 = g_fdc[l_ac].fdc06 *
                                                (g_fda.fda10/100)
                        LET g_fdc[l_ac].fdc09 = g_fdc[l_ac].fdc07 *
                                               (l_fdb07 / 1000) *
                                               ((g_fda.fda04 - g_fda.fda03) / 365)
                     END IF
                     #no.A010依幣別取位
                     LET g_fdc[l_ac].fdc07 = cl_digcut(g_fdc[l_ac].fdc07,g_azi04)
                     LET g_fdc[l_ac].fdc09 = cl_digcut(g_fdc[l_ac].fdc09,g_azi04)
                     #(end)
                   END IF
                 END IF
                END IF
            #-----MOD-7C0205---------
            ##-----MOD-750073---------
            #ELSE
            #   LET g_fdc[l_ac].fdc032 = ' ' 
            ##-----END MOD-750073-----
            #END IF
            #-----END MOD-7C0205-----
 
        AFTER FIELD fdc05
           IF NOT cl_null(g_fdc[l_ac].fdc05) THEN
              IF g_fdc[l_ac].fdc03 != 'MISC' THEN
                 SELECT COUNT(*) INTO g_cnt FROM faj_file
                  WHERE faj02 = g_fdc[l_ac].fdc03
                    AND faj022= g_fdc[l_ac].fdc032
                 IF g_cnt > 0 THEN
                    SELECT faj23,faj53 INTO l_faj23,l_faj53 FROM faj_file
                     WHERE faj02 = g_fdc[l_ac].fdc03
                       AND faj022= g_fdc[l_ac].fdc032
#--資產主檔雖是多部門分攤,但保險歸屬單一部門,所以取消多部門的check-----
                       CALL t500_fdc05('a')
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_fdc[l_ac].fdc05,g_errno,0)
                           NEXT FIELD fdc05
                        END IF
                 END IF
              END IF
           END IF
 
       #start FUN-5B0049
        AFTER FIELD fdc07
           IF g_fdc[l_ac].fdc07 != g_fdc_t.fdc07 THEN
              SELECT fdb09 INTO l_fdb09 FROM fdb_file
               WHERE fdb01 = g_fda.fda01
                 AND fdb02 = g_fdc[l_ac].fdc04
              IF NOT cl_null(l_fdb09) AND l_fdb09 != 0 THEN
                 LET g_fdc[l_ac].fdc09=g_fdc[l_ac].fdc07 *
                                      (g_fdc[l_ac].fdc08 / 1000) *
                                      (g_fda.fda10 / 100) *
                                      (l_fdb09 / 100) *
                                      ((g_fda.fda04-g_fda.fda03) / 365)
              ELSE
                 LET g_fdc[l_ac].fdc09=g_fdc[l_ac].fdc07 *
                                      (g_fdc[l_ac].fdc08 / 1000) *
                                      (g_fda.fda10 / 100) *
                                      ((g_fda.fda04-g_fda.fda03) / 365)
              END IF
              #依幣別取位
              LET g_fdc[l_ac].fdc09 = cl_digcut(g_fdc[l_ac].fdc09,g_azi04)
           END IF
       #end FUN-5B0049
 
        AFTER FIELD fdc08
           IF cl_null(g_fdc[l_ac].fdc08) THEN LET g_fdc[l_ac].fdc08=0 END IF
           IF NOT cl_null(g_fdc[l_ac].fdc08) THEN
              #No.TQC-970424--Add--Begin--#
              IF g_fdc[l_ac].fdc08 < 0 THEN
                 CALL cl_err(g_fdc[l_ac].fdc08,'axm-179',0)  
                 NEXT FIELD fdc08
              END IF
              #No.TQC-970424--Add--End--#           
              IF p_cmd='a' OR g_fdc[l_ac].fdc08 != g_fdc_t.fdc08 THEN
                 SELECT fdb09 INTO l_fdb09 FROM fdb_file
                  WHERE fdb01 = g_fda.fda01
                    AND fdb02 = g_fdc[l_ac].fdc04
                #IF NOT cl_null(l_fdb09) THEN                    #FUN-5B0049 mark
                 IF NOT cl_null(l_fdb09) AND l_fdb09 != 0 THEN   #FUN-5B0049
                    IF g_fdc[l_ac].fdc07 != g_fdc_t.fdc07 OR
                       g_fdc_t.fdc07 IS NULL THEN
                       LET g_fdc[l_ac].fdc09=g_fdc[l_ac].fdc07 *
                                            (g_fdc[l_ac].fdc08 / 1000) *
                                            (g_fda.fda10 / 100) *
                                            (l_fdb09 / 100) *
                                            ((g_fda.fda04-g_fda.fda03) / 365)
                    ELSE
                       LET g_fdc[l_ac].fdc09=g_fdc[l_ac].fdc07 *
                                            (g_fdc[l_ac].fdc08 / 1000) *
                                            ((g_fda.fda04-g_fda.fda03) / 365)
                    END IF
                 ELSE
                    IF g_fdc[l_ac].fdc07 != g_fdc_t.fdc07 OR
                       g_fdc_t.fdc07 IS NULL THEN
                       LET g_fdc[l_ac].fdc09=g_fdc[l_ac].fdc07 *
                                             (g_fda.fda10 / 100) *
                                             (g_fdc[l_ac].fdc08 / 1000) *
                                            ((g_fda.fda04-g_fda.fda03) / 365)
                    ELSE
                       LET g_fdc[l_ac].fdc09=g_fdc[l_ac].fdc07 *
                                             (g_fdc[l_ac].fdc08 / 1000) *
                                            ((g_fda.fda04-g_fda.fda03) / 365)
                    END IF
                 END IF
                 #no.A010依幣別取位
                 LET g_fdc[l_ac].fdc09 = cl_digcut(g_fdc[l_ac].fdc09,g_azi04)
                 #------MOD-5A0095 START----------
                 DISPLAY BY NAME g_fdc[l_ac].fdc09
                 #------MOD-5A0095 END------------
                 #(end)
               END IF
            END IF
            
        #No.TQC-970424--Add--Begin--#    
        AFTER FIELD fdc09
           IF NOT cl_null(g_fdc[l_ac].fdc09) THEN
              IF g_fdc[l_ac].fdc09 < 0 THEN
                 CALL cl_err(g_fdc[l_ac].fdc09,'axm-179',0)  
                 NEXT FIELD fdc09
              END IF
           END IF
        #No.TQC-970424--Add--End--#             
 
        BEFORE DELETE                            #是否取消單身
            IF g_fdc_t.fdc02 > 0 AND g_fdc_t.fdc02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fdc_file WHERE fdc01 = g_fda.fda01
                                       AND fdc02 = g_fdc_t.fdc02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fdc_t.fdc02,SQLCA.sqlcode,0)   #No.FUN-660136
                    CALL cl_err3("del","fdc_file",g_fda.fda01,g_fdc_t.fdc02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    EXIT INPUT
                END IF
                COMMIT WORK
                LET g_rec_b2=g_rec_b2-1
                DISPLAY g_rec_b2 TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fdc[l_ac].* = g_fdc_t.*
               CLOSE t500_bcl2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fdc[l_ac].fdc02,-263,1)
               LET g_fdc[l_ac].* = g_fdc_t.*
            ELSE
               UPDATE fdc_file SET
                 fdc01=g_fda.fda01,fdc02=g_fdc[l_ac].fdc02,
                 fdc03=g_fdc[l_ac].fdc03,fdc032=g_fdc[l_ac].fdc032,
                 fdc04=g_fdc[l_ac].fdc04,fdc05=g_fdc[l_ac].fdc05,
                 fdc06=g_fdc[l_ac].fdc06,fdc07=g_fdc[l_ac].fdc07,
                 fdc08=g_fdc[l_ac].fdc08,fdc09=g_fdc[l_ac].fdc09,
                 fdc10=g_fdc[l_ac].fdc10,fdc11=g_fdc[l_ac].fdc11,
                 fdc12=g_fdc[l_ac].fdc12
                 WHERE fdc01=g_fda.fda01 AND fdc02=g_fdc_t.fdc02
 
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('upd fdc',SQLCA.sqlcode,0)   #No.FUN-660136
                  CALL cl_err3("upd","fdc_file",g_fda.fda01,g_fdc_t.fdc02,SQLCA.sqlcode,"","upd fdc",1)  #No.FUN-660136
                  LET g_fdc[l_ac].* = g_fdc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
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
               IF p_cmd='u' THEN
                  LET g_fdc[l_ac].* = g_fdc_t.*
               END IF
               CLOSE t500_bcl2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #LET g_fdc_t.* = g_fdc[l_ac].* 
            CLOSE t500_bcl2
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fdc02) AND l_ac > 1 THEN
                LET g_fdc[l_ac].* = g_fdc[l_ac-1].*
                LET g_fdc[l_ac].fdc02 = NULL
                NEXT FIELD fdc02
            END IF
        ON ACTION controlp
           CASE
              WHEN INFIELD(fdc05)  #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fdc[l_ac].fdc05
                 CALL cl_create_qry() RETURNING g_fdc[l_ac].fdc05
#                 CALL FGL_DIALOG_SETBUFFER( g_fdc[l_ac].fdc05 )
                 DISPLAY g_fdc[l_ac].fdc05 TO fdc05
                 NEXT FIELD fdc05
              WHEN INFIELD(fdc03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fdc[l_ac].fdc03
                 LET g_qryparam.default2 = g_fdc[l_ac].fdc032
                 CALL cl_create_qry() RETURNING
                      g_fdc[l_ac].fdc03,g_fdc[l_ac].fdc032
#                 CALL FGL_DIALOG_SETBUFFER(g_fdc[l_ac].fdc03)
#                 CALL FGL_DIALOG_SETBUFFER( g_fdc[l_ac].fdc032)
                 DISPLAY g_fdc[l_ac].fdc03 TO fdc03
                 DISPLAY g_fdc[l_ac].fdc032 TO fdc032
                 NEXT FIELD fdc03
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      CALL t500_fdb_sum()
      CLOSE t500_cl
      CLOSE t500_bcl2
      COMMIT WORK
END FUNCTION
FUNCTION t5001_set_entry_b()
    IF INFIELD(fdc03) THEN
       CALL cl_set_comp_entry("fdc12",TRUE)
    END IF
END FUNCTION
 
FUNCTION t5001_set_no_entry_b()
 
    IF INFIELD(fdc03) THEN
       IF g_fdc[l_ac].fdc03 != 'MISC' THEN
          CALL cl_set_comp_entry("fdc12",FALSE)
       END IF
    END IF
END FUNCTION
 
 
FUNCTION t500_fdb_sum()
  DEFINE l_fdb   RECORD LIKE fdb_file.*,
         l_fdc09   LIKE fdc_file.fdc09
 
    DECLARE t500_fdb_sum CURSOR FOR
     SELECT * FROM fdb_file WHERE fdb01 = g_fda.fda01
    FOREACH t500_fdb_sum INTO l_fdb.*
        SELECT SUM(fdc09) INTO l_fdc09 FROM fdc_file
         WHERE fdc01 = g_fda.fda01
           AND fdc04 = l_fdb.fdb02
        IF cl_null(l_fdc09) THEN LET l_fdc09 = 0 END IF
        IF l_fdc09 != l_fdb.fdb08 THEN  #明細的保險費與標的物的保險費不合
           CALL cl_err(l_fdc09,'afa-373',0)
          EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore fdb',STATUS,1) END IF
 
END FUNCTION
 
FUNCTION t500_fdc05(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
 
     LET g_errno = ' '
     SELECT gem01,gemacti INTO l_gem01,l_gemacti
       FROM gem_file
      WHERE gem01 = g_fdc[l_ac].fdc05
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION
 
FUNCTION t500_fdc052(p_cmd,l_faj53)
DEFINE p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_cnt        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_faj53      LIKE faj_file.faj53
 
      LET g_errno = ' '
      IF cl_null(l_faj53) THEN
         CALL cl_err(' ',STATUS,0)
      ELSE
         SELECT COUNT(*) INTO l_cnt
           FROM fad_file
          WHERE fad04 = g_fdc[l_ac].fdc05
            AND fad03 = l_faj53
            AND fadacti = 'Y'
            AND fad07 = '1'    #FUN-AB0088   
         IF l_cnt = 0 THEN LET g_errno = 'afa-342' END IF
      END IF
END FUNCTION
 
FUNCTION t500_fdc06(p_faj02,p_faj022,p_faj33)
  DEFINE p_faj33      LIKE faj_file.faj33,  #未折金額
         p_faj02      LIKE faj_file.faj02,
         p_faj022     LIKE faj_file.faj022,
         l_fan07      LIKE fan_file.fan07,
         l_faj31      LIKE faj_file.faj31,
         l_tot        LIKE type_file.num20_6,                   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
         l_yy1,l_yy2  LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_mm1,l_mm2  LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_sql        STRING   #FUN-5B0049
 
    LET l_yy1 = g_fda.fda09
    LET l_yy2 = YEAR(g_today)
    LET l_mm1 = g_fda.fda091
    LET l_mm2 = MONTH(g_today)
    LET l_tot = 0
   #start FUN-5B0049
   #DECLARE t500_fdc06 CURSOR FOR
   # SELECT fan07 FROM fan_file
   #  WHERE fan01 = p_faj02
   #    AND fan02 = p_faj022
   #    AND fan03 BETWEEN l_yy1 AND l_yy2
   #    AND fan04 > l_mm1 AND fan04 <= l_mm2
   #    AND fan041 = '1'
    IF NOT cl_null( p_faj022) THEN
       LET l_sql = "SELECT fan07 FROM fan_file ",
                   " WHERE fan01 = '",p_faj02,"'",
                   "   AND fan02 = '",p_faj022,"'",
                   "   AND fan03 BETWEEN ",l_yy1," AND ",l_yy2,
                   "   AND fan04 > ",l_mm1," AND fan04 <= ",l_mm2,
                   "   AND fan041 = '1'"
    ELSE
       LET l_sql = "SELECT fan07 FROM fan_file ",
                   " WHERE fan01 = '",p_faj02,"'",
                   "   AND fan03 BETWEEN ",l_yy1," AND ",l_yy2,
                   "   AND fan04 > ",l_mm1," AND fan04 <= ",l_mm2,
                   "   AND fan041 = '1'"
    END IF
    PREPARE t500_fdc06_pre FROM l_sql
    DECLARE t500_fdc06 CURSOR FOR t500_fdc06_pre
   #end FUN-5B0049
    FOREACH t500_fdc06 INTO l_fan07
       IF cl_null(l_fan07) THEN LET l_fan07 = 0 END IF
       LET l_tot = l_tot + l_fan07
    END FOREACH
    IF STATUS THEN CALL cl_err('foreach',STATUS,0) END IF
    LET p_faj33 = p_faj33 + l_tot   #未折餘額=未折減額+每月攤提
    #no.A010依幣別取位
    LET p_faj33 = cl_digcut(p_faj33,g_azi04)
    RETURN p_faj33
 
END FUNCTION
 
FUNCTION t500_b2_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fdc02,fdc03,fdc032,fdc04,fdc05,fdc06,fdc07,fdc08,
                       fdc09,fdc10,fdc11,fdc12
         FROM s_fdc[1].fdc02,s_fdc[1].fdc03,s_fdc[1].fdc032,s_fdc[1].fdc04,
              s_fdc[1].fdc05,s_fdc[1].fdc06,s_fdc[1].fdc07,s_fdc[1].fdc08,
              s_fdc[1].fdc09,s_fdc[1].fdc10,s_fdc[1].fdc11,s_fdc[1].fdc12
 
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
    CALL t500_b2_fill(l_wc2)
END FUNCTION
 
FUNCTION t500_b2_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fdc02,fdc04,fdc03,fdc032,fdc12,fdc05,fdc06,fdc07,fdc08,",
        " fdc09,fdc10,fdc11",
        "  FROM fdc_file",
        " WHERE fdc01  ='",g_fda.fda01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t500_pb2 FROM g_sql
    DECLARE fdc_curs                       #SCROLL CURSOR
        CURSOR FOR t500_pb2
    CALL g_fdc.clear()
    LET g_rec_b2 = 0
    LET g_cnt = 1
    FOREACH fdc_curs INTO g_fdc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_fdc.deleteElement(g_cnt)
    LET g_rec_b2=g_cnt - 1
END FUNCTION
 
FUNCTION t500_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fdc TO s_fdc.* ATTRIBUTE(COUNT=g_rec_b2)
 
      BEFORE ROW
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
{
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
            CALL t500_fetch('F')
         LET g_action_choice="first"
         EXIT DISPLAY
      ON ACTION previous
      ON ACTION jump
         LET g_action_choice="jump"
         EXIT DISPLAY
      ON ACTION next
      ON ACTION last
         LET g_action_choice="last"
         EXIT DISPLAY
}
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
{
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
}
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
{
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
}
      #@ON ACTION 保險金額計算
      ON ACTION premium_calculation
         LET g_action_choice="premium_calculation"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()  #TQC-C20272
         EXIT DISPLAY           #TQC-C20272
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002,003> #

