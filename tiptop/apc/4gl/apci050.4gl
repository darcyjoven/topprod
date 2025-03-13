# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: apci050.4gl
# Descriptions...: POS基本參數維護作業
# Date & Author..: No:FUN-CA0074 12/10/10 By xumm
# Modify.........: No.FUN-D10016 13/01/04 By xumm 增加日期时间输入格式的判断
# Modify.........: No.FUN-D30036 13/03/14 By xumm 已使用的资料不可以删除或设置为无效
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 by lixiang 修正FUN-D30033 BUG

DATABASE ds
GLOBALS "../../config/top.global"  
 
DEFINE g_rzc            DYNAMIC ARRAY OF RECORD
           rzc01        LIKE rzc_file.rzc01,
           rzc01_desc   LIKE ryx_file.ryx05,
           rzc02        LIKE rzc_file.rzc02,
           rzc03        LIKE rzc_file.rzc03,
           rzc04        LIKE rzc_file.rzc04,
           rzc05        LIKE rzc_file.rzc05,
           rzcacti      LIKE rzc_file.rzcacti,
           rzcpos       LIKE rzc_file.rzcpos
                        END RECORD,
       g_rzc_t          RECORD                    
           rzc01        LIKE rzc_file.rzc01,
           rzc01_desc   LIKE ryx_file.ryx05,
           rzc02        LIKE rzc_file.rzc02,
           rzc03        LIKE rzc_file.rzc03,
           rzc04        LIKE rzc_file.rzc04,
           rzc05        LIKE rzc_file.rzc05,
           rzcacti      LIKE rzc_file.rzcacti,
           rzcpos       LIKE rzc_file.rzcpos
                        END RECORD,
       g_rzd            DYNAMIC ARRAY of RECORD        
           rzd02        LIKE rzd_file.rzd02,
           rzd02_desc   LIKE ryx_file.ryx05,
           rzdacti      LIKE rzd_file.rzdacti
                        END RECORD,
       g_rzd_t          RECORD                 
           rzd02        LIKE rzd_file.rzd02,
           rzd02_desc   LIKE ryx_file.ryx05,
           rzdacti      LIKE rzd_file.rzdacti
                        END RECORD                                      
DEFINE g_sql               STRING                   
DEFINE g_cmd               STRING
DEFINE g_wc1               STRING                  
DEFINE g_wc2               STRING
DEFINE g_rec_b             LIKE type_file.num5 
DEFINE g_rec_b1            LIKE type_file.num5 
DEFINE l_ac                LIKE type_file.num5 
DEFINE l_ac_t              LIKE type_file.num5
DEFINE l_ac1               LIKE type_file.num5
DEFINE l_ac1_t             LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_forupd_sql        STRING       
DEFINE g_forupd_sql1       STRING
DEFINE g_before_input_done LIKE type_file.num5         
DEFINE g_cnt               LIKE type_file.num10         
DEFINE g_action_flag       STRING
DEFINE g_detail_flag       LIKE type_file.chr1


MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT                            
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
 
   OPEN WINDOW i050_w  WITH FORM "apc/42f/apci050"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('rzcpos',FALSE)
   END IF
   LET g_wc1 = " 1=1"
   LET g_wc2 = " 1=1"
   CALL i050_b_fill(g_wc1,g_wc2)
   CALL i050_b2_fill(g_wc2)  
   CALL i050_menu()
 
   CLOSE WINDOW i050_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

FUNCTION i050_q()
   CLEAR FORM
   CALL g_rzc.clear()
   CALL g_rzd.clear()
   LET g_detail_flag = '1'
   DIALOG ATTRIBUTES(UNBUFFERED)  
       CONSTRUCT g_wc1 ON rzc01,rzc01_desc,rzc02,rzc03,rzc04,
                          rzc05,rzcacti,rzcpos
                     FROM s_rzc[1].rzc01,s_rzc[1].rzc01_desc,s_rzc[1].rzc02,s_rzc[1].rzc03,
                          s_rzc[1].rzc04,s_rzc[1].rzc05,s_rzc[1].rzcacti,s_rzc[1].rzcpos
        ON ACTION controlp
           CASE
              WHEN INFIELD(rzc01) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_rzc01" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rzc01
                    NEXT FIELD rzc01

              WHEN INFIELD(rzc05) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_rzc05" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rzc05
                    NEXT FIELD rzc05
                    
              OTHERWISE
                 EXIT CASE
           END CASE

        END CONSTRUCT

        CONSTRUCT g_wc2 ON rzd02,rzd02_desc,rzdacti  
                      FROM rzd02,s_rzd[1].rzd02_desc,s_rzd[1].rzdacti
        ON ACTION controlp
            CASE
               WHEN INFIELD(rzd02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rzd02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rzd02
                  NEXT FIELD rzd02
 
               OTHERWISE
                  EXIT CASE
            END CASE
        END CONSTRUCT
        
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
    
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

        ON ACTION ACCEPT
            ACCEPT DIALOG
      
        ON ACTION cancel
            LET INT_FLAG = 1
            EXIT DIALOG

   END DIALOG
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   LET g_wc1 = g_wc1 CLIPPED
   LET g_wc2 = g_wc2 CLIPPED
   CALL i050_b_fill(g_wc1,g_wc2)
   LET l_ac = 1
   CALL i050_b2_fill(g_wc2)
END FUNCTION


FUNCTION i050_menu()
   WHILE TRUE
      CALL i050_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i050_q()
            END IF
  
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i050_b()
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
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_rzc[l_ac].rzc01 IS NOT NULL THEN
                  LET g_doc.column1 = "rzc01"
                  LET g_doc.value1 = g_rzc[l_ac].rzc01
                  CALL cl_doc()
               END IF
            END IF

         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rzc),'','')
             END IF 

         WHEN "preserve_name"
            IF cl_null(g_rzc[l_ac].rzc01) THEN
               CALL cl_err(g_rzc[l_ac].rzc01,'apc-179',0)
            ELSE
               CALL i201_get_key_name('3',g_rzc[l_ac].rzc01,'1')
                    RETURNING g_rzc[l_ac].rzc01_desc
            END IF
         WHEN "preserve_name1"
            IF cl_null(g_rzd[l_ac1].rzd02) THEN
               CALL cl_err('','apc-179',0)
            ELSE
               CALL i201_get_key_name('4',g_rzc[l_ac].rzc01||"|"||g_rzd[l_ac1].rzd02,'1')
                    RETURNING g_rzd[l_ac1].rzd02_desc
            END IF 
     END CASE
   END WHILE
END FUNCTION

FUNCTION i050_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud != "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTE(UNBUFFERED)
   DISPLAY ARRAY g_rzc TO s_rzc.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
        #IF g_action_flag='' OR g_action_flag IS NULL THEN
        #   IF g_cmd = '' OR g_cmd IS NULL THEN
        #      LET l_ac = ARR_CURR()
        #   ELSE
        #      LET g_cmd = ''
        #   END IF
        #ELSE
        #   LET g_action_flag=''
        #END IF
         LET l_ac = ARR_CURR()
         CALL i050_b2_fill(g_wc2)
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET g_action_flag=''
         LET g_detail_flag  = '1'
         EXIT DIALOG
      
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL i050_b_fill(g_wc1,g_wc2)
         CALL i050_b2_fill(g_wc2)
       
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         LET g_action_flag=''
         LET g_detail_flag  = '1'
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

      ON ACTION preserve_name
        LET g_action_choice = "preserve_name"
        EXIT DIALOG
 
      ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DIALOG
                   
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      AFTER DISPLAY
         CONTINUE DIALOG
 
   END DISPLAY

   DISPLAY ARRAY g_rzd TO s_rzd.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
     
      BEFORE ROW
         LET l_ac1 = ARR_CURR() 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         LET g_detail_flag  = '2'
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL i050_b_fill(g_wc1,g_wc2)
         CALL i050_b2_fill(g_wc2)
      
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
   
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION preserve_name1
         LET g_action_choice = "preserve_name1"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET g_detail_flag  = '2'
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

      ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DIALOG
  
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      AFTER DISPLAY
         CONTINUE DIALOG 
      END DISPLAY 
      
      BEFORE DIALOG 
         IF cl_null(g_detail_flag) THEN LET g_detail_flag = '1' END IF
         CASE g_detail_flag
            WHEN '1'
               NEXT FIELD rzc01
            WHEN '2'
               NEXT FIELD rzd02
         END CASE

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i050_b_fill(p_wc1,p_wc3)
DEFINE p_wc1   STRING
DEFINE p_wc3   STRING

    IF p_wc3 = " 1=1" THEN 
       LET g_sql = "SELECT DISTINCT rzc01,'',rzc02,rzc03,rzc04,rzc05,rzcacti,rzcpos ",
                   "  FROM rzc_file ", 
                   " WHERE ",p_wc1 CLIPPED
    ELSE
       LET g_sql = "SELECT DISTINCT rzc01,'',rzc02,rzc03,rzc04,rzc05,rzcacti,rzcpos ", 
                   "  FROM rzc_file,rzd_file ",
                   " WHERE rzc01 = rzd01",
                   "   AND ",p_wc1 CLIPPED,
                   "   AND ",p_wc3 CLIPPED
    END IF
    IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
    END IF
    LET g_sql = g_sql CLIPPED," ORDER BY rzc01 "
    
    PREPARE i050_pb FROM g_sql
    DECLARE rzc_cs CURSOR FOR i050_pb
 
    CALL g_rzc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rzc_cs INTO g_rzc[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT ryx05 INTO g_rzc[g_cnt].rzc01_desc
          FROM ryx_file
         WHERE ryx03 =  g_rzc[g_cnt].rzc01
           AND ryx01 = 'rzc_file'
           AND ryx02 = 'rzc01'
           AND ryx04 = g_lang
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rzc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION

FUNCTION i050_b2_fill(p_wc2)
DEFINE p_wc2       STRING
DEFINE l_cnt       INTEGER
   LET l_cnt = g_rzc.getLength()
   IF cl_null(l_ac) OR l_ac=0 THEN
      LET l_ac = 1 
   END IF
   IF  l_cnt=0 OR l_cnt IS NULL THEN 
       CALL g_rzd.clear()
       RETURN 
   END IF
   
   LET g_sql = "SELECT rzd02,'',rzdacti ",
               "  FROM rzd_file ",
               " WHERE rzd01 = '",g_rzc[l_ac].rzc01,"'",
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY rzd02 "
   
   PREPARE i050_pb1 FROM g_sql
   DECLARE rzd_cs CURSOR FOR i050_pb1
 
   CALL g_rzd.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
   FOREACH rzd_cs INTO g_rzd[g_cnt].*  
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
      END IF
      SELECT ryx05 INTO g_rzd[g_cnt].rzd02_desc
        FROM ryx_file
       WHERE ryx03 = g_rzc[l_ac].rzc01||"|"||g_rzd[g_cnt].rzd02
         AND ryx01 = 'rzd_file'
         AND ryx02 = 'rzd02'
         AND ryx04 = g_lang
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_rzd.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt-1
   LET g_cnt = 0
END FUNCTION

FUNCTION i050_b()
DEFINE l_ac_t          LIKE type_file.num5,
       l_ac1_t         LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_n1            LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_rzcacti       LIKE rzc_file.rzcacti
DEFINE l_rzcpos        LIKE rzc_file.rzcpos 
DEFINE l_pos_str       LIKE type_file.chr1
DEFINE l_rzc05         STRING 
DEFINE l_rzd02         STRING     
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_cnt1          LIKE type_file.num5
DEFINE p_rzd02         LIKE rzd_file.rzd02    #FUN-D10016 
DEFINE p_rzc05         LIKE rzc_file.rzc05    #FUN-D10016

   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF

   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT rzc01,'',rzc02,rzc03,rzc04,rzc05,rzcacti,rzcpos",
                      "  FROM rzc_file",
                      "  WHERE rzc01=?",
                      "    FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i050_bcl CURSOR FROM g_forupd_sql
   
   LET g_forupd_sql1="SELECT rzd02,'',rzdacti",
                     "   FROM rzd_file",
                     "  WHERE rzd01=? AND rzd02=?",
                     "    FOR UPDATE "
   LET g_forupd_sql1 = cl_forupd_sql(g_forupd_sql1)
   DECLARE i050_bcl1 CURSOR FROM g_forupd_sql1
    
   IF g_rec_b > 0 THEN LET l_ac = 1 END IF     #FUN-D30033 add
   IF g_rec_b1 > 0 THEN LET l_ac1 =  1 END IF  #FUN-D30033 add
 
   DIALOG ATTRIBUTES(UNBUFFERED) 
   INPUT ARRAY g_rzc  FROM s_rzc.*
      BEFORE INPUT
         LET g_detail_flag = '1'
         IF g_rec_b !=0 THEN 
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         LET p_cmd =''
         LET g_cmd = ''
         LET l_ac =ARR_CURR()
         LET l_lock_sw ='N'
         LET l_n =ARR_COUNT()
         
         IF g_rec_b>=l_ac THEN 
            LET p_cmd ='u'
            LET g_rzc_t.*=g_rzc[l_ac].*
            LET g_before_input_done = FALSE                                                                                      
            CALL i050_set_entry(p_cmd)                                                                                           
            CALL i050_set_no_entry(p_cmd)  
            LET g_before_input_done = TRUE
           ##############################################################
           #已傳POS否處理段
            IF g_aza.aza88 = 'Y' THEN
               BEGIN WORK
               OPEN i050_bcl USING g_rzc_t.rzc01
               IF STATUS THEN
                  CLOSE i050_bcl
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i050_bcl INTO g_rzc[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CLOSE i050_bcl
                     LET l_lock_sw="Y" 
                  ELSE
                     LET l_pos_str = 'N'
                     SELECT rzcpos INTO l_rzcpos FROM rzc_file WHERE rzc01 = g_rzc[l_ac].rzc01
                     UPDATE rzc_file SET rzcpos = '4'
                      WHERE rzc01 = g_rzc[l_ac].rzc01
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","rzc_file",g_rzc_t.rzc01,"",SQLCA.sqlcode,"","",1)
                        RETURN
                     END IF
                     LET g_rzc[l_ac].rzcpos = '4'
                     DISPLAY BY NAME g_rzc[l_ac].rzcpos
                  END IF
               END IF
               COMMIT WORK
            END IF
           ##############################################################
            BEGIN WORK
            OPEN i050_bcl USING g_rzc_t.rzc01
            IF STATUS THEN
               CALL cl_err("OPEN i050_bcl:",STATUS,1)
               LET l_lock_sw='Y'
            ELSE
               FETCH i050_bcl INTO g_rzc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_rzc_t.rzc01,SQLCA.sqlcode,1)
                  CLOSE i050_bcl
                  LET l_lock_sw="Y"
               END IF
               SELECT ryx05 INTO g_rzc[l_ac].rzc01_desc
                 FROM ryx_file
                WHERE ryx03 =  g_rzc[l_ac].rzc01
                  AND ryx01 = 'rzc_file'
                  AND ryx02 = 'rzc01'
                  AND ryx04 = g_lang
            END IF
         END IF
         CALL i050_b2_fill(g_wc2) 
         CALL i050_rzd_refresh() 
            
      BEFORE INSERT
         LET l_n=ARR_COUNT()
         LET p_cmd='a'
         BEGIN WORK
         LET g_before_input_done = FALSE                                                                                      
         CALL i050_set_entry(p_cmd)                                                                                           
         CALL i050_set_no_entry(p_cmd)                                                                                        
         LET g_before_input_done = TRUE
         INITIALIZE g_rzc[l_ac].* TO NULL               
         LET g_rzc[l_ac].rzcpos = '1'
         LET l_rzcpos = '1' 
         LET g_rzc[l_ac].rzcacti = 'Y'  
         LET g_rzc_t.*=g_rzc[l_ac].*
         CALL g_rzd.clear()
         CALL i050_b2_fill(g_wc2) 
         CALL i050_rzd_refresh() 
         CALL cl_show_fld_cont()
         NEXT FIELD rzc01
              
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG=0
            CANCEL INSERT
         END IF
         BEGIN WORK               
         INSERT INTO rzc_file(rzc01,rzc02,rzc03,rzc04,rzc05,rzcacti,rzcpos)  
                       VALUES(g_rzc[l_ac].rzc01,g_rzc[l_ac].rzc02,
                              g_rzc[l_ac].rzc03,g_rzc[l_ac].rzc04,
                              g_rzc[l_ac].rzc05,g_rzc[l_ac].rzcacti,g_rzc[l_ac].rzcpos)                
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rzc_file",g_rzc[l_ac].rzc01,g_rzc[l_ac].rzc02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT OK'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b To FORMONLY.cn2
         END IF

      AFTER FIELD rzc01                       
         IF NOT cl_null(g_rzc[l_ac].rzc01) THEN
            IF g_rzc[l_ac].rzc01 != g_rzc_t.rzc01 OR g_rzc_t.rzc01 IS NULL THEN
               SELECT count(*)
                 INTO l_n
                 FROM rzc_file
                WHERE rzc01 = g_rzc[l_ac].rzc01
               IF l_n > 0 THEN
                  CALL cl_err(g_rzc[l_ac].rzc01,-239,0)
                  LET g_rzc[l_ac].rzc01 = g_rzc_t.rzc01
                  NEXT FIELD rzc01
               END IF
            END IF
         END IF

      AFTER FIELD rzc03                       
         IF NOT cl_null(g_rzc[l_ac].rzc03) THEN
            IF g_rzc[l_ac].rzc03 <= 0 THEN
               CALL cl_err(g_rzc[l_ac].rzc03,'apc1037',0)
               LET g_rzc[l_ac].rzc03 = g_rzc_t.rzc03
               NEXT FIELD rzc03
               IF NOT cl_null(g_rzc[l_ac].rzc05) THEN
                  LET l_rzc05 = g_rzc[l_ac].rzc05
                  LET l_n1 = 0
                  LET l_n1 = l_rzc05.getLength()
                  IF l_n1 > g_rzc[l_ac].rzc03 THEN
                     CALL cl_err(g_rzc[l_ac].rzc03,'apc1039',0)
                     LET g_rzc[l_ac].rzc03 = g_rzc_t.rzc03
                     NEXT FIELD rzc03
                  END IF
               END IF
            END IF
         END IF
          
      AFTER FIELD rzc05                       
         IF NOT cl_null(g_rzc[l_ac].rzc05) THEN
            IF NOT cl_null(g_rzc[l_ac].rzc01) THEN
               LET l_rzc05 = g_rzc[l_ac].rzc05
               LET l_n1 = 0
               LET l_n1 = l_rzc05.getLength()
               IF l_n1 > g_rzc[l_ac].rzc03 AND NOT cl_null(g_rzc[l_ac].rzc03) THEN
                  CALL cl_err(g_rzc[l_ac].rzc05,'apc1039',0)
                  LET g_rzc[l_ac].rzc05 = g_rzc_t.rzc05
                  NEXT FIELD rzc05
               END IF
               LET l_n = 0
               LET l_n1 = 0
               SELECT COUNT(*) INTO l_n FROM rzd_file WHERE rzd01 = g_rzc[l_ac].rzc01
               SELECT COUNT(*) INTO l_n1 FROM rzd_file WHERE rzd02 = g_rzc[l_ac].rzc05
               IF l_n > 0 AND l_n1 = 0 THEN
                  CALL cl_err(g_rzc[l_ac].rzc05,'apc1038',0)
                  LET g_rzc[l_ac].rzc05 = g_rzc_t.rzc05
                  NEXT FIELD rzc05
               END IF
               #FUN-D10016------add----str
               IF g_rzc[l_ac].rzc02 = '3' THEN
                  SELECT rzd02 INTO p_rzd02 FROM rzd_file WHERE rzd01 = g_rzc[l_ac].rzc01
                  CALL i050_check_date(g_rzc[l_ac].rzc05,p_rzd02)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rzc[l_ac].rzc05,g_errno,0)
                     LET g_rzc[l_ac].rzc05 = g_rzc_t.rzc05
                     NEXT FIELD rzc05
                  END IF
               END IF
               #FUN-D10016------add----end
            END IF
         END IF
         

      #FUN-D30036-----Add-----Str
      AFTER FIELD rzcacti 
         IF NOT cl_null(g_rzc[l_ac].rzcacti) AND g_rzc[l_ac].rzcacti = 'N' THEN
            LET l_n1 = 0
            SELECT COUNT(*) INTO l_n1
              FROM rze_file
             WHERE rze03 = g_rzc_t.rzc01
               AND rzeacti = 'Y'
            IF l_n1 > 0 THEN
               CALL cl_err(g_rzc_t.rzc01,'apc-123',0)
               LET g_rzc[l_ac].rzcacti = 'Y'
               NEXT FIELD rzcacti
            END IF 
         END IF
      #FUN-D30036-----Add-----End
      BEFORE DELETE                      
         DISPLAY "BEFORE DELETE"
         IF g_rzc_t.rzc01 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            #FUN-D30036-----Add-----Str
            LET l_n1 = 0
            SELECT COUNT(*) INTO l_n1
              FROM rze_file
             WHERE rze03 = g_rzc_t.rzc01
               AND rzeacti = 'Y'
            IF l_n1 > 0 THEN
               CALL cl_err(g_rzc_t.rzc01,'apc-123',0)
               CANCEL DELETE
            END IF
            #FUN-D30036-----Add-----End
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            IF g_aza.aza88='Y' THEN
               IF NOT ((l_rzcpos='3' AND l_rzcacti='N') OR (l_rzcpos='1'))  THEN
                  CALL cl_err('','apc-139',0)            
                  CANCEL DELETE
               END IF      
            END IF
            BEGIN WORK
            DELETE FROM ryx_file
                  WHERE ryx01 = 'rzd_file'
                    AND ryx02 = 'rzd01'
                    AND ryx03 IN (SELECT rzd01||"|"||rzd02 FROM rzd_file WHERE rzd01 = g_rzc_t.rzc01)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ryx_file","",g_rzc_t.rzc01,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM rzd_file
             WHERE rzd01 = g_rzc_t.rzc01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","rzd_file",g_rzc_t.rzc01,'',SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF SQLCA.sqlcode THEN   
               CALL cl_err3("del","rzd_file",g_rzc_t.rzc01,'',SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               DELETE FROM ryx_file
                WHERE ryx01 = 'rzc_file'
                  AND ryx02 = 'rzc01'
                  AND ryx03 = g_rzc_t.rzc01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ryx_file","",g_rzc_t.rzc01,SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               DELETE FROM rzc_file
                WHERE rzc01 = g_rzc_t.rzc01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","rzc_file",g_rzc_t.rzc01,'',SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rzc[l_ac].* = g_rzc_t.*
            CLOSE i050_bcl
            ROLLBACK WORK
            EXIT DIALOG 
         END IF
         IF g_aza.aza88='Y' THEN
            IF l_rzcpos <> '1' THEN
               LET g_rzc[l_ac].rzcpos='2'
            ELSE
               LET g_rzc[l_ac].rzcpos='1'
            END IF
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_rzc[l_ac].rzc02,-263,1)
            LET g_rzc[l_ac].* = g_rzc_t.*
         ELSE
            UPDATE rzc_file SET rzc02=g_rzc[l_ac].rzc02,
                                rzc03=g_rzc[l_ac].rzc03,
                                rzc04=g_rzc[l_ac].rzc04,
                                rzc05=g_rzc[l_ac].rzc05,
                                rzcacti=g_rzc[l_ac].rzcacti, 
                                rzcpos=g_rzc[l_ac].rzcpos
             WHERE rzc01=g_rzc_t.rzc01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","rzc_file",g_rzc_t.rzc01,'',SQLCA.sqlcode,"","",1) 
               LET g_rzc[l_ac].* = g_rzc_t.*
            ELSE
               LET g_cmd = 'c'
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
            CLOSE i050_bcl
            ROLLBACK WORK
            IF p_cmd = 'u' AND l_lock_sw <> 'Y' THEN
               LET g_rzc[l_ac].* = g_rzc_t.*
               IF g_aza.aza88 = 'Y' THEN
                  UPDATE rzc_file 
                     SET rzcpos = l_rzcpos
                   WHERE rzc01 = g_rzc_t.rzc01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","rzc_file",g_rzc_t.rzc01,"",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_rzc[l_ac].rzcpos = l_rzcpos
                  DISPLAY BY NAME g_rzc[l_ac].rzcpos
               END IF
            ELSE
               CALL g_rzc.deleteElement(l_ac)
            END IF 

            EXIT DIALOG 
         END IF
         CLOSE i050_bcl
         COMMIT WORK

     ON ACTION controlp
        CASE
            WHEN INFIELD(rzc05) 
               LET l_n1 = 0
               SELECT COUNT(*) INTO l_n1 FROM rzd_file WHERE rzd01 = g_rzc[l_ac].rzc01
               IF l_n1 = 0 THEN
                  CALL cl_err(g_rzc[l_ac].rzc05,'apc1040',0)
                  DISPLAY BY NAME g_rzc[l_ac].rzc05
                  NEXT FIELD rzc05
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rzd02"
                  LET g_qryparam.default1 = g_rzc[l_ac].rzc05
                  CALL cl_create_qry() RETURNING g_rzc[l_ac].rzc05
                  DISPLAY BY NAME g_rzc[l_ac].rzc05
                  NEXT FIELD rzc05
               END IF 
           OTHERWISE EXIT CASE
       END CASE

      ON ACTION preserve_name
         IF cl_null(g_rzc[l_ac].rzc01) THEN
            CALL cl_err(g_rzc[l_ac].rzc01,'apc-179',0)
         ELSE
            CALL i201_get_key_name('3',g_rzc[l_ac].rzc01,'1')
                 RETURNING g_rzc[l_ac].rzc01_desc
         END IF

   END INPUT
  
   INPUT ARRAY g_rzd  FROM s_rzd.*
      BEFORE INPUT
         LET g_detail_flag = '2'
         IF g_rec_b1 !=0 THEN 
            CALL fgl_set_arr_curr(l_ac1)
         END IF
        ##############################################################
        #已傳POS否處理段
         IF g_aza.aza88 = 'Y' THEN
            BEGIN WORK
            OPEN i050_bcl USING g_rzc[l_ac].rzc01
            IF STATUS THEN
               CALL cl_err("OPEN i050_bcl:",STATUS,1)
               CLOSE i050_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i050_bcl INTO g_rzc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err("OPEN i050_bcl:",STATUS,1)
                  CLOSE i050_bcl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  LET l_pos_str = 'N'
                  SELECT rzcpos INTO l_rzcpos FROM rzc_file WHERE rzc01 = g_rzc[l_ac].rzc01
                  UPDATE rzc_file SET rzcpos = '4'
                   WHERE rzc01 = g_rzc[l_ac].rzc01
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rzc_file",g_rzc_t.rzc01,"",SQLCA.sqlcode,"","",1)
                     RETURN
                  END IF
                  LET g_rzc[l_ac].rzcpos = '4'
                  DISPLAY BY NAME g_rzc[l_ac].rzcpos
               END IF
            END IF
            COMMIT WORK 
         END IF
        ##############################################################

      BEFORE ROW
         LET p_cmd =''
         LET l_ac1 =ARR_CURR()
         LET l_lock_sw ='N'
         LET l_n =ARR_COUNT()
         
         BEGIN WORK 
         IF g_rec_b1>=l_ac1 THEN 
            LET p_cmd ='u'
            LET g_rzd_t.*=g_rzd[l_ac1].*
            LET g_before_input_done = FALSE    
            LET g_before_input_done = TRUE
           ##############################################################
           #已傳POS否處理段
           #IF g_aza.aza88 = 'Y' THEN
           #   BEGIN WORK
           #   OPEN i050_bcl USING g_rzc[l_ac].rzc01
           #   IF STATUS THEN
           #      CLOSE i050_bcl
           #      LET l_lock_sw='Y'
           #   ELSE
           #      FETCH i050_bcl INTO g_rzc[l_ac].*
           #      IF SQLCA.sqlcode THEN
           #         CLOSE i050_bcl
           #         LET l_lock_sw="Y"
           #      ELSE
           #         LET l_pos_str = 'N'
           #         SELECT rzcpos INTO l_rzcpos FROM rzc_file WHERE rzc01 = g_rzc[l_ac].rzc01
           #         UPDATE rzc_file SET rzcpos = '4'
           #          WHERE rzc01 = g_rzc[l_ac].rzc01
           #         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #            CALL cl_err3("upd","rzc_file",g_rzc_t.rzc01,"",SQLCA.sqlcode,"","",1)
           #            RETURN
           #         END IF
           #         LET g_rzc[l_ac].rzcpos = '4'
           #         DISPLAY BY NAME g_rzc[l_ac].rzcpos
           #      END IF
           #   END IF
           #   COMMIT WORK
           #END IF
           ##############################################################
            OPEN i050_bcl USING g_rzc[l_ac].rzc01
            IF STATUS THEN
               CALL cl_err("OPEN i050_bcl:",STATUS,1)
               LET l_lock_sw='Y'
            ELSE
               FETCH i050_bcl INTO g_rzc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_rzc_t.rzc01,SQLCA.sqlcode,1)
                  CLOSE i050_bcl
                  LET l_lock_sw="Y"
               ELSE
                  OPEN i050_bcl1 USING g_rzc[l_ac].rzc01,g_rzd_t.rzd02
                  IF STATUS THEN
                     CALL cl_err("OPEN i050_bcl1:",STATUS,1)
                     EXIT DIALOG
                     LET l_lock_sw='Y'
                  ELSE
                     FETCH i050_bcl1 INTO g_rzd[l_ac1].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rzd_t.rzd02,SQLCA.sqlcode,1)
                        LET l_lock_sw="Y"
                     END IF
                        SELECT ryx05 INTO g_rzd[l_ac1].rzd02_desc
                          FROM ryx_file
                         WHERE ryx03 = g_rzc[l_ac].rzc01||"|"||g_rzd[l_ac1].rzd02
                           AND ryx01 = 'rzd_file'
                           AND ryx02 = 'rzd02'
                           AND ryx04 = g_lang
                  END IF
                  SELECT ryx05 INTO g_rzc[l_ac].rzc01_desc
                    FROM ryx_file
                   WHERE ryx03 =  g_rzc[l_ac].rzc01
                     AND ryx01 = 'rzc_file'
                     AND ryx02 = 'rzc01'
                     AND ryx04 = g_lang
               END IF
            END IF
         END IF
            
     BEFORE INSERT
        LET l_n=ARR_COUNT()
        LET p_cmd='a'
        LET g_before_input_done = FALSE                                                 
        CALL i050_set_entry(p_cmd)
        CALL i050_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
        INITIALIZE g_rzd[l_ac1].* TO NULL
        LET g_rzd[l_ac1].rzdacti = 'Y'
        LET g_rzd_t.*=g_rzd[l_ac1].*
        CALL cl_show_fld_cont()

     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG=0
           CANCEL INSERT
        END IF
        
        INSERT INTO rzd_file(rzd01,rzd02,rzdacti)
             VALUES(g_rzc[l_ac].rzc01,g_rzd[l_ac1].rzd02,g_rzd[l_ac1].rzdacti) 
               
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","rzd_file",g_rzc[l_ac].rzc01,g_rzd[l_ac1].rzd02,SQLCA.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           IF g_aza.aza88='Y' THEN
              IF l_rzcpos <> '1' THEN
                 LET l_rzcpos='2'
              ELSE
                 LET l_rzcpos='1'
              END IF
           END IF
           MESSAGE 'INSERT OK'
           COMMIT WORK
           LET l_pos_str = 'Y'
           LET g_rec_b1=g_rec_b1+1
        END IF

     AFTER FIELD rzd02
        IF NOT cl_null(g_rzd[l_ac1].rzd02) THEN
           IF g_rzd[l_ac1].rzd02 != g_rzd_t.rzd02 OR g_rzd_t.rzd02 IS NULL THEN
              SELECT COUNT(*) INTO l_n FROM rzd_file
               WHERE rzd01 = g_rzc[l_ac].rzc01    
                 AND rzd02 = g_rzd[l_ac1].rzd02
              LET l_n = 0
              IF l_n > 0 THEN
                 CALL cl_err(g_rzd[l_ac1].rzd02,-239,0)
                 LET g_rzd[l_ac1].rzd02 = g_rzd_t.rzd02
                 NEXT FIELD rzd02
              END IF
              LET l_rzd02 = g_rzd[l_ac1].rzd02
              LET l_n1 = 0
              LET l_n1 = l_rzd02.getLength()
              IF l_n1 > g_rzc[l_ac].rzc03 THEN
                 CALL cl_err(g_rzd[l_ac1].rzd02,'apc1039',0)
                 LET g_rzd[l_ac1].rzd02 = g_rzd_t.rzd02
                 NEXT FIELD rzd02
              END IF
              #FUN-D10016------add----str
              IF g_rzc[l_ac].rzc02 = '3' THEN
                 SELECT rzc05 INTO p_rzc05 FROM rzc_file WHERE rzc01 = g_rzc[l_ac].rzc01
                 CALL i050_check_date(g_rzd[l_ac1].rzd02,p_rzc05)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rzd[l_ac1].rzd02,g_errno,0)
                    LET g_rzd[l_ac1].rzd02 = g_rzd_t.rzd02
                    NEXT FIELD rzd02
                 END IF
              END IF
              #FUN-D10016------add----end 
           END IF
        END IF
        
    BEFORE DELETE                      
       DISPLAY "BEFORE DELETE"
       IF g_rzd[l_ac1].rzd02 = g_rzc[l_ac].rzc05 THEN
          CALL cl_err(g_rzd[l_ac1].rzd02,'apc1041', 1)
          CANCEL DELETE
       END IF
       IF NOT cl_delb(0,0) THEN
          CANCEL DELETE
       END IF
       IF l_lock_sw = "Y" THEN
          CALL cl_err("", -263, 1)
          CANCEL DELETE
       END IF
       IF g_aza.aza88='Y' THEN
          IF NOT ((l_rzcpos='3' AND g_rzc[l_ac].rzcacti = 'N') OR (l_rzcpos='1'))  THEN
             CALL cl_err('','apc-139',0)
             CANCEL DELETE
          END IF
       END IF
       BEGIN WORK
       DELETE FROM ryx_file
        WHERE ryx01 = 'rzd_file'
          AND ryx02 = 'rzd01'
          AND ryx03 IN (SELECT rzd01||"|"||rzd02 FROM rzd_file WHERE rzd01 = g_rzc[l_ac].rzc01 AND rzd02 = g_rzd_t.rzd02)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","ryx_file","",g_rzd_t.rzd02,SQLCA.sqlcode,"","",1)  
          ROLLBACK WORK
          CANCEL DELETE
       END IF
       DELETE FROM rzd_file
        WHERE rzd01 = g_rzc[l_ac].rzc01
          AND rzd02 = g_rzd_t.rzd02
       IF SQLCA.sqlcode THEN   
          CALL cl_err3("del","rzd_file",g_rzd_t.rzd02,'',SQLCA.sqlcode,"","",1)  
          ROLLBACK WORK
          CANCEL DELETE
       ELSE
          MESSAGE 'DELETE Ok'
          COMMIT WORK
          LET l_pos_str = 'Y'
          LET g_rec_b1=g_rec_b1-1 
       END IF

    ON ROW CHANGE
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_rzd[l_ac1].* = g_rzd_t.*
          CLOSE i050_bcl
          CLOSE i050_bcl1
          ROLLBACK WORK
          EXIT DIALOG 
       END IF
       IF g_aza.aza88='Y' THEN
          IF l_rzcpos <> '1' THEN
             LET l_rzcpos='2'
          ELSE
             LET l_rzcpos='1'
          END IF
       END IF
       IF l_lock_sw = 'Y' THEN
          CALL cl_err(g_rzd[l_ac1].rzd02,-263,1)
          LET g_rzd[l_ac1].* = g_rzd_t.*
       ELSE
          UPDATE rzd_file SET rzd02 = g_rzd[l_ac1].rzd02,
                              rzdacti =g_rzd[l_ac1].rzdacti
           WHERE rzd01 = g_rzc[l_ac].rzc01
             AND rzd02=g_rzd_t.rzd02
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","rzd_file",g_rzd_t.rzd02,'',SQLCA.sqlcode,"","",1) 
             LET g_rzd[l_ac1].* = g_rzd_t.*
          ELSE
             MESSAGE 'UPDATE O.K'
             COMMIT WORK
             LET l_pos_str = 'Y'
          END IF
       END IF

    AFTER ROW
       DISPLAY  "AFTER ROW!!"
       LET l_ac1 = ARR_CURR()
       LET l_ac1_t = l_ac1
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd = 'u' THEN
             LET g_rzd[l_ac1].* = g_rzd_t.*
          ELSE
             CALL g_rzd.deleteElement(l_ac1)
          END IF
          CLOSE i050_bcl
          CLOSE i050_bcl1
          ROLLBACK WORK
          EXIT DIALOG 
       END IF

      ON ACTION preserve_name1
        IF cl_null(g_rzd[l_ac1].rzd02) THEN
           CALL cl_err('','apc-179',0)
        ELSE
           CALL i201_get_key_name('4',g_rzc[l_ac].rzc01||"|"||g_rzd[l_ac1].rzd02,'1')
                RETURNING g_rzd[l_ac1].rzd02_desc
        END IF

      AFTER INPUT 
        IF NOT cl_null(g_rzc[l_ac].rzc05) THEN
           LET l_cnt = 0 
           LET l_cnt1 = 0
           SELECT COUNT(*) INTO l_cnt  FROM rzd_file WHERE rzd01 = g_rzc[l_ac].rzc01
           SELECT COUNT(*) INTO l_cnt1 FROM rzd_file WHERE rzd01 = g_rzc[l_ac].rzc01 AND rzd02 = g_rzc[l_ac].rzc05
           IF l_cnt > 0 AND l_cnt1 < 1 THEN
              CALL cl_err('','apc1049',0)
              NEXT FIELD rzd02
           END IF
        END IF
        IF g_aza.aza88 = 'Y' THEN
           UPDATE rzc_file
              SET rzcpos = l_rzcpos
            WHERE rzc01 = g_rzc[l_ac].rzc01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rzc_file",g_rzc[l_ac].rzc01,"",SQLCA.sqlcode,"","",1)
           END IF
           LET g_rzc[l_ac].rzcpos = l_rzcpos
           DISPLAY BY NAME g_rzc[l_ac].rzcpos
        END IF
        COMMIT WORK
      
   END INPUT

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DIALOG

   ON ACTION about       
      CALL cl_about()     

   ON ACTION help          
      CALL cl_show_help()  

   ON ACTION controls                    
      CALL cl_set_head_visible("","AUTO")  

   ON ACTION ACCEPT
      ACCEPT DIALOG

   ON ACTION CANCEL
     #IF g_aza.aza88 = 'Y' THEN
     #   UPDATE rzc_file SET rzcpos = l_rzcpos
     #    WHERE rzc01 = g_rzc[l_ac].rzc01
     #   IF SQLCA.sqlcode THEN
     #      CALL cl_err3("upd","rzc_file",g_rzc[l_ac].rzc01,"",SQLCA.sqlcode,"","",1)
     #   END IF
     #   LET g_rzc[l_ac].rzcpos = l_rzcpos
     #   DISPLAY BY NAME g_rzc[l_ac].rzcpos
     #END IF
     #LET INT_FLAG = 1
     #CALL i050_b_fill(g_wc1,g_wc2)
     #CALL i050_b2_fill(g_wc2)
      CLOSE i050_bcl
      ROLLBACK WORK
      CASE g_detail_flag
         WHEN '1'
            IF p_cmd = 'u' AND l_lock_sw <> 'Y' THEN
               LET g_rzc[l_ac].* = g_rzc_t.*
               IF g_aza.aza88 = 'Y' THEN
                  UPDATE rzc_file
                     SET rzcpos = l_rzcpos
                   WHERE rzc01 = g_rzc_t.rzc01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","rzc_file",g_rzc_t.rzc01,"",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_rzc[l_ac].rzcpos = l_rzcpos
                  DISPLAY BY NAME g_rzc[l_ac].rzcpos
               END IF
            END IF
           #IF p_cmd = 'a' THEN       #TQC-D40025 mark
            IF p_cmd = 'a' AND g_rec_b != 0 THEN   #TQC-D40025 add
               CALL g_rzc.deleteElement(l_ac)
               CALL i050_b()  #FUN-D30033 add
            END IF
         WHEN '2'
           IF NOT cl_null(g_rzc[l_ac].rzc05) THEN
              LET l_cnt = 0
              LET l_cnt1 = 0
              SELECT COUNT(*) INTO l_cnt  FROM rzd_file WHERE rzd01 = g_rzc[l_ac].rzc01
              SELECT COUNT(*) INTO l_cnt1 FROM rzd_file WHERE rzd01 = g_rzc[l_ac].rzc01 AND rzd02 = g_rzc[l_ac].rzc05
              IF l_cnt > 0 AND l_cnt1 < 1 THEN
                 CALL cl_err('','apc1049',0)
                 NEXT FIELD rzd02
              END IF 
           END IF 
            LET g_rzd[l_ac1].* = g_rzd_t.*
            IF g_aza.aza88 = 'Y' THEN
               UPDATE rzc_file
                  SET rzcpos = l_rzcpos
                WHERE rzc01 = g_rzc[l_ac].rzc01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rzc_file",g_rzc[l_ac].rzc01,"",SQLCA.sqlcode,"","",1)
               END IF
               LET g_rzc[l_ac].rzcpos = l_rzcpos
               DISPLAY BY NAME g_rzc[l_ac].rzcpos
            END IF
           #IF p_cmd = 'a' THEN       #TQC-D40025 mark
            IF p_cmd = 'a' AND g_rec_b1 != 0 THEN   #TQC-D40025 add
               CALL g_rzd.deleteElement(l_ac1)
               CALL i050_b()  #FUN-D30033 add
            END IF
      END CASE
      EXIT DIALOG

   ON ACTION CONTROLF
      CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
      CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

   BEFORE DIALOG
      CASE g_detail_flag
         WHEN '1'
            NEXT FIELD rzc02
         WHEN '2'
            NEXT FIELD rzdacti
      END CASE

   END DIALOG
CLOSE i050_bcl
CLOSE i050_bcl1
COMMIT WORK 
END FUNCTION

FUNCTION i050_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("rzc01",TRUE)
           CALL cl_set_comp_entry("rzd02",TRUE)
        END IF
END FUNCTION

FUNCTION i050_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("rzc01",FALSE)
           CALL cl_set_comp_entry("rzd02",FALSE)
        END IF
END FUNCTION

FUNCTION i050_bp_refresh()
 
  DISPLAY ARRAY g_rzc TO s_rzc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION i050_rzd_refresh()

  DISPLAY ARRAY g_rzd TO s_rzd.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION
#FUN-CA0074 
#FUN-D10016------add----str
FUNCTION i050_check_date(p_rzc05,p_rzd02)
DEFINE p_rzc05       LIKE rzc_file.rzc05
DEFINE p_rzd02       LIKE rzd_file.rzd02
DEFINE l_str         STRING
DEFINE l_str1        STRING
DEFINE l_date        LIKE type_file.chr10
DEFINE l_time        LIKE type_file.chr8
DEFINE l_days        LIKE type_file.num5

   LET g_errno = ''
   
   LET l_str1 = p_rzd02
   LET l_str = p_rzc05
   IF l_str.getindexof('-',1) > 0 THEN
      LET l_date = p_rzc05
      IF l_str.getLength() !=10 THEN
         LET g_errno = 'apc1059'
      END IF
      IF l_date[1,1] MATCHES '[0123456789]' AND
         l_date[2,2] MATCHES '[0123456789]' AND
         l_date[3,3] MATCHES '[0123456789]' AND
         l_date[4,4] MATCHES '[0123456789]' AND
         l_date[5,5] = '-' AND
         l_date[6,6] MATCHES '[012]' AND
         l_date[7,7] MATCHES '[0123456789]' AND
         l_date[8,8] = '-' AND
         l_date[9,9] MATCHES '[0123]' AND
         l_date[10,10] MATCHES '[0123456789]' THEN
         IF l_date[1,4] <'0001' OR l_date[6,7] <'01' OR l_date[6,7] >'12' OR 
            l_date[9,10] <'01' THEN
            LET g_errno = 'apc1059'
         ELSE
            LET l_days = cl_days(l_date[1,4],l_date[6,7])
            IF l_date[9,10] > l_days THEN
               LET g_errno = 'apc1059'
            END IF
         END IF
      ELSE
         LET g_errno = 'apc1059'
      END IF 
   ELSE
      IF l_str.getindexof(':',1) > 0 THEN
         LET l_time = p_rzc05
         IF l_str.getLength() != 8 THEN
            LET g_errno = 'apc1059'
         END IF
         IF l_time[1,1] MATCHES '[012]' AND
            l_time[2,2] MATCHES '[0123456789]' AND
            l_time[3,3] =':' AND
            l_time[4,4] MATCHES '[012345]' AND
            l_time[5,5] MATCHES '[0123456789]' AND
            l_time[6,6] =':' AND
            l_time[7,7] MATCHES '[012345]' AND
            l_time[8,8] MATCHES '[0123456789]' THEN
            IF l_time[1,2]<'00' OR l_time[1,2]>='24' OR
               l_time[4,5]<'00' OR l_time[4,5]>='60' OR
               l_time[7,8]<'00' OR l_time[7,8]>='60' THEN
               LET g_errno='apc1059'
            END IF         
         ELSE
            LET g_errno='apc1059'
         END IF
      ELSE
         LET g_errno = 'apc1059'
      END IF
   END IF
   IF l_str1.getindexof('-',1) > 0 AND l_str.getindexof('-',1) = 0 THEN 
      LET g_errno = 'apc1061'
   END IF
   IF l_str1.getindexof(':',1) > 0 AND l_str.getindexof(':',1) = 0 THEN
      LET g_errno = 'apc1061'
   END IF
END FUNCTION
#FUN-D10016------add----end
