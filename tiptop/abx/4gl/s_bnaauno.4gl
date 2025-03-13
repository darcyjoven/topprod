# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
##□ s_axmauno
##SYNTAX	CALL s_bnaauno(p_slip,p_date)
##			RETURNING l_stat,l_slip
##DESCRIPTION	自動賦予單據以單號
##PARAMETERS	p_slip	單號
##RETURNING	l_stat	結果碼 0:OK, 1:FAIL
##			l_slip	單號
# Date & Author..: 97/08/18 By Danny
# Modify.........: NO.TQC-5A0095 05/10/26 By Niocla 單據性質取位修改
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換    
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS
DEFINE
    g_bna RECORD LIKE bna_file.*,       #單據性質
    g_waitsec    LIKE type_file.num5,   #No.FUN-680062  smallint
    g_mxno       LIKE bnb_file.bnb01    #No.FUN-680062  VARCHAR(10)
END GLOBALS
 
FUNCTION s_bnaauno(p_slip,p_date)
DEFINE
    p_slip LIKE bnb_file.bnb01,        #單號     #No.FUN-680062 VARCHAR(10)
    p_date LIKE type_file.dat,         #單據日期 #No.FUN-680062 date
    l_slip LIKE bna_file.bna01,        #單別
    l_mxno LIKE type_file.chr6,        #No.FUN-680062  VARCHAR(6)
    l_year,l_month  LIKE type_file.num10,      #No.FUN-680062  integer
    l_int  LIKE type_file.num10,       #No.FUN-680062  integer   
    l_buf  LIKE type_file.chr6,        #No.FUN-680062 VARCHAR(6)
    l_date LIKE type_file.chr6,        #96-09-13  #No.FUN-680062    VARCHAR(6)
    l_date1 LIKE type_file.chr2        #96-09-13  #No.FUN-680062    VARCHAR(2)
 
    WHENEVER ERROR CONTINUE
 
    IF p_slip[5,10]<>' ' THEN RETURN 0,p_slip END IF
    LET l_mxno = NULL
    LET g_mxno = NULL
   #LET l_slip=p_slip[1,3]
    LET l_slip=s_get_doc_no(p_slip)   #No.TQC-5A0095
    SELECT azn02,azn04 INTO l_year,l_month FROM azn_file WHERE azn01=p_date
    IF STATUS THEN 
       LET l_year =YEAR(p_date)
       LET l_month=MONTH(p_date)
    END IF
 
    #設定成等待的模式
 
        SELECT * INTO g_bna.* FROM bna_file  #單據編號方式
         WHERE bna01 = l_slip
	IF SQLCA.sqlcode THEN
#          CALL cl_err('read oay:',SQLCA.sqlcode,1)   #No.FUN-660052
           CALL cl_err3("sel","bna_file",l_slip,"",SQLCA.sqlcode,"","read oay:",1) 
        END IF
        IF g_bna.bna04 = '1' THEN    #依流水號
           SELECT MAX(bnb01) INTO g_mxno FROM bnb_file
            WHERE bnb01[1,3] = l_slip
        ELSE             #依年度期別
           LET l_date = l_year USING '&&&&',l_month USING '&&'
           LET l_date1[1,1]=l_date[4,4]
	         CASE WHEN l_month = 10 LET l_date1[2,2]='A'
                      WHEN l_month = 11 LET l_date1[2,2]='B'
	              WHEN l_month = 12 LET l_date1[2,2]='C'
	              OTHERWISE         LET l_date1[2,2]=l_date[6,6]
	         END CASE
           LET l_buf=l_slip,'-',l_date1
           SELECT MAX(bnb01) INTO g_mxno FROM bnb_file
            WHERE bnb01[1,6] = l_buf
        END IF   
        LET l_mxno = g_mxno[5,10] 
        LET p_slip[5,10]=l_mxno[1,2],(l_mxno[3,6]+1) USING '&&&&'
 
	IF cl_null(p_slip[5,10]) THEN
	   IF l_mxno IS NULL OR l_mxno=' ' THEN	#最大編號未曾指定
	      LET l_buf = l_year USING '&&&&',l_month USING '&&'
	      LET l_mxno[1,1]=l_buf[4,4]
	      CASE WHEN l_month = 10 LET l_mxno[2,2]='A'
                   WHEN l_month = 11 LET l_mxno[2,2]='B'
	           WHEN l_month = 12 LET l_mxno[2,2]='C'
	           OTHERWISE         LET l_mxno[2,2]=l_buf[6,6]
	      END CASE
	      LET l_mxno[3,6]='0000'
	   END IF
	 # LET l_int=l_mxno[3,6]
	 # LET p_slip[5,10]=l_mxno[1,2],l_int + 1 USING '&&&&'
           LET p_slip[5,10]=l_mxno[1,2],(l_mxno[3,6]+1) USING '&&&&'
      END IF
 
    
 
    #因為4.0版本的不自動加上'-', 故在此吾人須多此一舉
    LET p_slip[4,4]='-'
    RETURN 0,p_slip
END FUNCTION
