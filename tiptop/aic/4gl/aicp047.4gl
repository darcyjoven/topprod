# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aicp047.4gl                                                  
# Descriptions...: ICD委外采購單批次背景處理作業                                    
# Date & Author..: 10/02/25 by jan (#FUN-A30027)
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  1、將cl_used()改成標準，使用g_time
#                                                          2、未加離開前的 cl_used(2)
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-B30192 11/05/05 By shenyang  修改字段icb05
# Modify.........: No.FUN-B90060 11/11/14 By jason icd行業加上"開立下階工單"的外部呼叫
# Modify.........: No.FUN-BA0051 11/11/14 By jason 一批號多DATECODE功能
 
DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aicp046.global"

MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP                       #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
  
#  LET g_t1 = ARG_VAL(1)
#  LET g_pmm04 = ARG_VAL(2)
#  LET g_pmm12 = ARG_VAL(3)
#  LET g_pmm13 = ARG_VAL(4)
#  LET g_t2    = ARG_VAL(5)
#  LET g_sfp03 = ARG_VAL(6)
#  LET g_pmm22 = ARG_VAL(7)
#  LET g_pmm42 = ARG_VAL(8)
   LET g_bgjob = ARG_VAL(1)
   LET g_rvu.rvu02 = ARG_VAL(2) #FUN-B90060 由sapmt720_icd呼叫時帶收貨單號

   IF cl_null(g_bgjob) THEN                                                     
      LET g_bgjob = "N"                                                         
   END IF
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211

   CALL p046sub_create_bin_temp()  RETURNING l_table
   CALL p046sub_create_icout_temp()

   IF g_bgjob <> 'Y' THEN
      CALL p047_tm()
   ELSE
      CALL p047_default()
   END IF

   DROP TABLE icout_temp
   CALL p047_rvv()
   CLOSE WINDOW p047_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN

#-----------------------------------------------------------------------------#
#--------------------------取得符合條件資料且維護資料-------------------------#
#-----------------------------------------------------------------------------#
#QBE查詢資料 & INPUT條件
FUNCTION p047_tm()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
DEFINE  li_result       LIKE type_file.num5
DEFINE  lc_cmd          LIKE type_file.chr1000
DEFINE  l_gen02         LIKE gen_file.gen02,
        l_gen03         LIKE gen_file.gen03,
        l_gem02         LIKE gem_file.gem02,
        l_acti          LIKE type_file.chr1

   OPEN WINDOW p047_w WITH FORM "aic/42f/aicp047"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   
   WHILE TRUE

      CLEAR FORM                             #清除畫面
      CALL g_data.clear()
      CALL g_idc.clear()
      CALL g_process.clear()
      CALL g_process_msg.clear()
      LET g_rec_b = 0
      LET g_rec_b2 = 0
      LET g_wc = NULL
      CALL cl_del_data(l_table)  
      DROP TABLE icout_temp

      CONSTRUCT BY NAME g_wc ON rvu01,rvu03,rvu04,rvviicd03,rvv31

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(rvu01) #入庫單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rvu1"
                  LET g_qryparam.arg1 = "1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvu01
                  NEXT FIELD rvu01

               WHEN INFIELD(rvu04) #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_pmc2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvu04
                  NEXT FIELD rvu04

               WHEN INFIELD(rvviicd03) #母體料號
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state = "c"
               #   LET g_qryparam.form = "q_imaicd"
               #   LET g_qryparam.where= " imaicd04='1'"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_imaicd","imaicd04='1'","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO rvviicd03
                  NEXT FIELD rvviicd03

               WHEN INFIELD(rvv31) #入庫料號
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state = "c"
               #   LET g_qryparam.form = "q_ima"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO rvv31
                  NEXT FIELD rvv31

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

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

      END CONSTRUCT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p047_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF

      IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF

      #default值
      LET g_pmm04 = g_today
      LET g_pmm12 = g_user
      LET g_pmm22 = g_aza.aza17 
      LET g_pmm42 = 1
      SELECT ica042,ica41 INTO g_t1,g_t2 FROM ica_file 
       WHERE ica00 = '0'

      LET l_gen02 = NULL
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_pmm12
      DISPLAY l_gen02 TO gen02

      SELECT gen03 INTO g_pmm13 FROM gen_file WHERE gen01 = g_user
      LET g_sfp03 = g_today


      INPUT g_t1,g_pmm04,g_pmm12,g_pmm13,g_t2,g_sfp03,g_pmm22,g_pmm42,g_bgjob
            WITHOUT DEFAULTS
       FROM g_t1,pmm04,pmm12,pmm13,g_t2,sfp03,pmm22,pmm42,g_bgjob

         BEFORE INPUT
           CALL p046sub_set_entry()
           CALL p046sub_set_no_entry()
           CALL p046sub_set_no_required()
           CALL p046sub_set_required()

         AFTER FIELD g_t1 #委外單別
            IF NOT cl_null(g_t1) THEN
               LET g_cnt = 0
               LET g_t1=s_get_doc_no(g_t1)
               SELECT COUNT(*) INTO g_cnt FROM smy_file
                WHERE smyslip = g_t1
                 #AND substr(smy57,6,6) = '1'
                  AND smy57[6,6] = '1'  #FUN-B40029
               IF g_cnt = 0 THEN
                  CALL cl_err('','aic-141',0)
                  NEXT FIELD g_t1
               END IF

               CALL s_check_no("asf",g_t1,"","1","sfb_file","sfb01","")
                    RETURNING li_result,g_t1
               DISPLAY BY NAME g_t1
               IF (NOT li_result) THEN
                  NEXT FIELD g_t1
               END IF
               LET g_t1 = s_get_doc_no(g_t1)
            END IF

         AFTER FIELD g_t2 #發料單別
            IF NOT cl_null(g_t2) THEN
               CALL s_check_no("asf",g_t2,"","3","sfp_file", "sfp01","")
                    RETURNING li_result,g_t2
               DISPLAY BY NAME g_t2
               IF (NOT li_result) THEN
                  NEXT FIELD g_t2
               END IF
               LET g_t2 = s_get_doc_no(g_t2)
            END IF

         AFTER FIELD pmm12 #採購人員
           IF NOT cl_null(g_pmm12) THEN
              LET l_gen02 = NULL LET l_gen03 = NULL
              SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_acti
                FROM gen_file
               WHERE gen01 = g_pmm12
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm12
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm12
              END IF
              LET g_pmm13 = l_gen03
              DISPLAY g_pmm13 TO pmm13
              DISPLAY l_gen02 TO gen02
           ELSE
              DISPLAY '' TO gen02
           END IF

         AFTER FIELD pmm13 #採購部門
           IF NOT cl_null(g_pmm13) THEN
              SELECT gem02,gemacti INTO l_gem02,l_acti FROM gem_file
               WHERE gem01 = g_pmm13
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm13
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm13
              END IF
           END IF

         BEFORE FIELD pmm22
           CALL p046sub_set_entry()
           CALL p046sub_set_no_required()

         AFTER FIELD pmm22 #幣別
           IF NOT cl_null(g_pmm22) THEN
              SELECT aziacti INTO l_acti FROM azi_file
               WHERE azi01 = g_pmm22
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm22
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm22
              END IF
              CALL s_curr3(g_pmm22,g_pmm04,'S') RETURNING g_pmm42
              DISPLAY g_pmm42 TO pmm42
           END IF
           CALL p046sub_set_no_entry()
           CALL p046sub_set_required()

         AFTER FIELD pmm42 #匯率
           IF NOT cl_null(g_pmm22) THEN
              IF NOT cl_null(g_pmm42) THEN
                 IF g_pmm42 <= 0 THEN
                    CALL cl_err('','mfg9243',0)
                    NEXT FIELD pmm42
                 END IF
              END IF
           END IF

         AFTER FIELD sfp03 #扣帳日期
           IF NOT cl_null(g_sfp03) THEN
              IF g_sma.sma53 IS NOT NULL AND g_sfp03 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD sfp03
              END IF
              CALL s_yp(g_sfp03) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD sfp03
              END IF
           END IF

         AFTER INPUT  #總檢
           IF INT_FLAG THEN EXIT INPUT END IF

           #採購人員
           IF NOT cl_null(g_pmm12) THEN
              SELECT genacti INTO l_acti FROM gen_file WHERE gen01 = g_pmm12
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm12
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm12
              END IF
           END IF

           #採購部門
           IF NOT cl_null(g_pmm13) THEN
              SELECT gemacti INTO l_acti FROM gem_file WHERE gem01 = g_pmm13
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm13
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm13
              END IF
           END IF

           #幣別
           IF NOT cl_null(g_pmm22) THEN
              SELECT aziacti INTO l_acti FROM azi_file WHERE azi01 = g_pmm22
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm22
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm22
              END IF
           END IF

           #匯率
           IF NOT cl_null(g_pmm22) THEN
              IF NOT cl_null(g_pmm42) THEN
                 IF g_pmm42 <= 0 THEN
                    CALL cl_err('','mfg9243',0)
                    NEXT FIELD pmm42
                 END IF
              END IF
           END IF

           #扣帳日期
           IF NOT cl_null(g_sfp03) THEN
              IF g_sma.sma53 IS NOT NULL AND g_sfp03 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD sfp03
              END IF
              CALL s_yp(g_sfp03) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD sfp03
              END IF
           END IF

         ON ACTION controlp
            CASE
               WHEN INFIELD(g_t1) #委外單別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smy1"
                     LET g_qryparam.where = "smykind= '1' AND smysys = 'asf' ",
                    #                       "AND substr(smy57,6,6) = '1' "
                                            "AND smy57[6,6] = '1' "       #FUN-B40029
                     CALL cl_create_qry() RETURNING g_t1
                     DISPLAY BY NAME g_t1
                     NEXT FIELD g_t1

               WHEN INFIELD(g_t2) #發料單別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smy1"
                  LET g_qryparam.where = "smykind= '3' AND smysys = 'asf' "
                  CALL cl_create_qry() RETURNING g_t2
                  DISPLAY BY NAME g_t2
                  NEXT FIELD g_t2

               WHEN INFIELD(pmm12) #採購人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_pmm12
                  DISPLAY g_pmm12 TO pmm12
                  NEXT FIELD pmm12

               WHEN INFIELD(pmm13) #採購部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_pmm13
                  DISPLAY g_pmm13 TO pmm13
                  NEXT FIELD pmm13

               WHEN INFIELD(pmm22) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  CALL cl_create_qry() RETURNING g_pmm22
                  DISPLAY g_pmm22 TO pmm22
                  NEXT FIELD pmm22

               OTHERWISE EXIT CASE
            END CASE

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT INPUT

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p047_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN                                                                                                             
      SELECT zz08 INTO lc_cmd FROM zz_file                                                                                          
       WHERE zz01 = "aicp047"                                                                                                       
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN                                                                                       
         CALL cl_err('aicp047','9031',1)                                                                                            
      ELSE                                                                                                                          
         LET lc_cmd = lc_cmd CLIPPED,                                                                                               
                      " '",g_t1 CLIPPED,"'",                                                                                      
                      " '",g_pmm04 CLIPPED,"'",                                                                                    
                      " '",g_pmm12 CLIPPED,"'",
                      " '",g_pmm13 CLIPPED,"'",
                      " '",g_t2 CLIPPED,"'",                                                                                      
                      " '",g_sfp03 CLIPPED,"'",                                                                                      
                      " '",g_pmm22 CLIPPED,"'",
                      " '",g_pmm42 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aicp047',g_time,lc_cmd CLIPPED)                                                                             
      END IF                                                                                                                        
      CLOSE WINDOW p047_w                                                                                                           
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM                                                                                                                  
   END IF
   EXIT WHILE
  END WHILE
END FUNCTION

FUNCTION p047_rvv()              
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
   DEFINE l_n         LIKE type_file.num5

   LET g_sql = "SELECT 'Y',rvv01,rvv02,rvv31,rvv031,imaicd04,rvv32,rvv33,",
               "       rvv34,pmn63,pmniicd08,pmniicd12,rvbiicd08,rvv17,",
            #  "       rvv85,icb05,rvviicd03,'','','','','','','','',",    #FUN-B30192
               "       rvv85,imaicd14,rvviicd03,'','','','','','','','',",          #FUN-B30192
               "       pmniicd17,pmniicd12,'','','','',''",
               "  FROM rvu_file,rvv_file,pmn_file,ima_file,imaicd_file, ",
          #    "       icb_file,rvb_file,pmni_file,rvbi_file,rvvi_file",    #FUN-B30192
               "       rvb_file,pmni_file,rvbi_file,rvvi_file",             #FUN-B30192
               " WHERE rvu01 = rvv01 AND rvuconf = 'Y' ",     #已確認
               "   AND rvv36 = pmn01 AND rvv37 = pmn02 ",
               "   AND rvv04 = rvb01 AND rvv05 = rvb02 ",
               "   AND rvv17 > 0 ",                           #入庫量>0
               "   AND pmni01 = pmn01 ",
               "   AND pmni02 = pmn02 ",
               "   AND rvbi01 = rvb01 ",
               "   AND rvbi02 = rvb02 ",
               "   AND rvvi01 = rvv01 ",
               "   AND rvvi02 = rvv02 ",
               "   AND rvv31  = ima01 ",
               "   AND ima01  = imaicd00",                #CHI-830032
               "   AND imaicd04 <> '9'",  #FUN-980033
            #  "   AND rvviicd03 = icb01 ",   #FUN-B30192
            #  "   AND icb06 <> '2' ",                    #母體狀態未hold     #FUN-B30192
               "   AND (rvviicd07 = 'N' OR rvviicd07 = ' ' ", #排除委外最終站
               "        OR rvviicd07 IS NULL)"
   IF g_bgjob <> 'Y' THEN
      LET g_sql = g_sql CLIPPED,"   AND ",g_wc CLIPPED
   ELSE
      #LET g_sql = g_sql CLIPPED,"   AND rvu03 = '",g_today,"'" #FUN-B90060 mark
      #FUN-B90060 --START--
      IF cl_null(g_rvu.rvu02) THEN
         LET g_sql = g_sql CLIPPED,"   AND rvu03 = '",g_today,"'"
      ELSE
         LET g_sql = g_sql CLIPPED,"   AND rvu02 = '",g_rvu.rvu02,"'"
      END IF
      #FUN-B90060 --END--  
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY rvv01,rvv02"

   PREPARE p047_data_pre FROM g_sql
   DECLARE p047_data_cs CURSOR FOR p047_data_pre

   CALL g_data.clear()
   LET l_cnt = 1
   LET g_rec_b = 0

   FOREACH p047_data_cs INTO g_data[l_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         RETURN
      END IF

     #判斷是否有庫存量
      IF cl_null(g_data[l_cnt].rvv33) THEN LET g_data[l_cnt].rvv33 = " " END IF
      IF cl_null(g_data[l_cnt].rvv34) THEN LET g_data[l_cnt].rvv34 = " "
      END IF
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM img_file
       WHERE img01 = g_data[l_cnt].rvv31 AND img02 = g_data[l_cnt].rvv32
         AND img03 = g_data[l_cnt].rvv33 AND img04 = g_data[l_cnt].rvv34
         AND img10 IS NOT NULL AND img10 > 0
      IF g_cnt = 0 THEN CONTINUE FOREACH END IF

     #判斷是否有庫存量(idc_file)
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM idc_file
       WHERE idc01 = g_data[l_cnt].rvv31
         AND idc02 = g_data[l_cnt].rvv32
         AND idc03 = g_data[l_cnt].rvv33
         AND idc04 = g_data[l_cnt].rvv34
         AND (idc08 - idc21) > 0          #idc數量>0
         AND idc17 <> 'Y'                 #料件狀態未hold

      IF g_cnt = 0 THEN CONTINUE FOREACH END IF

     #判斷是否有下階段料(須開WO)
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM icm_file
       WHERE icm01 = g_data[l_cnt].rvv31
         AND icm02 IS NOT NULL #AND icmacti = 'Y'
      IF g_cnt = 0 THEN CONTINUE FOREACH END IF

    #設default值---------------------------------------------------------------
     #若wafer廠商無資料,用母體料號串icd檔(icb_file),帶出wafer廠商(icb08)
     IF cl_null(g_data[l_cnt].sfbiicd02) THEN
        SELECT icb08 INTO g_data[l_cnt].sfbiicd02 FROM icb_file
         WHERE icb01 = g_data[l_cnt].sfbiicd14
     END IF

     #若wafer site無資料,用母體料號串icd檔(icb_file),帶出wafer site(icb27)
     IF cl_null(g_data[l_cnt].sfbiicd03) THEN
        SELECT icb27 INTO g_data[l_cnt].sfbiicd03 FROM icb_file
         WHERE icb01 = g_data[l_cnt].sfbiicd14
     END IF
     
     DECLARE rvv31_dec CURSOR FOR
      SELECT bmb09 FROM bmb_file
       WHERE bmb03 = g_data[l_cnt].rvv31 
         AND (bmb09<>' ' AND bmb09 IS NOT NULL)
       ORDER BY bmb09
     FOREACH rvv31_dec INTO g_data[l_cnt].sfbiicd09
       EXIT FOREACH
     END FOREACH
     IF cl_null(g_data[l_cnt].sfbiicd09) THEN 
        IF g_bgjob <> 'Y' THEN
           CALL cl_err(g_data[l_cnt].rvv01,'aic-966',1) 
        ELSE
           CALL cl_getmsg('aic-966',g_lang) RETURNING g_msg
           CALL p046sub_ins_err(g_data[l_cnt].rvv01,g_data[l_cnt].rvv02,g_msg,'','','','N')
        END IF
        CONTINUE FOREACH 
     END IF
     DECLARE icm02_dec CURSOR FOR
      SELECT DISTINCT(icm02) FROM icm_file
       WHERE icm01 = g_data[l_cnt].rvv31 
       ORDER BY icm02
     FOREACH icm02_dec INTO g_data[l_cnt].sfb05
       EXIT FOREACH
     END FOREACH
     IF cl_null(g_data[l_cnt].sfb05) THEN
        IF g_bgjob <> 'Y' THEN
           CALL cl_err(g_data[l_cnt].rvv01,'aic-967',1) 
        ELSE
           CALL cl_getmsg('aic-967',g_lang) RETURNING g_msg
           CALL p046sub_ins_err(g_data[l_cnt].rvv01,g_data[l_cnt].rvv02,g_msg,'','','','N')
        END IF
        CONTINUE FOREACH 
     END IF
     CALL p046sub_ecdicd01(g_data[l_cnt].sfbiicd09) RETURNING l_ecdicd01
     CASE 
       WHEN l_ecdicd01 = '2'
          DECLARE pmi03_dec CURSOR FOR
           SELECT pmi03 FROM pmi_file,pmj_file
            WHERE pmi01 = pmj01
              AND pmj03 = g_data[l_cnt].sfb05
              AND pmj10 = g_data[l_cnt].sfbiicd09
              AND pmiconf = 'Y' AND pmiacti = 'Y'
              AND pmj12 = '2'
              ORDER BY pmj09 DESC
          FOREACH pmi03_dec INTO g_data[l_cnt].sfb82
            EXIT FOREACH
          END FOREACH
       WHEN l_ecdicd01 = '3'
          DECLARE icg03_dec CURSOR FOR
            SELECT icg03 FROM icg_file
             WHERE icg01 = g_data[l_cnt].sfb05
               AND icg02 = g_data[l_cnt].sfbiicd09
             ORDER BY icg16 DESC
          FOREACH icg03_dec INTO g_data[l_cnt].sfb82
            EXIT FOREACH
          END FOREACH
       WHEN l_ecdicd01 = '4'
          DECLARE icj03_dec CURSOR FOR
            SELECT icj03 FROM icj_file
             WHERE icj01 = g_data[l_cnt].sfb05
          FOREACH icj03_dec INTO g_data[l_cnt].sfb82
            EXIT FOREACH
          END FOREACH
       WHEN l_ecdicd01 = '5'
          DECLARE ick09_dec CURSOR FOR
            SELECT ick09 FROM ick_file
             WHERE ick01 = g_data[l_cnt].sfb05
          FOREACH ick09_dec INTO g_data[l_cnt].sfb82
            EXIT FOREACH
          END FOREACH
     END CASE
     IF cl_null(g_data[l_cnt].sfb82) THEN
        IF g_bgjob <> 'Y' THEN
           CALL cl_err(g_data[l_cnt].rvv01,'aic-968',1) 
        ELSE
           CALL cl_getmsg('aic-968',g_lang) RETURNING g_msg
           CALL p046sub_ins_err(g_data[l_cnt].rvv01,g_data[l_cnt].rvv02,g_msg,'','','','N')
        END IF
        CONTINUE FOREACH 
     END IF
     CALL p047_def_sfb08(g_data[l_cnt].sfbiicd09,g_data[l_cnt].rvv01, g_data[l_cnt].rvv02,
       g_data[l_cnt].rvv31,g_data[l_cnt].rvv32,g_data[l_cnt].rvv33, g_data[l_cnt].rvv34)
     RETURNING g_data[l_cnt].sfb08
     IF cl_null(g_data[l_cnt].sfb08) OR g_data[l_cnt].sfb08 = 0 THEN 
        IF g_bgjob <> 'Y' THEN
           CALL cl_err(g_data[l_cnt].rvv01,'aic-969',1) 
        ELSE
           CALL cl_getmsg('aic-969',g_lang) RETURNING g_msg
           CALL p046sub_ins_err(g_data[l_cnt].rvv01,g_data[l_cnt].rvv02,g_msg,'','','','N')
        END IF
        CONTINUE FOREACH 
     END IF
     LET g_data[l_cnt].sfb15 = g_today
     LET l_cnt = l_cnt + 1

   END FOREACH 
   CALL g_data.deleteElement(l_cnt)
   LET g_rec_b = l_cnt - 1
   FOR l_n = 1 TO g_rec_b
       CALL p047_ins_bin_temp(l_n)
   END FOR
   CALL p046sub_process()
   CALL p046sub_out()  
END FUNCTION

#預設生產數量sfb08
FUNCTION p047_def_sfb08(p_sfbiicd09,p_rvv01,p_rvv02,p_rvv31,p_rvv32,p_rvv33,p_rvv34)
   DEFINE l_ecdicd01     LIKE ecd_file.ecdicd01,
          l_ecdicd01_pre LIKE ecd_file.ecdicd01
   DEFINE l_qty1      LIKE rvv_file.rvv85        #入庫數量
   DEFINE l_sfb08     LIKE sfb_file.sfb08        #其它工單生產數量
   DEFINE l_qty2      LIKE idc_file.idc08 #庫存數量
   DEFINE l_die       LIKE rvv_file.rvv85 #TQC-940015
   DEFINE p_sfbiicd09 LIKE sfbi_file.sfbiicd09
   DEFINE p_rvv01     LIKE rvv_file.rvv01
   DEFINE p_rvv02     LIKE rvv_file.rvv02
   DEFINE p_rvv31     LIKE rvv_file.rvv31
   DEFINE p_rvv32     LIKE rvv_file.rvv32
   DEFINE p_rvv33     LIKE rvv_file.rvv33
   DEFINE p_rvv34     LIKE rvv_file.rvv34

   CALL p046sub_ecdicd01(p_sfbiicd09) RETURNING l_ecdicd01
   SELECT ecdicd01 INTO l_ecdicd01_pre FROM ecd_file
     WHERE ecd01 = (SELECT rvviicd01 FROM rvvi_file
                     WHERE rvvi01 = p_rvv01
                       AND rvvi02 = p_rvv02)

   SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file,sfbi_file
    WHERE sfbiicd16 = p_rvv01
      AND sfbiicd17 = p_rvv02
      AND sfbi01=sfb01
      AND sfb87 <> 'X'
      AND sfb08 IS NOT NULL

   #取得入庫數量/庫存數量
   IF l_ecdicd01 MATCHES '[346]' THEN
      #入庫數量
      IF g_sma.sma115='Y' THEN  #若不使用多單位的處理方式
         SELECT rvv85 INTO l_qty1 FROM rvv_file
          WHERE rvv01 = p_rvv01 AND rvv02 = p_rvv02
      ELSE
         SELECT rvv17 INTO l_qty1 FROM rvv_file
          WHERE rvv01 = p_rvv01 
            AND rvv02 = p_rvv02
       #FUN-B30192--mark     
       # SELECT icb05 INTO l_die FROM icb_file,rvvi_file
       #                        WHERE rvvi01=p_rvv01
       #                          AND rvvi02=p_rvv02
       #                          AND icb01=rvviicd03
       #FUN-B30192--mark
         CALL s_icdfun_imaicd14(p_rvv31)   RETURNING l_die    #FUN-B30192
         IF cl_null(l_die) THEN
            LET l_die=0
         END IF    
         LET l_qty1=l_qty1*l_die      
      END IF
      
      #庫存數量
      IF l_ecdicd01 = '6' AND
         (cl_null(l_ecdicd01_pre) OR l_ecdicd01_pre <> '2') THEN
         SELECT SUM(idc12 * ((idc08 - idc21)/idc08)) INTO l_qty2
           FROM idc_file
          WHERE idc01 = p_rvv31
            AND idc02 = p_rvv32
            AND idc03 = p_rvv33
            AND idc04 = p_rvv34
            AND idc17 = 'N'
            AND idc08 > 0   #A要加,不然會錯
      ELSE
         SELECT SUM(idc12 * ((idc08 - idc21)/idc08)) INTO l_qty2
           FROM idc_file
          WHERE idc01 = p_rvv31
            AND idc02 = p_rvv32
            AND idc03 = p_rvv33
            AND idc04 = p_rvv34
            AND idc16 = 'Y'
            AND idc17 = 'N'
            AND idc08 > 0   #要加,不然會錯
      END IF
   ELSE
      #入庫數量
      SELECT rvv17 INTO l_qty1 FROM rvv_file
       WHERE rvv01 = p_rvv01 AND rvv02 = p_rvv02

      #庫存數量
      SELECT SUM(idc08 - idc21) INTO l_qty2 FROM idc_file
       WHERE idc01 = p_rvv31
         AND idc02 = p_rvv32
         AND idc03 = p_rvv33
         AND idc04 = p_rvv34
         AND idc17 = 'N'
   END IF
   IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
   IF l_qty1 IS NULL THEN LET l_qty1 = 0 END IF
   IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
   LET l_qty1 = l_qty1 - l_sfb08

   IF l_qty1 <= l_qty2 THEN
      RETURN l_qty1
   ELSE
      RETURN l_qty2
   END IF
END FUNCTION

FUNCTION p047_ins_bin_temp(p_ac)
  DEFINE p_ac        LIKE type_file.num5
  DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
  DEFINE l_qty       LIKE idc_file.idc08
  DEFINE l_icf01     LIKE icf_file.icf01 #bin item
  DEFINE l_sql       STRING
  DEFINE l_cnt       LIKE type_file.num10
 # DEFINE l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
  DEFINE l_sum1,l_sum2,l_qty1    LIKE idc_file.idc08

  #FUN-BA0051 --START mark--
  #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
  # WHERE imaicd00 = g_data[p_ac].rvv31
  ##入庫料號狀態為[0-2],且須做刻號管理才要維護BIN刻號資料
  #IF cl_null(g_data[p_ac].imaicd04) OR
  #   g_data[p_ac].imaicd04 NOT MATCHES '[012]' OR    #入庫料號狀態為[0-2]
  #   cl_null(l_imaicd08) OR l_imaicd08 <> 'Y' THEN  #須做刻號管理
  ##FUN-BA0051 --END mark--
  IF NOT s_icdbin(g_data[p_ac].rvv31) THEN   #FUN-BA0051   
     CALL p046sub_del_data(l_table,p_ac)
     RETURN
  END IF

  #取得庫存數量
  CALL p046sub_qty(g_data[p_ac].sfbiicd09,g_data[p_ac].imaicd04,g_data[p_ac].rvv31,
       g_data[p_ac].rvv32,g_data[p_ac].rvv33,g_data[p_ac].rvv34,g_data[p_ac].sfbiicd10,
       g_data[p_ac].sfbiicd14)
  RETURNING l_qty

  #若g_data[p_ac].sel = 'Y'且無bin維護記錄 =>新增bin維護記錄
  LET g_cnt = 0
  LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac
   PREPARE r406_bin_temp02 FROM l_sql
   DECLARE bin_count_cs1 CURSOR FOR r406_bin_temp02
   OPEN bin_count_cs1
   FETCH bin_count_cs1 INTO g_cnt
  #bin_temp沒資料就自動新增
   CALL p046sub_ecdicd01(g_data[p_ac].sfbiicd09) RETURNING l_ecdicd01
  IF g_cnt = 0 THEN
     IF g_data[p_ac].imaicd04 = '2' THEN
        CALL p046sub_icf01(g_data[p_ac].rvv31,g_data[p_ac].rvv32,g_data[p_ac].rvv33,
                           g_data[p_ac].rvv34,g_data[p_ac].sfbiicd14)
        RETURNING l_icf01 #--決定串icf_file的料號
        IF cl_null(l_icf01) THEN
           IF g_bgjob <> 'Y' THEN
              CALL cl_err(g_data[p_ac].rvv01,'aic-132',0) 
           ELSE
              CALL cl_getmsg('aic-132',g_lang) RETURNING g_msg
              CALL p046sub_ins_err(g_data[p_ac].rvv01,g_data[p_ac].rvv02,g_msg,'','','','N')
           END IF
           RETURN
        END IF
        LET l_sql =
            "SELECT 'Y',0,idd05,idd06,icf03,icf05,",
            "       idd13, ",
            "       idd18,",
            "       '',''",
            "  FROM idc_file,icf_file,idd_file ",
            " WHERE idc01 = '",g_data[p_ac].rvv31,"'",
            "   AND idc02 = '",g_data[p_ac].rvv32,"'",
            "   AND idc03 = '",g_data[p_ac].rvv33,"'",
            "   AND idc04 = '",g_data[p_ac].rvv34,"'",
            "   AND idd13 > 0 ",
            "   AND idd22 = 'Y'",
            "   AND idc17 = 'N'",
            "   AND idd01 = idc01 AND idd02 = idc02 ",
            "   AND idd03 = idc03 AND idd04 = idc04 ",
            "   AND idd05 = idc05 AND idd06 = idc06 ",
            "   AND idd10 = '",g_data[p_ac].rvv01,"'",
            "   AND idd11 = ",g_data[p_ac].rvv02,
            "   AND icf01 = '",l_icf01,"'",
            "   AND icf02 = idc06 ",
            " ORDER BY idc05,idc06 "
        IF l_ecdicd01 MATCHES '[34]' AND g_data[p_ac].sfbiicd10 = 'Y' THEN
           LET l_sql = l_sql CLIPPED, " AND icf05 <> '1' "
        END IF

            SELECT SUM(idd13),SUM(idd18) INTO l_sum1,l_sum2 
              FROM idc_file,icf_file,idd_file 
             WHERE idc01 = g_data[p_ac].rvv31
               AND idc02 = g_data[p_ac].rvv32
               AND idc03 = g_data[p_ac].rvv33
               AND idc04 = g_data[p_ac].rvv34
               AND idd13 > 0 
               AND idd22 = 'Y'
               AND idc17 = 'N'
               AND idd01 = idc01 AND idd02 = idc02 
               AND idd03 = idc03 AND idd04 = idc04 
               AND idd05 = idc05 AND idd06 = idc06 
               AND idd10 = g_data[p_ac].rvv01
               AND idd11 = g_data[p_ac].rvv02
               AND icf01 = l_icf01
               AND icf02 = idc06 

     ELSE
        LET l_sql =
            "SELECT 'Y',0,idd05,idd06,'','',",
            "       idd13, ",
            "       idd18, ",
            "       '',''",
            "  FROM idc_file,idd_file ",
            " WHERE idc01 = '",g_data[p_ac].rvv31,"'",
            "   AND idc02 = '",g_data[p_ac].rvv32,"'",
            "   AND idc03 = '",g_data[p_ac].rvv33,"'",
            "   AND idc04 = '",g_data[p_ac].rvv34,"'",
            "   AND idd01 = idc01 AND idd02 = idc02 ",
            "   AND idd03 = idc03 AND idd04 = idc04 ",
            "   AND idd05 = idc05 AND idd06 = idc06 ",
            "   AND idd10 = '",g_data[p_ac].rvv01,"'",
            "   AND idd11 = ",g_data[p_ac].rvv02,
            "   AND idc17 = 'N'",
            "   AND idd13 > 0 ",
            " ORDER BY idc05,idc06 "

            SELECT SUM(idd13),SUM(idd18) INTO l_sum1,l_sum2
              FROM idc_file,idd_file 
             WHERE idc01 = g_data[p_ac].rvv31
               AND idc02 = g_data[p_ac].rvv32
               AND idc03 = g_data[p_ac].rvv33
               AND idc04 = g_data[p_ac].rvv34
               AND idd01 = idc01 AND idd02 = idc02 
               AND idd03 = idc03 AND idd04 = idc04 
               AND idd05 = idc05 AND idd06 = idc06 
               AND idd10 = g_data[p_ac].rvv01
               AND idd11 = g_data[p_ac].rvv02
               AND idc17 = 'N'
               AND idd13 > 0 
     END IF

     DECLARE bin_gen_cs CURSOR FROM l_sql
     CALL g_idc.clear()
     LET l_cnt = 1
     FOREACH bin_gen_cs INTO g_idc[l_cnt].*
       IF l_ecdicd01 = '2' THEN LET l_qty1=l_sum1 ELSE LET l_qty1 = l_sum2 END IF
       IF g_data[p_ac].sfb08 <> l_qty1 THEN
          IF g_bgjob <> 'Y' THEN
             CALL cl_err3('','idd_file',g_data[p_ac].rvv01,g_data[p_ac].rvv02,'aic-142','','',0)
          ELSE
             CALL cl_getmsg('aic-142',g_lang) RETURNING g_msg
             CALL p046sub_ins_err(g_data[l_cnt].rvv01,g_data[l_cnt].rvv02,g_msg,'','','','N')
          END IF
          RETURN
        END IF
        LET g_idc[l_cnt].item = l_cnt
        LET g_idc[l_cnt].sel2 = 'Y'

        #在勾選單身二後,並且符合料件狀態為2且為刻號性質為D/G時,
        #抓取符合條件(與主生產料號/產品型號不同)的第一筆資料
        #當生產料號與產品型號的預設值
        #(生產料號/產品型號為空白時,才需做此預設動作)
        CALL p046sub_def_idc(g_idc[l_cnt].sel2,g_data[p_ac].imaicd04,g_idc[l_cnt].icf05,
                          g_idc[l_cnt].ima01,g_data[p_ac].rvv31,g_data[p_ac].sfb05,
                          g_idc[l_cnt].sfbiicd08_b,g_data[p_ac].sfbiicd14,g_data[p_ac].sfbiicd08)
             RETURNING g_idc[l_cnt].ima01,
                       g_idc[l_cnt].sfbiicd08_b

        #因為後續要用該欄位做group,所以不可存null
        IF cl_null(g_idc[l_cnt].sfbiicd08_b) THEN
           LET g_idc[l_cnt].sfbiicd08_b = ' '
        END IF

        LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,"(item1,sel2,item2, ",                                              
                    " idc05,idc06,icf03,icf05,qty1,qty2,ima01,ima02,sfbiicd08_b) ",                                                
                    " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"                                                                           
        PREPARE insert_prep FROM g_sql                                                                                             
        IF STATUS THEN                                                                                                             
          CALL cl_err('insert_prep:',status,1)                                                                         
          RETURN
        END IF
        EXECUTE insert_prep USING p_ac,g_idc[l_cnt].*
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('gen data error:',SQLCA.sqlcode,1)
           RETURN
        END IF
        LET l_cnt = l_cnt + 1
      END FOREACH
      CALL g_idc.deleteElement(l_cnt)
      LET g_rec_b2 = l_cnt - 1
      LET l_cnt = 0 
  END IF
END FUNCTION

FUNCTION p047_default()
DEFINE l_ica41   LIKE ica_file.ica41
DEFINE l_ica042  LIKE ica_file.ica042

  SELECT ica042,ica41 INTO g_t1,g_t2 FROM ica_file 
   WHERE ica00 = '0'
  LET g_pmm04 = g_today
  LET g_pmm12 = g_user
  LET g_pmm13 = g_grup
  LET g_sfp03 = g_today
  LET g_pmm22 = g_aza.aza17
  LET g_pmm42 = 1
END FUNCTION
#FUN-A30027
