# Prog. Version..: '5.30.07-13.05.20(00004)'     #
#
# Pattern name...: s_minus_ce.4gl
# Descriptions...: 损益类科目 帐结法时 月结余额会被结清,正常报表呈现零,故需要把CE凭证中该科目的值减回来
# Date & Author..: 11/12/05 By Carrier   #No.MOD-BC0032
# Usage..........: CALL s_minus_ce(p_aeh00,   p_aeh01_1, p_aeh01_2, p_aeh02_1, p_aeh02_2,  p_aeh03,
#                                  p_aeh04,   p_aeh05,   p_aeh06,   p_aeh07,   p_aeh08,    p_aeh09,
#                                  p_aeh10_1, p_aeh10_2, p_aeh17,   p_aeh31,   p_aeh32,    p_aeh33,
#                                  p_aeh34,   p_aeh35,   p_aeh36,   p_aeh37,   p_plant,    p_aaa09)
# Input Parameter: p_aeh00         帳別
#                  p_aeh01_1       FROM 科目編號1
#                  p_aeh01_2       FROM 科目編號2
#                  p_aeh02_1       FROM 部門編號1
#                  p_aeh02_2       FROM 部門編號2
#                  p_aeh03         專案編號
#                  p_aeh04         異動碼-1
#                  p_aeh05         異動碼-2
#                  p_aeh06         異動碼-3
#                  p_aeh07         異動碼-4
#                  p_aeh08         預算編號
#                  p_aeh09         會計年度
#                  p_aeh10_1       FROM 期別1
#                  p_aeh10_2       FROM 期別2
#                  p_aeh17         幣別
#                  p_aeh31         異動碼-5
#                  p_aeh32         異動碼-6
#                  p_aeh33         異動碼-7
#                  p_aeh34         異動碼-8
#                  p_aeh35         異動碼-9
#                  p_aeh36         異動碼-10
#                  p_aeh37         異動碼-關系人
#                  p_plant         所属营运中心
#                  p_aaa09         结帐方式
# Return code....: l_aeh11         借方金額
#                  l_aeh12         貸方金額
#                  l_aeh15         原幣借方金額
#                  l_aeh16         原幣貸方金額
# Modify.........: 
# Modify.........: No.MOD-C40008 12/04/03 By Polly 調整回傳值
# Modify.........: No.CHI-C70031 12/09/11 By chenying 21區CHI-C70031追單
# Modify.........: No.FUN-D40044 13/04/26 By zhangweib 修改核算項非空加WHERE條件的判斷,應為AEH_FILE中的核算項都是非空的,所以在產生aeh_file資料的時候
#                                                      核算項沒有值的情況下會給空格,所以在這裡判斷核算項的時候應該用cl_null而不是IS NOT NULL

DATABASE ds

GLOBALS "../../config/top.global"    #No.MOD-BC0032
DEFINE g_sql          STRING
DEFINE g_sql1         STRING

FUNCTION s_minus_ce( p_aeh00,   p_aeh01_1, p_aeh01_2, p_aeh02_1, p_aeh02_2,  p_aeh03,
                     p_aeh04,   p_aeh05,   p_aeh06,   p_aeh07,   p_aeh08,    p_aeh09,
                     p_aeh10_1, p_aeh10_2, p_aeh17,   p_aeh31,   p_aeh32,    p_aeh33,
                     p_aeh34,   p_aeh35,   p_aeh36,   p_aeh37,   p_plant,    p_aaa09, p_flag)  #CHI-C70031 add p_flag
   DEFINE p_aeh00    LIKE aeh_file.aeh00      #帳別
   DEFINE p_aeh01_1  LIKE aeh_file.aeh01      #FROM 科目編號1
   DEFINE p_aeh01_2  LIKE aeh_file.aeh01      #FROM 科目編號2
   DEFINE p_aeh02_1  LIKE aeh_file.aeh02      #FROM 部門編號1
   DEFINE p_aeh02_2  LIKE aeh_file.aeh02      #FROM 部門編號1
   DEFINE p_aeh03    LIKE aeh_file.aeh03      #專案編號
   DEFINE p_aeh04    LIKE aeh_file.aeh04      #異動碼-1
   DEFINE p_aeh05    LIKE aeh_file.aeh05      #異動碼-2
   DEFINE p_aeh06    LIKE aeh_file.aeh06      #異動碼-3
   DEFINE p_aeh07    LIKE aeh_file.aeh07      #異動碼-4
   DEFINE p_aeh08    LIKE aeh_file.aeh08      #預算編號
   DEFINE p_aeh09    LIKE aeh_file.aeh09      #會計年度
   DEFINE p_aeh10_1  LIKE aeh_file.aeh10      #FROM 期別1
   DEFINE p_aeh10_2  LIKE aeh_file.aeh10      #FROM 期別2
   DEFINE p_aeh17    LIKE aeh_file.aeh17      #幣別
   DEFINE p_aeh31    LIKE aeh_file.aeh31      #異動碼-5
   DEFINE p_aeh32    LIKE aeh_file.aeh32      #異動碼-6
   DEFINE p_aeh33    LIKE aeh_file.aeh33      #異動碼-7
   DEFINE p_aeh34    LIKE aeh_file.aeh34      #異動碼-8
   DEFINE p_aeh35    LIKE aeh_file.aeh35      #異動碼-9
   DEFINE p_aeh36    LIKE aeh_file.aeh36      #異動碼-10
   DEFINE p_aeh37    LIKE aeh_file.aeh37      #異動碼-關系人
   DEFINE p_plant    LIKE type_file.chr21     #所屬营运中心
   DEFINE p_aaa09    LIKE aaa_file.aaa09      #结帐方式
   DEFINE p_flag     LIKE type_file.chr1      #科目編號採取BETWEEN AND還是LIKE #CHI-C70031
   DEFINE l_aeh11    LIKE aeh_file.aeh11      #借方金額
   DEFINE l_aeh12    LIKE aeh_file.aeh12      #貸方金額
   DEFINE l_aeh15    LIKE aeh_file.aeh15      #原幣借方金額
   DEFINE l_aeh16    LIKE aeh_file.aeh16      #原幣貸方金額
   DEFINE l_aaa09    LIKE aaa_file.aaa09
   DEFINE l_str      STRING                   #CHI-C70031

   WHENEVER ERROR CALL cl_err_msg_log

   #帐别/科目/年/月
   IF cl_null(p_aeh00) OR cl_null(p_aeh01_1) OR cl_null(p_aeh09) OR cl_null(p_aeh10_1) THEN
      RETURN 0,0,0,0
   END IF

   #截止科目
   IF cl_null(p_aeh01_2) THEN LET p_aeh01_2 = p_aeh01_1 END IF

   #截止期别
   IF cl_null(p_aeh10_2) THEN LET p_aeh10_2 = p_aeh10_1 END IF

   #截止部门
   IF cl_null(p_aeh02_2) THEN LET p_aeh02_2 = p_aeh02_1 END IF

   LET l_aeh11 = 0   LET l_aeh12 = 0 
   LET l_aeh15 = 0   LET l_aeh16 = 0

   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF

   IF p_aaa09 MATCHES '[12]' THEN
      LET l_aaa09 = p_aaa09
   ELSE
      LET g_sql = " SELECT aaa09 FROM ",cl_get_target_table(p_plant,'aaa_file'),
                  "  WHERE aaa01 = '",p_aeh00,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE aaa09_p1 FROM g_sql
      EXECUTE aaa09_p1 INTO l_aaa09
      IF SQLCA.sqlcode <> 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','select aaa_file fail',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3('sel','aaa_file',p_aeh00,'',SQLCA.sqlcode,'','select aaa09',1)
         END IF
         LET g_success = 'N'
         RETURN 0,0,0,0
      END IF
   END IF

   #仅帐结法需要执行本功能
  #IF l_aaa09 <> '2' THEN RETURN END IF   #MOD-C40008 mark
   IF l_aaa09 <> '2' THEN                 #MOD-C40008 add
      RETURN 0,0,0,0                      #MOD-C40008 add
   END IF                                 #MOD-C40008 add

   LET g_sql = " SELECT SUM(abb07),SUM(abb07f) FROM ",cl_get_target_table(p_plant,'aba_file'),",",
                                                      cl_get_target_table(p_plant,'abb_file'),
               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
               "    AND aba00 = '",p_aeh00,"'",
               "    AND aba03 =  ",p_aeh09,
               "    AND aba04 BETWEEN  ",p_aeh10_1,"  AND  ",p_aeh10_2,
               "    AND ( aba06 = 'CE'",                                            #CHI-C70031 add (
               "    OR (aba06 = 'CA' AND aba07 IN (SELECT cdb13 FROM cdb_file ",    #CHI-C70031
               "    WHERE cdb01 = ",p_aeh09,                                        #CHI-C70031
               "      AND cdb02 BETWEEN  ",p_aeh10_1,"  AND  ",p_aeh10_2,           #CHI-C70031
               "      AND cdb13 IS NOT NULL)))" ,                                   #CHI-C70031    
               "    AND aba19 = 'Y' AND abapost = 'Y' " 
              #"    AND abb03 BETWEEN '",p_aeh01_1,"' AND '",p_aeh01_2,"'"          #CHI-C70031 
   #No.CHI-C70031  --Begin
   IF p_flag = '0'  THEN
      LET g_sql = g_sql CLIPPED,"  AND abb03 BETWEEN '",p_aeh01_1,"' AND '",p_aeh01_2,"'"
   ELSE
      LET l_str = p_aeh01_1
      IF l_str.getindexof("%",1) > 0 THEN
         LET g_sql = g_sql CLIPPED," AND abb03 LIKE '",p_aeh01_1,"'"
      ELSE
         LET g_sql = g_sql CLIPPED," AND abb03 LIKE '",p_aeh01_1,"%'"
      END IF
   END IF
   #No.CHI-C70031  --End
   IF p_aeh02_1 IS NOT NULL THEN
      LET g_sql = g_sql CLIPPED," AND abb05 BETWEEN '",p_aeh02_1,"' AND '",p_aeh02_2,"'"      #部门
   END IF
   IF p_aeh03 IS NOT NULL THEN
      LET g_sql = g_sql CLIPPED," AND abb08 = '",p_aeh03,"'"      #专案编号
   END IF
  #No.FUN-D40044 ---Mark--- str
  #IF p_aeh04 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb11 = '",p_aeh04,"'"      #核算项1
  #END IF
  #IF p_aeh05 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb12 = '",p_aeh05,"'"      #核算项2
  #END IF
  #IF p_aeh06 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb13 = '",p_aeh06,"'"      #核算项3
  #END IF
  #IF p_aeh07 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb14 = '",p_aeh07,"'"      #核算项4
  #END IF
  #No.FUN-D40044 ---Mark--- end
   IF p_aeh08 IS NOT NULL THEN
      LET g_sql = g_sql CLIPPED," AND abb15 = '",p_aeh08,"'"      #预算编号
   END IF
   IF p_aeh17 IS NOT NULL THEN
      LET g_sql = g_sql CLIPPED," AND abb24 = '",p_aeh17,"'"      #币种
   END IF
  #No.FUN-D40044 ---Mark--- str
  #IF p_aeh31 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb31 = '",p_aeh31,"'"      #核算项5
  #END IF
  #IF p_aeh32 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb32 = '",p_aeh32,"'"      #核算项6
  #END IF
  #IF p_aeh33 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb33 = '",p_aeh33,"'"      #核算项7
  #END IF
  #IF p_aeh34 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb34 = '",p_aeh34,"'"      #核算项8
  #END IF
  #IF p_aeh35 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb35 = '",p_aeh35,"'"      #核算项9
  #END IF
  #IF p_aeh36 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb36 = '",p_aeh36,"'"      #核算项10
  #END IF
  #IF p_aeh37 IS NOT NULL THEN
  #   LET g_sql = g_sql CLIPPED," AND abb37 = '",p_aeh37,"'"      #核算项-关系人
  #END IF
  #No.FUN-D40044 ---Mark--- end
  #No.FUN-D40044 ---add--- str
   IF NOT cl_null(p_aeh04) THEN
      LET g_sql = g_sql CLIPPED," AND abb11 = '",p_aeh04,"'"      #核算项1
   END IF
   IF NOT cl_null(p_aeh05) THEN
      LET g_sql = g_sql CLIPPED," AND abb12 = '",p_aeh05,"'"      #核算项2
   END IF
   IF NOT cl_null(p_aeh06) THEN
      LET g_sql = g_sql CLIPPED," AND abb13 = '",p_aeh06,"'"      #核算项3
   END IF
   IF NOT cl_null(p_aeh07) THEN
      LET g_sql = g_sql CLIPPED," AND abb14 = '",p_aeh07,"'"      #核算项4
   END IF
   IF NOT cl_null(p_aeh31) THEN
      LET g_sql = g_sql CLIPPED," AND abb31 = '",p_aeh31,"'"      #核算项5
   END IF
   IF NOT cl_null(p_aeh32) THEN
      LET g_sql = g_sql CLIPPED," AND abb32 = '",p_aeh32,"'"      #核算项6
   END IF
   IF NOT cl_null(p_aeh33) THEN
      LET g_sql = g_sql CLIPPED," AND abb33 = '",p_aeh33,"'"      #核算项7
   END IF
   IF NOT cl_null(p_aeh34) THEN
      LET g_sql = g_sql CLIPPED," AND abb34 = '",p_aeh34,"'"      #核算项8
   END IF
   IF NOT cl_null(p_aeh35) THEN
      LET g_sql = g_sql CLIPPED," AND abb35 = '",p_aeh35,"'"      #核算项9
   END IF
   IF NOT cl_null(p_aeh36) THEN
      LET g_sql = g_sql CLIPPED," AND abb36 = '",p_aeh36,"'"      #核算项10
   END IF
   IF NOT cl_null(p_aeh37) THEN
      LET g_sql = g_sql CLIPPED," AND abb37 = '",p_aeh37,"'"      #核算项-关系人
   END IF
  #No.FUN-D40044 ---add--- end

   #借方金额
   LET g_sql1 = g_sql CLIPPED," AND abb06 = '1'"
   CALL cl_replace_sqldb(g_sql1) RETURNING g_sql1
   CALL cl_parse_qry_sql(g_sql1,p_plant) RETURNING g_sql1
   PREPARE abb_p1 FROM g_sql1
   EXECUTE abb_p1 INTO l_aeh11,l_aeh15
   IF SQLCA.sqlcode <> 0 AND SQLCA.sqlcode <> 100 THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','select debit amount',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3('sel','abb_file',p_aeh00,p_aeh01_1,SQLCA.sqlcode,'','select debit amount',1)
      END IF
      LET g_success = 'N'
      RETURN 0,0,0,0
   END IF
   IF cl_null(l_aeh11) THEN LET l_aeh11 = 0 END IF
   IF cl_null(l_aeh15) THEN LET l_aeh15 = 0 END IF
   

   #贷方金额
   LET g_sql1 = g_sql CLIPPED," AND abb06 = '2'"
   CALL cl_replace_sqldb(g_sql1) RETURNING g_sql1
   CALL cl_parse_qry_sql(g_sql1,p_plant) RETURNING g_sql1
   PREPARE abb_p2 FROM g_sql1
   EXECUTE abb_p2 INTO l_aeh12,l_aeh16
   IF SQLCA.sqlcode <> 0 AND SQLCA.sqlcode <> 100 THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','select credit amount',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3('sel','abb_file',p_aeh00,p_aeh01_1,SQLCA.sqlcode,'','select credit amount',1)
      END IF
      LET g_success = 'N'
      RETURN 0,0,0,0
   END IF
   IF cl_null(l_aeh12) THEN LET l_aeh12 = 0 END IF
   IF cl_null(l_aeh16) THEN LET l_aeh16 = 0 END IF

   RETURN l_aeh11,l_aeh12,l_aeh15,l_aeh16


END FUNCTION
