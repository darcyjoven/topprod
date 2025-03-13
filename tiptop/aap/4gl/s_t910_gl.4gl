# Prog. Version..: '5.30.07-13.05.31(00003)'     #
#
# Pattern name...: s_t910_gl.4gl
# Descriptions...: 費用分攤作業分錄
# Date & Author..: NO.FUN-C70093 12/07/24 BY minpp
# Modify.........: No.FUN-D10065 13/01/15 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_chr           LIKE type_file.chr1    
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_sql           STRING                 
DEFINE g_bookno1         LIKE aza_file.aza81                                                                      
DEFINE g_bookno2         LIKE aza_file.aza82                                                                        
DEFINE g_bookno3         LIKE aza_file.aza82   
DEFINE   g_flag          LIKE type_file.chr1    
DEFINE   g_npq25         LIKE npq_file.npq25    
DEFINE   g_azi04_2       LIKE azi_file.azi04    
DEFINE   g_t1            LIKE apy_file.apyslip

FUNCTION t910_g_gl(p_apno,p_npptype) 
   DEFINE p_apno	LIKE aqa_file.aqa01
   DEFINE p_npptype     LIKE npp_file.npptype  
   DEFINE l_buf		LIKE type_file.chr1000 
   DEFINE l_n  		LIKE type_file.num5    
 
   WHENEVER ERROR CALL cl_err_msg_log
   #No:8009 add 若已拋轉總帳, 不可重新產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = p_apno AND nppglno != '' AND nppglno IS NOT NULL
      AND nppsys = 'AP'  AND npp00 = 4     AND npp011 = 1
      AND npptype = p_npptype 
   IF l_n > 0 THEN
      CALL cl_err(p_apno,'aap-122',1) RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM npp_file WHERE nppsys = 'AP' AND npp00 = 4 
                                            AND npp01  = p_apno
                                            AND npp011 = 1 
                                            AND npptype = p_npptype  
   IF l_n > 0 AND p_npptype = '0' THEN
      IF NOT s_ask_entry(p_apno) THEN RETURN END IF #Genero
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM tic_file
       WHERE tic04 = p_apno
      IF l_n > 0 THEN
         IF NOT cl_confirm('sub-533') THEN
            RETURN
         ELSE
            DELETE FROM tic_file WHERE tic04 = p_apno
         END IF
      END IF
      DELETE FROM npp_file WHERE nppsys = 'AP' AND npp00 = 4
                             AND npp01  = p_apno
                             AND npp011 = 1 
      DELETE FROM npq_file WHERE npqsys = 'AP' AND npq00 = 4 
                             AND npq01  = p_apno
                             AND npq011 = 1 
   END IF
   CALL t910_g_gl_1(p_apno,p_npptype) 
END FUNCTION
 
FUNCTION t910_g_gl_1(p_apno,p_npptype) 
   DEFINE p_apno	LIKE aqa_file.aqa01
   DEFINE p_npptype     LIKE npp_file.npptype  
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag21       LIKE aag_file.aag21
   DEFINE l_aag23       LIKE aag_file.aag23
   DEFINE l_aqb04       LIKE aqb_file.aqb04
   DEFINE l_apa51       LIKE apa_file.apa51
   DEFINE l_aqb04_2     LIKE aqb_file.aqb04
   DEFINE l_apa51_2     LIKE apa_file.apa51
   DEFINE l_aqb02_2     LIKE aqb_file.aqb02
   DEFINE l_apa06_2     LIKE apa_file.apa06
   DEFINE l_apa07_2     LIKE apa_file.apa07
   DEFINE l_apa22_2     LIKE apa_file.apa22
   DEFINE l_apa06       LIKE apa_file.apa06
   DEFINE l_apa07       LIKE apa_file.apa07
   DEFINE l_apa22       LIKE apa_file.apa22
   DEFINE l_apa66       LIKE apa_file.apa66   
   DEFINE l_apa67       LIKE apa_file.apa67   
   DEFINE l_apa68       LIKE apa_file.apa68   
   DEFINE l_apa69       LIKE apa_file.apa69   
   DEFINE l_apa70       LIKE apa_file.apa70         
   DEFINE l_sum_api05   LIKE api_file.api05
   DEFINE l_amt_api05   LIKE api_file.api05       #計算攤算後的金額
   DEFINE l_sum_api05_2 LIKE api_file.api05
   DEFINE l_amt_api05_2 LIKE api_file.api05       #計算攤算後的金額
   DEFINE l_sum_apb10_2 LIKE apb_file.apb10
   DEFINE l_amt_apb10_2 LIKE apb_file.apb10       #計算攤算後的金額
   DEFINE l_aqa		RECORD LIKE aqa_file.*
   DEFINE l_apb_2       RECORD LIKE apb_file.*
   DEFINE l_aqc		RECORD LIKE aqc_file.*
   DEFINE l_api		RECORD LIKE api_file.*
   DEFINE l_api_2       RECORD LIKE api_file.*
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_dept	LIKE type_file.chr6        
   DEFINE l_actno,l_actno2 LIKE ima_file.ima39               
   DEFINE l_amt		LIKE aqa_file.aqa04
   DEFINE l_amtf        LIKE aqa_file.aqa04
   DEFINE l_sql         STRING                 
   DEFINE l_opendate,l_duedate	LIKE type_file.dat     
   DEFINE l_aaa03       LIKE aaa_file.aaa03   
   DEFINE l_apb26       LIKE apb_file.apb26    
   DEFINE l_apa930      LIKE apa_file.apa930   
   DEFINE l_apb930      LIKE apb_file.apb930   
   DEFINE l_apb21       LIKE apb_file.apb21   
   DEFINE l_apb22       LIKE apb_file.apb22    
   DEFINE l_ware        LIKE ime_file.ime01    
   DEFINE l_loc         LIKE ime_file.ime02    
   DEFINE l_i,l_n       LIKE type_file.num5
   DEFINE l_apa00       LIKE apa_file.apa00
   DEFINE l_apydmy6     LIKE apy_file.apydmy6
   DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add
 
   SELECT * INTO l_aqa.* FROM aqa_file WHERE aqa01 = p_apno
   IF STATUS THEN RETURN END IF
                                                                                                        
   CALL s_get_bookno(YEAR(l_aqa.aqa02)) RETURNING g_flag,g_bookno1,g_bookno2                                                        
   IF g_flag =  '1' THEN  #抓不到帳別                                                                                               
      CALL cl_err(l_aqa.aqa02,'aoo-081',1)                                                                                          
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
   IF p_npptype = '0' THEN                                                                                                          
      LET g_bookno3 = g_bookno1                                                                                                     
   ELSE                                                                                                                             
      LET g_bookno3 = g_bookno2                                                                                                     
   END IF                                                                                                                           
 
   LET l_npp.npptype = p_npptype  
   LET l_npq.npqtype = p_npptype  
 
   #-->分錄單頭
   LET l_npp.nppsys = 'AP'
   LET l_npp.npp00  = 4 
   LET l_npp.npp01  = l_aqa.aqa01 
   LET l_npp.npp011 = 1 
   LET l_npp.npp02  = l_aqa.aqa02
   LET l_npp.npp03  = NULL
   LET l_npp.npp05  = NULL
   LET l_npp.nppglno= NULL
   LET l_npp.npplegal= g_legal 
   INSERT INTO npp_file VALUES (l_npp.*)
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,SQLCA.sqlcode,"","insert npp_file",1)  
      LET g_success = 'N' 
   END IF
  #单身
    LET l_npq.npqsys = 'AP'
    LET l_npq.npq00  = 4  
    LET l_npq.npq01  = l_aqa.aqa01 
    LET l_npq.npq011 = 1 
    LET l_npq.npq21 = ' '
    LET l_npq.npq22 = ' '

    LET l_npq.npq02=1
  #单身借方 
   IF p_npptype = '0' THEN 
      LET g_sql=" SELECT SUM(aqc06),aqc11,SUM(aqc08),aqc10 FROM aqc_file", 
                " WHERE aqc01 = '",l_aqa.aqa01,"' ",
                " GROUP BY aqc11,aqc10 "
   ELSE
       LET g_sql=" SELECT SUM(aqc08-aqc06),aqc111,aqc08,aqc10 FROM aqc_file", 
                " WHERE aqc01 = '",l_aqa.aqa01,"' ",
                " GROUP BY aqc111,aqc10"   
   END IF 
   PREPARE a_pre FROM g_sql 
   DECLARE a_curs CURSOR FOR a_pre
   FOREACH a_curs INTO l_aqc.aqc06,l_aqc.aqc11,l_aqc.aqc08,l_aqc.aqc10,l_aqc.aqc02
      IF SQLCA.sqlcode THEN
         CALL cl_err('a_curs:',SQLCA.sqlcode,1)    
         LET g_success='N' 
         EXIT FOREACH
      END IF
       LET g_t1=s_get_doc_no(l_aqa.aqa01)
       SELECT apydmy6 INTO l_apydmy6 FROM apy_file WHERE apyslip=g_t1  #紅沖 

      LET l_npq.npq03 = l_aqc.aqc11
          LET l_npq.npq06 = '1'    #借
          LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
          LET l_npq.npq25 = 1  #匯率
          LET l_npq.npqlegal = g_legal 
          LET g_npq25  = l_npq.npq25  
          LET l_npq.npq04 = NULL          #FUN-D10065  add
          IF l_aqc.aqc10='1' OR l_aqc.aqc10='2' THEN 
             LET l_npq.npq07f=l_aqc.aqc08-l_aqc.aqc06
             LET l_npq.npq07 =l_aqc.aqc08-l_aqc.aqc06
          ELSE
             LET l_npq.npq07f = l_aqc.aqc08
             LET l_npq.npq07 = l_aqc.aqc08
          END IF    
          
          IF cl_null(l_npq.npq07) THEN 
             LET l_npq.npq07=0
          END IF
          IF cl_null(l_npq.npq07f) THEN 
             LET l_npq.npq07f=0
          END IF
          IF l_aqc.aqc10='3' AND l_aqa.aqa03<0  THEN
             LET l_npq.npq07f =l_npq.npq07f *-1
             LET l_npq.npq07  =l_npq.npq07*-1
          END IF  
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  
          RETURNING l_npq.*
          CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq34,l_npq.npq34    
          IF l_npq.npq07<>0 THEN 
             IF p_npptype = '1' THEN
                SELECT aaa03 INTO l_aaa03 FROM aaa_file
                 WHERE aaa01 = g_bookno2
                SELECT azi04 INTO g_azi04_2 FROM azi_file
                 WHERE azi01 = l_aaa03
                CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                               g_npq25,l_npp.npp02)
                 RETURNING l_npq.npq25
                 LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
              ELSE
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  
              END IF
             
              SELECT apa00 INTO l_apa00 FROM apa_file,aqb_file WHERE apa01=aqb02 AND aqb01=l_aqa.aqa01
              IF l_apa00 MATCHES '2*' THEN 
                 IF l_apydmy6='N' THEN
                   #LET l_npq.npq07f= l_npq.npq07f* -1
                   #LET l_npq.npq07 = l_npq.npq07 * -1         
                 #ELSE 
                    LET l_npq.npq06 = '2'
                    LET l_npq.npq07f= l_npq.npq07f* -1
                    LET l_npq.npq07 = l_npq.npq07 * -1  
                 END IF
              END IF
             #FUN-D40118 ---Add--- Start
              SELECT aag44 INTO l_aag44 FROM aag_file
               WHERE aag00 = g_bookno3
                 AND aag01 = l_npq.npq03
              IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                 CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                 IF l_flag = 'N'   THEN
                    LET l_npq.npq03 = ''
                 END IF
              END IF
             #FUN-D40118 ---Add--- End
              INSERT INTO npq_file VALUES (l_npq.*)
              MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                          l_npq.npq06,' ',l_npq.npq07
             IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","a_curs ins:",1)  
               LET g_success='N'
            END IF
        END IF 
        LET l_npq.npq02 =  l_npq.npq02 +1   
  END FOREACH
  
  #貸方 : 費用或預付
   IF p_npptype = '0' THEN
      LET g_sql = " SELECT aqb02,apa00,apa06,apa07,aqb04,apa51,apa22,",
                  "        apa66,apa67,apa68,apa69,apa70,apa930 ",     
                  "   FROM aqb_file,apa_file ",
                  "  WHERE aqb01 = '",l_aqa.aqa01,"'",
                  "    AND aqb02 = apa01 ",
                  "  ORDER BY aqb02 "
   ELSE
      LET g_sql = " SELECT aqb02,apa00,apa06,apa07,aqb04,apa511,apa22,",
                  "        apa66,apa67,apa68,apa69,apa70,apa930 ",     
                  "   FROM aqb_file,apa_file ",
                  "  WHERE aqb01 = '",l_aqa.aqa01,"'",
                  "    AND aqb02 = apa01 ",
                  "  ORDER BY aqb02 "
   END IF
   PREPARE t910_gl_p2 FROM g_sql
   DECLARE t910_gl_c2 CURSOR FOR t910_gl_p2
   FOREACH t910_gl_c2 INTO l_aqb02_2,l_apa00,l_apa06_2,l_apa07_2,l_aqb04_2,
                           l_apa51_2,l_apa22_2,l_apa66,l_apa67,l_apa68,
                           l_apa69,l_apa70,l_apa930
      LET g_t1=s_get_doc_no(l_aqa.aqa01)
      SELECT apydmy6 INTO l_apydmy6 FROM apy_file WHERE apyslip=g_t1  #紅沖 
   #---->單一借方                        
      IF NOT cl_null(l_apa51_2) AND l_apa51_2 != 'UNAP' AND
         l_apa51_2 != 'MISC' AND l_apa51_2 != 'STOCK' THEN
          LET l_npq.npq03 = l_apa51_2
          LET l_npq.npq04 = ' '
          SELECT aag05 INTO l_aag05 FROM aag_file
           WHERE aag01=l_npq.npq03
             AND aag00 = g_bookno3   
          IF l_aag05='Y' THEN
             IF g_aaz.aaz90='N' THEN            
                LET l_npq.npq05 = l_apa22_2
             ELSE                               
                LET l_npq.npq05 = l_apa930      
             END IF                            
          ELSE
             LET l_npq.npq05 = ' '     
          END IF
          LET l_npq.npq06 = '2'    
          LET l_npq.npq21 = l_apa06_2
          LET l_npq.npq22 = l_apa07_2
          LET l_npq.npq23 = l_aqb02_2
          LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
          LET l_npq.npq25 = 1                        #匯率
          LET l_npq.npqlegal = g_legal
          LET g_npq25  = l_npq.npq25                 
          LET l_npq.npq07f= l_aqb04_2
          LET l_npq.npq07 = l_aqb04_2
          IF cl_null(l_npq.npq07) THEN 
             LET l_npq.npq07=0
          END IF
          IF cl_null(l_npq.npq07f) THEN 
             LET l_npq.npq07f=0
          END IF
          
          IF l_npq.npq07<>0 THEN 
             CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  
             RETURNING l_npq.*
             CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    
             IF p_npptype = '1' THEN
                SELECT aaa03 INTO l_aaa03 FROM aaa_file
                 WHERE aaa01 = g_bookno2
                SELECT azi04 INTO g_azi04_2 FROM azi_file
                 WHERE azi01 = l_aaa03

                CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                               g_npq25,l_npp.npp02)
                RETURNING l_npq.npq25
                LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
             ELSE
                LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  
             END IF
             
             IF l_apa00 MATCHES '2*' THEN
                IF l_apydmy6='Y' THEN
                   LET l_npq.npq07f= l_npq.npq07f* -1
                   LET l_npq.npq07 = l_npq.npq07 * -1
                ELSE
                   LET l_npq.npq06 = '1'
                END IF  
             END IF
            #FUN-D40118 ---Add--- Start
             SELECT aag44 INTO l_aag44 FROM aag_file
              WHERE aag00 = g_bookno3
                AND aag01 = l_npq.npq03
             IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                IF l_flag = 'N'   THEN
                   LET l_npq.npq03 = ''
                END IF
             END IF
            #FUN-D40118 ---Add--- End
             INSERT INTO npq_file VALUES (l_npq.*)
             MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                         l_npq.npq06,' ',l_npq.npq07
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","gl_c2 ins:",1)  
               LET g_success='N'
            END IF
         END IF    
     END IF
     #---->貸方科目為空
     IF cl_null(l_apa51_2) THEN
        CALL t910_gl_ins_npq(p_apno,l_aqb02_2,g_aza.aza17,1,l_npq.npq02,l_aqb04_2,l_apa06_2,l_apa07_2,l_apa22_2,p_npptype)
             RETURNING l_npq.npq02
        CONTINUE FOREACH
     END IF
     #--->MISC/UNAP
     IF l_apa51_2 = 'MISC' OR l_apa51_2 = 'UNAP' THEN
        #--計算總合
        IF p_npptype = '0' THEN 
           SELECT SUM(api05) INTO l_sum_api05_2 FROM api_file
            WHERE api01=l_aqb02_2   
              AND (api04 IS NOT NULL AND api04 <> ' ')
        ELSE
           SELECT SUM(api05) INTO l_sum_api05_2 FROM api_file
            WHERE api01=l_aqb02_2   
              AND (api041 IS NOT NULL AND api041 <> ' ')
        END IF
        IF cl_null(l_sum_api05_2) THEN LET l_sum_api05_2=0 END IF
        LET l_amt_api05_2 = 0
        #--計算每筆  
        IF p_npptype = '0' THEN
           LET g_sql = " SELECT * FROM api_file ",
                       "  WHERE api01 = '",l_aqb02_2,"'",
                       "    AND (api04 IS NOT NULL AND api04 <> ' ')"
        ELSE
           LET g_sql = " SELECT * FROM api_file ",
                       "  WHERE api01 = '",l_aqb02_2,"'",
                       "    AND (api041 IS NOT NULL AND api041 <> ' ')"
        END IF
        PREPARE b_pre_2 FROM g_sql
        DECLARE b_curs_2 CURSOR FOR b_pre_2
        FOREACH b_curs_2 INTO l_api_2.*
           IF STATUS THEN 
              CALL cl_err('b_curs_2:',SQLCA.sqlcode,1)    
              LET g_success='N' 
              EXIT FOREACH
           END IF
           IF p_npptype = '0' THEN 
              LET l_npq.npq03 = l_api_2.api04
           ELSE
              LET l_npq.npq03 = l_api_2.api041
           END IF
           LET l_npq.npq04 = NULL             #FUN-D10065  add
           #LET l_npq.npq04 = l_api_2.api06   #FUN-D10065  mark
           LET l_npq.npq06 = '2'
           SELECT apa06,apa07 INTO l_apa06_2,l_apa07_2 FROM apa_file
            WHERE apa01=l_aqb02_2
           LET l_npq.npq21 = l_apa06_2
           LET l_npq.npq22 = l_apa07_2
           LET l_npq.npq23 = l_aqb02_2
           LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
           LET l_npq.npq25 = 1                        #匯率
           LET l_npq.npqlegal = g_legal
           LET g_npq25  = l_npq.npq25                
           IF l_sum_api05_2!=0 THEN
              LET l_npq.npq07 = l_aqb04_2*l_api_2.api05/l_sum_api05_2
              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
           ELSE
              LET l_npq.npq07 = 0
           END IF
           LET l_npq.npq07f=l_npq.npq07      
           IF cl_null(l_npq.npq07) THEN 
              LET l_npq.npq07=0
           END IF
           IF cl_null(l_npq.npq07f) THEN 
              LET l_npq.npq07f=0
           END IF
           LET l_amt_api05_2 = l_amt_api05_2 + l_npq.npq07
           SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23 FROM aag_file
            WHERE aag01=l_npq.npq03
              AND aag00 = g_bookno3   
           IF l_aag23 = 'Y' THEN
              LET l_npq.npq08 = l_api_2.api26    # 專案
           ELSE
              LET l_npq.npq08 = null
           END IF
        
           IF l_aag05='Y' THEN
              IF g_aaz.aaz90='N' THEN            
                 LET l_npq.npq05 = l_api_2.api07
              ELSE                             
                 LET l_npq.npq05 = l_api_2.api930 
              END IF                  
           ELSE
              LET l_npq.npq05 = ''           
           END IF
           LET l_npq.npq11=l_api_2.api21
           LET l_npq.npq12=l_api_2.api22
           LET l_npq.npq13=l_api_2.api23
           LET l_npq.npq14=l_api_2.api24
           ##
           IF l_npq.npq07!=0 THEN 
              CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  
              RETURNING l_npq.*
              #FUN-D10065--add--str--
              IF cl_null(l_npq.npq04) THEN
                 LET l_npq.npq04 = l_api_2.api06
              END IF
              #FUN-D10065--add--end--
              CALL s_def_npq31_npq34(l_npq.*,g_bookno3)  RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34     

              IF p_npptype = '1' THEN
                 SELECT aaa03 INTO l_aaa03 FROM aaa_file
                  WHERE aaa01 = g_bookno2
                 SELECT azi04 INTO g_azi04_2 FROM azi_file
                  WHERE azi01 = l_aaa03
                 CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                                g_npq25,l_npp.npp02)
                 RETURNING l_npq.npq25
                 LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
              ELSE
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  
              END IF
              IF l_apa00 MATCHES '2*' THEN
                 IF l_apydmy6='Y' THEN
                   LET l_npq.npq07f= l_npq.npq07f* -1
                   LET l_npq.npq07 = l_npq.npq07 * -1
                ELSE
                   LET l_npq.npq06 = '1'
                END IF
              END IF
             #FUN-D40118 ---Add--- Start
              SELECT aag44 INTO l_aag44 FROM aag_file
               WHERE aag00 = g_bookno3
                 AND aag01 = l_npq.npq03
              IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                 CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                 IF l_flag = 'N'   THEN
                    LET l_npq.npq03 = ''
                 END IF
              END IF
             #FUN-D40118 ---Add--- End
              INSERT INTO npq_file VALUES (l_npq.*)
              MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                      l_npq.npq07
              IF STATUS THEN 
                 CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t910 b_curs_2 ins:",1)  
                 LET g_success='N' 
                 EXIT FOREACH 
              ELSE
                 LET l_npq.npq02 = l_npq.npq02 + 1
              END IF
           END IF
          END FOREACH
          #--差異歸到最後一筆,與aapt810原則相同
          LET l_npq.npq07 = l_npq.npq07 + (l_aqb04_2 - l_amt_api05_2)   
          LET l_npq.npq07f = l_npq.npq07
          UPDATE npq_file SET npq07 = l_npq.npq07,npq07f =l_npq.npq07f
            WHERE npq01 = l_npq.npq01 AND npq02 = l_npq.npq02-1    
              AND npq00 = 4 AND npqsys='AP'
              AND npqtype = l_npq.npqtype  
          IF STATUS THEN 
          CALL cl_err3("upd","npq_file",l_npq.npq01,l_npq.npq02-1,SQLCA.sqlcode,"","upd npq#2:",1)  
          LET g_success = 'N' END IF
     END IF
     #--->STOCK
     IF l_apa51_2 = 'STOCK' THEN    
      #--計算總合
      SELECT SUM(apb10) INTO l_sum_apb10_2 FROM apb_file
       WHERE apb01=l_aqb02_2   
        IF cl_null(l_sum_apb10_2) THEN LET l_sum_apb10_2=0 END IF
        LET l_amt_apb10_2 = 0
        #--計算每筆
        DECLARE c_curs_2 CURSOR FOR
           SELECT * FROM apb_file WHERE apb01 = l_aqb02_2   
        FOREACH c_curs_2 INTO l_apb_2.*
           IF STATUS THEN 
              CALL cl_err('c_curs_2:',SQLCA.sqlcode,1)   
              LET g_success='N' 
              EXIT FOREACH
           END IF
           IF p_npptype = '0' THEN  
              LET l_npq.npq03 = l_apb_2.apb25
           ELSE
              LET l_npq.npq03 = l_apb_2.apb251
           END IF
           LET l_npq.npq04 = ' '
           LET l_npq.npq06 = '2'
           SELECT apa06,apa07 INTO l_apa06_2,l_apa07_2 FROM apa_file
            WHERE apa01=l_aqb02_2
           LET l_npq.npq21 = l_apa06_2
           LET l_npq.npq22 = l_apa07_2
           LET l_npq.npq23 = l_aqb02_2
           LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
           LET l_npq.npq25 = 1                        #匯率
           LET g_npq25  = l_npq.npq25                 
           IF l_sum_apb10_2!=0 THEN
              LET l_npq.npq07 = l_aqb04_2*l_apb_2.apb10/l_sum_apb10_2
              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
           ELSE
              LET l_npq.npq07 = 0
           END IF
           LET l_npq.npq07f=l_npq.npq07      
           IF cl_null(l_npq.npq07) THEN 
              LET l_npq.npq07=0
           END IF
           IF cl_null(l_npq.npq07f) THEN 
              LET l_npq.npq07f=0
           END IF
           LET l_amt_apb10_2 = l_amt_apb10_2 + l_npq.npq07
           SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23 FROM aag_file
            WHERE aag01=l_npq.npq03 
              AND aag00 = g_bookno3   
           IF l_aag23 = 'Y' THEN
              LET l_npq.npq08 = l_apa66    # 專案
           ELSE
              LET l_npq.npq08 = null
           END IF

           IF l_aag05='Y' THEN
              IF g_aaz.aaz90='N' THEN                
                 LET l_npq.npq05 = l_apb_2.apb26      
              ELSE                                    
                 LET l_npq.npq05 = l_apb_2.apb930     
              END IF                                  
           ELSE
              LET l_npq.npq05 = ''           
           END IF
           LET l_npq.npq11=l_apa67
           LET l_npq.npq12=l_apa68
           LET l_npq.npq13=l_apa69
           LET l_npq.npq14=l_apa70
           ##
           IF l_npq.npq07!=0 THEN 
              CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3) 
              RETURNING l_npq.*
              CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING  l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34     

              IF p_npptype = '1' THEN
                 SELECT aaa03 INTO l_aaa03 FROM aaa_file                        
                  WHERE aaa01 = g_bookno2
                 SELECT azi04 INTO g_azi04_2 FROM azi_file                      
                  WHERE azi01 = l_aaa03
                 CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,                
                                g_npq25,l_npp.npp02)
                 RETURNING l_npq.npq25
                 LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) 
              ELSE
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   
              END IF
              LET l_npq.npqlegal = g_legal
              IF l_apa00 MATCHES '2*' THEN
                 IF l_apydmy6='Y' THEN
                   LET l_npq.npq07f= l_npq.npq07f* -1
                   LET l_npq.npq07 = l_npq.npq07 * -1
                ELSE
                   LET l_npq.npq06 = '1'
                END IF
              END IF
             #FUN-D40118 ---Add--- Start
              SELECT aag44 INTO l_aag44 FROM aag_file
               WHERE aag00 = g_bookno3
                 AND aag01 = l_npq.npq03
              IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                 CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                 IF l_flag = 'N'   THEN
                    LET l_npq.npq03 = ''
                 END IF
              END IF
             #FUN-D40118 ---Add--- End
              INSERT INTO npq_file VALUES (l_npq.*)
              MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                      l_npq.npq07
              IF STATUS THEN 
                 CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t910 b_curs_3 ins:",1)  
                 LET g_success='N' 
                 EXIT FOREACH 
              ELSE
                 LET l_npq.npq02 = l_npq.npq02 + 1
              END IF
           END IF
          END FOREACH
          #--差異歸到最後一筆,與aapt810原則相同
          LET l_npq.npq07 = l_npq.npq07 + (l_aqb04_2 - l_amt_apb10_2)         
          LET l_npq.npq07f = l_npq.npq07
          UPDATE npq_file SET npq07 = l_npq.npq07,npq07f =l_npq.npq07f
            WHERE npq01 = l_npq.npq01 AND npq02 = l_npq.npq02-1    #因為剛才npq02已先加一了,所以要減掉才會是最後一筆
              AND npq00 = 4 AND npqsys='AP'
              AND npqtype = p_npptype  
          IF STATUS THEN 
          CALL cl_err3("upd","npq_file",l_npq.npq01,l_npq.npq02-1,SQLCA.sqlcode,"","upd npq#3:",1)  
          LET g_success = 'N' END IF
       END IF
       LET l_npq.npq02 = l_npq.npq02 + 1
      END FOREACH
      
   CALL t110_gen_diff(l_npp.*)
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)     
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
   
END FUNCTION


FUNCTION t910_stock_act(p_apb01,p_apb02,p_npptype,p_ware,p_loc)  
  DEFINE p_apb01    LIKE apb_file.apb01
  DEFINE p_apb02    LIKE apb_file.apb02
  DEFINE p_npptype  LIKE npp_file.npptype 
  DEFINE p_item     LIKE ima_file.ima01
  DEFINE p_ware     LIKE ime_file.ime01
  DEFINE p_loc      LIKE ime_file.ime02
  DEFINE l_actno    LIKE aag_file.aag01
  DEFINE g_ccz07    LIKE ccz_file.ccz07
 
  SELECT apb12 INTO p_item
    FROM apb_file
   WHERE apb01=p_apb01 AND apb02=p_apb02
 
  SELECT ccz07 INTO g_ccz07 FROM ccz_file WHERE ccz00='0'
 
  CASE WHEN g_ccz07='1' IF p_npptype = '0' THEN  
                           SELECT ima39 INTO l_actno FROM ima_file
                            WHERE ima01=p_item
                        ELSE
                           SELECT ima391 INTO l_actno FROM ima_file
                            WHERE ima01=p_item
                        END IF
       WHEN g_ccz07='2' IF p_npptype = '0' THEN 
                           SELECT imz39 INTO l_actno
                             FROM ima_file,imz_file
                            WHERE ima01=p_item AND ima06=imz01
                        ELSE
                           SELECT imz391 INTO l_actno
                             FROM ima_file,imz_file
                            WHERE ima01=p_item AND ima06=imz01
                        END IF
       WHEN g_ccz07='3' IF p_npptype = '0' THEN  
                           SELECT imd08 INTO l_actno FROM imd_file
                            WHERE imd01=p_ware
                        ELSE
                           SELECT imd081 INTO l_actno FROM imd_file
                            WHERE imd01=p_ware
                        END IF
       WHEN g_ccz07='4' IF p_npptype = '0' THEN  
                           SELECT ime09 INTO l_actno FROM ime_file
                            WHERE ime01=p_ware AND ime02=p_loc
                        ELSE
                           SELECT ime091 INTO l_actno FROM ime_file
                            WHERE ime01=p_ware AND ime02=p_loc
                        END IF
       OTHERWISE        LET l_actno='STOCK'
  END CASE
  RETURN l_actno
END FUNCTION

FUNCTION t910_gl_ins_npq(p_apno,l_actno,l_curr,l_rate,l_npq02,l_npq07,l_apa06,l_apa07,l_apa22,p_npptype)
  DEFINE l_aqa     RECORD LIKE aqa_file.*
  DEFINE l_npq     RECORD LIKE npq_file.*
  DEFINE p_apno     LIKE aqa_file.aqa01
  DEFINE l_actno    LIKE apa_file.apa01
  DEFINE l_curr     LIKE npq_file.npq24
  DEFINE l_rate     LIKE npq_file.npq25
  DEFINE l_npq02    LIKE npq_file.npq02
  DEFINE l_npq07    LIKE npq_file.npq07
  DEFINE l_apa06    LIKE apa_file.apa06
  DEFINE l_apa07    LIKE apa_file.apa07
  DEFINE l_apa22    LIKE apa_file.apa22
  DEFINE l_apb25    LIKE apb_file.apb25
  DEFINE l_apb26    LIKE apb_file.apb26           
  DEFINE l_apb10    LIKE apb_file.apb10
  DEFINE l_apa31    LIKE apa_file.apa31
  DEFINE s_npq07    LIKE npq_file.npq07
  DEFINE l_aag05    LIKE aag_file.aag05
  DEFINE l_cnt,l_cnt2 LIKE type_file.num5
  DEFINE p_npptype  LIKE npp_file.npptype  
  DEFINE l_apa00    LIKE apa_file.apa00   
  DEFINE l_sql      STRING   
  DEFINE l_apa02    LIKE apa_file.apa02   
  DEFINE l_aaa03    LIKE aaa_file.aaa03  
  DEFINE l_apb930   LIKE apb_file.apb930  
  DEFINE l_aqa03    LIKE aqa_file.aqa03
  DEFINE l_apydmy6  LIKE apy_file.apydmy6 
  DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
  DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add

  LET l_npq.npqsys = 'AP'
  LET l_npq.npq00 = 4
  LET l_npq.npq011 = 1
  LET l_npq.npq02 = l_npq02
  LET l_npq.npqtype = p_npptype
 
  LET l_npq.npq01  = p_apno
  LET l_cnt = 0

  LET l_apa00 = ''
  SELECT apa00,apa02 INTO l_apa00,l_apa02 FROM apa_file WHERE apa01 = l_actno
  LET g_t1=s_get_doc_no(p_apno)
  SELECT apydmy6 INTO l_apydmy6 FROM apy_file WHERE apyslip=g_t1  #紅沖 
  IF l_apa00 = '23' THEN
     SELECT COUNT(*) INTO l_cnt FROM apb_file
        WHERE apb01 = (SELECT apa08 FROM apa_file WHERE apa01 = l_actno)
     IF p_npptype = '0' THEN
        LET l_sql = " SELECT apb25,apb10,apb26,apb930 FROM apb_file ", 
                    "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
                    "  WHERE apa01 = '",l_actno,"')"
     ELSE
        LET l_sql = " SELECT apb251,apb10,apb26,apb930 FROM apb_file ",
                    "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
                    "  WHERE apa01 = '",l_actno,"')"
     END IF
  ELSE
     SELECT COUNT(*) INTO l_cnt FROM apb_file
        WHERE apb01 = l_actno
     IF p_npptype = '0' THEN
        LET l_sql = " SELECT apb25,apb10,apb26,apb930 FROM apb_file ",  
                    "  WHERE apb01 = '",l_actno,"'"
     ELSE
        LET l_sql = " SELECT apb251,apb10,apb26,apb930 FROM apb_file ", 
                    "  WHERE apb01 = '",l_actno,"'"
     END IF
  END IF
  PREPARE t910_gl_p3 FROM l_sql
  DECLARE t910_gl_c3 CURSOR FOR t910_gl_p3
  LET l_apa31 = 0
 
  FOREACH t910_gl_c3 INTO l_apb25,l_apb10,l_apb26,l_apb930              
    LET l_apa31 = l_apa31 + l_apb10
  END FOREACH
  LET l_cnt2 = 1
  LET s_npq07 = 0
                       
  FOREACH t910_gl_c3 INTO l_apb25,l_apb10,l_apb26,l_apb930               
     IF l_cnt2 = l_cnt THEN
        LET l_npq.npq07 = l_npq07 - s_npq07
     ELSE
        LET l_npq.npq07 = l_apb10 * (l_npq07/l_apa31)
     END IF
     LET l_npq.npq03 = l_apb25
     LET l_npq.npq23 = l_actno
     LET l_npq.npq04 = ' '
     LET l_npq.npq06 = '2'
     LET l_npq.npq24 = l_curr
     LET l_npq.npq25 = l_rate
     LET g_npq25  = l_npq.npq25                 
     LET l_npq.npq21 = l_apa06
     LET l_npq.npq22 = l_apa07
     SELECT aag05 INTO l_aag05 FROM aag_file
        WHERE aag01=l_npq.npq03
          AND aag00 = g_bookno3   
     IF l_aag05 = 'Y' THEN
        IF g_aaz.aaz90='N' THEN            
           LET l_npq.npq05 = l_apb26       
        ELSE                              
           LET l_npq.npq05 = l_apb930      
        END IF                            
     ELSE
        LET l_npq.npq05 = ' '
     END IF
     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
     LET l_npq.npq07f = l_npq.npq07

     IF l_npq.npq07 <> 0  THEN 
        IF p_npptype = '1' THEN
           SELECT aaa03 INTO l_aaa03 FROM aaa_file
            WHERE aaa01 = g_bookno2
           SELECT azi04 INTO g_azi04_2 FROM azi_file
            WHERE azi01 = l_aaa03
           CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                          g_npq25,l_apa02)
           RETURNING l_npq.npq25
           LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
        ELSE
           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  
        END IF

        LET l_npq.npqlegal = g_legal
        IF l_apa00 MATCHES '2*' THEN
           IF l_apydmy6='Y' THEN
              LET l_npq.npq07f= l_npq.npq07f* -1
              LET l_npq.npq07 = l_npq.npq07 * -1
           ELSE
              LET l_npq.npq06 = '1'
           END IF
        END IF 
         #FUN-D10065--add--str--
        CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','')
        RETURNING l_npq.npq04
        #FUN-D10065--add--end--
       #FUN-D40118 ---Add--- Start
        SELECT aag44 INTO l_aag44 FROM aag_file
         WHERE aag00 = g_bookno3
           AND aag01 = l_npq.npq03
        IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
           CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
           IF l_flag = 'N'   THEN
              LET l_npq.npq03 = ''
           END IF
        END IF
       #FUN-D40118 ---Add--- End
        INSERT INTO npq_file VALUES (l_npq.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err('ins npq',SQLCA.sqlcode,1)
           LET g_success = 'N' EXIT FOREACH
        END IF
     END IF    
     LET l_npq.npq02 = l_npq.npq02 + 1
     LET l_cnt2 = l_cnt2 + 1
     LET s_npq07 = s_npq07 + l_npq.npq07
  END FOREACH
  RETURN l_npq.npq02
END FUNCTION

FUNCTION t110_gen_diff(p_npp)
DEFINE p_npp   RECORD LIKE npp_file.*
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add

   IF p_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(p_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                        
      IF g_flag =  '1' THEN
         CALL cl_err(p_npp.npp02,'aoo-081',1)                                                                                          
         RETURN                                                                                                                        
      END IF                                                                                                                           
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = p_npp.npp00
            AND npq01 = p_npp.npp01
            AND npq011= p_npp.npp011
            AND npqsys= p_npp.nppsys
         LET l_npq1.npqtype = p_npp.npptype
         LET l_npq1.npq00 = p_npp.npp00
         LET l_npq1.npq01 = p_npp.npp01
         LET l_npq1.npq011= p_npp.npp011
         LET l_npq1.npqsys= p_npp.nppsys
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
         LET l_npq1.npqlegal = g_legal
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno1,l_npq1.npq03,g_prog,l_npq1.npq01,'','')
         RETURNING l_npq1.npq04
         #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
           CALL s_chk_ahk(l_npq1.npq03,g_bookno2) RETURNING l_flag
           IF l_flag = 'N'   THEN
              LET l_npq1.npq03 = ''
           END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",p_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#FUN-C70093

