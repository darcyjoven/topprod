# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_locktab.4gl
# Descriptions...: lock table & wait lock       
# Date & Author..: 93/04/21 By  Pin
# Usage..........: IF NOT s_locktab(p_tbname,p_sdesc)
# Input Parameter: p_tbname    Table Name
#                  p_desc      Table description
# Return code....: l_flag      1:FAIL 0:OK
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.TQC-6A0079 06/11/06 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE m_no   LIKE type_file.num10            #No.FUN-680147 INTEGER
 
FUNCTION s_locktab(s_tbname,s_desc)
DEFINE
      s_tbname LIKE type_file.chr10,          #No.FUN-680147 VARCHAR(10)   #table name  #No.TQC-6A0079
      s_desc   LIKE bnb_file.bnb06,           #No.FUN-680147 VARCHAR(20)   #table desc.
      s_count  LIKE type_file.num10,          #No.FUN-680147 INTEGER    #this file wait count
      s_sec    LIKE type_file.num10           #No.FUN-680147 INTEGER    # wait second
 
    WHENEVER ERROR CALL cl_err_msg_log
       LET  s_count=0
       LET  s_sec=0
 
     WHILE TRUE
       IF s_waitlock(s_tbname) 
          THEN 
               LET s_count=s_count+1   #total no.
               LET s_sec  = s_sec+3    #total second
               CALL s_locktab_d(s_desc,s_count,s_sec)
               IF INT_FLAG  THEN LET INT_FLAG=0 
                                 CLOSE WINDOW s_locktab 
                                 RETURN 1
               END IF
               IF s_sec > 300 THEN  CLOSE WINDOW s_locktab RETURN 1 END IF
             ELSE EXIT WHILE 
          END IF
     END WHILE
     IF s_count !=0 THEN
        CLOSE WINDOW s_locktab 
     END IF
     RETURN 0
    
END FUNCTION
 
FUNCTION s_locktab_d(m_desc,count_no,sec_no)
  DEFINE m_desc   LIKE nma_file.nma04,             #No.FUN-680147 VARCHAR(30)
         m_window LIKE type_file.chr1,             #No.FUN-680147 VARCHAR(1)
         m_no     LIKE type_file.num10,            #No.FUN-680147 INTEGER
         count_no LIKE type_file.num10,            #No.FUN-680147 INTEGER
         sec_no   LIKE type_file.num10             #No.FUN-680147 INTEGER
 
    IF count_no=1 THEN
       OPEN WINDOW s_locktab AT 17,21 WITH 4 ROWS, 40 COLUMNS
       ATTRIBUTE ( STYLE = g_win_style )
    END IF
 
     DISPLAY '           ' at 2,16
     DISPLAY '           ' at 3,16
     DISPLAY 'Waitting Lock:' at 1,1
     DISPLAY  m_desc  at 1,16
     DISPLAY '        Count:' at 2,1
     DISPLAY count_no USING '<<<<<<<<<<' at 2,16
     DISPLAY 'Wait   Second:' at 3,1
     DISPLAY sec_no   USING '<<<<<<<<<<' at 3,16
     DISPLAY '    Sec/Count: 3' at 4,1
END FUNCTION 
