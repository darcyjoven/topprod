# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axmq413.4gl
# Descriptions...: 訂單查詢作業
# Date & Author..: No.FUN-870007 09/03/05 By Zhangyajun 
# Memo...........: 由axmq200客制而來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.TQC-A10070 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.TQC-A10096 10/01/11 By destiny 单身资料显示有重复  
# Modify.........: No.FUN-A50102 10/06/08 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.TQC-B90175 11/09/26 By pauline 跨DB時若DB的schema未建立會錯誤
# Modify.........: No.FUN-C60062 12/06/19 By yangxf 将作业artq611——>axmq413

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../art/4gl/artq600.global"
 
DEFINE l_ac_b1  LIKE type_file.num5
DEFINE l_ac_b2  LIKE type_file.num5
DEFINE l_ac_b3  LIKE type_file.num5
DEFINE l_ac_b4  LIKE type_file.num5
DEFINE l_ac_b5  LIKE type_file.num5
DEFINE l_ac_b6  LIKE type_file.num5
DEFINE l_ac_b7  LIKE type_file.num5
DEFINE g_renew   LIKE type_file.num5     
DEFINE g_dbs  LIKE azp_file.azp03
DEFINE g_sql2 STRING 
DEFINE g_chk_oeaplant LIKE type_file.chr1
DEFINE g_chk_auth STRING 
   
MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q413_w AT p_row,p_col WITH FORM "axm/42f/axmq413"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL q413_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL q413()
 
   CLOSE WINDOW q413_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN
 
FUNCTION q413()
 
   
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL q413_q()
      END IF
      CALL q413_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "query_ar"   #全部選取
           CALL q413_qry_ar()
         WHEN "view1"
            CALL q413_bp2_1('V')
         WHEN "view2"
            CALL q413_bp2_2('V')
         WHEN "view3"
            CALL q413_bp2_3('V')
         WHEN "view4"
            CALL q413_bp2_4('V')
         WHEN "view5"
            CALL q413_bp2_5('V')
         WHEN "view6"
            CALL q413_bp2_6('V')
         WHEN "view7"
            CALL q413_bp2_7('V')
 
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oea1),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q413_p1()
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      DISPLAY ARRAY g_oea1 TO s_oea.* ATTRIBUTE(COUNT=g_rec_b) #顯示並進行選擇
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
             LET l_ac1_t = l_ac1
             LET g_oea1_t.* = g_oea1[l_ac1].*
 
             IF g_rec_b > 0 THEN
               CALL q413_b_fill_1()  #訂單
               CALL q413_bp2_1('')
               CALL q413_b_fill_2()  #出通單
               CALL q413_bp2_2('')
               CALL q413_b_fill_3()  #出貨單
               CALL q413_bp2_3('')
               CALL q413_b_fill_4()  #應收
               CALL q413_bp2_4('')
               CALL q413_b_fill_5()  #工單
               CALL q413_bp2_5('')
               CALL q413_b_fill_6()  #請購
               CALL q413_bp2_6('')
               CALL q413_b_fill_7()  #採購
               CALL q413_bp2_7('')
               CALL cl_set_act_visible("query_ar", TRUE)
             ELSE
               CALL cl_set_act_visible("query_ar", FALSE)
             END IF
 
         ON ACTION query
            LET mi_need_cons = 1
            EXIT DISPLAY
 
         ON ACTION query_ar   #查詢客戶應收帳款
            LET g_action_choice="query_ar"
            EXIT DISPLAY
 
         ON ACTION view1
            LET g_renew = 0
            LET g_action_choice="view1"
            EXIT DISPLAY
         ON ACTION view2
            LET g_renew = 0
            LET g_action_choice="view2"
            EXIT DISPLAY
         ON ACTION view3
            LET g_renew = 0
            LET g_action_choice="view3"
            EXIT DISPLAY
         ON ACTION view4
            LET g_renew = 0
            LET g_action_choice="view4"
            EXIT DISPLAY
         ON ACTION view5
            LET g_renew = 0
            LET g_action_choice="view5"
            EXIT DISPLAY
         ON ACTION view6
            LET g_renew = 0
            LET g_action_choice="view6"
            EXIT DISPLAY
         ON ACTION view7
            LET g_renew = 0
            LET g_action_choice="view7"
            EXIT DISPLAY
 
         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT DISPLAY     
 
         ON ACTION help
            CALL cl_show_help()
            EXIT DISPLAY
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DISPLAY
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
         ON ACTION about
            CALL cl_about()
      END DISPLAY
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q413_q()
 
   LET g_renew = 1
   CALL q413_b_askkey()
END FUNCTION
 
 
FUNCTION q413_b_askkey()
 
   CLEAR FORM
   CALL g_oea1.clear()
   LET g_chk_oeaplant = TRUE
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON oeaplant,oea02,oea01,oea00,oea08,oea03,oea04,oea10,oea23,oea21,
                      oea31,oea32,oea14,oeaconf,oea49
                 FROM s_oea[1].oeaplant,s_oea[1].oea02,s_oea[1].oea01,s_oea[1].oea00,
                      s_oea[1].oea08,s_oea[1].oea03,s_oea[1].oea04,
                      s_oea[1].oea10,s_oea[1].oea23,s_oea[1].oea21,
                      s_oea[1].oea31,s_oea[1].oea32,s_oea[1].oea14,
                      s_oea[1].oeaconf,s_oea[1].oea49
 
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
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oeaplant
                   NEXT FIELD oeaplant
               WHEN INFIELD(oea03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea03
                    NEXT FIELD oea03
               WHEN INFIELD(oea01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oea11_t" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea01
                    NEXT FIELD oea01
               WHEN INFIELD(oea04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    IF g_aza.aza50='Y' THEN
                       LET g_qryparam.form ="q_occ4"    
                    ELSE
                       LET g_qryparam.form ="q_occ" 
                    END IF
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea04
                    NEXT FIELD oea04
               WHEN INFIELD(oea14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea14
                    NEXT FIELD oea14
               WHEN INFIELD(oea21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gec"
                    LET g_qryparam.arg1 = '2'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea21
                    NEXT FIELD oea21
               WHEN INFIELD(oea23)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea23
                    NEXT FIELD oea23
               WHEN INFIELD(oea31)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oah"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea31
                    NEXT FIELD oea31
               WHEN INFIELD(oea32)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oag"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea32
                    NEXT FIELD oea32
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
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   IF g_chk_oeaplant THEN
      CALL q413_chk_auth()
   END IF
   CALL q413_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_oea1_t.* = g_oea1[l_ac1].*
 
   CALL q413_b_fill_1()
   CALL q413_b_fill_2()
   CALL q413_b_fill_3()
   CALL q413_b_fill_4()
   CALL q413_b_fill_5()
   CALL q413_b_fill_6()
   CALL q413_b_fill_7()
END FUNCTION
 
FUNCTION q413_b1_fill(p_wc2)
DEFINE p_wc2     STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_zxy03 LIKE zxy_file.zxy03  #TQC-A10070 ADD
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add
 
    LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file ",
                " WHERE zxy01 = '",g_user,"' "
    PREPARE q413_pre FROM g_sql
    DECLARE q413_DB_cs CURSOR FOR q413_pre
    LET g_sql2 = ''
    FOREACH q413_DB_cs INTO l_zxy03 
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:q413_DB_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF 
#TQC-B90175 add START------------------------------
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_zxy03
       IF NOT cl_chk_schema_has_built(l_azp03) THEN
          CONTINUE FOREACH
       END IF
#TQC-B90175 add END------------------------------
      #FUN-A50102 ---mark---str--- 
      #TQC-A10070 ADD-------------------------------
       #LET g_plant_new = l_zxy03
       #CALL s_gettrandbs()
       #LET g_dbs = g_dbs_tra
       #LET g_dbs = s_dbstring(g_dbs) 
      #TQC-A10070 ADD-------------------------------
      #FUN-A50102 ---mark---end---
       LET g_sql = "SELECT DISTINCT oeaplant,'',oea02,oea01,oea00,oea08,oea03,oea032,oea04,'',",
               "       oea10,oea23,oea21,oea31,oea32,oea14,'',oeaconf,oea49", 
               #"  FROM ",g_dbs CLIPPED,"oea_file ", #FUN-A50102
                "  FROM ",cl_get_target_table(l_zxy03, 'oea_file'), #FUN-A50102
               " WHERE ",p_wc2 CLIPPED," AND oeaplant='",l_zxy03,"'",  #No.TQC-A10096
               "   AND oea00 IN ('1','2','3','4','6','7')"
       IF g_chk_oeaplant THEN
          LET g_sql = g_sql," AND oeaplant IN ",g_chk_auth
       END IF
       LET g_sql = "(",g_sql,")"
       IF g_sql2 IS NULL THEN
          LET g_sql2 = g_sql
       ELSE
          LET g_sql = g_sql2," UNION ALL ",g_sql
          LET g_sql2 = g_sql
       END IF
    END FOREACH
   LET g_sql = g_sql," ORDER BY oea02,oea03 "
 
   PREPARE q413_pb1 FROM g_sql
   DECLARE oea_curs CURSOR FOR q413_pb1
  
   CALL g_oea1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oea_curs INTO g_oea1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF
      SELECT azp02 INTO g_oea1[g_cnt].oeaplant_desc
        FROM azp_file
       WHERE azp01 = g_oea1[g_cnt].oeaplant
      SELECT occ02 INTO g_oea1[g_cnt].occ02
        FROM occ_file
       WHERE occ01 = g_oea1[g_cnt].oea04
 
      SELECT gen02 INTO g_oea1[g_cnt].gen02
        FROM gen_file
       WHERE gen01 = g_oea1[g_cnt].oea14
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_oea1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION q413_b_fill_1()
DEFINE l_dbs LIKE azp_file.azp01
   #TQC-A10070 MARK & ADD-------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oea1[l_ac1].oeaplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oea1[l_ac1].oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
    #LET l_dbs = s_dbstring(l_dbs CLIPPED) 
    #FUN-A50102 ---mark---end---
   #TQC-A10070 MARK & ADD------------- 
    LET g_sql =
        "SELECT DISTINCT oeb03,oeb04,'','','','','','','','','','','','','','','','',",
        "       '','','','','',oeb06,ima021,ima1002,ima135,oeb11,",  
        "       oeb71,oeb1001,oeb1012,",
        "       oeb906,oeb092,oeb15,oeb05,oeb12,",  
        "       oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,",
        "       oeb916,oeb917,oeb24,oeb27,oeb28,oeb1004,oeb1002,",  
        "       oeb13,oeb1006,oeb14,oeb14t,oeb09,oeb091,oeb930,'',",
        "       oeb908,oeb22,oeb19,oeb70,ima15,oeb16 ", 
        #" FROM ",s_dbstring(l_dbs CLIPPED),"oeb_file LEFT JOIN ",s_dbstring(l_dbs CLIPPED),"ima_file ", #FUN-A50102
         " FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'oeb_file')," LEFT JOIN ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ima_file'), #FUN-A50102
        "   ON oeb04 = ima01 ",
        " WHERE oeb01 ='",g_oea1_t.oea01,"'",  #單頭
        " AND oeb1003='1' ",
        " ORDER BY oeb03"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102
   PREPARE q413_pb FROM g_sql
   DECLARE oeb_curs CURSOR FOR q413_pb
   
   LET g_sql = "SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,",
                     "       imx07,imx08,imx09,imx10 ",
                     #"  FROM ",s_dbstring(l_dbs CLIPPED),"imx_file", #FUN-A50102
                      "  FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'imx_file'), #FUN-A50102
                     " WHERE imx000 = ?" 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102                 
   PREPARE imx_cs1 FROM g_sql
   
   CALL g_oeb1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oeb_curs INTO g_oeb1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
         #得到該料件對應的父料件和所有屬性
         
         EXECUTE imx_cs1 USING g_oeb1[g_cnt].oeb04
                     INTO g_oeb1[g_cnt].att00,g_oeb1[g_cnt].att01,g_oeb1[g_cnt].att02,
                          g_oeb1[g_cnt].att03,g_oeb1[g_cnt].att04,g_oeb1[g_cnt].att05,
                          g_oeb1[g_cnt].att06,g_oeb1[g_cnt].att07,g_oeb1[g_cnt].att08,
                          g_oeb1[g_cnt].att09,g_oeb1[g_cnt].att10
 
 
         LET g_oeb1[g_cnt].att01_c = g_oeb1[g_cnt].att01
         LET g_oeb1[g_cnt].att02_c = g_oeb1[g_cnt].att02
         LET g_oeb1[g_cnt].att03_c = g_oeb1[g_cnt].att03
         LET g_oeb1[g_cnt].att04_c = g_oeb1[g_cnt].att04
         LET g_oeb1[g_cnt].att05_c = g_oeb1[g_cnt].att05
         LET g_oeb1[g_cnt].att06_c = g_oeb1[g_cnt].att06
         LET g_oeb1[g_cnt].att07_c = g_oeb1[g_cnt].att07
         LET g_oeb1[g_cnt].att08_c = g_oeb1[g_cnt].att08
         LET g_oeb1[g_cnt].att09_c = g_oeb1[g_cnt].att09
         LET g_oeb1[g_cnt].att10_c = g_oeb1[g_cnt].att10
                
      END IF
      LET g_oeb1[g_cnt].gem02c=s_costcenter_desc(g_oeb1[g_cnt].oeb930) 
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_oeb1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
#出通單
FUNCTION q413_b_fill_2()
DEFINE l_dbs LIKE azp_file.azp03 
   #TQC-A10070 MARK&ADD -----------------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oea1[l_ac1].oeaplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oea1[l_ac1].oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
    #FUN-A50102 ---mark---end---
   #TQC-A10070 MARK&ADD ----------------------- 
    LET g_sql =
        "SELECT oga01,ogb03,ogb1005,ogb31,ogb32,ogb04,",
        "       '','','','','','','','','',",
        "       '','','','','','','','','','','','',",
        "       ogb06,ima021,ima1002,ima135,ogb11,ogb1001,ogb1012,",  
        "       ogb17,ogb09,ogb091,ogb092,ogb1003,ogb19,ogb05,ogb12,",
        "       ogb913,ogb914,",  
        "       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917, ",
        "       0,0,0,ogb65,'','',",  
        "       ogb1004,ogb1002,ogb13,ogb1006,ogb14,ogb14t,",   
        "       ogb930,'',ogb908 ", 
        #" FROM ",s_dbstring(l_dbs CLIPPED),"ogb_file LEFT JOIN ",s_dbstring(l_dbs CLIPPED),"ima_file ON ogb04=ima01,", #FUN-A50102
        #       s_dbstring(l_dbs CLIPPED),"oga_file ",  #FUN-A50102 
        " FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ogb_file')," LEFT JOIN ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ima_file')," ON ogb04=ima01,", #FUN-A50102
               cl_get_target_table(g_oea1[l_ac1].oeaplant, 'oga_file'),  #FUN-A50102
        " WHERE ogb01 = oga01 ",  
        " AND ogb1005 ='1'",   
        "  AND oga09 IN ('1','5') ",
        "  AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY oga01,ogb03"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102   
    PREPARE q413_pb2 FROM g_sql
    DECLARE ogb1_cs                       #CURSOR
        CURSOR FOR q413_pb2
    LET g_sql = "SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,",
                     "       imx07,imx08,imx09,imx10 ",
                     #"  FROM ",s_dbstring(l_dbs CLIPPED),"imx_file", #FUN-A50102
                      "  FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'imx_file'), #FUN-A50102
                     " WHERE imx000 = ?" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102
    PREPARE imx_cs2 FROM g_sql
   
    CALL g_ogb1.clear()
 
    LET g_cnt = 1
    FOREACH ogb1_cs INTO g_ogb1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改                                                             
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
           EXECUTE imx_cs2 USING g_ogb1[g_cnt].ogb04_gb1
                           INTO  g_ogb1[g_cnt].att00_gb1,g_ogb1[g_cnt].att01_gb1,g_ogb1[g_cnt].att02_gb1,                                                         
                                 g_ogb1[g_cnt].att03_gb1,g_ogb1[g_cnt].att04_gb1,g_ogb1[g_cnt].att05_gb1,                                                         
                                 g_ogb1[g_cnt].att06_gb1,g_ogb1[g_cnt].att07_gb1,g_ogb1[g_cnt].att08_gb1,                                                         
                                 g_ogb1[g_cnt].att09_gb1,g_ogb1[g_cnt].att10_gb1                                                                             
                                                                                                                                    
           LET g_ogb1[g_cnt].att01_c_gb1 = g_ogb1[g_cnt].att01_gb1                                                                            
           LET g_ogb1[g_cnt].att02_c_gb1 = g_ogb1[g_cnt].att02_gb1                                                                            
           LET g_ogb1[g_cnt].att03_c_gb1 = g_ogb1[g_cnt].att03_gb1                                                                            
           LET g_ogb1[g_cnt].att04_c_gb1 = g_ogb1[g_cnt].att04_gb1                                                                            
           LET g_ogb1[g_cnt].att05_c_gb1 = g_ogb1[g_cnt].att05_gb1                                                                            
           LET g_ogb1[g_cnt].att06_c_gb1 = g_ogb1[g_cnt].att06_gb1                                                                            
           LET g_ogb1[g_cnt].att07_c_gb1 = g_ogb1[g_cnt].att07_gb1                                                                            
           LET g_ogb1[g_cnt].att08_c_gb1 = g_ogb1[g_cnt].att08_gb1                                                                            
           LET g_ogb1[g_cnt].att09_c_gb1 = g_ogb1[g_cnt].att09_gb1                                                                            
           LET g_ogb1[g_cnt].att10_c_gb1 = g_ogb1[g_cnt].att10_gb1                                                                            
        END IF  
 
        IF cl_null(g_ogb1[g_cnt].ogb910_gb1) THEN 
           LET g_ogb1[g_cnt].ogb911_gb1 = NULL
           LET g_ogb1[g_cnt].ogb912_gb1 = NULL
        END IF
        IF cl_null(g_ogb1[g_cnt].ogb913_gb1) THEN 
           LET g_ogb1[g_cnt].ogb914_gb1 = NULL
           LET g_ogb1[g_cnt].ogb915_gb1 = NULL
        END IF
        IF g_ogb1[g_cnt].ogb04_gb1[1,4]!='MISC' THEN 
           SELECT ima1002,ima135 INTO g_ogb1[g_cnt].ima1002_gb1,g_ogb1[g_cnt].ima135_gb1                                                    
             FROM ima_file                                                                                                    
            WHERE ima01 = g_ogb1[g_cnt].ogb04_gb1                                                                                  
        END IF                                            
        LET g_ogb1[g_cnt].gem02c_gb1=s_costcenter_desc(g_ogb1[g_cnt].ogb930_gb1) 
        LET g_cnt = g_cnt + 1
    END FOREACH
 
   CALL g_ogb1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b2 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
#出貨單
FUNCTION q413_b_fill_3()
DEFINE l_oga65    LIKE oga_file.oga65
DEFINE l_dbs LIKE azp_file.azp03  
   #TQC-A10070 MARK&ADD--------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oea1[l_ac1].oeaplant
   #FUN-A50102 ---mark---str---
    #LET g_plant_new  = g_oea1[l_ac1].oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
   #FUN-A50102 ---mark---end---
   #TQC-A10070 MARK&ADD-------------- 
 
    LET g_sql =
        "SELECT oga01,ogb03,ogb1005,ogb31,ogb32,ogb04,",
        "       '','','','','','','','','',",
        "       '','','','','','','','','','','','',",
        "       ogb06,ima021,ima1002,ima135,ogb11,ogb1001,ogb1012,",  
        "       ogb17,ogb09,ogb091,ogb092,ogb1003,ogb19,ogb05,ogb12,",
        "       ogb913,ogb914,",  
        "       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917, ",
        "       0,0,0,ogb65,'','',",  
        "       ogb1004,ogb1002,ogb13,ogb1006,ogb14,ogb14t,",   
        "       ogb930,'',ogb908 ", 
        #" FROM ",s_dbstring(l_dbs CLIPPED),"oga_file,",l_dbs CLIPPED,"ogb_file LEFT JOIN ", #FUN-A50102
        #         s_dbstring(l_dbs CLIPPED),"ima_file ON ogb04=ima01",     #FUN-A50102
        " FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'oga_file'),",",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ogb_file')," LEFT JOIN ", #FUN-A50102
                 cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ima_file')," ON ogb04=ima01",     #FUN-A50102         
        " WHERE ogb01 = oga01 ",  
        " AND ogb1005 ='1'",   
        "  AND oga09 IN ('2','3','4','6') ",
        "  AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY oga01,ogb03"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102 
    PREPARE q413_pb3 FROM g_sql
    DECLARE ogb2_cs                       #CURSOR
        CURSOR FOR q413_pb3
    LET g_sql = "SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,",
                "       imx07,imx08,imx09,imx10 ",
               #"  FROM ",s_dbstring(l_dbs CLIPPED),"imx_file", #FUN-A50102
                "  FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'imx_file'), #FUN-A50102
                " WHERE imx000 = ?" 
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102                 
    PREPARE imx_cs3 FROM g_sql
    #LET g_sql = "SELECT ogb01 FROM ",s_dbstring(l_dbs CLIPPED),"ogb_file,", #FUN-A50102
    #                                 s_dbstring(l_dbs CLIPPED),"oga_file",  #FUN-A50102 
     LET g_sql = "SELECT ogb01 FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ogb_file'), #FUN-A50102
                                      cl_get_target_table(g_oea1[l_ac1].oeaplant, 'oga_file'), #FUN-A50102                                
                 " WHERE ogb01 = oga01 ",
                 "   AND oga011 = ? AND oga09 = ? AND ogb03 = ?",
                 "   AND ogb65 = 'Y'"  
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102
    PREPARE ogb_cs1 FROM g_sql
    CALL g_ogb2.clear()
 
    LET g_cnt = 1
    FOREACH ogb2_cs INTO g_ogb2[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        ##如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改                                                             
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
           EXECUTE imx_cs3 USING g_ogb2[g_cnt].ogb04_gb2                                                                                  
            INTO  g_ogb2[g_cnt].att00_gb2,g_ogb2[g_cnt].att01_gb2,g_ogb2[g_cnt].att02_gb2,                                                         
                  g_ogb2[g_cnt].att03_gb2,g_ogb2[g_cnt].att04_gb2,g_ogb2[g_cnt].att05_gb2,                                                         
                  g_ogb2[g_cnt].att06_gb2,g_ogb2[g_cnt].att07_gb2,g_ogb2[g_cnt].att08_gb2,                                                         
                  g_ogb2[g_cnt].att09_gb2,g_ogb2[g_cnt].att10_gb2                                                                             
                                                                                                                                    
           LET g_ogb2[g_cnt].att01_c_gb2 = g_ogb2[g_cnt].att01_gb2                                                                            
           LET g_ogb2[g_cnt].att02_c_gb2 = g_ogb2[g_cnt].att02_gb2                                                                            
           LET g_ogb2[g_cnt].att03_c_gb2 = g_ogb2[g_cnt].att03_gb2                                                                            
           LET g_ogb2[g_cnt].att04_c_gb2 = g_ogb2[g_cnt].att04_gb2                                                                            
           LET g_ogb2[g_cnt].att05_c_gb2 = g_ogb2[g_cnt].att05_gb2                                                                            
           LET g_ogb2[g_cnt].att06_c_gb2 = g_ogb2[g_cnt].att06_gb2                                                                            
           LET g_ogb2[g_cnt].att07_c_gb2 = g_ogb2[g_cnt].att07_gb2                                                                            
           LET g_ogb2[g_cnt].att08_c_gb2 = g_ogb2[g_cnt].att08_gb2                                                                            
           LET g_ogb2[g_cnt].att09_c_gb2 = g_ogb2[g_cnt].att09_gb2                                                                            
           LET g_ogb2[g_cnt].att10_c_gb2 = g_ogb2[g_cnt].att10_gb2                                                                            
        END IF  
 
        IF cl_null(g_ogb2[g_cnt].ogb910_gb2) THEN 
           LET g_ogb2[g_cnt].ogb911_gb2 = NULL
           LET g_ogb2[g_cnt].ogb912_gb2 = NULL
        END IF
        IF cl_null(g_ogb2[g_cnt].ogb913_gb2) THEN 
           LET g_ogb2[g_cnt].ogb914_gb2 = NULL
           LET g_ogb2[g_cnt].ogb915_gb2 = NULL
        END IF
        IF g_ogb2[g_cnt].ogb04_gb2[1,4]!='MISC' THEN 
           SELECT ima1002,ima135 INTO g_ogb2[g_cnt].ima1002_gb2,g_ogb2[g_cnt].ima135_gb2                                                    
             FROM ima_file                                                                                                    
            WHERE ima01 = g_ogb2[g_cnt].ogb04_gb2                                                                                  
        END IF   
 
        EXECUTE ogb_cs1 USING g_ogb2[g_cnt].ogb01_gb2,'8',g_ogb2[g_cnt].ogb03_gb2
                         INTO g_ogb2[g_cnt].ogb01a_gb2
        EXECUTE ogb_cs1 USING g_ogb2[g_cnt].ogb01_gb2,'9',g_ogb2[g_cnt].ogb03_gb2
                         INTO g_ogb2[g_cnt].ogb01b_gb2
 
        LET g_ogb2[g_cnt].gem02c_gb2=s_costcenter_desc(g_ogb2[g_cnt].ogb930_gb2) 
        LET g_cnt = g_cnt + 1
    END FOREACH
   CALL g_ogb2.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b3 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
#應收
FUNCTION q413_b_fill_4()
DEFINE l_dbs LIKE azp_file.azp03  
   #TQC-A10070 MARK&ADD------------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oea1[l_ac1].oeaplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oea1[l_ac1].oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
    #FUN-A50102 ---mark---end---
   #TQC-A10070 MARK&ADD------------------ 
     
    LET g_sql =
        "SELECT omb01,omb03,omb38,omb31,omb32,omb39,omb04,omb06,",
        "       omb40,omb05,omb12,omb33,omb331,", 
        "       omb13,omb14,omb14t,omb15,omb16,omb16t,",
        "       omb17,omb18,omb18t,omb930,''", 
        #" FROM ",s_dbstring(l_dbs CLIPPED),"omb_file,",s_dbstring(l_dbs CLIPPED),"oga_file,", #FUN-A50102
        #         s_dbstring(l_dbs CLIPPED),"ogb_file ",    #FUN-A50102
        " FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'omb_file'),",",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'oga_file'),",", #FUN-A50102
                 cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ogb_file'),    #FUN-A50102         
        " WHERE omb01 = oga10 ",  
        "   AND oga01 = ogb01 ",
        "   AND omb31 = ogb01 ",
        "   AND omb32 = ogb03 ",
        "   AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY omb03"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102  
    PREPARE q413_pb4 FROM g_sql
    DECLARE omb_curs CURSOR FOR q413_pb4      #SCROLL CURSOR
    CALL g_omb.clear()
    LET g_cnt = 1
    FOREACH omb_curs INTO g_omb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        LET g_omb[g_cnt].gem02c_omb=s_costcenter_desc(g_omb[g_cnt].omb930)
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_omb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b4 = g_cnt - 1
    CALL ui.Interface.refresh()
    LET g_cnt = 0
END FUNCTION
 
#工單
FUNCTION q413_b_fill_5()
DEFINE l_dbs LIKE azp_file.azp03  
   #TQC-A10070 MARK&ADD---------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oea1[l_ac1].oeaplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oea1[l_ac1].oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
    #FUN-A50102 ---mark---end---
   #TQC-A10070 MARK&ADD--------------- 
   LET g_sql = " SELECT sfb01,sfb81,sfb02,sfb221,sfb05,",
               "        '','',sfb08,sfb13,sfb15,sfb25,sfb081,",
               "        sfb09,sfb12,sfb87,sfb04",
               #" FROM ",s_dbstring(l_dbs CLIPPED),"sfb_file ", #FUN-A50102
                " FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'sfb_file'), #FUN-A50102
               " WHERE sfb22 = '", g_oea1_t.oea01 CLIPPED, "'" 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102           
   PREPARE q413_pb5 FROM g_sql
   DECLARE sfb_curs CURSOR FOR q413_pb5
  
   CALL g_sfb.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH sfb_curs INTO g_sfb[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
     
      IF NOT cl_null(g_sfb[g_cnt].sfb05) THEN
         SELECT ima02,ima021 INTO g_sfb[g_cnt].ima02_sfb,
                                  g_sfb[g_cnt].ima021_sfb
           FROM ima_file
          WHERE ima01 = g_sfb[g_cnt].sfb05
      END IF 
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_sfb.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b5 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
 
#請購單
FUNCTION q413_b_fill_6()
DEFINE l_dbs LIKE azp_file.azp03  
   #TQC-A10070 ADD&MARK------------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oea1[l_ac1].oeaplant
   #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oea1[l_ac1].oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
   #FUN-A50102 ---mark---end--- 
   #TQC-A10070 ADD&MARK------------------ 
   LET g_sql="SELECT pml01,pml02,pml24,pml25,pml04,",
             "      '','','','','','','','','','','','','','','','','','','','','', ",  #NO.FUN-670007 add pml24/pml25
             "       pml041,ima021,pml07,pml20,",
             "       pml83,pml84,pml85,pml80,pml81,pml82,pml86,pml87,",
             "       pml21,pml35,pml34,pml33,pml41,",   
             "       pml190,pml191,pml192,",     
             "       pml12,pml121,pml122,pml930,'',pml06,pml38,pml11 ", 
             #" FROM ",s_dbstring(l_dbs CLIPPED),"pml_file LEFT JOIN ",s_dbstring(l_dbs CLIPPED),"ima_file ON pml04=ima01 ",#FUN-A50102
              " FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'pml_file')," LEFT JOIN ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ima_file')," ON pml04=ima01 ",#FUN-A50102
             " WHERE pml24 = '",g_oea1_t.oea01 CLIPPED,"'",
             " ORDER BY pml01,pml02 " 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102  
   PREPARE q413_pb6 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE pml_cs CURSOR FOR q413_pb6
   LET g_sql = "SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,",
                     "       imx07,imx08,imx09,imx10 ",
                     #"  FROM ",s_dbstring(l_dbs CLIPPED),"imx_file",
                     "   FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'imx_file'),
                     " WHERE imx000 = ?"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102
   PREPARE imx_cs4 FROM g_sql
   CALL g_pml.clear()
   LET g_cnt=1
   FOREACH pml_cs INTO g_pml[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      IF cl_null(g_pml[g_cnt].pml80) THEN
         LET g_pml[g_cnt].pml81 = NULL
         LET g_pml[g_cnt].pml82 = NULL
      END IF
      IF cl_null(g_pml[g_cnt].pml83) THEN
         LET g_pml[g_cnt].pml84 = NULL
         LET g_pml[g_cnt].pml85 = NULL
      END IF
      SELECT gem02 INTO g_pml[g_cnt].gem02a_ml FROM gem_file
                            WHERE gem01=g_pml[g_cnt].pml930
                             
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改         
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                       
         #得到該料件對應的父料件和所有屬性         
         EXECUTE imx_cs4 USING g_pml[g_cnt].pml04                                                           
            INTO g_pml[g_cnt].att00_ml,g_pml[g_cnt].att01_ml,g_pml[g_cnt].att02_ml,     
                g_pml[g_cnt].att03_ml,g_pml[g_cnt].att04_ml,g_pml[g_cnt].att05_ml,     
                g_pml[g_cnt].att06_ml,g_pml[g_cnt].att07_ml,g_pml[g_cnt].att08_ml,     
                g_pml[g_cnt].att09_ml,g_pml[g_cnt].att10_ml                         
 
         LET g_pml[g_cnt].att01_c_ml = g_pml[g_cnt].att01_ml                        
         LET g_pml[g_cnt].att02_c_ml = g_pml[g_cnt].att02_ml                        
         LET g_pml[g_cnt].att03_c_ml = g_pml[g_cnt].att03_ml                        
         LET g_pml[g_cnt].att04_c_ml = g_pml[g_cnt].att04_ml                        
         LET g_pml[g_cnt].att05_c_ml = g_pml[g_cnt].att05_ml                        
         LET g_pml[g_cnt].att06_c_ml = g_pml[g_cnt].att06_ml                        
         LET g_pml[g_cnt].att07_c_ml = g_pml[g_cnt].att07_ml                        
         LET g_pml[g_cnt].att08_c_ml = g_pml[g_cnt].att08_ml                        
         LET g_pml[g_cnt].att09_c_ml = g_pml[g_cnt].att09_ml                        
         LET g_pml[g_cnt].att10_c_ml = g_pml[g_cnt].att10_ml                        
                                                                              
      END IF                                                                  
                               
      LET g_cnt = g_cnt +1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pml.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b6 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
 
#採購單
FUNCTION q413_b_fill_7()
DEFINE l_dbs LIKE azp_file.azp03  
   #TQC-A10070 MARK&ADD--------------
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01 = g_oea1[l_ac1].oeaplant
    #FUN-A50102 ---mark---str---
    #LET g_plant_new = g_oea1[l_ac1].oeaplant
    #CALL s_gettrandbs()
    #LET l_dbs = g_dbs_tra
    #FUN-A50102 ---mark---end---
   #TQC-A10070 MARK&ADD-------------- 
   LET g_sql ="SELECT pmn01,pmn02,pmn24,pmn25,pmn65,pmn41,pmn42,pmn16,pmn04,",
              "       pmn041,ima021,pmn07,pmn20,pmn83,pmn84,pmn85,",
              "       pmn80,pmn81,pmn82,pmn86,pmn87,pmn68,pmn69,pmn31,",
              "       pmn31t,pmn64,pmn63,pmn33,pmn34,pmn122,pmn930,'',",
              "       pmn43,pmn431 ",  
              "      ,pmn38 ,pmn90",   
              #"  FROM ",s_dbstring(l_dbs CLIPPED),".pmn_file LEFT JOIN ",s_dbstring(l_dbs CLIPPED),"ima_file ON pmn04=ima01",#FUN-A50102
               "  FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'pmn_file')," LEFT JOIN ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'ima_file')," ON pmn04=ima01",#FUN-A50102
              " WHERE  pmn24 ='", g_oea1_t.oea01 CLIPPED, "'", 
              " ORDER BY pmn01,pmn02"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102  
   PREPARE q413_pb7 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE pmn_cs CURSOR FOR q413_pb7
   LET g_sql = "SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,",
                     "       imx07,imx08,imx09,imx10 ",
                     #"  FROM ",s_dbstring(l_dbs CLIPPED),"imx_file",#FUN-A50102
                      "  FROM ",cl_get_target_table(g_oea1[l_ac1].oeaplant, 'imx_file'),#FUN-A50102
                     " WHERE imx000 = ?" 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                          #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, g_oea1[l_ac1].oeaplant) RETURNING g_sql  #FUN-A50102                  
   PREPARE imx_cs5 FROM g_sql
   CALL g_pmn.clear()
   LET g_cnt = 1
   FOREACH pmn_cs INTO g_pmn[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
         #得到該料件對應的父料件和所有屬性
         EXECUTE imx_cs5 USING g_pmn[g_cnt].pmn04
         INTO   g_pmn[g_cnt].att00_mn,g_pmn[g_cnt].att01_mn,g_pmn[g_cnt].att02_mn,
                g_pmn[g_cnt].att03_mn,g_pmn[g_cnt].att04_mn,g_pmn[g_cnt].att05_mn,
                g_pmn[g_cnt].att06_mn,g_pmn[g_cnt].att07_mn,g_pmn[g_cnt].att08_mn,
                g_pmn[g_cnt].att09_mn,g_pmn[g_cnt].att10_mn
 
 
           LET g_pmn[g_cnt].att01_c_mn = g_pmn[g_cnt].att01_mn
           LET g_pmn[g_cnt].att02_c_mn = g_pmn[g_cnt].att02_mn
           LET g_pmn[g_cnt].att03_c_mn = g_pmn[g_cnt].att03_mn
           LET g_pmn[g_cnt].att04_c_mn = g_pmn[g_cnt].att04_mn
           LET g_pmn[g_cnt].att05_c_mn = g_pmn[g_cnt].att05_mn
           LET g_pmn[g_cnt].att06_c_mn = g_pmn[g_cnt].att06_mn
           LET g_pmn[g_cnt].att07_c_mn = g_pmn[g_cnt].att07_mn
           LET g_pmn[g_cnt].att08_c_mn = g_pmn[g_cnt].att08_mn
           LET g_pmn[g_cnt].att09_c_mn = g_pmn[g_cnt].att09_mn
           LET g_pmn[g_cnt].att10_c_mn = g_pmn[g_cnt].att10_mn
                                   
      END IF                       
 
      SELECT gem02 INTO g_pmn[g_cnt].gem02a_mn 
        FROM gem_file
       WHERE gem01= g_pmn[g_cnt].pmn930
     
      LET g_cnt = g_cnt+1
      IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 1 ) #MOD-640492 0->1
       EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_pmn.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b7 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
 
#訂單
FUNCTION q413_bp2_1(p_cmd)
DEFINE p_cmd   LIKE  type_file.chr1
DEFINE l_action LIKE type_file.chr10   
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oeb1 TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE ROW
         LET l_ac_b1 = ARR_CURR()
 
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
    #FUN-740264   BEGIN
      ON ACTION view1
        LET l_action = ''
      ON ACTION view2
        LET l_action = 'view2'
        EXIT DISPLAY
      ON ACTION view3
        LET l_action = 'view3'
        EXIT DISPLAY
      ON ACTION view4
        LET l_action = 'view4'
        EXIT DISPLAY
      ON ACTION view5
        LET l_action = 'view5'
        EXIT DISPLAY
      ON ACTION view6
        LET l_action = 'view6'
        EXIT DISPLAY
      ON ACTION view7
        LET l_action = 'view7'
        EXIT DISPLAY
      ON ACTION so_detail
        LET l_action = 'so'
        EXIT DISPLAY
    #FUN-740264 END
      ON ACTION return1
         EXIT DISPLAY
      ON ACTION return2
         EXIT DISPLAY
      ON ACTION return3
         EXIT DISPLAY
      ON ACTION return4
         EXIT DISPLAY
      ON ACTION return5
         EXIT DISPLAY
      ON ACTION return6
         EXIT DISPLAY
      ON ACTION return7
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
   END DISPLAY
   CALL q413_b_act(l_action) 
END FUNCTION
 
#出通
FUNCTION q413_bp2_2(p_cmd)
DEFINE p_cmd   LIKE  type_file.chr1
DEFINE l_action LIKE type_file.chr10   
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb1 TO s_ogb1.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE ROW
         LET l_ac_b2 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
    #FUN-740264    BEGIN
      ON ACTION view1
        LET l_action = 'view1'
        EXIT DISPLAY
      ON ACTION view2
        LET l_action = ''
      ON ACTION view3
        LET l_action = 'view3'
        EXIT DISPLAY
      ON ACTION view4
        LET l_action = 'view4'
        EXIT DISPLAY
      ON ACTION view5
        LET l_action = 'view5'
        EXIT DISPLAY
      ON ACTION view6
        LET l_action = 'view6'
        EXIT DISPLAY
      ON ACTION view7
        LET l_action = 'view7'
        EXIT DISPLAY
      ON ACTION da_detail
        LET l_action = 'da'
        EXIT DISPLAY
    #FUN-740264     END
      ON ACTION return2
         EXIT DISPLAY
      ON ACTION return1
         EXIT DISPLAY
      ON ACTION return3
         EXIT DISPLAY
      ON ACTION return4
         EXIT DISPLAY
      ON ACTION return5
         EXIT DISPLAY
      ON ACTION return6
         EXIT DISPLAY
      ON ACTION return7
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
   END DISPLAY
   CALL q413_b_act(l_action)  
END FUNCTION
 
 
#出貨
FUNCTION q413_bp2_3(p_cmd)
DEFINE p_cmd   LIKE  type_file.chr1
DEFINE l_action LIKE type_file.chr10  
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb2 TO s_ogb2.* ATTRIBUTE(COUNT=g_rec_b3)
      BEFORE ROW
         LET l_ac_b3 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION view1
        LET l_action = 'view1'
        EXIT DISPLAY
      ON ACTION view2
        LET l_action = 'view2'
        EXIT DISPLAY
      ON ACTION view3
        LET l_action = ''
      ON ACTION view4
        LET l_action = 'view4'
        EXIT DISPLAY
      ON ACTION view5
        LET l_action = 'view5'
        EXIT DISPLAY
      ON ACTION view6
        LET l_action = 'view6'
        EXIT DISPLAY
      ON ACTION view7
        LET l_action = 'view7'
        EXIT DISPLAY
      ON ACTION dn_detail
        LET l_action = 'dn'
        EXIT DISPLAY
      ON ACTION return3
         EXIT DISPLAY
      ON ACTION return1
         EXIT DISPLAY
      ON ACTION return2
         EXIT DISPLAY
      ON ACTION return4
         EXIT DISPLAY
      ON ACTION return5
         EXIT DISPLAY
      ON ACTION return6
         EXIT DISPLAY
      ON ACTION return7
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
   END DISPLAY
   CALL q413_b_act(l_action)  
END FUNCTION
 
#應收
FUNCTION q413_bp2_4(p_cmd)
DEFINE p_cmd   LIKE  type_file.chr1
DEFINE l_action LIKE type_file.chr10   
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b4)
      BEFORE ROW
         LET l_ac_b4 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION view1
        LET l_action = 'view1'
        EXIT DISPLAY
      ON ACTION view2
        LET l_action = 'view2'
        EXIT DISPLAY
      ON ACTION view3
        LET l_action = 'view3'
        EXIT DISPLAY
      ON ACTION view4
        LET l_action = ''
      ON ACTION view5
        LET l_action = 'view5'
        EXIT DISPLAY
      ON ACTION view6
        LET l_action = 'view6'
        EXIT DISPLAY
      ON ACTION view7
        LET l_action = 'view7'
        EXIT DISPLAY
      ON ACTION ar_detail
        LET l_action = 'ar'
        EXIT DISPLAY
      ON ACTION return4
         EXIT DISPLAY
      ON ACTION return1
         EXIT DISPLAY
      ON ACTION return2
         EXIT DISPLAY
      ON ACTION return3
         EXIT DISPLAY
      ON ACTION return5
         EXIT DISPLAY
      ON ACTION return6
         EXIT DISPLAY
      ON ACTION return7
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
   END DISPLAY
   CALL q413_b_act(l_action)  
END FUNCTION
 
#工單
FUNCTION q413_bp2_5(p_cmd)
DEFINE p_cmd   LIKE  type_file.chr1
DEFINE l_action LIKE type_file.chr10 
  
    CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b5)
      BEFORE ROW
         LET l_ac_b5 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION view1
        LET l_action = 'view1'
        EXIT DISPLAY
      ON ACTION view2
        LET l_action = 'view2'
        EXIT DISPLAY
      ON ACTION view3
        LET l_action = 'view3'
        EXIT DISPLAY
      ON ACTION view4
        LET l_action = 'view4'
        EXIT DISPLAY
      ON ACTION view5
        LET l_action = ''
      ON ACTION view6
        LET l_action = 'view6'
        EXIT DISPLAY
      ON ACTION view7
        LET l_action = 'view7'
        EXIT DISPLAY
      ON ACTION wo_detail
        LET l_action = 'wo'
        EXIT DISPLAY
      ON ACTION return5
         EXIT DISPLAY
      ON ACTION return1
         EXIT DISPLAY
      ON ACTION return2
         EXIT DISPLAY
      ON ACTION return3
         EXIT DISPLAY
      ON ACTION return4
         EXIT DISPLAY
      ON ACTION return6
         EXIT DISPLAY
      ON ACTION return7
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
   END DISPLAY
   CALL q413_b_act(l_action)  
END FUNCTION
 
#請購
FUNCTION q413_bp2_6(p_cmd)
DEFINE p_cmd   LIKE  type_file.chr1
DEFINE l_action LIKE type_file.chr10   
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b6)
      BEFORE ROW
         LET l_ac_b6 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION view1
        LET l_action = 'view1'
        EXIT DISPLAY
      ON ACTION view2
        LET l_action = 'view2'
        EXIT DISPLAY
      ON ACTION view3
        LET l_action = 'view3'
        EXIT DISPLAY
      ON ACTION view4
        LET l_action = 'view4'
        EXIT DISPLAY
      ON ACTION view5
        LET l_action = 'view5'
        EXIT DISPLAY
      ON ACTION view6
        LET l_action = ''
      ON ACTION view7
        LET l_action = 'view7'
        EXIT DISPLAY
      ON ACTION pr_detail
        LET l_action = 'pr'
        EXIT DISPLAY
      ON ACTION return6
         EXIT DISPLAY
      ON ACTION return1
         EXIT DISPLAY
      ON ACTION return2
         EXIT DISPLAY
      ON ACTION return3
         EXIT DISPLAY
      ON ACTION return4
         EXIT DISPLAY
      ON ACTION return5
         EXIT DISPLAY
      ON ACTION return7
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
   END DISPLAY
   CALL q413_b_act(l_action)  
END FUNCTION
 
 
FUNCTION q413_bp2_7(p_cmd)
DEFINE p_cmd   LIKE  type_file.chr1
DEFINE l_action LIKE type_file.chr10  
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b7)
      BEFORE ROW
         LET l_ac_b7 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION view1
        LET l_action = 'view1'
        EXIT DISPLAY
      ON ACTION view2
        LET l_action = 'view2'
        EXIT DISPLAY
      ON ACTION view3
        LET l_action = 'view3'
        EXIT DISPLAY
      ON ACTION view4
        LET l_action = 'view4'
        EXIT DISPLAY
      ON ACTION view5
        LET l_action = 'view5'
        EXIT DISPLAY
      ON ACTION view6
        LET l_action = 'view6'
        EXIT DISPLAY
      ON ACTION view7
        LET l_action = ''
      ON ACTION po_detail
        LET l_action = 'po'
        EXIT DISPLAY
      ON ACTION return7
         EXIT DISPLAY
      ON ACTION return1
         EXIT DISPLAY
      ON ACTION return2
         EXIT DISPLAY
      ON ACTION return3
         EXIT DISPLAY
      ON ACTION return4
         EXIT DISPLAY
      ON ACTION return5
         EXIT DISPLAY
      ON ACTION return6
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
   END DISPLAY
   CALL q413_b_act(l_action)  
END FUNCTION
 
FUNCTION q413_b_act(l_act)
  DEFINE l_act    LIKE  type_file.chr10
  CASE l_act
    WHEN "view1"
      CALL q413_bp2_1('V')
    WHEN "view2"
      CALL q413_bp2_2('V')
    WHEN "view3"
      CALL q413_bp2_3('V')
    WHEN "view4"
      CALL q413_bp2_4('V')
    WHEN "view5"
      CALL q413_bp2_5('V')
    WHEN "view6"
      CALL q413_bp2_6('V')
    WHEN "view7"
      CALL q413_bp2_7('V')
    WHEN "so"  #訂單
      LET g_msg = " axmt410 '",g_oea1_t.oea01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    WHEN "da"  #出通
      IF l_ac_b2<>0 THEN
      LET g_msg = " axmt610 '",g_ogb1[l_ac_b2].ogb01_gb1 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
      END IF
    WHEN "dn"  #出貨
      IF l_ac_b3<>0 THEN
      LET g_msg = " axmt620 '",g_ogb2[l_ac_b3].ogb01_gb2 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
      END IF
    WHEN "ar"  #應收
      IF l_ac_b4<>0 THEN
      LET g_msg = " axrt300 '",g_omb[l_ac_b4].omb01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
      END IF
    WHEN "wo"  #工單
      IF l_ac_b5<>0 THEN
      LET g_msg = " asfi301 '",g_sfb[l_ac_b5].sfb01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
      END IF
    WHEN "pr"  #請購
      IF l_ac_b6<>0 THEN
      LET g_msg = " apmt420 '",g_pml[l_ac_b6].pml01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
      END IF
    WHEN "po"  #採購 
      IF l_ac_b7<>0 THEN
      LET g_msg = " apmt540 '",g_pmn[l_ac_b7].pmn01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
      END IF
  END CASE
END FUNCTION 
 
FUNCTION q413_refresh_detail()
  DEFINE l_compare          LIKE oay_file.oay22    
  DEFINE li_col_count       LIKE type_file.num5    
  DEFINE li_i, li_j         LIKE type_file.num5  
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) AND NOT cl_null(lg_oay22) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_oay22來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_oeb1.getLength() = 0 THEN
        LET lg_group = lg_oay22
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_oeb1.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_oeb1[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_oeb1[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN 
            LET lg_group = l_compare
         #以后是比較   
         ELSE 
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
         IF lg_group <> lg_oay22 THEN                                                                                               
            LET lg_group = ''                                                                                                       
            EXIT FOR                                                                                                                
         END IF
       END FOR 
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替oeb04子料件編號來顯示
     #得到當前語言別下oeb04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'oeb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'ogb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00_gb1",l_gae04)
     CALL cl_set_comp_att_text("att00_gb2",l_gae04)
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'pml04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00_ml",l_gae04)
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'pmn04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00_mn",l_gae04)
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'oeb04,oeb06'
        LET ls_show = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn'
     ELSE
        LET ls_hide = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn'
        LET ls_show = 'oeb04,oeb06,ogb04_gb1,ogb04_gb2,ogb06_gb1,ogb06_gb2,pml041,pmn041'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             LET ls_show = ls_show || ",att" || lc_index || "_gb1"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_gb1"
             LET ls_show = ls_show || ",att" || lc_index || "_gb2"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_gb2"
             LET ls_show = ls_show || ",att" || lc_index || "_ml"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_ml"
             LET ls_show = ls_show || ",att" || lc_index || "_mn"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_mn"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_gb1",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_gb2",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_ml",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_mn",lr_agc[li_i].agc02)
             
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             LET ls_show = ls_show || ",att" || lc_index || "_c_gb1"
             LET ls_hide = ls_hide || ",att" || lc_index || "_gb1"
             LET ls_show = ls_show || ",att" || lc_index || "_c_gb2"
             LET ls_hide = ls_hide || ",att" || lc_index || "_gb2"
             LET ls_show = ls_show || ",att" || lc_index || "_c_ml"
             LET ls_hide = ls_hide || ",att" || lc_index || "_ml"
             LET ls_show = ls_show || ",att" || lc_index || "_c_mn"
             LET ls_hide = ls_hide || ",att" || lc_index || "_mn"
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_gb1",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_gb2",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_ml",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_mn",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_gb1",ls_combo_vals,ls_combo_txts)
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_gb2",ls_combo_vals,ls_combo_txts)
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_ml",ls_combo_vals,ls_combo_txts)
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_mn",ls_combo_vals,ls_combo_txts)
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             LET ls_show = ls_show || ",att" || lc_index || "_gb1"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_gb1"
             LET ls_show = ls_show || ",att" || lc_index || "_gb2"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_gb2"
             LET ls_show = ls_show || ",att" || lc_index || "_ml"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_ml"
             LET ls_show = ls_show || ",att" || lc_index || "_mn"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_mn"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_gb1",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_gb2",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_ml",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_mn",lr_agc[li_i].agc02)
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn'
    LET ls_show = 'oeb04,ogb04_gb1,ogb04_gb2,pml041,pmn041'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
      LET ls_hide = ls_hide || ",att" || lc_index || "_gb1" || ",att" || lc_index || "_c_gb1"
      LET ls_hide = ls_hide || ",att" || lc_index || "_gb2" || ",att" || lc_index || "_c_gb2"
      LET ls_hide = ls_hide || ",att" || lc_index || "_ml"  || ",att" || lc_index || "_c_ml"
      LET ls_hide = ls_hide || ",att" || lc_index || "_mn"  || ",att" || lc_index || "_c_mn"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
FUNCTION q413_init()
DEFINE ls_hide_str STRING
 
   IF g_sma.sma120 = 'Y'  THEN                                                                                                      
      LET lg_oay22 = ''                                                                                                             
      LET lg_group = ''                                                                                                             
      CALL q413_refresh_detail()                                                                                                    
   END IF                                                                                                                           
 
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
 
 
   IF g_aza.aza50='Y' THEN
       CALL cl_set_comp_visible("ima1002,ima135,oeb11,oeb1012,oeb1004,oeb1002,
                                 oeb1006,oeb09,oeb091",TRUE)
   ELSE
       LET ls_hide_str = "ima1002,ima135,oeb11,oeb1012,oeb1004,oeb1002,",
                         "oeb1006,oeb09,oeb091,ogb11_gb1,ogb13_gb1,ogb14_gb1,",
                         "ogb14t_gb1,ogb1002_gb1,ogb1003_gb1,ogb1004_gb1,ogb1005_gb1,",
                         "ogb1006_gb1,ogb1012_gb1,ima1002_gb1,ima135_gb1,",
                         "ogb11_gb2,ogb13_gb2,ogb14_gb2,ogb14t_gb2,ogb1002_gb2,",
                         "ogb1003_gb2,ogb1004_gb2,ogb1005_gb2,ogb1006_gb2,ogb1012_gb2,",
                         "ima1002_gb2,ima135_gb2,oga1001,oga1002,oga1003,oga1005,oga1006,",
                         "oga1007,oga1008,oga1009,oga1010,oga1011,oga1013,oga1015"
       CALL cl_set_comp_visible(ls_hide_str,FALSE)
   END IF       
    
   LET ls_hide_str="ogb12b_gb1,ogb65_gb1,ogb915b_gb1,ogb912b_gb1,",
                   "ogb01a_gb1,ogb01b_gb1,oga01b_gb1,ogb12b_gb2,ogb65_gb2,ogb915b_gb2,ogb912b_gb2,",
                   "ogb01a_gb2,ogb01b_gb2,oga01b_gb2,ogb911_gb1,ogb914_gb1,",
                   "ogb1005_gb1,b2_1005_gb1,ogb911_gb2,ogb914_gb2,ogb1005_gb2,b2_1005_gb2,",
                   "ogb1005_gb1,ogb1007_gb1,tqw16_gb1,ogb1008_gb1,ogb1009_gb1,ogb1010_gb1,ogb1011_gb1,",
                   "ogb911_gb1,ogb914_gb1,ogb911_gb2,ogb914_gb2,ogb1005_gb1,ogb1007_gb1,ogb1008_gb1,",
                   "ogb1009_gb1,ogb1010_gb1,ogb1011_gb1 "
  CALL cl_set_comp_visible(ls_hide_str,FALSE)
 
    IF g_sma.sma115 ='N' THEN
       LET ls_hide_str = "oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,",
                         "ogb913_gb1,ogb914_gb1,ogb915_gb1,",
                         "ogb910_gb1,ogb911_gb1,ogb912_gb1,",
                         "ogb913_gb2,ogb914_gb2,ogb915_gb2,",                        
                         "ogb910_gb2,ogb911_gb2,ogb912_gb2"
       
    ELSE
       LET ls_hide_str = "oeb05,oeb12,oeb911,oeb914,",       
                         "ogb05_gb1,ogb12_gb1,",
                         "ogb05_gb2,ogb12_gb2,"      
    END IF
    CALL cl_set_comp_visible(ls_hide_str,FALSE)
    IF g_sma.sma116 MATCHES '[01]' THEN  
       CALL cl_set_comp_visible("oeb916,oeb917,ogb916_gb1,ogb917_gb1,ogb916_gb2,ogb917_gb2",FALSE)     
   END IF
 
   CALL cl_getmsg('axm-370',g_lang) RETURNING g_msg
   CALL cl_set_comp_att_text("oga01_gb1",g_msg CLIPPED)
   CALL cl_getmsg('axm-371',g_lang) RETURNING g_msg
   CALL cl_set_comp_att_text("oga02_gb1",g_msg CLIPPED)
   CALL cl_getmsg('axm-372',g_lang) RETURNING g_msg
   CALL cl_set_comp_att_text("oga011_gb1",g_msg CLIPPED)
   IF g_oaz.oaz23 = 'Y' THEN
      CALL cl_getmsg('axm-042',g_lang) RETURNING g_msg 
      CALL cl_set_comp_att_text("ogb17_gb1",g_msg CLIPPED)   
      CALL cl_set_comp_att_text("ogb17_gb2",g_msg CLIPPED)   
   END IF
  ############
 
    #初始化界面的樣式(沒有任何默認屬性組)
    LET lg_oay22 = ''
    LET lg_group = ''
    CALL q413_refresh_detail()
END FUNCTION
 
FUNCTION q413_qry_ar()
   LET g_msg = " axrq320 '",g_oea1_t.oea03 CLIPPED,"'"
   CALL cl_cmdrun_wait(g_msg CLIPPED)
END FUNCTION
 
FUNCTION q413_chk_auth()
DEFINE l_zxy03 LIKE zxy_file.zxy03
DEFINE l_azp03        LIKE azp_file.azp03      #TQC-B90175 add 
      LET g_chk_auth = ''
      DECLARE q413_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH q413_zxy_cs INTO l_zxy03
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
END FUNCTION
#FUN-C60062
#No.FUN-870007
