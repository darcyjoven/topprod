# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aws_process.4gl
# Descriptions...: 解析ERPII整合暫存檔批次拋轉DB作業
# Date & Author..: 12/04/18 By Abby
# Modify.........: 新建立 DEV-C40006
# Modify.........: No.FUN-D10092 13/01/20 By Abby  PLM GP5.3追版

     
IMPORT os 
DATABASE ds

#DEV-C40006
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE tm        RECORD
                   wc       STRING,
                   wcf09_1  LIKE wcf_file.wcf09,
                   wcf09_2  LIKE wcf_file.wcf09,
                   wcf09_3  LIKE wcf_file.wcf09,
                   wcf09_4  LIKE wcf_file.wcf09,
                   wcf09_5  LIKE wcf_file.wcf09,
                   wcf01    LIKE wcf_file.wcf01,
                   wcf06    LIKE wcf_file.wcf06
                 END RECORD
DEFINE g_wcf     DYNAMIC ARRAY OF RECORD LIKE wcf_file.*  #程式變數(Program Variables)
DEFINE l_wcf     DYNAMIC ARRAY OF RECORD LIKE wcf_file.*  #程式變數(Program Variables)
DEFINE g_cnt1    LIKE type_file.num10
#--------------------------------------------------------------------------#
# Service Request String(XML)                                              #
#--------------------------------------------------------------------------#
DEFINE l_request RECORD            
                   request        STRING,       #呼叫 TIPTOP 服務時傳入的 XML
                   xmlheader      STRING,
                   xmlbody        STRING,
                   xmltrailer     STRING,
                   xml            STRING
                 END RECORD
DEFINE l_request_root    om.DomNode    #Request XML Dom Node
DEFINE l_node            om.DomNode
 
MAIN
   DEFINE l_flag        LIKE type_file.num5
   DEFINE l_i SMALLINT  #DEBUG
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理


   LET l_i = 5/3               #DEBUG
   DISPLAY "l_i=",l_i          #DEBUG

   LET g_bgjob = ARG_VAL(1)
   LET tm.wcf06 = ARG_VAL(2)   
   LET tm.wc = ARG_VAL(3)
   LET tm.wcf01 = ARG_VAL(4)
   LET tm.wcf09_1 = ARG_VAL(5)
   LET tm.wcf09_2 = ARG_VAL(6)
   LET tm.wcf09_3 = ARG_VAL(7)
   LET tm.wcf09_4 = ARG_VAL(8)
   LET tm.wcf09_5 = ARG_VAL(9)

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL aws_process_p1()
         IF cl_sure(0,0) THEN 
            LET g_success='Y'
            CALL cl_wait()
            CALL aws_process_p2() 
            CALL s_showmsg()    
            IF g_success = 'Y' THEN
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL cl_end2(2) RETURNING l_flag
            END IF
            CALL cl_msg(" ")
            IF l_flag THEN 
               CLOSE WINDOW aws_process_w
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW aws_process_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success='Y'
         CALL aws_process_p2()
         CALL s_showmsg()
         EXIT WHILE
      END IF
   END WHILE

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-D10092
