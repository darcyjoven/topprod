# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
DATABASE ds

GLOBALS "../../config/top.global"
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_no	        VARCHAR(10) 
   DEFINE g_date        DATE
   DEFINE l_azi04       LIKE azi_file.azi04
   DEFINE g_chr         VARCHAR(1)
   DEFINE g_msg         VARCHAR(72)

FUNCTION t110_gl(p_no,p_date)
   DEFINE p_no     VARCHAR(10)
   DEFINE p_date  	DATE 
   DEFINE l_buf	 VARCHAR(70)
   DEFINE l_n  		SMALLINT
   DEFINE l_t1          VARCHAR(03)
   DEFINE l_fahdmy3     LIKE fah_file.fahdmy3

   WHENEVER ERROR CONTINUE
   LET g_no = p_no LET g_date = p_date 
   IF cl_null(g_no) THEN RETURN END IF
   IF p_date < g_faa.faa09 THEN   #立帳日期小於關帳日期
         CALL cl_err(g_no,'aap-176',1) RETURN 
   END IF
   LET l_t1 = p_no[1,3]
   LET l_fahdmy3 = ' '
   SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
   IF SQLCA.sqlcode THEN CALL cl_err('sel fah:',STATUS,0) END IF
   #---->是否拋轉傳票
   IF l_fahdmy3 != 'Y' THEN  RETURN END IF
   SELECT COUNT(*) INTO l_n FROM npq_file WHERE npq01 = g_no 
                                            AND npqsys = 'FA'
                                            AND npq00 = 4
                                            AND npq011=1
   IF l_n > 0 THEN
      IF NOT s_ask_entry(g_no) THEN RETURN END IF #Genero
   END IF
   DELETE FROM npp_file WHERE npp01 = g_no
                          AND nppsys = 'FA'
                          AND npp00 = 4
                          AND npp011=1
   DELETE FROM npq_file WHERE npq01 = g_no
                          AND npqsys = 'FA'
                          AND npq00 = 4
                          AND npq011=1
   CALL s_t110()
   DELETE FROM npq_file WHERE npq01=g_no    AND npq03='-'
                          AND npqsys = 'FA' AND npq00 = 4
                          AND npq011=1
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
   
FUNCTION s_t110() 
DEFINE l_fbz10    LIKE fbz_file.fbz10,  
       l_fbz11    LIKE fbz_file.fbz11,  
       l_fbz12    LIKE fbz_file.fbz12,  
       l_gec03    LIKE gec_file.gec03,  
       l_fbe      RECORD LIKE fbe_file.*,
       l_fbf      RECORD LIKE fbf_file.*,
       l_fbe08    LIKE fbe_file.fbe08,
       l_fbe08x   LIKE fbe_file.fbe08x,
       l_fbe08t   LIKE fbe_file.fbe08t,
       l_fbe09    LIKE fbe_file.fbe09,
       l_fbe09x   LIKE fbe_file.fbe09x,
       l_fbe09t   LIKE fbe_file.fbe09t,
       l_faj17    LIKE faj_file.faj17,
       l_faj23    LIKE faj_file.faj23,
       l_faj24    LIKE faj_file.faj24,
       l_faj53    LIKE faj_file.faj53,
       l_faj54    LIKE faj_file.faj54,
       l_faj32    LIKE faj_file.faj32,
       l_faj58    LIKE faj_file.faj58,
       l_faj59    LIKE faj_file.faj59,
       l_faj14    LIKE faj_file.faj14,
       l_faj141   LIKE faj_file.faj141,
       l_aag05    LIKE aag_file.aag05,    #No:7833
       l_sql      VARCHAR(600)
#No:A099
DEFINE l_fab24    LIKE fab_file.fab24,
       l_fbz18    LIKE fbz_file.fbz18,
       m_faj32    LIKE faj_file.faj32,
       m_faj14    LIKE faj_file.faj14
#end No:A099

   #-------------(單頭)-----------------------------------
   LET g_npp.nppsys = 'FA'        LET g_npp.npp00 = 4 
   LET g_npp.npp01  = g_no        LET g_npp.npp011= 1
   LET g_npp.npp02  = g_date      LET g_npp.npp03  = g_date
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
      CALL cl_err('ins npp',STATUS,1) 
      LET g_success='N' #no.5573
   END IF

   #-------------(單身)-----------------------------------
   LET g_npq.npqsys = 'FA'        LET g_npq.npq00 = 4 
   LET g_npq.npq01 = g_no         LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0            LET g_npq.npq04 = NULL        
   LET g_npq.npq21 = NULL         LET g_npq.npq22 = NULL 
   LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1  
   #No:A099
   SELECT fbz10,fbz11,fbz12,fbz18 INTO l_fbz10,l_fbz11,l_fbz12,l_fbz18
       FROM fbz_file WHERE fbz00 = '0' 
   IF SQLCA.sqlcode THEN 
      LET l_fbz10 = ' ' LET l_fbz11 = ' '  LET l_fbz12 = ' ' LET l_fbz18 = ' '
   END IF
   #end No:A099
   SELECT * INTO l_fbe.* FROM fbe_file 
    WHERE fbe01 = g_no
      AND fbeconf !='X' #010801增
   SELECT gec03 INTO l_gec03 FROM gec_file 
    WHERE  gec01 = l_fbe.fbe07
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = l_fbe.fbe05
   #No:A099
   LET l_sql = "SELECT fbf_file.*,faj17,faj23,faj24,faj53,faj54,faj32, ",
               "       faj14,faj141,faj59,faj58,fab24 ",  
               "  FROM fbf_file,faj_file,OUTER fab_file",
               " WHERE fbf01 = '",g_no,"'",
               "   AND fbf03  = faj_file.faj02",
               "   AND fbf031 = faj_file.faj022",
               "   AND fab01  = faj04 "
   #end No:A099
   PREPARE t110_p FROM l_sql
   DECLARE t110_c CURSOR WITH HOLD FOR t110_p
   FOREACH t110_c INTO l_fbf.*,l_faj17,l_faj23,l_faj24,l_faj53,l_faj54,l_faj32,
                       l_faj14,l_faj141,l_faj59,l_faj58,l_fab24   #No:A099
      IF SQLCA.sqlcode THEN
         CALL cl_err('t110_c',SQLCA.sqlcode,0)
         EXIT FOREACH 
      END IF
      IF cl_null(l_faj32) THEN LET l_faj32 = 0 END IF

      #No:A099
      #-------Dr.: 固定資產清理科目(fbz18) -------------                        
      IF g_faa.faa29 = 'Y' AND g_aza.aza26='2' THEN      #轉入清理科目                              
         LET g_npq.npq02 = g_npq.npq02 + 1                                      
         LET g_npq.npq03 = l_fbz18            #借:固定資產清理                  
         #-->單一部門分攤才給部門                                               
         IF l_faj23 = '1' THEN                                                  
            SELECT aag05 INTO l_aag05 FROM aag_file                             
             WHERE aag01=g_npq.npq03                                            
            IF l_aag05='Y' THEN                                                 
               LET g_npq.npq05 =l_faj24                                         
            ELSE                                                                
               LET g_npq.npq05 = ' '                                            
            END IF                                                              
         ELSE LET g_npq.npq05 = NULL                                            
         END IF                                                                 
         LET g_npq.npq06 = '1'                                                  
         #成本                                                                  
         LET m_faj14= (l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)*l_fbf.fbf04  
         #累折                                                                  
         LET m_faj32= (l_faj32/l_faj17)*l_fbf.fbf04                             
         LET g_npq.npq07f= m_faj14 - (m_faj32 + l_fbf.fbf11)                    
         LET g_npq.npq07 = m_faj14 - (m_faj32 + l_fbf.fbf11)         
         CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f            
         CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07              
         LET g_npq.npq23 = ' '                                                  
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03                                
         INSERT INTO npq_file VALUES (g_npq.*)                                  
         IF STATUS THEN                                                         
            CALL cl_err('ins npq#10',STATUS,1)                                  
            LET g_success='N' EXIT FOREACH                                      
         END IF                                                                 
      END IF                                                                    
      #end No:A099
      #-------Dr.: 累折科目 (faj54) -----------
      #-->單一部門分攤才給部門
      IF l_faj23 = '1' THEN   # 分攤方式1.單一部門分攤2.多部門分攤
         #No:7833
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01=g_npq.npq03
         IF l_aag05='Y' THEN
            LET g_npq.npq05 =l_faj24
         ELSE
            LET g_npq.npq05 = ' '
         END IF
         ##
         LET g_npq.npq06 = '1'
         LET g_npq.npq03 = l_faj54   #累折科目
#        LET g_npq.npq07f= l_faj32   #累積折舊(dec)
#        LET g_npq.npq07 = l_faj32   #累積折舊
         LET g_npq.npq07f= (l_faj32/l_faj17)*l_fbf.fbf04   #累積折舊(dec)
         LET g_npq.npq07 = (l_faj32/l_faj17)*l_fbf.fbf04   #累積折舊
         CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f
         CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
    #    UPDATE npq_file SET npq07f = npq07f + g_npq.npq07f,
    #                     npq07  = npq07  + g_npq.npq07 
    #     WHERE npqsys = g_npq.npqsys
    #       AND npq00 = g_npq.npq00
    #       AND npq01 = g_npq.npq01
    #       AND npq011 = g_npq.npq011
    #       AND npq03 = g_npq.npq03   #科目 
    #    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
            LET g_npq.npq02 = g_npq.npq02 + 1
            INSERT INTO npq_file VALUES (g_npq.*)
            IF STATUS THEN 
               CALL cl_err('ins npq#1',STATUS,1) 
               LET g_success='N' EXIT FOREACH #no.5573
            END IF
    #    END IF 
      ELSE 
         DECLARE fan_cur CURSOR FOR SELECT fan06,SUM(fan07) FROM fan_file
           WHERE fan01=l_fbf.fbf03
             AND fan02=l_fbf.fbf031
             AND fan041 = '1'
             AND fan05='3'   #被分攤
           GROUP BY fan06
           ORDER BY fan06
          FOREACH fan_cur INTO g_npq.npq05,g_npq.npq07f
             LET g_npq.npq06 = '1'
             LET g_npq.npq03 = l_faj54   #累折科目
             LET g_npq.npq07f= g_npq.npq07f/l_faj17*l_fbf.fbf04  #累積折舊(dec)
             LET g_npq.npq07 = g_npq.npq07f                    #累積折舊
             CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f
             CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07
             LET g_npq.npq23 = ' ' 
             MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
             LET g_npq.npq02 = g_npq.npq02 + 1
             INSERT INTO npq_file VALUES (g_npq.*)
             IF STATUS THEN 
                CALL cl_err('ins npq#1',STATUS,1) 
                LET g_success='N' EXIT FOREACH #no.5573
             END IF
          END FOREACH
      END IF
      IF cl_null(l_fbf.fbf07) THEN LET l_fbf.fbf07=0 END IF
      #No:A099
      #-------Dr.: 資產之減值準備科目(fab24) -------------                      
      IF l_fbf.fbf11 > 0 THEN     #已提列減值準備                               
         LET g_npq.npq02 = g_npq.npq02 + 1                                      
         LET g_npq.npq03 = l_fab24             #借:減值準備                     
         #-->單一部門分攤才給部門                                               
         IF l_faj23 = '1' THEN                                                  
            SELECT aag05 INTO l_aag05 FROM aag_file                             
             WHERE aag01=g_npq.npq03                                            
            IF l_aag05='Y' THEN                                                 
               LET g_npq.npq05 =l_faj24                                         
            ELSE                                                                
               LET g_npq.npq05 = ' '                                            
            END IF                                                              
         ELSE LET g_npq.npq05 = NULL                                            
         END IF                                                                 
         LET g_npq.npq06 = '1'                                                  
         LET g_npq.npq07f= l_fbf.fbf11                                          
         LET g_npq.npq07 = l_fbf.fbf11                                          
         LET g_npq.npq23 = ' '                                                  
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03                                
         INSERT INTO npq_file VALUES (g_npq.*)     
         IF STATUS THEN                                                         
            CALL cl_err('ins npq#12',STATUS,1)                                  
            LET g_success='N' EXIT FOREACH                                      
         END IF                                                                 
      END IF                                                                    
      #end No:A099
      IF g_faa.faa29 = 'N' THEN       #No:A099
         #-------Dr.: A/R 科目 (fbz10) -----------
         #-->單一部門分攤才給部門
         IF l_faj23 = '1' THEN 
            #No:7833
            LET g_npq.npq03 = l_fbz10       #出售應收科目
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
            IF l_aag05='Y' THEN
               LET g_npq.npq05 =l_faj24
            ELSE
               LET g_npq.npq05 = ' '
            END IF
            ##
         ELSE LET g_npq.npq05 = NULL           
         END IF
         LET g_npq.npq06 = '1'
         LET g_npq.npq03 = l_fbz10       #出售應收科目 
        ##1999/12/31小心千禧蟲發作
        #LET g_npq.npq07f= l_fbe.fbe08t  #本幣出售金額
        #LET g_npq.npq07 = l_fbe.fbe09t
         IF l_fbe.fbe073='N' THEN  #不含稅
            LET l_fbe08x=l_fbf.fbf06*l_fbe.fbe071/100
            CALL cl_digcut(l_fbe08x,l_azi04) RETURNING l_fbe08x
            LET l_fbe08t=l_fbf.fbf06+l_fbe08x
            LET l_fbe09x=l_fbf.fbf07*l_fbe.fbe071/100
            CALL cl_digcut(l_fbe09x,g_azi04) RETURNING l_fbe09x
            LET l_fbe09t=l_fbf.fbf07+l_fbe09x
            CALL cl_digcut(l_fbe08t,l_azi04) RETURNING l_fbe08t
            CALL cl_digcut(l_fbe09t,g_azi04) RETURNING l_fbe09t
         ELSE   # 含稅
            LET l_fbe08t=l_fbf.fbf06
            LET l_fbe09t=l_fbf.fbf07
            IF l_fbe.fbe071 = 0 THEN   #零稅率,應設不含稅 
               LET l_fbe08x=l_fbf.fbf06*l_fbe.fbe071/100
               CALL cl_digcut(l_fbe08x,l_azi04) RETURNING l_fbe08x
              #LET l_fbe08t=l_fbf.fbf06+l_fbe08x
               LET l_fbe09x=l_fbf.fbf07*l_fbe.fbe071/100
               CALL cl_digcut(l_fbe09x,g_azi04) RETURNING l_fbe09x
              #LET l_fbe09t=l_fbf.fbf07+l_fbe09x
               CALL cl_digcut(l_fbe08t,l_azi04) RETURNING l_fbe08t
               CALL cl_digcut(l_fbe09t,g_azi04) RETURNING l_fbe09t
            ELSE  
               LET l_fbe08x=l_fbf.fbf06 * (1-(100+l_fbe.fbe071)/100) 
               CALL cl_digcut(l_fbe08x,l_azi04) RETURNING l_fbe08x
               LET l_fbe09x=l_fbf.fbf07 * (1-(100+l_fbe.fbe071)/100)
               CALL cl_digcut(l_fbe09x,g_azi04) RETURNING l_fbe09x
               CALL cl_digcut(l_fbe08t,l_azi04) RETURNING l_fbe08t
               CALL cl_digcut(l_fbe09t,g_azi04) RETURNING l_fbe09t
            END IF 
         END IF
         LET g_npq.npq07f= l_fbe08t  #本幣出售金額
         LET g_npq.npq07 = l_fbe09t
         LET g_npq.npq23 = ' '
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
       # UPDATE npq_file SET npq07f = g_npq.npq07f,
       #                     npq07  = g_npq.npq07 
       #  WHERE npqsys = g_npq.npqsys
       #    AND npq00 = g_npq.npq00
       #    AND npq01 = g_npq.npq01
       #    AND npq011 = g_npq.npq011
       #    AND npq03 = g_npq.npq03   #科目 
        #IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
            LET g_npq.npq02 = g_npq.npq02 + 1
            INSERT INTO npq_file VALUES (g_npq.*)
            IF STATUS THEN 
               CALL cl_err('ins npq#2',STATUS,1)
               LET g_success='N' EXIT FOREACH #no.5573
            END IF
        #END IF 
         #----- 損失 (fbz12)------------
   #     IF (l_faj14+l_faj141-l_faj59) > (l_faj32+l_fbf.fbf07) THEN 
         IF l_fbf.fbf09<0 THEN
            #No:7833
            IF l_faj23 = '1' THEN
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE
               LET g_npq.npq05 = NULL
            END IF
            ##
            LET g_npq.npq06 = '1'
            LET g_npq.npq03 = l_fbz12    
            LET g_npq.npq07f=  l_fbf.fbf09 * (-1)
            LET g_npq.npq07 =  l_fbf.fbf09 * (-1) 
   #        LET g_npq.npq07f=  (l_faj14+l_faj141-l_faj59) - (l_faj32+l_fbf.fbf07) 
   #        LET g_npq.npq07 =  (l_faj14+l_faj141-l_faj59) - (l_faj32+l_fbf.fbf07) 
            LET g_npq.npq23 = ' ' 
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
          # UPDATE npq_file SET npq07f =  g_npq.npq07f,
          #                     npq07  =  g_npq.npq07 
          #  WHERE npqsys = g_npq.npqsys
          #    AND npq00 = g_npq.npq00
          #    AND npq01 = g_npq.npq01
          #    AND npq011 = g_npq.npq011
          #    AND npq03 = g_npq.npq03   #科目 
          # IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
               LET g_npq.npq02 = g_npq.npq02 + 1
               INSERT INTO npq_file VALUES (g_npq.*)
               IF STATUS THEN 
                  CALL cl_err('ins npq#3',STATUS,1) 
                  LET g_success='N' EXIT FOREACH #no.5573
               END IF
           #END IF 
         END IF
      END IF       #end No:A099
      #-------Dr.: 資產之資產科目(faj53) -------
      LET g_npq.npq06 = '2'
      LET g_npq.npq03 = l_faj53
      #No:7833
      IF l_faj23 = '1' THEN
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01=g_npq.npq03
         IF l_aag05='Y' THEN
            LET g_npq.npq05 =l_faj24
         ELSE
            LET g_npq.npq05 = ' '
         END IF
      ELSE
         LET g_npq.npq05 = NULL
      END IF
      ##
      LET g_npq.npq07f= (l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)*l_fbf.fbf04
      LET g_npq.npq07 = (l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)*l_fbf.fbf04
      LET g_npq.npq23 = ' '
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
    # UPDATE npq_file SET npq07f = g_npq.npq07f,
    #                     npq07  = g_npq.npq07 
    #  WHERE npqsys = g_npq.npqsys
    #    AND npq00 = g_npq.npq00
    #    AND npq01 = g_npq.npq01
    #    AND npq011 = g_npq.npq011
    #    AND npq03 = g_npq.npq03   #科目 
    # IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
         LET g_npq.npq02 = g_npq.npq02 + 1
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            CALL cl_err('ins npq#4',STATUS,1)
            LET g_success='N' EXIT FOREACH #no.5573
         END IF
    # END IF 
      IF g_faa.faa29 = 'N' THEN       #No:A099
         ##No.3043 1999/03/19 modify
         #----- DR.:稅額 (fbe08x,fbe09x)----
         IF l_fbe08x > 0 OR l_fbe09x > 0 THEN
            LET g_npq.npq06 = '2'
            LET g_npq.npq03 = l_gec03    
            #No:7833
            IF l_faj23 = '1' THEN
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE
               LET g_npq.npq05 = NULL
            END IF
            ##
            LET g_npq.npq07f=  l_fbe08x
            LET g_npq.npq07 =  l_fbe09x
            LET g_npq.npq23 = ' ' 
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            LET g_npq.npq02 = g_npq.npq02 + 1
            INSERT INTO npq_file VALUES (g_npq.*)
            IF STATUS THEN 
               CALL cl_err('ins npq#5',STATUS,1) 
               LET g_success='N' EXIT FOREACH #no.5573
            END IF
         END IF
         ##---------------------------------
         #----- DR.:收益 (fbz11)------------
         IF l_fbf.fbf09>0 THEN
            LET g_npq.npq06 = '2'
            LET g_npq.npq03 = l_fbz11    
            #No:7833
            IF l_faj23 = '1' THEN
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE
               LET g_npq.npq05 = NULL
            END IF
            ##
            LET g_npq.npq07f=  l_fbf.fbf09 
            LET g_npq.npq07 =  l_fbf.fbf09
            LET g_npq.npq23 = ' ' 
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            LET g_npq.npq02 = g_npq.npq02 + 1
            INSERT INTO npq_file VALUES (g_npq.*)
            IF STATUS THEN 
               CALL cl_err('ins npq#5',STATUS,1) 
               LET g_success='N' EXIT FOREACH #no.5573
            END IF
         END IF
      END IF      #end No:A099
   END FOREACH
END FUNCTION
