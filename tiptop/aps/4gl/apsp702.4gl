# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apsp702.4gl
# Descriptions...: APS TIPTOP佇列管理員
# Date & Author..: 08/07/11 By Kevin #FUN-870068 
# Modify.........: FUN-890104 08/09/23 By kevin 程式調整成可背景排程執行
# Modify.........: TQC-8B0021 08/11/11 By duke  
#                  (1)apsp702控制只能有一個process執行
#                  (2)apsp702跑到訊息30,且訊息狀態Y,後續作業執行結果為N時,增加刪除vlh_file資料  
#                  (3)apsp702跑到訊息50要自動close之前,要先判斷vlh_file有沒有資料,如果有,則不能作close動作
# Modify.........: MOD-8B0184 08/11/19 By kevin 回傳連線失敗
# Modify.........: TQC-8C0074 08/12/29 By duke 判斷vlz75=1 則不啟動手調器
# Modify.........: TQC-910011 09/01/08 By kevin apsp702 當遇到有失敗的情況,判斷 vlh_file 還有資料則不能關閉 
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:TQC-930117 09/03/20 By Duke log file close 後權限放開
# Modify.........: No:TQC-950064 09/05/12 By Duke 控制不同廠區可啟動各自的apsp702
# Modify.........: No:FUN-960076 09/06/09 By Joe TQC-950064 增加廠別顯示功能程式錯誤修正
# Modify.........: No:FUN-990012 09/09/07 By Mandy (1)非自動確認情況時(vlz75=0),在30階段需刪vlh_file,在50階段時關apsp702
#                                                  (2)  自動確認情況時(vlz75=1),在50階段才刪vlh_file,在50階段時關apsp702
# Modify.........: No:TQC-990049 09/09/11 By Mandy 當vzv06 IN ('F','C')時,刪vlh_file不需多判斷10,20,30才刪
# Modify.........: No:TQC-990063 09/09/15 By Mandy l_sql調整,限制vzv04 in ('10','20','30','40','50') 的才會掃描到
# Modify.........: No:TQC-990068 09/09/16 By Mandy 
#                  (1)log訊息的最前面都加g_plant 
#                  (2)結束apsp702加log,刪vlh_file加log
#                  (3)要刪vlh_file的時機點改為(有二處)--A:"50"(不用管是否自動確認(vlz75),是否背景執行(g_bgjob))
#                                                     --B:當vzv06 IN ('F','C')時
#                  (4)非自動確認(vlz75 = 0 )且非背景執行(g_bgjob = 'N')時,才能執行apst601
# Modify.........: No:FUN-990092 09/09/30 By Mandy erp_export :多送一個參數 code4 =使用者代號
# Modify.........: No:FUN-9C0021 09/12/07 By Mandy 回填vzy12(版本確認時間時),改在50階段執行
# Modify.........: No:TQC-A20050 10/02/23 By Mandy 執行apsp702時,會一直DISPLAY 掃瞄的SQL,改成在背景執行時,不要DISPLAY SQL,前景執行時才DISPLAY
# Modify.........: No:CHI-A70049 10/07/28 By Pengu 將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B50020 11/05/10 By Lilan GP5.1追版至GP5.25,以上為GP5.1更新紀錄-------
# Modify.........: No.FUN-B50161 11/05/24 By Mandy (1)補齊 apsp702程式內所有 SQL發生錯誤時,產生至log檔
#                                                  (2)依營運中心(g_plant)+日期 產生log檔
# Modify.........: No.FUN-B80053 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B90030 11/09/05 By minpp   程式撰寫規範修正
# Modify.........: No.FUN-BC0040 11/12/12 By Mandy 異常資料重拋問題:"50"階段會更新vla02基本資料最後異動日的同時,也更新vlq_file的最後異動日
# Modify.........: No.FUN-BC0059 11/12/16 By Mandy 非自動確認：
#                                                  (1)在30階段 (訊息狀態:”Y”後續作業執行結果:”Y) 關apsp702 
#                                                  (2) apst601按下確認後重起apsp702
# Modify.........: No.FUN-C30282 12/04/03 By Abby  apsp702 50拋回時若是F失敗,將vo*的TABLE全部刪除
# Modify.........: No:FUN-CC0150 13/01/09 By Mandy 傳給APS時增加傳<code9> 此碼傳legal code(法人)

DATABASE ds
#FUN-870068
GLOBALS "../../config/top.global"

DEFINE g_cmd         STRING
DEFINE g_start_time  DATETIME YEAR TO SECOND
DEFINE g_end_time    DATETIME YEAR TO SECOND
DEFINE g_vlg04       LIKE vlg_file.vlg04
DEFINE l_vlz75       LIKE vlz_file.vlz75  #TQC-8C0074 add
DEFINE g_vzv01       LIKE vzv_file.vzv01  #TQC-990068 add
DEFINE g_vzv02       LIKE vzv_file.vzv02  #TQC-990068 add
DEFINE g_str         STRING               #TQC-990068 add 
DEFINE g_plant_code  LIKE type_file.chr10 #TQC-990068 add


MAIN
   DEFINE   l_time       LIKE type_file.chr8
   DEFINE   p_row,p_col  LIKE type_file.num5
   DEFINE   l_i          LIKE type_file.num5
   DEFINE   l_gbq10      LIKE gbq_file.gbq10   #TQC-950064 ADD
   DEFINE   l_count      LIKE type_file.num5   #TQC-950064 ADD
   DEFINE   l_g_plant    LIKE type_file.chr20  #TQC-950064 ADD
   DEFINE   l_pid        STRING                #TQC-950064 ADD
   DEFINE   l_gbq01      LIKE gbq_file.gbq01   #TQC-950064 ADD
   #TQC-8B0021  ADD  --STR--
   DEFINE   lch_pipe     base.Channel,                
#            l_wc         LIKE type_file.num10, 
            l_wc         STRING,     #NO.FUN-910082       
            l_cmd        STRING     
   #TQC-8B0021  ADD  --END--
   #TQC-950064 ADD --STR-------------------------------------------
   DEFINE lch_cmd     base.Channel
   DEFINE ls_cmd      STRING,
          ls_result   STRING,
          ls_token    STRING
   DEFINE lst_token   base.StringTokenizer
   DEFINE li_i        LIKE type_file.num10   
   #TQC-950064  ADD  --END--             
   
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 

   #TQC-950064 MARK --STR------------------------------------------------------
   #TQC-8B0021  控制單一process執行  --ADD--STR--
   # #TQC-8C0074  MOD  --STR--
   # #LET l_cmd="ps -ef|grep apsp702|grep fglrun-bin|grep -v r.d2+|grep -v fgldeb|grep ",FGL_GETENV("USER"),"|wc -l"
   #  LET l_cmd="ps -ef|grep apsp702|grep fglrun-bin|grep -v r.d2+|grep -v fgldeb|wc -l"   
   # #TQC-8C0074  MOD  --END--
   # LET lch_pipe = base.Channel.create()
   # CALL lch_pipe.openPipe(l_cmd, "r")
   # WHILE lch_pipe.read(l_wc)
   #  #DISPLAY 'l_wc=',l_wc  
   # END WHILE
   # CALL lch_pipe.close()
   # IF l_wc>=2 THEN
   #   CALL cl_err(NULL, "azz-501", 1)
   #   EXIT PROGRAM
   # END IF
   #TQC-8B0021  控制單一process執行  --ADD--END--
   #TQC-950064 MARK --END------------------------------------------------------


   #FUN-890104 start
   #LET g_bgjob = ARG_VAL(1) #FUN-960076 呼叫執行apsp702時,背景執行參數應該為ARG_VAL(2) 
   LET g_bgjob = ARG_VAL(2) 
   #TQC-990068 add---str----
   LET g_plant_code = ARG_VAL(1)
   LET g_vzv01 = ARG_VAL(3) 
   LET g_vzv02 = ARG_VAL(4) 
   LET g_str = "apsp702 ",g_plant_code," ",g_bgjob," ",g_vzv01," ",g_vzv02,"==>" 
   #TQC-990068 add---end----
   
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #FUN-890104 end

   IF (NOT cl_user()) THEN
      CALL p702_scan_log("Exit PROGRAM:NOT cl_user") #TQC-990068 add
      EXIT PROGRAM
   END IF


   #TQC-950064 ADD --STR-------------------------------------------------------
    #控制單一process執行  
    LET ls_cmd = "COLUMNS=132;export COLUMNS; ps -ef | grep apsp702 | grep fglrun-bin | grep -v r.d2+ | grep -v fgldeb | grep -v export"
    LET lch_cmd = base.Channel.create()
    LET l_count = 0
    CALL lch_cmd.openPipe(ls_cmd, "r")
    WHILE lch_cmd.read(ls_result)
      LET lst_token = base.StringTokenizer.create(ls_result, ' ')
      LET li_i = 1
      WHILE lst_token.hasMoreTokens()
          LET ls_token = lst_token.nextToken()
          IF li_i = 2 THEN LET l_pid = ls_token END IF
          LET li_i = li_i + 1
      END WHILE
      LET l_gbq01 = l_pid
      LET l_g_plant = g_plant CLIPPED,'%' CLIPPED
      LET l_gbq10 = NULL
      SELECT gbq10 INTO l_gbq10 FROM gbq_file
       WHERE gbq01 = l_gbq01 
         AND gbq10 LIKE l_g_plant
      IF l_gbq10 IS NOT NULL THEN
         LET l_count = l_count + 1
      END IF
     #DISPLAY 'ls_result=',ls_result  #CHI-A70049 mark
     #DISPLAY 'gbq01=',l_gbq01        #CHI-A70049 mark
     #DISPLAY 'gbq10=',l_gbq10        #CHI-A70049 mark
     #DISPLAY 'g_plant=',l_g_plant    #CHI-A70049 mark
    END WHILE
    CALL lch_cmd.close()   #No:FUN-B90030


    IF l_count>=2 THEN
       CALL p702_scan_log("Exit PROGRAM:p702 COUNT >= 2") #TQC-990068 add
       EXIT PROGRAM
    END IF
   #TQC-950064 ADD --END-------------------------------------------------------
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      CALL p702_scan_log("Exit PROGRAM:NOT cl_setup()") #TQC-990068 add
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80053--l_time改為g_time--
  # CALL cl_used(g_prog,l_time,1) RETURNING l_time 
   CALL p702_scan_log("Start PROGRAM:apsp702") #TQC-990068 add
   
   WHILE TRUE 
   	 IF INT_FLAG THEN
             LET INT_FLAG = 0      
             EXIT WHILE
         END IF  	
   	 CALL p702_scan_data()
   	 SLEEP 5   	    
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--l_time改為g_time--
   #CALL cl_used(g_prog,l_time,2) RETURNING l_time
END MAIN


FUNCTION p702_scan_data()
DEFINE l_str    STRING   #FUN-B50161 add
DEFINE l_sql    STRING
DEFINE l_status LIKE type_file.chr1
DEFINE l_vzv01  LIKE vzv_file.vzv01,  
       l_vzv02  LIKE vzv_file.vzv02,
       l_vzv03  DATETIME YEAR TO SECOND, #FUN-B50020 mod
       l_vzv04  LIKE vzv_file.vzv04,
       l_vzv06  LIKE vzv_file.vzv06,       
       l_vzu07  LIKE vzu_file.vzu07,
       l_vzv07  LIKE vzv_file.vzv07,   #TQC-8B0021
       l_cnt    LIKE type_file.num10   #TQC-8B0021    

   #TQC-8B0021  ADD  vzv07
   LET l_sql = "SELECT vzv01,vzv02,vzv03,vzv04,vzv06,vzv07 FROM vzv_file  ",
              #" where vzv07 ='N' and vzv00='",g_plant,"' and vzv04>='10' ",                          #TQC-990063 mark
               " WHERE vzv07 ='N' AND vzv00='",g_plant,"' AND vzv04 IN ('10','20','30','40','50') ",  #TQC-990063 add
               " ORDER BY vzv01,vzv02,vzv03,vzv04"
  #CHI-A70049 mark---str---
  #IF g_bgjob = 'N' THEN #非背景執行時,DISPLAY SQL #TQC-A20050 add if 判斷
  #    DISPLAY l_sql  
  #END IF
  #CHI-A70049 mark---end---
   #CALL p702_scan_log("scan sql :"||l_sql ) 
   
   PREPARE aps_vzv_file FROM l_sql
   
   DECLARE vaz_file_cs CURSOR FOR aps_vzv_file
   	
   OPEN vaz_file_cs
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','vzv_file','','',SQLCA.sqlcode,'','',1)
      CALL p702_scan_log("Out PROGRAM:OPEN vaz_file_cs ERR!") #TQC-990068 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--
      EXIT PROGRAM
   END IF
   
   FETCH vaz_file_cs INTO l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06,l_vzv07  #TQC-8B0021 ADD l_vzv07   
   #FUN-B50161---add----str---
   IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
      LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'FETCH vaz_file_cs ERR!"
      CALL p702_scan_log(l_str) 
   END IF
   #FUN-B50161---add----end---
   CLOSE vaz_file_cs
   
   
   LET g_start_time = CURRENT YEAR TO SECOND
   LET g_end_time   = CURRENT YEAR TO SECOND
   

   #作業running
   IF l_vzv06="R" THEN   	  
     #CALL p702_scan_log("vzv06 is R ") #TQC-990068 mark
      CALL p702_vzv_data_log(l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06)
      SELECT vzu07 INTO l_vzu07
        FROM vzu_file
       WHERE vzu00=g_plant
         AND vzu01=l_vzv01
         AND vzu02=l_vzv02
         AND vzu03=l_vzv04
      #FUN-B50161---add---str---
      IF SQLCA.sqlcode THEN  
          LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'select vzu_file failed:1"
          CALL p702_scan_log(l_str) 
      END IF
      #FUN-B50161---add---end---
         
      IF (l_vzu07<>"R") THEN
         UPDATE vzu_file SET vzu07=l_vzv06,##回寫狀態碼
                             vzu05=g_start_time                             
          WHERE vzu00=g_plant
            AND vzu01=l_vzv01
            AND vzu02=l_vzv02
            AND vzu03=l_vzv04
         #FUN-B50161---add---str---
         IF SQLCA.sqlcode THEN  
              LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vzu_file failed:1"
              CALL p702_scan_log(l_str) 
         END IF
         #FUN-B50161---add---end---
      END IF
      
      IF (l_vzv04="10") THEN 
      	 UPDATE vzy_file set vzy11 = l_vzv02 ##回寫執行中版本
      	  WHERE vzy00=g_plant
   	        AND vzy01=l_vzv01
   	        AND vzy02=l_vzv02   	        
         #FUN-B50161---add---str---
         IF SQLCA.sqlcode THEN  
              LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vzy_file failed!"
              CALL p702_scan_log(l_str) 
         END IF
         #FUN-B50161---add---end---
      END IF
      
      UPDATE vzv_file SET vzv07='Y' 
       WHERE vzv00=g_plant
         AND vzv01=l_vzv01
         AND vzv02=l_vzv02
         AND vzv03=l_vzv03
         AND vzv04=l_vzv04
         AND vzv06=l_vzv06
   	   
      IF SQLCA.SQLCODE THEN  
          #FUN-B50161---add---str---
    	  #CALL p702_scan_log("update vzv_file failed:2")	              
           LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vzv_file failed:2"
           CALL p702_scan_log(l_str) 
          #FUN-B50161---add---end---
      END IF
   	   
      RETURN 
   END IF
   
   #作業失敗
   #注意:當有舊資料 vzv06="F" and vzv07='N' 會讓apsp702提前離開 

   IF l_vzv06="F" OR l_vzv06="C" THEN
     #CALL p702_scan_log("vzv06 is F ") #TQC-990068 mark
      CALL p702_vzv_data_log(l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06)
      
      SELECT vzu07 INTO l_vzu07
        FROM vzu_file
       WHERE vzu00=g_plant
         AND vzu01=l_vzv01
         AND vzu02=l_vzv02
         AND vzu03=l_vzv04
      #FUN-B50161---add---str---
      IF SQLCA.sqlcode THEN  
           LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'select vzu_file failed:2"
           CALL p702_scan_log(l_str) 
      END IF
      #FUN-B50161---add---end---
         
       IF (l_vzu07<>"F" OR l_vzu07<>"C") THEN 
       	  UPDATE vzu_file 
             SET vzu07 = l_vzv06, ##回寫狀態碼
       	         vzu06 = g_end_time
           WHERE vzu00=g_plant
             AND vzu01=l_vzv01
             AND vzu02=l_vzv02
             AND vzu03=l_vzv04 	
          #FUN-B50161---add---str---
          IF SQLCA.sqlcode THEN  
              LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vzu_file failed:2"
              CALL p702_scan_log(l_str) 
          END IF
          #FUN-B50161---add---end---
       END IF

       UPDATE vzv_file SET vzv07='Y'
        WHERE vzv00=g_plant
          AND vzv01=l_vzv01
          AND vzv02=l_vzv02
          AND vzv03=l_vzv03
          AND vzv04=l_vzv04
          AND vzv06=l_vzv06           
       IF SQLCA.SQLCODE THEN  
          #FUN-B50161---add---str---
          #CALL p702_scan_log("update vzv_file failed:3")	              
           LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vzv_file failed:3"
           CALL p702_scan_log(l_str) 
          #FUN-B50161---add---end---
       END IF
     
       #TQC-910011 --start--
      #TQC-990049---mod---str---
      #IF l_vzv04="10" OR l_vzv04="20" OR l_vzv04="30" THEN 
         #TQC-990068---mod---str---
         CALL p702_del_vlh(l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06)
         #DELETE FROM vlh_file
         #IF SQLCA.SQLCODE THEN  
   	 #   CALL p702_scan_log("delete vlh_file failed:1")	              
         #ELSE
         #   CALL p702_scan_log("DELETE FROM vlh_file:vzv06 in ('F','C')")
         #END IF
         #TQC-990068---mod---end---
      #END IF 
      #TQC-990049---mod---end---

      #FUN-C30282 add str---
      #將vo*_file的TABLE全部刪除
       IF l_vzv04="50" THEN
         CALL p702_del_vo(l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06)
       END IF
      #FUN-C30282 add end---
       
       SELECT COUNT(*) INTO l_cnt FROM vlh_file

       IF l_cnt = 0  THEN 
          #FUN-B50161---mod---str---
          #CALL p702_scan_log("Exit PROGRAM:Fail")
           LET l_str = "Out PROGRAM:Because vzv06 = 'F' OR vzv06 = 'C'"
           CALL p702_scan_log(l_str) 
          #FUN-B50161---mod---end---
          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--
          EXIT PROGRAM ##離開
       END IF
       #TQC-910011 --end--
   END IF 
   
   IF l_vzv06="Y" THEN #表示執行成功
      CALL p702_vzv_data_log(l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06)
      SELECT vzu07 INTO l_vzu07
        FROM vzu_file
       WHERE vzu00=g_plant
         AND vzu01=l_vzv01
         AND vzu02=l_vzv02
         AND vzu03=l_vzv04 
      #FUN-B50161---add---str---
      IF SQLCA.sqlcode THEN  
           LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'select vzu_file failed:3"
           CALL p702_scan_log(l_str) 
      END IF
      #FUN-B50161---add---end---
         
       IF l_vzu07<>"Y" THEN 
       	  UPDATE vzu_file 
             SET vzu07='Y', ##回寫狀態碼 Y
       	         vzu06=g_end_time 
           WHERE vzu00=g_plant
             AND vzu01=l_vzv01
             AND vzu02=l_vzv02
             AND vzu03=l_vzv04
          #FUN-B50161---add---str---
          IF SQLCA.sqlcode THEN  
             LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vzu_file failed:3"
             CALL p702_scan_log(l_str) 
          END IF
          #FUN-B50161---add---end---
       END IF   	
       
       UPDATE vzv_file SET vzv07='Y'
        WHERE vzv00=g_plant
          AND vzv01=l_vzv01
          AND vzv02=l_vzv02
          AND vzv03=l_vzv03
          AND vzv04=l_vzv04
          AND vzv06=l_vzv06   	    
       IF SQLCA.SQLCODE THEN  
          #FUN-B50161---mod---str---
   	  #CALL p702_scan_log("update vzv_file failed:4")	              
           LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vzv_file failed:4"
           CALL p702_scan_log(l_str) 
          #FUN-B50161---mod---end---
       END IF

       CASE l_vzv04     
          WHEN "10"     ##呼叫下一步
               #MOD-8B0184 start
       	       #LET g_cmd = "apsp600 'erp_export' '",
       	       #                      g_plant CLIPPED,"' '",
       	       #                      l_vzv01 CLIPPED,"' '",
               #                      '0' CLIPPED,"' ",
               #                      " '' ''  '",
               #                      l_vzv02 CLIPPED,"' "                                     
               #                      ##呼叫SSIS時,統一儲存版本為'0'                                  
               #DISPLAY g_cmd  #CHI-A70049 mark                           
               
              #IF aws_insert_command('erp_export',g_plant,l_vzv01,'0','','',l_vzv02,'','') THEN      #FUN-990092 mark
              #IF aws_insert_command('erp_export',g_plant,l_vzv01,'0',g_user,'',l_vzv02,'','') THEN  #FUN-990092 add #FUN-CC0150 mark
               IF aws_insert_command('erp_export',g_plant,l_vzv01,'0',g_user,'',l_vzv02,'','',g_legal) THEN          #FUN-CC0150 add g_legal
               	  CALL p700_ins_vzv('R',l_vzv01,l_vzv02,"20")
               ELSE
               	  CALL p700_ins_vzv('F',l_vzv01,l_vzv02,"20")
               	  
               	  UPDATE vzu_file SET vzu07='F'
      	           WHERE vzu00=g_plant
                     AND vzu01=l_vzv01
                     AND vzu02=l_vzv02
                     AND vzu03="20"
                     
                  IF SQLCA.SQLCODE THEN  
                     #FUN-B50161---mod---str---
    	             #CALL p702_scan_log("update vzv_file failed:2")	             #FUN-B50161 mark
                      LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vzu_file failed:4"
                      CALL p702_scan_log(l_str) 
                     #FUN-B50161---mod---end---
                  END IF
               END IF               
               #CALL cl_cmdrun_wait(g_cmd)
               #MOD-8B0184 end

          WHEN "30"               
               #FUN-990012--add---str---
               SELECT vlz75 
                 INTO l_vlz75 
                 FROM vlz_file
                WHERE vlz01 = l_vzv01
                  AND vlz02 = l_vzv02

               IF l_vlz75 = 0 THEN 
                  #TQC-990068----mod---str---
                  #非自動確認(vlz75 = 0 )且非背景執行(g_bgjob = 'N')時,才能執行apst601
                   IF g_bgjob = 'N' THEN
                       LET g_cmd = "apst601 '",g_plant CLIPPED,"' '",
                                              l_vzv01 CLIPPED,"' ",
                                              " '0' " #儲存版本為'0'
                      #DISPLAY g_cmd  #CHI-A70049 mark
                       CLOSE WINDOW screen
                       CALL cl_cmdrun(g_cmd)        
                   END IF
                  #FUN-BC0059---add----str---
                   IF NOT cl_null(g_sma.sma918) AND g_sma.sma918 = 'Y' THEN
                       CALL p702_scan_log("PROGRAM STOP:at '30' AND vlz75 = '0' ")
                       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
                       EXIT PROGRAM
                   END IF
                  #FUN-BC0059---add----end---

                  #非自動確認,30階段需刪vlh_file
                  #DELETE FROM vlh_file   
                  #CALL p702_scan_log("DELETE FROM vlh_file:30")
                  #TQC-990068----mod---str---
               END IF
               #FUN-990012--add---end---
            #FUN-990012--mark--str---
            #  #FUN-890104 start
            #  IF g_bgjob="Y" THEN
            #     CALL p702_scan_log("Exit PROGRAM When g_bgjob='Y' ")
            #     DELETE FROM vlh_file   #TQC-8C0074 ADD
            #  	  EXIT PROGRAM
            #  END IF
            #  #FUN-890104 end

            #  LET g_cmd = "apst601 '",g_plant CLIPPED,"' '",
            #                         l_vzv01 CLIPPED,"' ",
            #                         " '0' " #儲存版本為'0'
  
            # #TQC-8B0021  ADD  --STR--
            # #apsp702跑到訊息30,且訊息狀態Y,後續作業執行結果為N時,增加刪除vlh_file資料
            #  IF l_vzv06 = 'Y' AND l_vzv07='N' THEN
            #     DELETE FROM vlh_file
            #  END IF
            # #TQC-8B0021  ADD --END--

            # #TQC-8C0074  MARK --STR--
       	    # #DISPLAY g_cmd  #CHI-A70049 mark
       	    # #CALL cl_cmdrun_wait(g_cmd)    
            # #TQC-8C0074  MARK --END--

            # #TQC-8C0074  ADD --STR--
            #  SELECT vlz75 INTO l_vlz75 FROM vlz_file
            #   WHERE vlz01 = l_vzv01
            #     AND vlz02 = l_vzv02

            #  IF l_vlz75 =0 THEN 
            #    #DISPLAY g_cmd  #CHI-A70049 mark
            #     #CALL cl_cmdrun_wait(g_cmd)  #TQC-910011
            #     CLOSE WINDOW screen
            #     CALL cl_cmdrun(g_cmd)        #TQC-910011
            #  END IF
            # #TQC-8C0074  ADD --END--
   	    #   
            #  EXIT PROGRAM #FUN-960076 在完成30時需要停止apsp702
            #FUN-990012--mark--end---
       	  
       	  WHEN "40"
              #FUN-9C0021--mark---str---
       	      #UPDATE vzy_file set vzy12 = g_end_time ##回寫版本確認時間
       	      # WHERE vzy00=g_plant
   	      #   AND vzy01=l_vzv01
   	      #   AND vzy02=l_vzv02
   	      # 
   	      #IF SQLCA.SQLCODE THEN  
   	      #   CALL p702_scan_log("update vzy_file failed:5")	              
              #END IF
              #FUN-9C0021--mark---end---

          WHEN "50"
              #FUN-9C0021--add----str---
       	       UPDATE vzy_file set vzy12 = g_end_time ##回寫版本確認時間
       	        WHERE vzy00=g_plant
   	          AND vzy01=l_vzv01
   	          AND vzy02=l_vzv02
   	        
   	       IF SQLCA.SQLCODE THEN  
                  #FUN-B50161---mod---str---
   	          #CALL p702_scan_log("Update vzy12 Error!")	              
                   LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'Update vzy12 Error!"
                   CALL p702_scan_log(l_str) 
                  #FUN-B50161---mod---end---
               END IF
              #FUN-9C0021--add----end---
               CALL p700_upd_config(l_vzv01,l_vzv02) #FUN-870061
               CALL p702_del_vlh(l_vzv01,l_vzv02,l_vzv03,l_vzv04,l_vzv06) #TQC-990068 add
               CALL p702_scan_log("Out PROGRAM:50")
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--
               EXIT PROGRAM ##離開
               
               #DELETE FROM vlh_file    #TQC-8B0021  MARK
       
               #IF SQLCA.SQLCODE THEN  
               #   CALL p702_scan_log("delete vlh_file failed:2")	              
               #END IF
              #TQC-990068---mark---str---
              ##TQC-8B0021  ---ADD--STR--
              ##apsp702跑到訊息50要自動close之前,要先判斷vlh_file有沒有資料,
              ##如果有,則不能作close動作  
              #SELECT COUNT(*) INTO l_cnt FROM vlh_file
              #IF  cl_null(l_cnt) OR l_cnt = 0  THEN 
              #    #TQC-910011 start
              #    SELECT COUNT(*) INTO l_cnt FROM vzv_file 
              #     WHERE vzv04 >= '40' and vzv07 = 'N'

              #    IF l_cnt > 0 THEN
              #       #還有另一版的資料待處理,先不離開
              #       CALL p702_scan_log("Retry another data:50")
              #    ELSE 
              #       CALL p702_scan_log("Exit PROGRAM:50")
              #       EXIT PROGRAM ##離開
              #    END IF
              #    #TQC-910011 end
              ##FUN-990012--add---str---
              #ELSE
              #    SELECT vlz75 
              #      INTO l_vlz75 
              #      FROM vlz_file
              #     WHERE vlz01 = l_vzv01
              #       AND vlz02 = l_vzv02
              #    IF l_vlz75 = 1 THEN #自動確認
              #        #自動確認,50階段才刪vlh_file,並且關apsp702
              #        DELETE FROM vlh_file   
              #        CALL p702_scan_log("DELETE FROM vlh_file:50")
              #    END IF
              #    CALL p702_scan_log("Exit PROGRAM:50")
              #    EXIT PROGRAM ##離開
              ##FUN-990012--add---end---
              #END IF
              ##TQC-8B0021  ---ADD--STR--
              #TQC-990068---mark---end---

       END CASE
                
   END IF
  
   IF l_vzv06="N" THEN   	     	  
   	  RETURN   	  
   END IF   

END FUNCTION

FUNCTION p700_ins_vzv(p_code,p_vzv01,p_vzv02,p_vzv04) #APS各類訊息檔
DEFINE l_str       STRING   #FUN-B50161 add
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
  LET l_vzv.vzvplant = g_plant  #FUN-B50020 add
  LET l_vzv.vzvlegal = g_legal  #FUN-B50020 add

  INSERT INTO vzv_file(vzv00,vzv01,vzv02,vzv04,
                       vzv05,vzv06,vzv07,vzv08,vzvplant,vzvlegal) #FUN-B50020 add vzvplant,vzvlegal
   VALUES(l_vzv.vzv00,l_vzv.vzv01,l_vzv.vzv02,l_vzv.vzv04,
          l_vzv.vzv05,l_vzv.vzv06,l_vzv.vzv07,l_vzv.vzv08,l_vzv.vzvplant,l_vzv.vzvlegal) #FUN-B50020 add vzvplant,vzvlegal
  IF STATUS THEN
     CALL cl_err3("ins","vzv_file",l_vzv.vzv01,l_vzv.vzv02,STATUS,"","",1)
     #FUN-B50161---add----str---
     LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'insert vzv_file failed"
     CALL p702_scan_log(l_str) 
     #FUN-B50161---add----end---
  END IF
 
END FUNCTION

#FUN-870061 更新vla02基本資料最後異動日
FUNCTION p700_upd_config(p_vzv01,p_vzv02)
  DEFINE l_str      STRING   #FUN-B50161 add
  DEFINE l_cnt      LIKE type_file.num10   
  DEFINE p_vzv01    LIKE vzv_file.vzv01
  DEFINE p_vzv02    LIKE vzv_file.vzv02
  DEFINE l_vzu05    DATETIME YEAR TO SECOND
  DEFINE l_date     LIKE type_file.dat  #FUN-BC0040 add
  DEFINE l_vla02_old LIKE type_file.dat #FUN-BC0040 add
  DEFINE l_vlq_cnt   LIKE type_file.num10 #FUN-BC0040 add
     
     SELECT COUNT(*) INTO l_cnt
       FROM vla_file
      WHERE vla01 = p_vzv01
      
    #SELECT vzu05       INTO l_vzu05         #FUN-BC0040 mark
     SELECT vzu05,vzu05 INTO l_vzu05,l_date  #FUN-BC0040 add
       FROM vzu_file
      WHERE vzu03 = '10'
        AND vzu01 = p_vzv01
        AND vzu02 = p_vzv02
        AND vzu00 = g_plant        
        
     IF l_cnt >= 1 THEN
         #FUN-BC0040---add----str---
         SELECT vla02 INTO l_vla02_old  
           FROM vla_file
          WHERE vla01 = p_vzv01
         #FUN-BC0040---add----end---
         UPDATE vla_file 
            SET vla02 = l_vzu05
            WHERE vla01 = p_vzv01
         IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","vla_file",p_vzv01,"",SQLCA.sqlcode,"","upd vla_file",1)
             #FUN-B50161---add---str---
             LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vla_file failed:1"
             CALL p702_scan_log(l_str) 
             #FUN-B50161---add---end---
         #FUN-BC0040---add---str---
         ELSE
             IF NOT cl_null(l_vla02_old) THEN
                 LET l_vlq_cnt = 0
                 SELECT COUNT(*) INTO l_vlq_cnt FROM vlq_file
                  WHERE vlq01 = p_vzv01
                    AND vlq02 = l_vla02_old
                 IF l_vlq_cnt >=1 THEN
                     DELETE FROM vlq_file
                      WHERE vlq01 = p_vzv01
                        AND vlq02 = l_vla02_old
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         LET l_str = "Delete From vlq_file Error!==>","'",SQLCA.sqlcode,"'"
                     ELSE
                         LET l_str = "Delete From vlq_file ",SQLCA.sqlerrd[3] USING "##########"," Rows Success!"
                     END IF
                     CALL p702_scan_log(l_str) 
                 END IF
             END IF
         #FUN-BC0040---add---end---
         END IF
     ELSE
         INSERT INTO vla_file VALUES(p_vzv01,l_vzu05,g_legal,g_plant) #FUN-B5002 mod
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vla_file",p_vzv01,"",SQLCA.sqlcode,"","ins vla_file",1) 
             #FUN-B50161---add---str---
             LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'insert vla_file failed:1"
             CALL p702_scan_log(l_str) 
             #FUN-B50161---add---end---
         END IF
     END IF

     #FUN-BC0040----add----str---
     UPDATE vlq_file 
       SET vlq02 = l_date
      WHERE vlq01 = p_vzv01
     IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","vlq_file",p_vzv01,"",SQLCA.sqlcode,"","upd vlq_file",1)
         LET l_str = "SQLCA.sqlcode='",SQLCA.sqlcode,"'update vlq_file failed"
         CALL p702_scan_log(l_str) 
     END IF
     #FUN-BC0040----add----end---
END FUNCTION


FUNCTION p702_vzv_data_log(p_vzv01,p_vzv02,p_vzv03,p_vzv04,p_vzv06)    
DEFINE l_str    STRING   #TQC-990068 add 
DEFINE p_vzv01  LIKE vzv_file.vzv01,  
       p_vzv02  LIKE vzv_file.vzv02,
       p_vzv03  LIKE vzv_file.vzv03,
       p_vzv04  LIKE vzv_file.vzv04,
       p_vzv06  LIKE vzv_file.vzv06
      #TQC-990068---mod----str---
       LET l_str = " vzv01:",p_vzv01 CLIPPED,
                   " vzv02:",p_vzv02 CLIPPED,
                   " vzv03:",p_vzv03 CLIPPED,
                   " vzv04:",p_vzv04 CLIPPED,
                   " vzv06:",p_vzv06 CLIPPED
       CALL p702_scan_log(l_str )
      #CALL p702_scan_log("vzv01 :"||p_vzv01 )
      #CALL p702_scan_log("vzv02 :"||p_vzv02 )
      #CALL p702_scan_log("vzv03 :"||p_vzv03 )
      #CALL p702_scan_log("vzv04 :"||p_vzv04 )
      #CALL p702_scan_log("vzv06 :"||p_vzv06 )    
      #TQC-990068---mod----end---
END FUNCTION

FUNCTION p702_scan_log(p_result)    
   DEFINE p_result     STRING
   DEFINE l_file       STRING,              
          l_str        STRING,
          l_request    STRING
   DEFINE l_i          LIKE type_file.num10
   DEFINE channel      base.Channel

   LET channel = base.Channel.create()
  #FUN-B50161---mod---str---
  #LET l_file = fgl_getenv("TEMPDIR"), "/",
   LET l_file = fgl_getenv("TEMPDIR"), "/",g_plant CLIPPED,"-",
  #FUN-B50161---mod---end---
                 "apsp702-", TODAY USING 'YYYYMMDD', ".log"

   CALL channel.openFile(l_file, "a")  
   LET p_result = g_plant CLIPPED,":",p_result CLIPPED #TQC-990068 add
   
   IF STATUS = 0 THEN
       CALL channel.setDelimiter("")
       LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
       CALL channel.write(l_str)
      #TQC-990068---mod---str--- 
       CALL channel.write(g_str)
      #CALL channel.write("") 
      #CALL channel.write(p_result)        
       CALL channel.write(p_result)        
       CALL channel.write("")  
      #TQC-990068---mod---end---
  #ELSE                                #CHI-A70049 mark
  #    DISPLAY "Can't open log file."  #CHI-A70049 mark
   END IF
   CALL channel.close()
   RUN "chmod 666 " || l_file || " >/dev/null 2>&1"   #TQC-930117       
END FUNCTION

#TQC-990068---add---str---
FUNCTION p702_del_vlh(p_vzv01,p_vzv02,p_vzv03,p_vzv04,p_vzv06)
  DEFINE p_vzv01  LIKE vzv_file.vzv01
  DEFINE p_vzv02  LIKE vzv_file.vzv02
  DEFINE p_vzv03  LIKE vzv_file.vzv03
  DEFINE p_vzv04  LIKE vzv_file.vzv04
  DEFINE p_vzv06  LIKE vzv_file.vzv06
  DEFINE l_vlh    RECORD LIKE vlh_file.*
  DEFINE l_str    STRING   

  SELECT * INTO l_vlh.*
    FROM vlh_file

  DELETE FROM vlh_file
  IF SQLCA.sqlcode THEN  
      LET l_str = "Delete From vlh_file Error!==>"
  ELSE
      LET l_str = "Delete From vlh_file ",SQLCA.sqlerrd[3] USING "##"," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vlh03:",l_vlh.vlh03 CLIPPED,
              " vlh04:",l_vlh.vlh04 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)
END FUNCTION
#TQC-990068---add---str---

#FUN-C30282 add str---
FUNCTION p702_del_vo(p_vzv01,p_vzv02,p_vzv03,p_vzv04,p_vzv06)
  DEFINE p_vzv01  LIKE vzv_file.vzv01
  DEFINE p_vzv02  LIKE vzv_file.vzv02
  DEFINE p_vzv03  LIKE vzv_file.vzv03
  DEFINE p_vzv04  LIKE vzv_file.vzv04
  DEFINE p_vzv06  LIKE vzv_file.vzv06
  DEFINE l_voa    RECORD LIKE voa_file.*
  DEFINE l_vob    RECORD LIKE vob_file.*
  DEFINE l_voc    RECORD LIKE voc_file.*
  DEFINE l_vod    RECORD LIKE vod_file.*
  DEFINE l_voe    RECORD LIKE voe_file.*
  DEFINE l_vof    RECORD LIKE vof_file.*
  DEFINE l_vog    RECORD LIKE vog_file.*
  DEFINE l_voh    RECORD LIKE voh_file.*
  DEFINE l_voi    RECORD LIKE voi_file.*
  DEFINE l_voj    RECORD LIKE voj_file.*
  DEFINE l_vok    RECORD LIKE vok_file.*
  DEFINE l_vol    RECORD LIKE vol_file.*
  DEFINE l_vom    RECORD LIKE vom_file.*
  DEFINE l_von    RECORD LIKE von_file.*
  DEFINE l_voo    RECORD LIKE voo_file.*
  DEFINE l_vop    RECORD LIKE vop_file.*
  DEFINE l_voq    RECORD LIKE voq_file.*
  DEFINE l_str    STRING

  SELECT * INTO l_voa.*
    FROM voa_file

  DELETE FROM voa_file WHERE voa01 = p_vzv01 AND voa02 = p_vzv02 AND voa00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From voa_file Error!==>"
  ELSE
      LET l_str = "Delete From voa_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " voa01:",l_voa.voa01 CLIPPED,
              " voa02:",l_voa.voa02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)

  SELECT * INTO l_vob.*
    FROM vob_file

  DELETE FROM vob_file WHERE vob01 = p_vzv01 AND vob02 = p_vzv02 AND vob00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From vob_file Error!==>"
  ELSE
      LET l_str = "Delete From vob_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vob01:",l_vob.vob01 CLIPPED,
              " vob02:",l_vob.vob02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)

  SELECT * INTO l_voc.*
    FROM voc_file

  DELETE FROM voc_file WHERE voc01 = p_vzv01 AND voc02 = p_vzv02 AND voc00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From voc_file Error!==>"
  ELSE
      LET l_str = "Delete From voc_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " voc01:",l_voc.voc01 CLIPPED,
              " voc02:",l_voc.voc02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_vod.*
    FROM vod_file

  DELETE FROM vod_file WHERE vod01 = p_vzv01 AND vod02 = p_vzv02 AND vod00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From vod_file Error!==>"
  ELSE
      LET l_str = "Delete From vod_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vod01:",l_vod.vod01 CLIPPED,
              " vod02:",l_vod.vod02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_voe.*
    FROM voe_file

  DELETE FROM voe_file WHERE voe01 = p_vzv01 AND voe02 = p_vzv02 AND voe00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From voe_file Error!==>"
  ELSE
      LET l_str = "Delete From voe_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " voe01:",l_voe.voe01 CLIPPED,
              " voe02:",l_voe.voe02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_vof.*
    FROM vof_file

  DELETE FROM vof_file WHERE vof01 = p_vzv01 AND vof02 = p_vzv02 AND vof00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From vof_file Error!==>"
  ELSE
      LET l_str = "Delete From vof_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vof01:",l_vof.vof01 CLIPPED,
              " vof02:",l_vof.vof02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_vog.*
    FROM vog_file

  DELETE FROM vog_file WHERE vog01 = p_vzv01 AND vog02 = p_vzv02 AND vog00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From vog_file Error!==>"
  ELSE
      LET l_str = "Delete From vog_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vog01:",l_vog.vog01 CLIPPED,
              " vog02:",l_vog.vog02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_voh.*
    FROM voh_file

  DELETE FROM voh_file WHERE voh01 = p_vzv01 AND voh02 = p_vzv02 AND voh00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From voh_file Error!==>"
  ELSE
      LET l_str = "Delete From voh_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " voh01:",l_voh.voh01 CLIPPED,
              " voh02:",l_voh.voh02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_voi.*
    FROM voi_file

  DELETE FROM voi_file WHERE voi01 = p_vzv01 AND voi02 = p_vzv02 AND voi00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From voi_file Error!==>"
  ELSE
      LET l_str = "Delete From voi_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " voi01:",l_voi.voi01 CLIPPED,
              " voi02:",l_voi.voi02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_voj.*
    FROM voj_file

  DELETE FROM voj_file WHERE voj01 = p_vzv01 AND voj02 = p_vzv02 AND voj00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From voj_file Error!==>"
  ELSE
      LET l_str = "Delete From voj_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " voj01:",l_voj.voj01 CLIPPED,
              " voj02:",l_voj.voj02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_vok.*
    FROM vok_file

  DELETE FROM vok_file WHERE vok01 = p_vzv01 AND vok02 = p_vzv02 AND vok00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From vok_file Error!==>"
  ELSE
      LET l_str = "Delete From vok_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vok01:",l_vok.vok01 CLIPPED,
              " vok02:",l_vok.vok02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_vol.*
    FROM vol_file

  DELETE FROM vol_file WHERE vol01 = p_vzv01 AND vol02 = p_vzv02 AND vol00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From vol_file Error!==>"
  ELSE
      LET l_str = "Delete From vol_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vol01:",l_vol.vol01 CLIPPED,
              " vol02:",l_vol.vol02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)



  SELECT * INTO l_vom.*
    FROM vom_file

  DELETE FROM vom_file WHERE vom01 = p_vzv01 AND vom02 = p_vzv02 AND vom00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From vom_file Error!==>"
  ELSE
      LET l_str = "Delete From vom_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vom01:",l_vom.vom01 CLIPPED,
              " vom02:",l_vom.vom02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_von.*
    FROM von_file

  DELETE FROM von_file WHERE von01 = p_vzv01 AND von02 = p_vzv02 AND von00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From von_file Error!==>"
  ELSE
      LET l_str = "Delete From von_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " von01:",l_von.von01 CLIPPED,
              " von02:",l_von.von02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_voo.*
    FROM voo_file

  DELETE FROM voo_file WHERE voo01 = p_vzv01 AND voo02 = p_vzv02 AND voo00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From voo_file Error!==>"
  ELSE
      LET l_str = "Delete From voo_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " voo01:",l_voo.voo01 CLIPPED,
              " voo02:",l_voo.voo02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_vop.*
    FROM vop_file

  DELETE FROM vop_file WHERE vop01 = p_vzv01 AND vop02 = p_vzv02 AND vop00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From vop_file Error!==>"
  ELSE
      LET l_str = "Delete From vop_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " vop01:",l_vop.vop01 CLIPPED,
              " vop02:",l_vop.vop02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


  SELECT * INTO l_voq.*
    FROM voq_file

  DELETE FROM voq_file WHERE voq01 = p_vzv01 AND voq02 = p_vzv02 AND voq00 = g_plant
  IF SQLCA.sqlcode THEN
      LET l_str = "Delete From voq_file Error!==>"
  ELSE
      LET l_str = "Delete From voq_file ",SQLCA.sqlerrd[3]," Rows Success!=>"
  END IF
  LET l_str = l_str CLIPPED,
              " voq01:",l_voq.voq01 CLIPPED,
              " voq02:",l_voq.voq02 CLIPPED,
              " vzv01:",p_vzv01 CLIPPED,
              " vzv02:",p_vzv02 CLIPPED,
              " vzv03:",p_vzv03 CLIPPED,
              " vzv04:",p_vzv04 CLIPPED,
              " vzv06:",p_vzv06 CLIPPED
  CALL p702_scan_log(l_str)


END FUNCTION
#FUN-C30282 add end---

#FUN-B50020
