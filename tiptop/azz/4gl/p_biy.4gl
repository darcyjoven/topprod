# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_biy
# Descriptions...: Express報表權限設定
# Date & Author..: 06/07/07 Echo  FUN-660048
# Modify.........: No.TQC-740150 07/04/20 By Echo 將程式名稱改抓gaz03
# Modify.........: No.FUN-840065 08/04/15 By kevin 增加BI銷售智慧的報表清單
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds        #FUN-660048
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gcj                  DYNAMIC ARRAY of RECORD        
            gcj01               LIKE gcj_file.gcj01,
            gcj02               LIKE gcj_file.gcj02,
            zw02                LIKE zw_file.zw02,
            gcj03               LIKE gcj_file.gcj03,
           #zz02                LIKE zz_file.zz02,
            gaz03               LIKE gaz_file.gaz03,   #TQC-740150
            gcj04               LIKE gcj_file.gcj04
                               END RECORD,
         g_gcj_t                RECORD                 # 變數舊值
            gcj01               LIKE gcj_file.gcj01,
            gcj02               LIKE gcj_file.gcj02,
            zw02                LIKE zw_file.zw02,
            gcj03               LIKE gcj_file.gcj03,
           #zz02                LIKE zz_file.zz02,
            gaz03               LIKE gaz_file.gaz03,   #TQC-740150
            gcj04               LIKE gcj_file.gcj04
                               END RECORD 
DEFINE   g_cnt                 LIKE type_file.num10,   
         g_wc2                 string,  #No.FUN-580092 HCN
         g_sql                 string,  #No.FUN-580092 HCN
         g_rec_b               LIKE type_file.num5,              # 單身筆數
         l_ac                  LIKE type_file.num5               # 目前處理的ARRAY CNT
DEFINE   g_forupd_sql          STRING
DEFINE   g_argv1               LIKE gcj_file.gcj02
 
MAIN
   DEFINE   p_row,p_col    LIKE type_file.num5
   DEFINE   l_time         LIKE type_file.chr8                # 計算被使用時間
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL cl_used(g_prog,l_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
   RETURNING l_time
 
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_biy_w AT p_row,p_col WITH FORM "azz/42f/p_biy"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from gcj_file  WHERE gcj01 = ? ",
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_biy_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1 = ARG_VAL(1)
   IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = "gcj02='",g_argv1 CLIPPED,"'"
   ELSE
       LET g_wc2 = '1=1'
   END IF
   CALL p_biy_b_fill(g_wc2)
   CALL p_biy_menu() 
 
   CLOSE WINDOW p_biy_w                       # 結束畫面
     CALL cl_used(g_prog,l_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818
   RETURNING l_time
END MAIN
 
FUNCTION p_biy_menu()
 
   WHILE TRUE
      CALL p_biy_bp("G")
      CASE g_action_choice
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_biy_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_biy_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_biy_q()                            #Query 查詢
   CALL p_biy_b_askkey()
END FUNCTION
 
FUNCTION p_biy_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   k,i             LIKE type_file.num10
   DEFINE   l_err           LIKE type_file.num5
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gcj01,gcj02,'',gcj03,'',gcj04 FROM gcj_file",
                     "  WHERE gcj02 = ? AND gcj03 = ? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_biy_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gcj WITHOUT DEFAULTS FROM s_gcj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gcj_t.* = g_gcj[l_ac].*    #BACKUP
            OPEN p_biy_bcl USING g_gcj[l_ac].gcj02,g_gcj[l_ac].gcj03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_biy_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_biy_bcl INTO g_gcj[l_ac].*
               CASE g_gcj[l_ac].gcj01
                 WHEN '1'
                    SELECT zw02 INTO g_gcj[l_ac].zw02 FROM zw_file
                        WHERE zw01 = g_gcj[l_ac].gcj02
                 WHEN '2'
                    SELECT zx02 INTO g_gcj[l_ac].zw02 FROM zx_file
                        WHERE zx01 = g_gcj[l_ac].gcj02
               END CASE
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gcj[l_ac].gcj01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               #TQC-740150
               #SELECT zz02 INTO g_gcj[l_ac].zz02
               # FROM zz_file where zz01=g_gcj[l_ac].gcj03
               SELECT gaz03 INTO g_gcj[l_ac].gaz03 FROM gaz_file
                WHERE gaz01=g_gcj[l_ac].gcj03 AND gaz02=g_lang AND gaz05="Y"
               IF g_gcj[l_ac].gaz03 is null OR g_gcj[l_ac].gaz03=" " THEN
                  SELECT gaz03 INTO g_gcj[l_ac].gaz03 FROM gaz_file
                   WHERE gaz01=g_gcj[l_ac].gcj03 AND gaz02=g_lang AND gaz05="N"
               END IF
               #END TQC-740150
 
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gcj[l_ac].* TO NULL       #900423
         LET g_gcj[l_ac].gcj01 = '1'
         LET g_gcj[l_ac].gcj04 = 'Y'
         LET g_gcj_t.* = g_gcj[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gcj01
 
      AFTER FIELD gcj01 
         IF NOT cl_null(g_gcj[l_ac].gcj01) THEN
            IF NOT cl_null(g_gcj[l_ac].gcj02) THEN 
                 CALL p_biy_gcj02() RETURNING l_err
                 IF l_err = 1 THEN
                    LET l_err = 0
                    NEXT FIELD gcj02
                 END IF
            END IF
         END IF
 
      AFTER FIELD gcj03
         IF NOT cl_null(g_gcj[l_ac].gcj03) THEN
          IF g_gcj[l_ac].gcj03 != g_gcj_t.gcj03 OR g_gcj_t.gcj03 IS NULL THEN
                 CALL p_biy_gcj03() RETURNING l_err
                 IF l_err = 1 THEN
                    LET l_err = 0
                    NEXT FIELD gcj03
                 END IF
                #SELECT COUNT(*) INTO g_cnt FROM gcj_file 
                # WHERE gcj02=g_gcj[l_ac].gcj02 AND gcj03 = g_gcj[l_ac].gcj03 
                #IF g_cnt > 0 THEN
                #   CALL cl_err(g_gcj[l_ac].gcj03,-239,1)
                #   LET g_gcj[l_ac].gcj03 = g_gcj_t.gcj03
                #   LET g_gcj[l_ac].zz02 = g_gcj_t.zz02
                #   NEXT FIELD gcj03
                #END IF 
                #SELECT count(*) INTO g_cnt FROM zz_file
                # WHERE zz01 = g_gcj[l_ac].gcj03 AND g_gcj[l_ac].gcj03 LIKE 'bo%'
                #IF g_cnt = 0 THEN  #資料不存在
                #   CALL cl_err(g_gcj[l_ac].gcj03,'azz-052',0)
                #   LET g_gcj[l_ac].gcj03 =  g_gcj_t.gcj03
                #   LET g_gcj[l_ac].zz02 = g_gcj_t.zz02
                #   NEXT FIELD gcj03
                #END IF
                #SELECT zz02 INTO g_gcj[l_ac].zz02 
                # FROM zz_file where zz01=g_gcj[l_ac].gcj03
                #DISPLAY g_gcj[l_ac].zz02 TO FORMONLY.zz02
                #TQC-740150
                LET g_gcj[l_ac].gaz03 = ""
                SELECT gaz03 INTO g_gcj[l_ac].gaz03 FROM gaz_file
                 WHERE gaz01=g_gcj[l_ac].gcj03 AND gaz02=g_lang AND gaz05="Y"
                IF g_gcj[l_ac].gaz03 is null OR g_gcj[l_ac].gaz03=" " THEN
                   SELECT gaz03 INTO g_gcj[l_ac].gaz03 FROM gaz_file
                    WHERE gaz01=g_gcj[l_ac].gcj03 AND gaz02=g_lang AND gaz05="N"
                END IF
                #END TQC-740150
           END IF
          END IF
 
 
      AFTER FIELD gcj02 
         IF NOT cl_null(g_gcj[l_ac].gcj02) THEN
           IF g_gcj[l_ac].gcj02 != g_gcj_t.gcj02 OR g_gcj_t.gcj02 IS NULL THEN
             SELECT COUNT(*) INTO g_cnt FROM gcj_file 
                 where gcj03 = g_gcj[l_ac].gcj03 AND gcj02=g_gcj[l_ac].gcj02
             IF g_cnt > 0 THEN
                     CALL cl_err(g_gcj[l_ac].gcj02,-239,1)
                     LET g_gcj[l_ac].gcj02 = g_gcj_t.gcj02
                     LET g_gcj[l_ac].zw02 = g_gcj_t.zw02
                     NEXT FIELD gcj02
             END IF 
             CALL p_biy_gcj02() RETURNING l_err
             IF l_err = 1 THEN
                LET l_err = 0
                NEXT FIELD gcj02
             END IF
            # CASE g_gcj[l_ac].gcj01
            #     WHEN '1'
            #       SELECT zw02,zwacti INTO g_gcj[l_ac].zw02 ,l_zwacti
            #        FROM zw_file where zw01=g_gcj[l_ac].gcj02
            #       IF SQLCA.SQLCODE THEN
            #          #CALL cl_err(g_zy01,SQLCA.SQLCODE,1)  #No.FUN-660081
            #          CALL cl_err3("sel","zw_file",g_gcj[l_ac].gcj02,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
            #          LET g_gcj[l_ac].gcj02 = g_gcj_t.gcj02
            #          LET g_gcj[l_ac].zw02 = g_gcj_t.zw02
            #          NEXT FIELD gcj02
            #        ELSE                     #MOD-560212
            #          IF l_zwacti = "N" THEN
            #             CALL cl_err_msg(NULL,"azz-218",g_gcj[l_ac].gcj02 CLIPPED,10)
            #             LET g_gcj[l_ac].gcj02 = g_gcj_t.gcj02
            #             LET g_gcj[l_ac].zw02 = g_gcj_t.zw02
            #             NEXT FIELD gcj02
            #          END IF
            #       END IF
            #     WHEN '2'
            #       SELECT zx02 INTO g_gcj[l_ac].zw02 
            #        FROM zx_file where zx01=g_gcj[l_ac].gcj02
            #       IF sqlca.sqlcode THEN
            #          LET g_gcj[l_ac].gcj02 = g_gcj_t.gcj02
            #          LET g_gcj[l_ac].zw02 = g_gcj_t.zw02
            #          #CALL cl_err("Select p_zx,",SQLCA.SQLCODE,1)   #No.FUN-660081
            #          CALL cl_err3("sel","zx_file",g_gcj[l_ac].gcj02,"",SQLCA.sqlcode,"","Select p_zx",1)   #No.FUN-660081
            #          NEXT FIELD gcj02
            #       END IF
            # END CASE
            # DISPLAY g_gcj[l_ac].zw02 TO FORMONLY.zw02
           END IF
          END IF
       
      BEFORE DELETE#是否取消單身
         IF (NOT cl_null(g_gcj_t.gcj02)) AND (NOT cl_null(g_gcj_t.gcj03)) THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
           END IF
           DELETE FROM gcj_file
              WHERE gcj02 = g_gcj[l_ac].gcj02 AND gcj03 = g_gcj[l_ac].gcj03
           IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gcj[l_ac].gcj03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gcj_file",g_gcj[l_ac].gcj02,g_gcj_t.gcj03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
          END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO gcj_file(gcj01,gcj02,gcj03,gcj04)
             VALUES (g_gcj[l_ac].gcj01,g_gcj[l_ac].gcj02,g_gcj[l_ac].gcj03,g_gcj[l_ac].gcj04)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gcj01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gcj_file",g_gcj[l_ac].gcj02,g_gcj[l_ac].gcj03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gcj[l_ac].* = g_gcj_t.*
            END IF
            CLOSE p_biy_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_biy_bcl
         COMMIT WORK
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_gcj[l_ac].* = g_gcj_t.*
          CLOSE p_biy_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err("", -263, 1)
           LET g_gcj[l_ac].* = g_gcj_t.*
        ELSE
           UPDATE gcj_file SET gcj01=g_gcj[l_ac].gcj01,
                               gcj02=g_gcj[l_ac].gcj02,
                               gcj03=g_gcj[l_ac].gcj03,
                               gcj04=g_gcj[l_ac].gcj04
           WHERE gcj02 = g_gcj_t.gcj02 AND gcj03 = g_gcj_t.gcj03
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","gcj_file",g_gcj_t.gcj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_gcj[l_ac].* = g_gcj_t.*
           ELSE
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF
        END IF
     AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gcj[l_ac].* = g_gcj_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gcj.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_biy_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE p_biy_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(gcj02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.default1 = g_gcj[l_ac].gcj02  #TQC-740150
                   CASE g_gcj[l_ac].gcj01 
                     WHEN '1'
                         LET g_qryparam.form ="q_zw"
                         CALL cl_create_qry() RETURNING g_gcj[l_ac].gcj02
                         DISPLAY g_gcj[l_ac].gcj02 TO gcj02
                     WHEN '2'
                         LET g_qryparam.form ="q_zx"
                         CALL cl_create_qry() RETURNING g_gcj[l_ac].gcj02
                         DISPLAY g_gcj[l_ac].gcj02 TO gcj02
                   END CASE
            WHEN INFIELD(gcj03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_zz3"
                   LET g_qryparam.arg1 =  g_lang
                   LET g_qryparam.default1 = g_gcj[l_ac].gcj03  #TQC-740150
                   CALL cl_create_qry() RETURNING g_gcj[l_ac].gcj03,g_gcj[l_ac].gaz03  #TQC-740150
                   DISPLAY g_gcj[l_ac].gcj03 TO gcj03
                  #TQC-740150
                  #DISPLAY g_gcj[l_ac].zz02 TO FORMONLY.zz02
                   IF g_gcj[l_ac].gaz03 is null OR g_gcj[l_ac].gaz03=" " THEN
                      SELECT gaz03 INTO g_gcj[l_ac].gaz03 FROM gaz_file
                       WHERE gaz01=g_gcj[l_ac].gcj03 AND gaz02=g_lang AND gaz05="Y"
                      IF g_gcj[l_ac].gaz03 is null OR g_gcj[l_ac].gaz03=" " THEN
                         SELECT gaz03 INTO g_gcj[l_ac].gaz03 FROM gaz_file
                          WHERE gaz01=g_gcj[l_ac].gcj03 AND gaz02=g_lang AND gaz05="N"
                      END IF
                   END IF
                   DISPLAY g_gcj[l_ac].gaz03 TO FORMONLY.gaz03   
                  #END TQC-740150
              OTHERWISE
                   EXIT CASE
         END CASE
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
       ON ACTION CONTROLF                       #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CLOSE p_biy_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_biy_b_askkey()
    CLEAR FORM
    CALL g_gcj.clear()
 
    CONSTRUCT g_wc2 ON gcj01,gcj02,gcj03,gjc04
         FROM s_gcj[1].gcj01,s_gcj[1].gcj02,s_gcj[1].gcj03,
              s_gcj[1].gcj04
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(gcj02)
                   CALL cl_init_qry_var()
                   MENU "" ATTRIBUTE(STYLE="popup")
                      ON ACTION q_zx
                         LET g_qryparam.form ="q_zx"
                      ON ACTION q_zw
                         LET g_qryparam.form ="q_zw"
                      ON IDLE g_idle_seconds
                         CALL cl_on_idle()
                         CONTINUE MENU
                   END MENU
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_gcj[1].gcj02
            WHEN INFIELD(gcj03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_zz3"
                   LET g_qryparam.arg1 =  g_lang
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_gcj[1].gcj03
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
 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CALL p_biy_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_biy_b_fill(p_wc)              #BODY FILL UP
   DEFINE  
   # p_wc   LIKE type_file.chr1000
     p_wc         STRING       #NO.FUN-910082
 
    #TQC-740150
    #LET g_sql = "SELECT gcj01,gcj02,'',gcj03,zz02,gcj04",
    #              "  FROM gcj_file ,zz_file ",
    #              " WHERE gcj03 = zz01 ",
    #              "   AND ",p_wc CLIPPED,
    #              " ORDER BY gcj01"
     LET g_sql = "SELECT gcj01,gcj02,'',gcj03,'',gcj04",
                   "  FROM gcj_file ",
                   " WHERE ",p_wc CLIPPED,
                   " ORDER BY gcj01"
    #END TQC-740150
 
    PREPARE p_biy_prepare3 FROM g_sql           #預備一下
    DECLARE biy_curs3 CURSOR FOR p_biy_prepare3
 
    CALL g_gcj.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH biy_curs3 INTO g_gcj[g_cnt].*
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE g_gcj[g_cnt].gcj01
         WHEN '1'
            SELECT zw02 INTO g_gcj[g_cnt].zw02 FROM zw_file 
                WHERE zw01 = g_gcj[g_cnt].gcj02
         WHEN '2' 
            SELECT zx02 INTO g_gcj[g_cnt].zw02 FROM zx_file
                WHERE zx01 = g_gcj[g_cnt].gcj02
       END CASE
       #TQC-740150
       SELECT gaz03 INTO g_gcj[g_cnt].gaz03 FROM gaz_file
        WHERE gaz01=g_gcj[g_cnt].gcj03 AND gaz02=g_lang AND gaz05="Y"
       IF g_gcj[g_cnt].gaz03 is null OR g_gcj[g_cnt].gaz03=" " THEN
          SELECT gaz03 INTO g_gcj[g_cnt].gaz03 FROM gaz_file
           WHERE gaz01=g_gcj[g_cnt].gcj03 AND gaz02=g_lang AND gaz05="N"
       END IF
       #END TQC-740150
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gcj.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_biy_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gcj TO s_gcj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_biy_gcj03()
 
   SELECT COUNT(*) INTO g_cnt FROM gcj_file 
    WHERE gcj02=g_gcj[l_ac].gcj02 AND gcj03 = g_gcj[l_ac].gcj03 
   IF g_cnt > 0 THEN
      CALL cl_err(g_gcj[l_ac].gcj03,-239,1)
      LET g_gcj[l_ac].gcj03 = g_gcj_t.gcj03
     #LET g_gcj[l_ac].zz02 = g_gcj_t.zz02
      LET g_gcj[l_ac].gaz03 = g_gcj_t.gaz03      #TQC-740150
      RETURN 1
   END IF 
   SELECT count(*) INTO g_cnt FROM zz_file
    #WHERE zz01 = g_gcj[l_ac].gcj03 AND g_gcj[l_ac].gcj03 LIKE 'bo%' 
    WHERE zz01 = g_gcj[l_ac].gcj03 AND (g_gcj[l_ac].gcj03 LIKE 'bo%' or g_gcj[l_ac].gcj03 LIKE 'bi%') #FUN-840065
   IF g_cnt = 0 THEN  #資料不存在
      CALL cl_err(g_gcj[l_ac].gcj03,'azz-052',0)
      LET g_gcj[l_ac].gcj03 =  g_gcj_t.gcj03
     #LET g_gcj[l_ac].zz02 = g_gcj_t.zz02
      LET g_gcj[l_ac].gaz03 = g_gcj_t.gaz03      #TQC-740150
      RETURN 1
   END IF
   #TQC-740150
   #SELECT zz02 INTO g_gcj[l_ac].zz02
   # FROM zz_file where zz01=g_gcj[l_ac].gcj03
   SELECT gaz03 INTO g_gcj[l_ac].gaz03 FROM gaz_file
    WHERE gaz01=g_gcj[l_ac].gcj03 AND gaz02=g_lang AND gaz05="Y"
   IF g_gcj[l_ac].gaz03 is null OR g_gcj[l_ac].gaz03=" " THEN
      SELECT gaz03 INTO g_gcj[l_ac].gaz03 FROM gaz_file
       WHERE gaz01=g_gcj[l_ac].gcj03 AND gaz02=g_lang AND gaz05="N"
   END IF
   #DISPLAY g_gcj[l_ac].zz02 TO FORMONLY.zz02
   DISPLAY g_gcj[l_ac].gaz03 TO FORMONLY.gaz03
   #END TQC-740150
   RETURN 0
END FUNCTION
 
FUNCTION p_biy_gcj02()
   DEFINE   l_zwacti        LIKE zw_file.zwacti 
 
   CASE g_gcj[l_ac].gcj01
       WHEN '1'
         SELECT zw02,zwacti INTO g_gcj[l_ac].zw02 ,l_zwacti
          FROM zw_file where zw01=g_gcj[l_ac].gcj02
         IF SQLCA.SQLCODE THEN
            #CALL cl_err(g_zy01,SQLCA.SQLCODE,1)  #No.FUN-660081
            CALL cl_err3("sel","zw_file",g_gcj[l_ac].gcj02,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
            LET g_gcj[l_ac].gcj02 = g_gcj_t.gcj02
            LET g_gcj[l_ac].zw02 = g_gcj_t.zw02
            RETURN 1
          ELSE                     #MOD-560212
            IF l_zwacti = "N" THEN
               CALL cl_err_msg(NULL,"azz-218",g_gcj[l_ac].gcj02 CLIPPED,10)
               LET g_gcj[l_ac].gcj02 = g_gcj_t.gcj02
               LET g_gcj[l_ac].zw02 = g_gcj_t.zw02
               RETURN 1
            END IF
         END IF
       WHEN '2'
         SELECT zx02 INTO g_gcj[l_ac].zw02 
          FROM zx_file where zx01=g_gcj[l_ac].gcj02
         IF sqlca.sqlcode THEN
            LET g_gcj[l_ac].gcj02 = g_gcj_t.gcj02
            LET g_gcj[l_ac].zw02 = g_gcj_t.zw02
            #CALL cl_err("Select p_zx,",SQLCA.SQLCODE,1)   #No.FUN-660081
            CALL cl_err3("sel","zx_file",g_gcj[l_ac].gcj02,"",SQLCA.sqlcode,"","Select p_zx",1)   #No.FUN-660081
            RETURN 1
         END IF
   END CASE
   DISPLAY g_gcj[l_ac].zw02 TO FORMONLY.zw02
   RETURN 0
END FUNCTION
