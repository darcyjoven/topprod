# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Program name...: s_bart110.4gl
# Descriptions...: 將ibj_file.ibj01='1'的收貨掃描資料，產生ERP收貨單
# Date & Author..: No:DEV-D20004 2013/02/09 By Nina 
# Usage..........: CALL s_bart110()
# Return Code....: 執行結果,單號起迄字串 
# Modify.........: No:DEV-D30018 13/03/04 By Nina 修改Return值原本只傳TRUE/FALSE，改成傳字元判斷執行成功、執行失敗、無資料三種狀態
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.DEV-D30037 13/03/21 By TSD.JIE 有用smyb01="2:條碼單據"的控卡的改為用單身任一筆(MIN(項次)判斷即可)料件是否為包號管理(ima931)='Y'

#DEV-D20004 add str------------------------   
DATABASE ds 
    
GLOBALS "../../config/top.global" 
GLOBALS "../../aba/4gl/barcode.global"

DEFINE g_pmm    RECORD  LIKE pmm_file.*
DEFINE g_pmn    RECORD  LIKE pmn_file.*
DEFINE l_flag           LIKE type_file.chr1
DEFINE l_rva01_s    LIKE   rva_file.rva01
DEFINE l_rva01_e    LIKE   rva_file.rva01

FUNCTION s_bart110()
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_buf           LIKE type_file.chr100

   LET g_success = 'Y'
   LET l_cnt = 0
   SELECT COUNT(*) 
     INTO l_cnt
     FROM (SELECT unique ibj15 
             FROM ibj_file
            WHERE ibj01 = '1'         
              AND ibj13 = g_user
	      AND (ibj08='' OR ibj08 IS NULL) )   
 
   IF l_cnt > 0 THEN
      IF cl_confirm('aba-142') THEN 
         IF l_cnt > 1 THEN
            CALL cl_err('','aba-143',1)   #有前次掃描，但尚未產生收貨單的收貨資料(條碼)，將一併產生！
         END IF
         CALL s_bart110_gen()          #產生收貨單FUNCTION
         IF l_flag = 'N' THEN
            LET g_success = 'N'
         END IF
      ELSE
         LET g_success = 'N'
      END IF
   ELSE 
     #CALL cl_err('','aba-144',1)         #無可產生收貨單的條碼資訊   #DEV-D30018 mark
      LET g_success = 'N'
      RETURN 'Z',''                       #DEV-D30018 add
   END IF
   IF g_success = 'N' THEN
     #RETURN FALSE,''                     #DEV-D30018 mark
      RETURN 'N',''                       #DEV-D30018 add 
   ELSE
      LET l_buf = l_rva01_s,' ~ ',l_rva01_e
     #RETURN TRUE,l_buf                   #DEV-D30018 mark
      RETURN 'Y',l_buf                    #DEV-D30018 add
   END IF
END FUNCTION 

FUNCTION s_bart110_gen()
   DEFINE l_smyslip    LIKE   smy_file.smyslip
   DEFINE l_smyapr     LIKE   smy_file.smyapr
   DEFINE l_ibj06      LIKE   ibj_file.ibj06
   DEFINE l_ibj07      LIKE   ibj_file.ibj07
   DEFINE l_ibj03      LIKE   ibj_file.ibj03
   DEFINE l_ibj04      LIKE   ibj_file.ibj04
   DEFINE l_ibj05      LIKE   ibj_file.ibj05
   DEFINE l_ac         LIKE   type_file.num5
   DEFINE l_result     LIKE   type_file.num5
   DEFINE l_cnt        LIKE   type_file.num5
   DEFINE l_sql        LIKE   type_file.chr1000
   DEFINE l_gen_b      LIKE   type_file.chr1000
   DEFINE l_pmm09      LIKE   pmm_file.pmm09
   DEFINE l_pmm09_chk  LIKE   pmm_file.pmm09
   DEFINE l_rvb39      LIKE   rvb_file.rvb39
   DEFINE g_rva    RECORD  LIKE rva_file.*
   DEFINE g_rvb    RECORD  LIKE rvb_file.*

  ####取得收貨單別###
   LET l_smyslip = ''
   LET l_smyapr = ''
   SELECT a.smyslip,a.smyapr     
     INTO l_smyslip,l_smyapr
     FROM smy_file a
   #INNER JOIN smyb_file b ON b.smybslip = a.smyslip #DEV-D30037--mark
    WHERE a.smysys  ='apm'  #採購系統
      AND a.smykind ='3'    #收貨單
   #  AND b.smyb01  ='2'    #條碼使用單別            #DEV-D30037--mark
      AND ROWNUM = 1         #可能會有多筆，取第一筆

   IF cl_null(l_smyslip) THEN			
      CALL cl_err3("sel","smy_file",l_smyslip,"","apm1094","","",1)			
      LET g_success = 'N'
      RETURN 
   ELSE
      LET l_pmm09_chk = ' '
      LET l_flag = 'N'
      ###要產生收貨單的掃描資訊###
      DECLARE s_gen_bcl CURSOR WITH HOLD FOR
        SELECT b.pmm09,a.ibj06, a.ibj07, a.ibj03, a.ibj04, SUM(a.ibj05)											
          FROM ibj_file a
         INNER JOIN pmm_file b ON b.pmm01 = a.ibj06  											
         WHERE a.ibj01 = '1'                     #收貨掃描作業											
           AND a.ibj13 = g_user                  #過濾該USER的掃描資訊											
           AND (a.ibj08 = '' OR a.ibj08 IS NULL) #尚未拋轉收貨單											
        GROUP BY b.pmm09, a.ibj06, a.ibj07, a.ibj03, a.ibj04											
        ORDER BY b.pmm09, a.ibj06, a.ibj07, a.ibj03, a.ibj04											

      ###取得收貨單單身資料###
      LET l_sql = " SELECT pmm_file.*,pmn_file.*       ",
                  "   FROM pmm_file,pmn_file  	        ",		
                  "  WHERE pmn01 = pmm01 	        ",		
                  "    AND pmm18 <> 'X'    	        ",		
                  "    AND (pmn20-pmn50+pmn55+pmn58>0) ", 			
                  "    AND pmn16 = '2' 	        ",	
                  "    AND pmn01 = ?                   ",		
                  "    AND pmn02 = ?                   "			
      PREPARE s_gen_b FROM l_sql
      DECLARE s_gen_b_bcl CURSOR WITH HOLD FOR s_gen_b
      FOREACH s_gen_bcl INTO l_pmm09,l_ibj06,l_ibj07,l_ibj03,l_ibj04,l_ibj05
         IF SQLCA.sqlcode THEN
            CALL cl_err('s_gen_bcl foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF

         FOREACH s_gen_b_bcl USING l_ibj06,l_ibj07 INTO g_pmm.*,g_pmn.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('s_gen_bcl foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
         LET l_flag = 'Y'  #判斷是否有進FOREACH迴圈處理資料
            
            IF l_pmm09_chk <> l_pmm09 THEN
               LET l_cnt = 1
               CALL s_auto_assign_no("apm",l_smyslip,g_today,'3',"rva_file","rva01","","","") 	#自動取得單號		
                    RETURNING l_result,g_rva.rva01			
               IF (NOT l_result) THEN			
                  LET g_success ='N'			
                  RETURN			
               END IF
               IF cl_null(l_rva01_s) THEN LET l_rva01_s = g_rva.rva01 END IF    #紀錄第一張單號
               LET  l_rva01_e = g_rva.rva01                                     #紀錄最後一張單號
              ###取得收貨單單頭資料###			
              #LET g_rva.rva02 = l_ibj06
               LET g_rva.rva05 = g_pmm.pmm09
               LET g_rva.rva06 = g_today 
               LET g_rva.rva04 = 'N'
               LET g_rva.rva32 = '0'
               LET g_rva.rva33 = g_user
               LET g_rva.rva10 = 'REG'
               LET g_rva.rvamksg= l_smyapr    
               LET g_rva.rva29 = '1'
               LET g_rva.rvaconf = 'N'
               LET g_rva.rvaspc  = '0'                              
               LET g_rva.rvauser = g_user                                                          
               LET g_rva.rvacrat = g_today                     
               LET g_rva.rvaacti = 'Y'     
               LET g_rva.rvaoriu = g_user                    
               LET g_rva.rvaorig = g_grup   
               LET g_rva.rvagrup = g_grup      
               LET g_rva.rvaplant = g_plant
               LET g_rva.rvalegal = g_legal        
               IF g_azw.azw04='2' THEN
                  LET g_rva.rva30 = g_plant
                  LET g_rva.rvacrat= g_today
               END IF
            
               LET g_plant_new = ' '
               LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'rva_file'),
                           " (rva01,rva02,rva05,rva06,rva04, ",
                           "  rva32,rva33,rva10,rvamksg,rva29, ",
                           "  rvaconf,rvaspc,rvauser,rvacrat,rvaacti, ",
                           "  rvaoriu,rvaorig,rvagrup,rvaplant,rvalegal)     ",
                           "VALUES(?,?,?,?,?,  ?,?,?,?,?,    ",
                           "       ?,?,?,?,?,  ?,?,?,?,?  )  "
               PREPARE ins_prep FROM l_sql
               EXECUTE ins_prep USING
                     g_rva.rva01,g_rva.rva02,g_rva.rva05,g_rva.rva06,
                     g_rva.rva04,g_rva.rva32,g_rva.rva33,g_rva.rva10,
                     g_rva.rvamksg,g_rva.rva29,g_rva.rvaconf,g_rva.rvaspc,
                     g_rva.rvauser,g_rva.rvacrat,g_rva.rvaacti,g_rva.rvaoriu,
                     g_rva.rvaorig,g_rva.rvagrup,g_rva.rvaplant,g_rva.rvalegal
                     
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('rva01',g_rva.rva01,'s_rva:ins rva',STATUS,1)
                  ELSE
                      CALL cl_err3("ins","rva_file",g_rva.rva01,"",STATUS,"","",1)
                  END IF
                  LET g_success='N'
                  RETURN
               END IF
            ELSE
               LET l_cnt = l_cnt + 1
            END IF
            
            CALL p110_get_rvb39(g_pmn.pmn01,g_pmn.pmn04,g_pmn.pmn65) RETURNING l_rvb39

            LET g_rvb.rvb01     = g_rva.rva01				
            LET g_rvb.rvb02     = l_cnt
            LET g_rvb.rvb04     = g_pmn.pmn01				
            LET g_rvb.rvb03     = g_pmn.pmn02				
            LET g_rvb.rvb34     = g_pmn.pmn41				
            LET g_rvb.rvb05     = g_pmn.pmn04				
            LET g_rvb.rvb051    = g_pmn.pmn041      				
            LET g_rvb.rvb36     = l_ibj03				
            LET g_rvb.rvb37     = l_ibj04           				
            LET g_rvb.rvb07     = l_ibj05
            LET g_rvb.rvb90     = g_pmn.pmn07       				
            LET g_rvb.rvb30     = 0				
            LET g_rvb.rvb31     = 0				
            LET g_rvb.rvb29     = 0				
            LET g_rvb.rvb89     = g_pmn.pmn89       				
            LET g_rvb.rvb35     = 'N'				
            LET g_rvb.rvb42     = '4'     				
            LET g_rvb.rvb38     = g_pmn.pmn56				
            LET g_rvb.rvb25     = g_pmn.pmn71     				
            LET g_rvb.rvb83     = g_pmn.pmn83				
            LET g_rvb.rvb84     = g_pmn.pmn84				
            LET g_rvb.rvb85     = g_pmn.pmn85				
            LET g_rvb.rvb80     = g_pmn.pmn80				
            LET g_rvb.rvb81     = g_pmn.pmn81				
            LET g_rvb.rvb82     = g_pmn.pmn82				
            LET g_rvb.rvb86     = g_pmn.pmn86				
            LET g_rvb.rvb87     = g_pmn.pmn87				
            LET g_rvb.rvb10     = g_pmn.pmn31				
            LET g_rvb.rvb10t    = g_pmn.pmn31t				
            LET g_rvb.rvb919    = g_pmn.pmn919   				
            LET g_rvb.rvb90     = g_pmn.pmn07    				
            LET g_rvb.rvb930    = g_pmn.pmn930				
            LET g_rvb.rvbplant  = g_plant 				
            LET g_rvb.rvblegal  = g_legal    				
            LET g_rvb.rvb19     = g_pmn.pmn65
            LET g_rvb.rvb39     = l_rvb39
            LET g_rvb.rvb06     = 0     #已請數量
            LET g_rvb.rvb08     = 0     #收貨量
            LET g_rvb.rvb09     = 0     #允請數量

            LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'rvb_file'),
                        " (rvb01,rvb02,rvb04,rvb03,rvb34,    ",
                        "  rvb05,rvb051,rvb36,               ",
                        "  rvb37,rvb07,rvb90,rvb30,rvb29,    ",
                        "  rvb89,rvb35,rvb42,rvb38,          ",
                        "  rvb25,rvb83,rvb84,rvb85,rvb80,    ",
                        "  rvb81,rvb82,rvb86,rvb87,rvb10,    ",
                        "  rvb10t,rvb919,rvb930,             ",
                        "  rvb06,rvb08,rvb09,rvb31,          ",
                        "  rvbplant,rvblegal)                ",
                        "VALUES(?,?,?,?,?,  ?,?,?,?,?,    ",
                        "       ?,?,?,?,?,  ?,?,?,?,?,    ",
                        "       ?,?,?,?,?,  ?,?,?,?,?,    ",
                        "       ?,?,?,?,?,  ?          )  "
            PREPARE ins_prep_b FROM l_sql
            EXECUTE ins_prep_b USING
                  g_rvb.rvb01,g_rvb.rvb02,g_rvb.rvb04,g_rvb.rvb03,
                  g_rvb.rvb34,g_rvb.rvb05,g_rvb.rvb051,
                  g_rvb.rvb36,g_rvb.rvb37,g_rvb.rvb07,
                  g_rvb.rvb90,g_rvb.rvb30,g_rvb.rvb29,g_rvb.rvb89,                  
                  g_rvb.rvb35,g_rvb.rvb42,g_rvb.rvb38,g_rvb.rvb25,
                  g_rvb.rvb83,g_rvb.rvb84,g_rvb.rvb85,g_rvb.rvb80,
                  g_rvb.rvb81,g_rvb.rvb82,g_rvb.rvb86,g_rvb.rvb87,
                  g_rvb.rvb10,g_rvb.rvb10t,g_rvb.rvb919,
                  g_rvb.rvb930,g_rvb.rvb06,g_rvb.rvb08,g_rvb.rvb09,
                  g_rvb.rvb31,g_rvb.rvbplant,g_rvb.rvblegal
            
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               IF g_bgerr THEN
                  CALL s_errmsg('rvb01',g_rvb.rvb01,'s_rvb:ins rvb',STATUS,1)
               ELSE
                   CALL cl_err3("ins","rvb_file",g_rvb.rvb01,"",STATUS,"","",1)
               END IF
               LET g_success='N'
               RETURN
            ELSE
               UPDATE ibj_file  			
                  SET ibj08 = g_rvb.rvb01, ibj09 = g_rvb.rvb02
                WHERE ibj01 = '1' AND			
                      ibj13 = g_user AND   #該USER的掃描資訊			
                      ibj07 = l_ibj07 AND  #採購單號
                      ibj06 = l_ibj06 AND  #採購單項次
                      ibj03 = l_ibj03 AND  #倉庫
                      ibj04 = l_ibj04 AND  #儲位
                      (ibj08 = '' OR ibj08 = ' ' OR ibj08 IS NULL) #尚未拋轉收貨單

               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN				
                  CALL cl_err3("upd","ibj_file",g_rvb.rvb01,"",STATUS,"","",1)
                  LET g_success='N'
                  RETURN
               END IF				
            END IF
         END FOREACH
         LET l_pmm09_chk = l_pmm09
      END FOREACH
      CLOSE s_gen_bcl
      CLOSE s_gen_b_bcl
   END IF
END FUNCTION

FUNCTION p110_get_rvb39(p_rvb04,p_rvb05,p_rvb19)
   DEFINE l_pmh08   LIKE pmh_file.pmh08,
          l_pmm22   LIKE pmm_file.pmm22,
          p_rvb04   LIKE rvb_file.rvb04,
          p_rvb05   LIKE rvb_file.rvb05,
          p_rvb19   LIKE rvb_file.rvb19,
          l_rvb39   LIKE rvb_file.rvb39
   DEFINE l_ima915  LIKE ima_file.ima915   #FUN-710060 add
   DEFINE l_pmh21   LIKE pmh_file.pmh21,   #No.CHI-8C0017
          l_pmh22   LIKE pmh_file.pmh22    #No.CHI-8C0017

  #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
  #                        #                   2: 不作料件供應商管制
   LET l_ima915 = ''
   SELECT ima915 INTO l_ima915 FROM ima_file
    WHERE ima01=p_rvb05
   IF l_ima915='2' OR l_ima915='3' THEN
      LET l_pmm22 = ''
      SELECT pmm22 INTO l_pmm22 FROM pmm_file
       WHERE pmm01=p_rvb04

      IF g_pmm.pmm02='SUB' THEN
         LET l_pmh22='2'
           IF g_pmn.pmn43 = 0 OR cl_null(g_pmn.pmn43) THEN    
            LET l_pmh21 =' '
         ELSE
           LET l_pmh21 = ''
           IF NOT cl_null(g_pmn.pmn18) THEN
            SELECT sgm04 INTO l_pmh21 FROM sgm_file
             WHERE sgm01=g_pmn.pmn18
               AND sgm02=g_pmn.pmn41
               AND sgm03=g_pmn.pmn43
               AND sgm012 = g_pmn.pmn012   
           ELSE
            SELECT ecm04 INTO l_pmh21 FROM ecm_file
             WHERE ecm01=g_pmn.pmn41
               AND ecm03=g_pmn.pmn43
               AND ecm012 = g_pmn.pmn012    
           END IF
         END IF     
      ELSE
         LET l_pmh22='1'
         LET l_pmh21=' '
      END IF

      LET l_pmh08 = ''
      SELECT pmh08 INTO l_pmh08 FROM pmh_file
       WHERE pmh01=p_rvb05
         AND pmh02=g_rva.rva05
         AND pmh13=l_pmm22
         AND pmh21 = l_pmh21                                                     
         AND pmh22 = l_pmh22                                                     
         AND pmh23 = ' '                                            
         AND pmhacti = 'Y'                                          

      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF

      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   ELSE
      LET l_pmh08 = ''
      SELECT ima24 INTO l_pmh08 FROM ima_file
       WHERE ima01=p_rvb05

      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF

      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   END IF

   IF l_pmh08='N' OR     #免驗料
      (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
      p_rvb19='2' THEN #委外代買料
      LET l_rvb39 = 'N'
   ELSE
      LET l_rvb39 = 'Y'
   END IF

   RETURN l_rvb39
END FUNCTION
#DEV-D20004 add end------------------------   
#DEV-D30025--add
