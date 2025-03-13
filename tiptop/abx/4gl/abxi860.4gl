# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: abxi860.4gl
# Descriptions...: 保稅單別維護作業
# Date & Author..: 95/07/14 By Roger
# modify by nick 97/08/05 bxy04增加一種單據性質:收貨單(4)
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-530025 05/03/17 By kim 報表轉XML功能
# Modify.........: No.FUN-560150 05/06/21 By ice 輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570109 05/07/13 By day   修正建檔程式key值是否可更改
# Modify.........: No.MOD-580323 05/09/02 By jackie 將程序中寫死為中文的錯誤
# Modify.........: No.TQC-5C0042 05/12/12 By Nicola 開窗會把原本的資料清空，新增原因說明欄位
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/10/30 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-820002 07/12/18 By lala   報表轉為使用p_query
# Modify.........: No.MOD-840232 08/04/20 By Carol bxy01 add check smy_file的檢查
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30059 10/03/19 By rainy bxy_file 改為bna_file，且同步doc_file
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-A30059 begin
#DEFINE g_bxy        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
#                       bxy01       LIKE bxy_file.bxy01,
#                       bxy02       LIKE bxy_file.bxy02,
#                       bxy04       LIKE bxy_file.bxy04,
#                       bxy05       LIKE bxy_file.bxy05,
#                       bxr02       LIKE bxr_file.bxr02,     #No.TQC-5C0042
#                       bxy06   LIKE bxy_file.bxy06, #FUN-6A0007 
#                       bxy07   LIKE bxy_file.bxy07  #FUN-6A0007
#                    END RECORD,
#       g_bxy_t      RECORD                 #程式變數 (舊值)
#                       bxy01       LIKE bxy_file.bxy01,
#                       bxy02       LIKE bxy_file.bxy02,
#                       bxy04       LIKE bxy_file.bxy04,
#                       bxy05       LIKE bxy_file.bxy05,
#                       bxr02       LIKE bxr_file.bxr02,     #No.TQC-5C0042
#                       bxy06   LIKE bxy_file.bxy06, #FUN-6A0007 
#                       bxy07   LIKE bxy_file.bxy07  #FUN-6A0007
#                    END RECORD,
DEFINE g_bna        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                       bna01       LIKE bna_file.bna01,
                       bna02       LIKE bna_file.bna02,
                       bna05       LIKE bna_file.bna05,
                       bna08       LIKE bna_file.bna08,
                       bxr02       LIKE bxr_file.bxr02,     #No.TQC-5C0042
                       bna03       LIKE bna_file.bna03
                    END RECORD,
       g_bna_t      RECORD                 #程式變數 (舊值)
                       bna01       LIKE bna_file.bna01,
                       bna02       LIKE bna_file.bna02,
                       bna05       LIKE bna_file.bna05,
                       bna08       LIKE bna_file.bna08,
                       bxr02       LIKE bxr_file.bxr02,     #No.TQC-5C0042
                       bna03       LIKE bna_file.bna03
                    END RECORD,
#FUN-A30059 end
       g_wc,g_wc2,g_sql  STRING,  #No.FUN-580092 HCN       
       g_rec_b      LIKE type_file.num5,                #單身筆數        #No.FUN-680062  SMALLINT
       l_ac         LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680062 SMALLINT
DEFINE g_before_input_done    LIKE type_file.num5     #No.FUN-570109        #No.FUN-680062 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE g_cnt        LIKE type_file.num10              #No.FUN-680062 INTEGER
 
MAIN
#     DEFINE l_time LIKE type_file.chr8            #No.FUN-6A0062
DEFINE p_row,p_col   LIKE type_file.num5               #No.FUN-680062   SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
         RETURNING g_time    #No.FUN-6A0062
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW i860_w AT p_row,p_col WITH FORM "abx/42f/abxi860"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
 
   CALL i860_b_fill(g_wc2)
 
   CALL i860_menu()
 
   CLOSE WINDOW i860_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
         RETURNING g_time    #No.FUN-6A0062
 
END MAIN
 
FUNCTION i860_menu()
DEFINE l_cmd  LIKE type_file.chr1000         #No.FUN-820002
   WHILE TRUE
      CALL i860_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i860_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i860_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
         IF cl_chk_act_auth()                                                   
               THEN CALL i860_out()                                            
         END IF                                                                 
#        WHEN "help"
#           CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bna),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i860_q()
 
   CALL i860_b_askkey()
 
END FUNCTION
 
FUNCTION i860_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680062 SMALLINT
       l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680062 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否              #No.FUN-680062 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態                #No.FUN-680062 VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,                                          #No.FUN-680062 VARCHAR(1)        
       l_allow_delete  LIKE type_file.chr1,                                          #No.FUN-680062 VARCHAR(1)   
       l_errmsg        STRING
 DEFINE l_i            LIKE type_file.num5     #No.FUN-560150                        #No.FUN-680062 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
 #FUN-A30059 begin
   #LET g_forupd_sql = "SELECT bxy01,bxy02,bxy04,bxy05,'',",   #No.TQC-5C0042
   #                   "       bxy06,bxy07 ",         #FUN-6A0007 
   #                   "  FROM bxy_file WHERE bxy01= ? FOR UPDATE "
   LET g_forupd_sql = "SELECT bna01,bna02,bna05,bna08,'',",   #No.TQC-5C0042
                      "       bna03 ",      
                      "  FROM bna_file WHERE bna01= ? FOR UPDATE "
 #FUN-A30059 end
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i860_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   #INPUT ARRAY g_bxy WITHOUT DEFAULTS FROM s_bxy.*    #FUN-A30059
   INPUT ARRAY g_bna WITHOUT DEFAULTS FROM s_bna.*     #FUN-A30059
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,
                    DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
         END IF
         #NO.FUN-560150 --start--
         #CALL cl_set_doctype_format("bxy01")  #FUN-A30059
         CALL cl_set_doctype_format("bna01")   #FUN-A30059
         #NO.FUN-560150 --end--
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            #LET g_bxy_t.* = g_bxy[l_ac].*  #BACKUP   #FUN-A30059
            LET g_bna_t.* = g_bna[l_ac].*  #BACKUP    #FUN-A30059
           #No.FUN-570109 --start--
            LET g_before_input_done = FALSE
            CALL i860_set_entry(p_cmd)
            CALL i860_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
           #No.FUN-570109 --end--
            BEGIN WORK
            #OPEN i860_bcl USING g_bna_t.bna01  #FUN-A30059
            OPEN i860_bcl USING g_bna_t.bna01   #FUN-A30059
            IF STATUS THEN
               CALL cl_err("OPEN i860_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               #FETCH i860_bcl INTO g_bxy[l_ac].*   #FUN-A30059
               FETCH i860_bcl INTO g_bna[l_ac].*    #FUN-A30059
               IF SQLCA.sqlcode THEN
                  #CALL cl_err(g_bxy_t.bxy01,SQLCA.sqlcode,1)  #FUN-A30059
                  CALL cl_err(g_bna_t.bna01,SQLCA.sqlcode,1)   #FUN-A30059
                  LET l_lock_sw = "Y"
               #-----No.TQC-5C0042-----
               ELSE
                  #SELECT bxr02 INTO g_bxy[l_ac].bxr02   #FUN-A30059
                  SELECT bxr02 INTO g_bna[l_ac].bxr02    #FUN-A30059
                    FROM bxr_file
                   WHERE bxr01 = g_bna[l_ac].bna08     #g_bxy[l_ac].bxy05  #FUN-A30059
               #-----No.TQC-5C0042 END-----
               END IF
               #FUN-6A0007 -->
               #CALL i860_set_ta_entry(g_bxy[l_ac].bxy01, g_bxy[l_ac].bxy06)    #FUN-A30059
               CALL i860_set_ta_entry(g_bna[l_ac].bna01, g_bna[l_ac].bna03)     #FUN-A30059
                    RETURNING g_errno
               IF NOT cl_null(g_errno) THEN 
                  #CALL cl_set_comp_entry("bxy07",FALSE)   #FUN-A30059
                  CALL cl_set_comp_entry("bna03",FALSE)    #FUN-A30059
            END IF
               #FUN-6A0007 <--
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
        #No.FUN-570109 --start--
         LET g_before_input_done = FALSE
         CALL i860_set_entry(p_cmd)
         CALL i860_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
        #No.FUN-570109 --end--
       #FUN-A30059 beign
         #INITIALIZE g_bxy[l_ac].* TO NULL      #900423
         #LET g_bxy[l_ac].bxy06 = 'N'       #FUN-6A0007
         #LET g_bxy_t.* = g_bxy[l_ac].*         #新輸入資料
         #CALL cl_show_fld_cont()     #FUN-550037(smin)
         #NEXT FIELD bxy01
         INITIALIZE g_bna[l_ac].* TO NULL      #900423
         LET g_bna[l_ac].bna03 = 'N'       #FUN-6A0007
         LET g_bna_t.* = g_bna[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bna01
        #FUN-A30059 end
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
        #FUN-A30059 begin
         #INSERT INTO bxy_file(bxy01,bxy02,bxy03,bxy04,bxy05,
         #                     bxy06,bxy07)           #FUN-6A0007
         #              VALUES(g_bxy[l_ac].bxy01,g_bxy[l_ac].bxy02,'N',
         #                     g_bxy[l_ac].bxy04,g_bxy[l_ac].bxy05,
         #                     g_bxy[l_ac].bxy06,
         #                     g_bxy[l_ac].bxy07)
         INSERT INTO bna_file(bna01,bna02,bna07,bna05,bna08,
                              bna03)           #FUN-6A0007
                       VALUES(g_bna[l_ac].bna01,g_bna[l_ac].bna02,'N',
                              g_bna[l_ac].bna05,g_bna[l_ac].bna08,
                              g_bna[l_ac].bna03)
        #FUN-A30059 edn
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bxy[l_ac].bxy01,SQLCA.sqlcode,0)   #No.FUN-660052
            #CALL cl_err3("ins","bxy_file",g_bxy[l_ac].bxy01,"",SQLCA.sqlcode,"","",1)   #FUN-A30059
            CALL cl_err3("ins","bna_file",g_bna[l_ac].bna01,"",SQLCA.sqlcode,"","",1)    #FUN-A30059
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL s_access_doc('a',g_bna[l_ac].bna03,g_bna[l_ac].bna05,g_bna[l_ac].bna01,'ABX','Y')  #FUN-A30059 ad
         END IF
 
   #FUN-A30059 begin
#      AFTER FIELD bxy01                        #check 編號是否重複
#         IF NOT cl_null(g_bxy[l_ac].bxy01) THEN     #MOD-840232-modify
#            IF g_bxy[l_ac].bxy01 != g_bxy_t.bxy01 OR
#              (g_bxy[l_ac].bxy01 IS NOT NULL AND g_bxy_t.bxy01 IS NULL) THEN
#               SELECT count(*) INTO l_n FROM bxy_file
#                WHERE bxy01 = g_bxy[l_ac].bxy01
#               IF l_n > 0 THEN
#                  CALL cl_err('',-239,0)
#                  LET g_bxy[l_ac].bxy01 = g_bxy_t.bxy01
#                  NEXT FIELD bxy01
#               END IF
#               #NO.FUN-560150 --start--
#               FOR l_i = 1 TO g_doc_len
#                  IF cl_null(g_bxy[l_ac].bxy01[l_i,l_i]) THEN
#                     CALL cl_err('','sub-146',0)
#                     LET g_bxy[l_ac].bxy01 = g_bxy_t.bxy01
#                     NEXT FIELD bxy01
#                  END IF
#               END FOR
##MOD-840232-modify
#            END IF
#            #FUN-6A0007...............begin
#             SELECT smydesc INTO g_bxy[l_ac].bxy02 FROM smy_file
#              WHERE smyslip = g_bxy[l_ac].bxy01
#            #FUN-6A0007...............end
##MOD-840232-modify-end
#          ELSE 
#             LET g_bxy[l_ac].bxy02 = NULL
#          END IF
#          DISPLAY BY NAME g_bxy[l_ac].bxy02
#          CALL i860_set_no_entry(p_cmd)         #MOD-840232-add
      AFTER FIELD bna01                        #check 編號是否重複
         IF NOT cl_null(g_bna[l_ac].bna01) THEN     #MOD-840232-modify
            IF g_bna[l_ac].bna01 != g_bna_t.bna01 OR
              (g_bna[l_ac].bna01 IS NOT NULL AND g_bna_t.bna01 IS NULL) THEN
               SELECT count(*) INTO l_n FROM bna_file
                WHERE bna01 = g_bna[l_ac].bna01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_bna[l_ac].bna01 = g_bna_t.bna01
                  NEXT FIELD bna01
               END IF
               #NO.FUN-560150 --start--
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(g_bna[l_ac].bna01[l_i,l_i]) THEN
                     CALL cl_err('','sub-146',0)
                     LET g_bna[l_ac].bna01 = g_bna_t.bna01
                     NEXT FIELD bna01
                  END IF
               END FOR
#MOD-840232-modify
            END IF
            #FUN-6A0007...............begin
             SELECT smydesc INTO g_bna[l_ac].bna02 FROM smy_file
              WHERE smyslip = g_bna[l_ac].bna01
            #FUN-6A0007...............end
#MOD-840232-modify-end
          ELSE 
             LET g_bna[l_ac].bna02 = NULL
          END IF
          DISPLAY BY NAME g_bna[l_ac].bna02
          CALL i860_set_no_entry(p_cmd)         #MOD-840232-add
#FUN-A30059 modify end
 
#FUN-A30059 begin
      #BEFORE FIELD bxy04
      #   IF cl_null(g_bxy[l_ac].bxy04) THEN
      #      LET g_bxy[l_ac].bxy04 = '0'
      #      #------MOD-5A0095 START----------
      #      DISPLAY BY NAME g_bxy[l_ac].bxy04
      #      #------MOD-5A0095 END------------
      #   END IF
 
      #AFTER FIELD bxy04
      #   IF cl_null(g_bxy[l_ac].bxy04) THEN
      #      LET g_bxy[l_ac].bxy04='0'
      #      #------MOD-5A0095 START----------
      #      DISPLAY BY NAME g_bxy[l_ac].bxy04
      #      #------MOD-5A0095 END------------
 
      #      NEXT FIELD bxy04
      #   END IF
      #   IF g_bxy[l_ac].bxy04 NOT MATCHES '[01234]' THEN
      #      LET g_bxy[l_ac].bxy04='0'
      #      NEXT FIELD bxy04
      #   END IF
 
      #AFTER FIELD bxy05
      #   IF NOT cl_null(g_bxy[l_ac].bxy05) THEN
      #      #-----No.TQC-5C0042-----
      #     #SELECT * FROM bxr_file WHERE bxr01=g_bxy[l_ac].bxy05
      #      SELECT bxr02 INTO g_bxy[l_ac].bxr02
      #        FROM bxr_file
      #       WHERE bxr01 = g_bxy[l_ac].bxy05
      #      #-----No.TQC-5C0042 END-----
      #      IF STATUS <> 0 THEN
      #        #No.MOD-580323 --start--
      #         CALL cl_getmsg('abx-860',g_lang) RETURNING l_errmsg
      #         ERROR l_errmsg
      #        #No.MOD-580323 --end--
      #         LET g_bxy[l_ac].bxy05=' '
      #         LET g_bxy[l_ac].bxr02=' '   #No.TQC-5C0042
      #         NEXT FIELD bxy05
      #      END IF
      #      #--NO.MOD-5A0095 START---
      #      DISPLAY BY NAME g_bxy[l_ac].bxr02
      #      #--NO.MOD-5A0095 END-----
      #   END IF
      #   CALL i860_set_no_entry(p_cmd)         #MOD-840232-add
 
      BEFORE FIELD bna05
          CALL s_getgee(g_prog,g_lang,'bna05') #FUN-A30059 

      AFTER FIELD bna05
         IF cl_null(g_bna[l_ac].bna05) THEN
            LET g_bna[l_ac].bna05='0'
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_bna[l_ac].bna05
            #------MOD-5A0095 END------------
 
            NEXT FIELD bna05
         END IF
         SELECT COUNT(*) INTO l_n FROM gee_file
          WHERE gee01 = 'ABX' AND gee02 = g_bna[l_ac].bna05
            AND gee04 = 'abxi860'
         IF l_n = 0 THEN
            CALL cl_err(g_bna[l_ac].bna05,'mfg0015',1)
            NEXT FIELD bna05
         END IF
 
      AFTER FIELD bna08
         IF NOT cl_null(g_bna[l_ac].bna08) THEN
            #-----No.TQC-5C0042-----
           #SELECT * FROM bxr_file WHERE bxr01=g_bna[l_ac].bna08
            SELECT bxr02 INTO g_bna[l_ac].bxr02
              FROM bxr_file
             WHERE bxr01 = g_bna[l_ac].bna08
            #-----No.TQC-5C0042 END-----
            IF STATUS <> 0 THEN
              #No.MOD-580323 --start--
               CALL cl_getmsg('abx-860',g_lang) RETURNING l_errmsg
               ERROR l_errmsg
              #No.MOD-580323 --end--
               LET g_bna[l_ac].bna08=' '
               LET g_bna[l_ac].bxr02=' '   #No.TQC-5C0042
               NEXT FIELD bna08
            END IF
            #--NO.MOD-5A0095 START---
            DISPLAY BY NAME g_bna[l_ac].bxr02
            #--NO.MOD-5A0095 END-----
         END IF
         CALL i860_set_no_entry(p_cmd)         #MOD-840232-add
#FUN-A30059 end 
#MOD-840232-modify
#     #FUN-6A0007...............begin
#     BEFORE FIELD bxy06
#        CALL i860_set_ta_entry(g_bxy[l_ac].bxy01, g_bxy[l_ac].bxy06)
#             RETURNING g_errno
#        IF NOT cl_null(g_errno) THEN 
##          CALL cl_err(g_bxy[l_ac].bxy01,g_errno,1)   ##已存在asmi300
#           CALL cl_set_comp_entry("bxy07",FALSE)
#           CALL cl_set_comp_required("bxy06",FALSE) 
#           LET g_bxy[l_ac].bxy06 = 'N'
#           LET g_bxy[l_ac].bxy07 = NULL
#           DISPLAY BY NAME g_bxy[l_ac].bxy06,g_bxy[l_ac].bxy07
#           #NEXT FIELD bxy01  #FUN-6A0007 mark
#        ELSE
#           CALL cl_set_comp_entry("bxy07",TRUE)
#           CALL cl_set_comp_required("bxy06",TRUE) 
#        END IF
#MOD-840232-mark-end
 
#FUN-A30059 begin
      #AFTER FIELD bxy06
      #   IF g_bxy[l_ac].bxy06 = 'Y' THEN
      #      CALL cl_set_comp_entry("bxy07",TRUE)
      #      CALL cl_set_comp_required("bxy07",TRUE) 
      #      IF cl_null(g_bxy[l_ac].bxy07) THEN
      #         LET g_bxy[l_ac].bxy07 = '1'
      #      END IF
      #   ELSE
      #      CALL cl_set_comp_entry("bxy07",FALSE)
      #      CALL cl_set_comp_required("bxy07",FALSE) 
      #      LET g_bxy[l_ac].bxy07 = NULL
      #   END IF
      #   DISPLAY BY NAME g_bxy[l_ac].bxy06,g_bxy[l_ac].bxy07    #MOD-840232-add
 
      #AFTER FIELD bxy07
      #   IF g_bxy[l_ac].bxy06 = 'Y' THEN
      #      IF cl_null(g_bxy[l_ac].bxy07) THEN
      #         NEXT FIELD bxy07
      #      END IF
      #   END IF
      ##FUN-6A0007...............end
#FUN-A30059 end 

 
      BEFORE DELETE                            #是否取消單身
         #IF g_bxy_t.bxy01 IS NOT NULL THEN  #FUN-A30059
         IF g_bna_t.bna01 IS NOT NULL THEN   #FUN-A30059
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             #DELETE FROM bxy_file WHERE bxy01 = g_bxy_t.bxy01   #FUN-A30059
             DELETE FROM bna_file WHERE bna01 = g_bna_t.bna01    #FUN-A30059
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bxy_t.bxy01,SQLCA.sqlcode,0)   #No.FUN-660052
                #CALL cl_err3("del","bxy_file",g_bxy_t.bxy01,"",SQLCA.sqlcode,"","",1)  #FUN-A30059
                CALL cl_err3("del","bna_file",g_bna_t.bna01,"",SQLCA.sqlcode,"","",1)   #FUN-A30059
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             CALL s_access_doc('r','','',g_bna[l_ac].bna01,'ABX','Y')   #FUN-A30059 add
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #LET g_bxy[l_ac].* = g_bxy_t.*   #FUN-A30059
            LET g_bna[l_ac].* = g_bna_t.*    #FUN-A30059
            CLOSE i860_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
           #FUN-A30059 begin
            #CALL cl_err(g_bxy[l_ac].bxy01,-263,1)
            #LET g_bxy[l_ac].* = g_bxy_t.*
            CALL cl_err(g_bna[l_ac].bna01,-263,1)
            LET g_bna[l_ac].* = g_bna_t.*
           #FUN-A30059 end
         ELSE
           #FUN-A30059 begin
            #UPDATE bxy_file SET bxy01=g_bxy[l_ac].bxy01,
            #                    bxy02=g_bxy[l_ac].bxy02,
            #                    bxy03='N',
            #                    bxy04=g_bxy[l_ac].bxy04,
            #                    bxy05     = g_bxy[l_ac].bxy05,
            #                    bxy06 = g_bxy[l_ac].bxy06,
            #                    bxy07 = g_bxy[l_ac].bxy07
            # WHERE bxy01=g_bxy_t.bxy01
            UPDATE bna_file SET bna01=g_bna[l_ac].bna01,
                                bna02=g_bna[l_ac].bna02,
                                bna07='N',
                                bna05=g_bna[l_ac].bna05,
                                bna08     = g_bna[l_ac].bna08,
                                bna03 = g_bna[l_ac].bna03
             WHERE bna01=g_bna_t.bna01
            #FUN-A30059 end
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bxy[l_ac].bxy01,SQLCA.sqlcode,0)   #No.FUN-660052
             #FUN-A30059 begin
               #CALL cl_err3("upd","bxy_file",g_bxy_t.bxy01,"",SQLCA.sqlcode,"","",1)
               #LET g_bxy[l_ac].* = g_bxy_t.*
               CALL cl_err3("upd","bna_file",g_bna_t.bna01,"",SQLCA.sqlcode,"","",1)
               LET g_bna[l_ac].* = g_bna_t.*
             #FUN-A30059 end
            ELSE
               CALL s_access_doc('u',g_bna[l_ac].bna03,g_bna[l_ac].bna05,g_bna_t.bna01,'ABX','Y')  #FUN-A30059 add
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               #LET g_bxy[l_ac].* = g_bxy_t.*   #FUN-A30059
               LET g_bna[l_ac].* = g_bna_t.*    #FUN-A30059
            #FUN-D30034--add--begin--
            ELSE
               CALL g_bna.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i860_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE i860_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
        #FUN-A30059 begin
         #IF INFIELD(bxy01) AND l_ac > 1 THEN
         #   LET g_bxy[l_ac].* = g_bxy[l_ac-1].*
         #   NEXT FIELD bxy01
         #END IF
         IF INFIELD(bna01) AND l_ac > 1 THEN
            LET g_bna[l_ac].* = g_bna[l_ac-1].*
            NEXT FIELD bna01
         END IF
        #FUN-A30059 end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION controlp
         CASE
            #WHEN INFIELD(bxy05) #
            WHEN INFIELD(bna08) #FUN-A30059
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_bxr"
                #FUN-A30059 begin
                 #LET g_qryparam.default1 = g_bxy[l_ac].bxy05   #No.TQC-5C0042  
                 #CALL cl_create_qry() RETURNING g_bxy[l_ac].bxy05   
                 #DISPLAY BY NAME g_bxy[l_ac].bxy05        #No.MOD-490371
                 #NEXT FIELD bxy05  
                 LET g_qryparam.default1 = g_bna[l_ac].bna08   
                 CALL cl_create_qry() RETURNING g_bna[l_ac].bna08    
                 DISPLAY BY NAME g_bna[l_ac].bna08        
                 NEXT FIELD bna08   
                #FUN-A30059 end
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE i860_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i860_b_askkey()
 
   CLEAR FORM

   CALL s_getgee(g_prog,g_lang,'bna05') #FUN-A30059

 #FUN-A30059 begin
   #CALL g_bxy.clear()
 
   #CONSTRUCT g_wc2 ON bxy01,bxy02,bxy04,bxy05,bxy06,bxy07
   #     FROM s_bxy[1].bxy01,s_bxy[1].bxy02,s_bxy[1].bxy04,s_bxy[1].bxy05,
   #          s_bxy[1].bxy06,s_bxy[1].bxy07   #FUN-6A0007
   CALL g_bna.clear()
 
   CONSTRUCT g_wc2 ON bna01,bna02,bna05,bna08,bna03
        FROM s_bna[1].bna01,s_bna[1].bna02,s_bna[1].bna05,s_bna[1].bna08,
             s_bna[1].bna03
 #FUN-A30059 end 

              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
           # WHEN INFIELD(bxy05) #FUN-A30059
            WHEN INFIELD(bna08) #FUN-A30059
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_bxr"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
               #FUN-A30059 begin
                 #DISPLAY g_qryparam.multiret TO bxy05
                 #NEXT FIELD bxy05
                 DISPLAY g_qryparam.multiret TO bna08
                 NEXT FIELD bna08
               #FUN-A30059 end
            OTHERWISE EXIT CASE
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
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL i860_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i860_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   LIKE type_file.chr1000 #No.FUN-680062    VARCHAR(200)

   CALL s_getgee(g_prog,g_lang,'bna05') #FUN-A30059
 
  #FUN-A30059 begin
   #LET g_sql = "SELECT bxy01,bxy02,bxy04,bxy05,'',",   #No.TQC-5C0042
   #            "       bxy06,bxy07 ",          #FUN-6A0007
   #            " FROM bxy_file",
   #            " WHERE ", p_wc2 CLIPPED,                     #單身
   #            " ORDER BY bxy01"
   LET g_sql = "SELECT bna01,bna02,bna05,bna08,'',",   
               "       bna03 ",        
               " FROM bna_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               "   AND bna05 IN ( ",
               "  SELECT DISTINCT gee02 FROM gee_file WHERE gee01 = 'ABX' AND gee04 = 'abxi860') ",
               " ORDER BY bna01"
  #FUN-A30059 end
 
   PREPARE i860_pb FROM g_sql
   #DECLARE bxy_curs CURSOR FOR i860_pb   #FUN-A30059
   DECLARE bna_curs CURSOR FOR i860_pb    #FUN-A30059
 
   #CALL g_bxy.clear()   #FUN-A30059
   CALL g_bna.clear()    #FUN-A30059
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   #FOREACH bxy_curs INTO g_bxy[g_cnt].*   #單身 ARRAY 填充   #FUN-A30059
   FOREACH bna_curs INTO g_bna[g_cnt].*   #單身 ARRAY 填充    #FUN-A30059
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      #-----No.TQC-5C0042-----
      #SELECT bxr02 INTO g_bxy[g_cnt].bxr02  #FUN-A30059
      SELECT bxr02 INTO g_bna[g_cnt].bxr02   #FUN-A30059
        FROM bxr_file
       #WHERE bxr01 = g_bxy[g_cnt].bxy05   #FUN-A30059
       WHERE bxr01 = g_bna[g_cnt].bna08    #FUN-A30059
      #-----No.TQC-5C0042 END-----
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   #CALL g_bxy.deleteElement(g_cnt)  #FUN-A30059
   CALL g_bna.deleteElement(g_cnt)   #FUN-A30059
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i860_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_bxy TO s_bxy.* ATTRIBUTE(COUNT=g_rec_b)   #FUN-A30059
   DISPLAY ARRAY g_bna TO s_bna.* ATTRIBUTE(COUNT=g_rec_b)    #FUN-A30059
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
#     ON ACTION help
#        LET g_action_choice="help"
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CALL s_getgee(g_prog,g_lang,'bna05') #FUN-A30059 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
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
 
#No.FUN-820002--start--
FUNCTION i860_out()
DEFINE l_cmd  LIKE type_file.chr1000
#   DEFINE l_bxy       RECORD  LIKE bxy_file.*,
#          l_bxr02     LIKE bxr_file.bxr02,          #No.TQC-5C0042
#          l_bxy04_1   LIKE zaa_file.zaa08,          #No.FUN-680062    VARCHAR(30),              #No.TQC-5C0042             
#          l_i         LIKE type_file.num5,          #No.FUN-680062  SMALLINT
#          l_name      LIKE type_file.chr20,         #No.FUN-680062   VARCHAR(20)
#          l_za05      LIKE za_file.za05             #No.FUN-680062   VARCHAR(40) 
    IF cl_null(g_wc2) THEN                                                                                                          
       CALL cl_err("","9057",0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "abxi860" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)
#No.TQC-710076 -- begin --
#   IF cl_null(g_wc2) THEN
#      CALL cl_err("","9057",0)
#      RETURN
#   END IF
#No.TQC-710076 -- end --
  #IF g_wc2 IS NULL THEN
  # # CALL cl_err('',-400,0)
  #   CALL cl_err('','9057',0)
  #RETURN END IF
 
#   CALL cl_wait()
#   CALL cl_outnam('abxi860') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
  #LET g_x[1]='保稅單別明細列表'
  #LET g_x[2]='製表日期:'
  #LET g_x[3]='頁次:'
  #LET g_x[4]='(abxi860)'
  #LET g_x[6]='(接下頁)'
  #LET g_x[7]='(結  束)'
 
 
   # 組合出 SQL 指令
#   LET g_sql="SELECT * ",
#             "  FROM bxy_file ",
#             " WHERE ",g_wc2 CLIPPED
 
#   PREPARE i860_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i860_co CURSOR FOR i860_p1
 
#   START REPORT i860_rep TO l_name
 
#   FOREACH i860_co INTO l_bxy.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
 
      #-----No.TQC-5C0042-----
#      LET l_bxr02 = ''
#      LET l_bxy04_1 = ''
 
#      SELECT bxr02 INTO l_bxr02
#        FROM bxr_file
#       WHERE bxr01 = l_bxy.bxy05
 
#      CASE l_bxy.bxy04
#         WHEN "0"
#            LET l_bxy04_1 = l_bxy.bxy04,":",g_x[9]
#         WHEN "1"
#            LET l_bxy04_1 = l_bxy.bxy04,":",g_x[10]
#         WHEN "2"
#            LET l_bxy04_1 = l_bxy.bxy04,":",g_x[11]
#         WHEN "3"
#            LET l_bxy04_1 = l_bxy.bxy04,":",g_x[12]
#         WHEN "4"
#            LET l_bxy04_1 = l_bxy.bxy04,":",g_x[13]
#         OTHERWISE
#            LET l_bxy04_1 = l_bxy.bxy04
#      END CASE
      #-----No.TQC-5C0042 END-----
 
#      OUTPUT TO REPORT i860_rep(l_bxy.*,l_bxr02,l_bxy04_1)   #No.TQC-5C0042
#   END FOREACH
 
#   FINISH REPORT i860_rep
 
#   CLOSE i860_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
#REPORT i860_rep(sr,l_bxr02,l_bxy04_1)
#    DEFINE l_trailer_sw  LIKE type_file.chr1,                  #No.FUN-680062   VARCHAR(1)      
#          sr             RECORD LIKE bxy_file.*,                #程式變數 (舊值)
#          l_bxr02        LIKE bxr_file.bxr02,   #No.TQC-5C0042
#          l_bxy04_1      LIKE zaa_file.zaa08    #No.TQC-5C0042   #No.FUN-680062 VARCHAR(30) 
 
 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.bxy01,sr.bxy02
 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         LET g_pageno=g_pageno+1
#         LET pageno_total=PAGENO USING '<<<','/pageno'
#         PRINT g_head CLIPPED,pageno_total
#         PRINT g_dash #FUN-6A0007
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]   #No.TQC-5C0042
#         PRINT g_dash1
#         LET l_trailer_sw = 'y'
 
#      ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.bxy01,
#               COLUMN g_c[32],sr.bxy02,
#               COLUMN g_c[33],l_bxy04_1,   #No.TQC-5C0042
#               COLUMN g_c[34],sr.bxy05,
#               COLUMN g_c[35],l_bxr02   #No.TQC-5C0042
 
#      ON LAST ROW
#         PRINT g_dash
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#         LET l_trailer_sw = 'n'
 
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
 
#END REPORT
#No.FUN-820002--end-- 
 
#No.FUN-570109 --begin
FUNCTION i860_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     #FUN-A30059 begin
      #CALL cl_set_comp_entry("bxy01",TRUE)
      #CALL cl_set_comp_entry("bxy06,bxy07",TRUE)
      CALL cl_set_comp_entry("bna01",TRUE)
      CALL cl_set_comp_entry("bna03",TRUE)
     #FUN-A30059 end
   END IF
 
END FUNCTION
 
FUNCTION i860_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)    
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      #CALL cl_set_comp_entry("bxy01",FALSE)   #FUN-A30059
      CALL cl_set_comp_entry("bna01",FALSE)    #FUN-A30059
   END IF
#MOD-840232-add
   #IF INFIELD(bxy01) OR INFIELD(bxy06) THEN   #FUN-A30059
   IF INFIELD(bna01) OR INFIELD(bna03) THEN    #FUN-A30059
      LET g_errno = ''
      #CALL i860_set_ta_entry(g_bxy[l_ac].bxy01,g_bxy[l_ac].bxy06)   #FUN-A30059
      CALL i860_set_ta_entry(g_bna[l_ac].bna01,g_bna[l_ac].bna03)    #FUN-A30059
           RETURNING g_errno
      IF NOT cl_null(g_errno) THEN
      #FUN-A30059 begin
      #   LET g_bxy[l_ac].bxy06 = 'N'
      #   LET g_bxy[l_ac].bxy07 = NULL
      #   DISPLAY BY NAME g_bxy[l_ac].bxy06,g_bxy[l_ac].bxy07
      #   CALL cl_set_comp_entry("bxy06,bxy07",FALSE)
      #ELSE 
      #   CALL cl_set_comp_entry("bxy06,bxy07",TRUE)
         LET g_bna[l_ac].bna03 = 'N'
         DISPLAY BY NAME g_bna[l_ac].bna03
         CALL cl_set_comp_entry("bna03",FALSE)
      ELSE 
         CALL cl_set_comp_entry("bna03",TRUE)
      #FUN-A30059 end
      END IF
   END IF
 
END FUNCTION
#No.FUN-570109 --end
 
#FUN-6A0007 ##檢查單別是否存在 smy_file，存在時無法勾選bxy06
#FUNCTION i860_set_ta_entry(p_bxy01,p_bxy06)   #FUN-A30059
FUNCTION i860_set_ta_entry(p_bna01,p_bna03)    #FUN-A30059
   DEFINE l_cnt       LIKE type_file.num5
  #FUN-A30059 begin
   #DEFINE p_bxy01     LIKE bxy_file.bxy01,
   #       p_bxy06 LIKE bxy_file.bxy06
   DEFINE p_bna01     LIKE bna_file.bna01,
          p_bna03 LIKE bna_file.bna03
  #FUN-A30059 end
 
   LET g_errno = NULL
   LET l_cnt = 0
   #SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smyslip = p_bxy01   #FUN-A30059
   SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smyslip = p_bna01    #FUN-A30059 
   IF l_cnt > 0 THEN
      LET g_errno = 'abx-057'
   END IF
 
   RETURN g_errno
END FUNCTION
