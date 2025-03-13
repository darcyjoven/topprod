# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: artq620.4gl
# Descriptions...: 銷售明細查詢
# Date & Author..: No.FUN-870007 09/02/27 By Zhangyajun
# Modify.........: No.FUN-870100 09/09/02 By Cockroach 流通別超市移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10070 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No.MOD-AB0131 10/11/16 By lilingyu sql變量定義為string類型,仍然過短,無法組合出正確的sql語句
# Modify.........: No.TQC-AB0025 10/12/17 By chenying 查詢時程序擋出
#                                10/12/20 By 點右側款別明細功能鈕，程序DOWN出
# Modify.........: No.MOD-B30321 11/03/12 By baogc 修改bug
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga   DYNAMIC ARRAY OF RECORD        #
               ogaplant       LIKE oga_file.ogaplant,
               ogaplant_desc  LIKE azp_file.azp02,
               oga02        LIKE oga_file.oga02,
               oga00        LIKE oga_file.oga00,
               oga01        LIKE oga_file.oga01,    
               oga03        LIKE oga_file.oga03,
               oga032       LIKE oga_file.oga032,
               occ930       LIKE occ_file.occ930,
               occ930_type  LIKE type_file.chr1,
               oga85        LIKE oga_file.oga85,
               oga04        LIKE oga_file.oga04,
               oga18        LIKE oga_file.oga18,
               oga08        LIKE oga_file.oga08,
               oga09        LIKE oga_file.oga09,
               oga10        LIKE oga_file.oga10,
               oga14        LIKE oga_file.oga14,
               oga14_desc   LIKE gen_file.gen02,
               oga15        LIKE oga_file.oga15,           
               oga15_desc   LIKE gem_file.gem02,
               oga16        LIKE oga_file.oga16,
               oga161       LIKE oga_file.oga161,
               oga162       LIKE oga_file.oga162,
               oga163       LIKE oga_file.oga163,
               oga21        LIKE oga_file.oga21,
               oga211       LIKE oga_file.oga211,
               oga213       LIKE oga_file.oga213,
               oga23        LIKE oga_file.oga23,
               oga24        LIKE oga_file.oga24,
               oga50        LIKE oga_file.oga50,
               oga501       LIKE oga_file.oga501,
               oga51        LIKE oga_file.oga51,
               oga511       LIKE oga_file.oga511,
               oga70        LIKE oga_file.oga70,
               oga83        LIKE oga_file.oga83,
               oga84        LIKE oga_file.oga84,
               oga86        LIKE oga_file.oga86,
               oga87        LIKE oga_file.oga87,
               oga88        LIKE oga_file.oga88,
               oga89        LIKE oga_file.oga89,
               oga94        LIKE oga_file.oga94,
               oga95        LIKE oga_file.oga95,
               oga96        LIKE oga_file.oga96,
               oga97        LIKE oga_file.oga97,
               oga99        LIKE oga_file.oga99,
               oga909       LIKE oga_file.oga909,
               ogapost      LIKE oga_file.ogapost,
               ogaconf      LIKE oga_file.ogaconf,
               ogacond      LIKE oga_file.ogacond,
               ogaconu      LIKE oga_file.ogaconu,
               ogaconu_desc LIKE gen_file.gen02,               
               ogaprsw      LIKE oga_file.ogaprsw
               END RECORD,
       g_ogb   DYNAMIC ARRAY OF RECORD        # 
               ogb03      LIKE ogb_file.ogb03,
               ogb04      LIKE ogb_file.ogb04,
               ogb06      LIKE ogb_file.ogb06,
               ima021     LIKE ima_file.ima021,
               ogb05      LIKE ogb_file.ogb05,
               ogb05_desc LIKE gfe_file.gfe02,
               ogb05_fac  LIKE ogb_file.ogb05_fac,              
               ogb12      LIKE ogb_file.ogb12,
               ogb09      LIKE ogb_file.ogb09,
               ogb09_desc LIKE imd_file.imd02,
               ogb091     LIKE ogb_file.ogb091,
               ogb092     LIKE ogb_file.ogb092,
               ogb13      LIKE ogb_file.ogb13,
               ogb14      LIKE ogb_file.ogb14,
               ogb14t     LIKE ogb_file.ogb14t,              
               ogb1008    LIKE ogb_file.ogb1008,
               ogb1009    LIKE ogb_file.ogb1009,
               ogb1010    LIKE ogb_file.ogb1010,
               ogb1012    LIKE ogb_file.ogb1012,
               ogb31      LIKE ogb_file.ogb31,
               ogb32      LIKE ogb_file.ogb32,
               ogb44      LIKE ogb_file.ogb44,
               ogb45      LIKE ogb_file.ogb45,
               ogb46      LIKE ogb_file.ogb46,
               ogb47      LIKE ogb_file.ogb47
              #ogb48      LIKE ogb_file.ogb48,
              #ogb49      LIKE ogb_file.ogb49,
              #ogb50      LIKE ogb_file.ogb50,
              #ogb51      LIKE ogb_file.ogb51,
              #ogb52      LIKE ogb_file.ogb52,
              #ogb53      LIKE ogb_file.ogb53,
              #ogb54      LIKE ogb_file.ogb54,
              #ogb55      LIKE ogb_file.ogb55,
              #ogb56      LIKE ogb_file.ogb56
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
#DEFINE g_dbs  LIKE azp_file.azp03 #FUN-A50102
#DEFINE g_sql2 STRING              #MOD-AB0131
DEFINE g_chk_ogaplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_argv1 LIKE oga_file.oga01
DEFINE g_argv2 LIKE oga_file.ogaplant
DEFINE g_flag STRING
 
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
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q620_w AT p_row,p_col WITH FORM "art/42f/artq620"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q620_q()
   END IF
   CALL q620_menu()
 
   CLOSE WINDOW q620_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q620_menu()
 
   WHILE TRUE
      CASE g_flag
        WHEN "page1" CALL q620_bp()
        WHEN "page2" CALL q620_bp2()
        OTHERWISE    CALL q620_bp()
      END CASE
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q620_q()
            END IF
         WHEN "money_detail"
            LET l_ac = ARR_CURR()                                    #TQC-AB0025 add
            IF NOT cl_null(l_ac) AND  l_ac != 0 THEN                 #TQC-AB0025 add
               CALL s_pay_detail('02',g_oga[l_ac].oga01,g_oga[l_ac].ogaplant,g_oga[l_ac].ogaconf)
            END IF                                                   #TQC-AB0025 add

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
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oga),base.TypeInfo.create(g_ogb),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q620_q()
 
   CALL q620_b_askkey()
 
END FUNCTION
 
FUNCTION q620_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03 LIKE azp_file.azp03      #TQC-B90175 add 
   CLEAR FORM
   CALL g_oga.clear()
   CALL g_ogb.clear()
 
   LET g_chk_ogaplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " oga01 = '",g_argv1,"' AND ogaplant = '",g_argv2,"'"
      LET g_wc = " 1=1"
      LET g_chk_ogaplant = FALSE
   ELSE   
   CONSTRUCT g_wc ON ogaplant, oga02,  oga00,  oga01,
                     oga03,  oga032, oga85,  oga04,
                     oga18,  oga08,  oga09,  oga10,
                     oga14,  oga15,  oga16,  oga161,
                     oga162, oga163, oga21,  oga211,
                     oga213, oga23,  oga24,  oga50,
                     oga501, oga51,  oga511, oga70,
                     oga83,  oga84,  oga86,  oga87,
                     oga88,  oga89,  oga94,  oga95,
                     oga96,  oga97,  oga99,  oga909,
                     ogapost,ogaconf,ogacond,ogaconu,
                     ogaprsw                     
                FROM s_oga[1].ogaplant, s_oga[1].oga02,  s_oga[1].oga00,  s_oga[1].oga01,
                     s_oga[1].oga03,  s_oga[1].oga032, s_oga[1].oga85,  s_oga[1].oga04,
                     s_oga[1].oga18,  s_oga[1].oga08,  s_oga[1].oga09,  s_oga[1].oga10,        
                     s_oga[1].oga14,  s_oga[1].oga15,  s_oga[1].oga16,  s_oga[1].oga161,
                     s_oga[1].oga162, s_oga[1].oga163, s_oga[1].oga21,  s_oga[1].oga211,
                     s_oga[1].oga213, s_oga[1].oga23,  s_oga[1].oga24,  s_oga[1].oga50,
                     s_oga[1].oga501, s_oga[1].oga51,  s_oga[1].oga511, s_oga[1].oga70,
                     s_oga[1].oga83,  s_oga[1].oga84,  s_oga[1].oga86,  s_oga[1].oga87,
                     s_oga[1].oga88,  s_oga[1].oga89,  s_oga[1].oga94,  s_oga[1].oga95,
                     s_oga[1].oga96,  s_oga[1].oga97,  s_oga[1].oga99,  s_oga[1].oga909,
                     s_oga[1].ogapost,s_oga[1].ogaconf,s_oga[1].ogacond,s_oga[1].ogaconu,
                     s_oga[1].ogaprsw
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD ogaplant
         IF get_fldbuf(ogaplant) IS NOT NULL THEN
            LET g_chk_ogaplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ogaplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogaplant
                   NEXT FIELD ogaplant
 
              WHEN INFIELD(oga03)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga03
                   NEXT FIELD oga03
 
              WHEN INFIELD(oga04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga04
                   NEXT FIELD oga04
 
              WHEN INFIELD(oga18)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga18
                   NEXT FIELD oga18  
              
              WHEN INFIELD(oga83)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga83
                   NEXT FIELD oga83
              
              WHEN INFIELD(oga84)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga84
                   NEXT FIELD oga84
                   
              WHEN INFIELD(oga86)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_tqa"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.arg1 = "23"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga86
                   NEXT FIELD oga86     
                   
              WHEN INFIELD(oga87)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lpj02"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga87
                   NEXT FIELD oga87
                   
              WHEN INFIELD(oga21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gec001"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga21
                   NEXT FIELD oga21
                   
              WHEN INFIELD(oga23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga23                
                   NEXT FIELD oga23  
                   
              WHEN INFIELD(oga14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga14
                   NEXT FIELD oga14   
                    
              WHEN INFIELD(oga15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga15
                   NEXT FIELD oga15    
                   
              WHEN INFIELD(ogaconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogaconu
                   NEXT FIELD ogaconu
                   
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
   
   CONSTRUCT g_wc2 ON ogb03,    ogb04,  ogb06,  ogb05,
                      ogb05_fac,ogb12,  ogb09,  ogb091,
                      ogb092,   ogb13,  ogb14,  ogb14t,
                      ogb1008,  ogb1009,ogb1010,ogb1012,  
                      ogb31,    ogb32,  ogb44,  ogb45,
                      ogb46,    ogb47   # ,  ogb48,  ogb49,
                     # ogb50,    ogb51,  ogb52,  ogb53,
                     # ogb54,    ogb55,  ogb56  
                 FROM s_ogb[1].ogb03,    s_ogb[1].ogb04,  s_ogb[1].ogb06,  s_ogb[1].ogb05,
                      s_ogb[1].ogb05_fac,s_ogb[1].ogb12,  s_ogb[1].ogb09,  s_ogb[1].ogb091, 
                      s_ogb[1].ogb092,   s_ogb[1].ogb13,  s_ogb[1].ogb14,  s_ogb[1].ogb14t,   
                      s_ogb[1].ogb1008,  s_ogb[1].ogb1009,s_ogb[1].ogb1010,s_ogb[1].ogb1012,                        
                      s_ogb[1].ogb31,    s_ogb[1].ogb32,  s_ogb[1].ogb44,  s_ogb[1].ogb45,     
                      s_ogb[1].ogb46,    s_ogb[1].ogb47   # ,  s_ogb[1].ogb48,  s_ogb[1].ogb49,
                     # s_ogb[1].ogb50,    s_ogb[1].ogb51,  s_ogb[1].ogb52,  s_ogb[1].ogb53,  
                     # s_ogb[1].ogb54,    s_ogb[1].ogb55,  s_ogb[1].ogb56
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(ogb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb04
                 NEXT FIELD ogb04
              WHEN INFIELD(ogb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb05
                 NEXT FIELD ogb05
              WHEN INFIELD(ogb09)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd"    #FUN-AA0062 mark
                 LET g_qryparam.form = "q_imd003"  #FUN-AA0062 add
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = 'SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb09
                 NEXT FIELD ogb09
              WHEN INFIELD(ogb1008)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gec001"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ogb1008
                 NEXT FIELD ogb1008
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
    #       LET g_wc = g_wc CLIPPED," AND ogauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #       LET g_wc = g_wc CLIPPED," AND ogagrup MATCHES '",
    #                 g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN
    #       LET g_wc = g_wc CLIPPED," AND ogagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
    #End:FUN-980030
    LET g_chk_auth = ''
    IF g_chk_ogaplant THEN
      DECLARE q620_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q620_zxy_cs INTO l_zxy03
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
    CALL q620_b_fill(g_wc,g_wc2)
    CALL q620_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q620_b_fill(p_wc,p_wc2)              
DEFINE p_wc,p_wc2 STRING        
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_zxy03 LIKE zxy_file.zxy03   #TQC-A10070 ADD
DEFINE l_str   LIKE type_file.chr1   #MOD-B30321 ADD
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
    LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file ",
                " WHERE zxy01 = '",g_user,"' "
    IF NOT cl_null(g_argv2) THEN
       LET g_sql = g_sql," zxy03 = '",g_argv2,"'"
    END IF
    PREPARE q620_pre FROM g_sql
    DECLARE q620_DB_cs CURSOR FOR q620_pre

#   LET g_sql2 = ''   #MOD-AB0131 
    CALL g_oga.clear() #MOD-B30321 ADD
    LET g_cnt = 1      #MOD-B30321 ADD
    LET l_str = 'Y'    #MOD-B30321 ADD

    FOREACH q620_DB_cs INTO l_zxy03 
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q620_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
#TQC-B90175 add START------------------------------
        SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
        IF NOT cl_chk_schema_has_built(l_azp03) THEN
          CONTINUE FOREACH
        END IF
#TQC-B90175 add END--------------------------------
      #TQC-A10070 ADD---------- 
       #FUN-A50102 ---mark---str---
       #LET g_plant_new =l_zxy03 
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra
       #LET g_dbs = s_dbstring(g_dbs CLIPPED)
       #FUN-A50102 ---mark---end---
      #TQC-A10070 ADD----------
       IF p_wc2 = " 1=1" THEN
          LET g_sql = "SELECT ogaplant,'',oga02,oga00,oga01,oga03,oga032,'','',oga85,oga04,",
                      "       oga18,oga08,oga09,oga10,oga14,'',oga15,'',oga16,oga161,oga162,oga163,",
                      "       oga21,oga211,oga213,oga23,oga24,oga50,oga501,oga51,oga511,oga70,",
                      "       oga83,oga84,oga86,oga87,oga88,oga89,oga94,oga95,oga96,oga97,",
                      "       oga99,oga909,ogapost,ogaconf,ogacond,ogaconu,'',ogaprsw",
                      #"  FROM ",g_dbs CLIPPED,"oga_file,azp_file", #FUN-A50102
                       "  FROM ",cl_get_target_table(l_zxy03, 'oga_file'),",azp_file", #FUN-A50102
                      " WHERE ogaplant = azp01 AND azp01 = '",l_zxy03 CLIPPED,"'",
                      "   AND ",p_wc
       ELSE
           LET g_sql = "SELECT ogaplant,'',oga02,oga00,oga01,oga03,oga032,'','',oga85,oga04,",
                       "       oga18,oga08,oga09,oga10,oga14,'',oga15,'',oga16,oga161,oga162,oga163,",
                       "       oga21,oga211,oga213,oga23,oga24,oga50,oga501,oga51,oga511,oga70,",
                       "       oga83,oga84,oga86,oga87,oga88,oga89,oga94,oga95,oga96,oga97,",
                       "       oga99,oga909,ogapost,ogaconf,ogacond,ogaconu,'',ogaprsw",
                       #"  FROM ",g_dbs CLIPPED,"oga_file,",g_dbs CLIPPED,"ogb_file,azp_file", #FUN-A50102
                        "  FROM ",cl_get_target_table(l_zxy03, 'oga_file'),",",cl_get_target_table(l_zxy03, 'ogb_file'),",azp_file", #FUN-A50102
                       " WHERE oga01 = ogb01 AND ogaplant = ogbplant",
                       "   AND ogaplant = azp01 AND azp01 = '",l_zxy03 CLIPPED,"'",
                       "   AND ",p_wc," AND ",p_wc2
       END IF
       IF g_chk_ogaplant THEN
          LET g_sql = "(",g_sql," AND ogaplant IN ",g_chk_auth,")"
       ELSE
          LET g_sql = "(",g_sql,")"
       END IF
#MOD-AB0131 --begin--       
#       IF g_sql2 IS NULL THEN
#          LET g_sql2 = g_sql
#       ELSE
#          LET g_sql = g_sql2," UNION ALL ",g_sql
#          LET g_sql2 = g_sql
#       END IF
#    END FOREACH
#MOD-AB0131 --end--
    
    PREPARE q620_pb FROM g_sql
    DECLARE q620_cs CURSOR FOR q620_pb
 
  # CALL g_oga.clear()                                   #MOD-B30321 MARK
  # LET g_cnt = 1                                        #MOD-B30321 MARK
    MESSAGE "Searching!"
    FOREACH q620_cs INTO g_oga[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q620_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT azp02
          INTO g_oga[g_cnt].ogaplant_desc
          FROM azp_file
         WHERE azp01 = g_oga[g_cnt].ogaplant 
       #FUN-A50102 ---mark---str---  
       #TQC-A10070 ADD-----------------
        #LET g_plant_new = g_oga[g_cnt].ogaplant
        #CALL s_gettrandbs()
        #LET l_dbs = g_dbs_tra
        #LET l_dbs = s_dbstring(l_dbs CLIPPED)
       #TQC-A10070 ADD-----------------
       #FUN-A50102 ---mark---end---
        SELECT gen02 INTO g_oga[g_cnt].oga14_desc
          FROM gen_file
         WHERE gen01 = g_oga[g_cnt].oga14
           AND genacti = 'Y'
        SELECT gen02 INTO g_oga[g_cnt].ogaconu_desc
          FROM gen_file
         WHERE gen01 = g_oga[g_cnt].ogaconu
           AND genacti = 'Y'
        SELECT gem02 INTO g_oga[g_cnt].oga15_desc
          FROM gem_file
         WHERE gem01 = g_oga[g_cnt].oga15
           AND gemacti = 'Y'
        #LET g_sql = "SELECT occ930 FROM ",l_dbs CLIPPED,"occ_file", #FUN-A50102 
         LET g_sql = "SELECT occ930 FROM ",cl_get_target_table(g_oga[g_cnt].ogaplant, 'occ_file'), #FUN-A50102
                " WHERE occ01 = ? AND occacti = 'Y'" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_oga[g_cnt].ogaplant) RETURNING g_sql  #FUN-A50102        
        PREPARE q620_occ_cs FROM g_sql
        EXECUTE q620_occ_cs USING g_oga[g_cnt].oga03
                             INTO g_oga[g_cnt].occ930
        IF g_oga[g_cnt].occ930 IS NULL THEN
           LET g_oga[g_cnt].occ930_type = '1'
        ELSE
           LET g_oga[g_cnt].occ930_type = '2'
        END IF           
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           LET l_str = 'N'                   #MOD-B30321 ADD
           EXIT FOREACH
        END IF
    END FOREACH
###-MOD-B30321 - ADD -  BEGIN ------------------------------
    CALL g_oga.deleteElement(g_cnt)
    IF l_str <> 'Y' THEN
       EXIT FOREACH
    END IF
###-MOD-B30321 - ADD -   END  ------------------------------
  END FOREACH   #MOD-AB0131 
  
 #  CALL g_oga.deleteElement(g_cnt)          #MOD-B30321 MARK
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q620_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03  
   #TQC-A10070 MARK&ADD---------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oga[l_ac].ogaplant 
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oga[l_ac].ogaplant
    #CALL s_gettrandbs()
    #LET l_dbs =g_dbs_tra
    #LET l_dbs =s_dbstring(l_dbs CLIPPED)
   #FUN-A50102 ---mark---end---
   #TQC-A10070 MARK&ADD---------------
    LET g_sql = "SELECT ogb03,ogb04,ogb06,'',ogb05,'',ogb05_fac,ogb12,",
                "       ogb09,'',ogb091,ogb092,ogb13,ogb14,ogb14t,ogb1008,ogb1009,",
                "       ogb1010,ogb1012,ogb31,ogb32,ogb44,ogb45,ogb46,",
                "       ogb47",    #ogb48,ogb49,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55,ogb56",
                #"  FROM ",l_dbs CLIPPED,"ogb_file",  #FUN-A50102
                "  FROM ",cl_get_target_table(g_oga[l_ac].ogaplant, 'ogb_file'),  #FUN-A50102
                " WHERE ogb01 = '",g_oga[l_ac].oga01,"'",
                "   AND ogbplant = '",g_oga[l_ac].ogaplant,"'",
                "   AND ",p_wc2 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#   CALL cl_parse_qry_sql(g_sql, g_oga[g_cnt].ogaplant) RETURNING g_sql  #FUN-A50102  #TQC-AB0025 mark          
    CALL cl_parse_qry_sql(g_sql, g_oga[l_ac].ogaplant)  RETURNING g_sql  #TQC-AB0025 add             
    PREPARE q620_pb2 FROM g_sql
    DECLARE q620_cs2 CURSOR FOR q620_pb2
    
    #LET g_sql = "SELECT ima021 FROM ",l_dbs CLIPPED,"ima_file", #FUN-A50102
    LET g_sql = "SELECT ima021 FROM ",cl_get_target_table(g_oga[l_ac].ogaplant, 'ima_file'), #FUN-A50102
                " WHERE ima01 = ? AND imaacti = 'Y'" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oga[l_ac].ogaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q620_ima021_cs FROM g_sql
    
    CALL g_ogb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q620_cs2 INTO g_ogb[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q620_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF       
        EXECUTE q620_ima021_cs USING g_ogb[g_cnt].ogb04
                                INTO g_ogb[g_cnt].ima021
        SELECT gfe02 INTO g_ogb[g_cnt].ogb05_desc
          FROM gfe_file
         WHERE gfe01 = g_ogb[g_cnt].ogb05   
           AND gfeacti = 'Y'        
        SELECT imd02 INTO g_ogb[g_cnt].ogb09_desc
          FROM imd_file
         WHERE imd01 = g_ogb[g_cnt].ogb09
           AND imdacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ogb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q620_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
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
 
FUNCTION q620_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b!=0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q620_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
     
      ON ACTION money_detail
         LET g_action_choice = "money_detail"
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
#FUN-870100
#MOD-B30321 ADD
