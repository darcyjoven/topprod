# Prog. Version..: '5.30.07-13.05.31(00005)'     #
# Pattern name...: s_t114_gl.4gl
# Descriptions...: 會計分錄產生
# Date & Author..: 12/01/12 FUN-BC0035 By Sakura
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3處理的地方加npptype判斷
# Modify.........: No:MOD-C70136 12/07/13 By Polly 異動前資產科目fby05列為貸方，異動後資產科目fby09列為借方
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds

GLOBALS "../../config/top.global"
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_no	        LIKE type_file.chr20
   DEFINE g_date        LIKE type_file.dat
   DEFINE g_chr         LIKE type_file.chr1
   DEFINE g_msg         LIKE type_file.chr1000
   DEFINE g_bookno1     LIKE aza_file.aza81         
   DEFINE g_bookno2     LIKE aza_file.aza82         
   DEFINE g_bookno      LIKE aza_file.aza81         
   DEFINE g_flag        LIKE type_file.chr1         
   DEFINE g_npq25       LIKE npq_file.npq25         
   DEFINE g_azi04_2     LIKE azi_file.azi04         

FUNCTION t114_gl(p_no,p_date,p_npptype) #p_npptype='0'財簽一,p_npptype='1'財簽二
   DEFINE p_no    	LIKE type_file.chr20
   DEFINE p_date  	LIKE type_file.dat
   DEFINE p_npptype     LIKE npp_file.npptype     
   DEFINE l_buf		LIKE type_file.chr1000
   DEFINE l_n  		LIKE type_file.num5
   DEFINE l_t1          LIKE type_file.chr5
   DEFINE l_fahdmy3     LIKE fah_file.fahdmy3

   WHENEVER ERROR CONTINUE
   LET g_no = p_no LET g_date = p_date 
   IF cl_null(g_no) THEN RETURN END IF
   IF p_npptype = "0" THEN
      IF p_date < g_faa.faa09 THEN   #立帳日期小於關帳日期
         CALL cl_err(g_no,'aap-176',1)
         RETURN
      END IF
   ELSE
      IF p_date < g_faa.faa092 THEN   #立帳日期小於關帳日期
         CALL cl_err(g_no,'aap-176',1)
         RETURN
      END IF
   END IF
   LET l_t1 = s_get_doc_no(p_no)
   LET l_fahdmy3 = ' '
   #SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1 #FUN-C30313 mark
#FUN-C30313---add---START-----
   IF p_npptype = '0' THEN
      SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
   ELSE
      SELECT fahdmy32 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
   END IF
#FUN-C30313---add---END-------
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","fah_file",l_t1,"",SQLCA.sqlcode,"","sel fah",0)   
   END IF
   #---->是否拋轉傳票
   IF l_fahdmy3 != 'Y' THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM npq_file WHERE npq01  = g_no 
                                            AND npqsys = 'FA'
                                            AND npq00  = 14
                                            AND npq011 = 1
   IF l_n > 0 THEN
      IF p_npptype = '0' THEN     
         IF NOT s_ask_entry(g_no) THEN RETURN END IF
      END IF     
   END IF
   DELETE FROM npp_file WHERE npp01   = g_no
                          AND nppsys  = 'FA'
                          AND npp00   = 14
                          AND npp011  = 1
                          AND npptype = p_npptype     
   DELETE FROM npq_file WHERE npq01   = g_no
                          AND npqsys  = 'FA'
                          AND npq00   = 14
                          AND npq011  = 1
                          AND npqtype = p_npptype     
   CALL s_t114(p_npptype)     
   DELETE FROM npq_file WHERE npq01=g_no    AND npq03='-'
                          AND npqsys = 'FA' AND npq00 = 14
                          AND npq011=1
                          AND npqtype = p_npptype
   CALL t114_gen_diff()
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
   
FUNCTION s_t114(p_npptype)      
DEFINE p_npptype  LIKE npp_file.npptype      
DEFINE l_fbz10    LIKE fbz_file.fbz10,  
       l_fbz11    LIKE fbz_file.fbz11,  
       l_fbz12    LIKE fbz_file.fbz12,  
       l_fby      RECORD LIKE fby_file.*,
       l_faj23    LIKE faj_file.faj23,
       l_faj24    LIKE faj_file.faj24,
       l_faj53    LIKE faj_file.faj53,  #資產科目
       l_faj54    LIKE faj_file.faj54,  #累折科目
       l_faj531   LIKE faj_file.faj531, #資產科目
       l_faj541   LIKE faj_file.faj541, #累折科目
       l_faj32    LIKE faj_file.faj32,  #累折
       l_faj14    LIKE faj_file.faj14,  #成本
       l_faj141   LIKE faj_file.faj141, #調整成本
       l_aag05    LIKE aag_file.aag05,
       l_aag051   LIKE aag_file.aag05,
       l_sql      LIKE type_file.chr1000
DEFINE l_aaa03    LIKE aaa_file.aaa03
DEFINE l_faj142   LIKE faj_file.faj142
DEFINE l_faj1412  LIKE faj_file.faj1412 
DEFINE l_faj232   LIKE faj_file.faj232
DEFINE l_faj242   LIKE faj_file.faj242
DEFINE l_faj322   LIKE faj_file.faj322
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   #-------------(單頭)-----------------------------------
   LET g_npp.nppsys = 'FA'        LET g_npp.npp00 = 14
   LET g_npp.npp01  = g_no        LET g_npp.npp011= 1
   LET g_npp.npp02  = g_date      LET g_npp.npp03  = g_date
   LET g_npp.npptype = p_npptype     
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npp_file",g_npp.npp01,g_npp.nppsys,SQLCA.sqlcode,"","ins npp",1)   
      LET g_success='N'
   END IF

   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(g_npp.npp02,'aoo-081',1)
      LET g_success = 'N'
   END IF
   #-------------(單身)-----------------------------------
   LET g_npq.npqsys  = 'FA'        LET g_npq.npq00  = 14 
   LET g_npq.npq01   = g_no        LET g_npq.npq011 = 1
   LET g_npq.npq02   = 0           LET g_npq.npq04  = NULL        
   LET g_npq.npq21   = NULL        LET g_npq.npq22  = NULL 
   LET g_npq.npq24   = g_aza.aza17 LET g_npq.npq25  = 1          
   LET g_npq.npqtype = p_npptype     
   LET g_npq.npqlegal = g_legal
   LET g_npq25 = g_npq.npq25      
   
   IF g_npq.npqtype = '0' THEN
      LET g_bookno = g_bookno1
   ELSE
      LET g_bookno2 = g_faa.faa02c
      LET g_bookno = g_bookno2   #No.FUN-D40118   Add
   END IF

   LET l_sql = "SELECT fby_file.*,",
               " faj23, faj24, faj53, faj531, faj54, faj541, faj32, faj14, ",
               " faj141,faj142,faj1412, ",
               " faj232,faj242,faj322 ",
               "  FROM fby_file,OUTER faj_file",
               " WHERE fby01 = '",g_no,"'",
               "   AND fby03  = faj02",
               "   AND fby031 = faj022"
   PREPARE t114_p FROM l_sql
   DECLARE t114_c CURSOR WITH HOLD FOR t114_p
   FOREACH t114_c INTO l_fby.*,
                  l_faj23,l_faj24,l_faj53,l_faj531,l_faj54,l_faj541,l_faj32,l_faj14,l_faj141,     
                  l_faj142,l_faj1412,l_faj232,l_faj242,l_faj322                                                                                                          
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
      
      LET g_npq.npq04  = NULL     #FUN-D10065  add
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('fby01',g_no,'t114_c',SQLCA.sqlcode,0)
         ELSE
            CALL cl_err('t114_c',SQLCA.sqlcode,0)
         END IF
         EXIT FOREACH 
      END IF
      IF cl_null(l_faj32) THEN LET l_faj32 = 0 END IF
      IF cl_null(l_faj322) THEN LET l_faj322 = 0 END IF
         #-------資產科目(借)-------
         LET g_npq.npq02 = g_npq.npq02 + 1
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fby.fby05               
         ELSE
            LET g_npq.npq03 = l_fby.fby052              
         END IF
         LET g_npq.npq05 = ' '
        #LET g_npq.npq06 = '1'           #借貸別(1.借 2.貸)  #MOD-C70136 mark
         LET g_npq.npq06 = '2'           #借貸別(1.借 2.貸)  #MOD-C70136 add
         IF g_npq.npqtype = '0' THEN
             LET g_npq.npq07f= l_faj14
             LET g_npq.npq07 = l_faj14
         ELSE
             LET g_npq.npq07f= l_faj142
             LET g_npq.npq07 = l_faj142
         END IF

         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fby.fby02,'',g_bookno)
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
         IF p_npptype = '1' THEN
            SELECT aaa03 INTO l_aaa03 FROM aaa_file 
             WHERE aaa01 = g_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
             CALL s_newrate(g_bookno1,g_bookno2,g_npq.npq24,
                            g_npq25,g_npp.npp02)
             RETURNING g_npq.npq25
             IF cl_null(g_npq.npq25) OR g_npq.npq25 =0 THEN 
                LET g_npq.npq25 = 1
             END IF
             LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2) 
         ELSE
             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   
         END IF
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)    
            END IF
            LET g_success='N' CONTINUE FOREACH  
         END IF
         #-------累折科目(借)-------
         LET g_npq.npq02 = g_npq.npq02 + 1
         IF g_npq.npqtype = '0' THEN
             LET g_npq.npq03 = l_fby.fby06   
         ELSE
             LET g_npq.npq03 = l_fby.fby062  
         END IF
         LET g_npq.npq04 = NULL
         LET g_npq.npq05 = ' '

         LET g_npq.npq06 = '1'           #借貸別(1.借 2.貸) 
         IF g_npq.npqtype = '0' THEN     
             LET g_npq.npq07f= l_faj32       
             LET g_npq.npq07 = l_faj32
         ELSE
             LET g_npq.npq07f= l_faj322    
             LET g_npq.npq07 = l_faj322   
         END IF

         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fby.fby02,'',g_bookno)   
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
      IF p_npptype = '1' THEN
         SELECT aaa03 INTO l_aaa03 FROM aaa_file 
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03

          CALL s_newrate(g_bookno1,g_bookno2,g_npq.npq24,
                         g_npq25,g_npp.npp02)
          RETURNING g_npq.npq25
          IF cl_null(g_npq.npq25) OR g_npq.npq25 =0 THEN 
             LET g_npq.npq25 = 1
          END IF          
          LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2) 
      ELSE
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   
      END IF
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)    
            END IF
            LET g_success='N' CONTINUE FOREACH  
         END IF
         LET g_npq.npq02 = g_npq.npq02 + 1 
      #-------資產科目(貸)-------
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fby.fby09
         ELSE
            LET g_npq.npq03 = l_fby.fby092
         END IF
         LET g_npq.npq04 = NULL
        #LET g_npq.npq06 = '2'           #借貸別(1.借 2.貸) #MOD-C70136 mark
         LET g_npq.npq06 = '1'           #借貸別(1.借 2.貸) #MOD-C70136 add
         IF g_npq.npqtype = '0' THEN 
            LET g_npq.npq07f= l_faj14 #原幣金額 
            LET g_npq.npq07 = l_faj14 #本幣金額
         ELSE
            LET g_npq.npq07f= l_faj142
            LET g_npq.npq07 = l_faj142
         END IF    
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fby.fby02,'',g_bookno)
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
         IF p_npptype = '1' THEN
            SELECT aaa03 INTO l_aaa03 FROM aaa_file 
             WHERE aaa01 = g_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
             CALL s_newrate(g_bookno1,g_bookno2,g_npq.npq24,
                            g_npq25,g_npp.npp02)
             RETURNING g_npq.npq25
             IF cl_null(g_npq.npq25) OR g_npq.npq25 =0 THEN 
                LET g_npq.npq25 = 1
             END IF              
             LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)
         ELSE
             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  
         END IF
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)    
            END IF
            LET g_success='N' CONTINUE FOREACH
         END IF
         LET g_npq.npq02 = g_npq.npq02 + 1

         #-------累折科目(貸)-------
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fby.fby10
         ELSE
            LET g_npq.npq03 = l_fby.fby102
         END IF
         LET g_npq.npq04 = NULL
         LET g_npq.npq06 = '2'           #借貸別(1.借 2.貸) 
         IF g_npq.npqtype = '0' THEN  
            LET g_npq.npq07f= l_faj32       
            LET g_npq.npq07 = l_faj32
         ELSE
           LET g_npq.npq07f= l_faj322    
           LET g_npq.npq07 = l_faj322  
         END IF

         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fby.fby02,'',g_bookno)   
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 
         IF p_npptype = '1' THEN
            SELECT aaa03 INTO l_aaa03 FROM aaa_file 
             WHERE aaa01 = g_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
             CALL s_newrate(g_bookno1,g_bookno2,g_npq.npq24,
                            g_npq25,g_npp.npp02)
             RETURNING g_npq.npq25
             IF cl_null(g_npq.npq25) OR g_npq.npq25 =0 THEN 
                LET g_npq.npq25 = 1
             END IF              
             LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2) 
         ELSE
             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   
         END IF
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)    
            END IF
            LET g_success='N' CONTINUE FOREACH  
         END IF
   END FOREACH                                                                                                           
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
END FUNCTION

FUNCTION t114_gen_diff() #處理第二套帳由于匯率問題，會存在帳不平的可能   
DEFINE l_aaa            RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag =  '1' THEN  #抓不到帳別
         CALL cl_err(g_npp.npp02,'aoo-081',1)
         RETURN
      END IF
      LET g_bookno2 = g_faa.faa02c
      LET g_bookno = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp.npp00
            AND npq01 = g_npp.npp01
            AND npq011= g_npp.npp011
            AND npqsys= g_npp.nppsys
         LET l_npq1.npqtype = g_npp.npptype
         LET l_npq1.npq00 = g_npp.npp00
         LET l_npq1.npq01 = g_npp.npp01
         LET l_npq1.npq011= g_npp.npp011
         LET l_npq1.npqsys= g_npp.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno,l_npq1.npq03,g_prog,l_npq1.npq01,'','')
         RETURNING l_npq1.npq04
         #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg = l_npq1.npq01,"/",l_npq1.npq011,"/",l_npq1.npq02,"/",l_npq1. npqsys,"/",l_npq1.npq00
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq1.npq01,l_npq1.npq02,SQLCA.sqlcode,"","ins npq#1",1)
            END IF
               LET g_success='N'
         END IF
      END IF
   END IF   
END FUNCTION
#FUN-BC0035
