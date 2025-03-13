# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program name  : axci101.4gl
# Description   : 雜項進出理由碼會計科目設定作業
# Date & Author : 05/01/28 By Carol
# Modify........: No.FUN-510041 05/01/25 By Carol 設定雜項異動單據的理由碼所對應的科目( 非存貨科目)
#                                                 註:不以單別的角度來設定,是怕這樣一來客戶的單別會設的太細,所以還是以理由碼方式來設
# Modify........: No.FUN-530038 05/03/23 By Carol axci101加一欄位,成本歸屬部門’,此欄位default第一欄位(部門)的值,可修改,此欄位要做科目部門的關係檢查(科目拒絕或接受科目)
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.TQC-620028 06/02/22 By Smapmin 有做部門管理的科目才需CALL s_chkdept
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680086 06/08/25 By Xufeng 多帳套內容新增         
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: NO.FUN-730057 07/03/27 By mike 會計科目加帳套
# Modify.........: No.MOD-760062 07/06/13 By Carol ARRAY轉為EXCEL檔
# Modify.........: No.MOD-830235 08/04/19 By Pengu 在新增時會出現一直agl-209錯誤訊息
# Modify.........: No.FUN-930106 09/03/19 By destiny cxi02增加管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0082 09/12/11 By jan g_max_b-->g_max_rec
# Modify.........: No:CHI-A70057 10/08/11 By Summer 單據分類增加兩個選項4.組合 5.拆解
# Modify.........: No:MOD-AB0087 10/11/10 By sabrina 當sma79='Y'時，理由碼開窗應是aooi306+aooi301。當sma79='N'時，理由碼開窗是aooi301
# Modify.........: No:MOD-AC0027 10/12/06 By sabrina 延伸MOD-AB0087的修改
# Modify.........: No:FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:MOD-B90151 11/09/22 By johung key不允許修改時，不控卡cxi01/cxi02/cxi03
# Modify.........: No:CHI-C40009 12/09/20 By bart 修改理由碼抓取方法
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_cxi       DYNAMIC ARRAY OF RECORD 
              cxi01       LIKE cxi_file.cxi01,
              gem02       LIKE gem_file.gem02,
              cxi02       LIKE cxi_file.cxi02,
              azf03       LIKE azf_file.azf03,
              cxi03       LIKE cxi_file.cxi03,
              cxi04       LIKE cxi_file.cxi04,
              aag02       LIKE aag_file.aag02,
              cxi041      LIKE cxi_file.cxi041,         #FUN-680086
              aag021      LIKE aag_file.aag02,         #FUN-680086
              cxi05       LIKE cxi_file.cxi05,
              gem02_5     LIKE gem_file.gem02
         END RECORD,
         g_cxi_t     RECORD 
              cxi01       LIKE cxi_file.cxi01,
              gem02       LIKE gem_file.gem02,
              cxi02       LIKE cxi_file.cxi02,
              azf03       LIKE azf_file.azf03,
              cxi03       LIKE cxi_file.cxi03,
              cxi04       LIKE cxi_file.cxi04,
              aag02       LIKE aag_file.aag02,
              cxi041      LIKE cxi_file.cxi041,         #FUN-680086
              aag021      LIKE aag_file.aag02,
              cxi05       LIKE cxi_file.cxi05,
              gem02_5     LIKE gem_file.gem02
         END RECORD
 DEFINE   g_sql          string,  #No.FUN-580092 HCN
         g_cnt          LIKE type_file.num10,   #No.FUN-680122 INTEGER
         l_ac           LIKE type_file.num5,    #No.FUN-680122 SMALLINT
         g_rec_b        LIKE type_file.num5    #No.FUN-680122 SMALLINT
        #g_max_b        LIKE type_file.num5     #No.FUN-680122SMALLINT  #TQC-9C0082
DEFINE   p_row          LIKE type_file.num5,    #No.FUN-680122 SMALLINT
         p_col          LIKE type_file.num5,    #No.FUN-680122 SMALLINT
          g_wc2          string,  #No.FUN-580092 HCN
         g_i            LIKE type_file.num5    #No.FUN-680122 SMALLINT
DEFINE   g_forupd_sql   STRING
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680122 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680122 SMALLINT
DEFINE   g_before_input_done   STRING 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8       #No.FUN-6A0146
 
   OPTIONS
      INPUT NO WRAP
      DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
 
   LET p_row = 3 LET p_col = 3
 
   OPEN WINDOW i101_w AT p_row,p_col WITH FORM "axc/42f/axci101"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
   #No.FUN-680086   --Begin--
   IF g_aza.aza63= 'N' THEN
      CALL cl_set_comp_visible("cxi041",FALSE)
      CALL cl_set_comp_visible("aag021",FALSE)
   END IF
   #No.FUN-680086   --End--
 
   SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00='0'
 
   CALL i101_b_fill(' 1=1')
   CALL i101_menu()
 
   CLOSE WINDOW i101_w
 
     CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION i101_menu()
   LET g_action_choice = " "
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i101_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#MOD-760062-add
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cxi),'','')
            END IF
#MOD-760062-add-end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i101_q()
   CALL i101_b_askkey()
END FUNCTION
 
FUNCTION i101_b()
   DEFINE   l_ac_t           LIKE type_file.num5,    #No.FUN-680122 SMALLINT
            l_n              LIKE type_file.num5,    #No.FUN-680122 SMALLINT
            l_lock_sw        LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(1)
            p_cmd            LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(1)
            l_aag05          LIKE aag_file.aag05,
            l_allow_insert   LIKE type_file.chr1,    #No.FUN-680122CHAR(1),
            l_allow_delete   LIKE type_file.chr1     #No.FUN-680122CHAR(1)
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = 
       "SELECT cxi01,'',cxi02,'',cxi03,cxi04,'',cxi041,'',cxi05,'' FROM cxi_file ",      #FUN-680086
       " WHERE cxi01 = ? AND cxi02 = ? AND cxi03 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE axci101_bcl CURSOR FROM g_forupd_sql
 
   INPUT ARRAY g_cxi WITHOUT DEFAULTS FROM s_cxi.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,   #FUN-9C0082
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         CALL i101_set_entry_b('a','N')
         CALL i101_set_no_entry_b('a','N')
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd = 'u'
            LET g_cxi_t.* = g_cxi[l_ac].*
#No.FUN-570110--begin                                                           
            LET g_before_input_done = FALSE                                     
            CALL i101_set_entry_b1(p_cmd)                                       
            CALL i101_set_no_entry_b1(p_cmd)                                    
            LET g_before_input_done = TRUE                                      
#No.FUN-570110--end     
            OPEN axci101_bcl USING g_cxi_t.cxi01,g_cxi_t.cxi02,g_cxi_t.cxi03
            IF STATUS THEN
               CALL cl_err("OPEN axci101_bcl:",STATUS,1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH axci101_bcl INTO g_cxi[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_cxi_t.cxi01,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               ELSE
                  LET g_cxi[l_ac].gem02 = i101_gem02(g_cxi[l_ac].cxi01)
                  DISPLAY BY NAME g_cxi[l_ac].gem02
                  LET g_cxi[l_ac].azf03 = i101_azf03(g_cxi[l_ac].cxi02)
                  DISPLAY BY NAME g_cxi[l_ac].azf03
                  LET g_cxi[l_ac].aag02 = i101_aag02(g_cxi[l_ac].cxi04,g_aza.aza81)            #No.FUN-730057
                  DISPLAY BY NAME g_cxi[l_ac].aag02 
                  #No.FUN-680086   --Begin--
                  LET g_cxi[l_ac].aag021 = i101_aag02(g_cxi[l_ac].cxi041,g_aza.aza82)            #No.FUN-730057 
                  DISPLAY BY NAME g_cxi[l_ac].aag021 
                  #No.FUN_680086   --End--
                  LET g_cxi[l_ac].gem02_5 = i101_gem02(g_cxi[l_ac].cxi05)
                  DISPLAY BY NAME g_cxi[l_ac].gem02_5
                  LET g_before_input_done = FALSE
                  CALL i101_set_entry_b(p_cmd,'N')
                  CALL i101_set_no_entry_b(p_cmd,l_aag05)
                  LET g_before_input_done = TRUE
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
#No.FUN-570110--begin                                                           
         LET g_before_input_done = FALSE                                        
         CALL i101_set_entry_b1(p_cmd)                                          
         CALL i101_set_no_entry_b1(p_cmd)                                       
         LET g_before_input_done = TRUE                                         
#No.FUN-570110--end  
         INITIALIZE g_cxi[l_ac].* TO NULL
         LET g_cxi_t.* = g_cxi[l_ac].*
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD cxi01
         
      AFTER FIELD cxi01
         IF NOT cl_null(g_cxi[l_ac].cxi01) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_chkey = 'Y') THEN   #MOD-B90151 add
               LET g_cxi[l_ac].gem02 = i101_gem02(g_cxi[l_ac].cxi01)
               DISPLAY BY NAME g_cxi[l_ac].gem02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cxi[l_ac].cxi01,g_errno,0)
                  NEXT FIELD cxi01
               ELSE 
                  IF cl_null(g_cxi[l_ac].cxi05) THEN 
                     LET g_cxi[l_ac].cxi05   = g_cxi[l_ac].cxi01
                     LET g_cxi[l_ac].gem02_5 = g_cxi[l_ac].gem02
                     DISPLAY BY NAME g_cxi[l_ac].cxi05
                     DISPLAY BY NAME g_cxi[l_ac].gem02_5
                  END IF
               END IF
            END IF   #MOD-B90151 add
         END IF
         
      AFTER FIELD cxi02
         IF NOT cl_null(g_cxi[l_ac].cxi02) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_chkey = 'Y') THEN   #MOD-B90151 add
               LET g_cxi[l_ac].azf03 = i101_azf03(g_cxi[l_ac].cxi02)
               DISPLAY BY NAME g_cxi[l_ac].azf03
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cxi[l_ac].cxi02,g_errno,0)
                  NEXT FIELD cxi02
               END IF
            END IF   #MOD-B90151 add
         END IF
 
      AFTER FIELD cxi03
         IF NOT cl_null(g_cxi[l_ac].cxi03) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_chkey = 'Y') THEN   #MOD-B90151 add
               IF g_cxi[l_ac].cxi03 NOT MATCHES '[12345]' THEN  #CHI-A70057 add 45
                  NEXT FIELD cxi03
               END IF
               IF g_cxi[l_ac].cxi01 != g_cxi_t.cxi01 
                  OR g_cxi[l_ac].cxi02 != g_cxi_t.cxi02 
                  OR g_cxi[l_ac].cxi03 != g_cxi_t.cxi03 
                  OR g_cxi_t.cxi01 IS NULL
                  OR g_cxi_t.cxi02 IS NULL
                  OR g_cxi_t.cxi03 IS NULL 
               THEN
                  SELECT COUNT(*) INTO l_n FROM cxi_file
                      WHERE cxi01 = g_cxi[l_ac].cxi01
                        AND cxi02 = g_cxi[l_ac].cxi02
                        AND cxi03 = g_cxi[l_ac].cxi03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     NEXT FIELD cxi03
                  END IF
               END IF
               IF g_cxi[l_ac].cxi03 ='3' THEN 
                  SELECT COUNT(*) INTO l_n FROM cxi_file
                      WHERE cxi01 = g_cxi[l_ac].cxi01
                        AND cxi02 = g_cxi[l_ac].cxi02
                        AND ( cxi03 ='1' OR  cxi03 = '2' )
                  IF l_n > 0 THEN
                     CALL cl_err('','axc-035',0)
                     NEXT FIELD cxi03
                  END IF
               END IF
            END IF   #MOD-B90151 add
         END IF
         
      BEFORE FIELD cxi04
         CALL i101_set_no_entry_b(p_cmd,'N')

      AFTER FIELD cxi04
         IF NOT cl_null(g_cxi[l_ac].cxi04) THEN 
            LET g_cxi[l_ac].aag02 = i101_aag02(g_cxi[l_ac].cxi04,g_aza.aza81)  #No.FUN-730057
            DISPLAY BY NAME g_cxi[l_ac].aag02 
            IF NOT cl_null(g_errno) THEN
#FUN-B10052 --begin--            
#              CALL cl_err(g_cxi[l_ac].cxi04,g_errno,1)
               CALL cl_err(g_cxi[l_ac].cxi04,g_errno,0)

               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_cxi[l_ac].cxi04
               LET g_qryparam.arg1= g_aza.aza81  
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_cxi[l_ac].cxi04 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_cxi[l_ac].cxi04
               DISPLAY BY NAME g_cxi[l_ac].cxi04 
               LET g_cxi[l_ac].aag02 = i101_aag02(g_cxi[l_ac].cxi04,g_aza.aza81) 
               DISPLAY BY NAME g_cxi[l_ac].aag02                  
#FUN-B10052 --end--
               NEXT FIELD cxi04
            END IF
            LET l_aag05 = i101_aag05(g_cxi[l_ac].cxi04,g_aza.aza81)              #No.FUN-730057
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cxi[l_ac].cxi04,g_errno,1)
               NEXT FIELD cxi04
            END IF
         ELSE
            LET l_aag05 = 'N'
         END IF
         CALL i101_set_no_entry_b(p_cmd,l_aag05)
 
      BEFORE FIELD cxi041
         CALL i101_set_no_entry_b(p_cmd,'N')
 
      AFTER FIELD cxi041
         IF NOT cl_null(g_cxi[l_ac].cxi041) THEN 
            LET g_cxi[l_ac].aag021 = i101_aag02(g_cxi[l_ac].cxi041,g_aza.aza82)    #No.FUN-730057
            DISPLAY BY NAME g_cxi[l_ac].aag021 
            IF NOT cl_null(g_errno) THEN
#FUN-B10052 --begin--
#               CALL cl_err(g_cxi[l_ac].cxi041,g_errno,1)
                CALL cl_err(g_cxi[l_ac].cxi041,g_errno,0)
                
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_cxi[l_ac].cxi041
               LET g_qryparam.arg1= g_aza.aza82                 
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y' AND aag01 LIKE '",g_cxi[l_ac].cxi041 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_cxi[l_ac].cxi041
               DISPLAY BY NAME g_cxi[l_ac].cxi041 
               LET g_cxi[l_ac].aag021 = i101_aag02(g_cxi[l_ac].cxi041,g_aza.aza82)  
               DISPLAY BY NAME g_cxi[l_ac].aag021 
#FUN-B10052 --end--
               NEXT FIELD cxi041
            END IF
            LET l_aag05 = i101_aag051(g_cxi[l_ac].cxi041,g_aza.aza82)      #No.FUN-730057
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cxi[l_ac].cxi041,g_errno,1)
               NEXT FIELD cxi041
            END IF
         ELSE
            LET l_aag05 = 'N'
         END IF
         
      BEFORE FIELD cxi05
     
      AFTER FIELD cxi05
         IF NOT cl_null(g_cxi[l_ac].cxi05) THEN 
            LET g_cxi[l_ac].gem02_5 = i101_gem02(g_cxi[l_ac].cxi05)
            DISPLAY BY NAME g_cxi[l_ac].gem02_5
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cxi[l_ac].cxi05,g_errno,1)
               NEXT FIELD cxi05
            END IF
            #-----TQC-620028---------
            SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_cxi[l_ac].cxi04
               AND  aag00 = g_aza.aza81               #No.FUN-730057
            #-----END TQC-620028-----
            IF l_aag05 = 'Y' THEN 
            #FUN-680086    --Begin--
            SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_cxi[l_ac].cxi041
               AND  aag00 = g_aza.aza82               #No.FUN-730057
            #FUN-680086    --End--
               CALL s_chkdept(g_aaz.aaz72,g_cxi[l_ac].cxi04,g_cxi[l_ac].cxi05,g_aza.aza81)  #No.FUN-730057
                    RETURNING g_errno
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cxi[l_ac].cxi05,g_errno,1)
                  NEXT FIELD cxi05
               END IF
               #FUN-680086   --Begin--
               IF g_aza.aza63= 'Y' THEN     #No.MOD-830235 add
                  IF l_aag05 = 'Y' THEN     #No.MOD-830235 add
                     CALL s_chkdept(g_aaz.aaz72,g_cxi[l_ac].cxi041,g_cxi[l_ac].cxi05,g_aza.aza82)   #No.FUN-730057 
                          RETURNING g_errno
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_cxi[l_ac].cxi05,g_errno,1)
                        NEXT FIELD cxi05
                     END IF
                  END IF         #No.MOD-830235 add
               END IF            #No.MOD-830235 add
               #FUN-680086   --End--
            END IF 
         END IF
 
      BEFORE DELETE
         IF g_cxi_t.cxi01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err("",-263,1)
               CANCEL DELETE
            END IF
            DELETE FROM cxi_file 
             WHERE cxi01 = g_cxi_t.cxi01
               AND cxi02 = g_cxi_t.cxi02
               AND cxi03 = g_cxi_t.cxi03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cxi_t.cxi01,SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("del","cxi_file",g_cxi_t.cxi01,g_cxi_t.cxi02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
               ROLLBACK WORK
               CANCEL DELETE
            ELSE 
               LET g_rec_b = g_rec_b - 1
               DISPLAY g_rec_b TO FORMONLY.cnt
               COMMIT WORK
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_cxi[l_ac].* = g_cxi_t.*
            CLOSE axci101_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
       
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cxi[l_ac].cxi01,-263,1)
            LET g_cxi[l_ac].* = g_cxi_t.*
         ELSE
            UPDATE cxi_file SET cxi01 = g_cxi[l_ac].cxi01,
                                cxi02 = g_cxi[l_ac].cxi02,
                                cxi03 = g_cxi[l_ac].cxi03,
                                cxi04 = g_cxi[l_ac].cxi04,
                                cxi041 = g_cxi[l_ac].cxi041,       #FUN-680086
                                cxi05 = g_cxi[l_ac].cxi05
             WHERE cxi01 = g_cxi_t.cxi01
               AND cxi02 = g_cxi_t.cxi02
               AND cxi03 = g_cxi_t.cxi03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cxi[l_ac].cxi01,SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("upd","cxi_file",g_cxi_t.cxi01,g_cxi_t.cxi02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
               LET g_cxi[l_ac].* = g_cxi_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE OK'
               COMMIT WORK
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE axci101_bcl
            CANCEL INSERT
         END IF
 
         INSERT INTO cxi_file(cxi01,cxi02,cxi03,cxi04,cxi041,cxi05)  #No.FUN-680086
         VALUES (g_cxi[l_ac].cxi01,
                 g_cxi[l_ac].cxi02,
                 g_cxi[l_ac].cxi03,
                 g_cxi[l_ac].cxi04,
                 g_cxi[l_ac].cxi041,       #No.FUN-680086
                 g_cxi[l_ac].cxi05)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cxi[l_ac].cxi01,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cxi_file",g_cxi[l_ac].cxi01,g_cxi[l_ac].cxi02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT OK'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cnt
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_cxi[l_ac].* = g_cxi_t.*
            #FUN-D40030---add---str---
               ELSE
                  CALL g_cxi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
            END IF
            CLOSE axci101_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE axci101_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO
         IF INFIELD(cxi01) AND l_ac > 1 THEN
            LET g_cxi[l_ac].* = g_cxi[l_ac-1].*
            NEXT FIELD cxi01
         END IF
         
      ON ACTION controlp
         CASE 
            WHEN INFIELD(cxi01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_gem"
               LET g_qryparam.default1 = g_cxi[l_ac].cxi01
               CALL cl_create_qry() RETURNING g_cxi[l_ac].cxi01  
               DISPLAY BY NAME g_cxi[l_ac].cxi01
               LET g_cxi[l_ac].gem02 = i101_gem02(g_cxi[l_ac].cxi01)
               DISPLAY BY NAME g_cxi[l_ac].gem02 
               NEXT FIELD cxi01
            WHEN INFIELD(cxi02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form    = "q_azf"
               IF g_sma.sma79='Y' THEN
                  LET g_qryparam.arg1 = "A2"     #MOD-AB0087 add 2     
               ELSE
                  LET g_qryparam.arg1 = "2"
                  LET g_qryparam.where = " azf09='4' "              #No.FUN-930106
               END IF 
               LET g_qryparam.default1 = g_cxi[l_ac].cxi02
               CALL cl_create_qry() RETURNING g_cxi[l_ac].cxi02
               DISPLAY g_cxi[l_ac].cxi02 TO cxi02
               LET g_cxi[l_ac].azf03 = i101_azf03(g_cxi[l_ac].cxi02)
               DISPLAY BY NAME g_cxi[l_ac].azf03 
               NEXT FIELD cxi02
            WHEN INFIELD(cxi04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_cxi[l_ac].cxi04
               LET g_qryparam.arg1= g_aza.aza81   #No.FUN-730057
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
               CALL cl_create_qry() RETURNING g_cxi[l_ac].cxi04
               DISPLAY BY NAME g_cxi[l_ac].cxi04 
               LET g_cxi[l_ac].aag02 = i101_aag02(g_cxi[l_ac].cxi04,g_aza.aza81)  #No.FUN-730057
               DISPLAY BY NAME g_cxi[l_ac].aag02          
               NEXT FIELD cxi04
            WHEN INFIELD(cxi041)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_cxi[l_ac].cxi041
               LET g_qryparam.arg1= g_aza.aza82                          #No.FUN-730057
               LET g_qryparam.where = "aag07 MATCHES '[23]'  AND aag09 ='Y'"
               CALL cl_create_qry() RETURNING g_cxi[l_ac].cxi041
               DISPLAY BY NAME g_cxi[l_ac].cxi041 
               LET g_cxi[l_ac].aag021 = i101_aag02(g_cxi[l_ac].cxi041,g_aza.aza82)  #No.FUN-730057
               DISPLAY BY NAME g_cxi[l_ac].aag021 
               NEXT FIELD cxi041
            WHEN INFIELD(cxi05)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_gem"
               LET g_qryparam.default1 = g_cxi[l_ac].cxi05
               CALL cl_create_qry() RETURNING g_cxi[l_ac].cxi05  
               DISPLAY BY NAME g_cxi[l_ac].cxi05
               LET g_cxi[l_ac].gem02_5 = i101_gem02(g_cxi[l_ac].cxi05)
               DISPLAY BY NAME g_cxi[l_ac].gem02_5 
               NEXT FIELD cxi05
         OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      END INPUT
   MESSAGE ' '
   CLOSE axci101_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i101_set_entry_b(p_cmd,p_aag05)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
  DEFINE p_aag05 LIKE aag_file.aag05
 
    IF p_cmd = 'a' OR INFIELD(cxi04) OR INFIELD(cxi041) OR ( NOT g_before_input_done ) THEN    #No.FUN-680086
       CASE p_aag05
            WHEN 'Y'     CALL cl_set_comp_required("cxi05",TRUE)
            OTHERWISE
                         CALL cl_set_comp_required("cxi05",FALSE)
       END CASE
    END IF
 
END FUNCTION
 
FUNCTION i101_set_no_entry_b(p_cmd,p_aag05)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
  DEFINE p_aag05 LIKE aag_file.aag05
 
    IF INFIELD(cxi04) OR INFIELD(cxi04) OR ( NOT g_before_input_done ) THEN   #No.FUN-680086 
       CASE p_aag05 
            WHEN 'Y'     CALL cl_set_comp_required("cxi05",TRUE)
            OTHERWISE    
                         CALL cl_set_comp_required("cxi05",FALSE)
       END CASE
    END IF 
 
END FUNCTION
 
FUNCTION i101_gem02(p_code)
 DEFINE p_code      LIKE gem_file.gem01
 DEFINE l_gem02    LIKE gem_file.gem02,
        l_gemacti  LIKE gem_file.gemacti
 
   LET l_gem02 = ''
   LET l_gemacti = ''
   LET g_errno = ''
   SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file 
    WHERE gem01=p_code 
 
   CASE WHEN STATUS=100         LET g_errno='mfg3097'
        WHEN l_gemacti='N'      LET g_errno='9028'
        OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
 
   RETURN l_gem02 
 
END FUNCTION
 
FUNCTION i101_azf03(p_code)
  DEFINE p_code     LIKE azf_file.azf01
  DEFINE l_azfacti  LIKE azf_file.azfacti
  DEFINE l_azf03    LIKE azf_file.azf03
  DEFINE l_azf09    LIKE azf_file.azf09        #No.FUN-930106
  DEFINE l_azf02    LIKE azf_file.azf02        #No.FUN-930106 
   LET l_azf03 = ''
   LET l_azfacti = ''
   LET g_errno = ''
   #No.FUN-930106--begin
   IF g_sma.sma79 = 'Y' THEN                   
#     SELECT azf03,azfacti INTO l_azf03,l_azfacti FROM azf_file
      SELECT azf03,azfacti,azf02 INTO l_azf03,l_azfacti,l_azf02 FROM azf_file
       WHERE azf01 = p_code
         AND azf02 = '2'                                              #No.FUN-930106  #CHI-C40009
         #AND azf02 = 'A'                     #FUN-930106   #MOD-AC0027 mark                                                                                       
         #AND (azf02 = 'A' OR azf02 = '2')    #MOD-AC0027 add  #CHI-C40009      
      #CHI-C40009---begin 
      IF STATUS=100 THEN
         SELECT azf03,azfacti,azf02 INTO l_azf03,l_azfacti,l_azf02 FROM azf_file
          WHERE azf01 = p_code
            AND azf02 = 'A'  
      END IF 
      #CHI-C40009---end
      CASE WHEN STATUS=100         LET g_errno='mfg3088'
           WHEN l_azfacti='N'      LET g_errno='9028'
           OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
      END CASE
   ELSE 
      SELECT azf03,azfacti,azf09 INTO l_azf03,l_azfacti,l_azf09 FROM azf_file                                                                                    
       WHERE azf01 = p_code                                                                                                      
         AND azf02 = '2'     
      CASE WHEN STATUS=100         LET g_errno='mfg3088'                                                                            
           WHEN l_azfacti='N'      LET g_errno='9028'                                                                               
           WHEN l_azf09 !='4'      LET g_errno='aoo-403'                                                                                   
           OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'    
      END CASE
   END IF 
   #No.FUN-930106--end 
 
   RETURN l_azf03
 
END FUNCTION
 
FUNCTION i101_aag02(p_code ,p_bookno)    #No.FUN-730057
  DEFINE p_code     LIKE aag_file.aag01  
  DEFINE p_bookno   LIKE aag_file.aag00 #No.FUN-730057
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag07    LIKE aag_file.aag07
  DEFINE l_aag09    LIKE aag_file.aag09
  DEFINE l_aag02    LIKE aag_file.aag02
 
 
   LET l_aag02 = ''
   LET l_aag07 = ''
   LET l_aag09 = ''
   LET l_aagacti = ''
   LET g_errno = ''
   SELECT aag02,aag07,aag09,aagacti
     INTO l_aag02,l_aag07,l_aag09,l_aagacti
     FROM aag_file
    WHERE aag01=p_code
      AND aag00 = p_bookno    #No.FUN-730057
  
   CASE WHEN STATUS=100         LET g_errno='agl-001'
        WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'     LET g_errno = 'agl-015'
        WHEN l_aag09  = 'N'     LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   
   RETURN l_aag02
 
END FUNCTION
 
FUNCTION i101_aag05(p_cxi04,p_bookno)               #No.FUN-730057
  DEFINE p_code     LIKE aag_file.aag01
  DEFINE p_bookno   LIKE aag_file.aag00              #No.FUN-730057
  DEFINE p_cxi04    LIKE cxi_file.cxi04
  DEFINE l_aag05    LIKE aag_file.aag05,
         l_gem02    LIKE gem_file.gem02,
         l_gemacti  LIKE gem_file.gemacti
 
   LET g_errno = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01=p_cxi04
      AND aag00 = p_bookno      #No.FUN-730057 
 
   CASE WHEN STATUS=100         LET g_errno='agl-001'
        OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
 
   RETURN l_aag05
 
END FUNCTION
 
#No.FUN-680086     --Begin--
FUNCTION i101_aag051(p_cxi041,p_bookno)                #No.FUN-730057
  DEFINE p_code     LIKE aag_file.aag01
  DEFINE p_bookno   LIKE aag_file.aag00                #No.FUN-730057
  DEFINE p_cxi041   LIKE cxi_file.cxi041
  DEFINE l_aag05    LIKE aag_file.aag05,
         l_gem02    LIKE gem_file.gem02,
         l_gemacti  LIKE gem_file.gemacti
 
   LET g_errno = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01=p_cxi041
      AND aag00=p_bookno                   #No.FUN-730057 
 
   CASE WHEN STATUS=100         LET g_errno='agl-001'
        OTHERWISE               LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
 
   RETURN l_aag05
 
END FUNCTION
#No.FUN-680086    --End--
 
FUNCTION i101_b_askkey()
   CLEAR FORM
   CALL g_cxi.clear()
   
   CONSTRUCT g_wc2 ON cxi01,cxi02,cxi03,cxi04,axi041,cxi05        #No.FUN-680086
        FROM s_cxi[1].cxi01,s_cxi[1].cxi02,
             s_cxi[1].cxi03,s_cxi[1].cxi04,s_cxi[1].cxi041,                #No.FUN-680086
             s_cxi[1].cxi05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        
      ON ACTION controlp
         CASE 
            WHEN INFIELD(cxi01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_gem"
               LET g_qryparam.state    = "c"
               LET g_qryparam.default1 = g_cxi[1].cxi01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cxi01
               NEXT FIELD cxi01
            WHEN INFIELD(cxi02) 
               CALL cl_init_qry_var()
              #LET g_qryparam.form     = "q_azf"                  #No.FUN-930106
               IF g_sma.sma79 = 'Y' THEN 
                  LET g_qryparam.form     = "q_azf"               #No.FUN-930106 
                  LET g_qryparam.default1 = g_cxi[1].cxi02,'A'
                  LET g_qryparam.arg1 = "A2"     #MOD-AB0087 add 2     
               ELSE 
                  LET g_qryparam.form     = "q_azf01a"            #No.FUN-930106
                  LET g_qryparam.default1 = g_cxi[1].cxi02,'2'
                 #LET g_qryparam.arg1     = "2"                   #No.FUN-930106
                  LET g_qryparam.arg1     = "4"                   #No.FUN-930106
               END IF
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cxi02
               NEXT FIELD cxi02
            WHEN INFIELD(cxi04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
               LET g_qryparam.default1 = g_cxi[1].cxi04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cxi04
               NEXT FIELD cxi04
            WHEN INFIELD(cxi041)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag09 ='Y'"
               LET g_qryparam.default1 = g_cxi[1].cxi041
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cxi041
               NEXT FIELD cxi041
            WHEN INFIELD(cxi05)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_gem"
               LET g_qryparam.state    = "c"
               LET g_qryparam.default1 = g_cxi[1].cxi05
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cxi05
               NEXT FIELD cxi05
            OTHERWISE EXIT CASE
         END CASE   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
       
		#No.FUN-580031 --start--     HCN
		ON ACTION qbe_select
         	   CALL cl_qbe_select() 
		ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL i101_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i101_b_fill(lc_wc2)
   DEFINE   lc_wc2   LIKE type_file.chr1000   #No.FUN-680122CHAR(1000)
 
   LET g_sql = "SELECT cxi01,'',cxi02,'',cxi03,cxi04,'',cxi041,'',cxi05,''",       #No.FUN-680086
               "  FROM cxi_file",
               " WHERE ",lc_wc2 CLIPPED,
               " ORDER BY cxi01"
   PREPARE axci101_pb FROM g_sql
   DECLARE ze_curs CURSOR FOR axci101_pb
 
   CALL g_cxi.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
   MESSAGE "Searching!"
   FOREACH ze_curs INTO g_cxi[g_cnt].*
      IF STATUS THEN
         CALL cl_err('FOREACH:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cxi[g_cnt].gem02 = i101_gem02(g_cxi[g_cnt].cxi01)
      LET g_cxi[g_cnt].azf03 = i101_azf03(g_cxi[g_cnt].cxi02)
      LET g_cxi[g_cnt].aag02 = i101_aag02(g_cxi[g_cnt].cxi04,g_aza.aza81)             #No.FUN-730057 
      LET g_cxi[g_cnt].aag021 = i101_aag02(g_cxi[g_cnt].cxi041,g_aza.aza82)            #No.FUN-730057 
      LET g_cxi[g_cnt].gem02_5 = i101_gem02(g_cxi[g_cnt].cxi05)
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_cxi.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1 
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
 
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_cxi TO s_cxi.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query                  # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail                 # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help                   # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit                   # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice = "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT DISPLAY
 
#MOD-760062-add
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#MOD-760062-add-end
     
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-570110--begin                                                           
FUNCTION i101_set_entry_b1(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("cxi01,cxi02,cxi03",TRUE)                           
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i101_set_no_entry_b1(p_cmd)                                            
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("cxi01,cxi02,cxi03",FALSE)                          
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570110--end             
