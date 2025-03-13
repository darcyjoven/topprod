# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_all_act.4gl
# Descriptions...: Action 代碼及基本資料維護作業
# Date & Author..: 04/04/01 alex
# Modify.........: No.FUN-4B0049 04/11/18 By Yuna 加轉 excel 檔功能
# Modify.........: No.FUN-530022 05/03/17 By alex 修正 standard 功能
# Modify.........: No.MOD-530203 05/03/23 By alex 因 gbd07 規格變更, 移除 gbd07
# Modify.........: No.MOD-540072 05/04/12 By alex 修正 203 產生的錯誤
# Modify.........: No.MOD-540140 05/04/20 By alex 取消 referash
# Modify.........: No.MOD-580056 05/08/04 By yiting key可更改
# Modify.........: No.MOD-580196 05/08/17 By alex 筆數計算錯誤
# Modify.........: No.MOD-580359 05/08/30 By alex 移除不需要的 output
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen 欄位類型修改`
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770078 07/07/22 By Nicola 新增欄位異動日期(gbd11)
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gbd     DYNAMIC ARRAY OF RECORD 
            gbd06          LIKE gbd_file.gbd06,  
            gbd01          LIKE gbd_file.gbd01,  
            gbd03          LIKE gbd_file.gbd03,
            gbd04          LIKE gbd_file.gbd04,
            gbd05          LIKE gbd_file.gbd05,
 #          gbd07          LIKE gbd_file.gbd07,  #MOD-530203
            gbd02          LIKE gbd_file.gbd02,  
            gbd11          LIKE gbd_file.gbd11   #No.FUN-770078 
                      END RECORD,
         g_gbd_t           RECORD 
            gbd06          LIKE gbd_file.gbd06,  
            gbd01          LIKE gbd_file.gbd01,  
            gbd03          LIKE gbd_file.gbd03,
            gbd04          LIKE gbd_file.gbd04,
            gbd05          LIKE gbd_file.gbd05,
 #          gbd07          LIKE gbd_file.gbd07,  #MOD-530203
            gbd02          LIKE gbd_file.gbd02, 
            gbd11          LIKE gbd_file.gbd11   #No.FUN-770078 
                      END RECORD,
         g_wc2            STRING,
         g_sql            STRING,
         g_rec_b          LIKE type_file.num5,          #單身筆數               #No.FUN-680135 SMALLINT
         l_ac             LIKE type_file.num5,          #目前處理的ARRAY CNT    #No.FUN-680135 SMALLINT
         l_sl             LIKE type_file.num5           #No.FUN-680135 SMALLINT #目前處理的SCREEN LINE  
DEFINE g_cnt            LIKE type_file.num10          #No.FUN-680135 INTEGER
DEFINE g_forupd_sql     STRING
DEFINE g_argv1          STRING
DEFINE g_before_input_done   LIKE type_file.num5        #NO.MOD-580056 #No.FUN-680135 SMALLINT
 
MAIN
   OPTIONS                                     # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   # 計算使用時間 (進入時間)
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
 
   LET g_argv1 = ARG_VAL(1)
 
   OPEN WINDOW p_all_act_w WITH FORM "azz/42f/p_all_act"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   # 語言別設定
   CALL cl_set_combo_lang('gbd03')
 
   # 2004/04/27 新增可以接參數  直接進入編輯  為串接至 p_zz 用
   IF NOT cl_null(g_argv1) THEN
      CALL p_all_act_q()
   END IF
 
   CALL p_all_act_menu()
 
   CLOSE WINDOW p_all_act_w                            # 結束畫面
   CALL cl_used(g_prog,g_time,2)                  # 計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
END MAIN
 
 
FUNCTION p_all_act_menu()
 
   WHILE TRUE
      CALL p_all_act_bp("G")
      CASE g_action_choice
 
      WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL p_all_act_q()
         END IF
 
      WHEN "detail"                            # "B.單身"
         IF cl_chk_act_auth() THEN
            CALL p_all_act_b()
         ELSE
            LET g_action_choice = " "
         END IF
 
      WHEN "help"
         CALL cl_show_help()
 
      WHEN "exit"
         EXIT WHILE
 
      WHEN "controlg"                          # KEY(CONTROL-G)
         CALL cl_cmdask()
 
      WHEN "locale"
         CALL cl_set_combo_lang("gbd03")
 
      WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gbd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_all_act_q()
   CALL p_all_act_b_askkey()
END FUNCTION
 
 
FUNCTION p_all_act_b()
 
DEFINE   l_ac_t          LIKE type_file.num5,                  #未取消的ARRAY CNT #No.FUN-680135 SMALLINT SMALLINT
         l_n             LIKE type_file.num5,                  #檢查重複用        #No.FUN-680135 SMALLINT
         l_lock_sw       LIKE type_file.chr1,                  #單身鎖住否        #No.FUN-680135 VARCHAR(1)
         l_exit_sw       LIKE type_file.chr1,                  #No.FUN-680135  VARCHAR(1)   #Esc結束INPUT ARRAY 否  
         p_cmd           LIKE type_file.chr1,                  #處理狀態          #No.FUN-680135 VARCHAR(1)
         l_allow_insert  LIKE type_file.num5,                  #可否新增          #No.FUN-680135 SMALLINT
         l_allow_delete  LIKE type_file.num5,                  #可否刪除          #No.FUN-680135 SMALLINT
         l_jump          LIKE type_file.num5                   #No.FUN-680135  SMALLINT  #判斷是否跳過AFTER ROW的處理
 
   CALL cl_opmsg('b')
 
   IF s_shut(0) THEN 
      RETURN 
   END IF
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
#  #MOD-530203
#  LET g_forupd_sql=" SELECT gbd06,gbd01,gbd03,gbd04,gbd05,gbd07,gbd02 ",
   LET g_forupd_sql=" SELECT gbd06,gbd01,gbd03,gbd04,gbd05,gbd02,gbd11 ",   #No.FUN-770078
                      " FROM gbd_file  WHERE gbd01= ? AND gbd02= ? ",
                        " AND gbd03=? AND gbd07='N' FOR UPDATE "  #MOD-540072
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_all_act_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gbd WITHOUT DEFAULTS FROM s_gbd.*
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
            LET g_gbd_t.* = g_gbd[l_ac].*  #BACKUP
 #No.MOD-580056 --start
           LET g_before_input_done = FALSE
           CALL p_all_act_set_entry(p_cmd)
           CALL p_all_act_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 #No.MOD-5800560 --end
 
            OPEN p_all_act_bcl
                 USING g_gbd_t.gbd01, g_gbd_t.gbd02, g_gbd_t.gbd03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_all_act_bcl",SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_all_act_bcl INTO g_gbd[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_all_act_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_gbd[l_ac].gbd11 = TODAY   #No.FUN-770078
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          # 2004/04/22 新增初始值設定
          INITIALIZE g_gbd[l_ac].* TO NULL      #900423
          LET g_gbd[l_ac].gbd06 = "N"
#         LET g_gbd[l_ac].gbd07 = "N"
          LET g_gbd[l_ac].gbd02 = "standard"
          LET g_gbd[l_ac].gbd11 = TODAY   #No.FUN-770078
          LET g_gbd_t.* = g_gbd[l_ac].*         #新輸入資料
 #No.MOD-580056 --start
           LET g_before_input_done = FALSE
           CALL p_all_act_set_entry(p_cmd)
           CALL p_all_act_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 #No.MOD-5800560 --end
          CALL cl_show_fld_cont()               #FUN-550037(smin)
 
       AFTER FIELD gbd02                        #check 代號+語言別是否重複
          IF g_gbd[l_ac].gbd02 NOT MATCHES '[012]' OR cl_null(g_gbd[l_ac].gbd02) THEN
             LET g_gbd[l_ac].gbd02 = g_gbd_t.gbd02
             DISPLAY g_gbd[l_ac].gbd02 TO s_gbd[l_sl].gbd02
             NEXT FIELD gbd02 
          END IF 
          IF g_gbd[l_ac].gbd01 != g_gbd_t.gbd01 OR g_gbd[l_ac].gbd02 != g_gbd_t.gbd02
          OR (g_gbd[l_ac].gbd01 IS NOT NULL AND g_gbd_t.gbd01 IS NULL) 
          OR (g_gbd[l_ac].gbd02 IS NOT NULL AND g_gbd_t.gbd02 IS NULL) THEN
             SELECT count(*) INTO l_n FROM gbd_file
              WHERE gbd01 = g_gbd[l_ac].gbd01
                AND gbd02 = g_gbd[l_ac].gbd02
                AND gbd03 = g_gbd[l_ac].gbd03
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_gbd[l_ac].gbd01 = g_gbd_t.gbd01
                LET g_gbd[l_ac].gbd02 = g_gbd_t.gbd02
                DISPLAY g_gbd[l_ac].gbd01 TO s_gbd[l_sl].gbd01
                DISPLAY g_gbd[l_ac].gbd02 TO s_gbd[l_sl].gbd02
                NEXT FIELD gbd01
             END IF
          END IF
 
       BEFORE FIELD gbd05
          CALL s_textedit(g_gbd[l_ac].gbd05) 
          RETURNING g_gbd[l_ac].gbd05
          DISPLAY g_gbd[l_ac].gbd05 TO gbd05
 
       BEFORE DELETE                            #是否取消單身
          IF g_gbd_t.gbd01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
             DELETE FROM gbd_file
              WHERE gbd01 = g_gbd_t.gbd01
                AND gbd02 = g_gbd_t.gbd02
                AND gbd03 = g_gbd_t.gbd03
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gbd_t.gbd01,SQLCA.sqlcode,0)  #No.FUN-660081 
                CALL cl_err3("del","gbd_file",g_gbd_t.gbd01,g_gbd_t.gbd02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                ROLLBACK WORK 
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             MESSAGE "Delete OK"
             CLOSE p_all_act_bcl
             COMMIT WORK 
          END IF
 
      AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO gbd_file(gbd01,gbd02,gbd03,gbd04,gbd05,gbd06,gbd07,gbd11)   #No.FUN-770078
               VALUES (g_gbd[l_ac].gbd01,g_gbd[l_ac].gbd02,
                       g_gbd[l_ac].gbd03,g_gbd[l_ac].gbd04,
                       g_gbd[l_ac].gbd05,g_gbd[l_ac].gbd06,
 #                     g_gbd[l_ac].gbd07)   #MOD-530203
                       "N",g_gbd[l_ac].gbd11)   #No.FUN-770078
          IF SQLCA.sqlcode THEN
             #CALL cl_err(g_gbd[l_ac].gbd01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","gbd_file",g_gbd[l_ac].gbd01,g_gbd[l_ac].gbd02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
          END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gbd[l_ac].* = g_gbd_t.*
             CLOSE p_all_act_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gbd[l_ac].gbd01,-263,1)
             LET g_gbd[l_ac].* = g_gbd_t.*
          ELSE
             UPDATE gbd_file SET gbd01 = g_gbd[l_ac].gbd01,
                                 gbd02 = g_gbd[l_ac].gbd02,
                                 gbd03 = g_gbd[l_ac].gbd03,
                                 gbd04 = g_gbd[l_ac].gbd04,
                                 gbd05 = g_gbd[l_ac].gbd05,
                                 gbd06 = g_gbd[l_ac].gbd06,  #MOD-540072
                                 gbd11 = g_gbd[l_ac].gbd11   #No.FUN-770078
              WHERE CURRENT OF p_all_act_bcl
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gbd[l_ac].gbd01,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("upd","gbd_file",g_gbd_t.gbd01,g_gbd_t.gbd02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                LET g_gbd[l_ac].* = g_gbd_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE p_all_act_bcl
                COMMIT WORK 
             END IF
          END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gbd[l_ac].* = g_gbd_t.*
             #FUN-D30034--add--begin--
             ELSE
                CALL g_gbd.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end----
             END IF
             CLOSE p_all_act_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE p_all_act_bcl
          COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(gbd01) AND l_ac > 1 THEN
             LET g_gbd[l_ac].* = g_gbd[l_ac-1].*
             DISPLAY g_gbd[l_ac].* TO s_gbd[l_sl].* 
             NEXT FIELD gbd01
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
 
 
   END INPUT
 
   CLOSE p_all_act_bcl
   COMMIT WORK 
END FUNCTION
 
 
 
FUNCTION p_all_act_b_askkey()
 
   CLEAR FORM
   CALL g_gbd.clear()
 
   # 2004/04/27 新增可傳參數  如果傳入參數  則令 CONSTRUCT 失效
   IF cl_null(g_argv1) THEN
 
 #     #MOD-530203
#     CONSTRUCT g_wc2 ON gbd06,gbd01,gbd03,gbd04,gbd05,gbd07,gbd02
      CONSTRUCT g_wc2 ON gbd06,gbd01,gbd03,gbd04,gbd05,gbd02,gbd11   #No.FUN-770078
           FROM s_gbd[1].gbd06,s_gbd[1].gbd01,s_gbd[1].gbd03,s_gbd[1].gbd04,
                s_gbd[1].gbd05,s_gbd[1].gbd02,s_gbd[1].gbd11   #No.FUN-770078
#               s_gbd[1].gbd05,s_gbd[1].gbd07,s_gbd[1].gbd02
 
         ON IDLE g_idle_seconds  #FUN-860033
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
      END CONSTRUCT
      LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
   ELSE
      CALL p_all_act_check_arg(g_argv1) RETURNING g_wc2
   END IF
 
   CALL p_all_act_b_fill(g_wc2)
END FUNCTION
 
 
 
FUNCTION p_all_act_b_fill(p_wc2)              #BODY FILL UP
 
   DEFINE p_wc2       STRING
 
 #   #MOD-530203
#   LET g_sql = "SELECT gbd06,gbd01,gbd03,gbd04,gbd05,gbd07,gbd02 ", 
    LET g_sql = "SELECT gbd06,gbd01,gbd03,gbd04,gbd05,gbd02,gbd11 ",    #No.FUN-770078
                " FROM gbd_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY gbd06 ASC,gbd01,gbd03"
 
    PREPARE p_all_act_pb FROM g_sql
    DECLARE gbd_curs CURSOR FOR p_all_act_pb
 
    CALL g_gbd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gbd_curs INTO g_gbd[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_gbd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
     DISPLAY g_rec_b TO FORMONLY.cn2   #MOD-580196
    LET g_cnt=0
END FUNCTION
 
 
FUNCTION p_all_act_bp(p_ud)
 
   DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
       RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gbd TO s_gbd.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
           LET g_action_choice="locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_dynamic_locale()
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
 
        ON ACTION close
           LET g_action_choice="exit"
           EXIT DISPLAY
        
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
        ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
# 2004/04/27 接參數  如果有參數  則先判斷參數中的 Action id 是否都在 db
#            中有建資料, 如果沒有就 show 給 user 並詢問是否建立, 如果 user
#            想要建立就先建立, 如果不想建立就先踢除這些資料
 
FUNCTION p_all_act_check_arg(ls_gap02)
 
   DEFINE ls_gap02        STRING
   DEFINE lt_gap02        base.StringTokenizer
   DEFINE ls_gbd01        STRING
   DEFINE li_index        LIKE type_file.num5         #FUN-680135 SMALLINT
   DEFINE li_lang         LIKE type_file.num5         #FUN-680135 SMALLINT
   DEFINE li_i            LIKE type_file.num5         #FUN-680135 SMALLINT
   DEFINE li_string_count LIKE type_file.num5         #FUN-680135 SMALLINT
   DEFINE li_item         LIKE type_file.num5         #FUN-680135 SMALLINT
   DEFINE lc_flag         LIKE type_file.chr2         #FUN-680135 VARCHAR(2)
   DEFINE la_gbd          DYNAMIC ARRAY OF RECORD
             gbd01          LIKE gbd_file.gbd01,
             gbd03          LIKE gbd_file.gbd03,
             exist          LIKE type_file.chr1       #FUN-680135 VARCHAR(1)
                          END RECORD
   DEFINE ls_return       STRING
 
   CALL la_gbd.clear()
   LET li_index = 1
   LET lc_flag = "NN"
   # 選定語言種類
   SELECT COUNT(DISTINCT gay01) INTO li_lang FROM gay_file
 
   # 2004/04/27 輸出各項 4ad
   LET lt_gap02 = base.StringTokenizer.create(ls_gap02 CLIPPED, ",")
   WHILE lt_gap02.hasMoreTokens()
 
      LET ls_gbd01 = lt_gap02.nextToken()
      LET la_gbd[li_index].gbd01 = ls_gbd01.trim()
 
      SELECT COUNT(*) INTO li_item FROM gbd_file
       WHERE gbd01=la_gbd[li_index].gbd01
 
      CASE
         WHEN li_item = 0 
            LET la_gbd[li_index].exist= "0" # 一個都沒有, 一次新增  
            LET lc_flag[1] = "Y"
         WHEN ( li_item > 0 AND li_item < li_lang )
            LET la_gbd[li_index].exist= "1" # 有但個數不足, 不增  
            SELECT gbd03 INTO la_gbd[li_index].gbd03 FROM gbd_file
             WHERE gbd01=la_gbd[li_index].gbd01
               AND gbd02="standard" AND gbd03 = g_lang
            LET lc_flag[2] = "Y"
         OTHERWISE
            LET la_gbd[li_index].exist= "2" # 個數足, 不增  
      END CASE
 
      LET li_index = li_index + 1
   END WHILE
   LET li_index = li_index - 1
 
 
   # 顯示提示字串 1: 詢問是否新增資料庫中沒有的 action id
   LET ls_return = ""
   IF lc_flag[1]="Y" THEN
      IF cl_confirm("azz-029") THEN
         FOR li_i = 1 TO li_index
           IF la_gbd[li_i].exist = 0 THEN
              INSERT INTO gbd_file (gbd01,gbd02,gbd03,gbd06,gbd07,gbd11)   #No.FUN-770078
                 VALUES(la_gbd[li_i].gbd01,"standard","0","N","N",TODAY)   #No.FUN-770078
              INSERT INTO gbd_file (gbd01,gbd02,gbd03,gbd06,gbd07,gbd11)   #No.FUN-770078
                 VALUES(la_gbd[li_i].gbd01,"stardard","1","N","N",TODAY)   #No.FUN-770078
              INSERT INTO gbd_file (gbd01,gbd02,gbd03,gbd06,gbd07,gbd11)   #No.FUN-770078
                 VALUES(la_gbd[li_i].gbd01,"stardard","2","N","N",TODAY)   #No.FUN-770078
           END IF
         END FOR
      END IF
   END IF
 
   # 組出提示字串 2: 提示某些 action id 個數不足語言別數目
 
   # 組出回傳字串
   LET ls_return = ""
   FOR li_i = 1 TO li_index
      LET ls_return = "OR gbd01='",la_gbd[li_i].gbd01 CLIPPED,"' ",ls_return.trim()
   END FOR
   LET ls_return = ls_return.trim()
   LET li_string_count = ls_return.getLength()
   LET ls_return = ls_return.subString(3,li_string_count)
 
   RETURN ls_return
 
END FUNCTION
 
 #No.MOD-580056--start
FUNCTION p_all_act_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gbd01,gbd03,gbd07",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_all_act_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gbd01,gbd03,gbd07",FALSE)
   END IF
END FUNCTION
 #No.MOD-580056--end
 
