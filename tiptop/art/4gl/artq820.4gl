# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: artq820.4gl
# Descriptions...: 倉庫調撥明細查詢
# Date & Author..: No: FUN-870100 09/03/06 By lala
# Modify.........: No.FUN-870007 09/08/26 By Zhangyajun 程序移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10049 10/01/07 By destiny DB取值请取实体DB 
# Modify.........: No.FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No:FUN-B90091 11/09/19 by pauline 增加匯出EXCEL功能
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_imm   DYNAMIC ARRAY OF RECORD        #
               immplant       LIKE imm_file.immplant,
               immplant_desc  LIKE azp_file.azp02,
               imm01        LIKE imm_file.imm01,
               imm02        LIKE imm_file.imm02,
               imm03        LIKE imm_file.imm03,
               imm10        LIKE imm_file.imm10,               
               imm11        LIKE imm_file.imm11, 
               imm12        LIKE imm_file.imm12, 
               imm13        LIKE imm_file.imm13, 
               imm14        LIKE imm_file.imm14, 
               imm09        LIKE imm_file.imm09,
               immconf      LIKE imm_file.immconf,
               immuser      LIKE imm_file.immuser,
               immgrup      LIKE imm_file.immgrup,
               immmodu      LIKE imm_file.immmodu,
               immdate      LIKE imm_file.immdate
               END RECORD,
       g_imn   DYNAMIC ARRAY OF RECORD        # 明細
               imn02      LIKE imn_file.imn02,
               imn03      LIKE imn_file.imn03,
               imn04      LIKE imn_file.imn04,
               imn041     LIKE imn_file.imn041,
               imn05      LIKE imn_file.imn05,
               imn06      LIKE imn_file.imn06,
               imn07      LIKE imn_file.imn07,
               imn08      LIKE imn_file.imn08,
               imn09      LIKE imn_file.imn09,
               imn091     LIKE imn_file.imn091,
               imn092     LIKE imn_file.imn092,
               imn10      LIKE imn_file.imn10,
               imn11      LIKE imn_file.imn11,
               imn12      LIKE imn_file.imn12,
               imn13      LIKE imn_file.imn13,
               imn13_desc   LIKE gen_file.gen02,
               imn14      LIKE imn_file.imn14,
               imn15      LIKE imn_file.imn15,
               imn15_desc   LIKE imd_file.imd02,
               imn151     LIKE imn_file.imn151,
               imn16      LIKE imn_file.imn16,
               imn17      LIKE imn_file.imn17,
               imn18      LIKE imn_file.imn18,
               imn19      LIKE imn_file.imn19,
               imn20      LIKE imn_file.imn20,
               imn20_desc   LIKE gfe_file.gfe02,
               imn201     LIKE imn_file.imn201,
               imn202     LIKE imn_file.imn202,
               imn21      LIKE imn_file.imn21,
               imn22      LIKE imn_file.imn22,
               imn23      LIKE imn_file.imn23,
               imn24      LIKE imn_file.imn24,
               imn25      LIKE imn_file.imn25,
               imn25_desc   LIKE gen_file.gen02,
               imn26      LIKE imn_file.imn26,
               imn27      LIKE imn_file.imn27,
               imn28      LIKE imn_file.imn28,
               imn29      LIKE imn_file.imn29,
               imn30      LIKE imn_file.imn30,
               imn31      LIKE imn_file.imn31,
               imn32      LIKE imn_file.imn32,
               imn33      LIKE imn_file.imn33,
               imn34      LIKE imn_file.imn34,
               imn35      LIKE imn_file.imn35,
               imn40      LIKE imn_file.imn40,
               imn41      LIKE imn_file.imn41,
               imn42      LIKE imn_file.imn42,
               imn43      LIKE imn_file.imn43,
               imn44      LIKE imn_file.imn44,
               imn45      LIKE imn_file.imn45,
               imn51      LIKE imn_file.imn51,
               imn52      LIKE imn_file.imn52,
               imn9301    LIKE imn_file.imn9301,
               imn9302    LIKE imn_file.imn9302
               END RECORD
DEFINE g_wc,g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,    
       g_rec_b2       LIKE type_file.num5,
       l_ac,l_ac2     LIKE type_file.num5,
       g_argv1        LIKE imm_file.imm02,
       g_argv2        LIKE imm_file.immplant 
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_cnt,l_cnt    LIKE type_file.num5
DEFINE g_sql2 STRING 
DEFINE g_chk_immplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10049 
 
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
 
   OPEN WINDOW q820_w AT p_row,p_col WITH FORM "art/42f/artq820"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_set_comp_visible("imn30,imn31,imn32,imn33,imn34,imn35,imn40,"
                          ||"imn41,imn42,imn43,imn44,imn45,imn51,imn52",g_sma.sma115='N')
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL q820_q()
   END IF
 
   CALL q820_menu()
 
   CLOSE WINDOW q820_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION q820_menu()
 
   WHILE TRUE
      CALL q820_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q820_q()
            END IF
 
         WHEN "view"
              CALL q820_bp2()
 
         WHEN "return"
              CALL q820_bp()
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

#FUN-B90091 add START
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imm),base.TypeInfo.create(g_imn),'')
            END IF
#FUN-B90091 add END
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q820_q()
 
   CALL q820_b_askkey()
 
END FUNCTION
 
FUNCTION q820_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
 
   CLEAR FORM
   CALL g_imm.clear()
   CALL g_imn.clear()
 
   LET g_chk_immplant = TRUE 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = " imm01 = '",g_argv1,"' AND immplant = '",g_argv2,"'"
      LET g_wc2 =" 1=1"
      LET g_chk_immplant=FALSE
   ELSE
      
   CONSTRUCT g_wc ON immplant,imm01,imm02,imm03,imm10,imm11,imm12,imm13,imm14,imm09,
                     immconf,immuser,immgrup,immmodu,immdate
                FROM s_imm[1].immplant,s_imm[1].imm01,s_imm[1].imm02,s_imm[1].imm03,s_imm[1].imm10,
                     s_imm[1].imm11,s_imm[1].imm12,s_imm[1].imm13,s_imm[1].imm14,s_imm[1].imm09,s_imm[1].immconf,
                     s_imm[1].immuser,s_imm[1].immgrup,s_imm[1].immmodu,s_imm[1].immdate
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD immplant
         IF get_fldbuf(immplant) IS NOT NULL THEN
            LET g_chk_immplant = FALSE
         END IF
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(immplant)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO immplant
                   NEXT FIELD immplant
 
              WHEN INFIELD(imm13)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imm13
                   NEXT FIELD imm13
 
              WHEN INFIELD(imm14)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO imm14
                   NEXT FIELD imm14
 
              WHEN INFIELD(immgrup)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO immconu
                   NEXT FIELD immgrup
                   
              WHEN INFIELD(immmodu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO immmodu
                   NEXT FIELD immmodu
                   
              WHEN INFIELD(immuser)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen5"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO immuser
                   NEXT FIELD immuser
 
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
   #      LET g_wc = g_wc CLIPPED," AND immuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           
   #      LET g_wc = g_wc CLIPPED," AND immgrup MATCHES '",
   #                 g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              
   #      LET g_wc = g_wc CLIPPED," AND immgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
   #End:FUN-980030
   
   CONSTRUCT g_wc2 ON imn02,imn03,imn04,imn041,imn05,imn06,imn07,imn08,imn09,imn091,imn092,imn10,imn11,imn12,imn13,imn14,imn15,imn151,
                      imn16,imn17,imn18,imn19,imn20,imn201,imn202,imn21,imn22,imn23,imn24,imn25,imn26,imn27,imn28,imn29,
                      imn30,imn31,imn32,imn33,imn34,imn35,imn40,imn41,imn42,imn43,imn44,imn45,imn51,imn52,imn9301,imn9302
                 FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn04,s_imn[1].imn041,s_imn[1].imn05,s_imn[1].imn06,s_imn[1].imn07,s_imn[1].imn08,
                      s_imn[1].imn09,s_imn[1].imn091,s_imn[1].imn092,s_imn[1].imn10,s_imn[1].imn11,s_imn[1].imn12,s_imn[1].imn13,s_imn[1].imn14,s_imn[1].imn15,
                      s_imn[1].imn151,s_imn[1].imn16,s_imn[1].imn17,s_imn[1].imn18,s_imn[1].imn19,s_imn[1].imn20,s_imn[1].imn201,s_imn[1].imn202,
                      s_imn[1].imn21,s_imn[1].imn22,s_imn[1].imn23,s_imn[1].imn24,s_imn[1].imn25,s_imn[1].imn26,s_imn[1].imn27,s_imn[1].imn28,s_imn[1].imn29,
                      s_imn[1].imn30,s_imn[1].imn31,s_imn[1].imn32,s_imn[1].imn33,s_imn[1].imn34,s_imn[1].imn35,s_imn[1].imn40,s_imn[1].imn41,s_imn[1].imn42,
                      s_imn[1].imn43,s_imn[1].imn44,s_imn[1].imn45,s_imn[1].imn51,s_imn[1].imn52,s_imn[1].imn9301,s_imn[1].imn9302
                      
                      
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(imn03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn03
                 NEXT FIELD imn03
              WHEN INFIELD(imn04)
                 CALL cl_init_qry_var()
#No.FUN-AA0062  --Begin
#                 LET g_qryparam.form = "q_imd02"
                 LET g_qryparam.form = "q_imd003"
                 LET g_qryparam.arg1 = "SW"
#No.FUN-AA0062  --End
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn04
                 NEXT FIELD imn04
              WHEN INFIELD(imn09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn09
                 NEXT FIELD imn09
              WHEN INFIELD(imn13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn13
                 NEXT FIELD imn13
              WHEN INFIELD(imn15)
                 CALL cl_init_qry_var()
#No.FUN-AA0062  --Begin
#                 LET g_qryparam.form = "q_imd02"
                 LET g_qryparam.form = "q_imd003"
                 LET g_qryparam.arg1 = "SW"
#No.FUN-AA0062  --End
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn15
                 NEXT FIELD imn15
              WHEN INFIELD(imn20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn20
                 NEXT FIELD imn20
              WHEN INFIELD(imn25)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn25
                 NEXT FIELD imn25
              WHEN INFIELD(imn30)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn30
                 NEXT FIELD imn30
              WHEN INFIELD(imn33)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn33
                 NEXT FIELD imn33
              WHEN INFIELD(imn40)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn40
                 NEXT FIELD imn40
              WHEN INFIELD(imn43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imn43
                 NEXT FIELD imn43
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
    END IF
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    LET g_chk_auth = ''
    IF g_chk_immplant THEN
      DECLARE q820_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q820_zxy_cs INTO l_zxy03
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
    CALL q820_b_fill(g_wc,g_wc2)
    CALL q820_b2_fill(g_wc2)
 
END FUNCTION
 
FUNCTION q820_b_fill(p_wc,p_wc2)              
DEFINE p_wc STRING        
DEFINE p_wc2 STRING
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
#DEFINE l_dbs LIKE azp_file.azp03 #FUN-A50102
DEFINE l_n   LIKE type_file.num5
    #NO.TQC-A10049--begin
    #LET g_sql = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
    #            " WHERE zxy01 = '",g_user,"' ",
    #            "   AND zxy03 = azp01  "
    LET g_sql = "SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
    PREPARE q820_pre FROM g_sql
    DECLARE q820_DB_cs CURSOR FOR q820_pre
    LET g_sql2 = ''
    #FOREACH q820_DB_cs INTO l_dbs
    FOREACH q820_DB_cs INTO  g_zxy03
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q820_DB_cs',SQLCA.sqlcode,1)
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
       #LET l_dbs=g_dbs_tra         
       #FUN-A50102 ---mark---end---
    #NO.TQC-A10049--end
    IF p_wc2 =" 1=1" THEN
       LET g_sql = "SELECT DISTINCT immplant,'',imm01,imm02,imm03,imm10,imm11,imm12,imm13,imm14,imm09,",
                   "       immconf,immuser,immgrup,immmodu,immdate ",
                   #"  FROM ",s_dbstring(l_dbs),"imm_file,azp_file", #FUN-A50102
                   "  FROM ",cl_get_target_table(g_zxy03, 'imm_file'),",","azp_file", #FUN-A50102
                   #" WHERE immplant = azp01 AND azp03 = '",l_dbs CLIPPED,"'",
                    " WHERE immplant = azp01 AND azp01 = '",g_zxy03 CLIPPED,"'",
                   "   AND ",p_wc
    ELSE
       LET g_sql = "SELECT DISTINCT immplant,'',imm01,imm02,imm03,imm10,imm11,imm12,imm13,imm14,imm09,",
                   "       immconf,immuser,immgrup,immmodu,immdate ",
                   #"  FROM ",s_dbstring(l_dbs),"imm_file,",s_dbstring(l_dbs),"imn_file,azp_file", #FUN-A50102
                   "  FROM ",cl_get_target_table(g_zxy03, 'imm_file'),",",cl_get_target_table(g_zxy03, 'imn_file'),",","azp_file", #FUN-A50102
                   " WHERE imm01 = imn01 AND immplant = imnplant ",
                   #"   AND imm930 = azp01 AND azp03 = '",l_dbs CLIPPED,"'",
                   "   AND imm930 = azp01 AND azp01 = '",g_zxy03 CLIPPED,"'",
                   "   AND ",p_wc," AND ",p_wc2
    END IF
       IF g_chk_immplant THEN
          LET g_sql = "(",g_sql," AND immplant IN ",g_chk_auth,")"
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
    
    PREPARE q820_pb FROM g_sql
    DECLARE q820_cs CURSOR FOR q820_pb
 
    CALL g_imm.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q820_cs INTO g_imm[g_cnt].*
        IF STATUS THEN 
           CALL cl_err('foreach q820_cs:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT azp02
          INTO g_imm[g_cnt].immplant_desc
          FROM azp_file
         WHERE azp01 = g_imm[g_cnt].immplant
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_imm.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q820_b2_fill(p_wc2)              
DEFINE p_wc2 STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_imm01 LIKE imm_file.imm01
    #NO.TQC-A10049--begin
    #SELECT azp03 INTO l_dbs
    #  FROM azp_file
    # WHERE azp01 = g_imm[l_ac].immplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_imm[l_ac].immplant
    #CALL s_gettrandbs()
    #LET l_dbs=g_dbs_tra          
    #FUN-A50102 ---mark---end---
    #NO.TQC-A10049--end 
    LET g_sql = "SELECT imn02,imn03,imn04,imn041,imn05,imn06,imn07,imn08,imn09,imn091,imn092,imn10,imn11,imn12,imn13,'',imn14,imn15,'',imn151,",
                "       imn16,imn17,imn18,imn19,imn20,'',imn201,imn202,imn21,imn22,imn23,imn24,imn25,'',imn26,imn27,imn28,imn29, ",
                "       imn30,imn31,imn32,imn33,imn34,imn35,imn40,imn41,imn42,imn43,imn44,imn45,imn51,imn52,imn9301,imn9302 ",
                #"  FROM ",s_dbstring(l_dbs),"imn_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_imm[l_ac].immplant, 'imn_file'), #FUN-A50102
                " WHERE imn01 = '",g_imm[l_ac].imm01,"'",
                "   AND imnplant = '",g_imm[l_ac].immplant,"'",
                "   AND ",p_wc2
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                        #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_imm[l_ac].immplant) RETURNING g_sql  #FUN-A50102            
    PREPARE q820_pb2 FROM g_sql
    DECLARE q820_cs2 CURSOR FOR q820_pb2
    
    CALL g_imn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH q820_cs2 INTO g_imn[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach q820_cs2:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT gen02 INTO g_imn[g_cnt].imn13_desc FROM gen_file
         WHERE gen01 = g_imn[g_cnt].imn13
        SELECT imd02 INTO g_imn[g_cnt].imn15_desc FROM imd_file
         WHERE imd01 = g_imn[g_cnt].imn15
        SELECT gfe02 INTO g_imn[g_cnt].imn20_desc FROM gfe_file
         WHERE gfe01 = g_imn[g_cnt].imn20
        SELECT gen02 INTO g_imn[g_cnt].imn25_desc FROM gen_file
         WHERE gen01 = g_imn[g_cnt].imn25
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_imn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION q820_bp2()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
 
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

#FUN-B90091 add START
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#FUN-B90091 add END
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION q820_bp()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_imm TO s_imm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF g_rec_b != 0 THEN
            DISPLAY l_ac TO FORMONLY.idx
            CALL q820_b2_fill(g_wc2)
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b2)
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
 
      ON ACTION VIEW
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
#No.FUN-870007
