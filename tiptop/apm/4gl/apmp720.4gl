# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apmp720.4gl
# Descriptions...: 采購入庫核價批次更新作業
# Date & Author..: 08/02/26 By douzh
# Modify.........: No.FUN-940083 09/06/04 By douzh 新增采購入庫核價批次更新作業
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0068 09/10/25 By destiny
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD
                  wc             STRING,
                  b_date  LIKE type_file.dat,
                  e_date  LIKE type_file.dat 
                  END RECORD
DEFINE g_rec_b	  LIKE type_file.num10
DEFINE g_rvu   DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  sel      LIKE type_file.chr1,
                  rvu04    LIKE rvu_file.rvu04,
                  pmc03    LIKE pmc_file.pmc03,
                  rvu01    LIKE rvu_file.rvu01,
                  rvu03    LIKE rvu_file.rvu03,
                  rvu00    LIKE rvu_file.rvu00 
                 END RECORD
DEFINE  g_rvux  DYNAMIC ARRAY OF RECORD                                                 
                 sel       LIKE type_file.chr1 
                END RECORD
DEFINE  g_rvu_p  DYNAMIC ARRAY OF RECORD                                                 
                 sel       LIKE type_file.chr1
                END RECORD               
                                            
DEFINE 
       g_sql      STRING    
DEFINE g_cnt      LIKE type_file.num10
DEFINE g_i        LIKE type_file.num5
DEFINE l_ac       LIKE type_file.num5
DEFINE l_count    LIKE type_file.num10
DEFINE i          LIKE type_file.num5
DEFINE g_cnt1     LIKE type_file.num10
DEFINE l_flag     LIKE type_file.chr1   #No.FUN-9A0068   
MAIN
  DEFINE p_row,p_col    LIKE type_file.num5
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p720_w AT p_row,p_col
        WITH FORM "apm/42f/apmp720"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL p720_tm()
   CALL p720_menu()
   
   CLOSE WINDOW p720_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p720_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000  
 
   WHILE TRUE
      CALL p720_bp("G")
      CASE g_action_choice
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_rvu),'','')
            END IF
      END CASE
   END WHILE
 
 
END FUNCTION
 
FUNCTION p720_tm()
  DEFINE l_sql          STRING
  DEFINE l_where        STRING
  DEFINE l_module       LIKE type_file.chr4
 
    CALL cl_opmsg('p')
    CLEAR FORM
    CALL g_rvu.clear()
    INITIALIZE tm.* TO NULL            
 
    LET tm.b_date = g_today
    LET tm.e_date = g_today
 
    WHILE TRUE     #No.FUN-9A0068
    DISPLAY BY NAME tm.b_date,tm.e_date   
    CONSTRUCT BY NAME tm.wc ON pmi03,pmj03,pmj05,pmj09,pmi01
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
   
      ON ACTION controlp
          CASE
            WHEN INFIELD(pmi03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pmi03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmi03
               NEXT FIELD pmi03   
            WHEN INFIELD(pmj03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pmj03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmj03
               NEXT FIELD pmj03
            WHEN INFIELD(pmj05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pmj05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmj05
               NEXT FIELD pmj05               
            WHEN INFIELD(pmi01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pmi01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmi01
               NEXT FIELD pmi01 
                                                                                                   
             OTHERWISE EXIT CASE
          END CASE 

         ON ACTION locale
            CALL cl_show_fld_cont()    
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
   
         ON ACTION controlg      
            CALL cl_cmdask()    
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
   
         ON ACTION about       
            CALL cl_about()   
   
         ON ACTION help      
            CALL cl_show_help() 
   
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
   
         ON ACTION qbe_select
            CALL cl_qbe_select()
   
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmiuser', 'pmigrup') #FUN-980030
          IF g_action_choice = "locale" THEN
             LET g_action_choice = ""
             CALL cl_dynamic_locale()
          END IF
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p720_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.b_date,tm.e_date
          WITHOUT DEFAULTS
 
       BEFORE INPUT
 
       AFTER FIELD b_date
          IF cl_null(tm.b_date) THEN
             CALL cl_err('','aap-099',0) NEXT FIELD b_date
          END IF
          IF cl_null(tm.e_date) THEN
             LET tm.e_date = tm.b_date
             DISPLAY BY NAME tm.e_date
          END IF
 
       AFTER FIELD e_date
          IF cl_null(tm.e_date) THEN
             CALL cl_err('','aap-099',0) NEXT FIELD e_date
          END IF
          IF tm.e_date < tm.b_date THEN
             CALL cl_err('','aap-100',0) NEXT FIELD b_date
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()    # Command execution
 
       AFTER INPUT
          IF INT_FLAG THEN
             CONTINUE WHILE  
             EXIT INPUT 
          END IF
          EXIT WHILE 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()     
 
       ON ACTION help        
          CALL cl_show_help() 
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
    END INPUT
 
    IF INT_FLAG THEN 
        LET INT_FLAG = 0
        #RETURN           #No.FUN-9A0068
        CONTINUE WHILE    #No.FUN-9A0068
    END IF 
    END WHILE 
    CALL p720_ins_tmp()
    CALL p720_init_b()
    LET g_success = 'Y'   #No.FUN-9A0068 
    CALL p720_b()
    IF g_success = 'Y' THEN           #No.FUN-9A0068
    IF cl_confirm('apm-088') THEN
       CALL p720_process()     
       LET g_success = 'N'            #No.FUN-9A0068
    ELSE
       CALL p720_b()
    END IF
    END IF                #No.FUN-9A0068
    IF g_success = 'N' THEN           #No.FUN-9A0068
       CALL p720_tm()                 #No.FUN-9A0068
    END IF                            #No.FUN-9A0068
END FUNCTION
 
FUNCTION p720_b()
 
   IF g_rvu.getLength()=0 THEN
      LET g_action_choice=''
      RETURN
   END IF  
 
    INPUT ARRAY g_rvu WITHOUT DEFAULTS FROM s_rvu.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
       
      BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
       
       AFTER ROW
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
          EXIT INPUT
 
       ON ACTION select_all
          CALL p720_sel_all_1("Y")
 
       ON ACTION select_non
          CALL p720_sel_all_1("N")
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg
          CALL cl_cmdask() 
 
    END INPUT
 
    LET g_action_choice=''
    IF INT_FLAG THEN
       LET INT_FLAG=0
       LET g_success = 'N'  #No.FUN-9A0068
       RETURN
    ELSE                    #No.FUN-9A0068
    	 LET g_success = 'Y'  #No.FUN-9A0068
    END IF


END FUNCTION
 
FUNCTION p720_sel_all_1(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_rvu.getLength()
       LET g_rvu[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION p720_ins_tmp()
 
  DEFINE l_sql,l_where   STRING
  DEFINE l_pmi01  LIKE pmi_file.pmi01 
  DEFINE l_pmi03  LIKE pmi_file.pmi03 
  DEFINE l_pmi05  LIKE pmi_file.pmi05 
  DEFINE l_pmj02  LIKE pmj_file.pmj02
  DEFINE l_pmj03  LIKE pmj_file.pmj03 
  DEFINE l_pmj05  LIKE pmj_file.pmj05 
  DEFINE l_ima44  LIKE ima_file.ima44
  DEFINE l_pmj07  LIKE pmj_file.pmj07
  DEFINE l_pmj07t LIKE pmj_file.pmj07t
  DEFINE l_pmj09  LIKE pmj_file.pmj09
 
  CREATE TEMP TABLE p720_tmp( 
       pmi01    LIKE pmi_file.pmi01,
       pmi03    LIKE pmi_file.pmi03,
       pmi05    LIKE pmi_file.pmi05,
       pmj02    LIKE pmj_file.pmj02,
       pmj03    LIKE pmj_file.pmj03,
       pmj05    LIKE pmj_file.pmj05,
       ima44    LIKE ima_file.ima44,
       pmj07    LIKE pmj_file.pmj07,
       pmj07t   LIKE pmj_file.pmj07t,
       pmj09    LIKE pmj_file.pmj09)
 
    CALL g_rvu.clear()
 
    DELETE FROM p720_tmp
    LET l_sql="SELECT pmi01,pmi03,pmi05,pmj02,pmj03,pmj05,ima44,",
              "       pmj07,pmj07t,pmj09",
              "  FROM pmi_file,pmj_file,ima_file ",
              " WHERE pmi01 = pmj01",
              "   AND pmj03 = ima01",
              "   AND pmiconf = 'Y'",
              "   AND pmiacti = 'Y'",
              "   AND pmj02 = '1'",
              "   AND pmj09 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
              "   AND ",tm.wc 
           
    PREPARE p720_tmp_prepare FROM l_sql
    DECLARE p720_tmp_bc SCROLL CURSOR FOR p720_tmp_prepare
 
     FOREACH p720_tmp_bc INTO l_pmi01,l_pmi03,l_pmi05,l_pmj02,l_pmj03,l_pmj05,l_ima44,
                          l_pmj07,l_pmj07t,l_pmj09
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF 
        INSERT INTO p720_tmp VALUES (l_pmi01,l_pmi03,l_pmi05,l_pmj02,l_pmj03,l_pmj05,l_ima44,
                                     l_pmj07,l_pmj07t,l_pmj09)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","p720_tmp",l_pmi01,l_pmj03,SQLCA.sqlcode,"","ins p720_tmp:",1)
           EXIT FOREACH
        END IF
     END FOREACH
 
END FUNCTION
 
FUNCTION p720_init_b()
  DEFINE l_sql,l_where   STRING
 
    CALL g_rvu.clear()
    LET l_sql="SELECT distinct 'Y',rvu04,'',rvu01,rvu03,rvu00",        #No.FUN-9A0068
              "  FROM rvu_file,rvv_file,pmi_file,pmj_file,ima_file,rva_file ",
              " WHERE rva00 = '2'",
              "   AND rva01 = rvu02",
              "   AND rvu03 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"' ",
              "   AND rvu04 = pmi03",
              "   AND pmi01 = pmj01",
              "   AND rvv31 = pmj03",
              "   AND ima01 = pmj03",
              "   AND rvv86 = ima44",
              "   AND ",tm.wc 
           
   
    PREPARE p720_prepare FROM l_sql
    DECLARE p720_bc SCROLL CURSOR FOR p720_prepare
 
    LET g_cnt = 1
       FOREACH p720_bc INTO g_rvu[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         SELECT pmc03 INTO g_rvu[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_rvu[g_cnt].rvu04
         DISPLAY g_rvu[g_cnt].pmc03 TO FORMONLY.pmc03
         LET g_cnt=g_cnt+1
         IF g_cnt > g_max_rec THEN
            EXIT FOREACH 
         END IF    
       END FOREACH
    CALL g_rvu.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1         
 
END FUNCTION
 
FUNCTION p720_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice="detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvu TO s_rvu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION p720_process()
 
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_sql     STRING
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_rvv02   LIKE rvv_file.rvv02
   DEFINE l_rvv17   LIKE rvv_file.rvv17
   DEFINE l_rvv31   LIKE rvv_file.rvv31
   DEFINE l_rvv86   LIKE rvv_file.rvv86
   DEFINE l_rvv87   LIKE rvv_file.rvv87
   DEFINE l_pmi01   LIKE pmi_file.pmi01 
   DEFINE l_pmi03   LIKE pmi_file.pmi03 
   DEFINE l_pmi05   LIKE pmi_file.pmi05 
   DEFINE l_pmj02   LIKE pmj_file.pmj02
   DEFINE l_pmj03   LIKE pmj_file.pmj03 
   DEFINE l_pmj05   LIKE pmj_file.pmj05 
   DEFINE l_ima44   LIKE ima_file.ima44
   DEFINE l_pmj07   LIKE pmj_file.pmj07
   DEFINE l_pmj07t  LIKE pmj_file.pmj07t
   DEFINE l_pmj09   LIKE pmj_file.pmj09
   DEFINE l_rvv38   LIKE rvv_file.rvv38
   DEFINE l_rvv38t  LIKE rvv_file.rvv38t
   DEFINE l_rvv39   LIKE rvv_file.rvv39
   DEFINE l_rvv39t  LIKE rvv_file.rvv39t
   DEFINE l_curr    LIKE rvu_file.rvu113
   DEFINE l_rate    LIKE rvu_file.rvu114
   DEFINE l_pmh     RECORD LIKE pmh_file.*
 
 
   LET l_flag = 'N'
   FOR l_i = 1 TO g_rvu.getLength()    
      IF g_rvu[l_i].sel = 'N' THEN
         CONTINUE FOR
      END IF                                                                                   
      LET l_flag = 'Y'
   END FOR                                                                                                                  
 
   IF l_flag= 'N' THEN
      LET g_success = 'N'    #syc=----add---
      CALL cl_err('','aoo-096',1)
      RETURN
   END IF
    
   FOR l_i = 1 TO g_rvu.getLength()
       IF g_rvu[l_i].sel = 'Y' THEN
          LET l_sql="SELECT rvv02,rvv17,rvv31,rvv86,rvv87", 
                    "  FROM rvv_file ",
                    " WHERE rvv01= '",g_rvu[l_i].rvu01,"' "
          
          PREPARE p720_p_prepare FROM l_sql
          DECLARE p720_p_bc SCROLL CURSOR FOR p720_p_prepare
 
             FOREACH p720_p_bc INTO l_rvv02,l_rvv17,l_rvv31,
                                    l_rvv86,l_rvv87
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach:',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF 
                IF g_rvu[l_i].rvu00 ='1' THEN
                   SELECT rva113,rva114 INTO l_curr,l_rate 
                     FROM rva_file
#                   WHERE rva05 = g_rvu[l_i].rvu04    #No.FUN-9A0068
                    WHERE rva01 = g_rvu[l_i].rvu01    #No.FUN-9A0068
                ELSE 
                   IF g_rvu[l_i].rvu00 ='3' THEN
                      SELECT rvu113,rvu114 INTO l_curr,l_rate 
                        FROM rvu_file
                       WHERE rvu01 = g_rvu[l_i].rvu01
                   END IF
                END IF
                SELECT pmi01,pmi05,pmj02,pmj07,pmj07t 
                  INTO l_pmi01,l_pmi05,l_pmj02,l_pmj07,l_pmj07t
                  FROM p720_tmp
                 WHERE pmi03 = g_rvu[l_i].rvu04
                   AND pmj03 = l_rvv31
                   AND pmj05 = l_curr
                IF SQLCA.SQLCODE THEN   
                   CALL cl_err(l_rvv31,SQLCA.SQLCODE,1)
                   EXIT FOREACH
                ELSE
                   LET l_rvv38  = l_pmj07
                   LET l_rvv38t = l_pmj07t
                   IF l_pmi05 = 'Y' THEN  #分量計算
                      DECLARE pmr05_cur CURSOR FOR
                       SELECT pmr05,pmr05t #分量計價的單價
                         FROM pmr_file
                        WHERE pmr01 = l_pmi01
                          AND pmr02 = l_pmj02
                          AND l_rvv17 BETWEEN pmr03 AND pmr04
                          ORDER BY pmr05
                      FOREACH pmr05_cur INTO l_rvv38, l_rvv38t
                          IF NOT cl_null(l_rvv38) THEN
                              EXIT FOREACH
                          END IF
                      END FOREACH
                   END IF
                   IF cl_null(l_rvv38t) AND NOT cl_null(l_rvv38) THEN
                      IF NOT cl_null(l_rate) THEN
                         LET l_rvv38t = l_rvv38 * (1 +l_rate/100)
                         LET l_rvv38t = cl_digcut(l_rvv38t,g_azi03)
                      END IF
                   END IF
                   IF cl_null(l_rvv38) THEN LET l_rvv38 = 0 END IF
                   LET l_rvv39 = l_rvv87*l_rvv38
                   LET l_rvv39t= l_rvv87*l_rvv38t
                   UPDATE rvv_file SET rvv38  = l_rvv38,
                                       rvv38t = l_rvv38t,
                                       rvv39  = l_rvv39,
                                       rvv39t = l_rvv39t 
                                 WHERE rvv01  = g_rvu[l_i].rvu01
                                   AND rvv02  = l_rvv02
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","rvv_file",g_rvu[l_i].rvu01,"",SQLCA.sqlcode,"","update rvv_file",1)
                      EXIT FOREACH
                      LET l_flag = 'N'
                   ELSE
                      UPDATE pmh_file SET pmh12 = l_rvv38,
                                          pmh19 = l_rvv38t
                                    WHERE pmh01 = l_rvv31
                                      AND pmh02 = g_rvu[l_i].rvu04
                                      AND pmh13 = l_curr
                                      AND pmh05 = '0'
                                      AND pmhacti='Y'
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         CALL cl_err3("upd","pmh_file",g_rvu[l_i].rvu04,"",SQLCA.sqlcode,"","update pmh_file",1)
                         EXIT FOREACH
                         LET l_flag = 'N'
                      END IF
                   END IF
                END IF
             END FOREACH
          CALL g_rvu.deleteElement(g_cnt)
       END IF
   END FOR
 
   IF l_flag = 'Y' THEN
      CALL cl_err('','9062',0)
   END IF
 
END FUNCTION
