# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_gettlf.4gl
# Descriptions...: get transaction log file's tabl name
# Date & Author..: 93/04/16 By Pin
# Usage..........: CALL s_gettlf(p_row,p_col)
# Input Parameter: p_row     open window's row
#                  p_col     open window's column
# Return code....: g_gettlf
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整ATTRIBUTES
# Modify.........: No.FUN-A90024 10/11/10 By Jay 調整各DB利用sch_file取得table與field等資訊
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
DEFINE
    p_tlf   ARRAY[120] OF RECORD
            sure     LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)   # Y/N
            tbname   LIKE qcs_file.qcs03,         #No.FUN-680147 VARCHAR(10)  #Table Name
            bdate    LIKE type_file.dat,          #No.FUN-680147 DATE      #Transaction begin date
            edate    LIKE type_file.dat,          #No.FUN-680147 DATE      #Transaction end   date
            p_no     LIKE type_file.num10         #No.FUN-680147 NTEGER    #Transaction count      
    END RECORD 
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680147 INTEGER
DEFINE   g_gettlf        DYNAMIC ARRAY OF RECORD   
                   tbname   LIKE qcs_file.qcs03,         #No.FUN-680147 VARCHAR(10) #Table Name
                   bdate    LIKE type_file.dat,          #No.FUN-680147 DATE     #Transaction begin date
                   edate    LIKE type_file.dat,          #No.FUN-680147 DATE     #Transaction end   date
                   p_no     LIKE type_file.num10         #No.FUN-680147 INTEGER  #Transaction count
        END RECORD
 
FUNCTION s_gettlf(p_row,p_col)
DEFINE
    p_row          LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    p_col          LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    l_i            LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    p_table        LIKE qcs_file.qcs03,          #No.FUN-680147 VARCHAR(10)
    l_msg1,l_msg2  LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(60)
    l_j            LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    l_sql1,l_sql2  LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(1000)
 
   IF p_row=0 THEN
      LET p_row=5
   END IF
 
   IF p_col=0 THEN
      LET p_col=5 
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
    OPEN WINDOW gettlf_w WITH FORM "sub/42f/s_gettlf"
    ATTRIBUTE( STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("s_gettlf")
 
    message 'Searching......'   #ATTRIBUTE(REVERSE)    #FUN-9B0156
    CALL cl_getmsg('mfg9172',g_lang) RETURNING l_msg1
    CALL cl_getmsg('mfg9173',g_lang) RETURNING l_msg2
    DISPLAY l_msg1 CLIPPED      #AT 1,1 ATTRIBUTE(magenta)   #FUN-9B0156
    DISPLAY l_msg2 CLIPPED      #AT 2,1 ATTRIBUTE(magenta)   #FUN-9B0156
#--->from system table get table name
    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構
    #DECLARE gettlf_curs CURSOR FOR
    # SELECT  'N',tabname  FROM systables
    # WHERE   tabname MATCHES 'tlf_*'
    #  ORDER BY tabname DESC   #由大排到小
    DECLARE gettlf_curs CURSOR FOR
     SELECT DISTINCT 'N', sch01 FROM sch_file
       WHERE sch01 MATCHES 'tlf_*'
     ORDER BY sch01 DESC   #由大排到小
    #---FUN-A90024---end-------
     
   FOR l_j=1  TO 70
       initialize g_gettlf[l_j].* TO NULL
   END FOR
    LET g_cnt = 1
    FOREACH gettlf_curs INTO p_tlf[g_cnt].sure,p_tlf[g_cnt].tbname 
        IF SQLCA.sqlcode THEN
            CALL cl_err('gettlf_curs:',SQLCA.sqlcode,1)
            LET g_gettlf[1].tbname='tlf_file'
            CLOSE WINDOW gettlf_w
            RETURN
        END IF
 
        LET l_sql1= "SELECT count(*)  FROM ",p_tlf[g_cnt].tbname
        PREPARE l_cor FROM l_sql1
        DECLARE l_pr1 CURSOR FOR l_cor      
        OPEN l_pr1 
        FETCH l_pr1 INTO p_tlf[g_cnt].p_no
        CLOSE l_pr1
 
        LET l_sql2= "SELECT min(tlf06),max(tlf06) FROM ",p_tlf[g_cnt].tbname
        PREPARE l_cor2 FROM l_sql2
        DECLARE l_pr2 CURSOR FOR l_cor2     
        OPEN  l_pr2
        FETCH l_pr2 INTO p_tlf[g_cnt].bdate,p_tlf[g_cnt].edate
        CLOSE l_pr2
       
        LET g_cnt = g_cnt + 1
        IF g_cnt > 120  THEN
           CALL cl_err( '', 9035, 0 )     #No.TQC-630109
            EXIT FOREACH
        END IF
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    message ''
    CALL s_gettlf_sure()
    IF INT_FLAG THEN LET INT_FLAG = 0 LET g_gettlf[1].tbname='tlf_file'
                     CLOSE WINDOW gettlf_w
                     RETURN 
    END IF
    LET l_i=1
    FOR g_cnt=1 TO 120
    IF p_tlf[g_cnt].tbname IS NULL OR p_tlf[g_cnt].tbname=' '
       THEN EXIT FOR
    END IF
    IF p_tlf[g_cnt].sure NOT MATCHES '[Yy]'
       THEN CONTINUE FOR
    END IF
    LET g_gettlf[l_i].tbname= p_tlf[g_cnt].tbname
    LET g_gettlf[l_i].bdate = p_tlf[g_cnt].bdate
    LET g_gettlf[l_i].edate = p_tlf[g_cnt].edate
    LET g_gettlf[l_i].p_no  = p_tlf[g_cnt].p_no
    LET l_i=l_i+1
    IF l_i>71 THEN EXIT FOR END IF   #設定最高 [70] 期
    END FOR
    CLOSE WINDOW gettlf_w
END FUNCTION
   
FUNCTION s_gettlf_sure()
    DEFINE l_buf     LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(80)
           y_ac      LIKE type_file.num5,         #No.FUN-680147 SMALLINT
           y_sl      LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY p_tlf TO s_tlf.*          #ATTRIBUTE(WHITE)  #FUN-9B0156
        ON KEY (control-m) LET y_ac = ARR_CURR()
                           LET y_sl = SCR_LINE()
                           IF p_tlf[y_ac].sure = 'N' 
                              THEN  LET p_tlf[y_ac].sure='Y'
                              ELSE  LET p_tlf[y_ac].sure = 'N'
                           END IF
                           DISPLAY p_tlf[y_ac].sure TO s_tlf[y_sl].sure
        ON KEY(CONTROL-G)
           CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
