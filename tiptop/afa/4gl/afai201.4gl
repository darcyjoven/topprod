# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: afai201.4gl
# Descriptions...: 校定項目維護作業
# Date & Author..: 00/03/17 By Iceman
# Modify.........: No.MOD-470515 04/07/27 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-490344 04/09/20 By Kitty  controlp 少display加入
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By day    修正建檔程式key值是否可更改
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-8B0045 08/11/06 By Sarah 與fgb_file有關的SQL都少串key值fgb01
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B40172 11/04/20 by Dido 檢核校定代號不可重複 
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fgb01         LIKE fgb_file.fgb01,
    g_argv1         LIKE fgb_file.fgb01,       #No.FUN-680070 VARCHAR(15)
    g_fgb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fgb02       LIKE fgb_file.fgb02,       #項次
        fgb03       LIKE fgb_file.fgb03,       #校定代號
        fgd02       LIKE fgd_file.fgd02,       #校定項次名稱
        fgb04       LIKE fgb_file.fgb04        #項目名稱
                    END RECORD,
    g_fgb_t         RECORD                     #程式變數 (舊值)
        fgb02       LIKE fgb_file.fgb02,       #項次
        fgb03       LIKE fgb_file.fgb03,       #校定代號
        fgd02       LIKE fgd_file.fgd02,       #校定項次名稱
        fgb04       LIKE fgb_file.fgb04        #項目名稱
                    END RECORD,
    g_wc2,g_sql     STRING,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數                    #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT         #No.FUN-680070 SMALLINT
 
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-570108           #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680070 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose #No.FUN-680070 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0069
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680070 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
    LET g_argv1=ARG_VAL(1)
    LET g_fgb01 = g_argv1
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW i201_w AT p_row,p_col WITH FORM "afa/42f/afai201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i201_b_fill(g_wc2)
 
    CALL i201_menu()
    CLOSE WINDOW i201_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
END MAIN
 
FUNCTION i201_menu()
 
   WHILE TRUE
      CALL i201_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i201_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i201_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i201_out()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fgb01 IS NOT NULL THEN
                  LET g_doc.column1 = "fgb01"
                  LET g_doc.value1 = g_fgb01
                   #-----No.MOD-4C0029-----
                  LET g_doc.column2 = "fgb02"
                  LET g_doc.value2 = g_fgb[l_ac].fgb02
                   #-----No.MOD-4C0029 END-----
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fgb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i201_q()
   IF g_fgb01 IS NULL OR g_fgb01 = ' ' THEN CALL cl_err('','afa-411',0)
        RETURN END IF
   CALL i201_b_askkey()
END FUNCTION
 
FUNCTION i201_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #可新增否       #No.FUN-680070 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                  #可刪除否       #No.FUN-680070 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fgb.clear() END IF
 
 
    IF g_fgb01 IS NULL OR g_fgb01 = ' ' THEN CALL cl_err('','afa-411',0)
        RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fgb02,fgb03,'',fgb04 FROM fgb_file",
                      #" WHERE fgb02= ? FOR UPDATE"                #MOD-8B0045 mark
                       " WHERE fgb02= ? AND fgb01 = ? FOR UPDATE"  #MOD-8B0045
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_fgb
            WITHOUT DEFAULTS
            FROM s_fgb.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
           #LET g_fgb_t.* = g_fgb[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           #IF g_fgb_t.fgb02 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fgb_t.* = g_fgb[l_ac].*  #BACKUP
#No.FUN-570108 --start--
                LET g_before_input_done = FALSE
                CALL i201_set_entry(p_cmd)
                CALL i201_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
#No.FUN-570108 --end--
 
                BEGIN WORK
               #OPEN i201_bcl USING g_fgb_t.fgb02           #MOD-8B0045 mark
                OPEN i201_bcl USING g_fgb_t.fgb02,g_fgb01   #MOD-8B0045
                IF STATUS THEN
                   CALL cl_err("OPEN i201_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i201_bcl INTO g_fgb[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fgb_t.fgb02,SQLCA.sqlcode,0)
                      LET l_lock_sw = "Y"
                   END IF
                   CALL i201_fgb03('a')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
          # NEXT FIELD fgb02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start--
            LET g_before_input_done = FALSE
            CALL i201_set_entry(p_cmd)
            CALL i201_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570108 --end--
            INITIALIZE g_fgb[l_ac].* TO NULL      #900423
            LET g_fgb_t.* = g_fgb[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fgb02
 
        AFTER INSERT
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fgb[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fgb[l_ac].* TO s_fgb.*
              CALL g_fgb.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
               INSERT INTO fgb_file(fgb01,fgb02,fgb03,fgb04,fgboriu,fgborig)
               VALUES(g_fgb01,g_fgb[l_ac].fgb02,g_fgb[l_ac].fgb03,
		      g_fgb[l_ac].fgb04, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fgb[l_ac].fgb02,SQLCA.sqlcode,0)   #No.FUN-660136
                  CALL cl_err3("ins","fgb_file",g_fgb01,g_fgb[l_ac].fgb02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                 #LET g_fgb[l_ac].* = g_fgb_t.*
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2
               END IF
 
        BEFORE FIELD fgb02
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fgb[l_ac].fgb02 IS NULL OR g_fgb[l_ac].fgb02 = 0 THEN
                   SELECT max(fgb02)+1 INTO g_fgb[l_ac].fgb02
                      FROM fgb_file WHERE fgb01 = g_fgb01
                   IF g_fgb[l_ac].fgb02 IS NULL THEN
                       LET g_fgb[l_ac].fgb02 = 1
                   END IF
               END IF
            END IF
 
        BEFORE FIELD fgb03
            IF g_fgb[l_ac].fgb02 != g_fgb_t.fgb02 OR  #check 編號是否重複
               (g_fgb[l_ac].fgb02 IS NOT NULL AND g_fgb_t.fgb02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM fgb_file
                    WHERE fgb02 = g_fgb[l_ac].fgb02
                      AND fgb01 = g_fgb01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fgb[l_ac].fgb02 = g_fgb_t.fgb02
                    NEXT FIELD fgb02
                END IF
            END IF
 
        AFTER FIELD fgb03
          IF NOT cl_null(g_fgb[l_ac].fgb03) THEN   # 重要欄位不可空白
            CALL i201_fgb03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fgb[l_ac].fgb03,g_errno,0)
               LET g_fgb[l_ac].fgb03 = g_fgb_t.fgb03
               NEXT FIELD fgb03
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_fgb[l_ac].fgb03
               #------MOD-5A0095 END------------
            END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fgb_t.fgb02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "fgb01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_fgb01                #No.FUN-9B0098 10/02/24
                LET g_doc.column2 = "fgb02"               #No.FUN-9B0098 10/02/24
                LET g_doc.value2 = g_fgb[l_ac].fgb02      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM fgb_file WHERE fgb02 = g_fgb_t.fgb02
                                       AND fgb01=g_fgb01   #MOD-8B0045 add
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fgb_t.fgb02,SQLCA.sqlcode,0)     #No.FUN-660136
                   CALL cl_err3("del","fgb_file",g_fgb_t.fgb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i201_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_fgb[l_ac].* = g_fgb_t.*
              CLOSE i201_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fgb[l_ac].fgb02,-263,1)
             LET g_fgb[l_ac].* = g_fgb_t.*
           ELSE
             UPDATE fgb_file SET
                    fgb02=g_fgb[l_ac].fgb02,fgb03=g_fgb[l_ac].fgb03,
                    fgb04=g_fgb[l_ac].fgb04,fgbmodu=g_today
              WHERE fgb02=g_fgb_t.fgb02
                AND fgb01=g_fgb01      #MOD-8B0045 add
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fgb[l_ac].fgb02,SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("upd","fgb_file",g_fgb_t.fgb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                LET g_fgb[l_ac].* = g_fgb_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i201_bcl
                COMMIT WORK
             END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_fgb[l_ac].* = g_fgb_t.*
              #FUN-D30032--add--begin--
              ELSE
                 CALL g_fgb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end----
              END IF
              CLOSE i201_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
         # LET g_fgb_t.* = g_fgb[l_ac].*
           LET l_ac_t = l_ac
           CLOSE i201_bcl
           COMMIT WORK
           #CKP2
           CALL g_fgb.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLN
            CALL i201_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fgb02) AND l_ac > 1 THEN
                LET g_fgb[l_ac].* = g_fgb[l_ac-1].*
                LET g_fgb[l_ac].fgb02 = '    '
                NEXT FIELD fgb02
            END IF
 
        ON ACTION controlp
            CASE  WHEN INFIELD(fgb03)  #校定代號
#                     CALL q_fgd(2,4,g_fgb[l_ac].fgb03)
#                          RETURNING g_fgb[l_ac].fgb03
#                     CALL FGL_DIALOG_SETBUFFER( g_fgb[l_ac].fgb03 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_fgd"
                      LET g_qryparam.default1 = g_fgb[l_ac].fgb03
                      CALL cl_create_qry() RETURNING g_fgb[l_ac].fgb03
#                      CALL FGL_DIALOG_SETBUFFER( g_fgb[l_ac].fgb03 )
                      CALL i201_fgb03('d')
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err(' ',g_errno,0)
                           NEXT FIELD fgb03
                        END IF
                       DISPLAY BY NAME g_fgb[l_ac].fgb03       #No.MOD-490344
                      NEXT FIELD fgb03
            OTHERWISE EXIT CASE
            END CASE
 
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
 
    CLOSE i201_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i201_b_askkey()
    CLEAR FORM
   CALL g_fgb.clear()
    CONSTRUCT g_wc2 ON fgb02,fgb03,fgb04
            FROM s_fgb[1].fgb02,s_fgb[1].fgb03,s_fgb[1].fgb04
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE  WHEN INFIELD(fgb03)  #校定代號
#                     CALL q_fgd(2,4,g_fgb[1].fgb03)
#                          RETURNING g_fgb[1].fgb03
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_fgd"
                      LET g_qryparam.form = "c"
                      LET g_qryparam.default1 = g_fgb[1].fgb03
                      CALL cl_create_qry() RETURNING g_fgb[1].fgb03
                      DISPLAY g_qryparam.multiret TO s_fgb[1].fgb03
                      NEXT FIELD fgb03
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('fgbuser', 'fgbgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i201_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i201_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fgb02,fgb03,fgd02,fgb04",
        " FROM fgb_file ,OUTER fgd_file ",
        " WHERE fgb_file.fgb03=fgd_file.fgd01 ",
        " AND fgb01 = '",g_fgb01,"' AND ", p_wc2 CLIPPED,     #單身
        " ORDER BY 1"
    PREPARE i201_pb FROM g_sql
    DECLARE fgb_curs CURSOR FOR i201_pb
 
    FOR g_cnt = 1 TO g_fgb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_fgb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH fgb_curs INTO g_fgb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_fgb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fgb TO s_fgb.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
 
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
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i201_fgb03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fgd02    LIKE fgd_file.fgd02,
          l_fgdacti  LIKE fgd_file.fgdacti
 DEFINE   l_cnt      LIKE type_file.num5           #MOD-B40172 
 
    LET g_errno = ' '
    SELECT fgd02,fgdacti INTO l_fgd02,l_fgdacti
      FROM fgd_file
     WHERE fgd01 = g_fgb[l_ac].fgb03
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-409'
                                 LET l_fgd02 = NULL
                                 LET l_fgdacti = NULL
        WHEN l_fgdacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  #-MOD-B40172-add-
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM fgb_file
    WHERE fgb01 = g_fgb01
      AND fgb02 <> g_fgb[l_ac].fgb02 
      AND fgb03 = g_fgb[l_ac].fgb03
   IF l_cnt > 0 THEN
      LET g_errno ='axm-220'
   END IF
  #-MOD-B40172-end-
   IF p_cmd = 'a' THEN
      LET g_fgb[l_ac].fgd02 = l_fgd02
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY g_fgb[l_ac].fgd02 TO s_fgb[l_ac].fgd02
   END IF
END FUNCTION
 
FUNCTION i201_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr20,        # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
        l_za05          LIKE za_file.za05,           #No.FUN-680070 VARCHAR(40)
        sr   RECORD LIKE fgb_file.*
 
    IF g_fgb01 IS NULL OR g_fgb01 = ' ' THEN CALL cl_err('','afa-411',0)
        RETURN END IF
    IF g_wc2 IS NULL THEN
 #     CALL cl_err('',-400,0) RETURN END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('afai201') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * ",   #組合出 SQL 指令
              "  FROM fgb_file ",
              " WHERE fgb01 = '",g_fgb01,"' AND ",g_wc2 CLIPPED
 
    PREPARE i201_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i201_co                         # SCROLL CURSOR
         CURSOR FOR i201_p1
 
    START REPORT i201_rep TO l_name
 
    FOREACH i201_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0) 
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i201_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i201_rep
 
    CLOSE i201_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i201_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        sr   RECORD LIKE fgb_file.*,
        l_fgd02  LIKE fgd_file.fgd02 ,
        l_str    STRING
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fgb01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.fgb01
          PRINT COLUMN g_c[31],sr.fgb01;
        ON EVERY ROW
          SELECT fgd02 INTO l_fgd02
           FROM fgd_file
           WHERE fgd01 = sr.fgb03
          LET l_str = sr.fgb03,'/',l_fgd02
          PRINT COLUMN g_c[32],l_str,
                COLUMN g_c[33],sr.fgb04
 
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
#No.FUN-570108 --start--
FUNCTION i201_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("fgb02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i201_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("fgb02",FALSE)
   END IF
END FUNCTION
#No.FUN-570108 --end--
#Patch....NO.MOD-5A0095 <001> #
