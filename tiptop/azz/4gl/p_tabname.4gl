# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: p_tabname.4gl
# Descriptions...: 檔案名稱設定維護作業
# Date & Author..: 04/03/29 alex
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-440464 05/02/02 By saki 增加log功能
# Modify.........: No.MOD-540140 05/04/20 By alex 取消 referash
# Modify.........: No.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.MOD-580237 05/08/26 By alex add gat06,gat07 and upd func
# Modify.........: No.MOD-580359 05/08/30 By alex 移除無用的 output
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.TQC-6A0040 06/10/19 By Smapmin 更改完模組名稱後要重新產生sch檔
# Modify.........: No.FUN-6A0096 06/10/30 By johnray l_time改為g_time
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60050 10/06/22 By Echo update gat06及gat07改以 p_zta的 zta03及zta09 為主.
# Modify.........: No:FUN-B90139 11/09/29 By tsai_yen 檢查簡繁字串
# Modify.........: No:FUN-BA0116 11/10/31 By joyce 新增繁簡體資料轉換action

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gat     DYNAMIC ARRAY OF RECORD
            gat01          LIKE gat_file.gat01,
            gat02          LIKE gat_file.gat02,
            gat03          LIKE gat_file.gat03,
            gat06          LIKE gat_file.gat06,   #MOD-580237
            gat07          LIKE gat_file.gat07,   #MOD-580237
            gat04          LIKE gat_file.gat04,
            gat05          LIKE gat_file.gat05
                      END RECORD,
         g_gat_t           RECORD
            gat01          LIKE gat_file.gat01,
            gat02          LIKE gat_file.gat02,
            gat03          LIKE gat_file.gat03,
            gat06          LIKE gat_file.gat06,   #MOD-580237
            gat07          LIKE gat_file.gat07,   #MOD-580237
            gat04          LIKE gat_file.gat04,
            gat05          LIKE gat_file.gat05
                      END RECORD,
         g_wc2            STRING,                 #MOD-580237
         g_sql            STRING,                 #MOD-580237
         g_rec_b          LIKE type_file.num5,    # 單身筆數            #No.FUN-680135 SMALLINT
         l_ac             LIKE type_file.num5     # 目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
#        l_sl             SMALLINT                # 目前處理的SCREEN LINE MOD-580237
DEFINE   g_cnt            LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql     STRING
DEFINE   g_argv1          LIKE gat_file.gat01
DEFINE   g_before_input_done LIKE type_file.num5   #MOD-580056 #No.FUN-680135 SMALLINT
 
MAIN
 
#   DEFINE   l_time        LIKE type_file.chr8      # 計算被使用時間   #No.FUN-680135 VARCHAR(8) #No.FUN-6A0096
   DEFINE   p_row         LIKE type_file.num5,     #MOD-580237        #No.FUN-680135 SMALLINT
            p_col         LIKE type_file.num5      #No.FUN-680135     SMALLINT
 
   OPTIONS                                         # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                              # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-6A0096 -- begin --
#     CALL cl_used(g_prog,l_time,1)                  # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
#   RETURNING l_time
     CALL cl_used(g_prog,g_time,1) RETURNING g_time
#No.FUN-6A0096 -- end --
   LET p_row = 4 LET p_col = 10
 
   OPEN WINDOW p_tabname_w AT p_row,p_col WITH FORM "azz/42f/p_tabname"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)         #MOD-580237
 
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gat02")
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_tabname_q()
   END IF
 
   CALL p_tabname_menu()
 
   CLOSE WINDOW p_tabname_w                  # 結束畫面
#No.FUN-6A0096 -- begin --
#    CALL cl_used(g_prog,l_time,2)            # 計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
#   RETURNING l_time
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
#No.FUN-6A0096 -- end --
END MAIN
 
 
 
FUNCTION p_tabname_menu()
 
    DEFINE li_sts     LIKE type_file.num5    #No.FUN-680135 SMALLINT   #MOD-580237
    DEFINE li_i       LIKE type_file.num10   #No.FUN-680135 INTEGER    #MOD-580237
    DEFINE lc_gat06   LIKE gat_file.gat06    #MOD-580237
    DEFINE lc_gat07   LIKE gat_file.gat07    #MOD-580237
 
   WHILE TRUE
      CALL p_tabname_bp("G")
      CASE g_action_choice
 
      WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL p_tabname_q()
         END IF
 
      WHEN "detail"                          # "B.單身"
         IF cl_chk_act_auth() THEN
            CALL p_tabname_b()
         ELSE
            LET g_action_choice = " "
         END IF
 
      WHEN "help"
         CALL cl_show_help()
 
      WHEN "exit"
         EXIT WHILE
 
      WHEN "controlg"                          # KEY(CONTROL-G)
         CALL cl_cmdask()
 
      WHEN "exporttoexcel"     #FUN-4B0049
         IF cl_chk_act_auth() THEN
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gat),'','')
         END IF
 
       WHEN "update_type"       #MOD-580237
         IF cl_chk_act_auth() THEN
            CALL p_tabname_upd067() RETURNING li_sts,lc_gat06,lc_gat07
            LET INT_FLAG=FALSE
            IF li_sts THEN
               FOR li_i = 1 TO g_gat.getLength()
                   IF g_gat[li_i].gat01=g_gat[l_ac].gat01 THEN
                      LET g_gat[li_i].gat06=lc_gat06
                      LET g_gat[li_i].gat07=lc_gat07
                   END IF
               END FOR
               CALL cl_generate_sch(g_gat[l_ac].gat01,'')   #TQC-6A0040
            END IF
         END IF
 
       WHEN "showlog"           #MOD-440464
         IF cl_chk_act_auth() THEN
            CALL cl_show_log("p_tabname")
         END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_tabname_q()
   CALL p_tabname_b_askkey()
END FUNCTION
 
 
FUNCTION p_tabname_b()
 
DEFINE   l_ac_t          LIKE type_file.num5,    # 未取消的ARRAY CNT           #No.FUN-680135 SMALLINT 
         l_n             LIKE type_file.num5,    # 檢查重複用                  #No.FUN-680135 SMALLINT
         l_modify_flag   LIKE type_file.chr1,    # 單身更改否                  #No.FUN-680135 VARCHAR(1)
         l_lock_sw       LIKE type_file.chr1,    # 單身鎖住否                  #No.FUN-680135 VARCHAR(1)
         l_exit_sw       LIKE type_file.chr1,    # Esc結束INPUT ARRAY 否       #No.FUN-680135 VARCHAR(1)
         p_cmd           LIKE type_file.chr1,    # 處理狀態                    #No.FUN-680135 VARCHAR(1)
         l_allow_insert  LIKE type_file.num5,    # 可否新增                    #No.FUN-680135 SMALLINT
         l_allow_delete  LIKE type_file.num5,    # 可否刪除                    #No.FUN-680135 SMALLINT
         l_jump          LIKE type_file.num5     # 判斷是否跳過AFTER ROW的處理 #No.FUN-680135 SMALLINT
DEFINE   ls_msg_o        STRING
DEFINE   ls_msg_n        STRING
DEFINE   li_i            LIKE type_file.num5     # 暫存用數值   # No:FUN-BA0116
DEFINE   lc_target       LIKE gay_file.gay01     # No:FUN-BA0116
 
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = " SELECT gat01,gat02,gat03,gat06,gat07,gat04,gat05 ", #MOD-580237
                        " FROM gat_file  WHERE gat01 = ? AND gat02= ? ",
                         " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_tabname_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gat WITHOUT DEFAULTS FROM s_gat.*
      ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
            LET g_gat_t.* = g_gat[l_ac].*  #BACKUP
 #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_tabname_set_entry_b(p_cmd)
            CALL p_tabname_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
            OPEN p_tabname_bcl USING g_gat_t.gat01, g_gat_t.gat02
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN p_tabname_bcl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_tabname_bcl INTO g_gat[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_tabname_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gat[l_ac].* TO NULL      #900423
          LET g_gat_t.* = g_gat[l_ac].*         #新輸入資料
 #         DISPLAY g_gat[l_ac].* TO s_gat[l_sl].*#MOD-580237
 #No.MOD-580056 --start
          LET g_before_input_done = FALSE
          CALL p_tabname_set_entry_b(p_cmd)
          CALL p_tabname_set_no_entry_b(p_cmd)
          LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
       AFTER FIELD gat02                        #check 代號+語言別是否重複
#         IF cl_null(g_gat[l_ac].gat02) THEN
#            LET g_gat[l_ac].gat02 = g_gat_t.gat02
 #            DISPLAY g_gat[l_ac].gat02 TO s_gat[l_sl].gat02 #MOD-580237
#            NEXT FIELD gat02
#         END IF
          IF g_gat[l_ac].gat01 != g_gat_t.gat01 OR g_gat[l_ac].gat02 != g_gat_t.gat02
          OR (g_gat[l_ac].gat01 IS NOT NULL AND g_gat_t.gat01 IS NULL)
          OR (g_gat[l_ac].gat02 IS NOT NULL AND g_gat_t.gat02 IS NULL) THEN
             SELECT count(*) INTO l_n FROM gat_file
              WHERE gat01 = g_gat[l_ac].gat01
                AND gat02 = g_gat[l_ac].gat02
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_gat[l_ac].gat01 = g_gat_t.gat01
                LET g_gat[l_ac].gat02 = g_gat_t.gat02
 #               #MOD-580237
                DISPLAY g_gat[l_ac].gat01 TO gat01
                DISPLAY g_gat[l_ac].gat02 TO gat02
#               DISPLAY g_gat[l_ac].gat01 TO s_gat[l_sl].gat01
#               DISPLAY g_gat[l_ac].gat02 TO s_gat[l_sl].gat02
                NEXT FIELD gat01
             END IF
          END IF
 
       BEFORE FIELD gat03
          LET l_modify_flag = 'Y'
          IF l_lock_sw = 'Y' THEN            #已鎖住
             LET l_modify_flag = 'N'
          END IF
          IF l_modify_flag = 'N' THEN
             LET g_gat[l_ac].gat01 = g_gat_t.gat01
             LET g_gat[l_ac].gat02 = g_gat_t.gat02
 #            #MOD-580237
             DISPLAY g_gat[l_ac].gat01 TO gat01
             DISPLAY g_gat[l_ac].gat02 TO gat02
#            DISPLAY g_gat[l_ac].gat01 TO s_gat[l_sl].gat01
#            DISPLAY g_gat[l_ac].gat02 TO s_gat[l_sl].gat02
             NEXT FIELD gat01
          END IF

       ###FUN-B90139 START ###
       AFTER FIELD gat03
          IF NOT cl_unicode_check02(g_gat[l_ac].gat02, g_gat[l_ac].gat03,"1") THEN
             NEXT FIELD gat03
          END IF
       ###FUN-B90139 END ###

       
       BEFORE DELETE                            #是否取消單身
          IF g_gat_t.gat01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
             DELETE FROM gat_file WHERE gat01 = g_gat_t.gat01
                AND gat02 = g_gat_t.gat02
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gat_t.gat01,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("del","gat_file",g_gat_t.gat01,g_gat_t.gat02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             MESSAGE "Delete OK"
             CLOSE p_tabname_bcl
             COMMIT WORK
             LET ls_msg_n = g_gat_t.gat01 CLIPPED,"",g_gat_t.gat02 CLIPPED,"",g_gat[l_ac].gat03 CLIPPED,"",g_gat[l_ac].gat04 CLIPPED,"",g_gat[l_ac].gat05 CLIPPED
              CALL cl_log("p_tabname","D",ls_msg_n,"")  # MOD-440464
          END IF
 
      AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO gat_file(gat01,gat02,gat03,gat04,gat05)
               VALUES (g_gat[l_ac].gat01,g_gat[l_ac].gat02,g_gat[l_ac].gat03,
                       g_gat[l_ac].gat04,g_gat[l_ac].gat05)
          IF SQLCA.sqlcode THEN
             #CALL cl_err(g_gat[l_ac].gat01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","gat_file",g_gat[l_ac].gat01,g_gat[l_ac].gat02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
             LET ls_msg_n = g_gat[l_ac].gat01 CLIPPED,"",g_gat[l_ac].gat02 CLIPPED,"",g_gat[l_ac].gat03 CLIPPED,"",g_gat[l_ac].gat04 CLIPPED,"",g_gat[l_ac].gat05 CLIPPED
              CALL cl_log("p_tabname","I",ls_msg_n,"")    # MOD-440464
          END IF
          CALL cl_generate_sch(g_gat[l_ac].gat01,'')
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gat[l_ac].* = g_gat_t.*
             CLOSE p_tabname_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gat[l_ac].gat01,-263,1)
             LET g_gat[l_ac].* = g_gat_t.*
          ELSE
             UPDATE gat_file SET gat01 = g_gat[l_ac].gat01,
                                 gat02 = g_gat[l_ac].gat02,
                                 gat03 = g_gat[l_ac].gat03,
                                 gat04 = g_gat[l_ac].gat04,
                                 gat05 = g_gat[l_ac].gat05
              WHERE CURRENT OF p_tabname_bcl
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gat[l_ac].gat01,SQLCA.sqlcode,0)
                CALL cl_err3("upd","gat_file",g_gat_t.gat01,g_gat_t.gat02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                LET g_gat[l_ac].* = g_gat_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE p_tabname_bcl
                COMMIT WORK
                LET ls_msg_n = g_gat[l_ac].gat01 CLIPPED,"",g_gat[l_ac].gat02 CLIPPED,"",g_gat[l_ac].gat03 CLIPPED,"",g_gat[l_ac].gat04 CLIPPED,"",g_gat[l_ac].gat05 CLIPPED
                LET ls_msg_o = g_gat_t.gat01 CLIPPED,"",g_gat_t.gat02 CLIPPED,"",g_gat_t.gat03 CLIPPED,"",g_gat_t.gat04 CLIPPED,"",g_gat_t.gat05 CLIPPED
                 CALL cl_log("p_tabname","U",ls_msg_n,ls_msg_o)    # MOD-440464
             END IF
          END IF
          CALL cl_generate_sch(g_gat[l_ac].gat01,'')
 
      AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gat[l_ac].* = g_gat_t.*
             END IF
             CLOSE p_tabname_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE p_tabname_bcl
          COMMIT WORK
 
      # No:FUN-BA0116 ---start---
      ON ACTION translate_zhtw
         LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE 
            WHEN g_gat[l_ac].gat02 = "0" LET lc_target = "2"
            WHEN g_gat[l_ac].gat02 = "2" LET lc_target = "0"
         END CASE

         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO g_gat.getLength()
            IF li_i = l_ac THEN CONTINUE FOR END IF
            IF g_gat[li_i].gat01 = g_gat[l_ac].gat01 AND 
               g_gat[li_i].gat02 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(gat03)
                     LET g_gat[l_ac].gat03 = cl_trans_utf8_twzh(g_gat[l_ac].gat02,g_gat[li_i].gat03)
                     DISPLAY g_gat[l_ac].gat03 TO gat03
                     EXIT FOR
               END CASE
            END IF
         END FOR
      # No:FUN-BA0116 --- end ---

      ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(gat01) AND l_ac > 1 THEN
             LET g_gat[l_ac].* = g_gat[l_ac-1].*
 #            DISPLAY g_gat[l_ac].* TO s_gat[l_sl].*  #MOD-580237
             NEXT FIELD gat01
          END IF
 
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
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE p_tabname_bcl
   COMMIT WORK
END FUNCTION
 
 
 
FUNCTION p_tabname_b_askkey()
    CLEAR FORM
    CALL g_gat.clear()
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = "gat01 = '",g_argv1 CLIPPED,"' "
    ELSE
 
       CONSTRUCT g_wc2 ON gat01,gat02,gat03,gat06,gat07,gat04,gat05
            FROM s_gat[1].gat01,s_gat[1].gat02,s_gat[1].gat03,
                  s_gat[1].gat06,s_gat[1].gat07,                 #MOD-580237
                 s_gat[1].gat04,s_gat[1].gat05
 
          ON ACTION about         #FUN-860033
             CALL cl_about()      #FUN-860033
 
          ON ACTION controlg      #FUN-860033
             CALL cl_cmdask()     #FUN-860033
 
          ON ACTION help          #FUN-860033
             CALL cl_show_help()  #FUN-860033
 
          ON IDLE g_idle_seconds  #FUN-860033
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
       END CONSTRUCT
       LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          RETURN
       END IF
    END IF
    CALL p_tabname_b_fill(g_wc2)
END FUNCTION
 
 
 
FUNCTION p_tabname_b_fill(p_wc2)              #BODY FILL UP
DEFINE
     p_wc2           STRING                    #CHAR(1000) MOD-580237
 
     LET g_sql = "SELECT gat01,gat02,gat03,gat06,gat07,gat04,gat05 ",  #MOD-580237
                " FROM gat_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY gat01,gat02"
 
    PREPARE p_tabname_pb FROM g_sql
    DECLARE gat_curs CURSOR FOR p_tabname_pb
 
    CALL g_gat.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH gat_curs INTO g_gat[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.SQLCODE THEN
           CALL cl_err('foreach:',SQLCA.SQLCODE,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_gat.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt=0
END FUNCTION
 
 
FUNCTION p_tabname_bp(p_ud)
 
   DEFINE p_ud    LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
       RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gat TO s_gat.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
 
        ON ACTION query                  # Q.查詢
           LET g_action_choice="query"
           EXIT DISPLAY
 
        ON ACTION detail                 # B.單身
           LET g_action_choice="detail"
           EXIT DISPLAY
 
 #       ON ACTION output                 #MOD-580359
#          LET g_action_choice="output"
#          EXIT DISPLAY
 
        ON ACTION help                   # H.說明
           LET g_action_choice="help"
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
 
           # 2004/03/24 新增語言別選項
           CALL cl_set_combo_lang("gat02")
           EXIT DISPLAY
 
        ON ACTION exit                   # Esc.結束
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
 
        ON ACTION cancel
            LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION exporttoexcel         #FUN-4B0049
           LET g_action_choice = 'exporttoexcel'
           EXIT DISPLAY
 
        #FUN-A60050 -- start --
        #ON ACTION update_type           #MOD-580237
        #   LET g_action_choice = 'update_type'
        #   LET l_ac = ARR_CURR()
        #   EXIT DISPLAY
        #FUN-A60050 -- end --
 
        ON ACTION showlog
           LET g_action_choice = "showlog"
           EXIT DISPLAY
 
        ON ACTION about         #FUN-860033
           CALL cl_about()      #FUN-860033
 
        ON ACTION controlg      #FUN-860033
           CALL cl_cmdask()     #FUN-860033
 
        ON IDLE g_idle_seconds  #FUN-860033
            CALL cl_on_idle()
            CONTINUE DISPLAY 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 #No.MOD-580056 --start
FUNCTION p_tabname_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gat01,gat02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_tabname_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gat01,gat02",FALSE)
   END IF
 
END FUNCTION
 #No.MOD-580056 --end
 
 
 FUNCTION p_tabname_upd067()   #MOD-580237
 
   DEFINE lc_gao01       LIKE gao_file.gao01
   DEFINE ls_zz011       STRING
   DEFINE lc_gat         RECORD LIKE gat_file.*
   DEFINE lc_gat_t       RECORD LIKE gat_file.*
   DEFINE l_lock_sw      LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
   DEFINE ls_msg_o       STRING
   DEFINE ls_msg_n       STRING
 
   IF g_gat.getLength() < 1  THEN
      CALL cl_err("Select gat01 ",-400,1)
      RETURN FALSE,"",""
   END IF
   IF cl_null(g_gat[l_ac].gat01) THEN
      CALL cl_err("Select gat01 ",-400,1)
      RETURN FALSE,"",""
   END IF
 
   OPEN WINDOW p_tabs_w WITH FORM "azz/42f/p_tabname_s"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_tabname_s")
 
   LET ls_zz011=""
   DECLARE p_zz011_cur CURSOR FOR SELECT gao01 FROM gao_file ORDER BY gao01
   FOREACH p_zz011_cur INTO lc_gao01
      IF cl_null(ls_zz011) THEN
         LET ls_zz011=lc_gao01
      ELSE
         LET ls_zz011=ls_zz011.trim(),",",lc_gao01 CLIPPED
      END IF
   END FOREACH
 
   CALL cl_set_combo_items("gat06",ls_zz011,ls_zz011)
 
   SELECT * INTO lc_gat.* FROM gat_file
    WHERE gat01=g_gat[l_ac].gat01 AND gat02=g_lang
 
   DISPLAY lc_gat.gat01,lc_gat.gat03,lc_gat.gat06,lc_gat.gat07
        TO gat01,gat03,gat06,gat07
   LET lc_gat_t.* = lc_gat.*
 
   BEGIN WORK
   LET g_forupd_sql = " SELECT * FROM gat_file  WHERE gat01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_tabnames_bcl CURSOR FROM g_forupd_sql
   OPEN p_tabnames_bcl USING lc_gat_t.gat01
   IF SQLCA.sqlcode THEN
      CALL cl_err('OPEN p_tabname_bcl',SQLCA.sqlcode,1)
      LET l_lock_sw = "Y"
   ELSE
      FETCH p_tabnames_bcl INTO lc_gat.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FETCH p_tabnames_bcl',SQLCA.sqlcode,1)
         LET l_lock_sw = "Y"
      END IF
   END IF
   IF l_lock_sw = "Y" THEN
       LET INT_FLAG = 0
       ROLLBACK WORK
       CLOSE WINDOW p_tabs_w
       RETURN FALSE,"",""
   END IF
 
   INPUT BY NAME lc_gat.gat06,lc_gat.gat07 WITHOUT DEFAULTS
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       ROLLBACK WORK
       CLOSE p_tabnames_bcl
       CLOSE WINDOW p_tabs_w
       RETURN FALSE,"",""
   END IF
 
   UPDATE gat_file SET gat06=lc_gat.gat06,gat07=lc_gat.gat07
    WHERE gat01=lc_gat_t.gat01
   IF STATUS THEN
      ROLLBACK WORK
   ELSE
      #No.FUN-A60050 -- start --
      #一併需更新至 zta03,zta09
      UPDATE zta_file SET zta03=lc_gat.gat06, zta09=lc_gat.gat07
       WHERE zta01=lc_gat_t.gat01
      #No.FUN-A60050 -- end --

      COMMIT WORK
      LET ls_msg_n = g_gat[l_ac].gat01 CLIPPED,"",lc_gat.gat06 CLIPPED,"",lc_gat.gat07 CLIPPED
      LET ls_msg_o = g_gat[l_ac].gat01 CLIPPED,"",lc_gat_t.gat06 CLIPPED,"",lc_gat_t.gat07 CLIPPED
      CALL cl_log("p_tabname","U",ls_msg_n,ls_msg_o)
   END IF
 
   CLOSE p_tabnames_bcl
   CLOSE WINDOW p_tabs_w
   RETURN TRUE,lc_gat.gat06,lc_gat.gat07
 
END FUNCTION
#Patch....NO.TQC-610037 <001> #
