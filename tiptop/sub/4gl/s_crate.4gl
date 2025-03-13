# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_crate.4gl
# Descriptions...: 緊急比率計算
# Date & Author..: 92/08/19 By Nora
# Usage..........: CALL s_crate(l_sfb) RETURNING l_stat,l_crate
# Input Parameter: l_sfb.*
#                    sfb01   工單編號
#                    sfb05   料件編號
#                    sfb06   製程編號
#                    sfb071  有效日期
#                    sfb08   生產數量
#                    sfb09   完工數量
#                    sfb10   再加工數量
#                    sfb11   F.Q.C數量
#                    sfb12   報廢數量
#                    sfb15   完工日
#                    sfb17   己完工作業序號
#                    ima56   生產單位倍量
#                    ima59   固定前置時間
#                    ima60   變動前置時間
# Return code....: l_stat    結果
#                    0  OK
#                    1  BACK ORDER QTY.=0
#                    2  ERROR
#                  l_crate   緊急比率
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
GLOBALS
  DEFINE g_cnt     LIKE type_file.num10,         #No.FUN-680147 INTEGER
	 g_i       LIKE type_file.num5,          #No.FUN-680147 SMALLINT
	 g_chr     LIKE type_file.chr1           #No.FUN-680147 VARCHAR(01)
END GLOBALS
 
FUNCTION s_crate(l_sfb)
   DEFINE  l_sfb 	 RECORD
			sfb01   LIKE sfb_file.sfb01,		#工單編號
	   		sfb05	LIKE sfb_file.sfb05,		#料件編號
	   		sfb06	LIKE sfb_file.sfb06,		#製程編號
	   		sfb071  LIKE sfb_file.sfb071,		#有效日期
			sfb08	LIKE sfb_file.sfb08,		#生產數量
			sfb09	LIKE sfb_file.sfb09,		#完工數量
			sfb10	LIKE sfb_file.sfb10,		#再加工數量
			sfb11	LIKE sfb_file.sfb11,		#F.Q.C數量
			sfb12	LIKE sfb_file.sfb12,		#報廢數量
			sfb15	LIKE sfb_file.sfb15,		#完工日
			sfb17	LIKE sfb_file.sfb17,		#己完工作業序號
			ima56	LIKE ima_file.ima56,
			ima59   LIKE ima_file.ima59,
			ima60	LIKE ima_file.ima60
                 END RECORD,
	   l_nedhur  LIKE ima_file.ima59,        #No.FUN-680147 DECIMAL(8,3) #need hour
    	   l_remhur  LIKE ima_file.ima59,        #No.FUN-680147 DECIMAL(8,3) #remain hour
	   l_crate   LIKE sfb_file.sfb34,               #critical rate
           l_sfb93   LIKE sfb_file.sfb93,
	   l_boqty	 LIKE sfb_file.sfb08,          #No.FUN-680147 DECIMAL(13,5) #back order qty
	   l_ss		 LIKE type_file.num5,          #No.FUN-680147 SMALLINT #status code 1:ERROR
	   l_hour        LIKE type_file.num10,         #No.FUN-680147 INTEGER
	   l_flag	 LIKE type_file.chr1           #1:時距排程 2:製程排程        #No.FUN-680147 VARCHAR(01)
  DEFINE   l_ima601      LIKE ima_file.ima601          #No.FUN-840194 
	SELECT COUNT(*) INTO g_cnt FROM ecm_file WHERE
			ecm01 = l_sfb.sfb01 AND ecm11 = l_sfb.sfb06
			AND ecm03 >= l_sfb.sfb17
	IF SQLCA.sqlcode THEN
           CALL cl_err('',STATUS,0)
           RETURN 2,l_crate
        END IF
	LET l_flag = '1'
        SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=l_sfb.sfb01
        IF g_sma.sma28 = '2' AND l_sfb93 = 'Y' AND g_cnt > 0 THEN
           LET l_flag = '2'
        END IF
 
	#計算工單剩餘工時
	LET g_sma.sma30 = g_sma.sma30 + 1
	CALL s_wksize(g_sma.sma30,l_sfb.sfb15) RETURNING l_ss,l_remhur
	IF l_ss THEN RETURN 2,l_crate END IF
 
	IF l_sfb.ima56 IS NULL OR l_sfb.ima56 = 0 THEN
           LET l_sfb.ima56 = 1
	END IF
        SELECT ima601 INTO l_ima601 FROM ima_file WHERE ima01 = l_sfb.sfb01   #No.FUN-840194
	#計算工單尚需工時
	IF l_flag = '1' THEN
	   #計算 BACK ORDER QTY
           LET l_boqty = l_sfb.sfb08-(l_sfb.sfb09+l_sfb.sfb10+
                         l_sfb.sfb11+l_sfb.sfb12)
           IF l_boqty = 0 THEN RETURN 1,l_nedhur END IF
        #計算工單尚需工時
           LET l_hour = l_boqty/l_sfb.ima56 + 0.999
          #FUN-710073---mod---str---
          #LET l_nedhur = (l_hour * l_sfb.ima59 + l_boqty * l_sfb.ima60)  #No.FUN-840194 #CHI-810015 mark還原 
           LET l_nedhur = (l_hour * l_sfb.ima59 + l_boqty * l_sfb.ima60/l_ima601)  #No.FUN-840194 #CHI-810015 mark還原 
          #LET l_nedhur = (l_hour *(l_sfb.ima59 / l_sfb.ima56)+           #CHI-810015 mark
          #                l_boqty * (l_sfb.ima60 / l_sfb.ima56))         #CHI-810015 mark
          #FUN-710073---mod---end---
	ELSE
           CALL s_taskhur(l_sfb.sfb071,l_sfb.sfb01,
	                  l_sfb.sfb06,l_sfb.sfb08) RETURNING l_ss
           IF l_ss THEN RETURN 1,l_crate END IF
           LET l_nedhur = 0
           FOR g_i = g_cnt TO 1 STEP -1
               LET l_nedhur = l_nedhur + g_takhur[g_i].takhur
               IF g_takhur[g_i].ecb03 = l_sfb.sfb17 THEN EXIT FOR END IF
           END FOR
           IF g_i = 0 THEN RETURN 2,l_crate END IF
           IF g_i > 1 THEN LET g_i = g_i - 1 END IF
        END IF
           IF l_nedhur = 0 THEN RETURN 1,l_crate END IF
           LET l_crate = l_remhur/l_nedhur
           RETURN 0,l_crate
END FUNCTION
#Patch....NO.TQC-610035 <001> #
