# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axcp310.4gl
# Descriptions...: 月底投入工時統計及分攤作業
# Date & Author..: 01/11/23 BY DS/P
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670037 06/07/13 By Sarah axcp310_dis()計算標準工時程式段,改成抓SUM(cam10),SUM(cam11)
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.CHI-940027 09/04/23 By ve007 制費分為5大類
# Modify.........: No.CHI-970021 09/08/21 By jan 拿掉cursor axcp310_cur1/ecb_cur
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_sql string,  #No.FUN-580092 HCN
        tm RECORD
             yy LIKE type_file.num5,           #No.FUN-680122 smallint,
             mm LIKE type_file.num5            #No.FUN-680122 smallint
           END RECORD
DEFINE g_row,g_col   LIKE type_file.num5           #No.FUN-680122 SMALLINT
DEFINE l_flag          LIKE type_file.chr1,                  #No.FUN-570153        #No.FUN-680122 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),               #是否有做語言切換 No.FUN-570153
       ls_date         STRING                  #->No.FUN-570153
#       l_time       LIKE type_file.chr8        #No.FUN-6A0146
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#->No.FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy    = ARG_VAL(1)                      
   LET tm.mm    = ARG_VAL(2)                      
   LET g_bgjob  = ARG_VAL(3)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570153 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#CHI-970021--mark--begin--
# LET g_sql=" SELECT caa04 FROM caa_file ",
#           "  WHERE caa01= ? ",        #成本中心
#           "    AND caa02= ? " CLIPPED #成本項目
# PREPARE axcp310_pre1 FROM g_sql
# DECLARE axcp310_cur1 CURSOR WITH HOLD FOR axcp310_pre1
 
# LET g_sql=" SELECT SUM(ecb19),SUM(ecb21) FROM ecb_file ",
#           "   WHERE ecb08= ? " CLIPPED  #成本中心
# PREPARE ecb_pre FROM g_sql
# DECLARE ecb_cur CURSOR WITH HOLD FOR ecb_pre
#CHI-970021--mark--end--
 
#NO.FUN-570153 mark--
#   LET g_row = 5 LET g_col = 28
 
#   OPEN WINDOW p310_w AT g_row,g_col WITH FORM "axc/42f/axcp310"  
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0)				# 
#   CLOSE WINDOW p310_w 
#NO.FUN-570153 mark--
 
#NO.FUN-570153 start--
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CLEAR FORM
         CALL p310_tm(0,0)
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            CALL axcp310()
            CALL s_showmsg()        #No.FUN-710027 
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
               CLOSE WINDOW p310_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p310_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL axcp310()
         CALL s_showmsg()        #No.FUN-710027 
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used('axcp310',g_time,2) RETURNING g_time  #FUN-570153   #No.FUN-6A0146
#->No.FUN-570153 ---end---
  #CLOSE axcp310_cur1  #CHI-970021
  #CLOSE ecb_cur       #CHI-970021
END MAIN
 
FUNCTION p310_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE   l_flag        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   DEFINE lc_cmd        LIKE type_file.chr1000         #No.FUN-680122 VARCHAR(500)          #No.FUN-570153
 
#->No.FUN-570153 ---start---
   LET g_row = 5 LET g_col = 28
 
   OPEN WINDOW p310_w AT g_row,g_col WITH FORM "axc/42f/axcp310"  
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
#->No.FUN-570153 ---end---
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.yy =g_ccz.ccz01  
      LET tm.mm =g_ccz.ccz02 
      LET g_bgjob = 'N'    #NO.FUN-570153
      DISPLAY BY NAME tm.yy,tm.mm
 
      #INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS 
      INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS   #NO.FUN-571053 
 
         AFTER FIELD yy
            IF tm.yy IS NULL THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.mm IS NULL THEN
               NEXT FIELD mm
            END IF
#No.TQC-720032 -- begin --
#            IF tm.mm < 1 OR tm.mm > 12 THEN
#               NEXT FIELD mm 
#            END IF
#No.TQC-720032 -- end --
 
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
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION locale #genero
#NO.FUN-570153 start--
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
#NO.FUN-570153 end---
            EXIT INPUT
 
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
 
      END INPUT
#NO.FUN-570153 start-
#->No.FUN-570153 ---start---   
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p310_w
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axcp310"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axcp310','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy CLIPPED ,"'",
                         " '",tm.mm CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp310',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p310_w
         EXIT PROGRAM
      END IF
    EXIT WHILE
#->No.FUN-570153 ---end--- 
  
#NO.FUN-570153 mark--
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#        CONTINUE WHILE
#      END IF
#
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 EXIT PROGRAM
#      END IF
#      IF cl_sure(21,21) THEN   #genero
#         BEGIN WORK 
#         LET g_success='Y'
#         CALL axcp310()
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#         END IF
#         IF l_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#NO.FUN-570153  END---
END WHILE
END FUNCTION
 
FUNCTION axcp310()
    DEFINE l_name1,l_name2    LIKE type_file.chr20,          #No.FUN-680122  VARCHAR(20),       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
            cae         RECORD LIKE cae_file.*,
            l_cal01     LIKE cal_file.cal01,
            l_cal02     LIKE cal_file.cal02,
            unit_cost   LIKE cae_file.cae05,
            p_sum       LIKE cae_file.cae05,
            l_sql       LIKE type_file.chr1000     # RDSQL STATEMENT   #No.FUN-680122 VARCHAR(600)
     DEFINE l_bdate     LIKE type_file.dat         #CHI-9A0021 add
     DEFINE l_edate     LIKE type_file.dat         #CHI-9A0021 add
     DEFINE l_correct   LIKE type_file.chr1        #CHI-9A0021 add
 
     LET l_sql=" SELECT * FROM cae_file ",
               "  WHERE cae01='",tm.yy,"'  AND cae02='",tm.mm,"' " CLIPPED
     PREPARE axcp310_pre FROM l_sql 
     IF STATUS THEN CALL cl_err('axcp310_pre',STATUS,1) LET g_success='N' END IF 
     DECLARE axcp310_cur CURSOR FOR axcp310_pre 
     IF STATUS THEN CALL cl_err('axcp310_cur',STATUS,1) LET g_success='N' END IF 
 
     CALL s_showmsg_init()   #No.FUN-710027    
     FOREACH axcp310_cur INTO cae.* 
       IF STATUS THEN 
#          CALL cl_err('axcp310_for',STATUS,1)          #No.FUN-710027
          CALL s_errmsg('','','axcp310_for',STATUS,1)   #No.FUN-710027
          LET g_success='N' 
          EXIT FOREACH 
       END IF
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
 
#No.MOD-580322--begin                                                                                                              
       IF g_bgjob = 'N' THEN  #NO.FUN-570153 
           MESSAGE cl_getmsg('axc-197',g_lang),cae.cae03,' ',cae.cae04                                                                  
       END IF
#      MESSAGE "成本中心/成本項目:", cae.cae03,' ',cae.cae04                                                                        
#No.MOD-580322--end  
       CALL ui.Interface.refresh()
       IF cae.cae05 IS NULL THEN LET cae.cae05=0 END IF  
       #統計指標總數
       CALL axcp310_dis(cae.*) RETURNING p_sum
       #----------------------
       #單位成本  = 成本  /分攤基準指標總數
       LET unit_cost=cae.cae05/p_sum 
       IF unit_cost IS NULL THEN LET unit_cost=0 END IF 
       #------------------------
       UPDATE cae_file SET cae06=p_sum,cae07=unit_cost 
        WHERE cae01=cae.cae01 AND cae02=cae.cae02
          AND cae03=cae.cae03 AND cae04=cae.cae04 AND cae08=cae.cae08 
          AND cae041 = cae.cae041             #No.CHI-940027
       IF STATUS THEN 
#         CALL cl_err('UPD cae error!',STATUS,1)    #No.FUN-660127
#No.FUN-710027--begin 
#          CALL cl_err3("upd","cae_file",cae.cae01,cae.cae02,STATUS,"","UPD cae error!",1)   #No.FUN-660127
          LET g_showmsg=cae.cae01,"/",cae.cae02
          CALL s_errmsg('cae01,cae02',g_showmsg,'upd cae error!',STATUS,1)
          LET g_success='N' 
#          EXIT FOREACH 
          CONTINUE FOREACH
#No.FUN-710027--end
       END IF
     END FOREACH   
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
    #當月起始日與截止日
     CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add

     #將當月的每日工時檔確認 
     DECLARE cal_cur CURSOR FOR 
      SELECT cal01,cal02 FROM cal_file 
      #WHERE YEAR(cal01)=tm.yy AND MONTH(cal01)=tm.mm #CHI-9A0021
       WHERE cal01 BETWEEN l_bdate AND l_edate        #CHI-9A0021
     FOREACH cal_cur INTO l_cal01,l_cal02 
       IF STATUS THEN 
#          CALL cl_err('cal_for',STATUS,1)         #No.FUN-710027
          CALL s_errmsg('','','cal_for',STATUS,1)  #No.FUN-710027 
          LET g_success='N'    
         EXIT FOREACH 
      END IF 
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
 
      UPDATE cal_file SET calfirm='Y' WHERE cal01=l_cal01 AND cal02=l_cal02 
        IF STATUS THEN 
#          CALL cl_err('UPD calfirm',STATUS,1)     #No.FUN-660127
#No.FUN-710027--begin 
#          CALL cl_err3("upd","cal_file",l_cal01,l_cal02,STATUS,"","UPD calfirm",1)   #No.FUN-660127
          LET g_showmsg= l_cal01,"/",l_cal02 
          CALL s_errmsg('cal02,cal02',g_showmsg,'upd calfirm',STATUS,1)
          LET g_success='N'
#          EXIT FOREACH 
          CONTINUE FOREACH
#No.FUN-710027--end
      END IF 
     END FOREACH 
#No.FUN-710027--begin 
     IF g_totsuccess="N" THEN
          LET g_success="N"
     END IF 
#No.FUN-710027--end
 
END FUNCTION
 
FUNCTION axcp310_dis(p_cae) 
   DEFINE p_cae    RECORD LIKE cae_file.* 
   DEFINE l_sum    LIKE cae_file.cae05 
   DEFINE l_ecb19  LIKE ecb_file.ecb19 
   DEFINE l_ecb21  LIKE ecb_file.ecb21 
   DEFINE l_caa04  LIKE caa_file.caa04 
   DEFINE l_stander_tim LIKE ecb_file.ecb19 
   DEFINE l_qty         LIKE cam_file.cam07           #No.FUN-680122 DEC(15,3)
   DEFINE l_cac03       LIKE cac_file.cac03 
   DEFINE l_ima58       LIKE ima_file.ima58    #CHI-970021
   DEFINE l_ima912      LIKE ima_file.ima912   #CHI-970021
   DEFINE l_bdate       LIKE type_file.dat     #CHI-9A0021 add
   DEFINE l_edate       LIKE type_file.dat     #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1    #CHI-9A0021 add
 
  #當月起始日與截止日
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
 
   CASE p_cae.cae08 
    WHEN '1' #實際工時
              #CHI-970021--begin--mod--
              #SELECT SUM(cam08) INTO l_sum  FROM cam_file 
              # WHERE YEAR(cam01)=tm.yy AND MONTH(cam01)=tm.mm 
              #   AND cam02=p_cae.cae03 
              SELECT SUM(srl05) INTO l_sum FROM srk_file,srl_file
              #WHERE YEAR(srk01)=tm.yy AND MONTH(srk01)=tm.mm     #CHI-9A0021
               WHERE srk01 BETWEEN l_bdate AND l_edate            #CHI-9A0021
                 AND srk02 = p_cae.cae03
                 AND srkfirm = 'Y'
                 AND srl01 = srk01 
                 AND srl02 = srk02
              #CHI-970021--end--mod--
    WHEN '2' #標準工時  約當產量
             #start FUN-670037 modify
             #SELECT SUM(cam07) INTO l_qty FROM cam_file 
             # WHERE YEAR(cam01)=tm.yy AND MONTH(cam01)=tm.mm 
             #   AND cam02=p_cae.cae03  
             #IF l_qty IS NULL THEN LET l_qty=0 END IF 
             #
             #CHI-970021--begin--mark--
             #OPEN axcp310_cur1 USING p_cae.cae03,p_cae.cae04 
             #FETCH axcp310_cur1 INTO l_caa04 
             #IF STATUS THEN CALL cl_err('axcp310_cur1',STATUS,1) 
             #    LET g_success='N'
             #END IF 
             #CLOSE axcp310_cur1 
             #CHI-970021--end--mark--
             #
             ##統計總標準工時
             #OPEN ecb_cur USING p_cae.cae03 
             #FETCH ecb_cur INTO l_ecb19,l_ecb21 
             #IF STATUS THEN CALL cl_err('ecb_cur',STATUS,1) 
             #   LET g_success='N' END IF 
             #CLOSE ecb_cur   
             #IF l_ecb19 IS NULL THEN LET l_ecb19=0 END IF 
             #IF l_ecb21 IS NULL THEN LET l_ecb21=0 END IF 
             #CASE l_caa04 
             #  WHEN '1'  LET l_stander_tim=l_ecb19    #人工  
             #  WHEN '2'  LET l_stander_tim=l_ecb21    #製費   
             #  EXIT CASE 
             #END CASE 
             #LET l_sum=l_qty*l_stander_tim
             #CHI-970021--begin--add--
             SELECT SUM(srl06) INTO l_qty FROM srk_file,srl_file
             #WHERE YEAR(srk01)=tm.yy AND MONTH(srk01)=tm.mm  #CHI-9A0021
              WHERE srk01 BETWEEN l_bdate AND l_edate         #CHI-9A0021
               AND srk02 = p_cae.cae03
               AND srkfirm = 'Y'
               AND srl01 = srk01 
               AND srl02 = srk02
             IF l_qty IS NULL THEN LET l_qty=0 END IF
             SELECT SUM(ima58),SUM(ima912) INTO l_ima58,l_ima912
               FROM ima_file
              WHERE ima34 = p_cae.cae03
             IF l_ima58  IS NULL THEN LET l_ima58=0  END IF
             IF l_ima912 IS NULL THEN LET l_ima912=0 END IF
             CASE p_cae.cae041
                 WHEN '1' LET l_stander_tim=l_ima58     #人工
                 OTHERWISE LET l_stander_tim=l_ima912    #制費1-5
              END CASE 
             LET l_sum=l_qty*l_stander_tim
             #CHI-970021--end--add--
             #CHI-970021--begin--mark--
             ##CASE l_caa04        #CHI-970021
             #CASE p_cae.cae041   #CHI-970021 
             #   WHEN '1'    #人工  
             #       SELECT SUM(cam10) INTO l_sum FROM cam_file
             #        WHERE YEAR(cam01)=tm.yy AND MONTH(cam01)=tm.mm
             #          AND cam02=p_cae.cae03
             ##   WHEN '2'    #製費   
             #   OTHERWISE   #製費1-5   #NO.CHI-940027
             #       SELECT SUM(cam11) INTO l_sum FROM cam_file
             #        WHERE YEAR(cam01)=tm.yy AND MONTH(cam01)=tm.mm
             #          AND cam02=p_cae.cae03
             #END CASE 
             #CHI-970021--end--mark--
             #end FUN-670037 modify
    WHEN '3'                                    #總產出數量 
              #CHI-970021--begin--mod--
              #SELECT SUM(cam07) INTO l_qty FROM cam_file 
              # WHERE YEAR(cam01)=tm.yy AND MONTH(cam01)=tm.mm 
              #   AND cam02=p_cae.cae03  
              SELECT SUM(srl06) INTO l_qty 
                FROM srk_file,srl_file
              #WHERE YEAR(srk01)=tm.yy AND MONTH(srk01)=tm.mm  #CHI-9A0021
               WHERE srk01 BETWEEN l_bdate AND l_edate         #CHI-9A0021
                 AND srk02 = p_cae.cae03
                 AND srkfirm = 'Y'
                 AND srl01 = srk01 
                 AND srl02 = srk02
              #CHI-970021--end--mod--
              
              IF l_qty IS NULL THEN LET l_qty=0 END IF 
              SELECT cac03 INTO l_cac03 FROM cac_file 
               WHERE cac01=p_cae.cae03 AND cac02=p_cae.cae04 
              IF l_cac03 IS NULL THEN LET l_cac03=0 END IF 
              LET l_sum=l_qty*l_cac03/100 
       EXIT CASE 
   END CASE 
   IF l_sum IS NULL THEN LET l_sum=0 END IF 
   RETURN l_sum 
END FUNCTION 
