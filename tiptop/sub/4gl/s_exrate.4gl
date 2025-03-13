# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_extrate.4gl
# Descriptions...: 
# Input Parameter: 
# Return code....: 
# Modify.........: No.FUN-4B0071 04/11/25 By Mandy DEFINE匯率欄位,改用LIKE方式
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-740074 07/04/23 By jacklai 加入呼叫java程式下載台銀網站程式
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-960178 09/06/30 By jacklai 在MSV版中將環境變數$DS4GL改為用FGL_GETENV()取得
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-B10021 11/01/17 By jrg542 加呼叫java程式下載海關匯率

IMPORT os   #No.FUN-9C0009 
DATABASE ds    #FUN-7C0053
 
FUNCTION s_exrate(o_curr,d_curr,p_rate)		
 DEFINE o_curr        	LIKE azk_file.azk01        #No.FUN-680147 VARCHAR(4)  # 來源幣別
 DEFINE d_curr         	LIKE azk_file.azk01        #No.FUN-680147 VARCHAR(4) # 目的幣別
 DEFINE p_rate	        LIKE type_file.chr1        #No.FUN-680147 VARCHAR(1) # B:銀行買入 S:銀行賣出 M:銀行中價
                                  # P:海關旬 C:海關買入D:海關賣出
 DEFINE p_exrate        LIKE azk_file.azk03 #FUN-4B0071
 DEFINE p_aza		RECORD LIKE aza_file.*
 DEFINE p_azk1	        RECORD LIKE azk_file.*
 DEFINE p_azk2	        RECORD LIKE azk_file.*
 DEFINE l_date          LIKE type_file.dat          #No.FUN-680147 DATE
 
 WHENEVER ERROR CALL cl_err_msg_log
 
 SELECT * INTO p_aza.* FROM aza_file WHERE aza01='0'
 IF STATUS <> 0 THEN RETURN 0 END IF
 IF o_curr = d_curr THEN 
    RETURN 1
 END IF
 LET l_date=TODAY
 IF o_curr = p_aza.aza17 THEN
    LET p_azk1.azk03=1
    LET p_azk1.azk04=1
    LET p_azk1.azk041=1
    LET p_azk1.azk05=1
    LET p_azk1.azk051=1
    LET p_azk1.azk052=1
 ELSE
    DECLARE azk_cur1 CURSOR FOR 
     SELECT * FROM azk_file 
      WHERE azk01=o_curr AND azk02 <= l_date ORDER BY azk02 DESC
    OPEN azk_cur1
    FETCH azk_cur1 INTO p_azk1.*
    IF STATUS <> 0 THEN
       CLOSE azk_cur1
       RETURN 0
    END IF
    CLOSE azk_cur1
 END IF
 IF d_curr = p_aza.aza17 THEN
    LET p_azk2.azk03=1
    LET p_azk2.azk04=1
    LET p_azk2.azk041=1
    LET p_azk2.azk05=1
    LET p_azk2.azk051=1
    LET p_azk2.azk052=1
 ELSE
    DECLARE azk_cur2 CURSOR FOR 
     SELECT * FROM azk_file 
      WHERE azk01=d_curr AND azk02 <= l_date ORDER BY azk02 DESC
    OPEN azk_cur2
    FETCH azk_cur2 INTO p_azk2.*
    IF STATUS <> 0 THEN
       CLOSE azk_cur2
       RETURN 0
    END IF
    CLOSE azk_cur2
 END IF
 LET p_exrate=0
 
 #No.+048  依oaz212 參數決定使用之匯率
 CASE WHEN p_rate='B' 
           IF p_azk2.azk03 <> 0 THEN
              LET p_exrate=p_azk1.azk03/p_azk2.azk03
           END IF
      WHEN p_rate='S' 
           IF p_azk2.azk04 <> 0 THEN
              LET p_exrate=p_azk1.azk04/p_azk2.azk04
           END IF
      WHEN p_rate='M' 
           IF p_azk2.azk041 <> 0 THEN
              LET p_exrate=p_azk1.azk041/p_azk2.azk041
           END IF
      WHEN p_rate='P' 
           IF p_azk2.azk05 <> 0 THEN
              LET p_exrate=p_azk1.azk05/p_azk2.azk05
           END IF
      WHEN p_rate='C' 
           IF p_azk2.azk051 <> 0 THEN
              LET p_exrate=p_azk1.azk051/p_azk2.azk051
           END IF
      WHEN p_rate='D' 
           IF p_azk2.azk052 <> 0 THEN
              LET p_exrate=p_azk1.azk052/p_azk2.azk052
           END IF
 END CASE
    RETURN  p_exrate
 
END FUNCTION
 
#No.FUN-740074 --start--
FUNCTION s_jget_exrate(p_url)
   DEFINE p_url STRING     #URL
   DEFINE l_cmd STRING
   DEFINE l_out STRING
   DEFINE l_ch  base.Channel
   DEFINE l_buf STRING
   DEFINE l_pos LIKE type_file.num10
   DEFINE l_num STRING
   DEFINE l_msg STRING
   DEFINE l_len STRING
   DEFINE l_sb  base.StringBuffer
   
   #呼叫Java程式, 執行結果會輸出在stdout
   LET l_ch = base.Channel.create()
   CALL l_ch.setDelimiter("")
   LET l_cmd = "java -jar ", FGL_GETENV("DS4GL"), "/bin/javaexrate/jar/exrate.jar ",p_url  #FUN-960178 ADD
   LET l_cmd = l_cmd CLIPPED
   #DISPLAY "cmd: ",l_cmd

   CALL l_ch.openPipe(l_cmd,"r")
   IF STATUS == 0 THEN
      WHILE TRUE
         CALL l_ch.readLine() RETURNING l_buf
         IF l_buf IS NULL THEN
            EXIT WHILE
         END IF
         LET l_out = l_out,l_buf
      END WHILE
   END IF
   CALL l_ch.close()
   #DISPLAY l_out
   
   #根據stdout訊息取得下載檔名
   LET l_pos = l_out.getIndexOf(" ",1)
   LET l_len = l_out.getLength()
   LET l_num = l_out.subString(1,l_pos - 1)
   LET l_msg = l_out.subString(l_pos + 1,l_len)
   #DISPLAY "num: ",l_num
   #DISPLAY "msg: ",l_msg
    
   #remove double quote
   LET l_sb = base.StringBuffer.create()
   CALL l_sb.append(l_msg)
   CALL l_sb.replace("\"","",0)
   LET l_msg = l_sb.toString()
   
   IF l_num == 0 AND l_msg IS NOT NULL THEN
#     LET l_cmd = "chmod 777 ",l_msg                    #No.FUN-9C0009
#     RUN l_cmd                                         #No.FUN-9C0009
      IF os.Path.chrwx(l_msg CLIPPED,511) THEN END IF   #No.FUN-9C0009
   END IF
    
   RETURN l_num,l_msg
END FUNCTION 


##################################################
# Descriptions...: 抓取海關每旬公告匯率
# Date & Author..: 2011/2/16 by Jrg542
# Input Parameter: p_url   STRING 測試用的URL, 正常狀態為NULL
# Return code....: l_num,l_msg
# Modify.........: No.FUN-B10021
################################################## 

FUNCTION s_jget_excustrate(p_url)
   DEFINE p_url STRING     #URL
   DEFINE l_cmd STRING
   DEFINE l_out STRING
   DEFINE l_ch  base.Channel
   DEFINE l_buf STRING
   DEFINE l_pos LIKE type_file.num10
   DEFINE l_num STRING
   DEFINE l_msg STRING
   DEFINE l_len STRING
   DEFINE l_sb  base.StringBuffer
   
   #呼叫Java程式, 執行結果會輸出在stdout
   LET l_ch = base.Channel.create()
   CALL l_ch.setDelimiter("")
   LET l_cmd = "java -jar ",FGL_GETENV("DS4GL"),"/bin/javaexrate/jar/custrate.jar ",p_url
   LET l_cmd = l_cmd CLIPPED
   #DISPLAY "cmd: ",l_cmd

   CALL l_ch.openPipe(l_cmd,"r")
   IF STATUS == 0 THEN
      WHILE TRUE
         CALL l_ch.readLine() RETURNING l_buf
         IF l_buf IS NULL THEN
            EXIT WHILE
         END IF
         LET l_out = l_out,l_buf
      END WHILE
   END IF
   CALL l_ch.close()
   #DISPLAY l_out
   
   #根據stdout訊息取得下載檔名
   LET l_pos = l_out.getIndexOf(" ",1)
   LET l_len = l_out.getLength()
   LET l_num = l_out.subString(1,l_pos - 1)
   LET l_msg = l_out.subString(l_pos + 1,l_len)
   DISPLAY "num: ",l_num
   DISPLAY "msg: ",l_msg
    
   #remove double quote
   LET l_sb = base.StringBuffer.create()
   CALL l_sb.append(l_msg)
   CALL l_sb.replace("\"","",0)
   LET l_msg = l_sb.toString()
   
   IF l_num == 0 AND l_msg IS NOT NULL THEN
      LET l_cmd = "chmod 777 ",l_msg
      RUN l_cmd
   END IF
    
   RETURN l_num,l_msg
END FUNCTION 
#No.FUN-B10021 --end--
