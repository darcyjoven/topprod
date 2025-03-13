# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: p_bi.4gl
# Descriptions...: TIPTOP 系統整合 V-Point Express 參數設定
# Date & Author..: 05/12/01 By Echo FUN-660048   
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/09/15 By ice 欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time改為g_time
# Modify.........: No.FUN-6B0004 06/11/08 By Echo 新增一欄位「Express 是否與 BI 整合」
# Modify.........: No.FUN-740207 07/05/03 By Echo 搭配 V-Point4 Express 版本功能調整
# Modify.........: No.FUN-840065 08/04/15 By kevin 增加 BI 銷售智慧的報表清單
# Modify.........: No.TQC-860017 08/06/06 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960052 09/10/12 by Echo TIPTOP & V-Point5 整合
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位 
# Modify.........: No:FUN-B50029 11/05/06 by Henry 選N:V-point3時不能勾選「Express&BI整合」 
# Modify.........: No:FUN-C20087 12/03/06 By Abby CROSS GP5.3追版以下單號----
# Modify.........: No:FUN-B70112 11/07/27 By Abby 新增CROSS平台整合
# Modify.........: No:FUN-BC0117 11/12/28 By Lilan CROSS自動化流程
# Modify.........: No:FUN-C10064 12/02/01 By Abby 與CROSS整合時，新增資料來源抓取aws_crosscfg的產品站台設定
# Modify.........: No:FUN-C20087 12/03/06 By Abby CROSS GP5.3追版以上單號----

DATABASE ds

 
GLOBALS "../../config/top.global"             
 
DEFINE
        g_gcf       RECORD LIKE gcf_file.*,
        g_gcf_t     RECORD LIKE gcf_file.*,
        g_gcf_o     RECORD LIKE gcf_file.*,
        g_gch       RECORD LIKE gch_file.*,
        g_gch_t     RECORD LIKE gch_file.*,
        g_gch_o     RECORD LIKE gch_file.*
DEFINE g_bgch  DYNAMIC ARRAY OF RECORD
         bgcf10  LIKE gcf_file.gcf10,                 #FUN-740207
         bgcf09  LIKE gcf_file.gcf09,                 #FUN-6B0004
         bgch01  LIKE gch_file.gch01,
         bgcf06  LIKE gcf_file.gcf06,
         bgch03  LIKE gch_file.gch03,
         bgch04  LIKE gch_file.gch04,
         bgch05  LIKE gch_file.gch05,
         bgch06  LIKE gch_file.gch06,
         bgch07  LIKE gch_file.gch07,
         bgch08  LIKE gch_file.gch08,
         bgch09  LIKE gch_file.gch09,
         bgch10  LIKE gch_file.gch10,
         bgcf07  LIKE gcf_file.gcf07,                 #No.FUN-960052
         bgch12  LIKE gch_file.gch12,                 #FUN-740207
         bgch13  LIKE gch_file.gch13,                 #FUN-740207
         bgch11  LIKE gch_file.gch11                  #FUN-740207
      END RECORD
DEFINE  g_cnt       LIKE type_file.num10             #FUN-680135
DEFINE  g_sql       STRING
DEFINE  g_before_input_done LIKE type_file.num5      #FUN-680135
DEFINE  g_msg,g_forupd_gch STRING
DEFINE  l_cnt       LIKE type_file.num10             #FUN-680135
DEFINE  l_gch_cnt   LIKE type_file.num10,            #FUN-680135 
        l_ac        LIKE type_file.num5              #目前處理的ARRAY CNT #FUN-680135
DEFINE  g_rec_b     LIKE type_file.num10             #FUN-740207 
DEFINE  g_war       RECORD LIKE war_file.*           #FUN-C10064 add
 
MAIN
#   DEFINE l_time         VARCHAR(8)                   #No.FUN-6A0096
   DEFINE p_row,p_col    LIKE type_file.num5         #FUN-680135
   DEFINE l_wap02   LIKE wap_file.wap02     #FUN-B70112
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET p_row = 4 LET p_col = 2
   OPEN WINDOW p_bi_w AT p_row,p_col WITH FORM "azz/42f/p_bi" 
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
  #FUN-B70112 add str-----
   SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'
   IF SQLCA.SQLCODE THEN
      CALL cl_err("wap_file", SQLCA.SQLCODE, 1)   
   END IF
   IF l_wap02 = "Y" THEN
      CALL cl_err(NULL,"aws-802", 1)           
   END IF
  #FUN-B70112 add end-----

   CALL p_bi_cross_visible()   #FUN-BC0117 add

   CALL p_biy_b_fill()   
 
   LET g_action_choice=""
   CALL p_bi_menu()
 
   CLOSE WINDOW p_bi_w
END MAIN
 
FUNCTION p_bi_maintain(p_cmd)
DEFINE p_cmd       LIKE type_file.chr10                    #FUN-680135
DEFINE l_cnt       LIKE type_file.num10                    #FUN-680135
DEFINE l_startint, l_endint   LIKE type_file.num5          #FUN-C10064 add
DEFINE l_startstr   STRING                                 #FUN-C10064 add
DEFINE l_wap02     LIKE wap_file.wap02                     #FUN-C10064 add
DEFINE l_length    LIKE type_file.num5                     #FUN-C10064 add
    #No.FUN-960052 -- start --
    IF p_cmd = 'modify' AND g_bgch[l_ac].bgch01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    #No.FUN-960052 -- end --
 
    BEGIN WORK
    INITIALIZE g_gcf.*,g_gch.*,g_gcf_t.*,g_gch_t.* TO NULL
    IF p_cmd = "modify" THEN
         LET g_gcf.gcf01 = g_bgch[l_ac].bgch01
         LET g_gcf.gcf06 = g_bgch[l_ac].bgcf06
         LET g_gcf.gcf02 = 'S'
         LET g_gcf.gcf03 = g_bgch[l_ac].bgch03
         LET g_gcf.gcf04 = g_bgch[l_ac].bgch04
         LET g_gcf.gcf09 = g_bgch[l_ac].bgcf09        #FUN-6B0004
         LET g_gcf.gcf10 = g_bgch[l_ac].bgcf10        #FUN-740207
         LET g_gcf.gcf05 = g_bgch[l_ac].bgch05
         LET g_gch.gch01 = g_gcf.gcf01  
         LET g_gch.gch02 = g_gcf.gcf02  
         LET g_gch.gch03 = g_gcf.gcf03  
         LET g_gch.gch04 = g_gcf.gcf04  
         LET g_gch.gch05 = g_gcf.gcf05  
         LET g_gch.gch06 = g_bgch[l_ac].bgch06  
         LET g_gch.gch07 = g_bgch[l_ac].bgch07  
         LET g_gch.gch08 = g_bgch[l_ac].bgch08  
         LET g_gch.gch09 = g_bgch[l_ac].bgch09  
         LET g_gch.gch10 = g_bgch[l_ac].bgch10  
         LET g_gcf.gcf07 = g_bgch[l_ac].bgcf07        #No.FUN-960052
         LET g_gch.gch11 = g_bgch[l_ac].bgch11        #FUN-740207
         LET g_gch.gch12 = g_bgch[l_ac].bgch12        #FUN-740207
         LET g_gch.gch13 = g_bgch[l_ac].bgch13        #FUN-740207
         DISPLAY g_gcf.gcf01 TO gcf01 
         DISPLAY g_gcf.gcf06 TO gcf06 
         DISPLAY g_gcf.gcf07 TO gcf07                 #No.FUN-960052
         DISPLAY g_gcf.gcf03 TO gcf03 
         DISPLAY g_gcf.gcf04 TO gcf04 
         DISPLAY g_gcf.gcf09 TO gcf09                  #FUN-6B0004
         DISPLAY g_gcf.gcf10 TO gcf10                  #FUN-740207
         DISPLAY g_gcf.gcf05 TO gcf05 
         DISPLAY g_gch.gch06 TO gch06 
         DISPLAY g_gch.gch07 TO gch07 
         DISPLAY g_gch.gch08 TO gch08 
         DISPLAY g_gch.gch09 TO gch09 
         DISPLAY g_gch.gch10 TO gch10 
         DISPLAY g_gch.gch11 TO gch11                  #FUN-740207 
         DISPLAY g_gch.gch12 TO gch12                  #FUN-740207 
         DISPLAY g_gch.gch13 TO gch13                  #FUN-740207 
    END IF    
    LET g_gcf_t.* = g_gcf.*
    LET g_gch_t.* = g_gch.*
 
    #FUN-740207
    INPUT BY NAME g_gcf.gcf10,g_gcf.gcf09,g_gcf.gcf01,g_gcf.gcf06,
                  g_gcf.gcf03, g_gcf.gcf04,g_gcf.gcf05,             #FUN-6B0004
                  g_gch.gch06,g_gch.gch07,g_gch.gch08,g_gch.gch09,
                  g_gch.gch10,g_gcf.gcf07,g_gch.gch11,g_gch.gch12,g_gch.gch13   ##No.FUN-960052
    #END FUN-740207
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
        BEFORE INPUT
           IF p_cmd = "insert" THEN
              LET g_gcf.gcf01 = ''      # 營運中心
              LET g_gcf.gcf02 = 'S'     # 標准站台
              LET g_gcf.gcf03 = ''      # 站台IP
              LET g_gcf.gcf07 = ''      # 站台 port       #No.FUN-960052
              LET g_gcf.gcf04 = 'wiasp' # 站台名稱
              CASE cl_db_get_database_type()
               WHEN "ORA"
                  LET g_gcf.gcf05 = '0'         # 資料倉庫類型Oracle
               WHEN "IFX"
                  LET g_gcf.gcf05 = '1'         # 資料倉庫類型SQL Server
              END CASE
              LET g_gcf.gcf06 = 'ds'
              #FUN-740207
              #No.FUN-960052 -- start --
              IF NOT cl_null(g_bgch[1].bgcf10) THEN
                 LET g_gcf.gcf10 = g_bgch[1].bgcf10
                 LET g_gcf.gcf09 = g_bgch[1].bgcf09
              ELSE
                 LET g_gcf.gcf10 = 'U'             # Express版本
                 LET g_gcf.gcf09 = 'N'             # 是否與BI整合      #FUN-6B0004
              END IF
              #No.FUN-960052 -- end --
 
              CALL p_bi_gcf05()
              #END FUN-740207
           END IF
           LET g_before_input_done = FALSE
           CALL bi_set_entry()
           CALL bi_set_no_entry()
           LET g_before_input_done = TRUE
 
           #FUN-740207
 
           IF (p_cmd = "insert" AND g_rec_b > 0) OR 
              (p_cmd = "modify" AND g_rec_b > 1)
           THEN
              CALL cl_set_comp_entry("gcf10",FALSE)
           ELSE
              CALL cl_set_comp_entry("gcf10",TRUE)
           END IF
 
           #No.FUN-960052
           CASE g_gcf.gcf10 
             WHEN 'N'  #V-Point3
                CALL cl_set_comp_visible("gcf06,group02,group04,gcf04,gcf09",TRUE) 
                CALL cl_set_comp_visible("gch11,gch12,gch13,gcf07",FALSE)
                LET g_gcf.gcf09 = "N"                   #FUN-B50029 Empty the checkbox
                CALL cl_set_comp_entry("gcf09",FALSE)   #FUN-B50029 If choose the "N:V-point3", disable the "Express&BI"(gch09) checkbox.
                
             WHEN 'Y'  #V-Point4
                CALL cl_set_comp_visible("gch11,gch12,gch13",TRUE)
                CALL cl_set_comp_visible("gcf06,group02,group04,gcf04,gcf07",FALSE)#FUN-840065
                CALL cl_set_comp_entry("gcf09",TRUE)    #FUN-B50029 If choose the other item, the "Express&BI"(gch09) checkbox would be enable.                
                
             WHEN 'U'  #V-Point5
                CALL cl_set_comp_visible("gch11,gch12,gch13,gcf07",TRUE)
                CALL cl_set_comp_visible("gcf06,group02,group04,gcf04",FALSE)#FUN-840065
                CALL cl_set_comp_entry("gcf09",TRUE)    #FUN-B50029 If choose the other item, the "Express&BI"(gch09) checkbox would be enable.
                
           END CASE
           #No.FUN-960052 -- start --
           #END FUN-740207
 
           CALL p_bi_cross_visible()   #FUN-BC0117 add
 
       AFTER FIELD gcf01 
           IF NOT cl_null(g_gcf.gcf01) THEN  
              IF g_gcf.gcf01 != g_gcf_t.gcf01 OR cl_null(g_gcf_t.gcf01) THEN
                 SELECT COUNT(*) INTO l_cnt 
                   FROM azp_file where azp01 = g_gcf.gcf01
                 IF l_cnt = 0 THEN 
                       CALL cl_err3("sel","azp_file",g_gcf.gcf01,"",SQLCA.sqlcode,"","select azp", 1)  #No.FUN-660081)   #No.FUN-660081
                       NEXT FIELD gcf01
                 END IF
              END IF
             #FUN-C10064 add str---
              SELECT wap02 INTO l_wap02 FROM wap_file
              IF l_wap02 = "Y" THEN  #與CROSS整合
                 SELECT COUNT(*) INTO l_cnt 
                   FROM war_file
                  WHERE war03='BI'
                 CASE 
                   WHEN l_cnt = 1    #只有標準站台
                        SELECT * INTO g_war.* 
                          FROM war_file
                         WHERE war03='BI' 
                             
                   WHEN l_cnt > 1    #有例外站台
                     SELECT COUNT(*) INTO l_cnt FROM war_file
                      WHERE war03='BI'
                        AND war02 = g_gcf.gcf01 
                     IF l_cnt > 0 THEN   #判斷例外站台是否為登入的營運中心
                        SELECT * INTO g_war.* 
                          FROM war_file
                         WHERE war03='BI'
                           AND war02 = g_gcf.gcf01          
                     ELSE
                        SELECT * INTO g_war.* 
                          FROM war_file
                         WHERE war03='BI' 
                           AND war02 = '*'       
           END IF
                     
                   OTHERWISE         #應為0,表示無此產品的站台
                     CALL cl_err("","aws-806",1)
                     EXIT INPUT
                 END CASE 
                 
                 LET g_gcf.gcf03 = g_war.war05                       #IP
                 LET l_startstr = g_war.war07
                 LET l_startint = l_startstr.getIndexOf(":",8)+1
                 LET l_endint = l_startstr.getIndexOf("/",8)-1
                 LET g_gcf.gcf07 = g_war.war07[l_startint,l_endint]  #PORT
                 CALL crosscfg_getlen(g_war.war07) RETURNING l_length
                 LET g_gch.gch11 = g_war.war07[1,l_length-5]         #SOAP
              END IF
             #FUN-C10064 add end---
           END IF
 
       ON CHANGE gcf05
           IF p_cmd = "insert" OR (g_gcf.gcf05 != g_gcf_t.gcf05) 
           THEN
              #FUN-740207
              CALL p_bi_gcf05()
              #END FUN-740207
           ELSE
              #FUN-740207
              IF g_gcf.gcf10 = 'N' AND g_gcf.gcf10 != g_gcf_t.gcf10 THEN
                 CALL p_bi_gcf05()
              ELSE
                 LET g_gch.gch06 = g_gch_t.gch06  
                 LET g_gch.gch07 = g_gch_t.gch07  
                 LET g_gch.gch08 = g_gch_t.gch08  
                 LET g_gch.gch09 = g_gch_t.gch09  
                 LET g_gch.gch10 = g_gch_t.gch10  
              END IF
              #END FUN-740207
           END IF
 
       #FUN-6B0004
       ON CHANGE gcf09
           IF g_gcf.gcf10 = 'N' THEN               #cl_set_comp_visible
              #FUN-740207
              CALL p_bi_gcf09()
              #END FUN-740207
            END IF
       #END FUN-6B0004
 
       #FUN-740207
       ON CHANGE gcf10
           #No.FUN-960052 -- start --
           CASE g_gcf.gcf10 
             WHEN 'N'
                CALL cl_set_comp_visible("gcf06,group02,group04,gcf04,gcf09",TRUE)
                CALL cl_set_comp_visible("gcf07,gch11,gch12,gch13",FALSE)
                LET g_gcf.gcf09 = "N"                   #FUN-B50029 Empty the checkbox
                CALL cl_set_comp_entry("gcf09",FALSE)   #FUN-B50029 If choose the "N:V-point3", disable the "Express&BI"(gch09) checkbox.                
                IF cl_null(g_gcf.gcf09) THEN
                   LET g_gcf.gcf09 = "N"
                END IF 
             WHEN 'Y'
                CALL cl_set_comp_visible("gch11,gch12,gch13",TRUE)
                CALL cl_set_comp_visible("gcf06,group02,group04,gcf04,gcf07",FALSE)#FUN-840065
                CALL cl_set_comp_entry("gcf09",TRUE)    #FUN-B50029 If choose the other item, the "Express&BI"(gch09) checkbox would be enable.
                
             WHEN 'U'
                CALL cl_set_comp_visible("gch11,gch12,gch13,gcf07",TRUE)
                CALL cl_set_comp_visible("gcf06,group02,group04,gcf04",FALSE)#FUN-840065
                CALL cl_set_comp_entry("gcf09",TRUE)    #FUN-B50029 If choose the other item, the "Express&BI"(gch09) checkbox would be enable.                
           END CASE
           #No.FUN-960052 -- end --
          #IF (p_cmd = 'modify' AND g_gcf_t.gcf10 = 'Y') OR
          #    p_cmd = 'insert'
          #THEN
           IF g_gcf.gcf10 != g_gcf_t.gcf10 OR g_gcf_t.gcf10 IS NULL THEN
              CALL p_bi_gcf05()
           END IF
          #END IF
       #END FUN-740207
 
           CALL p_bi_cross_visible()   #FUN-BC0117 add
 
       BEFORE FIELD gch07
          CALL bi_set_entry()
 
       AFTER FIELD gch07
          CALL bi_set_no_entry()
 
        ON ACTION controlp
           CASE WHEN INFIELD(gcf01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_gcf.gcf01
              CALL cl_create_qry() RETURNING g_gcf.gcf01
              DISPLAY BY NAME g_gcf.gcf01
              NEXT FIELD gcf01
           END CASE
 
        ON ACTION controlf                        # 欄位說明    #MOD-560086
           CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#TQC-860017 start
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
            CONTINUE INPUT
#TQC-860017 end
    END INPUT
    IF INT_FLAG THEN
       LET g_gcf.* = g_gcf_t.*
       LET g_gch.* = g_gch_t.*
       LET g_gch.gch01 = g_gcf_t.gcf01
       LET g_gch.gch02 = g_gcf_t.gcf02
       LET g_gch.gch03 = g_gcf_t.gcf03
       LET g_gch.gch04 = g_gcf_t.gcf04
       LET g_gch.gch05 = g_gcf_t.gcf05
       #No.FUN-9A0024--begin
       #DISPLAY BY NAME g_gcf.*
       DISPLAY BY NAME g_gcf.gcf10,g_gcf.gcf09,g_gcf.gcf01,g_gcf.gcf03,g_gcf.gcf07
       #DISPLAY BY NAME g_gcf.*,g_gch.*
       DISPLAY BY NAME g_gch.gch11,g_gch.gch12,g_gch.gch13
       #No.FUN-9A0024--end 
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    LET g_gch.gch01 = g_gcf.gcf01  # 所有營運中心
    LET g_gch.gch02 = g_gcf.gcf02  # 標准站台
    LET g_gch.gch03 = g_gcf.gcf03  # 站台IP
    LET g_gch.gch04 = g_gcf.gcf04  # 站台名稱
    LET g_gch.gch05 = g_gcf.gcf05  # 資料倉庫類型SQL Server
 
    #FUN-740207
    IF g_gcf.gcf10 = 'N' THEN
       LET g_gch.gch11 = ""
       LET g_gch.gch12 = ""
       LET g_gch.gch13 = ""
    ELSE
       LET g_gch.gch06 = "*"
       LET g_gch.gch07 = "*"
       LET g_gch.gch08 = "*"
       LET g_gch.gch09 = "*"
       LET g_gch.gch10 = "*"
    END IF
    #END FUN-740207
 
    IF p_cmd ="insert" THEN
        INSERT INTO gcf_file VALUES(g_gcf.*)
        IF SQLCA.sqlcode THEN  #No.FUN-660081
            #CALL cl_err(g_gcf.gcf01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gcf_file",g_gcf.gcf01,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
            ROLLBACK WORK
            RETURN
        END IF
        INSERT INTO gch_file VALUES(g_gch.*)
        IF SQLCA.sqlcode THEN  #No.FUN-660081
           CALL cl_err3("ins","gch_file",g_gch.gch01,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
           ROLLBACK WORK
           RETURN
        END IF
    ELSE
        UPDATE gcf_file SET gcf_file.* = g_gcf.*    # 更新DB
         WHERE gcf01 = g_gcf_t.gcf01
           AND gcf02 = g_gcf_t.gcf02
           AND gcf03 = g_gcf_t.gcf03 
           AND gcf04 = g_gcf_t.gcf04 
           AND gcf05 = g_gcf_t.gcf05 
        IF SQLCA.sqlcode THEN  #No.FUN-660081
           #CALL cl_err(g_gcf_t.gcf01,SQLCA.sqlcode,0)  #No.FUN-660081
           CALL cl_err3("upd","gcf_file",g_gcf_t.gcf01,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
           ROLLBACK WORK
           RETURN
        END IF
        UPDATE gch_file SET gch_file.* = g_gch.*    # 更新DB
         WHERE gch01 = g_gch_t.gch01 AND gch02 = g_gch_t.gch02
           AND gch03 = g_gch_t.gch03 AND gch04 = g_gch_t.gch04
           AND gch05 = g_gch_t.gch05 AND gch06 = g_gch_t.gch06
           AND gch07 = g_gch_t.gch07 AND gch08 = g_gch_t.gch08
           AND gch09 = g_gch_t.gch09 AND gch10 = g_gch_t.gch10
        IF SQLCA.sqlcode THEN  #No.FUN-660081
           #CALL cl_err(g_gch_t.gch01,SQLCA.sqlcode,0)
           CALL cl_err3("upd","gch_file",g_gch_t.gch01,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
           ROLLBACK WORK
           RETURN
        END IF
    END IF
    
    COMMIT WORK
    CALL p_biy_b_fill()
    CALL p_bi_relation() #FUN-840065
END FUNCTION
 
FUNCTION p_biy_b_fill()
 
    LET g_sql = "SELECT gcf10,gcf09,gch01,gcf06,gch03,gch04,gch05,gch06,gch07,", #FUN-740207
                "       gch08,gch09,gch10,gcf07,gch12,gch13,gch11 ",                   #FUN-6B0004  #FUN-740207 #No.FUN-960052
                "  FROM gch_file,gcf_file WHERE gch01 = gcf01 AND ",
                " gch02 = gcf02 AND gch03 = gcf03 AND gch04=gcf04 AND ",
                " gch05 = gcf05 "
 
    PREPARE p_bi_pp FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","gch_file","","",SQLCA.sqlcode,"","",1) 
       EXIT PROGRAM
    END IF
    DECLARE p_bi_cs2 CURSOR FOR p_bi_pp
    CALL g_bgch.clear()
    LET g_cnt=1
    FOREACH p_bi_cs2 INTO g_bgch[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","gch_file","","",SQLCA.sqlcode,"","",1) 
         EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
   END FOREACH
   CALL g_bgch.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1                             #FUN-740207
   
END FUNCTION
 
FUNCTION p_bi_menu()
 
      LET l_ac = 1
      
      WHILE TRUE
         CALL p_bi_bp()                  
         CASE g_action_choice
            WHEN "insert"                          # A.輸入
               IF cl_chk_act_auth() THEN
                 CALL p_bi_maintain("insert")
               END IF
        
           WHEN "modify" 
              IF cl_chk_act_auth() THEN
                 IF l_ac != 0 THEN
                    CALL p_bi_maintain("modify")
                 END IF
              END IF
         
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL p_bi_maintain("modify")
              END IF
 
           WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL p_bi_r()
              END IF
           WHEN "help" 
              CALL cl_show_help()
 
           WHEN "exit"
              EXIT WHILE
        
           WHEN "sqlserver"
              IF cl_chk_act_auth() THEN
                 #FUN-740207
                 #CASE g_gch.gch05 
                 #   WHEN '0' CALL cl_oraserver()
                 #   WHEN '1' CALL cl_sqlserver()
                 #END CASE
                 CALL p_bi_report_list()
                 #END FUN-740207
              END IF
              #CALL cl_err(g_msg,g_msg,1)
         
           WHEN "rep_relation"
              IF cl_chk_act_auth() THEN
                 IF g_gcf.gcf01 IS NOT NULL THEN
                    LET g_gcf_o.* = g_gcf.*
                    LET g_msg = "p_zbo '",g_gcf.gcf01 CLIPPED,"' '",
                                          g_gcf.gcf02 CLIPPED,"' '",
                                          g_gcf.gcf03 CLIPPED,"' '",
                                          g_gcf.gcf04 CLIPPED,"' '",
                                          g_gcf.gcf05 CLIPPED,"'"
                                          ," 'Y'" #FUN-840065
                                          
                    CALL cl_cmdrun_wait(g_msg)
                    LET g_msg = NULL
                    LET g_gcf.* = g_gcf_o.*
                 END IF
              END IF
           
           #FUN-840065 start 
           WHEN "bi_relation"  
              IF cl_chk_act_auth() THEN
              	 IF g_gcf.gcf01 IS NOT NULL THEN
                    LET g_gcf_o.* = g_gcf.*
                    LET g_msg = "p_zbo '",g_gcf.gcf01 CLIPPED,"' '",
                                          g_gcf.gcf02 CLIPPED,"' '",
                                          g_gcf.gcf03 CLIPPED,"' '",
                                          g_gcf.gcf04 CLIPPED,"' '",
                                          g_gcf.gcf05 CLIPPED,"'"
                                          ," 'N'"
                    DISPLAY g_msg
                    CALL cl_cmdrun_wait(g_msg)
                    LET g_msg = NULL
                    LET g_gcf.* = g_gcf_o.*
                 END IF              	
              END IF 
           #FUN-840065 end
             WHEN "auto_generate_menu" 
               IF cl_chk_act_auth() THEN
                   CALL aws_bicli_auto_menu(g_gcf.gcf09)      #FUN-840065   #FUN-740207
               END IF
         END CASE
      END WHILE
END FUNCTION
 
FUNCTION p_bi_bp()
 
  INITIALIZE g_gcf.*,g_gch.* TO NULL
  CALL cl_set_act_visible("accept,cancel", FALSE)  
  DISPLAY ARRAY g_bgch TO s_bgch.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,KEEP CURRENT ROW)   #FUN-740207
    BEFORE DISPLAY
          CALL fgl_set_arr_curr(l_ac)
          #FUN-740207
          #No.FUN-960052
          CASE 
            WHEN g_bgch[1].bgcf10 = 'N' AND g_rec_b > 0 
              CALL cl_set_comp_visible("gcf06,group02,group04,gcf04,gcf09,bgcf09,bgcf06,bgch04,bgch05,bgch06,bgch07,bgch08,bgch09,bgch10",TRUE)
              CALL cl_set_comp_visible("gch11,gch12,gch13,gcf07,bgcf07,bgch11,bgch12,bgch13",FALSE)
            WHEN g_bgch[1].bgcf10 = 'Y' AND g_rec_b > 0 
              CALL cl_set_comp_visible("gch11,gch12,gch13,gcf07,bgcf07,bgch11,bgch12,bgch13",TRUE)
              CALL cl_set_comp_visible("gcf06,group02,group04,gcf04,bgcf09,bgcf10,bgcf06,bgch04,bgch05,bgch06,bgch07,bgch08,bgch09,bgch10,gcf07,bgcf07",FALSE)
            OTHERWISE
              CALL cl_set_comp_visible("gch11,gch12,gch13,gcf07,bgcf07,bgch11,bgch12,bgch13",TRUE)
              CALL cl_set_comp_visible("gcf06,group02,group04,gcf04,bgcf09,bgcf10,bgcf06,bgch04,bgch05,bgch06,bgch07,bgch08,bgch09,bgch10",FALSE)
          END CASE
          #No.FUN-960052 -- start --
          #END FUN-740207
 
          CALL p_bi_cross_visible()   #FUN-BC0117 add

    BEFORE ROW
          LET l_ac = ARR_CURR()
          IF l_ac != 0 THEN
              CALL p_bi_default()
          END IF
 
    AFTER DISPLAY
        CONTINUE DISPLAY
 
    ON ACTION insert 
       LET g_action_choice="insert"
       EXIT DISPLAY
 
    ON ACTION modify 
       LET g_action_choice="modify"
       EXIT DISPLAY
 
    ON ACTION accept
       LET g_action_choice="modify"
       EXIT DISPLAY
       
    ON ACTION delete
       LET g_action_choice="delete"
       EXIT DISPLAY
 
    ON ACTION help  
       LET g_action_choice = "help"
       EXIT DISPLAY
 
    ON ACTION locale
       CALL cl_dynamic_locale()
 
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT DISPLAY
 
    ON ACTION cancel
       LET INT_FLAG=FALSE                 #MOD-570244     mars
       LET g_action_choice="exit"
       EXIT DISPLAY
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
 
    ON ACTION controlg      #MOD-4C0121
       CALL cl_cmdask()     #MOD-4C0121
 
    ON ACTION sqlserver
       LET g_action_choice="sqlserver"
       EXIT DISPLAY
 
    ON ACTION rep_relation
       LET g_action_choice="rep_relation"
       EXIT DISPLAY
 
    ON ACTION bi_relation
       LET g_action_choice="bi_relation"
       EXIT DISPLAY
       
    ON ACTION auto_generate_menu
       LET g_action_choice = "auto_generate_menu"
       EXIT DISPLAY
              
  END DISPLAY 
  CALL cl_set_act_visible("accept,cancel", TRUE)  
 	
END FUNCTION
 
FUNCTION p_bi_r()
 
      #No.FUN-960052 -- start --
      IF g_bgch[l_ac].bgch01 IS NULL THEN
         CALL cl_err('',-400,0)
         RETURN
      END IF
      #No.FUN-960052 -- end --
 
      IF cl_delete() THEN
          BEGIN WORK
           LET g_gcf.gcf01 = g_bgch[l_ac].bgch01
           LET g_gcf.gcf06 = g_bgch[l_ac].bgcf06
           LET g_gcf.gcf02 = 'S'
           LET g_gcf.gcf03 = g_bgch[l_ac].bgch03
           LET g_gcf.gcf04 = g_bgch[l_ac].bgch04
           LET g_gcf.gcf09 = g_bgch[l_ac].bgcf09             #FUN-6B0004
           LET g_gcf.gcf10 = g_bgch[l_ac].bgcf10             #FUN-740207
           LET g_gcf.gcf05 = g_bgch[l_ac].bgch05
           LET g_gch.gch01 = g_gcf.gcf01  
           LET g_gch.gch02 = g_gcf.gcf02  
           LET g_gch.gch03 = g_gcf.gcf03  
           LET g_gch.gch04 = g_gcf.gcf04  
           LET g_gch.gch05 = g_gcf.gcf05  
           LET g_gch.gch06 = g_bgch[l_ac].bgch06  
           LET g_gch.gch07 = g_bgch[l_ac].bgch07  
           LET g_gch.gch08 = g_bgch[l_ac].bgch08  
           LET g_gch.gch09 = g_bgch[l_ac].bgch09  
           LET g_gch.gch10 = g_bgch[l_ac].bgch10  
           LET g_gcf.gcf07 = g_bgch[l_ac].bgcf07             #No.FUN-960052
           LET g_gch.gch11 = g_bgch[l_ac].bgch11             #FUN-740207 
           LET g_gch.gch12 = g_bgch[l_ac].bgch12             #FUN-740207 
           LET g_gch.gch13 = g_bgch[l_ac].bgch13             #FUN-740207 
           DELETE FROM gcf_file 
            WHERE gcf01 = g_gcf.gcf01
              AND gcf02 = g_gcf.gcf02
              AND gcf03 = g_gcf.gcf03 
              AND gcf04 = g_gcf.gcf04 
              AND gcf05 = g_gcf.gcf05 
           IF SQLCA.sqlcode THEN  #No.FUN-660081
              #CALL cl_err(g_gcf_t.gcf01,SQLCA.sqlcode,0)  #No.FUN-660081
              CALL cl_err3("del","gcf_file",g_gcf.gcf01,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
              ROLLBACK WORK
              RETURN
           END IF
           DELETE FROM gch_file
            WHERE gch01 = g_gch.gch01 AND gch02 = g_gch.gch02
              AND gch03 = g_gch.gch03 AND gch04 = g_gch.gch04
              AND gch05 = g_gch.gch05 AND gch06 = g_gch.gch06
              AND gch07 = g_gch.gch07 AND gch08 = g_gch.gch08
              AND gch09 = g_gch.gch09 AND gch10 = g_gch.gch10
           IF SQLCA.sqlcode THEN  #No.FUN-660081
              #CALL cl_err(g_gch_t.gch01,SQLCA.sqlcode,0)
              CALL cl_err3("del","gch_file",g_gch.gch01,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
              ROLLBACK WORK
              RETURN
           END IF
           COMMIT WORK
           CLEAR FORM
           CALL p_biy_b_fill()
      END IF
END FUNCTION
FUNCTION bi_set_entry()
 
   IF INFIELD(gch07) OR (NOT g_before_input_done) THEN
      IF g_gch.gch05 = '1' THEN 
         CALL cl_set_comp_entry("gch07",TRUE)
      END IF
   END IF
END FUNCTION
 
FUNCTION bi_set_no_entry()
   IF INFIELD(gch07) OR (NOT g_before_input_done) THEN
      IF g_gch.gch05 = '0' THEN 
         CALL cl_set_comp_entry("gch07",FALSE)
      END IF
   END IF
END FUNCTION
 
FUNCTION initRpsDB(pcb_RpsDB)
   DEFINE pcb_RpsDB  ui.ComboBox
   DEFINE li_i       LIKE type_file.num10                     #FUN-680135
   DEFINE li_cnt     LIKE type_file.chr1                      #FUN-680135
 
   CALL pcb_RpsDB.clear()
   FOR li_i = 0 TO 9
       IF li_i = 0 THEN 
          CALL pcb_RpsDB.addItem('ds', 'ds')
       ELSE
          LET li_cnt = li_i
          CALL pcb_RpsDB.addItem('ds'||li_cnt,'ds'||li_cnt)
       END IF
   END FOR
 
END FUNCTION
 
#FUN-740207
#FUNCTION aws_bicli_auto_menu()
#DEFINE l_cnt    LIKE type_file.num10                          #FUN-680135 
#DEFINE l_zz01   LIKE zz_file.zz01
#
#  BEGIN WORK
#
#  SELECT COUNT(*) INTO l_cnt FROM gci_file 
#  IF l_cnt = 0 THEN
#        RETURN
#  END IF
#
#  SELECT COUNT(*) INTO l_cnt FROM zm_file where zm01='mbo' 
#  IF l_cnt = 0 THEN
#      IF NOT cl_confirm("azz-131") THEN
#             RETURN
#      END IF   
#  ELSE
#      IF NOT cl_confirm("azz-132") THEN
#             RETURN
#      END IF   
#      DELETE FROM zm_file where zm01='mbo'
#      IF SQLCA.sqlcode THEN  #No.FUN-660081
#          CALL cl_err3("del","zm_file","mbo",'',SQLCA.sqlcode,"","",1) #No.FUN-660081
#          ROLLBACK WORK
#          RETURN
#      END IF
#  END IF
#
#  SELECT COUNT(*) INTO l_cnt FROM zm_file where zm01='menu' AND zm04='mbo'
#  IF l_cnt = 0 THEN
#     SELECT MAX(zm03) INTO l_cnt FROM zm_file where zm01='menu'
#     IF l_cnt IS NULL THEN
#         LET l_cnt = 1
#     END IF
#     LET l_cnt = l_cnt + 1
#     INSERT INTO zm_file VALUES('menu',l_cnt,'mbo')
#     IF SQLCA.sqlcode THEN  #No.FUN-660081
#         CALL cl_err3("ins","zm_file",'mbo','',SQLCA.sqlcode,"","",1) #No.FUN-660081
#         ROLLBACK WORK
#         RETURN
#     END IF
#  END IF 
#  LET l_cnt = 0
#  LET g_sql = "SELECT zz01 FROM zz_file where zz01 like 'bo%'"
#  PREPARE p_bi_menu FROM g_sql
#  IF SQLCA.sqlcode THEN
#     CALL cl_err3('sel','zz_file','','',SQLCA.sqlcode,'','',1)
#     EXIT PROGRAM
#  END IF
#  DECLARE p_bi_menu_cs CURSOR FOR p_bi_menu
#  FOREACH p_bi_menu_cs INTO l_zz01,l_gaz03
#    IF SQLCA.sqlcode THEN
#       CALL cl_err3('sel','zz_file','','',SQLCA.sqlcode,'','',1) 
#       EXIT FOREACH
#    END IF
#    LET l_cnt=l_cnt+1
#    INSERT INTO zm_file VALUES('mbo',l_cnt,l_zz01)
#    IF SQLCA.sqlcode THEN  #No.FUN-660081
#        CALL cl_err3("ins","zm_file",l_zz01,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
#        ROLLBACK WORK
#        RETURN
#    END IF
#  END FOREACH
#  COMMIT WORK
#  CALL cl_ora_redo_menu()              #重新產生menu
#
#END FUNCTION
#END FUN-740207
 
FUNCTION p_bi_default()
 
         LET g_gcf.gcf01 = g_bgch[l_ac].bgch01
         LET g_gcf.gcf06 = g_bgch[l_ac].bgcf06
         LET g_gcf.gcf02 = 'S'
         LET g_gcf.gcf03 = g_bgch[l_ac].bgch03
         LET g_gcf.gcf04 = g_bgch[l_ac].bgch04
         LET g_gcf.gcf09 = g_bgch[l_ac].bgcf09              #FUN-6B0004
         LET g_gcf.gcf05 = g_bgch[l_ac].bgch05
         LET g_gch.gch01 = g_gcf.gcf01  
         LET g_gch.gch02 = g_gcf.gcf02  
         LET g_gch.gch03 = g_gcf.gcf03  
         LET g_gch.gch04 = g_gcf.gcf04  
         LET g_gch.gch05 = g_gcf.gcf05  
         LET g_gch.gch06 = g_bgch[l_ac].bgch06  
         LET g_gch.gch07 = g_bgch[l_ac].bgch07  
         LET g_gch.gch08 = g_bgch[l_ac].bgch08  
         LET g_gch.gch09 = g_bgch[l_ac].bgch09  
         LET g_gch.gch10 = g_bgch[l_ac].bgch10  
 
         #FUN-740207
         LET g_gcf.gcf10 = g_bgch[l_ac].bgcf10              
         LET g_gcf.gcf07 = g_bgch[l_ac].bgcf07              #No.FUN-960052
         LET g_gch.gch11 = g_bgch[l_ac].bgch11              
         LET g_gch.gch12 = g_bgch[l_ac].bgch12              
         LET g_gch.gch13 = g_bgch[l_ac].bgch13              
         DISPLAY g_gcf.gcf10 TO gcf10 
         DISPLAY g_gch.gch11 TO gch11 
         DISPLAY g_gch.gch12 TO gch12 
         DISPLAY g_gch.gch13 TO gch13 
         #END FUN-740207
 
         DISPLAY g_gcf.gcf01 TO gcf01 
         DISPLAY g_gcf.gcf06 TO gcf06 
         DISPLAY g_gcf.gcf03 TO gcf03 
         DISPLAY g_gcf.gcf04 TO gcf04 
         DISPLAY g_gcf.gcf07 TO gcf07               #No.FUN-960052
         DISPLAY g_gcf.gcf09 TO gcf09               ##FUN-6B0004
         DISPLAY g_gcf.gcf05 TO gcf05 
         DISPLAY g_gch.gch06 TO gch06 
         DISPLAY g_gch.gch07 TO gch07 
         DISPLAY g_gch.gch08 TO gch08 
         DISPLAY g_gch.gch09 TO gch09 
         DISPLAY g_gch.gch10 TO gch10 
         CALL p_bi_relation() #FUN-840065
END FUNCTION
 
#FUN-740207
FUNCTION p_bi_gcf05()
 
    IF g_gcf.gcf10 = 'N' THEN
       IF g_gcf.gcf05 = '1' THEN            # 資料倉庫類型為SQL 
          LET g_gch.gch06 = ''              # SQL Server IP地址
          LET g_gch.gch07 = '1433'          # SQL Server端口 
       END IF
       IF g_gcf.gcf05 = '0' THEN      # 資料倉庫類型為ORA
          LET g_gch.gch06 = ''           # Oracle Server IP地址
          LET g_gch.gch07 = '1521'       #
          LET g_gch.gch08 = FGL_GETENV("ORACLE_SID")
       END IF
       CALL p_bi_gcf09()
    ELSE
       LET g_gch.gch12 = 'administrator' #系統帳號預設為: administrator
       LET g_gch.gch13 = ''              #系統密碼為設為空
    END IF
 
END FUNCTION
 
FUNCTION p_bi_gcf09()
    IF g_gcf.gcf09 = 'N' THEN
       IF g_gcf.gcf05 = '1' THEN            # 資料倉庫類型為SQL 
          LET g_gch.gch08 = 'trep_rps'      # 資料倉庫名稱
       END IF
       LET g_gch.gch09 = 'trep_rps'         # 資料倉庫使用者
       LET g_gch.gch10 = 'trep_rps'         # 資料倉庫使用者密碼       
    ELSE
       IF g_gcf.gcf05 = '1' THEN            # 資料倉庫類型為SQL 
          LET g_gch.gch08 = 'tebi_rps'      # 資料倉庫名稱
       END IF
       LET g_gch.gch09 = 'tebi_rps'         # 資料倉庫使用者
       LET g_gch.gch10 = 'tebi_rps'         # 資料倉庫使用者密碼       
    END IF 
END FUNCTION
 
#FUN-840065 start
FUNCTION p_bi_relation()
    IF g_gcf.gcf09 = 'N' OR cl_null(g_gcf.gcf09) THEN
    	 CALL cl_set_act_visible("bi_relation", FALSE) 
    ELSE
    	 CALL cl_set_act_visible("bi_relation", TRUE) 
    END IF
END FUNCTION
#FUN-840065 end
 
FUNCTION p_bi_report_list()
  DEFINE l_gch    RECORD LIKE gch_file.* , #存取用戶設定SQL Server連線參數
         l_gcf    RECORD LIKE gcf_file.*,  #匯入Tiptop工廠與Express對應DB之關聯
         l_aza57  LIKE aza_file.aza57      # aoos010 設定系統是否串接Express系統
  DEFINE l_cnt    LIKE type_file.num10
 
    # 判斷系統參數是否允許使用Express
    SELECT aza57 INTO l_aza57 FROM aza_file
  
    IF l_aza57 MATCHES "[Yy]" THEN
       #No.FUN-960052 -- start --
       SELECT * INTO l_gcf.* FROM gcf_file 
        WHERE gcf01 = g_plant AND gcf02 = 'S' AND gcf06='ds'
       IF cl_null(l_gcf.gcf06) THEN
          # 需設定 對應 DB關聯 gcf06
          SELECT * INTO l_gcf.* FROM gcf_file WHERE gcf02 = 'S' AND gcf06='ds'
          IF cl_null(l_gcf.gcf06) THEN
             SELECT unique * INTO l_gcf.* FROM gcf_file WHERE gcf02 = 'S'
             IF cl_null(l_gcf.gcf06) THEN
                #CALL cl_err('','No DB Relation Between Tiptop & Express',1)
                CALL cl_err('','azz-133',1)
                RETURN
             END IF
          END IF
       END IF
       #No.FUN-960052 -- end --
  
       SELECT COUNT(*) INTO l_cnt FROM gch_file
       WHERE gch01 = l_gcf.gcf01 AND gch02=l_gcf.gcf02 AND gch03= l_gcf.gcf03
         AND gch04 = l_gcf.gcf04 AND gch05=l_gcf.gcf05
       IF l_cnt = 0 THEN
          # 若參數未設定，則直接返回
          #CALL cl_err('','SQL Server Parameter Error!',1)
          CALL cl_err('','azz-133',1)
          RETURN
       END IF
  
  
       SELECT * INTO l_gch.* FROM gch_file
       WHERE gch01 = l_gcf.gcf01 AND gch02=l_gcf.gcf02 AND gch03= l_gcf.gcf03
         AND gch04 = l_gcf.gcf04 AND gch05=l_gcf.gcf05
       IF cl_null(l_gch.gch06) OR cl_null(l_gch.gch07) OR
          cl_null(l_gch.gch08) OR cl_null(l_gch.gch09) OR
          cl_null(l_gch.gch10) THEN
          # 若SQL Server連線參數未設定，則錯誤返回
          #CALL cl_err('','SQL Server Parameter Error!',1)
          CALL cl_err('','azz-133',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','lib-351',1)
       RETURN
    END IF
 
    IF l_gcf.gcf10 = 'N' THEN
       CASE g_gch.gch05
          WHEN '0' CALL cl_oraserver(l_gcf.*,l_gch.*)
          WHEN '1' CALL cl_sqlserver(l_gcf.*,l_gch.*)
       END CASE
    ELSE
       CALL aws_bicli(l_gcf.*,l_gch.*)
    END IF
 
END FUNCTION
#END FUN-740207


#FUN-BC0117 add str---------
FUNCTION p_bi_cross_visible()
  DEFINE l_wap02   LIKE wap_file.wap02


    SELECT wap02 INTO l_wap02 FROM wap_file WHERE wap01 = '0'
    IF SQLCA.SQLCODE THEN
       CALL cl_err("wap_file", SQLCA.SQLCODE, 1)
    END IF
    IF l_wap02 = "Y" THEN
       CALL cl_set_comp_entry('gcf03',FALSE)                   #欄位不可輸入  #FUN-C10064 add
      #CALL cl_set_comp_visible('gcf03,gcf07,gch11',FALSE)     #單頭欄位      #FUN-C10064 mark
       CALL cl_set_comp_visible('gcf07,gch11',FALSE)           #單頭欄位      #FUN-C10064 add
       CALL cl_set_comp_visible('bgcf03,bgcf07,bgch11',FALSE)  #單身欄位
    END IF
END FUNCTION
#FUN-BC0117 add end---------
#FUN-C20087
