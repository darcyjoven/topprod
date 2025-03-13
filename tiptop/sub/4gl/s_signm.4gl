# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_signm.4gl
# Descriptions...: 簽核等級資料輸入
# Date & Author..: 91/01/03 By Wu  
# Usage..........: CALL s_signm(p_row,p_col,p_lang,p_flag,p_no,p_type,p_label,
#                               p_days,p_prit,p_max,p_seq)
#                  RETURNING l_label,l_days,l_prit,l_max,l_seq,l_statu
# Input Parameter: p_row   視窗左上角x坐標
#                  p_col   視窗左上角y坐標
#                  p_flag  處理方式 1.可輸入簽核等級  2.display
#                  p_no    單據編號
#                  p_type  單據類別
#                  p_label 等級
#                  p_days  簽核完成天數
#                  p_prit  簽核優先等級
#                  p_max   應簽
#                  p_seq   已簽
# Return code....: l_label 簽核等級
#                  l_days  簽核完成天數
#                  l_prit  簽核優先順序
#                  l_max   應簽
#                  l_seq   已簽
#                  l_statu 是否有重新賦予新等級
# Memo...........: 只有在p_flag=1時才有RETURN值
# modify.........: 92/09/23 By Pin
#                  加二欄位:簽核完成天數(p_days)與簽核優先等級(p_prit)
# modify.........: No.FUN-640197 95/04/14 By Alexstar 當勾選「簽核流程與EasyFlow串聯」，應簽核的整合單據選擇「取消確認」時不需顯示簽核異動視窗, 
#                                                   若要查詢簽核狀況可以選擇「簽核狀況」功能。
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: NO.TQC-D50078 13/07/15 BY qirl aza23=Y時，修改供應商簡稱程序會down出
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
    DEFINE
        p_flag     LIKE type_file.chr1,          # 1. 可輸入簽核等級 2. display        #No.FUN-680147 VARCHAR(1)
        p_no       LIKE oea_file.oea01,          #No.FUN-680147 VARCHAR(20)      #單據編號
        p_type     LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #單據類別
        p_label    LIKE pmk_file.pmksign,        # Prog. Version..: '5.30.06-13.03.12(04)      #等級
        p_days     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        p_prit     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        p_max      LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #應簽
        p_seq      LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #已簽
        p_label_o  LIKE pmk_file.pmksign,        # Prog. Version..: '5.30.06-13.03.12(04)      #等級
        p_days_o   LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        p_prit_o   LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        p_statu    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)      #是否重新賦予新等級
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680147 VARCHAR(1)


FUNCTION s_signm
   (p_row,p_col,p_lang,p_flag,p_no,p_type,p_label,p_days,p_prit,p_max,p_seq)
DEFINE
   p_row,p_col LIKE type_file.num5,         #No.FUN-680147 SMALLINT
   p_lang      LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
   p_flag      LIKE type_file.chr1,         # 1. 可輸入簽核等級 2. display        #No.FUN-680147 VARCHAR(1)
   p_no        LIKE oea_file.oea01,         #No.FUN-680147 VARCHAR(20)      #單據編號
   p_type     LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #單據類別
   p_label    LIKE pmk_file.pmksign,        # Prog. Version..: '5.30.06-13.03.12(04)      #等級
   p_days     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
   p_prit     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
   p_max      LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #應簽
   p_seq      LIKE type_file.num5,          #No.FUN-680147 SMALLINT      #已簽
   l_chr      LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
   g_msg      LIKE zaa_file.zaa08           #No.FUN-680147 VARCHAR(60)
 
   WHENEVER ERROR CALL cl_err_msg_log

### 若 aza23='Y' 表示簽核流程串 EasyFlow ##
   IF g_aza.aza23 MATCHES '[Yy]' THEN
      RETURN '','','','','',''    #TQC-D50078 add '','','','','',''
   END IF
 
   OPEN WINDOW s_signm_w WITH FORM "sub/42f/s_signm"
      ATTRIBUTE( STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("s_signm")
 
   LET p_statu = '0' 
   LET p_label_o = p_label
   LET p_days_o = p_days
   LET p_prit_o = p_prit
    IF p_flag = '1' THEN 
 
       CALL signm_count(p_label) RETURNING p_max  #get 應簽人數
       DISPLAY p_label,p_days,p_prit,p_max,p_seq 
            TO pmksign,pmkdays,pmkprit,pmksmax,pmksseq 
       CALL signm_show(p_no,p_type,p_label,'1')
 
       CALL cl_getmsg('mfg0049',p_lang) RETURNING g_msg
       WHILE l_chr IS NULL OR l_chr NOT MATCHES'[YNyn]'

             PROMPT g_msg CLIPPED FOR CHAR l_chr
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
             
             END PROMPT
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
       END WHILE

       #賦予新等級
       IF l_chr matches'[Yy]' THEN  
             #是否重新賦予新等級
             INPUT p_label,p_days,p_prit WITHOUT DEFAULTS 
             FROM pmksign,pmkdays,pmkprit 
 
                AFTER FIELD pmksign  #簽核等級
                    IF p_label  IS NULL OR  p_label = ' '
                      THEN NEXT FIELD pmksign
                      ELSE IF p_label_o != p_label THEN 
                              CALL signm_chk(p_label,p_type)
                              IF NOT cl_null(g_errno) THEN
                                 CALL cl_err(p_label,g_errno,0)
                                 LET p_label = p_label_o 
                                 LET p_days = p_days_o
                                 LET p_prit = p_prit_o
                                 DISPLAY p_label,p_days,p_prit 
                                      TO pmksign,pmkdays,pmkprit 
                              END IF
                              CALL signm_count(p_label) RETURNING p_max
                              CALL signm_signu(p_label_o,p_label,p_no,p_type) 
                                       RETURNING p_label,p_max,p_seq
                              LET p_statu = '1' 
                           ELSE 
                              CALL signm_count(p_label) RETURNING p_max
                              IF g_chr='E' THEN
                                 CALL cl_err(p_label,'mfg3034',0)
                                 NEXT FIELD pmksign
                              ELSE 
                                 NEXT FIELD pmkdays
                              END IF
                           END IF
                    END IF
 
             AFTER FIELD pmkdays
               IF p_days IS NULL THEN LET p_days=0 END IF
               DISPLAY p_days TO pmkdays
 
             AFTER FIELD pmkprit
               IF p_prit IS NULL THEN LET p_prit=0 END IF
               DISPLAY p_prit TO pmkprit
               CALL signm_show(p_no,p_type,p_label,'0')
        
                ON ACTION controlp                        # 欄位說明
                     CASE
                      WHEN INFIELD(pmksign) #等級資料檔
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = 'q_azc'
                         LET g_qryparam.default1 = p_label
                         CALL cl_create_qry() RETURNING p_label
                         DISPLAY p_label TO  pmksign 
                         NEXT FIELD pmksign
                      OTHERWISE EXIT CASE
                     END CASE
 
                ON ACTION controlg
                    CALL cl_cmdask()
 
                ON ACTION controlf                        # 欄位說明
                    CASE
                        WHEN INFIELD(pmksign)    CALL cl_fldhlp('pmksign')
                        OTHERWISE             CALL cl_fldhlp('    ')
                    END CASE

                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE INPUT
 
                ON ACTION about         
                   CALL cl_about()      
 
                ON ACTION help          
                   CALL cl_show_help()  
            END INPUT

            IF INT_FLAG THEN 
                LET p_label= p_label_o
                LET p_days= p_days_o
                LET p_prit= p_prit_o
                LET INT_FLAG = 0 
                CLOSE WINDOW s_signm_w
            END IF
       END IF
   ELSE 
       DISPLAY p_label,p_days,p_prit,p_max,p_seq TO 
               pmksign,pmkdays,pmkprit,pmksmax,pmksseq 
       CALL signm_show(p_no,p_type,p_label,'0')
   END IF
   CLOSE WINDOW s_signm_w
   IF p_flag = '1' THEN 
      RETURN p_label, p_days,p_prit,p_max, p_seq , p_statu
   END IF
END FUNCTION
   
FUNCTION signm_signu(p_label_o,p_label,p_no,p_type)  #簽核等級相關欄位
   DEFINE p_label,p_label_o    LIKE pmk_file.pmksign,          #No.FUN-680147 VARCHAR(04)
          p_no                 LIKE oea_file.oea01,            #No.FUN-680147 VARCHAR(20)
           g_sql                string,  #No.FUN-580092 HCN
          p_type               LIKE type_file.num5,            #No.FUN-680147 SMALLINT 
          l_max  ,l_seq        LIKE type_file.num5             #No.FUN-680147 SMALLINT
 
    LET g_chr=' '
    SELECT COUNT(*) INTO l_max          #新等級的應簽人數
        FROM azc_file
        WHERE azc01=p_label
 
    IF SQLCA.sqlcode OR
       l_max =0 OR l_max IS NULL THEN
        LET g_chr='E'
    ELSE DISPLAY l_max TO pmksmax 
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
    DISPLAY l_seq TO pmksseq  
    RETURN p_label, l_max,l_seq
END FUNCTION
   
FUNCTION signm_chk(p_label,p_type)  #判斷簽核等級對不對
   DEFINE  p_max      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           p_label    LIKE pmk_file.pmksign,        # Prog. Version..: '5.30.06-13.03.12(04)      #等級
           p_type     LIKE type_file.num5,          #No.FUN-680147 SMALLINT     #單據類別
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
END FUNCTION
 
FUNCTION signm_count(p_label)  #讀取應簽人數    
   DEFINE p_max      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          p_label    LIKE pmk_file.pmksign         # Prog. Version..: '5.30.06-13.03.12(04)        #等級
 
    LET g_chr=' '
    SELECT COUNT(*) INTO p_max        
        FROM azc_file
        WHERE azc01=p_label
 
    IF SQLCA.sqlcode OR p_max =0 OR p_max IS NULL THEN
        LET g_chr='E'
    END IF
    RETURN p_max
END FUNCTION
   
FUNCTION signm_show(p_no,p_type,p_label,p_sw)  #display 應簽/已簽 人員代號
   DEFINE p_no     LIKE oea_file.oea01,          #No.FUN-680147 VARCHAR(20)
          p_type   LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          p_sw     LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
          p_label  LIKE pmk_file.pmksign,        #No.FUN-680147 VARCHAR(04)
          l_max    LIKE pmk_file.pmksmax,        #No.FUN-680147 VARCHAR(08)
          l_seq    LIKE pmk_file.pmksseq,        #No.FUN-680147 VARCHAR(08)
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
 
FUNCTION s_ef_log(p_row,p_col,p_key)
	 DEFINE	p_row,p_col	LIKE type_file.num5,          #No.FUN-680147 SMALLINT
   		p_key		LIKE azg_file.azg01,
                l_azg04         LIKE azg_file.azg04,
   		l_azg ARRAY[300] of RECORD
				azg02 LIKE azg_file.azg02,
   				azg03 LIKE azg_file.azg03,
   				desc  LIKE azg_file.azg06,    #No.FUN-680147 VARCHAR(10)
   				azg05 LIKE azg_file.azg05,
   				azg06 LIKE azg_file.azg06,
				azg07 LIKE azg_file.azg07    #No.FUN-680147 CHARACTER(256)
			END RECORD,
		l_arrno		LIKE type_file.num5,          #No.FUN-680147 SMALLINT
		l_maxac		LIKE type_file.num5,          #No.FUN-680147 SMALLINT
		l_n,l_ac     	LIKE type_file.num5,          #No.FUN-680147 SMALLINT
		l_exit_sw	LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
		l_chr    	LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
		l_wc  		LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(200)
		l_sql 		LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(200)
		l_priv		LIKE cre_file.cre08,          #No.FUN-680147 VARCHAR(10)
                l_time		LIKE type_file.chr8,          #No.FUN-680147 VARCHAR(8)
                l_azg07         LIKE azg_file.azg07           #No.FUN-680147 CHARACTER(256)
 
   WHENEVER ERROR CALL cl_err_msg_log

   LET l_arrno = 300
 
   OPEN WINDOW s_ef_log_w WITH FORM "sub/42f/s_ef_log"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("s_ef_log")
 
   WHILE TRUE
     LET l_exit_sw = "y"
     LET l_sql = "SELECT azg02,azg03,'',azg05,azg06,azg07 FROM azg_file",
                 " WHERE azg01='",p_key,"'",
                 " ORDER BY 2,3"
     PREPARE s_ef_log_prepare FROM l_sql
     DECLARE azg_curs CURSOR FOR s_ef_log_prepare
     LET l_ac = 1

     FOREACH azg_curs INTO l_azg[l_ac].*,l_azg04
        IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
        CASE
           WHEN l_azg04='1'
                LET l_azg[l_ac].desc=cl_getmsg('mfg3552',g_lang)
           WHEN l_azg04='2'
                LET l_azg[l_ac].desc=cl_getmsg('mfg3556',g_lang)
           WHEN l_azg04='3'
                LET l_azg[l_ac].desc=cl_getmsg('mfg3554',g_lang)
           WHEN l_azg04='4'
                LET l_azg[l_ac].desc=cl_getmsg('mfg3555',g_lang)
        END CASE
	LET l_ac = l_ac + 1
	IF l_ac > l_arrno THEN 
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
     END FOREACH
     LET l_maxac = l_ac - 1
     CALL SET_COUNT(l_maxac)
 
     INPUT ARRAY l_azg WITHOUT DEFAULTS FROM s_azg.*
          BEFORE ROW
             LET l_ac = ARR_CURR()
             IF l_azg[l_ac].azg02 IS NOT NULL AND l_ac <= l_maxac THEN
                DISPLAY l_azg[l_ac].azg02,l_azg[l_ac].azg03,
                        l_azg[l_ac].desc,l_azg[l_ac].azg05,l_azg[l_ac].azg06,
                        l_azg[l_ac].azg07 
                     TO azg02, azg03, desc, azg05, azg06, azg07 
             END IF
          AFTER ROW
                DISPLAY l_azg[l_ac].azg02,l_azg[l_ac].azg03,
                        l_azg[l_ac].desc,l_azg[l_ac].azg05,l_azg[l_ac].azg06,
                        l_azg[l_ac].azg07 
                     TO azg02, azg03,desc, azg05,azg06, azg07

          ON ACTION controlp 
            OPEN WINDOW s_ef_azg07w WITH 6 ROWS, 70 COLUMNS
               ATTRIBUTE ( STYLE = g_win_style CLIPPED)
            LET l_azg07=l_azg[l_ac].azg07[1,68]
            DISPLAY l_azg07 
            LET l_azg07=l_azg[l_ac].azg07[69,136]
            DISPLAY l_azg07 
            LET l_azg07=l_azg[l_ac].azg07[137,204]
            DISPLAY l_azg07 
            LET l_azg07=l_azg[l_ac].azg07[205,256]
            DISPLAY l_azg07
            CALL cl_end(0,0)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
     
     END INPUT
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     IF l_exit_sw = "y" THEN EXIT WHILE  END IF
   END WHILE
   CLOSE WINDOW s_ef_log_w

   RETURN
END FUNCTION
 
FUNCTION s_ef_upload(p_key)
	 DEFINE	p_key		LIKE azl_file.azl01,
   		l_azl ARRAY[300] of RECORD
				azl02 LIKE azl_file.azl02,
   				x     LIKE type_file.chr1     #No.FUN-680147 VARCHAR(1)
			END RECORD,
		l_arrno,i 	LIKE type_file.num5,          #No.FUN-680147 SMALLINT
		l_maxac		LIKE type_file.num5,          #No.FUN-680147 SMALLINT
		l_n,l_ac        LIKE type_file.num5,          #No.FUN-680147 SMALLINT
		l_exit_sw	LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
		l_wc  		LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(200)
		l_sql 		LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(200)
		l_priv		LIKE cre_file.cre08,          #No.FUN-680147 VARCHAR(10)
                l_upload        LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(1000)
 
   WHENEVER ERROR CALL cl_err_msg_log

   LET l_arrno = 300
 
   OPEN WINDOW s_ef_upload_w WITH FORM "sub/42f/s_ef_uplo"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("s_ef_uplo")
 
   WHILE TRUE
     LET l_exit_sw = "y"
     LET l_sql = "SELECT azl02,'' FROM azl_file",
                 " WHERE azl01='",p_key,"'",
                 " ORDER BY 1"
     PREPARE s_ef_upload_prepare FROM l_sql
     DECLARE azl_curs CURSOR FOR s_ef_upload_prepare
     LET l_ac = 1
     FOREACH azl_curs INTO l_azl[l_ac].*
        IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
	LET l_ac = l_ac + 1
	IF l_ac > l_arrno THEN 
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
     END FOREACH
     LET l_maxac = l_ac - 1
     CALL SET_COUNT(l_maxac)
 
     INPUT ARRAY l_azl WITHOUT DEFAULTS FROM s_azl.*
          BEFORE ROW
             LET l_ac = ARR_CURR()
             IF l_azl[l_ac].azl02 IS NOT NULL AND l_ac <= l_maxac THEN
                LET l_azl[l_ac].x = '>'
                DISPLAY l_azl[l_ac].x,l_azl[l_ac].azl02 TO x,azg02
             END IF

          AFTER ROW
             LET l_azl[l_ac].x = ' '
                DISPLAY l_azl[l_ac].x,l_azl[l_ac].azl02 TO x,azg02

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
     
     END INPUT
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     IF l_exit_sw = "y" THEN EXIT WHILE  END IF
   END WHILE
   CLOSE WINDOW s_ef_upload_w
 
   LET l_upload=''
   IF l_maxac>0 THEN
      FOR i=1 TO l_maxac
          IF i>1 THEN LET l_upload=l_upload CLIPPED,',' END IF
          LET l_upload = l_upload CLIPPED,'"',l_azl[i].azl02 CLIPPED,'"'
      END FOR
   END IF
   RETURN l_maxac,l_upload
 
END FUNCTION

