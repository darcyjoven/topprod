# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
##□ s_currX
##SYNTAX	LET l_rate=s_currX(p_curr,p_date,p_bs)
##DESCRIPTION	取得該幣別在該日期或該月份的買入或賣出匯率
##PARAMETERS	p_curr	幣別
##		p_date	日期
##		p_bs	B:買入/S:賣出 /C:海關
##RETURNING	l_rate	匯率
##NOTE		若g_chr='E'則無幣別資料或無每月匯率資料或無每日匯率資料
# Date & Author..: 91/06/11 By LEE
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
#
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
    DEFINE g_chr     LIKE type_file.chr1          #No.FUN-680123 VARCHAR(01)
END GLOBALS
 
FUNCTION s_currX(p_curr,p_date,p_bs)
DEFINE
    p_curr           LIKE azi_file.azi01,         # Prog. Version..: '5.30.06-13.03.12(04) #幣別
    p_date           LIKE type_file.dat,          #No.FUN-680123 DATE     #日期
    p_bs             LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1)  #B:買入/S:賣出
    l_rate           LIKE azj_file.azj03,
    l_r1,l_r2,l_r3   LIKE azj_file.azj03,
    l_ym             LIKE azj_file.azj02,         #No.FUN-680123 VARCHAR(6)  # YYYYMM
    l_buf            LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(20)
 
    WHENEVER ERROR CONTINUE
    IF p_date IS NULL THEN LET p_date=MDY(12,31,9999) END IF
#-----> Modify By Jones   -------92/12/02---------
# 捉出整體系統參數
    SELECT * INTO g_aza.* FROM aza_file WHERE aza01 = '0'
    IF p_curr = g_aza.aza17 THEN RETURN 1 END IF
#------------------------------------------------
    CASE
      WHEN g_aza.aza19 = '1'		#取每月匯率
          LET l_ym = p_date USING 'yyyymm'
          SELECT azj03,azj04 INTO l_r1,l_r2 FROM azj_file
           WHERE azj01 = p_curr AND azj02 = l_ym
          IF SQLCA.sqlcode THEN
              LET l_buf = p_curr,'+',l_ym
#             CALL cl_err(l_buf,'aoo-056',0)   #No.FUN-660116
              CALL cl_err3("sel","azj_file",p_curr,l_ym,"aoo-056","",l_buf,0)   #No.FUN-660116
              LET l_r1=1.0 LET l_r2=1.0
	     LET l_buf = p_curr CLIPPED,'+',p_date
               LET g_success = 'N' CALL cl_err(l_buf,'kxm-014',0)  
          END IF
      WHEN g_aza.aza19 = '2'		#取每日匯率
          SELECT azk03,azk04,azk05 INTO l_r1,l_r2,l_r3
            FROM azk_file
           WHERE azk01 = p_curr AND azk02 = p_date
	  IF SQLCA.sqlcode THEN	#每日取不到時, 取最近匯率
	     LET l_buf = p_curr CLIPPED,'+',p_date
	             LET g_success = 'N' 
#              CALL cl_err(l_buf,'kxm-014',0)   #No.FUN-660116
               CALL cl_err3("sel","azk_file",p_curr,p_date,"kxm-014","",l_buf,0)   #No.FUN-660116
            #SELECT azk03,azk04,azk05 INTO l_r1,l_r2,l_r3 FROM azk_file
            # WHERE azk01 = p_curr
            #   AND azk02=(SELECT MAX(azk02) FROM azk_file
            #               WHERE azk01=p_curr AND azk02<=p_date)
            #IF SQLCA.sqlcode THEN	#無最近匯率, 則設為一
	#LET l_buf = p_curr CLIPPED,'+',p_date
  	#CALL cl_err(l_buf,'aoo-057',0)  
	#LET l_r1=1.0 LET l_r2=1.0
	#    END IF
	  END IF
      OTHERWISE LET l_r1 = 1 LET l_r2 = 1
    END CASE
    CASE
      WHEN p_bs = 'B' LET l_rate = l_r1
      WHEN p_bs = 'S' LET l_rate = l_r2
      WHEN p_bs = 'C' LET l_rate = l_r3
      OTHERWISE       LET l_rate = 1
    END CASE
    RETURN l_rate
END FUNCTION
