# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: sapci201.4gl
# Descriptions...: 名稱多語言對照檔
# Date & Author..: No:FUN-C40084 12/04/28 fanbj
# Modify.........: No.FUN-CA0074 12/10/11 BY xumeimei 添加两个来源类型'3':rzc_file,'4':rzd_file
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ryx                DYNAMIC ARRAY OF RECORD 
          ryx03                LIKE ryx_file.ryx03,  
          ryx04                LIKE ryx_file.ryx04,  
          ryx05                LIKE ryx_file.ryx05
                            END RECORD,
       g_ryx_t              RECORD 
          ryx03                LIKE ryx_file.ryx03,  
          ryx04                LIKE ryx_file.ryx04,  
          ryx05                LIKE ryx_file.ryx05
                            END RECORD
DEFINE gs_wc2               string                
DEFINE gs_sql               string                
DEFINE gs_rec_b             LIKE type_file.num5   # 單身筆數 
DEFINE ls_ac                LIKE type_file.num5   # 目前處理的ARRAY CNT    
DEFINE gs_cnt               LIKE type_file.num10    
DEFINE gs_forupd_sql        STRING
DEFINE gs_before_input_done LIKE type_file.num5  
DEFINE gs_flag              LIKE type_file.chr1 
DEFINE gs_no                LIKE ryp_file.ryp01
DEFINE gs_type              LIKE type_file.chr1

#維護模塊和功能名稱
#p_type       #類型                     1-apci201,         2-apci202 
#p_no         #編號                     模塊編號           功能編號
#p_flag       #開啟維護名稱畫面的方式   1-不進單身開啟     2-進單身開啟 
FUNCTION i201_get_key_name(p_type,p_no,p_flag)

   DEFINE p_type        LIKE type_file.chr1
   DEFINE p_no          LIKE ryp_file.ryp01   
   DEFINE l_title1      LIKE gaq_file.gaq03 
   DEFINE l_title2      LIKE gaq_file.gaq03 
   DEFINE l_ryx05       LIKE ryx_file.ryx05
   DEFINE p_flag        LIKE type_file.chr1
  
   LET gs_type = p_type 
   LET gs_no = p_no
   LET gs_flag = p_flag
   WHENEVER ERROR CALL cl_err_msg_log
  
   OPEN WINDOW apci201_1_w WITH FORM "apc/42f/apci201_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   
   CASE gs_type
      WHEN '1'
         SELECT gaq03 INTO l_title1
           FROM gaq_file
          WHERE gaq01 = 'ryp01'
            AND gaq02 = g_lang
      WHEN '2'
         SELECT gaq03 INTO l_title1
           FROM gaq_file
          WHERE gaq01 = 'ryq01'
            AND gaq02 = g_lang
      #FUN-CA0074-----add---str
      WHEN '3'
         SELECT gaq03 INTO l_title1
           FROM gaq_file
          WHERE gaq01 = 'rzc01'
            AND gaq02 = g_lang
      WHEN '4'
         SELECT gaq03 INTO l_title1
           FROM gaq_file
          WHERE gaq01 = 'rzd01'
            AND gaq02 = g_lang
         SELECT gaq03 INTO l_title2
           FROM gaq_file
          WHERE gaq01 = 'rzd02'
            AND gaq02 = g_lang
         LET l_title1 = l_title1 CLIPPED,"|",l_title2 CLIPPED
      #FUN-CA0074-----add---end
   END CASE
   CALL cl_set_comp_att_text("ryx03",l_title1)
   CALL cl_set_combo_lang("ryx04")
   CALL i201_1_b_fill( " 1=1") 
   CALL i201_1_menu()
 
   CLOSE WINDOW apci201_1_w                            # 結束畫面

   CASE gs_type
      WHEN '1'
         SELECT ryx05 INTO l_ryx05
           FROM ryx_file
          WHERE ryx01 = 'ryp_file'
            AND ryx02 = 'ryp01'
            AND ryx03 = gs_no
            AND ryx04 = g_lang
      WHEN '2'
         SELECT ryx05 INTO l_ryx05
           FROM ryx_file
          WHERE ryx01 = 'ryq_file'
            AND ryx02 = 'ryq01'
            AND ryx03 = gs_no
            AND ryx04 = g_lang
      #FUN-CA0074-----add---str
      WHEN '3'
         SELECT ryx05 INTO l_ryx05
           FROM ryx_file
          WHERE ryx01 = 'rzc_file'
            AND ryx02 = 'rzc01'
            AND ryx03 = gs_no
            AND ryx04 = g_lang
      WHEN '4'
         SELECT ryx05 INTO l_ryx05
           FROM ryx_file
          WHERE ryx01 = 'rzd_file'
            AND ryx02 = 'rzd02'
            AND ryx03 = gs_no
            AND ryx04 = g_lang
      #FUN-CA0074-----add---end 
   END CASE
   RETURN l_ryx05
END FUNCTION 
 
FUNCTION i201_1_menu()
 
   WHILE TRUE
      CALL i201_1_bp("G")
      CASE g_action_choice
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i201_1_q()
            END IF
 
         WHEN "detail"            # "B.單身"
            IF cl_chk_act_auth() THEN
               IF gs_flag = '1' THEN
                  CALL i201_1_b()
               ELSE
                  CALL i201_1_b1()
               END IF 
            ELSE
               LET g_action_choice = " "
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"   
           CALL cl_cmdask()
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i201_1_q()
   CALL i201_1_b_askkey()
END FUNCTION
 
 
FUNCTION i201_1_b()
 
   DEFINE l_ac_t          LIKE type_file.num5    # 未取消的ARRAY CNT     
   DEFINE l_n             LIKE type_file.num5    # 檢查重複用                    
   DEFINE l_lock_sw       LIKE type_file.chr1    # 單身鎖住否           
   DEFINE p_cmd           LIKE type_file.chr1    # 處理狀態             
   DEFINE l_allow_insert  LIKE type_file.num5    # 可否新增             
   DEFINE l_allow_delete  LIKE type_file.num5    # 可否刪除             
   DEFINE l_modify_flag   LIKE type_file.chr1
 
   LET g_action_choice = ""
   CALL cl_opmsg('b')
 
   IF s_shut(0) THEN 
      RETURN 
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   CASE  gs_type  
      WHEN '1'   
         LET gs_forupd_sql = " SELECT ryx03,ryx04,ryx05",   
                            "   FROM ryx_file ",
                            "  WHERE ryx01 = 'ryp_file' ",
                            "    AND ryx02= 'ryp01' ",
                            "    AND ryx03= ? AND ryx04 = ? ",
                            "    FOR UPDATE "
         LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
      WHEN '2'
         LET gs_forupd_sql = " SELECT ryx03,ryx04,ryx05",
                            "   FROM ryx_file ",
                            "  WHERE ryx01 ='ryq_file' ",
                            "    AND ryx02 ='ryq01' ",
                            "    AND ryx03 = ? AND ryx04 = ?",
                            "    FOR UPDATE "  
         LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
      #FUN-CA0074-----add---str
      WHEN '3'
         LET gs_forupd_sql = " SELECT ryx03,ryx04,ryx05",
                            "   FROM ryx_file ",
                            "  WHERE ryx01 = 'rzc_file' ",
                            "    AND ryx02= 'rzc01' ",
                            "    AND ryx03= ? AND ryx04 = ? ",
                            "    FOR UPDATE "
         LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
      WHEN '4'
         LET gs_forupd_sql = " SELECT ryx03,ryx04,ryx05",
                            "   FROM ryx_file ",
                            "  WHERE ryx01 = 'rzd_file' ",
                            "    AND ryx02= 'rzd02' ",
                            "    AND ryx03= ? AND ryx04 = ? ",
                            "    FOR UPDATE "
         LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
      #FUN-CA0074-----add---end
   END CASE       
                      
   DECLARE i201_1_bcl CURSOR FROM gs_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_ryx WITHOUT DEFAULTS FROM s_ryx.*
      ATTRIBUTE(COUNT=gs_rec_b, MAXCOUNT= g_max_rec, UNBUFFERED,
                INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF gs_rec_b != 0 THEN
            CALL fgl_set_arr_curr(ls_ac)
         END IF 
      BEFORE ROW
         LET p_cmd = ''
         LET ls_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF gs_rec_b>=ls_ac THEN
            BEGIN WORK
            LET g_ryx_t.* = g_ryx[ls_ac].*  #BACKUP
            LET p_cmd='u'

            OPEN i201_1_bcl USING g_ryx_t.ryx03, g_ryx_t.ryx04
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN i201_1_bcl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i201_1_bcl INTO g_ryx[ls_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i201_1_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ryx[ls_ac].* TO NULL      
         LET gs_before_input_done = FALSE
         LET gs_before_input_done = TRUE
 
         LET g_ryx[ls_ac].ryx03 = gs_no
         LET g_ryx_t.* = g_ryx[ls_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     
         
      AFTER FIELD ryx04
         IF NOT cl_null(g_ryx[ls_ac].ryx04) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ryx_t.ryx04 <> g_ryx[ls_ac].ryx04) THEN
               CALL i201_1_ryx_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ryx[ls_ac].ryx04 = g_ryx_t.ryx04
                  NEXT FIELD ryx04
               END IF  
            END IF 
         END IF 

      BEFORE FIELD ryx05
         LET l_modify_flag = 'Y'
         IF l_lock_sw = 'Y' THEN            #已鎖住
            LET l_modify_flag = 'N'
         END IF
         IF l_modify_flag = 'N' THEN
            LET g_ryx[ls_ac].ryx03 = g_ryx_t.ryx03
            LET g_ryx[ls_ac].ryx03 = g_ryx_t.ryx04 
            DISPLAY g_ryx[ls_ac].ryx03 TO s_ryx[ls_ac].ryx03
            DISPLAY g_ryx[ls_ac].ryx04 TO s_ryx[ls_ac].ryx04
            NEXT FIELD ryx04
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_ryx_t.ryx03 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            CASE gs_type
               WHEN '1'
                  DELETE FROM ryx_file 
                   WHERE ryx01 = 'ryp_file'
                     AND ryx02 = 'ryp01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '2'
                  DELETE FROM ryx_file
                   WHERE ryx01 = 'ryq_file'
                     AND ryx02 = 'ryq01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04       
               #FUN-CA0074-----add---str
               WHEN '3'
                  DELETE FROM ryx_file
                   WHERE ryx01 = 'rzc_file'
                     AND ryx02 = 'rzc01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '4'
                  DELETE FROM ryx_file
                   WHERE ryx01 = 'rzd_file'
                     AND ryx02 = 'rzd02'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               #FUN-CA0074-----add---end
            END CASE    
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gaz_file",g_ryx_t.ryx03,g_ryx_t.ryx04,
                             SQLCA.sqlcode,"","",0)
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            LET gs_rec_b=gs_rec_b-1
            DISPLAY gs_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i201_1_bcl
            COMMIT WORK 
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         CASE gs_type
            WHEN '1'
               INSERT INTO ryx_file(ryx01,ryx02,ryx03,ryx04,ryx05)
                    VALUES ('ryp_file','ryp01',g_ryx[ls_ac].ryx03,
                             g_ryx[ls_ac].ryx04,g_ryx[ls_ac].ryx05 )
            WHEN '2'
               INSERT INTO ryx_file(ryx01,ryx02,ryx03,ryx04,ryx05)
                    VALUES ('ryq_file','ryq01',g_ryx[ls_ac].ryx03,
                             g_ryx[ls_ac].ryx04,g_ryx[ls_ac].ryx05 )
            #FUN-CA0074-----add---str
            WHEN '3'
               INSERT INTO ryx_file(ryx01,ryx02,ryx03,ryx04,ryx05)
                    VALUES ('rzc_file','rzc01',g_ryx[ls_ac].ryx03,
                             g_ryx[ls_ac].ryx04,g_ryx[ls_ac].ryx05 )
            WHEN '4'
               INSERT INTO ryx_file(ryx01,ryx02,ryx03,ryx04,ryx05)
                    VALUES ('rzd_file','rzd02',g_ryx[ls_ac].ryx03,
                             g_ryx[ls_ac].ryx04,g_ryx[ls_ac].ryx05 )
            #FUN-CA0074-----add---end
         END CASE 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ryx_file",g_ryx[ls_ac].ryx03,g_ryx[ls_ac].ryx04,
                          SQLCA.sqlcode,"","",0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET gs_rec_b=gs_rec_b+1
            DISPLAY gs_rec_b TO FORMONLY.cn2  
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ryx[ls_ac].* = g_ryx_t.*
            CLOSE i201_1_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ryx[ls_ac].ryx03,-263,1)
            LET g_ryx[ls_ac].* = g_ryx_t.*
         ELSE
           #FUN-CA0074---mark---str
           #IF gs_type = '1' THEN
           #   UPDATE ryx_file 
           #      SET ryx03 = g_ryx[ls_ac].ryx03,
           #          ryx04 = g_ryx[ls_ac].ryx04,
           #          ryx05 = g_ryx[ls_ac].ryx05
           #    WHERE ryx01 = 'ryp_file'
           #      AND ryx02 = 'ryp01'
           #      AND ryx03 = g_ryx_t.ryx03
           #      AND ryx04 = g_ryx_t.ryx04
           #ELSE
           #  UPDATE ryx_file
           #     SET ryx03 = g_ryx[ls_ac].ryx03,
           #         ryx04 = g_ryx[ls_ac].ryx04,
           #         ryx05 = g_ryx[ls_ac].ryx05
           #   WHERE ryx01 = 'ryq_file'
           #     AND ryx02 = 'ryq01'
           #     AND ryx03 = g_ryx_t.ryx03
           #     AND ryx04 = g_ryx_t.ryx04
           #END IF 
           #FUN-CA0074---mark---end

            #FUN-CA0074---add---str
            CASE gs_type
               WHEN '1'
                  UPDATE ryx_file
                     SET ryx03 = g_ryx[ls_ac].ryx03,
                         ryx04 = g_ryx[ls_ac].ryx04,
                         ryx05 = g_ryx[ls_ac].ryx05
                   WHERE ryx01 = 'ryp_file'
                     AND ryx02 = 'ryp01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '2'
                  UPDATE ryx_file
                     SET ryx03 = g_ryx[ls_ac].ryx03,
                         ryx04 = g_ryx[ls_ac].ryx04,
                         ryx05 = g_ryx[ls_ac].ryx05
                   WHERE ryx01 = 'ryq_file'
                     AND ryx02 = 'ryq01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '3'
                  UPDATE ryx_file
                     SET ryx03 = g_ryx[ls_ac].ryx03,
                         ryx04 = g_ryx[ls_ac].ryx04,
                         ryx05 = g_ryx[ls_ac].ryx05
                   WHERE ryx01 = 'rzc_file'
                     AND ryx02 = 'rzc01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '4'
                  UPDATE ryx_file
                     SET ryx03 = g_ryx[ls_ac].ryx03,
                         ryx04 = g_ryx[ls_ac].ryx04,
                         ryx05 = g_ryx[ls_ac].ryx05
                   WHERE ryx01 = 'rzd_file'
                     AND ryx02 = 'rzd02'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
            END CASE
            #FUN-CA0074---add---end
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ryx_file",g_ryx_t.ryx03,g_ryx_t.ryx04,
                            SQLCA.sqlcode,"","",0)
               LET g_ryx[ls_ac].* = g_ryx_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i201_1_bcl
               COMMIT WORK 
            END IF
         END IF
 
      AFTER ROW
         LET ls_ac = ARR_CURR()
        #LET l_ac_t = ls_ac    #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ryx[ls_ac].* = g_ryx_t.*
            END IF
            IF p_cmd = 'a' THEN
               CALL g_ryx.deleteElement(ls_ac)
               #FUN-D30033--add--begin--
               IF gs_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET ls_ac = l_ac_t
                  LET gs_flag = '1'   
               END IF
               #FUN-D30033--add--end----
            END IF 
            CLOSE i201_1_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = ls_ac   #FUN-D30033 add
         CLOSE i201_1_bcl
         COMMIT WORK

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()

   END INPUT
 
   CLOSE i201_1_bcl
   COMMIT WORK 
END FUNCTION

FUNCTION i201_1_b1()
   DEFINE l_ac_t          LIKE type_file.num5    
   DEFINE l_n             LIKE type_file.num5    
   DEFINE l_lock_sw       LIKE type_file.chr1    
   DEFINE p_cmd           LIKE type_file.chr1    
   DEFINE l_allow_insert  LIKE type_file.num5    
   DEFINE l_allow_delete  LIKE type_file.num5    
   DEFINE l_modify_flag   LIKE type_file.chr1
 
   LET g_action_choice = ""
   CALL cl_opmsg('b')
 
   IF s_shut(0) THEN 
      RETURN 
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   CASE  gs_type  
      WHEN '1'   
         LET gs_forupd_sql = " SELECT ryx03,ryx04,ryx05",   
                            "   FROM ryx_file ",
                            "  WHERE ryx01 = 'ryp_file' ",
                            "    AND ryx02= 'ryp01' ",
                            "    AND ryx03= ? AND ryx04 = ? ",
                            "    FOR UPDATE "
         LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
      WHEN '2'
         LET gs_forupd_sql = " SELECT ryx03,ryx04,ryx05",
                            "   FROM ryx_file ",
                            "  WHERE ryx01 ='ryq_file' ",
                            "    AND ryx02 ='ryq01' ",
                            "    AND ryx03 = ? AND ryx04 = ?",
                            "    FOR UPDATE "  
         LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
      #FUN-CA0074-----add---str
      WHEN '3'
         LET gs_forupd_sql = " SELECT ryx03,ryx04,ryx05",
                            "   FROM ryx_file ",
                            "  WHERE ryx01 = 'rzc_file' ",
                            "    AND ryx02= 'rzc01' ",
                            "    AND ryx03= ? AND ryx04 = ? ",
                            "    FOR UPDATE "
         LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
      WHEN '4'
         LET gs_forupd_sql = " SELECT ryx03,ryx04,ryx05",
                            "   FROM ryx_file ",
                            "  WHERE ryx01 = 'rzd_file' ",
                            "    AND ryx02 = 'rzd02' ",
                            "    AND ryx03= ? AND ryx04 = ? ",
                            "    FOR UPDATE "
         LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
      #FUN-CA0074-----add---end
   END CASE       
                      
   DECLARE i201_1_bcl1 CURSOR FROM gs_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_ryx WITHOUT DEFAULTS FROM s_ryx.*
      ATTRIBUTE(COUNT=gs_rec_b, MAXCOUNT= g_max_rec, UNBUFFERED,
                INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF gs_rec_b != 0 THEN
            CALL fgl_set_arr_curr(ls_ac)
         END IF 
      BEFORE ROW
         LET p_cmd = ''
         LET ls_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF gs_rec_b>=ls_ac THEN
            LET g_ryx_t.* = g_ryx[ls_ac].*  #BACKUP
            LET p_cmd='u'

            OPEN i201_1_bcl1 USING g_ryx_t.ryx03, g_ryx_t.ryx04
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN i201_1_bcl1',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i201_1_bcl1 INTO g_ryx[ls_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i201_1_bcl1',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ryx[ls_ac].* TO NULL      
         LET gs_before_input_done = FALSE
         LET gs_before_input_done = TRUE
 
         LET g_ryx[ls_ac].ryx03 = gs_no
         LET g_ryx_t.* = g_ryx[ls_ac].*         
         CALL cl_show_fld_cont()     
          
       AFTER FIELD ryx04
          IF NOT cl_null(g_ryx[ls_ac].ryx04) THEN
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ryx_t.ryx04 <> g_ryx[ls_ac].ryx04) THEN
                CALL i201_1_ryx_chk()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_ryx[ls_ac].ryx04 = g_ryx_t.ryx04
                   NEXT FIELD ryx04
                END IF
             END IF
          END IF

         
      BEFORE FIELD ryx05
         LET l_modify_flag = 'Y'
         IF l_lock_sw = 'Y' THEN            
            LET l_modify_flag = 'N'
         END IF
         IF l_modify_flag = 'N' THEN
            LET g_ryx[ls_ac].ryx03 = g_ryx_t.ryx03
            LET g_ryx[ls_ac].ryx03 = g_ryx_t.ryx04 
            DISPLAY g_ryx[ls_ac].ryx03 TO s_ryx[ls_ac].ryx03
            DISPLAY g_ryx[ls_ac].ryx04 TO s_ryx[ls_ac].ryx04
            NEXT FIELD ryx04
         END IF

      BEFORE DELETE                            
         IF g_ryx_t.ryx03 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            CASE gs_type
               WHEN '1'
                  DELETE FROM ryx_file 
                   WHERE ryx01 = 'ryp_file'
                     AND ryx02 = 'ryp01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '2'
                  DELETE FROM ryx_file
                   WHERE ryx01 = 'ryq_file'
                     AND ryx02 = 'ryq01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04       
               #FUN-CA0074-----add---str
               WHEN '3'
                  DELETE FROM ryx_file
                   WHERE ryx01 = 'rzc_file'
                     AND ryx02 = 'rzc01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '4'
                  DELETE FROM ryx_file
                   WHERE ryx01 = 'rzd_file'
                     AND ryx02 = 'rzd02'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               #FUN-CA0074-----add---end
            END CASE    
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gaz_file",g_ryx_t.ryx03,g_ryx_t.ryx04,
                             SQLCA.sqlcode,"","",0)
               EXIT INPUT
            END IF
            LET gs_rec_b=gs_rec_b-1
            DISPLAY gs_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i201_1_bcl
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         CASE gs_type
            WHEN '1'
               INSERT INTO ryx_file(ryx01,ryx02,ryx03,ryx04,ryx05)
                    VALUES ('ryp_file','ryp01',g_ryx[ls_ac].ryx03,
                             g_ryx[ls_ac].ryx04,g_ryx[ls_ac].ryx05 )
            WHEN '2'
               INSERT INTO ryx_file(ryx01,ryx02,ryx03,ryx04,ryx05)
                    VALUES ('ryq_file','ryq01',g_ryx[ls_ac].ryx03,
                             g_ryx[ls_ac].ryx04,g_ryx[ls_ac].ryx05 )
            #FUN-CA0074-----add---str
            WHEN '3'
               INSERT INTO ryx_file(ryx01,ryx02,ryx03,ryx04,ryx05)
                    VALUES ('rzc_file','rzc01',g_ryx[ls_ac].ryx03,
                             g_ryx[ls_ac].ryx04,g_ryx[ls_ac].ryx05 )
            WHEN '4'
               INSERT INTO ryx_file(ryx01,ryx02,ryx03,ryx04,ryx05)
                    VALUES ('rzd_file','rzd02',g_ryx[ls_ac].ryx03,
                             g_ryx[ls_ac].ryx04,g_ryx[ls_ac].ryx05 )
            #FUN-CA0074-----add---end
         END CASE 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ryx_file",g_ryx[ls_ac].ryx03,g_ryx[ls_ac].ryx04,
                          SQLCA.sqlcode,"","",0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET gs_rec_b=gs_rec_b+1
            DISPLAY gs_rec_b TO FORMONLY.cn2  
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ryx[ls_ac].* = g_ryx_t.*
            CLOSE i201_1_bcl
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ryx[ls_ac].ryx03,-263,1)
            LET g_ryx[ls_ac].* = g_ryx_t.*
         ELSE
           #FUN-CA0074----mark---str
           #IF gs_type = '1' THEN
           #   UPDATE ryx_file 
           #      SET ryx03 = g_ryx[ls_ac].ryx03,
           #          ryx04 = g_ryx[ls_ac].ryx04,
           #          ryx05 = g_ryx[ls_ac].ryx05
           #    WHERE ryx01 = 'ryp_file'
           #      AND ryx02 = 'ryp01'
           #      AND ryx03 = g_ryx_t.ryx03
           #      AND ryx04 = g_ryx_t.ryx04
           #ELSE
           #   UPDATE ryx_file
           #      SET ryx03 = g_ryx[ls_ac].ryx03,
           #          ryx04 = g_ryx[ls_ac].ryx04,
           #          ryx05 = g_ryx[ls_ac].ryx05
           #    WHERE ryx01 = 'ryq_file'
           #      AND ryx02 = 'ryq01'
           #      AND ryx03 = g_ryx_t.ryx03
           #      AND ryx04 = g_ryx_t.ryx04
           #END IF 
           #FUN-CA0074----mark---end 
            #FUN-CA0074----add---str
            CASE gs_type
               WHEN '1' 
                  UPDATE ryx_file
                     SET ryx03 = g_ryx[ls_ac].ryx03,
                         ryx04 = g_ryx[ls_ac].ryx04,
                         ryx05 = g_ryx[ls_ac].ryx05
                   WHERE ryx01 = 'ryp_file'
                     AND ryx02 = 'ryp01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '2'
                  UPDATE ryx_file
                     SET ryx03 = g_ryx[ls_ac].ryx03,
                         ryx04 = g_ryx[ls_ac].ryx04,
                         ryx05 = g_ryx[ls_ac].ryx05
                   WHERE ryx01 = 'ryq_file'
                     AND ryx02 = 'ryq01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '3'
                  UPDATE ryx_file
                     SET ryx03 = g_ryx[ls_ac].ryx03,
                         ryx04 = g_ryx[ls_ac].ryx04,
                         ryx05 = g_ryx[ls_ac].ryx05
                   WHERE ryx01 = 'rzc_file'
                     AND ryx02 = 'rzc01'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
               WHEN '4'
                  UPDATE ryx_file
                     SET ryx03 = g_ryx[ls_ac].ryx03,
                         ryx04 = g_ryx[ls_ac].ryx04,
                         ryx05 = g_ryx[ls_ac].ryx05
                   WHERE ryx01 = 'rzd_file'
                     AND ryx02 = 'rzd02'
                     AND ryx03 = g_ryx_t.ryx03
                     AND ryx04 = g_ryx_t.ryx04
            END CASE
            #FUN-CA0074----add---end
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ryx_file",g_ryx_t.ryx03,g_ryx_t.ryx04,
                            SQLCA.sqlcode,"","",0)
               LET g_ryx[ls_ac].* = g_ryx_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i201_1_bcl1
               #COMMIT WORK 
            END IF
         END IF
 
      AFTER ROW
         LET ls_ac = ARR_CURR()
        #LET l_ac_t = ls_ac  #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ryx[ls_ac].* = g_ryx_t.*
            END IF
            IF p_cmd = 'a' THEN
               CALL g_ryx.deleteElement(ls_ac)
               #FUN-D30033--add--begin--
               IF gs_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET ls_ac = l_ac_t
                  LET gs_flag = '2'   
               END IF
               #FUN-D30033--add--end----
            END IF 
            CLOSE i201_1_bcl1
            EXIT INPUT
         END IF
         LET l_ac_t = ls_ac  #FUN-D30033 add
         CLOSE i201_1_bcl1

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()

   END INPUT
 
   CLOSE i201_1_bcl1
END FUNCTION
 
FUNCTION i201_1_b_askkey()
   CLEAR FORM
   CALL g_ryx.clear()

   CONSTRUCT gs_wc2 ON ryx03,ryx04,ryx05
        FROM s_ryx[1].ryx03,s_ryx[1].ryx04,s_ryx[1].ryx05
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON IDLE g_idle_seconds  
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL i201_1_b_fill(gs_wc2)
END FUNCTION
 
FUNCTION i201_1_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2      LIKE type_file.chr1000 
 

  #FUN-CA0074----mark----str 
  #IF gs_type = '1' THEN  
  #   LET gs_sql = " SELECT ryx03,ryx04,ryx05 ", 
  #                "   FROM ryx_file",
  #                "  WHERE ryx01 = 'ryp_file'", 
  #                "    AND ryx02 = 'ryp01'",
  #                "    AND ryx03 = '",gs_no,"'",  
  #                "    AND ",p_wc2 CLIPPED,
  #                "  ORDER BY ryx03,ryx04 "
  #ELSE 
  #   LET gs_sql = " SELECT ryx03,ryx04,ryx05 ",
  #                "   FROM ryx_file",
  #                "  WHERE ryx01 = 'ryq_file' ",
  #                "    AND ryx02 = 'ryq01'",
  #                "    AND ryx03 = '",gs_no,"'",
  #                "    AND ",p_wc2 CLIPPED,
  #                "  ORDER BY ryx03,ryx04 "
  #END IF 
  #FUN-CA0074----mark----end

   #FUN-CA0074----add----str
   CASE gs_type
        WHEN '1'
           LET gs_sql = " SELECT ryx03,ryx04,ryx05 ",
                        "   FROM ryx_file",
                        "  WHERE ryx01 = 'ryp_file'",
                        "    AND ryx02 = 'ryp01'",
                        "    AND ryx03 = '",gs_no,"'",
                        "    AND ",p_wc2 CLIPPED,
                        "  ORDER BY ryx03,ryx04 "
        WHEN '2'
           LET gs_sql = " SELECT ryx03,ryx04,ryx05 ",
                        "   FROM ryx_file",
                        "  WHERE ryx01 = 'ryq_file'",
                        "    AND ryx02 = 'ryq01'",
                        "    AND ryx03 = '",gs_no,"'",
                        "    AND ",p_wc2 CLIPPED,
                        "  ORDER BY ryx03,ryx04 "
        WHEN '3'
           LET gs_sql = " SELECT ryx03,ryx04,ryx05 ",
                        "   FROM ryx_file",
                        "  WHERE ryx01 = 'rzc_file'",
                        "    AND ryx02 = 'rzc01'",
                        "    AND ryx03 = '",gs_no,"'",
                        "    AND ",p_wc2 CLIPPED,
                        "  ORDER BY ryx03,ryx04 "
        WHEN '4'
           LET gs_sql = " SELECT ryx03,ryx04,ryx05 ",
                        "   FROM ryx_file",
                        "  WHERE ryx01 = 'rzd_file'",
                        "    AND ryx02 = 'rzd02'",
                        "    AND ryx03 = '",gs_no,"'",
                        "    AND ",p_wc2 CLIPPED,
                        "  ORDER BY ryx03,ryx04 "
   END CASE
   #FUN-CA0074----add----end
 
   PREPARE i201_1_pb FROM gs_sql
   DECLARE ryx_curs CURSOR FOR i201_1_pb
 
   CALL g_ryx.clear()
   LET gs_cnt = 1
   MESSAGE "Searching!" 
   FOREACH ryx_curs INTO g_ryx[gs_cnt].*   #單身 ARRAY 填充
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET gs_cnt = gs_cnt + 1
 
      IF gs_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ryx.deleteElement(gs_cnt)
   MESSAGE ""
   LET gs_rec_b = gs_cnt-1
   DISPLAY gs_rec_b TO FORMONLY.cn2  
   LET gs_cnt=0
END FUNCTION

FUNCTION i201_1_ryx_chk()
   DEFINE l_n         LIKE type_file.num10
   
   LET g_errno = ''

  #FUN-CA0074---mark---str
  #IF gs_type = '1' THEN
  #   SELECT COUNT(*) INTO l_n
  #     FROM ryx_file
  #    WHERE ryx01 = 'ryp_file'
  #      AND ryx02 = 'ryp01'
  #      AND ryx03 = gs_no
  #      AND ryx04 = g_ryx[ls_ac].ryx04
  #ELSE
  #   SELECT COUNT(*) INTO l_n
  #     FROM ryx_file
  #    WHERE ryx01 = 'ryq_file'
  #      AND ryx02 = 'ryq01'
  #      AND ryx03 = gs_no
  #      AND ryx04 = g_ryx[ls_ac].ryx04
  #END IF 
  #FUN-CA0074---mark---end

   #FUN-CA0074---add---str
   CASE gs_type 
      WHEN '1'
         SELECT COUNT(*) INTO l_n
           FROM ryx_file
          WHERE ryx01 = 'ryp_file'
            AND ryx02 = 'ryp01'
            AND ryx03 = gs_no
            AND ryx04 = g_ryx[ls_ac].ryx04
      WHEN '2'
         SELECT COUNT(*) INTO l_n
           FROM ryx_file
          WHERE ryx01 = 'ryq_file'
            AND ryx02 = 'ryq01'
            AND ryx03 = gs_no
            AND ryx04 = g_ryx[ls_ac].ryx04
      WHEN '3'
         SELECT COUNT(*) INTO l_n
           FROM ryx_file
          WHERE ryx01 = 'rzc_file'
            AND ryx02 = 'rzc01'
            AND ryx03 = gs_no
            AND ryx04 = g_ryx[ls_ac].ryx04
      WHEN '4'
         SELECT COUNT(*) INTO l_n
           FROM ryx_file
          WHERE ryx01 = 'rzd_file'
            AND ryx02 = 'rzd02'
            AND ryx03 = gs_no
            AND ryx04 = g_ryx[ls_ac].ryx04
   END CASE
   #FUN-CA0074---add---end
 
   IF l_n > 0 THEN
      LET g_errno = 'apc-185'
   END IF  
END FUNCTION
 
FUNCTION i201_1_bp(p_ud)
 
   DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
       RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_ryx TO s_ryx.* ATTRIBUTE(COUNT=gs_rec_b)
 
      BEFORE ROW
         LET ls_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
 
         ON ACTION query                  # Q.查詢
            LET g_action_choice="query"
            EXIT DISPLAY
 
         ON ACTION detail                 # B.單身
            LET g_action_choice="detail"
            EXIT DISPLAY
 
         ON ACTION help                   # H.說明
            LET g_action_choice="help"
            EXIT DISPLAY
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   
            CALL cl_set_combo_lang("ryx04")
            EXIT DISPLAY
 
         ON ACTION exit                   # Esc.結束
            LET g_action_choice="exit"
            EXIT DISPLAY
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET ls_ac = ARR_CURR()
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
    
      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-C40084 -------------------------------------------------------------------
