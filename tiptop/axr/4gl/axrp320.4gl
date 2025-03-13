# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrp320.4gl
# Descriptions...: 發票自動開立作業
# Date & Author..: 96/05/21 By Roger
# Modify.........: 97/08/01 By Sophia 判斷ooz20是否須確認後才可開立發票
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-570156 06/03/07 By saki 批次背景執行
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680022 06/08/22 By cl  多帳期處理
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/27 By xumin l_time 轉g_time
# Modify.........: No.TQC-6C0147 06/12/26 By Rayven 在程序85行已經處于begin work，而后CALL的FUNCTION中又使用begin work，造成事務重復
# Modify.........: No.FUN-710050 07/01/23 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-810070 08/01/16 By Smapmin 修改幣別取位
# Modify.........: No.FUN-8A0086 08/10/21 By dongbg 修正FUN-710050遺留問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying s_insome加一參數
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 
# Modify.........: No.FUN-A60056 10/06/25 By lutingting GP5.2財務串前段問題整批調整  
# Modify.........: No:CHI-A70015 10/07/06 By Nicola 需考慮無訂單出貨
# Modify.........: No:TQC-A60111 10/08/04 By Dido 比照 CHI-A50040 修改
# Modify.........: No:MOD-AB0101 10/11/11 By Dido SUM ogb14 應以出貨單為主;SUM omb16 應排除作廢部分 
# Modify.........: No:MOD-B10012 11/01/04 By Dido 超交需增加訂單項次條件 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.MOD-B50216 11/05/25 By Dido 超交出貨金額計算與過濾條件調整;過濾作廢條件 
# Modify.........: No.MOD-B50230 11/05/26 By Dido 計算訂單數量取消項次,依整張訂單數量比對給予訂金金額 
# Modify.........: No.TQC-B60089 11/06/15 By Dido 出貨原幣一律採用倒扣計算,本幣金額依原幣與匯率乘算即可 
# Modify.........: No.CHI-B90025 11/09/28 By Polly 程式梳理專案，將計算單身至單頭的程式段合併成一隻saxrp310_bu
# Modify.........: No.FUN-B90130 11/11/24 By wujie 大陆发票改善
# Modify.........: No.MOD-C40153 12/04/20 By Elise 發票整批開立也排除外銷單

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql		string                      #No.FUN-580092 HCN
DEFINE g_date			LIKE type_file.dat          #FUN-680123 DATE
DEFINE g_oma05			LIKE oma_file.oma05         #FUN-680123 VARCHAR(1)
DEFINE ex_sw   			LIKE type_file.chr1         #FUN-680123 VARCHAR(1)
DEFINE g_oma   			RECORD LIKE oma_file.*
DEFINE g_ogb                    RECORD LIKE ogb_file.*      #TQC-A60111
DEFINE g_oma59,g_oma59x		LIKE oma_file.oma59         #FUN-4C0013
DEFINE
    g_oar   RECORD LIKE oar_file.*,
    g_gec   RECORD LIKE gec_file.*,
    exT	       LIKE type_file.chr1,        #FUN-680123 VARCHAR(1)	
    g_unikey   LIKE type_file.chr1         #FUN-680123 VARCHAR(1) 
DEFINE   g_cnt           LIKE type_file.num10        #FUN-680123 INTEGER   
DEFINE   g_i             LIKE type_file.num5         #FUN-680123 SMALLINT   #count/index for any purpose
DEFINE   g_change_lang   LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)   #是否有做語言切換 No.FUN-570156
DEFINE   g_net           LIKE oox_file.oox10         #TQC-A60111
 
MAIN
   DEFINE ls_date       STRING    #No.FUN-570156 
   DEFINE l_flag        LIKE type_file.chr1         #FUN-680123 VARCHAR(1)   #No.FUN-570156 
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570156 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   #LET g_wc = cl_replace_str(g_wc, "\"", "'")
   LET ls_date  = ARG_VAL(2)             #開立發票日期
   LET g_date   = cl_batch_bg_date_convert(ls_date)
   LET g_oma05  = ARG_VAL(3)             #發票別
   LET ex_sw    = ARG_VAL(4)             #外幣發票匯率賦與方式
   LET g_bgjob = ARG_VAL(5)     #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570156 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0095
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p320()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            BEGIN WORK
            CALL p320_process()
            CALL s_showmsg()           #NO.FUN-710050
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p320_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p320_process()
         CALL s_showmsg()           #NO.FUN-710050
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p320()
   #No.FUN-570156 --start--
#  DEFINE   l_ok,l_fail,l_i   LIKE type_file.num5         #FUN-680123 SMALLINT
#  DEFINE   l_start,l_end     LIKE oma_file.oma10
#  DEFINE   l_oga909          LIKE oga_file.oga909        #三角貿易否
#  DEFINE   l_oga16           LIKE oga_file.oga16         #訂單單號
#  DEFINE   l_oea904          LIKE oea_file.oea904        #流程代碼
#  #add 030625 NO.A083
#  DEFINE   l_oot05           LIKE oot_file.oot05 
#  DEFINE   l_oot05x          LIKE oot_file.oot05x
#  DEFINE   l_flag            VARCHAR(1)
   DEFINE   lc_cmd            LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(500)
 
   OPEN WINDOW p320_w WITH FORM "axr/42f/axrp320"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE
      CLEAR FORM
      LET g_date=TODAY
      LET ex_sw='1'
      CALL cl_opmsg('w')
      LET g_bgjob = "N"        #No.FUN-570156
      MESSAGE  ""
      CONSTRUCT BY NAME g_wc ON oma01,oma02,oma05,oma212  
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION locale          #genero
#           LET g_action_choice = "locale"    #No.FUN-570156
#           CALL cl_show_fld_cont()           #No.FUN-550037 hmf   No.FUN-570156
            LET g_change_lang = TRUE          #No.FUN-570156
            EXIT CONSTRUCT
         ON ACTION exit              #加離開功能genero
              LET INT_FLAG = 1
              EXIT CONSTRUCT
 
         EXIT CONSTRUCT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup') #FUN-980030
      #No.FUN-570156 --start--
#     IF g_action_choice = "locale" THEN  #genero
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         CLOSE WINDOW p320_w  #No.FUN-570156
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
         EXIT PROGRAM         #No.FUN-570156
#        RETURN               #No.FUN-570156
      END IF
 
      #No.FUN-570156 --start--
      IF g_wc = ' 1=1' THEN
         CALL cl_err('','9046',0) 
         CONTINUE WHILE
      END IF
      #No.FUN-570156 ---end---
 
      INPUT BY NAME g_date, g_oma05, ex_sw, g_bgjob WITHOUT DEFAULTS   #No.FUN-570156
 
      AFTER FIELD ex_sw
        IF ex_sw NOT MATCHES "[123]" THEN 
           NEXT FIELD ex_sw
        END IF 
 
      AFTER INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION exit      #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT 
 
      #No.FUN-570156 --start--
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axrp320"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axrp320','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc    CLIPPED,"'",
                         " '",g_date  CLIPPED,"'",
                         " '",g_oma05 CLIPPED,"'",
                         " '",ex_sw   CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axrp320',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p320_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
 
#  LET g_sql="SELECT COUNT(*),SUM(oma59),SUM(oma59x) FROM oma_file",
#            "  WHERE ",g_wc CLIPPED,
#            "    AND oma10 IS NULL AND omavoid='N' "
#  PREPARE p320_prepare0 FROM g_sql
#  DECLARE p320_cs0 CURSOR WITH HOLD FOR p320_prepare0
#  OPEN p320_cs0 
#  FETCH p320_cs0 INTO g_cnt,g_oma59,g_oma59x
#  #add 030625 NO.A083
#  LET g_sql="SELECT SUM(oot05),SUM(oot05x) FROM oot_file,oma_file",
#            "  WHERE ",g_wc CLIPPED,
#            "    AND oma10 IS NULL AND omavoid='N' ",
#            "    AND oot03 = oma01 "
#  PREPARE p320_prepare1 FROM g_sql
#  DECLARE p320_cs1 CURSOR WITH HOLD FOR p320_prepare1
#  OPEN p320_cs1 
#  FETCH p320_cs1 INTO l_oot05,l_oot05x
#  IF cl_null(l_oot05)  THEN
#     LET l_oot05  = 0
#  END IF
#  IF cl_null(l_oot05x) THEN
#     LET l_oot05x = 0
#  END IF
#  LET g_oma59  = g_oma59  - l_oot05
#  LET g_oma59x = g_oma59x - l_oot05x
 
#  DISPLAY BY NAME g_cnt,g_oma59,g_oma59x
#  IF cl_sure(20,20) THEN
#     LET g_sql="SELECT * FROM oma_file WHERE ",g_wc CLIPPED,
#              "  AND oma10 IS NULL AND omavoid='N' "
#     PREPARE p320_prepare FROM g_sql
#     DECLARE p320_cs CURSOR WITH HOLD FOR p320_prepare
#     LET l_start = ''
#     LET l_end = ''
#     LET l_i = 1
#     BEGIN WORK LET g_success='Y'
#     FOREACH p320_cs INTO g_oma.*
#     IF STATUS THEN
#        CALL cl_err('p320(foreach):',STATUS,1) 
#        EXIT FOREACH 
#     END IF
#     IF g_oma.oma00[1,1]='2' THEN 
#        CONTINUE FOREACH  
#     END IF
#      #-------97/08/01 modify判斷ooz20是否須確認後才可開立發票
#     IF g_ooz.ooz20 = 'Y' THEN
#        IF g_oma.omaconf = 'N' THEN
#           CALL cl_err(g_oma.oma01,"axr-916",0)
#           CONTINUE FOREACH
#        END IF
#     END IF
#     #--------------------------------------------
#     LET g_oma.oma09=g_date
#     IF g_oma05 IS NOT NULL THEN
#        LET g_oma.oma05=g_oma05
#     END IF
#     IF g_oma.oma05 IS NULL THEN
#        CONTINUE FOREACH
#     END IF
#     #-----99.01.25 ---------
#              #99.01.25 三角貿易
#     LET l_oga909='N'
#     IF g_oma.oma00='12' THEN
#        SELECT oga16,oga909 INTO l_oga16,l_oga909
#          FROM oga_file
#         WHERE oga01=g_oma.oma16
#        IF SQLCA.SQLCODE <>0 OR l_oga909 IS NULL THEN
#           LET l_oga909='N'
#        END IF
#     END IF
#     IF cl_null(l_oga909) THEN
#        LET l_oga909='N' 
#     END IF
#     IF l_oga909='Y' THEN
#        #讀取流程代碼
#        SELECT oea904 INTO l_oea904
#          FROM oea_file
#         WHERE oea01=l_oga16
#        SELECT * INTO g_oar.*
#          FROM oar_file
#         WHERE oar01=l_oea904
#           AND oar02=g_plant
#        IF SQLCA.SQLCODE <>0 THEN
#           LET g_unikey='N'
#        ELSE
#           LET g_unikey='Y'
#           IF cl_null(g_oar.oar04) THEN
#              LET g_unikey='N'
#           ELSE
#              SELECT * INTO g_gec.*
#                FROM gec_file
#               WHERE gec01=g_oar.oar04
#                 AND gec011='2'
#           END IF   
#        END IF
#     ELSE
#        LET g_unikey='N'
#     END IF 
#       #------------------------------------------ (1) Default GUI NO
#      # CALL s_guiauno(g_oma.oma10,g_oma.oma09,g_oma.oma05,g_oma.oma212)
#         	 RETURNING g_i,g_oma.oma10
#        #99.01.25 for cec三角貿易
#     IF g_unikey='N' THEN
#        CALL s_guiauno(g_oma.oma10,g_oma.oma09,g_oma.oma05,g_oma.oma212)
#        RETURNING g_i,g_oma.oma10
#     ELSE
#        CALL s_guiauno(g_oma.oma10,g_oma.oma09,g_oma.oma05,g_gec.gec05)
#        RETURNING g_i,g_oma.oma10
#     END IF
#     IF g_i THEN
#        LET g_success='N' 
#        EXIT FOREACH 
#     END IF
#       #------------------------------------------ (2) Update max GUI NO
#     # CALL s_guiauno(g_oma.oma10,g_oma.oma09,g_oma.oma05,g_oma.oma212)
#     #	 RETURNING g_i,g_oma.oma10	
#     IF g_unikey='N' THEN
#        CALL s_guiauno(g_oma.oma10,g_oma.oma09,g_oma.oma05,g_oma.oma212)
#        RETURNING g_i,g_oma.oma10
#     ELSE
#        CALL s_guiauno(g_oma.oma10,g_oma.oma09,g_oma.oma05,g_gec.gec05)
#        RETURNING g_i,g_oma.oma10
#     END IF
#     IF g_i THEN
#        LET g_success='N' 
#        EXIT FOREACH 
#     END IF
##----------1999/07/27 modify
#     IF l_i = 1 THEN 
#        LET l_start = g_oma.oma10  
#     END IF
#        #------------------------------------------ Default Ex.rate
#     IF g_oma.oma23!=g_aza.aza17 THEN
#        IF ex_sw = '1' THEN
#           IF g_oma.oma08='1' THEN 
#              LET exT=g_ooz.ooz17 
#           ELSE 
#              LET exT=g_ooz.ooz63 
#           END IF
#           CALL s_curr3(g_oma.oma23,g_oma.oma09,exT) RETURNING g_oma.oma58
#           CALL p320_ex()
#        END IF
#        IF ex_sw = '2' AND (g_oma.oma58=0 OR g_oma.oma58=1) THEN
#           IF g_oma.oma08='1' THEN 
#              LET exT=g_ooz.ooz17 
#           ELSE 
#              LET exT=g_ooz.ooz63 
#           END IF
#           CALL s_curr3(g_oma.oma23,g_oma.oma09,exT) RETURNING g_oma.oma58
#           CALL p320_ex()
#        END IF
#     END IF
#     #------------------------------------------
#      UPDATE oma_file
#         SET oma05=g_oma.oma05, oma09=g_oma.oma09,
#             oma10=g_oma.oma10, oma58=g_oma.oma58
#       WHERE oma01=g_oma.oma01
#     
#       #No.+041 010330 by plum
#       #IF STATUS THEN
#       #   CALL cl_err('upd oma09,10,58:',STATUS,1) 
#     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd oma09,10,58:',SQLCA.SQLCODE,1)
#        LET g_success='N' EXIT FOREACH
#     END IF
#       #No.+041..end
#        #------------------------------------------
#     IF g_unikey='N' THEN
#        CALL s_insome(g_oma.oma01,g_oma.oma21)
#     ELSE
#        CALL s_insome(g_oma.oma01,g_gec.gec01)
#     END IF
#     IF g_success='N' THEN
#        EXIT FOREACH
#     END IF
#     LET l_i = l_i + 1
#     END FOREACH
#     LET l_end = g_oma.oma10
#     MESSAGE 'Start No :',l_start,' End No : ',l_end
#     CALL ui.Interface.refresh() 
#     IF cl_null(l_start) THEN
#        CALL cl_err('','aap-129',1)
#        CALL cl_end2(2) RETURNING l_flag           #批次作業失敗
#        ROLLBACK WORK 
#     ELSE
#        IF g_success='Y' THEN
#           COMMIT WORK 
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE 
#           ROLLBACK WORK 
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#     END IF
#     IF l_flag THEN
#         CONTINUE WHILE
#     ELSE
#         EXIT WHILE
#     END IF
#     #CALL cl_end(10,10)
#  END IF 
   #No.FUN-570156 ---end---   
 END WHILE 
END FUNCTION
 
#No.FUN-570156 --start--
FUNCTION p320_process()
   DEFINE   l_ok,l_fail,l_i   LIKE type_file.num5         #FUN-680123 SMALLINT
   DEFINE   l_start,l_end     LIKE oma_file.oma10
   DEFINE   l_oga909          LIKE oga_file.oga909        #三角貿易否
   DEFINE   l_oga16           LIKE oga_file.oga16         #訂單單號
   DEFINE   l_oea904          LIKE oea_file.oea904        #流程代碼
   #add 030625 NO.A083
   DEFINE   l_oot05           LIKE oot_file.oot05 
   DEFINE   l_oot05x          LIKE oot_file.oot05x
   DEFINE   l_flag            LIKE type_file.chr1         #FUN-680123 VARCHAR(1)
 
   LET g_sql="SELECT COUNT(*),SUM(oma59),SUM(oma59x) FROM oma_file",
             "  WHERE ",g_wc CLIPPED,
             "    AND oma10 IS NULL AND omavoid='N' "
   PREPARE p320_prepare0 FROM g_sql
   DECLARE p320_cs0 CURSOR WITH HOLD FOR p320_prepare0
   OPEN p320_cs0 
   FETCH p320_cs0 INTO g_cnt,g_oma59,g_oma59x
   #add 030625 NO.A083
   LET g_sql="SELECT SUM(oot05),SUM(oot05x) FROM oot_file,oma_file",
             "  WHERE ",g_wc CLIPPED,
             "    AND oma10 IS NULL AND omavoid='N' ",
             "    AND oot03 = oma01 "
   PREPARE p320_prepare1 FROM g_sql
   DECLARE p320_cs1 CURSOR WITH HOLD FOR p320_prepare1
   OPEN p320_cs1 
   FETCH p320_cs1 INTO l_oot05,l_oot05x
   IF cl_null(l_oot05)  THEN
      LET l_oot05  = 0
   END IF
   IF cl_null(l_oot05x) THEN
      LET l_oot05x = 0
   END IF
   LET g_oma59  = g_oma59  - l_oot05
   LET g_oma59x = g_oma59x - l_oot05x
 
   DISPLAY BY NAME g_cnt,g_oma59,g_oma59x
   LET g_sql="SELECT * FROM oma_file WHERE ",g_wc CLIPPED,
            "  AND oma10 IS NULL AND omavoid='N' "
   PREPARE p320_prepare FROM g_sql
   DECLARE p320_cs CURSOR WITH HOLD FOR p320_prepare
   LET l_start = ''
   LET l_end = ''
   LET l_i = 1
#  BEGIN WORK LET g_success='Y'  #No.TQC-6C0147 mark
   LET g_success='Y'             #No.TQC-6C0147
   CALL s_showmsg_init()         #NO.FUN-710050
   FOREACH p320_cs INTO g_oma.*
   IF STATUS THEN
#     CALL cl_err('p320(foreach):',STATUS,1)                  #NO.FUN-710050
      LET g_success = 'N'    #No.FUN-8A0086 
      CALL s_errmsg('','','p320(foreach):',STATUS,1)          #NO.FUN-710050 
      EXIT FOREACH 
    END IF    #No.FUN-8A0086
#NO.FUN-710050-----begin add
    IF g_success='N' THEN                                                                                                          
       LET g_totsuccess='N'                                                                                                       
       LET g_success="Y"                                                                                                          
    END IF                    
#NO.FUN-710050-----end
 
#  END IF      #No.FUN-8A0086

  #MOD-C40153---str---
   IF g_ooz.ooz64 = 'N' AND g_oma.oma08 = '2' AND g_aza.aza26 = '0' THEN
      CONTINUE FOREACH
   END IF
  #MOD-C40153---end---
 
   #-----MOD-810070---------
   SELECT azi04 INTO t_azi04 FROM azi_file
     WHERE azi01 = g_oma.oma23
   #-----END MOD-810070-----
 
   IF g_oma.oma00[1,1]='2' THEN 
      CONTINUE FOREACH  
   END IF
    #-------97/08/01 modify判斷ooz20是否須確認後才可開立發票
   IF g_ooz.ooz20 = 'Y' THEN
      IF g_oma.omaconf = 'N' THEN
#        CALL cl_err(g_oma.oma01,"axr-916",0)               #NO.FUN-710050
         CALL s_errmsg('','',g_oma.oma01,"axr-916",0)       #NO.FUN-710050
         CONTINUE FOREACH
      END IF
   END IF
   #--------------------------------------------
   LET g_oma.oma09=g_date
   IF g_oma05 IS NOT NULL THEN
      LET g_oma.oma05=g_oma05
   END IF
   IF g_oma.oma05 IS NULL THEN
      CONTINUE FOREACH
   END IF
   #-----99.01.25 ---------
            #99.01.25 三角貿易
   LET l_oga909='N'
   IF g_oma.oma00='12' THEN
     #FUN-A60056--mod--str--
     #SELECT oga16,oga909 INTO l_oga16,l_oga909
     #  FROM oga_file
     # WHERE oga01=g_oma.oma16
      LET g_sql = "SELECT oga16,oga909 ",
                  "  FROM ",cl_get_target_table(g_oma.oma66,'oga_file'),
                  " WHERE oga01='",g_oma.oma16,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
      PREPARE sel_oga16 FROM g_sql
      EXECUTE sel_oga16 INTO l_oga16,l_oga909
     #FUN-A60056--mod--end
      IF SQLCA.SQLCODE <>0 OR l_oga909 IS NULL THEN
         LET l_oga909='N'
      END IF
   END IF
   IF cl_null(l_oga909) THEN
      LET l_oga909='N' 
   END IF
   IF l_oga909='Y' THEN
      #讀取流程代碼
     #FUN-A60056--mod--str--
     #SELECT oea904 INTO l_oea904
     #  FROM oea_file
     # WHERE oea01=l_oga16
      LET g_sql = "SELECT oea904 FROM ",cl_get_target_table(g_oma.oma66,'oea_file'),
                  " WHERE oea01='",l_oga16,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
      PREPARE sel_oea904 FROM g_sql
      EXECUTE sel_oea904 INTO l_oea904
     #FUN-A60056--mod--end
      SELECT * INTO g_oar.*
        FROM oar_file
       WHERE oar01=l_oea904
         AND oar02=g_plant
      IF SQLCA.SQLCODE <>0 THEN
         LET g_unikey='N'
      ELSE
         LET g_unikey='Y'
         IF cl_null(g_oar.oar04) THEN
            LET g_unikey='N'
         ELSE
            SELECT * INTO g_gec.*
              FROM gec_file
             WHERE gec01=g_oar.oar04
               AND gec011='2'
         END IF   
      END IF
   ELSE
      LET g_unikey='N'
   END IF 
     #------------------------------------------ (1) Default GUI NO
    # CALL s_guiauno(g_oma.oma10,g_oma.oma09,g_oma.oma05,g_oma.oma212)
#      	 RETURNING g_i,g_oma.oma10
      #99.01.25 for cec三角貿易
   IF g_unikey='N' THEN
      CALL s_guiauno(g_oma.oma10,g_oma.oma75,g_oma.oma09,g_oma.oma05,g_oma.oma212)   #No.FUN-B90130 add oma75   
      RETURNING g_i,g_oma.oma10,g_oma.oma75   #No.FUN-B90130  
   ELSE
      CALL s_guiauno(g_oma.oma10,g_oma.oma75,g_oma.oma09,g_oma.oma05,g_gec.gec05)   #No.FUN-B90130 add oma75 
      RETURNING g_i,g_oma.oma10,g_oma.oma75   #No.FUN-B90130 
   END IF
   IF g_i THEN
      LET g_success='N' 
      EXIT FOREACH            
   END IF
     #------------------------------------------ (2) Update max GUI NO
   # CALL s_guiauno(g_oma.oma10,g_oma.oma09,g_oma.oma05,g_oma.oma212)
   #	 RETURNING g_i,g_oma.oma10	
   IF g_unikey='N' THEN
      CALL s_guiauno(g_oma.oma10,g_oma.oma75,g_oma.oma09,g_oma.oma05,g_oma.oma212)  #No.FUN-B90130 add oma75 
      RETURNING g_i,g_oma.oma10,g_oma.oma75   #No.FUN-B90130   
   ELSE
      CALL s_guiauno(g_oma.oma10,g_oma.oma75,g_oma.oma09,g_oma.oma05,g_gec.gec05)   #No.FUN-B90130 add oma75 
      RETURNING g_i,g_oma.oma10,g_oma.oma75   #No.FUN-B90130   
   END IF
   IF g_i THEN
      LET g_success='N' 
      EXIT FOREACH 
   END IF
##-------1999/07/27 modify
   IF l_i = 1 THEN 
      LET l_start = g_oma.oma10  
   END IF
      #------------------------------------------ Default Ex.rate
   IF g_oma.oma23!=g_aza.aza17 THEN
      IF ex_sw = '1' THEN
         IF g_oma.oma08='1' THEN 
            LET exT=g_ooz.ooz17 
         ELSE 
            LET exT=g_ooz.ooz63 
         END IF
         CALL s_curr3(g_oma.oma23,g_oma.oma09,exT) RETURNING g_oma.oma58
         CALL p320_ex()
      END IF
      IF ex_sw = '2' AND (g_oma.oma58=0 OR g_oma.oma58=1) THEN
         IF g_oma.oma08='1' THEN 
            LET exT=g_ooz.ooz17 
         ELSE 
            LET exT=g_ooz.ooz63 
         END IF
         CALL s_curr3(g_oma.oma23,g_oma.oma09,exT) RETURNING g_oma.oma58
         CALL p320_ex()
      END IF
   END IF
   #------------------------------------------
    UPDATE oma_file
       SET oma05=g_oma.oma05, oma09=g_oma.oma09,
           oma10=g_oma.oma10, oma58=g_oma.oma58,oma75 = g_oma.oma75   #No.FUN-B90130     
     WHERE oma01=g_oma.oma01
   
     #No.+041 010330 by plum
     #IF STATUS THEN
     #   CALL cl_err('upd oma09,10,58:',STATUS,1) 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd oma09,10,58:',SQLCA.SQLCODE,1)   #No.FUN-660116
#     CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.SQLCODE,"","upd oma09,10,58:",1)    #No.FUN-660116 #NO.FUN-710050
      CALL s_errmsg('oma01',g_oma.oma01,'upd oma09,10,58:',SQLCA.SQLCODE,1)                  #NO.FUN-710050
      LET g_success='N' EXIT FOREACH
   #No.FUN-680022--begin-- add
   ELSE
      UPDATE omc_file SET omc12=g_oma.oma10 WHERE omc01=g_oma.oma01
      IF SQLCA.sqlcode THEN
#        CALL cl_err3("upd","omc_file",g_oma.oma01,"",SQLCA.sqlcode,"","update omc12",1)    #NO.FUN-710050
         CALL s_errmsg('omc01',g_oma.oma01,"update omc12",SQLCA.sqlcode,1)                  #NO.FUN-710050 
         LET g_success='N' EXIT FOREACH
      END IF   
   #No.FUN-680022--end-- add
   END IF
     #No.+041..end
      #------------------------------------------
   IF g_unikey='N' THEN
   #  CALL s_insome(g_oma.oma01,g_oma.oma21)    #No.FUN-9C0014
      CALL s_insome(g_oma.oma01,g_oma.oma21,'') #No.FUN-9C0014
   ELSE
   #  CALL s_insome(g_oma.oma01,g_gec.gec01)    #No.FUN-9C0014
      CALL s_insome(g_oma.oma01,g_gec.gec01,'') #No.FUN-9C0014
   END IF
   IF g_success='N' THEN
     EXIT FOREACH
   END IF
   LET l_i = l_i + 1
   END FOREACH
#NO.FUN-710050----begin 
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
#NO.FUN-710050----end
 
   LET l_end = g_oma.oma10
   IF g_bgjob = "N" THEN   #No.FUN-570156
      MESSAGE 'Start No :',l_start,' End No : ',l_end
      CALL ui.Interface.refresh() 
   END IF                  #No.FUN-570156
   IF cl_null(l_start) THEN
      CALL cl_err('','aap-129',1)
      #No.FUN-570156 --start--
      LET g_success = "N"
      RETURN
#     CALL cl_end2(2) RETURNING l_flag           #批次作業失敗
#     ROLLBACK WORK 
#  ELSE
#     IF g_success='Y' THEN
#        COMMIT WORK 
#        CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#     ELSE 
#        ROLLBACK WORK 
#        CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#     END IF
      #No.FUN-570156 ---end---
   END IF
   #No.FUN-570156 --start--
#  IF l_flag THEN
#      CONTINUE WHILE
#  ELSE
#      EXIT WHILE
#  END IF
   #No.FUN-570156 ---end---
   #CALL cl_end(10,10)
END FUNCTION
#No.FUN-570156 --end--
 
FUNCTION p320_ex()
   DEFINE x	RECORD LIKE omb_file.*
   DEFINE l_oga909 LIKE oga_file.oga909    #是否為三角貿易
   DEFINE l_oeaa08 LIKE oeaa_file.oeaa08  #CHI-B90025 add
   DEFINE l_oea01  LIKE oea_file.oea01    #CHI-B90025 add
    
   #99.01.25 for cec 若為三角貿易出貨單則發票單價不重新計算
   LET l_oga909='N' 
   IF g_oma.oma00='12' THEN
    #FUN-A60056--mod--str--
    #SELECT oga909 INTO l_oga909
    #  FROM oga_file
    # WHERE oga01=g_oma.oma16 
     LET g_sql = "SELECT oga909 FROM ",cl_get_target_table(g_oma.oma66,'oga_file'),
                 " WHERE oga01='",g_oma.oma16,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
     PREPARE sel_oga909 FROM g_sql
     EXECUTE sel_oga909 INTO l_oga909
    #FUN-A60056--mod--end
     IF SQLCA.SQLCODE <>0 OR l_oga909 IS NULL THEN
        LET l_oga909='N'
     END IF
   END IF
   IF cl_null(l_oga909) THEN LET l_oga909='N' END IF
   IF l_oga909='N' THEN
      DECLARE t300_oma58_c2 CURSOR FOR SELECT * FROM omb_file WHERE omb01=g_oma.oma01

      FOREACH t300_oma58_c2 INTO x.*
         IF STATUS THEN EXIT FOREACH END IF
         LET x.omb17 =x.omb13 *g_oma.oma58
         LET x.omb18 =x.omb14 *g_oma.oma58
         LET x.omb18t=x.omb14t*g_oma.oma58
         CALL cl_digcut(x.omb18,g_azi04) RETURNING x.omb18   #MOD-810070
         CALL cl_digcut(x.omb18t,g_azi04)RETURNING x.omb18t   #MOD-810070
         UPDATE omb_file SET *=x.*
          WHERE omb01=g_oma.oma01 AND omb03=x.omb03
        #-TQC-A60111-add-
         LET g_sql = "SELECT * ",
                     "  FROM ",cl_get_target_table(g_oma.oma66,'ogb_file'),
                     " WHERE ogb01 = '",x.omb31,"'",
                     "   AND ogb03 = '",x.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
         PREPARE sel_ogb FROM g_sql
         EXECUTE sel_ogb INTO g_ogb.* 
#-------------------------------No.CHI-B90025----------------------------------start
         IF g_oma.oma00='11' THEN
            SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
             WHERE oeaa01 = g_oma.oma16
               AND oeaa02 = '1'
               AND oeaa03 = g_oma.oma165
               AND oeaa01 = oea01
         END IF

         IF g_oma.oma00='13' THEN
            SELECT oeaa08,oea01 INTO l_oeaa08,l_oea01 FROM oeaa_file,oea_file
             WHERE oeaa01 = g_oma.oma16
               AND oeaa02 = '2'
               AND oeaa03 = g_oma.oma165
               AND oeaa01 = oea01
         END IF
         CALL saxrp310_bu(g_oma.*,g_ogb.*,l_oea01,l_oeaa08) RETURNING g_oma.*
        #CALL p320_bu()
#-------------------------------No.CHI-B90025----------------------------------end
        #-TQC-A60111-end-
      END FOREACH
     #CALL t300_bu()            #TQC-A60111 mark
   END IF
END FUNCTION
 
#FUNCTION t300_bu()     # 注意: 此段_bu()必須與 s_g_ar.4gl 的_bu()完全相同     #TQC-A60111 mark
#------------------------------------------No.CHI-B90025----------------------------------start
#FUNCTION p320_bu()      # 注意: 此段_bu()必須與 s_g_ar.4gl 的_bu()完全相同     #TQC-A60111
#  DEFINE l_oea61     LIKE oea_file.oea61    #No:FUN-A50103
#  DEFINE l_oea1008   LIKE oea_file.oea1008  #No:FUN-A50103
#  DEFINE l_oea261    LIKE oea_file.oea261   #No:FUN-A50103
#  DEFINE l_oea262    LIKE oea_file.oea262   #No:FUN-A50103
#  DEFINE l_oea263    LIKE oea_file.oea263   #No:FUN-A50103
#  DEFINE l_oeaa08    LIKE oeaa_file.oeaa08  #No:FUN-A50103
# #-TQC-A60111-add-
#  DEFINE l_oma54     LIKE oma_file.oma54
#  DEFINE l_oma54t    LIKE oma_file.oma54t
#  DEFINE l_oma56     LIKE oma_file.oma56
#  DEFINE l_oma56t    LIKE oma_file.oma56t
#  DEFINE l_sumogb14  LIKE ogb_file.ogb14   #出貨總金額(未稅)
#  DEFINE l_sumogb14t LIKE ogb_file.ogb14t  #出貨總金額(含稅)
#  DEFINE l_11_oma54  LIKE oma_file.oma54   #訂金金額(未稅)
#  DEFINE l_11_oma54t LIKE oma_file.oma54t  #訂金金額(含稅)
#  DEFINE l_12_oma52  LIKE oma_file.oma52   #分批訂金金額(未稅)
#  DEFINE l_12_oma54  LIKE oma_file.oma54   #分批出貨金額(未稅)
#  DEFINE l_12_oma54t LIKE oma_file.oma54t  #分批出貨金額(含稅)
#  DEFINE l_13_oma54  LIKE oma_file.oma54   #尾款金額(未稅)
#  DEFINE l_13_oma54t LIKE oma_file.oma54t  #尾款金額(含稅)
#  DEFINE l_oeb917    LIKE oeb_file.oeb917
#  DEFINE l_ogb917    LIKE ogb_file.ogb917
#  DEFINE l_sumogb917 LIKE ogb_file.ogb917  #MOD-B50230     #出貨總數量
#  DEFINE l_flag2     LIKE type_file.chr1
#  DEFINE l_sumomb16  LIKE omb_file.omb16   #出貨總金額(未稅)
#  DEFINE l_sumomb16t LIKE omb_file.omb16t  #出貨總金額(含稅)
#  DEFINE l_11_oma56  LIKE oma_file.oma56   #訂金金額(未稅)
#  DEFINE l_11_oma56t LIKE oma_file.oma56t  #訂金金額(含稅)
#  DEFINE l_12_oma53  LIKE oma_file.oma53   #分批訂金金額(未稅)
#  DEFINE l_12_oma56  LIKE oma_file.oma56   #分批出貨金額(未稅)
#  DEFINE l_12_oma56t LIKE oma_file.oma56t  #分批出貨金額(含稅)
#  DEFINE l_13_oma56  LIKE oma_file.oma56   #尾款金額(未稅)
#  DEFINE l_13_oma56t LIKE oma_file.oma56t  #尾款金額(含稅)
#  DEFINE l_sumomb18  LIKE omb_file.omb18   #發票出貨總金額(未稅)
#  DEFINE l_sumomb18t LIKE omb_file.omb18t  #發票出貨總金額(含稅)
#  DEFINE l_11_oma59  LIKE oma_file.oma59   #發票訂金金額(未稅)
#  DEFINE l_11_oma59t LIKE oma_file.oma59t  #發票訂金金額(含稅)
#  DEFINE l_12_oma59  LIKE oma_file.oma59   #發票分批出貨金額(未稅)
#  DEFINE l_12_oma59t LIKE oma_file.oma59t  #發票分批出貨金額(含稅)
#  DEFINE l_13_oma59  LIKE oma_file.oma59   #發票尾款金額(未稅)
#  DEFINE l_13_oma59t LIKE oma_file.oma59t  #發票尾款金額(含稅)
#  DEFINE l_cnt       LIKE type_file.num5
# #-TQC-A60111-end-

#  #-----No:FUN-A50103-----
#  IF g_oma.oma00='11' THEN
#     SELECT oeaa08 INTO l_oeaa08 FROM oeaa_file
#      WHERE oeaa01 = g_oma.oma16
#        AND oeaa02 = '1'
#        AND oeaa03 = g_oma.oma165
#  END IF

#  IF g_oma.oma00='13' THEN
#     SELECT oeaa08 INTO l_oeaa08 FROM oeaa_file
#      WHERE oeaa01 = g_oma.oma16
#        AND oeaa02 = '2'
#        AND oeaa03 = g_oma.oma165
#  END IF

#  IF g_oma.oma00 = '12' THEN
#     SELECT oea61,oea1008,oea261,oea262,oea263
#       INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
#      FROM oea_file
#     WHERE oea01 = g_ogb.ogb31
#  END IF
#  #-----No:FUN-A50103 END-----

#  #-----No:CHI-A70015-----
#  IF STATUS THEN     #找不到訂單，表無訂單出貨
#     LET l_oea61 = 100
#     LET l_oea1008 = 100
#     LET l_oea261 = 0
#     LET l_oea262 = 100
#     LET l_oea263 = 0
#  END IF
#  #-----No:CHI-A70015 END-----

#  LET g_oma.oma50 = 0
#  LET g_oma.oma50t= 0
#  LET l_flag2 = 'N'                         #TQC-A60111

#  SELECT SUM(omb14),SUM(omb14t) INTO g_oma.oma50,g_oma.oma50t
#    FROM omb_file 
#   WHERE omb01=g_oma.oma01

#  IF g_oma.oma50 IS NULL THEN LET g_oma.oma50=0 END IF

# #-TQC-A60111-mark-
# #IF g_oma.oma213='N' THEN
# #   LET g_oma.oma50t=g_oma.oma50 *(1+g_oma.oma211/100)
# #ELSE
# #   LET g_oma.oma50 =g_oma.oma50t*100/(100+g_oma.oma211)
# #END IF
# #-TQC-A60111-end-

#  #------------------------------------------------------------
#  LET g_oma.oma52 = 0
# #LET g_oma.oma53 = 0             #TQC-A60111 mark

#  CASE
#       WHEN g_oma.oma00 = '11'
#            #-----No:FUN-A50103-----
#            IF g_oma.oma213 = 'Y' THEN
#               LET g_oma.oma54t = l_oeaa08
#               LET g_oma.oma54  = g_oma.oma54t/(1+ g_oma.oma211/100)
#            ELSE
#               LET g_oma.oma54  = l_oeaa08
#               LET g_oma.oma54t = g_oma.oma54*(1+ g_oma.oma211/100)
#            END IF
#           #LET g_oma.oma54 = g_oma.oma50 *g_oma.oma161/100
#           #LET g_oma.oma54t= g_oma.oma50t*g_oma.oma161/100
#            #-----No:FUN-A50103 END-----
#       WHEN g_oma.oma00 = '12'
#          #-TQC-B60089-mark-
#          ##-TQC-A60111-add-
#          # LET l_cnt = 0
#          # LET g_sql = "SELECT count(*) ",
#          #             "  FROM ",cl_get_target_table(g_oma.oma66,'oeb_file'),
#          #             " WHERE oeb01 = '",g_ogb.ogb31,"'",
#          #             "   AND oeb03 = '",g_ogb.ogb32,"'"
#          # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#          # CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#          # PREPARE sel_oeb FROM g_sql
#          # EXECUTE sel_oeb INTO l_cnt 
#          #-TQC-B60089-end-
#           #若出貨數量大於訂單數量即表示超交
#           #LET g_sql = "SELECT oeb917 ",         #MOD-B50230 mark
#            LET g_sql = "SELECT SUM(oeb917) ",    #MOD-B50230
#                        "  FROM ",cl_get_target_table(g_oma.oma66,'oeb_file'),
#                        " WHERE oeb01 = '",g_ogb.ogb31,"'"
#                       #"   AND oeb03 = '",g_ogb.ogb32,"'"     #MOD-B50230 mark
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#            CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#            PREPARE sel_oeb917 FROM g_sql
#            EXECUTE sel_oeb917 INTO l_oeb917 
#            IF l_oeb917  IS NULL THEN LET l_oeb917 = 0 END IF
#           #抓取非此張出貨單的其他同訂單
#            LET g_sql = "SELECT SUM(ogb917) ",
#                        "  FROM ",cl_get_target_table(g_oma.oma66,'ogb_file'),",",
#                                  cl_get_target_table(g_oma.oma66,'oga_file'),
#                        " WHERE ogb01 <> '",g_ogb.ogb01,"'",
#                        "   AND ogb31 = '",g_ogb.ogb31,"'",
#                       #"   AND ogb32 = '",g_ogb.ogb32,"'",      #MOD-B50230 mark
#                        "   AND (oga10 IS NOT NULL AND oga10 <> ' ' ) AND oga01 = ogb01 ",
#                       #"   AND oga09 IN ('2','3','4','8','A')"                       #MOD-AB0101  #MOD-B50216 mark 
#                        "   AND oga01 = ogb01 ",                                                   #MOD-B50216  
#                        "   AND ((oga09 = '2' AND oga65 = 'N') OR (oga09 IN ('3','4','8','A'))) "  #MOD-B50216
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#            CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#            PREPARE sel_ogb917 FROM g_sql
#            EXECUTE sel_ogb917 INTO l_ogb917 
#            IF l_ogb917  IS NULL THEN LET l_ogb917 = 0 END IF
#           #-MOD-B50230-add-
#           #抓取此張出貨單的總數量
#            LET l_sumogb917 = 0
#            LET g_sql = "SELECT SUM(ogb917)",
#                        "  FROM ",cl_get_target_table(g_oma.oma66,'oga_file'),",",        
#                                  cl_get_target_table(g_oma.oma66,'ogb_file'),           
#                        " WHERE ogb01 = '",g_ogb.ogb01,"' AND ogb31 = '",g_ogb.ogb31,"'",
#                        "   AND oga01 = ogb01 ",                                                   
#                        "   AND ((oga09 = '2' AND oga65 = 'N') OR (oga09 IN ('3','4','8','A'))) " 
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#            PREPARE sel_ogb_pre08 FROM g_sql
#            EXECUTE sel_ogb_pre08 INTO l_sumogb917  
#            IF l_sumogb917  IS NULL THEN LET l_sumogb917 = 0 END IF
#           #抓取不是本張出貨單的其他訂金應收之訂金金額
#            LET l_12_oma52 = 0
#            LET g_sql = " SELECT SUM(oma52) ",
#                        " FROM oma_file ",
#                        " WHERE oma01 IN (SELECT oma01 FROM oma_file,",cl_get_target_table(g_plant_new,'ogb_file'),  
#                        " WHERE oma16 = ogb01 ",
#                        "   AND oma16 <> '",g_ogb.ogb01,"'",
#                        "   AND (oma00 = '12' OR oma00 = '19')",  
#                        "   AND omavoid = 'N' ", 
#                        "   AND ogb31 = '",g_ogb.ogb31,"' AND omaconf = 'N')"
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#            PREPARE sel_ogb_pre09 FROM g_sql
#            EXECUTE sel_ogb_pre09 INTO l_12_oma52
#            IF l_12_oma52  IS NULL THEN LET l_12_oma52 = 0 END IF   
#           #-MOD-B50230-end-
#          #-TQC-B60089-mark-
#          ##IF l_oeb917 <= g_ogb.ogb917+l_ogb917 AND l_cnt > 0 THEN     #MOD-B50230 mark
#          # IF l_oeb917 < l_sumogb917+l_ogb917 AND l_cnt > 0 THEN       #MOD-B50230
#          #    LET l_flag2 = 'Y'
#          #   #此訂單在出貨單的金額 
#          #    LET g_sql = "SELECT SUM(ogb14),SUM(ogb14t) ",
#          #                "  FROM ",cl_get_target_table(g_oma.oma66,'oga_file'),",", #MOD-AB0101
#          #                          cl_get_target_table(g_oma.oma66,'ogb_file'),",", #MOD-AB0101 
#          #                "         oma_file,omb_file ",                             #MOD-B50216
#          #                " WHERE ogb31 = '",g_ogb.ogb31,"'",
#          #               #"   AND ogb32 = '",g_ogb.ogb32,"'",                       #MOD-B10012 #MOD-B50230 mark 
#          #                "   AND oma01 = omb01 ",                                   #MOD-B50216
#          #                "   AND omavoid = 'N' ",                                   #MOD-B50216 
#          #                "   AND omb31 = ogb01 ",                                   #MOD-B50216 
#          #                "   AND omb32 = ogb03 ",                                   #MOD-B50216
#          #               #"   AND oga01 = ogb01 AND oga09 IN ('2','3','4','8','A')"  #MOD-AB0101     #MOD-B50216 mark 
#          #                "   AND oga01 = ogb01 ",                                                   #MOD-B50216  
#          #                "   AND ((oga09 = '2' AND oga65 = 'N') OR (oga09 IN ('3','4','8','A'))) "  #MOD-B50216
#          #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#          #    CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#          #    PREPARE sel_ogb14 FROM g_sql
#          #    EXECUTE sel_ogb14 INTO l_sumogb14,l_sumogb14t 
#          #    IF l_sumogb14  IS NULL THEN LET l_sumogb14 = 0 END IF
#          #    IF l_sumogb14t IS NULL THEN LET l_sumogb14t = 0 END IF
#          #    #-----No:FUN-A50103-----
#          #    IF g_oma.oma213 = 'Y' THEN
#          #      ##-----No:CHI-A70015-----
#          #      #SELECT oea263 INTO l_13_oma54t
#          #      #  FROM oea_file
#          #      # WHERE oea01 = g_ogb.ogb31
#          #       LET l_13_oma54t = l_oea263
#          #       #-----No:CHI-A70015 END-----
#          #       LET l_13_oma54  = l_13_oma54t/(1+ g_oma.oma211/100)
#          #       CALL cl_digcut(l_13_oma54,t_azi04) RETURNING l_13_oma54
#          #    ELSE
#          #      ##-----No:CHI-A70015-----
#          #      #SELECT oea263 INTO l_13_oma54
#          #      #  FROM oea_file
#          #      # WHERE oea01 = g_ogb.ogb31
#          #       LET l_13_oma54 = l_oea263
#          #       #-----No:CHI-A70015 END-----
#          #       LET l_13_oma54t = l_13_oma54 *(1+ g_oma.oma211/100)
#          #       CALL cl_digcut(l_13_oma54t,t_azi04) RETURNING l_13_oma54t
#          #    END IF
#          #   #SELECT oma50,oma50t,oma54,oma54t
#          #   #  INTO l_13_oma54,l_13_oma54t,l_11_oma54,l_11_oma54t
#          #   #  FROM oma_file
#          #   # WHERE oma16 = g_ogb.ogb31 AND oma00 = '11'
#          #    IF l_11_oma54  IS NULL THEN LET l_11_oma54 = 0 END IF   
#          #    IF l_11_oma54t IS NULL THEN LET l_11_oma54t = 0 END IF 
#          #    IF l_13_oma54  IS NULL THEN LET l_13_oma54 = 0 END IF
#          #    IF l_13_oma54t IS NULL THEN LET l_13_oma54t = 0 END IF
#       
#          #   #LET l_13_oma54 = l_13_oma54  * g_oma.oma163/100
#          #   #LET l_13_oma54t= l_13_oma54t * g_oma.oma163/100
#          #   #CALL cl_digcut(l_13_oma54,t_azi04)  RETURNING l_13_oma54
#          #   #CALL cl_digcut(l_13_oma54t,t_azi04) RETURNING l_13_oma54t
#          #   ##-----No:FUN-A50103 END-----
#       
#          #   #抓取不是本張出貨單的其他出貨應收之未稅與含稅金額
#          #    LET g_sql = " SELECT SUM(oma54),SUM(oma54t) ",    #MOD-B50230 remove SUM(oma52) 
#          #                "  FROM oma_file ",
#          #                " WHERE oma01 IN ( SELECT oma01 FROM oma_file,",
#          #                                          cl_get_target_table(g_oma.oma66,'ogb_file'),
#          #                " WHERE oma16 = ogb01 AND oma16 <> '",g_ogb.ogb01,"'",
#          #                "   AND oma00 = '12' AND omavoid = 'N' AND ogb31 = '",g_ogb.ogb31,"')"  #MOD-B10012 mark #MOD-B50230 remark
#          #               #"   AND oma00 = '12' AND omavoid = 'N' AND ogb31 = '",g_ogb.ogb31,"')", #MOD-B10012      #MOD-B50230
#          #               #"   AND ogb32 = '",g_ogb.ogb32,"')"    #MOD-B50230 mark
#          #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#          #    CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#          #    PREPARE sel_oma52 FROM g_sql
#          #    EXECUTE sel_oma52 INTO l_12_oma54,l_12_oma54t #MOD-B50230 remove SUM(oma52) 
#          #   #IF l_12_oma52  IS NULL THEN LET l_12_oma52 = 0 END IF    #MOD-B50230 mark 
#          #    IF l_12_oma54  IS NULL THEN LET l_12_oma54 = 0 END IF
#          #    IF l_12_oma54t IS NULL THEN LET l_12_oma54t = 0 END IF
#       
#          #    LET g_oma.oma54 = l_sumogb14 - l_11_oma54 - l_12_oma54 - l_13_oma54
#          #    LET g_oma.oma54t= l_sumogb14t - l_11_oma54t - l_12_oma54t - l_13_oma54t
#          #    LET g_oma.oma52 = l_11_oma54 - l_12_oma52 
#          # ELSE
#          #    #-----No:FUN-A50103-----
#          #   ##-----No:CHI-A70015-----
#          #   #SELECT oea61,oea1008,oea262
#          #   #  INTO l_oea61,l_oea1008,l_oea262
#          #   #  FROM oea_file
#          #   # WHERE oea01 = g_ogb.ogb31
#          #   ##-----No:CHI-A70015 END-----
#          #    IF g_oma.oma213 = 'Y' THEN
#          #       LET g_oma.oma54 = g_oma.oma50 * l_oea262 / l_oea1008
#          #       LET g_oma.oma54t= g_oma.oma50t* l_oea262 / l_oea1008
#          #       LET g_oma.oma52 = g_oma.oma50 * l_oea261 / l_oea1008  
#          #    ELSE
#          #       LET g_oma.oma54 = g_oma.oma50 * l_oea262 / l_oea61
#          #       LET g_oma.oma54t= g_oma.oma50t* l_oea262 / l_oea61
#          #       LET g_oma.oma52 = g_oma.oma50 * l_oea261 / l_oea61  
#          #    END IF
#          #   ##-----No:FUN-A50103 END-----
#          # END IF
#           #-TQC-B60089-add-
#            LET g_oma.oma52 = g_oma.oma50 *g_oma.oma161/100
#            LET l_13_oma54  = g_oma.oma50 *g_oma.oma163/100
#            LET l_13_oma54t = g_oma.oma50t *g_oma.oma163/100
#            CALL cl_digcut(l_13_oma54,t_azi04) RETURNING l_13_oma54 
#            CALL cl_digcut(l_13_oma54t,t_azi04) RETURNING l_13_oma54t 
#           #-TQC-B60089-end-
#           #判斷變更後金額是否超出原待抵金額,
#           #若是的話,oma52=原待抵金額,oma54=變更後金額-原待抵金額
#            IF NOT cl_null(g_oma.oma19) THEN    #待抵帳款單號不為空
#               LET l_oma54=0  LET l_oma54t=0
#               SELECT SUM(oma54t-oma55),SUM(oma54t) INTO l_oma54,l_oma54t    #No:FUN-A50103
#                 FROM oma_file
#                WHERE oma16=g_oma.oma19     #No:FUN-A50103
#              #IF l_oma54 < g_oma.oma52 THEN   #MOD-B50230 mark
#               IF l_oma54 < g_oma.oma52 OR l_oeb917 <= l_sumogb917+l_ogb917 THEN  #MOD-B50230
#                 #LET g_oma.oma52 = l_oma54                 #原幣訂金      #MOD-B50230 mark
#                  LET g_oma.oma52 = l_oma54 - l_12_oma52    #原幣訂金      #MOD-B50230
#               END IF
#            ELSE                     #TQC-B60089 
#              LET g_oma.oma52 = 0    #TQC-B60089
#            END IF
#            CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52
#            LET g_oma.oma54 = g_oma.oma50 - g_oma.oma52 - l_13_oma54    #TQC-B60089
#            LET g_oma.oma54t= g_oma.oma50t - g_oma.oma52 - l_13_oma54t  #TQC-B60089
#           #-TQC-A60111-end-
#       WHEN g_oma.oma00 = '13'
#           #-----No:FUN-A50103-----
#            IF g_oma.oma213 = 'Y' THEN
#               LET g_oma.oma54t = l_oeaa08
#               LET g_oma.oma54  = g_oma.oma54t/(1+ g_oma.oma211/100)
#            ELSE
#               LET g_oma.oma54  = l_oeaa08
#               LET g_oma.oma54t = g_oma.oma54*(1+ g_oma.oma211/100)
#            END IF
#            IF l_oea262=0 AND l_oea263 >0 AND NOT cl_null(g_oma.oma19) THEN
#               IF g_oma.oma213 = 'Y' THEN
#                  LET g_oma.oma52 = g_oma.oma50 * l_oea261 / l_oea1008
#               ELSE
#                  LET g_oma.oma52 = g_oma.oma50 * l_oea261 / l_oea61
#               END IF
#               CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52   
#            END IF
#           #LET g_oma.oma54 = g_oma.oma50 *g_oma.oma163/100
#           #LET g_oma.oma54t= g_oma.oma50t*g_oma.oma163/100
#           #-----No:FUN-A50103 END-----
#       OTHERWISE
#          LET g_oma.oma54 = g_oma.oma50
#          LET g_oma.oma54t= g_oma.oma50t
#  END CASE

#  IF g_oma.oma213='N' THEN
#     CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54
#     LET g_oma.oma54x=g_oma.oma54*g_oma.oma211/100
#     CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x
#     LET g_oma.oma54t=g_oma.oma54+g_oma.oma54x
#  ELSE
#     CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t
#     LET g_oma.oma54x=g_oma.oma54t*g_oma.oma211/(100+g_oma.oma211)
#     CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x
#     LET g_oma.oma54 =g_oma.oma54t-g_oma.oma54x
#  END IF

#  #------------------------------------------------------------
#  LET g_oma.oma56 = 0
#  LET g_oma.oma56t= 0                     
#  LET g_oma.oma53 = 0                        #TQC-A60111

#  SELECT SUM(omb16),SUM(omb16t) INTO g_oma.oma56,g_oma.oma56t
#    FROM omb_file
#   WHERE omb01=g_oma.oma01
#  IF g_oma.oma56  IS NULL THEN LET g_oma.oma56 =0 END IF   #TQC-A60111
#  IF g_oma.oma56t IS NULL THEN LET g_oma.oma56t=0 END IF   #TQC-A60111

#  CASE
#     WHEN g_oma.oma00 = '11'
#         #LET g_oma.oma56 = g_oma.oma56 *g_oma.oma161/100
#          LET g_oma.oma56  = g_oma.oma54 * g_oma.oma24    #No:FUN-A50103
#          LET g_oma.oma56t = g_oma.oma54t* g_oma.oma24    #TQC-A60111
#     WHEN g_oma.oma00 = '12'
#        #-TQC-B60089-add-
#        ##-MOD-B50230-add-
#        ##抓取不是本張出貨單的其他訂金應收之訂金金額
#        # LET l_12_oma53 = 0
#        # LET g_sql = " SELECT SUM(oma53) ",
#        #             " FROM oma_file ",
#        #             " WHERE oma01 IN (SELECT oma01 FROM oma_file,",cl_get_target_table(g_plant_new,'ogb_file'),  
#        #             " WHERE oma16 = ogb01 ",
#        #             "   AND oma16 <> '",g_ogb.ogb01,"'",
#        #             "   AND (oma00 = '12' OR oma00 = '19')", 
#        #             "   AND omavoid = 'N' ", 
#        #             "   AND ogb31 = '",g_ogb.ogb31,"' AND omaconf = 'N')"
#        # CALL cl_replace_sqldb(g_sql) RETURNING g_sql      	
#        # CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#        # PREPARE sel_ogb_pre10 FROM g_sql
#        # EXECUTE sel_ogb_pre10 INTO l_12_oma53
#        # IF l_12_oma53  IS NULL THEN LET l_12_oma53 = 0 END IF   
#        ##-MOD-B50230-end-
#        ##-TQC-A60111-add-
#        #   IF l_flag2 = 'Y' THEN
#        #     #此訂單在出貨單的金額 
#        #      LET g_sql = "SELECT SUM(omb16),SUM(omb16t) ",
#        #                 #"  FROM omb_file,",cl_get_target_table(g_oma.oma66,'ogb_file'),            #MOD-AB0101 mark
#        #                  "  FROM oma_file,omb_file,",cl_get_target_table(g_oma.oma66,'ogb_file'),   #MOD-AB0101
#        #                  " WHERE omb31 = ogb01 AND omb32 = ogb03 ",
#        #                  "   AND ogb31 = '",g_ogb.ogb31,"'",
#        #                 #"   AND ogb32 = '",g_ogb.ogb32,"'",                 #MOD-B10012 #MOD-B50230 mark 
#        #                  "   AND oma01 = omb01 AND omavoid = 'N'"                                   #MOD-AB0101 
#        #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#        #      CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#        #      PREPARE sel_omb16 FROM g_sql
#        #      EXECUTE sel_omb16 INTO l_sumomb16,l_sumomb16t 
#        #      IF l_sumomb16  IS NULL THEN LET l_sumomb16 = 0 END IF
#        #      IF l_sumomb16t IS NULL THEN LET l_sumomb16t = 0 END IF

#        #     ##-----No:FUN-A50103-----
#        #     #此訂單的訂金金額 
#        #      SELECT SUM(oma56),SUM(oma56t)
#        #        INTO l_11_oma56,l_11_oma56t
#        #        FROM oma_file
#        #       WHERE oma16 = g_ogb.ogb31
#        #         AND oma00 = '11'
#        #      IF g_oma.oma213 = 'Y' THEN
#        #        ##-----No:CHI-A70015-----
#        #        #SELECT oea263 INTO l_13_oma56t
#        #        #  FROM oea_file
#        #        # WHERE oea01 = g_ogb.ogb31
#        #         LET l_13_oma56t = l_oea263
#        #         #-----No:CHI-A70015 END-----
#        #         LET l_13_oma56t = l_13_oma56t * g_oma.oma24
#        #         LET l_13_oma56  = l_13_oma56t/(1+ g_oma.oma211/100)
#        #         CALL cl_digcut(l_13_oma56,t_azi04) RETURNING l_13_oma56
#        #      ELSE
#        #        ##-----No:CHI-A70015-----
#        #        #SELECT oea263 INTO l_13_oma56
#        #        #  FROM oea_file
#        #        # WHERE oea01 = g_ogb.ogb31
#        #         LET l_13_oma56 = l_oea263
#        #         #-----No:CHI-A70015 END-----
#        #         LET l_13_oma56  = l_13_oma56  * g_oma.oma24
#        #         LET l_13_oma56t = l_13_oma56 *(1+ g_oma.oma211/100)
#        #         CALL cl_digcut(l_13_oma56t,t_azi04) RETURNING l_13_oma56t
#        #      END IF
#        #     #SELECT oma50*oma24,oma50t*oma24,oma56,oma56t          
#        #     #  INTO l_13_oma56,l_13_oma56t,l_11_oma56,l_11_oma56t
#        #     #  FROM oma_file
#        #     # WHERE oma16 = g_ogb.ogb31 AND oma00 = '11'
#        #      IF l_11_oma56  IS NULL THEN LET l_11_oma56 = 0 END IF  
#        #      IF l_11_oma56t IS NULL THEN LET l_11_oma56t = 0 END IF
#        #      IF l_13_oma56  IS NULL THEN LET l_13_oma56 = 0 END IF
#        #      IF l_13_oma56t IS NULL THEN LET l_13_oma56t = 0 END IF


#        #     #LET l_13_oma56 = l_13_oma56  * g_oma.oma163/100
#        #     #LET l_13_oma56t= l_13_oma56t * g_oma.oma163/100
#        #     #CALL cl_digcut(l_13_oma56,g_azi04)  RETURNING l_13_oma56
#        #     #CALL cl_digcut(l_13_oma56t,g_azi04) RETURNING l_13_oma56t
#        #     ##-----No:FUN-A50103 END-----

#        #     #抓取不是本張出貨單的其他出貨應收之未稅與含稅金額
#        #      LET g_sql = " SELECT SUM(oma56),SUM(oma56t) ",    #MOD-B50230 remove l_12_oma53
#        #                  "  FROM oma_file ",
#        #                  " WHERE oma01 IN ( SELECT oma01 FROM oma_file,",
#        #                                            cl_get_target_table(g_oma.oma66,'ogb_file'),
#        #                  " WHERE oma16 = ogb01 AND oma16 <> '",g_ogb.ogb01,"'",
#        #                  "   AND oma00 = '12' AND omavoid = 'N' AND ogb31 = '",g_ogb.ogb31,"')"  #MOD-B10012 mark #MOD-B50230 remark
#        #                 #"   AND oma00 = '12' AND omavoid = 'N' AND ogb31 = '",g_ogb.ogb31,"')", #MOD-B10012      #MOD-B50230
#        #                 #"   AND ogb32 = '",g_ogb.ogb32,"')"       #MOD-B50230 mark 
#        #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#        #      CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#        #      PREPARE sel_oma53 FROM g_sql
#        #      EXECUTE sel_oma53 INTO l_12_oma56,l_12_oma56t #MOD-B50230 remove l_12_oma53 
#        #     #IF l_12_oma53  IS NULL THEN LET l_12_oma53 = 0 END IF   #MOD-B50230 mark 
#        #      IF l_12_oma56  IS NULL THEN LET l_12_oma56 = 0 END IF
#        #      IF l_12_oma56t IS NULL THEN LET l_12_oma56t = 0 END IF

#        #      LET g_oma.oma56 = l_sumomb16 - l_11_oma56 - l_12_oma56 - l_13_oma56
#        #      LET g_oma.oma56t= l_sumomb16t - l_11_oma56t - l_12_oma56t - l_13_oma56t
#        #      LET g_oma.oma53 = l_11_oma56 - l_12_oma53    #訂單轉銷貨收入實際計算
#        #   ELSE
#        #      #-----No:FUN-A50103-----
#        #     ##-----No:CHI-A70015-----
#        #     #SELECT oea61,oea1008,oea262
#        #     #  INTO l_oea61,l_oea1008,l_oea262
#        #     #  FROM oea_file
#        #     # WHERE oea01 = g_ogb.ogb31
#        #     ##-----No:CHI-A70015 END-----
#        #      IF g_oma.oma213 = 'Y' THEN
#        #         LET g_oma.oma53 = g_oma.oma56 * l_oea261 / l_oea1008
#        #         LET g_oma.oma56 = g_oma.oma56 * l_oea262 / l_oea1008
#        #         LET g_oma.oma56t= g_oma.oma56t* l_oea262 / l_oea1008
#        #      ELSE
#        #         LET g_oma.oma53 = g_oma.oma56 * l_oea261 / l_oea61
#        #         LET g_oma.oma56 = g_oma.oma56 * l_oea262 / l_oea61
#        #         LET g_oma.oma56t= g_oma.oma56t* l_oea262 / l_oea61
#        #      END IF
#        #     ##-----No:FUN-A50103 END-----
#        #   END IF
#        #-TQC-B60089-end-
#          LET g_oma.oma53 = g_oma.oma52 * g_oma.oma24            #TQC-B60089
#          CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53
#         #-TQC-B60089-add-
#         #單頭本幣與單身本幣尾差調整
#          LET l_oma56=0 
#          LET l_oma56t=0
#          SELECT SUM(omb16),SUM(omb16t) INTO l_sumomb16,l_sumomb16t
#            FROM omb_file
#           WHERE omb01 = g_oma.oma01 
#          IF l_sumomb16  IS NULL THEN LET l_sumomb16 = 0 END IF
#          IF l_sumomb16t IS NULL THEN LET l_sumomb16t = 0 END IF
#          LET g_oma.oma56 = g_oma.oma54 *g_oma.oma24
#          LET l_oma56 = g_oma.oma53 + g_oma.oma56 
#          CALL cl_digcut(l_oma56,g_azi04) RETURNING l_oma56  
#          LET l_oma56 = l_oma56 - l_sumomb16
#          IF l_oma56 <> 0 THEN
#             LET g_oma.oma56 = g_oma.oma56 - l_oma56
#          END IF
#          LET g_oma.oma56t= g_oma.oma54t*g_oma.oma24
#          LET l_oma56t = g_oma.oma53 + g_oma.oma56t 
#          CALL cl_digcut(l_oma56t,g_azi04) RETURNING l_oma56t  
#          LET l_oma56t = l_oma56t - l_sumomb16
#          IF l_oma56t <> 0 THEN
#             LET g_oma.oma56t = g_oma.oma56t - l_oma56t
#          END IF
#         #-TQC-B60089-mark-
#         ##判斷變更後金額是否超出原待抵金額,
#         ##若是的話,oma53=原待抵金額,oma54=變更後金額-原待抵金額
#         #IF NOT cl_null(g_oma.oma19) THEN    #待抵帳款單號不為空
#         #   LET l_oma56=0 LET l_oma56t=0
#         #  #SELECT (oma56t-oma57),oma56t INTO l_oma56,l_oma56t
#         #   SELECT SUM(oma56t-oma57),SUM(oma56t) INTO l_oma56,l_oma56t
#         #     FROM oma_file
#         #   #WHERE oma01=g_oma.oma19
#         #    WHERE oma16=g_oma.oma19     #No:FUN-A50103
#         #  #IF l_oma56 < g_oma.oma53 THEN   #MOD-B50230 mark
#         #   IF l_oma56 < g_oma.oma53 OR l_oeb917 <= l_sumogb917+l_ogb917 THEN   #MOD-B50230
#         #     #LET g_oma.oma53 = l_oma56                 #本幣訂金     #MOD-B50230 mark 
#         #      LET g_oma.oma53 = l_oma56 - l_12_oma53    #本幣訂金     #MOD-B50230
#         #   END IF
#         #END IF
#         #-TQC-B60089-end-
#           #-TQC-A60111-end-
#     WHEN g_oma.oma00 = '13'
#       #LET g_oma.oma56 = g_oma.oma56 *g_oma.oma163/100
#        LET g_oma.oma56 = g_oma.oma54 * g_oma.oma24    #No:FUN-A50103
#       #-TQC-A60111-add-
#        LET g_oma.oma56t = g_oma.oma54t* g_oma.oma24
#        IF l_oea262 = 0 AND l_oea263 > 0 THEN
#           LET g_oma.oma53  = g_oma.oma52 * g_oma.oma24
#           CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53
#        END IF
#       #-TQC-A60111-end-
#  END CASE

#  IF g_oma.oma56  IS NULL THEN LET g_oma.oma56 =0 END IF
#  IF g_oma.oma56t IS NULL THEN LET g_oma.oma56t=0 END IF

#  IF g_oma.oma213='N' THEN
#     CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56   #MOD-810070
#     LET g_oma.oma56x=g_oma.oma56*g_oma.oma211/100
#     CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x   #MOD-810070
#     LET g_oma.oma56t=g_oma.oma56+g_oma.oma56x
#  ELSE
#     CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t   #MOD-810070
#     LET g_oma.oma56x=g_oma.oma56t*g_oma.oma211/(100+g_oma.oma211)
#     CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x   #MOD-810070
#     LET g_oma.oma56 =g_oma.oma56t-g_oma.oma56x
#  END IF

#  #------------------------------------------------------------
#  LET g_oma.oma59 = 0 LET g_oma.oma59t= 0
#  SELECT SUM(omb18),SUM(omb18t) INTO g_oma.oma59,g_oma.oma59t
#    FROM omb_file
#   WHERE omb01=g_oma.oma01

#  CASE
#     WHEN g_oma.oma00 = '11'
#       #LET g_oma.oma59 = g_oma.oma59 *g_oma.oma161/100
#        LET g_oma.oma59 = g_oma.oma54 * g_oma.oma58    #No:FUN-A50103
#        LET g_oma.oma59t = g_oma.oma54t* g_oma.oma58   #TQC-A60111
#     WHEN g_oma.oma00 = '12'
#      #-TQC-B60089-mark-
#      ##-TQC-A60111-add-
#      # IF l_flag2 = 'Y' THEN
#      #   #此訂單在出貨單的金額 
#      #    LET g_sql = "SELECT SUM(omb18),SUM(omb18t) ",
#      #               #"  FROM omb_file,",cl_get_target_table(g_oma.oma66,'ogb_file'),          #MOD-B10012 mark
#      #                "  FROM oma_file,omb_file,",cl_get_target_table(g_oma.oma66,'ogb_file'), #MOD-B10012
#      #                " WHERE omb31 = ogb01 AND omb32 = ogb03 ",
#      #               #"   AND ogb32 = '",g_ogb.ogb32,"'",        #MOD-B50230 mark 
#      #                "   AND ogb32 = '",g_ogb.ogb32,"'",                 #MOD-B10012 
#      #                "   AND oma01 = omb01 AND omavoid = 'N'"            #MOD-B10012 
#      #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#      #    CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#      #    PREPARE sel_omb18 FROM g_sql
#      #    EXECUTE sel_omb18 INTO l_sumomb18,l_sumomb18t 
#      #    IF l_sumomb18  IS NULL THEN LET l_sumomb18 = 0 END IF
#      #    IF l_sumomb18t IS NULL THEN LET l_sumomb18t = 0 END IF

#      #   ##-----No:FUN-A50103-----
#      #   #此訂單的訂金金額 
#      #    SELECT SUM(oma59),SUM(oma59t)
#      #      INTO l_11_oma59,l_11_oma59t
#      #      FROM oma_file
#      #     WHERE oma16 = g_ogb.ogb31
#      #       AND oma00 = '11'
#      #    IF g_oma.oma213 = 'Y' THEN
#      #      ##-----No:CHI-A70015-----
#      #      #SELECT oea263 INTO l_13_oma59t
#      #      #  FROM oea_file
#      #      # WHERE oea01 = g_ogb.ogb31
#      #       LET l_13_oma59t = l_oea263
#      #       #-----No:CHI-A70015 END-----
#      #       LET l_13_oma59t = l_13_oma59t * g_oma.oma58
#      #       LET l_13_oma59  = l_13_oma59t/(1+ g_oma.oma211/100)
#      #       CALL cl_digcut(l_13_oma59,t_azi04) RETURNING l_13_oma59
#      #    ELSE
#      #      ##-----No:CHI-A70015-----
#      #      #SELECT oea263 INTO l_13_oma59
#      #      #  FROM oea_file
#      #      # WHERE oea01 = g_ogb.ogb31
#      #       LET l_13_oma59 = l_oea263
#      #       #-----No:CHI-A70015 END-----
#      #       LET l_13_oma59  = l_13_oma59 * g_oma.oma58
#      #       LET l_13_oma59t = l_13_oma59 *(1+ g_oma.oma211/100)
#      #       CALL cl_digcut(l_13_oma59t,t_azi04) RETURNING l_13_oma59t
#      #    END IF
#      #   #SELECT oma50*oma58,oma50t*oma58,oma59,oma59t           
#      #   #  INTO l_13_oma59,l_13_oma59t,l_11_oma59,l_11_oma59t
#      #   #  FROM oma_file
#      #   # WHERE oma16 = g_ogb.ogb31 AND oma00 = '11'
#      #    IF l_11_oma59  IS NULL THEN LET l_11_oma59 = 0 END IF
#      #    IF l_11_oma59t IS NULL THEN LET l_11_oma59t = 0 END IF
#      #    IF l_13_oma59  IS NULL THEN LET l_13_oma59 = 0 END IF
#      #    IF l_13_oma59t IS NULL THEN LET l_13_oma59t = 0 END IF

#      #   #LET l_13_oma59 = l_13_oma59  * g_oma.oma163/100
#      #   #LET l_13_oma59t= l_13_oma59t * g_oma.oma163/100
#      #   #CALL cl_digcut(l_13_oma59,g_azi04)  RETURNING l_13_oma59
#      #   #CALL cl_digcut(l_13_oma59t,g_azi04) RETURNING l_13_oma59t
#      #   ##-----No:FUN-A50103 END-----

#      #   #抓取不是本張出貨單的其他出貨應收之未稅與含稅金額
#      #    LET g_sql = "SELECT SUM(oma59),SUM(oma59t) ",
#      #                "  FROM oma_file ",
#      #                " WHERE oma01 IN ( SELECT oma01 FROM oma_file,",
#      #                                          cl_get_target_table(g_oma.oma66,'ogb_file'),
#      #                " WHERE oma16 = ogb01 AND oma16 <> '",g_ogb.ogb01,"'",
#      #                "   AND oma00 = '12' AND omavoid = 'N' AND ogb31 = '",g_ogb.ogb31,"')"  #MOD-B10012 mark #MOD-B50230 remark
#      #               #"   AND oma00 = '12' AND omavoid = 'N' AND ogb31 = '",g_ogb.ogb31,"')", #MOD-B10012      #MOD-B50230
#      #               #"   AND ogb32 = '",g_ogb.ogb32,"')"     #MOD-B50230 mark
#      #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#      #    CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
#      #    PREPARE sel_oma59 FROM g_sql
#      #    EXECUTE sel_oma59 INTO l_12_oma59,l_12_oma59t 
#      #    IF l_12_oma59  IS NULL THEN LET l_12_oma59 = 0 END IF
#      #    IF l_12_oma59t IS NULL THEN LET l_12_oma59t = 0 END IF

#      #    LET g_oma.oma59 = l_sumomb18 - l_11_oma59 - l_12_oma59 - l_13_oma59
#      #    LET g_oma.oma59t= l_sumomb18t - l_11_oma59t - l_12_oma59t - l_13_oma59t
#      # ELSE
#      #    #-----No:FUN-A50103-----
#      #   ##-----No:CHI-A70015-----
#      #   #SELECT oea61,oea1008,oea262
#      #   #  INTO l_oea61,l_oea1008,l_oea262
#      #   #  FROM oea_file
#      #   # WHERE oea01 = g_ogb.ogb31
#      #   ##-----No:CHI-A70015 END-----
#      #    IF g_oma.oma213 = 'Y' THEN
#      #       LET g_oma.oma59 = g_oma.oma59 * l_oea262 / l_oea1008
#      #       LET g_oma.oma59t= g_oma.oma59t* l_oea262 / l_oea1008
#      #    ELSE
#      #       LET g_oma.oma59 = g_oma.oma59 * l_oea262 / l_oea61
#      #       LET g_oma.oma59t= g_oma.oma59t* l_oea262 / l_oea61
#      #    END IF
#      #    #-----No:FUN-A50103 END-----
#      # END IF
#      ##-TQC-A60111-end-
#      #-TQC-B60089-end-
#        LET g_oma.oma59 = g_oma.oma54 *g_oma.oma58   #TQC-B60089
#        LET g_oma.oma59t= g_oma.oma54t*g_oma.oma58   #TQC-B60089
#     WHEN g_oma.oma00 = '13'
#       #LET g_oma.oma59 = g_oma.oma59 *g_oma.oma163/100
#        LET g_oma.oma59 = g_oma.oma54 * g_oma.oma58    #No:FUN-A50103
#        LET g_oma.oma59t = g_oma.oma54t* g_oma.oma58   #TQC-A60111
#  END CASE

#  IF g_oma.oma59  IS NULL THEN LET g_oma.oma59 =0 END IF
#  IF g_oma.oma59t IS NULL THEN LET g_oma.oma59t=0 END IF

#  IF g_oma.oma213='N' THEN
#     CALL cl_digcut(g_oma.oma59,g_azi04) RETURNING g_oma.oma59   #MOD-810070
#     LET g_oma.oma59x=g_oma.oma59*g_oma.oma211/100
#     CALL cl_digcut(g_oma.oma59x,g_azi04) RETURNING g_oma.oma59x   #MOD-810070
#     LET g_oma.oma59t=g_oma.oma59+g_oma.oma59x
#  ELSE
#     CALL cl_digcut(g_oma.oma59t,g_azi04) RETURNING g_oma.oma59t   #MOD-810070
#     LET g_oma.oma59x=g_oma.oma59t*g_oma.oma211/(100+g_oma.oma211)
#     CALL cl_digcut(g_oma.oma59x,g_azi04) RETURNING g_oma.oma59x   #MOD-810070
#     LET g_oma.oma59 =g_oma.oma59t-g_oma.oma59x
#  END IF

#  #------------------------------------------------------------
#  IF g_oma.oma00='31' THEN			# '31'類視為已沖帳, 不再視為應收
#     LET g_oma.oma55=g_oma.oma54t
#     LET g_oma.oma57=g_oma.oma56t
#     DISPLAY BY NAME g_oma.oma55,g_oma.oma57
#  END IF
# #-TQC-A60111-add-
#  LET g_oma.oma61 = g_oma.oma56t-g_oma.oma57
#  CALL s_ar_oox03(g_oma.oma01) RETURNING g_net
#  LET g_oma.oma61 = g_oma.oma61+g_net
#  CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t
#  CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t
# #-TQC-A60111-end-
#  UPDATE oma_file SET oma50=g_oma.oma50   ,oma50t=g_oma.oma50t,
#                      oma52=g_oma.oma52   ,oma53=g_oma.oma53,
#                      oma54=g_oma.oma54   ,oma54x=g_oma.oma54x,
#                      oma54t=g_oma.oma54t ,oma56=g_oma.oma56,
#                      oma56x=g_oma.oma56x ,oma56t=g_oma.oma56t,
#                      oma59=g_oma.oma59   ,oma59x=g_oma.oma59x,
#                      oma59t=g_oma.oma59t ,oma55=g_oma.oma55,
#                      oma57=g_oma.oma57   ,oma61=g_oma.oma61        #TQC-A60111
#   WHERE oma01=g_oma.oma01
# #No.+041 010330 by plum
# #IF STATUS THEN CALL cl_err('upd oma50',STATUS,1)
#  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd oma50: ',SQLCA.SQLCODE,1)   #No.FUN-660116
#     CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.SQLCODE,"","upd oma50: ",1)    #No.FUN-660116 #NO.FUN-710050
#     CALL s_errmsg('oma01',g_oma.oma01,'upd oma50: ',SQLCA.SQLCODE,1)                  #NO.FUN-710050
#     LET g_success='N' RETURN 
#  END IF
# #No.+041..end

#END FUNCTION
