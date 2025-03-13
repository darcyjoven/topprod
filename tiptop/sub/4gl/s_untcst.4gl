# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_untcst.4gl
# Descriptions...: 料件單位成本計算
# Date & Author..: 92/01/24 By Carol
# Usage..........: CALL s_untcst(p_opt,p_part,p_stat) RETURNING l_flag,l_cost
# Input Parameter: p_opt   成本分類
#                     1      標準成本(Standard Cost)
#                     2      現時成本(Current Cost)
#                     3      預設成本(Proposed Cost)
#                  p_part  料件編號 
#                  p_stat  成本要素來源是否改變
# Return code....: l_flag  0  成功
#                          1  成本分類有誤 NOT MATCHES '123' 
#                          2  無此料件編號
#                  l_cost  成本        
# Modify.........: No.MOD-530205 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or LIKE type_file.num20_6	#No.FUN-680147
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_untcst(p_opt,p_part,p_stat)
    DEFINE  p_opt    LIKE type_file.chr1,                 #Kind of Cost 	#No.FUN-680147 VARCHAR(01)
            p_part   LIKE imb_file.imb01,    #Part Number
            p_stat   LIKE type_file.chr1,                 #SQLCA.sqlcode 	#No.FUN-680147 VARCHAR(01)
            l_err    LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
 	    l_cost   LIKE imb_file.imb118, #MOD-530205
	    l_imb    RECORD LIKE imb_file.*,
	    l_ima08  LIKE ima_file.ima08
 
	LET l_err = 0
    IF p_opt  IS NULL OR p_opt NOT MATCHES '[123]' THEN  RETURN 1,0 END IF
    IF p_part IS NULL THEN  RETURN 2,0 END IF
    IF p_stat NOT MATCHES '[Yy]' THEN LET p_stat = 'N' END IF
 
    SELECT imb_file.*,ima08 INTO l_imb.*, l_ima08 FROM imb_file,ima_file 
	 WHERE imb01 = p_part AND ima01 = imb01
	IF SQLCA.sqlcode THEN RETURN 2,0 END IF
    IF (l_ima08 NOT MATCHES '[PVZ]' AND p_stat ='N') OR
       (l_ima08     MATCHES '[PVZ]' AND p_stat ='Y') THEN
       CASE p_opt
		    WHEN '1'
			 LET l_cost=l_imb.imb111+l_imb.imb112+l_imb.imb1131+l_imb.imb1132+
						l_imb.imb114+l_imb.imb115+l_imb.imb116+l_imb.imb1171+
						l_imb.imb1172+l_imb.imb119+l_imb.imb120+l_imb.imb121+
						l_imb.imb122+l_imb.imb1231+ l_imb.imb1232+l_imb.imb124+
						l_imb.imb125+l_imb.imb126+l_imb.imb1271+l_imb.imb1272+
						l_imb.imb129+l_imb.imb130
		    WHEN '2'
			 LET l_cost=l_imb.imb211+l_imb.imb212+l_imb.imb2131+l_imb.imb2132+
						l_imb.imb214+l_imb.imb215+l_imb.imb216+l_imb.imb2171+
					  	l_imb.imb2172+ l_imb.imb219+l_imb.imb220+l_imb.imb221 +
						l_imb.imb222+l_imb.imb2231+ l_imb.imb2232+l_imb.imb224 +
						l_imb.imb225+l_imb.imb226+l_imb.imb2271+l_imb.imb2272+
						l_imb.imb229+l_imb.imb230
		    WHEN '3'
			 LET l_cost=l_imb.imb311+l_imb.imb312+l_imb.imb3131+l_imb.imb3132+
				        l_imb.imb314+l_imb.imb315+l_imb.imb316+l_imb.imb3171+
						l_imb.imb3172+ l_imb.imb319+l_imb.imb320+l_imb.imb321 +
						l_imb.imb322+l_imb.imb3231+ l_imb.imb3232+l_imb.imb324 +
						l_imb.imb325+l_imb.imb326+l_imb.imb3271+l_imb.imb3272+
						l_imb.imb329+l_imb.imb330
	   END CASE
    ELSE
       CASE p_opt
		    WHEN '1'
				 LET l_cost=l_imb.imb118
		    WHEN '2'
				 LET l_cost=l_imb.imb218
		    WHEN '3'
				 LET l_cost=l_imb.imb318
	   END CASE
    END IF
	RETURN 0,l_cost
END FUNCTION
