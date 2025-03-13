# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aict030.4gl
# Descriptions...: New Code申請單維護作業
# Date & Author..: 07/12/12 By hellen No.FUN-7B0018
# Modify.........: No.FUN-830076 by hellen
# Modify.........: No.FUN-850068 08/05/15 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-920172 09/02/26 By jan 當 ica040='N' 時，則卡不可執行此程式 
# Modify.........: No.FUN-980004 09/08/21 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/17 By douzh 加上栏位为空的判断
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/22 By vealxu ima26x 調整
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.MOD-B30519 11/03/15 By jan ici020自動產生料號及BOM無法產生
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改	
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0106 12/02/04 by jason 新增s_aic_auto_no參數
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No.FUN-C30289 12/04/03 By bart 所有程式的Multi Die隱藏
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/12/18 By bart 1.刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D20059 12/03/26 By lujh 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_icw               RECORD LIKE icw_file.*         #NEW CODE申請單(單頭檔)
DEFINE g_icw_t             RECORD LIKE icw_file.*         #NEW CODE申請單(單頭舊值)
DEFINE g_icw_o             RECORD LIKE icw_file.*         #NEW CODE申請單(單頭舊值)
DEFINE g_icw01_t           LIKE icw_file.icw01            #單頭KEY單據編號舊值
DEFINE g_icx               DYNAMIC ARRAY OF RECORD        #NEW CODE申請單(單身檔)
         icx02             LIKE icx_file.icx02,           #項次
         icx03             LIKE icx_file.icx03,           #產品型號
         icx03_desc        LIKE ima_file.ima02,           #品名
         icx26             LIKE icx_file.icx26,           #子Code
         icx04             LIKE icx_file.icx04,           #NUMBER OF VOICE SECTION
         icx05             LIKE icx_file.icx05,           #NUMBER OF MELODY SECTION
         icx06             LIKE icx_file.icx06,           #NUMBER OF DATA SECTIONS
         icx07             LIKE icx_file.icx07,           #APROVED BY 0.EPROM 1.OTHER
         icx23             LIKE icx_file.icx23,           #Program Name
         icx08             LIKE icx_file.icx08,           #Program Date
         icx09             LIKE icx_file.icx09,           #Program Length
         icx24             LIKE icx_file.icx24,           #Eprom Name
         icx10             LIKE icx_file.icx10,           #Eprom Date
         icx11             LIKE icx_file.icx11,           #Eprom Length
         icx12             LIKE icx_file.icx12,           #Layout
         icx13             LIKE icx_file.icx13,           #Layout Date
         icx14             LIKE icx_file.icx14,           #Layout Size
         icx15             LIKE icx_file.icx15,           #Check Sum
         icx16             LIKE icx_file.icx16,           #Comment
         icx17             LIKE icx_file.icx17,           #CUSTOMER APPROVAL SIGNATURE
         icx18             LIKE icx_file.icx18,           #Remark
         icx19             LIKE icx_file.icx19,           #Multi Die比例
         icx20             LIKE icx_file.icx20,           #Status 0.New Code 1.Repeat Code
         icx21             LIKE icx_file.icx21,           #New Code否
         icx22             LIKE icx_file.icx22,           #版次
         #FUN-850068 --start---
         icxud01           LIKE icx_file.icxud01,
         icxud02           LIKE icx_file.icxud02,
         icxud03           LIKE icx_file.icxud03,
         icxud04           LIKE icx_file.icxud04,
         icxud05           LIKE icx_file.icxud05,
         icxud06           LIKE icx_file.icxud06,
         icxud07           LIKE icx_file.icxud07,
         icxud08           LIKE icx_file.icxud08,
         icxud09           LIKE icx_file.icxud09,
         icxud10           LIKE icx_file.icxud10,
         icxud11           LIKE icx_file.icxud11,
         icxud12           LIKE icx_file.icxud12,
         icxud13           LIKE icx_file.icxud13,
         icxud14           LIKE icx_file.icxud14,
         icxud15           LIKE icx_file.icxud15
         #FUN-850068 --end--
                           END RECORD,
       g_icx_t             RECORD                         #New Code申請單(單身檔舊值)
         icx02             LIKE icx_file.icx02,           #項次
         icx03             LIKE icx_file.icx03,           #產品型號
         icx03_desc        LIKE ima_file.ima02,           #品名
         icx26             LIKE icx_file.icx26,           #子Code
         icx04             LIKE icx_file.icx04,           #NUMBER OF VOICE SECTION
         icx05             LIKE icx_file.icx05,           #NUMBER OF MELODY SECTION
         icx06             LIKE icx_file.icx06,           #NUMBER OF DATA SECTIONS
         icx07             LIKE icx_file.icx07,           #APROVED BY 0.EPROM 1.OTHER
         icx23             LIKE icx_file.icx23,           #Program Name
         icx08             LIKE icx_file.icx08,           #Program Date
         icx09             LIKE icx_file.icx09,           #Program Length
         icx24             LIKE icx_file.icx24,           #Eprom Name
         icx10             LIKE icx_file.icx10,           #Eprom Date
         icx11             LIKE icx_file.icx11,           #Eprom Length
         icx12             LIKE icx_file.icx12,           #Layout
         icx13             LIKE icx_file.icx13,           #Layout Date
         icx14             LIKE icx_file.icx14,           #Layout Size
         icx15             LIKE icx_file.icx15,           #Check Sum
         icx16             LIKE icx_file.icx16,           #Comment
         icx17             LIKE icx_file.icx17,           #CUSTOMER APPROVAL SIGNATURE
         icx18             LIKE icx_file.icx18,           #Remark
         icx19             LIKE icx_file.icx19,           #Multi Die比例
         icx20             LIKE icx_file.icx20,           #Status 0.New Code 1.Repeat Code
         icx21             LIKE icx_file.icx21,           #New Code否
         icx22             LIKE icx_file.icx22,           #版次
         #FUN-850068 --start---
         icxud01           LIKE icx_file.icxud01,
         icxud02           LIKE icx_file.icxud02,
         icxud03           LIKE icx_file.icxud03,
         icxud04           LIKE icx_file.icxud04,
         icxud05           LIKE icx_file.icxud05,
         icxud06           LIKE icx_file.icxud06,
         icxud07           LIKE icx_file.icxud07,
         icxud08           LIKE icx_file.icxud08,
         icxud09           LIKE icx_file.icxud09,
         icxud10           LIKE icx_file.icxud10,
         icxud11           LIKE icx_file.icxud11,
         icxud12           LIKE icx_file.icxud12,
         icxud13           LIKE icx_file.icxud13,
         icxud14           LIKE icx_file.icxud14,
         icxud15           LIKE icx_file.icxud15
         #FUN-850068 --end--
                           END RECORD,
       g_icx_o             RECORD                         #New Code申請單(單身檔舊值)
         icx02             LIKE icx_file.icx02,           #項次
         icx03             LIKE icx_file.icx03,           #產品型號
         icx03_desc        LIKE ima_file.ima02,           #品名
         icx26             LIKE icx_file.icx26,           #子Code
         icx04             LIKE icx_file.icx04,           #NUMBER OF VOICE SECTION
         icx05             LIKE icx_file.icx05,           #NUMBER OF MELODY SECTION
         icx06             LIKE icx_file.icx06,           #NUMBER OF DATA SECTIONS
         icx07             LIKE icx_file.icx07,           #APROVED BY 0.EPROM 1.OTHER
         icx23             LIKE icx_file.icx23,           #Program Name
         icx08             LIKE icx_file.icx08,           #Program Date
         icx09             LIKE icx_file.icx09,           #Program Length
         icx24             LIKE icx_file.icx24,           #Eprom Name
         icx10             LIKE icx_file.icx10,           #Eprom Date
         icx11             LIKE icx_file.icx11,           #Eprom Length
         icx12             LIKE icx_file.icx12,           #Layout
         icx13             LIKE icx_file.icx13,           #Layout Date
         icx14             LIKE icx_file.icx14,           #Layout Size
         icx15             LIKE icx_file.icx15,           #Check Sum
         icx16             LIKE icx_file.icx16,           #Comment
         icx17             LIKE icx_file.icx17,           #CUSTOMER APPROVAL SIGNATURE
         icx18             LIKE icx_file.icx18,           #Remark
         icx19             LIKE icx_file.icx19,           #Multi Die比例
         icx20             LIKE icx_file.icx20,           #Status 0.New Code 1.Repeat Code
         icx21             LIKE icx_file.icx21,           #New Code否
         icx22             LIKE icx_file.icx22,           #版次
         #FUN-850068 --start---
         icxud01           LIKE icx_file.icxud01,
         icxud02           LIKE icx_file.icxud02,
         icxud03           LIKE icx_file.icxud03,
         icxud04           LIKE icx_file.icxud04,
         icxud05           LIKE icx_file.icxud05,
         icxud06           LIKE icx_file.icxud06,
         icxud07           LIKE icx_file.icxud07,
         icxud08           LIKE icx_file.icxud08,
         icxud09           LIKE icx_file.icxud09,
         icxud10           LIKE icx_file.icxud10,
         icxud11           LIKE icx_file.icxud11,
         icxud12           LIKE icx_file.icxud12,
         icxud13           LIKE icx_file.icxud13,
         icxud14           LIKE icx_file.icxud14,
         icxud15           LIKE icx_file.icxud15
         #FUN-850068 --end--
                           END RECORD
DEFINE g_t1                LIKE type_file.chr5
DEFINE g_imaicd01          LIKE imaicd_file.imaicd01
DEFINE g_icb02             LIKE icb_file.icb02
DEFINE g_icx19_sum         LIKE icx_file.icx19
DEFINE g_argv1             LIKE icw_file.icw05
DEFINE g_status            LIKE type_file.chr1
DEFINE g_copy              LIKE type_file.chr1
DEFINE g_sql               STRING
DEFINE g_wc                STRING                         #單頭CONSTRUCT結果
DEFINE g_wc2               STRING                         #單身CONSTRUCT結果
DEFINE g_rec_b             LIKE type_file.num5            #單身筆數
DEFINE l_ac                LIKE type_file.num5            #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5            #count/index for any purpose
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10           #總筆數
DEFINE g_jump              LIKE type_file.num10           #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num5            #是否開啟指定筆數視窗
DEFINE g_table             STRING
DEFINE g_str               STRING
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_close             LIKE type_file.chr1
DEFINE g_void              LIKE type_file.chr1
 
MAIN
   DEFINE l_ica40          LIKE ica_file.ica40            #FUN-920172
 
   OPTIONS                                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('icd') THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF
 
   #FUN-920172--BEGIN--
   SELECT ica40 INTO l_ica40 FROM ica_file WHERE ica00 = '0'
   IF l_ica40 = 'N' THEN
      CALL cl_err('','aic-911',1)
      EXIT PROGRAM
   END IF
   #FUN-920172--END--
 
   LET g_argv1 = ARG_VAL(1)
 
   LET g_sql= "icw01.icw_file.icw01,",
              "icw02.icw_file.icw02,",
              "occ02.occ_file.occ02,",
              "icw03.icw_file.icw03,",
              "gen02.gen_file.gen02,",
              "icw04.icw_file.icw04,",
              "gem02.gem_file.gem02,",
              "icw05.icw_file.icw05,",
              "icw05_desc.ima_file.ima02,",
              "icw06.icw_file.icw06,",
              "icw10.icw_file.icw10,",
              "icw22.icw_file.icw22,",
              "icw22_desc.ima_file.ima02,",
              "icw23.icw_file.icw23,",
              "icw13.icw_file.icw13,",
              "icw14.icw_file.icw14,",
              "icw15.icw_file.icw15,",
              "icw16.icw_file.icw16,",
              "icw18.icw_file.icw18,",
              "icx02.icx_file.icx02,",
              "icx03.icx_file.icx03,",
              "icx03_desc.ima_file.ima02,",
              "icx26.icx_file.icx26,",
              "icx04.icx_file.icx04,",
              "icx05.icx_file.icx05,",
              "icx06.icx_file.icx06,",
              "icx07.icx_file.icx07,",
              "icx23.icx_file.icx23,",
              "icx08.icx_file.icx08,",
              "icx09.icx_file.icx09,",
              "icx24.icx_file.icx24,",
              "icx10.icx_file.icx10,",
              "icx11.icx_file.icx11,",
              "icx12.icx_file.icx12,",
              "icx13.icx_file.icx13,",
              "icx14.icx_file.icx14,",
              "icx15.icx_file.icx15,",
              "icx16.icx_file.icx16,",
              "icx17.icx_file.icx17,",
              "icx18.icx_file.icx18,",
              "icx19.icx_file.icx19,",
              "icx20.icx_file.icx20,",
              "icx21.icx_file.icx21,",
              "icx22.icx_file.icx22"
   LET g_table=cl_prt_temptable("aict030",g_sql) CLIPPED
   IF g_table=-1 THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,g_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,",
             "        ?,?,?,?,?,?,?,?,?,?,",
             "        ?,?,?,?,?,?,?,?,?,?,",
             "        ?,?,?,?,?,?,?,?,?,?,",
             "        ?,?,?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
     CALL cl_err("insert_prep:",status,1)
   END IF
 
   LET g_forupd_sql = " SELECT * FROM icw_file  WHERE icw01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t030_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t030_w WITH FORM "aic/42f/aict030"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_set_comp_visible("dummy1,icw06,icx19",FALSE)  #FUN-C30289
 
   CALL t030_menu()
 
   CLOSE WINDOW t030_w                                    #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t030_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   DEFINE l_icw01     LIKE icw_file.icw01
 
   CLEAR FORM                                             #清除畫面
   CALL g_icx.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = NULL
      LET g_wc2 = NULL
      IF g_status = '1' THEN
         LET g_wc = "icw05 = '",g_argv1 CLIPPED,"'"
         LET g_wc2 = " 1=1"
      ELSE
         DECLARE t030_arg_cs CURSOR FOR
          SELECT DISTINCT icw01
            FROM icw_file,icx_file
           WHERE icw01 = icx01
             AND icx03 = g_argv1
 
         LET g_cnt = 0
         FOREACH t030_arg_cs INTO l_icw01
            LET g_cnt = g_cnt + 1
            IF g_cnt > 1 THEN
               LET g_wc = g_wc CLIPPED,","
            END IF
            LET g_wc = g_wc CLIPPED,"'",l_icw01 CLIPPED,"'"
         END FOREACH
         IF g_cnt > 0 THEN
            LET g_wc = "icw01 IN (",g_wc CLIPPED,")"
         ELSE
            LET g_wc = "icw01 = '@'"
         END IF
         LET g_wc2 = " 1=1"
      END IF
   ELSE
      CONSTRUCT BY NAME g_wc ON icw01,icw02,icw03,icw04,icw05,
                                icw06,icw10,icw22,icw23,icw14,
                                icw15,icw16,icw18,icwuser,icwgrup,
                                icwacti,icwmodu,icwdate,
                                #FUN-850068   ---start---
                                icwud01,icwud02,icwud03,icwud04,icwud05,
                                icwud06,icwud07,icwud08,icwud09,icwud10,
                                icwud11,icwud12,icwud13,icwud14,icwud15
                                #FUN-850068    ----end----
 
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(icw01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_icw01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icw01
                    NEXT FIELD icw01
               WHEN INFIELD(icw02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icw02
                    NEXT FIELD icw02
               WHEN INFIELD(icw03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icw03
                    NEXT FIELD icw03
               WHEN INFIELD(icw04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icw04
                    NEXT FIELD icw04
               WHEN INFIELD(icw05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_imaicd2"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icw05
                    NEXT FIELD icw05
               WHEN INFIELD(icwuser)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icwuser
                    NEXT FIELD icwuser
               WHEN INFIELD(icwmodu)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icwmodu
                    NEXT FIELD icwmodu
               WHEN INFIELD(icwgrup)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icwgrup
                    NEXT FIELD icwgrup
               OTHERWISE EXIT CASE
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
 
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON icx02,icx03,icx26,icx04,icx05,icx06,
                         icx07,icx23,icx08,icx09,icx24,icx10,
                         icx11,icx12,icx13,icx14,icx15,icx16,
                         icx17,icx18,icx19,icx20,icx21,icx22
                         #No.FUN-850068 --start--
                         ,icxud01,icxud02,icxud03,icxud04,icxud05
                         ,icxud06,icxud07,icxud08,icxud09,icxud10
                         ,icxud11,icxud12,icxud13,icxud14,icxud15
                         #No.FUN-850068 ---end---
                    FROM s_icx[1].icx02,s_icx[1].icx03,s_icx[1].icx26,
                         s_icx[1].icx04,s_icx[1].icx05,s_icx[1].icx06,
                         s_icx[1].icx07,s_icx[1].icx23,s_icx[1].icx08,
                         s_icx[1].icx09,s_icx[1].icx24,s_icx[1].icx10,
                         s_icx[1].icx11,s_icx[1].icx12,s_icx[1].icx13,
                         s_icx[1].icx14,s_icx[1].icx15,s_icx[1].icx16,
                         s_icx[1].icx17,s_icx[1].icx18,s_icx[1].icx19,
                         s_icx[1].icx20,s_icx[1].icx21,s_icx[1].icx22
                         #No.FUN-850068 --start--
                         ,s_icx[1].icxud01,s_icx[1].icxud02,s_icx[1].icxud03
                         ,s_icx[1].icxud04,s_icx[1].icxud05,s_icx[1].icxud06
                         ,s_icx[1].icxud07,s_icx[1].icxud08,s_icx[1].icxud09
                         ,s_icx[1].icxud10,s_icx[1].icxud11,s_icx[1].icxud12
                         ,s_icx[1].icxud13,s_icx[1].icxud14,s_icx[1].icxud15
                         #No.FUN-850068 ---end---
 
         BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(icx03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_imaicd2"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO icx03
                    NEXT FIELD icx03
               OTHERWISE EXIT CASE
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                                    #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND icwuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                                    #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND icwgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND icwgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icwuser', 'icwgrup')
   #End:FUN-980030
 
   IF g_wc2 = " 1=1" THEN                                 #若單身未輸入條件
      LET g_sql = "SELECT icw01 FROM icw_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY icw01"
   ELSE                                                   #若單身有輸入條件
      LET g_sql = "SELECT UNIQUE icw_file.icw01 ",
                  "  FROM icw_file,icx_file ",
                  " WHERE icw01 = icx01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED,
                  " ORDER BY icw01"
   END IF
   PREPARE t030_prepare FROM g_sql
   DECLARE t030_cs                                        #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t030_prepare
 
   IF g_wc2 = " 1=1" THEN                                 #取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM icw_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT icw01) ",
                "  FROM icw_file,icx_file ",
                " WHERE icx01 = icw01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE t030_precount FROM g_sql
   DECLARE t030_count CURSOR FOR t030_precount
 
END FUNCTION
 
FUNCTION t030_menu()
   DEFINE l_cmd STRING
 
   WHILE TRUE
      CALL t030_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t030_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t030_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t030_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t030_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t030_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t030_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t030_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t030_out()
            END IF
            
         WHEN "icd_processitem"       #CODE產生
            IF cl_chk_act_auth() THEN                                                        
               LET l_cmd = "aici020 '",g_icw.icw22,"' '",g_icw.icw01,"'"  #MOD-B30519                          
               CALL cl_cmdrun_wait(l_cmd)                                       
            END IF
    
         WHEN "code_generate"         #CODE產生
            IF cl_chk_act_auth() THEN
               CALL t030_code()
            END IF
 
         WHEN "sale_confirm"          #銷售確認
            IF cl_chk_act_auth() THEN
               CALL t030_sale_y()
            END IF
            CALL t030_pic()           #圖形顯示
 
         WHEN "undo_sale_confirm"     #取消銷售確認
            IF cl_chk_act_auth() THEN
               CALL t030_sale_z()
            END IF
            CALL t030_pic()           #圖形顯示
 
         WHEN "code_mask"             #光罩料號產生
            IF cl_chk_act_auth() THEN
               CALL t030_mask()
            END IF
 
         WHEN "code_routing_wafer"    #WAFER料號及制程料號產生
            IF cl_chk_act_auth() THEN
               CALL t030_wafer()
            END IF
 
         WHEN "maintain_mask"         #維護光罩資料
            IF cl_chk_act_auth() THEN
               CALL t030_maintain()
            END IF
 
         WHEN "mask_group"            #光罩群組維護
            IF cl_chk_act_auth() THEN
               CALL t030_group()
            END IF
 
         WHEN "void"                  #作廢/取消作廢
            IF cl_chk_act_auth() THEN
            #  CALL t030_v()    #CHI-D20010
               CALL t030_v(1)   #CHI-D20010
            END IF
            CALL t030_pic()           #圖形顯示

         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
             # CALL t030_v()    #CHI-D20010
               CALL t030_v(2)   #CHI-D20010
            END IF
            CALL t030_pic()
         #CHI-D20010---end
 
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_icw.icw01) THEN
                  LET g_doc.column1 = "icw01"
                  LET g_doc.value1 = g_icw.icw01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icx),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t030_bp(p_ud)
   DEFINE   p_ud   VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_icx TO s_icx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL t030_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t030_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t030_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t030_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t030_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
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
         
      ON ACTION icd_processitem                                                 
         LET g_action_choice="icd_processitem"
         EXIT DISPLAY    
 
      ON ACTION code_generate      #CODE 產生
         LET g_action_choice="code_generate"
         EXIT DISPLAY
 
      ON ACTION sale_confirm       #銷售確認
         LET g_action_choice="sale_confirm"
         EXIT DISPLAY
 
      ON ACTION undo_sale_confirm  #取消銷售確認
         LET g_action_choice="undo_sale_confirm"
         EXIT DISPLAY
 
      ON ACTION code_mask          #光罩料號產生
         LET g_action_choice="code_mask"
         EXIT DISPLAY
 
      ON ACTION code_routing_wafer #WAFER料號及制程料號產生
         LET g_action_choice="code_routing_wafer"
         EXIT DISPLAY
 
      ON ACTION maintain_mask      #光罩資料維護
         LET g_action_choice="maintain_mask"
         EXIT DISPLAY
 
      ON ACTION mask_group         #光罩群組維護
         LET g_action_choice="mask_group"
         EXIT DISPLAY
 
      ON ACTION void               #作廢
         LET g_action_choice="void"
         EXIT DISPLAY
    
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL t030_pic()               #圖形顯示
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
FUNCTION t030_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_icx.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_icw.* LIKE icw_file.*                     #DEFAULT 設定
   LET g_icw01_t = NULL
 
   #預設值及將數值變數清為零
   LET g_icw.icw06 = 'N'
#  LET g_icw.icwmksg = 'N'
   LET g_icw.icw10 = 'N'
   LET g_icw.icw14 = g_today
   LET g_icw.icw18 = 'N'
   LET g_icw_t.* = g_icw.*
   LET g_icw_o.* = g_icw.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_icw.icwuser=g_user
      LET g_icw.icworiu = g_user #FUN-980030
      LET g_icw.icworig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_icw.icwgrup=g_grup
      LET g_icw.icwdate=g_today
      LET g_icw.icwacti='Y'                               #資料有效
 
      CALL t030_i("a")                                    #輸入單頭
      IF INT_FLAG THEN                                    #使用者不玩了
         LET INT_FLAG = 0
         INITIALIZE g_icw.* TO NULL
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_icw.icw01) THEN                        #KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入后，若該單據需要自動編號，并且其單號為空白，則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("axm",g_icw.icw01,g_icw.icw14,"","icw_file","icw01","","","")
           RETURNING li_result,g_icw.icw01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_icw.icw01
 
      LET g_icw.icwplant = g_plant #FUN-980004
      LET g_icw.icwlegal = g_legal #FUN-980004
      INSERT INTO icw_file VALUES (g_icw.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_icw.icw01,SQLCA.sqlcode,1)   #FUN-B80083 ADD
         ROLLBACK WORK
        # CALL cl_err(g_icw.icw01,SQLCA.sqlcode,1)   #FUN-B80083 MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
 
      SELECT icw01 INTO g_icw.icw01
        FROM icw_file
       WHERE icw01 = g_icw.icw01
 
      LET g_icw01_t = g_icw.icw01                         #保留舊值
      LET g_icw_t.* = g_icw.*
      LET g_icw_o.* = g_icw.*
      CALL g_icx.clear()
 
      IF g_icw.icw06 = 'N' THEN
         CALL t030_g_b()
      ELSE
         LET g_rec_b = 0
      END IF
      CALL t030_b()                                       #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t030_g_b()
  DEFINE  l_icx   RECORD LIKE icx_file.*
 
  INITIALIZE l_icx.* TO NULL
 
  LET l_icx.icx01 = g_icw.icw01
  LET l_icx.icx02 = 1
  LET l_icx.icx03 = g_icw.icw05
  LET l_icx.icx07 = '0'
  LET l_icx.icx19 = 1
  LET l_icx.icx20 = '0'
  LET l_icx.icx21 = 'Y'
  LET l_icx.icxplant = g_plant #FUN-980004
  LET l_icx.icxlegal = g_legal #FUN-980004
 
  INSERT INTO icx_file VALUES(l_icx.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
     CALL cl_err('ins icx:',SQLCA.SQLCODE,0)
     RETURN
  END IF
 
  CALL t030_b_fill(' 1=1')
 
END FUNCTION
 
FUNCTION t030_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.*
     FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 != 'N' THEN
      IF g_icw.icw18 = 'Y' THEN
         CALL cl_err(g_icw.icw01,'9023',0)
         RETURN
      END IF
      IF g_icw.icw18 = 'X' THEN
         CALL cl_err(g_icw.icw01,'9024',0)
         RETURN
      END IF
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_icw01_t = g_icw.icw01
 
   BEGIN WORK
 
   OPEN t030_cl USING g_icw.icw01
   IF STATUS THEN
      CALL cl_err("OPEN t030_cl:",STATUS,1)
      CLOSE t030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t030_cl INTO g_icw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
      CLOSE t030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t030_show()
   WHILE TRUE
      LET g_icw01_t = g_icw.icw01
      LET g_icw_o.* = g_icw.*
      LET g_icw.icwmodu = g_user
      LET g_icw.icwdate = g_today
 
      CALL t030_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_icw.* = g_icw_t.*
         CALL t030_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_icw.icw01 != g_icw01_t THEN
         UPDATE icx_file
            SET icx01 = g_icw.icw01
          WHERE icx01 = g_icw01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('icx',SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE icw_file
      SET icw_file.* = g_icw.*
    WHERE icw01 = g_icw01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t030_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t030_i(p_cmd)
DEFINE  p_cmd          LIKE type_file.chr1
DEFINE  l_cnt          LIKE type_file.num5
DEFINE  l_oayapr       LIKE oay_file.oayapr
DEFINE  li_result      LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   DISPLAY BY NAME g_icw.icw01,g_icw.icw02,g_icw.icw03,
                   g_icw.icw04,g_icw.icw05,g_icw.icw06,
                   g_icw.icw10,g_icw.icw22,g_icw.icw23,
                   g_icw.icw13,g_icw.icw14,g_icw.icw15,
                   g_icw.icw16,g_icw.icw18,g_icw.icwuser,
                   g_icw.icwgrup,g_icw.icwacti,
                   g_icw.icwdate,g_icw.icwmodu
 
   INPUT BY NAME   g_icw.icw01,g_icw.icw02,g_icw.icw03, g_icw.icworiu,g_icw.icworig,
                   g_icw.icw04,g_icw.icw05,g_icw.icw06,
                   g_icw.icw10,g_icw.icw22,g_icw.icw23,
                   g_icw.icw13,g_icw.icw14,g_icw.icw15,
                   g_icw.icw16,g_icw.icw18,
                   #FUN-850068     ---start---
                   g_icw.icwud01,g_icw.icwud02,g_icw.icwud03,g_icw.icwud04,
                   g_icw.icwud05,g_icw.icwud06,g_icw.icwud07,g_icw.icwud08,
                   g_icw.icwud09,g_icw.icwud10,g_icw.icwud11,g_icw.icwud12,
                   g_icw.icwud13,g_icw.icwud14,g_icw.icwud15 
                   #FUN-850068     ----end----
                   WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t030_set_entry(p_cmd)
         CALL t030_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("icw01")
 
      AFTER FIELD icw01
         IF NOT cl_null(g_icw.icw01) THEN
            CALL s_check_no("axm",g_icw.icw01,g_icw01_t,"12",
                            "icw_file","icw01","")
                 RETURNING li_result,g_icw.icw01
            DISPLAY BY NAME g_icw.icw01
            IF (NOT li_result) THEN
               LET g_icw.icw01 = g_icw_o.icw01
               NEXT FIELD icw01
            END IF
 
            LET g_t1 = g_icw.icw01[1,3]
 
            LET l_oayapr = NULL
            SELECT oayapr INTO l_oayapr
              FROM oay_file
             WHERE oayslip = g_t1
#           LET g_icw.icwmksg = l_oayapr
#           DISPLAY BY NAME g_icw.icwmksg
         END IF
 
      AFTER FIELD icw02
         IF NOT cl_null(g_icw.icw02) THEN
            IF cl_null(g_icw_o.icw02) OR
              (p_cmd = "u" AND g_icw.icw02 != g_icw_o.icw02) THEN
               CALL t030_icw02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_icw.icw02,g_errno,0)
                  LET g_icw.icw02 = g_icw_o.icw02
                  DISPLAY BY NAME g_icw.icw02
                  NEXT FIELD icw02
               END IF
            END IF
         ELSE
            DISPLAY ' ' TO FORMONLY.occ02
         END IF
         LET g_icw_o.icw02 = g_icw.icw02
 
      AFTER FIELD icw03
         IF NOT cl_null(g_icw.icw03) THEN
            IF cl_null(g_icw_o.icw03) OR
              (p_cmd = "u" AND g_icw.icw03 != g_icw_o.icw03) THEN
               CALL t030_icw03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_icw.icw03,g_errno,0)
                  LET g_icw.icw03 = g_icw_o.icw03
                  DISPLAY BY NAME g_icw.icw03
                  NEXT FIELD icw03
               END IF
            END IF
         ELSE
            DISPLAY ' ' TO FORMONLY.gen02
         END IF
         LET g_icw_o.icw03 = g_icw.icw03
 
      AFTER FIELD icw04
         IF NOT cl_null(g_icw.icw04) THEN
            IF cl_null(g_icw_o.icw04) OR
              (p_cmd = "u" AND g_icw.icw04 != g_icw_o.icw04) THEN
               CALL t030_icw04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_icw.icw04,g_errno,0)
                  LET g_icw.icw04 = g_icw_o.icw04
                  DISPLAY BY NAME g_icw.icw04
                  NEXT FIELD icw04
               END IF
            END IF
         ELSE
            DISPLAY ' ' TO FORMONLY.gem02
         END IF
         LET g_icw_o.icw04 = g_icw.icw04
 
      AFTER FIELD icw05
         IF NOT cl_null(g_icw.icw05) THEN
           #FUN-AA0059 -----------------add start--------
            IF NOT s_chk_item_no(g_icw.icw05,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_icw.icw05 = g_icw_o.icw05
               DISPLAY BY NAME g_icw.icw05
               NEXT FIELD icw05
            END IF
           #FUN-AA0059 ----------------add end-------------
            IF cl_null(g_icw_o.icw05) OR
              (p_cmd = "u" AND g_icw.icw05 != g_icw_o.icw05) THEN
               CALL t030_icw05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_icw.icw05,g_errno,0)
                  LET g_icw.icw05 = g_icw_o.icw05
                  DISPLAY BY NAME g_icw.icw05
                  NEXT FIELD icw05
               END IF
            END IF
         ELSE
            DISPLAY ' ' TO FORMONLY.icw05_desc
         END IF
         LET g_icw_o.icw05 = g_icw.icw05
 
      AFTER FIELD icw06
         IF NOT cl_null(g_icw.icw06) THEN
            IF g_icw.icw06 NOT MATCHES '[YN]' THEN
               NEXT FIELD icw06
            END IF
            IF (p_cmd = 'u' AND
                g_icw.icw06 != g_icw_o.icw06) THEN
                IF g_icw.icw06 = 'N' THEN
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt
                     FROM icx_file
                    WHERE icx01 = g_icw.icw01
                   IF l_cnt != 1 THEN
                      CALL cl_err('','aic-960',0)
                      LET g_icw.icw06 = g_icw_o.icw06
                      DISPLAY BY NAME g_icw.icw06
                      NEXT FIELD icw06
                   ELSE
                      LET l_cnt = 0
                      SELECT COUNT(*) INTO l_cnt
                        FROM icx_file
                       WHERE icx01 = g_icw.icw01
                         AND icx19 = 1
                      IF l_cnt = 0 THEN
                         CALL cl_err('','aic-960',0)
                         LET g_icw.icw06 = g_icw_o.icw06
                         DISPLAY BY NAME g_icw.icw06
                         NEXT FIELD icw06
                      END IF
                   END IF
                END IF
            END IF
         END IF
         LET g_icw_o.icw06 = g_icw.icw06
 
 
      #FUN-850068     ---start---
      AFTER FIELD icwud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD icwud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-850068     ----end----
 
      AFTER INPUT
         LET g_icw.icwuser = s_get_data_owner("icw_file") #FUN-C10039
         LET g_icw.icwgrup = s_get_data_group("icw_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM icw_file
          WHERE icw05 = g_icw.icw05
            AND icw18 != 'X'
            AND icw01 != g_icw.icw01
         IF l_cnt > 0 THEN
            CALL cl_err(g_icw.icw05,'aic-961',0)
            NEXT FIELD icw05
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icw01)
                 LET g_t1 = s_get_doc_no(g_icw.icw01)
                 CALL q_oay(FALSE,FALSE,g_t1,'12','axm') RETURNING g_t1   #FUN-A70130      
                 LET g_icw.icw01 = g_t1
                 DISPLAY BY NAME g_icw.icw01
                 NEXT FIELD icw01
            WHEN INFIELD(icw02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_icw.icw02
                 CALL cl_create_qry() RETURNING g_icw.icw02
                 DISPLAY BY NAME g_icw.icw02
                 NEXT FIELD icw02
            WHEN INFIELD(icw03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_icw.icw03
                 CALL cl_create_qry() RETURNING g_icw.icw03
                 DISPLAY BY NAME g_icw.icw03
                 NEXT FIELD icw03
            WHEN INFIELD(icw04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_icw.icw04
                 CALL cl_create_qry() RETURNING g_icw.icw04
                 DISPLAY BY NAME g_icw.icw04
                 NEXT FIELD icw04
            WHEN INFIELD(icw05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_imaicd2"
                 LET g_qryparam.default1 = g_icw.icw05
                 CALL cl_create_qry() RETURNING g_icw.icw05
                 DISPLAY BY NAME g_icw.icw05
                 NEXT FIELD icw05
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t030_icw02(p_cmd)
  DEFINE  p_cmd      LIKE type_file.chr1
  DEFINE  l_occ02    LIKE occ_file.occ02
  DEFINE  l_occ04    LIKE occ_file.occ04
  DEFINE  l_occacti  LIKE occ_file.occacti
  DEFINE  l_gen02    LIKE gen_file.gen02
  DEFINE  l_gen03    LIKE gen_file.gen03
  DEFINE  l_gem02    LIKE gem_file.gem02
 
  LET g_errno = ''
 
  SELECT occ02,occ04,occacti
    INTO l_occ02,l_occ04,l_occacti
    FROM occ_file
   WHERE occ01 = g_icw.icw02
 
  IF p_cmd = 'a' THEN
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2732'
       WHEN l_occacti = 'N'     LET g_errno = '9028'
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '------'
     END CASE
  END IF
 
  IF p_cmd = 'd' OR cl_null(g_errno) THEN
     DISPLAY l_occ02 TO FORMONLY.occ02
     IF cl_null(g_icw.icw03) THEN
        LET g_icw.icw03 = l_occ04
        SELECT gen02,gen03 INTO l_gen02,l_gen03
          FROM gen_file
         WHERE gen01 = g_icw.icw03
        LET g_icw.icw04 = l_gen03
        SELECT gem02 INTO l_gem02
          FROM gem_file
         WHERE gem01 = g_icw.icw04
        DISPLAY BY NAME g_icw.icw03,g_icw.icw04
        DISPLAY l_gen02 TO FORMONLY.gen02
        DISPLAY l_gem02 TO FORMONLY.gem02
     END IF
  END IF
 
END FUNCTION
 
FUNCTION t030_icw03(p_cmd)
  DEFINE  p_cmd     LIKE type_file.chr1
  DEFINE  l_gen02   LIKE gen_file.gen02
  DEFINE  l_gen03   LIKE gen_file.gen03
  DEFINE  l_genacti LIKE gen_file.genacti
  DEFINE  l_gem02   LIKE gem_file.gem02
 
  LET g_errno = ''
 
  SELECT gen02,gen03,genacti
    INTO l_gen02,l_gen03,l_genacti
    FROM gen_file
   WHERE gen01 = g_icw.icw03
 
  IF p_cmd = 'a' THEN
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
       WHEN l_genacti = 'N'     LET g_errno = '9028'
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '------'
     END CASE
  END IF
 
  IF p_cmd = 'd' OR cl_null(g_errno) THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
     LET g_icw.icw04 = l_gen03
     SELECT gem02 INTO l_gem02
       FROM gem_file
      WHERE gem01 = g_icw.icw04
     DISPLAY BY NAME g_icw.icw04
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
 
END FUNCTION
 
FUNCTION t030_icw04(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1
  DEFINE l_gem02    LIKE gem_file.gem02
  DEFINE l_gemacti  LIKE gem_file.gemacti
 
  LET g_errno = ''
 
  SELECT gem02,gemacti INTO l_gem02,l_gemacti
    FROM gem_file
   WHERE gem01 = g_icw.icw04
 
  IF p_cmd = 'a' THEN
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-110'
       WHEN l_gemacti = 'N'     LET g_errno = '9028'
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '------'
     END CASE
  END IF
 
  IF p_cmd = 'd' OR cl_null(g_errno) THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
 
END FUNCTION
 
FUNCTION t030_icw05(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1
  DEFINE l_ima02    LIKE ima_file.ima02
  DEFINE l_ima02_1  LIKE ima_file.ima02
  DEFINE l_imaicd01 LIKE imaicd_file.imaicd01
  DEFINE l_imaacti  LIKE ima_file.imaacti
 
  LET g_errno = ''
 
  SELECT ima02,imaacti
    INTO l_ima02,l_imaacti
    FROM ima_file,imaicd_file
   WHERE ima01 = imaicd00
     AND ima01 = g_icw.icw05
 
  IF p_cmd = 'a' THEN
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-110'
                                LET l_ima02 = NULL
#                               LET l_imaicd01 = NULL
       WHEN l_imaacti = 'N'     LET g_errno = '9028'
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '------'
     END CASE
  END IF
 
  IF p_cmd = 'd' OR cl_null(g_errno) THEN
     SELECT imaicd01 INTO l_imaicd01
       FROM imaicd_file,ima_file
      WHERE imaicd01 = ima01
        AND imaicd00 = g_icw.icw05
 
     LET g_icw.icw22 = l_imaicd01
     SELECT ima02 INTO l_ima02_1
       FROM ima_file
      WHERE ima01 = g_icw.icw22
 
     DISPLAY l_ima02 TO FORMONLY.icw05_desc
     DISPLAY g_icw.icw22 TO icw22
     DISPLAY l_ima02_1 TO FORMONLY.icw22_desc
  END IF
 
END FUNCTION
 
FUNCTION t030_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_icx.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t030_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_icw.* TO NULL
      RETURN
   END IF
 
   OPEN t030_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_icw.* TO NULL
   ELSE
      OPEN t030_count
      FETCH t030_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t030_fetch('F')
   END IF
END FUNCTION
 
FUNCTION t030_fetch(p_flag)
DEFINE p_flag LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t030_cs INTO g_icw.icw01,g_icw.icw01
      WHEN 'P' FETCH PREVIOUS t030_cs INTO g_icw.icw01,g_icw.icw01
      WHEN 'F' FETCH FIRST    t030_cs INTO g_icw.icw01,g_icw.icw01
      WHEN 'L' FETCH LAST     t030_cs INTO g_icw.icw01,g_icw.icw01
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
            FETCH ABSOLUTE g_jump t030_cs INTO g_icw.icw01,g_icw.icw01
            LET g_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
      LET g_icw.icw01 = NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index,g_row_count )
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file WHERE icw01 = g_icw.icw01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
      INITIALIZE g_icw.* TO NULL
      RETURN
   END IF
 
   SELECT imaicd01 INTO g_imaicd01
     FROM imaicd_file,ima_file
    WHERE ima01 = imaicd00
      AND ima01 = g_icw.icw05
 
   LET g_data_owner = g_icw.icwuser
   LET g_data_group = g_icw.icwgrup
   LET g_data_plant = g_icw.icwplant #FUN-980030
 
   CALL t030_show()
 
END FUNCTION
 
FUNCTION t030_show()
   LET g_icw_t.* = g_icw.*
   LET g_icw_o.* = g_icw.*
   DISPLAY BY NAME g_icw.icw01,g_icw.icw02,g_icw.icw03, g_icw.icworiu,g_icw.icworig,
                   g_icw.icw04,g_icw.icw05,g_icw.icw06,
                   g_icw.icw10,g_icw.icw22,g_icw.icw23,
                   g_icw.icw13,g_icw.icw14,g_icw.icw15,
                   g_icw.icw16,g_icw.icw18,g_icw.icwuser,
                   g_icw.icwgrup,g_icw.icwacti,
                   g_icw.icwdate,g_icw.icwmodu,
                   #FUN-850068     ---start---
                   g_icw.icwud01,g_icw.icwud02,g_icw.icwud03,g_icw.icwud04,
                   g_icw.icwud05,g_icw.icwud06,g_icw.icwud07,g_icw.icwud08,
                   g_icw.icwud09,g_icw.icwud10,g_icw.icwud11,g_icw.icwud12,
                   g_icw.icwud13,g_icw.icwud14,g_icw.icwud15 
                   #FUN-850068     ----end----
 
   CALL t030_icw02('d')
   CALL t030_icw03('d')
   CALL t030_icw04('d')
   CALL t030_icw05('d')
   CALL t030_pic()       #圖形顯示
 
   CALL t030_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t030_x() 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t030_cl USING g_icw.icw01
   IF STATUS THEN
      CALL cl_err("OPEN t030_cl:",STATUS,1)
      CLOSE t030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t030_cl INTO g_icw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
      CLOSE t030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t030_show()
 
   IF cl_exp(0,0,g_icw.icwacti) THEN
      LET g_chr = g_icw.icwacti
      IF g_icw.icwacti = 'Y' THEN
         LET g_icw.icwacti = 'N'
      ELSE
         LET g_icw.icwacti = 'Y'
      END IF
 
      UPDATE icw_file SET icwacti = g_icw.icwacti,
                          icwmodu = g_user,
                          icwdate = g_today
       WHERE icw01 = g_icw.icw01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
         LET g_icw.icwacti = g_chr
      END IF
   END IF
 
   CLOSE t030_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT icwacti,icwmodu,icwdate
     INTO g_icw.icwacti,g_icw.icwmodu,g_icw.icwdate
     FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   DISPLAY BY NAME g_icw.icwacti,g_icw.icwmodu,g_icw.icwdate
 
END FUNCTION
 
FUNCTION t030_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 != 'N' THEN
      IF g_icw.icw18 = 'Y' THEN
         CALL cl_err(g_icw.icw01,'9023',0)
         RETURN
      END IF
      IF g_icw.icw18 = 'X' THEN
         CALL cl_err(g_icw.icw01,'9024',0)
         RETURN
      END IF
   END IF
 
   BEGIN WORK
 
   OPEN t030_cl USING g_icw.icw01
   IF STATUS THEN
      CALL cl_err("OPEN t030_cl:",STATUS,1)
      CLOSE t030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t030_cl INTO g_icw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
      CLOSE t030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t030_show()
 
   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "icw01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_icw.icw01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
      DELETE FROM icw_file WHERE icw01 = g_icw.icw01
      DELETE FROM icx_file WHERE icx01 = g_icw.icw01
      CLEAR FORM
      CALL g_icx.clear()
      OPEN t030_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t030_cs
         CLOSE t030_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t030_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t030_cs
         CLOSE t030_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t030_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t030_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t030_fetch('/')
      END IF
   END IF
 
   CLOSE t030_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t030_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF cl_null(g_icw.icw01) THEN
       RETURN
    END IF
 
    SELECT * INTO g_icw.* FROM icw_file
     WHERE icw01 = g_icw.icw01
 
    IF g_icw.icwacti ='N' THEN
       CALL cl_err(g_icw.icw01,'mfg1000',0)
       RETURN
    END IF
 
    IF g_icw.icw18 != 'N' THEN
       IF g_icw.icw18 = 'Y' THEN
          CALL cl_err(g_icw.icw01,'9023',0)
          RETURN
       END IF
       IF g_icw.icw18 = 'X' THEN
          CALL cl_err(g_icw.icw01,'9024',0)
          RETURN
       END IF
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT icx02,icx03,'',icx26,icx04,",
                       "       icx05,icx06,icx07,icx23,icx08,",
                       "       icx09,icx24,icx10,icx11,icx12,",
                       "       icx13,icx14,icx15,icx16,icx17,",
                       "       icx18,icx19,icx20,icx21,icx22,",
                       #No.FUN-850068 --start--
                       "       icxud01,icxud02,icxud03,icxud04,icxud05,",
                       "       icxud06,icxud07,icxud08,icxud09,icxud10,",
                       "       icxud11,icxud12,icxud13,icxud14,icxud15 ", 
                       #No.FUN-850068 ---end---
                       "  FROM icx_file ",
                       "  WHERE icx01 = ? ",
                       "   AND icx02 = ? ",
                       "   AND icx03 = ? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t030_bcl CURSOR FROM g_forupd_sql             #LOCK CURSOR
 
    IF g_icw.icw06 = 'Y' THEN
       LET l_allow_insert = cl_detail_input_auth("insert")
       LET l_allow_delete = cl_detail_input_auth("delete")
    ELSE
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
    END IF
 
    INPUT ARRAY g_icx WITHOUT DEFAULTS FROM s_icx.*
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
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t030_cl USING g_icw.icw01
           IF STATUS THEN
              CALL cl_err("OPEN t030_cl:",STATUS,1)
              CLOSE t030_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t030_cl INTO g_icw.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
              CLOSE t030_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_icx_t.* = g_icx[l_ac].*               #BACKUP
              LET g_icx_o.* = g_icx[l_ac].*               #BACKUP
              OPEN t030_bcl USING g_icw.icw01,g_icx_t.icx02,g_icx_t.icx03
              IF STATUS THEN
                 CALL cl_err("OPEN t030_bcl:",STATUS,1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t030_bcl INTO g_icx[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_icx_t.icx02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT ima02 INTO g_icx[l_ac].icx03_desc FROM ima_file
                  WHERE ima01 = g_icx[l_ac].icx03
                 CALL t030_set_entry_b(p_cmd)
                 CALL t030_set_no_entry_b(p_cmd)
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd = 'a'
           INITIALIZE g_icx[l_ac].* TO NULL
           LET g_icx[l_ac].icx07 = '0'
           LET g_icx[l_ac].icx08 = g_today
           LET g_icx[l_ac].icx10 = g_today
           LET g_icx[l_ac].icx19 = '0'
           LET g_icx[l_ac].icx20 = '0'
           LET g_icx[l_ac].icx21 = 'Y'
           LET g_icx_t.* = g_icx[l_ac].*
           LET g_icx_o.* = g_icx[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD icx02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM icx_file
            WHERE icx01 = g_icw.icw01
              AND icx02 = g_icx[l_ac].icx02
              AND icx03 = g_icx[l_ac].icx03
           IF l_cnt > 0 THEN
              CALL cl_err(g_icx[l_ac].icx02,-239,0)
              CANCEL INSERT
           END IF
 
           INSERT INTO icx_file(icx01,icx02,icx03,icx26,icx04,
                                icx05,icx06,icx07,icx23,icx08,
                                icx09,icx24,icx10,icx11,icx12,
                                icx13,icx14,icx15,icx16,icx17,
                                icx18,icx19,icx20,icx21,icx22,
                                #FUN-850068 --start--
                                icxud01,icxud02,icxud03,icxud04,icxud05,
                                icxud06,icxud07,icxud08,icxud09,icxud10,
                                icxud11,icxud12,icxud13,icxud14,icxud15,
                                icxplant,icxlegal) #FUN-980004
                                #FUN-850068 --end--
                         VALUES(g_icw.icw01,g_icx[l_ac].icx02,
                                g_icx[l_ac].icx03,g_icx[l_ac].icx26,
                                g_icx[l_ac].icx04,g_icx[l_ac].icx05,
                                g_icx[l_ac].icx06,g_icx[l_ac].icx07,
                                g_icx[l_ac].icx23,g_icx[l_ac].icx08,
                                g_icx[l_ac].icx09,g_icx[l_ac].icx24,
                                g_icx[l_ac].icx10,g_icx[l_ac].icx11,
                                g_icx[l_ac].icx12,g_icx[l_ac].icx13,
                                g_icx[l_ac].icx14,g_icx[l_ac].icx15,
                                g_icx[l_ac].icx16,g_icx[l_ac].icx17,
                                g_icx[l_ac].icx18,g_icx[l_ac].icx19,
                                g_icx[l_ac].icx20,g_icx[l_ac].icx21,
                                g_icx[l_ac].icx22,
                                #FUN-850068 --start--
                                g_icx[l_ac].icxud01,g_icx[l_ac].icxud02,
                                g_icx[l_ac].icxud03,g_icx[l_ac].icxud04,
                                g_icx[l_ac].icxud05,g_icx[l_ac].icxud06,
                                g_icx[l_ac].icxud07,g_icx[l_ac].icxud08,
                                g_icx[l_ac].icxud09,g_icx[l_ac].icxud10,
                                g_icx[l_ac].icxud11,g_icx[l_ac].icxud12,
                                g_icx[l_ac].icxud13,g_icx[l_ac].icxud14,
                                g_icx[l_ac].icxud15,
                                g_plant,g_legal) #FUN-980004
                                #FUN-850068 --end--
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err(g_icx[l_ac].icx02,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD icx02
           IF cl_null(g_icx[l_ac].icx02) OR
              g_icx[l_ac].icx02 = 0 THEN
              SELECT MAX(icx02)+1
                INTO g_icx[l_ac].icx02
                FROM icx_file
               WHERE icx01 = g_icw.icw01
              IF SQLCA.SQLCODE OR cl_null(g_icx[l_ac].icx02) THEN
                 LET g_icx[l_ac].icx02 = 1
              END IF
           END IF
           DISPLAY BY NAME g_icx[l_ac].icx02
 
        AFTER FIELD icx02
           IF NOT cl_null(g_icx[l_ac].icx02) THEN
              IF (p_cmd = "u" AND g_icx[l_ac].icx02 != g_icx_t.icx02) OR
                 g_icx[l_ac].icx02 IS NULL THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt
                   FROM icx_file
                  WHERE icx01 = g_icw.icw01
                    AND icx02 = g_icx[l_ac].icx02
                 IF l_n > 0 THEN
                    CALL cl_err(g_icx[l_ac].icx02,-239,1)
                    NEXT FIELD icx02
                 END IF
                 IF g_icx[l_ac].icx02 <= 0 THEN
                    CALL cl_err(g_icx[l_ac].icx02,'mfg9243',0)
                    LET g_icx[l_ac].icx02 = g_icx_t.icx02
                    DISPLAY BY NAME g_icx[l_ac].icx02
                    NEXT FIELD icx02
                 END IF
               END IF
           END IF
 
        AFTER FIELD icx03
           IF NOT cl_null(g_icx[l_ac].icx03) THEN
             #FUN-AA0059 ----------------add start-----------------
              IF NOT s_chk_item_no(g_icx[l_ac].icx03,'') THEN
                 CALL cl_err('',g_errno,1)
                 LET g_icx[l_ac].icx03 = g_icx_o.icx03
                 DISPLAY BY NAME g_icx[l_ac].icx03
                 NEXT FIELD icx03
              END IF
             #FUN-AA0059 -----------------add end----------------------- 
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND
                 g_icx[l_ac].icx03 != g_icx_o.icx03) THEN
                 CALL t030_icx03('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_icx[l_ac].icx03,g_errno,0)
                    LET g_icx[l_ac].icx03 = g_icx_o.icx03
                    DISPLAY BY NAME g_icx[l_ac].icx03
                    NEXT FIELD icx03
                 END IF
              END IF
           END IF
           LET g_icx_o.icx03 = g_icx[l_ac].icx03
 
        AFTER FIELD icx07
           IF NOT cl_null(g_icx[l_ac].icx07) THEN
              IF g_icx[l_ac].icx07 NOT MATCHES '[01]' THEN
                 NEXT FIELD icx07
              END IF
           END IF
 
        AFTER FIELD icx20
           IF NOT cl_null(g_icx[l_ac].icx20) THEN
              IF g_icx[l_ac].icx20 NOT MATCHES '[01]' THEN
                 NEXT FIELD icx20
              END IF
           END IF
 
        AFTER FIELD icx21
           IF NOT cl_null(g_icx[l_ac].icx21) THEN
              IF g_icx[l_ac].icx21 NOT MATCHES '[YN]' THEN
                 NEXT FIELD icx21
              END IF
           END IF
 
        AFTER FIELD icx19
           IF NOT cl_null(g_icx[l_ac].icx19) THEN
              IF g_icx[l_ac].icx19 <= 0 THEN
                 CALL cl_err(g_icx[l_ac].icx19,'mfg9243',0)
                 LET g_icx[l_ac].icx19 = g_icx_o.icx19
                 DISPLAY BY NAME g_icx[l_ac].icx19
                 NEXT FIELD icx19
              END IF
              IF g_icx[l_ac].icx19 > 1 THEN
                 CALL cl_err(g_icx[l_ac].icx19,'aic-962',0)
                 LET g_icx[l_ac].icx19 = g_icx_o.icx19
                 DISPLAY BY NAME g_icx[l_ac].icx19
                 NEXT FIELD icx19
              END IF
           END IF
           LET g_icx_o.icx19 = g_icx[l_ac].icx19
 
        #No.FUN-850068 --start--
        AFTER FIELD icxud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD icxud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
 
 
        BEFORE DELETE
           IF g_icx_t.icx02 > 0 AND
              NOT cl_null(g_icx_t.icx02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("",-263,1)
                 CANCEL DELETE
              END IF
              DELETE FROM icx_file
               WHERE icx01 = g_icw.icw01
                 AND icx02 = g_icx_t.icx02
                 AND icx03 = g_icx_t.icx03
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                 CALL cl_err(g_icx_t.icx02,SQLCA.sqlcode,0)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b = g_rec_b - 1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              CALL cl_err('',9001,0)
              LET g_icx[l_ac].* = g_icx_t.*
              CLOSE t030_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_icx[l_ac].icx02,-263,1)
              LET g_icx[l_ac].* = g_icx_t.*
           ELSE
 
              UPDATE icx_file
                 SET icx02 = g_icx[l_ac].icx02,
                     icx03 = g_icx[l_ac].icx03,
                     icx26 = g_icx[l_ac].icx26,
                     icx04 = g_icx[l_ac].icx04,
                     icx05 = g_icx[l_ac].icx05,
                     icx06 = g_icx[l_ac].icx06,
                     icx07 = g_icx[l_ac].icx07,
                     icx23 = g_icx[l_ac].icx23,
                     icx08 = g_icx[l_ac].icx08,
                     icx09 = g_icx[l_ac].icx09,
                     icx24 = g_icx[l_ac].icx24,
                     icx10 = g_icx[l_ac].icx10,
                     icx11 = g_icx[l_ac].icx11,
                     icx12 = g_icx[l_ac].icx12,
                     icx13 = g_icx[l_ac].icx13,
                     icx14 = g_icx[l_ac].icx14,
                     icx15 = g_icx[l_ac].icx15,
                     icx16 = g_icx[l_ac].icx16,
                     icx17 = g_icx[l_ac].icx17,
                     icx18 = g_icx[l_ac].icx18,
                     icx19 = g_icx[l_ac].icx19,
                     icx20 = g_icx[l_ac].icx20,
                     icx21 = g_icx[l_ac].icx21,
                     icx22 = g_icx[l_ac].icx22,
                     #FUN-850068 --start--
                     icxud01 = g_icx[l_ac].icxud01,
                     icxud02 = g_icx[l_ac].icxud02,
                     icxud03 = g_icx[l_ac].icxud03,
                     icxud04 = g_icx[l_ac].icxud04,
                     icxud05 = g_icx[l_ac].icxud05,
                     icxud06 = g_icx[l_ac].icxud06,
                     icxud07 = g_icx[l_ac].icxud07,
                     icxud08 = g_icx[l_ac].icxud08,
                     icxud09 = g_icx[l_ac].icxud09,
                     icxud10 = g_icx[l_ac].icxud10,
                     icxud11 = g_icx[l_ac].icxud11,
                     icxud12 = g_icx[l_ac].icxud12,
                     icxud13 = g_icx[l_ac].icxud13,
                     icxud14 = g_icx[l_ac].icxud14,
                     icxud15 = g_icx[l_ac].icxud15
                     #FUN-850068 --end-- 
               WHERE icx01 = g_icw.icw01
                 AND icx02 = g_icx_t.icx02
                 AND icx03 = g_icx_t.icx03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_icx[l_ac].icx02,SQLCA.sqlcode,0)
                 LET g_icx[l_ac].* = g_icx_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac#FUN-D40030 mark
           IF (g_icx[l_ac].icx02 != g_icx_t.icx02) OR
              (g_icx[l_ac].icx03 != g_icx_t.icx03) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM icx_file
               WHERE icx01 = g_icw.icw01
                 AND icx02 = g_icx[l_ac].icx02
                 AND icx03 = g_icx[l_ac].icx03
              IF l_cnt > 0 THEN
                 CALL cl_err(g_icx[l_ac].icx02,-239,0)
                 NEXT FIELD icx02
              END IF
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              CALL cl_err('',9001,0)
              IF p_cmd = 'u' THEN
                 LET g_icx[l_ac].* = g_icx_t.*
             #FUN-D40030--add--str
              ELSE
                 CALL g_icx.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
             #FUN-D40030--add--end
              END IF
              CLOSE t030_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac#FUN-D40030 add
           CLOSE t030_bcl
           COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(icx03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imaicd2"
                 LET g_qryparam.default1 = g_icx[l_ac].icx03
                 CALL cl_create_qry() RETURNING g_icx[l_ac].icx03
                 DISPLAY BY NAME g_icx[l_ac].icx03
                 NEXT FIELD icx03
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
    END INPUT
 
    LET g_icw.icwmodu = g_user
    LET g_icw.icwdate = g_today
    UPDATE icw_file
       SET icwmodu = g_icw.icwmodu,
           icwdate = g_icw.icwdate
     WHERE icw01 = g_icw.icw01
 
    DISPLAY BY NAME g_icw.icwmodu,g_icw.icwdate
 
    CLOSE t030_bcl
    COMMIT WORK
#   CALL t030_delall()        #CHI-C30002 mark
    CALL t030_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t030_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_icw.icw01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM icw_file ",
                  "  WHERE icw01 LIKE '",l_slip,"%' ",
                  "    AND icw01 > '",g_icw.icw01,"'"
      PREPARE t030_pb1 FROM l_sql 
      EXECUTE t030_pb1 INTO l_cnt       
      
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
        #CALL t030_v()    #CHI-D20010
         CALL t030_v(1)   #CHI-D20010
         CALL t030_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM icw_file WHERE icw01 = g_icw.icw01
         INITIALIZE g_icw.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin 
#FUNCTION t030_delall()
 
#   LET g_cnt = 0
#   SELECT COUNT(*) INTO g_cnt
#     FROM icx_file
#    WHERE icx01 = g_icw.icw01
#
#   IF g_cnt = 0 THEN
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM icw_file WHERE icw01 = g_icw.icw01
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t030_b_fill(p_wc2)                               #BODY FILL UP
 
   DEFINE p_wc2 STRING
 
   LET g_sql = "SELECT icx02,icx03,'',icx26,icx04,",
               "       icx05,icx06,icx07,icx23,icx08,",
               "       icx09,icx24,icx10,icx11,icx12,",
 
               "       icx13,icx14,icx15,icx16,icx17,",
               "       icx18,icx19,icx20,icx21,icx22, ",
               #No.FUN-850068 --start--
               "       icxud01,icxud02,icxud03,icxud04,icxud05,",
               "       icxud06,icxud07,icxud08,icxud09,icxud10,",
               "       icxud11,icxud12,icxud13,icxud14,icxud15 ", 
               #No.FUN-850068 ---end---
               "  FROM icx_file ",
               " WHERE icx01 = '",g_icw.icw01 CLIPPED,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY icx02,icx03 "
 
   PREPARE t030_pb FROM g_sql
   DECLARE icx_cs CURSOR FOR t030_pb
 
   CALL g_icx.clear()
   LET g_cnt = 1
   FOREACH icx_cs INTO g_icx[g_cnt].*
     IF STATUS THEN
        CALL cl_err('foreach:',STATUS,1)
        EXIT FOREACH
     END IF
 
     SELECT ima02 INTO g_icx[g_cnt].icx03_desc
       FROM ima_file
      WHERE ima01 = g_icx[g_cnt].icx03
     IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ima_file",g_icx[g_cnt].icx03,"",SQLCA.sqlcode,"","",0)
        LET g_icx[g_cnt].icx03_desc = NULL
     END IF
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
   END FOREACH
   CALL g_icx.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t030_icx03(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1
  DEFINE l_ima02    LIKE ima_file.ima02
  DEFINE l_imaacti  LIKE ima_file.imaacti
  DEFINE l_cnt      LIKE type_file.num5
 
  LET g_errno = ''
 
  SELECT ima02,imaacti
    INTO l_ima02,l_imaacti
    FROM ima_file,imaicd_file
   WHERE ima01 = g_icx[l_ac].icx03
     AND ima01 = imaicd00
 
  IF p_cmd = 'a' THEN
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-110'
                                LET l_ima02 = NULL
       WHEN l_imaacti = 'N'     LET g_errno = '9028'
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '------'
     END CASE
  END IF
 
  IF g_icw.icw06 = 'Y' THEN
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt
       FROM icx_file
      WHERE icx01 = g_icw.icw01
        AND icx03 = g_icx[l_ac].icx03
     IF l_cnt > 0 THEN
        LET g_errno = 'aic-980'
     END IF
# ELSE
#    LET g_errno = 'aic-981'
  END IF
 
  IF p_cmd = 'd' OR cl_null(g_errno) THEN
     DISPLAY l_ima02 TO FORMONLY.icx03_desc
  END IF
 
END FUNCTION
 
FUNCTION t030_copy()
   DEFINE l_newno   LIKE icw_file.icw01
   DEFINE l_newdate LIKE icw_file.icw14
   DEFINE l_oldno   LIKE icw_file.icw01
   DEFINE li_result LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t030_set_entry('a')
 
   INPUT l_newno,l_newdate FROM icw01,icw14
 
      BEFORE INPUT
         CALL cl_set_docno_format("icw01")
 
      AFTER FIELD icw01
         CALL s_check_no("axm",l_newno,"","12","icw_file","icw01","")
              RETURNING li_result,l_newno
         DISPLAY l_newno TO icw01
         IF (NOT li_result) THEN
            LET g_icw.icw01 = NULL
            NEXT FIELD icw01
         END IF
 
      AFTER FIELD icw14
         IF cl_null(l_newdate) THEN
            NEXT FIELD icw14
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         BEGIN WORK
         CALL s_auto_assign_no("axm",l_newno,l_newdate,"","icw_file",
                               "icw01","","","")
              RETURNING li_result,l_newno
         IF (NOT li_result) THEN
            NEXT FIELD icw01
         END IF
         DISPLAY l_newno TO icw01
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icw01)
                 LET g_t1=s_get_doc_no(l_newno)
                 CALL q_oay(FALSE,FALSE,g_t1,'12','axm') RETURNING g_t1       #FUN-A70130
                 LET l_newno = g_t1
                 DISPLAY l_newno TO icw01
                 NEXT FIELD icw01
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
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_icw.icw01,g_icw.icw14
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM icw_file
    WHERE icw01 = g_icw.icw01
     INTO TEMP y
 
   UPDATE y
      SET icw01 = l_newno,
          icw05 = '',
#         icw08 = '',
#         icw09 = '',
#         icw12 = '',
          icw13 = '',
          icw10 = 'N',
          icw14 = l_newdate,
          icw15 = NULL,
          icw16 = NULL,
          icw18 = 'N',
          icwuser = g_user,
          icwgrup = g_grup,
          icwmodu = NULL,
          icwdate = g_today,
          icwacti = 'Y'
 
   INSERT INTO icw_file SELECT * FROM y
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM icx_file
     WHERE icx01 = g_icw.icw01
      INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x SET icx01 = l_newno
 
   INSERT INTO icx_file SELECT * FROM x
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_icw.icw01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_icw.icw01
   SELECT icw_file.* INTO g_icw.icw01,g_icw.*
     FROM icw_file
    WHERE icw01 = l_newno
   LET g_copy = 'Y'
   CALL t030_u()
   LET g_copy = 'N'
   CALL t030_b()
   #FUN-C30027---begin
   #SELECT icw_file.* INTO g_icw.icw01,g_icw.*
   #  FROM icw_file
   # WHERE icw01 = l_oldno
   #CALL t030_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION t030_set_entry(p_cmd)
   DEFINE p_cmd   VARCHAR(01)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("icw01",TRUE)
   END IF
 
   CALL cl_set_comp_entry("icw14",TRUE)
 
END FUNCTION
 
FUNCTION t030_set_no_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.num5
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("icw01",FALSE)
   END IF
 
   IF g_copy = 'Y' THEN
      CALL cl_set_comp_entry("icw14",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t030_set_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.num5
 
   CALL cl_set_comp_entry("icx03,icx19",TRUE)
 
END FUNCTION
 
FUNCTION t030_set_no_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.num5
 
   IF g_icw.icw06 = 'N' THEN
      CALL cl_set_comp_entry("icx03,icx19",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t030_code()
   DEFINE l_icu     RECORD LIKE icu_file.*
   DEFINE l_totcode LIKE icw_file.icw13
   DEFINE l_subcode LIKE icx_file.icx26
   DEFINE l_icx02   LIKE icx_file.icx02
   DEFINE l_cnt     LIKE type_file.num5
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF cl_null(g_icw.icw22) THEN
      CALL cl_err(g_icw.icw22,'aic-993',1)
      RETURN
   END IF
 
   SELECT icu_file.* INTO l_icu.*
     FROM icu_file
    WHERE icu01 = g_icw.icw22
 
   IF l_icu.icu08 IS NULL THEN
      LET l_icu.icu08 = 0
   END IF
 
   IF l_icu.icu13 IS NULL THEN
      LET l_icu.icu13 = 0
   END IF
 
   IF l_icu.icu03 = 'N' THEN
      CALL cl_err(l_icu.icu03,'aic-963',1)
      RETURN
   ELSE
      IF g_icw.icw06 = "N" THEN
         LET l_icu.icu08 = l_icu.icu08 + 1
         LET l_icu.icu13 = l_icu.icu13 + 1
         LET l_totcode = l_icu.icu04,l_icu.icu08
         LET l_subcode = l_icu.icu09,l_icu.icu13
 
         UPDATE icw_file
            SET icw13 = l_totcode
          WHERE icw01 = g_icw.icw01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(l_totcode,SQLCA.sqlcode,1)
         END IF
         LET g_icw.icw13 = l_totcode
         DISPLAY g_icw.icw13 TO icw13
 
         #自動產生一筆單身，所以單身也要有子code
         UPDATE icx_file
            SET icx26 = l_subcode
          WHERE icx01 = g_icw.icw01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(l_subcode,SQLCA.sqlcode,1)
         END IF
         LET g_icx[1].icx26 = l_subcode
         DISPLAY g_icx[1].icx26 TO icx26
 
         UPDATE icu_file
            SET icu08 = l_icu.icu08,
                icu13 = l_icu.icu13
          WHERE icu01 = g_icw.icw22
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_icw.icw22,SQLCA.sqlcode,1)
         END IF
      ELSE
         LET l_icu.icu08 = l_icu.icu08 + 1
         LET l_totcode = l_icu.icu04,l_icu.icu08
 
         UPDATE icw_file
            SET icw13 = l_totcode
          WHERE icw01 = g_icw.icw01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(l_totcode,SQLCA.sqlcode,1)
         END IF
         LET g_icw.icw13 = l_totcode
         DISPLAY g_icw.icw13 TO icw13
 
         DECLARE icx_sel CURSOR FOR
          SELECT icx02
            FROM icx_file
           WHERE icx01 = g_icw.icw01
 
         LET l_cnt = 1
         FOREACH icx_sel INTO l_icx02
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
 
            LET l_icu.icu13 = l_icu.icu13 + 1
            LET l_subcode = l_icu.icu09,l_icu.icu13
 
            UPDATE icx_file
               SET icx26 = l_subcode
             WHERE icx01 = g_icw.icw01
               AND icx02 = l_icx02
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err(l_subcode,SQLCA.sqlcode,1)
            END IF
            LET g_icx[l_cnt].icx26 = l_subcode
            LET l_cnt = l_cnt + 1
         END FOREACH
 
         UPDATE icu_file
            SET icu08 = l_icu.icu08,
                icu13 = l_icu.icu13
          WHERE icu01 = g_icw.icw22
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err(g_icw.icw22,SQLCA.sqlcode,1)
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t030_sale_y()
   DEFINE l_icu     RECORD LIKE icu_file.*
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 = 'Y' THEN
      CALL cl_err(g_icw.icw01,'9023',0)
      RETURN
   END IF
 
   IF g_icw.icw18 = 'X' THEN
      CALL cl_err(g_icw.icw01,'9024',0)
      RETURN
   END IF
 
   SELECT icu_file.* INTO l_icu.*
     FROM icu_file
    WHERE icu01 = g_icw.icw22
 
   IF cl_null(g_icw.icw13) AND l_icu.icu03 = 'Y' THEN
      CALL cl_err(g_icw.icw01,'aic-964',0)
      RETURN
   ELSE
      IF NOT cl_confirm("aic-995") THEN
         RETURN
      END IF
      LET g_icw.icw18 = 'Y'
      LET g_icw.icw10 = 'Y'
      UPDATE icw_file
         SET icw18 = g_icw.icw18,
             icw10 = g_icw.icw10,
             icw15 = g_today
       WHERE icw01 = g_icw.icw01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd icw:',SQLCA.SQLCODE,0)
         LET g_icw.icw18 = "N"
         LET g_icw.icw10 = 'N'
         LET g_icw.icw15 = NULL
         DISPLAY BY NAME g_icw.icw18,g_icw.icw10,g_icw.icw15
         RETURN
      ELSE
         LET g_icw.icw15 = g_today         #FUN-D20059 add
         DISPLAY BY NAME g_icw.icw18,g_icw.icw10,g_icw.icw15
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t030_sale_z()
   DEFINE l_n LIKE type_file.num5
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 = 'N' THEN
      CALL cl_err(g_icw.icw01,'9025',0)
      RETURN
   END IF
 
   IF g_icw.icw18 = 'X' THEN
      CALL cl_err(g_icw.icw01,'9024',0)
      RETURN
   END IF
 
   IF NOT cl_null(g_icw.icw22) THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM ice_file
       WHERE ice02 = g_icw.icw22
         AND ice14 = g_icw.icw23
      IF l_n > 0 THEN
         CALL cl_err(g_icw.icw01,'aic-992',0)
         RETURN
      END IF
   ELSE
      CALL cl_err(g_icw.icw22,'aic-993',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('aic-994') THEN
      RETURN
   END IF
 
   LET g_icw.icw18 = 'N'
   LET g_icw.icw10 = 'N'
   UPDATE icw_file
      SET icw18 = g_icw.icw18,
          icw10 = g_icw.icw10,
          icw16 = g_today
    WHERE icw01 = g_icw.icw01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd icw:',SQLCA.SQLCODE,0)
      LET g_icw.icw18 = "Y"
      LET g_icw.icw10 = 'N'
      LET g_icw.icw16 = NULL
      DISPLAY BY NAME g_icw.icw18,g_icw.icw10,g_icw.icw16
      RETURN
   ELSE
      LET g_icw.icw16 = g_today         #FUN-D20059 add
      DISPLAY BY NAME g_icw.icw18,g_icw.icw10,g_icw.icw16
   END IF
 
END FUNCTION
 
FUNCTION t030_mask()
   DEFINE l_icr01 LIKE icr_file.icr01
   DEFINE l_ice01 LIKE ice_file.ice01
   DEFINE l_ice04 LIKE ice_file.ice04
   DEFINE l_ice08 LIKE ice_file.ice08
   DEFINE l_ice16 LIKE ice_file.ice16
   DEFINE l_value STRING
   DEFINE l_res   LIKE ice_file.ice16
   DEFINE l_imz   RECORD LIKE imz_file.*
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 != 'Y' THEN
      CALL cl_err(g_icw.icw01,'aic-953',0)
      RETURN
   END IF
 
   OPEN WINDOW t030_1_w WITH FORM "aic/42f/aict030_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("aict030_1")
 
   INPUT l_icr01,l_ice01 WITHOUT DEFAULTS FROM icr01,ice01
 
      AFTER FIELD icr01
         IF NOT cl_null(l_icr01) THEN
            SELECT icr01
              FROM icr_file
             WHERE icr01 = l_icr01
               AND icr02 = '3'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","icr_file",l_icr01,'',SQLCA.sqlcode,"","sel icr:",1)
               NEXT FIELD icr01
            END IF
         END IF
 
      AFTER FIELD ice01
         IF NOT cl_null(l_ice01) THEN
            SELECT DISTINCT ice01
              FROM ice_file
             WHERE ice02 = g_icw.icw22
               AND ice14 = g_icw.icw23
               AND ice01 = l_ice01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","ice_file",l_ice01,g_icw.icw22,SQLCA.sqlcode,"","sel ice:",1)
               NEXT FIELD ice01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icr01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_icr1"
                 LET g_qryparam.arg1 = "3"
                 LET g_qryparam.default1 = l_icr01
                 CALL cl_create_qry() RETURNING l_icr01
                 DISPLAY l_icr01 TO icr01
                 NEXT FIELD icr01
            WHEN INFIELD(ice01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ice_1"
                 LET g_qryparam.arg1 = g_icw.icw22
                 LET g_qryparam.arg2 = g_icw.icw23
                 LET g_qryparam.default1 = l_ice01
                 CALL cl_create_qry() RETURNING l_ice01
                 DISPLAY l_ice01 TO ice01
                 NEXT FIELD ice01
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
      CLOSE WINDOW t030_1_w
      RETURN
   END IF
 
   CLOSE WINDOW t030_1_w
   
   BEGIN WORK
 
   DECLARE upd_ice CURSOR FOR
    SELECT ice04,ice08,ice16
      FROM ice_file
     WHERE ice01 = l_ice01
       AND ice02 = g_icw.icw22
       AND ice14 = g_icw.icw23
 
   FOREACH upd_ice INTO l_ice04,l_ice08,l_ice16
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_ice08 != 'Y' THEN
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(l_ice16) THEN
         CONTINUE FOREACH
      END IF
      LET l_value = l_ice01,"||",g_icw.icw01
      CALL s_aic_auto_no(l_icr01,'3',l_value,'')   #FUN-BC0106 add ''
         RETURNING l_res
 
      UPDATE ice_file SET ice16 = l_res
       WHERE ice01 = l_ice01
         AND ice02 = g_icw.icw22
         AND ice04 = l_ice04
         AND ice14 = g_icw.icw23
      IF SQLCA.sqlcode THEN
         CALL cl_err3('upd','ice_file',l_ice01,g_icw.icw22,SQLCA.sqlcode,'','',1)
         ROLLBACK WORK
         EXIT FOREACH
      END IF
 
      SELECT * INTO l_imz.*
        FROM imz_file
       WHERE imz01 IN 
            (SELECT ima06 FROM ima_file
              WHERE ima01 = g_icw.icw22)
      
                  
      IF SQLCA.sqlcode THEN
         CALL cl_err3('sel','imz_file','','',SQLCA.sqlcode,'','',0)
         ROLLBACK WORK         
         EXIT FOREACH
      END IF
      IF cl_null(l_imz.imz926) THEN LET l_imz.imz926 = 'N' END IF  #FUN-9B0099   
     #FUN-A70130---add---start---
      IF cl_null(l_imz.imz156) THEN 
         LET l_imz.imz156 = 'N'
      END IF
      IF cl_null(l_imz.imz158) THEN 
         LET l_imz.imz158 = 'N'
      END IF
     #FUN-C20065 -----------Begin------------
      IF cl_null(l_imz.imz159) THEN
         LET l_imz.imz159 = '3'
      END IF
     #FUN-C20065 -----------End--------------
     #FUN-A70130---add---end---
      INSERT INTO ima_file(ima01,ima03,ima04,ima06,
                           ima07,ima08,ima09,ima10,
                           ima11,ima12,ima14,ima15,
                           ima17,ima19,ima21,ima23,
                           ima24,ima25,ima27,ima28,
                           ima31,ima31_fac,ima34,ima35,
                           ima36,ima37,ima38,ima39,
                           ima42,ima43,ima44,ima44_fac,
                           ima45,ima46,ima47,ima48,
                           ima49,ima491,ima50,ima51,
                           ima52,ima54,ima55,ima55_fac,
                           ima56,ima561,ima562,ima571,
                           ima59,ima60,ima601,ima61,ima62,     #No.FUN-840194 add ima601
                           ima63,ima63_fac,ima64,ima641,
                           ima65,ima66,ima67,ima68,
                           ima69,ima70,ima71,ima86,
                           ima86_fac,ima87,ima871,ima872,
                           ima873,ima874,ima88,ima89,
                           ima90,ima94,ima99,ima100,
                           ima101,ima102,ima103,ima105,  
                           ima106,ima107,ima108,ima109,
                           ima110,ima130,ima131,ima132,
                           ima133,ima134,ima147,ima148,
                           ima903,ima906,ima907,ima908,
                           ima909,ima911,ima136,ima137,
                           ima926,       #FUN-9B0099
                           ima391,ima1321,ima915,imaacti,
                           imauser,imagrup,imamodu,imadate,
#                           ima26,ima261,ima262,ima150,         #FUN-A20044 mark
                           ima150,ima156,ima158,                #FUN-A20044 #FUN-A70130 add ima156,ima158
                           ima151,ima152,ima916,imaoriu,imaorig,ima927,ima159,ima928,ima160)   #No:FUN-AA0014    #FUN-C20065 add ima159 #TQC-C20131  add ima928   #FUN-C50036 add ima160
                    VALUES(l_res,l_imz.imz03,l_imz.imz04,l_imz.imz01,
                           l_imz.imz07,l_imz.imz08,l_imz.imz09,l_imz.imz10,
                           l_imz.imz11,l_imz.imz12,l_imz.imz14,l_imz.imz15,
                           l_imz.imz17,l_imz.imz19,l_imz.imz21,l_imz.imz23,
                           l_imz.imz24,l_imz.imz25,l_imz.imz27,l_imz.imz28,
                           l_imz.imz31,l_imz.imz31_fac,l_imz.imz34,l_imz.imz35,
                           l_imz.imz36,l_imz.imz37,l_imz.imz38,l_imz.imz39,
                           l_imz.imz42,l_imz.imz43,l_imz.imz44,l_imz.imz44_fac,
                           l_imz.imz45,l_imz.imz46,l_imz.imz47,l_imz.imz48,
                           l_imz.imz49,l_imz.imz491,l_imz.imz50,l_imz.imz51,
                           l_imz.imz52,l_imz.imz54,l_imz.imz55,l_imz.imz55_fac,
                           l_imz.imz56,l_imz.imz561,l_imz.imz562,l_imz.imz571,
                           l_imz.imz59,l_imz.imz60,1,l_imz.imz61,l_imz.imz62,   #No.FUN-840194 add 1
                           l_imz.imz63,l_imz.imz63_fac,l_imz.imz64,l_imz.imz641,
                           l_imz.imz65,l_imz.imz66,l_imz.imz67,l_imz.imz68,
                           l_imz.imz69,l_imz.imz70,l_imz.imz71,l_imz.imz86,
                           l_imz.imz86_fac,l_imz.imz87,l_imz.imz871,l_imz.imz872,
                           l_imz.imz873,l_imz.imz874,l_imz.imz88,l_imz.imz89,
                           l_imz.imz90,l_imz.imz94,l_imz.imz99,l_imz.imz100 ,
                           l_imz.imz101,l_imz.imz102,l_imz.imz103,l_imz.imz105,
                           l_imz.imz106,l_imz.imz107,l_imz.imz108,l_imz.imz109,
                           l_imz.imz110,l_imz.imz130,l_imz.imz131,l_imz.imz132,
                           l_imz.imz133,l_imz.imz134,l_imz.imz147,l_imz.imz148,
                           l_imz.imz903,l_imz.imz906,l_imz.imz907,l_imz.imz908,                              
                           l_imz.imz909,l_imz.imz911,l_imz.imz136,l_imz.imz137,                              
                           l_imz.imz926,   #FUN-9B0099
                           l_imz.imz391,l_imz.imz1321,l_imz.imz72,l_imz.imzacti,
                           l_imz.imzuser,l_imz.imzgrup,l_imz.imzmodu,l_imz.imzdate,
#                           0,0,0,' ',' ',' ',' ', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig  #FUN-A20044 mark
                           ' ',l_imz.imz156,l_imz.imz158,' ',' ',' ', g_user, g_grup,'N',l_imz.imz159,'N','N')   #No:FUN-AA0014       #FUN-A20044  #FUN-A70130 add imz156,imz158 #FUN-C20065 add imz159 #TQC-C20131  add 'N' #FUN-C50036 add 'N'
            
      IF SQLCA.sqlcode THEN
         CALL cl_err3('ins','ima_file',l_res,l_imz.imz01,SQLCA.sqlcode,'','',1)
         ROLLBACK WORK
         EXIT FOREACH
      END IF
      
      INSERT INTO imaicd_file(imaicd00,imaicd01,imaicd02,imaicd03,imaicd04,
                              imaicd05,imaicd06,imaicd07,imaicd08,imaicd09,
                              imaicd10,imaicd11,imaicd12) 
                       VALUES(l_res,g_icw.icw22,'','','9','3','',
                              '','N','N','N',g_icw.icw01,100)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","imaicd_file",l_res,g_icw.icw01,SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         EXIT FOREACH
      END IF
         
   END FOREACH
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t030_wafer()
   DEFINE l_icr01 LIKE icr_file.icr01
   DEFINE l_ice01 LIKE ice_file.ice01
   DEFINE l_ice16 LIKE ice_file.ice16
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 != 'Y' THEN
      CALL cl_err(g_icw.icw01,'aic-953',0)
      RETURN
   END IF
 
   DECLARE sel_ice CURSOR FOR
    SELECT ice16
      FROM ice_file
     WHERE ice01 = l_ice01
       AND ice02 = g_icw.icw22
       AND ice14 = g_icw.icw23
 
   FOREACH sel_ice INTO l_ice16
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF cl_null(l_ice16) THEN
         CALL cl_err(l_ice16,'aic-990',1)
         EXIT FOREACH
      END IF
 
      CALL s_aic_bom(l_icr01,l_ice01,g_icw.icw01)
 
   END FOREACH
 
   OPEN WINDOW t030_1_w WITH FORM "aic/42f/aict030_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("aict030_1")
 
   INPUT l_icr01,l_ice01 WITHOUT DEFAULTS FROM icr01,ice01
 
      AFTER FIELD icr01
         IF NOT cl_null(l_icr01) THEN
            SELECT icr01
              FROM icr_file
             WHERE icr01 = l_icr01
               AND icr02 = '3'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","icr_file",l_icr01,'',SQLCA.sqlcode,"","sel icr:",1)
               NEXT FIELD icr01
            END IF
         END IF
 
      AFTER FIELD ice01
         IF NOT cl_null(l_ice01) THEN
            SELECT DISTINCT ice01
              FROM ice_file
             WHERE ice02 = g_icw.icw22
               AND ice14 = g_icw.icw23
               AND ice01 = l_ice01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","ice_file",l_ice01,g_icw.icw22,SQLCA.sqlcode,"","sel ice:",1)
               NEXT FIELD ice01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icr01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_icr1"
                 LET g_qryparam.arg1 = "4"
                 LET g_qryparam.default1 = l_icr01
                 CALL cl_create_qry() RETURNING l_icr01
                 DISPLAY l_icr01 TO icr01
                 NEXT FIELD icr01
            WHEN INFIELD(ice01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ice_1"
                 LET g_qryparam.arg1 = g_icw.icw22
                 LET g_qryparam.arg2 = g_icw.icw23
                 LET g_qryparam.default1 = l_ice01
                 CALL cl_create_qry() RETURNING l_ice01
                 DISPLAY l_ice01 TO ice01
                 NEXT FIELD ice01
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
      CLOSE WINDOW t030_1_w
      RETURN
   END IF
 
   CLOSE WINDOW t030_1_w
 
END FUNCTION
 
FUNCTION t030_maintain()
   DEFINE l_ice16 LIKE ice_file.ice16
   DEFINE l_cmd   STRING
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 != 'Y' THEN
      CALL cl_err(g_icw.icw01,'aic-953',0)
      RETURN
   END IF
 
   IF NOT cl_null(g_icw.icw22) THEN
      LET l_ice16 = NULL
      SELECT ice16 INTO l_ice16
        FROM ice_file
       WHERE ice02 = g_icw.icw22
         AND ice14 = g_icw.icw23
      IF l_ice16 IS NULL THEN
         CALL cl_err(g_icw.icw01,'aic-950',0)
         RETURN
      END IF
      LET l_cmd = "aici018  '",l_ice16,"' "
      CALL cl_cmdrun(l_cmd)
   ELSE
      CALL cl_err(g_icw.icw22,'aic-993',1)
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION t030_group()
   DEFINE l_ice16 LIKE ice_file.ice16
   DEFINE l_cmd   STRING
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 =  g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 != 'Y' THEN
      CALL cl_err(g_icw.icw18,'aic-953',1)
      RETURN
   END IF
 
   IF NOT cl_null(g_icw.icw22) THEN
      LET l_ice16 = NULL
      SELECT ice16 INTO l_ice16
        FROM ice_file
       WHERE ice02 = g_icw.icw22
         AND ice14 = g_icw.icw23
      IF l_ice16 IS NULL THEN
         CALL cl_err(g_icw.icw01,'aic-950',0)
         RETURN
      END IF
      LET l_cmd = "aici014  '",g_icw.icw22,"' '",g_icw.icw23,"' "
      CALL cl_cmdrun(l_cmd)
   ELSE
      CALL cl_err(g_icw.icw22,'aic-993',1)
      RETURN
   END IF
 
END FUNCTION
 
#FUNCTION t030_v() #CHI-D20010
FUNCTION t030_v(p_type) #CHI-D20010
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010
 
   IF cl_null(g_icw.icw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_icw.* FROM icw_file
    WHERE icw01 = g_icw.icw01
 
   IF g_icw.icwacti ='N' THEN
      CALL cl_err(g_icw.icw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_icw.icw18 = 'Y' THEN
      CALL cl_err(g_icw.icw01,'9023',0)
      RETURN
   END IF
 
#  IF g_icw.icwmksg = 'Y' THEN
#     CALL cl_err(g_icw.icw01,'axm4009',0)
#     RETURN
#  END IF
  
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_icw.icw18 ='X' THEN RETURN END IF
   ELSE
      IF g_icw.icw18 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   IF g_icw.icw18 != 'Y' THEN
     #IF g_icw.icw18 = 'X' THEN #CHI-D20010
      IF p_type = 2 THEN        #CHI-D20010
         IF NOT cl_confirm('aic-952') THEN
            RETURN
         ELSE
            LET g_icw.icw18 = 'N'
            UPDATE icw_file
               SET icw18 = g_icw.icw18
             WHERE icw01 = g_icw.icw01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd icw:',SQLCA.SQLCODE,0)
               LET g_icw.icw18 = "X"
               DISPLAY BY NAME g_icw.icw18
               RETURN
            ELSE
               DISPLAY BY NAME g_icw.icw18
            END IF
         END IF
      ELSE
         IF NOT cl_confirm('aic-951') THEN
            RETURN
         ELSE
            LET g_icw.icw18 = 'X'
            UPDATE icw_file
               SET icw18 = g_icw.icw18
             WHERE icw01 = g_icw.icw01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd icw:',SQLCA.SQLCODE,0)
               LET g_icw.icw18 = "N"
               DISPLAY BY NAME g_icw.icw18
               RETURN
            ELSE
               DISPLAY BY NAME g_icw.icw18
            END IF
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t030_pic()
   CASE g_icw.icw18
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE
 
   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_icw.icwacti)
END FUNCTION
 
FUNCTION t030_out()
DEFINE
    l_i             LIKE type_file.num5,
    sr              RECORD
        icw01       LIKE icw_file.icw01,                  #
        icw02       LIKE icw_file.icw02,                  #
        occ02       LIKE occ_file.occ02,                  #
        icw03       LIKE icw_file.icw03,                  #
        gen02       LIKE gen_file.gen02,                  #
        icw04       LIKE icw_file.icw04,                  #
        gem02       LIKE gem_file.gem02,                  #
        icw05       LIKE icw_file.icw05,                  #
        icw05_desc  LIKE ima_file.ima02,                  #
        icw06       LIKE icw_file.icw06,                  #
        icw10       LIKE icw_file.icw10,                  #
        icw22       LIKE icw_file.icw22,                  #
        icw22_desc  LIKE ima_file.ima02,                  #
        icw23       LIKE icw_file.icw23,                  #
        icw13       LIKE icw_file.icw13,                  #
        icw14       LIKE icw_file.icw14,                  #
        icw15       LIKE icw_file.icw15,                  #
        icw16       LIKE icw_file.icw16,                  #
        icw18       LIKE icw_file.icw18,                  #
        icx02       LIKE icx_file.icx02,                  #
        icx03       LIKE icx_file.icx03,                  #
        icx03_desc  LIKE ima_file.ima02,                  #
        icx26       LIKE icx_file.icx26,                  #
        icx04       LIKE icx_file.icx04,                  #
        icx05       LIKE icx_file.icx05,                  #
        icx06       LIKE icx_file.icx06,                  #
        icx07       LIKE icx_file.icx07,                  #
        icx23       LIKE icx_file.icx23,                  #
        icx08       LIKE icx_file.icx08,                  #
        icx09       LIKE icx_file.icx09,                  #
        icx24       LIKE icx_file.icx24,                  #
        icx10       LIKE icx_file.icx10,                  #
        icx11       LIKE icx_file.icx11,                  #
        icx12       LIKE icx_file.icx12,                  #
        icx13       LIKE icx_file.icx13,                  #
        icx14       LIKE icx_file.icx14,                  #
        icx15       LIKE icx_file.icx15,                  #
        icx16       LIKE icx_file.icx16,                  #
        icx17       LIKE icx_file.icx17,                  #
        icx18       LIKE icx_file.icx18,                  #
        icx19       LIKE icx_file.icx19,                  #
        icx20       LIKE icx_file.icx20,                  #
        icx21       LIKE icx_file.icx21,                  #
        icx22       LIKE icx_file.icx22                   #
                    END RECORD,
    l_name          LIKE type_file.chr20,                 #External(Disk) file name
    l_wc            STRING
 
    IF cl_null(g_icw.icw01) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc = " icw01 = '",g_icw.icw01," '"
       LET g_wc2= " 1=1 "
    END IF
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
    CALL cl_del_data(g_table)
 
    LET g_sql = "SELECT icw01,icw02,'',icw03,'',icw04,'',icw05,",
                "       '',icw06,icw10,icw22,'',icw23,icw13,icw14,",
                "       icw15,icw16,icw18,icx02,icx03,'',icx26,icx04,",
                "       icx05,icx06,icx07,icx23,icx08,icx09,icx24,icx10,",
                "       icx11,icx12,icx13,icx14,icx15,icx16,icx17,icx18,",
                "       icx19,icx20,icx21,icx22 ",
                " FROM  icw_file,icx_file",
                " WHERE icw01 = icx01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
    LET g_sql = g_sql CLIPPED," ORDER BY icx01,icx02"
    PREPARE t030_p1 FROM g_sql                            #RUNTIME 編譯
    IF STATUS THEN
       CALL cl_err('t030_p1',STATUS,0)
    END IF
    DECLARE t030_co CURSOR FOR t030_p1
 
    FOREACH t030_co INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT occ02 INTO sr.occ02
         FROM occ_file
        WHERE occ01 = sr.icw02
 
       SELECT gen02 INTO sr.gen02
         FROM gen_file
        WHERE gen01 = sr.icw03
 
       SELECT gem02 INTO sr.gem02
         FROM gem_file
        WHERE gem01 = sr.icw04
 
       SELECT ima02 INTO sr.icw05_desc
         FROM ima_file
        WHERE ima01 = sr.icw05
 
       SELECT ima02 INTO sr.icw22_desc
         FROM ima_file
        WHERE ima01 = sr.icw22
 
       SELECT ima02 INTO sr.icx03_desc
         FROM ima_file
        WHERE ima01 = sr.icx03
 
       EXECUTE insert_prep USING sr.*
    END FOREACH
 
    #是否列印選擇條件
    #將cl_wcchp轉換後的g_wc放到l_wc,不要改變原來g_wc的值,不然第二次執行會有問題
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'icw01,icw02,icw03,icw04,icw05,icw06,
                           icw10,icw22,icw23,icw14,icw15,icw16,
                           icw18,icwuser,icwgrup,icwacti,icwmodu,
                           icwdate')
            RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
 
    LET g_str = l_wc
#   CALL cl_prt_cs1('aict030','aict030',g_sql,g_str)
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,g_table CLIPPED
    CALL cl_prt_cs3('aict030','aict030',g_sql,g_str)
 
    CLOSE t030_co
    ERROR ""
END FUNCTION
#No.FUN-7B0018 Create this program
#No.FUN-830076 --過單

