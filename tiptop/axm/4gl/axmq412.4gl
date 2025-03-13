# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axmq412.4gl
# Descriptions...: 訂單明細查詢
# Date & Author..: No.FUN-870007 09/02/24 By Zhangyajun
# Modify.........: No.FUN-870100 09/09/02 By Cockroach 流通別超市移植 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0163 10/01/04 By Cockroach 無詳細資料時按鈕無效
# Modify.........: No.TQC-A10070 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A10008 10/01/08 By Cockroach 無詳細資料時按鈕無效
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤
# Modify.........: No.FUN-C60062 12/06/19 By yangxf 将作业artq610——>axmq412
# Modify.........: No.TQC-C70170 12/08/10 By yangtt 将作业ART——>AXM

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   DYNAMIC ARRAY OF RECORD        #
               oeaplant       LIKE oea_file.oeaplant,
               oeaplant_desc  LIKE azp_file.azp02,
               oea02        LIKE oea_file.oea02,
               oea01        LIKE oea_file.oea01,
               oea00        LIKE oea_file.oea00,
               oea08        LIKE oea_file.oea08,
               oea11        LIKE oea_file.oea11,              
               oea12        LIKE oea_file.oea12,    
               oea03        LIKE oea_file.oea03,
               oea03_desc   LIKE occ_file.occ03,
               occ930       LIKE occ_file.occ930,
               occ930_type  LIKE type_file.chr1,
               oea85        LIKE oea_file.oea85,
               oea04        LIKE oea_file.oea04,
               oea17        LIKE oea_file.oea17,
               oea1004      LIKE oea_file.oea1004,
               oea83        LIKE oea_file.oea83,
               oea84        LIKE oea_file.oea84,
               oea86        LIKE oea_file.oea86,
               oea87        LIKE oea_file.oea87,
               oea88        LIKE oea_file.oea88,
               oea89        LIKE oea_file.oea89,
               oea33        LIKE oea_file.oea33,
               oea161       LIKE oea_file.oea161,
               oea162       LIKE oea_file.oea162,
               oea163       LIKE oea_file.oea163,
               oea21        LIKE oea_file.oea21,
               oea211       LIKE oea_file.oea211,
               oea213       LIKE oea_file.oea213,
               oea23        LIKE oea_file.oea23,
               oea24        LIKE oea_file.oea24,
               oea61        LIKE oea_file.oea61,
               oea62        LIKE oea_file.oea62,
               oea14        LIKE oea_file.oea14,
               oea14_desc   LIKE gen_file.gen02,
               oea15        LIKE oea_file.oea15,           
               oea15_desc   LIKE gem_file.gem02,
               oea40        LIKE oea_file.oea40,
               oeaconf      LIKE oea_file.oeaconf,
               oea72        LIKE oea_file.oea72,
               oeacont      LIKE oea_file.oeacont,
               oeaconu      LIKE oea_file.oeaconu,
               oeaconu_desc LIKE gen_file.gen02,
               oea901       LIKE oea_file.oea901,
               oea904       LIKE oea_file.oea904,
               oea905       LIKE oea_file.oea905,
               oea99        LIKE oea_file.oea99,
               oeaprsw      LIKE oea_file.oeaprsw,
               oeaud01      LIKE oea_file.oeaud01
               END RECORD,
       g_oeb   DYNAMIC ARRAY OF RECORD        # 明細
               oeb03      LIKE oeb_file.oeb03,
               oeb04      LIKE oeb_file.oeb04,
               oeb06      LIKE oeb_file.oeb06,
               ima021     LIKE ima_file.ima021,
               oeb05      LIKE oeb_file.oeb05,
               oeb05_desc LIKE gfe_file.gfe02,
               oeb05_fac  LIKE oeb_file.oeb05_fac,
               oeb12      LIKE oeb_file.oeb12,
               oeb13      LIKE oeb_file.oeb13,
               oeb14      LIKE oeb_file.oeb14,
               oeb14t     LIKE oeb_file.oeb14t,
               oeb15      LIKE oeb_file.oeb15,
               oeb09      LIKE oeb_file.oeb09,
               oeb09_desc LIKE imd_file.imd02,
               oeb091     LIKE oeb_file.oeb091,
               oeb092     LIKE oeb_file.oeb092,
               oeb1008    LIKE oeb_file.oeb1008,
               oeb1009    LIKE oeb_file.oeb1009,
               oeb1010    LIKE oeb_file.oeb1010,
               oeb1012    LIKE oeb_file.oeb1012,
               oeb24      LIKE oeb_file.oeb24,
               oeb25      LIKE oeb_file.oeb25,
               oeb27      LIKE oeb_file.oeb27,
               oeb28      LIKE oeb_file.oeb28,
               oeb44      LIKE oeb_file.oeb44,
               oeb45      LIKE oeb_file.oeb45,
               oeb46      LIKE oeb_file.oeb46,
               oeb47      LIKE oeb_file.oeb47,
              #oeb52      LIKE oeb_file.oeb52,
              #oeb53      LIKE oeb_file.oeb53,
              #oeb54      LIKE oeb_file.oeb54,
              #oeb55      LIKE oeb_file.oeb55,
              #oeb56      LIKE oeb_file.oeb56,
              #oeb48      LIKE oeb_file.oeb48,
              #oeb49      LIKE oeb_file.oeb49,
              #oeb50      LIKE oeb_file.oeb50,
              #oeb51      LIKE oeb_file.oeb51,
               oeb1002    LIKE oeb_file.oeb1002,
              #oeb67      LIKE oeb_file.oeb67,
               oeb48      LIKE oeb_file.oeb48, #add
               oeb70      LIKE oeb_file.oeb70
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_dbs  LIKE azp_file.azp03
DEFINE g_sql2 STRING 
DEFINE g_chk_oeaplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_argv1 LIKE oea_file.oea01
DEFINE g_argv2 LIKE oea_file.oeaplant 
DEFINE g_flag STRING
DEFINE l_cmd STRING
 
MAIN
 
   OPTIONS                     
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN   #TQC-C70170 mod ART -> AXM
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q412_w AT p_row,p_col WITH FORM "axm/42f/axmq412"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q412_q()
   END IF
   CALL q412_menu()
 
   CLOSE WINDOW q412_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q412_menu()
 
   WHILE TRUE
      CASE g_flag
        WHEN "page1" CALL q412_bp()
        WHEN "page2" CALL q412_bp2()
        OTHERWISE    CALL q412_bp()
      END CASE
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q412_q()
            END IF
         WHEN "money_detail"
           #FUN-9C0163 ADD --------------------------   
            IF l_ac>0 THEN
               IF cl_null(g_oea[l_ac].oea01) THEN 
                  CALL cl_err('',-400,1)
               ELSE
                  CALL s_pay_detail('01',g_oea[l_ac].oea01,g_oea[l_ac].oeaplant,g_oea[l_ac].oeaconf)
               END IF
            END IF
           #FUN-9C0163 END--------------------------
         WHEN "ship_detail"
           #FUN-A10008  ADD --------------------------
            IF l_ac>0 THEN
               IF cl_null(g_oea[l_ac].oea01) THEN
                  CALL cl_err('',-400,1)
               ELSE
                  LET l_cmd = "artq613 '",g_oea[l_ac].oea01,"' '",g_oea[l_ac].oeaplant,"'"
                  CALL cl_cmdrun(l_cmd)
               END IF
            END IF
           #FUN-A10008  ADD --------------------------
         WHEN "view1"
            LET g_flag = "page2"
 
         WHEN "return"
            LET g_flag = "page1"
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oea),base.TypeInfo.create(g_oeb),'')
            END IF
#FUN-B90091 add END 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q412_q()
 
   CALL q412_b_askkey()
 
END FUNCTION
 
FUNCTION q412_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
   CLEAR FORM
   CALL g_oea.clear()
   CALL g_oeb.clear()
 
   LET g_chk_oeaplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " oea01 = '",g_argv1,"' AND oeaplant = '",g_argv2,"'"
      LET g_wc2 = " 1=1"
      LET g_chk_oeaplant = FALSE
   ELSE   
   CONSTRUCT g_wc ON oeaplant, oea02, oea01,  oea00,
                     oea08,  oea11, oea12,  oea03,
                     oea85,  oea04, oea17,  oea1004,
                     oea83,  oea84, oea86,  oea87,
                     oea88,  oea89, oea33,  oea161,
                     oea162, oea163,oea21,  oea211,
                     oea213, oea23, oea24,  oea61,
                     oea62,  oea14, oea15,  oea40,
                     oeaconf,oea72, oeacont,oeaconu,
                     oea901, oea904,oea905, oea99,
                     oeaprsw,oeaud01
                FROM s_oea[1].oeaplant, s_oea[1].oea02, s_oea[1].oea01,  s_oea[1].oea00,
                     s_oea[1].oea08,  s_oea[1].oea11, s_oea[1].oea12,  s_oea[1].oea03,
                     s_oea[1].oea85,  s_oea[1].oea04, s_oea[1].oea17,  s_oea[1].oea1004,        
                     s_oea[1].oea83,  s_oea[1].oea84, s_oea[1].oea86,  s_oea[1].oea87,
                     s_oea[1].oea88,  s_oea[1].oea89, s_oea[1].oea33,  s_oea[1].oea161,
                     s_oea[1].oea162, s_oea[1].oea163,s_oea[1].oea21,  s_oea[1].oea211,
                     s_oea[1].oea213, s_oea[1].oea23, s_oea[1].oea24,  s_oea[1].oea61,
                     s_oea[1].oea62,  s_oea[1].oea14, s_oea[1].oea15,  s_oea[1].oea40,
                     s_oea[1].oeaconf,s_oea[1].oea72, s_oea[1].oeacont,s_oea[1].oeaconu,
                     s_oea[1].oea901, s_oea[1].oea904,s_oea[1].oea905, s_oea[1].oea99,
                     s_oea[1].oeaprsw,s_oea[1].oeaud01
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD oeaplant
         IF get_fldbuf(oeaplant) IS NOT NULL THEN
            LET g_chk_oeaplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oeaplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeaplant
                   NEXT FIELD oeaplant
 
              WHEN INFIELD(oea03)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea03
                   NEXT FIELD oea03
 
              WHEN INFIELD(oea04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea04
                   NEXT FIELD oea04
 
              WHEN INFIELD(oea17)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea17
                   NEXT FIELD oea17
 
              WHEN INFIELD(oea1004)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea1004
                   NEXT FIELD oea1004
                   
              WHEN INFIELD(oea83)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea83
                   NEXT FIELD oea83    
              
              WHEN INFIELD(oea84)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea84
                   NEXT FIELD oea84
              
              WHEN INFIELD(oea86)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_tqa"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.arg1 = "23"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea86
                   NEXT FIELD oea86
              
              WHEN INFIELD(oea87)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lpj02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea87
                   NEXT FIELD oea87
                   
              WHEN INFIELD(oea21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gec001"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea21
                   NEXT FIELD oea21
                   
              WHEN INFIELD(oea23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea23                
                   NEXT FIELD oea23  
                   
              WHEN INFIELD(oea14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea14
                   NEXT FIELD oea14   
                    
              WHEN INFIELD(oea15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea15
                   NEXT FIELD oea15  
                       
              WHEN INFIELD(oea904)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_poz"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oea904
                   NEXT FIELD oea904   
                   
              WHEN INFIELD(oeaconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeaconu
                   NEXT FIELD oeaconu
                   
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
         
      ON ACTION qbe_select                         	  
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   
   CONSTRUCT g_wc2 ON oeb03,    oeb04,  oeb06,  oeb05,
                      oeb05_fac,oeb12,  oeb13,  oeb14,
                      oeb14t,   oeb15,  oeb09,  oeb091,
                      oeb092,   oeb1008,oeb1009,oeb1010,
                      oeb1012,  oeb24,  oeb25,  oeb27,
                      oeb28,    oeb44,  oeb45,  oeb46,
                      oeb47,   
                               # oeb52,  oeb53,  oeb54,
                     #oeb55,    oeb56,  oeb48,  oeb49,
                     #oeb50,    oeb51, 
                      oeb1002,
                     #oeb67,
                      oeb48,
                      oeb70
                 FROM s_oeb[1].oeb03,    s_oeb[1].oeb04,  s_oeb[1].oeb06,  s_oeb[1].oeb05,
                      s_oeb[1].oeb05_fac,s_oeb[1].oeb12,  s_oeb[1].oeb13,  s_oeb[1].oeb14,
                      s_oeb[1].oeb14t,   s_oeb[1].oeb15,  s_oeb[1].oeb09,  s_oeb[1].oeb091, 
                      s_oeb[1].oeb092,   s_oeb[1].oeb1008,s_oeb[1].oeb1009,s_oeb[1].oeb1010,                      
                      s_oeb[1].oeb1012,  s_oeb[1].oeb24,  s_oeb[1].oeb25,  s_oeb[1].oeb27,
                      s_oeb[1].oeb28,    s_oeb[1].oeb44,  s_oeb[1].oeb45,  s_oeb[1].oeb46,
                      s_oeb[1].oeb47,    #s_oeb[1].oeb52,  s_oeb[1].oeb53,  s_oeb[1].oeb54,
                     #s_oeb[1].oeb55,    s_oeb[1].oeb56,  s_oeb[1].oeb48,  s_oeb[1].oeb49,
                     # s_oeb[1].oeb50,    s_oeb[1].oeb51, 
                      s_oeb[1].oeb1002,  s_oeb[1].oeb48,
                      s_oeb[1].oeb70
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(oeb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb04
                 NEXT FIELD oeb04
              WHEN INFIELD(oeb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb05
                 NEXT FIELD oeb05
              WHEN INFIELD(oeb09)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_imd"     #FUN-AA0062 mark
                 LET g_qryparam.form = "q_imd003"  #FUN-AA0062 add
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = 'SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb09
                 NEXT FIELD oeb09
              WHEN INFIELD(oeb1008)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gec001"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb1008
                 NEXT FIELD oeb1008
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
        ON ACTION about         
          CALL cl_about()      
 
        ON ACTION help         
          CALL cl_show_help()
 
        ON ACTION controlg   
          CALL cl_cmdask() 
 
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
		
    END CONSTRUCT
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #       LET g_wc = g_wc CLIPPED," AND oeauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #       LET g_wc = g_wc CLIPPED," AND oeagrup MATCHES '",
    #                 g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN
    #       LET g_wc = g_wc CLIPPED," AND oeagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
    #End:FUN-980030
    LET g_chk_auth = ''
    IF g_chk_oeaplant THEN
      DECLARE q412_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q412_zxy_cs INTO l_zxy03
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
        IF g_chk_auth IS NULL THEN
           LET g_chk_auth = "'",l_zxy03,"'"
        ELSE
           LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
        END IF
      END FOREACH
      IF g_chk_auth IS NOT NULL THEN
         LET g_chk_auth = "(",g_chk_auth,")"
      END IF
    END IF
  
    LET l_ac = 1 
    CALL q412_b_fill(g_wc,g_wc2)
    CALL q412_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q412_b_fill(p_wc,p_wc2)              
DEFINE p_wc,p_wc2 STRING        
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03 LIKE azp_file.azp03      #TQC-B90175 add
 
    LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file ",
                " WHERE zxy01 = '",g_user,"' " 
    IF NOT cl_null(g_argv2) THEN
       LET g_sql = g_sql," AND zxy03 = '",g_argv1,"'"
    END IF
    PREPARE q412_pre FROM g_sql
    DECLARE q412_DB_cs CURSOR FOR q412_pre
    LET g_sql2 = ''
   #FOREACH q412_DB_cs INTO g_dbs    #TQC-A10070 MARK
    FOREACH q412_DB_cs INTO l_zxy03  #TQC-A10070 ADD
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q412_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF 
#TQC-B90175 add START------------------------------
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
     IF NOT cl_chk_schema_has_built(l_azp03) THEN
        CONTINUE FOREACH
     END IF
#TQC-B90175 add END--------------------------------
      #FUN-A50102 ---mark---str--- 
      #TQC-A10070 ADD-------------
       #LET g_plant_new = l_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs =g_dbs_tra
       #LET g_dbs = s_dbstring(g_dbs CLIPPED)
      #TQC-A10070 ADD-------------  
      #FUN-A50102 ---mark---end---
       IF p_wc2 = " 1=1" THEN
           LET g_sql = "SELECT oeaplant,'',oea02,oea01,oea00,oea08,oea11,oea12,oea03,'','','',",
                       "       oea85,oea04,oea17,oea1004,oea83,oea84,oea86,oea87,oea88,oea89,",
                       "       oea33,oea161,oea162,oea163,oea21,oea211,oea213,oea23,oea24,oea61,",
                       "       oea62,oea14,'',oea15,'',oea40,oeaconf,oea72,oeacont,oeaconu,'',",
                       "       oea901,oea904,oea905,oea99,oeaprsw,oeaud01",
                       #"  FROM ",g_dbs CLIPPED,"oea_file,azp_file", #FUN-A50102
                        "  FROM ",cl_get_target_table(l_zxy03, 'oea_file'),",","azp_file", #FUN-A50102
                       " WHERE oeaplant = azp01 AND azp01 = '",l_zxy03 CLIPPED,"'",
                       "   AND ",p_wc
       ELSE
           LET g_sql = "SELECT oeaplant,'',oea02,oea01,oea00,oea08,oea11,oea12,oea03,'','','',",
                       "       oea85,oea04,oea17,oea1004,oea83,oea84,oea86,oea87,oea88,oea89,",
                       "       oea33,oea161,oea162,oea163,oea21,oea211,oea213,oea23,oea24,oea61,",
                       "       oea62,oea14,'',oea15,'',oea40,oeaconf,oea72,oeacont,oeaconu,'',",
                       "       oea901,oea904,oea905,oea99,oeaprsw,oeaud01",
                       #"  FROM ",g_dbs CLIPPED,"oea_file,",g_dbs CLIPPED,"oeb_file,azp_file", #FUN-A50102
                       "  FROM ",cl_get_target_table(l_zxy03, 'oea_file'),",",cl_get_target_table(l_zxy03, 'oeb_file'),",","azp_file", #FUN-A50102
                       " WHERE oea01 = oeb01 AND oeaplant = oebplant",
                       "   AND oeaplant = azp01 AND azp01 = '",l_zxy03 CLIPPED,"'",
                       "   AND ",p_wc," AND ",p_wc2
       END IF
       IF g_chk_oeaplant THEN
          LET g_sql = "(",g_sql," AND oeaplant IN ",g_chk_auth,")"
       ELSE
          LET g_sql = "(",g_sql,")"
       END IF
       IF g_sql2 IS NULL THEN
          LET g_sql2 = g_sql
       ELSE
          LET g_sql = g_sql2," UNION ALL ",g_sql
          LET g_sql2 = g_sql
       END IF
    END FOREACH
    
    PREPARE q412_pb FROM g_sql
    DECLARE q412_cs CURSOR FOR q412_pb
 
    CALL g_oea.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q412_cs INTO g_oea[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q412_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT azp02
          INTO g_oea[g_cnt].oeaplant_desc
          FROM azp_file
         WHERE azp01 = g_oea[g_cnt].oeaplant
        #FUN-A50102 ---mark---str---
        #TQC-A10070 ADD----------------------
        #LET g_plant_new = g_oea[g_cnt].oeaplant
        #CALL s_gettrandbs()
        #LET l_dbs = g_dbs_tra
        #LET l_dbs = s_dbstring(l_dbs CLIPPED)
        #TQC-A10070 ADD---------------------- 
        #FUN-A50102 ---mark---end---
        SELECT gen02 INTO g_oea[g_cnt].oea14_desc
          FROM gen_file
         WHERE gen01 = g_oea[g_cnt].oea14
           AND genacti = 'Y'
        SELECT gen02 INTO g_oea[g_cnt].oeaconu_desc
          FROM gen_file
         WHERE gen01 = g_oea[g_cnt].oeaconu
           AND genacti = 'Y'
        SELECT gem02 INTO g_oea[g_cnt].oea15_desc
          FROM gem_file
         WHERE gem01 = g_oea[g_cnt].oea15
           AND gemacti = 'Y'
        #LET g_sql = "SELECT occ02,occ930 FROM ",l_dbs CLIPPED,"occ_file", #FUN-A50102
         LET g_sql = "SELECT occ02,occ930 FROM ",cl_get_target_table(g_oea[g_cnt].oeaplant, 'occ_file'), #FUN-A50102
                " WHERE occ01 = ? AND occacti = 'Y'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_oea[g_cnt].oeaplant) RETURNING g_sql  #FUN-A50102        
        PREPARE q412_occ_cs FROM g_sql
        EXECUTE q412_occ_cs USING g_oea[g_cnt].oea03
                             INTO g_oea[g_cnt].oea03_desc,g_oea[g_cnt].occ930
        IF g_oea[g_cnt].occ930 IS NULL THEN
           LET g_oea[g_cnt].occ930_type = '1'
        ELSE
           LET g_oea[g_cnt].occ930_type = '2'
        END IF           
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_oea.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q412_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03  
   #TQC-A10070 MARK AND ADD---------------------- 
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oea[l_ac].oeaplant 
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oea[l_ac].oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
    #LET l_dbs = s_dbstring(l_dbs CLIPPED)
    #FUN-A50102 ---mark---end---
   #TQC-A10070 MARK AND ADD---------------------- 
    LET g_sql = "SELECT oeb03,oeb04,oeb06,'',oeb05,'',oeb05_fac,oeb12,oeb13,",
                "       oeb14,oeb14t,oeb15,oeb09,'',oeb091,oeb092,oeb1008,oeb1009,",
                "       oeb1010,oeb1012,oeb24,oeb25,oeb27,oeb28,oeb44,oeb45,oeb46,",
                "       oeb47,oeb1002,", #oeb52,oeb53,oeb54,oeb55,oeb56,oeb48,oeb49,oeb50,oeb1002,",
                "       oeb48,oeb70",
               #"  FROM ",l_dbs CLIPPED,"oeb_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_oea[l_ac].oeaplant, 'oeb_file'), #FUN-A50102
                " WHERE oeb01 = '",g_oea[l_ac].oea01,"'",
                "   AND oebplant = '",g_oea[l_ac].oeaplant,"'",
                "   AND ",p_wc2 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea[l_ac].oeaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q412_pb2 FROM g_sql
    DECLARE q412_cs2 CURSOR FOR q412_pb2
    
    #LET g_sql = "SELECT ima021 FROM ",l_dbs CLIPPED,"ima_file", #FUN-A50102
    LET g_sql = "SELECT ima021 FROM ",cl_get_target_table(g_oea[l_ac].oeaplant, 'ima_file'), #FUN-A50102 
                " WHERE ima01 = ? AND imaacti = 'Y'" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea[l_ac].oeaplant) RETURNING g_sql  #FUN-A50102
    PREPARE q412_ima021_cs FROM g_sql
    
    CALL g_oeb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q412_cs2 INTO g_oeb[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q412_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF       
        EXECUTE q412_ima021_cs USING g_oeb[g_cnt].oeb04
                                INTO g_oeb[g_cnt].ima021
        SELECT gfe02 INTO g_oeb[g_cnt].oeb05_desc
          FROM gfe_file
         WHERE gfe01 = g_oeb[g_cnt].oeb05   
           AND gfeacti = 'Y'        
        SELECT imd02 INTO g_oeb[g_cnt].oeb09_desc
          FROM imd_file
         WHERE imd01 = g_oeb[g_cnt].oeb09
           AND imdacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_oeb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q412_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION ship_detail
         LET g_action_choice = "ship_detail"
         EXIT DISPLAY
 
      ON ACTION return
         LET g_action_choice = "return"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="return"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION q412_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b!=0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q412_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
        
      ON ACTION money_detail
         LET g_action_choice = "money_detail"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
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
 
      ON ACTION view1
         LET g_action_choice = "view1"
         EXIT DISPLAY
 
#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#FUN-C60062
#FUN-870100
