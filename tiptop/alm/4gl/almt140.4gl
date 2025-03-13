# Prog. Version..: '5.30.06-13.04.09(00009)'     #
#
# Pattern name...: almt140.4gl
# Descriptions...: 攤位變更申請作業
# Date & Author..: NO.FUN-B80141 11/08/25 By huangtao
# Modify.........: No.FUN-B80141 11/09/21 By baogc 添加攤位編號自動編碼
# Modify.........: No.FUN-BA0118 11/11/02 By baogc 添加面積變更申請邏輯
# Modify.........: No.FUN-B90121 12/01/13 By baogc BUG修改
# Modify.........: No.TQC-C20141 12/02/13 By huangtao 產品分類頁簽BUG修改
# Modify.........: No.TQC-C20528 12/02/29 By baogc 變更申請單邏輯修改&單身使用DIALOG
# Modify.........: No.TQC-C30111 12/03/08 By yangxf 單身錄入有區域編號的場地編號，代出區域編號和區域名稱後，
#                                                   再將場地編號改為無區域編號的場地編號，區域名稱沒有清空
# Modify.........: No.TQC-C30239 12/03/20 By fanbj 已作廢的場地攤位不可用
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 13/01/04 By bart 排除作廢
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
                                
DEFINE   g_lic        DYNAMIC ARRAY OF RECORD
                         lic02        LIKE lic_file.lic02,
                         lic03        LIKE lic_file.lic03,
                         lic04        LIKE lic_file.lic04,
                         lic04_desc   LIKE lmc_file.lmc04,
                         lic05        LIKE lic_file.lic05,
                         lic05_desc   LIKE lmy_file.lmy04,
                         lic06        LIKE lic_file.lic06,
                         lic07        LIKE lic_file.lic07,
                         lic08        LIKE lic_file.lic08,
                         licacti      LIKE lic_file.licacti
                        END RECORD
DEFINE   g_lic_t      RECORD 
                         lic02        LIKE lic_file.lic02,
                         lic03        LIKE lic_file.lic03,
                         lic04        LIKE lic_file.lic04,
                         lic04_desc   LIKE lmc_file.lmc04,
                         lic05        LIKE lic_file.lic05,
                         lic05_desc   LIKE lmy_file.lmy04,
                         lic06        LIKE lic_file.lic06,
                         lic07        LIKE lic_file.lic07,
                         lic08        LIKE lic_file.lic08,
                         licacti      LIKE lic_file.licacti
                        END RECORD      
DEFINE   g_lid        DYNAMIC ARRAY OF RECORD     
                         lid02        LIKE lid_file.lid02,
                         lid03        LIKE lid_file.lid03,
                         lid03_desc   LIKE oba_file.oba02,
                         lidacti      LIKE lid_file.lidacti            
                      END RECORD
DEFINE   g_lid_t      RECORD
                         lid02        LIKE lid_file.lid02,
                         lid03        LIKE lid_file.lid03,
                         lid03_desc   LIKE oba_file.oba02,
                         lidacti      LIKE lid_file.lidacti              
                       END RECORD
                         
DEFINE   g_lib          RECORD LIKE lib_file.*,
         g_lib_t        RECORD LIKE lib_file.*,
         g_lib01        LIKE lib_file.lib01,
         g_lib01_t      LIKE lib_file.lib01,
         g_wc,g_wc2,g_wc3,
         g_sql          STRING,
         g_rec_b1       LIKE type_file.num5,
         g_rec_b2       LIKE type_file.num5
DEFINE   g_dbs_atm      LIKE type_file.chr1000
DEFINE   p_row,p_col    LIKE type_file.num5
DEFINE   g_b_flag       LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_forupd_sql   STRING
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_cnt          LIKE type_file.num5
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_flag         LIKE type_file.chr1
DEFINE   l_ac1          LIKE type_file.num5
DEFINE   l_ac2          LIKE type_file.num5
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_t1           LIKE oay_file.oayslip
DEFINE   g_flag_b       LIKE type_file.chr1 #TQC-C20528 Add

MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 
   LET g_forupd_sql= " SELECT * FROM lib_file WHERE lib01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t140_cl CURSOR FROM g_forupd_sql
 
   LET g_b_flag = '2'
 
   LET p_row = 2  LET p_col = 9 
   OPEN WINDOW t140_w AT p_row,p_col WITH FORM "alm/42f/almt140"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL t140_menu()
 
   CLOSE WINDOW t140_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

 
FUNCTION t140_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
DEFINE  l_table         LIKE    type_file.chr1000
DEFINE  l_where         LIKE    type_file.chr1000

      CLEAR FORM
      LET g_action_choice=" " 
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lib.* TO NULL
      CONSTRUCT BY NAME g_wc ON
                lib01,lib02,lib03,lib04,lib05,lib06,libplant,liblegal,lib07,lib08,
                lib09,lib10,lib11,lib091,lib101,lib111,lib12,lib13,lib14,
                libmksg,lib16,libconf,libconu,libcond,lib15,
                libuser,libgrup,liboriu,libmodu,libdate,liborig,libacti,libcrat     
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION controlp
            CASE WHEN INFIELD(lib01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lib01"
                    LET g_qryparam.default1 = g_lib.lib01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lib01
                    NEXT FIELD lib01
            
                #FUN-B90121 Add Begin ---
                 WHEN INFIELD(lib04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lja01_1"
                    LET g_qryparam.where = " lja02 = '4' "
                    LET g_qryparam.default1 = g_lib.lib04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lib04
                    NEXT FIELD lib04
                #FUN-B90121 Add End -----
                
                 WHEN INFIELD(lib05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lib05"
                    LET g_qryparam.default1 = g_lib.lib05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lib05
                    NEXT FIELD lib05
                
                 WHEN INFIELD(libplant)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_libplant"
                      LET g_qryparam.default1 = g_lib.libplant
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO libplant
                      NEXT FIELD libplant
                      
                 WHEN INFIELD(liblegal)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_liblegal"
                      LET g_qryparam.default1 = g_lib.liblegal
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO liblegal
                      NEXT FIELD liblegal
                 
                WHEN INFIELD(lib07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lib07"
                    LET g_qryparam.default1 = g_lib.lib07
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lib07
                    NEXT FIELD lib07
                    
                WHEN INFIELD(lib08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lib08"
                    LET g_qryparam.default1 = g_lib.lib08
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lib08
                    NEXT FIELD lib08  

                WHEN INFIELD(lib12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_lib12"
                    LET g_qryparam.default1 = g_lib.lib12
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lib12
                    NEXT FIELD lib12     
                    
                 WHEN INFIELD(libconu)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form = "q_libconu"
                      LET g_qryparam.default1 = g_lib.libconu
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO libconu
                      NEXT FIELD libconu

                 OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT CONSTRUCT
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      
      IF INT_FLAG OR g_action_choice = "exit" THEN
         RETURN
      END IF

      DIALOG ATTRIBUTES(UNBUFFERED) 
        CONSTRUCT g_wc2 ON lic02,lic03,lic04,lic05,lic06,lic07,lic08,licacti
             FROM s_lic[1].lic02,s_lic[1].lic03,s_lic[1].lic04,
                  s_lic[1].lic05,s_lic[1].lic06,s_lic[1].lic07,
                  s_lic[1].lic08,s_lic[1].licacti
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
         ON ACTION controlp
            CASE WHEN INFIELD(lic03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_lic03"
                      LET g_qryparam.default1 = g_lic[1].lic03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lic03
                      NEXT FIELD lic03
                 WHEN INFIELD(lic04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_lic04"
                      LET g_qryparam.default1 = g_lic[1].lic04
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lic04
                      NEXT FIELD lic04
                  WHEN INFIELD(lic05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_lic05"
                      LET g_qryparam.default1 = g_lic[1].lic05
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lic05
                      NEXT FIELD lic05
                 OTHERWISE EXIT CASE
            END CASE
      
         
 
      END CONSTRUCT

      CONSTRUCT g_wc3 ON lid02,lid03,lidacti
           FROM s_lid[1].lid02,s_lid[1].lid03,s_lid[1].lidacti
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
         ON ACTION controlp
            CASE WHEN INFIELD(lid03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_lid03"
                      LET g_qryparam.default1 = g_lid[1].lid03
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO lid03
                      NEXT FIELD lid03
                 OTHERWISE EXIT CASE
            END CASE
      
 
      END CONSTRUCT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
            
      ON ACTION about
         CALL cl_about()
      
      ON ACTION HELP
         CALL cl_show_help()
         
      
      ON ACTION controlg
         CALL cl_cmdask()
        
      
      ON ACTION qbe_save
         CALL cl_qbe_save() 
        
         
      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
         
     END DIALOG
     IF INT_FLAG THEN
        RETURN
     END IF
   LET g_sql = "SELECT lib01 " 
   LET l_table = " FROM lib_file "
   LET l_where = " WHERE ",g_wc 
   IF g_wc2 <> " 1=1" THEN
      LET l_table = l_table,",lic_file"
      LET l_where = l_where," AND lib01 = lic01 AND ",g_wc2
   END IF
   IF g_wc3 <> " 1=1" THEN 
      LET l_table = l_table,",lid_file" 
      LET l_where = l_where," AND lib01 = lid01 AND ",g_wc3
   END IF
  
   LET g_sql = g_sql,l_table,l_where," ORDER BY lib01"
 
   PREPARE t140_prepare FROM g_sql
   DECLARE t140_cs SCROLL CURSOR WITH HOLD FOR t140_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT lib01) ",l_table,l_where
   PREPARE t140_precount FROM g_sql
   DECLARE t140_count CURSOR FOR t140_precount
END FUNCTION
 
FUNCTION t140_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 
     #TQC-C20528 Add&Mark Begin ---
     #CASE g_b_flag
     #   WHEN '2'
     #      CALL t140_bp1("G")
     #      CALL t140_b1_fill(g_wc2)
     #   WHEN '3'
     #      CALL t140_bp2("G")
     #      CALL t140_b2_fill(g_wc3)
     #   OTHERWISE 
     #      CALL t140_bp1("G")
     #      CALL t140_b1_fill(g_wc2)
     #END CASE

      CALL t140_bp("G")
     #TQC-C20528 Add&Mark End -----
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t140_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t140_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t140_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t140_u()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
              #TQC-C20528 Add&Mark Begin ---
              #IF g_b_flag = 2 THEN
              #   CALL t140_b1()
              #END IF
              #IF g_b_flag = 3 THEN
              #   CALL t140_b2()
              #END IF

               CALL t140_b()
              #TQC-C20528 Add&Mark End -----
            END IF
        

 
         WHEN "exporttoexcel"                                                                                                       
            IF cl_chk_act_auth() THEN                                                                                               
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lic),base.TypeInfo.create(g_lid),'')         
            END IF

 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "confirm"                                                                                                             
            IF cl_chk_act_auth() THEN            
               CALL t140_y()
            END IF                                                                                                                  
                                                                                                                                    
        WHEN "unconfirm"                                                                                                                 
            IF cl_chk_act_auth() THEN     
               CALL t140_z() 
            END IF

        WHEN "change_post"
            IF cl_chk_act_auth() THEN
               CALL t140_post()
            END IF    
            
         WHEN "controlg"
            CALL cl_cmdask()
 
    
         WHEN "changdi"
            LET g_b_flag = "2"
            CALL t140_b1_fill(g_wc2) 
            CALL t140_bp1_refresh()       
 
         WHEN "xiaolei"
            LET g_b_flag = "3"
            CALL t140_b2_fill(g_wc3)            
            CALL t140_bp2_refresh()
 
       WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_lib.lib01 IS NOT NULL THEN
                LET g_doc.column1 = "lib01"
                LET g_doc.value1 = g_lib.lib01
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION t140_z()
DEFINE l_n LIKE type_file.num5
DEFINE l_gen02        LIKE gen_file.gen02  #CHI-D20015
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_lib.* FROM lib_file WHERE lib01 = g_lib.lib01
   IF g_lib.lib01 IS NULL  OR g_lib.libplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   IF g_lib.libconf = 'N' THEN CALL cl_err('','atm-053',0) RETURN END IF
   IF g_lib.libacti = 'N' THEN CALL cl_err(g_lib.lib01,'mfg0301',0) RETURN END IF
   IF g_lib.lib16 = '2' THEN CALL cl_err('','alm-943',0) RETURN END IF

   IF NOT cl_confirm('aim-302') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t140_cl USING g_lib.lib01
   IF STATUS THEN
      CALL cl_err("OPEN t140_cl:", STATUS, 1)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t140_cl INTO g_lib.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lib.lib01,SQLCA.sqlcode,0)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF

  
    UPDATE lib_file SET libconf='N',
                        lib16 = '0',
                        #CHI-D20015--modify--str--
                        #libcond=NULL,  
                        #libconu=NULL 
                        libcond=g_today,  
                        libconu=g_user
                        #CHI-D20015--modify--str--
     WHERE lib01 = g_lib.lib01 
    IF SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("upd","lib_file",g_lib.lib01,"",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK
    END IF
   
    COMMIT WORK
    CLOSE t140_cl
 
   SELECT * INTO g_lib.* FROM lib_file WHERE lib01=g_lib.lib01
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lib.libconu #CHI-D20015 add
   DISPLAY l_gen02 TO FORMONLY.libconu_desc                            #CHI-D20015 add
   DISPLAY BY NAME g_lib.libconf,g_lib.lib16,g_lib.libcond,g_lib.libconu      
   CALL cl_set_field_pic(g_lib.libconf,g_lib.lib16,"","","","")                                                                                    
END FUNCTION

FUNCTION t140_y()
DEFINE l_cnt1         LIKE type_file.num5
DEFINE l_cnt2         LIKE type_file.num5
DEFINE l_cnt3         LIKE type_file.num5
DEFINE l_cnt4         LIKE type_file.num5
DEFINE l_count        LIKE type_file.num5
DEFINE l_gen02        LIKE gen_file.gen02
DEFINE l_lid03        LIKE lid_file.lid03
DEFINE l_lib08        LIKE lib_file.lib08
DEFINE l_flag         LIKE type_file.num5
DEFINE l_org          LIKE azp_file.azp01
 
    IF g_lib.lib01 IS NULL OR g_lib.libplant IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
#CHI-C30107 ------------- add ------------- begin
    IF g_lib.libconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lib.libacti = 'N' THEN CALL cl_err(g_lib.lib01,'art-142',0) RETURN END IF
    IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ------------- add ------------- end
    SELECT * INTO g_lib.* FROM lib_file WHERE lib01=g_lib.lib01 
#CHI-C30107 ------------- add ------------- begin
    IF g_lib.lib01 IS NULL OR g_lib.libplant IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
#CHI-C30107 ------------- add ------------- end
    IF g_lib.libconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lib.libacti = 'N' THEN CALL cl_err(g_lib.lib01,'art-142',0) RETURN END IF
    

#   IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
    BEGIN WORK
    OPEN t140_cl USING g_lib.lib01
    IF STATUS THEN
       CALL cl_err("OPEN t140_cl:", STATUS, 1)
       CLOSE t140_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t140_cl INTO g_lib.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lib.lib01,SQLCA.sqlcode,0)
       CLOSE t140_cl 
       ROLLBACK WORK 
       RETURN
    END IF
 
    LET g_success = 'Y'
    LET l_cnt2 = 0
    LET l_cnt3 = 0
   
    SELECT COUNT(*) INTO l_cnt2 FROM lic_file                                                                                   
       WHERE lic01 = g_lib.lib01 AND licacti = 'Y'
#TQC-C30111 add begin --- 
    IF l_cnt2 = 0 THEN
       CALL cl_err('','alm-791',0)
       ROLLBACK WORK
       RETURN
    END IF 
#TQC-C30111 add end ----

    SELECT COUNT(*) INTO l_cnt3 FROM lid_file
       WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
#TQC-C30111 add begin ---
    IF l_cnt3 = 0 THEN
       CALL cl_err('','alm1598',0)
       ROLLBACK WORK
       RETURN
    END IF
#TQC-C30111 add end ----
 
#TQC-C30111 mark begin ---
#    IF l_cnt2 = 0 OR l_cnt3 = 0 THEN 
#       CALL cl_err('','alm-791',0)
#       ROLLBACK WORK
#       RETURN
#    END IF
#TQC-C30111 mark end -----
 
    UPDATE lib_file SET libconf='Y',
                        lib16 = '1',
                        libcond=g_today, 
                        libconu=g_user
     WHERE lib01 = g_lib.lib01 
    IF SQLCA.sqlerrd[3]=0 THEN
       LET g_success='N'
    END IF
 
   IF g_success = 'Y' THEN
      LET g_lib.libconf='Y'
      LET g_lib.lib16 = '1'
      LET g_lib.libcond=g_today    
      LET g_lib.libconu=g_user    
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   
   SELECT * INTO g_lib.* FROM lib_file WHERE lib01=g_lib.lib01 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_lib.libconu
   DISPLAY BY NAME g_lib.libconf,g_lib.lib16,g_lib.libcond,g_lib.libconu                                                                                        
   DISPLAY l_gen02 TO FORMONLY.libconu_desc
   CALL cl_set_field_pic(g_lib.libconf,g_lib.lib16,"","","","") 
   
END FUNCTION
 
FUNCTION t140_desc()
DEFINE l_azp02    LIKE  azp_file.azp02
DEFINE l_azt02    LIKE  azt_file.azt02
DEFINE l_tqa02    LIKE  tqa_file.tqa02
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_lmb03    LIKE lmb_file.lmb03
DEFINE l_lmc04    LIKE lmc_file.lmc04
 
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
   DISPLAY l_azp02 TO FORMONLY.libplant_desc
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lib.liblegal
   DISPLAY l_azt02 TO FORMONLY.liblegal_desc
   SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmbstore = g_lib.libplant AND lmb02 = g_lib.lib07
   DISPLAY l_lmb03  TO FORMONLY.lib07_desc 
   SELECT lmc04 INTO l_lmc04 FROM lmc_file WHERE lmcstore = g_lib.libplant AND lmc02 = g_lib.lib07 AND lmc03 = g_lib.lib08
   DISPLAY l_lmc04  TO FORMONLY.lib08_desc
   SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01 = g_lib.lib12 AND tqa03 = '30'
   DISPLAY l_tqa02  TO FORMONLY.lib12_desc
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lib.libconu
   DISPLAY l_gen02 TO FORMONLY.libconu_desc
END FUNCTION

FUNCTION t140_a()
DEFINE li_result   LIKE type_file.num5
DEFINE l_n         LIKE type_file.num5
DEFINE l_str       STRING
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
 
   CALL g_lic.clear()
   CALL g_lid.clear()
 
   INITIALIZE g_lib.* LIKE lib_file.*
   LET g_lib01_t = NULL
   LET g_lib_t.* = g_lib.*
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_lib.lib02 = g_today
       LET g_lib.libplant = g_plant
       LET g_lib.liblegal = g_legal
       LET g_lib.libconf = 'N'
       LET g_lib.libmksg = 'N'
       LET g_lib.lib16 = '0'
       LET g_lib.libuser = g_user
       LET g_lib.liboriu = g_user 
       LET g_lib.liborig = g_grup 
       LET g_data_plant  = g_plant 
       LET g_lib.libgrup = g_grup
       LET g_lib.libmodu = NULL
       LET g_lib.libdate = NULL
       LET g_lib.libacti = 'Y'
       LET g_lib.libcrat = g_today
       CALL t140_i("a")
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_lic.clear()
           CALL g_lid.clear()
           EXIT WHILE
       END IF
       IF g_lib.lib01 IS NULL OR g_lib.libplant IS NULL THEN
          CONTINUE WHILE
       END IF

       IF g_lib.lib03 = '1' AND g_aza.aza111 = 'Y' THEN
          CALL s_auno(g_lib.lib05,'A','') RETURNING g_lib.lib05,l_str
       END IF
       IF cl_null(g_lib.lib05) THEN
          CONTINUE WHILE
       END IF
       DISPLAY BY NAME g_lib.lib05

       BEGIN WORK
       CALL s_auto_assign_no("alm",g_lib.lib01,g_today,"O5","lib_file","lib01","","","")
          RETURNING li_result,g_lib.lib01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_lib.lib01
       
       INSERT INTO lib_file VALUES(g_lib.*)     
       IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("ins","lib_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)
          ROLLBACK WORK
          CONTINUE WHILE
       ELSE
          COMMIT WORK
       END IF
       LET g_rec_b1=0
       LET g_rec_b2=0

       IF g_lib.lib03 = '2' OR g_lib.lib03 = '3' THEN 
          CALL t140_inslic()
          CALL t140_inslid()
          CALL t140_b1_fill(" 1=1 ")
          CALL t140_b2_fill(" 1=1 ")
       END IF
       IF g_lib.lib03 <> '3' THEN     
         #TQC-C20528 Add&Mark Begin ---
         #CALL t140_b1()
         #CALL t140_b2()

          CALL t140_b()
         #TQC-C20528 Add&Mark End -----
       END IF
       CALL t140_delall()
       EXIT WHILE
   END WHILE
   MESSAGE ''
END FUNCTION

FUNCTION t140_inslid()
DEFINE l_lml   RECORD LIKE lml_file.*

   LET g_sql = " SELECT  lml02,lml06 FROM lml_file ",
               " WHERE lml01 = '",g_lib.lib05,"'"
   PREPARE pre_get_lid FROM g_sql
   DECLARE pre_lid_cur CURSOR FOR pre_get_lid
   BEGIN WORK   
   FOREACH  pre_lid_cur INTO l_lml.lml02,l_lml.lml06

       INSERT INTO lid_file(lid01,lid02,lid03,lidacti,lidplant,lidlegal)
                           VALUES(g_lib.lib01,'0',l_lml.lml02,l_lml.lml06,
                                   g_lib.libplant,g_lib.liblegal)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","lid_file",g_lib.lib01,"",SQLCA.sqlcode,"","",1)
          ROLLBACK WORK
          RETURN
       END IF
    END FOREACH
    COMMIT WORK
END FUNCTION
 
FUNCTION t140_inslic()
DEFINE l_lie   RECORD LIKE lie_file.*
DEFINE l_lmd06 LIKE lmd_file.lmd06
DEFINE l_lmd15 LIKE lmd_file.lmd15
DEFINE l_lmd05 LIKE lmd_file.lmd05
DEFINE l_f  LIKE type_file.chr1
DEFINE l_lmd10 LIKE lmd_file.lmd10 #FUN-BA0118 Add

   LET g_sql = " SELECT  lie02,lie03,lie04,lie05,lie06,lie07,lieacti FROM lie_file ",
               " WHERE lie01 = '",g_lib.lib05,"'"
   PREPARE pre_get_lic FROM g_sql
   DECLARE pre_lic_cur CURSOR FOR pre_get_lic
   BEGIN WORK   
   FOREACH  pre_lic_cur INTO l_lie.lie02,l_lie.lie03,l_lie.lie04,         
                             l_lie.lie05,l_lie.lie06,l_lie.lie07,l_lie.lieacti
       SELECT lmd06,lmd15,lmd05,lmd10 INTO l_lmd06,l_lmd15,l_lmd05,l_lmd10 #FUN-BA0118 Add lmd10
         FROM lmd_file WHERE lmd01 = l_lie.lie02
       IF l_lmd06 <> l_lie.lie05 OR l_lmd15 <> l_lie.lie06 OR l_lmd05 <> l_lie.lie07 THEN
          LET l_f = '2'
       ELSE
         #FUN-BA0118 Add Begin ---
          IF l_lmd10 = 'X' THEN
             LET l_f = '3'
             LET l_lie.lieacti = 'N'
          ELSE
         #FUN-BA0118 Add End -----
             LET l_f = '0'
          END IF #FUN-BA0118 Add
       END IF  
       INSERT INTO lic_file(lic01,lic02,lic03,lic04,lic05,lic06,lic07,lic08,licacti,
                                  licplant,liclegal)
                           VALUES(g_lib.lib01,l_f,l_lie.lie02,l_lie.lie03,
                                   l_lie.lie04,l_lmd06,l_lmd15,l_lmd05,l_lie.lieacti,
                                   g_lib.libplant,g_lib.liblegal)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","lic_file",g_lib.lib01,"",SQLCA.sqlcode,"","",1)
          ROLLBACK WORK
          RETURN
       END IF
    END FOREACH
    COMMIT WORK
END FUNCTION


FUNCTION t140_delall()
DEFINE l_cnt1      LIKE type_file.num5
DEFINE l_cnt2      LIKE type_file.num5
DEFINE l_cnt3      LIKE type_file.num5
DEFINE l_cnt4      LIKE type_file.num5
DEFINE l_count     LIKE type_file.num5
 
   LET l_cnt1 = 0
   LET l_cnt2 = 0
   LET l_cnt3 = 0
   LET l_count = 0
 
   SELECT COUNT(*) INTO l_cnt2 FROM lic_file                                                                                   
       WHERE lic01=g_lib.lib01 
   
   SELECT COUNT(*) INTO l_cnt3 FROM lid_file                                        
       WHERE lid01 = g_lib.lib01 
        
   IF l_cnt2=0 AND l_cnt3=0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lib_file WHERE lib01 = g_lib.lib01
      INITIALIZE g_lib.* TO NULL
      CALL g_lic.clear()
      CALL g_lid.clear()
      CLEAR FORM
   END IF
 
END FUNCTION
 

 
FUNCTION t140_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_lib.lib01 IS NULL OR g_lib.libplant IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_lib.* FROM lib_file WHERE lib01 = g_lib.lib01
 
   IF g_lib.libconf='Y' THEN CALL cl_err('','9022',0) RETURN END IF   
   IF g_lib.libacti = 'N' THEN                                                                                                      
      CALL cl_err('','mfg1000',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   LET g_success = 'Y'
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lib01_t = g_lib.lib01
   LET g_lib_t.* = g_lib.*
   BEGIN WORK
   OPEN t140_cl USING g_lib.lib01
   FETCH t140_cl INTO g_lib.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lib.lib01,SQLCA.SQLCODE,0)
      CLOSE t140_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL t140_show()
   WHILE TRUE
      LET g_lib01_t = g_lib.lib01
      LET g_lib.libmodu=g_user
      LET g_lib.libdate=g_today
      CALL t140_i("u")
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_lib.*=g_lib_t.*
          CALL t140_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE lib_file SET lib_file.* = g_lib.* WHERE lib01 = g_lib.lib01 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","lib_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t140_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t140_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_n          LIKE type_file.num5,
          li_result    LIKE type_file.num5,
          l_lmb03      LIKE lmb_file.lmb03,
          l_lmc04      LIKE lmc_file.lmc04,
          l_gen02      LIKE gen_file.gen02,
          l_lmb06      LIKE lmb_file.lmb06,
          l_lmc07      LIKE lmc_file.lmc07,
          l_tqa02      LIKE tqa_file.tqa02,
          l_tqaacti    LIKE tqa_file.tqaacti
          
   DISPLAY BY NAME
      g_lib.lib01,g_lib.lib02, g_lib.lib03,g_lib.lib04,g_lib.lib05,g_lib.lib06,
      g_lib.libplant,g_lib.liblegal,g_lib.lib07,g_lib.lib08,g_lib.lib09,
      g_lib.lib10,g_lib.lib11,g_lib.lib091,g_lib.lib101,g_lib.lib111,
      g_lib.lib12,g_lib.lib13,g_lib.lib14,g_lib.libmksg,g_lib.lib16,
      g_lib.libconf,g_lib.libconu,g_lib.libcond,g_lib.lib15,
      g_lib.libuser,g_lib.libmodu,g_lib.libacti,g_lib.libgrup,
      g_lib.libdate,g_lib.libcrat,g_lib.liboriu,g_lib.liborig 
      
   
   CALL t140_desc()
   INPUT BY NAME g_lib.lib01,g_lib.lib02, g_lib.lib03,g_lib.lib04,g_lib.lib05,
      g_lib.lib07,g_lib.lib08,
      g_lib.lib12,g_lib.lib13,g_lib.lib15  WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t140_set_entry(p_cmd)
           CALL t140_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("lib01")
 
       AFTER FIELD lib01
           IF NOT cl_null(g_lib.lib01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_lib.lib01!=g_lib_t.lib01) THEN
                 CALL s_check_no("alm",g_lib.lib01,g_lib01_t,"O5","lib_file","lib01","")  
                    RETURNING li_result,g_lib.lib01
                 IF (NOT li_result) THEN                                                            
                    LET g_lib.lib01=g_lib_t.lib01                                                                 
                    NEXT FIELD lib01                                                                                      
                 END IF
                 SELECT oayapr INTO g_lib.libmksg FROM oay_file WHERE oayslip = g_lib.lib01 
              END IF
           END IF

      #TQC-C20528 Add Begin ---
       AFTER FIELD lib02
          IF NOT cl_null(g_lib.lib02) THEN
             IF NOT cl_null(g_lib.lib03) AND NOT cl_null(g_lib.lib04) THEN
                IF g_lib.lib03 = '2' THEN
                   CALL t140_chk_lib02()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD lib02
                   END IF
                END IF
             END IF
          END IF
       
       AFTER FIELD lib03
          IF NOT cl_null(g_lib.lib03) THEN
             IF NOT cl_null(g_lib.lib02) AND NOT cl_null(g_lib.lib04) THEN
                IF g_lib.lib03 = '2' THEN
                   CALL t140_chk_lib02()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD lib03
                   END IF
                END IF
             END IF
          END IF
      #TQC-C20528 Add End -----
 
       ON CHANGE lib03
           IF NOT cl_null(g_lib.lib03) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_lib.lib03!=g_lib_t.lib03) THEN
                 CALL t140_set_entry(p_cmd)
                 CALL t140_set_no_entry(p_cmd)
                 IF NOT cl_null(g_lib.lib05) THEN
                    CALL t140_chk_lib05()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lib.lib03 = g_lib_t.lib03
                       NEXT FIELD lib03
                    END IF 
                 END IF
                 IF g_lib.lib03 = '1' THEN
                    LET g_lib.lib09 = ''
                    LET g_lib.lib10 = ''
                    LET g_lib.lib11 = ''
                    LET g_lib.lib06 = 0
                    LET g_lib.lib14 = '1'
                   #FUN-BA0118 Add Begin ---
                    LET g_lib.lib04 = NULL
                    CALL cl_set_comp_entry('lib12',TRUE)
                    DISPLAY BY NAME g_lib.lib04
                   #FUN-BA0118 Add End -----
                    DISPLAY BY NAME g_lib.lib09,g_lib.lib10,g_lib.lib11,g_lib.lib06,g_lib.lib14
                 END IF
                #FUN-B80141 Add Begin 20111208 ---
                 IF g_lib.lib03 = '1' AND g_aza.aza111 = 'Y' THEN
                    CALL cl_set_comp_entry("lib05",FALSE)
                    CALL cl_set_comp_required("lib05",FALSE)
                 ELSE
                    CALL cl_set_comp_entry("lib05",TRUE)
                    CALL cl_set_comp_required("lib05",TRUE)
                 END IF
                #FUN-B80141 Add End 20111208 -----
              END IF
           END IF

      #FUN-BA0118 Add Begin ---
       AFTER FIELD lib04
          IF NOT cl_null(g_lib.lib04) THEN
             CALL t140_chk_lib04()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lib.lib04 = g_lib_t.lib04
                DISPLAY BY NAME g_lib.lib04
                NEXT FIELD lib04
             END IF

            #TQC-C20528 Add Begin ---
             IF NOT cl_null(g_lib.lib03) AND NOT cl_null(g_lib.lib02) THEN
                IF g_lib.lib03 = '2' THEN
                   CALL t140_chk_lib02()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD lib04
                   END IF
                END IF
             END IF
            #TQC-C20528 Add End -----

             CALL t140_lib05()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lib.lib05 = g_lib_t.lib05
                DISPLAY BY NAME g_lib.lib05
                NEXT FIELD lib04
             END IF
             CALL cl_set_comp_entry('lib05,lib12',FALSE)
          ELSE
             IF p_cmd <> 'a' THEN #FUN-B80141 Add
                CALL cl_set_comp_entry('lib05,lib12',TRUE)
             END IF #FUN-B80141 Add
          END IF
      #FUN-BA0118 Add End -----

      #FUN-B80141 Mark Begin ---
      #FUN-B80141 Add By baogc --- Begin ---
      #BEFORE FIELD lib05
      #   IF cl_null(g_lib.lib05) THEN
      #      IF g_lib.lib03 = '1' THEN
      #         IF g_aza.aza111 = 'Y' THEN
      #            CALL s_auno(g_lib.lib05,'A','') RETURNING g_lib.lib05,g_lib.lib15
      #            DISPLAY BY NAME g_lib.lib05,g_lib.lib15
      #         END IF
      #      END IF
      #   END IF
      #FUN-B80141 Add By baogc --- End   ---    
      #FUN-B80141 Mark End -----
 
       AFTER FIELD lib05
          IF NOT cl_null(g_lib.lib05) THEN
             IF (p_cmd='a') OR (p_cmd='u' AND g_lib.lib05!=g_lib_t.lib05) THEN
                 CALL t140_chk_lib05()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lib.lib05 = g_lib_t.lib05
                    NEXT FIELD lib05
                 END IF 
                 IF g_lib.lib03 <> '1' THEN
                    CALL t140_lib05()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lib.lib05 = g_lib_t.lib05
                       NEXT FIELD lib05
                    END IF  
                 END IF
             END IF
          END IF

       AFTER FIELD lib07 
           IF NOT cl_null(g_lib.lib07) THEN
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM lmb_file
               WHERE lmb02 = g_lib.lib07 AND lmbstore = g_lib.libplant  
              IF l_n < 1 THEN
                 CALL cl_err('','alm-003',0)
                 NEXT FIELD lib07
              ELSE
                SELECT lmb06 INTO l_lmb06 FROM lmb_file
                 WHERE lmb02 = g_lib.lib07 AND lmbstore = g_lib.libplant  
                IF l_lmb06 = 'N' THEN
                   CALL cl_err('','alm-905',1)
                   NEXT FIELD lib07
                ELSE
                   SELECT lmb03,lmb06 INTO l_lmb03,l_lmb06 FROM lmb_file
                    WHERE lmb02 = g_lib.lib07 AND lmbstore = g_lib.libplant 
                   IF cl_null(l_lmb03) OR cl_null(l_lmb06) THEN
                      CALL cl_err('','alm-904',1)
                      NEXT FIELD lib07
                   ELSE
                      DISPLAY l_lmb03 TO FORMONLY.lib07_desc
                   END IF
               END IF
               IF NOT cl_null(g_lib.lib08) THEN                         
                   SELECT COUNT(*) INTO l_n FROM lmc_file
                    WHERE lmc03 = g_lib.lib08  AND lmcstore =  g_lib.libplant AND lmc02 = g_lib.lib07
                   IF l_n < 1 THEN
                      CALL cl_err('','alm-847',1)
                      NEXT FIELD lib08
                   END IF
                END IF                                                   
              END IF
           ELSE
              LET l_lmb03 = NULL
              DISPLAY l_lmb03 TO FORMONLY.lib07_desc
           END IF

       AFTER FIELD lib08
           IF NOT cl_null(g_lib.lib08) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM lmc_file
              WHERE lmc03 = g_lib.lib08 AND lmcstore =  g_lib.libplant AND lmc02 = g_lib.lib07 
            IF l_n < 1 THEN
               CALL cl_err('','alm-554',1)
               LET l_lmc04 = NULL
               DISPLAY l_lmc04 TO FORMONLY.lib08_desc
               NEXT FIELD lib08
            ELSE
               SELECT lmc07 INTO l_lmc07 FROM lmc_file
                WHERE lmc03 = g_lib.lib08 AND lmcstore =  g_lib.libplant AND lmc02 = g_lib.lib07 
               IF l_lmc07 = 'N' THEN
                  CALL cl_err('','alm-908',1)
                  NEXT FIELD lib08
               ELSE
                  SELECT lmc04 INTO l_lmc04 FROM lmc_file
                   WHERE lmc03 = g_lib.lib08 AND lmcstore =  g_lib.libplant AND lmc02 = g_lib.lib07 
                  IF STATUS = 100 THEN
                     CALL cl_err('','alm-907',1)
                     NEXT FIELD lib08
                  ELSE
                     DISPLAY l_lmc04 TO FORMONLY.lib08_desc
                  END IF
               END IF
            END IF
         ELSE
            LET l_lmc04 = NULL
            DISPLAY l_lmc04 TO FORMONLY.lib08_desc
         END IF

           
       AFTER FIELD lib12
           IF NOT cl_null(g_lib.lib12) THEN  
              IF (p_cmd='a') OR (p_cmd='u' AND g_lib.lib12!=g_lib_t.lib12) THEN
                 SELECT tqaacti INTO l_tqaacti FROM tqa_file WHERE tqa01 = g_lib.lib12 AND tqa03 = '30'
                 IF STATUS = 100 THEN
                    CALL cl_err('','alm-780',0)
                    LET g_lib.lib12 = g_lib_t.lib12
                    NEXT FIELD lib12
                 ELSE 
                    IF l_tqaacti = 'N' THEN
                       CALL cl_err('','alm-861',0)
                       LET g_lib.lib12 = g_lib_t.lib12
                       NEXT FIELD lib12
                    END IF
                 END IF
                 SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lib.lib12 AND tqa03 = '30'
                 DISPLAY l_tqa02 TO FORMONLY.lib12_desc
              END IF
           END IF
           
       ON ACTION controlp
          CASE 
             WHEN INFIELD(lib01)
                LET g_t1=s_get_doc_no(g_lib.lib01)
                CALL q_oay(FALSE,FALSE,g_t1,'O5','ALM') RETURNING g_t1  
                LET g_lib.lib01=g_t1               
                DISPLAY BY NAME g_lib.lib01       
                NEXT FIELD lib01

            #FUN-BA0118 Add Begin ---
             WHEN INFIELD(lib04)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lja01_1"
               #TQC-C20528 Add&Mark Begin ---
               #LET g_qryparam.where = " lja02 = '4' "
                LET g_qryparam.where = " lja02 = '4' AND lja01 NOT IN (SELECT lji03 ",
                                       "                                 FROM lji_file ",
                                       "                                WHERE ljiconf <> 'A' ",
                                       "                                  AND ljiconf <> 'X' ",  #CHI-C80041
                                       "                                  AND ljiconf <> 'B' AND lji02 = '4') "
               #TQC-C20528 Add&Mark End -----
                LET g_qryparam.default1 = g_lib.lib04
                CALL cl_create_qry() RETURNING g_lib.lib04
                DISPLAY BY NAME g_lib.lib04
                NEXT FIELD lib04
            #FUN-BA0118 Add End -----
                
             WHEN INFIELD(lib05) AND g_lib.lib03 <> '1'  
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lmf01_1"
                LET g_qryparam.arg1 = g_lib.libplant
                LET g_qryparam.default1 = g_lib.lib05
                CALL cl_create_qry() RETURNING g_lib.lib05
                DISPLAY BY NAME g_lib.lib05
                CALL t140_lib05()
                NEXT FIELD lib05

            WHEN INFIELD(lib07)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lmc3"
                LET g_qryparam.arg1 = g_lib.libplant
                LET g_qryparam.default1 = g_lib.lib07
                LET g_qryparam.default2 = g_lib.lib08
                LET g_qryparam.default3 = l_lmc04
                CALL cl_create_qry()
                RETURNING g_lib.lib07,g_lib.lib08,l_lmc04
                SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmbstore = g_lib.libplant AND lmb02 = g_lib.lib07
                DISPLAY BY NAME g_lib.lib07,g_lib.lib08
                DISPLAY  l_lmb03 TO FORMONLY.lib07_desc
                DISPLAY  l_lmc04 TO FORMONLY.lib08_desc
               NEXT FIELD lib07 

            WHEN INFIELD(lib08) 
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lmc2"
                LET g_qryparam.arg1 = g_lib.lib07
                LET g_qryparam.arg2 = g_lib.libplant
                LET g_qryparam.default1 = g_lib.lib07
                LET g_qryparam.default2 = g_lib.lib08
                LET g_qryparam.default3 = l_lmc04
                CALL cl_create_qry()
                    RETURNING g_lib.lib07,g_lib.lib08,l_lmc04
                SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmbstore = g_lib.libplant AND lmb02 = g_lib.lib07
                DISPLAY BY NAME g_lib.lib07,g_lib.lib08
                DISPLAY  l_lmb03 TO FORMONLY.lib07_desc
                DISPLAY  l_lmc04 TO FORMONLY.lib08_desc
                NEXT FIELD lib08
                
            WHEN INFIELD(lib12) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_tqa"
                LET g_qryparam.default1 = g_lib.lib12
                LET g_qryparam.arg1 ='30'
                CALL cl_create_qry() RETURNING g_lib.lib12
                DISPLAY BY NAME g_lib.lib12
                NEXT FIELD lib12
                
          END CASE
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) 
               RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about 
          CALL cl_about()
 
       ON ACTION HELP
          CALL cl_show_help()
 
       AFTER INPUT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
   END INPUT
END FUNCTION

FUNCTION t140_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_lib.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t140_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_lib.* TO NULL
      CALL g_lic.clear()
      CALL g_lid.clear()
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN t140_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_lib.* TO NULL
   ELSE
      OPEN t140_count
      FETCH t140_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t140_fetch('F')
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t140_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t140_cs INTO g_lib.lib01
      WHEN 'P' FETCH PREVIOUS t140_cs INTO g_lib.lib01
      WHEN 'F' FETCH FIRST    t140_cs INTO g_lib.lib01
      WHEN 'L' FETCH LAST     t140_cs INTO g_lib.lib01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about
                   CALL cl_about()
            
                ON ACTION HELP
                   CALL cl_show_help()
            
                ON ACTION controlg
                   CALL cl_cmdask()
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump t140_cs INTO g_lib.lib01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lib.lib01,SQLCA.SQLCODE,0) 
      INITIALIZE g_lib.* TO NULL
      CALL g_lic.clear()
      CALL g_lid.clear()
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   SELECT * INTO g_lib.* FROM lib_file WHERE  lib01 = g_lib.lib01
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_lib.* TO NULL
      CALL g_lic.clear()
      CALL g_lid.clear()
      CALL cl_err3("sel","lib_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)  
      RETURN
   END IF
   
   CALL t140_show()
END FUNCTION
 
FUNCTION t140_show()
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_lmb03    LIKE lmb_file.lmb03
   DEFINE l_lmc04    LIKE lmc_file.lmc04
 
 
   DISPLAY BY NAME
      g_lib.lib01,g_lib.lib02, g_lib.lib03,g_lib.lib04,g_lib.lib05,g_lib.lib06,
      g_lib.libplant,g_lib.liblegal,g_lib.lib07,g_lib.lib08,g_lib.lib09,
      g_lib.lib10,g_lib.lib11,g_lib.lib091,g_lib.lib101,g_lib.lib111,
      g_lib.lib12,g_lib.lib13,g_lib.lib14,g_lib.libmksg,g_lib.lib16,
      g_lib.libconf,g_lib.libconu,g_lib.libcond,g_lib.lib15,
      g_lib.libuser,g_lib.libmodu,g_lib.libacti,g_lib.libgrup,
      g_lib.libdate,g_lib.libcrat,g_lib.liboriu,g_lib.liborig        
   CALL cl_set_field_pic(g_lib.libconf,g_lib.lib16,"","","","") 
   CALL t140_desc()
   CALL t140_b1_fill(g_wc2)
   CALL t140_b2_fill(g_wc3)
   CALL cl_show_fld_cont()
END FUNCTION
 
#TQC-C20528 Mark Begin ---
#FUNCTION t140_b1()
#DEFINE
#   l_ac1_t         LIKE type_file.num5,
#   l_n             LIKE type_file.num5,
#   l_qty           LIKE type_file.num10,
#   l_lock_sw       LIKE type_file.chr1,
#   p_cmd           LIKE type_file.chr1,
#   l_allow_insert  LIKE type_file.num5,
#   l_allow_delete  LIKE type_file.num5,
#   l_cnt           LIKE type_file.num5
#DEFINE l_lie05     LIKE lie_file.lie05
#DEFINE l_lie06     LIKE lie_file.lie06
#DEFINE l_lie07     LIKE lie_file.lie07
#   
#   LET g_b_flag = '2'
#   LET g_action_choice = ""
#   IF s_shut(0) THEN RETURN END IF
#   IF g_lib.lib01 IS NULL OR g_lib.libplant IS NULL THEN RETURN END IF
#      
#   SELECT * INTO g_lib.* FROM lib_file
#      WHERE lib01=g_lib.lib01 
#   IF g_lib.libacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF     
#   IF g_lib.libconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
#   IF g_lib.lib03 = '3' THEN RETURN END IF
#   
#   CALL cl_opmsg('b')
# 
#   LET g_forupd_sql = 
#       "SELECT lic02,lic03,lic04,'',lic05,'',lic06,lic07,lic08,licacti ",
#       "  FROM lic_file ",
#       " WHERE lic03=? AND lic01='",g_lib.lib01,"'",
#       " FOR UPDATE  "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t140_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
# 
#   LET l_ac1_t = 0
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
# 
#   INPUT ARRAY g_lic WITHOUT DEFAULTS FROM s_lic.*
#         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
#                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
# 
#       BEFORE INPUT
#           IF g_rec_b1 != 0 THEN
#              CALL fgl_set_arr_curr(l_ac1)
#              LET l_ac1 = 1
#           END IF
# 
#       BEFORE ROW
#           LET p_cmd=''
#           LET l_ac1 = ARR_CURR()
#           LET l_lock_sw = 'N'            #DEFAULT
#           LET l_n  = ARR_COUNT()
#           BEGIN WORK
# 
#           OPEN t140_cl USING g_lib.lib01
#           IF STATUS THEN
#              CALL cl_err("OPEN t140_cl:", STATUS, 1)
#              CLOSE t140_cl
#              ROLLBACK WORK
#              RETURN
#           END IF
#           FETCH t140_cl INTO g_lib.*
#           IF SQLCA.SQLCODE THEN
#              CALL cl_err(g_lib.lib01,SQLCA.SQLCODE,0)
#              ROLLBACK WORK
#              RETURN
#           END IF
#           IF g_rec_b1>=l_ac1 THEN
#              LET g_lic_t.* = g_lic[l_ac1].*  #BACKUP
#              LET p_cmd='u'
#              OPEN t140_bc2 USING g_lic_t.lic03
#              IF STATUS THEN
#                 CALL cl_err("OPEN t140_bc2:", STATUS, 1)
#                 CLOSE t140_bc2
#                 ROLLBACK WORK
#                 RETURN
#              END IF
#              FETCH t140_bc2 INTO g_lic[l_ac1].*
#              IF SQLCA.SQLCODE THEN
#                  CALL cl_err(g_lic_t.lic03,SQLCA.SQLCODE,1)
#                  LET l_lock_sw = "Y"
#              END IF
#              SELECT lmc04 INTO g_lic[l_ac1].lic04_desc FROM lmc_file
#               WHERE lmcstore = g_plant AND lmc02 = g_lib.lib07
#                 AND lmc03 = g_lic[l_ac1].lic04
#              SELECT lmy04 INTO g_lic[l_ac1].lic05_desc FROM lmy_file 
#               WHERE lmy01 =  g_lib.lib07 AND lmy02 =  g_lib.lib08
#                 AND lmy03 = g_lic[l_ac1].lic05 AND lmystore = g_plant
#              CALL cl_show_fld_cont()
#              IF g_lic[l_ac1].lic02 = '1' THEN
#                 CALL cl_set_comp_entry("lic03",TRUE)
#                 CALL cl_set_comp_entry("licacti",FALSE)
#                 NEXT FIELD lic03
#              ELSE
#                 CALL cl_set_comp_entry("lic03",FALSE)
#                 CALL cl_set_comp_entry("licacti",TRUE)
#                 NEXT FIELD licacti
#              END IF     
#             
#           END IF
# 
#       BEFORE INSERT
#           LET l_n = ARR_COUNT()
#           LET p_cmd='a'
#           INITIALIZE g_lic[l_ac1].* TO NULL
#           LET g_lic_t.* = g_lic[l_ac1].*
#           LET g_lic[l_ac1].lic02 = '1'
#           CALL cl_set_comp_entry("lic03",TRUE)
#           CALL cl_set_comp_entry("licacti",FALSE)
#           LET g_lic[l_ac1].licacti='Y'
#           CALL cl_show_fld_cont()
#           
# 
#       AFTER INSERT
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              CANCEL INSERT
#           END IF
#           INSERT INTO lic_file(lic01,lic02,lic03,lic04,lic05,lic06,lic07,lic08,licacti,licplant,liclegal)
#              VALUES(g_lib.lib01,g_lic[l_ac1].lic02,g_lic[l_ac1].lic03,g_lic[l_ac1].lic04,
#                    g_lic[l_ac1].lic05,g_lic[l_ac1].lic06, g_lic[l_ac1].lic07,
#                    g_lic[l_ac1].lic08,g_lic[l_ac1].licacti,g_lib.libplant,g_lib.liblegal)
#           IF SQLCA.SQLCODE THEN
#              CALL cl_err3("ins","lic_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)
#              CANCEL INSERT
#           ELSE
#              MESSAGE 'INSERT O.K'
#              COMMIT WORK
#              CALL t140_sum()
#              LET g_rec_b1=g_rec_b1+1   
#           END IF
#
#
#
#      BEFORE DELETE  
#          SELECT COUNT(*) INTO l_n FROM lie_file WHERE lie01 = g_lib.lib05 AND lie02 = g_lic_t.lic03
#          IF g_lic_t.lic02 <> '0' AND g_lic_t.lic02 <> '2' AND  l_n = 0  THEN
#              IF NOT cl_delb(0,0) THEN
#                 CANCEL DELETE
#              END IF
#              IF l_lock_sw = "Y" THEN
#                 CALL cl_err("", -263, 1)
#                 CANCEL DELETE
#              END IF
#              DELETE FROM lic_file
#               WHERE lic01 = g_lib.lib01
#                 AND lic03 = g_lic_t.lic03
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err3("del","lic_file",g_lib.lib01,g_lic_t.lic03,SQLCA.sqlcode,"","",1)  
#                 ROLLBACK WORK
#                 CANCEL DELETE
#              END IF
#              LET g_rec_b1=g_rec_b1-1
#              DISPLAY g_rec_b1 TO FORMONLY.c1
#          ELSE
#             CALL cl_err('','alm-788',0)
#             CANCEL DELETE 
#          END IF
#           COMMIT WORK
#
#           
#      AFTER FIELD lic03
#         IF NOT cl_null(g_lic[l_ac1].lic03) AND g_lic[l_ac1].lic02 = '1' THEN
#            IF (p_cmd='a') OR (p_cmd='u' AND g_lic[l_ac1].lic03!=g_lic_t.lic03) THEN
#               CALL t140_chk_lic03() 
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err('',g_errno,0)
#                  LET g_lic[l_ac1].lic03 = g_lic_t.lic03
#                  NEXT FIELD lic03
#               END IF 
#               CALL t140_lic03()  
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err('',g_errno,0)
#                  LET g_lic[l_ac1].lic03 = g_lic_t.lic03
#                  NEXT FIELD lic03
#               END IF
#            END IF
#         END IF
#         
#      
#      ON CHANGE licacti
#         IF p_cmd = 'u' AND g_lic[l_ac1].lic02<> '1' THEN 
#            IF g_lic[l_ac1].licacti = 'N' THEN
#               LET g_lic[l_ac1].lic02 = '3'
#            ELSE
#               SELECT lie05,lie06,lie07 INTO l_lie05,l_lie06,l_lie07 FROM lie_file 
#                WHERE lie01 = g_lib.lib05 AND lie02 = g_lic[l_ac1].lic03
#               IF g_lic[l_ac1].lic06 <> l_lie05 OR g_lic[l_ac1].lic07 <> l_lie06 OR g_lic[l_ac1].lic08 <> l_lie07 THEN
#                  LET  g_lic[l_ac1].lic02 = '2'
#               ELSE
#                  LET  g_lic[l_ac1].lic02 = '0'
#               END IF
#            END IF
#         END IF
# 
#
# 
#       ON ROW CHANGE
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              LET g_lic[l_ac1].* = g_lic_t.*
#              CLOSE t140_bc2
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           IF l_lock_sw = 'Y' THEN
#              CALL cl_err(g_lic[l_ac1].lic03,-263,1) 
#              LET g_lic[l_ac1].* = g_lic_t.*
#           ELSE
#              UPDATE lic_file SET lic02 = g_lic[l_ac1].lic02,
#                                  lic03 = g_lic[l_ac1].lic03,
#                                  lic04 = g_lic[l_ac1].lic04,
#                                  lic05 = g_lic[l_ac1].lic05,
#                                  lic06 = g_lic[l_ac1].lic06,
#                                  lic07 = g_lic[l_ac1].lic07,
#                                  lic08 = g_lic[l_ac1].lic08,
#                                  licacti = g_lic[l_ac1].licacti
#                 WHERE lic01=g_lib.lib01 
#                   AND lic03=g_lic_t.lic03
#              IF SQLCA.SQLCODE THEN
#                 CALL cl_err3("upd","lic_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)
#                 LET g_lic[l_ac1].* = g_lic_t.*
#              ELSE
#                 MESSAGE 'UPDATE O.K'
#                 COMMIT WORK
#                 CALL t140_sum()
#              END IF
#           END IF
# 
#       AFTER ROW
#           LET l_ac1= ARR_CURR()
#           LET l_ac1_t = l_ac1
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              IF p_cmd = 'u' THEN
#                 LET g_lic[l_ac1].* = g_lic_t.*
#              END IF
#              CLOSE t140_bc2
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           CALL t140_sum() #FUN-BA0118 Add
#           CLOSE t140_bc2
#           COMMIT WORK
#
#       ON ACTION controlp
#           CASE WHEN INFIELD(lic03)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_lmd"
#                LET g_qryparam.arg1 = g_lib.lib07
#                LET g_qryparam.arg2 = g_lib.libplant
#                LET g_qryparam.default1 = g_lic[l_ac1].lic03
#                CALL cl_create_qry() RETURNING g_lic[l_ac1].lic03
#                DISPLAY g_lic[l_ac1].lic03 TO lic03
#                CALL t140_lic03() 
#                NEXT FIELD lic03
#           OTHERWISE EXIT CASE
#           END CASE
#            
#       ON ACTION CONTROLO
#          IF INFIELD(lic03) AND l_ac1 > 1 THEN
#             LET g_lic[l_ac1].* = g_lic[l_ac1-1].*
#             NEXT FIELD lic03
#          END IF
# 
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
# 
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
# 
#       ON ACTION CONTROLF
#          CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#             RETURNING g_fld_name,g_frm_name
#          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#       ON ACTION about
#          CALL cl_about()
# 
#       ON ACTION HELP
#          CALL cl_show_help()
#                                                                                                             
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
# 
#   END INPUT
# 
#   CLOSE t140_bc2
#   COMMIT WORK
#END FUNCTION
#TQC-C20528 Mark End -----

#TQC-C20528 Mark Begin ---
#FUNCTION t140_b2()
#DEFINE
#   l_ac2_t          LIKE type_file.num5,
#   l_n             LIKE type_file.num5,
#   l_qty           LIKE type_file.num10,
#   l_lock_sw       LIKE type_file.chr1,
#   p_cmd           LIKE type_file.chr1,
#   l_allow_insert  LIKE type_file.num5,
#   l_allow_delete  LIKE type_file.num5,
#   l_cnt           LIKE type_file.num5
#DEFINE l_obaacti   LIKE oba_file.obaacti
#DEFINE l_lml02     LIKE lml_file.lml02
#
#   LET g_b_flag = '3'
#   LET g_action_choice = ""
#   IF s_shut(0) THEN RETURN END IF
#   IF g_lib.lib01 IS NULL OR g_lib.libplant IS NULL THEN RETURN END IF
#   SELECT * INTO g_lib.* FROM lib_file
#      WHERE lib01=g_lib.lib01 
#   IF g_lib.libconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
#   IF g_lib.lib03 = '3' THEN  RETURN END IF
#
#   CALL cl_opmsg('b')
#
#   LET g_forupd_sql = "SELECT lid02,lid03,'',lidacti FROM lid_file ", 
#                      " WHERE lid03=? AND lid01='",g_lib.lib01,"'",
#                      "   FOR UPDATE  "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t140_bc3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
# 
#   LET l_ac2_t = 0
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
# 
#   INPUT ARRAY g_lid WITHOUT DEFAULTS FROM s_lid.*
#         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
#                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
# 
#       BEFORE INPUT
#           IF g_rec_b2 != 0 THEN
#              CALL fgl_set_arr_curr(l_ac2)
#           END IF
# 
#       BEFORE ROW
#           LET p_cmd=''
#           LET l_ac2 = ARR_CURR()
#           LET l_lock_sw = 'N'            #DEFAULT
#           LET l_n  = ARR_COUNT()
# 
#           BEGIN WORK
# 
#           OPEN t140_cl USING g_lib.lib01
#           IF STATUS THEN
#              CALL cl_err("OPEN t140_cl:", STATUS, 1)
#              CLOSE t140_cl
#              ROLLBACK WORK
#              RETURN
#           END IF
# 
#           FETCH t140_cl INTO g_lib.*
#           IF SQLCA.SQLCODE THEN
#              CALL cl_err(g_lib.lib01,SQLCA.SQLCODE,0)
#              CLOSE t140_cl
#              ROLLBACK WORK
#              RETURN
#           END IF
#           IF g_rec_b2>=l_ac2 THEN
#              LET p_cmd='u'
#              LET g_lid_t.* = g_lid[l_ac2].*   #BACKUP
#              LET l_lock_sw = 'N'              #DEFAULT
#              OPEN t140_bc3 USING g_lid_t.lid03
#              IF STATUS THEN
#                 CALL cl_err("OPEN t140_bc3:", STATUS, 1)
#                 LET l_lock_sw = "Y"
#              ELSE
#                 FETCH t140_bc3 INTO g_lid[l_ac2].*
#                 IF SQLCA.SQLCODE THEN
#                    CALL cl_err(g_lid_t.lid03,SQLCA.SQLCODE , 1)
#                    LET l_lock_sw = "Y"
#                 END IF
#                 SELECT oba02 INTO g_lid[l_ac2].lid03_desc FROM oba_file
#                  WHERE oba01 = g_lid[l_ac2].lid03
#              END IF
#              IF g_lid[l_ac2].lid02 = '1' THEN
#                 CALL cl_set_comp_entry("lid03",TRUE)
#                 CALL cl_set_comp_entry("lidacti",FALSE)      
#                 NEXT FIELD lid03
#              ELSE
#                 CALL cl_set_comp_entry("lid03",FALSE)
#                 CALL cl_set_comp_entry("lidacti",TRUE)      
#                 NEXT FIELD lidacti
#              END IF
#              CALL cl_show_fld_cont()
#           END IF
# 
#       BEFORE INSERT
#           LET l_n = ARR_COUNT()
#           LET p_cmd='a'
##TQC-C20141 ------------------MARK
##          SELECT COUNT(*) INTO l_n FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
##          IF l_n > 0 THEN
##             CALL cl_err('','alm-782',0)
##             CANCEL INSERT 
##          END IF
##TQC-C20141 -----------------MARK
#           INITIALIZE g_lid[l_ac2].* TO NULL
#           LET g_lid_t.* = g_lid[l_ac2].*
#           LET g_lid[l_ac2].lid02 = '1'
#           LET g_lid[l_ac2].lidacti = 'Y'
#           CALL cl_set_comp_entry("lid03",TRUE)
#           CALL cl_set_comp_entry("lidacti",FALSE)
#           CALL cl_show_fld_cont()
#          
#
#       BEFORE DELETE 
#          SELECT COUNT(*) INTO l_n FROM lml_file WHERE lml01 = g_lib.lib05 AND lml02 = g_lid_t.lid03 
#          IF g_lid_t.lid02 <> '0'  AND  l_n = 0  THEN
#              IF NOT cl_delb(0,0) THEN
#                 CANCEL DELETE
#              END IF
#              IF l_lock_sw = "Y" THEN
#                 CALL cl_err("", -263, 1)
#                 CANCEL DELETE
#              END IF
#              DELETE FROM lid_file
#               WHERE lid01 = g_lib.lib01
#                 AND lid03 = g_lid_t.lid03
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err3("del","lid_file",g_lib.lib01,g_lid_t.lid03,SQLCA.sqlcode,"","",1)  
#                 ROLLBACK WORK
#                 CANCEL DELETE
#              END IF
#              LET g_rec_b2=g_rec_b2-1
#              DISPLAY g_rec_b2 TO FORMONLY.c2
#           ELSE
#              CALL cl_err('', 'alm-788', 1)
#              CANCEL DELETE
#           END IF
#           COMMIT WORK
#           
#       AFTER INSERT
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              CANCEL INSERT
#           END IF
#           INSERT INTO lid_file(lid01,lid02,lid03,lidacti,lidplant,lidlegal)
#                         VALUES(g_lib.lib01,g_lid[l_ac2].lid02,
#                         g_lid[l_ac2].lid03,g_lid[l_ac2].lidacti,
#                         g_lib.libplant,g_lib.liblegal)                               
#           IF SQLCA.SQLCODE THEN
#              CALL cl_err3("ins","lid_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)
#              CANCEL INSERT
#           ELSE
#              MESSAGE 'INSERT O.K'
#              COMMIT WORK
#              LET g_rec_b2=g_rec_b2+1   
#           END IF
#
#       AFTER FIELD lid03
#          IF NOT cl_null(g_lid[l_ac2].lid03) THEN
#             IF (p_cmd='a') OR (p_cmd='u' AND g_lid[l_ac2].lid03!=g_lid_t.lid03) THEN
#                SELECT COUNT(*) INTO l_n FROM lid_file
#                WHERE lid01 = g_lib.lib01 AND lid03 = g_lid[l_ac2].lid03
#                IF l_n > 0 THEN
#                   CALL cl_err('','-239',0)
#                   LET g_lid[l_ac2].lid03 = g_lid_t.lid03 
#                   NEXT FIELD lid03 
#                ELSE
#                   SELECT oba02,obaacti INTO g_lid[l_ac2].lid03_desc ,l_obaacti FROM oba_file
#                    WHERE oba01 = g_lid[l_ac2].lid03 AND oba14 = 0 
#                   IF STATUS = 100 THEN
#                      CALL cl_err('','alm-792',0)
#                      LET g_lid[l_ac2].lid03 = g_lid_t.lid03 
#                      NEXT FIELD lid03
#                   END IF
#                   IF l_obaacti = 'N' THEN
#                      CALL cl_err('','alm-781',0)
#                      LET g_lid[l_ac2].lid03 = g_lid_t.lid03 
#                      NEXT FIELD lid03
#                   END IF
#               END IF
##TQC-C20141 -----------------STA
#             SELECT COUNT(*) INTO l_n FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
#             IF l_n > 0 AND p_cmd='a' THEN
#                CALL cl_err('','alm-782',0)
#                LET g_lid[l_ac2].lid03 = g_lid_t.lid03
#                LET g_lid[l_ac2].lid03_desc = ''
#                NEXT FIELD lid03
#             END IF
##TQC-C20141 -----------------END
#             END IF
#          END IF
#                 
#
#
#       ON CHANGE lidacti
##TQC-C20141 -----------------STA
##         IF (p_cmd='a') OR (p_cmd='u' AND g_lid[l_ac2].lidacti!=g_lid_t.lidacti AND g_lid[l_ac2].lidacti = 'Y') THEN
##            SELECT COUNT(*) INTO l_n FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
##            IF l_n > 0 THEN
##               CALL cl_err('','alm-782',0)
##               LET g_lid[l_ac2].lidacti = 'N'
##               NEXT FIELD lidacti
##            END IF
##         END IF
#          SELECT COUNT(*) INTO l_n FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'   
#          IF( l_n > 0 AND p_cmd = 'a') OR (l_n > 0 AND p_cmd='u' AND g_lid_t.lidacti = 'N' AND g_lid[l_ac2].lidacti = 'Y') THEN
#             CALL cl_err('','alm-782',0)
#             LET g_lid[l_ac2].lidacti = 'N'
#             NEXT FIELD lidacti
#          END IF
##TQC-C20141 -----------------END
#          SELECT lml02 INTO l_lml02 FROM lml_file WHERE lml01 = g_lib.lib05 AND lml06 = 'Y'
#          IF  g_lid[l_ac2].lid02 <> '1' AND g_lid[l_ac2].lid03 = l_lml02 THEN 
#             IF g_lid[l_ac2].lidacti = 'N' THEN
#                LET g_lid[l_ac2].lid02 = '3'
#             ELSE
#                LET g_lid[l_ac2].lid02 = '0'
#             END IF
#          END IF
#               
#       ON ROW CHANGE
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              LET g_lid[l_ac2].* = g_lid_t.*
#              CLOSE t140_bc3
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           IF l_lock_sw = 'Y' THEN
#              CALL cl_err(g_lid[l_ac2].lid03,-263,1)
#              LET g_lid[l_ac2].* = g_lid_t.*
#           ELSE
#              UPDATE lid_file SET lid02 = g_lid[l_ac2].lid02,
#                                  lid03 = g_lid[l_ac2].lid03,
#                                  lidacti = g_lid[l_ac2].lidacti
#               WHERE lid01=g_lib.lib01 
#                 AND lid03=g_lid_t.lid03
#              IF SQLCA.SQLCODE THEN
#                 CALL cl_err3("upd","lid_file",g_lid_t.lid03,'',SQLCA.SQLCODE,"","",1)  
#                 LET g_lid[l_ac2].* = g_lid_t.*
#              ELSE
#                 MESSAGE 'UPDATE O.K'
#                 COMMIT WORK
#              END IF
#           END IF
# 
#       AFTER ROW
#           LET l_ac2 = ARR_CURR()
#           LET l_ac2_t = l_ac2
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              IF p_cmd = 'u' THEN
#                 LET g_lid[l_ac2].* = g_lid_t.*
#              END IF
#              CLOSE t140_bc3
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           CLOSE t140_bc3
#           COMMIT WORK
#           
#       ON ACTION controlp
#          CASE 
#             WHEN INFIELD(lid03) 
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_oba01"
#                LET g_qryparam.default1 = g_lid[l_ac2].lid03
#                CALL cl_create_qry() RETURNING g_lid[l_ac2].lid03
#                DISPLAY g_lid[l_ac2].lid03 TO lid03
#                NEXT FIELD lid03
#          END CASE
#         
# 
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
# 
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
# 
#       ON ACTION CONTROLF
#          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#       ON ACTION about
#          CALL cl_about()
# 
#       ON ACTION HELP
#          CALL cl_show_help()
#                                                                                                             
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")     
#                                                                                 
#   END INPUT
#   
#   IF p_cmd = 'u' THEN
#      LET g_lib.libmodu = g_user
#      LET g_lib.libdate = g_today
#      UPDATE lib_file SET libmodu = g_lib.libmodu,
#                          libdate = g_lib.libdate
#         WHERE lib01 = g_lib.lib01 
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err3("upd","lib_file",g_lib.lib01,"",SQLCA.SQLCODE,"","upd lib",1)  
#      END IF
#      DISPLAY BY NAME g_lib.libmodu,g_lib.libdate
#   END IF
#   CLOSE t140_bc3
#   COMMIT WORK
#END FUNCTION
#TQC-C20528 Mark End -----

 
FUNCTION t140_b2_fill(p_wc)
DEFINE l_sql,p_wc        STRING
 
   LET l_sql = "SELECT lid02,lid03,'',lidacti FROM lid_file ", 
               "WHERE lid01 = '",g_lib.lib01,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc
   END IF
   DECLARE t140_cr3 CURSOR FROM l_sql
 
   CALL g_lid.clear()
   LET g_rec_b2 = 0
 
   LET g_cnt = 1
   FOREACH t140_cr3 INTO g_lid[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT oba02 INTO g_lid[g_cnt].lid03_desc FROM oba_file
       WHERE oba01 = g_lid[g_cnt].lid03
      IF cl_null(g_lid[g_cnt].lid03_desc) OR STATUS = 100 THEN
         LET g_lid[g_cnt].lid03_desc = ' '
      END IF
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lid.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   LET g_cnt = 1
   DISPLAY g_rec_b2 TO FORMONLY.c2
   CLOSE t140_cr3
   CALL t140_bp2_refresh()
END FUNCTION
 
FUNCTION t140_bp2_refresh()
  DISPLAY ARRAY g_lid TO s_lid.* ATTRIBUTE(COUNT = g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t140_b1_fill(p_wc)
DEFINE l_sql      STRING
DEFINE p_wc       STRING
DEFINE l_sum     LIKE ohb_file.ohb12
DEFINE l_dbs     LIKE azp_file.azp03
 
   LET l_sql = "SELECT lic02,lic03,lic04,'',lic05,'',lic06,lic07,lic08,licacti",
               " FROM lic_file ",
               "WHERE lic01 = '",g_lib.lib01,"'"
               
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql," AND ",p_wc
   END IF
   DECLARE t140_cr2 CURSOR FROM l_sql
   CALL g_lic.clear()
   LET g_rec_b1 = 0
   LET g_cnt = 1
   FOREACH t140_cr2 INTO g_lic[g_cnt].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      SELECT lmc04 INTO g_lic[g_cnt].lic04_desc FROM lmc_file
       WHERE lmcstore = g_plant AND lmc02 = g_lib.lib07
         AND lmc03 = g_lic[g_cnt].lic04
      IF cl_null(g_lic[g_cnt].lic04_desc) OR STATUS = 100 THEN
         LET g_lic[g_cnt].lic04_desc = ' '
      END IF
      SELECT lmy04 INTO g_lic[g_cnt].lic05_desc FROM lmy_file 
       WHERE lmy01 =  g_lib.lib07 AND lmy02 =  g_lib.lib08
         AND lmy03 = g_lic[g_cnt].lic05 AND lmystore = g_plant
      IF cl_null(g_lic[g_cnt].lic05_desc) OR STATUS = 100 THEN
         LET g_lic[g_cnt].lic05_desc = ' '
      END IF    
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lic.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   LET g_cnt = 1
   DISPLAY g_rec_b1 TO FORMONLY.c1
   CLOSE t140_cr2
   CALL t140_bp1_refresh()
END FUNCTION
 
FUNCTION t140_bp1_refresh()
  DISPLAY ARRAY g_lic TO s_lic.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
#TQC-C20528 Mark Begin ---
#FUNCTION t140_bp2(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1
# 
#   IF p_ud <> "G" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = " "
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_lid TO s_lid.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac2 = ARR_CURR()  
# 
#      ON ACTION CONTROLS                                                                                                          
#         CALL cl_set_head_visible("","AUTO")                                                                                          
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#  
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac2 = 1
#         EXIT DISPLAY
# 
#     
# 
#      ON ACTION exporttoexcel 
#         LET g_action_choice = 'exporttoexcel'  
#         EXIT DISPLAY
# 
#
#      ON ACTION first
#         CALL t140_fetch('F')
#         EXIT DISPLAY
# 
#      ON ACTION previous
#         CALL t140_fetch('P')
#         EXIT DISPLAY
# 
#      ON ACTION jump
#         CALL t140_fetch('/')
#         EXIT DISPLAY
# 
#      ON ACTION next
#         CALL t140_fetch('N')
#         EXIT DISPLAY
# 
#      ON ACTION last
#         CALL t140_fetch('L')
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()
#         CALL cl_set_field_pic(g_lib.libconf,g_lib.lib16,"","","","")
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
# 
#      ON ACTION unconfirm
#         LET g_action_choice="unconfirm"
#         EXIT DISPLAY
#         
#      ON ACTION change_post
#         LET g_action_choice = 'change_post'  
#         EXIT DISPLAY
# 
#      ON ACTION changdi
#         LET g_b_flag = '2'
#         LET g_action_choice = "changdi"
#         EXIT DISPLAY
# 
#      ON ACTION xiaolei
#         LET g_b_flag = '3'
#         LET g_action_choice = "xiaolei"
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#    
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac2 = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#      
#      ON ACTION about
#         CALL cl_about()
#      
#      ON ACTION HELP
#         CALL cl_show_help()
#      
#      ON ACTION controlg
#         CALL cl_cmdask()
# 
#      ON ACTION related_document
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY
#   END DISPLAY
# 
#   CALL cl_set_act_visible("accept,cancel", TRUE)
# 
#END FUNCTION
# 
#FUNCTION t140_bp1(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1
# 
#   IF p_ud <> "G" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = " "
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_lic TO s_lic.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac1 = ARR_CURR()
# 
#      ON ACTION CONTROLS 
#         CALL cl_set_head_visible("","AUTO")     
# 
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#  
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac1 = 1
#         EXIT DISPLAY
#   
#       
#                                                                                                                                    
#      ON ACTION exporttoexcel          
#         LET g_action_choice = 'exporttoexcel' 
#         EXIT DISPLAY
# 
#
#      ON ACTION first
#         CALL t140_fetch('F')
#         EXIT DISPLAY
# 
#      ON ACTION previous
#         CALL t140_fetch('P')
#         EXIT DISPLAY
# 
#      ON ACTION jump
#         CALL t140_fetch('/')
#         EXIT DISPLAY
# 
#      ON ACTION next
#         CALL t140_fetch('N')
#         EXIT DISPLAY
# 
#      ON ACTION last
#         CALL t140_fetch('L')
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()
#         CALL cl_set_field_pic(g_lib.libconf,g_lib.lib16,"","","","")
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#         
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
# 
#      ON ACTION unconfirm
#         LET g_action_choice="unconfirm"
#         EXIT DISPLAY
# 
#      ON ACTION change_post
#         LET g_action_choice="change_post"
#         EXIT DISPLAY   
# 
#      ON ACTION changdi
#         LET g_b_flag = '2'
#         LET g_action_choice = "changdi"
#         EXIT DISPLAY
# 
#      ON ACTION xiaolei
#         LET g_b_flag = '3'
#         LET g_action_choice = "xiaolei"
#         EXIT DISPLAY
#   
#      ON ACTION cancel
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac1 = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#      
#      ON ACTION about
#         CALL cl_about()
#      
#      ON ACTION HELP
#         CALL cl_show_help()
#      
#      ON ACTION controlg
#         CALL cl_cmdask()
# 
#      ON ACTION related_document
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY
# 
#   END DISPLAY
# 
#   CALL cl_set_act_visible("accept,cancel", TRUE)
# 
#END FUNCTION
#TQC-C20528 Mark End -----
 
FUNCTION t140_r()
   DEFINE l_cnt    LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   IF g_lib.lib01 IS NULL OR g_lib.libplant IS NULL THEN 
      CALL cl_err('',-400,2) 
      RETURN 
   END IF
   SELECT * INTO g_lib.* FROM lib_file WHERE lib01 = g_lib.lib01
   IF g_lib.libconf='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_lib.libacti='N' THEN CALL cl_err('','aic-201',0) RETURN END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t140_cl USING g_lib.lib01
   FETCH t140_cl INTO g_lib.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_lib.lib01,SQLCA.SQLCODE,0)
      CLOSE t140_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_lib_t.* = g_lib.*
   CALL t140_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          
       LET g_doc.column1 = "lib01"        
       LET g_doc.value1 = g_lib.lib01      
       CALL cl_del_doc()                                     
      DELETE FROM lib_file 
         WHERE lib01=g_lib.lib01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lib_file",g_lib.lib01,"",SQLCA.SQLCODE,"","(t140_r:delete lib)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM lic_file 
         WHERE lic01 = g_lib.lib01 
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lic_file",g_lib.lib01,"",SQLCA.SQLCODE,"","(t140_r:delete lic)",1) 
         LET g_success='N'
      END IF
      DELETE FROM lid_file WHERE lid01 = g_lib.lib01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lid_file",g_lib.lib01,"",SQLCA.SQLCODE,"","(t140_r:delete lid)",1) 
         LET g_success='N'
      END IF

      INITIALIZE g_lib.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         CLEAR FORM
         LET g_lib_t.* = g_lib.*
         CALL g_lic.clear()
         CALL g_lid.clear()
         OPEN t140_count
         FETCH t140_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t140_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t140_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t140_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_lib.* = g_lib_t.*
      END IF
   END IF
   CALL t140_show()
END FUNCTION


FUNCTION t140_sum()
   IF NOT cl_null(g_lib.lib01) THEN
      SELECT SUM(lic06) INTO g_lib.lib091 FROM lic_file WHERE lic01 = g_lib.lib01 AND licacti = 'Y'
      IF cl_null(g_lib.lib091) THEN LET g_lib.lib091 = 0 END IF 
      SELECT SUM(lic07) INTO g_lib.lib101 FROM lic_file WHERE lic01 = g_lib.lib01 AND licacti = 'Y'
      IF cl_null(g_lib.lib101) THEN LET g_lib.lib101 = 0 END IF 
      SELECT SUM(lic08) INTO g_lib.lib111 FROM lic_file WHERE lic01 = g_lib.lib01 AND licacti = 'Y'
      IF cl_null(g_lib.lib111) THEN LET g_lib.lib111 = 0 END IF 
      UPDATE lib_file SET lib091 = g_lib.lib091,
                          lib101 = g_lib.lib101,
                          lib111 = g_lib.lib111
       WHERE  lib01 = g_lib.lib01
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","lib_file",g_lib.lib01,"",SQLCA.sqlcode,"","",1)
      END IF
      DISPLAY BY NAME g_lib.lib091,g_lib.lib101,g_lib.lib111
   END IF
END FUNCTION

FUNCTION t140_post()
DEFINE l_rtz24    LIKE type_file.num5           #FUN-B80141 add

   IF g_lib.lib01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lib.* FROM lib_file WHERE lib01 = g_lib.lib01
   IF g_lib.libplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  
      RETURN
   END IF
   IF g_lib.lib16 = '0' THEN CALL cl_err('','art-124',0) RETURN END IF
   IF g_lib.lib16 = '2' THEN CALL cl_err('','art-125',0) RETURN END IF

  #FUN-BA0118 Add Begin ---
   IF NOT cl_null(g_lib.lib04) THEN
      CALL t140_chk_area()
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,0)
         RETURN
      END IF
   END IF
  #FUN-BA0118 Add End -----
   
   IF NOT cl_confirm('alm-207') THEN RETURN END IF
   BEGIN WORK
   CALL s_showmsg_init()
   OPEN t140_cl USING g_lib.lib01
   IF STATUS THEN
      CALL cl_err("OPEN t140_cl:", STATUS, 1)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t140_cl INTO g_lib.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lib.lib01,SQLCA.sqlcode,0)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF 
   LET g_success = 'Y'

   CASE g_lib.lib03
      WHEN '1'
         CALL t140_ins_lmf()
      WHEN '2'
         CALL t140_upd_lmf('2')
      WHEN '3'
         CALL t140_upd_lmf('3')
   END CASE

   IF g_success = 'Y' THEN
      UPDATE lib_file SET lib16 = '2' WHERE lib01 = g_lib.lib01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('upd lib_file',g_lib.lib01,'',SQLCA.sqlcode,1)
          LET g_success = 'N'
      END IF
#     CALL s_showmsg()       #TQC-C30111 mark
   END IF
#FUN-B80141 -------------add by huangtao 11/09/29
   IF g_success = 'Y' THEN
#     CASE g_lib.lib03
#       WHEN '1'
#          SELECT rtz24 INTO l_rtz24 FROM rtz_file WHERE rtz01 = g_lib.libplant
#          IF cl_null(l_rtz24) THEN 
#             UPDATE rtz_file SET rtz24 = 1 WHERE rtz01 = g_lib.libplant
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL s_errmsg('upd rtz_file',g_lib.lib01,'',SQLCA.sqlcode,1)
#                LET g_success = 'N'
#             END IF
#          ELSE
#             UPDATE rtz_file SET rtz24 = rtz24+1 WHERE rtz01 = g_lib.libplant
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL s_errmsg('upd rtz_file',g_lib.lib01,'',SQLCA.sqlcode,1)
#                LET g_success = 'N'
#             END IF
#          END IF
#          CALL s_showmsg() 
#       WHEN '3'
#          UPDATE rtz_file SET rtz24 = rtz24-1 WHERE rtz01 = g_lib.libplant
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL s_errmsg('upd rtz_file',g_lib.lib01,'',SQLCA.sqlcode,1)
#             LET g_success = 'N'
#          END IF
#          CALL s_showmsg() 
#     END CASE
      SELECT COUNT(*) INTO l_rtz24 FROM lmf_file WHERE lmfstore = g_lib.libplant AND lmf06 = 'Y'
      IF cl_null(l_rtz24) THEN
         LET l_rtz24 = 0 
      END IF
      UPDATE rtz_file SET rtz24 = l_rtz24 WHERE rtz01 = g_lib.libplant    
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('upd rtz_file',g_lib.lib01,'',SQLCA.sqlcode,1)
          LET g_success = 'N'
      END IF
#     CALL s_showmsg()        #TQC-C30111 mark
   END IF
   CALL s_showmsg()           #TQC-C30111 add 
#FUN-B80141 -------------add by huangtao 11/09/29   
   IF g_success = 'Y' THEN
      CALL cl_err('','alm-940',0)
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_lib.* FROM lib_file WHERE lib01 = g_lib.lib01
   DISPLAY BY NAME g_lib.lib16
   CLOSE t140_cl
   
END FUNCTION

#FUN-BA0118 Add Begin ---
FUNCTION t140_chk_area()
DEFINE l_lja081 LIKE lja_file.lja081
DEFINE l_lja091 LIKE lja_file.lja091
DEFINE l_lja101 LIKE lja_file.lja101

   LET g_errno = ''
   SELECT lja081,lja091,lja101 INTO l_lja081,l_lja091,l_lja101
     FROM lja_file
    WHERE lja01 = g_lib.lib04
   IF l_lja081 <> g_lib.lib091 OR l_lja091 <> g_lib.lib101 OR l_lja101 <> g_lib.lib111 THEN
      LET g_errno = 'alm-875'  #面積變更不符合'面積變更申請單'中的設置
   END IF
END FUNCTION
#FUN-BA0118 Add End -----

FUNCTION t140_ins_lmf()
DEFINE l_lmf     RECORD LIKE lmf_file.*
DEFINE l_lie     RECORD LIKE lie_file.*
DEFINE l_lml     RECORD LIKE lml_file.*
DEFINE l_lic     RECORD LIKE lic_file.*
DEFINE l_lid     RECORD LIKE lid_file.*
DEFINE l_sql     STRING

    LET l_lmf.lmf01 = g_lib.lib05
    LET l_lmf.lmf03 = g_lib.lib07
    LET l_lmf.lmf04 = g_lib.lib08
    LET l_lmf.lmf05 = g_lib.lib14
    LET l_lmf.lmf06 = 'Y'
    LET l_lmf.lmf07 = g_user
    LET l_lmf.lmf08 = g_today
    LET l_lmf.lmf09 = g_lib.lib091
    LET l_lmf.lmf10 = g_lib.lib101
    LET l_lmf.lmf11 = g_lib.lib111
    LET l_lmf.lmf12 = g_lib.lib12
    LET l_lmf.lmf13 = g_lib.lib13
    LET l_lmf.lmf14 = g_lib.lib15
    LET l_lmf.lmf15 = g_lib.lib06
    LET l_lmf.lmfacti = 'Y'
    LET l_lmf.lmfuser = g_lib.libuser
    LET l_lmf.lmfcrat = g_lib.libcrat
    LET l_lmf.lmfdate = g_today
    LET l_lmf.lmfgrup = g_lib.libgrup
    LET l_lmf.lmfstore = g_lib.libplant
    LET l_lmf.lmflegal = g_lib.liblegal
    LET l_lmf.lmforiu = g_lib.liboriu
    LET l_lmf.lmforig = g_lib.liborig
    INSERT INTO lmf_file VALUES (l_lmf.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL s_errmsg('ins lmf_file',g_lib.lib05,'',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF

    LET l_sql = " SELECT * FROM lic_file WHERE lic01 = '",g_lib.lib01,"'",
                "                          AND licacti = 'Y'"                          
    PREPARE pre_lie FROM l_sql
    DECLARE cur_lie CURSOR FOR  pre_lie
    FOREACH cur_lie INTO l_lic.*
        LET l_lie.lie01 = g_lib.lib05
        LET l_lie.lie02 = l_lic.lic03
        LET l_lie.lie03 = l_lic.lic04
        LET l_lie.lie04 = l_lic.lic05
        LET l_lie.lie05 = l_lic.lic06
        LET l_lie.lie06 = l_lic.lic07
        LET l_lie.lie07 = l_lic.lic08
        LET l_lie.lieacti = 'Y'
        LET l_lie.lielegal = l_lic.liclegal
        LET l_lie.liestore = l_lic.licplant
        INSERT INTO lie_file VALUES (l_lie.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL s_errmsg('ins lie_file',g_lib.lib05,'',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF
        UPDATE lmd_file SET lmd07 = 'Y'
         WHERE lmd01 = l_lic.lic03 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL s_errmsg('upd lmd_file',l_lic.lic03,'',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF
    END FOREACH
    SELECT * INTO l_lid.* FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
    LET l_lml.lml01 = g_lib.lib05
    LET l_lml.lml02 = l_lid.lid03 
    LET l_lml.lml06 = 'Y'
    LET l_lml.lmllegal = l_lid.lidlegal
    LET l_lml.lmlstore = l_lid.lidplant    
    INSERT INTO lml_file VALUES (l_lml.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL s_errmsg('ins lml_file',g_lib.lib05,'',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
END FUNCTION

FUNCTION t140_upd_lmf(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_lmf     RECORD LIKE lmf_file.*
DEFINE l_lie     RECORD LIKE lie_file.*
DEFINE l_lml     RECORD LIKE lml_file.*
DEFINE l_lic     RECORD LIKE lic_file.*
DEFINE l_lid     RECORD LIKE lid_file.*
DEFINE l_sql     STRING
DEFINE l_n       LIKE type_file.num5

INITIALIZE l_lmf.* TO NULL 
INITIALIZE l_lie.* TO NULL
INITIALIZE l_lml.* TO NULL
INITIALIZE l_lic.* TO NULL
INITIALIZE l_lid.* TO NULL

   IF p_cmd = '2' THEN
      LET l_lmf.lmf01 = g_lib.lib05
      LET l_lmf.lmf03 = g_lib.lib07
      LET l_lmf.lmf04 = g_lib.lib08
      LET l_lmf.lmf05 = g_lib.lib14
      LET l_lmf.lmf06 = 'Y'
      LET l_lmf.lmf07 = g_user
      LET l_lmf.lmf08 = g_today
      LET l_lmf.lmf09 = g_lib.lib091
      LET l_lmf.lmf10 = g_lib.lib101
      LET l_lmf.lmf11 = g_lib.lib111
      LET l_lmf.lmf12 = g_lib.lib12
      LET l_lmf.lmf13 = g_lib.lib13
      LET l_lmf.lmf14 = g_lib.lib15
      LET l_lmf.lmf15 = g_lib.lib06
      LET l_lmf.lmfacti = 'Y'
      LET l_lmf.lmfcrat = g_lib.libcrat
      LET l_lmf.lmfuser = g_lib.libuser
      LET l_lmf.lmfdate = g_today
      LET l_lmf.lmfgrup = g_lib.libgrup
      LET l_lmf.lmfstore = g_lib.libplant
      LET l_lmf.lmflegal = g_lib.liblegal
      LET l_lmf.lmforiu = g_lib.liboriu
      LET l_lmf.lmforig = g_lib.liborig
      UPDATE lmf_file SET lmf_file.* = l_lmf.*
       WHERE lmf01 = g_lib.lib05
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('upd lmf_file',g_lib.lib05,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      LET l_sql = " SELECT * FROM lic_file WHERE lic01 = '",g_lib.lib01,"'"
      PREPARE pre_lie1 FROM l_sql
      DECLARE cur_lie1 CURSOR FOR  pre_lie1
      FOREACH cur_lie1 INTO l_lic.*
          IF l_lic.lic02 = '1' THEN
             LET l_lie.lie01 = g_lib.lib05
             LET l_lie.lie02 = l_lic.lic03
             LET l_lie.lie03 = l_lic.lic04
             LET l_lie.lie04 = l_lic.lic05
             LET l_lie.lie05 = l_lic.lic06
             LET l_lie.lie06 = l_lic.lic07
             LET l_lie.lie07 = l_lic.lic08
             LET l_lie.lieacti = 'Y'
             LET l_lie.lielegal = l_lic.liclegal
             LET l_lie.liestore = l_lic.licplant
             INSERT INTO lie_file VALUES (l_lie.*)
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL s_errmsg('ins lie_file',g_lib.lib05,'',SQLCA.sqlcode,1)
                LET g_success = 'N'
                RETURN
             END IF
             UPDATE lmd_file SET lmd07 = 'Y'
              WHERE lmd01 = l_lic.lic03 
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL s_errmsg('upd lmd_file',l_lic.lic03,'',SQLCA.sqlcode,1)
                LET g_success = 'N'
                RETURN
             END IF
           END IF
           IF l_lic.lic02 = '2' THEN
              LET l_lie.lie01 = g_lib.lib05
              LET l_lie.lie02 = l_lic.lic03
              LET l_lie.lie03 = l_lic.lic04
              LET l_lie.lie04 = l_lic.lic05
              LET l_lie.lie05 = l_lic.lic06
              LET l_lie.lie06 = l_lic.lic07
              LET l_lie.lie07 = l_lic.lic08
              LET l_lie.lieacti = 'Y'
              LET l_lie.lielegal = l_lic.liclegal
              LET l_lie.liestore = l_lic.licplant
              UPDATE lie_file SET lie_file.* = l_lie.*
               WHERE lie01 = g_lib.lib05 AND lie02 = l_lic.lic03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL s_errmsg('upd lie_file',g_lib.lib05,l_lic.lic03,SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 RETURN
              END IF
           END IF
           IF l_lic.lic02 = '3' THEN
              SELECT COUNT(*) INTO l_n FROM lie_file 
               WHERE lie01 = g_lib.lib05 AND lie02 = l_lic.lic03
              IF l_n > 0 THEN
                 DELETE FROM lie_file WHERE lie01 = g_lib.lib05 AND lie02 = l_lic.lic03
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL s_errmsg('del lie_file',g_lib.lib05,l_lic.lic03,SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    RETURN
                 END IF
                 UPDATE lmd_file SET lmd07 = 'N'
                  WHERE lmd01 = l_lic.lic03
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL s_errmsg('upd lmd_file',l_lic.lic03,'',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    RETURN
                 END IF
              END IF
           END IF
      END FOREACH
      LET l_sql = " SELECT * FROM lid_file WHERE lid01 = '",g_lib.lib01,"'"
      PREPARE pre_lml FROM l_sql
      DECLARE cur_lml CURSOR FOR  pre_lml
      FOREACH cur_lml INTO l_lid.*
         IF l_lid.lid02 = '1' AND l_lid.lidacti = 'Y' THEN
            DELETE FROM lml_file WHERE lml01 = g_lib.lib05 
            LET l_lml.lml01 =  g_lib.lib05
            LET l_lml.lml02 = l_lid.lid03 
            LET l_lml.lml06 = 'Y'
            LET l_lml.lmllegal = l_lid.lidlegal
            LET l_lml.lmlstore = l_lid.lidplant    
            INSERT INTO lml_file VALUES (l_lml.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('ins lml_file',g_lib.lib05,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF   
         IF l_lid.lid02 = '3' THEN
            SELECT COUNT(*) INTO l_n FROM lml_file 
             WHERE lml01 = g_lib.lib05 AND lml02 = l_lid.lid03 
            IF l_n > 0 THEN
               DELETE FROM lml_file WHERE lml01 = g_lib.lib05 AND lml02 = l_lid.lid03 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL s_errmsg('del lml_file',g_lib.lib05,'',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
         END IF
      END FOREACH
      
   END IF
   IF p_cmd = '3' THEN
      UPDATE lmf_file SET lmf06 = 'X'
       WHERE lmf01 = g_lib.lib05
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('upd lmf_file',g_lib.lib05,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF 
      LET l_sql = " SELECT * FROM lic_file WHERE lic01 = '",g_lib.lib01,"'"
      PREPARE pre_lic FROM l_sql
      DECLARE cur_lic CURSOR FOR pre_lic 
      FOREACH cur_lic INTO l_lic.*
         UPDATE lmd_file SET lmd07 = 'N'
          WHERE lmd01 = l_lic.lic03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('upd lmd_file',l_lic.lic03,'',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH
      
   END IF 

END FUNCTION

#FUN-BA0118 Add Begin ---
FUNCTION t140_chk_lib04()
DEFINE l_lja05   LIKE lja_file.lja05
DEFINE l_ljaconf LIKE lja_file.ljaconf
DEFINE l_n       LIKE type_file.num5 #TQC-C20528 Add

   LET g_errno = ''
   SELECT lja05,ljaconf INTO l_lja05,l_ljaconf FROM lja_file WHERE lja01 = g_lib.lib04 AND lja02 = '4'
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-876'   #不存在
                               LET l_lja05 = NULL
      WHEN l_ljaconf <> 'Y'    LET g_errno = 'alm-873'   #未確認
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

  #TQC-C20528 Add Begin ---
   IF cl_null(g_errno) THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM lji_file 
       WHERE ljiconf <> 'A' AND ljiconf <> 'B' AND lji03 = g_lib.lib04 AND lji02 = '4'
         AND ljiconf <> 'X'
      IF l_n > 0 THEN
         LET g_errno = 'alm1593' #此變更申請單已存在於變更作業中，請檢查！
      END IF
   END IF
  #TQC-C20528 Add End -----

   IF cl_null(g_errno) THEN
      SELECT lnt06,lnt55 INTO g_lib.lib05,g_lib.lib12 
        FROM lnt_file 
       WHERE lnt01 = l_lja05
      LET g_lib.lib03 = '2'
      CALL t140_chk_lib05()
      IF cl_null(g_errno) THEN
         DISPLAY BY NAME g_lib.lib03,g_lib.lib05,g_lib.lib12
      END IF
   END IF
END FUNCTION
#FUN-BA0118 Add End -----

FUNCTION  t140_lib05() 
DEFINE l_tqa02  LIKE tqa_file.tqa02
DEFINE l_lmb03  LIKE lmb_file.lmb03 #FUN-BA0118 Add
DEFINE l_lmc04  LIKE lmc_file.lmc04 #FUN-BA0118 Add
   LET g_errno = '  '
   SELECT lmf03,lmf04,lmf05,lmf09,lmf10,lmf11,lmf15+1,lmf12,lmf13,lmf05,lmf14
     INTO g_lib.lib07,g_lib.lib08,g_lib.lib14,g_lib.lib09,g_lib.lib10,g_lib.lib11,
            g_lib.lib06,g_lib.lib12,g_lib.lib13,g_lib.lib14,g_lib.lib15
     FROM lmf_file WHERE lmf01 = g_lib.lib05
   CASE
       WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) THEN
      SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lib.lib12 AND tqa03 = '30'
      DISPLAY l_tqa02 TO FORMONLY.lib12_desc
     #FUN-BA0118 Add Begin ---
      SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmb02 = g_lib.lib07
      SELECT lmc04 INTO l_lmc04 FROM lmc_file WHERE lmc02 = g_lib.lib07 AND lmc03 = g_lib.lib08
      DISPLAY l_lmb03,l_lmc04 TO FORMONLY.lib07_desc,FORMONLY.lib08_desc
     #FUN-BA0118 Add End -----
      DISPLAY BY NAME g_lib.lib07,g_lib.lib08,g_lib.lib14,g_lib.lib09,g_lib.lib10,
                      g_lib.lib11,g_lib.lib06,g_lib.lib12,g_lib.lib13,g_lib.lib14,g_lib.lib15 #FUN-BA0118 Add g_lib.lib15
   END IF
END FUNCTION

FUNCTION t140_chk_lib05()
DEFINE l_n    LIKE type_file.num5,
       l_n1    LIKE type_file.num5,
       l_n2    LIKE type_file.num5,
       l_n3    LIKE type_file.num5

   LET g_errno = '  '
   IF g_lib.lib03 = '1' THEN
      SELECT COUNT(*) INTO l_n FROM lib_file WHERE lib05 = g_lib.lib05 AND lib16 <> '2'
      IF l_n > 0 THEN
         LET g_errno = 'alm-790'
         RETURN
      END IF
      SELECT COUNT(*) INTO l_n2 FROM lmf_file WHERE lmf01 = g_lib.lib05
      IF l_n2 > 0 THEN
         LET g_errno = 'alm-784'
         RETURN
      END IF
   ELSE
      IF g_lib.lib03 = '2' THEN
         SELECT COUNT(*) INTO l_n1 FROM lib_file WHERE lib05 = g_lib.lib05 AND libconf = 'N'
                                                   AND lib03 = '2'
         IF l_n1 > 0  THEN 
            LET g_errno = 'alm-783'
            RETURN
         END IF
      END IF
      SELECT COUNT(*) INTO l_n3 FROM lmf_file WHERE lmf01 = g_lib.lib05 AND lmf06 = 'Y'
      IF l_n3 = 0 THEN
         LET g_errno = 'alm-785'
         RETURN          
      END IF
   END IF 
END FUNCTION 

FUNCTION t140_chk_lic03() 
DEFINE l_n LIKE type_file.num5
DEFINE l_n1 LIKE type_file.num5
DEFINE l_n2 LIKE type_file.num5
DEFINE l_n3 LIKE type_file.num5 
DEFINE l_n4 LIKE type_file.num5
DEFINE l_lmd10 LIKE lmd_file.lmd10
DEFINE l_lmd07 LIKE lmd_file.lmd07

   LET g_errno = '  '
   SELECT COUNT(*) INTO l_n FROM  lmd_file WHERE lmd01 = g_lic[l_ac1].lic03  
   IF l_n = 0 THEN
      LET g_errno = 'alm-558'
      RETURN
   ELSE
      SELECT lmd10 INTO l_lmd10 FROM lmd_file WHERE lmd01 = g_lic[l_ac1].lic03
      IF l_lmd10 <> 'Y' THEN
         LET g_errno = 'alm-066'
         RETURN
      END IF
   END IF
   
   SELECT COUNT(*) INTO l_n3 FROM lmd_file WHERE lmd01 = g_lic[l_ac1].lic03
                                             AND lmd03 = g_lib.lib07
                                            
   IF l_n3 = 0 THEN
      LET g_errno = 'alm-786'
      RETURN
   END IF 
   SELECT lmd07 INTO l_lmd07 FROM lmd_file WHERE lmd01 = g_lic[l_ac1].lic03
                                             AND lmd03 = g_lib.lib07
                            
   IF l_lmd07 = 'Y' THEN
      LET g_errno = 'alm-787'
      RETURN
   END IF  
 
   SELECT COUNT(*) INTO l_n2 FROM lic_file WHERE lic01 = g_lib.lib01 AND lic03 = g_lic[l_ac1].lic03
   IF l_n2 > 0 THEN
      LET g_errno = '-239'
      RETURN
   END IF

#add ----by huangtao ---------sta
   IF g_lic[l_ac1].lic02 = '1' OR g_lic[l_ac1].lic02 = '2' THEN
     # SELECT COUNT(*) INTO l_n4 FROM lie_file where lie02 = g_lic[l_ac1].lic03    #TQC-C30239 mark
     #TQC-C30239--start add-------------
      SELECT COUNT(*) INTO l_n4 
        FROM lie_file ,lmf_file 
       WHERE lie02 = g_lic[l_ac1].lic03 
         AND lmf01 = lie01
         AND lmf06 <> 'X'
      #TQC-C30239--end add-------------

      IF l_n4 > 0 THEN
         LET g_errno = 'alm-334'
         RETURN
      END IF
   END IF 
#add ----by huangtao ----------end


END FUNCTION
FUNCTION t140_lic03() 
    LET g_errno = '  '   
    SELECT lmd04,lmd14,lmd06,lmd15,lmd05 
      INTO g_lic[l_ac1].lic04,g_lic[l_ac1].lic05,g_lic[l_ac1].lic06,g_lic[l_ac1].lic07,g_lic[l_ac1].lic08
      FROM lmd_file WHERE lmd01 = g_lic[l_ac1].lic03
    SELECT lmc04 INTO g_lic[l_ac1].lic04_desc FROM lmc_file
     WHERE lmcstore = g_plant AND lmc02 = g_lib.lib07 AND lmc03 = g_lic[l_ac1].lic04
    IF NOT cl_null(g_lic[l_ac1].lic05) THEN #TQC-C30111 add
       SELECT lmy04 INTO g_lic[l_ac1].lic05_desc FROM lmy_file 
        WHERE lmy01 =  g_lib.lib07 AND lmy02 =  g_lib.lib08
          AND lmy03 = g_lic[l_ac1].lic05 AND lmystore = g_plant
#TQC-C30111 add begin ----
    ELSE
       LET g_lic[l_ac1].lic05_desc = ''
    END IF   
#TQC-C30111 add end ----
END FUNCTION
 
FUNCTION t140_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' THEN
       CALL cl_set_comp_entry("lib01,lib03,lib05",TRUE) 
       IF g_lib.lib03 = '1' THEN
          CALL cl_set_comp_entry("lib07,lib08",TRUE)
       ELSE
          CALL cl_set_comp_entry("lib07,lib08",FALSE)
       END IF
   END IF 
END FUNCTION
 
FUNCTION t140_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u'  THEN
       CALL cl_set_comp_entry("lib05",FALSE)
       IF g_lib_t.lib03 = '1' THEN
          CALL cl_set_comp_entry("lib03",FALSE) 
       END IF
       CALL cl_set_comp_entry("lib01,lib07,lib08",FALSE)
   END IF
END FUNCTION

#TQC-C20528 Add Begin ---
FUNCTION t140_chk_lib02()
DEFINE l_lja11 LIKE lja_file.lja11

   LET g_errno = ''
   SELECT lja11 INTO l_lja11 FROM lja_file WHERE lja01 = g_lib.lib04 AND lja02 = '4'
   IF NOT cl_null(l_lja11) THEN
      IF l_lja11 <> g_lib.lib02 THEN
         LET g_errno  = 'alm1595' #申請類型為修改時，申請日期必須和面積變更申請單的生效日期一致！
      END IF
   END IF
END FUNCTION
#TQC-C20528 Add End -----

#TQC-C20528 Add Begin ---
FUNCTION t140_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   LET g_action_choice = NULL

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_lic TO s_lic.* ATTRIBUTE(COUNT=g_rec_b1)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()

         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac1 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG

      END DISPLAY

      DISPLAY ARRAY g_lid TO s_lid.* ATTRIBUTE(COUNT=g_rec_b2)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac2 = ARR_CURR()

         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = ARR_CURR()
            EXIT DIALOG

      END DISPLAY

      ON ACTION CONTROLS
         CALL cl_set_head_visible("","AUTO")

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG


      ON ACTION first
         CALL t140_fetch('F')
         EXIT DIALOG

      ON ACTION previous
         CALL t140_fetch('P')
         EXIT DIALOG

      ON ACTION jump
         CALL t140_fetch('/')
         EXIT DIALOG

      ON ACTION next
         CALL t140_fetch('N')
         EXIT DIALOG

      ON ACTION last
         CALL t140_fetch('L')
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL cl_set_field_pic(g_lib.libconf,g_lib.lib16,"","","","")
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DIALOG

      ON ACTION change_post
         LET g_action_choice="change_post"
         EXIT DIALOG

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      
      ON ACTION about
         CALL cl_about()
         
      ON ACTION HELP
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#TQC-C20528 Add End -----

#TQC-C20528 Add Begin ---
FUNCTION t140_b()
DEFINE
   l_ac1_t         LIKE type_file.num5,
   l_ac2_t          LIKE type_file.num5,
   l_n             LIKE type_file.num5,
   l_qty           LIKE type_file.num10,
   l_lock_sw       LIKE type_file.chr1,
   p_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,
   l_allow_delete  LIKE type_file.num5,
   l_cnt           LIKE type_file.num5
DEFINE l_lie05     LIKE lie_file.lie05
DEFINE l_lie06     LIKE lie_file.lie06
DEFINE l_lie07     LIKE lie_file.lie07
DEFINE l_obaacti   LIKE oba_file.obaacti
DEFINE l_lml02     LIKE lml_file.lml02


   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_lib.lib01 IS NULL OR g_lib.libplant IS NULL THEN RETURN END IF

   SELECT * INTO g_lib.* FROM lib_file
      WHERE lib01=g_lib.lib01
   IF g_lib.libacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
   IF g_lib.libconf='Y' THEN CALL cl_err('','art-046',0) RETURN END IF
   IF g_lib.lib03 = '3' THEN RETURN END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql =
       "SELECT lic02,lic03,lic04,'',lic05,'',lic06,lic07,lic08,licacti ",
       "  FROM lic_file ",
       " WHERE lic03=? AND lic01='",g_lib.lib01,"'",
       " FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t140_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT lid02,lid03,'',lidacti FROM lid_file ",
                      " WHERE lid03=? AND lid01='",g_lib.lib01,"'",
                      "   FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t140_bc3 CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac1_t = 0
   LET l_ac2_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")


   DIALOG ATTRIBUTE(UNBUFFERED)

      INPUT ARRAY g_lic FROM s_lic.*
            ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
   
          BEFORE INPUT
              IF g_rec_b1 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac1)
                 LET l_ac1 = 1
              END IF
   
          BEFORE ROW
              LET p_cmd=''
              LET l_ac1 = ARR_CURR()
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
              BEGIN WORK
   
              OPEN t140_cl USING g_lib.lib01
              IF STATUS THEN
                 CALL cl_err("OPEN t140_cl:", STATUS, 1)
                 CLOSE t140_cl
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH t140_cl INTO g_lib.*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err(g_lib.lib01,SQLCA.SQLCODE,0)
                 ROLLBACK WORK
                 RETURN
              END IF
              IF g_rec_b1>=l_ac1 THEN
                 LET g_lic_t.* = g_lic[l_ac1].*  #BACKUP
                 LET p_cmd='u'
                 OPEN t140_bc2 USING g_lic_t.lic03
                 IF STATUS THEN
                    CALL cl_err("OPEN t140_bc2:", STATUS, 1)
                    CLOSE t140_bc2
                    ROLLBACK WORK
                    RETURN
                 END IF
                 FETCH t140_bc2 INTO g_lic[l_ac1].*
                 IF SQLCA.SQLCODE THEN
                     CALL cl_err(g_lic_t.lic03,SQLCA.SQLCODE,1)
                     LET l_lock_sw = "Y"
                 END IF
                 SELECT lmc04 INTO g_lic[l_ac1].lic04_desc FROM lmc_file
                  WHERE lmcstore = g_plant AND lmc02 = g_lib.lib07
                    AND lmc03 = g_lic[l_ac1].lic04
                 SELECT lmy04 INTO g_lic[l_ac1].lic05_desc FROM lmy_file
                  WHERE lmy01 =  g_lib.lib07 AND lmy02 =  g_lib.lib08
                    AND lmy03 = g_lic[l_ac1].lic05 AND lmystore = g_plant
                 CALL cl_show_fld_cont()
                 IF g_lic[l_ac1].lic02 = '1' THEN
                    CALL cl_set_comp_entry("lic03",TRUE)
                    CALL cl_set_comp_entry("licacti",FALSE)
                    NEXT FIELD lic03
                 ELSE
                    CALL cl_set_comp_entry("lic03",FALSE)
                    CALL cl_set_comp_entry("licacti",TRUE)
                    NEXT FIELD licacti
                 END IF
                
              END IF
                 
          BEFORE INSERT
              LET l_n = ARR_COUNT()
              LET p_cmd='a'
              INITIALIZE g_lic[l_ac1].* TO NULL
              LET g_lic_t.* = g_lic[l_ac1].*
              LET g_lic[l_ac1].lic02 = '1'
              CALL cl_set_comp_entry("lic03",TRUE)
              CALL cl_set_comp_entry("licacti",FALSE)
              LET g_lic[l_ac1].licacti='Y'
              CALL cl_show_fld_cont()
              
                 
          AFTER INSERT
              IF INT_FLAG THEN 
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
              END IF
              INSERT INTO lic_file(lic01,lic02,lic03,lic04,lic05,lic06,lic07,lic08,licacti,licplant,liclegal)
                 VALUES(g_lib.lib01,g_lic[l_ac1].lic02,g_lic[l_ac1].lic03,g_lic[l_ac1].lic04,
                       g_lic[l_ac1].lic05,g_lic[l_ac1].lic06, g_lic[l_ac1].lic07,
                       g_lic[l_ac1].lic08,g_lic[l_ac1].licacti,g_lib.libplant,g_lib.liblegal)
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("ins","lic_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)
                 CANCEL INSERT
              ELSE
                 MESSAGE 'INSERT O.K'
                 COMMIT WORK
                 CALL t140_sum()
                 LET g_rec_b1=g_rec_b1+1   
              END IF
   
         BEFORE DELETE
             SELECT COUNT(*) INTO l_n FROM lie_file WHERE lie01 = g_lib.lib05 AND lie02 = g_lic_t.lic03
             IF g_lic_t.lic02 <> '0' AND g_lic_t.lic02 <> '2' AND  l_n = 0  THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM lic_file
                  WHERE lic01 = g_lib.lib01
                    AND lic03 = g_lic_t.lic03
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","lic_file",g_lib.lib01,g_lic_t.lic03,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 LET g_rec_b1=g_rec_b1-1
                 DISPLAY g_rec_b1 TO FORMONLY.c1
             ELSE
                CALL cl_err('','alm-788',0)
                CANCEL DELETE
             END IF
              COMMIT WORK
   
   
         AFTER FIELD lic03
            IF NOT cl_null(g_lic[l_ac1].lic03) AND g_lic[l_ac1].lic02 = '1' THEN
               IF (p_cmd='a') OR (p_cmd='u' AND g_lic[l_ac1].lic03!=g_lic_t.lic03) THEN
                  CALL t140_chk_lic03()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lic[l_ac1].lic03 = g_lic_t.lic03
                     NEXT FIELD lic03
                  END IF
                  CALL t140_lic03()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lic[l_ac1].lic03 = g_lic_t.lic03
                     NEXT FIELD lic03
                  END IF
               END IF
            END IF
            
             
         ON CHANGE licacti
            IF p_cmd = 'u' AND g_lic[l_ac1].lic02<> '1' THEN
               IF g_lic[l_ac1].licacti = 'N' THEN
                  LET g_lic[l_ac1].lic02 = '3'
               ELSE 
                  SELECT lie05,lie06,lie07 INTO l_lie05,l_lie06,l_lie07 FROM lie_file
                   WHERE lie01 = g_lib.lib05 AND lie02 = g_lic[l_ac1].lic03
                  IF g_lic[l_ac1].lic06 <> l_lie05 OR g_lic[l_ac1].lic07 <> l_lie06 OR g_lic[l_ac1].lic08 <> l_lie07 THEN
                     LET  g_lic[l_ac1].lic02 = '2'
                  ELSE
                     LET  g_lic[l_ac1].lic02 = '0'
                  END IF
               END IF
            END IF  
                    
                 
                 
          ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET g_lic[l_ac1].* = g_lic_t.*
                 CLOSE t140_bc2
                 ROLLBACK WORK
                 EXIT DIALOG
              END IF 
              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_lic[l_ac1].lic03,-263,1) 
                 LET g_lic[l_ac1].* = g_lic_t.*
              ELSE
                 UPDATE lic_file SET lic02 = g_lic[l_ac1].lic02,
                                     lic03 = g_lic[l_ac1].lic03,
                                     lic04 = g_lic[l_ac1].lic04,
                                     lic05 = g_lic[l_ac1].lic05,
                                     lic06 = g_lic[l_ac1].lic06,
                                     lic07 = g_lic[l_ac1].lic07,
                                     lic08 = g_lic[l_ac1].lic08,
                                     licacti = g_lic[l_ac1].licacti
                    WHERE lic01=g_lib.lib01
                      AND lic03=g_lic_t.lic03
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err3("upd","lic_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)
                    LET g_lic[l_ac1].* = g_lic_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                    CALL t140_sum()
                 END IF
              END IF
   
          AFTER ROW
              LET l_ac1= ARR_CURR()
              LET l_ac1_t = l_ac1
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN
                    LET g_lic[l_ac1].* = g_lic_t.*
                 END IF
                 CLOSE t140_bc2
                 ROLLBACK WORK
                 EXIT DIALOG
              END IF
              CALL t140_sum() #FUN-BA0118 Add
              CLOSE t140_bc2
              COMMIT WORK
   
          ON ACTION controlp
              CASE WHEN INFIELD(lic03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lmd"
                   LET g_qryparam.arg1 = g_lib.lib07
                   LET g_qryparam.arg2 = g_lib.libplant
                   LET g_qryparam.default1 = g_lic[l_ac1].lic03
                   CALL cl_create_qry() RETURNING g_lic[l_ac1].lic03
                   DISPLAY g_lic[l_ac1].lic03 TO lic03
                   CALL t140_lic03()
                   NEXT FIELD lic03
              OTHERWISE EXIT CASE
              END CASE
   
          ON ACTION CONTROLO
             IF INFIELD(lic03) AND l_ac1 > 1 THEN
                LET g_lic[l_ac1].* = g_lic[l_ac1-1].*
                NEXT FIELD lic03
             END IF 

         ON ACTION accept
            ACCEPT DIALOG
                  
         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_lic.deleteElement(l_ac1)
            END IF
            EXIT DIALOG
   
      END INPUT
   
      INPUT ARRAY g_lid FROM s_lid.*
            ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
   
          BEFORE INPUT
              IF g_rec_b2 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac2)
              END IF
   
          BEFORE ROW
              LET p_cmd=''
              LET l_ac2 = ARR_CURR()
              LET l_lock_sw = 'N'            #DEFAULT
              LET l_n  = ARR_COUNT()
   
              BEGIN WORK
   
              OPEN t140_cl USING g_lib.lib01
              IF STATUS THEN
                 CALL cl_err("OPEN t140_cl:", STATUS, 1)
                 CLOSE t140_cl
                 ROLLBACK WORK
                 RETURN
              END IF 
      
              FETCH t140_cl INTO g_lib.*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err(g_lib.lib01,SQLCA.SQLCODE,0)
                 CLOSE t140_cl
                 ROLLBACK WORK
                 RETURN
              END IF
              IF g_rec_b2>=l_ac2 THEN
                 LET p_cmd='u'
                 LET g_lid_t.* = g_lid[l_ac2].*   #BACKUP
                 LET l_lock_sw = 'N'              #DEFAULT
                 OPEN t140_bc3 USING g_lid_t.lid03
                 IF STATUS THEN
                    CALL cl_err("OPEN t140_bc3:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH t140_bc3 INTO g_lid[l_ac2].*
                    IF SQLCA.SQLCODE THEN
                       CALL cl_err(g_lid_t.lid03,SQLCA.SQLCODE , 1)
                       LET l_lock_sw = "Y"
                    END IF
                    SELECT oba02 INTO g_lid[l_ac2].lid03_desc FROM oba_file
                     WHERE oba01 = g_lid[l_ac2].lid03
                 END IF
                 IF g_lid[l_ac2].lid02 = '1' THEN
                    CALL cl_set_comp_entry("lid03",TRUE)
                    CALL cl_set_comp_entry("lidacti",FALSE)
                    NEXT FIELD lid03
                 ELSE
                    CALL cl_set_comp_entry("lid03",FALSE)
                    CALL cl_set_comp_entry("lidacti",TRUE)
                    NEXT FIELD lidacti       
                 END IF
                 CALL cl_show_fld_cont()
              END IF
   
          BEFORE INSERT
              LET l_n = ARR_COUNT()
              LET p_cmd='a'
   #TQC-C20141 ------------------MARK
   #          SELECT COUNT(*) INTO l_n FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
   #          IF l_n > 0 THEN
   #             CALL cl_err('','alm-782',0)
   #             CANCEL INSERT
   #          END IF
   #TQC-C20141 -----------------MARK
              INITIALIZE g_lid[l_ac2].* TO NULL
              LET g_lid_t.* = g_lid[l_ac2].*
              LET g_lid[l_ac2].lid02 = '1'
              LET g_lid[l_ac2].lidacti = 'Y'
              CALL cl_set_comp_entry("lid03",TRUE)
              CALL cl_set_comp_entry("lidacti",FALSE)
              CALL cl_show_fld_cont()
   
   
          BEFORE DELETE
             SELECT COUNT(*) INTO l_n FROM lml_file WHERE lml01 = g_lib.lib05 AND lml02 = g_lid_t.lid03
             IF g_lid_t.lid02 <> '0'  AND  l_n = 0  THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM lid_file
                  WHERE lid01 = g_lib.lib01
                    AND lid03 = g_lid_t.lid03
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","lid_file",g_lib.lib01,g_lid_t.lid03,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 LET g_rec_b2=g_rec_b2-1
                 DISPLAY g_rec_b2 TO FORMONLY.c2
              ELSE
                 CALL cl_err('', 'alm-788', 1)
                 CANCEL DELETE
              END IF
              COMMIT WORK
   
          AFTER INSERT
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
              END IF
              INSERT INTO lid_file(lid01,lid02,lid03,lidacti,lidplant,lidlegal)
                            VALUES(g_lib.lib01,g_lid[l_ac2].lid02,
                            g_lid[l_ac2].lid03,g_lid[l_ac2].lidacti,
                            g_lib.libplant,g_lib.liblegal)
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("ins","lid_file",g_lib.lib01,"",SQLCA.SQLCODE,"","",1)
                 CANCEL INSERT
              ELSE 
                 MESSAGE 'INSERT O.K'
                 COMMIT WORK
                 LET g_rec_b2=g_rec_b2+1
              END IF
          
          AFTER FIELD lid03
             IF NOT cl_null(g_lid[l_ac2].lid03) THEN
                IF (p_cmd='a') OR (p_cmd='u' AND g_lid[l_ac2].lid03!=g_lid_t.lid03) THEN
                   SELECT COUNT(*) INTO l_n FROM lid_file
                   WHERE lid01 = g_lib.lib01 AND lid03 = g_lid[l_ac2].lid03
                   IF l_n > 0 THEN
                      CALL cl_err('','-239',0)
                      LET g_lid[l_ac2].lid03 = g_lid_t.lid03
                      NEXT FIELD lid03
                   ELSE 
                      SELECT oba02,obaacti INTO g_lid[l_ac2].lid03_desc ,l_obaacti FROM oba_file
                       WHERE oba01 = g_lid[l_ac2].lid03 AND oba14 = 0
                      IF STATUS = 100 THEN
                         CALL cl_err('','alm-792',0)
                         LET g_lid[l_ac2].lid03 = g_lid_t.lid03
                         NEXT FIELD lid03
                      END IF
                      IF l_obaacti = 'N' THEN
                         CALL cl_err('','alm-781',0)
                         LET g_lid[l_ac2].lid03 = g_lid_t.lid03
                         NEXT FIELD lid03
                      END IF
                  END IF
   #TQC-C20141 -----------------STA
                SELECT COUNT(*) INTO l_n FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
                IF l_n > 0 AND p_cmd='a' THEN
                   CALL cl_err('','alm-782',0)
                   LET g_lid[l_ac2].lid03 = g_lid_t.lid03
                   LET g_lid[l_ac2].lid03_desc = ''
                   NEXT FIELD lid03
                END IF
   #TQC-C20141 -----------------END
                END IF
             END IF
   
   
   
          ON CHANGE lidacti
   #TQC-C20141 -----------------STA
   #         IF (p_cmd='a') OR (p_cmd='u' AND g_lid[l_ac2].lidacti!=g_lid_t.lidacti AND g_lid[l_ac2].lidacti = 'Y') THEN
   #            SELECT COUNT(*) INTO l_n FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
   #            IF l_n > 0 THEN
   #               CALL cl_err('','alm-782',0)
   #               LET g_lid[l_ac2].lidacti = 'N'
   #               NEXT FIELD lidacti
   #            END IF
   #         END IF
             SELECT COUNT(*) INTO l_n FROM lid_file WHERE lid01 = g_lib.lib01 AND lidacti = 'Y'
             IF( l_n > 0 AND p_cmd = 'a') OR (l_n > 0 AND p_cmd='u' AND g_lid_t.lidacti = 'N' AND g_lid[l_ac2].lidacti = 'Y') THEN
                CALL cl_err('','alm-782',0)
                LET g_lid[l_ac2].lidacti = 'N'
                NEXT FIELD lidacti
             END IF
   #TQC-C20141 -----------------END
             SELECT lml02 INTO l_lml02 FROM lml_file WHERE lml01 = g_lib.lib05 AND lml06 = 'Y'
             IF  g_lid[l_ac2].lid02 <> '1' AND g_lid[l_ac2].lid03 = l_lml02 THEN
                IF g_lid[l_ac2].lidacti = 'N' THEN
                   LET g_lid[l_ac2].lid02 = '3'
                ELSE
                   LET g_lid[l_ac2].lid02 = '0'
                END IF
             END IF
   
          ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET g_lid[l_ac2].* = g_lid_t.*
                 CLOSE t140_bc3
                 ROLLBACK WORK
                 EXIT DIALOG
              END IF
              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_lid[l_ac2].lid03,-263,1)
                 LET g_lid[l_ac2].* = g_lid_t.*
              ELSE
                 UPDATE lid_file SET lid02 = g_lid[l_ac2].lid02,
                                     lid03 = g_lid[l_ac2].lid03,
                                     lidacti = g_lid[l_ac2].lidacti
                  WHERE lid01=g_lib.lib01
                    AND lid03=g_lid_t.lid03
                 IF SQLCA.SQLCODE THEN
                    CALL cl_err3("upd","lid_file",g_lid_t.lid03,'',SQLCA.SQLCODE,"","",1)
                    LET g_lid[l_ac2].* = g_lid_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF
              END IF
                
          AFTER ROW
              LET l_ac2 = ARR_CURR()
              LET l_ac2_t = l_ac2
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 IF p_cmd = 'u' THEN
                    LET g_lid[l_ac2].* = g_lid_t.*
                 END IF
                 CLOSE t140_bc3
                 ROLLBACK WORK
                 EXIT DIALOG
              END IF
              CLOSE t140_bc3
              COMMIT WORK
              
          ON ACTION controlp
             CASE 
                WHEN INFIELD(lid03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oba01"
                   LET g_qryparam.default1 = g_lid[l_ac2].lid03
                   CALL cl_create_qry() RETURNING g_lid[l_ac2].lid03
                   DISPLAY g_lid[l_ac2].lid03 TO lid03
                   NEXT FIELD lid03
             END CASE

         ON ACTION accept
            ACCEPT DIALOG
                  
         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_lid.deleteElement(l_ac2)
            END IF
            EXIT DIALOG
   
      END INPUT
 
      BEFORE DIALOG
         CASE g_flag_b
            WHEN '1'
               NEXT FIELD lic02
            WHEN '2'
               NEXT FIELD lid02
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
                
      ON ACTION CONTROLG
         CALL cl_cmdask()
          
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
                
      ON ACTION about
         CALL cl_about()
             
      ON ACTION HELP
         CALL cl_show_help()
                                         
      ON ACTION CONTROLS
         CALL cl_set_head_visible("","AUTO")

   END DIALOG

   IF p_cmd = 'u' THEN
      LET g_lib.libmodu = g_user
      LET g_lib.libdate = g_today
      UPDATE lib_file SET libmodu = g_lib.libmodu,
                          libdate = g_lib.libdate
         WHERE lib01 = g_lib.lib01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","lib_file",g_lib.lib01,"",SQLCA.SQLCODE,"","upd lib",1)
      END IF
      DISPLAY BY NAME g_lib.libmodu,g_lib.libdate
   END IF

   CLOSE t140_bc2
   CLOSE t140_bc3
   COMMIT WORK  

END FUNCTION
#TQC-C20528 Add End -----

#FUN-B80141
