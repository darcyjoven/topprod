# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: aqci102.4gl
# Descriptions...: 不良原因資料維護
# Date & Author..: 99/05/10 By Melody
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/12 By kim 報表轉XML功能
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.TQC-5B0034 05/11/07 By Rosayu 修改報表結束位置
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/17 By Sunyanchun  老報表改成p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A60132 10/07/19 By chenmoyan 鎖表語句不標準
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_qce           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        qce01       LIKE qce_file.qce01,        #部門編號
        qce03       LIKE qce_file.qce03,        #全名
        qceacti     LIKE type_file.chr1         #No.FUN-680104 VARCHAR(1)
                    END RECORD,
    g_qce_t         RECORD                      #程式變數 (舊值)
        qce01       LIKE qce_file.qce01,        #部門編號
        qce03       LIKE qce_file.qce03,        #全名
        qceacti     LIKE type_file.chr1         #No.FUN-680104 VARCHAR(1)
                    END RECORD,
    g_wc2,g_sql     STRING,                     #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,        #單身筆數        #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_sl            LIKE type_file.num5         #No.FUN-680104 SMALLINT #目前處理的SCREEN LINE
DEFINE   g_forupd_sql    LIKE type_file.chr1000  #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680104 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5        #FUN-570109        #No.FUN-680104 SMALLINT
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("AQC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0085

    OPEN WINDOW i102_w WITH FORM "aqc/42f/aqci102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i102_b_fill(g_wc2)
    CALL i102_menu()

    CLOSE WINDOW i102_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0085
END MAIN
 
FUNCTION i102_menu()
DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043   add
   WHILE TRUE
      CALL i102_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i102_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i102_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL i102_out()                        
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qce),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i102_q()
   CALL i102_b_askkey()
END FUNCTION
 
FUNCTION i102_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用 #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否 #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態 #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,      #No.FUN-680104 VARCHAR(1) #可新增否
    l_allow_delete  LIKE type_file.chr1       #No.FUN-680104 VARCHAR(1) #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT qce01,qce03,qceacti ",
#                       "UPLOCK FROM qce_file WHERE qce01=?  ",#TQC-A60132
                        "  FROM qce_file WHERE qce01=?  ",     #TQC-A60132
                          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_qce WITHOUT DEFAULTS FROM s_qce.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
                BEGIN WORK
                LET p_cmd='u'
                LET g_qce_t.* = g_qce[l_ac].*  #BACKUP
#No.FUN-570109 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i102_set_entry(p_cmd)                                      
                CALL i102_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570109 --end                 
                OPEN i102_bcl USING g_qce_t.qce01
                IF STATUS THEN
                   CALL cl_err("OPEN i102_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i102_bcl INTO g_qce[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_qce_t.qce01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i102_set_entry(p_cmd)                                          
            CALL i102_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570109 --end                               
            INITIALIZE g_qce[l_ac].* TO NULL      #900423
            LET g_qce[l_ac].qceacti = 'Y'         #Body default
            LET g_qce_t.* = g_qce[l_ac].*         #新輸入資料
            DISPLAY g_qce[l_ac].* TO s_qce[l_sl].* 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qce01
 
        AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i102_bcl
#            CALL g_qce.deleteElement(l_ac)
#           IF g_rec_b != 0 THEN
#              LET g_action_choice = "detail"
#              LET l_ac = l_ac_t
#           END IF
#           EXIT INPUT
         END IF
         INSERT INTO qce_file(qce01,qce02,qce03,qceacti,qceuser,qcedate,qceoriu,qceorig)
                       VALUES(g_qce[l_ac].qce01,' ',g_qce[l_ac].qce03,
                              g_qce[l_ac].qceacti, g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN 
#           CALL cl_err(g_qce[l_ac].qce01,SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("ins","qce_file",g_qce[l_ac].qce01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD qce01                        #check 編號是否重複
            IF g_qce[l_ac].qce01 != g_qce_t.qce01 OR
               (g_qce[l_ac].qce01 IS NOT NULL AND g_qce_t.qce01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM qce_file
                 WHERE qce01 = g_qce[l_ac].qce01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_qce[l_ac].qce01 = g_qce_t.qce01
                   NEXT FIELD qce01
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
             IF g_qce_t.qce01 IS NOT NULL THEN
               IF g_cnt = 0 THEN 
                IF NOT cl_delete() THEN
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM qce_file WHERE qce01 = g_qce_t.qce01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qce_t.qce01,SQLCA.sqlcode,0)   #No.FUN-660115
                   CALL cl_err3("del","qce_file",g_qce_t.qce01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i102_bcl
                COMMIT WORK
               ELSE 
                CLOSE i102_bcl
               END IF
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_qce[l_ac].* = g_qce_t.*
            CLOSE i102_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_qce[l_ac].qce01,-263,1)
             LET g_qce[l_ac].* = g_qce_t.*
         ELSE
             UPDATE qce_file
                SET qce01 = g_qce[l_ac].qce01,
                    qce02 = " ",
                    qce03 = g_qce[l_ac].qce03,
                    qceacti = g_qce[l_ac].qceacti,
                    qcemodu = g_user,
                    qcedate = g_today
              WHERE qce01=g_qce_t.qce01
 
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_qce[l_ac].qce01,SQLCA.sqlcode,0)   #No.FUN-660115
                CALL cl_err3("upd","qce_file",g_qce_t.qce01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
                LET g_qce[l_ac].* = g_qce_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i102_bcl
                COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qce[l_ac].* = g_qce_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qce.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i102_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i102_b_askkey()
#           LET l_exit_sw = "n"
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qce01) AND l_ac > 1 THEN
                LET g_qce[l_ac].* = g_qce[l_ac-1].*
                DISPLAY g_qce[l_ac].* TO s_qce[l_sl].* 
                NEXT FIELD qce01
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
 
    CLOSE i102_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i102_b_askkey()
    CLEAR FORM
   CALL g_qce.clear()
    CONSTRUCT g_wc2 ON qce01,qce03,qceacti
            FROM s_qce[1].qce01,s_qce[1].qce03,s_qce[1].qceacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('qceuser', 'qcegrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i102_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i102_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    LET g_sql =
        "SELECT qce01,qce03,qceacti",
        " FROM qce_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i102_pb FROM g_sql
    DECLARE qce_curs CURSOR FOR i102_pb
 
    CALL g_qce.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH qce_curs INTO g_qce[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_qce.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qce TO s_qce.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         EXIT DISPLAY
 
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
 
FUNCTION i102_out()
DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043   add 
#    DEFINE
#        l_qce           RECORD LIKE qce_file.*,
#        l_i             LIKE type_file.num5,        #No.FUN-680104 SMALLINT
#        l_name          LIKE type_file.chr20,       # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#        l_za05          LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(40)
     #FUN-7C0043---Begin
     IF g_wc2 IS NULL THEN                                                       
        CALL cl_err('','9057',0)                                                 
        RETURN                                                                   
     END IF                                                                      
     LET l_cmd = 'p_query "aqci102" "',g_wc2 CLIPPED,'"'             
     CALL cl_cmdrun(l_cmd)
     #FUN-7C0043----End    
#    IF g_wc2 IS NULL THEN 
#      CALL cl_err('',-400,0)
#       CALL cl_err('','9057',0)
#     RETURN 
#    END IF
#    CALL cl_wait()
#   LET l_name = 'aqci102.out'
#   CALL cl_outnam('aqci102') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM qce_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i102_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i102_co                         # SCROLL CURSOR
#       CURSOR FOR i102_p1
 
#   START REPORT i102_rep TO l_name
 
#   FOREACH i102_co INTO l_qce.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i102_rep(l_qce.*)
#   END FOREACH
 
#   FINISH REPORT i102_rep
 
#   CLOSE i102_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i102_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#       sr RECORD LIKE qce_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.qce01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT 
#           PRINT g_dash
#           PRINT g_x[31],g_x[32]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           IF sr.qceacti = 'N' THEN PRINT '*'; END IF
#           PRINT COLUMN g_c[31],sr.qce01,
#                 COLUMN g_c[32],sr.qce03
 
#       ON LAST ROW
#           PRINT g_dash
#           #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[32], g_x[7] CLIPPED  #TQC-5B0034 mark
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #TQC-5B0034 add
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[32], g_x[6] CLIPPED #TQC-5B0034 mark
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0034 add
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
 
#No.FUN-570109 --start                                                          
FUNCTION i102_set_entry(p_cmd)                                                  
 DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680104 VARCHAR(1)
                                                                               
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
    CALL cl_set_comp_entry("qce01",TRUE)                                       
  END IF                                                                       
END FUNCTION                                                                    
                                                                               
FUNCTION i102_set_no_entry(p_cmd)                                               
 DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680104 VARCHAR(1)
                                                                               
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
    CALL cl_set_comp_entry("qce01",FALSE)                                      
  END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570109 --end                                                            
                                        
