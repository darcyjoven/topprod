# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: s_i200tr.4gl
# Descriptions...: 倉管員限定資料維護作業
# Date & Author..: NO.FUN-930108 09/03/17 By zhaijie 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0209 10/11/29 By vealxu aimi200倉管員 目前控管了zx_file的資料，請改成跟gen_file關聯
# Modify.........: No.TQC-AC0253 10/12/17 还原No.TQC-AB0209 
#                  因為後端所有作業對倉庫權限的處理均是根據zx_file來的，改成gen_file就不能做後續操作了
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_imd        RECORD LIKE imd_file.*
DEFINE 
    g_inc           DYNAMIC ARRAY OF RECORD          #程式變數(Program Variables)
        inc03       LIKE inc_file.inc03,             #no
        zx02        LIKE zx_file.zx02              #name    #TQC-AB0209
       #gen02       LIKE gen_file.gen02                     #TQC-AB0209  #ReMod No.TQC-AC0253
                    END RECORD,
    g_inc_t         RECORD                           #程式變數 (舊值)
        inc03       LIKE inc_file.inc03,             #no
        zx02        LIKE zx_file.zx02              #name  #TQC-AB0209
       #gen02       LIKE gen_file.gen02                     #TQC-AB0209  #ReMod No.TQC-AC0253
                    END RECORD,
    g_rec_b             LIKE type_file.num5,         #單身筆數 
    l_ac                LIKE type_file.num5          #目前處理的ARRAY CNT SMALLINT
DEFINE   g_forupd_sql   STRING
DEFINE   g_sql          STRING
DEFINE   g_before_input_done  LIKE type_file.num5    # SMALLINT
DEFINE   g_cnt          LIKE type_file.num10         # INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       # VARCHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10         #INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #INTEGER
DEFINE   g_jump         LIKE type_file.num10         #INTEGER
DEFINE   g_no_ask       LIKE type_file.num5
DEFINE   g_imd01        LIKE imd_file.imd01          #倉庫編號
DEFINE   g_inc02        LIKE inc_file.inc02          #儲位
 
#FUN-930108 新增
FUNCTION s_i200tr(p_argv1)
DEFINE   p_argv1        LIKE inc_file.inc01          #倉庫編號
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   OPEN WINDOW aimi200_a AT 19,18 WITH FORM "aim/42f/aimi200_a"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_locale("aimi200_a")
   LET g_imd01 = p_argv1 
   LET g_inc02 = ' ' 
   SELECT * INTO g_imd.* FROM imd_file WHERE imd01 = p_argv1
 
   CALL i200tr_b_fill()
   CALL i200tr_menu()
   CLOSE WINDOW aimi200_a
END FUNCTION
 
FUNCTION i200tr_menu()
   WHILE TRUE
     CALL i200tr_bp("G")
     CASE g_action_choice
        WHEN "help"                                                                                                                
            CALL cl_show_help()                                                                                                     
        WHEN "detail"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i200tr_b()                                                                                                        
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
 
FUNCTION i200tr_b()
DEFINE
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
   l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680135 SMALLINT
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680135 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680135 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,      #可新增否          #No.FUN-680135 SMALLINT
   l_allow_delete  LIKE type_file.num5       #可刪除否          #No.FUN-680135 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF           #檢查權限
   IF g_imd01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT inc03,'' FROM inc_file",
                      " WHERE inc01=? AND inc02 = ? AND inc03 = ? FOR UPDATE"   #FUN-930108未加儲位條件
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i200tr_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_inc WITHOUT DEFAULTS FROM s_inc.*
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
            LET g_inc_t.* = g_inc[l_ac].*      #BACKUP
            LET p_cmd='u'
            OPEN i200tr_bcl USING g_imd01,g_inc02,g_inc_t.inc03
            IF STATUS THEN
               CALL cl_err("OPEN i200tr_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i200tr_bcl INTO g_inc[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_inc_t.inc03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
              #ReMod No.TQC-AC0253
              #TQC-AB0209 -----------mark start-----------
               SELECT zx02 INTO g_inc[l_ac].zx02
                 FROM zx_file
                WHERE zx01 = g_inc[l_ac].inc03
              #SELECT gen02 INTO g_inc[l_ac].gen02
              #  FROM gen_file
              # WHERE gen01 = g_inc[l_ac].inc03
              #TQC-AB0209 -----------mark end--------- 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO inc_file(inc01,inc02,inc03)
                       VALUES(g_imd01,g_inc02,g_inc[l_ac].inc03)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","inc_file",g_imd01,g_inc[l_ac].inc03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cnt  
            COMMIT WORK
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_inc[l_ac].* TO NULL  
         LET g_inc_t.* = g_inc[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD inc03
 
      BEFORE FIELD inc03                        #default 序號
         IF cl_null(g_inc[l_ac].inc03) THEN
            LET g_inc[l_ac].inc03=""
         ELSE
        #    IF g_rec_b < 2 THEN
        #       DISPLAY g_inc[l_ac].inc03 TO inc03
        #    END IF 
         END IF 
 
      AFTER FIELD inc03                        #check inc03是否重複
         IF NOT cl_null(g_inc[l_ac].inc03) THEN 
           #Remod No.TQC-AC0253
            SELECT zx02 INTO g_inc[l_ac].zx02 FROM zx_file      #TQC-AB0209        
             WHERE zx01 = g_inc[l_ac].inc03                     #TQC-AB020
           #SELECT gen02 INTO g_inc[l_ac].gen02 FROM gen_file           #TQC-AB0209
           # WHERE gen01 = g_inc[l_ac].inc03                           #TQC-AB0209
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","zx_file",g_inc[l_ac].inc03,"",SQLCA.sqlcode,"","Plant No.",1)    #No.FUN-660081   #TQC-AB0209 mod zx_file->gen_file  #No.TQC-AC0253 gen_file->zx_file
               NEXT FIELD inc03 
            END IF
         END IF
 
         IF g_inc[l_ac].inc03 != g_inc_t.inc03 OR g_inc_t.inc03 IS NULL THEN
            SELECT count(*) INTO l_n FROM inc_file
             WHERE inc01 = g_imd01
               AND inc02 = g_inc02
               AND inc03 = g_inc[l_ac].inc03
            IF l_n > 0 THEN
               CALL cl_err(g_inc[l_ac].inc03,-239,0)
               LET g_inc[l_ac].inc03 = g_inc_t.inc03
               NEXT FIELD inc03
            END IF
         END IF
          
      BEFORE DELETE
         IF g_inc_t.inc03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM inc_file
             WHERE inc01 = g_imd01 
               AND inc03 = g_inc_t.inc03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","inc_file",g_imd01,g_inc_t.inc03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK 
               CANCEL DELETE 
            END IF
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cnt  
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_inc[l_ac].* = g_inc_t.*
            CLOSE i200tr_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_inc[l_ac].inc03,-263,1)
            LET g_inc[l_ac].* = g_inc_t.*
         ELSE
            UPDATE inc_file SET inc03 = g_inc[l_ac].inc03
             WHERE inc01=g_imd01
               AND inc02=g_inc02
               AND inc03=g_inc_t.inc03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","inc_file",g_imd01,g_inc_t.inc03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_inc[l_ac].* = g_inc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_inc[l_ac].* = g_inc_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_inc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i200tr_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D40030 Add
         CLOSE i200tr_bcl
         COMMIT WORK
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(inc03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zx"     #TQC-AB0209
              #LET g_qryparam.form ="q_gen"    #TQC-AB0209  #ReMod No.TQC-AC0253
               LET g_qryparam.default1 = g_inc[l_ac].inc03
               CALL cl_create_qry() RETURNING g_inc[l_ac].inc03
               DISPLAY g_inc[l_ac].inc03 TO inc03
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
 
   CLOSE i200tr_bcl
   COMMIT WORK
        
END FUNCTION
   
FUNCTION i200tr_b_fill()              #BODY FILL UP
 
  #ReMod No.TQC-AC0253
   LET g_sql = "SELECT inc03,zx02 ",     #TQC-AB0209
  #LET g_sql = "SELECT inc03,gen02 ",    #TQC-AB0209
               " FROM inc_file,zx_file ",   #TQC-AB0209   mod zx_file-> gen_file
               " WHERE inc03 = zx01 ",      #TQC-AB0209   mod zx01 - > gen01              
               " AND inc01 = '",g_imd01 CLIPPED,"' ",
               #" AND inc02 = '",g_inc02 CLIPPED,"' ",
               " AND inc02 = '",g_inc02,"' ",
               " ORDER BY 1"
   PREPARE inc_pre2 FROM g_sql      #預備一下
   DECLARE inc_cs CURSOR FOR inc_pre2
      
   CALL g_inc.clear() 
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH inc_cs INTO g_inc[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_inc.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i200tr_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_inc TO s_inc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()
 
        ON ACTION detail
           LET g_action_choice="detail"    
           LET l_ac = 1
           EXIT DISPLAY
 
        ON ACTION help
           LET g_action_choice="help"      
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont() 
           EXIT DISPLAY
 
        #ON ACTION output
        #   LET g_action_choice="output"
        #   EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit" 
           EXIT DISPLAY
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
     
        ON ACTION cancel
           LET INT_FLAG=FALSE 
           LET g_action_choice="exit"
           EXIT DISPLAY
       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
