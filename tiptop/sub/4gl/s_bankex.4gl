# Prog. Version..: '5.30.06-13.04.16(00004)'     #
#
# Program name...: s_bankex.4gl
# Descriptions...: 計算外幣銀行存款出帳匯率 (return 匯率)
# Date & Author..: 
# Modify.........: No:7952 03/09/03 By Wiky 修改匯率
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-890226 08/09/24 By Sarah CALL s_curr3()時傳入的第三個參數改為'S'
# Modify.........: No.MOD-9A0024 09/10/19 By sabrina l_ex 改成LIKE azk_file.azk03
# Modify.........: No.MOD-C90193 12/09/24 By Polly 會計日屬於ERP交易日期，本期存入與提出是以會計日為主
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE g_curr	LIKE nma_file.nma10 	#No.FUN-680147 VARCHAR(4)
 
FUNCTION s_bankex(p_bank,p_date)
  DEFINE p_bank		LIKE nma_file.nma01 	#No.FUN-680147 VARCHAR(11)
  DEFINE p_date		LIKE type_file.dat    	#No.FUN-680147 DATE
 #DEFINE l_ex		LIKE type_file.num20_6 #No:7952   #No.FUN-4C0010 #No.FUN-680147 DEC(20,6) #MOD-9A0024 mark
  DEFINE l_ex		LIKE azk_file.azk03               #MOD-9A0024 add 
 
  SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0'
  SELECT nma10 INTO g_curr FROM nma_file WHERE nma01=p_bank
  IF g_nmz.nmz04='1'
     THEN CALL s_bankex1(p_bank,p_date) RETURNING l_ex
     ELSE CALL s_curr3(g_curr,p_date,'S') RETURNING l_ex   #MOD-890226 mod 'B'->'S'
  END IF
  RETURN l_ex
END FUNCTION
 
FUNCTION s_bankex1(p_bank,p_date)
DEFINE p_bank		LIKE nma_file.nma01 	#No.FUN-680147 VARCHAR(11)
DEFINE p_date		LIKE type_file.dat    	#No.FUN-680147 DATE
#DEFINE l_ex		LIKE type_file.num20_6  #No:7952   #No.FUN-4C0010#No.FUN-680147 DEC(20,6) #MOD-9A0024 mark
DEFINE l_ex		LIKE azk_file.azk03     #MOD-9A0024 add 
DEFINE l_yy,l_mm	LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE l_date		LIKE type_file.dat    	#No.FUN-680147 DATE
DEFINE a1,a2,b1,b2,b3,b4 LIKE type_file.num20_6  #No.FUN-4C0010 	#No.FUN-680147 DEC(20,6)
 
    IF g_curr=g_aza.aza17 THEN LET l_ex=1 RETURN l_ex END IF
    LET l_yy=YEAR(p_date) USING '&&&&' LET l_mm=MONTH(p_date)
    #-------------------- 再往前推一個月 ------------------------------
    LET l_date=MDY(l_mm,1,l_yy)			# 當月第一日
    #------------------------------------------------------------------
    LET l_mm=l_mm-1				# 上期年月
    IF l_mm=0 THEN LET l_yy=l_yy-1 LET l_mm=12 END IF
    SELECT nmp16,nmp19 INTO a1,a2		#上月結存
      FROM nmp_file
     WHERE nmp01=p_bank AND nmp02=l_yy AND nmp03=l_mm
    SELECT SUM(nme04),SUM(nme08) INTO b1,b2	#本月存入
      FROM nme_file, nmc_file
     WHERE nme01=p_bank AND nme03=nmc01 AND nmc03='1'
      #AND nme02 >= l_date AND nme02 <= p_date           #MOD-C90193 mark
       AND nme16 >= l_date AND nme16 <= p_date           #MOD-C90193 add
    SELECT SUM(nme04),SUM(nme08) INTO b3,b4	#本月提出
      FROM nme_file, nmc_file
     WHERE nme01=p_bank AND nme03=nmc01 AND nmc03='2'
      #AND nme02 >= l_date AND nme02 <= p_date           #MOD-C90193 mark
       AND nme16 >= l_date AND nme16 <= p_date           #MOD-C90193 add
    IF a1 IS NULL THEN LET a1=0 END IF
    IF a2 IS NULL THEN LET a2=0 END IF
    IF b1 IS NULL THEN LET b1=0 END IF
    IF b2 IS NULL THEN LET b2=0 END IF
    IF b3 IS NULL THEN LET b3=0 END IF
    IF b4 IS NULL THEN LET b4=0 END IF
    IF a1+b1-b3=0
       THEN # ERROR "無庫存現金, 匯率暫設為 0"
            LET l_ex=0
       ELSE LET l_ex=(a2+b2-b4)/(a1+b1-b3)
    END IF
    RETURN l_ex
END FUNCTION
