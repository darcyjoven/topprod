# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_sop.4gl
# Descriptions...: SOP情境資料維護作業
# Date & Author..: 04/03/16 By Nicola
# Modify.........: No.FUN-4A0085 04/10/28 By Raymon 新增單身資料轉 Excel 功能
# Modify.........: No.FUN-550041 05/05/13 By saki 將sop資料作成menu
# Modify.........: No.MOD-580056 05/08/04 By Yiting key可更改
# Modify.........: No.FUN-5A0015 05/12/29 By alex 增加上傳SOP文件及刪除SOP資料功能
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-920014 09/02/03 By Sarah 進入單身時"部門名稱"與"員工名稱"沒有show出來
# Modify.........: No.TQC-930150 09/04/01 By liuxqa 負責部門欄位沒有做控管。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........; No.FUN-B30176 11/03/25 By xianghui 使用iconv須區分為FOR UNIX& FOR Windows,批量去除$TOP
 
IMPORT os       #No.FUN-B30176 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_gba          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gba01       LIKE gba_file.gba01,
        gba011      LIKE gba_file.gba011,
        gba02       LIKE gba_file.gba02,
        gba021      LIKE gba_file.gba021,
        gba03       LIKE gba_file.gba03,
        gba04       LIKE gba_file.gba04,
        gba05       LIKE gba_file.gba05,
        gba06       LIKE gba_file.gba06,
        gba07       LIKE gba_file.gba07,
        gem02       LIKE gem_file.gem02,
        gba08       LIKE gba_file.gba08,
        gen02       LIKE gen_file.gen02,
        gba09       LIKE gba_file.gba09,
        gba10       LIKE gba_file.gba10,
        gba11       LIKE gba_file.gba11,
        gba12       LIKE gba_file.gba12
                    END RECORD,
    g_gba_t         RECORD
        gba01       LIKE gba_file.gba01,
        gba011      LIKE gba_file.gba011,
        gba02       LIKE gba_file.gba02,
        gba021      LIKE gba_file.gba021,
        gba03       LIKE gba_file.gba03,
        gba04       LIKE gba_file.gba04,
        gba05       LIKE gba_file.gba05,
        gba06       LIKE gba_file.gba06,
        gba07       LIKE gba_file.gba07,
        gem02       LIKE gem_file.gem02,
        gba08       LIKE gba_file.gba08,
        gen02       LIKE gen_file.gen02,
        gba09       LIKE gba_file.gba09,
        gba10       LIKE gba_file.gba10,
        gba11       LIKE gba_file.gba11,
        gba12       LIKE gba_file.gba12
                    END RECORD,
    g_wc2,g_sql     string,                  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #單身筆數             #No.FUN-680135 SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5     #NO.MOD-580056  #No.FUN-680135 SMALLINT
DEFINE g_forupd_sql STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose #No.FUN-680135 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0096
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680135   SMALLINT 
 
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p_sop_w AT p_row,p_col
     WITH FORM "azz/42f/p_sop"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gba04")
 
 
   LET g_wc2 = '1=1'
 
   CALL p_sop_b_fill(g_wc2)
 
   CALL p_sop_menu()
 
   CLOSE WINDOW p_sop_w                 #結束畫面
 
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
END MAIN
 
FUNCTION p_sop_menu()
 
   DEFINE l_cmd          STRING                #FUN-5A0015     VARCHAR(100),
   DEFINE ls_file        STRING                #FUN-5A0015
   DEFINE ls_server_file STRING                #FUN-5A0015
 
   WHILE TRUE
      CALL p_sop_bp("G")
      CASE g_action_choice
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_sop_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_sop_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         #No.FUN-550041 --start--
         WHEN "make_menu"
            IF cl_chk_act_auth() THEN
               CALL p_sop_make_menu()
            END IF
         #No.FUN-550041 ---end---
 
         WHEN "exporttoexcel"     #FUN-4A0085 By Raymon
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gba),'','')
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "update_sop_file"                  #FUN-5A0015
            IF cl_chk_act_auth() THEN
               IF NOT s_shut(0) AND NOT cl_null(g_gba[l_ac].gba10) AND
                                    NOT cl_null(g_gba[l_ac].gba04) THEN
                  LET ls_file = cl_browse_file()
                  IF NOT cl_null(ls_file) THEN
                     #不置於INPUT ARRAY是可避免使用者新增文件後又取消此筆資料
                    #LET ls_server_file="$TOP/doc/sop/",g_gba[l_ac].gba04 CLIPPED,       #FUN-B30176 mark
                    #                   "/",g_gba[l_ac].gba10 CLIPPED                    #FUN-B30176 mark
                     LET ls_server_file=FGL_GETENV("TOP"),os.Path.separator(),"doc",os.Path.separator(),   #FUN-B30176 add
                                        "sop",os.Path.separator(),g_gba[l_ac].gba04 CLIPPED,               #FUN-B30176 add
                                        os.Path.separator(),g_gba[l_ac].gba10 CLIPPED                      #FUN-B30176 add
                     LET l_cmd = "rm ",ls_server_file CLIPPED
                     RUN l_cmd
                     IF NOT cl_upload_file(ls_file, ls_server_file) THEN
                        CALL cl_err(NULL, "lib-212", 1)
                     ELSE
                        CALL cl_err_msg(NULL,"azz-232",ls_server_file.trim(),10)
                     END IF
                  END IF
               ELSE
                  CALL cl_err(NULL,"azz-231",1)
               END IF
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p_sop_q()
 
   CALL p_sop_b_askkey()
 
END FUNCTION
 
FUNCTION p_sop_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
   l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680135 SMALLINT
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680135 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680135 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680135 SMALLINT
   l_allow_delete  LIKE type_file.num5,    #可刪除否          #No.FUN-680135 SMALLINT
   l_cmd           STRING,                 #FUN-5A0015        VARCHAR(100)
   ls_server_file  STRING                  #FUN-5A0015
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   LET g_forupd_sql = "SELECT gba01,gba011,gba02,gba021,gba03,gba04,gba05,",
                      "       gba06,gba07,'',gba08,'',gba09,gba10,gba11,gba12",
                      "  FROM gba_file",
                      "  WHERE gba01 = ? AND gba02=?",
                      "   AND gba03=? AND gba04=?",
                      "   FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_sop_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gba WITHOUT DEFAULTS FROM s_gba.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gba_t.* = g_gba[l_ac].*  #BACKUP
        #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_sop_set_entry_b(p_cmd)
            CALL p_sop_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
        #No.MOD-580056 --end
 
            OPEN p_sop_bcl USING g_gba_t.gba01,g_gba_t.gba02,
                                 g_gba_t.gba03,g_gba_t.gba04
            IF STATUS THEN
               CALL cl_err("OPEN p_sop_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_sop_bcl INTO g_gba[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gba_t.gba01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
           #str MOD-920014 add
            SELECT gem02 INTO g_gba[l_ac].gem02 FROM gem_file
             WHERE gem01 = g_gba[l_ac].gba07
            SELECT gen02 INTO g_gba[l_ac].gen02 FROM gen_file
             WHERE gen01 = g_gba[l_ac].gba08
            DISPLAY BY NAME g_gba[l_ac].gem02,g_gba[l_ac].gen02
           #end MOD-920014 add
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gba[l_ac].* TO NULL      #900423
         LET g_gba_t.* = g_gba[l_ac].*         #新輸入資料
 #No.MOD-580056 --start
         LET g_before_input_done = FALSE
         CALL p_sop_set_entry_b(p_cmd)
         CALL p_sop_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gba01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE p_sop_bcl
            CANCEL INSERT
         END IF
         INSERT INTO gba_file(gba01,gba011,gba02,gba021,gba03,gba04,gba05,
                              gba06,gba07,gba08,gba09,gba10,gba11,gba12)
              VALUES(g_gba[l_ac].gba01,g_gba[l_ac].gba011,g_gba[l_ac].gba02,
                     g_gba[l_ac].gba021,g_gba[l_ac].gba03,g_gba[l_ac].gba04,
                     g_gba[l_ac].gba05,g_gba[l_ac].gba06,g_gba[l_ac].gba07,
                     g_gba[l_ac].gba08,g_gba[l_ac].gba09,g_gba[l_ac].gba10,
                     g_gba[l_ac].gba11,g_gba[l_ac].gba12)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gba[l_ac].gba01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gba_file",g_gba[l_ac].gba01,g_gba[l_ac].gba02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD gba01,gba02,gba03                #check KEY是否重複
         IF NOT cl_null(g_gba[l_ac].gba01) AND NOT cl_null(g_gba[l_ac].gba02)
            AND NOT cl_null(g_gba[l_ac].gba03) AND NOT cl_null(g_gba[l_ac].gba04) THEN
            IF g_gba[l_ac].gba01 != g_gba_t.gba01 OR cl_null(g_gba_t.gba01)
               OR g_gba[l_ac].gba02 != g_gba_t.gba02 OR cl_null(g_gba_t.gba02)
               OR g_gba[l_ac].gba03 != g_gba_t.gba03 OR cl_null(g_gba_t.gba03)
               OR g_gba[l_ac].gba04 != g_gba_t.gba04 OR cl_null(g_gba_t.gba04) THEN
               SELECT COUNT(*) INTO g_cnt FROM gba_file
                WHERE gba01 = g_gba[l_ac].gba01
                  AND gba02 = g_gba[l_ac].gba02
                  AND gba03 = g_gba[l_ac].gba03
                  AND gba04 = g_gba[l_ac].gba04
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gba[l_ac].gba01 = g_gba_t.gba01
                  LET g_gba[l_ac].gba02 = g_gba_t.gba02
                  LET g_gba[l_ac].gba03 = g_gba_t.gba03
                  LET g_gba[l_ac].gba04 = g_gba_t.gba04
                  NEXT FIELD gba01
               END IF
            END IF
         END IF
 
      AFTER FIELD gba04
         IF g_gba[l_ac].gba04 IS NOT NULL THEN
            IF g_gba[l_ac].gba04 NOT MATCHES '[012]' THEN
               NEXT FIELD gba04
            END IF
            IF NOT cl_null(g_gba[l_ac].gba01) AND NOT cl_null(g_gba[l_ac].gba02)
               AND NOT cl_null(g_gba[l_ac].gba03) AND NOT cl_null(g_gba[l_ac].gba04) THEN
               IF g_gba[l_ac].gba01 != g_gba_t.gba01 OR cl_null(g_gba_t.gba01)
                  OR g_gba[l_ac].gba02 != g_gba_t.gba02 OR cl_null(g_gba_t.gba02)
                  OR g_gba[l_ac].gba03 != g_gba_t.gba03 OR cl_null(g_gba_t.gba03)
                  OR g_gba[l_ac].gba04 != g_gba_t.gba04 OR cl_null(g_gba_t.gba04) THEN
                  SELECT COUNT(*) INTO g_cnt FROM gba_file
                   WHERE gba01 = g_gba[l_ac].gba01
                     AND gba02 = g_gba[l_ac].gba02
                     AND gba03 = g_gba[l_ac].gba03
                     AND gba04 = g_gba[l_ac].gba04
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_gba[l_ac].gba01 = g_gba_t.gba01
                     LET g_gba[l_ac].gba02 = g_gba_t.gba02
                     LET g_gba[l_ac].gba03 = g_gba_t.gba03
                     LET g_gba[l_ac].gba04 = g_gba_t.gba04
                     NEXT FIELD gba01
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD gba07
         IF NOT cl_null(g_gba[l_ac].gba07) THEN
#No.TQC-930150 add 把mark的地方重新放開
            SELECT COUNT(*) INTO g_cnt FROM gem_file
             WHERE gem01 = g_gba[l_ac].gba07
            IF g_cnt = 0 THEN
               CALL cl_err(g_gba[l_ac].gba07,"mfg9329",0)
               NEXT FIELD gba07
            ELSE
#No.TQC-930150 add --end 
               SELECT gem02 INTO g_gba[l_ac].gem02 FROM gem_file
                WHERE gem01 = g_gba[l_ac].gba07
               DISPLAY g_gba[l_ac].gem02 TO gem02
            END IF  #No.TQC-930150 把mark重新放開
         END IF
 
      AFTER FIELD gba08
         IF NOT cl_null(g_gba[l_ac].gba08) THEN
            SELECT COUNT(*) INTO g_cnt FROM gen_file
             WHERE gen01 = g_gba[l_ac].gba08
            IF g_cnt = 0 THEN
               CALL cl_err(g_gba[l_ac].gba08,"mfg9329",0)
               NEXT FIELD gba08
            ELSE
               SELECT gen02 INTO g_gba[l_ac].gen02 FROM gen_file
                WHERE gen01 = g_gba[l_ac].gba08
               DISPLAY g_gba[l_ac].gen02 TO gen02
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gba_t.gba01) THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gba_file WHERE gba01 = g_gba_t.gba01
                                   AND gba02 = g_gba_t.gba02
                                   AND gba03 = g_gba_t.gba03
                                   AND gba04 = g_gba_t.gba04
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gba_t.gba01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gba_file",g_gba_t.gba01,g_gba_t.gba02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               EXIT INPUT
            ELSE
               #FUN-5A0015
               IF NOT cl_null(g_gba[l_ac].gba10) THEN
                  IF cl_confirm("azz-233") THEN
                    #LET ls_server_file="$TOP/doc/sop/",g_gba[l_ac].gba04 CLIPPED,                         #FUN-B30176 amrk
                    #                   "/",g_gba[l_ac].gba10 CLIPPED                                      #FUN-B30176 amrk
                     LET ls_server_file=FGL_GETENV("TOP"),os.Path.separator(),"doc",os.Path.separator(),   #FUN-B30176 add
                                        "sop",os.Path.separator(),g_gba[l_ac].gba04 CLIPPED,               #FUN-B30176 add
                                        os.Path.separator(),g_gba[l_ac].gba10 CLIPPED                      #FUN-B30176 add
                     LET l_cmd = "rm ",ls_server_file CLIPPED
                     RUN l_cmd
                     CALL cl_err_msg(NULL,"azz-234",ls_server_file.trim(),10)
                  END IF
               END IF
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gba[l_ac].* = g_gba_t.*
            CLOSE p_sop_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_gba[l_ac].gba01,-263,0)
            LET g_gba[l_ac].* = g_gba_t.*
         ELSE
            UPDATE gba_file SET gba01 = g_gba[l_ac].gba01,
                                gba011 = g_gba[l_ac].gba011,
                                gba02 = g_gba[l_ac].gba02,
                                gba021 = g_gba[l_ac].gba021,
                                gba03 = g_gba[l_ac].gba03,
                                gba04 = g_gba[l_ac].gba04,
                                gba05 = g_gba[l_ac].gba05,
                                gba06 = g_gba[l_ac].gba06,
                                gba07 = g_gba[l_ac].gba07,
                                gba08 = g_gba[l_ac].gba08,
                                gba09 = g_gba[l_ac].gba09,
                                gba10 = g_gba[l_ac].gba10,
                                gba11 = g_gba[l_ac].gba11,
                                gba12 = g_gba[l_ac].gba12
             WHERE gba01 = g_gba_t.gba01
               AND gba02 = g_gba_t.gba02
               AND gba03 = g_gba_t.gba03
               AND gba04 = g_gba_t.gba04
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gba[l_ac].gba01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gba_file",g_gba_t.gba01,g_gba_t.gba02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_gba[l_ac].* = g_gba_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增
         LET l_ac_t = l_ac                # 新增
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gba[l_ac].* = g_gba_t.*
            END IF
            CLOSE p_sop_bcl            # 新增
            ROLLBACK WORK         # 新增
            EXIT INPUT
         END IF
         CLOSE p_sop_bcl            # 新增
         COMMIT WORK
 
    #  ON ACTION sop_status_process
    #     LET l_cmd = "p_sopno '",g_gba[l_ac].gba01,"' '",g_gba[l_ac].gba02,"' '",g_gba[l_ac].gba03,"' '",g_gba[l_ac].gba04,"'"
    #     CALL cl_cmdrun(l_cmd CLIPPED)
 
      ON ACTION open_file
          CALL open_sop_doc(g_gba[l_ac].gba10)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gba07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_gba[l_ac].gba07
               CALL cl_create_qry() RETURNING g_gba[l_ac].gba07
               DISPLAY g_gba[l_ac].gba07 TO gba07
#              CALL FGL_DIALOG_SETBUFFER(g_gba[l_ac].gba07 )
            WHEN INFIELD(gba08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_gba[l_ac].gba08
               CALL cl_create_qry() RETURNING g_gba[l_ac].gba08
               DISPLAY g_gba[l_ac].gba08 TO gba08
#              CALL FGL_DIALOG_SETBUFFER(g_gba[l_ac].gba08 )
            OTHERWISE
               EXIT CASE
          END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gba01) AND l_ac > 1 THEN
            LET g_gba[l_ac].* = g_gba[l_ac-1].*
            NEXT FIELD gba01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   END INPUT
 
   CLOSE p_sop_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_sop_b_askkey()
 
   CLEAR FORM
   CALL g_gba.clear()
 
   CONSTRUCT g_wc2 ON gba01,gba011,gba02,gba021,gba03,gba04,gba05,
                      gba06,gba07,gba08,gba09,gba10,gba11,gba12
        FROM s_gba[1].gba01,s_gba[1].gba011,s_gba[1].gba02,
             s_gba[1].gba021,s_gba[1].gba03,s_gba[1].gba04,
             s_gba[1].gba05,s_gba[1].gba06,s_gba[1].gba07,
             s_gba[1].gba08,s_gba[1].gba09,s_gba[1].gba10,
             s_gba[1].gba11,s_gba[1].gba12
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gba07)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_gba[1].gba07
            WHEN INFIELD(gba08)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_gba[1].gba08
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL p_sop_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_sop_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2  LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(200)
 
   LET g_sql = "SELECT gba01,gba011,gba02,gba021,gba03,gba04,gba05,",
               "       gba06,gba07,'',gba08,'',gba09,gba10,gba11,gba12",
               " FROM gba_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY gba01"
   PREPARE p_sop_pb FROM g_sql
   DECLARE gba_curs CURSOR FOR p_sop_pb
 
   CALL g_gba.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH gba_curs INTO g_gba[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT gem02 INTO g_gba[g_cnt].gem02 FROM gem_file
       WHERE gem01 = g_gba[g_cnt].gba07
 
      SELECT gen02 INTO g_gba[g_cnt].gen02 FROM gen_file
       WHERE gen01 = g_gba[g_cnt].gba08
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   MESSAGE ""
   CALL g_gba.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_sop_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
   DEFINE   l_cmd  LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(100)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gba TO s_gba.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("gba04")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION sop_status_process
         LET l_ac = ARR_CURR()
         LET l_cmd = "p_sopno '",g_gba[l_ac].gba01,"' '",g_gba[l_ac].gba02,"' '",g_gba[l_ac].gba03,"' '",g_gba[l_ac].gba04,"'"
         CALL cl_cmdrun(l_cmd CLIPPED)
 
      ON ACTION open_file
         LET l_ac = ARR_CURR()
         CALL open_sop_doc(g_gba[l_ac].gba10)
 
      ON ACTION update_sop_file           #FUN-5A0015
         LET g_action_choice="update_sop_file"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      #No.FUN-550041 --start--
      ON ACTION make_menu
         LET g_action_choice = "make_menu"
         EXIT DISPLAY
      #No.FUN-550041 ---end---
 
      ON ACTION exporttoexcel   #FUN-4A0085  By Raymon
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE            #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION open_sop_doc(ls_filename)
   DEFINE   ls_filename     STRING
   DEFINE   ls_help_url     STRING
 
   IF cl_null(ls_filename) THEN RETURN END IF
 
   LET ls_help_url = FGL_GETENV("FGLASIP"), "/tiptop/sop/", g_gba[l_ac].gba04, "/", ls_filename
 
   IF NOT cl_open_url(ls_help_url) THEN
      CALL cl_err(ls_filename.trim(), "azz-056", 1)
   END IF
END FUNCTION
 
#No.FUN-550041 --start--
FUNCTION p_sop_make_menu()
   DEFINE   ls_log_path    STRING
   DEFINE   ls_msg         STRING
   DEFINE   lc_menu_name   LIKE zm_file.zm01
   DEFINE   lc_version     LIKE gba_file.gba03
   DEFINE   li_max_cnt     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_cnt         LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_result      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_sql         STRING
   DEFINE   lr_gba         RECORD LIKE gba_file.* # SOP代碼資料
   DEFINE   lc_gbb05       LIKE gbb_file.gbb05    # 流程程式序號
   DEFINE   lc_gbb06       LIKE gbb_file.gbb06    # 流程順序
   DEFINE   lc_gbb08       LIKE gbb_file.gbb08    # 程式代碼
   DEFINE   lc_sop_code    LIKE zm_file.zm04
   DEFINE   li_i           LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_j           LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
 
   LET ls_log_path = FGL_GETENV("TOP"),"/log/system/zm_file.backup"
   LET lc_menu_name = "sop_menu"
 
   WHILE TRUE
      # 詢問要製造的情境資料版本
      LET ls_msg = cl_getmsg("azz-719",g_lang)
      PROMPT ls_msg CLIPPED || ":" FOR lc_version
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
         RETURN
      END IF
 
      # 檢查所輸入版本於sop資料中是否存在
      SELECT COUNT(*) INTO li_cnt FROM gba_file WHERE gba03 = lc_version
      IF li_cnt <= 0 THEN
         CALL cl_err(lc_version,"azz-720",1)
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
   END WHILE
 
   # 檢查SOP Menu名稱於zm_file中有沒有重複
   SELECT COUNT(*) INTO li_cnt FROM zm_file WHERE zm01 = lc_menu_name
   IF li_cnt > 0 THEN
      CALL cl_confirm("azz-716") RETURNING li_result
      IF (NOT li_result) THEN
         RETURN
      ELSE
         # 先備份目前資料庫的zm_file資料，有問題請倒回去
         UNLOAD TO ls_log_path SELECT * FROM zm_file
         CALL cl_err("","azz-715",1)
         CALL p_sop_delete_sop_menu(lc_menu_name)
      END IF
   END IF
 
   # 檢查有沒有其他節點用到sop menu
   SELECT COUNT(*) INTO li_cnt FROM zm_file
    WHERE zm01 != "root" AND zm04 = lc_menu_name
   IF li_cnt > 0 THEN
      CALL cl_err(lc_menu_name || " : ","azz-717",1)
      RETURN
   END IF
 
   # 檢查有沒有root的節點，如果沒有就建立
   SELECT COUNT(*) INTO li_cnt FROM zm_file WHERE zm01 = "root"
   IF li_cnt <= 0 THEN
      CALL p_sop_add_to_zz("root","root") RETURNING li_result
      IF (NOT li_result) THEN
         RETURN
      END IF
   END IF
 
   # 做第一層SOP Menu
   CALL p_sop_add_to_zz(lc_menu_name,lc_menu_name) RETURNING li_result
   IF (li_result) THEN
      SELECT zm03 INTO li_max_cnt FROM zm_file
       WHERE zm01 = "root" AND zm04 = lc_menu_name
      IF li_max_cnt <= 0 THEN
         SELECT MAX(zm03) INTO li_max_cnt FROM zm_file WHERE zm01 = "root"
         INSERT INTO zm_file VALUES ("root",li_max_cnt + 1,lc_menu_name)
      END IF
   END IF
 
   # 做第二層SOP Menu
   LET ls_sql = "SELECT * FROM gba_file ",
                " WHERE gba03 = '",lc_version,"' AND gba04 = '",g_lang,"'",
                " ORDER BY gba01"
   PREPARE gba_pre FROM ls_sql
   DECLARE menu_curs CURSOR FOR gba_pre
 
   LET li_i = 0
   FOREACH menu_curs INTO lr_gba.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      IF (cl_null(lr_gba.gba01)) OR (cl_null(lr_gba.gba02)) OR
         (cl_null(lr_gba.gba03)) OR (cl_null(lr_gba.gba04)) THEN
         CONTINUE FOREACH
      END IF
 
      LET li_i = li_i + 1
 
      # 為第二層Menu做zz_file的資訊
      LET lc_sop_code = "sop_" || DOWNSHIFT(lr_gba.gba01 CLIPPED)
      CALL p_sop_add_to_zz(lc_sop_code,lr_gba.gba011 CLIPPED || "_" || lr_gba.gba02 CLIPPED) RETURNING li_result
      IF (NOT li_result) THEN
         LET li_i = li_i - 1
         CONTINUE FOREACH
      END IF
 
      INSERT INTO zm_file VALUES (lc_menu_name,li_i,lc_sop_code)
      IF SQLCA.sqlcode THEN
         LET li_i = li_i - 1
         CONTINUE FOREACH
      END IF
 
      # 做第三層的SOP Menu
      LET ls_sql = "SELECT gbb05,gbb06,gbb08 FROM gbb_file ",
                   " WHERE gbb01 = '",lr_gba.gba01 CLIPPED,"' AND gbb02 = '",lr_gba.gba02 CLIPPED,"'",
                   "   AND gbb03 = '",lr_gba.gba03 CLIPPED,"' AND gbb04 = '",lr_gba.gba04 CLIPPED,"'",
                   " ORDER BY gbb05,gbb06"
      PREPARE gbb_pre FROM ls_sql
      DECLARE gbb_curs CURSOR FOR gbb_pre
 
      LET li_j = 0
      FOREACH gbb_curs INTO lc_gbb05,lc_gbb06,lc_gbb08
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
 
         IF (cl_null(lc_gbb08)) THEN
            CONTINUE FOREACH
         END IF
 
         LET li_j = li_j + 1
 
         SELECT COUNT(*) INTO li_cnt FROM zz_file WHERE zz01 = lc_gbb08
         IF li_cnt <= 0 THEN
            CALL cl_err_msg("","azz-718",lr_gba.gba01 CLIPPED || "|" || lr_gba.gba02 CLIPPED || "|" || lr_gba.gba03 CLIPPED || "|" || lr_gba.gba04 CLIPPED || "|" || lc_gbb05,1)
            LET li_j = li_j - 1
            CONTINUE FOREACH
         END IF
 
         INSERT INTO zm_file VALUES(lc_sop_code,li_j,lc_gbb08)
         IF SQLCA.sqlcode THEN
            LET li_j = li_j - 1
            CONTINUE FOREACH
         END IF
      END FOREACH
   END FOREACH
 
   # 重新製造root此節點的4sm(預設是只有此4sm有影響, 其餘不管)
   # 若沒有人用到root此節點就不製造
   SELECT COUNT(*) INTO li_cnt FROM zx_file WHERE zx05 = "root"
   IF li_cnt > 0 THEN
      CALL cl_create_4sm("root",TRUE)
   END IF
END FUNCTION
 
FUNCTION p_sop_delete_sop_menu(p_sopname)
   DEFINE   p_sopname   LIKE zm_file.zm01
   DEFINE   lc_zm03     LIKE zm_file.zm03
   DEFINE   lc_zm04     LIKE zm_file.zm04
   DEFINE   ls_sql      STRING
 
 
   IF cl_null(p_sopname) THEN
      RETURN
   END IF
 
   LET ls_sql = "SELECT zm03,zm04 FROM zm_file WHERE zm01 = '",p_sopname CLIPPED,"'"
   PREPARE zm_pre FROM ls_sql
   DECLARE zm_curs CURSOR FOR zm_pre
 
   FOREACH zm_curs INTO lc_zm03,lc_zm04
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      # 刪除zm_file資料
      DELETE FROM zm_file WHERE zm01 = lc_zm04
      IF SQLCA.sqlcode THEN
         MESSAGE lc_zm04 CLIPPED," delete zm_file error!"
      END IF
 
      # 刪除基本資料
      DELETE FROM zz_file WHERE zz01 = lc_zm04
      IF SQLCA.sqlcode THEN
         MESSAGE lc_zm04 CLIPPED," delete zz_file error!"
      END IF
      DELETE FROM gaz_file WHERE gaz01 = lc_zm04
      IF SQLCA.sqlcode THEN
         MESSAGE lc_zm04 CLIPPED," delete gaz_file error!"
      END IF
   END FOREACH
 
   DELETE FROM zm_file WHERE zm01 = p_sopname
   IF SQLCA.sqlcode THEN
      MESSAGE p_sopname CLIPPED," delete zm_file error!"
   END IF
   DELETE FROM zz_file WHERE zz01 = p_sopname
   IF SQLCA.sqlcode THEN
      MESSAGE p_sopname CLIPPED," delete zz_file error!"
   END IF
   DELETE FROM gaz_file WHERE gaz01 = p_sopname
   IF SQLCA.sqlcode THEN
      MESSAGE p_sopname CLIPPED," delete gaz_file error!"
   END IF
 
   DELETE FROM zm_file WHERE zm01 = "root" AND zm04 = p_sopname
   IF SQLCA.sqlcode THEN
      MESSAGE p_sopname CLIPPED," delete zm_file error!"
   END IF
END FUNCTION
 
FUNCTION p_sop_add_to_zz(p_prog,p_progname)
   DEFINE   p_prog      LIKE zz_file.zz01
   DEFINE   p_progname  LIKE gaz_file.gaz03
   DEFINE   lc_unixcmd  LIKE zz_file.zz08
   DEFINE   li_cnt      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_result   LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
 
   LET li_result = TRUE
   IF (cl_null(p_prog)) THEN
      RETURN FALSE
   END IF
 
   SELECT COUNT(*) INTO li_cnt FROM zz_file WHERE zz01 = p_prog
   IF li_cnt <= 0 THEN
      LET lc_unixcmd = "$FGLRUN $MENUi/" || p_prog
      INSERT INTO zz_file (zz01,zz011,zz03,zz05,zz06,zz08,zz13,zz15,
                           zz25,zz26,zz27,zz28,zz29,zz30,
                           zzuser,zzgrup,zzmodu,zzdate,zzoriu,zzorig)
           VALUES (p_prog,"MENU","M","N","1",lc_unixcmd,"N","N",
                   "N","N","sm1","N","1",0,g_user,g_grup,"",g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      IF SQLCA.sqlcode THEN
         LET li_result = FALSE
      END IF
   END IF
 
   SELECT COUNT(*) INTO li_cnt FROM gaz_file WHERE gaz01 = p_prog
   IF li_cnt <= 0 THEN
      INSERT INTO gaz_file (gaz01,gaz02,gaz03,gaz05,gazuser,gazgrup,gazmodu,gazdate,gazoriu,gazorig)
           VALUES (p_prog,g_lang,p_progname,"N",g_user,g_grup,"",TODAY, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      IF SQLCA.sqlcode THEN
         LET li_result = FALSE
      END IF
   END IF
 
   RETURN li_result
END FUNCTION
#No.FUN-550041 ---end---
 
 
 #NO.MOD-580056
FUNCTION p_sop_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gba01,gba02,gba03,gba04",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_sop_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gba01,gba02,gba03,gba04",FALSE)
   END IF
 
END FUNCTION
 #No.MOD-580056 --end
 
#Patch....NO.TQC-610037 <001> #
