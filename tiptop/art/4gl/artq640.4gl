# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: artq640.4gl
# Descriptions...: 銷退明細查詢作業
# Date & Author..: No: FUN-870008 09/02/27 By Mike
# Modify.........: No: FUN-870100 09/09/03 By Cockroach  流通別超市移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10041 10/01/07 By destiny DB取值请取实体DB
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No.MOD-AB0131 10/11/12 By lilingyu sql變量定義為string類型,仍然過短,無法組合出正確的sql語句
# Modify.........: No.FUN-B70071 11/07/21 By yangxf 添加控管使抓到的值顯示到畫面上 
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oha   DYNAMIC ARRAY OF RECORD        #退
               ohaplant       LIKE oha_file.ohaplant,
               azp02        LIKE azp_file.azp02,
               oha02        LIKE oha_file.oha02,
               oha01        LIKE oha_file.oha01,
               oha03        LIKE oha_file.oha03,
               oha032       LIKE oha_file.oha032,
               occ930       LIKE occ_file.occ930,
               occ930_type  LIKE oha_file.oha85,
               oha85        LIKE oha_file.oha85,              
               oha04        LIKE oha_file.oha04,    
               oha05        LIKE oha_file.oha05,
               oha08        LIKE oha_file.oha08,
               oha09        LIKE oha_file.oha09,
               oha14        LIKE oha_file.oha14,
               gen02        LIKE gen_file.gen02,
               oha15        LIKE oha_file.oha15,
               gem02        LIKE gem_file.gem02,
               oha16        LIKE oha_file.oha16,
               oha17        LIKE oha_file.oha17,
               oha21        LIKE oha_file.oha21,
               oha211       LIKE oha_file.oha211,
               oha213       LIKE oha_file.oha213,
               oha23        LIKE oha_file.oha23,
               oha24        LIKE oha_file.oha24,
               oha50        LIKE oha_file.oha50,
               oha53        LIKE oha_file.oha53,
               oha54        LIKE oha_file.oha54,
               oha48        LIKE oha_file.oha48,
               oha56        LIKE oha_file.oha56,
               oha87        LIKE oha_file.oha87,
               oha88        LIKE oha_file.oha88,
               oha89        LIKE oha_file.oha89,
               oha94        LIKE oha_file.oha94,
               oha95        LIKE oha_file.oha95,
               oha96        LIKE oha_file.oha96,
               oha97        LIKE oha_file.oha97,
               oha41        LIKE oha_file.oha41,
               oha44        LIKE oha_file.oha44,
               oha99        LIKE oha_file.oha99,
               ohaconf      LIKE oha_file.ohaconf,
               ohacond      LIKE oha_file.ohacond,
               ohaconu      LIKE oha_file.ohaconu,
               gen02_1      LIKE gen_file.gen02,
               ohaprsw      LIKE oha_file.ohaprsw
               END RECORD,
       g_ohb   DYNAMIC ARRAY OF RECORD        #退明細
               ohb03      LIKE ohb_file.ohb03,
               ohb04      LIKE ohb_file.ohb04,
               ohb06      LIKE ohb_file.ohb06,
               ima021     LIKE ima_file.ima021,
               ohb05      LIKE ohb_file.ohb05,
               ohb05_fac  LIKE ohb_file.ohb05_fac,
               ohb12      LIKE ohb_file.ohb12,
               ohb09      LIKE ohb_file.ohb09,
               imd02      LIKE imd_file.imd02,
               ohb091     LIKE ohb_file.ohb091,
               ohb092     LIKE ohb_file.ohb092,
               ohb13      LIKE ohb_file.ohb13,
               ohb14      LIKE ohb_file.ohb14,
               ohb14t     LIKE ohb_file.ohb14t,
               ohb31      LIKE ohb_file.ohb31,
               ohb32      LIKE ohb_file.ohb32,
               ohb33      LIKE ohb_file.ohb33,
               ohb34      LIKE ohb_file.ohb34,
               ohb50      LIKE ohb_file.ohb50,
               azf03      LIKE azf_file.azf03,
               ohb64      LIKE ohb_file.ohb64,
               ohb65      LIKE ohb_file.ohb65,
               ohb66      LIKE ohb_file.ohb66,
               ohb67      LIKE ohb_file.ohb67,
              #ohb68      LIKE ohb_file.ohb68,
              #ohb69      LIKE ohb_file.ohb69,
              #ohb70      LIKE ohb_file.ohb70,
              #ohb71      LIKE ohb_file.ohb71,
              #ohb72      LIKE ohb_file.ohb72,
              #ohb73      LIKE ohb_file.ohb73,
              #ohb74      LIKE ohb_file.ohb74,
              #ohb75      LIKE ohb_file.ohb75,
               ohb68      LIKE ohb_file.ohb68
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,               
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_dbs  LIKE azp_file.azp03
#DEFINE g_sql2        STRING                      #MOD-AB0131 
DEFINE g_chk_ohaplant LIKE type_file.chr1
DEFINE g_chk_auth    STRING              
DEFINE g_argv1 LIKE oha_file.ohaplant
DEFINE g_argv2 LIKE oha_file.oha01
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10041 
 
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
 
   OPEN WINDOW q640_w AT p_row,p_col WITH FORM "art/42f/artq640"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q640_q()
   END IF   
   
   CALL q640_menu()
 
   CLOSE WINDOW q640_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q640_menu()
 
   WHILE TRUE
      CALL q640_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q640_q()
            END IF
 
         WHEN "view"
              CALL q640_bp2()
 
         WHEN "return"
              CALL q640_bp()
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oha),base.TypeInfo.create(g_ohb),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q640_q()
 
   CALL q640_b_askkey()
 
END FUNCTION
 
FUNCTION q640_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
  IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
     LET g_wc = "oha01 = '",g_argv2,"' AND ohaplant = '",g_argv1,"'"
  ELSE  
   CLEAR FORM
   CALL g_oha.clear()
   CALL g_ohb.clear()
 
   LET g_chk_ohaplant = TRUE 
   
   CONSTRUCT g_wc ON ohaplant, oha02, oha01,  oha03,
                     oha032, oha85, oha04,  oha05,
                     oha08,  oha09, oha14,  oha15,
                     oha16,  oha17, oha21,  oha211,
                     oha213, oha23, oha24,  oha50,
                     oha53,  oha54, oha48,  oha56,
                     oha87,  oha88, oha89,  oha94,
                     oha95,  oha96, oha97,  oha41,
                     oha44,  oha99, ohaconf,ohacond,
                     ohaconu,ohaprsw
                FROM s_oha[1].ohaplant, s_oha[1].oha02, s_oha[1].oha01,  s_oha[1].oha03,
                     s_oha[1].oha032, s_oha[1].oha85, s_oha[1].oha04,  s_oha[1].oha05,
                     s_oha[1].oha08,  s_oha[1].oha09, s_oha[1].oha14,  s_oha[1].oha15,        
                     s_oha[1].oha16,  s_oha[1].oha17, s_oha[1].oha21,  s_oha[1].oha211,
                     s_oha[1].oha213, s_oha[1].oha23, s_oha[1].oha24,  s_oha[1].oha50,
                     s_oha[1].oha53,  s_oha[1].oha54, s_oha[1].oha48,  s_oha[1].oha56,
                     s_oha[1].oha87,  s_oha[1].oha88, s_oha[1].oha89,  s_oha[1].oha94,
                     s_oha[1].oha95,  s_oha[1].oha96, s_oha[1].oha97,  s_oha[1].oha41,
                     s_oha[1].oha44,  s_oha[1].oha99, s_oha[1].ohaconf,s_oha[1].ohacond,
                     s_oha[1].ohaconu,s_oha[1].ohaprsw 
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD ohaplant
         IF get_fldbuf(ohaplant) IS NOT NULL THEN
            LET g_chk_ohaplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ohaplant)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ohaplant
                   NEXT FIELD ohaplant
 
              WHEN INFIELD(oha03)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oha03
                   NEXT FIELD oha03
 
              WHEN INFIELD(oha04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oha04
                   NEXT FIELD oha04
                   
              WHEN INFIELD(oha87)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_oha87"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oha87
                   NEXT FIELD oha87
                   
              WHEN INFIELD(oha21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gec"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oha21
                   NEXT FIELD oha21
                   
              WHEN INFIELD(oha23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi1"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oha23                
                   NEXT FIELD oha23  
                   
              WHEN INFIELD(oha14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oha14
                   NEXT FIELD oha14   
                    
              WHEN INFIELD(oha15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oha15
                   NEXT FIELD oha15  
                       
              WHEN INFIELD(ohaconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ohaconu
                   NEXT FIELD ohaconu
                   
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
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND ohauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND ohagrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              
   #      LET g_wc = g_wc CLIPPED," AND ohagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup')
   #End:FUN-980030
   
   CONSTRUCT g_wc2 ON ohb03,    ohb04,  ohb06,  ohb05,
                      ohb05_fac,ohb12,  ohb09,  ohb091,
                      ohb092,   ohb13,  ohb14,  ohb14t,
                      ohb31,    ohb32,  ohb33,  ohb34,
                      ohb50,    ohb64,  ohb65,  ohb66,
                      ohb67,    ohb68   # ,  ohb69,  ohb70,
                     # ohb71,    ohb72,  ohb73,  ohb74,
                     # ohb75,    ohb81  
                 FROM s_ohb[1].ohb03,    s_ohb[1].ohb04,  s_ohb[1].ohb06,  s_ohb[1].ohb05,
                      s_ohb[1].ohb05_fac,s_ohb[1].ohb12,  s_ohb[1].ohb09,  s_ohb[1].ohb091,
                      s_ohb[1].ohb092,   s_ohb[1].ohb13,  s_ohb[1].ohb14,  s_ohb[1].ohb14t, 
                      s_ohb[1].ohb31,    s_ohb[1].ohb32,  s_ohb[1].ohb33,  s_ohb[1].ohb34,                      
                      s_ohb[1].ohb50,    s_ohb[1].ohb64,  s_ohb[1].ohb65,  s_ohb[1].ohb66,
                      s_ohb[1].ohb67,    s_ohb[1].ohb68  # ,  s_ohb[1].ohb69,  s_ohb[1].ohb70,
                    #  s_ohb[1].ohb71,    s_ohb[1].ohb72,  s_ohb[1].ohb73,  s_ohb[1].ohb74,
                    #  s_ohb[1].ohb75,    s_ohb[1].ohb81  
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(ohb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohb04
                 NEXT FIELD ohb04
              WHEN INFIELD(ohb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohb05
                 NEXT FIELD ohb05
              WHEN INFIELD(ohb09)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd01"     #FUN-AA0062 mark
                 LET g_qryparam.form = "q_imd003"     #FUN-AA0062 mark
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = 'SW'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohb09
                 NEXT FIELD ohb09
              WHEN INFIELD(ohb50)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azf03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '2' 
                 LET g_qryparam.arg2 = '2' 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ohb50
                 NEXT FIELD ohb50
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
 
    LET g_chk_auth = ''
    IF g_chk_ohaplant THEN
      DECLARE q640_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q640_zxy_cs INTO l_zxy03
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
    IF cl_null(g_wc2) THEN LET g_wc2="1=1" END IF
    LET g_wc = g_wc CLIPPED," AND ",g_wc2 CLIPPED
    CALL q640_b_fill(g_wc)
    CALL q640_b2_fill(g_wc2)
   
END FUNCTION
 
FUNCTION q640_b_fill(p_wc)              
DEFINE p_wc STRING        
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add

    #NO.TQC-A10041-- begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
    #            " WHERE zxy01 = '",g_user,"' ",
    #            "   AND zxy03 = azp01  "
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
    PREPARE q640_pre FROM g_sql
    DECLARE q640_DB_cs CURSOR FOR q640_pre
#   LET g_sql2 = ''   #MOD-AB0131
    #FOREACH q640_DB_cs INTO g_dbs
     FOREACH q640_DB_cs INTO g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q640_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
#TQC-B90175 add START------------------------------
        SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_zxy03
        IF NOT cl_chk_schema_has_built(l_azp03) THEN
          CONTINUE FOREACH
        END IF
#TQC-B90175 add END--------------------------------
       #FUN-A50102 ---mark---str---
       #LET g_plant_new = g_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs=g_dbs_tra
       #LET g_dbs = s_dbstring(g_dbs CLIPPED)
       #FUN-A50102 ---mark---end---
    #NO.TQC-A10041-- begin   
       LET g_sql = "SELECT DISTINCT ohaplant,    '', oha02, oha01,   oha03,  oha032,      '',    '',   oha85,  oha04, oha05, oha08,",       
                   "        oha09, oha14,    '', oha15,      '',   oha16,   oha17, oha21,  oha211, oha213, oha23, oha24,",       
                   "        oha50, oha53, oha54, oha48,   oha56,   oha87,   oha88, oha89,   oha94,  oha95, oha96,       ",       
                   "        oha97, oha41, oha44, oha99, ohaconf, ohacond, ohaconu,    '', ohaprsw                       ",       
                  #"  FROM ",g_dbs CLIPPED,".oha_file,",g_dbs CLIPPED,".ohb_file",
                  #"  FROM ",g_dbs CLIPPED,"oha_file,",g_dbs CLIPPED,"ohb_file",    #FUN-A50102
                   "  FROM ",cl_get_target_table(g_zxy03, 'oha_file'),",",cl_get_target_table(g_zxy03, 'ohb_file'),    #FUN-A50102
                   " WHERE oha01=ohb01 AND ohaplant=ohbplant "," AND ohaplant='",g_zxy03,"' ", 
                   "   AND  ",p_wc 
 
       IF g_chk_ohaplant THEN
          LET g_sql = "(",g_sql," AND ohaplant IN ",g_chk_auth,")"
       ELSE
          LET g_sql = "(",g_sql,")"
       END IF
#MOD-AB0131 --begin--
#       IF g_sql2 IS NULL THEN
#          LET g_sql2 = g_sql
#       ELSE
#          LET g_sql2 = g_sql2," UNION ALL ",g_sql
#       END IF
#    END FOREACH
    
#    PREPARE q640_pb FROM g_sql2
     PREPARE q640_pb FROM g_sql
#MOD-AB0131 --end--
    
    DECLARE q640_cs CURSOR FOR q640_pb
 
#FUN-B70071------------------str----------------
    IF g_cnt = 0 THEN 
        CALL g_oha.clear()
        LET g_cnt = 1
    END IF 
#FUN-B70071------------------end----------------
    MESSAGE "Searching!"
    FOREACH q640_cs INTO g_oha[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q640_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        #NO.TQC-A10041-- begin
        #SELECT azp02,azp03
        #  INTO g_oha[g_cnt].azp02,l_dbs
        #  FROM azp_file
        # WHERE azp01 = g_oha[g_cnt].ohaplant
        SELECT azp02 INTO g_oha[g_cnt].azp02     
         FROM azp_file WHERE azp01 = g_oha[g_cnt].ohaplant
        #FUN-A50102 ---mark---str--- 
        #LET g_plant_new = g_oha[g_cnt].ohaplant
        #CALL s_gettrandbs()
        #LET l_dbs=g_dbs_tra 
        #LET l_dbs = s_dbstring(l_dbs CLIPPED)
        #FUN-A50102 ---mark---end---
        #NO.TQC-A10041-- end
        SELECT gen02 INTO g_oha[g_cnt].gen02
          FROM gen_file
         WHERE gen01 = g_oha[g_cnt].oha14
           AND genacti = 'Y'
        SELECT gen02 INTO g_oha[g_cnt].gen02_1
          FROM gen_file
         WHERE gen01 = g_oha[g_cnt].ohaconu
           AND genacti = 'Y'
        SELECT gem02 INTO g_oha[g_cnt].gem02
          FROM gem_file
         WHERE gem01 = g_oha[g_cnt].oha15
           AND gemacti = 'Y'
        #LET g_sql = "SELECT occ930 FROM ",l_dbs CLIPPED,".occ_file",
        #LET g_sql = "SELECT occ930 FROM ",l_dbs CLIPPED,"occ_file", #FUN-A50102
        LET g_sql = "SELECT occ930 FROM ",cl_get_target_table(g_oha[g_cnt].ohaplant, 'occ_file'), #FUN-A50102
                " WHERE occ01 = ? AND occacti = 'Y'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
        CALL cl_parse_qry_sql(g_sql, g_oha[g_cnt].ohaplant) RETURNING g_sql  #FUN-A50102
        PREPARE q640_occ_cs FROM g_sql
        EXECUTE q640_occ_cs USING g_oha[g_cnt].oha03
                             INTO g_oha[g_cnt].occ930
        IF g_oha[g_cnt].occ930 IS NOT NULL THEN
           LET g_oha[g_cnt].occ930_type = '1'
        ELSE
           LET g_oha[g_cnt].occ930_type = '2'
        END IF           
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        CALL g_oha.deleteElement(g_cnt)                #FUN-B70071   
    END FOREACH
  END FOREACH  #MOD-AB0131 
  
    CALL g_oha.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q640_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03  
    #NO.TQC-A10041-- begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_oha[l_ac].ohaplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oha[l_ac].ohaplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra        
    #LET l_dbs = s_dbstring(l_dbs CLIPPED) 
    #FUN-A50102 ---mark---end---
    #NO.TQC-A10041--end  
    LET g_sql = "SELECT DISTINCT ohb03, ohb04,  ohb06,    '', ohb05, ohb05_fac, ohb12, ohb09,    '', ohb091, ohb092, ",
                "       ohb13, ohb14, ohb14t, ohb31, ohb32,     ohb33, ohb34, ohb50,    '',  ohb64, ohb65,  ",
                "       ohb66, ohb67,  ohb68 ",   # ohb69, ohb70,     ohb71, ohb72, ohb73, ohb74,  ohb75, ohb81   ",
               #"  FROM ",l_dbs CLIPPED,".ohb_file",
               #"  FROM ",l_dbs CLIPPED,"ohb_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_oha[l_ac].ohaplant, 'ohb_file'), #FUN-A50102
                " WHERE ohb01 = '",g_oha[l_ac].oha01,"'",
                "   AND ohbplant = '",g_oha[l_ac].ohaplant,"'",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oha[l_ac].ohaplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q640_pb2 FROM g_sql
    DECLARE q640_cs2 CURSOR FOR q640_pb2
    
    #LET g_sql = "SELECT ima021 FROM ",l_dbs CLIPPED,".ima_file",
    #LET g_sql = "SELECT ima021 FROM ",l_dbs CLIPPED,"ima_file", #FUN-A50102
    LET g_sql = "SELECT ima021 FROM ",cl_get_target_table(g_oha[l_ac].ohaplant, 'ima_file'), #FUN-A50102
                " WHERE ima01 = ? AND imaacti = 'Y'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oha[l_ac].ohaplant) RETURNING g_sql  #FUN-A50102             
    PREPARE q640_ima021_cs FROM g_sql
    
    CALL g_ohb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q640_cs2 INTO g_ohb[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q640_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF       
        EXECUTE q640_ima021_cs USING g_ohb[g_cnt].ohb04
                                INTO g_ohb[g_cnt].ima021
        SELECT azf03 INTO g_ohb[g_cnt].azf03
          FROM azf_file
         WHERE azf01 = g_ohb[g_cnt].ohb50   
           AND azfacti = 'Y'        
        SELECT imd02 INTO g_ohb[g_cnt].imd02
          FROM imd_file
         WHERE imd01 = g_ohb[g_cnt].ohb09
           AND imdacti = 'Y'
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ohb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q640_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ohb TO s_ohb.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION return
         LET g_action_choice = "return"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit 
         LET g_action_choice="exit"
         EXIT DISPLAY

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END

   END DISPLAY
 
END FUNCTION
 
FUNCTION q640_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_oha TO s_oha.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b!=0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q640_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_ohb TO s_ohb.* ATTRIBUTE(COUNT=g_rec_b2)
              BEFORE DISPLAY
                EXIT DISPLAY
            END DISPLAY
         END IF
         CALL cl_show_fld_cont()
         
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
 
      ON ACTION view
         LET g_action_choice = "view"
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
