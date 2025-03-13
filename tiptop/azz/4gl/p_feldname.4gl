# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_feldname.4gl
# Descriptions...: 欄位名稱維護作業
# Date & Author..: 04/12/17 alex
# Modify.........: No.MOD-440464 05/02/02 By saki 增加log功能
# Modify.........: No.MOD-530136 05/02/02 By Carrier 資料筆數錯誤
# Modify.........: No.FUN-540019 05/04/26 By saki 增加TEXTEDIT hint顯示
# Modify.........: No.FUN-550037 05/05/12 By saki 欄位comment顯示
# Modify.........: No.MOD-580056 05/08/04 By yiting key可更改
# Modify.........: No.MOD-580359 05/08/30 By alex 移除不需要的 output
# Modify.........: No.FUN-660025 06/06/13 By Nicola 增加欄位gaq06(Unicode否)
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.TQC-680009 06/08/04 By rainy 1.新增"所屬欄位型態"(gaq07)
#                                                  2.開窗顯示語言別:0的讓user直接輸入所屬欄位型態
# Modify.........: No.FUN-680031 06/08/10 By rainy 將gaq06(Unicode)拿掉,更改欄位屬性畫面加簡稱(gck02)
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-730018 06/03/23 By kim 增加欄位用途欄位(gaq06)
# Modify.........: No.FUN-750034 07/06/25 By rainy 新增欄位型態長度及屬性型態
# Modify.........: No.FUN-770078 07/07/20 By Nicola 新增欄位異動日期(gaq08)
# Modify.........: No.TQC-780068 07/08/30 By rainy za*資料在DS以外的資料庫無法查出資料
# Modify.........: No.FUN-810060 08/01/22 By alex 增加 SQL Server處理段
# Modify.........: No.FUN-820009 08/02/13 By alex 修訂欄位應顯示名稱
# Modify.........: No.MOD-890296 07/10/01 By alexstar oracle10g的all_tab_columns會包含已刪除的資料,會重複
# Modify.........: No.TQC-970259 09/07/23 By kevin 改成MSV語法
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-AA0017 10/10/19 By alex 新增ASE語法
# Modify.........: No.FUN-AA0073 10/10/19 By kevin 加入Sybase columns type
# Modify.........: No.FUN-AC0036 10/12/28 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No:FUN-B90139 11/09/29 By tsai_yen 檢查簡繁字串
# Modify.........: No:FUN-BA0116 11/10/31 By joyce 新增繁簡體資料轉換action
# Modify.........: No:CHI-C70040 12/09/06 By zack 修正點選維護欄位型態.會多加一筆空白ROW和替換azz-130的錯誤代碼
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gaq     DYNAMIC ARRAY OF RECORD 
            gaq01          LIKE gaq_file.gaq01,  
            gaq02          LIKE gaq_file.gaq02,  
            gaq03          LIKE gaq_file.gaq03,
            gaq04          LIKE gaq_file.gaq04,   #MOD-580359
            ztb04          LIKE ztb_file.ztb04,   #FUN-750034
            ztb08          LIKE ztb_file.ztb08,   #FUN-750034
            gaq07          LIKE gck_file.gck02,   #TQC-680009
            gck03          LIKE gck_file.gck03,   #FUN-750034
            gaq05          LIKE gaq_file.gaq05, 
            gaq06          LIKE gaq_file.gaq06, #FUN-730018
            gaq08          LIKE gaq_file.gaq08  #No.FUN-770078 
                      END RECORD,
         g_gaq_t           RECORD 
            gaq01          LIKE gaq_file.gaq01,  
            gaq02          LIKE gaq_file.gaq02,  
            gaq03          LIKE gaq_file.gaq03,
            gaq04          LIKE gaq_file.gaq04,   #MOD-580359
            ztb04          LIKE ztb_file.ztb04,   #FUN-750034
            ztb08          LIKE ztb_file.ztb08,   #FUN-750034
            gaq07          LIKE gck_file.gck02,   #TQC-680009
            gck03          LIKE gck_file.gck03,   #FUN-750034
            gaq05          LIKE gaq_file.gaq05,
            gaq06          LIKE gaq_file.gaq06, #FUN-730018
            gaq08          LIKE gaq_file.gaq08  #No.FUN-770078 
                      END RECORD,
         g_wc2            STRING,
         g_sql            STRING,
         g_rec_b          LIKE type_file.num5,   # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac             LIKE type_file.num5,   # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
         l_sl             LIKE type_file.num5    #FUN-680135    SMALLINT # 目前處理的SCREEN LINE
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql    STRING
DEFINE   g_before_input_done   LIKE type_file.num5    #NO.MOD-580056    #No.FUN-680135 SMALLINT
DEFINE   g_argv1         LIKE gaq_file.gaq01
DEFINE   g_db_type       LIKE type_file.chr3   #FUN-770023
DEFINE   g_ase_sql       STRING                #FUN-AA0073
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW p_feldname_w WITH FORM "azz/42f/p_feldname"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_db_type=cl_db_get_database_type()  #FUN-770023
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gaq02")

   CALL cl_query_prt_temptable()     #FUN-AC0036
   
   IF NOT cl_null(g_argv1) THEN
      CALL p_feldname_q()
   END IF
 
   CALL p_feldname_menu()
 
   CLOSE WINDOW p_feldname_w         # 結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION p_feldname_menu()
 
   WHILE TRUE
      CALL p_feldname_bp("G")
      CASE g_action_choice
 
      WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL p_feldname_q()
         END IF
 
      WHEN "detail"
         IF cl_chk_act_auth() THEN
            CALL p_feldname_b()
         ELSE
            LET g_action_choice = " "
         END IF
 
      WHEN "help"
         CALL cl_show_help()
 
      WHEN "exit"
         EXIT WHILE
 
      WHEN "controlg"
         CALL cl_cmdask()
 
      WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gaq),'','')
            END IF
 
       WHEN "showlog"           #MOD-440464
         IF cl_chk_act_auth() THEN
            CALL cl_show_log("p_feldname")
         END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p_feldname_q()
 
   CALL p_feldname_b_askkey()
 
END FUNCTION
 
FUNCTION p_feldname_b()
   DEFINE l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT   #No.FUN-680135  SMALLINT
          l_n             LIKE type_file.num5,     # 檢查重複用      #No.FUN-680135 SMALLINT
          l_modify_flag   LIKE type_file.chr1,     # 單身更改否      #No.FUN-680135 VARCHAR(1)
          l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否      #No.FUN-680135 VARCHAR(1)
          l_exit_sw       LIKE type_file.chr1,     #FUN-680135       VARCHAR(1) # Esc結束INPUT ARRAY 否
          p_cmd           LIKE type_file.chr1,     # 處理狀態        #No.FUN-680135 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,     # 可否新增        #No.FUN-680135 SMALLINT
          l_allow_delete  LIKE type_file.num5,     # 可否刪除        #No.FUN-680135 SMALLINT
          l_jump          LIKE type_file.num5      #FUN-680135       SMALLINT # 判斷是否跳過AFTER ROW的處理
   DEFINE ls_msg_o        STRING
   DEFINE ls_msg_n        STRING
   DEFINE l_gck02         LIKE gck_file.gck02      #TQC-680009 add
   DEFINE li_i            LIKE type_file.num5      # 暫存用數值   # No:FUN-BA0116
   DEFINE lc_target       LIKE gay_file.gay01      # No:FUN-BA0116

   CALL cl_opmsg('b')
 
   IF s_shut(0) THEN 
      RETURN 
   END IF
 
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = " SELECT gaq01,gaq02,gaq03,gaq04,'','',gaq07,'',gaq05,gaq06,gaq08 ",  #No.FUN-660025  #TQC-680009 add gaq07  #FUN-680031 #FUN-730018  #FUN-750034 add ztb04,ztb08,gck03  #No.FUN-770078 
                        " FROM gaq_file  WHERE gaq01= ? AND gaq02= ? ",
                         " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_feldname_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gaq WITHOUT DEFAULTS FROM s_gaq.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gaq_t.* = g_gaq[l_ac].*  #BACKUP
            #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_feldname_set_entry(p_cmd)
            CALL p_feldname_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            #No.MOD-580056 --end
            OPEN p_feldname_bcl USING g_gaq_t.gaq01, g_gaq_t.gaq02
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN p_feldname_bcl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_feldname_bcl INTO g_gaq[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_feldname_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
                 #TQC-680009 add --start
               ELSE
                  CALL p_feldname_gettype(l_ac,NULL,NULL,NULL)  #FUN-750034
                  LET l_gck02 = ""
                  SELECT gck02 INTO l_gck02
                    FROM gck_file
                   WHERE gck01 = g_gaq[l_ac].gaq07 
                  LET g_gaq[l_ac].gaq07 = l_gck02
                 #TQC-680009 add --end
                  LET g_gaq[l_ac].gaq08 = TODAY  #No.FUN-770078 
               END IF
            END IF
            CALL cl_show_fld_cont()             #No.FUN-550037
         END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gaq[l_ac].* TO NULL      #900423
         #LET g_gaq[l_ac].gaq06 = "N"   #No.FUN-660025  #FUN-680031 remark
          LET g_gaq[l_ac].gaq08 = TODAY  #No.FUN-770078 
          LET g_gaq_t.* = g_gaq[l_ac].*         #新輸入資料
          #No.MOD-580056 --start
          LET g_before_input_done = FALSE
          CALL p_feldname_set_entry(p_cmd)
          CALL p_feldname_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          #No.MOD-580056 --end
          DISPLAY g_gaq[l_ac].* TO s_gaq[l_sl].* 
          CALL cl_show_fld_cont()               #No.FUN-550037
 
       AFTER FIELD gaq01
          CALL p_feldname_set_entry(p_cmd)
          CALL p_feldname_set_no_entry(p_cmd)
 
       AFTER FIELD gaq02                        #check 代號+語言別是否重複
          IF cl_null(g_gaq[l_ac].gaq02) THEN
             LET g_gaq[l_ac].gaq02 = g_gaq_t.gaq02
             DISPLAY g_gaq[l_ac].gaq02 TO s_gaq[l_sl].gaq02
             NEXT FIELD gaq02 
          END IF 
          IF g_gaq[l_ac].gaq01 != g_gaq_t.gaq01 OR g_gaq[l_ac].gaq02 != g_gaq_t.gaq02
          OR (g_gaq[l_ac].gaq01 IS NOT NULL AND g_gaq_t.gaq01 IS NULL) 
          OR (g_gaq[l_ac].gaq02 IS NOT NULL AND g_gaq_t.gaq02 IS NULL) THEN
             SELECT COUNT(*) INTO l_n FROM gaq_file
              WHERE gaq01 = g_gaq[l_ac].gaq01
                AND gaq02 = g_gaq[l_ac].gaq02
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_gaq[l_ac].gaq01 = g_gaq_t.gaq01
                LET g_gaq[l_ac].gaq02 = g_gaq_t.gaq02
                DISPLAY g_gaq[l_ac].gaq01 TO s_gaq[l_sl].gaq01
                DISPLAY g_gaq[l_ac].gaq02 TO s_gaq[l_sl].gaq02
                NEXT FIELD gaq01
             END IF
            #FUN-680031 remark start
            # #-----No.FUN-660025-----
            # SELECT UNIQUE gaq06 INTO g_gaq[l_ac].gaq06 FROM gaq_file
            #  WHERE gaq01 = g_gaq[l_ac].gaq01
            # IF STATUS OR STATUS=100 THEN
            #    LET g_gaq[l_ac].gaq06 = "N"
            # END IF 
            # LET g_gaq_t.gaq06 = g_gaq[l_ac].gaq06 
            # #-----No.FUN-660025 END-----
            #FUN-680031 remark --end
          END IF
 
       BEFORE FIELD gaq03
          LET l_modify_flag = 'Y'
          IF l_lock_sw = 'Y' THEN            #已鎖住
             LET l_modify_flag = 'N'
          END IF
          IF l_modify_flag = 'N' THEN
             LET g_gaq[l_ac].gaq01 = g_gaq_t.gaq01
             LET g_gaq[l_ac].gaq02 = g_gaq_t.gaq02
             DISPLAY g_gaq[l_ac].gaq01 TO s_gaq[l_sl].gaq01
             DISPLAY g_gaq[l_ac].gaq02 TO s_gaq[l_sl].gaq02
             NEXT FIELD gaq01
          END IF
 
       BEFORE FIELD gaq04
          CALL s_textedit(g_gaq[l_ac].gaq04) RETURNING g_gaq[l_ac].gaq04
          DISPLAY g_gaq[l_ac].gaq04 TO gaq04
 
       BEFORE FIELD gaq05
          CALL s_textedit(g_gaq[l_ac].gaq05) RETURNING g_gaq[l_ac].gaq05
          DISPLAY g_gaq[l_ac].gaq05 TO gaq05

       ###FUN-B90139 START ###
       AFTER FIELD gaq03
          IF NOT cl_unicode_check02(g_gaq[l_ac].gaq02, g_gaq[l_ac].gaq03,"1") THEN
             NEXT FIELD gaq03
          END IF
          
       AFTER FIELD gaq04
          IF NOT cl_unicode_check02(g_gaq[l_ac].gaq02, g_gaq[l_ac].gaq04,"1") THEN
             NEXT FIELD gaq04
          END IF

       AFTER FIELD gaq05
          IF NOT cl_unicode_check02(g_gaq[l_ac].gaq02, g_gaq[l_ac].gaq05,"1") THEN
             NEXT FIELD gaq05
          END IF
       ###FUN-B90139 END ###
 
       BEFORE DELETE                            #是否取消單身
          IF g_gaq_t.gaq01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
             DELETE FROM gaq_file WHERE gaq01 = g_gaq_t.gaq01
                AND gaq02 = g_gaq_t.gaq02
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gaq_t.gaq01,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("del","gaq_file",g_gaq_t.gaq01,g_gaq_t.gaq02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                ROLLBACK WORK 
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             MESSAGE "Delete OK"
             CLOSE p_feldname_bcl
             COMMIT WORK 
             LET g_gaq_t.* = g_gaq[l_ac+1].*   #No.FUN-660025
             LET ls_msg_n = g_gaq_t.gaq01 CLIPPED,"",g_gaq_t.gaq02 CLIPPED,"",g_gaq[l_ac].gaq03 CLIPPED,"",g_gaq[l_ac].gaq04 CLIPPED,"",g_gaq[l_ac].gaq05 CLIPPED
             CALL cl_log("p_feldname","D",ls_msg_n,"")  # MOD-440464
          END IF
 
      AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO gaq_file(gaq01,gaq02,gaq03,gaq04,gaq05,gaq06,gaq08)  #No.FUN-660025  #FUN-730018  #No.FUN-770078 
               VALUES (g_gaq[l_ac].gaq01,g_gaq[l_ac].gaq02,
                       g_gaq[l_ac].gaq03,g_gaq[l_ac].gaq04,
                       g_gaq[l_ac].gaq05,g_gaq[l_ac].gaq06, #FUN-730018
                       g_gaq[l_ac].gaq08)  #No.FUN-770078 
          IF SQLCA.sqlcode THEN
             #CALL cl_err(g_gaq[l_ac].gaq01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","gaq_file",g_gaq[l_ac].gaq01,g_gaq[l_ac].gaq02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             LET ls_msg_n = g_gaq[l_ac].gaq01 CLIPPED,"",g_gaq[l_ac].gaq02 CLIPPED,"",g_gaq[l_ac].gaq03 CLIPPED,"",g_gaq[l_ac].gaq04 CLIPPED,"",g_gaq[l_ac].gaq05 CLIPPED
              CALL cl_log("p_feldname","I",ls_msg_n,"")    # MOD-440464
          END IF
          #CALL cl_generate_sch('',g_gaq[l_ac].gaq01)   #FUN-AA0073
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gaq[l_ac].* = g_gaq_t.*
             CLOSE p_feldname_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gaq[l_ac].gaq01,-263,1)
             LET g_gaq[l_ac].* = g_gaq_t.*
          ELSE
             UPDATE gaq_file SET gaq01 = g_gaq[l_ac].gaq01,
                                 gaq02 = g_gaq[l_ac].gaq02,
                                 gaq03 = g_gaq[l_ac].gaq03,
                                 gaq04 = g_gaq[l_ac].gaq04,
                                 gaq05 = g_gaq[l_ac].gaq05,
                                 gaq06 = g_gaq[l_ac].gaq06, #FUN-730018
                                 gaq08 = g_gaq[l_ac].gaq08  #No.FUN-770078 
              WHERE gaq01 = g_gaq_t.gaq01
                AND gaq02 = g_gaq_t.gaq02
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gaq[l_ac].gaq01,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("upd","gaq_file",g_gaq_t.gaq01,g_gaq_t.gaq02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
                LET g_gaq[l_ac].* = g_gaq_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE p_feldname_bcl
                COMMIT WORK 
                LET ls_msg_n = g_gaq[l_ac].gaq01 CLIPPED,"",g_gaq[l_ac].gaq02 CLIPPED,"",g_gaq[l_ac].gaq03 CLIPPED,"",g_gaq[l_ac].gaq04 CLIPPED,"",g_gaq[l_ac].gaq05 CLIPPED
                LET ls_msg_o = g_gaq_t.gaq01 CLIPPED,"",g_gaq_t.gaq02 CLIPPED,"",g_gaq_t.gaq03 CLIPPED,"",g_gaq_t.gaq04 CLIPPED,"",g_gaq_t.gaq05 CLIPPED
                 CALL cl_log("p_feldname","U",ls_msg_n,ls_msg_o)    # MOD-440464
             END IF
          END IF
          #CALL cl_generate_sch('',g_gaq[l_ac].gaq01)    #FUN-AA0073
 
      AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gaq[l_ac].* = g_gaq_t.*
             #FUN-D30034--add--begin--
             ELSE
                CALL g_gaq.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end----
             END IF
             CLOSE p_feldname_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
         #FUN-680031 remark start--
          #-----No.FUN-660025-----
          #IF g_gaq_t.gaq06 <> g_gaq[l_ac].gaq06 THEN 
          #   SELECT COUNT(*) INTO l_n FROM gaq_file
          #    WHERE gaq01 = g_gaq[l_ac].gaq01
          #      AND gaq02 <> g_gaq[l_ac].gaq02
          #   IF l_n > 0 THEN
          #      CALL cl_err(g_gaq[l_ac].gaq01,"azz-129",1) 
          #      UPDATE gaq_file SET gaq06 = g_gaq[l_ac].gaq06
          #       WHERE gaq01 = g_gaq[l_ac].gaq01
          #         AND gaq02 <> g_gaq[l_ac].gaq02
          #      CALL p_feldname_b_fill(g_wc2)
          #   END IF
          #END IF
          #-----No.FUN-660025 END-----
         #FUN-680031 remark end--
 
          LET l_ac_t = l_ac
          CLOSE p_feldname_bcl
          COMMIT WORK
 
      # No:FUN-BA0116 ---start---
      ON ACTION translate_zhtw
         LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE
            WHEN g_gaq[l_ac].gaq02 = "0" LET lc_target = "2"
            WHEN g_gaq[l_ac].gaq02 = "2" LET lc_target = "0"
         END CASE

         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO g_gaq.getLength()
            IF li_i = l_ac THEN CONTINUE FOR END IF
            IF g_gaq[li_i].gaq01 = g_gaq[l_ac].gaq01 AND
               g_gaq[li_i].gaq02 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(gaq03)
                     LET g_gaq[l_ac].gaq03 = cl_trans_utf8_twzh(g_gaq[l_ac].gaq02,g_gaq[li_i].gaq03)
                     DISPLAY g_gaq[l_ac].gaq03 TO gaq03
                     EXIT FOR
                  WHEN INFIELD(gaq04)
                     LET g_gaq[l_ac].gaq04 = cl_trans_utf8_twzh(g_gaq[l_ac].gaq02,g_gaq[li_i].gaq04)
                     DISPLAY g_gaq[l_ac].gaq04 TO gaq04
                     EXIT FOR
                  WHEN INFIELD(gaq05)
                     LET g_gaq[l_ac].gaq05 = cl_trans_utf8_twzh(g_gaq[l_ac].gaq02,g_gaq[li_i].gaq05)
                     DISPLAY g_gaq[l_ac].gaq05 TO gaq05
                     EXIT FOR
               END CASE
            END IF
         END FOR
      # No:FUN-BA0116 --- end ---

      ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(gaq01) AND l_ac > 1 THEN
             LET g_gaq[l_ac].* = g_gaq[l_ac-1].*
             DISPLAY g_gaq[l_ac].* TO s_gaq[l_sl].* 
             NEXT FIELD gaq01
          END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
     #TQC-680009 add--start
      ON ACTION field_type  #維護欄位型態
         CALL p_feldname_field_type()
     #TQC-680009 add--end 
   END INPUT
 
   CLOSE p_feldname_bcl
   COMMIT WORK 
 
END FUNCTION
 
FUNCTION p_feldname_b_askkey()
 
   CLEAR FORM
   CALL g_gaq.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = "gaq01 like '",g_argv1 CLIPPED,"' "
   ELSE
     #CONSTRUCT g_wc2 ON gaq01,gaq02,gaq03,gaq06,gaq04,gaq07,gaq05  #No.FUN-660025    #TQC-680009   #FUN-680031 remark
      CONSTRUCT g_wc2 ON gaq01,gaq02,gaq03,gaq04,gaq07,gaq05,gaq06,gaq08  #FUN-680031  #FUN-730018  #No.FUN-770078 
           FROM s_gaq[1].gaq01,s_gaq[1].gaq02,s_gaq[1].gaq03,
               #s_gaq[1].gaq06,s_gaq[1].gaq04,s_gaq[1].gaq07,s_gaq[1].gaq05  #No.FUN-660025  #TQC-680009  #FUN-680031 remark
                s_gaq[1].gaq04,s_gaq[1].gaq07,s_gaq[1].gaq05,s_gaq[1].gaq06,  #FUN-680031 #FUN-730018
                s_gaq[1].gaq08  #No.FUN-770078 
       #FUN-730018........begin
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
       
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
       
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
       #FUN-730018........end
       #TQC-680069 add--start
        ON ACTION CONTROLP
       CASE
         WHEN INFIELD(gaq07)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_gck"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO gaq07
           NEXT FIELD gaq07
         OTHERWISE EXIT CASE
         END CASE
    
       #TQC-680069 add--end
      END CONSTRUCT --TQC-680069
      LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      #FUN-730018...........begin
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
      #FUN-730018...........end
   END IF
   CALL p_feldname_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_feldname_b_fill(p_wc2)       #BODY FILL UP

  DEFINE p_wc2      LIKE type_file.chr1000#No.FUN-680135 VARCHAR(1000)
  DEFINE l_gck02    LIKE gck_file.gck02   #TQC-680009
  DEFINE l_length   LIKE type_file.num20_6
  DEFINE l_type     LIKE ztb_file.ztb03
  DEFINE l_scale    LIKE type_file.num5
  DEFINE l_dbname   STRING              #TQC-970259

  #---FUN-AC0036---start-----
  #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
  #目前統一用sch_file紀錄TIPTOP資料結構
  #CASE g_db_type
  #  WHEN "IFX" 
  #    LET g_sql = "SELECT gaq01,gaq02,gaq03,gaq04,'','',gaq07,gck03,gaq05,gaq06,gaq08 ",   #FUN-680031 #FUN-730018   #FUN-750034 add 3個空白(ztb04,ztb08,gck03)  #No.FUN-770078 
  #                "       ,coltype,collength,0 ",
  #                "  FROM gaq_file,OUTER gck_file,syscolumns ",
  #                " WHERE gaq07=gck01",
  #                "   AND colname=gaq01",
  #                "   AND ", p_wc2 CLIPPED,                     #單身
  #                " ORDER BY gaq01,gaq02 "
  #  WHEN "ORA"
  #    LET g_sql = "SELECT gaq01,gaq02,gaq03,gaq04,'','',gaq07,gck03,gaq05,gaq06,gaq08 ",   #FUN-680031 #FUN-730018   #FUN-750034 add 3個空白(ztb04,ztb08,gck03)  #No.FUN-770078 
  #                "       ,lower(data_type)",
  #                "       ,to_char(decode(data_precision,null,data_length,data_precision),'9999.99') ",
  #                "       ,data_scale ",
  #                #"  FROM gaq_file,gck_file,user_tab_columns",   #TQC-780068
  #                #No.TQC-9B0015 --Begin
  #                "  FROM all_tab_columns,gaq_file LEFT OUTER JOIN gck_file ",     #TQC-780068
  #                "                                ON  gaq07=gck01",
  #                " WHERE lower(column_name)=gaq01",
  #                "   AND lower(owner)='ds'",                     #TQC-780068
  #                "   AND lower(table_name) NOT LIKE 'bin$%'",     #MOD-890296 
  #                "   AND ", p_wc2 CLIPPED,                     #單身
  #                " ORDER BY gaq01,gaq02 "
  #                #No.TQC-9B0015 --End  
  #  WHEN "MSV"    #FUN-810060   #FUN-820009
  #    LET l_dbname= FGL_GETENV("MSSQLAREA") CLIPPED,"_ds.dbo."      #TQC-970259
  #    LET g_sql = " SELECT gaq01,gaq02,gaq03,gaq04,'','',gaq07,gck03,gaq05,gaq06,gaq08 ",   #FUN-680031 #FUN-730018   #FUN-750034 add 3個空白(ztb04,ztb08,gck03)  #No.FUN-770078 
  #                       " ,xtype,length,0 ",
  #                " FROM gaq_file LEFT OUTER JOIN ",l_dbname ,"syscolumns c ON c.name=gaq_file.gaq01 ",
  #                "               LEFT OUTER JOIN gck_file ON gaq_file.gaq07=gck_file.gck01 ",
  #                " WHERE 1=1 ",
  #                " AND ", p_wc2 CLIPPED,                     #單身
  #                " ORDER BY gaq01,gaq02 "
  #  WHEN "ASE"    #FUN-AA0017
  #    LET g_ase_sql = "SELECT t.name FROM ds.dbo.syscolumns c,ds.dbo.systypes t", #FUN-AA0073
  #                    " WHERE c.name=? and c.usertype *= t.usertype "
  #    PREPARE p_feldname_ase FROM g_ase_sql
  #
  #    LET g_sql = " SELECT gaq01,gaq02,gaq03,gaq04,'','',gaq07,gck03,gaq05,gaq06,gaq08 ", 
  #                       " ,type,isnull(c.prec ,c.length),c.scale ",
  #                " FROM gaq_file LEFT OUTER JOIN ds.dbo.syscolumns c ON c.name=gaq_file.gaq01 ",
  #                "               LEFT OUTER JOIN gck_file ON gaq_file.gaq07=gck_file.gck01 ",
  #                " WHERE 1=1 ",
  #                " AND ", p_wc2 CLIPPED,                     #單身
  #                " ORDER BY gaq01,gaq02 "
  #END CASE
  LET g_sql = "SELECT gaq01, gaq02, gaq03, gaq04, '', '', gaq07, gck03, gaq05, gaq06, gaq08, ",
              "       sch03, sch04, 0 ",
              "  FROM gaq_file LEFT OUTER JOIN sch_file ON sch02 = gaq01 ",
              "                LEFT OUTER JOIN gck_file ON gaq07 = gck01 ",
              "  WHERE sch01 NOT LIKE 'bin$%' AND sch01 LIKE '%_file' ",
              "   AND ", p_wc2 CLIPPED,                     #單身
              "  ORDER BY gaq01, gaq02 "
  #---FUN-AC0036---end-------
#FUN-750034 end
 
   PREPARE p_feldname_pb FROM g_sql
   #DECLARE gaq_curs CURSOR FOR p_feldname_pb             #FUN-AC0036 mark
   DECLARE gaq_curs CURSOR WITH HOLD FOR p_feldname_pb    #FUN-AC0036 因為下面的temp table會有transaction會造成cursor自動關閉
 
  #TQC-680009 add--start
   LET g_sql = " SELECT gaq01,gaq03,gaq07,'' ",   
                 " FROM gaq_file",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                  " AND gaq02 = '0' ",  #只找語言別=繁中的
                " ORDER BY gaq01 "
 
   PREPARE p_feldname_type FROM g_sql
   DECLARE gaq_type_curs CURSOR FOR p_feldname_type
  #TQC-68009 add--end
 
   CALL g_gaq.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   #FOREACH gaq_curs INTO g_gaq[g_cnt].*   #單身 ARRAY 填充
   FOREACH gaq_curs INTO g_gaq[g_cnt].*,l_type,l_length,l_scale   #單身 ARRAY 填充
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
     #FUN-750034
      IF g_cnt > 1 THEN
        IF g_gaq[g_cnt].gaq01 = g_gaq[g_cnt-1].gaq01 THEN
          LET g_gaq[g_cnt].ztb04 = g_gaq[g_cnt-1].ztb04
          LET g_gaq[g_cnt].ztb08 = g_gaq[g_cnt-1].ztb08
          LET g_gaq[g_cnt].gck03 = g_gaq[g_cnt-1].gck03
        ELSE
          #CALL p_feldname_gettype(g_cnt)  #FUN-750034
          CALL p_feldname_gettype(g_cnt,l_type,l_length,l_scale)  #FUN-750034
        END IF
      ELSE
        #CALL p_feldname_gettype(g_cnt)  #FUN-750034
          CALL p_feldname_gettype(g_cnt,l_type,l_length,l_scale)  #FUN-750034
      END IF
     #FUN-750034 end
     #TQC-680009 add --start
      LET l_gck02 = ""
      SELECT gck02 INTO l_gck02
        FROM gck_file
       WHERE gck01 = g_gaq[g_cnt].gaq07 
      LET g_gaq[g_cnt].gaq07 = l_gck02
     #TQC-680009 add --end
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
      
   END FOREACH
   CALL g_gaq.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
 
   #No.MOD-530136  --begin
   #DISPLAY g_cnt TO FORMONLY.cn2  
   DISPLAY g_rec_b TO FORMONLY.cn2  
   #No.MOD-530136  --end   
 
   LET g_cnt=0
 
END FUNCTION
 
 
FUNCTION p_feldname_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gaq TO s_gaq.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()      #No.FUN-550037
 
      ON ACTION query                  # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail                 # B.單身
         LET g_action_choice="detail"
         EXIT DISPLAY
 
#     ON ACTION output                 #MOD-580359
#        LET g_action_choice="output"
#        EXIT DISPLAY
 
      ON ACTION help                   # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       #No.FUN-550037
 
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("gaq02")
         EXIT DISPLAY
 
      ON ACTION exit                   # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
  
      ON ACTION cancel
         LET INT_FLAG=FALSE         #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION showlog                             # MOD-440464
         LET g_action_choice = "showlog"
         EXIT DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#No.MOD-580056 --start
FUNCTION p_feldname_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gaq01,gaq02",TRUE)
   END IF
  #CALL cl_set_comp_entry("gaq06",TRUE)  #No.FUN-660025  #FUN-680031 remark
 
END FUNCTION
 
FUNCTION p_feldname_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
   DEFINE l_ztb04 LIKE ztb_file.ztb04   #No.FUN-660025
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("gaq01,gaq02",FALSE)
   END IF
 
  #FUN-680031 remark --start--
   #-----No.FUN-660025-----
   #SELECT UNIQUE lower(data_type) INTO l_ztb04
   #  FROM all_tab_columns
   # WHERE lower(column_name) = g_gaq[l_ac].gaq01
 
   #IF l_ztb04 <> 'char' THEN
   #   CALL cl_set_comp_entry("gaq06",FALSE)
   #END IF
   #-----No.FUN-660025 END-----
  #FUN-680031 remark --end---
 
 
END FUNCTION
 
#TQC-680009 add--start
FUNCTION p_feldname_field_type()  #維護欄位型態
 
   DEFINE l_cnt      LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE l_rec_type LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE l_ac2      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE l_gck02    LIKE gck_file.gck02
   DEFINE l_lock_sw  LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
   DEFINE   l_gaq    DYNAMIC ARRAY OF RECORD
              gaq01      LIKE gaq_file.gaq01,
              gaq03      LIKE gaq_file.gaq03,
              gaq07      LIKE gaq_file.gaq07,
              gck02      LIKE gck_file.gck02 
                     END RECORD
   DEFINE   l_gaq_t  RECORD
              gaq01      LIKE gaq_file.gaq01,
              gaq03      LIKE gaq_file.gaq03,
              gaq07      LIKE gaq_file.gaq07,
              gck02      LIKE gck_file.gck02 
                     END RECORD
 
  OPEN WINDOW p_feldname2_w WITH FORM "azz/42f/p_feldname2"
     ATTRIBUTE(STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("p_feldname2")
  
  CALL l_gaq.clear()
 
  LET l_cnt = 1
  FOREACH gaq_type_curs INTO l_gaq[l_cnt].*   #單身 ARRAY 填充
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      #FUN-680031 add--start--
      IF NOT cl_null(l_gaq[l_cnt].gaq07) THEN
         SELECT gck02 INTO l_gaq[l_cnt].gck02 FROM gck_file
          WHERE gck01 = l_gaq[l_cnt].gaq07
      END IF
      #FUN-680031 add--end--
      LET l_cnt = l_cnt + 1
  END FOREACH
  CALL l_gaq.deleteElement(l_cnt)
  LET l_rec_type = l_cnt-1
 
  INPUT ARRAY l_gaq WITHOUT DEFAULTS FROM s_gaq2.*
       ATTRIBUTE(COUNT=l_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
    BEFORE INPUT
      IF l_rec_type != 0 THEN
         CALL fgl_set_arr_curr(l_ac2)
      END IF
 
    BEFORE ROW
      LET l_ac2 = ARR_CURR()
      LET l_lock_sw = 'N'                   #DEFAULT
      BEGIN WORK
      LET l_gaq_t.* = l_gaq[l_ac2].*  #BACKUP
 
    AFTER FIELD gaq07
      SELECT count(*) INTO l_cnt FROM gck_file
       WHERE gck01 = l_gaq[l_ac2].gaq07
      IF l_cnt = 0 THEN
         #CALL cl_err(l_gaq[l_ac2].gaq07,'azz-130',0) #mark CHI-C70040
         CALL cl_err(l_gaq[l_ac2].gaq07,'azz-950',0) #CHI-C70040
         LET l_gaq[l_ac2].gaq07 = l_gaq_t.gaq07
         DISPLAY BY NAME l_gaq[l_ac2].gaq07
         NEXT FIELD gaq07
     #FUN-680031 add--start
      ELSE 
        SELECT gck02 INTO l_gaq[l_ac2].gck02 FROM gck_file
         WHERE gck01 = l_gaq[l_ac2].gaq07
        DISPLAY BY NAME l_gaq[l_ac2].gck02
     #FUN-680031 add--end
      END IF      
 
    ON ACTION CONTROLP
      CASE 
        WHEN INFIELD(gaq07)
          CALL cl_init_qry_var()
          LET g_qryparam.form = "q_gck"
          CALL cl_create_qry() RETURNING l_gaq[l_ac2].gaq07,l_gaq[l_ac2].gck02
          DISPLAY BY NAME l_gaq[l_ac2].gaq07 ,l_gaq[l_ac2].gck02
          NEXT FIELD gaq07
      OTHERWISE EXIT CASE
      END CASE
   
    ON ROW CHANGE
       IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET l_gaq[l_ac2].* = l_gaq_t.*
         CLOSE p_feldname_bcl
         ROLLBACK WORK
         EXIT INPUT
        END IF
        
        IF l_lock_sw = 'Y' THEN
           CALL cl_err(l_gaq[l_ac2].gaq01,-263,1)
           LET l_gaq[l_ac2].* = l_gaq_t.*
        ELSE
          UPDATE gaq_file SET gaq07 = l_gaq[l_ac2].gaq07
           WHERE gaq01 = l_gaq[l_ac2].gaq01
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err3("upd","gaq_file",l_gaq[l_ac2].gaq01,'',SQLCA.SQLCODE,"","upd for",1)
             LET l_gaq[l_ac2].* = l_gaq_t.*
          ELSE
             MESSAGE 'UPDATE O.K'
             COMMIT WORK
          END IF
 
          SELECT gck02 INTO l_gck02 FROM gck_file 
           WHERE gck01 = l_gaq[l_ac2].gaq07
         
          FOR l_ac = 1 to g_rec_b
              IF g_gaq[l_ac].gaq01 = l_gaq[l_ac2].gaq01 THEN
                 LET g_gaq[l_ac].gaq07 = l_gck02
                 DISPLAY BY NAME g_gaq[l_ac].gaq07
              END IF
          END FOR 
          LET l_ac=g_rec_b #CHI-C70040 
        END IF
 
    AFTER ROW
      LET l_ac2 = ARR_CURR()
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET l_gaq[l_ac2].* = l_gaq_t.*
         #CLOSE p_feldname_bcl
         #ROLLBACK WORK
         EXIT INPUT
      END IF
      #CLOSE p_feldname_bcl
      #COMMIT WORK
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about
       CALL cl_about()
  END INPUT 
  
  CLOSE WINDOW p_feldname2_w
  
  LET INT_FLAG = 0 
 
  #CALL p_feldname_b_fill(g_wc2)
  #CALL p_feldname_bp("G")
 
END FUNCTION
#TQC-680009 add--end
#--END
 
#FUNCTION p_feldname_gettype(p_cnt)
FUNCTION p_feldname_gettype(p_cnt,l_type,l_length,l_scale)
  DEFINE p_cnt LIKE type_file.num5
  DEFINE l_length   LIKE type_file.num20_6
  DEFINE l_length1  LIKE type_file.chr20
  DEFINE l_type     LIKE ztb_file.ztb03
  DEFINE l_sql      STRING
  DEFINE g_err      STRING
  DEFINE i          LIKE type_file.num5,
       l_scale      LIKE type_file.num5
  DEFINE l_type_s   LIKE type_file.num5
  DEFINE l_datetype STRING                #FUN-AC0036
  
  #---FUN-AC0036---start-----
  #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
  #目前統一用sch_file紀錄TIPTOP資料結構
  #IF cl_null(l_type) AND cl_null(l_length) AND cl_null(l_scale) THEN
  #   #屬性的型態長度
  #     SELECT gck03 INTO g_gaq[p_cnt].gck03
  #       FROM gck_file
  #      WHERE gck01 = g_gaq[p_cnt].gaq07
  #   #欄位的型態/長度
  #    CASE g_db_type
  #      WHEN "IFX" 
  #        LET l_sql="SELECT coltype,collength,0 ",
  #                      "  FROM syscolumns ",
  #                      " WHERE colname='",g_gaq[p_cnt].gaq01 CLIPPED,"'"
  #      WHEN "ORA" 
  #            LET l_sql="SELECT lower(data_type),",
  #                      "       to_char(decode(data_precision,null,data_length,data_precision),'9999.99'), ",
  #                      "       data_scale ",
  #                      "  FROM user_tab_columns",
  #                      " WHERE lower(table_name) = 'ima_file' ",
  #                      "   AND lower(column_name)='",g_gaq[p_cnt].gaq01 CLIPPED,"'"
  #      WHEN "MSV"      #FUN-810060  #FUN-820009
  #        LET l_sql=" SELECT a.name,b.length,0 ",
  #                    " FROM sys.types a, sys.syscolumns b ",
  #                   " WHERE b.name='",g_gaq[p_cnt].gaq01 CLIPPED,"' ",
  #                     " AND b.xtype=a.system_type_id "
  #      WHEN "ASE"      #FUN-AA0017
  #        LET l_sql=" SELECT a.name,b.length,0 ",
  #                    " FROM systypes a, ds.dbo.syscolumns b ",
  #                   " WHERE b.name='",g_gaq[p_cnt].gaq01 CLIPPED,"' ",
  #                     " AND b.usertype=a.usertype "
  #    END CASE
  #         #END FUN-730016
  #
  #    PREPARE p_feldname_type_pre FROM l_sql
  #    EXECUTE p_feldname_type_pre INTO l_type,l_length,l_scale
  #    IF sqlca.sqlcode THEN
  #       LET g_err="select ztb data error(bshow)"
  #       CALL cl_err(g_err CLIPPED,sqlca.sqlcode,0) 
  #       RETURN
  #    END IF
  #END IF
  #
  #    CASE g_db_type                                        #FUN-730016
  #     WHEN "IFX"                                           #FUN-730016
  #       CASE WHEN l_type = 0
  #                 LET l_length1=l_length CLIPPED
  #                 LET g_gaq[p_cnt].ztb04 = "char"
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #            WHEN l_type = 1 LET g_gaq[p_cnt].ztb04 = "smallint"
  #            WHEN l_type = 2 LET g_gaq[p_cnt].ztb04 = "integer"
  #            WHEN l_type = 5
  #                 LET l_length1=l_length/256
  #                 LET l_length=l_length mod 256 CLIPPED
  #                 IF l_length1<l_length THEN
  #                    FOR i=1 TO 10
  #                        IF l_length1[i,i]="." THEN
  #                           LET g_gaq[p_cnt].ztb04=l_length1[1,i-1] CLIPPED
  #                           EXIT FOR
  #                        END IF
  #                    END FOR
  #                 ELSE
  #                    FOR i=1 TO 10
  #                        IF l_length1[i,i]="." THEN
  #                           LET g_gaq[p_cnt].ztb04=l_length1[1,i-1] CLIPPED,","
  #                           EXIT FOR
  #                        END IF
  #                    END FOR
  #                    LET l_length1=l_length CLIPPED
  #                    LET g_gaq[p_cnt].ztb04 = g_gaq[p_cnt].ztb04 CLIPPED,
  #                                             l_length1 CLIPPED
  #                 END IF
  #                 LET g_gaq[p_cnt].ztb08 = g_gaq[p_cnt].ztb04 CLIPPED
  #                 LET g_gaq[p_cnt].ztb04 = "decimal"
  #            WHEN l_type = 7 LET g_gaq[p_cnt].ztb04 = "date"
  #            WHEN l_type = 10 LET g_gaq[p_cnt].ztb04 = "datetime"
  #            WHEN l_type = 11 LET g_gaq[p_cnt].ztb04 = "byte"
  #            WHEN l_type = 13
  #                 LET l_length1=l_length CLIPPED
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #                 LET g_gaq[p_cnt].ztb04 = "varchar"
  #            WHEN l_type = 256
  #                 LET l_length1=l_length CLIPPED
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #                 LET g_gaq[p_cnt].ztb04 = "char"
  #            WHEN l_type = 257 LET g_gaq[p_cnt].ztb04 = "smallint"
  #            WHEN l_type = 258 LET g_gaq[p_cnt].ztb04 = "integer"
  #            WHEN l_type = 261
  #                 LET l_length1=l_length/256
  #                 FOR i=1 TO 10
  #                     IF l_length1[i,i]="." THEN
  #                        LET g_gaq[p_cnt].ztb04=l_length1[1,i-1] CLIPPED,","
  #                        EXIT FOR
  #                     END IF
  #                 END FOR
  #                 LET l_length=l_length mod 256 CLIPPED
  #                 LET l_length1=l_length CLIPPED
  #                 LET g_gaq[p_cnt].ztb04 = g_gaq[p_cnt].ztb04 CLIPPED,l_length1 CLIPPED
  #                 LET g_gaq[p_cnt].ztb08 = g_gaq[p_cnt].ztb04 CLIPPED
  #                 LET g_gaq[p_cnt].ztb04 = "decimal"
  #            WHEN l_type = 262 LET g_gaq[p_cnt].ztb04 = "serial"
  #            WHEN l_type = 263 LET g_gaq[p_cnt].ztb04 = "date"
  #            WHEN l_type = 266 LET g_gaq[p_cnt].ztb04 = "datetime"
  #            WHEN l_type = 267 LET g_gaq[p_cnt].ztb04 = "byte"
  #            WHEN l_type = 269
  #                 LET l_length1=l_length CLIPPED
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #                 LET g_gaq[p_cnt].ztb04 = "varchar"
  #            OTHERWISE LET g_gaq[p_cnt].ztb04 = g_gaq[p_cnt].ztb04
  #       END CASE
  # 
  #     WHEN "ORA"                                           
  #       CASE WHEN l_type = 'varchar2'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #            WHEN l_type = 'char'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #            WHEN l_type = 'number'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08=l_length1 CLIPPED
  #                 LET l_length1=l_scale 
  #                 IF l_length1<>'0' THEN
  #                    LET g_gaq[p_cnt].ztb08 = g_gaq[p_cnt].ztb08 CLIPPED,',',l_length1 CLIPPED
  #                 END IF
  #       END CASE
  #       LET g_gaq[p_cnt].ztb04 = l_type
  # 
  #     WHEN "MSV"           #FUN-810060  #FUN-820009
  #        SELECT name INTO g_gaq[p_cnt].ztb04 FROM sys.types WHERE l_type=system_type_id
  #        CASE g_gaq[p_cnt].ztb04 CLIPPED
  #           WHEN 'varchar'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #           WHEN 'char'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #           WHEN 'numeric'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08=l_length1 CLIPPED
  #                 LET l_length1=l_scale 
  #                 IF l_length1<>'0' THEN
  #                    LET g_gaq[p_cnt].ztb08 = g_gaq[p_cnt].ztb08 CLIPPED,',',l_length1 CLIPPED
  #                 END IF
  #        END CASE
  #
  #     WHEN "ASE"           #FUN-AA0017
  #        #FUN-AA0073
  #        EXECUTE p_feldname_ase USING g_gaq[p_cnt].gaq01 INTO g_gaq[p_cnt].ztb04
  #        
  #        CASE g_gaq[p_cnt].ztb04 CLIPPED
  #           WHEN 'varchar'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #           WHEN 'char'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
  #           WHEN 'decimal'
  #                 LET l_length1=l_length USING "####"
  #                 LET g_gaq[p_cnt].ztb08=l_length1 CLIPPED
  #                 LET l_length1=l_scale 
  #                 IF l_length1<>'0' THEN
  #                    LET g_gaq[p_cnt].ztb08 = g_gaq[p_cnt].ztb08 CLIPPED,',',l_length1 CLIPPED
  #                 END IF
  #        END CASE
  #    END CASE                                              #FUN-730016
  CALL cl_query_prt_getlength(g_gaq[p_cnt].gaq01, 'N', 's', 0)
  SELECT xabc06, xabc04, xabc05 INTO l_type, l_length, l_scale 
    FROM xabc WHERE xabc02 = g_gaq[p_cnt].gaq01

  LET g_gaq[p_cnt].ztb04 = l_type CLIPPED
  LET l_datetype = l_type CLIPPED
  IF l_datetype.getIndexOf("char", 1) > 0 OR 
     l_datetype = "smallint" OR l_datetype = "integer" THEN
     LET l_length1 = l_length USING "####"
     LET g_gaq[p_cnt].ztb08 = l_length1
  END IF
  IF l_datetype = "decimal" OR l_datetype = "number" THEN
     LET l_length1 = l_length USING "####"
     LET g_gaq[p_cnt].ztb08 = l_length1 CLIPPED
     LET l_length1 = l_scale 
     IF l_length1 <> '0' THEN
        LET g_gaq[p_cnt].ztb08 = g_gaq[p_cnt].ztb08 CLIPPED, ',', l_length1 CLIPPED
     END IF
  END IF
  #---FUN-AC0036---end-------
END FUNCTION
 
 
