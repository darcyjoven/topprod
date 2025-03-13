# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: anmp500.4gl
# Descriptions...: 支票/轉帳單整批產生作業
# Date & Author..: 94/05/20 By Roger
# Modify.........: No.5058 03/10/27 By Sophia 增加應付電匯款部份
# Modify.........: No.MOD-470480 Kammy 起始單號應在 WHILE迴圈一開始清除
# Modify.........: No.MOD-4A0076 04/10/14 By Yuna 在輸入工廠編號的地方,應該不要新增與刪除的功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: NO.FUN-550057 05/05/30 By jackie 單據編號加大
# Modify.........: No.MOD-550093 05/05/31 By ching fix工廠輸入問題
# Modify.........: No.FUN-560060 05/06/17 By day  單據編號修改
# Modify.........: No.FUN-560139 05/06/20 By Yuna 產生應付票據後,顯示及產生的應付票據單號只有10碼,無法看到完整單號16碼
# Modify.........: No.MOD-5B0212 05/11/21 By Smapmin 無符合資料時,秀出的錯誤訊息只要有確認鈕就好
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.MOD-640309 06/04/10 By Smapmin 部門判斷條件錯誤
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680034 06/08/28 By douzh 增加nmd231--兩套帳修改
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/01/16 By Jackho 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.FUN-960141 09/06/23 By dongbg GP5.2修改:nmd40賦值
# Modify.........: No.FUN-980005 09/08/19 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.MOD-970167 09/09/03 By sabrina (1).若其開票單別是要拋轉傳票者，則開票傳票不帶原付款單上的傳票單號
#                                                    (2).來源的營運中心，若與執行的營運中心，本國幣別不同時，
#                                                        其nmd26本幣金額要依原幣金額 * 參數指定轉換匯率
# Modify.........: No.FUN-990031 09/10/13 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.FUN-9A0093 09/11/04 By lutingting營運中心欄位拿掉 
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: NO:MOD-AC0326 10/12/25 By Dido 設定 nmd54 預設值取此銀行簿號最大筆取票日期 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-C50205 12/05/28 By yinhy 付款單號、付款廠商、付款銀行等欄位請增加開窗挑選功能
# Modify.........: No.FUN-C90122 12/10/16 By wangrr 已沖金額nmd55=nmd04
# Modify.........: No.MOD-C90262 12/10/01 By Polly 外幣支票開立時，應該以付款單支票匯率(aph14)來產生開票匯率(nmd19)
# Modify.........: No.MOD-D30124 13/03/13 By Polly 整批產生時，需排除退款資料(aapt332)

IMPORT os   #No.FUN-9C0009
DATABASE ds
 
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
    DEFINE l_ac,l_sl             LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE g_wc,g_sql  	         string                 #No.FUN-580092 HCN
    #DEFINE plant  	         ARRAY[10] OF LIKE nmd_file.nmd34  #No.FUN-680107 ARRAY[10] OF VARCHAR(10)  #FUN-9A0093 mark
    DEFINE g_cnt2                LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE g_tot,g_tot2          LIKE nmd_file.nmd04
    DEFINE g_dept                LIKE type_file.chr20   #No.FUN-680107 VARCHAR(10)
    DEFINE g_start_no,g_end_no   LIKE nmd_file.nmd01
    DEFINE g_start_no2,g_end_no2 LIKE nmd_file.nmd01
    DEFINE g_nmd07               LIKE nmd_file.nmd07    #No.FUN-680107 DATE
    DEFINE tr_type1              LIKE nmz_file.nmz51    #No.FUN-680107 VARCHAR(5) #No.FUN-550057
    DEFINE tr_type2              LIKE nmz_file.nmz51    #No.FUN-680107 VARCHAR(5)
    DEFINE g_buf                 LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(20)
    DEFINE g_cnt                 LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE z1,z2,z3,z4,z5        LIKE gem_file.gem01    #No.FUN-680107 VARCHAR(6)
    DEFINE z0                    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)    #No.5058
    DEFINE p_row,p_col           LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE g_rec_b               LIKE type_file.num10   #No.FUN-680107 INTEGER
 
    DEFINE g_chr                 LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE g_flag                LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE g_i                   LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
    DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
    DEFINE i                     LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE j                     LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE l_flag                LIKE type_file.chr1,   #No.FUN-570127 #No.FUN-680107 VARCHAR(1)
           g_change_lang         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01) #是否有做語言切換 No.FUN-570127
           ls_date               STRING
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8                    #No.FUN-6A0082
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570127 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   #FUN-9A0093--mod--str--
   #LET plant[1] = ARG_VAL(2)
   #LET plant[2] = ARG_VAL(3)
   #LET plant[3] = ARG_VAL(4)
   #LET plant[4] = ARG_VAL(5)
   #LET plant[5] = ARG_VAL(6)
   #LET plant[6] = ARG_VAL(7)
   #LET plant[7] = ARG_VAL(8)
   #LET plant[8] = ARG_VAL(9)
   #LET plant[9] = ARG_VAL(10)
   #LET plant[10]= ARG_VAL(11)
   #LET z0       = ARG_VAL(12)
   #LET tr_type1 = ARG_VAL(13)
   #LET ls_date  = ARG_VAL(14)
   #LET g_nmd07  = cl_batch_bg_date_convert(ls_date)
   #LET z1       = ARG_VAL(15)
   #LET z2       = ARG_VAL(16)
   #LET z3       = ARG_VAL(17)
   #LET z4       = ARG_VAL(18)
   #LET z5       = ARG_VAL(19)
   #LET g_bgjob  = ARG_VAL(20)                 #背景作業
   LET z0       = ARG_VAL(2)
   LET tr_type1 = ARG_VAL(3)
   LET ls_date  = ARG_VAL(4)
   LET g_nmd07  = cl_batch_bg_date_convert(ls_date)
   LET z1       = ARG_VAL(5)
   LET z2       = ARG_VAL(6)
   LET z3       = ARG_VAL(7)
   LET z4       = ARG_VAL(8)
   LET z5       = ARG_VAL(9)
   LET g_bgjob  = ARG_VAL(10)                  #背景作業
   #FUN-9A0093--mod-end
   
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570127 ---end---
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570127 mark--
#   OPEN WINDOW p500_w AT p_row,p_col WITH FORM "anm/42f/anmp500"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
#NO.FUN-570127 mark--
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
#NO.FUN-570127 mark--
#   LET g_cnt = 0  LET g_tot = 0 LET g_start_no = ' ' LET g_end_no =' '
#   LET g_cnt2= 0  LET g_tot2= 0 LET g_start_no2= ' ' LET g_end_no2=' '
#   CALL p500()
#   CLOSE WINDOW p500_w
#NO.FUN-570127 mark--
 
#NO.FUN-570127 start--
   LET g_success = 'Y'
   WHILE TRUE
      LET g_cnt = 0  LET g_tot = 0 LET g_start_no = ' ' LET g_end_no =' '
      LET g_cnt2= 0  LET g_tot2= 0 LET g_start_no2= ' ' LET g_end_no2=' '
      IF g_bgjob = "N" THEN
         CALL p500()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL s_showmsg_init()   #No.FUN-710024
            CALL p500_p()
            CALL s_showmsg()          #No.FUN-710024
            IF g_success = 'Y' THEN
               COMMIT WORK
               IF g_cnt > 0 OR g_cnt2 > 0 THEN
                  OPEN WINDOW p500_w2 AT 5,12 WITH FORM "anm/42f/anmp500_1"
                       ATTRIBUTE (STYLE = g_win_style)
                  CALL cl_ui_locale("anmp500_1")
                  DISPLAY BY NAME g_cnt ,g_tot ,g_start_no ,g_end_no
                  DISPLAY BY NAME g_cnt2,g_tot2,g_start_no2,g_end_no2  #No.5058
               END IF
               CALL cl_end2(1) RETURNING l_flag
               IF g_cnt > 0 OR g_cnt2 > 0 THEN
                  CLOSE WINDOW p500_w2
               END IF
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
                 CONTINUE WHILE
            ELSE
                 CLOSE WINDOW p500_w
                 EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL s_showmsg_init()   #No.FUN-710024
         CALL p500_p()
         CALL s_showmsg()          #No.FUN-710024
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570127 ---end---
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
END MAIN
 
FUNCTION p500()
   DEFINE   l_name    LIKE type_file.chr20   #No.FUN-680107 VARCHAR(20)
   DEFINE   l_cmd     LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30)
   DEFINE   l_seq     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE   l_gem02   LIKE gem_file.gem02
   DEFINE   l_nml02   LIKE nml_file.nml02
   DEFINE   l_nmo02   LIKE nmo_file.nmo02
   DEFINE   l_apf     RECORD
                         plant    LIKE nmd_file.nmd34,    #No.FUN-680107 VARCHAR(10)
                         dbs      LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
                         apf00    LIKE apf_file.apf00,
                         apf01    LIKE apf_file.apf01,
                         apf03    LIKE apf_file.apf03,
                         apf05    LIKE apf_file.apf05,
                         apf06    LIKE apf_file.apf06,
                         apf07    LIKE apf_file.apf07,
                         apf11    LIKE apf_file.apf11,
                         apf12    LIKE apf_file.apf12,
                         apf13    LIKE apf_file.apf13,
                         apf43    LIKE apf_file.apf43,
                         apf44    LIKE apf_file.apf44,
                         aph02    LIKE aph_file.aph02,
                         aph03    LIKE aph_file.aph03,
                         aph08    LIKE aph_file.aph08,
                         apf02    LIKE apf_file.apf02,    #付款日期
                         aph07    LIKE aph_file.aph07,
                         aph04    LIKE aph_file.aph04,
                         aph05    LIKE aph_file.aph05,
                         aph05f   LIKE aph_file.aph05f,
                         aph14    LIKE aph_file.aph14,
                         aph13    LIKE aph_file.aph13,
                         aph15    LIKE aph_file.aph15
                      END RECORD,
            l_allow_insert        LIKE type_file.num5,    #可新增否  #No.FUN-680107 SMALLINT
            l_allow_delete        LIKE type_file.num5     #可刪除否  #No.FUN-680107 SMALLINT
DEFINE      li_result             LIKE type_file.num5     #No.FUN-550057  #No.FUN-680107 SMALLINT
DEFINE      lc_cmd                LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
#->No.FUN-570127 ---start---
   OPEN WINDOW p500_w AT p_row,p_col WITH FORM "anm/42f/anmp500"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
#->No.FUN-570127 ---end---
 
     WHILE TRUE
        #No.MOD-470480
       LET g_cnt = 0  LET g_tot = 0 LET g_start_no = ' ' LET g_end_no =' '
       LET g_cnt2= 0  LET g_tot2= 0 LET g_start_no2= ' ' LET g_end_no2=' '
        #No.MOD-470480(end)
 
       CLEAR FORM
       CONSTRUCT BY NAME g_wc ON apf44, apf02, apf01, apf05, apf04, apf00, apf03, aph08, apf06
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        
      #No.MOD-C50205  --Begin
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(apf01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apf4"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apf01
               NEXT FIELD apf01
            WHEN INFIELD(apf03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apf03
               NEXT FIELD apf03
            WHEN INFIELD(apf04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apf04
               NEXT FIELD apf04
            WHEN INFIELD(apf05) # Dept CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apf05
            WHEN INFIELD(apf44) #傳票編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aba02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apf44
               NEXT FIELD apf44
            WHEN INFIELD(apf06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apf06
               NEXT FIELD apf06
            WHEN INFIELD(aph08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_nma"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aph08
               NEXT FIELD aph08
            OTHERWISE
               EXIT CASE
          END CASE
      #No.MOD-C50205  --End
         ON ACTION locale                    #genero
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang = TRUE                  #NO.FUN-570127
           EXIT CONSTRUCT
        
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
        
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup') #FUN-980030
        
#NO.FUN-570127 start--
#       IF g_action_choice = "locale" THEN  #genero
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
        
#       IF INT_FLAG THEN
#          EXIT WHILE
#       END IF
 
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p500_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
#->No.FUN-570127 ---end---
 
#FUN-9A0093--mark--str--
#       LET plant[1] = g_plant
# 
#       LET g_rec_b = 1
# 
#       DISPLAY ARRAY plant TO s_plant.* ATTRIBUTE(COUNT=g_rec_b)
#         BEFORE DISPLAY
#           EXIT DISPLAY
#       END DISPLAY
# 
#        #No.MOD-4A0076
#       #LET l_allow_insert = cl_detail_input_auth("insert")
#       #LET l_allow_delete = cl_detail_input_auth("delete")
# 
#        #No.MOD-550093
#       LET l_allow_insert = TRUE
#       LET l_allow_delete = TRUE
#       #--
# 
#       INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.* 
#             ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
# 
#          AFTER FIELD plant
#             LET l_ac = ARR_CURR()
#             IF NOT cl_null(plant[l_ac]) AND plant[l_ac] != g_plant THEN
#                IF NOT s_chknplt(plant[l_ac],'AAP','AAP') THEN 
#                   CALL cl_err(plant[l_ac],'anm-025',0)
#                   NEXT FIELD plant
#                END IF
#             END IF
#             #FUN-990031--mod--str--    營運中心要控制在當前法人下 
#             IF NOT cl_null(plant[l_ac]) THEN
#                SELECT * FROM azw_file WHERE azw01 = plant[l_ac] AND azw02 = g_legal                                                        
#               IF STATUS THEN                                                                                                          
#                  CALL cl_err3("sel","azw_file",plant[l_ac],"","agl-171","","",1)                                                          
#                  NEXT FIELD plant                                                                                                   
#               END IF 
#             END IF                                                                                                                 
#             #FUN-990031--mod--end  
# 
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#       
#       END INPUT
##NO.FUN-570127 start--
##       IF INT_FLAG THEN 
##          EXIT WHILE 
##       END IF
# 
#       IF INT_FLAG THEN
#          LET INT_FLAG = 0
#          CLOSE WINDOW p500_w
#          EXIT PROGRAM
#       END IF
##->No.FUN-570127 ---end---
#FUN-9A0093--mark--end
 
       LET tr_type1 = g_nmz.nmz51
       LET z0       = '3'          #No.5058
       LET g_nmd07  = null
       LET z4       = g_nmz.nmz55
       LET g_bgjob = "N"    #NO.FUN-570127
       DISPLAY BY NAME tr_type1,g_nmd07,z1,z2,z3,z4,z5
 
       #INPUT BY NAME z0,tr_type1,g_nmd07,z1,z2,z3,z4,z5 WITHOUT DEFAULTS  
       INPUT BY NAME z0,tr_type1,g_nmd07,z1,z2,z3,z4,z5,g_bgjob WITHOUT DEFAULTS    #NO.FUN-570127
      
          AFTER FIELD tr_type1
             IF NOT cl_null(tr_type1) THEN 
#No.FUN-550057 --start--
              CALL s_check_no("anm",tr_type1,"","1","","","")
                 RETURNING li_result,tr_type1
             LET tr_type1= s_get_doc_no(tr_type1)                    
              DISPLAY BY NAME tr_type1
               IF (NOT li_result) THEN
                 NEXT FIELD tr_type1
               END IF
#                CALL s_nmyslip(tr_type1,'1',g_sys)	#檢查單別
#                IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#                   CALL cl_err(tr_type1,g_errno,0)
#                   NEXT FIELD tr_type1
#                END IF
#No.FUN-550057 ---END--
             END IF
 
          #No.5058
          AFTER FIELD z0
             IF cl_null(z0) OR z0 NOT MATCHES '[123]' THEN
              NEXT FIELD z0
             END IF
          #No.5058(end)
 
          AFTER FIELD z1 
             IF NOT cl_null(z1) THEN 
                SELECT nmo02 INTO l_nmo02 FROM nmo_file 
                 WHERE nmo01 = z1 AND nmoacti = 'Y'
                IF SQLCA.sqlcode THEN 
                   LET l_nmo02 = ' '
#                  CALL cl_err(z1,'anm-086',0)   #No.FUN-660148
                   CALL cl_err3("sel","nmo_file",z1,"","anm-086","","",0) #No.FUN-660148
                   NEXT FIELD z1 
                END IF
                DISPLAY l_nmo02 TO FORMONLY.nmo02 
             END IF
      
          AFTER FIELD z2 
             IF NOT cl_null(z2) THEN 
                SELECT nmo02 INTO l_nmo02 FROM nmo_file 
                 WHERE nmo01 = z2 AND nmoacti = 'Y'
                IF SQLCA.sqlcode THEN 
                   LET l_nmo02 = ' '
#                  CALL cl_err(z1,'anm-086',0)   #No.FUN-660148
                   CALL cl_err3("sel","nmo_file",z2,"","anm-086","","",0) #No.FUN-660148
                   NEXT FIELD z2 
                END IF
                DISPLAY l_nmo02 TO FORMONLY.nmo02_2 
             END IF
      
          AFTER FIELD z3 
             IF not cl_null(z3) THEN    #MOD-640309
                SELECT gem02 INTO l_gem02 FROM gem_file 
                 WHERE gem01 = z3 AND gem05='Y' AND gemacti = 'Y'
                IF SQLCA.sqlcode THEN 
                   LET l_gem02 = ' '
#                  CALL cl_err(z1,'anm-071',0)    #No.FUN-660148
                   CALL cl_err3("sel","gem_file",z3,"","anm-071","","",0) #No.FUN-660148
                   NEXT FIELD z3 
                END IF
                DISPLAY l_gem02 TO FORMONLY.gem02 
             END IF
      
          AFTER FIELD z4 
             IF not cl_null(z4) THEN 
                SELECT nml02 INTO l_nml02 FROM nml_file 
                 WHERE nml01 = z4 AND nmlacti = 'Y'
                IF SQLCA.sqlcode THEN 
                   LET l_gem02 = ' '
#                  CALL cl_err(z1,'anm-140',0)    #No.FUN-660148
                   CALL cl_err3("sel","nml_file",z4,"","anm-140","","",0) #No.FUN-660148
                   NEXT FIELD z4 
                END IF
                DISPLAY l_nml02 TO FORMONLY.nml02 
             END IF
      
           AFTER FIELD z5
              IF NOT cl_null(z5) THEN 
                 CALL t100_nmd17('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD z5
                 END IF
              END IF
              
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(tr_type1) #查詢單据
                    #CALL q_nmy(FALSE,FALSE,tr_type1,'1',g_sys) #TQC-670008
                    CALL q_nmy(FALSE,FALSE,tr_type1,'1','ANM')  #TQC-670008
                    RETURNING tr_type1 #NO:6842
#                    CALL FGL_DIALOG_SETBUFFER( tr_type1 )
                    DISPLAY BY NAME tr_type1 
                    NEXT FIELD tr_type1
                 WHEN INFIELD(z3) #
#                   CALL q_gem(10,3,z3) RETURNING z3
#                   CALL FGL_DIALOG_SETBUFFER( z3 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = z3
                    CALL cl_create_qry() RETURNING z3
#                    CALL FGL_DIALOG_SETBUFFER( z3 )
                    DISPLAY BY NAME z3 
                    NEXT FIELD z3    
                 WHEN INFIELD(z1)   
#                   CALL q_nmo01(10,3,z1) RETURNING z1
#                   CALL FGL_DIALOG_SETBUFFER( z1 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nmo01"
                    LET g_qryparam.default1 = z1
                    CALL cl_create_qry() RETURNING z1
#                    CALL FGL_DIALOG_SETBUFFER( z1 )
                    DISPLAY BY NAME z1 
                    NEXT FIELD z1 
                 WHEN INFIELD(z2)    
#                   CALL q_nmo01(10,3,z2) RETURNING z2
#                   CALL FGL_DIALOG_SETBUFFER( z2 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nmo01"
                    LET g_qryparam.default1 = z2
                    CALL cl_create_qry() RETURNING z2
#                    CALL FGL_DIALOG_SETBUFFER( z2 )
                    DISPLAY BY NAME z2
                    NEXT FIELD z2   
                 WHEN INFIELD(z4) #變動碼
#                   CALL q_nml(10,33,z4) RETURNING z4 
#                   CALL FGL_DIALOG_SETBUFFER( z4 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nml"
                    LET g_qryparam.default1 = z4
                    CALL cl_create_qry() RETURNING z4
#                    CALL FGL_DIALOG_SETBUFFER( z4 )
                    DISPLAY BY NAME z4 
                    NEXT FIELD z4   
                 WHEN INFIELD(z5) #付款理由
#                   CALL q_azf(10,26,z5,'2') RETURNING z5
#                   CALL FGL_DIALOG_SETBUFFER( z5 )
                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_azf"   #No.FUN-930104
                    LET g_qryparam.form = "q_azf01a" #No.FUN-930104
                    LET g_qryparam.default1 = z5
#                    LET g_qryparam.arg1 = "2"       #No.FUN-930104
                    LET g_qryparam.arg1 = "8"        #No.FUN-930104
                    CALL cl_create_qry() RETURNING z5
#                    CALL FGL_DIALOG_SETBUFFER( z5 )
                    DISPLAY BY NAME z5
                    CALL t100_nmd17('d')
                    NEXT FIELD z5
                 OTHERWISE EXIT CASE
                END CASE
      
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
      
          ON ACTION CONTROLG
             CALL cl_cmdask()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit              #加離開功能genero
             LET INT_FLAG = 1
             EXIT INPUT     
 
#NO.FUN-570127 start--
         ON ACTION locale                    #genero
            LET g_change_lang = TRUE  
            EXIT INPUT
#NO.FUN-570127 end--
       
       END INPUT
 
#NO.FUN-570127 start---
#       IF INT_FLAG THEN 
#          EXIT WHILE  
#       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p500_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
       IF g_bgjob = "Y" THEN
          SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01 = "anmp500"
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
              CALL cl_err('anmp500','9031',1)   
          ELSE
             LET g_wc=cl_replace_str(g_wc, "'", "\"")
             LET lc_cmd = lc_cmd CLIPPED,
                          " '",g_wc CLIPPED ,"'",
                          #FUN-9A0093--mark--str--
                          #" '",plant[1] CLIPPED ,"'",
                          #" '",plant[2] CLIPPED ,"'",
                          #" '",plant[3] CLIPPED ,"'",
                          #" '",plant[4] CLIPPED ,"'",
                          #" '",plant[5] CLIPPED ,"'",
                          #" '",plant[6] CLIPPED ,"'",
                          #" '",plant[7] CLIPPED ,"'",
                          #" '",plant[8] CLIPPED ,"'",
                          #" '",plant[9] CLIPPED ,"'",
                          #" '",plant[10] CLIPPED ,"'",      
                          #FUN-9A0093--mark--end
                          " '",z0 CLIPPED ,"'",
                          " '",tr_type1 CLIPPED ,"'",
                          " '",g_nmd07 CLIPPED , "'",
                          " '",z1 CLIPPED , "'",
                          " '",z2 CLIPPED , "'",
                          " '",z3 CLIPPED , "'",
                          " '",z4 CLIPPED , "'",
                          " '",z5 CLIPPED , "'",
                          " '",g_bgjob CLIPPED,"'"
             CALL cl_cmdat('anmp500',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p500_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
     EXIT WHILE
  END WHILE
#NO.FUN-570127 end------------
 
#NO.FUN-571027 mark----------
#       IF cl_sure(10,10) THEN
#
#          CALL cl_outnam('anmp500') RETURNING l_name
#          START REPORT anmp500_rep TO l_name
#
#          BEGIN WORK
#
#          LET g_success = 'Y'
#          LET l_seq = 0
#          FOR i = 1 TO 10
#             IF cl_null(plant[i]) THEN 
#                CONTINUE FOR
#             END IF
#             LET g_plant_new = plant[i]
#
#             FOR j = 1 TO i	
#                IF plant[j] = g_plant_new THEN
#                   #No.FUN-550057 ---END--EXIT FOR
#                END IF
#             END FOR
#
#             IF j < i THEN 
#                CONTINUE FOR
#             END IF
#
#             CALL s_getdbs()
#             LET g_sql = "SELECT '','',apf00,apf01,apf03,apf05,apf06,apf07,",
#                         " apf11,apf12,apf13,apf43,apf44,aph02,aph03,",
#                         " aph08,apf02,aph07,aph04,aph05,aph05f,aph14,aph13,aph15",
#                         "  FROM ",g_dbs_new,"apf_file,",g_dbs_new,"aph_file ",
#                         " WHERE ", g_wc CLIPPED,
#                         " AND apf01 = aph01 AND apf41 = 'Y'",
#                       # " AND aph03 = '1' ",  #No.5058
#                         " AND (aph09='N' OR aph09 IS NULL OR aph09 = ' ')"
#
#             #No.5058
#             CASE z0
#               WHEN '1' LET g_sql = g_sql CLIPPED," AND aph03 = '1' "
#               WHEN '2' LET g_sql = g_sql CLIPPED," AND aph03 = 'C' "
#               WHEN '3' LET g_sql = g_sql CLIPPED," AND aph03 IN ('1','C') "
#             END CASE
#             #No.5058(end)
#
#             ##nmz05(付款是否要拋傳票)
#             IF g_nmz.nmz05 = 'Y' THEN 
#                LET g_sql = g_sql clipped, " AND apf44 IS NOT NULL AND apf44 != ' ' "
#             END IF
#             LET g_sql = g_sql clipped," ORDER BY apf01"   #no.5248
#
#             PREPARE p500_prepare FROM g_sql
#             IF SQLCA.sqlcode THEN
#                CALL cl_err("prepare p500_prepare:",SQLCA.sqlcode,1)
#                LET g_success = 'N'
#                EXIT WHILE 
#             END IF
#      
#             DECLARE p500_cs CURSOR WITH HOLD FOR p500_prepare
#             IF SQLCA.sqlcode THEN
#                CALL cl_err("declare p500_prepare:",SQLCA.sqlcode,1)
#                LET g_success = 'N'
#                EXIT WHILE 
#             END IF
#
#             FOREACH p500_cs INTO l_apf.*
#                IF SQLCA.sqlcode THEN
#                   LET g_msg = "p500(Foreach) Plant:",g_plant_new CLIPPED," i:",i
#                   CALL cl_err(g_msg,SQLCA.sqlcode,1)
#                   LET g_success = 'N'
#                   EXIT FOREACH 
#                END IF
#                LET l_apf.plant = plant[i]
#                LET l_apf.dbs   = g_dbs_new
#                OUTPUT TO REPORT anmp500_rep(l_apf.*)
#                LET l_seq = l_seq + 1
#             END FOREACH
#             IF g_success = 'N' THEN 
#                EXIT FOR
#             END IF  
#          END FOR
#
#          FINISH REPORT anmp500_rep
#          #No.+366 010705 plum
#          LET l_cmd = "chmod 777 ", l_name
#          RUN l_cmd
#          #No.+366..end
#       END IF 
#       EXIT WHILE
#     END WHILE
#
#     IF INT_FLAG THEN 
#        LET INT_FLAG = 0
#        EXIT WHILE 
#     END IF
 
     #-----無符合條件資料
 
 
#MOD-5B0212
#    IF l_seq = 0 THEN 
#       CALL cl_getmsg('anm-243',g_lang) RETURNING g_msg
#       LET INT_FLAG = 0  ######add for prompt bug
#       PROMPT g_msg CLIPPED,': ' FOR g_chr  
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#       END PROMPT
#       LET g_success = 'N'
#    END IF
 
#    IF l_seq = 0 THEN
#       CALL cl_err('','anm-243',1)
#       LET g_success = 'N'
#    END IF
#END MOD-5B0212
#
#
#     IF g_success = 'Y' THEN 
#        COMMIT WORK
#        IF g_cnt > 0 OR g_cnt2 > 0 THEN 
#           OPEN WINDOW p500_w2 AT 5,12 WITH FORM "anm/42f/anmp500_1"
#                 ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#           CALL cl_ui_locale("anmp500_1")
#           DISPLAY BY NAME g_cnt ,g_tot ,g_start_no ,g_end_no
#           DISPLAY BY NAME g_cnt2,g_tot2,g_start_no2,g_end_no2  #No.5058
#        END IF
#
#        CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#        IF g_cnt > 0 OR g_cnt2 > 0 THEN 
#           CLOSE WINDOW p500_w2
#        END IF
#     ELSE
#        ROLLBACK WORK
#        CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#     END IF
#
#     IF g_flag THEN
#        CONTINUE WHILE
#     ELSE
#        EXIT WHILE
#     END IF
#
END FUNCTION
 
FUNCTION p500_p()
   DEFINE   l_name    LIKE type_file.chr20   #No.FUN-680107 VARCHAR(20)
   DEFINE   l_cmd     LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30)
   DEFINE   l_seq     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE   l_gem02   LIKE gem_file.gem02
   DEFINE   l_nml02   LIKE nml_file.nml02
   DEFINE   l_nmo02   LIKE nmo_file.nmo02
   DEFINE   l_apf     RECORD
                         plant    LIKE nmd_file.nmd34,   #No.FUN-680107 VARCHAR(10)
                         dbs      LIKE type_file.chr21,  #No.FUN-680107CHAR(21)
                         apf00    LIKE apf_file.apf00,
                         apf01    LIKE apf_file.apf01,
                         apf03    LIKE apf_file.apf03,
                         apf05    LIKE apf_file.apf05,
                         apf06    LIKE apf_file.apf06,
                         apf07    LIKE apf_file.apf07,
                         apf11    LIKE apf_file.apf11,
                         apf12    LIKE apf_file.apf12,
                         apf13    LIKE apf_file.apf13,
                         apf43    LIKE apf_file.apf43,
                         apf44    LIKE apf_file.apf44,
                         aph02    LIKE aph_file.aph02,
                         aph03    LIKE aph_file.aph03,
                         aph08    LIKE aph_file.aph08,
                         apf02    LIKE apf_file.apf02,   #付款日期
                         aph07    LIKE aph_file.aph07,
                         aph04    LIKE aph_file.aph04,
                         aph041   LIKE aph_file.aph041,  #FUN-680034
                         aph05    LIKE aph_file.aph05,
                         aph05f   LIKE aph_file.aph05f,
                         aph14    LIKE aph_file.aph14,
                         aph13    LIKE aph_file.aph13,
                         aph15    LIKE aph_file.aph15
                      END RECORD,
   l_allow_insert  LIKE type_file.num5,       #可新增否  #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5        #可刪除否  #No.FUN-680107 SMALLINT
DEFINE li_result   LIKE type_file.num5        #No.FUN-550057  #No.FUN-680107 SMALLINT
   
          CALL cl_outnam('anmp500') RETURNING l_name
          START REPORT anmp500_rep TO l_name
 
#          BEGIN WORK                    #No.FUN-710024
 
          LET g_success = 'Y'
          LET l_seq = 0
          #FUN-9A0093--mark--str--
          #FOR i = 1 TO 10
          #   IF cl_null(plant[i]) THEN 
          #      CONTINUE FOR
          #   END IF
          #   LET g_plant_new = plant[i]
          #
          #   FOR j = 1 TO i	
          #      IF plant[j] = g_plant_new THEN
          #         #No.FUN-550057 ---END--EXIT FOR
          #      END IF
          #   END FOR
          #
          #   IF j < i THEN 
          #      CONTINUE FOR
          #   END IF
          #
          #   CALL s_getdbs()
          #FUN-9A0093--mark--end
          
             LET g_sql = "SELECT '','',apf00,apf01,apf03,apf05,apf06,apf07,",
                         "       apf11,apf12,apf13,apf43,apf44,aph02,aph03,",
                         "       aph08,apf02,aph07,aph04,aph041,aph05,aph05f,aph14,aph13,aph15",    #FUN-680034
                        #"  FROM ",g_dbs_new,"apf_file,",g_dbs_new,"aph_file ",  #FUN-9A0093
                         "  FROM apf_file,aph_file ",   #FUN-9A0093
                         " WHERE ", g_wc CLIPPED,
                         "   AND apf01 = aph01 AND apf41 = 'Y'",
                       # "   AND aph03 = '1' ",  #No.5058
                         "   AND apf00 <> '32' ",                                #MOD-D30124 add
                         "   AND (aph09='N' OR aph09 IS NULL OR aph09 = ' ')"
 
             #No.5058
             CASE z0
               WHEN '1' LET g_sql = g_sql CLIPPED," AND aph03 = '1' "
               WHEN '2' LET g_sql = g_sql CLIPPED," AND aph03 = 'C' "
               WHEN '3' LET g_sql = g_sql CLIPPED," AND aph03 IN ('1','C') "
             END CASE
             #No.5058(end)
 
             ##nmz05(付款是否要拋傳票)
             IF g_nmz.nmz05 = 'Y' THEN 
                LET g_sql = g_sql clipped, " AND apf44 IS NOT NULL AND apf44 != ' ' "
             END IF
             LET g_sql = g_sql clipped," ORDER BY apf01"   #no.5248
 
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             PREPARE p500_prepare FROM g_sql
             IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#                CALL cl_err("prepare p500_prepare:",SQLCA.sqlcode,1)
                CALL s_errmsg('','',"prepare p500_prepare:",SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N'
#                EXIT WHILE   #NO.FUN-571027 mark
             END IF
      
             DECLARE p500_cs CURSOR WITH HOLD FOR p500_prepare
             IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#                CALL cl_err("declare p500_prepare:",SQLCA.sqlcode,1)
                CALL s_errmsg('','',"declare p500_prepare:",SQLCA.sqlcode,1)
#No.FUN-710024--end
                LET g_success = 'N'
#                EXIT WHILE    #NO.FUN-570127 mark
             END IF
 
             FOREACH p500_cs INTO l_apf.*
                IF SQLCA.sqlcode THEN
                   LET g_msg = "p500(Foreach) Plant:",g_plant_new CLIPPED," i:",i
#No.FUN-710024--begin
#                   CALL cl_err(g_msg,SQLCA.sqlcode,1)
                   CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)
#No.FUN-710024--end
                   LET g_success = 'N'
                   EXIT FOREACH 
                END IF
                #LET l_apf.plant = plant[i]    #FUN-9A0093
                #LET l_apf.dbs   = g_dbs_new   #FUN-9A0093
                OUTPUT TO REPORT anmp500_rep(l_apf.*)
                LET l_seq = l_seq + 1
             END FOREACH
#FUN-9A0093--mark--str--           
#             IF g_success = 'N' THEN 
##                EXIT FOR                            #No.FUN-710024
#                CONTINUE FOR                         #No.FUN-710024
#             END IF  
#          END FOR
#FUN-9A0093--mark--end
 
          FINISH REPORT anmp500_rep
          #No.+366 010705 plum
#         LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#         RUN l_cmd                                          #No.FUN-9C0009
          IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
          #No.+366..end
#       END IF    #NO.FUN-570127 MARK
#       EXIT WHILE
#     END WHILE
 
#     IF INT_FLAG THEN 
#        LET INT_FLAG = 0
#        EXIT WHILE 
#     END IF
 
     #-----無符合條件資料
 
#MOD-5B0212
#    IF l_seq = 0 THEN 
#       CALL cl_getmsg('anm-243',g_lang) RETURNING g_msg
#       LET INT_FLAG = 0  ######add for prompt bug
#       PROMPT g_msg CLIPPED,': ' FOR g_chr  
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#       END PROMPT
#       LET g_success = 'N'
#    END IF
 
    IF l_seq = 0 THEN
#No.FUN-710024--begin
#       CALL cl_err('','anm-243',1)
       CALL s_errmsg('','','','anm-243',1) 
#No.FUN-710024--end
       LET g_success = 'N'
    END IF
#END MOD-5B0212
#NO.FUN-570127  end-----
END FUNCTION
 
FUNCTION t100_nmd17(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)'
    DEFINE l_azfacti LIKE azf_file.azfacti
    DEFINE l_azf03   LIKE azf_file.azf03
    DEFINE l_azf09   LIKE azf_file.azf09    #No.FUN-930104
    SELECT azfacti,azf03,azf09  INTO l_azfacti,l_azf03,l_azf09 FROM azf_file #No.FUN-930104
           WHERE azf01 = z5 AND azf02 = '2'     
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
         WHEN l_azfacti = 'N'     LET g_errno = '9028'
         WHEN l_azf09 != '8'      LET g_errno = 'aoo-407'  #No.FUN-930104
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    DISPLAY l_azf03 TO FORMONLY.azf03 
 
END FUNCTION
   
REPORT anmp500_rep(l_apf)
    DEFINE l_sql        LIKE type_file.chr1000         #No.FUN-680107 VARCHAR(400)
    DEFINE l_apf        RECORD
                        plant LIKE nmd_file.nmd34,     #No.FUN-680107 VARCHAR(10)
                        dbs   LIKE type_file.chr21,    #No.FUN-680107 VARCHAR(21)
                        apf00 LIKE apf_file.apf00,
                        apf01 LIKE apf_file.apf01,
                        apf03 LIKE apf_file.apf03,
                        apf05 LIKE apf_file.apf05,
                        apf06 LIKE apf_file.apf06,
                        apf07 LIKE apf_file.apf07,
                        apf11 LIKE apf_file.apf11,
                        apf12 LIKE apf_file.apf12,
                        apf13 LIKE apf_file.apf13,
                        apf43 LIKE apf_file.apf43,
                        apf44 LIKE apf_file.apf44,
                        aph02 LIKE aph_file.aph02,
                        aph03 LIKE aph_file.aph03,
                        aph08 LIKE aph_file.aph08,
                        apf02 LIKE apf_file.apf02,
                        aph07 LIKE aph_file.aph07,
                        aph04 LIKE aph_file.aph04,
                        aph041 LIKE aph_file.aph041,   #FUN-680034
                        aph05  LIKE aph_file.aph05,
                        aph05f LIKE aph_file.aph05f,
                        aph14 LIKE aph_file.aph14,
                        aph13 LIKE aph_file.aph13,
                        aph15 LIKE aph_file.aph15
                        END RECORD
#   DEFINE l_nmd01      VARCHAR(10)
    DEFINE l_nmd01      LIKE nmd_file.nmd01            #No.FUN-680107 VARCHAR(16) #No.FUN-550057
#   DEFINE l_no         VARCHAR(10)
    DEFINE l_no         LIKE oea_file.oea01            #No.FUN-680107 VARCHAR(16) #No.FUN-550057
    DEFINE l_amt      	LIKE type_file.num20_6         #No.FUN-4C0010 #No.FUN-680107 DECIMAL(20,6)
 
# ORDER EXTERNAL BY l_apf.plant,l_apf.apf01   #FUN-9A0093
  ORDER EXTERNAL BY l_apf.apf01   #FUN-9A0093
 FORMAT
    ON EVERY ROW
       #----update aph_file -------
       LET l_sql = #"UPDATE ",l_apf.dbs,"aph_file ",   #FUN-9A0093 mark
                   "UPDATE aph_file ",       #FUN-9A0093
                   "   SET aph09 = 'Y'  ",
                   "  WHERE aph01 = ? ", 
                   "   AND aph02 =  ? "  CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       PREPARE p500_upapf FROM l_sql
       EXECUTE p500_upapf  USING l_apf.apf01,l_apf.aph02
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
#No.FUN-710024--begin
#          CALL cl_err('upd aph:',SQLCA.sqlcode,1)    
          LET g_showmsg=l_apf.apf01,"/",l_apf.aph02
          CALL s_errmsg('aph01,aph02',g_showmsg,'upd aph:',SQLCA.sqlcode,1)
#No.FUN-710024--end
          LET g_success = 'N'
       END IF
       CALL p500_ins_nmd(l_apf.*) RETURNING l_nmd01   #支票
END REPORT
   
FUNCTION p500_ins_nmd(p_apf)
    DEFINE p_apf        RECORD
                        plant  LIKE nmd_file.nmd34,    #No.FUN-680107 VARCHAR(10)
                        dbs    LIKE cre_file.cre08,    #No.FUN-680107 VARCHAR(10)
                        apf00  LIKE apf_file.apf00,
                        apf01  LIKE apf_file.apf01,
                        apf03  LIKE apf_file.apf03,
                        apf05  LIKE apf_file.apf05,
                        apf06  LIKE apf_file.apf06,
                        apf07  LIKE apf_file.apf07,
                        apf11  LIKE apf_file.apf11,
                        apf12  LIKE apf_file.apf12,
                        apf13  LIKE apf_file.apf13,
                        apf43  LIKE apf_file.apf43,
                        apf44  LIKE apf_file.apf44,
                        aph02  LIKE aph_file.aph02,
                        aph03  LIKE aph_file.aph03,
                        aph08  LIKE aph_file.aph08,
                        apf02  LIKE apf_file.apf02,
                        aph07  LIKE aph_file.aph07,
                        aph04  LIKE aph_file.aph04,
                        aph041 LIKE aph_file.aph041,   #FUN-680034
                        aph05  LIKE aph_file.aph05,
                        aph05f LIKE aph_file.aph05f,
                        aph14  LIKE aph_file.aph14,
                        aph13  LIKE aph_file.aph13,
                        aph15  LIKE aph_file.aph15
                        END RECORD
  # DEFINE l_nmd01      VARCHAR(10)
    DEFINE l_nmd01      LIKE nmd_file.nmd01            #No.FUN-680107 VARCHAR(16) #FUN.560139
    DEFINE l_pmc081     LIKE pmc_file.pmc081
    DEFINE l_pmc082     LIKE pmc_file.pmc082
    DEFINE l_nmd        RECORD LIKE nmd_file.*
    DEFINE l_nmf        RECORD LIKE nmf_file.*
    DEFINE l_date       LIKE type_file.dat             #No.FUN-680107 date
    DEFINE li_result    LIKE type_file.num5            #No.FUN-560060 #No.FUN-680107 SMALLINT
    DEFINE l_nmydmy3    LIKE nmy_file.nmydmy3          #MOD-970167 add
    DEFINE l_aza17      LIKE aza_file.aza17            #MOD-970167 add
 
#------------------------ INSERT nmd_file ------------------------------
    INITIALIZE l_nmd01 TO NULL
    INITIALIZE l_nmd.* TO NULL
    IF NOT cl_null(g_nmd07) THEN #依畫面輸入之日期  01/08/13
       LET l_date = g_nmd07
    ELSE 
       LET l_date = p_apf.apf02
    END IF
#No.FUN-560060--begin                                                   
    CALL s_auto_assign_no("anm",tr_type1,l_date,"1","nmd_file","nmd01","","","")
      RETURNING li_result,l_nmd01
    IF (NOT li_result) THEN                                                   
       LET g_success = 'N' RETURN l_nmd01
    END IF                                                                    
#   CALL s_nmyauno(tr_type1,l_date,'1') RETURNING g_i,l_nmd01
#   IF g_i THEN LET g_success = 'N' RETURN l_nmd01 END IF
#No.FUN-560060--end                                                     
    LET l_nmd.nmd01 = l_nmd01
 
    #No.5058 若為應付電匯款，票號=單號
    IF p_apf.aph03 = 'C' THEN
       LET l_nmd.nmd02 = l_nmd.nmd01
    END IF
    #No.5058(end)
 
    LET l_nmd.nmd03 = p_apf.aph08
    LET l_nmd.nmd04 = p_apf.aph05f  #原幣金額
    LET l_nmd.nmd26 = p_apf.aph05   #本幣金額
    LET l_nmd.nmd05 = p_apf.aph07
    LET l_nmd.nmd06 = z1
    LET l_nmd.nmd17 = p_apf.apf11   #付款理由
    IF cl_null(l_nmd.nmd17) THEN LET l_nmd.nmd17 = z5 END IF
    LET l_nmd.nmd20 = z2
    LET l_nmd.nmd07 = l_date
    LET l_nmd.nmd08 = p_apf.apf03
##No:2741 --------廠商全名加上pmc082
    SELECT pmc081,pmc082,pmc27 INTO l_pmc081,l_pmc082,l_nmd.nmd14 
      FROM pmc_file WHERE pmc01 = p_apf.apf03
    LET l_nmd.nmd09 = l_pmc081 CLIPPED,l_pmc082 CLIPPED
##No:2741 --------廠商全名加上pmc082
    IF l_nmd.nmd09 IS NULL OR l_nmd.nmd09 = ' ' THEN
       SELECT apl02 INTO l_nmd.nmd09 FROM apl_file WHERE apl01 = p_apf.apf13
    END IF
    IF l_nmd.nmd14 IS NULL THEN LET l_nmd.nmd14 = '2' END IF
    LET l_nmd.nmd10 = p_apf.apf01
    LET l_nmd.nmd101 = p_apf.aph02
    LET l_nmd.nmd12 = 'X'
    LET l_nmd.nmd13 = p_apf.apf02
    LET l_nmd.nmd18 = z3
    LET l_nmd.nmd19 = p_apf.aph14
    LET l_nmd.nmd21 = p_apf.aph13
    SELECT MAX(pmd02) INTO l_nmd.nmd22 FROM pmd_file
           WHERE pmd01 = p_apf.apf03 AND pmd06 = g_nmz.nmz54
    LET l_nmd.nmd23 = p_apf.aph04
#FUN-680034--begin
    IF g_aza.aza63='Y' THEN
       LET l_nmd.nmd231 = p_apf.aph041
    END IF
#FUN-680034--end   
    LET l_nmd.nmd24 = p_apf.apf12
    LET l_nmd.nmd25 = z4
  #MOD-970167---modify---start---
    SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file
     WHERE nmyslip = tr_type1
    IF l_nmydmy3 = 'Y' THEN
       LET l_nmd.nmd27 = " "
    ELSE
       LET l_nmd.nmd27 = p_apf.apf44
    END IF
   #LET l_nmd.nmd27 = p_apf.apf44
  #MOD-970167---modify---end---
   #No.B629 010702 by plum
    IF NOT cl_null(p_apf.apf44) THEN
       SELECT npp03 INTO l_nmd.nmd28 FROM npp_file
        WHERE nppsys = 'AP'   AND npp00 = 3
         #AND npp01  = p_apf.apf44 AND npp011 = 1
          AND npp01  = p_apf.apf01 AND npp011 = 1 #no.7492
    END IF
   #No.B629..end
    #no.7492 直接付款時
    IF p_apf.apf00 != '33' THEN
       SELECT npp03 INTO l_nmd.nmd28 FROM npp_file
        WHERE nppsys = 'AP'   AND npp00 = 1
          AND npp01  = p_apf.apf01 AND npp011 = 1
          AND npptype='0'                         #FUN-680034       
    END IF
    #no.7492(end)
    LET l_nmd.nmd30 = 'N'
    IF p_apf.aph03 = '1' THEN
       LET l_nmd.nmd31 = p_apf.aph15    #No.B095 add
    ELSE
       LET l_nmd.nmd31 = '98'           #No.5058
    END IF
    #LET l_nmd.nmd34 = p_apf.plant   #FUN-9A0093
 #MOD-970167---add---start---
    SELECT aza17 INTO l_aza17 FROM aza_file
    #IF l_nmd.nmd34 != g_plant and l_nmd.nmd21 != l_aza17 THEN   #FUN-9A0093 
    IF l_nmd.nmd21 != l_aza17 THEN   #FUN-9A0093
       SELECT * INTO g_apz.* FROM apz_file
      #CALL s_curr3(l_nmd.nmd21,l_nmd.nmd07,g_apz.apz33) RETURNING l_nmd.nmd19   #MOD-C90262 mark
       LET l_nmd.nmd26 = l_nmd.nmd04 * l_nmd.nmd19
       IF cl_null(l_nmd.nmd26) THEN
          LET l_nmd.nmd26 = 0
       END IF
       CALL cl_digcut(l_nmd.nmd26,g_azi04) RETURNING l_nmd.nmd26
    END IF
 #MOD-970167---add---end---
    LET l_nmd.nmduser=g_user
    LET l_nmd.nmdgrup=g_grup
    LET l_nmd.nmddate=g_today
    #---bug no:A049
     LET l_nmd.nmd33=l_nmd.nmd19
    #---end 
    LET l_nmd.nmd40='1' #FUN-960141 add
   #-MOD-AC0326-add-
    SELECT MAX(nna021) INTO l_nmd.nmd54
      FROM nna_file
     WHERE nna01 = p_apf.aph08
       AND nna02 = p_apf.aph15
       AND nna06 = 'Y' 
   #-MOD-AC0326-end-
    #FUN-980005 add legal 
    LET l_nmd.nmdlegal = g_legal 
    #FUN-980005 end legal 
    LET l_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
    LET l_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
    LET l_nmd.nmd55=l_nmd.nmd04     #FUN-C90122
    INSERT INTO nmd_file VALUES(l_nmd.*)
    IF SQLCA.sqlcode THEN 
#      CALL cl_err('ins nmd:',STATUS,1)    #No.FUN-660148
#No.FUN-710024--begin
#       CALL cl_err3("ins","nmd_file",l_nmd.nmd01,"",STATUS,"","ins nmd:",1) #No.FUN-660148
       CALL s_errmsg('nmd01',l_nmd.nmd01,'ins nmd:',STATUS,1) 
#No.FUN-710024--end
       LET g_success = 'N' 
       RETURN ''
    END IF
   #LET g_cnt = g_cnt + 1
   #LET g_tot = g_tot + p_apf.aph05
   #IF g_cnt =1 THEN LET  g_start_no = l_nmd.nmd01 END IF
   #LET g_end_no = l_nmd.nmd01
    #No.5058
    CASE p_apf.aph03
      WHEN '1' LET g_cnt = g_cnt + 1
               LET g_tot = g_tot + p_apf.aph05
               IF g_cnt =1 THEN LET  g_start_no = l_nmd.nmd01 END IF
               LET g_end_no = l_nmd.nmd01
      WHEN 'C' LET g_cnt2= g_cnt2+ 1
               LET g_tot2= g_tot2+ p_apf.aph05
               IF g_cnt2=1 THEN LET  g_start_no2= l_nmd.nmd01 END IF
               LET g_end_no2= l_nmd.nmd01
    END CASE
    #No.5058(end)
 
#------------------------ INSERT nmf_file ------------------------------
    INITIALIZE l_nmf.* TO NULL
    LET l_nmf.nmf01 = l_nmd.nmd01
    LET l_nmf.nmf02 = p_apf.apf02
    LET l_nmf.nmf03 = '1'
    LET l_nmf.nmf04 = g_user
    LET l_nmf.nmf05 = '0'
    LET l_nmf.nmf06 = 'X'
    LET l_nmf.nmf07 = p_apf.apf03
    LET l_nmf.nmf08 = 1
    LET l_nmf.nmf09 = 1
    LET l_nmf.nmf12 = p_apf.apf01    #付款單號
    LET l_nmf.nmf11 = p_apf.apf44    #傳票編號
    LET l_nmf.nmf13 = p_apf.apf43    #傳票日期
    #FUN-980005 add legal 
    LET l_nmf.nmflegal = g_legal 
    #FUN-980005 end legal 
    INSERT INTO nmf_file VALUES(l_nmf.*)
    IF SQLCA.sqlcode THEN 
#      CALL cl_err('ins nmf',STATUS,1)    #No.FUN-660148
#No.FUN-710024--begin
#       CALL cl_err3("ins","nmf_file",l_nmf.nmf01,l_nmf.nmf03,STATUS,"","ins nmf",1) #No.FUN-660148
       LET g_showmsg=l_nmf.nmf01,"/",l_nmf.nmf03
       CALL s_errmsg('nmf01,nmf03',g_showmsg,'ins nmf:',STATUS,1) 
#No.FUN-710024--end
       LET g_success = 'N' 
       RETURN ' '     
    END IF
    RETURN l_nmd01
END FUNCTION
