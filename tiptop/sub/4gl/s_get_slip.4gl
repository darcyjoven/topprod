# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_get_slip.4gl
# Descriptions...: 取单别
# Date & Author..: #No.FUN-CB0019 12/11/06 By Carrier
# Modify.........:

DATABASE ds

GLOBALS "../../config/top.global"    #No.FUN-CB0019

FUNCTION s_get_slip(p_sys,p_tabname,p_slip_field,p_type_field,p_acti_field,p_kind,p_where)
   DEFINE p_sys           LIKE zz_file.zz011
   DEFINE p_tabname       LIKE gat_file.gat01
   DEFINE p_slip_field    LIKE gaq_file.gaq01
   DEFINE p_type_field    LIKE gaq_file.gaq01
   DEFINE p_acti_field    LIKE gaq_file.gaq01
   DEFINE p_kind          LIKE apy_file.apykind
   DEFINE p_where         STRING
   DEFINE l_apyslip       LIKE apy_file.apyslip
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_sql           STRING
   DEFINE l_result        LIKE type_file.num5
   DEFINE l_gen03         LIKE gen_file.gen03
   DEFINE l_n             LIKE type_file.num5
   DEFINE r_apyslip       LIKE apy_file.apyslip

   WHENEVER ERROR CALL cl_err_msg_log

   IF cl_null(p_tabname) OR cl_null(p_slip_field) OR cl_null(p_type_field) OR cl_null(p_sys) THEN
      RETURN ''
   END IF

   LET l_sql = "SELECT ",p_slip_field CLIPPED,
               "  FROM ",p_tabname CLIPPED,
               " WHERE ",p_type_field CLIPPED," = '",p_kind CLIPPED,"'"
   IF NOT cl_null(p_where) THEN
      LET l_sql = l_sql CLIPPED," AND ",p_where CLIPPED
   END IF

   IF NOT cl_null(p_acti_field) THEN
      LET l_sql = l_sql CLIPPED," AND ",p_acti_field CLIPPED,"='Y'"
   END IF

   PREPARE s_get_slip_p1 FROM l_sql
   DECLARE s_get_slip_c1 CURSOR FOR s_get_slip_p1
   IF SQLCA.sqlcode THEN
      CALL cl_err('s_get_slip_c1',SQLCA.sqlcode,1)
      RETURN ''
   END IF

   SELECT zx03 INTO l_gen03 FROM zx_file where zx01=g_user   #抓此人所屬部門
   IF SQLCA.SQLCODE THEN
      LET l_gen03=NULL
   END IF

   LET l_cnt = 0
   FOREACH s_get_slip_c1 INTO l_apyslip
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach s_get_slip_c1',SQLCA.sqlcode,1)
         RETURN ''
      END IF

      #權限先check user再check部門
      SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=l_apyslip AND upper(smu03)=p_sys   #CHECK USER
      IF l_n>0 THEN                                                #USER權限存有資料,並g_user判斷是否存在
         SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=l_apyslip AND smu02=g_user AND upper(smu03)=p_sys
         IF l_n=0 THEN
            IF l_gen03 IS NULL THEN                               #g_user沒有部門
               CONTINUE FOREACH
            ELSE                                                  #CHECK g_user部門是否存在
               SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=l_apyslip AND smv02=l_gen03 AND upper(smv03)=p_sys
               IF l_n=0 THEN
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
      ELSE                                                          #CHECK Dept
         SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=l_apyslip AND upper(smv03)=p_sys
         IF l_n>0 THEN
            IF l_gen03 IS NULL THEN                                #g_user沒有部門
               CONTINUE FOREACH
            ELSE                                                   #CHECK g_user部門是否存在
               SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=l_apyslip AND smv02=l_gen03 AND upper(smv03)=p_sys
               IF l_n=0 THEN
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
      END IF
      LET l_cnt = l_cnt + 1
      LET r_apyslip = l_apyslip
   END FOREACH

   IF l_cnt = 1 THEN
      RETURN r_apyslip
   ELSE
      RETURN ''
   END IF

END FUNCTION

