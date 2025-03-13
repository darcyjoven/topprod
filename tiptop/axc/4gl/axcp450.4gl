# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp450.4gl
# Descriptions...: 固定/變動成本分析計算作業
# Date & Author..: 02/03/03 BY DS/P
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4C0005 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次作業修改
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-790087 07/09/17 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0068 09/11/10 By lilingyu 臨時表字段改成like的形式
# Modify.........: No.FUN-A50075 10/05/25 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改 
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          wc       LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(300),
         yy LIKE type_file.num5,                  #No.FUN-680122 smallint, 
         mm LIKE type_file.num5,                  #No.FUN-680122 smallint, 
         more     LIKE type_file.chr1             #No.FUN-680122 VARCHAR(1)
          END RECORD,
         g_sql  string  #No.FUN-580092 HCN
DEFINE  g_change_lang LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1),      #FUN-570153
        l_flag        LIKE type_file.chr1          #FUN-570153        #No.FUN-680122 VARCHAR(1)
#     DEFINEl_time  LIKE type_file.chr8            #No.FUN-6A0146
DEFINE  g_row,g_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570153 start--
#FUN-570153 --start--
   IF s_shut(0) THEN EXIT PROGRAM END IF
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc   = ARG_VAL(1)
   LET tm.yy   = ARG_VAL(2)
   LET tm.mm   = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
 
 # CALL cl_used('axcp450',g_time,1) RETURNING g_time   #No.FUN-6A0146
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   WHILE TRUE
      LET g_change_lang = FALSE
      LET g_success = 'Y'
      IF g_bgjob = 'N' THEN
         CALL p450_tm(0,0)
         IF cl_sure(20,20) THEN 
            BEGIN WORK 
            LET g_success='Y'
            CALL axcp450()
            CALL s_showmsg()      #No.FUN-710027
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p450_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p450_w
      ELSE
         BEGIN WORK 
         LET g_success='Y'
         CALL axcp450()
         CALL s_showmsg()       #No.FUN-710027
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570153  end--
 
#NO.FUN-570153 mark--
#   LET g_row = 5 LET g_col = 16
#
#   OPEN WINDOW p450_w AT g_row,g_col WITH FORM "axc/42f/axcp450"  
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    
#   CALL cl_ui_init()
#
#
# Prog. Version..: '5.30.06-13.03.12(0,0)				# 
#   CLOSE WINDOW p450_w 
#NO.FUN-570153 mark--
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p450_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE   l_flag        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   DEFINE   lc_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(500)       #FUN-570153
 
#FUN-570153 --start--
   LET g_row = 5 LET g_col = 16
   OPEN WINDOW p450_w AT g_row,g_col WITH FORM "axc/42f/axcp450"  
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
#FUN-570153 ---end---
 
   CALL cl_opmsg('z')
   LET tm.yy = YEAR (TODAY)
   LET tm.mm = MONTH(TODAY)
   LET tm.more='N'
 
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      CONSTRUCT BY NAME tm.wc ON ima12,ima57,ccg04  
 
      #MOD-530850                                                                 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(ccg04) 
#FUN-AA0059---------mod------------str-----------------                                                            
#            CALL cl_init_qry_var()                                              
#            LET g_qryparam.form = "q_ima"                                       
#            LET g_qryparam.state = "c"                                          
#            CALL cl_create_qry() RETURNING g_qryparam.multiret 
             CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------                 
            DISPLAY g_qryparam.multiret TO ccg04                                
            NEXT FIELD ccg04                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
     #--
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     ON ACTION locale                    #genero
#NO.FUN-570153 start--
#        LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        LET g_change_lang = TRUE                    #FUN-570153
#NO.FUN-570153 end--
        EXIT CONSTRUCT
 
     ON ACTION exit              #加離開功能genero
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
#      IF g_action_choice = "locale" THEN  #genero  #FUN-570153
      IF g_change_lang THEN                         #FUN-570153 
         LET g_change_lang = FALSE                  #FUN-570153
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p450_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF tm.wc = '1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
  
      DISPLAY BY NAME tm.yy,tm.mm,tm.more 
      LET g_bgjob = 'N'                      #FUN-570153
 
      #INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS 
      INPUT BY NAME tm.yy,tm.mm,tm.more,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570153 
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         ON ACTION locale                #FUN-570153
            LET g_change_lang = TRUE     #FUN-570153
            EXIT INPUT                   #FUN-570153
 
      END INPUT
 
#NO.FUN-570153 start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axcp450'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axcp450','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET lc_cmd  = lc_cmd CLIPPED,
                          " '",tm.wc CLIPPED,"'",
                          " '",tm.yy CLIPPED,"'",
                          " '",tm.mm CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp450',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p450_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#FUN-570153 ---end---
  
#NO.FUN-570153 mark--
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 EXIT PROGRAM
#      END IF
#   IF cl_sure(20,20) THEN 
#      BEGIN WORK 
#      LET g_success='Y'
#      CALL axcp450()
#   END IF
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#   ELSE
#      ROLLBACK WORK
#      CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#   END IF
#   IF l_flag THEN
#      CONTINUE WHILE
#   ELSE
#      EXIT WHILE
#   END IF
#   END WHILE
#   #CLOSE WINDOW p450_w 
#NO.FUN-570153 mark---
END FUNCTION
 
FUNCTION axcp450()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20),        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680122 VARCHAR(300),
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_sfb01_old LIKE sfb_file.sfb01,
          l_p02     LIKE ccg_file.ccg04,
          l_p03,l_p04,l_p05  LIKE ccc_file.ccc23,
          l_cad08_t,l_cad08_f,l_cad08_v LIKE cad_file.cad08,
          sr      RECORD 
             cxh01  LIKE cxh_file.cxh01,
             cxh011 LIKE cxh_file.cxh011,
             cxh02  LIKE cxh_file.cxh02,
             cxh03  LIKE cxh_file.cxh03,
             ccg04  LIKE ccg_file.ccg04,
             cxh22b LIKE cxh_file.cxh22b,
             cxh22c LIKE cxh_file.cxh22c,
              amt_in LIKE ccg_file.ccg23b,           #No.FUN-680122 DEC(20,6),      #MOD-4C0005
              amt_f  LIKE cxh_file.cxh22,            #No.FUN-680122 DEC(20,6),      #MOD-4C0005
              amt_v  LIKE cxh_file.cxh22             #No.FUN-680122 DEC(20,6)       #MOD-4C0005
               END RECORD, 
          l_ccg     RECORD 
              ccg01   LIKE ccg_file.ccg01,
              cam02   LIKE cam_file.cam02,
              ccg04   LIKE ccg_file.ccg04,
              ima57   LIKE ima_file.ima57 
                END RECORD 
 
 
     CALL p450_create_tmp() 
 
     LET l_sql=" SELECT ccg01,'',ccg04,ima57 ",
               "   FROM ccg_file,ima_file WHERE ccg04=ima01 ",
               "    AND ccg02=",tm.yy," AND ccg03=",tm.mm,
               "    AND ima08='M' ",
               "    AND ",tm.wc CLIPPED,
               "   GROUP BY ccg01,ccg04,ima57 " CLIPPED
 
            
     PREPARE axcp450_p1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
         RETURN
         #EXIT PROGRAM 
     END IF
     DECLARE axcp450_c1 CURSOR FOR axcp450_p1
     FOREACH axcp450_c1 INTO l_ccg.* 
       IF STATUS THEN LET g_success='N' 
         CALL cl_err('foreach1:',STATUS,1)  
         RETURN   #NO.FUN-570153
         #EXIT PROGRAM 
       END IF
       #找出工單所屬成本中心
       DECLARE cam_cur CURSOR FOR 
        SELECT UNIQUE cam02 FROM cam_file 
         WHERE cam04=l_ccg.ccg01 
       FOREACH cam_cur INTO l_ccg.cam02 
         IF STATUS THEN LET g_success='N' 
         CALL cl_err('cam_for',STATUS,1)     
          RETURN  #NO.FUN-570153
          #EXIT PROGRAM 
         END IF
          #總投入成本
          SELECT SUM(cad08) INTO l_cad08_t FROM cad_file 
           WHERE cad01=tm.yy AND cad02=tm.mm AND cad03=l_ccg.cam02 
          #總固定投入成本
          SELECT SUM(cad08) INTO l_cad08_f FROM cad_file 
           WHERE cad01=tm.yy AND cad02=tm.mm AND cad03=l_ccg.cam02 AND cad07='F'
          #總變動投入成本
          SELECT SUM(cad08) INTO l_cad08_v FROM cad_file 
           WHERE cad01=tm.yy AND cad02=tm.mm AND cad03=l_ccg.cam02 AND cad07='V'
          IF l_cad08_t IS NULL THEN LET l_cad08_t=0 END IF 
          IF l_cad08_f IS NULL THEN LET l_cad08_f=0 END IF 
          IF l_cad08_v IS NULL THEN LET l_cad08_v=0 END IF 
          INSERT INTO p450_file1 VALUES(l_ccg.cam02,l_cad08_t,l_cad08_f,
                                        l_cad08_v) 
         #IF SQLCA.SQLCODE !=-239 AND SQLCA.SQLCODE <0 THEN                   #TQC-790087 mark
          IF (NOT cl_sql_dup_value(SQLCA.SQLCODE)) AND SQLCA.SQLCODE <0 THEN  #TQC-790087
             LET g_success='N' EXIT FOREACH
          END IF
       END FOREACH 
     END FOREACH
   
     IF g_success='N' THEN RETURN END IF 
   
     #unload to "/u02/testcxc/cxc/4gl/p4501.txt" select * from p450_file1  
 
 LET g_sql="SELECT cxh01,cxh011,cxh02,cxh03,ccg04,cxh22b,cxh22c,p02,p03,p04",
           "  FROM ccg_file,cxh_file,ima_file,sfb_file,p450_file1 ",
           " WHERE ccg04=ima01  AND ccg02='",tm.yy,"' AND ccg03='",tm.mm,"' ",
           "   AND ccg01=cxh01  AND ccg02=cxh02 AND ccg03=cxh03 ",
           "   AND ccg01=sfb01  AND sfb93='Y' ",
           "   AND cxh011=p01 ",
           "   AND cxh04 =' DL+OH+SUB' ",
           "   AND ",tm.wc CLIPPED,
           " UNION ALL ",
           "SELECT cch01,sfb98 ,cch02,cch03,ccg04,cch22b,cch22c,p02,p03,p04",
           "  FROM ccg_file,cch_file,ima_file,sfb_file,p450_file1 ",
           " WHERE ccg04=ima01  AND ccg02='",tm.yy,"' AND ccg03='",tm.mm,"' ",
           "   AND ccg01=cch01  AND ccg02=cch02 AND ccg03=cch03 ",
           "   AND ccg01=sfb01  AND sfb93='N' ",
           "   AND sfb98=p01 ",
           "   AND cch04=' DL+OH+SUB' ",
           "   AND ",tm.wc CLIPPED
 
     PREPARE axcp450_p2 FROM g_sql
     DECLARE axcp450_c2 CURSOR FOR axcp450_p2 
     LET l_sfb01_old=' '
     CALL s_showmsg_init()   #No.FUN-710027 
     FOREACH axcp450_c2 INTO sr.* 
       IF STATUS THEN 
#           CALL cl_err('axcp450_f2',STATUS,1)               #No.FUN-710027
           CALL s_errmsg('','','axcp450_f2',STATUS,1)        #No.FUN-710027
           LET g_success='N'  
          RETURN   #NO.FUN-570153 
#          EXIT PROGRAM
       END IF        #比率
#No.FUN-710027--begin 
       IF g_success='N' THEN  
          LET g_totsuccess='N'  
          LET g_success="Y"   
       END IF 
#No.FUN-710027--end
 
       LET sr.amt_f=(sr.amt_f/sr.amt_in)*(sr.cxh22b+sr.cxh22c)  #固定
       LET sr.amt_v=(sr.amt_v/sr.amt_in)*(sr.cxh22b+sr.cxh22c)  #變動
       IF sr.amt_f IS NULL THEN LET sr.amt_f=0 END IF 
       IF sr.amt_v IS NULL THEN LET sr.amt_v=0 END IF 
       IF l_sfb01_old !=sr.cxh01 THEN 
          SELECT ccg23b+ccg23c INTO sr.amt_in FROM ccg_file 
           WHERE ccg01=sr.cxh01 AND ccg02=sr.cxh02 AND ccg03=sr.cxh03 
       ELSE 
          LET sr.amt_in=0 
       END IF 
       LET l_sfb01_old =sr.cxh01 
       INSERT INTO p450_file2 VALUES(sr.cxh01,sr.ccg04,sr.amt_in,sr.amt_f,sr.amt_v) 
          IF SQLCA.sqlcode THEN 
#         CALL cl_err('p450_file2',STATUS,1)   #No.FUN-660127
#No.FUN-710027--begin 
#         CALL cl_err3("ins","p450_file2","","",STATUS,"","p450_file2",1)   #No.FUN-660127
         CALL s_errmsg('','','ins p_450_file2',STATUS,1)
         LET g_success='N' 
#         EXIT PROGRAM
         CONTINUE FOREACH 
#No.FUN-710027--end
       END IF  
     END FOREACH
 
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
 
     IF g_success='N' THEN RETURN END IF 
   
    # unload to "/u02/testcxc/cxc/4gl/p4502.txt" select * from p450_file2
 
     #再sum 起來
     DECLARE axcp450_c3 CURSOR FOR 
       SELECT p02,SUM(p03),SUM(p04),SUM(p05) FROM p450_file2  
        GROUP BY p02 
     IF STATUS THEN 
      CALL cl_err('axcp450_c3',STATUS,1)    
      LET g_success='N' END IF
     FOREACH axcp450_c3 INTO l_p02,l_p03,l_p04,l_p05 
       IF STATUS THEN 
#          CALL cl_err('axcp450_f3',STATUS,1)              #No.FUN-710027
          CALL s_errmsg('','','axcp450_f3',STATUS,1)       #No.FUN-710027
          LET g_success='N'
          EXIT FOREACH 
       END IF
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
      #FUN-A50075--mod--str--拿掉plant
      # INSERT INTO caj_file(caj01,caj02,caj04,caj05,caj06,caj07,cajplant,cajlegal) #No.MOD-470041 #FUN-980009 add cajplant,cajlegal
      #              VALUES(tm.yy,tm.mm,l_p02,l_p03,l_p04,l_p05,g_plant,g_legal)  #FUN-980009 add g_plant,g_legal
        INSERT INTO caj_file(caj01,caj02,caj04,caj05,caj06,caj07,cajlegal) 
                     VALUES(tm.yy,tm.mm,l_p02,l_p03,l_p04,l_p05,g_legal) 
      #FUN-A50075--mod--end
      #IF SQLCA.SQLCODE !=-239 AND SQLCA.SQLCODE <0 THEN                   #TQC-790087 mark
       IF (NOT cl_sql_dup_value(SQLCA.SQLCODE)) AND SQLCA.SQLCODE <0 THEN  #TQC-790087
#         CALL cl_err('INS caj',SQLCA.SQLCODE,1)     #No.FUN-660127
#No.FUN-710027--begin
#          CALL cl_err3("ins","caj_file",tm.yy,tm.mm,SQLCA.SQLCODE,"","INS caj",1)   #No.FUN-660127
          LET g_showmsg = tm.yy,"/",tm.mm        
          CALL s_errmsg('caj01,caj02',g_showmsg,'INS caj',SQLCA.SQLCODE,1)    
          LET g_success='N'
#          EXIT FOREACH 
          CONTINUE FOREACH
#No.FUN-710027--end
       ELSE 
       #IF SQLCA.SQLCODE=-239 THEN               #TQC-790087 mark
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790087
         UPDATE caj_file SET caj05=l_p03,caj06=l_p04,caj07=l_p05 
          WHERE caj01=tm.yy AND caj02=tm.mm AND caj04=l_p02 
         IF SQLCA.SQLCODE THEN 
#         CALL cl_err('UPD caj',SQLCA.SQLCODE,1)     #No.FUN-660127
#No.FUN-710027--begin
#          CALL cl_err3("upd","caj_file",tm.yy,tm.mm,SQLCA.SQLCODE,"","UPD caj",1)   #No.FUN-660127
          LET g_showmsg = tm.yy,"/",tm.mm        
          CALL s_errmsg('caj01,caj02',g_showmsg,'INS caj',SQLCA.SQLCODE,1)    
         LET g_success='N' 
         END IF 
#No.FUN-710027--end
        END IF 
       END IF 
     END FOREACH 
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
END FUNCTION
 
 
 
FUNCTION p450_create_tmp()
 
   DROP TABLE p450_file1
   IF STATUS =-206 THEN 
#FUN-9B0068 --BEGIN--
#     CREATE TEMP TABLE p450_file1
#      (
#        p01 VARCHAR(6),   #成本中心
#         p02 DEC(20,6), #本月投入金額    #MOD-4C0005 modify
#         p03 DEC(20,6), #固定成本        #MOD-4C0005 moidfy 
#         p04 DEC(20,6)  #變動成本        #MOD-4C0005 modify
#      );
     CREATE TEMP TABLE p450_file1(
         p01    LIKE type_file.chr9,  
         p02    LIKE type_file.num20_6,
         p03    LIKE type_file.num20_6,
         p04    LIKE type_file.num20_6); 
#FUN-9B0068 --end--
     create unique index pp_01 on p450_file1 (p01) ;
   END IF 
   DROP TABLE p450_file2
   IF STATUS =-206 THEN 
#FUN-9B0068 --BEGIN--
#     CREATE TEMP TABLE p450_file2
#      ( p01  VARCHAR(16),    #工單編號   # FUN-550025
#        p02  VARCHAR(20),    #主件料號
#         p03  DEC(20,6),   #in=ccg23b+ccg23c    #MOD-4C0005
#         p04  DEC(20,6),   #fix                 #MOD-4C0005
#         p05  DEC(20,6)    #variable            #MOD-4C0005
#      );
     CREATE TEMP TABLE p450_file2(
         p01    LIKE pmn_file.pmn01,
         p02    LIKE type_file.chr20,
         p03    LIKE type_file.num20_6,
         p04    LIKE type_file.num20_6,
         p05    LIKE type_file.num20_6); 
#FUN-9B0068 --END--
   END IF 
END FUNCTION
