# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: abmi618.4gl
# Descriptions...: 標準BOM 維護作業
# Date & Author..: 08/06/19 By jan FUN-870127
# Modify.........: No.FUN-8B0023 08/11/06 By arman 元件料號未設置插件則不能入部位 
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:FUN-B10030 11/01/19 By Mengxw Remove "switch_plant"
# Modify.........: No:CHI-C80041 13/02/04 By bart 排除作廢
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bok   RECORD LIKE bok_file.*,
    g_bok_t RECORD LIKE bok_file.*,
    g_bok_o RECORD LIKE bok_file.*,
    g_bok01_t LIKE bok_file.bok01,
    g_bok31_t LIKE bok_file.bok31,
    g_bok29_t LIKE bok_file.bok29, 
    g_bok32_t LIKE bok_file.bok32,            
    b_bmh     RECORD LIKE bmh_file.*,
    g_ima     RECORD LIKE ima_file.*,
    g_wc,g_wc2,g_sql string,                   
    g_bmh           DYNAMIC ARRAY OF RECORD  
        bmh05		LIKE bmh_file.bmh05,
        bmh06		LIKE bmh_file.bmh06,
        bmh07		LIKE bmh_file.bmh07  
                    END RECORD,
    g_bmh_t         RECORD                    #程式變數 (舊值)
        bmh05		LIKE bmh_file.bmh05,
        bmh06		LIKE bmh_file.bmh06,
        bmh07		LIKE bmh_file.bmh07 
                    END RECORD,
    tot		          LIKE bok_file.bok06,       
    g_buf           LIKE type_file.chr1000,    # VARCHAR(78)
    g_rec_b         LIKE type_file.num5,       # SMALLINT,   #單身筆數
    l_ac            LIKE type_file.num5,       # SMALLINT,   #目前處理的ARRAY CNT
    g_ls            LIKE type_file.chr1,       # VARCHAR(1), #No.FUN-590110
    g_argv1         LIKE bok_file.bok01,         
    g_argv2         LIKE bok_file.bok31,                
    g_argv3         LIKE bok_file.bok32       #No.FUN-870127                
 
DEFINE   p_row,p_col     LIKE type_file.num5    #No.FUN-680096  SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ...
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680096  INTEGER
DEFINE   g_i             LIKE type_file.num5    #No.FUN-680096  SMALLINT   #count/index for any purpose
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-680096  VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-680096  INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-680096  INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-680096  INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680096  SMALLINT
DEFINE   l_table         STRING,                ### FUN-770052 ###                                                                  
         g_str           STRING                 ### FUN-770052 ###
DEFINE g_sql_tmp    STRING
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2) 
    LET g_argv3=ARG_VAL(3)   #No.FUN-870127
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
    OPEN WINDOW i618_w AT p_row,p_col
         WITH FORM "abm/42f/abmi618"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    
    CALL cl_set_comp_visible("bok29",g_sma.sma118='Y')
   
 
    CALL i618()
    IF NOT cl_null(g_argv1) THEN
        CALL i618_q()
    END IF
    CALL i618_menu()
 
    CLOSE WINDOW i618_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i618()
    INITIALIZE g_bok.* TO NULL
    INITIALIZE g_bok_t.* TO NULL
    INITIALIZE g_bok_o.* TO NULL
    CALL i618_lock_cur()
END FUNCTION
 
FUNCTION i618_lock_cur()
 
    LET g_forupd_sql =
        "SELECT * FROM bok_file WHERE bok01 = g_bok.bok01 AND bok31 = g_bok.bok31 AND bok32 = g_bok.bok32 FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i618_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION i618_cs()
DEFINE  lc_qbe_sn      LIKE    gbm_file.gbm01    
    CLEAR FORM
    CALL g_bmh.clear()
    IF cl_null(g_argv1) THEN
       CALL cl_set_head_visible("","YES")     
 
   INITIALIZE g_bok.* TO NULL    
       CONSTRUCT BY NAME g_wc ON
              bok31,bok32,bok01,bok29,bok04,bok05,bok03,bok02,bok06,bok07 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON ACTION controlp    #FUN-4B0024
          IF INFIELD(bok01) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_bmb204"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO bok01
             NEXT FIELD bok01
          END IF
          IF INFIELD(bok31) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_boj09"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO bok31
             NEXT FIELD bok31
          END IF
       ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF INT_FLAG THEN RETURN END IF
       CONSTRUCT g_wc2 ON bmh05,bmh06,bmh07
            FROM s_bmh[1].bmh05,s_bmh[1].bmh06,s_bmh[1].bmh07
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
     ELSE
       IF g_argv3 IS NULL THEN 
       LET g_wc="     bok01='",g_argv1,"'", 
                " AND bok31='",g_argv2,"'"  
       ELSE
       LET g_wc="     bok01='",g_argv1,"'", 
                " AND bok31='",g_argv2,"'",  
                " AND bok32='",g_argv3,"'"   #No.FUN-870127
       END IF
 
       LET g_wc2=" 1=1"
    END IF
 
    IF g_wc2=' 1=1' THEN
          LET g_sql="SELECT bok01,bok31,bok32 FROM bok_file ",
                    " WHERE ",g_wc CLIPPED," ORDER BY bok01,bok31,bok32"
 
    ELSE
       LET g_sql="SELECT bok_file.bok01,bok31,bok32",     
                 "  FROM bok_file,bmh_file ",
                 " WHERE bok01=bmh01 AND bok31=bmh09",
                 "   AND bok32=bmh10 ",                                                    
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY bok01,bok31,bok32"                                 
    END IF
    PREPARE i618_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i618_cs SCROLL CURSOR WITH HOLD FOR i618_prepare
    IF g_wc2=' 1=1' THEN
       LET g_sql_tmp= "SELECT UNIQUE bok01,bok31,bok32 FROM bok_file WHERE ",g_wc CLIPPED,
                      "INTO TEMP x"
    ELSE
       LET g_sql_tmp= "SELECT UNIQUE bok01,bok31,bok32 FROM bok_file,bmh_file",
                  " WHERE bok01=bmh01 AND bok31=bmh09",                                                                              
                 "   AND bok32=bmh10 ",                                                                                             
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 "   INTO TEMP x"
    END IF
    DROP TABLE x
    PREPARE i618_precount_x FROM g_sql_tmp
    EXECUTE i618_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i618_precount FROM g_sql
    DECLARE i618_count CURSOR FOR i618_precount
END FUNCTION
 
FUNCTION i618_menu()
 
   WHILE TRUE
      CALL i618_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i618_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i618_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "工廠切換"
          #--FUN-B10030--start--
          #  WHEN "switch_plant"
          #  CALL i618_d()
          #--FUN-B10030--end--
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bok.bok01 IS NOT NULL THEN
                  LET g_doc.column1 = "bok01"
                  LET g_doc.value1  = g_bok.bok01
                  LET g_doc.column2 = "bok31"
                  LET g_doc.value2  = g_bok.bok31
                  LET g_doc.column3 = "bok32"
                  LET g_doc.value3  = g_bok.bok32
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmh),'','')
            END IF
      END CASE
   END WHILE
      CLOSE i618_cs
END FUNCTION
 
 
FUNCTION i618_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bok.* TO NULL             
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i618_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_bmh.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i618_count
    FETCH i618_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i618_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bok.bok01,SQLCA.sqlcode,0)
        INITIALIZE g_bok.* TO NULL
    ELSE
        CALL i618_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i618_fetch(p_flbok)
    DEFINE
        p_flbok    LIKE type_file.chr1      
 
    CASE p_flbok
        WHEN 'N' FETCH NEXT     i618_cs INTO g_bok.bok01,g_bok.bok31,g_bok.bok32 
        WHEN 'P' FETCH PREVIOUS i618_cs INTO g_bok.bok01,g_bok.bok31,g_bok.bok32
        WHEN 'F' FETCH FIRST    i618_cs INTO g_bok.bok01,g_bok.bok31,g_bok.bok32
        WHEN 'L' FETCH LAST     i618_cs INTO g_bok.bok01,g_bok.bok31,g_bok.bok32
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i618_cs INTO g_bok.bok01,g_bok.bok31,g_bok.bok32 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bok.bok01,SQLCA.sqlcode,0)
        INITIALIZE g_bok.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbok
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bok.* FROM bok_file       # 重讀DB,因TEMP有不被更新特性
       WHERE bok01 = g_bok.bok01 AND bok31 = g_bok.bok31 AND bok32 = g_bok.bok32
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bok_file",g_bok.bok01,g_bok.bok31,SQLCA.sqlcode,"","",1)  
    ELSE
        CALL i618_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i618_show()
    LET g_bok_t.* = g_bok.*
    DISPLAY BY NAME
           g_bok.bok31,g_bok.bok32,g_bok.bok01,g_bok.bok29, g_bok.bok02,
           g_bok.bok03,g_bok.bok04, g_bok.bok05, g_bok.bok06,
           g_bok.bok07
    INITIALIZE g_ima.* TO NULL
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_bok.bok01
    DISPLAY BY NAME g_ima.ima02,g_ima.ima021,g_ima.ima25
    INITIALIZE g_ima.* TO NULL
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_bok.bok03
    DISPLAY g_ima.ima02,g_ima.ima021,g_ima.ima25 TO ima02b,ima021b,ima25b
#   CALL i618_b_fill(' 1=1')
    CALL i618_b_fill(g_wc2)
    DISPLAY BY NAME tot
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
#--FUN-B10030--start-- 
#FUNCTION i618_d()
#   DEFINE l_plant,l_dbs	LIKE type_file.chr21   #No.FUN-680096  VARCHAR(21)
 
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE PROMPT
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
 
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
#   CALL cl_ins_del_sid(1,l_plant) #FUN-980030   #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs
#   CALL i618_lock_cur()
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION i618_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,   #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,   #檢查重複用
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否
    p_cmd           LIKE type_file.chr1,   #處理狀態
    l_sfb38         LIKE type_file.dat,    #DATE,
    l_ima107        LIKE ima_file.ima107,
    l_allow_insert  LIKE type_file.num5,   #可新增否
    l_allow_delete  LIKE type_file.num5    #可刪除否
DEFINE l_boj05  LIKE boj_file.boj05  
DEFINE l_bmh07  LIKE bmh_file.bmh07   
DEFINE l_ima147 LIKE ima_file.ima147   
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_bok.bok01 IS NULL THEN RETURN END IF
#TQC-760078.....begin                                                           
    SELECT boj05 INTO l_boj05 FROM boj_file,bok_file
     WHERE boj01 = bok01 AND boj09 = bok31 AND boj01 = g_bok.bok01
       AND bok03 = g_bok.bok03 AND bok04 = g_bok.bok04
       AND bok29 = g_bok.bok29
       AND boj10 <> 'X'  #CHI-C80041
    IF l_boj05 IS NOT NULL AND g_sma.sma101 = 'N' THEN                     
       CALL cl_err('','abm-120',0)                                              
       RETURN                                                                   
    END IF                                                                      
#TQC-760078.....end
    #NO.FUN-8B0023 ---begin
    SELECT ima107 INTO l_ima107  FROM ima_file WHERE ima01 = g_bok.bok03
    IF l_ima107 = 'N'  THEN
       CALL cl_err('','abm-032',0)                                              
       RETURN
    END IF
    #NO.FUN-8B0023  --end
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT bmh05,bmh06,bmh07 ",
      "   FROM bmh_file ",
      "  WHERE bmh01 = ? ",
      "    AND bmh02 = ? ",
      "    AND bmh03 = ? ",
      "    AND bmh04 = ? ",
      "    AND bmh05 = ? ",
      "    AND bmh08 = ? ",  
      "    AND bmh09 = ? ",
      "    AND bmh10 = ? ",
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i618_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
#   BEGIN WORK
    LET g_success = 'Y'
#   LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
     WHILE TRUE #MOD-4B0191(ADD WHILE....END WHILE)
 
        INPUT ARRAY g_bmh WITHOUT DEFAULTS FROM s_bmh.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                #CKP
                BEGIN WORK
                LET p_cmd='u'
                LET g_bmh_t.* = g_bmh[l_ac].*  #BACKUP
 
                OPEN i618_bcl USING g_bok.bok01,g_bok.bok02,g_bok.bok03,g_bok.bok04,g_bmh_t.bmh05,g_bok.bok29,g_bok.bok31,g_bok.bok32 
                IF SQLCA.sqlcode THEN
                    CALL cl_err("OPEN i618_bcl:",SQLCA.sqlcode, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i618_bcl INTO g_bmh[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmh_t.bmh05,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bmh05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            #CHI-790004..................begin
            IF cl_null(g_bok.bok02) THEN
               LET g_bok.bok02=0
            END IF
            #CHI-790004..................end
            INSERT INTO bmh_file(bmh01,bmh02,bmh03,bmh04,
                                bmh05,bmh06,bmh07,bmh08,bmh09,bmh10) #FUN-550014
            VALUES(g_bok.bok01,g_bok.bok02,
                   g_bok.bok03,g_bok.bok04,
                   g_bmh[l_ac].bmh05,g_bmh[l_ac].bmh06,
                   g_bmh[l_ac].bmh07,g_bok.bok29,
                   g_bok.bok31,g_bok.bok32)   
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bmh[l_ac].bmh05,SQLCA.sqlcode,0)   #No.TQC-660046
                CALL cl_err3("ins","bmh_file",g_bok.bok01,g_bmh[l_ac].bmh05,SQLCA.sqlcode,"","",1)  #No.TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
         #by arman 080529 ----BEGIN
         SELECT ima147 INTO l_ima147 FROM ima_file WHERE ima01=g_bok.bok03
           IF l_ima147 != 'Y' THEN     
            SELECT SUM(bmh07) INTO  l_bmh07 FROM bmh_file WHERE bmh01 = g_bok.bok01 
                                                            AND bmh09 = g_bok.bok31
                                                            AND bmh10 = g_bok.bok32
            IF cl_null(l_bmh07) THEN LET l_bmh07 = 1 END IF
            UPDATE bok_file SET bok06 = l_bmh07
                          WHERE bok01 = g_bok.bok01
                            AND bok31 = g_bok.bok31
                            AND bok32 = g_bok.bok32
            IF SQLCA.sqlcode THEN
               CALL cl_err3("update","bok_file",g_bok.bok01,g_bok.bok02,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
            ELSE
                LET g_bok.bok06 = l_bmh07
                DISPLAY BY NAME g_bok.bok06
                MESSAGE 'INSERT O.K'
            END IF
           END IF
            #by arman 080529 --- END 
 
        BEFORE INSERT
            #CKP
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmh[l_ac].* TO NULL      #900423
            LET g_bmh[l_ac].bmh07 = 0
            LET g_bmh_t.* = g_bmh[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmh05
 
        BEFORE FIELD bmh05                        #default 序號
            IF g_bmh[l_ac].bmh05 IS NULL OR
               g_bmh[l_ac].bmh05 = 0 THEN
                SELECT max(bmh05) INTO g_bmh[l_ac].bmh05
                   FROM bmh_file
                   WHERE bmh01 = g_bok.bok01  AND bmh09 = g_bok.bok31
                     AND bmh10 = g_bok.bok32
                IF g_bmh[l_ac].bmh05 IS NULL THEN
                    LET g_bmh[l_ac].bmh05 = 0
                END IF
                LET g_bmh[l_ac].bmh05 = g_bmh[l_ac].bmh05 + g_sma.sma19
            END IF
 
        AFTER FIELD bmh05                        #check 序號是否重複
            IF g_bmh[l_ac].bmh05 IS NULL THEN
               LET g_bmh[l_ac].bmh05 = g_bmh_t.bmh05
            END IF
            IF NOT cl_null(g_bmh[l_ac].bmh05) THEN
                IF g_bmh[l_ac].bmh05 != g_bmh_t.bmh05 OR
                   g_bmh_t.bmh05 IS NULL THEN
                    SELECT count(*) INTO l_n
                        FROM bmh_file
                        WHERE bmh01 = g_bok.bok01 AND bmh02 = g_bok.bok02
                          AND bmh03 = g_bok.bok03 AND bmh04 = g_bok.bok04
                          AND bmh05 = g_bmh[l_ac].bmh05
                          AND bmh08 = g_bok.bok29 
                          AND bmh09 = g_bok.bok31
                          AND bmh10 = g_bok.bok32
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,1)
                        LET g_bmh[l_ac].bmh05 = g_bmh_t.bmh05
                        #------MOD-5A0095 START----------
                        DISPLAY BY NAME g_bmh[l_ac].bmh05
                        #------MOD-5A0095 END------------
                        NEXT FIELD bmh05
                    END IF
                END IF
            END IF
            
        #MOD-590060 add
        AFTER FIELD bmh06
        #080526 by arman
            IF NOT cl_null(g_bmh[l_ac].bmh06) THEN
              SELECT  count(*) INTO l_n FROM bol_file 
                                       WHERE bolacti = 'Y'
                                         AND bol01 = g_bmh[l_ac].bmh06
                IF l_n <= 0 THEN      # 080526 by arman
                  CALL cl_err('','asfi115',1)
                  NEXT FIELD bmh06
                END IF
        #080526 by arman
                LET l_n = 0
                IF g_bmh[l_ac].bmh06 != g_bmh_t.bmh06
                   OR g_bmh_t.bmh06 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bmh_file
                       WHERE bmh01 = g_bok.bok01 AND bmh09 = g_bok.bok31
                         AND bmh10 = g_bok.bok32 AND bmh06 = g_bmh[l_ac].bmh06
                    IF l_n > 0 THEN    
                         CALL cl_err('',-239,1)
                        LET g_bmh[l_ac].bmh06 = g_bmh_t.bmh06
                        NEXT FIELD bmh06
                    END IF
                END IF
            END IF
        #MOD-590060 end
        IF g_bmh_t.bmh06 IS NULL THEN
           NEXT FIELD bmh07
        END IF
 
        AFTER FIELD bmh07
            IF NOT cl_null(g_bmh[l_ac].bmh07) THEN
               IF g_bmh[l_ac].bmh07 <= 0 THEN
                  CALL cl_err(g_bmh[l_ac].bmh07,'afa-043',0)
                  NEXT FIELD bmh07
               END IF
               IF (g_bmh[l_ac].bmh07 - cl_digcut(g_bmh[l_ac].bmh07,0)) <> 0 THEN
                  CALL cl_err(g_bmh[l_ac].bmh07,'abm-981',0)
                  NEXT FIELD bmh07
               END IF
            END IF
        #No.TQC-6B0149 --end
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmh_t.bmh05 > 0 AND g_bmh_t.bmh05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bmh_file
                    WHERE bmh01 = g_bok.bok01 AND bmh02 = g_bok.bok02
                      AND bmh03 = g_bok.bok03 AND bmh04 = g_bok.bok04
                      AND bmh05 = g_bmh_t.bmh05
                      AND bmh08 = g_bok.bok29 #FUN-550014
                      AND bmh09 = g_bok.bok31
                      AND bmh10 = g_bok.bok32
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bmh_t.bmh05,SQLCA.sqlcode,0)   #No.TQC-660046
                    CALL cl_err3("del","bmh_file",g_bok.bok01,g_bmh_t.bmh05,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                SELECT SUM(bmh07) INTO  l_bmh07 FROM bmh_file WHERE bmh01 = g_bok.bok01 
                                                          AND bmh09 = g_bok.bok31
                                                          AND bmh10 = g_bok.bok32
 
                IF cl_null(l_bmh07) THEN LET l_bmh07 = 1 END IF
                UPDATE bok_file SET bok06 = l_bmh07
                              WHERE bok01 = g_bok.bok01
                                AND bok31 = g_bok.bok31
                                AND bok32 = g_bok.bok32
 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("update","bok_file",g_bok.bok01,g_bok.bok02,SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                ELSE
                    LET g_bok.bok06 = l_bmh07
                    DISPLAY BY NAME g_bok.bok06
                    MESSAGE 'INSERT O.K'
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL i618_b_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmh[l_ac].* = g_bmh_t.*
               CLOSE i618_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmh[l_ac].bmh05,-263,1)
                LET g_bmh[l_ac].* = g_bmh_t.*
            ELSE
                UPDATE bmh_file SET
                       bmh05 = g_bmh[l_ac].bmh05,
                       bmh06 = g_bmh[l_ac].bmh06,
                       bmh07 = g_bmh[l_ac].bmh07
                 WHERE bmh01 = g_bok.bok01
                   AND bmh02 = g_bok.bok02
                   AND bmh03 = g_bok.bok03
                   AND bmh04 = g_bok.bok04
                   AND bmh05 = g_bmh_t.bmh05
                   AND bmh08 = g_bok.bok29 #FUN-550014
                   AND bmh09 = g_bok.bok31
                   AND bmh10 = g_bok.bok32
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bmh[l_ac].bmh05,SQLCA.sqlcode,0)   #No.TQC-660046
                    CALL cl_err3("upd","bmh_file",g_bok.bok01,g_bmh_t.bmh05,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    LET g_bmh[l_ac].* = g_bmh_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
             #by arman 080529 ----BEGIN
             SELECT ima147 INTO l_ima147 FROM ima_file WHERE ima01=g_bok.bok03
               IF l_ima147 ! = 'Y' THEN
                SELECT SUM(bmh07) INTO  l_bmh07 FROM bmh_file WHERE bmh01 = g_bok.bok01 
                                                          AND bmh09 = g_bok.bok31
                                                          AND bmh10 = g_bok.bok32
 
                IF cl_null(l_bmh07) THEN LET l_bmh07 = 1 END IF
                UPDATE bok_file SET bok06 = l_bmh07
                              WHERE bok01 = g_bok.bok01
                                AND bok31 = g_bok.bok31
                                AND bok32 = g_bok.bok32
 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("update","bok_file",g_bok.bok01,g_bok.bok02,SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                ELSE
                    LET g_bok.bok06 = l_bmh07
                    DISPLAY BY NAME g_bok.bok06
                    MESSAGE 'INSERT O.K'
                END IF
               END IF
            #by arman 080529 --- END 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
#            IF g_bmh[l_ac].bmh07 <= 0 THEN
#               CALL cl_err(g_bmh[l_ac].bmh07,'afa-043',0)
#               NEXT FIELD bmh07
#            END IF
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmh[l_ac].* = g_bmh_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmh.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i618_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_bmh_t.* = g_bmh[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
 
            #MOD-480365
           CALL i618_up_bok13() #BugNo:4476
           #--
 
            CLOSE i618_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL i618_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLP
        # 080526  -------begin-------------
         CASE WHEN INFIELD(bmh06) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_bmb13"
              LET g_qryparam.default1 = g_bmh[l_ac].bmh06
              CALL cl_create_qry() RETURNING g_bmh[l_ac].bmh06
              DISPLAY g_bmh[l_ac].bmh06 TO bmh06
              NEXT FIELD bmh06
        # 080526  --------------end---------
           OTHERWISE EXIT CASE
         END  CASE
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmh05) AND l_ac > 1 THEN
                LET g_bmh[l_ac].* = g_bmh[l_ac-1].*
                NEXT FIELD bmh05
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
        CALL i618_b_tot()
        #no.6542
        CALL i618_chk_QPA()
        #no.6542(end)
     #MOD-4B0191
        IF NOT cl_null(g_errno) THEN
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
     #MOD-4B0191(end)
 
    CLOSE i618_bcl
    IF g_success = 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION i618_b_tot()
   SELECT SUM(bmh07) INTO tot
          FROM bmh_file
         WHERE bmh01 = g_bok.bok01 AND bmh09 = g_bok.bok31
           AND bmh10 = g_bok.bok32 
   IF cl_null(tot) THEN LET tot = 0 END IF
   DISPLAY BY NAME tot
END FUNCTION
 
FUNCTION i618_b_askkey()
DEFINE
    l_wc2       LIKE type_file.chr1000  #No.FUN-680096      VARCHAR(200)
 
# genero  script marked     IF g_bmh_sarrno = 0 THEN RETURN END IF
    CONSTRUCT g_wc2 ON bmh05,bmh06,bmh07
            FROM s_bmh[1].bmh05,s_bmh[1].bmh06,s_bmh[1].bmh07
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i618_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i618_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(200)
 
    LET g_sql =
       #---------No.MOD-760104 modify
       #"SELECT bmh05,bmh06,bmh07,bmh04",      #No.FUN-680015 modify
        "SELECT bmh05,bmh06,bmh07",      
       #---------No.MOD-760104 end
        " FROM bmh_file",
        " WHERE bmh01 ='",g_bok.bok01,"' AND bmh09 ='",g_bok.bok31,"'",
        "   AND bmh10 ='",g_bok.bok32,"'",  
       "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i618_pb FROM g_sql
    DECLARE bmh_curs CURSOR FOR i618_pb
 
    CALL g_bmh.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET tot = 0
    FOREACH bmh_curs INTO g_bmh[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET tot = tot + g_bmh[g_cnt].bmh07
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #CKP
    CALL g_bmh.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    DISPLAY BY NAME tot
END FUNCTION
 
#BugNo:4476
FUNCTION i618_up_bok13()
 DEFINE l_bmh06   LIKE bmh_file.bmh06,
        l_bok13   LIKE bok_file.bok13,
        l_i       LIKE type_file.num5,   #No.FUN-680096  SMALLINT,
        i,j       LIKE type_file.num5,   #No.MOD-6B0077 add
        p_ac      LIKE type_file.num5    #No.FUN-680096  SMALLINT
 
    LET l_bok13=' '
    LET l_i = 0
    DECLARE up_bok13_cs CURSOR FOR
     SELECT bmh06 FROM bmh_file
      WHERE bmh01=g_bok.bok01
        AND bmh09=g_bok.bok31
        AND bmh10=g_bok.bok32
 
    FOREACH up_bok13_cs INTO l_bmh06
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF l_i = 0 THEN
        LET l_bok13=l_bmh06
     ELSE
      #----------No.MOD-6B0077 modify
        IF (Length(l_bok13) + Length(l_bmh06)) > 8 THEN
           LET j = 10 - Length(l_bok13)
           FOR i=1 TO j
               LET l_bok13 = l_bok13 CLIPPED , '.'
           END FOR
           EXIT FOREACH
        ELSE
           LET l_bok13= l_bok13 CLIPPED , ',', l_bmh06
        END IF
      #----------No.MOD-6B0077 end
     END IF
     LET l_i = l_i + 1
    END FOREACH
    UPDATE bok_file
      SET bok13 = l_bok13
      WHERE bok01=g_bok.bok01
        AND bok31=g_bok.bok31
        AND bok32=g_bok.bok32
END FUNCTION
 
#no.6542
FUNCTION i618_chk_QPA()
 DEFINE l_i       LIKE type_file.num10  #No.FUN-680096  INTEGER
 DEFINE g_ima147  LIKE ima_file.ima147
 DEFINE g_qpa     LIKE bok_file.bok06   #FUN-550106 #FUN-560227
    LET g_errno = ''
    SELECT ima147 INTO g_ima147 FROM ima_file WHERE ima01=g_bok.bok03
    LET g_qpa = g_bok.bok06 / g_bok.bok07
    LET tot = 0
    FOR l_i = 1 TO g_bmh.getLength()
        IF cl_null(g_bmh[l_i].bmh07) THEN
            EXIT FOR
        END IF
        LET tot = tot + g_bmh[l_i].bmh07
    END FOR
    DISPLAY tot TO FORMONLY.tot
    LET g_errno = NULL
    IF g_ima147 = 'Y' AND (tot != g_qpa) THEN
       CALL cl_err(tot,'mfg2765',1)
       LET g_errno = 'mfg2765'
    END IF
END FUNCTION
#no.6542(end)
 
 
FUNCTION i618_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1      
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmh TO s_bmh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i618_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION previous
         CALL i618_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION jump
         CALL i618_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION next
         CALL i618_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION last
         CALL i618_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 工廠切換
      #--FUN-B10030--start--
      # ON ACTION switch_plant
      #   LET g_action_choice="switch_plant"
      #   EXIT DISPLAY
      #--FUN-B10030--end-- 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-870127 End
