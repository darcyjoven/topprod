# Prog. Version..: '5.30.06-13.04.15(00010)'     #
#
# Pattern name....: s_icdout.4gl
# Descriptions....: 刻號/BIN出庫資料維護作業
# SYNTAX..........: s_icdout(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,
#                             p_argv6,p_argv7,p_argv8,p_argv9,p_argv10
# Input parameter.: p_argv1   料件編號
#                   p_argv2   倉庫
#                   p_argv3   儲位
#                   p_argv4   批號
#                   p_argv5   單位
#                   p_argv6   數量
#                   p_argv7   單據編號
#                   p_argv8   單據項次
#                   p_argv9   單據日期
#                   p_argv10  調撥否 (Y:for aimt324)
#                   p_argv11  撥入倉庫 (for aimt324)
#                   p_argv12  撥入儲位(for aimt324)
#                   p_argv13  撥入批號 (for aimt324)
#                   p_argv14  撥入單位(for aimt324)
# RETURN          : g_idb16(DIE)
# Date & Author..:No.FUN-7B0016  07/12/11 By ve007  #No.FUN-830130 By ve007
# Modify.........: No.CHI-830032 08/03/31 By kim GP5.1整合測試修改
# Modify.........: No.MOD-890023 08/09/02 By chenyu icd版功能修改
# Modify.........: No.FUN-930038 09/03/06 By kim 借貨單的刻號/BIN資料過帳時要拋轉至調撥單，調撥單刪除時要拋轉回借貨單
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:MOD-A60021 10/07/16 By Pengu 外部參數值若為NULL時，訊息不夠明確
# Modify.........: No:FUN-AA0007 10/10/14 By jan 批號hold(新增s_icdout_holdlot()FUNCTION)
# Modify.........: No.FUN-B30192 11/05/09 By shenyang       改icb05為imaicd14
# Modify.........: No:CHI-B70044 11/08/02 By johung 批號hold，該料走刻號/BIN時，未hold住的量可挑選
# Modify.........: No:TQC-B90174 11/09/26 By lixh1 糾正idc21計算錯誤
# Modify.........: No.TQC-BA0136 11/10/25 By jason ida17存檔前判斷如果為null給0
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No:FUN-B40081 11/11/14 By jason 多倉儲出貨
# Modify.........: No.FUN-BB0085 11/12/08 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-BC0036 11/12/19 By jason 新增刻號/BIN調整單功能
# Modify.........: No.MOD-C30515 12/03/12 By bart 修改變數大小
# Modify.........: No.FUN-C30302 12/04/13 By bart 刻號/BIN數量不等於單據數量時,詢問是否回寫
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.TQC-C60012 12/06/01 By bart 當料號的料件狀態為2時(CP),要可以維護idb16(DIE數)
# Modify.........: No.TQC-C60014 12/06/01 By bart 當調整的料號有做DateCode管理(imaicd09='Y')時,要可以改idb15(DATECODE)
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:FUN-C30080 12/10/12 By bart 刻號BIN出庫挑選時請加入全選及取消全選的按鈕
# Modify.........: No:CHI-D30030 13/03/25 By bart 異動數量為0時可以die數不換算成異動數

DATABASE ds
GLOBALS "../../config/top.global"

#模組變數 (Module Variables)
DEFINE
    g_argv1          LIKE idb_file.idb01, #料件編號
    g_argv2          LIKE idb_file.idb02, #倉庫
    g_argv3          LIKE idb_file.idb03, #儲位
    g_argv4          LIKE idb_file.idb04, #批號
    g_argv5          LIKE idb_file.idb12, #單位
    g_argv6          LIKE idb_file.idb11, #數量
    g_argv7          LIKE idb_file.idb07, #單據編號
    g_argv8          LIKE idb_file.idb08, #單據項次
    g_argv9          LIKE idb_file.idb09, #異動日期
    g_argv10         LIKE type_file.chr1, #調撥否
    g_argv11         LIKE idb_file.idb02, #撥入倉庫
    g_argv12         LIKE idb_file.idb03, #撥入儲位
    g_argv13         LIKE idb_file.idb04, #撥入批號
    g_argv14         LIKE idb_file.idb12, #撥入單位
    g_idc            DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
                        cho     LIKE type_file.chr1, # 選取
                        idc05   LIKE idc_file.idc05, # 刻號
                        idc06   LIKE idc_file.idc06, # BIN
                        idc08   LIKE idc_file.idc08, # 庫存數量
                        idc21   LIKE idc_file.idc21, # 已置備量
                        idc08_a LIKE idc_file.idc08, # 出庫數量
                        idc12   LIKE idc_file.idc12, # GROSS DIE
                        idc11   LIKE idc_file.idc11, # DATECODE
                        idc13   LIKE idc_file.idc13, # YIELD
                        idc14   LIKE idc_file.idc14, # TEST #
                        idc15   LIKE idc_file.idc15, # DEDUCT
                        idc16   LIKE idc_file.idc16, # PASS BIN
                        idc09   LIKE idc_file.idc09, # 母體料號
                        idc10   LIKE idc_file.idc10, # 母批
                        idc19   LIKE idc_file.idc19, # 接單料號
                        idc20   LIKE idc_file.idc20  # 備注
                     END RECORD,
    g_idc_t          RECORD                 #程序變數(舊值)
                        cho     LIKE type_file.chr1, #選取
                        idc05   LIKE idc_file.idc05, #刻號
                        idc06   LIKE idc_file.idc06, #BIN
                        idc08   LIKE idc_file.idc08,
                        idc21   LIKE idc_file.idc21,
                        idc08_a LIKE idc_file.idc08,
                        idc12   LIKE idc_file.idc12,
                        idc11   LIKE idc_file.idc11,
                        idc13   LIKE idc_file.idc13,
                        idc14   LIKE idc_file.idc14,
                        idc15   LIKE idc_file.idc15,
                        idc16   LIKE idc_file.idc16,
                        idc09   LIKE idc_file.idc09,
                        idc10   LIKE idc_file.idc10,
                        idc19   LIKE idc_file.idc19,
                        idc20   LIKE idc_file.idc20
                     END RECORD,
    g_idb            DYNAMIC ARRAY OF RECORD    #程序變數 (Program Variables)
                        idb05  LIKE idb_file.idb05, #刻號
                        idb06  LIKE idb_file.idb06, #BIN
                        idb10  LIKE idb_file.idb10, #庫存數量
                        idb11  LIKE idb_file.idb11, #出庫數量
                        idb13  LIKE idb_file.idb13, #母體
                        idb14  LIKE idb_file.idb14, #母批
                        idb16  LIKE idb_file.idb16, #DIE數
                        idb15  LIKE idb_file.idb15, #DATECODE
                        idb17  LIKE idb_file.idb17, #YIELD
                        idb18  LIKE idb_file.idb18, #TEST #
                        idb19  LIKE idb_file.idb19, #DEDUCT
                        idb20  LIKE idb_file.idb20, #PASS IN
                        idb21  LIKE idb_file.idb21, #接單料號
                        idb25  LIKE idb_file.idb25, #備注
                        idb26  LIKE idb_file.idb26, #變更前刻號 #FUN-BC0036
                        idb27  LIKE idb_file.idb27  #變更前BIN #FUN-BC0036
                     END RECORD,
    g_idb_t          RECORD
                        idb05  LIKE idb_file.idb05,
                        idb06  LIKE idb_file.idb06,
                        idb10  LIKE idb_file.idb10,
                        idb11  LIKE idb_file.idb11,
                        idb13  LIKE idb_file.idb13,
                        idb14  LIKE idb_file.idb14,
                        idb16  LIKE idb_file.idb16,
                        idb15  LIKE idb_file.idb15,
                        idb17  LIKE idb_file.idb17,
                        idb18  LIKE idb_file.idb18,
                        idb19  LIKE idb_file.idb19,
                        idb20  LIKE idb_file.idb20,
                        idb21  LIKE idb_file.idb21,
                        idb25  LIKE idb_file.idb25,
                        idb26  LIKE idb_file.idb26,   #FUN-BC0036
                        idb27  LIKE idb_file.idb27    #FUN-BC0036
                     END RECORD,
    g_s_icdout        LIKE type_file.chr1,       #s_icdout.4gl的g_s_icdout
    g_idc08_t1       LIKE idc_file.idc08,       #庫存數量統計
    g_idc08_t2       LIKE idc_file.idc08,       #挑選數量統計
    g_idc08_t2_t     LIKE idc_file.idc08,       #挑選數量統計
    g_idb10_t        LIKE idb_file.idb10,       #庫存數量統計
    g_idb11_t        LIKE idb_file.idb11,       #出庫數量統計
#   g_icb05          LIKE icb_file.icb05,       #GROSS DIE   #FUN-B30192
    g_imaicd14       LIKE imaicd_file.imaicd14, #FUN-B30192
    g_idc12_t        LIKE idc_file.idc12,       #庫存DIE數統計
    g_idb16_t        LIKE idb_file.idb16,       #出庫DIE數統計
    g_idb16          LIKE idb_file.idb16,       #回傳DIE數統計
    g_collect        LIKE type_file.chr1,       #成套發料否
    g_sql            STRING,
    g_rec_b,g_rec_b2 LIKE type_file.num5,       #單身筆數
    l_ac             LIKE type_file.num5        #目前處理的ARRAY CNT

DEFINE g_forupd_sql  STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt         LIKE type_file.num5
DEFINE g_msg         LIKE type_file.chr1000
DEFINE g_row_count   LIKE type_file.num5
DEFINE g_curs_index  LIKE type_file.num5
DEFINE g_ogb17_flag  LIKE type_file.num5        #是否為多倉儲出貨 FUN-B40081
DEFINE g_idbch_flag  LIKE type_file.num5        #是否為刻號/BIN調整單 FUN-BC0036
DEFINE l_r           LIKE type_file.chr1        #FUN-C30302

FUNCTION s_icdout(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7,
                   p_argv8,p_argv9,p_argv10,p_argv11,p_argv12,p_argv13,p_argv14)
DEFINE p_argv1       LIKE idb_file.idb01
DEFINE p_argv2       LIKE idb_file.idb02
DEFINE p_argv3       LIKE idb_file.idb03
DEFINE p_argv4       LIKE idb_file.idb04
DEFINE p_argv5       LIKE idb_file.idb12
DEFINE p_argv6       LIKE idb_file.idb11
DEFINE p_argv7       LIKE idb_file.idb07
DEFINE p_argv8       LIKE idb_file.idb08
DEFINE p_argv9       LIKE idb_file.idb09
DEFINE p_argv10      LIKE type_file.chr1
DEFINE p_argv11      LIKE idb_file.idb02
DEFINE p_argv12      LIKE idb_file.idb03
DEFINE p_argv13      LIKE idb_file.idb04
DEFINE p_argv14      LIKE idb_file.idb12
#DEFINE l_imaicd08    LIKE imaicd_file.imaicd08           #顯示明細否 #FUN-BA0051 mark
DEFINE l_flag        LIKE type_file.num5
DEFINE l_fac         DECIMAL(16,8)
DEFINE l_n           LIKE type_file.num5
DEFINE l_msg         LIKE type_file.chr1000
DEFINE l_idc17       LIKE idc_file.idc17                 #No.FUN-810130
DEFINE l_msg1        STRING    #FUN-BC0036

   WHENEVER ERROR CALL cl_err_msg_log

  #------------------------------No:MOD-A60021 modify
  #IF cl_null(p_argv1) OR cl_null(p_argv2) OR cl_null(p_argv5) OR
  #   cl_null(p_argv6) OR cl_null(p_argv7) OR cl_null(p_argv8) OR
  #   cl_null(p_argv9) OR cl_null(p_argv10) THEN
  #   CALL cl_err('s_icdout()','sub-170',1)
  #   RETURN 0
  #END IF
   IF cl_null(p_argv1) THEN
      LET l_msg = NULL
      LET l_msg = cl_getmsg('asr-009',g_lang)
      CALL cl_err(l_msg,'sub-522',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

   IF cl_null(p_argv2) THEN
      LET l_msg = NULL
      LET l_msg = cl_getmsg('apm-335',g_lang)
      CALL cl_err(l_msg,'sub-522',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

   IF cl_null(p_argv5) THEN
      LET l_msg = NULL
      LET l_msg = cl_getmsg('asm-312',g_lang)
      CALL cl_err(l_msg,'sub-522',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

   IF cl_null(p_argv6) THEN
      LET l_msg = NULL
      LET l_msg = cl_getmsg('afa-331',g_lang)
      CALL cl_err(l_msg,'sub-522',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

   IF cl_null(p_argv7) THEN
      LET l_msg = NULL
      LET l_msg = cl_getmsg('lib-258',g_lang)
      CALL cl_err(l_msg,'sub-522',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

   IF cl_null(p_argv8) THEN
      LET l_msg = NULL
      LET l_msg = cl_getmsg('aap-417',g_lang)
      CALL cl_err(l_msg,'sub-522',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

   IF cl_null(p_argv9) THEN
      LET l_msg = NULL
      LET l_msg = cl_getmsg('lib-035',g_lang)
      CALL cl_err(l_msg,'sub-522',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

   IF cl_null(p_argv10) THEN
      CALL cl_err('s_icdout()','sub-170',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

  #------------------------------No:MOD-A60021 end

   #調撥否='Y',表示是由倉庫直接調撥作業呼叫執行(aimt324)
   #須檢查相關信息不可空白，撥入倉庫，撥入單位
   IF p_argv10 = "Y" THEN
      #傳入值不可空白
      IF cl_null(p_argv11) OR cl_null(p_argv14) THEN
         CALL cl_err('','sub-170',1)
         RETURN 0,"N",0  #FUN-C30302
      END IF

   #此料號須做刻號管理，撥出倉儲的單位需與撥入倉儲的單位相同，請查核！
      IF p_argv5 != p_argv14 THEN
         CALL cl_err(p_argv1,'sub-181',1)
         RETURN 0,"N",0  #FUN-C30302
      END IF

      IF cl_null(p_argv12) THEN
         LET p_argv12 = ' '   #撥入儲位
      END IF

      IF cl_null(p_argv13) THEN
         LET p_argv13 = ' '   #撥入批號
      END IF

   END IF
   #FUN-BA0051 --START mark--
   #imaicd08為'Y' 時才可做
   #LET l_imaicd08 = NULL
   #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
   #   WHERE imaicd00 = p_argv1
   #IF l_imaicd08 != "Y"  OR cl_null(l_imaicd08) THEN
   #FUN-BA0051 --END mark--
   IF NOT s_icdbin(p_argv1) THEN   #FUN-BA0051
      CALL cl_err(p_argv1,'sub-175',1)
      RETURN 0,"N",0  #FUN-C30302
   END IF

   #取Gross DIE
  #LET g_icb05 = NULL
  #SELECT icb05 INTO g_icb05 FROM icb_file WHERE icb01 = p_argv1
   LET g_imaicd14 =NULL                                      #FUN-B30192
   CALL s_icdfun_imaicd14(p_argv1)   RETURNING g_imaicd14    #FUN-B30192
   IF cl_null(p_argv3) THEN
      LET p_argv3 = ' '  #儲位
   END IF

   IF cl_null(p_argv4) THEN
      LET p_argv4 = ' '  #批號
   END IF

   # 檢查該料件庫存已被hold lot(沒有未hold 住的量可以挑選時)，
   # 則show訊息，請user更新倉儲批資料
#CHI-B70044 -- begin --
#  LET l_n = 0
#  SELECT DISTINCT idc17 INTO l_idc17  #CHI-830032
#     FROM idc_file
#    WHERE idc01 = p_argv1
#      AND idc02 = p_argv2
#      AND idc03 = p_argv3
#      AND idc04 = p_argv4
#  #No.FUN-830130 --begin--
#  CASE
#     WHEN  SQLCA.sqlcode <>0
#       CALL cl_err('',SQLCA.sqlcode,0)
#       RETURN 0
#     WHEN l_idc17='Y'  #CHI-830032
#       CALL cl_err('hold lot:','sub-182',1)
#       RETURN 0
#   END CASE
# #No.FUN-830130 --end--
#CHI-B70044 -- end --
   OPEN WINDOW s_icdout_w AT 2,2 WITH FORM "sub/42f/s_icdout"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("s_icdout")

   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   LET g_argv3 = p_argv3
   LET g_argv4 = p_argv4
   #轉換成img的單位及數量
   SELECT img09 INTO g_argv5 FROM img_file
    WHERE img01 = g_argv1
      AND img02 = g_argv2
      AND img03 = g_argv3
      AND img04 = g_argv4
   IF SQLCA.SQLCODE THEN
      CALL cl_err('select img09',SQLCA.SQLCODE,1)
      CLOSE WINDOW s_icdout_w
      RETURN 0,"N",0  #FUN-C30302
   END IF
   CALL s_umfchk(g_argv1,p_argv5,g_argv5) RETURNING l_flag,l_fac
   IF l_flag = 1 THEN
      LET l_msg = p_argv5 CLIPPED,'->',g_argv5 CLIPPED
      CALL cl_err(l_msg CLIPPED,'aqc-500',1)
      CLOSE WINDOW s_icdout_w
      RETURN 0,"N",0  #FUN-C30302
   END IF
   LET g_argv6 = p_argv6 * l_fac    #出庫數量 (TO  img09)
   LET g_argv7 = p_argv7
   LET g_argv8 = p_argv8
   LET g_argv9 = p_argv9
   LET g_argv10 = p_argv10
   LET g_argv11 = p_argv11
   LET g_argv12 = p_argv12
   LET g_argv13 = p_argv13
   LET g_argv14 = p_argv14

   #FUN-BC0036 --START--
   IF g_prog[1,7] = 'aict324' THEN
      LET g_idbch_flag = TRUE      
      CALL cl_getmsg('aic-324',g_lang) RETURNING l_msg1
      CALL cl_set_comp_att_text('idb05',l_msg1 CLIPPED)
      CALL cl_getmsg('aic-325',g_lang) RETURNING l_msg1
      CALL cl_set_comp_att_text('idb06',l_msg1 CLIPPED)
   ELSE
      LET g_idbch_flag = FALSE
   END IF
   #FUN-BC0036 --END--

   #同單號+項次，料/倉/儲/批不可更改過
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM idb_file
      WHERE idb07 = p_argv7
        AND idb08 = p_argv8
        AND (idb01 != g_argv1 OR idb02 != g_argv2 OR
             idb03 != g_argv3 OR idb04 != g_argv4)
   IF l_n > 0 THEN
      IF NOT g_ogb17_flag THEN   #FUN-B40081
         CALL cl_err('','sub-177',1)
         CLOSE WINDOW s_icdout_w
         RETURN 0,"N",0  #FUN-C30302
      END IF   #FUN-B40081
   END IF

   #判斷來源單號是否為成套發料單號
   LET g_collect = 'N'
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM sfp_file WHERE sfp01 = p_argv7 AND sfp06 IN ('1','D')         #FUN-C70014 sfp06='1' -> sfp06 IN('1','D')
   IF l_n > 0 THEN LET g_collect = 'Y' END IF

   CALL s_icdout_show()

   CALL s_icdout_menu()

   CLOSE WINDOW s_icdout_w

   LET INT_FLAG = 0
   CALL s_icdout_DIE() RETURNING g_idb16
        #RETURN g_idb16  #FUN-C30302
   RETURN g_idb16,l_r,g_idb11_t    #FUN-C30302

END FUNCTION

FUNCTION s_icdout_menu()

   WHILE TRUE
      CALL s_icdout_bp("G")
      CASE g_action_choice

        #刻號BIN 庫存明細資料選取
         WHEN "one_detail"
            CALL s_icdout_b()

        #查詢刻號BIN庫存明細資料選取
         WHEN "qry_one_detail"
            CALL s_icdout_bp2('G')

        #刻號BIN出庫資料維護
         WHEN "two_detail"
            CALL s_icdout_b2()

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            #FUN-BC0036 --START--
            IF g_idbch_flag THEN
               IF NOT s_icdout_idb_chk() THEN
                  CONTINUE WHILE
               END IF
            END IF
            #FUN-BC0036 --END--
            #FUN-C30302---begin
            IF g_argv6 <> g_idb11_t THEN 
               IF cl_confirm('aic-328') THEN
                  LET l_r = "Y"
               ELSE
                  LET l_r = "N"
               END IF
            END IF
            #FUN-C30302---end
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

      END CASE
   END WHILE
END FUNCTION

#資料顯示
FUNCTION s_icdout_show()
DEFINE l_ima02   LIKE ima_file.ima02
DEFINE l_ima021  LIKE ima_file.ima021

   SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
    WHERE ima01 = g_argv1

   DISPLAY g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,
           g_argv6,g_argv7,g_argv8,g_argv9,l_ima02,l_ima021
        TO FORMONLY.p_argv1,FORMONLY.p_argv2,FORMONLY.p_argv3,FORMONLY.p_argv4,
           FORMONLY.p_argv5,FORMONLY.p_argv6,FORMONLY.p_argv7,FORMONLY.p_argv8,
           FORMONLY.p_argv9,FORMONLY.ima02,FORMONLY.ima021

  #DISPLAY g_icb05 TO FORMONLY.icb05
   DISPLAY g_imaicd14 TO FORMONLY.icb05  #FUN-B30192
   LET g_row_count = 1
   DISPLAY g_row_count TO FORMONLY.cnt

   CALL s_icdout_b_fill()       #單身
   CALL s_icdout_g_b2()         #自動產生
   CALL s_icdout_b2_fill()      #單身

   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION s_icdout_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,    #檢查重復用
   p_cmd           LIKE type_file.chr1,    #處理狀態
   l_allow_insert  LIKE type_file.num5,    #可新增否
   l_allow_delete  LIKE type_file.num5,    #可刪除否
   l_flag          LIKE type_file.chr1     #選取狀態
DEFINE l_cnt       LIKE type_file.num5     #CHI-B70044 add

   CALL cl_opmsg('b')

   CALL s_icdout_b_fill()

   IF g_rec_b > 0 THEN
      LET l_ac = 1
   END IF

   INPUT ARRAY g_idc WITHOUT DEFAULTS FROM s_idc.*
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
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         LET g_s_icdout = 'Y'
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_idc_t.* = g_idc[l_ac].*  #BACKUP
            CALL cl_show_fld_cont()
         END IF
         NEXT FIELD cho
         CALL s_icdout_set_entry_b(p_cmd)
         CALL s_icdout_set_no_entry_b(p_cmd)

      BEFORE FIELD cho
         CALL s_icdout_set_entry_b(p_cmd)

      AFTER FIELD cho
         IF NOT cl_null(g_idc[l_ac].cho) THEN
            CALL s_icdout_set_no_entry_b(p_cmd)
         END IF

      #選取的當下(點選checkbox),若為打勾則default出庫量=庫存量-已備置量，
      #若為不打勾則default出庫量=0
      #并即時更新顯示出出庫量加總欄位
      ON CHANGE cho
#CHI-B70044 -- begin --
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
            FROM idc_file
            WHERE idc01 = g_argv1
              AND idc02 = g_argv2
              AND idc03 = g_argv3
              AND idc04 = g_argv4
              AND idc05 = g_idc[l_ac].idc05
              AND idc06 = g_idc[l_ac].idc06
              AND idc17='Y'
         IF l_cnt > 0 THEN
            CALL cl_err('','sub-237',1)
            NEXT FIELD cho
         END IF
#CHI-B70044 -- end --
         IF g_idc[l_ac].cho = 'Y' THEN
            LET g_idc[l_ac].idc08_a = g_idc[l_ac].idc08 -
                                      g_idc[l_ac].idc21
         ELSE
            LET g_idc[l_ac].idc08_a =  0
         END IF
         DISPLAY BY NAME g_idc[l_ac].idc08_a
         LET g_idc08_t2_t = g_idc08_t2
         CALL s_icdout_chked()
         CALL s_icdout_b1_tot()

      AFTER FIELD idc08_a   #出庫數量
         IF NOT cl_null(g_idc[l_ac].idc08_a) THEN
            IF g_idc[l_ac].idc08_a < 0 THEN
               CALL cl_err(g_idc[l_ac].idc08_a,'aap-022',0)
               LET g_idc[l_ac].idc08_a = g_idc_t.idc08_a
               NEXT FIELD idc08_a
            END IF
            #須小于庫存量
            IF g_idc[l_ac].idc08_a >
               (g_idc[l_ac].idc08 - g_idc[l_ac].idc21) THEN
               CALL cl_err(g_idc[l_ac].idc08_a,'axm-280',0)
               LET g_idc[l_ac].idc08_a = g_idc_t.idc08_a
               NEXT FIELD idc08_a
            END IF
            LET g_idc08_t2_t = g_idc08_t2
            CALL s_icdout_b1_tot()
            IF cl_null(g_idb11_t) THEN
               LET g_idb11_t = 0
            END IF
            #挑選數量總計需小于單頭出庫數量
            IF (g_idc08_t2 + g_idb11_t) > g_argv6 THEN
               CALL cl_err(g_idc[l_ac].idc08_a,'sub-183',0)
               LET g_idc[l_ac].idc08_a = g_idc_t.idc08_a
               CALL s_icdout_b1_tot()
               DISPLAY g_idc08_t2 TO FORMONLY.idc08_t2
               NEXT FIELD idc08_a
            END IF
            DISPLAY g_idc08_t2 TO FORMONLY.idc08_t2
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_idc[l_ac].* = g_idc_t.*
            EXIT INPUT
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_idc[l_ac].* = g_idc_t.*
            END IF
            EXIT INPUT
         END IF

         LET g_idc08_t2_t = g_idc08_t2
         CALL s_icdout_b1_tot()
         IF cl_null(g_idb11_t) THEN
            LET g_idb11_t = 0
         END IF
         #挑選數量總計需小于單頭出庫數量
         IF (g_idc08_t2 + g_idb11_t) > g_argv6 THEN
            CALL cl_err(g_idc08_t2,'sub-183',0)
            CALL s_icdout_b1_tot()
            DISPLAY g_idc08_t2 TO FORMONLY.idc08_t2
            NEXT FIELD cho
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

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

      #FUN-C30080---begin
      ON ACTION ALL
         FOR l_ac = 1 TO g_idc.getLength()
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
               FROM idc_file
               WHERE idc01 = g_argv1
                 AND idc02 = g_argv2
                 AND idc03 = g_argv3
                 AND idc04 = g_argv4
                 AND idc05 = g_idc[l_ac].idc05
                 AND idc06 = g_idc[l_ac].idc06
                 AND idc17='Y'
            IF l_cnt = 0 THEN
               LET g_idc[l_ac].cho = 'Y'
               LET g_idc[l_ac].idc08_a = g_idc[l_ac].idc08 -
                                         g_idc[l_ac].idc21
            END IF
            DISPLAY BY NAME g_idc[l_ac].cho
            DISPLAY BY NAME g_idc[l_ac].idc08_a
            LET g_idc08_t2_t = g_idc08_t2
            CALL s_icdout_chked()
            CALL s_icdout_b1_tot()
         END FOR
      ON ACTION no_all
         FOR l_ac = 1 TO g_idc.getLength()
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
               FROM idc_file
               WHERE idc01 = g_argv1
                 AND idc02 = g_argv2
                 AND idc03 = g_argv3
                 AND idc04 = g_argv4
                 AND idc05 = g_idc[l_ac].idc05
                 AND idc06 = g_idc[l_ac].idc06
                 AND idc17='Y'
            IF l_cnt = 0 THEN
               LET g_idc[l_ac].cho = 'N'
               LET g_idc[l_ac].idc08_a = 0
            END IF
            DISPLAY BY NAME g_idc[l_ac].cho
            DISPLAY BY NAME g_idc[l_ac].idc08_a
            LET g_idc08_t2_t = g_idc08_t2
            CALL s_icdout_chked()
            CALL s_icdout_b1_tot()
         END FOR
      #FUN-C30080---end

   END INPUT

   LET l_flag = "N"
   FOR l_n = 1 TO g_rec_b
      IF g_idc[l_n].cho = "Y" AND
         #g_idc[l_n].idc08_a > 0 THEN  #CHI-D30030
         g_idc[l_n].idc08_a >= 0 THEN  #CHI-D30030
         LET l_flag = "Y"
         EXIT FOR
      END IF
   END FOR

   IF l_flag = "Y" THEN
      IF NOT (cl_confirm("sub-184")) THEN
         ROLLBACK WORK
         RETURN
      END IF
   ELSE
      ROLLBACK WORK
      RETURN
   END IF

   CALL s_icdout_ins()

   IF g_s_icdout = "Y" THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF

   CALL s_icdout_b2_fill()
   #FUN-BC0036 --START--
   IF g_idbch_flag THEN
      CALL s_icdout_b2()
   END IF
   #FUN-BC0036 --END--
END FUNCTION

FUNCTION s_icdout_ins()
DEFINE l_i           LIKE type_file.num5
DEFINE l_flag        LIKE type_file.num5
DEFINE l_fac         DECIMAL(16,8)
DEFINE l_idb         RECORD LIKE idb_file.*
DEFINE l_cnt         LIKE type_file.num5   #CHI-B70044 add

   LET g_cnt = 0
   FOR l_i = 1 TO g_rec_b
      #將選取否打勾，并且出庫數量>0的，產生至idb_file
      #IF g_idc[l_i].cho = "Y" AND g_idc[l_i].idc08_a > 0 THEN #CHI-D30030
      IF g_idc[l_i].cho = "Y" AND g_idc[l_i].idc08_a >= 0 THEN #CHI-D30030
#CHI-B70044 -- begin --
         LET l_cnt = 0
         SELECT count(*) INTO l_cnt
            FROM idc_file
            WHERE idc01 = g_argv1
              AND idc02 = g_argv2
              AND idc03 = g_argv3
              AND idc04 = g_argv4
              AND idc05 = g_idc[l_i].idc05
              AND idc06 = g_idc[l_i].idc06
              AND idc17='Y'
         IF l_cnt > 0 THEN
            CALl cl_err('','sub-237',1)
            EXIT FOR
         END IF
#CHI-B70044 -- end --
         INITIALIZE l_idb.* TO NULL
         LET l_idb.idb01 = g_argv1
         LET l_idb.idb02 = g_argv2
         LET l_idb.idb03 = g_argv3
         LET l_idb.idb04 = g_argv4
         LET l_idb.idb05 = g_idc[l_i].idc05
         LET l_idb.idb06 = g_idc[l_i].idc06
         LET l_idb.idb07 = g_argv7
         LET l_idb.idb08 = g_argv8
         LET l_idb.idb09 = g_argv9
         LET l_idb.idb10 = g_idc[l_i].idc08
         LET l_idb.idb11 = g_idc[l_i].idc08_a
         LET l_idb.idb12 = g_argv5
         LET l_idb.idb10 = s_digqty(l_idb.idb10,l_idb.idb12)     #FUN-BB0085
         LET l_idb.idb11 = s_digqty(l_idb.idb11,l_idb.idb12)     #FUN-BB0085
         LET l_idb.idb13 = g_idc[l_i].idc09
         LET l_idb.idb14 = g_idc[l_i].idc10
         LET l_idb.idb15 = g_idc[l_i].idc11
         LET l_idb.idb16 = g_idc[l_i].idc12 *
                         (g_idc[l_i].idc08_a/g_idc[l_i].idc08)
         LET l_idb.idb16 = cl_digcut(l_idb.idb16,0)  #TQC-C60012
         LET l_idb.idb17 = g_idc[l_i].idc13
         LET l_idb.idb18 = g_idc[l_i].idc14
         LET l_idb.idb19 = g_idc[l_i].idc15
         LET l_idb.idb20 = g_idc[l_i].idc16
         LET l_idb.idb21 = g_idc[l_i].idc19
         LET l_idb.idb25 = g_idc[l_i].idc20

         #FUN-BC0036 --START--
         IF g_idbch_flag THEN
            LET l_idb.idb26 = g_idc[l_i].idc05
            LET l_idb.idb27 = g_idc[l_i].idc06
         END IF
         #FUN-BC0036 --END--

         LET l_idb.idbplant = g_plant #FUN-980012 add
         LET l_idb.idblegal = g_legal #FUN-980012 add
         IF l_idb.idb16 IS NULL THEN LET l_idb.idb16=0 END IF #TQC-BA0136

         INSERT INTO idb_file VALUES(l_idb.*)
#        IF SQLCA.sqlcode = -239 THEN #CHI-C30115 mark
         IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
            LET g_idc[l_i].idc08_a = s_digqty(g_idc[l_i].idc08_a,l_idb.idb12)    #FUN-BB0085
            UPDATE idb_file
               SET idb11 = idb11 + g_idc[l_i].idc08_a,
                   idb16 = idb16 + l_idb.idb16
             WHERE idb01 = g_argv1
               AND idb02 = g_argv2
               AND idb03 = g_argv3
               AND idb04 = g_argv4
               AND idb05 = g_idc[l_i].idc05
               AND idb06 = g_idc[l_i].idc06
               AND idb07 = g_argv7
               AND idb08 = g_argv8
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
               CALL cl_err("upd idb",SQLCA.sqlcode,1)
               LET g_s_icdout = "N"
               EXIT FOR
            END IF
         ELSE
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
               CALL cl_err("insert idb",SQLCA.sqlcode,1)
               LET g_s_icdout = "N"
               EXIT FOR
            END IF
         END IF
         #將刻號BIN庫存明細資料的庫存量指定給出庫資料后，
         #同步更新庫存明細的已置備量(idc21),避免在未過賬前
         #數量同時被2筆以上的出貨資料指定走
         UPDATE idc_file
            SET idc21 = idc21 + g_idc[l_i].idc08_a
          WHERE idc01 = g_argv1
            AND idc02 = g_argv2
            AND idc03 = g_argv3
            AND idc04 = g_argv4
            AND idc05 = g_idc[l_i].idc05
            AND idc06 = g_idc[l_i].idc06
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            CALL cl_err("update idc21",SQLCA.sqlcode,1)
            LET g_s_icdout = "N"
            EXIT FOR
         END IF
         #調撥否為'Y'時，同步產生或更新ida_file
         IF g_argv10 = "Y" THEN
            IF NOT s_icdout_insicin(l_idb.*,g_argv11,g_argv12,g_argv13) THEN #FUN-930038
               LET g_s_icdout = 'N'  #FUN-930038
               EXIT FOR
            END IF
         END IF
         LET g_cnt = g_cnt + 1
      END IF
   END FOR

   IF g_cnt = 0 THEN
      CALL cl_err('','axc-034',1)
      LET g_s_icdout = "N"
   END IF

END FUNCTION

#調撥否為'Y'時，同步產生或更新ida_file
FUNCTION s_icdout_insicin(p_idb,l_ida02,l_ida03,l_ida04)
   DEFINE p_idb    RECORD LIKE idb_file.*            #刻號BIN出庫明細資料
   DEFINE l_ida    RECORD LIKE ida_file.*   #刻號BIN入庫明細資料
   DEFINE l_ida02  LIKE ida_file.ida02  #FUN-930038
   DEFINE l_ida03  LIKE ida_file.ida03  #FUN-930038
   DEFINE l_ida04  LIKE ida_file.ida04  #FUN-930038

   INITIALIZE l_ida.* TO NULL
   LET l_ida.ida01 = p_idb.idb01            #料件編號
   LET l_ida.ida02 = l_ida02                #g_argv11  #倉庫
   LET l_ida.ida03 = l_ida03                #g_argv12  #儲位
   LET l_ida.ida04 = l_ida04                #g_argv13  #批號
   LET l_ida.ida05 = p_idb.idb05            #刻號
   LET l_ida.ida06 = p_idb.idb06            #BIN
   LET l_ida.ida07 = p_idb.idb07            #單據編號
   LET l_ida.ida08 = p_idb.idb08            #單據項次
   LET l_ida.ida09 = p_idb.idb09            #異動日期
   LET l_ida.ida10 = p_idb.idb11            #實收數量
   LET l_ida.ida11 = 0                      #不良數量
   LET l_ida.ida12 = 0                      #報廢數量
   LET l_ida.ida13 = p_idb.idb12            #單位
   LET l_ida.ida14 = p_idb.idb13            #母體編號
   LET l_ida.ida15 = p_idb.idb14            #母批
   LET l_ida.ida16 = p_idb.idb15            #DATECODE
   LET l_ida.ida17 = p_idb.idb16            #DIE數
   LET l_ida.ida18 = p_idb.idb17            #YIELD
   LET l_ida.ida19 = p_idb.idb18            #TEST #
   LET l_ida.ida20 = p_idb.idb19            #DEDUCT
   LET l_ida.ida21 = p_idb.idb20            #PASSBIN
   LET l_ida.ida22 = p_idb.idb21            #接單料號
   LET l_ida.ida27 = "N"                    #轉入否
   LET l_ida.ida28 = 1                      #異動別
   LET l_ida.ida29 = p_idb.idb25            #備注
   LET l_ida.idaplant = g_plant #FUN-980012 add
   LET l_ida.idalegal = g_legal #FUN-980012 add
   IF l_ida.ida17 IS NULL THEN LET l_ida.ida17=0 END IF #TQC-BA0136

   INSERT INTO ida_file VALUES(l_ida.*)
    #若刻號BIN入庫明細已存在，則更新它的實收數量
#  IF SQLCA.sqlcode = -239 THEN #CHI-C30115 mark
   IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
      UPDATE ida_file
         SET ida10 = ida10 + l_ida.ida10,
             ida17 = ida17 + l_ida.ida17
       WHERE ida01 = p_idb.idb01
         AND ida02 = g_argv11
         AND ida03 = g_argv12
         AND ida04 = g_argv13
         AND ida05 = p_idb.idb05
         AND ida06 = p_idb.idb06
         AND ida07 = p_idb.idb07
         AND ida08 = p_idb.idb08
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd ida10',SQLCA.SQLCODE,'1')
        #LET g_s_icdout = "N"  #FUN-930038
         RETURN FALSE  #FUN-930038
      END IF
   ELSE
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err("insert ida",SQLCA.sqlcode,1)
        #LET g_s_icdout = "N"  #FUN-930038
         RETURN FALSE  #FUN-930038
      END IF
   END IF
   RETURN TRUE  #FUN-930038
END FUNCTION

#刻號BIN庫存明細資料選取  總計
FUNCTION s_icdout_b1_tot()
DEFINE l_i     LIKE type_file.num5

   LET g_idc08_t2 = 0
   FOR l_i = 1 TO g_rec_b
      IF g_idc[l_i].cho = "Y" AND NOT cl_null(g_idc[l_i].idc08_a) THEN
         LET g_idc08_t2 = g_idc08_t2 + g_idc[l_i].idc08_a
      END IF
   END FOR

   DISPLAY g_idc08_t2 TO FORMONLY.idc08_t2

END FUNCTION

FUNCTION s_icdout_b2()
DEFINE p_cmd           LIKE type_file.chr1,
       l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5,
       l_idc08         LIKE idc_file.idc08,       #庫存量
       l_idc21         LIKE idc_file.idc21        #備置量
DEFINE l_idc12         LIKE idc_file.idc12        #DIE 數
DEFINE l_icf04         LIKE icf_file.icf04        #pass bin #FUN-BC0036
DEFINE l_imaicd04      LIKE imaicd_file.imaicd04  #TQC-C60012
DEFINE l_imaicd09      LIKE imaicd_file.imaicd09  #TQC-C60014

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT idb05,idb06,idb10,",
                       "       idb11,idb13,idb14,",
                       "       idb16,idb15,idb17,",
                       "       idb18,idb19,idb20,",
                       "       idb21,idb25,",
                       "       idb26,idb27",   #FUN-BC0036
                     "  FROM idb_file ",
                       " WHERE idb01 = ? AND idb02 = ? ",
                       "   AND idb03 = ? AND idb04 = ? ",
                       "   AND idb05 = ? AND idb06 = ? ",
                       "   AND idb07 = ? AND idb08 = ? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE s_icdout_bcl CURSOR FROM g_forupd_sql

    CALL s_icdout_b2_fill()

    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_idb WITHOUT DEFAULTS FROM s_idb.*
       ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)

       BEFORE INPUT
          IF g_rec_b2 != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF          

          #FUN-BC0036 --START--
          IF g_idbch_flag THEN
             CALL cl_set_comp_entry("idb05,idb06",TRUE)
             CALL cl_set_comp_entry("idb11",FALSE)
             CALL cl_set_act_visible("q_bin_g", TRUE)
          END IF
          #FUN-BC0036 --END--
          #TQC-C60012---begin
          LET l_imaicd04 = NULL
          LET l_imaicd09 = NULL  #TQC-C60014
          SELECT imaicd04,imaicd09 INTO l_imaicd04, l_imaicd09 FROM imaicd_file  #TQC-C60014
           WHERE imaicd00 = g_argv1
          IF l_imaicd04 = '2' THEN 
             CALL cl_set_comp_entry("idb16",TRUE)
          ELSE 
             CALL cl_set_comp_entry("idb16",FALSE)
          END IF 
          #TQC-C60012---END
          #TQC-C60014---begin
          IF l_imaicd09 = 'Y' THEN 
             CALL cl_set_comp_entry("idb15",TRUE)
          ELSE 
             CALL cl_set_comp_entry("idb15",FALSE)
          END IF 
          #TQC-C60014---end
       BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_s_icdout = 'Y'
          IF g_rec_b2 >= l_ac THEN
             LET p_cmd='u'
             LET g_idb_t.* = g_idb[l_ac].*  #BACKUP
             OPEN s_icdout_bcl USING g_argv1,g_argv2,g_argv3,g_argv4,
                                      g_idb_t.idb05,
                                      g_idb_t.idb06,
                                      g_argv7,g_argv8
             IF SQLCA.SQLCODE THEN
                CALL cl_err("OPEN s_icdout_bcl.",SQLCA.SQLCODE ,1)
                LET l_lock_sw = "Y"
             END IF
             FETCH s_icdout_bcl INTO g_idb[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err('fetch s_icdout_bcl',SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             CALL cl_show_fld_cont()
          END IF          
          
       #FUN-BC0036 --START--
       AFTER FIELD idb06   #BIN
          IF NOT cl_null(g_idb[l_ac].idb06) THEN
             IF NOT cl_null(g_idb[l_ac].idb05) THEN
                IF cl_null(g_idb_t.idb06) OR
                   (g_idb_t.idb06 <> g_idb[l_ac].idb06) THEN
                   LET g_cnt = 0 
                   SELECT COUNT(*) INTO g_cnt FROM idb_file
                    WHERE idb01 = g_argv1 
                      AND idb02 = g_argv2
                      AND idb03 = g_argv3
                      AND idb04 = g_argv4 
                      AND idb05 = g_idb[l_ac].idb05 
                      AND idb06 = g_idb[l_ac].idb06 
                      AND idb07 = g_argv7 
                      AND idb08 = g_argv8 
                   IF g_cnt > 0 THEN
                      CALL cl_err(g_idb[l_ac].idb06,'-239',0)
                      LET g_idb[l_ac].idb06 = g_idb_t.idb06
                      LET g_idb[l_ac].idb20 = g_idb_t.idb20
                      NEXT FIELD idb06
                   END IF
                   #2. 已測wafer 控卡:檢查所輸入之資料icf是否存在,則警告user輸入錯誤
                   CALL s_icdout_icf_chk() RETURNING l_icf04
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('chk icf:',g_errno,1)
                      LET g_idb[l_ac].idb06 = g_idb_t.idb06
                      LET g_idb[l_ac].idb20 = g_idb_t.idb20
                      NEXT FIELD idb06
                   ELSE
                      LET g_idb[l_ac].idb20 = l_icf04
                      DISPLAY BY NAME g_idb[l_ac].idb20
                   END IF
                END IF
             END IF
          END IF        
       #FUN-BC0036 --END-- 
       
       AFTER FIELD idb11   #出庫數量
          IF NOT cl_null(g_idb[l_ac].idb11) THEN
             IF g_idb[l_ac].idb11 < 0 THEN
                CALL cl_err(g_idb[l_ac].idb11,'atm-114',0)
                LET g_idb[l_ac].idb11 = g_idb_t.idb11
                NEXT FIELD idb11
             END IF
             SELECT idc08,idc21,idc12
                 INTO l_idc08,l_idc21,l_idc12
               FROM idc_file
              WHERE idc01 = g_argv1
                AND idc02 = g_argv2
                AND idc03 = g_argv3
                AND idc04 = g_argv4
                AND idc05 = g_idb[l_ac].idb05
                AND idc06 = g_idb[l_ac].idb06
             IF cl_null(l_idc08) THEN
                LET l_idc08 = 0
             END IF
             IF cl_null(l_idc21) THEN
                LET l_idc21 = 0
             END IF
             IF g_idb[l_ac].idb11 >
                (l_idc08 + g_idb_t.idb11 - l_idc21) THEN
                CALL cl_err(g_idb[l_ac].idb11,'axm-280',0)
                LET g_idb[l_ac].idb11 = g_idb_t.idb11
                NEXT FIELD idb11
             END IF
             IF g_idb[l_ac].idb11 > 0 THEN   #CHI-D30030
             #出貨DIE數，改為idc的DIE數乘上(出貨/庫存數量)比率
                LET g_idb[l_ac].idb16 = l_idc12 *
                                    (g_idb[l_ac].idb11/l_idc08)

                LET g_idb[l_ac].idb16 = cl_digcut(g_idb[l_ac].idb16,0)  #TQC-C60012
             END IF #CHI-D30030
             CALL s_icdout_b2_tot()
             #出庫數量總計不可大于單頭數量
             IF g_idb11_t > g_argv6 THEN
                CALL cl_err(g_idb[l_ac].idb11,'sub-183',0)
                LET g_idb[l_ac].idb11 = g_idb_t.idb11
                IF g_idb[l_ac].idb11 > 0 THEN   #CHI-D30030
                #出貨DIE數，改為idc的DIE數乘上(出貨/庫存數量)比率
                   LET g_idb[l_ac].idb16 = l_idc12 *
                                     (g_idb[l_ac].idb11/l_idc08)
                   LET g_idb[l_ac].idb16 = cl_digcut(g_idb[l_ac].idb16,0)  #TQC-C60012
                END IF  #CHI-D30030
                CALL s_icdout_b2_tot()
                NEXT FIELD idb11
             END IF
             
          END IF
       #TQC-C60012---begin   
       AFTER FIELD idb16
          IF NOT cl_null(g_idb[l_ac].idb16) THEN
             IF g_idb[l_ac].idb16 < 0 THEN
                CALL cl_err(g_idb[l_ac].idb16,'atm-114',0)
                LET g_idb[l_ac].idb16 = g_idb_t.idb16
                NEXT FIELD idb16
             END IF

             SELECT idc08,idc12
                 INTO l_idc08,l_idc12
               FROM idc_file
              WHERE idc01 = g_argv1
                AND idc02 = g_argv2
                AND idc03 = g_argv3
                AND idc04 = g_argv4
                AND idc05 = g_idb[l_ac].idb05
                AND idc06 = g_idb[l_ac].idb06
             IF cl_null(l_idc08) THEN
                LET l_idc08 = 0
             END IF
             LET g_idb[l_ac].idb16 = cl_digcut(g_idb[l_ac].idb16,0)
             IF g_idb[l_ac].idb11 > 0 THEN   #CHI-D30030
                LET g_idb[l_ac].idb11 = l_idc08 * (g_idb[l_ac].idb16/l_idc12)
             END IF  #CHI-D30030
          END IF                        
       #TQC-C60012---end
       BEFORE DELETE
        # IF g_idb_t.idb05 > 0 AND              #No.MOD-890023 mark
        #    NOT cl_null(g_idb_t.idb05) THEN    #No.MOD-890023 mark
          IF g_idb_t.idb05 IS NOT NULL THEN     #No.MOD-890023 add
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             #FUN-BC0036 --START --
             IF g_idbch_flag THEN
                UPDATE idc_file
                   SET idc21 = idc21 - g_idb_t.idb11
                 WHERE idc01 = g_argv1
                   AND idc02 = g_argv2
                   AND idc03 = g_argv3
                   AND idc04 = g_argv4
                   AND idc05 = g_idb[l_ac].idb26
                   AND idc06 = g_idb[l_ac].idb27
             ELSE
             #FUN-BC0036 --END --
                UPDATE idc_file
                #  SET idc21 = idc21 - g_idb[l_ac].idb11   #TQC-B90174
                   SET idc21 = idc21 - g_idb_t.idb11       #TQC-B90174
                 WHERE idc01 = g_argv1
                   AND idc02 = g_argv2
                   AND idc03 = g_argv3
                   AND idc04 = g_argv4
                   AND idc05 = g_idb[l_ac].idb05
                   AND idc06 = g_idb[l_ac].idb06
             END IF   #FUN-BC0036
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err("updtae idc",SQLCA.sqlcode,0)
                LET g_s_icdout = "N"
                CANCEL DELETE
             END IF
             DELETE FROM idb_file
              WHERE idb01 = g_argv1
                AND idb02 = g_argv2
                AND idb03 = g_argv3
                AND idb04 = g_argv4
                AND idb05 = g_idb[l_ac].idb05
                AND idb06 = g_idb[l_ac].idb06
                AND idb07 = g_argv7
                AND idb08 = g_argv8
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err("delete idb",SQLCA.sqlcode,0)
                LET g_s_icdout = "N"
                CANCEL DELETE
             END IF
             #當調撥否為'Y' 時，刪除idb_file同時要刪除ida_file
             IF g_argv10 = "Y" THEN
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM ida_file
                 WHERE ida01 = g_argv1
                   AND ida02 = g_argv11
                   AND ida03 = g_argv12
                   AND ida04 = g_argv13
                   AND ida05 = g_idb[l_ac].idb05
                   AND ida06 = g_idb[l_ac].idb06
                   AND ida07 = g_argv7
                   AND ida08 = g_argv8
                IF l_n > 0 THEN
                   DELETE FROM ida_file
                    WHERE ida01 = g_argv1
                      AND ida02 = g_argv11
                      AND ida03 = g_argv12
                      AND ida04 = g_argv13
                      AND ida05 = g_idb[l_ac].idb05
                      AND ida06 = g_idb[l_ac].idb06
                      AND ida07 = g_argv7
                      AND ida08 = g_argv8
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err("delete ida",SQLCA.sqlcode,0)
                      LET g_s_icdout = "N"
                      CANCEL DELETE
                   END IF
                END IF
             END IF
             LET g_rec_b2 = g_rec_b2-1
             DISPLAY g_rec_b2 TO FORMONLY.cn4
             IF g_s_icdout = "Y" THEN
                COMMIT WORK
             ELSE
                ROLLBACK WORK
             END IF
          END IF
          CALL s_icdout_b2_tot()

       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_idb[l_ac].* = g_idb_t.*
             CLOSE s_icdout_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_idb[l_ac].idb05,-263,1)
             LET g_idb[l_ac].* = g_idb_t.*
          ELSE
             #FUN-BC0036 --START --
             IF g_idbch_flag THEN
                UPDATE idb_file
                   SET idb11 = g_idb[l_ac].idb11,
                       idb16 = g_idb[l_ac].idb16,
                       idb05 = g_idb[l_ac].idb05,
                       idb06 = g_idb[l_ac].idb06,
                       idb20 = g_idb[l_ac].idb20
                 WHERE idb01 = g_argv1
                   AND idb02 = g_argv2
                   AND idb03 = g_argv3
                   AND idb04 = g_argv4
                   AND idb05 = g_idb_t.idb05
                   AND idb06 = g_idb_t.idb06
                   AND idb07 = g_argv7
                   AND idb08 = g_argv8
             ELSE
             #FUN-BC0036 --END --
                UPDATE idb_file
                   SET idb11 = g_idb[l_ac].idb11,
                       idb16 = g_idb[l_ac].idb16
                 WHERE idb01 = g_argv1
                   AND idb02 = g_argv2
                   AND idb03 = g_argv3
                   AND idb04 = g_argv4
                   AND idb05 = g_idb[l_ac].idb05
                   AND idb06 = g_idb[l_ac].idb06
                   AND idb07 = g_argv7
                   AND idb08 = g_argv8
              END IF   #FUN-BC0036

             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err("update idb",SQLCA.sqlcode,0)
                LET g_idb[l_ac].* = g_idb_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                #FUN-BC0036 --START --
                IF g_idbch_flag THEN
                   UPDATE idc_file
                      SET idc21 = (idc21 - g_idb_t.idb11) +
                                      g_idb[l_ac].idb11
                    WHERE idc01 = g_argv1
                      AND idc02 = g_argv2
                      AND idc03 = g_argv3
                      AND idc04 = g_argv4
                      AND idc05 = g_idb[l_ac].idb26
                      AND idc06 = g_idb[l_ac].idb27
                ELSE
                #FUN-BC0036 --END --
                   UPDATE idc_file
                      SET idc21 = (idc21 - g_idb_t.idb11) +
                                      g_idb[l_ac].idb11
                    WHERE idc01 = g_argv1
                      AND idc02 = g_argv2
                      AND idc03 = g_argv3
                      AND idc04 = g_argv4
                      AND idc05 = g_idb[l_ac].idb05
                      AND idc06 = g_idb[l_ac].idb06
                END IF   #FUN-BC0036
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err("update idc",SQLCA.sqlcode,0)
                   LET g_s_icdout = "N"
                END IF
                #當調撥否為'Y' 時,idb_file,ida_file均要更改
                IF g_argv10 = "Y" THEN
                   #FUN-BC0036 --START --
                   IF g_idbch_flag THEN
                      UPDATE ida_file
                         SET ida10 = g_idb[l_ac].idb11,
                             ida05 = g_idb[l_ac].idb05,
                             ida06 = g_idb[l_ac].idb06,
                             ida21 = g_idb[l_ac].idb20,
                             ida16 = g_idb[l_ac].idb15   #TQC-C60014
                       WHERE ida01 = g_argv1
                         AND ida02 = g_argv11
                         AND ida03 = g_argv12
                         AND ida04 = g_argv13
                         AND ida05 = g_idb_t.idb05
                         AND ida06 = g_idb_t.idb06
                         AND ida07 = g_argv7
                         AND ida08 = g_argv8
                   ELSE
                   #FUN-BC0036 --END --
                      UPDATE ida_file
                         SET ida10 = g_idb[l_ac].idb11
                       WHERE ida01 = g_argv1
                         AND ida02 = g_argv11
                         AND ida03 = g_argv12
                         AND ida04 = g_argv13
                         AND ida05 = g_idb[l_ac].idb05
                         AND ida06 = g_idb[l_ac].idb06
                         AND ida07 = g_argv7
                         AND ida08 = g_argv8
                   END IF   #FUN-BC0036
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err("update ida",SQLCA.sqlcode,0)
                      LET g_s_icdout = "N"
                   END IF
                END IF
                IF g_s_icdout = "Y" THEN
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
             END IF
          END IF

       AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_idb[l_ac].* = g_idb_t.*
              END IF
              CLOSE s_icdout_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE s_icdout_bcl
           COMMIT WORK
           CALL s_icdout_b2_tot()

       #FUN-BC0036 --START--
       ON ACTION CONTROLP
            CASE
               WHEN INFIELD(idb06)   #BIN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bin"
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.default1 = g_idb[l_ac].idb06
                  LET g_qryparam.default2 = g_idb[l_ac].idb20
                  CALL cl_create_qry() RETURNING g_idb[l_ac].idb06,g_idb[l_ac].idb20
                  DISPLAY BY NAME g_idb[l_ac].idb06,g_idb[l_ac].idb20
                  NEXT FIELD idb06
             OTHERWISE EXIT CASE
             END CASE
             
       ON ACTION q_bin_g   #查詢群組BIN            
          CALL cl_init_qry_var()
          LET g_qryparam.form = "q_bin_g"
          LET g_qryparam.construct = "N"
          LET g_qryparam.arg1 = g_argv1               
          LET g_qryparam.default1 = g_idb[l_ac].idb06
          LET g_qryparam.default2 = g_idb[l_ac].idb20
          CALL cl_create_qry() RETURNING g_idb[l_ac].idb06,g_idb[l_ac].idb20
            DISPLAY BY NAME g_idb[l_ac].idb06,g_idb[l_ac].idb20
          NEXT FIELD idb06  
       #FUN-BC0036 --END--

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

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

    CALL s_icdout_b2_tot()

    CLOSE s_icdout_bcl

END FUNCTION

FUNCTION s_icdout_b2_tot()
DEFINE  l_i     LIKE type_file.num5

   LET g_idb10_t = 0
   LET g_idb11_t = 0
   FOR l_i = 1 TO g_rec_b2
      LET g_idb10_t = g_idb10_t + g_idb[l_i].idb10
      LET g_idb11_t = g_idb11_t + g_idb[l_i].idb11
   END FOR
   DISPLAY g_idb10_t,g_idb11_t
        TO FORMONLY.idb10_t,FORMONLY.idb11_t

   LET g_idb16_t = 0
   FOR l_i = 1 TO g_rec_b2
      LET g_idb16_t = g_idb16_t + g_idb[l_i].idb16
   END FOR
   DISPLAY g_idb16_t TO FORMONLY.idb16_t

END FUNCTION

FUNCTION s_icdout_b_fill()
   DEFINE l_pcs  LIKE idc_file.idc08

   LET g_sql = "SELECT 'N',idc05,idc06,idc08,idc21,0,",
               "       idc12,idc11,idc13,idc14,idc15,",
               "       idc16,idc09,idc10,idc19,idc20 ",
               "  FROM idc_file",
               " WHERE idc01 ='",g_argv1,"'",
               "   AND idc02 ='",g_argv2,"'",
               "   AND idc03 ='",g_argv3,"'",
               "   AND idc04 ='",g_argv4,"'",
               "   AND (idc08 - idc21) > 0",
               #料號庫存狀態為HOLD,不允許作出庫
               "   AND idc17 != 'Y' ",
               " ORDER BY idc05,idc06,idc08"

   PREPARE s_icdout_pb FROM g_sql
   DECLARE idc_curs CURSOR FOR s_icdout_pb

   CALL g_idc.clear()
   LET l_ac = 1
   LET g_idc08_t1 = 0
   LET g_idc12_t  = 0
   FOREACH idc_curs INTO g_idc[l_ac].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach idc',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
        #若為[成套發料],且發料數量為整數，則僅提供同一刻號加總合為整數的資料
        IF g_collect = 'Y' AND s_icdout_integer(g_argv6) THEN
         LET g_cnt = 0
         SELECT SUM(idc08 - idc21) INTO l_pcs FROM idc_file
          WHERE idc01 = g_argv1
            AND idc02 = g_argv2
            AND idc03 = g_argv3
            AND idc04 = g_argv4
            AND idc05 = g_idc[l_ac].idc05
            AND (idc08 - idc21) > 0
            #料件庫存狀態為HOLD，不允許作出庫
            AND idc17 != 'Y'
         IF NOT s_icdout_integer(l_pcs) THEN CONTINUE FOREACH END IF
      END IF

      LET g_idc08_t1 = g_idc08_t1 + g_idc[l_ac].idc08
      LET g_idc12_t = g_idc12_t + g_idc[l_ac].idc12
      LET l_ac = l_ac + 1
   END FOREACH
   CALL g_idc.deleteElement(l_ac)
   LET g_rec_b = l_ac-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY g_idc08_t1 TO FORMONLY.idc08_t1
   DISPLAY g_idc12_t TO FORMONLY.idc12_t
END FUNCTION

FUNCTION s_icdout_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_idc TO s_idc.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY

   DISPLAY ARRAY g_idb TO s_idb.* ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION one_detail
         LET g_action_choice="one_detail"
         EXIT DISPLAY

      ON ACTION qry_one_detail
         LET g_action_choice="qry_one_detail"
         EXIT DISPLAY

      ON ACTION two_detail
         LET g_action_choice="two_detail"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="two_detail"
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

      ON ACTION ExportToExcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_idc),base.TypeInfo.create(g_idb),'')
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION s_icdout_b2_fill()              #BODY FILL UP

   LET g_sql = "SELECT idb05,idb06,idb10,idb11,",
               "       idb13,idb14,idb16,idb15,",
               "       idb17,idb18,idb19,idb20,",
               "       idb21,idb25,idb26,idb27",   #FUN-BC0036 add idb26,27
               " FROM idb_file",
               " WHERE idb07 ='",g_argv7,"'",
               "   AND idb08 ='",g_argv8,"'",
               "   AND idb01 ='",g_argv1,"'",   #FUN-B40081
               "   AND idb02 ='",g_argv2,"'",   #FUN-B40081
               "   AND idb03 ='",g_argv3,"'",   #FUN-B40081
               "   AND idb04 ='",g_argv4,"'",   #FUN-B40081
               " ORDER BY idb05,idb06,idb10"
   PREPARE s_icdout_pb2 FROM g_sql
   DECLARE idb_curs CURSOR FOR s_icdout_pb2

   CALL g_idb.clear()
   LET g_cnt = 1
   LET g_idb10_t = 0
   LET g_idb11_t = 0
   LET g_idb16_t = 0
   FOREACH idb_curs INTO g_idb[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach idb',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET g_idb10_t = g_idb10_t + g_idb[g_cnt].idb10
      LET g_idb11_t = g_idb11_t + g_idb[g_cnt].idb11
      LET g_idb16_t = g_idb16_t + g_idb[g_cnt].idb16
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_idb.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn4
   DISPLAY g_idb10_t,g_idb11_t,
           g_idb16_t
        TO FORMONLY.idb10_t,FORMONLY.idb11_t,
           FORMONLY.idb16_t

END FUNCTION

FUNCTION s_icdout_set_entry_b(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

   CALL cl_set_comp_entry("idc08_a",TRUE)

END FUNCTION

FUNCTION s_icdout_set_no_entry_b(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

   #IF g_idc[l_ac].cho = "N" THEN                      #TQC-C60014 mark
    IF g_idc[l_ac].cho = "N" OR g_prog='aict324' THEN  #TQC-C60014
       CALL cl_set_comp_entry("idc08_a",FALSE)
    END IF

END FUNCTION


FUNCTION s_icdout_bp2(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_idc TO s_idc.* ATTRIBUTE(COUNT=g_rec_b)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)

END FUNCTION

FUNCTION s_icdout_DIE()
   DEFINE l_idb16      LIKE idb_file.idb16,
          l_imaicd04   LIKE imaicd_file.imaicd04

   SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file WHERE imaicd00 = g_argv1

   CASE
       WHEN l_imaicd04 = '1' OR l_imaicd04 = '0'
            SELECT SUM(idb16) INTO l_idb16 FROM idb_file
             WHERE idb01 = g_argv1
               AND idb02 = g_argv2
               AND idb03 = g_argv3
               AND idb04 = g_argv4
               AND idb07 = g_argv7
               AND idb08 = g_argv8
               AND idb16 IS NOT NULL
       WHEN l_imaicd04 = '2'
            SELECT SUM(idb16) INTO l_idb16 FROM idb_file
             WHERE idb01 = g_argv1
               AND idb02 = g_argv2
               AND idb03 = g_argv3
               AND idb04 = g_argv4
               AND idb07 = g_argv7
               AND idb08 = g_argv8
               AND idb16 IS NOT NULL
               AND idb20 = 'Y'
       OTHERWISE
            LET l_idb16 = 0
   END CASE
   IF cl_null(l_idb16) THEN LET l_idb16 = 0 END IF
   RETURN l_idb16
END FUNCTION

#自動產生s_icdout(若所發的料與庫存數量相同，將全部自動insert)
FUNCTION s_icdout_g_b2()
   DEFINE l_qty LIKE idc_file.idc08,
          l_i   LIKE type_file.num5

   IF g_collect = 'N' THEN RETURN END IF      #不為成套發料

   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM idb_file
    WHERE idb07 = g_argv7 AND idb08 = g_argv8
   IF g_cnt <> 0 THEN RETURN END IF

   LET l_qty = 0
   FOR l_i = 1 TO g_rec_b
       LET l_qty = l_qty + (g_idc[l_i].idc08 - g_idc[l_i].idc21)
   END FOR
   IF l_qty = g_argv6 THEN
      FOR l_i = 1 TO g_rec_b
          LET g_idc[l_i].cho = 'Y'
          LET g_idc[l_i].idc08_a = g_idc[l_i].idc08 -
                                          g_idc[l_i].idc21
      END FOR
      CALL s_icdout_ins()
   END IF
   CALL s_icdout_b_fill()
END FUNCTION

#勾選時，同刻號全勾
FUNCTION s_icdout_chked()
   DEFINE l_i    LIKE type_file.num5,
          l_qty1 LIKE idc_file.idc08,
          l_qty2 LIKE idc_file.idc08

   #檢查全勾后，數量是否會超過，若會超過不全勾
   LET l_qty1 = 0
   LET l_qty2 = 0
   FOR l_i = 1 TO g_rec_b
       IF g_idc[l_i].idc05 = g_idc[l_ac].idc05 THEN
          LET l_qty1 = l_qty1 + g_idc[l_i].idc08 -
                                g_idc[l_i].idc21
       ELSE
          IF g_idc[l_i].cho = 'Y' THEN
             LET l_qty2 = l_qty2 + g_idc[l_i].idc08_a
          END IF
       END IF
   END FOR
   IF (l_qty1 + l_qty2) > g_argv6 THEN RETURN END IF

   FOR l_i = 1 TO g_rec_b
       IF g_idc[l_ac].cho = 'Y' AND l_i <> l_ac AND
          g_idc[l_i].idc05 = g_idc[l_ac].idc05 THEN
          LET g_idc[l_i].cho = 'Y'
          LET g_idc[l_i].idc08_a = g_idc[l_i].idc08 -
                                          g_idc[l_i].idc21
          DISPLAY BY NAME g_idc[l_i].cho
          DISPLAY BY NAME g_idc[l_i].idc08_a
       END IF
   END FOR
END FUNCTION

#判斷傳入值是否為>0 整數
FUNCTION s_icdout_integer(p_qty)
    DEFINE p_qty LIKE idc_file.idc08
    #DEFINE l_i LIKE type_file.num5     #MOD-C30515 mark
    DEFINE l_i LIKE type_file.num20     #MOD-C30515

    IF p_qty = 0 THEN RETURN 0 END IF
    LET l_i = p_qty / 1
    IF p_qty - (1 * l_i) > 0 THEN
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION

#FUN-AA0007--begin--add------------
FUNCTION s_icdout_holdlot(p_idc01,p_idc02,p_idc03,p_idc04)
DEFINE p_idc01    LIKE idc_file.idc01
DEFINE p_idc02    LIKE idc_file.idc02
DEFINE p_idc03    LIKE idc_file.idc03
DEFINE p_idc04    LIKE idc_file.idc04
DEFINE l_cnt      LIKE type_file.num5
#DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #CHI-B70044 add #FUN-BA0051 mark

   LET l_cnt=0
   IF cl_null(p_idc01) OR cl_null(p_idc04) THEN
      RETURN 1
   END IF
   IF p_idc02 IS NULL THEN LET p_idc02=' ' END IF
   IF p_idc03 IS NULL THEN LET p_idc03=' ' END IF
   #FUN-BA0051 --START mark--
#CHI-B70044 -- begin --
   #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file WHERE imaicd00=p_idc01
   #IF l_imaicd08='Y' THEN RETURN 1 END IF
#CHI-B70044 -- end --
   #FUN-BA0051 --END mark--
   IF s_icdbin(p_idc01) THEN RETURN 1 END IF   #FUN-BA0051
   SELECT count(*) INTO l_cnt FROM idc_file
    WHERE idc01=p_idc01
      AND idc02=p_idc02
      AND idc03=p_idc03
      AND idc04=p_idc04
      AND idc17='Y'
   IF l_cnt > 0 THEN
      CALL cl_err('','asf-144',1)
      RETURN 0
   END IF
   RETURN 1
END FUNCTION
#FUN-AA0007--end--add-----------
#FUN-B40081 --START--
FUNCTION s_icdout_ogb17_on()
   LET g_ogb17_flag = TRUE
END FUNCTION

FUNCTION s_icdout_ogb17_off()
   LET g_ogb17_flag = FALSE
END FUNCTION

#FUN-B40081 --END--

#FUN-BC0036 --START--
FUNCTION s_icdout_idb_chk()
DEFINE l_idb RECORD LIKE idb_file.*
DEFINE l_i          LIKE type_file.num5
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sum_idb11  LIKE idb_file.idb11
DEFINE l_sql STRING
DEFINE l_imaicd08   LIKE imaicd_file.imaicd08  #TQC-C60014
DEFINE l_imaicd09   LIKE imaicd_file.imaicd09  #TQC-C60014
   #TQC-C60014---begin
   SELECT imaicd08,imaicd09 INTO l_imaicd08, l_imaicd09 FROM imaicd_file  
    WHERE imaicd00 = g_argv1
   IF l_imaicd08 = 'Y' AND l_imaicd09 = 'N' THEN 
   #TQC-C60014---end
      #刻號/BIN未變更
      SELECT COUNT(*) INTO l_cnt FROM idb_file
       WHERE idb01 = g_argv1
         AND idb02 = g_argv2
         AND idb03 = g_argv3
         AND idb04 = g_argv4
         AND idb07 = g_argv7
         AND idb08 = g_argv8
         AND idb05 = idb26
         AND idb06 = idb27
      IF l_cnt > 0 THEN
         CALL cl_err('','aic-321',1)
         RETURN FALSE
      END IF
   #TQC-C60014---begin   
   END IF 
   IF l_imaicd08 = 'N' AND l_imaicd09 = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM idb_file
       WHERE idb01 = g_argv1
         AND idb02 = g_argv2
         AND idb03 = g_argv3
         AND idb04 = g_argv4
         AND idb07 = g_argv7
         AND idb08 = g_argv8
         AND idb15 IS NULL 
      IF l_cnt > 0 THEN
         CALL cl_err('','aic-330',1)
         RETURN FALSE
      END IF 
   END IF 
   IF l_imaicd08 = 'Y' AND l_imaicd09 = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM idb_file
       WHERE idb01 = g_argv1
         AND idb02 = g_argv2
         AND idb03 = g_argv3
         AND idb04 = g_argv4
         AND idb07 = g_argv7
         AND idb08 = g_argv8
         AND idb05 = idb26
         AND idb06 = idb27
         AND idb15 IS NULL
      IF l_cnt > 0 THEN
         CALL cl_err('','aic-321',1)
         RETURN FALSE
      END IF
   END IF 
#TQC-C60014---end
   #wafer出貨總數大於1
   LET l_sql = "SELECT SUM(idb11) FROM idb_file INNER JOIN imaicd_file ",
                "  ON idb01 = imaicd00 WHERE imaicd04 in (1,2) ",
                "  AND idb01 = '", g_argv1 ,"' AND idb02 = '", g_argv2 ,"' ",
                "  AND idb03 = '", g_argv3 ,"' AND idb04 = '", g_argv4 ,"' ",
                "  AND idb07 = '", g_argv7 ,"'   AND idb08 = '", g_argv8 ,"' ",                
                "  GROUP BY idb05"
                
   PREPARE s_icdout_idb_p1 FROM l_sql
   DECLARE s_icdout_idb_c1 CURSOR FOR s_icdout_idb_p1
   
   FOREACH s_icdout_idb_c1 INTO l_sum_idb11   
         IF l_sum_idb11 > 1 THEN
            CALL cl_err('','aic-322',1)
            RETURN FALSE
         END IF
   END FOREACH

   RETURN TRUE
END FUNCTION

FUNCTION s_icdout_icf_chk() 
    DEFINE l_imaicd06 LIKE imaicd_file.imaicd06,      #No.FUN-830073
          l_imaicd04 LIKE imaicd_file.imaicd04,
          l_icf04 LIKE icf_file.icf04
   DEFINE l_flag      LIKE type_file.chr1
 
   LET g_errno = ''
   LET l_imaicd06 = ''
   LET l_imaicd04 = ''
 
   #取得該料件之內編子體(Wafer 料號)料件狀態
   SELECT imaicd06,imaicd04 INTO l_imaicd06,l_imaicd04
      FROM imaicd_file
     WHERE imaicd00 = g_argv1
 
   IF l_imaicd04 NOT MATCHES '[24]' THEN 
      RETURN l_icf04 
   END IF   
 
   LET l_flag = '1'
 
   #case1. 先用該料件號以及icf值串icf_file
   LET l_icf04 = ''
   SELECT icf04 INTO l_icf04
     FROM icf_file
    WHERE icf01 = g_argv1
      AND icf02 = g_idb[l_ac].idb06
   IF SQLCA.SQLCODE = 100 THEN
      LET l_flag = '2'
   ELSE
      IF SQLCA.SQLCODE != 0 THEN
         LET g_errno = SQLCA.SQLCODE
         RETURN l_icf04
      END IF
   END IF
 
   #case2. case1串不到時，改用該料件號的wafer料號(imaicd06) 串icf_file
   IF l_flag = '2' THEN  
      IF NOT cl_null(l_imaicd06) THEN
         SELECT icf04 INTO l_icf04
           FROM icf_file
           WHERE icf01 = l_imaicd06
             AND icf02 = g_idb[l_ac].idb06
         IF SQLCA.SQLCODE = 100 THEN
            LET l_flag = '3'
         ELSE
            IF SQLCA.SQLCODE != 0 THEN
               LET g_errno = SQLCA.SQLCODE
               RETURN l_icf04
            END IF
         END IF
      ELSE
         LET l_flag = '3'
      END IF
   END IF
 
  #case3. case2也串不到時，再改用傳入參數母體料號來串icf_file 
  IF l_flag = '3' THEN
      SELECT icf04 INTO l_icf04
        FROM icf_file
       WHERE icf01 = g_idb[l_ac].idb13
         AND icf02 = g_idb[l_ac].idb06
      IF SQLCA.SQLCODE THEN
         LET g_errno = SQLCA.SQLCODE
         RETURN l_icf04
      END IF
   END IF   
   RETURN l_icf04
END FUNCTION
#FUN-BC0036 --END--



#No.FUN-7B0016
