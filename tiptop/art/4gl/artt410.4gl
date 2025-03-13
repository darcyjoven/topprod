# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: artt410.4gl
# Descriptions...: 自動補貨建議單 
# Date & Author..: No.FUN-870100 09/09/21 By Cockroach
# Modify.........: No.FUN-9C0069 09/12/14 By bnlent mark or replace rucplant/ruclegal 
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/10 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No.TQC-AC0337 10/12/23 By huangrh  寫入欄位是否統購，採購中心，補貨單取消確認條件 對應的請購單確認碼為N
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 11/12/07 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-CC0057 12/12/18 By xumeimei INSERT INTO ruc_file 时ruc33=' '
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rua          RECORD LIKE rua_file.*,
       g_rua_t        RECORD LIKE rua_file.*,
       g_rua_o        RECORD LIKE rua_file.*,
 
       g_rua01_t      LIKE rua_file.rua01,
       g_rub          DYNAMIC ARRAY OF RECORD
           rub02      LIKE rub_file.rub02,
           rub03      LIKE rub_file.rub03,
           rub03_desc LIKE ima_file.ima02,   
           rub11      LIKE rub_file.rub11,
           rub11_desc LIKE pmc_file.pmc03,         
           rub04      LIKE rub_file.rub04,
           rub04_desc LIKE gfe_file.gfe02,
           rub05      LIKE rub_file.rub05,
           rub06      LIKE rub_file.rub06,
           rub07      LIKE rub_file.rub07,
           rub08      LIKE rub_file.rub08,
           rub09      LIKE rub_file.rub09,
           rub10      LIKE rub_file.rub10          
                      END RECORD,
       g_rub_t        RECORD
           rub02      LIKE rub_file.rub02,
           rub03      LIKE rub_file.rub03,
           rub03_desc LIKE ima_file.ima02,
           rub11      LIKE rub_file.rub11,
           rub11_desc LIKE pmc_file.pmc03,  
           rub04      LIKE rub_file.rub04,
           rub04_desc LIKE gfe_file.gfe02,
           rub05      LIKE rub_file.rub05,
           rub06      LIKE rub_file.rub06,
           rub07      LIKE rub_file.rub07,
           rub08      LIKE rub_file.rub08,
           rub09      LIKE rub_file.rub09,
           rub10      LIKE rub_file.rub10 
                      END RECORD,
       g_rub_o        RECORD 
           rub02      LIKE rub_file.rub02,
           rub03      LIKE rub_file.rub03,
           rub03_desc LIKE ima_file.ima02,
           rub11      LIKE rub_file.rub11,
           rub11_desc LIKE pmc_file.pmc03,  
           rub04      LIKE rub_file.rub04,
           rub04_desc LIKE gfe_file.gfe02,
           rub05      LIKE rub_file.rub05,
           rub06      LIKE rub_file.rub06,
           rub07      LIKE rub_file.rub07,
           rub08      LIKE rub_file.rub08,
           rub09      LIKE rub_file.rub09,
           rub10      LIKE rub_file.rub10 
                      END RECORD,
       g_sql,g_str    STRING,
       g_sql1         LIKE type_file.chr1000,
       g_wc           STRING,
       g_wc2          STRING,
       g_rec_b        LIKE type_file.num5,
       l_ac           LIKE type_file.num5
 
DEFINE g_void              LIKE type_file.chr1 
DEFINE g_approve           LIKE type_file.chr1 
DEFINE g_confirm           LIKE type_file.chr1
DEFINE p_row,p_col         LIKE type_file.num5   
DEFINE g_forupd_sql        STRING           
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_chr2              LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_dbs2              LIKE type_file.chr30
#DEFINE g_t1                LIKE lrk_file.lrkslip    #FUN-A70130  mark
DEFINE g_n                 LIKE type_file.num5
 
MAIN
   DEFINE p_row,p_col         LIKE type_file.num5
   
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
 
 
   CALL cl_used(g_prog,g_time,1)
      RETURNING g_time
 
   INITIALIZE g_rua.* TO NULL
 
 
   LET g_forupd_sql = "SELECT * FROM rua_file WHERE rua01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t410_cl CURSOR FROM g_forupd_sql
 
   LET p_row =5   LET p_col = 10
   OPEN WINDOW t410_w AT p_row,p_col WITH FORM "art/42f/artt410"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("artt410")  
   LET g_pdate = g_today  
   CALL cl_ui_init()
 
   LET g_action_choice=""
 
   CALL t410_menu()
   CLOSE WINDOW t410_w 
   CALL cl_used(g_prog,g_time,2) 
      RETURNING g_time
END MAIN
 
FUNCTION t410_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM 
   CALL g_rub.clear()
   
 
   INITIALIZE g_rua.* TO NULL      
   CONSTRUCT BY NAME g_wc ON rua01,rua02,rua03,rua04,rua05,rua06,
                             ruaconf,ruacond,ruaconu,ruaplant,ruauser,
                             ruagrup,ruamodu,ruadate,ruaacti,ruacrat,
                             ruaoriu,ruaorig 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(rua01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_rua01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rua01
                  NEXT FIELD rua01
               
               WHEN INFIELD(rua03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_rua03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rua03
                  NEXT FIELD rua03
   
               WHEN INFIELD(ruaconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_ruaconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruaconu
                  NEXT FIELD ruaconu
               WHEN INFIELD(ruaplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_azp"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO ruaplant                                                                             
                  NEXT FIELD ruaplant                  
              
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
         #  CALL cl_qbe_save()
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)        
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruauser', 'ruagrup')
 
 
   CONSTRUCT g_wc2 ON rub02,rub03,rub11,rub04,rub05,rub06,rub07,rub08,rub09,rub10
        FROM s_rub[1].rub02,s_rub[1].rub03,s_rub[1].rub11,s_rub[1].rub04,
             s_rub[1].rub05,s_rub[1].rub06,s_rub[1].rub07,s_rub[1].rub08,
             s_rub[1].rub09,s_rub[1].rub10
       
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
       
      ON ACTION controlp
         CASE
            WHEN INFIELD(rub03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_rub03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rub03
               NEXT FIELD rub03
            WHEN INFIELD(rub11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_rub11"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rub11
               NEXT FIELD rub11
            WHEN INFIELD(rub04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_rub04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rub04
               NEXT FIELD rub04               
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
 
 
   IF g_wc2 = " 1=1" THEN              
      LET g_sql = "SELECT rua01",
                  " FROM rua_file WHERE ", g_wc CLIPPED, 
                  " ORDER BY rua01"
   ELSE                              
      LET g_sql = "SELECT UNIQUE rua01",
                  "  FROM rua_file, rub_file ",
                  " WHERE rua01 = rub01", 
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rua01"
   END IF
 
   PREPARE t410_prepare FROM g_sql
   DECLARE t410_cs SCROLL CURSOR WITH HOLD FOR t410_prepare
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM rua_file ",
                " WHERE ",g_wc CLIPPED 
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT rua01) FROM rua_file,rub_file",
                " WHERE rua01 = rub01", 
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t410_precount FROM g_sql
   DECLARE t410_count CURSOR FOR t410_precount
END FUNCTION
 
FUNCTION t410_menu()
   WHILE TRUE
      CALL t410_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t410_q()
            END IF
 
       #  WHEN "modify"
       #     IF cl_chk_act_auth() THEN
       #     #      CALL t410_u()
       #     END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t410_r()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t410_x()
            END IF
 
 
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t410_b()
            ELSE
               LET g_action_choice=NULL
            END IF
         
 
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
                  CALL t410_y()
            END IF 
 
         WHEN "undo_confirm"      
            IF cl_chk_act_auth() THEN
                  CALL t410_z()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
           #    CALL t410_out()
            END IF
        
         WHEN "void"
            IF cl_chk_act_auth() THEN
                  CALL t410_v(1)
            END IF
         #FUN-D20039 ----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
                  CALL t410_v(2)
            END IF
         #FUN-D20039 ----------end
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rub),'','')
            END IF
        
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rua.rua01 IS NOT NULL THEN
                 LET g_doc.column1 = "rua01"
                 LET g_doc.value1 = g_rua.rua01
                 CALL cl_doc()
               END IF
         END IF
       END CASE
   END WHILE
END FUNCTION
 
FUNCTION t410_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rub TO s_rub.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION detail 
         LET g_action_choice="detail"
         LET l_ac=1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION first
         CALL t410_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t410_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL t410_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL t410_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL t410_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
  
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
 
      #FUN-D20039 -----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 -----------end     

      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
     
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t410_z()
DEFINE l_n       LIKE type_file.num5
DEFINE l_gen02   LIKE gen_file.gen02 
DEFINE l_pmk18 LIKE pmk_file.pmk18
 
   LET g_success = 'Y'
   IF cl_null(g_rua.rua01) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
   
    SELECT * INTO g_rua.* FROM rua_file
    WHERE rua01=g_rua.rua01
   
   IF g_rua.ruaacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_rua.ruaconf='X' THEN 
        CALL cl_err('','9024',0)
        RETURN
   END IF
   
   IF g_rua.ruaconf='N' THEN 
        CALL cl_err('','9025',0)
        RETURN
   END IF
 
   SELECT pmk18 INTO l_pmk18 FROM pmk_file WHERE pmk01 = g_rua.rua06
#   IF l_pmk18 = 'Y' THEN                  #TQC-AC0337
   IF l_pmk18 <> 'N' THEN                  #TQC-AC0337
      CALL cl_err(g_rua.rua06,'art-666',0) 
      RETURN 
   END IF 
      
   IF g_success = 'N' THEN RETURN END IF
   
   IF NOT cl_confirm('alm-008') THEN 
      RETURN
   END IF
 
 
   BEGIN WORK
   OPEN t410_cl USING g_rua.rua01  
   IF STATUS THEN 
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t410_cl  
      ROLLBACK WORK 
      RETURN 
   END IF
    
   FETCH t410_cl INTO g_rua.* 
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_rua.rua01,SQLCA.sqlcode,0)
      CLOSE t410_cl ROLLBACK WORK RETURN 
   END IF

#TQC-AC0337-------------begin-----------
   DELETE FROM pmk_file WHERE pmk01=g_rua.rua06
   IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,1)
      ROLLBACK WORK
      RETURN
   END IF
   DELETE FROM pml_file WHERE pml01=g_rua.rua06
   IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,1)
      ROLLBACK WORK
      RETURN
   END IF
#TQC-AC0337-------------end------------                                          

   UPDATE rua_file SET ruaconf='N', 
                      #CHI-D20015 Mark&Add Str
                      #ruacond=NULL,
                      #ruaconu=NULL,
                       ruacond=g_today,
                       ruaconu=g_user,
                      #CHI-D20015 Mark&Add End
                       rua06  =''
     WHERE rua01=g_rua.rua01
   IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
      CALL cl_err('',SQLCA.SQLCODE,1)
      ROLLBACK WORK                       #TQC-AC0337
      RETURN
   END IF

   COMMIT WORK
   
   SELECT * INTO g_rua.* FROM rua_file WHERE rua01=g_rua.rua01
   DISPLAY BY NAME g_rua.rua06   
   DISPLAY BY NAME g_rua.ruaconf                                                                                                    
   DISPLAY BY NAME g_rua.ruacond                                                                                                    
   DISPLAY BY NAME g_rua.ruaconu  
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rua.ruaconu                                                                                                  
   DISPLAY l_gen02 TO FORMONLY.ruaconu_desc                                                                                         
    #CKP                                                                                                                            
   IF g_rua.ruaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rua.ruaconf,"","","",g_chr,"")                                                                           
                                                                                                                                    
   CALL cl_flow_notify(g_rua.rua01,'V')   
 
 
END FUNCTION
 
 
 
 
FUNCTION t410_y()       
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
   IF cl_null(g_rua.rua01) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
   
#CHI-C30107 ------------- add ------------ begin
   IF g_rua.ruaacti='N' THEN       
        CALL cl_err('','alm-048',0)
        RETURN
   END IF

   IF g_rua.ruaconf='Y' THEN #眒机瞄
        CALL cl_err('','9023',0)
        RETURN
   END IF

   IF g_rua.ruaconf='X' THEN #眒釬煙
        CALL cl_err('','9024',0)
        RETURN
   END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF 
#CHI-C30107 ------------- add ------------ end
   SELECT * INTO g_rua.* FROM rua_file
    WHERE rua01=g_rua.rua01
      
   IF g_rua.ruaacti='N' THEN       #
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_rua.ruaconf='Y' THEN #眒机瞄
        CALL cl_err('','9023',0)
        RETURN
   END IF
   
   IF g_rua.ruaconf='X' THEN #眒釬煙
        CALL cl_err('','9024',0)
        RETURN
   END IF
 
 
 #  CALL s_showmsg_init()
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rub_file
    WHERE rub01=g_rua.rua01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t410_cl USING g_rua.rua01
   
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_rua.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rua.rua01,SQLCA.sqlcode,0)
      CLOSE t410_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE rua_file SET ruaconf='Y',
                       ruacond=g_today, 
                       ruaconu=g_user 
     WHERE rua01=g_rua.rua01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
   #為每個壓貨機構產生請購單
   CALL t410_buy()
   IF g_success = 'Y' THEN
      LET g_rua.ruaconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rua.rua01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rua.* FROM rua_file WHERE rua01=g_rua.rua01 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rua.ruaconu
   DISPLAY BY NAME g_rua.ruaconf                                                                                         
   DISPLAY BY NAME g_rua.ruacond                                                                                         
   DISPLAY BY NAME g_rua.ruaconu
   DISPLAY l_gen02 TO FORMONLY.ruaconu_desc
    #CKP
   IF g_rua.ruaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rua.ruaconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rua.rua01,'V')   
  # CALL t410_y1()
  # CALL t410_y2()
END FUNCTION
 
FUNCTION t410_buy()
DEFINE l_rubplant   LIKE rub_file.rubplant
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE l_rub     RECORD LIKE rub_file.*
DEFINE l_flag    LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_no      LIKE pmk_file.pmk01
DEFINE l_rty03   LIKE rty_file.rty03
DEFINE l_fac     LIKE type_file.num20_6
DEFINE l_flag1   LIKE type_file.chr1
DEFINE l_ima155  LIKE ima_file.ima155
DEFINE l_rtb02   LIKE rtb_file.rtb02
DEFINE l_rtb03   LIKE rtb_file.rtb03
DEFINE l_rtc02   LIKE rtc_file.rtc02
DEFINE l_rtc03   LIKE rtc_file.rtc03
DEFINE l_rtc04   LIKE rtc_file.rtc04
DEFINE l_msg     LIKE type_file.chr1000
DEFINE l_shop    RECORD LIKE rub_file.*
 
   LET g_sql = "SELECT DISTINCT rubplant FROM rub_file ",
               " WHERE rub01= '",g_rua.rua01,"'" #AND rubplant='",g_rua.ruaplant,"'"
   PREPARE pre_ruh FROM g_sql
   DECLARE ruh_curs CURSOR FOR pre_ruh
 
   FOREACH ruh_curs INTO l_rubplant
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rubplant IS NULL THEN CONTINUE FOREACH END IF
 
      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rubplant
      IF l_dbs IS NULL THEN
         CALL cl_err(l_rubplant,'art-516',1)
         LET g_success = 'N'
         RETURN
      END IF  
      LET l_dbs = s_dbstring(l_dbs CLIPPED)
      #產生請購單單頭檔
      CALL t410_inspmk(l_dbs,l_rubplant) RETURNING l_flag,l_no
      IF l_flag = 0 THEN
         LET g_success = 'N' 
         RETURN
      ELSE  
         LET g_rua.rua06=l_no
         UPDATE rua_file SET rua06= g_rua.rua06 
           WHERE rua01=g_rua.rua01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         DISPLAY BY NAME g_rua.rua06
                
      END IF
 
               
      LET g_sql = "SELECT * ",
                  " FROM rub_file",    
                  " WHERE rub01 ='",g_rua.rua01,"' ",
                  "   AND rubplant = '",g_rua.ruaplant,"'"  #,
            #      "   AND rub09 = '",l_rub09,"'"       
      PREPARE t400_pb1 FROM g_sql
      DECLARE rub_cs1 CURSOR FOR t400_pb1
      LET g_n = 1
      FOREACH rub_cs1 INTO l_rub.*
         IF SQLCA.sqlcode THEN
            LET g_success = 'N' 
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT ima155 INTO l_ima155 FROM ima_file WHERE ima01 = l_rub.rub03
         #該商品是否為組裝商品
         IF l_ima155 = 'Y' THEN
            LET g_sql = "SELECT rtb02,rtb03,rtc02,rtc03,rtc04 ",
                        " FROM rtb_file,rtc_file ",
                        " WHERE rtb01 = rtc01 AND rtb01 = '",l_rub.rub03,"'"
            PREPARE pre_rtb FROM g_sql
            DECLARE rtb_cs CURSOR FOR pre_rtb
            LET l_n = 0
            FOREACH rtb_cs INTO l_rtb02,l_rtb03,l_rtc02,l_rtc03,l_rtc04
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N' 
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET l_flag1 = NULL
               LET l_fac = NULL
               CALL s_umfchk(l_rub.rub03,l_rub.rub04,l_rtb02) RETURNING l_flag1,l_fac
               IF l_flag1 = 1 THEN
                  LET l_msg = l_rub.rub04 CLIPPED,'->',l_rtb02 CLIPPED
                  CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                  LET l_fac = NULL
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_shop.* = l_rub.*
               LET l_shop.rub03 = l_rtc02
               LET l_shop.rub05 = l_rub.rub05*l_fac*(l_rtc04/l_rtb03)
               LET l_shop.rub04 = l_rtc03
               #產生請購單單身
               CALL t410_inspml(l_no,l_shop.*,l_dbs,l_rubplant) RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N' 
                  RETURN
               END IF
              # SELECT rty03 INTO l_rty03 
              #    FROM rty_file WHERE rty01 = l_rubplant AND rty02 = l_shop.rub03
              # IF l_rty03 = '2' OR l_rty03 = '3' THEN
              #    #產生需求匯總表
              #    CALL t410_insruc(l_shop.*,l_no,l_rub09) RETURNING l_flag
              #    IF l_flag = 0 THEN
              #       LET g_success = 'N' 
              #       RETURN
              #    END IF
              # END IF
               LET l_n = l_n + 1
               LET g_n = g_n + 1
            END FOREACH
         END IF
         #該商品不是組裝商品，或是組裝商品但是沒有維護子項商品
         IF l_ima155 = 'N' OR l_n = 0 OR l_n IS NULL THEN
            #產生請購單單身
            CALL t410_inspml(l_no,l_rub.*,l_dbs,l_rubplant) RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N' 
               RETURN
            END IF
           # SELECT rty03 INTO l_rty03 
           #     FROM rty_file WHERE rty01 = l_rub09 AND rty02 = l_rub.rub03
           # IF l_rty03 = '2' OR l_rty03 = '3' THEN
           #    #產生需求匯總表
           #    CALL t410_insruc(l_rub.*,l_no,l_rubplant) RETURNING l_flag
           #    IF l_flag = 0 THEN
           #       LET g_success = 'N' 
           #       RETURN
           #    END IF
           # END IF
            LET g_n = g_n + 1
         END IF
      END FOREACH
   END FOREACH
END FUNCTION

FUNCTION t410_inspmk(p_dbs,p_org)
DEFINE l_pmk     RECORD LIKE pmk_file.*
DEFINE p_dbs     LIKE azp_file.azp03
DEFINE p_org     LIKE azp_file.azp01
DEFINE l_doc     LIKE rye_file.rye03
DEFINE li_result LIKE type_file.num5
 
   LET g_errno = ""
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_doc FROM rye_file WHERE rye01 = 'apm' 
   #    AND rye02 = '1' AND ryeacti = 'Y'
   #FUN-C90050 mark end------

   CALL s_get_defslip('apm','1',g_plant,'N') RETURNING l_doc    #FUN-C90050 add

   IF l_doc IS NULL THEN 
      CALL cl_err('','art-330',1)
      RETURN 0,''
   END IF
   CALL s_auto_assign_no("apm",l_doc,g_today,"1","pmk_file","pmk01",p_org,"","")
      RETURNING li_result,l_pmk.pmk01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN 0,''
   END IF
   
   LET l_pmk.pmk46 = '2'
   LET l_pmk.pmk02 = 'REG'
   LET l_pmk.pmk03 = 0
   LET l_pmk.pmk04 = g_today
   LET l_pmk.pmk48 = TIME(CURRENT)
   LET l_pmk.pmk18 = 'N' 
   LET l_pmk.pmkcond = ""
   LET l_pmk.pmkconu = ""
   LET l_pmk.pmk47 = g_plant
   LET l_pmk.pmkplant = p_org
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk22 = g_aza.aza17 #本幣幣別
   LET l_pmk.pmk42 = 1
   LET l_pmk.pmk45 = 'Y' 
   LET l_pmk.pmkmksg = 'N'
   LET l_pmk.pmk25 = '0'
   LET l_pmk.pmk30 = 'N' 
   LET l_pmk.pmkuser = g_user
   LET l_pmk.pmkoriu = g_user #FUN-980030
   LET l_pmk.pmkorig = g_grup #FUN-980030
  #LET g_data_plant = g_plant #FUN-980030  #TQC-A10128 MARK 
   LET l_pmk.pmkgrup = g_grup
   LET l_pmk.pmkacti = 'Y'  
   LET l_pmk.pmkcrat = g_today
   LET l_pmk.pmkcont = ''
 
   SELECT azn02,azn04 INTO l_pmk.pmk31,l_pmk.pmk32 FROM azn_file 
        WHERE azn01 = l_pmk.pmk04
   SELECT azw02 INTO l_pmk.pmklegal FROM azw_file WHERE azw01=p_org
   LET l_pmk.pmkprsw = 'Y'
   LET l_pmk.pmkprno = 0
   LET l_pmk.pmkdays = 0
   LET l_pmk.pmksseq = 0
   LET l_pmk.pmksmax = 0
   #LET g_sql = "INSERT INTO ",p_dbs,"pmk_file(pmk01,pmk46,pmk02,pmk03,pmk04,pmk48,pmk18,", #FUN-A50102
   LET g_sql = "INSERT INTO ",cl_get_target_table(p_org, 'pmk_file'),"(pmk01,pmk46,pmk02,pmk03,pmk04,pmk48,pmk18,", #FUN-A50102
               "pmk47,pmkplant,pmk12,pmk13,pmk22,pmk42,pmk45,pmkmksg,pmk25,pmk30,",
               "pmkuser,pmkgrup,pmkacti,pmkcrat,pmkcond,pmkconu,pmkcont, ",
               "pmk31,pmk32,pmkprsw,pmkprno,pmkdays,pmksseq,pmksmax,pmklegal,pmkoriu,pmkorig) ",  #FUN-A10036
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?)" #FUN-A10036
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102            
   PREPARE pre_inspmk FROM g_sql
   EXECUTE pre_inspmk USING l_pmk.pmk01,l_pmk.pmk46,l_pmk.pmk02,l_pmk.pmk03,l_pmk.pmk04,
                            l_pmk.pmk48,l_pmk.pmk18,l_pmk.pmk47,l_pmk.pmkplant,l_pmk.pmk12,
                            l_pmk.pmk13,l_pmk.pmk22,l_pmk.pmk42,l_pmk.pmk45,l_pmk.pmkmksg,
                            l_pmk.pmk25,l_pmk.pmk30,l_pmk.pmkuser,l_pmk.pmkgrup,l_pmk.pmkacti,
                            l_pmk.pmkcrat,l_pmk.pmkcond,l_pmk.pmkconu,l_pmk.pmkcont,
                            l_pmk.pmk31,l_pmk.pmk32,l_pmk.pmkprsw,l_pmk.pmkprno,l_pmk.pmkdays,
                            l_pmk.pmksseq,l_pmk.pmksmax,l_pmk.pmklegal,g_user,g_grup  #FUN-A10036
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","pmk_file",l_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
      RETURN 0,''
   END IF
 
   RETURN 1,l_pmk.pmk01
END FUNCTION
FUNCTION t410_inspml(p_no,p_rub,p_dbs,p_org)
DEFINE p_rub    RECORD LIKE rub_file.*
DEFINE p_dbs    LIKE azp_file.azp03
DEFINE p_org    LIKE azp_file.azp01
DEFINE l_pml    RECORD LIKE pml_file.*
DEFINE l_ima02  LIKE ima_file.ima02
DEFINE l_rty03  LIKE rty_file.rty03
DEFINE l_rty05  LIKE rty_file.rty05
DEFINE l_rty06  LIKE rty_file.rty06
DEFINE p_no     LIKE pmk_file.pmk01
DEFINE l_msg    LIKE type_file.chr1000
DEFINE l_ima25  LIKE ima_file.ima25
DEFINE l_fac    LIKE type_file.num20_6
DEFINE l_flag   LIKE type_file.num5
DEFINE l_rty12  LIKE rty_file.rty12             #TQC-AC0337
 
   SELECT ima02,ima25 INTO l_ima02,l_ima25 FROM ima_file WHERE ima01 = p_rub.rub03
   SELECT rty03,rty05,rty06,rty12 INTO l_rty03,l_rty05,l_rty06,l_rty12   #TQC-AC0337 add rty12
       FROM rty_file WHERE rty01 = p_org AND rty02 = p_rub.rub03
   IF SQLCA.SQLCODE = 100 THEN
      LET l_msg = p_org,"-->",p_rub.rub03
      CALL cl_err(p_org,'art-517',1)
      RETURN 0
   END IF
 
   LET l_pml.pml01 = p_no
   LET l_pml.pml02 = g_n
   LET l_pml.pml24 = g_rua.rua01
   LET l_pml.pml25 = p_rub.rub02
   LET l_pml.pml04 = p_rub.rub03
   LET l_pml.pml041 = l_ima02
   LET l_pml.pml07 = p_rub.rub04
   LET l_pml.pml48 = l_rty05        #rub11
   LET l_pml.pml49 = l_rty06
   LET l_pml.pml50 = l_rty03
   LET l_pml.pml190 = 'N'                #TQC-AC0337
   IF l_rty03 = '2' OR l_rty03='4' THEN  #TQC-AC0337 add l_rty03='4'
      LET l_pml.pml52 = l_pml.pml01
      LET l_pml.pml53 = l_pml.pml02
      LET l_pml.pml51 = p_org
      LET l_pml.pml190 = 'Y'             #TQC-AC0337
      LET l_pml.pml191 = l_rty12         #TQC-AC0337
   ELSE
      LET l_pml.pml52 = NULL
      LET l_pml.pml53 = NULL
      LET l_pml.pml51 = NULL
   END IF
   LET l_pml.pml06 = g_rua.rua05          # p_rub.rub08
   LET l_pml.pml54 = '1'
   LET l_pml.pml20 = p_rub.rub10
   LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)   #FUN-910088--add--
   LET l_pml.pml33 = g_today             #p_rub.rub06
   LET l_pml.pml34 = g_today             #p_rub.rub06
   LET l_pml.pml35 = g_today             #p_rub.rub06
   LET l_pml.pml55 = TIME(CURRENT)       #p_rub.rub07
#   LET l_pml.pml190 = 'N'               #TQC-AC0337
   LET l_pml.pml192 = 'N'
   LET l_pml.pml38 = 'Y'
   LET l_pml.pml11 = 'N'
   LET l_pml.pml56 = '1'
   LET l_pml.pml42 = '0'
   LET l_pml.pmlplant = p_org
   LET l_pml.pml16 = '0'
 
   LET l_pml.pml011 = 'REG'
   LET l_pml.pml08 = l_ima25
   CALL s_umfchk(l_pml.pml04,l_pml.pml07,l_ima25) RETURNING l_flag,l_fac
   LET l_pml.pml09 = l_fac
   CALL s_overate(l_pml.pml04) RETURNING l_pml.pml13
   LET l_pml.pml14 =g_sma.sma886[1,1]         #部份交貨
   LET l_pml.pml15 =g_sma.sma886[2,2]         #部份交貨
   LET l_pml.pml21 = 0
   LET l_pml.pml23 = 'Y'
   LET l_pml.pml30 = 0
   LET l_pml.pml32 = 0
   LET l_pml.pml44 = 0
   LET l_pml.pml67 = g_grup
   LET l_pml.pml86 = l_pml.pml07
   LET l_pml.pml87 = l_pml.pml20
   LET l_pml.pml88 = 0
   LET l_pml.pml88t = 0
   SELECT azw02 INTO l_pml.pmllegal FROM azw_file WHERE azw01=p_org
   #LET g_sql = "INSERT INTO ",p_dbs,"pml_file(pml01,pml02,pml24,pml25,pml04,", #FUN-A50102
   LET g_sql = "INSERT INTO ",cl_get_target_table(p_org, 'pml_file'),"(pml01,pml02,pml24,pml25,pml04,", #FUN-A50102
               "                              pml41,pml07,pml48,pml49,pml50,",
               "                              pml52,pml53,pml06,pml54,pml20,",
               "                              pml33,pml34,pml35,pml55,pml190,",
               "                              pml192,pml38,pml11,pml56,pml42,",
               "                              pmlplant,pml041,pml51,pml16,pml011,",
               "                              pml08,pml09,pml13,pml14,pml15,",
               "                              pml21,pml23,pml30,pml32,pml44,",
               "                              pml67,pml86,pml87,pml88,pml88t,pmllegal,pml191) ",  #TQC-AC0337 add pml191
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"                                    #TQC-AC0337 add pml191
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102            
   PREPARE pre_inspml FROM g_sql
   EXECUTE pre_inspml USING l_pml.pml01,l_pml.pml02,l_pml.pml24,l_pml.pml25,l_pml.pml04,
                            l_pml.pml41,l_pml.pml07,l_pml.pml48,l_pml.pml49,l_pml.pml50,
                            l_pml.pml52,l_pml.pml53,l_pml.pml06,l_pml.pml54,l_pml.pml20,
                            l_pml.pml33,l_pml.pml34,l_pml.pml35,l_pml.pml55,l_pml.pml190,
                            l_pml.pml192,l_pml.pml38,l_pml.pml11,l_pml.pml56,l_pml.pml42,
                            l_pml.pmlplant,l_pml.pml041,l_pml.pml51,l_pml.pml16,l_pml.pml011,
                            l_pml.pml08,l_pml.pml09,l_pml.pml13,l_pml.pml14,l_pml.pml15,
                            l_pml.pml21,l_pml.pml23,l_pml.pml30,l_pml.pml32,l_pml.pml44,
                            l_pml.pml67,l_pml.pml86,l_pml.pml87,l_pml.pml88,l_pml.pml88t,l_pml.pmllegal,l_pml.pml191 #TQC-AC0337 add pml191
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","pml_file",l_pml.pml01,"",SQLCA.sqlcode,"","",1)
      RETURN 0
   END IF
 
   RETURN 1
END FUNCTION
#產生需求匯總表
FUNCTION t410_insruc(p_rub,p_no,p_org)
DEFINE p_rub    RECORD LIKE rub_file.*
DEFINE p_no     LIKE pmk_file.pmk01
DEFINE p_org    LIKE azp_file.azp01
DEFINE p_shop   LIKE ima_file.ima01
DEFINE l_ruc    RECORD LIKE ruc_file.*
DEFINE l_rty03  LIKE rty_file.rty03
DEFINE l_rty04  LIKE rty_file.rty04
DEFINE l_rty05  LIKE rty_file.rty05
DEFINE l_rty06  LIKE rty_file.rty06
DEFINE l_ima25  LIKE ima_file.ima25
DEFINE l_ima02  LIKE ima_file.ima02
DEFINE l_fac    LIKE type_file.num20_6
DEFINE l_flag   LIKE type_file.num5
 
   SELECT ima02,ima25 INTO l_ima02,l_ima25 FROM ima_file WHERE ima01 = p_rub.rub03
 
   SELECT rty03,rty04,rty05,rty06 
     INTO l_rty03,l_rty04,l_rty05,l_rty06 
       FROM rty_file WHERE rty01 = p_org AND rty02 = p_rub.rub03
 
   LET l_ruc.ruc00 = '1'
   LET l_ruc.ruc01 = p_org
   LET l_ruc.ruc02 = p_no           #請購單單號
   LET l_ruc.ruc03 = g_n            #請購單項次
   LET l_ruc.ruc04 = p_rub.rub03
   LET l_ruc.ruc05 = g_today
   LET l_ruc.ruc06 = p_org
   LET l_ruc.ruc07 = '2'            #rub
   LET l_ruc.ruc08 = p_rub.rub01
   LET l_ruc.ruc09 = p_rub.rub02
   LET l_ruc.ruc10 = l_rty05
   LET l_ruc.ruc11 = l_rty06
   LET l_ruc.ruc12 = l_rty03
   LET l_ruc.ruc13 = l_ima25
   LET l_ruc.ruc14 = NULL
   LET l_ruc.ruc15 = l_ima02
   LET l_ruc.ruc16 = p_rub.rub04
   CALL s_umfchk(p_rub.rub03,p_rub.rub04,l_ima25) RETURNING l_flag,l_fac
   LET l_ruc.ruc17 = l_fac
   LET l_ruc.ruc18 = p_rub.rub05
   LET l_ruc.ruc19 = 0
   LET l_ruc.ruc20 = 0
   LET l_ruc.ruc21 = 0
   LET l_ruc.ruc22 = NULL
   IF l_rty03 = '2' THEN
      LET l_ruc.ruc24 = p_no
      LET l_ruc.ruc25 = g_n
      LET l_ruc.ruc23 = p_org
   ELSE
      LET l_ruc.ruc24 = NULL
      LET l_ruc.ruc25 = NULL
      LET l_ruc.ruc23 = NULL
   END IF
   LET l_ruc.ruc26 = l_rty04
   LET l_ruc.ruc27 = p_rub.rub06
   LET l_ruc.ruc28 = '1'
   #LET l_ruc.rucplant = p_org  #No.FUN-9C0069
   #SELECT azw02 INTO l_ruc.ruclegal FROM azw_file WHERE azw01=p_org#No.FUN-9C0069
   LET l_ruc.ruc29 = 'N'
   LET l_ruc.ruc31 = p_rub.rub07 #No.FUN-870007
   LET l_ruc.ruc33 = ' '         #FUN-CC0057 add
   INSERT INTO ruc_file VALUES(l_ruc.*)
   IF SQLCA.SQLCODE = 100 THEN
      CALL cl_err3("ins","ruc_file",l_ruc.ruc01,"",SQLCA.sqlcode,"","",1)
      RETURN 0
   END IF
  
   RETURN 1
END FUNCTION
FUNCTION t410_v(p_type)             #作廢/取消作廢
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废 
DEFINE  l_pmk18 LIKE pmk_file.pmk18
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rua.rua01 IS NULL OR g_rua.ruaplant IS NULL THEN
      CALL cl_err('','-400',0)
      RETURN 
   END IF
   
   SELECT * INTO g_rua.* FROM rua_file
    WHERE rua01=g_rua.rua01 AND ruaplant = g_rua.ruaplant
   
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rua.ruaconf='X' THEN RETURN END IF
    ELSE
       IF g_rua.ruaconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end   
   IF g_rua.ruaconf='Y' THEN CALL cl_err('','9023',0) RETURN END IF   
   IF g_rua.ruaacti='N' THEN CALL cl_err('','alm-004',0) RETURN END IF
  # IF g_rua.ruaconf='X' THEN CALL cl_err('','art-148',0) RETURN END IF   #FUN-D20039 mark
   SELECT pmk18 INTO l_pmk18 FROM pmk_file WHERE pmk01 = g_rua.rua06
   IF l_pmk18 = 'Y' THEN CALL cl_err(g_rua.rua06,'art-666',0) RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y' 
 
   OPEN t410_cl USING g_rua.rua01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_rua.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rua.rua01,SQLCA.sqlcode,0) 
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_rua.ruaconf) THEN
      LET g_chr = g_rua.ruaconf
      IF g_rua.ruaconf ='N' THEN
         LET g_rua.ruaconf='X'
      ELSE
         LET g_rua.ruaconf='N'
      END IF
      UPDATE rua_file SET
             ruaconf=g_rua.ruaconf,
             ruamodu=g_user,
             ruadate=g_today
       WHERE rua01=g_rua.rua01 AND ruaplant = g_rua.ruaplant
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","rua_file",g_rua.rua01,"","apm-266","","upd rua_file",1)
         LET g_success='N'
         LET g_rua.ruaconf = g_chr         
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      CLOSE t410_cl
      COMMIT WORK
      CALL cl_flow_notify(g_rua.rua01,'V')
      DISPLAY BY NAME g_rua.ruaconf
 
   ELSE
      LET g_rua.ruaconf= g_rua_t.ruaconf
      DISPLAY BY NAME g_rua.ruaconf
      ROLLBACK WORK
   END IF
 
   SELECT ruaconf,ruamodu,ruadate
   INTO g_rua.ruaconf,g_rua.ruamodu,g_rua.ruadate FROM rua_file
    WHERE rua01=g_rua.rua01 
 
    DISPLAY BY NAME g_rua.ruaconf,g_rua.ruamodu,g_rua.ruadate
    IF g_rua.ruaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_rua.ruaconf,"","","",g_chr,"")
    CALL cl_flow_notify(g_rua.rua01,'V')
END FUNCTION
 
FUNCTION t410_bp_refresh()
  DISPLAY ARRAY g_rub TO s_rub.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
 
FUNCTION t410_rub03()
    DEFINE l_imaacti LIKE ima_file.imaacti
 
   LET g_errno = " "
 
   SELECT ima02,imaacti
     INTO g_rub[l_ac].rub03_desc,l_imaacti
     FROM ima_file WHERE ima01 = g_rub[l_ac].rub03
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY BY NAME g_rub[l_ac].rub03_desc  
   END CASE
 
END FUNCTION
 
 
FUNCTION t410_rub11()
DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
   LET g_errno = " "
 
   SELECT pmc03,pmcacti
     INTO g_rub[l_ac].rub11_desc,l_pmcacti
     FROM pmc_file WHERE pmc01 = g_rub[l_ac].rub11
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = '100'
        WHEN l_pmcacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY BY NAME g_rub[l_ac].rub11_desc
   END CASE
 
END FUNCTION
 
FUNCTION t410_rub04()
DEFINE l_gfeacti LIKE gfe_file.gfeacti
 
   LET g_errno = " "
 
   SELECT gfe02,gfeacti
     INTO g_rub[l_ac].rub04_desc,l_gfeacti
     FROM gfe_file WHERE gfe01 = g_rub[l_ac].rub04
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = '100'
        WHEN l_gfeacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY BY NAME g_rub[l_ac].rub04_desc  
   END CASE
 
END FUNCTION
 
 
FUNCTION t410_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rub.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t410_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rua.* TO NULL
      RETURN
   END IF
 
   OPEN t410_cs                            
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rua.* TO NULL
   ELSE
      OPEN t410_count
      FETCH t410_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t410_fetch('F')
   END IF
END FUNCTION
 
FUNCTION t410_fetch(p_flag)
DEFINE         p_flag         LIKE type_file.chr1                 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t410_cs INTO g_rua.rua01
      WHEN 'P' FETCH PREVIOUS t410_cs INTO g_rua.rua01
      WHEN 'F' FETCH FIRST    t410_cs INTO g_rua.rua01
      WHEN 'L' FETCH LAST     t410_cs INTO g_rua.rua01
      WHEN '/'
         IF (NOT mi_no_ask) THEN    
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
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
          FETCH ABSOLUTE g_jump t410_cs INTO g_rua.rua01
          LET mi_no_ask = FALSE    
     END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rua.rua01,SQLCA.sqlcode,0)
      INITIALIZE g_rua.* TO NULL               
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
 
   SELECT * INTO g_rua.* FROM rua_file WHERE rua01 = g_rua.rua01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rua_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_rua.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rua.ruauser      
   LET g_data_group = g_rua.ruagrup      
   LET g_data_plant = g_rua.ruaplant   #TQC-A10128 ADD
   CALL t410_show()
END FUNCTION
 
FUNCTION t410_show()
DEFINE l_azp02     LIKE azp_file.azp02
DEFINE l_gen02     LIKE gen_file.gen02
DEFINE l_gen02_1   LIKE gen_file.gen02
   LET g_rua_t.* = g_rua.* 
   LET g_rua_o.* = g_rua.*
   DISPLAY BY NAME g_rua.rua01,g_rua.rua02,g_rua.rua03,g_rua.rua04,g_rua.rua05,
                   g_rua.rua06,g_rua.ruaconf,g_rua.ruacond,g_rua.ruaconu,
                   g_rua.ruaplant,g_rua.ruauser,g_rua.ruagrup,g_rua.ruamodu,
                   g_rua.ruadate,g_rua.ruaacti,g_rua.ruacrat,g_rua.ruaoriu,
                   g_rua.ruaorig
 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rua.rua03
   DISPLAY l_gen02 TO FORMONLY.rua03_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rua.ruaplant
   DISPLAY l_azp02 TO ruaplant_desc
   SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01=g_rua.ruaconu
   DISPLAY l_gen02_1 TO FORMONLY.ruaconu_desc
   IF g_rua.ruaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rua.ruaconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_rua.rua01,'V') 
 
   CALL t410_b_fill(g_wc2)
   CALL cl_show_fld_cont()  
END FUNCTION
 
FUNCTION t410_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rua.rua01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rua.* FROM rua_file
    WHERE rua01=g_rua.rua01
   
   IF g_rua.ruaconf='X' THEN
      CALL cl_err('','9024',0) 
      RETURN 
   END IF
   
   IF g_rua.ruaconf='Y' THEN
      CALL cl_err('','9023',0) 
      RETURN 
   END IF
    
 
   BEGIN WORK
 
   OPEN t410_cl USING g_rua.rua01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_rua.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rua.rua01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
   CALL t410_show()
   IF cl_exp(0,0,g_rua.ruaacti) THEN
      LET g_chr=g_rua.ruaacti
      IF g_rua.ruaacti='Y' THEN
         LET g_rua.ruaacti='N'
      ELSE
         LET g_rua.ruaacti='Y'
      END IF
 
      UPDATE rua_file SET ruaacti=g_rua.ruaacti,
                          ruamodu=g_user,
                          ruadate=g_today
       WHERE rua01=g_rua.rua01  AND ruaplant=g_rua.ruaplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rua_file",g_rua.rua01,"",SQLCA.sqlcode,"","",1)
         LET g_rua.ruaacti=g_chr
      END IF
   END IF
   CLOSE t410_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rua.rua01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT ruaacti,ruamodu,ruadate
     INTO g_rua.ruaacti,g_rua.ruamodu,g_rua.ruadate FROM rua_file
    WHERE rua01 = g_rua.rua01
   DISPLAY BY NAME g_rua.ruaacti,g_rua.ruamodu,g_rua.ruadate
 #  CALL t410_field_pic()
END FUNCTION
 
 
 
FUNCTION t410_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rua.rua01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rua.* FROM rua_file
    WHERE rua01=g_rua.rua01
   IF g_rua.ruaacti ='N' THEN    
      CALL cl_err(g_rua.rua01,'mfg1000',0)
      RETURN
   END IF
  
   IF g_rua.ruaconf ='Y' THEN    
      CALL cl_err(g_rua.rua01,'9023',0)
      RETURN
   END IF
 
   IF g_rua.ruaconf ='X' THEN    
      CALL cl_err(g_rua.rua01,'9024',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t410_cl USING g_rua.rua01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_rua.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rua.rua01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t410_show()
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rua01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rua.rua01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM rua_file WHERE rua01=g_rua.rua01
      DELETE FROM rub_file WHERE rub01=g_rua.rua01
      CLEAR FORM
      CALL g_rub.clear()
      OPEN t410_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t410_cs
         CLOSE t410_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t410_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t410_cs
         CLOSE t410_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t410_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t410_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE      
         CALL t410_fetch('/')
      END IF
   END IF
   CLOSE t410_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rua.rua01,'D')
END FUNCTION
 
 
 
FUNCTION t410_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  i1       LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rua.rua01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rua.* FROM rua_file
     WHERE rua01=g_rua.rua01
 
    IF g_rua.ruaacti ='N' THEN 
       CALL cl_err(g_rua.rua01,'mfg1000',0)
       RETURN
    END IF
 
    IF g_rua.ruaconf='Y' THEN            #已審核
       CALL cl_err(g_rua.rua01,'9003',0)
       RETURN
    END IF
 
    IF g_rua.ruaconf='X' THEN             #已作廢
       CALL cl_err(g_rua.rua01,'9024',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rub02,rub03,'',rub11,'',rub04,'',rub05,",
                       "       rub06,rub07,rub08,rub09,rub10",
                       "  FROM rub_file",
                       " WHERE rub01=? AND rub02=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t410_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
       LET l_allow_insert=FALSE
       LET l_allow_delete=FALSE
    INPUT ARRAY g_rub WITHOUT DEFAULTS FROM s_rub.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t410_cl USING g_rua.rua01
           IF STATUS THEN
              CALL cl_err("OPEN t410_cl:", STATUS, 1)
              CLOSE t410_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t410_cl INTO g_rua.* 
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rua.rua01,SQLCA.sqlcode,0) 
              CLOSE t410_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rub_t.* = g_rub[l_ac].*  #BACKUP
              LET g_rub_o.* = g_rub[l_ac].*  #BACKUP
              OPEN t410_bcl USING g_rua.rua01,g_rub_t.rub02
              IF STATUS THEN
                 CALL cl_err("OPEN t410_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t410_bcl INTO g_rub[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rub_t.rub02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t410_rub03()
                 CALL t410_rub11()
                 CALL t410_rub04()
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rub[l_ac].* TO NULL
           LET g_rub_t.* = g_rub[l_ac].* 
           LET g_rub_o.* = g_rub[l_ac].* 
 
           CALL t410_set_no_entry(p_cmd)
           CALL cl_show_fld_cont()
           NEXT FIELD rub02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rub_file(rub01,rub02,rub03,rub11,rub04,rub05,rub06,
                                rub07,rub08,rub09,rub10,rubplant,rublegal)
           VALUES(g_rua.rua01,g_rub[l_ac].rub02,g_rub[l_ac].rub03,g_rub[l_ac].rub11,
                  g_rub[l_ac].rub04,g_rub[l_ac].rub05,g_rub[l_ac].rub06,
                  g_rub[l_ac].rub07,g_rub[l_ac].rub08,g_rub[l_ac].rub09,
                  g_rub[l_ac].rub10,g_rua.ruaplant,   g_rua.rualegal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","rub_file",g_rua.rua01,g_rub[l_ac].rub02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
   
 
        AFTER FIELD rub10
           IF NOT cl_null(g_rub[l_ac].rub10) THEN
              IF g_rub[l_ac].rub10 < 0 THEN
                 CALL cl_err('','art-514',0)
                 NEXT FIELD rub10                
              END IF
           END IF
 
 
        BEFORE DELETE 
           DISPLAY "BEFORE DELETE"
           IF g_rub_t.rub02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rub_file
               WHERE rub01 = g_rua.rua01
                 AND rub02 = g_rub_t.rub02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rub_file",g_rua.rua01,g_rub_t.rub02,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rub[l_ac].* = g_rub_t.*
              CLOSE t410_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rub[l_ac].rub02,-263,1)
              LET g_rub[l_ac].* = g_rub_t.*
           ELSE
              UPDATE rub_file SET rub02=g_rub[l_ac].rub02,
                                  rub03=g_rub[l_ac].rub03,
                                  rub11=g_rub[l_ac].rub11,
                                  rub04=g_rub[l_ac].rub04,
                                  rub05=g_rub[l_ac].rub05,
                                  rub06=g_rub[l_ac].rub06,
                                  rub07=g_rub[l_ac].rub07,
                                  rub08=g_rub[l_ac].rub08,
                                  rub09=g_rub[l_ac].rub09,
                                  rub10=g_rub[l_ac].rub10
               WHERE rub01=g_rua.rua01
                 AND rub02=g_rub_t.rub02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rub_file",g_rua.rua01,g_rub_t.rub02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rub[l_ac].* = g_rub_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rub[l_ac].* = g_rub_t.*
              END IF
              CLOSE t410_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t410_bcl
           COMMIT WORK
        
        ON ACTION CONTROLO
           IF INFIELD(rub02) AND l_ac > 1 THEN
              LET g_rub[l_ac].* = g_rub[l_ac-1].*
              LET g_rub[l_ac].rub02 = g_rec_b + 1
              NEXT FIELD rub02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
     {   ON ACTION controlp
           CASE
             WHEN INFIELD(rub03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oaj2"
               LET g_qryparam.arg1 = g_aza.aza81
               LET g_qryparam.arg2 = g_rua.rua02
               LET g_qryparam.default1 = g_rub[l_ac].rub03
               CALL cl_create_qry() RETURNING g_rub[l_ac].rub03
               DISPLAY BY NAME g_rub[l_ac].rub03
               CALL t410_rub03('d')
               NEXT FIELD rub03
               OTHERWISE EXIT CASE
            END CASE }
 
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
 
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")
    END INPUT
 
       LET g_rua.ruamodu = g_user
       LET g_rua.ruadate = g_today
       UPDATE rua_file SET ruamodu = g_rua.ruamodu,ruadate = g_rua.ruadate
        WHERE rua01 = g_rua.rua01
       DISPLAY BY NAME g_rua.ruamodu,g_rua.ruadate
 
 
    CLOSE t410_bcl
    COMMIT WORK
    CALL t410_delall()
    
END FUNCTION
 
FUNCTION t410_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rub_file
    WHERE rub01 = g_rua.rua01
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rua_file WHERE rua01 = g_rua.rua01 
 
      CLEAR FORM
   END IF
END FUNCTION
 
 
 
FUNCTION t410_b_fill(p_wc2)
   DEFINE p_wc2   STRING
   LET g_sql = "SELECT rub02,rub03,'',rub11,'',rub04,'',rub05, ",
               "       rub06,rub07,rub08,rub09,rub10  ",
               " FROM rub_file",
               " WHERE rub01 ='",g_rua.rua01,"' "
  
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rub02 "
   DISPLAY g_sql
   PREPARE t410_pb FROM g_sql
   DECLARE rub_cs CURSOR FOR t410_pb
   CALL g_rub.clear()
   LET g_cnt = 1
   FOREACH rub_cs INTO g_rub[g_cnt].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       SELECT ima02 INTO g_rub[g_cnt].rub03_desc FROM ima_file
       WHERE ima01=g_rub[g_cnt].rub03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_rub[g_cnt].rub03,"",SQLCA.sqlcode,"","",0)
          LET g_rub[g_cnt].rub03 = NULL
       END IF
       
       SELECT pmc03 INTO g_rub[g_cnt].rub11_desc FROM pmc_file
       WHERE pmc01=g_rub[g_cnt].rub11
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","pmc_file",g_rub[g_cnt].rub11,"",SQLCA.sqlcode,"","",0)
          LET g_rub[g_cnt].rub11 = NULL
       END IF
       
       SELECT gfe02 INTO g_rub[g_cnt].rub04_desc FROM gfe_file
       WHERE gfe01=g_rub[g_cnt].rub04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","gfe_file",g_rub[g_cnt].rub04,"",SQLCA.sqlcode,"","",0)
          LET g_rub[g_cnt].rub04 = NULL
       END IF
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rub.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
{
FUNCTION t410_u()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_rua.rua01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rua.* FROM rua_file
    WHERE rua01 = g_rua.rua01
      
   IF g_rua.ruaacti ='N' THEN         
      CALL cl_err(g_rua.rua01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
      
   BEGIN WORK
   OPEN t410_cl USING g_rua.rua01
   IF STATUS THEN
      CALL cl_err("OPEN t410_cl:", STATUS, 1)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t410_cl INTO g_rua.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rua.rua01,SQLCA.sqlcode,0)
      CLOSE t410_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t410_show()
   WHILE TRUE
      LET g_rua01_t = g_rua.rua01
      LET g_rua_o.* = g_rua.*
      LET g_rua.ruamodu=g_user
      LET g_rua.ruadate=g_today
      CALL t410_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rua.*=g_rua_t.*
         CALL t410_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
   
 
      UPDATE rua_file SET rua_file.* = g_rua.*
       WHERE rua01 = g_rua.rua01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rua_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t410_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rua.rua01,'U')
   CALL t410_show()
   CALL t410_b_fill("1=1")
END FUNCTION
}
{
FUNCTION t410_i(p_cmd)
 DEFINE l_n         LIKE type_file.num5
 DEFINE l_input     LIKE type_file.chr1
 DEFINE p_cmd       LIKE type_file.chr1     
 DEFINE l_cnt       LIKE type_file.num5
 DEFINE l_azp02     LIKE azp_file.azp02
 DEFINE l_rub04     LIKE rub_file.rub04
 DEFINE li_result   LIKE type_file.num5
 DEFINE l_rub       DYNAMIC ARRAY OF RECORD
           rub02    LIKE rub_file.rub02,
           rub04    LIKE rub_file.rub04,
           rub04t   LIKE rub_file.rub04t
                    END RECORD
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rua.rua02,g_rua.rua04,g_rua.rua06,
                   g_rua.rua08,g_rua.rua19,g_rua.rua11,g_rua.rua12,g_rua.rua19,
                   g_rua.rua09,g_rua.rua10,g_rua.rua13,g_rua.rua14,g_rua.ruaconf,
                   g_rua.ruauser,g_rua.ruamodu,g_rua.ruagrup,g_rua.ruadate,
                   g_rua.ruaacti,g_rua.ruacrat,g_rua.ruaplant
 
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rua.ruaplant
   DISPLAY l_azp02 TO ruaplant_desc
   LET l_azp02 = ""
 
   CALL cl_set_head_visible("","YES")          
   INPUT BY NAME g_rua.rua01,g_rua.rua02,g_rua.rua04,
                 g_rua.rua06
                 WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t410_set_entry(p_cmd)
        CALL t410_set_no_entry(p_cmd)
        CALL t410_set_entry_rua04()
        IF p_cmd = 'u' THEN
           CALL cl_set_comp_entry("rua02",FALSE)
           IF g_rua.rua11 = '2' THEN
              CALL cl_set_comp_entry("rua04",FALSE)
           ELSE
              CALL cl_set_comp_entry("rua04",TRUE)
           END IF
        ELSE
           CALL cl_set_comp_entry("rua02",TRUE)
        END IF
        LET g_before_input_done = TRUE
        CALL t410_rua06(p_cmd)
        IF p_cmd ="a" THEN
           CALL cl_set_comp_entry("rua061",TRUE)
        END IF
        IF g_rua.rua05 = '2' THEN
           CALL cl_set_comp_entry("rua061",FALSE)
        END IF
        CALL cl_set_docno_format("rua01")
 
     AFTER FIELD rua01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_rua.rua01) THEN
            CALL s_check_no("alm",g_rua.rua01,g_rua01_t,'01',"rua_file","rua01","")
                 RETURNING li_result,g_rua.rua01
            IF (NOT li_result) THEN
               LET g_rua.rua01=g_rua_o.rua01
               NEXT FIELD rua01
            END IF
            DISPLAY BY NAME g_rua.rua01
         END IF 
 
      AFTER FIELD rua04
         IF g_rua.rua04 IS NOT NULL THEN
            CALL t410_rua04(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rua.rua04,g_errno,1)
               LET g_rua.rua04 = g_rua_o.rua04
               NEXT FIELD rua04
            ELSE
               LET g_rua.rua05 = '2'
               DISPLAY BY NAME g_rua.rua05
               CALL t410_set_entry_rua04()
            END IF            
         ELSE
            CALL t410_set_entry_rua04()
         END IF
 
      AFTER FIELD rua06
         IF g_rua.rua06 IS NOT NULL THEN
            CALL t410_rua06(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rua.rua06,g_errno,1)
               LET g_rua.rua06 = g_rua_o.rua06
               NEXT FIELD rua06
            END IF
         END IF     
 
 
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rua01)
              LET g_t1=s_get_doc_no(g_rua.rua01)
              LET g_qryparam.state = 'i' #FUN-980030
              LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
             # CALL q_lrk(FALSE,FALSE,g_t1,'01','ALM') RETURNING g_t1        #FUN-A70130  mark
             CALL q_oay(FALSE,FALSE,g_t1,'B9','ART') RETURNING g_t1        #FUN-A70130 add
              LET g_rua.rua01 = g_t1
              DISPLAY BY NAME g_rua.rua01
              NEXT FIELD rua01
 
           WHEN INFIELD(rua03)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_rto01"
              LET g_qryparam.default1 =g_rua.rua04
              CALL cl_create_qry() RETURNING g_rua.rua04
              DISPLAY BY NAME g_rua.rua04
              NEXT FIELD rua04
 
           WHEN INFIELD(ruaconu)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_occ91"
              LET g_qryparam.default1 =g_rua.ruaconu
              CALL cl_create_qry() RETURNING g_rua.ruaconu
              DISPLAY BY NAME g_rua.ruaconu
              NEXT FIELD ruaconu
 
           OTHERWISE EXIT CASE
        END CASE       
           
      ON ACTION CONTROLO                 
         IF INFIELD(rua01) THEN
            LET g_rua.* = g_rua_t.*
            CALL t410_show()
            NEXT FIELD rua01
         END IF
    
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
 
      ON ACTION help         
         CALL cl_show_help() 
    END INPUT
END FUNCTION
}
 
 
 
 
 
FUNCTION t410_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rub10",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t410_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("rub02,rub03,rub04,rub05,rub06,rub07,rub08,rub09",FALSE)
    END IF
END FUNCTION
#NO.FUN-870100 COCKROACH
 
