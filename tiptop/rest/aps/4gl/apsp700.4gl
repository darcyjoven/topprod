# Prog. Version..: '5.10.05-08.12.18(00003)'     #
#
# Pattern name...: apsp700.4gl
# Descriptions...: APS TIPTOP佇列管理員
# Date & Author..: 08/04/28 By Kevin #FUN-840179
# Modify.........: No:MOD-860081 08/06/10 By jamie ON IDLE問題
# Modify.........: No:FUN-870061 08/07/10 By kevin 更新vla02基本資料最後異動日

DATABASE ds
#FUN-840179
GLOBALS "../../config/top.global"

DEFINE g_all_dbs     DYNAMIC ARRAY OF STRING
DEFINE g_cmd         STRING
DEFINE g_vzu_rowid   LIKE type_file.chr18     #ROWID使用
DEFINE g_vzv_rowid   LIKE type_file.chr18     #vzv_file ROWID使用
DEFINE g_start_time  DATETIME YEAR TO SECOND
DEFINE g_end_time    DATETIME YEAR TO SECOND
DEFINE g_vlg04       LIKE vlg_file.vlg04

MAIN
                    
  DEFINE l_time        LIKE type_file.chr8,   #計算被使用時間  #No.FUN-690010 CHAR
      p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
  
                      
  OPTIONS                                 #改變一些系統預設值
       FORM LINE       FIRST + 2,         #畫面開始的位置
       MESSAGE LINE    LAST,              #訊息顯示的位置
       PROMPT LINE     LAST,              #提示訊息的位置
       INPUT NO WRAP                      #輸入的方式: 不打轉
  DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF

  WHENEVER ERROR CALL cl_err_msg_log

  IF (NOT cl_setup("APS")) THEN
     EXIT PROGRAM
  END IF

  
  #CALL scan()
  OPEN WINDOW p700_w AT p_row,p_col WITH FORM "aps/42f/apsp700"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)  
  
  CALL cl_ui_init()  
  
  SELECT vlg04 INTO g_vlg04 FROM vlg_file WHERE vlg01= g_plant
  
  WHILE TRUE
      LET g_action_choice = NULL
      CALL p700_menu()
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE  
         
  CLOSE WINDOW p700_w
  
  
  CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No:MOD-580088
       RETURNING l_time

END MAIN

FUNCTION p700_menu()
   DEFINE l_config  RECORD
                    url STRING                    
                    END RECORD
   DEFINE l_response STRING   
   DEFINE l_ze03      LIKE  ze_file.ze03
   
   CALL cl_getmsg('aps-700',g_lang) RETURNING l_ze03
   #DEFINE l_scan_time  DATETIME YEAR TO SECOND   
   #LET l_scan_time = DATETIME YEAR TO SECOND   
   
   LET l_response= l_ze03 ,CURRENT YEAR TO SECOND
   
   DISPLAY l_response TO out
   
   LET l_config.url=g_vlg04   
                    
   INPUT BY NAME l_config.* WITHOUT DEFAULTS 
        ATTRIBUTE(UNBUFFERED)
        
        BEFORE INPUT
          CALL DIALOG.setActionHidden("accept", TRUE)
          CALL DIALOG.setActionHidden("cancel", TRUE)
             
        ON IDLE 5
           LET l_response= l_ze03,CURRENT YEAR TO SECOND
           DISPLAY l_response TO out           
           CALL aps_scan_data()
          
        ON ACTION accept
           CONTINUE INPUT  
             	
        ON ACTION cancel
           LET INT_FLAG = FALSE
           LET g_action_choice = "exit"
           EXIT INPUT     	        

       #MOD-860081------add-----str---
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
        
        ON ACTION help          
           CALL cl_show_help()  
       #MOD-860081------add-----end---

    END INPUT
   {WHILE TRUE      
      CASE g_action_choice          
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
     END CASE
   END WHILE}

END FUNCTION

FUNCTION scan()
DEFINE   g_fglserver   STRING
  #LET g_fglserver = FGL_GETENV("FGLSERVER")
  #LET g_fglserver = cl_process_chg_iprec(g_fglserver)
  
  DISPLAY "apsp700啟動執行中...(每隔 5 秒跑一次)"   
  DISPLAY "中斷執行請輸入Delete"   
  CALL aps_scan_log("apsp700啟動----每隔 5 秒跑一次")
  #DISPLAY g_fglserver
  #DISPLAY g_user  
  
   WHILE TRUE   	  
   	 IF INT_FLAG THEN
       LET INT_FLAG = 0      
       EXIT WHILE
     END IF  
     CALL aps_scan_data()        
     SLEEP 5     
   END WHILE
   DISPLAY " "
   DISPLAY "執行結束..."   
END FUNCTION  

FUNCTION aps_scan_data()
DEFINE l_sql    STRING
DEFINE l_status LIKE type_file.chr1
DEFINE l_vzv01  LIKE vzv_file.vzv01,  
       l_vzv02  LIKE vzv_file.vzv02,
       l_vzv03  LIKE vzv_file.vzv03,
       l_vzv04  LIKE vzv_file.vzv04,
       l_vzv06  LIKE vzv_file.vzv06,       
       l_vzu07  LIKE vzu_file.vzu07
       
   LET l_sql = "SELECT rowid,vzv01,vzv02,vzv03,vzv04,vzv06 FROM vzv_file  ",
               " where vzv07 ='N' and vzv00='",g_plant,"' ",
               " ORDER BY vzv01,vzv02,vzv03,vzv04"
   
   #DISPLAY l_sql
   
   PREPARE aps_vzv_file FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','vzv_file','','',SQLCA.sqlcode,'','',1)
      EXIT PROGRAM
   END IF
   DECLARE vaz_file_cs CURSOR FOR aps_vzv_file
   	
   OPEN vaz_file_cs
   FETCH vaz_file_cs INTO g_vzv_rowid,l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06   
   CLOSE vaz_file_cs
   
   IF l_vzv04='01' THEN   	
   	  UPDATE vzy_file      #更新多廠資料
   	     SET vzy10=l_vzv06
   	   WHERE vzy00=g_plant
   	     AND vzy01=l_vzv01
   	     AND vzy02=l_vzv02
   	     
      IF SQLCA.SQLCODE THEN   	     
         CALL aps_scan_log("update vzy_file failed")   
         LET l_status='N'         
      ELSE
         LET l_status='Y'	
      END IF
   	  
    UPDATE vzv_file
       SET vzv07=l_status
     WHERE ROWID= g_vzv_rowid
     
    IF SQLCA.SQLCODE THEN  
       CALL aps_scan_log("update vzv_file failed:1")	              
    END IF
     
    RETURN
   END IF
   
   #作業running
   LET g_start_time = CURRENT YEAR TO SECOND
   LET g_end_time   = CURRENT YEAR TO SECOND
   IF l_vzv06="R" THEN
      SELECT vzu07,ROWID INTO l_vzu07,g_vzu_rowid
        FROM vzu_file
       WHERE vzu00=g_plant
         AND vzu01=l_vzv01
         AND vzu02=l_vzv02
         AND vzu03=l_vzv04
         
      IF (l_vzu07<>"R") THEN
         UPDATE vzu_file SET vzu07=l_vzv06,##回寫狀態碼
                             vzu05=g_start_time                             
          WHERE ROWID = g_vzu_rowid
      END IF
      
      IF (l_vzv04="10") THEN 
      	 UPDATE vzy_file set vzy11 = l_vzv02 ##回寫執行中版本
      	  WHERE vzy00=g_plant
   	        AND vzy01=l_vzv01
   	        AND vzy02=l_vzv02   	        
      END IF
      
      
      UPDATE vzv_file SET vzv07='Y' 
   	   WHERE ROWID= g_vzv_rowid
   	   
      IF SQLCA.SQLCODE THEN  
    	 CALL aps_scan_log("update vzv_file failed:2")	              
      END IF
   	   
      RETURN 
   END IF
   
   #作業失敗
   IF l_vzv06="F" OR l_vzv06="C" THEN
   	  SELECT vzu07,ROWID INTO l_vzu07,g_vzu_rowid
   	    FROM vzu_file
       WHERE vzu00=g_plant
         AND vzu01=l_vzv01
         AND vzu02=l_vzv02
         AND vzu03=l_vzv04
         
       IF (l_vzu07<>"F" OR l_vzu07<>"C") THEN 
       	  UPDATE vzu_file SET vzu07=l_vzv06, ##回寫狀態碼
       	                      vzu06=g_end_time
       	   WHERE ROWID = g_vzu_rowid    	
       END IF
       
       UPDATE vzv_file SET vzv07='Y'
   	   WHERE ROWID= g_vzv_rowid
   	   IF SQLCA.SQLCODE THEN  
   	  	 CALL aps_scan_log("update vzv_file failed:3")	              
       END IF
      
       RETURN
   END IF 
   
   IF l_vzv06="Y" THEN #表示執行成功
      SELECT vzu07,ROWID INTO l_vzu07,g_vzu_rowid
        FROM vzu_file
       WHERE vzu00=g_plant
         AND vzu01=l_vzv01
         AND vzu02=l_vzv02
         AND vzu03=l_vzv04
         
       IF l_vzu07<>"Y" THEN 
       	  UPDATE vzu_file SET vzu07='Y', ##回寫狀態碼 Y
       	                      vzu06=g_end_time 
       	   WHERE ROWID = g_vzu_rowid 	
       END IF   	
       
       UPDATE vzv_file SET vzv07='Y'
   	    WHERE ROWID= g_vzv_rowid
   	    
   	   IF SQLCA.SQLCODE THEN  
   	  	  CALL aps_scan_log("update vzv_file failed:4")	              
       END IF
       
       CASE l_vzv04     
            WHEN "10"     ##呼叫下一步  	 
               CALL p700_ins_vzv('R',l_vzv01,l_vzv02,"20")
            	 
       	       LET g_cmd = "apsp600 'erp_export' '",
       	                             g_plant CLIPPED,"' '",
       	                             l_vzv01 CLIPPED,"' '",
                                     '0' CLIPPED,"' ",
                                     " '' ''  '",
                                     l_vzv02 CLIPPED,"' "                                     
                                     ##呼叫SSIS時,統一儲存版本為'0'                                  
               DISPLAY g_cmd                             
               CALL cl_cmdrun_wait(g_cmd)
               
           WHEN "30"
               #CALL p700_ins_vzv('R',l_vzv01,l_vzv02,"40")   
               LET g_cmd = "apst601 '",g_plant CLIPPED,"' '",               
                                       l_vzv01 CLIPPED,"' ",
       	                               " '0' " #儲存版本為'0'
       	                            
       	       DISPLAY g_cmd
       	       CALL cl_cmdrun_wait(g_cmd)       	    	 
       	  
       	  WHEN "40"
       	  	   UPDATE vzy_file set vzy12 = g_end_time ##回寫版本確認時間
       	  	    WHERE vzy00=g_plant
   	              AND vzy01=l_vzv01
   	              AND vzy02=l_vzv02
   	              
   	           IF SQLCA.SQLCODE THEN  
   	  	          CALL aps_scan_log("update vzy_file failed:5")	              
               END IF
          WHEN "50"
               CALL p700_upd_config(l_vzv01) #FUN-870061
       END CASE
                
   END IF
  
   IF l_vzv06="N" THEN   	     	  
   	  RETURN   	  
   END IF 
   
END FUNCTION

FUNCTION p700_ins_vzv(p_code,p_vzv01,p_vzv02,p_vzv04) #APS各類訊息檔
DEFINE l_vzv       RECORD LIKE vzv_file.*
DEFINE l_ze03      LIKE  ze_file.ze03
DEFINE l_vzv03     DATETIME YEAR TO SECOND
DEFINE p_code      LIKE vzv_file.vzv06
DEFINE p_vzv01     LIKE vzv_file.vzv01
DEFINE p_vzv02     LIKE vzv_file.vzv02
DEFINE p_vzv04     LIKE vzv_file.vzv04

  #CALL cl_getmsg('aps-504',g_lang) RETURNING l_ze03
  INITIALIZE l_ze03 TO NULL
  IF p_vzv04 = '20' THEN
     CALL cl_getmsg('aps-506',g_lang) RETURNING l_ze03
  END IF
  IF p_vzv04 = '40' THEN
     CALL cl_getmsg('aps-508',g_lang) RETURNING l_ze03
  END IF
  INITIALIZE l_vzv.* TO NULL
  LET l_vzv.vzv00 = g_plant     #營運中心
  LET l_vzv.vzv01 = p_vzv01    #APS版本
  ##LET l_vzv.vzv02 = p_vzv01    #儲存版本
  LET l_vzv.vzv02 = p_vzv02    #儲存版本
  #LET l_vzv03     = CURRENT YEAR TO SECOND #訊息接收時間
  LET g_start_time = l_vzv03
  LET l_vzv.vzv04 = p_vzv04        #訊息代號
  LET l_vzv.vzv05 = l_ze03      #訊息說明==>TP資料轉至中介檔
  LET l_vzv.vzv06 = p_code      #訊息狀態
  LET l_vzv.vzv07 = 'N'         #tiptop執行結果
  LET l_vzv.vzv08 = g_user      #操作人員代號

  INSERT INTO vzv_file(vzv00,vzv01,vzv02,vzv04,
                       vzv05,vzv06,vzv07,vzv08)
   VALUES(l_vzv.vzv00,l_vzv.vzv01,l_vzv.vzv02,l_vzv.vzv04,
          l_vzv.vzv05,l_vzv.vzv06,l_vzv.vzv07,l_vzv.vzv08)
  IF STATUS THEN
     CALL cl_err3("ins","vzv_file",l_vzv.vzv01,l_vzv.vzv02,STATUS,"","",1)
  END IF
 
END FUNCTION

#FUN-870061 更新vla02基本資料最後異動日
FUNCTION p700_upd_config(p_vzv01)
  DEFINE l_cnt      LIKE type_file.num10   
  DEFINE p_vzv01    LIKE vzv_file.vzv01
     
     SELECT COUNT(*) INTO l_cnt
       FROM vla_file
      WHERE vla01 = p_vzv01
      
     IF l_cnt >= 1 THEN
         UPDATE vla_file 
            SET vla02 = g_today
            WHERE vla01 = p_vzv01
         IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","vla_file",p_vzv01,"",SQLCA.sqlcode,"","upd vla_file",1)
         END IF
     ELSE
         INSERT INTO vla_file VALUES(p_vzv01,g_today)
         IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","vla_file",p_vzv01,"",SQLCA.sqlcode,"","upd vla_file",1) 
         END IF
     END IF
END FUNCTION

FUNCTION p700_upd_vzv(p_rowid)
DEFINE l_cnt    LIKE type_file.num5 
DEFINE p_rowid  LIKE type_file.chr18
             
     UPDATE vzv_file SET vzv07='Y' 
      WHERE ROWID=p_rowid

END FUNCTION

{FUNCTION checkdata(p_vzv01,p_vzv02,p_vzv03,p_vzv04)
DEFINE l_sql    STRING
DEFINE p_vzv01  LIKE vzv_file.vzv01,  
       p_vzv02  LIKE vzv_file.vzv02,
       p_vzv03  LIKE vzv_file.vzv03,       
       p_vzv04  LIKE vzv_file.vzv04,  
       l_vzv06  LIKE vzv_file.vzv06
       
       
   LET l_sql = "SELECT vzv06 FROM vzv_file where ",
                 " vzv00='",g_plant,"'",
                 " and vzv01='",p_vzv01,"'",
                 " and vzv02='",p_vzv02,"'",                 
                 " and vzv04='",p_vzv04,"'",
                 " ORDER BY vzv01,vzv02,vzv03 desc "
   
   DISPLAY l_sql
                 
   PREPARE aps_sql FROM l_sql
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','vzv_file','','',SQLCA.sqlcode,'','',1)
      EXIT PROGRAM
   END IF
   
   DECLARE aps_cs CURSOR FOR aps_sql
   OPEN aps_cs
   FETCH aps_cs INTO l_vzv06
   
   IF l_vzv06= "Y" THEN   	  
   	  RETURN TRUE #代表前一步執行OK
   ELSE
   	  DISPLAY  p_vzv01," ",p_vzv02," " ,p_vzv04, " status :",l_vzv06
   	  RETURN FALSE 	  
   END IF
   	
END FUNCTION
}
 
FUNCTION aps_scan_log(p_result)    
   DEFINE p_result     STRING
   DEFINE l_file       STRING,              
          l_str        STRING,
          l_request    STRING
   DEFINE l_i          LIKE type_file.num10
   DEFINE channel      base.Channel

   LET channel = base.Channel.create()
   LET l_file = fgl_getenv("TEMPDIR"), "/",
                 "apsp700-", TODAY USING 'YYYYMMDD', ".log"

   CALL channel.openFile(l_file, "a")  
   
   IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
       CALL channel.write("") 
       CALL channel.write(p_result)        
   ELSE
       DISPLAY "Can't open log file."
   END IF
   CALL channel.close()
       
END FUNCTION

#[
# Description....: 切換多工廠資料庫
# Date & Author..: 2008/05/05 by Kevin
# Parameter......: 
# Return.........: TRUE/FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aps_multiDB_scan()
   DEFINE l_azp03   LIKE azp_file.azp03
   DEFINE l_sql     STRING  
   DEFINE l_i       INTEGER     
   
   LET l_sql = "SELECT azp03 FROM azp_file"
   PREPARE sql_prepare1 FROM l_sql      #預備一下
   DECLARE azp_cs CURSOR FOR sql_prepare1
   	
   LET l_i=1
   
   FOREACH azp_cs INTO l_azp03     	  
   	  LET g_all_dbs[l_i] = l_azp03    	  
   	  #IF aps_changeDatabase(l_azp03) THEN
   	  #   DISPLAY l_azp03	
   	  #ELSE
   	  #	 DISPLAY "Switch Database Failed"	  
   	  #END IF   	  
      IF SQLCA.sqlcode THEN  
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF      
      
      LET l_i = l_i + 1 
   END FOREACH 
   
   FOR l_i=1 TO g_all_dbs.getLength()       
       LET l_azp03 = g_all_dbs[l_i] CLIPPED
       IF  aps_changeDatabase(l_azp03) THEN
       	   DISPLAY "Change database success:" , g_all_dbs[l_i]
       ELSE
       	   DISPLAY "Change database failed:" , g_all_dbs[l_i]	
       END IF
       
   END FOR
   
END FUNCTION
#[
# Description....: 切換指定的資料庫
# Date & Author..: 2008/05/05 by Kevin
# Parameter......: p_azp03 - STRING - 資料庫代碼
# Return.........: TRUE/FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aps_changeDatabase(p_azp03)
#DEFINE p_azp01   LIKE azp_file.azp01
DEFINE p_azp03   LIKE azp_file.azp03

   IF cl_null(p_azp03) THEN
      RETURN FALSE
   END IF

   #SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_azp01
   #IF SQLCA.SQLCODE THEN
      #LET g_status.sqlcode = SQLCA.SQLCODE
   #   RETURN FALSE
   #END IF
   
   CLOSE DATABASE

   #切換資料庫
   DATABASE p_azp03
   IF SQLCA.SQLCODE THEN
      #LET g_status.sqlcode = SQLCA.SQLCODE
      CLOSE DATABASE
      DATABASE ds
      RETURN FALSE
   END IF

   RETURN TRUE
END FUNCTION
   
