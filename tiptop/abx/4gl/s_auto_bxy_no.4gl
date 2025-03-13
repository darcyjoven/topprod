# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Program name	: s_auto_bxy_no.4gl
# Program ver.	: 7.0
# Description	: 依照bxy01單別自動編號
# LIKE type_file.dat & Author	: 2006/11/02 by kim
# Memo        	: 由s_auto_assing_no.4gl改寫
# Modify.........: No.FUN-960081 09/07/21 By dxfwo   s_get_serial_no自動編號添加參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-9B0035 09/11/05 By wujie 5.2SQL转标准语法
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........:#No.TQC-A70106 10/07/22 by yinhy DEFINE段LIKE語法zld_file.zld19改為skh_file.skh03

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_aac          RECORD LIKE aac_file.*
DEFINE   g_fah          RECORD LIKE fah_file.*
DEFINE   g_forupd_sql   STRING
DEFINE   g_bxy          RECORD LIKE bxy_file.*
 
#[
# Description  	: 自動編號
# LIKE type_file.dat & Author	: 2006/11/02 by kim
# Parameter   	: ps_slip        單號
#               : ps_date        日期
#               : ps_tab         單據編號是否重複要檢查的table名稱
#               : ps_fld         單據編號對應要檢查的key欄位名稱
#               : ps_dbs         工廠別
# Return   	: li_result      結果(TRUE/FALSE)
#               : ls_no          單據編號
# Memo        	. CALL s_auto_bxy_no(g_bxi.bxi01,g_bxi.bxi02)
# Modify   	:
#]
#FUNCTION s_auto_bxy_no(ps_slip,ps_date,ps_tab,ps_fld,ps_dbs)   #No.FUN-980025 mark
FUNCTION s_auto_bxy_no(ps_slip,ps_date,ps_tab,ps_fld,ps_plant)  #No.FUN-980025 
   DEFINE   ps_slip         STRING
   DEFINE   ps_date         LIKE type_file.dat
   DEFINE   ps_tab          STRING
   DEFINE   ps_fld          STRING
   DEFINE   ps_dbs          STRING
   DEFINE   ps_plant        LIKE type_file.chr10
   DEFINE   li_sn_cnt       LIKE type_file.num10               # 單號碼數
   DEFINE   ls_doc          STRING                # 單別
   DEFINE   ls_sn           STRING                # 單號
   DEFINE   lc_doc          LIKE type_file.chr5            # 單別
   DEFINE   lc_sn           LIKE apr_file.apr02           # 單號
   DEFINE   lc_max_no       LIKE apr_file.apr02           # 最大單據編號
   DEFINE   ls_max_sn       STRING                # 最大流水號
   DEFINE   li_year         LIKE azn_file.azn02   # 年度
   DEFINE   li_month        LIKE azn_file.azn04   # 期別
   DEFINE   li_week         LIKE azn_file.azn05   # 週別
   DEFINE   ls_type         STRING                # 單據性質
   DEFINE   lc_method       LIKE type_file.chr1               # 編號方式
   DEFINE   ls_date         STRING
   DEFINE   lc_buf          LIKE apr_file.apr02  #MOD-590151 10->12
   DEFINE   lc_buf2         LIKE apr_file.apr02  #FUN-560095
   DEFINE   lc_msg          LIKE adj_file.adj02
   DEFINE   li_i            LIKE type_file.num10
   DEFINE   ls_format       STRING
   DEFINE   ls_sql          STRING
   DEFINE   li_cnt          LIKE type_file.num10
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   ls_no           STRING
   #DEFINE   lc_no           LIKE zld_file.zld19   #mark by No.TQC-A70106
   DEFINE   lc_no           LIKE skh_file.skh03    #add by No.TQC-A70106
   DEFINE   lc_progname     LIKE gaz_file.gaz03
   DEFINE   lc_aza41_t      LIKE aza_file.aza41,    #No.FUN-560192
            lc_aza42_t      LIKE aza_file.aza42,    #備份原本單據編號設定值
            li_doc_len_t    LIKE type_file.num5,
            li_no_sp_t      LIKE type_file.num5,
            li_no_ep_t      LIKE type_file.num5
 
 
   ##NO.FUN-980025 GP5.2 add begin                                                                                                  
   IF cl_null(ps_plant) THEN                                                                                                         
     LET ps_dbs = NULL                                                                                                               
   ELSE                                                                                                                             
     LET g_plant_new = ps_plant                                                                                                      
     CALL s_getdbs()                                                                                                                
     LET ps_dbs = g_dbs_new                                                                                                          
   END IF                                                                                                                           
   ##NO.FUN-980025 GP5.2 add end  
   WHENEVER ERROR CALL cl_err_msg_log
 
   ##DB的種類
   LET ps_dbs=ps_dbs.trimRight()
   LET ps_dbs = s_dbstring(ps_dbs CLIPPED)    #FUN-9B0106
 
   IF (g_aza.aza41 IS NULL) OR (g_aza.aza42 IS NULL) THEN
      CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
      CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
      RETURN FALSE,ps_slip
   END IF
 
   ##不同DB，單據長度也不同
  #IF (NOT cl_null(ps_dbs)) THEN   #FUN-A50102
   IF (NOT cl_null(ps_plant)) THEN   #FUN-A50102
      LET lc_aza41_t = g_aza.aza41
      LET lc_aza42_t = g_aza.aza42
      LET li_doc_len_t = g_doc_len
      LET li_no_sp_t = g_no_sp
      LET li_no_ep_t = g_no_ep
 
     #LET ls_sql = "SELECT aza41,aza42 FROM ",ps_dbs,"aza_file"
      LET ls_sql = "SELECT aza41,aza42 FROM ",cl_get_target_table(ps_plant,'aza_file')   #FUN-A50102
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        #FUN-920032
      CALL cl_parse_qry_sql(ls_sql,ps_plant) RETURNING ls_sql  #FUN-A50102
      PREPARE aza_cur FROM ls_sql
      EXECUTE aza_cur INTO g_aza.aza41,g_aza.aza42
      CASE g_aza.aza41
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
   END IF
 
   ##單號碼數
   LET li_sn_cnt = g_no_ep - g_no_sp + 1
 
   LET ps_slip = ps_slip.trimRight()        #No.MOD-580290
 
   # 如果要自動編號，但傳進的單據編號是完整的，就直接檢查編號是否重複、連續性就回傳
   IF ps_slip.getLength() = g_no_ep THEN
      CALL cl_chk_data_continue(ps_slip) RETURNING li_result
      IF NOT li_result THEN
         CALL cl_err(ps_slip,"sub-141",0)
         RETURN li_result,ps_slip
      END IF
 
      # 編號重複檢查
      LET ls_sql = " SELECT COUNT(*) FROM ",ps_tab,
                   "  WHERE ",ps_fld," = '",ps_slip.trim(),"'"
      PREPARE autono_chk_curs FROM ls_sql
      EXECUTE autono_chk_curs INTO li_cnt
      IF li_cnt > 0 THEN
         CALL cl_err(ps_slip,"sub-144",1)
         RETURN FALSE,ps_slip
      END IF
 
      RETURN TRUE,ps_slip
   END IF
 
   # 自動編號前的check、預設動作
   LET lc_max_no = NULL
   LET ls_max_sn = NULL
   LET ls_doc = ps_slip.subString(1,g_doc_len)
   LET lc_doc = ls_doc
#  LET ls_sn = s_get_serial_no(ps_slip)        #FUN-960081 
   LET ls_sn = s_get_serial_no(ps_slip,'','')  #FUN-960081 
   SELECT azn02,azn04,azn05 INTO li_year,li_month,li_week
     FROM azn_file WHERE azn01 = ps_date
   IF STATUS THEN 
      CALL cl_err("","sub-142",0)
      RETURN FALSE,ps_slip
   END IF
   
   #TQC-630101
   # 避免搶號，因此在 select 時便作 lock，待取得單號後再release
   CALL cl_err("","mfg8889",0)
   #END TQC-630101
 
   # 各系統自動編號
   LET g_forupd_sql = " SELECT bxy07 FROM bxy_file ",
                      "  WHERE bxy01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE bxyauno_cl CURSOR FROM g_forupd_sql
   OPEN bxyauno_cl USING lc_doc 
   IF SQLCA.sqlcode = "-243" THEN
      CALL cl_err("open bxyauno_cl:",SQLCA.sqlcode,1)
      CLOSE bxyauno_cl
      RETURN FALSE,ps_slip
   END IF
 
   FETCH bxyauno_cl INTO lc_method
   IF SQLCA.sqlcode = "-243" THEN
      CALL cl_err("bxy07",SQLCA.sqlcode,1)
      CLOSE bxyauno_cl
      RETURN FALSE,ps_slip
   END IF
   CASE
      WHEN (lc_method = "1")                    #依流水號
#FUN-9B0035 mod --begin
#           SELECT MAX(bxi01) INTO lc_max_no FROM bxi_file
#           WHERE SUBSTR(bxi01,1,g_doc_len) = lc_doc
#            WHERE bxi01[1,g_doc_len] = lc_doc     #No.FUN-9B0035
             
            LET ls_sql="SELECT MAX(bxi01) FROM bxi_file ",
                       "  WHERE bxi01 LIKE '", lc_doc CLIPPED, "%'"    #No.FUN-9B0035
            PREPARE bxi_max1 FROM ls_sql
            EXECUTE bxi_max1 INTO lc_max_no
      WHEN (lc_method = "2")                    #依年度期別
            LET ls_date = li_year USING "&&&&",li_month USING "&&"
            LET ls_date = ls_date.subString(3,6)
            LET lc_buf = lc_doc CLIPPED,"-",ls_date
#            SELECT MAX(bxi01) INTO lc_max_no FROM bxi_file
#            WHERE SUBSTR(bxi01,1,g_doc_len+5) = lc_buf
#             WHERE bxi01[1,g_doc_len+5] = lc_buf  #No.FUN-9B0035
 
            LET ls_sql="SELECT MAX(bxi01) FROM bxi_file ",
                       "  WHERE bxi01 LIKE '", lc_buf CLIPPED, "%'"  #No.FUN-9B0035
            PREPARE bxi_max2 FROM ls_sql
            EXECUTE bxi_max2 INTO lc_max_no
      WHEN (lc_method = "3")                    #依年度週別
           LET ls_date = li_year USING "&&&&",li_week USING "&&"
           LET ls_date = ls_date.subString(3,6)
           LET lc_buf = lc_doc CLIPPED,"-",ls_date
#           SELECT MAX(bxi01) INTO lc_max_no FROM bxi_file
#           WHERE SUBSTR(bxi01,1,g_doc_len+5) = lc_buf
#            WHERE bxi01[1,g_doc_len+5] = lc_buf  #No.FUN-9B0035

           LET ls_sql="SELECT MAX(bxi01)  FROM bxi_file ",
                      " WHERE bxi01 LIKE '",lc_buf CLIPPED, "%'"  #No.FUN-9B0035
           PREPARE bxi_max3 FROM ls_sql
           EXECUTE bxi_max3 INTO lc_max_no
      WHEN (lc_method = "4")                    #依年月日
           LET ls_date = li_year USING "&&&&",li_month USING "&&", 
                         DAY(ps_date) USING "&&"
           LET ls_date = ls_date.subString(3,8)
           LET lc_buf = lc_doc CLIPPED,"-",ls_date
#           SELECT MAX(bxi01) INTO lc_max_no FROM bxi_file
#           WHERE SUBSTR(bxi01,1,g_doc_len+7) = lc_buf
#            WHERE bxi01[1,g_doc_len+7] = lc_buf   #No.FUN-9B0035

           LET ls_sql="SELECT MAX(bxi01) FROM bxi_file ",
                      " WHERE bxi01 LIKE '",lc_buf CLIPPED, "%'"   #No.FUN-9B0035
           PREPARE bxi_max4 FROM ls_sql
           EXECUTE bxi_max4 INTO lc_max_no
#FUN-9B0035 mod
   END CASE
 
   # 找出資料庫中最大的單據編號後，計算新的單據編號
   LET ls_max_sn = lc_max_no[g_no_sp,g_no_ep]
 
   IF cl_null(ps_slip.subString(g_no_sp,g_no_ep)) THEN
      CASE
         WHEN (lc_method = "1")                                #依流水號
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN  #最大流水號未曾指定
               LET ls_max_sn = ""
               FOR li_i = 1 TO li_sn_cnt
                   LET ls_max_sn = ls_max_sn,"0"
               END FOR
            END IF
            LET ls_format = ""
            FOR li_i = 1 TO li_sn_cnt
                LET ls_format = ls_format,"&"
            END FOR
            LET lc_sn = (ls_max_sn + 1) USING ls_format
 
         WHEN (lc_method = "2")                #依年度期別
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN  #最大流水號未曾指定
               LET ls_date = li_year USING "&&&&",li_month USING "&&"
               LET ls_date = ls_date.subString(3,6)
               LET ls_max_sn = ""
               LET ls_format = ""
               FOR li_i = 1 TO li_sn_cnt - 4
                   LET ls_max_sn = ls_max_sn,"0"
                   LET ls_format = ls_format,"&"
               END FOR
               LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format
            ELSE
               LET ls_format = ""
               FOR li_i = 1 TO li_sn_cnt - 4
                   LET ls_format = ls_format,"&"
               END FOR
               LET lc_sn = ls_date,(ls_max_sn.subString(5,li_sn_cnt) + 1) USING ls_format
            END IF
 
         WHEN (lc_method = "3")                #依年度週別
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN  #最大流水號未曾指定
               LET ls_date = li_year USING "&&&&",li_week USING "&&"
               LET ls_date = ls_date.subString(3,6)
               LET ls_max_sn = ""
               LET ls_format = ""
               FOR li_i = 1 TO li_sn_cnt - 4
                   LET ls_max_sn = ls_max_sn,"0"
                   LET ls_format = ls_format,"&"
               END FOR
               LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format
            ELSE
               LET ls_format = ""
               FOR li_i = 1 TO li_sn_cnt - 4
                   LET ls_format = ls_format,"&"
               END FOR
               LET lc_sn = ls_date,(ls_max_sn.subString(5,li_sn_cnt) + 1) USING ls_format
            END IF
 
         WHEN (lc_method = "4")                                #依年月日
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN  #最大流水號未曾指定
               LET ls_date = li_year USING "&&&&",li_month USING "&&",
                             DAY(ps_date) USING "&&"
               LET ls_date = ls_date.subString(3,8)
               LET ls_max_sn = ""
               LET ls_format = ""
               FOR li_i = 1 TO li_sn_cnt - 6
                   LET ls_max_sn = ls_max_sn,"0"
                   LET ls_format = ls_format,"&"
               END FOR
               LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format
            ELSE
               LET ls_format = ""
               FOR li_i = 1 TO li_sn_cnt - 6
                   LET ls_format = ls_format,"&"
               END FOR
               LET lc_sn = ls_date,(ls_max_sn.subString(7,li_sn_cnt) + 1) USING ls_format
            END IF
      END CASE
   ELSE
      # 檢查單號碼數是否符合設定值
      IF ls_sn.getLength() <> li_sn_cnt THEN
         CALL cl_err(ls_sn,"sub-143",1)   # TQC-5B0162 0->1
         RETURN FALSE,ps_slip
      END IF
         
      CALL cl_chk_data_continue(ls_sn) RETURNING li_result
      IF NOT li_result THEN
         CALL cl_err(ls_sn,"sub-143",1)   # TQC-5B0162 0->1
         RETURN li_result,ps_slip
      END IF
 
      # 編號重複檢查
      LET ls_sql = " SELECT COUNT(*) FROM ",ps_tab,
                   "  WHERE ",ps_fld," = '",ps_slip.trim(),"'"
      PREPARE autono1_chk_curs FROM ls_sql
      EXECUTE autono1_chk_curs INTO li_cnt
      IF li_cnt > 0 THEN
         CALL cl_err(ps_slip,"sub-144",1)
         RETURN FALSE,ps_slip
      END IF
   END IF
 
   LET lc_no = lc_doc CLIPPED,"-",lc_sn
   LET ls_no = lc_no CLIPPED               #No.MOD-580290
 
  #IF (NOT cl_null(ps_dbs)) THEN   #FUN-A50102
   IF (NOT cl_null(ps_plant)) THEN
      LET g_aza.aza41 = lc_aza41_t
      LET g_aza.aza42 = lc_aza42_t
      LET g_doc_len = li_doc_len_t
      LET g_no_sp = li_no_sp_t
      LET g_no_ep = li_no_ep_t
   END IF
 
   RETURN TRUE,ls_no
END FUNCTION
 
#[
# Description  	: 單據編號檢查
# LIKE type_file.dat & Author	: 2006/11/02 by kim
# Parameter   	: ps_slip        新單號
# Return   	    : li_result      結果(TRUE/FALSE)
#               : ls_no          單據編號
# Memo        	: CALL s_chk_bxy_no(g_bxi.bxi01) RETURNING li_result,g_bxi.bxi01
# Modify   	    :
#]
FUNCTION s_chk_bxy_no(ps_slip,ps_slip_o)
   DEFINE   ps_slip         STRING
   DEFINE   ps_slip_o       STRING
   DEFINE   li_inx_s        LIKE type_file.num10
   DEFINE   ls_doc          STRING                  # 單別
   DEFINE   ls_sn           STRING                  # 單號
   DEFINE   lc_doc          LIKE type_file.chr5              # 單別
   DEFINE   li_sn_cnt       LIKE type_file.num10                 # 單號碼數
   DEFINE   ls_sql          STRING
   DEFINE   li_result       LIKE type_file.num5
   #DEFINE   ls_no           LIKE zld_file.zld19  #mark by No.TQC-A70106
   DEFINE   ls_no           LIKE skh_file.skh03   #add by No.TQC-A70106
   DEFINE   lc_progname     LIKE gaz_file.gaz03
   DEFINE   ls_temp         STRING
   DEFINE   li_cnt          LIKE type_file.num5
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET li_result = TRUE
 
   IF cl_null(ps_slip) THEN
      RETURN FALSE,ps_slip
   END IF
 
   IF (g_aza.aza41 IS NULL) OR (g_aza.aza42 IS NULL) THEN
      CALL cl_get_progname("aoos010",g_lang) RETURNING lc_progname
      CALL cl_err_msg("","sub-140",lc_progname CLIPPED,0)
      RETURN FALSE,ps_slip
   END IF
 
   LET li_sn_cnt = g_no_ep - g_no_sp + 1
 
   LET li_inx_s = ps_slip.getIndexOf("-",1)
   IF li_inx_s > 0 THEN
      LET ls_doc = ps_slip.subString(1,li_inx_s - 1)
      LET ls_temp = ps_slip.trim()
      LET ls_sn = ps_slip.subString(li_inx_s + 1,ls_temp.getLength())
   ELSE
      LET ls_doc = ps_slip
      LET ls_sn = NULL
   END IF
 
   IF cl_null(ls_doc) THEN
      CALL cl_err(ls_doc,"sub-146",1) #MOD-590041 0->1
      RETURN FALSE,ps_slip
   END IF
 
   # 檢查單別碼數是否符合設定值
   LET ls_doc = ls_doc.trim()
   IF ls_doc.getLength() <> g_doc_len THEN
      CALL cl_err(ls_doc,"sub-146",1) #MOD-590041 0->1
      RETURN FALSE,ps_slip
   END IF
 
   # 檢查單別資料是否連續
   CALL cl_chk_data_continue(ls_doc) RETURNING li_result
   IF NOT li_result THEN
      CALL cl_err(ls_doc,"sub-146",1) #MOD-590041 0->1
      RETURN li_result,ps_slip
   END IF
 
   # 單別檢查,原本的s_*slip程式
   LET lc_doc = ls_doc
   LET g_errno = ""
 
   ##檢查是否為自動編號
   SELECT * INTO g_bxy.* FROM bxy_file WHERE bxy01 = lc_doc
   IF SQLCA.sqlcode = 100 THEN
      LET g_errno = "aap-010"
   END IF
   IF g_bxy.bxy06 = 'N' OR cl_null(g_bxy.bxy06) THEN
      LET g_errno = "amm-107"
   END IF
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(ps_slip,g_errno,1)
      RETURN FALSE,ps_slip
   END IF
 
   # 單號部分有輸入
   IF NOT cl_null(ls_sn) THEN
      # 檢查單號碼數是否符合設定值
      IF ls_sn.getLength() <> li_sn_cnt THEN
         CALL cl_err(ls_sn,"sub-143",1)
         RETURN FALSE,ps_slip
      END IF
            
      CALL cl_chk_data_continue(ls_sn) RETURNING li_result
      IF NOT li_result THEN
         CALL cl_err(ls_sn,"sub-143",1)  # TQC-5B0162 0->1
         RETURN li_result,ps_slip
      END IF
 
      # 編號重複檢查
      IF (ps_slip != ps_slip_o) OR (ps_slip_o IS NULL) THEN
         LET ls_sql = "SELECT COUNT(*) FROM bxi_file",
                      " WHERE bxi01 = '",ps_slip.trim(),"'"
         PREPARE no_chk_curs FROM ls_sql
         EXECUTE no_chk_curs INTO li_cnt
         IF li_cnt > 0 THEN
            CALL cl_err(ps_slip,"sub-144",1)
            RETURN FALSE,ps_slip
         END IF
      END IF
   END IF
 
   LET ls_no = ls_doc,"-",ls_sn
   RETURN li_result,ls_no
END FUNCTION
 
