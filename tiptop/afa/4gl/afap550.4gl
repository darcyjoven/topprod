# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: afap550
# Descriptions...: 利息資本化計算作業
# Date & Author..: 98/06/26 By David Hsu
# Modify.........: 99/05/11 By Kammy
# Modify.........: No.9057 04/01/28 Kammy 不使用npp011來區分各月份的利息資本化
#                                         分錄，而以分錄編號 = 財編+年月, 因此
#                                         若已產生過的分錄，直接先刪除再重新產生
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710028 07/01/22 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-770083 07/07/16 By wujie 年月欄位對負數未控管 
# Modify.........: No.TQC-770087 07/07/18 By chenl 增加離開按鈕功能。
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B30626 11/03/21 By Dido 過濾fcx11為null;檢核作業該月月底是否大於faa09 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-D10065 13/01/17 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     b_date,e_date   LIKE type_file.dat,          #No.FUN-680070 DATE
    yy              LIKE fcx_file.fcx02,
    mm              LIKE fcx_file.fcx03,
    mark            LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_fcx           RECORD
                    fcx01 LIKE fcx_file.fcx01,
                    fcx011 LIKE fcx_file.fcx011,
                    fcx02 LIKE fcx_file.fcx02,
                    fcx03 LIKE fcx_file.fcx03,
                    fcx04 LIKE fcx_file.fcx04,
                    fcx05 LIKE fcx_file.fcx05,
                    fcx06 LIKE fcx_file.fcx06,
                    fcx07 LIKE fcx_file.fcx07,
                    fcx08 LIKE fcx_file.fcx08,
                    fcx09 LIKE fcx_file.fcx09,
                    fcx10 LIKE fcx_file.fcx10,
                    fcx091 LIKE fcx_file.fcx091,     #No.FUN-680028
                    fcx101 LIKE fcx_file.fcx101,     #No.FUN-680028
                    fcx11 LIKE fcx_file.fcx11,
                    fcx12 LIKE fcx_file.fcx12,
                    fcxacti LIKE fcx_file.fcxacti,
                    fcxuser LIKE fcx_file.fcxuser,
                    fcxgrup LIKE fcx_file.fcxgrup,
                    fcxmodu LIKE fcx_file.fcxmodu,
                    fcxdate LIKE fcx_file.fcxdate,
                    nmm03   LIKE nmm_file.nmm03,
                    nmm04   LIKE nmm_file.nmm04
                END RECORD,
    g_nmm           RECORD LIKE nmm_file.*,
    g_fcx_trn       RECORD LIKE fcx_file.*,
    g_npp_trn       RECORD LIKE npp_file.*,
    g_npq_trn       RECORD LIKE npq_file.*,
    g_sql           string,  #No.FUN-580092 HCN
    g_bookno           LIKE aag_file.aag00         #FUN-D10065   add
DEFINE g_flag          LIKE type_file.chr1,                  #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
 
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE l_syy    LIKE type_file.num5,     #NO.FUN-570144        #No.FUN-680070 smallint
       l_smm    LIKE type_file.num5         #No.FUN-680070 smallint
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0069
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET l_syy  = ARG_VAL(1)
   LET l_smm  = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570144 MARK---
#   OPEN WINDOW p550_w AT p_row,p_col  WITH FORM "afa/42f/afap550"
################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570144 MARK---                   
 
 
   CALL cl_opmsg('z')
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
   LET g_bookno = g_aza.aza81   #FUN-D10065  add
   WHILE TRUE
    IF g_bgjob = "N" THEN
       CALL p550()
       IF cl_sure(18,20) THEN
          LET g_success = 'Y'
          BEGIN WORK
          CALL p550_t()
          CALL s_showmsg()   #No.FUN-710028
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING g_flag
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING g_flag
          END IF
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p550_w
            EXIT WHILE
         END IF
     ELSE
         CONTINUE WHILE
     END IF
   ELSE
     BEGIN WORK
     LET g_success = 'Y'
     CALL p550_t()
     CALL s_showmsg()   #No.FUN-710028
     IF g_success = "Y" THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     CALL cl_batch_bg_javamail(g_success)
     EXIT WHILE
    END IF
  END WHILE
#      CALL p550()
#      IF g_success = 'N' OR INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#   END WHILE
#   CLOSE WINDOW p550_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
#   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
#NO.FUN-570144 END--------
END MAIN
 
FUNCTION p550()
DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
DEFINE   l_date        LIKE type_file.dat               #MOD-B30626

  #->No.FUN-570144 --start--
  LET p_row = 5 LET p_col = 28
 
  OPEN WINDOW p550_w AT p_row,p_col WITH FORM "afa/42f/afap550"
    ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
 
  #->No.FUN-570144 ---end---
 
    CLEAR FORM
{---afa.4gl已有 99-05-03
    SELECT faa07,faa08 INTO l_syy,l_smm
      FROM faa_file
      WHERE faa00='0'
    IF STATUS THEN CALL cl_err('update:','',1) RETURN END IF
---}
    LET l_syy=g_faa.faa07    LET l_smm=g_faa.faa08
    LET g_bgjob = 'N'  #NO.FUN-570144 
 
  WHILE TRUE   #NO.FUN-570144 
    #INPUT l_syy,l_smm WITHOUT DEFAULTS FROM fcx02,fcx03
    INPUT l_syy,l_smm,g_bgjob WITHOUT DEFAULTS FROM fcx02,fcx03,g_bgjob #NO.FUN-570144
#No.TQC-770083--begin                                                                                                               
       AFTER FIELD fcx02                                                                                                            
         IF NOT cl_null(l_syy) THEN                                                                                                 
            IF l_syy <=0 THEN                                                                                                       
               LET l_syy =NULL                                                                                                      
               CALL cl_err('','asf-108',1)
               NEXT FIELD fcx02                                                                                                     
            END IF                                                                                                                  
         ELSE                                                                                                                       
            NEXT FIELD fcx02                                                                                                        
         END IF                                                                                                                     
                                                                                                                                    
       AFTER FIELD fcx03                                                                                                            
         IF NOT cl_null(l_smm) THEN                                                                                                 
            IF l_smm <=0 THEN                                                                                                       
               LET l_smm =NULL                                                                                                      
               CALL cl_err('','asf-108',1)
               NEXT FIELD fcx03                                                                                                     
            END IF                                                                                                                  
           #-MOD-B30626-add-
            LET l_date = MDY(l_smm,1,l_syy)
            LET l_date = s_last(l_date)
            IF l_date <= g_faa.faa09 THEN
               CALL cl_err('','mfg9999',1)
               NEXT FIELD fcx03                                                                                                     
            END IF
           #-MOD-B30626-end- 
         ELSE                                                                                                                       
            NEXT FIELD fcx03                                                                                                        
         END IF                                                                                                                     
#No.TQC-770083--end     
       ON ACTION locale
         # CALL cl_dynamic_locale()
         # CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE                 #NO.FUN-570144 
            EXIT INPUT
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
         
         #No.TQC-770087 --begin--
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         #No.TQC-770087 ---end---
 
END INPUT
#NO.FUN-570144 start---
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin) #NO.FUN-570112 MARK
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p550_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
      END IF
 
#    IF INT_FLAG THEN RETURN END IF
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap550'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap550','9031',1)  
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",l_syy CLIPPED,"'",
                     " '",l_smm CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('afap550',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p550_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
  EXIT WHILE
END WHILE
#FUN-570144 ---end---
END FUNCTION
 
#NO.FUN-570144 START--------------------
FUNCTION p550_t()
DEFINE 
    l_fcx07  LIKE fcx_file.fcx07,
    l_fcx08  LIKE fcx_file.fcx08,
    l_fcx06  LIKE fcx_file.fcx06,
    l_n      LIKE type_file.num5,         #No.FUN-680070 smallint
    l_yy     LIKE fcx_file.fcx02,
    l_mm     LIKE fcx_file.fcx03,
    l_ayy    LIKE type_file.num5,         #No.FUN-680070 smallint
    l_amm    LIKE type_file.num5,         #No.FUN-680070 smallint
#   l_syy    LIKE type_file.num5,      #mark by #No.FUN-680028 導致_t()內取不到年月       #No.FUN-680070 smallint
#   l_smm    LIKE type_file.num5,      #mark by #No.FUN-680028 導致_t()內取不到年月       #No.FUN-680070 smallint
    l_rate   LIKE faa_file.faa27,
    l_npp01  LIKE npp_file.npp01,          #No.9057
    l_npp011 LIKE npp_file.npp011,
    l_npp02  LIKE npp_file.npp02,
    l_sum    LIKE fcx_file.fcx07,
    l_sum1   LIKE fcx_file.fcx07,
    l_b_bdate       LIKE type_file.dat,                     #       #No.FUN-680070 date
    l_b_edate       LIKE type_file.dat,                     #       #No.FUN-680070 date
    l_yn     LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(25)
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
    #BEGIN WORK
    #LET g_success='Y'
    #--------------------------------------------------------------
      DECLARE i900_cu CURSOR FOR
      SELECT fcx01,fcx011,fcx02,fcx03,fcx04,fcx05,fcx06,
               fcx07,fcx08,fcx09,fcx10,fcx091,fcx101,fcx11,fcx12,     #No.FUN-680028
               fcxacti,fcxuser,fcxgrup,fcxmodu,fcxdate,
               nmm03,nmm04
         FROM fcx_file,nmm_file
         WHERE fcx02=nmm01
          AND fcx03=nmm02
          AND fcx02=l_syy
          AND fcx03=l_smm
          AND fcx13 IS NULL
          AND fcx11 IS NULL       #MOD-B30626
    #-------------------------------------------------------------
    #3-2.每筆利息資本化資料計算完畢均Update fcx_file
    #--------------------------------------------------------------
    CALL s_showmsg_init()  #No.FUN-710028
    FOREACH i900_cu INTO g_fcx.*
    IF SQLCA.sqlcode THEN
#    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH          #No.FUN-710028
     CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0) EXIT FOREACH  #No.FUN-710028
     LET g_success = 'N'                                           #No.FUN-8A0086
    END IF
#No.FUN-710028 --begin                                                                                                              
    IF g_success='N' THEN                                                                                                         
       LET g_totsuccess='N'                                                                                                       
       LET g_success="Y"                                                                                                          
    END IF                                                                                                                        
#No.FUN-710028 -end
 
       MESSAGE g_fcx.fcx01
       CALL ui.Interface.refresh()
       IF g_faa.faa26 = '2' THEN                ##--採月利率
             SELECT SUM((fcx04+fcx05/2)*nmm03/100)
               INTO l_sum
               FROM fcx_file,nmm_file
               WHERE fcx02=l_syy
                 AND fcx03=l_smm
                 AND fcx02=nmm01
                 AND fcx03=nmm02
                 AND fcx13 IS NULL
             LET l_rate = g_fcx.nmm03
       ELSE                                     ##--採年利率
             SELECT SUM(fcx04+fcx05/2)
               INTO l_sum FROM fcx_file
               WHERE fcx02=l_syy
                 AND fcx03=l_smm
                 AND fcx13 IS NULL
             LET l_rate = g_faa.faa27/12
             LET l_sum = l_sum * l_rate /100
       END IF
       LET g_fcx.fcx07=(g_fcx.fcx04+g_fcx.fcx05/2)*l_rate/100
       IF l_sum=0 OR l_rate=0 THEN
          LET g_fcx.fcx08=0
       ELSE
          IF g_faa.faa26='2' THEN   #月利率
            LET g_fcx.fcx08=(g_fcx.fcx07/l_sum)*g_fcx.nmm04
          ELSE
            LET g_fcx.fcx08=g_fcx.fcx07
          END IF
       END IF
       #---取其低者--------------------
       IF g_fcx.fcx07 > g_fcx.fcx08 THEN
          LET g_fcx.fcx06 = g_fcx.fcx08
       ELSE
          LET g_fcx.fcx06 = g_fcx.fcx07
       END IF
       CALL cl_digcut(g_fcx.fcx06,0) RETURNING g_fcx.fcx06
       CALL cl_digcut(g_fcx.fcx07,0) RETURNING g_fcx.fcx07
       CALL cl_digcut(g_fcx.fcx08,0) RETURNING g_fcx.fcx08
 
       UPDATE fcx_file
          SET fcx07 = g_fcx.fcx07,
              fcx08 = g_fcx.fcx08,
              fcx06 = g_fcx.fcx06
          WHERE fcx01=g_fcx.fcx01
            AND fcx011=g_fcx.fcx011
            AND fcx02=g_fcx.fcx02
            AND fcx03=g_fcx.fcx03
       IF STATUS THEN
#        CALL cl_err('update:',SQLCA.sqlcode,1)    #No.FUN-660136
#        CALL cl_err3("upd","fcx_file",g_fcx.fcx01,g_fcx.fcx011,SQLCA.sqlcode,"","update:",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = g_fcx.fcx01,"/",g_fcx.fcx011,"/",g_fcx.fcx02,"/",g_fcx.fcx03          #No.FUN-710028  
         CALL s_errmsg('fcx01,fcx011,fcx02,fcx03',g_showmsg,'update:',SQLCA.sqlcode,1)         #No.FUN-710028
         LET g_success = 'N' 
       END IF
    #--------------------------------------------------------------
    #3-3.產生一筆'次月'利息資本化資料
    #--------------------------------------------------------------
          LET g_fcx_trn.fcx01 =g_fcx.fcx01
          LET g_fcx_trn.fcx011 =g_fcx.fcx011
          #--------------------------------
           LET l_mm=l_smm+1 LET l_yy=l_syy
           IF l_mm >12 THEN
            LET l_mm=1
            LET l_yy=l_yy+1
           END IF
           LET g_fcx_trn.fcx02 =l_yy
           LET g_fcx_trn.fcx03 =l_mm
          #--------------------------------
          LET g_fcx_trn.fcx04 =g_fcx.fcx04+g_fcx.fcx05+g_fcx.fcx06
          LET g_fcx_trn.fcx05 =0
          LET g_fcx_trn.fcx06 =0
          LET g_fcx_trn.fcx07 =0
          LET g_fcx_trn.fcx08 =0
          LET g_fcx_trn.fcx09 =g_fcx.fcx09
          LET g_fcx_trn.fcx10 =g_fcx.fcx10
          #No.FUN-680028 --begin
 #        IF g_aza.aza63 = 'Y' THEN   
          IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 
             LET g_fcx_trn.fcx091=g_fcx.fcx091
             LET g_fcx_trn.fcx101=g_fcx.fcx101
          END IF
          #No.FUN-680028 --end
          LET g_fcx_trn.fcx11 =''
          LET g_fcx_trn.fcx12 =''
          LET g_fcx_trn.fcx13 = NULL
          LET g_fcx_trn.fcxacti='Y'
          LET g_fcx_trn.fcxuser=g_user
          LET g_fcx_trn.fcxgrup=g_grup
          LET g_fcx_trn.fcxmodu=''
          LET g_fcx_trn.fcxdate=''
          LET g_fcx_trn.fcxlegal=g_legal    #FUN-980003 add
 
       UPDATE fcx_file
          SET fcx04 = g_fcx_trn.fcx04,
              fcx05 = g_fcx_trn.fcx05,
              fcx06 = g_fcx_trn.fcx06,
              fcx07 = g_fcx_trn.fcx07,
              fcx08 = g_fcx_trn.fcx08,
              fcx09 = g_fcx_trn.fcx09,
              fcx10 = g_fcx_trn.fcx10,
              #No.FUN-680028 --begin
              fcx091= g_fcx_trn.fcx091,
              fcx101= g_fcx_trn.fcx101,
              #No.FUN-680028 --end
              fcx11 = g_fcx_trn.fcx11,
              fcx12 = g_fcx_trn.fcx12,
              fcxacti = g_fcx_trn.fcxacti,
              fcxuser = g_fcx_trn.fcxuser,
              fcxgrup = g_fcx_trn.fcxgrup,
              fcxmodu = g_fcx_trn.fcxmodu,
              fcxdate = g_fcx_trn.fcxdate
          WHERE fcx01=g_fcx.fcx01
            AND fcx011=g_fcx.fcx011
            AND fcx02=l_yy
            AND fcx03=l_mm
       IF STATUS =0 AND SQLCA.SQLERRD[3] =0 THEN
         LET g_fcx_trn.fcxoriu = g_user      #No.FUN-980030 10/01/04
         LET g_fcx_trn.fcxorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO fcx_file VALUES(g_fcx_trn.*)
           IF STATUS THEN 
#             CALL cl_err('ins fcx',STATUS,1)   #No.FUN-660136
#             CALL cl_err3("ins","fcx_file",g_fcx.fcx01,g_fcx.fcx011,STATUS,"","ins fcx",1)  #No.FUN-660136 #No.FUN-710028
              LET g_showmsg = g_fcx.fcx01,"/",g_fcx.fcx011,"/",l_yy,"/",l_mm                 #No.FUN-710028  
              CALL s_errmsg('fcx01,fcx011,fcx02,fcx03',g_showmsg,'ins fcx',STATUS,1)         #No.FUN-710028
              LET g_success = 'N'
           END IF
       END IF
 
    #--------------------------------------------------------------
    #3-4.產生分錄底稿 ------------ 借方科目=fcx09(預付設備科目)
    #                              貸方科目=fcx10(利息支出科目)
    #                              金額    =fcx06(利息資本化金額)
    #--------------------------------------------------------------
          LET g_npp_trn.nppsys ='FA'
          LET g_npp_trn.npp00  =11
          LET g_npp_trn.npp01  =g_fcx.fcx01
          #---------------------------------------------
          CALL s_mothck(MDY(l_smm,1,l_syy))
               RETURNING l_b_bdate,l_b_edate
          #---------------------------------------------
          LET g_npp_trn.npp02  =l_b_edate
          LET g_npp_trn.npp03  =NULL
          LET g_npp_trn.npp04  =''
          LET g_npp_trn.npp05  =''
          LET g_npp_trn.npp06  =''
          LET g_npp_trn.npp07  =''
          LET g_npp_trn.nppglno =''
          LET g_npp_trn.npptype = '0'     #No.FUN-680028
          LET g_npp_trn.npplegal= g_legal #FUN-980003 add
 
#No.9057 不使用npp011來區分可月份的利息資本化分錄，而以分錄編號 = 財編+年月
#        因此若已產生過的分錄，直接先刪除再重新產生
{
       LET l_n = 0
       SELECT count(*),npp011 INTO l_n,l_npp011
         FROM npp_file
         WHERE npp00=11
           AND nppsys='FA'
           AND npp01=g_fcx.fcx01
           AND npp02=l_b_edate
         GROUP BY npp011
       IF STATUS THEN
#        # CALL cl_err('npp-se:',STATUS,1)   #No.FUN-660136
         CALL cl_err3("sel","npp_file",g_fcx.fcx01,"",STATUS,"","npp-se:",1)   #No.FUN-660136
         LET l_n=0
       END IF
 
       IF l_n >0 THEN
         UPDATE npq_file 
         SET npq03 = g_fcx.fcx09,
             npq06 = '1',
             npq07 = g_fcx.fcx06,
             npq07f= g_fcx.fcx06,
             npq24 = g_aza.aza17,
             npq25 = 1
          WHERE npqsys='FA'
            AND npq00='11'
            AND npq011=l_npp011
            AND npq01=g_fcx.fcx01
            AND npq02=1
 
        IF STATUS THEN
#          CALL cl_err('upd npq:',STATUS,0)    #No.FUN-660136
           CALL cl_err3("upd","npq_file",g_fcx.fcx01,l_npp011,SQLCA.sqlcode,"","upd npq:",0)   #No.FUN-660136
           LET g_success='N'
        END IF
    #--貸-----------------------------------------------
        UPDATE npq_file
         SET npq03 = g_fcx.fcx10,
             npq06 = '2',
             npq07 = g_fcx.fcx06,
             npq07f= g_fcx.fcx06,
             npq24 = g_aza.aza17,
             npq25 = 1
          WHERE npqsys='FA'
            AND npq00='11'
            AND npq011=l_npp011
            AND npq01=g_fcx.fcx01
            AND npq02=2
        IF STATUS THEN
#          CALL cl_err('upd npq:',STATUS,0)    #No.FUN-660136
           CALL cl_err3("upd","npq_file",g_fcx.fcx01,l_npp011,SQLCA.sqlcode,"","upd npq:",0)   #No.FUN-660136
           LET g_success='N'
        END IF
       ELSE
          #--取MAX(npp011)-----------------------
          SELECT MAX(npp011)+1
            INTO l_npp011
            FROM npp_file
            WHERE npp01=g_fcx.fcx01
              AND nppsys='FA'
              AND npp00=11
          IF l_npp011 IS NULL THEN LET l_npp011=0 END IF
          LET g_npp_trn.npp011 =l_npp011
          #--------------------------------------
}
         LET l_npp01[1,10] = g_fcx.fcx01
         LET l_npp01[11,16]= l_syy USING '&&&&',l_smm USING '&&'
         LET g_npp_trn.npp01 = l_npp01
         DELETE FROM npp_file WHERE nppsys = 'FA'    AND npp00 ='11'
                                AND npp01  = l_npp01 AND npp011=0
                                AND npptype='0'   #No.FUN-680028
         DELETE FROM npq_file WHERE npqsys = 'FA'    AND npq00 ='11'
                                AND npq01  = l_npp01 AND npq011=0
                                AND npqtype='0'   #No.FUN-680028
         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = l_npp01
         #FUN-B40056--add--end--
         LET g_npp_trn.npp011 = 0
#No.9057(end)
         INSERT INTO npp_file VALUES(g_npp_trn.*)
          IF STATUS THEN 
#            CALL cl_err('ins npp',STATUS,1)   #No.FUN-660136
#            CALL cl_err3("ins","npp_file",g_npp_trn.nppsys,g_npp_trn.npp01,STATUS,"","ins npp",1)         #No.FUN-660136 #No.FUN-710028
             LET g_showmsg = g_npp_trn.npp01,"/",g_npp_trn.npp011,"/",g_npp_trn.nppsys,"/",g_npp_trn.npp00 #No.FUN-710028
             CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',STATUS,1)                       #No.FUN-710028
             LET g_success = 'N'
          END IF
    #--借-------------------------------------------------
          LET g_npq_trn.npqsys = 'FA'
          LET g_npq_trn.npq00  = 11
          LET g_npq_trn.npq01  = l_npp01      #No.9057
          LET g_npq_trn.npq011 = 0            #No.9057
          LET g_npq_trn.npq02  = 1
          LET g_npq_trn.npq03  = g_fcx.fcx09
          LET g_npq_trn.npq04  = ''
          LET g_npq_trn.npq05  = ''
          LET g_npq_trn.npq06  = 1
          LET g_npq_trn.npq07f = g_fcx.fcx06
          LET g_npq_trn.npq07  = g_fcx.fcx06
          LET g_npq_trn.npq08  = ''
          LET g_npq_trn.npq11  = ''
          LET g_npq_trn.npq12  = ''
          LET g_npq_trn.npq13  = ''
          LET g_npq_trn.npq14  = ''
          LET g_npq_trn.npq15  = ''
          LET g_npq_trn.npq21  = ''
          LET g_npq_trn.npq22  = ''
          LET g_npq_trn.npq23  = ''
          LET g_npq_trn.npq24  = g_aza.aza17
          LET g_npq_trn.npq25  = 1
          LET g_npq_trn.npq26  = ''
          LET g_npq_trn.npq27  = ''
          LET g_npq_trn.npq28  = ''
          LET g_npq_trn.npq29  = ''
          LET g_npq_trn.npq30  = ''
          LET g_npq_trn.npqtype = '0'     #No.FUN-680028
          LET g_npq_trn.npqlegal= g_legal #FUN-980003 add
 
        #FUN-D10065--add--str--
        CALL s_def_npq3(g_bookno,g_npq_trn.npq03,g_prog,g_npq_trn.npq01,'','')
        RETURNING g_npq_trn.npq04
        #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq_trn.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq_trn.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq_trn.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
        INSERT INTO npq_file VALUES(g_npq_trn.*)
          IF STATUS THEN 
#         CALL cl_err3("ins","npq_file",g_npq_trn.npqsys,g_npq_trn.npq01,STATUS,"","in21npq",1)              #No.FUN-660136 #No.FUN-710028
          LET g_showmsg = g_npq_trn.npq01,g_npq_trn.npq011,g_npq_trn.npq02,g_npq_trn.npqsys,g_npq_trn.npq00  #No.FUN-710028
          CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'in21npq',STATUS,1)                      #No.FUN-710028
          LET g_success = 'N'
       END IF
    #--貸-----------------------------------------------
          LET g_npq_trn.npq02  = 2
          LET g_npq_trn.npq03  = g_fcx.fcx10
          LET g_npq_trn.npq06  = 2
       #FUN-D10065--add--str--
       LET g_npq_trn.npq04  = NULL
       CALL s_def_npq3(g_bookno,g_npq_trn.npq03,g_prog,g_npq_trn.npq01,'','')
       RETURNING g_npq_trn.npq04
       #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq_trn.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq_trn.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq_trn.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
       INSERT INTO npq_file VALUES(g_npq_trn.*)
         IF STATUS THEN 
#        CALL cl_err('in22npq',STATUS,1)   #No.FUN-660136
#        CALL cl_err3("ins","npq_file",g_npq_trn.npqsys,g_npq_trn.npq01,STATUS,"","in22npq",1)              #No.FUN-660136
         LET g_showmsg = g_npq_trn.npq01,g_npq_trn.npq011,g_npq_trn.npq02,g_npq_trn.npqsys,g_npq_trn.npq00  #No.FUN-710028
         CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'in22npq',STATUS,1)                      #No.FUN-710028
         LET g_success = 'N'
       END IF
       CALL s_flows('3','',g_npq_trn.npq01,g_npp_trn.npp02,'N',g_npq_trn.npqtype,TRUE)   #No.TQC-B70021   
    # END IF   #No:9057
      #No.FUN-680028 --begin
 #    IF g_aza.aza63 = 'Y' THEN   
      IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
          LET g_npp_trn.nppsys ='FA'
          LET g_npp_trn.npp00  =11
          LET g_npp_trn.npp01  =g_fcx.fcx01
          #---------------------------------------------
          CALL s_mothck(MDY(l_smm,1,l_syy))
               RETURNING l_b_bdate,l_b_edate
          #---------------------------------------------
          LET g_npp_trn.npp02  =l_b_edate
          LET g_npp_trn.npp03  =NULL
          LET g_npp_trn.npp04  =''
          LET g_npp_trn.npp05  =''
          LET g_npp_trn.npp06  =''
          LET g_npp_trn.npp07  =''
          LET g_npp_trn.nppglno =''
          LET g_npp_trn.npptype = '1'
          LET g_npp_trn.npplegal= g_legal #FUN-980003 add
 
         LET l_npp01[1,10] = g_fcx.fcx01
         LET l_npp01[11,16]= l_syy USING '&&&&',l_smm USING '&&'
         LET g_npp_trn.npp01 = l_npp01
         DELETE FROM npp_file WHERE nppsys = 'FA'    AND npp00 ='11'
                                AND npp01  = l_npp01 AND npp011=0
                                AND npptype='1'   #No.FUN-680028
         DELETE FROM npq_file WHERE npqsys = 'FA'    AND npq00 ='11'
                                AND npq01  = l_npp01 AND npq011=0
                                AND npqtype='1'   #No.FUN-680028
         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = l_npp01
         #FUN-B40056--add--end--
         LET g_npp_trn.npp011 = 0
         INSERT INTO npp_file VALUES(g_npp_trn.*)
            IF STATUS THEN 
#              CALL cl_err3("ins","npp_file",g_npp_trn.nppsys,g_npp_trn.npp01,STATUS,"","ins npp",1)         #No.FUN-660136 #No.FUN-710028
               LET g_showmsg = g_npp_trn.npp01,"/",g_npp_trn.npp011,"/",g_npp_trn.nppsys,"/",g_npp_trn.npp00 #No.FUN-710028
               CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',STATUS,1)                       #No.FUN-710028
           LET g_success = 'N'
          END IF
    #--借-------------------------------------------------
          LET g_npq_trn.npqsys = 'FA'
          LET g_npq_trn.npq00  = 11
          LET g_npq_trn.npq01  = l_npp01      #No.9057
          LET g_npq_trn.npq011 = 0            #No.9057
          LET g_npq_trn.npq02  = 1
          LET g_npq_trn.npq03  = g_fcx.fcx091
          LET g_npq_trn.npq04  = ''
          LET g_npq_trn.npq05  = ''
          LET g_npq_trn.npq06  = 1
          LET g_npq_trn.npq07f = g_fcx.fcx06
          LET g_npq_trn.npq07  = g_fcx.fcx06
          LET g_npq_trn.npq08  = ''
          LET g_npq_trn.npq11  = ''
          LET g_npq_trn.npq12  = ''
          LET g_npq_trn.npq13  = ''
          LET g_npq_trn.npq14  = ''
          LET g_npq_trn.npq15  = ''
          LET g_npq_trn.npq21  = ''
          LET g_npq_trn.npq22  = ''
          LET g_npq_trn.npq23  = ''
          LET g_npq_trn.npq24  = g_aza.aza17
          LET g_npq_trn.npq25  = 1
          LET g_npq_trn.npq26  = ''
          LET g_npq_trn.npq27  = ''
          LET g_npq_trn.npq28  = ''
          LET g_npq_trn.npq29  = ''
          LET g_npq_trn.npq30  = ''
          LET g_npq_trn.npqtype = '1'
          LET g_npq_trn.npqlegal = g_legal  #FUN-980003 add
        #FUN-D10065--add--str--
        CALL s_def_npq3(g_bookno,g_npq_trn.npq03,g_prog,g_npq_trn.npq01,'','')
        RETURNING g_npq_trn.npq04
        #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq_trn.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq_trn.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq_trn.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
        INSERT INTO npq_file VALUES(g_npq_trn.*)
          IF STATUS THEN 
#            CALL cl_err3("ins","npq_file",g_npq_trn.npqsys,g_npq_trn.npq01,STATUS,"","in21npq",1)              #No.FUN-660136 #No.FUN-710028
             LET g_showmsg = g_npq_trn.npq01,g_npq_trn.npq011,g_npq_trn.npq02,g_npq_trn.npqsys,g_npq_trn.npq00  #No.FUN-710028
             CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'in21npq',STATUS,1)                      #No.FUN-710028
          LET g_success = 'N'
       END IF
    #--貸-----------------------------------------------
          LET g_npq_trn.npq02  = 2
          LET g_npq_trn.npq03  = g_fcx.fcx101
          LET g_npq_trn.npq06  = 2
       #FUN-D10065--add--str--
       LET g_npq_trn.npq04  = NULL
       CALL s_def_npq3(g_bookno,g_npq_trn.npq03,g_prog,g_npq_trn.npq01,'','')
       RETURNING g_npq_trn.npq04
       #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq_trn.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq_trn.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq_trn.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
       INSERT INTO npq_file VALUES(g_npq_trn.*)
         IF STATUS THEN 
#           CALL cl_err3("ins","npq_file",g_npq_trn.npqsys,g_npq_trn.npq01,STATUS,"","in22npq",1)              #No.FUN-660136 #No.FUN-710028
            LET g_showmsg = g_npq_trn.npq01,g_npq_trn.npq011,g_npq_trn.npq02,g_npq_trn.npqsys,g_npq_trn.npq00  #No.FUN-710028
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'in22npq',STATUS,1)                      #No.FUN-710028
            LET g_success = 'N'
       END IF
     END IF
     #No.FUN-680028 --end
     CALL s_flows('3','',g_npq_trn.npq01,g_npp_trn.npp02,'N',g_npq_trn.npqtype,TRUE)   #No.TQC-B70021  
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    ##--------
    IF g_faa.faa26 = '1' THEN    #年利率
       LET g_nmm.nmm01 = l_syy
       LET g_nmm.nmm02 = l_smm
       LET g_nmm.nmm03 = g_faa.faa27
       SELECT SUM(fcx06) INTO g_nmm.nmm04 FROM fcx_file
        WHERE fcx02 = l_syy AND fcx03 = l_smm
       LET g_nmm.nmmacti = 'Y'
       LET g_nmm.nmmuser = g_user
       LET g_nmm.nmmgrup = g_grup 
       LET g_nmm.nmmmodu = g_user
       LET g_nmm.nmmdate = g_today
       LET g_nmm.nmmlegal = g_legal #FUN-980003 add
       UPDATE nmm_file SET nmm03=g_nmm.nmm03,
                           nmm04=g_nmm.nmm04,
                           nmmacti = g_nmm.nmmacti,
                           nmmgrup = g_nmm.nmmgrup,
                           nmmmodu = g_nmm.nmmmodu,
                           nmmdate = g_nmm.nmmdate
                     WHERE nmm01=l_syy
                       AND nmm02=l_smm
       IF STATUS =0 AND SQLCA.SQLERRD[3] =0 THEN
          LET g_nmm.nmmoriu = g_user      #No.FUN-980030 10/01/04
          LET g_nmm.nmmorig = g_grup      #No.FUN-980030 10/01/04
          INSERT INTO nmm_file VALUES(g_nmm.*)
          IF STATUS THEN
#            CALL cl_err('ins nmm:',STATUS,1)   #No.FUN-660136
#            CALL cl_err3("ins","nmm_file",l_syy,l_smm,STATUS,"","ins nmm:",1)  #No.FUN-660136 #No.FUN-710028
             LET g_showmsg = g_nmm.nmm01,"/",g_nmm.nmm02                        #No.FUN-710028
             CALL s_errmsg('nmm01,nmm02',g_showmsg,'ins nmm:',STATUS,1)         #No.FUN-710028
             LET g_success = 'N' 
          END IF
       END IF
    END IF
    #--------------------------------------------------------------
#NO.FUN-570144 MARK--
#    IF g_success = 'Y' THEN 
#       COMMIT WORK
#    ELSE 
#       ROLLBACK WORK
#    END IF
#    CALL cl_end(0,0)
#NO.FUN-570144 MARK--
END FUNCTION
