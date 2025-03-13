# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimi100_prt.4gl
# Descriptions...: 特性维护功能
# Date & Author..: TQC-B90236 11/10/09 BY yuhuabao
# Modify.........: No.TQC-C10054 12/01/16 By wuxj   資料同步，過單
# Modify.........: No.TQC-C20284 12/02/12 By zhuhao Action"特性維護"，if 特性主料(ima929) is not null 除歸屬層級="1.料號"的屬性值(imac05)可輸外，其餘欄位不可輸
# Modify.........: No.TQC-C20573 12/03/01 By yuhuabao 按"特性維護"時，檢查是否存在已確認的特性資料時，如已存不可維護，還是需要可看
# Modify.........: No.MOD-C30124 12/03/09 By yuhuabao 單身無資料時按單身會down掉
# Modify.........: No.MOD-C30191 12/03/10 By yuhuabao 資料確認后不可進行修改
# Modify.........: No.MOD-C30300 12/03/12 By yuhuabao 單身僅有歸屬製造批號的特性，則不能維護
# Modify.........: No.MOD-C30552 12/03/13 By yuhuabao 若母料已被使用為特性主料編號則不能維護特性資料
# Modify.........: No.TQC-C40023 12/04/06 By fengrui 添加項次大於等於零控管
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aimi100.global"

DEFINE g_imac        DYNAMIC ARRAY OF RECORD
          imac02     LIKE   imac_file.imac02,
          imac03     LIKE   imac_file.imac03,
          imac04     LIKE   imac_file.imac04,
          ini02      LIKE   ini_file.ini02,
          ini03      LIKE   ini_file.ini03,
          imac05     LIKE   imac_file.imac05
                     END  RECORD,
       g_imac_t      RECORD
          imac02     LIKE   imac_file.imac02,
          imac03     LIKE   imac_file.imac03,
          imac04     LIKE   imac_file.imac04,
          ini02      LIKE   ini_file.ini02,
          ini03      LIKE   ini_file.ini03,
          imac05     LIKE   imac_file.imac05
                     END  RECORD
DEFINE    l_ac_prt   LIKE   type_file.num5,
          l_cnt    LIKE   type_file.num5,
          l_rec_b  LIKE   type_file.num5,
          l_sql    STRING

FUNCTION i100_feature_maintain()
#DEFINE   l_n    LIKE   type_file.num5     #No.TQC-C20573 mark
   WHENEVER ERROR CALL cl_err_msg_log
   IF cl_null(g_ima.ima01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#No.TQC-C20573 ----- mark ----- begin
#   SELECT COUNT(*) INTO l_n FROM inj_file WHERE inj01 = g_ima.ima01
#   IF l_n <> 0 THEN #判斷是否存在特性資料
#      CALL cl_err('','aim1138',0)
#      RETURN
#   END IF
#No.TQC-C20573 ----- mark ----- end
   OPEN WINDOW i100_w_prt WITH FORM "aim/42f/aimi100_prt"
   CALL cl_ui_init()
   IF g_ima.ima928 = 'Y' THEN
      CALL cl_set_comp_visible("imac05",FALSE)  #特性值栏位隐藏
   ELSE
      CALL cl_set_comp_visible("imac05",TRUE)
   END IF

   LET l_sql = "SELECT imac02,imac03,imac04,'','',imac05",
               "  FROM imac_file",
               " WHERE imac01 = '",g_ima.ima01,"'",
               " ORDER BY imac02"
   PREPARE i100_prt_pre FROM l_sql
   DECLARE i100_prt_cs CURSOR FOR i100_prt_pre
   LET l_cnt = 1
   CALL g_imac.clear()
   FOREACH i100_prt_cs INTO g_imac[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      SELECT ini02,ini03 INTO g_imac[l_cnt].ini02,
                              g_imac[l_cnt].ini03
        FROM ini_file
       WHERE ini01 = g_imac[l_cnt].imac04
      LET l_cnt = l_cnt + 1
      IF l_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_imac.deleteElement(l_cnt)
   LET l_rec_b = l_cnt - 1
   LET l_cnt  = 0
   CALL i100_prt_menu()
   CLOSE WINDOW i100_w_prt
END FUNCTION

FUNCTION i100_prt_menu()
   DEFINE  l_n     LIKE   type_file.num5
   DEFINE  l_num   LIKE   type_file.num5  #TQC-C20284 
   DEFINE  l_str        STRING
   WHILE TRUE
      CALL i100_prt_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
              #TQC-C20284--add--begin
              IF NOT cl_null(g_ima.ima929) THEN
                 SELECT COUNT(*) INTO l_num FROM imac_file
                  WHERE imac01 = g_ima.ima01
                    AND imac03 = '1'
                 IF l_num > 0 THEN
                    CALL i100_prt_b()
                 ELSE                          #MOD-C30124 add     
                    LET g_action_choice = NULL #MOD-C30124 add
                 END IF
              ELSE
                 CALL i100_prt_b()
              END IF
              #TQC-C20284--add--end
              #CALL i100_prt_b()   #TQC-C20284  mark
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            SELECT COUNT(*) INTO l_n FROM imac_file
             WHERE imac03='1' AND (imac05 IS NULL)
               AND imac01 = g_ima.ima01
            IF l_n > 0 AND g_ima.ima928 <> 'Y' THEN
               IF cl_confirm('aim1115') THEN
                  EXIT WHILE
               ELSE
                  CONTINUE WHILE
               END IF
            ELSE
              EXIT WHILE
            END IF
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i100_prt_bp(p_ud)
DEFINE   p_ud    LIKE  type_file.chr1
   IF p_ud<>"G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = ""
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_imac TO s_imac.* ATTRIBUTE(COUNT = l_rec_b)
      BEFORE ROW
         LET l_ac_prt = ARR_CURR()
         CALL cl_show_fld_cont()
      ON ACTION detail
         LET g_action_choice = "detail"
         LET l_ac_prt        = 1
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

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac_prt = ARR_CURR()
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

      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION i100_prt_b()
   DEFINE  l_ac_t       LIKE type_file.num5,
           l_n          LIKE type_file.num5,
           l_lock_sw    LIKE type_file.chr1,
           p_cmd        LIKE type_file.chr1,
           l_allow_insert LIKE type_file.num5,
           l_allow_delete LIKE type_file.num5
   DEFINE  l_n1         LIKE type_file.num5,   #MOD-C30300 add
           l_n2         LIKE type_file.num5    #MOD-C30300 add
   LET g_action_choice = ""

   IF s_shut(0) THEN
      RETURN
   END IF
#MOD-C30552 ----- add ----- begin
   SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima929 = g_ima.ima01
   IF l_n <> 0 THEN
      CALL cl_err('','aim1155',0)
      RETURN
   END IF
#MOD-C30552 ----- add ----- end

#No.TQC-C20573 ----- add ----- begin
   SELECT COUNT(*) INTO l_n FROM inj_file WHERE inj01 = g_ima.ima01
                                            AND inj06 = 'Y'
   IF l_n <> 0 THEN #判斷是否存在已確認特性資料
      CALL cl_err('','aim1138',0)
      RETURN
   END IF
#MOD-C30191 ---- add ---- begin
   IF g_ima.ima1010 = '1' THEN
      CALL cl_err('','abm-879',0)
      RETURN
   END IF
#MOD-C30191 ---- add ---- end
#No.TQC-C20573 ----- add ----- end

#MOD-C30300 ----- add ------ begin
#單身僅有歸屬製造批號的特性，則不能維護
   IF NOT cl_null(g_ima.ima929) THEN
      SELECT COUNT(*) INTO l_n1 FROM imac_file
       WHERE imac01 = g_ima.ima01
         AND imac03 = '1'
      SELECT COUNT(*) INTO l_n2 FROM imac_file
       WHERE imac01 = g_ima.ima01
         AND imac03 = '2'
      IF l_n1 = 0 AND l_n2 > 0 THEN
         CALL cl_err('','aim1153',0)
         RETURN
      END IF
   END IF
#MOD-C30300 ----- add ------ end

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT imac02,imac03,imac04,'','',imac05",
                      "  FROM imac_file",
                      " WHERE imac01 = ? AND imac02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_prt_bcl CURSOR FROM g_forupd_sql

   IF g_ima.ima928 = 'Y' THEN
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
   ELSE
      IF cl_null(g_ima.ima929) THEN
         LET l_allow_insert = TRUE
         LET l_allow_delete = TRUE
      ELSE
         LET l_allow_insert = FALSE
         LET l_allow_delete = FALSE
      END IF
   END IF 

   INPUT ARRAY g_imac WITHOUT DEFAULTS FROM s_imac.*
       ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF l_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac_prt)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac_prt  = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n   = ARR_COUNT()

         BEGIN WORK

         IF l_rec_b >= l_ac_prt THEN
            LET p_cmd = 'u'
            LET g_imac_t.* = g_imac[l_ac_prt].*
            OPEN i100_prt_bcl USING g_ima.ima01,g_imac_t.imac02
            IF STATUS THEN
               CALL cl_err("OPEN i100_prt_bcl:",STATUS,0)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i100_prt_bcl INTO g_imac[l_ac_prt].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ima.ima01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT ini02,ini03 INTO g_imac[l_ac_prt].ini02,
                                       g_imac[l_ac_prt].ini03
                 FROM ini_file
                WHERE ini01 = g_imac[l_ac_prt].imac04
            END IF
            #TQC-C20284--add--begin
            IF NOT cl_null(g_ima.ima929) THEN
               IF g_imac[l_ac_prt].imac03 <> '1' THEN
                  CALL cl_err(g_imac[l_ac_prt].imac04,'aim1146',0)
                  RETURN
               END IF
            END IF
            #TQC-C20284--add--end
            CALL cl_show_fld_cont()
            CALL i100_prt_set_comp_entry()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_imac[l_ac_prt].* TO NULL
         LET g_imac[l_ac_prt].imac03 = '1'
         LET g_imac_t.* = g_imac[l_ac_prt].*

         CALL cl_show_fld_cont()
         CALL i100_prt_set_comp_entry()
         NEXT FIELD imac02
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i100_prt_bcl
            CANCEL INSERT
         END IF
         INSERT INTO imac_file(imac01,imac02,imac03,imac04,imac05,
                               imacuser,imacgrup,imacoriu,imacorig)
         VALUES(g_ima.ima01,g_imac[l_ac_prt].imac02,g_imac[l_ac_prt].imac03,
                g_imac[l_ac_prt].imac04,g_imac[l_ac_prt].imac05,
                g_user,g_grup,g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","imac_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT OK'
            LET l_rec_b = l_rec_b + 1
            COMMIT WORK
         END IF
      BEFORE FIELD imac02   #预设流水号
         IF g_imac[l_ac_prt].imac02 IS NULL 
            OR g_imac[l_ac_prt].imac02 = 0 THEN
            SELECT MAX(imac02)+1 INTO g_imac[l_ac_prt].imac02
              FROM imac_file
             WHERE imac01 = g_ima.ima01
            IF g_imac[l_ac_prt].imac02 IS NULL THEN
               LET g_imac[l_ac_prt].imac02 = 1
            END IF
         END IF

      AFTER FIELD imac02
         IF NOT cl_null(g_imac[l_ac_prt].imac02) THEN
            #TQC-C40023--add--str--
            IF g_imac[l_ac_prt].imac02 <= 0 THEN
               CALL cl_err('','aec-994',0)
               LET g_imac[l_ac_prt].imac02 = g_imac_t.imac02
               DISPLAY g_imac[l_ac_prt].imac02 TO imac02
               NEXT FIELD imac02
            END IF
            #TQC-C40023--add--end--
            IF g_imac[l_ac_prt].imac02 != g_imac_t.imac02
               OR g_imac_t.imac02 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM imac_file
                WHERE imac01 = g_ima.ima01
                  AND imac02 = g_imac[l_ac_prt].imac02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_imac[l_ac_prt].imac02 = g_imac_t.imac02
                  DISPLAY g_imac[l_ac_prt].imac02 TO imac02
                  NEXT FIELD imac02
               END IF
            END IF
         END IF

      AFTER FIELD imac03
         IF NOT cl_null(g_imac[l_ac_prt].imac03) THEN
            IF g_ima.ima918 != 'Y' AND 
               g_imac[l_ac_prt].imac03 = '2' THEN
               CALL cl_err('','aim1113',0)
               LET g_imac[l_ac_prt].imac03 = g_imac_t.imac03 
               DISPLAY g_imac[l_ac_prt].imac03 TO imac03
               NEXT FIELD imac03
            END IF
            #TQC-C40023--add--str--
            IF g_imac[l_ac_prt].imac04 = "purity"
               AND g_imac[l_ac_prt].imac03 != '2'  THEN
               CALL cl_err('','aim1156',0)
               LET g_imac[l_ac_prt].imac03 = g_imac_t.imac03
               DISPLAY g_imac[l_ac_prt].imac03 TO imac03
               NEXT FIELD imac03
            END IF 
            #TQC-C40023--add--end--
            CALL i100_prt_set_comp_entry()
         END IF

      AFTER FIELD imac04
         IF NOT cl_null(g_imac[l_ac_prt].imac04) THEN
            #同一料號下特性代碼不能相同
            IF g_imac_t.imac04 IS NULL OR
              (g_imac_t.imac04 != g_imac[l_ac_prt].imac04) THEN
               SELECT COUNT(*) INTO l_n FROM imac_file
                WHERE imac01 = g_ima.ima01
                  AND imac04 = g_imac[l_ac_prt].imac04
               IF l_n <> 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_imac[l_ac_prt].imac04 = g_imac_t.imac04
                  DISPLAY g_imac[l_ac_prt].imac04 TO imac04
                  NEXT FIELD imac04
               END IF
            END IF

            CALL i100_prt_imac04('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_imac[l_ac_prt].imac04 = g_imac_t.imac04
               DISPLAY g_imac[l_ac_prt].imac04 TO imac04
               NEXT FIELD imac04
            END IF
            IF g_imac[l_ac_prt].imac04 = "purity"
               AND g_imac[l_ac_prt].imac03 != '2'  THEN
               CALL cl_err('','aim1114',0)
               LET g_imac[l_ac_prt].imac04 = g_imac_t.imac04
               DISPLAY g_imac[l_ac_prt].imac04 TO imac04
               NEXT FIELD imac04
            END IF
            #屬性為數值時特性值需為數值
            IF g_imac[l_ac_prt].ini03 = '2' AND NOT cl_null(g_imac[l_ac_prt].imac05) 
               AND NOT cl_numchk(g_imac[l_ac_prt].imac05,40) THEN
               CALL cl_err('','aim1140',0)
               NEXT FIELD imac05
            END IF
            CALL i100_prt_set_comp_entry()
         END IF

      BEFORE FIELD imac05
         CALL i100_prt_set_comp_entry()
      AFTER FIELD imac05
        #屬性為數值時特性值需為數值
         IF g_imac[l_ac_prt].ini03 = '2' AND NOT cl_null(g_imac[l_ac_prt].imac05)
             AND NOT cl_numchk(g_imac[l_ac_prt].imac05,40) THEN
            CALL cl_err('','aim1140',0)
            LET g_imac[l_ac_prt].imac05 = g_imac_t.imac05
            NEXT FIELD imac05
         END IF

      BEFORE DELETE
         IF g_imac_t.imac02 IS NOT NULL AND 
            g_imac_t.imac02 > 0 THEN
            IF NOT cl_delete() THEN
               CANCEL delete
            END IF
            IF l_lock_sw = "Y"  THEN
               CALL cl_err('',-263,1)
               CANCEL delete
            END IF
            DELETE FROM imac_file
             WHERE imac01 = g_ima.ima01
               AND imac02 = g_imac_t.imac02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","imac_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET l_rec_b = l_rec_b - 1
         END IF
         COMMIT WORK
        
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_imac[l_ac_prt].* = g_imac_t.*
            CLOSE i100_prt_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = "Y" THEN
            CALL cl_err(g_imac[l_ac_prt].imac02,-263,1)
            LET g_imac[l_ac_prt].* = g_imac_t.*
         ELSE
            UPDATE imac_file SET   imac02  = g_imac[l_ac_prt].imac02,
                                   imac03  = g_imac[l_ac_prt].imac03,
                                   imac04  = g_imac[l_ac_prt].imac04,
                                   imac05  = g_imac[l_ac_prt].imac05,
                                   imacmodu = g_user,
                                   imacdate = g_today
             WHERE imac01 = g_ima.ima01
               AND imac02 = g_imac_t.imac02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","imac_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
               LET g_imac[l_ac_prt].* = g_imac_t.*
            ELSE
               MESSAGE 'UPDATE OK'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac_prt = ARR_CURR()
        #LET l_ac_t = l_ac_prt        #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_imac[l_ac_prt].* = g_imac_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_imac.deleteElement(l_ac_prt)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac_prt = l_ac_t
               END IF
            #FUN-D40030--add--end-- 
            END IF
            CLOSE i100_prt_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac_prt  #FUN-D40030 add
         IF g_ima.ima928 <> 'Y' THEN
            IF g_imac[l_ac_prt].imac03 = '1' THEN
               SELECT COUNT(*) INTO l_n FROM inj_file
                WHERE inj01 = g_ima.ima01
                  AND inj03 = g_imac[l_ac_prt].imac04
               IF l_n = 0 THEN
                  IF cl_null(g_imac[l_ac_prt].imac05) THEN
                     CALL cl_err('','aim1120',0)
                     NEXT FIELD imac05
                  END IF
               END IF
            END IF
         END IF
         CLOSE i100_prt_bcl
         COMMIT WORK
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(imac02) AND l_ac_prt > 1 THEN
            LET g_imac[l_ac_prt].* = g_imac[l_ac_prt-1].*
            LET g_imac[l_ac_prt].imac02 = NULL
            NEXT FIELD imac02
         END IF
      ON ACTION controlp
         CASE
            WHEN INFIELD(imac04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ini01"
               LET g_qryparam.default1 = g_imac[l_ac_prt].imac04
               CALL cl_create_qry() RETURNING g_imac[l_ac_prt].imac04
               CALL i100_prt_imac04('a')
               DISPLAY g_imac[l_ac_prt].imac04 TO imac04
               NEXT FIELD imac04
            OTHERWISE EXIT CASE
         END CASE
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
   END INPUT

   CLOSE i100_prt_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i100_prt_imac04(p_cmd)
DEFINE   p_cmd   LIKE  type_file.chr1,
         l_ini02 LIKE  ini_file.ini02,
         l_ini03 LIKE  ini_file.ini03
   LET g_errno = ''
   SELECT ini02,ini03 INTO l_ini02,l_ini03
     FROM ini_file
    WHERE ini01 = g_imac[l_ac_prt].imac04

   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'aim1112'
         LET l_ini02 = NULL
         LET l_ini03 = NULL
      OTHERWISE 
        LET g_errno = SQLCA.sqlcode USING '---------'
   END CASE
   IF cl_null(g_errno) OR p_cmd ='d' THEN
      LET g_imac[l_ac_prt].ini02 = l_ini02
      LET g_imac[l_ac_prt].ini03 = l_ini03
      DISPLAY l_ini02,l_ini03 TO ini02,ini03
   END IF
END FUNCTION

FUNCTION i100_prt_set_comp_entry()
DEFINE  l_n     LIKE  type_file.num5
   CALL cl_set_comp_entry("imac05",TRUE)
   CALL cl_set_comp_required("imac05",FALSE)
   IF g_ima.ima928 = 'N' THEN
      IF g_imac[l_ac_prt].imac03 = '1' THEN
         SELECT COUNT(*) INTO l_n FROM inj_file
          WHERE inj01 = g_ima.ima01
            AND inj03 = g_imac[l_ac_prt].imac04
         IF l_n<>0 THEN
            CALL cl_set_comp_entry("imac05",FALSE)
         ELSE
            CALL cl_set_comp_entry("imac05",TRUE)
            CALL cl_set_comp_required("imac05",TRUE)
         END IF
      ELSE
         CALL cl_set_comp_entry("imac05",FALSE)
      END IF
   #TQC-C20284--add--begin
      IF NOT cl_null(g_ima.ima929) THEN
         CALL cl_set_comp_entry("imac02,imac03,imac04",FALSE)
         IF g_imac[l_ac_prt].imac03 = '1' THEN
            CALL cl_set_comp_entry("imac05",TRUE)
         END IF
      ELSE
         CALL cl_set_comp_entry("imac02,imac03,imac04",TRUE)
      END IF
   #TQC-C20284--add--end
   END IF
END FUNCTION

#TQC-B90236---end--
#TQC-C10054---add--end---
