# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: askt004.4gl
# Descriptions...: 成品碼尺寸表維護作業 
# Date & Author..: 08/08/12 By ve007 No.FUN-870117 FUN-8A0151 FUN-8B0009
# Modify.........: No.MOD-910137 09/01/13 By chenyu 新增的時候沒有插入slg_file
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-920156 09/02/20 By dxfwo askt004仍  用固定長度 array ，更改為標准做法
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao 新增料號管控
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_value      DYNAMIC ARRAY OF RECORD           # FUN-920156 
                    fname    LIKE type_file.chr5,      
                    visible  LIKE type_file.chr1,      
                    nvalue   LIKE type_file.chr20,      
                    value    DYNAMIC ARRAY OF STRING   
                    END RECORD,
       g_num        DYNAMIC ARRAY OF STRING
 
DEFINE 
    g_slc           RECORD LIKE slc_file.*,       
    g_slc_t         RECORD LIKE slc_file.*,  
    g_slc_o         RECORD LIKE slc_file.*, 
    g_slc01_t       LIKE slc_file.slc01,  
    g_k                 DYNAMIC ARRAY OF RECORD
              s01       LIKE type_file.num20_6,
              s02       LIKE type_file.num20_6,
              s03       LIKE type_file.num20_6,
              s04       LIKE type_file.num20_6,
              s05       LIKE type_file.num20_6,
              s06       LIKE type_file.num20_6,
              s07       LIKE type_file.num20_6,
              s08       LIKE type_file.num20_6,
              s09       LIKE type_file.num20_6,
              s10       LIKE type_file.num20_6,
              s11       LIKE type_file.num20_6,
              s12       LIKE type_file.num20_6,
              s13       LIKE type_file.num20_6,
              s14       LIKE type_file.num20_6,
              s15       LIKE type_file.num20_6,
              s16       LIKE type_file.num20_6,
              s17       LIKE type_file.num20_6,
              s18       LIKE type_file.num20_6,
              s19       LIKE type_file.num20_6,
              s20       LIKE type_file.num20_6
                        END RECORD,      
    g_sld           DYNAMIC ARRAY OF RECORD    #(Program Variables)
        sld03      LIKE sld_file.sld03,
        sld05      LIKE sld_file.sld05, 
        bol02      LIKE bol_file.bol02,
        sld06      LIKE sld_file.sld06,
        slb02      LIKE slb_file.slb02,
        sld04      LIKE sld_file.sld04,
        sld07      LIKE sld_file.sld07,
               k01      LIKE type_file.chr10,
               k02      LIKE type_file.chr10, 
               k03      LIKE type_file.chr10,
               k04      LIKE type_file.chr10, 
               k05      LIKE type_file.chr10,
               k06      LIKE type_file.chr10,
               k07      LIKE type_file.chr10,
               k08      LIKE type_file.chr10,
               k09      LIKE type_file.chr10,
               k10      LIKE type_file.chr10,
               k11      LIKE type_file.chr10,
               k12      LIKE type_file.chr10,
               k13      LIKE type_file.chr10,
               k14      LIKE type_file.chr10,
               k15      LIKE type_file.chr10,
               k16      LIKE type_file.chr10,
               k17      LIKE type_file.chr10,
               k18      LIKE type_file.chr10,
               k19      LIKE type_file.chr10,
               k20      LIKE type_file.chr10,
        sld10      LIKE sld_file.sld10,
        sld11      LIKE sld_file.sld11 
                    END RECORD,
    g_sld_t         RECORD                
        sld03      LIKE sld_file.sld03,
        sld05      LIKE sld_file.sld05,
        bol02      LIKE bol_file.bol02,
        sld06      LIKE sld_file.sld06,
        slb02      LIKE slb_file.slb02,
        sld04      LIKE sld_file.sld04,
        sld07      LIKE sld_file.sld07,
               k01      LIKE type_file.chr10, 
               k02      LIKE type_file.chr10,
               k03      LIKE type_file.chr10,
               k04      LIKE type_file.chr10,
               k05      LIKE type_file.chr10,
               k06      LIKE type_file.chr10,
               k07      LIKE type_file.chr10,
               k08      LIKE type_file.chr10,
               k09      LIKE type_file.chr10,
               k10      LIKE type_file.chr10,
               k11      LIKE type_file.chr10,
               k12      LIKE type_file.chr10,
               k13      LIKE type_file.chr10,
               k14      LIKE type_file.chr10,
               k15      LIKE type_file.chr10,
               k16      LIKE type_file.chr10,
               k17      LIKE type_file.chr10,
               k18      LIKE type_file.chr10,
               k19      LIKE type_file.chr10,
               k20      LIKE type_file.chr10,
        sld10      LIKE sld_file.sld10,
        sld11      LIKE sld_file.sld11
                    END RECORD,
    #g_wc,g_wc2,g_sql    LIKE type_file.chr1000,
    g_wc,g_wc2,g_sql    STRING,      #NO.FUN-910082
    l_za05              LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,              
    l_ac            LIKE type_file.num5               
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_ima02    LIKE ima_file.ima02,
         g_ima021   LIKE ima_file.ima021
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_chr           LIKE type_file.chr1
DEFINE g_cnt           LIKE type_file.num10   
DEFINE g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE g_no_ask      LIKE type_file.num5 
 
MAIN
   OPTIONS                                
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASK")) THEN 
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW t004_w WITH FORM "ask/42f/askt004"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
        
   CALL g_x.clear()
 
   LET g_forupd_sql = "SELECT * FROM slc_file WHERE slc01 = ? AND slc02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t004_cl CURSOR FROM g_forupd_sql
 
   CALL t004_menu()
 
   CLOSE WINDOW t004_w                
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t004_set_visible()
DEFINE 
    i        LIKE type_file.num5,
    l_msg    STRING
    FOR i = 1 TO 20
       LET l_msg = 'k',i USING '&&'
       CALL cl_set_comp_visible(l_msg,FALSE)
    END FOR
 
END FUNCTION
 
FUNCTION t004_cs()
   CALL t004_slg() 
   CLEAR FORM
   CALL g_sld.clear()
   CONSTRUCT BY NAME g_wc ON                     
      slc01,slc02,ima02,ima021,slc03,
      slc07,slc08,slc09,
      slcuser,slcgrup,slcmodu,slcdate
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(slc01)
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_oea13" 
               LET g_qryparam.form = "q_pbi"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO slc01
            WHEN INFIELD(slc02)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima98"
#              LET g_qryparam.state = "c"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima98","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO slc02
            WHEN INFIELD(slc07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO slc07
            WHEN INFIELD(slc09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_agc"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO slc09
 
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
 
   
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('slcuser', 'slcgrup') #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           
   #       LET g_wc = g_wc clipped," AND slcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                          
   #       LET g_wc = g_wc clipped," AND slcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   CONSTRUCT g_wc2 ON sld03,sld05,bol02,sld06,slb02,
                      sld04,sld07,sld10,sld11
        FROM s_sld[1].sld03,
             s_sld[1].sld05,s_sld[1].bol02,
             s_sld[1].sld06,s_sld[1].slb02,
             s_sld[1].sld04,s_sld[1].sld07,
             s_sld[1].sld10,s_sld[1].sld11
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sld05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bol"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sld05
            WHEN INFIELD(sld06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_slb"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sld06
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
 
   
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF g_wc2 = " 1=1" THEN			# 
      LET g_sql = "SELECT UNIQUE slc01,slc02 FROM slc_file,ima_file,ocq_file ",
                  " WHERE slc02 = ima01 AND ", g_wc CLIPPED,
                  " ORDER BY 1"
   ELSE					
      LET g_sql = "SELECT UNIQUE slc01,slc02 ",
                  "  FROM slc_file, sld_file, ima_file, ",
                  "       bol_file, slb_file ",
                  " WHERE slc01 = sld01",
                  "   AND slc02 = sld02",
                  "   AND slc02 = ima01 ",
                  "   AND sld05 = bol01 ",
                  "   AND sld06 = slb01 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF
 
   PREPARE t004_prepare FROM g_sql
   DECLARE t004_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t004_prepare
 
   IF g_wc2 = " 1=1" THEN		
       LET g_sql="SELECT COUNT(*) FROM slc_file,ima_file WHERE slc02 = ima01 AND ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT slc01) FROM slc_file,sld_file,ima_file,oea_file,oeg_file WHERE slc01 = sld_file.sld01",
                 " AND slc02 = ima01 ",
                 " AND sld05 = bol01 ",
                 " AND slc02 = sld02 ", 
                 " AND sld06 = slb01 ",
                 " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t004_precount FROM g_sql
   DECLARE t004_count CURSOR FOR t004_precount
 
   OPEN t004_count
   FETCH t004_count INTO g_row_count
   CLOSE t004_count
 
END FUNCTION
 
FUNCTION t004_menu()
 
   WHILE TRUE
      #CALL t004_set_visible()
      CALL t004_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t004_a()
            END IF
 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t004_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t004_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL t004_u()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL t004_copy()
            END IF
         WHEN "modsize" 
            #IF cl_chk_act_auth() THEN
               CALL t004_modsize()
            #END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_slc.slc01 IS NOT NULL THEN
                  LET g_doc.column1 = "slc01"
                  LET g_doc.value1 = g_slc.slc01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sld),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t004_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CALL t004_set_visible()
    CLEAR FORM
    CALL g_sld.clear()
    INITIALIZE g_slc.* LIKE slc_file.*        
    LET g_slc01_t = NULL
    LET g_slc_o.* = g_slc.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_slc.slcuser=g_user
        LET g_slc.slcgrup=g_grup
        LET g_slc.slcdate=g_today
        LET g_slc.slcconf='N' 
        CALL t004_i("a")               
        IF INT_FLAG THEN                   
            INITIALIZE g_slc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_slc.slc01 IS NULL THEN               
            CONTINUE WHILE
        END IF
        LET g_slc.slcoriu = g_user      #No.FUN-980030 10/01/04
        LET g_slc.slcorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO slc_file VALUES (g_slc.*)
        IF SQLCA.sqlcode THEN   			#
            CALL cl_err(g_slc.slc01,SQLCA.sqlcode,1)
            CONTINUE WHILE
        END IF
        SELECT slc01,slc02 INTO g_slc.slc01,g_slc.slc02 FROM slc_file
            WHERE slc01 = g_slc.slc01
        LET g_slc01_t = g_slc.slc01        
        LET g_slc_t.* = g_slc.*
 
        CALL g_sld.clear()
        LET g_rec_b = 0
        CALL t004_default_b() 
        CALL t004_b()                  
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t004_default_b()
DEFINE #l_sql LIKE type_file.chr1000,
       l_sql        STRING,       #NO.FUN-910082  
#      l_wc  LIKE type_file.chr50,
       l_wc           STRING,       #NO.FUN-910082 
       l_k   LIKE type_file.num5,
       l_slf RECORD LIKE slf_file.*,
       l_sld RECORD LIKE sld_file.*
DEFINE l_slg        RECORD LIKE slg_file.*
DEFINE l_sle03      LIKE sle_file.sle03
 
   LET l_k = 0
   SELECT COUNT(*) INTO l_k FROM sle_file 
     WHERE sle01= g_slc.slc01
       AND sle02= g_slc.slc02
       AND sleconf <> 'X'  #CHI-C80041
     # AND sleconf = 'Y'
 
   IF l_k = 0 THEN
      CALL cl_err("",-998,0)
      RETURN
   END IF
   LET l_sql = "SELECT slf_file.* FROM slf_file,sle_file ",
               " WHERE slf01 ='",g_slc.slc01,
               "'  AND slf02 ='",g_slc.slc02,
               "'  AND sle01 = slf01",
               "   AND sle02 = slf02",
               "   AND sle03 = slf03",
               "   AND sle07 = 'Y'",
               "   AND sleconf <> 'X' "  #CHI-C80041
 
   PREPARE t001f_precount96 FROM l_sql
   DECLARE t001f_count96 CURSOR FOR t001f_precount96
 
   FOREACH t001f_count96 INTO l_slf.*
      LET l_sld.sld01 = l_slf.slf01
      LET l_sld.sld02 = l_slf.slf02
      LET l_sld.sld03 = l_slf.slf04
      LET l_sld.sld04 = l_slf.slf05
      LET l_sld.sld05 = l_slf.slf06
      LET l_sld.sld06 = l_slf.slf07
      LET l_sld.sld07 = l_slf.slf08
      LET l_sld.sld08 = l_slf.slf03
      LET l_sld.sld09 = l_slf.slf09
      LET l_sld.sld09a = l_slf.slf09a
      LET l_sld.sld10 = l_slf.slf17    
      LET l_sld.sld11 = l_slf.slf18
      INSERT INTO sld_file VALUES (l_sld.*)
   END FOREACH
#   CALL t004_p()
   #No.MOD-910137 add --begin
   DECLARE t004_ins_slg CURSOR FOR
    SELECT sle03 FROM sle_file
     WHERE sle01= g_slc.slc01
       AND sle02= g_slc.slc02
       AND sleconf <> 'X'  #CHI-C80041
   LET l_k = 1
   FOREACH t004_ins_slg INTO l_sle03
      LET l_slg.slg01 = g_slc.slc01
      LET l_slg.slg02 = g_slc.slc02
      LET l_slg.slg03 = l_k
      LET l_slg.slg04 = l_sle03
      INSERT INTO slg_file VALUES (l_slg.*)
      LET l_k = l_k + 1 
   END FOREACH
   #No.MOD-910137 add --end
   LET l_wc = " 1=1"   
   CALL t004_b_fill(l_wc)
         
END FUNCTION
FUNCTION t004_u()
    IF s_shut(0) THEN RETURN END IF
    CALL t004_set_visible()
    IF g_slc.slc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_slc.* FROM slc_file 
     WHERE slc01=g_slc.slc01
       AND slc02=g_slc.slc02
       AND slc03=g_slc.slc03
    IF g_slc.slcconf ='Y' THEN    
       CALL cl_err(g_slc.slc01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_slc01_t = g_slc.slc01
    LET g_slc_o.* = g_slc.*
    BEGIN WORK
 
    OPEN t004_cl USING g_slc.slc01,g_slc.slc02
    IF STATUS THEN
       CALL cl_err("OPEN t004_cl:", STATUS, 1)
       CLOSE t004_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t004_cl INTO g_slc.*           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_slc.slc01,SQLCA.sqlcode,1)   
        CLOSE t004_cl ROLLBACK WORK RETURN
    END IF
    CALL t004_show()
    WHILE TRUE
        LET g_slc01_t = g_slc.slc01
        LET g_slc.slcmodu=g_user
        LET g_slc.slcdate=g_today
        CALL t004_i("u")                   
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_slc.*=g_slc_t.*
            CALL t004_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_slc.slc01 != g_slc01_t THEN           
            UPDATE sld_file SET sld01 = g_slc.slc01
                WHERE sld01 = g_slc01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err('sld',SQLCA.sqlcode,0) CONTINUE WHILE
            END IF
        END IF
        UPDATE slc_file SET slc_file.* = g_slc.*
            WHERE slc01 = g_slc_t.slc01 AND slc02 = g_slc_t.slc02
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_slc.slc01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t004_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t004_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,             
            p_cmd    LIKE type_file.chr1,             
            l_cnt    LIKE type_file.num5               
 
 
   INPUT 
      g_slc.slc01,g_slc.slc02,g_slc.slc03,
      g_slc.slc09,g_slc.slc07,g_slc.slc08 WITHOUT DEFAULTS  
      FROM 
      slc01,slc02,slc03,slc09,slc07,slc08
        
              
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t004_set_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD slc09
         IF NOT cl_null(g_slc.slc09) THEN
            LET g_cnt = 0 
             SELECT count(*) INTO g_cnt FROM ocq_file
               WHERE ocq01 = g_slc.slc09
#                AND ocq06 = '1'    FUN-8A0151 
                 AND ocqacti = 'Y'
            IF g_cnt <= 0  THEN
               CALL cl_err('','ask-111',0)
               NEXT FIELD slc09
            END IF
          
            IF p_cmd = 'u' THEN
               IF cl_confirm('ask-112') THEN
                  CALL t004_deleteb()
                  CALL t004_default_b()
               END IF
            END IF
         END IF
                    
      AFTER FIELD slc01                  
         IF NOT cl_null(g_slc.slc01) THEN
               LET g_cnt = 0 
               SELECT count(*) INTO g_cnt FROM sle_file 
                WHERE sle01  = g_slc.slc01
                  AND sleconf <> 'X'  #CHI-C80041
              #   AND sleconf = 'Y'
               IF g_cnt <= 0 THEN
                 CALL cl_err('','ask-110',0)   
                 NEXT FIELD slc01
               END IF
 
               IF NOT cl_null(g_slc.slc02) THEN
                  LET g_cnt = 0
                  SELECT count(*) INTO g_cnt FROM ima_file
                   WHERE ima01 = g_slc.slc02
                    #AND imaag1 = ' '
                  IF g_cnt <= 0 THEN
                     CALL cl_err('','ask-113',0)
                     DISPLAY BY NAME g_slc.slc02
                     NEXT FIELD slc02
                  ELSE
                     LET g_cnt = 0
                     SELECT count(*) INTO g_cnt FROM sle_file
                      WHERE sle01 = g_slc.slc01
                        AND sle02 = g_slc.slc02
                        AND sleconf <> 'X'  #CHI-C80041
                     IF g_cnt <= 0 THEN
                        CALL cl_err('','ask-113',0)
                        NEXT FIELD slc02
                     ELSE
                        SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file
                         WHERE ima01 = g_slc.slc02
                          #AND imaag1 = ' '
                        DISPLAY g_ima02 TO ima02
                        DISPLAY g_ima021 TO ima021
                     END IF
                  END IF
            END IF
 
         END IF
 
      AFTER FIELD slc02
         IF NOT cl_null(g_slc.slc02) THEN
#FUN-AB0025 ---------------------start----------------------------
             IF NOT s_chk_item_no(g_slc.slc02,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_slc.slc02= g_slc_t.slc02
                NEXT FIELD slc02
             END IF
#FUN-AB0025 ---------------------end-------------------------------
              LET g_cnt = 0
              SELECT count(*) INTO g_cnt FROM ima_file
               WHERE ima01 = g_slc.slc02
                 #AND imaag1 = ' '
              IF g_cnt <= 0 THEN
                 CALL cl_err('','ask-113',0)
                 DISPLAY BY NAME g_slc.slc02
                 NEXT FIELD slc02
              ELSE
                 LET g_cnt = 0
                 SELECT count(*) INTO g_cnt FROM sle_file
                  WHERE sle01 = g_slc.slc01
                    AND sle02 = g_slc.slc02
                    AND sleconf <> 'X'  #CHI-C80041
                 IF g_cnt <= 0 THEN
                    CALL cl_err('','ask-113',0)
                    NEXT FIELD slc02
                 ELSE
                    SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file
                     WHERE ima01 = g_slc.slc02
                      #AND imaag1 = ' '
                    DISPLAY g_ima02 TO ima02
                    DISPLAY g_ima021 TO ima021
                 END IF
              END IF
        END IF
 
      BEFORE FIELD slc03
         LET g_slc.slc03 = g_today
         DISPLAY BY NAME g_slc.slc03
 
      AFTER INPUT  
         LET g_slc.slcuser = s_get_data_owner("slc_file") #FUN-C10039
         LET g_slc.slcgrup = s_get_data_group("slc_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
 
 
      ON ACTION CONTROLF                 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
      ON ACTION CONTROLO                        
         IF INFIELD(slc01) THEN
            LET g_slc.* = g_slc_t.*
            #No.FUN-9A0024--begin
            #DISPLAY BY NAME g_slc.* 
            DISPLAY BY NAME g_slc.slc01,g_slc.slc02,g_slc.slc03,
                            g_slc.slc07,g_slc.slc08,g_slc.slc09,
                            g_slc.slcuser,g_slc.slcgrup,g_slc.slcmodu,
                            g_slc.slcdate,g_slc.slcoriu,g_slc.slcorig         
            #No.FUN-9A0024--end                   
            NEXT FIELD slc01
         END IF
 
      ON ACTION controlp
        CASE
           WHEN INFIELD(slc01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_slc01"
              LET g_qryparam.default1 = g_slc.slc01
              CALL cl_create_qry() RETURNING g_slc.slc01
              DISPLAY g_slc.slc01 TO slc01
           WHEN INFIELD(slc02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_slc02"
              LET g_qryparam.arg1 = g_slc.slc01
              LET g_qryparam.default1 = g_slc.slc02
              CALL cl_create_qry() RETURNING g_slc.slc02
              DISPLAY g_slc.slc02 TO slc02
           WHEN INFIELD(slc07)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.default1 = g_slc.slc07
              CALL cl_create_qry() RETURNING g_slc.slc07
              DISPLAY g_slc.slc07 TO slc07
           WHEN INFIELD(slc09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ocq01"
               LET g_qryparam.default1 = g_slc.slc09
               CALL cl_create_qry() RETURNING g_slc.slc09
               DISPLAY g_slc.slc09 TO slc09 
 
           OTHERWISE
              EXIT CASE
        END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help         
         CALL cl_show_help() 
 
   END INPUT
END FUNCTION
 
FUNCTION t004_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("slc01",TRUE)
      END IF
END FUNCTION
 
FUNCTION t004_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1
 
      IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("slc01",FALSE)
      END IF
 
END FUNCTION
 
     
FUNCTION t004_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL t004_set_visible()
    CLEAR FORM
    CALL g_sld.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t004_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN t004_count
    FETCH t004_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t004_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_slc.* TO NULL
    ELSE
        CALL t004_fetch('F')                 
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t004_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,              
    ls_jump         LIKE ze_file.ze03
 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t004_cs 
                       INTO g_slc.slc01,g_slc.slc02
        WHEN 'P' FETCH PREVIOUS t004_cs 
                       INTO g_slc.slc01,g_slc.slc02
        WHEN 'F' FETCH FIRST    t004_cs 
                       INTO g_slc.slc01,g_slc.slc02
        WHEN 'L' FETCH LAST     t004_cs 
                       INTO g_slc.slc01,g_slc.slc02
        WHEN '/'
             IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()     
 
               
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t004_cs 
                      INTO g_slc.slc01,g_slc.slc02 
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_slc.slc01,SQLCA.sqlcode,0)
        RETURN
    ELSE
         CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
    SELECT * INTO g_slc.* FROM slc_file WHERE slc01 = g_slc.slc01 AND slc02 = g_slc.slc02
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_slc.slc01,SQLCA.sqlcode,0)
        INITIALIZE g_slc.* TO NULL
        RETURN
    ELSE                                    
       LET g_data_owner=g_slc.slcuser       
       LET g_data_group=g_slc.slcgrup
    END IF
 
    CALL t004_show()
END FUNCTION
 
FUNCTION t004_show()
    DEFINE l_cnt      LIKE type_file.num5
    SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file
     WHERE ima01 = g_slc.slc02 
    LET g_slc_t.* = g_slc.*                      
    DISPLAY BY NAME                             
        g_slc.slc01,g_slc.slc02,
        g_slc.slc03,
        g_slc.slc07,g_slc.slc08,g_slc.slc09,
        g_slc.slcuser,g_slc.slcgrup,g_slc.slcmodu,
        g_slc.slcdate,g_slc.slcoriu,g_slc.slcorig        #No.FUN-9A0024 add slcoriu,slcorig
    DISPLAY g_ima02 TO ima02
    DISPLAY g_ima021 TO ima021
    CALL t004_b_fill(g_wc2)                 
 
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION t004_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_slc.slc01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t004_cl USING g_slc.slc01,g_slc.slc02
    IF STATUS THEN
       CALL cl_err("OPEN t004_cl:", STATUS, 1)
       CLOSE t004_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t004_cl INTO g_slc.*              
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_slc.slc01,SQLCA.sqlcode,0)         
        CLOSE t004_cl ROLLBACK WORK RETURN
    END IF
    CALL t004_show()
    IF cl_delh(0,0) THEN                  
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "slc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_slc.slc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
         DELETE FROM slc_file WHERE slc01 = g_slc.slc01
                                    AND slc02 = g_slc.slc02
         DELETE FROM sld_file WHERE sld01 = g_slc.slc01
                                    AND sld02 = g_slc.slc02
         DELETE FROM slg_file WHERE slg01 = g_slc.slc01
                                    AND slg02 = g_slc.slc02
 
         INITIALIZE g_slc.* TO NULL
         CLEAR FORM
         CALL g_sld.clear()
         OPEN t004_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t004_cs
            CLOSE t004_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t004_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t004_cs
            CLOSE t004_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t004_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t004_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t004_fetch('/')
         END IF
    END IF
    CLOSE t004_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION t004_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              
    l_n             LIKE type_file.num5,             
    l_lock_sw       LIKE type_file.chr1,               
    p_cmd           LIKE type_file.chr1,               
    l_k             LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,              
    l_allow_delete  LIKE type_file.chr1               
    
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_slc.slc01 IS NULL THEN
       RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    SELECT * INTO g_slc.* FROM slc_file 
     WHERE slc01=g_slc.slc01
       AND slc02=g_slc.slc02
 
    CALL cl_opmsg('b')
    CALL t004_slg()
 
    LET g_forupd_sql = "SELECT DISTINCT sld03,sld05,'',sld06,'',",
                       "       sld04,sld07,'','','','','','','','','','',",
                       "       '','','','','','','','','','',sld10,sld11",
                       "       FROM sld_file ",
                       "  WHERE sld01=? AND sld02=? ",
                       "   AND sld03=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_sld WITHOUT DEFAULTS FROM s_sld.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
           DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
 
            BEGIN WORK
            OPEN t004_cl USING g_slc.slc01,g_slc.slc02
            IF STATUS THEN
               CALL cl_err("OPEN t004_cl:", STATUS, 1)
               CLOSE t004_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t004_cl INTO g_slc.*           
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_slc.slc01,SQLCA.sqlcode,0)     
               CLOSE t004_cl 
               ROLLBACK WORK 
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_sld_t.* = g_sld[l_ac].*  #BACKUP
         
                CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_sld[l_ac].* TO NULL     
            LET g_sld_t.* = g_sld[l_ac].*         
            CALL cl_show_fld_cont()    
            NEXT FIELD sld03
 
        AFTER INSERT
        DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           CALL t004_g_sld08()
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_sld[l_ac].sld03,SQLCA.sqlcode,1)
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD sld03                       
            IF g_sld[l_ac].sld03 IS NULL OR
               g_sld[l_ac].sld03 = 0 THEN
                 SELECT max(sld03)+1              
                   INTO g_sld[l_ac].sld03
                   FROM sld_file
                   WHERE sld01 = g_slc.slc01
                     AND sld02 = g_slc.slc02
                IF g_sld[l_ac].sld03 IS NULL THEN
                    LET g_sld[l_ac].sld03 = 1
                END IF
            END IF
 
        AFTER FIELD sld03                        
            IF NOT cl_null(g_sld[l_ac].sld03) THEN
               IF g_sld[l_ac].sld03 != g_sld_t.sld03 OR
                  g_sld_t.sld03 IS NULL THEN
                  LET l_n = 0
                   SELECT count(*) INTO l_n FROM sld_file
                    WHERE sld01 = g_slc.slc01 
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[l_ac].sld03 
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_sld[l_ac].sld03 = g_sld_t.sld03
                      NEXT FIELD sld03
                   END IF
               END IF
            ELSE
               NEXT FIELD sld03
            END IF
 
        AFTER FIELD sld05
            IF NOT cl_null(g_sld[l_ac].sld05) THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt
                 FROM bol_file
                WHERE bol01 = g_sld[l_ac].sld05
               IF g_cnt<=0 THEN
                  CALL cl_err('','ask-114',0)
                  NEXT FIELD sld05
               ELSE
                  SELECT bol02 INTO g_sld[l_ac].bol02 
                    FROM bol_file
                   WHERE bol01 = g_sld[l_ac].sld05
               END IF
            END IF
 
        AFTER FIELD sld06
            IF NOT cl_null(g_sld[l_ac].sld06) THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt
                 FROM slb_file
                WHERE slb01 = g_sld[l_ac].sld06
               IF g_cnt<=0 THEN
                  CALL cl_err('','ask-115',0)
                  NEXT FIELD sld06
               ELSE
                  SELECT slb02 INTO g_sld[l_ac].slb02
                    FROM slb_file
                   WHERE slb01 = g_sld[l_ac].sld06
               END IF
            END IF
        AFTER FIELD k01
            CALL cl_s_d(g_sld[l_ac].k01) RETURNING g_k[l_ac].s01,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k01 
            END IF
        AFTER FIELD k02
            CALL cl_s_d(g_sld[l_ac].k02) RETURNING g_k[l_ac].s02,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k02
            END IF
        AFTER FIELD k03
            CALL cl_s_d(g_sld[l_ac].k03) RETURNING g_k[l_ac].s03,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k03
            END IF
        AFTER FIELD k04
            CALL cl_s_d(g_sld[l_ac].k04) RETURNING g_k[l_ac].s04,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k04
            END IF
        AFTER FIELD k05
            CALL cl_s_d(g_sld[l_ac].k05) RETURNING g_k[l_ac].s05,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k05
            END IF
        AFTER FIELD k06
            CALL cl_s_d(g_sld[l_ac].k06) RETURNING g_k[l_ac].s06,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k06
            END IF
        AFTER FIELD k07
            CALL cl_s_d(g_sld[l_ac].k07) RETURNING g_k[l_ac].s07,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k07
            END IF
        AFTER FIELD k08
            CALL cl_s_d(g_sld[l_ac].k08) RETURNING g_k[l_ac].s08,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k08
            END IF
        AFTER FIELD k09
            CALL cl_s_d(g_sld[l_ac].k09) RETURNING g_k[l_ac].s09,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k09
            END IF
        AFTER FIELD k10
            CALL cl_s_d(g_sld[l_ac].k10) RETURNING g_k[l_ac].s10,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k10
            END IF
        AFTER FIELD k11
            CALL cl_s_d(g_sld[l_ac].k11) RETURNING g_k[l_ac].s11,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k11
            END IF
        AFTER FIELD k12
            CALL cl_s_d(g_sld[l_ac].k12) RETURNING g_k[l_ac].s12,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k12
            END IF
        AFTER FIELD k13
            CALL cl_s_d(g_sld[l_ac].k13) RETURNING g_k[l_ac].s13,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k13
            END IF
        AFTER FIELD k14
            CALL cl_s_d(g_sld[l_ac].k14) RETURNING g_k[l_ac].s14,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k14
            END IF
        AFTER FIELD k15
            CALL cl_s_d(g_sld[l_ac].k15) RETURNING g_k[l_ac].s15,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k15
            END IF
        AFTER FIELD k16
            CALL cl_s_d(g_sld[l_ac].k16) RETURNING g_k[l_ac].s16,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k16
            END IF
        AFTER FIELD k17
            CALL cl_s_d(g_sld[l_ac].k17) RETURNING g_k[l_ac].s17,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k17
            END IF
        AFTER FIELD k18
            CALL cl_s_d(g_sld[l_ac].k18) RETURNING g_k[l_ac].s18,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k18
            END IF
        AFTER FIELD k19
            CALL cl_s_d(g_sld[l_ac].k19) RETURNING g_k[l_ac].s19,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k19
            END IF
        AFTER FIELD k20
            CALL cl_s_d(g_sld[l_ac].k20) RETURNING g_k[l_ac].s20,l_k
            IF l_k = 'N' THEN
               NEXT FIELD k20
            END IF
 
        BEFORE DELETE                            
            IF g_sld_t.sld03 > 0 AND
               g_sld_t.sld03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               DELETE FROM sld_file
                WHERE sld01 = g_slc.slc01 
                  AND sld02 = g_slc.slc02
                  AND sld03 = g_sld_t.sld03 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_sld_t.sld03,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete Ok"
               CLOSE t004_bcl
               COMMIT WORK
            END IF
 
     ON ROW CHANGE
            DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN                 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sld[l_ac].* = g_sld_t.*
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sld[l_ac].sld04,-263,1)
               LET g_sld[l_ac].* = g_sld_t.*
            ELSE
               CALL t004_g_sld08_up()
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_sld[l_ac].sld03,SQLCA.sqlcode,1)
                  LET g_sld[l_ac].* = g_sld_t.*
                  CLOSE t004_bcl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE t004_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           DISPLAY "AFTER  ROW"
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac            #FUN-D40030 mark
 
           IF INT_FLAG THEN               
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_sld[l_ac].* = g_sld_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_sld.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE t004_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           LET l_ac_t = l_ac           #FUN-D40030 add
           CLOSE t004_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(sld05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bol"
                     LET g_qryparam.default1 = g_sld[l_ac].sld05
                     CALL cl_create_qry() RETURNING g_sld[l_ac].sld05
                     DISPLAY BY NAME g_sld[l_ac].sld05
                     NEXT FIELD sld05
                WHEN INFIELD(sld06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_slb"
                     LET g_qryparam.default1 = g_sld[l_ac].sld06
                     CALL cl_create_qry() RETURNING g_sld[l_ac].sld06
                     DISPLAY BY NAME g_sld[l_ac].sld06
                     NEXT FIELD sld06
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            #CALL t004_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        
            LET g_sld[l_ac].* = g_sld[l_ac-1].*
            IF  l_ac > 1 THEN
               LET g_sld[l_ac].* = g_sld[l_ac-1].*
               SELECT max(sld03)+1
                 INTO g_sld[l_ac].sld03
                 FROM sld_file
                WHERE sld01 = g_slc.slc01
                  AND sld02=g_slc.slc02
               NEXT FIELD sld03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
     
#      ON ACTION default
#         CASE
#            WHEN INFIELD(k01)
#               LET g_sld[l_ac].k02 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k03 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k04 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k05 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k06 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k07 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k08 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k09 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k01
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k01
#            WHEN INFIELD(k02)
#               LET g_sld[l_ac].k03 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k04 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k05 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k06 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k07 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k08 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k09 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k02
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k02
#            WHEN INFIELD(k03)
#               LET g_sld[l_ac].k04 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k05 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k06 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k07 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k08 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k09 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k03
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k03
#            WHEN INFIELD(k04)
#               LET g_sld[l_ac].k05 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k06 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k07 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k08 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k09 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k04
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k04
#            WHEN INFIELD(k05)
#               LET g_sld[l_ac].k06 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k07 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k08 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k09 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k05
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k05
#            WHEN INFIELD(k06)
#               LET g_sld[l_ac].k07 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k08 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k09 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k06
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k06
#            WHEN INFIELD(k07)
#               LET g_sld[l_ac].k08 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k09 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k07
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k07
#            WHEN INFIELD(k08)
#               LET g_sld[l_ac].k09 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k08
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k08
#            WHEN INFIELD(k09)
#               LET g_sld[l_ac].k10 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k09
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k09
#            WHEN INFIELD(k10)
#               LET g_sld[l_ac].k11 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k10
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k10
#            WHEN INFIELD(k11)
#               LET g_sld[l_ac].k12 = g_sld[l_ac].k11
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k11
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k11
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k11
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k11
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k11
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k11
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k11
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k11
#            WHEN INFIELD(k12)
#               LET g_sld[l_ac].k13 = g_sld[l_ac].k12
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k12
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k12
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k12
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k12
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k12
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k12
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k12
#            WHEN INFIELD(k13)
#               LET g_sld[l_ac].k14 = g_sld[l_ac].k13
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k13
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k13
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k13
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k13
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k13
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k13
#            WHEN INFIELD(k14)
#               LET g_sld[l_ac].k15 = g_sld[l_ac].k14
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k14
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k14
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k14
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k14
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k14
#            WHEN INFIELD(k15)
#               LET g_sld[l_ac].k16 = g_sld[l_ac].k15
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k15
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k15
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k15
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k15
#            WHEN INFIELD(k16)
#               LET g_sld[l_ac].k17 = g_sld[l_ac].k16
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k16
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k16
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k16
#            WHEN INFIELD(k17)
#               LET g_sld[l_ac].k18 = g_sld[l_ac].k17
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k17
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k17
#            WHEN INFIELD(k18)
#               LET g_sld[l_ac].k19 = g_sld[l_ac].k18
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k18
#            WHEN INFIELD(k19)
#               LET g_sld[l_ac].k20 = g_sld[l_ac].k19
#            OTHERWISE
#               EXIT CASE
#         END CASE
    END INPUT
 
    LET g_slc.slcmodu = g_user
    LET g_slc.slcdate = g_today
    UPDATE slc_file SET slcmodu = g_slc.slcmodu,slcdate = g_slc.slcdate
     WHERE slc01 = g_slc.slc01
       AND slc02 = g_slc.slc02
    DISPLAY BY NAME g_slc.slcmodu,g_slc.slcdate
 
    CLOSE t004_bcl
    CLOSE t004_cl
    COMMIT WORK
    #CALL t004_delall()
    CALL t004_delHeader()     #CHI-C30002 add
 
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION t004_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM slg_file WHERE slg01 = g_slc.slc01     #CHI-C80041
                                    AND slg02 = g_slc.slc02 #CHI-C80041
         DELETE FROM slc_file WHERE slc01 = g_slc.slc01
                               AND slc02 = g_slc.slc02
         INITIALIZE g_slc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t004_delall()
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM sld_file
        WHERE sld01 = g_slc.slc01
          AND sld02=g_slc.slc02
    IF g_cnt <= 0 THEN 			
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM slc_file WHERE slc01 = g_slc.slc01
                                  AND slc02 = g_slc.slc02
    END IF
END FUNCTION
FUNCTION t004_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    #p_wc2           LIKE type_file.chr200,
    p_wc2           STRING,       #NO.FUN-910082 
    l_sld08         LIKE sld_file.sld08,
    l_i             LIKE type_file.num5,
    i               LIKE type_file.num5          
 
    CALL t004_slg() 
    LET g_sql =
        "SELECT  DISTINCT sld03,sld05,'',sld06,'',sld04, ",
        "        sld07,'','','','','','','','','','','','','','','', ",
        "       '','','','','',sld10,sld11 ",
        " FROM sld_file ",
        " WHERE sld01 ='",g_slc.slc01,"' AND ", 
        "       sld02 ='",g_slc.slc02,"' AND ", 
        p_wc2 CLIPPED,                     
        " ORDER BY 1"
    PREPARE t004_pb FROM g_sql
    DECLARE sld_curs                       #SCROLL CURSOR
        CURSOR FOR t004_pb
 
     CALL g_sld.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH sld_curs INTO g_sld[g_cnt].*   
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT bol02
        INTO  g_sld[g_cnt].bol02
        FROM  bol_file
       WHERE bol01 = g_sld[g_cnt].sld05
      SELECT slb02
        INTO  g_sld[g_cnt].slb02
        FROM  slb_file
       WHERE slb01 = g_sld[g_cnt].sld06
      LET g_sql = " SELECT sld08 FROM sld_file ",
                  " WHERE sld01 ='",g_slc.slc01,"' AND ",
                  "       sld02 ='",g_slc.slc02,"' AND ",
                  "       sld03 ='",g_sld[g_cnt].sld03,"'",
                  " order by sld08"
      PREPARE t004_pb999 FROM g_sql
      DECLARE sld_curs999
         CURSOR FOR t004_pb999
      FOREACH sld_curs999 INTO l_sld08
        FOR i = 1 TO 20
           IF g_value[i].nvalue = l_sld08 THEN
              CASE g_value[i].fname
                WHEN 'k01' 
                   SELECT sld09 INTO g_sld[g_cnt].k01
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k02'
                   SELECT sld09 INTO g_sld[g_cnt].k02
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k03'
                   SELECT sld09 INTO g_sld[g_cnt].k03
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k04'
                   SELECT sld09 INTO g_sld[g_cnt].k04
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k05'
                   SELECT sld09 INTO g_sld[g_cnt].k05
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k06'
                   SELECT sld09 INTO g_sld[g_cnt].k06
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k07'
                   SELECT sld09 INTO g_sld[g_cnt].k07
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k08'
                   SELECT sld09 INTO g_sld[g_cnt].k08
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k09'
                   SELECT sld09 INTO g_sld[g_cnt].k09
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k10'
                   SELECT sld09 INTO g_sld[g_cnt].k10
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k11'
                   SELECT sld09 INTO g_sld[g_cnt].k11
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k12'
                   SELECT sld09 INTO g_sld[g_cnt].k12
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k13'
                   SELECT sld09 INTO g_sld[g_cnt].k13
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k14'
                   SELECT sld09 INTO g_sld[g_cnt].k14
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k15'
                   SELECT sld09 INTO g_sld[g_cnt].k15
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k16'
                   SELECT sld09 INTO g_sld[g_cnt].k16
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k17'
                   SELECT sld09 INTO g_sld[g_cnt].k17
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k18'
                   SELECT sld09 INTO g_sld[g_cnt].k18
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k19'
                   SELECT sld09 INTO g_sld[g_cnt].k19
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
                WHEN 'k20'
                   SELECT sld09 INTO g_sld[g_cnt].k20
                     FROM sld_file
                    WHERE sld01 = g_slc.slc01
                      AND sld02 = g_slc.slc02
                      AND sld03 = g_sld[g_cnt].sld03
                      AND sld08 = l_sld08
              END CASE
            END IF
         END FOR             
      END FOREACH
        LET g_rec_b = g_rec_b + 1
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_sld.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sld TO s_sld.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
  
      ON ACTION modsize
         CALL t004_modsize()
 
      ON ACTION first 
         CALL t004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY                  
                              
      ON ACTION previous
         CALL t004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY                   
                              
      ON ACTION jump 
         CALL t004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY                   
                              
      ON ACTION next
         CALL t004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
                              
      ON ACTION last 
         CALL t004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                   
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
       ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
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
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t004_copy()
DEFINE
    l_slc		RECORD LIKE slc_file.*,
    l_oldno,l_newno	LIKE slc_file.slc01,
    l_oldsty,l_newsty LIKE type_file.chr20
 
    IF s_shut(0) THEN RETURN END IF
    IF g_slc.slc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t004_set_entry('a')
    CALL t004_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno,l_newsty FROM slc01,slc02
 
      ON ACTION controlp
        CASE
           WHEN INFIELD(slc01)
              CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_oea13"   
              LET g_qryparam.form = "q_pbi"
              LET g_qryparam.default1 = l_newno
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO slc01
           WHEN INFIELD(slc02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima201"
              LET g_qryparam.arg1 = l_newno
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = l_newsty
              CALL cl_create_qry() RETURNING l_newsty
              DISPLAY l_newsty TO slc02  
           OTHERWISE
              EXIT CASE
        END CASE           
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
        AFTER FIELD slc02
           IF NOT cl_null(l_newno) THEN
              SELECT count(*) INTO g_cnt FROM slc_file
               WHERE slc01 = l_newno
               and slc02 = l_newsty
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 NEXT FIELD slc02
              END IF
           END IF 
    
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_slc.slc01
       RETURN
    END IF
 
    LET l_slc.* = g_slc.*
    LET l_slc.slc01  =l_newno   
    LET l_slc.slc02  =l_newsty   
    LET l_slc.slcuser=g_user    
    LET l_slc.slcgrup=g_grup    
    LET l_slc.slcmodu=NULL     
    LET l_slc.slcdate=g_today   
    BEGIN WORK
    LET l_slc.slcoriu = g_user      #No.FUN-980030 10/01/04
    LET l_slc.slcorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO slc_file VALUES (l_slc.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err('slc:',SQLCA.sqlcode,0)
        RETURN
    END IF
 
    DROP TABLE x1
    SELECT * FROM sld_file         
    WHERE sld01=g_slc.slc01
    AND sld02=g_slc.slc02
    INTO TEMP x1
    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_slc.slc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    UPDATE x1
        SET   sld01=l_newno,
        		  sld02=l_newsty
    INSERT INTO sld_file
        SELECT * FROM x1
    IF SQLCA.sqlcode THEN
        CALL cl_err('sld:',SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    DROP TABLE x1
    SELECT * FROM slg_file         
    WHERE slg01=g_slc.slc01
    AND slg02=g_slc.slc02
    INTO TEMP x1
    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_slc.slc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    UPDATE x1
        SET   slg01=l_newno,
        		  slg02=l_newsty
    INSERT INTO slg_file
        SELECT * FROM x1
    IF SQLCA.sqlcode THEN
        CALL cl_err('slg:',SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF    
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        
    #LET l_oldno = g_slc.slc01   #FUN-C80046
    #LET l_oldsty = g_slc.slc02  #FUN-C80046
    
    SELECT slc_file.* 
    INTO g_slc.* 
    FROM slc_file 
    #WHERE slc01 = l_oldno
    #AND slc02 = l_oldsty
    WHERE slc01 = l_newno #FUN-C80046
    AND slc02 = l_newsty  #FUN-C80046
    
    CALL t004_show()
END FUNCTION
 
#FUNCTION t004_p()
#   DEFINE l_slg_t RECORD 
#            slg03 LIKE slg_file.slg03,
#            slg04 LIKE slg_file.slg04
#                  END RECORD,
#          l_slg DYNAMIC ARRAY OF RECORD
#            slg03 LIKE slg_file.slg03,
#            slg04 LIKE slg_file.slg04
#                  END RECORD,
#          l_slg01 LIKE slg_file.slg01,
#          l_slg02 LIKE slg_file.slg02,
#          l_ima02 LIKE ima_file.ima02
#   DEFINE p_row,p_col LIKE type_file.num5,
#          l_allow_insert  LIKE type_file.chr1,              
#          l_allow_delete  LIKE type_file.chr1,
#          l_ac_t          LIKE type_file.num5,              
#   l_n,l_i         LIKE type_file.num5,             
#   l_lock_sw       LIKE type_file.chr1,               
#   p_cmd           LIKE type_file.chr1
#
#   IF cl_null(g_slc.slc01) OR
#      cl_null(g_slc.slc02) THEN
#      RETURN
#   END IF
#
#   OPEN WINDOW t999f_w AT p_row,p_col              
#       WITH FORM "ask/42f/askt999"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
#    CALL cl_ui_init()
#      
#   
#   LET l_slg01 = g_slc.slc01 
#   LET l_slg02 = g_slc.slc02  
#   SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_slg02
#   DISPLAY l_slg01 TO slg01
#   DISPLAY l_slg01 TO slg02
#   DISPLAY l_ima02 TO ima02
#
#   IF s_shut(0) THEN RETURN END IF
#   LET l_allow_insert = cl_detail_input_auth('insert')
#   LET l_allow_delete = cl_detail_input_auth('delete')
#
#   IF g_slc.slc09 IS NOT NULL THEN
#      LET g_sql = "SELECT ocq04 FROM ocq_file ",
#                  "  WHERE ocq06 = '1'",
#                  "    AND ocq01 = '",g_slc.slc09,"'"
#      PREPARE t004_inaf FROM g_sql
#      DECLARE t004_inbf03 CURSOR FOR t004_inaf
#      LET g_rec_b = 0
#      LET l_i = 1
#      FOREACH t004_inbf03 INTO l_slg[l_i].slg04
#           LET l_slg[l_i].slg03 = l_i
#           INSERT INTO slg_file
#                VALUES(l_slg01,l_slg02,
#                       l_slg[l_i].slg03,l_slg[l_i].slg04)
#           IF STATUS OR SQLCA.SQLCODE THEN
#              CALL cl_err('ins slg:',SQLCA.SQLCODE,1)
#           END IF
#           LET l_i = l_i + 1
#           LET g_rec_b = g_rec_b + 1
#      END FOREACH
#      
#   END IF      
#   INPUT ARRAY l_slg WITHOUT DEFAULTS FROM s_slg.*
#          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
#
#        BEFORE INPUT
#            DISPLAY "BEFORE INPUT"
#            IF g_rec_b != 0 THEN
#               CALL fgl_set_arr_curr(l_ac)
#            END IF
#        BEFORE ROW
#            DISPLAY "BEFORE ROW"
#            LET l_ac = ARR_CURR()
#            IF g_rec_b >= l_ac THEN
#                LET l_slg_t.* = l_slg[l_ac].*  #BACKUP
#                CALL cl_show_fld_cont()     
#            END IF
#
#        BEFORE INSERT
#            DISPLAY "BEFORE INSERT"
#            LET l_n = ARR_COUNT()
#            INITIALIZE l_slg[l_ac].* TO NULL      
#            LET l_slg_t.* = l_slg[l_ac].*      
#            CALL cl_show_fld_cont()   
#            NEXT FIELD slg03
#        AFTER INSERT
#           DISPLAY "AFTER INSERT"
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              CANCEL INSERT
#           END IF
#           INSERT INTO slg_file
#                VALUES(l_slg01,l_slg02,
#                       l_slg[l_ac].slg03,l_slg[l_ac].slg04)
#
#           IF SQLCA.sqlcode THEN
#               CALL cl_err(l_slg[l_ac].slg03,SQLCA.sqlcode,1)
#               CANCEL INSERT
#           ELSE
#               MESSAGE 'INSERT O.K'
#               LET g_rec_b=g_rec_b+1
#               DISPLAY g_rec_b TO FORMONLY.cn2
#           END IF
#
#        BEFORE FIELD slg03                        
#            IF l_slg[l_ac].slg03 IS NULL OR
#               l_slg[l_ac].slg03 = 0 THEN
#                 SELECT max(slg03)+1               
#                   INTO l_slg[l_ac].slg03
#                   FROM slg_file
#                   WHERE slg01 = l_slg01
#                     AND slg02 = l_slg02
#                IF l_slg[l_ac].slg03 IS NULL THEN
#                    LET l_slg[l_ac].slg03 = 1
#                END IF
#            END IF
#
#        AFTER FIELD slg03                        
#            IF NOT cl_null(l_slg[l_ac].slg03) THEN
#               IF l_slg[l_ac].slg03 != l_slg_t.slg03 OR
#                  l_slg_t.slg03 IS NULL THEN
#                  LET l_n = 0
#                   SELECT count(*) INTO l_n FROM slg_file
#                    WHERE slg01 = l_slg01
#                      AND slg02 = l_slg02
#                      AND slg03 = l_slg[l_ac].slg03
#                   IF l_n > 0 THEN
#                      CALL cl_err('',-239,0)
#                      LET l_slg[l_ac].slg03 = l_slg_t.slg03
#                      NEXT FIELD slg03
#                   END IF
#               END IF
#            END IF
#
#        BEFORE DELETE                           
#            IF l_slg_t.slg03 > 0 AND
#               l_slg_t.slg03 IS NOT NULL THEN
#               IF NOT cl_delb(0,0) THEN
#                  CANCEL DELETE
#               END IF
#                IF l_lock_sw = "Y" THEN
#                   CALL cl_err("", -263, 1)
#                   CANCEL DELETE
#                END IF
#               DELETE FROM slg_file
#                WHERE slg01 = l_slg01
#                  AND slg02 = l_slg02
#                  AND slg03 = l_slg_t.slg03
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err(l_slg_t.slg03,SQLCA.sqlcode,0)
#                  CANCEL DELETE
#               END IF
#               LET g_rec_b=g_rec_b-1
#               DISPLAY g_rec_b TO FORMONLY.cn2
#               MESSAGE "Delete Ok"
#            END IF
#
#     ON ROW CHANGE
#            DISPLAY "ON ROW CHANGE"
#            IF INT_FLAG THEN                
#               CALL cl_err('',9001,0)
#               LET INT_FLAG = 0
#               LET l_slg[l_ac].* = l_slg_t.*
#               EXIT INPUT
#            END IF
#            UPDATE slg_file SET slg03=l_slg[l_ac].slg03,
#                                    slg005=l_slg[l_ac].slg04
#             WHERE slg01=l_slg01
#               AND slg02=l_slg02
#               AND slg03=l_slg_t.slg03
#            IF SQLCA.sqlcode THEN
#               CALL cl_err(l_slg[l_ac].slg03,SQLCA.sqlcode,1)
#               LET l_slg[l_ac].* = l_slg_t.*
#            ELSE
#               MESSAGE 'UPDATE O.K'
#            END IF
#      AFTER ROW
#           DISPLAY "AFTER  ROW"
#           LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac
#
#           IF INT_FLAG THEN                
#               CALL cl_err('',9001,0)
#               LET INT_FLAG = 0
#               EXIT INPUT
#           END IF
#      ON IDLE g_idle_seconds
#              CALL cl_on_idle()
#              CONTINUE INPUT
#
#      ON ACTION about         
#         CALL cl_about()      
#
#      ON ACTION help          
#         CALL cl_show_help()  
#
#   END INPUT
#   CLOSE WINDOW t999f_w
#   CALL t004_slg_p() 
#END FUNCTION
 
#FUNCTION t004_slg_p()
#   DEFINE l_sql LIKE type_file.chr1000,
#          l_wc  LIKE type_file.chr50,
#          l_sle03 LIKE sle_file.sle03,
#          l_ocq04 LIKE ocq_file.ocq04,
#          l_slg04_b LIKE slg_file.slg04,
#          l_sld     RECORD LIKE sld_file.*,
#          l_slg03  LIKE slg_file.slg03,
#          l_slg04  LIKE slg_file.slg04,
#          l_slf16  LIKE slf_file.slf16,
#
#          l_i         LIKE type_file.num5   
#   CALL t004_slg()
#   
#   SELECT sle03
#     INTO l_sle03 
#     FROM sle_file
#    WHERE sle01 = g_slc.slc01
#      AND sle02 = g_slc.slc02
#      AND sle07 = 'Y'
#
#   LET l_sql = "SELECT * FROM sld_file ",
#               " WHERE sld01='",g_slc.slc01,
#               "'  AND sld02='",g_slc.slc02,"'"
#
#   PREPARE t001f_precount98 FROM l_sql
#   DECLARE t001f_count98 CURSOR FOR t001f_precount98
#
#   SELECT slg04 INTO l_slg04_b
#     FROM slg_file
#    WHERE slg01 = g_slc.slc01
#      AND slg02 = g_slc.slc02
#      AND slg04 = l_sle03
#
#   LET l_sql = "SELECT slg03,slg04 FROM slg_file ",
#               " WHERE slg01 = '",g_slc.slc01,
#               "'  AND slg02 = '",g_slc.slc02,
#               "'  AND slg04 != '",l_sle03,"'"
#   PREPARE t001f_precount97 FROM l_sql
#   DECLARE t001f_count97 CURSOR FOR t001f_precount97
#
#   FOREACH t001f_count98 INTO l_sld.*
#      FOREACH t001f_count97 INTO l_slg03,l_slg04
#          IF l_slg04 = l_sld.sld08 THEN
#             CONTINUE FOREACH
#          ELSE
#       {
#             SELECT inbf03 INTO l_inbf03
#                FROM inbf_file
#               WHERE inbf00 = '1'
#                 AND inbf01 = g_slc.slc09
#                 AND inbf04 = l_slg04 
#             LET l_sld.sld08 = l_inbf03 
#          END IF
#          SELECT slf16 INTO l_slf16
#            FROM slf_file
#           WHERE slf01 = l_sld.sld01
#             AND slf02 = l_sld.sld02
#             AND slf03 = l_sle03 
#             AND slf04 = l_sld.sld03
#          IF l_sld.sld07 = 1 THEN
#             SELECT sle008 INTO l_sle0089
#               FROM sle_file
#              WHERE sle01 = g_slc.slc01
#                AND sle02 = g_slc.slc02
#                AND sle07 = 'Y'
#          END IF
#          IF l_sld.sld07 = 2 THEN
#             SELECT sle009 INTO l_sle0089
#               FROM sle_file
#              WHERE sle01 = g_slc.slc01
#                AND sle02 = g_slc.slc02
#                AND sle07 = 'Y'
#          END IF
#        }
#          LET l_sld.sld08 = l_slg04 
#          END IF                
#          INSERT INTO sld_file VALUES (l_sld.*)
#       END FOREACH
#   END FOREACH
# 
#   LET l_wc = " 1=1" 
#   CALL t004_b_fill(l_wc)
#                  
#END FUNCTION
 
FUNCTION t004_slg()
   DEFINE #l_sql LIKE type_file.chr1000,
          l_sql        STRING,       #NO.FUN-910082  
          l_slg04 LIKE slg_file.slg04,
          l_ocq05 LIKE ocq_file.ocq05,
          l_msg STRING,
          i     LIKE type_file.num5
 
   LET i = 1
   LET l_sql = "SELECT slg04 FROM slg_file ",
               "WHERE slg01 = '",g_slc.slc01,
               "' AND slg02 = '",g_slc.slc02,"'",
               " order by slg03"
   PREPARE t001f_precount99 FROM l_sql
   DECLARE t001f_count99 CURSOR FOR t001f_precount99
   
   FOREACH t001f_count99 INTO l_slg04
       IF STATUS THEN
          CALL cl_err('foreach slg04',STATUS,0)
          EXIT FOREACH
       END IF
 
       SELECT DISTINCT ocq05 INTO l_ocq05
         FROM ocq_file
         WHERE ocq04 = l_slg04
           AND ocq01 = g_slc.slc09
 
       LET l_msg = 'k',i USING '&&'
       CALL cl_set_comp_att_text(l_msg ,l_ocq05)
       CALL cl_set_comp_visible(l_msg,TRUE)
 
       LET g_value[i].fname = l_msg
       LET g_value[i].visible = 'Y'
       LET g_value[i].nvalue = l_slg04
 
       LET i = i + 1
       IF i = 21 THEN EXIT FOREACH END IF  
    END FOREACH
 
    FOR i = i TO 20
       LET l_msg = 'k',i USING '&&'
       CALL cl_set_comp_visible(l_msg,FALSE)
 
       LET g_value[i].fname = l_msg
       LET g_value[i].visible = 'N'
       LET g_value[i].nvalue = ''
    END FOR
 
END FUNCTION
 
FUNCTION t004_g_sld08_up()
DEFINE l_i   LIKE type_file.num5,
       l_sld RECORD LIKE sld_file.*
DEFINE l_k  LIKE type_file.chr1
 
      LET l_sld.sld01 = g_slc.slc01
      LET l_sld.sld02 = g_slc.slc02
      LET l_sld.sld03 = g_sld[l_ac].sld03
      LET l_sld.sld04 = g_sld[l_ac].sld04
      LET l_sld.sld05 = g_sld[l_ac].sld05
      LET l_sld.sld06 = g_sld[l_ac].sld06
      LET l_sld.sld07 = g_sld[l_ac].sld07
      LET l_sld.sld10 = g_sld[l_ac].sld10
      LET l_sld.sld11 = g_sld[l_ac].sld11
 
     FOR l_i = 1 TO 20
       IF g_value[l_i].visible = 'Y' THEN
          CASE l_i
            WHEN 1
              LET l_sld.sld09 = g_sld[l_ac].k01
            WHEN 2
              LET l_sld.sld09 = g_sld[l_ac].k02
            WHEN 3
              LET l_sld.sld09 = g_sld[l_ac].k03
            WHEN 4
              LET l_sld.sld09 = g_sld[l_ac].k04
            WHEN 5
              LET l_sld.sld09 = g_sld[l_ac].k05
            WHEN 6
              LET l_sld.sld09 = g_sld[l_ac].k06
            WHEN 7
              LET l_sld.sld09 = g_sld[l_ac].k07
            WHEN 8
              LET l_sld.sld09 = g_sld[l_ac].k08
            WHEN 9
              LET l_sld.sld09 = g_sld[l_ac].k09
            WHEN 10
              LET l_sld.sld09 = g_sld[l_ac].k10
            WHEN 11
              LET l_sld.sld09 = g_sld[l_ac].k11
            WHEN 12
              LET l_sld.sld09 = g_sld[l_ac].k12
            WHEN 13
              LET l_sld.sld09 = g_sld[l_ac].k13
            WHEN 14
              LET l_sld.sld09 = g_sld[l_ac].k14
            WHEN 15
              LET l_sld.sld09 = g_sld[l_ac].k15
            WHEN 16
              LET l_sld.sld09 = g_sld[l_ac].k16
            WHEN 17
              LET l_sld.sld09 = g_sld[l_ac].k17
            WHEN 18
              LET l_sld.sld09 = g_sld[l_ac].k18
            WHEN 19
              LET l_sld.sld09 = g_sld[l_ac].k19
            WHEN 20
              LET l_sld.sld09 = g_sld[l_ac].k20
          END CASE
          CALL cl_s_d(l_sld.sld09)
               RETURNING l_sld.sld09a,l_k
          UPDATE sld_file SET sld03=g_sld[l_ac].sld03,
                                  sld04=g_sld[l_ac].sld04,
                                  sld05=g_sld[l_ac].sld05,
                                  sld06=g_sld[l_ac].sld06,
                                  sld07=g_sld[l_ac].sld07,
                                  sld09=l_sld.sld09,
                                 sld09a=l_sld.sld09a,
                                  sld10=g_sld[l_ac].sld10,
                                  sld11=g_sld[l_ac].sld11
                WHERE sld01=g_slc.slc01
                  AND sld02=g_slc.slc02
                  AND sld03=g_sld_t.sld03
                  AND sld08=g_value[l_i].nvalue
       ELSE
          EXIT FOR
       END IF
    END FOR
END FUNCTION
 
FUNCTION t004_g_sld08()
DEFINE l_i   LIKE type_file.num5,
       l_sld RECORD LIKE sld_file.*
DEFINE l_k   LIKE type_file.chr1
      LET l_sld.sld01 = g_slc.slc01
      LET l_sld.sld02 = g_slc.slc02
      LET l_sld.sld03 = g_sld[l_ac].sld03
      LET l_sld.sld04 = g_sld[l_ac].sld04
      LET l_sld.sld05 = g_sld[l_ac].sld05
      LET l_sld.sld06 = g_sld[l_ac].sld06
      LET l_sld.sld07 = g_sld[l_ac].sld07
      LET l_sld.sld10 = g_sld[l_ac].sld10
      LET l_sld.sld11 = g_sld[l_ac].sld11
      FOR l_i = 1 TO 20
       IF g_value[l_i].visible = 'Y' THEN
          LET l_sld.sld08 = g_value[l_i].nvalue
          CASE l_i
            WHEN 1
              LET l_sld.sld09 = g_sld[l_ac].k01
            WHEN 2
              LET l_sld.sld09 = g_sld[l_ac].k02
            WHEN 3
              LET l_sld.sld09 = g_sld[l_ac].k03
            WHEN 4
              LET l_sld.sld09 = g_sld[l_ac].k04
            WHEN 5
              LET l_sld.sld09 = g_sld[l_ac].k05
            WHEN 6
              LET l_sld.sld09 = g_sld[l_ac].k06
            WHEN 7
              LET l_sld.sld09 = g_sld[l_ac].k07
            WHEN 8
              LET l_sld.sld09 = g_sld[l_ac].k08
            WHEN 9
              LET l_sld.sld09 = g_sld[l_ac].k09
            WHEN 10
              LET l_sld.sld09 = g_sld[l_ac].k10
            WHEN 11
              LET l_sld.sld09 = g_sld[l_ac].k11
            WHEN 12
              LET l_sld.sld09 = g_sld[l_ac].k12
            WHEN 13
              LET l_sld.sld09 = g_sld[l_ac].k13
            WHEN 14
              LET l_sld.sld09 = g_sld[l_ac].k14
            WHEN 15
              LET l_sld.sld09 = g_sld[l_ac].k15
            WHEN 16
              LET l_sld.sld09 = g_sld[l_ac].k16
            WHEN 17
              LET l_sld.sld09 = g_sld[l_ac].k17
            WHEN 18
              LET l_sld.sld09 = g_sld[l_ac].k18
            WHEN 19
              LET l_sld.sld09 = g_sld[l_ac].k19
            WHEN 20 
              LET l_sld.sld09 = g_sld[l_ac].k20
          END CASE
          CALL cl_s_d(l_sld.sld09)
               RETURNING l_sld.sld09a,l_k
          INSERT INTO sld_file
                VALUES(l_sld.*)
       ELSE
          EXIT FOR
       END IF
    END FOR
END FUNCTION
 
FUNCTION t004_g_sld()
DEFINE l_i   LIKE type_file.num5
     FOR l_i = 1 TO 20
       IF g_value[l_i].visible = 'Y' THEN
          CASE l_i
            WHEN 1
              SELECT sld09 INTO g_sld[l_ac].k01
                FROM sld_file
               WHERE sld01 = g_slc.slc01  #No.TQC-940183
                 AND sld02 = g_slc.slc02  #No.TQC-940183
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 2
              SELECT sld09 INTO g_sld[l_ac].k02
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 3
              SELECT sld09 INTO g_sld[l_ac].k03
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 4
              SELECT sld09 INTO g_sld[l_ac].k04
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 5
              SELECT sld09 INTO g_sld[l_ac].k05
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 6
              SELECT sld09 INTO g_sld[l_ac].k06
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 7
              SELECT sld09 INTO g_sld[l_ac].k07
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 8
              SELECT sld09 INTO g_sld[l_ac].k08
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 9
              SELECT sld09 INTO g_sld[l_ac].k09
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 10
              SELECT sld09 INTO g_sld[l_ac].k10
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 11
              SELECT sld09 INTO g_sld[l_ac].k11
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 12
              SELECT sld09 INTO g_sld[l_ac].k12
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 13
              SELECT sld09 INTO g_sld[l_ac].k13
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 14
              SELECT sld09 INTO g_sld[l_ac].k14
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 15
              SELECT sld09 INTO g_sld[l_ac].k15
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 16
              SELECT sld09 INTO g_sld[l_ac].k16
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 17
              SELECT sld09 INTO g_sld[l_ac].k17
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 18
              SELECT sld09 INTO g_sld[l_ac].k18
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 19
              SELECT sld09 INTO g_sld[l_ac].k19
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
            WHEN 20
              SELECT sld09 INTO g_sld[l_ac].k20
                FROM sld_file
               WHERE sld01 = g_slc.slc01
                 AND sld02 = g_slc.slc02
                 AND sld03 = g_sld[l_ac].sld03
                 AND sld08 = g_value[l_i].nvalue
          END CASE
        ELSE
          EXIT FOR
        END IF
      END FOR
END FUNCTION    
  
FUNCTION t004_deleteb()
DEFINE  
    #l_wc LIKE type_file.chr1000
    l_wc         STRING       #NO.FUN-910082 
 
   DELETE FROM sld_file WHERE sld01 = g_slc.slc01
                              AND sld02 = g_slc.slc02
 
   DELETE FROM slg_file WHERE slg01 = g_slc.slc01
                              AND slg02 = g_slc.slc02
 
   LET l_wc = " 1=1"
   CALL t004_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t004_modsize()
 DEFINE mod_act,size_no,size_desc LIKE type_file.chr10
 DEFINE l_slg04 like slg_file.slg04
 DEFINE l_seq     LIKE type_file.num5
 DEFINE l_size_no LIKE type_file.chr10
 DEFINE l_n      LIKE type_file.num5
 DEFINE l_sql    STRING 
 #INPUT size_no,mod_act WITHOUT DEFAULTS FROM 
 OPEN WINDOW t004_s AT 2,4
     WITH FORM "ask/42f/askt004_s" ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN 
 CALL cl_ui_init()
 let mod_act='2'
 INPUT BY NAME mod_act,size_no WITHOUT DEFAULTS    
      ON ACTION controlp
         CASE
            WHEN INFIELD(size_no)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_size01"
               LET g_qryparam.arg1 = g_slc.slc09
               LET g_qryparam.construct = "N"
               CALL cl_create_qry() RETURNING size_no
								 select ocq03,ocq05 into l_seq,size_desc
								 from ocq_file
								 where ocq01= g_slc.slc09
								 and ocq04= size_no            
               DISPLAY size_no,size_desc TO size_no,size_desc
               
            OTHERWISE
               EXIT CASE
         END CASE 
         
    AFTER  FIELD  size_no
    #No.FUN-870117  --begin--
     IF NOT cl_null(size_no)  THEN 
      SELECT COUNT(*) INTO l_n FROM  ocq_file WHERE ocq01 = g_slc.slc09 AND ocq04 =size_no 
       IF l_n =0 THEN
         CALL cl_err('','ask-116',0)
			 	 NEXT  FIELD  size_no 
			 END  IF 
		 END IF
		 #No.FUN-870117 --end-- 	  
			 SELECT  ocq05 INTO size_desc
			 FROM  ocq_file
			 WHERE ocq01= g_slc.slc09
			 AND   ocq04= size_no
  			 
			 IF  cl_null(l_seq) then 
			 	 CALL cl_err('','ask-116',0)
			 	 NEXT  FIELD  size_no 
			 END  IF 
			 DISPLAY  size_desc TO  size_desc
 END INPUT
  if INT_FLAG then
  	 let INT_FLAG=0
  	 close window t004_s
  end if 
 
 #add='1'
 begin work 
   IF  mod_act='1' THEN 
     LET l_sql = "SELECT COUNT(*),MIN(t.a21) +1 from_num",
                 " FROM (SELECT slg03 a11,lag(slg03,1,0) over (ORDER BY slg03) a21 FROM slg_file) t",
                 " WHERE t.a11-t.a21>1"
     PREPARE t004_mod01 FROM l_sql
     EXECUTE t004_mod01 INTO l_n,l_seq
     
   
    IF l_n = 0 THEN    
 	   SELECT COALESCE(MAX(slg03),0)+1 INTO  l_seq
 	   FROM  slg_file
 	   WHERE slg01 = g_slc.slc01
 	     AND slg02 = g_slc.slc02 
    END IF       
 	   
 	  SELECT COUNT(*) INTO l_n FROM  slg_file 
 	    WHERE slg01 = g_slc.slc01 AND slg02 = g_slc.slc02
 	      AND slg04 = size_no
 	  IF l_n =0 THEN    
 	  #No.FUN-870117 --end--
	   IF NOT sqlca.sqlcode then
    		INSERT INTO slg_file ( slg01, slg02, slg03, slg04 )
    		VALUES (g_slc.slc01,g_slc.slc02,l_seq,size_no) 		
    		LET l_seq = l_seq + 1
 		 END  IF 
 		END IF   #No.FUN-870117 
 	END  IF 
 	#delete='2' a size
 	let l_size_no = size_no
 	if mod_act='2' then
 	  
   DELETE FROM sld_file WHERE sld001 = g_slc.slc01
                              AND sld002 = g_slc.slc02
                              AND sld008 = l_size_no
                              
 
   DELETE FROM slg_file WHERE slg01 = g_slc.slc01
                              AND slg02 = g_slc.slc02
                              AND slg04 = l_size_no
 	end if
 	if sqlca.sqlcode then
 		rollback work
 		close window t004_s
 		CALL cl_err('','ask-117',0)
 	else
 		commit work
 		close window t004_s
 		call t004_show()
 	end if
END FUNCTION
 
 
FUNCTION cl_d_s(p_dec)
DEFINE
     p_dec    LIKE type_file.num20_6,       
     l_ele    LIKE type_file.num10,             
     l_den    LIKE type_file.num10,              
     l_ret1,l_ret2,l_ret3    LIKE type_file.num10,
     l_k1     LIKE type_file.num10,
     l_k2     LIKE type_file.num10,
     i,l      LIKE type_file.num5,
     l_kkk    LIKE type_file.chr50
 
     IF p_dec = 0 THEN
        LET l_kkk = 0
     END IF
     LET l_ele = p_dec * 100000
     LET l_den = 100000
     LET l_ret1 = l_den
     LET l_ret2 = l_ele
     
 
 
     IF l_ele > l_den THEN
        LET l_ret3 = l_den
        WHILE (l_ele MOD l_den) <> 0 
           LET l_ret3 = l_den
           LET l_den = l_ele MOD l_den                              
           LET l_ele=l_ret3
           LET l_ret3 = l_den
        END WHILE
     ELSE
        LET l_ret3 = l_ele
        WHILE (l_den MOD l_ele) <> 0
           LET l_ret3 = l_ele
            LET l_ele = l_den MOD l_ele                  
           LET l_den=l_ret3
           LET l_ret3 = l_ele
        END WHILE
     END IF   
 
     LET l_ele = l_ret2/l_ret3
     LET l_den = l_ret1/l_ret3
     LET l_k1 = 0
     IF l_ele > l_den THEN
        LET l_k1 = l_ele/l_den
        LET l_k2 = l_ele MOD l_den
     END IF
     
     
     IF l_k1 = 0 THEN   
        LET l_kkk = l_ele ,'/',l_den
        IF l_ele = '0' THEN LET l_kkk = '0' END IF
     ELSE
        LET l_kkk = l_k1,',',l_k2,'/',l_den
        IF l_k2 = '0' THEN LET l_kkk = l_k1 END IF
     END IF
     FOR i = 1 TO LENGTH(l_kkk)-1
         IF l_kkk[i,i] = ' ' THEN
            FOR l = i TO LENGTH(l_kkk)-1
                LET l_kkk[l,l] = l_kkk[l+1,l+1]
                LET l_kkk[l+1,l+1] = ' '
            END FOR
            LET i = 0
         END IF
     END FOR
     LET l_kkk = l_kkk CLIPPED
     RETURN l_kkk
END FUNCTION 
 
FUNCTION cl_s_d(p_sco)
DEFINE p_sco  LIKE type_file.chr10,   
       l_d1   LIKE type_file.chr10,
       l_d2   LIKE type_file.chr10,
       l_d3   LIKE type_file.chr10,
       l_s1   LIKE type_file.num10,      
       l_s2   LIKE type_file.num10,
       l_s3   LIKE type_file.num10,
       l_c1   LIKE type_file.num20_6,   
       l_c2   LIKE type_file.num20_6,
       l_c3   LIKE type_file.num20_6,
       l_kkk  LIKE type_file.num20_6,
       i,l,k  LIKE type_file.num5,
       l_kk   LIKE type_file.num20_6,
       l_i    LIKE type_file.chr1,     
       l_str  STRING
 
DEFINE l_flag LIKE type_file.num5
 
   LET l_flag = 1
   IF p_sco[1,1] = '-' THEN
   	LET p_sco = p_sco[2,length(p_sco)]
   	LET l_flag = -1
   END IF
   IF p_sco[1,1] = '+' THEN
   	LET p_sco = p_sco[2,length(p_sco)]
   END IF
   
   LET l_i = 'Y'
   LET l_kk = p_sco
   
   LET l_str = p_sco
   IF l_str.getIndexOf(",",1) > 0 THEN
		IF l_str.getIndexOf("/",1) <= 0 THEN 
			LET l_i = 'N'
         CALL cl_err(p_sco,'ask-107',1)
         RETURN l_kkk,l_i
		END IF
	ELSE
		IF l_str.getIndexOf("/",1) > 0 THEN 
			LET p_sco = '0,',p_sco
		END IF
	END IF
		
   IF l_kk IS NOT NULL THEN
      RETURN l_kk,l_i
   END IF
	
   LET k = 1
   FOR i = 1 TO LENGTH(p_sco)
       IF p_sco[i,i] != '1' AND p_sco[i,i] !='2' AND p_sco[i,i] !='3'
           AND p_sco[i,i] !='4' AND p_sco[i,i] != '5' AND p_sco[i,i] !='6'
           AND p_sco[i,i] !='7' AND p_sco[i,i] !='8' AND p_sco[i,i] !='9'
           AND p_sco[i,i] !='0' AND p_sco[i,i] !=',' AND p_sco[i,i] !='/'
       THEN 
          LET l_i = 'N'
          CALL cl_err(p_sco,'ask-107',1)
          RETURN l_kkk,l_i
       END IF
       IF p_sco[i,i] = ',' THEN
          LET k = 2
          CONTINUE FOR
       ELSE
          IF p_sco[i,i] = '/' THEN
             LET k = 3
             CONTINUE FOR
          END IF
       END IF 
       CASE
         WHEN k = 1    
              LET l_d1 = l_d1,p_sco[i,i]
         WHEN k = 2
              LET l_d2 = l_d2,p_sco[i,i]
         WHEN k = 3
              LET l_d3 = l_d3,p_sco[i,i]
       END CASE      
   END FOR
   LET l_s1 = l_d1
   LET l_s2 = l_d2 
   LET l_s3 = l_d3
   LET l_c1 = l_d1
   LET l_c2 = l_d2
   LET l_c3 = l_d3
   IF cl_null(l_s1) THEN LET l_s1 = 0 END IF
   IF cl_null(l_s2) THEN LET l_s2 = 0 END IF
   IF cl_null(l_s3) THEN LET l_s3 = 0 END IF
   IF cl_null(l_c1) THEN LET l_c1 = 0 END IF
   IF cl_null(l_c2) THEN LET l_c2 = 0 END IF
   IF cl_null(l_c3) THEN LET l_c3 = 0 END IF
   IF l_s1 <> l_c1 OR l_s2 <> l_c2 OR l_s3 <> l_c3 OR l_s3 = 0 THEN
      LET l_i = 'N'
      CALL cl_err(p_sco,'ask-107',1)
      RETURN l_kkk,l_i
   END IF
   IF l_s2 = 0 THEN
   	  #LET l_kkk=l_s1/l_s3 2007-08-24
      LET l_kkk = l_s1
   ELSE
   	  #LET l_kkk=l_s1*(l_s2/l_s3) 2007-08-24
      LET l_kkk = l_s1+(l_s2/l_s3)
   END IF
   IF cl_null(l_kkk) THEN
      CALL cl_err(p_sco,'ask-107',1)
      LET l_i = 'N'
   END IF
   LET l_kkk = l_kkk * l_flag
   RETURN l_kkk,l_i
END FUNCTION
 
#No.FUN-870117 FUN-8B0009

