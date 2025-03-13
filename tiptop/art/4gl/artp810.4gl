# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artp810.4gl
# Descriptions...: 營運中心調撥批量處理 
# Date & Author..: No.FUN-C80072 12/08/27 by nanbing 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ruo   DYNAMIC ARRAY OF RECORD        #調撥單
               sel          LIKE type_file.chr1,   #選擇
               ruoplant     LIKE ruo_file.ruoplant,
               ruoplant_desc  LIKE azw_file.azw08,
               ruo07        LIKE ruo_file.ruo07,
               ruo01        LIKE ruo_file.ruo01,
               ruo02        LIKE ruo_file.ruo02,
               ruo03        LIKE ruo_file.ruo03,
               ruo04        LIKE ruo_file.ruo04,
               ruo05        LIKE ruo_file.ruo05,
               ruo06        LIKE ruo_file.ruo06,
               ruo08        LIKE ruo_file.ruo08,
               gen02        LIKE gen_file.gen02,
               ruo09        LIKE ruo_file.ruo09,              
               ruopos       LIKE ruo_file.ruopos,    
               ruoconf      LIKE ruo_file.ruoconf,
               ruo10        LIKE ruo_file.ruo10,
               ruo11        LIKE ruo_file.ruo11,
               ruo12        LIKE ruo_file.ruo12,
               ruo13        LIKE ruo_file.ruo13,
               ruoacti      LIKE ruo_file.ruoacti,
               ruocrat      LIKE ruo_file.ruocrat,
               ruouser      LIKE ruo_file.ruouser,
               ruogrup      LIKE ruo_file.ruogrup,
               ruodate      LIKE ruo_file.ruodate,
               ruomodu      LIKE ruo_file.ruomodu
               END RECORD
DEFINE g_ruo1   DYNAMIC ARRAY OF RECORD        #調撥單
               sel1         LIKE type_file.chr1,   #選擇
               ruoplant     LIKE ruo_file.ruoplant,
               ruoplant_desc  LIKE azw_file.azw08,
               ruo07        LIKE ruo_file.ruo07,
               ruo01        LIKE ruo_file.ruo01,
               ruo02        LIKE ruo_file.ruo02,
               ruo03        LIKE ruo_file.ruo03,
               ruo04        LIKE ruo_file.ruo04,
               ruo05        LIKE ruo_file.ruo05,
               ruo06        LIKE ruo_file.ruo06,
               ruo08        LIKE ruo_file.ruo08,
               gen02        LIKE gen_file.gen02,
               ruo09        LIKE ruo_file.ruo09,              
               ruopos       LIKE ruo_file.ruopos,    
               ruoconf      LIKE ruo_file.ruoconf,
               ruo10        LIKE ruo_file.ruo10,
               ruo11        LIKE ruo_file.ruo11,
               ruo12        LIKE ruo_file.ruo12,
               ruo13        LIKE ruo_file.ruo13,
               ruoacti      LIKE ruo_file.ruoacti,
               ruocrat      LIKE ruo_file.ruocrat,
               ruouser      LIKE ruo_file.ruouser,
               ruogrup      LIKE ruo_file.ruogrup,
               ruodate      LIKE ruo_file.ruodate,
               ruomodu      LIKE ruo_file.ruomodu
               END RECORD             
DEFINE g_rup   DYNAMIC ARRAY OF RECORD        
               rup02      LIKE rup_file.rup02,
               rup03      LIKE rup_file.rup03,
               ima02      LIKE ima_file.ima02,
               rup04      LIKE rup_file.rup04,
               rup06      LIKE rup_file.rup06,
               rup07      LIKE rup_file.rup07,
               rup08      LIKE rup_file.rup08,
               rup09      LIKE rup_file.rup09,
               rup10      LIKE rup_file.rup10,
               rup11      LIKE rup_file.rup11,
               rup12      LIKE rup_file.rup12,
               rup13      LIKE rup_file.rup13,
               rup14      LIKE rup_file.rup14,
               rup15      LIKE rup_file.rup15,
               rup16      LIKE rup_file.rup16,
               rup05      LIKE rup_file.rup05
               END RECORD
DEFINE g_wc,g_wc1,g_wc2,g_sql    STRING
DEFINE g_rec_b        LIKE type_file.num5    
DEFINE g_rec_b1       LIKE type_file.num5    
DEFINE g_rec_b2       LIKE type_file.num5
DEFINE l_ac,l_ac1,l_ac2     LIKE type_file.num5
DEFINE g_flag_b       LIKE type_file.num5    
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt          LIKE type_file.num5
DEFINE g_cnt1         LIKE type_file.num5
DEFINE g_chk_ruoplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_chk_auth1 STRING     
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_renew          LIKE type_file.num5 
DEFINE g_chk_rtz01   LIKE type_file.chr1
DEFINE g_rtz01       LIKE rtz_file.rtz01 
DEFINE g_rtz01_str   STRING 

MAIN
 
   OPTIONS                     
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p810_w AT p_row,p_col WITH FORM "art/42f/artp810"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("ruopos_1",FALSE) 
   CALL cl_set_comp_visible("ruopos_2",FALSE)
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
 
   CALL p810()
 
   CLOSE WINDOW p810_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN
 
FUNCTION p810()
 
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p810_q()
      END IF
      CALL p810_bp('G')

      IF INT_FLAG THEN EXIT WHILE END IF 
      CASE g_action_choice
         WHEN "detail"
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              IF g_flag_b = 1 THEN 
                 CALL p810_p1()  
                 
              ELSE 
                 CALL p810_p2()
                 
              END IF      
           END IF 

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p810_q()
            END IF 
         WHEN "out_confirm"      #
            LET g_renew = 0
            IF cl_chk_act_auth() THEN
               CALL p810_out_confirm()
               CALL p810_b_fill(g_wc)
            END IF
           
         WHEN "in_confirm" #整批確認
            LET g_renew = 0
            IF cl_chk_act_auth() THEN
               CALL p810_in_confirm()
               CALL p810_b1_fill(g_wc1)
            END IF            
         WHEN "select_all"   #全部選取
            CALL p810_sel_all('Y')
 
         WHEN "select_non"   #全部不選
            CALL p810_sel_all('N')
            
         #WHEN "select_all_1"   #全部選取
         #   CALL p810_sel_all_1('Y')

 
         #WHEN "select_non_1"   #全部不選
         #   CALL p810_sel_all_1('N')           

           
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
               IF g_flag_b = 1 THEN 
                  CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ruo),'','')
               ELSE 
                  CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ruo1),'','')
               END IF   
            END IF
         WHEN "controlg"
            CALL cl_cmdask()     
         WHEN "help"
            CALL cl_show_help()            
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

FUNCTION p810_p1()
    LET g_action_choice = " "
   # CALL cl_set_act_visible("accept,cancel", FALSE)
    IF g_rec_b <= 0 THEN 
       RETURN 
    END IF    
    INPUT ARRAY g_ruo WITHOUT DEFAULTS FROM s_ruo1.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
       BEFORE ROW
          IF g_renew THEN
             LET l_ac = ARR_CURR()
             IF l_ac = 0 THEN
                LET l_ac = 1
             END IF
          END IF
          CALL fgl_set_arr_curr(l_ac)
          LET g_renew = 1
          CALL cl_show_fld_cont()

         # LET g_ruo_t.* = g_ruo[l_ac].*
          IF g_rec_b > 0 THEN
             CALL p810_b2_fill(' 1=1',g_ruo[l_ac].ruoplant,g_ruo[l_ac].ruo01)
             DISPLAY g_rec_b2 TO FORMONLY.cn2
             DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b2)
             BEFORE DISPLAY
                EXIT DISPLAY
             END DISPLAY  
          END IF
 
       ON CHANGE sel
          IF cl_null(g_ruo[l_ac].sel) THEN 
             LET g_ruo[l_ac].sel = 'Y'
          END IF
       ON ACTION close
          LET g_action_choice ="exit"
          EXIT INPUT
       ON ACTION select_all   #全部選取
          CALL p810_sel_all('Y')
          CONTINUE INPUT
 
       ON ACTION select_non   #全部不選
          CALL p810_sel_all('N')
          CONTINUE INPUT
 
       ON ACTION exporttoexcel
          LET g_action_choice = "exporttoexcel"
          EXIT INPUT     
       ON ACTION help
          CALL cl_show_help()
          EXIT INPUT
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT INPUT
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION CANCEL
          LET INT_FLAG=FALSE
          CALL p810_sel_all('N')
          EXIT INPUT  
       ON ACTION about
          CALL cl_about()
    END INPUT
    #CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

FUNCTION p810_p2()
    LET g_action_choice = " "
   # CALL cl_set_act_visible("accept,cancel", FALSE)
    IF g_rec_b1 <= 0 THEN 
       RETURN 
    END IF    
    INPUT ARRAY g_ruo1 WITHOUT DEFAULTS FROM s_ruo2.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
       BEFORE ROW
          IF g_renew THEN
             LET l_ac1 = ARR_CURR()
             IF l_ac1 = 0 THEN
                LET l_ac1 = 1
             END IF
          END IF
          CALL fgl_set_arr_curr(l_ac1)
          LET g_renew = 1
          CALL cl_show_fld_cont()

         # LET g_ruo_t.* = g_ruo[l_ac].*
          IF g_rec_b1 > 0 THEN
             CALL p810_b2_fill(' 1=1',g_ruo1[l_ac1].ruoplant,g_ruo1[l_ac1].ruo01)
             DISPLAY g_rec_b2 TO FORMONLY.cn2
             DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b2)
             BEFORE DISPLAY
                EXIT DISPLAY
             END DISPLAY  
          END IF
 
       ON CHANGE sel1
          IF cl_null(g_ruo1[l_ac1].sel1) THEN 
             LET g_ruo1[l_ac1].sel1 = 'Y'
          END IF
       ON ACTION close
          LET g_action_choice ="exit"
          EXIT INPUT
       ON ACTION select_all_1   #全部選取
          CALL p810_sel_all_1('Y')
          CONTINUE INPUT
 
       ON ACTION select_non_1   #全部不選
          CALL p810_sel_all_1('N')
          CONTINUE INPUT
 
       ON ACTION exporttoexcel
          LET g_action_choice = "exporttoexcel"
          EXIT INPUT     
       ON ACTION help
          CALL cl_show_help()
          EXIT INPUT
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT INPUT
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION CANCEL
          LET INT_FLAG=FALSE
          CALL p810_sel_all_1('N')
          EXIT INPUT  
       ON ACTION about
          CALL cl_about()
    END INPUT
    #CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

 
FUNCTION p810_q()
 
   CALL p810_b_askkey()
 
END FUNCTION
 
FUNCTION p810_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE  tok            base.StringTokenizer   
DEFINE  l_sql       STRING 
DEFINE  l_n         LIKE type_file.num5  
   CLEAR FORM
   CALL g_ruo.clear()
   CALL g_rup.clear()
   LET g_rec_b = 0
   LET g_rec_b1 = 0
   LET g_rec_b2 = 0
   LET g_chk_ruoplant = TRUE 
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT g_wc ON ruoplant, ruo07,  ruo01,  ruo02,
                     ruo03,  ruo04,  ruo05,  ruo06,
                     ruo08,  ruo09,  ruoconf,
                     ruo10,  ruo11,  ruo12,  ruo13,
                     ruoacti,ruocrat,ruouser,ruogrup,
                     ruodate,ruomodu 
                FROM s_ruo1[1].ruoplant_1, s_ruo1[1].ruo07_1,  s_ruo1[1].ruo01_1,  s_ruo1[1].ruo02_1,
                     s_ruo1[1].ruo03_1,  s_ruo1[1].ruo04_1,  s_ruo1[1].ruo05_1,  s_ruo1[1].ruo06_1,
                     s_ruo1[1].ruo08_1,  s_ruo1[1].ruo09_1,  s_ruo1[1].ruoconf_1,                        
                     s_ruo1[1].ruo10_1,  s_ruo1[1].ruo11_1,  s_ruo1[1].ruo12_1,  s_ruo1[1].ruo13_1,
                     s_ruo1[1].ruoacti_1,s_ruo1[1].ruocrat_1,s_ruo1[1].ruouser_1,s_ruo1[1].ruogrup_1,
                     s_ruo1[1].ruodate_1,s_ruo1[1].ruomodu_1 
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         AFTER FIELD ruoplant_1
            LET g_chk_rtz01 = TRUE 
            LET g_rtz01_str = get_fldbuf(ruoplant_1)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_rtz01_str) AND g_rtz01_str <> "*" THEN
               LET g_chk_rtz01 = FALSE 
               LET tok = base.StringTokenizer.create(g_rtz01_str,"|") 
               LET g_rtz01 = ""
               WHILE tok.hasMoreTokens() 
                  LET g_rtz01 = tok.nextToken()
                  LET l_sql = " SELECT COUNT(*) FROM rtz_file",
                              " WHERE rtz01 ='",g_rtz01,"'",
                              " AND EXISTS(SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
                  PREPARE sel_num_pre FROM l_sql
                  EXECUTE sel_num_pre INTO l_n 
                  IF l_n > 0 THEN
                     IF g_chk_auth IS NULL THEN
                        LET g_chk_auth = "'",g_rtz01,"'"
                     ELSE
                        LET g_chk_auth = g_chk_auth,",'",g_rtz01,"'"
                     END IF 
                  ELSE
                     CONTINUE WHILE
                  END IF
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF
            END IF
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ruoplant_1)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rtz01"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruoplant_1
                   NEXT FIELD ruoplant_1
               WHEN INFIELD(ruo04_1)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rtz01"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo04_1
                   NEXT FIELD ruo04_1
 
               WHEN INFIELD(ruo05_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rtz01"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo05_1
                   NEXT FIELD ruo05_1
                   
               WHEN INFIELD(ruo06_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rtz01"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo06_1
                   NEXT FIELD ruo06_1
                   
               WHEN INFIELD(ruo08_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo08_1
                   NEXT FIELD ruo08_1
                   
               WHEN INFIELD(ruo11_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo11_1                
                   NEXT FIELD ruo11_1  
                   
               WHEN INFIELD(ruo13_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo13_1
                   NEXT FIELD ruo13_1  
                    
               WHEN INFIELD(ruouser_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruouser_1
                   NEXT FIELD ruouser_1 
                       
               WHEN INFIELD(ruogrup_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruogrup_1
                   NEXT FIELD ruogrup_1
              
               WHEN INFIELD(ruomodu_1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruomodu_1
                   NEXT FIELD ruomodu_1
     
               OTHERWISE EXIT CASE
            END CASE
 
      END CONSTRUCT
      CONSTRUCT g_wc1 ON ruoplant, ruo07,  ruo01,  ruo02,
                     ruo03,  ruo04,  ruo05,  ruo06,
                     ruo08,  ruo09,  ruoconf,
                     ruo10,  ruo11,  ruo12,  ruo13,
                     ruoacti,ruocrat,ruouser,ruogrup,
                     ruodate,ruomodu 
                FROM s_ruo2[1].ruoplant_2, s_ruo2[1].ruo07_2,  s_ruo2[1].ruo01_2,  s_ruo2[1].ruo02_2,
                     s_ruo2[1].ruo03_2,  s_ruo2[1].ruo04_2,  s_ruo2[1].ruo05_2,  s_ruo2[1].ruo06_2,
                     s_ruo2[1].ruo08_2,  s_ruo2[1].ruo09_2,  s_ruo2[1].ruoconf_2,                        
                     s_ruo2[1].ruo10_2,  s_ruo2[1].ruo11_2,  s_ruo2[1].ruo12_2,  s_ruo2[1].ruo13_2,
                     s_ruo2[1].ruoacti_2,s_ruo2[1].ruocrat_2,s_ruo2[1].ruouser_2,s_ruo2[1].ruogrup_2,
                     s_ruo2[1].ruodate_2,s_ruo2[1].ruomodu_2 
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         AFTER FIELD ruoplant_2
            LET g_chk_rtz01 = TRUE 
            LET g_rtz01_str = get_fldbuf(ruoplant_2)  
            LET g_chk_auth1 = '' 
            IF NOT cl_null(g_rtz01_str) AND g_rtz01_str <> "*" THEN
               LET g_chk_rtz01 = FALSE 
               LET tok = base.StringTokenizer.create(g_rtz01_str,"|") 
               LET g_rtz01 = ""
               WHILE tok.hasMoreTokens() 
                  LET g_rtz01 = tok.nextToken()
                  LET l_sql = " SELECT COUNT(*) FROM rtz_file",
                              " WHERE rtz01 ='",g_rtz01,"'",
                              " AND EXISTS(SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
                  PREPARE sel_num_pre1 FROM l_sql
                  EXECUTE sel_num_pre1 INTO l_n 
                  IF l_n > 0 THEN
                     IF g_chk_auth1 IS NULL THEN
                        LET g_chk_auth1 = "'",g_rtz01,"'"
                     ELSE
                        LET g_chk_auth1 = g_chk_auth1,",'",g_rtz01,"'"
                     END IF 
                  ELSE
                     CONTINUE WHILE
                  END IF
               END WHILE
               IF g_chk_auth1 IS NOT NULL THEN
                  LET g_chk_auth1 = "(",g_chk_auth1,")"
               END IF
            END IF
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ruoplant_2)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rtz01"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruoplant_2
                   NEXT FIELD ruoplant_2
               WHEN INFIELD(ruo04_2)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rtz01"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo04_2
                   NEXT FIELD ruo04_2
 
               WHEN INFIELD(ruo05_2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rtz01"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo05_2
                   NEXT FIELD ruo05_2
                   
               WHEN INFIELD(ruo06_2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_rtz01"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo06_2
                   NEXT FIELD ruo06_2
                   
               WHEN INFIELD(ruo08_2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo08_2
                   NEXT FIELD ruo08_2
                   
               WHEN INFIELD(ruo11_2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo11_2                
                   NEXT FIELD ruo11_2  
                   
               WHEN INFIELD(ruo13_2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruo13_2
                   NEXT FIELD ruo13_2  
                    
               WHEN INFIELD(ruouser_2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruouser_2
                   NEXT FIELD ruouser_2 
                       
               WHEN INFIELD(ruogrup_2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruogrup_2
                   NEXT FIELD ruogrup_2
              
               WHEN INFIELD(ruomodu_2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruomodu_2
                   NEXT FIELD ruomodu_2
     
               OTHERWISE EXIT CASE
            END CASE
 
      END CONSTRUCT
      CONSTRUCT g_wc2 ON rup02,    rup03,  rup04,  rup06,
                      rup07,    rup08,  rup09,  rup10,
                      rup11,    rup12,  rup13,  rup14,
                      rup15,    rup16,  rup05  
                 FROM s_rup[1].rup02,   s_rup[1].rup03,  s_rup[1].rup04,  s_rup[1].rup06,
                      s_rup[1].rup07,   s_rup[1].rup08,  s_rup[1].rup09,  s_rup[1].rup10,
                      s_rup[1].rup11,   s_rup[1].rup12,  s_rup[1].rup13,  s_rup[1].rup14, 
                      s_rup[1].rup15,   s_rup[1].rup16,  s_rup[1].rup05                     
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(rup03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup03
                 NEXT FIELD rup03
              WHEN INFIELD(rup04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup04
                 NEXT FIELD rup04
              WHEN INFIELD(rup07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup07
                 NEXT FIELD rup07
              WHEN INFIELD(rup09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_imd003"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = 'SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup09
                 NEXT FIELD rup09
              WHEN INFIELD(rup13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_imd003"  
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = 'SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rup13
                 NEXT FIELD rup13
              OTHERWISE
                 EXIT CASE
           END CASE
		
      END CONSTRUCT
      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
      ON ACTION qbe_save                        
         CALL cl_qbe_save()
   END DIALOG
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruouser', 'ruogrup')
   LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('ruouser', 'ruogrup')
   LET l_ac = 1 
   LET l_ac1 = 1
   IF cl_null(g_wc2) THEN LET g_wc2=" 1=1" END IF
   LET g_wc = g_wc CLIPPED," AND ",g_wc2 CLIPPED
   LET g_wc1 = g_wc1 CLIPPED," AND ",g_wc2 CLIPPED
   CALL p810_b_fill(g_wc)  
   CALL p810_b1_fill(g_wc1)  
END FUNCTION
 

 
FUNCTION p810_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_plant        LIKE rtz_file.rtz01
DEFINE l_sql          STRING 
    LET g_cnt = 1
    CALL g_ruo.clear()
    LET l_sql = " SELECT DISTINCT rtz01 FROM azw_file,rtz_file ",
                " WHERE azw01 = rtz01 ",
                "   AND EXISTS (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
    IF NOT cl_null(g_chk_auth) THEN    
       LET l_sql = l_sql," AND rtz01 IN ",g_chk_auth
    END IF  
    LET l_sql = l_sql,"  ORDER BY rtz01 "
    PREPARE sel_rtz01_pre1 FROM l_sql
    DECLARE sel_rtz01_cs1 CURSOR FOR sel_rtz01_pre1           
    FOREACH sel_rtz01_cs1 INTO l_plant
       IF STATUS THEN
          CALL cl_err('PLANT:',SQLCA.sqlcode,1)
          RETURN
       END IF 
       
       LET g_sql = "SELECT DISTINCT 'N',ruoplant,'',ruo07,ruo01,ruo02,ruo03,ruo04,ruo05,ruo06,ruo08,'',ruo09,ruopos,",
                   "       ruoconf,ruo10,ruo11,ruo12,ruo13,ruoacti,ruocrat,ruouser,ruogrup,ruodate,ruomodu        ",  
                   "  FROM ",cl_get_target_table(l_plant, 'ruo_file'),",",cl_get_target_table(l_plant, 'rup_file'),   
                   " WHERE ruo01=rup01 AND ruoplant=rupplant "," AND ruoplant='",l_plant CLIPPED,"'", 
                   "   AND ruoconf = '0' AND ruoplant = ruo04 ",
                   "   AND  ",p_wc   
       LET g_sql = g_sql,"  ORDER BY ruo01 "
       PREPARE p810_pb1 FROM g_sql
       DECLARE p810_cs1 CURSOR FOR p810_pb1
 

       MESSAGE "Searching!"
       FOREACH p810_cs1 INTO g_ruo[g_cnt].*  
          IF STATUS THEN 
             CALL cl_err('foreach p810_cs:',STATUS,1) 
             EXIT FOREACH
          END IF
          SELECT azw08 INTO g_ruo[g_cnt].ruoplant_desc
            FROM azw_file
           WHERE azw01= g_ruo[g_cnt].ruoplant
          SELECT gen02 INTO g_ruo[g_cnt].gen02
            FROM gen_file
           WHERE gen01 = g_ruo[g_cnt].ruo08
             AND genacti = 'Y'
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
    END FOREACH 
    CALL g_ruo.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION

FUNCTION p810_b1_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_plant        LIKE rtz_file.rtz01
DEFINE l_sql          STRING 
    LET g_cnt = 1
    CALL g_ruo1.clear()
    LET l_sql = " SELECT DISTINCT rtz01 FROM azw_file,rtz_file ",
                " WHERE azw01 = rtz01 ",
                "   AND EXISTS (SELECT 1 FROM zxy_file WHERE zxy03 = rtz_file.rtz01 AND zxy01 = '",g_user,"')"
    IF NOT cl_null(g_chk_auth1) THEN    
       LET l_sql = l_sql," AND rtz01 IN ",g_chk_auth1
    END IF  
    LET l_sql = l_sql,"  ORDER BY rtz01 "
    PREPARE sel_rtz01_pre FROM l_sql
    DECLARE sel_rtz01_cs CURSOR FOR sel_rtz01_pre           
    FOREACH sel_rtz01_cs INTO l_plant
       IF STATUS THEN
          CALL cl_err('PLANT:',SQLCA.sqlcode,1)
          RETURN
       END IF 
       
       LET g_sql = "SELECT DISTINCT 'N',ruoplant,'',ruo07,ruo01,ruo02,ruo03,ruo04,ruo05,ruo06,ruo08,'',ruo09,ruopos,",
                   "       ruoconf,ruo10,ruo11,ruo12,ruo13,ruoacti,ruocrat,ruouser,ruogrup,ruodate,ruomodu        ",  
                   "  FROM ",cl_get_target_table(l_plant, 'ruo_file'),",",cl_get_target_table(l_plant, 'rup_file'),   
                   " WHERE ruo01=rup01 AND ruoplant=rupplant "," AND ruoplant='",l_plant CLIPPED,"'", 
                   "   AND ruoconf = '1' AND ruoplant = ruo05",
                   "   AND  ",p_wc   
       LET g_sql = g_sql,"  ORDER BY ruo01 "
       PREPARE p810_pb FROM g_sql
       DECLARE p810_cs CURSOR FOR p810_pb
 

       MESSAGE "Searching!"
       FOREACH p810_cs INTO g_ruo1[g_cnt].*  
          IF STATUS THEN 
             CALL cl_err('foreach p810_cs:',STATUS,1) 
             EXIT FOREACH
          END IF
          SELECT azw08 INTO g_ruo1[g_cnt].ruoplant_desc
            FROM azw_file
           WHERE azw01= g_ruo1[g_cnt].ruoplant
          SELECT gen02 INTO g_ruo1[g_cnt].gen02
            FROM gen_file
           WHERE gen01 = g_ruo1[g_cnt].ruo08
             AND genacti = 'Y'
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
    END FOREACH 
    CALL g_ruo1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p810_b2_fill(p_wc2,l_plant,l_ruo01)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE rtz_file.rtz03
DEFINE l_plant LIKE ruo_file.ruoplant
DEFINE l_ruo01 LIKE ruo_file.ruo01

    LET g_sql = "SELECT DISTINCT rup02,rup03,'',rup04,rup06,rup07,rup08,rup09,rup10,rup11, ",
                "       rup12,rup13,rup14,rup15,rup16,rup05   ",
                "  FROM ",cl_get_target_table(l_plant, 'rup_file'), 
                " WHERE rup01 = '",l_ruo01,"'",
                "   AND rupplant = '",l_plant,"'",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
    CALL cl_parse_qry_sql(g_sql, l_plant) RETURNING g_sql           
    PREPARE p810_pb2 FROM g_sql
    DECLARE p810_cs2 CURSOR FOR p810_pb2
    
    LET g_sql = "SELECT ima02 FROM ",cl_get_target_table(l_plant, 'ima_file'), 
                " WHERE ima01 = ? AND imaacti = 'Y'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             
    CALL cl_parse_qry_sql(g_sql, l_plant) RETURNING g_sql  
    PREPARE p810_ima021_cs FROM g_sql
    
    CALL g_rup.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH p810_cs2 INTO g_rup[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach p810_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF       
        EXECUTE p810_ima021_cs USING g_rup[g_cnt].rup03
                                INTO g_rup[g_cnt].ima02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rup.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p810_bp(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1 
   IF p_cmd <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      
      DISPLAY ARRAY g_ruo TO s_ruo1.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            IF l_ac <> 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            DISPLAY g_rec_b TO FORMONLY.cnt
            IF g_rec_b = 0 THEN 
               CALL g_rup.clear()
            END IF    
            LET g_flag_b = 1
         BEFORE ROW
            LET l_ac = ARR_CURR()
            IF g_rec_b != 0 THEN
               DISPLAY l_ac TO FORMONLY.idx
               CALL p810_b2_fill(g_wc2,g_ruo[l_ac].ruoplant,g_ruo[l_ac].ruo01)
               DISPLAY g_rec_b2 TO FORMONLY.cn2
               DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b2)
                 BEFORE DISPLAY
                   EXIT DISPLAY
               END DISPLAY
            END IF
            CALL cl_show_fld_cont()
         
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = 1
            LET l_ac = 1
            EXIT DIALOG   
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = 1
            LET l_ac = ARR_CURR()
            EXIT DIALOG 
         ON ACTION out_confirm      #
            LET g_action_choice="out_confirm"
            EXIT DIALOG
         ON ACTION select_all   #全部選取
            LET g_action_choice="select_all"
            EXIT DIALOG
 
         ON ACTION select_non   #全部不選
            LET g_action_choice="select_non"
            EXIT DIALOG   
      END DISPLAY
      DISPLAY ARRAY g_ruo1 TO s_ruo2.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            IF l_ac1 <> 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
            DISPLAY g_rec_b1 TO FORMONLY.cnt
            IF g_rec_b1 = 0 THEN 
               CALL g_rup.clear()
            END IF 
            LET g_flag_b = 2   
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            IF g_rec_b1 != 0 THEN
               DISPLAY l_ac1 TO FORMONLY.idx
               CALL p810_b2_fill(g_wc2,g_ruo1[l_ac1].ruoplant,g_ruo1[l_ac1].ruo01)
               DISPLAY g_rec_b2 TO FORMONLY.cn2
               DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b2)
                 BEFORE DISPLAY
                   EXIT DISPLAY
               END DISPLAY
            END IF
            CALL cl_show_fld_cont()
         
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = 2
            LET l_ac1 = 1
            EXIT DIALOG   
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = 2
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG  
         ON ACTION in_confirm #整批確認
            LET g_action_choice="in_confirm"
            EXIT DIALOG  
         ON ACTION select_all_1   #全部選取
            #LET g_action_choice="select_all_1"
            #EXIT DIALOG
            CALL p810_sel_all_1('Y')
            NEXT FIELD sel1
         ON ACTION select_non_1   #全部不選
            #LET g_action_choice="select_non_1"
            #EXIT DIALOG   
            CALL p810_sel_all_1('N')
            NEXT FIELD sel1
      END DISPLAY   
      DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b2)
 
         BEFORE DISPLAY
            IF l_ac2 <> 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
            IF cl_null(p_cmd) THEN
              EXIT DIALOG
            END IF
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
 
      END DISPLAY

      BEFORE DIALOG 
         CASE g_flag_b
            WHEN '1' 
               NEXT FIELD sel
            WHEN '2'
               NEXT FIELD sel1
            OTHERWISE 
               NEXT FIELD sel
         END CASE 
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
      ON ACTION close
         LET g_action_choice ="exit"
         EXIT DIALOG  
      ON ACTION exit 
         LET g_action_choice="exit"
         EXIT DIALOG
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p810_out_confirm()
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_ruo         RECORD LIKE ruo_file.* 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b
    IF g_ruo[l_i].sel = 'Y' THEN
       LET l_n = l_n + 1
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('axm-596') THEN
      RETURN
    END IF
  ELSE
     CALL cl_err('',-400,0)
     RETURN
  END IF
  CALL s_showmsg_init()
  FOR l_i = 1 TO g_rec_b
     IF g_ruo[l_i].sel = 'Y' THEN
        CALL p810_out_yes(g_ruo[l_i].ruo01,g_ruo[l_i].ruoplant,'Y')
     END IF
  END FOR
  CALL s_showmsg()
END FUNCTION
FUNCTION p810_in_confirm()
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_ruo         RECORD LIKE ruo_file.* 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_ruo1[l_i].sel1 = 'Y' THEN
       LET l_n = l_n + 1
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('axm-596') THEN
      RETURN
    END IF
  ELSE
     CALL cl_err('',-400,0)
     RETURN
  END IF
  CALL s_showmsg_init()
  FOR l_i = 1 TO g_rec_b1
     IF g_ruo1[l_i].sel1 = 'Y' THEN
        CALL p810_in_yes(g_ruo1[l_i].ruo01,g_ruo1[l_i].ruoplant,'Y')
     END IF
  END FOR
  CALL s_showmsg() 

END FUNCTION
FUNCTION p810_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b
    LET g_ruo[l_i].sel = p_flag
    DISPLAY BY NAME g_ruo[l_i].sel
  END FOR
END FUNCTION
FUNCTION p810_sel_all_1(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1
    LET g_ruo1[l_i].sel1 = p_flag
    DISPLAY BY NAME g_ruo1[l_i].sel1
  END FOR
END FUNCTION

#FUN-C80072
