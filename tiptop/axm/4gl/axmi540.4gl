# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: axmi540.4gl
# Descriptions...: 客戶產品折扣檔  
# Date & Author..: 02/08/23 by WINDY
 # Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 結束位置調整
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-740135 07/04/23 By arman   更改‘折扣’欄位為顯示3位小數
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_xmh           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        xmh01       LIKE xmh_file.xmh01,  
        oca02       LIKE oca_file.oca02,
        xmh02       LIKE xmh_file.xmh02, 
        oba02       LIKE oba_file.oba02,
        xmh03       LIKE xmh_file.xmh03,
        xmh04       LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
                    END RECORD,
    g_xmh_t         RECORD                 #程式變數 (舊值)
        xmh01       LIKE xmh_file.xmh01, 
        oca02       LIKE oca_file.oca02,
        xmh02       LIKE xmh_file.xmh02,
        oba02       LIKE oba_file.oba02,
        xmh03       LIKE xmh_file.xmh03,
        xmh04       LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
                    END RECORD,
     g_wc2,g_sql    STRING, #No.FUN-580092 HCN   
    g_rec_b         LIKE type_file.num5,   #單身筆數             #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680137 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose#No.FUN-680137 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5        #No.FUN-570109       #No.FUN-680137 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0094
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)           #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET p_row = 4 LET p_col = 6
 
    OPEN WINDOW i540_w AT p_row,p_col 
         WITH FORM "axm/42f/axmi540"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
         
    LET g_wc2 = '1=1' 
    CALL i540_b_fill(g_wc2)
    CALL i540_menu()
    CLOSE WINDOW i540_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i540_menu()
   WHILE TRUE
      CALL i540_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i540_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i540_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               CALL i540_out()
            END IF                  
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_xmh),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i540_q()
   CALL i540_b_askkey()
END FUNCTION
 
FUNCTION i540_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT xmh01,'',xmh02,'',xmh03,xmh04 FROM xmh_file WHERE xmh01=? AND xmh02=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i540_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_xmh WITHOUT DEFAULTS FROM s_xmh.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
               LET p_cmd='u'
               LET g_xmh_t.* = g_xmh[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i540_set_entry_b(p_cmd)                                                                                         
               CALL i540_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--                  
            BEGIN WORK
 
               OPEN i540_bcl USING g_xmh_t.xmh01,g_xmh_t.xmh02
               IF STATUS THEN
                  CALL cl_err("OPEN i540_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i540_bcl INTO g_xmh[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_xmh_t.xmh01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i540_xmh01('d')
                  CALL i540_xmh02('d') 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO xmh_file(xmh01,xmh02,xmh03,xmh04,
                                 xmhuser,xmhgrup,xmhmodu,xmhdate,xmhoriu,xmhorig)
                          VALUES(g_xmh[l_ac].xmh01,g_xmh[l_ac].xmh02,
                                 g_xmh[l_ac].xmh03,g_xmh[l_ac].xmh04,
                                 g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_xmh[l_ac].xmh01,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","xmh_file",g_xmh[l_ac].xmh01,g_xmh[l_ac].xmh02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
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
            LET g_before_input_done = FALSE                                                                                      
            CALL i540_set_entry_b(p_cmd)                                                                                         
            CALL i540_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--                  
            INITIALIZE g_xmh[l_ac].* TO NULL      #900423
            LET g_xmh[l_ac].xmh03=100
            LET g_xmh[l_ac].xmh04='Y'
            LET g_xmh_t.* = g_xmh[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD xmh01
            
        BEFORE FIELD xmh02
            IF NOT cl_null(g_xmh[l_ac].xmh01) THEN
               IF p_cmd = 'a' OR (p_cmd = 'u' AND
                  g_xmh[l_ac].xmh01 != g_xmh_t.xmh01) THEN
                  CALL i540_xmh01('d')
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err(g_xmh[l_ac].xmh01,g_errno,0) NEXT FIELD xmh01
                  END IF
               END IF
            END IF
 
        AFTER FIELD xmh02                        
            IF NOT cl_null(g_xmh[l_ac].xmh02) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               g_xmh[l_ac].xmh02 != g_xmh_t.xmh02) THEN
               CALL i540_xmh02('d')
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_xmh[l_ac].xmh02,g_errno,0) NEXT FIELD xmh02
               END IF
               SELECT COUNT(*) INTO l_n FROM xmh_file                          
                WHERE xmh01 = g_xmh[l_ac].xmh01
                  AND xmh02 = g_xmh[l_ac].xmh02
               IF l_n > 0 THEN                                                 
                  CALL cl_err('',-239,0)                                      
                  LET g_xmh[l_ac].xmh01 = g_xmh_t.xmh01
                  LET g_xmh[l_ac].xmh02 = g_xmh_t.xmh02                       
                  LET g_xmh[l_ac].oca02 = ""
                  NEXT FIELD xmh01
               END IF
            END IF 
            END IF 
 
        AFTER FIELD xmh03
            IF NOT cl_null(g_xmh[l_ac].xmh03) THEN
               IF g_xmh[l_ac].xmh03 <= 0 OR g_xmh[l_ac].xmh03 > 100 THEN
                  CALL cl_err(g_xmh[l_ac].xmh03,'mfg1332',0) 
                  NEXT FIELD xmh03
               END IF 
            END IF 
                
        BEFORE DELETE                            #是否取消單身
            IF g_xmh_t.xmh01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               
                DELETE FROM xmh_file
                 WHERE xmh01 = g_xmh_t.xmh01 AND xmh02 = g_xmh_t.xmh02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_xmh_t.xmh01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","xmh_file",g_xmh_t.xmh01,g_xmh_t.xmh02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i540_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_xmh[l_ac].* = g_xmh_t.*
               CLOSE i540_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_xmh[l_ac].xmh01,-263,1)
               LET g_xmh[l_ac].* = g_xmh_t.*
            ELSE
               UPDATE xmh_file SET xmh01=g_xmh[l_ac].xmh01,
                                   xmh02=g_xmh[l_ac].xmh02,
                                   xmh03=g_xmh[l_ac].xmh03,
                                   xmh04=g_xmh[l_ac].xmh04,
                                   xmhmodu=g_user,
                                   xmhdate=g_today
                WHERE xmh01 = g_xmh_t.xmh01
                  AND xmh02 = g_xmh_t.xmh02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_xmh[l_ac].xmh01,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","xmh_file",g_xmh_t.xmh01,g_xmh_t.xmh02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_xmh[l_ac].* = g_xmh_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i540_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_xmh[l_ac].* = g_xmh_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_xmh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i540_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i540_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
           CALL i540_b_askkey()
           EXIT INPUT
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(xmh01)     
#                CALL q_oca(10,3,g_xmh[l_ac].xmh01) 
#                     RETURNING g_xmh[l_ac].xmh01
#                CALL FGL_DIALOG_SETBUFFER( g_xmh[l_ac].xmh01 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oca"
                 LET g_qryparam.default1 = g_xmh[l_ac].xmh01
                 CALL cl_create_qry() RETURNING g_xmh[l_ac].xmh01
#                 CALL FGL_DIALOG_SETBUFFER( g_xmh[l_ac].xmh01 )
                   DISPLAY BY NAME g_xmh[l_ac].xmh01      #No.MOD-490371
                 NEXT FIELD xmh01
              WHEN INFIELD(xmh02)                                     
#                CALL q_oba(10,3,g_xmh[l_ac].xmh02)      
#                     RETURNING g_xmh[l_ac].xmh02                     
#                CALL FGL_DIALOG_SETBUFFER( g_xmh[l_ac].xmh02 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oba"
                 LET g_qryparam.default1 = g_xmh[l_ac].xmh02
                 CALL cl_create_qry() RETURNING g_xmh[l_ac].xmh02   
#                 CALL FGL_DIALOG_SETBUFFER( g_xmh[l_ac].xmh02 )
                   DISPLAY BY NAME g_xmh[l_ac].xmh01      #No.MOD-490371
                 NEXT FIELD xmh02
              OTHERWISE
                 EXIT CASE
           END CASE
 
                                                 #modified by windy 
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
 
    CLOSE i540_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION  i540_xmh01(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT oca02 INTO g_xmh[l_ac].oca02 FROM oca_file  
     WHERE oca01 = g_xmh[l_ac].xmh01
    CASE WHEN SQLCA.SQLCODE = 100  
           LET g_errno = SQLCA.SQLCODE
           LET g_xmh[l_ac].oca02 = NULL
         OTHERWISE       
           LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION  i540_xmh02(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT oba02 INTO g_xmh[l_ac].oba02 FROM oba_file  
     WHERE oba01 = g_xmh[l_ac].xmh02
    CASE WHEN SQLCA.SQLCODE = 100 
           LET g_errno = SQLCA.SQLCODE
           LET g_xmh[l_ac].oba02 = NULL
         OTHERWISE 
           LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i540_b_askkey()
    CLEAR FORM
    CALL g_xmh.clear()
    CONSTRUCT g_wc2 ON xmh01,xmh02,xmh03,xmh04
         FROM s_xmh[1].xmh01,s_xmh[1].xmh02,s_xmh[1].xmh03,s_xmh[1].xmh04
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(xmh01)     
#                CALL q_oca(10,3,g_xmh[1].xmh01) 
#                     RETURNING g_xmh[1].xmh01
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oca"
                 LET g_qryparam.default1 = g_xmh[1].xmh01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO xmh01      #No.MOD-490371
                 NEXT FIELD xmh01
              WHEN INFIELD(xmh02)                                     
#                CALL q_oba(10,3,g_xmh[1].xmh02)      
#                     RETURNING g_xmh[1].xmh02                     
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oba"
                 LET g_qryparam.default1 = g_xmh[1].xmh02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO xmh02       #No.MOD-490371
                 NEXT FIELD xmh02
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
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('xmhuser', 'xmhgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i540_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i540_b_fill(g_wc2)              #BODY FILL UP
DEFINE
     g_wc2     STRING   #No.FUN-580092 HCN   
 
    LET g_sql =
        "SELECT xmh01,oca02,xmh02,oba02,xmh03,xmh04",
        "  FROM xmh_file LEFT OUTER JOIN oca_file ON xmh_file.xmh01=oca_file.oca01 LEFT OUTER JOIN oba_file ON xmh_file.xmh02=oba_file.oba01",
        " WHERE  ",
        "   ", g_wc2 CLIPPED,   #單身
        " ORDER BY 1,3"
     
    PREPARE i540_pb FROM g_sql
    DECLARE xmh_curs CURSOR FOR i540_pb
 
    CALL g_xmh.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH xmh_curs INTO g_xmh[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
     
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    
    END FOREACH
    CALL g_xmh.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i540_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_xmh TO s_xmh.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
   ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-7C0043--start--
FUNCTION i540_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
        sr              RECORD
                        xmh    RECORD LIKE xmh_file.*,
                        oca02  LIKE oca_file.oca02,
                        oba02  LIKE oba_file.oba02
                        END RECORD
 DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                    
                                                                                                                                    
    IF g_wc2 IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0) RETURN END IF                                                                                       
    LET l_cmd = 'p_query "axmi540" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN  
#   IF g_wc2 IS NULL THEN 
#      CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT xmh_file.*,oca02,oba02 ",
#             "  FROM xmh_file LEFT OUTER JOIN oca_file ON xmh_file.xmh01=oca_file.oca01 LEFT OUTER JOIN oba_file ON xmh_file.xmh02=oba_file.oba01 ",
#             " WHERE ",
#             "   ",g_wc2 CLIPPED
#   PREPARE i540_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i540_co                         # CURSOR
#       CURSOR FOR i540_p1
 
#   LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi540') RETURNING l_name         #FUN-4C0096 add
#   START REPORT i540_rep TO l_name
 
#   FOREACH i540_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i540_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i540_rep
 
#   CLOSE i540_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i540_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680137  VARCHAR(1)
#       sr              RECORD
#                       xmh    RECORD LIKE xmh_file.*,
#                       oca02  LIKE oca_file.oca02,
#                       oba02  LIKE oba_file.oba02
#                       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
#   ORDER BY sr.xmh.xmh01,sr.xmh.xmh02
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           #PRINT ''   #No.TQC-6A0091
 
#           PRINT g_dash
#           PRINT g_x[31], 
#                 g_x[32],
#                 g_x[33],
#                 g_x[34],
#                 g_x[35],
#                 g_x[36]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           IF sr.xmh.xmh04 = 'N' THEN 
#             PRINT COLUMN g_c[31],'N';
#           ELSE 
#             PRINT COLUMN g_c[31],' ';
#           END IF 
 
#           PRINT COLUMN g_c[32],sr.xmh.xmh01,
#                 COLUMN g_c[33],sr.oca02,
#                 COLUMN g_c[34],sr.xmh.xmh02,
#                 COLUMN g_c[35],sr.oba02,
#                 COLUMN g_c[36],sr.xmh.xmh03 USING '#####&.###'   #No.TQC-740135
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5B0212
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5B0212
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--
#No.FUN-570109 --start--                                                                                                            
FUNCTION i540_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("xmh01,xmh02",TRUE)                                                                                     
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i540_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("xmh01,xmh02",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--      
