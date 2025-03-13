# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_signx1.4gl
# Descriptions...: 簽核等級資料輸入
# Date & Author..: 91/01/03 By Wu  
# Usage..........: CALL s_signx1(p_row,p_col,p_lang,p_flag,p_no,p_type,p_label,
#                                p_days,p_prit,p_max,p_seq)
#                  RETURNING l_label,l_days,l_prit,l_max,l_seq,l_statu
# Input Parameter: p_row    視窗左上角x坐標
#                  p_col    視窗左上角y坐標
#                  p_flag   處理方式 1.可輸入簽核等級  2.display
#                  p_no     單據編號
#                  p_type   單據類別
#                  p_label  等級
#                  p_days   簽核完成天數
#                  p_prit   簽核優先等級
#                  p_max    應簽
#                  p_seq    已簽
# Return code....: l_label  簽核等級
#                  l_days   簽核完成天數
#                  l_prit   簽核優先順序
#                  l_max    應簽
#                  l_seq    已簽
#                  l_statu  是否有重新賦予新等級
# Memo...........: 只有在p_flag=1時才有RETURN值
# Modify.........: 92/09/23 By Pin 加二欄位:簽核完成天數(p_days)與簽核優先等級(p_prit)
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整ATTRIBUTES
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
    DEFINE
        p_flag     LIKE type_file.chr1,          # 1. 可輸入簽核等級 2. display        #No.FUN-680147 VARCHAR(1)
        p_no       LIKE azd_file.azd01,          #No.FUN-680147 VARCHAR(20)      #單據編號
        p_type     LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #單據類別
        p_label    LIKE pmk_file.pmksign,        # Prog. Version..: '5.30.06-13.03.12(04)      #等級
        p_days     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        p_prit     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        p_max      LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #應簽
        p_seq      LIKE type_file.num5,          #No.FUN-680147 SMALLINT       #已簽
        p_label_o  LIKE pmk_file.pmksign,        # Prog. Version..: '5.30.06-13.03.12(04)      #等級
        p_days_o   LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        p_prit_o   LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        p_statu    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)       #是否重新賦予新等級
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
FUNCTION s_signx1(p_row,p_col,p_lang,p_flag,p_no,p_type,p_label,
                  p_days,p_prit,p_max,p_seq)
DEFINE
   p_row,p_col LIKE type_file.num5,         #No.FUN-680147 SMALLINT
   p_lang      LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
   p_flag     LIKE type_file.chr1,          # 1. 可輸入簽核等級 2. display        #No.FUN-680147 VARCHAR(1)
   p_no       LIKE azd_file.azd01,          #No.FUN-680147 VARCHAR(20)      #單據編號
   p_type     LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #單據類別
   p_label    LIKE pmk_file.pmksign,        # Prog. Version..: '5.30.06-13.03.12(04)      #等級
   p_days     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
   p_prit     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
   p_max      LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #應簽
   p_seq      LIKE type_file.num5,          #No.FUN-680147 SMALLINT     #已簽
   l_chr      LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
   g_msg      LIKE zaa_file.zaa08           #No.FUN-680147 VARCHAR(60)
 
   WHENEVER ERROR CALL cl_err_msg_log
     
   OPEN WINDOW s_signx1_w WITH FORM "sub/42f/s_signx1"
   ATTRIBUTE( STYLE = g_win_style CLIPPED)     #FUN-9B0156
 
   CALL cl_ui_locale("s_signx1")
 
   LET p_statu = '0' 
   LET p_label_o = ' '  
   LET p_days_o=0
   LET p_prit_o=0
   IF p_flag = '1' THEN      #可輸入簽核等級
       CALL signx1_count(p_label) RETURNING p_max  #get 應簽人數
       DISPLAY p_label,p_days,p_prit,p_max,p_seq TO 
               oeasign,oeadays,oeaprit,oeasmax,oeasseq 
       CALL signx1_show(p_no,p_type,p_label,'1')
 
       CALL cl_getmsg('mfg0049',p_lang) RETURNING g_msg
       WHILE l_chr IS NULL OR l_chr NOT MATCHES'[YNyn]'
#............是否重新賦予新等級
             PROMPT g_msg CLIPPED FOR CHAR l_chr
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
             
             END PROMPT
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
       END WHILE
      
       IF l_chr matches'[Yy]' THEN   #賦予新等級
          INPUT p_label,p_days,p_prit WITHOUT DEFAULTS 
                   FROM oeasign,oeadays,oeaprit  HELP 1
 
             BEFORE FIELD oeasign
                    LET p_label_o = p_label
                    LET p_days_o = p_days
                    LET p_prit_o = p_prit
 
             AFTER FIELD oeasign  #簽核等級
                   IF p_label  IS NULL OR  p_label = ' '  THEN 
                      NEXT FIELD oeasign
                   ELSE 
                      IF p_label_o != p_label THEN 
                         CALL signx1_chk(p_label,p_type)
                         IF NOT cl_null(g_errno) THEN
                            CALL cl_err(p_label,g_errno,0)
                            LET p_label = p_label_o 
                            LET p_days = p_days_o
                            LET p_prit = p_prit_o
                            DISPLAY p_label,p_days,p_prit 
                                 TO oeasign,oeadays,oeaprit 
                            NEXT FIELD oeasign
                         END IF
 
                         CALL signx1_count(p_label) RETURNING p_max
                         CALL signx1_signu(p_label_o,p_label,p_no,p_type) 
                              RETURNING p_label,p_max,p_seq
                         LET p_statu = '1'
                         NEXT FIELD oeadays
                      ELSE 
                         CALL signx1_count(p_label) RETURNING p_max
                         IF g_chr='E' THEN
                            CALL cl_err(p_label,'mfg3034',0)
                            NEXT FIELD oeasign
                         ELSE #CALL signx1_show(p_no,p_type,p_label,'0')
                            NEXT FIELD oeadays
                         END IF
                      END IF
                    END IF
 
             AFTER FIELD oeadays
               IF p_days IS NULL THEN LET p_days=0 END IF
               DISPLAY p_days TO oeadays
#              CALL signx1_show(p_no,p_type,p_label,'0')
 
             AFTER FIELD oeaprit
               IF p_prit IS NULL THEN LET p_prit=0 END IF
               DISPLAY p_prit TO oeaprit
               CALL signx1_show(p_no,p_type,p_label,'0')
        
               ON ACTION controlp
                  CASE WHEN INFIELD(oeasign) 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_azc"
                      LET g_qryparam.default1 = p_label 
                      LET g_qryparam.arg1 = p_type 
                      CALL cl_create_qry() RETURNING p_label
                      DISPLAY p_label TO  oeasign
                      NEXT FIELD oeasign
                      OTHERWISE 
                           EXIT CASE
                   END CASE
 
                ON KEY(CONTROL-G)
                    CALL cl_cmdask()
 
                ON KEY(control-f)                        # 欄位說明
                    CASE
                        WHEN INFIELD(oeasign)    CALL cl_fldhlp('oeasign')
                        OTHERWISE             CALL cl_fldhlp('    ')
                    END CASE
#--NO.MOD-860078 start---
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE INPUT
 
                ON ACTION about         
                   CALL cl_about()      
 
                ON ACTION help          
                   CALL cl_show_help()  
#--NO.MOD-860078 end------- 
            END INPUT
            IF INT_FLAG THEN 
                LET INT_FLAG = 0 
                CLOSE WINDOW s_signx1_w
            END IF
       END IF
   ELSE 
       DISPLAY p_label,p_days,p_prit,p_max,p_seq TO 
               oeasign,oeadays,oeaprit,oeasmax,oeasseq 
       CALL signx1_show(p_no,p_type,p_label,'0')
   END IF
   CLOSE WINDOW s_signx1_w
   IF p_flag = '1' THEN 
      RETURN p_label, p_days,p_prit,p_max, p_seq , p_statu
   END IF
END FUNCTION
   
FUNCTION signx1_signu(p_label_o,p_label,p_no,p_type)  #簽核等級相關欄位
   DEFINE p_label,p_label_o    LIKE pmk_file.pmksign,      #No.FUN-680147 VARCHAR(04)
          p_no                 LIKE azd_file.azd01,        #No.FUN-680147 VARCHAR(20)
          g_sql                string,  #No.FUN-580092 HCN
          p_type               LIKE type_file.num5,        #No.FUN-680147 SMALLINT
          l_max  ,l_seq        LIKE type_file.num5         #No.FUN-680147 SMALLINT
 
    LET g_chr=' '
    SELECT COUNT(*) INTO l_max          #新等級的應簽人數
        FROM azc_file
        WHERE azc01=p_label
 
    IF SQLCA.sqlcode OR
       l_max =0 OR l_max IS NULL THEN
        LET g_chr='E'
    ELSE DISPLAY l_max TO oeasmax 
    END IF
 
    LET g_sql = "SELECT COUNT(distinct azd03)",  
                " FROM azd_file,azc_file ",
                " WHERE azc03 = azd03 AND azd01 ='",p_no,"' AND",
                " azd02 = ",p_type ,"  AND",
                " azc01 ='",p_label,"'" 
 
    PREPARE sign_co FROM g_sql
    DECLARE sign_count CURSOR FOR sign_co       
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) END IF
 
    LET l_seq=''
    OPEN sign_count
    FETCH sign_count INTO l_seq
    IF l_seq IS NULL THEN LET l_seq=0 END IF
    DISPLAY l_seq TO oeasseq  
    RETURN p_label, l_max,l_seq
END FUNCTION
   
FUNCTION signx1_chk(p_label,p_type)  #判斷簽核等級對不對
   DEFINE  p_max      LIKE type_file.num5,        #No.FUN-680147 SMALLINT
           p_label    LIKE pmk_file.pmksign,      # Prog. Version..: '5.30.06-13.03.12(04)      #等級
           p_type     LIKE type_file.num5,        #No.FUN-680147 SMALLINT      #單據類別
           l_aze02 LIKE aze_file.aze02,
           l_azeacti LIKE aze_file.azeacti
 
    LET g_errno = ' '
    SELECT aze02,azeacti
           INTO l_aze02,l_azeacti
           FROM aze_file WHERE aze01 = p_label
                               AND aze09=p_type
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3034'
                            LET l_aze02 = NULL
         WHEN l_azeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
  # IF cl_null(g_errno) OR p_cmd = 'd' THEN
  #    DISPLAY l_aze02 TO FORMONLY.aze02 
  # END IF
END FUNCTION
 
FUNCTION signx1_count(p_label)  #讀取應簽人數    
   DEFINE p_max      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          p_label    LIKE pmk_file.pmksign         # Prog. Version..: '5.30.06-13.03.12(04)       #等級
 
    LET g_chr=' '
    SELECT COUNT(*) INTO p_max FROM azc_file
     WHERE azc01=p_label
 
    IF SQLCA.sqlcode OR p_max =0 OR p_max IS NULL THEN
       LET g_chr='E'
    ELSE 
       DISPLAY p_max TO oeasmax 
    END IF
    RETURN p_max
 
END FUNCTION
   
FUNCTION signx1_show(p_no,p_type,p_label,p_sw)  #display 應簽/已簽 人員代號
   DEFINE p_no     LIKE azd_file.azd01,          #No.FUN-680147 VARCHAR(20)
          p_type   LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          p_sw     LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
          p_label  LIKE oea_file.oeasign,        #No.FUN-680147 VARCHAR(4)
          l_max    LIKE oea_file.oeasmax,        #No.FUN-680147 VARCHAR(08)
          l_seq    LIKE oea_file.oeasseq,        #No.FUN-680147 VARCHAR(08)
          l_cnt    LIKE type_file.num5   ,       #No.FUN-680147 SMALLINT
          l_arrno  LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          l_azc02  LIKE azc_file.azc02,
          l_azd03  LIKE azd_file.azd03,
          l_azd04  LIKE azd_file.azd03,
          l_ans    LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
          l_msg    LIKE zaa_file.zaa08,          #No.FUN-680147 VARCHAR(30)
          l_sw     LIKE type_file.chr1           #No.FUN-680147 VARCHAR(01)
 
   CLEAR ac3_m1,ac3_m2,ac3_m3,ac3_m4,ac3_m5,ac3_m6,
         ac3_s1,ac3_s2,ac3_s3,ac3_s4,ac3_s5,ac3_s6 
 
   DECLARE max_cl CURSOR FOR SELECT  azc02,azc03 FROM azc_file
                             WHERE azc01 = p_label 
                             ORDER BY azc02
 
   DECLARE seq_cl CURSOR FOR SELECT  azd03,azd04,azc02 FROM azd_file,azc_file
                             WHERE azd01 = p_no  AND   
                                   azd02 = p_type AND 
                                   azc01 = p_label AND 
                                   azc03 = azd03 
                             ORDER BY azc02,azd04        
 
   LET l_cnt = 1
   LET l_arrno = 6
   FOREACH max_cl INTO l_azc02,l_max
       IF SQLCA.sqlcode THEN 
          CALL cl_err('max_cl error',SQLCA.sqlcode,0) EXIT FOREACH 
       END IF
       CASE l_cnt
          WHEN 1 DISPLAY l_max TO  FORMONLY.ac3_m1 
          WHEN 2 DISPLAY l_max TO  FORMONLY.ac3_m2 
          WHEN 3 DISPLAY l_max TO  FORMONLY.ac3_m3 
          WHEN 4 DISPLAY l_max TO  FORMONLY.ac3_m4 
          WHEN 5 DISPLAY l_max TO  FORMONLY.ac3_m5 
          WHEN 6 DISPLAY l_max TO  FORMONLY.ac3_m6 
          OTHERWISE EXIT CASE
       END CASE
       LET l_cnt = l_cnt + 1
       IF l_cnt > l_arrno THEN 
           CALL cl_err('','9035',0)
           EXIT FOREACH 
       END IF
   END FOREACH 
 
   LET l_cnt = 1
   LET l_arrno = 6
   FOREACH seq_cl INTO l_seq,l_azd04,l_azc02
       IF SQLCA.sqlcode THEN 
          CALL cl_err('seq_cl error',SQLCA.sqlcode,0) EXIT FOREACH 
       END IF
       CASE l_cnt
          WHEN 1 DISPLAY l_seq TO  FORMONLY.ac3_s1 
          WHEN 2 DISPLAY l_seq TO  FORMONLY.ac3_s2 
          WHEN 3 DISPLAY l_seq TO  FORMONLY.ac3_s3 
          WHEN 4 DISPLAY l_seq TO  FORMONLY.ac3_s4 
          WHEN 5 DISPLAY l_seq TO  FORMONLY.ac3_s5 
          WHEN 6 DISPLAY l_seq TO  FORMONLY.ac3_s6 
          OTHERWISE EXIT CASE
       END CASE
       LET l_cnt = l_cnt + 1
       IF l_cnt > l_arrno THEN 
           CALL cl_err('','9035',0)
           EXIT FOREACH 
       END IF
   END FOREACH 
   CALL cl_getmsg('mfg6012',g_lang) RETURNING l_msg
   IF p_sw='0' THEN
      PROMPT l_msg CLIPPED FOR CHAR l_ans
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
#            CONTINUE PROMPT
      
      END PROMPT
   END IF
   IF INT_FLAG THEN LET INT_FLAG = 0  END IF
#   ERROR ''  
END FUNCTION
