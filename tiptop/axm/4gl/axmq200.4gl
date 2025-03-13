# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: axmq200.4gl
# Descriptions...: 訂單查詢作業
# Date & Author..: No.TQC-730022 07/03/13 By rainy
# Modify.........: No.FUN-740046 07/04/12 By rainy pmn94/95->pmn24/25
# Modify.........: No.FUN-740264 07/05/25 By rainy 各單身加action串到主作業
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.MOD-830025 08/03/05 By lumx 修改oea01開窗，過濾多角貿易訂單
# Modify.........: No.CHI-8C0026 08/12/25 By Smapmin 改善執行效率
# Modify.........: No.TQC-960118 09/06/11 By Carrier 使用dynamic array前,檢查下票值是否>0
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No:MOD-A90128 10/10/22 By Smapmin 採購單記錄分頁資料有錯
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-BA0092 11/10/24 By lilingyu 增加出貨進度條顯示
# Modify.........: No:TQC-CB0021 12/11/07 By wuxj  查詢后，資料呈現后，點右上角的叉叉，關閉不了畫面,添加action
# Modify.........: No:TQC-CB0022 12/11/07 By xuxz 添加倉庫名稱欄位及規格欄位
# Modify.........: No:FUN-CC0024 13/02/22 By jt_chen 增加銷退單記錄,單位為銷退單身所有欄位,並增加倉庫名稱
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/axmq200.global"
 
#FUN-740264 begin
DEFINE l_ac_b1  LIKE type_file.num5
DEFINE l_ac_b2  LIKE type_file.num5
DEFINE l_ac_b3  LIKE type_file.num5
DEFINE l_ac_b4  LIKE type_file.num5
DEFINE l_ac_b5  LIKE type_file.num5
DEFINE l_ac_b6  LIKE type_file.num5
DEFINE l_ac_b7  LIKE type_file.num5
DEFINE l_ac_b8  LIKE type_file.num5   #FUN-CC0024 add
#FUN-740264 end
DEFINE g_renew   LIKE type_file.num5        
MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q200_w AT p_row,p_col WITH FORM "axm/42f/axmq200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL q200_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL q200()
 
   CLOSE WINDOW q200_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN
 
FUNCTION q200()
 
   
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL q200_q()
      END IF
      CALL q200_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "query_ar"   #全部選取
           CALL q200_qry_ar()
         WHEN "view1"
            CALL q200_bp2_1('V')
         WHEN "view2"
            CALL q200_bp2_2('V')
         WHEN "view3"
            CALL q200_bp2_3('V')
         WHEN "view4"
            CALL q200_bp2_4('V')
         WHEN "view5"
            CALL q200_bp2_5('V')
         WHEN "view6"
            CALL q200_bp2_6('V')
         WHEN "view7"
            CALL q200_bp2_7('V')
         WHEN "view8"              #FUN-CC0024 add
            CALL q200_bp2_8('V')   #FUN-CC0024 add
 
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oea1),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q200_p1()
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
             #No.TQC-960118  --Begin
             IF l_ac1 = 0 THEN
                LET l_ac1 = 1
             END IF
             #No.TQC-960118  --End  
             LET g_oea1_t.* = g_oea1[l_ac1].*
 
             IF g_rec_b > 0 THEN
               CALL q200_b_fill_1()  #訂單
               CALL q200_bp2_1('')
               CALL q200_b_fill_2()  #出通單
               CALL q200_bp2_2('')
               CALL q200_b_fill_3()  #出貨單
               CALL q200_bp2_3('')
               CALL q200_b_fill_4()  #應收
               CALL q200_bp2_4('')
               CALL q200_b_fill_5()  #工單
               CALL q200_bp2_5('')
               CALL q200_b_fill_6()  #請購
               CALL q200_bp2_6('')
               CALL q200_b_fill_7()  #採購
               CALL q200_bp2_7('')
               CALL q200_b_fill_8()  #銷退   #FUN-CC0024 add
               CALL q200_bp2_8('')           #FUN-CC0024 add
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
         #FUN-CC0024 -- add start --
         ON ACTION view8
            LET g_renew = 0
            LET g_action_choice="view8"
            EXIT DISPLAY
         #FUN-CC0024 -- add end --
 
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
     
       #TQC-CB0021 ---add---begin
          ON ACTION close 
             LET INT_FLAG=FALSE       
             LET g_action_choice="exit"
             EXIT DISPLAY
       #TQC-CB0021 ---add---end

      END DISPLAY
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q200_q()
 
   LET g_renew = 1
   CALL q200_b_askkey()
END FUNCTION
 
 
FUNCTION q200_b_askkey()
   CLEAR FORM
   CALL g_oea1.clear()
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON oea02,oea01,oea00,oea08,oea03,oea04,oea10,oea23,oea21,
                      oea31,oea32,oea14,oeaconf,oea49
                 FROM s_oea[1].oea02,s_oea[1].oea01,s_oea[1].oea00,
                      s_oea[1].oea08,s_oea[1].oea03,s_oea[1].oea04,
                      s_oea[1].oea10,s_oea[1].oea23,s_oea[1].oea21,
                      s_oea[1].oea31,s_oea[1].oea32,s_oea[1].oea14,
                      s_oea[1].oeaconf,s_oea[1].oea49
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
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
#                   LET g_qryparam.form ="q_oea11" #MOD-830025
                    LET g_qryparam.form ="q_oea11_t" #MOD-830025
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL q200_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_oea1_t.* = g_oea1[l_ac1].*
 
   CALL q200_b_fill_1()
   CALL q200_b_fill_2()
   CALL q200_b_fill_3()
   CALL q200_b_fill_4()
   CALL q200_b_fill_5()
   CALL q200_b_fill_6()
   CALL q200_b_fill_7()
   CALL q200_b_fill_8()   #FUN-CC0024 add
END FUNCTION
 
FUNCTION q200_b1_fill(p_wc2)
DEFINE p_wc2     STRING
DEFINE l_oeb24   LIKE oeb_file.oeb24        #FUN-BA0092
DEFINE l_oeb12   LIKE oeb_file.oeb12        #FUN-BA0092
 
   LET g_sql = "SELECT oea02,oea01,oea00,oea08,oea03,oea032,oea04,'',",
               "       oea10,oea23,oea21,oea31,oea32,oea14,'',oeaconf,oea49", 
               "       ,0",                               #FUN-BA0092
               "  FROM oea_file ",
               " WHERE ",p_wc2 CLIPPED,
               "   AND oea00 IN ('1','2','3','4','6','7')",
               "   AND (oea901 = 'N' OR oea901 IS NULL) ",
               " ORDER BY oea02,oea03"
 
   PREPARE q200_pb1 FROM g_sql
   DECLARE oea_curs CURSOR FOR q200_pb1
  
   CALL g_oea1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oea_curs INTO g_oea1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF
 
#FUN-BA0092 --begin--
      SELECT SUM(oeb12) INTO l_oeb12 FROM oeb_file
       WHERE oeb01 = g_oea1[g_cnt].oea01
      SELECT SUM(oeb24) INTO l_oeb24 FROM oeb_file
       WHERE oeb01 = g_oea1[g_cnt].oea01      
      LET g_oea1[g_cnt].pro_1 = l_oeb24/l_oeb12*100
      IF cl_null(g_oea1[g_cnt].pro_1) THEN 
         LET g_oea1[g_cnt].pro_1 = 0 
      END IF 
#FUN-BA0092 --end--

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
 
 
FUNCTION q200_b_fill_1()
    LET g_sql =
        #FUN-550103 Start , 下面注掉的是原有程序,新程序增加了20個欄位的空白顯示
        "SELECT oeb03,oeb04,'','','','','','','','','','','','','','','','',",
        "       '','','','','',oeb06,ima021,ima1002,ima135,oeb11,",  
        "       oeb71,oeb1001,oeb1012,",
        "       oeb906,oeb092,oeb15,oeb05,oeb12,",  
        "       oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,",
        "       oeb916,oeb917,oeb24,oeb27,oeb28,oeb1004,oeb1002,",  
        "       oeb13,oeb1006,oeb14,oeb14t,oeb09,oeb091,oeb930,'',",
        "       oeb908,oeb22,oeb19,oeb70,ima15,oeb16 ", 
        " FROM oeb_file,OUTER ima_file ",
        " WHERE oeb01 ='",g_oea1_t.oea01,"'",  #單頭
        " AND oeb_file.oeb04=ima_file.ima01 ",
        " AND oeb1003='1' ",
        " ORDER BY oeb03"
 
   PREPARE q200_pb FROM g_sql
   DECLARE oeb_curs CURSOR FOR q200_pb
  
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
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_oeb1[g_cnt].att00,g_oeb1[g_cnt].att01,g_oeb1[g_cnt].att02,
                g_oeb1[g_cnt].att03,g_oeb1[g_cnt].att04,g_oeb1[g_cnt].att05,
                g_oeb1[g_cnt].att06,g_oeb1[g_cnt].att07,g_oeb1[g_cnt].att08,
                g_oeb1[g_cnt].att09,g_oeb1[g_cnt].att10
         FROM imx_file WHERE imx000 = g_oeb1[g_cnt].oeb04
 
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
FUNCTION q200_b_fill_2()
    LET g_sql =
        "SELECT oga01,ogb03,ogb1005,ogb31,ogb32,ogb04,",
        "       '','','','','','','','','',",
        "       '','','','','','','','','','','','',",
        "       ogb06,ima021,ima1002,ima135,ogb11,ogb1001,ogb1012,",  
        "       ogb17,ogb09,'',ogb091,ogb092,ogb1003,ogb19,ogb05,ogb12,",#TQC-CB0022 add '' after ogb09
        "       ogb913,ogb914,",  
        "       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917, ",
        "       0,0,0,ogb65,'','',",  
        "       ogb1004,ogb1002,ogb13,ogb1006,ogb14,ogb14t,",   
        "       ogb930,'',ogb908 ", 
        " FROM ogb_file,oga_file,OUTER ima_file ",
        " WHERE ogb01 = oga01 ",  
        " AND ogb_file.ogb04=ima_file.ima01 ",
        " AND ogb1005 ='1'",   
        "  AND oga09 IN ('1','5') ",
        "  AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY oga01,ogb03"
 
    PREPARE q200_pb2 FROM g_sql
    DECLARE ogb1_cs                       #CURSOR
        CURSOR FOR q200_pb2
 
    CALL g_ogb1.clear()
 
    LET g_cnt = 1
    FOREACH ogb1_cs INTO g_ogb1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改                                                             
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                                                                        
                  imx07,imx08,imx09,imx10 INTO                                                                                      
                  g_ogb1[g_cnt].att00_gb1,g_ogb1[g_cnt].att01_gb1,g_ogb1[g_cnt].att02_gb1,                                                         
                  g_ogb1[g_cnt].att03_gb1,g_ogb1[g_cnt].att04_gb1,g_ogb1[g_cnt].att05_gb1,                                                         
                  g_ogb1[g_cnt].att06_gb1,g_ogb1[g_cnt].att07_gb1,g_ogb1[g_cnt].att08_gb1,                                                         
                  g_ogb1[g_cnt].att09_gb1,g_ogb1[g_cnt].att10_gb1                                                                             
           FROM imx_file WHERE imx000 = g_ogb1[g_cnt].ogb04_gb1                                                                          
                                                                                                                                    
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
        SELECT imd02 INTO g_ogb1[g_cnt].imd02_gb1 FROM imd_file#TQC-CB0022 add
         WHERE imd01 =g_ogb1[g_cnt].ogb09_gb1#TQC-CB0022 add
        LET g_cnt = g_cnt + 1
    END FOREACH
 
   CALL g_ogb1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b2 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
#出貨單
FUNCTION q200_b_fill_3()
    DEFINE l_oga65    LIKE oga_file.oga65
 
 
    LET g_sql =
        "SELECT oga01,ogb03,ogb1005,ogb31,ogb32,ogb04,",
        "       '','','','','','','','','',",
        "       '','','','','','','','','','','','',",
        "       ogb06,ima021,ima1002,ima135,ogb11,ogb1001,ogb1012,",  
        "       ogb17,ogb09,'',ogb091,ogb092,ogb1003,ogb19,ogb05,ogb12,",#TQC-CB0022 add '' after ogb09
        "       ogb913,ogb914,",  
        "       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917, ",
        "       0,0,0,ogb65,'','',",  
        "       ogb1004,ogb1002,ogb13,ogb1006,ogb14,ogb14t,",   
        "       ogb930,'',ogb908 ", 
        " FROM ogb_file,oga_file,OUTER ima_file ",
        " WHERE ogb01 = oga01 ",  
        " AND ogb_file.ogb04=ima_file.ima01 ",
        " AND ogb1005 ='1'",   
        "  AND oga09 IN ('2','3','4','6') ",
        "  AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY oga01,ogb03"
 
    PREPARE q200_pb3 FROM g_sql
    DECLARE ogb2_cs                       #CURSOR
        CURSOR FOR q200_pb3
 
    CALL g_ogb2.clear()
 
    LET g_cnt = 1
    FOREACH ogb2_cs INTO g_ogb2[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        ##如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改                                                             
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                                                                        
                  imx07,imx08,imx09,imx10 INTO                                                                                      
                  g_ogb2[g_cnt].att00_gb2,g_ogb2[g_cnt].att01_gb2,g_ogb2[g_cnt].att02_gb2,                                                         
                  g_ogb2[g_cnt].att03_gb2,g_ogb2[g_cnt].att04_gb2,g_ogb2[g_cnt].att05_gb2,                                                         
                  g_ogb2[g_cnt].att06_gb2,g_ogb2[g_cnt].att07_gb2,g_ogb2[g_cnt].att08_gb2,                                                         
                  g_ogb2[g_cnt].att09_gb2,g_ogb2[g_cnt].att10_gb2                                                                             
           FROM imx_file WHERE imx000 = g_ogb2[g_cnt].ogb04_gb2                                                                          
                                                                                                                                    
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
 
        LET l_oga65 = ''                                         
         SELECT oga65 INTO l_oga65 FROM oga_file 
          WHERE oga01 = g_ogb2[g_cnt].ogb01_gb2
        IF l_oga65='Y' THEN
           SELECT ogb01 INTO g_ogb2[g_cnt].ogb01a_gb2
             FROM ogb_file,oga_file
            WHERE ogb01 =oga01
              AND oga011=g_ogb2[g_cnt].ogb01_gb2
              AND oga09 = '8'
              AND ogb03 = g_ogb2[g_cnt].ogb03_gb2
           SELECT ogb01 INTO g_ogb2[g_cnt].ogb01b_gb2
             FROM ogb_file,oga_file
            WHERE ogb01 =oga01
              AND oga011=g_ogb2[g_cnt].ogb01_gb2
              AND oga09 = '9'
              AND ogb03 = g_ogb2[g_cnt].ogb03_gb2
        END IF
        LET g_ogb2[g_cnt].gem02c_gb2=s_costcenter_desc(g_ogb2[g_cnt].ogb930_gb2) 
        SELECT imd02 INTO g_ogb2[g_cnt].imd02_gb2 FROM imd_file#TQC-CB0022 add
         WHERE imd01 =g_ogb2[g_cnt].ogb09_gb2#TQC-CB0022 add
        LET g_cnt = g_cnt + 1
    END FOREACH
   CALL g_ogb2.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b3 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
#應收
FUNCTION q200_b_fill_4()
    LET g_sql =
        "SELECT omb01,omb03,omb38,omb31,omb32,omb39,omb04,omb06,'',",#TQC-CB0022 add '' after omb06
        "       omb40,omb05,omb12,omb33,omb331,", 
        "       omb13,omb14,omb14t,omb15,omb16,omb16t,",
        "       omb17,omb18,omb18t,omb930,''", 
        " FROM omb_file,oga_file,ogb_file ",
        " WHERE omb01 = oga10 ",  
        "   AND oga01 = ogb01 ",
        "   AND omb31 = ogb01 ",
        "   AND omb32 = ogb03 ",
        "   AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY omb03"
 
    PREPARE q200_pb4 FROM g_sql
    DECLARE omb_curs CURSOR FOR q200_pb4      #SCROLL CURSOR
    CALL g_omb.clear()
    LET g_cnt = 1
    FOREACH omb_curs INTO g_omb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        LET g_omb[g_cnt].gem02c_omb=s_costcenter_desc(g_omb[g_cnt].omb930)
        #TQC-CB0022 add--str
        SELECT ima021 INTO g_omb[g_cnt].ima021_omb FROM ima_file
         WHERE ima01 = g_omb[g_cnt].omb04
       #TQC-CB0022 add--end
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #FUN-CC0024 -- add start --
    LET g_sql =
        "SELECT omb01,omb03,omb38,omb31,omb32,omb39,omb04,omb06,'',",
        "       omb40,omb05,omb12,omb33,omb331,",
        "       omb13,omb14,omb14t,omb15,omb16,omb16t,",
        "       omb17,omb18,omb18t,omb930,''",
        " FROM omb_file,oha_file,ohb_file ",
        " WHERE omb01 = oha10 ",
        "   AND oha01 = ohb01 ",
        "   AND omb31 = ohb01 ",
        "   AND omb32 = ohb03 ",
        "   AND ohb33 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY omb03"
    PREPARE q200_pb41 FROM g_sql
    DECLARE omb_curs1 CURSOR FOR q200_pb41
    FOREACH omb_curs1 INTO g_omb[g_cnt].*
       IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
       END IF
       LET g_omb[g_cnt].gem02c_omb=s_costcenter_desc(g_omb[g_cnt].omb930)
       SELECT ima021 INTO g_omb[g_cnt].ima021_omb FROM ima_file
         WHERE ima01 = g_omb[g_cnt].omb04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    #FUN-CC0024 -- add end --
    CALL g_omb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b4 = g_cnt - 1
    CALL ui.Interface.refresh()
    LET g_cnt = 0
END FUNCTION
 
#工單
FUNCTION q200_b_fill_5()
   LET g_sql = " SELECT sfb01,sfb81,sfb02,sfb221,sfb05,",
               "        '','',sfb08,sfb13,sfb15,sfb25,sfb081,",
               "        sfb09,sfb12,sfb87,sfb04",
               " FROM sfb_file ",
               " WHERE sfb22 = '", g_oea1_t.oea01 CLIPPED, "'"
   PREPARE q200_pb5 FROM g_sql
   DECLARE sfb_curs CURSOR FOR q200_pb5
  
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
FUNCTION q200_b_fill_6()
   LET g_sql="SELECT pml01,pml02,pml24,pml25,pml04,",
             "      '','','','','','','','','','','','','','','','','','','','','', ",  #NO.FUN-670007 add pml24/pml25
             "       pml041,ima021,pml07,pml20,",
             "       pml83,pml84,pml85,pml80,pml81,pml82,pml86,pml87,",
             "       pml21,pml35,pml34,pml33,pml41,",   
             "       pml190,pml191,pml192,",     
             "       pml12,pml121,pml122,pml930,'',pml06,pml38,pml11 ", 
             " FROM pml_file,OUTER ima_file ",
             " WHERE pml_file.pml04=ima_file.ima01",
             "   AND pml24 = '",g_oea1_t.oea01 CLIPPED,"'",
             " ORDER BY pml01,pml02 " 
 
   PREPARE q200_pb6 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE pml_cs CURSOR FOR q200_pb6
 
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
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                    
                imx07,imx08,imx09,imx10 INTO                                  
                g_pml[g_cnt].att00_ml,g_pml[g_cnt].att01_ml,g_pml[g_cnt].att02_ml,     
                g_pml[g_cnt].att03_ml,g_pml[g_cnt].att04_ml,g_pml[g_cnt].att05_ml,     
                g_pml[g_cnt].att06_ml,g_pml[g_cnt].att07_ml,g_pml[g_cnt].att08_ml,     
                g_pml[g_cnt].att09_ml,g_pml[g_cnt].att10_ml                         
         FROM imx_file WHERE imx000 = g_pml[g_cnt].pml04      
 
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
FUNCTION q200_b_fill_7()
 
   LET g_sql ="SELECT pmn01,pmn02,pmn24,pmn25,pmn65,pmn41,pmn42,pmn16,pmn04,",
              "       '','','','','','','','','','','','','','','','','','','','','',",#No.TQC-650108   #MOD-A90128 取消mark
              "       pmn041,ima021,pmn07,pmn20,pmn83,pmn84,pmn85,",
              "       pmn80,pmn81,pmn82,pmn86,pmn87,pmn68,pmn69,pmn31,",
              "       pmn31t,pmn64,pmn63,pmn33,pmn34,pmn122,pmn930,'',",
              "       pmn43,pmn431 ",  
              "      ,pmn38 ,pmn90",   
              #"      ,pmn94,pmn95 ",  #FUN-740046
              " FROM pmn_file,OUTER ima_file ",
              " WHERE pmn_file.pmn04=ima_file.ima01 ",
              #"   AND pmn94 ='", g_oea1_t.oea01 CLIPPED, "'",   #FUN-740046
              "   AND pmn24 ='", g_oea1_t.oea01 CLIPPED, "'",    #FUN-740046
              " ORDER BY pmn01,pmn02"
 
   PREPARE q200_pb7 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE pmn_cs CURSOR FOR q200_pb7
   CALL g_pmn.clear()
   LET g_cnt = 1
   FOREACH pmn_cs INTO g_pmn[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_pmn[g_cnt].att00_mn,g_pmn[g_cnt].att01_mn,g_pmn[g_cnt].att02_mn,
                g_pmn[g_cnt].att03_mn,g_pmn[g_cnt].att04_mn,g_pmn[g_cnt].att05_mn,
                g_pmn[g_cnt].att06_mn,g_pmn[g_cnt].att07_mn,g_pmn[g_cnt].att08_mn,
                g_pmn[g_cnt].att09_mn,g_pmn[g_cnt].att10_mn
           FROM imx_file WHERE imx000 = g_pmn[g_cnt].pmn04
 
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
 
#FUN-CC0024 -- add start --
FUNCTION q200_b_fill_8()

   IF g_aza.aza50='Y' THEN
      LET g_sql =
          "SELECT ohb01,ohb03,ohb30,ohb31,ohb32,ohb33,ohb34,ohb69,ohb70,ohb50,ohb40,ohb1004,ohb04,'','','','','','','','','','','','','','','','','','','','','',",    
          " ohb06,ima021,ima1002,ima135,ohb11,ohb09,'',ohb091,ohb092,ohb61,ohb05,ohb12,",
          " ohb913,ohb914,ohb915,ohb910,ohb911,ohb912,ohb916,ohb917,ohb1002,ohb1001,",
          " ohb37,ohb13,ohb1003,ohb14,ohb14t,",  
          " ohb51,ohb930,'',  ",  
          " ohbud01,ohbud02,ohbud03,ohbud04,ohbud05,",
          " ohbud06,ohbud07,ohbud08,ohbud09,ohbud10,",
          " ohbud11,ohbud12,ohbud13,ohbud14,ohbud15,",
          " ohb64,ohb65,ohb66,ohb67,ohb68 ",        
          " ,'',''",  
          " FROM ohb_file LEFT OUTER JOIN ima_file ON ohb04 = ima01",  
          " WHERE ohb33 = '",g_oea1_t.oea01 CLIPPED,"' ",
          " AND (ohb1005='1' OR ohb1005 IS NULL) ",
          " ORDER BY ohb03"
   ELSE
      LET g_sql =
          "SELECT ohb01,ohb03,ohb30,ohb31,ohb32,ohb33,ohb34,ohb69,ohb70,ohb50,ohb40,'',ohb04,'','','','','','','','','','','','','','','','','','','','','',",    
          " ohb06,ima021,ima1002,ima135,ohb11,ohb09,'',ohb091,ohb092,ohb61,ohb05,ohb12,",
          " ohb913,ohb914,ohb915,ohb910,ohb911,ohb912,ohb916,ohb917,'','',",
          " ohb37,ohb13,'',ohb14,ohb14t,",  
          " ohb51,ohb930,'',  ",  
          " ohbud01,ohbud02,ohbud03,ohbud04,ohbud05,",
          " ohbud06,ohbud07,ohbud08,ohbud09,ohbud10,",
          " ohbud11,ohbud12,ohbud13,ohbud14,ohbud15,",
          " ohb64,ohb65,ohb66,ohb67,ohb68 ",  
          " ,'',''",  
          " FROM ohb_file LEFT OUTER JOIN ima_file ON ohb04 = ima01 ",  
          " WHERE ohb33 = '",g_oea1_t.oea01 CLIPPED,"' ",
          " ORDER BY ohb03"
   END IF
   PREPARE q200_pb8 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE ohb_cs CURSOR FOR q200_pb8
   CALL g_ohb1.clear()
   LET g_cnt = 1
   FOREACH ohb_cs INTO g_ohb[g_cnt].ohb01,g_ohb1[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10
           INTO g_ohb1[g_cnt].att00_ohb,g_ohb1[g_cnt].att01_ohb,g_ohb1[g_cnt].att02_ohb,
                g_ohb1[g_cnt].att03_ohb,g_ohb1[g_cnt].att04_ohb,g_ohb1[g_cnt].att05_ohb,
                g_ohb1[g_cnt].att06_ohb,g_ohb1[g_cnt].att07_ohb,g_ohb1[g_cnt].att08_ohb,
                g_ohb1[g_cnt].att09_ohb,g_ohb1[g_cnt].att10_ohb
           FROM imx_file WHERE imx000 = g_ohb1[g_cnt].ohb04
         LET g_ohb1[g_cnt].att01_c_ohb = g_ohb1[g_cnt].att01_ohb  
         LET g_ohb1[g_cnt].att02_c_ohb = g_ohb1[g_cnt].att02_ohb
         LET g_ohb1[g_cnt].att03_c_ohb = g_ohb1[g_cnt].att03_ohb
         LET g_ohb1[g_cnt].att04_c_ohb = g_ohb1[g_cnt].att04_ohb
         LET g_ohb1[g_cnt].att05_c_ohb = g_ohb1[g_cnt].att05_ohb
         LET g_ohb1[g_cnt].att06_c_ohb = g_ohb1[g_cnt].att06_ohb
         LET g_ohb1[g_cnt].att07_c_ohb = g_ohb1[g_cnt].att07_ohb
         LET g_ohb1[g_cnt].att08_c_ohb = g_ohb1[g_cnt].att08_ohb
         LET g_ohb1[g_cnt].att09_c_ohb = g_ohb1[g_cnt].att09_ohb
         LET g_ohb1[g_cnt].att10_c_ohb = g_ohb1[g_cnt].att10_ohb
      END IF
      LET g_ohb1[g_cnt].gem02c_ohb=s_costcenter_desc(g_ohb1[g_cnt].ohb930) #FUN-670063
      IF cl_null(g_ohb1[g_cnt].ohb910) THEN
         LET g_ohb1[g_cnt].ohb911 = NULL
         LET g_ohb1[g_cnt].ohb912 = NULL
      END IF
      IF cl_null(g_ohb1[g_cnt].ohb913) THEN
         LET g_ohb1[g_cnt].ohb914 = NULL
         LET g_ohb1[g_cnt].ohb915 = NULL
      END IF
      SELECT imd02 INTO g_ohb1[g_cnt].imd02_ohb FROM imd_file
         WHERE imd01 =g_ohb1[g_cnt].ohb09
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ohb1.deleteElement(g_cnt)  
   MESSAGE ""
   LET g_rec_b8=g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
#FUN-CC0024 -- add end --
 
#訂單
FUNCTION q200_bp2_1(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_action LIKE type_file.chr10   #FUN-740264
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
      #FUN-CC0024 -- add start --
      ON ACTION view8
        LET l_action = 'view8'
        EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
      #FUN-CC0024 -- add start --
      ON ACTION return8
         EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
   CALL q200_b_act(l_action)  #FUN-740264
END FUNCTION
 
#出通
FUNCTION q200_bp2_2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_action LIKE type_file.chr10   #FUN-740264
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
      #FUN-CC0024 -- add start --
      ON ACTION view8
        LET l_action = 'view8'
        EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
      #FUN-CC0024 -- add start --
      ON ACTION return8
         EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
   CALL q200_b_act(l_action)  #FUN-740264
END FUNCTION
 
 
#出貨
FUNCTION q200_bp2_3(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_action LIKE type_file.chr10   #FUN-740264
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb2 TO s_ogb2.* ATTRIBUTE(COUNT=g_rec_b3)
      BEFORE ROW
         LET l_ac_b3 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
    #FUN-740264 BEGIN
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
      #FUN-CC0024 -- add start --
      ON ACTION view8
        LET l_action = 'view8'
        EXIT DISPLAY
      #FUN-CC0024 -- add end --
      ON ACTION dn_detail
        LET l_action = 'dn'
        EXIT DISPLAY
    #FUN-740264 END
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
      #FUN-CC0024 -- add start --
      ON ACTION return8
         EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
   CALL q200_b_act(l_action)  #FUN-740264
END FUNCTION
 
#應收
FUNCTION q200_bp2_4(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_action LIKE type_file.chr10   #FUN-740264
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b4)
      BEFORE ROW
         LET l_ac_b4 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
    #FUN-740264  BEGIN
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
      #FUN-CC0024 -- add start --
      ON ACTION view8
        LET l_action = 'view8'
        EXIT DISPLAY
      #FUN-CC0024 -- add end --
      ON ACTION ar_detail
        LET l_action = 'ar'
        EXIT DISPLAY
    #FUN-740264 END
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
      #FUN-CC0024 -- add start --
      ON ACTION return8
         EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
   CALL q200_b_act(l_action)  #FUN-740264
END FUNCTION
 
#工單
FUNCTION q200_bp2_5(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_action LIKE type_file.chr10   #FUN-740264
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b5)
      BEFORE ROW
         LET l_ac_b5 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
    #FUN-740264 BEGIN
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
      #FUN-CC0024 -- add start --
      ON ACTION view8
        LET l_action = 'view8'
        EXIT DISPLAY
      #FUN-CC0024 -- add end --
      ON ACTION wo_detail
        LET l_action = 'wo'
        EXIT DISPLAY
    #FUN-740264 END
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
      #FUN-CC0024 -- add start --
      ON ACTION return8
         EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
   CALL q200_b_act(l_action)  #FUN-740264
END FUNCTION
 
#請購
FUNCTION q200_bp2_6(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_action LIKE type_file.chr10   #FUN-740264
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b6)
      BEFORE ROW
         LET l_ac_b6 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
    #FUN-740264  BEGIN
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
      #FUN-CC0024 -- add start --
      ON ACTION view8
        LET l_action = 'view8'
        EXIT DISPLAY
      #FUN-CC0024 -- add end --
      ON ACTION pr_detail
        LET l_action = 'pr'
        EXIT DISPLAY
    #FUN-740264  END
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
      #FUN-CC0024 -- add start --
      ON ACTION return8
         EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
   CALL q200_b_act(l_action)  #FUN-740264
END FUNCTION
 
 
FUNCTION q200_bp2_7(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_action LIKE type_file.chr10   #FUN-740264
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b7)
      BEFORE ROW
         LET l_ac_b7 = ARR_CURR()
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
    #FUN-740264 BEGIN
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
      #FUN-CC0024 -- add start --
      ON ACTION view8
        LET l_action = 'view8'
        EXIT DISPLAY
      #FUN-CC0024 -- add end --
      ON ACTION po_detail
        LET l_action = 'po'
        EXIT DISPLAY
    #FUN-740264 END
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
      #FUN-CC0024 -- add start --
      ON ACTION return8
         EXIT DISPLAY
      #FUN-CC0024 -- add end --
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
   CALL q200_b_act(l_action)  #FUN-740264
END FUNCTION
#FUN-CC0024 -- add start --
FUNCTION q200_bp2_8(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   DEFINE l_action LIKE type_file.chr10   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ohb1 TO s_ohb1.* ATTRIBUTE(COUNT=g_rec_b8)
      BEFORE ROW
         LET l_ac_b8 = ARR_CURR()
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
        LET l_action = 'view7'
        EXIT DISPLAY
      ON ACTION view8
        LET l_action = ''
      ON ACTION srn_detail
        LET l_action = 'srn'
        EXIT DISPLAY

      ON ACTION return8
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
   CALL q200_b_act(l_action) 
END FUNCTION
#FUN-CC0024 -- add end --
 
FUNCTION q200_b_act(l_act)
  DEFINE l_act    LIKE  type_file.chr10
  CASE l_act
    WHEN "view1"
      CALL q200_bp2_1('V')
    WHEN "view2"
      CALL q200_bp2_2('V')
    WHEN "view3"
      CALL q200_bp2_3('V')
    WHEN "view4"
      CALL q200_bp2_4('V')
    WHEN "view5"
      CALL q200_bp2_5('V')
    WHEN "view6"
      CALL q200_bp2_6('V')
    WHEN "view7"
      CALL q200_bp2_7('V')
    WHEN "view8"             #FUN-CC0024 add
      CALL q200_bp2_8('V')   #FUN-CC0024 add
    WHEN "so"  #訂單
      LET g_msg = " axmt410 '",g_oea1_t.oea01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    WHEN "da"  #出通
      #No.TQC-960118  --Begin
      IF l_ac_b2 = 0 THEN RETURN END IF
      #No.TQC-960118  --End  
      LET g_msg = " axmt610 '",g_ogb1[l_ac_b2].ogb01_gb1 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    WHEN "dn"  #出貨
      #No.TQC-960118  --Begin
      IF l_ac_b3 = 0 THEN RETURN END IF
      #No.TQC-960118  --End  
      LET g_msg = " axmt620 '",g_ogb2[l_ac_b3].ogb01_gb2 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    WHEN "ar"  #應收
      #No.TQC-960118  --Begin
      IF l_ac_b4 = 0 THEN RETURN END IF
      #No.TQC-960118  --End  
      LET g_msg = " axrt300 '",g_omb[l_ac_b4].omb01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    WHEN "wo"  #工單
      #No.TQC-960118  --Begin
      IF l_ac_b5 = 0 THEN RETURN END IF
      #No.TQC-960118  --End  
      LET g_msg = " asfi301 '",g_sfb[l_ac_b5].sfb01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    WHEN "pr"  #請購
      #No.TQC-960118  --Begin
      IF l_ac_b6 = 0 THEN RETURN END IF
      #No.TQC-960118  --End  
      LET g_msg = " apmt420 '",g_pml[l_ac_b6].pml01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    WHEN "po"  #採購
      #No.TQC-960118  --Begin
      IF l_ac_b7 = 0 THEN RETURN END IF
      #No.TQC-960118  --End  
      LET g_msg = " apmt540 '",g_pmn[l_ac_b7].pmn01 CLIPPED,"'"
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    #FUN-CC0024 -- add start--
    WHEN "srn"  #銷退
      IF l_ac_b8 = 0 THEN RETURN END IF
      CASE g_sma.sma124
         WHEN 'std'
            LET g_msg = " axmt700 '",g_ohb[l_ac_b8].ohb01 CLIPPED,"'"
         WHEN 'icd'
            LET g_msg = " axmt700_icd '",g_ohb[l_ac_b8].ohb01 CLIPPED,"'"
         WHEN 'slk'
            LET g_msg = " axmt700_slk '",g_ohb[l_ac_b8].ohb01 CLIPPED,"'"
      END CASE 
      CALL cl_cmdrun_wait(g_msg CLIPPED)
    #FUN-CC0024 -- add end --
  END CASE
END FUNCTION 
 
FUNCTION q200_refresh_detail()
  DEFINE l_compare          LIKE oay_file.oay22    
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-680137 SMALLINT
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
     #FUN-CC0024 -- add start --
     SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01 = g_prog AND gae02 = 'ohb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00_ohb",l_gae04)
     #FUN-CC0024 -- add end --
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'oeb04,oeb06'
        LET ls_show = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn,att00_ohb'                           #FUN-CC0024 add ,att00_ohb
     ELSE
        LET ls_hide = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn,att00_ohb'                           #FUN-CC0024 add ,att00_ohb
        LET ls_show = 'oeb04,oeb06,ogb04_gb1,ogb04_gb2,ogb06_gb1,ogb06_gb2,pml041,pmn041,ohb04,ohb06'   #FUN-CC0024 add ,ohb04,ohb06
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
             #FUN-CC0024 -- add start --
             LET ls_show = ls_show || ",att" || lc_index || "_ohb"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_ohb"
             #FUN-CC0024 -- add end --
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_gb1",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_gb2",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_ml",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_mn",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_ohb",lr_agc[li_i].agc02)   #FUN-CC0024 add
             
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
             #FUN-CC0024 -- add start --
             LET ls_show = ls_show || ",att" || lc_index || "_c_ohb"
             LET ls_hide = ls_hide || ",att" || lc_index || "_ohb"
             #FUN-CC0024 -- add end --
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_gb1",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_gb2",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_ml",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_mn",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_c_ohb",lr_agc[li_i].agc02)  #FUN-CC0024 add
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
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_ohb",ls_combo_vals,ls_combo_txts)   #FUN-CC0024 add
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
             #FUN-CC0024 -- add start --
             LET ls_show = ls_show || ",att" || lc_index || "_ohb"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_ohb"
             #FUN-CC0024 -- add end --
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
    LET ls_hide = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn,att00_ohb'   #FUN-CC0024 add ,att00_ohb
    LET ls_show = 'oeb04,ogb04_gb1,ogb04_gb2,pml041,pmn041,ohb04'           #FUN-CC0024 add ,ohb04
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
      LET ls_hide = ls_hide || ",att" || lc_index || "_ohb" || ",att" || lc_index || "_c_ohb"   #FUN-CC0024 add
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
 
 
FUNCTION q200_init()
   IF g_sma.sma120 = 'Y'  THEN                                                                                                      
      LET lg_oay22 = ''                                                                                                             
      LET lg_group = ''                                                                                                             
      CALL q200_refresh_detail()                                                                                                    
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
 
   #-----CHI-8C0026---------
   #IF g_aza.aza50 = 'N'THEN
   #    CALL cl_set_comp_visible("oeb11,oeb1012,oeb1004,oeb1002,
   #                              oeb1006,oeb09,oeb091",FALSE)
   #END IF
   #IF g_aza.aza50='Y' THEN
   #    CALL cl_set_comp_visible("ima1002,ima135,oeb11,oeb1012,oeb1004,oeb1002,
   #                              oeb1006,oeb09,oeb091",TRUE)
   #ELSE
   #    CALL cl_set_comp_visible("ima1002,ima135,oeb11,oeb1012,oeb1004,oeb1002,
   #                              oeb1006,oeb09,oeb091",FALSE)
   #END IF
   #
   # CALL cl_set_comp_visible("oeb911,oeb914",FALSE)
   # IF g_sma.sma115 ='N' THEN
   #    CALL cl_set_comp_visible("oeb913,oeb914,oeb915",FALSE)
   #    CALL cl_set_comp_visible("oeb910,oeb911,oeb912",FALSE)
   # ELSE
   #    CALL cl_set_comp_visible("oeb05,oeb12",FALSE)
   # END IF
   # IF g_sma.sma116 MATCHES '[01]' THEN  
   #    CALL cl_set_comp_visible("oeb916,oeb917",FALSE)
   # END IF
   # 
   # 
   #CALL cl_set_comp_visible("oeb930,gem02c",g_aaz.aaz90='Y')  #FUN-670063
   #
   ##出通/出貨
   #CALL cl_set_comp_visible("ogb12b_gb1,ogb65_gb1,ogb915b_gb1,ogb912b_gb1",FALSE)
   #CALL cl_set_comp_visible("ogb01a_gb1,ogb01b_gb1",FALSE) 
   #CALL cl_set_comp_visible("oga01b_gb1",FALSE) #只有一般出貨單才顯示
   #CALL cl_set_comp_visible("ogb12b_gb2,ogb65_gb2,ogb915b_gb2,ogb912b_gb2",FALSE)
   #CALL cl_set_comp_visible("ogb01a_gb2,ogb01b_gb2",FALSE) 
   #CALL cl_set_comp_visible("oga01b_gb2",FALSE) #只有一般出貨單才顯示
   #
   #CALL cl_set_comp_visible("ogb911_gb1,ogb914_gb1",FALSE)
   #CALL cl_set_comp_visible("ogb1005_gb1,b2_1005_gb1",FALSE)
   #CALL cl_set_comp_visible("ogb911_gb2,ogb914_gb2",FALSE)
   #CALL cl_set_comp_visible("ogb1005_gb2,b2_1005_gb2",FALSE)
   #
   #CALL cl_set_comp_visible("ogb1005_gb1,ogb1007_gb1,tqw16_gb1,ogb1008_gb1,ogb1009_gb1,ogb1010_gb1,ogb1011_gb1",FALSE)
   #
   #CALL cl_set_comp_visible("ogb930_gb1,gem02c_gb1",g_aaz.aaz90='Y') 
   #CALL cl_set_comp_visible("ogb930_gb2,gem02c_gb2",g_aaz.aaz90='Y') 
   #CALL cl_set_comp_visible("ogb911_gb1,ogb914_gb1",FALSE)
   #CALL cl_set_comp_visible("ogb911_gb2,ogb914_gb2",FALSE)
   #
   #IF (g_aza.aza50='N') THEN
   #      CALL cl_set_comp_visible("ogb11_gb1,ogb13_gb1,ogb14_gb1,ogb14t_gb1,ogb1002_gb1,ogb1003_gb1,ogb1004_gb1,ogb1005_gb1,ogb1006_gb1,ogb1012_gb1,ima1002_gb1,ima135_gb1",FALSE)   
   #      CALL cl_set_comp_visible("ogb11_gb2,ogb13_gb2,ogb14_gb2,ogb14t_gb2,ogb1002_gb2,ogb1003_gb2,ogb1004_gb2,ogb1005_gb2,ogb1006_gb2,ogb1012_gb2,ima1002_gb2,ima135_gb2",FALSE)   
   #      CALL cl_set_comp_visible("oga1001,oga1002,oga1003,oga1005,oga1006,oga1007,oga1008,oga1009,oga1010,oga1011,oga1013,oga1015",FALSE)
   #END IF
   #
   #CALL cl_set_comp_visible("ogb1005_gb1,ogb1007_gb1,ogb1008_gb1,ogb1009_gb1,ogb1010_gb1,ogb1011_gb1",FALSE)
   #
   #CALL cl_set_comp_visible("ogb930_gb1,gem02c_gb1",g_aaz.aaz90='Y') #FUN-670063
   #CALL cl_set_comp_visible("ogb930_gb2,gem02c_gb2",g_aaz.aaz90='Y') #FUN-670063
   #
   #IF g_sma.sma115 ='N' THEN
   #   CALL cl_set_comp_visible("ogb913_gb1,ogb914_gb1,ogb915_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb910_gb1,ogb911_gb1,ogb912_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb913_gb2,ogb914_gb2,ogb915_gb2",FALSE)
   #   CALL cl_set_comp_visible("ogb910_gb2,ogb911_gb2,ogb912_gb2",FALSE)
   #ELSE
   #   CALL cl_set_comp_visible("ogb05_gb1,ogb12_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb05_gb2,ogb12_gb2",FALSE)
   #END IF
   #
   #IF g_sma.sma116 MATCHES '[01]' THEN    
   #   CALL cl_set_comp_visible("ogb916_gb1,ogb917_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb916_gb2,ogb917_gb2",FALSE)
   #END IF
   #
   #
   #IF g_sma.sma115 ='N' THEN
   #   CALL cl_set_comp_visible("ogb913_gb1,ogb914_gb1,ogb915_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb910_gb1,ogb911_gb1,ogb912_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb913_gb2,ogb914_gb2,ogb915_gb2",FALSE)
   #   CALL cl_set_comp_visible("ogb910_gb2,ogb911_gb2,ogb912_gb2",FALSE)
   #ELSE
   #   CALL cl_set_comp_visible("ogb05_gb1,ogb12_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb05_gb2,ogb12_gb2",FALSE)
   #END IF
   #
   #IF g_sma.sma116 MATCHES '[01]' THEN   
   #   CALL cl_set_comp_visible("ogb916_gb1,ogb917_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb916_gb2,ogb917_gb2",FALSE)
   #END IF
   #
   #
   #CALL cl_set_comp_visible("ogb12b_gb1,ogb65_gb1,ogb915b_gb1,ogb912b_gb1",FALSE)
   #CALL cl_set_comp_visible("ogb12b_gb2,ogb65_gb2,ogb915b_gb2,ogb912b_gb2",FALSE)
   #CALL cl_set_comp_visible("ogb01a_gb1,ogb01b_gb1",FALSE) 
   #CALL cl_set_comp_visible("ogb01a_gb2,ogb01b_gb2",FALSE) 
   #
   #CALL cl_set_comp_visible("ogb911_gb1,ogb914_gb1",FALSE)
   #CALL cl_set_comp_visible("ogb911_gb2,ogb914_gb2",FALSE)
   #
   #CALL cl_set_comp_visible("ogb1005_gb1,ogb1007_gb1,ogb1008_gb1,ogb1009_gb1,ogb1010_gb1,ogb1011_gb1",FALSE)
   #CALL cl_set_comp_visible("ogb1005_gb2,ogb1007_gb2,ogb1008_gb2,ogb1009_gb2,ogb1010_gb2,ogb1011_gb2",TRUE)
   #
   #CALL cl_set_comp_visible("ogb930_gb1,gem02c_gb1",g_aaz.aaz90='Y') 
   #CALL cl_set_comp_visible("ogb930_gb2,gem02c_gb2",g_aaz.aaz90='Y') 
   #
   #
   #IF g_sma.sma115 ='N' THEN
   #   CALL cl_set_comp_visible("ogb913_gb1,ogb914_gb1,ogb915_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb913_gb2,ogb914_gb2,ogb915_gb2",FALSE)
   #   CALL cl_set_comp_visible("ogb910_gb1,ogb911_gb1,ogb912_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb910_gb2,ogb911_gb2,ogb912_gb2",FALSE)
   #ELSE
   #   CALL cl_set_comp_visible("ogb05_gb1,ogb12_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb05_gb2,ogb12_gb2",FALSE)
   #END IF
   #
   #IF g_sma.sma116 MATCHES '[01]' THEN   
   #   CALL cl_set_comp_visible("ogb916_gb1,ogb917_gb1",FALSE)
   #   CALL cl_set_comp_visible("ogb916_gb2,ogb917_gb2",FALSE)
   #END IF
   #
   #CALL cl_getmsg('axm-370',g_lang) RETURNING g_msg
   #CALL cl_set_comp_att_text("oga01_gb1",g_msg CLIPPED)
   #CALL cl_getmsg('axm-371',g_lang) RETURNING g_msg
   #CALL cl_set_comp_att_text("oga02_gb1",g_msg CLIPPED)
   #CALL cl_getmsg('axm-372',g_lang) RETURNING g_msg
   #CALL cl_set_comp_att_text("oga011_gb1",g_msg CLIPPED)
 
   IF g_aza.aza50='Y' THEN
       CALL cl_chg_comp_att("ima1002_oeb,ima135_oeb,oeb11,oeb1012,oeb1004,oeb1002,   
                                 oeb1006,oeb09,oeb091","HIDDEN","0")
   ELSE
       CALL cl_chg_comp_att("ima1002_oeb,ima135_oeb,oeb11,oeb1012,oeb1004,oeb1002,   
                                 oeb1006,oeb09,oeb091","HIDDEN","1")
   END IF
 
    CALL cl_chg_comp_att("oeb911,oeb914","HIDDEN","1")
    IF g_sma.sma115 ='N' THEN
       CALL cl_chg_comp_att("oeb913,oeb915","HIDDEN","1")   
       CALL cl_chg_comp_att("oeb910,oeb912","HIDDEN","1")   
    ELSE
       CALL cl_chg_comp_att("oeb05,oeb12","HIDDEN","1")
    END IF
    IF g_sma.sma116 MATCHES '[01]' THEN  
       CALL cl_chg_comp_att("oeb916,oeb917","HIDDEN","1")
    END IF
    
    
    CALL cl_chg_comp_att("oeb930,gem02c","HIDDEN",g_aaz.aaz90!='Y')  #FUN-670063
 
#出通/出貨
   CALL cl_chg_comp_att("ogb12b_gb1,ogb65_gb1,ogb915b_gb1,ogb912b_gb1","HIDDEN","1")
   CALL cl_chg_comp_att("ogb01a_gb1,ogb01b_gb1","HIDDEN","1") 
   CALL cl_chg_comp_att("ogb12b_gb2,ogb65_gb2,ogb915b_gb2,ogb912b_gb2","HIDDEN","1")
   CALL cl_chg_comp_att("ogb01a_gb2,ogb01b_gb2","HIDDEN","1") 
 
   CALL cl_chg_comp_att("ogb911_gb1,ogb914_gb1","HIDDEN","1")
   CALL cl_chg_comp_att("ogb1005_gb1","HIDDEN","1")   
   CALL cl_chg_comp_att("ogb911_gb2,ogb914_gb2","HIDDEN","1")
   CALL cl_chg_comp_att("ogb1005_gb2","HIDDEN","1")   
 
   CALL cl_chg_comp_att("ogb1005_gb1","HIDDEN","1")   
 
   CALL cl_chg_comp_att("ogb930_gb1,gem02c_gb1","HIDDEN",g_aaz.aaz90!='Y') 
   CALL cl_chg_comp_att("ogb930_gb2,gem02c_gb2","HIDDEN",g_aaz.aaz90!='Y') 
 
   IF (g_aza.aza50='N') THEN
      CALL cl_chg_comp_att("ogb11_gb1,ogb13_gb1,ogb14_gb1,ogb14t_gb1,ogb1002_gb1,ogb1003_gb1,ogb1004_gb1,ogb1005_gb1,ogb1006_gb1,ogb1012_gb1,ima1002_gb1,ima135_gb1","HIDDEN","1")   
      CALL cl_chg_comp_att("ogb11_gb2,ogb13_gb2,ogb14_gb2,ogb14t_gb2,ogb1002_gb2,ogb1003_gb2,ogb1004_gb2,ogb1005_gb2,ogb1006_gb2,ogb1012_gb2,ima1002_gb2,ima135_gb2","HIDDEN","1")   
   END IF
 
   CALL cl_chg_comp_att("ogb1005_gb1","HIDDEN","1")   
 
 
   CALL cl_chg_comp_att("ogb914_gb1,ogb911_gb1,ogb914_gb2,ogb911_gb2","HIDDEN","1")   
   IF g_sma.sma115 ='N' THEN
      CALL cl_chg_comp_att("ogb913_gb1,ogb915_gb1","HIDDEN","1")
      CALL cl_chg_comp_att("ogb910_gb1,ogb912_gb1","HIDDEN","1")
      CALL cl_chg_comp_att("ogb913_gb2,ogb915_gb2","HIDDEN","1")
      CALL cl_chg_comp_att("ogb910_gb2,ogb912_gb2","HIDDEN","1")
   ELSE
      CALL cl_chg_comp_att("ogb05_gb1,ogb12_gb1","HIDDEN","1")
      CALL cl_chg_comp_att("ogb05_gb2,ogb12_gb2","HIDDEN","1")
   END IF
 
   IF g_sma.sma116 MATCHES '[01]' THEN    
      CALL cl_chg_comp_att("ogb916_gb1,ogb917_gb1","HIDDEN","1")
      CALL cl_chg_comp_att("ogb916_gb2,ogb917_gb2","HIDDEN","1")
   END IF
   #-----END CHI-8C0026-----
 
   IF g_oaz.oaz23 = 'Y' THEN
      CALL cl_getmsg('axm-042',g_lang) RETURNING g_msg 
      CALL cl_set_comp_att_text("ogb17_gb1",g_msg CLIPPED)   
      CALL cl_set_comp_att_text("ogb17_gb2",g_msg CLIPPED)   
   END IF
#FUN-CC0024 -- add start --
#銷退 
   IF g_aza.aza50='Y' THEN
      CALL cl_chg_comp_att("ohb1004,ima1002_ohb,ima135_ohb,ohb11,ohb1002,ohb1001,ohb1003,  
                                ohb37,ohb13,ohb14,ohb14t","HIDDEN","0")  
   ELSE
      CALL cl_chg_comp_att("ohb1004,ima1002_ohb,ima135_ohb,ohb11,ohb1002,ohb1001,ohb1003,
                                ohb37,ohb13,ohb14,ohb14t","HIDDEN","1")
   END IF
   CALL cl_chg_comp_att("ohb1001","HIDDEN",g_azw.azw04='2')  
   CALL cl_chg_comp_att("ohb911,ohb914","HIDDEN","1") 
   IF g_sma.sma115 ='N' THEN
      CALL cl_chg_comp_att("ohb913,ohb914,ohb915","HIDDEN","1")  
      CALL cl_chg_comp_att("ohb910,ohb911,ohb912","HIDDEN","1")  
   ELSE
      CALL cl_chg_comp_att("b1_ohb05,b1_ohb12","HIDDEN","1")  
   END IF
   IF g_sma.sma116 MATCHES '[01]' THEN  
      CALL cl_chg_comp_att("ohb916,ohb917","HIDDEN","1")  
   END IF
   
   IF g_azw.azw04 = '2' THEN
      CALL cl_chg_comp_att("ohb69,ohb70,oha57","HIDDEN","0")
   ELSE
      CALL cl_chg_comp_att("ohb69,ohb70,oha57","HIDDEN","1")
   END IF
   CALL cl_chg_comp_att("ohb40","HIDDEN",g_azw.azw04!='2')
   CALL cl_chg_comp_att("ohb64,ohb65,ohb66,ohb67,ohb68,ohb1001","HIDDEN",g_azw.azw04!='2')
   CALL cl_chg_comp_att("ohb930,gem02c_ohb","HIDDEN",g_aaz.aaz90!='Y')
#FUN-CC0024 -- add end --
  ############
 
    #初始化界面的樣式(沒有任何默認屬性組)
    LET lg_oay22 = ''
    LET lg_group = ''
    CALL q200_refresh_detail()
END FUNCTION
 
 
 
FUNCTION q200_qry_ar()
   LET g_msg = " axrq320 '",g_oea1_t.oea03 CLIPPED,"'"
   CALL cl_cmdrun_wait(g_msg CLIPPED)
END FUNCTION
 
#TQC-730022
#CHI-7B0023/CHI-7B0039
