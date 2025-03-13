# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abxp113.4gl
# Descriptions...: 批次更新損耗數
# Date & Author..: 06/11/03 By kim
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    l_ac          LIKE type_file.num5,               
    g_wc          STRING, 
    tm            RECORD 
                  bnd02       LIKE bnd_file.bnd02,
                  bnd03       LIKE bnd_file.bnd03,
                  head        LIKE ima_file.ima1916, 
                  body        LIKE ima_file.ima1916, 
                  bne11       LIKE bne_file.bne11
                  END RECORD,
    g_bne2        DYNAMIC ARRAY OF RECORD 
                  bne02         LIKE bne_file.bne02,
                  bne10         LIKE bne_file.bne10,
                  ima1916_1   LIKE ima_file.ima1916,
                  ima1916_2   LIKE ima_file.ima1916
                  END RECORD, 
    g_bne         DYNAMIC ARRAY OF RECORD
                  choice    LIKE type_file.chr1,                #選擇
                  bnd01_b   LIKE bnd_file.bnd01,       #主件料號
                  ima02_01  LIKE ima_file.ima02,       #品名
                  ima021_01 LIKE ima_file.ima021,      #規格
                  bnd02_b   LIKE bnd_file.bnd02,       #生效日期
                  bnd03_b   LIKE bnd_file.bnd03,       #失效日期
                  bne03     LIKE bne_file.bne03,       #項次
                  bne05_b   LIKE bne_file.bne05,       #元件料號
                  ima02_02  LIKE ima_file.ima02,       #品名 
                  ima021_02 LIKE ima_file.ima021,      #規格
                  bne11_b   LIKE bne_file.bne11,       #原耗損數 
                  new       LIKE bne_file.bne11        #新耗損數
                  END RECORD,
    g_rec_b       LIKE type_file.num5,  #單身筆數
    l_flag        LIKE type_file.chr1,
    g_sql         STRING
 
DEFINE   g_cnt           LIKE type_file.num10   
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW abxp113_w AT p_row,p_col WITH FORM "abx/42f/abxp113" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('z')
   WHILE TRUE
      CALL p113_tm()                      #接受選擇
      CALL p113_p1()
      IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE END IF #使用者中斷
      IF cl_sure(0,0) THEN 
          CALL p113_update() 
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
          ELSE 
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             EXIT WHILE
          END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p113_w
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
      RETURNING g_time
END MAIN
 
FUNCTION p113_tm()
   DEFINE   l_n     LIKE type_file.num5                  #screen array no
 
   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM
   CALL g_bne.clear()
   CALL g_bne2.clear()
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   CONSTRUCT BY NAME g_wc ON bnd01,bne05 
    
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(bnd01)
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.state = "c"
            #  LET g_qryparam.form = "q_ima"
            #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End-- 
              DISPLAY g_qryparam.multiret TO bnd01
              NEXT FIELD bnd01
           WHEN INFIELD(bne05)
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.state = "c"
            #  LET g_qryparam.form = "q_ima"
            #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
              DISPLAY g_qryparam.multiret TO bne05
              NEXT FIELD bne05
        END CASE 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about   
         CALL cl_about()
 
      ON ACTION help   
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont() 
 
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW p113_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
 
   LET tm.bnd02 = g_today
   LET tm.bnd03 = g_today
   LET tm.bne11 = 0
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INPUT BY NAME tm.bnd02,tm.bnd03,tm.head,
                 tm.body,tm.bne11  WITHOUT DEFAULTS 
 
      AFTER FIELD bnd02 
         IF NOT cl_null(tm.bnd02) THEN
            IF NOT cl_null(tm.bnd03) THEN
               IF tm.bnd02 > tm.bnd03 THEN
                  CALL cl_err('','agl-031',0)
                  NEXT FIELD bnd02
               END IF
            END IF
         END IF
 
      AFTER FIELD bnd03 
         IF NOT cl_null(tm.bnd03) THEN
            IF NOT cl_null(tm.bnd02) THEN
               IF tm.bnd02 > tm.bnd03 THEN
                  CALL cl_err('','agl-031',0)
                  NEXT FIELD bnd02
               END IF
            END IF
         END IF
 
      AFTER FIELD head        #主件群組代碼 
         IF NOT cl_null(tm.head) THEN
            SELECT count(*) INTO g_cnt FROM bxe_file
               WHERE bxe01 = tm.head AND bxeacti = 'Y'
            IF g_cnt = 0 THEN
               CALL cl_err(tm.head,'abx-077',0)
               NEXT FIELD head
            END IF
         END IF
 
      AFTER FIELD body        #元件群組代碼
         IF NOT cl_null(tm.body) THEN
            SELECT count(*) INTO g_cnt FROM bxe_file
               WHERE bxe01 = tm.body AND bxeacti = 'Y'
            IF g_cnt = 0 THEN
               CALL cl_err(tm.body,'abx-077',0)
               NEXT FIELD body
            END IF
         END IF
 
      AFTER FIELD bne11            #損耗數
         IF NOT cl_null(tm.bne11) THEN
            IF tm.bne11 < 0 THEN
               CALL cl_err('','aim-391',0)
               NEXT FIELD bne11
            END IF
         END IF   
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(head)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_bxe01"
             LET g_qryparam.default1 = tm.head
             CALL cl_create_qry() RETURNING tm.head
             DISPLAY BY NAME tm.head 
             NEXT FIELD head 
           WHEN INFIELD(body)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_bxe01"
             LET g_qryparam.default1 = tm.body
             CALL cl_create_qry() RETURNING tm.body
             DISPLAY BY NAME tm.body 
             NEXT FIELD body 
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about   
         CALL cl_about()
 
      ON ACTION help   
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()  
 
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p113_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
 
END FUNCTION 
 
FUNCTION p113_p1()
   DEFINE l_exit LIKE type_file.chr1
 
   LET g_sql = "SELECT ' ',bnd01,' ',' ',bnd02,bnd03,bne03,bne05,",
               "       ' ',' ',bne11,' ',bne02,bne10,' ' ",
               "  FROM bnd_file,bne_file ",
               " WHERE bnd01 = bne01 AND bnd02 = bne02 ",
               "   AND bnd02 <= '",tm.bnd03 CLIPPED,"'",
               "   AND (bnd03 > '",tm.bnd02 CLIPPED,"' OR bnd03 IS NULL)",
               "   AND ",g_wc CLIPPED 
 
   PREPARE p113_prepare FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('PREPARE:',SQLCA.SQLCODE,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF   
 
   DECLARE p113_curs CURSOR FOR p113_prepare
 
   CALL g_bne.clear()
   CALL g_bne2.clear()
   LET g_cnt = 1
   FOREACH p113_curs INTO g_bne[g_cnt].*,g_bne2[g_cnt].*
      IF SQLCA.sqlcode THEN                                  #有問題
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      SELECT ima02,ima021,ima1916 
         INTO g_bne[g_cnt].ima02_01,g_bne[g_cnt].ima021_01,g_bne2[g_cnt].ima1916_1
         FROM ima_file WHERE ima01 = g_bne[g_cnt].bnd01_b 
      #如有輸入主件群組代碼則須符合
      IF NOT cl_null(tm.head) THEN
         IF g_bne2[g_cnt].ima1916_1 != tm.head THEN
            CONTINUE FOREACH
         END IF 
      END IF
      SELECT ima02,ima021,ima1916 
         INTO g_bne[g_cnt].ima02_02,g_bne[g_cnt].ima021_02,g_bne2[g_cnt].ima1916_2
         FROM ima_file WHERE ima01 = g_bne[g_cnt].bne05_b 
      #如有輸入元件群組代碼則須符合
      IF NOT cl_null(tm.body) THEN
         IF g_bne2[g_cnt].ima1916_2 != tm.body THEN
            CONTINUE FOREACH
         END IF 
      END IF
       
      LET g_bne[g_cnt].choice = 'Y'       
      LET g_bne[g_cnt].new = tm.bne11
 
      LET g_cnt = g_cnt + 1                           #累加筆數
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_bne.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1                               #正確的總筆數
   #筆數為零則跳出訊息並RETURN
   IF g_cnt = 0 THEN 
      CALL cl_err('','agl-118',1) 
      LET INT_FLAG = 1 
      RETURN
   END IF
   CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
   DISPLAY g_cnt TO FORMONLY.cn3                       #顯示總筆數
   WHILE TRUE 
     LET l_exit = 'y'
     INPUT ARRAY g_bne WITHOUT DEFAULTS FROM s_bne.*  #顯示並進行選擇
       ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
 
        AFTER FIELD choice
           IF g_bne[l_ac].choice NOT MATCHES '[YN]' THEN
              NEXT FIELD choice
           END IF 
 
        AFTER FIELD new
           IF g_bne[l_ac].new < 0 THEN
              CALL cl_err(g_bne[l_ac].new,'aim-391',0)
              NEXT FIELD new
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about     
           CALL cl_about()  
 
        ON ACTION help         
           CALL cl_show_help()
 
        ON ACTION controls                       #No.FUN-6B0033                                                                       
           CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
     
     END INPUT
     IF INT_FLAG THEN RETURN END IF   #使用者中斷
     IF l_exit = 'y' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
FUNCTION p113_update()
   DEFINE  l_i       LIKE type_file.num5
 
   LET g_success = 'Y'
   BEGIN WORK
      FOR l_i = 1 TO g_cnt
          IF g_bne[l_i].choice = 'N' THEN
             CONTINUE FOR
          END IF
          UPDATE bne_file SET bne11 = g_bne[l_i].new,
                              bne08 = g_bne2[l_i].bne10 + g_bne[l_i].new
                        WHERE bne01 = g_bne[l_i].bnd01_b
                          AND bne02 = g_bne2[l_i].bne02
                          AND bne03 = g_bne[l_i].bne03
                          AND bne05 = g_bne[l_i].bne05_b
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('upd bne_file',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             EXIT FOR
          END IF
      END FOR 
END FUNCTION
