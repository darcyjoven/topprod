# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: armi010.4gl
# Descriptions...: 人工單價維護作業
# Date & Author..: 91/06/21 By Alan
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-510044 05/01/21 By Mandy 報表轉XML
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.TQC-5C0064 05/12/13 By kevin 結束位置調整
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/18 By Sunyanchun   老報表改成p_query
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990100 09/10/10 By lilingyu "工資單價"未控管負數
# Modify.........: No.TQC-AB0025 10/12/17 By chenying 修改CURRENT OF寫法
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
 
    g_rmg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        rmg01       LIKE rmg_file.rmg01,   #生效日期
        rmg02       LIKE rmg_file.rmg02    #工資單價
                    END RECORD,
 
    g_rmg_t         RECORD                 #程式變數 (舊值)
        rmg01       LIKE rmg_file.rmg01,   #生效日期
        rmg02       LIKE rmg_file.rmg02    #工資單價
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570109  #No.FUN-690010 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose  #No.FUN-690010 SMALLINT
 
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0085
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "arm/42f/armi010"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i010_b_fill(g_wc2)
    CALL i010_menu()
    CLOSE WINDOW i010_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
FUNCTION i010_menu()
DEFINE l_cmd  LIKE type_file.chr1000           #No.FUN-7C0043---add---
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i010_out()   
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmg),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i010_q()
   CALL i010_b_askkey()
END FUNCTION
 
FUNCTION i010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-690010 VARCHAR(01),
    l_allow_delete  LIKE type_file.chr1                  #No.FUN-690010 VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rmg01,rmg02 FROM rmg_file WHERE rmg01= ?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_rmg WITHOUT DEFAULTS FROM s_rmg.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET g_rmg_t.* = g_rmg[l_ac].*  #BACKUP
               LET p_cmd='u'
#No.FUN-570109 --start
               LET g_before_input_done = FALSE
               CALL i010_set_entry(p_cmd)
               CALL i010_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570109 --end
               BEGIN WORK
               OPEN i010_bcl USING g_rmg_t.rmg01
               IF STATUS THEN
                  CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_rmg_t.rmg01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  FETCH i010_bcl INTO g_rmg[l_ac].*
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD rmg01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start
            LET g_before_input_done = FALSE
            CALL i010_set_entry(p_cmd)
            CALL i010_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end
            INITIALIZE g_rmg[l_ac].* TO NULL      #900423
            LET g_rmg_t.* = g_rmg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmg01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            CANCEL INSERT
         END IF
         INSERT INTO rmg_file(rmg01,rmg02,rmguser,rmggrup,rmgdate,
                              rmgplant,rmglegal,rmgoriu,rmgorig) #FUN-980007
         VALUES(g_rmg[l_ac].rmg01,g_rmg[l_ac].rmg02,
                g_user,g_grup,g_today,
                g_plant,g_legal, g_user, g_grup)                 #FUN-980007      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#             CALL cl_err(g_rmg[l_ac].rmg01,SQLCA.sqlcode,0) # FUN-660111
            CALL cl_err3("ins","rmg_file",g_rmg[l_ac].rmg01,"",SQLCA.sqlcode,"","",1) # FUN-660111
             #CKP
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
        AFTER FIELD rmg01                        #check 編號是否重複
            IF g_rmg[l_ac].rmg01 IS NOT NULL THEN
               IF g_rmg[l_ac].rmg01 != g_rmg_t.rmg01 OR
                 (g_rmg[l_ac].rmg01 IS NOT NULL AND g_rmg_t.rmg01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM rmg_file
                   WHERE rmg01 = g_rmg[l_ac].rmg01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_rmg[l_ac].rmg01 = g_rmg_t.rmg01
                     NEXT FIELD rmg01
                 END IF
               END IF
            END IF
 
#TQC-990100 --begin--
      AFTER FIELD rmg02
          IF NOT cl_null(g_rmg[l_ac].rmg02) THEN 
              IF  g_rmg[l_ac].rmg02 < 0 THEN 
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD rmg02
              END IF 
          END IF 
#TQC-990100 --end--
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmg_t.rmg01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmg_file WHERE rmg01 = g_rmg_t.rmg01
                IF SQLCA.sqlcode THEN
 #                  CALL cl_err(g_rmg_t.rmg01,SQLCA.sqlcode,0) # FUN-660111
                   CALL cl_err3("del","rmg_file",g_rmg_t.rmg01,"",SQLCA.sqlcode,"","",1) # FUN-660111
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i010_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rmg[l_ac].* = g_rmg_t.*
              CLOSE i010_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rmg[l_ac].rmg01,-263,1)
              LET g_rmg[l_ac].* = g_rmg_t.*
           ELSE
                        UPDATE rmg_file SET
                               rmg01=g_rmg[l_ac].rmg01,
                               rmg02=g_rmg[l_ac].rmg02,
                               rmgmodu=g_user,
                               rmgdate=g_today
#                        WHERE CURRENT OF i010_bcl    #TQC-AB0025 mark
                         WHERE rmg01= g_rmg_t.rmg01   #TQC-AB0025 add 
              IF SQLCA.sqlcode THEN
 #                 CALL cl_err(g_rmg[l_ac].rmg01,SQLCA.sqlcode,0)  # FUN-660111
                CALL cl_err3("upd","rmg_file",g_rmg_t.rmg01,"",SQLCA.sqlcode,"","",1) # FUN-660111
                  LET g_rmg[l_ac].* = g_rmg_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i010_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmg[l_ac].* = g_rmg_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE i010_bcl
               ROLLBACK WORK
               EXIT INPUT
 #TQC-990100 --begin--
            ELSE
               IF NOT cl_null(g_rmg[l_ac].rmg02) THEN
                 IF  g_rmg[l_ac].rmg02 < 0 THEN
                    CALL cl_err('','aec-020',0)
                    NEXT FIELD rmg02
                 END IF
                END IF 
 #TQC-990100 --end--               
            END IF
            LET l_ac_t = l_ac
            CLOSE i010_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i010_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rmg01) AND l_ac > 1 THEN
                LET g_rmg[l_ac].* = g_rmg[l_ac-1].*
                NEXT FIELD rmg01
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
 
    CLOSE i010_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_b_askkey()
    CLEAR FORM
    CALL g_rmg.clear()
    CONSTRUCT g_wc2 ON rmg01,rmg02
            FROM s_rmg[1].rmg01,s_rmg[1].rmg02
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('rmguser', 'rmggrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i010_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
        "SELECT rmg01,rmg02,''",
        " FROM rmg_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i010_pb FROM g_sql
    DECLARE rmg_curs CURSOR FOR i010_pb
 
    CALL g_rmg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rmg_curs INTO g_rmg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    #CKP
    CALL g_rmg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmg TO s_rmg.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i010_out()
DEFINE l_cmd  LIKE type_file.chr1000     #No.FUN-7C0043    add
#    DEFINE
#        l_rmg           RECORD LIKE rmg_file.*,
#        l_i             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#        l_za05          LIKE type_file.chr1000                #  #No.FUN-690010 VARCHAR(40)
 
     #FUN-7C0043----Begin
     IF g_wc2 IS NULL THEN CALL cl_err('',9057,0) RETURN END IF                  
     LET l_cmd = 'p_query "armi010" "',g_wc2 CLIPPED,'"'                         
     CALL cl_cmdrun(l_cmd)
     #FUN=7C0043----END
 
#    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#No.CHI-6A0004--------------------Begin-----------
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#                              FROM azi_file
#                             WHERE azi01 =g_aza.aza17
#No.CHI-6A0004-------------------End--------------
#   CALL cl_wait()
#   CALL cl_outnam('armi010') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM rmg_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
 
#   PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i010_co                         # SCROLL CURSOR
#       CURSOR FOR i010_p1
 
#   START REPORT i010_rep TO l_name
 
#   FOREACH i010_co INTO l_rmg.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i010_rep(l_rmg.*)
#   END FOREACH
 
#   FINISH REPORT i010_rep
 
#   CLOSE i010_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i010_rep(sr)
#   DEFINE
#       l_last_sw   LIKE type_file.chr1,          #No.FUN-690010 VARCHAR(1),
#       sr RECORD LIKE rmg_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.rmg01
 
#   FORMAT
#       PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT
#         PRINT g_dash
#         PRINT g_x[31],g_x[32]
#         PRINT g_dash1
#         LET l_last_sw = 'n'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.rmg01,
#                 COLUMN g_c[32],cl_numfor(sr.rmg02,32,g_azi03)
 
#       ON LAST ROW
#           LET l_last_sw ='y'
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-5C0064
 
#       PAGE TRAILER
#          IF l_last_sw = 'n' THEN
#             PRINT g_dash
#             PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-5C0064
#          ELSE SKIP 2 LINE END IF
#END REPORT
 
#No.FUN-570109 --start
FUNCTION i010_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rmg01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i010_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("rmg01",FALSE)
   END IF
END FUNCTION
#No.FUN-570109 --end
#Patch....NO.TQC-610037 <001> #
