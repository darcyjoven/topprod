# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_check_bookno.4gl
# Descriptions...: 檢查使用者有無權限使用此帳別
# Date & Author..: 06/05/08 by Sarah
# Modify.........: No.FUN-660140 06/06/26 By Sarah 帳別放大成5碼
# Modify.........: No.FUN-660204 06/06/30 By Sarah 增加第三個參數ps_plant(總帳營運中心編號)
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.TQC-6A0079 06/11/06 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-B60023 11/06/07 By yinhy 增加"部門設限"
 
DATABASE ds
 
GLOBALS "../../config/top.global"     #FUN-7C0053
 
DEFINE   g_aac          RECORD LIKE aac_file.*
DEFINE   g_fah          RECORD LIKE fah_file.*
DEFINE   g_forupd_sql   STRING
 
 
# Descriptions...: 帳別檢查
# Input Parameter: ps_bookno      帳別
#                  ps_user        使用者
#                  ps_plant       營運中心編號
# Return Code....: li_result      結果(TRUE/FALSE)
# Usage..........: CALL s_check_bookno("00",g_user) RETURNING li_result
 
FUNCTION s_check_bookno(ps_bookno,ps_user,ps_plant)
   DEFINE   ps_bookno       STRING
   DEFINE   ps_user         STRING
   DEFINE   ps_plant        STRING     #FUN-660204 add
   DEFINE   li_cnt          LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE   li_result       LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE   l_bookno        LIKE aba_file.aba00          #No.FUN-680147 VARCHAR(5)    #FUN-660140 VARCHAR(2)->CHAR(5)
   DEFINE   l_user          LIKE aay_file.aay02          #No.FUN-680147 VARCHAR(10)
   DEFINE   l_plant         LIKE type_file.chr10         #No.FUN-680147 VARCHAR(10)  #FUN-660204 add #No.TQC-6A0079
   DEFINE   l_dbs           LIKE type_file.chr21         #No.FUN-680147 VARCHAR(21)  #FUN-660204 add
   DEFINE   l_sql           STRING     #FUN-660204 add   
   DEFINE   lc_gen03        LIKE gen_file.gen03          #No.TQC-B60023  # 部門代號
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET li_result = TRUE
 
   IF cl_null(ps_bookno) THEN
      RETURN FALSE
   END IF
 
   LET g_errno = ""
 
   LET l_bookno = ps_bookno CLIPPED
   LET l_user = ps_user CLIPPED
   LET l_plant = ps_plant CLIPPED   #FUN-660204 add
 
  #start FUN-660204 add
   #抓取營運中心的DB
   LET g_plant_new = l_plant
   CALL s_getdbs()
   LET l_dbs = g_dbs_new 
  #end FUN-660204 add
   #No.TQC-B60023  --Begin # 抓取使用者所屬部門
   LET l_sql = "SELECT zx03 FROM ",cl_get_target_table(g_plant_new,"zx_file"),
                " WHERE zx01 = '",l_user CLIPPED,"'"    #抓此人所屬部門
   LET l_sql = cl_replace_sqldb(l_sql)
   PREPARE chkno_zx_pre FROM l_sql
   EXECUTE chkno_zx_pre INTO lc_gen03
   IF SQLCA.SQLCODE THEN
      LET lc_gen03 = NULL
   END IF
   #No.TQC-B60023  --End
   
   #檢查使用者有沒有使用帳別的權限
  #start FUN-660204 modify
  #SELECT COUNT(*) INTO li_cnt FROM aay_file WHERE aay01 = l_bookno
   #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs,"aay_file ",
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aay_file'), #FUN-A50102
               " WHERE aay01 = '",l_bookno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE chk_bkno_p1 FROM l_sql
   IF STATUS THEN
      CALL cl_err("pre sel_aay",STATUS,1)
   END IF
   DECLARE chk_bkno_c1 CURSOR FOR chk_bkno_p1
   IF STATUS THEN
      CALL cl_err("dec sel_aay",STATUS,1)
   END IF
   OPEN chk_bkno_c1
   FETCH chk_bkno_c1 INTO li_cnt
  #end FUN-660204 modify
   IF li_cnt > 0 THEN               #USER權限存有資料,並g_user判斷是否存在
     #start FUN-660204 modify
     #SELECT COUNT(*) INTO li_cnt FROM aay_file 
     # WHERE aay01 = l_bookno AND aay02 = l_user
      #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs,"aay_file ",
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aay_file'), #FUN-A50102
                  " WHERE aay01 = '",l_bookno,"' AND aay02 = '",l_user,"'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE chk_bkno_p2 FROM l_sql
      IF STATUS THEN
         CALL cl_err("pre2 sel_aay",STATUS,1)
      END IF
      DECLARE chk_bkno_c2 CURSOR FOR chk_bkno_p2
      IF STATUS THEN
         CALL cl_err("dec2 sel_aay",STATUS,1)
      END IF
      OPEN chk_bkno_c2
      FETCH chk_bkno_c2 INTO li_cnt
     #end FUN-660204 modify
      IF li_cnt = 0 THEN
         LET g_errno = "agl-100"
      #No.TQC-B60023  --Begin #檢查部門有沒有使用帳別的權限
      ELSE      	 
        # 需做部門控管, Check User部門是否有此單別使用權限
        LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aax_file'), #FUN-A50102
                    " WHERE aax01 = '",l_bookno,"' AND aax02 = '",lc_gen03,"'"
        LET l_sql = cl_replace_sqldb(l_sql)
        PREPARE chk_bkno_c3 FROM l_sql
        EXECUTE chk_bkno_c3 INTO li_cnt
        IF li_cnt = 0 THEN
           LET g_errno = "agl-100" 
        END IF 
      END IF   
    ELSE
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aax_file'),
                  " WHERE aax01 = '",l_bookno,"'"
      LET l_sql = cl_replace_sqldb(l_sql)
      PREPARE chk_bkno_c4 FROM l_sql
      EXECUTE chk_bkno_c4 INTO li_cnt
      IF li_cnt > 0 THEN
         # 需做部門控管, Check User部門是否有此單別使用權限
         IF lc_gen03 IS NULL THEN   #g_user沒有部門
             LET g_errno = "agl-100" 
         ELSE
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aax_file'), #FUN-A50102
                        " WHERE aax01 = '",l_bookno,"' AND aax02 = '",lc_gen03,"'"
            LET l_sql = cl_replace_sqldb(l_sql)
            PREPARE chk_bkno_c5 FROM l_sql
            EXECUTE chk_bkno_c5 INTO li_cnt
            IF li_cnt = 0 THEN
               LET g_errno = "agl-100" 
            END IF
         END IF
      END IF
      #No.TQC-B60023  --End
   END IF
      
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(l_bookno CLIPPED,g_errno,1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
 
END FUNCTION
