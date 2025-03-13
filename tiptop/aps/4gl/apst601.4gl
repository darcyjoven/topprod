# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apst601.4gl
# Descriptions...: 啟動APS CP手調器
# Date & Author..: 08/04/28 By Kevin #FUN-840179
# Modify.........: No.MOD-870105 08/07/09 By kevin 修改select的方式
# Modify.........: No.FUN-890104 08/09/23 By kevin 程式調整成可背景排程執行
# Modify.........: No.TQC-8B0013 08/11/06 By kevin 帶入0 儲存版本
# Modify.........: No.TQC-8B0021 08/11/13 By Duke  確認時啟動 apsp702
# Modify.........: No.FUN-8C0140 08/12/31 By Duke  run apsp702 時,p_process加顯示aps版本及儲存版本,且g_bgjob預設為'N'
# Modify.........: NO.TQC-940098 09/05/07 BY destiny DISPLAY BY NAME g_vzu01會報錯將其改為DISPLAY TO的形式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No.FUN-B50020 11/05/04 By Lilan APS GP5.25追版 -----
#                                1.apsp702執行時增加顯示廠別
#                                2.僅留下"啟動APS CP手調器"的動作,不需要再啟動apsp702
# Modify.........: No.FUN-B50020 --------------------------------------
# Modify.........: No.FUN-BC0059 11/12/16 By Mandy 非自動確認：
#                                                  (1)在30階段 (訊息狀態:”Y”後續作業執行結果:”Y) 關apsp702 
#                                                  (2)apst601按下確認後重起apsp702
#                                                  (3)需等程式執行完畢後，由系統自動跳出apst601時再啟動APS手調器，提供防呆機制


DATABASE ds
GLOBALS "../../config/top.global"
DEFINE   p_row         LIKE type_file.num5    
DEFINE   p_col         LIKE type_file.num5 
DEFINE   g_argv1       LIKE vzx_file.vzx00,
         g_argv2       LIKE vzx_file.vzx01,
         g_argv3       LIKE vzx_file.vzx02,
         g_argv4       String,
         g_argv5       String
DEFINE   g_vzu01       LIKE vzu_file.vzu01,     
         g_vzu02       LIKE vzu_file.vzu02,  
         g_ch1         LIKE type_file.chr1           
DEFINE   g_version     LIKE type_file.chr1  
DEFINE   g_vlh06       LIKE vlh_file.vlh06
DEFINE   l_msg         string    #TQC-8B0021  ADD
         
MAIN
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_vlz75  LIKE vlz_file.vlz75 #FUN-BC0059 add
   DEFINE l_str    STRING              #FUN-BC0059 add

   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   
   LET g_argv1 = ARG_VAL(1) CLIPPED     
   LET g_argv2 = ARG_VAL(2) CLIPPED     
   LET g_argv3 = ARG_VAL(3) CLIPPED     
   LET g_argv4 = ARG_VAL(4) CLIPPED     
   LET g_argv5 = ARG_VAL(5) CLIPPED     
   
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW apst601_w AT p_row,p_col WITH FORM "aps/42f/apst601"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()   
 
    IF NOT cl_null(g_argv1) THEN
    	  LET g_plant = g_argv1 CLIPPED        
        LET g_vzu01 = g_argv2 CLIPPED        
        LET g_vzu02 = g_argv3 CLIPPED
        LET g_ch1   = 'Y'
           
        SELECT COUNT(*) INTO l_cnt
        FROM vzy_file
        WHERE vzy00=g_plant
   	      AND vzy01=g_vzu01
   	      AND vzy02=g_vzu02
   	     
        IF l_cnt=0 THEN
        	 CALL cl_err('','aps-522',1)
        	 RETURN 
        END IF            
        CALL q100()
    ELSE
    	  LET g_ch1="N"
        CALL q100()
    END IF
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
    ELSE
      #FUN-B50020 mark str --------------------
      #SELECT vlh06 INTO g_vlh06
      #  FROM vlh_file
      # WHERE vlh01=g_plant AND vlh03=g_vzu01 AND vlh04=g_vzu02       
      #
      #IF g_argv3='0' OR g_vlh06="Y" OR g_vlh06="R" THEN
      #     CALL aws_open_browser(g_plant,g_vzu01,'0','1')    	    
      #     CALL t601_run_apsp702() #FUN-890104    	    
      #  ELSE
      #      LET g_bgjob = "N"    
      #
      #     LET l_msg = " apsp702 '",g_bgjob CLIPPED,"' '",g_vzu01 CLIPPED,"' '",g_vzu02 CLIPPED,"'" ##FUN-8C0140 ADD
      #     CALL cl_cmdrun(l_msg CLIPPED)   #TQC-8B0021 ADD
      #     CALL aws_open_browser(g_plant,g_vzu01,'0','1') #TQC-8B0013
      #END IF
      #FUN-B50020 mark end --------------------
      #FUN-BC0059---add----str---
      IF NOT cl_null(g_sma.sma918) AND g_sma.sma918 = 'Y' THEN
          SELECT COUNT(*) INTO l_cnt
            FROM vlh_file
           WHERE vlh01 = g_plant
             AND vlh03 = g_vzu01
             AND vlh04 = g_vzu02
          SELECT vlz75 
            INTO l_vlz75 
            FROM vlz_file
           WHERE vlz01 = g_vzu01
             AND vlz02 = g_vzu02
          IF l_cnt >=1 AND l_vlz75 = '0' THEN
             #條件:
             #(1)APS版本,儲存版本要跟vlh_file一樣
             #(2)apss301 為非自動確認
             #==>停5秒後,重啟apsp702
             SLEEP 5   	    
             LET l_msg = " apsp702 '",g_plant CLIPPED,"' '",g_bgjob CLIPPED,"' '",g_vzu01 CLIPPED,"' '",g_vzu02 CLIPPED,"'"  #TQC-950064 ADD
             CALL cl_cmdrun(l_msg CLIPPED)
             LET l_str = "ReStart PROGRAM:apsp702 at apst601==> vzu01:",g_vzu01 CLIPPED," vzu02:",g_vzu02 CLIPPED
             CALL t601_scan_log(l_str) 
          END IF
      END IF
      #FUN-BC0059---add----end---

      CALL aws_open_browser(g_plant,g_vzu01,'0','1')    #FUN-B50020 add   
    END IF
    
    CLOSE WINDOW apst601_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
   
END MAIN
 
FUNCTION t601_run_apsp702()   
   DEFINE l_msg      string
   
   IF g_vlh06 ="Y" THEN 
      LET g_bgjob = "Y"
     #LET l_msg = " apsp702 '",g_bgjob CLIPPED,"' '",g_vzu01 CLIPPED,"' '",g_vzu02 CLIPPED,"'"   ##FUN-8C0140 ADD  #FUN-B50020 mark
      LET l_msg = " apsp702 '",g_plant CLIPPED,"' '",g_bgjob CLIPPED,"' '",g_vzu01 CLIPPED,"' '",g_vzu02 CLIPPED,"'"  #FUN-B50020 add
      CALL cl_cmdrun(l_msg CLIPPED)
      
      UPDATE vlh_file SET vlh06='R'  #避開重複開啟apsp702       
       WHERE vlh01=g_plant AND vlh03=g_vzu01 AND vlh04=g_vzu02 
   END IF   
END FUNCTION
 
FUNCTION q100()
   DEFINE l_cnt    LIKE type_file.num5
         
   INPUT g_vzu01,g_vzu02,g_ch1 WITHOUT DEFAULTS  FROM vzu01,vzu02,ch1 
       ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
        	   IF NOT cl_null(g_argv1) THEN
                CALL cl_set_comp_entry("vzu01",FALSE)
                CALL cl_set_comp_entry("vzu02",FALSE)             
             END IF
     
        ON ACTION CONTROLP
           IF INFIELD(vzu01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_vzy01"
               CALL cl_create_qry() RETURNING g_vzu01
               DISPLAY g_vzu01 TO vzu01                  #No.TQC-940098
               NEXT FIELD vzu01                  
               
           END IF
           
           IF INFIELD(vzu02) THEN
              IF NOT cl_null(g_vzu01) THEN          	
                 CALL cl_init_qry_var()
                 IF g_version="0" THEN                 	  

                 ELSE
                 		LET g_qryparam.form = "q_vzy04"                                 
                 END IF
                 LET g_qryparam.arg1 = g_vzu01 CLIPPED                 
                 CALL cl_create_qry() RETURNING g_vzu02
                 DISPLAY g_vzu01 TO vzu02                #No.TQC-940098
                 NEXT FIELD vzu02              
               ELSE
                 CALL cl_err('','aps-521',1)
               END IF
           END IF
           
       AFTER FIELD vzu01
         IF NOT cl_null(g_vzu01) THEN
            SELECT count(*) INTO l_cnt FROM vzy_file #MOD-870105
             WHERE vzy01 = g_vzu01
               AND vzy10 = 'Y'
               
            IF l_cnt = 0 THEN #MOD-870105
               CALL cl_err('sel vzy:',STATUS,1)
               NEXT FIELD vzu01
            END IF
            
            
            IF cl_null(g_argv1) THEN
               CALL cl_set_comp_entry("vzu02",TRUE)
                  SELECT vzy11 INTO g_vzu02
                    FROM vzy_file
                   WHERE vzy00=g_plant
   	                 AND vzy01=g_vzu01
   	                 AND vzy02='0'   	              
   	              
   	              IF cl_null(g_vzu02) THEN
   	              	 LET g_vzu02="0"   #取不到預設給0      	 	   	              	 
   	              END IF
   	              LET g_ch1="Y"
   	              DISPLAY BY NAME g_ch1
   	              DISPLAY g_vzu02 TO vzu02
   	              CALL cl_set_comp_entry("vzu02",FALSE) 
   	                	                 
            ELSE
            	 SELECT vzy11 INTO g_vzu02
                    FROM vzy_file
                   WHERE vzy00=g_plant
   	                 AND vzy01=g_vzu01
   	                 AND vzy02='0'
   	                 
   	           DISPLAY g_vzu02 TO vzu02        
            END IF               
         END IF
         
       AFTER FIELD vzu02
         IF NOT cl_null(g_vzu01) AND NOT cl_null(g_vzu02) THEN
            SELECT COUNT(*) INTO l_cnt
              FROM vlz_file where vlz01 = g_vzu01
               
            IF l_cnt = 0  THEN
               CALL cl_err('sel vzy:',STATUS,1)
               NEXT FIELD vzu02
            END IF
         END IF  
         
        AFTER INPUT        	 
          #FUN-BC0059-----add----str----
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM vzv_file
           WHERE vzv01 = g_vzu01
             AND vzv02 = g_vzu02
             AND vzv04 = '30'
             AND vzv06 = 'Y'
          IF l_cnt = 0  THEN
              CALL cl_err(' ','aps-601',1)
              LET INT_FLAG = 1
          END IF 
          #FUN-BC0059-----add----end----
          IF INT_FLAG THEN
              EXIT INPUT            	
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
        
        ON ACTION locale
           CALL cl_dynamic_locale()
        
        ON ACTION qbe_select
           CALL cl_qbe_select()
           
        ON ACTION qbe_save
           CALL cl_qbe_save()
           
           
   END INPUT  
   
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#FUN-BC0059----add----str----
FUNCTION t601_scan_log(p_result)    
   DEFINE p_result     STRING
   DEFINE l_file       STRING,              
          l_str        STRING,
          l_request    STRING
   DEFINE l_i          LIKE type_file.num10
   DEFINE channel      base.Channel

   LET channel = base.Channel.create()
   LET l_file = fgl_getenv("TEMPDIR"), "/",g_plant CLIPPED,"-",
                 "apsp702-", TODAY USING 'YYYYMMDD', ".log"

   CALL channel.openFile(l_file, "a")  
   LET p_result = g_plant CLIPPED,":",p_result CLIPPED 
   
   IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write(p_result)        
       CALL channel.write("")              
   ELSE            
      #CHI-A70049 ---mod---str---
      #DISPLAY "Can't open log file."   
       IF g_bgjob = "N" OR cl_null(g_bgjob) THEN
           CALL cl_err("Can't open log file.",STATUS,1)
       END IF
      #CHI-A70049 ---mod---end---
   END IF
   CALL channel.close()
   RUN "chmod 666 " || l_file || " >/dev/null 2>&1"   
END FUNCTION
#FUN-BC0059----add----end----
