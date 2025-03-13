# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: p_zbo.4gl
# Descriptions...: 報表關聯設定維護作業
# Date & Author..: 2005.12.02 By Leagh FUN-660048
# Modify.........: 06/06/15 No.FUN-660081 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/09/15 By ice 欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time改為g_time
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-740155 07/04/26 By kim zz02以gaz03取代
# Modify.........: No.FUN-740207 07/05/03 By Echo 增加顯示Express報表ID
# Modify.........: No.FUN-840065 08/04/15 By kevin g_argv6 add Y:表示為 Express 報表,N:表示為 BI 報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題 
 
DATABASE ds
 
GLOBALS "../../config/top.global"  
 
DEFINE 
    g_gcg01         LIKE gcg_file.gcg01,   #           (假單頭)
    g_gcg02         LIKE gcg_file.gcg02,   #           (假單頭)
    g_gcg03         LIKE gcg_file.gcg03,   #           (假單頭)
    g_gcg04         LIKE gcg_file.gcg04,   #           (假單頭)
    g_gcg05         LIKE gcg_file.gcg05,   #           (假單頭)
    g_gcg01_t       LIKE gcg_file.gcg01,   #           (舊值)
    g_gcg02_t       LIKE gcg_file.gcg02,   #           (舊值)
    g_gcg03_t       LIKE gcg_file.gcg03,   #           (舊值)
    g_gcg04_t       LIKE gcg_file.gcg04,   #           (舊值)
    g_gcg05_t       LIKE gcg_file.gcg05,   #           (舊值)
    g_gcg           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        gcg06       LIKE gcg_file.gcg06,   # 程序編號
       #zz02        LIKE zz_file.zz02,     # 程序名稱 #TQC-740155
        gaz03       LIKE gaz_file.gaz03,   # 程序名稱 #TQC-740155
        gcg08       LIKE gcg_file.gcg08,   # REP關聯報表ID         #FUN-740207
        gcg07       LIKE gcg_file.gcg07,   # REP關聯報表名稱
        gcg09       LIKE gcg_file.gcg09,   # BUTTON關聯報表名稱
        gcg10       LIKE gcg_file.gcg10,   # BUTTON關聯報表ID
        gcg11       LIKE gcg_file.gcg11    # REP關聯報表類型
                    END RECORD,
    g_gcg_t         RECORD                 #程式變數 (舊值)
        gcg06       LIKE gcg_file.gcg06,   # 程序編號
       #zz02        LIKE zz_file.zz02,     # 程序名稱 #TQC-740155
        gaz03       LIKE gaz_file.gaz03,   # 程序名稱 #TQC-740155
        gcg08       LIKE gcg_file.gcg08,   # REP關聯報表ID        #FUN-740207 
        gcg07       LIKE gcg_file.gcg07,   # REP關聯報表名稱
        gcg09       LIKE gcg_file.gcg09,   # BUTTON關聯報表名稱
        gcg10       LIKE gcg_file.gcg10,   # BUTTON關聯報表ID
        gcg11       LIKE gcg_file.gcg11    # REP關聯報表類型
                    END RECORD,
    g_wc                LIKE type_file.chr1000,           #FUN-680135
    g_wc2               LIKE type_file.chr1000,           #FUN-680135
    g_gch               LIKE type_file.chr1000,           #FUN-680135
    g_rec_b             LIKE type_file.num5,              #單身筆數  #FUN-680135 
    l_ac                LIKE type_file.num5               #目前處理的ARRAY CNT #FUN-680135
DEFINE   g_forupd_sql   STRING     #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt          LIKE type_file.num10              #FUN-680135
DEFINE   g_i            LIKE type_file.num5   #count/index for any purpose #FUN-680135
DEFINE   g_msg          LIKE type_file.chr1000            #FUN-680135 VARCHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10              #FUN-680135
DEFINE   g_row_count    LIKE type_file.num10              #FUN-680135 
DEFINE   g_jump         LIKE type_file.num10              #FUN-680135
DEFINE   mi_no_ask       LIKE type_file.num5          #FUN-6A0080    #FUN-680135
DEFINE   g_argv1        LIKE gcg_file.gcg01,
         g_argv2        LIKE gcg_file.gcg02,
         g_argv3        LIKE gcg_file.gcg03,
         g_argv4        LIKE gcg_file.gcg04,
         g_argv5        LIKE gcg_file.gcg05,
         g_argv6        LIKE gci_file.gci07   #FUN-840065
 
#主程式開始
MAIN
#  DEFINE l_time       VARCHAR(8)                #計算被使用時間 #No.FUN-6A0096
   DEFINE p_row,p_col  LIKE type_file.num5                    #FUN-680135
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)               # 
   LET g_argv2 = ARG_VAL(2)               # 
   LET g_argv3 = ARG_VAL(3)               # 
   LET g_argv4 = ARG_VAL(4)               # 
   LET g_argv5 = ARG_VAL(5)               # 
   LET g_argv6 = ARG_VAL(6)               #FUN-840065
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
   #No.FUN-6A0096
   #CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
   #    RETURNING l_time
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
       RETURNING g_time
   #END No.FUN-6A0096
   LET g_gcg01 = NULL                     #清除鍵值
   LET g_gcg02 = NULL                     #清除鍵值
   LET g_gcg03 = NULL                     #清除鍵值
   LET g_gcg04 = NULL                     #清除鍵值
   LET g_gcg05 = NULL                     #清除鍵值
   LET g_gcg01_t = NULL
   LET g_gcg02_t = NULL
   LET g_gcg03_t = NULL
   LET g_gcg04_t = NULL
   LET g_gcg05_t = NULL
 
   LET p_row = 5 LET p_col = 25
   OPEN WINDOW p_zbo_w AT p_row,p_col WITH FORM "azz/42f/p_zbo"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
       
   IF NOT cl_null(g_argv1) THEN
      CALL p_zbo_cs()
      CALL p_zbo_show()
   END IF
 
   CALL p_zbo_menu()
 
   CLOSE WINDOW p_zbo_w                 #結束畫面
   #No.FUN-6A0096
   #CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
   #  RETURNING l_time
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
     RETURNING g_time
   #END No.FUN-6A0096
END MAIN
 
FUNCTION p_zbo_cs()
 
   CLEAR FORM                             #清除畫面
   LET g_gcg01=NULL
   LET g_gcg02=NULL
   LET g_gcg03=NULL
   LET g_gcg04=NULL
   LET g_gcg05=NULL
   CALL g_gcg.clear()
   
   IF NOT cl_null(g_argv1)  
   THEN
      CALL cl_set_comp_visible("g01", FALSE)
      LET g_gcg01 = g_argv1
      LET g_gcg02 = g_argv2
      LET g_gcg03 = g_argv3
      LET g_gcg04 = g_argv4
      LET g_gcg05 = g_argv5
      LET g_wc = " gcg05 ='",g_argv5 CLIPPED,"'"      
     
     #LET g_wc = " gcg01 ='",g_argv1 CLIPPED,"' AND " CLIPPED,
     #           " gcg02 ='",g_argv2 CLIPPED,"' AND " CLIPPED,
     #           " gcg03 ='",g_argv3 CLIPPED,"' AND " CLIPPED,
     #           " gcg04 ='",g_argv4 CLIPPED,"' AND " CLIPPED,
     #           " gcg05 ='",g_argv5 CLIPPED,"'" CLIPPED 
   END IF
   CALL cl_set_head_visible("grid01,grid02,grid03","YES")       #No.FUN-6A0092
   
   IF g_action_choice = "query" 
   THEN
      CONSTRUCT g_wc2 ON gcg06,gcg08,gcg09,gcg10,gcg11    #FUN-740207
           FROM s_gcg[1].gcg06,s_gcg[1].gcg08,   #FUN-740207
                s_gcg[1].gcg09,s_gcg[1].gcg10,s_gcg[1].gcg11
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(gcg06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gaz"
                  LET g_qryparam.arg1 = g_lang
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gcg06
               #FUN-740207
               #WHEN INFIELD(gcg07)
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form ="q_gci"
               #   LET g_qryparam.state ="c"
               #   LET g_qryparam.multiret_index = 2
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO gcg07
               WHEN INFIELD(gcg08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gci"
                  LET g_qryparam.state ="c"
                  LET g_qryparam.multiret_index = 1
                  LET g_qryparam.arg1 = g_argv6 CLIPPED #FUN-840065
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gcg08
               #END FUN-740207
               WHEN INFIELD(gcg09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gci"
                  LET g_qryparam.state ="c"
                  LET g_qryparam.multiret_index = 2
                  LET g_qryparam.arg1 = g_argv6 CLIPPED #FUN-840065
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gcg09
            END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     END CONSTRUCT
     LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF INT_FLAG THEN RETURN END IF
     IF NOT cl_null(g_wc2) THEN 
        LET g_wc = g_wc CLIPPED ," AND ",g_wc2 CLIPPED
     END IF
   ELSE
     LET g_wc2 = "1=1"
   END IF
 
   #LET g_gch="SELECT UNIQUE gcg01,gcg02,gcg03,gcg04,gcg05,gcg06,",
   #          "              gcg07,gcg08,gcg09,gcg10,gcg11       ",
   #          "  FROM gcg_file ", # 組合出 SQL 指令
   #          " WHERE ", g_wc CLIPPED,
   #          " ORDER BY gcg01,gcg02,gcg03,gcg04,gcg05,gcg06"
   #DISPLAY g_gch
   #PREPARE p_zbo_prepare FROM g_gch      #預備一下
   #DECLARE p_zbo_bcs                     #宣告成可捲動的
   #    SCROLL CURSOR  WITH HOLD FOR p_zbo_prepare
 
   #LET g_gch = "SELECT COUNT(DISTINCT gcg06) FROM gcg_file ",
   #            " WHERE ", g_wc CLIPPED,
   #            " ORDER BY 1" 
   #PREPARE p_zbo_precount FROM g_gch
   #DECLARE p_zbo_count CURSOR FOR p_zbo_precount
 
END FUNCTION
 
FUNCTION p_zbo_menu()
   WHILE TRUE
      CALL p_zbo_bp("G")
      CASE g_action_choice
 
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p_zbo_cs()
                CALL p_zbo_show()
            END IF
 
           WHEN "detail" 
            IF cl_chk_act_auth() THEN
                CALL p_zbo_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
           WHEN "exit"
            EXIT WHILE
 
           WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zbo_show()
 
   CALL p_zbo_b_fill(g_wc2)             #單身
 
END FUNCTION
 
FUNCTION p_zbo_b()
DEFINE
   l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT #FUN-680135
   l_n             LIKE type_file.num5,              #檢查重複用        #FUN-680135
   l_lock_sw       LIKE type_file.chr1,              #單身鎖住否        #FUN-680135
   p_cmd           LIKE type_file.chr1,              #處理狀態          #FUN-680135
   l_allow_insert  LIKE type_file.num5,              #可新增否          #FUN-680135
   l_allow_delete  LIKE type_file.num5               #可刪除否          #FUN-680135
DEFINE 
   l_gci01         LIKE gci_file.gci01,              #FUN-740207
   l_gci02         LIKE gci_file.gci02,              #FUN-740207
   l_gcg12         LIKE gcg_file.gcg12               #FUN-840065
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_gcg01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT gcg06,'',gcg08,gcg07,gcg09,gcg10,gcg11 ",  #FUN-740207
                      "  FROM gcg_file ",
                      "   WHERE gcg05 = ?     ",
                      "   AND gcg06=? AND gcg07=? AND gcg11=?    ",
                      "   FOR UPDATE "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

   DECLARE p_zbo_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   
   #FUN-840065 start
   IF g_argv6='Y' THEN
      LET l_gcg12="Y"
   ELSE
      LET l_gcg12="N"
   END IF
   #FUN-840065 end
 
   INPUT ARRAY g_gcg WITHOUT DEFAULTS FROM s_gcg.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET g_gcg_t.* = g_gcg[l_ac].*      #BACKUP
            LET p_cmd='u'
#           OPEN p_zbo_bcl USING g_gcg01,g_gcg02,g_gcg03,
#                                g_gcg04,g_gcg05,g_gcg_t.gcg06,
#                                g_gcg_t.gcg07,g_gcg_t.gcg11
            OPEN p_zbo_bcl USING g_gcg05,g_gcg_t.gcg06,
                                 g_gcg_t.gcg07,g_gcg_t.gcg11
            IF STATUS THEN
               CALL cl_err("OPEN p_zbo_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH p_zbo_bcl INTO g_gcg[l_ac].* 
               IF SQLCA.sqlcode THEN  #No.FUN-660081
                  CALL cl_err(g_gcg_t.gcg06,SQLCA.sqlcode,1)  #No.FUN-660081
                  LET l_lock_sw = "Y"
               END IF
              #SELECT zz02 INTO g_gcg[l_ac].zz02 FROM zz_file #TQC-740155
              # WHERE zz01 = g_gcg[l_ac].gcg06 #TQC-740155
               LET g_gcg[l_ac].gaz03=cl_get_progdesc(g_gcg[l_ac].gcg06,g_lang) #TQC-740155
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF         
         
         INSERT INTO gcg_file(gcg01,gcg02,gcg03,gcg04,
                              gcg05,gcg06,gcg07,gcg08,
                              gcg09,gcg10,gcg11,gcg12)
                       VALUES(g_gcg01,g_gcg02,g_gcg03,g_gcg04,g_gcg05,
                              g_gcg[l_ac].gcg06,g_gcg[l_ac].gcg07,
                              g_gcg[l_ac].gcg08,g_gcg[l_ac].gcg09,
                              g_gcg[l_ac].gcg10,g_gcg[l_ac].gcg11,l_gcg12)
         IF SQLCA.sqlcode THEN  #No.FUN-660081
            #CALL cl_err(g_gcg[l_ac].gcg06,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gcg_file",g_gcg01,g_gcg[l_ac].gcg06,SQLCA.sqlcode,"","",1)  #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            COMMIT WORK
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gcg[l_ac].* TO NULL      #900423
         LET g_gcg_t.* = g_gcg[l_ac].*         #新輸入資料
         NEXT FIELD gcg06
 
      AFTER FIELD gcg06                        #check 序號是否重複
         IF NOT cl_null(g_gcg[l_ac].gcg06) THEN 
            #TQC-740155........begin
            LET g_cnt=0
           #SELECT zz02 INTO g_gcg[l_ac].zz02 FROM zz_file 
           # WHERE zz01 = g_gcg[l_ac].gcg06 
           #IF SQLCA.SQLCODE THEN
            SELECT COUNT(*) INTO g_cnt FROM zz_file
             WHERE zz01 = g_gcg[l_ac].gcg06 
            IF g_cnt=0 THEN
            #TQC-740155........end
               #CALL cl_err("Plant No.:",SQLCA.sqlcode,1)  #No.FUN-660081
               CALL cl_err3("sel","zz_file",g_gcg[l_ac].gcg06,"",SQLCA.sqlcode,"","Plant No.",1)  #No.FUN-660081
               NEXT FIELD gcg06 
            END IF
            LET g_gcg[l_ac].gaz03=cl_get_progdesc(g_gcg[l_ac].gcg06,g_lang) #TQC-740155
            DISPLAY BY NAME g_gcg[l_ac].gaz03 #TQC-740155
         END IF
 
      #FUN-740207
      #AFTER FIELD gcg07
      #   IF g_gcg[l_ac].gcg07 != g_gcg_t.gcg07 OR g_gcg_t.gcg07 IS NULL THEN 
      #      SELECT COUNT(*) INTO l_n FROM gcg_file 
      #      WHERE gcg05 = g_gcg05 AND gcg06 = g_gcg[l_ac].gcg06
      #        AND gcg07 = g_gcg[l_ac].gcg07
      #      #WHERE gcg01 = g_gcg01 AND gcg02 = g_gcg02
      #      #  AND gcg03 = g_gcg03 AND gcg04 = g_gcg04
      #      #  AND gcg05 = g_gcg05 AND gcg06 = g_gcg[l_ac].gcg06
      #      #  AND gcg07 = g_gcg[l_ac].gcg07
      #      IF l_n > 0 THEN 
      #         CALL cl_err3('sel','gcg_file',g_gcg[l_ac].gcg06,g_gcg[l_ac].gcg07,'-269','','',0)
      #         LET g_gcg[l_ac].gcg07 = g_gcg_t.gcg07
      #         NEXT FIELD gcg07
      #      END IF
      #   END IF
          
      AFTER FIELD gcg08
         IF g_gcg[l_ac].gcg08 != g_gcg_t.gcg08 OR g_gcg_t.gcg08 IS NULL THEN 
            SELECT COUNT(*) INTO l_n FROM gcg_file 
            WHERE gcg05 = g_gcg05 AND gcg06 = g_gcg[l_ac].gcg06
              AND gcg08 = g_gcg[l_ac].gcg08
            IF l_n > 0 THEN 
               CALL cl_err3('sel','gcg_file',g_gcg[l_ac].gcg06,g_gcg[l_ac].gcg08,'-269','','',0)
               LET g_gcg[l_ac].gcg08 = g_gcg_t.gcg08
               NEXT FIELD gcg08
            END IF
            SELECT COUNT(*) INTO g_cnt FROM zz_file
             WHERE zz01 = g_gcg[l_ac].gcg08 
            IF g_cnt=0 THEN
               CALL cl_err3("sel","zz_file",g_gcg[l_ac].gcg08,"",SQLCA.sqlcode,"","Report ID.",1)  #No.FUN-660081
               NEXT FIELD gcg08 
            END IF
            LET g_gcg[l_ac].gcg07=cl_get_progdesc(g_gcg[l_ac].gcg08,g_lang) #TQC-740155
            LET l_gci02 = g_gcg[l_ac].gcg08[6,FGL_WIDTH(g_gcg[l_ac].gcg08)]
            LET l_gci01 = g_gcg[l_ac].gcg08[3,5]
            SELECT gci01 INTO g_gcg[l_ac].gcg11 FROM gci_file 
             WHERE gci02 = l_gci02 AND gci01[1,3] = l_gci01
            DISPLAY g_gcg[l_ac].gcg07 TO gcg07
            DISPLAY g_gcg[l_ac].gcg08 TO gcg08
            DISPLAY g_gcg[l_ac].gcg11 TO gcg11
         END IF
      #FUN-740207
 
      BEFORE DELETE
         IF g_gcg_t.gcg06 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gcg_file
            WHERE gcg05 = g_gcg05 AND gcg06 = g_gcg_t.gcg06
              AND gcg07 = g_gcg_t.gcg07
              AND gcg11 = g_gcg_t.gcg11
            #WHERE gcg01 = g_gcg01 AND gcg02 = g_gcg02
            #  AND gcg03 = g_gcg03 AND gcg04 = g_gcg04
            #  AND gcg05 = g_gcg05 AND gcg06 = g_gcg_t.gcg06
            #  AND gcg07 = g_gcg_t.gcg07
            #  AND gcg11 = g_gcg_t.gcg11
            IF SQLCA.sqlcode THEN  #No.FUN-660081
               #CALL cl_err(g_gcg_t.gcg06,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gcg_file",g_gcg01,g_gcg_t.gcg06,SQLCA.sqlcode,"","Plant No.",1)  #No.FUN-660081
               ROLLBACK WORK 
               CANCEL DELETE 
            END IF
            MESSAGE 'DELETE O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gcg[l_ac].* = g_gcg_t.*
            CLOSE p_zbo_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gcg[l_ac].gcg06,-266,1)
            LET g_gcg[l_ac].* = g_gcg_t.*
         ELSE
            UPDATE gcg_file SET gcg06 = g_gcg[l_ac].gcg06,
                                gcg07 = g_gcg[l_ac].gcg07,
                                gcg08 = g_gcg[l_ac].gcg08,
                                gcg09 = g_gcg[l_ac].gcg09,
                                gcg10 = g_gcg[l_ac].gcg10, 
                                gcg11 = g_gcg[l_ac].gcg11,
                                gcg12 = l_gcg12 
            WHERE gcg05 = g_gcg05 AND gcg06 = g_gcg_t.gcg06
              AND gcg08 = g_gcg_t.gcg08 AND gcg11 = g_gcg_t.gcg11 #FUN-740207
                   
            #WHERE gcg01 = g_gcg01 AND gcg02 = g_gcg02
            #  AND gcg03 = g_gcg03 AND gcg04 = g_gcg04
            #  AND gcg05 = g_gcg05 AND gcg06 = g_gcg_t.gcg06
            #  AND gcg07 = g_gcg_t.gcg07 AND gcg11 = g_gcg_t.gcg11
            IF SQLCA.sqlcode THEN  #No.FUN-660081
               #CALL cl_err(g_gcg[l_ac].gcg06,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gcg_file",g_gcg01,g_gcg_t.gcg06,SQLCA.sqlcode,"","Plant No.",1)  #No.FUN-660081
               LET g_gcg[l_ac].* = g_gcg_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_gcg[l_ac].* = g_gcg_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_gcg.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end-- 
            END IF
            CLOSE p_zbo_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE p_zbo_bcl
         COMMIT WORK
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01,grid02,grid03","AUTO")           
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gcg06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gaz"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1 = g_gcg[l_ac].gcg06
               CALL cl_create_qry() RETURNING g_gcg[l_ac].gcg06
               DISPLAY g_gcg[l_ac].gcg06 TO gcg06
              #TQC-740155.............begin
              #SELECT zz02 INTO g_gcg[l_ac].zz02 FROM zz_file
              # WHERE zz01 = g_gcg[l_ac].gcg06 
              #DISPLAY g_gcg[l_ac].zz02 TO zz02
              LET g_gcg[l_ac].gaz03=cl_get_progdesc(g_gcg[l_ac].gcg06,g_lang)
              DISPLAY BY NAME g_gcg[l_ac].gaz03
              #TQC-740155.............end
            #FUN-740207
            #WHEN INFIELD(gcg07)
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form ="q_gci"
            #   LET g_qryparam.default1 = g_gcg[l_ac].gcg07
            #   CALL cl_create_qry() RETURNING g_gcg[l_ac].gcg11,g_gcg[l_ac].gcg07
            #   DISPLAY g_gcg[l_ac].gcg07 TO gcg07
            #   SELECT gci02 INTO g_gcg[l_ac].gcg08 FROM gci_file
            #    WHERE gci03 = g_gcg[l_ac].gcg07 AND gci01 = g_gcg[l_ac].gcg11
            WHEN INFIELD(gcg08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gci"
               LET g_qryparam.default1 = g_gcg[l_ac].gcg08
               LET g_qryparam.default2 = g_gcg[l_ac].gcg07
               LET g_qryparam.default3 = g_gcg[l_ac].gcg11
               LET g_qryparam.arg1 = g_argv6 CLIPPED #FUN-840065
               CALL cl_create_qry() RETURNING g_gcg[l_ac].gcg08,g_gcg[l_ac].gcg07,g_gcg[l_ac].gcg11
               DISPLAY g_gcg[l_ac].gcg07 TO gcg07
               DISPLAY g_gcg[l_ac].gcg08 TO gcg08
               DISPLAY g_gcg[l_ac].gcg11 TO gcg11
            #END FUN-740207
            WHEN INFIELD(gcg09)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gci"
               LET g_qryparam.default1 = g_gcg[l_ac].gcg09
               LET g_qryparam.arg1 = g_argv6 CLIPPED #FUN-840065
               CALL cl_create_qry() RETURNING g_gcg[l_ac].gcg11,g_gcg[l_ac].gcg07
               DISPLAY g_gcg[l_ac].gcg09 TO gcg09
               SELECT gci02 INTO g_gcg[l_ac].gcg10 FROM gci_file
                WHERE gci03 = g_gcg[l_ac].gcg09
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   CLOSE p_zbo_bcl
   COMMIT WORK
        
END FUNCTION
   
FUNCTION p_zbo_b_fill(p_wc)              #BODY FILL UP
 
   DEFINE p_wc  LIKE type_file.chr1000                  #FUN-680135 VARCHAR(200)    
   
   #FUN-840065 start
   IF g_argv6='Y' THEN
      LET p_wc = p_wc CLIPPED," AND gcg08 LIKE 'bo%' "
   ELSE
      LET p_wc = p_wc CLIPPED," AND gcg08 LIKE 'bi%' "
   END IF
   #FUN-840065 end
     
   LET g_gch = "SELECT gcg06,'',gcg08,gcg07,gcg09,gcg10,gcg11 ", #TQC-740155  ##FUN-740207
               "  FROM gcg_file ",  #TQC-740155
               " WHERE ",  #TQC-740155
#              "   AND gcg01 = '",g_gcg01 CLIPPED,"' ",
#              "   AND gcg02 = '",g_gcg02 CLIPPED,"' ",
#              "   AND gcg03 = '",g_gcg03 CLIPPED,"' ",
#              "   AND gcg04 = '",g_gcg04 CLIPPED,"' ",
               "   gcg05 = '",g_gcg05 CLIPPED,"' ", #TQC-740155               
               "   AND ",p_wc CLIPPED, " ORDER BY 1"
   PREPARE p_zbo_prepare2 FROM g_gch      #預備一下
   DECLARE gcg_cs CURSOR FOR p_zbo_prepare2
      
   CALL g_gcg.clear() 
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH gcg_cs INTO g_gcg[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN  #No.FUN-660081
         CALL cl_err('foreach:',SQLCA.sqlcode,1)  #No.FUN-660081
         EXIT FOREACH
      END IF
      LET g_gcg[g_cnt].gaz03=cl_get_progdesc(g_gcg[g_cnt].gcg06,g_lang) #TQC-740155
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gcg.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_zbo_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1                    #FUN-680135
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_gcg TO s_gcg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
 
 
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
           EXIT DISPLAY
 
        ON ACTION exit
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01,grid02,grid03","AUTO")           
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
