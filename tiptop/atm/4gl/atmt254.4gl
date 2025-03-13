# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmt254.4gl
# Descriptions...: 集團調撥申請單維護作業
# Date & Author..: 06/02/23 By ice
# Modify.........: No.FUN-A10099 10/01/22 By Carier 拋轉邏輯重整&程序清理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A20063 10/02/26 By Carrier 流通配销时,apmi000没有设置,则取ART模块的默认设置
# Modify.........: No.TQC-A30048 10/03/12 By Cockroach ADD orig/oriu
# Modify.........: No.FUN-A30063 10/03/19 By Cockroach ADD conu/cond/cont
# Modify.........: No:FUN-A30056 10/04/13 By Carrier call p801时,给是否IN TRANSACTION标志位
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-A80018 10/08/04 By Carrier rye_file选出货单别时,性质变为axm/50
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0078 11/11/19 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.TQC-B10010 11/01/06 By lixia 去掉畫面上重複的欄位tsk24,修改經銷相關
# Modify.........: No.MOD-B40030 11/04/06 By lilingyu 過賬時報錯:傳入空值失敗
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0084 11/11/24 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-BB0083 11/12/21 By xujing 增加數量欄位小數取位
# Modify.........: NO:TQC-BB0217 11/11/25 By SunLM 增加審核人員開窗查詢
# Modify.........: No:FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C20048 12/02/09 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C20068 12/02/13 By fengrui  增加數量欄位小數取位 
# Modify.........: No:TQC-C20155 12/02/17 By yangxf 單頭部門別欄位輸入完畢後未判斷資料有問題
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:CHI-C80041 13/01/03 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D10081 13/01/21 By qiull 增加資料清單
# Modify.........: No:TQC-D10084 13/01/25 By qiull 資料清單頁簽跳轉問題
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20015 13/03/26 By xuxz 修改取消確認邏輯
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D70073 13/07/22 By SunLM 临时表p801_file，且都链接了sapmp801，应该在临时表创建时同步新增一个栏位so_price2

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_tsk               RECORD LIKE tsk_file.*
DEFINE g_tsk_t             RECORD LIKE tsk_file.*
DEFINE g_tsk_o             RECORD LIKE tsk_file.*
DEFINE g_tsk01_t           LIKE tsk_file.tsk01        #調撥申請單號
DEFINE g_pmm               RECORD LIKE pmm_file.*
DEFINE g_oga               RECORD LIKE oga_file.*
DEFINE g_oea               RECORD LIKE oea_file.*
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_wc                STRING
DEFINE g_wc2               STRING
DEFINE g_sql               STRING
DEFINE g_tsl               DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                           tsl02     LIKE tsl_file.tsl02,       #項次
                           tsl13     LIKE tsl_file.tsl13,       #來源項次 #No.FUN-870007
                           tsl03     LIKE tsl_file.tsl03,       #料件編號
                           #No.TQC-650090--begin
                           att00     LIKE imx_file.imx00,
                           att01     LIKE imx_file.imx01,
                           att01_c   LIKE imx_file.imx01,
                           att02     LIKE imx_file.imx02,
                           att02_c   LIKE imx_file.imx02,
                           att03     LIKE imx_file.imx03,
                           att03_c   LIKE imx_file.imx03,
                           att04     LIKE imx_file.imx04,
                           att04_c   LIKE imx_file.imx04,
                           att05     LIKE imx_file.imx05,
                           att05_c   LIKE imx_file.imx05,
                           att06     LIKE imx_file.imx06,
                           att06_c   LIKE imx_file.imx06,
                           att07     LIKE imx_file.imx07,
                           att07_c   LIKE imx_file.imx07,
                           att08     LIKE imx_file.imx08,
                           att08_c   LIKE imx_file.imx08,
                           att09     LIKE imx_file.imx09,
                           att09_c   LIKE imx_file.imx09,
                           att10     LIKE imx_file.imx10,
                           att10_c   LIKE imx_file.imx10,
                           #No.TQC-650090--end
                           ima02     LIKE ima_file.ima02,       #品名規格
                           ima135    LIKE ima_file.ima135,      #產品條碼編號
                           tsl04     LIKE tsl_file.tsl04,       #單位
                           tsl05     LIKE tsl_file.tsl05,       #數量
                           tsl10     LIKE tsl_file.tsl10,       #單位二
                           tsl11     LIKE tsl_file.tsl11,       #單位二轉換率
                           tsl12     LIKE tsl_file.tsl12,       #單位二數量
                           tsl07     LIKE tsl_file.tsl07,       #單位一
                           tsl08     LIKE tsl_file.tsl08,       #單位一轉換率
                           tsl09     LIKE tsl_file.tsl09        #單位一數量
                           END RECORD
DEFINE g_tsl_t             RECORD                     #程式變數 (舊值)
                           tsl02     LIKE tsl_file.tsl02,       #項次
                           tsl13     LIKE tsl_file.tsl13,       #來源項次 #No.FUN-870007
                           tsl03     LIKE tsl_file.tsl03,       #料件編號
                           #No.TQC-650090--begin
                           att00     LIKE imx_file.imx00,
                           att01     LIKE imx_file.imx01,
                           att01_c   LIKE imx_file.imx01,
                           att02     LIKE imx_file.imx02,
                           att02_c   LIKE imx_file.imx02,
                           att03     LIKE imx_file.imx03,
                           att03_c   LIKE imx_file.imx03,
                           att04     LIKE imx_file.imx04,
                           att04_c   LIKE imx_file.imx04,
                           att05     LIKE imx_file.imx05,
                           att05_c   LIKE imx_file.imx05,
                           att06     LIKE imx_file.imx06,
                           att06_c   LIKE imx_file.imx06,
                           att07     LIKE imx_file.imx07,
                           att07_c   LIKE imx_file.imx07,
                           att08     LIKE imx_file.imx08,
                           att08_c   LIKE imx_file.imx08,
                           att09     LIKE imx_file.imx09,
                           att09_c   LIKE imx_file.imx09,
                           att10     LIKE imx_file.imx10,
                           att10_c   LIKE imx_file.imx10,
                           #No.TQC-650090--end
                           ima02     LIKE ima_file.ima02,       #品名規格
                           ima135    LIKE ima_file.ima135,      #產品條碼編號
                           tsl04     LIKE tsl_file.tsl04,       #單位
                           tsl05     LIKE tsl_file.tsl05,       #數量
                           tsl10     LIKE tsl_file.tsl10,       #單位二
                           tsl11     LIKE tsl_file.tsl11,       #單位二轉換率
                           tsl12     LIKE tsl_file.tsl12,       #單位二數量
                           tsl07     LIKE tsl_file.tsl07,       #單位一
                           tsl08     LIKE tsl_file.tsl08,       #單位一轉換率
                           tsl09     LIKE tsl_file.tsl09        #單位一數量
                           END RECORD
DEFINE g_tsl_o             RECORD                     #程式變數 (舊值)
                           tsl02     LIKE tsl_file.tsl02,       #項次
                           tsl13     LIKE tsl_file.tsl13,       #來源項次 #No.FUN-870007
                           tsl03     LIKE tsl_file.tsl03,       #料件編號
                           #No.TQC-650090--begin
                           att00     LIKE imx_file.imx00,
                           att01     LIKE imx_file.imx01,
                           att01_c   LIKE imx_file.imx01,
                           att02     LIKE imx_file.imx02,
                           att02_c   LIKE imx_file.imx02,
                           att03     LIKE imx_file.imx03,
                           att03_c   LIKE imx_file.imx03,
                           att04     LIKE imx_file.imx04,
                           att04_c   LIKE imx_file.imx04,
                           att05     LIKE imx_file.imx05,
                           att05_c   LIKE imx_file.imx05,
                           att06     LIKE imx_file.imx06,
                           att06_c   LIKE imx_file.imx06,
                           att07     LIKE imx_file.imx07,
                           att07_c   LIKE imx_file.imx07,
                           att08     LIKE imx_file.imx08,
                           att08_c   LIKE imx_file.imx08,
                           att09     LIKE imx_file.imx09,
                           att09_c   LIKE imx_file.imx09,
                           att10     LIKE imx_file.imx10,
                           att10_c   LIKE imx_file.imx10,
                           #No.TQC-650090--end
                           ima02     LIKE ima_file.ima02,       #品名規格
                           ima135    LIKE ima_file.ima135,      #產品條碼編號
                           tsl04     LIKE tsl_file.tsl04,       #單位
                           tsl05     LIKE tsl_file.tsl05,       #數量
                           tsl10     LIKE tsl_file.tsl10,       #單位二
                           tsl11     LIKE tsl_file.tsl11,       #單位二轉換率
                           tsl12     LIKE tsl_file.tsl12,       #單位二數量
                           tsl07     LIKE tsl_file.tsl07,       #單位一
                           tsl08     LIKE tsl_file.tsl08,       #單位一轉換率
                           tsl09     LIKE tsl_file.tsl09        #單位一數量
                           END RECORD
DEFINE g_buf               LIKE type_file.chr1000
DEFINE g_t1                LIKE oay_file.oayslip
DEFINE g_rec_b             LIKE type_file.num5                  #單身筆數
DEFINE l_ac                LIKE type_file.num5                  #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_argv1	           LIKE tsk_file.tsk01
DEFINE g_argv2             STRING

#No.TQC-650090--begin
DEFINE l_check             LIKE type_file.chr1
DEFINE arr_detail          DYNAMIC ARRAY OF RECORD
                           imx00   LIKE imx_file.imx00,
                           imx     ARRAY[10] OF LIKE imx_file.imx01
                           END RECORD
DEFINE lr_agc              DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE lg_smy62            LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別
DEFINE lg_group            LIKE smy_file.smy62   #當前單身中采用的組別
#No.TQC-650090--end
#FUN-910088--add--start--
DEFINE g_tsl04_t           LIKE tsl_file.tsl04   
DEFINE g_tsl07_t           LIKE tsl_file.tsl07
DEFINE g_tsl10_t           LIKE tsl_file.tsl10
#FUN-910088--add--end--
#FUN-D10081---add---str---
DEFINE g_tsk_l DYNAMIC ARRAY OF RECORD
               tsk01          LIKE tsk_file.tsk01,
               tsk02          LIKE tsk_file.tsk02,
               tsk18          LIKE tsk_file.tsk18,
               tsk19          LIKE tsk_file.tsk19,
               tsk08          LIKE tsk_file.tsk08,
               gen02          LIKE gen_file.gen02,
               tsk09          LIKE tsk_file.tsk09,
               gem02          LIKE gem_file.gem02,
               tsk05          LIKE tsk_file.tsk05,
               tskconu        LIKE tsk_file.tskconu,
               tskconu_desc   LIKE tsk_file.tskconu,
               tskcond        LIKE tsk_file.tskcond,
               tskcont        LIKE tsk_file.tskcont,
               tsk06          LIKE tsk_file.tsk06,
               tsk03          LIKE tsk_file.tsk03,
               azp02          LIKE azp_file.azp02,
               tsk17          LIKE tsk_file.tsk17,
               imd02          LIKE imd_file.imd02,
               tsk20          LIKE tsk_file.tsk20,
               tsk21          LIKE tsk_file.tsk21,
               tsk22          LIKE tsk_file.tsk22,
               tsk10          LIKE tsk_file.tsk10
               END RECORD,
        l_ac4      LIKE type_file.num5,
        g_rec_b4   LIKE type_file.num5,
        g_action_flag  STRING
DEFINE   w     ui.Window
DEFINE   f     ui.Form
DEFINE   page  om.DomNode
#FUN-D10081---add---end---

MAIN
   OPTIONS
      INPUT NO WRAP
      DEFER INTERRUPT

   LET g_argv1=ARG_VAL(1)  #No:TQC-630072
   LET g_argv2=ARG_VAL(2)  #No:TQC-630072

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW t254_w WITH FORM "atm/42f/atmt254"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #No.TQC-650090--begin
   #初始化界面的樣式(沒有任何默認屬性組)
   LET lg_smy62 = ''
   LET lg_group = ''
   CALL t254_refresh_detail()
   #No.TQC-650090--end

   CALL t254_def_form()
   #No:TQC-630072
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t254_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t254_a()
            END IF
      END CASE
   END IF
   #No:TQC-630072 ---end---
   CALL t254()
   CLOSE WINDOW t254_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN

FUNCTION t254()
   INITIALIZE g_tsk.*   TO NULL
   INITIALIZE g_tsk_t.* TO NULL
   INITIALIZE g_tsk_o.* TO NULL
   CALL t254_lock_cur()
   CALL t254_menu()
END FUNCTION

FUNCTION t254_lock_cur()
   LET g_forupd_sql = " SELECT * FROM tsk_file WHERE tsk01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t254_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
END FUNCTION

FUNCTION t254_cs()
   DEFINE l_tsk03  LIKE tsk_file.tsk03
   DEFINE l_tsk06  LIKE tsk_file.tsk06

   CLEAR FORM
   CALL g_tsl.clear()

   IF cl_null(g_argv1) THEN               #No.TQC-630072
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_tsk.* TO NULL          #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON
         tsk01,tsk02,tsk18,tsk19,tsk08,tsk09,
         #tsk23,tsk24,tsk25,tsk26,tskplant,  #No.FUN-870007
         tsk23,tsk25,tsk26,tskplant,   #TQC-B10010 drop tsk24
         tsk05,tsk06,tsk03,tsk17,
         tsk20,tsk21,tsk22,tsk10,tskuser,tskgrup,tskmodu,tskdate,tskacti
        ,tskoriu,tskorig                   #TQC-A30048 ADD
        ,tskconu,tskcond,tskcont           #FUN-A30063 ADD

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION controlp
            CASE
               WHEN INFIELD(tsk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tsk"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsk01
                  NEXT FIELD tsk01
               WHEN INFIELD(tsk08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsk08
                  NEXT FIELD tsk08
               WHEN INFIELD(tsk09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsk09
                  NEXT FIELD tsk09
               WHEN INFIELD(tsk03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_azp"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsk03
                  LET l_tsk03 = g_qryparam.multiret
                  NEXT FIELD tsk03
               WHEN INFIELD(tsk17)
                  CALL q_m_imd(TRUE,FALSE,g_tsk.tsk17,'S',l_tsk03)
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsk17
                  NEXT FIELD tsk17
               #No.FUN-870007-start-
#TQC-B10010 mark--str--
#               WHEN INFIELD(tsk24)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form  = "q_tsk24"
#                  LET g_qryparam.state = "c"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO tsk24
#                  NEXT FIELD tsk24
#TQC-B10010 mark--end--
               WHEN INFIELD(tsk25)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tsk25"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsk25
                  NEXT FIELD tsk25
               WHEN INFIELD(tskplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_azp"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tskplant
                  NEXT FIELD tskplant
               #No.FUN-870007--end--
#TQC-BB0217  start
               WHEN INFIELD(tskconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tskconu
                  NEXT FIELD tskconu 
#TQC-BB0217 end
            END CASE
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF

      CONSTRUCT g_wc2 ON tsl02,tsl13,tsl03,tsl04,tsl05,tsl10,tsl11,tsl12,
                         tsl07,tsl08,tsl09
                    FROM s_tsl[1].tsl02,s_tsl[1].tsl13,s_tsl[1].tsl03,
                         s_tsl[1].tsl04,s_tsl[1].tsl05,s_tsl[1].tsl10,
                         s_tsl[1].tsl11,s_tsl[1].tsl12,s_tsl[1].tsl07,
                         s_tsl[1].tsl08,s_tsl[1].tsl09

         ON ACTION controlp
            CASE
               WHEN INFIELD(tsl03)
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form  = "q_ima"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                  DISPLAY g_qryparam.multiret TO tsl03
                  NEXT FIELD tsl03
               WHEN INFIELD(tsl04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gfe"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsl04
                  NEXT FIELD tsl04
               WHEN INFIELD(tsl10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gfe"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsl10
                  NEXT FIELD tsl10
               WHEN INFIELD(tsl07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gfe"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tsl07
                  NEXT FIELD tsl07
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF

   #--No:TQC-630072
   ELSE
      LET g_wc =" tsk01 = '",g_argv1,"'"    #No:TQC-630072
      LET g_wc2 =" 1=1 "                    #No:TQC-630072
   END IF
   #--No:TQC-630072

   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tskuser', 'tskgrup')

   IF g_wc2 = ' 1=1' THEN
      LET g_sql = "SELECT tsk01 ",
                  "  FROM tsk_file ",
                  " WHERE ",g_wc CLIPPED,
                  " ORDER BY tsk01"
   ELSE
      LET g_sql = "SELECT DISTINCT tsk_file.tsk01",
                  "  FROM tsk_file,tsl_file ",
                  " WHERE tsk01=tsl01",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " ORDER BY tsk01"
   END IF
   PREPARE t254_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t254_cs SCROLL CURSOR WITH HOLD FOR t254_prepare
   DECLARE t254_fill_cs CURSOR WITH HOLD FOR t254_prepare   #FUN-D10081 add
   IF g_wc2 = ' 1=1' THEN
      LET g_sql = " SELECT COUNT(DISTINCT tsk01) FROM tsk_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql = " SELECT COUNT(DISTINCT tsk01) FROM tsk_file,tsl_file ",
                  "  WHERE ",g_wc CLIPPED,
                  "    AND ",g_wc2 CLIPPED,
                  "    AND tsk01 = tsl01 "
   END IF
   PREPARE t254_precount FROM g_sql
   DECLARE t254_count CURSOR FOR t254_precount
END FUNCTION

FUNCTION t254_menu()

   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN      #FUN-D10081 add
         CALL t254_bp("G")
      #FUN-D10081---add---str---
      ELSE 
         CALL t254_list_fill()
         CALL t254_bp2("G")
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT tsk_file.* INTO g_tsk.*
              FROM tsk_file
             WHERE tsk01 = g_tsk_l[l_ac4].tsk01
         END IF 
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET g_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t254_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("page_main", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("page_main", TRUE)
         END IF
      END IF
      #FUN-D10081---add---end---
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL t254_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t254_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL t254_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL t254_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t254_x()
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN
               CALL t254_copy()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN
               CALL t254_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t254_out()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            LET w = ui.Window.getCurrent()   #FUN-D10081 add
            LET f = w.getForm()              #FUN-D10081 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN           #FUN-D10081 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")                         #FUN-D10081 add
                  #CALL cl_export_to_excel                                          #FUN-D10081 mark
                  #(ui.Interface.getRootNode(),base.TypeInfo.create(g_tsl),'','')   #FUN-D10081 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tsl),'','')   #FUN-D10081 add
               END IF
            #FUN-D10081---add---str---
            END IF 
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tsk_l),'','')
               END IF
            END IF
            #FUN-D10081---add---end---     
  
         WHEN "confirm"        #審核
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1 =' ') THEN
               CALL t254_y()
            END IF

         WHEN "undo_confirm"   #取消審核
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN
               CALL t254_xy()
            END IF

         WHEN "triangletrade"
            IF cl_chk_act_auth() THEN
               CALL t254_v()
            END IF

         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t254_post()
            END IF

         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t254_p2()
            END IF

         WHEN "qry_lot"
            CALL t254_qry_lot(FALSE,'QRY')

         #No:FUN-6B0043-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tsk.tsk01 IS NOT NULL THEN
                 LET g_doc.column1 = "tsk01"
                 LET g_doc.value1 = g_tsk.tsk01
                 CALL cl_doc()
               END IF
         END IF
         #No:FUN-6B0043-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t254_c(1)
               CALL t254_field_pic()
            END IF
         #CHI-C80041---end 
         #FUN-D20039 ---------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t254_c(2)
               CALL t254_field_pic()
            END IF
         #FUN-D20039 ---------end
      END CASE
   END WHILE
   CLOSE t254_cs
END FUNCTION

FUNCTION t254_a()
   DEFINE li_result       LIKE type_file.num5
   DEFINE l_azp02         LIKE azp_file.azp02          #No.FUN-870007

   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清畫面欄位內容
   CALL g_tsl.clear()
   INITIALIZE g_tsk.* LIKE tsk_file.*
   LET g_tsk01_t     = NULL
   LET g_tsk.tsk02   = g_today
   LET g_tsk.tsk03   = g_plant
   LET g_tsk.tsk05   = '1'
   LET g_tsk.tsk08   = g_user
   LET g_tsk.tsk09   = g_grup
   LET g_tsk.tsk18   = g_today+1
   LET g_tsk.tsk20   = '0'
   LET g_tsk.tsk21   = 0
   LET g_tsk.tsk22   = 0
   #No.FUN-870007-start-
   LET g_tsk.tskplant = g_plant
   LET g_tsk.tsklegal = g_legal
   LET g_tsk.tsk23 = '1'
   #LET g_tsk.tsk24 = g_plant   #TQC-B10010
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
   #DISPLAY l_azp02,l_azp02 TO tsk24_desc,tsk930_desc
   DISPLAY l_azp02 TO tsk930_desc #TQC-B10010
   #No.FUN-870007--end--
   LET g_tsk.tskuser = g_user
   LET g_tsk.tskoriu = g_user  #FUN-980030
   LET g_tsk.tskorig = g_grup  #FUN-980030
   LET g_data_plant  = g_plant #FUN-980030
   LET g_tsk.tskgrup = g_grup
   LET g_tsk.tskdate = g_today
   LET g_tsk.tskacti = 'Y'
   LET g_tsk_t.* = g_tsk.*
   LET g_tsk_o.* = g_tsk.*
   CALL cl_opmsg('a')
   WHILE TRUE
      #No:TQC-630072 --start--
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_tsk.tsk01 = g_argv1
      END IF
      #No:TQC-630072 ---end---
      CALL t254_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_tsk.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_tsl.clear()
         EXIT WHILE
      END IF
      IF g_tsk.tsk01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF

      #輸入後, 若該單據需自動編號, 并且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("apm",g_tsk.tsk01,g_tsk.tsk02,"","tsk_file","tsk01","","","")
           RETURNING li_result,g_tsk.tsk01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_tsk.tsk01

      INSERT INTO tsk_file VALUES(g_tsk.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)         #FUN-B80061    ADD
         ROLLBACK WORK
        # CALL cl_err3("ins","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)        #FUN-B80061    MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         LET g_tsk_t.* = g_tsk.*               # 保存上筆資料
         SELECT tsk01 INTO g_tsk.tsk01 FROM tsk_file
          WHERE tsk01 = g_tsk.tsk01
      END IF
      CALL t254_v()                            #多角貿易流程代碼
      CALL g_tsl.clear()
      LET g_rec_b=0
      CALL t254_b()
      EXIT WHILE
   END WHILE
   LET g_wc=' '
END FUNCTION

FUNCTION t254_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE li_result       LIKE type_file.num5
   DEFINE l_azp02         LIKE azp_file.azp02
   DEFINE l_imd02         LIKE imd_file.imd02
   DEFINE l_gen02         LIKE gen_file.gen02
   DEFINE l_gem02         LIKE gem_file.gem02

   DISPLAY BY NAME g_tsk.tsk02,g_tsk.tsk18,g_tsk.tsk03,
                   g_tsk.tsk05,g_tsk.tsk08,g_tsk.tsk09,
                   g_tsk.tsk20,g_tsk.tsk21,g_tsk.tsk22,
                   #g_tsk.tsk23,g_tsk.tsk24,g_tsk.tskplant,      #No.FUN-870007
                   g_tsk.tsk23,g_tsk.tskplant,                   #TQC-B10010
                   g_tsk.tskuser,g_tsk.tskmodu,
                   g_tsk.tskgrup,g_tsk.tskdate,g_tsk.tskacti
                  ,g_tsk.tskoriu,g_tsk.tskorig                   #TQC-A30048 ADD 
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME
      g_tsk.tsk01,g_tsk.tsk02,g_tsk.tsk18,g_tsk.tsk19,
      #g_tsk.tsk08,g_tsk.tsk09,g_tsk.tsk24,g_tsk.tsk03,g_tsk.tsk17,  #No.FUN-870007
      g_tsk.tsk08,g_tsk.tsk09,g_tsk.tsk03,g_tsk.tsk17,               #TQC-B10010
      g_tsk.tsk10
      WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t254_set_entry(p_cmd)
         CALL t254_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tsk01")
         CALL t254_bshow()

      AFTER FIELD tsk01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_tsk.tsk01) THEN
            #No.TQC-650090--begin
            LET g_t1 = s_get_doc_no(g_tsk.tsk01)
            IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN
               #讀取smy_file中指定作業對應的默認屬性群組
               SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1
               #刷新界面顯示
               CALL t254_refresh_detail()
            ELSE
               LET lg_smy62 = ''
            END IF
            #No.TQC-650090--end

            CALL s_check_no("apm",g_tsk.tsk01,g_tsk01_t,"9","tsk_file","tsk01","")
                 RETURNING li_result,g_tsk.tsk01
            DISPLAY BY NAME g_tsk.tsk01
            IF (NOT li_result) THEN
               LET g_tsk.tsk01=g_tsk_o.tsk01
               NEXT FIELD tsk01
            END IF
         #No.TQC-650090--begin
         ELSE
            IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
               LET lg_smy62 = ''
               CALL t254_refresh_detail()
            END IF
         #No.TQC-650090--begin
         END IF

      AFTER FIELD tsk08
         IF NOT cl_null(g_tsk.tsk08) THEN
            IF (g_tsk.tsk08 != g_tsk_t.tsk08) OR g_tsk_t.tsk08 IS NULL THEN
               CALL t254_tsk08(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tsk.tsk08,g_errno,0)
                  LET g_tsk.tsk08 = g_tsk_t.tsk08
                  DISPLAY BY NAME g_tsk.tsk08
                  NEXT FIELD tsk08
               ELSE
#                 LET g_tsk_t.tsk08 = g_tsk.tsk08   #TQC-C20155 mark
                  CALL t254_tsk09('d')
                  DISPLAY BY NAME g_tsk.tsk09
               END IF
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.gen02
         END IF

      AFTER FIELD tsk09
         IF NOT cl_null(g_tsk.tsk09) THEN
            IF (g_tsk.tsk09 != g_tsk_t.tsk09) OR g_tsk_t.tsk09 IS NULL THEN
               CALL t254_tsk09(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tsk.tsk09,g_errno,0)
                  LET g_tsk.tsk09 = g_tsk_t.tsk09
                  DISPLAY BY NAME g_tsk.tsk09
                  NEXT FIELD tsk09
               ELSE
#                 LET g_tsk_t.tsk09 = g_tsk.tsk09     #TQC-C20155 mark
               END IF
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.gem02
         END IF

      AFTER FIELD tsk03
         IF NOT cl_null(g_tsk.tsk03) THEN
            IF (g_tsk.tsk03 != g_tsk_t.tsk03) OR g_tsk_t.tsk03 IS NULL THEN
               CALL t254_tsk03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tsk.tsk03,g_errno,0)
                  LET g_tsk.tsk03 = g_tsk_t.tsk03
                  DISPLAY BY NAME g_tsk.tsk03
                  NEXT FIELD tsk03
               END IF
               IF NOT cl_null(g_tsk.tsk17) THEN
                  CALL t254_imd02(g_tsk.tsk17,g_tsk.tsk03,p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tsk.tsk03,g_errno,0)
                     LET g_tsk.tsk03 = g_tsk_t.tsk03
                     DISPLAY BY NAME g_tsk.tsk03
                     NEXT FIELD tsk03
                  END IF
               END IF
               LET g_tsk_t.tsk03 = g_tsk.tsk03
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.azp02
         END IF

      AFTER FIELD tsk17
         IF NOT cl_null(g_tsk.tsk17) THEN
            IF (g_tsk.tsk17 != g_tsk_t.tsk17) OR g_tsk_t.tsk17 IS NULL THEN
               CALL t254_imd02(g_tsk.tsk17,g_tsk.tsk03,p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tsk.tsk17,g_errno,0)
                  LET g_tsk.tsk17 = g_tsk_t.tsk17
                  DISPLAY BY NAME g_tsk.tsk17
                  NEXT FIELD tsk17
               END IF
         #add FUN-AB0078
         IF NOT s_chk_ware1(g_tsk.tsk17,g_tsk.tsk03) THEN
            NEXT FIELD tsk17
         END IF
         #end FUN-AB0078
               LET g_tsk_t.tsk17 = g_tsk.tsk17
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.imd02
         END IF

      #No.FUN-870007-start-
##TQC-B10010--mark--str--
#      AFTER FIELD tsk24 #需求機構帶出營運中心
#         IF NOT cl_null(g_tsk.tsk24) THEN
#            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_tsk.tsk24 <> g_tsk_t.tsk24) THEN
#               CALL t254_tsk24('a')
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err('',g_errno,0)
#                  NEXT FIELD tsk24
#               END IF
#            END IF
#         END IF
##TQC-B10010--mark--end--
      #No.FUN-870007--end--

      ON ACTION controlp
         CASE
            WHEN INFIELD(tsk01)
               LET g_t1=s_get_doc_no(g_tsk.tsk01)
               CALL q_smy(FALSE,FALSE,g_t1,'APM','9') RETURNING g_t1  #TQC-670008
               LET g_tsk.tsk01 = g_t1
               DISPLAY BY NAME g_tsk.tsk01
               NEXT FIELD tsk01
            WHEN INFIELD(tsk08)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gen"
               CALL cl_create_qry() RETURNING g_tsk.tsk08
               DISPLAY BY NAME g_tsk.tsk08
               NEXT FIELD tsk08
            WHEN INFIELD(tsk09)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem"
               CALL cl_create_qry() RETURNING g_tsk.tsk09
               DISPLAY BY NAME g_tsk.tsk09
               NEXT FIELD tsk09
            WHEN INFIELD(tsk03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_azp"
               CALL cl_create_qry() RETURNING g_tsk.tsk03
               DISPLAY BY NAME g_tsk.tsk03
               NEXT FIELD tsk03
            WHEN INFIELD(tsk17)
               #FUN-AB0078 --MODIFY
              #CALL q_m_imd(FALSE,FALSE,g_tsk.tsk17,'S',g_tsk.tsk03)
               CALL cl_init_qry_var()
               CALL q_imd_1(FALSE,TRUE,"","",g_tsk.tsk03,"","")
              #FUN-AB0078 --END
                    RETURNING g_tsk.tsk17
               DISPLAY BY NAME g_tsk.tsk17
               NEXT FIELD tsk17
#No.FUN-870007-start-
##TQC-B10010--mark--str--
#            WHEN INFIELD(tsk24)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  = "q_azp"
#               CALL cl_create_qry() RETURNING g_tsk.tsk24
#               DISPLAY BY NAME g_tsk.tsk24
#               NEXT FIELD tsk24
##TQC-B10010--mark--end--
#No.FUN-870007--end--
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
        CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT
END FUNCTION

FUNCTION t254_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tsk01",TRUE)
   END IF
END FUNCTION

FUNCTION t254_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tsk01",FALSE)
   END IF
END FUNCTION

FUNCTION t254_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF g_sma.sma115 = 'Y' THEN
      CALL cl_set_comp_entry("tsl10,tsl12,tsl07,tsl09",TRUE)
   END IF
END FUNCTION

FUNCTION t254_set_no_entry_b(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_ima906     LIKE ima_file.ima906
   DEFINE l_ima907     LIKE ima_file.ima907

   IF g_sma.sma115 = 'Y' AND g_sma.sma122 ='2' THEN     #參考單位
      CALL cl_set_comp_entry("tsl10",FALSE)
   END IF
   IF g_sma.sma115 = 'Y' THEN
      IF NOT cl_null(g_tsl[l_ac].tsl03) THEN
         CALL s_chk_va_setting(g_tsl[l_ac].tsl03)
            RETURNING g_flag,l_ima906,l_ima907
         IF l_ima906 = '1' THEN                #單一單位
            CALL cl_set_comp_entry("tsl10,tsl12",FALSE)
         END IF
         IF l_ima906 = '3' THEN                #參考單位
            CALL cl_set_comp_entry("tsl10",FALSE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t254_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tsk.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt

   #No.TQC-660097 --start--
   IF g_sma.sma120 = 'Y'  THEN
      LET lg_smy62 = ''
      LET lg_group = ''
      CALL t254_refresh_detail()
   END IF
   #No.TQC-660097 --end--

   CALL t254_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_tsl.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t254_count
   FETCH t254_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t254_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)
      INITIALIZE g_tsk.* TO NULL
   ELSE
      CALL t254_fetch('F')                 # 讀出TEMP第一筆并顯示
   END IF
   MESSAGE ""
END FUNCTION

FUNCTION t254_fetch(p_fltsk)
   DEFINE
      p_fltsk         LIKE type_file.chr1,
      l_abso          LIKE type_file.num10
   DEFINE l_slip      LIKE tsk_file.tsk01

   CASE p_fltsk
      WHEN 'N' FETCH NEXT     t254_cs INTO g_tsk.tsk01
      WHEN 'P' FETCH PREVIOUS t254_cs INTO g_tsk.tsk01
      WHEN 'F' FETCH FIRST    t254_cs INTO g_tsk.tsk01
      WHEN 'L' FETCH LAST     t254_cs INTO g_tsk.tsk01
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()

               ON ACTION about
                  CALL cl_about()

               ON ACTION help
                  CALL cl_show_help()

               ON ACTION controlg
                  CALL cl_cmdask()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t254_cs INTO g_tsk.tsk01
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)
      INITIALIZE g_tsk.* TO NULL
      RETURN
   ELSE
      CASE p_fltsk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF

   #No.TQC-650090--begin
   #在使用Q查詢的情況下得到當前對應的屬性組smy62
   IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
      LET l_slip = g_tsk.tsk01[1,g_doc_len]
      SELECT smy62 INTO lg_smy62 FROM smy_file
       WHERE smyslip = l_slip
   END IF
   #No.TQC-650090--end

   SELECT * INTO g_tsk.* FROM tsk_file       # 重讀DB,因TEMP有不被更新特性
    WHERE tsk01 = g_tsk.tsk01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_tsk.* TO NULL
   ELSE                                      #FUN-4C0042權限控管
      LET g_data_owner=g_tsk.tskuser
      LET g_data_group=g_tsk.tskgrup
      LET g_data_plant = g_tsk.tskplant
      CALL t254_show()                      # 重新顯示
   END IF
END FUNCTION

FUNCTION t254_show()
DEFINE l_azp02   LIKE azp_file.azp02 #No.FUN-870007
DEFINE l_azp02_1 LIKE azp_file.azp02 #No.FUN-A30063
DEFINE l_azp02_2 LIKE azp_file.azp02 #No.FUN-A30063 
DEFINE l_gen02   LIKE gen_file.gen02  #FUN-A30063 ADD

   LET g_tsk_t.* = g_tsk.*
   LET g_tsk_o.* = g_tsk.*
   DISPLAY BY NAME
      g_tsk.tsk01,g_tsk.tsk02,g_tsk.tsk18,g_tsk.tsk19,
      g_tsk.tsk08,g_tsk.tsk09,g_tsk.tsk05,g_tsk.tsk06,
      g_tsk.tsk03,g_tsk.tsk17,g_tsk.tsk20,
      g_tsk.tsk21,g_tsk.tsk22,g_tsk.tsk10,
      #g_tsk.tsk23,g_tsk.tsk24,g_tsk.tsk25,g_tsk.tsk26,g_tsk.tskplant,   #No.FUN-870007
      g_tsk.tsk23,g_tsk.tsk25,g_tsk.tsk26,g_tsk.tskplant, #TQC-B10010
      g_tsk.tskuser,g_tsk.tskgrup,g_tsk.tskmodu,
      g_tsk.tskdate,g_tsk.tskacti
     ,g_tsk.tskoriu,g_tsk.tskorig           #TQC-A30048 ADD
     ,g_tsk.tskconu,g_tsk.tskcond,g_tsk.tskcont   #FUN-A30063 ADD
#No.FUN-870007-start-
    IF g_azw.azw04='2' THEN
       #SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_tsk.tsk24  #TQC-B10010
       #DISPLAY l_azp02 TO tsk24_desc                                      #TQC-B10010
       SELECT azp02 INTO l_azp02_1 FROM azp_file WHERE azp01 = g_tsk.tsk25
       DISPLAY l_azp02_1 TO tsk25_desc
       SELECT azp02 INTO l_azp02_2 FROM azp_file WHERE azp01 = g_tsk.tskplant
       DISPLAY l_azp02_2 TO tsk930_desc
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_tsk.tskconu  #FUN-A30063
       DISPLAY l_gen02 TO tskconu_desc
    END IF
#No.FUN-870007--end--

   CALL t254_tsk08('d')
   CALL t254_tsk09('d')
   CALL t254_tsk03('d')
   CALL t254_imd02(g_tsk.tsk17,g_tsk.tsk03,'d')

   CALL t254_field_pic()
   CALL t254_b_fill(g_wc2)

END FUNCTION

FUNCTION t254_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #-->已審核不可修改
   IF g_tsk.tsk05 = '2'   THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsk.tsk05 = '3'   THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsk.tsk05 = '4'   THEN CALL cl_err('','afa-916',0) RETURN END IF
   IF g_tsk.tskacti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF
   IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041
   MESSAGE ""
   CALL cl_opmsg('u')

   BEGIN WORK
   LET g_success = 'Y'
   OPEN t254_cl USING g_tsk.tsk01
   IF STATUS THEN
      CALL cl_err("OPEN t254_cl:", STATUS, 1)
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t254_cl INTO g_tsk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE t254_cl
      RETURN
   END IF
   LET g_tsk01_t = g_tsk.tsk01
   LET g_tsk_t.* = g_tsk.*
   LET g_tsk_o.* = g_tsk.*
   LET g_tsk.tskmodu = g_user
   CALL t254_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t254_i("u")                       # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tsk.*=g_tsk_o.*
         CALL t254_show()
         CALL cl_err('',9001,0)
         LET g_success = 'N'
         EXIT WHILE
      END IF

      IF g_tsk.tsk01 != g_tsk01_t THEN            # 更改單號
         CALL t254_rvbs('atmt254',g_tsk.tsk01,0,g_tsk01_t,0,'MOD')
         IF g_success = 'N' THEN
            EXIT WHILE
         END IF

         UPDATE tsl_file SET tsl01 = g_tsk.tsk01
          WHERE tsl01 = g_tsk01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tsl_file",g_tsk01_t,"",SQLCA.sqlcode,"","update tsl",1)
            LET g_success = 'N'
            EXIT WHILE
         END IF
      END IF

      UPDATE tsk_file SET tsk_file.* = g_tsk.*    # 更新DB
       WHERE tsk01 = g_tsk01_t                    # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         EXIT WHILE
      END IF

      EXIT WHILE
   END WHILE
   CLOSE t254_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t254_r()   #刪除
    DEFINE l_chr   LIKE type_file.chr1,
           l_cnt   LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    IF g_tsk.tsk01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_tsk.tsk05 ='2'    THEN CALL cl_err('','9023',0)    RETURN END IF
    IF g_tsk.tsk05 = '3'   THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_tsk.tsk05 = '4'   THEN CALL cl_err('','afa-916',0) RETURN END IF
    IF g_tsk.tskacti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF
    IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041

    BEGIN WORK
    LET g_success = 'Y'

    OPEN t254_cl USING g_tsk.tsk01
    IF STATUS THEN
       CALL cl_err("OPEN t254_cl:", STATUS, 1)
       CLOSE t254_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t254_cl INTO g_tsk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        CLOSE t254_cl
        RETURN
    END IF
    CALL t254_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tsk01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tsk.tsk01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM tsk_file WHERE tsk01=g_tsk.tsk01
        IF STATUS THEN
           CALL cl_err3("del","tsk_file",g_tsk.tsk01,"",STATUS,"","",1)
           ROLLBACK WORK
           RETURN
        END IF

        DELETE FROM tsl_file WHERE tsl01 = g_tsk.tsk01
        IF STATUS THEN
           CALL cl_err3("del","tsl_file",g_tsk.tsk01,"",STATUS,"","",1)
           ROLLBACK WORK
           RETURN
        END IF

        CALL t254_rvbs('atmt254',g_tsk.tsk01,0,g_tsk01_t,0,'DEL')
        IF g_success = 'N' THEN
           ROLLBACK WORK
           RETURN
        END IF

        INITIALIZE g_tsk.* TO NULL
        CLEAR FORM
        CALL g_tsl.clear()
        OPEN t254_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE t254_cs
           CLOSE t254_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH t254_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t254_cs
           CLOSE t254_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t254_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t254_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL t254_fetch('/')
        END IF
    END IF
    CLOSE t254_cl
    COMMIT WORK
END FUNCTION

FUNCTION t254_y()    #審核
DEFINE l_gen02 LIKE gen_file.gen02     #FUN-A30063 ADD

   IF s_shut(0) THEN RETURN END IF
#CHI-C30107 --------------- add ----------------- begin
   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF cl_null(g_tsk.tsk07) THEN
      CALL cl_err('','axm-315',0)
      RETURN
   END IF
   IF g_tsk.tsk05 = '2'   THEN CALL cl_err('','9023',0)    RETURN END IF
   IF g_tsk.tsk05 = '3'   THEN CALL cl_err('','mfg0175',0) RETURN END IF
   IF g_tsk.tsk05 = '4'   THEN CALL cl_err('','mfg0175',0) RETURN END IF
   IF g_tsk.tskacti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF
   IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041
   IF NOT cl_confirm('axr-108') THEN  RETURN END IF
   SELECT * INTO g_tsk.* FROM tsk_file WHERE tsk01 = g_tsk.tsk01
#CHI-C30107 --------------- add ----------------- end
   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF cl_null(g_tsk.tsk07) THEN
      CALL cl_err('','axm-315',0)
      RETURN
   END IF

   IF g_tsk.tsk05 = '2'   THEN CALL cl_err('','9023',0)    RETURN END IF
   IF g_tsk.tsk05 = '3'   THEN CALL cl_err('','mfg0175',0) RETURN END IF
   IF g_tsk.tsk05 = '4'   THEN CALL cl_err('','mfg0175',0) RETURN END IF
   IF g_tsk.tskacti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF
   IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041

   BEGIN WORK
   LET g_success='Y'
   OPEN t254_cl USING g_tsk.tsk01
   IF STATUS THEN
      CALL cl_err("OPEN t254_cl:", STATUS, 1)
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t254_cl INTO g_tsk.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   #add FUN-AB0078
   IF NOT s_chk_ware1(g_tsk.tsk17,g_tsk.tsk03) THEN #检查仓库是否属于当前门店 
      LET g_success='N'
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF NOT s_chk_ware1(g_oga.oga06,g_plant) THEN #检查仓库是否属于当前门店 
      LET g_success='N'
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   #end FUN-AB0078
#  IF cl_confirm('axr-108') THEN #CHI-C30107 mark
      IF g_tsk.tsk05 = '1' THEN
         LET g_tsk.tsk05 ='2'
      END IF
      #1.更新狀態碼
      LET g_time =TIME  #FUN-A30063 ADD
      UPDATE tsk_file SET tsk05=g_tsk.tsk05,
                          tskconu=g_user,       #FUN-A30063 ADD
                          tskcond=g_today,      #FUN-A30063 ADD
                          tskcont=g_time,         #FUN-A30063 ADD
                          tskmodu=g_user,
                          tskdate=g_today
                    WHERE tsk01  =g_tsk.tsk01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
         LET g_tsk.tsk05 = '1'
         LET g_success = 'N'
      END IF
      #2.Check 批序號的數量和單身的數量是否一致
      #carrier need complete
#     CALL t254_check_body_lot_qty()
      IF g_success = 'N' THEN
         LET g_tsk.tsk05 = '1'
      END IF
#  END IF  #CHI-C30107 mark
   CLOSE t254_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET  g_tsk.tskconu=g_user
      LET  g_tsk.tskcond=g_today
      LET  g_tsk.tskcont=g_time
      LET  g_tsk.tskmodu=g_user
      LET  g_tsk.tskdate=g_today
   ELSE
      ROLLBACK WORK
   END IF
  #FUN-A30063 ADD----------------------------------
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tsk.tskconu
  #DISPLAY l_gen02 TO tskconu.desc    #CHI-D20015
   DISPLAY l_gen02 TO tskconu_desc#CHI-D20015 
   DISPLAY BY NAME g_tsk.tskconu,g_tsk.tskcond,g_tsk.tskcont,g_tsk.tskdate,g_tsk.tskmodu 
  #FUN-A30063 END---------------------------------
   DISPLAY BY NAME g_tsk.tsk05
   CALL t254_field_pic()
END FUNCTION

FUNCTION t254_xy()    #取消審核
   DEFINE l_gen02 LIKE gen_file.gen02 #CHI-D20015 add


   IF s_shut(0) THEN RETURN END IF
   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_tsk.tsk05 = '1'   THEN CALL cl_err('','9025',0)          RETURN END IF
   IF g_tsk.tsk05 = '3'   THEN CALL cl_err('post=Y','mfg0175',0) RETURN END IF
   IF g_tsk.tsk05 = '4'   THEN CALL cl_err('post=Y','mfg0175',0) RETURN END IF
   IF g_tsk.tskacti = 'N' THEN CALL cl_err('','aap-127',0)       RETURN END IF
   IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041

   BEGIN WORK
   LET g_success='Y'
   OPEN t254_cl USING g_tsk.tsk01
   IF STATUS THEN
      CALL cl_err("OPEN t254_cl:", STATUS, 1)
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t254_cl INTO g_tsk.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF cl_confirm('axr-109') THEN
      IF g_tsk.tsk05 ='2'  THEN
         LET g_tsk.tsk05='1'
      END IF
      UPDATE tsk_file SET tsk05  =g_tsk.tsk05,
                         #CHI-D20015--mod--str
                         #tskconu=NULL,      #FUN-A30063 ADD
                         #tskcond=NULL,      #FUN-A30063 ADD
                         #tskcont=NULL,      #FUN-A30063 ADD
                          tskconu = g_user,
                          tskcond = g_today,
                          tskcont = g_time,
                         #CHI-D20015--mod--end
                          tskmodu=g_user,
                          tskdate=g_today
                    WHERE tsk01  =g_tsk.tsk01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
         LET g_tsk.tsk05 = '2'
         ROLLBACK WORK
      END IF
     #FUN-A30063 ADD-------------------
     #CHI-D20015--mod--str
     #LET g_tsk.tskconu=NULL
     #LET g_tsk.tskcond=NULL
     #LET g_tsk.tskcont=NULL
      LET g_tsk.tskconu=g_user
      LET g_tsk.tskcond=g_today
      LET g_tsk.tskcont=g_time
     #CHI-D20015--mod--end
      LET g_tsk.tskmodu=g_user
      LET g_tsk.tskdate=g_today
      DISPLAY BY NAME g_tsk.tskconu,g_tsk.tskcond,g_tsk.tskcont,g_tsk.tskmodu,g_tsk.tskdate
     #DISPLAY ' ' TO tskconu_desc#CHI-D20015 mark
     #CHI-D20015--add-s-tr
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tsk.tskconu
      DISPLAY l_gen02 TO tskconu_desc
     #CHI-D20015--add--end
     #FUN-A30063 END----------------
      DISPLAY BY NAME g_tsk.tsk05
   END IF
   CLOSE t254_cl
   CALL t254_field_pic()
   COMMIT WORK
END FUNCTION

FUNCTION t254_out()
   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_sql = "atmr254 '",g_tsk.tsk01,"' "
   CALL cl_cmdrun(g_sql)

END FUNCTION

FUNCTION t254_b()
   #No.TQC-650090--begin
   DEFINE li_i            LIKE type_file.num5
   DEFINE l_count         LIKE type_file.num5
   DEFINE l_temp          LIKE ima_file.ima01
   DEFINE l_imaag         LIKE ima_file.imaag
   DEFINE l_check_res     LIKE type_file.num5
   #No.TQC-650090--end
   DEFINE l_ac_t          LIKE type_file.num5       #未取消的ARRAY CNT
   DEFINE l_n             LIKE type_file.num5       #檢查重復用
   DEFINE l_lock_sw       LIKE type_file.chr1       #單身鎖住否
   DEFINE p_cmd           LIKE type_file.chr1       #處理狀態
   DEFINE l_allow_insert  LIKE type_file.num5       #可新增否
   DEFINE l_allow_delete  LIKE type_file.num5       #可刪除否
   DEFINE l_fac           LIKE inb_file.inb08_fac
   DEFINE l_tsl09         LIKE tsl_file.tsl09
   DEFINE l_tsl12         LIKE tsl_file.tsl12
   DEFINE l_ima25         LIKE ima_file.ima25
   DEFINE l_imaacti       LIKE ima_file.imaacti
   DEFINE l_ima135        LIKE ima_file.ima135
   DEFINE l_ima906        LIKE ima_file.ima906
   DEFINE l_ima907        LIKE ima_file.ima907
   DEFINE l_state         LIKE type_file.num5
   DEFINE l_rty06_1       LIKE rty_file.rty06       #TQC-B10010
   DEFINE l_rty06_2       LIKE rty_file.rty06       #TQC-B10010
   DEFINE l_sql           STRING                    #TQC-B10010
   DEFINE l_tf            LIKE type_file.chr1       #FUN-910088--add--
   DEFINE l_tf1           LIKE type_file.chr1       #FUN-910088--add--
   DEFINE l_case          STRING                    #FUN-910088--add--

   IF s_shut(0) THEN RETURN END IF

   LET g_action_choice = ""
   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #-->已審核或結案不可修改
   IF g_tsk.tsk05 = '2' OR g_tsk.tsk05 = '3'  THEN
      CALL cl_err('','axr-101',0)
      RETURN
   END IF
   IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041
   IF g_tsk.tsk05   = '4' THEN CALL cl_err('','afa-916',0) RETURN END IF
   IF g_tsk.tskacti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF

   LET l_tsl09 = 0
   LET l_tsl12 = 0

   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT tsl02,tsl13,tsl03,'','', ",         #No.FUN-870007
                      "  '','','','','','','','','','','','','','','','','','','','','',",  #No.TQC-650090
                      "        tsl04,tsl05,tsl10,tsl11,tsl12, ",
                      "        tsl07,tsl08,tsl09 ",
                      "   FROM tsl_file ",
                      "  WHERE tsl01=? ",
                      "    AND tsl02=? ",
                      "    FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t254_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_tsl WITHOUT DEFAULTS FROM s_tsl.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n = ARR_COUNT()

         BEGIN WORK
         OPEN t254_cl USING g_tsk.tsk01
         IF STATUS THEN
            CALL cl_err("OPEN t254_cl:", STATUS, 1)
            CLOSE t254_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t254_cl INTO g_tsk.*               # 對DB鎖定
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)
            ROLLBACK WORK
            CLOSE t254_cl
            RETURN
         END IF

         IF g_rec_b >= l_ac THEN
            LET p_cmd = 'u'
            LET g_tsl_t.* = g_tsl[l_ac].*  #BACKUP
            LET g_tsl_o.* = g_tsl[l_ac].*  #BACKUP
         #FUN-910088--add--start--
            LET g_tsl04_t = g_tsl[l_ac].tsl04
            LET g_tsl07_t = g_tsl[l_ac].tsl07
            LET g_tsl10_t = g_tsl[l_ac].tsl10
         #FUN-910088--add--end--
            OPEN t254_bcl USING g_tsk.tsk01,g_tsl_t.tsl02
            IF STATUS THEN
               CALL cl_err("OPEN t254_bcl:", STATUS, 1)
               CLOSE t254_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t254_bcl INTO g_tsl[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tsl_t.tsl02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               #No.TQC-650090--begin
               IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
                  #得到該料件對應的父料件和所有屬性
                  SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                         imx07,imx08,imx09,imx10 INTO
                         g_tsl[l_ac].att00,g_tsl[l_ac].att01,g_tsl[l_ac].att02,
                         g_tsl[l_ac].att03,g_tsl[l_ac].att04,g_tsl[l_ac].att05,
                         g_tsl[l_ac].att06,g_tsl[l_ac].att07,g_tsl[l_ac].att08,
                         g_tsl[l_ac].att09,g_tsl[l_ac].att10
                  FROM imx_file WHERE imx000 = g_tsl[l_ac].tsl03

                  LET g_tsl[l_ac].att01_c = g_tsl[l_ac].att01
                  LET g_tsl[l_ac].att02_c = g_tsl[l_ac].att02
                  LET g_tsl[l_ac].att03_c = g_tsl[l_ac].att03
                  LET g_tsl[l_ac].att04_c = g_tsl[l_ac].att04
                  LET g_tsl[l_ac].att05_c = g_tsl[l_ac].att05
                  LET g_tsl[l_ac].att06_c = g_tsl[l_ac].att06
                  LET g_tsl[l_ac].att07_c = g_tsl[l_ac].att07
                  LET g_tsl[l_ac].att08_c = g_tsl[l_ac].att08
                  LET g_tsl[l_ac].att09_c = g_tsl[l_ac].att09
                  LET g_tsl[l_ac].att10_c = g_tsl[l_ac].att10
               END IF
               #No.TQC-650090--end
               CALL t254_tsl03('d')
               CALL t254_set_entry_b(p_cmd)
               CALL t254_set_no_entry_b(p_cmd)
               CALL cl_show_fld_cont()
            END IF
         END IF

      BEFORE FIELD tsl02
         IF p_cmd='a' THEN
   	    SELECT MAX(tsl02)+1 INTO g_cnt FROM tsl_file
             WHERE tsl01 = g_tsk.tsk01
            IF cl_null(g_cnt) THEN
               LET g_cnt = 1
            END IF
            LET g_tsl[l_ac].tsl02 = g_cnt
         END IF

      AFTER FIELD tsl02
         IF NOT cl_null(g_tsl[l_ac].tsl02) THEN
            IF g_tsl[l_ac].tsl02 != g_tsl_t.tsl02 OR
               g_tsl_t.tsl02 IS NULL THEN
               SELECT COUNT(*) INTO g_cnt FROM tsl_file
                WHERE tsl01 = g_tsk.tsk01
                  AND tsl02 = g_tsl[l_ac].tsl02
               IF g_cnt>0 THEN
                  CALL cl_err('tsl02',-239,0)
                  LET g_tsl[l_ac].tsl02 = g_tsl_t.tsl02
                  DISPLAY BY NAME g_tsl[l_ac].tsl02
                  NEXT FIELD tsl02
               END IF
            END IF
            #項次修改后,要更新批序號
            IF g_tsl[l_ac].tsl02 <> g_tsl_o.tsl02 THEN
               CALL t254_rvbs('atmt254',g_tsk.tsk01,g_tsl[l_ac].tsl02,g_tsk.tsk01,g_tsl_o.tsl02,'MOD')
            END IF
            LET g_tsl_o.tsl02 = g_tsl[l_ac].tsl02
         END IF

      BEFORE FIELD tsl03
         CALL t254_set_entry_b(p_cmd)
         CALL t254_set_no_entry_b(p_cmd)
         CALL t254_set_no_required()

#No.TQC-650090--begin
      AFTER FIELD tsl03
         #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
#FUN-AA0059 ---------------------start----------------------------
         IF NOT cl_null(g_tsl[l_ac].tsl03) THEN
            IF NOT s_chk_item_no(g_tsl[l_ac].tsl03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_tsl[l_ac].tsl03= g_tsl_t.tsl03
               NEXT FIELD tsl03
            END IF
         END IF
#FUN-AA0059 ---------------------end-------------------------------
         CALL t254_check_tsl03('tsl03',l_ac,p_cmd) #No.MOD-660090
              RETURNING l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
       #FUN-910088--add--start--
         LET l_tf = NULL
         LET l_tf1 = NULL
         LET l_case = NULL
         IF g_sma.sma115 ='N' THEN
            LET g_tsl[l_ac].tsl12 = s_digqty(g_tsl[l_ac].tsl12,g_tsl[l_ac].tsl10)
            LET g_tsl[l_ac].tsl09 = s_digqty(g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl07)
            DISPLAY BY NAME g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl12
            IF NOT cl_null(g_tsl[l_ac].tsl05) AND g_tsl[l_ac].tsl05<>0 THEN #FUN-C20068 add
               CALL t254_tsl05_check() RETURNING l_tf                       #FUN-C20068 add
            END IF                                                          #FUN-C20068 add
         ELSE
            LET g_tsl[l_ac].tsl05 = s_digqty(g_tsl[l_ac].tsl05,g_tsl[l_ac].tsl04) #FUN-C20068 add
            DISPLAY BY NAME g_tsl[l_ac].tsl05                                     #FUN-C20068 add
            IF NOT cl_null(g_tsl[l_ac].tsl12) AND g_tsl[l_ac].tsl12<>0 THEN #FUN-C20068 add
               CALL t254_tsl12_check(l_tsl12,l_tsl09,l_ima906) RETURNING l_tf1,l_tsl12,l_tsl09
            END IF                                                          #FUN-C20068 add
            IF NOT cl_null(g_tsl[l_ac].tsl09) AND g_tsl[l_ac].tsl09<>0 THEN #FUN-C20068 add
               CALL t254_tsl09_check(l_tsl09,l_tsl12) RETURNING l_case, l_tsl09,l_tsl12
            END IF                                                          #FUN-C20068 add
         END IF
         LET g_tsl_o.tsl04 = g_tsl[l_ac].tsl04  #FUN-C20068 add
         LET g_tsl04_t = g_tsl[l_ac].tsl04      #FUN-C20068 add
         LET g_tsl10_t = g_tsl[l_ac].tsl10
         LET g_tsl07_t = g_tsl[l_ac].tsl07
       #FUN-910088--add--end--
#No.FUN-870007-start-
         IF g_azw.azw04='2' THEN
#TQC-B10010--mark--str--
#            SELECT COUNT(*) INTO l_n FROM rty_file a,rty_file b
#             WHERE a.rty06 = b.rty06
#               AND a.rty01 = g_tsk.tskplant
#               #AND b.rty01 = g_tsk.tsk24
#               AND b.rty01 = g_tsk.tsk03  #TQC-B10010
#               AND a.rty02 = b.rty02
#               AND a.rty02 = g_tsl[l_ac].tsl03
#               AND a.rty06 = '1'
#               AND a.rtyacti = 'Y'
#               AND b.rtyacti = 'Y'
#            IF l_n = 0 THEN
#               CALL cl_err('','art-332',0)
#               NEXT FIELD tsl03
#            END IF
#TQC-B10010--mark--end--
#TQC-B10010--add--str--
             LET l_rty06_1 = ''
             LET l_rty06_2 = ''
             LET l_sql = "SELECT rty06 FROM ",cl_get_target_table(g_tsk.tskplant, 'rty_file'),
                         " WHERE rty01 = '",g_tsk.tskplant,"'",
                         "   AND rtyacti = 'Y' ",
                         "   AND rty02 = '",g_tsl[l_ac].tsl03,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             CALL cl_parse_qry_sql(l_sql,g_tsk.tskplant) RETURNING l_sql
             PREPARE pre_rty1 FROM l_sql
             EXECUTE pre_rty1 INTO l_rty06_1
             IF cl_null(l_rty06_1) THEN
                LET l_rty06_1 = '1'
             END IF
             LET l_sql = "SELECT rty06 FROM ",cl_get_target_table(g_tsk.tsk03, 'rty_file'),
                         " WHERE rty01 = '",g_tsk.tsk03,"'",
                         "   AND rtyacti = 'Y' ",
                         "   AND rty02 = '",g_tsl[l_ac].tsl03,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             CALL cl_parse_qry_sql(l_sql,g_tsk.tsk03) RETURNING l_sql
             PREPARE pre_rty2 FROM l_sql
             EXECUTE pre_rty2 INTO l_rty06_2
             IF cl_null(l_rty06_2) THEN
                LET l_rty06_2 = '1'
             END IF
             IF l_rty06_1<>l_rty06_2 THEN
                CALL cl_err('','art-332',0)
                NEXT FIELD tsl03
             END IF           
#TQC-B10010--add--end--
         END IF
#No.FUN-870007--end--
#No.MOD-660094 --start-- 以下程序被莫名刪除了，重要程序，請勿隨意刪除
         IF NOT l_check_res THEN NEXT FIELD tsl03 END IF
         SELECT imaag INTO l_imaag FROM ima_file
          WHERE ima01 = g_tsl[l_ac].tsl03
         IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN
            LET g_tsl[l_ac].ima02 = ''
            CALL cl_err(g_tsl[l_ac].tsl03,'aim1004',0)
            NEXT FIELD tsl03
         ELSE
            SELECT ima02 INTO g_tsl[l_ac].ima02
              FROM ima_file
             WHERE ima01 = g_tsl[l_ac].tsl03
         END IF
         IF NOT cl_null(g_tsl[l_ac].tsl03) THEN
            IF g_tsl[l_ac].tsl03 <> g_tsl_o.tsl03 THEN
               CALL t254_rvbs('atmt254',g_tsk.tsk01,g_tsl[l_ac].tsl02,g_tsk.tsk01,g_tsl[l_ac].tsl02,'DEL')
               CALL t254_lot('3') RETURNING l_state
               IF l_state = FALSE THEN
                  NEXT FIELD tsl03
               END IF
            END IF
            LET g_tsl_o.tsl03 = g_tsl[l_ac].tsl03
         END IF
         CALL t254_set_required()
     #FUN-910088--add--start--
         IF g_sma.sma115 != 'N' THEN 
            IF NOT cl_null(l_tf1) AND NOT l_tf1  THEN
               NEXT FIELD tsl12
            END IF
            CASE l_case
               WHEN "tsl07"
                  NEXT FIELD tsl07
               WHEN "tsl09"
                  NEXT FIELD tsl09
               OTHERWISE EXIT CASE
            END CASE
         ELSE
            IF NOT cl_null(l_tf) AND NOT l_tf  THEN #FUN-C20068
               NEXT FIELD tsl05                     #FUN-C20068
            END IF                                  #FUN-C20068
         END IF
     #FUN-910088--add--end--

      BEFORE FIELD att00
         #根據子料件找到母料件及各個屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,
                imx06,imx07,imx08,imx09,imx10
         INTO g_tsl[l_ac].att00, g_tsl[l_ac].att01, g_tsl[l_ac].att02,
              g_tsl[l_ac].att03, g_tsl[l_ac].att04, g_tsl[l_ac].att05,
              g_tsl[l_ac].att06, g_tsl[l_ac].att07, g_tsl[l_ac].att08,
              g_tsl[l_ac].att09, g_tsl[l_ac].att10
         FROM imx_file
         WHERE imx000 = g_tsl[l_ac].tsl03
         #賦值所有屬性
         LET g_tsl[l_ac].att01_c = g_tsl[l_ac].att01
         LET g_tsl[l_ac].att02_c = g_tsl[l_ac].att02
         LET g_tsl[l_ac].att03_c = g_tsl[l_ac].att03
         LET g_tsl[l_ac].att04_c = g_tsl[l_ac].att04
         LET g_tsl[l_ac].att05_c = g_tsl[l_ac].att05
         LET g_tsl[l_ac].att06_c = g_tsl[l_ac].att06
         LET g_tsl[l_ac].att07_c = g_tsl[l_ac].att07
         LET g_tsl[l_ac].att08_c = g_tsl[l_ac].att08
         LET g_tsl[l_ac].att09_c = g_tsl[l_ac].att09
         LET g_tsl[l_ac].att10_c = g_tsl[l_ac].att10
         #顯示所有屬性
         DISPLAY BY NAME
           g_tsl[l_ac].att01, g_tsl[l_ac].att01_c,
           g_tsl[l_ac].att02, g_tsl[l_ac].att02_c,
           g_tsl[l_ac].att03, g_tsl[l_ac].att03_c,
           g_tsl[l_ac].att04, g_tsl[l_ac].att04_c,
           g_tsl[l_ac].att05, g_tsl[l_ac].att05_c,
           g_tsl[l_ac].att06, g_tsl[l_ac].att06_c,
           g_tsl[l_ac].att07, g_tsl[l_ac].att07_c,
           g_tsl[l_ac].att08, g_tsl[l_ac].att08_c,
           g_tsl[l_ac].att09, g_tsl[l_ac].att09_c,
           g_tsl[l_ac].att10, g_tsl[l_ac].att10_c

      AFTER FIELD att00
          #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
          SELECT COUNT(ima01) INTO l_count FROM ima_file
           WHERE ima01 = g_tsl[l_ac].att00 AND imaag = lg_smy62
          IF l_count = 0 THEN
             CALL cl_err_msg('','aim-909',lg_smy62,0)
             NEXT FIELD att00
          END IF

          CALL t254_check_tsl03('imx00',l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
#No.MOD-660094 --end--
       #FUN-910088--add--start--
          LET l_tf = ""
          LET l_tf1 = ""
          LET l_case =""
          IF g_sma.sma115 ='N' THEN
            LET g_tsl[l_ac].tsl12 = s_digqty(g_tsl[l_ac].tsl12,g_tsl[l_ac].tsl10)
            LET g_tsl[l_ac].tsl09 = s_digqty(g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl07)
            DISPLAY BY NAME g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl12
            IF NOT cl_null(g_tsl[l_ac].tsl05) AND g_tsl[l_ac].tsl05<>0 THEN  #FUN-C20068 add
               CALL t254_tsl05_check() RETURNING l_tf                        #FUN-C20068 add
            END IF                                                           #FUN-C20068 add
         ELSE
            LET g_tsl[l_ac].tsl05 = s_digqty(g_tsl[l_ac].tsl05,g_tsl[l_ac].tsl04) #FUN-C20068 add
            DISPLAY BY NAME g_tsl[l_ac].tsl05                                     #FUN-C20068 add
            IF NOT cl_null(g_tsl[l_ac].tsl12) AND g_tsl[l_ac].tsl12<>0 THEN #FUN-C20068 add
               CALL t254_tsl12_check(l_tsl12,l_tsl09,l_ima906) RETURNING l_tf1,l_tsl12,l_tsl09
            END IF                                                          #FUN-C20068 add
            IF NOT cl_null(g_tsl[l_ac].tsl09) AND g_tsl[l_ac].tsl09<>0 THEN #FUN-C20068 add
               CALL t254_tsl09_check(l_tsl09,l_tsl12) RETURNING l_case, l_tsl09,l_tsl12
            END IF                                                          #FUN-C20068 add
         END IF
         LET g_tsl_o.tsl04 = g_tsl[l_ac].tsl04  #FUN-C20068 add
         LET g_tsl04_t = g_tsl[l_ac].tsl04      #FUN-C20068 add
         LET g_tsl10_t = g_tsl[l_ac].tsl10
         LET g_tsl07_t = g_tsl[l_ac].tsl07
      #FUN-910088--add--end--
          IF NOT l_check_res THEN NEXT FIELD att00 END IF
      #FUN-910088--add--start--
         IF g_sma.sma115 != 'N' THEN
            IF NOT cl_null(l_tf1) AND NOT l_tf1 THEN
               NEXT FIELD tsl12
            END IF
            CASE l_case
               WHEN "tsl07"
                  NEXT FIELD tsl07
               WHEN "tsl09"
                  NEXT FIELD tsl09
               OTHERWISE EXIT CASE
            END CASE
         ELSE
            IF NOT cl_null(l_tf) AND NOT l_tf  THEN #FUN-C20068
               NEXT FIELD tsl05                     #FUN-C20068
            END IF                                  #FUN-C20068
         END IF
     #FUN-910088--add--end--

      AFTER FIELD att01
          CALL t254_check_att0x(g_tsl[l_ac].att01,1,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att01 END IF
      AFTER FIELD att02
          CALL t254_check_att0x(g_tsl[l_ac].att02,2,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att02 END IF
      AFTER FIELD att03
          CALL t254_check_att0x(g_tsl[l_ac].att03,3,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att03 END IF
      AFTER FIELD att04
          CALL t254_check_att0x(g_tsl[l_ac].att04,4,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att04 END IF
      AFTER FIELD att05
          CALL t254_check_att0x(g_tsl[l_ac].att05,5,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att05 END IF
      AFTER FIELD att06
          CALL t254_check_att0x(g_tsl[l_ac].att06,6,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att06 END IF
      AFTER FIELD att07
          CALL t254_check_att0x(g_tsl[l_ac].att07,7,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att07 END IF
      AFTER FIELD att08
          CALL t254_check_att0x(g_tsl[l_ac].att08,8,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att08 END IF
      AFTER FIELD att09
          CALL t254_check_att0x(g_tsl[l_ac].att09,9,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att09 END IF
      AFTER FIELD att10
          CALL t254_check_att0x(g_tsl[l_ac].att10,10,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att10 END IF
      #下面是十個輸入型屬性欄位的判斷語句
      AFTER FIELD att01_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att01_c,1,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att01_c END IF
      AFTER FIELD att02_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att02_c,2,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att02_c END IF
      AFTER FIELD att03_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att03_c,3,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att03_c END IF
      AFTER FIELD att04_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att04_c,4,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att04_c END IF
      AFTER FIELD att05_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att05_c,5,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att05_c END IF
      AFTER FIELD att06_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att06_c,6,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att06_c END IF
      AFTER FIELD att07_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att07_c,7,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att07_c END IF
      AFTER FIELD att08_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att08_c,8,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att08_c END IF
      AFTER FIELD att09_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att09_c,9,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att09_c END IF
      AFTER FIELD att10_c
          CALL t254_check_att0x_c(g_tsl[l_ac].att10_c,10,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att10_c END IF
      #FUN-640013 End --

#No.TQC-650090--end

      AFTER FIELD tsl04
         IF NOT cl_null(g_tsl[l_ac].tsl04) THEN
            IF g_tsl[l_ac].tsl04 != g_tsl_t.tsl04 OR
               g_tsl_t.tsl04 IS NULL THEN
               CALL t254_tsl04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tsl[l_ac].tsl04,g_errno,0)
                  LET g_tsl[l_ac].tsl04 = g_tsl_t.tsl04
                  NEXT FIELD tsl04
               END IF
               CALL t254_lot('2') RETURNING l_state
               IF l_state = FALSE THEN
                  CALL cl_err(g_tsl[l_ac].tsl04,g_errno,0)
                  LET g_tsl[l_ac].tsl04 = g_tsl_t.tsl04
                  NEXT FIELD tsl04
               END IF
            END IF
            #單位有變化時,要delete批序號資料
            IF g_tsl[l_ac].tsl04 <> g_tsl_o.tsl04 THEN
               CALL t254_rvbs('atmt254',g_tsk.tsk01,g_tsl[l_ac].tsl02,g_tsk.tsk01,g_tsl[l_ac].tsl02,'DEL')
               CALL t254_lot('3') RETURNING l_state
               IF l_state = FALSE THEN
                  NEXT FIELD tsl03
               END IF
            END IF
            LET g_tsl_o.tsl04 = g_tsl[l_ac].tsl04
          #FUN-910088--add--start--
            IF NOT cl_null(g_tsl[l_ac].tsl05) AND g_tsl[l_ac].tsl05<>0 THEN  #FUN-C20068 add
               IF NOT t254_tsl05_check() THEN 
                  LET g_tsl04_t = g_tsl[l_ac].tsl04
                  NEXT FIELD tsl04
               END IF
            END IF                                                           #FUN-C20068 add
            LET g_tsl04_t = g_tsl[l_ac].tsl04
          #FUN-910088--add--end--
         END IF

      AFTER FIELD tsl05
         IF NOT t254_tsl05_check() THEN NEXT FIELD tsl05 END IF   #FUN-910088--add--
    #FUN-910088--mark--start--
    #    IF NOT cl_null(g_tsl[l_ac].tsl05) THEN
    #       IF (g_tsl[l_ac].tsl05 != g_tsl_t.tsl05)
    #          OR (g_tsl_t.tsl05 IS NULL) THEN
    #          CALL t254_lot('3') RETURNING l_state
    #          IF l_state = FALSE THEN
    #             CALL cl_err('g_tsl[l_ac].tsl05','mfg4012',0)
    #             LET g_tsl[l_ac].tsl05 = g_tsl_t.tsl05
    #             NEXT FIELD tsl05
    #          END IF
    #          IF g_tsl[l_ac].tsl05<=0 THEN
    #             CALL cl_err('g_tsl[l_ac].tsl05','mfg4012',0)
    #             LET g_tsl[l_ac].tsl05 = g_tsl_t.tsl05
    #             DISPLAY BY NAME g_tsl[l_ac].tsl05
    #             NEXT FIELD tsl05
    #          END IF
    #       END IF
    #    END IF
    #FUN-910088--mark--end--

      BEFORE FIELD tsl10
         CALL t254_set_no_required()

      AFTER FIELD tsl10
         IF NOT cl_null(g_tsl[l_ac].tsl10) THEN
            IF (g_tsl[l_ac].tsl10 != g_tsl_t.tsl10)
               OR (g_tsl_t.tsl10 IS NULL) THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM gfe_file
                WHERE gfe01 = g_tsl[l_ac].tsl10
               IF g_cnt=0 THEN
                  CALL cl_err(g_tsl[l_ac].tsl10,'mfg3377',0)
                  LET g_tsl[l_ac].tsl10 = g_tsl_t.tsl10
                  DISPLAY BY NAME g_tsl[l_ac].tsl10
                  NEXT FIELD tsl10
               END IF
               SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_tsl[l_ac].tsl03
               CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl10,l_ima25)
                  RETURNING g_cnt,l_fac
               IF g_cnt = 1 THEN
                  CALL cl_err('','mfg3075',1)
                  LET g_tsl[l_ac].tsl10 = g_tsl_t.tsl10
                  DISPLAY BY NAME g_tsl[l_ac].tsl10
                  NEXT FIELD tsl10
               END IF
               LET g_tsl[l_ac].tsl11 = l_fac
               IF (g_tsl[l_ac].tsl11 != g_tsl_t.tsl11) THEN
                  IF l_ima906 = '2' THEN                #母子單位
                     LET l_tsl12 = g_tsl[l_ac].tsl11*g_tsl[l_ac].tsl12
                     LET l_tsl12 = s_digqty(l_tsl12,g_tsl[l_ac].tsl10)     #FUN-910088--add--      
                     IF g_tsl[l_ac].tsl09 > 0 THEN
                        LET l_tsl09 = g_tsl[l_ac].tsl09 * g_tsl[l_ac].tsl08
                        LET l_tsl09 = s_digqty(l_tsl09,g_tsl[l_ac].tsl07)  #FUN-910088--add--
                     END IF
                  END IF
               END IF
            END IF
         ELSE
            LET l_tsl12 = 0
         END IF
    #FUN-910088--add--start--
         LET l_tf1 = NULL
         IF NOT cl_null(g_tsl[l_ac].tsl12) AND g_tsl[l_ac].tsl12<>0 THEN #FUN-C20068 add
            CALL t254_tsl12_check(l_tsl12,l_tsl09,l_ima906) RETURNING l_tf1,l_tsl12,l_tsl09
         END IF                                                          #FUN-C20068 add 
         LET g_tsl10_t = g_tsl[l_ac].tsl10
    #FUN-910088--add--end--
         CALL t254_set_required()
         CALL cl_show_fld_cont()
    #FUN-910088--add--start--
         IF NOT cl_null(l_tf1) AND NOT l_tf1  THEN
            NEXT FIELD tsl12
         END IF
    #FUN-910088--add--end--

      BEFORE FIELD tsl12
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_tsl[l_ac].tsl03
         CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl10,l_ima25)
            RETURNING g_cnt,l_fac
         LET g_tsl[l_ac].tsl11 = l_fac

      AFTER FIELD tsl12
      #FUN-910088--add--start--
         LET l_tf1 = NULL               #FUN-C20048--add--
         CALL t254_tsl12_check(l_tsl12,l_tsl09,l_ima906) RETURNING l_tf1,l_tsl12,l_tsl09      
         IF NOT cl_null(l_tf1) AND NOT l_tf1 THEN
            NEXT FIELD tsl12
         END IF
      #FUN-910088--add--end--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_tsl[l_ac].tsl12) THEN
      #     IF g_tsl[l_ac].tsl12<=0 THEN
      #        CALL cl_err('g_tsl[l_ac].tsl12','mfg4012',0)
      #        LET g_tsl[l_ac].tsl12 = g_tsl_t.tsl12
      #        DISPLAY BY NAME g_tsl[l_ac].tsl12
      #        NEXT FIELD tsl12
      #     END IF
      #     IF l_ima906 = '2' THEN                #母子單位
      #        LET l_tsl12 = g_tsl[l_ac].tsl11*g_tsl[l_ac].tsl12
      #        IF g_tsl[l_ac].tsl09 > 0 THEN
      #           LET l_tsl09 = g_tsl[l_ac].tsl09 * g_tsl[l_ac].tsl08
      #        END IF
      #     END IF
      #      #carrier  --Begin
      #     #IF p_cmd = 'a' THEN
      #        IF l_ima906='3' THEN
      #           IF cl_null(g_tsl[l_ac].tsl09) OR g_tsl[l_ac].tsl09=0 OR
      #              g_tsl[l_ac].tsl12 <> g_tsl_t.tsl12 OR cl_null(g_tsl_t.tsl12)
      #           THEN
      #              LET l_fac = 1
      #              CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl10,
      #                             g_tsl[l_ac].tsl07)
      #                   RETURNING g_cnt,l_fac
      #              IF g_cnt = 1 THEN
      #              ELSE
      #                #LET g_tsl[l_ac].tsl09=g_tsl[l_ac].tsl12*g_tsl[l_ac].tsl11
      #                 LET g_tsl[l_ac].tsl09=g_tsl[l_ac].tsl12*l_fac
      #              END IF
      #              DISPLAY BY NAME g_tsl[l_ac].tsl09
      #           END IF
      #        END IF
      #  #  END IF
      #     #carrier  --End
      #  END IF
      #FUN-910088--mark--end--

      BEFORE FIELD tsl07
         CALL t254_set_no_required()

      AFTER FIELD tsl07
         IF NOT cl_null(g_tsl[l_ac].tsl07) THEN
            SELECT COUNT(*) INTO g_cnt
              FROM gfe_file
             WHERE gfe01 = g_tsl[l_ac].tsl07
            IF g_cnt=0 THEN
               CALL cl_err(g_tsl[l_ac].tsl07,'mfg3377',0)
               LET g_tsl[l_ac].tsl07 = g_tsl_t.tsl07
               DISPLAY BY NAME g_tsl[l_ac].tsl07
               NEXT FIELD tsl07
            END IF
            IF (g_tsl[l_ac].tsl07 != g_tsl_t.tsl07)
               OR (g_tsl_t.tsl07 IS NULL) THEN
               SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_tsl[l_ac].tsl03
               CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl07,l_ima25)
                  RETURNING g_cnt,l_fac
               IF g_cnt = 1 THEN
                  CALL cl_err('','mfg3075',1)
                  LET g_tsl[l_ac].tsl07 = g_tsl_t.tsl07
                  DISPLAY BY NAME g_tsl[l_ac].tsl07
                  NEXT FIELD tsl07
               END IF
               LET g_tsl[l_ac].tsl08 = l_fac
               IF (g_tsl[l_ac].tsl08 != g_tsl_t.tsl08) THEN
                  IF cl_null(g_tsl[l_ac].tsl08) THEN LET g_tsl[l_ac].tsl08 = 1 END IF
                  LET l_tsl09 = g_tsl[l_ac].tsl08*g_tsl[l_ac].tsl09
                  LET l_tsl09 = s_digqty(l_tsl09,g_tsl[l_ac].tsl07)    #FUN-910088--add--
                  CALL s_chk_va_setting(g_tsl[l_ac].tsl03)
                     RETURNING g_flag,l_ima906,l_ima907
                  IF l_ima906 = '2' THEN
                     IF g_tsl[l_ac].tsl12 > 0 THEN
                        LET l_tsl12 = g_tsl[l_ac].tsl12 * g_tsl[l_ac].tsl11
                        LET l_tsl12 = s_digqty(l_tsl12,g_tsl[l_ac].tsl10)    #FUN-910088--add--
                     END IF
                  ELSE
                     LET l_tsl12 = 0
                  END IF
               END IF
               #carrier  --Begin
               IF l_ima906 = '3' THEN
                  IF cl_null(g_tsl[l_ac].tsl09) OR g_tsl[l_ac].tsl09=0 OR
                     g_tsl[l_ac].tsl07 <> g_tsl_t.tsl07 THEN
                     LET l_fac = 1
                     CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl10,
                                    g_tsl[l_ac].tsl07)
                          RETURNING g_cnt,l_fac
                     IF g_cnt = 1 THEN
                     ELSE
                        LET g_tsl[l_ac].tsl09=g_tsl[l_ac].tsl12*l_fac
                        LET g_tsl[l_ac].tsl09 = s_digqty(g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl07)   #FUN-910088--add--
                     END IF
                     DISPLAY BY NAME g_tsl[l_ac].tsl09
                  END IF
               END IF
               #carrier  --End
            END IF
         ELSE
            LET l_tsl09 = 0
         END IF
         CALL t254_set_required()
         CALL cl_show_fld_cont()
      #FUN-910088--add--start--
         LET l_case = ""
         IF NOT cl_null(g_tsl[l_ac].tsl09) AND g_tsl[l_ac].tsl09<>0 THEN #FUN-C20068 add
            CALL t254_tsl09_check(l_tsl09,l_tsl12) RETURNING l_case,l_tsl09,l_tsl12
         END IF                                                          #FUN-C20068 add
         LET g_tsl07_t = g_tsl[l_ac].tsl07
         CASE l_case           
            WHEN "tsl09"
               LET g_tsl07_t = g_tsl[l_ac].tsl07
               NEXT FIELD tsl09
            WHEN "tsl07"
               LET g_tsl07_t = g_tsl[l_ac].tsl07
               NEXT FIELD tsl07
            OTHERWISE EXIT CASE
         END CASE
      #FUN-910088--add--end--

      BEFORE FIELD tsl09
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_tsl[l_ac].tsl03
         CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl07,l_ima25)
            RETURNING g_cnt,l_fac
         LET g_tsl[l_ac].tsl08 = l_fac

      AFTER FIELD tsl09
      #FUN-910088--add--start--
         LET l_case = ""
         CALL t254_tsl09_check(l_tsl09,l_tsl12) RETURNING l_case,l_tsl09,l_tsl12
         CASE l_case            
            WHEN "tsl09"
               NEXT FIELD tsl09
            WHEN "tsl07"
               NEXT FIELD tsl07
            OTHERWISE EXIT CASE
         END CASE
      #FUN-910088--add--end--
      #FUN-910088--mark--start--
      #  IF NOT cl_null(g_tsl[l_ac].tsl09) THEN
      #     IF g_tsl[l_ac].tsl09<=0 THEN
      #        CALL cl_err('g_tsl[l_ac].tsl09','mfg4012',0)
      #        LET g_tsl[l_ac].tsl09 = g_tsl_t.tsl09
      #        DISPLAY BY NAME g_tsl[l_ac].tsl09
      #        NEXT FIELD tsl09
      #     END IF
      #     IF cl_null(g_tsl[l_ac].tsl08) THEN LET g_tsl[l_ac].tsl08 = 1 END IF
      #     LET l_tsl09 = g_tsl[l_ac].tsl08*g_tsl[l_ac].tsl09
      #     CALL s_chk_va_setting(g_tsl[l_ac].tsl03)
      #        RETURNING g_flag,l_ima906,l_ima907
      #     IF l_ima906 = '2' THEN
      #        IF g_tsl[l_ac].tsl12 > 0 THEN
      #           LET l_tsl12 = g_tsl[l_ac].tsl12 * g_tsl[l_ac].tsl11
      #        END IF
      #     ELSE
      #        LET l_tsl12 = 0
      #     END IF
      #     CALL t254_du_data_to_correct()
      #     LET g_tsl[l_ac].tsl05 = l_tsl12 + l_tsl09
      #     IF g_tsl[l_ac].tsl05 IS NULL OR g_tsl[l_ac].tsl05=0 THEN
      #        IF l_ima906 MATCHES '[23]' THEN
      #           NEXT FIELD tsl09
      #        ELSE
      #           NEXT FIELD tsl07
      #        END IF
      #     END IF
      #  ELSE
      #     LET l_tsl09 = 0
      #  END IF
      #  CALL cl_show_fld_cont()
      #FUN-910088--mark--

      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tsl[l_ac].* TO NULL      #900423
         INITIALIZE arr_detail[l_ac].* TO NULL #No.TQC-650090
         LET g_tsl_t.* = g_tsl[l_ac].*         #新輸入資料
         LET g_tsl_o.* = g_tsl[l_ac].*         #新輸入資料
      #FUN-910088--add--start--
         LET g_tsl04_t = NULL
         LET g_tsl07_t = NULL
         LET g_tsl10_t = NULL
      #FUN-910088--add--end--
         LET g_tsl[l_ac].tsl05 =  0            #Body default
         LET g_tsl[l_ac].tsl12 =  0            #Body default
         LET g_tsl[l_ac].tsl09 =  0            #Body default
         CALL cl_show_fld_cont()
         CALL t254_set_entry_b(p_cmd)
         CALL t254_set_no_entry_b(p_cmd)
         NEXT FIELD tsl02

      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF g_sma.sma115 = 'Y' THEN
            CALL s_chk_va_setting(g_tsl[l_ac].tsl03)
               RETURNING g_flag,l_ima906,l_ima907
            IF g_flag=1 THEN
               NEXT FIELD tsl03
            END IF
            CALL t254_du_data_to_correct()
            #carrier  --Begin
            CALL t254_set_origin_field()
            #carrier  --End
         END IF
         #carrier --Begin
         #IF l_tsl09 >0 OR l_tsl12 >  0 THEN
         #   LET g_tsl[l_ac].tsl05 = l_tsl09 + l_tsl12
         #END IF
         #carrier --End
         INSERT INTO tsl_file(tsl01,tsl02,tsl03,tsl04,
                              tsl05,tsl07,tsl08,
                              tsl09,tsl10,tsl11,tsl12,
                              tsl13,tsllegal,tslplant)    #No.FUN-870007
                       VALUES(g_tsk.tsk01,g_tsl[l_ac].tsl02,g_tsl[l_ac].tsl03,
                              g_tsl[l_ac].tsl04,g_tsl[l_ac].tsl05,
                              g_tsl[l_ac].tsl07,g_tsl[l_ac].tsl08,g_tsl[l_ac].tsl09,
                              g_tsl[l_ac].tsl10,g_tsl[l_ac].tsl11,g_tsl[l_ac].tsl12,
                              g_tsl[l_ac].tsl13,g_tsk.tsklegal,g_tsk.tskplant)     #No.FUN-870007
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tsl_file",g_tsl[l_ac].tsl02,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            CALL t254_weight_cubage('0')
            LET g_rec_b = g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF

      BEFORE DELETE                            #是否取消單身
         DISPLAY "BEFORE DELETE"
         IF g_tsl_t.tsl02 > 0 AND g_tsl_t.tsl02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM tsl_file
             WHERE tsl01 = g_tsk.tsk01
               AND tsl02 = g_tsl_t.tsl02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tsl_file",g_tsl_t.tsl02,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               CALL t254_rvbs('atmt254',g_tsk.tsk01,g_tsl[l_ac].tsl02,g_tsk.tsk01,g_tsl[l_ac].tsl02,'DEL')
            END IF
            CALL t254_weight_cubage('0')
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tsl[l_ac].* = g_tsl_t.*
            CLOSE t254_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tsl[l_ac].tsl02,-263,1)
            LET g_tsl[l_ac].* = g_tsl_t.*
         ELSE
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_tsl[l_ac].tsl03)
                  RETURNING g_flag,l_ima906,l_ima907
               IF g_flag=1 THEN
                  NEXT FIELD tsl03
               END IF
               CALL t254_du_data_to_correct()
               #carrier  --Begin
               CALL t254_set_origin_field()
               #carrier  --End
            END IF
            IF cl_null(g_tsl[l_ac].tsl02) THEN    #重要欄位空白,無效
               INITIALIZE g_tsl[l_ac].* TO NULL
            END IF
            #carrier --Begin
            #IF l_tsl09 >0 OR l_tsl12 >  0 THEN
            #   LET g_tsl[l_ac].tsl05 = l_tsl09 + l_tsl12
            #END IF
            #carrier --End
            UPDATE tsl_file SET tsl02=g_tsl[l_ac].tsl02,
                                tsl03=g_tsl[l_ac].tsl03,
                                tsl04=g_tsl[l_ac].tsl04,
                                tsl05=g_tsl[l_ac].tsl05,
                                tsl10=g_tsl[l_ac].tsl10,
                                tsl11=g_tsl[l_ac].tsl11,
                                tsl12=g_tsl[l_ac].tsl12,
                                tsl07=g_tsl[l_ac].tsl07,
                                tsl08=g_tsl[l_ac].tsl08,
                                tsl09=g_tsl[l_ac].tsl09
                          WHERE tsl01=g_tsk.tsk01
                            AND tsl02=g_tsl_t.tsl02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_tsl[l_ac].* = g_tsl_t.*
#              DISPLAY g_tsl[l_ac].* TO s_tsl[l_sl].*
            ELSE
               MESSAGE 'UPDATE O.K'
               CALL t254_weight_cubage('0')
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_tsl[l_ac].* = g_tsl_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_tsl.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE t254_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30033 add
         CLOSE t254_bcl
         COMMIT WORK

      ON ACTION CONTROLO
         IF INFIELD(tsl02) AND l_ac > 1 THEN
            LET g_tsl[l_ac].* = g_tsl[l_ac-1].*
            LET g_tsl[l_ac].tsl02 = 0
            DISPLAY BY NAME g_tsl[l_ac].*  #No.TQC-6C0217
            NEXT FIELD tsl02
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION controlp
         CASE
            #No.TQC-650090--begin
            #新增的母料件開窗
            #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
            #BEFORE FIELD att00來做開窗了
            #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
            WHEN INFIELD(att00)
               #可以新增子料件,開窗是單純的選取母料件
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_ima_p"
#              LET g_qryparam.arg1 = lg_group
#              CALL cl_create_qry() RETURNING g_tsl[l_ac].att00
               CALL q_sel_ima(FALSE, "q_ima_p","","",lg_group,"","","","",'' ) 
                   RETURNING  g_tsl[l_ac].att00 
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_tsl[l_ac].att00
               NEXT FIELD att00
              #No.TQC-650090--end
            WHEN INFIELD(tsl03)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form  = "q_ima"
#              CALL cl_create_qry() RETURNING g_tsl[l_ac].tsl03
               CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                   RETURNING  g_tsl[l_ac].tsl03 
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_tsl[l_ac].tsl03
               NEXT FIELD tsl03
            WHEN INFIELD(tsl04)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gfe"
               CALL cl_create_qry() RETURNING g_tsl[l_ac].tsl04
               DISPLAY BY NAME g_tsl[l_ac].tsl04
               NEXT FIELD tsl04
            WHEN INFIELD(tsl10)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gfe"
               CALL cl_create_qry() RETURNING g_tsl[l_ac].tsl10
               DISPLAY BY NAME g_tsl[l_ac].tsl10
               NEXT FIELD tsl10
            WHEN INFIELD(tsl07)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gfe"
               CALL cl_create_qry() RETURNING g_tsl[l_ac].tsl07
               DISPLAY BY NAME g_tsl[l_ac].tsl07
               NEXT FIELD tsl07
         END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
#NO.FUN-6B0031--BEGIN
        ON ACTION CONTROLS
           CALL cl_set_head_visible("","AUTO")
#NO.FUN-6B0031--END
   END INPUT

   CLOSE t254_bcl
   COMMIT WORK
#  CALL t254_delall()  #CHI-C30002 mark
   CALL t254_delHeader()     #CHI-C30002 add
   CALL t254_weight_cubage('0')
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t254_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_tsk.tsk01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tsk_file ",
                  "  WHERE tsk01 LIKE '",l_slip,"%' ",
                  "    AND tsk01 > '",g_tsk.tsk01,"'"
      PREPARE t254_pb1 FROM l_sql 
      EXECUTE t254_pb1 INTO l_cnt       
      
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
         CALL t254_c(1)
         CALL t254_field_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM tsk_file WHERE tsk01 = g_tsk.tsk01
         INITIALIZE g_tsk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t254_delall()

#  SELECT COUNT(*) INTO g_cnt FROM tsl_file
#   WHERE tsl01 = g_tsk.tsk01

#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM tsk_file WHERE tsk01 = g_tsk.tsk01
#     INITIALIZE g_tsk.* TO NULL
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION t254_tsl03(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_imaacti   LIKE ima_file.imaacti
   DEFINE l_ima25     LIKE ima_file.ima25

   LET g_errno = ''
   #顯示品名
   SELECT ima02,ima135,ima25,imaacti
     INTO g_tsl[l_ac].ima02,g_tsl[l_ac].ima135,l_ima25,l_imaacti
     FROM ima_file
    WHERE ima01=g_tsl[l_ac].tsl03

   CASE WHEN SQLCA.SQLCODE = 100       LET g_errno = STATUS
                                       LET g_tsl[l_ac].ima02 =''
                                       LET g_tsl[l_ac].ima135 =''
        WHEN l_imaacti='N'             LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022 add
        OTHERWISE                      LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
#No.FUN-870007-start-
   IF g_azw.azw04='2' THEN
      SELECT rta05 INTO g_tsl[l_ac].ima135
        FROM rta_file
       WHERE rta01 = g_tsl[l_ac].tsl03
         AND rta03 = g_ima25
         AND rtaacti = 'Y'
   END IF
#No.FUN-870007--end--
   IF NOT cl_null(g_errno) THEN
      LET g_tsl[l_ac].ima02  = g_tsl_t.ima02
      LET g_tsl[l_ac].ima135 = g_tsl_t.ima135
   END IF
   DISPLAY g_tsl[l_ac].ima02  TO FORMONLY.ima02
   DISPLAY g_tsl[l_ac].ima135  TO FORMONLY.ima135

END FUNCTION

FUNCTION t254_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2           LIKE type_file.chr1000

   IF cl_null(p_wc2) THEN
      LET p_wc2 = "  1=1"
   END IF
   LET g_sql = " SELECT tsl02,tsl13,tsl03,",               #No.FUN-870007
               "        '','','','','','','','','','','','','','','','','','','','','','','',",
               "        tsl04,tsl05, ",
               "        tsl10,tsl11,tsl12,tsl07,tsl08,tsl09 ",
               "   FROM tsl_file ",
               "  WHERE tsl01 = '",g_tsk.tsk01,"' ",
               "    AND ",p_wc2 CLIPPED,
               "  ORDER BY tsl02"
   PREPARE t254_pb FROM g_sql
   DECLARE tsl_curs CURSOR FOR t254_pb

   CALL g_tsl.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH tsl_curs INTO g_tsl[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima02,ima135
        INTO g_tsl[g_cnt].ima02,g_tsl[g_cnt].ima135
        FROM ima_file
       WHERE ima01=g_tsl[g_cnt].tsl03
#No.FUN-870007-start-
      IF g_azw.azw04='2' THEN
         SELECT rta05 INTO g_tsl[g_cnt].ima135
           FROM rta_file
          WHERE rta01 = g_tsl[g_cnt].tsl03
            AND rta03 = g_tsl[g_cnt].tsl04
            AND rtaacti = 'Y'
      END IF
#No.FUN-870007--end--
      #No.TQC-650090--begin
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_tsl[g_cnt].att00,g_tsl[g_cnt].att01,g_tsl[g_cnt].att02,
                g_tsl[g_cnt].att03,g_tsl[g_cnt].att04,g_tsl[g_cnt].att05,
                g_tsl[g_cnt].att06,g_tsl[g_cnt].att07,g_tsl[g_cnt].att08,
                g_tsl[g_cnt].att09,g_tsl[g_cnt].att10
         FROM imx_file WHERE imx000 = g_tsl[g_cnt].tsl03

         LET g_tsl[g_cnt].att01_c = g_tsl[g_cnt].att01
         LET g_tsl[g_cnt].att02_c = g_tsl[g_cnt].att02
         LET g_tsl[g_cnt].att03_c = g_tsl[g_cnt].att03
         LET g_tsl[g_cnt].att04_c = g_tsl[g_cnt].att04
         LET g_tsl[g_cnt].att05_c = g_tsl[g_cnt].att05
         LET g_tsl[g_cnt].att06_c = g_tsl[g_cnt].att06
         LET g_tsl[g_cnt].att07_c = g_tsl[g_cnt].att07
         LET g_tsl[g_cnt].att08_c = g_tsl[g_cnt].att08
         LET g_tsl[g_cnt].att09_c = g_tsl[g_cnt].att09
         LET g_tsl[g_cnt].att10_c = g_tsl[g_cnt].att10
      END IF
      #No.TQC-650090--end

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
   CALL g_tsl.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2

   CALL t254_refresh_detail() #No.TQC-650090
END FUNCTION

FUNCTION t254_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tsl TO s_tsl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()

      #FUN-D10081---add---str---
      ON ACTION page_list 
         LET g_action_flag="page_list"
         EXIT DISPLAY
      #FUN-D10081---add---end---
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
         CALL t254_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION previous
         CALL t254_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION jump
         CALL t254_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION next
         CALL t254_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION last
         CALL t254_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

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

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL t254_field_pic()
         CALL cl_show_fld_cont()
         CALL t254_def_form()
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      #@ON ACTION 審核
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      #@ON ACTION 取消審核
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end
      #FUN-D20039 ------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ------------end
      ON ACTION triangletrade
         LET g_action_choice="triangletrade"
         EXIT DISPLAY

      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY

      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY

      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

#NO.FUN-6B0031--BEGIN
      ON ACTION CONTROLS
         CALL cl_set_head_visible("","AUTO")
#NO.FUN-6B0031--END

      ON ACTION related_document                #No:FUN-6B0043  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t254_copy()
   DEFINE l_newno         LIKE tsk_file.tsk01,
          l_oldno         LIKE tsk_file.tsk01
   DEFINE li_result       LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#No.FUN-870007-start-
   IF g_tsk.tsk23 = '2' THEN
      CALL cl_err('','art-485',0)
      RETURN
   END IF
#No.FUn-870007--end--

   LET g_before_input_done = FALSE
   CALL t254_set_entry('a')

   LET l_oldno = g_tsk.tsk01
   LET l_newno = NULL
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT l_newno FROM tsk01

      BEFORE INPUT
         CALL cl_set_docno_format("tsk01")

      AFTER FIELD tsk01
         IF cl_null(l_newno) THEN NEXT FIELD tsk01 END IF
         CALL s_check_no("apm",l_newno,"","9","tsk_file","tsk01","")
              RETURNING li_result,l_newno
         IF NOT li_result THEN
            LET l_newno = NULL
            DISPLAY l_newno TO tsk01
            NEXT FIELD tsk01
         END IF
         BEGIN WORK
         CALL s_auto_assign_no("apm",l_newno,g_tsk.tsk02,"","tsk_file","tsk01","","","")
              RETURNING li_result,l_newno
         IF NOT li_result THEN
            NEXT FIELD tsk01
         END IF
         DISPLAY l_newno TO tsk01

      ON ACTION controlp
         CASE
            WHEN INFIELD(tsk01) #單據編號
               LET g_t1 = s_get_doc_no(l_newno)
              #CALL q_smy(FALSE,FALSE,g_t1,'apm','9') RETURNING g_t1  #TQC-670008
               CALL q_smy(FALSE,FALSE,g_t1,'APM','9') RETURNING g_t1  #TQC-670008
               LET l_newno = g_t1
               DISPLAY BY NAME l_newno
               NEXT FIELD tsk01
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_tsk.tsk01
      RETURN
   END IF

   DROP TABLE y

   SELECT * FROM tsk_file         #單頭復制
    WHERE tsk01=g_tsk.tsk01
     INTO TEMP y

   UPDATE y SET tsk01=l_newno,    #新的鍵值
                tsk05='1',
                tsk06=NULL,
                tsk07=NULL,
                tsk11=NULL,
                tsk12=NULL,
                tsk13=NULL,
                tsk14=NULL,
                tsk15=NULL,
                tsk16=NULL,
                tsk20='0',
                tskuser=g_user,   #資料所有者
                tskgrup=g_grup,   #資料所有者所屬群
                tskorig=g_grup,   #TQC-A30048 ADD
                tskoriu=g_user,   #TQC-A30048 ADD
                tskconu=NULL,       #FUN-A30063 ADD
                tskcond=NULL,       #FUN-A30063 ADD
                tskcont=NULL,       #FUN-A30063 ADD
                tskmodu=NULL,     #資料修改日期
                tskdate=g_today,  #資料建立日期
                tskacti='Y'       #有效資料

   INSERT INTO tsk_file SELECT * FROM y

   DROP TABLE x

   SELECT * FROM tsl_file         #單身復制
    WHERE tsl01=g_tsk.tsk01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tsl_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET tsl01=l_newno

   INSERT INTO tsl_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tsl_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)         #FUN-B80061    ADD
      ROLLBACK WORK
     # CALL cl_err3("ins","tsl_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)        #FUN-B80061    MARK
      RETURN
   ELSE
      COMMIT WORK
   END IF

   LET l_oldno = g_tsk.tsk01
   SELECT tsk_file.* INTO g_tsk.* FROM tsk_file WHERE tsk01 = l_newno
   CALL t254_u()
   CALL t254_b()
   #SELECT tsk_file.* INTO g_tsk.* FROM tsk_file WHERE tsk01 = l_oldno  #FUN-C80046
   #CALL t254_show()  #FUN-C80046

END FUNCTION

FUNCTION t254_azp(l_azp01)
   DEFINE l_azp01        LIKE azp_file.azp01
   DEFINE p_dbs          LIKE type_file.chr21
   DEFINE p_dbs_tra      LIKE type_file.chr21
   DEFINE p_plant_new    LIKE azp_file.azp01

    # FUN-980093 add----GP5.2 Modify #改抓Transaction DB
    LET g_plant_new = l_azp01
    LET p_plant_new = g_plant_new
    CALL s_getdbs()
    LET p_dbs = g_dbs_new
    CALL s_gettrandbs()
    LET p_dbs_tra = g_dbs_tra
    #--End   FUN-980093 add-------------------------------------

    RETURN p_dbs,p_dbs_tra,p_plant_new

END FUNCTION

FUNCTION t254_imd02(p_imd01,p_plant,p_cmd)
   DEFINE p_imd01         LIKE imd_file.imd01
   DEFINE p_plant         LIKE azp_file.azp01
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_imd02         LIKE imd_file.imd02
   DEFINE l_imd10         LIKE imd_file.imd10
   DEFINE l_imd11         LIKE imd_file.imd11
   DEFINE l_imdacti       LIKE imd_file.imdacti
   #DEFINE l_dbs           LIKE type_file.chr21

   LET g_errno=''

   #LET g_plant_new = p_plant
   #CALL s_getdbs()
   #LET l_dbs = g_dbs_new

   LET g_sql = "SELECT imd02,imd10,imd11,imdacti ",
               #"  FROM ",l_dbs CLIPPED,"imd_file",
               "  FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
               " WHERE imd01 = '",p_imd01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE imd_pre1 FROM g_sql
   EXECUTE imd_pre1 INTO l_imd02,l_imd10,l_imd11,l_imdacti

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
                                  LET l_imd02 = NULL
        WHEN l_imd11 = 'N' OR l_imdacti = 'N'
                                  LET g_errno = 'axm-993'
        WHEN l_imd10 <> 'S'       LET g_errno = 'axd-022'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_imd02 TO FORMONLY.imd02
   END IF

END FUNCTION

FUNCTION t254_tsk08(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_genacti LIKE gen_file.genacti

   LET g_errno = ' '
   SELECT gen02,gen03,genacti
     INTO l_gen02,l_gen03,l_genacti
     FROM gen_file
    WHERE gen01 = g_tsk.tsk08

   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF p_cmd = 'a' AND cl_null(g_errno) THEN
      LET g_tsk.tsk09   = l_gen03
#     LET g_tsk_t.tsk09 = l_gen03               #TQC-C20155 mark
   END IF
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION

FUNCTION t254_tsk09(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gemacti LIKE gen_file.genacti
   DEFINE l_gem02   LIKE gem_file.gem02

   LET g_errno = ' '
   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti
    FROM gem_file
    WHERE gem01 = g_tsk.tsk09
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION

FUNCTION t254_def_form()

    CALL cl_set_comp_visible("tsl08,tsl11",FALSE)
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("tsl07,tsl08,tsl09",FALSE)
       CALL cl_set_comp_visible("tsl10,tsl11,tsl12",FALSE)
    ELSE
       CALL cl_set_comp_visible("tsl04,tsl05",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tsl10",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tsl12",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tsl07",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tsl09",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tsl10",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tsl12",g_msg CLIPPED)
       CALL cl_getmsg('asm-351',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tsl07",g_msg CLIPPED)
       CALL cl_getmsg('asm-352',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("tsl09",g_msg CLIPPED)
    END IF
    CALL cl_set_comp_visible('grhide',g_azw.azw04='2')  #No.FUN-870007
    CALL cl_set_comp_visible('tsl13',g_azw.azw04='2')   #No.FUN-870007
    CALL cl_set_comp_entry('tsk03',g_azw.azw04 <> '2')  #No.FUN-870007
END FUNCTION

FUNCTION t254_weight_cubage(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,
          l_tsl02   LIKE tsl_file.tsl02,
          l_tsl03   LIKE tsl_file.tsl03,
          l_tsl04   LIKE tsl_file.tsl04,
          l_tsl05   LIKE tsl_file.tsl05,
          l_tsk21   LIKE tsk_file.tsk21,
          l_tsk22   LIKE tsk_file.tsk22

   LET g_tsk.tsk21 = 0
   LET g_tsk.tsk22 = 0
   DECLARE t254_b2_b CURSOR FOR
     SELECT tsl02,tsl03,tsl04,tsl05
       FROM tsl_file
      WHERE tsl01 = g_tsk.tsk01
      ORDER BY tsl02

   FOREACH t254_b2_b INTO l_tsl02,l_tsl03,l_tsl04,l_tsl05
      IF p_cmd = '0' THEN
         CALL s_weight_cubage(l_tsl03,l_tsl04,l_tsl05)
            RETURNING l_tsk21,l_tsk22
      END IF
      LET g_tsk.tsk21 = g_tsk.tsk21 + l_tsk21
      LET g_tsk.tsk22 = g_tsk.tsk22 + l_tsk22
   END FOREACH
   IF g_tsk.tsk22 > 0 OR g_tsk.tsk21 > 0 THEN
      UPDATE tsk_file SET tsk21 = g_tsk.tsk21,
                          tsk22 = g_tsk.tsk22
                    WHERE tsk01 = g_tsk.tsk01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN

         CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
         RETURN
      END IF
      DISPLAY BY NAME g_tsk.tsk21
      DISPLAY BY NAME g_tsk.tsk22
   END IF

END FUNCTION

#過帳
FUNCTION t254_post()

   CALL t254_p1()

END FUNCTION

FUNCTION t254_p1()
   DEFINE l_tsk05           LIKE tsk_file.tsk05
   DEFINE l_dbs             LIKE type_file.chr21
   DEFINE l_dbs_tra         LIKE type_file.chr21
   DEFINE l_pmm01           LIKE pmm_file.pmm01
   DEFINE l_poz17           LIKE poz_file.poz17
   DEFINE l_last_poy02      LIKE poy_file.poy02
   DEFINE l_last_poy04      LIKE poy_file.poy04
   DEFINE l_last_dbs        LIKE type_file.chr21
   DEFINE l_last_dbs_tra    LIKE type_file.chr21
   DEFINE p_plant_new       LIKE azp_file.azp01
   DEFINE p_plant_new_a     LIKE azp_file.azp01
   DEFINE l_pmm99           LIKE pmm_file.pmm99

   IF s_shut(0) THEN RETURN END IF
   IF g_tsk.tsk01 IS NULL THEN CALL cl_err('',-400,0)      RETURN END IF
   IF g_tsk.tskacti = 'N' THEN CALL cl_err('','aap-127',0) RETURN END IF
   IF g_tsk.tsk05 = '1'   THEN CALL cl_err('','aap-717',0) RETURN END IF
   IF g_tsk.tsk05 = '3'   THEN CALL cl_err('','asf-812',0) RETURN END IF
   IF g_tsk.tsk05 = '4'   THEN CALL cl_err('','axr-315',0) RETURN END IF
   IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041

   CREATE TEMP TABLE p801_file(
        p_no     LIKE type_file.num5,
        so_no    LIKE pmm_file.pmm01,
        so_item  LIKE type_file.num5,
        so_price LIKE oeb_file.oeb13,
        so_price2 LIKE pmn_file.pmn31t, #TQC-D70073
        so_curr  LIKE pmm_file.pmm22);

   DELETE FROM p801_file;

   CREATE TEMP TABLE p900_file(
       p_no        LIKE type_file.num5,
       pab_no      LIKE oea_file.oea01,
       pab_item    LIKE type_file.num5,
       pab_price   LIKE type_file.num20_6);
   DELETE FROM p900_file;

   BEGIN WORK
   LET g_success='Y'

   OPEN t254_cl USING g_tsk.tsk01
   IF STATUS THEN
      CALL cl_err("OPEN t254_cl:", STATUS, 1)
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t254_cl INTO g_tsk.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL s_showmsg_init()

   IF cl_confirm('mfg0176') THEN
      #1.需求工廠--產生采購單
      CALL t254_pmm_ins()
      IF g_success = 'N' THEN
         CLOSE t254_cl
         ROLLBACK WORK
         CALL s_showmsg()
         RETURN
      END IF

      #2.代采買--正拋
      LET g_from_plant = g_tsk.tsk03     #拋轉資料的來源
    # CALL p801(g_pmm.pmm01,'N')  #call 多角抛转  #No.FUN-A30056                
      CALL p801(g_pmm.pmm01,'N',TRUE)             #No.FUN-A30056
      IF g_success = 'N' THEN
         CLOSE t254_cl
         ROLLBACK WORK
         CALL s_showmsg()
         RETURN
      END IF
      LET l_tsk05 = '4'

      LET l_pmm01 = g_pmm.pmm01

      #CALL t254_azp(g_tsk.tsk03) RETURNING l_dbs,l_dbs_tra,p_plant_new            #FUN-A50102

      #LET g_sql = " SELECT pmm99 FROM ",l_dbs_tra CLIPPED,"pmm_file ",
      LET g_sql = " SELECT pmm99 FROM ",cl_get_target_table(g_tsk.tsk03,'pmm_file'), #FUN-A50102
                  "  WHERE pmm01 = '",g_pmm.pmm01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql
      PREPARE pmm99_2_pre FROM g_sql
      EXECUTE pmm99_2_pre INTO l_pmm99
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pmm01',g_pmm.pmm01,'select pmm99',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF

      SELECT poz17 INTO l_poz17 FROM poz_file WHERE poz01 = g_tsk.tsk07
      IF cl_null(l_poz17) THEN LET l_poz17 = 'N' END IF
      #多角貿易流程需一次完成
      IF l_poz17 = 'Y' THEN
         #3.出貨工廠--生成出貨單
         CALL t254_oga_ins(l_pmm01)
         IF g_success = 'N' THEN
            CLOSE t254_cl
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF

         CALL s_mtrade_last_plant(g_tsk.tsk07)     #最后一站的站別 & 營運中心
              RETURNING l_last_poy02,l_last_poy04
         #CALL t254_azp(l_last_poy04) RETURNING l_last_dbs,l_last_dbs_tra,p_plant_new_a

         #4.出貨工廠--出貨單過帳
         CALL t254_1('6',g_oga.oga01,l_last_poy04,g_tsk.tsk07,l_pmm99)   #出貨單過帳
         IF g_success = 'N' THEN
            CLOSE t254_cl
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF

         #5.銷售逆拋
         CALL p900_p2(g_oga.oga01,g_oga.oga09,l_last_poy04)    #多角拋轉
         IF g_success = 'N' THEN
            CLOSE t254_cl
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF
         LET l_tsk05 = '3'
      END IF

      LET g_tsk.tsk06 = l_pmm99
      UPDATE tsk_file SET tsk05   = l_tsk05,
                          tsk06   = g_tsk.tsk06,
                          tskmodu = g_user,
                          tskdate = g_today
                    WHERE tsk01   = g_tsk.tsk01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('tsk01',g_tsk.tsk01,"UPDATE tsk_file",SQLCA.sqlcode,1)
         LET g_tsk.tsk06 = NULL
         LET g_success = 'N'
      ELSE
         LET g_tsk.tsk05 = l_tsk05
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL s_showmsg()
   DROP TABLE p801_file;
   DROP TABLE p900_file;

   DISPLAY BY NAME g_tsk.tsk05
   DISPLAY BY NAME g_tsk.tsk06
   CLOSE t254_cl

   CALL t254_field_pic()
   #No.FUN-A10099  --End

END FUNCTION

#取消過帳
FUNCTION t254_p2()
   DEFINE l_dbs             LIKE type_file.chr21
   DEFINE l_dbs_tra         LIKE type_file.chr21
   DEFINE l_last_poy02      LIKE poy_file.poy02
   DEFINE l_last_poy04      LIKE poy_file.poy04
   DEFINE l_last_dbs        LIKE type_file.chr21
   DEFINE l_last_dbs_tra    LIKE type_file.chr21
   DEFINE p_plant_new       LIKE azp_file.azp01
   DEFINE p_plant_new_a     LIKE azp_file.azp01
   DEFINE l_pmm01           LIKE pmm_file.pmm01
   DEFINE ll_oga01          LIKE oga_file.oga01
   DEFINE ll_oga09          LIKE oga_file.oga09
   DEFINE l_poz17           LIKE poz_file.poz17
   DEFINE l_tm              RECORD
                            ogb01   LIKE ogb_file.ogb01,
                            ogb03   LIKE ogb_file.ogb03,
                            ogb04   LIKE ogb_file.ogb04,
                            ogb09   LIKE ogb_file.ogb09,
                            ogb091  LIKE ogb_file.ogb091,
                            ogb092  LIKE ogb_file.ogb092
                            END RECORD

   IF s_shut(0) THEN RETURN END IF
   IF g_tsk.tsk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041
   IF g_tsk.tsk05 NOT MATCHES '[34]' THEN CALL cl_err('','mfg0178',0) RETURN END IF

   BEGIN WORK
   LET g_success='Y'

   OPEN t254_cl USING g_tsk.tsk01
   IF STATUS THEN
      CALL cl_err("OPEN t254_cl:", STATUS, 1)
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t254_cl INTO g_tsk.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,1)
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL s_showmsg_init()
   IF cl_confirm('asf-663') THEN
      #1.檢查需求工廠--采購單是否還存在
      #CALL t254_azp(g_tsk.tsk03) RETURNING l_dbs,l_dbs_tra,p_plant_new             #FUN-A50102

      #LET g_sql = " SELECT pmm01 FROM ",l_dbs_tra CLIPPED,"pmm_file ",
      LET g_sql = " SELECT pmm01 FROM ",cl_get_target_table(g_tsk.tsk03,'pmm_file'), #FUN-A50102
                  "  WHERE pmm99 = '",g_tsk.tsk06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql #FUN-980093
      PREPARE pmm99_pl FROM g_sql
      EXECUTE pmm99_pl INTO l_pmm01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pmm99',g_tsk.tsk06,'SELECT pmm','mfg3188',1)
         ROLLBACK WORK
         CALL s_showmsg()
         RETURN
      END IF

      #2.采購單若是倉退,則不能做過帳還原
      LET g_sql = "SELECT COUNT(*) ",
                  #"  FROM ",l_dbs_tra CLIPPED,"rvv_file,",l_dbs_tra CLIPPED,"rvu_file",
                  "  FROM ",cl_get_target_table(g_tsk.tsk03,'rvv_file'),",",cl_get_target_table(g_tsk.tsk03,'rvu_file'), #FUN-A50102
                  " WHERE rvv36= '",l_pmm01,"'",
                  "   AND rvu00 = '3' and rvu01 = rvv01 "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql #FUN-980093
      PREPARE rvv_pl FROM g_sql
      EXECUTE rvv_pl INTO g_cnt
      IF g_cnt > 0 THEN
         CALL s_errmsg('rvv36',l_pmm01,'SELECT rvv','axm-650',1)
         ROLLBACK WORK
         CALL s_showmsg()
         RETURN
      END IF

      SELECT poz17 INTO l_poz17 FROM poz_file WHERE poz01 = g_tsk.tsk07
      IF cl_null(l_poz17) THEN LET l_poz17 = 'N' END IF
      #多角貿易流程需一次完成
      IF l_poz17 = 'Y' THEN
         CALL s_mtrade_last_plant(g_tsk.tsk07)     #最后一站的站別 & 營運中心
              RETURNING l_last_poy02,l_last_poy04
         #CALL t254_azp(l_last_poy04) RETURNING l_last_dbs,l_last_dbs_tra,p_plant_new_a #FUN-A50102

         #3.Check出貨單是否存在
         LET g_sql = " SELECT oga01,oga09 ",
                     #"   FROM ",l_last_dbs_tra CLIPPED,"oga_file ",
                     "   FROM ",cl_get_target_table(l_last_poy04,'oga_file'), #FUN-A50102
                     "  WHERE oga99 = '",g_tsk.tsk06,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
         PREPARE oga01_sel FROM g_sql
         EXECUTE oga01_sel INTO ll_oga01,ll_oga09
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('oga99',g_tsk.tsk06,'SELECT oga','atm-151',1)
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF

         #4.出貨單逆拋還原
         CALL p901_p2(ll_oga01,ll_oga09,l_last_poy04)
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF

         #5.出貨單--過帳還原
         CALL t254_p2_s(ll_oga01,l_last_poy04,g_tsk.tsk07)
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF

         #6.刪除出貨單對應內容 -oga/ogb/rvbs/tlfs
         #LET g_sql = " DELETE FROM ",l_last_dbs_tra CLIPPED,"oga_file",
         LET g_sql = " DELETE FROM ",cl_get_target_table(l_last_poy04,'oga_file'), #FUN-A50102
                     "  WHERE oga01= '",ll_oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
         PREPARE del_oga1 FROM g_sql
         EXECUTE del_oga1
         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','','del oga:' ,SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF

         LET g_sql = " SELECT ogb01,ogb03,ogb04,ogb09,ogb091,ogb092 ",
                     #"   FROM ",l_last_dbs_tra CLIPPED,"ogb_file",
                     "   FROM ",cl_get_target_table(l_last_poy04,'ogb_file'),  #FUN-A50102
                     "  WHERE ogb01= '",ll_oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
         DECLARE sel_ogb_cs CURSOR FROM g_sql

         #LET g_sql="DELETE FROM ",l_last_dbs_tra CLIPPED,"tlfs_file",
         LET g_sql="DELETE FROM ",cl_get_target_table(l_last_poy04,'tlfs_file'),  #FUN-A50102
                    " WHERE tlfs01 = ? ",
                    "   AND tlfs02 = ? ",
                    "   AND tlfs03 = ? ",
                    "   AND tlfs04 = ? ",
                    "   AND tlfs09 = -1 ",
                    "   AND tlfs10 = ? ",
                    "   AND tlfs11 = ? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
         PREPARE del_tlfs_p1 FROM g_sql

         FOREACH sel_ogb_cs INTO l_tm.*
             IF cl_null(l_tm.ogb091) THEN LET l_tm.ogb091 = ' ' END IF
             IF cl_null(l_tm.ogb092) THEN LET l_tm.ogb092 = ' ' END IF
             EXECUTE del_tlfs_p1 USING l_tm.ogb04,l_tm.ogb09,l_tm.ogb091,
                                       l_tm.ogb092,l_tm.ogb01,l_tm.ogb03
             IF SQLCA.sqlcode THEN
                LET g_showmsg = l_tm.ogb04,'/',l_tm.ogb09,'/',l_tm.ogb01,
                                '/',l_tm.ogb03
                CALL s_errmsg('ogb04,ogb09,ogb01,ogb03',g_showmsg,'del_tlfs_p1',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
         END FOREACH

         #LET g_sql = " DELETE FROM ",l_last_dbs_tra CLIPPED,"ogb_file",
         LET g_sql = " DELETE FROM ",cl_get_target_table(l_last_poy04,'ogb_file'),  #FUN-A50102
                     "  WHERE ogb01= '",ll_oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
         PREPARE del_ogb1 FROM g_sql
         EXECUTE del_ogb1
         IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','','del ogb:' ,SQLCA.SQLCODE,1)
            LET g_success = 'N'
         #No.FUN-7B0018 080305 add --begin
         ELSE
            IF NOT s_industry('std') THEN
               IF NOT s_del_ogbi(ll_oga01,'',l_last_poy04) THEN
                  LET g_success = 'N'
               END IF
            END IF
         #No.FUN-7B0018 080305 add --end
         END IF
         #LET g_sql = " DELETE FROM ",l_last_dbs_tra CLIPPED,"rvbs_file",
         LET g_sql = " DELETE FROM ",cl_get_target_table(l_last_poy04,'rvbs_file'), #FUN-A50102
                     "  WHERE rvbs00 = 'axmt820'",
                     "    AND rvbs01 = '",ll_oga01,"'",
                     "    AND rvbs13 = 0 ",
                     "    AND rvbs09 = - 1 "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
         PREPARE del_rvbs FROM g_sql
         EXECUTE del_rvbs
         IF SQLCA.sqlcode THEN
            LET g_showmsg = 'axmt820/',g_tsk.tsk01
            CALL s_errmsg('rvbs00,rvbs01',g_showmsg,'del rvbs',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CALL s_showmsg()
            RETURN
         END IF
      END IF

      #7.采購單拋轉還原
      CALL p811_p2(l_pmm01,g_tsk.tsk03)
      IF g_success = 'N' THEN
         ROLLBACK WORK
         CALL s_showmsg()
         RETURN
      END IF

      #8.刪除采購資料
      #LET g_sql = " DELETE FROM ",l_dbs_tra CLIPPED,"pmm_file",
      LET g_sql = " DELETE FROM ",cl_get_target_table(g_tsk.tsk03,'pmm_file'),  #FUN-A50102
                  "  WHERE pmm01= '",l_pmm01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql #FUN-980093
      PREPARE del_pmm1 FROM g_sql
      EXECUTE del_pmm1
      IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('','','del pmm:' ,SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      #LET g_sql = " DELETE FROM ",l_dbs_tra CLIPPED,"pmn_file",
      LET g_sql = " DELETE FROM ",cl_get_target_table(g_tsk.tsk03,'pmn_file'),  #FUN-A50102
                  "  WHERE pmn01= '",l_pmm01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql #FUN-980093
      PREPARE del_pmn2 FROM g_sql
      EXECUTE del_pmn2
      IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('','','del pmn:' ,SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      #NO.FUN-7B0018 08/02/29 add --begin
      IF NOT s_industry('std') THEN
         IF NOT s_del_pmni(l_pmm01,'',g_tsk.tsk03) THEN
            LET g_success = 'N'
         END IF
      END IF
      #NO.FUN-7B0018 08/02/29 add --end

      UPDATE tsk_file SET tsk05   = '2',
                          tsk06   = NULL,
                          tskmodu = g_user,
                          tskdate = g_today
                    WHERE tsk01   = g_tsk.tsk01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('tsk01',g_tsk.tsk01,g_tsk.tsk01,SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         LET g_tsk.tsk05 = '2'
         LET g_tsk.tsk06 = NULL
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL s_showmsg()

   DISPLAY BY NAME g_tsk.tsk05
   DISPLAY BY NAME g_tsk.tsk06
   CLOSE t254_cl
   CALL t254_field_pic()

   #No.FUN-A10099  --End
END FUNCTION

#過帳-產生采購單
FUNCTION t254_pmm_ins()
   DEFINE l_poy         RECORD LIKE poy_file.*
   DEFINE l_pmc         RECORD LIKE pmc_file.*
   DEFINE l_dbs         LIKE type_file.chr21
   DEFINE l_dbs_tra     LIKE type_file.chr21
   DEFINE p_plant_new   LIKE azp_file.azp01
   DEFINE l_poy03       LIKE poy_file.poy03
   DEFINE li_result     LIKE type_file.num5

   INITIALIZE g_pmm.* TO NULL

   LET g_pmm.pmm40 = 0
   LET g_pmm.pmm40t = 0

   #需求站
   SELECT poy_file.* INTO l_poy.* FROM poy_file,poz_file
    WHERE poy01 = poz01
      AND poy01 = g_tsk.tsk07
      AND poy02 = (SELECT MIN(poy02) FROM poy_file
    WHERE poy01 = g_tsk.tsk07)

   #CALL t254_azp(g_tsk.tsk03) RETURNING l_dbs,l_dbs_tra,p_plant_new

   #需求營運中心和apmi000中0站的營運中心不同
   IF g_tsk.tsk03 <> l_poy.poy04 THEN
      LET g_showmsg = g_tsk.tsk03,'/',l_poy.poy04
      CALL s_errmsg('tsk03,poy04',g_showmsg,'PLANT DIFF','atm-152',1)
      LET g_success = 'N'
      RETURN
   END IF

   #出貨站
   #No.TQC-A20063 流通配销时,调拨可能是很多站,而并不是原来的2站式
   #现在合二为一
   #SELECT poy03 INTO l_poy03 FROM poy_file,poz_file
   # WHERE poz01 = g_tsk.tsk07
   #   AND poz01 = poy01
   #   AND poy02 = (SELECT MAX(poy02) FROM poy_file
   # WHERE poy01 = g_tsk.tsk07)
   SELECT poy03 INTO l_poy03 FROM poy_file,poz_file
    WHERE poz01 = g_tsk.tsk07
      AND poz01 = poy01
      AND poy02 = (SELECT MIN(poy02) + 1 FROM poy_file
    WHERE poy01 = g_tsk.tsk07)
   IF g_azw.azw04 = '2' THEN
      CALL t254_art(l_poy.*,l_poy03,g_tsk.tsk03) RETURNING l_poy.*
   END IF
   #No.TQC-A20063  --End

   #需求方設定的供應商資料
   #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"pmc_file",
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_tsk.tsk03,'pmc_file'),  #FUN-A50102
               " WHERE pmc01 = '",l_poy03,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql #FUN-A50102
   PREPARE t254_pmc_p1 FROM g_sql
   EXECUTE t254_pmc_p1 INTO l_pmc.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmc01',l_poy03,'SELECT pmc',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   LET g_pmm.pmm01 = l_poy.poy35    #採購單號
   LET g_pmm.pmm02 = 'TAP'          #採購單性質
   LET g_pmm.pmm03 = 0              #更動序號
   IF g_azw.azw04 = '2' THEN
      LET g_pmm.pmm04 = g_today     #採購日期
      LET g_pmm.pmm12 = g_user      #採購員
      LET g_pmm.pmm13 = g_grup      #採購部門
   ELSE
      LET g_pmm.pmm04 = g_tsk.tsk02 #採購日期
      LET g_pmm.pmm12 = g_tsk.tsk08 #採購員
      LET g_pmm.pmm13 = g_tsk.tsk09 #採購部門
   END IF
   LET g_pmm.pmm05 = NULL           #專案號碼
   LET g_pmm.pmm06 = NULL           #預算號碼
   LET g_pmm.pmm07 = NULL           #單據分類
   LET g_pmm.pmm08 = NULL           #PBI
   LET g_pmm.pmm09 = l_poy03        #供應廠商
   LET g_pmm.pmm10 = l_pmc.pmc15    #送貨地址
   LET g_pmm.pmm11 = l_pmc.pmc16    #帳單地址
   LET g_pmm.pmm14 = g_pmm.pmm13    #收貨部門
   LET g_pmm.pmm15 = g_user         #確認人
   LET g_pmm.pmm16 = NULL           #運送方式
   LET g_pmm.pmm17 = NULL           #代理商
   LET g_pmm.pmm18 = 'Y'            #確認碼
   LET g_pmm.pmm20 = l_poy.poy06    #付款方式
   LET g_pmm.pmm21 = l_poy.poy09    #稅別
   LET g_pmm.pmm22 = l_poy.poy05    #幣別
   IF cl_null(g_pmm.pmm20) THEN LET g_pmm.pmm20 = l_pmc.pmc17 END IF
   IF cl_null(g_pmm.pmm21) THEN LET g_pmm.pmm21 = l_pmc.pmc47 END IF
   IF cl_null(g_pmm.pmm22) THEN LET g_pmm.pmm22 = l_pmc.pmc22 END IF
   LET g_pmm.pmm25 = '2'            #狀況碼
   LET g_pmm.pmm26 = l_poy.poy32    #理由碼
   LET g_pmm.pmm27 = g_today        #狀況異動日期
   LET g_pmm.pmm28 = NULL           #會計分類
   LET g_pmm.pmm29 = NULL           #會計科目
   LET g_pmm.pmm30 = 'N'            #收貨單列印否
   LET g_pmm.pmm31 = YEAR(g_today)  #會計年度
   LET g_pmm.pmm32 = MONTH(g_today) #會計期間
   LET g_pmm.pmm40 = 0              #總金額
   LET g_pmm.pmm401= 0              #代買總金額
   LET g_pmm.pmm41 = l_pmc.pmc49    #價格條件
   CALL s_currm(g_pmm.pmm22,g_pmm.pmm04,'B',g_tsk.tsk03)      #匯率
        RETURNING g_pmm.pmm42
   IF cl_null(g_pmm.pmm42) THEN LET g_pmm.pmm42 = 1 END IF
   #LET g_sql = "SELECT gec04 FROM ",l_dbs CLIPPED,"gec_file ",   #稅率
   LET g_sql = "SELECT gec04 FROM ",cl_get_target_table(g_tsk.tsk03,'gec_file'),  #FUN-A50102
               " WHERE gec01 = '",g_pmm.pmm21,"'",
               "   AND gec011= '1' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql #FUN-A50102
   PREPARE t254_gec_p1 FROM g_sql
   EXECUTE t254_gec_p1 INTO g_pmm.pmm43
   IF cl_null(g_pmm.pmm43) THEN LET g_pmm.pmm43 = 0 END IF
   LET g_pmm.pmm44 = '1'            #扣抵區分
   LET g_pmm.pmm45 = 'Y'            #可用/不可用
   LET g_pmm.pmm46 = 0              #預付比率
   LET g_pmm.pmm47 = 0              #預付金額
   LET g_pmm.pmm48 = 0              #已結帳金額
   LET g_pmm.pmm49 = 'N'            #預付發票否
   LET g_pmm.pmm50 = ''             #代買流程最終供應商代號
   LET g_pmm.pmm99 = ''             #多角貿易流程序號
   LET g_pmm.pmm901 = 'Y'            #多角貿易否
   LET g_pmm.pmm902 = 'N'            #最終採購單否
   LET g_pmm.pmm903 = '3'            #營業額申報方式
   LET g_pmm.pmm904 = g_tsk.tsk07    #多角貿易流程代碼
   LET g_pmm.pmm905 = 'N'            #多角貿易拋轉否
   LET g_pmm.pmm906 = 'Y'            #多角貿易來源採購單否
   LET g_pmm.pmm907 = NULL           #No Use
   LET g_pmm.pmm908 = NULL           #No Use
   LET g_pmm.pmm909 = '4'            #資料來源
   LET g_pmm.pmm911 = g_tsk.tsk11    #下游廠商對應客戶編號
   LET g_pmm.pmm912 = g_tsk.tsk12    #下游廠商對應客戶編號
   LET g_pmm.pmm913 = g_tsk.tsk13    #下游廠商對應客戶編號
   LET g_pmm.pmm914 = g_tsk.tsk14    #下游廠商對應客戶編號
   LET g_pmm.pmm915 = g_tsk.tsk15    #下游廠商對應客戶編號
   LET g_pmm.pmm916 = g_tsk.tsk16    #下游廠商對應客戶編號
   LET g_pmm.pmmprsw = 'N'           #列印控制
   LET g_pmm.pmmprno = 0             #已列印次數
   LET g_pmm.pmmprdt = NULL          #最後列印日期
   LET g_pmm.pmmmksg = 'N'           #是否簽核
   LET g_pmm.pmmsign = NULL          #簽核等級
   LET g_pmm.pmmdays = 0             #簽核完成天數
   LET g_pmm.pmmprit = NULL          #簽核優先等級
   LET g_pmm.pmmsseq = NULL          #已簽核順序
   LET g_pmm.pmmsmax = NULL          #應簽核順序
   LET g_pmm.pmmacti = 'Y'           #資料有效碼
   LET g_pmm.pmmuser = g_user        #資料所有者
   LET g_pmm.pmmgrup = g_grup        #資料所有部門
   LET g_pmm.pmmmodu = NULL          #資料修改者
   LET g_pmm.pmmdate = g_today       #最近修改日
   LET g_pmm.pmm40t  = 0             #含稅總金額
   LET g_pmm.pmmud01 = NULL          #使用者定義
   LET g_pmm.pmmud02 = NULL          #使用者定義
   LET g_pmm.pmmud03 = NULL          #使用者定義
   LET g_pmm.pmmud04 = NULL          #使用者定義
   LET g_pmm.pmmud05 = NULL          #使用者定義
   LET g_pmm.pmmud06 = NULL          #使用者定義
   LET g_pmm.pmmud07 = NULL          #使用者定義
   LET g_pmm.pmmud08 = NULL          #使用者定義
   LET g_pmm.pmmud09 = NULL          #使用者定義
   LET g_pmm.pmmud10 = NULL          #使用者定義
   LET g_pmm.pmmud11 = NULL          #使用者定義
   LET g_pmm.pmmud12 = NULL          #使用者定義
   LET g_pmm.pmmud13 = NULL          #使用者定義
   LET g_pmm.pmmud14 = NULL          #使用者定義
   LET g_pmm.pmmud15 = NULL          #使用者定義
#  LET g_pmm.pmmplant= p_plant_new   #所屬工廠   #要算需求的工厂                #MOD-B40030
   LET g_pmm.pmmplant= g_tsk.tsk03                                              #MOD-B40030
   CALL s_getlegal(g_pmm.pmmplant) RETURNING g_pmm.pmmlegal   #所屬法人 
   LET g_pmm.pmm51   = '1'           #經營方式 1-經銷,2-成本代銷,3- 
   LET g_pmm.pmm52   = g_pmm.pmmplant#採購機構
   LET g_pmm.pmm53   = NULL          #配送中心
   LET g_pmm.pmmcond = g_today       #審核日期
   LET g_pmm.pmmcont = g_time        #審核時間
   LET g_pmm.pmmconu = g_user        #審核人員
   LET g_pmm.pmmcrat = g_today       #資料創建日
   LET g_pmm.pmmpos  = 'N'           #已傳POS否
   LET g_pmm.pmmoriu = g_user        #資料建立者
   LET g_pmm.pmmorig = g_grup        #資料建立部門

   CALL s_auto_assign_no("apm",g_pmm.pmm01,g_today,"","pmm_file","pmm01",g_tsk.tsk03,"","")
      RETURNING li_result,g_pmm.pmm01
   IF (NOT li_result) THEN
      LET g_success="N"
      CALL s_errmsg('','','','asf-377',1)
      RETURN
   END IF
   #CALL t254_pmn_ins(l_dbs,l_dbs_tra,g_tsk.tsk03)
   CALL t254_pmn_ins(g_tsk.tsk03)   #FUN-A50102
   IF g_success = "N" THEN RETURN END IF

   #LET g_sql = "INSERT INTO ",l_dbs_tra CLIPPED,"pmm_file(",
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_tsk.tsk03,'pmm_file'),"(", #FUN-A50102
               "pmm01, pmm02, pmm03, pmm04, pmm05,",
               "pmm06, pmm07, pmm08, pmm09, pmm10,",
               "pmm11, pmm12, pmm13, pmm14, pmm15,",
               "pmm16, pmm17, pmm18, pmm20, pmm21,",
               "pmm22, pmm25, pmm26, pmm27, pmm28,",
               "pmm29, pmm30, pmm31, pmm32, pmm40,",
               "pmm401,pmm41, pmm42, pmm43, pmm44,",
               "pmm45, pmm46, pmm47, pmm48, pmm49,",
               "pmm50, pmm99, pmm901,pmm902,pmm903,",
               "pmm904,pmm905,pmm906,pmm907,pmm908,",
               "pmm909,pmm911,pmm912,pmm913,pmm914,",
               "pmm915,  pmm916,  pmmprsw, pmmprno, pmmprdt,",
               "pmmmksg, pmmsign, pmmdays, pmmprit, pmmsseq,",
               "pmmsmax, pmmacti, pmmuser, pmmgrup, pmmmodu,",
               "pmmdate, pmm40t,  pmmud01, pmmud02, pmmud03,",
               "pmmud04, pmmud05, pmmud06, pmmud07, pmmud08,",
               "pmmud09, pmmud10, pmmud11, pmmud12, pmmud13,",
               "pmmud14, pmmud15, pmmplant,pmmlegal,pmm51, ",
               "pmm52,   pmm53,   pmmcond, pmmcont, pmmconu,",
               "pmmcrat, pmmpos,  pmmoriu, pmmorig)",
               "  VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?)  "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql #FUN-A50102
   PREPARE pmm_ins FROM g_sql
   EXECUTE pmm_ins USING
      g_pmm.pmm01, g_pmm.pmm02, g_pmm.pmm03, g_pmm.pmm04, g_pmm.pmm05,
      g_pmm.pmm06, g_pmm.pmm07, g_pmm.pmm08, g_pmm.pmm09, g_pmm.pmm10,
      g_pmm.pmm11, g_pmm.pmm12, g_pmm.pmm13, g_pmm.pmm14, g_pmm.pmm15,
      g_pmm.pmm16, g_pmm.pmm17, g_pmm.pmm18, g_pmm.pmm20, g_pmm.pmm21,
      g_pmm.pmm22, g_pmm.pmm25, g_pmm.pmm26, g_pmm.pmm27, g_pmm.pmm28,
      g_pmm.pmm29, g_pmm.pmm30, g_pmm.pmm31, g_pmm.pmm32, g_pmm.pmm40,
      g_pmm.pmm401,g_pmm.pmm41, g_pmm.pmm42, g_pmm.pmm43, g_pmm.pmm44,
      g_pmm.pmm45, g_pmm.pmm46, g_pmm.pmm47, g_pmm.pmm48, g_pmm.pmm49,
      g_pmm.pmm50, g_pmm.pmm99, g_pmm.pmm901,g_pmm.pmm902,g_pmm.pmm903,
      g_pmm.pmm904,g_pmm.pmm905,g_pmm.pmm906,g_pmm.pmm907,g_pmm.pmm908,
      g_pmm.pmm909,g_pmm.pmm911,g_pmm.pmm912,g_pmm.pmm913,g_pmm.pmm914,
      g_pmm.pmm915,  g_pmm.pmm916, g_pmm.pmmprsw, g_pmm.pmmprno, g_pmm.pmmprdt,
      g_pmm.pmmmksg, g_pmm.pmmsign,g_pmm.pmmdays, g_pmm.pmmprit, g_pmm.pmmsseq,
      g_pmm.pmmsmax, g_pmm.pmmacti,g_pmm.pmmuser, g_pmm.pmmgrup, g_pmm.pmmmodu,
      g_pmm.pmmdate, g_pmm.pmm40t, g_pmm.pmmud01, g_pmm.pmmud02, g_pmm.pmmud03,
      g_pmm.pmmud04, g_pmm.pmmud05,g_pmm.pmmud06, g_pmm.pmmud07, g_pmm.pmmud08,
      g_pmm.pmmud09, g_pmm.pmmud10,g_pmm.pmmud11, g_pmm.pmmud12, g_pmm.pmmud13,
      g_pmm.pmmud14, g_pmm.pmmud15,g_pmm.pmmplant,g_pmm.pmmlegal,g_pmm.pmm51,
      g_pmm.pmm52,   g_pmm.pmm53,  g_pmm.pmmcond, g_pmm.pmmcont, g_pmm.pmmconu,
      g_pmm.pmmcrat, g_pmm.pmmpos, g_pmm.pmmoriu, g_pmm.pmmorig
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','',g_tsk.tsk01,SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN
   END IF

END FUNCTION

#FUNCTION t254_pmn_ins(p_dbs,p_dbs_tra,p_plant_new)
FUNCTION t254_pmn_ins(p_plant_new)   #FUN-A50102
   DEFINE p_dbs           LIKE type_file.chr21
   DEFINE p_dbs_tra       LIKE type_file.chr21
   DEFINE p_plant_new     LIKE azp_file.azp01
   DEFINE l_unit          LIKE ima_file.ima25
   DEFINE l_no            LIKE tqm_file.tqm01
   DEFINE l_price         LIKE tqn_file.tqn05
   DEFINE l_success       LIKE type_file.chr1
   DEFINE l_ima02         LIKE ima_file.ima02
   DEFINE l_ima25         LIKE ima_file.ima25
   DEFINE l_ima908        LIKE ima_file.ima908
   DEFINE l_ima15         LIKE ima_file.ima15
   DEFINE l_ima49         LIKE ima_file.ima49
   DEFINE l_ima491        LIKE ima_file.ima491
   DEFINE l_fac           LIKE pmn_file.pmn09
   DEFINE l_pmni          RECORD LIKE pmni_file.*           #No.FUN-7B0018
   DEFINE l_tsl           RECORD LIKE tsl_file.*
   DEFINE l_pmn           RECORD LIKE pmn_file.*

   DECLARE t254_b3_b CURSOR FOR
    SELECT * FROM tsl_file
     WHERE tsl01 = g_tsk.tsk01
     ORDER BY tsl02
   IF STATUS THEN
      CALL s_errmsg('tsl01',g_tsk.tsk01,'t254_b3_b',SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN
   END IF

   FOREACH t254_b3_b INTO l_tsl.*
      IF STATUS THEN
         CALL s_errmsg('tsl01',g_tsk.tsk01,'foreach t254_b3_b',STATUS,1)
         LET g_success="N"
         EXIT FOREACH
      END IF
      LET g_sql = " SELECT ima02,ima25,ima908,ima15 ",
                  #"   FROM ",p_dbs CLIPPED,"ima_file",
                  "   FROM ",cl_get_target_table(p_plant_new,'ima_file'), #FUN-A50102
                  "  WHERE ima01 = '",l_tsl.tsl03,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE t254_ima_p1 FROM g_sql
      EXECUTE t254_ima_p1 INTO l_ima02,l_ima25,l_ima908,l_ima15
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ima01',l_tsl.tsl03,'SELECT ima',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      INITIALIZE l_pmn.* TO NULL
      LET l_pmn.pmn01 = g_pmm.pmm01   #採購單號
      LET l_pmn.pmn011= 'TAP'         #單據性質
      LET l_pmn.pmn02 = l_tsl.tsl02   #項次
      LET l_pmn.pmn03 = NULL          #詢價單號
      LET l_pmn.pmn04 = l_tsl.tsl03   #料件編號
      LET l_pmn.pmn041= l_ima02       #品名規格
      LET l_pmn.pmn05 = NULL          #APS單據編號

      #LET g_sql = " SELECT pmh04,pmh07 FROM ",p_dbs CLIPPED,"pmh_file",
      LET g_sql = " SELECT pmh04,pmh07 FROM ",cl_get_target_table(p_plant_new,'pmh_file'),  #FUN-A50102
                  "  WHERE pmh01 = '",l_pmn.pmn04,"'",
                  "    AND pmh02 = '",g_pmm.pmm09,"'",
                  "    AND pmh13 = '",g_pmm.pmm22,"'",
                  "    AND pmh21 = ' ' ",
                  "    AND pmh22 = '1' ",
                  "    AND pmh23 = ' ' ",
                  "    AND pmhacti = 'Y'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE t254_pmh_p1 FROM g_sql
      EXECUTE t254_pmh_p1 INTO l_pmn.pmn06,l_pmn.pmn123 #廠商料件編號 #廠牌

      LET l_pmn.pmn07 = l_tsl.tsl04   #採購單位
      LET l_pmn.pmn08 = l_ima25       #庫存單位
      CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08,p_plant_new)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN LET l_fac = 1 END IF
      LET l_pmn.pmn09 = l_fac         #轉換因子
      LET l_pmn.pmn10 = NULL          #No Use
      LET l_pmn.pmn11 = 'N'           #凍結碼
      LET l_pmn.pmn121= 1             #轉換因子
      LET l_pmn.pmn122= NULL          #專案代號
      LET l_pmn.pmn13 = 0             #超/短交限率
      LET l_pmn.pmn14 = 'N'           #部份交貨
      LET l_pmn.pmn15 = 'N'           #提前交貨
      LET l_pmn.pmn16 = '2'           #狀況碼
      LET l_pmn.pmn18 = NULL          #RunCard單號(委外)
      LET l_pmn.pmn20 = l_tsl.tsl05   #採購量
      LET l_pmn.pmn80 = l_tsl.tsl07   #單位一
      LET l_pmn.pmn81 = l_tsl.tsl08   #單位一換算率(與採購單位)
      LET l_pmn.pmn82 = l_tsl.tsl09   #單位一數量
      LET l_pmn.pmn83 = l_tsl.tsl10   #單位二
      LET l_pmn.pmn84 = l_tsl.tsl11   #單位二換算率(與採購單位)
      LET l_pmn.pmn85 = l_tsl.tsl12   #單位二數量
      IF cl_null(l_ima908) THEN LET l_ima908 = l_pmn.pmn07 END IF
      LET l_pmn.pmn86 = l_ima908      #計價單位
      CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn86,p_plant_new)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN
         LET l_fac = 1
      END IF
      LET l_pmn.pmn87 = l_pmn.pmn20*l_fac  #計價數量
      LET l_pmn.pmn87 = s_digqty(l_pmn.pmn87,l_pmn.pmn86)    #FUN-BB0084

      LET l_pmn.pmn23 = g_pmm.pmm10        #送貨地址
      LET l_pmn.pmn24 = NULL               #請購單號
      LET l_pmn.pmn25 = NULL               #請購單號項次
      LET l_pmn.pmn30 = NULL               #標準價格
      IF g_sma.sma116 <> '0' THEN
         LET l_unit = l_pmn.pmn86
      ELSE
         LET l_unit = l_pmn.pmn07
      END IF
      IF g_azw.azw04='2' THEN         #check user
         CALL s_fetch_price3(g_tsk.tsk07,l_pmn.pmnplant,l_pmn.pmn04,l_pmn.pmn86,'0',0)
         RETURNING l_success,l_price
      ELSE
         CALL s_fetch_price2(g_pmm.pmm09,l_pmn.pmn04,l_unit,g_tsk.tsk18,'4',p_plant_new,g_pmm.pmm22)
              RETURNING l_no,l_price,l_success
      END IF
      IF l_success = 'N' THEN
         LET g_showmsg = g_pmm.pmm09,'/',l_pmn.pmn04,'/',l_unit,'/',g_pmm.pmm22,'/',g_tsk.tsk18
         CALL s_errmsg('tqo01,tqn03,tqn04,tqm05,tqn06',g_showmsg,'fetch price','axm-333',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      #LET g_sql = " SELECT azi03 FROM ",p_dbs CLIPPED,"azi_file ",
      LET g_sql = " SELECT azi03 FROM ",cl_get_target_table(p_plant_new,'azi_file'),  #FUN-A50102
                  "  WHERE azi01 ='",g_pmm.pmm22,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-A50102
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE t254_azi_p1 FROM g_sql
      EXECUTE t254_azi_p1 INTO t_azi03
      IF cl_null(l_price) THEN LET l_price = 0 END IF
      LET l_pmn.pmn31 = l_price                         #單價
      LET l_pmn.pmn31 = cl_digcut(l_pmn.pmn31,t_azi03)
      LET l_pmn.pmn31t= l_pmn.pmn31 * (1+ g_pmm.pmm43/100)  #含稅單價
      LET l_pmn.pmn31t= cl_digcut(l_pmn.pmn31t,t_azi03)
      LET l_pmn.pmn32 = NULL                            #RunCard委外製程序
      LET l_pmn.pmn33 = g_tsk.tsk18                     #原始交貨日期
      LET l_pmn.pmn34 = l_pmn.pmn33 + l_ima49           #原始到廠日期
      LET l_pmn.pmn35 = l_pmn.pmn34 + l_ima491          #原始到庫日期
      LET l_pmn.pmn36 = g_tsk.tsk18                     #最近確認交貨日期
      LET l_pmn.pmn37 = NULL                            #最後一次到廠日期
      LET l_pmn.pmn38 = 'Y'                             #可用/不可用
      LET l_pmn.pmn40 = NULL                            #會計科目
      LET l_pmn.pmn41 = NULL                            #工單號碼
      LET l_pmn.pmn42 = '0'                             #替代碼
      LET l_pmn.pmn43 = NULL                            #本製程序號
      LET l_pmn.pmn431= NULL                            #下製程序號
      LET l_pmn.pmn44 = l_pmn.pmn31 * g_pmm.pmm42       #本幣單價
      LET l_pmn.pmn45 = NULL                            #無交期性採購單項次
      LET l_pmn.pmn46 = NULL                            #製程序號
      LET l_pmn.pmn50 = 0                               #交貨量
      LET l_pmn.pmn51 = 0                               #在驗量
      LET l_pmn.pmn52 = g_tsk.tsk17                     #倉庫
      LET l_pmn.pmn53 = 0                               #入庫量
      LET l_pmn.pmn54 = ' '                             #儲位
      LET l_pmn.pmn55 = 0                               #驗退量
      LET l_pmn.pmn56 = ' '                             #批號
      LET l_pmn.pmn57 = 0                               #超短交量
      LET l_pmn.pmn58 = 0                               #倉退量
      LET l_pmn.pmn59 = NULL                            #退貨單號
      LET l_pmn.pmn60 = NULL                            #項次
      LET l_pmn.pmn61 = l_pmn.pmn04                     #被替代料號
      LET l_pmn.pmn62 = 1                               #替代率
      LET l_pmn.pmn63 = 'N'                             #急料否
      LET l_pmn.pmn64 = 'N'                             #保稅否
      LET l_pmn.pmn65 = '1'                             #代買性質
      LET l_pmn.pmn66 = NULL                            #預算編號
      LET l_pmn.pmn67 = g_tsk.tsk09                     #部門編號
      LET l_pmn.pmn68 = NULL                            #Blanket PO 單號
      LET l_pmn.pmn69 = NULL                            #Blanket PO 項次
      LET l_pmn.pmn70 = NULL                            #轉換因子
      LET l_pmn.pmn71 = NULL                            #海關手冊編號

      LET l_pmn.pmn88 = l_pmn.pmn31 * l_pmn.pmn87       #未稅金額
      LET l_pmn.pmn88t= l_pmn.pmn31t* l_pmn.pmn87       #含稅金額
      LET l_pmn.pmn930= g_plant                         #採購成本中心
      LET l_pmn.pmn401= NULL                            #會計科目二
      LET l_pmn.pmn90 = l_pmn.pmn31                     #取出單價
      LET l_pmn.pmn94 = NULL                            #no use
      LET l_pmn.pmn95 = NULL                            #no use
      LET l_pmn.pmn96 = NULL                            #WBS編號
      LET l_pmn.pmn97 = NULL                            #活動代號
      LET l_pmn.pmn98 = NULL                            #費用原因
      LET l_pmn.pmn91 = NULL                            #單元編號
      LET l_pmn.pmnud01 = NULL                          #自訂欄位-Textedit
      LET l_pmn.pmnud02 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud03 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud04 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud05 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud06 = NULL                          #自訂欄位-文字
      LET l_pmn.pmnud07 = NULL                          #自訂欄位-數值
      LET l_pmn.pmnud08 = NULL                          #自訂欄位-數值
      LET l_pmn.pmnud09 = NULL                          #自訂欄位-數值
      LET l_pmn.pmnud10 = NULL                          #自訂欄位-整數
      LET l_pmn.pmnud11 = NULL                          #自訂欄位-整數
      LET l_pmn.pmnud12 = NULL                          #自訂欄位-整數
      LET l_pmn.pmnud13 = NULL                          #自訂欄位-日期
      LET l_pmn.pmnud14 = NULL                          #自訂欄位-日期
      LET l_pmn.pmnud15 = NULL                          #自訂欄位-日期
      LET l_pmn.pmn89   = 'N'                           #VMI采購 
      LET l_pmn.pmnplant= g_pmm.pmmplant                #所屬工廠
      LET l_pmn.pmnlegal= g_pmm.pmmlegal                #所屬法人
      LET l_pmn.pmn72   = NULL                          #商品條碼
      LET l_pmn.pmn73   = '4'                           #取價類型 1-搭贈,2-促銷協議,3- 
      LET l_pmn.pmn74   = NULL                          #價格來源
      LET l_pmn.pmn75   = l_tsl.tsl01                   #來源單號
      LET l_pmn.pmn76   = l_tsl.tsl02                   #來源項次
      LET l_pmn.pmn77   = g_plant                       #來源機構

      #LET g_sql = "INSERT INTO ",p_dbs_tra CLIPPED,"pmn_file( ",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_new,'pmn_file'),"( ", #FUN-A50102
                  "pmn01, pmn011,pmn02, pmn03, pmn04,",
                  "pmn041,pmn05, pmn06, pmn07, pmn08,",
                  "pmn09, pmn10, pmn11, pmn121,pmn122,",
                  "pmn123,pmn13, pmn14, pmn15, pmn16,",
                  "pmn18, pmn20, pmn23, pmn24, pmn25,",
                  "pmn30, pmn31, pmn31t,pmn32, pmn33,",
                  "pmn34, pmn35, pmn36, pmn37, pmn38,",
                  "pmn40, pmn41, pmn42, pmn43, pmn431,",
                  "pmn44, pmn45, pmn46, pmn50, pmn51,",
                  "pmn52, pmn53, pmn54, pmn55, pmn56,",
                  "pmn57, pmn58, pmn59, pmn60, pmn61,",
                  "pmn62, pmn63, pmn64, pmn65, pmn66,",
                  "pmn67, pmn68, pmn69, pmn70, pmn71,",
                  "pmn80, pmn81, pmn82, pmn83, pmn84,",
                  "pmn85, pmn86, pmn87, pmn88, pmn88t,",
                  "pmn930,pmn401,pmn90, pmn94, pmn95,",
                  "pmn96, pmn97, pmn98, pmn91, pmnud01,",
                  "pmnud02, pmnud03, pmnud04, pmnud05, pmnud06,",
                  "pmnud07, pmnud08, pmnud09, pmnud10, pmnud11,",
                  "pmnud12, pmnud13, pmnud14, pmnud15, pmn89, ",
                  "pmnplant,pmnlegal,pmn72,   pmn73,   pmn74, ",
                  "pmn75,   pmn76,   pmn77)                   ",
                  "  VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?    )"

      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE ins_pmn FROM g_sql
      EXECUTE ins_pmn USING
         l_pmn.pmn01, l_pmn.pmn011,l_pmn.pmn02, l_pmn.pmn03, l_pmn.pmn04,
         l_pmn.pmn041,l_pmn.pmn05, l_pmn.pmn06, l_pmn.pmn07, l_pmn.pmn08,
         l_pmn.pmn09, l_pmn.pmn10, l_pmn.pmn11, l_pmn.pmn121,l_pmn.pmn122,
         l_pmn.pmn123,l_pmn.pmn13, l_pmn.pmn14, l_pmn.pmn15, l_pmn.pmn16,
         l_pmn.pmn18, l_pmn.pmn20, l_pmn.pmn23, l_pmn.pmn24, l_pmn.pmn25,
         l_pmn.pmn30, l_pmn.pmn31, l_pmn.pmn31t,l_pmn.pmn32, l_pmn.pmn33,
         l_pmn.pmn34, l_pmn.pmn35, l_pmn.pmn36, l_pmn.pmn37, l_pmn.pmn38,
         l_pmn.pmn40, l_pmn.pmn41, l_pmn.pmn42, l_pmn.pmn43, l_pmn.pmn431,
         l_pmn.pmn44, l_pmn.pmn45, l_pmn.pmn46, l_pmn.pmn50, l_pmn.pmn51,
         l_pmn.pmn52, l_pmn.pmn53, l_pmn.pmn54, l_pmn.pmn55, l_pmn.pmn56,
         l_pmn.pmn57, l_pmn.pmn58, l_pmn.pmn59, l_pmn.pmn60, l_pmn.pmn61,
         l_pmn.pmn62, l_pmn.pmn63, l_pmn.pmn64, l_pmn.pmn65, l_pmn.pmn66,
         l_pmn.pmn67, l_pmn.pmn68, l_pmn.pmn69, l_pmn.pmn70, l_pmn.pmn71,
         l_pmn.pmn80, l_pmn.pmn81, l_pmn.pmn82, l_pmn.pmn83, l_pmn.pmn84,
         l_pmn.pmn85, l_pmn.pmn86, l_pmn.pmn87, l_pmn.pmn88, l_pmn.pmn88t,
         l_pmn.pmn930,l_pmn.pmn401,l_pmn.pmn90, l_pmn.pmn94, l_pmn.pmn95,
         l_pmn.pmn96, l_pmn.pmn97, l_pmn.pmn98, l_pmn.pmn91, l_pmn.pmnud01,
         l_pmn.pmnud02, l_pmn.pmnud03, l_pmn.pmnud04, l_pmn.pmnud05, l_pmn.pmnud06,
         l_pmn.pmnud07, l_pmn.pmnud08, l_pmn.pmnud09, l_pmn.pmnud10, l_pmn.pmnud11,
         l_pmn.pmnud12, l_pmn.pmnud13, l_pmn.pmnud14, l_pmn.pmnud15, l_pmn.pmn89,
         l_pmn.pmnplant,l_pmn.pmnlegal,l_pmn.pmn72,   l_pmn.pmn73,   l_pmn.pmn74,
         l_pmn.pmn75,   l_pmn.pmn76,   l_pmn.pmn77
       
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','',g_tsk.tsk01,SQLCA.sqlcode,1)
         LET g_success="N"
         CONTINUE FOREACH
      END IF
      #NO.FUN-7B0018 08/02/29 add --begin
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmni.* TO NULL
         LET l_pmni.pmni01 = l_pmn.pmn01
         LET l_pmni.pmni02 = l_pmn.pmn02
         IF NOT s_ins_pmni(l_pmni.*,p_plant_new) THEN
            LET g_success='N'                                                                      #NO.FUN-710026
            CONTINUE FOREACH                                                                       #NO.FUN-710026
         END IF
      END IF
      #NO.FUN-7B0018 08/02/29 add --end
      LET g_pmm.pmm40  = g_pmm.pmm40  + l_pmn.pmn88
      LET g_pmm.pmm40t = g_pmm.pmm40t + l_pmn.pmn88t
   END FOREACH
END FUNCTION

FUNCTION t254_x()
DEFINE l_chr               LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF

   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_tsk.tsk05 = '2' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsk.tsk05 = '3' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsk.tsk05 = '4' THEN CALL cl_err('','afa-916',0) RETURN END IF

   BEGIN WORK
   LET g_success='Y'
   OPEN t254_cl USING g_tsk.tsk01
    IF STATUS THEN
      CALL cl_err("OPEN t254_cl:", STATUS, 1)
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t254_cl INTO g_tsk.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_exp(0,0,g_tsk.tskacti) THEN                   #確認一下
      LET l_chr=g_tsk.tskacti
      IF g_tsk.tskacti='Y' THEN
         LET g_tsk.tskacti='N'
      ELSE
         LET g_tsk.tskacti='Y'
      END IF
      UPDATE tsk_file SET tskacti = g_tsk.tskacti,
                          tskmodu = g_user,
                          tskdate = g_today
                    WHERE tsk01   = g_tsk.tsk01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
         LET g_tsk.tskacti=l_chr
      END IF
   END IF
   CLOSE t254_cl
   CALL t254_field_pic()
   COMMIT WORK
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tsk.tsk01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT tskacti,tskmodu,tskdate
     INTO g_tsk.tskacti,g_tsk.tskmodu,g_tsk.tskdate FROM tsk_file
    WHERE tsk01=g_tsk.tsk01
   DISPLAY BY NAME g_tsk.tskacti,g_tsk.tskmodu,g_tsk.tskdate

END FUNCTION

FUNCTION t254_v()
   DEFINE l_poz02   LIKE poz_file.poz02
   DEFINE l_poy03   LIKE poy_file.poy03
   DEFINE l_poy31   LIKE poy_file.poy03
   DEFINE l_poy32   LIKE poy_file.poy03
   DEFINE l_poy33   LIKE poy_file.poy03
   DEFINE l_poy34   LIKE poy_file.poy03
   DEFINE l_poy35   LIKE poy_file.poy03
   DEFINE l_poy36   LIKE poy_file.poy03
   DEFINE i         LIKE type_file.num5

   IF g_tsk.tsk01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_tsk.tsk05 = 'X'   THEN RETURN END IF #CHI-C80041
   SELECT * INTO g_tsk.* FROM tsk_file WHERE tsk01 = g_tsk.tsk01

   OPEN WINDOW t254_vw WITH FORM "atm/42f/atmt254_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("atmt254_1")
   LET g_success = 'Y'
   MENU ""
      BEFORE MENU
         LET l_poz02 = NULL
         LET l_poy31 = NULL  LET l_poy32 = NULL
         LET l_poy33 = NULL  LET l_poy34 = NULL
         LET l_poy35 = NULL  LET l_poy36 = NULL
         IF NOT cl_null(g_tsk.tsk07) THEN
            SELECT poz02 INTO l_poz02 FROM poz_file WHERE poz01 = g_tsk.tsk07
            FOR i = 1 TO 6
               SELECT poy03 INTO l_poy03 FROM poy_file
                WHERE poy01 = g_tsk.tsk07 AND poy02 = i
               IF SQLCA.sqlcode = 100 THEN
                  LET l_poy03 = NULL
               END IF
               CASE i
                  WHEN 1 LET l_poy31 = l_poy03
                  WHEN 2 LET l_poy32 = l_poy03
                  WHEN 3 LET l_poy33 = l_poy03
                  WHEN 4 LET l_poy34 = l_poy03
                  WHEN 5 LET l_poy35 = l_poy03
                  WHEN 6 LET l_poy36 = l_poy03
               END CASE
            END FOR
            DISPLAY l_poz02 TO FORMONLY.poz02
            DISPLAY l_poy31 TO FORMONLY.poy31
            DISPLAY l_poy32 TO FORMONLY.poy32
            DISPLAY l_poy33 TO FORMONLY.poy33
            DISPLAY l_poy34 TO FORMONLY.poy34
            DISPLAY l_poy35 TO FORMONLY.poy35
            DISPLAY l_poy36 TO FORMONLY.poy36
            DISPLAY BY NAME g_tsk.tsk07,g_tsk.tsk11,g_tsk.tsk12,g_tsk.tsk13,
                            g_tsk.tsk14,g_tsk.tsk15,g_tsk.tsk16
            IF g_tsk.tsk05 MATCHES '[234]' OR g_tsk.tskacti = 'N' THEN
               CALL cl_set_act_visible("modify", FALSE)
            END IF
            IF g_tsk.tsk05 MATCHES '[234]' OR g_tsk.tskacti = 'N' THEN
               CALL cl_set_act_visible("delete", FALSE)
            END IF
            CALL cl_set_act_visible("insert", FALSE)
         ELSE
            CALL t254_v_1()
            IF g_success = 'Y' THEN
               UPDATE tsk_file SET * = g_tsk.* WHERE tsk01 = g_tsk.tsk01
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
               END IF
            END IF
            CALL cl_set_act_visible("insert", TRUE)
            CALL cl_set_act_visible("modify", FALSE)
            CALL cl_set_act_visible("delete", FALSE)
         END IF

      ON ACTION modify
         IF cl_null(g_tsk.tsk07) THEN
            CALL cl_err(g_tsk.tsk07,100,0)
         ELSE
            CALL t254_v_1()
            IF g_success = 'Y' THEN
               UPDATE tsk_file SET * = g_tsk.* WHERE tsk01 = g_tsk.tsk01
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
               END IF
            END IF
         END IF

      ON ACTION delete
         IF cl_null(g_tsk.tsk07) THEN
            CALL cl_err(g_tsk.tsk07,100,0)
         ELSE
            IF cl_delete() THEN
                INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "tsk01"         #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_tsk.tsk01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                                 #No.FUN-9B0098 10/02/24
               LET g_tsk.tsk07 = NULL
               LET g_tsk.tsk11 = NULL
               LET g_tsk.tsk12 = NULL
               LET g_tsk.tsk13 = NULL
               LET g_tsk.tsk14 = NULL
               LET g_tsk.tsk15 = NULL
               LET g_tsk.tsk16 = NULL
               UPDATE tsk_file SET * = g_tsk.* WHERE tsk01 = g_tsk.tsk01
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
               END IF
               CLEAR FORM
               CALL cl_set_act_visible("insert", TRUE)
               CALL cl_set_act_visible("modify", FALSE)
               CALL cl_set_act_visible("delete", FALSE)
            END IF
         END IF

      ON ACTION insert
         CALL t254_v_1()
         IF g_success = 'Y' THEN
            UPDATE tsk_file SET * = g_tsk.* WHERE tsk01 = g_tsk.tsk01
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)
            END IF
         END IF
         IF NOT cl_null(g_tsk.tsk07) THEN
            CALL cl_set_act_visible("modify", TRUE)
            CALL cl_set_act_visible("delete", TRUE)
            CALL cl_set_act_visible("insert", FALSE)
         ELSE
            CALL cl_set_act_visible("insert", TRUE)
         END IF

      ON ACTION exit               #"Esc.結束"
         EXIT MENU

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU

      ON ACTION about
         CALL cl_about()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION help
         CALL cl_show_help()

      COMMAND KEY(INTERRUPT)
         LET INT_FLAG = 0
         EXIT MENU

   END MENU
   CALL cl_set_act_visible("modify,delete,insert", TRUE)
   CLOSE WINDOW t254_vw
   DISPLAY BY NAME g_tsk.tsk03
   DISPLAY BY NAME g_tsk.tsk17

END FUNCTION

FUNCTION t254_oga_ins(p_pmm01)
   DEFINE p_pmm01           LIKE pmm_file.pmm01
   DEFINE l_last_poy02      LIKE poy_file.poy02
   DEFINE l_last_poy04      LIKE poy_file.poy04
   DEFINE l_dbs             LIKE type_file.chr21
   DEFINE l_dbs_tra         LIKE type_file.chr21
   DEFINE l_last_dbs        LIKE type_file.chr21
   DEFINE l_last_dbs_tra    LIKE type_file.chr21
   DEFINE p_plant_new       LIKE azp_file.azp01 
   DEFINE p_plant_new_a     LIKE azp_file.azp01 
   DEFINE li_result         LIKE type_file.num5
   DEFINE l_rvbs            RECORD LIKE rvbs_file.*
   DEFINE l_o_prog          LIKE zz_file.zz01
   DEFINE l_pmm99           LIKE pmm_file.pmm99        #多角貿易流程序號
   DEFINE l_poy             RECORD LIKE poy_file.*

    #1.找需求工廠--采購單
    #CALL t254_azp(g_tsk.tsk03) RETURNING l_dbs,l_dbs_tra,p_plant_new  #FUN-A50102

    #LET g_sql =" SELECT pmm99 FROM ",l_dbs_tra CLIPPED,"pmm_file",
    LET g_sql =" SELECT pmm99 FROM ",cl_get_target_table(g_tsk.tsk03,'pmm_file'), #FUN-A50102
               "  WHERE pmm01 = '",p_pmm01,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_tsk.tsk03) RETURNING g_sql #FUN-980093
    PREPARE pmm99_pre FROM g_sql
    EXECUTE pmm99_pre INTO l_pmm99
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('pmm01',p_pmm01,'SELECT pmm99','mfg3188',1)
       LET g_success="N"
       RETURN
    END IF

    CALL s_mtrade_last_plant(g_tsk.tsk07)     #最后一站的站別 & 營運中心
         RETURNING l_last_poy02,l_last_poy04
    #CALL t254_azp(l_last_poy04) RETURNING l_last_dbs,l_last_dbs_tra,p_plant_new_a  #FUN-A50102

    SELECT poy_file.* INTO l_poy.* FROM poy_file,poz_file
     WHERE poy01 = poz01
       AND poy01 = g_tsk.tsk07
       AND poy02 = (SELECT MAX(poy02) FROM poy_file
     WHERE poy01 = g_tsk.tsk07)

    #No.TQC-A20063  --Begin
    #配销时,若apmi000没有设置,则可以找ART默认设置
    IF g_azw.azw04 = '2' THEN
       IF cl_null(l_poy.poy36) THEN
          #No.TQC-A80018  --Begin
          #SELECT rye03 INTO l_poy.poy35 FROM rye_file
          # WHERE rye01 = 'axm'
          #   AND rye02 = '1'
          #FUN-C90050 mark begin---
          #SELECT rye03 INTO l_poy.poy36 FROM rye_file
          # WHERE rye01 = 'axm'
          #   AND rye02 = '50'
          #IF SQLCA.sqlcode THEN
          #  #LET g_showmsg = 'axm','/1'
          #   LET g_showmsg = 'axm','/50'
          #   CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
          #   LET g_success = 'N'
          #   RETURN
          #END IF
          #FUN-C90050 mark end-----
          #No.TQC-A80018  --End  
    
          #FUN-C90050 add begin---
          CALL s_get_defslip('axm','50',g_plant,'N') RETURNING l_poy.poy36
          IF cl_null(l_poy.poy36) THEN
             LET g_showmsg = 'axm','/50'
             CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN
          END IF
          #FUN-C90050 add end-----

       END IF
       IF cl_null(l_poy.poy11) THEN #出货仓库
          #FUN-C90049 FUN-C90049 mark begin---
          #SELECT rtz07 INTO l_poy.poy11 FROM rtz_file
          # WHERE rtz01 = l_last_poy04
          #FUN-C90049 mark end-----
          CALL s_get_coststore(l_last_poy04,'') RETURNING l_poy.poy11    #FUN-C90049 add
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('rtz01',l_last_poy04,'SELECT rtz07',SQLCA.sqlcode,1)
          END IF
       END IF
    END IF
    #carrier 流通配销出货仓库若没维护,要到哪里找?
    #No.TQC-A20063  --End  
    #2.找代采買拋轉時產生的訂單
    LET g_sql= " SELECT * ",
               #"   FROM ",l_last_dbs_tra CLIPPED,"oea_file ",
               "   FROM ",cl_get_target_table(l_last_poy04,'oea_file'),  #FUN-A50102
               "  WHERE oea99 = '",l_pmm99,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
    CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
    PREPARE oea_pre FROM g_sql
    EXECUTE oea_pre INTO g_oea.*
    IF SQLCA.sqlcode THEN
       LET g_showmsg = l_last_poy04,'/',l_pmm99
       CALL s_errmsg('azp03,oea99',g_showmsg,'SELECT oea','asf-959',1)
       LET g_success="N"
       RETURN
    END IF

    #3.出貨工廠--產生出貨單頭
    LET g_oga.oga00   = g_oea.oea00      #出貨別
    LET g_oga.oga01   = l_poy.poy36      #出貨單號
    LET g_oga.oga011  = NULL             #出貨通知單號
    LET g_oga.oga02   = g_tsk.tsk02      #出貨日期
    LET g_oga.oga021  = g_tsk.tsk02      #結關日期
    LET g_oga.oga022  = NULL             #裝船日期
    LET g_oga.oga03   = g_oea.oea03      #帳款客戶編號
    LET g_oga.oga032  = g_oea.oea032     #帳款客戶簡稱
    LET g_oga.oga033  = g_oea.oea033     #帳款客戶稅號
    LET g_oga.oga04   = g_oea.oea04      #送貨客戶編號
    LET g_oga.oga044  = g_oea.oea044     #送貨地址碼
    LET g_oga.oga05   = g_oea.oea05      #發票別
    LET g_oga.oga06   = g_oea.oea06      #更改版本
    LET g_oga.oga07   = g_oea.oea07      #出貨是否計入未開發票的銷貨待驗收入
    LET g_oga.oga08   = g_oea.oea08      #1.內銷 2.外銷  3.視同外銷
    LET g_oga.oga09   = '6'              #單據別
    LET g_oga.oga10   = NULL             #帳單編號
    LET g_oga.oga11   = NULL             #應收款日
    LET g_oga.oga12   = NULL             #容許票據到期日
    LET g_oga.oga13   = NULL             #科目分類碼
    LET g_oga.oga14   = g_oea.oea14      #人員編號
    LET g_oga.oga15   = g_oea.oea15      #部門編號
    LET g_oga.oga16   = g_oea.oea01      #訂單單號
    LET g_oga.oga161  = 0                #訂金應收比率
    LET g_oga.oga162  = 100              #出貨應收比率
    LET g_oga.oga163  = 0                #尾款應收比率
    LET g_oga.oga17   = NULL             #排貨模擬順序
    LET g_oga.oga18   = g_oea.oea1001    #收款客戶編號
    LET g_oga.oga19   = NULL             #待抵帳款-預收單號
    LET g_oga.oga20   = 'Y'              #分錄底稿是否可重新生成
    LET g_oga.oga21   = g_oea.oea21      #稅種
    LET g_oga.oga211  = g_oea.oea211     #稅率
    LET g_oga.oga212  = g_oea.oea212     #聯數
    LET g_oga.oga213  = g_oea.oea213     #含稅否
    LET g_oga.oga23   = g_oea.oea23      #幣種
    LET g_oga.oga24   = g_oea.oea24      #匯率
    LET g_oga.oga25   = g_oea.oea25      #銷售分類一
    LET g_oga.oga26   = g_oea.oea26      #銷售分類二
    LET g_oga.oga27   = NULL             #Invoice No.
    LET g_oga.oga28   = g_oea.oea18      #立帳時採用訂單匯率
    LET g_oga.oga29   = NULL             #信用額度餘額
    LET g_oga.oga30   = 'N'              #包裝單審核碼
    LET g_oga.oga31   = g_oea.oea31      #價格條件編號
    LET g_oga.oga32   = g_oea.oea32      #收款條件編號
    LET g_oga.oga33   = g_oea.oea33      #其它條件
    LET g_oga.oga34   = g_oea.oea34      #佣金率
    LET g_oga.oga35   = NULL             #外銷方式
    LET g_oga.oga36   = NULL             #非經海關証明文件名稱
    LET g_oga.oga37   = NULL             #非經海關証明文件號碼
    LET g_oga.oga38   = NULL             #出口報單類型
    LET g_oga.oga39   = NULL             #出口報單號碼
    LET g_oga.oga40   = NULL             #NOTIFY
    LET g_oga.oga41   = g_oea.oea41      #起運地
    LET g_oga.oga42   = g_oea.oea42      #到達地
    LET g_oga.oga43   = g_oea.oea43      #交運方式
    LET g_oga.oga44   = g_oea.oea44      #嘜頭編號
    LET g_oga.oga45   = g_oea.oea45      #聯絡人
    LET g_oga.oga46   = g_oea.oea46      #項目編號
    LET g_oga.oga47   = NULL             #船名/車號
    LET g_oga.oga48   = NULL             #航次
    LET g_oga.oga49   = g_oea.oea35      #卸貨港
    LET g_oga.oga50   = 0                #原幣出貨金額
    LET g_oga.oga501  = 0                #本幣出貨金額
    LET g_oga.oga51   = 0                #原幣出貨金額
    LET g_oga.oga511  =0                 #本幣出貨金額
    LET g_oga.oga52   = 0                #原幣預收訂金轉銷貨收入金額
    LET g_oga.oga53   = 0                #原幣應開發票稅前金額
    LET g_oga.oga54   = 0                #原幣已開發票稅前金額
    LET g_oga.oga99   = g_oea.oea99      #多角貿易流程序號
    LET g_oga.oga901  = 'N'              #post to abx system flag
    LET g_oga.oga902  = NULL             #信用超限留置代碼
    LET g_oga.oga903  = 'Y'              #信用檢查放行否
    LET g_oga.oga904  = NULL             #No Use
    LET g_oga.oga905  = 'N'              #已轉三角貿易出貨單否
    LET g_oga.oga906  = 'Y'              #起始出貨單否
    LET g_oga.oga907  = NULL             #憑証號碼
    LET g_oga.oga908  = NULL             #L/C NO
    LET g_oga.oga909  = 'Y'              #三角貿易否
    LET g_oga.oga910  = NULL             #境外倉庫
    LET g_oga.oga911  = NULL             #境外庫位
    LET g_oga.ogaconf = 'Y'              #審核否/作廢碼
    LET g_oga.ogapost = 'N'              #出貨扣帳否
    LET g_oga.ogaprsw = 0                #打印次數
    LET g_oga.ogauser = g_user           #資料所有者
    LET g_oga.ogagrup = g_plant          #資料所有部門
    LET g_oga.ogamodu = NULL             #資料更改者
    LET g_oga.ogadate = g_today          #最近更改日
    LET g_oga.oga55   = '1'              #狀況碼
    LET g_oga.oga57   = '1'              #FUN-AC0055 add
    LET g_oga.ogamksg = g_oea.oeamksg    #簽核
    LET g_oga.oga65   = g_oea.oea65      #客戶出貨簽收否
    LET g_oga.oga66   = NULL             #出貨簽收在途/驗退倉庫
    LET g_oga.oga67   = NULL             #出貨簽收在途/驗退庫位
    LET g_oga.oga1001 = g_oea.oea1001    #收款客戶編號
    LET g_oga.oga1002 = g_oea.oea1002    #債權代碼
    LET g_oga.oga1003 = g_oea.oea1003    #業績歸屬方
    LET g_oga.oga1004 = g_oea.oea1004    #調貨客戶
    LET g_oga.oga1005 = g_oea.oea1005    #是否計算業績
    LET g_oga.oga1006 = g_oea.oea1006    #折扣金額(稅前)
    LET g_oga.oga1007 = g_oea.oea1007    #折扣金額(含稅)
    LET g_oga.oga1008 = 0                #出貨總含稅金額
    LET g_oga.oga1009 = g_oea.oea1009    #客戶所屬渠道
    LET g_oga.oga1010 = g_oea.oea1010    #客戶所屬方
    LET g_oga.oga1011 = g_oea.oea1011    #開票客戶
    LET g_oga.oga1012 = NULL             #銷退單單號
    LET g_oga.oga1013 = 'N'              #已打印提單否
    LET g_oga.oga1014 = 'N'              #調貨銷退單所自動生成否
    LET g_oga.oga1015 = NULL             #導物流狀況碼
    LET g_oga.oga1016 = g_oea.oea1015    #代送商
    LET g_oga.oga68   = NULL             #No Use
    LET g_oga.ogaspc  = NULL             #SPC拋轉碼 0/1/2
    LET g_oga.oga69   = g_today          #錄入日期
    LET g_oga.oga912  = NULL             #保稅異動原因代碼
    LET g_oga.oga913  = NULL             #保稅報單日期
    LET g_oga.oga914  = NULL             #入庫單號
    LET g_oga.oga70   = NULL             #調撥單號
    LET g_oga.ogaud01 = NULL             #自訂欄位-Textedit
    LET g_oga.ogaud02 = NULL             #自訂欄位-文字
    LET g_oga.ogaud03 = NULL             #自訂欄位-文字
    LET g_oga.ogaud04 = NULL             #自訂欄位-文字
    LET g_oga.ogaud05 = NULL             #自訂欄位-文字
    LET g_oga.ogaud06 = NULL             #自訂欄位-文字
    LET g_oga.ogaud07 = NULL             #自訂欄位-數值
    LET g_oga.ogaud08 = NULL             #自訂欄位-數值
    LET g_oga.ogaud09 = NULL             #自訂欄位-數值
    LET g_oga.ogaud10 = NULL             #自訂欄位-整數
    LET g_oga.ogaud11 = NULL             #自訂欄位-整數
    LET g_oga.ogaud12 = NULL             #自訂欄位-整數
    LET g_oga.ogaud13 = NULL             #自訂欄位-日期
    LET g_oga.ogaud14 = NULL             #自訂欄位-日期
    LET g_oga.ogaud15 = NULL             #自訂欄位-日期
    LET g_oga.ogaplant=g_oea.oeaplant    #所屬工廠  #出货端的工厂  #carrier
    LET g_oga.ogalegal=g_oea.oealegal    #所屬法人  #出货端的工厂  #carrier
    LET g_oga.oga83   =g_oea.oea83       #銷貨機構
    LET g_oga.oga84   =g_oea.oea84       #取貨機構
    LET g_oga.oga85   =g_oea.oea85       #結算方式
    LET g_oga.oga86   =g_oea.oea86       #客層代碼
    LET g_oga.oga87   =g_oea.oea87       #會員卡號
    LET g_oga.oga88   =g_oea.oea88       #顧客姓名
    LET g_oga.oga89   =g_oea.oea89       #聯系電話
    LET g_oga.oga90   =g_oea.oea90       #證件類型
    LET g_oga.oga91   =g_oea.oea91       #證件號碼
    LET g_oga.oga92   =g_oea.oea92       #贈品發放單號
    LET g_oga.oga93   =g_oea.oea93       #返券發放單號
    LET g_oga.oga94   ='N'               #POS銷售否 Y-是,N-否
    LET g_oga.oga95   =0                 #本次積分  #carrier
    LET g_oga.oga96   =NULL              #收銀機號
    LET g_oga.oga97   =NULL              #交易序號
    LET g_oga.ogacond =g_today           #審核日期
    LET g_oga.ogaconu =g_user            #審核人員
    LET g_oga.ogaoriu =g_user            #資料建立者
    LET g_oga.ogaorig =g_grup            #資料建立部門
    LET g_oga.oga71   = NULL             #申報統編

    CALL s_auto_assign_no("axm",g_oga.oga01,g_oga.oga02,"","oga_file","oga01",l_last_poy04,"","")
         RETURNING li_result,g_oga.oga01
    IF (NOT li_result) THEN
       LET g_success="N"
       CALL s_errmsg('oga01',g_oga.oga01,'oga_file','asf-377',1)  #No.FUN-710033
       RETURN
    END IF

    #4.出貨工廠--產生出貨單身
    #CALL t254_ogb_ins(l_last_dbs,l_last_dbs_tra,l_last_poy04)
    CALL t254_ogb_ins(l_last_poy04)   #FUN-A50102
    IF g_success = 'N' THEN
       RETURN
    END IF

    LET g_oga.oga501 = g_oga.oga50*g_oga.oga24
    LET g_oga.oga511 = g_oga.oga51*g_oga.oga24
    #LET g_sql = " INSERT INTO ",l_last_dbs_tra CLIPPED,"oga_file(",
    LET g_sql = " INSERT INTO ",cl_get_target_table(l_last_poy04,'oga_file'),"(",  #FUN-A50102
                "oga00, oga01, oga011,oga02, oga021,",
                "oga022,oga03, oga032,oga033,oga04,",
                "oga044,oga05, oga06, oga07, oga08,",
                "oga09, oga10, oga11, oga12, oga13,",
                "oga14, oga15, oga16, oga161,oga162,",
                "oga163,oga17, oga18, oga19, oga20,",
                "oga21, oga211,oga212,oga213,oga23,",
                "oga24, oga25, oga26, oga27, oga28,",
                "oga29, oga30, oga31, oga32, oga33,",
                "oga34, oga35, oga36, oga37, oga38,",
                "oga39, oga40, oga41, oga42, oga43,",
                "oga44, oga45, oga46, oga47, oga48,",
                "oga49, oga50, oga501,oga51, oga511,",
                "oga52, oga53, oga54, oga99, oga901,",
                "oga902,oga903,oga904,oga905,oga906,",
                "oga907,oga908,oga909,oga910,oga911,",
                "ogaconf, ogapost, ogaprsw, ogauser, ogagrup,",
                "ogamodu, ogadate, oga55,   ogamksg, oga65,",
                "oga66,   oga67,   oga1001, oga1002, oga1003,",
                "oga1004, oga1005, oga1006, oga1007, oga1008,",
                "oga1009, oga1010, oga1011, oga1012, oga1013,",
                "oga1014, oga1015, oga1016, oga68,   ogaspc,",
                "oga69,   oga912,  oga913,  oga914,  oga70,",
                "ogaud01, ogaud02, ogaud03, ogaud04, ogaud05,",
                "ogaud06, ogaud07, ogaud08, ogaud09, ogaud10,",
                "ogaud11, ogaud12, ogaud13, ogaud14, ogaud15,",
                "ogaplant,ogalegal,oga83,   oga84,   oga85,",
                "oga86,   oga87,   oga88,   oga89,   oga90,",
                "oga91,   oga92,   oga93,   oga94,   oga95,",
                "oga96,   oga97,   ogacond, ogaconu, ogaoriu,",
                "ogaorig, oga71,oga57)", #TQC-AC0055 add oga57
                "  VALUES(?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?,?,?, ?,?,?,?,?,",
                "         ?,?,?)      "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
    CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-A50102
    PREPARE oga_ins FROM g_sql
    EXECUTE oga_ins USING
       g_oga.oga00,   g_oga.oga01,   g_oga.oga011, g_oga.oga02,  g_oga.oga021,
       g_oga.oga022,  g_oga.oga03,   g_oga.oga032, g_oga.oga033, g_oga.oga04,
       g_oga.oga044,  g_oga.oga05,   g_oga.oga06,  g_oga.oga07,  g_oga.oga08,
       g_oga.oga09,   g_oga.oga10,   g_oga.oga11,  g_oga.oga12,  g_oga.oga13,
       g_oga.oga14,   g_oga.oga15,   g_oga.oga16,  g_oga.oga161, g_oga.oga162,
       g_oga.oga163,  g_oga.oga17,   g_oga.oga18,  g_oga.oga19,  g_oga.oga20,
       g_oga.oga21,   g_oga.oga211,  g_oga.oga212, g_oga.oga213, g_oga.oga23,
       g_oga.oga24,   g_oga.oga25,   g_oga.oga26,  g_oga.oga27,  g_oga.oga28,
       g_oga.oga29,   g_oga.oga30,   g_oga.oga31,  g_oga.oga32,  g_oga.oga33,
       g_oga.oga34,   g_oga.oga35,   g_oga.oga36,  g_oga.oga37,  g_oga.oga38,
       g_oga.oga39,   g_oga.oga40,   g_oga.oga41,  g_oga.oga42,  g_oga.oga43,
       g_oga.oga44,   g_oga.oga45,   g_oga.oga46,  g_oga.oga47,  g_oga.oga48,
       g_oga.oga49,   g_oga.oga50,   g_oga.oga501, g_oga.oga51,  g_oga.oga511,
       g_oga.oga52,   g_oga.oga53,   g_oga.oga54,  g_oga.oga99,  g_oga.oga901,
       g_oga.oga902,  g_oga.oga903,  g_oga.oga904, g_oga.oga905, g_oga.oga906,
       g_oga.oga907,  g_oga.oga908,  g_oga.oga909, g_oga.oga910, g_oga.oga911,
       g_oga.ogaconf, g_oga.ogapost, g_oga.ogaprsw,g_oga.ogauser,g_oga.ogagrup,
       g_oga.ogamodu, g_oga.ogadate, g_oga.oga55,  g_oga.ogamksg,g_oga.oga65,
       g_oga.oga66,   g_oga.oga67,   g_oga.oga1001,g_oga.oga1002,g_oga.oga1003,
       g_oga.oga1004, g_oga.oga1005, g_oga.oga1006,g_oga.oga1007,g_oga.oga1008,
       g_oga.oga1009, g_oga.oga1010, g_oga.oga1011,g_oga.oga1012,g_oga.oga1013,
       g_oga.oga1014, g_oga.oga1015, g_oga.oga1016,g_oga.oga68,  g_oga.ogaspc,
       g_oga.oga69,   g_oga.oga912,  g_oga.oga913, g_oga.oga914, g_oga.oga70,
       g_oga.ogaud01, g_oga.ogaud02, g_oga.ogaud03,g_oga.ogaud04,g_oga.ogaud05,
       g_oga.ogaud06, g_oga.ogaud07, g_oga.ogaud08,g_oga.ogaud09,g_oga.ogaud10,
       g_oga.ogaud11, g_oga.ogaud12, g_oga.ogaud13,g_oga.ogaud14,g_oga.ogaud15,
       g_oga.ogaplant,g_oga.ogalegal,g_oga.oga83,  g_oga.oga84,  g_oga.oga85,
       g_oga.oga86,   g_oga.oga87,   g_oga.oga88,  g_oga.oga89,  g_oga.oga90,
       g_oga.oga91,   g_oga.oga92,   g_oga.oga93,  g_oga.oga94,  g_oga.oga95,
       g_oga.oga96,   g_oga.oga97,   g_oga.ogacond,g_oga.ogaconu,g_oga.ogaoriu,
       g_oga.ogaorig, g_oga.oga71,g_oga.oga57    #TQC-AC0055 add g_oga.oga57
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','',g_tsk.tsk01,SQLCA.sqlcode,1)  #No.FUN-710033
       LET g_success="N"
       RETURN
    END IF

    #5.產生--出貨單的rvbs_file/imgs_file/tlfs_file
    #LET g_sql = " SELECT COUNT(*) FROM ",l_last_dbs_tra CLIPPED,"rvbs_file",
    LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_last_poy04,'rvbs_file'), #FUN-A50102
                "  WHERE rvbs00 = '",g_prog,"'",
                "    AND rvbs01 = '",g_tsk.tsk01,"'",
                "    AND rvbs13 = 0 ",
                "    AND rvbs09 = - 1 "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
    CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
    PREPARE rvbs_p1 FROM g_sql
    EXECUTE rvbs_p1 INTO g_cnt
    IF g_cnt > 0 THEN
       #LET g_sql = " SELECT * FROM ",l_last_dbs_tra CLIPPED,"rvbs_file",
       LET g_sql = " SELECT * FROM ",cl_get_target_table(l_last_poy04,'rvbs_file'), #FUN-A50102
                   "  WHERE rvbs00 = '",g_prog,"'",
                   "    AND rvbs01 = '",g_tsk.tsk01,"'",
                   "    AND rvbs13 = 0 ",
                   "    AND rvbs09 = - 1 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
       CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
       DECLARE rvbs_cs1 CURSOR FROM g_sql

       #LET g_sql = " INSERT INTO ",l_last_dbs_tra CLIPPED,"rvbs_file(",
       LET g_sql = " INSERT INTO ",cl_get_target_table(l_last_poy04,'rvbs_file'),"(", #FUN-A50102
                   "                       rvbs00,rvbs01,rvbs02,rvbs021,",
                   "                       rvbs022,rvbs03,rvbs04,rvbs05,",
                   "                       rvbs06,rvbs07,rvbs08,rvbs09, ",
                   "                       rvbs10,rvbs11,rvbs12,rvbs13,  ",
                   "                       rvbsplant,rvbslegal)          ",
                   "  VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,? )"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
       CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-A50102

       PREPARE ins_p1 FROM g_sql

       FOREACH rvbs_cs1 INTO l_rvbs.*
          LET l_rvbs.rvbs00 = 'axmt820'
          LET l_rvbs.rvbs01 = g_oga.oga01

          EXECUTE ins_p1 USING l_rvbs.rvbs00, l_rvbs.rvbs01, l_rvbs.rvbs02,
                               l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                               l_rvbs.rvbs04, l_rvbs.rvbs05, l_rvbs.rvbs06,
                               l_rvbs.rvbs07, l_rvbs.rvbs08, l_rvbs.rvbs09,
                               l_rvbs.rvbs10, l_rvbs.rvbs11, l_rvbs.rvbs12,
                               l_rvbs.rvbs13, l_rvbs.rvbsplant,l_rvbs.rvbslegal
          IF SQLCA.sqlcode THEN
             LET g_showmsg = l_rvbs.rvbs00,'/',l_rvbs.rvbs01,'/',l_rvbs.rvbs02
             CALL s_errmsg('rvbs00,rvbs01,rvbs02',g_showmsg,'ins rvbs',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF
          LET l_o_prog = g_prog
          LET g_prog = 'axmt820'
          CALL p900_imgs(l_last_poy04,l_poy.poy11,' ',' ',g_tsk.tsk02,l_rvbs.*)
          LET g_prog = l_o_prog
       END FOREACH
    END IF

END FUNCTION

#FUNCTION t254_ogb_ins(p_dbs,p_dbs_tra,p_plant_new)
FUNCTION t254_ogb_ins(p_plant_new)   #FUN-A50102
   DEFINE p_dbs       LIKE type_file.chr21
   DEFINE p_dbs_tra   LIKE type_file.chr21
   DEFINE p_plant_new LIKE type_file.chr21
   DEFINE l_fac       LIKE pmn_file.pmn09
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_poy11     LIKE poy_file.poy11
   DEFINE l_ogbi      RECORD LIKE ogbi_file.*       #No.FUN-7B0018
   DEFINE l_ogb       RECORD LIKE ogb_file.*
   DEFINE l_oeb       RECORD LIKE oeb_file.*
   DEFINE l_ima25     LIKE ima_file.ima25

   SELECT poy11 INTO l_poy11
     FROM poy_file,poz_file
    WHERE poz01 = g_tsk.tsk07
      AND poz01 = poy01
      AND poy02 IN (SELECT MAX(poy02) FROM poy_file
    WHERE poy01 = g_tsk.tsk07)

   #LET g_sql = " SELECT * FROM ",p_dbs_tra CLIPPED,"oeb_file ",
   LET g_sql = " SELECT * FROM ",cl_get_target_table(p_plant_new,'oeb_file'),  #FUN-A50102
               "  WHERE oeb01 = '",g_oea.oea01,"' ",
               "  ORDER BY oeb03 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql #FUN-980093
   PREPARE oeb_pre FROM g_sql
   DECLARE oeb_cs CURSOR FOR oeb_pre
   FOREACH oeb_cs INTO l_oeb.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oea01',l_oeb.oeb01,'oeb_cs',SQLCA.sqlcode,1)  #No.FUN-710033
         LET g_success="N"
         RETURN
      END IF
      LET l_ogb.ogb01   = g_oga.oga01          #出貨單號
      LET l_ogb.ogb03   = l_oeb.oeb03          #項次
      LET l_ogb.ogb04   = l_oeb.oeb04          #產品編號
      LET l_ogb.ogb05   = l_oeb.oeb05          #銷售單位
      LET l_ogb.ogb05_fac = l_oeb.oeb05_fac    #銷售/庫存彙總單位換算率
      LET l_ogb.ogb06   = l_oeb.oeb06          #品名規格
      LET l_ogb.ogb07   = l_oeb.oeb07          #額外品名編號
      LET l_ogb.ogb08   = l_oeb.oeb08          #出貨營運中心編號
      LET l_ogb.ogb09   = l_poy11              #出貨倉庫編號
      LET l_ogb.ogb091  = ' '                  #出貨儲位編號
      LET l_ogb.ogb092  = ' '                  #出貨批號
      LET l_ogb.ogb11   = l_oeb.oeb11          #客戶產品編號
      LET l_ogb.ogb12   = l_oeb.oeb12          #實際出貨數量
      #兩站式就直接取訂單的價格-也就是采購單的訂價;
      #若是多站式,則要做出貨工廠的取價
      #目前程序暫定是兩站式,故不做取價了
      LET l_ogb.ogb13   = l_oeb.oeb13          #原幣單價
      LET l_ogb.ogb14   = l_oeb.oeb14          #原幣未稅金額
      LET l_ogb.ogb14t  = l_oeb.oeb14t         #原幣含稅金額
      IF cl_null(l_ogb.ogb13)  THEN LET l_ogb.ogb13 = 0 END IF
      IF cl_null(l_ogb.ogb14)  THEN LET l_ogb.ogb14 = 0 END IF
      IF cl_null(l_ogb.ogb14t) THEN LET l_ogb.ogb14t= 0 END IF
#FUN-AB0061 -----------add start----------------                             
      LET l_ogb.ogb37=l_oeb.oeb13                         
#FUN-AB0061 -----------add end----------------  
      #LET g_sql = " SELECT img09 FROM ",p_dbs_tra CLIPPED,"img_file ",
      LET g_sql = " SELECT img09 FROM ",cl_get_target_table(p_plant_new,'img_file'),  #FUN-A50102
                  "  WHERE img01 = '",l_ogb.ogb04,"' ",
                  "    AND img02 = '",l_ogb.ogb09,"' ",
                  "    AND img03 = '",l_ogb.ogb091,"' ",
                  "    AND img04 = '",l_ogb.ogb092,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql #FUN-980093
      PREPARE img_pre FROM g_sql
      EXECUTE img_pre INTO l_img09
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_ogb.ogb04,'/',l_ogb.ogb09,'/',
                         l_ogb.ogb091,'/',l_ogb.ogb092
         CALL s_errmsg('ogb04,ogb09,ogb091,ogb092',g_showmsg,'img_pre','axm-244',1)
         LET g_success="N"
         RETURN
      END IF
      LET l_ogb.ogb15  = l_img09               #庫存明細單位由廠/倉/儲/批自動得出
      CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb15,p_plant_new)
           RETURNING g_cnt,l_fac
      IF g_cnt = 1 THEN
         LET l_fac = 1
      END IF
      LET l_ogb.ogb15_fac = l_fac              #銷售/庫存明細單位換算率
      LET l_ogb.ogb16  = l_ogb.ogb12*l_ogb.ogb15_fac        #數量
      LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15)   #FUN-BB0083 add
      LET l_ogb.ogb17   = 'N'                  #多倉儲批出貨否
      LET l_ogb.ogb18   = l_ogb.ogb12          #預計出貨數量
      LET l_ogb.ogb19   = l_oeb.oeb906         #檢驗否
      LET l_ogb.ogb20   = NULL                 #No Use
      LET l_ogb.ogb21   = NULL                 #No Use
      LET l_ogb.ogb22   = NULL                 #No Use
      LET l_ogb.ogb31   = l_oeb.oeb01          #訂單單號
      LET l_ogb.ogb32   = l_oeb.oeb03          #訂單項次
      LET l_ogb.ogb60   = 0                    #已開發票數量
      LET l_ogb.ogb63   = 0                    #銷退數量
      LET l_ogb.ogb64   = 0                    #銷退數量
      LET l_ogb.ogb901  = NULL                 #No Use
      LET l_ogb.ogb902  = NULL                 #No Use
      LET l_ogb.ogb903  = NULL                 #No Use
      LET l_ogb.ogb904  = NULL                 #No Use
      LET l_ogb.ogb905  = NULL                 #No Use
      LET l_ogb.ogb906  = NULL                 #No Use
      LET l_ogb.ogb907  = NULL                 #No Use
      LET l_ogb.ogb908  = l_oeb.oeb908         #手冊編號
      LET l_ogb.ogb909  = NULL                 #No Use
      LET l_ogb.ogb910  = l_oeb.oeb910         #單位一
      LET l_ogb.ogb911  = l_oeb.oeb911         #單位一換算率(與銷售單位)
      LET l_ogb.ogb912  = l_oeb.oeb912         #單位一數量
      LET l_ogb.ogb913  = l_oeb.oeb913         #單位二
      LET l_ogb.ogb914  = l_oeb.oeb914         #單位二換算率(與銷售單位)
      LET l_ogb.ogb915  = l_oeb.oeb915         #單位二數量
      LET l_ogb.ogb916  = l_oeb.oeb916         #計價單位
      LET l_ogb.ogb917  = l_oeb.oeb917         #計價數量*/
      LET l_ogb.ogb65   = NULL                 #驗退理由碼
      LET l_ogb.ogb1001 = l_oeb.oeb1001        #原因碼
      LET l_ogb.ogb1002 = l_oeb.oeb1002        #訂價代號
      LET l_ogb.ogb1005 = l_oeb.oeb1003        #作業方式
      LET l_ogb.ogb1007 = l_oeb.oeb1007        #現金折扣單號
      LET l_ogb.ogb1008 = l_oeb.oeb1008        #稅別
      LET l_ogb.ogb1009 = l_oeb.oeb1009        #稅率
      LET l_ogb.ogb1010 = l_oeb.oeb1010        #含稅否
      LET l_ogb.ogb1011 = l_oeb.oeb1011        #非直營KAB
      LET l_ogb.ogb1003 = g_oga.oga02          #預計出貨日期
      LET l_ogb.ogb1004 = l_oeb.oeb1004        #提案代號
      LET l_ogb.ogb1006 = l_oeb.oeb1006        #折扣率
      LET l_ogb.ogb1012 = l_oeb.oeb1012        #搭贈
      LET l_ogb.ogb930  = l_oeb.oeb930         #成本中心
      LET l_ogb.ogb1013 = 0                    #已開發票未稅金額
      LET l_ogb.ogb1014 = NULL                 #保稅已放行否
      LET l_ogb.ogb41   = l_oeb.oeb41          #專案代號
      LET l_ogb.ogb42   = l_oeb.oeb42          #WBS編號
      LET l_ogb.ogb43   = l_oeb.oeb43          #活動代號
      LET l_ogb.ogb931  = l_oeb.oeb931         #包裝編號
      LET l_ogb.ogb932  = l_oeb.oeb932         #包裝數量
      LET l_ogb.ogbud01 = NULL                 #自訂欄位-Textedit
      LET l_ogb.ogbud02 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud03 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud04 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud05 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud06 = NULL                 #自訂欄位-文字
      LET l_ogb.ogbud07 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud08 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud09 = NULL                 #自訂欄位-數值
      LET l_ogb.ogbud10 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud11 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud12 = NULL                 #自訂欄位-整數
      LET l_ogb.ogbud13 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbud14 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbud15 = NULL                 #自訂欄位-日期
      LET l_ogb.ogbplant=l_oeb.oebplant        #所屬工廠
      LET l_ogb.ogblegal=l_oeb.oeblegal        #所屬法人
      LET l_ogb.ogb44   =l_oeb.oeb44           #經營方式
      LET l_ogb.ogb45   =l_oeb.oeb45           #原扣率
      LET l_ogb.ogb46   =l_oeb.oeb46           #新扣率
      LET l_ogb.ogb47   =l_oeb.oeb47           #分攤折價=全部折價字段值的和
      #LET l_ogb.ogb50 = '1'                    #FUN-AB0096   #FUN-AC0055 mark
      #FUN-C50097 ADD BEGIN-----
      IF cl_null(l_ogb.ogb50) THEN 
        LET l_ogb.ogb50 = 0
      END IF 
      IF cl_null(l_ogb.ogb51) THEN 
        LET l_ogb.ogb51 = 0
      END IF 
      IF cl_null(l_ogb.ogb52) THEN 
        LET l_ogb.ogb52 = 0
      END IF     
      IF cl_null(l_ogb.ogb53) THEN 
        LET l_ogb.ogb53 = 0
      END IF 
      IF cl_null(l_ogb.ogb54) THEN 
        LET l_ogb.ogb54 = 0
      END IF 
      IF cl_null(l_ogb.ogb55) THEN 
        LET l_ogb.ogb55 = 0
      END IF                                       
      #FUN-C50097 ADD END-------  
      #LET g_sql = " INSERT INTO ",p_dbs_tra CLIPPED,"ogb_file(",
      LET g_sql = " INSERT INTO ",cl_get_target_table(p_plant_new,'ogb_file'),"(", #FUN-A50102
                  "ogb01,  ogb03,  ogb04,    ogb05,  ogb05_fac,",
                  "ogb06,  ogb07,  ogb08,    ogb09,  ogb091,",
                  "ogb092, ogb11,  ogb12,    ogb13,  ogb14,",
                  "ogb14t, ogb15,  ogb15_fac,ogb16,  ogb17,",
                  "ogb18,  ogb19,  ogb20,    ogb21,  ogb22,",
                  "ogb31,  ogb32,  ogb60,    ogb63,  ogb64,",
                  "ogb901, ogb902, ogb903,   ogb904, ogb905,",
                  "ogb906, ogb907, ogb908,   ogb909, ogb910,",
                  "ogb911, ogb912, ogb913,   ogb914, ogb915,",
                  "ogb916, ogb917, ogb65,    ogb1001,ogb1002,",
                  "ogb1005,ogb1007,ogb1008,  ogb1009,ogb1010,",
                  "ogb1011,ogb1003,ogb1004,  ogb1006,ogb1012,",
                  "ogb930, ogb1013,ogb1014,  ogb41,  ogb42,",
                  "ogb43,  ogb931, ogb932,   ogbud01,ogbud02,",
                  "ogbud03,ogbud04,ogbud05,  ogbud06,ogbud07,",
                  "ogbud08,ogbud09,ogbud10,  ogbud11,ogbud12,",
                  "ogbud13,ogbud14,ogbud15,  ogbplant,ogblegal,",
                  "ogb44,  ogb45,  ogb46,    ogb47,ogb37,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",   #FUN-AB0061 add ogb37   #FUN-C50097 add ogb50,51,52
                  "   VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?,",
                  "          ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)    "   #FUN-AB0061 add ogb37    #FUN-AB0096 add ? #FUN-C50097 add ogb50,51,52
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant_new) RETURNING g_sql #FUN-50102
      PREPARE ogb_ins FROM g_sql
      EXECUTE ogb_ins USING
         l_ogb.ogb01,  l_ogb.ogb03,  l_ogb.ogb04,    l_ogb.ogb05,   l_ogb.ogb05_fac,
         l_ogb.ogb06,  l_ogb.ogb07,  l_ogb.ogb08,    l_ogb.ogb09,   l_ogb.ogb091,
         l_ogb.ogb092, l_ogb.ogb11,  l_ogb.ogb12,    l_ogb.ogb13,   l_ogb.ogb14,
         l_ogb.ogb14t, l_ogb.ogb15,  l_ogb.ogb15_fac,l_ogb.ogb16,   l_ogb.ogb17,
         l_ogb.ogb18,  l_ogb.ogb19,  l_ogb.ogb20,    l_ogb.ogb21,   l_ogb.ogb22,
         l_ogb.ogb31,  l_ogb.ogb32,  l_ogb.ogb60,    l_ogb.ogb63,   l_ogb.ogb64,
         l_ogb.ogb901, l_ogb.ogb902, l_ogb.ogb903,   l_ogb.ogb904,  l_ogb.ogb905,
         l_ogb.ogb906, l_ogb.ogb907, l_ogb.ogb908,   l_ogb.ogb909,  l_ogb.ogb910,
         l_ogb.ogb911, l_ogb.ogb912, l_ogb.ogb913,   l_ogb.ogb914,  l_ogb.ogb915,
         l_ogb.ogb916, l_ogb.ogb917, l_ogb.ogb65,    l_ogb.ogb1001, l_ogb.ogb1002,
         l_ogb.ogb1005,l_ogb.ogb1007,l_ogb.ogb1008,  l_ogb.ogb1009, l_ogb.ogb1010,
         l_ogb.ogb1011,l_ogb.ogb1003,l_ogb.ogb1004,  l_ogb.ogb1006, l_ogb.ogb1012,
         l_ogb.ogb930, l_ogb.ogb1013,l_ogb.ogb1014,  l_ogb.ogb41,   l_ogb.ogb42,
         l_ogb.ogb43,  l_ogb.ogb931, l_ogb.ogb932,   l_ogb.ogbud01, l_ogb.ogbud02,
         l_ogb.ogbud03,l_ogb.ogbud04,l_ogb.ogbud05,  l_ogb.ogbud06, l_ogb.ogbud07,
         l_ogb.ogbud08,l_ogb.ogbud09,l_ogb.ogbud10,  l_ogb.ogbud11, l_ogb.ogbud12,
         l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,  l_ogb.ogbplant,l_ogb.ogblegal,
         l_ogb.ogb44,  l_ogb.ogb45,  l_ogb.ogb46,    l_ogb.ogb47  , l_ogb.ogb37, 
         l_ogb.ogb50, l_ogb.ogb51, l_ogb.ogb52,l_ogb.ogb53, l_ogb.ogb54, l_ogb.ogb55 #FUN-AB0061 add ogb37#FUN-C50097 addogb50,51,52   
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('tsk01',g_tsk.tsk01,'ogb_ins',SQLCA.sqlcode,1)
         LET g_success="N"
         RETURN
      #No.FUN-7B0018 080304 add --begin
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_ogbi.* TO NULL    #No.FUN-830132 add
            LET l_ogbi.ogbi01 = l_ogb.ogb01
            LET l_ogbi.ogbi03 = l_ogb.ogb03
            IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      #No.FUN-7B0018 080304 add --end
      END IF

      LET g_oga.oga50 = g_oga.oga50 + l_ogb.ogb14
      LET g_oga.oga51 = g_oga.oga51 + l_ogb.ogb14t
   END FOREACH

END FUNCTION

FUNCTION t254_field_pic()

   CASE
      WHEN g_tsk.tsk05 = "2"
         CALL cl_set_field_pic("","Y","","","","")
      WHEN g_tsk.tsk05 = "3" OR g_tsk.tsk05 = "4"
         CALL cl_set_field_pic("","","Y","","","")
      WHEN g_tsk.tsk05 = "X"  #CHI-C80041
         CALL cl_set_field_pic("","","","","Y","")  #CHI-C80041
      WHEN g_tsk.tskacti = "N"
         CALL cl_set_field_pic("","","","","Y","")
      WHEN g_tsk.tskacti = "Y" AND g_tsk.tsk05 = "1"
         CALL cl_set_field_pic("","","","","","Y")
      OTHERWISE
         CALL cl_set_field_pic("","","","","","")
  END CASE

END FUNCTION

FUNCTION t254_v_1()
   DEFINE   l_poz02   LIKE poz_file.poz02,
            l_poy03   LIKE poy_file.poy03,
            l_poy31   LIKE poy_file.poy03,
            l_poy32   LIKE poy_file.poy03,
            l_poy33   LIKE poy_file.poy03,
            l_poy34   LIKE poy_file.poy03,
            l_poy35   LIKE poy_file.poy03,
            l_poy36   LIKE poy_file.poy03,
            i         LIKE type_file.num5
DEFINE l_poz               RECORD LIKE poz_file.*

   LET g_tsk_t.tsk07 = g_tsk.tsk07
   INPUT BY NAME g_tsk.tsk07 WITHOUT DEFAULTS
      AFTER FIELD tsk07
         IF NOT cl_null(g_tsk.tsk07)  THEN
            IF g_tsk.tsk07 != g_tsk_t.tsk07 OR g_tsk_t.tsk07 IS NULL THEN
               CALL t254_tsk07('a')
               IF NOT cl_null(g_errno)  THEN
                  LET g_tsk.tsk07 = g_tsk_t.tsk07
                  DISPLAY BY NAME g_tsk.tsk07
                  NEXT FIELD tsk07
               END IF
               FOR i = 0 TO 6
                   SELECT poy03 INTO l_poy03 FROM poy_file
                    WHERE poy01 = g_tsk.tsk07 AND poy02 = i
                   IF SQLCA.sqlcode = 100 THEN
                      LET l_poy03 = NULL
                   END IF
                   CASE i
                      WHEN 0 LET l_poy31 = l_poy03
                      WHEN 1 LET l_poy32 = l_poy03
                      WHEN 2 LET l_poy33 = l_poy03
                      WHEN 3 LET l_poy34 = l_poy03
                      WHEN 4 LET l_poy35 = l_poy03
                      WHEN 5 LET l_poy36 = l_poy03
                   END CASE
               END FOR
               DISPLAY l_poy31 TO FORMONLY.poy31
               DISPLAY l_poy32 TO FORMONLY.poy32
               DISPLAY l_poy33 TO FORMONLY.poy33
               DISPLAY l_poy34 TO FORMONLY.poy34
               DISPLAY l_poy35 TO FORMONLY.poy35
               DISPLAY l_poy36 TO FORMONLY.poy36
               LET g_tsk.tsk11 = l_poy31
               LET g_tsk.tsk12 = l_poy32
               LET g_tsk.tsk13 = l_poy33
               LET g_tsk.tsk14 = l_poy34
               LET g_tsk.tsk15 = l_poy35
               LET g_tsk.tsk16 = l_poy36
               DISPLAY BY NAME g_tsk.tsk11,g_tsk.tsk12,g_tsk.tsk13,
                               g_tsk.tsk14,g_tsk.tsk15,g_tsk.tsk16
               END IF
            END IF

         ON ACTION CONTROLP
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_poz1"
            LET g_qryparam.arg1 = '2'
            LET g_qryparam.default1 = g_tsk.tsk07
            CALL cl_create_qry() RETURNING g_tsk.tsk07
            DISPLAY BY NAME g_tsk.tsk07
            NEXT FIELD tsk07

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION exit
            EXIT INPUT

      END INPUT
      IF INT_FLAG THEN
         LET g_success = 'N'
         LET INT_FLAG = 0
         LET g_tsk.tsk07 = g_tsk_t.tsk07
         LET g_tsk.tsk03 = g_tsk_t.tsk03
         LET g_tsk.tsk17 = g_tsk_t.tsk17
      END IF
END FUNCTION

FUNCTION t254_qty_def()

   IF g_tsl[l_ac].tsl08 <> 0  THEN
      LET g_tsl[l_ac].tsl08 = 0
   END IF
   IF g_tsl[l_ac].tsl09 <> 0  THEN
      LET g_tsl[l_ac].tsl09 = 0
   END IF
   IF g_tsl[l_ac].tsl11 <> 0  THEN
      LET g_tsl[l_ac].tsl11 = 0
   END IF
   IF g_tsl[l_ac].tsl12 <> 0  THEN
      LET g_tsl[l_ac].tsl12 = 0
   END IF
END FUNCTION

#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t254_du_data_to_correct()

   IF cl_null(g_tsl[l_ac].tsl07) THEN
      LET g_tsl[l_ac].tsl08 = NULL
      LET g_tsl[l_ac].tsl09 = NULL
   END IF

   IF cl_null(g_tsl[l_ac].tsl10) THEN
      LET g_tsl[l_ac].tsl11 = NULL
      LET g_tsl[l_ac].tsl12 = NULL
   END IF
   DISPLAY BY NAME g_tsl[l_ac].tsl08
   DISPLAY BY NAME g_tsl[l_ac].tsl09
   DISPLAY BY NAME g_tsl[l_ac].tsl11
   DISPLAY BY NAME g_tsl[l_ac].tsl12

END FUNCTION

FUNCTION t254_set_required()
DEFINE l_ima906            LIKE ima_file.ima906
DEFINE l_ima907            LIKE ima_file.ima907

  IF g_sma.sma115 = 'Y' THEN   #No.TQC-650059
     #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
     IF NOT cl_null(g_tsl[l_ac].tsl03) THEN
        CALL s_chk_va_setting(g_tsl[l_ac].tsl03)
           RETURNING g_flag,l_ima906,l_ima907
        IF l_ima906 = '3' THEN
           CALL cl_set_comp_required("tsl10,tsl12,tsl07,sh09",TRUE)
        END IF
        IF l_ima906 = '1' THEN
           CALL cl_set_comp_required("tsl07,sh09",TRUE)
        END IF
        #單位不同,轉換率,數量必KEY
        IF NOT cl_null(g_tsl[l_ac].tsl07) THEN
           CALL cl_set_comp_required("tsl09",TRUE)
        END IF
        IF NOT cl_null(g_tsl[l_ac].tsl10) THEN
           CALL cl_set_comp_required("tsl12",TRUE)
        END IF
     END IF
  END IF   #No.TQC-650059
END FUNCTION

FUNCTION t254_set_no_required()

   CALL cl_set_comp_required("tsl10,tsl12,tsl07,tsl09",FALSE)
END FUNCTION

#carrier --Begin
#對原來數量/換算率/單位的賦值
FUNCTION t254_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima25  LIKE ima_file.ima25,      #采購單位
            l_unit   LIKE ima_file.ima25,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE tsl_file.tsl11,
            l_qty2   LIKE tsl_file.tsl12,
            l_fac1   LIKE tsl_file.tsl08,
            l_fac    LIKE tsl_file.tsl08,
            l_qty1   LIKE tsl_file.tsl09,
            l_factor LIKE oeb_file.oeb12

    SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file
     WHERE ima01=g_tsl[l_ac].tsl03

    LET l_fac = 1
    IF l_ima25 <> g_tsl[l_ac].tsl07 THEN
       CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl07,l_ima25)
            RETURNING g_cnt,l_fac
       IF g_cnt = 1 THEN
          LET l_fac = 1
       END IF
    END IF
    LET g_tsl[l_ac].tsl08 = l_fac
    IF l_ima906 = '2' THEN
       LET l_fac = 1
       IF l_ima25 <> g_tsl[l_ac].tsl10 THEN
          CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl10,l_ima25)
               RETURNING g_cnt,l_fac
          IF g_cnt = 1 THEN
             LET l_fac = 1
          END IF
       END IF
       LET g_tsl[l_ac].tsl11 = l_fac
    END IF
    LET l_fac2=g_tsl[l_ac].tsl11
    LET l_qty2=g_tsl[l_ac].tsl12
    LET l_fac1=g_tsl[l_ac].tsl08
    LET l_qty1=g_tsl[l_ac].tsl09

    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    LET g_tsl[l_ac].tsl04 = l_ima25

    CASE l_ima906
       WHEN '1' LET l_unit = g_tsl[l_ac].tsl07
                LET l_tot  = l_qty1
       WHEN '2' LET l_tot  = l_fac1*l_qty1+l_fac2*l_qty2
                LET l_unit = l_ima25
       WHEN '3' LET l_unit = g_tsl[l_ac].tsl07
                LET l_tot  = l_qty1
                IF l_qty2 <> 0 THEN
                   LET g_tsl[l_ac].tsl11 = l_qty1 / l_qty2
                ELSE
                   LET g_tsl[l_ac].tsl11 = 0
                END IF
    END CASE

    LET l_fac = 1
    IF l_ima25 <> l_unit THEN
       CALL s_umfchk(g_tsl[l_ac].tsl03,l_unit,l_ima25)
            RETURNING g_cnt,l_fac
       IF g_cnt = 1 THEN
          LET l_fac = 1
       END IF
    END IF

    LET g_tsl[l_ac].tsl05 = l_tot * l_fac
    LET g_tsl[l_ac].tsl05 = s_digqty(g_tsl[l_ac].tsl05,g_tsl[l_ac].tsl04)   #FUN-910088--add--

END FUNCTION
#carrier --End

#No.TQC-650090--begin
FUNCTION t254_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62
  DEFINE li_col_count       LIKE type_file.num5
  DEFINE li_i, li_j         LIKE type_file.num5
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04

  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') AND
      NOT cl_null(lg_smy62) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_tsl.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_tsl.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_tsl[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_tsl[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN
            LET lg_group = l_compare
         #以后是比較
         ELSE
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
         IF lg_group <> lg_smy62 THEN
            LET lg_group = ''
            EXIT FOR
         END IF
       END FOR
     END IF

     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group

     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替tsl03子料件編號來顯示
     #得到當前語言別下tsl03的欄位標題
     #No.TQC-960204  --Begin
      SELECT gae04 INTO l_gae04 FROM gae_file
        WHERE gae01 = g_prog AND gae02 = 'tsl03' AND gae03 = g_lang
     #CALL cl_get_fielddesc("tsl03") RETURNING l_gae04
     #No.TQC-960204  --End
     CALL cl_set_comp_att_text("att00",l_gae04)

     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'tsl03,ima02'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'tsl03,ima02'
     END IF

     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i

         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03

         LET lc_index = li_i USING '&&'

         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)

             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
#            IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
#            ELSE
#               CALL cl_chg_comp_att("formonly.att" || lc_index,"NOENTRY|SCROLL","1|1")
#            END IF
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
#            IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
#            ELSE
#               CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOENTRY|SCROLL","1|1")
#            END IF
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
#            IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
#            ELSE
#               CALL cl_chg_comp_att("formonly.att" || lc_index,"NOENTRY|SCROLL","1|1")
#            END IF
       END CASE
     END FOR

  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'tsl03'
  END IF

  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR

  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)

END FUNCTION

#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------

#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的oea04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把oeb04的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_tsl[l_ac]都被改成g_tsl[p_ac]，請注意

#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t254_check_oeb04(.....)  THEN NEXT FIELD XXX END IF
FUNCTION t254_check_tsl03(p_field,p_ac,p_cmd) #No.MOD-660090
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,
  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,
  ls_value                    STRING,
  g_value                     LIKE type_file.chr1000,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING,
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE ade_file.ade04,
  l_n                         LIKE type_file.num5,
  l_b2                        LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima131                    LIKE ima_file.ima131,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,
  p_cmd                       LIKE type_file.chr1    #No.MOD-660090
DEFINE l_ima135               LIKE ima_file.ima135
DEFINE l_ima906               LIKE ima_file.ima906
DEFINE l_ima907               LIKE ima_file.ima907
DEFINE l_state                LIKE type_file.num5


  #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
  #新的子料件編號并把值填入到已經隱藏起來的oeb04中（如果imxXX能夠顯示，oeb04一定是隱藏的）
  #下面就可以直接沿用oeb04的檢核邏輯了
  #如果不是，則看看是不是oeb04自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
  IF (p_field = 'imx00') OR (p_field = 'imx01') OR (p_field = 'imx02') OR
     (p_field = 'imx03') OR (p_field = 'imx04') OR (p_field = 'imx05') OR
     (p_field = 'imx06') OR (p_field = 'imx07') OR (p_field = 'imx08') OR
     (p_field = 'imx09') OR (p_field = 'imx10')  THEN

     #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
     #全部被輸入完成了才進行后續的操作
     LET ls_pid   = g_tsl[p_ac].att00   # ls_pid 父料件編號
     LET ls_value = g_tsl[p_ac].att00   # ls_value 子料件編號
     IF cl_null(ls_pid) THEN
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被注釋掉
        CALL t254_set_required()

        RETURN TRUE,g_buf,l_ima135,l_ima25,l_imaacti
     END IF  #注意這里沒有錯，所以返回TRUE

     #取出當前母料件包含的明細屬性的個數
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
     IF l_cnt = 0 THEN
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t254_set_required()

        RETURN TRUE,g_buf,l_ima135,l_ima25,l_imaacti
     END IF

     FOR li_i = 1 TO l_cnt
         #如果有任何一個明細屬性應該輸而沒有輸的則退出
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN
            #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
            #注釋掉
            CALL t254_set_required()

            RETURN TRUE,g_buf,l_ima135,l_ima25,l_imaacti
         END IF
     END FOR

     #得到系統定義的標准分隔符sma46
     SELECT sma46 INTO l_ps FROM sma_file

     #合成子料件的名稱
     SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
       WHERE ima01 = ls_pid
     LET ls_spec = ls_pname  # ls_spec 子料件名稱
     #方法:循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
     #替換初始名稱，如果找不到則就用原來的名稱
     FOR li_i = 1 TO l_cnt
         LET lc_agd03 = ""
         LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]
         SELECT agd03 INTO lc_agd03 FROM agd_file
          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
         IF cl_null(lc_agd03) THEN
            LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]
         ELSE
            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
         END IF
     END FOR

     #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
     LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
     LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉

     LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                  "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",
                  "ORDER BY agb02"
     DECLARE param_curs CURSOR FROM ls_sql
     FOREACH param_curs INTO lc_agb03
       #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
       IF cl_null(l_param_list) THEN
          LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
       ELSE
          LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
       END IF
     END FOREACH

     LET g_value=ls_value
     SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_value
     IF l_n=0 THEN
        CALL cl_err('g_value','ams-003',1)
        RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
     END IF
     #調用cl_copy_ima將新生成的子料件插入到數據庫中
#    IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN
#       #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
#       LET ls_value_fld = ls_value
#       INSERT INTO imx_file VALUES(ls_value_fld,arr_detail[p_ac].imx[1],
#         arr_detail[p_ac].imx[2],arr_detail[p_ac].imx[3],arr_detail[p_ac].imx[4],
#         arr_detail[p_ac].imx[5],arr_detail[p_ac].imx[6],arr_detail[p_ac].imx[7],
#         arr_detail[p_ac].imx[8],arr_detail[p_ac].imx[9],arr_detail[p_ac].imx[10],
#         ls_pid)
#       #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
#       #記錄的完全同步
#       IF SQLCA.sqlcode THEN

#          DELETE FROM ima_file WHERE ima01 = ls_value_fld
#          RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
#       END IF
#    END IF

     #把生成的子料件賦給tsl03，否則下面的檢查就沒有意義了
     LET g_tsl[p_ac].tsl03 = ls_value
     SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_tsl[l_ac].tsl03
     IF l_n=0 THEN
        CALL cl_err('tsl03','ams-003',1)
        RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
     END IF
  ELSE
    IF ( p_field <> 'tsl03' )AND( p_field <> 'imx00' ) THEN
       RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
    END IF
  END IF

  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照oeb04進行判斷了

  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD oeb04段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了

  IF NOT cl_null(g_tsl[l_ac].tsl03) THEN
     CALL t254_tsl03(p_cmd)
     IF NOT cl_null(g_errno)  THEN
        CALL cl_err(g_tsl[l_ac].tsl03,g_errno,1)
        LET g_tsl[l_ac].tsl03 = g_tsl_t.tsl03
        DISPLAY BY NAME g_tsl[l_ac].tsl03
        RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
     END IF
     IF g_sma.sma115 = 'Y' THEN
        CALL s_chk_va_setting(g_tsl[l_ac].tsl03)
           RETURNING g_flag,l_ima906,l_ima907
        IF g_flag=1 THEN
           RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
        END IF
     END IF
     IF g_tsl[l_ac].tsl03 <> g_tsl_t.tsl03 THEN
        CALL t254_lot('1') RETURNING l_state
        IF l_state = FALSE THEN
           RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
        END IF
     END IF
     SELECT ima02,ima135,ima25,imaacti
       INTO g_buf,l_ima135,l_ima25,l_imaacti
       FROM ima_file
      WHERE ima01=g_tsl[l_ac].tsl03
     LET g_tsl[l_ac].tsl04 = l_ima25
     LET g_tsl[l_ac].ima02 = g_buf
     LET g_tsl[l_ac].ima135= l_ima135
     CALL t254_qty_def()
#    LET g_tsl_t.* = g_tsl[l_ac].*
     IF g_sma.sma115 = 'Y' THEN
        IF p_cmd='a' OR (p_cmd='u' AND g_tsl_t.tsl03<>g_tsl[l_ac].tsl03) THEN
           LET g_tsl[l_ac].tsl07 = l_ima25
           LET g_tsl[l_ac].tsl10 = l_ima907
        END IF
     END IF

     #新增一個判斷,如果lg_smy62不為空,表示當前采用的是料件多屬性的新機制,因此這個函數應該是被
     #attxx這樣的明細屬性欄位的AFTER FIELD來調用的,所以不再使用原來的輸入機制,否則不變
     IF cl_null(lg_smy62) THEN
        IF g_sma.sma120 = 'Y' THEN
           CALL cl_itemno_multi_att("tsl03",g_tsl[l_ac].tsl03,"",'1','2') RETURNING l_check,g_tsl[l_ac].tsl03,g_tsl[l_ac].ima02
           DISPLAY g_tsl[l_ac].tsl03 TO tsl03
           DISPLAY g_tsl[l_ac].ima02 TO ima02
        END IF
     END IF

     SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_tsl[l_ac].tsl03
     IF l_n=0 THEN
        CALL cl_err('tsl03','ams-003',1)
        RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
     END IF
     RETURN TRUE,g_buf,l_ima135,l_ima25,l_imaacti
  ELSE
     #如果是由oeb04來觸發的,說明當前用的是舊的流程,那么oeb04為空是可以的
     #如果是由att00來觸發,原理一樣
     IF (p_field = 'tsl03') OR (p_field = 'imx00') THEN
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t254_set_required()
     LET g_value=ls_value
     SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_value
     IF l_n=0 THEN
        CALL cl_err('g_value','ams-003',1)
        RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
     END IF

        RETURN TRUE,g_buf,l_ima135,l_ima25,l_imaacti
     ELSE
        #如果不是oeb,則是由attxx來觸發的,則非輸不可
        RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
     END IF #如果為空則不允許新增
  END IF
END FUNCTION

#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t254_check_tsl03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t254_check_att0x(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.chr1,
  p_row        LIKE type_file.num5,
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
  p_cmd        LIKE type_file.chr1,   #No.MOD-660090
  l_check_res     LIKE type_file.num5,
  l_b2            LIKE nma_file.nma04,
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE ima_file.ima130,
  l_ima131        LIKE ima_file.ima131,
  l_ima25         LIKE ima_file.ima25
DEFINE l_ima135            LIKE ima_file.ima135

  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成tsl03料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
  END IF

  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t254_refresh_detail()函數在較早的時候填充

  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
  END IF
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t254_check_tsl03('imx' || l_index ,p_row,p_cmd)  #No.MOD-660090
    RETURNING l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
    RETURN l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
    LET g_tsl[l_ac].tsl05 = s_digqty(g_tsl[l_ac].tsl05,g_tsl[l_ac].tsl04)    #FUN-910088--add--
    LET g_tsl[l_ac].tsl09 = s_digqty(g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl07)    #FUN-910088--add--
    LET g_tsl[l_ac].tsl12 = s_digqty(g_tsl[l_ac].tsl12,g_tsl[l_ac].tsl10)    #FUN-910088--add--
END FUNCTION

#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t254_check_tsl03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t254_check_att0x_c(p_value,p_index,p_row,p_cmd)  #No.MOD-660090
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,
  p_row    LIKE type_file.num5,
  l_index  STRING,
  p_cmd    LIKE type_file.chr1,   #No.MOD-660090
  l_check_res     LIKE type_file.num5,
  l_b2            LIKE nma_file.nma04,
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE ima_file.ima130,
  l_ima131        LIKE ima_file.ima131,
  l_ima25         LIKE ima_file.ima25
DEFINE l_ima135            LIKE ima_file.ima135


  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成oeb04料件編號
  IF cl_null(p_value) THEN
     RETURN FALSE,g_buf,l_ima135,l_ima25,l_imaacti
  END IF
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t254_check_tsl03('imx'||l_index,p_row,p_cmd) #No.MOD-660090
    RETURNING l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
  RETURN l_check_res,g_buf,l_ima135,l_ima25,l_imaacti
  LET g_tsl[l_ac].tsl05 = s_digqty(g_tsl[l_ac].tsl05,g_tsl[l_ac].tsl04)    #FUN-910088--add--
  LET g_tsl[l_ac].tsl09 = s_digqty(g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl07)    #FUN-910088--add--
  LET g_tsl[l_ac].tsl12 = s_digqty(g_tsl[l_ac].tsl12,g_tsl[l_ac].tsl10)    #FUN-910088--add--
END FUNCTION

#No.TQC-650090--end

FUNCTION t254_qry_lot(p_InTransaction,p_action)
   DEFINE p_InTransaction   LIKE type_file.num5
   DEFINE p_action          LIKE type_file.chr3
   DEFINE l_last_poy02      LIKE poy_file.poy02
   DEFINE l_last_poy04      LIKE poy_file.poy04
   DEFINE l_azp03           LIKE azp_file.azp03
   DEFINE l_poy11           LIKE poy_file.poy11
   DEFINE l_dbs             LIKE type_file.chr21
   DEFINE l_dbs_tra         LIKE type_file.chr21
   DEFINE p_plant_new       LIKE azp_file.azp01
   DEFINE l_ima918          LIKE ima_file.ima918
   DEFINE l_ima921          LIKE ima_file.ima921
   DEFINE l_img09           LIKE img_file.img09
   DEFINE l_sw              LIKE type_file.chr1
   DEFINE l_factor          LIKE ogb_file.ogb15_fac
   DEFINE l_qty             LIKE tsl_file.tsl05

   IF l_ac <= 0 THEN RETURN END IF
   IF cl_null(p_InTransaction) THEN LET p_InTransaction = FALSE END IF

   CALL s_mtrade_last_plant(g_tsk.tsk07)     #最后一站的站別 & 營運中心
        RETURNING l_last_poy02,l_last_poy04
   #CALL t254_azp(l_last_poy04) RETURNING l_dbs,l_dbs_tra,p_plant_new#FUN-A50102

   LET l_ima918 = ''
   LET l_ima921 = ''
   #LET g_sql = " SELECT ima918,ima921 FROM ",l_dbs CLIPPED,"ima_file",
   LET g_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(l_last_poy04,'ima_file'), #FUN-A50102
               "  WHERE ima01 = '",g_tsl[l_ac].tsl03,"'",
               "    AND imaacti = 'Y'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-A50102
   PREPARE ima_p1 FROM g_sql
   EXECUTE ima_p1 INTO l_ima918,l_ima921

   IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
      #LET g_sql = " SELECT img09 FROM ",l_dbs_tra CLIPPED,"img_file",
      LET g_sql = " SELECT img09 FROM ",cl_get_target_table(l_last_poy04,'img_file'), #FUN-A50102
                  "  WHERE img01 = '",g_tsl[l_ac].tsl03,"'",
                  "    AND img02 = '",g_tsk.tsk17,"'",
                  "    AND img03 = ' ' ",
                  "    AND img04 = ' ' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
      PREPARE img_p1 FROM g_sql
      EXECUTE img_p1 INTO l_img09

      CALL s_umfchkm(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl04,l_img09,l_last_poy04)
           RETURNING l_sw,l_factor

      LET g_success = 'Y'
      IF NOT p_InTransaction THEN
         BEGIN WORK
      END IF
      CALL s_mlotout(g_prog,g_tsk.tsk01,g_tsl[l_ac].tsl02,0,
                    g_tsl[l_ac].tsl03,g_tsk.tsk17,' ',' ',
                    g_tsl[l_ac].tsl04,l_img09,l_factor,
                    g_tsl[l_ac].tsl05,'QRY',l_last_poy04)
           RETURNING l_sw,l_qty
      IF NOT p_InTransaction THEN
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t254_bshow()

   IF NOT cl_null(g_tsk.tsk08) THEN
      CALL t254_tsk08('d')
   ELSE
      DISPLAY '' TO FORMONLY.gen02
   END IF
   IF NOT cl_null(g_tsk.tsk09) THEN
      CALL t254_tsk09('d')
   ELSE
      DISPLAY '' TO FORMONLY.gem02
   END IF
   IF NOT cl_null(g_tsk.tsk03) THEN
      CALL t254_tsk03('d')
   ELSE
      DISPLAY '' TO FORMONLY.azp02
   END IF

   IF NOT cl_null(g_tsk.tsk17) THEN
      CALL t254_imd02(g_tsk.tsk17,g_tsk.tsk03,'d')
   ELSE
      DISPLAY '' TO FORMONLY.imd02
   END IF

END FUNCTION

FUNCTION t254_tsk03(p_cmd)
  DEFINE p_cmd    LIKE type_file.chr1
  DEFINE l_azp02  LIKE azp_file.azp03
  DEFINE l_azp053 LIKE azp_file.azp03

    LET g_errno=' '
    SELECT azp02,azp053 INTO l_azp02,l_azp053 FROM azp_file
     WHERE azp01=g_tsk.tsk03

     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
                                    LET l_azp02 = NULL
          WHEN l_azp053 ='N'        LET g_errno = 'mfg8000'
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_azp02 TO FORMONLY.azp02
    END IF
END FUNCTION

FUNCTION t254_rvbs(p_rvbs00,p_rvbs01,p_rvbs02,p_rvbs01_t,p_rvbs02_t,p_action)
   DEFINE p_rvbs00          LIKE rvbs_file.rvbs00   #程序代號
   DEFINE p_rvbs01          LIKE rvbs_file.rvbs01   #異動單號
   DEFINE p_rvbs02          LIKE rvbs_file.rvbs02   #項次
   DEFINE p_rvbs01_t        LIKE rvbs_file.rvbs01   #異動單號 - 舊值
   DEFINE p_rvbs02_t        LIKE rvbs_file.rvbs02   #項次     - 舊值
   DEFINE p_action          LIKE type_file.chr3
   DEFINE l_last_poy02      LIKE poy_file.poy02
   DEFINE l_last_poy04      LIKE poy_file.poy04
   DEFINE l_azp03           LIKE azp_file.azp03
   DEFINE l_poy11           LIKE poy_file.poy11
   DEFINE l_dbs             LIKE type_file.chr21
   DEFINE l_dbs_tra         LIKE type_file.chr21
   DEFINE p_plant_new       LIKE azp_file.azp01 
   DEFINE l_ima918          LIKE ima_file.ima918

    IF p_action <> 'MOD' AND p_action <> 'DEL' AND p_action <> 'INS' THEN
       RETURN
    END IF
    IF cl_null(p_rvbs00)   THEN RETURN END IF
    IF cl_null(p_rvbs01)   THEN RETURN END IF
    IF cl_null(p_rvbs02)   THEN LET p_rvbs02 = 0   END IF
    IF cl_null(p_rvbs02_t) THEN LET p_rvbs02_t = 0 END IF

    CALL s_mtrade_last_plant(g_tsk.tsk07)     #最后一站的站別 & 營運中心
         RETURNING l_last_poy02,l_last_poy04
    #CALL t254_azp(l_last_poy04) RETURNING l_dbs,l_dbs_tra,p_plant_new #FUN-A50102

    IF p_action = 'DEL' THEN
       #LET g_sql = " DELETE FROM ",l_dbs_tra CLIPPED,"rvbs_file ",
       LET g_sql = " DELETE FROM ",cl_get_target_table(l_last_poy04,'rvbs_file'), #FUN-A50102
                   "  WHERE rvbs00 = '",p_rvbs00,"'",    #程序代號
                   "    AND rvbs01 = '",p_rvbs01_t,"'",  #單號舊值
                   "    AND rvbs09 = -1"                 #出貨 最后一站均為-1
       IF p_rvbs02_t <> 0 THEN
          LET g_sql = g_sql CLIPPED,"   AND rvbs02 = ",p_rvbs02_t  #項次舊值
       END IF
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
       CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093

       PREPARE del_rvbs_p1 FROM g_sql
       EXECUTE del_rvbs_p1
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL cl_err3('del','rvbs_file',p_rvbs01_t,p_rvbs02_t,SQLCA.sqlcode,'','',1)
       END IF
    END IF

    IF p_action = 'MOD' THEN  #修改
       IF p_rvbs02 <> 0  AND p_rvbs02_t <> 0 THEN  #單身修改
          #LET g_sql = " UPDATE ",l_dbs_tra CLIPPED,"rvbs_file ",
          LET g_sql = " UPDATE ",cl_get_target_table(l_last_poy04,'rvbs_file'), #FUN-A50102
                      "    SET rvbs01 = ?,",
                      "        rvbs02 = ? ",
                      "  WHERE rvbs00 = '",p_rvbs00,"'",
                      "    AND rvbs01 = '",p_rvbs01_t,"'",
                      "    AND rvbs02 =  ",p_rvbs02_t,
                      "    AND rvbs09 = -1"              #出貨 最后一站均為-1
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
          CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
          PREPARE upd_rvbs_p1 FROM g_sql
          EXECUTE upd_rvbs_p1 USING p_rvbs01,p_rvbs02
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL cl_err3('upd','rvbs_file',p_rvbs01_t,p_rvbs02_t,SQLCA.sqlcode,'','',1)
          END IF
       ELSE                                                       #單頭修改
          #LET g_sql = " UPDATE ",l_dbs_tra CLIPPED,"rvbs_file ",
          LET g_sql = " UPDATE ",cl_get_target_table(l_last_poy04,'rvbs_file'), #FUN-A50102
                      "    SET rvbs01 = ? ",
                      "  WHERE rvbs00 = '",p_rvbs00,"'",
                      "    AND rvbs01 = '",p_rvbs01_t,"'",
                      "    AND rvbs09 = -1"              #出貨 最后一站均為-1
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
          CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
          PREPARE upd_rvbs_p2 FROM g_sql
          EXECUTE upd_rvbs_p2 USING p_rvbs01
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL cl_err3('upd','rvbs_file',p_rvbs01_t,'',SQLCA.sqlcode,'','',1)
          END IF
       END IF
    END IF

END FUNCTION

FUNCTION t254_tsl04()
  DEFINE l_gfeacti  LIKE gfe_file.gfeacti
  DEFINE l_ima25    LIKE ima_file.ima25
  DEFINE l_fac     LIKE ogb_file.ogb15_fac

  LET g_errno=' '
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
   WHERE gfe01=g_tsl[l_ac].tsl04

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE

  IF NOT cl_null(g_errno) THEN RETURN END IF
  IF NOT cl_null(g_tsl[l_ac].tsl03) THEN
     SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_tsl[l_ac].tsl03
     CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl04,l_ima25)
        RETURNING g_cnt,l_fac
     IF g_cnt = 1 THEN
        LET g_errno = 'mfg3075'
     END IF
  END IF

END FUNCTION

FUNCTION t254_lot(p_type)
   DEFINE p_type          LIKE type_file.chr1  #1.料件 2.單位 3.數量
   DEFINE l_last_poy02    LIKE poy_file.poy02
   DEFINE l_last_poy04    LIKE poy_file.poy04
   DEFINE l_dbs           LIKE type_file.chr21
   DEFINE l_dbs_tra       LIKE type_file.chr21
   DEFINE p_plant_new     LIKE azp_file.azp01 
   DEFINE l_ima918        LIKE ima_file.ima918
   DEFINE l_ima921        LIKE ima_file.ima921
   DEFINE l_img09         LIKE img_file.img09
   DEFINE l_sw            LIKE type_file.chr1
   DEFINE l_factor        LIKE ogb_file.ogb15_fac
   DEFINE l_qty           LIKE tsl_file.tsl05
   DEFINE l_poy11         LIKE poy_file.poy11
   DEFINE l_str           STRING

   CALL s_mtrade_last_plant(g_tsk.tsk07)     #最后一站的站別 & 營運中心
        RETURNING l_last_poy02,l_last_poy04
   #CALL t254_azp(l_last_poy04) RETURNING l_dbs,l_dbs_tra,p_plant_new  #FUN-A50102

   #1.Check 出貨倉庫是否有維護
   SELECT poy11 INTO l_poy11                 #出貨倉庫
     FROM poy_file,poz_file
    WHERE poz01 = g_tsk.tsk07
      AND poz01 = poy01
      AND poy02 = (SELECT MAX(poy02) FROM poy_file
    WHERE poy01 = g_tsk.tsk07)
   IF cl_null(l_poy11) THEN
      CALL cl_err(g_tsk.tsk07,'atm-150',1)
      RETURN FALSE
   END IF

   #2.Check 料件+出貨倉庫是否存在img_file
   #LET g_sql = " SELECT img09 FROM ",l_dbs_tra CLIPPED,"img_file",
   LET g_sql = " SELECT img09 FROM ",cl_get_target_table(l_last_poy04,'img_file'), #FUN-A50102
               "  WHERE img01 = '",g_tsl[l_ac].tsl03,"'",
               "    AND img02 = '",l_poy11,"'",
               "    AND img03 = ' ' ",
               "    AND img04 = ' ' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
   CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093

   PREPARE img_p2 FROM g_sql
   EXECUTE img_p2 INTO l_img09
   IF SQLCA.sqlcode THEN
      LET l_str = l_last_poy04 CLIPPED,'|',g_tsl[l_ac].tsl03 CLIPPED,'|',l_poy11 CLIPPED
      CALL cl_err(l_str,-1281,1)
      RETURN FALSE
   END IF

   #3.Check 出貨單位是否和出貨img_file 有轉換率
   CALL s_umfchkm(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl04,l_img09,l_last_poy04)
        RETURNING l_sw,l_factor
   IF SQLCA.sqlcode THEN
      LET l_str = l_last_poy04 CLIPPED,'|',g_tsl[l_ac].tsl04 CLIPPED,'|',l_img09 CLIPPED
      CALL cl_err(l_str,'mfg2719',1)
      RETURN FALSE
   END IF

   IF p_type = '3' THEN    #數量字段時,要開批序號維護的畫面
      #4.批序號開窗錄入
      LET l_ima918 = ''
      LET l_ima921 = ''
      #LET g_sql = " SELECT ima918,ima921 FROM ",l_dbs CLIPPED,"ima_file",
      LET g_sql = " SELECT ima918,ima921 FROM ",cl_get_target_table(l_last_poy04,'ima_file'), #FUN-A50102
                  "  WHERE ima01 = '",g_tsl[l_ac].tsl03,"'",
                  "    AND imaacti = 'Y'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      CALL cl_parse_qry_sql(g_sql,l_last_poy04) RETURNING g_sql #FUN-980093
      PREPARE ima_p2 FROM g_sql
      EXECUTE ima_p2 INTO l_ima918,l_ima921
      IF cl_null(l_ima918) THEN LET l_ima918 = 'N' END IF
      IF cl_null(l_ima921) THEN LET l_ima921 = 'N' END IF

      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         CALL s_mlotout(g_prog,g_tsk.tsk01,g_tsl[l_ac].tsl02,0,
                       g_tsl[l_ac].tsl03,l_poy11,' ',' ',
                       g_tsl[l_ac].tsl04,l_img09,l_factor,
                       g_tsl[l_ac].tsl05,'MOD',l_last_poy04)
              RETURNING l_sw,l_qty
         IF l_sw = "Y" THEN
            LET g_tsl[l_ac].tsl05 = l_qty
            LET g_tsl[l_ac].tsl05 = s_digqty(g_tsl[l_ac].tsl05,g_tsl[l_ac].tsl04)    #FUN-910088--add--
            DISPLAY BY NAME g_tsl[l_ac].tsl05
            RETURN TRUE
         END IF
      END IF
   END IF
   RETURN TRUE

END FUNCTION

FUNCTION t254_tsk07(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_poz     RECORD LIKE poz_file.*
   DEFINE l_poy     RECORD LIKE poy_file.*
   DEFINE l_flag    LIKE type_file.chr1

   LET g_errno = NULL
   LET l_flag = 'Y'
   SELECT * INTO l_poz.* FROM poz_file
    WHERE poz01 = g_tsk.tsk07
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'tri-006'
       WHEN l_poz.pozacti='N'    LET g_errno = '9028'
       WHEN l_poz.poz00 <> '2'   LET g_errno = 'tri-008'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) AND p_cmd <> 'd' THEN
     SELECT poy_file.* INTO l_poy.* 
       FROM poy_file,poz_file
      WHERE poy01 = poz01
        AND poy01 = g_tsk.tsk07
        AND poy02 = 0
     IF l_poy.poy04 <> g_tsk.tsk03 THEN
        LET g_errno = 'atm-153'
        LET l_flag = 'N'
     END IF
     IF l_poy.poy11 <> g_tsk.tsk17 THEN
        LET g_errno = 'atm-154'
        LET l_flag = 'N'
     END IF
     IF l_flag = 'N' THEN
        IF cl_confirm('atm-155') THEN
           LET g_tsk.tsk03 = l_poy.poy04 
           LET g_tsk.tsk17 = l_poy.poy11 
           LET g_errno = NULL
        END IF
     END IF
  END IF
  DISPLAY l_poz.poz02 TO FORMONLY.poz02
END FUNCTION

#No.FUN-870007-start-
FUNCTION t254_tsk24(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
#  DEFINE l_azp02 LIKE azp_file.azp02
#  DEFINE l_dbs   LIKE azp_file.azp03

#  LET g_errno = ''
#  SELECT azp02,azp01
#    INTO l_azp02,g_tsk.tsk03
#    FROM azp_file
#   WHERE azp01 = g_tsk.tsk24
#  CASE
#      WHEN SQLCA.sqlcode = 100 LET g_errno = 'art-002'
#                               LET l_azp02 = ''
#      OTHERWISE
#      LET g_errno=SQLCA.sqlcode USING '------'
#  END CASE
#  IF cl_null(g_errno) THEN
#     IF NOT cl_null(g_tsk.tsk17) THEN
#        CALL t254_azp(g_tsk.tsk03) RETURNING l_dbs
#        IF cl_null(g_errno) THEN
#           CALL t254_imd(g_tsk.tsk17,g_tsk.tsk03) RETURNING g_sw #FUN-980093 add
#           IF NOT g_sw THEN
#              CALL t254_imd02(g_tsk.tsk17,g_tsk.tsk03) RETURNING g_imd02 #FUN-980093 add
#           END IF
#        END IF
#     END IF
#   END IF
#   IF cl_null(g_errno) OR p_cmd = 'd' THEN
#      DISPLAY l_azp02 TO tsk24_desc
#      DISPLAY BY NAME g_tsk.tsk03
#      DISPLAY g_azp02 TO azp02
#      DISPLAY g_imd02 TO FORMONLY.imd02
#   END IF
END FUNCTION
#No.FUN-870007--end--

#No.TQC-A20063  --Begin
FUNCTION t254_art(p_poy,p_pmc01,p_plant)
   DEFINE p_poy         RECORD LIKE poy_file.*
   DEFINE p_pmc01       LIKE pmc_file.pmc01
   DEFINE p_plant       LIKE azp_file.azp01
   DEFINE l_dbs         LIKE type_file.chr21
   DEFINE l_dbs_tra     LIKE type_file.chr21
   DEFINE l_pmc         RECORD LIKE pmc_file.*

   #LET g_plant_new = p_plant
   #FUN-A50102--mark--str--
   #CALL s_getdbs()
   #LET l_dbs = g_dbs_new
   #CALL s_gettrandbs()
   #LET l_dbs_tra = g_dbs_tra
   #FUN-A50102--mark--end

   IF cl_null(p_poy.poy35) THEN   #采购单别
      SELECT rye03 INTO p_poy.poy35 FROM rye_file
       WHERE rye01 = 'apm'
         AND rye02 = '2'
      IF SQLCA.sqlcode THEN
         LET g_showmsg = 'apm','/2'
         CALL s_errmsg('rye01,rye02',g_showmsg,'SELECT rye03',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #LET g_sql = " SELECT * FROM ",l_dbs CLIPPED,"pmc_file ",
   LET g_sql = " SELECT * FROM ",cl_get_target_table(p_plant,'pmc_file'), #FUN-A50102
               "  WHERE pmc01 = '",p_pmc01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE t254_pmc_px1 FROM g_sql
   EXECUTE t254_pmc_px1 INTO l_pmc.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pmc01',l_pmc.pmc01,'SELECT pmc',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(p_poy.poy06) THEN  #付款方式
      LET p_poy.poy06 = l_pmc.pmc17
   END IF
   IF cl_null(p_poy.poy09) THEN  #PO税别
      LET p_poy.poy09 = l_pmc.pmc47
   END IF
   IF cl_null(p_poy.poy05) THEN  #币别
      LET p_poy.poy05 = l_pmc.pmc22
   END IF
  #IF cl_null(p_poy.poy32) THEN  #调拨理由码
  #   LET p_poy.poy32 = l_pmc.pmc
  #END IF
   RETURN p_poy.*

END FUNCTION
#No.TQC-A20063  --End  

#FUN-910088--aad--start--
FUNCTION t254_tsl05_check()
   DEFINE l_state         LIKE type_file.num5
   IF NOT cl_null(g_tsl[l_ac].tsl05) AND NOT cl_null(g_tsl[l_ac].tsl04) THEN
      IF cl_null(g_tsl04_t) OR cl_null(g_tsl_t.tsl05) OR g_tsl04_t != g_tsl[l_ac].tsl04 OR g_tsl_t.tsl05 != g_tsl[l_ac].tsl05 THEN
         LET g_tsl[l_ac].tsl05 = s_digqty(g_tsl[l_ac].tsl05,g_tsl[l_ac].tsl04)
         DISPLAY BY NAME g_tsl[l_ac].tsl05
      END IF
   END IF
   IF NOT cl_null(g_tsl[l_ac].tsl05) THEN
      IF (g_tsl[l_ac].tsl05 != g_tsl_t.tsl05)
         OR (g_tsl_t.tsl05 IS NULL) THEN
         CALL t254_lot('3') RETURNING l_state
         IF l_state = FALSE THEN
            CALL cl_err('g_tsl[l_ac].tsl05','mfg4012',0)
            LET g_tsl[l_ac].tsl05 = g_tsl_t.tsl05
            RETURN FALSE    
         END IF
         IF g_tsl[l_ac].tsl05<=0 THEN
            CALL cl_err('g_tsl[l_ac].tsl05','mfg4012',0)
            LET g_tsl[l_ac].tsl05 = g_tsl_t.tsl05
            DISPLAY BY NAME g_tsl[l_ac].tsl05
          RETURN FALSE      
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t254_tsl09_check(p_tsl09,p_tsl12)
   DEFINE p_tsl09  LIKE tsl_file.tsl09,
          p_tsl12  LIKE tsl_file.tsl12,
          l_ima906 LIKE ima_file.ima906,
          l_ima907 LIKE ima_file.ima907
   IF NOT cl_null(g_tsl[l_ac].tsl09) AND NOT cl_null(g_tsl[l_ac].tsl07) THEN
      IF cl_null(g_tsl07_t) OR cl_null(g_tsl_t.tsl09) OR g_tsl07_t != g_tsl[l_ac].tsl07 OR g_tsl_t.tsl09 != g_tsl[l_ac].tsl09 THEN
         LET g_tsl[l_ac].tsl09 = s_digqty(g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl07)
         DISPLAY BY NAME g_tsl[l_ac].tsl09
      END IF
   END IF
   IF NOT cl_null(g_tsl[l_ac].tsl09) THEN
      IF g_tsl[l_ac].tsl09<=0 THEN
         CALL cl_err('g_tsl[l_ac].tsl09','mfg4012',0)
         LET g_tsl[l_ac].tsl09 = g_tsl_t.tsl09
         DISPLAY BY NAME g_tsl[l_ac].tsl09
         RETURN "tsl09",p_tsl09,p_tsl12
      END IF
      IF cl_null(g_tsl[l_ac].tsl08) THEN LET g_tsl[l_ac].tsl08 = 1 END IF
      LET p_tsl09 = g_tsl[l_ac].tsl08*g_tsl[l_ac].tsl09
      LET p_tsl09 = s_digqty(p_tsl09,g_tsl[l_ac].tsl07)
      CALL s_chk_va_setting(g_tsl[l_ac].tsl03)
         RETURNING g_flag,l_ima906,l_ima907
      IF l_ima906 = '2' THEN
         IF g_tsl[l_ac].tsl12 > 0 THEN
            LET p_tsl12 = g_tsl[l_ac].tsl12 * g_tsl[l_ac].tsl11
            LET p_tsl12 = s_digqty(p_tsl12,g_tsl[l_ac].tsl10)   
         END IF
      ELSE
         LET p_tsl12 = 0
      END IF
      CALL t254_du_data_to_correct()
      LET g_tsl[l_ac].tsl05 = p_tsl12 + p_tsl09
      IF g_tsl[l_ac].tsl05 IS NULL OR g_tsl[l_ac].tsl05=0 THEN
         IF l_ima906 MATCHES '[23]' THEN
            RETURN "tsl09",p_tsl09,p_tsl12
         ELSE
            RETURN "tsl07",p_tsl09,p_tsl12
         END IF
      END IF
   ELSE
      LET p_tsl09 = 0
   END IF
   CALL cl_show_fld_cont()
   RETURN "",p_tsl09,p_tsl12
END FUNCTION

FUNCTION t254_tsl12_check(p_tsl12,p_tsl09,p_ima906)
   DEFINE p_tsl12   LIKE tsl_file.tsl12,
          p_tsl09   LIKE tsl_file.tsl09,
          p_ima906  LIKE ima_file.ima906
   DEFINE l_fac     LIKE inb_file.inb08_fac   
   IF NOT cl_null(g_tsl[l_ac].tsl12) AND NOT cl_null(g_tsl[l_ac].tsl10) THEN
      IF cl_null(g_tsl_t.tsl12) OR cl_null(g_tsl10_t) OR g_tsl_t.tsl12 != g_tsl[l_ac].tsl12 OR g_tsl10_t != g_tsl[l_ac].tsl12 THEN
         LET g_tsl[l_ac].tsl12 = s_digqty(g_tsl[l_ac].tsl12,g_tsl[l_ac].tsl10)
         DISPLAY BY NAME g_tsl[l_ac].tsl12
      END IF
   END IF 
   IF NOT cl_null(g_tsl[l_ac].tsl12) THEN
      IF g_tsl[l_ac].tsl12<=0 THEN
         CALL cl_err('g_tsl[l_ac].tsl12','mfg4012',0)
         LET g_tsl[l_ac].tsl12 = g_tsl_t.tsl12
         DISPLAY BY NAME g_tsl[l_ac].tsl12
         RETURN FALSE,p_tsl12,p_tsl09    
      END IF
      IF p_ima906 = '2' THEN                #母子單位
         LET p_tsl12 = g_tsl[l_ac].tsl11*g_tsl[l_ac].tsl12
         LET p_tsl12 = s_digqty(p_tsl12,g_tsl[l_ac].tsl10)   
         IF g_tsl[l_ac].tsl09 > 0 THEN
            LET p_tsl09 = g_tsl[l_ac].tsl09 * g_tsl[l_ac].tsl08
            LET p_tsl09 = s_digqty(p_tsl09,g_tsl[l_ac].tsl07)      
         END IF
      END IF
         IF p_ima906='3' THEN
            IF cl_null(g_tsl[l_ac].tsl09) OR g_tsl[l_ac].tsl09=0 OR
               g_tsl[l_ac].tsl12 <> g_tsl_t.tsl12 OR cl_null(g_tsl_t.tsl12)
            THEN
               LET l_fac = 1
               CALL s_umfchk(g_tsl[l_ac].tsl03,g_tsl[l_ac].tsl10,
                              g_tsl[l_ac].tsl07)
                    RETURNING g_cnt,l_fac
               IF g_cnt = 1 THEN
               ELSE
                  LET g_tsl[l_ac].tsl09=g_tsl[l_ac].tsl12*l_fac
                  LET g_tsl[l_ac].tsl09 = s_digqty(g_tsl[l_ac].tsl09,g_tsl[l_ac].tsl07)   
               END IF
               DISPLAY BY NAME g_tsl[l_ac].tsl09
            END IF
         END IF
   END IF
   RETURN TRUE,p_tsl12,p_tsl09
END FUNCTION
#FUN-910088--add--end--
#CHI-C80041---begin
FUNCTION t254_c(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_chr LIKE type_file.chr1
DEFINE l_c   LIKE type_file.chr1       #FUN-D20039  add

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_tsk.tsk01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_tsk.tsk05='X' THEN RETURN END IF
    ELSE
       IF g_tsk.tsk05<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_tsk.tsk05 = '2' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsk.tsk05 = '3' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsk.tsk05 = '4' THEN CALL cl_err('','afa-916',0) RETURN END IF

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t254_cl USING g_tsk.tsk01
   IF STATUS THEN
      CALL cl_err("OPEN t254_cl:", STATUS, 1)
      CLOSE t254_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t254_cl INTO g_tsk.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsk.tsk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t254_cl ROLLBACK WORK RETURN
   END IF
   #FUN-D20039 --------sta
   IF g_tsk.tsk05 = 1 THEN
      LET l_c = 'N'
   ELSE
      LET l_c = 'Y'
   END IF
   #FUN-D20039 ---------end
   #IF cl_void(0,0,g_tsk.tsk05)   THEN  #FUN-D20039 mark
    IF cl_void(0,0,l_c) THEN            #FUN-D20039 add
        LET l_chr=g_tsk.tsk05
        IF g_tsk.tsk05='1' THEN 
            LET g_tsk.tsk05='X' 
        ELSE
            LET g_tsk.tsk05='1'
        END IF
        UPDATE tsk_file
            SET tsk05=g_tsk.tsk05,  
                tskmodu=g_user,
                tskdate=g_today
            WHERE tsk01=g_tsk.tsk01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tsk_file",g_tsk.tsk01,"",SQLCA.sqlcode,"","",1)  
            LET g_tsk.tsk05=l_chr 
        END IF
        DISPLAY BY NAME g_tsk.tsk05
   END IF
 
   CLOSE t254_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tsk.tsk01,'V')
 
END FUNCTION
#CHI-C80041---end
#FUN-D10081---add---str---
FUNCTION t254_list_fill()
  DEFINE l_tsk01         LIKE tsk_file.tsk01
  DEFINE l_i             LIKE type_file.num10

    CALL g_tsk_l.clear()
    LET l_i = 1
    FOREACH t254_fill_cs INTO l_tsk01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT tsk01,tsk02,tsk18,tsk19,tsk08,gen02,tsk09,gem02,
              tsk05,tskconu,'',tskcond,tskcont,tsk06,tsk03,azp02,
              tsk17,imd02,tsk20,tsk21,tsk22,tsk10
         INTO g_tsk_l[l_i].*
         FROM tsk_file
              LEFT OUTER JOIN gem_file ON gem01 = tsk09
              LEFT OUTER JOIN gen_file ON gen01 = tsk08
              LEFT OUTER JOIN azp_file ON azp01 = tsk03
              LEFT OUTER JOIN imd_file ON imd01 = tsk17
        WHERE tsk01=l_tsk01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b4 = l_i - 1
    DISPLAY ARRAY g_tsk_l TO s_tsk_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
END FUNCTION

FUNCTION t254_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_tsk_l TO s_tsk_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
          CALL fgl_set_arr_curr(g_curs_index)
          CALL cl_navigator_setting( g_curs_index, g_row_count )
       BEFORE ROW
          LET l_ac4 = ARR_CURR()
          LET g_curs_index = l_ac4
          CALL cl_show_fld_cont()

      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET g_no_ask = TRUE
         IF g_rec_b4 > 0 THEN
             CALL t254_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", TRUE)          
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET g_no_ask = TRUE
         CALL t254_fetch('/')  
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_main", TRUE)    
         EXIT DISPLAY

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
         CALL t254_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                           #TQC-D10084---add---

      ON ACTION previous
         CALL t254_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                           #TQC-D10084---add---

      ON ACTION jump
         CALL t254_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                           #TQC-D10084---add---

      ON ACTION next
         CALL t254_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                           #TQC-D10084---add---

      ON ACTION last
         CALL t254_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                           #TQC-D10084---add---

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      #TQC-D10084---mark---str---
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
      #TQC-D10084---mark---end---

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL t254_field_pic()
         CALL cl_show_fld_cont()
         CALL t254_def_form()
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      #@ON ACTION 審核
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      #@ON ACTION 取消審核
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY

      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
  
      #FUN-D20039 ----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ----------end

      ON ACTION triangletrade
         LET g_action_choice="triangletrade"
         EXIT DISPLAY

      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY

      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY

      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION CONTROLS
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document                
         LET g_action_choice="related_document"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION 
#FUN-D10081---add---end---
