# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Program name...: sasfi610_sub.4gl
# Description....: 提供sasfi610.4gl使用的sub routine
# Date & Author..: 10/03/09 by liuxqa FUN-A20048
# Modify.........: No.FUN-A50023 10/05/12 By liuxqa
# Modify.........: No.FUN-A60042 10/06/18 By liuxqa confirm error
# Modify.........: No.FUN-AB0054 10/11/16 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No.FUN-B20009 11/04/07 By lixh1 增加字段sie16,sie15,sic15  
# Modify.........: No.FUN-AC0074 11/05/11 By lixh1 調整確認邏輯
# Modify.........: No.TQC-B50052 11/05/27 By lixh1 修改SQL問題
# Modify.........: No.FUN-910088 11/12/01 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:TQC-C60207 12/06/28 By lixh1 審核時控管廠商是否可用
# Modify.........: No:MOD-CC0185 13/01/31 By Elise 1.目前BOM料號、發料料號、備置量、倉庫有CALL i610_img10_count檢查可備置量,請增加儲位、批號的控卡,比照倉庫控卡
#                                                  2.FUNCTION i610_img10_count中請增加判斷倉庫為空白直接RETURN,並請測試確認時倉庫為空要不能確認
# Modify.........: No:FUN-D20059 13/03/26 By xumm 確認/取消確認賦值確認異動日期
# Modify.........: No:MOD-D60230 13/06/27 By suncx 管控備置量不能大於庫存量時應該對工單同一單身料件的所有備料數量之和與庫存量-已備料量對比
# Modify.........: No:MOD-D60120 13/06/28 By SunLM axmi611审核/取消审核时应回写oeb905
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasfi610.global"  #FUN-AC0074
 
DEFINE g_forupd_sql   STRING     
DEFINE g_line         LIKE type_file.num5    
DEFINE g_rva_no       LIKE rva_file.rva01    

FUNCTION i610sub_lock_cl()
   LET g_forupd_sql = "SELECT * FROM sia_file WHERE sia01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i610sub_cl CURSOR FROM g_forupd_sql
END FUNCTION
            
FUNCTION i610sub_sie(p_sia)
 DEFINE p_sia       RECORD LIKE sia_file.*
 DEFINE l_sic       RECORD LIKE sic_file.*
 DEFINE l_sie       RECORD LIKE sie_file.*
 DEFINE l_sig       RECORD LIKE sig_file.* 
 DEFINE l_cnt       LIKE type_file.num5
 DEFINE l_count     LIKE type_file.num5
 DEFINE l_sie11     LIKE sie_file.sie11 #MOD-D60120 add                                           
                                          
   IF cl_null(p_sia.sia01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE i610_sic_1 CURSOR FOR
         SELECT * FROM sic_file WHERE sic01=p_sia.sia01
   FOREACH i610_sic_1 INTO l_sic.*
      IF NOT cl_null(p_sia.sia04) THEN
         IF p_sia.sia04 = '2' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sie_file WHERE sie01= l_sic.sic05 AND sie02= l_sic.sic08
                      AND sie03=l_sic.sic09 AND sie04=l_sic.sic10 AND sie05= l_sic.sic03 AND sie06=l_sic.sic11
                      AND sie07=l_sic.sic07 AND sie08=l_sic.sic04  
                      AND sie012 = l_sic.sic012 AND sie013 = l_sic.sic013 AND sie15 = l_sic.sic15   #FUN-AC0074 
        
            IF l_cnt >0 THEN 
               UPDATE sie_file SET sie11= sie11-l_sic.sic06,sie12 = g_today,sie09= sie09 - l_sic.sic06,
                         sie13 = l_sic.sic01,sie14 = l_sic.sic02 
                   WHERE sie01= l_sic.sic05 AND sie02= l_sic.sic08
                  AND sie03=l_sic.sic09 AND sie04=l_sic.sic10 AND sie05= l_sic.sic03 AND sie06=l_sic.sic11
                  AND sie07=l_sic.sic07 AND sie08=l_sic.sic04 
                  AND sie012 = l_sic.sic012 AND sie013 = l_sic.sic013 AND sie15 = l_sic.sic15   #FUN-AC0074
               IF SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","sie_file",l_sie.sie01,l_sie.sie02,SQLCA.sqlcode,"","up sie10",1)
                  LET g_success = 'N' 
                  RETURN
               END IF
            ELSE
               LET g_success = 'N'
               RETURN
            END IF
            IF g_argv1 = '1' THEN    #FUN-AC0074

               UPDATE sfb_file SET sfb104='Y' WHERE sfb01=l_sic.sic03 
               IF SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","sfb_file",l_sic.sic03,"",SQLCA.sqlcode,"","up sfb104",1)
                  LET g_success = 'N' 
                  RETURN
               END IF
            END IF     #FUN-AC0074
            #FUN-AC0074 ------------------Begin----------------------
            IF g_argv1 = '2' THEN
               #MOD-D60120 add begin-------
               SELECT SUM(sie11) INTO l_sie11 FROM sie_file WHERE sie05=l_sic.sic03 AND sie15=l_sic.sic15
               IF cl_null(l_sie11) THEN LET l_sie11=0 END IF    
               #MOD-D60120 add end---------           
               UPDATE oeb_file SET oeb19 = 'Y',
                                  oeb905 = l_sie11 #MOD-D60120 add 
                WHERE oeb01 = l_sic.sic03
                  AND oeb03 = l_sic.sic15
               IF SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","oeb_file",l_sic.sic03,"",SQLCA.sqlcode,"","up oeb19",1)
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
            #FUN-AC0074 ------------------End------------------------
            CALL i610sub_ins_sif(p_sia.sia04,l_sic.*)
            CALL i610sub_ins_sig(p_sia.sia04,l_sic.*)          
            IF g_success = 'N' THEN 
               RETURN
            END IF              	       
         ELSE  
            IF g_argv1 = '1' THEN    #FUN-AC0074  
               UPDATE sfb_file SET sfb104='Y' WHERE sfb01=l_sic.sic03 
               IF SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","sfb_file",l_sic.sic03,"",SQLCA.sqlcode,"","up sfb104",1)
                  LET g_success = 'N' 
                  RETURN
               END IF
            END IF    #FUN-AC0074
         #FUN-AC0074 --------------------Begin-----------------------  MOD-D60120 mark beg 
#            IF g_argv1 = '2' THEN
#               #MOD-D60120 add begin-------
#               SELECT SUM(sie11) INTO l_sie11 FROM sie_file WHERE sie05=l_sic.sic03 AND sie15=l_sic.sic15
#               IF cl_null(l_sie11) THEN LET l_sie11=0 END IF    
#               #MOD-D60120 add end---------                 
#               UPDATE oeb_file SET oeb19 ='Y',
#                                  oeb905 = l_sie11 #MOD-D60120 add                 
#               WHERE oeb01=l_sic.sic03
#                 AND oeb03=l_sic.sic15   
#               IF SQLCA.SQLERRD[3]=0 THEN
#                  CALL cl_err3("upd","oeb_file",l_sic.sic03,"",SQLCA.sqlcode,"","up oeb19",1)
#                  LET g_success = 'N'
#                  RETURN
#               END IF
#            END IF
         #FUN-AC0074 --------------------End------------------------- MOD-D60120 mark end
#FUN-B20009 ----------------------Begin----------------------
            IF cl_null(l_sic.sic012) THEN
               LET l_sic.sic012 = ' '
            END IF 
            IF cl_null(l_sic.sic013) THEN
               LET l_sic.sic013 = 0
            END IF 
#FUN-B20009 ----------------------End------------------------
       
           #CALL i610sub_ins_sie(p_sia.sia04,l_sic.*)              #FUN-AC0074
            CALL i610sub_ins_sie(p_sia.sia04,p_sia.sia05,l_sic.*)  #FUN-AC0074
            CALL i610sub_ins_sif(p_sia.sia04,l_sic.*)
            CALL i610sub_ins_sig(p_sia.sia04,l_sic.*) 
            #MOD-D60120 add beg----------------   
            IF g_argv1 = '2' THEN
               #MOD-D60120 add begin-------
               SELECT SUM(sie11) INTO l_sie11 FROM sie_file WHERE sie05=l_sic.sic03 AND sie15=l_sic.sic15
               IF cl_null(l_sie11) THEN LET l_sie11=0 END IF    
               #MOD-D60120 add end---------                 
               UPDATE oeb_file SET oeb19 ='Y',
                                  oeb905 = l_sie11 #MOD-D60120 add                 
               WHERE oeb01=l_sic.sic03
                 AND oeb03=l_sic.sic15   
               IF SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","oeb_file",l_sic.sic03,"",SQLCA.sqlcode,"","up oeb19",1)
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
            #MOD-D60120 add end--------------                  
            IF g_success = 'N' THEN 
               RETURN
            END IF 
         END IF 
      END IF              	       
   END FOREACH                                                                                                           
END FUNCTION 

#FUNCTION i610sub_ins_sie(p_sia04,l_sic)         #FUN-AC0074
FUNCTION i610sub_ins_sie(p_sia04,p_sia05,l_sic)  #FUN-AC0074
 DEFINE p_sia04      LIKE sia_file.sia04 
 DEFINE p_sia05      LIKE sia_file.sia05      #FUN-AC0074
 DEFINE l_sic        RECORD LIKE sic_file.*
 DEFINE l_sie        RECORD LIKE sie_file.*
 DEFINE l_cnt        LIKE type_file.num5

 INITIALIZE l_sie.* TO NULL
   
 IF p_sia04 = '2' THEN 
    LET l_sic.sic06 = l_sic.sic06 *(-1)
 END IF 
  LET l_sie.sie01 = l_sic.sic05
  LET l_sie.sie02 = l_sic.sic08
  LET l_sie.sie03 = l_sic.sic09
  LET l_sie.sie04 = l_sic.sic10
  LET l_sie.sie05 = l_sic.sic03
  LET l_sie.sie06 = l_sic.sic11
  LET l_sie.sie07 = l_sic.sic07
  LET l_sie.sie08 = l_sic.sic04
  LET l_sie.sie09 = l_sic.sic06
  LET l_sie.sie10 = 0
  LET l_sie.sie11 = l_sic.sic06
  LET l_sie.sie12 = g_today
  LET l_sie.sie13 = l_sic.sic01
  LET l_sie.sie14 = l_sic.sic02
  LET l_sie.sielegal = g_legal
  LET l_sie.sieplant = g_plant
# LET l_sie.sie012 = ' '     #FUN-A60042 add   #FUN-B20009
# LET l_sie.sie013 = 0       #FUN-A60042 add   #FUN-B20009
  LET l_sie.sie012 = l_sic.sic012              #FUN-B20009
  LET l_sie.sie013 = l_sic.sic013              #FUN-B20009
  #FUN-AC0074 --------Begin-------------
  LET l_sie.sie15 = l_sic.sic15         
  IF cl_null(l_sie.sie15) THEN
     LET l_sie.sie15 = 0
  END IF
  LET l_sie.sie16 = p_sia05 
  #FUN-AC0074 --------End---------------
#FUN-AC0074 ------------Begin-----------------
  SELECT COUNT(*) INTO l_cnt FROM sie_file
   WHERE sie01 = l_sie.sie01
     AND sie02 = l_sie.sie02
     AND sie03 = l_sie.sie03
     AND sie04 = l_sie.sie04
     AND sie05 = l_sie.sie05
     AND sie06 = l_sie.sie06
     AND sie07 = l_sie.sie07
     AND sie08 = l_sie.sie08
     AND sie012 = l_sie.sie012
     AND sie013 = l_sie.sie013
     AND sie15 = l_sie.sie15   
  IF cl_null(l_cnt) THEN
     LET l_cnt = 0
  END IF
  IF l_cnt = 0 THEN
     INSERT INTO sie_file VALUES(l_sie.*)
  ELSE
    UPDATE sie_file SET sie09 = sie09 + l_sie.sie09,
                         sie11 = sie11 + l_sie.sie11,
                         sie12 = g_today,
                         sie13 = l_sic.sic01,
                         sie14 = l_sic.sic02
      WHERE sie01 = l_sie.sie01
        AND sie02 = l_sie.sie02
        AND sie03 = l_sie.sie03
        AND sie04 = l_sie.sie04
        AND sie05 = l_sie.sie05
        AND sie06 = l_sie.sie06
        AND sie07 = l_sie.sie07
        AND sie08 = l_sie.sie08
        AND sie012 = l_sie.sie012
        AND sie013 = l_sie.sie013
        AND sie15 = l_sie.sie15
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","sie_file",l_sie.sie01,l_sie.sie02,SQLCA.sqlcode,"","up sie05",1)
        LET g_success = 'N'
        RETURN
     END IF
  END IF
#FUN-AC0074 ------------End-------------------
#FUN-AC0074 ------------Begin-----------------
# INSERT INTO sie_file VALUES(l_sie.*)
# IF SQLCA.SQLCODE THEN
#    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
#       UPDATE sie_file SET sie09 = sie09 + l_sie.sie09,
#                           sie11 = sie11 + l_sie.sie11,
#                           sie12 = g_today,
#                           sie13 = l_sic.sic01,
#                           sie14 = l_sic.sic02
#        WHERE sie01 = l_sie.sie01
#          AND sie02 = l_sie.sie02
#          AND sie03 = l_sie.sie03
#          AND sie04 = l_sie.sie04
#          AND sie05 = l_sie.sie05
#          AND sie06 = l_sie.sie06
#          AND sie07 = l_sie.sie07
#          AND sie08 = l_sie.sie08
#          AND sie012 = l_sie.sie012
#          AND sie013 = l_sie.sie013
#          AND sie15 = l_sie.sie15
#        IF SQLCA.SQLCODE THEN
#           CALL cl_err3("upd","sie_file",l_sie.sie01,l_sic.sic06,STATUS,"","update sie",1)
#           LET g_success = 'N'
#        END IF
#     ELSE
#        CALL cl_err(l_sie.sie05,SQLCA.SQLCODE,0)
#        LET g_success = 'N'
#     END IF
#  END IF
#FUN-AC0074 ------------End-------------------
  IF STATUS THEN
     CALL cl_err3("ins","sie_file",l_sie.sie01,l_sie.sie02,STATUS,"","ins sie",1)  
     LET g_success='N' 
     RETURN
  END IF
END FUNCTION 

FUNCTION i610sub_ins_sig(p_sia04,l_sic)
 DEFINE p_sia04      LIKE sia_file.sia04
 DEFINE l_sic        RECORD LIKE sic_file.*
 DEFINE l_sig        RECORD LIKE sig_file.*
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE l_ima25      LIKE ima_file.ima25       #FUN-AC0074
 DEFINE l_fac        LIKE ima_file.ima31_fac   #FUN-AC0074
 DEFINE l_flag       LIKE type_file.num10      #FUN-AC0074
 INITIALIZE l_sig.* TO NULL
   
 SELECT COUNT(*) INTO l_cnt FROM sig_file WHERE  sig01 = l_sic.sic05  AND sig02 = l_sic.sic08
                    AND sig03 = l_sic.sic09 AND sig04 = l_sic.sic10
#IF p_sia04 = '2' OR g_action_choice = 'undo_confirm' THEN   #FUN-AC0074
 IF (p_sia04 = '2' AND g_action_choice = 'confirm') OR        #FUN-AC0074
    (p_sia04 <> '2' AND g_action_choice = 'undo_confirm') OR  #FUN-AC0074
    (g_prog='asfp400' OR g_prog='asfp401' OR g_prog='axcp401' OR g_prog='axmp410' OR g_prog='axmp811')THEN  #FUN-AC0074
    LET   l_sic.sic06 = l_sic.sic06 *(-1)
 END IF 
#FUN-AC0074 --------------Begin-----------------
 SELECT ima25 INTO l_ima25 FROM ima_file
  WHERE ima01 = l_sic.sic05
 CALL s_umfchk(l_sic.sic05,l_sic.sic07,l_ima25)
    RETURNING l_flag,l_fac
 IF l_flag THEN
    CALL cl_err('','',0)
 ELSE
    LET l_sic.sic06=l_sic.sic06 * l_fac
 END IF
#FUN-AC0074 --------------End-------------------
 LET l_sig.sig01 = l_sic.sic05 
 LET l_sig.sig02 = l_sic.sic08
 LET l_sig.sig03 = l_sic.sic09
 LET l_sig.sig04 = l_sic.sic10
 LET l_sig.sig05 = l_sic.sic06
 LET l_sig.sig06 = l_sic.sic07
 LET l_sig.sig07 = g_today  
 LET l_sig.siglegal = g_legal
 LET l_sig.sigplant = g_plant
    
 IF l_cnt >0 THEN 
     UPDATE sig_file SET sig05 = sig05 + l_sic.sic06,sig07 = l_sig.sig07
            WHERE sig01 = l_sic.sic05 AND sig02 = l_sic.sic08 
              AND sig03 = l_sic.sic09 AND sig04 = l_sic.sic10 
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","sig_file",l_sig.sig01,l_sig.sig02,SQLCA.sqlcode,"","up sig05",1)
        LET g_success = 'N' 
        RETURN
     END IF
  ELSE 
    INSERT INTO sig_file VALUES(l_sig.*)
    IF STATUS THEN
       CALL cl_err3("ins","sig_file",l_sig.sig01,l_sig.sig02,STATUS,"","ins sif",1)  
       LET g_success='N' 
       RETURN
    END IF 
  END IF 
END FUNCTION 
  	          
                
FUNCTION i610sub_ins_sif(p_sia04,l_sic)
 DEFINE p_sia04      LIKE sia_file.sia04
 DEFINE l_sic        RECORD LIKE sic_file.*
 DEFINE l_sif        RECORD LIKE sif_file.*

 INITIALIZE l_sif.* TO NULL
      CASE p_sia04
        WHEN '1'  #備置
           LET l_sif.sif09=1
        WHEN '2'  #退備置
           LET l_sif.sif09=-1
      END CASE  
  LET l_sif.sif01 = l_sic.sic05
  LET l_sif.sif02 = l_sic.sic08
  LET l_sif.sif03 = l_sic.sic09
  LET l_sif.sif04 = l_sic.sic10
  LET l_sif.sif05 = l_sic.sic03
  LET l_sif.sif06 = l_sic.sic11
  LET l_sif.sif07 = l_sic.sic07
  LET l_sif.sif08 = l_sic.sic04
  LET l_sif.sif10 = g_today
  LET l_sif.sif11 = l_sic.sic01
  LET l_sif.sif12 = l_sic.sic02
  LET l_sif.siflegal = g_legal
  LET l_sif.sifplant = g_plant
  LET l_sif.sif13 = l_sic.sic06     #FUN-A60042 add
  LET l_sif.sif012 = l_sic.sic012   #FUN-B20009
  LET l_sif.sif013 = l_sic.sic013   #FUN-B20009
#FUN-AC0074 -----------Begin------------
  LET l_sif.sif15 = l_sic.sic15   
  IF cl_null(l_sif.sif15) THEN
     LET l_sif.sif15 = 0
  END IF
#FUN-AC0074 -----------End--------------
  INSERT INTO sif_file VALUES(l_sif.*)
  IF STATUS THEN
     CALL cl_err3("ins","sif_file",l_sif.sif11,l_sif.sif12,STATUS,"","ins sif",1)  
     LET g_success='N' 
     RETURN
  END IF
END FUNCTION 
    
FUNCTION i610sub_y_chk(p_sia01)
   DEFINE l_cnt        LIKE type_file.num10   
   DEFINE l_str        STRING                 
   DEFINE l_rvbs06     LIKE rvbs_file.rvbs06   
   DEFINE p_sia01      LIKE sia_file.sia01  
   DEFINE l_sia RECORD LIKE sia_file.* 
   DEFINE l_sic RECORD LIKE sic_file.* 
   DEFINE l_ima918     LIKE ima_file.ima918
   DEFINE l_ima921     LIKE ima_file.ima921
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_r          LIKE type_file.chr1   
   DEFINE l_fac        LIKE img_file.img34   
   DEFINE l_sfa07      LIKE sfa_file.sfa07   
   DEFINE l_sfa05      LIKE sfa_file.sfa05  
   DEFINE l_sfa06      LIKE sfa_file.sfa06  
   DEFINE l_ime12      LIKE ime_file.ime12  
   DEFINE l_sia06      LIKE sia_file.sia06
   DEFINE g_rvbs00     LIKE rvbs_file.rvbs00
   DEFINE l_str1       STRING
   DEFINE l_str2       STRING
   DEFINE l_sig05      LIKE sig_file.sig05
   DEFINE l_img10      LIKE img_file.img10
   DEFINE m_img10      LIKE img_file.img10   #FUN-AC0074 
   DEFINE m_sic06      LIKE sic_file.sic06   #FUN-AC0074 
   DEFINE m_sig05      LIKE sig_file.sig05   #FUN-AC0074
   DEFINE l_sia04      LIKE sia_file.sia04   #FUN-AC0074
   DEFINE l_sia05      LIKE sia_file.sia05   #FUN-AC0074
   DEFINE l_argv       LIKE type_file.chr1   #FUN-AC0074
   DEFINE l_sql        STRING                #FUN-AC0074 
   DEFINE l_gem01      LIKE gem_file.gem01   #TQC-C60207
   
   LET g_success = 'Y'
 
   IF cl_null(p_sia01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
#CHI-C30107 -------------- add ---------------- begin
   IF l_sia.siaconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF l_sia.siaconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF  
   IF NOT cl_null(g_action_choice) THEN
      IF NOT cl_confirm('axm-108') THEN 
         LET g_success = 'N'
         RETURN
      END IF 
   END IF  
#CHI-C30107 -------------- add ---------------- end 
   SELECT * INTO l_sia.* FROM sia_file WHERE sia01 = p_sia01
   IF l_sia.siaconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   IF l_sia.siaconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM sia_file
      WHERE sia01= p_sia01
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

#TQC-C60207 ---------------Begin--------------
   IF NOT cl_null(l_sia.sia06) THEN
      SELECT gem01 INTO l_gem01 FROM gem_file
       WHERE gem01 = l_sia.sia06
         AND gemacti = 'Y'
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err(l_sia.sia06,'asf-683',0)
         RETURN
      END IF
   END IF
#TQC-C60207 ---------------End----------------

   #Cehck 單身 料倉儲批是否存在 img_file
   DECLARE i610_y_chk_c CURSOR FOR SELECT * FROM sic_file
                                   WHERE sic01=p_sia01
#FUN-AC0074 --------------Begin----------------------------
   SELECT sia04,sia05 INTO l_sia04,l_sia05 FROM sia_file
    WHERE sia01 = p_sia01
   IF (l_sia05 = '1' OR l_sia05 = '2') THEN
      LET l_argv = '1'
   END IF
   IF l_sia05 = '3' THEN
      LET l_argv = '2'
   END IF
#FUN-AC0074 --------------End------------------------------  
   FOREACH i610_y_chk_c INTO l_sic.*
      #Add No.FUN-AB0054
      IF NOT cl_null(l_sic.sic08) THEN
         IF NOT s_chk_ware(l_sic.sic08) THEN  #检查仓库是否属于当前门店
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF
      #End Add No.FUN-AB0054
      LET l_cnt=0
#FUN-AC0074 -------------------------Begin-------------------------------
   #  SELECT COUNT(*) INTO l_cnt FROM img_file WHERE img01=l_sic.sic05
   #                                             AND img02=l_sic.sic08
   #                                             AND img03=l_sic.sic09
   #                                             AND img04=l_sic.sic10
           LET l_sql = "SELECT COUNT(*) FROM img_file",
                       " WHERE img01 = '",l_sic.sic05,"'",
                       "   AND img03 = '",l_sic.sic09,"'",
                       "   AND img04 = '",l_sic.sic10,"'"
           IF NOT cl_null(l_sic.sic08) THEN 
              LET l_sql = l_sql CLIPPED," AND img02 = '",l_sic.sic08,"'"
           END IF
           PREPARE i600_pre3 FROM l_sql
           DECLARE i600_img_count2 CURSOR FOR i600_pre3
           OPEN i600_img_count2
           IF SQLCA.sqlcode THEN 
              CALL cl_err('',SQLCA.sqlcode,0)
              CLOSE i600_img_count2
           ELSE 
              FETCH i600_img_count2 INTO l_cnt
              IF SQLCA.sqlcode THEN 
                  CALL cl_err('i600_img_count2:',SQLCA.sqlcode,0)
                  CLOSE i600_img_count2
              END IF
           END IF
#FUN-AC0074 -----------------------End----------------------------
                                                
         IF l_cnt=0 THEN
            IF NOT cl_null(l_sic.sic08) THEN    #FUN-AC0074
               SELECT ime12  INTO l_ime12 FROM imd_file,ime_file
                WHERE imd01 = ime01
                  AND imd01 = l_sic.sic08
                  AND ime02 = l_sic.sic09
                   AND imeacti = 'Y'        #FUN-D40103 
                IF l_ime12 = '2' THEN 
                ELSE       
                 LET g_success='N'
                 LET l_str = l_sic.sic02,' - ',l_sic.sic04   
                 CALL cl_err(l_str,'asf-507',1)              
                END IF                                       
                 EXIT FOREACH
            END IF     #FUN-AC0074
         END IF    
#FUN-AC0074 ------------------------Begin----------------------------
#     SELECT img10 INTO l_img10 FROM img_file WHERE img01=l_sic.sic05
#                                               AND img02=l_sic.sic08
#                                               AND img03=l_sic.sic09
#                                               AND img04=l_sic.sic10  
#  
#     SELECT sig05 INTO l_sig05 
#          FROM sig_file 
#        WHERE sig01=l_sic.sic05 AND sig02=l_sic.sic08
#          AND sig03=l_sic.sic09 AND sig04=l_sic.sic10
                  
#      #sic06备置量 > img10庫存量 
#     IF l_sia.sia04 = '1' THEN
#        LET l_img10 = l_img10 - l_sig05
#        IF l_sic.sic06 > l_img10 THEN
#           CALL cl_err(l_sic.sic06,'sie-002',0)  
#           LET g_success = 'N'
#           EXIT FOREACH 
#        END IF                  
#     END IF                            
     #CALL i610_img10_count(l_sic.sic05,l_sic.sic08,l_sic.sic09,l_sic.sic10,l_sic.sic06,l_sic.sic07) #MOD-D60230 mark
      CALL i610_img10_count(l_sic.sic05,l_sic.sic08,l_sic.sic09,l_sic.sic10,l_sic.sic06,l_sic.sic07,
                            l_sic.sic01,l_sic.sic02,l_sic.sic03) #MOD-D60230 add
           RETURNING m_img10,m_sic06,m_sig05
      IF l_sia.sia04 = '1' THEN
         IF (m_img10 - m_sig05)< m_sic06 THEN
            CALL cl_err(l_sic.sic06,'sie-002',0)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
      CALL i610sub_chk_sic06(l_sia04,l_argv,l_sic.sic01,l_sic.sic02,l_sic.sic03,l_sic.sic05,l_sic.sic06,l_sic.sic07,
                             l_sic.sic11,l_sic.sic15,l_sic.sic012,l_sic.sic013 )
      IF g_success = 'N' THEN
         RETURN
      END IF 
#FUN-AC0074 ----------------------End------------------------
#{     SELECT sfa05,sfa06 into l_sfa05,l_sfa06 FROM sfa_file
#      WHERE sfa01=l_sic.sic03 AND sfa03=l_sic.sic05
#        AND sfa12=l_sic.sic07 AND sfa08=l_sic.sic11
#        AND sfa27 = l_sic.sic04  #FUN-9B0149
#     IF l_sia.sia04 MATCHES '[1]' AND 
#        l_sfa05-l_sfa06 < l_sic.sic06 THEN
#        CALL cl_err(l_sic.sic04,'asf-351',1) 
#        LET g_success='N'
#        EXIT FOREACH     
#     END IF}

      IF l_sia.sia04 = '1' AND l_sia.sia05 = '1' THEN   #FUN-A50023 add                                                                                                    
         LET l_cnt=0                                                                                                                
         SELECT COUNT(*) INTO l_cnt FROM sib_file                                                                                   
          WHERE sib01=p_sia01                                                                                                       
            AND sib02=l_sic.sic03                                                                                                   
         IF l_cnt=0 THEN                                                                                                            
            LET l_str=l_sic.sic03                                                                                                   
            CALL cl_err(l_str,'asf-000',1)                                                                                          
            LET g_success='N'                                                                                                       
            EXIT FOREACH                                                                                                            
         END IF                                                                                                                     
      END IF                                             #FUN-A50023 add                                                                       
                                                      
   END FOREACH
 
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION i610sub_y_upd(p_sia01,p_action_choice,p_inTransaction)  
   DEFINE l_forupd_sql    STRING
   DEFINE p_sia01         LIKE sia_file.sia01
   DEFINE p_action_choice LIKE type_file.chr1
   DEFINE l_sia    RECORD LIKE sia_file.*
   DEFINE p_inTransaction LIKE type_file.num5
 
#CHI-C30107 ----------------- mark ---------------- begin
#  IF NOT cl_null(p_action_choice) THEN
#     IF NOT cl_confirm('axm-108') THEN #CHI-C30107 mark
#        SELECT * INTO l_sia.* FROM sia_file
#                             WHERE sia01=p_sia01
#        RETURN l_sia.* 
#     END IF #CHI-C30107 mark
#  END IF
#CHI-C30107 ----------------- mark ---------------- end
   LET g_success = 'Y'
 
   IF NOT p_inTransaction THEN 
      BEGIN WORK
   END IF
 
   LET g_forupd_sql = "SELECT * FROM sia_file WHERE sia01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i610sub_upd_cl CURSOR FROM g_forupd_sql
 
   OPEN i610sub_upd_cl USING p_sia01
   IF STATUS THEN
      CALL cl_err("OPEN i610sub_upd_cl:", STATUS, 1)
      CLOSE i610sub_upd_cl
      IF NOT p_inTransaction THEN 
         ROLLBACK WORK
      END IF
      RETURN l_sia.*
   END IF
 
   FETCH i610sub_upd_cl INTO l_sia.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(l_sia.sia01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE i610sub_upd_cl 
       ROLLBACK WORK 
       RETURN l_sia.*
   END IF
   CLOSE i610sub_upd_cl
  #UPDATE sia_file SET siaconf = 'Y' WHERE sia01 = l_sia.sia01                   #FUN-D20059 Mark
   UPDATE sia_file SET siaconf = 'Y',sia03 = g_today WHERE sia01 = l_sia.sia01   #FUN-D20059 Add
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","sia_file",l_sia.sia01,"",STATUS,"","upd siaconf",1)  #No.FUN-660128
      LET g_success = 'N'
   END IF
 
   CALL i610sub_sie(l_sia.*)
   IF g_success='Y' THEN   
      IF NOT p_inTransaction THEN
         COMMIT WORK
      END IF 
      LET l_sia.siaconf='Y'
      LET l_sia.sia03 = g_today #FUN-D20059 Add
      CALL cl_flow_notify(l_sia.sia01,'Y')
   ELSE
      ROLLBACK WORK
      LET l_sia.siaconf='N'
      LET l_sia.sia03 = g_today #FUN-D20059 Add
   END IF
   RETURN l_sia.* 

END FUNCTION

FUNCTION i610sub_refresh(p_sia01)
  DEFINE p_sia01 LIKE sia_file.sia01
  DEFINE l_sia RECORD LIKE sia_file.*
 
  SELECT * INTO l_sia.* FROM sia_file WHERE sia01=p_sia01
  RETURN l_sia.*
END FUNCTION


#FUNCTION i610sub_w(p_sia01,p_action_choice,p_call_transaction)       #FUN-AC0074
FUNCTION i610sub_w(p_sia01,p_action_choice,p_call_transaction,p_argv) #FUN-AC0074
  DEFINE p_sia01         LIKE sia_file.sia01
  DEFINE p_action_choice STRING
  DEFINE p_call_transaction LIKE type_file.num5 #WHEN TRUE -> CALL BEGIN/ROLLBACK/COMMIT WORK
  DEFINE l_sia RECORD    LIKE sia_file.*
  DEFINE l_sib02   LIKE sib_file.sib02   
  DEFINE l_cnt     LIKE type_file.num5   
#FUN-AC0074 ----------Begin----------- 
  DEFINE l_sic03   LIKE sic_file.sic03
  DEFINE l_sic01   LIKE sic_file.sic01
  DEFINE l_sic04   LIKE sic_file.sic04
  DEFINE l_sic05   LIKE sic_file.sic05
  DEFINE l_sic07   LIKE sic_file.sic07
  DEFINE l_sic11   LIKE sic_file.sic11
  DEFINE l_sic012  LIKE sic_file.sic012
  DEFINE l_sic013  LIKE sic_file.sic013
  DEFINE l_sie09   LIKE sie_file.sie09
  DEFINE l_sie11   LIKE sie_file.sie11
  DEFINE l_sic15   LIKE sic_file.sic15
  DEFINE p_argv    LIKE type_file.chr1
#FUN-AC0074 ----------End------------- 
  DEFINE m_sia RECORD    LIKE sia_file.*, #MOD-D60120 add
         m_sic RECORD    LIKE sic_file.*
 
   LET g_success='Y'
   IF cl_null(p_sia01) THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
   SELECT * INTO l_sia.* FROM sia_file WHERE sia01 = p_sia01
   IF l_sia.siaconf='N' THEN LET g_success='N' RETURN END IF
   IF l_sia.siaconf='X' THEN CALL cl_err(' ','9024',0) LET g_success='N' RETURN END IF
 
 
 
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('axm-109') THEN LET g_success='N' RETURN END IF
   END IF
  #FUN-AC0074 ---------------------------Begin-------------------------
   IF p_argv = '1' THEN
      DECLARE i610_sic_cs CURSOR FOR 
       SELECT DISTINCT sic03,sic04,sic05,sic07,sic11,sic012,sic013 FROM sic_file
       WHERE sic01 = p_sia01 
       
      FOREACH i610_sic_cs INTO l_sic03,l_sic04,l_sic05,l_sic07,l_sic11,l_sic012,l_sic013
         SELECT SUM(sie09),SUM(sie11) INTO l_sie09,l_sie11  FROM sie_file 
          WHERE sie01 = l_sic05
            AND sie05 = l_sic03
            AND sie06 = l_sic11
            AND sie07 = l_sic07
            AND sie08 = l_sic04
            AND sie012 = l_sic012
            AND sie013 = l_sic013
         IF l_sie09 - l_sie11 <> 0 THEN
            CALL cl_err( p_sia01,'asf-195',0)
            RETURN
         END IF
      END FOREACH
   END IF
   IF p_argv = '2' THEN
      DECLARE i610_sic_cs1 CURSOR FOR
       SELECT DISTINCT sic03,sic15 FROM sic_file  WHERE sic01 = p_sia01
      FOREACH i610_sic_cs1 INTO l_sic03,l_sic15 
         SELECT SUM(sie09),SUM(sie11) INTO l_sie09,l_sie11  FROM sie_file
      #   WHERE sic03 = l_sic03    #TQC-B50052
      #     AND sic05 = l_sic15    #TQC-B50052 
          WHERE sie05 = l_sic03    #TQC-B50052
            AND sie15 = l_sic15    #TQC-B50052
         IF l_sie09 - l_sie11 <> 0 THEN
            CALL cl_err(p_sia01,'asf-195',0)
            RETURN
         END IF
      END FOREACH
      #MOD-D60120 add begin---------------
      DECLARE i610_siac_cs1 CURSOR FOR
      SELECT * FROM sia_file,sic_file WHERE sia01 =sic01 AND sia01 = p_sia01
      FOREACH i610_siac_cs1 INTO m_sia.*,m_sic.*
        IF STATUS THEN
          CALL cl_err('i610_siac_cs1:',STATUS,1)  
           EXIT FOREACH
        END IF      
        IF m_sia.sia04 = '1' THEN 
           SELECT COUNT(*) INTO l_cnt FROM sia_file,sic_file 
            WHERE sia01 =sic01 
              AND sia04 = '2' 
              AND sic03 = m_sic.sic03
              AND sic15 = m_sic.sic15
              AND siaconf = 'Y'
           IF l_cnt > 0 THEN 
              CALL cl_err(m_sic.sic03,'asf-238',1)
              RETURN 
           END IF     
        END IF  
      END FOREACH 
      #MOD-D60120 add end-----------------
   END IF
  #FUN-AC0074 ---------------------------End--------------------------- 
   IF p_call_transaction THEN
      BEGIN WORK
   END IF
 
   CALL i610sub_lock_cl()
   
   OPEN i610sub_cl USING l_sia.sia01
   
   IF STATUS THEN
      CALL cl_err("OPEN i610sub_cl:", STATUS, 1)
      CLOSE i610sub_cl
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N' 
      RETURN
   END IF
   
   FETCH i610sub_cl INTO l_sia.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_sia.sia01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i610sub_cl 
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N' 
      RETURN
   END IF

   
   LET g_success = 'Y'
  #UPDATE sia_file SET siaconf = 'N' WHERE sia01 = l_sia.sia01                   #FUN-D20059 Mark
   UPDATE sia_file SET siaconf = 'N',sia03 = g_today WHERE sia01 = l_sia.sia01   #FUN-D20059 Add
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   CALL i610_cancel(l_sia.*)
   
   CLOSE i610sub_cl
   IF g_success = 'Y' THEN
      IF p_call_transaction THEN
         COMMIT WORK
      END IF
   ELSE
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
   END IF
END FUNCTION

FUNCTION i610_cancel(p_sia)
 DEFINE p_sia   RECORD LIKE sia_file.*
 DEFINE l_sic   RECORD LIKE sic_file.*
 DEFINE l_sie11,l_qty  LIKE sie_file.sie11  #FUN-AC0074
  
   IF cl_null(p_sia.sia01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE i610_sic_2 CURSOR FOR
         SELECT * FROM sic_file WHERE sic01=p_sia.sia01
   FOREACH i610_sic_2 INTO l_sic.*
      IF g_argv1 = '1' THEN    #FUN-AC0074
         UPDATE sfb_file SET sfb104='N' WHERE sfb01=l_sic.sic03 
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","sfb_file",l_sic.sic03,"",SQLCA.sqlcode,"","up sfb104",1)
               LET g_success = 'N' 
               RETURN
            END IF
      END IF   #FUN-AC0074
#FUN-AC0074 -------------------------Begin----------------------------
#MOD-D60120 mark beg
#      IF g_argv1 = '2' THEN
#         #MOD-D60120 add begin-------
#         SELECT SUM(sie11) INTO l_sie11_oea FROM sie_file WHERE sie05=l_sic.sic03 AND sie15=l_sic.sic15
#         IF cl_null(l_sie11) THEN LET l_sie11_oea =0 END IF    
#         #MOD-D60120 add end---------           
#         UPDATE oeb_file SET oeb19 = 'N',
#                             oeb905 =  l_sie11_oea #MOD-D60120 add
#          WHERE oeb01 = l_sic.sic03
#            AND oeb03 = l_sic.sic15
#            IF SQLCA.SQLERRD[3]=0 THEN
#               CALL cl_err3("upd","oeb_file",l_sic.sic03,"",SQLCA.sqlcode,"","up oeb19",1)
#               LET g_success = 'N' 
#               RETURN
#            END IF 
#      END IF 
#MOD-D60120 mark end
#FUN-AC0074 -------------------------End------------------------------ 
      IF p_sia.sia04 = '2' THEN
         UPDATE sie_file SET sie11= sie11+l_sic.sic06,sie12 = g_today,sie09= sie09 + l_sic.sic06,
                sie13 = l_sic.sic01,sie14 = l_sic.sic02 
          WHERE sie01= l_sic.sic05 AND sie02= l_sic.sic08
         AND sie03=l_sic.sic09 AND sie04=l_sic.sic10 AND sie05= l_sic.sic03 AND sie06=l_sic.sic11
         AND sie07=l_sic.sic07 AND sie08=l_sic.sic04 
         AND sie012 = l_sic.sic012 AND sie013 = l_sic.sic013 AND sie15 = l_sic.sic15   #FUN-AC0074
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","sie_file",l_sic.sic05,l_sic.sic08,SQLCA.sqlcode,"","up sie10",1)
            LET g_success = 'N' 
            RETURN
         END IF
      ELSE 
        #DELETE FROM sie_file   #FUN-AC0074
         LET l_sie11=0          #FUN-AC0074
         SELECT sie11 INTO l_sie11 FROM sie_file #FUN-AC0074
          WHERE sie01= l_sic.sic05 AND sie02= l_sic.sic08
            AND sie03=l_sic.sic09 AND sie04=l_sic.sic10 AND sie05= l_sic.sic03 AND sie06=l_sic.sic11
            AND sie07=l_sic.sic07 AND sie08=l_sic.sic04 
            AND sie012 = l_sic.sic012 AND sie013 = l_sic.sic013 AND sie15 = l_sic.sic15   #FUN-AC0074
         #FUN-AC0074--begin--add----
         IF cl_null(l_sie11) THEN LET l_sie11=0  END IF 
         LET l_qty = l_sie11 - l_sic.sic06
         IF l_qty > 0 THEN
            UPDATE sie_file SET sie11 = l_qty 
             WHERE sie01= l_sic.sic05 AND sie02= l_sic.sic08
               AND sie03=l_sic.sic09 AND sie04=l_sic.sic10 AND sie05= l_sic.sic03 AND sie06=l_sic.sic11
               AND sie07=l_sic.sic07 AND sie08=l_sic.sic04 
               AND sie012 = l_sic.sic012 AND sie013 = l_sic.sic013 AND sie15 = l_sic.sic15 
         ELSE
            DELETE FROM sie_file
             WHERE sie01= l_sic.sic05 AND sie02= l_sic.sic08
               AND sie03=l_sic.sic09 AND sie04=l_sic.sic10 AND sie05= l_sic.sic03 AND sie06=l_sic.sic11
               AND sie07=l_sic.sic07 AND sie08=l_sic.sic04 
               AND sie012 = l_sic.sic012 AND sie013 = l_sic.sic013 AND sie15 = l_sic.sic15
         END IF
         #FUN-AC0074--end--add---
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","sie_file",l_sic.sic01,l_sic.sic02,SQLCA.sqlcode,"","up sie10",1)
            LET g_success = 'N' 
            RETURN
          END IF  
      END IF  
      DELETE FROM sif_file WHERE sif11=l_sic.sic01 AND sif12 = l_sic.sic02 
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","sie_file",l_sic.sic01,l_sic.sic02,SQLCA.sqlcode,"","del",1)
         LET g_success = 'N' 
         RETURN
      END IF 
      #MOD-D60120 add beg---------
      IF g_argv1 = '2' THEN
         #MOD-D60120 add begin-------
         LET l_sie11 =0
         SELECT SUM(sie11) INTO l_sie11 FROM sie_file WHERE sie05=l_sic.sic03 AND sie15=l_sic.sic15
         IF cl_null(l_sie11) THEN LET l_sie11 =0 END IF    
         #MOD-D60120 add end---------           
         UPDATE oeb_file SET oeb19 = 'N',
                             oeb905 =  l_sie11 #MOD-D60120 add
          WHERE oeb01 = l_sic.sic03
            AND oeb03 = l_sic.sic15
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","oeb_file",l_sic.sic03,"",SQLCA.sqlcode,"","up oeb19",1)
               LET g_success = 'N' 
               RETURN
            END IF 
      END IF  
      #MOD-D60120 add end----------------        
      CALL i610sub_ins_sig(p_sia.sia04,l_sic.*)          
      IF g_success = 'N' THEN 
         RETURN
      END IF              	       
   END FOREACH   
END FUNCTION           

#FUN-AC0074 ----------------------Begin---------------------------
#FUNCTION i610_img10_count(p_sic05,p_sic08,p_sic09,p_sic10,p_sic06,p_sic07) #MOD-D60230 mark
FUNCTION i610_img10_count(p_sic05,p_sic08,p_sic09,p_sic10,p_sic06,p_sic07,p_sic01,p_sic02,p_sic03) #MOD-D60230
   DEFINE p_sic05    LIKE sic_file.sic05
   DEFINE p_sic06    LIKE sic_file.sic06
   DEFINE p_sic07    LIKE sic_file.sic07
   DEFINE p_sic08    LIKE sic_file.sic08
   DEFINE p_sic09    LIKE sic_file.sic09
   DEFINE p_sic10    LIKE sic_file.sic10      
   DEFINE p_sic01    LIKE sic_file.sic01  #MOD-D60230 add
   DEFINE p_sic02    LIKE sic_file.sic02  #MOD-D60230 add
   DEFINE p_sic03    LIKE sic_file.sic03  #MOD-D60230 add
   DEFINE l_sic06    LIKE sic_file.sic06
   DEFINE l_img10    LIKE img_file.img10
   DEFINE l_ima25    LIKE ima_file.ima25
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_fac      LIKE ima_file.ima31_fac
   DEFINE l_sig05    LIKE sig_file.sig05
   DEFINE l_sql      STRING

   #MOD-CC0185 add start -----
   IF cl_null(p_sic08) THEN
      RETURN l_img10,l_sic06,l_sig05
   END IF
   #MOD-CC0185 add end   -----

   IF cl_null(p_sic09) THEN LET p_sic09 = ' ' END IF
   IF cl_null(p_sic10) THEN LET p_sic10 = ' ' END IF

#MOD-D60230 add begin----------------------------
   SELECT SUM(sic06) INTO l_sic06 FROM sic_file,sia_file
    WHERE sia01 = sic01 AND sic03 = p_sic03 
      AND sic07 = p_sic07 AND sic08 = p_sic08 AND sic09 = p_sic09
      AND sic10 = p_sic10 AND sic05 = p_sic05
      AND ((sic01 = p_sic01  AND sic02 <> p_sic02) OR sic01<>p_sic01)
      AND siaconf = 'N'
      AND siaacti = 'Y'
   IF cl_null(l_sic06) OR SQLCA.SQLCODE = 100 THEN
      LET l_sic06 = 0
   END IF
#MOD-D60230 add end------------------------------
   LET l_sql = "SELECT SUM(img10*img21) FROM img_file WHERE img01='",p_sic05,"'",
                                                      " AND img03='",p_sic09,"'",
                                                      " AND img04='",p_sic10,"'" 
   IF NOT cl_null(p_sic08) THEN
      LET l_sql=l_sql CLIPPED," AND img02='",p_sic08,"'"
   END IF
   PREPARE i600_pre FROM l_sql
   DECLARE i600_img10 CURSOR FOR i600_pre
   LET l_sql = "SELECT SUM(sig05) FROM sig_file ",
               " WHERE sig01 = '",p_sic05,"'",
               "   AND sig03 = '",p_sic09,"'",
               "   AND sig04 = '",p_sic10,"'"
   IF NOT cl_null(p_sic08) THEN
     LET l_sql=l_sql CLIPPED," AND sig02='",p_sic08,"'"
   END IF
   PREPARE i600_pre_1 FROM l_sql
   DECLARE i600_sig05 CURSOR FOR i600_pre_1
   OPEN i600_img10
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE i600_img10
   ELSE
      FETCH i600_img10 INTO l_img10
      IF SQLCA.sqlcode THEN
          CALL cl_err('i600_img10:',SQLCA.sqlcode,0)
          CLOSE i600_img10
      END IF
      SELECT ima25 INTO l_ima25 FROM ima_file
       WHERE ima01=p_sic05 
      CALL s_umfchk(p_sic05,p_sic07,l_ima25)
         RETURNING l_flag,l_fac
      IF l_flag THEN
         CALL cl_err('','',0)
      ELSE
        #LET l_sic06=p_sic06 * l_fac               #MOD-D60230 mark
         LET l_sic06=(p_sic06+l_sic06) * l_fac     #MOD-D60230 add
      END IF
   END IF
   OPEN i600_sig05
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE i600_sig05
   ELSE
      FETCH i600_sig05 INTO l_sig05
      IF SQLCA.sqlcode THEN
          CALL cl_err('i600_sie11:',SQLCA.sqlcode,0)
          CLOSE i600_sig05
      END IF
     CALL s_umfchk(p_sic05,p_sic07,l_ima25)
         RETURNING l_flag,l_fac
      IF l_flag THEN
         CALL cl_err('','',0)
      ELSE
         LET l_sig05= l_sig05* l_fac
         LET l_sig05= s_digqty(l_sig05,l_ima25)   #FUN-910088--add--
      END IF
   END IF
   IF cl_null(l_img10) THEN LET l_img10=0 END IF
   IF cl_null(l_sic06) THEN LET l_sic06=0 END IF
   IF cl_null(l_sig05) THEN LET l_sig05=0 END IF
   RETURN l_img10,l_sic06,l_sig05

END FUNCTION
FUNCTION i610sub_chk_sic06(p_sia04,p_argv,m_sic01,m_sic02,m_sic03,m_sic05,m_sic06,m_sic07,m_sic11,m_sic15,m_sic012,m_sic013)
   DEFINE    p_sia04      LIKE sia_file.sia04
   DEFINE    p_argv       LIKE type_file.chr1
   DEFINE    m_sic01      LIKE sic_file.sic01
   DEFINE    m_sic02      LIKE sic_file.sic02
   DEFINE    m_sic03      LIKE sic_file.sic03
   DEFINE    m_sic05      LIKE sic_file.sic05
   DEFINE    m_sic06      LIKE sic_file.sic06
   DEFINE    m_sic07      LIKE sic_file.sic07
   DEFINE    m_sic11      LIKE sic_file.sic11
   DEFINE    m_sic15      LIKE sic_file.sic15
   DEFINE    m_sic012     LIKE sic_file.sic012
   DEFINE    m_sic013     LIKE sic_file.sic013
   DEFINE    l_sie11      LIKE sie_file.sie11
   DEFINE    l_oeb12x     LIKE oeb_file.oeb12
   DEFINE    l_oeb24x     LIKE oeb_file.oeb24
   DEFINE    l_sfa05      LIKE sfa_file.sfa05
   DEFINE    l_sfa06      LIKE sfa_file.sfa06
   DEFINE    l_sic06      LIKE sic_file.sic06
   LET g_success = 'Y'
   IF p_sia04 = '1' THEN
      IF m_sic06 <0 THEN
         CALL cl_err(m_sic06,"sia-101",1)
         LET g_success = 'N'
      END IF
      LET l_sie11 =  0
      LET l_sic06 = 0
      IF p_argv = '2' THEN
         LET l_oeb12x = 0
         LET l_oeb24x = 0
         SELECT oeb12,oeb24 INTO l_oeb12x,l_oeb24x FROM oeb_file
          WHERE oeb01 = m_sic03
            AND oeb03 = m_sic15
         SELECT SUM(sie11) INTO l_sie11 FROM sie_file
          WHERE sie01 = m_sic05
            AND sie05 = m_sic03
            AND sie15 = m_sic15
         IF cl_null(l_sie11) OR SQLCA.SQLCODE = 100 THEN
            LET l_sie11 = 0
         END IF  
         SELECT SUM(sic06) INTO l_sic06 FROM sic_file,sia_file
          WHERE sia01 = sic01
            AND sic03 = m_sic03
            AND sic15 = m_sic15
            AND ((sic01 = m_sic01  AND sic02 <> m_sic02) OR sic01<>m_sic01)
            AND siaconf = 'N'
            AND siaacti = 'Y'
         #  AND siaconf <> 'X'
         IF cl_null(l_sic06) OR SQLCA.SQLCODE = 100 THEN
            LET l_sic06 = 0
         END IF

         IF l_sie11+m_sic06+l_sic06 > l_oeb12x-l_oeb24x THEN
            CALL cl_err(m_sic03,'asf-189',0)
            LET g_success = 'N'
         END IF
      END IF
      IF p_argv = '1' THEN

         SELECT SUM(sfa05-sfa065),SUM(sfa06)  # 扣除代買部分
           INTO l_sfa05,l_sfa06
           FROM sfa_file
          WHERE sfa01 = m_sic03
            AND sfa03 = m_sic05
            AND sfa08 = m_sic11
            AND sfa12 = m_sic07
            AND sfa012 = m_sic012
            AND sfa013 = m_sic013
          IF SQLCA.SQLCODE  OR cl_null(l_sfa05) OR cl_null(l_sfa06) THEN
              LET l_sfa05 = 0
              LET l_sfa06 = 0
          END IF
 

         SELECT SUM(sie11) INTO l_sie11 FROM sie_file
          WHERE sie01 = m_sic05
            AND sie05 = m_sic03
            AND sie06 = m_sic11
            AND sie07 = m_sic07
            AND sie012 = m_sic012
            AND sie013 = m_sic013
         IF cl_null(l_sie11) OR SQLCA.SQLCODE = 100 THEN
            LET l_sie11 = 0
         END IF
         SELECT SUM(sic06) INTO l_sic06 FROM sic_file,sia_file
          WHERE sia01 = sic01
            AND sic05 = m_sic05
            AND sic03 = m_sic03
            AND sic07 = m_sic07
            AND sic11 = m_sic11
            AND sic012 = m_sic012
            AND sic013 = m_sic013     
            AND ((sic01 = m_sic01 AND sic02 <> m_sic02) OR sic01 <> m_sic01)
            AND siaconf = 'N'
         #  AND siaconf <> 'X'
            AND siaacti = 'Y'
         IF cl_null(l_sic06) OR SQLCA.SQLCODE = 100 THEN
            LET l_sic06 = 0
         END IF

         IF l_sie11+l_sic06+m_sic06 > l_sfa05-l_sfa06 THEN
            CALL cl_err(m_sic03,'asf-189',0)
            LET g_success = 'N'
         END IF
      END IF
   END IF
   IF p_sia04 = '2' THEN
      IF m_sic06 < 0 THEN
         CALL cl_err(m_sic06,"sia-101",1)
         LET g_success = 'N'
      END IF
      LET l_sie11 =  0  
      LET l_sic06 = 0
      IF p_argv = '2' THEN
         SELECT SUM(sie11) INTO l_sie11 FROM sie_file
          WHERE sie05 = m_sic03
            AND sie15 = m_sic15
            AND sie01 = m_sic05
         IF cl_null(l_sie11) OR SQLCA.SQLCODE = 100 THEN
            LET l_sie11 = 0
         END IF
         IF m_sic06 > l_sie11 THEN
            CALL cl_err(m_sic06,'asf-190',0)
            LET g_success = 'N'
         END IF
      END IF
      IF p_argv = '1' THEN
         SELECT SUM(sie11) INTO l_sie11 FROM sie_file
          WHERE sie05 = m_sic03
            AND sie01 = m_sic05
            AND sie06 = m_sic11
            AND sie07 = m_sic07
            AND sie012 = m_sic012
            AND sie013 = m_sic013
         IF cl_null(l_sie11) OR SQLCA.SQLCODE = 100 THEN
            LET l_sie11 = 0
         END IF
         IF m_sic06 > l_sie11 THEN
            CALL cl_err(m_sic06,'asf-190',0)
            LET g_success = 'N'
         END IF
      END IF
   END IF
END FUNCTION
#FUN-AC0074 ----------------------End------------------------------
#FUN-A20048 add                       
