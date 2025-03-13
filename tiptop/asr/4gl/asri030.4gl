# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asri030.4gl
# Descriptions...: 機台(生產線)標準產能維護作業
# Date & Author..: 05/12/30 By kim
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/30 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0166 06/11/09 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0191 06/12/01 By kim 增加人工及製費工時及分攤率
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7B0103 07/11/22 By jan 報表格式修改為crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0086 12/01/04 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-C40265 12/04/28 By fengrui參照標準程式 添加g_no_ask，限制PROMPT開窗
# Modify.........: No.TQC-C40231 12/05/08 By fengrui 刪除后如果無上下筆資料，則清空變量
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_sra01         LIKE sra_file.sra01,
    g_sra07         LIKE sra_file.sra07, #TQC-6B0191
    g_sra08         LIKE sra_file.sra08, #TQC-6B0191
   #g_sra01_t       LIKE sra_file.sra01,
    g_sra           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sra02       LIKE sra_file.sra02,   
        ima02       LIKE ima_file.ima02,   
        ima021      LIKE ima_file.ima021,   
        sra03       LIKE sra_file.sra03,   
        sra04       LIKE sra_file.sra04,
        sra05       LIKE sra_file.sra05, #TQC-6B0191
        sra06       LIKE sra_file.sra06, #TQC-6B0191
        sraacti     LIKE sra_file.sraacti
                    END RECORD,
    g_sra_t         RECORD                 
        sra02       LIKE sra_file.sra02,   
        ima02       LIKE ima_file.ima02,   
        ima021      LIKE ima_file.ima021,   
        sra03       LIKE sra_file.sra03,   
        sra04       LIKE sra_file.sra04,
        sra05       LIKE sra_file.sra05, #TQC-6B0191
        sra06       LIKE sra_file.sra06, #TQC-6B0191
        sraacti     LIKE sra_file.sraacti
                    END RECORD,
    g_wc,g_sql      string, 
    g_rec_b         LIKE type_file.num5,     #單身筆數    #No.FUN-680130 SMALLINT
    l_ac            LIKE type_file.num5,     #目前處理的ARRAY CNT #No.FUN-680130 SMALLINT
    g_ss            LIKE type_file.chr1      #No.FUN-680130 VARCHAR(1)
DEFINE g_forupd_sql STRING                   #SELECT ... FOR UPDATE  SQL  
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680130 INTEGER
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose   #No.FUN-680130 SMALLINT
DEFINE g_row_count  LIKE type_file.num10     #No.FUN-680130 INTEGER
DEFINE g_curs_index LIKE type_file.num10     #No.FUN-680130 INTEGER
DEFINE g_jump       LIKE type_file.num10     #No.FUN-680130 INTEGER
DEFINE l_table               STRING          #No.FUN-7BO103                                                                  
DEFINE g_str                 STRING          #No.FUN-7B0103
DEFINE g_msg        LIKE type_file.chr1000   #No.FUN-680130 VARCHAR(100)
DEFINE g_sra03_t    LIKE sra_file.sra03      #No.FUN-BB0086 
DEFINE g_no_ask     LIKE type_file.num5      #TQC-C40265

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680130 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
 
#No.FUN-7B0103--BEGIN--
   LET g_sql="sra01.sra_file.sra01,",
             "eci06.eci_file.eci06,",
             "sra02.sra_file.sra02,",
             "sra03.sra_file.sra03,",
             "sra04.sra_file.sra04,",
             "sraacti.sra_file.sraacti,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021"
   LET l_table=cl_prt_temptable("asri030",g_sql) CLIPPED                                                                           
    IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?)"                                                                                           
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err("insert_prep:",status,1)                                                                                         
    END IF                                                                                                                          
#No.FUN-7B0013--END
   LET p_row = 4 LET p_col = 25
   OPEN WINDOW i030_w AT p_row,p_col WITH FORM "asr/42f/asri030"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   #2004/06/02共用程式時呼叫
   CALL cl_set_locale_frm_name("asri030")
   CALL cl_ui_init()
 
   CALL i030_menu()
 
   CLOSE WINDOW i030_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
END MAIN
 
FUNCTION i030_menu()
 
   WHILE TRUE
      CALL i030_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i030_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN 
               CALL i030_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i030_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i030_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i030_r()
            END IF
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_sra01 IS NOT NULL THEN
                  LET g_doc.column1 = "sra01"
                  LET g_doc.value1 = g_sra01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sra),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i030_cs()
    CLEAR FORM
    INITIALIZE g_sra01 TO NULL
    DISPLAY g_sra01 TO sra01
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INITIALIZE g_sra01 TO NULL    #No.FUN-750051
   INITIALIZE g_sra07 TO NULL    #No.FUN-750051
   INITIALIZE g_sra08 TO NULL    #No.FUN-750051
    cONSTRUCT g_wc ON sra01,sra02,sra03,sra04,sra07,sra08,sraacti #TQC-6B0191
         FROM sra01,s_sra[1].sra02,s_sra[1].sra03,
              s_sra[1].sra04,s_sra[1].sra05,s_sra[1].sra06, #TQC-6B0191
              s_sra[1].sraacti 
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(sra02)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.state = "c"
#               LET g_qryparam.default1 = g_sra[1].sra02
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima(TRUE, "q_ima","",g_sra[1].sra02,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO sra02
                NEXT FIELD sra02
              WHEN INFIELD(sra03) #單位主檔
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sra03
                NEXT FIELD sra03
              OTHERWISE
           END CASE
 
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
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    LET g_sql = "SELECT DISTINCT sra01,sra07,sra08 FROM sra_file", #TQC-6B0191
                " WHERE ", g_wc CLIPPED,
                " ORDER BY sra01"
    PREPARE i030_prepare FROM g_sql
    DECLARE i030_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i030_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT sra01) FROM sra_file", #此處不加sra07,sra08也不會錯 #TQC-6B0191
              " WHERE ",g_wc CLIPPED
    PREPARE i030_precount FROM g_sql
    DECLARE i030_count CURSOR FOR i030_precount    
END FUNCTION
 
FUNCTION i030_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sra01 TO NULL               #No.FUN-6A0166
    MESSAGE ""
    CALL cl_opmsg('q')
    INITIALIZE g_sra01 TO NULL
    CLEAR FORM
    CALL g_sra.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i030_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_sra01 TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN i030_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sra01,g_sra07,g_sra08 TO NULL #TQC-6B0191
    ELSE
        OPEN i030_count
        FETCH i030_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt 
        CALL i030_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i030_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680130 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680130 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680130 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680130 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680130 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680130 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sra01) THEN
      CALL cl_err('',-400,1)
      RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    #CKP2
    IF g_rec_b=0 THEN CALL g_sra.clear() END IF
 
    LET g_action_choice = ""
                       
    LET g_forupd_sql = " SELECT sra02,'','',sra03,sra04,sra05,sra06,sraacti FROM sra_file ",  #TQC-6B0191
                       " WHERE  sra01= ? AND sra02= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i030_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    INPUT ARRAY g_sra WITHOUT DEFAULTS FROM s_sra.*
          ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                    INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_sra03_t = NULL   #No.FUN-BB0086
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac      = ARR_CURR()
            LET l_n       = ARR_COUNT()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_sra_t.* = g_sra[l_ac].*  #BACKUP
               LET g_sra03_t = g_sra[l_ac].sra03   #No.FUN-BB0086
               OPEN i030_bcl USING g_sra01,g_sra_t.sra02
               IF STATUS THEN
                  CALL cl_err("OPEN i030_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i030_bcl INTO g_sra[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_sra_t.sra02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     LET g_sra[l_ac].ima02 = ''
                     LET g_sra[l_ac].ima021= ''
                     SELECT ima02,ima021 INTO g_sra[l_ac].ima02,g_sra[l_ac].ima021 FROM ima_file
                       WHERE ima01=g_sra_t.sra02
                     DISPLAY BY NAME g_sra[l_ac].ima02
                     DISPLAY BY NAME g_sra[l_ac].ima021
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sra[l_ac].* TO NULL
            LET g_sra[l_ac].sra04=0
            LET g_sra[l_ac].sraacti = 'Y'       #Body default
            LET g_sra_t.* = g_sra[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sra02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO sra_file(sra01,sra02,sra03,sra04,sra05,sra06,sra07,sra08,sraacti) #TQC-6B0191
                          VALUES(g_sra01,g_sra[l_ac].sra02,g_sra[l_ac].sra03,
                                 g_sra[l_ac].sra04,g_sra[l_ac].sra05,g_sra[l_ac].sra06, #TQC-6B0191
                                 g_sra07,g_sra08,g_sra[l_ac].sraacti)  #TQC-6B0191
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_sra[l_ac].sra02,SQLCA.sqlcode,0)   #No.FUN-660138
               CALL cl_err3("ins","sra_file",g_sra01,g_sra[l_ac].sra02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD sra02                        #check 編號是否重複
            IF NOT cl_null(g_sra[l_ac].sra02) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_sra[l_ac].sra02,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_sra[l_ac].sra02= g_sra_t.sra02 
                  NEXT FIELD sra02
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               IF g_sra[l_ac].sra02 != g_sra_t.sra02 
                  OR g_sra_t.sra02 IS NULL THEN
                  LET l_n=0
                  SELECT count(*) INTO l_n FROM sra_file
                     WHERE sra01 = g_sra01
                       AND sra02 = g_sra[l_ac].sra02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_sra[l_ac].sra02 = g_sra_t.sra02
                     NEXT FIELD sra02
                  END IF
                  CALL i030_sra02()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     LET g_sra[l_ac].sra02 =g_sra_t.sra02
                     LET g_sra[l_ac].ima02 =g_sra_t.ima02
                     LET g_sra[l_ac].ima021=g_sra_t.ima021
                     LET g_sra[l_ac].sra03 =g_sra_t.sra03
                     DISPLAY BY NAME g_sra[l_ac].sra02,
                                     g_sra[l_ac].ima02,
                                     g_sra[l_ac].ima021,
                                     g_sra[l_ac].sra03
                     NEXT FIELD sra02
                  END IF
               END IF
            ELSE
              #NEXT FIELD sra02
            END IF
 
        AFTER FIELD sra03
            IF NOT cl_null(g_sra[l_ac].sra03) THEN 
               LET l_n=0
               SELECT count(*) INTO l_n FROM gfe_file
                  WHERE gfe01 = g_sra[l_ac].sra03
               IF l_n=0 THEN
                  CALL cl_err(g_sra[l_ac].sra03,100,1)
                  LET g_sra[l_ac].sra03=g_sra_t.sra03
                  NEXT FIELD sra03
               END IF
               #No.FUN-BB0086--add--begin--
               CALL i030_sra04_check()
               LET g_sra03_t = g_sra[l_ac].sra03
               #No.FUN-BB0086--add--end--
            END IF
        #TQC-6B0191......................begin
        AFTER FIELD sra04
           CALL i030_sra04_check()   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           # IF NOT cl_null(g_sra[l_ac].sra04) AND (g_sra[l_ac].sra04<>0)THEN 
           #    IF (g_sra[l_ac].sra04<>g_sra_t.sra04) OR
           #       (g_sra_t.sra04 IS NULL) THEN
           #       LET g_sra[l_ac].sra06=1/g_sra[l_ac].sra04
           #       DISPLAY BY NAME g_sra[l_ac].sra06
           #    END IF
           # ELSE
           #    LET g_sra[l_ac].sra06=0
           #    DISPLAY BY NAME g_sra[l_ac].sra06
           # END IF        
           ##TQC-6B0191......................end
           #No.FUN-BB0086--mark--end--
        
	      AFTER FIELD sraacti
            IF NOT cl_null(g_sra[l_ac].sraacti) THEN
               IF g_sra[l_ac].sraacti NOT MATCHES '[YN]' THEN 
                  LET g_sra[l_ac].sraacti = g_sra_t.sraacti
                  NEXT FIELD sraacti
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_sra_t.sra02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM sra_file WHERE sra01 = g_sra01 AND sra02=g_sra_t.sra02
                IF (SQLCA.sqlcode) OR SQLCA.sqlerrd[3]=0 THEN
                   CALL cl_err(g_sra_t.sra02,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sra[l_ac].* = g_sra_t.*
               CLOSE i030_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sra[l_ac].sra02,-263,1)
               LET g_sra[l_ac].* = g_sra_t.*
            ELSE
               UPDATE sra_file SET sra01=g_sra01,
                                   sra02=g_sra[l_ac].sra02,
                                   sra03=g_sra[l_ac].sra03,
                                   sra04=g_sra[l_ac].sra04,
                                   sra05=g_sra[l_ac].sra05, #TQC-6B0191
                                   sra06=g_sra[l_ac].sra06, #TQC-6B0191
                                   sraacti=g_sra[l_ac].sraacti
                WHERE sra01 = g_sra01
                  AND sra02 = g_sra_t.sra02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_sra[l_ac].sra02,SQLCA.sqlcode,0)   #No.FUN-660138
                   CALL cl_err3("upd","sra_file",g_sra01,g_sra_t.sra02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
                   LET g_sra[l_ac].* = g_sra_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac          #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sra[l_ac].* = g_sra_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_sra.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE i030_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac          #FUN-D40030 add
            CLOSE i030_bcl
            COMMIT WORK
            CALL g_sra.deleteElement(g_rec_b+1)   
 
#FUN-510041 add
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(sra02)     
#FUN-AA0059---------mod------------str----------------- 
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_sra[l_ac].sra02
#                  CALL cl_create_qry() RETURNING g_sra[l_ac].sra02
                   CALL q_sel_ima(FALSE, "q_ima","",g_sra[l_ac].sra02,"","","","","",'' ) 
                     RETURNING g_sra[l_ac].sra02  
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_sra[l_ac].sra02
                   NEXT FIELD sra02
                WHEN INFIELD(sra03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gfe"
                   CALL cl_create_qry() RETURNING g_sra[l_ac].sra03
                   DISPLAY BY NAME g_sra[l_ac].sra03
                   NEXT FIELD sra03
                OTHERWISE
            END CASE
##
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sra01) AND l_ac > 1 THEN
                LET g_sra[l_ac].* = g_sra[l_ac-1].*
                NEXT FIELD sra02
            END IF
 
        ON ACTION CONTROLZ
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
    
    END INPUT
 
    CLOSE i030_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i030_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
    LET g_sql =
        "SELECT sra02,'','',sra03,sra04,sra05,sra06,sraacti FROM sra_file ", #TQC-6B0191
        " WHERE sra01='",g_sra01,"' AND ", p_wc CLIPPED,                     #單身
        " ORDER BY sra02"
    PREPARE i030_pb FROM g_sql
    DECLARE sra_curs CURSOR FOR i030_pb
 
    CALL g_sra.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    MESSAGE "Searching!" 
    FOREACH sra_curs INTO g_sra[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      LET g_sra[g_cnt].ima02 =''
      LET g_sra[g_cnt].ima021 =''
      SELECT ima02,ima021 INTO g_sra[g_cnt].ima02,g_sra[g_cnt].ima021 FROM ima_file
        WHERE ima01=g_sra[g_cnt].sra02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      
    END FOREACH
    CALL g_sra.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i030_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sra TO s_sra.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
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
 
      ON ACTION first 
         CALL i030_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL i030_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump
         CALL i030_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL i030_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last
         CALL i030_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-503067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-503067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i030_out()
    DEFINE
        l_sra           RECORD LIKE sra_file.*,
        l_ima02         LIKE ima_file.ima02,       #No.FUN-7B0103
        l_ima021        LIKE ima_file.ima021,      #No.FUN-7B0103
        l_eci06         LIKE eci_file.eci06,       #No.FUN-7BO103
        l_name          LIKE type_file.chr20       # External(Disk) file name   #No.FUN-680130 VARCHAR(20)
 
    IF g_wc IS NULL AND cl_null(g_sra01) THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
 
    CALL cl_wait()
    CALL cl_del_data(l_table)                                #No.FUN-7B0103
    LET g_str=''                                             #No.FUN-7B0103
    SELECT zz05 INTO g_zz05 FROM  zz_file WHERE zz01=g_prog  #No.FUN-7B0103
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    IF NOT g_wc IS NULL THEN
      LET g_sql="SELECT * FROM sra_file ",          # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED
    ELSE
      LET g_sql="SELECT * FROM sra_file ",          # 組合出 SQL 指令
                " WHERE sra01='", g_sra01 ,"'"
 
    END IF
    PREPARE i030_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i030_co                         # SCROLL CURSOR
         CURSOR FOR i030_p1
 
#   CALL cl_outnam('asri030') RETURNING l_name     #No.FUN-7B0103
 
#   START REPORT i030_rep TO l_name                #No.FUN-7B0103
 
    FOREACH i030_co INTO l_sra.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#No.FUN-7B0103--BEGIN--
        LET l_ima02 = ''
        LET l_ima021 = ''
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
         WHERE ima01 = l_sra.sra02
        LET l_eci06 =''
        SELECT eci06 INTO l_eci06 FROM eci_file
         WHERE eci01 = l_sra.sra01
#       OUTPUT TO REPORT i030_rep(l_sra.*)
        EXECUTE insert_prep USING l_sra.sra01,l_eci06,l_sra.sra02,l_sra.sra03,
                                  l_sra.sra04,l_sra.sraacti,l_ima02,l_ima021
#No.FUN-7BO103--END--
    END FOREACH
 
#No;FUN-7B0103--BEGIN--
#   FINISH REPORT i030_rep
 
#   CLOSE i030_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                  
    IF g_zz05='Y' THEN                                                                                                              
       CALL cl_wcchp(g_wc,'sra01,sra02,sra03,sra04,sra07,sra08,sraacti')                                                                 
       RETURNING g_wc                                                                                                              
    END IF                                                                                                                          
    LET g_str=g_wc                                                                                                                 
    CALL cl_prt_cs3('asri030','asri030',g_sql,g_str)                                                                                
#No.FUN-7B0103--END
END FUNCTION
 
#處理資料的讀取
FUNCTION i030_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   #No.FUN-680130 VARCHAR(1)
   l_abso          LIKE type_file.num10   #絕對的筆數 #No.FUN-680130 INTEGER
 
   MESSAGE ""
   LET l_abso = g_jump  #TQC-C40265 add
   CASE p_flag
       WHEN 'N' FETCH NEXT     i030_cs INTO g_sra01,g_sra07,g_sra08 #TQC-6B0191
       WHEN 'P' FETCH PREVIOUS i030_cs INTO g_sra01,g_sra07,g_sra08 #TQC-6B0191
       WHEN 'F' FETCH FIRST    i030_cs INTO g_sra01,g_sra07,g_sra08 #TQC-6B0191
       WHEN 'L' FETCH LAST     i030_cs INTO g_sra01,g_sra07,g_sra08 #TQC-6B0191
       WHEN '/' 
          IF (NOT g_no_ask) THEN       #TQC-C40265 add
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
 
             ON ACTION about         #MOD-4C0121
                CALL cl_about()      #MOD-4C0121
 
             ON ACTION help          #MOD-4C0121
                CALL cl_show_help()  #MOD-4C0121
 
             ON ACTION controlg      #MOD-4C0121
                CALL cl_cmdask()     #MOD-4C0121
 
          
             END PROMPT
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
          LET g_no_ask = FALSE #TQC-C40265 add
#         FETCH ABSOLUTE l_abso i030_cs INTO g_sra01                  #No.TQC-720019
          FETCH ABSOLUTE l_abso i030_cs INTO g_sra01,g_sra07,g_sra08  #No.TQC-720019
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_sra01,SQLCA.sqlcode,0)
      INITIALIZE g_sra01 TO NULL  #TQC-6B0105
      INITIALIZE g_sra07 TO NULL  #TQC-6B0105
      INITIALIZE g_sra08 TO NULL  #TQC-6B0105
   ELSE
      CALL i030_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
   
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i030_show()
   DISPLAY g_sra01 TO sra01                #單頭
   DISPLAY g_sra07 TO sra07                #單頭 #TQC-6B0191
   DISPLAY g_sra08 TO sra08                #單頭 #TQC-6B0191
   CALL i030_sra01()
   CALL i030_b_fill(g_wc)                      #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i030_sra01()
   DEFINE l_eci06   LIKE eci_file.eci06,
          l_eciacti LIKE eci_file.eciacti
   LET g_errno = " "
   SELECT eci06,eciacti INTO l_eci06,l_eciacti
     FROM eci_file WHERE eci01 = g_sra01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
        WHEN l_eciacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
      DISPLAY l_eci06 TO FORMONLY.eci06
   END IF
END FUNCTION
 
FUNCTION i030_sra02()
   DEFINE l_ima01   LIKE ima_file.ima01,
          l_imaacti LIKE ima_file.imaacti,
          l_ima55   LIKE ima_file.ima55
 
   LET g_errno = " "
   SELECT ima01,imaacti INTO l_ima01,l_imaacti
     FROM ima_file WHERE ima01 = g_sra[l_ac].sra02
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
        WHEN l_imaacti='N' LET g_errno = '9028'
   #FUN-690022------mod-------
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
   #FUN-690022------mod-------        
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
     LET g_sra[l_ac].ima02 = ''
     LET g_sra[l_ac].ima021= ''
     SELECT ima02,ima021,ima55 INTO g_sra[l_ac].ima02,
       g_sra[l_ac].ima021,g_sra[l_ac].sra03 FROM ima_file
        WHERE ima01=g_sra[l_ac].sra02
     DISPLAY BY NAME g_sra[l_ac].ima02
     DISPLAY BY NAME g_sra[l_ac].ima021
     DISPLAY BY NAME g_sra[l_ac].sra03
   END IF
END FUNCTION
 
FUNCTION i030_r()
  DEFINE l_cnt LIKE type_file.num10          #No.FUN-680130 INTEGER
  IF s_shut(0) THEN RETURN END IF
  IF g_sra01 IS NULL THEN 
    CALL cl_err('',-400,0) 
    RETURN 
  END IF
  IF cl_delh(15,16) THEN
      INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "sra01"      #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_sra01       #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                                       #No.FUN-9B0098 10/02/24
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM sra_file WHERE sra01=g_sra01
    BEGIN WORK
    DELETE FROM sra_file WHERE sra01=g_sra01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]<>l_cnt THEN
#     CALL cl_err('del sra: ',SQLCA.SQLCODE,1)   #No.FUN-660138
      CALL cl_err3("del","sra_file",g_sra01,"",SQLCA.sqlcode,"","del sra:",1)  #No.FUN-660138
      ROLLBACK WORK
      RETURN    
    END IF
    COMMIT WORK
    CLEAR FORM
    CALL g_sra.clear()
    OPEN i030_count
    #TQC-C40265--mark--str--
    ##FUN-B50064-add-start--
    #IF STATUS THEN
    #   CLOSE i030_cs
    #   CLOSE i030_count
    #   COMMIT WORK
    #   RETURN
    #END IF
    ##FUN-B50064-add-end-- 
    #TQC-C40265--mark--end--
    FETCH i030_count INTO g_row_count
    #TQC-C40265--mark--str--
    ##FUN-B50064-add-start--
    #IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
    #   CLOSE i030_cs
    #   CLOSE i030_count
    #   COMMIT WORK
    #   RETURN
    #END IF
    ##FUN-B50064-add-end-- 
    #TQC-C40265--mark--end
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i030_cs
    IF g_row_count >= 1 THEN      #TQC-C40265 add
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i030_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE     #TQC-C40265 add
          CALL i030_fetch('/')
       END IF    
    ELSE
       LET g_sra01 = NULL #TQC-C40231
    END IF
    MESSAGE 'DELETE O.K'          #TQC-C40265 add 
  END IF
END FUNCTION
 
FUNCTION i030_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_sra.clear()
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i030_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_sra01 IS NULL THEN CONTINUE WHILE END IF
 
      LET g_rec_b=0                   #No.FUN-680064
      IF g_ss='N' THEN
         CALL g_sra.clear() 
      ELSE
         CALL i030_b_fill('1=1')            #單身
      END IF
 
      CALL i030_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i030_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改   #No.FUN-680130 VARCHAR(1)
    l_cnt           LIKE type_file.num5                      #No.FUN-680130 SMALLINT
 
    LET g_ss='Y'
 
    INITIALIZE g_sra01,g_sra07,g_sra08 TO NULL #TQC-6B0191
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT g_sra01,g_sra07,g_sra08 WITHOUT DEFAULTS FROM sra01,sra07,sra08 #TQC-6B0191
    
    AFTER FIELD sra01 
       IF cl_null(g_sra01) THEN
         NEXT FIELD sra01
       ELSE  
         CALL i030_sra01()
         IF NOT cl_null(g_errno) THEN
           Call cl_err('',g_errno,1)
           NEXT FIELD sra01
         END IF
         IF p_cmd='a' THEN
           LET l_cnt=0
           SELECT COUNT(DISTINCT sra01) INTO l_cnt FROM sra_file
             WHERE sra01=g_sra01
           IF l_cnt>0 THEN
             CALL cl_err(g_sra01,'asr-001',1)
             NEXT FIELD sra01
           END IF
         END IF
       END IF
 
       ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON ACTION CONTROLP
         IF INFIELD(sra01) THEN        
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_eci"
           CALL cl_create_qry() RETURNING g_sra01
            DISPLAY BY NAME g_sra01
           NEXT FIELD sra01
         END IF
 
       ON ACTION CONTROLZ
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
END FUNCTION
 
#No.FUN-7BO103--BEGIN
{
REPORT i030_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680130 VARCHAR(1)
        l_ima02         LIKE ima_file.ima02,
        l_ima021        LIKE ima_file.ima021,
        l_eci06         LIKE eci_file.eci06,
        sr RECORD LIKE sra_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sra01,sr.sra02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
            PRINTX name=H2 g_x[37],g_x[38],g_x[39]
            PRINTX name=H3 g_x[40],g_x[41],g_x[42]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            LET l_ima02 = ''
            LET l_ima021 = ''
            SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
              WHERE ima01 = sr.sra02
            LET l_eci06 =''
            SELECT eci06 INTO l_eci06 FROM eci_file
              WHERE eci01 = sr.sra01
            PRINTX name=D1 COLUMN g_c[31],sr.sra01,
                           COLUMN g_c[32],l_eci06,  
                           COLUMN g_c[33],sr.sra02,
                           COLUMN g_c[34],sr.sra03,
                           COLUMN g_c[35],cl_numfor(sr.sra04,35,3),
                           COLUMN g_c[36],sr.sraacti
            PRINTX name=D2 COLUMN g_c[39],l_ima02
            PRINTX name=D3 COLUMN g_c[42],l_ima021
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-7B0103--END
 
#TQC-6B0191..........begin
FUNCTION i030_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_sra01 IS NULL THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
   CALL cl_opmsg('u')
   BEGIN WORK

   LET g_sql="SELECT sra07,sra08 FROM sra_file  WHERE sra01='",
             g_sra01,"' FOR UPDATE"
   LET g_sql = cl_forupd_sql(g_sql)

   PREPARE i030_cl_p FROM g_sql
   DECLARE i030_cl CURSOR FOR i030_cl_p
   OPEN i030_cl 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","sra_file",g_sra01,"",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
   FETCH i030_cl INTO g_sra07,g_sra08
   INPUT g_sra07,g_sra08 WITHOUT DEFAULTS FROM sra07,sra08
    
       ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON ACTION CONTROLZ
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
    CLOSE i030_cl
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
    UPDATE sra_file SET sra07=g_sra07,sra08=g_sra08
                  WHERE sra01=g_sra01
    COMMIT WORK
    CALL i030_show()
END FUNCTION
#TQC-6B0191..........end

#No.FUN-BB0086--add--begin--
FUNCTION i030_sra04_check()
   IF NOT cl_null(g_sra[l_ac].sra04) AND NOT cl_null(g_sra[l_ac].sra03) THEN
      IF cl_null(g_sra_t.sra04) OR cl_null(g_sra03_t) OR g_sra_t.sra04 != g_sra[l_ac].sra04 OR g_sra03_t != g_sra[l_ac].sra03 THEN
         LET g_sra[l_ac].sra04=s_digqty(g_sra[l_ac].sra04,g_sra[l_ac].sra03)
         DISPLAY BY NAME g_sra[l_ac].sra04
      END IF
   END IF
   
   IF NOT cl_null(g_sra[l_ac].sra04) AND (g_sra[l_ac].sra04<>0)THEN 
      IF (g_sra[l_ac].sra04<>g_sra_t.sra04) OR
         (g_sra_t.sra04 IS NULL) THEN
         LET g_sra[l_ac].sra06=1/g_sra[l_ac].sra04
         DISPLAY BY NAME g_sra[l_ac].sra06
      END IF
   ELSE
      LET g_sra[l_ac].sra06=0
      DISPLAY BY NAME g_sra[l_ac].sra06
   END IF     
END FUNCTION
#No.FUN-BB0086--add--end--
