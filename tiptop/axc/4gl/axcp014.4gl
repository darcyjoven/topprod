# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axcp014.4gl
# Descriptions...: 料件轉撥計價加成百分比設定作業
# Date & Author..: 00/04/18 By Kammy
# Modify.........: No.FUN-4C0099 05/01/10 By kim 報表轉XML功能
# Modify.........: NO.MOD-590014 05/09/05 By Rosayu 單身刪除後資料沒有被刪除
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0102 06/11/15 By johnray 報表修改
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/27 By hellen 將iamicd_file變為icd專用
# Modify.........: No.TQC-970190 09/07/20 By dxfwo  若沒有新增功能，就把按鈕取消
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_ima           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        ima01       LIKE ima_file.ima01,
        ima25       LIKE ima_file.ima25,
        ima08       LIKE ima_file.ima08,
        ima16       LIKE ima_file.ima16,
        ima57       LIKE ima_file.ima57,
        ima12       LIKE ima_file.ima12,
        ima129      LIKE ima_file.ima129
                    END RECORD,
    m_ima_t         RECORD                 #程式變數 (舊值)
        ima01       LIKE ima_file.ima01,
        ima25       LIKE ima_file.ima25,
        ima08       LIKE ima_file.ima08,
        ima16       LIKE ima_file.ima16,
        ima57       LIKE ima_file.ima57,
        ima12       LIKE ima_file.ima12,
        ima129      LIKE ima_file.ima129
                    END RECORD,
    g_imaacti       LIKE  ima_file.imaacti,     
    g_imauser       LIKE  ima_file.imauser,     
    g_imagrup       LIKE  ima_file.imagrup,     
    g_imamodu       LIKE  ima_file.imamodu,     
    g_imadate       LIKE  ima_file.imadate,     
    g_wc2,g_sql     STRING,#TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW p014_w WITH FORM "axc/42f/axcp014"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1'
    CALL p014_menu()
    CLOSE WINDOW p014_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p014_menu()
   WHILE TRUE
      CALL p014_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p014_q() 
            END IF
         WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL p014_b() 
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL p014_out() 
            END IF
         WHEN "help" CALL cl_show_help()
         WHEN "exit" EXIT WHILE
         WHEN "controlg" CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p014_q()
   CALL p014_b_askkey()
END FUNCTION
 
FUNCTION p014_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql = 
    "SELECT ima01,ima25,ima08,ima16,ima57,ima12,ima129 ",
    " FROM ima_file ",
    " WHERE ima01 = ? ",
    " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p014_bcl CURSOR FROM g_forupd_sql
 
#       LET l_allow_insert = cl_detail_input_auth("insert")  #No.TQC-970190 
        LET l_allow_insert = false    #No.TQC-970190 
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY m_ima WITHOUT DEFAULTS FROM s_ima.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'
            IF g_rec_b >= l_ac THEN
               LET p_cmd = 'u'
               LET m_ima_t.*=m_ima[l_ac].*
               BEGIN WORK
               OPEN p014_bcl USING m_ima_t.ima01
               IF SQLCA.sqlcode THEN
                   CALL cl_err(m_ima_t.ima01,SQLCA.sqlcode,1)
                   LET l_lock_sw='Y' 
               ELSE
                   FETCH p014_bcl INTO m_ima[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(m_ima_t.ima01,SQLCA.sqlcode,1)
                      LET l_lock_sw='Y' 
                   END IF
               END IF
               SELECT imaacti,imauser,imagrup,imadate,imamodu 
                 INTO g_imaacti,g_imauser,g_imagrup,g_imadate,g_imamodu 
                 FROM ima_file WHERE ima01 = m_ima[l_ac].ima01 
               IF cl_null(g_imauser) THEN LET g_imauser = g_user END IF 
               #使用者所屬群
               IF cl_null(g_imagrup) THEN LET g_imagrup = g_grup END IF
               IF cl_null(g_imadate) THEN LET g_imadate = g_today END IF 
               DISPLAY  g_imauser,g_imagrup,g_imadate,g_imamodu 
                    TO    imauser,  imagrup,  imadate ,  imamodu 
               CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        AFTER FIELD ima129
            IF m_ima_t.ima129 != m_ima[l_ac].ima129 THEN 
		LET g_imamodu = g_user                   #修改者
		LET g_imadate = g_today                  #修改日期
                DISPLAY  g_imamodu,g_imadate TO  imamodu,  imadate
            END IF 
 
        BEFORE DELETE
           IF NOT cl_null(m_ima_t.ima01) THEN
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw ="Y" THEN
                 CALL cl_err("",-263,1)
                 CANCEL DELETE
              END IF
              DELETE FROM ima_file where ima01 = m_ima_t.ima01
              IF SQLCA.sqlcode THEN
#                CALL cl_err(m_ima_t.ima01,SQLCA.sqlcode,0)   #No.FUN-660127
                 CALL cl_err3("del","ima_file",m_ima_t.ima01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660127
                 ROLLBACK WORK
                 CANCEL DELETE
              #No.FUN-7B0018 080304 add --begin
              ELSE
#                IF NOT s_industry('std') THEN  #No.FUN-830132 mark
                 IF s_industry('icd') THEN      #No.FUN-830132 add
                    IF NOT s_del_imaicd(m_ima_t.ima01,'') THEN
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF
                 END IF 
              #No.FUN-7B0018 080304 add --end
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE "Delete OK"
              CLOSE p014_bcl
              COMMIT WORK
           END IF
        #MOD-590014 end
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET m_ima[l_ac].* = m_ima_t.*
               CLOSE p014_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(m_ima[l_ac].ima01,-263,1)
                LET m_ima[l_ac].* = m_ima_t.*
            ELSE
                UPDATE ima_file SET ima129  = m_ima[l_ac].ima129,
                                    imauser = g_imauser, 
                                    imagrup = g_imagrup, 
                                    imadate = g_imadate, 
                                    imamodu = g_imamodu
                       WHERE ima01=m_ima[l_ac].ima01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(m_ima[l_ac].ima01,SQLCA.sqlcode,1)   #No.FUN-660127
                   CALL cl_err3("upd","ima_file",m_ima_t.ima01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660127
                ELSE
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET m_ima[l_ac].* = m_ima_t.*
               END IF
               CLOSE p014_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE p014_bcl
            COMMIT WORK
 
 
      # ON ACTION CONTROLN
      #     CALL p014_b_askkey()
      #     EXIT INPUT
 
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
 
        
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        END INPUT
 
END FUNCTION
 
FUNCTION p014_b_askkey()
    CLEAR FORM
    CALL m_ima.clear()
    CONSTRUCT g_wc2 ON ima01,ima25,ima08,ima16,ima57,ima12,ima129
            FROM s_ima[1].ima01,s_ima[1].ima25,s_ima[1].ima08,
                 s_ima[1].ima16,s_ima[1].ima57,s_ima[1].ima12,
                 s_ima[1].ima129
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
  
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL p014_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p014_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    LET g_sql =
        "SELECT ima01,ima25,ima08,ima16,ima57,ima12,ima129",
        " FROM ima_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE p014_pb FROM g_sql
    DECLARE ima_curs CURSOR FOR p014_pb
 
    CALL m_ima.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ima_curs INTO m_ima[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL m_ima.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p014_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p014_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),           # External(Disk) file name
        l_ima   RECORD LIKE ima_file.*,
        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),              #
        l_chr           LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axcp014') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM ima_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE p014_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p014_co CURSOR FOR p014_p1
 
    START REPORT p014_rep TO l_name
 
    FOREACH p014_co INTO l_ima.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT p014_rep(l_ima.*)
    END FOREACH
 
    FINISH REPORT p014_rep
 
    CLOSE p014_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p014_rep(sr)
    DEFINE l_ima02 LIKE ima_file.ima02
    DEFINE l_ima021 LIKE ima_file.ima021
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1),
        sr RECORD LIKE ima_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ima01
    FORMAT
        PAGE HEADER
           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
           LET g_pageno=g_pageno+1
           LET pageno_total=PAGENO USING '<<<','/pageno'
           PRINT g_head CLIPPED,pageno_total
           PRINT 
           PRINT g_dash
           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                 g_x[36],g_x[37],g_x[38],g_x[39]
           PRINT g_dash1
           LET l_trailer_sw = 'y'
 
      ON EVERY ROW
           SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
               WHERE ima01=sr.ima01
           IF SQLCA.sqlcode THEN 
               LET l_ima02 = NULL 
               LET l_ima021 = NULL 
           END IF
 
         PRINT COLUMN g_c[31],sr.ima01,
               COLUMN g_c[32],l_ima02,
               COLUMN g_c[33],l_ima021,
               COLUMN g_c[34],sr.ima25,
               COLUMN g_c[35],sr.ima08,
#No.TQC-6A0102 -- begin --
#               COLUMN g_c[36],sr.ima16 using '##&',
#               COLUMN g_c[37],sr.ima57 using '##&',
               COLUMN g_c[36],sr.ima16 USING '#####&',
               COLUMN g_c[37],sr.ima57 USING '#######&',
#No.TQC-6A0102 -- end --
               COLUMN g_c[38],sr.ima12 ,
               COLUMN g_c[39],cl_numfor(sr.ima129,39,3)
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc2,'ima01,ima25,ima08,ima16,ima57,ima58')
                 RETURNING g_sql
            PRINT g_dash
            #TQC-630166
            {
            IF g_sql[001,080] > ' ' THEN
                    PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
            IF g_sql[071,140] > ' ' THEN
                    PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
            IF g_sql[141,210] > ' ' THEN
                    PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
            }
              CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166
         END IF
         PRINT g_dash
         LET l_trailer_sw = 'n'
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
     PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
             PRINT g_dash
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
             SKIP 2 LINE
         END IF
END REPORT
