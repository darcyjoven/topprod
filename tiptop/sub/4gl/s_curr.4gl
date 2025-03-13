# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_curr.4gl
# Descriptions...: 檢查幣別, 並依系統參數取得賣出匯率(OM使用)
# Date & Author..: 91/06/11 By LEE
# Usage..........: LET l_rate=s_curr(p_curr,p_date)
#                  CALL s_curr1(p_curr,p_date) RETURNING l_rate
# Input Parameter: p_curr  幣別
#                  p_date  日期
# Return code....: l_rate  匯率
# Memo...........: 1.系統參數aza17定義為本國幣別
#                  2.系統參數aza19定義為匯率取得方式
#                  3.若g_chr='E'無幣別資料
#                  4.檢查g_errno錯誤原因代號
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"        #No.FUN-680147  #FUN-7C0053
 
DEFINE g_azi RECORD LIKE azi_file.*		#幣別
 
FUNCTION s_curr(p_curr,p_date)
DEFINE
	p_curr	LIKE aza_file.aza17,          # Prog. Version..: '5.30.06-13.03.12(04) #幣別
	p_date	LIKE type_file.dat,           #No.FUN-680147 DATE #日期
	l_ym	LIKE azj_file.azj02,          # Prog. Version..: '5.30.06-13.03.12(04) #年月
	l_date	LIKE smh_file.smh01,          #No.FUN-680147 VARCHAR(08)
	l_rate	LIKE azj_file.azj03           #匯率
 
	WHENEVER ERROR CALL cl_err_msg_log
 
	LET g_errno=' '
 
	#檢查幣別檔
	SELECT *
		INTO g_azi.*
		FROM azi_file
		WHERE azi01=p_curr
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-011'
         WHEN g_azi.aziacti='N' LET g_errno = '9028'
         OTHERWISE  LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
	IF NOT cl_null(g_errno) THEN RETURN 1 END IF
	#若是本國幣別, 則O.K, 並給匯率1.0
	IF p_curr=g_aza.aza17 THEN RETURN 1.0 END IF
 
	IF g_aza.aza19='1' THEN	#取得每月匯率為匯率
		LET l_date=p_date USING 'yyyymmdd'
		LET l_ym=l_date[1,6]
		SELECT azj04                   #取得匯率
			INTO l_rate
			FROM azj_file
			WHERE azj01 = p_curr AND
				azj02 = l_ym
	ELSE				#取得每日匯率為匯率
		SELECT azk04                   #取得匯率
			INTO l_rate
			FROM azk_file
			WHERE azk01 = p_curr AND
				azk02 = p_date
	END IF
    IF SQLCA.sqlcode THEN
		LET g_errno='aom-011'
        LET l_rate=1.0
    END IF
    RETURN l_rate
END FUNCTION
