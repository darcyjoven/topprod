# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: anmi710.4gl
# Descriptions...: 信貸銀行資料維護
# Date & Author..: 99/06/04 By Kitty
# Modify ........: No.MOD-470448 04/07/20 By Melody 一進程式先顯示資料
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/11 By pengu 報表轉XML
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-790050 07/07/13 By Carrier _out()轉p_query實現
# Modify.........: No.MOD-960067 09/06/09 By baofei 4fd上沒有cn3欄位 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_alg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        alg01       LIKE alg_file.alg01,       #
        alg02       LIKE alg_file.alg02,       #
        alg021      LIKE alg_file.alg021       #
                    END RECORD,
    g_alg_t         RECORD                     #程式變數 (舊值)
        alg01       LIKE alg_file.alg01,       #
        alg02       LIKE alg_file.alg02,       #
        alg021      LIKE alg_file.alg021       #
                    END RECORD,
    g_wc,g_sql      STRING,                    #TQC-630166       
    g_rec_b         LIKE type_file.num5,       #單身筆數 #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-790050
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5     #FUN-570108 #No.FUN-680107 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680107 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW i710_w AT p_row,p_col WITH FORM "anm/42f/anmi710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
     CALL i710_b_fill(' 1=1 ')  #No.MOD-470448
    CALL i710_menu()
    CLOSE WINDOW i710_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION i710_menu()
 
   WHILE TRUE
      CALL i710_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i710_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i710_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i710_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi710" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_alg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i710_q()
   CALL i710_b_askkey()
END FUNCTION
 
FUNCTION i710_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用        #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態          #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否          #No.FUN-680107 VARCHAR(1)
    l_allow_delete  LIKE type_file.num5          #可刪除否          #No.FUN-680107 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT alg01,alg02,alg021 FROM alg_file ",
                       " WHERE alg01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i710_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_alg WITHOUT DEFAULTS FROM s_alg.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
#            DISPLAY l_ac TO FORMONLY.cn3  #MOD-960067
           #LET g_alg_t.* = g_alg[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_alg_t.* = g_alg[l_ac].*  #BACKUP
#No.FUN-570108 --start
                LET g_before_input_done = FALSE
                CALL i710_set_entry(p_cmd)
                CALL i710_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
#No.FUN-570108 --end
 
                BEGIN WORK
                OPEN i710_bcl USING g_alg_t.alg01
                IF STATUS THEN
                   CALL cl_err("OPEN i710_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                   FETCH i710_bcl INTO g_alg[l_ac].*
                   IF STATUS THEN
                      CALL cl_err(g_alg_t.alg01,STATUS,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start
            LET g_before_input_done = FALSE
            CALL i710_set_entry(p_cmd)
            CALL i710_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570108 --end
            INITIALIZE g_alg[l_ac].* TO NULL      #900423
            LET g_alg_t.* = g_alg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD alg01
 
        AFTER INSERT
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
              #CLOSE i710_bcl
              #CALL g_alg.deleteElement(l_ac)
              #IF g_rec_b != 0 THEN
              #   LET g_action_choice = "detail"
              #   LET l_ac = l_ac_t
              #END IF
              #EXIT INPUT
            END IF
            INSERT INTO alg_file(alg01,alg02,alg021)
            VALUES(g_alg[l_ac].alg01,g_alg[l_ac].alg02,g_alg[l_ac].alg021)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_alg[l_ac].alg01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("ins","alg_file",g_alg[l_ac].alg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
              #LET g_alg[l_ac].* = g_alg_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD alg01                        #check 編號是否重複
            IF g_alg[l_ac].alg01 != g_alg_t.alg01 OR
               (g_alg[l_ac].alg01 IS NOT NULL AND g_alg_t.alg01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM alg_file
                    WHERE alg01 = g_alg[l_ac].alg01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_alg[l_ac].alg01 = g_alg_t.alg01
                    NEXT FIELD alg01
                END IF
            END IF
 
        BEFORE FIELD alg021
            IF g_alg[l_ac].alg02 IS NOT NULL AND g_alg[l_ac].alg021 IS NULL THEN
               LET g_alg[l_ac].alg021=g_alg[l_ac].alg02
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_alg[l_ac].alg021
               #------MOD-5A0095 END------------
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_alg_t.alg01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
{ckp#1}         DELETE FROM alg_file WHERE alg01 = g_alg_t.alg01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_alg_t.alg01,SQLCA.sqlcode,0)  #No.FUN-660148
                   CALL cl_err3("del","alg_file",g_alg_t.alg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i710_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
          IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_alg[l_ac].* = g_alg_t.*
               CLOSE i710_bcl
               ROLLBACK WORK
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_alg[l_ac].alg01,-263,1)
             LET g_alg[l_ac].* = g_alg_t.*
          ELSE
             UPDATE alg_file SET alg01 = g_alg[l_ac].alg01,
                                 alg02 = g_alg[l_ac].alg02,
                                 alg021= g_alg[l_ac].alg021
                        WHERE alg01=g_alg_t.alg01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_alg[l_ac].alg01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","alg_file",g_alg_t.alg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_alg[l_ac].* = g_alg_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i710_bcl
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_alg[l_ac].* = g_alg_t.*
            #FUN-D30032--add--str--
             ELSE
                CALL g_alg.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
            #FUN-D30032--add--end--
             END IF
             CLOSE i710_bcl
             ROLLBACK WORK
             EXIT INPUT
           END IF
          #LET g_alg_t.* = g_alg[l_ac].*          # 900423
           LET l_ac_t = l_ac
           CLOSE i710_bcl
           COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i710_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(alg01) AND l_ac > 1 THEN
                LET g_alg[l_ac].* = g_alg[l_ac-1].*
                NEXT FIELD alg01
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
 
    CLOSE i710_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i710_b_askkey()
    CLEAR FORM
   CALL g_alg.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON alg01,alg02,alg021
            FROM s_alg[1].alg01,s_alg[1].alg02,s_alg[1].alg021
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i710_b_fill(g_wc)
END FUNCTION
 
FUNCTION i710_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
    LET g_sql =
        "SELECT alg01,alg02,alg021 FROM alg_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i710_pb FROM g_sql
    DECLARE alg_curs CURSOR FOR i710_pb
 
    CALL g_alg.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    MESSAGE "Searching!"
    FOREACH alg_curs INTO g_alg[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
 
    CALL g_alg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_alg TO s_alg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i710_out()
#    DEFINE
#        l_i             LIKE type_file.num5,         #No.FUN-680107 SMALLINT
#        l_name          LIKE type_file.chr20,        # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#        l_alg           RECORD LIKE alg_file.*,
#        l_za05          LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(40)
#        l_chr           LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
#
##No.TQC-710076 -- begin --
##    IF cl_null(g_wc)  THEN LET g_wc = " 1=1 " END IF
#   IF cl_null(g_wc) THEN
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF
##No.TQC-710076 -- end --
#    CALL cl_wait()
#    LET l_name = 'anmi710.out'
#    CALL cl_outnam('anmi710') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM alg_file ",     # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#    PREPARE i710_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i710_co CURSOR FOR i710_p1
#
#    START REPORT i710_rep TO l_name
#
#    FOREACH i710_co INTO l_alg.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i710_rep(l_alg.*)
#    END FOREACH
#
#    FINISH REPORT i710_rep
#
#    CLOSE i710_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i710_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
#        sr              RECORD LIKE alg_file.*,
#        l_chr           LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.alg01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.alg01,
#                  COLUMN g_c[32],sr.alg02,
#                  COLUMN g_c[33],sr.alg021
#
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash[1,g_len]
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-790050  --End
 
#No.FUN-570108 --start
FUNCTION i710_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("alg01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i710_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("alg01",FALSE)
   END IF
END FUNCTION
#No.FUN-570108 --end
#Patch....NO.MOD-5A0095 <003> #
