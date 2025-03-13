# Prog. Version..: '5.10.03-08.08.20(00009)'   
# Pattern name...: cgli054_2.4gl
# Descriptions...: 採購料件詢價維護作業
# Date & Author..: 09/03/31 By Czh 

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

#模組變數(Module Variables)   
 DEFINE tm  RECORD				 
       		wc  	  LIKE type_file.chr1000, 
          bdate    LIKE type_file.dat

              END RECORD,      
       g_sql         STRING,                       #CURSOR暫存
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  
       l_ac          LIKE type_file.num5           #目前處理的ARRAY CNT 

DEFINE p_row,p_col         LIKE type_file.num5     #
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE g_before_input_done LIKE type_file.num5     #
DEFINE g_chr               LIKE type_file.chr1     #
DEFINE g_cnt               LIKE type_file.num10    #
DEFINE g_i                 LIKE type_file.num5     #count/index for any purpose 
DEFINE g_msg               LIKE ze_file.ze03       #
DEFINE g_curs_index        LIKE type_file.num10    #
DEFINE g_row_count         LIKE type_file.num10    #總筆數  
DEFINE mi_no_ask           LIKE type_file.num5     #是否開啟指定筆視窗  
DEFINE g_argv1             LIKE pmw_file.pmw01     #
DEFINE g_argv2             STRING                  #指定執行的功能
DEFINE g_argv3             LIKE pmx_file.pmx11     #
DEFINE g_pmx11             LIKE pmx_file.pmx11     #
DEFINE l_table             STRING
DEFINE g_str               STRING
DEFINE g_flag              LIKE type_file.chr6
#主程式開始
FUNCTION i054_2(p_flag)
   DEFINE l_time   LIKE type_file.chr8             #計算被使用時間 
   DEFINE p_flag              LIKE type_file.chr6
   
   OPTIONS                               #改變一些系統預設值
      FORM LINE       FIRST + 2,         #畫面開始的位置
      MESSAGE LINE    LAST,              #訊息顯示的位置
      PROMPT LINE     LAST,              #提示訊息的位置
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間)
      RETURNING l_time
   LET p_row = 2 LET p_col = 9

   OPEN WINDOW i054_2_w AT p_row,p_col WITH FORM "ghr/42f/ghri054_2"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)   
   CALL cl_ui_init()
   LET g_flag = p_flag
   CALL i054_2_cs()
   CLOSE WINDOW i054_2_w                 #結束畫面

   CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出時間)
      RETURNING l_time

END FUNCTION 

#QBE 查詢資料
FUNCTION i054_2_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  
   CLEAR FORM 
      INPUT BY NAME tm.bdate  WITHOUT DEFAULTS
      BEFORE INPUT 
         LET tm.bdate = g_today
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            CALL cl_err('','aim-372',0)
            NEXT FIELD bdate   
         END IF
 
      AFTER INPUT
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           RETURN       
        END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    
    END INPUT
      
#      IF INT_FLAG THEN
#         RETURN
#      END IF

      CONSTRUCT BY NAME tm.wc ON hrat01
        BEFORE CONSTRUCT       
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(hrat01) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_hrat"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrat01
              NEXT FIELD hrat01                            
            END CASE
         AFTER CONSTRUCT
         IF tm.wc = " 1=1" THEN
            NEXT FIELD hrat01
         END IF 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()

      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    CALL i054_2_cl()

END FUNCTION
FUNCTION i054_2_cl()
DEFINE l_hrcp04  LIKE hrcp_file.hrcp04
DEFINE l_hrcp05  LIKE hrcp_file.hrcp05
DEFINE l_hrcb01  LIKE hrcb_file.hrcb01
DEFINE l_sql,l_sql1,l_sql2     STRING 
DEFINE l_hratid  LIKE hrat_file.hratid
DEFINE l_hrbo10  LIKE hrbo_file.hrbo10
DEFINE l_hrbob   RECORD LIKE hrbob_file.*
DEFINE l_hrby    RECORD LIKE hrby_file.*
DEFINE l_hrbtud02    LIKE hrbt_file.hrbtud02
DEFINE l_o,l_n,l_a,l_i,l_m,l_x,l_k   LIKE type_file.num5
DEFINE l_hrcn02  LIKE hrcn_file.hrcn02
DEFINE l_time,l_btime,l_hrcn05,l_hrcn07 LIKE hrcn_file.hrcn05 
DEFINE l_p       LIKE hrby_file.hrby10
DEFINE l_hrboa   RECORD 
                 hrboa01  LIKE hrboa_file.hrboa01,
                 hrboa02  LIKE hrboa_file.hrboa02,
                 hrboa03  LIKE hrboa_file.hrboa03,
                 hrboa04  LIKE hrboa_file.hrboa04,
                 hrboa05  LIKE hrboa_file.hrboa05,
                 hrboa06  LIKE hrboa_file.hrboa06,
                 hrboa07  LIKE hrboa_file.hrboa07
                 END RECORD 
   LET l_sql = " SELECT hratid FROM hrat_file ",
               "  WHERE hratconf = 'Y' AND ",tm.wc  CLIPPED 
   PREPARE i054_2_hr FROM l_sql
   DECLARE i054_2_s  CURSOR FOR i054_2_hr   
   FOREACH i054_2_s INTO l_hratid
      #确定班次	
      #从ghri056中确定班次
      SELECT hrcp04 INTO l_hrcp04 FROM hrcp_file 
       WHERE hrcp02 = l_hratid AND hrcp03 = tm.bdate       
      IF STATUS=100 THEN            
         #从ghri084中确定班次
         SELECT hrdq06 INTO l_hrcp04 FROM hrdq_file
          WHERE hrdq03=l_hratid AND hrdq05=tm.bdate AND hrdq02='1'
         IF STATUS=100 THEN 
            SELECT hrcb01 INTO l_hrcb01 FROM hrcb_file
             WHERE hrcb05=l_hratid AND rownum=1
               AND hrcb06<=tm.bdate AND hrcb07>=tm.bdate
            IF STATUS=100 THEN 
               CALL i054_2_hrcp04(l_hratid) RETURNING l_hrcp04
            ELSE
               SELECT hrdq06 INTO l_hrcp04 FROM hrdq_file
                WHERE hrdq03=l_hrcb01 AND hrdq05=g_date AND hrdq02='4'
               IF STATUS=100 THEN 
                  CALL i054_2_hrcp04(l_hratid) RETURNING l_hrcp04
               END IF 
            END IF 
         END IF 
      END IF 
      #班次信息处理
      LET l_sql1 = " SELECT hrboa01,hrboa02,hrboa03,hrboa04,hrboa05,hrboa06,hrboa07 from hrbo_file,hrboa_file ",
                   "  WHERE hrboa15 = hrbo02 and hrbo10 = 'Y' ",
                   "    AND hrbo02 = '",l_hrcp04,"' " 
      PREPARE i054_2_hr1 FROM l_sql1
      DECLARE i054_2_s1  CURSOR FOR i054_2_hr1   
      FOREACH i054_2_s1 INTO l_hrboa.* 
         IF g_flag = 'bwork' THEN  
            IF l_hrboa.hrboa03 = 'Y' THEN 
               SELECT * INTO l_hrbob.* FROM hrbob_file
                WHERE hrbob09 = l_hrcp04 AND hrbob10 = l_hrboa.hrboa01
                  AND hrbob02 = 'Y'
               IF STATUS=100 THEN  
                  CONTINUE FOREACH #无符合加班信息  
               END IF              
               LET l_sql = " SELECT  to_char(to_date('",l_hrboa.hrboa02,"','hh24:mi') - interval '",l_hrboa.hrboa04,"' minute,'hh24:mi')  FROM  dual "
               PREPARE i054_2_b1 FROM l_sql
               EXECUTE i054_2_b1 INTO l_btime  
            ELSE 
             	 CONTINUE FOREACH  
            END IF  	  
         END IF    
         IF g_flag = 'ework' THEN  
            IF l_hrboa.hrboa06 = 'Y' THEN 
               SELECT * INTO l_hrbob.* FROM hrbob_file
                WHERE hrbob09 = l_hrcp04 AND hrbob10 = l_hrboa.hrboa01
                  AND hrbob03 = 'Y'
               IF STATUS=100 THEN  
                  CONTINUE FOREACH #无符合加班信息  
               END IF             
               LET l_sql = " SELECT  to_char(to_date('",l_hrboa.hrboa05,"','hh24:mi') + interval '",l_hrboa.hrboa07,"' minute,'hh24:mi')  FROM  dual "
               PREPARE i054_2_b2 FROM l_sql
               EXECUTE i054_2_b2 INTO l_btime  
               IF l_btime < l_hrboa.hrboa05 THEN 
                  LET l_btime = '24:00' 
               END IF 
            ELSE 
             	 CONTINUE FOREACH  
            END IF  	  
         END IF        
         IF  g_flag = 'bwork' THEN           
            LET l_sql2 = " SELECT * FROM hrby_file ",
                         "  WHERE hrby05 = '",tm.bdate,"' AND hrby06 BETWEEN  '",l_btime ,"' AND '",l_hrboa.hrboa02,"'  and hrby09 = '",l_hratid CLIPPED,"' and hrby11= '1' and hrbyacti = 'Y' ",
                         "  order by hrby06 "  
            SELECT count(*) INTO l_a FROM hrby_file 
                           WHERE hrby05 = tm.bdate AND hrby06 BETWEEN  l_btime  AND l_hrboa.hrboa02  
                             AND hrby09 = l_hratid  and hrby11= '1' and hrbyacti = 'Y' 
                           ORDER  BY  hrby06  
         ELSE 
            LET l_sql2 = " SELECT * FROM hrby_file ",
                         "  WHERE hrby05 = '",tm.bdate,"' AND hrby06 BETWEEN  '",l_hrboa.hrboa05 ,"' AND '",l_btime,"'  and hrby09 = '",l_hratid CLIPPED,"' and hrby11= '1' and hrbyacti = 'Y' ",
                         "  order by hrby06 "  
            SELECT count(*) INTO l_a FROM hrby_file 
                           WHERE hrby05 = tm.bdate AND hrby06 BETWEEN  l_hrboa.hrboa05  AND l_btime  
                             AND hrby09 = l_hratid  and hrby11= '1' and hrbyacti = 'Y' 
                           ORDER  BY  hrby06  
         END IF                 
         PREPARE i054_2_hr2 FROM l_sql2
         DECLARE i054_2_s2  CURSOR FOR i054_2_hr2  
         LET l_i = 1 
         LET l_n = 0
         LET l_o = 0
         LET l_a = 0
         FOREACH i054_2_s2 INTO l_hrby.*           
            SELECT hrbtud02 INTO l_hrbtud02 FROM hrbt_file      
            IF l_hrbtud02 = '001' THEN 
               IF g_flag = 'bwork' THEN
                  IF l_i = 1 THEN 
                     IF l_hrby.hrby10 = '2' THEN 
                        LET l_time = l_hrby.hrby06
                        LET l_n = 0 
                        IF l_i = l_a THEN 
                           IF l_o = 0  THEN 
                              LET l_hrcn05 = l_hrby.hrby06 
                           END IF 
                           LET l_hrcn07 = l_hrboa.hrboa02
                           CALL i054_1_mi(l_hrboa.hrboa02,l_time) RETURNING l_o                              
                        END IF  
                     END IF 
                  ELSE      
                     IF l_hrby.hrby10 = l_p  THEN 
                        IF l_p = '2' THEN 
                           LET l_time = l_hrby.hrby06
                           LET l_n = 0      
                        END IF              
                     ELSE  
                     	  IF l_hrby.hrby10 = '3' THEN 
                           IF l_p = '2' THEN 
                              IF l_o = 0  THEN 
                                 LET l_hrcn05 = l_time 
                              END IF 
                              LET l_hrcn07 = l_hrby.hrby06
                              CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                              LET l_o = l_o + l_n                     
                           ELSE 
                              LET l_time = l_hrby.hrby06
                              LET l_n = 0      
                           END IF  
                        END IF                     
                     END IF                      
                     IF l_i = l_a AND l_hrby.hrby10 = '2' THEN 
                        IF l_o = 0  THEN 
                           LET l_hrcn05 = l_time 
                        END IF 
                        LET l_hrcn07 = l_hrby.hrby06
                        CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                        LET l_o = l_o + l_n                           
                     END IF 
                  END IF  
               ELSE 
                  IF l_i = 1 THEN 
                     IF l_hrby.hrby10 = '2' THEN 
                        LET l_time = l_hrby.hrby06
                        LET l_n = 0 
                     END IF    
                     IF l_hrby.hrby10 = '3' THEN       
                        IF l_o = 0  THEN 
                           LET l_hrcn05 = l_hrboa.hrboa02
                        END IF 
                        IF l_i = l_a THEN 
                           LET l_hrcn07 = l_hrby.hrby06
                        END IF 
                        CALL i054_1_mi(l_hrby.hrby06,l_hrboa.hrboa02) RETURNING l_o                               
                     END IF 
                  ELSE      
                     IF l_hrby.hrby10 = l_p  THEN 
                        IF l_p = '2' THEN 
                           LET l_time = l_hrby.hrby06
                           LET l_n = 0      
                        END IF              
                     ELSE  
                     	  IF l_hrby.hrby10 = '3' THEN  
                           IF l_p = '2' THEN 
                              IF l_o = 0  THEN 
                                 LET l_hrcn05 = l_time 
                              END IF 
                              LET l_hrcn07 = l_hrby.hrby06
                              CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                              LET l_o = l_o + l_n                     
                           ELSE 
                              LET l_time = l_hrby.hrby06
                              LET l_n = 0      
                           END IF 
                        END IF                   
                     END IF                      
                     IF l_i = l_a AND l_hrby.hrby10 = '2' THEN 
                        IF l_o = 0  THEN 
                           LET l_hrcn05 = l_time 
                        END IF 
                        LET l_hrcn07 = l_hrby.hrby06
                        CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                        LET l_o = l_o + l_n                           
                     END IF 
                  END IF 
               END IF 	     	 
               LET l_p = l_hrby.hrby10 
            END IF 
            IF l_hrbtud02 = '002' THEN
               IF g_flag = 'bwork' THEN 
                  IF l_i = 1 THEN 
                     LET l_hrcn05 = l_hrby.hrby06
                  END IF
                  SELECT mod(l_i,2) INTO l_m FROM dual
                  IF l_m = 1 THEN 
                     LET l_time = l_hrby.hrby06
                     LET l_n = 0
                  ELSE 
                     LET l_hrcn07 = l_hrby.hrby06
                     CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                     LET l_o = l_o + l_n
                  END IF
                  IF l_i = l_a AND l_m = 1 THEN 
                     LET l_hrcn07 = l_hrboa.hrboa02
                     CALL i054_1_mi(l_hrboa.hrboa02,l_time) RETURNING l_n
                     LET l_o = l_o + l_n                     
                  END IF  
               ELSE 
                  IF l_i = 1 THEN 
                     LET l_hrcn05 = l_hrboa.hrboa05 
                     LET l_time = l_hrboa.hrboa05 
                  END IF
                  SELECT mod(l_i,2) INTO l_m FROM dual
                  IF l_m = 0 THEN 
                     LET l_time = l_hrby.hrby06
                     LET l_n = 0
                  ELSE 
                     LET l_hrcn07 = l_hrby.hrby06
                     CALL i054_1_mi(l_hrby.hrby06,l_time) RETURNING l_n
                     LET l_o = l_o + l_n
                  END IF 
               END IF    	                             
            END IF
            IF l_hrbtud02 = '003' THEN
               IF g_flag = 'bwork' THEN
                  IF l_i = 1 THEN 
                     LET l_hrcn05 = l_hrby.hrby06 
                  END IF 
                  IF l_i = l_a THEN                      
                     LET l_hrcn07 = l_hrboa.hrboa02
                     CALL i054_1_mi(l_hrcn07,l_hrcn05) RETURNING l_o
                  END IF  
               ELSE 
                  IF l_i = 1 THEN 
                     LET l_hrcn05 = l_hrboa.hrboa05 
                  END IF 
                  IF l_i = l_a THEN                      
                     LET l_hrcn07 = l_hrby.hrby06 
                     CALL i054_1_mi(l_hrcn07,l_hrcn05) RETURNING l_o
                  END IF  
               END IF 	                                     
            END IF  
            LET l_i = l_i +1     
         END FOREACH 
         IF l_o = 0 THEN 
            CONTINUE FOREACH 
         END IF
         IF l_o < l_hrbob.hrbob05 THEN 
            CONTINUE FOREACH
         ELSE 
         	 SELECT  l_o - mod(l_o,l_hrbob.hrbob06) INTO l_o FROM  dual   
         END IF
         IF l_o > l_hrbob.hrbob07 THEN 
            LET l_o = l_hrbob.hrbob07 
         END IF 
         LET l_o = l_o/60
         LET l_n = 0                        
         SELECT COUNT(*) INTO l_n FROM hrcn_file 
         IF g_flag = 'ework' THEN
            SELECT COUNT(*) INTO l_x FROM hrcn_file 
             WHERE hrcn03 = l_hratid AND hrcn04 = tm.bdate
               AND hrcn05 = l_hrcn05
            IF l_x = 1  THEN 
               UPDATE hrcn_file SET hrcn06 = tm.bdate,hrcn07 = l_hrcn07,hrcn08 = l_o
                WHERE hrcn03 = l_hratid AND hrcn04 = tm.bdate
                  AND hrcn05 = l_hrcn05
               IF SQLCA.sqlcode THEN
               ELSE
                  SELECT COUNT(*) INTO l_k FROM hrcp_file WHERE hrcp02 = l_hratid AND hrcp03 = tm.bdate
                  IF l_k > 0 THEN 
                   	UPDATE hrcp_file
                   	   SET hrcp35 = 'N'
                	     WHERE hrcp02 = l_hratid AND hrcp03 = tm.bdate
                  END IF   
               END IF 
               CONTINUE FOREACH
            END IF  
         ELSE 
            SELECT COUNT(*) INTO l_x FROM hrcn_file 
             WHERE hrcn03 = l_hratid AND hrcn06 = tm.bdate
               AND hrcn07 = l_hrcn07
            IF l_x = 1  THEN 
               UPDATE hrcn_file SET hrcn04 = tm.bdate,hrcn05 = l_hrcn05,hrcn08 = l_o
                WHERE hrcn03 = l_hratid AND hrcn06 = tm.bdate
                  AND hrcn07 = l_hrcn07
               IF SQLCA.sqlcode THEN
               ELSE
                  SELECT COUNT(*) INTO l_k FROM hrcp_file WHERE hrcp02 = l_hratid AND hrcp03 = tm.bdate
                  IF l_k > 0 THEN 
                   	UPDATE hrcp_file
                   	   SET hrcp35 = 'N'
                	     WHERE hrcp02 = l_hratid AND hrcp03 = tm.bdate
                  END IF   
               END IF 
               CONTINUE FOREACH
            END IF           	      
         END IF          
         IF l_n >0 THEN 
            SELECT MAX(hrcn02) + 1 INTO l_hrcn02 FROM hrcn_file
         ELSE 
         	  LET l_hrcn02 = 1
         END IF 
         INSERT INTO hrcn_file (hrcn01,hrcn02,hrcn03,hrcn04,hrcn05,hrcn06,hrcn07,hrcn08,hrcn09,hrcn10,hrcn11,hrcn12,hrcn13,hrcn14,hrcnconf,hrcnacti)
         VALUES ('',l_hrcn02,l_hratid,tm.bdate,l_hrcn05,tm.bdate,l_hrcn07,l_o,'015','N','',0,0,tm.bdate,'N','Y')            
        IF SQLCA.sqlcode THEN
        ELSE
           SELECT COUNT(*) INTO l_k FROM hrcp_file WHERE hrcp02 = l_hratid AND hrcp03 = tm.bdate
           IF l_k > 0 THEN 
            	UPDATE hrcp_file
            	   SET hrcp35 = 'N'
         	     WHERE hrcp02 = l_hratid AND hrcp03 = tm.bdate
           END IF   
        END IF           
      END FOREACH 

    
   END FOREACH               
 
END FUNCTION 
FUNCTION i054_2_hrcp04(p_hratid)
DEFINE l_hrat03 LIKE hrat_file.hrat02
DEFINE l_hrat04 LIKE hrat_file.hrat04
DEFINE l_hrcp04 LIKE hrcp_file.hrcp04
DEFINE p_hratid LIKE hrat_file.hratid

      SELECT hrat03,hrat04 INTO l_hrat03,l_hrat04
        FROM hrat_file WHERE hratid=p_hratid
      SELECT hrdq06 INTO l_hrcp04 FROM hrdq_file
       WHERE hrdq03=l_hrat04 AND hrdq05=tm.bdate AND hrdq02='2'
      IF STATUS=100 THEN 
         SELECT hrdq06 INTO l_hrcp04 FROM hrdq_file
          WHERE hrdq03=l_hrat03 AND hrdq05=tm.bdate AND hrdq02='3'
      END IF 
      RETURN l_hrcp04
END FUNCTION

