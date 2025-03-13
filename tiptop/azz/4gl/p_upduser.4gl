# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: p_upduser.4gl
# Descriptions...: 資料所有人/部門修改作業
# Date & Author..: 08/05/06 alex   #FUN-840222
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AC0036 10/12/29 By Jay 調整各DB利用sch_file取得table與field等資訊
 
DATABASE ds  #FUN-840222
 
GLOBALS "../../config/top.global"
 
   DEFINE g_tm       RECORD
            gaz01    LIKE gaz_file.gaz01,
            gaz03    LIKE gaz_file.gaz03,
            zz03     LIKE zz_file.zz03,
            gat01    LIKE gat_file.gat01,
            zx01_o   LIKE zx_file.zx01,
            zx01_n   LIKE zx_file.zx01,
            zx02_o   LIKE zx_file.zx02,
            zx02_n   LIKE zx_file.zx02,
            cnt_u    LIKE type_file.num5,
            gem01_o  LIKE gem_file.gem01,
            gem01_n  LIKE gem_file.gem01,
            gem03_o  LIKE gem_file.gem03,
            gem03_n  LIKE gem_file.gem03,
            cnt_g    LIKE type_file.num5,
            azo06    LIKE azo_file.azo06
                 END RECORD
   DEFINE g_tab      DYNAMIC ARRAY OF RECORD
            tabid    LIKE gat_file.gat01,
            userid   LIKE gaq_file.gaq01,
            grupid   LIKE gaq_file.gaq01
                 END RECORD
   DEFINE g_whereu   STRING                  #組完後移入g_qryparam.where
   DEFINE g_whereg   STRING                  #組完後移入g_qryparam.where
   DEFINE g_before_input_done   LIKE type_file.num5
 
MAIN
 
   DEFINE ls_sql   STRING
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   OPEN WINDOW p_upduser_w WITH FORM "azz/42f/p_upduser"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET ls_sql = " SELECT gat03 FROM gat_file ",
                 " WHERE gat01 = ? AND gat02 = ? "
   PREPARE p_upduser_gat03 FROM ls_sql
 
   CALL p_upduser_i()
 
   CLOSE WINDOW p_upduser_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION p_upduser_i()
 
    DEFINE li_exit    LIKE type_file.num5
    DEFINE li_cnt     LIKE type_file.num5
    DEFINE ls_sql     STRING
 
    WHILE TRUE
 
       LET li_exit = FALSE
       INITIALIZE g_tm.* TO NULL
       CLEAR FORM
 
       INPUT BY NAME g_tm.* WITHOUT DEFAULTS
 
          BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL p_upduser_set_entry()
             CALL p_upduser_set_no_entry()
             LET g_before_input_done = TRUE
 
          AFTER FIELD gaz01
             SELECT count(*) INTO li_cnt FROM zz_file
              WHERE zz01=g_tm.gaz01 AND zz011 <> "MENU"
             IF li_cnt < 1 THEN
                CALL cl_err("Program ID Not Exists OR It's a Menu!","!",1)
                NEXT FIELD gaz01
             END IF
             SELECT zz03 INTO g_tm.zz03 FROM zz_file
              WHERE zz01=g_tm.gaz01
             LET g_tm.gaz03 = cl_get_progname(g_tm.gaz01,g_lang)
             DISPLAY BY NAME g_tm.gaz03,g_tm.zz03
             IF g_tm.zz03 <> "I" AND g_tm.zz03 <> "T" AND g_tm.zz03 <> "S" THEN
                CALL cl_err("Program Catagory Not Be Allowed Process!","!",1)
                NEXT FIELD gaz01
             END IF
             IF NOT p_upduser_chk_gat01() THEN
                CALL cl_err("Not Record User/Group OR No any Table be Used!","!",1)
                NEXT FIELD gaz01
             ELSE
                DISPLAY BY NAME g_tm.gat01
             END IF
 
          AFTER FIELD gat01
             LET g_whereu = " 1=1 " LET g_whereg = " 1=1 "
             FOR li_cnt = 1 TO g_tab.getLength()
                IF g_tab[li_cnt].tabid = g_tm.gat01 THEN
                   LET g_whereu = " zx01 IN (SELECT ",g_tab[li_cnt].userid CLIPPED," FROM ",g_tab[li_cnt].tabid CLIPPED," ) "
                   LET g_whereg = " gem01 IN (SELECT ",g_tab[li_cnt].grupid CLIPPED," FROM ",g_tab[li_cnt].tabid CLIPPED," ) "
                   EXIT FOR
                END IF
             END FOR
             #DISPLAY "User Where append:",g_whereu
             #DISPLAY "Grup Where append:",g_whereg
 
          BEFORE FIELD zx01_o
             CALL p_upduser_set_entry()
 
          AFTER FIELD zx01_o
             LET g_tm.cnt_u = 0
             IF NOT cl_null(g_tm.zx01_o) THEN
                SELECT count(*) INTO li_cnt FROM zx_file WHERE zx01=g_tm.zx01_o
                IF li_cnt < 1 THEN
                   CALL cl_err("The Username is invalid!","!",1)
                   NEXT FIELD zx01_o
                END IF
                FOR li_cnt = 1 TO g_tab.getLength()
                   IF g_tab[li_cnt].tabid = g_tm.gat01 THEN
                      LET ls_sql = "SELECT COUNT(*) FROM ",g_tm.gat01 CLIPPED,
                                   " WHERE ",g_tab[li_cnt].userid CLIPPED,"='",g_tm.zx01_o CLIPPED,"' "
                      EXIT FOR
                   END IF
                END FOR
                PREPARE p_upduser_cntu FROM ls_sql
                EXECUTE p_upduser_cntu INTO g_tm.cnt_u
             END IF
             LET g_tm.zx02_o = ""
             SELECT zx02 INTO g_tm.zx02_o FROM zx_file WHERE zx01=g_tm.zx01_o
             DISPLAY BY NAME g_tm.zx02_o,g_tm.cnt_u
             CALL p_upduser_set_no_entry()
 
          BEFORE FIELD zx01_n
             CALL p_upduser_set_entry()
 
          AFTER FIELD zx01_n
             IF NOT cl_null(g_tm.zx01_n) THEN
                SELECT count(*) INTO li_cnt FROM zx_file WHERE zx01=g_tm.zx01_n
                IF li_cnt < 1 THEN
                   CALL cl_err("The Username is invalid!","!",1)
                   NEXT FIELD zx01_n
                END IF
             END IF
             LET g_tm.zx02_n = ""
             SELECT zx02 INTO g_tm.zx02_n FROM zx_file WHERE zx01=g_tm.zx01_n
             DISPLAY BY NAME g_tm.zx02_n
             CALL p_upduser_set_no_entry()
 
          BEFORE FIELD gem01_o
             CALL p_upduser_set_entry()
 
          AFTER FIELD gem01_o
             LET g_tm.cnt_g = 0
             IF NOT cl_null(g_tm.gem01_o) THEN
                SELECT count(*) INTO li_cnt FROM gem_file WHERE gem01=g_tm.gem01_o
                IF li_cnt < 1 THEN
                   CALL cl_err("The Group ID is invalid!","!",1)
                   NEXT FIELD gem01_o
                END IF
                FOR li_cnt = 1 TO g_tab.getLength()
                   IF g_tab[li_cnt].tabid = g_tm.gat01 THEN
                      LET ls_sql = "SELECT COUNT(*) FROM ",g_tm.gat01 CLIPPED,
                                   " WHERE ",g_tab[li_cnt].grupid CLIPPED,"='",g_tm.gem01_o CLIPPED,"' "
                      EXIT FOR
                   END IF
                END FOR
                PREPARE p_upduser_cntg FROM ls_sql
                EXECUTE p_upduser_cntg INTO g_tm.cnt_g
             END IF
             LET g_tm.gem03_o = ""
             SELECT gem03 INTO g_tm.gem03_o FROM gem_file WHERE gem01=g_tm.gem01_o
             DISPLAY BY NAME g_tm.gem03_o,g_tm.cnt_g
             CALL p_upduser_set_no_entry()
 
          BEFORE FIELD gem01_n
             CALL p_upduser_set_entry()
 
          AFTER FIELD gem01_n
             IF NOT cl_null(g_tm.gem01_n) THEN
                SELECT count(*) INTO li_cnt FROM gem_file WHERE gem01=g_tm.gem01_n
                IF li_cnt < 1 THEN
                   CALL cl_err("The Group ID is invalid!","!",1)
                   NEXT FIELD gem01_n
                END IF
             END IF
             LET g_tm.gem03_n = ""
             SELECT gem03 INTO g_tm.gem03_n FROM gem_file WHERE gem01=g_tm.gem01_n
             DISPLAY BY NAME g_tm.gem03_n
             CALL p_upduser_set_no_entry()
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(gaz01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz"
                   LET g_qryparam.default1= g_tm.gaz01
                   LET g_qryparam.arg1 = g_lang CLIPPED
                   CALL cl_create_qry() RETURNING g_tm.gaz01
                   DISPLAY BY NAME g_tm.gaz01
                   NEXT FIELD gaz01
 
                WHEN INFIELD(zx01_o) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zx"
                   LET g_qryparam.where = g_whereu
                   LET g_qryparam.default1= g_tm.zx01_o
                   CALL cl_create_qry() RETURNING g_tm.zx01_o
                   DISPLAY BY NAME g_tm.zx01_o
                   NEXT FIELD zx01_o
 
                WHEN INFIELD(zx01_n) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zx"
                   LET g_qryparam.default1= g_tm.zx01_n
                   CALL cl_create_qry() RETURNING g_tm.zx01_n
                   DISPLAY BY NAME g_tm.zx01_n
                   NEXT FIELD zx01_n
 
                WHEN INFIELD(gem01_o) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.where = g_whereg
                   LET g_qryparam.default1= g_tm.gem01_o
                   CALL cl_create_qry() RETURNING g_tm.gem01_o
                   DISPLAY BY NAME g_tm.gem01_o
                   NEXT FIELD gem01_o
 
                WHEN INFIELD(gem01_n) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.default1= g_tm.gem01_n
                   CALL cl_create_qry() RETURNING g_tm.gem01_n
                   DISPLAY BY NAME g_tm.gem01_n
                   NEXT FIELD gem01_n
             END CASE
 
          ON ACTION locale
             CALL cl_dynamic_locale()
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
          ON IDLE g_idle_seconds  #FUN-860033
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION exit
             LET li_exit = TRUE
             EXIT INPUT
 
       END INPUT
       IF INT_FLAG OR li_exit THEN
          LET INT_FLAG = 0
          EXIT WHILE
       END IF
 
       IF NOT p_upduser_action() THEN
          CALL cl_err("Error to Interrupt Program,Plz Try Again!","!",1)
       END IF
    END WHILE
 
END FUNCTION
 
 
FUNCTION p_upduser_chk_gat01() 
 
    DEFINE li_cnt   LIKE type_file.num5
    DEFINE l_sql    STRING
    DEFINE lc_zr02  LIKE zr_file.zr02
    DEFINE lc_gaq01 LIKE gaq_file.gaq01
    DEFINE lc_gat03 LIKE gat_file.gat03
    DEFINE li_user,li_grup   LIKE type_file.num5
    DEFINE ls_tmp1,ls_tmp2   STRING
    DEFINE li_first LIKE type_file.num5
 
    CALL g_tab.clear()
 
    SELECT COUNT(*) INTO li_cnt FROM zr_file
     WHERE zr01=g_tm.gaz01 AND zr03 = "I"
    IF li_cnt < 1 THEN
       RETURN FALSE
    END IF
 
    LET l_sql= " SELECT zr02 FROM zr_file ",
                " WHERE zr01='",g_tm.gaz01 CLIPPED,"' ",
                  " AND zr03='I' ORDER BY zr02 " 
    LET ls_tmp1 = ""
    LET ls_tmp2 = ""
    LET li_cnt = 1
    LET li_first = TRUE
    DECLARE p_upduser_ckzr02 CURSOR FROM l_sql
    FOREACH p_upduser_ckzr02 INTO lc_zr02
 
        #列出不須/不可執行的 table
 
 
        LET li_user = FALSE
        LET li_grup = FALSE
        #---FUN-AC0036---start-----
        #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
        #目前統一用sch_file紀錄TIPTOP資料結構
        #CASE cl_db_get_database_type()
        #   WHEN "ORA"
        #      LET l_sql= " SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS ",
        #                  " WHERE TABLE_NAME = UPPER('",lc_zr02 CLIPPED,"') ",
        #                    " AND OWNER ='DS' ",
        #                  " ORDER BY COLUMN_ID "
        #   WHEN "IFX"
        #      LET l_sql = " SELECT colname FROM ds:syscolumns col,systables tab ",
        #                   " WHERE tab.tabname = '",lc_zr02 CLIPPED ,"' ",
        #                     " AND tab.tabid = col.tabid ",
        #                   " ORDER BY colno "
        #END CASE
        LET l_sql = " SELECT sch02 FROM sch_file ",
                    "   WHERE sch01 = '", lc_zr02 CLIPPED, "'",
                    "   ORDER BY sch05"
        #---FUN-AC0036---end-------
        DECLARE p_upduser_ckgat CURSOR FROM l_sql
        FOREACH p_upduser_ckgat INTO lc_gaq01
 
           LET lc_gaq01 = DOWNSHIFT(lc_gaq01 CLIPPED)
           IF lc_gaq01 MATCHES "*user" THEN
              LET li_user = TRUE
              LET g_tab[li_cnt].tabid = lc_zr02
              LET g_tab[li_cnt].userid = lc_gaq01
           END IF
           IF lc_gaq01 MATCHES "*grup" THEN
              LET li_grup = TRUE
              LET g_tab[li_cnt].tabid = lc_zr02
              LET g_tab[li_cnt].grupid = lc_gaq01
           END IF
           IF li_user AND li_grup THEN
              EXIT FOREACH
           END IF
        END FOREACH
 
        IF li_user OR li_grup THEN
           LET li_cnt = li_cnt + 1
           IF li_first THEN
              LET g_tm.gat01 = lc_zr02 CLIPPED 
              LET li_first = FALSE
           END IF
 
           LET ls_tmp1 = lc_zr02 CLIPPED,",",ls_tmp1.trim()
           EXECUTE p_upduser_gat03 USING lc_zr02,g_lang INTO lc_gat03
           LET ls_tmp2 = lc_gat03 CLIPPED," (",lc_zr02 CLIPPED,"),",ls_tmp2.trim()
        END IF
 
    END FOREACH
    LET li_cnt = li_cnt - 1
    LET ls_tmp1 = ls_tmp1.subString(1,ls_tmp1.getLength()-1)
    LET ls_tmp2 = ls_tmp2.subString(1,ls_tmp2.getLength()-1)
 
    CALL cl_set_combo_items("gat01",ls_tmp1,ls_tmp2)
    CALL ui.interface.refresh()
    RETURN TRUE
 
END FUNCTION
 
 
FUNCTION p_upduser_set_entry()
 
   CALL cl_set_comp_entry("zx01_o,zx01_n,gem01_o,gem01_n",TRUE)
   CALL cl_set_comp_required("zx01_o,zx01_n,gem01_o,gem01_n",FALSE)
 
END FUNCTION
 
FUNCTION p_upduser_set_no_entry()
 
   IF NOT cl_null(g_tm.zx01_o) OR NOT cl_null(g_tm.zx01_n) THEN
      CALL cl_set_comp_entry("gem01_o,gem01_n",FALSE)
      CALL cl_set_comp_required("zx01_o,zx01_n",TRUE)
   END IF
 
   IF NOT cl_null(g_tm.gem01_o) OR NOT cl_null(g_tm.gem01_n) THEN
      CALL cl_set_comp_entry("zx01_o,zx01_n",FALSE)
      CALL cl_set_comp_required("gem01_o,gem01_n",TRUE)
   END IF
 
END FUNCTION
 
 
FUNCTION p_upduser_action()
 
   DEFINE lc_act_type  LIKE type_file.chr1
   DEFINE lc_azo05     LIKE azo_file.azo05
   DEFINE ls_sql       STRING
   DEFINE li_cnt       LIKE type_file.num5
 
   IF cl_null(g_tm.gaz01) THEN
      CALL cl_err('',-400,0)
      RETURN FALSE
   END IF
   IF cl_null(g_tm.zx01_o) AND cl_null(g_tm.zx01_n) AND
      cl_null(g_tm.gem01_o) AND cl_null(g_tm.gem01_n) THEN
      CALL cl_err("Modified User/Group Should Be Defined one!","!",1)
      RETURN FALSE
   END IF
   CASE
      WHEN NOT cl_null(g_tm.zx01_o) OR NOT cl_null(g_tm.zx01_n) 
         IF cl_null(g_tm.zx01_o) THEN
            CALL cl_err("Original User ID Empty!","!",1)
            RETURN FALSE
         END IF
         IF cl_null(g_tm.zx01_n) THEN
            CALL cl_err("New User ID Empty!","!",1)
            RETURN FALSE
         END IF
         LET lc_act_type = "u"
      WHEN NOT cl_null(g_tm.gem01_o) OR NOT cl_null(g_tm.gem01_n)
         IF cl_null(g_tm.gem01_o) THEN
            CALL cl_err("Original Group ID Empty!","!",1)
            RETURN FALSE
         END IF
         IF cl_null(g_tm.gem01_n) THEN
            CALL cl_err("New Group ID Empty!","!",1)
            RETURN FALSE
         END IF
         LET lc_act_type = "g"
      OTHERWISE
         CALL cl_err("System Problem Occur!","!",1)
         RETURN FALSE
   END CASE
 
   IF NOT cl_sure(0,0) THEN
      RETURN TRUE
   END IF
 
   BEGIN WORK
   FOR li_cnt = 1 TO g_tab.getLength()
      IF g_tab[li_cnt].tabid = g_tm.gat01 THEN
         IF lc_act_type = "u" THEN
            LET ls_sql = "UPDATE ",g_tm.gat01 CLIPPED,
                           " SET ",g_tab[li_cnt].userid CLIPPED,"='",g_tm.zx01_n CLIPPED,"' ",
                         " WHERE ",g_tab[li_cnt].userid CLIPPED,"='",g_tm.zx01_o CLIPPED,"' "
         ELSE
            LET ls_sql = "UPDATE ",g_tm.gat01 CLIPPED,
                           " SET ",g_tab[li_cnt].grupid CLIPPED,"='",g_tm.gem01_n CLIPPED,"' ",
                         " WHERE ",g_tab[li_cnt].grupid CLIPPED,"='",g_tm.gem01_o CLIPPED,"' "
         END IF
         EXIT FOR
      END IF
   END FOR
   DISPLAY "Action SQL:",ls_sql
   PREPARE p_upduser_action FROM ls_sql
   EXECUTE p_upduser_action
   IF STATUS THEN
      CALL cl_err("p_upduser_action_curs:",SQLCA.SQLCODE,1)
      ROLLBACK WORK
      RETURN FALSE
   ELSE
      MESSAGE SQLCA.SQLERRD[3]," Row(s) Be Modified Successfully."
      COMMIT WORK
   END IF
 
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)        #FUN-980011 add
   VALUES("p_upduser",g_user,g_today,g_tm.gaz01,lc_azo05,g_tm.azo06,g_plant,g_legal)  #FUN-980011 add
   RETURN TRUE
 
END FUNCTION
 
