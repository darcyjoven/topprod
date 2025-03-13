# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_chknpq3.4gl
# Descriptions...: 檢查分錄底稿
# Date & Author..: 
# Usage..........: CALL s_chknpq3(p_no,p_sys,p_npq011,p_npptype,p_plant)
# Input Parameter: p_no      單號
#                  p_sys     系統別:AP/AR/NM/FA
#                  p_npq011  序號
#                  p_npptype 分錄底稿類別
#                  p_plant   營運中心
# Return code....: none
# Modify.........: No.FUN-4C0031 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify ........: No.FUN-560060 05/06/15 By wujie 單據編號加大返工 
# Modify.........: No.FUN-560126 05/06/27 By Nicola 錯誤訊息修改
# Modify.........: No.FUN-530061 05/09/27 By Sarah 錯誤訊息前面應該要show出單號
# Modify.........: No.MOD-5B0328 05/12/06 By Smapmin 檢核是否須產生分錄
# Modify.........: No.TQC-630176 06/03/21 By Smapmin 預算卡關加入是否作部門管理的控管
# Modify.........: No.TQC-630215 06/03/21 By Smapmin 加強錯誤訊息顯示
# Modify.........: No.FUN-620051 06/04/03 By Mandy add if 判斷,npq011 = '9'時代表的是集團資金調撥所傳入,不需要重抓 nmydmy3,直接讓l_dmy3 = 'Y'
# Modify.........: No.FUN-640178 06/05/04 By Nicola 錯誤訊息改call cl_showarray()
# Modify.........: No.FUN-640246 06/05/10 By Echo 自動執行確認功能
# Modify.........: No.FUN-670047 06/08/15 By Rayven 新增使用多帳套功能
# Modify.........: No.FUN-680147 06/09/10 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690090 06/11/17 By Rayven 所有的select改成跨庫
# Modify.........: No.FUN-6C0083 07/01/12 By Nicola 錯誤訊息彙整
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.TQC-790164 07/10/05 By Smapmin SQL語法錯誤
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810069 08/03/04 By lynn s_getbug()新增參數 部門編號afb041,專案代碼afb042
# Modify.........: No.FUN-830139 08/04/11 By douzh s_getbug1()合并后的重新調整
# Modify.........: No.FUN-830161 08/04/15 By Carrier 項目預算修改
# modify.........: No.MOD-920001 09/02/01 By chnel 調整預算和項目的判斷條件，若未勾選項目核算，則在預算判斷時，不需要判斷npq08和npq35
# modify.........: No.MOD-960194 09/06/18 By Dido 資料庫轉換有誤
# modify.........: No.MOD-970292 09/08/03 By Dido 變數定義與增加跨主機語法
# modify.........: No.TQC-980276 09/09/02 By Dido MOD-960194 還原
# modify.........: No.MOD-980276 09/09/02 By Dido 錯誤訊息中增加站別代號
# Modify.........: No.CHI-9A0012 09/10/15 By sabrina 增加第5~11組異動碼管理
# Modify.........: No.TQC-A10144 10/01/21 By Dido 錯誤訊息營運中心調整
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:MOD-A90001 10/09/01 By Carrier aap-401/aap-402的错误,判断时考虑"单向分录"
# Modify.........: No:MOD-B30595 11/03/18 By Sarah 修正FUN-830161,預算超限檢查時,科目做不做部門管理時SQL條件寫顛倒了
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3處理的地方加npptype判斷
# Modify.........: No:MOD-CB0152 12/11/20 By Polly 修正重覆計算已耗用金額問題
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
GLOBALS
   DEFINE g_aaz72        LIKE aaz_file.aaz72
   DEFINE g_apz02p       LIKE apz_file.apz02p
   DEFINE g_ooz02p       LIKE ooz_file.ooz02p
   DEFINE g_nmz02p       LIKE nmz_file.nmz02p
   DEFINE g_faa02p       LIKE faa_file.faa02p
   DEFINE g_bookno       LIKE apz_file.apz02b
   DEFINE g_dbs_gl       LIKE type_file.chr21         #No.FUN-680147 VARCHAR(21)
   DEFINE g_dbs1         LIKE type_file.chr21         #No.FUN-690090
   DEFINE g_sql          STRING                       #No.FUN-690090
   #-----No.FUN-640178-----
  # Prog. Version..: '5.30.06-13.03.12(01)   #No.FUN-6C0083
   DEFINE g_show_msg     DYNAMIC ARRAY OF RECORD
                            azp02    LIKE azp_file.azp02,
                            npqsys   LIKE npq_file.npqsys,
                            npq01    LIKE npq_file.npq01,
                            npq03    LIKE npq_file.npq03,
                            ze01     LIKE ze_file.ze01,
                            ze03     LIKE ze_file.ze03
                         END RECORD
   DEFINE l_msg          STRING
   DEFINE l_msg2         STRING
   DEFINE lc_gaq03       LIKE gaq_file.gaq03
   DEFINE lc_no          LIKE npq_file.npq01         #No.FUN-680147 VARCHAR(20)
   DEFINE lc_sys         LIKE npq_file.npqsys        #No.FUN-680147 VARCHAR(02)
   #-----No.FUN-640178 END-----
END GLOBALS
 
FUNCTION s_chknpq3(p_no,p_sys,p_npq011,p_npptype,p_plant,p_bookno) # 檢查分錄底稿正確否  #No.FUN-670047 新增p_npptype #No.FUN-690090 add p_plant  #No.FUN-730020
   DEFINE p_no        LIKE npq_file.npq01     #No.FUN-680147 VARCHAR(20)   # 單號
   DEFINE p_sys       LIKE npq_file.npqsys    # Prog. Version..: '5.30.06-13.03.12(02)   # 系統別:AP/AR/NM/FA
   DEFINE p_npq011    LIKE npq_file.npq011    # 序號
   DEFINE p_bookno    LIKE aag_file.aag00     #No.FUN-730020
   DEFINE amtd,amtc   LIKE npq_file.npq07     # FUN-4C0031
   DEFINE l_t1        LIKE apy_file.apyslip        # Prog. Version..: '5.30.06-13.03.12(02)  #No.FUN560060
   DEFINE l_dmy3      LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_sql       LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
   DEFINE n1,n2       LIKE type_file.num5,         #No.FUN-680147 SMALLINT
          l_cnt       LIKE type_file.num5,         #No.FUN-680147 SMALLINT
          l_buf       LIKE ze_file.ze03,           #No.FUN-680147 VARCHAR(40)
          l_buf1      LIKE ze_file.ze03,           #No.FUN-680147 VARCHAR(40)
          l_flag      LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE g_azn02     LIKE azn_file.azn02
   DEFINE g_azn04     LIKE azn_file.azn04
   DEFINE l_afb04     LIKE afb_file.afb04
   DEFINE l_afb07     LIKE afb_file.afb07
   DEFINE l_afb15     LIKE afb_file.afb15
   DEFINE l_afb041    LIKE afb_file.afb041         #FUN-810069
   DEFINE l_afb042    LIKE afb_file.afb042         #FUN-810069
   DEFINE l_amt       LIKE npq_file.npq07
   DEFINE l_tol       LIKE npq_file.npq07
   DEFINE l_tol1      LIKE npq_file.npq07
   DEFINE total_t     LIKE npq_file.npq07
   DEFINE l_dept      LIKE gem_file.gem01
   DEFINE l_npp       RECORD LIKE npp_file.*
   DEFINE l_npq       RECORD LIKE npq_file.*
   DEFINE l_aag       RECORD LIKE aag_file.*
   DEFINE l_errmsg    LIKE type_file.chr1000 #No.FUN-680147 VARCHAR(1000)   #FUN-530061
   DEFINE l_count     LIKE type_file.num5    #No.FUN-680147 SMALLINT    #MOD-5B0328
   DEFINE l_aag05     LIKE aag_file.aag05    #TQC-630176
   DEFINE l_str       STRING                 #FUN-640246
   DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-670047
   DEFINE p_plant     LIKE type_file.chr21   #MOD-970292 modify azp_file.azp01
  #DEFINE l_plant     STRING		     #MOD-960194	#TQC-980276 mark
   DEFINE g_pmc903      LIKE pmc_file.pmc903    #CHI-9A0012
   DEFINE l_pmc903      LIKE pmc_file.pmc903    #CHI-9A0012
   DEFINE g_occ37       LIKE occ_file.occ37     #CHI-9A0012
 
   LET g_success = 'Y'
 
   #-----No.FUN-640178-----
   CALL g_show_msg.clear()
   LET g_totsuccess = g_success
   LET lc_sys = p_sys
   LET lc_no = p_no
   #-----No.FUN-640178 END-----
 
   #No.FUN-560060--begin
#  LET l_t1 = p_no[1,3]
   LET l_t1 = p_no[1,g_doc_len]
   #No.FUN-560060--end   
 
   #No.FUN-690090 --start--
  #-TQC-980276-remark-
  #-MOD-960194-add-
  #LET l_plant = p_plant
  #LET l_count = l_plant.getlength() - 1
  #LET g_plant_new = l_plant.substring(1,l_count)
   LET g_plant_new = p_plant
   CALL s_getdbs()
  #LET g_dbs_new=s_dbstring(g_plant_new CLIPPED)
  #-MOD-960194-end
  #-TQC-980276-end-
   LET g_dbs1 = g_dbs_new
   #No.FUN-690090 --end--
 
   CASE
      WHEN p_sys = 'AP'
         #No.FUN-690090 --start--
#        SELECT apydmy3 INTO l_dmy3 FROM apy_file WHERE apyslip = l_t1
         #LET g_sql = "SELECT apydmy3 FROM ",g_dbs1,"apy_file",
         LET g_sql = "SELECT apydmy3 FROM ",cl_get_target_table(p_plant,'apy_file'), #FUN-A50102
                     " WHERE apyslip = '",l_t1,"'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE apydmy3_p1 FROM g_sql
         DECLARE apydmy3_c1 CURSOR FOR apydmy3_p1
         OPEN apydmy3_c1
         FETCH apydmy3_c1 INTO l_dmy3
#        IF SQLCA.sqlcode THEN 
         IF l_dmy3 IS NULL THEN
         #No.FUN-690090 --end--
           #-----No.FUN-640178-----
           #CALL cl_err('sel apy:',SQLCA.SQLCODE,1) 
           #LET g_success = 'N'
           #RETURN 
            LET g_totsuccess = "N"
           #CALL s_chknpq3_err(g_plant,SQLCA.SQLCODE,'')   #TQC-A10144 mark
            CALL s_chknpq3_err(p_plant,SQLCA.SQLCODE,'')   #TQC-A10144
           #-----No.FUN-640178 END-----
         END IF
         #No.FUN-690090 --start--
#        SELECT apz02p,apz02b INTO g_apz02p,g_bookno 
#          FROM apz_file WHERE apz00 = '0'
         #LET g_sql = "SELECT apz02p,apz02b FROM ",g_dbs1,"apz_file",
         LET g_sql = "SELECT apz02p,apz02b FROM ",cl_get_target_table(p_plant,'apz_file'), #FUN-A50102
                     " WHERE apz00 = '0'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE apz02p_p1 FROM g_sql
         DECLARE apz02p_c1 CURSOR FOR apz02p_p1
         OPEN apz02p_c1
         FETCH apz02p_c1 INTO g_apz02p,g_bookno
         #No.FUN-690090 --end--
         LET g_plant_new = g_apz02p
         CALL s_getdbs()
         LET g_dbs_gl = g_dbs_new 
      WHEN p_sys = 'AR'
         #No.FUN-690090 --start--
#        SELECT ooydmy1 INTO l_dmy3 FROM ooy_file WHERE ooyslip = l_t1
         #LET g_sql = "SELECT ooydmy1 FROM ",g_dbs1,"ooy_file",
         LET g_sql = "SELECT ooydmy1 FROM ",cl_get_target_table(p_plant,'ooy_file'), #FUN-A50102
                     " WHERE ooyslip = '",l_t1,"'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE ooydmy1_p1 FROM g_sql
         DECLARE ooydmy1_c1 CURSOR FOR ooydmy1_p1
         OPEN ooydmy1_c1
         FETCH ooydmy1_c1 INTO l_dmy3
#        IF SQLCA.sqlcode THEN 
         IF l_dmy3 IS NULL THEN
         #No.FUN-690090 --end--
           #-----No.FUN-640178-----
           #CALL cl_err('sel ooy:',SQLCA.SQLCODE,1) 
           #LET g_success = 'N' RETURN 
            LET g_totsuccess = "N"
           #CALL s_chknpq3_err(g_plant,SQLCA.SQLCODE,'')   #TQC-A10144 mark
            CALL s_chknpq3_err(p_plant,SQLCA.SQLCODE,'')   #TQC-A10144
           #-----No.FUN-640178 END-----
         END IF
         IF p_npptype = '0' THEN  #No.FUN-670047
            #No.FUN-690090 --start--
#           SELECT ooz02p,ooz02b INTO g_ooz02p,g_bookno
#             FROM ooz_file WHERE ooz00 = '0'
            #LET g_sql = "SELECT ooz02p,ooz02b FROM ",g_dbs1,"ooz_file",
            LET g_sql = "SELECT ooz02p,ooz02b FROM ",cl_get_target_table(p_plant,'ooz_file'), #FUN-A50102
                        " WHERE ooz00 = '0'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE ooz02p_p1 FROM g_sql
            DECLARE ooz02p_c1 CURSOR FOR ooz02p_p1
            OPEN ooz02p_c1
            FETCH ooz02p_c1 INTO g_ooz02p,g_bookno
            #No.FUN-690090 --end--
         #No.FUN-670047 --start--
         ELSE
            #No.FUN-690090 --start--
#           SELECT ooz02p,ooz02c INTO g_ooz02p,g_bookno 
#             FROM ooz_file WHERE ooz00 = '0'
            #LET g_sql = "SELECT ooz02p,ooz02c FROM ",g_dbs1,"ooz_file",
            LET g_sql = "SELECT ooz02p,ooz02c FROM ",cl_get_target_table(p_plant,'ooz_file'), #FUN-A50102
                        " WHERE ooz00 = '0'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE ooz02p_p2 FROM g_sql
            DECLARE ooz02p_c2 CURSOR FOR ooz02p_p2
            OPEN ooz02p_c2
            FETCH ooz02p_c2 INTO g_ooz02p,g_bookno
            #No.FUN-690090 --end--
         END IF
         #No.FUN-670047 --end--
         LET g_plant_new = g_ooz02p
         CALL s_getdbs()
         LET g_dbs_gl = g_dbs_new 
      WHEN p_sys = 'NM'
         IF p_npq011 = '9' THEN #FUN-620051 add if 判斷,npq011 = '9'時代表的是集團資金調撥所傳入,不需要重抓 nmydmy3,直接讓l_dmy3 = 'Y'
            LET l_dmy3 = 'Y'
         ELSE
            #No.FUN-690090 --start--
#           SELECT nmydmy3 INTO l_dmy3 FROM nmy_file WHERE nmyslip = l_t1
            #LET g_sql = "SELECT nmydmy3 FROM ",g_dbs1,"nmy_file",
            LET g_sql = "SELECT nmydmy3 FROM ",cl_get_target_table(p_plant,'nmy_file'), #FUN-A50102
                        " WHERE nmyslip = '",l_t1,"'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE nmydmy3_p1 FROM g_sql
            DECLARE nmydmy3_c1 CURSOR FOR nmydmy3_p1
            OPEN nmydmy3_c1
            FETCH nmydmy3_c1 INTO l_dmy3
#           IF SQLCA.sqlcode THEN 
            IF l_dmy3 IS NULL THEN
            #No.FUN-690090 --end--
              #-----No.FUN-640178-----
              #CALL cl_err('sel nmy:',SQLCA.SQLCODE,1) 
              #LET g_success = 'N' RETURN 
               LET g_totsuccess = "N"
              #CALL s_chknpq3_err(g_plant,SQLCA.SQLCODE,'')   #TQC-A10144 mark
               CALL s_chknpq3_err(p_plant,SQLCA.SQLCODE,'')   #TQC-A10144
              #-----No.FUN-640178 END-----
            END IF
         END IF
         #No.FUN-690090 --start--
#        SELECT nmz02p,nmz02b INTO g_nmz02p,g_bookno
#          FROM nmz_file WHERE nmz00 = '0'
         #LET g_sql = "SELECT nmz02p,nmz02b FROM ",g_dbs1,"nmz_file",
         LET g_sql = "SELECT nmz02p,nmz02b FROM ",cl_get_target_table(p_plant,'nmz_file'), #FUN-A50102
                     " WHERE nmz00 = '0'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE nmz02p_p1 FROM g_sql
         DECLARE nmz02p_c1 CURSOR FOR nmz02p_p1
         OPEN nmz02p_c1
         FETCH nmz02p_c1 INTO g_nmz02p,g_bookno
         #No.FUN-690090 --end--
         LET g_plant_new = g_nmz02p
         CALL s_getdbs()
         LET g_dbs_gl = g_dbs_new 
      WHEN p_sys = 'FA'
         #No.FUN-690090 --start--
#        SELECT fahdmy3 INTO l_dmy3 FROM fah_file WHERE fahslip = l_t1
         #LET g_sql = "SELECT fahdmy3 FROM ",g_dbs1,"fah_file",
#FUN-C30313---mark---START
#        LET g_sql = "SELECT fahdmy3 FROM ",cl_get_target_table(p_plant,'fah_file'), #FUN-A50102
#                    " WHERE fahslip = '",l_t1,"'"
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
         IF p_npptype = '0' THEN
            LET g_sql = "SELECT fahdmy3 FROM ",cl_get_target_table(p_plant,'fah_file'), #FUN-A50102
                        " WHERE fahslip = '",l_t1,"'"
         ELSE
            LET g_sql = "SELECT fahdmy32 FROM ",cl_get_target_table(p_plant,'fah_file'), #FUN-A50102
                        " WHERE fahslip = '",l_t1,"'"
         END IF
#FUN-C30313---add---END-------
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE fahdmy3_p1 FROM g_sql
         DECLARE fahdmy3_c1 CURSOR FOR fahdmy3_p1
         OPEN fahdmy3_c1
         FETCH fahdmy3_c1 INTO l_dmy3
#        IF SQLCA.sqlcode THEN 
         IF l_dmy3 IS NULL THEN
         #No.FUN-690090 --end--
           #-----No.FUN-640178-----
           #CALL cl_err('sel fah:',SQLCA.SQLCODE,1) 
           #LET g_success = 'N' RETURN 
            LET g_totsuccess = "N"
           #CALL s_chknpq3_err(g_plant,SQLCA.SQLCODE,'')   #TQC-A10144 mark
            CALL s_chknpq3_err(p_plant,SQLCA.SQLCODE,'')   #TQC-A10144
           #-----No.FUN-640178 END-----
         END IF
         #No.FUN-690090 --start--
#        SELECT faa02p,faa02b INTO g_faa02p,g_bookno
#          FROM faa_file WHERE faa00 = '0'
         #LET g_sql = "SELECT faa02p,faa02b FROM ",g_dbs1,"faa_file",
         LET g_sql = "SELECT faa02p,faa02b FROM ",cl_get_target_table(p_plant,'faa_file'), #FUN-A50102
                     " WHERE faa00 = '0'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE faa02p_p1 FROM g_sql
         DECLARE faa02p_c1 CURSOR FOR faa02p_p1
         OPEN faa02p_c1
         FETCH faa02p_c1 INTO g_faa02p,g_bookno
         #No.FUN-690090 --end--
         LET g_plant_new = g_faa02p
         CALL s_getdbs()
         LET g_dbs_gl = g_dbs_new 
   END CASE
 
   #-->取總帳系統參數
   #LET l_sql = "SELECT aaz72 FROM ",g_dbs_gl CLIPPED,
   #             "aaz_file WHERE aaz00 = '0' "
   LET l_sql = "SELECT aaz72 FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE chk_pregl FROM l_sql
   DECLARE chk_curgl CURSOR FOR chk_pregl
 
   OPEN chk_curgl 
   FETCH chk_curgl INTO g_aaz72 
   IF SQLCA.sqlcode THEN 
      LET g_aaz72 = '1' 
   END IF
 
   #MOD-5B0328
   LET l_count = 0
   #No.FUN-690090 --start--
#  SELECT COUNT(*) INTO l_count FROM npq_file
#   WHERE npq01 = p_no
#     AND npqsys = p_sys
#     AND npq011 = p_npq011
#     AND npqtype = p_npptype  #No.FUN-670047
   #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs1,"npq_file",
   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
               " WHERE npq01 = '",p_no,"'",
               "   AND npqsys = '",p_sys,"'",
               "   AND npq011 = '",p_npq011,"'",
               "   AND npqtype = '",p_npptype,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE npq_p1 FROM g_sql
   DECLARE npq_c1 CURSOR FOR npq_p1
   OPEN npq_c1
   FETCH npq_c1 INTO l_count
   #No.FUN-690090 --end--
   IF l_dmy3 = 'Y' THEN
      IF l_count = 0 THEN
        #-----No.FUN-640178-----
        #CALL cl_err(l_errmsg,'aap-995',1)
        #LET g_success = 'N'
        #RETURN
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-995','')   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-995','')   #TQC-A10144
        #-----No.FUN-640178 END-----
      END IF
   ELSE
      IF l_count > 0 THEN
        #-----No.FUN-640178-----
        #CALL cl_err(p_no,'mfg9310',1)
        #LET g_success = 'N'
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'mfg9310','')   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'mfg9310','')   #TQC-A10144
        #-----No.FUN-640178 END-----
      END IF
      RETURN
   END IF
   #END MOD-5B0328
 
   #No.FUN-690090 --start--
#  SELECT sum(npq07) INTO amtd FROM npq_file 
#   WHERE npq01 = p_no
#     AND npq06 = '1' #--->借方合計
#     AND npqsys = p_sys 
#     AND npq011 = p_npq011
#     AND npqtype = p_npptype  #No.FUN-670047
   #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file",
   #No.MOD-A90001  --Begin
   #LET g_sql = "SELECT SUM(npq07) FROM ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
   #            " WHERE npq01 = '",p_no,"'",
   #            "   AND npq06 = '1'",
   #            "   AND npqsys = '",p_sys,"'",
   #            "   AND npq011 = '",p_npq011,"'",
   #            "   AND npqtype = '",p_npptype,"'"
   LET g_sql = "SELECT SUM(ABS(npq07)) FROM ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
               " WHERE npq01 = '",p_no,"'",
               "   AND npqsys = '",p_sys,"'",
               "   AND npq011 = '",p_npq011,"'",
               "   AND npqtype = '",p_npptype,"'",
               "   AND (npq06 = '1' AND npq07 > 0 OR npq06 = '2' AND npq07 < 0) "
   #No.MOD-A90001  --End  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE npq_p2 FROM g_sql
   DECLARE npq_c2 CURSOR FOR npq_p2
   OPEN npq_c2
   FETCH npq_c2 INTO amtd
   #No.FUN-690090 --end--
   IF cl_null(amtd) THEN 
     #CALL cl_err('sel sum(npq07)','aap-995',1)   #No.FUN-560126   #FUN-530061 mark
     #-----No.FUN-640178-----
     #LET l_errmsg = p_no , ' sel sum(npq07)'                      #FUN-530061
#    #CALL cl_err(l_errmsg,'aap-995',1)                            #FUN-530061   #MOD-5B0328
     #CALL cl_err(l_errmsg,'aap-401',1)                            #FUN-530061    #MOD-5B0328
     #LET g_success = 'N'
     #RETURN
      LET g_totsuccess = "N"
     #CALL s_chknpq3_err(g_plant,'aap-401','')   #TQC-A10144 mark
      CALL s_chknpq3_err(p_plant,'aap-401','')   #TQC-A10144
     #-----No.FUN-640178 END-----
   END IF
 
   #No.FUN-690090 --start--
#  SELECT sum(npq07) INTO amtc FROM npq_file 
#   WHERE npq01 = p_no
#     AND npq06 = '2' #--->貸方合計
#     AND npqsys = p_sys 
#     AND npq011 = p_npq011
#     AND npqtype = p_npptype  #No.FUN-670047
   #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file",
   #No.MOD-A90001 --Begin
   #LET g_sql = "SELECT SUM(npq07) FROM ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
   #            " WHERE npq01 = '",p_no,"'",
   #            "   AND npq06 = '2'",
   #            "   AND npqsys = '",p_sys,"'",
   #            "   AND npq011 = '",p_npq011,"'",
   #            "   AND npqtype = '",p_npptype,"'"
   LET g_sql = "SELECT SUM(ABS(npq07)) FROM ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
               " WHERE npq01 = '",p_no,"'",
               "   AND npqsys = '",p_sys,"'",
               "   AND npq011 = '",p_npq011,"'",
               "   AND npqtype = '",p_npptype,"'",
               "   AND (npq06 = '2' AND npq07 > 0 OR npq06 = '1' AND npq07 < 0) "
   #No.MOD-A90001 --End  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE npq_p3 FROM g_sql
   DECLARE npq_c3 CURSOR FOR npq_p3
   OPEN npq_c3
   FETCH npq_c3 INTO amtc
   #No.FUN-690090 --end--
   IF cl_null(amtc) THEN 
     #CALL cl_err('sel sum(npq07)','aap-995',1)   #No.FUN-560126   #FUN-530061 mark
     #-----No.FUN-640178-----
     #LET l_errmsg = p_no , ' sel sum(npq07)'                      #FUN-530061
#    #CALL cl_err(l_errmsg,'aap-995',1)                            #FUN-530061   #MOD-5B0328
     #CALL cl_err(l_errmsg,'aap-402',1)                            #FUN-530061    #MOD-5B0328
     #LET g_success = 'N'
      LET g_totsuccess = "N"
     #CALL s_chknpq3_err(g_plant,'aap-402','')   #TQC-A10144 mark
      CALL s_chknpq3_err(p_plant,'aap-402','')   #TQC-A10144
     #-----No.FUN-640178 END-----
   END IF
 
#MOD-5B0328
#  #-->單別不產生分錄, 不可有分錄
#  IF l_dmy3 = 'N' THEN
#     IF (amtd >0 OR amtc > 0) THEN
#        CALL cl_err(p_no,'mfg9310',1)
#        LET g_success = 'N'
#     END IF
#     RETURN
#  END IF
#END MOD-5B0328
 
   #-->必須要有分錄
   IF (amtd = 0 OR amtc = 0) THEN
     #-----No.FUN-640178-----
     #CALL cl_err(p_no,'aap-261',1)
     #LET g_success = 'N'
      LET g_totsuccess = "N"
     #CALL s_chknpq3_err(g_plant,'aap-261','')   #TQC-A10144 mark
      CALL s_chknpq3_err(p_plant,'aap-261','')   #TQC-A10144
     #-----No.FUN-640178 END-----
   END IF
 
   #-->借貸要平
   IF amtd != amtc THEN
     #-----No.FUN-640178-----
     #CALL cl_err(p_no,'aap-058',1)
     #LET g_success = 'N'
      LET g_totsuccess = "N"
     #CALL s_chknpq3_err(g_plant,'aap-058','')   #TQC-A10144 mark
      CALL s_chknpq3_err(p_plant,'aap-058','')   #TQC-A10144
     #-----No.FUN-640178 END-----
   END IF
 
   #-->科目要對
   #No.FUN-690090 --start--
#  SELECT COUNT(*) INTO n1 FROM npq_file
#   WHERE npq01 = p_no
#     AND npqsys = p_sys
#     AND npq011 = p_npq011
#     AND npqtype = p_npptype  #No.FUN-670047
   #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs1,"npq_file",
   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
               " WHERE npq01 = '",p_no,"'",
               "   AND npqsys = '",p_sys,"'",
               "   AND npq011 = '",p_npq011,"'",
               "   AND npqtype = '",p_npptype,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE npq_p4 FROM g_sql
   DECLARE npq_c4 CURSOR FOR npq_p4
   OPEN npq_c4
   FETCH npq_c4 INTO n1
   #No.FUN-690090 --end--
 
   #No.FUN-690090 --start--
#  SELECT COUNT(*) INTO n2 FROM npq_file,aag_file
#   WHERE npq01 = p_no
#     AND npqsys = p_sys
#     AND npq011 = p_npq011
#     AND npq03 = aag01
#     AND npqtype = p_npptype  #No.FUN-670047
#     AND aag03 = '2'
##    AND aag07 MATCHES '[23]' #No.FUN-670047 mark
#     AND aag07 IN ('2','3')   #No.FUN-670047
   #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs1,"npq_file,",g_dbs1,"aag_file",
   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'npq_file'),",", #FUN-A50102
                                       cl_get_target_table(p_plant,'aag_file'),     #FUN-A50102
               " WHERE npq01 = '",p_no,"'",
               "   AND npqsys = '",p_sys,"'",
               "   AND npq011 = '",p_npq011,"'",
               "   AND npq03 = aag01",
               "   AND npqtype = '",p_npptype,"'",
               "   AND aag03 = '2'",
               "   AND aag00 = '",p_bookno,"'",   #No.FUN-730020
               "   AND aag07 IN ('2','3') "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE npq_p5 FROM g_sql
   DECLARE npq_c5 CURSOR FOR npq_p5
   OPEN npq_c5
   FETCH npq_c5 INTO n2
   #No.FUN-690090 --end--
 
   IF n1<>n2 THEN
     #-----No.FUN-640178-----
     #CALL cl_err(p_no,'aap-262',1)
     #LET g_success = 'N'
      LET g_totsuccess = "N"
     #CALL s_chknpq3_err(g_plant,'aap-262','')   #TQC-A10144 mark
      CALL s_chknpq3_err(p_plant,'aap-262','')   #TQC-A10144
     #-----No.FUN-640178 END-----
   END IF
 
## No:2406 modify 1998/08/26 ----------------------------
   #No.FUN-690090 --start--
#  DECLARE npq_cur CURSOR FOR
#   SELECT npq_file.*,aag_file.*
#     FROM npq_file,OUTER aag_file 
#    WHERE npq01 = p_no 
#      AND npqsys = p_sys 
#      AND npq011 = p_npq011
#      AND npqtype = p_npptype  #No.FUN-670047
#      AND npq03=aag01
   #No.FUN-830161  --Begin add npp_file
   LET g_sql = "SELECT npp_file.*,npq_file.*,aag_file.* FROM ",
               # g_dbs1,"npp_file,",g_dbs1,"npq_file LEFT OUTER JOIN ",g_dbs1,"aag_file ON npq_file.npq03 = aag_file.aag01 AND aag_file.aag00 = '",p_bookno,"'",
                       cl_get_target_table(p_plant,'npp_file'),",",                     #FUN-A50102
                       cl_get_target_table(p_plant,'npq_file')," LEFT OUTER JOIN ",     #FUN-A50102                
                       cl_get_target_table(p_plant,'aag_file'),                         #FUN-A50102
               "    ON npq_file.npq03 = aag_file.aag01 AND aag_file.aag00 = '",p_bookno,"'",#FUN-A50102
               " WHERE npq01 = '",p_no,"'",
               "   AND npqsys = '",p_sys,"'",
               "   AND npq011 = '",p_npq011,"'",
               "   AND npqtype = '",p_npptype,"'",
               "   AND npp01 = npq01 AND npp011 = npq011 ",
               "   AND nppsys = npqsys AND npp00 = npq00 ",
               "   AND npptype = npqtype ",
               " "  #No.FUN-730020
   #No.FUN-830161  --End  
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#MOD-970292
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE npq_pre FROM g_sql
   DECLARE npq_cur CURSOR FOR npq_pre
   #No.FUN-690090 --end--
   IF STATUS THEN
     #-----No.FUN-640178-----
     #CALL cl_err('decl cursor',STATUS,1)
     #LET g_success = 'N'
     #RETURN
      LET g_totsuccess = "N"
     #CALL s_chknpq3_err(g_plant,STATUS,'')   #TQC-A10144 mark
      CALL s_chknpq3_err(p_plant,STATUS,'')   #TQC-A10144
     #-----No.FUN-640178 END-----
   END IF
   
   FOREACH npq_cur INTO l_npp.*,l_npq.*,l_aag.*  #No.FUN-830161  add npp
 
      ## ( 若科目有部門管理者,應check部門欄位 )
      IF l_aag.aag05='Y' THEN  #部門明細管理
         IF cl_null(l_npq.npq05) THEN 
           #-----No.FUN-640178-----
           #LET g_success = 'N'
           #CALL cl_err(l_npq.npq03,'aap-287',1)
            LET g_totsuccess = "N"
           #CALL s_chknpq3_err(g_plant,'aap-287',l_npq.npq03)   #TQC-A10144 mark
            CALL s_chknpq3_err(p_plant,'aap-287',l_npq.npq03)   #TQC-A10144
           #-----No.FUN-640178 END-----
         END IF
 
         ##NO:4897部門Check
         #No.FUN-690090 --start--
#        SELECT gem01 FROM gem_file
#         WHERE gem01 = l_npq.npq05
#           AND gemacti = 'Y' 
         #LET g_sql = "SELECT gem01 FROM ",g_dbs1,"gem_file",
         LET g_sql = "SELECT gem01 FROM ",cl_get_target_table(p_plant,'gem_file'), #FUN-A50102
                     " WHERE gem01 = '",l_npq.npq05,"'",
                     "   AND gemacti = 'Y'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE gem_p1 FROM g_sql
         DECLARE gem_c1 CURSOR FOR gem_p1
         #No.FUN-690090 --end--
         IF STATUS THEN
           #-----No.FUN-640178-----
          # LET g_success = 'N'
          ##CALL cl_err(l_npq.npq05,'aap-039',1)   #TQC-630215
          # CALL cl_err(l_npq.npq03,'aap-039',1)   #TQC-630215
            LET g_totsuccess = "N"
           #CALL s_chknpq3_err(g_plant,'aap-039',l_npq.npq03)   #TQC-A10144 mark
            CALL s_chknpq3_err(p_plant,'aap-039',l_npq.npq03)   #TQC-A10144
           #-----No.FUN-640178 END-----
         END IF
 
         ##No.2874 modify 1998/12/01 若有部門管理應Check其部門是否為拒絕部門
         IF g_aaz72 = '2' THEN 
            #No.FUN-690090 --start--
#           SELECT COUNT(*) INTO l_cnt FROM aab_file 
#            WHERE aab01 = l_npq.npq03   #科目
#              AND aab02 = l_npq.npq05   #部門
            #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs1,"aab_file",
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'aab_file'), #FUN-A50102
                        " WHERE aab01 = '",l_npq.npq03,"'",   #TQC-790164
                        "   AND aab02 = '",l_npq.npq05,"'",
                        "   AND aab00 = '",p_bookno,"'"      #No.FUN-730020
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE aab_p1 FROM g_sql
            DECLARE aab_c1 CURSOR FOR aab_p1
            OPEN aab_c1
            FETCH aab_c1 INTO l_cnt
            #No.FUN-690090 --end--
            IF l_cnt = 0 THEN
              #-----No.FUN-640178-----
              #LET g_success = 'N'
              #CALL cl_err(l_npq.npq03,'agl-209',1)
               LET g_totsuccess = "N"
              #CALL s_chknpq3_err(g_plant,'agl-209',l_npq.npq03)   #TQC-A10144 mark
               CALL s_chknpq3_err(p_plant,'agl-209',l_npq.npq03)   #TQC-A10144
              #-----No.FUN-640178 END-----
            END IF
         ELSE 
            #No.FUN-690090 --start--
#           SELECT COUNT(*) INTO l_cnt FROM aab_file 
#            WHERE aab01 = l_npq.npq03   #科目
#              AND aab02 = l_npq.npq05   #部門
            #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs1,"aab_file",
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'aab_file'), #FUN-A50102
                        " WHERE aab01 = '",l_npq.npq03,"'",
                        "   AND aab02 = '",l_npq.npq05,"'",
                        "   AND aab00 = '",p_bookno,"'"      #No.FUN-730020
 	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE aab_p2 FROM g_sql
            DECLARE aab_c2 CURSOR FOR aab_p2
            OPEN aab_c2
            FETCH aab_c2 INTO l_cnt
            #No.FUN-690090 --end--
            IF l_cnt > 0 THEN
              #-----No.FUN-640178-----
              #LET g_success = 'N'
              #CALL cl_err(l_npq.npq03,'agl-207',1)
               LET g_totsuccess = "N"
              #CALL s_chknpq3_err(g_plant,'agl-207',l_npq.npq03)   #TQC-A10144 mark
               CALL s_chknpq3_err(p_plant,'agl-207',l_npq.npq03)   #TQC-A10144
              #-----No.FUN-640178 END-----
            END IF
         END IF 
      #No.B203 010409 by plum add 針對不做部門管理,其部門應為空白
      ELSE 
         IF NOT cl_null(l_npq.npq05) THEN
           #-----No.FUN-640178-----
           #LET g_success = 'N'
           #CALL cl_err(l_npq.npq03,'agl-216',1)
            LET g_totsuccess = "N"
           #CALL s_chknpq3_err(g_plant,'agl-216',l_npq.npq03)   #TQC-A10144 mark 
            CALL s_chknpq3_err(p_plant,'agl-216',l_npq.npq03)   #TQC-A10144
           #-----No.FUN-640178 END-----
         END IF 
     #No.B203..end
      END IF
      #-----------------------------------------------------------------
 
      #若科目須做預算控制，預算編號不可空白(modi in 99/12/14 NO:0911)
      IF l_aag.aag21 = 'Y' THEN
         #No.FUN-830161  --Begin
         IF p_bookno IS NULL OR l_npq.npq36 IS NULL OR                          
            l_npq.npq03 IS NULL OR YEAR(l_npp.npp02) IS NULL OR                 
           #No.MOD-920001--begin-- modify
           #l_npq.npq35 IS NULL OR l_npq.npq05 IS NULL OR                       
           #l_npq.npq08 IS NULL OR MONTH(l_npp.npp02) IS NULL THEN              
            l_npq.npq05 IS NULL OR MONTH(l_npp.npp02) IS NULL THEN              
           #No.MOD-920001---end--- modify
            LET g_totsuccess = "N"                                              
           #CALL s_chknpq3_err(g_plant,'agl-215',l_npq.npq03)   #TQC-A10144 mark
            CALL s_chknpq3_err(p_plant,'agl-215',l_npq.npq03)   #TQC-A10144
#           #IF cl_null(l_npq.npq15) THEN     #No.FUN-830139
            #  #-----No.FUN-640178-----
            # # LET g_success = 'N'
            # ##CALL cl_err('','agl-215',1)   #TQC-630215
            # # CALL cl_err(l_npq.npq03,'agl-215',1)   #TQC-630215
            #   LET g_totsuccess = "N"
            #   CALL s_chknpq3_err(g_plant,'agl-215',l_npq.npq03)
            #  #-----No.FUN-640178 END-----
#           #ELSE                              #No.FUN-830139
         ELSE
         #No.FUN-830161  --End
            #no.6354 考慮是否預算超限
            #No.FUN-690090 --start--
#           SELECT * INTO l_npp.* FROM npp_file WHERE npp01 = p_no
#                                                 AND npptype = p_npptype  #No.FUN-670047
            #No.FUN-830161  --Begin
            #LET g_sql = "SELECT * FROM ",g_dbs1,"npp_file",
            #            " WHERE npp01 = '",p_no,"'",
            #            "   AND npptype = '",p_npptype,"'"
            #PREPARE npp_p1 FROM g_sql
            #DECLARE npp_c1 CURSOR FOR npp_p1
            #OPEN npp_c1
            #FETCH npp_c1 INTO l_npp.*
            #No.FUN-830161  --End  
            #No.FUN-690090 --end--
 
            #No.FUN-670047 --start--                                                                                                         
            IF g_aza.aza63 = 'Y' THEN                                                                                                        
               #No.FUN-830161  --Begin azn->aznn_file
               #LET l_sql = "SELECT azn02,azn04 FROM ",g_dbs_gl CLIPPED,                                                                      
               #            "azn_file WHERE azn01 = '",l_npp.npp02,"'",                                                                       
               #            "           AND azn00 = '",g_bookno,"'"                                                                            
               #LET l_sql = "SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,                                                                      
               #            "azn_file WHERE aznn01 = '",l_npp.npp02,"'",
               LET l_sql = "SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'), #FUN-A50102                                                                      
                           " WHERE aznn01 = '",l_npp.npp02,"'",                 
                           "           AND aznn00 = '",g_bookno,"'"                                                                            
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
               PREPARE azn_p1 FROM l_sql                                                                                                     
               DECLARE azn_c1 CURSOR FOR azn_p1                                                                                              
               OPEN azn_c1                                                                                                                   
               FETCH azn_c1 INTO g_azn02,g_azn04                                                                                             
               IF SQLCA.sqlcode THEN
                 #CALL s_chknpq3_err(g_plant,'mfg3078','')   #TQC-A10144 mark
                  CALL s_chknpq3_err(p_plant,'mfg3078','')   #TQC-A10144
               END IF
               #No.FUN-830161  --End  
            ELSE                                                                                                                             
            #No.FUN-670047 --end--
               #No.FUN-690090 --start--
#              SELECT azn02,azn04 INTO g_azn02,g_azn04  FROM azn_file
#               WHERE azn01 = l_npp.npp02  
               #LET g_sql = "SELECT azn02,azn04 FROM ",g_dbs1 CLIPPED,
               #            "azn_file WHERE azn01 = '",l_npp.npp02,"'"
               LET g_sql = "SELECT azn02,azn04 FROM ",cl_get_target_table(p_plant,'azn_file'), #FUN-A50102
                           " WHERE azn01 = '",l_npp.npp02,"'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
               PREPARE azn_p2 FROM g_sql
               DECLARE azn_c2 CURSOR FOR azn_p2
               OPEN azn_c2
               FETCH azn_c2 INTO g_azn02,g_azn04
               #No.FUN-690090 --end--
            END IF  #No.FUN-670047      
 
            IF cl_null(l_npq.npq05) THEN 
               LET l_dept = '@'
            ELSE
               LET l_dept = l_npq.npq05
            END IF
 
            #No.FUN-690090 --start--
#           SELECT afb04,afb15 INTO l_afb04,l_afb15
#             FROM afb_file
#            WHERE afb00 = g_bookno
#              AND afb01 = l_npq.npq15
#              AND afb02 = l_npq.npq03
#              AND afb03 = g_azn02
#              AND afb04 = l_dept
#            LET g_sql = "SELECT afb04,afb15 FROM ",g_dbs1,"afb_file",                 #FUN-810069
            #No.FUN-830161  --Begin
            #LET g_sql = "SELECT afb04,afb15,afb041,afb042 FROM ",g_dbs1,"afb_file",    #FUN-810069
            #            " WHERE afb00 = '",g_bookno,"'",
#           #            "   AND afb01 = '",l_npq.npq15,"'",      #No.FUN-830139
            #            "   AND afb01 = '",l_npq.npq36,"'",      #No.FUN-830139
            #            "   AND afb02 = '",l_npq.npq03,"'",
            #            "   AND afb03 = '",g_azn02,"'",
            #            "   AND afb041= '",l_npq.npq05,"' ",     #FUN-810069
            #            "   AND afb042= '",l_npq.npq08,"' ",     #FUN-810069
            #            "   AND afb04 = '",l_dept,"'"
            #LET g_sql = "SELECT afb04,afb15,afb041,afb042 FROM ",g_dbs1,"afb_file",    #FUN-810069
            LET g_sql = "SELECT afb04,afb15,afb041,afb042 FROM ",cl_get_target_table(p_plant,'afb_file'), #FUN-A50102
                        " WHERE afb00 = '",p_bookno,"'",
                        "   AND afb01 = '",l_npq.npq36,"'",      #No.FUN-830139
                        "   AND afb02 = '",l_npq.npq03,"'",
                        "   AND afb03 = '",g_azn02,"'",
                        "   AND afb04 = '",l_npq.npq35,"'",
                        "   AND afb041= '",l_npq.npq05,"' ",     #FUN-810069
                        "   AND afb042= '",l_npq.npq08,"' "      #FUN-810069
                       ,"   AND afbacti = 'Y' "                  #FUN-D70090 add
            #No.FUN-830161  --End  
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE afb_p1 FROM g_sql
            DECLARE afb_c1 CURSOR FOR afb_p1
            OPEN afb_c1
#            FETCH afb_c1 INTO l_afb04,l_afb15                    #FUN-810069
            FETCH afb_c1 INTO l_afb04,l_afb15,l_afb041,l_afb042   #FUN-810069
#           IF SQLCA.sqlcode THEN 
            IF l_afb04 IS NULL AND l_afb15 IS NULL THEN
            #No.FUN-690090 --end--
              #-----No.FUN-640178-----
              #CALL cl_err(l_npq.npq15,'agl-139',1)
              #CALL s_chknpq3_err(g_plant,'agl-139','')   #TQC-A10144 mark
               CALL s_chknpq3_err(p_plant,'agl-139','')   #TQC-A10144
              #-----No.FUN-640178 END-----
            END IF
 
#No.FUN-830139--begin
#           CALL s_getbug(g_bookno,l_npq.npq15,l_npq.npq03,
#                          g_azn02,g_azn04,l_afb04,l_afb15)           #FUN-810069 
#                         g_azn02,g_azn04,l_afb04,l_afb15,l_afb041,l_afb042)    #FUN-810069
            CALL s_getbug1(p_bookno,l_npq.npq36,l_npq.npq03,
                          g_azn02,l_npq.npq35,l_npq.npq05,
                          l_npq.npq08,g_azn04,l_npq.npqtype)   
#No.FUN-830139--begin
                RETURNING l_flag,l_afb07,l_amt
 
            IF l_flag THEN   #若不成功
              #-----No.FUN-640178-----
              #CALL cl_err('','agl-139',1)
              #CALL s_chknpq3_err(g_plant,'agl-139','')   #TQC-A10144 mark
               CALL s_chknpq3_err(p_plant,'agl-139','')   #TQC-A10144
              #-----No.FUN-640178 END-----
            END IF
 
            IF l_afb07 != '1' THEN #要做超限控制
               #-----TQC-630176---------
               #No.FUN-690090 --start--
#              SELECT aag05 INTO l_aag05 FROM aag_file
#               WHERE aag01 = l_npq.npq03
               #LET g_sql = "SELECT aag05 FROM ",g_dbs1,"aag_file",
               LET g_sql = "SELECT aag05 FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
                           " WHERE aag01 = '",l_npq.npq03,"'",
                           "   AND aag00 = '",p_bookno,"'"  #No.FUN-730020
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
               PREPARE aag_p1 FROM g_sql
               DECLARE aag_c1 CURSOR FOR aag_p1
               OPEN aag_c1
               FETCH aag_c1 INTO l_aag05
               #No.FUN-690090 --end--
               IF l_aag05 = 'Y' THEN
                  #No.FUN-690090 --start--
#                 SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
#                  WHERE npq01 = npp01
#                    AND npq03 = l_npq.npq03
#                    AND npq15 = l_npq.npq15 AND npq06 = '1' #借方
#                    AND npq05 = l_npq.npq05
#                    AND npqtype = p_npptype  #No.FUN-670047
#                    AND YEAR(npp02) = g_azn02
#                    AND MONTH(npp02) = g_azn04
                  #No.FUN-830161  --Begin
                  #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file,",g_dbs1,"npp_file",
                  #            " WHERE npq01 = npp01",
                  #            "   AND npq03 = '",l_npq.npq03,"'",
#                 #            "   AND npq15 = '",l_npq.npq15,"'",        #No.FUN-830139
                  #            "   AND npq36 = '",l_npq.npq36,"'",        #No.FUN-830139
                  #            "   AND npq06 = '1'",
                  #            "   AND npq05 = '",l_npq.npq05,"'",
                  #            "   AND npqtype = '",p_npptype,"'",
                  #            "   AND YEAR(npp02) = '",g_azn02,"'",
                  #            "   AND MONTH(npp02) = '",g_azn04,"'"
                  #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file,",g_dbs1,"npp_file",
                  LET g_sql = "SELECT SUM(npq07) FROM ",cl_get_target_table(p_plant,'npq_file'),",", #FUN-A50102
                                                        cl_get_target_table(p_plant,'npp_file'),     #FUN-A50102
                              " WHERE npq01 = npp01",
                              "   AND npp011 = npq011 ",
                              "   AND nppsys = npqsys ",
                              "   AND npp00 = npq00 ",
                              "   AND npptype = npqtype ",
                              "   AND npq36 = '",l_npq.npq36,"'",        #No.FUN-830139
                              "   AND npq03 = '",l_npq.npq03,"'",
                              "   AND YEAR(npp02) = ",g_azn02,
                              "   AND npq35 = '",l_npq.npq35,"'",        #No.FUN-830139
                              "   AND npq05 = '",l_npq.npq05,"'",        #MOD-B30595 mark還原
                              "   AND npq08 = '",l_npq.npq08,"'",
                              "   AND MONTH(npp02) = ",g_azn04,
                              "   AND npq06 = '1'",
                              "   AND npqtype = '",p_npptype,"'"
                  #No.FUN-830161  --End  
 	              CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
                  PREPARE npq_p6 FROM g_sql
                  DECLARE npq_c6 CURSOR FOR npq_p6
                  OPEN npq_c6
                  FETCH npq_c6 INTO l_tol
                  #No.FUN-690090 --end--
                  IF SQLCA.sqlcode OR l_tol IS NULL THEN
                     LET l_tol = 0
                  END IF
                  #No.FUN-690090 --start--
#                 SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
#                  WHERE npq01 = npp01
#                    AND npq03 = l_npq.npq03
#                    AND npq15 = l_npq.npq15 AND npq06 = '2' #貸方
#                    AND npq05 = l_npq.npq05
#                    AND npqtype = p_npptype  #No.FUN-670047
#                    AND YEAR(npp02) = g_azn02
#                    AND MONTH(npp02) = g_azn04
                  #No.FUN-830161  --Begin
                  #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file,",g_dbs1,"npp_file",
                  #            " WHERE npq01 = npp01",
                  #            "   AND npq03 = '",l_npq.npq03,"'",
#                 #            "   AND npq15 = '",l_npq.npq15,"'",        #No.FUN-830139
                  #            "   AND npq36 = '",l_npq.npq36,"'",        #No.FUN-830139 
                  #            "   AND npq06 = '2'",
                  #            "   AND npq05 = '",l_npq.npq05,"'",
                  #            "   AND npqtype = '",p_npptype,"'",
                  #            "   AND YEAR(npp02) = '",g_azn02,"'",
                  #            "   AND MONTH(npp02) = '",g_azn04,"'"
                  #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file,",g_dbs1,"npp_file",
                  LET g_sql = "SELECT SUM(npq07) FROM ",cl_get_target_table(p_plant,'npq_file'),",", #FUN-A50102
                                                        cl_get_target_table(p_plant,'npp_file'),  
                              " WHERE npq01 = npp01",
                              "   AND npp011 = npq011 ",
                              "   AND nppsys = npqsys ",
                              "   AND npp00 = npq00 ",
                              "   AND npptype = npqtype ",
                              "   AND npq36 = '",l_npq.npq36,"'",        #No.FUN-830139
                              "   AND npq03 = '",l_npq.npq03,"'",
                              "   AND YEAR(npp02) = ",g_azn02,
                              "   AND npq35 = '",l_npq.npq35,"'",        #No.FUN-830139
                              "   AND npq05 = '",l_npq.npq05,"'",        #MOD-B30595 mark還原
                              "   AND npq08 = '",l_npq.npq08,"'",
                              "   AND MONTH(npp02) = ",g_azn04,
                              "   AND npq06 = '2'",
                              "   AND npqtype = '",p_npptype,"'"
                  #No.FUN-830161  --End  
 	              CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
                  PREPARE npq_p7 FROM g_sql
                  DECLARE npq_c7 CURSOR FOR npq_p7
                  OPEN npq_c7
                  FETCH npq_c7 INTO l_tol1
                  #No.FUN-690090 --end--
                  IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
                     LET l_tol1 = 0
                  END IF
               ELSE
               #-----END TQC-630176-----
                  #No.FUN-690090 --start--
#                 SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
#                  WHERE npq01 = npp01
#                    AND npq03 = l_npq.npq03 
#                    AND npq15 = l_npq.npq15 AND npq06 = '1' #借方
#                    AND npqtype = p_npptype  #No.FUN-670047
#                    AND YEAR(npp02) = g_azn02
#                    AND MONTH(npp02) = g_azn04
                  #No.FUN-830161  --Begin
                  #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file,",g_dbs1,"npp_file",
                  #            " WHERE npq01 = npp01",
                  #            "   AND npq03 = '",l_npq.npq03,"'",
#                 #            "   AND npq15 = '",l_npq.npq15,"'",          #No.FUN-830139
                  #            "   AND npq15 = '",l_npq.npq15,"'",          #No.FUN-830139
                  #            "   AND npq06 = '1'",
                  #            "   AND npqtype = '",p_npptype,"'",
                  #            "   AND YEAR(npp02) = '",g_azn02,"'",
                  #            "   AND MONTH(npp02) = '",g_azn04,"'"
                  #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file,",g_dbs1,"npp_file",
                  LET g_sql = "SELECT SUM(npq07) FROM ",cl_get_target_table(p_plant,'npq_file'),",", #FUN-A50102
                                                        cl_get_target_table(p_plant,'npp_file'), 
                              " WHERE npq01 = npp01",
                              "   AND npp011 = npq011 ",
                              "   AND nppsys = npqsys ",
                              "   AND npp00 = npq00 ",
                              "   AND npptype = npqtype ",
                              "   AND npq36 = '",l_npq.npq36,"'",        #No.FUN-830139
                              "   AND npq03 = '",l_npq.npq03,"'",
                              "   AND YEAR(npp02) = ",g_azn02,
                              "   AND npq35 = '",l_npq.npq35,"'",        #No.FUN-830139
                             #"   AND npq05 = '",l_npq.npq05,"'",        #MOD-B30595 mark
                              "   AND npq08 = '",l_npq.npq08,"'",
                              "   AND MONTH(npp02) = ",g_azn04,
                              "   AND npq06 = '1'",
                              "   AND npqtype = '",p_npptype,"'"
                  #No.FUN-830161  --End  
 	              CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
                  PREPARE npq_p8 FROM g_sql
                  DECLARE npq_c8 CURSOR FOR npq_p8
                  OPEN npq_c8
                  FETCH npq_c8 INTO l_tol
                  #No.FUN-690090 --end--
                  IF SQLCA.sqlcode OR l_tol IS NULL THEN 
                     LET l_tol = 0 
                  END IF
                  #No.FUN-690090 --start--
#                 SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
#                  WHERE npq01 = npp01
#                    AND npq03 = l_npq.npq03 
#                    AND npq15 = l_npq.npq15 AND npq06 = '2' #貸方
#                    AND npqtype = p_npptype  #No.FUN-670047
#                    AND YEAR(npp02) = g_azn02
#                    AND MONTH(npp02) = g_azn04
                  #No.FUN-830161  --Begin
                  #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file,",g_dbs1,"npp_file",
                  #            " WHERE npq01 = npp01",
                  #            "   AND npq03 = '",l_npq.npq03,"'",
                  #            "   AND npq36 = '",l_npq.npq36,"'",          #No.FUN-830139
#                 #            "   AND npq15 = '",l_npq.npq15,"'",          #No.FUN-830139
                  #            "   AND npq06 = '2'",
                  #            "   AND npqtype = '",p_npptype,"'",
                  #            "   AND YEAR(npp02) = '",g_azn02,"'",
                  #            "   AND MONTH(npp02) = '",g_azn04,"'"
                  #LET g_sql = "SELECT SUM(npq07) FROM ",g_dbs1,"npq_file,",g_dbs1,"npp_file",
                  LET g_sql = "SELECT SUM(npq07) FROM ",cl_get_target_table(p_plant,'npq_file'),",", #FUN-A50102
                                                        cl_get_target_table(p_plant,'npp_file'), 
                              " WHERE npq01 = npp01",
                              "   AND npp011 = npq011 ",
                              "   AND nppsys = npqsys ",
                              "   AND npp00 = npq00 ",
                              "   AND npptype = npqtype ",
                              "   AND npq36 = '",l_npq.npq36,"'",        #No.FUN-830139
                              "   AND npq03 = '",l_npq.npq03,"'",
                              "   AND YEAR(npp02) = ",g_azn02,
                              "   AND npq35 = '",l_npq.npq35,"'",        #No.FUN-830139
                             #"   AND npq05 = '",l_npq.npq05,"'",        #MOD-B30595 mark
                              "   AND npq08 = '",l_npq.npq08,"'",
                              "   AND MONTH(npp02) = ",g_azn04,
                              "   AND npq06 = '2'",
                              "   AND npqtype = '",p_npptype,"'"
                  #No.FUN-830161  --End  
 	              CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                  CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
                  PREPARE npq_p9 FROM g_sql
                  DECLARE npq_c9 CURSOR FOR npq_p9
                  OPEN npq_c9
                  FETCH npq_c9 INTO l_tol1
                  #No.FUN-690090 --end--
                  IF SQLCA.sqlcode OR l_tol1 IS NULL THEN 
                     LET l_tol1 = 0 
                  END IF
               END IF   #TQC-630176
 
               IF l_aag.aag06 = '1' THEN #借餘 
                  LET total_t = l_tol - l_tol1   #借減貸
               ELSE #貸餘
                  LET total_t = l_tol1 - l_tol   #貸減借
               END IF
        
               LET l_amt = l_amt + l_npq.npq07            #MOD-CB0152 add
              #IF total_t > l_amt THEN #借餘大於預算金額  #MOD-CB0152 mark
               IF l_npq.npq07 > l_amt THEN                #MOD-CB0152 add
                  CASE l_afb07
                     WHEN '2'
                        CALL cl_getmsg('agl-140',0) RETURNING l_buf
                        CALL cl_getmsg('agl-141',0) RETURNING l_buf1
                       #FUN-640246
                       #ERROR l_npq.npq03 CLIPPED,' ',
                       #      l_buf CLIPPED,' ',total_t,
                       #      l_buf1 CLIPPED,' ',l_amt
                        LET l_str = l_npq.npq03 CLIPPED,' ',
                                    l_buf CLIPPED,' ',total_t,
                                    l_buf1 CLIPPED,' ',l_amt
                        CALL cl_msg(l_str)
                        #No.FUN-830161  --Begin
                        CALL s_chknpq3_err(l_str,'agl-233','')
                        #No.FUN-830161  --End  
                     WHEN '3'
                        CALL cl_getmsg('agl-142',0) RETURNING l_buf
                        CALL cl_getmsg('agl-143',0) RETURNING l_buf
                       #ERROR l_npq.npq03 CLIPPED,' ',
                       #      l_buf CLIPPED,' ',total_t,
                       #      l_buf1 CLIPPED,' ',l_amt
                        LET l_str = l_npq.npq03 CLIPPED,' ',
                                    l_buf CLIPPED,' ',total_t,
                                    l_buf1 CLIPPED,' ',l_amt
                        CALL cl_msg(l_str)
                        #No.FUN-830161  --Begin
                        CALL s_chknpq3_err(l_str,'agl-233','')
                        #No.FUN-830161  --End  
                       #FUN-640246
                        LET g_totsuccess = 'N'  #No.FUN-830161
                  END CASE
               END IF
            END IF
            #no.6354(end)
         END IF                                #No.FUN-830139
      END IF
 
      #若科目須做專案管理，專案編號不可空白(modi in 01/09/14 no.3565)
      IF l_aag.aag23 = 'Y' THEN
        #IF cl_null(l_npq.npq08) THEN                         #No.MOD-920001 mark  
         IF cl_null(l_npq.npq08) OR l_npq.npq35 IS NULL THEN  #No.MOD-920001  
           #-----No.FUN-640178-----
           #LET g_success = 'N'
           #CALL cl_err(l_npq.npq03,'agl-922',1)
            LET g_totsuccess = "N"
           #CALL s_chknpq3_err(g_plant,'agl-922',l_npq.npq03)   #TQC-A10144 mark
            CALL s_chknpq3_err(p_plant,'agl-922',l_npq.npq03)   #TQC-A10144
           #-----No.FUN-640178 END-----
         ELSE
            #No.FUN-690090 --start--
#           SELECT * FROM gja_file WHERE gja01 = l_npq.npq08 AND gjaacti = 'Y'
            #LET g_sql = "SELECT * FROM ",g_dbs1,"gja_file,",
            LET g_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'gja_file'), #FUN-A50102
                        " WHERE gja01 = '",l_npq.npq08,"'",
                        "   AND gjaacti = 'Y'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
            PREPARE gja_p1 FROM g_sql
            DECLARE gja_c1 CURSOR FOR gja_p1
            #No.FUN-690090 --end--
            IF STATUS = 100 THEN
              #-----No.FUN-640178-----
              #LET g_success = 'N'
              #CALL cl_err(l_npq.npq03,'apj-005',1)
               LET g_totsuccess = "N"
              #CALL s_chknpq3_err(g_plant,'apj-005',l_npq.npq03)   #TQC-A10144 mark
               CALL s_chknpq3_err(p_plant,'apj-005',l_npq.npq03)   #TQC-A10144
              #-----No.FUN-640178 END-----
            END IF
         END IF
      END IF
   
 
      ## ( 若科目有異動碼管理者,應check異動碼欄位 )
      IF (l_aag.aag151 = '2' OR     #異動碼-1控制方式 
         l_aag.aag151 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq11)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
        #-----No.FUN-640178-----
        #LET g_success = 'N'
        #CALL cl_err(l_npq.npq03,'aap-288',1)
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
        #-----No.FUN-640178 END-----
      END IF
 
      IF (l_aag.aag161 = '2' OR     #異動碼-1控制方式 
         l_aag.aag161 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq12)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
        #-----No.FUN-640178-----
        #LET g_success = 'N'
        #CALL cl_err(l_npq.npq03,'aap-288',1)
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
        #-----No.FUN-640178 END-----
      END IF
 
      IF (l_aag.aag171 = '2' OR     #異動碼-1控制方式 
         l_aag.aag171 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq13)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
        #-----No.FUN-640178-----
        #LET g_success = 'N'
        #CALL cl_err(l_npq.npq03,'aap-288',1)
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
        #-----No.FUN-640178 END-----
      END IF
 
      IF (l_aag.aag181 = '2' OR     #異動碼-1控制方式 
         l_aag.aag181 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq14)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
        #-----No.FUN-640178-----
        #LET g_success = 'N'
        #CALL cl_err(l_npq.npq03,'aap-288',1)
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
        #-----No.FUN-640178 END-----
      END IF
    #CHI-9A0012---add---start---
      IF (l_aag.aag311 = '2' OR     #異動碼-1控制方式 
         l_aag.aag311 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq31)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
      END IF
      IF (l_aag.aag321 = '2' OR     #異動碼-1控制方式 
         l_aag.aag321 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq32)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
      END IF
      IF (l_aag.aag331 = '2' OR     #異動碼-1控制方式 
         l_aag.aag331 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq33)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
      END IF
      IF (l_aag.aag341 = '2' OR     #異動碼-1控制方式 
         l_aag.aag341 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq34)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
      END IF
      IF (l_aag.aag351 = '2' OR     #異動碼-1控制方式 
         l_aag.aag351 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq35)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
      END IF
      IF (l_aag.aag361 = '2' OR     #異動碼-1控制方式 
         l_aag.aag361 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq36)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_totsuccess = "N"
        #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)   #TQC-A10144 mark
         CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
      END IF
      IF p_sys  = 'AP' THEN 
          SELECT pmc903 INTO g_pmc903 FROM pmc_file,apa_file
           WHERE pmc01 = apa05
             AND apa44 = l_npq.npq01
          LET l_pmc903 = g_pmc903
      END IF  
      IF p_sys = 'AR' THEN  
          SELECT occ37 INTO g_occ37 FROM occ_file,oma_file
            WHERE occ01 =oma03
              AND oma33 = l_npq.npq01
          LET l_pmc903 = g_occ37
      END IF        
      IF (l_aag.aag371 = '2' OR                                #異動碼-1控制方式 
         l_aag.aag371 = '3') 
         OR (l_aag.aag371 = '4' AND l_pmc903 = 'Y') THEN       #   1:可輸入,  可空白   
         IF cl_null(l_npq.npq37) THEN                          #   2.必須輸入,不需檢查   
            LET g_totsuccess = "N"                             #   3.必須輸入, 必須檢查
           #CALL s_chknpq3_err(g_plant,'aap-288',l_npq.npq03)  #   4.必須輸入，必須檢查，非關係人時需空白  #TQC-A10144 mark
            CALL s_chknpq3_err(p_plant,'aap-288',l_npq.npq03)   #TQC-A10144
         END IF
      END IF
    #CHI-9A0012---add---end---
   END FOREACH
   # ------------------------------------------------------
 
   #-----No.FUN-640178-----
   IF g_totsuccess = "N" THEN
      LET g_success = "N"
      IF g_show_msg.getlength() > 0 THEN
         CALL cl_get_feldname("azp02",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("npqsys",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("npq01",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("npq03",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03
         LET l_msg2 = l_msg2.trim(),"|",lc_gaq03 CLIPPED
 
         CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
         CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
      END IF
   END IF
   #-----No.FUN-640178 END-----
 
END FUNCTION
 
#-----No.FUN-640178-----
FUNCTION s_chknpq3_err(lc_azp01,lc_ze01,lc_npq03)
   DEFINE ls_showmsg    STRING
   DEFINE lc_azp01      LIKE azp_file.azp01
   DEFINE lc_azp02      LIKE azp_file.azp02
   DEFINE lc_npq03      LIKE npq_file.npq03
   DEFINE lc_ze01       LIKE ze_file.ze01
   DEFINE li_newerrno   LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE ls_tmpstr     STRING
  
   #No.FUN-690090 --start--
#  SELECT azp02 INTO lc_azp02 FROM azp_file
#   WHERE azp01 = lc_azp01
   #LET g_sql = "SELECT azp02 FROM ",g_dbs1,"azp_file",
   LET g_sql = "SELECT azp02 FROM ",cl_get_target_table(lc_azp01,'azp_file'), #FUN-A50102
               " WHERE azp01 = '",lc_azp01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,lc_azp01) RETURNING g_sql #FUN-A50102
   PREPARE azp_p1 FROM g_sql
   DECLARE azp_c1 CURSOR FOR azp_p1
   OPEN azp_c1
   FETCH azp_c1 INTO lc_azp02
   #No.FUN-690090 --end--
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].azp02 = lc_azp02
   LET g_show_msg[li_newerrno].npqsys = lc_sys
   LET g_show_msg[li_newerrno].npq01 = lc_no
   LET g_show_msg[li_newerrno].npq03 = lc_npq03
   LET g_show_msg[li_newerrno].ze01 = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
  #LET g_show_msg[li_newerrno].ze03 = ls_showmsg.trim(),ls_tmpstr.trim()		#MOD-980276 mark
   LET g_show_msg[li_newerrno].ze03 = lc_azp01,ls_showmsg.trim(),ls_tmpstr.trim()	#MOD-980276
  
END FUNCTION
#-----No.FUN-640178 END-----
 
