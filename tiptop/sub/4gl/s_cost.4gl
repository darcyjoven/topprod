# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_cost.4gl
# Descriptions...: 取得標準, 現時, 預設成本
# Date & Author..: 92/04/01 By  Wu
# Usage..........: LET l_cost=s_cost(p_code,p_source,p_part)
# Input Parameter: p_code     取得方式
#                    1  標準
#                    2  現時
#                    3  預設
#                  p_source   來源碼
#                  p_part     料件編號
# Return code....: l_cost     標準/現時/預設成本
# Memo...........: 本日為1992年愚人節
# Modify.........: No.MOD-530205 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_cost(p_code,p_source,p_part)
   DEFINE  p_code          LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01) 
		   p_source        LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(01)
		   p_part          LIKE imb_file.imb01,
 		   l_cost          LIKE imb_file.imb118, #MOD-530205
		   l_imb RECORD    LIKE imb_file.*
  
#1.標準成本 2.現時成本 3.預設成本
        SELECT * INTO l_imb.* FROM imb_file 
							 WHERE imb01 = p_part AND 
								   imbacti IN ('y','Y')
        IF SQLCA.sqlcode THEN RETURN 0 END IF 
        CASE p_code 
           WHEN '1'
			IF p_source matches'[PVZ]' THEN 
			     LET l_cost = l_imb.imb118
            ELSE LET l_cost=
                l_imb.imb111 +l_imb.imb112 +l_imb.imb1131+l_imb.imb1132+
				l_imb.imb114 +l_imb.imb115 +l_imb.imb1151+l_imb.imb116 +l_imb.imb1171+
				l_imb.imb1172+l_imb.imb119 +l_imb.imb120 +l_imb.imb121 +
				l_imb.imb122 +l_imb.imb1231+l_imb.imb1232+l_imb.imb124 +
				l_imb.imb125 +l_imb.imb126 +l_imb.imb1271+l_imb.imb1272+
				l_imb.imb129 +l_imb.imb130
           END IF
           WHEN '2'
			IF p_source matches'[PVZ]' THEN 
			     LET l_cost = l_imb.imb218
            ELSE LET l_cost=
                l_imb.imb211 +l_imb.imb212 +l_imb.imb2131+l_imb.imb2132+
				l_imb.imb214 +l_imb.imb215 +l_imb.imb2151+l_imb.imb216 +l_imb.imb2171+
				l_imb.imb2172+l_imb.imb219 +l_imb.imb220 +l_imb.imb221 +
				l_imb.imb222 +l_imb.imb2231+l_imb.imb2232+l_imb.imb224 +
				l_imb.imb225 +l_imb.imb226 +l_imb.imb2271+l_imb.imb2272+
				l_imb.imb229 +l_imb.imb230
           END IF
           WHEN '3'
			IF p_source matches'[PVZ]' THEN 
			     LET l_cost = l_imb.imb318
            ELSE LET l_cost=
                l_imb.imb311 +l_imb.imb312 +l_imb.imb3131+l_imb.imb3132+
				l_imb.imb314 +l_imb.imb315+l_imb.imb3151+l_imb.imb316 +l_imb.imb3171+
				l_imb.imb3172+l_imb.imb319 +l_imb.imb320 +l_imb.imb321 +
				l_imb.imb322 +l_imb.imb3231+l_imb.imb3232+l_imb.imb324 +
				l_imb.imb325 +l_imb.imb326 +l_imb.imb3271+l_imb.imb3272+
				l_imb.imb329 +l_imb.imb330
           END IF
        END CASE
		IF l_cost IS NULL THEN LET l_cost = 0 END IF
   RETURN l_cost 
END FUNCTION
