# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmp460.4gl
# Descriptions...: 整批發佈電子採購需求作業
# Date & Author..: 09/12/08 By baofei
# Memo...........: 
# Modify.........: FUN-9A0065
# Modify.........: No:FUN-A10034 10/01/07 By baofei  BUG修改
# Modify.........: No:FUN-A90009 10/09/27 By detiny  b2b修改
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.TQC-B20184 11/02/28 By wuxj 廠商欄位檢查修改,mail改善
# Modify.........: No.TQC-B30010 11/03/02 By wuxj 廠商欄位檢查修改
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_pml         DYNAMIC ARRAY OF RECORD
            sel        LIKE type_file.chr1,
            wpc10      LIKE wpc_file.wpc10, #No.FUN-A90009
            pmk09      LIKE pmk_file.pmk09, 
            pmc03      LIKE pmc_file.pmc03,
            pml04      LIKE pml_file.pml04,
            pml041     LIKE pml_file.pml041,
            ima021     LIKE ima_file.ima021,
            pml33      LIKE pml_file.pml33,
            pml07      LIKE pml_file.pml07,
            pml20      LIKE pml_file.pml20
                       END RECORD
DEFINE   g_pmk         DYNAMIC ARRAY OF RECORD
            c          LIKE type_file.chr1,
            pmk01      LIKE pmk_file.pmk01,
            pmk04      LIKE pmk_file.pmk04,
            pmk09      LIKE pmk_file.pmk09, 
            pmc03      LIKE pmc_file.pmc03, 
            pml02      LIKE pml_file.pml02,
            pml04      LIKE pml_file.pml04,
            pml041     LIKE pml_file.pml041,
            ima021     LIKE ima_file.ima021,
            pml33      LIKE pml_file.pml33,
            pml07      LIKE pml_file.pml07,
            pml20      LIKE pml_file.pml20
                       END RECORD 
DEFINE   g_pml2        DYNAMIC ARRAY OF RECORD
            pmk09      LIKE pmk_file.pmk09, 
            pmc03      LIKE pmc_file.pmc03
                       END RECORD                                                 
DEFINE   g_sql         STRING
DEFINE   g_wc          STRING
DEFINE   g_rec_b       LIKE type_file.num10
DEFINE   g_rec_b1      LIKE type_file.num10
DEFINE   g_cnt         LIKE type_file.num10
DEFINE   g_ac          LIKE type_file.num5
DEFINE   g_pmk01       LIKE pmk_file.pmk01
DEFINE   g_pml04       LIKE pml_file.pml04
DEFINE   g_pmk04       LIKE pmk_file.pmk04
DEFINE   g_curs_index  LIKE type_file.num10   
DEFINE   g_row_count   LIKE type_file.num10   
DEFINE   g_jump        LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03     
DEFINE   mi_need_cons  LIKE type_file.num5 
DEFINE   g_count       LIKE type_file.num10
DEFINE   g_pmk09_t     LIKE pmk_file.pmk09
DEFINE   g_renew       LIKE type_file.num5
DEFINE   g_wpc         RECORD LIKE wpc_file.*
DEFINE g_channel        base.Channel
DEFINE g_tmpstr         STRING

MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
    
   CALL create_temp()
   
   OPEN WINDOW p460_w WITH FORM "apm/42f/apmp460"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
   CALL cl_ui_locale("apmp460")
   #No.FUN-A90009--begin
   IF g_aza.aza95='N' THEN 
      CALL cl_err('','apm-317',1)
      EXIT PROGRAM 
   END IF 
   #No.FUN-A90009--end    
 # CALL cl_used('apmp460',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   LET g_cnt = 0
   LET mi_need_cons = 1
   LET g_renew = 1
   CALL p460_p()

   CLOSE WINDOW p460_w
 # CALL cl_used('apmp460',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN
FUNCTION p460_p()
 
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p460_q()
      END IF
      CALL p460_p1()
      
      CASE g_action_choice

         WHEN  "e_release" 
            IF cl_chk_act_auth() THEN
               CALL p460_e_pur() 
            END IF   
            
         WHEN  "mul_vendor" 
            LET g_renew = 0
            IF cl_chk_act_auth() THEN
               CALL p460_mul()
            END IF  
            
         WHEN  "order" 
            LET g_renew = 0
            IF cl_chk_act_auth() THEN
               CALL p460_pr_d()
            END IF   
                                    

         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
FUNCTION create_temp()
  DROP table  pr_temp
  CREATE TEMP TABLE pr_temp (
     b01  LIKE  type_file.chr1,
     b11  LIKE  wpc_file.wpc10, #No.FUN-A90009 
     b02  LIKE  pmk_file.pmk04,
     b03  LIKE  pmk_file.pmk01,
     b04  LIKE  pmk_file.pmk09,
     b05  LIKE  pml_file.pml02,
     b06  LIKE  pml_file.pml04,
     b07  LIKE  pml_file.pml07,
     b08  LIKE  pml_file.pml20,
     b09  LIKE  pml_file.pml33,
     b10  LIKE  pml_file.pml041 )
  DROP table  cus_temp
  CREATE TEMP TABLE cus_temp (
     c01  LIKE  pml_file.pml04,
     c02  LIKE  pml_file.pml041,     
     c03  LIKE  pml_file.pml33,
     c04  LIKE  pml_file.pml07,
     c05  LIKE  pmk_file.pmk09 )  
END FUNCTION
FUNCTION p460_p1()
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      INPUT ARRAY g_pml WITHOUT DEFAULTS FROM s_pml.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
         BEFORE ROW
         
           IF  g_renew THEN 
               LET g_ac = ARR_CURR()   
           END IF
           CALL fgl_set_arr_curr(g_ac)
           LET g_renew = 1
          CALL cl_show_fld_cont()

          #No.FUN-A90009--begin
          AFTER FIELD sel 
            IF g_pml[g_ac].sel='Y' THEN 
               CALL cl_set_comp_entry('wpc10',TRUE)
               LET g_pml[g_ac].wpc10=(g_today+g_pml[g_ac].pml33)/2
               DISPLAY BY NAME g_pml[g_ac].wpc10
            ELSE 
            	 CALL cl_set_comp_entry('wpc10',FALSE)
            	 LET g_pml[g_ac].wpc10=NULL 
            	 DISPLAY BY NAME g_pml[g_ac].wpc10
            END IF 
            
          ON CHANGE sel
            IF g_pml[g_ac].sel='Y' THEN 
               CALL cl_set_comp_entry('wpc10',TRUE)
               LET g_pml[g_ac].wpc10=(g_today+g_pml[g_ac].pml33)/2
               DISPLAY BY NAME g_pml[g_ac].wpc10               
            ELSE 
            	 CALL cl_set_comp_entry('wpc10',FALSE)
            	 LET g_pml[g_ac].wpc10=NULL 
            	 DISPLAY BY NAME g_pml[g_ac].wpc10
            END IF   
            
          AFTER FIELD wpc10 
            IF NOT cl_null(g_pml[g_ac].wpc10) THEN 
               IF g_pml[g_ac].wpc10<=g_today OR g_pml[g_ac].wpc10 >g_pml[g_ac].pml33 THEN 
                  CALL cl_err('','apm-319',1)
                  NEXT FIELD wpc10 
               END IF 
            END IF             
          #No.FUN-A90009--end  
                      
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT
 
         ON ACTION e_release 
            LET g_action_choice="e_release"
            EXIT INPUT
 
         ON ACTION order 
            LET g_action_choice="order"
            EXIT INPUT
            
         ON ACTION mul_vendor 
            LET g_action_choice="mul_vendor"
            EXIT INPUT            
 
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
              
         ON ACTION close 
            LET INT_FLAG=FALSE 
            LET g_action_choice="exit"
            EXIT INPUT              
              
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p460_cs()
      CONSTRUCT g_wc ON pmk01,pmk04,pml04 FROM 
        FORMONLY.pmk01_q,FORMONLY.pmk04_q,FORMONLY.pml04_q
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()  
            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmk01_q)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmk01"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk01_q
                    NEXT FIELD pmk01_q
               WHEN INFIELD(pml04_q)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_pml04"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_pml04","","","","","","","",'')  
                             RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO pml04_q
                    NEXT FIELD pml04_q                 
                 
            END CASE          
      END CONSTRUCT
END FUNCTION

FUNCTION p460_q()
    
  	MESSAGE ""
    CALL cl_set_act_visible("accept,cancel", TRUE)
  	CLEAR FORM
     
  	DISPLAY '   ' TO FORMONLY.cn 
  	CALL p460_cs() 
    CALL create_temp()
  	CALL ins_pr_temp(g_wc)
  	CALL p460_b_fill(g_wc)
END FUNCTION
FUNCTION ins_pr_temp(p_wc)
  DEFINE   l_sql    STRING
  DEFINE   p_wc     STRING
  DEFINE   l_pmk01  LIKE pmk_file.pmk01  #No.FUN-A90009
  DEFINE   l_pmk09  LIKE pmk_file.pmk09  #No.FUN-A90009
   
   #No.FUN-A90009--begin
   #LET l_sql = " INSERT INTO pr_temp ",
   #            " SELECT 'Y','',pmk04,pmk01,pmk09,pml02,pml04,pml07,pml20,pml33,pml041 FROM pmk_file,pml_file ",  #No.FUN-A90009 add ''
   #            " WHERE ",p_wc,
   #            " AND pmk18 = 'Y' AND pmk25 = '1' AND pmk01 = pml01",
   #            " AND pml16 = '1' AND pml92 = 'N' "
   #
   #PREPARE b_pr1 FROM l_sql
   #EXECUTE b_pr1   
   LET l_sql = " INSERT INTO pr_temp ",
               " SELECT 'Y','',pmk04,pmk01,pmk09,pml02,pml04,pml07,(pml20-pml21),pml33,pml041 FROM pmk_file,pml_file,ima_file ",  
               " WHERE pmk18 = 'Y' AND pmk25 = '1' AND pmk01 = pml01",
               " AND pml16 = '1' AND pml92 = 'N' AND pmk01= ? AND ima927='Y' AND ima01=pml04 "
   PREPARE b_prtemp1 FROM l_sql
               
   LET l_sql = " INSERT INTO pr_temp ",
               " SELECT 'Y','',pmk04,pmk01,pmk09,pml02,pml04,pml07,(pml20-pml21),pml33,pml041 FROM pmk_file,pml_file,pmh_file ",  
               " WHERE pmk18 = 'Y' AND pmk25 = '1' AND pmk01 = pml01",
               " AND pml16 = '1' AND pml92 = 'N' AND pmk01= ? AND pmh25='Y' AND pmh01=pml04 AND pmh02=pmk09 "     
               
   PREPARE b_prtemp2 FROM l_sql     
                 
  #LET l_sql = " SELECT pmk01,pmk09 FROM pmk_file,pml_file ",               #TQC-B20184  MARK
   LET l_sql = " SELECT DISTINCT pmk01,pmk09 FROM pmk_file,pml_file ",      #TQC-B20184  ADD 
               " WHERE ",p_wc,
               " AND pmk18 = 'Y' AND pmk25 = '1' AND pmk01 = pml01",
               " AND pml16 = '1' AND pml92 = 'N' "
   
   PREPARE b_pr1 FROM l_sql
   DECLARE b_cur1 CURSOR FOR b_pr1

   FOREACH  b_cur1 INTO l_pmk01,l_pmk09
       IF cl_null(l_pmk09) THEN 
          EXECUTE b_prtemp1 USING l_pmk01
       ELSE 
       	  EXECUTE b_prtemp2 USING l_pmk01
       END IF       
   END FOREACH 

   #No.FUN-A90009--end    
END FUNCTION


FUNCTION p460_b_fill(p_wc)
   DEFINE   p_wc     STRING
   DEFINE   li_cnt   LIKE type_file.num5

   LET g_sql = " SELECT 'N','',b04,'',b06,b10,'',b09,b07,SUM(b08) FROM pr_temp ",   #No.FUN-A90009
               " WHERE  b01 = 'Y'",
               " GROUP BY b04,b06,b10,b09,b07 "
               
   PREPARE b_pr2 FROM g_sql
   DECLARE b_curs2 CURSOR FOR b_pr2

   
   CALL g_pml.clear()
   LET li_cnt = 1
   LET g_cnt = 0

   FOREACH b_curs2 INTO g_pml[li_cnt].*
      SELECT pmc03 INTO g_pml[li_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_pml[li_cnt].pmk09
      SELECT ima021 INTO g_pml[li_cnt].ima021 FROM ima_file WHERE ima01 = g_pml[li_cnt].pml04 
      LET g_pml[li_cnt].wpc10=(g_today+g_pml[li_cnt].pml33)/2     #No.FUN-A90009
      LET li_cnt = li_cnt + 1
   END FOREACH
   LET g_cnt = li_cnt-1
   DISPLAY g_cnt TO FORMONLY.cn
   CALL g_pml.deleteElement(li_cnt)
   IF g_cnt = 0 THEN 
      CALL cl_err('','aco-058',0) 
      RETURN
   END IF
END FUNCTION


FUNCTION p460_pr_d()
 DEFINE  l_cn    LIKE  type_file.num5
 DEFINE  l_cnt   LIKE  type_file.num5
 DEFINE  l_count LIKE  type_file.num5
 DEFINE  l_sum   LIKE  pml_file.pml20
 DEFINE  i       LIKE  type_file.num5
    IF g_cnt = 0 THEN
       RETURN
    END IF
   IF g_ac = 0 THEN        
      CALL cl_err('','apm-140',0)
   END IF
   OPEN WINDOW p460_w1 WITH FORM "apm/42f/apmp460_1"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_locale("apmp460_1")
   
   LET g_sql = " SELECT b01,b03,b02,b04,'',b05,b06,b10,'',b09,b07,b08 FROM pr_temp ",
               " WHERE 1=1"
   IF NOT cl_null(g_pml[g_ac].pmk09) THEN
      LET g_sql = g_sql," AND b04 ='",g_pml[g_ac].pmk09,"'" 
   ELSE
      LET g_sql = g_sql," AND b04 IS NULL "
   END IF
   IF NOT cl_null(g_pml[g_ac].pml04) THEN
      LET g_sql = g_sql," AND b06 ='",g_pml[g_ac].pml04,"' " 
   ELSE
      LET g_sql = g_sql," AND b06 IS NULL "
   END IF      
   IF NOT cl_null(g_pml[g_ac].pmL07) THEN
      LET g_sql = g_sql," AND b07 = '",g_pml[g_ac].pml07,"' "
   ELSE
      LET g_sql = g_sql," AND b07 IS NULL "
   END IF
   IF NOT cl_null(g_pml[g_ac].pml33) THEN
      LET g_sql = g_sql," AND b09 ='",g_pml[g_ac].pml33,"' " 
   ELSE
      LET g_sql = g_sql," AND b09 IS NULL " 
   END IF     
   IF NOT cl_null(g_pml[g_ac].pml041) THEN
      LET g_sql = g_sql," AND b10 ='",g_pml[g_ac].pml041,"' " 
   ELSE
      LET g_sql = g_sql," AND b10 IS  NULL "
   END IF       
 
   PREPARE b_pr3 FROM g_sql
   DECLARE b_curs3 CURSOR FOR b_pr3

   
   CALL g_pmk.clear()
   LET l_count = 1
   FOREACH b_curs3 INTO g_pmk[l_count].*
      LET g_pmk[l_count].pmc03 = g_pml[g_ac].pmc03
      LET g_pmk[l_count].ima021 = g_pml[g_ac].ima021
      
      LET l_count = l_count + 1
   END FOREACH
   LET g_count = l_count-1
   DISPLAY g_count TO FORMONLY.cn1
   CALL g_pmk.deleteElement(l_count)
 
   INPUT ARRAY g_pmk WITHOUT DEFAULTS FROM s_pmk.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)   
       BEFORE ROW
            LET l_cn = ARR_CURR()         
        ON CHANGE c
           LET l_sum = g_pml[g_ac].pml20
           IF g_pmk[l_cn].c = 'N'  THEN
              UPDATE pr_temp SET b01 = 'N' 
               WHERE b03 = g_pmk[l_cn].pmk01 
                 AND b05 = g_pmk[l_cn].pml02 
              LET l_sum = l_sum - g_pmk[l_cn].pml20
           ELSE
              UPDATE pr_temp SET b01 = 'Y' 
               WHERE b03 = g_pmk[l_cn].pmk01 
                 AND b05 = g_pmk[l_cn].pml02 
              LET l_sum = l_sum + g_pmk[l_cn].pml20 
           END IF

           LET g_pml[g_ac].pml20 = l_sum
            
   END INPUT  
   CLOSE WINDOW p460_w1
END FUNCTION

FUNCTION p460_e_pur()
 DEFINE  i          LIKE  type_file.num10   
 DEFINE  l_wpc01    LIKE  wpc_file.wpc01                                                                                              
 DEFINE  n_wpc01    LIKE  wpc_file.wpc01                                                                                              
 DEFINE  s_wpc01    LIKE  type_file.num5                                                                                              
 DEFINE  l_month    LIKE  type_file.chr3                                                                                              
 DEFINE  l_day      LIKE  type_file.chr3    
 DEFINE  l_b03      LIKE  pmk_file.pmk01
 DEFINE  l_b05      LIKE  pml_file.pml02 
 DEFINE  l_sum      LIKE  type_file.num10
 DEFINE  l_n        LIKE  type_file.num5
 DEFINE  l_sql      STRING
 DEFINE  l_c05      LIKE  pmk_file.pmk09
 DEFINE  l_a        LIKE  type_file.num5   #No.FUN-A90009
 DEFINE  l_success  LIKE  type_file.chr1   #No.FUN-A90009
    IF g_cnt = 0 THEN
       RETURN
    END IF
    IF NOT cl_confirm('apm-135') THEN        
       RETURN 
    END IF
    LET g_success = 'Y'
    BEGIN WORK
    CALL s_showmsg_init()
    LET l_sum = 0
    LET l_success='Y' #No.FUN-A90009
    FOR i=1 TO g_cnt
      IF g_pml[i].sel = 'Y' THEN
         INITIALIZE g_wpc.* TO NULL
         LET l_n = 0 
 
            LET l_month = "0"||MONTH(g_today)                                                                                            
            LET l_month = l_month[LENGTH(l_month)-1,LENGTH(l_month)]                                                                     
            LET l_day = "0"||DAY(g_today)                                                                                                
            LET l_day = l_day[LENGTH(l_day)-1,LENGTH(l_day)]                                                                             
            LET l_wpc01 = "P"||YEAR(g_today)||l_month||l_day                                                                             
            SELECT MAX(wpc01) INTO n_wpc01 FROM wpc_file                                                                                 
            WHERE wpc01 LIKE l_wpc01||'%'                                                                                               
            IF cl_null(n_wpc01) THEN                                                                                                     
               LET g_wpc.wpc01 = "0001"                                                                                                   
            ELSE                                                                                                                         
               LET s_wpc01 = n_wpc01[LENGTH(l_wpc01)+3,LENGTH(l_wpc01)+4]+1                                                              
               LET g_wpc.wpc01 = "000"||s_wpc01                                                                                          
               LET g_wpc.wpc01 = g_wpc.wpc01[LENGTH(g_wpc.wpc01)-3,LENGTH(g_wpc.wpc01)]                                                  
            END IF                                                                                                                       
            LET g_wpc.wpc01 = l_wpc01 CLIPPED,g_wpc.wpc01                                                                                
            LET g_wpc.wpc02 = '1'                      
            LET g_wpc.wpc04 = g_pml[i].pml33
            LET g_wpc.wpc05 = g_pml[i].pml04
            LET g_wpc.wpc06 = g_pml[i].pml041
            LET g_wpc.wpc07 = g_pml[i].pml07
            LET g_wpc.wpc08 = g_pml[i].pml20
            LET g_wpc.wpc10 = g_pml[i].wpc10 #No.FUN-A90009
            LET g_wpc.wpc11=g_plant #No.FUN-A90009
            IF cl_null(g_wpc.wpc08) THEN
               LET g_wpc.wpc08 = 0
            END IF            
            LET g_wpc.wpc09 = 'N'                    
         
         IF cl_null(g_pml[i].pmk09) THEN
           LET l_sql = " SELECT c05 FROM cus_temp WHERE 1=1 "
           IF NOT cl_null(g_pml[i].pml04) THEN
              LET l_sql = l_sql," AND c01 ='",g_pml[i].pml04,"' " 
           ELSE
              LET l_sql = l_sql," AND c01 IS NULL " 
           END IF      
           IF NOT cl_null(g_pml[i].pmL07) THEN
              LET l_sql = l_sql," AND c04 = '",g_pml[i].pml07,"' "
           ELSE
              LET l_sql = l_sql," AND c04 IS NULL " 
           END IF
           IF NOT cl_null(g_pml[i].pml33) THEN
              LET l_sql = l_sql," AND c03 ='",g_pml[i].pml33,"' " 
           ELSE
              LET l_sql = l_sql," AND c03 IS NULL "
           END IF     
           IF NOT cl_null(g_pml[i].pml041) THEN
              LET l_sql = l_sql," AND c02 ='",g_pml[i].pml041,"' " 
           ELSE
              LET l_sql = l_sql," AND c02 IS NULL " 
           END IF 
           PREPARE b_pr5 FROM l_sql
           DECLARE b_curs5 CURSOR FOR b_pr5 
           FOREACH b_curs5 INTO l_c05

              LET g_wpc.wpc03 =  l_c05
              INSERT INTO wpc_file VALUES(g_wpc.*)                                                                                         
              IF STATUS OR SQLCA.SQLCODE THEN                                                                                              
                 CALL s_errmsg('','','',SQLCA.sqlcode,1)                                                                                   
                 LET g_success = 'N'   
              ELSE
                 CALL sendmail()                                                                                                       
              END IF                             
             LET l_n = l_n+1   
           END FOREACH  
         END IF  
         IF l_n = 0 THEN 
       
            LET g_wpc.wpc03 = g_pml[i].pmk09 
            #No.FUN-A90009--begin
            #IF cl_null(g_wpc.wpc03) THEN
            #   LET g_wpc.wpc03 = ' '  
            #END IF
            IF NOT cl_null(g_wpc.wpc03) THEN 
               INSERT INTO wpc_file VALUES(g_wpc.*)                                                                                         
               IF STATUS OR SQLCA.SQLCODE THEN                                                                                              
                  CALL s_errmsg('','','',SQLCA.sqlcode,1)                                                                                   
                  LET l_success = 'N'  
               ELSE
                   CALL sendmail()                                                                                                         
               END IF      
            ELSE 
            	 SELECT COUNT(*) INTO l_a FROM pmh_file WHERE pmh01=g_pml[i].pml04 AND pmh25='Y'
            	 IF l_a=0 THEN 
            	    CALL s_errmsg('pml04',g_pml[i].pml04,'','apm-320',1)
                  LET l_success='N'
                  CONTINUE FOR
               ELSE 
               	  DECLARE b_curs6 CURSOR FOR SELECT pmh02 FROM pmh_file WHERE pmh01=g_pml[i].pml04 AND pmh25='Y'
               	  FOREACH b_curs6 INTO g_wpc.wpc03
               	     INSERT INTO wpc_file VALUES(g_wpc.*)                                                                                         
                     IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN                                                                                              
                        CALL s_errmsg('','','',SQLCA.sqlcode,1)                                                                                   
                        LET l_success = 'N'  
                        CONTINUE FOREACH 
                     ELSE
                        CALL sendmail()                                                                                                         
                     END IF      
               	  END FOREACH 
            	 END IF 
            END IF    
            #No.FUN-A90009--end                              
         END IF  
           #No.FUN-A90009--begin
           IF l_success='N' THEN 
              CONTINUE FOR 
           END IF 
           #No.FUN-A90009--end 
           LET g_sql = " SELECT b03,b05 FROM pr_temp ",
                        " WHERE b01 = 'Y' "
           IF NOT cl_null(g_pml[i].pmk09) THEN
              LET g_sql = g_sql," AND b04 ='",g_pml[i].pmk09,"'" 
           ELSE
              LET g_sql = g_sql," AND b04 IS NULL " 
           END IF
           IF NOT cl_null(g_pml[i].pml04) THEN
              LET g_sql = g_sql," AND b06 ='",g_pml[i].pml04,"' " 
           ELSE
              LET g_sql = g_sql," AND b06 IS NULL "
           END IF      
           IF NOT cl_null(g_pml[i].pmL07) THEN
              LET g_sql = g_sql," AND b07 = '",g_pml[i].pml07,"' "
           ELSE
              LET g_sql = g_sql," AND b07 IS NULL " 
           END IF
           IF NOT cl_null(g_pml[i].pml33) THEN
              LET g_sql = g_sql," AND b09 ='",g_pml[i].pml33,"' " 
           ELSE
              LET g_sql = g_sql," AND b09 IS NULL "
           END IF     
           IF NOT cl_null(g_pml[i].pml041) THEN
              LET g_sql = g_sql," AND b10 ='",g_pml[i].pml041,"' " 
           ELSE
              LET g_sql = g_sql," AND b10 IS NULL "
           END IF       
 
           PREPARE b_pr4 FROM g_sql
           DECLARE b_curs4 CURSOR FOR b_pr4
           
           FOREACH b_curs4 INTO l_b03,l_b05
             UPDATE pml_file SET pml92 = 'Y',
                                 pml93 = g_wpc.wpc01
              WHERE pml01 = l_b03 AND pml02 = l_b05
            
           END FOREACH
           LET l_sum = l_sum+1
      END IF    
    END FOR
   
    IF g_success = 'N' THEN
       CALL s_showmsg()
       ROLLBACK WORK
    ELSE
       COMMIT WORK
       CALL cl_err(l_sum,'apm-137',1) 
       CALL create_temp()
       CALL ins_pr_temp(g_wc) 
       CALL p460_b_fill(g_wc)
    END IF   
END FUNCTION

FUNCTION p460_mul()
  DEFINE   l_sql           STRING   
  DEFINE   l_cn            LIKE   type_file.num5
  DEFINE   l_allow_insert  LIKE   type_file.num5
  DEFINE   l_allow_delete  LIKE   type_file.num5   
  DEFINE   l_count         LIKE   type_file.num5
  DEFINE   l_c            LIKE   type_file.num5
  
    IF g_cnt = 0 THEN
       RETURN
    END IF  
   IF g_ac = 0 THEN        
      CALL cl_err('','apm-140',0)
   END IF    
    IF g_pml[g_ac].sel <> 'Y' THEN
       CALL cl_err('','apm-138',1)
       RETURN
    END IF 
    IF NOT cl_null(g_pml[g_ac].pmk09) THEN
       CALL cl_err('','apm-139',1)
       RETURN
    END IF
    CALL g_pml2.clear()
    LET l_c = 1
    LET l_sql = " SELECT c05 FROM cus_temp WHERE 1=1 "
    IF NOT  cl_null(g_pml[g_ac].pml04) THEN 
       LET l_sql = l_sql," AND c01 = '",g_pml[g_ac].pml04,"'"
    ELSE
    	 LET  l_sql = l_sql," AND c01 IS NULL "  
    END IF    
    IF NOT  cl_null(g_pml[g_ac].pml041) THEN 
       LET l_sql = l_sql," AND c02 = '",g_pml[g_ac].pml041,"'"
    ELSE
    	 LET  l_sql = l_sql," AND c02 IS NULL "         
    END IF
    IF NOT  cl_null(g_pml[g_ac].pml33) THEN 
       LET l_sql = l_sql," AND c03 = '",g_pml[g_ac].pml33,"'"
    ELSE
    	 LET  l_sql = l_sql," AND c03 IS NULL "         
    END IF
    IF NOT  cl_null(g_pml[g_ac].pml07) THEN 
       LET l_sql = l_sql," AND c04 = '",g_pml[g_ac].pml07,"'"
    ELSE
    	 LET  l_sql = l_sql," AND c04 IS NULL "         
    END IF       
    PREPARE cus_pre  FROM l_sql
    DECLARE cus_d CURSOR FOR cus_pre
    
    FOREACH cus_d INTO g_pml2[l_c].pmk09
       SELECT pmc03 INTO g_pml2[l_c].pmc03 FROM pmc_file
        WHERE pmc01 = g_pml2[l_c].pmk09
        LET l_c=l_c+1
    END FOREACH
    LET g_rec_b1 = l_c-1
    CALL g_pml2.deleteElement(l_c)
    
   
    OPEN WINDOW p460_w2 WITH FORM "apm/42f/apmp460_2"
      ATTRIBUTE(STYLE=g_win_style)
    CALL cl_ui_locale("apmp460_2") 
    DISPLAY  g_pml[g_ac].pml04  TO FORMONLY.pml04_2
    DISPLAY  g_pml[g_ac].pml041 TO FORMONLY.pml041_2
    DISPLAY  g_pml[g_ac].pml33 TO FORMONLY.pml33_2
    DISPLAY  g_pml[g_ac].pml07  TO FORMONLY.pml07_2

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")   
    INPUT ARRAY g_pml2 WITHOUT DEFAULTS FROM s_pml2.*
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
        BEFORE ROW
             LET l_cn = ARR_CURR()    
             LET  g_pmk09_t = g_pml2[l_cn].pmk09 
        AFTER FIELD pmk09_2
             IF NOT cl_null(g_pml2[l_cn].pmk09) THEN
                CALL p460_pmk092(g_pml2[l_cn].pmk09)
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pml2[l_cn].pmk09,g_errno,0)
                  LET g_pml2[l_cn].pmk09  = g_pmk09_t
                  DISPLAY g_pml2[l_cn].pmk09 TO pmk09_2
                  NEXT FIELD pmk09_2                   
                END IF
              IF g_pml2[l_cn].pmk09 <> g_pmk09_t THEN
                LET l_count = 0
                LET l_sql = " SELECT COUNT(*) FROM cus_temp WHERE c05 = '",g_pml2[l_cn].pmk09,"'"
                IF NOT  cl_null(g_pml[g_ac].pml04) THEN 
                    LET l_sql = l_sql," AND c01 = '",g_pml[g_ac].pml04,"'"
                ELSE
                	  LET l_sql = l_sql," AND c01 IS NULL "      
                END IF    
                IF NOT  cl_null(g_pml[g_ac].pml041) THEN 
                    LET l_sql = l_sql," AND c02 = '",g_pml[g_ac].pml041,"'"
                ELSE
                	  LET l_sql = l_sql," AND c02 IS NULL "                      
                END IF
                IF NOT  cl_null(g_pml[g_ac].pml33) THEN 
                    LET l_sql = l_sql," AND c03 = '",g_pml[g_ac].pml33,"'"
                ELSE
                	  LET l_sql = l_sql," AND c03 IS NULL "                      
                END IF
                IF NOT  cl_null(g_pml[g_ac].pml07) THEN 
                    LET l_sql = l_sql," AND c04 = '",g_pml[g_ac].pml07,"'"
                ELSE
                	  LET l_sql = l_sql," AND c04 IS NULL "                      
                END IF  
                  
                PREPARE pml_sel FROM l_sql    
                EXECUTE pml_sel INTO l_count
                IF l_count > 0 THEN
                   CALL cl_err('','aec-009',0)
                   NEXT FIELD  pmk09_2    
                END IF
              END IF               
                SELECT pmc03 INTO g_pml2[l_cn].pmc03 FROM pmc_file
                 WHERE pmc01 = g_pml2[l_cn].pmk09
                DISPLAY g_pml2[l_cn].pmc03 TO pmc03_2
             END IF    
            
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF

              LET l_sql = " DELETE FROM cus_temp WHERE c05 = '",g_pml2[l_cn].pmk09,"'"
              IF NOT  cl_null(g_pml[g_ac].pml04) THEN 
                  LET l_sql = l_sql," AND c01 = '",g_pml[g_ac].pml04,"'"
              ELSE
                	LET l_sql = l_sql," AND c01 IS NULL "                    
              END IF    
              IF NOT  cl_null(g_pml[g_ac].pml041) THEN 
                  LET l_sql = l_sql," AND c02 = '",g_pml[g_ac].pml041,"'"
              ELSE
                	LET l_sql = l_sql," AND c02 IS NULL "                          
              END IF
              IF NOT  cl_null(g_pml[g_ac].pml33) THEN 
                  LET l_sql = l_sql," AND c03 = '",g_pml[g_ac].pml33,"'"
              ELSE
                	LET l_sql = l_sql," AND c03 IS NULL "                          
              END IF
              IF NOT  cl_null(g_pml[g_ac].pml07) THEN 
                  LET l_sql = l_sql," AND c04 = '",g_pml[g_ac].pml07,"'"
              ELSE
                	LET l_sql = l_sql," AND c04 IS NULL "                          
              END IF    
              PREPARE pml_del FROM l_sql    
              EXECUTE pml_del                                      
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","cus_file",'','',SQLCA.sqlcode,"","",1)   
                 CANCEL DELETE
              ELSE
               	LET g_rec_b1=g_rec_b1-1
              END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pml2[l_cn].pmk09 = g_pmk09_t
              EXIT INPUT
           END IF

              LET l_sql = " UPDATE cus_temp SET  c05 = '",g_pml2[l_cn].pmk09,"' WHERE c05 = '",g_pmk09_t,"' "
              IF NOT  cl_null(g_pml[g_ac].pml04) THEN 
                  LET l_sql = l_sql," AND c01 = '",g_pml[g_ac].pml04,"'"
              ELSE
                	LET l_sql = l_sql," AND c01 IS NULL "                          
              END IF    
              IF NOT  cl_null(g_pml[g_ac].pml041) THEN 
                  LET l_sql = l_sql," AND c02 = '",g_pml[g_ac].pml041,"'"
              ELSE
                	LET l_sql = l_sql," AND c02 IS NULL "                          
              END IF
              IF NOT  cl_null(g_pml[g_ac].pml33) THEN 
                  LET l_sql = l_sql," AND c03 = '",g_pml[g_ac].pml33,"'"
              ELSE
                	LET l_sql = l_sql," AND c03 IS NULL "                          
              END IF
              IF NOT  cl_null(g_pml[g_ac].pml07) THEN 
                  LET l_sql = l_sql," AND c04 = '",g_pml[g_ac].pml07,"'"
              ELSE
                	LET l_sql = l_sql," AND c04 IS NULL "                          
              END IF    
              PREPARE pml_upd FROM l_sql    
              EXECUTE pml_upd               
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","cus_file",'','',SQLCA.sqlcode,"","",1)  
                 LET g_pml2[l_cn].pmk09 = g_pmk09_t
              ELSE
                 MESSAGE 'UPDATE O.K'
              END IF
                    
      
          
       AFTER INSERT 
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO cus_temp VALUES(g_pml[g_ac].pml04,g_pml[g_ac].pml041,g_pml[g_ac].pml33,g_pml[g_ac].pml07,
                                       g_pml2[l_cn].pmk09)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","cus_temp",'','',SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b1=g_rec_b1+1 
           END IF 
                         
      ON ACTION CONTROLP    
            CASE
               WHEN INFIELD(pmk09_2)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmk09"
                    LET g_qryparam.default1 = g_pml2[l_cn].pmk09
                    CALL cl_create_qry() RETURNING g_pml2[l_cn].pmk09
                    DISPLAY g_pml2[l_cn].pmk09 TO pmk09_2
                    SELECT pmc03 INTO g_pml2[l_cn].pmc03 FROM pmc_file
                     WHERE pmc01 = g_pml2[l_cn].pmk09
                    DISPLAY g_pml2[l_cn].pmc03 TO pmc03_2
                    NEXT FIELD pmk09_2
            END CASE                
      
         
    END INPUT  
    CLOSE WINDOW p460_w2    
END FUNCTION

#No.TQC-B30010   ---begin---
FUNCTION p460_pmk092(p_wpa01)
  DEFINE  p_wpa01   LIKE  wpa_file.wpa01
  DEFINE  l_wpa01   LIKE  wpa_file.wpa01
  DEFINE  l_wpa02   LIKE  wpa_file.wpa02
    LET g_errno = ' '
    SELECT DISTINCT wpa01,wpa02 INTO l_wpa01,l_wpa02 FROM wpa_file 
     WHERE wpa01 = p_wpa01 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-061'
                               LET l_wpa01 = NULL
                               LET l_wpa02 = NULL
         WHEN l_wpa02<>'Y'     LET g_errno = '9028'
                               LET l_wpa01 = NULL
                               LET l_wpa02 = NULL
         OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE     
END FUNCTION
#No.TQC-B30010   ---end---

FUNCTION sendmail()
  DEFINE  l_str      STRING
  DEFINE  l_sql      STRING
  DEFINE  l_pmd07    LIKE  pmd_file.pmd07
  DEFINE  l_pmd02    LIKE  pmd_file.pmd02
  DEFINE  l_cn       LIKE  type_file.num5
  DEFINE ls_temppath       STRING
  DEFINE ls_filename       STRING  
  
  WHENEVER ERROR CALL cl_err_msg_log
  LET ls_temppath = FGL_GETENV("TEMPDIR")
  LET ls_filename = ls_temppath.trim(),"/apmp460_" || FGL_GETPID() || ".htm"


  INITIALIZE g_xml.* TO NULL

  LET g_xml.subject = "鼎新電腦股份有份公司-採購需求發佈通知"  
  LET l_pmd07 = ''
  LET l_str = ''
  LET l_cn = 0 
  IF NOT cl_null(g_wpc.wpc03) THEN
#No.TQC-B20184   BEGIN 
#    SELECT pmd07,pmd02 INTO l_pmd07,l_pmd02  FROM pmd_file
#     WHERE pmd07 IS NOT NULL AND pmd08 = 'Y' AND pmd01 = g_wpc.wpc03 
#    IF NOT cl_null(l_pmd07) THEN 
#       LET l_str = l_pmd07,":",l_pmd02  CLIPPED
#    END IF
     LET l_sql = "SELECT pmd07,pmd02 FROM pmd_file WHERE pmd07 IS NOT NULL AND pmd08 = 'Y' AND pmd01 = '",g_wpc.wpc03,"'"
     PREPARE pmd_pr2 FROM l_sql
     DECLARE pmd_curs2 CURSOR FOR pmd_pr2
     FOREACH pmd_curs2 INTO l_pmd07,l_pmd02
        IF l_cn = 0 THEN
           LET l_str = l_pmd07,":",l_pmd02  CLIPPED
        ELSE
           LET l_str = l_str,";",l_pmd07,":",l_pmd02  CLIPPED
        END IF
        LET l_cn = l_cn + 1
     END FOREACH
#No.TQC-B20184   end

  #No.FUN-A90009--begin--mark    
  #ELSE
  #   LET l_sql = " SELECT pmd07,pmd02 FROM pmd_file,wpa_file WHERE pmd07 IS NOT NULL ",
  #               "    AND pmd08 = 'Y' AND pmd01 = wpa01 AND wpa02 ='Y' "
  #   PREPARE pmd_pr2 FROM l_sql
  #   DECLARE pmd_curs2 CURSOR FOR pmd_pr2  
  #   FOREACH pmd_curs2 INTO l_pmd07,l_pmd02              
  #      IF l_cn = 0 THEN
  #         LET l_str = l_pmd07,":",l_pmd02  CLIPPED
  #      ELSE    
  #         LET l_str = l_str,";",l_pmd07,":",l_pmd02  CLIPPED
  #      END IF
  #      LET l_cn = l_cn +1   
  #   END FOREACH
  #No.FUN-A90009--end 
  END IF
  LET g_xml.body      = ls_filename.trim()
  LET g_xml.sender    = "tiptop@dsc.com.tw:top30"
  LET g_xml.recipient = l_str.trim()
  LET g_channel = base.Channel.create()
  CALL g_channel.openFile( ls_filename CLIPPED, "a" )
  CALL g_channel.setDelimiter("")
  
  CALL p460_head()
  CALL p460_detail()
  CALL p460_tail()

  CALL g_channel.close()
 
  CALL cl_jmail()
 
  RUN "rm -f " || ls_filename
  
  RUN "rm -f " || FGL_GETPID() || ".xml"
  
END FUNCTION

FUNCTION p460_head()
   DEFINE l_codeset STRING
   DEFINE l_lang    STRING
   
   CASE g_lang
      WHEN '0'
         LET l_lang = "zh-tw"
      WHEN '2'
         LET l_lang = "zh-cn"
      OTHERWISE
         #LET l_codeset = ms_codeset
         LET l_lang = "en"
   END CASE
   LET l_codeset = "UTF-8"
 
   LET g_tmpstr ='<html><head>                                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<meta http-equiv="Content-Language" content="',l_lang,'">                  ' CALL g_channel.write(g_tmpstr.trimRight()) #No.FUN-740189
   LET g_tmpstr ='<meta http-equiv="Content-Type" content="text/html; charset=',l_codeset,'">' CALL g_channel.write(g_tmpstr.trimRight()) #No.FUN-740189
   LET g_tmpstr ='<title>',g_xml.subject CLIPPED,'</title>                                   ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<style><!--                                                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='div.Section1                                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      {page:Section1;}                                                     ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr =' p.MsoNormal                                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      {mso-style-parent:"";                                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      margin-bottom:.0001pt;                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      font-size:12.0pt;                                                    ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      font-family:新細明體;                                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      margin-left:0cm; margin-right:0cm; margin-top:0cm}                   ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='span.GramE                                                                 ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      {}  -->                                                              ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</style></head><body>                                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      <div class="Section1">                                               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      <p class="MsoNormal">                                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      <span style="COLOR: #000000; FONT-FAMILY: 新細明體; font-weight:700">' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      <font size="4"><i></i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='      ',g_xml.subject CLIPPED,'</font></span></p></div>                    ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<p class="MsoNormal">　</p>                                                ' CALL g_channel.write(g_tmpstr.trimRight())
 
END FUNCTION

FUNCTION p460_detail()
 
   DEFINE ls_zl15    STRING   
 
   LET g_tmpstr ='<table border="1" style="border-collapse: collapse" width="680" id="table2">               ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<tr><td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">需求單號</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())
 
   LET ls_zl15 = g_wpc.wpc01 CLIPPED
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',ls_zl15.trim(),'</font></td>         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">需求日期</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())
 
   LET ls_zl15 = g_wpc.wpc04 CLIPPED
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',ls_zl15.trim(),'</font></td>         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b><font color="#FFFF00" size="2">料件編號</font></b></td>' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',g_wpc.wpc05 CLIPPED,'</font></td>      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">品名規格</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())

   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',g_wpc.wpc06 CLIPPED,'</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">需求單位</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',g_wpc.wpc07 CLIPPED,'</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr><tr>                                                                                  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="100" bgcolor="#000080" align="center">                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><b>                                                       ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <font color="#FFFF00" size="2">需求數量</font></b></td>                                ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td><p style="line-height: 150%"><font size="2">',g_wpc.wpc08 CLIPPED,'</font></td> ' CALL g_channel.write(g_tmpstr.trimRight())

   LET g_tmpstr ='</tr></table><p class="MsoNormal"></p>                                                     ' CALL g_channel.write(g_tmpstr.trimRight())
 
END FUNCTION

FUNCTION p460_tail()
 
   DEFINE l_time      DATETIME YEAR TO SECOND
   DEFINE lc_zx02     LIKE zx_file.zx02
 
   LET g_tmpstr ='<p class="MsoNormal"> </p>                                                    ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<table border="1" style="border-collapse: collapse" width="680" id="table3">  ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<tr><td width="50%" bgcolor="#000080" align="center">                         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><font color="#FFFF00" size="2">              ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    寄發人員</font></td>                                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="50%" bgcolor="#000080" align="center">                         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <p style="line-height: 150%"><font color="#FFFF00" size="2">              ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    寄發時間</font></td>                                                      ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr>                                                                         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='<tr><td width="50%" align="center">                                           ' CALL g_channel.write(g_tmpstr.trimRight())
   SELECT zx02 INTO lc_zx02 FROM zx_file WHERE zx01=g_user
   LET g_tmpstr ='    <p style="line-height: 150%"><font size="2">',g_user CLIPPED,' / ',lc_zx02 CLIPPED,'</font></td>' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='    <td width="50%" align="center">                                           ' CALL g_channel.write(g_tmpstr.trimRight())
 
   LET l_time = CURRENT YEAR TO SECOND
 
   LET g_tmpstr ='    <p style="line-height: 150%"><font size="2">',l_time CLIPPED,'</font></td>' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</tr>                                                                         ' CALL g_channel.write(g_tmpstr.trimRight())
   LET g_tmpstr ='</table></body></html>                                                        ' CALL g_channel.write(g_tmpstr.trimRight())
 
END FUNCTION
# FUN-9A0065 
#No:FUN-A10034
