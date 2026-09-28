# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: apmp520.4gl
# Descriptions...: 请购转入采购整批处理作业
# Date & Author..: No.FUN-C50082 12/06/18 By suncx
# Modify.........: No.TQC-C90106 12/09/27 By dongsz 1.修改CONSTRUCT字段順序 2.查詢點退出時，return返回  3.請購單位欄位增加開窗
# Modify.........: No.TQC-C90115 12/09/27 By dongsz 1.查詢不到資料時，增加警告提示  2.採購員欄位做有效性檢查
#                                                   3.調整畫面欄位   4.FOREACH 抓取錯誤項次并顯示所有符合條件的項次
# Modify.........: No.TQC-C90114 12/09/28 By yuhuabao 1.pnn35報錯后還原舊值
#                                                     2.如果取價類型、經營方式為空,則給默認值'4',其它,經營方式默認給'1'
#                                                     3.請購單上有維護收貨部門、運送方式、代理商欄位,轉出採購單后轉出採購單后,採購單未寫入
#                                                     4.若請購單也維護了廠牌，應優先從採購單抓取，抓不到再抓取準料件/供貨數據廠牌
#                                                     5.FUNCTION p520_price_check()中抓取價格條件,應先從採購單抓取,抓不到再從供貨商數據中抓取應跟作業整體的處理方式一致
# Modify.........: No.TQC-C90126 12/09/28 By yuhuabao 1.會反復提示 是否為建議數量
#                                                     2.採購數量與請購數量差異為10%的時候,分配量設置差額大於或者小於10%仍然可以生成採購單
# Modify.........: No.MOD-CB0208 12/11/21 By suncx 拋轉查詢時去掉按請購員排序
# Modify.........: No.TQC-CC0111 12/12/24 By suncx 如果抓不到分配比率>0的apmi254资料，就抓主供應商按100%分配率分配
# Modify.........: No:TQC-D40015 13/04/03 By Elise 調整s_sizechk傳入參數
# Modify.........: No:FUN-D40042 13/04/15 By fengrui 請購單轉採購時，請購單備註pml06帶入採購單備註pmn100
# Modify.........: No:TQC-D70014 13/07/01 By qirl 如果沒有勾選那個“選擇”，則點“轉出”按鈕的時候不要彈出那個框
# Modify.........: No:TQC-D70013 13/07/02 By lujh 查詢出資料後，點擊單身回車到pnn18和pnn19欄位時無法跳出，一直在這兩個欄位來回跳轉
# Modify.........: No:MOD-D50250 13/07/15 By SunLM 1.相同料号多个项次只能带出一个;2.当供应商取价方式不能为零单价时进行管控
# Modify.........: No:16/05/25 16/05/25 By guanyao 1.查询时，加筛选条件：料件对应采购员 like %g_user%;2.料件未维护主要供应商时，查询不要报错.
# Modify.........: No:181208     18/12/08 By pulf 修正更改厂商后的金额问题

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_pml           RECORD LIKE pml_file.*,
    g_pml_t         RECORD LIKE pml_file.*,
    g_pnn2          RECORD LIKE pnn_file.*,
    g_poz           RECORD LIKE poz_file.*,
    g_poy           RECORD LIKE poy_file.*,
    l_pnn_o         RECORD LIKE pnn_file.*,
    g_pmc47_o       LIKE pmc_file.pmc47,
    g_seq           LIKE type_file.num5,
    g_pnn01         LIKE pnn_file.pnn01,
    g_pnn02         LIKE pnn_file.pnn02,
    g_pnn17         LIKE pnn_file.pnn17,
    g_pnn20         LIKE pnn_file.pnn20,
    g_pnn DYNAMIC ARRAY OF RECORD
                select      LIKE type_file.chr1,
                pml01       LIKE pml_file.pml01,
                pml02       LIKE pml_file.pml02,
                pmk04       LIKE pmk_file.pmk04,
                pmk12       LIKE pmk_file.pmk12,
                gen02a      LIKE gen_file.gen02,
                pmk13       LIKE pmk_file.pmk13,
                gem02       LIKE gem_file.gem02,
                pml24       LIKE pml_file.pml24,
                pml25       LIKE pml_file.pml25,
                pml06       LIKE pml_file.pml06,
                pml04       LIKE pml_file.pml04,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021,
                ima06       LIKE ima_file.ima06,
                imz02       LIKE imz_file.imz02,
                ima08       LIKE ima_file.ima08,
                pml07       LIKE pml_file.pml07,
                pml33       LIKE pml_file.pml33,
                pml12       LIKE pml_file.pml12,
                pml121      LIKE pml_file.pml121,
                pnn15       LIKE pnn_file.pnn15,
                pmn04       LIKE pmn_file.pmn04,
                ima54       LIKE ima_file.ima54,
                pmc03       LIKE pmc_file.pmc03,
                pnn06       LIKE pnn_file.pnn06,
                pmc47       LIKE pmc_file.pmc47,
                gec04       LIKE gec_file.gec04,
                pmk02       LIKE pmk_file.pmk02,
                pnn13       LIKE pnn_file.pnn13,
                att00       LIKE imx_file.imx00,
                att01       VARCHAR(10),
                att01_c     VARCHAR(10),
                att02       VARCHAR(10),
                att02_c     VARCHAR(10),
                att03       VARCHAR(10),
                att03_c     VARCHAR(10),
                att04       VARCHAR(10),
                att04_c     VARCHAR(10),
                att05       VARCHAR(10),
                att05_c     VARCHAR(10),
                att06       VARCHAR(10),
                att06_c     VARCHAR(10),
                att07       VARCHAR(10),
                att07_c     VARCHAR(10),
                att08       VARCHAR(10),
                att08_c     VARCHAR(10),
                att09       VARCHAR(10),
                att09_c     VARCHAR(10),
                att10       VARCHAR(10),
                att10_c     VARCHAR(10),
                ima43       LIKE ima_file.ima43,
                gen02       LIKE gen_file.gen02,
                gen03       LIKE gen_file.gen03,
                pml20       LIKE pml_file.pml20,
                ima46       LIKE ima_file.ima46,
                ima45       LIKE ima_file.ima45,
                pml21       LIKE pml_file.pml21,
                diff        LIKE pml_file.pml20,
                pnn07       LIKE pnn_file.pnn07,
                pnn08       LIKE pnn_file.pnn08,
                pnn09       LIKE pnn_file.pnn09,
                pnn33       LIKE pnn_file.pnn33,
                pnn34       LIKE pnn_file.pnn34,
                pnn35       LIKE pnn_file.pnn35,
                pnn30       LIKE pnn_file.pnn30,
                pnn31       LIKE pnn_file.pnn31,
                pnn32       LIKE pnn_file.pnn32,
                pnn36       LIKE pnn_file.pnn36,
                pnn37       LIKE pnn_file.pnn37,
                pnn10       LIKE pnn_file.pnn10,
                pnn10t      LIKE pnn_file.pnn10t,
                pnn38       LIKE pnn_file.pnn38,
                pnn38t      LIKE pnn_file.pnn38t,
                pnn12       LIKE pnn_file.pnn12,
                pnn11       LIKE pnn_file.pnn11,
                pnn18       LIKE pnn_file.pnn18,
                pnn19       LIKE pnn_file.pnn19,
                pnn16       LIKE pnn_file.pnn16
            END RECORD,
    g_pnn_t RECORD
                select      LIKE type_file.chr1,
                pml01       LIKE pml_file.pml01,
                pml02       LIKE pml_file.pml02,
                pmk04       LIKE pmk_file.pmk04,
                pmk12       LIKE pmk_file.pmk12,
                gen02a      LIKE gen_file.gen02,
                pmk13       LIKE pmk_file.pmk13,
                gem02       LIKE gem_file.gem02,
                pml24       LIKE pml_file.pml24,
                pml25       LIKE pml_file.pml25,
                pml06       LIKE pml_file.pml06,
                pml04       LIKE pml_file.pml04,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021,
                ima06       LIKE ima_file.ima06,
                imz02       LIKE imz_file.imz02,
                ima08       LIKE ima_file.ima08,
                pml07       LIKE pml_file.pml07,
                pml33       LIKE pml_file.pml33,
                pml12       LIKE pml_file.pml12,
                pml121      LIKE pml_file.pml121,
                pnn15       LIKE pnn_file.pnn15,
                pmn04       LIKE pmn_file.pmn04,
                ima54       LIKE ima_file.ima54,
                pmc03       LIKE pmc_file.pmc03,
                pnn06       LIKE pnn_file.pnn06,
                pmc47       LIKE pmc_file.pmc47,
                gec04       LIKE gec_file.gec04,
                pmk02       LIKE pmk_file.pmk02,
                pnn13       LIKE pnn_file.pnn13,
                att00       LIKE imx_file.imx00,
                att01       VARCHAR(10),
                att01_c     VARCHAR(10),
                att02       VARCHAR(10),
                att02_c     VARCHAR(10),
                att03       VARCHAR(10),
                att03_c     VARCHAR(10),
                att04       VARCHAR(10),
                att04_c     VARCHAR(10),
                att05       VARCHAR(10),
                att05_c     VARCHAR(10),
                att06       VARCHAR(10),
                att06_c     VARCHAR(10),
                att07       VARCHAR(10),
                att07_c     VARCHAR(10),
                att08       VARCHAR(10),
                att08_c     VARCHAR(10),
                att09       VARCHAR(10),
                att09_c     VARCHAR(10),
                att10       VARCHAR(10),
                att10_c     VARCHAR(10),
                ima43       LIKE ima_file.ima43,
                gen02       LIKE gen_file.gen02,
                gen03       LIKE gen_file.gen03,
                pml20       LIKE pml_file.pml20,
                ima46       LIKE ima_file.ima46,
                ima45       LIKE ima_file.ima45,
                pml21       LIKE pml_file.pml21,
                diff        LIKE pml_file.pml20,
                pnn07       LIKE pnn_file.pnn07,
                pnn08       LIKE pnn_file.pnn08,
                pnn09       LIKE pnn_file.pnn09,
                pnn33       LIKE pnn_file.pnn33,
                pnn34       LIKE pnn_file.pnn34,
                pnn35       LIKE pnn_file.pnn35,
                pnn30       LIKE pnn_file.pnn30,
                pnn31       LIKE pnn_file.pnn31,
                pnn32       LIKE pnn_file.pnn32,
                pnn36       LIKE pnn_file.pnn36,
                pnn37       LIKE pnn_file.pnn37,
                pnn10       LIKE pnn_file.pnn10,
                pnn10t      LIKE pnn_file.pnn10t,
                pnn38       LIKE pnn_file.pnn38,
                pnn38t      LIKE pnn_file.pnn38t,
                pnn12       LIKE pnn_file.pnn12,
                pnn11       LIKE pnn_file.pnn11,
                pnn18       LIKE pnn_file.pnn18,
                pnn19       LIKE pnn_file.pnn19,
                pnn16       LIKE pnn_file.pnn16
            END RECORD,
    tm  RECORD				            # Print condition RECORD
          wc   STRING,                  # Where Condition
          wc2  STRING,                  # Where Condition
          pmk02     LIKE pmk_file.pmk02,
          desc      VARCHAR(10),
          purpeo    LIKE ima_file.ima43,
          deldate   DATE,
          a         VARCHAR(01),
          d         VARCHAR(01),
          pmc01     LIKE pmc_file.pmc01,
          pmc03     LIKE pmc_file.pmc03
       END RECORD,
    tm3 RECORD				            # Print condition RECORD
          wc   STRING,                  # Where Condition
          wc2  STRING,                  # Where Condition
          type      VARCHAR(03),
          slip      VARCHAR(05),
          purdate   DATE,
          pmm12     LIKE pmm_file.pmm12,
          pmm02     LIKE pmm_file.pmm02,
          pmm13     LIKE pmm_file.pmm13
       END RECORD,
    tm4 RECORD
          wc   STRING
        END RECORD,
       g_img09         LIKE img_file.img09,
       g_ima25         LIKE ima_file.ima25,
       g_ima31         LIKE ima_file.ima31,
       g_ima44         LIKE ima_file.ima44,
       g_ima906        LIKE ima_file.ima906,
       g_ima907        LIKE ima_file.ima907,
       g_ima908        LIKE ima_file.ima908,
       g_tot           LIKE img_file.img10,
       g_factor        LIKE pnn_file.pnn17,
       g_qty           LIKE img_file.img10,
       g_flag          VARCHAR(01),
       g_buf           LIKE gfe_file.gfe02,
       g_pnn38         LIKE pnn_file.pnn38,
       g_pnn38t        LIKE pnn_file.pnn38t,
       g_pom           RECORD LIKE pom_file.*,
       g_pon           RECORD LIKE pon_file.*,
       g_pnn03_sub     LIKE pnn_file.pnn03,
       g_pnn08_sub     LIKE pnn_file.pnn08,
       g_t1            VARCHAR(5),
       g_t2            VARCHAR(6),
       g_exit          VARCHAR(01),
       g_cmd           VARCHAR(200),
       g_pnn15         LIKE pnn_file.pnn15,
       g_bno,g_eno     LIKE pmk_file.pmk01,
       g_po,g_auno     VARCHAR(01),
       g_pmm           RECORD LIKE  pmm_file.*,
       g_pmn           RECORD LIKE  pmn_file.*,
       g_buf1          VARCHAR(30),
       g_buf2          VARCHAR(01),
       g_gec07         LIKE gec_file.gec07,
       g_wc,g_wc2,g_sql STRING,
       g_rec_b         LIKE type_file.num5,
       l_ac            LIKE type_file.num5,
       p_row,p_col     LIKE type_file.num5,
       g_char          VARCHAR(100),
       g_wc_count,g_wc2_count    STRING

DEFINE   arr_detail    DYNAMIC ARRAY OF RECORD
         imx00         LIKE imx_file.imx00,
         imx           ARRAY[10] OF LIKE imx_file.imx01
         END RECORD
DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE   lg_smy62      LIKE smy_file.smy62
DEFINE   lg_group      LIKE smy_file.smy62
DEFINE   g_term     LIKE pmk_file.pmk41
DEFINE   g_price    LIKE pmk_file.pmk20
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           INTEGER
DEFINE g_msg           STRING
DEFINE g_msg2          STRING
DEFINE g_row_count     INTEGER
DEFINE g_curs_index    INTEGER
DEFINE g_jump          INTEGER
DEFINE mi_no_ask       LIKE type_file.num5,
       g_i         LIKE type_file.num5,
       g_gaq03_f1  LIKE gaq_file.gaq03,
       g_gaq03_f2  LIKE gaq_file.gaq03,
       g_gaq03_f3  LIKE gaq_file.gaq03
DEFINE g_ima43     LIKE ima_file.ima43
DEFINE g_pmk12     LIKE pmk_file.pmk12
DEFINE g_ll        LIKE type_file.num5
DEFINE g_fag_a     LIKE type_file.num5
DEFINE g_flag_b    STRING

DEFINE g_pmk12_a   LIKE pmk_file.pmk12
DEFINE g_pmk12_t   LIKE pmk_file.pmk12
DEFINE g_pmk13_a   LIKE pmk_file.pmk13
DEFINE g_pnz08     LIKE pnz_file.pnz08

MAIN
DEFINE i          LIKE type_file.num5
DEFINE j          LIKE type_file.num5
    OPTIONS
        INPUT NO WRAP,        #TQC-C90126 add ,
        FIELD ORDER FORM      #TQC-C90126 add
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   DROP TABLE p520_tmp
   CREATE TEMP TABLE p520_tmp(
   choice    LIKE type_file.chr1,
   supr      LIKE type_file.chr10,
   curr      LIKE type_file.chr4,
   price     LIKE type_file.num20_6,
   price_t   LIKE type_file.num20_6,
   rate      dec(8,4))

   DROP TABLE p520_tmp2
   CREATE TEMP TABLE p520_tmp2
   (pmm01   LIKE pmm_file.pmm01)

   DROP TABLE p520_tmp3
   CREATE TEMP TABLE p520_tmp3
      (pnn01   LIKE pnn_file.pnn01,
       pnn02   LIKE pnn_file.pnn02,
       pnn38   LIKE pnn_file.pnn38,
       pnn38t  LIKE pnn_file.pnn38t,
       pmc47   LIKE pmc_file.pmc47)

   LET p_row = 2 LET p_col = 2

   OPEN WINDOW p520_w AT p_row,p_col WITH FORM "apm/42f/apmp520"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   LET lg_smy62 = ''
   LET lg_group = ''
   CALL p520_refresh_detail()

   CALL cl_ui_init()

   CALL p520_def_form()

   CALL p520_menu()

   LET i = g_pnn.getlength()
   FOR j = 1 TO i
      DELETE FROM pnn_file
       WHERE pnn01 = g_pnn[j].pml01
         AND pnn02 = g_pnn[j].pml02
   END FOR
   CLOSE WINDOW p520_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p520_menu()
DEFINE i   LIKE type_file.num5
DEFINE l_n LIKE type_file.num5

   WHILE TRUE
      CALL p520_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p520_q('g')
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p520_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "transfer_out"
            IF cl_chk_act_auth() THEN
#              CALL p520_t()  #----TQC-D70014-mark---
#----TQC-D70014---add--star---
              LET l_n=0
              FOR i=1 TO g_rec_b
                  IF g_pnn[i].select = 'Y' THEN
                     CALL p520_t()
                     LET l_n=l_n + 1
                  END IF
              END FOR
              IF l_n=0  THEN
                 CALL cl_err('','anm-803',1)
              END IF
#---TQC-D70014---add---end--
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pnn),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION p520_q(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1

   CALL p520_b_askkey(p_cmd)
END FUNCTION

FUNCTION p520_b_askkey(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1
   DEFINE l_show_msg DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    pnn01       LIKE pnn_file.pnn01,   #廠商編號
                    pnn02       LIKE pnn_file.pnn02,   #料件編號
                    pnn05       LIKE pnn_file.pnn05    #廠商編號
                 END RECORD,
          l_name    LIKE type_file.chr20,
          l_sma46   LIKE sma_file.sma46,
          l_pnn03   LIKE pnn_file.pnn03,
          l_cnt_tot,l_tot,l_tot_1 LIKE pmh_file.pmh11,
          l_qty_tot LIKE pml_file.pml20,
          l_ima915  LIKE ima_file.ima915,
          l_n1      LIKE type_file.num5,
          l_count1  LIKE type_file.num5,
          l_count2  LIKE type_file.num5,   #TQC-CC0111
          l_str     LIKE pnn_file.pnn03
   DEFINE l_sql  STRING
   DEFINE l_wc2  STRING
   DEFINE l_pml80         LIKE pml_file.pml80,
          l_pml02         LIKE pml_file.pml02,           #TQC-C90115 add
          l_pml81         LIKE pml_file.pml81,
          l_pml82         LIKE pml_file.pml82,
          l_pml83         LIKE pml_file.pml83,
          l_pml84         LIKE pml_file.pml84,
          l_pml85         LIKE pml_file.pml85,
          l_pml86         LIKE pml_file.pml86,
          l_pml87         LIKE pml_file.pml87,
          l_gec04         LIKE gec_file.gec04,
          l_pmh02         LIKE pmh_file.pmh02,
          l_pmh11         LIKE pmh_file.pmh11,
          l_pmh12         LIKE pmh_file.pmh12,
          l_pmh13         LIKE pmh_file.pmh13,
          l_pml34         LIKE pml_file.pml34,
          l_pml07         LIKE pml_file.pml07,
          l_ima44         LIKE ima_file.ima44,
          l_ima54         LIKE ima_file.ima54,
          l_pml20         LIKE pml_file.pml20,
          l_ima021        LIKE ima_file.ima021,
          l_pml21         LIKE pml_file.pml121,
          l_pmk22         LIKE pmk_file.pmk22,
          l_pmc49,l_pmc17 LIKE pmc_file.pmc49
   DEFINE l_pnn   RECORD LIKE pnn_file.*
   DEFINE l_pmk   RECORD LIKE pmk_file.*
   DEFINE l_flag          LIKE type_file.num5
   DEFINE l_num           LIKE type_file.num5
   DEFINE l_pnn01   LIKE pnn_file.pnn01,
          l_pnn02   LIKE pnn_file.pnn02,
          l_pnn09   LIKE pnn_file.pnn09,
          l_pml16   LIKE pml_file.pml16,
          l_sw      LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_n2      LIKE type_file.num5,           #TQC-C90115 add
	      l_cnt       LIKE type_file.num5,
          l_fa      LIKE pnn_file.pnn17

   DEFINE i LIKE type_file.num5
   DEFINE j LIKE type_file.num5

   DEFINE l_pmc47_b  LIKE pmc_file.pmc47
   DEFINE l_gec04_b  LIKE gec_file.gec02
   DEFINE l_pmcacti  LIKE pmc_file.pmcacti   #TQC-CC0111

   LET i = g_pnn.getlength()
   FOR j = 1 TO i
      DELETE FROM pnn_file
       WHERE pnn01 = g_pnn[j].pml01
         AND pnn02 = g_pnn[j].pml02
   END FOR

   CLEAR FORM
   CALL g_pnn.clear()     #TQC-C90106 add

   LET g_pmk12 = NULL

   CALL cl_set_comp_entry("ima43",TRUE)

  #TQC-C90106 mark str---
  #CONSTRUCT BY NAME tm4.wc ON pml01,pmk04,pmk12,pmk13,pml02,pml24,pml25,
  #                            ima02,pml04,pml07,pml20,pml33,pml12,pml121,
  #                            ima54,pnn15,ima06
  #TQC-C90106 mark end---
  #TQC-C90106 add str---
   CONSTRUCT BY NAME tm4.wc ON pml01,pml02,pmk04,pmk12,pmk13,pml24,pml25,
                               pml04,ima02,ima06,pml07,pml33,pml12,pml121,
                               pnn15,ima54,pml20
  #TQC-C90106 add end---
     #ON ACTION controlp             #TQC-C90106 mark
      ON ACTION CONTROLP             #TQC-C90106 add
         CASE
            WHEN INFIELD(pml01)
               CALL cl_init_qry_var()
               #LET g_qryparam.form     = "q_pmk01"     #mark by jixf 160804
               LET g_qryparam.form     = "cq_pmk01"     #add by jixf 160804
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml01
               NEXT FIELD pml01
            WHEN INFIELD(pml04)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml04
               NEXT FIELD pml04
            WHEN INFIELD(pnn15)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pnn15
               NEXT FIELD pnn15
            WHEN INFIELD(ima54)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_pmc"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima54
               NEXT FIELD ima54
            WHEN INFIELD(ima06)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_imz"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            WHEN INFIELD(pml12)  #專案代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pja2"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml12
               NEXT FIELD pml12
            WHEN INFIELD(pml121) #WBS
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pjb4"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml121
               NEXT FIELD pml121
            WHEN INFIELD(pmk12) #請購員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmk12
               NEXT FIELD pmk12
            WHEN INFIELD(pmk13) #請購Dept
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmk13
               NEXT FIELD pmk13
           #TQC-C90106 add str---
            WHEN INFIELD(pml07) #請購單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml07
               NEXT FIELD pml07
           #TQC-C90106 add end---
            OTHERWISE
               EXIT CASE
         END CASE

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END CONSTRUCT

   IF INT_FLAG THEN
       LET tm4.wc = ' 1=0 '
       LET INT_FLAG = 0
       RETURN                  #TQC-C90106 add
   END IF

   IF cl_null(l_wc2) THEN
      LET l_wc2 = '1=1'
   END IF
   IF cl_null(tm4.wc) THEN
      LET tm4.wc = ' 1=1 '
   END IF

   LET l_sql = "SELECT pml01,pml02,pml04,pml42,(pml20-pml21), ",
               "  pml80,pml81,pml82,pml83,pml84,pml85,pml86,pml87, ",
               "  pml34,ima44,ima54,pml07,pml919,ima021,pml21 ",
               "  FROM pmk_file,pml_file,ima_file",
               "  WHERE pmk01= pml01 ",
               "   AND pmk18 = 'Y'",     #MOD-5B0332 add
               "   AND pml92 <> 'Y' ",    #FUN-A10034
               "   AND pml04 = ima01 ",
               "   AND pml20 > pml21 ",
               "   AND pml16 IN ('1','2') ",
               "   AND pml190 = 'N'",   #No.FUN-630040
              -- "   AND ima43 LIKE '%",g_user CLIPPED,"%' ",  #add by donghy 按照采购员分类
               "   AND (ima43 LIKE '%",g_user CLIPPED,"%' ",  #add by donghy 按照采购员分类 或空
               "  or ima43='' or ima43 is null)",
               "   AND pml02 NOT IN (SELECT pnn02 FROM pnn_file",
               "                      WHERE pnn01 = pml01      ",
               "                        AND pnn02 = pml02)     ",
               "   AND ",tm4.wc
   PREPARE p520_prepare2 FROM l_sql
   DECLARE pml_curs2  CURSOR FOR p520_prepare2

   #-->廠商分配資料
   LET l_sql = "SELECT pmh02,pmh11,pmh12,pmh13",
               "  FROM pmh_file ",
               " WHERE pmh01 = ? ",
               "   AND pmh05 = '0' ",    #已核准
               "   AND pmh21 = ' ' ",                                           #CHI-860042
               "   AND pmh22 = '1' ",                                           #CHI-860042
               "   AND pmh23 = ' '",                             #No.CHI-960033
               "   AND pmhacti = 'Y'",                                          #CHI-910021
               "   AND pmh02 IN (SELECT pmc01 FROM pmc_file ",   #MOD-930224
               " WHERE pmcacti = 'Y')",
               "   AND pmh11 > 0 "

   LET l_sql = l_sql CLIPPED," ORDER BY pmh02,pmh13 "
   PREPARE p520_pvender FROM l_sql
   DECLARE vender_c  CURSOR FOR p520_pvender
   #-->總分配率
   LET l_sql = "SELECT SUM(pmh11) FROM pmh_file ",
               " WHERE pmh01= ? ",
               "   AND pmh05 = '0' ",   #已核准
               "   AND pmh21 = ' ' ",                                           #CHI-860042
               "   AND pmh22 = '1' ",                                           #CHI-860042
               "   AND pmh23 = ' '",                             #No.CHI-960033
               "   AND pmhacti = 'Y'",                                          #CHI-910021
               "   AND pmh02 IN (SELECT pmc01 FROM pmc_file ",   #MOD-930224
               "   WHERE pmcacti = 'Y')"   #MOD-930224

   PREPARE p520_psum FROM l_sql
   DECLARE sum_cur   CURSOR FOR p520_psum

   LET l_sql = "SELECT SUM(pmh11) FROM pmh_file ",
               " WHERE pmh01= ? ",
               "   AND pmh05 = '0' ",   #已核准
               "   AND pmh21 = ' ' ",                                           #CHI-860042
               "   AND pmh22 = '1' ",                                           #CHI-860042
               "   AND pmh23 = ' '",                             #No.CHI-960033
               "   AND pmhacti = 'Y'"                                           #CHI-910021

   PREPARE p520_psum_1 FROM l_sql
   DECLARE sum_cur_1   CURSOR FOR p520_psum_1

   LET g_success = 'Y'
   LET g_exit = 'N'        #TQC-C90106 modify Y->N
   LET g_i = 1             #FUN-590130 add
   CALL l_show_msg.clear() #FUN-590130 add

   CALL cl_outnam('apmp520') RETURNING l_name

   BEGIN WORK   #MOD-9B0041
   START REPORT p520_rep TO l_name

   CALL s_showmsg_init()        #No.FUN-710030
   LET l_n2 = 0                 #TQC-C90115 add
   FOREACH pml_curs2 INTO l_pnn.pnn01,l_pnn.pnn02,l_pnn.pnn03,
                          l_pnn.pnn13,l_pml20,
                          l_pml80,l_pml81,l_pml82,l_pml83,l_pml84,
                          l_pml85,l_pml86,l_pml87,l_pml34,
                          l_ima44,l_ima54,l_pml07,l_pnn.pnn919,l_ima021,l_pml21
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","pml_curs2",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","pml_curs2",0)
         END IF
         LET g_success = 'N'  #No.FUN-8A0086
         EXIT FOREACH
      END IF
      #請購-已轉採購量須大於0
      IF l_pml20 <= 0 THEN CONTINUE FOREACH END IF
      LET g_exit = 'N'
      #-->總分配率
      OPEN sum_cur USING l_pnn.pnn03
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","open sum_cur",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","open sum_cur",0)
         END IF
      END IF
      SELECT sma46 INTO l_sma46 FROM sma_file
         FOR i=1 TO length(l_pnn.pnn03)
            IF l_pnn.pnn03[i,i] = l_sma46 THEN
               LET l_pnn03 = l_pnn.pnn03[1,i-1]
               EXIT FOR
            END IF
         END FOR
      OPEN sum_cur_1 USING l_pnn03        #No.FUN-8A0129
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","open sum_cur_1",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","open sum_cur_1",0)
         END IF
      END IF
      FETCH sum_cur INTO l_tot
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","sum_cur",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","sum_cur",1)
         END IF
      END IF
      FETCH sum_cur_1 INTO l_tot_1    #No.FUN-8A0129
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","sum_cur_1",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","sum_cur_1",1)
         END IF
      END IF
      CLOSE sum_cur
      CLOSE sum_cur_1      #No.FUN-8A0129
      #TQC-CC0111 mark begin-------------------------------
      #IF cl_null(l_tot) AND cl_null(l_tot_1) THEN
      #    #此料件的料件/供應商資料未建立(apmi254)!
      #   IF g_bgerr THEN
      #      LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03   #FUN-9B0085
      #      CALL s_errmsg("pnn01,pnn02,pnn03",g_showmsg,"","apm-572",1)   #FUN-9B0085
      #   ELSE
      #      CALL cl_err3("","","","","apm-572","",l_pnn.pnn03,1)
      #   END IF
      #   IF l_pnn.pnn02 IS NOT NULL THEN CONTINUE FOREACH END IF           #TQC-C90115 add
      #   CALL s_showmsg()      #No.TQC-7C0168
      #   CALL cl_rbmsg(1)
      #   ROLLBACK WORK
      #END IF
      #TQC-CC0111 mark end---------------------------------
      LET l_cnt_tot = 0
      LET l_qty_tot = 0
      DELETE FROM p520_tmp
      #TQC-CC0111 mark begin-------------------------------
      #SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=l_pnn.pnn03
      #IF l_ima915='2' OR l_ima915='3' THEN
      #    SELECT COUNT(*) INTO l_n
      #      FROM pmh_file
      #     WHERE pmh01 = l_pnn.pnn03
      #       AND pmh05 = '0'
      #       AND pmh21 = " "                                             #CHI-860042
      #       AND pmh22 = '1'                                             #CHI-860042
      #       AND pmh23 = ' '                                             #CHI-960033
      #       AND pmhacti = 'Y'                                           #CHI-910021
      #    SELECT COUNT(*) INTO l_n1
      #      FROM pmh_file
      #     WHERE pmh01 = l_pnn03
      #       AND pmh05 = '0'
      #       AND pmh21 = " "                                             #CHI-860042
      #       AND pmh22 = '1'                                             #CHI-860042
      #       AND pmh23 = ' '                                             #CHI-960033
      #       AND pmhacti = 'Y'                                           #CHI-910021
      #    IF STATUS OR SQLCA.sqlcode OR (l_n <=0 AND l_n1 <=0) THEN      #No.FUN-8A0129 add l_n1
      #        LET g_exit = 'Y'
      #       #此料件的料件/供應商資料未建立(apmi254)!
      #       IF g_bgerr THEN
      #          LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03   #FUN-9B0085
      #          CALL s_errmsg("pnn01,pnn02,pnn03",g_showmsg,"","apm-572",1)   #FUN-9B0085
      #       ELSE
      #          CALL cl_err3("","","","","apm-572","",l_pnn.pnn03,1)
      #       END IF
      #    END IF
      #END IF
      #TQC-CC0111 mark end---------------------------------
     #在apmt420中沒有這個明細料號資料則抓款式的資料
      SELECT COUNT(*) INTO l_count1 FROM pmh_file
       WHERE pmh01= l_pnn.pnn03
         AND pmh05 = '0' AND pmh21 = ' ' AND pmh22 = '1' AND pmh11 > 0
         AND pmh23 = ' ' AND pmhacti = 'Y'                                           #CHI-910021
       ORDER BY pmh02,pmh13

     IF l_count1 <= 0 THEN
        LET l_str = l_pnn03
     ELSE
        LET l_str = l_pnn.pnn03
     END IF

#TQC-CC0111 add begin---------------------------------------------------------
     SELECT COUNT(*) INTO l_count2 FROM pmh_file
      WHERE pmh01= l_pnn03
        AND pmh05 = '0' AND pmh21 = ' ' AND pmh22 = '1' AND pmh11 > 0
        AND pmh23 = ' ' AND pmhacti = 'Y'
      ORDER BY pmh02,pmh13

     IF l_count1 <= 0 AND l_count2 <= 0 THEN
        LET l_pnn.pnn05 = l_ima54
        #主要供應廠商未輸入,請至料件基本資料維護-採購資料(aimi103)輸入!
        IF cl_null(l_pnn.pnn05) THEN
#str----mark by guanyao160525
            #IF g_bgerr THEN
            #    LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03
            #    CALL s_errmsg("pnn01,pnn02,pnn03",g_showmsg,"","apm-571",1)
            #    CONTINUE FOREACH
            #ELSE
            #    CALL cl_err3("","","","","apm-571","",l_pnn.pnn03,1)
            #    CONTINUE FOREACH
            #END IF
#end----mark by guanyao160525
        END IF

        LET l_pmcacti=''
        SELECT pmcacti INTO l_pmcacti FROM pmc_file
          WHERE pmc01=l_pnn.pnn05
        IF l_pmcacti MATCHES '[PHN]' THEN
           IF g_bgerr THEN
              LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03,"/",l_pnn.pnn05
              CALL s_errmsg("pnn01,pnn02,pnn03,pnn05",g_showmsg,"","9038",1)
              CONTINUE FOREACH
           ELSE
              CALL cl_err(l_pnn.pnn05,"9038",1)
              CONTINUE FOREACH
           END IF
        END IF

        LET l_pnn.pnn09 = l_pml20
        IF l_pnn.pnn09 <= 0 THEN LET g_success ='N' END IF
        LET g_exit = 'N'
        LET l_pnn.pnn07 = 100              #分配率
        LET l_pnn.pnn08 = 1                #單位替代量
        SELECT ima43 INTO l_pnn.pnn15 FROM ima_file
         WHERE ima01 = l_pnn.pnn03
        LET l_pnn.pnn30 = l_pml80
        LET l_pnn.pnn31 = l_pml81
        LET l_pnn.pnn33 = l_pml83
        LET l_pnn.pnn34 = l_pml84
        LET l_pnn.pnn36 = l_pml86
        LET l_pnn.pnn37 = l_pml87
        LET l_pnn.pnn32 = l_pml82
        LET l_pnn.pnn35 = l_pml85
        LET l_pnn.pnn32 = s_digqty(l_pnn.pnn32,l_pnn.pnn30)
        LET l_pnn.pnn35 = s_digqty(l_pnn.pnn35,l_pnn.pnn33)
        LET l_pnn.pnn37 = s_digqty(l_pnn.pnn37,l_pnn.pnn36)

        #IF cl_null(tm.deldate) THEN
             LET l_pnn.pnn11 = l_pml34     #到廠日期
        #ELSE LET l_pnn.pnn11 = tm.deldate  #到廠日期
        #END IF
        #若無指定幣別則 default 供應商的慣用幣別
           SELECT pmc22 INTO l_pmk22 FROM pmc_file
            WHERE pmc01=l_pnn.pnn05

        SELECT gec04 INTO l_gec04 FROM pmc_file,gec_file
         WHERE pmc01 = l_pnn.pnn05 AND gec01 = pmc47
           AND gec011 = '1'  #進項
        IF cl_null(l_gec04) THEN LET l_gec04 = 0 END IF

        LET l_pnn.pnn06 = l_pmk22   #先用原請購單幣別,如找不到時再用ima的
        #str---add by guanyao160525
        IF cl_null(l_pnn.pnn06) THEN
           LET l_pnn.pnn06 = ' '
        END IF
        #end---add by guanyao160525
        IF l_pnn.pnn13 IS NULL OR l_pnn.pnn13 = ' '
        THEN LET l_pnn.pnn13 = '0'
        END IF
        IF cl_null(l_pnn.pnn05) THEN LET l_pnn.pnn05=' ' END IF
        LET l_pnn.pnn12 = l_ima44
        #---增加單位換算(因要計算轉出量,故以請購->採購之換算率)
        CALL s_umfchk(l_pnn.pnn03,l_pml07,l_pnn.pnn12)
            RETURNING l_flag,l_pnn.pnn17
        IF l_flag THEN
          ###Modify:98/11/15 --------單位換算率抓到----#####
           IF g_bgerr THEN
              LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03,"/",l_pml07,l_pnn.pnn12   #FUN-9B0085
              CALL s_errmsg("pnn01,pnn02,pnn03,pml07,pnn12",g_showmsg,"","abm-731",1)   #FUN-9B0085
           ELSE
              CALL cl_err3("","","","","abm-731","","pml07/pnn12: ",1)
           END IF
          LET g_success ='N'
          LET l_pnn.pnn17=1
        END IF
        LET l_pnn.pnn09=l_pnn.pnn09*l_pnn.pnn17
        LET l_pnn.pnn09 = s_digqty(l_pnn.pnn09,l_pnn.pnn12) # darcy:2025/09/24 add

        #---存換算率以採購對請購之換算率
        CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pml07)
            RETURNING l_flag,l_pnn.pnn17
        IF l_flag THEN
          ### --------單位換算率抓到----#####
          IF g_bgerr THEN
             LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03,"/",l_pnn.pnn12,l_pml07   #FUN-9B0085
             CALL s_errmsg("pnn01,pnn02,pnn03,pnn12,pml07",g_showmsg,"","abm-731",1)   #FUN-9B0085
          ELSE
             CALL cl_err3("","","","","abm-731","","pnn12/pml07: ",1)
          END IF
          LET g_success ='N'
          LET l_pnn.pnn17=1
        END IF
        LET l_pnn.pnn16 = 'Y'              #修正否
        IF g_sma.sma116 MATCHES '[02]' THEN
           LET l_pnn.pnn36=l_pnn.pnn12
           LET l_pnn.pnn37=l_pnn.pnn09
        END IF
        IF l_pml21 > 0 THEN
           CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn30)
                RETURNING l_flag,g_factor
           IF l_flag THEN
               LET g_factor=1
           END IF
           LET l_pnn.pnn32 = l_pnn.pnn09 * g_factor
           LET l_pnn.pnn35 = 0
           CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn36)
                RETURNING l_flag,g_factor
           IF l_flag THEN
               LET g_factor=1
           END IF
           LET l_pnn.pnn37 = l_pnn.pnn09 * g_factor
        END IF
        SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pnn.pnn06
        SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = l_pnn.pnn01
        LET g_term = l_pmk.pmk41
        IF cl_null(g_term) THEN
          SELECT pmc49 INTO g_term
            FROM pmc_file
           WHERE pmc01 = l_pnn.pnn05
        END IF
        LET g_price = l_pmk.pmk20
        IF cl_null(g_price) THEN
          SELECT pmc17 INTO g_price
            FROM pmc_file
           WHERE pmc01 = l_pnn.pnn05
        END IF
      --   LET l_pnn.pnn36 = l_pml07  # darcy:2025/11/07 mark 不要取请购单位
        SELECT pmc47 INTO g_pmm.pmm21
          FROM pmc_file
          WHERE pmc01 =l_pnn.pnn05
        SELECT gec04 INTO g_pmm.pmm43
          FROM gec_file
         WHERE gec01 = g_pmm.pmm21
           AND gec011 = '1'  #進項
        CALL s_defprice_new(l_pnn.pnn03,l_pnn.pnn05,l_pnn.pnn06,g_today,l_pnn.pnn37,'',g_pmm.pmm21,g_pmm.pmm43,"1",l_pnn.pnn36,'',g_term,g_price,g_plant)
           RETURNING l_pnn.pnn10,l_pnn.pnn10t,
                     g_pmn.pmn73,g_pmn.pmn74
        CALL p520_price_check(l_pnn.pnn05,l_pnn.pnn10,l_pnn.pnn10t,g_term,l_pnn.pnn01,l_pnn.pnn02)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,1)
         END IF
        IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF
        LET l_pnn.pnn10 = cl_digcut(l_pnn.pnn10,t_azi03)
        LET l_pnn.pnn10t= cl_digcut(l_pnn.pnn10t,t_azi03)
        LET l_pnn.pnn38 = l_pnn.pnn10 * l_pnn.pnn37
        LET l_pnn.pnn38t = l_pnn.pnn10t * l_pnn.pnn37
        CALL cl_digcut(l_pnn.pnn38,t_azi03) RETURNING l_pnn.pnn38
        CALL cl_digcut(l_pnn.pnn38t,t_azi03) RETURNING l_pnn.pnn38t
        LET l_pnn.pnnplant = g_plant
        LET l_pnn.pnnlegal = g_legal
        INSERT INTO pnn_file VALUES(l_pnn.*)
        IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN
           LET g_success = 'N'
           IF g_bgerr THEN
              LET g_showmsg = l_pnn.pnn01,"/",l_pnn.pnn02,"/",l_pnn.pnn03,"/",l_pnn.pnn05,"/",l_pnn.pnn06
              CALL s_errmsg("pnn01,pnn02,pnn03,pnn05,pnn06",g_showmsg,"ins pnn #1",SQLCA.sqlcode,1)
              CONTINUE FOREACH
           ELSE
              CALL cl_err3("ins","pnn_file","l_pnn.pnn01","l_pnn.pnn02",SQLCA.sqlcode,"","ins pnn #1",0)
              EXIT FOREACH
           END IF
        END IF
        LET l_n2 = l_n2 + 1
     ELSE
#TQC-CC0111 add end------------------------------------------------
        FOREACH vender_c USING l_str
           INTO l_pmh02,l_pmh11,l_pmh12,l_pmh13
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                 CALL s_errmsg("","","vender_c",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.sqlcode,"","vender_c",0)
              END IF
              EXIT FOREACH
           END IF

           SELECT gec04 INTO l_gec04 FROM pmc_file,gec_file
            WHERE pmc01 = l_pmh02 AND gec01 = pmc47
              AND gec011 = '1'  #進項 TQC-B70212 add
           IF cl_null(l_gec04) THEN LET l_gec04 = 0 END IF

           IF cl_null(l_tot) THEN
              LET l_tot = l_tot_1
           END IF
           OUTPUT TO REPORT p520_rep(l_pmh02,l_pmh11,l_pmh12,l_pmh13,
                                     l_pnn.*,
                                     l_pml20,l_pml80,l_pml81,l_pml82,
                                     l_pml83,l_pml84,l_pml85,l_pml86,
                                     l_pml87,l_pml34,l_ima44,l_ima54,
                                     l_pml07,l_ima021,l_pml21,l_tot,l_gec04)  #No.FUN-550089
        LET l_n2 = l_n2 + 1          #TQC-C90115 add
        END FOREACH
     END IF   #TQC-CC0111 add
  END FOREACH
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF

  FINISH REPORT p520_rep
  IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009

  #-->無符合條件資料
  IF g_exit = 'Y' THEN
     CALL cl_err(l_pnn.pnn01,'mfg2601',1)
  END IF

  CALL s_showmsg()       #No.FUN-710030

 #TQC-C90115 add str---
  IF l_n2 = 0 THEN
     CALL cl_err('','100',1)
     CALL g_pnn.clear()
  END IF
 #TQC-C90115 add end---

  IF g_success = 'Y' THEN
     CALL cl_cmmsg(1)
     COMMIT WORK
  ELSE
     CALL cl_rbmsg(1)
     ROLLBACK WORK
  END IF
   CALL p520_b_fill(l_wc2)
END FUNCTION

FUNCTION p520_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_i,l_k         LIKE type_file.num5,
    l_modify_flag   LIKE type_file.chr1,
    l_lock_sw       LIKE type_file.chr1,
    l_exit_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_insert        VARCHAR(01),
    l_update,l_a    VARCHAR(01),
    l_jump          LIKE type_file.num5,
    t_pnn10         LIKE pnn_file.pnn10,
    t_pnn10t        LIKE pnn_file.pnn10t,
    l_flag          LIKE type_file.num5,
    l_b2            LIKE ima_file.ima31,
    l_ima130        LIKE ima_file.ima130,
    l_ima131        LIKE ima_file.ima131,
    l_ima25         LIKE ima_file.ima25,
    l_imaag         LIKE ima_file.imaag,
    l_imaacti       LIKE ima_file.imaacti,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_pmc49,l_pmc17 LIKE pmc_file.pmc49
DEFINE  l_ima53   LIKE ima_file.ima53
DEFINE  l_cnt     LIKE type_file.num5
DEFINE  l_pml20   LIKE pml_file.pml20,
        l_pml21   LIKE pml_file.pml21,
        l_num     LIKE type_file.num5
DEFINE  l_bmj08   LIKE bmj_file.bmj08
DEFINE  li_i         LIKE type_file.num5
DEFINE  l_count      LIKE type_file.num5
DEFINE  l_temp       LIKE ima_file.ima01
DEFINE  l_check_res  LIKE type_file.num5
DEFINE  l_ima915     LIKE ima_file.ima915
DEFINE  l_pmk        RECORD LIKE pmk_file.*
DEFINE  l_pnn10      LIKE pnn_file.pnn10,
        l_pnn10t     LIKE pnn_file.pnn10t
#No:181208 add begin------------
DEFINE ll_pmk    RECORD LIKE pmk_file.*
DEFINE ll_term   LIKE pmk_file.pmk41
DEFINE ll_price  LIKE pmk_file.pmk20
DEFINE ll_pmn73  LIKE pmn_file.pmn73
DEFINE ll_pmn74  LIKE pmn_file.pmn73
#No:181208 add end--------------


   LET g_flag_b='0'
   LET g_action_choice = ""
   IF g_pnn.getLength() = 0 THEN CALL cl_err('',-400,0) RETURN END IF
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   IF cl_null(g_pnn_t.ima54) THEN LET g_pnn_t.ima54=' ' END IF

   LET g_forupd_sql = "SELECT pmk04,pnn13,pmk02,pnn01,pnn02,pnn03,'','','','','','','','','','','','','','','',",
                      "       '','','','','','','','','',' ',' ',",
                      "       pnn15,'','','','','','','',pnn05,' ',' ',' ',' ',pnn15,pnn07,pnn08,pnn09,",
                      "       pnn33,pnn34,pnn35,pnn30,pnn31,pnn32,pnn36,pnn37,",
                      "       pnn18,pnn19,pnn10,pnn10t,pnn12,pnn11,pnn16,",
                      "  FROM pnn_file ",
                      " WHERE pnn01 = ? AND pnn02 = ? ",
                      "   AND pnn03 = ? AND pnn05 = ? ",
                      "   AND pnn06 = ? ",
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p520_bcl CURSOR FROM g_forupd_sql

   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

   INPUT ARRAY g_pnn WITHOUT DEFAULTS FROM s_pnn.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL p520_set_entry_b()
         CALL p520_set_no_entry_b()

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()

         BEGIN WORK
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_pnn_t.* = g_pnn[l_ac].*  #BACKUP

            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_pnn[l_ac].pmn04) RETURNING g_flag,g_ima906,g_ima907
               CALL s_chk_va_setting1(g_pnn[l_ac].pmn04) RETURNING g_flag,g_ima908
               CALL p520_set_entry_b()
               CALL p520_set_no_entry_b()
               CALL p520_set_no_required()
               CALL p520_set_required()
            END IF

            CALL cl_show_fld_cont()
         END IF

        AFTER FIELD pnn13
           IF NOT cl_null(g_pnn[l_ac].pnn13) THEN
              IF g_pnn[l_ac].pnn13 NOT MATCHES '[10S]' THEN
                 NEXT FIELD pnn13
              END IF
           END IF

        AFTER FIELD pml04
           CALL p520_check_pnn03('pml04',l_ac,p_cmd) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
           IF NOT l_check_res THEN NEXT FIELD pml04 END IF
              SELECT imaag INTO l_imaag FROM ima_file
               WHERE ima01=g_pnn[l_ac].pmn04
              IF (NOT cl_null(l_imaag)) AND (l_imaag!='@CHILD') THEN
                 CALL cl_err(l_imaag,"aim1004",1)
              NEXT FIELD pml04
           END IF

       AFTER FIELD att00
          SELECT COUNT(ima01) INTO l_count FROM ima_file
            WHERE ima01 = g_pnn[l_ac].att00 AND imaag = lg_smy62
          IF l_count = 0 THEN
             CALL cl_err_msg('','aim-909',lg_smy62,0)
             NEXT FIELD att00
          END IF

          IF p_cmd='u' THEN
             CALL  cl_set_comp_entry("att01,att01_c,att02,att02_c,att03,att03_c,
                                    att04,att04_c,att05,att05_c,att06,att06_c,
                                    att07,att07_c,att08,att08_c,att09,att09_c,att10,att10_c",TRUE)
          END IF

       AFTER FIELD att01
          CALL p520_check_att0x(g_pnn[l_ac].att01,1,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att01 END IF
       AFTER FIELD att02
          CALL p520_check_att0x(g_pnn[l_ac].att02,2,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att02 END IF
       AFTER FIELD att03
          CALL p520_check_att0x(g_pnn[l_ac].att03,3,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att03 END IF
       AFTER FIELD att04
          CALL p520_check_att0x(g_pnn[l_ac].att04,4,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att04 END IF
       AFTER FIELD att05
          CALL p520_check_att0x(g_pnn[l_ac].att05,5,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att05 END IF
       AFTER FIELD att06
          CALL p520_check_att0x(g_pnn[l_ac].att06,6,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att06 END IF
       AFTER FIELD att07
          CALL p520_check_att0x(g_pnn[l_ac].att07,7,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att07 END IF
       AFTER FIELD att08
          CALL p520_check_att0x(g_pnn[l_ac].att08,8,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att08 END IF
       AFTER FIELD att09
          CALL p520_check_att0x(g_pnn[l_ac].att09,9,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att09 END IF
       AFTER FIELD att10
          CALL p520_check_att0x(g_pnn[l_ac].att10,10,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att10 END IF
       AFTER FIELD att01_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att01_c,1,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att01_c END IF
       AFTER FIELD att02_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att02_c,2,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att02_c END IF
       AFTER FIELD att03_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att03_c,3,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att03_c END IF
       AFTER FIELD att04_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att04_c,4,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att04_c END IF
       AFTER FIELD att05_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att05_c,5,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att05_c END IF
       AFTER FIELD att06_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att06_c,6,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att06_c END IF
       AFTER FIELD att07_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att07_c,7,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att07_c END IF
       AFTER FIELD att08_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att08_c,8,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att08_c END IF
       AFTER FIELD att09_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att09_c,9,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att09_c END IF
       AFTER FIELD att10_c
          CALL p520_check_att0x_c(g_pnn[l_ac].att10_c,10,l_ac,p_cmd) RETURNING  #No.MOD-660090
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att10_c END IF

       AFTER FIELD SELECT
          IF g_pnn[l_ac].select  = 'Y' THEN
             LET g_pnn[l_ac].select = 'Y'
             DISPLAY g_pnn[l_ac].select TO FORMONLY.select
             CALL p520_set_entry_b()
          END IF

       AFTER FIELD ima54
          IF NOT cl_null(g_pnn[l_ac].ima54) THEN
               CALL p520_ima54_1() #check pmc01
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_pnn[l_ac].ima54=g_pnn_t.ima54
                  NEXT FIELD ima54
               END IF

               IF g_pnn[l_ac].pml04[1,4] <> 'MISC' THEN
                   CALL p520_ima54(p_cmd)
                   SELECT ima915 INTO l_ima915 FROM ima_file
                    WHERE ima01=g_pnn[l_ac].pml04
                   IF NOT cl_null(g_errno) AND (l_ima915='2' OR l_ima915='3') THEN
                       CALL cl_err('',g_errno,0)
                       LET g_pnn[l_ac].ima54=g_pnn_t.ima54
                       NEXT FIELD ima54
                   END IF
                   IF l_ima915='2' OR l_ima915='3' THEN
                       LET g_cnt = 0
                       SELECT COUNT(*) INTO g_cnt FROM pmh_file
                        WHERE pmh01 = g_pnn[l_ac].pml04 #料件編號
                          AND pmh02 = g_pnn[l_ac].ima54 #供應廠商編號
                          AND pmh13 = g_pnn[l_ac].pnn06 #採購幣別
                          AND pmh05 = '0'# 已核准
                          AND pmh21 = " "
                          AND pmh22 = '1'
                          AND pmh23 = ' '
                          AND pmhacti = 'Y'
                       IF g_cnt <= 0 THEN
                           LET g_char = NULL
                           LET g_char= "(",g_pnn[l_ac].pml04 CLIPPED,'+',g_pnn[l_ac].ima54 CLIPPED,")"
                           LET g_char = g_char CLIPPED
                           #此料件+供應商資料(pmh_file)尚未核准,請查核...!
                           CALL cl_err(g_char,'mfg3043',1)
                           NEXT FIELD ima54
                       END IF
                   END IF
               END IF
               #No:181208 add begin-------------
               SELECT * INTO ll_pmk.* FROM pmk_file WHERE pmk01 = g_pnn[l_ac].pml01
               LET ll_term = ll_pmk.pmk41
               IF cl_null(ll_term) THEN
                  SELECT pmc49 INTO ll_term
                  FROM pmc_file
                  WHERE pmc01 = g_pnn[l_ac].ima54
               END IF
               LET ll_price = ll_pmk.pmk20
               IF cl_null(ll_price) THEN
                  SELECT pmc17 INTO ll_price
                  FROM pmc_file
                  WHERE pmc01 = g_pnn[l_ac].ima54
               END IF
               CALL s_defprice_new(g_pnn[l_ac].pml04,g_pnn[l_ac].ima54,g_pnn[l_ac].pnn06,g_today,g_pnn[l_ac].pnn37,'',g_pnn[l_ac].pmc47,
                         g_pnn[l_ac].gec04,'1',g_pnn[l_ac].pnn36,'',ll_term,ll_price,g_plant)
               RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                         ll_pmn73,ll_pmn74
               CALL p520_price_check(g_pnn[l_ac].ima54,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,ll_term,g_pnn[l_ac].pml01,g_pnn[l_ac].pml02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
               END IF
               LET g_pnn[l_ac].pnn10 = cl_digcut(g_pnn[l_ac].pnn10,t_azi03)
               LET g_pnn[l_ac].pnn10t = cl_digcut(g_pnn[l_ac].pnn10t,t_azi03)
               LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
               LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
               CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
               CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
               #No:181208 add end---------------
            END IF
            CALL p520_set_no_entry_b()

        AFTER FIELD pnn06
            IF NOT cl_null(g_pnn[l_ac].pnn06) THEN
               LET l_n = 0
               SELECT COUNT(*)
                 INTO l_n
                 FROM azi_file
                WHERE azi01 = g_pnn[l_ac].pnn06
               IF l_n = 0 THEN
                  CALL cl_err(g_pnn[l_ac].pnn06,'100',1)
                  NEXT FIELD pnn06
               END IF
            END IF

        AFTER FIELD pnn09   #原分配量
           IF NOT cl_null(g_pnn[l_ac].pnn09) THEN
              LET g_pnn[l_ac].pnn09 = s_digqty(g_pnn[l_ac].pnn09,g_pnn[l_ac].pnn12)
              DISPLAY BY NAME g_pnn[l_ac].pnn09
              IF g_pnn[l_ac].pnn09 < 0 THEN
                 LET g_pnn[l_ac].pnn09 = g_pnn_t.pnn09
                 NEXT FIELD pnn09
              END IF
             #CALL s_sizechk(g_pnn[l_ac].pml04,g_pnn[l_ac].pnn09,g_lang)              #TQC-D40015 mark
              CALL s_sizechk(g_pnn[l_ac].pml04,g_pnn[l_ac].pnn09,g_lang,g_pml.pml07)  #TQC-D40015
                 RETURNING g_pnn[l_ac].pnn09
#             DISPLAY g_pnn[l_ac].pnn09 TO pnn09 #TQC-C90126 mark
#             LET g_confirm = '0'          #TQC-C90126 mark
              DISPLAY BY NAME g_pnn[l_ac].pnn09  #TQC-C90126  add
              IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
                 #IF p520_available_qty('2') THEN  #mark by guanyao160809
                 IF p520_available_qty('1') THEN   #add by guanyao160809
                    LET g_pnn[l_ac].pnn09 = g_pnn_t.pnn09   #TQC-C90114 add
                    NEXT FIELD pnn09
                 END IF
              END IF
              IF g_pnn[l_ac].pnn37 = 0 OR
                    (g_pnn_t.pnn09 <> g_pnn[l_ac].pnn09 OR
                     g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN
                 CALL p520_set_pnn37()
              END IF
              IF cl_null(g_pnn[l_ac].pnn37) THEN
                 CALL p520_set_pnn37()
              END IF

              IF cl_null(g_pnn[l_ac].pnn10) OR g_pnn[l_ac].pnn10 = 0 THEN
                 SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01
                 LET g_term = l_pmk.pmk41
                 IF cl_null(g_term) THEN
                   SELECT pmc49 INTO g_term
                     FROM pmc_file
                    WHERE pmc01 = g_pnn[l_ac].ima54
                 END IF
                 LET g_price = l_pmk.pmk20
                 IF cl_null(g_price) THEN
                   SELECT pmc17 INTO g_price
                     FROM pmc_file
                    WHERE pmc01 = g_pnn[l_ac].ima54
                 END IF
                 SELECT pmc47 INTO g_pmm.pmm21
                  FROM pmc_file
                  WHERE pmc01 =g_pnn[l_ac].ima54
                 SELECT gec04 INTO g_pmm.pmm43
                   FROM gec_file
                  WHERE gec01 = g_pmm.pmm21
                    AND gec011 = '1'  #進項
                 CALL s_defprice_new(g_pnn[l_ac].pml04,g_pnn[l_ac].ima54,
                                 g_pnn[l_ac].pnn06,g_today,g_pnn[l_ac].pnn37,'',g_pmm.pmm21,
                                 g_pmm.pmm43,'1',g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant)
                    RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                              g_pmn.pmn73,g_pmn.pmn74
                 CALL p520_price_check(g_pnn[l_ac].ima54,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_term,
                                       g_pnn[l_ac].pml01,g_pnn[l_ac].pml02)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                 END IF
                 IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF
                 LET t_pnn10 = g_pnn[l_ac].pnn10
                 LET t_pnn10t= g_pnn[l_ac].pnn10t
                 IF NOT cl_null(g_pnn[l_ac].pnn18) AND
                    NOT cl_null(g_pnn[l_ac].pnn19) THEN
                    SELECT * INTO g_pon.* FROM pon_file
                     WHERE pon01 = g_pnn[l_ac].pnn18
                       AND pon02 = g_pnn[l_ac].pnn19
                    CALL s_bkprice(t_pnn10,t_pnn10t,g_pon.pon31,g_pon.pon31t)
                         RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
                 END IF
                 CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10
                 CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t
                 LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
                 LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
                 CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
                 CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
              END IF
           END IF
       #TQC-C90115 add str---
        AFTER FIELD pnn15
           IF NOT cl_null(g_pnn[l_ac].pnn15) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM pnn_file
               WHERE pnn15 = g_pnn[l_ac].pnn15
              IF l_n = 0 THEN
                 CALL cl_err('','aap-038',1)
                 NEXT FIELD pnn15
              END IF
           END IF
       #TQC-C90115 add end---

        AFTER FIELD pnn34
           IF NOT cl_null(g_pnn[l_ac].pnn34) THEN
              IF g_pnn[l_ac].pnn34=0 THEN
                 NEXT FIELD pnn34
              END IF
           END IF

        AFTER FIELD pmn04
           IF NOT cl_null(g_pnn[l_ac].pmn04) THEN
              LET l_n = 0
              SELECT COUNT(*)
                INTO l_n
                FROM ima_file
               WHERE ima01 = g_pnn[l_ac].pmn04
                 AND ima08 IN ("M","P")
              IF l_n = 0 THEN
                 CALL cl_err(g_pnn[l_ac].pmn04,'100',1)
                 NEXT FIELD pmn04
              END IF
           END IF

        AFTER FIELD pnn35
           IF NOT cl_null(g_pnn[l_ac].pnn35) THEN
              IF g_pnn[l_ac].pnn35 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 LET g_pnn[l_ac].pnn35 = g_pnn_t.pnn35  #TQC-C90114 add
                 NEXT FIELD pnn35
              END IF
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                 g_pnn_t.pnn35 <> g_pnn[l_ac].pnn35 THEN
                 IF g_ima906='3' THEN
                    LET g_tot=g_pnn[l_ac].pnn35*g_pnn[l_ac].pnn34
                    LET g_pnn[l_ac].pnn32=g_tot*g_pnn[l_ac].pnn31
                 END IF
              END IF
           END IF
           IF g_pnn[l_ac].pnn37 = 0 OR
                 (g_pnn_t.pnn31 <> g_pnn[l_ac].pnn31 OR
                  g_pnn_t.pnn32 <> g_pnn[l_ac].pnn32 OR
                  g_pnn_t.pnn34 <> g_pnn[l_ac].pnn34 OR
                  g_pnn_t.pnn35 <> g_pnn[l_ac].pnn35 OR
                  g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN
              CALL p520_set_pnn37()
           END IF
           CALL cl_show_fld_cont()

        AFTER FIELD pnn31
           IF NOT cl_null(g_pnn[l_ac].pnn31) THEN
              IF g_pnn[l_ac].pnn31=0 THEN
                 NEXT FIELD pnn31
              END IF
           END IF

        AFTER FIELD pnn32
           IF NOT cl_null(g_pnn[l_ac].pnn32) THEN
              IF g_pnn[l_ac].pnn32 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD pnn32
              END IF
           END IF
            CALL p520_set_origin_field()
            CALL p520_check_inventory_qty()
                RETURNING g_flag
            IF g_flag = '1' THEN
               IF g_ima906 = '3' OR g_ima906 = '2' THEN
                  NEXT FIELD pnn35
               ELSE
                  NEXT FIELD pnn32
               END IF
            END IF
            IF g_pnn[l_ac].pnn37 = 0 OR (g_pnn_t.pnn31 <> g_pnn[l_ac].pnn31 OR
                   g_pnn_t.pnn32 <> g_pnn[l_ac].pnn32 OR
                   g_pnn_t.pnn34 <> g_pnn[l_ac].pnn34 OR
                   g_pnn_t.pnn35 <> g_pnn[l_ac].pnn35 OR
                   g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN
               CALL p520_set_pnn37()
            END IF
            CALL cl_show_fld_cont()

        BEFORE FIELD pnn37
           IF g_sma.sma115 ='Y' THEN
              CALL p520_set_no_required()
              CALL p520_set_required()
           END IF
           IF g_sma.sma115 = 'Y' THEN
              IF g_pnn[l_ac].pnn37 = 0 OR
                    (g_pnn_t.pnn31 <> g_pnn[l_ac].pnn31 OR
                     g_pnn_t.pnn32 <> g_pnn[l_ac].pnn32 OR
                     g_pnn_t.pnn34 <> g_pnn[l_ac].pnn34 OR
                     g_pnn_t.pnn35 <> g_pnn[l_ac].pnn35 OR
                     g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN
                 CALL p520_set_pnn37()
              END IF
           ELSE
              IF g_pnn[l_ac].pnn37 = 0 OR
                    (g_pnn_t.pnn09 <> g_pnn[l_ac].pnn09 OR
                     g_pnn_t.pnn36 <> g_pnn[l_ac].pnn36) THEN
                 CALL p520_set_pnn37()
              END IF
           END IF

        AFTER FIELD pnn37
          IF NOT cl_null(g_pnn[l_ac].pnn37) THEN
             LET g_pnn[l_ac].pnn37 = s_digqty(g_pnn[l_ac].pnn37,g_pnn[l_ac].pnn36)
             DISPLAY BY NAME g_pnn[l_ac].pnn37
             IF g_pnn[l_ac].pnn37 < 0 THEN
                CALL cl_err('','aim-391',0)
                NEXT FIELD pnn37
             END IF
          END IF
          IF g_pnn[l_ac].pnn37 != g_pnn_t.pnn37 THEN
             SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01
             LET g_term = l_pmk.pmk41
             IF cl_null(g_term) THEN
                SELECT pmc49 INTO g_term
                  FROM pmc_file
                 WHERE pmc01 =g_pnn[l_ac].ima54
             END IF
             LET g_price = l_pmk.pmk20
             IF cl_null(g_price) THEN
                SELECT pmc17 INTO g_price
                  FROM pmc_file
                 WHERE pmc01 =g_pnn[l_ac].ima54
             END IF
             SELECT pmc47 INTO g_pmm.pmm21
               FROM pmc_file
              WHERE pmc01 =g_pnn[l_ac].ima54
             SELECT gec04 INTO g_pmm.pmm43
               FROM gec_file
              WHERE gec01 = g_pmm.pmm21 AND gec011 = '1'  #進項
             CALL s_defprice_new(g_pnn[l_ac].pml04,g_pnn[l_ac].ima54,g_pnn[l_ac].pnn06,g_today,
                                 g_pnn[l_ac].pnn37,'',g_pmm.pmm21,g_pmm.pmm43,"1",
                                 g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant)
                       RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                                 g_pmn.pmn73,g_pmn.pmn74

             CALL p520_price_check(g_pnn[l_ac].ima54,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_term,
                                   g_pnn[l_ac].pml01,g_pnn[l_ac].pml02)
             IF cl_null(g_pmn.pmn73) THEN
                LET g_pmn.pmn73 = '4'
             END IF
             CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10
             CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t
             LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
             LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
             CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
             CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
          END IF

        AFTER FIELD pnn10   #採購單價
            IF NOT cl_null(g_pnn[l_ac].pnn10) THEN
               IF g_pnn[l_ac].pnn10 < 0 THEN
                  CALL cl_err(g_pnn[l_ac].pnn10,'mfg1322',0)
                  LET g_pnn[l_ac].pnn10 = g_pnn_t.pnn10
                  NEXT FIELD pnn10
               END IF
               #參數設定單價不可為零
               SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=g_pnn[l_ac].ima54
               IF cl_null(g_pnz08) THEN
                  LET g_pnz08 = 'Y'
               END IF
               IF g_pnz08 = 'N' THEN
                  IF g_pnn[l_ac].pnn10 <= 0 THEN
                     LET g_pnn[l_ac].pnn10 = g_pnn_t.pnn10
                     CALL cl_err('','axm-627',1)
                     NEXT FIELD pnn10
                  END IF
               END IF
                SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01
                LET g_term = l_pmk.pmk41
                IF cl_null(g_term) THEN
                  SELECT pmc49 INTO g_term
                    FROM pmc_file
                   WHERE pmc01 =g_pnn[l_ac].ima54
                END IF
                LET g_price = l_pmk.pmk20
                IF cl_null(g_price) THEN
                  SELECT pmc17 INTO g_price
                    FROM pmc_file
                   WHERE pmc01 =g_pnn[l_ac].ima54
                END IF
                SELECT pmc47 INTO g_pmm.pmm21
                   FROM pmc_file
                   WHERE pmc01 =g_pnn[l_ac].ima54
                SELECT gec04 INTO g_pmm.pmm43
                  FROM gec_file
                 WHERE gec01 = g_pmm.pmm21
                   AND gec011 = '1'  #進項
                CALL s_defprice_new(g_pnn[l_ac].pml04,g_pnn[l_ac].ima54,g_pnn[l_ac].pnn06,g_today,
                                g_pnn[l_ac].pnn37,'',g_pmm.pmm21,g_pmm.pmm43,"1",
                                g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant)
                   RETURNING l_pnn10,l_pnn10t,
                             g_pmn.pmn73,g_pmn.pmn74
                CALL p520_price_check(g_pnn[l_ac].ima54,l_pnn10,l_pnn10t,g_term,
                                      g_pnn[l_ac].pml01,g_pnn[l_ac].pml02)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                END IF
                IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF
               #----- check採購單價超過最近採購單價% 96-06-25
               IF g_sma.sma84 != 99.99 AND g_pnn[l_ac].pml04[1,4] <>'MISC' THEN
                  IF l_pnn10 != 0 THEN
                     IF g_pnn[l_ac].pnn10 > l_pnn10*(1+g_sma.sma84/100) THEN
                        IF g_sma.sma109 = 'R' THEN #Rejected
                           CALL cl_err(g_pnn[l_ac].pml04,'apm-240',1)
                           NEXT FIELD pnn10
                        ELSE
                           CALL cl_err('','apm-240',1)
                        END IF
                     END IF
                  ELSE
                  SELECT ima53 INTO l_ima53 FROM ima_file
                   WHERE ima01=g_pnn[l_ac].pml04
                  IF l_ima53 != 0 THEN  #有單價才能比較
                     IF g_pnn[l_ac].pnn10*g_pmm.pmm42 > l_ima53*(1+g_sma.sma84/100) #No.8618
                     THEN
                        IF g_sma.sma109 = 'R' THEN
                            CALL cl_err(g_pnn[l_ac].pml04,'apm-240',0)
                            NEXT FIELD pnn10
                        ELSE
                            CALL cl_err('','apm-240',0)
                        END IF
                     END IF
                  END IF
                  END IF
               END IF

               CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10
               LET g_pnn[l_ac].pnn10t = g_pnn[l_ac].pnn10 * ( 1 + g_pnn[l_ac].gec04 /100)
               CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t
               LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
               LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
               CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
               CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
            END IF

        AFTER FIELD pnn10t   #含稅單價
            IF NOT cl_null(g_pnn[l_ac].pnn10t) THEN
               #參數設定單價不可為零
               SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=g_pnn[l_ac].ima54
               IF cl_null(g_pnz08) THEN
                  LET g_pnz08 = 'Y'
               END IF
               IF g_pnz08 = 'N' THEN
                  IF g_pnn[l_ac].pnn10t <= 0 THEN
                     LET g_pnn[l_ac].pnn10t = g_pnn_t.pnn10t
                     CALL cl_err('','axm-627',1)
                     NEXT FIELD pnn10t
                  END IF
               END IF
               CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t   #No.CHI-6A0004
               LET g_pnn[l_ac].pnn10 = g_pnn[l_ac].pnn10t / ( 1 + g_pnn[l_ac].gec04 / 100)
               CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10
               LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
               LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
               CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
               CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
            END IF

        AFTER FIELD pnn18   #Blanket P/O單號
            IF NOT cl_null(g_pnn[l_ac].pnn18) THEN
               CALL p520_pnn18()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pnn[l_ac].pnn18,g_errno,0)
                  NEXT FIELD pnn18
               END IF
               IF g_pnn[l_ac].ima54 != g_pom.pom09 THEN    #廠商編號不合
                   CALL cl_err(g_pnn[l_ac].ima54,'apm-903',0)
                  NEXT FIELD pnn18
               END IF
            END IF

        AFTER FIELD pnn19   #Blanket 項次
            IF NOT cl_null(g_pnn[l_ac].pnn18) THEN
               IF cl_null(g_pnn[l_ac].pnn19) THEN
                  NEXT FIELD pnn18
               END IF
            END IF
            IF NOT cl_null(g_pnn[l_ac].pnn19) AND NOT cl_null(g_pnn[l_ac].pnn18) THEN    #TQC-D70013 add AND NOT cl_null(g_pnn[l_ac].pnn18)
               IF ((g_pnn[l_ac].pnn19 != g_pnn_t.pnn19 OR g_pnn_t.pnn19 IS NULL)
               OR (g_pnn[l_ac].pnn18 != g_pnn_t.pnn18 OR g_pnn_t.pnn18 IS NULL)) THEN
                  SELECT * INTO g_pon.* FROM pon_file
                   WHERE pon01 = g_pnn[l_ac].pnn18
                     AND pon02 = g_pnn[l_ac].pnn19
                  IF STATUS THEN
                      CALL cl_err3("sel","pon_file",g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,"apm-902","","",0)
                     NEXT FIELD pnn18
                  END IF
                  IF tm3.purdate > g_pon.pon19 THEN
                     CALL cl_err('','apm-815',1)
                     NEXT FIELD pnn19
                  END IF
                  #Blanket P/O 之單位轉換因子
                  CALL s_umfchk(g_pnn[l_ac].pml04,g_pnn[l_ac].pnn12,
                                g_pon.pon07)
                            RETURNING l_flag,g_pnn20
                  IF l_flag THEN
                     CALL cl_err('','abm-731',1)
                     NEXT FIELD pnn18
                  END IF
                  #輸入之數量不合大於Blanket P/O 之
                  #申請數量-已轉數量(pon20-pon21)
                  IF g_pnn[l_ac].pnn09 > g_pon.pon20 - g_pon.pon21 THEN
                      CALL cl_err('','apm-905',0)
                     NEXT FIELD pnn18
                  END IF
                  CALL s_bkprice(t_pnn10,t_pnn10t,g_pon.pon31,g_pon.pon31t)
                       RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
                  CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10
                  CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t
                  LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
                  LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
                  CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
                  CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
               END IF
             END IF

        AFTER FIELD pnn11
           IF NOT s_daywk(g_pnn[l_ac].pnn11) THEN
              CALL cl_err(g_pnn[l_ac].pnn11,'mfg3152',1)
           END IF

        BEFORE DELETE
            IF NOT cl_null(g_pnn_t.pnn13) AND
               g_pnn_t.pnn13 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM pnn_file
                 WHERE pnn01 = g_pnn[l_ac].pml01   AND
                       pnn02 = g_pnn[l_ac].pml02   AND
                       pnn03 = g_pnn_t.pml04 AND
                       pnn05 = g_pnn_t.ima54 AND
                       pnn06 = g_pnn_t.pnn06
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","pnn_file",g_pnn_t.pml04,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
#                CALL g_pnn.deleteElement(l_ac)
                COMMIT WORK
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pnn[l_ac].* = g_pnn_t.*
               CLOSE p520_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pnn[l_ac].pnn13,-263,1)
               LET g_pnn[l_ac].* = g_pnn_t.*
            ELSE
               IF NOT cl_null(g_pnn[l_ac].pnn18) THEN
                  IF cl_null(g_pnn[l_ac].pnn19) THEN
                     NEXT FIELD pnn18
                  END IF
               END IF
                IF g_sma.sma115 = 'Y' THEN
                   IF NOT cl_null(g_pnn[l_ac].pmn04) THEN
                      SELECT ima25,ima31 INTO g_ima25,g_ima31
                        FROM ima_file WHERE ima01=g_pnn[l_ac].pmn04
                   END IF

                   CALL s_chk_va_setting(g_pnn[l_ac].pmn04)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD pnn03
                   END IF
                   CALL s_chk_va_setting1(g_pnn[l_ac].pmn04)
                        RETURNING g_flag,g_ima908
                   IF g_flag=1 THEN
                      NEXT FIELD pnn03
                   END IF

                   CALL p520_du_data_to_correct()


                   CALL p520_set_origin_field()
                   CALL p520_check_inventory_qty()
                       RETURNING g_flag
                   IF g_flag = '1' THEN
                      IF g_ima906 = '3' OR g_ima906 = '2' THEN
                         NEXT FIELD pnn35       #TQC-C90106 modify pon35->pnn35
                      ELSE
                         NEXT FIELD pnn32       #TQC-C90106 modify pon32->pnn32
                      END IF
                   END IF
                END IF
                LET g_pnn38  = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
                LET g_pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
                CALL cl_digcut(g_pnn38,t_azi03) RETURNING g_pnn38
                CALL cl_digcut(g_pnn38t,t_azi03) RETURNING g_pnn38t
                UPDATE pnn_file SET pnn13=g_pnn[l_ac].pnn13,
                                    pnn03=g_pnn[l_ac].pmn04,
                                    pnn05=g_pnn[l_ac].ima54,
                                    pnn15=g_pnn[l_ac].pnn15,
                                    pnn06=g_pnn[l_ac].pnn06,
                                    pnn07=g_pnn[l_ac].pnn07,
                                    pnn08=g_pnn[l_ac].pnn08,
                                    pnn09=g_pnn[l_ac].pnn09,
                                    pnn32=g_pnn[l_ac].pnn32,
                                    pnn35=g_pnn[l_ac].pnn35,
                                    pnn37=g_pnn[l_ac].pnn37,
                                    pnn38=g_pnn38,
                                    pnn38t=g_pnn38t,
                                    pnn10=g_pnn[l_ac].pnn10,
                                    pnn10t=g_pnn[l_ac].pnn10t,
                                    pnn11=g_pnn[l_ac].pnn11,
                                    pnn12=g_pnn[l_ac].pnn12,
                                    pnn18=g_pnn[l_ac].pnn18,
                                    pnn19=g_pnn[l_ac].pnn19,
                                    pnn16='Y'
               WHERE pnn01=g_pnn[l_ac].pml01   AND
                     pnn02=g_pnn[l_ac].pml02   AND
                    ( pnn03=g_pnn_t.pml04 OR pnn03 = ' ') AND
                    ( pnn05=g_pnn_t.ima54 OR pnn05 = ' ') AND
                    ( pnn06=g_pnn_t.pnn06 OR pnn06 = ' ' )

              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pnn_file",g_pnn[l_ac].pmn04,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
                 LET g_pnn[l_ac].* = g_pnn_t.*
                 ROLLBACK WORK
              ELSE
                 COMMIT WORK
              END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pnn[l_ac].* = g_pnn_t.*
               END IF
               CLOSE p520_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE p520_bcl
            COMMIT WORK

       AFTER INPUT
         IF g_sma.sma32='Y' THEN
            IF p520_available_qty('1') THEN
               NEXT FIELD pnn13
            END IF
         END IF

         ON ACTION CONTROLP
            CASE

            WHEN INFIELD(att00)

               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ima_p"
               LET g_qryparam.arg1 = lg_group
               CALL cl_create_qry() RETURNING g_pnn[l_ac].att00
               DISPLAY BY NAME g_pnn[l_ac].att00
               NEXT FIELD att00


              #WHEN INFIELD(pnn03)                   #TQC-C90106 mark
               WHEN INFIELD(pml04)                   #TQC-C90106 add
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmd"
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.default1 = g_pnn[l_ac].pmn04
                  LET g_qryparam.arg1 = g_pml.pml04
                  CALL cl_create_qry() RETURNING g_pnn03_sub,g_pnn08_sub

                   DISPLAY BY NAME g_pnn03_sub
                   DISPLAY BY NAME g_pnn08_sub
                  IF NOT cl_null(g_pnn03_sub) THEN
                     CALL p520_s(l_ac)
                     CALL p520_b_fill(' 1=1')
                     LET l_exit_sw='n'
                     CLOSE p520_bcl
                     COMMIT WORK
                     EXIT INPUT
                  END IF

            WHEN INFIELD(ima54)
                SELECT ima915 INTO l_ima915 FROM ima_file
                 WHERE ima01=g_pnn[l_ac].pml04
                IF (l_ima915 = '2' OR l_ima915 = '3') AND g_pnn[l_ac].pml04[1,4] <> 'MISC' THEN
                    CALL q_pmh3(FALSE,TRUE,g_pnn[l_ac].pml04,g_pnn[l_ac].ima54,g_pnn[l_ac].pnn06,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn09,'1',g_pnn[l_ac].pnn12)
                    RETURNING g_pnn[l_ac].ima54,g_pnn[l_ac].pnn06,
                              g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
                    CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10
                    CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t
                    LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
                    LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
                    CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
                    CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
                ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc01"
                    LET g_qryparam.default1 = g_pnn[l_ac].ima54
                    CALL cl_create_qry() RETURNING g_pnn[l_ac].ima54
                END IF
                DISPLAY BY NAME g_pnn[l_ac].ima54
                DISPLAY BY NAME g_pnn[l_ac].pnn06
                DISPLAY BY NAME g_pnn[l_ac].pnn10
                DISPLAY BY NAME g_pnn[l_ac].pnn10t
                CALL p520_ima54_1()

            WHEN INFIELD(pnn06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.default1 = g_pnn[l_ac].pnn06
                   CALL cl_create_qry() RETURNING g_pnn[l_ac].pnn06
                   DISPLAY BY NAME g_pnn[l_ac].pnn06
                   NEXT FIELD pnn06
            WHEN INFIELD(pmn04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.default1 = g_pnn[l_ac].pmn04
                   CALL cl_create_qry() RETURNING g_pnn[l_ac].pmn04
                   DISPLAY BY NAME g_pnn[l_ac].pmn04
                   NEXT FIELD pmn04
            WHEN INFIELD(pnn18) #Blanket P/O
               CALL q_pom2(FALSE,TRUE,g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,g_pnn[l_ac].ima54,g_pnn[l_ac].pnn06,g_pnn[l_ac].pmc47) RETURNING g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19
                   DISPLAY BY NAME g_pnn[l_ac].pnn18
                   DISPLAY BY NAME g_pnn[l_ac].pnn19
               NEXT FIELD pnn18
            WHEN INFIELD(pnn15)
               CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_pnn[l_ac].pnn15
                   CALL cl_create_qry() RETURNING g_pnn[l_ac].pnn15
                   DISPLAY BY NAME g_pnn[l_ac].pnn15
                   NEXT FIELD pnn15
            WHEN INFIELD(pnn19) #Blanket P/O
               CALL q_pom2(FALSE,TRUE,g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19,g_pnn[l_ac].ima54,g_pnn[l_ac].pnn06,g_pnn[l_ac].pmc47) RETURNING g_pnn[l_ac].pnn18,g_pnn[l_ac].pnn19
                   DISPLAY BY NAME g_pnn[l_ac].pnn18
                   DISPLAY BY NAME g_pnn[l_ac].pnn19
               NEXT FIELD pnn19

               OTHERWISE
                  EXIT CASE
            END CASE

        ON ACTION select_all
           LET g_action_choice = "select_all"
           FOR l_k = 1 TO g_pnn.getLength()
               LET g_pnn[l_k].select = "Y"
           END FOR
           CONTINUE INPUT

        ON ACTION un_select_all
           LET g_action_choice = "un_select_all"
           FOR l_k = 1 TO g_pnn.getLength()
               LET g_pnn[l_k].select = "N"
           END FOR
           CONTINUE INPUT

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
         CALL cl_cmdask()

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

     IF g_sma.sma32='Y' THEN   #
        IF p520_available_qty('1') THEN
           LET l_exit_sw = 'N'
        END IF
     END IF
     LET g_ll = ARR_CURR()

END FUNCTION

FUNCTION p520_ima02(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_ima44         LIKE ima_file.ima44,
    l_imaacti       LIKE ima_file.imaacti

    LET g_errno = ' '

    SELECT ima02,ima021,ima06,ima44,imaacti
      INTO g_pnn[l_ac].ima02,g_pnn[l_ac].ima021,g_pnn[l_ac].ima06,l_ima44,l_imaacti
                         FROM ima_file
                        WHERE ima01 =g_pnn[l_ac].pmn04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_pnn[l_ac].ima02 = NULL
                                   LET l_ima44 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #No.FUN-110523-BEGIN
    SELECT imz02 INTO g_pnn[l_ac].imz02
    FROM imz_file
    WHERE imz01=g_pnn[l_ac].ima06
    #No.FUN-110523-END
    LET g_pnn[l_ac].pnn12 = l_ima44
END FUNCTION

FUNCTION p520_pnn18()
  SELECT * INTO g_pom.* FROM pom_file
   WHERE pom01 = g_pnn[l_ac].pnn18
   CASE WHEN STATUS = 100                    LET g_errno = 'apm-902'   #No:MOD-4A0356
       WHEN g_pom.pom25 MATCHES '[678]'     LET g_errno = 'mfg3258'
       WHEN g_pom.pom25 = '9'               LET g_errno = 'mfg3259'
       WHEN g_pom.pom25 NOT MATCHES '[12]'  LET g_errno = 'apm-293'
       WHEN g_pom.pom18 = 'N'               LET g_errno = 'apm-292'
       OTHERWISE  LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION

FUNCTION p520_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   STRING,
       l_gec07 LIKE gec_file.gec07,
       l_sw    LIKE type_file.num5,
       l_fa    LIKE pnn_file.pnn17,
       l_cnt   INTEGER,
       l_n     INTEGER

 LET g_sql ="SELECT DISTINCT 'N',pnn01,pnn02,pmk04,pmk12,'',pmk13,'',",
            "       pml24,pml25,pml06,",
	        "       pml04,ima02,ima021,ima06,'',ima08,pml07,pml33,pml12,pml121,pnn15,pnn03,pnn05,pmc03,pnn06,pmc47,0,",
	        "       pmk02,pnn13,'','','','','','','','','','','','','','',",
            "       '','','','','','','',ima43,'','',pml20,ima46,",
            "       ima45,pml21,pml20-pml21,pnn07,",
            "       pnn08,pnn09,pnn33,pnn34,pnn35,pnn30,pnn31,pnn32,pnn36,",
            "       pnn37,pnn10,pnn10t,pnn38,pnn38t,pnn12,pnn11,pnn18,pnn19,pnn16 ",
            "  FROM pml_file LEFT JOIN ima_file ON ima01 = pml04 , ",
            "       pmk_file, ",
            "       pnn_file LEFT JOIN pmc_file ON pmc01 = pnn05 ",
            " WHERE ",tm4.wc,
            "   AND pml01 = pmk01 ",
            "   AND pnn01 = pmk01 ",
            "   AND pnn02 = pml02 ",
            "   AND pml16 IN( '1','2') ",
            "  AND ",  p_wc2 CLIPPED,
            " AND pml20-pml21>0  "

    IF NOT cl_null(g_pmk12) AND g_pmk12 <> '*' THEN
       LET g_sql = g_sql CLIPPED," AND pnn15 = '",g_pmk12,"' "
    END IF
    LET g_sql = g_sql CLIPPED," ORDER BY pnn01,pnn02 "

    PREPARE p520_pb FROM g_sql
    DECLARE pnn_curs                       #CURSOR
        CURSOR FOR p520_pb

    CALL g_pnn.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET g_gec07 = 'N'       #No:FUN-550089
    FOREACH pnn_curs INTO g_pnn[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF cl_null(g_pnn[g_cnt].pml04) THEN
           LET g_pnn[g_cnt].ima02 = ''
           LET g_pnn[g_cnt].ima021 = ''
           LET g_pnn[g_cnt].ima08 = 'K'
           LET g_pnn[g_cnt].ima06 = ''
           LET g_pnn[g_cnt].imz02 = ''
        END IF
       #No.FUN-110523-BEGIN
       SELECT imz02 INTO g_pnn[g_cnt].imz02
       FROM imz_file
       WHERE imz01=g_pnn[g_cnt].ima06


        SELECT gen02
          INTO g_pnn[g_cnt].gen02a
          FROM gen_file
         WHERE gen01 = g_pnn[g_cnt].pmk12
        SELECT gem02
          INTO g_pnn[g_cnt].gem02
          FROM gem_file
         WHERE gem01 = g_pnn[g_cnt].pmk13

        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN

           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                  imx07,imx08,imx09,imx10 INTO
                  g_pnn[g_cnt].att00,g_pnn[g_cnt].att01,g_pnn[g_cnt].att02,
                  g_pnn[g_cnt].att03,g_pnn[g_cnt].att04,g_pnn[g_cnt].att05,
                  g_pnn[g_cnt].att06,g_pnn[g_cnt].att07,g_pnn[g_cnt].att08,
                  g_pnn[g_cnt].att09,g_pnn[g_cnt].att10
           FROM imx_file WHERE imx000 = g_pnn[g_cnt].pml04

           LET g_pnn[g_cnt].att01_c = g_pnn[g_cnt].att01
           LET g_pnn[g_cnt].att02_c = g_pnn[g_cnt].att02
           LET g_pnn[g_cnt].att03_c = g_pnn[g_cnt].att03
           LET g_pnn[g_cnt].att04_c = g_pnn[g_cnt].att04
           LET g_pnn[g_cnt].att05_c = g_pnn[g_cnt].att05
           LET g_pnn[g_cnt].att06_c = g_pnn[g_cnt].att06
           LET g_pnn[g_cnt].att07_c = g_pnn[g_cnt].att07
           LET g_pnn[g_cnt].att08_c = g_pnn[g_cnt].att08
           LET g_pnn[g_cnt].att09_c = g_pnn[g_cnt].att09
           LET g_pnn[g_cnt].att10_c = g_pnn[g_cnt].att10

        END IF
        SELECT pmc47 INTO g_pnn[g_cnt].pmc47
          FROM pmc_file
         WHERE pmc01 = g_pnn[g_cnt].ima54
        IF g_pnn[g_cnt].pmc47 IS NULL THEN
           SELECT pmk21 INTO g_pnn[g_cnt].pmc47
             FROM pmk_file
            WHERE pmk01 = g_pml.pml01
        END IF

        IF NOT cl_null(g_pnn[g_cnt].pmc47) THEN
           SELECT gec04,gec07 INTO g_pnn[g_cnt].gec04,l_gec07
             FROM gec_file
            WHERE gec01 = g_pnn[g_cnt].pmc47
           IF l_gec07 = 'Y' THEN
              LET g_gec07 = 'Y'
           END IF
        END IF

        IF g_pnn[g_cnt].pnn30=g_pnn[g_cnt].pnn36 THEN
           LET l_fa=1
        ELSE
            # CALL s_umfchk(g_pnn[g_cnt].pml04,g_pnn[g_cnt].pnn10,g_pnn[g_cnt].pnn36)
            #     RETURNING l_sw,l_fa
            # IF l_sw  THEN
                 LET l_fa=1
            # END IF
        END IF

       IF NOT cl_null(g_pnn[g_cnt].ima43) THEN
          SELECT gen02 INTO g_pnn[g_cnt].gen02 FROM gen_file WHERE gen01 = g_pnn[g_cnt].ima43
       END IF
       IF NOT cl_null(g_pnn[g_cnt].pmk12) THEN
          SELECT gen03 INTO g_pnn[g_cnt].gen03 FROM gen_file
           WHERE gen01 = g_pnn[g_cnt].pmk12
       END IF

       LET g_pnn[g_cnt].diff = g_pnn[g_cnt].pml20 - g_pnn[g_cnt].pml21

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pnn.deleteElement(g_cnt)

    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

    CALL p520_refresh_detail()
END FUNCTION

FUNCTION p520_bp(p_ud)

    DEFINE p_ud            LIKE type_file.chr1

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF

    LET g_action_choice = " "

    CALL cl_set_act_visible("accept,cancel", FALSE)

    DISPLAY ARRAY g_pnn TO s_pnn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

        BEFORE DISPLAY
          IF cl_null(g_ll) THEN
             LET g_ll = 1
          END IF
          CALL fgl_set_arr_curr(g_ll)
          LET g_ll = NULL
          CALL cl_navigator_setting( g_curs_index, g_row_count )
        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()

        ON ACTION transfer_out
           LET g_action_choice="transfer_out"
           EXIT DISPLAY

        ON ACTION query
           LET g_action_choice="query"
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
           CALL cl_show_fld_cont()
           CALL p520_def_form()
           EXIT DISPLAY

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

        ON ACTION controlg
           LET g_action_choice="controlg"
           EXIT DISPLAY

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


        ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---


    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION p520_t()
DEFINE l_show_msg  DYNAMIC ARRAY OF RECORD
                   pmm01    LIKE pmm_file.pmm01
                   END RECORD,
       l_i         LIKE type_file.num5,
       l_gaq03_f1  LIKE gaq_file.gaq03
DEFINE i          LIKE type_file.num5
DEFINE l_sql      LIKE  type_file.chr1000
DEFINE l_str1     STRING

   DEFINE l_pmm01 LIKE pmm_file.pmm01
   LET p_row = 3 LET p_col = 16

   OPEN WINDOW p5201_w AT p_row,p_col WITH FORM "apm/42f/apmp520_b"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("apmp520_b")
#MOD-D50250 add begin-------
   CALL s_showmsg_init()
   #darcy:2024/07/03 mark s---
   # FOR i=1 TO g_rec_b
   #   #參數設定單價不可為零
   #   IF g_pnn[i].select = 'Y' THEN
   #      SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=g_pnn[i].ima54
   #      IF cl_null(g_pnz08) THEN
   #         LET g_pnz08 = 'Y'
   #      END IF
   #      IF g_pnz08 = 'N' THEN
   #         IF g_pnn[i].pnn10 <= 0 THEN
   #            LET g_pnn[i].select = 'N'
   #            CALL s_errmsg('pnn02',i,'','axm-627',1)
   #         END IF
   #      END IF
   #   END IF
   # END FOR
   #darcy:2024/07/03 mark e---
#MOD-D50250 add end---------
   CALL p520_tm()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p5201_w
      CALL p520_b_fill(' 1=1')
      RETURN
   END IF
   INITIALIZE l_pnn_o.* TO NULL
   LET g_pmc47_o=NULL
   INITIALIZE g_pmm.* TO NULL			# Default condition
   INITIALIZE g_pmn.* TO NULL			# Default condition
   IF cl_sure(0,0) THEN
      #darcy:2024/08/07 add s---
      # 请购单别能产生的采购单别
      # FRA->PSF/PRS
      # PRA->PRB
      for i=1 to g_rec_b
         if g_pnn[i].select = 'Y' then
            if g_pnn[i].pml01[1,3] == "FRA" then
               if not (tm3.slip == "PSF" or tm3.slip == "PRS") then
                  call cl_err(g_pnn[i].pml01,"cpm-078",1)
                  close window p5201_w
                  return
               end if
            end if
            if g_pnn[i].pml01[1,3] == "PRA" then
               if not (tm3.slip == "PRB") then
                  call cl_err(g_pnn[i].pml01,"cpm-079",1)
                  close window p5201_w
                  return
               end if
            end if
            #if tm3.slip == "PSF" or tm3.slip == "PRS" then
            #   if g_pnn[i].pml01[1,3] != "FRA" then
            #      call cl_err(g_pnn[i].pml01,"cpm-080",1)
            #      close window p5201_w
            #      return
            #   end if
            #end if
            #if tm3.slip == "PRB" then
            #   if g_pnn[i].pml01[1,3] != "PRA" then
            #      call cl_err(g_pnn[i].pml01,"cpm-081",1)
            #      close window p5201_w
            #      return
            #   end if
            #end if
         end if
      end for
      #darcy:2024/08/07 add e---
      BEGIN WORK
      LET l_i = 1
      CALL l_show_msg.clear()

      LET g_success ='Y'
      DELETE FROM p520_tmp2

      CALL p520_gen()

      IF g_success = 'Y' THEN
         FOR i=1 TO g_rec_b
            IF g_pnn[i].select = 'Y' THEN
               DELETE FROM pnn_file
                WHERE pnn01=g_pnn[i].pml01
                  AND pnn02=g_pnn[i].pml02
                  AND pnn03=g_pnn[i].pml04
                  AND pnn05=g_pnn[i].ima54
                  AND pnn06=g_pnn[i].pnn06
            END IF
         END FOR
      END IF
      IF g_success = 'Y' THEN
         CALL cl_cmmsg(1)
         COMMIT WORK
         DECLARE p520_pmm01 CURSOR FOR
          SELECT pmm01 FROM p520_tmp2
         LET l_str1 = NULL
         FOREACH p520_pmm01 INTO l_pmm01
            IF cl_null(l_str1) THEN
               LET l_str1 = l_pmm01 CLIPPED
            ELSE
               LET l_str1 = l_str1,';',l_pmm01 CLIPPED
            END IF
            LET l_show_msg[l_i].pmm01=l_pmm01
            LET l_i = l_i + 1
         END FOREACH

         LET g_msg = NULL
         LET g_msg2= NULL
         LET l_gaq03_f1 = NULL
         CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
         CALL cl_get_feldname('pmm01',g_lang) RETURNING l_gaq03_f1
         LET g_msg2 = l_gaq03_f1 CLIPPED
         CALL cl_show_array(base.TypeInfo.create(l_show_msg),g_msg,g_msg2)
         CLOSE WINDOW p5201_w
      ELSE
         CALL cl_rbmsg(1) ROLLBACK WORK
         CLOSE WINDOW p5201_w
      END IF
   ELSE
      CLOSE WINDOW p5201_w
   END IF
   CALL s_showmsg() #MOD-D50250 add
   ERROR ""
   CALL p520_b_fill(' 1=1')

END FUNCTION

FUNCTION p520_tm()
 DEFINE  l_cnt      LIKE type_file.num5,
         li_result  LIKE type_file.num5                    #No:FUN-550060
 DEFINE  l_oay22    LIKE oay_file.oay22,        #No:TQC-650108
         l_errmsg   VARCHAR(50)                    #No:TQC-650108
 DEFINE  i          LIKE type_file.num5
 DEFINE  l_str      VARCHAR(40)
 DEFINE  l_str2      VARCHAR(40)
 DEFINE  l_pnn15    LIKE pnn_file.pnn15
 DEFINE  l_gen02    LIKE gen_file.gen02
 DEFINE  l_gem02    LIKE gem_file.gem02
 DEFINE  l_n        INTEGER
   INITIALIZE tm3.* TO NULL			# Default condition
   LET tm3.purdate = g_today
   let tm3.slip = 'PRB' #darcy:2024/06/19 add
   CLEAR FORM
   CALL cl_wait()
   #darcy:2024/07/03 mark s---
   # LET tm3.wc = " pnn01||pnn02||pnn05 in ( "
   # FOR i = 1 TO g_rec_b
   #     CALL cl_wait()
   #     IF g_pnn[i].select = 'Y' THEN
   #        LET l_str = ''
   #        LET l_str2 = g_pnn[i].pml02
   #        LET l_str = g_pnn[i].pml01 CLIPPED,l_str2 CLIPPED,g_pnn[i].ima54 CLIPPED
   #        LET l_pnn15 = g_pnn[i].pnn15
   #        IF tm3.wc <> ' pnn01||pnn02||pnn05 in (' THEN
   #           LET tm3.wc = tm3.wc,",'",l_str CLIPPED,"'"
   #          ELSE
   #           LET tm3.wc = tm3.wc,"'",l_str CLIPPED,"'"
   #        END IF
   #     END IF
   # END FOR
   # LET tm3.wc = tm3.wc," )"
   #darcy:2024/07/03 mark e---
 #  CALL cl_set_comp_visible("pmm12,pmm13,gen02,gem02",FALSE)
   ################################
   LET tm3.pmm12=g_user
   LET tm3.pmm13=g_grup
   SELECT gen02 INTO l_gen02
   FROM gen_file
   WHERE gen01 =tm3.pmm12
   SELECT gem02 INTO l_gen02
   FROM gem_file
   WHERE gem01 =tm3.pmm13
   DISPLAY l_gen02,l_gem02 TO gen02,gem02

   INPUT BY NAME tm3.slip,tm3.purdate,tm3.pmm12,tm3.pmm13
                 WITHOUT DEFAULTS
   ################################ 注释BY FENG
      BEFORE INPUT
      AFTER FIELD slip

         IF cl_null(tm3.slip) THEN
            NEXT FIELD slip
         ELSE
             #TQC-650108--begin--
             IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
                SELECT oay22 INTO l_oay22 FROM smy_file
                 WHERE smyslip = tm3.slip
                IF cl_null(tm3.slip) THEN
                  #LET l_errmsg = g_t1,',',tm3.slip
                   CALL cl_err(tm3.slip,"apm-576",1)
                   NEXT FIELD slip
                END IF
             END IF
             #TQC-650108--end--
             #No:FUN-550060  --start
             CALL s_check_no("apm",tm3.slip,"","2","","","")
               RETURNING li_result,tm3.slip
             DISPLAY BY NAME tm3.slip
             IF (NOT li_result) THEN
      	       NEXT FIELD slip
             END IF

         END IF


      AFTER FIELD purdate
         IF tm3.purdate IS NULL OR tm3.purdate = ' '
         THEN NEXT FIELD purdate
         END IF

      AFTER FIELD pmm12
        IF cl_null(tm3.pmm12) OR tm3.pmm12 = ' ' THEN
           NEXT FIELD pmm12
        END IF
        IF NOT cl_null(tm3.pmm12) THEN
           CALL p520_pmm12()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(tm3.pmm12,g_errno,0)
              NEXT FIELD pmm12
           END IF
        END IF

      AFTER FIELD pmm13
        IF cl_null(tm3.pmm13) THEN
           NEXT FIELD pmm13
         ELSE
          CALL p520_pmm13()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(tm3.pmm13,g_errno,0)
             NEXT FIELD pmm13
          END IF
        END IF

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(slip)
                  CALL q_smy(FALSE,FALSE,tm3.slip,'APM','2') RETURNING tm3.slip #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( tm3.slip )
                  DISPLAY tm3.slip TO FORMONLY.slip
                  NEXT FIELD slip
               WHEN INFIELD(pmm12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = tm3.pmm12
                  CALL cl_create_qry() RETURNING tm3.pmm12
                  DISPLAY BY NAME tm3.pmm12
                  CALL p520_pmm12()
                  NEXT FIELD pmm12
               WHEN INFIELD(pmm13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = tm3.pmm13
                  CALL cl_create_qry() RETURNING tm3.pmm13
                  DISPLAY BY NAME tm3.pmm13
                  CALL p520_pmm13()
                  NEXT FIELD pmm13
               OTHERWISE EXIT CASE
            END CASE

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          IF tm3.slip IS NULL OR tm3.slip = ' ' THEN
             NEXT FIELD slip
          END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


   END INPUT
   #darcy:2024/07/03 add s---
   LET tm3.wc = " pnn01||pnn02||pnn05 in ( "
   FOR i = 1 TO g_rec_b
       CALL cl_wait()
       IF g_pnn[i].select = 'Y' THEN
         if  tm3.slip[1,3] !="PSF" then
            SELECT pnz08 INTO g_pnz08 FROM pnz_file,pmc_file WHERE pnz01=pmc49 AND pmc01=g_pnn[i].ima54
            IF cl_null(g_pnz08) THEN
               LET g_pnz08 = 'Y'
            END IF
            IF g_pnz08 = 'N' THEN
               IF g_pnn[i].pnn10 <= 0 THEN
                  LET g_pnn[i].select = 'N'
                  CALL s_errmsg('pnn02',i,'','axm-627',1)
               END IF
            END IF
         end if
         IF g_pnn[i].select = 'Y'  THEN
            LET l_str = ''
            LET l_str2 = g_pnn[i].pml02
            LET l_str = g_pnn[i].pml01 CLIPPED,l_str2 CLIPPED,g_pnn[i].ima54 CLIPPED
            LET l_pnn15 = g_pnn[i].pnn15
            IF tm3.wc <> ' pnn01||pnn02||pnn05 in (' THEN
               LET tm3.wc = tm3.wc,",'",l_str CLIPPED,"'"
            ELSE
               LET tm3.wc = tm3.wc,"'",l_str CLIPPED,"'"
            END IF
         END IF
       END IF
   END FOR
   LET tm3.wc = tm3.wc," )"
   #darcy:2024/07/03 add e---
   IF INT_FLAG THEN RETURN END IF
END FUNCTION

FUNCTION p520_pmm12()
         DEFINE l_gen02     LIKE gen_file.gen02,
                l_gen03     LIKE gen_file.gen03,
                l_genacti   LIKE gen_file.genacti

	  LET g_errno = ' '
	  SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03
            FROM gen_file WHERE gen01 = tm3.pmm12

	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                         LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          DISPLAY l_gen02 TO FORMONLY.gen02
          LET tm3.pmm13=l_gen03
          DISPLAY BY NAME tm3.pmm13
END FUNCTION

FUNCTION p520_pmm13()
         DEFINE l_gem02     LIKE gem_file.gem02,
                l_gemacti   LIKE gem_file.gemacti

	  LET g_errno = ' '
	  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
				  WHERE gem01 = tm3.pmm13

	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                         LET l_gem02 = NULL
               WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION

FUNCTION p520_gen()
    DEFINE l_qty     LIKE pml_file.pml03,
           l_pnn01   LIKE pnn_file.pnn01,
           l_pnn02   LIKE pnn_file.pnn02,
           l_imb118  LIKE imb_file.imb118,
           l_ima49   LIKE ima_file.ima49,
           l_ima491  LIKE ima_file.ima491,
           l_release LIKE pml_file.pml21,
           l_pnn09   LIKE pnn_file.pnn09,
           l_smy62   LIKE smy_file.smy62,
           t_smy62   LIKE smy_file.smy62,
           l_cnt     LIKE type_file.num5,
           l_seq     LIKE type_file.num5,
           l_sql     STRING,
           l_slip    LIKE type_file.chr10,
           l_msg1    STRING,
           l_sma112  LIKE sma_file.sma112,
           l_pmc47   LIKE pmc_file.pmc47
   DEFINE  l_over    LIKE pml_file.pml20
   DEFINE  l_ima07   LIKE ima_file.ima07



   LET l_sql = " SELECT pnn01,pnn02 ",
               "   FROM pnn_file,pml_file, ima_file ",
               "  WHERE pnn01 = pml01 AND pnn02 = pml02 ",
               "    AND pml16 IN ('1','2') AND pnn03 = ima_file.ima01 ",
               "    AND pnn05 = ? AND pnn06=?  ",
               "    AND " ,tm3.wc CLIPPED,
               "  ORDER BY pnn05,pnn06,pnn03,pnn15,pnn01,pnn02"

   PREPARE p520_preg_a FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE p520_curg_a CURSOR WITH HOLD  FOR p520_preg_a

   LET l_msg1= NULL
   LET l_sql = " SELECT pnn_file.*,",
               "        pml_file.*,'',ima49,ima491,pmk12,pmk13 ",
               "  FROM pnn_file,pml_file, ima_file,pmk_file  ",
               " WHERE pnn01 = pml01 AND pnn02 = pml02 ",
               "   AND pml01 = pmk01 ",
               "   AND pml16 IN ('1','2') AND pnn03 = ima_file.ima01 ",
               "   AND " ,tm3.wc CLIPPED,
              #" ORDER BY pmk12,pnn05,pnn06,pnn11,pnn03,pnn15,pnn01,pnn02"   #MOD-CB0208 mark
               " ORDER BY pnn05,pnn06,pnn11,pnn03,pnn15,pnn01,pnn02"         #MOD-CB0208 add

   PREPARE p520_preg FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE p520_curg CURSOR WITH HOLD  FOR p520_preg
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('declare p520_curg:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF cl_null(l_pnn_o.pnn05) THEN LET l_pnn_o.pnn05 = '@' END IF
   IF cl_null(l_pnn_o.pnn06) THEN LET l_pnn_o.pnn06 = '@' END IF
   IF cl_null(g_pmc47_o) THEN LET g_pmc47_o = '@' END IF

   CALL p520_pmnini()

   LET g_seq = 1
   FOREACH p520_curg INTO g_pnn2.*,g_pml.*,
                          l_imb118,l_ima49,l_ima491,g_pmk12_a,g_pmk13_a
      IF SQLCA.sqlcode THEN
         CALL cl_err('p520_curg',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      #apmp520抛转采购单的时候新增判断厂商编码不能为MISC开头的
      IF g_pnn2.pnn05 MATCHES 'MISC*' THEN
         CALL cl_err(g_pnn2.pnn05,'apm-570',1)
         LET g_success = 'N'
         RETURN
      END IF

      LET l_sma112 = 'N'
      SELECT sma112 INTO l_sma112 FROM sma_file

      IF l_sma112 = 'N' OR cl_null(l_sma112) THEN
         IF g_pnn2.pnn10 = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF

      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
         LET l_slip = g_pnn2.pnn01[1,g_doc_len]
         SELECT smy62 INTO l_smy62 FROM smy_file
          WHERE smyslip = l_slip
         LET l_slip = tm3.slip[1,g_doc_len]
         SELECT smy62 INTO t_smy62 FROM smy_file
          WHERE smyslip = l_slip
         IF l_smy62 != l_smy62 THEN
            LET l_msg1=l_msg1 CLIPPED,' ',l_slip CLIPPED
            CONTINUE FOREACH
         END IF
      END IF

      IF g_sma.sma63 = '1' THEN
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt
           FROM pmh_file
          WHERE pmh01 = g_pnn2.pnn03
            AND pmh02 = g_pnn2.pnn05
            AND pmh13 = g_pnn2.pnn06
            AND pmh05 = '0'
         IF g_cnt <= 0 THEN
            LET g_char = NULL
            LET g_char= "(",g_pnn2.pnn03,'+',g_pnn2.pnn05,")"
            LET g_char = g_char CLIPPED

            CALL cl_err(g_char,'mfg3043',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      SELECT SUM(pnn09/pnn08) INTO l_pnn09 FROM pnn_file
       WHERE pnn01 = g_pnn2.pnn01
         AND pnn02 = g_pnn2.pnn02

      LET l_over = 0
      IF g_sma.sma32 = "Y" THEN  #請採購需要勾稽時
         SELECT ima07 INTO l_ima07 FROM ima_file  #select ABC code
          WHERE ima01=g_pml.pml04
         CASE
            WHEN l_ima07='A'  #計算可容許的數量
               LET l_over = g_pml.pml20 * (g_sma.sma341/100)
            WHEN l_ima07='B'
               LET l_over = g_pml.pml20 * (g_sma.sma342/100)
            WHEN l_ima07='C'
               LET l_over = g_pml.pml20 * (g_sma.sma343/100)
            OTHERWISE
               LET l_over=0
         END CASE
      END IF
      LET g_pml.pml20 = g_pml.pml20 * g_pml.pml09
      LET l_over = l_over* g_pml.pml09
      #採購分配數量合計不可大於請購未轉採購量
      SELECT pml21*pml09 INTO g_pml.pml21 FROM pml_file    #MOD-940133
       WHERE pml01 = g_pml.pml01
         AND pml02 = g_pml.pml02
      IF (g_pml.pml20+l_over-g_pml.pml21 ) < l_pnn09 THEN
         LET g_msg = g_pml.pml01 CLIPPED,'+',g_pml.pml02 USING '##',
                       '+',g_pnn2.pnn05
         CALL cl_err(g_msg CLIPPED,'apm-911',1)
         CONTINUE FOREACH
      END IF
      SELECT imb118 INTO l_imb118 FROM imb_file WHERE imb01 = g_pnn2.pnn03
      IF STATUS  THEN LET l_imb118 ='' END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM pnn_file
       WHERE pnn01 = g_pnn2.pnn01 AND pnn02 = g_pnn2.pnn02
         AND pnn16 = 'Y'
      IF l_cnt = 0 THEN CONTINUE FOREACH END IF
      IF g_pnn2.pnn09 = 0 THEN
         DELETE FROM pnn_file WHERE pnn01=g_pnn2.pnn01 AND pnn02=g_pnn2.pnn02 AND pnn03=g_pnn2.pnn03 AND pnn05=g_pnn2.pnn05 AND pnn06=g_pnn2.pnn06
         IF SQLCA.sqlerrd[3] = 0 OR SQLCA.sqlcode THEN
            LET g_success ='N'
            CALL cl_err3("del","pnn_file","","",SQLCA.sqlcode,"","(p520: delete error)",1)  #No.FUN-660129
         END IF
         CONTINUE FOREACH
      END IF

      SELECT pmc47 INTO l_pmc47 FROM p520_tmp3 WHERE pnn01=g_pnn2.pnn01 AND pnn02=g_pnn2.pnn02
      IF g_pnn2.pnn05 IS NULL THEN LET g_pnn2.pnn05 =' ' END IF
      IF g_pnn2.pnn06 IS NULL THEN LET g_pnn2.pnn06 =' ' END IF
      IF l_pmc47 IS NULL THEN LET l_pmc47=' ' END IF
      IF g_pnn2.pnn05 != l_pnn_o.pnn05 OR g_pnn2.pnn06 != l_pnn_o.pnn06 OR
          l_pmc47!=g_pmc47_o THEN #OR g_pmk12_t != g_pmk12_a
          CALL p520_pmmsum(g_pmm.pmm01)
          LET g_pmk12_t = g_pmk12_a
          CALL p520_pmmini()
          IF g_success = 'Y' THEN
             LET g_seq = 1
          END IF
          IF g_success = 'N' THEN
             EXIT FOREACH
          END IF
       END IF

       LET g_pmk12_t = g_pmk12_a
       CALL p520_inspmn(g_seq,l_imb118,l_ima49,l_ima491)
       IF g_success = 'N' THEN
          EXIT FOREACH END IF
       LET g_seq = g_seq + 1

       DELETE FROM pnn_file WHERE pnn01=g_pnn2.pnn01 AND pnn02=g_pnn2.pnn02 AND pnn03=g_pnn2.pnn03 AND pnn05=g_pnn2.pnn05 AND pnn06=g_pnn2.pnn06
       IF SQLCA.sqlerrd[3] = 0 OR SQLCA.sqlcode THEN
          LET g_success ='N'
          CALL cl_err3("del","pnn_file","","",SQLCA.sqlcode,"","(p520: del pnn error)",1)  #No.FUN-660129
          EXIT FOREACH
       END IF

       CALL p520_pml(g_pnn2.pnn01,g_pnn2.pnn02,g_pmn.pmn01)

       IF NOT cl_null(g_pnn2.pnn18) THEN
          CALL p520_pon(g_pnn2.pnn18,g_pnn2.pnn19)
       END IF

       IF g_success='N' THEN
          EXIT FOREACH
       END IF
       UPDATE pmk_file SET pmk25='2'
        WHERE pmk01 = g_pnn2.pnn01
          AND pmk01 IN (SELECT pml01 FROM pml_file
                         WHERE pml01=g_pnn2.pnn01 AND pml16='2')
      IF SQLCA.sqlcode THEN
         LET g_success ='N'
         CALL cl_err3("upd","pmk_file",g_pnn2.pnn01,"",SQLCA.sqlcode,"","(p520: up_pmk error)",1)  #No.FUN-660129
         EXIT FOREACH
      END IF
      LET l_pnn_o.* = g_pnn2.*
      LET g_pmc47_o=l_pmc47
   END FOREACH
   IF g_success = 'Y' THEN CALL p520_pmmsum(g_pmm.pmm01)  END IF

   IF NOT cl_null(l_msg1) THEN
      CALL cl_err(l_msg1,"apm-575",1)
   END IF

END FUNCTION

FUNCTION p520_pmmini()
 DEFINE  l_smyno   LIKE pmm_file.pmm01,
         l_pmc14   LIKE pmc_file.pmc14,
         l_pmc15   LIKE pmc_file.pmc15,
         l_pmc16   LIKE pmc_file.pmc16,
         l_pmc17   LIKE pmc_file.pmc17,
         l_pmc49   LIKE pmc_file.pmc49,   #TQC-C90114 add
         l_pmc47   LIKE pmc_file.pmc47,
         l_pmc47_t   LIKE pmc_file.pmc47,
         l_pmh14   LIKE pmh_file.pmh14,
         l_pmk     RECORD LIKE pmk_file.*
 DEFINE li_result    LIKE type_file.num5 #No.FUN-560014
 DEFINE l_cnt LIKE type_file.num5
 DEFINE  l_sql    STRING
 DEFINE l_pnn01    LIKE  pnn_file.pnn01
 DEFINE l_pnn02    LIKE  pnn_file.pnn02
 DEFINE l_pnn38    LIKE  pnn_file.pnn38
 DEFINE l_pnn38_t    LIKE  pnn_file.pnn38
 DEFINE l_pnn38t    LIKE  pnn_file.pnn38t
 DEFINE l_pnn38t_t    LIKE  pnn_file.pnn38t
 DEFINE l_i    LIKE type_file.num5

    CALL s_auto_assign_no("apm",tm3.slip,tm3.purdate,"2","","","","","")
        RETURNING li_result,l_smyno
        IF (NOT li_result) THEN
           CALL cl_err('','mfg3326',1)
           LET g_success = 'N'
        END IF

   message l_smyno
   CALL ui.Interface.refresh()

   SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pnn2.pnn01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmk_file",g_pnn2.pnn01,"",SQLCA.sqlcode,"","sel pmk",1)
      LET g_success = 'N'
   END IF

   IF g_pml.pml011 IS NULL OR g_pml.pml011 = ' '
   THEN LET g_pml.pml011 = 'REG'
   END IF
   LET g_pmm.pmm01   = l_smyno
   LET g_pmm.pmm02   = g_pml.pml011
   LET g_pmm.pmm905 = 'N'   #No:MOD-5A0045

   IF l_pmk.pmk02 = 'TAP' THEN
      LET g_pmm.pmm02='TAP'
      LET g_pmm.pmm901 = 'Y'
      LET g_pmm.pmm902 = 'N'
      LET g_pmm.pmm905 = 'N'
      LET g_pmm.pmm906 = 'Y'
   ELSE
      LET g_pmm.pmm901 = 'N'
   END IF
   LET l_pnn01 = NULL
   LET l_pnn02 = NULL
   LET l_pnn38 =NULL
   LET l_pnn38_t =NULL
   LET l_pnn38t = NULL
   LET l_pnn38t_t = NULL
   LET l_pmc47_t=NULL
   LET l_i=1
   FOREACH p520_curg_a USING g_pnn2.pnn05,g_pnn2.pnn06 INTO l_pnn01,l_pnn02
      SELECT pnn38,pnn38t,pmc47 INTO l_pnn38,l_pnn38t,l_pmc47
        FROM p520_tmp3
       WHERE pnn01 = l_pnn01 AND pnn02=l_pnn02
      IF cl_null(l_pmc47_t) THEN
         LET l_pmc47_t=l_pmc47
      END IF
      IF l_pmc47_t<>l_pmc47 THEN CONTINUE FOREACH END IF
      IF cl_null(l_pnn38_t) THEN
        LET l_pnn38_t=l_pnn38
      ELSE
        LET l_pnn38_t=l_pnn38_t+l_pnn38
      END IF
      IF cl_null(l_pnn38t_t) THEN
        LET l_pnn38t_t=l_pnn38t
      ELSE
        LET l_pnn38t_t=l_pnn38t_t+l_pnn38t
      END IF
     LET l_i=l_i+1
   END FOREACH
   LET g_pmm.pmm40 =l_pnn38_t
   LET g_pmm.pmm40t=l_pnn38t_t
   LET g_pmm.pmm04 = tm3.purdate
   LET g_pmm.pmm06 = l_pmk.pmk06
   LET g_pmm.pmm08 = l_pmk.pmk08               #PBI
   LET g_pmm.pmm09 = g_pnn2.pnn05
   LET l_pmk.pmk21=l_pmc47
   SELECT pmc14,pmc15,pmc16,pmc17,pmc47,pmc49
     INTO l_pmc14,l_pmc15,l_pmc16,l_pmc17,l_pmc47,l_pmc49   #TQC-C90114 modify pmm41->l_pmc49
     FROM pmc_file
    WHERE pmc01 = g_pmm.pmm09
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmc_file",g_pmm.pmm09,"",SQLCA.sqlcode,"","sel pmc",1)
      LET g_success='N'
      LET l_pmc14 = ' '      LET l_pmc15 = ' '
      LET l_pmc16 = ' '      LET l_pmc17 = ' '
      LET l_pmc47 = ' '      LET l_pmc49 = ' '         #TQC-C90114 modify pmm41->l_pmc49
   END IF
#TQC-C90114 -------------------- add ------------------------ begin
   IF cl_null(l_pmk.pmk41) THEN
      LET g_pmm.pmm41 = l_pmc49
   ELSE
      LET g_pmm.pmm41 = l_pmk.pmk41
   END IF
#TQC-C90114 -------------------- add ------------------------ end
   IF g_success='N' THEN RETURN END IF
   SELECT gen03 INTO g_pmm.pmm13 FROM gen_file
    WHERE gen01=g_pnn2.pnn15
   IF cl_null(l_pmk.pmk10) THEN LET l_pmk.pmk10 = l_pmc15 END IF
   IF cl_null(l_pmk.pmk11) THEN LET l_pmk.pmk11 = l_pmc16 END IF
   IF cl_null(l_pmk.pmk18) THEN LET l_pmk.pmk18 = l_pmc14 END IF
   IF cl_null(l_pmk.pmk20) THEN LET l_pmk.pmk20 = l_pmc17 END IF
   IF cl_null(l_pmk.pmk21) THEN LET l_pmk.pmk21 = l_pmc47 END IF
   LET g_pmm.pmm10   = l_pmk.pmk10
   LET g_pmm.pmm11   = l_pmk.pmk11
   SELECT UNIQUE pnn15 INTO g_pnn15 FROM pnn_file
    WHERE pnn01 = g_pml.pml01
      AND pnn02 = g_pml.pml02
   LET g_pmm.pmm12   = tm3.pmm12
   LET g_pmm.pmm13   = tm3.pmm13
   LET g_pmm.pmm15   = g_user
   LET g_pmm.pmm20   = l_pmk.pmk20
   LET g_pmm.pmm21   = l_pmk.pmk21
   SELECT gec04 INTO g_pmm.pmm43 FROM gec_file
                                WHERE gec01 = g_pmm.pmm21
                                  AND gec011='1'
   IF g_pmm.pmm43 IS NULL THEN LET g_pmm.pmm43   = 0 END IF
   LET g_pmm.pmm22   = g_pnn2.pnn06
   CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904) RETURNING g_pmm.pmm42
   IF cl_null(g_pmm.pmm42) THEN LET g_pmm.pmm42=1 END IF
   IF g_smy.smydmy4 = 'N' THEN
      LET g_pmm.pmm25   = '0'
      LET g_pmm.pmm18   = 'N'
   ELSE
      LET g_pmm.pmm25   = '1'
      LET g_pmm.pmm18   = 'Y'
   END IF
   LET g_pmm.pmm27   = g_today
   LET g_pmm.pmm30   = 'Y'               LET g_pmm.pmm31 = g_sma.sma51
   LET g_pmm.pmm32   = g_sma.sma52       LET g_pmm.pmm40 = 0
   LET g_pmm.pmm44   = '1'
   LET g_pmm.pmm45 = 'Y'
   LET g_pmm.pmm46   = 0                 LET g_pmm.pmm47 = 0
   LET g_pmm.pmm48   = 0                 LET g_pmm.pmm49 = 'N'
   LET g_pmm.pmm909="2"
   LET g_pmm.pmmprsw = 'Y'               LET g_pmm.pmmprno = 0
   LET g_pmm.pmmprdt = ' '
   LET g_pmm.pmmmksg = g_smy.smyapr      LET g_pmm.pmmsign = g_smy.smysign
   LET g_pmm.pmmdays = g_smy.smydays     LET g_pmm.pmmprit = g_smy.smyprit
   LET g_pmm.pmmsseq = 0                 LET g_pmm.pmmsmax = 0
   LET g_pmm.pmmuser = g_user            LET g_pmm.pmmgrup = g_grup
   LET g_pmm.pmmmodu = ' '               LET g_pmm.pmmdate = g_today
   LET g_pmm.pmmacti = 'Y'
#  LET g_pmm.pmm51 = ' '             #TQC-C90114 mark by yuhb
   LET g_pmm.pmm51 = '1'             #TQC-C90114 add by yuhb
   LET g_pmm.pmmpos = 'N'
   LET g_pmm.pmmplant = g_plant
   LET g_pmm.pmmlegal = g_legal
   LET g_pmm.pmmoriu = g_user
   LET g_pmm.pmmorig = g_grup
   LET g_pmm.pmm14 = l_pmk.pmk14    #TQC-C90114 add
   LET g_pmm.pmm16 = l_pmk.pmk16    #TQC-C90114 add
   LET g_pmm.pmm17 = l_pmk.pmk17    #TQC-C90114 add


   INSERT INTO pmm_file VALUES(g_pmm.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmm_file","","",SQLCA.sqlcode,"","ins pmm",1)
      LET g_success = 'N'
   END IF

   INSERT INTO p520_tmp2 VALUES(g_pmm.pmm01)
END FUNCTION

FUNCTION p520_pmnini()
   LET g_pmn.pmn11 = 'N'                   LET g_pmn.pmn13  = 0
   LET g_pmn.pmn14 = g_sma.sma886[1,1]     LET g_pmn.pmn15  =g_sma.sma886[2,2]
   LET g_pmn.pmn23 = ' '
   LET g_pmn.pmn36 = ' '                   LET g_pmn.pmn37 = ' '
   LET g_pmn.pmn38 = 'Y'                   LET g_pmn.pmn40 = ' '
   LET g_pmn.pmn41 = ' '                   LET g_pmn.pmn43 = 0
   LET g_pmn.pmn431 = 0
   LET g_pmn.pmn50 = 0
   LET g_pmn.pmn51 = 0
   LET g_pmn.pmn52 =' '

   LET g_pmn.pmn53 = 0                     LET g_pmn.pmn54 = ' '
   LET g_pmn.pmn55 = 0                     LET g_pmn.pmn56 = ' '
   LET g_pmn.pmn57 = 0                     LET g_pmn.pmn58 = 0
   LET g_pmn.pmn59 = ' '                   LET g_pmn.pmn60 = ' '
END FUNCTION

FUNCTION p520_inspmn(p_seq,p_imb118,p_ima49,p_ima491)
  DEFINE  p_seq     LIKE type_file.num5,
          p_imb118  LIKE imb_file.imb118,
          p_ima49   LIKE ima_file.ima49,
          p_ima491  LIKE ima_file.ima491,
          l_sw      LIKE type_file.num5,
          l_fa      LIKE pnn_file.pnn17
  DEFINE l_pmc03    LIKE pmc_file.pmc03
  DEFINE l_price    LIKE type_file.num20_6
  DEFINE l_pmi03    LIKE pmi_file.pmi03
  DEFINE l_cnt      LIKE type_file.num5
  DEFINE l_temp_str LIKE type_file.chr1000
  DEFINE l_pmh24    LIKE pmh_file.pmh24
  DEFINE  l_pmc914  LIKE pmc_file.pmc914

   LET g_pmn.pmn01 = g_pmm.pmm01          LET g_pmn.pmn011= g_pmm.pmm02
   LET g_pmn.pmn02 = p_seq
   LET g_pmn.pmn61 = g_pml.pml04

   IF g_pnn2.pnn03[1,4]='MISC' THEN
      LET g_pmn.pmn041= g_pml.pml041
   ELSE
      SELECT ima02 INTO g_pmn.pmn041 FROM ima_file
       WHERE ima01 = g_pnn2.pnn03
   END IF

   LET g_pmn.pmn05 = g_pml.pml05
   LET g_pmn.pmn07 = g_pnn2.pnn12
   LET g_pmn.pmn08 = g_pml.pml08
   LET g_pmn.pmn80 = g_pnn2.pnn30
   LET g_pmn.pmn81 = g_pnn2.pnn31
   LET g_pmn.pmn82 = g_pnn2.pnn32
   LET g_pmn.pmn83 = g_pnn2.pnn33
   LET g_pmn.pmn84 = g_pnn2.pnn34
   LET g_pmn.pmn85 = g_pnn2.pnn35
   LET g_pmn.pmn86 = g_pnn2.pnn36
   LET g_pmn.pmn87 = g_pnn2.pnn37

   IF g_pmn.pmn07 != g_pmn.pmn08 THEN
      CALL s_umfchk(g_pnn2.pnn03,g_pmn.pmn07,g_pmn.pmn08)
           RETURNING l_sw,g_pmn.pmn09
      IF l_sw  THEN
          LET g_pmn.pmn09 = 1
      END IF
   ELSE
       LET g_pmn.pmn09 = 1
   END IF

   LET g_pmn.pmn121= g_pnn2.pnn17
   LET g_pmn.pmn16 = g_pmm.pmm25
   LET g_pmn.pmn20 = g_pnn2.pnn09
   LET g_pmn.pmn24 = g_pnn2.pnn01
   LET g_pmn.pmn25 = g_pnn2.pnn02
   LET g_pmn.pmn30 = p_imb118
   LET g_pmn.pmn31 = g_pnn2.pnn10

   IF cl_null(g_pmn.pmn31) THEN
        LET g_pmn.pmn31 = 0.0
   END IF
   IF cl_null(g_pmm.pmm43) THEN
        SELECT pmm43 INTO g_pmm.pmm43 FROM pmm_file WHERE pmm01 = g_pmn.pmn01
        IF SQLCA.SQLCODE THEN LET g_pmm.pmm43 = 0.0 END IF
   END IF

   LET g_pmn.pmn31t = g_pnn2.pnn10t
   LET g_pmn.pmn44 = 0
   # darcy add s---
   if g_pnn2.pnn11 < tm3.purdate then
    let g_pnn2.pnn11 = tm3.purdate + 7
   end if
   # darcy add e---
   LET g_pmn.pmn34 = g_pnn2.pnn11
   LET g_pmn.pmn33 = g_pnn2.pnn11
   LET g_pmn.pmn35 = g_pnn2.pnn11

   LET g_pmn.pmn44 = g_pmn.pmn31 * g_pmm.pmm42
   LET g_pmn.pmn04 = g_pnn2.pnn03
   LET g_pmn.pmn42 = g_pnn2.pnn13
   IF g_pmn.pmn42 IS NULL OR g_pmn.pmn42 = ' '
   THEN LET g_pmn.pmn42 = '0'
   END IF
   LET g_pmn.pmn62 = g_pnn2.pnn08
   IF g_pmn.pmn62 IS NULL OR g_pmn.pmn62 = ' '
   THEN LET g_pmn.pmn62 = 1
   END IF
   LET g_pmn.pmn63='N'
   LET g_pmn.pmn64='N'
   LET g_pmn.pmn65='1'
   LET g_pmn.pmn50=0
   LET g_pmn.pmn51=0
   LET g_pmn.pmn53=0
   LET g_pmn.pmn55=0
   LET g_pmn.pmn57=0
   LET g_pmn.pmn66 = g_pml.pml66
   LET g_pmn.pmn67 = g_pml.pml67
   LET g_pmn.pmn68 = g_pnn2.pnn18 #Blanket PO
   LET g_pmn.pmn69 = g_pnn2.pnn19 #Blanket PO
   LET g_pmn.pmn70 = g_pnn2.pnn20 #Blanket PO
   LET g_pmn.pmn122 = g_pml.pml12   #No:8841
   IF cl_null(g_pmn.pmn122) THEN LET g_pmn.pmn122=' ' END IF    #No:8841
   LET g_pmn.pmn100 = g_pml.pml06  #FUN-D40042 備註
   #darcy:2024/05/27 add s---
   # 如果是HRA请购单，将备注栏位同步带到pmnud01
   if g_pml.pml01 matches "HRA*" or g_pml.pml01 matches "PMJ*" then #darcy:2024/07/08 add PMJ
      let g_pmn.pmnud01 = g_pml.pml06
   else
      let g_pmn.pmnud01 = ""
   end if
   #darcy:2024/05/27 add e---
   LET g_pmn.pmn88  = g_pmn.pmn31  * g_pmn.pmn87
   LET g_pmn.pmn88t = g_pmn.pmn31t * g_pmn.pmn87
   LET g_pmn.pmn88  = cl_digcut(g_pmn.pmn88,g_azi04)
   LET g_pmn.pmn88t = cl_digcut(g_pmn.pmn88t,g_azi04)

#TQC-C90114 ----------------- add -------------- begin #TQC-C90114
   SELECT pml123 INTO g_pmn.pmn123 FROM pml_file
    WHERE pml01 = g_pml.pml01
      AND pml02 = g_pml.pml02
   IF cl_null(g_pmn.pmn123) THEN
#TQC-C90114 ----------------- add -------------- end
      SELECT pmh07 INTO g_pmn.pmn123 FROM pmh_file
       WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
         AND pmh13 = g_pmm.pmm22
   END IF    #TQC-C90114 add

   IF cl_null(g_pmn.pmn01) THEN RETURN END IF
   IF cl_null(g_pmn.pmn02) THEN RETURN END IF
   IF cl_null(g_pmn.pmn04) THEN RETURN END IF
   SELECT ima35,ima36,ima15,ima39 INTO g_pmn.pmn52,g_pmn.pmn54,g_pmn.pmn64,g_pmn.pmn40 #CHI-840007
     FROM ima_file WHERE ima01=g_pmn.pmn04

   SELECT pmh24  INTO l_pmh24 FROM pmh_file
     WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
       AND pmh13 = g_pmm.pmm22 AND pmh21 = " "
       AND pmh22 = '1' AND pmhacti = 'Y'
       AND pmh23 = ' '
   IF NOT cl_null(l_pmh24) THEN
      LET g_pmn.pmn89=l_pmh24
   ELSE
      SELECT pmc914 INTO l_pmc914 FROM pmc_file
        WHERE pmc01 = g_pmm.pmm09
      IF l_pmc914 = 'Y' THEN
        LET g_pmn.pmn89 = 'Y'
      ELSE
        LET g_pmn.pmn89 = 'N'
      END IF
   END IF

   IF cl_null(g_pmn.pmn20) THEN LET g_pmn.pmn20 = 0 END IF
   IF cl_null(g_pmn.pmn31) THEN LET g_pmn.pmn31 = 0 END IF
   IF cl_null(g_pmn.pmn42) THEN LET g_pmn.pmn42 = '0' END IF
   IF cl_null(g_pmn.pmn50) THEN LET g_pmn.pmn50 = 0 END IF
   IF cl_null(g_pmn.pmn51) THEN LET g_pmn.pmn51 = 0 END IF
   IF cl_null(g_pmn.pmn52) THEN LET g_pmn.pmn52 = '' END IF
   IF cl_null(g_pmn.pmn53) THEN LET g_pmn.pmn53 = 0 END IF
   IF cl_null(g_pmn.pmn54) THEN LET g_pmn.pmn54 = '' END IF
   IF cl_null(g_pmn.pmn55) THEN LET g_pmn.pmn55 = 0 END IF
   IF cl_null(g_pmn.pmn56) THEN LET g_pmn.pmn56 = '' END IF
   IF cl_null(g_pmn.pmn57) THEN LET g_pmn.pmn57 = 0 END IF
   IF cl_null(g_pmn.pmn61) THEN LET g_pmn.pmn61 = g_pmn.pmn04 END IF
   IF cl_null(g_pmn.pmn62) THEN LET g_pmn.pmn62 = 1 END IF
   LET g_pmn.pmn73 = ' '   #NO.FUN-960130
   LET g_pmn.pmnplant = g_plant #FUN-980006 add
   LET g_pmn.pmnlegal = g_legal #FUN-980006 add
   IF cl_null(g_pmn.pmn58) THEN LET g_pmn.pmn58 = 0 END IF  #TQC-9B0203
   IF cl_null(g_pmn.pmn89) THEN LET g_pmn.pmn89 = 'N' END IF
   IF cl_null(g_pmn.pmn73) THEN LET  g_pmn.pmn73= '4' END IF   #TQC-C90114 add by yuhb

   LET g_pmn.pmn56=g_pml.pmlud02     #add by jixf 160804
   INSERT INTO pmn_file VALUES(g_pmn.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmn_file","","",SQLCA.sqlcode,"","ins pmn",1)  #No.FUN-660129
      LET g_success = 'N'
   END IF
END FUNCTION

FUNCTION p520_pmmsum(p_pmm01)
 DEFINE  p_pmm01 LIKE pmm_file.pmm01,
         l_tot   LIKE pmm_file.pmm40,
         lt_tot  LIKE pmm_file.pmm40t

   SELECT SUM(pmn87 * pmn31),SUM(pmn87 * pmn31t)
     INTO l_tot,lt_tot
     FROM pmn_file
     WHERE pmn01 = p_pmm01
   IF l_tot > 0 THEN
      SELECT azi04 INTO g_azi04
        FROM azi_file
       WHERE azi01=g_pmm.pmm22
         AND aziacti ='Y'
      CALL cl_digcut(l_tot,g_azi04) RETURNING l_tot
      CALL cl_digcut(lt_tot,g_azi04) RETURNING lt_tot
      UPDATE pmm_file SET pmm40 = l_tot,
                          pmm40t= lt_tot
                    WHERE pmm01 = p_pmm01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pmm_file",p_pmm01,"",SQLCA.sqlcode,"","(p200.ckp#5 update pmm_file error)",1)
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION p520_s(p_ac)
   DEFINE  p_ac,l_n       LIKE type_file.num5
   DEFINE  l_pnn09        LIKE pnn_file.pnn09
   DEFINE  l_gec04        LIKE gec_file.gec04     #No:FUN-550089
   DEFINE  l_azi03        LIKE azi_file.azi03     #No:FUN-550089
   DEFINE  l_pnn17        LIKE pnn_file.pnn17  #MOD-5B0333 add
   DEFINE  l_pnn30        LIKE pnn_file.pnn30     #MOD-5B0333 add
   DEFINE  l_pnn36        LIKE pnn_file.pnn36     #MOD-5B0333 add

   LET l_pnn09 = g_pnn[p_ac].pnn09

   SELECT COUNT(*) INTO l_n FROM pnn_file
    WHERE pnn01=g_pml.pml01 AND pnn02=g_pml.pml02
   IF l_n = 0  THEN RETURN  END IF

   IF g_pnn03_sub != g_pnn[p_ac].pml04  THEN
      LET l_n = l_n + 1
      LET g_pnn[l_n].pnn13='S'
      LET g_pnn[l_n].pml04=g_pnn03_sub
      LET g_pnn[l_n].pnn08=g_pnn08_sub

      DECLARE p520_s_cl CURSOR FOR
        SELECT pmh02,pmh11,pmh12,pmh13 FROM pmh_file
         WHERE pmh01 = g_pnn03_sub AND pmhacti = 'Y'

      OPEN p520_s_cl
      FETCH p520_s_cl INTO g_pnn[l_n].ima54,g_pnn[l_n].pnn07,
                           g_pnn[l_n].pnn10,g_pnn[l_n].pnn06
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_pnn[l_n].ima54,SQLCA.sqlcode,1)
      END IF
      CLOSE p520_s_cl

      #SELECT ima02,ima021,ima44  INTO           #MOD-5B0333 mark
      SELECT ima02,ima021,ima06,ima44,ima908  INTO     #MOD-5B0333 add
             #g_pnn[l_n].ima02,g_pnn[l_n].ima021_1,g_pnn[l_n].pnn12  #MOD-5B0333 mark
             g_pnn[l_n].ima02,g_pnn[l_n].ima021,g_pnn[l_n].ima06,g_pnn[l_n].pnn12,g_pnn[l_n].pnn36  #MOD-5B0333 add
        FROM ima_file
       WHERE ima01=g_pnn03_sub
      IF STATUS THEN
         LET g_pnn[l_n].ima02 =''
         LET g_pnn[l_n].ima021 =''
      END IF
      #No.FUN-110523-BEGIN
       SELECT imz02 INTO g_pnn[l_n].imz02
       FROM imz_file
       WHERE imz01=g_pnn[l_n].ima06
      #No.FUN-110523-END
      LET g_pnn[l_n].pnn30 = g_pnn[l_n].pnn12  #MOD-5B0333 add
      IF cl_null(g_pnn[l_n].pnn07) THEN LET g_pnn[l_n].pnn07 = 0 END IF
      LET g_pnn[l_n].pnn09 = g_pnn[p_ac].pnn09 * g_pnn[l_n].pnn08
      #No.FUN-560063  --begin
      LET g_pnn[l_n].pnn32 = g_pnn[p_ac].pnn32 * g_pnn[l_n].pnn08
      LET g_pnn[l_n].pnn35 = g_pnn[p_ac].pnn35 * g_pnn[l_n].pnn08
      LET g_pnn[l_n].pnn37 = g_pnn[p_ac].pnn37 * g_pnn[l_n].pnn08
      #No.FUN-560063  --end
      IF g_pnn[l_n].pnn09 = 0  THEN
         INITIALIZE g_pnn[l_n].* TO NULL
         RETURN  END IF

      IF cl_null(g_pnn[l_n].pnn10) THEN LET g_pnn[l_n].pnn10 = 0 END IF

      LET g_pnn[l_n].pnn16 = 'Y'
      LET g_pnn[l_n].pnn11 = g_pnn[p_ac].pnn11

      #No:FUN-550089
      SELECT azi03 INTO l_azi03 FROM azi_file
       WHERE azi01 = g_pnn[l_n].pnn06
      LET g_pnn[l_n].pnn10 = cl_digcut(g_pnn[l_n].pnn10,l_azi03)
      SELECT gec04 INTO l_gec04 FROM gec_file,pmc_file
       WHERE gec01 = pmc47 AND pmc01 = g_pnn[l_n].ima54
      IF cl_null(l_gec04) THEN LET l_gec04 = 0 END IF
      LET g_pnn[l_n].pnn10t = g_pnn[l_n].pnn10 * ( 1 + l_gec04 / 100 )
      LET g_pnn[l_n].pnn10t = cl_digcut(g_pnn[l_n].pnn10t,l_azi03)

      LET g_pnn38  = g_pnn[l_n].pnn10 * g_pnn[l_n].pnn37
      LET g_pnn38t = g_pnn[l_n].pnn10t * g_pnn[l_n].pnn37
      CALL cl_digcut(g_pnn38,t_azi03) RETURNING g_pnn38
      CALL cl_digcut(g_pnn38t,t_azi03) RETURNING g_pnn38t

      SELECT pnn17 INTO l_pnn17 FROM pnn_file WHERE pnn01 = g_pml.pml01 AND
             pnn02=g_pml.pml02 AND pnn13 = '1'

      INSERT INTO pnn_file(pnn01, pnn02, pnn03, pnn05, pnn06,
                           pnn07, pnn08, pnn09, pnn10, pnn11,
                           #pnn12, pnn13, pnn14, pnn15, pnn16, pnn10t,  #No:FUN-550089 #MOD-5B0333 mark
                           pnn12, pnn13, pnn14, pnn15, pnn16, pnn10t, pnn17, #MOD-5B0333 add
                           pnn30, pnn31, pnn32, pnn33, pnn34,
                           pnn35, pnn36, pnn37, pnn38, pnn38t,pnnplant,pnnlegal)#FUN-101220
       VALUES(g_pml.pml01,g_pml.pml02,
              g_pnn[l_n].pml04,g_pnn[l_n].ima54,
              g_pnn[l_n].pnn06,g_pnn[l_n].pnn07,
              g_pnn[l_n].pnn08,g_pnn[l_n].pnn09,
              g_pnn[l_n].pnn10,g_pnn[l_n].pnn11,
              g_pnn[l_n].pnn12,g_pnn[l_n].pnn13,
              g_pnn[l_n].pml04,g_pnn15,'Y',g_pnn[l_n].pnn10t,  #No:FUN-550089
              l_pnn17,        #MOD-5B0333 add
              g_pnn[l_n].pnn30,g_pnn[l_n].pnn31,
              g_pnn[l_n].pnn32,g_pnn[l_n].pnn33,
              g_pnn[l_n].pnn34,g_pnn[l_n].pnn35,
              g_pnn[l_n].pnn36,g_pnn[l_n].pnn37,
              g_pnn38,g_pnn38t,g_pnnplant,g_pnnlegal)#FUN-101220
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_pnn[l_n].pml04,SQLCA.sqlcode,0)   #No.FUN-660129
          CALL cl_err3("ins","pnn_file",g_pnn[l_n].pml04,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
          INITIALIZE g_pnn[l_n].* TO NULL
       ELSE
         LET g_pnn[p_ac].pnn09 = 0
         UPDATE pnn_file SET pnn09=0
          WHERE pnn01 = g_pml.pml01  AND
                pnn02 = g_pml.pml02  AND
                pnn03 = g_pnn[p_ac].pml04  AND
                pnn05 = g_pnn[p_ac].ima54
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_pnn[p_ac].pml04,SQLCA.sqlcode,0)   #No.FUN-660129
             CALL cl_err3("upd","pnn_file",g_pnn[p_ac].pml04,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
          ELSE
             MESSAGE '(SUB)insert pnn_file OK! update pnn_file OK !'
          END IF
       END IF
   END IF
END FUNCTION

FUNCTION p520_pml(p_pmn24,p_pmn25,p_pmn01)
  DEFINE p_pmn24   LIKE pmn_file.pmn24
  DEFINE p_pmn25   LIKE pmn_file.pmn25
  DEFINE l_sum     LIKE pml_file.pml21
  #MOD-5B0333 add
  DEFINE l_pmn20   LIKE pmn_file.pmn20
  DEFINE l_pmn62   LIKE pmn_file.pmn62
  DEFINE l_pmn121  LIKE pmn_file.pmn121
  #MOD-5B0333 end
  DEFINE p_pmn01   LIKE pmn_file.pmn01
  DEFINE l_pml21   LIKE pml_file.pml21

      LET l_sum=0

      #SELECT SUM(pmn20/pmn62*pmn121) INTO l_sum FROM pmn_file #MOD-5B0333 mark
      SELECT pmn20,pmn62,pmn121 INTO l_pmn20,l_pmn62,l_pmn121 FROM pmn_file #MOD-5B0333 add
       WHERE pmn24=p_pmn24 AND pmn25=p_pmn25
         AND pmn01 = p_pmn01
         AND pmn16<>'9'
      #MOD-5B0333 add
      IF cl_null(l_pmn62) THEN
         LET l_pmn62 = 1
      END IF
      IF cl_null(l_pmn121) THEN
         LET l_pmn121 = 1
      END IF
      LET l_sum = l_pmn20/l_pmn62*l_pmn121

      IF cl_null(l_sum) THEN LET l_sum = 0 END IF
      #MOD-5B0333 end

      SELECT pml21 INTO l_pml21 FROM pml_file WHERE pml01=p_pmn24 AND pml02=p_pmn25
      IF cl_null(l_pml21) THEN LET l_pml21 = 0 END IF

      UPDATE pml_file SET pml16='2',pml21=l_sum + l_pml21
       WHERE pml01=p_pmn24 AND pml02=p_pmn25
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("upd","pml_file",p_pmn24,p_pmn25,SQLCA.sqlcode,"","upd pml",1)  #No.FUN-660129
         RETURN
      END IF
END FUNCTION

FUNCTION p520_pon(p_pmn68,p_pmn69)
  DEFINE p_pmn68   LIKE pmn_file.pmn68
  DEFINE p_pmn69   LIKE pmn_file.pmn69
  DEFINE l_pon20   LIKE pon_file.pon20
  DEFINE l_sum     LIKE pml_file.pml21

      LET l_sum=0

      SELECT SUM(pmn20/pmn62*pmn70) INTO l_sum FROM pmn_file
       WHERE pmn68=p_pmn68 AND pmn69=p_pmn69
         AND pmn16<>'9'
      IF cl_null(l_sum) THEN LET l_sum = 0 END IF

      SELECT pon20 INTO l_pon20 FROM pon_file
       WHERE pon01 = p_pmn68 AND pon02 = p_pmn69
      IF cl_null(l_pon20) THEN LET l_pon20 = 0 END IF
      IF l_pon20 - l_sum < 0 THEN
         LET g_success='N'
          CALL cl_err('','apm-905',1)   #No:MOD-4A0356
         RETURN
      END IF

      UPDATE pon_file SET pon16='2',pon21=l_sum
       WHERE pon01=p_pmn68 AND pon02=p_pmn69
      IF SQLCA.sqlcode THEN
         LET g_success='N'
#        CALL cl_err('upd pon',SQLCA.sqlcode,1)   #No.FUN-660129
         CALL cl_err3("upd","pon_file",p_pmn68,p_pmn69,SQLCA.sqlcode,"","upd pon",1)  #No.FUN-660129
         RETURN
      END IF

      UPDATE pom_file SET pom25='2'
        WHERE pom01=p_pmn68 AND pom01 NOT IN
             (SELECT pon01 FROM pon_file WHERE pon01=p_pmn68
                          AND pon16 NOT IN ('2'))
      IF SQLCA.sqlcode THEN
         LET g_success='N'
#        CALL cl_err('upd pom',SQLCA.sqlcode,1)   #No.FUN-660129
         CALL cl_err3("upd","pom_file",p_pmn68,"",SQLCA.sqlcode,"","upd pom",1)  #No.FUN-660129
         RETURN
      END IF
END FUNCTION

FUNCTION p520_available_qty(p_flag)
DEFINE    l_sum           LIKE pml_file.pml20,
          l_over          LIKE pml_file.pml20,
          l_k             LIKE type_file.num5,
          l_ima07         LIKE  ima_file.ima07
DEFINE    l_pnn           RECORD LIKE pnn_file.*
DEFINE    l_pml09         LIKE pml_file.pml09
DEFINE    p_flag          LIKE type_file.chr1
DEFINE    l_flag2         LIKE type_file.num5
DEFINE    l_pnn17         LIKE pnn_file.pnn17

    LET l_sum = 0
# TQC-C90126-------------- add -------------- begin
    SELECT * INTO g_pml.* FROM pml_file
     WHERE pml01 = g_pnn[l_ac].pml01
       AND pml02 = g_pnn[l_ac].pml02
# TQC-C90126-------------- add -------------- end
    IF p_flag = '1' THEN
       LET g_sql =
           "SELECT * FROM pnn_file ",
           "  WHERE  pnn01 ='",g_pnn[l_ac].pml01,"'",
           "    AND  pnn02 ='",g_pnn[l_ac].pml02,"'"
    ELSE
       LET g_sql =
           "SELECT * FROM pnn_file ",
           "  WHERE  pnn01 ='",g_pml.pml01,"'",
           "    AND  pnn02 ='",g_pml.pml02,"'",
           "    AND  pnn01 NOT IN (SELECT pnn01 FROM pnn_file ",
           "                        WHERE  pnn01 ='",g_pnn[l_ac].pml01,"'",
           "                          AND  pnn02 ='",g_pnn[l_ac].pml02,"'",
           "                          AND  pnn03 ='",g_pnn[l_ac].pml04,"'",
           "                          AND  pnn05 ='",g_pnn[l_ac].ima54,"'",
           "                          AND  pnn06 ='",g_pnn[l_ac].pnn06,"')"
    END IF

    PREPARE p520_pb2 FROM g_sql
    DECLARE pnn_curs2 CURSOR FOR p520_pb2
    FOREACH pnn_curs2 INTO l_pnn.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF l_pnn.pnn03 IS NULL OR l_pnn.pnn03 = ' '
          THEN EXIT FOREACH
        END IF
        IF l_pnn.pnn08 IS NULL THEN
           LET l_pnn.pnn08=1
        END IF
        SELECT pml09 INTO l_pml09 FROM pml_file
          WHERE pml01 = g_pml.pml01
            AND pml02 = g_pml.pml02
        LET l_sum = l_sum + ((l_pnn.pnn09/l_pnn.pnn08*l_pnn.pnn17)*l_pml09)
    END FOREACH

    IF p_flag = '2' THEN
       CALL s_umfchk(g_pnn[l_ac].pml04,g_pnn[l_ac].pnn12,g_pml.pml07)
           RETURNING l_flag2,l_pnn17
       IF l_flag2 = 1 THEN
          LET l_pnn17=1
       END IF
       LET l_sum = l_sum + ((g_pnn[l_ac].pnn09/g_pnn[l_ac].pnn08*l_pnn17)*g_pml.pml09)
    END IF

    SELECT ima07 INTO l_ima07 FROM ima_file
     WHERE ima01=g_pml.pml04
    CASE
       WHEN l_ima07='A'  #計算可容許的數量
            LET l_over=g_pml.pml20 * (g_sma.sma341/100)
       WHEN l_ima07='B'
            LET l_over=g_pml.pml20 * (g_sma.sma342/100)
       WHEN l_ima07='C'
            LET l_over=g_pml.pml20 * (g_sma.sma343/100)
       OTHERWISE
            LET l_over=0
    END CASE
    LET g_pml.pml20 = g_pml.pml20 * g_pml.pml09
    LET l_over = l_over * g_pml.pml09

    SELECT pml21*pml09 INTO g_pml.pml21 FROM pml_file
      WHERE pml01 = g_pml.pml01
        AND pml02 = g_pml.pml02
    IF l_sum > (g_pml.pml20 - g_pml.pml21)+l_over THEN
        CALL cl_err(g_pml.pml01,'mfg3528',0)
          IF g_sma.sma33='R'    #reject
             THEN
             RETURN -1
          END IF
    END IF
    RETURN 0
END FUNCTION

FUNCTION p520_set_entry_b()

   IF cl_null(g_pnn[l_ac].pmn04) OR g_pnn[l_ac].ima08 = 'K' THEN
      CALL cl_set_comp_entry("pmn04",TRUE)
   ELSE
      CALL cl_set_comp_entry("pmn04",FALSE)
   END IF
 #  CALL cl_set_comp_entry("pnn10,pnn10t",FALSE)
   #No.FUN-560063  --begin
   CALL cl_set_comp_entry("pnn32,pnn35,pnn37",TRUE)
   #No.FUN-560063  --end
   CALL cl_set_comp_entry("ima43,pmk12",FALSE)

END FUNCTION

FUNCTION p520_set_no_entry_b()


   DEFINE l_gec07 LIKE gec_file.gec07
   SELECT gec07 INTO l_gec07   #
    FROM gec_file WHERE gec01 = g_pnn[l_ac].pmc47
   IF cl_null(l_gec07) THEN LET l_gec07 = 'N' END IF
   IF l_gec07 = 'N' THEN
      CALL cl_set_comp_entry("pnn10t",FALSE)
   ELSE
      CALL cl_set_comp_entry("pnn10",FALSE)
   END IF

   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("pnn35",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN
      CALL cl_set_comp_entry("pnn36,pnn37",FALSE)
   END IF
   CALL cl_set_comp_entry("ima43,pmk12",FALSE)
   CALL cl_set_comp_entry("ima06",FALSE)
   CALL cl_set_comp_entry("pml12,pml121,diff",FALSE)
END FUNCTION

FUNCTION p520_set_required()

   IF g_ima906 = '3' THEN
      CALL cl_set_comp_required("pnn35,pnn32",TRUE)
   END IF

   IF NOT cl_null(g_pnn[l_ac].pnn30) THEN
      CALL cl_set_comp_required("pnn32",TRUE)
   END IF
   IF NOT cl_null(g_pnn[l_ac].pnn33) THEN
      CALL cl_set_comp_required("pnn35",TRUE)
   END IF
   IF NOT cl_null(g_pnn[l_ac].pnn36) THEN
      CALL cl_set_comp_required("pnn37",TRUE)
   END IF
END FUNCTION

FUNCTION p520_set_no_required()

  CALL cl_set_comp_required("pnn35,pnn32,pnn37",FALSE)

END FUNCTION


FUNCTION p520_du_data_to_correct()

   IF cl_null(g_pnn[l_ac].pnn30) THEN
      LET g_pnn[l_ac].pnn31 = NULL
      LET g_pnn[l_ac].pnn32 = NULL
   END IF

   IF cl_null(g_pnn[l_ac].pnn33) THEN
      LET g_pnn[l_ac].pnn34 = NULL
      LET g_pnn[l_ac].pnn35 = NULL
   END IF

   IF cl_null(g_pnn[l_ac].pnn36) THEN
      LET g_pnn[l_ac].pnn37 = NULL
   END IF

   DISPLAY BY NAME g_pnn[l_ac].pnn31
   DISPLAY BY NAME g_pnn[l_ac].pnn32
   DISPLAY BY NAME g_pnn[l_ac].pnn34
   DISPLAY BY NAME g_pnn[l_ac].pnn35
   DISPLAY BY NAME g_pnn[l_ac].pnn36
   DISPLAY BY NAME g_pnn[l_ac].pnn37

END FUNCTION

FUNCTION p520_set_pnn37()
  DEFINE    l_item   LIKE img_file.img01,
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44,
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,
            l_qty2   LIKE img_file.img10,
            l_fac1   LIKE img_file.img21,
            l_qty1   LIKE img_file.img10,
            l_tot    LIKE img_file.img10,
            l_factor DECIMAL(16,8)

    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pnn[l_ac].pmn04
    IF SQLCA.sqlcode =100 THEN
       IF g_pnn[l_ac].pmn04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF

    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_pnn[l_ac].pnn34
       LET l_qty2=g_pnn[l_ac].pnn35
       LET l_fac1=g_pnn[l_ac].pnn31
       LET l_qty1=g_pnn[l_ac].pnn32
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pnn[l_ac].pnn09
       CALL s_umfchk(g_pnn[l_ac].pmn04,g_pnn[l_ac].pnn12,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906

          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchk(g_pnn[l_ac].pmn04,l_ima44,g_pnn[l_ac].pnn36)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor

    LET g_pnn[l_ac].pnn37 = l_tot
END FUNCTION

FUNCTION p520_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pnn_file.pnn34,
            l_qty2   LIKE pnn_file.pnn35,
            l_fac1   LIKE pnn_file.pnn31,
            l_qty1   LIKE pnn_file.pnn32,
            l_factor DECIMAL(16,8),
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44

    #No.MOD-590119  --begin
    IF g_sma.sma115='N' THEN RETURN END IF
    #No.MOD-590119  --end
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=g_pnn[l_ac].pmn04
    IF SQLCA.sqlcode = 100 THEN
       IF g_pnn[l_ac].pmn04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_pnn[l_ac].pnn34
    LET l_qty2=g_pnn[l_ac].pnn35
    LET l_fac1=g_pnn[l_ac].pnn31
    LET l_qty1=g_pnn[l_ac].pnn32

    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906

          WHEN '1' LET g_pnn[l_ac].pnn09=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_pnn[l_ac].pnn09=l_tot
          WHEN '3' LET g_pnn[l_ac].pnn09=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_pnn[l_ac].pnn34=l_qty1/l_qty2
                   ELSE
                      LET g_pnn[l_ac].pnn34=0
                   END IF
       END CASE
    END IF

    IF cl_null(g_pnn[l_ac].pnn36) THEN
       LET g_pnn[l_ac].pnn36 = g_pnn[l_ac].pnn12
       LET g_pnn[l_ac].pnn37 = g_pnn[l_ac].pnn09
    END IF
END FUNCTION

FUNCTION p520_check_inventory_qty()
DEFINE   t_pnn10         LIKE pnn_file.pnn10
DEFINE   t_pnn10t        LIKE pnn_file.pnn10t
DEFINE   l_pmk           RECORD LIKE pmk_file.*

   IF NOT cl_null(g_pnn[l_ac].pnn09) THEN
      IF g_pnn[l_ac].pnn09 < 1 THEN
         LET g_pnn[l_ac].pnn09 = g_pnn_t.pnn09
         RETURN 1
      END IF
      IF cl_null(g_pnn[l_ac].pnn10) OR g_pnn[l_ac].pnn10 = 0 THEN
         SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pml.pml01
         LET g_term = l_pmk.pmk41
         IF cl_null(g_term) THEN
            SELECT pmc49 INTO g_term
              FROM pmc_file
             WHERE pmc01 = g_pnn[l_ac].ima54
         END IF
         LET g_price = l_pmk.pmk20
         IF cl_null(g_price) THEN
            SELECT pmc17 INTO g_price
              FROM pmc_file
             WHERE pmc01 = g_pnn[l_ac].ima54
         END IF
         SELECT pmc47 INTO g_pmm.pmm21
         FROM pmc_file
         WHERE pmc01 =g_pnn[l_ac].ima54
         SELECT gec04 INTO g_pmm.pmm43
           FROM gec_file
          WHERE gec01 = g_pmm.pmm21
            AND gec011 = '1'  #進項 TQC-B70212 add

         CALL s_defprice_new(g_pnn[l_ac].pmn04,g_pnn[l_ac].ima54,
                         g_pnn[l_ac].pnn06,g_today,g_pnn[l_ac].pnn37,'',g_pmm.pmm21,
                         g_pmm.pmm43,'1',g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant)
            RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                      g_pmn.pmn73,g_pmn.pmn74

         CALL p520_price_check(g_pnn[l_ac].ima54,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_term,
                               g_pnn[l_ac].pml01,g_pnn[l_ac].pml02)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
           END IF
         IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF
         LET t_pnn10 = g_pnn[l_ac].pnn10
         LET t_pnn10t= g_pnn[l_ac].pnn10t
         IF NOT cl_null(g_pnn[l_ac].pnn18) AND
            NOT cl_null(g_pnn[l_ac].pnn19) THEN
            SELECT * INTO g_pon.* FROM pon_file
             WHERE pon01 = g_pnn[l_ac].pnn18
               AND pon02 = g_pnn[l_ac].pnn19

            CALL s_bkprice(t_pnn10,t_pnn10t,g_pon.pon31,g_pon.pon31t)
               RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
         END IF
         CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10
         CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t
         LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
         LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
         CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
         CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
      END IF
   END IF

   RETURN 0
END FUNCTION

FUNCTION p520_def_form()
   CALL cl_set_comp_visible("ima43,gen02,gen03,pnn16",FALSE)
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pnn33,pnn35,pnn30,pnn32",FALSE)
      CALL cl_set_comp_visible("pnn09",TRUE)
   ELSE
      CALL cl_set_comp_visible("pnn09",TRUE)
      CALL cl_set_comp_visible("pnn33,pnn35,pnn30,pnn32",TRUE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pnn33",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pnn35",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pnn30",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pnn32",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pnn33",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pnn35",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pnn30",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pnn32",g_msg CLIPPED)
   END IF
   CALL cl_set_comp_visible("pnn31,pnn34",FALSE)
   IF g_sma.sma116 MATCHES '[02]' THEN
       CALL cl_set_comp_visible("pnn36,pnn37",FALSE)
   END IF
END FUNCTION

FUNCTION p520_refresh_detail()
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


  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) AND (NOT cl_null(lg_smy62)) THEN

     IF g_pnn.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE

       FOR li_i = 1 TO g_pnn.getLength()


         IF  cl_null(g_pnn[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_pnn[li_i].att00

         IF cl_null(lg_group) THEN
            LET lg_group = l_compare

         ELSE

           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
       END FOR
     END IF

     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
     SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01 = g_prog AND gae02 = 'pnn03' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'pnn03'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'pnn03'
     END IF
     CALL lr_agc.clear()
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
      #      IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
      #      ELSE
      #         CALL cl_chg_comp_att("formonly.att" || lc_index,"NOENTRY|SCROLL","1|1")
      #      END IF
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
#            IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
#            ELSE
#               CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOENTRY|SCROLL","1|1")
#            END IF
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
           # IF g_sma.sma908 = 'Y' THEN
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           # ELSE
           #    CALL cl_chg_comp_att("formonly.att" || lc_index,"NOENTRY|SCROLL","1|1")
           # END IF
       END CASE
     END FOR

  ELSE
    LET li_i = 1
    LET ls_hide = 'att00'
    LET ls_show = 'pnn03'
  END IF
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)

END FUNCTION

FUNCTION p520_check_pnn03(p_field,p_ac,p_cmd) #No.MOD-660090
DEFINE
  p_field                     STRING,
  p_ac                        LIKE type_file.num5,

  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,
  ls_value                    STRING,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING,
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      VARCHAR(04),
  l_n                         LIKE type_file.num5,
  l_oeb06                     LIKE oeb_file.oeb06,
  l_b2                        LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima131                    LIKE ima_file.ima131,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       INTEGER,
  l_nul                       VARCHAR(01),
# p_cmd                       STRING   #No.MOD-660090 MARK
  p_cmd                       VARCHAR(01) #No.MOD-660090


  IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR
     ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR
     ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR
     ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN

     LET ls_pid = g_pnn[p_ac].att00
     LET ls_value = g_pnn[p_ac].att00
     IF cl_null(ls_pid) THEN
        CALL p520_set_no_entry_b()
        CALL p520_set_required()
        RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     END IF

     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
     IF l_cnt = 0 THEN
        CALL p520_set_no_entry_b()
        CALL p520_set_required()
         RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     END IF
     FOR li_i = 1 TO l_cnt

         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN
            CALL p520_set_no_entry_b()
            #FUN-540049  --begin
            CALL p520_set_required()
            #FUN-540049  --end

            RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
         END IF
     END FOR

     SELECT sma46 INTO l_ps FROM sma_file

     SELECT ima02 INTO ls_pname FROM ima_file   #
       WHERE ima01 = ls_pid
     LET ls_spec = ls_pname
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

     LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
     LET l_tmp = l_str_tok.nextToken()

     LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                  "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",
                  "ORDER BY agb02"
     DECLARE param_curs CURSOR FROM ls_sql
     FOREACH param_curs INTO lc_agb03

       IF cl_null(l_param_list) THEN
          LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
       ELSE
          LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
       END IF
     END FOREACH

     IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN

        LET ls_value_fld = ls_value
        INSERT INTO imx_file VALUES(ls_value_fld,ls_pid,arr_detail[p_ac].imx[1],
          arr_detail[p_ac].imx[2],arr_detail[p_ac].imx[3],arr_detail[p_ac].imx[4],
          arr_detail[p_ac].imx[5],arr_detail[p_ac].imx[6],arr_detail[p_ac].imx[7],
          arr_detail[p_ac].imx[8],arr_detail[p_ac].imx[9],arr_detail[p_ac].imx[10])

        IF SQLCA.sqlcode THEN
#          CALL cl_err('Failure to insert imx_file , rollback insert to ima_file !','',1)   #No.FUN-660129
           CALL cl_err3("ins","imx_file",ls_value_fld,ls_pid,SQLCA.sqlcode,
                        "","Failure to insert imx_file , rollback insert to ima_file !",1)  #No.FUN-660129
           DELETE FROM ima_file WHERE ima01 = ls_value_fld
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
        END IF
     END IF
     LET g_pnn[p_ac].pml04 = ls_value
  ELSE
    IF ( p_field <> 'pnn03' )AND( p_field <> 'imx00' ) THEN
       RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
    END IF
  END IF

  IF NOT cl_null(g_pnn[l_ac].pmn04) THEN


     RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  ELSE
     IF ( p_field = 'pnn03' )OR( p_field = 'imx00' ) THEN
        CALL p520_set_no_entry_b()
        CALL p520_set_required()
        CALL p520_ima02(p_cmd)
         RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     ELSE
       RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     END IF
  END IF
END FUNCTION

FUNCTION p520_check_att0x(p_value,p_index,p_row,p_cmd)
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,
  p_row        LIKE type_file.num5,
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
  p_cmd        VARCHAR(01),
  l_check_res     LIKE type_file.num5,
  l_b2            VARCHAR(30),
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,
  l_ima131        VARCHAR(10),
  l_ima25         LIKE ima_file.ima25

  IF cl_null(p_value) THEN
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF

  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF

  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL p520_check_pnn03('imx' || l_index ,p_row,p_cmd)  #No.MOD-660090
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
    RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
END FUNCTION

FUNCTION p520_check_att0x_c(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,
  p_row    LIKE type_file.num5,
  l_index  STRING,
  p_cmd    VARCHAR(01),
  l_check_res     LIKE type_file.num5,
  l_b2            VARCHAR(30),
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,
  l_ima131        VARCHAR(10),
  l_ima25         LIKE ima_file.ima25

  IF cl_null(p_value) THEN
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF

  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL p520_check_pnn03('imx'||l_index,p_row,p_cmd) #No.MOD-660090
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
END FUNCTION

FUNCTION p520_ima54_1()
   DEFINE l_pmcacti LIKE pmc_file.pmcacti,
          l_gec07   LIKE gec_file.gec07

   LET g_errno = ""
   SELECT pmc03,pmcacti,pmc47
     INTO g_pnn[l_ac].pmc03,l_pmcacti,g_pnn[l_ac].pmc47
     FROM pmc_file
    WHERE pmc01 = g_pnn[l_ac].ima54
   CASE
      WHEN SQLCA.sqlcode=100   LET g_errno  ='aap-000' #無此供應廠商, 請重新輸入!
                               LET l_pmcacti=NULL
      WHEN l_pmcacti='N'       LET g_errno='9028'
      WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
      OTHERWISE
         LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_pnn[l_ac].pmc47 IS NULL THEN
      SELECT pmk21 INTO g_pnn[l_ac].pmc47
        FROM pmk_file
       WHERE pmk01 = g_pml.pml01
   END IF

   SELECT azi03 INTO t_azi03 FROM azi_file
    WHERE azi01 = g_pnn[l_ac].pnn06
   SELECT gec04,gec07 INTO g_pnn[l_ac].gec04,l_gec07
     FROM gec_file
    WHERE gec01 = g_pnn[l_ac].pmc47
      AND gec011 = '1'  #進項
   IF SQLCA.sqlcode THEN
      LET g_errno = 'art-493'
   END IF

   IF l_gec07 = 'N' THEN
      CALL cl_set_comp_entry("pnn10t",FALSE)
   ELSE
      CALL cl_set_comp_entry("pnn10",FALSE)
   END IF
END FUNCTION

FUNCTION p520_price_check(p_pnn05,p_pnn10,p_pnn10t,p_term,p_pml01,p_pml02)
   DEFINE p_pnn05    LIKE pnn_file.pnn05
   DEFINE p_pnn10    LIKE pnn_file.pnn10
   DEFINE p_pnn10t   LIKE pnn_file.pnn10t
   DEFINE p_term     LIKE pmk_file.pmk41
   DEFINE p_pml01    LIKE pml_file.pml01
   DEFINE p_pml02    LIKE pml_file.pml02
   DEFINE l_pmc49    LIKE pmc_file.pmc49
   DEFINE l_pmc47    LIKE pmc_file.pmc47
   DEFINE l_pnz04    LIKE pnz_file.pnz04
   DEFINE l_pnz07    LIKE pnz_file.pnz07
   DEFINE l_gec07    LIKE gec_file.gec07
   DEFINE l_pnn03    LIKE pnn_file.pnn03

   IF NOT cl_null(p_pnn05) THEN
      SELECT pmc49,pmc47 INTO l_pmc49,l_pmc47 FROM pmc_file
       WHERE pmc01 = p_pnn05
      IF SQLCA.sqlcode THEN
      	 CALL cl_err( 'sel pmc49' , SQLCA.sqlcode,0)
      	 RETURN
      END IF
   END IF
   IF cl_null(p_term) THEN LET p_term = l_pmc49 END IF

   IF NOT cl_null(p_term) THEN
      SELECT pnz04,pnz07 INTO l_pnz04,l_pnz07 FROM pnz_file
       WHERE pnz01 = p_term
      IF SQLCA.sqlcode THEN
         CALL cl_err( 'sel pnz04' , SQLCA.sqlcode,0)
         RETURN
      END IF
   END IF

   SELECT gec07 INTO l_gec07
     FROM gec_file
    WHERE gec01 = l_pmc47
      AND gec011 = '1'  #進項
   IF cl_null(l_gec07) THEN LET l_gec07='N' END IF

   SELECT pnn03 INTO l_pnn03
     FROM pnn_file
    WHERE pnn01 = p_pml01 AND pnn02 = p_pml02
   IF l_pnn03[1,4] = 'MISC' THEN
      IF l_gec07 = 'Y' THEN   #含税
         CALL cl_set_comp_entry("pnn10",FALSE)
         CALL cl_set_comp_entry("pnn10t",TRUE)
      ELSE
         CALL cl_set_comp_entry("pnn10",TRUE)
         CALL cl_set_comp_entry("pnn10t",FALSE)
      END IF
      RETURN
   END IF

   IF l_gec07 = 'Y' THEN   #含税
      IF p_pnn10t = 0 OR cl_null(p_pnn10t) THEN
         #未取到含税单价
         IF l_pnz04 = 'Y'  THEN   #未取到单价可人工输入
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         END IF
      ELSE
         #有取到含税单价
         IF l_pnz07 = 'Y' THEN    #取到价格可修改
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         END IF
      END IF
   ELSE                    #不含税
      IF p_pnn10 = 0 OR cl_null(p_pnn10) THEN
         #未取到税前单价
         IF l_pnz04 = 'Y'  THEN   #未取到单价可人工输入
            CALL cl_set_comp_entry("pnn10",TRUE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         END IF
      ELSE
         #有取到税前单价
         IF l_pnz07 = 'Y' THEN    #取到价格可修改
            CALL cl_set_comp_entry("pnn10",TRUE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pnn10",FALSE)
            CALL cl_set_comp_entry("pnn10t",FALSE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION  p520_ima54(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_pmc22     LIKE pmc_file.pmc22,
       l_pmhacti   LIKE pmh_file.pmhacti,
       l_pmh11     LIKE pmh_file.pmh11,#MOD-580302
       l_pmh12     LIKE pmh_file.pmh12,#MOD-580302
       l_pmh13     LIKE pmh_file.pmh13 #MOD-580302
DEFINE l_ima915    LIKE ima_file.ima915  #FUN-710060 add
DEFINE l_pmk       RECORD LIKE pmk_file.*   #No.FUN-930148

    IF cl_null(g_pnn[l_ac].pnn06) THEN
       SELECT pmc22 INTO l_pmc22 FROM pmc_file
        WHERE pmc01 = g_pnn[l_ac].ima54
    ELSE
       LET l_pmc22 = g_pnn[l_ac].pnn06
    END IF

    LET g_errno = ' '
    SELECT pmh11,pmh12,pmh13,pmhacti
       INTO l_pmh11,l_pmh12,l_pmh13,l_pmhacti     #MOD-580302
      FROM pmh_file
     WHERE pmh01 = g_pnn[l_ac].pml04
       AND pmh02 = g_pnn[l_ac].ima54
       AND pmh13 = l_pmc22
       AND pmh21 = " "                                             #CHI-860042
       AND pmh22 = '1'                                             #CHI-860042
       AND pmh23 = ' '                                             #CHI-960033
       AND pmhacti = 'Y'                                           #CHI-910021

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3323'
         WHEN l_pmhacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_pnn[l_ac].pnn07) THEN LET g_pnn[l_ac].pnn07 = l_pmh11 DISPLAY BY NAME g_pnn[l_ac].pnn07 END IF
    IF cl_null(g_pnn[l_ac].pnn10) THEN LET g_pnn[l_ac].pnn10 = l_pmh12 DISPLAY BY NAME g_pnn[l_ac].pnn10 END IF
    IF cl_null(g_pnn[l_ac].pnn06) THEN LET g_pnn[l_ac].pnn06 = l_pmh13 DISPLAY BY NAME g_pnn[l_ac].pnn06 END IF

    SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pnn[l_ac].pml04  #FUN-710060 add
     IF l_ima915='0' OR l_ima915='1' THEN   #FUN-710060 mod
        LET g_errno = ' '
     END IF
    IF cl_null(g_errno) THEN #NO:6998,select pmh_file 無誤的才call s_defprice
       IF cl_null(g_pnn[l_ac].pnn10) OR g_pnn[l_ac].pnn10 = 0 THEN
          SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = g_pnn[l_ac].pml01
          LET g_term = l_pmk.pmk41
          IF cl_null(g_term) THEN
             SELECT pmc49 INTO g_term
               FROM pmc_file
              WHERE pmc01 = g_pnn[l_ac].ima54
          END IF
          LET g_price = l_pmk.pmk20
          IF cl_null(g_price) THEN
             SELECT pmc17 INTO g_price
              FROM pmc_file
              WHERE pmc01 = g_pnn[l_ac].ima54
          END IF
          SELECT pmc47 INTO g_pmm.pmm21
                     FROM pmc_file
                     WHERE pmc01 =g_pnn[l_ac].ima54
          SELECT gec04 INTO g_pmm.pmm43
            FROM gec_file
           WHERE gec01 = g_pmm.pmm21
             AND gec011 = '1'  #進項 TQC-B70212 add
          CALL s_defprice_new(g_pnn[l_ac].pml04,g_pnn[l_ac].ima54,
                         g_pnn[l_ac].pnn06,g_today,g_pnn[l_ac].pnn37,'',g_pmm.pmm21,
                         g_pmm.pmm43,'1',g_pnn[l_ac].pnn36,'',g_term,g_price,g_plant)
             RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,
                       g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
          IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
          CALL p520_price_check(g_pnn[l_ac].ima54,g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_term,
                                g_pnn[l_ac].pml01,g_pnn[l_ac].pml02)   #MOD-9C0285 ADD  #TQC-B80055 mod
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,1)
          END IF
       END IF   #MOD-A10185
       IF NOT cl_null(g_pnn[l_ac].pnn18) AND NOT cl_null(g_pnn[l_ac].pnn19) THEN
          SELECT * INTO g_pon.* FROM pon_file
             WHERE pon01 = g_pnn[l_ac].pnn18
               AND pon02 = g_pnn[l_ac].pnn19
          CALL s_bkprice(g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t,g_pon.pon31,g_pon.pon31t)
               RETURNING g_pnn[l_ac].pnn10,g_pnn[l_ac].pnn10t
       END IF
       CALL cl_digcut(g_pnn[l_ac].pnn10,t_azi03) RETURNING g_pnn[l_ac].pnn10
       CALL cl_digcut(g_pnn[l_ac].pnn10t,t_azi03) RETURNING g_pnn[l_ac].pnn10t
       LET g_pnn[l_ac].pnn38 = g_pnn[l_ac].pnn10 * g_pnn[l_ac].pnn37
       LET g_pnn[l_ac].pnn38t = g_pnn[l_ac].pnn10t * g_pnn[l_ac].pnn37
       CALL cl_digcut(g_pnn[l_ac].pnn38,t_azi03) RETURNING g_pnn[l_ac].pnn38
       CALL cl_digcut(g_pnn[l_ac].pnn38t,t_azi03) RETURNING g_pnn[l_ac].pnn38t
    END IF
END FUNCTION

REPORT p520_rep(l_pmh02,l_pmh11,l_pmh12,l_pmh13,l_pnn,
                l_pml20,l_pml80,l_pml81,l_pml82,l_pml83,l_pml84,l_pml85,
                l_pml86,l_pml87,l_pml34,l_ima44,l_ima54,l_pml07,l_ima021,
                l_pml21,l_tot,l_gec04)  #No.FUN-550089
DEFINE  l_pnn     RECORD LIKE pnn_file.*,
        l_pmh02   LIKE pmh_file.pmh02,
        l_pmh11   LIKE pmh_file.pmh11,
        l_pmh12   LIKE pmh_file.pmh12,
        l_pmh19   LIKE pmh_file.pmh19,  #No.FUN-610018
        l_pmh13   LIKE pmh_file.pmh13,
        l_pml20   LIKE pml_file.pml20,
        l_pml80         LIKE pml_file.pml80,
        l_pml81         LIKE pml_file.pml81,
        l_pml82         LIKE pml_file.pml82,
        l_pml83         LIKE pml_file.pml83,
        l_pml84         LIKE pml_file.pml84,
        l_pml85         LIKE pml_file.pml85,
        l_pml86         LIKE pml_file.pml86,
        l_pml87         LIKE pml_file.pml87,
        l_pml21         LIKE pml_file.pml21,
        l_pml34   LIKE pml_file.pml34,
        l_pml07   LIKE pml_file.pml07,
        l_ima44   LIKE ima_file.ima44,
        l_ima54   LIKE ima_file.ima54,
        l_ima021  LIKE ima_file.ima021,
        l_gec04          LIKE gec_file.gec04,       #No.FUN-550089
        l_cnt_tot,l_tot  LIKE pmh_file.pmh11,
        l_flag    LIKE type_file.num5,   #No.FUN-680136 SMALLINT
        l_qty     LIKE pnn_file.pnn09,
        l_qty_tot        LIKE pml_file.pml20,
        l_n              LIKE type_file.num5,    #No.FUN-680136 SMALLINT
        l_pnn10t         LIKE pnn_file.pnn10t,    #No.FUN-550089
        sr RECORD
                  choice   LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01)
                  supr     LIKE pmh_file.pmh02,   #No.FUN-680136 VARCHAR(10)
                  curr     LIKE pmh_file.pmh13,   #No.FUN-680136 VARCHAR(04)
                  price    LIKE pmh_file.pmh12,   #No.FUN-680136 dec(20,6) #FUN-4C0011
                  price_t  LIKE pmh_file.pmh12,   #No.FUN-680136 dec(20,6) #No.FUN-550089
                  rate     LIKE pmh_file.pmh11    #No.FUN-680136 dec(8,4)
        END RECORD
DEFINE  l_pmk       RECORD LIKE pmk_file.*      #No.FUN-930148

#ORDER EXTERNAL BY l_pnn.pnn01,l_pnn.pnn02,l_pnn.pnn03,l_pmh02,l_pmh13 #MOD-BB0252 mark
 ORDER BY l_pnn.pnn01,l_pnn.pnn02,l_pnn.pnn03,l_pmh02,l_pmh13 #MOD-BB0252 add  MOD-D50250 add ,l_pnn.pnn02
FORMAT
  BEFORE GROUP OF l_pmh02
   DELETE FROM p520_tmp

  AFTER GROUP OF l_pmh13
     SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pmh13   #No.CHI-6A0004
      SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = l_pnn.pnn01
      LET g_term = l_pmk.pmk41
      IF cl_null(g_term) THEN
         SELECT pmc49 INTO g_term
           FROM pmc_file
          WHERE pmc01 = l_pmh02
      END IF
      LET g_price = l_pmk.pmk20
      IF cl_null(g_price) THEN
         SELECT pmc17 INTO g_price
           FROM pmc_file
          WHERE pmc01 = l_pmh02
      END IF
      LET l_pnn.pnn36 = l_pml07
      SELECT pmc47 INTO g_pmm.pmm21
       FROM pmc_file
      WHERE pmc01 =l_pmh02
     SELECT gec04 INTO g_pmm.pmm43
       FROM gec_file
      WHERE gec01 = g_pmm.pmm21
        AND gec011 = '1'  #進項 TQC-B70212 add
     CALL s_defprice_new(l_pnn.pnn03,l_pmh02,l_pmh13,g_today,l_pnn.pnn37,'',g_pmm.pmm21,
                         g_pmm.pmm43,'1',l_pnn.pnn36,'',g_term,g_price,g_plant)
        RETURNING l_pmh12,l_pmh19,
                  g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
    #CALL p520_price_check(l_pmh02,l_pmh12,l_pmh19)      #MOD-9C0285 ADD
     CALL p520_price_check(l_pmh02,l_pmh12,l_pmh19,g_term,l_pnn.pnn01,l_pnn.pnn02)      #MOD-9C0285 ADD  #TQC-B80055 mod
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,1)
      END IF
     IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
     LET l_pmh12 = cl_digcut(l_pmh12,t_azi03)  #No.CHI-6A0004
     LET l_pnn10t = l_pmh19
     LET l_pnn10t = cl_digcut(l_pnn10t,t_azi03)  #No.CHI-6A0004
     INSERT INTO p520_tmp VALUES('N',l_pmh02,l_pmh13,l_pmh12,l_pnn10t,l_pmh11)

  AFTER GROUP OF l_pmh02
     SELECT COUNT(*) INTO l_n FROM p520_tmp
     IF l_n > 1 THEN
        #CALL p520_choice(l_pnn.pnn01,l_pnn.pnn03)
     ELSE
        UPDATE p520_tmp SET choice='Y'
     END IF
     LET l_cnt_tot=0
     LET l_qty_tot=0
     DECLARE tmp_cs CURSOR FOR
       SELECT * FROM p520_tmp WHERE choice='Y'
     FOREACH tmp_cs INTO sr.*
               LET l_pnn.pnn30 = l_pml80
               LET l_pnn.pnn31 = l_pml81
               LET l_pnn.pnn33 = l_pml83
               LET l_pnn.pnn34 = l_pml84
               LET l_pnn.pnn36 = l_pml86
               LET l_pnn.pnn37 = l_pml87   #No.MOD-5A0045
               LET l_pnn.pnn32 = l_pml82   #No.MOD-5A0045
               LET l_pnn.pnn35 = l_pml85   #No.MOD-5A0045
               #-->分配數量
               LET l_cnt_tot = l_cnt_tot + sr.rate
               IF l_cnt_tot = l_tot THEN
                  LET l_pnn.pnn09 = l_pml20 - l_qty_tot
                  IF l_pml21 > 0 THEN
                     CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn30)
                          RETURNING l_flag,g_factor
                     IF l_flag THEN
                         LET g_factor=1
                     END IF
                     LET l_pnn.pnn32 = l_pnn.pnn09 * g_factor
                     LET l_pnn.pnn35 = 0
                     CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn36)
                          RETURNING l_flag,g_factor
                     IF l_flag THEN
                         LET g_factor=1
                     END IF
                     LET l_pnn.pnn37 = l_pnn.pnn09 * g_factor
                  END IF
               ELSE
                  LET l_qty = l_pml20 * sr.rate /l_tot
                  LET l_pnn.pnn09 = l_qty
                  IF l_pml21 > 0 THEN
                     CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn30)
                          RETURNING l_flag,g_factor
                     IF l_flag THEN
                         LET g_factor=1
                     END IF
                     LET l_pnn.pnn32 = l_pnn.pnn09 * g_factor
                     LET l_pnn.pnn35 = 0
                     CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pnn.pnn36)
                          RETURNING l_flag,g_factor
                     IF l_flag THEN
                         LET g_factor=1
                     END IF
                     LET l_pnn.pnn37 = l_pnn.pnn09 * g_factor
                  ELSE
                     LET l_pnn.pnn32 = l_pml82 * sr.rate/l_tot
                     LET l_pnn.pnn35 = l_pml85 * sr.rate/l_tot
                     LET l_pnn.pnn37 = l_pml87 * sr.rate/l_tot
                  END IF
                  LET l_qty_tot = l_qty_tot + l_pnn.pnn09
               END IF
               LET l_pnn.pnn32 = s_digqty(l_pnn.pnn32,l_pnn.pnn30)   #FUN-910088--add--
               LET l_pnn.pnn35 = s_digqty(l_pnn.pnn35,l_pnn.pnn33)   #FUN-910088--add--
               LET l_pnn.pnn37 = s_digqty(l_pnn.pnn37,l_pnn.pnn36)   #FUN-910088--add--

               LET l_pnn.pnn05 = l_pmh02          #供應商
               LET l_pnn.pnn06 = sr.curr          #幣別
               LET l_pnn.pnn07 = sr.rate          #分配率
               LET l_pnn.pnn08 = 1                #單位替代量
               LET l_pnn.pnn10 = sr.price
               LET l_pnn.pnn10t= sr.price_t
               LET l_pnn.pnn12 = l_ima44          #採購單位
             #---增加單位換算(因要計算轉出量,故以請購->採購之換算率)
             CALL s_umfchk(l_pnn.pnn03,l_pml07,l_pnn.pnn12)
                 RETURNING l_flag,l_pnn.pnn17
             IF l_flag THEN
                 ### -----單位換算率抓不到-------####
                 CALL cl_err('pml07/pnn12: ','abm-731',1)
                 LET g_success ='N'
                 LET l_pnn.pnn17=1
             END IF
             LET l_pnn.pnn09=l_pnn.pnn09*l_pnn.pnn17
             LET l_pnn.pnn09 = s_digqty(l_pnn.pnn09,l_pnn.pnn12)   #FUN-910088--add--
             #---存換算率以採購對請購之換算率
             CALL s_umfchk(l_pnn.pnn03,l_pnn.pnn12,l_pml07)
                  RETURNING l_flag,l_pnn.pnn17
             IF l_flag THEN
                 ### ---單位換算率抓不到 -----#####
                 CALL cl_err('pnn12/pml07: ','abm-731',1)
                 LET g_success ='N'
                 LET l_pnn.pnn17=1
             END IF
               IF g_sma.sma116 MATCHES '[02]' THEN
                  LET l_pnn.pnn36=l_pnn.pnn12
                  LET l_pnn.pnn37=l_pnn.pnn09
               END IF
               SELECT ima43 INTO l_pnn.pnn15 FROM ima_file
                WHERE ima01 = l_pnn.pnn03
               LET l_pnn.pnn11 = l_pml34     #到廠日期
               IF l_pnn.pnn13 IS NULL OR l_pnn.pnn13 = ' ' THEN
                  LET l_pnn.pnn13 = '0'
               END IF
              IF cl_null(l_pnn.pnn05) THEN LET l_pnn.pnn05=' ' END IF
               LET l_pnn.pnn16 = "Y"
               CALL s_defprice_new(l_pnn.pnn03,l_pnn.pnn05,l_pnn.pnn06,g_today,l_pnn.pnn37,'',
                                   g_pmm.pmm21,g_pmm.pmm43,'1',l_pnn.pnn36,'',g_term,g_price,g_plant)
                  RETURNING l_pnn.pnn10,l_pnn.pnn10t,
                            g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add
               CALL p520_price_check(l_pnn.pnn05,l_pnn.pnn10,l_pnn.pnn10t,g_term,l_pnn.pnn01,l_pnn.pnn02)    #MOD-9C0285 ADD  #TQC-B80055 mod
               IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
               LET l_pnn.pnnplant = g_plant #FUN-980006 add
               LET l_pnn.pnnlegal = g_legal #FUN-980006 add
               LET l_pnn.pnn19 = NULL
               CALL cl_digcut(l_pnn.pnn10,t_azi03) RETURNING l_pnn.pnn10
               CALL cl_digcut(l_pnn.pnn10t,t_azi03) RETURNING l_pnn.pnn10t
               LET l_pnn.pnn38 = l_pnn.pnn10 * l_pnn.pnn37
               LET l_pnn.pnn38t = l_pnn.pnn10t * l_pnn.pnn37
               CALL cl_digcut(l_pnn.pnn38,t_azi03) RETURNING l_pnn.pnn38
               CALL cl_digcut(l_pnn.pnn38t,t_azi03) RETURNING l_pnn.pnn38t

               INSERT INTO pnn_file VALUES(l_pnn.*)
               IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN
                  CALL cl_err3("ins","pnn_file","","",SQLCA.sqlcode,"","ins pnn #2",0)  #No.FUN-660129
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               LET g_i = g_i + 1
    END FOREACH
END REPORT
#FUN-C50082
