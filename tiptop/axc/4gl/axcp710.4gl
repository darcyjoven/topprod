# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp710.4gl
# Descriptions...: 生產日報工時轉成會每日工時作業
# Date & Author..: 99/04/30 By ChiaYi FOR TIPTOP 4.00 
# Modify ........: 01/11/14 By DS/P   
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file 
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次作業修改
# Modify.........: No.FUN-660160 06/06/23 By Sarah 計算約當數量需考慮轉換率
# Modify.........: No.FUN-670037 06/07/13 By Sarah 增加計算cam10,cam11
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/19 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.MOD-750146 07/06/07 By pengu 調整成本中心的抓法
# Modify.........: NO.TQC-790100 07/09/17 BY Joe 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A60080 10/07/15 By destiny              
# Modify.........: No:FUN-A60095 10/07/26 By kim GP5.25平行工藝
# Modify.........: No:FUN-A90065 10/10/19 By jan 新增確認碼欄位
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-C20382 12/02/22 By xujing 修正l_name1,l_name2 LIKE type_file.chr20
# Modify.........: No:MOD-C20186 12/03/06 By ck2yuan 當報工單分多次報,第二次後cah07,cah08累加後update
# Modify.........: No.FUN-C80092 12/12/05 By lixh1 增加寫入日誌功能

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          yy LIKE type_file.num5,          #No.FUN-680122 SMALLINT,
          mm LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          check LIKE type_file.chr1        #FUN-A90065
          END RECORD,
      g_caf11 LIKE caf_file.caf11,
      g_caf12 LIKE caf_file.caf12,
      g_shi  RECORD LIKE shi_file.*,
      g_shd  RECORD LIKE shd_file.* 
 
DEFINE  g_row,g_col   LIKE type_file.num5           #No.FUN-680122 SMALLINT
DEFINE  g_flag        LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE  g_change_lang LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)         #FUN-570153
DEFINE  g_ccifirm     LIKE type_file.chr1           #FUN-A90065
DEFINE  g_cka00       LIKE cka_file.cka00           #FUN-C80092
DEFINE  l_msg         STRING                        #FUN-C80092

#     DEFINEl_time  LIKE type_file.chr8            #No.FUN-6A0146
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#FUN-570153 --start--
   IF s_shut(0) THEN RETURN END IF
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy   = ARG_VAL(1)
   LET tm.mm   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
 
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
#NO.FUN-570153 end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570153 mark--
#   LET g_row = 5 LET g_col = 36
 
#   OPEN WINDOW p710_w AT g_row,g_col WITH FORM "axc/42f/axcp710"  
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
# Prog. Version..: '5.30.06-13.03.12(0,0)				# 
#NO.FUN-570153 mark--
 
#NO.FUN-570153 start--
#   CALL cl_used('axcp710',l_time,1) RETURNING l_time         #FUN-570153  #No.FUN-6A0146
#   CALL cl_used('axcp710',g_time,1) RETURNING g_time        #No.FUN-6A0146
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p710_tm(0,0)
         IF cl_sure(20,20) THEN
   #FUN-C80092 -------------Begin---------------
            LET l_msg = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";",
                        "tm.check = '",tm.check,"'",";","g_bgjob = '",g_bgjob,"'"
            CALL s_log_ins(g_prog,tm.yy,tm.mm,'',l_msg)
                 RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
            CALL cl_wait()
            BEGIN WORK	
            CALL axcp710()
            CALL s_showmsg()        #No.FUN-710027
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
               CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
            END IF
 
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p710_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p710_w
      ELSE
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";",
                     "tm.check = '",tm.check,"'",";","g_bgjob = '",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         BEGIN WORK	
         CALL axcp710()
         CALL s_showmsg()        #No.FUN-710027
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#   CALL cl_used('axcp710',l_time,2) RETURNING l_time        #No.FUN-6A0146
#   CALL cl_used('axcp710',g_time,2) RETURNING g_time        #No.FUN-6A0146
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
#NO.FUN-570153 end---
END MAIN
 
FUNCTION p710_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
#     DEFINE   l_time   LIKE type_file.chr8            #No.FUN-6A0146
   DEFINE   lc_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(500)        #FUN-570153
 
#NO.FUN-570153 start--
   LET g_row = 5 LET g_col = 36
 
   OPEN WINDOW p710_w AT g_row,g_col WITH FORM "axc/42f/axcp710"  
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
#NO.FUN-570153 end---
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.yy = g_ccz.ccz01 
      LET tm.mm = g_ccz.ccz02
      LET tm.check = 'N'   #FUN-A90065
      LET g_ccifirm = 'N'  #FUN-A90065

      LET g_bgjob = 'N'                         #FUN-570153
 
#     INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS 
      INPUT BY NAME tm.yy,tm.mm,tm.check,g_bgjob WITHOUT DEFAULTS    #FUN-570153 #FUN-A90065
 
         AFTER FIELD yy
            IF tm.yy IS NULL THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
            IF tm.mm IS NULL THEN
               NEXT FIELD mm 
            END IF
            IF tm.mm < 1 OR tm.mm > 12 THEN
               NEXT FIELD mm 
            END IF

         #FUN-A90065--begin--add--------
         AFTER FIELD check
            IF tm.check = 'Y' THEN
               LET g_ccifirm = 'Y'
            END IF
         #FUN-A90065--end--add---------

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
#NO.FUN-570153 end--
            LET g_change_lang = TRUE               #FUN-570153
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
#NO.FUN-570153 mark-
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 EXIT PROGRAM
#      END IF
#      IF cl_sure(20,20) THEN
#         CALL cl_wait()
#         BEGIN WORK	
#         LET g_success='Y'
#         CALL axcp710()
#           CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#         END IF
#         IF g_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#        #CALL cl_end(0,0)
#      END IF
#NO.FUN-570153 mark---
 
#NO.FUN-570153 start--
      IF g_change_lang THEN                           #FUN-570153
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         LET g_change_lang = FALSE                    #FUN-570153
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p710_w               #FUN-570153
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
#FUN-570153 --start--
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axcp710'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axcp710','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp710',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p710_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#NO.FUN-570153 end--
#   ERROR ""
#   CLOSE WINDOW p710_w
END FUNCTION
 
 
FUNCTION axcp710()
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0146
DEFINE    l_gen03       LIKE gen_file.gen03,
          l_eca03       LIKE eca_file.eca03,    #No.MOD-750146 add
          l_sql		LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(500)
          l_cam06       LIKE cam_file.cam06,
          l_sfb98       LIKE sfb_file.sfb98,
          l_ecm03       LIKE ecm_file.ecm03,
          l_ecm04       LIKE ecm_file.ecm04,
          l_ecm58       LIKE ecm_file.ecm58,   #FUN-660160 add
          l_ecm59       LIKE ecm_file.ecm59,   #FUN-660160 add
          l_ima55       LIKE ima_file.ima55,   #FUN-660160 add
          shb03_max     LIKE shb_file.shb03,
          l_c1,l_c2     LIKE type_file.num10,        #No.FUN-680122 INT,
          l_name1,l_name2     LIKE type_file.chr20,        #No.FUN-680122 VARCHAR(12),   #TQC-C20382
          l_caf   RECORD LIKE caf_file.*,
          shb2           RECORD
                 shb05  LIKE shb_file.shb05,
                 sfb05  LIKE sfb_file.sfb05,
                 shb06  LIKE shb_file.shb06,
                 shb081 LIKE shb_file.shb081,
                 shb012 LIKE shb_file.shb012 #NO.FUN-A60080
                       END RECORD,
          shb  RECORD LIKE shb_file.* ,
          cal           RECORD LIKE cal_file.*,
          cam           RECORD LIKE cam_file.* 
   DEFINE l_bdate       LIKE type_file.dat     #CHI-9A0021 add
   DEFINE l_edate       LIKE type_file.dat     #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1    #CHI-9A0021 add
 
    #當月起始日與截止日
     CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
 
    #CHI-9A0021 -- begin
    #DELETE FROM cal_file WHERE YEAR(cal01)=tm.yy AND MONTH(cal01)= tm.mm
    #DELETE FROM cam_file WHERE YEAR(cam01)=tm.yy AND MONTH(cam01)= tm.mm
     DELETE FROM cal_file WHERE cal01 BETWEEN l_bdate AND l_edate
     DELETE FROM cam_file WHERE cam01 BETWEEN l_bdate AND l_edate
    #CHI-9A0021 -- end
     DELETE FROM caf_file WHERE caf02=tm.yy AND caf03= tm.mm
     DELETE FROM cag_file WHERE cag02=tm.yy AND cag03= tm.mm
     DELETE FROM cah_file WHERE cah02=tm.yy AND cah03= tm.mm
     
     IF sqlca.sqlcode THEN 
        IF g_bgjob = 'N' THEN    #FUN-570153
             ERROR "DELETE FROM cal_file ERROR:",sqlca.sqlcode 
        END IF
        LET g_success='N'
        RETURN
       # ROLLBACK WORK
       # EXIT PROGRAM
     END IF 
 
     #宣告工單轉出明細檔游標
     LET l_sql=" SELECT * FROM shi_file WHERE shi01=? " CLIPPED
     PREPARE shi_pre FROM l_sql 
     IF STATUS THEN 
        CALL cl_err('shi_pre',STATUS,1) 
        LET g_success='N' 
        RETURN
     END IF 
     DECLARE shi_cur CURSOR FOR shi_pre  
     IF STATUS THEN 
        CALL cl_err('shi_cur',STATUS,1) 
        LET g_success='N' 
        RETURN
     END IF 
   
     #宣告下線資料檔游標
     LET l_sql=" SELECT * FROM shd_file WHERE shd01 =? " CLIPPED
     PREPARE shd_pre FROM l_sql 
     IF STATUS THEN 
        CALL cl_err('shd_pre',STATUS,1) 
        LET g_success='N' 
        RETURN
     END IF 
     DECLARE shd_cur CURSOR FOR shd_pre  
     IF STATUS THEN 
        CALL cl_err('shd_cur',STATUS,1) 
        LET g_success='N' 
        RETURN
     END IF 
 
    #start FUN-660160 modify
    #LET l_name1='axcp7101.txt'  
    #LET l_name2='axcp7102.txt'  
     CALL cl_outnam('axcp710') RETURNING l_name1
     CALL cl_outnam('axcp710') RETURNING l_name2
    #end FUN-660160 modify
 
     START REPORT p710_rep1 TO l_name1  
     START REPORT p710_rep2 TO l_name2  
 
     DELETE FROM cam_file 
    #WHERE YEAR(cam01) = tm.yy AND MONTH(cam01) = tm.mm  #CHI-9A0021
     WHERE cam01 BETWEEN l_bdate AND l_edate             #CHI-9A0021
     IF sqlca.sqlcode THEN 
        IF g_bgjob = 'N' THEN    #FUN-570153
            ERROR "DELETE FROM cam_file ERROR:",sqlca.sqlcode 
        END IF
        LET g_success='N'
        RETURN
        #ROLLBACK WORK
        #EXIT PROGRAM
     END IF 
 
     INITIALIZE shb.* TO NULL
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
     LET l_sql="SELECT UNIQUE shb05,sfb05,shb06,shb081,shb012 FROM shb_file,sfb_file ",  #NO.FUN-A60080 add shb012
              #CHI-9A0021 --begin
              #" WHERE YEAR(shb03)  = ",tm.yy,
              #"   AND MONTH(shb03) = ",tm.mm,
               " WHERE shb03 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
              #CHI-9A0021 --end 
               "   AND shb05=sfb01 ",
               "   AND shbconf = 'Y'",    #FUN-A70095
        #若該工單本月有投入工時,但結案日壓到上個月
        #此會影響到單位成本的計算,
        #故不將工時納入
               "  GROUP BY shb05,sfb05,shb06,shb081,shb012 " CLIPPED  #FUN-A60095
     PREPARE p710_prepare FROM l_sql
     DECLARE p710_cur CURSOR FOR p710_prepare
     CALL s_showmsg_init()   #No.FUN-710027
     FOREACH p710_cur INTO shb2.*
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
         IF sqlca.sqlcode THEN 
#           CALL cl_err('',STATUS,0)         #No.FUN-710027  
            CALL s_errmsg('','','',STATUS,0) #No.FUN-710027
            LET g_success='N'
            RETURN
            #EXIT PROGRAM
         END IF 
         SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file 
          WHERE ecm01=shb2.shb05 
            AND ecm012=shb2.shb012  #NO.FUN-A60080
         IF cl_null(l_ecm03) THEN 
            LET g_success='N' 
#           EXIT FOREACH               #No.FUN-710027
           CONTINUE FOREACH            #No.FUN-710027
         END IF 
 
         #重工轉入量
         SELECT SUM(shb113) INTO g_caf11 FROM shb_file 
          WHERE shb05=shb2.shb05  AND shb12=shb2.shb06  
           #AND YEAR(shb03)=tm.yy  AND MONTH(shb03)=tm.mm #CHI-9A0021
            AND shb03 BETWEEN l_bdate AND l_edate         #CHI-9A0021
            AND shb012=shb2.shb012 #NO.FUN-A60080
            AND shbconf = 'Y'      #FUN-A70095
         IF g_caf11 IS NULL THEN LET g_caf11=0 END IF 
         #----------------------------------------------
         SELECT SUM(shi05) INTO g_caf12  #工單轉入量
           FROM shi_file,shb_file WHERE shi01=shb01 
           #AND YEAR(shb03)=tm.yy AND MONTH(shb03)=tm.mm  #CHI-9A0021
            AND shb03 BETWEEN l_bdate AND l_edate         #CHI-9A0021
            AND shi02=shb2.shb05  AND shi03=shb2.shb081 
            AND shi04=shb2.shb06 
            AND shi012=shb2.shb012 #NO.FUN-A60080
            AND shbconf = 'Y'      #FUN-A70095
         IF g_caf12 IS NULL THEN LET g_caf12=0 END IF 
 
         LET l_caf.caf01=shb2.shb05       #工單  
         LET l_caf.caf02=tm.yy    
         LET l_caf.caf03=tm.mm    
         LET l_caf.caf04=shb2.sfb05     #料號
         LET l_caf.caf05=shb2.shb06     #製程序號
         LET l_caf.caf06=shb2.shb081    #作業編號
         SELECT ecm06 INTO l_caf.caf07 FROM ecm_file 
          WHERE ecm01=shb2.shb05 AND ecm03=shb2.shb06 
          AND ecm012=shb2.shb012 #NO.FUN-A60080
         IF l_caf.caf07 IS NULL THEN LET l_caf.caf07=0 END IF  #工作中心編號
         LET l_caf.caf10=0          #盤點量
         LET l_caf.caf11=g_caf11    #工單轉入量
         LET l_caf.caf12=g_caf12    #重工轉入量
         SELECT SUM(shb111),SUM(shb115),SUM(shb113),SUM(shb112),SUM(shb114),
                SUM(shb17) 
           INTO l_caf.caf13,l_caf.caf14,l_caf.caf15,l_caf.caf16,l_caf.caf17,
                l_caf.caf18    
           FROM shb_file  WHERE shb05=shb2.shb05 AND shb06=shb2.shb06 
           #AND YEAR(shb03)=tm.yy AND MONTH(shb03)=tm.mm  #CHI-9A0021 
            AND shb03 BETWEEN l_bdate AND l_edate         #CHI-9A0021
            AND shb012=shb2.shb012 #NO.FUN-A60080
            AND shbconf = 'Y'  #FUN-A70095
        #start FUN-660160 add
         SELECT ecm59 INTO l_ecm59 FROM ecm_file          
          WHERE ecm01 = shb2.shb05 AND ecm03 = shb2.shb06
            AND ecm012 =shb2.shb012  #NO.FUN-A60080     
         LET l_caf.caf13 = l_caf.caf13 * l_ecm59       
         LET l_caf.caf14 = l_caf.caf14 * l_ecm59      
        #end FUN-660160 add
 
         SELECT SUM(shb111) INTO l_caf.caf19 FROM shb_file 
          WHERE shb05=shb2.shb05 AND shb06=shb2.shb06 
           #AND YEAR(shb03)=tm.yy AND MONTH(shb03)=tm.mm  #CHI-9A0021
            AND shb03 BETWEEN l_bdate AND l_edate         #CHI-9A0021
            AND shb012=shb2.shb012 #NO.FUN-A60080
            AND (shb14 !='' AND shb14 !=' ')  
            AND shbconf = 'Y'   #FUN-A70095
         IF cl_null(l_caf.caf19) THEN LET l_caf.caf19=0 END IF   #委外完工量
 
         SELECT MIN(shb03) INTO l_caf.cafdate #製程首站報工日
           FROM shb_file WHERE shb05=shb2.shb05 AND shb06=shb2.shb06
           AND shb012=shb2.shb012 #NO.FUN-A60080
           AND shbconf = 'Y'  #FUN-A70095 
         ##NO.TQC-790100 START--------------------------
         ##IF STATUS=-239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         ##NO.TQC-790100 END----------------------------
#        CALL cl_err('SEL MIN(shb03)',STATUS,1)                              #No.FUN-710027 
         LET g_showmsg=shb2.shb05,"/",shb2.shb06                             #No.FUN-710027
         CALL s_errmsg('shb05,shb06',g_showmsg,'SEL MIN(shb03)',STATUS,1)    #No.FUN-710027
            LET g_success='N'
            EXIT FOREACH                
         END IF 
        
         SELECT MAX(shb03) INTO shb03_max  #該站最後報工日
           FROM shb_file WHERE shb05=shb2.shb05 AND shb06=shb2.shb06
           AND shb012=shb2.shb012 #NO.FUN-A60080
           AND shbconf = 'Y'  #FUN-A70095
         ##NO.TQC-790100 START--------------------------
         ##IF STATUS=-239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         ##NO.TQC-790100 END----------------------------
#           CALL cl_err('SEL MAX(shb03)',STATUS,1)         #No.FUN-710027  
            LET g_showmsg=shb2.shb05,"/",shb2.shb06        #No.FUN-710027
            CALL s_errmsg('shb05,shb06',g_showmsg,'SEL MAX(shb03)',STATUS,1) #No.FUN-710027
            LET g_success='N'
            EXIT FOREACH 
         END IF
         LET l_c1=(DATE(shb03_max)-30000)*24*60  #以分為準(怕數值太大,故減2000)
      
         SELECT MAX(shb031[1,2]*24+shb031[4,5]) INTO l_c2 FROM shb_file 
          WHERE shb05=shb2.shb05 AND shb06=shb2.shb06 AND shb03=shb03_max  
            AND shb012=shb2.shb012 #NO.FUN-A60080
            AND shbconf = 'Y'  #FUN-A70095
         LET l_caf.caftime=l_c1+l_c2 
         
        #LET l_caf.cafplant = g_plant #FUN-980009    #FUN-A50075
         LET l_caf.caflegal = g_legal #FUN-980009
         #NO.FUN-A60080--begin
         LET l_caf.caf012=shb2.shb012
         IF cl_null(l_caf.caf012) THEN 
            LET l_caf.caf012=' '
         END IF 
         #NO.FUN-A60080--end

         INSERT INTO caf_file VALUES(l_caf.*) 
         ##NO.TQC-790100 START--------------------------
         ##IF STATUS=-239 THEN  #資料重複
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         ##NO.TQC-790100 END----------------------------
          UPDATE caf_file SET caf11=l_caf.caf11,
                              caf12=l_caf.caf12, 
                              caf13=l_caf.caf13, 
                              caf14=l_caf.caf14, 
                              caf15=l_caf.caf15, 
                              caf16=l_caf.caf16, 
                              caf17=l_caf.caf17, 
                              caf18=l_caf.caf18, 
                              caf19=l_caf.caf19, 
                              cafdate=l_caf.cafdate,
                              caftime=l_caf.caftime 
             WHERE caf01=l_caf.caf01 
               AND caf02=l_caf.caf02 
               AND caf03=l_caf.caf03 
               AND caf05=l_caf.caf05 
               AND caf06=l_caf.caf06 
               AND caf012=l_caf.caf012 #NO.FUN-A60080
           IF STATUS <0 THEN 
#             CALL cl_err('UPD caf_file !',STATUS,1) #No.FUN-710027
              LET g_showmsg=l_caf.caf01,"/",l_caf.caf02,"/",l_caf.caf03,"/",l_caf.caf05,"/",l_caf.caf06  #No.FUN-710027 
              CALL s_errmsg('caf01,caf02,caf03,caf05,caf06',g_showmsg,'UPD caf_file !',STATUS,1)         #No.FUN-710027                  
              LET g_success='N'
              EXIT FOREACH
           END IF 
         ELSE 
           IF STATUS < 0 THEN 
#             CALL cl_err('INS caf1 error!',STATUS,1)  #No.FUN-710027
              LET g_showmsg=l_caf.caf01,"/",l_caf.caf02,"/",l_caf.caf03,"/",l_caf.caf05,"/",l_caf.caf06  #No.FUN-710027              
              CALL s_errmsg('caf01,caf02,caf03,caf05,caf06',g_showmsg,'UPD caf_file !',STATUS,1)         #No.FUN-710027   
              LET g_success='N'
              EXIT FOREACH
           END IF 
         END IF 
         #新增本站轉出在製月結檔End-----------------------------
     END FOREACH 
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
     #DECLARE p710_cur2 CURSOR FOR 
     LET l_sql=" SELECT shb_file.*,sfb98 FROM shb_file,sfb_file  ", 
              #"  WHERE YEAR(shb03)=",tm.yy," AND MONTH(shb03)=",tm.mm,   #CHI-9A0021
               "  WHERE shb03 BETWEEN '",l_bdate,"' AND '",l_edate,"'",   #CHI-9A0021
               "    AND shbconf = 'Y' ",      #FUN-A70095
               "    AND shb05=sfb01 " CLIPPED
     PREPARE p710_pre2 FROM l_sql 
     DECLARE p710_cur2 CURSOR FOR p710_pre2 
     FOREACH p710_cur2 INTO shb.*,l_sfb98  
       IF STATUS THEN 
#         CALL cl_err('p710_for2',STATUS,1)          #No.FUN-710027
          CALL s_errmsg('','','p710_for2',STATUS,1)  #No.FUN-710027
          LET g_success='N' 
          EXIT FOREACH 
       END IF 
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
       #新增cag_file工單轉入資料檔
       OPEN shi_cur USING shb.shb01  
       IF STATUS THEN 
#         CALL cl_err('shi_cur open',STATUS,1)         #No.FUN-710027
          CALL s_errmsg('','','shi_cur open',STATUS,1) #No.FUN-710027 
          LET g_success='N' 
          EXIT FOREACH 
       END IF 
       FOREACH shi_cur INTO g_shi.* 
         IF STATUS THEN 
#           CALL cl_err('shi_for',STATUS,1)            #No.FUN-710027
            CALL s_errmsg('','','shi_for',STATUS,1)    #No.FUN-710027
            LET g_success='N'  
            EXIT FOREACH 
         END IF 
         OUTPUT TO REPORT p710_rep1(g_shi.*,shb.*) 
       END FOREACH 
       CLOSE shi_cur 
 
       #新增cah_file工單下線資料
       OPEN shd_cur USING shb.shb01 
       IF STATUS THEN 
#         CALL cl_err('shd_for',STATUS,1)               #No.FUN-710027
          CALL s_errmsg('','','shd_for',STATUS,1)       #No.FUN-710027 
          LET g_success='N' 
          EXIT FOREACH 
       END IF 
       FOREACH shd_cur INTO g_shd.* 
           IF STATUS THEN 
#             CALL cl_err('shd_for',STATUS,1)            #No.FUN-710027
              CALL s_errmsg('','','shd_for',STATUS,1)    #No.FUN-710027 
              LET g_success='N'  
              EXIT FOREACH 
           END IF 
           OUTPUT TO REPORT p710_rep2(g_shd.*,shb.*) 
         END FOREACH 
         CLOSE shd_cur 
         IF g_bgjob = 'N' THEN    #FUN-570153
             MESSAGE cl_getmsg('axc-198',g_lang),shb.shb01    #No.MOD-580322 
         END IF
         initialize cal.* to null
         initialize cam.* to null
         LET l_gen03 = ''
         LET cal.cal01 = shb.shb03  #報工日期
        #-----------No.MOD-750146 add
         LET l_eca03 = ' '
         SELECT eca03 INTO l_eca03 FROM eca_file WHERE eca01=shb.shb07
        #-----------No.MOD-750146 end
         CASE
             #-----------No.MOD-750146 modify
             #WHEN g_ccz.ccz06='1' OR g_ccz.ccz06='2'
             #  LET cal.cal02 = l_sfb98   #l_gen03 部門
              WHEN g_ccz.ccz06 = '1'
                LET cal.cal02 = ' '
              WHEN g_ccz.ccz06 = '2'
                LET cal.cal02 = l_eca03
             #-----------No.MOD-750146 end
              WHEN g_ccz.ccz06 = '3'
                LET cal.cal02 = shb.shb081
              WHEN g_ccz.ccz06 = '4'
                LET cal.cal02 = shb.shb07
         END CASE
         LET cal.cal03 = ""         #備註
         LET cal.cal04 = ""         #NO USE
         LET cal.cal05 = 0          #工時合計
        #LET cal.calfirm = 'N'      #確認碼    
         LET cal.calfirm=g_ccifirm  #確認碼    #FUN-A90065
         LET cal.calinpd   = TODAY  #輸入日期                                
         LET cal.calacti   = 'Y'    #資料有效碼
         LET cal.caluser   = g_user #資料所有者
         LET cal.calgrup   = g_grup #資料所有群
         LET cal.calmodu   = ''     #資料更改者                              
         LET cal.caldate   = NULL   #最近修改日
        #LET cal.calplant  = g_plant #FUN-980009 add    #FUN-A50075
         LET cal.callegal  = g_legal #FUN-980009 add
     
         LET cam.cam01 = shb.shb03  #報工日期
         LET cam.cam02 = cal.cal02 
         #NO.FUN-A60080--begin
         LET cam.cam012=shb.shb012
         IF cam.cam012 IS NULL THEN 
            LET cam.cam012=' '
         END IF 
         #NO.FUN-A60080--end
         SELECT max(cam03) INTO cam.cam03 FROM cam_file  #序號
         WHERE cam01 = cam.cam01 AND cam02 = cam.cam02 
         IF cl_null(cam.cam03) OR (cam.cam03 = 0) THEN
            LET cam.cam03 = 1
         ELSE
            LET cam.cam03 = cam.cam03 + 1
         END IF 
         LET cam.cam04 = shb.shb05     #工單單號
         LET cam.cam06 = shb.shb06     #製程序
 
        #start FUN-660160 modify
        #LET cam.cam07 = shb.shb111+shb.shb115 #約當數量
         SELECT ecm58,ecm59 INTO l_ecm58,l_ecm59 FROM ecm_file
          WHERE ecm01 = shb.shb05 AND ecm03 = shb.shb06
            AND ecm012=shb.shb012  #NO.FUN-A60080
         SELECT ima55 INTO l_ima55 FROM ima_file 
          WHERE ima01 = shb.shb10
         IF l_ecm58 <> l_ima55 THEN
            LET cam.cam07 = (shb.shb111+shb.shb115) * l_ecm59 #約當數量
         ELSE
            LET cam.cam07 = shb.shb111+shb.shb115
         END IF
        #end FUN-660160 modify

        #start FUN-670037 add
        #計算cam10(投入標準人工工時),cam11(投入標準機器工時)
         SELECT ecb19*cam.cam07,ecb21*cam.cam07
           INTO cam.cam10,cam.cam11
           FROM ecb_file
          WHERE ecb01=shb.shb10
            AND ecb02 IN (SELECT sfb06 FROM sfb_file WHERE sfb01=shb.shb05)
            AND ecb03=shb.shb06
            AND ecb06=shb.shb081
            AND ecb012=shb.shb012  #NO.FUN-A60080
         IF cl_null(cam.cam10) THEN LET cam.cam10 = 0 END IF
         IF cl_null(cam.cam11) THEN LET cam.cam11 = 0 END IF
        #end FUN-670037 add
 
         LET cam.cam08 = shb.shb032/60 #投入工時-->成會以小時為單位
         LET cam.cam081= shb.shb033/60 #投入幾時-->成會以小時為單位 #FUN-A90065
         LET cam.cam06 = shb.shb06 
        #LET cam.camplant = g_plant #FUN-980009 add    #FUN-A50075
         LET cam.camlegal = g_legal #FUN-980009 add
         IF cl_null(cam.cam05) THEN LET cam.cam05 = 0 END IF
         IF cam.cam03 = 1 THEN
            LET cal.caloriu = g_user      #No.FUN-980030 10/01/04
            LET cal.calorig = g_grup      #No.FUN-980030 10/01/04
            INSERT INTO cal_file VALUES(cal.*)
            IF sqlca.sqlcode THEN
               IF g_bgjob = 'N' THEN    #FUN-570153
                   ERROR "INSERT INTO cal_file ERROR:",sqlca.sqlcode 
               END IF
               #ROLLBACK WORK
               #EXIT PROGRAM
               LET g_success='N'
               RETURN
            END IF 
         END IF 
         INSERT INTO cam_file VALUES(cam.*)
         IF SQLCA.sqlcode THEN
             IF g_bgjob = 'N' THEN    #FUN-570153
                 ERROR "INSERT INTO cam_file ERROR:",sqlca.sqlcode 
             END IF
             #ROLLBACK WORK
             #EXIT PROGRAM
             LET g_success='N'
             RETURN
         END IF 
         SELECT SUM(cam08) INTO cal.cal05 FROM cam_file 
          WHERE cam01 = cam.cam01 AND cam02 = cam.cam02
         
         IF cl_null(cal.cal05) THEN LET cal.cal05 = 0 END IF 
 
         UPDATE cal_file SET cal05 = cal.cal05 WHERE 
         cal01 = cal.cal01 AND cal02 = cal.cal02
         IF sqlca.sqlcode OR sqlca.sqlerrd[3] = 0 THEN 
             ROLLBACK WORK
             #ERROR "UPDATE cal_file.cal05 ERROR:",sqlca.sqlcode 
             #EXIT PROGRAM
             LET g_success='N'
         END IF 
     END FOREACH
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
     FINISH REPORT p710_rep1 
     FINISH REPORT p710_rep2 
 
END FUNCTION
 
REPORT p710_rep1(p_shi,p_shb)       
  DEFINE p_shi  RECORD  LIKE shi_file.*,
         p_shb  RECORD LIKE shb_file.*,
         l_cag  RECORD LIKE cag_file.*,
         shi05_sum  LIKE shi_file.shi05  
 
  #ORDER BY p_shi.shi02,p_shi.shi04                #NO.FUN-A60080
  ORDER BY p_shi.shi02,p_shi.shi012,p_shi.shi04    #NO.FUN-A60080
  FORMAT 
     AFTER GROUP OF p_shi.shi012 #NO.FUN-A60080
     AFTER GROUP OF p_shi.shi04 
        LET shi05_sum=GROUP SUM(p_shi.shi05)
        LET l_cag.cag01=p_shi.shi02  #轉入工單編號
        LET l_cag.cag02=tm.yy 
        LET l_cag.cag03=tm.mm
        LET l_cag.cag04=p_shb.shb10 #料號
        LET l_cag.cag012=p_shb.shb012  #NO.FUN-A60080
        LET l_cag.cag05=p_shi.shi04 #轉入工單之製程序
        LET l_cag.cag06=p_shi.shi03 #轉入工單之作業編號
        LET l_cag.cag11=p_shb.shb05 #轉出工單編號
        LET l_cag.cag112=p_shb.shb012  #NO.FUN-A60080
        LET l_cag.cag15=p_shb.shb06 #轉出工單之製程序
        LET l_cag.cag16=p_shb.shb081 #轉出工單之作業編號
        LET l_cag.cag20=shi05_sum #工單轉入量
        LET l_cag.cagdate=p_shb.shb03 #首次報工日 
       #LET l_cag.cagplant = g_plant #FUN-980009 add    #FUN-A50075
        LET l_cag.caglegal = g_legal #FUN-980009 add
        INSERT INTO cag_file VALUES(l_cag.*) 
        ##NO.TQC-790100 START--------------------------
        ##IF STATUS<0 AND STATUS !=-239 THEN 
        IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
        ##NO.TQC-790100 END----------------------------
          CALL cl_err('INS cag error',STATUS,1) LET g_success='N' 
        END IF 
END REPORT 
 
 
 
REPORT p710_rep2(p_shd,p_shb) 
  DEFINE p_shd  RECORD  LIKE shd_file.*,
         p_shb  RECORD LIKE shb_file.*,
         l_cah  RECORD LIKE cah_file.*,
         shi05_sum  LIKE shi_file.shi05  
 
  ORDER BY p_shb.shb05,p_shd.shd06
  FORMAT 
    ON EVERY ROW
        IF p_shd.shd07 IS NULL THEN LET p_shd.shd07=0 END IF 
        IF p_shd.shd08 IS NULL THEN LET p_shd.shd08=0 END IF 
        IF p_shd.shd09 IS NULL THEN LET p_shd.shd09=0 END IF 
        LET l_cah.cah01=p_shb.shb05   #工單編號
        LET l_cah.cah02=tm.yy
        LET l_cah.cah03=tm.mm
        LET l_cah.cah04=p_shd.shd06   #料號
        #NO.FUN-A60080--begin
        LET l_cah.cah012=p_shb.shb012 
        IF l_cah.cah012 IS NULL THEN 
           LET l_cah.cah012=' '
        END IF 
        #NO.FUN-A60080--end
        LET l_cah.cah05=p_shb.shb06   #製程序
        LET l_cah.cah06=p_shb.shb081  #作業編號
        LET l_cah.cah07=p_shd.shd07   #數量
        LET l_cah.cah08=p_shd.shd09   #金額
        LET l_cah.cah08a=0  #下線材料成本
        LET l_cah.cah08b=0  #下線人工成本
        LET l_cah.cah08c=0  #下線製造費用
        LET l_cah.cah08d=0  #下線加工成本
        LET l_cah.cah08e=0  #下線其它成本
       #LET l_cah.cahplant = g_plant #FUN-980009 add    #FUN-A50075
        LET l_cah.cahlegal = g_legal #FUN-980009 add
        INSERT INTO cah_file VALUES(l_cah.*) 
       #MOD-C20186 str add-----
        IF cl_sql_dup_value(SQLCA.sqlcode) THEN

          UPDATE cah_file SET cah07=cah07+l_cah.cah07,cah08=cah08+l_cah.cah08
           WHERE cah01=l_cah.cah01 AND cah04=l_cah.cah04
             AND cah02=l_cah.cah02 AND cah03=l_cah.cah03
             AND cah05=l_cah.cah05 AND cah06=l_cah.cah06
        END IF
       #MOD-C20186 end add-----
        IF STATUS THEN CALL cl_err('INS cah error',STATUS,1) 
          LET g_success='N' 
        END IF 
END REPORT 
