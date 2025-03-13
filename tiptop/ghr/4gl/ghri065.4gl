# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri065.4gl
# Descriptions...: 考勤统计作业
# Date & Author..: 13/07/31 By Exia
# modify.........: NO.130910 13/09/10 By wangxh 程序运行后显示第一个单身所以结果

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_hrcj          DYNAMIC ARRAY OF RECORD
           hrcj01   LIKE hrcj_file.hrcj01,
           hrcj02   LIKE hrcj_file.hrcj02,
           hraa02   LIKE hraa_file.hraa02,
           hrcj03   LIKE hrcj_file.hrcj03,
           hrbl04   LIKE hrbl_file.hrbl04,
           hrbl05   LIKE hrbl_file.hrbl05,
           hrcj04   LIKE hrcj_file.hrcj04,
           hrcjconf LIKE hrcj_file.hrcjconf,
           hrbl08   LIKE hrbl_file.hrbl08,
           hrcj05   LIKE hrcj_file.hrcj05
                       END RECORD,
       g_hrcj_t        RECORD
           hrcj01   LIKE hrcj_file.hrcj01,
           hrcj02   LIKE hrcj_file.hrcj02,
           hraa02   LIKE hraa_file.hraa02,
           hrcj03   LIKE hrcj_file.hrcj03,
           hrbl04   LIKE hrbl_file.hrbl04,
           hrbl05   LIKE hrbl_file.hrbl05,
           hrcj04   LIKE hrcj_file.hrcj04,
           hrcjconf LIKE hrcj_file.hrcjconf,
           hrbl08   LIKE hrbl_file.hrbl08,
           hrcj05   LIKE hrcj_file.hrcj05
                       END RECORD,
       g_hrcja         DYNAMIC ARRAY OF RECORD  
           hrcja03     LIKE   hrcja_file.hrcja03,           
           hrat02      LIKE hrat_file.hrat02,
           hraa02a     LIKE hraa_file.hraa02,
           hrao02      LIKE hrao_file.hrao02,
           hrap02      LIKE hrap_file.hrap02,
           hrcja04     LIKE hrbm_file.hrbm04,
           hrcja05     LIKE hrcja_file.hrcja05,    
           hrcja06     LIKE hrcja_file.hrcja06,  
           hrcja07     LIKE hrcja_file.hrcja07,  
           hrcja08     LIKE hrcja_file.hrcja08,  
           hrcja09     LIKE hrcja_file.hrcja09  
                     END RECORD,
       g_hrinput       DYNAMIC  ARRAY OF RECORD
           hrat01     LIKE hrat_file.hrat01,
           hrat03      LIKE   hrat_file.hrat03,
           hrat04      LIKE   hrat_file.hrat04,
           hrat05      LIKE   hrat_file.hrat05,
           hrcja04     LIKE   hrcja_file.hrcja04,
           hrcja05     LIKE   hrcja_file.hrcja05,
           hrcja06     LIKE   hrcja_file.hrcja06,
           hrcja07     LIKE   hrcja_file.hrcja07,
           hrcja08     LIKE   hrcja_file.hrcja08
                     END RECORD,
       g_sql         STRING,                      
       g_wc          STRING,                      
       g_wc2         STRING,                      
       g_rec_b,g_rec_b2      LIKE type_file.num5,         
       l_ac          LIKE type_file.num5          
DEFINE g_forupd_sql        STRING                  
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10  
DEFINE g_row_count         LIKE type_file.num10    
DEFINE g_jump              LIKE type_file.num10    
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_flag              LIKE type_file.chr1     
 
MAIN

   OPTIONS                       
      INPUT NO WRAP
   DEFER INTERRUPT               
 

   IF (NOT cl_user()) THEN          
      EXIT PROGRAM                  
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log     
 
   IF (NOT cl_setup("GHR")) THEN          
      EXIT PROGRAM                        
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   #便于数据的统计,决定使用临时表
   DROP TABLE tmp_hrcja
   CREATE TEMP TABLE tmp_hrcja
   (
       hrcja03    VARCHAR(60),
       hrcja04    VARCHAR(60),
       hrcja05    DEC(5,2),
       hrcja06    DEC(5,2),
       hrcja07    DEC(5,2),
       hrcja08    DEC(5,2)
   )

   LET g_forupd_sql = "SELECT * FROM hrcj_file WHERE hrcj01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)       
   DECLARE i065_cl CURSOR FROM g_forupd_sql            

   OPEN WINDOW i065_w WITH FORM "ghr/42f/ghri065"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()                              
 
   #隐藏KEY值栏位
   CALL cl_set_comp_visible("hrcj01",FALSE) 
  # NO.130910 --str--
   LET g_wc2='1=1'
   CALL i065_b_fill(g_wc2)
  # NO.130910  --end--
   CALL i065_menu()                              
   CLOSE WINDOW i065_w                          
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION i065_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM 
   CALL g_hrcj.clear()
   CALL g_hrcja.clear()
  
   CALL cl_set_head_visible("","YES")   

   CONSTRUCT BY NAME g_wc ON hrcj01,hrcj02,hrcj03,hrcj04,hrcj05
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrcj02) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hraa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrcj02
               NEXT FIELD hrcj02

            WHEN INFIELD(hrcj03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrcj03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrcj03
               NEXT FIELD hrcj03

            WHEN INFIELD(hrcj04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrcj04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrcj04
               NEXT FIELD hrcj04
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcjuser', 'hrcjgrup')
     
END FUNCTION
 
FUNCTION i065_menu()
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode


   WHILE TRUE
      CALL i065_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i065_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i065_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "ghr_confirm"
            IF cl_chk_act_auth() THEN
               CALL i065_y()
            END IF
         
         WHEN "ghr_undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i065_z()
            END IF

         WHEN "ghri065_a"
            IF cl_chk_act_auth() THEN
               CALL i065_g()
            END IF

         WHEN "ghri065_b"
            IF cl_chk_act_auth() THEN
               CALL i065_c()
            END IF

         WHEN "ghri065_c"
            IF cl_chk_act_auth() THEN
               CALL i065_uc()
            END IF

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"          
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcj),'','')
            END IF
         WHEN "ghri065_d"
             IF cl_chk_act_auth() THEN
               CALL i065_b_fill2()
            END IF
 
         WHEN "ghri065_e"          
            IF cl_chk_act_auth() THEN
            	 LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               LET page = f.FindNode("Page","page2")
               CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrcja),'','')
               #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcja),'','')
            END IF
            
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i065_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_hrcj TO s_hrcj.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE ROW                                                     
            LET l_ac = ARR_CURR()                                       
            CALL cl_show_fld_cont()    
   #         CALL i065_b_fill2()      #130910 mark by wangxh130910
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG
      END DISPLAY 

      DISPLAY ARRAY g_hrcja TO s_hrcja.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG

      ON ACTION ghr_confirm
         LET g_action_choice="ghr_confirm"
         EXIT DIALOG

      ON ACTION ghr_undo_confirm
         LET g_action_choice="ghr_undo_confirm"
         EXIT DIALOG

      ON ACTION ghri065_a
         LET g_action_choice="ghri065_a"
         EXIT DIALOG

      ON ACTION ghri065_b
         LET g_action_choice="ghri065_b"
         EXIT DIALOG

      ON ACTION ghri065_c
         LET g_action_choice="ghri065_c"
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()    
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION close  
        LET INT_FLAG=FALSE  
        LET g_action_choice = "exit"
        EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE        
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION exporttoexcel     
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
         
      ON ACTION ghri065_d
           LET g_action_choice="ghri065_d"
           EXIT DIALOG
         
      ON ACTION ghri065_e
           LET g_action_choice="ghri065_e"
           EXIT DIALOG
 
      ON ACTION controls      
         CALL cl_set_head_visible("","AUTO")      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i065_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i065_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL i065_b_fill(g_wc)
END FUNCTION
 
FUNCTION i065_b()
DEFINE l_ac_t          LIKE type_file.num5,  
       l_n             LIKE type_file.num5, 
       l_lock_sw       LIKE type_file.chr1,   
       p_cmd           LIKE type_file.chr1,  
       l_allow_insert  LIKE type_file.num5, 
       l_allow_delete  LIKE type_file.num5 
DEFINE l_max_hrcj01    LIKE hrcj_file.hrcj01

   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT hrcj01,hrcj02,'',hrcj03,'','',hrcj04,hrcjconf,'',hrcj05 ",
                      "  FROM hrcj_file",
                      "  WHERE hrcj01=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i065_bcl CURSOR FROM g_forupd_sql    
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_hrcj WITHOUT DEFAULTS FROM s_hrcj.*
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
         LET l_lock_sw = 'N'    
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_hrcj_t.* = g_hrcj[l_ac].*  
            OPEN i065_bcl USING g_hrcj_t.hrcj01
            IF STATUS THEN
               CALL cl_err("OPEN i065_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i065_bcl INTO g_hrcj[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcj[l_ac].hrcj02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_hrcj[l_ac].hraa02 = g_hrcj_t.hraa02
            LET g_hrcj[l_ac].hrbl04 = g_hrcj_t.hrbl04
            LET g_hrcj[l_ac].hrbl05 = g_hrcj_t.hrbl05
            LET g_hrcj[l_ac].hrbl08 = g_hrcj_t.hrbl08
            CALL i065_set_entry_b(p_cmd)    
            CALL i065_set_no_entry_b(p_cmd) 
         END IF
 
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrcj[l_ac].* TO NULL     
         LET g_hrcj[l_ac].hrcjconf = 'N'
         LET g_hrcj[l_ac].hrbl08='N'
         LET g_hrcj_t.* = g_hrcj[l_ac].*      
         CALL cl_show_fld_cont()         
         CALL i065_set_entry_b(p_cmd)    
         CALL i065_set_no_entry_b(p_cmd) 
         NEXT FIELD hrcj02
 
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         #考勤统计编号
         LET l_max_hrcj01 = ''
         SELECT MAX(hrcj01) INTO l_max_hrcj01 FROM hrcj_file
         IF cl_null(l_max_hrcj01) THEN
            LET g_hrcj[l_ac].hrcj01 = 1
         ELSE
            LET g_hrcj[l_ac].hrcj01 = l_max_hrcj01 + 1
         END IF
         INSERT INTO hrcj_file(hrcj01,hrcj02,hrcj03,hrcj04,hrcj05,hrcjconf)
         VALUES(g_hrcj[l_ac].hrcj01,g_hrcj[l_ac].hrcj02,g_hrcj[l_ac].hrcj03,
                g_hrcj[l_ac].hrcj04,g_hrcj[l_ac].hrcj05,g_hrcj[l_ac].hrcjconf)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcj_file",g_hrcj[l_ac].hrcj01,g_hrcj[l_ac].hrcj02,SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cnt
         END IF
 
      AFTER FIELD hrcj02
         IF NOT cl_null(g_hrcj[l_ac].hrcj02) THEN 
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01 = g_hrcj[l_ac].hrcj02
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n =0 THEN
               CALL cl_err("录入的公司编号不存在,请检查相关资料的设置","!",0)
               NEXT FIELD hrcj02
            ELSE
               SELECT hraa02 INTO g_hrcj[l_ac].hraa02 FROM hraa_file WHERE hraa01 = g_hrcj[l_ac].hrcj02
               DISPLAY BY NAME g_hrcj[l_ac].hraa02
            END IF 
            IF NOT cl_null(g_hrcj[l_ac].hrcj03) THEN
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM hrbl_file WHERE hrbl01 = g_hrcj[l_ac].hrcj02 AND hrbl02 = g_hrcj[l_ac].hrcj03 AND hrbl08 ='N'
               IF cl_null(l_n) THEN LET l_n = 0 END IF
               IF l_n = 0 THEN
                  CALL cl_err("录入的公司编号和考勤区间没有维护,请检查相关设置","!",0)
                  NEXT FIELD hrcj03
               END IF 
            END IF 
            IF NOT cl_null(g_hrcj[l_ac].hrcj03) AND NOT cl_null(g_hrcj[l_ac].hrcj04) THEN
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM hrbl_file,hrbla_file
                WHERE hrbl02 = hrbla02 AND hrbl01 = g_hrcj[l_ac].hrcj02
                  AND hrbl02 = g_hrcj[l_ac].hrcj03 AND hrbla01 = g_hrcj[l_ac].hrcj04
                  AND hrbl08 ='N'
               IF cl_null(l_n) THEN LET l_n = 0 END IF 
               IF l_n = 0 THEN 
                  CALL cl_err("录入的公司编号,考勤区间以及项次不存在,请检查相关设置","!",0)
                  NEXT FIELD hrcj04
               END IF 
               #检查资料的唯一性
               IF p_cmd = 'a' OR(g_hrcj[l_ac].hrcj02 <> g_hrcj_t.hrcj02 OR g_hrcj[l_ac].hrcj03 <> g_hrcj_t.hrcj03 OR g_hrcj[l_ac].hrcj04 <> g_hrcj_t.hrcj04) THEN
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM hrcj_file WHERE hrcj02 = g_hrcj[l_ac].hrcj02 AND hrcj03 = g_hrcj[l_ac].hrcj03 AND hrcj04 = g_hrcj[l_ac].hrcj04
                  IF cl_null(l_n) THEN LET l_n = 0 END IF 
                  IF l_n > 0 THEN 
                     CALL cl_err("同一公司的考勤区间项次必须唯一","!",0) 
                     NEXT FIELD hrcj02
                  END IF
               END IF  
            END IF     
         END IF 
      
       AFTER FIELD hrcj03
         IF NOT cl_null(g_hrcj[l_ac].hrcj02) AND NOT cl_null(g_hrcj[l_ac].hrcj03) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM hrbl_file WHERE hrbl01 = g_hrcj[l_ac].hrcj02 AND hrbl02 = g_hrcj[l_ac].hrcj03
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err("录入的公司编号和考勤区间没有维护,请检查相关设置","!",0)
               NEXT FIELD hrcj03
            ELSE
               SELECT hrbl04,hrbl05 INTO g_hrcj[l_ac].hrbl04,g_hrcj[l_ac].hrbl05 FROM hrbl_file WHERE hrbl01 = g_hrcj[l_ac].hrcj02 AND hrbl02 = g_hrcj[l_ac].hrcj03 AND hrbl08 ='N'
               DISPLAY BY NAME g_hrcj[l_ac].hrbl04,g_hrcj[l_ac].hrbl05
            END IF
            IF NOT cl_null(g_hrcj[l_ac].hrcj04) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM hrbl_file,hrbla_file
                WHERE hrbl02 = hrbla02 AND hrbl01 = g_hrcj[l_ac].hrcj02
                  AND hrbl02 = g_hrcj[l_ac].hrcj03 AND hrbla01 = g_hrcj[l_ac].hrcj04
                  AND hrbl08 ='N'
               IF cl_null(l_n) THEN LET l_n = 0 END IF
               IF l_n = 0 THEN
                  CALL cl_err("录入的公司编号,考勤区间以及项次不存在,请检查相关设置","!",0)
                  NEXT FIELD hrcj04
               END IF
               #检查资料的唯一性
               IF p_cmd = 'a' OR(g_hrcj[l_ac].hrcj02 <> g_hrcj_t.hrcj02 OR g_hrcj[l_ac].hrcj03 <> g_hrcj_t.hrcj03 OR g_hrcj[l_ac].hrcj04 <> g_hrcj_t.hrcj04) THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM hrcj_file WHERE hrcj02 = g_hrcj[l_ac].hrcj02 AND hrcj03 = g_hrcj[l_ac].hrcj03 AND hrcj04 = g_hrcj[l_ac].hrcj04
                  IF cl_null(l_n) THEN LET l_n = 0 END IF
                  IF l_n > 0 THEN
                     CALL cl_err("同一公司的考勤区间项次必须唯一","!",0)
                     NEXT FIELD hrcj04
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD hrcj04
         IF NOT cl_null(g_hrcj[l_ac].hrcj02) AND NOT cl_null(g_hrcj[l_ac].hrcj03) AND NOT cl_null(g_hrcj[l_ac].hrcj04) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM hrbl_file,hrbla_file
             WHERE hrbl02 = hrbla02 AND hrbl01 = g_hrcj[l_ac].hrcj02
               AND hrbl02 = g_hrcj[l_ac].hrcj03 AND hrbla01 = g_hrcj[l_ac].hrcj04
               AND hrbl08 ='N'
            IF cl_null(l_n) THEN LET l_n = 0 END IF
            IF l_n = 0 THEN
               CALL cl_err("录入的公司编号,考勤区间以及项次不存在,请检查相关设置","!",0)
               NEXT FIELD hrcj04
            END IF
            #检查资料的唯一性
            IF p_cmd = 'a' OR(g_hrcj[l_ac].hrcj02 <> g_hrcj_t.hrcj02 OR g_hrcj[l_ac].hrcj03 <> g_hrcj_t.hrcj03 OR g_hrcj[l_ac].hrcj04 <> g_hrcj_t.hrcj04) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM hrcj_file WHERE hrcj02 = g_hrcj[l_ac].hrcj02 AND hrcj03 = g_hrcj[l_ac].hrcj03 AND hrcj04 = g_hrcj[l_ac].hrcj04
               IF cl_null(l_n) THEN LET l_n = 0 END IF
               IF l_n > 0 THEN
                  CALL cl_err("同一公司的考勤区间项次必须唯一","!",0)
                  NEXT FIELD hrcj04
               END IF
            END IF
         END IF

      BEFORE DELETE          
         DISPLAY "BEFORE DELETE"
         IF g_hrcj_t.hrcj01 > 0 AND g_hrcj_t.hrcj01 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF

            DELETE FROM hrcj_file WHERE hrcj01 = g_hrcj_t.hrcj01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcj_file",g_hrcj_t.hrcj01,"",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               DELETE FROM hrcja_file WHERE hrcja01 = g_hrcj_t.hrcj01
               CALL g_hrcja.clear()
               LET g_rec_b2 = 0
               CALL i065_bpfresh()
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cnt
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrcj[l_ac].* = g_hrcj_t.*
            CLOSE i065_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         #资料已经审核则不允许修改
         IF g_hrcj[l_ac].hrcjconf = 'Y' THEN
            CALL cl_err("已审核资料不允许修改","!",1)
            LET g_hrcj[l_ac].* = g_hrcj_t.*
         ELSE
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrcj[l_ac].hrcj01,-263,1)
               LET g_hrcj[l_ac].* = g_hrcj_t.*
            ELSE
               UPDATE hrcj_file SET hrcj02=g_hrcj[l_ac].hrcj02,
                                    hrcj03=g_hrcj[l_ac].hrcj03,
                                    hrcj04=g_hrcj[l_ac].hrcj04,
                                    hrcj05=g_hrcj[l_ac].hrcj05
                WHERE hrcj01=g_hrcj_t.hrcj01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","hrcj_file",g_hrcj_t.hrcj01,"",SQLCA.sqlcode,"","",1)
                  LET g_hrcj[l_ac].* = g_hrcj_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
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
               LET g_hrcj[l_ac].* = g_hrcj_t.*
            END IF
            CLOSE i065_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i065_bcl
         COMMIT WORK
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrcj02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.default1 = g_hrcj[l_ac].hrcj02
               CALL cl_create_qry() RETURNING g_hrcj[l_ac].hrcj02
               DISPLAY BY NAME g_hrcj[l_ac].hrcj02
               NEXT FIELD hrcj02
            WHEN INFIELD(hrcj03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrcj03"
               LET g_qryparam.arg1 = g_hrcj[l_ac].hrcj02
               LET g_qryparam.default1 = g_hrcj[l_ac].hrcj03
               CALL cl_create_qry() RETURNING g_hrcj[l_ac].hrcj03
               DISPLAY BY NAME g_hrcj[l_ac].hrcj03
               NEXT FIELD hrcj03
            WHEN INFIELD(hrcj04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrcj04"
               LET g_qryparam.default1 = g_hrcj[l_ac].hrcj04
               LET g_qryparam.arg1 = g_hrcj[l_ac].hrcj02
               LET g_qryparam.arg2 = g_hrcj[l_ac].hrcj03
               CALL cl_create_qry() RETURNING g_hrcj[l_ac].hrcj04
               DISPLAY BY NAME g_hrcj[l_ac].hrcj04
               NEXT FIELD hrcj04
            OTHERWISE EXIT CASE
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
 
      ON ACTION controls    
         CALL cl_set_head_visible("","AUTO") 
   END INPUT
 
   CLOSE i065_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i065_b_fill(p_wc2)
DEFINE p_wc2   STRING
   LET g_sql = "SELECT hrcj01,hrcj02,'',hrcj03,hrbl04,hrbl05,hrcj04,hrcjconf,hrbl08,hrcj05 ",
               "  FROM hrcj_file,hrbl_file WHERE hrbl01=hrcj02 AND hrbl02=hrcj03 AND ",
               p_wc2 CLIPPED," ORDER BY hrbl04 DESC,hrbl05 DESC "
 
   PREPARE i065_pb FROM g_sql
   DECLARE hrcj_cs CURSOR FOR i065_pb
 
   CALL g_hrcj.clear()
   LET g_cnt = 1
 
   FOREACH hrcj_cs INTO g_hrcj[g_cnt].*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_hrcj[g_cnt].hrcj05) THEN
         LET g_hrcj[g_cnt].hrcj05=' '
      END IF
      SELECT hraa02 INTO g_hrcj[g_cnt].hraa02 FROM hraa_file WHERE hraa01 = g_hrcj[g_cnt].hrcj02
      #130910 mark by wangxh
#      SELECT hrbl04,hrbl05,hrbl08 INTO g_hrcj[g_cnt].hrbl04,g_hrcj[g_cnt].hrbl05,g_hrcj[g_cnt].hrbl08 
#        FROM hrbl_file WHERE hrbl01 = g_hrcj[g_cnt].hrcj02 AND hrbl02 = g_hrcj[g_cnt].hrcj03
#        
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrcj.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0
 
END FUNCTION

FUNCTION i065_b_fill2()
DEFINE l_hrcja03      LIKE  hrcja_file.hrcja03
DEFINE l_hrcja04      LIKE  hrcja_file.hrcja04
DEFINE l_hrat03       LIKE  hrat_file.hrat03
DEFINE l_hrat04       LIKE  hrat_file.hrat04
DEFINE l_hrat05       LIKE  hrat_file.hrat05
DEFINE l_hrat02       LIKE  hrat_file.hrat02
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
LET g_flag='N'
 CLEAR FORM
 CALL g_hrcja.clear()

     CONSTRUCT g_wc2 ON hrat01,hrat03,hrat04,hrat05,hrcja04,hrcja05,hrcja06,hrcja07,hrcja08
               FROM  s_hrcja[1].hrcja03,s_hrcja[1].hraa02a,s_hrcja[1].hrao02,s_hrcja[1].hrap02,
                     s_hrcja[1].hrcja04,s_hrcja[1].hrcja05,s_hrcja[1].hrcja06,s_hrcja[1].hrcja07,
                     s_hrcja[1].hrcja08
     BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)    #再次顯示查詢條件，因為進入單身後會將原顯示值清空
           CALL g_hrcja.clear()
           AFTER FIELD hrcja03
              LET l_hrcja03=GET_FLDBUF(hrcja03)
              IF NOT cl_null(l_hrcja03) THEN
                 SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01=l_hrcja03
                 DISPLAY l_hrat02 TO hrat02
              END IF 
    ON ACTION controlp
           CASE
                WHEN INFIELD(hrcja03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcja03
                 NEXT FIELD hrcja03
                 
                WHEN INFIELD(hraa02a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.default1 = l_hrat03
                 LET g_qryparam.construct = 'N'
                 CALL cl_create_qry() RETURNING l_hrat03
                 DISPLAY  l_hrat03 TO hraa02a
                 NEXT FIELD hraa02a
                 
                 
                WHEN INFIELD(hrao02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.arg1 = l_hrat03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao02
                 NEXT FIELD hrao02
                 
                WHEN INFIELD(hrap02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hras01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrap02
                 NEXT FIELD hrap02
                 
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
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
   END CONSTRUCT
     IF INT_FLAG THEN
        RETURN
     END IF
     LET g_sql="SELECT hrcja03,hrcja04,hrcja05,hrcja06,hrcja07,hrcja08,hrcja09 ",
               "  FROM hrcja_file,hrat_file WHERE hratid=hrcja03 AND hrcja01 = '",g_hrcj[l_ac].hrcj01,"' AND ",
               g_wc2 CLIPPED
     IF g_wc2=' 1=1' THEN
        IF cl_confirm('ghr-198') THEN
           LET g_sql = "SELECT hrcja03,hrcja04,hrcja05,hrcja06,hrcja07,hrcja08,hrcja09 ",
                       "  FROM hrcja_file WHERE hrcja01 = '",g_hrcj[l_ac].hrcj01,"' "
        ELSE
        	 RETURN
        END IF
     END IF

  
 
   PREPARE i065_pb2 FROM g_sql
   DECLARE hrcja_cs CURSOR FOR i065_pb2

   CALL g_hrcja.clear()
   LET g_cnt = 1

   FOREACH hrcja_cs INTO l_hrcja03,l_hrcja04,g_hrcja[g_cnt].hrcja05,g_hrcja[g_cnt].hrcja06,
                         g_hrcja[g_cnt].hrcja07,g_hrcja[g_cnt].hrcja08,g_hrcja[g_cnt].hrcja09
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(g_hrcja[g_cnt].hrcja05) THEN
         LET g_hrcja[g_cnt].hrcja05=cl_digcut(g_hrcja[g_cnt].hrcja05,0)
      END IF
      SELECT hrat01,hrat02,hrat03,hrat04,hrat05 INTO g_hrcja[g_cnt].hrcja03,g_hrcja[g_cnt].hrat02,l_hrat03,l_hrat04,l_hrat05
        FROM hrat_file WHERE hratid = l_hrcja03

      SELECT hraa02 INTO g_hrcja[g_cnt].hraa02a FROM hraa_file WHERE hraa01 = l_hrat03
      SELECT hrao02 INTO g_hrcja[g_cnt].hrao02 FROM hrao_file WHERE hrao01 = l_hrat04
      SELECT hrap06 INTO g_hrcja[g_cnt].hrap02 FROM hrap_file WHERE hrap05 = l_hrat05 AND hrap01 = l_hrat04

      SELECT hrbm04 INTO g_hrcja[g_cnt].hrcja04 FROM hrbm_file WHERE hrbm03 = l_hrcja04 #AND hrbm01 = g_hrcj[l_ac].hrcj02

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrcja.deleteElement(g_cnt)

   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION
FUNCTION i065_set_entry_b(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1   
   IF p_cmd = 'a' THEN 
      CALL cl_set_comp_entry("hrcj02,hrcj03,hrcj04",TRUE)
   END IF 
 
END FUNCTION
 
FUNCTION i065_set_no_entry_b(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1   
   IF p_cmd = 'u' THEN 
      CALL cl_set_comp_entry("hrcj02,hrcj03,hrcj04",FALSE)
   END IF 
END FUNCTION

FUNCTION i065_bpfresh()
    DISPLAY ARRAY g_hrcja TO s_hrcja.* ATTRIBUTE(COUNT=g_rec_b2)
       BEFORE DISPLAY 
          EXIT DISPLAY 
    END DISPLAY
END FUNCTION 

FUNCTION i065_y()
DEFINE l_hrcj    RECORD LIKE hrcj_file.*
   
   IF g_hrcj[l_ac].hrcj01 = 0 OR cl_null(g_hrcj[l_ac].hrcj01) THEN
      RETURN
   END IF

   IF g_hrcj[l_ac].hrcjconf = 'Y' THEN
      RETURN
   END IF

   BEGIN WORK

   OPEN i065_cl USING g_hrcj[l_ac].hrcj01
   IF STATUS THEN
      CALL cl_err("OPEN i065_cl:", STATUS, 1)
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i065_cl INTO l_hrcj.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcj[l_ac].hrcj01,SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF
   
   IF NOT cl_confirm("请再次确认审核") THEN
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_hrcj[l_ac].hrcjconf = 'Y' 

   UPDATE hrcj_file SET hrcjconf = 'Y'
    WHERE hrcj01 = g_hrcj[l_ac].hrcj01

   DISPLAY BY NAME g_hrcj[l_ac].hrcjconf

   CLOSE i065_cl

   COMMIT WORK

END FUNCTION

FUNCTION i065_z()
DEFINE l_hrcj    RECORD LIKE hrcj_file.*
DEFINE l_hrbl08  LIKE  hrbl_file.hrbl08

   IF g_hrcj[l_ac].hrcj01 = 0 OR cl_null(g_hrcj[l_ac].hrcj01) THEN
      RETURN
   END IF


   IF g_hrcj[l_ac].hrcjconf = 'N' THEN
      RETURN
   END IF 
  
   LET l_hrbl08 = ''
   SELECT hrbl08 INTO l_hrbl08 FROM hrbl_file 
    WHERE hrbl01 = g_hrcj[l_ac].hrcj02 
      AND hrbl02 = g_hrcj[l_ac].hrcj03

   IF l_hrbl08 ='Y' THEN
      IF NOT cl_confirm('已经期末关帐\n撤销修改可能造成考勤与已经计算的薪资结果不一致\n是否继续\n') THEN
         RETURN
      END IF
   END IF 

   BEGIN WORK

   OPEN i065_cl USING g_hrcj[l_ac].hrcj01
   IF STATUS THEN
      CALL cl_err("OPEN i065_cl:", STATUS, 1)
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i065_cl INTO l_hrcj.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcj[l_ac].hrcj01,SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF

   IF NOT cl_confirm("请再次确认取消审核") THEN
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_hrcj[l_ac].hrcjconf = 'N'

   UPDATE hrcj_file SET hrcjconf = 'N'
    WHERE hrcj01 = g_hrcj[l_ac].hrcj01

   DISPLAY BY NAME g_hrcj[l_ac].hrcjconf

   CLOSE i065_cl

   COMMIT WORK
END FUNCTION

FUNCTION i065_g()
DEFINE l_hrcj        RECORD LIKE hrcj_file.*
DEFINE l_hrcja       RECORD LIKE hrcja_file.*
DEFINE l_sql         STRING
DEFINE l_msg STRING 
DEFINE l_hrbla04     LIKE hrbla_file.hrbla04
DEFINE l_hrbla05     LIKE hrbla_file.hrbla05
DEFINE l_max_num     LIKE type_file.num20
DEFINE l_data        LIKE hrcja_file.hrcja05
DEFINE l_hrcd07      LIKE hrcd_file.hrcd07
DEFINE l_hrbm06      LIKE hrbm_file.hrbm06
DEFINE l_insflg      LIKE type_file.chr1 
DEFINE l_data1        LIKE hrcja_file.hrcja05

   IF g_hrcj[l_ac].hrcj01 = 0 OR cl_null(g_hrcj[l_ac].hrcj01) THEN
      CALL cl_err("获取基本资料信息错误",'!',1)
      RETURN
   END IF 
   
   IF g_hrcj[l_ac].hrcjconf = 'Y' THEN
      CALL cl_err("资料已经审核不允许运行统计",'!',1)
      RETURN
   END IF 

   BEGIN WORK
   #查询当前须要统计的资料
   OPEN i065_cl USING g_hrcj[l_ac].hrcj01    
   IF STATUS THEN
      CALL cl_err("OPEN i065_cl:", STATUS, 1)
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i065_cl INTO l_hrcj.*        
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcj[l_ac].hrcj01,SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF
CALL cl_progress_bar(8)
   #获取当前统计数据是考勤区间
   SELECT hrbla04,hrbla05 INTO l_hrbla04,l_hrbla05 FROM hrbla_file
    WHERE hrbla01 = l_hrcj.hrcj04 AND hrbla02 = l_hrcj.hrcj03
CALL cl_progressing('重新考勤汇总......')
##add by yinbq 期末统计前先重新处理点名数据
#   IF cl_confirm('是否确定重新核算日考勤?') THEN
#      LET l_msg="ghrp056 G ",l_hrbla04," ",l_hrbla05," 1 "
#      CALL cl_cmdrun_wait(l_msg)
#   END IF
##add by yinbq 期末统计前先重新处理点名数据
   #清空原有的统计数据
   DELETE FROM hrcja_file WHERE hrcja01 = l_hrcj.hrcj01
   #清空临时表数据
   DELETE FROM tmp_hrcja
   INITIALIZE l_hrcja.* TO NULL
CALL cl_progressing('收集补刷卡信息......')
   #获取补刷卡
   LET l_sql = "SELECT hrby09,hrby13,SUM(hrby11),COUNT(*) FROM hrby_file ",
               " WHERE EXISTS (SELECT 1 FROM (SELECT hrbm03 FROM hrbm_file WHERE hrbm02='009') tab WHERE tab.hrbm03=hrby13)",
               " AND hrby05 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " AND hrbyacti = 'Y' AND hrby12 = '2' AND hrbyacti = 'Y' ",
               " GROUP BY hrby09,hrby13 "
   PREPARE sel_hrby_pre FROM l_sql
   DECLARE sel_hrby_cs CURSOR FOR sel_hrby_pre
   FOREACH sel_hrby_cs INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
      #对累计统计分类
      LET l_hrbm06 = ''
      SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
      CASE l_hrbm06
         WHEN '001' LET l_hrcja.hrcja06 = l_data
         WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
         WHEN '003' LET l_hrcja.hrcja07 = l_data
         WHEN '004' LET l_hrcja.hrcja08 = l_data
         WHEN '005' LET l_hrcja.hrcja05 = l_data
      END CASE
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
   # add by yinbq 20141111 for 根据薪资生效日期分段核计
   LET l_sql = "SELECT hrby09,hrby13,SUM(hrby11),COUNT(*) FROM hrby_file ",
               " LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrby09",
               " WHERE EXISTS (SELECT 1 FROM (SELECT hrbm03 FROM hrbm_file WHERE hrbm02='009') tab WHERE tab.hrbm03=hrby13)",
               " AND hrby05 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " AND hrbyacti = 'Y' AND hrby12 = '2' AND hrbyacti = 'Y' ",
               " GROUP BY hrby09,hrby13 "
   PREPARE sel_hrby_pre_b FROM l_sql
   DECLARE sel_hrby_cs_b CURSOR FOR sel_hrby_pre_b
   FOREACH sel_hrby_cs_b INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
      #对累计统计分类
      LET l_hrbm06 = ''
      SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
      CASE l_hrbm06
         WHEN '001' LET l_hrcja.hrcja06 = l_data
         WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
         WHEN '003' LET l_hrcja.hrcja07 = l_data
         WHEN '004' LET l_hrcja.hrcja08 = l_data
         WHEN '005' LET l_hrcja.hrcja05 = l_data
      END CASE
      LET l_hrcja.hrcja04 = 'b',l_hrcja.hrcja04
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
   # add by yinbq 20141111 for 根据薪资生效日期分段核计
CALL cl_progressing('收集日考勤信息......')
   #对点名信息中的异常进行处理
   LET l_sql = " SELECT hrcp02,typecode,hrbm02,resSUM,resCOUNT,resDay,hrbm06 FROM (",
               " SELECT hrcp02,typecode,SUM(times) resSUM,COUNT(times) resCOUNT,sum(times2) resDay FROM (",
               " SELECT '1' colFlag, hrcp02,hrcp03,hrcp10 AS typecode,hrcp11 AS times ,hrcp11/(hrbo08/60) AS times2 FROM hrcp_file LEFT JOIN hrbo_file ON hrcp04=hrbo02 WHERE hrcp10 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " UNION",
               " SELECT '2' colFlag, hrcp02,hrcp03,hrcp12 AS typecode,hrcp13 AS times ,hrcp13/(hrbo08/60) AS times2 FROM hrcp_file LEFT JOIN hrbo_file ON hrcp04=hrbo02 WHERE hrcp12 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " UNION",
               " SELECT '3' colFlag, hrcp02,hrcp03,hrcp14 AS typecode,hrcp15 AS times ,hrcp15/(hrbo08/60) AS times2 FROM hrcp_file LEFT JOIN hrbo_file ON hrcp04=hrbo02 WHERE hrcp14 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " UNION",
               " SELECT '4' colFlag, hrcp02,hrcp03,hrcp16 AS typecode,hrcp17 AS times ,hrcp17/(hrbo08/60) AS times2 FROM hrcp_file LEFT JOIN hrbo_file ON hrcp04=hrbo02 WHERE hrcp16 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " UNION",
               " SELECT '5' colFlag, hrcp02,hrcp03,hrcp18 AS typecode,hrcp19 AS times ,hrcp19/(hrbo08/60) AS times2 FROM hrcp_file LEFT JOIN hrbo_file ON hrcp04=hrbo02 WHERE hrcp18 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " UNION",
               " SELECT '6' colFlag, hrcp02,hrcp03,hrcp20 AS typecode,hrcp21 AS times ,hrcp21/(hrbo08/60) AS times2 FROM hrcp_file LEFT JOIN hrbo_file ON hrcp04=hrbo02 WHERE hrcp20 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " )tab GROUP BY hrcp02,typecode)tab1",
               " LEFT JOIN hrbm_file ON hrbm03=typecode"
   PREPARE sel_hrcp_pre FROM l_sql
   DECLARE sel_hrcp_cs CURSOR FOR sel_hrcp_pre
   FOREACH sel_hrcp_cs INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcd07,l_data,l_hrcja.hrcja05,l_data1,l_hrbm06
      CASE l_hrcd07
			WHEN '001' LET l_hrcja.hrcja08 = l_data   #迟到 累计分钟值
			WHEN '002' LET l_hrcja.hrcja08 = l_data   #早退 累计分钟值
			WHEN '003' LET l_hrcja.hrcja07 = l_data   #旷工 累计小时值
			WHEN '004' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1   #请假 累计小时值
			WHEN '005' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #出差 累计小时值
			WHEN '006' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #年假 累计小时值
			WHEN '008' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #加班 累计小时值
			WHEN '010' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #特殊假 累计小时值
			WHEN '011' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #调休假 累计小时值
      
#         WHEN '001' LET l_hrcja.hrcja06 = l_data
#         WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#         WHEN '003' LET l_hrcja.hrcja07 = l_data
#         WHEN '004' LET l_hrcja.hrcja08 = l_data
#         WHEN '005' LET l_hrcja.hrcja05 = l_data
      END CASE
      #add by zhuzw 20150407 start
      IF l_hrbm06 = '001' THEN 
        SELECT  SUM(hrcda09) INTO l_hrcja.hrcja06 FROM  hrcda_file
        LEFT join hrcp_file ON hrcp02=hrcda04 AND hrcp03=hrcda05 
         WHERE  hrcda04 = l_hrcja.hrcja03
           AND  hrcda03 = l_hrcja.hrcja04
           AND  hrcda10 = '001'
           AND  hrcda05 BETWEEN l_hrbla04 AND l_hrbla05
           AND hrcda16 = 'N' AND hrcp08='92'
      END IF 
      IF l_hrcja.hrcja04 = '019' THEN 
         SELECT  COUNT(hrcda01),SUM(hrcda09),SUM(hrcda09*hrbo08/60)INTO l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07 FROM  hrcda_file,hrcp_file,hrbo_file
          WHERE  hrcda04 = hrcp02
            AND  hrcda05 = hrcp03
            AND  hrcp04 = hrbo02
            AND  hrbo06 = 'N'
            AND  hrcda04 = l_hrcja.hrcja03
            AND  hrcda03 ='019'
            AND  hrcda10 = '001'
            AND  hrcda05 BETWEEN l_hrbla04 AND l_hrbla05
            AND hrcda16 = 'N' AND hrcp08='92'
      END IF    
      #add by zhuzw 20150407 end       
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
   # add by yinbq 20141111 for 根据薪资生效日期分段核计
   LET l_sql = " SELECT hrcp02,typecode,hrbm02,resSUM,resCOUNT,resDay FROM (",
               " SELECT hrcp02,typecode,SUM(times) resSUM,COUNT(times) resCOUNT,COUNT(times2) resDay FROM (",
               " SELECT '1' colFlag, hrcp02,hrcp03,hrcp10 AS typecode,hrcp11 AS times ,hrcp11/hrbo08/60 AS times2 FROM hrcp_file 
                LEFT JOIN hrbo_file ON hrcp04=hrbo02 
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcp02
                WHERE hrcp10 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " UNION",
               " SELECT '2' colFlag, hrcp02,hrcp03,hrcp12 AS typecode,hrcp13 AS times ,hrcp13/hrbo08/60 AS times2 FROM hrcp_file 
                LEFT JOIN hrbo_file ON hrcp04=hrbo02 
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcp02
                WHERE hrcp10 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " UNION",
               " SELECT '3' colFlag, hrcp02,hrcp03,hrcp14 AS typecode,hrcp15 AS times ,hrcp15/hrbo08/60 AS times2 FROM hrcp_file 
                LEFT JOIN hrbo_file ON hrcp04=hrbo02 
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcp02
                WHERE hrcp10 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " UNION",
               " SELECT '4' colFlag, hrcp02,hrcp03,hrcp16 AS typecode,hrcp17 AS times ,hrcp17/hrbo08/60 AS times2 FROM hrcp_file 
                LEFT JOIN hrbo_file ON hrcp04=hrbo02 
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcp02
                WHERE hrcp10 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " UNION",
               " SELECT '5' colFlag, hrcp02,hrcp03,hrcp18 AS typecode,hrcp19 AS times ,hrcp19/hrbo08/60 AS times2 FROM hrcp_file 
                LEFT JOIN hrbo_file ON hrcp04=hrbo02 
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcp02
                WHERE hrcp10 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " UNION",
               " SELECT '6' colFlag, hrcp02,hrcp03,hrcp20 AS typecode,hrcp21 AS times ,hrcp21/hrbo08/60 AS times2 FROM hrcp_file 
                LEFT JOIN hrbo_file ON hrcp04=hrbo02 
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcp02
                WHERE hrcp10 IS NOT NULL AND hrcp03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " )tab GROUP BY hrcp02,typecode)tab1",
               " LEFT JOIN hrbm_file ON hrbm03=typecode"
   PREPARE sel_hrcp_pre_b FROM l_sql
   DECLARE sel_hrcp_cs_b CURSOR FOR sel_hrcp_pre_b
   FOREACH sel_hrcp_cs_b INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcd07,l_data,l_hrcja.hrcja05,l_data1
      CASE l_hrcd07
			WHEN '001' LET l_hrcja.hrcja08 = l_data   #迟到 累计分钟值
			WHEN '002' LET l_hrcja.hrcja08 = l_data   #早退 累计分钟值
			WHEN '003' LET l_hrcja.hrcja07 = l_data   #旷工 累计小时值
			WHEN '004' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1   #请假 累计小时值
			WHEN '005' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #出差 累计小时值
			WHEN '006' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #年假 累计小时值
			WHEN '008' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #加班 累计小时值
			WHEN '010' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #特殊假 累计小时值
			WHEN '011' LET l_hrcja.hrcja07 = l_data LET l_hrcja.hrcja06 = l_data1  #调休假 累计小时值
      END CASE
      LET l_hrcja.hrcja04 = 'b',l_hrcja.hrcja04
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
   # add by yinbq 20141111 for 根据薪资生效日期分段核计 
CALL cl_progressing('收集执行班次信息......')
   #对点名信息中的班次进行处理
   LET l_sql = "SELECT hrcp02,'9'||hrcp04,SUM(nvl(HRCPUD07,hrcp09)),COUNT(hrcp04) FROM hrcp_file ",
               " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " GROUP BY hrcp02,hrcp04"
   PREPARE sel_hrbo_pre FROM l_sql
   DECLARE sel_hrbo_cs CURSOR FOR sel_hrbo_pre
   FOREACH sel_hrbo_cs INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
      LET l_hrcja.hrcja06 = ""
      LET l_hrcja.hrcja07 = l_data
      LET l_hrcja.hrcja08 = ""
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH 
   # add by yinbq 20141111 for 根据薪资生效日期分段核计
   LET l_sql = "SELECT hrcp02,'9'||hrcp04,SUM(nvl(HRCPUD07,hrcp09)),COUNT(hrcp04) FROM hrcp_file 
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcp02",
               " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " GROUP BY hrcp02,hrcp04"
   PREPARE sel_hrbo_pre_b FROM l_sql
   DECLARE sel_hrbo_cs_b CURSOR FOR sel_hrbo_pre_b
   FOREACH sel_hrbo_cs_b INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
      LET l_hrcja.hrcja06 = ""
      LET l_hrcja.hrcja07 = l_data
      LET l_hrcja.hrcja08 = ""
      LET l_hrcja.hrcja04 = 'b',l_hrcja.hrcja04
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH  
   # add by yinbq 20141111 for 根据薪资生效日期分段核计 
CALL cl_progressing('收集节假日工作时间信息......')
   #对日历节假日工作时间处理
   LET l_sql = "SELECT hrcp02,'8'||hrbk05,SUM(nvl(HRCPUD07,hrcp09)),COUNT(hrcp04),SUM(case when HRCPUD07>8 then HRCPUD07-8 else 0 end ) FROM hrcp_file",
               " LEFT JOIN hrat_file ON hratid=hrcp02",
               " LEFT JOIN hrbk_file ON hrbk03=hrcp03 AND hrbk01=hrat03",
               " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " GROUP BY hrcp02,hrbk05"
   PREPARE sel_hrbk_pre FROM l_sql
   DECLARE sel_hrbk_cs CURSOR FOR sel_hrbk_pre
   FOREACH sel_hrbk_cs INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05,l_hrcja.hrcja06
      LET l_hrcja.hrcja07 = l_data
      LET l_hrcja.hrcja08 = ""
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
   # add by yinbq 20141111 for 根据薪资生效日期分段核计
   LET l_sql = "SELECT hrcp02,'8'||hrbk05,SUM(nvl(HRCPUD07,hrcp09)),COUNT(hrcp04),SUM(case when HRCPUD07>8 then HRCPUD07-8 else 0 end ) FROM hrcp_file",
               " LEFT JOIN hrat_file ON hratid=hrcp02",
               " LEFT JOIN hrbk_file ON hrbk03=hrcp03 AND hrbk01=hrat03
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcp02",
               " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " GROUP BY hrcp02,hrbk05"
   PREPARE sel_hrbk_pre_b FROM l_sql
   DECLARE sel_hrbk_cs_b CURSOR FOR sel_hrbk_pre_b
   FOREACH sel_hrbk_cs_b INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05,l_hrcja.hrcja06
      LET l_hrcja.hrcja07 = l_data
      LET l_hrcja.hrcja08 = ""
      LET l_hrcja.hrcja04 = 'b',l_hrcja.hrcja04
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
   # add by yinbq 20141111 for 根据薪资生效日期分段核计
CALL cl_progressing('收集班次津贴信息......')
   #对员工津贴处理
   LET l_sql = "SELECT hrcq02,hrcq05,sum(hrcq06),COUNT(hrcq05),0 FROM hrcq_file ",
               " WHERE hrcqconf='Y' AND hrcqacti='Y' AND",
               " hrcq03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
               " GROUP BY hrcq02,hrcq05"
   PREPARE sel_hrcq_pre FROM l_sql
   DECLARE sel_hrcq_cs CURSOR FOR sel_hrcq_pre
   FOREACH sel_hrcq_cs INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05,l_hrcja.hrcja06
      LET l_hrcja.hrcja07 = l_data
      LET l_hrcja.hrcja08 = ""
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
   # add by yinbq 20141111 for 根据薪资生效日期分段核计
   LET l_sql = "SELECT hrcq02,hrcq05,sum(hrcq06),COUNT(hrcq05),0 FROM hrcq_file 
                LEFT JOIN  (SELECT hrdp04,MAX(hrdpud13) hrdpud13 FROM hrdp_file GROUP BY hrdp04) a ON a.hrdp04=hrcq02",
               " WHERE hrcqconf='Y' AND hrcqacti='Y' AND",
               " hrcq03 BETWEEN '",l_hrbla04,"' AND hrdpud13 ",
               " GROUP BY hrcq02,hrcq05"
   PREPARE sel_hrcq_pre_b FROM l_sql
   DECLARE sel_hrcq_cs_b CURSOR FOR sel_hrcq_pre_b
   FOREACH sel_hrcq_cs_b INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05,l_hrcja.hrcja06
      LET l_hrcja.hrcja07 = l_data
      LET l_hrcja.hrcja08 = ""
      LET l_hrcja.hrcja04 = 'b',l_hrcja.hrcja04
      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
   # add by yinbq 20141111 for 根据薪资生效日期分段核计
   
#   #获取请假
#   LET l_sql = "SELECT hrcd09,hrcd01,hrcd07,SUM(hrcda09),COUNT(*) FROM hrcd_file,hrcda_file ",
#               " WHERE hrcd02 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
#               "   AND hrcda02 = hrcd10 ",
#               "  GROUP BY hrcd09,hrcd01,hrcd07 "
#
#   PREPARE sel_hrcd_pre FROM l_sql
#   DECLARE sel_hrcd_cs CURSOR FOR sel_hrcd_pre
#
#   FOREACH sel_hrcd_cs INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcd07,l_data,l_hrcja.hrcja05
#
#      #对累计统计分类
#      LET l_hrbm06 = ''
#      SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
#
#      CASE l_hrbm06
#         WHEN '001' LET l_hrcja.hrcja06 = l_data
#         WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#         WHEN '003' LET l_hrcja.hrcja07 = l_data
#         WHEN '004' LET l_hrcja.hrcja08 = l_data
#         WHEN '005' LET l_hrcja.hrcja05 = l_data
#      END CASE
#
#      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
#
#      INITIALIZE l_hrcja.* TO  NULL
#
#   END FOREACH
#
#   
#   #获取加班
#   LET l_sql ="SELECT hrcn03,hrcn09,SUM(hrcn08),COUNT(*) FROM hrcn_file ",
#              " WHERE hrcn04 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
#              "   AND hrcnconf = 'Y' ",
#              "  GROUP BY hrcn03,hrcn09 "
#       
#   PREPARE sel_hrcn_pre FROM l_sql
#   DECLARE sel_hrcn_cs CURSOR FOR sel_hrcn_pre
#  
#   FOREACH sel_hrcn_cs INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
#
#      #对累计统计分类
#      LET l_hrbm06 = ''
#      SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
#
#      CASE l_hrbm06
#         WHEN '001' LET l_hrcja.hrcja06 = l_data
#         WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#         WHEN '003' LET l_hrcja.hrcja07 = l_data
#         WHEN '004' LET l_hrcja.hrcja08 = l_data
#         WHEN '005' LET l_hrcja.hrcja05 = l_data
#      END CASE
#
#      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
#
#      INITIALIZE l_hrcja.* TO  NULL
#   END FOREACH
#
#   #获取考勤异常(项目一)
#   LET l_insflg = 'N' 
#
#   LET l_sql ="SELECT hrcp02,hrcp10,SUM(hrcp11),COUNT(*) FROM hrcp_file,hrbm_file ",
#              " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
#              "   AND hrcpconf = 'Y' AND hrcp08 = '92' AND hrcp10 = hrbm03 ",
#              "   AND hrbm02 IN('001','002','003','004') ",
#              "  GROUP BY hrcp02,hrcp10 "
#
#   PREPARE sel_hrcp_pre1 FROM l_sql
#   DECLARE sel_hrcp_cs1 CURSOR FOR sel_hrcp_pre1
#
#   FOREACH sel_hrcp_cs1 INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
#
#      LET l_insflg = 'Y'
#
#      #对累计统计分类
#      LET l_hrbm06 = ''
#      SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
#
#      CASE l_hrbm06
#         WHEN '001' LET l_hrcja.hrcja06 = l_data
#         WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#         WHEN '003' LET l_hrcja.hrcja07 = l_data
#         WHEN '004' LET l_hrcja.hrcja08 = l_data
#         WHEN '005' LET l_hrcja.hrcja05 = l_data
#      END CASE
#
#      INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
#
#      INITIALIZE l_hrcja.* TO  NULL
#   END FOREACH
#
# 
#   #获取考勤异常(项目二)
#   IF l_insflg = 'Y' THEN
#      LET l_insflg = 'N'
#
#      LET l_sql ="SELECT hrcp02,hrcp12,SUM(hrcp13),COUNT(*) FROM hrcp_file,hrbm_file ",
#                 " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
#                 "   AND hrcpconf = 'Y' AND hrcp08 = '92' AND hrcp12 = hrbm03 ",
#                 "   AND hrbm02 IN('001','002','003','004') ",
#                 "  GROUP BY hrcp02,hrcp12 "
#
#      PREPARE sel_hrcp_pre2 FROM l_sql
#      DECLARE sel_hrcp_cs2 CURSOR FOR sel_hrcp_pre2
#
#      FOREACH sel_hrcp_cs2 INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
#
#         LET l_insflg = 'Y'
#
#         #对累计统计分类
#         LET l_hrbm06 = ''
#         SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
#
#         CASE l_hrbm06
#            WHEN '001' LET l_hrcja.hrcja06 = l_data
#            WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#            WHEN '003' LET l_hrcja.hrcja07 = l_data
#            WHEN '004' LET l_hrcja.hrcja08 = l_data
#            WHEN '005' LET l_hrcja.hrcja05 = l_data
#         END CASE
#
#         INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
#
#         INITIALIZE l_hrcja.* TO  NULL
#      END FOREACH
#   END IF    
#
#   #获取考勤异常(项目三)
#   IF l_insflg = 'Y' THEN
#      LET l_insflg = 'N'
#
#      LET l_sql ="SELECT hrcp02,hrcp14,SUM(hrcp15),COUNT(*) FROM hrcp_file,hrbm_file ",
#                 " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
#                 "   AND hrcpconf = 'Y' AND hrcp08 = '92' AND hrcp14 = hrbm03 ",
#                 "   AND hrbm02 IN('001','002','003','004') ",
#                 "  GROUP BY hrcp02,hrcp14 "
#
#      PREPARE sel_hrcp_pre3 FROM l_sql
#      DECLARE sel_hrcp_cs3 CURSOR FOR sel_hrcp_pre3
#
#      FOREACH sel_hrcp_cs3 INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
#
#         LET l_insflg = 'Y'
#
#         #对累计统计分类
#         LET l_hrbm06 = ''
#         SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
#
#         CASE l_hrbm06
#            WHEN '001' LET l_hrcja.hrcja06 = l_data
#            WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#            WHEN '003' LET l_hrcja.hrcja07 = l_data
#            WHEN '004' LET l_hrcja.hrcja08 = l_data
#            WHEN '005' LET l_hrcja.hrcja05 = l_data
#         END CASE
#
#         INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
#
#         INITIALIZE l_hrcja.* TO  NULL
#      END FOREACH
#   END IF
#
#   #获取考勤异常(项目四)
#   IF l_insflg = 'Y' THEN
#      LET l_insflg = 'N'
#
#      LET l_sql ="SELECT hrcp02,hrcp16,SUM(hrcp17),COUNT(*) FROM hrcp_file,hrbm_file ",
#                 " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
#                 "   AND hrcpconf = 'Y' AND hrcp08 = '92' AND hrcp16 = hrbm03 ",
#                 "   AND hrbm02 IN('001','002','003','004') ",
#                 "  GROUP BY hrcp02,hrcp16 "
#
#      PREPARE sel_hrcp_pre4 FROM l_sql
#      DECLARE sel_hrcp_cs4 CURSOR FOR sel_hrcp_pre4
#
#      FOREACH sel_hrcp_cs4 INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
#
#         LET l_insflg = 'Y'
#
#         #对累计统计分类
#         LET l_hrbm06 = ''
#         SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
#
#         CASE l_hrbm06
#            WHEN '001' LET l_hrcja.hrcja06 = l_data
#            WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#            WHEN '003' LET l_hrcja.hrcja07 = l_data
#            WHEN '004' LET l_hrcja.hrcja08 = l_data
#            WHEN '005' LET l_hrcja.hrcja05 = l_data
#         END CASE
#
#         INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
#
#         INITIALIZE l_hrcja.* TO  NULL
#      END FOREACH
#   END IF
#
#   #获取考勤异常(项目五)
#   IF l_insflg = 'Y' THEN
#      LET l_insflg = 'N'
#
#      LET l_sql ="SELECT hrcp02,hrcp18,SUM(hrcp19),COUNT(*) FROM hrcp_file,hrbm_file ",
#                 " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
#                 "   AND hrcpconf = 'Y' AND hrcp08 = '92' AND hrcp18 = hrbm03 ",
#                 "   AND hrbm02 IN('001','002','003','004') ",
#                 "  GROUP BY hrcp02,hrcp18 "
#
#      PREPARE sel_hrcp_pre5 FROM l_sql
#      DECLARE sel_hrcp_cs5 CURSOR FOR sel_hrcp_pre5
#
#      FOREACH sel_hrcp_cs5 INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
#
#         LET l_insflg = 'Y'
#
#         #对累计统计分类
#         LET l_hrbm06 = ''
#         SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
#
#         CASE l_hrbm06
#            WHEN '001' LET l_hrcja.hrcja06 = l_data
#            WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#            WHEN '003' LET l_hrcja.hrcja07 = l_data
#            WHEN '004' LET l_hrcja.hrcja08 = l_data
#            WHEN '005' LET l_hrcja.hrcja05 = l_data
#         END CASE
#
#         INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
#
#         INITIALIZE l_hrcja.* TO  NULL
#      END FOREACH
#   END IF
#
#   #获取考勤异常(项目六)
#   IF l_insflg = 'Y' THEN
#      LET l_insflg = 'N'
#
#      LET l_sql ="SELECT hrcp02,hrcp20,SUM(hrcp21),COUNT(*) FROM hrcp_file,hrbm_file ",
#                 " WHERE hrcp03 BETWEEN '",l_hrbla04,"' AND '",l_hrbla05,"' ",
#                 "   AND hrcpconf = 'Y' AND hrcp08 = '92' AND hrcp20 = hrbm03 ",
#                 "   AND hrbm02 IN('001','002','003','004') ",
#                 "  GROUP BY hrcp02,hrcp20 "
#
#      PREPARE sel_hrcp_pre6 FROM l_sql
#      DECLARE sel_hrcp_cs6 CURSOR FOR sel_hrcp_pre6
#
#      FOREACH sel_hrcp_cs6 INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_data,l_hrcja.hrcja05
#
#         LET l_insflg = 'Y'
#
#         #对累计统计分类
#         LET l_hrbm06 = ''
#         SELECT hrbm06 INTO l_hrbm06 FROM hrbm_file WHERE hrbm03 = l_hrcja.hrcja04
#
#         CASE l_hrbm06
#            WHEN '001' LET l_hrcja.hrcja06 = l_data
#            WHEN '002' LET l_hrcja.hrcja06 = l_data*0.5
#            WHEN '003' LET l_hrcja.hrcja07 = l_data
#            WHEN '004' LET l_hrcja.hrcja08 = l_data
#            WHEN '005' LET l_hrcja.hrcja05 = l_data
#         END CASE
#
#         INSERT INTO tmp_hrcja VALUES(l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08)
#
#         INITIALIZE l_hrcja.* TO  NULL
#      END FOREACH
#   END IF
CALL cl_progressing('分析存储收集的信息......')
   #对临时表数据汇总
   LET l_sql = "SELECT hrcja03,hrcja04,SUM(hrcja05),SUM(hrcja06),SUM(hrcja07),SUM(hrcja08) FROM tmp_hrcja ",
              "  GROUP BY hrcja03,hrcja04 "

   PREPARE tmp_pre FROM l_sql
   DECLARE tmp_cs CURSOR FOR tmp_pre

   INITIALIZE l_hrcja.* TO NULL

   FOREACH tmp_cs INTO l_hrcja.hrcja03,l_hrcja.hrcja04,l_hrcja.hrcja05,l_hrcja.hrcja06,l_hrcja.hrcja07,l_hrcja.hrcja08
      LET l_hrcja.hrcja01 = l_hrcj.hrcj01
      LET l_max_num = ''
      SELECT MAX(hrcja02) INTO l_max_num FROM hrcja_file WHERE hrcja01 = l_hrcj.hrcj01
      IF cl_null(l_max_num) THEN
         LET l_hrcja.hrcja02 = 1
      ELSE
         LET l_hrcja.hrcja02 = l_max_num + 1
      END IF

      INSERT INTO hrcja_file VALUES(l_hrcja.*)

      INITIALIZE l_hrcja.* TO  NULL
   END FOREACH
CALL cl_progressing('统计结束')
   COMMIT WORK  
 
   CALL i065_b_fill2()
  
END FUNCTION

FUNCTION i065_c()
DEFINE l_hrcj    RECORD LIKE hrcj_file.*
DEFINE l_hrbl08  LIKE hrbl_file.hrbl08

   IF g_hrcj[l_ac].hrcj01 = 0 OR cl_null(g_hrcj[l_ac].hrcj01) THEN
      RETURN
   END IF

   IF g_hrcj[l_ac].hrcjconf = 'N' THEN
      CALL cl_err("存在未审核的资料不能关账","!",1)
      RETURN
   END IF 

   LET l_hrbl08 = ''
   SELECT hrbl08 INTO l_hrbl08 FROM hrbl_file
    WHERE hrbl01 = g_hrcj[l_ac].hrcj02
      AND hrbl02 = g_hrcj[l_ac].hrcj03

   IF l_hrbl08 = 'Y' THEN
      RETURN
   END IF 

   BEGIN WORK

   OPEN i065_cl USING g_hrcj[l_ac].hrcj01
   IF STATUS THEN
      CALL cl_err("OPEN i065_cl:", STATUS, 1)
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i065_cl INTO l_hrcj.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcj[l_ac].hrcj01,SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF

   IF NOT cl_confirm("请再次确认关账") THEN
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF

#   调整考勤区间关帐标记
   UPDATE hrbl_file SET hrbl08 = 'Y'
    WHERE hrbl02 = g_hrcj[l_ac].hrcj03
      AND hrbl01 = g_hrcj[l_ac].hrcj02
#   调整点名结果中已审核标记
   UPDATE hrcp_file SET hrcpconf='Y' WHERE 
   exists (SELECT 1 FROM hrat_file WHERE hratid=hrcp02 AND hrat03=g_hrcj[l_ac].hrcj02) AND 
   exists (SELECT 1 FROM hrbl_file WHERE hrbl01=g_hrcj[l_ac].hrcj02 AND hrbl02=g_hrcj[l_ac].hrcj03 AND hrcp03 BETWEEN hrbl06 AND hrbl07 )
   
   CLOSE i065_cl

   COMMIT WORK

END FUNCTION

FUNCTION i065_uc()
DEFINE l_hrcj    RECORD LIKE hrcj_file.*
DEFINE l_hrbl08  LIKE hrbl_file.hrbl08

   IF g_hrcj[l_ac].hrcj01 = 0 OR cl_null(g_hrcj[l_ac].hrcj01) THEN
      RETURN
   END IF

   LET l_hrbl08 = ''
   SELECT hrbl08 INTO l_hrbl08 FROM hrbl_file
    WHERE hrbl01 = g_hrcj[l_ac].hrcj02
      AND hrbl02 = g_hrcj[l_ac].hrcj03

   IF l_hrbl08 = 'N' OR cl_null(l_hrbl08) THEN
      RETURN
   END IF

   BEGIN WORK

   OPEN i065_cl USING g_hrcj[l_ac].hrcj01
   IF STATUS THEN
      CALL cl_err("OPEN i065_cl:", STATUS, 1)
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF 
      
   FETCH i065_cl INTO l_hrcj.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcj[l_ac].hrcj01,SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF

   IF NOT cl_confirm("请再次确认取消关账") THEN
      CLOSE i065_cl
      ROLLBACK WORK
      RETURN
   END IF


   UPDATE hrbl_file SET hrbl08 = 'N'
    WHERE hrbl02 = g_hrcj[l_ac].hrcj03
      AND hrbl01 = g_hrcj[l_ac].hrcj02


   CLOSE i065_cl

   COMMIT WORK

END FUNCTION
