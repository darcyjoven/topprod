# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_umfchk.4gl
# Descriptions...: 兩單位間之轉換率計算與檢查
# Date & Author..: 90/09/26 By  Wu
# Usage..........: CALL s_umfchk(p_item,p_1,p_2) RETURNING l_flag,l_fac
# Input Parameter: p_item  料件	 
#                  p_1     來源單位
#                  p_2     目的單位
# Return code....: l_flag  是否有此單位轉換
#                     0	OK
#                     1	ERROR
#                  l_fac    轉換率
# Modify.........: 99/03/25 By Carol:MISC的料件無須作單位間的轉換率計算
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-870265 08/07/23 By claire 單位換算率的變數定義小數位放大減少誤差值
# Modify.........: No:TQC-C50233 12/05/29 By SunLM 將STATUS替換為sqlca.sqlcode='100'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_umfchk(p_item,p_1,p_2)
    DEFINE  p_item     LIKE smd_file.smd01, #No.MOD-490217
           p_1        LIKE smd_file.smd02,      #No.FUN-680147 VARCHAR(04)
           p_2        LIKE smd_file.smd03,      #No.FUN-680147 VARCHAR(04)
           l_flag     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
           l_factor   LIKE type_file.num26_10,  #MOD-870265 modify ima_file.ima31_fac, 	#No.FUN-680147 DECIMAL(16,8)
           l_su       LIKE ima_file.ima31_fac,  #來源單位兌換數量 	#No.FUN-680147 DECIMAL(16,8)
           l_tu       LIKE ima_file.ima31_fac   #目的單位兌換數量 	#No.FUN-680147 DECIMAL(16,8)
 
#....加入MISC的判斷
     IF p_1=p_2 OR p_item[1,4]='MISC' THEN RETURN 0,1.0 END IF
     
     LET l_flag  = 0
     SELECT smd04,smd06 INTO l_su,l_tu       #check 料件單位換算
            FROM smd_file WHERE smd01=p_item AND smd02=p_1 AND smd03=p_2
     #IF STATUS THEN TQC-C50233
     IF sqlca.sqlcode ='100' THEN
        SELECT smd06,smd04 INTO l_su,l_tu       #check 料件單位換算
               FROM smd_file WHERE smd01=p_item AND smd02=p_2 AND smd03=p_1
        #IF STATUS THEN TQC-C50233
        IF sqlca.sqlcode ='100' THEN 
           SELECT smc03,smc04 INTO l_su,l_tu
                  FROM smc_file WHERE smc01=p_1 AND smc02=p_2
                   AND smcacti='Y'    #NO:4757
           #IF STATUS THEN LET l_flag = 1 END IF TQC-C50233
           IF sqlca.sqlcode ='100' THEN LET l_flag = 1 END IF
        END IF
     END IF
     IF l_flag = 0 
        THEN IF l_su = 0 OR l_su IS NULL
                THEN LET  l_factor = 0
                ELSE LET  l_factor = l_tu / l_su     #轉換率
             END IF
     END IF
   RETURN l_flag,l_factor
END FUNCTION
