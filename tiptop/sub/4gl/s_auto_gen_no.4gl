# Prog. Version..: '5.30.06-13.03.12(00003)'#
#
# Program name...: s_auto_gen_no.4gl
# Descriptions...: 自動編號
# Date & Author..: 09/09/28 by Zhangyajun
# Input Parameter: ps_sys      系統別
#                  ps_slip     單號
#                  ps_date     日期
#                  ps_tab      需要自動編號的表
#                  ps_fld      需要自動編號的字段
#                  ps_plant    機構別
# Return Code....: li_result   結果(TRUE/FALSE)
#                  ls_no       單據編號
# Usage..........: CALL s_auto_gen_no("art","615",g_today,"rwb_file","rwb04",g_plant)
# Memo...........: 參考s_auto_assign_no
# Modify.........: No.TQC-9B0023 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-A80044 10/08/06 By Hiko 宣告變數不參考zld_file
 
DATABASE ds   
 
GLOBALS "../../config/top.global" 
 
DEFINE gc_slip LIKE smy_file.smyslip
DEFINE gs_tab  STRING
DEFINE gs_fld  STRING
DEFINE gs_dbs  LIKE type_file.chr21
DEFINE gi_year  LIKE azn_file.azn02 # 年度
DEFINE gi_month LIKE azn_file.azn04 # 期別
DEFINE gi_week  LIKE azn_file.azn05 # 週別
DEFINE gi_day   LIKE type_file.num5
 
FUNCTION s_auto_gen_no(ps_sys,ps_slip,ps_date,ps_tab,ps_fld,ps_plant)
DEFINE ps_sys  LIKE smu_file.smu03
DEFINE ps_slip STRING
DEFINE ps_date LIKE type_file.dat
DEFINE ps_tab  STRING
DEFINE ps_fld  STRING
DEFINE ps_plant LIKE azp_file.azp01
DEFINE ls_sql   STRING
DEFINE lc_progname  LIKE gaz_file.gaz03
DEFINE ls_lock_tab  STRING
DEFINE lc_method    LIKE type_file.chr1
#DEFINE lc_max_no    LIKE zld_file.zld19
#DEFINE lc_next_no   LIKE zld_file.zld19
DEFINE lc_max_no    LIKE type_file.chr50 #FUN-A80044
DEFINE lc_next_no   LIKE type_file.chr50 #FUN-A80044
DEFINE li_pos LIKE type_file.num5
 
   IF cl_null(ps_date) THEN
      LET ps_date = g_today
   END IF
   IF cl_null(ps_plant) THEN
      LET ps_plant = g_plant
   END IF
   SELECT azp03 INTO gs_dbs FROM azp_file WHERE azp01=ps_plant
   LET gs_dbs = s_dbstring(gs_dbs)
   LET ps_sys = UPSHIFT(ps_sys)
   LET gs_tab = ps_tab
   LET gs_fld = ps_fld
   LET ps_slip = ps_slip.trim()
   LET li_pos = ps_slip.getIndexOf('-',1)
   IF li_pos>0 THEN
      LET gc_slip = ps_slip.substring(1,li_pos-1)
   ELSE
      LET gc_slip = ps_slip
   END IF
   LET gi_day = DAY(ps_date)
   SELECT azn02,azn04,azn05 INTO gi_year,gi_month,gi_week
     FROM azn_file
    WHERE azn01 = ps_date
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','',"sub-142",0)
      ELSE
         CALL cl_err(ps_slip,"sub-142",0)
      END IF
      RETURN FALSE,ps_slip
   END IF
 
   IF (g_aza.aza41 IS NULL) OR (g_aza.aza42 IS NULL) THEN
      CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
      CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
      RETURN FALSE,ps_slip
   END IF
   LET ls_sql = "SELECT aza41,aza42 FROM ",gs_dbs,"aza_file"
   PREPARE aza_cur FROM ls_sql
   EXECUTE aza_cur INTO g_aza.aza41,g_aza.aza42
   CASE g_aza.aza41
      WHEN "0"   LET g_doc_len = 2                                                                                
                 LET g_no_sp = 2 + 2              
      WHEN "1"   LET g_doc_len = 3
                 LET g_no_sp = 3 + 2
      WHEN "2"   LET g_doc_len = 4
                 LET g_no_sp = 4 + 2
      WHEN "3"   LET g_doc_len = 5
                 LET g_no_sp = 5 + 2
   END CASE
   CASE g_aza.aza42
      WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
      WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
      WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
   END CASE
   CALL cl_msg(cl_getmsg("mfg8889",g_lang)) 
 
   IF ps_sys="ART" OR ps_sys="CRT" THEN
      LET ls_lock_tab = "smy"
   END IF
   IF ps_sys="ALM" OR ps_sys="CLM" THEN
      LET ls_lock_tab = "lrk"
   END IF
   IF ps_sys="AXM" OR ps_sys="CXM" THEN
      LET ls_lock_tab = "oay"
   END IF
   IF NOT s_lock_sql(ls_lock_tab) THEN
      RETURN FALSE,ps_slip
   END IF
   CASE ls_lock_tab
      WHEN "smy" LET lc_method = g_smy.smydmy5
      WHEN "oay" LET lc_method = g_oay.oaydmy6
      WHEN "lrk" LET lc_method = g_lrk.lrkdmy1
   END CASE
   LET lc_max_no = s_get_max_no(lc_method)
   LET lc_next_no = s_get_next_no(lc_max_no,lc_method)
   IF NOT s_chk_no(lc_next_no) THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','','sub-145',1)
      ELSE
         CALL cl_err('','sub-145',0)
      END IF
      RETURN FALSE,lc_next_no
   END IF
   RETURN TRUE,lc_next_no
      
END FUNCTION
 
FUNCTION s_get_max_no(pc_method)
DEFINE pc_method LIKE type_file.chr1
DEFINE ls_date   STRING
DEFINE lc_buf    LIKE apr_file.apr02
#DEFINE lc_max_no LIKE zld_file.zld19
DEFINE lc_max_no LIKE type_file.chr50 #FUN-A80044
DEFINE ls_sql STRING
 
   CASE pc_method
      WHEN '1' LET lc_buf = gc_slip CLIPPED,"-"
      WHEN '2' LET ls_date = gi_year USING "&&&&",gi_month USING "&&"                                                               
               LET ls_date = ls_date.subString(3,6)                                                                                 
               LET lc_buf = gc_slip CLIPPED,"-",ls_date
      WHEN '3' LET ls_date = gi_year USING "&&&&",gi_week USING "&&"                                                                
               LET ls_date = ls_date.subString(3,6)                                                                                 
               LET lc_buf = gc_slip CLIPPED,"-",ls_date 
      WHEN '4' LET ls_date = gi_year USING "&&&&",gi_month USING "&&",gi_day USING "&&"                                                                                
               LET ls_date = ls_date.subString(3,8)                                                                                 
               LET lc_buf = gc_slip CLIPPED,"-",ls_date
   END CASE
   LET ls_sql = "SELECT MAX(",gs_fld,") FROM ",gs_dbs,gs_tab,
                " WHERE ",gs_fld," LIKE '",lc_buf,"%'"
   PREPARE auto_max_no FROM ls_sql
   EXECUTE auto_max_no INTO lc_max_no
   RETURN lc_max_no
   
END FUNCTION
 
FUNCTION s_get_next_no(pc_max_no,pc_method)
DEFINE pc_method LIKE type_file.chr1
#DEFINE pc_max_no LIKE zld_file.zld19
#DEFINE lc_next_no LIKE zld_file.zld19
DEFINE pc_max_no LIKE type_file.chr50 #FUN-A80044
DEFINE lc_next_no LIKE type_file.chr50 #FUN-A80044
DEFINE li_pos LIKE type_file.num5
DEFINE ls_max_no STRING
DEFINE ls_no STRING
DEFINE ls_buf STRING
DEFINE li_sn_cnt LIKE type_file.num5
DEFINE lc_sn     LIKE type_file.chr10
DEFINE li_i LIKE type_file.num5
DEFINE ls_max_sn STRING
DEFINE ls_format STRING
DEFINE ls_date STRING
 
   LET li_sn_cnt = g_no_ep - g_no_sp + 1
   IF cl_null(pc_max_no) THEN
      CASE pc_method
         WHEN '1' FOR li_i=1 TO li_sn_cnt
                      LET ls_max_sn = ls_max_sn,"0"
                      LET ls_format = ls_format,"&"
                  END FOR
                  LET lc_sn = (ls_max_sn+1) USING ls_format
         WHEN '2' LET ls_date = gi_year USING "&&&&",gi_month USING "&&"
                  LET ls_date = ls_date.subString(3,6)
                  FOR li_i = 1 TO li_sn_cnt - 4
                     LET ls_max_sn = ls_max_sn,"0"
                     LET ls_format = ls_format,"&"
                  END FOR
                  LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format                   
         WHEN '3' LET ls_date = gi_year USING "&&&&",gi_week USING "&&"
                  LET ls_date = ls_date.subString(3,6)
                  FOR li_i = 1 TO li_sn_cnt - 4
                     LET ls_max_sn = ls_max_sn,"0"
                     LET ls_format = ls_format,"&"
                  END FOR 
                  LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format   
         WHEN '4' LET ls_date = gi_year USING "&&&&",gi_month USING "&&",gi_day USING "&&"
                  LET ls_date = ls_date.subString(3,8)
                  FOR li_i = 1 TO li_sn_cnt - 6
                     LET ls_max_sn = ls_max_sn,"0"
                     LET ls_format = ls_format,"&"
                  END FOR
                  LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format 
      END CASE 
      LET lc_next_no = gc_slip||'-'||lc_sn
   ELSE
      LET ls_max_no = pc_max_no
      LET li_pos = ls_max_no.getIndexOf('-',1)
      LET ls_no = ls_max_no.substring(li_pos+1,ls_max_no.getLength())
      CASE pc_method
         WHEN '1' FOR li_i=1 TO li_sn_cnt
                      LET ls_format = ls_format,"&"
                  END FOR
                  LET ls_buf = (ls_no+1) USING ls_format
         WHEN '2' FOR li_i = 1 TO li_sn_cnt - 4
                     LET ls_format = ls_format,"&"
                  END FOR
                  LET ls_buf = ls_no.substring(1,4)||((ls_no.substring(5,ls_no.getLength())+1) USING ls_format)
         WHEN '3' FOR li_i = 1 TO li_sn_cnt - 4
                     LET ls_format = ls_format,"&"
                  END FOR
                  LET ls_buf = ls_no.substring(1,4)||((ls_no.substring(5,ls_no.getLength())+1) USING ls_format)
         WHEN '4' FOR li_i = 1 TO li_sn_cnt - 6
                     LET ls_format = ls_format,"&"
                  END FOR
                  LET ls_buf = ls_no.substring(1,6)||((ls_no.substring(7,ls_no.getLength())+1) USING ls_format)
      END CASE
      LET lc_next_no = gc_slip||'-'||ls_buf
   END IF
   RETURN lc_next_no
   
END FUNCTION
 
FUNCTION s_lock_sql(ps_lock_tab)
DEFINE ps_lock_tab STRING
DEFINE ls_sql STRING
 
   CASE ps_lock_tab
      WHEN "smy"
           LET ls_sql = "SELECT * FROM ",gs_dbs,"smy_file WHERE smyslip = ? FOR UPDATE "
      WHEN "lrk"
           LET ls_sql = "SELECT * FROM ",gs_dbs,"lrk_file WHERE lrkslip = ? FOR UPDATE "
      WHEN "oay"
           LET ls_sql = "SELECT * FROM ",gs_dbs,"oay_file WHERE oayslip = ? FOR UPDATE "
   END CASE
   LET ls_sql = cl_forupd_sql(ls_sql)  #No.TQC-9B0023
   DECLARE auto_no_lock CURSOR FROM ls_sql
   OPEN auto_no_lock USING gc_slip
   IF SQLCA.sqlcode = "-243" THEN                                                                                           
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','',"open auto_no_lock:",SQLCA.sqlcode,1)                                                                               
      ELSE                                                                                                                 
         CALL cl_err("open auto_no_lock:",SQLCA.sqlcode,0)
      END IF  
      CLOSE auto_no_lock
      RETURN FALSE
   END IF
   CASE ps_lock_tab
      WHEN "smy" FETCH auto_no_lock INTO g_smy.* 
      WHEN "lrk" FETCH auto_no_lock INTO g_lrk.* 
      WHEN "oay" FETCH auto_no_lock INTO g_oay.* 
   END CASE
   IF SQLCA.sqlcode = "-243" THEN                                                                                           
      IF g_bgerr THEN                                                                                                      
         CALL s_errmsg('','',"fetch auto_no_lock",SQLCA.sqlcode,1)                                                                               
      ELSE                                                                                                                 
         CALL cl_err("fetch auto_no_lock",SQLCA.sqlcode,0)
      END IF               
      CLOSE auto_no_lock
      RETURN FALSE
    END IF
    RETURN TRUE
    
END FUNCTION
 
FUNCTION s_chk_no(pc_no)
#DEFINE pc_no LIKE zld_file.zld19
DEFINE pc_no LIKE type_file.chr50 #FUN-A80044
DEFINE ls_doc STRING
DEFINE ls_tail STRING
DEFINE ls_no STRING
DEFINE li_pos LIKE type_file.num5
  
    LET ls_no = pc_no
    LET ls_no = ls_no.trim()
    IF ls_no.getLength()<>(g_doc_len+g_no_ep-g_no_sp+2) THEN
       RETURN FALSE
    END IF
    LET li_pos = ls_no.getIndexOf('-',1)
    LET ls_doc = ls_no.substring(1,li_pos-1)
    IF ls_doc.getLength()<>g_doc_len THEN 
       RETURN FALSE
    END IF
    LET ls_tail = ls_no.substring(li_pos+1,ls_no.getLength())
    IF ls_tail.getLength()<>(g_no_ep-g_no_sp+1) THEN
       RETURN FALSE
    END IF
    RETURN TRUE 
END FUNCTION
#No.FUN-870007
