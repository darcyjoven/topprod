# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_ahe_qry.4gl
# Descriptions...: 以異動碼類型設定的qry代號開窗查詢
# Date & Author..: No.FUN-5C0015 06/02/14 By GILL
# Memo...........: 回傳異動碼值
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740024 07/04/10 By Judy 加錯誤信息
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:MOD-B60233 11/06/27 By Sarah p_seq=99開窗需只過濾關係人的資料
# Modify.........: No:MOD-BA0081 11/10/12 By Dido 增加限定條件 p_seq = 99 
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_ahe_qry(p_aag01,p_seq,p_type,p_def,p_bookno)  #No.FUN-730020
DEFINE p_aag01     LIKE aag_file.aag01      # 科目
DEFINE p_seq       LIKE aaz_file.aaz88      # 異動碼序
DEFINE p_type      LIKE type_file.chr1      # 'i' INPUT 'c' CONSTRUCT 	#No.FUN-680147 VARCHAR(1)
DEFINE p_def       LIKE npq_file.npq11      #參數預設值
DEFINE p_bookno    LIKE aag_file.aag00      #No.FUN-730020
DEFINE l_aag       RECORD LIKE aag_file.*   #會計科目 
DEFINE l_ahe06     LIKE ahe_file.ahe06      #QRY代號
DEFINE l_val       STRING                   #回傳值                      
DEFINE l_aag_v     LIKE aag_file.aag15      #異動碼代號
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   INITIALIZE l_aag.* TO NULL
   SELECT * INTO l_aag.* FROM aag_file WHERE aag01=p_aag01
                                         AND aag00=p_bookno   #No.FUN-730020
   IF STATUS THEN RETURN '' END IF
 
   INITIALIZE l_aag_v,l_ahe06 TO NULL
 
   CASE p_seq
 
      WHEN 1   LET l_aag_v = l_aag.aag15
      WHEN 2   LET l_aag_v = l_aag.aag16
      WHEN 3   LET l_aag_v = l_aag.aag17
      WHEN 4   LET l_aag_v = l_aag.aag18
      WHEN 5   LET l_aag_v = l_aag.aag31
      WHEN 6   LET l_aag_v = l_aag.aag32
      WHEN 7   LET l_aag_v = l_aag.aag33
      WHEN 8   LET l_aag_v = l_aag.aag34
      WHEN 9   LET l_aag_v = l_aag.aag35
      WHEN 10  LET l_aag_v = l_aag.aag36
      WHEN 99  LET l_aag_v = l_aag.aag37
 
   END CASE
 
   SELECT ahe06 INTO l_ahe06 FROM ahe_file      #QRY代號
    WHERE ahe01 = l_aag_v
   IF STATUS THEN 
      CALL cl_err('','ahe-001',0)   #TQC-740024
      RETURN '' 
   END IF
 
   CALL cl_init_qry_var()
   IF cl_null(l_ahe06) THEN 
      LET l_ahe06 = 'q_aee'
      LET g_qryparam.arg1 = p_aag01
      LET g_qryparam.arg2 = p_seq
      LET g_qryparam.arg3 = p_bookno   #No.FUN-730020
   END IF
   LET g_qryparam.form     = l_ahe06
   LET g_qryparam.state    = p_type 
   LET g_qryparam.default1 = p_def
  #str MOD-B60233 add
  #當l_ahe06是q_pmc開頭時,LET g_qryparam.where = " pmc903='Y'"
  #當l_ahe06是q_occ開頭時,LET g_qryparam.where = " occ37='Y'"
  #IF l_ahe06 MATCHES 'q_pmc*' THEN                 #MOD-BA0081 mark
   IF l_ahe06 MATCHES 'q_pmc*' AND p_seq = 99 THEN  #MOD-BA0081
      LET g_qryparam.where = " pmc903='Y'"
   END IF
  #IF l_ahe06 MATCHES 'q_occ*' THEN                 #MOD-BA0081 mark
   IF l_ahe06 MATCHES 'q_occ*' AND p_seq = 99 THEN  #MOD-BA0081
      LET g_qryparam.where = " occ37='Y'"
   END IF
  #end MOD-B60233 add
   CALL cl_create_qry() RETURNING l_val
 
   RETURN l_val
 
END FUNCTION
