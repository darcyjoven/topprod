# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: p_gr_javamail.4gl
# Descriptions...: Genero Report 串javamail時等待檔案產生時間
# Date & Author..: 12/04/11 Janet
# Modify.........: No.TQC-C40053 12/04/11 By janet Genero Report 串javamail時等待檔案產生時間
# Modify.........: No.FUN-C30109 12/04/18 By janet mail寄送
# Modify.........: No.FUN-C60077 12/07/06 By downhell mail附件權限改成777

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"



MAIN 

     DEFINE l_xml_str STRING   #接參數2
     DEFINE  l_gdw16   LIKE gdw_file.gdw16 #閒置時間
     DEFINE  l_timeout,l_time_cnt  LIKE type_file.num10 #預設閒置時間, 累計sleep秒數
     DEFINE  l_i,i       LIKE type_file.num10   #TQC-C40053
     DEFINE  l_str     DYNAMIC ARRAY OF STRING  
     DEFINE   ls_para ,l_xml_file          STRING 
     DEFINE   ls_context,l_read_str        STRING 
     DEFINE   ls_pid            STRING 
     DEFINE   ls_context_file   STRING 
     DEFINE   ls_cmd            STRING    
     DEFINE   lc_chin       base.Channel        
     DEFINE  l_file_sizeA,l_file_sizeB LIKE type_file.num10
   # FUN-C30109  ADD--START 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   #IF (NOT cl_setup("AZZ")) THEN  #TQC-C40053 mark
   IF (NOT cl_setup("AZZ")) THEN #TQC-C40053 ADD
      EXIT PROGRAM
   END IF
   # FUN-C30109  ADD--END 
   LET l_xml_file = ARG_VAL(1)
   LET g_prog= ARG_VAL(2)
   LET i=1 

   LET ls_cmd = l_xml_file    
  # DISPLAY ls_cmd
   LET lc_chin = base.Channel.create() #create new 物件
   CALL lc_chin.openFile(ls_cmd,"r") #開啟檔案  
      WHILE TRUE   
             LET l_xml_str =l_xml_str,lc_chin.readLine() #整行讀入
              IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
       END WHILE
      CALL lc_chin.close()  

  CALL cl_used(g_prog,g_time,1) RETURNING g_time
   WHILE (l_xml_str.getLength()>0 )
      LET  l_str[i]=l_xml_str.subString(1, l_xml_str.getIndexOf("|",1)-1)
    #  DISPLAY i,"_ l_str:",l_str[i]
      LET l_xml_str=l_xml_str.subString(l_xml_str.getIndexOf("|",1)+1,l_xml_str.getLength())
      LET i=i+1 
   END WHILE 

   LET g_xml.attach=l_str[1]
   LET g_xml.bcc=l_str[2]   
   LET g_xml.body=l_str[3]
   LET g_xml.cc=l_str[4] 
   LET g_xml.file=l_str[5]
   LET g_xml.mailserver=l_str[6]  
   LET g_xml.passwd=l_str[7]
   LET g_xml.recipient=l_str[8]   
   LET g_xml.sender=l_str[9]
   LET g_xml.serverport=l_str[10] 
   LET g_xml.subject=l_str[11]
   LET g_xml.user=l_str[12]
   #LET ls_para=l_str[13]
   #LET ls_pid=l_str[14]

   
   SELECT DISTINCT  gdw16 INTO l_gdw16 FROM gdw_file WHERE gdw01 =g_prog 
   
       DISPLAY "gdw16:",l_gdw16
       LET l_timeout=1200 #預設20mins
       IF l_gdw16=0 THEN 
          LET l_gdw16=l_timeout #若沒設閒置時間
       ELSE
          LET l_gdw16=l_gdw16*60 #換算為秒
       END IF
       LET l_i=l_gdw16/20 
       DISPLAY "l_i:",l_i
       LET l_time_cnt=0
       LET l_file_sizeA=0
       LET l_file_sizeB=0
       #SLEEP 3
       
       WHILE  ( l_time_cnt < l_gdw16)
          SLEEP 1
          LET l_file_sizeA=os.path.size(g_xml.attach)
          DISPLAY "file_a:",l_file_sizeA
          SLEEP l_i
          LET l_time_cnt=l_time_cnt+l_i
          LET l_file_sizeB=os.path.size(g_xml.attach)
          DISPLAY "file_b:",l_file_sizeB
          #IF (l_file_sizeA=l_file_sizeB) AND (l_file_sizeA <> 0 and l_file_sizeB <> 0) AND ( os.Path.exists(g_xml.attach)) THEN
          IF (l_file_sizeA=l_file_sizeB)  AND ( os.Path.exists(g_xml.attach)) THEN
            EXIT WHILE 
          END IF 

            #讀檔
            
            #LET ls_cmd = g_xml.attach     
            #DISPLAY ls_cmd
            #LET lc_chin = base.Channel.create() #create new 物件
            #CALL lc_chin.openFile(ls_cmd,"ab") #開啟檔案   
            #
            #IF STATUS  THEN DISPLAY  "STATUS:",STATUS  END IF 
            #IF ( os.Path.exists(g_xml.attach) AND  os.path.readable(g_xml.attach)) THEN
               #EXIT WHILE 
            #END IF 
            #CALL lc_chin.close()  
       END WHILE 
       
       #若超時或檔案不存在時，寫一錯誤訊息至log檔
       IF l_time_cnt>l_gdw16 AND NOT os.Path.exists(g_xml.attach) THEN
           ERROR "azz1205 ",g_xml.body," user:",g_user  
           DISPLAY "EXIT PROGRAM"     
           EXIT PROGRAM 
       END IF 
       DISPLAY "g_xml.body:",g_xml.body 
   LET lc_chin = base.Channel.create() #create new 物件
   CALL lc_chin.openFile(g_xml.body,"r") #開啟檔案  
      WHILE TRUE   
             LET l_read_str =l_read_str,lc_chin.readLine() #整行讀入
              IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
       END WHILE
      CALL lc_chin.close()  
  
   IF NOT os.Path.exists(g_xml.attach) THEN
     LET l_read_str = cl_replace_str(l_read_str, "${result}", cl_getmsg("lib-216",g_lang))
    ELSE
       LET l_read_str = cl_replace_str(l_read_str, "${result}", cl_getmsg("lib-284",g_lang))
   END IF

   
   LET ls_cmd = "echo '", l_read_str,"' > ",g_xml.body
   RUN ls_cmd    
    #FUN-C60077 add-----start
   LET ls_cmd = "chmod 777 ", g_xml.attach
   display "g_xml.attach:",g_xml.attach
   display "ls_cmd:",ls_cmd
   RUN ls_cmd
   #FUN-C60077 add-----end 
       CALL cl_jmail()
        DISPLAY "OK"
                 
       IF os.Path.delete(g_xml.body CLIPPED) THEN
       END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   EXIT PROGRAM 
END MAIN 

