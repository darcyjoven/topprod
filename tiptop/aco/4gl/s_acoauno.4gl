# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
##□ s_acoauno
##SYNTAX        CALL s_acoauno(p_slip,p_date,p_type) RETURNING l_status,l_slip
##DESCRIPTION   自動賦予單據以單號(合同系統)
##PARAMETERS	p_slip   	單號
##              p_date          日期
##              p_type          單據性質
##RETURNING	l_status	結果
##		1       	TRUE
##		0	        FALSE
##	        l_slip		單號
# Varibles Set ..: SQLCA.sqlcode 錯誤時的錯誤代號
# Date & Author..: 00/10/05
# NOTE...........: 1.若使用自動編號但傳入之單別有單號, 則判斷其單據性質
#                  為1.依流水號 或 2.依年度期別分別尋找其所屬檔案之已用
#                  最大編號 + 1                
#                  2.呼叫後請判斷傳回的第一個值, 若不等於0,表示有問題
#                  因為4.0在使用PICTURE='XXX-XXXXXX'輸入後, 並不將
#                  第四個byte的'-'自動給予變數, 故在所有的處理完後
#                  將資料丟回去前, 將第四個byte指定成'-'
#                  單據編號方式採1.流水號 2.依年月  
# Modify.........: No.MOD-490398  核銷單的資料并入cno_file/cnp_file中,修改單別選擇的TABLE_NAME
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
GLOBALS "../../config/top.global"
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS
DEFINE
    g_message		LIKE ze_file.ze03,           #No.FUN-680069 VARCHAR(70)
    g_waitsec	        LIKE type_file.num5          #No.FUN-680069 SMALLINT 
END GLOBALS
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   #No.FUN-680069
FUNCTION s_acoauno(p_slip,p_date,p_type)	
DEFINE p_slip 			LIKE faj_file.faj02       #No.FUN-680069 VARCHAR(10)  #單號
DEFINE p_date			LIKE type_file.dat        #No.FUN-680069 DATE
DEFINE p_type                   LIKE ooy_file.ooytype     #No.FUN-680069 VARCHAR(2)   #單據性質
DEFINE l_year,l_month	        LIKE type_file.num10      #No.FUN-680069 INT
DEFINE l_slip 			LIKE oay_file.oayslip     #No.FUN-680069 VARCHAR(3)        #單別
DEFINE l_type                   LIKE ooy_file.ooytype     #No.FUN-680069 VARCHAR(2) 
DEFINE l_mxno			LIKE oea_file.oea01       #No.FUN-680069 VARCHAR(6)
DEFINE g_mxno                   LIKE oea_file.oea01       #No.FUN-680069 VARCHAR(10)
DEFINE l_dmy2                   LIKE type_file.chr1       #No.FUN-680069 VARCHAR(1)
DEFINE l_buf			LIKE cng_file.cng01       #No.FUN-680069 VARCHAR(6)
DEFINE l_date   		LIKE type_file.chr6       #No.FUN-680069 VARCHAR(6)
DEFINE l_date1           	LIKE type_file.chr2       #No.FUN-680069 VARCHAR(2)
 
	WHENEVER ERROR CONTINUE
 
	IF p_slip[5,10]<>' ' THEN RETURN 0,p_slip END IF
        LET l_mxno = NULL
        LET g_mxno = NULL
	LET l_slip=p_slip[1,3]
	SELECT azn02,azn04 INTO l_year,l_month FROM azn_file WHERE azn01=p_date
	IF STATUS THEN 
	   LET l_year =YEAR(p_date)
	   LET l_month=MONTH(p_date)
	END IF
        LET l_type = p_type
 
        ## 為了避免搶號,因此在 select coy_fle (單別)時便作 lock,
        ## 待取得單號後再release
        CALL cl_getmsg('mfg8889',g_lang) RETURNING g_message
        MESSAGE g_message
 
        LET g_forupd_sql = " SELECT coykind FROM coy_file WHERE coyslip = ? FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE coyauno_cl CURSOR FROM g_forupd_sql
 
        OPEN coyauno_cl USING l_slip
        IF STATUS THEN
           CALL cl_err("OPEN coyauno_cl:", STATUS, 1)
           CLOSE coyauno_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH coyauno_cl INTO l_dmy2       # 鎖住將的資料
        IF SQLCA.sqlcode = '-243' THEN
            CALL cl_err('coykind:read coy:',SQLCA.sqlcode,1)
            CLOSE coyauno_cl
            RETURN -1,l_slip
        END IF
        IF l_dmy2='1' THEN    #依流水號
           CASE 
             WHEN l_type = '00'         #合同模擬單
               SELECT MAX(cng01) INTO g_mxno FROM cng_file
                WHERE cng01[1,3] = l_slip
             WHEN l_type = '10'         #合同申請單
               SELECT MAX(coc01) INTO g_mxno FROM coc_file
                WHERE coc01[1,3] = l_slip
             WHEN l_type = '11'         #設備申請單
               SELECT MAX(cos01) INTO g_mxno FROM cos_file
                WHERE cos01[1,3] = l_slip
             WHEN l_type = '12'         #加簽申請(出口)
               SELECT MAX(cog01) INTO g_mxno FROM cog_file
                WHERE cog01[1,3] = l_slip
             WHEN l_type = '13'         #加簽申請(進口)
               SELECT MAX(coi01) INTO g_mxno FROM coi_file
                WHERE coi01[1,3] = l_slip
             WHEN l_type = '14'         #報關申請
               SELECT MAX(cno01) INTO g_mxno FROM cno_file
                WHERE cno01[1,3] = l_slip
             WHEN l_type = '15'         #轉廠申請
               SELECT MAX(cnm01) INTO g_mxno FROM cnm_file
                WHERE cnm01[1,3] = l_slip
             WHEN l_type = '16'         #進口設備報關
               SELECT MAX(cou01) INTO g_mxno FROM cou_file
                WHERE cou01[1,3] = l_slip
             WHEN l_type = '17'         #免稅設備報關
               SELECT MAX(cow01) INTO g_mxno FROM cow_file
                WHERE cow01[1,3] = l_slip
             WHEN l_type = '18'         #內銷申請單
               SELECT MAX(cnu01) INTO g_mxno FROM cnu_file
                WHERE cnu01[1,3] = l_slip
              #No.MOD-490398  --begin
             WHEN l_type = '19'         #核銷單
               #SELECT MAX(cns00) INTO g_mxno FROM cns_file
               # WHERE cns00[1,3] = l_slip
               SELECT MAX(cno01) INTO g_mxno FROM cno_file
                WHERE cno01[1,3] = l_slip
              #No.MOD-490398  --end   
             OTHERWISE EXIT CASE
           END CASE
        ELSE             #依年度期別
           LET l_date = l_year USING '&&&&',l_month USING '&&'
           LET l_date1[1,1]=l_date[4,4]
	         CASE WHEN l_month = 10 LET l_date1[2,2]='A'
                      WHEN l_month = 11 LET l_date1[2,2]='B'
	              WHEN l_month = 12 LET l_date1[2,2]='C'
	              OTHERWISE         LET l_date1[2,2]=l_date[6,6]
	         END CASE
           LET l_buf=l_slip,'-',l_date1
           CASE 
             WHEN l_type = '00'         #合同模擬單
               SELECT MAX(cng01) INTO g_mxno FROM cng_file
                WHERE cng01[1,6] = l_buf
             WHEN l_type = '10'         #合同申請單
               SELECT MAX(coc01) INTO g_mxno FROM coc_file
                WHERE coc01[1,6] = l_buf
             WHEN l_type = '11'         #設備申請單
               SELECT MAX(cos01) INTO g_mxno FROM cos_file
                WHERE cos01[1,6] = l_buf
             WHEN l_type = '12'         #加簽申請(出口)
               SELECT MAX(cog01) INTO g_mxno FROM cog_file
                WHERE cog01[1,6] = l_buf
             WHEN l_type = '13'         #加簽申請(進口)
               SELECT MAX(coi01) INTO g_mxno FROM coi_file
                WHERE coi01[1,6] = l_buf
             WHEN l_type = '14'         #報關申請
               SELECT MAX(cno01) INTO g_mxno FROM cno_file
                WHERE cno01[1,6] = l_buf
             WHEN l_type = '15'         #轉廠申請
               SELECT MAX(cnm01) INTO g_mxno FROM cnm_file
                WHERE cnm01[1,6] = l_buf
             WHEN l_type = '16'         #進口設備報關
               SELECT MAX(cou01) INTO g_mxno FROM cou_file
                WHERE cou01[1,6] = l_buf
             WHEN l_type = '17'         #免稅設備報關
               SELECT MAX(cow01) INTO g_mxno FROM cow_file
                WHERE cow01[1,6] = l_buf
             WHEN l_type = '18'         #內銷申請單
               SELECT MAX(cnu01) INTO g_mxno FROM cnu_file
                WHERE cnu01[1,6] = l_buf  
              #No.MOD-490398  --begin
             WHEN l_type = '19'         #核銷單
             #  SELECT MAX(cns00) INTO g_mxno FROM cns_file
             #   WHERE cns00[1,6] = l_buf  
               SELECT MAX(cno01) INTO g_mxno FROM cno_file
                WHERE cno01[1,6] = l_buf
              #No.MOD-490398  --end   
             OTHERWISE EXIT CASE
           END CASE
        END IF   
 
        LET l_mxno = g_mxno[5,10] 
 
	IF cl_null(p_slip[5,10]) THEN
           IF l_dmy2 = '1' THEN     #依流水號
	      IF l_mxno IS NULL OR l_mxno=' ' THEN	#最大編號未曾指定
	         LET l_mxno = '000000'
	      END IF
	      LET p_slip[5,10]=(l_mxno+1) USING '&&&&&&'
           ELSE                      #依年月
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
	      LET p_slip[5,10]=l_mxno[1,2],(l_mxno[3,6]+1) USING '&&&&'
          END IF
       END IF
 
	#因為4.0版本的不自動加上'-', 故在此吾人須多此一舉
	LET p_slip[4,4]='-'
	RETURN 0,p_slip
END FUNCTION
