# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: aooi035_1.4gl
# Descriptions...: 部門名稱
# Date & Author..: 91/06/21 By Lee
# Modify.........: 95/03/11 By Danny (加OUTER gea_file)
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510027 05/01/13 By pengu 報表轉XML
# Modify.........: No.MOD-550119 05/05/17 By pengu  報表格式錯誤
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-640194 06/04/17 By Echo  在 ON LAST ROW 用 NEED 控制跳頁正常
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/09/15 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760083 07/07/06 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_hrbua           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
       # hrbua01       LIKE hrbua_file.hrbua01,   #員工編號
        hrbua02       LIKE hrbua_file.hrbua02,   #員工姓名
        hrbua03       LIKE hrbua_file.hrbua03,   #部門編號
        hrbua04      LIKE hrbua_file.hrbua04
                    END RECORD,
    g_hrbua_t         RECORD                 #程式變數 (舊值)
       # hrbua01       LIKE hrbua_file.hrbua01,   #員工編號
        hrbua02       LIKE hrbua_file.hrbua02,   #員工姓名
        hrbua03       LIKE hrbua_file.hrbua03,   #部門編號
        hrbua04      LIKE hrbua_file.hrbua04
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE g_before_input_done   LIKE type_file.num5      #No.FUN-680102 SMALLINT      #FUN-570110
DEFINE   g_i             LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE l_table           STRING                   #No.FUN-760083
DEFINE g_str             STRING                   #No.FUN-760083
DEFINE g_arg00      STRING

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0081
DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680102 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-760083  --BEGIN--
    LET g_sql=
              "hrbua02.hrbua_file.hrbua02,",
              "hrbua03.hrbua_file.hrbua03,",
              "hrbua04.hrbua_file.hrbua04"
    LET l_table=cl_prt_temptable("ghri035_1",g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err("insert_prep:",status,1)
    END IF
#No.FUN-760083  --END--
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i035_1_w AT p_row,p_col WITH FORM "ghr/42f/ghri035_1"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_arg00 = ARG_VAL(1)
   
    IF cl_null(g_arg00) THEN
       LET g_wc2 = '1=1' 
    ELSE
       LET g_wc2 = "hrbua01 ='",g_arg00,"'"
    END IF
    CALL i035_1_b_fill(g_wc2)
    CALL i035_1_menu()
    CLOSE WINDOW i035_1_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i035_1_menu()
 
   WHILE TRUE
      CALL i035_1_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i035_1_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i035_1_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        # WHEN "output"
        #    IF cl_chk_act_auth() THEN
        #       CALL i035_1_out()
        #    END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
      #    WHEN "related_document"  #No.MOD-470515
      #      IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
      #         IF g_hrbua[l_ac].hrbua01 IS NOT NULL THEN
      #            LET g_doc.column1 = "hrbua01"
      #            LET g_doc.value1 = g_hrbua[l_ac].hrbua01
      #            CALL cl_doc()
      #         END IF
      #      END IF
      #   WHEN "exporttoexcel"   #No.FUN-4B0020
      #      IF cl_chk_act_auth() THEN
      #        CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbua),'','')
      #      END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i035_1_q()
   CALL i035_1_b_askkey()
END FUNCTION
 
FUNCTION i035_1_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,      #No.FUN-680102 SMALLINT,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),               #單身鎖住否
    p_cmd           LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),               #處理狀態
    l_allow_insert  LIKE type_file.chr1,      # Prog. Version..: '5.30.03-12.09.18(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,       # Prog. Version..: '5.30.03-12.09.18(01)               #可刪除否
    l_hrbua01        LIKE hrbua_file.hrbua01
 
    LET l_hrbua01 = g_arg00
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbua02,hrbua03,hrbua04 FROM hrbua_file",
    #                   " WHERE hrbua01=? FOR UPDATE"
                       " WHERE hrbua01=? AND hrbua02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i035_1_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrbua WITHOUT DEFAULTS FROM s_hrbua.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
{#No.FUN-570110 --start                                                          
               LET g_before_input_done = FALSE                                  
               CALL i035_1_set_entry(p_cmd)                                       
               CALL i035_1_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
#No.FUN-570110 --end 
}            
               LET g_hrbua_t.* = g_hrbua[l_ac].*  #BACKUP
 
              # OPEN i035_1_bcl USING l_hrbua01 
               OPEN i035_1_bcl USING l_hrbua01,g_hrbua[l_ac].hrbua02
               IF STATUS THEN
                  CALL cl_err("OPEN i035_1_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i035_1_bcl INTO g_hrbua[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     #CALL cl_err(g_hrbua_t.hrbua01,SQLCA.sqlcode,1)
                     CALL cl_err(g_hrbua_t.hrbua02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
              # SELECT gea02  INTO g_hrbua[l_ac].gea02 FROM gea_file
              #  WHERE g_hrbua[l_ac].hrbua03 = gea01
              # CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
{#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL i035_1_set_entry(p_cmd)                                           
           CALL i035_1_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end  
}      
           INITIALIZE g_hrbua[l_ac].* TO NULL      #900423
           #LET g_hrbua[l_ac].hrbuaacti = 'Y'       #Body default
           LET g_hrbua_t.* = g_hrbua[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hrbua02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i035_1_bcl
              CANCEL INSERT
           END IF
           INSERT INTO hrbua_file(hrbua01,hrbua02,hrbua03,hrbua04,hrbuauser,hrbuadate,hrbuaoriu,hrbuaorig)
                         VALUES(l_hrbua01,g_hrbua[l_ac].hrbua02,
                                g_hrbua[l_ac].hrbua03,g_hrbua[l_ac].hrbua04,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
 #             CALL cl_err(g_hrbua[l_ac].hrbua01,SQLCA.sqlcode,0)    #No.FUN-660131
               #CALL cl_err3("ins","hrbua_file",g_hrbua[l_ac].hrbua01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CALL cl_err3("ins","hrbua_file",g_hrbua[l_ac].hrbua02,"",SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD hrbua02                        #check 編號是否重複
            IF NOT cl_null(g_hrbua[l_ac].hrbua02) THEN
               IF g_hrbua[l_ac].hrbua02 != g_hrbua_t.hrbua02 OR
                  g_hrbua_t.hrbua02 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM hrbua_file
                       WHERE hrbua01 = l_hrbua01
                       AND hrbua02 = g_hrbua[l_ac].hrbua02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_hrbua[l_ac].hrbua02 = g_hrbua_t.hrbua02
                       NEXT FIELD hrbua02
                   END IF
               END IF
            END IF
 
 
       AFTER FIELD hrbua03
           IF g_hrbua[l_ac].hrbua03 IS NULL THEN
           	 CALL cl_err('该栏位不可为空','!',1)
           	 NEXT FIELD hrbua03
           ELSE
             DISPLAY BY NAME g_hrbua[l_ac].hrbua03
           END IF
                                                  	
       {AFTER FIELD hrbuaacti
          IF NOT cl_null(g_hrbua[l_ac].hrbuaacti) THEN
             IF g_hrbua[l_ac].hrbuaacti NOT MATCHES '[YN]' THEN
                LET g_hrbua[l_ac].hrbuaacti = g_hrbua_t.hrbuaacti
                NEXT FIELD hrbuaacti
             END IF
          END IF
       }
        BEFORE DELETE                            #是否取消單身
            IF g_hrbua_t.hrbua02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "hrbua02"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_hrbua[l_ac].hrbua02      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM hrbua_file WHERE hrbua01 = l_hrbua01 AND hrbua01=g_hrbua[l_ac].hrbua02
                IF SQLCA.sqlcode THEN
 #                   CALL cl_err(g_hrbua_t.hrbua01,SQLCA.sqlcode,0)    #No.FUn-660131
                     CALL cl_err3("del","hrbua_file",g_hrbua_t.hrbua02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrbua[l_ac].* = g_hrbua_t.*
              CLOSE i035_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrbua[l_ac].hrbua02,-263,0)
               LET g_hrbua[l_ac].* = g_hrbua_t.*
           ELSE
               UPDATE hrbua_file SET hrbua01=l_hrbua01,
                                   hrbua02=g_hrbua[l_ac].hrbua02,
                                   hrbua03=g_hrbua[l_ac].hrbua03,
                                   hrbua04=g_hrbua[l_ac].hrbua04,
                                   hrbuamodu=g_user,
                                   hrbuadate=g_today
                WHERE hrbua01 = l_hrbua01
                AND hrbua02 = g_hrbua_t.hrbua02   #add by lifang 130522
               IF SQLCA.sqlcode THEN
 #                 CALL cl_err(g_hrbua[l_ac].hrbua01,SQLCA.sqlcode,0)   #No.FUN-660131
                   CALL cl_err3("upd","hrbua_file",g_hrbua_t.hrbua02,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrbua[l_ac].* = g_hrbua_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrbua[l_ac].* = g_hrbua_t.*
              END IF
              CLOSE i035_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i035_1_bcl
           COMMIT WORK
 
      { ON ACTION controlp
           CASE WHEN INFIELD(hrbua03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gea"
                   LET g_qryparam.default1 = g_hrbua[l_ac].hrbua03
                   CALL cl_create_qry() RETURNING g_hrbua[l_ac].hrbua03
                   DISPLAY g_hrbua[l_ac].hrbua03 TO hrbua03
#                  CALL FGL_DIALOG_SETBUFFER( g_hrbua[l_ac].hrbua03 )
                   CALL i035_1_hrbua03('a')
                OTHERWISE
                   EXIT CASE
            END CASE
       }
       #ON ACTION CONTROLN
       #    CALL i035_1_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(hrbua01) AND l_ac > 1 THEN
                LET g_hrbua[l_ac].* = g_hrbua[l_ac-1].*
                NEXT FIELD hrbua01
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
 
 
    CLOSE i035_1_bcl
    COMMIT WORK
END FUNCTION
 
{FUNCTION i035_1_hrbua03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),
    l_geaacti       LIKE gea_file.geaacti
 
    LET g_errno = ' '
    SELECT gea02,geaacti INTO g_hrbua[l_ac].gea02,l_geaacti
        FROM gea_file
        WHERE gea01 = g_hrbua[l_ac].hrbua03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-061'
                            LET g_hrbua[l_ac].gea02 = NULL
         WHEN l_geaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 }
FUNCTION i035_1_b_askkey()
 
    CLEAR FORM
   CALL g_hrbua.clear()
 
    CONSTRUCT g_wc2 ON hrbua02,hrbua03,hrbua04
         FROM s_hrbua[1].hrbua02,s_hrbua[1].hrbua03,s_hrbua[1].hrbua04
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       {  ON ACTION controlp
             CASE WHEN INFIELD(hrbua03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gea"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_hrbua[1].hrbua03            
                     CALL i035_1_hrbua03('a')
                  OTHERWISE
                     EXIT CASE
              END CASE
       }
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbuauser', 'hrbuagrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i035_1_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i035_1_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT hrbua02,hrbua03,hrbua04 ",
        "  FROM hrbua_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i035_1_pb FROM g_sql
    DECLARE hrbua_curs CURSOR FOR i035_1_pb
 
    CALL g_hrbua.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbua_curs INTO g_hrbua[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbua.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i035_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbua TO s_hrbua.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
#@    ON ACTION 相關文件  
  {     ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   }
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
{FUNCTION i035_1_out()
    DEFINE
        l_hrbua           RECORD LIKE hrbua_file.*,
        l_i             LIKE type_file.num5,      #No.FUN-680102 SMALLINT,
        l_name          LIKE type_file.chr20,     #No.FUN-680102 VARCHAR(20),                # External(Disk) file name
        l_za05          LIKE type_file.chr1000    #No.FUN-680102 VARCHAR(40)                 #
    DEFINE l_gea02      LIKE gea_file.gea02       #No.FUN-760083 
     
    IF g_wc2 IS NULL THEN 
     # CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
    RETURN END IF
    #CALL cl_wait()                                       #No.FUN-760083
    #LET l_name = 'aooi035_1.out'                           #No.FUN-760083
    #CALL cl_outnam('aooi035_1') RETURNING l_name           #No.FUN-760083
    CALL cl_del_data(l_table)                             #No.FUN-760083
    LET g_str=''                                          #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM hrbua_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i035_1_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i035_1_co                         # SCROLL CURSOR
         CURSOR FOR i035_1_p1
 
    #START REPORT i035_1_rep TO l_name                        #No.FUN-760083
 
    FOREACH i035_1_co INTO l_hrbua.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT gea02 INTO l_gea02 FROM gea_file WHERE gea01 = l_hrbua.hrbua03               #No.FUN-760083                              
        #OUTPUT TO REPORT i035_1_rep(l_hrbua.*)                 #No.FUN-760083
        EXECUTE insert_prep USING l_hrbua.hrbua01,l_hrbua.hrbua02,l_hrbua.hrbua03,          #No.FUN-760083
                                  l_hrbua.hrbuaacti,l_hrbua.hrbuadate,l_hrbua.hrbuagrup,    #No.FUN-760083
                                  l_hrbua.hrbuamodu,l_hrbua.hrbuauser,l_gea02           #No.FUN-760083
    END FOREACH
 
    #FINISH REPORT i035_1_rep                                 #No.FUN-760083
 
    CLOSE i035_1_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                      #No.FUN-760083
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED     #No.FUN-760083 
    IF g_zz05='Y' THEN                                                 #No.FUN-760083
        CALL cl_wcchp(g_wc2,'hrbua01,hrbua02,hrbua03,hrbuaacti')               #No.FUN-760083
        RETURNING   g_wc2                                              #No.FUN-760083
    END IF                                                             #No.FUN-760083
    LET g_str=g_wc2                                                    #No.FUN-760083
    CALL cl_prt_cs3("aooi035_1","aooi035_1",g_sql,g_str)                   #No.FUN-760083 
END FUNCTION
 }
#No.FUN-760083
{
REPORT i035_1_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE hrbua_file.*,
        l_gea02   LIKE gea_file.gea02,
        l_chr           LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),
        l_area          LIKE type_file.chr20,     #No.FUN-680102 VARCHAR(20), 
        l_need_lines    LIKE type_file.num10      #No.FUN-680102 INTEGER
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.hrbua01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'                
 
        ON EVERY ROW
	    SELECT gea02 INTO l_gea02 FROM gea_file WHERE gea01 = sr.hrbua03
            LET l_area=sr.hrbua03,'   ',l_gea02
            IF sr.hrbuaacti = 'N' 
                #THEN PRINT g_c[31],'* ';            #No.MOD-550119
                 THEN PRINT COLUMN g_c[31],'* ';     #No.MOD-550119
            END IF
            PRINT COLUMN g_c[32],sr.hrbua01,
                  COLUMN g_c[33],sr.hrbua02,
                  COLUMN g_c[34],l_area
 
        ON LAST ROW
            #FUN-640194
            LET l_need_lines = 2
            NEED l_need_lines LINES
            #END FUN-640194
            
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760083
 
#No.FUN-570110 --start                                                          
{FUNCTION i035_1_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hrbua01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i035_1_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("hrbua01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end     
}
