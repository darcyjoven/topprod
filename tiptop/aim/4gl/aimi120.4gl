# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aimi120.4gl
# Descriptions...: 料件分群碼基本資料維護作業 (只有二個欄位)
# Date & Author..: 92/03/28 By Lin
# Modify.........: 94/12/06 By Danny (將畫面改成多行式)
# Modify.........: No.MOD-480048 04/08/11 By Nicola IDLE 5秒會跳出
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510017 05/01/12 By Mandy 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By day    修正建檔程式key值是否可更改 
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VAR CHAR-> CHAR
# Modify.........: No.FUN-660078 06/06/13 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_imz          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
            imz01       LIKE imz_file.imz01,   
             imz02       LIKE imz_file.imz02,  
           # imzacti     LIKE type_file.chr1                 #FUN-660078 remark  #No.FUN-690026 VARCHAR(1)
            imzacti     LIKE imz_file.imzacti  #FUN-660078
                        END RECORD,
         g_imz_t        RECORD                     #程式變數 (舊值)
            imz01       LIKE imz_file.imz01,   
            imz02       LIKE imz_file.imz02,  
            #imzacti     LIKE type_file.chr1                 #FUN-660078 remark  #No.FUN-690026 VARCHAR(1)
            imzacti     LIKE imz_file.imzacti  #FUN-660078
                        END RECORD,
          #g_wc2,g_sql   LIKE type_file.chr1000,#TQC-5A0134 VAR CHAR-->CHAR   #TQC-630166  #No.FUN-690026 VARCHAR(300)
          g_wc2,g_sql   STRING, #TQC-5A0134 VAR CHAR-->CHAR   #TQC-630166
         g_rec_b        LIKE type_file.num5,                    #單身筆數  #No.FUN-690026 SMALLINT
         l_ac           LIKE type_file.num5                     #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE   p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
DEFINE   g_forupd_sql   STRING                     #SELECT ... FOR UPDATE SQL
 
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690026 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570110    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE   l_time   LIKE type_file.chr8       #No.FUN-6A0074
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
 
   LET p_row = 2 LET p_col = 15
 
   OPEN WINDOW i120_w AT p_row,p_col WITH FORM "aim/42f/aimi120"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i120_b_fill(g_wc2)
   CALL i120_menu()
   CLOSE WINDOW i120_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION i120_menu()
 
   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i120_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i120_out() 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"   
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imz),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i120_q()
   CALL i120_b_askkey()
END FUNCTION
 
FUNCTION i120_b()
   DEFINE   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
            l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690026 SMALLINT
            l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690026 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690026 VARCHAR(1)
            l_allow_insert  LIKE type_file.chr1,                #可新增否  #No.FUN-690026 VARCHAR(1)
            l_allow_delete  LIKE type_file.chr1                 #可刪除否  #No.FUN-690026 VARCHAR(1)
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT imz01,imz02,imzacti",
                      "  FROM imz_file",
                      " WHERE imz01 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      INPUT ARRAY g_imz WITHOUT DEFAULTS FROM s_imz.*
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
 
         IF g_rec_b>=l_ac THEN
#No.FUN-570110 --start--                                                                                                            
            LET p_cmd = 'u'                                                                                                     
            LET g_before_input_done = FALSE                                                                                     
            CALL i120_set_entry(p_cmd)                                                                                          
            CALL i120_set_no_entry(p_cmd)                                                                                       
            LET g_before_input_done = TRUE                                                                                      
#No.FUN-570110 --end-- 
            BEGIN WORK
            LET p_cmd='u'
            LET g_imz_t.* = g_imz[l_ac].*  #BACKUP
 
            OPEN i120_bcl USING g_imz_t.imz01
            IF STATUS THEN
               CALL cl_err("OPEN i120_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i120_bcl INTO g_imz[l_ac].* 
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_imz_t.imz01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start--                                                                                                            
         LET g_before_input_done = FALSE                                                                                     
         CALL i120_set_entry(p_cmd)                                                                                          
         CALL i120_set_no_entry(p_cmd)                                                                                       
         LET g_before_input_done = TRUE                                                                                      
#No.FUN-570110 --end-- 
         INITIALIZE g_imz[l_ac].* TO NULL      #900423
         LET g_imz_t.* = g_imz[l_ac].*         #新輸入資料
         LET g_imz[l_ac].imzacti='Y'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD imz01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i120_bcl
            CANCEL INSERT
         END IF
         INSERT INTO imz_file(imz01,imz02,imzacti,
                              imzuser,imzdate,imzoriu,imzorig)
         VALUES(g_imz[l_ac].imz01,g_imz[l_ac].imz02,
                g_imz[l_ac].imzacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_imz[l_ac].imz01,SQLCA.sqlcode,0) #No.FUN-660156 
            CALL cl_err3("ins","imz_file",g_imz[l_ac].imz01,g_imz[l_ac].imz02,
                          SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD imz01                        #check 編號是否重複
         IF g_imz[l_ac].imz01 IS NOT NULL THEN
            IF g_imz[l_ac].imz01 != g_imz_t.imz01 OR
               (g_imz[l_ac].imz01 IS NOT NULL AND g_imz_t.imz01 IS NULL) THEN
               SELECT count(*) INTO l_n FROM imz_file
                WHERE imz01 = g_imz[l_ac].imz01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_imz[l_ac].imz01 = g_imz_t.imz01
                  NEXT FIELD imz01
               END IF
            END IF
         END IF
 
      AFTER FIELD imzacti
         IF g_imz[l_ac].imzacti NOT MATCHES '[YN]' THEN
            NEXT FIELD imzacti
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_imz_t.imz01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
{ckp#1}     DELETE FROM imz_file WHERE imz01 = g_imz_t.imz01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_imz_t.imz01,SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("sel","imz_file",g_imz_t.imz01,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i120_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_imz[l_ac].* = g_imz_t.*
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_imz[l_ac].imz01,-263,1)
             LET g_imz[l_ac].* = g_imz_t.*
         ELSE
             UPDATE imz_file 
                SET imz01   = g_imz[l_ac].imz01,
                    imz02   = g_imz[l_ac].imz02,
                    imzacti = g_imz[l_ac].imzacti,
                    imzmodu = g_user,
                    imzdate = g_today
              WHERE imz01 = g_imz_t.imz01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_imz[l_ac].imz01,SQLCA.sqlcode,0) #No.FUN-660156
                CALL cl_err3("upd","imz_file",g_imz_t.imz01,"",
                              SQLCA.sqlcode,"","",1)  #No.FUN-660156
                LET g_imz[l_ac].* = g_imz_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i120_bcl
                COMMIT WORK
             END IF
         END IF
 
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac                #FUN-D40030 Mark
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
           #IF p_cmd = 'a' THEN           #FUN-D40030 Mark
            IF p_cmd = 'u' THEN           #FUN-D40030 Add 
               LET g_imz[l_ac].* = g_imz_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_imz.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac                #FUN-D40030 Add
         CLOSE i120_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(imz01) AND l_ac > 1 THEN
             LET g_imz[l_ac].* = g_imz[l_ac-1].*
             NEXT FIELD imz01
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
 
   CLOSE i120_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i120_b_askkey()
   CLEAR FORM
   CALL g_imz.clear()
   CONSTRUCT g_wc2 ON imz01,imz02,imzacti
        FROM s_imz[1].imz01,s_imz[1].imz02,s_imz[1].imzacti
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('imzuser', 'imzgrup') #FUN-980030
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
   CALL i120_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i120_b_fill(p_wc2)              #BODY FILL UP
   DEFINE   p_wc2   LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
 
   LET g_sql =
       "SELECT imz01,imz02,imzacti",
       " FROM imz_file",
       " WHERE ", p_wc2 CLIPPED,                     #單身
       " ORDER BY 1"
   PREPARE i120_pb FROM g_sql
   DECLARE imz_curs CURSOR FOR i120_pb
 
   CALL g_imz.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH imz_curs INTO g_imz[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imz.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 #   LET g_idle_seconds = 5    #No.MOD-480048 Mark
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imz TO s_imz.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION exporttoexcel #FUN-4B0002
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
 
FUNCTION i120_out()
   DEFINE   l_i      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
            l_name   LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
            l_imz    RECORD LIKE imz_file.*,
            l_za05   LIKE type_file.chr1000,               #  #No.FUN-690026 VARCHAR(40)
            l_chr    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
#No.TQC-710076 -- begin --
#   IF cl_null(g_wc2) THEN
#       LET g_wc2 = ' 1=1'
#   END IF
   IF cl_null(g_wc2) THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
#No.TQC-710076 -- end --
   CALL cl_wait()
   CALL cl_outnam('aimi120') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT * FROM imz_file ",          # 組合出 SQL 指令
             " WHERE ",g_wc2 CLIPPED
   PREPARE i120_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i120_co                         # CURSOR
      CURSOR FOR i120_p1
 
   START REPORT i120_rep TO l_name
 
   FOREACH i120_co INTO l_imz.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
         END IF
      OUTPUT TO REPORT i120_rep(l_imz.*)
   END FOREACH
 
   FINISH REPORT i120_rep
 
   CLOSE i120_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i120_rep(sr)
   DEFINE   l_trailer_sw   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            sr             RECORD LIKE imz_file.*,
            l_chr          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.imz01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno" 
         PRINT g_head CLIPPED,pageno_total     
         PRINT 
         PRINT g_dash
         PRINT g_x[31],g_x[32],g_x[33]
         PRINT g_dash1 
         LET l_trailer_sw = 'y'
      ON EVERY ROW
         IF sr.imzacti = 'N' THEN 
             PRINT COLUMN g_c[31],'*'; 
         ELSE
             PRINT COLUMN g_c[31],' '; 
         END IF
 
         PRINT COLUMN g_c[32],sr.imz01,
               COLUMN g_c[33],sr.imz02
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc2,'imz01,imz02,imz03,imz04')
                 RETURNING g_wc2
            PRINT g_dash
            #TQC-630166
            #IF g_wc2[001,080] > ' ' THEN
      	    #   PRINT g_x[8] CLIPPED,g_wc2[001,070] CLIPPED
            #END IF
            #IF g_wc2[071,140] > ' ' THEN
      	    #   PRINT COLUMN 10,     g_wc2[071,140] CLIPPED
            #END IF
            #IF g_wc2[141,210] > ' ' THEN
      	    #   PRINT COLUMN 10,     g_wc2[141,210] CLIPPED
            #END IF
            CALL cl_prt_pos_wc(g_wc2)
            #END TQC-630166
         END IF
         PRINT g_dash
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         LET l_trailer_sw = 'n'
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT
 
#No.FUN-570110 --start--                                                                                                            
FUNCTION i120_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690026 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("imz01",TRUE)                                                                                           
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i120_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690026 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("imz01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--     
