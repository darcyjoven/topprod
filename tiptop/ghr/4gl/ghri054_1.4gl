# Prog. Version..: '5.10.03-08.09.13(00009)'     #
# Pattern name...: ghri054_1.4gl
# Descriptions...: 
# Date & Author..: 20130702 by zhuzw

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
     g_hrcma           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sel          LIKE type_file.chr1,        
        hrcm02       LIKE hrcm_file.hrcm02, 
        hrcm03       LIKE hrcm_file.hrcm03,       
        hrat01       LIKE hrat_file.hrat01,        #
        hrat02       LIKE hrat_file.hrat02,        #
        hrat04_name  LIKE hrao_file.hrao02,        #
        hrat05_name  LIKE hras_file.hras02,   # 
        hrcma15      LIKE hrcma_file.hrcma15,
        hrcma04       LIKE hrcma_file.hrcma04,
        hrcma05       LIKE hrcma_file.hrcma05,
        hrcma06       LIKE hrcma_file.hrcma06,
        hrcma07       LIKE hrcma_file.hrcma07,
        hrcma08       LIKE hrcma_file.hrcma08,
        hrcma09       LIKE hrcma_file.hrcma09,
        hrcma09_name  LIKE hrbm_file.hrbm04
                    END RECORD,                    
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,        #單身筆數
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT

DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change,g_rec_b1  LIKE type_file.num5    
DEFINE g_row_count  LIKE type_file.num5   
DEFINE g_curs_index LIKE type_file.num5  
DEFINE g_str        STRING              
DEFINE g_flag       LIKE type_file.chr1
FUNCTION i054_1()
 DEFINE p_row,p_col   LIKE type_file.num5
    CALL cl_set_comp_entry("hrcm02,hrcm03,hrat01,hrat02,hrat04_name,hrat05_name,hrcm03,hrcma04,hrcma05,hrcma06,hrcma07,hrcma08,hrcma09,hrcma09_name ",TRUE)
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i054_1_w AT p_row,p_col WITH FORM "ghr/42f/ghri054_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    CALL i054_1_b_askkey()
    CALL i054_1_b_cl()
    CLOSE WINDOW i054_1_w 
END FUNCTION 
FUNCTION  i054_1_b_cl()
DEFINE  l_hrcma           RECORD    
        hrcm02       LIKE hrcm_file.hrcm02, 
        hratid       LIKE hrat_file.hratid,        
        hrcma04       LIKE hrcma_file.hrcma04,
        hrcma05       LIKE hrcma_file.hrcma05,
        hrcma06       LIKE hrcma_file.hrcma06,
        hrcma07       LIKE hrcma_file.hrcma07,
        hrcma08       LIKE hrcma_file.hrcma08,
        hrcma09       LIKE hrcma_file.hrcma09
        END RECORD
DEFINE         l_a,l_b,l_c,l_d,l_e,l_i,l_n,l_m,l_bm,l_em,l_num,l_o,l_k,l_x          LIKE  type_file.num5         
DEFINE l_hrcl_file RECORD LIKE hrcl_file.* 
DEFINE l_g,l_f,l_g1           LIKE type_file.chr1  
DEFINE l_hrcma05,l_hrcma07 LIKE hrcma_file.hrcma05
DEFINE l_hrby RECORD LIKE hrby_file.* 
DEFINE l_hrcn05,l_hrcn07,l_time,p_time,l_btime,l_etime,l_hrcn07_1,l_hrcn07_2,l_hrcn05_1      LIKE hrcn_file.hrcn05
DEFINE l_hrcn12,l_hrcn13      LIKE hrcn_file.hrcn13
DEFINE l_hrcn02      LIKE hrcn_file.hrcn02
DEFINE l_hrcn08,l_hrcn08_1,l_hrcn08_2      LIKE hrcn_file.hrcn08
DEFINE l_hrcnconf    LIKE hrcn_file.hrcnconf
DEFINE l_sql STRING 
DEFINE l_hrbtud02    LIKE hrbt_file.hrbtud02
DEFINE l_hrby10,l_hrby10_1,l_hrby10_2,l_hrby10_3,l_p LIKE hrby_file.hrby10
DEFINE l_hrcma04,l_hrcma06  LIKE hrcma_file.hrcma04
DEFINE l_hrcma10     LIKE hrcma_file.hrcma10
DEFINE l_hrcma11     LIKE hrcma_file.hrcma11
DEFINE l_hrcn14      LIKE hrcn_file.hrcn14
DEFINE l_hrboa    RECORD LIKE hrboa_file.*
DEFINE l_jcsj    LIKE hrcn_file.hrcn08
DEFINE l_hrat21  LIKE hrat_file.hrat21
DEFINE l_hrboa02 LIKE hrboa_file.hrboa02
DEFINE l_hrbn02    LIKE hrbn_file.hrbn02
   LET l_sql = "SELECT * FROM hrcma_tmp"
   PREPARE i054_1_rp FROM l_sql 
   DECLARE i054_1_cl CURSOR FOR i054_1_rp 
   FOREACH i054_1_cl INTO l_hrcma.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH   
      END IF  
      LET l_f = 'Y' 
      CALL i054_1_hrcl(l_hrcma.hratid,l_hrcma.hrcma09) RETURNING l_hrcl_file.*,l_g
      IF l_g = 'N' THEN 
         CONTINUE FOREACH  #没有合适的考勤参数
      END IF 
      LET l_hrcn05 = ''
      LET l_hrcn07 = ''
      IF l_hrcl_file.hrcl05 = 'N' THEN 
         IF l_hrcl_file.hrcl06 = 'Y' THEN  
            LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_hrcl_file.hrcl07,"' minute,'hh24:mi')  FROM  dual "
            PREPARE i054_1_a1 FROM l_sql
            EXECUTE i054_1_a1 INTO l_hrcma05 
         END IF 
         IF l_hrcl_file.hrcl08 = 'Y' THEN 
            LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_hrcl_file.hrcl09,"' minute,'hh24:mi')  FROM  dual "
            PREPARE i054_1_a2 FROM l_sql
            EXECUTE i054_1_a2 INTO l_hrcma07        

         END IF    
      END IF 
      SELECT hrbtud02 INTO l_hrbtud02 FROM hrbt_file      
      IF l_hrbtud02 = '002' THEN
         #计算提前,延长加班时间
         LET l_bm = 0
         LET l_a = 0 
         IF l_hrcl_file.hrcl06 = 'Y' THEN 
            IF l_hrcma05 > l_hrcma.hrcma05 THEN 
               LET l_hrcma04 = l_hrcma.hrcma04 - 1
               SELECT mod(COUNT(*),2) INTO l_a FROM hrby_file
                	WHERE ( hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  '00:00' AND l_hrcma.hrcma05  )
                	   OR ( hrby05 = l_hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND '24:00'  )
                    AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                    
               IF l_a >0 THEN                     
                  SELECT hrby06  INTO p_time FROM hrby_file  
                	WHERE ( hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  '00:00' AND l_hrcma.hrcma05  )
                	   OR ( hrby05 = l_hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND '24:00'  )
                    AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'   
                    AND rownum = '1'
                    ORDER BY hrby05,hrby06 desc
                    CALL i054_1_mi(l_hrcma.hrcma05,p_time) RETURNING l_bm
                  IF l_bm <  l_hrcl_file.hrcl11 OR  l_hrcl_file.hrcl10 = 'N' THEN 
                     LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                     PREPARE i054_1_d1 FROM l_sql
                     EXECUTE i054_1_d1 INTO l_hrcn05 
                     LET l_bm = 0                    
                  ELSE   
                  	 IF l_hrcl_file.hrcl10 = 'Y' THEN  
                        SELECT  l_bm - mod(l_bm,l_hrcl_file.hrcl11) INTO l_bm FROM  dual 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_1_d2 FROM l_sql
                        EXECUTE i054_1_d2 INTO l_hrcn05
                     END IF 
                  END IF    
               END IF  
                             
            ELSE  
               SELECT mod(COUNT(*),2) INTO l_a FROM hrby_file
                	WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND l_hrcma.hrcma05  
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                    
               IF l_a >0 THEN                     
                  SELECT hrby06  INTO p_time FROM hrby_file  
                  WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND l_hrcma.hrcma05  
                    AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                    AND rownum = '1'
                    ORDER BY hrby06 desc
                    CALL i054_1_mi(l_hrcma.hrcma05,p_time) RETURNING l_bm
                  IF l_bm <  l_hrcl_file.hrcl11 OR  l_hrcl_file.hrcl10 = 'N' THEN 
                     LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                     PREPARE i054_1_b1 FROM l_sql
                     EXECUTE i054_1_b1 INTO l_hrcn05 
                     LET l_bm = 0                    
                  ELSE   
                  	 IF l_hrcl_file.hrcl10 = 'Y' THEN  
                        SELECT  l_bm - mod(l_bm,l_hrcl_file.hrcl11) INTO l_bm FROM  dual 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_1_b2 FROM l_sql
                        EXECUTE i054_1_b2 INTO l_hrcn05
                     END IF 
                  END IF    
               END IF   
            END IF    
         END IF 
         IF l_hrcma.hrcma04 = l_hrcma.hrcma06 THEN  
            SELECT mod(COUNT(*),2),COUNT(*) INTO l_c,l_d FROM hrby_file  
             WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND l_hrcma.hrcma07  
               AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'  
         ELSE 
            SELECT mod(COUNT(*),2),COUNT(*) INTO l_c,l_d FROM hrby_file  
             WHERE ((hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND '23:59')
                OR (hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  '00:00' AND l_hrcma.hrcma07))
               AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y' 
         END IF 	   
         IF l_a = 0 AND l_d = 0 AND l_hrcl_file.hrcl06 = 'Y' THEN 
            CONTINUE FOREACH #没有合适的考勤数据
         END IF          
         LET l_em = 0
         LET l_b = 0
         IF l_hrcl_file.hrcl08 = 'Y' THEN  
            IF l_hrcma.hrcma07 > l_hrcma07 THEN 
               LET l_hrcma06 = l_hrcma.hrcma06 + 1
               SELECT COUNT(*) INTO l_b FROM hrby_file
                WHERE ((hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND '23:59')  
                   OR (hrby05 = l_hrcma06 AND hrby06 BETWEEN  '00:00' AND l_hrcma07))
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                     
               IF l_b > 0 THEN                      
               
                  SELECT  hrby06 INTO p_time FROM hrby_file  
                  WHERE ((hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND '23:59')  
                     OR (hrby05 = l_hrcma06 AND hrby06 BETWEEN  '00:00' AND l_hrcma07))
                    AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                    AND rownum = '1'
                    ORDER BY hrby06 
                  CALL i054_1_mi(p_time,l_hrcma.hrcma07) RETURNING l_em
               
                  IF l_em <  l_hrcl_file.hrcl13 OR  l_hrcl_file.hrcl12 = 'N'  THEN 
                     LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                     PREPARE i054_1_d3 FROM l_sql
                     EXECUTE i054_1_d3 INTO l_hrcn07
                     LET l_em = 0                    
                  ELSE   
                  	 IF l_hrcl_file.hrcl12 = 'Y' THEN 
                        SELECT  l_em - mod(l_em,l_hrcl_file.hrcl13) INTO l_em FROM  dual 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_1_d4 FROM l_sql
                        EXECUTE i054_1_d4 INTO l_hrcn07
                     END IF 
                  END IF     
               ELSE 
               	  IF  l_d = 0 AND l_hrcl_file.hrcl08 = 'Y' THEN 
               	     CONTINUE FOREACH #没有合适的考勤数据
               	  END IF 
               END IF
            ELSE           	
               SELECT COUNT(*) INTO l_b FROM hrby_file
                WHERE hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND l_hrcma07  
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                     
               IF l_b > 0 THEN                      
               
                  SELECT  hrby06 INTO p_time FROM hrby_file  
                  WHERE hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND l_hrcma07   
                    AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                    AND rownum = '1'
                    ORDER BY hrby06 
                  CALL i054_1_mi(p_time,l_hrcma.hrcma07) RETURNING l_em
               
                  IF l_em <  l_hrcl_file.hrcl13 OR  l_hrcl_file.hrcl12 = 'N'  THEN 
                     LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                     PREPARE i054_1_b3 FROM l_sql
                     EXECUTE i054_1_b3 INTO l_hrcn07
                     LET l_em = 0                    
                  ELSE   
                  	 IF l_hrcl_file.hrcl12 = 'Y' THEN 
                        SELECT  l_em - mod(l_em,l_hrcl_file.hrcl13) INTO l_em FROM  dual 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_1_b4 FROM l_sql
                        EXECUTE i054_1_b4 INTO l_hrcn07
                     END IF 
                  END IF     
               ELSE 
               	  IF  l_d = 0 AND l_hrcl_file.hrcl08 = 'Y' THEN 
               	     CONTINUE FOREACH #没有合适的考勤数据
               	  END IF 
               END IF   
            END IF     
         END IF                                                 
         IF l_hrcma.hrcma04 = l_hrcma.hrcma06 AND  l_hrcl_file.hrcl06 = 'Y' AND  l_hrcl_file.hrcl08 = 'Y' THEN  
            LET l_sql = " SELECT * FROM hrby_file ",
                        "  WHERE hrby05 = '",l_hrcma.hrcma04,"' AND hrby06 BETWEEN  '",l_hrcma.hrcma05 CLIPPED ,"' AND '",l_hrcma.hrcma07 CLIPPED,"'  and hrby09 = '",l_hrcma.hratid CLIPPED,"' and hrby11= '1' and hrbyacti = 'Y' ",
                        "  order by hrby05,hrby06 "
         #         ELSE 
         #            l_sql = " SELECT * FROM hrby_file ",
         #                    "  WHERE (hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  '",l_hrcma.hrcma05,"' AND '23:59') ",
         #         	         "     OR (hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  '00:00' AND '",l_hrcma.hrcma07,"')  and hrby09 = '",l_hrcma.hratid,"' and hrby11= '1' and hrbyacti = 'Y' "
         END IF
         PREPARE i054_1_sk FROM l_sql
         DECLARE hrby_curs1 CURSOR FOR i054_1_sk
         LET l_i = 1
         LET l_m = 0
         LET l_n = 0
         LET l_o = 0  
         LET l_hrcn12 = 0 
         LET l_hrcn13 = 0 
         FOREACH hrby_curs1 INTO l_hrby.*
            #无早到加班,计划区间考勤笔数为偶数
            IF l_a = 0 AND l_c = 0  THEN 
               SELECT mod(l_i,2) INTO l_m FROM dual
               IF l_m = 1 THEN 
                  LET l_time = l_hrby.hrby06
                  LET l_n = 0
               ELSE 
                  CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                  LET l_o = l_o + l_n
               END IF 	            
               IF l_i = 1 THEN 
                  LET l_hrcn05 = l_hrby.hrby06 
                  CALL i054_1_mi(l_hrby.hrby06,l_hrcma.hrcma05) RETURNING l_hrcn13
               END IF 
               IF l_i = l_d  THEN 
                  LET l_hrcn07 = l_hrby.hrby06
                  CALL i054_1_mi(l_hrcma.hrcma07,l_hrby.hrby06) RETURNING l_hrcn12 
               END IF
            END IF 
            #无早到加班,计划区间考勤笔数为奇数
            IF l_a = 0 AND l_c = 1  THEN 
               SELECT mod(l_i,2) INTO l_m FROM dual
               IF l_m = 1 THEN 
                  LET l_time = l_hrby.hrby06
                  LET l_n = 0
               ELSE 
                  CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n                  
                  LET l_o = l_o + l_n
               END IF 	            
               IF l_i = 1 THEN 
                  LET l_hrcn05 = l_hrby.hrby06 
                  CALL i054_1_mi(l_hrby.hrby06,l_hrcma.hrcma05) RETURNING l_hrcn13  
               END IF 
               IF l_i = l_d - 1 AND l_b = 0  THEN 
                  LET l_hrcn07 = l_hrby.hrby06
                  CALL i054_1_mi(l_hrcma.hrcma07,l_hrby.hrby06) RETURNING l_hrcn12
               END IF
               IF l_i = l_d  AND l_b > 0  THEN 
                  CALL i054_1_mi(l_hrcma.hrcma07,l_hrby.hrby06) RETURNING l_n                  
                  LET l_o = l_o + l_n
               END IF               
            END IF                                       
            #有早到加班,计划区间考勤笔数为偶数
            IF l_a = 1 AND l_c = 0  THEN 
               SELECT mod(l_i,2) INTO l_m FROM dual
               IF l_m = 0 THEN 
                  LET l_time = l_hrby.hrby06
                  LET l_n = 0
               ELSE 
                  IF l_i = 1 THEN 
                     CALL i054_1_mi(l_hrby.hrby06,l_hrcma.hrcma05) RETURNING l_n
                     LET l_o = l_o + l_n                        
                  ELSE 
                     CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                     LET l_o = l_o + l_n
                  END IF 
               END IF 	             
               IF l_i = l_d - 1 AND l_b = 0  THEN 
                  LET l_hrcn07 = l_hrby.hrby06
                  CALL i054_1_mi(l_hrcma.hrcma07,l_hrby.hrby06) RETURNING l_hrcn12
               END IF
               IF l_i = l_d  AND l_b > 0  THEN 
                  CALL i054_1_mi(l_hrcma.hrcma07,l_hrby.hrby06) RETURNING l_n
                  LET l_o = l_o + l_n
               END IF               
            END IF
            #有早到加班,计划区间考勤笔数为奇数
            IF l_a = 1 AND l_c = 1  THEN 
               SELECT mod(l_i,2) INTO l_m FROM dual
               IF l_m = 0 THEN 
                  LET l_time = l_hrby.hrby06
                  LET l_n = 0
               ELSE 
                  IF l_i = 1 THEN 
                   CALL i054_1_mi(l_hrby.hrby06,l_hrcma.hrcma05) RETURNING l_n
                     LET l_o = l_o + l_n                        
                  ELSE 
                     CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                     LET l_o = l_o + l_n
                  END IF 
               END IF 	             
               IF l_i = l_d  THEN 
                  LET l_hrcn07 = l_hrby.hrby06
                   CALL i054_1_mi(l_hrcma.hrcma07,l_hrby.hrby06) RETURNING l_hrcn12
               END IF               
            END IF
            LET l_i = l_i + 1         
         END FOREACH
         IF l_d = 0 AND l_a >0 AND l_b > 0THEN 
            CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_o 
         END IF 
         IF l_hrcl_file.hrcl06 = 'Y' AND  l_hrcl_file.hrcl08 = 'Y' THEN 
            LET l_hrcn08 = l_bm + l_em + l_o            
         END IF 
         IF l_hrcl_file.hrcl06 = 'Y' AND  l_hrcl_file.hrcl08 = 'N' THEN 
            IF l_a = 1 THEN 
               CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_hrcn08
               LET l_hrcn08 = l_hrcn08 + l_bm
               LET l_hrcn13 = 0
               LET l_hrcn12 = 0 
               LET l_hrcn07 = l_hrcma.hrcma07
            ELSE
               SELECT hrby06 INTO p_time FROM hrby_file   
                WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05  AND l_hrcma.hrcma07   
                  AND hrby09 = l_hrcma.hratid  and hrby11= '1' and hrbyacti = 'Y' AND rownum = '1'
                ORDER BY hrby05,hrby06
               CALL i054_1_mi(l_hrcma.hrcma07,p_time)RETURNING l_hrcn08
               CALL i054_1_mi(p_time,l_hrcma.hrcma05)RETURNING l_hrcn13
               LET l_hrcn12 = 0   
               LET l_hrcn05 = p_time
               LET l_hrcn07 = l_hrcma.hrcma07                  	   
            END IF 	 
         END IF  
         IF l_hrcl_file.hrcl06 = 'N' AND  l_hrcl_file.hrcl08 = 'Y' THEN 
            IF l_b = 0 THEN 
               SELECT hrby06 INTO p_time FROM hrby_file   
                WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05  AND l_hrcma.hrcma07   
                  AND hrby09 = l_hrcma.hratid  and hrby11= '1' and hrbyacti = 'Y' AND rownum = '1'
                ORDER BY hrby05,hrby06 desc             
               CALL i054_1_mi(p_time,l_hrcma.hrcma05)RETURNING l_hrcn08
               LET l_hrcn13 = 0
               CALL i054_1_mi(l_hrcma.hrcma07,p_time)RETURNING l_hrcn12                
               LET l_hrcn07 = p_time
               LET l_hrcn05 = l_hrcma.hrcma05 
            ELSE 
               CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_hrcn08
               LET l_hrcn08 = l_hrcn08 + l_em
               LET l_hrcn13 = 0
               LET l_hrcn12 = 0         
               LET l_hrcn05 = l_hrcma.hrcma05 
            END IF                  
         END IF 
         IF (l_hrcl_file.hrcl06 = 'N' AND  l_hrcl_file.hrcl08 = 'N') OR  l_hrcl_file.hrcl05 = 'Y' THEN 
            CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_hrcn08
            LET l_hrcn13 = 0
            LET l_hrcn12 = 0 
         END IF                       
      END IF 
     IF l_hrbtud02 = '003' THEN   #考勤类型为'003' #add by zhuzw 20140912 圣奥修改处理逻辑段 start
         #计算提前,延长加班时间
        #add by zhuzw 20141028 start 增加逆向考勤逻辑
         SELECT hrbn02 INTO l_hrbn02 FROM hrbn_file WHERE hrbn01 = l_hrcma.hratid AND  l_hrcma.hrcma04 BETWEEN hrbn04 AND hrbn05
         IF l_hrbn02 = '002' THEN 
            LET l_hrcn05 = l_hrcma.hrcma05
            LET l_hrcn07 = l_hrcma.hrcma07
            LET l_hrcn08 = l_hrcma.hrcma08*60
            LET l_hrcn12 = 0
            LET l_hrcn13 = 0
         ELSE 
         #add by zhuzw 20141028 end 	
            LET l_bm = 0
            LET l_a = 0 
            IF l_hrcl_file.hrcl06 = 'Y' THEN 
               IF l_hrcma05 > l_hrcma.hrcma05 THEN 
                  LET l_hrcma04 = l_hrcma.hrcma04 - 1
                  SELECT COUNT(*) INTO l_a FROM hrby_file
                   	WHERE ( hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  '00:00' AND l_hrcma.hrcma05  )
                   	   OR ( hrby05 = l_hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND '24:00'  )
                       AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                    
                  IF l_a >0 THEN                     
                     SELECT hrby06  INTO p_time FROM (SELECT hrby06 FROM hrby_file  
                   	WHERE ( hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  '00:00' AND l_hrcma.hrcma05  )
                   	   OR ( hrby05 = l_hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND '24:00'  )
                       AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'  
                       ORDER BY hrby05,hrby06  )
                       where  rownum = '1'
                       
                       CALL i054_1_mi(l_hrcma.hrcma05,p_time) RETURNING l_bm
                     IF l_bm <  l_hrcl_file.hrcl11 OR  l_hrcl_file.hrcl10 = 'N' THEN 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_bj_d11 FROM l_sql
                        EXECUTE i054_bj_d11 INTO l_hrcn05 
                        LET l_bm = 0                    
                     ELSE   
                     	 IF l_hrcl_file.hrcl10 = 'Y' THEN  
                           SELECT  l_bm - mod(l_bm,l_hrcl_file.hrcl11) INTO l_bm FROM  dual 
                           LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                           PREPARE i054_bj_d21 FROM l_sql
                           EXECUTE i054_bj_d21 INTO l_hrcn05
                        END IF 
                     END IF    
                  END IF  
                                
               ELSE  
                  SELECT COUNT(*) INTO l_a FROM hrby_file
                   	WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND l_hrcma.hrcma05  
                     AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                    
                  IF l_a >0 THEN                     
                     SELECT hrby06  INTO p_time FROM (SELECT hrby06 FROM hrby_file  
                     WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND l_hrcma.hrcma05  
                       AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                       ORDER BY hrby06)
                       WHERE rownum = '1' 
                       CALL i054_1_mi(l_hrcma.hrcma05,p_time) RETURNING l_bm
                     IF l_bm <  l_hrcl_file.hrcl11 OR  l_hrcl_file.hrcl10 = 'N' THEN 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_bj_b11 FROM l_sql
                        EXECUTE i054_bj_b11 INTO l_hrcn05 
                        LET l_bm = 0                    
                     ELSE   
                     	 IF l_hrcl_file.hrcl10 = 'Y' THEN  
                           SELECT  l_bm - mod(l_bm,l_hrcl_file.hrcl11) INTO l_bm FROM  dual 
                           LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                           PREPARE i054_bj_b21 FROM l_sql
                           EXECUTE i054_bj_b21 INTO l_hrcn05
                        END IF 
                     END IF    
                  END IF   
               END IF    
            END IF 
            IF l_hrcma.hrcma04 = l_hrcma.hrcma06 THEN  
               SELECT COUNT(*) INTO l_d FROM hrby_file  
                WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND l_hrcma.hrcma07  
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'  
            ELSE 
               SELECT COUNT(*) INTO l_d FROM hrby_file  
                WHERE ((hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND '23:59')
                   OR (hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  '00:00' AND l_hrcma.hrcma07))
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y' 
            END IF 	   
            IF l_a = 0 AND l_d = 0 AND l_hrcl_file.hrcl06 = 'Y' THEN 
               CONTINUE FOREACH #没有合适的考勤数据
            END IF          
            LET l_em = 0
            LET l_b = 0
            IF l_hrcl_file.hrcl08 = 'Y' THEN  
               IF l_hrcma.hrcma07 > l_hrcma07 THEN 
                  LET l_hrcma06 = l_hrcma.hrcma06 + 1
                  SELECT COUNT(*) INTO l_b FROM hrby_file
                   WHERE ((hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND '23:59')  
                      OR (hrby05 = l_hrcma06 AND hrby06 BETWEEN  '00:00' AND l_hrcma07))
                     AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                     
                  IF l_b > 0 THEN                      
                  
                     SELECT  hrby06 INTO p_time FROM (SELECT hrby06 FROM hrby_file  
                     WHERE ((hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND '23:59')  
                        OR (hrby05 = l_hrcma06 AND hrby06 BETWEEN  '00:00' AND l_hrcma07))
                       AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                       ORDER BY hrby06)
                       WHERE  rownum = '1'
                        
                     CALL i054_1_mi(p_time,l_hrcma.hrcma07) RETURNING l_em
                  
                     IF l_em <  l_hrcl_file.hrcl13 OR  l_hrcl_file.hrcl12 = 'N'  THEN 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_bj_d31 FROM l_sql
                        EXECUTE i054_bj_d31 INTO l_hrcn07
                        LET l_em = 0                    
                     ELSE   
                     	 IF l_hrcl_file.hrcl12 = 'Y' THEN 
                           SELECT  l_em - mod(l_em,l_hrcl_file.hrcl13) INTO l_em FROM  dual 
                           LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                           PREPARE i054_bj_d41 FROM l_sql
                           EXECUTE i054_bj_d41 INTO l_hrcn07
                        END IF 
                     END IF     
                  ELSE 
                  	  IF  l_d = 0 AND l_hrcl_file.hrcl08 = 'Y' THEN 
                  	     CONTINUE FOREACH #没有合适的考勤数据
                  	  END IF 
                  END IF
               ELSE           	
                  SELECT COUNT(*) INTO l_b FROM hrby_file
                   WHERE hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND l_hrcma07  
                     AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                     
                  IF l_b > 0 THEN                      
                  
                     SELECT  hrby06 INTO p_time FROM (SELECT hrby06 FROM hrby_file  
                     WHERE hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND l_hrcma07   
                       AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                       ORDER BY hrby06)
                       WHERE rownum = '1' 
                     CALL i054_1_mi(p_time,l_hrcma.hrcma07) RETURNING l_em
                  
                     IF l_em <  l_hrcl_file.hrcl13 OR  l_hrcl_file.hrcl12 = 'N'  THEN 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_bj_b31 FROM l_sql
                        EXECUTE i054_bj_b31 INTO l_hrcn07
                        LET l_em = 0                    
                     ELSE   
                     	 IF l_hrcl_file.hrcl12 = 'Y' THEN 
                           SELECT  l_em - mod(l_em,l_hrcl_file.hrcl13) INTO l_em FROM  dual 
                           LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                           PREPARE i054_bj_b41 FROM l_sql
                           EXECUTE i054_bj_b41 INTO l_hrcn07
                        END IF 
                     END IF     
                  ELSE 
                  	  IF  l_d = 0 AND l_hrcl_file.hrcl08 = 'Y' THEN 
                  	     CONTINUE FOREACH #没有合适的考勤数据
                  	  END IF 
                  END IF   
               END IF     
            END IF 
            IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN 
              SELECT    hrby06 INTO l_btime FROM (SELECT hrby06 FROM hrby_file
                 WHERE  hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND '23:59'   
                   AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                   ORDER BY hrby06)
                  where  rownum = '1' 
              IF  cl_null(l_btime) THEN 
                 SELECT  hrby06 INTO l_btime FROM (SELECT hrby06 FROM hrby_file
                  WHERE  hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  '00:00' AND l_hrcma.hrcma07  
                    AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                   ORDER BY hrby06)
                  where  rownum = '1' 
              END IF     
            ELSE 
               SELECT  hrby06 INTO l_btime FROM (SELECT hrby06 FROM hrby_file  
                WHERE  hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND l_hrcma.hrcma07   
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                   ORDER BY hrby06)
                  where  rownum = '1'        
            END IF 
            IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN 
               SELECT  hrby06 INTO l_etime FROM (SELECT hrby06 FROM hrby_file  
                WHERE  hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  '00:00' AND l_hrcma.hrcma07   
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                  AND rownum = '1')
                ORDER  BY hrby06  desc 
                IF  cl_null(l_etime) THEN 
                   SELECT  hrby06 INTO l_etime FROM (SELECT hrby06 FROM hrby_file  
                    WHERE  hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05  AND '23:59'  
                      AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                   ORDER BY hrby06 desc)
                  where  rownum = '1'            
                END IF          
            ELSE             
               SELECT  hrby06 INTO l_etime FROM (SELECT hrby06 FROM hrby_file  
                WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND l_hrcma.hrcma07   
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                   ORDER BY hrby06 desc)
                  where  rownum = '1' 
            END IF               
            IF l_hrcl_file.hrcl06 = 'Y' AND  l_hrcl_file.hrcl08 = 'Y' THEN
               IF l_a > 0 AND l_b > 0 THEN 
                  IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                     CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                     CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2
                     LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2 + l_em + l_bm
                     LET l_hrcn13 = 0
                     LET l_hrcn12 = 0                   
                  ELSE   
                     CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_hrcn08
                     LET l_hrcn08 = l_hrcn08 + l_em + l_bm
                     LET l_hrcn13 = 0
                     LET l_hrcn12 = 0  
                  END IF    
               END IF    
               IF l_a > 0 AND l_b = 0 THEN
                  IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                     CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                     CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2 
                     LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2 + l_bm
                     LET l_hrcn13 = 0
                     LET l_hrcn07 = l_etime
                     CALL i054_1_mi(l_hrcma.hrcma07,l_etime)RETURNING l_hrcn12
                  ELSE    
                     CALL i054_1_mi(l_etime,l_hrcma.hrcma05)RETURNING l_hrcn08
                     LET l_hrcn08 = l_hrcn08 + l_bm
                     LET l_hrcn13 = 0
                     LET l_hrcn07 = l_etime
                     CALL i054_1_mi(l_hrcma.hrcma07,l_etime)RETURNING l_hrcn12
                  END IF     
               END IF 
               IF l_a = 0 AND l_b > 0 THEN 
                  IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                     CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                     CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2 
                     LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2 + l_em
                     LET l_hrcn12 = 0
                     LET l_hrcn05 = l_btime
                     CALL i054_1_mi(l_btime,l_hrcma.hrcma05)RETURNING l_hrcn13 
                  ELSE    
                     CALL i054_1_mi(l_hrcma.hrcma07,l_btime)RETURNING l_hrcn08
                     LET l_hrcn08 = l_hrcn08 + l_em
                     LET l_hrcn12 = 0
                     LET l_hrcn05 = l_btime
                     CALL i054_1_mi(l_btime,l_hrcma.hrcma05)RETURNING l_hrcn13  
                  END IF              
               END IF 
               IF l_a = 0 AND l_b = 0 THEN
                  IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                     CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                     CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2 
                     LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2 
                     LET l_hrcn05 = l_btime
                     LET l_hrcn07 = l_etime
                     CALL i054_1_mi(l_btime,l_hrcma.hrcma05)RETURNING l_hrcn13  
                     CALL i054_1_mi(l_hrcma.hrcma07,l_etime)RETURNING l_hrcn12
                  ELSE    
                     CALL i054_1_mi(l_etime,l_btime)RETURNING l_hrcn08
                     LET l_hrcn05 = l_btime
                     LET l_hrcn07 = l_etime
                     CALL i054_1_mi(l_btime,l_hrcma.hrcma05)RETURNING l_hrcn13  
                     CALL i054_1_mi(l_hrcma.hrcma07,l_etime)RETURNING l_hrcn12
                  END IF 
               END IF 
            END IF                
            IF l_hrcl_file.hrcl06 = 'Y' AND  l_hrcl_file.hrcl08 = 'N' THEN
               IF l_a > 0 THEN 
                  IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                     CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                     CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2 
                     LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2 + l_bm
                     LET l_hrcn13 = 0
                     LET l_hrcn12 = 0 
                     LET l_hrcn07 = l_hrcma.hrcma07 
                  ELSE    
                     CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_hrcn08
                     LET l_hrcn08 = l_hrcn08 + l_bm
                     LET l_hrcn13 = 0
                     LET l_hrcn12 = 0 
                     LET l_hrcn07 = l_hrcma.hrcma07 
                  END IF             
               ELSE
               	 IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                     CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                     CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2 
                     LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2
                     CALL i054_1_mi(l_btime,l_hrcma.hrcma05)RETURNING l_hrcn13 
                     LET l_hrcn12 = 0  
                     LET l_hrcn05 = l_btime
                     LET l_hrcn07 = l_hrcma.hrcma07 
                  ELSE    
                     CALL i054_1_mi(l_hrcma.hrcma07,l_btime)RETURNING l_hrcn08
                     CALL i054_1_mi(l_btime,l_hrcma.hrcma05)RETURNING l_hrcn13 
                     LET l_hrcn12 = 0  
                     LET l_hrcn05 = l_btime
                     LET l_hrcn07 = l_hrcma.hrcma07 
                  END IF              
               END IF 	          
            END IF 
            IF l_hrcl_file.hrcl06 = 'N' AND  l_hrcl_file.hrcl08 = 'Y' THEN
               IF l_b > 0 THEN 
               	 IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                     CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                     CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2 
                     LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2 + l_em
                     LET l_hrcn13 = 0
                     LET l_hrcn12 = 0
                     LET l_hrcn05 = l_hrcma.hrcma05
                  ELSE                
                     CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_hrcn08
                     LET l_hrcn08 = l_hrcn08 + l_em
                     LET l_hrcn13 = 0
                     LET l_hrcn12 = 0
                     LET l_hrcn05 = l_hrcma.hrcma05
                  END IF 
               ELSE
               	 IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                     CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                     CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2 
                     LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2
                     CALL i054_1_mi(l_hrcma.hrcma07,l_etime)RETURNING l_hrcn12 
                     LET l_hrcn13 = 0                
                     LET l_hrcn05 = l_hrcma.hrcma05
                     LET l_hrcn07 = l_etime                   
                  ELSE                	
                     CALL i054_1_mi(l_etime,l_hrcma.hrcma05)RETURNING l_hrcn08
                     CALL i054_1_mi(l_hrcma.hrcma07,l_etime)RETURNING l_hrcn12 
                     LET l_hrcn13 = 0                
                     LET l_hrcn05 = l_hrcma.hrcma05
                     LET l_hrcn07 = l_etime 
                  END IF 
               END IF
            END IF 
            IF (l_hrcl_file.hrcl06 = 'N' AND  l_hrcl_file.hrcl08 = 'N') OR  l_hrcl_file.hrcl05 = 'Y' THEN 
               IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
                  CALL i054_1_mi(l_hrcma.hrcma07,'00:00')RETURNING l_hrcn08_1
                  CALL i054_1_mi('23:59',l_hrcma.hrcma05)RETURNING l_hrcn08_2 
                  LET l_hrcn08 = l_hrcn08_1 + l_hrcn08_2
                  LET l_hrcn13 = 0
                  LET l_hrcn12 = 0 
                  LET l_hrcn05 = l_hrcma.hrcma05
                  LET l_hrcn07 = l_hrcma.hrcma07                
               ELSE    
                  CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_hrcn08
                  LET l_hrcn13 = 0
                  LET l_hrcn12 = 0 
                  LET l_hrcn05 = l_hrcma.hrcma05
                  LET l_hrcn07 = l_hrcma.hrcma07 
               END IF 
            END IF  
#add by z   huzw 20140916 加班减去就餐时间段 star
            IF l_hrcma.hrcma04 != l_hrcma.hrcma06 THEN
               LET l_sql = " SELECT hrboa_file.* FROM hrboa_file                                                                               ",   
                          "  LEFT JOIN hrbo_file on hrbo02 = hrboa15                                                                         ",
                          "  WHERE  hrboa08 = '002' AND hrboa15 =                                                             ",
                          "  (SELECT MAX(NVL(TRIM(b.hrcp04),NVL(d.hrdq06,NVL(e.hrdq06,NVL(f.hrdq06,g.hrdq06)))))                             ",
                          "  FROM hrat_file a                                                                                                ",
                          "  LEFT JOIN hrcp_file b ON b.hrcp02 = a.hratid AND b.hrcp03 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  LEFT JOIN hrcb_file c ON c.hrcb05 = a.hratid AND to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd') BETWEEN c.hrcb06 AND c.hrcb07   ",
                          "  LEFT JOIN hrdq_file d ON d.hrdq03 = a.hratid AND d.hrdq05 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  LEFT JOIN hrdq_file e ON e.hrdq03 = c.hrcb01 AND e.hrdq05 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  LEFT JOIN hrdq_file f ON f.hrdq03 = a.hrat03 AND f.hrdq05 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  LEFT JOIN hrdq_file g ON g.hrdq03 = a.hrat04 AND g.hrdq05 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  WHERE hratid = '",l_hrcma.hratid,"') ORDER BY hrboa05 "  
               PREPARE i054_bj_bc_q1 FROM l_sql
               EXECUTE i054_bj_bc_q1 INTO l_hrboa.*
               IF SQLCA.SQLCODE = 0 THEN 
                  IF l_hrboa.hrboa05 <= l_hrcn05  THEN 
                     LET l_jcsj = 0
                  END IF 
                  IF l_hrboa.hrboa02 >= l_hrcn05 AND  l_hrboa.hrboa05 <= '23:59' THEN 
                     LET l_jcsj = l_hrboa.hrboa11
                  END IF 
                  IF l_hrboa.hrboa02 < l_hrcn05 AND  l_hrboa.hrboa05 > l_hrcn05 AND l_hrboa.hrboa05 <= '23:59' THEN
                     CALL i054_1_mi(l_hrboa.hrboa05,l_hrcn05)RETURNING l_jcsj
                  END IF 
                  IF l_hrboa.hrboa02 < l_hrcn07 AND l_hrboa.hrboa02 > l_hrcn05  THEN
                     CALL i054_1_mi('23:59',l_hrboa.hrboa02)RETURNING l_jcsj
                  END IF 
                  IF   l_jcsj= l_hrboa.hrboa11 THEN          
                     LET  l_hrcn08 = l_hrcn08 - l_jcsj
                  END IF 
               END IF
               IF SQLCA.SQLCODE = 100 THEN 
                  LET l_sql = " SELECT hrboa_file.* FROM hrboa_file                                                                               ",   
                             "  LEFT JOIN hrbo_file on hrbo02 = hrboa15                                                                         ",
                             "  WHERE hrboa08 = '002' AND hrboa15 =                                                             ",
                             "  (SELECT MAX(NVL(TRIM(b.hrcp04),NVL(d.hrdq06,NVL(e.hrdq06,NVL(f.hrdq06,g.hrdq06)))))                             ",
                             "  FROM hrat_file a                                                                                                ",
                             "  LEFT JOIN hrcp_file b ON b.hrcp02 = a.hratid AND b.hrcp03 = to_date('",l_hrcma.hrcma06,"','yyyy-mm-dd')                      ",
                             "  LEFT JOIN hrcb_file c ON c.hrcb05 = a.hratid AND to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd') BETWEEN c.hrcb06 AND c.hrcb07   ",
                             "  LEFT JOIN hrdq_file d ON d.hrdq03 = a.hratid AND d.hrdq05 = to_date('",l_hrcma.hrcma06,"','yyyy-mm-dd')                      ",
                             "  LEFT JOIN hrdq_file e ON e.hrdq03 = c.hrcb01 AND e.hrdq05 = to_date('",l_hrcma.hrcma06,"','yyyy-mm-dd')                      ",
                             "  LEFT JOIN hrdq_file f ON f.hrdq03 = a.hrat03 AND f.hrdq05 = to_date('",l_hrcma.hrcma06,"','yyyy-mm-dd')                      ",
                             "  LEFT JOIN hrdq_file g ON g.hrdq03 = a.hrat04 AND g.hrdq05 = to_date('",l_hrcma.hrcma06,"','yyyy-mm-dd')                      ",
                             "  WHERE hratid = '",l_hrcma.hratid,"') ORDER BY hrboa05 "  
                  PREPARE i054_bj_bc_q2 FROM l_sql
                  EXECUTE i054_bj_bc_q2 INTO l_hrboa.*
                  IF SQLCA.SQLCODE = 0 THEN 
                     IF  l_hrboa.hrboa02 >= l_hrcn07 THEN 
                        LET l_jcsj = 0
                     END IF 
                     IF l_hrboa.hrboa02 >= '00:00' AND  l_hrboa.hrboa05 <= l_hrcn07 THEN 
                        LET l_jcsj = l_hrboa.hrboa11
                     END IF 
                     IF l_hrboa.hrboa05 > '00:00' AND l_hrboa.hrboa05 <= l_hrcn07 THEN
                        CALL i054_1_mi(l_hrboa.hrboa05,'00:00')RETURNING l_jcsj
                     END IF 
                     IF l_hrboa.hrboa02 < l_hrcn07 AND l_hrboa.hrboa02 > '00:00' AND  l_hrboa.hrboa05 > l_hrcn07 THEN
                        CALL i054_1_mi(l_hrcn07,l_hrboa.hrboa02)RETURNING l_jcsj
                     END IF            
                     IF   l_jcsj= l_hrboa.hrboa11 THEN          
                        LET  l_hrcn08 = l_hrcn08 - l_jcsj
                     END IF 
                  END IF
               END IF                 
            ELSE
            	  LET l_sql = " SELECT hrboa_file.* FROM hrboa_file                                                                               ",   
                          "  LEFT JOIN hrbo_file on hrbo02 = hrboa15                                                                         ",
                          "  WHERE  hrboa08 = '002' AND hrboa15 =                                                             ",
                          "  (SELECT MAX(NVL(TRIM(b.hrcp04),NVL(d.hrdq06,NVL(e.hrdq06,NVL(f.hrdq06,g.hrdq06)))))                             ",
                          "  FROM hrat_file a                                                                                                ",
                          "  LEFT JOIN hrcp_file b ON b.hrcp02 = a.hratid AND b.hrcp03 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  LEFT JOIN hrcb_file c ON c.hrcb05 = a.hratid AND to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd') BETWEEN c.hrcb06 AND c.hrcb07   ",
                          "  LEFT JOIN hrdq_file d ON d.hrdq03 = a.hratid AND d.hrdq05 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  LEFT JOIN hrdq_file e ON e.hrdq03 = c.hrcb01 AND e.hrdq05 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  LEFT JOIN hrdq_file f ON f.hrdq03 = a.hrat03 AND f.hrdq05 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  LEFT JOIN hrdq_file g ON g.hrdq03 = a.hrat04 AND g.hrdq05 = to_date('",l_hrcma.hrcma04,"','yyyy-mm-dd')                      ",
                          "  WHERE hratid = '",l_hrcma.hratid,"') ORDER BY hrboa05 "  
               PREPARE i054_bj_bc_q FROM l_sql
               EXECUTE i054_bj_bc_q INTO l_hrboa.* 
               IF SQLCA.SQLCODE = 0 THEN             
                  #add by zhuzw 20150323 start
                  LET l_hrcn05_1 = l_hrcn05
                  LET l_hrcn07_2 = l_hrcn07
                  IF l_hrcl_file.hrcl10 = 'N' AND l_hrcma.hrcma05 > l_hrcn05 THEN 
                     LET l_hrcn05_1 = l_hrcma.hrcma05                     
                  END IF    
                  IF l_hrcl_file.hrcl12 = 'N' AND l_hrcma.hrcma07 < l_hrcn07 THEN 
                     LET l_hrcn07_2 = l_hrcma.hrcma07                    
                  END IF  
                   #add by zhuzw 20150323 end
                  IF l_hrboa.hrboa05 <= l_hrcn05_1 OR l_hrboa.hrboa02 >= l_hrcn07_2 THEN 
                     LET l_jcsj = 0
                  END IF 
                  IF l_hrboa.hrboa02 >= l_hrcn05_1 AND  l_hrboa.hrboa05 <= l_hrcn07_2 THEN 
                     LET l_jcsj = l_hrboa.hrboa11
                  END IF 
                  IF l_hrboa.hrboa02 < l_hrcn05_1 AND  l_hrboa.hrboa05 > l_hrcn05_1 AND l_hrboa.hrboa05 <= l_hrcn07_2 THEN
                     CALL i054_1_mi(l_hrboa.hrboa05,l_hrcn05_1)RETURNING l_jcsj
                  END IF
                  
                  IF l_hrboa.hrboa02 <= l_hrcn05_1 AND l_hrboa.hrboa05 >= l_hrcn07_2 THEN
                     CONTINUE FOREACH 
                  END IF 
                  IF l_hrboa.hrboa02 < l_hrcn07_2 AND l_hrboa.hrboa02 > l_hrcn05_1 AND  l_hrboa.hrboa05 > l_hrcn07_2 THEN
                     CALL i054_1_mi(l_hrcn07_2,l_hrboa.hrboa02)RETURNING l_jcsj
                  END IF            
                  SELECT max(hrboa02) INTO l_hrboa02 FROM hrboa_file                                                                               
                               LEFT JOIN hrbo_file on hrbo02 = hrboa15                                                                         
                               WHERE hrboa08 != '002' AND hrboa15 =                                                             
                               (SELECT MAX(NVL(TRIM(b.hrcp04),NVL(d.hrdq06,NVL(e.hrdq06,NVL(f.hrdq06,g.hrdq06)))))                             
                               FROM hrat_file a                                                                                                
                               LEFT JOIN hrcp_file b ON b.hrcp02 = a.hratid AND b.hrcp03 = to_date(l_hrcma.hrcma04,'yyyy-mm-dd')                      
                               LEFT JOIN hrcb_file c ON c.hrcb05 = a.hratid AND to_date(l_hrcma.hrcma04,'yyyy-mm-dd') BETWEEN c.hrcb06 AND c.hrcb07   
                               LEFT JOIN hrdq_file d ON d.hrdq03 = a.hratid AND d.hrdq05 = to_date(l_hrcma.hrcma04,'yyyy-mm-dd')                      
                               LEFT JOIN hrdq_file e ON e.hrdq03 = c.hrcb01 AND e.hrdq05 = to_date(l_hrcma.hrcma04,'yyyy-mm-dd')                      
                               LEFT JOIN hrdq_file f ON f.hrdq03 = a.hrat03 AND f.hrdq05 = to_date(l_hrcma.hrcma04,'yyyy-mm-dd')                      
                               LEFT JOIN hrdq_file g ON g.hrdq03 = a.hrat04 AND g.hrdq05 = to_date(l_hrcma.hrcma04,'yyyy-mm-dd')                      
                               WHERE hratid = l_hrcma.hratid ) ORDER BY hrboa05 
                  IF l_hrboa02 <= l_hrcn07_2 THEN 
                     #IF   l_jcsj= l_hrboa.hrboa11 THEN          
                        LET  l_hrcn08 = l_hrcn08 - l_jcsj
                    # END IF 
                  END IF 
               END IF        
            END IF
         END IF            
#add by zhuzw 20140916 加班减去就餐时间段 end                                    
      END IF 
#add by zhuzw 20140912 圣奥修改处理逻辑段 end       
      IF l_hrbtud02 = '001' THEN 
         LET l_bm = 0
         LET l_c = 0
         SELECT COUNT(*) INTO l_d FROM hrby_file  
          WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND l_hrcma.hrcma07  
            AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'    
         SELECT COUNT(*) INTO l_a FROM hrby_file
          	WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND l_hrcma.hrcma05  
            AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'                    
         IF l_a >0 AND l_hrcl_file.hrcl06 = 'Y' THEN                     
            SELECT hrby10,hrby06 INTO l_hrby10,p_time FROM hrby_file  
            WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma05 AND l_hrcma.hrcma05  
              AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
              AND rownum = '1'
              ORDER BY hrby06 desc
              IF l_hrby10 ='2' THEN 
                 LET l_c = 1                 
                 SELECT hrby10 INTO l_hrby10_1 FROM hrby_file  
                  WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND l_hrcma.hrcma07  
                    AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                    AND rownum = '1'
                  ORDER BY hrby06   
                 SELECT  hrby10,hrby06 INTO l_hrby10_2 FROM hrby_file  
                  WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND l_hrcma07   
                    AND hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                    AND rownum = '1'
                   ORDER BY hrby06  
                  IF l_hrby10_1 = '3' OR (l_hrby10_2 = '3' AND l_d = 0)  THEN 
                     CALL i054_1_mi(l_hrcma.hrcma05,p_time) RETURNING l_bm
                     IF l_bm <  l_hrcl_file.hrcl11 OR  l_hrcl_file.hrcl10 = 'N' THEN 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_1_c11 FROM l_sql
                        EXECUTE i054_1_c11 INTO l_hrcn05 
                        LET l_bm = 0                    
                     ELSE   
                        IF l_hrcl_file.hrcl10 = 'Y' THEN  
                           SELECT  l_bm - mod(l_bm,l_hrcl_file.hrcl11) INTO l_bm FROM  dual 
                           LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma05,"','hh24:mi') - interval '",l_bm,"' minute,'hh24:mi')  FROM  dual "
                           PREPARE i054_1_c21 FROM l_sql
                           EXECUTE i054_1_c21 INTO l_hrcn05
                        END IF 
                     END IF                                          
                	END IF                              	    
              END IF      
         END IF               
         IF l_a = 0 AND l_d = 0 AND l_hrcl_file.hrcl06 = 'Y' THEN 
            CONTINUE FOREACH #没有合适的考勤数据
         END IF          
         LET l_em = 0  
         SELECT COUNT(*) INTO l_b FROM hrby_file  
          WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND l_hrcma07  
            AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
         IF l_b > 0 AND l_hrcl_file.hrcl08 = 'Y' THEN                      
            SELECT  hrby10,hrby06 INTO l_hrby10_2,p_time FROM hrby_file  
            WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma07 AND l_hrcma07   
              AND hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
              AND rownum = '1'
              ORDER BY hrby06 
            LET l_e = 0    
            IF l_hrby10_2 = '3' THEN 
               LET l_e = 1
               SELECT hrby10 INTO l_hrby10_3 FROM hrby_file  
                WHERE hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  l_hrcma.hrcma05 AND l_hrcma.hrcma07  
                  AND  hrby09 = l_hrcma.hratid and hrby11= '1' and hrbyacti = 'Y'
                  AND rownum = '1'
                ORDER BY hrby06 desc
               IF l_hrby10_3 = '2' OR (l_d = 0 AND l_hrby10 = '2') THEN 
                  CALL i054_1_mi(p_time,l_hrcma.hrcma07) RETURNING l_em   
                  IF l_em <  l_hrcl_file.hrcl13 OR  l_hrcl_file.hrcl12 = 'N'  THEN 
                     LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                     PREPARE i054_1_c31 FROM l_sql
                     EXECUTE i054_1_c31 INTO l_hrcn07
                     LET l_em = 0                    
                  ELSE   
                  	 IF l_hrcl_file.hrcl12 = 'Y' THEN 
                        SELECT  l_em - mod(l_em,l_hrcl_file.hrcl13) INTO l_em FROM  dual 
                        LET l_sql = " SELECT  to_char(to_date('",l_hrcma.hrcma07,"','hh24:mi') + interval '",l_em,"' minute,'hh24:mi')  FROM  dual "
                        PREPARE i054_1_c41 FROM l_sql
                        EXECUTE i054_1_c41 INTO l_hrcn07
                     END IF 
                  END IF 
               END IF    
            END IF         
         END IF  
         IF  l_d = 0  AND l_b = 0 AND l_hrcl_file.hrcl08 = 'Y' THEN 
         	  CONTINUE FOREACH #没有合适的考勤数据
         END IF  
         IF l_hrcma.hrcma04 = l_hrcma.hrcma06  THEN  
            LET l_sql = " SELECT * FROM hrby_file ",
                        "  WHERE hrby05 = '",l_hrcma.hrcma04,"' AND hrby06 BETWEEN  '",l_hrcma.hrcma05 CLIPPED ,"' AND '",l_hrcma.hrcma07 CLIPPED,"'  and hrby09 = '",l_hrcma.hratid CLIPPED,"' and hrby11= '1' and hrbyacti = 'Y' ",
                        "  order by hrby05,hrby06 "
         #         ELSE 
         #            l_sql = " SELECT * FROM hrby_file ",
         #                    "  WHERE (hrby05 = l_hrcma.hrcma04 AND hrby06 BETWEEN  '",l_hrcma.hrcma05,"' AND '23:59') ",
         #         	         "     OR (hrby05 = l_hrcma.hrcma06 AND hrby06 BETWEEN  '00:00' AND '",l_hrcma.hrcma07,"')  and hrby09 = '",l_hrcma.hratid,"' and hrby11= '1' and hrbyacti = 'Y' "
         END IF 
         PREPARE i054_1_sk1 FROM l_sql
         DECLARE hrby_curs2 CURSOR FOR i054_1_sk1
         LET l_i = 1
         LET l_m = 0
         LET l_n = 0
         LET l_o = 0  
         LET l_hrcn12 = 0 
         LET l_hrcn13 = 0 
         FOREACH hrby_curs2 INTO l_hrby.*
            IF l_i = 1 THEN             
               IF l_hrcl_file.hrcl06 = 'N' THEN 
                  IF l_hrby.hrby10 = '3' THEN 
                     LET l_hrcn05 = l_hrcma.hrcma05
                     LET l_hrcn07_1 = l_hrby.hrby06
                     CALL i054_1_mi(l_hrby.hrby06,l_hrcma.hrcma05) RETURNING l_n
                     LET l_o = l_o + l_n
                  ELSE 
                     LET l_time = l_hrby.hrby06
                     LET l_n = 0  
                  END IF                    
               ELSE 
               	  IF l_hrby.hrby10 = '3' THEN 
               	     IF l_c = 1 THEN 
                        LET l_hrcn07_1 = l_hrby.hrby06
                        CALL i054_1_mi(l_hrby.hrby06,l_hrcma.hrcma05) RETURNING l_n
                        LET l_o = l_o + l_n  
               	     END IF 
               	  ELSE
                     LET l_time = l_hrby.hrby06
                     LET l_n = 0               	  	    
               	  END IF 
               END IF 
            END IF 
            IF l_i >1 AND l_i < l_d THEN 
               IF l_hrby.hrby10 = l_p   THEN 
                  IF l_p = '2' THEN 
                     LET l_time = l_hrby.hrby06
                     LET l_n = 0      
                  END IF              
               ELSE
                  IF l_p = '2' THEN 
                     IF l_o = 0  THEN 
                        LET l_hrcn05 = l_time 
                        CALL i054_1_mi(l_hrby.hrby06,l_hrcma.hrcma05) RETURNING l_hrcn13
                     END IF 
                     LET l_hrcn07_1 = l_hrby.hrby06
                     CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                     LET l_o = l_o + l_n                     
                  ELSE 
                     LET l_time = l_hrby.hrby06
                     LET l_n = 0      
                  END IF                   
               END IF 	 
            END IF 
            IF l_i = l_d THEN 
               IF l_hrcl_file.hrcl08 = 'N' THEN 
                  IF l_hrby.hrby10 = '2' THEN 
                     LET l_hrcn07 = l_hrcma.hrcma07
                     CALL i054_1_mi(l_hrcma.hrcma07,l_hrby.hrby06) RETURNING l_n
                     LET l_o = l_o + l_n
                  END IF                  
               ELSE 
               	  IF l_hrby.hrby10 = '2' THEN 
               	     IF l_e = 1 THEN 
                        CALL i054_1_mi(l_hrcma.hrcma07,l_hrby.hrby06) RETURNING l_n
                        LET l_o = l_o + l_n  
               	     END IF               	  	    
               	  END IF 
               END IF               
            END IF 
            IF  cl_null(l_hrcn07) THEN 
               LET l_hrcn07 = l_hrcn07_1 
               CALL i054_1_mi(l_hrcma.hrcma07,l_hrcn07_1) RETURNING l_hrcn12
            END IF  
            LET l_p = l_hrby.hrby10
            LET l_i = l_i + 1             
         END FOREACH                                
         IF l_d = 0 AND l_a >0 AND l_b > 0 THEN 
            CALL i054_1_mi(l_hrcma.hrcma07,l_hrcma.hrcma05)RETURNING l_o 
         END IF
         LET l_hrcn08 = l_o + l_bm + l_em         
      END IF       
      #对ghri052参数判断&INSERT hrcn_file      
      SELECT hrcma10,hrcma11 INTO l_hrcma10,l_hrcma11 FROM hrcma_file 
       WHERE hrcma02 = l_hrcma.hrcm02 AND hrcma03 = l_hrcma.hratid 
         AND hrcma04 = l_hrcma.hrcma04
      IF l_hrcma11 = 'Y' THEN 
         IF cl_null(l_hrcma10) THEN 
            LET l_hrcma10 = 0 
         END IF          
         LET l_hrcn08 = l_hrcn08 - l_hrcma10*60
      END IF  
 
      IF l_hrcn08 < l_hrcl_file.hrcl19 THEN 
         CONTINUE FOREACH
      ELSE 
      	 SELECT  l_hrcn08 - mod(l_hrcn08,l_hrcl_file.hrcl20) INTO l_hrcn08 FROM  dual   
      END IF 
      IF l_hrcn08 > l_hrcma.hrcma08 * 60  AND l_hrcl_file.hrcl22 = 'Y' THEN 
         LET l_hrcn08 = l_hrcma.hrcma08*60
      END IF
      LET l_hrcn08 = l_hrcn08/60
      IF (l_hrcl_file.hrcl15 = 'Y' AND l_hrcn13 <= l_hrcl_file.hrcl16 ) OR l_hrcl_file.hrcl15 = 'N' THEN  
         LET l_hrcn13 = 0            
      END IF 
      IF (l_hrcl_file.hrcl17 = 'Y' AND l_hrcn12 <= l_hrcl_file.hrcl18 ) OR l_hrcl_file.hrcl17 = 'N' THEN  
         LET l_hrcn12 = 0            
      END IF       
      IF l_hrcl_file.hrcl25 = 'Y' THEN 
         LET l_hrcnconf = 'Y'
      ELSE 
         LET l_hrcnconf = 'N'
      END IF 
      IF l_hrcma.hrcma04 =  l_hrcma.hrcma06 THEN  
         LET  l_hrcn14 =  l_hrcma.hrcma04
      ELSE 
         CALL i054_1_hrcn14(l_hrcma.hratid,l_hrcma.hrcma04,l_hrcn05,l_hrcn07) RETURNING l_g1
         IF l_g1 = 'Y' THEN 
            LET l_hrcn14 = l_hrcma.hrcma04
         ELSE  
            LET l_hrcn14 = l_hrcma.hrcma06
         END IF 
      END IF           
      SELECT COUNT(*) INTO l_x FROM hrcn_file
       WHERE hrcn01 = l_hrcma.hrcm02 AND hrcn03 = l_hrcma.hratid AND hrcn14 = l_hrcn14 
      IF l_x  > 0 THEN 
         UPDATE hrcn_file SET hrcn04 = l_hrcma.hrcma04,hrcn05 = l_hrcn05,hrcn06 = l_hrcma.hrcma06,
                              hrcn07 = l_hrcn07,hrcn08 = l_hrcn08,hrcn09 = l_hrcma.hrcma09,
                              hrcn12 = l_hrcn12,hrcn13 = l_hrcn13,hrcn14 = l_hrcn14
          WHERE hrcn03 = l_hrcma.hratid AND hrcn01 = l_hrcma.hrcm02 AND hrcn14 = l_hrcn14 
          IF SQLCA.sqlcode THEN
          ELSE   	
         #add by zhuzw 20140925 start
          UPDATE hrcma_file SET ta_hrcma01 = 'Y'
           WHERE hrcma02 = l_hrcma.hrcm02
             AND hrcma03 = l_hrcma.hratid
             AND hrcma04 = l_hrcma.hrcma04
         #add by zhzuw 20140925 end           	
         #add by zhuzw 20140919 start #间接员工生成调休计划
            SELECT hrat21 INTO l_hrat21 FROM hrat_file 
             WHERE hratid = l_hrcma.hratid
            IF l_hrat21 = '002' THEN 
               SELECT hrcn02 INTO l_hrcn02 FROM hrcn_file
                WHERE hrcn03 = l_hrcma.hratid AND hrcn01 = l_hrcma.hrcm02  AND hrcn14 = l_hrcn14
               SELECT COUNT(*) INTO l_n FROM hrci_file
                WHERE hrci01 = l_hrcn02 AND hrci02 = l_hrcma.hratid AND hrci03 = l_hrcn14
               IF l_n = 0 THEN  
                  CALL i054_bj_txjh(l_hrcn02)
               ELSE
                  UPDATE hrci_file SET hrci05 = l_hrcn08,hrci07 = l_hrcn08,hrci09 = l_hrcn08- hrci08 
                   WHERE hrci01 =  l_hrcn02  AND hrci02 = l_hrcma.hratid AND  hrci03 = l_hrcn14
               END IF 	 
            END IF 
            #add by zhuzw 20140919 end #间接员工生成调休计划          	
             SELECT COUNT(*) INTO l_k FROM hrcp_file WHERE hrcp02 = l_hrcma.hratid AND hrcp03 = l_hrcn14
             IF l_k > 0 THEN 
              	UPDATE hrcp_file
              	   SET hrcp35 = 'N'
           	     WHERE hrcp02 = l_hrcma.hratid AND hrcp03 = l_hrcn14
             END IF   
          END IF 
              CONTINUE FOREACH
      END IF  
      SELECT COUNT(*) INTO l_n FROM hrcn_file 
      IF l_n >0 THEN 
         SELECT MAX(hrcn02) + 1 INTO l_hrcn02 FROM hrcn_file
      ELSE 
      	  LET l_hrcn02 = 1
      END IF 
           
      INSERT INTO hrcn_file (hrcn01,hrcn02,hrcn03,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn10,hrcn11,hrcn12,hrcn13,hrcnconf,hrcnacti,hrcn14)
      VALUES (l_hrcma.hrcm02,l_hrcn02,l_hrcma.hratid,l_hrcma.hrcma04,l_hrcn05,l_hrcma.hrcma06,l_hrcn07,l_hrcn08,l_hrcma.hrcma09,'N','',l_hrcn12,l_hrcn13,l_hrcnconf,'Y',l_hrcn14)            
      IF SQLCA.sqlcode THEN
      ELSE   	
         SELECT COUNT(*) INTO l_k FROM hrcp_file WHERE hrcp02 = l_hrcma.hratid AND hrcp03 = l_hrcn14
         IF l_k > 0 THEN 
          	UPDATE hrcp_file
          	   SET hrcp35 = 'N'
       	     WHERE hrcp02 = l_hrcma.hratid AND hrcp03 = l_hrcn14
         END IF
         #add by zhuzw 20140925 start
          UPDATE hrcma_file SET ta_hrcma01 = 'Y'
           WHERE hrcma02 = l_hrcma.hrcm02
             AND hrcma03 = l_hrcma.hratid
             AND hrcma04 = l_hrcma.hrcma04
         #add by zhzuw 20140925 end 
         #add by zhuzw 20140919 start #间接员工生成调休计划
            SELECT hrat21 INTO l_hrat21 FROM hrat_file 
             WHERE hratid = l_hrcma.hratid
            IF l_hrat21 = '002' THEN 
               SELECT hrcn02 INTO l_hrcn02 FROM hrcn_file
                WHERE hrcn03 = l_hrcma.hratid AND hrcn01 = l_hrcma.hrcm02 AND hrcn14 = l_hrcn14
               SELECT COUNT(*) INTO l_n FROM hrci_file
                WHERE hrci01 = l_hrcn02 AND hrci02 = l_hrcma.hratid AND hrci03 = l_hrcn14
               IF l_n = 0 THEN  
                  CALL i054_bj_txjh(l_hrcn02)
               ELSE
                  UPDATE hrci_file SET hrci05 = l_hrcn08,hrci07 = l_hrcn08,hrci09 = l_hrcn08- hrci08 
                   WHERE hrci01 =  l_hrcn02  AND hrci02 = l_hrcma.hratid AND  hrci03 = l_hrcn14
               END IF 	 
            END IF 
            #add by zhuzw 20140919 end #间接员工生成调休计划 
      END IF 
   END FOREACH             
   DROP TABLE hrcma_tmp
END FUNCTION 
FUNCTION i054_1_b_askkey()
DEFINE 
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5, 
    l_i             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_hratid        LIKE hrat_file.hratid 
    CLEAR FORM
    CALL g_hrcma.clear()

    CONSTRUCT g_wc2 ON hrcm02,hrat01,hrcma04,hrcma06,hrcma08,hrcma09
         FROM s_hrcma[1].hrcm02,s_hrcma[1].hrat01,
              s_hrcma[1].hrcma04,s_hrcma[1].hrcma06,s_hrcma[1].hrcma08,
              s_hrcma[1].hrcma09
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE WHEN INFIELD(hrat01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_hrat"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_hrcma[1].hrat01
              WHEN INFIELD(hrcma09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "g_hrbm03"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_hrcma[1].hrcma09
              WHEN INFIELD(hrcm02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "g_hrcm02"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_hrcma[1].hrcm02                                      
              OTHERWISE
                   EXIT CASE
         END CASE
       
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help() 
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    CALL i054_1_b_fill(g_wc2)    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
    CALL i054_1_tmp()
    CALL cl_set_comp_entry("hrcm02,hrcm03,hrat01,hrat02,hrat04_name,hrat05_name,hrcm03,hrcma04,hrcma05,hrcma06,hrcma07,hrcma08,hrcma09,hrcma09_name ",FALSE)
    INPUT ARRAY g_hrcma  WITHOUT DEFAULTS FROM s_hrcma.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,  UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
        CALL cl_set_act_visible("accept,cancel",TRUE)		
       	
    BEFORE ROW
        LET l_ac = ARR_CURR()
        LET l_n  = ARR_COUNT()    	
      ON ACTION sel_all
         LET g_action_choice="sel_all" 
         LET l_i = 0        	
         FOR l_i = 1 TO g_rec_b
             LET g_hrcma[l_i].sel = 'Y'
         END FOR  
      ON ACTION sel_none
         LET g_action_choice="sel_none"   
         LET l_i = 0     	
         FOR l_i = 1 TO g_rec_b
             LET g_hrcma[l_i].sel = 'N'
         END FOR
      ON ACTION accept
         LET l_i = 0
         FOR l_i = 1 TO g_rec_b
             IF  g_hrcma[l_i].sel = 'Y' THEN 
                SELECT hratid INTO l_hratid FROM hrat_file 
                 WHERE hrat01 = g_hrcma[l_i].hrat01
                INSERT INTO hrcma_tmp VALUES (g_hrcma[l_i].hrcm02,l_hratid,g_hrcma[l_i].hrcma04,g_hrcma[l_i].hrcma05,g_hrcma[l_i].hrcma06,g_hrcma[l_i].hrcma07,g_hrcma[l_i].hrcma08,g_hrcma[l_i].hrcma09)
             END IF     
         END FOR 
         EXIT INPUT 
                                 
     END INPUT 
END FUNCTION

FUNCTION i054_1_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hrcma03 LIKE hrcn_file.hrcn03
    DEFINE p_wc2           STRING
    LET g_flag = 1
    LET g_sql = "SELECT 'N',hrcm02,hrcm03,hrat01,hrat02,'','',hrcma15,hrcma04,hrcma05,hrcma06,hrcma07,hrcma08,hrcma09,'' ",
                " FROM hrcm_file,hrcma_file,hrat_file ",
                " WHERE hrcma03 = hratid  AND hrcmconf ='Y' ",
                "   AND hrcma04 < to_date('",g_today,"','yyyy/mm/dd')",
                "   AND hrcma02 = hrcm02  AND hrcm05 = 'Y' ",
                "   AND ", p_wc2 CLIPPED,           #單身
                " ORDER BY hrcm02 " 

    PREPARE i054_1_pb FROM g_sql
    DECLARE hrcm_curs CURSOR FOR i054_1_pb

    CALL g_hrcma.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrcm_curs INTO g_hrcma[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT hrao02 INTO g_hrcma[g_cnt].hrat04_name FROM hrao_file,hrat_file
         WHERE hrat01= g_hrcma[g_cnt].hrat01 
           AND hrat04 = hrao01
        SELECT hras04 INTO g_hrcma[g_cnt].hrat05_name FROM hras_file,hrat_file
         WHERE hrat01= g_hrcma[g_cnt].hrat01 
           AND hrat05 = hras01
        SELECT hrbm04 INTO  g_hrcma[g_cnt].hrcma09_name  FROM hrbm_file
         WHERE hrbm03 = g_hrcma[g_cnt].hrcma09           
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcma.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
     
END FUNCTION                                                                                                                                                         
FUNCTION i054_1_tmp()
   CREATE TEMP TABLE hrcma_tmp
   (
    hrcm02            VARCHAR(20),
    hrcma03           VARCHAR(20),
    hrcma04           DATE,
    hrcma05           VARCHAR(5),
    hrcma06           DATE,
    hrcma07           VARCHAR(5), 
    hrcma08           DEC(15,2),
    hrcma09           VARCHAR(20)    
    )
END FUNCTION 
FUNCTION i054_1_hrcl(p_hratid,p_hrcma09)
DEFINE p_hratid  LIKE hrat_file.hratid
DEFINE p_hrcma09 LIKE hrcma_file.hrcma09
DEFINE l_hrat03  LIKE hrat_file.hrat03
DEFINE l_hrat04  LIKE hrat_file.hrat04
DEFINE l_hrcl_file RECORD LIKE hrcl_file.*
DEFINE l_n1,l_n      LIKE type_file.num5
      LET l_n = 0 
      SELECT hrat03,hrat04 INTO l_hrat03,l_hrat04  FROM hrat_file
       WHERE hratid =  p_hratid
      SELECT COUNT(*) INTO l_n FROM hrcl_file 
       WHERE hrcl04 = p_hrcma09
       IF l_n = 0 THEN 
          SELECT COUNT(*) INTO l_n1 FROM hrcl_file
           WHERE hrcl02 = l_hrat03
             AND hrcl03 = l_hrat04
             AND hrcl04  IS NULL 
          IF l_n1 > 0 THEN
             SELECT * INTO l_hrcl_file.* FROM hrcl_file 
              WHERE hrcl02 = l_hrat03
                AND hrcl03 = l_hrat04
                AND hrcl04  IS NULL 
             RETURN l_hrcl_file.*,'Y'   
          ELSE 
             SELECT COUNT(*) INTO l_n1 FROM hrcl_file
              WHERE hrcl02 = l_hrat03
                AND hrcl03  IS NULL
                AND hrcl04  IS NULL
             IF l_n1 > 0 THEN
                SELECT * INTO l_hrcl_file.* FROM hrcl_file 
                 WHERE hrcl02 = l_hrat03
                   AND hrcl03  IS NULL
                   AND hrcl04  IS NULL
                RETURN l_hrcl_file.*,'Y'   
             ELSE 
                SELECT COUNT(*) INTO l_n1 FROM hrcl_file
                 WHERE hrcl02  IS NULL
                   AND hrcl03  IS NULL
                   AND hrcl04  IS NULL
                IF l_n1 > 0 THEN
                   SELECT * INTO l_hrcl_file.* FROM hrcl_file 
                    WHERE hrcl02  IS NULL
                      AND hrcl03  IS NULL
                      AND hrcl04  IS NULL
                   RETURN l_hrcl_file.*,'Y'   
                ELSE  
                   RETURN l_hrcl_file.*,'N'
                END IF 	            	
             END IF 	
          END IF 	
       ELSE 
          SELECT COUNT(*) INTO l_n1 FROM hrcl_file
           WHERE hrcl02 = l_hrat03
             AND hrcl03 = l_hrat04
             AND hrcl04 = p_hrcma09
          IF l_n1 > 0 THEN
             SELECT * INTO l_hrcl_file.* FROM hrcl_file 
              WHERE hrcl02 = l_hrat03
                AND hrcl03 = l_hrat04
                AND hrcl04 = p_hrcma09 
             RETURN l_hrcl_file.*,'Y'   
          ELSE    
             SELECT COUNT(*) INTO l_n1 FROM hrcl_file
              WHERE hrcl02 = l_hrat03
                AND hrcl03  IS NULL
                AND hrcl04 = p_hrcma09 
             IF l_n1 > 0 THEN 
                SELECT * INTO l_hrcl_file.* FROM hrcl_file 
                 WHERE hrcl02 = l_hrat03
                   AND hrcl03  IS NULL
                   AND hrcl04 = p_hrcma09 
                RETURN l_hrcl_file.*,'Y' 
             ELSE   
                SELECT COUNT(*) INTO l_n1 FROM hrcl_file
                 WHERE hrcl02  IS NULL
                   AND hrcl03  IS NULL
                   AND hrcl04 = p_hrcma09 
                IF l_n1 > 0 THEN 
                   SELECT * INTO l_hrcl_file.* FROM hrcl_file 
                    WHERE hrcl02  IS NULL
                      AND hrcl03  IS NULL
                      AND hrcl04 = p_hrcma09 
                   RETURN l_hrcl_file.*,'Y' 
                ELSE   
                	 RETURN l_hrcl_file.*,'N'          
                END IF              	           
             END IF 
          END IF    
       END IF    
END FUNCTION 

FUNCTION i054_1_mi(p_btime,p_etime)
DEFINE p_btime,p_etime  LIKE type_file.chr5
DEFINE l_a,l_b,l_c          LIKE type_file.num5
   LET l_a = p_btime[1,2] * 60 + p_btime[4,5]
   LET l_b = p_etime[1,2] * 60 + p_etime[4,5]
   LET l_c = l_a - l_b
   IF l_c < 0 THEN 
      LET l_c = l_a + 1440 - l_b      
   END IF 
   RETURN l_c
END FUNCTION
 
FUNCTION i054_1_hrcn14(p_hratid,p_date,p_hrcn05,p_hrcn07)
DEFINE p_hratid  LIKE hrat_file.hratid
DEFINE p_date    LIKE type_file.dat
DEFINE l_hrboa02,l_hrboa05 LIKE hrboa_file.hrboa05
DEFINE p_hrcn05,p_hrcn07,l_hrboa04,l_hrboa07,l_btime,l_etime LIKE hrcn_file.hrcn05
DEFINE l_sql STRING
DEFINE l_hrcp04 LIKE hrcp_file.hrcp04
DEFINE l_hrboa01,l_hrboa01_1  LIKE hrboa_file.hrboa01 #add by zhuzw 20150430
   SELECT  hrcp04 INTO l_hrcp04 FROM hrcp_file WHERE hrcp02 = p_hratid AND hrcp03 = p_date
   IF cl_null(l_hrcp04) THEN 
      RETURN  'Y'
   END IF 
   #add by zhuzw 20150430 str
   SELECT MIN(hrboa01),MAX(hrboa01) INTO  l_hrboa01,l_hrboa01_1 FROM hrcp_file,hrboa_file
    WHERE hrcp02 = p_hratid AND hrcp03 = p_date 
      AND hrboa15 = hrcp04  # and hrboa03 = 'Y' 
   #add by zhuzw 20150430 end       
   SELECT hrboa02,hrboa04 INTO l_hrboa02,l_hrboa04 FROM hrcp_file,hrboa_file
    WHERE hrcp02 = p_hratid AND hrcp03 = p_date 
      AND hrboa15 = hrcp04  AND hrboa01 = l_hrboa01        
   SELECT hrboa05,hrboa07 INTO  l_hrboa05,l_hrboa07 FROM hrcp_file,hrboa_file
     WHERE hrcp02 = p_hratid AND hrcp03 = p_date
      AND hrboa15 = hrcp04 AND hrboa01 = l_hrboa01_1
   LET l_sql = " SELECT  to_char(to_date('",l_hrboa02,"','hh24:mi') - interval '",l_hrboa04,"' minute,'hh24:mi') FROM dual "
   PREPARE i054_1_14_1 FROM l_sql
   EXECUTE i054_1_14_1 INTO l_btime    
   LET l_sql = " SELECT  to_char(to_date('",l_hrboa05,"','hh24:mi') + interval '",l_hrboa07,"' minute,'hh24:mi') FROM dual "
   PREPARE i054_1_14_2 FROM l_sql
   EXECUTE i054_1_14_2 INTO l_etime
   IF p_hrcn05 >= l_btime AND  p_hrcn05 <= l_etime THEN 
      RETURN  'Y'
   ELSE 
      IF p_hrcn07 >= l_btime AND  p_hrcn07 <= l_etime THEN 
   	     RETURN  'Y'
   	  ELSE 
   	  	 RETURN  'N'
   	  END IF 	       
   END IF 
END FUNCTION 
#add by zhuzw 20140919 start
FUNCTION i054_bj_txjh(p_hrcn02)
  DEFINE p_hrcn02   LIKE hrcn_file.hrcn02 
  DEFINE l_hrcn RECORD LIKE hrcn_file.*
  DEFINE l_hrci RECORD LIKE hrci_file.*
  DEFINE l_hrbl02 LIKE hrbl_file.hrbl02
  DEFINE l_hrat03 LIKE hrat_file.hrat03
  SELECT * INTO l_hrcn.* FROM hrcn_file
   WHERE hrcn02 = p_hrcn02
  LET l_hrci.hrci01 = p_hrcn02
  LET l_hrci.hrci02 = l_hrcn.hrcn03 
  LET l_hrci.hrci03 = l_hrcn.hrcn14
  LET l_hrci.hrci04 = l_hrcn.hrcn09
  LET l_hrci.hrci05 = l_hrcn.hrcn08
  LET l_hrci.hrci06 = 0
  LET l_hrci.hrci07 = l_hrci.hrci05
  LET l_hrci.hrci08 = 0
  LET l_hrci.hrci09 = l_hrci.hrci05
#  SELECT hrat03 INTO l_hrat03 FROM hrat_file 
#   WHERE hratid  = l_hrcn.hrcn03
  SELECT hrbl02 INTO l_hrbl02 FROM hrbl_file
   WHERE 
  hrbl06 <= l_hrci.hrci03 AND hrbl07 >= l_hrci.hrci03
  SELECT hrbl07 INTO  l_hrci.hrci10 FROM hrbl_file 
   WHERE hrbl02 = l_hrbl02 + 1   
  LET l_hrci.hrciacti ='Y'
  LET l_hrci.hrciconf ='Y' 
  INSERT INTO hrci_file VALUES (l_hrci.*)
END FUNCTION   
#add by zhuzw 20140919 end

