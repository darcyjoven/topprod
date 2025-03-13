# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi110.4gl
# Descriptions...: 價格條件維護作業
# Date & Author..: 97/07/25 By Kitty
# Modify.........: NO.MOD-470518 BY wiky add cl_doc()功能
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0095 05/01/07 By Mandy 報表轉XML
# Modify.........: NO.FUN-570109 05/07/14 By Trisy key值可更改
# Modify.........: No.FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/07 By baogui 表頭多行空白
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為用p_query輸出
# Modify.........: No.FUN-930113 09/03/17 By mike 將oah_file改為pnz_file,pnz_file多了一個欄位pnz03
# Modify.........: No.FUN-870007 09/08/06 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A20044 10/02/23 By sherry 修正錄入已存在的價格條件編號無法保存的問題
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60076 10/06/21 By houlia 修正可更改key值時不能成功的問題
# Modify.........: No.FUN-A80104 10/08/18 By lixia 採購取價功能改善
# Modify.........: No.FUN-AB0053 10/11/12 By suncx apmi110調整,價格代碼取消抓取rzz_file，改用combobox
# Modify.........: No.MOD-B10188 11/01/24 By lixia A類價格一組只能有一個
# Modify.........: No.MOD-B30097 11/03/11 By huangrh 判斷同一組別不可存在兩個類型A之資料
# Modify.........: No.MOD-B30229 11/03/12 By baogc 價格代碼下拉中A5和A6的動態顯示
# Modify.........: No:TQC-B50137 11/05/24 By lixia 修改每組只能有一筆A的資料的管控
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50150 11/06/16 By guoch 增加選項 取到價格允許修改
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-C40089 12/04/30 By batr 增加單價可否為零
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-D20076 13/03/13 By Elise 匯出excel時，資料錯誤。
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
#No.FUN-870007-start-
#    g_pnz           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables) #FUN-930113 oah-->pnz
#        pnz01       LIKE pnz_file.pnz01,                                   #FUN-930113 oah-->pnz    
#        pnz02       LIKE pnz_file.pnz02,                                   #FUN-930113 oah-->pnz 
#        pnz03       LIKE pnz_file.pnz03                                    #FUN-930113 add pnz03
#                    END RECORD,
#    g_pnz_t         RECORD                    #程式變數 (舊值)             #FUN-930113 oah-->pnz 
#        pnz01       LIKE pnz_file.pnz01,                                   #FUN-930113 oah-->pnz   
#        pnz02       LIKE pnz_file.pnz02,                                   #FUN-930113 oah-->pnz
#        pnz03       LIKE pnz_file.pnz03                                    #FUN-930113 add pnz03
#                    END RECORD,
       g_pnz RECORD LIKE pnz_file.*,
       g_pnz_t RECORD LIKE pnz_file.*,
       g_pnq DYNAMIC ARRAY OF RECORD 
         pnq04      LIKE pnq_file.pnq04,   #FUN-A80104 add組別       
         pnq02      LIKE pnq_file.pnq02,
         pnq03      LIKE pnq_file.pnq03,         
         #pnq03_desc LIKE rzz_file.rzz02,  #FUN-AB0053 mark
         #rzz03      LIKE rzz_file.rzz03    #FUN-A80104 add類型   #FUN-AB0053 mark
         type       LIKE type_file.chr1     #FUN-AB0053 add類型
             END RECORD,
       g_pnq_t RECORD 
         pnq04      LIKE pnq_file.pnq04,   #FUN-A80104 add組別       
         pnq02      LIKE pnq_file.pnq02,
         pnq03      LIKE pnq_file.pnq03,         
         #pnq03_desc LIKE rzz_file.rzz02,  #FUN-AB0053 mark
         #rzz03      LIKE rzz_file.rzz03    #FUN-A80104 add類型   #FUN-AB0053 mark
         type      LIKE type_file.chr1     #FUN-AB0053 add類型
             END RECORD,
       g_wc STRING,
#No.FUN-870007--end--      
       g_wc2,g_sql    string,  #No.FUN-580092 HCN
       g_rec_b        LIKE type_file.num5,        #單身筆數             #No.FUN-680136 SMALLINT
       l_ac           LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680136 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #NO.FUN-570109    #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_i          LIKE type_file.num5       #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03    #No.FUN-870007
DEFINE g_row_count  LIKE type_file.num10 #No.FUN-870007
DEFINE g_curs_index LIKE type_file.num10 #No.FUN-870007
DEFINE g_jump       LIKE type_file.num10 #No.FUN-870007
DEFINE mi_no_ask    LIKE type_file.num5  #No.FUN-870007
DEFINE cb           ui.ComboBox          #MOD-B30121 ADD
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET p_row = 3 LET p_col = 12
 
    OPEN WINDOW i110_w AT p_row,p_col WITH FORM "apm/42f/apmi110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
##-MOD-B30229- --ADD --BEGIN-------
    LET cb = ui.ComboBox.forName("pnq03")
    IF g_azw.azw04 = '1' THEN
       CALL cb.removeItem('A6')
    END IF
    IF g_sma.sma124 <> 'icd' THEN
       CALL cb.removeItem('A5')
    END IF
##-MOD-B30229- --ADD ---END--------
 
    LET g_forupd_sql="SELECT * FROM pnz_file WHERE pnz01=? FOR UPDATE " #No.FUN-870007
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_cl CURSOR FROM g_forupd_sql     #No.FUN-870007
    CALL i110_menu()
    CLOSE WINDOW i110_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i110_menu()
 
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
#No.FUN-870007-start-
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i110_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i110_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i110_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i110_copy()
            END IF
#No.FUN-870007--end--
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i110_q() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL i110_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL i110_out()         
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"   
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470518
            IF cl_chk_act_auth() AND l_ac != 0 THEN     # FUN-570200
               #IF g_pnz[l_ac].pnz01 IS NOT NULL THEN    #FUN-930113 oah-->pnz #No.FUN-870007
                IF g_pnz.pnz01 IS NOT NULL THEN #No.FUN-870007
					LET g_doc.column1 = "pnz01"           #FUN-930113 oah-->pnz
                 #LET g_doc.value1 = g_pnz[l_ac].pnz01  #FUN-930113 oah-->pnz #No.FUN-870007
                  LET g_doc.value1 = g_pnz.pnz01        #No.FUN-870007
					  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pnz),'','') #FUN-930113 oah-->pnz #MOD-D20076 mark
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pnq),'','') #MOD-D20076 add
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#FUNCTION i110_q() #No.FUN-870007
#   CALL i110_b_askkey() #No.FUN-870007
#END FUNCTION #No.FUN-870007
 
FUNCTION i110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,              #檢查重複用         #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,              #單身鎖住否         #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,              #處理狀態           #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,              #可新增否           #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,              #可刪除否           #No.FUN-680136 SMALLINT
    l_t             LIKE type_file.num5               #FUN-A80104
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    IF cl_null(g_pnz.pnz01) THEN RETURN END IF     #No.FUN-870007
#   LET g_forupd_sql = "SELECT pnz01,pnz02,pnz03 FROM pnz_file WHERE pnz01=? FOR UPDATE" #FUN-930113 oah-->pnz,add pnz03 #No.FUN-870007-mark
#    LET g_forupd_sql = "SELECT pnq02,pnq03,'' FROM pnq_file WHERE pnq01=? AND pnq02=? FOR UPDATE " #No.FUN-870007
#    LET g_forupd_sql = "SELECT pnq04,pnq02,pnq03,'','' FROM pnq_file WHERE pnq01=? AND pnq02=? AND pnq04=? FOR UPDATE " #FUN-A80104  #FUN-AB0053mark
    LET g_forupd_sql = "SELECT pnq04,pnq02,pnq03,'' FROM pnq_file WHERE pnq01=? AND pnq02=? AND pnq04=? FOR UPDATE "  #FUN-AB0053 add
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
#       INPUT ARRAY g_pnz WITHOUT DEFAULTS FROM s_pnz.* #FUN-930113 oah-->pnz #No.FUN-870007
        INPUT ARRAY g_pnq WITHOUT DEFAULTS FROM s_pnq.*                       #No.FUN-870007
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
           #DISPLAY l_ac TO FORMONLY.cn3   #No.FUN-870007  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
              #LET g_pnz_t.* = g_pnz[l_ac].*  #BACKUP #FUN-930113  oah-->pnz #No.FUN-870007
               LET g_pnq_t.* = g_pnq[l_ac].*  #No.FUN-870007
#No.FUN-570109 --start--                                                                                                            
               #LET  g_before_input_done = FALSE #No.FUN-870007                                                                                 
               #CALL i110_set_entry(p_cmd)       #No.FUN-870007                                                                               
               #CALL i110_set_no_entry(p_cmd)    #No.FUN-870007                                                                                 
               #LET  g_before_input_done = TRUE  #No.FUN-870007                                                                      
#No.FUN-570109 --end--     
               BEGIN WORK
               #No.FUN-870007-start-
               OPEN i110_cl USING g_pnz.pnz01
               IF STATUS THEN
                  CALL cl_err("OPEN i110_cl:",STATUS,1)
                  CLOSE i110_cl
                  ROLLBACK WORK
               END IF
               FETCH i110_cl INTO g_pnz.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pnz.pnz01,SQLCA.sqlcode,1)
                  CLOSE i110_cl
                  ROLLBACK WORK 
                  RETURN
               END IF
               #No.FUN-870007--end--
              #OPEN i110_bcl USING g_pnz_t.pnz01 #FUN-930113  oah-->pnz #No.FUN-870007
               #OPEN i110_bcl USING g_pnz.pnz01,g_pnq_t.pnq02  #No.FUN_870007
               OPEN i110_bcl USING g_pnz.pnz01,g_pnq_t.pnq02,g_pnq_t.pnq04 #FUN-A80104 
               IF STATUS THEN
                  CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                 #FETCH i110_bcl INTO g_pnz[l_ac].* #FUN-930113  oah-->pnz #No.FUN-870007
                  FETCH i110_bcl INTO g_pnq[l_ac].* #No.FUN-870007
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pnz_t.pnz01,SQLCA.sqlcode,1) #FUN-930113 oah-->pnz
                     LET l_lock_sw = "Y"
                  END IF
                  #No.FUN-870007-start-
                  #SELECT rzz02 INTO g_pnq[l_ac].pnq03_desc FROM rzz_file
                  #FUN-AB0053 mark begin------------------------------
                  #SELECT rzz02,rzz03 INTO g_pnq[l_ac].pnq03_desc,g_pnq[l_ac].rzz03 FROM rzz_file #FUN-A80104
                  # WHERE rzz01 = g_pnq[l_ac].pnq03
                  #   AND rzz00 = '1'
                  #FUN-AB0053 mark end------------------------------
                  #FUN-AB0053 add begin------------------------------
                  IF g_pnq[l_ac].pnq03 MATCHES "A*" THEN
                     LET g_pnq[l_ac].type = "A"
                  END IF
                  IF g_pnq[l_ac].pnq03 MATCHES "B*" THEN
                     LET g_pnq[l_ac].type = "B"
                  END IF
                  IF g_pnq[l_ac].pnq03 MATCHES "C*" THEN
                     LET g_pnq[l_ac].type = "C"
                  END IF
                  #FUN-AB0053 add end------------------------------
                  #No.FUN-870007--end--
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           #INSERT INTO pnz_file(pnz01,pnz02,pnz03) #FUN-930113 oah-->pnz,add pnz03 #No.FUN-870007
           #VALUES(g_pnz[l_ac].pnz01,g_pnz[l_ac].pnz02,g_pnz[l_ac].pnz03) #FUN-930113 oah-->pnz,add pnz03 #No.FUN-870007
           # INSERT INTO pnq_file(pnq01,pnq02,pnq03)                    #No.FUN-870007#FUN-A80104mark
           #   VALUES(g_pnz.pnz01,g_pnq[l_ac].pnq02,g_pnq[l_ac].pnq03)  #No.FUN-870007#FUN-A80104mark
           INSERT INTO pnq_file(pnq01,pnq02,pnq03,pnq04)                    #FUN-A80104add
           VALUES(g_pnz.pnz01,g_pnq[l_ac].pnq02,g_pnq[l_ac].pnq03,g_pnq[l_ac].pnq04)    #FUN-A80104add
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_oah[l_ac].oah01,SQLCA.sqlcode,0)   #No.FUN-660129
               #CALL cl_err3("ins","pnz_file",g_pnz[l_ac].pnz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129 #FUN-930113 oah-->pnz #No.FUN-870007
                CALL cl_err3("ins","pnq_file",g_pnz.pnz01,g_pnq[l_ac].pnq02,SQLCA.sqlcode,"","",1)  #No.FUN-870007
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
           #LET  g_before_input_done = FALSE #No.FUN-870007                                                                                     
           #CALL i110_set_entry(p_cmd)       #No.FUN-870007                                                                                       
           #CALL i110_set_no_entry(p_cmd)    #No.FUN-870007                                                                                       
           #LET  g_before_input_done = TRUE  #No.FUN-870007                                                                                       
#No.FUN-570109 --end--           
           #INITIALIZE g_pnz[l_ac].* TO NULL      #900423 #FUN-930113 oah-->pnz #No.FUN-870007
           #LET g_pnz_t.* = g_pnz[l_ac].*         #新輸入資料 #FUN-930113 oah-->pnz #No.FUN-870007
            INITIALIZE g_pnq[l_ac].* TO NULL   #No.FUN-870007
            LET g_pnq_t.* = g_pnq[l_ac].*      #No.FUN-870007
            CALL cl_show_fld_cont()     #FUN-550037(smin)
           #NEXT FIELD pnz01 #FUN-930113 oah-->pnz #No.FUN-870007
           #NEXT FIELD pnq02 #No.FUN-870007  #FUN-A80104
           #FUN-A80104--start--
           #根據l_ac判斷顯示的組別 
            IF l_ac >= 2 THEN
               LET g_pnq[l_ac].pnq04 = g_pnq[l_ac-1].pnq04
            ELSE
               LET g_pnq[l_ac].pnq04 =  1            #Body default
            END IF
            NEXT FIELD pnq04
           #FUN-A80104--END-- 
            
 
#No.FUN-870007-start-
#        AFTER FIELD pnz01                        #check 編號是否重複 #FUN-930113 oah-->pnz
#            IF g_pnz[l_ac].pnz01 IS NOT NULL THEN #FUN-930113 oah-->pnz 
#            IF g_pnz[l_ac].pnz01 != g_pnz_t.pnz01 OR #FUN-930113 oah-->pnz 
#               (g_pnz[l_ac].pnz01 IS NOT NULL AND g_pnz_t.pnz01 IS NULL) THEN #FUN-930113 oah-->pnz 
#                SELECT count(*) INTO l_n FROM pnz_file #FUN-930113 oah-->pnz 
#                    WHERE pnz01 = g_pnz[l_ac].pnz01 #FUN-930113 oah-->pnz 
#                IF l_n > 0 THEN
#                    CALL cl_err('',-239,0)
#                    LET g_pnz[l_ac].pnz01 = g_pnz_t.pnz01 #FUN-930113 oah-->pnz 
#                    NEXT FIELD pnz01 #FUN-930113 oah-->pnz 
#                END IF
#            END IF
#            END IF
#
##FUN-930113 -----ADD START
#        AFTER FIELD pnz03
#           IF g_pnz[l_ac].pnz03 IS NOT NULL THEN
#              IF g_pnz[l_ac].pnz03 NOT MATCHES '[123456789]' THEN
#                 CALL cl_err('',-1103,0)
#                 NEXT FIELD pnz03
#              END IF
#              IF NOT s_industry("icd") THEN                                      
#                 IF g_pnz[l_ac].pnz03 ="8" THEN                                       
#                    CALL cl_err(g_pnz[l_ac].pnz03,"asm-250",1)                       
#                    NEXT FIELD pnz03                                           
#                 END IF                                                          
#              END IF
#           END IF  
##FUN-930113 -----ADD END
#FUN-A80104-----AND START
      AFTER FIELD pnq04
           IF NOT cl_null(g_pnq[l_ac].pnq04) THEN
              IF g_pnq[l_ac].pnq04 != g_pnq_t.pnq04 OR g_pnq_t.pnq04 IS NULL THEN
                 SELECT COUNT(*) INTO l_n FROM pnq_file
                  WHERE pnq01= g_pnz.pnz01 AND pnq02=g_pnq[l_ac].pnq02 AND pnq04=g_pnq[l_ac].pnq04
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pnq[l_ac].pnq04 = g_pnq_t.pnq04
                    NEXT FIELD pnq04
                 END IF                
                 CALL i110_first_a()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_pnq[l_ac].pnq04 = g_pnq_t.pnq04
                    NEXT FIELD pnq04
                 END IF
                 #MOD-B10188--add--str--
                 CALL i110_check(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_pnq[l_ac].pnq04 = g_pnq_t.pnq04
                    DISPLAY BY NAME g_pnq[l_ac].pnq04
                    NEXT FIELD pnq04
                 END IF
                 #MOD-B10188--add--end--
                 IF NOT cl_null(g_pnq[l_ac].pnq03) THEN
                    CALL i110_pnq03('d')
                 END IF              
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_pnq[l_ac].pnq04 = g_pnq_t.pnq04
                    NEXT FIELD pnq04
                 END IF
                 IF g_pnq[l_ac].pnq04 = 0 THEN
                    IF l_ac >= 2 THEN
                       LET g_pnq[l_ac].pnq04 = g_pnq[l_ac-1].pnq04
                    ELSE
                       LET g_pnq[l_ac].pnq04 =  1      
                    END IF
                    NEXT FIELD pnq04
                 END IF
              END IF
           END IF
#FUN-A80104-----ADD END
      
      BEFORE FIELD pnq02
        IF cl_null(g_pnq[l_ac].pnq02) OR g_pnq[l_ac].pnq02 = 0 THEN 
           SELECT MAX(pnq02)+1 INTO g_pnq[l_ac].pnq02 FROM pnq_file
#            WHERE pnq01=g_pnz.pnz01
             WHERE pnq01=g_pnz.pnz01 AND pnq04=g_pnq[l_ac].pnq04   #FUN-A80104
           IF g_pnq[l_ac].pnq02 IS NULL THEN
              LET g_pnq[l_ac].pnq02=1
           END IF
         END IF
         
      AFTER FIELD pnq02
        IF NOT cl_null(g_pnq[l_ac].pnq02) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_pnq[l_ac].pnq02 <> g_pnq_t.pnq02) THEN
              SELECT COUNT(*) INTO l_n FROM pnq_file
#               WHERE pnq01= g_pnz.pnz01 AND pnq02=g_pnq[l_ac].pnq02
                WHERE pnq01= g_pnz.pnz01 AND pnq02=g_pnq[l_ac].pnq02 AND pnq04=g_pnq[l_ac].pnq04    #FUN-A80104
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_pnq[l_ac].pnq02=g_pnq_t.pnq02
                 NEXT FIELD pnq02
              END IF
#FUN-A80104---START---
           #END IF   
              CALL i110_first_a()                 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pnq[l_ac].pnq02,g_errno,0)
                 LET g_pnq[l_ac].pnq02 = g_pnq_t.pnq02
                 NEXT FIELD pnq02
              END IF
              #MOD-B10188--add--str--
#              CALL i110_check(p_cmd) #MOD-B30097 mark
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_pnq[l_ac].pnq02 = g_pnq_t.pnq02
                 DISPLAY BY NAME g_pnq[l_ac].pnq02
                 NEXT FIELD pnq02
              END IF
              #MOD-B10188--add--end--
              IF g_pnq[l_ac].pnq02 = 0 THEN
                 NEXT FIELD pnq02
              END IF              
            END IF
            IF NOT cl_null(g_pnq[l_ac].pnq03) THEN
               CALL i110_pnq03('d')
            END IF   
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pnq[l_ac].pnq02,g_errno,0)
               LET g_pnq[l_ac].pnq02 = g_pnq_t.pnq02
               NEXT FIELD pnq02
            END IF
#FUN-A80104---END---             
         END IF
         
      AFTER FIELD pnq03
         IF NOT cl_null(g_pnq[l_ac].pnq03) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_pnq[l_ac].pnq03 <> g_pnq_t.pnq03) THEN
              #FUN-AB0053 mark begin------------------
              #CALL i110_pnq03('a')
              #IF NOT cl_null(g_errno) THEN
              #   CALL cl_err(g_pnq[l_ac].pnq03,g_errno,0)
              #   LET g_pnq[l_ac].pnq03=g_pnq_t.pnq03
              #   DISPLAY BY NAME g_pnq[l_ac].pnq03
              #   NEXT FIELD pnq03
              #END IF
              #FUN-AB0053 mark end------------------
#FUN-A80104---START---                 
              CALL i110_first_a()              
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pnq[l_ac].pnq03,g_errno,0)
                 LET g_pnq[l_ac].pnq03 = g_pnq_t.pnq03
                 DISPLAY BY NAME g_pnq[l_ac].pnq03
                 NEXT FIELD pnq03
              END IF                          
              #MOD-B10188--add--str--
              CALL i110_check(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 #LET g_pnq[l_ac].pnq03 = g_pnq_t.pnq03
                 #DISPLAY BY NAME g_pnq[l_ac].pnq03
                 NEXT FIELD pnq03
              END IF
              #MOD-B10188--add--end--
              IF NOT cl_null(g_pnq[l_ac].pnq04) THEN
                 FOR l_t=1 TO g_rec_b
                     IF g_pnq[l_ac].pnq04=g_pnq[l_t].pnq04 AND l_ac !=l_t THEN
                        IF g_pnq[l_ac].pnq03=g_pnq[l_t].pnq03 THEN
                           LET g_errno="art-617" 
                           EXIT FOR
                        END IF 
                     END IF    
                  END FOR
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pnq[l_ac].pnq03,g_errno,0)
                     LET g_pnq[l_ac].pnq03 = g_pnq_t.pnq03
                     DISPLAY BY NAME g_pnq[l_ac].pnq03
                     NEXT FIELD pnq03
                  END IF 
               END IF
#FUN-A80104---END---                 
           END IF
         END IF
#No.FUN-870007--end--
#No.FUN-AB0053--- ADD begin--------------
        ON CHANGE pnq03
           IF NOT cl_null(g_pnq[l_ac].pnq03) THEN
              CALL i110_pnq03('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pnq[l_ac].pnq03,g_errno,0)
                 IF p_cmd = 'u' THEN           #MOD-B10188 add 
                 LET g_pnq[l_ac].pnq03=g_pnq_t.pnq03 
                 END IF                        #MOD-B10188 add
                 DISPLAY BY NAME g_pnq[l_ac].pnq03 
                 NEXT FIELD pnq03
              END IF
           END IF
#No.FUN-AB0053--- ADD end--------------
        BEFORE DELETE                            #是否取消單身
           #IF g_pnz_t.pnz01 IS NOT NULL THEN #FUN-930113 oah-->pnz #No.FUN-870007
           #IF g_pnq_t.pnq02 > 0 AND NOT cl_null(g_pnq_t.pnq02) THEN #No.FUN-870007
           IF g_pnq_t.pnq02 > 0 AND NOT cl_null(g_pnq_t.pnq02)
              AND g_pnq_t.pnq04 > 0 AND NOT cl_null(g_pnq_t.pnq04) THEN  #FUN-A80104
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}        #DELETE FROM pnz_file WHERE pnz01 = g_pnz_t.pnz01 #FUN-930113 oah-->pnz #No.FUN-870007
                #DELETE FROM pnq_file WHERE pnq01 = g_pnz.pnz01 AND pnq02 = g_pnq_t.pnq02 #No.FUN-870007
                DELETE FROM pnq_file WHERE pnq01 = g_pnz.pnz01 AND pnq02 = g_pnq_t.pnq02 AND pnq04 = g_pnq_t.pnq04 #FUN-A80104
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oah_t.oah01,SQLCA.sqlcode,0)
                  #CALL cl_err3("del","pnz_file",g_pnz_t.pnz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129 #FUN-930113 oah-->pnz #No.FUN-870007
                   CALL cl_err3("del","pnq_file",g_pnz.pnz01,g_pnq_t.pnq02,SQLCA.sqlcode,"","",1) #No.FUN-870007
                   ROLLBACK WORK 
                   CANCEL DELETE 
                END IF                                 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i110_bcl
                COMMIT WORK 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #LET g_pnz[l_ac].* = g_pnz_t.* #FUN-930113 oah-->pnz #No.FUN-870007 
               LET g_pnq[l_ac].* = g_pnq_t.* #No.FUN-870007
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
              #CALL cl_err(g_pnz[l_ac].pnz01,-263,1) #FUN-930113 oah-->pnz #No.FUN-870007
              #LET g_pnz[l_ac].* = g_pnz_t.* #FUN-930113 oah-->pnz  #No.FUN-870007
               CALL cl_err(g_pnq[l_ac].pnq02,-263,1) #No.FUN-870007
               LET g_pnq[l_ac].* = g_pnq_t.*         #No.FUN-870007
            ELSE
               #No.FUN-870007-start-
               #UPDATE pnz_file #FUN-930113 oah-->pnz 
               #            SET pnz01=g_pnz[l_ac].pnz01, #FUN-930113 oah-->pnz 
               #                pnz02=g_pnz[l_ac].pnz02, #FUN-930113 oah-->pnz 
               #                pnz03=g_pnz[l_ac].pnz03  #FUN-930113 add pnz03 
               # WHERE pnz01= g_pnz_t.pnz01 #FUN-930113 oah-->pnz 
               UPDATE pnq_file SET pnq02=g_pnq[l_ac].pnq02,
                                   pnq03=g_pnq[l_ac].pnq03,
                                   pnq04=g_pnq[l_ac].pnq04  #FUN-A80104
                WHERE pnq01 = g_pnz.pnz01
                  AND pnq02 = g_pnq_t.pnq02
                  AND pnq04 = g_pnq_t.pnq04   #FUN-A80104
               #No.FUN-870007--end--
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oah[l_ac].oah01,SQLCA.sqlcode,0)   #No.FUN-660129
                  #CALL cl_err3("upd","pnz_file",g_pnz_t.pnz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129 #FUN-930113 oah-->pnz #No.FUN-870007
                  #LET g_pnz[l_ac].* = g_pnz_t.* #FUN-930113 oah-->pnz #No.FUN-870007
                   CALL cl_err3("upd","pnq_file",g_pnz.pnz01,g_pnq_t.pnq02,SQLCA.sqlcode,"","",1) #No.FUN-870007
                   LET g_pnq[l_ac].* = g_pnq_t.* #No.FUN-870007
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i110_bcl
                   COMMIT WORK 
               END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac             #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                 #LET g_pnz[l_ac].* = g_pnz_t.* #FUN-930113 oah-->pnz #No.FUN-870007
                  LET g_pnq[l_ac].* = g_pnq_t.* #No.FUN-870007
               #FUN-D30034---add---str---
               ELSE
                  CALL g_pnq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034---add---end---
               END IF 
               #MOD-B10188--mark--str--
#               #FUN-A80104---START---       
#               CALL i110_first_a()              
#               IF NOT cl_null(g_errno) THEN
#                  CALL cl_err(g_pnq[l_ac].pnq02,g_errno,1)
#                  NEXT FIELD pnq02
#               END IF   
#               #FUN-A80104---END---    
               #MOD-B10188--mark--end--
               #MOD-B10188--add--str--
               IF NOT i110_check_a() THEN
                  CALL cl_err('','axm-264',0)
                  NEXT FIELD pnq04
               END IF
               #MOD-B10188--add--end--
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF    
            LET l_ac_t = l_ac         #FUN-D30034 add    
            CLOSE i110_bcl
            COMMIT WORK 
#    #FUN-A80104---START---
        AFTER INPUT
           # LET l_ac = ARR_CURR()
           # CALL i110_first_a()              
           # IF NOT cl_null(g_errno) THEN
           #    CALL cl_err(g_pnq[l_ac].pnq02,g_errno,1)
           #    NEXT FIELD pnq02
           # END IF   
           #MOD-B10188--add--str--
           IF NOT i110_check_a() THEN
              CALL cl_err('','axm-264',0)
              NEXT FIELD pnq04
           END IF
           #MOD-B10188--add--end--
    #FUN-A80104---END---
#FUN-AB0053 mark begin------------           
#No.FUN-870007-start-     
	#ON ACTION controlp
  #       CASE
	#    WHEN INFIELD(pnq03)
  #             CALL cl_init_qry_var()
  #             LET g_qryparam.form = "q_rzz01"
  #             LET g_qryparam.arg1='1'
	#       CALL cl_create_qry() RETURNING g_pnq[l_ac].pnq03
	#       DISPLAY BY NAME g_pnq[l_ac].pnq03 
  #             CALL i110_pnq03('d')
	#       NEXT FIELD pnq03
	#    OTHERWISE EXIT CASE
	#END CASE
#No.FUN-870007--end--    
#FUN-AB0053 mark end------------  
 
        ON ACTION CONTROLN
            CALL i110_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           #No.FUN-870007-start-
           #IF INFIELD(pnz01) AND l_ac > 1 THEN #FUN-930113 oah-->pnz 
               #LET g_pnz[l_ac].* = g_pnz[l_ac-1].* #FUN-930113 oah-->pnz 
               #NEXT FIELD pnz01 #FUN-930113 oah-->pnz 
            IF INFIELD(pnq02) AND l_ac > 1 THEN 
               LET g_pnq[l_ac].* = g_pnq[l_ac-1].*
               NEXT FIELD pnq02
           #No.FUN-870007--end--
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
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i110_bcl
    COMMIT WORK
#   CALL i110_delall() #No.FUN-870007  #CHI-C30002 mark
    CALL i110_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i110_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM pnz_file WHERE pnz01 = g_pnz.pnz01
         INITIALIZE g_pnz.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i110_b_askkey()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01 #No.FUN-870007
 
    CLEAR FORM
#No.FUN-870007-start-
   #CALL g_pnz.clear() #FUN-930113 oah-->pnz 
   #CONSTRUCT g_wc2 ON pnz01,pnz02,pnz03 #FUN-930113 oah-->pnz ,add pnz03
   #        FROM s_pnz[1].pnz01,s_pnz[1].pnz02,s_pnz[1].pnz03 #FUN-930113 oah-->pnz,add pnz03
    CALL g_pnq.clear()
 
    CONSTRUCT BY NAME g_wc ON                               
        #pnz01,pnz02,pnz04,pnz05
        pnz01,pnz02,pnz04,pnz07,pnz06,pnz05,pnz08  #FUN-A80104 #FUN-B50150 add pnz07 #FUN-C40089 add pnz08
             
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
        ON ACTION about         
          CALL cl_about()      
 
        ON ACTION help         
          CALL cl_show_help()
 
        ON ACTION controlg   
          CALL cl_cmdask() 
 
        ON ACTION qbe_select                         	  
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)          
		
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN
      RETURN
    END IF
    #CONSTRUCT g_wc2 ON pnq02,pnq03
    #FROM s_pnq[1].pnq02,s_pnq[1].pnq03
    CONSTRUCT g_wc2 ON pnq04,pnq02,pnq03
    FROM s_pnq[1].pnq04,s_pnq[1].pnq02,s_pnq[1].pnq03  #FUN-A80104
#No.FUN-870007--end--
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
#FUN-930113 -----add start
      ON ACTION controlp
         CASE                
            #No.FUN-870007-start-                                                                                                     
            #WHEN INFIELD(pnz01)                                                                                                   
            #   CALL cl_init_qry_var()                                                                                           
            #   LET g_qryparam.form = "q_pnz01"                                                                                  
            #   LET g_qryparam.state = 'c'                                                                                       
            #   CALL cl_create_qry() RETURNING g_qryparam.multiret                                                               
            #   DISPLAY g_qryparam.multiret TO pnz01                                                                             
            #   NEXT FIELD pnz01   
             WHEN INFIELD(pnq03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pnq03"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO pnq03 
                NEXT FIELD pnq03
            #No.FUN-870007--end--
            OTHERWISE EXIT CASE
         END CASE
#FUN-930113 -----add end
       
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
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
#      LET INT_FLAG = 0  #No.FUN-870007
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    
#No.FUN-870007-start-
    LET g_wc2 = g_wc2 CLIPPED
    #IF  g_wc2 = "1=1" THEN    #FUN-AB0053 mark
    IF  g_wc2 = " 1=1" THEN    #FUN-AB0053 add  
         LET g_sql = "SELECT pnz01 FROM pnz_file ", 
                     " WHERE ",g_wc CLIPPED, " ORDER BY pnz01"
    ELSE                                 
        LET g_sql = "SELECT UNIQUE pnz01",
                    " FROM pnz_file,pnq_file",
                    " WHERE pnz01=pnq01",
                    " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " ORDER BY pnz01"
    END IF
    
    PREPARE i110_prepare FROM g_sql
    DECLARE i110_cs SCROLL CURSOR WITH HOLD FOR i110_prepare
    IF g_wc2=" 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM pnz_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT pnz01) FROM pnz_file,pnq_file ",
                  " WHERE pnz01=pnq01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE i110_precount FROM g_sql
    DECLARE i110_count CURSOR FOR i110_precount
#    CALL i110_b_fill(g_wc2)
#No.FUN-870007--end--
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
#No.FUN-870007-start-
#    LET g_sql =
#        "SELECT pnz01,pnz02,pnz03", #FUN-930113 oah-->pnz,add pnz03
#        " FROM pnz_file", #FUN-930113 oah-->pnz 
#        " WHERE ", p_wc2 CLIPPED,                     #單身
#        " ORDER BY 1"
    #LET g_sql = "SELECT pnq02,pnq03,'' FROM pnq_file",
    #            " WHERE pnq01='",g_pnz.pnz01,"'"
    LET g_sql = "SELECT pnq04,pnq02,pnq03,'','' FROM pnq_file",    #FUN-A80104
                " WHERE pnq01='",g_pnz.pnz01,"'" 
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    #LET g_sql=g_sql CLIPPED," ORDER BY pnq02 "
    LET g_sql=g_sql CLIPPED," ORDER BY pnq04,pnq02,pnq03"  #FUN-A80104
#No.FUN-870007--end--
    PREPARE i110_pb FROM g_sql
    DECLARE pnz_curs CURSOR FOR i110_pb #FUN-930113 oah-->pnz 
 
   #CALL g_pnz.clear() #FUN-930113 oah-->pnz #No.FUN-870007
    CALL g_pnq.clear() #No.FUN-870007
    LET g_cnt = 1
    MESSAGE "Searching!" 
   #FOREACH pnz_curs INTO g_pnz[g_cnt].*   #單身 ARRAY 填充 #FUN-930113 oah-->pnz #No.FUN-870007
    FOREACH pnz_curs INTO g_pnq[g_cnt].*   #No.FUN-870007
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-870007-start-
        #SELECT rzz02 INTO g_pnq[g_cnt].pnq03_desc
        #SELECT rzz02,rzz03 INTO g_pnq[g_cnt].pnq03_desc,g_pnq[g_cnt].rzz03  #FUN-A80104  #FUN-AB0053 mark
        #  FROM rzz_file                                  #FUN-AB0053 mark
        # WHERE rzz00='1' AND rzz01=g_pnq[g_cnt].pnq03    #FUN-AB0053 mark
        #No.FUN-870007--end--
        #FUN-AB0053 add begin------------------------------
        IF g_pnq[g_cnt].pnq03 MATCHES "A*" THEN
            LET g_pnq[g_cnt].type = "A"
        END IF
        IF g_pnq[g_cnt].pnq03 MATCHES "B*" THEN
           LET g_pnq[g_cnt].type = "B"
        END IF
        IF g_pnq[g_cnt].pnq03 MATCHES "C*" THEN
           LET g_pnq[g_cnt].type = "C"
        END IF
        #FUN-AB0053 add end------------------------------
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
   #CALL g_pnz.deleteElement(g_cnt) #FUN-930113 oah-->pnz #No.FUN-870007
    CALL g_pnq.deleteElement(g_cnt) #No.FUN-870007
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3  
END FUNCTION
 
FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  #DISPLAY ARRAY g_pnz TO s_pnz.* ATTRIBUTE(COUNT=g_rec_b) #FUN-930113 oah-->pnz #No.FUN-870007
   DISPLAY ARRAY g_pnq TO s_pnq.* ATTRIBUTE(COUNT=g_rec_b) #No.FUN-870007
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#No.FUN-870007-start-
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i110_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i110_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i110_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i110_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL i110_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
#No.FUN-870007--end--
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
       ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i110_out()
   DEFINE
       l_pnz           RECORD LIKE pnz_file.*,       #FUN-930113 oah-->pnz 
       l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       l_name          LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680136 VARCHAR(20)
       l_za05          LIKE za_file.za05             #No.FUN-680136 VARCHAR(40)
 
   DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002  
  
   IF g_wc2 IS NULL THEN 
      CALL cl_err('','9057',0) RETURN 
   END IF
#No.FUN-820002--start--
   #報表轉為使用 p_query                                                                                                            
   LET l_cmd = 'p_query "apmi110" "',g_wc2 CLIPPED,'"'                                                                              
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN 
 
#   CALL cl_wait()
#   CALL cl_outnam('apmi110') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM oah_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i110_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i110_co                         # CURSOR
#       CURSOR FOR i110_p1
 
#   START REPORT i110_rep TO l_name
 
#   FOREACH i110_co INTO l_oah.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i110_rep(l_oah.*)
#   END FOREACH
 
#   FINISH REPORT i110_rep
 
#   CLOSE i110_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i110_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,                 #No.FUN-680136 VARCHAR(1)
#       sr RECORD LIKE oah_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.oah01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
##           PRINT                   #TQC-6A0090
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#           PRINT g_dash1 
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.oah01,
#                 COLUMN g_c[32],sr.oah02,
#                 COLUMN g_c[33],sr.oah03,
#                 COLUMN g_c[34],sr.oah04,
#                 COLUMN g_c[35],sr.oah05,
#                 COLUMN g_c[36],sr.oah06 
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
#No.FUN-570109 --start--                                                                                                            
FUNCTION i110_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680136 VARCHAR(1)
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("pnz01",TRUE)   #FUN-930113 oah-->pnz                                                                                         
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i110_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680136 VARCHAR(1)
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("pnz01",FALSE)    #FUN-930113 oah-->pnz                                                                                       
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--               
 
#No.FUN-870007-start-
FUNCTION i110_pnq03(p_cmd)         
DEFINE p_cmd   LIKE type_file.chr1
#DEFINE l_rzz02 LIKE rzz_file.rzz02   #FUN-AB0053 mark
#DEFINE l_rzz03 LIKE rzz_file.rzz03  #FUN-A80104   #FUN-AB0053 mark
DEFINE l_type LIKE type_file.chr1  #FUN-AB0053 add 
DEFINE l_n     LIKE type_file.num5  #FUN-A80104
          
   LET g_errno = ' '
#   SELECT rzz02 INTO l_rzz02
#FUN-AB0053 mark begin----------------------
#    SELECT rzz02,rzz03 INTO l_rzz02,l_rzz03  #FUN-A80104
#     FROM rzz_file 
#    WHERE rzz01 = g_pnq[l_ac].pnq03
#      AND rzz00='1'
#  CASE                          
#        WHEN SQLCA.sqlcode=100   LET g_errno='axm-183' 
#                                 LET l_rzz02=NULL 
#       OTHERWISE   
#       LET g_errno=SQLCA.sqlcode USING '------' 
#  END CASE
#FUN-AB0053 mark end------------------------
#FUN-AB0053 add begin------------------------------
   IF g_pnq[l_ac].pnq03 MATCHES "A*" THEN
      LET l_type = "A"
   END IF
   IF g_pnq[l_ac].pnq03 MATCHES "B*" THEN
      LET l_type = "B"
   END IF
   IF g_pnq[l_ac].pnq03 MATCHES "C*" THEN
      LET l_type = "C"
   END IF
#FUN-AB0053 add end------------------------------
  #FUN-A80104---start---
  IF NOT cl_null(g_pnq[l_ac].pnq04) THEN
     IF l_type = 'A'  THEN
        #FUN-AB0053 mark begin----------------------
        #SELECT COUNT(*) INTO l_n FROM rzz_file,pnq_file
        # WHERE rzz00 = '1' AND rzz01 = pnq03
        #   AND pnq01 = g_pnz.pnz01
        #   AND pnq04 = g_pnq[l_ac].pnq04
        #   AND pnq02 < g_pnq[l_ac].pnq02
        #   AND rzz03 = 'C'
        #FUN-AB0053 mark end------------------------
        SELECT COUNT(*) INTO l_n FROM pnq_file     #FUN-AB0053 add
         WHERE pnq01 = g_pnz.pnz01
           AND pnq04 = g_pnq[l_ac].pnq04
           AND pnq02 < g_pnq[l_ac].pnq02
           AND pnq03 LIKE "C%"
      ELSE
         IF l_type = 'C'  THEN 
            #FUN-AB0053 mark begin----------------------
            #SELECT COUNT(*) INTO l_n FROM rzz_file,pnq_file
            # WHERE rzz00 = '1' AND rzz01 = pnq03
            #   AND pnq01 = g_pnz.pnz01
            #   AND pnq04 = g_pnq[l_ac].pnq04
            #   AND pnq02 > g_pnq[l_ac].pnq02
            #   AND rzz03 = 'A'  
            #FUN-AB0053 mark end------------------------
            SELECT COUNT(*) INTO l_n FROM pnq_file  #FUN-AB0053 add
             WHERE pnq01 = g_pnz.pnz01
               AND pnq04 = g_pnq[l_ac].pnq04
               AND pnq02 > g_pnq[l_ac].pnq02
               AND pnq03 LIKE "A%"
         END IF
      END IF
      IF l_n IS NULL THEN LET l_n = 0 END IF
      IF l_n > 0 THEN
         LET g_errno='apm1049'
      END IF 
   END IF   
   #FUN-A80104---end---    
  
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      #LET g_pnq[l_ac].pnq03_desc = l_rzz02    #FUN-AB0053 mark
      LET g_pnq[l_ac].type = l_type    #FUN-A80104
      #DISPLAY BY NAME g_pnq[l_ac].pnq03_desc  #FUN-AB0053 mark
      DISPLAY BY NAME g_pnq[l_ac].type #FUN-A80104
   END IF
END FUNCTION
 
FUNCTION i110_a()
  DEFINE l_n   LIKE type_file.num5    #TQC-A20044
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pnq.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_pnz.* LIKE pnz_file.*                  
 
   LET g_pnz_t.* = g_pnz.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_pnz.pnz03=' '
      LET g_pnz.pnz04='N'
      LET g_pnz.pnz05='N'
      LET g_pnz.pnz06='N'    #FUN-A80104   
      LET g_pnz.pnz07='N'    #FUN-B50150
      LET g_pnz.pnz08='Y'    #FUN-C40089
 
      CALL i110_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_pnz.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_pnz.pnz01) THEN       
         CONTINUE WHILE
      END IF
 
      SELECT COUNT(*) INTO l_n FROM pnz_file WHERE pnz01 = g_pnz.pnz01 #TQC-A20044 add
      IF l_n = 0 THEN  #TQC-A20044
         INSERT INTO pnz_file VALUES (g_pnz.*)
         IF SQLCA.sqlcode THEN                     
            CALL cl_err3("ins","pnz_file",g_pnz.pnz01,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
         ELSE
            COMMIT WORK                                                   
         END IF
      END IF #TQC-A20044   
      
      SELECT * INTO g_pnz.* FROM pnz_file
       WHERE pnz01 = g_pnz.pnz01
      LET g_pnz_t.* = g_pnz.*
      IF l_n = 0 THEN  #TQC-A20044
         CALL g_pnq.clear()
         LET g_rec_b = 0 
         CALL i110_b() 
      END IF #TQC-A20044                      
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i110_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1,                
           l_n       LIKE type_file.num5           
     
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME
      #g_pnz.pnz01,g_pnz.pnz02,g_pnz.pnz04,g_pnz.pnz05   
      g_pnz.pnz01,g_pnz.pnz02,g_pnz.pnz04,g_pnz.pnz07,g_pnz.pnz06,g_pnz.pnz05,g_pnz.pnz08  #FUN-A80104   #FUN-B50150  add pnz07  #FUN-C40089 add pnz08
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         
          LET g_before_input_done = FALSE
          CALL i110_set_entry(p_cmd)
          CALL i110_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
	
      AFTER FIELD pnz01
         IF NOT cl_null(g_pnz.pnz01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnz.pnz01 != g_pnz_t.pnz01) THEN
               SELECT COUNT(*) INTO l_n FROM pnz_file WHERE pnz01 = g_pnz.pnz01
               IF l_n > 0 THEN                  
                 CALL i110_b_fill("1=1")
                 LET l_ac = g_rec_b + 1  
                 CALL i110_b()
                 EXIT INPUT
               END IF
            END IF
         END IF
          
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_pnz.pnz01) THEN
               NEXT FIELD pnz01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(pnz01) THEN
            LET g_pnz.* = g_pnz_t.*
            CALL i110_show()
            NEXT FIELD pnz01
         END IF
 
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
 
END FUNCTION
 
FUNCTION i110_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_pnz.pnz01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   
   BEGIN WORK
 
   OPEN i110_cl USING g_pnz.pnz01
   IF STATUS THEN
      CALL cl_err("OPEN i110_cl:", STATUS, 1)
      CLOSE i110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i110_cl INTO g_pnz.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pnz.pnz01,SQLCA.sqlcode,0)    
       CLOSE i110_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i110_show()
 
   WHILE TRUE
      LET g_pnz_t.* = g_pnz.*
 
      CALL i110_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pnz.*=g_pnz_t.*
         CALL i110_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_pnz.pnz01 <> g_pnz_t.pnz01 THEN            
         UPDATE pnq_file SET pnq01 = g_pnz.pnz01
          WHERE pnq01 = g_pnz_t.pnz01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","pnq_file",g_pnz_t.pnz01,"",SQLCA.sqlcode,"","pnq",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE pnz_file SET pnz_file.* = g_pnz.*
   #   WHERE pnz01 = g_pnz.pnz01
       WHERE pnz01 = g_pnz_t.pnz01      #TQC-A60076 --houlia modify
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","pnz_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i110_cl
   COMMIT WORK
   CALL i110_show()
   CALL i110_b_fill(g_wc2)
   CALL i110_bp_refresh()
 
END FUNCTION   
 
FUNCTION i110_copy()
DEFINE l_newno     LIKE pnz_file.pnz01,
       l_oldno     LIKE pnz_file.pnz01,
       l_cnt       LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pnz.pnz01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i110_set_entry('a')
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM pnz01
 
       AFTER FIELD pnz01
          IF l_newno IS NOT NULL THEN                                          
              SELECT count(*) INTO l_cnt FROM pnz_file                          
                  WHERE pnz01 = l_newno                                         
              IF l_cnt > 0 THEN                                                 
                 CALL cl_err(l_newno,-239,0)                                    
                 NEXT FIELD pnz01                                              
              END IF                                                                                                                        
           END IF                       
 
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()   
 
     ON ACTION help      
        CALL cl_show_help() 
 
     ON ACTION controlg    
        CALL cl_cmdask()  
 
 
   END INPUT
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_pnz.pnz01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM pnz_file         
    WHERE pnz01=g_pnz.pnz01
     INTO TEMP y
 
   UPDATE y
      SET pnz01=l_newno 
 
   INSERT INTO pnz_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pnz_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM pnq_file         
    WHERE pnq01=g_pnz.pnz01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET pnq01=l_newno
 
   INSERT INTO pnq_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pnq_file","","",SQLCA.sqlcode,"","",1) #No.FUN-B80088---上移一行調整至回滾事務前---
      ROLLBACK WORK 
      RETURN
   ELSE
      COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pnz.pnz01
   SELECT pnz_file.* INTO g_pnz.* FROM pnz_file WHERE pnz01 = l_newno
   CALL i110_u()
   CALL i110_b()
   #SELECT pnz_file.* INTO g_pnz.* FROM pnz_file WHERE pnz01 = l_oldno  #FUN-C80046
   #CALL i110_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION i110_show()
 
   LET g_pnz_t.*=g_pnz.*
    DISPLAY BY NAME g_pnz.pnz01,g_pnz.pnz02,
#                    g_pnz.pnz04,g_pnz.pnz05
                    g_pnz.pnz04,g_pnz.pnz05,g_pnz.pnz06,g_pnz.pnz07,g_pnz.pnz08   #FUN-A80104 #FUN-B50150  add pnz07  #FUN-C40089 add pnz08
    CALL i110_b_fill(g_wc2)
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i110_fetch(p_flpnz)
DEFINE p_flpnz         LIKE type_file.chr1   
        
    CASE p_flpnz
        WHEN 'N' FETCH NEXT     i110_cs INTO g_pnz.pnz01
        WHEN 'P' FETCH PREVIOUS i110_cs INTO g_pnz.pnz01
        WHEN 'F' FETCH FIRST    i110_cs INTO g_pnz.pnz01
        WHEN 'L' FETCH LAST     i110_cs INTO g_pnz.pnz01
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
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
                   LET g_jump = g_curs_index
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i110_cs INTO g_pnz.pnz01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pnz.pnz01,SQLCA.sqlcode,0)
        INITIALIZE g_pnz.* TO NULL  
        RETURN
    ELSE
      CASE p_flpnz
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_pnz.* FROM pnz_file    
     WHERE pnz01 = g_pnz.pnz01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pnz_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        CALL i110_show()                   
    END IF
END FUNCTION
 
FUNCTION i110_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_pnq.clear()      
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt
    
    CALL i110_b_askkey()              
            
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_pnz.* TO NULL
        CALL g_pnq.clear()
        RETURN
    END IF
    
    OPEN i110_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_pnq.clear()
    ELSE
        OPEN i110_count
        FETCH i110_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt                                 
           CALL i110_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
        END IF             
    END IF
END FUNCTION
 
FUNCTION i110_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_pnz.pnz01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_pnz.* FROM pnz_file
    WHERE pnz01=g_pnz.pnz01
 
   BEGIN WORK
 
   OPEN i110_cl USING g_pnz.pnz01
   IF STATUS THEN
      CALL cl_err("OPEN i110_cl:", STATUS, 1)
      CLOSE i110_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i110_cl INTO g_pnz.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pnz.pnz01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i110_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL                  #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pnz01"                 #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pnz.pnz01              #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                                    #No.FUN-9B0098 10/02/24
      DELETE FROM pnz_file WHERE pnz01 = g_pnz.pnz01
      DELETE FROM pnq_file WHERE pnq01 = g_pnz.pnz01
      CLEAR FORM
      CALL g_pnq.clear()
      OPEN i110_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i110_cs
          CLOSE i110_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
      FETCH i110_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i110_cs
          CLOSE i110_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i110_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i110_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL i110_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE i110_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i110_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM pnq_file
    WHERE pnq01 = g_pnz.pnz01
   IF g_cnt = 0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM pnz_file WHERE pnz01 = g_pnz.pnz01
   END IF
END FUNCTION
 
FUNCTION i110_bp_refresh()
 
  DISPLAY ARRAY g_pnq TO s_pnq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
#No.FUN-870007--end--
#FUN-A80104----ADD----
#判斷每組的最小順序是否為A類價格代碼
FUNCTION i110_first_a() 
DEFINE l_n        LIKE type_file.num5
#DEFINE l_rzz03    LIKE rzz_file.rzz03  #FUN-AB0053 mark
DEFINE l_type    LIKE type_file.chr1   #FUN-AB0053 add
 
   LET g_errno = ' '
   IF cl_null(g_pnq[l_ac].pnq02) OR 
      cl_null(g_pnq[l_ac].pnq03) OR
      cl_null(g_pnq[l_ac].pnq04) THEN 
      RETURN 
   END IF 
   SELECT MIN(pnq02) INTO l_n FROM pnq_file 
       WHERE pnq01 = g_pnz.pnz01
         AND pnq04 = g_pnq[l_ac].pnq04   
         AND pnq02 < g_pnq[l_ac].pnq02   
        
   IF l_n IS NULL THEN LET l_n = 0 END IF
   #l_n=0表示每組新增的第一個順序
   IF l_n = 0 OR l_n = g_pnq[l_ac].pnq02 THEN
      LET l_type = g_pnq[l_ac].type
      IF l_type IS NULL THEN LET l_type = ' ' END IF
      IF l_type <> 'A' THEN LET g_errno = 'axm-523' END IF
   END IF
   #MOD-B10188--add--str--
   SELECT MIN(pnq02) INTO l_n FROM pnq_file
    WHERE pnq01 = g_pnz.pnz01
      AND pnq04 = g_pnq[l_ac].pnq04
   IF l_n <> 0 THEN
      IF g_pnq[l_ac].pnq02 < l_n AND g_pnq[l_ac].pnq03 MATCHES "C*" THEN
         LET g_errno = 'axm-523'
      END IF
   END IF
   #MOD-B10188--add--end--
END FUNCTION
#FUN-A80104---
#MOD-B10188--add--str--
FUNCTION i110_check(p_cmd)
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE p_cmd      LIKE type_file.chr1

   LET g_errno = ' '
   IF cl_null(g_pnq[l_ac].pnq02) OR
      cl_null(g_pnq[l_ac].pnq03) OR
      cl_null(g_pnq[l_ac].pnq04) THEN
      RETURN
   END IF
   #檢查每組必須且只能具有一筆A類的類的資料
   SELECT COUNT(*) INTO l_n FROM pnq_file
    WHERE pnq01 = g_pnz.pnz01
      AND pnq04 = g_pnq[l_ac].pnq04
      AND pnq03 LIKE 'A%'
   IF l_n IS NULL THEN LET l_n = 0 END IF

#MOD-B30097------------modify---begin------------
   IF g_pnq[l_ac].pnq03 MATCHES "A*"  AND l_n >0 THEN
      IF g_pnq[l_ac].pnq03 <> g_pnq_t.pnq03 
         AND g_pnq_t.pnq03 MATCHES "A*" THEN   #TQC-B50137
         LET g_errno = ''                  #TQC-B50137
      ELSE                                 #TQC-B50137
         LET g_errno = 'axm-264'
      END IF                               #TQC-B50137
   END IF
#MOD-B30097------------end---------------------
END FUNCTION

FUNCTION i110_check_a()
DEFINE l_pnq04    LIKE pnq_file.pnq04   
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
 
   #檢查每組必須且只能具有一筆A類的類的資料
   LET l_sql = "SELECT pnq04 FROM pnq_file ",
               " WHERE pnq01 = '",g_pnz.pnz01,"'",
               " GROUP BY pnq04 "
   PREPARE pre_sel_pnqa FROM l_sql
   DECLARE cur_pnqa CURSOR FOR pre_sel_pnqa
 
   FOREACH cur_pnqa INTO l_pnq04
      IF SQLCA.SQLCODE THEN
         CALL cl_err('',SQLCA.SQLCODE,1)
         RETURN FALSE
      END IF
      SELECT COUNT(*) INTO l_n FROM pnq_file  
       WHERE pnq01 = g_pnz.pnz01
         AND pnq04 = l_pnq04
         AND pnq03 LIKE 'A%'
      IF l_n IS NULL THEN LET l_n = 0 END IF
      IF l_n <> 1 THEN RETURN FALSE END IF
   END FOREACH 
   RETURN TRUE
END FUNCTION
#MOD-B10188--add--end--
