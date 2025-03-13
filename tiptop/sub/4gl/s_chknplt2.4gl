# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_chknplt.4gl
# Descriptions...: 檢查工廠是否為可使用工廠
# Date & Author..: 
# Usage..........: IF NOT s_chkplt(p_plant,p_sys,p_toSys)
# Input Parameter: p_plant  工廠代號
#                  p_sys    使用系統代號
#                  p_toSys  關連系統代號
# Return code....: 1   YES
#                  0   NO
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.CHI-880003 08/08/06 By Sarah 移除azr_file相關程式段
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680147 INTEGER
FUNCTION s_chknplt2(p_plant,p_sys,p_ToSys)
DEFINE
	p_plant		LIKE azq_file.azq01,          #No.FUN-680147 VARCHAR(10)
	p_sys,p_ToSys   LIKE azq_file.azq03           #No.FUN-680147 VARCHAR(20)
 
	LET g_errno=' '
#IF g_multpl='N' THEN RETURN 0 END IF
 
	#檢查是否有此工廠
 	SELECT azp03 INTO g_dbs_new FROM azp_file
		WHERE azp01 = p_plant
	IF SQLCA.SQLCODE THEN
		LET g_errno='aom-300'
		RETURN 0
	END IF
 
	SELECT COUNT(*) INTO g_cnt
		FROM azq_file
		WHERE azq01=p_plant AND
			azq03=p_sys
	IF SQLCA.SQLCODE THEN
		LET g_errno='aom-302'
		RETURN 0
	END IF
 
        #No.FUN-7B0012  --Begin
        #LET g_dbs_new[21,21] = ':'
        #LET g_dbs_new=g_dbs_new CLIPPED,s_dbstring()
        LET g_dbs_new=s_dbstring(g_dbs_new CLIPPED)     #FUN-820017
        #No.FUN-7B0012  --End
 
       #str CHI-880003 mark
       ##檢查該工廠是否有符合的系統
       #SELECT COUNT(*) INTO g_cnt FROM azr_file
       #	WHERE azr01=g_plant AND azr03=p_plant
       #IF SQLCA.SQLCODE OR g_cnt=0 OR g_cnt IS NULL THEN
       #	LET g_errno='aom-301'
       #	RETURN 0
       #END IF
       #
       #IF p_sys IS NOT NULL THEN
       #	SELECT COUNT(*) INTO g_cnt FROM azr_file
       #		WHERE azr01=g_plant
       #			AND azr02=p_sys
       #			AND azr03=p_plant
       #			AND azr04 = p_ToSys
       #	IF SQLCA.SQLCODE OR g_cnt IS NULL OR g_cnt=0 THEN
       #		LET g_errno='aom-302'
       #		RETURN 0
       #	END IF
       #END IF
       #end CHI-880003 mark
 
	RETURN 1
END FUNCTION
