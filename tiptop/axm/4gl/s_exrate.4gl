# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
#
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
FUNCTION s_exrate(o_curr,d_curr,p_rate)		
 DEFINE o_curr        	LIKE aza_file.aza17       # Prog. Version..: '5.30.06-13.03.12(04)  # 來源幣別 #TQC-840066
 DEFINE d_curr         	LIKE aza_file.aza17       # Prog. Version..: '5.30.06-13.03.12(04)  # 目的幣別 #TQC-840066
 DEFINE p_rate	        LIKE type_file.chr1     # B:銀行買入 S:銀行賣出 M:銀行中價  # No.FUN-680137 VARCHAR(01)
                                                # P:海關旬 C:海關買入D:海關賣出
 DEFINE p_exrate        LIKE pml_file.pml09      # No.FUN-680137 DEC(15,8)
 DEFINE p_aza		RECORD LIKE aza_file.*
 DEFINE p_azk1	        RECORD LIKE azk_file.*
 DEFINE p_azk2	        RECORD LIKE azk_file.*
 DEFINE l_date          LIKE type_file.dat         # No.FUN-680137 DATE
 
 WHENEVER ERROR CONTINUE
 SELECT * INTO p_aza.* FROM aza_file WHERE aza01='0'
 IF STATUS <> 0 THEN RETURN 0 END IF
 IF o_curr = d_curr THEN 
    RETURN 1
 END IF
 LET l_date=TODAY
 IF o_curr = p_aza.aza17 THEN
    LET p_azk1.azk03=1
    LET p_azk1.azk04=1
    LET p_azk1.azk041=1
    LET p_azk1.azk05=1
    LET p_azk1.azk051=1
    LET p_azk1.azk052=1
 ELSE
    DECLARE azk_cur1 CURSOR FOR 
     SELECT * FROM azk_file 
      WHERE azk01=o_curr AND azk02 <= l_date ORDER BY azk02 DESC
    OPEN azk_cur1
    FETCH azk_cur1 INTO p_azk1.*
    IF STATUS <> 0 THEN
       CLOSE azk_cur1
       RETURN 0
    END IF
    CLOSE azk_cur1
 END IF
 IF d_curr = p_aza.aza17 THEN
    LET p_azk2.azk03=1
    LET p_azk2.azk04=1
    LET p_azk2.azk041=1
    LET p_azk2.azk05=1
    LET p_azk2.azk051=1
    LET p_azk2.azk052=1
 ELSE
    DECLARE azk_cur2 CURSOR FOR 
     SELECT * FROM azk_file 
      WHERE azk01=d_curr AND azk02 <= l_date ORDER BY azk02 DESC
    OPEN azk_cur2
    FETCH azk_cur2 INTO p_azk2.*
    IF STATUS <> 0 THEN
       CLOSE azk_cur2
       RETURN 0
    END IF
    CLOSE azk_cur2
 END IF
 LET p_exrate=0
 
 #No.+048  依oaz212 參數決定使用之匯率
 CASE WHEN p_rate='B' 
           IF p_azk2.azk03 <> 0 THEN
              LET p_exrate=p_azk1.azk03/p_azk2.azk03
           END IF
      WHEN p_rate='S' 
           IF p_azk2.azk04 <> 0 THEN
              LET p_exrate=p_azk1.azk04/p_azk2.azk04
           END IF
      WHEN p_rate='M' 
           IF p_azk2.azk041 <> 0 THEN
              LET p_exrate=p_azk1.azk041/p_azk2.azk041
           END IF
      WHEN p_rate='P' 
           IF p_azk2.azk05 <> 0 THEN
              LET p_exrate=p_azk1.azk05/p_azk2.azk05
           END IF
      WHEN p_rate='C' 
           IF p_azk2.azk051 <> 0 THEN
              LET p_exrate=p_azk1.azk051/p_azk2.azk051
           END IF
      WHEN p_rate='D' 
           IF p_azk2.azk052 <> 0 THEN
              LET p_exrate=p_azk1.azk052/p_azk2.azk052
           END IF
 END CASE
    RETURN  p_exrate
 
END FUNCTION
